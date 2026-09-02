#define RENODX_SKIP_SHARED_RENODX_HLSL 1
#include "../../shared.h"
#undef RENODX_SKIP_SHARED_RENODX_HLSL

// IS-FAST noise: 128x128x32 RG8_UNORM source decoded to float2 in a ByteAddressBuffer.
// Bound by the addon as a buffer SRV at t0/space50 to avoid descriptor-heap swaps.
ByteAddressBuffer FASTNoiseTexture : register(t0, space50);

static const uint RENODX_FAST_NOISE_W = 128u;
static const uint RENODX_FAST_NOISE_H = 128u;
static const uint RENODX_FAST_NOISE_SLICES = 32u;
static const uint RENODX_FAST_NOISE_SLICE_TEXELS = RENODX_FAST_NOISE_W * RENODX_FAST_NOISE_H;
static const uint RENODX_FAST_NOISE_ELEMENT_BYTES = 8u;

float2 RenoDX_FASTNoiseLoad(uint x, uint y, uint slice) {
  uint flat_index = ((slice & 31u) * RENODX_FAST_NOISE_SLICE_TEXELS) + ((y & 127u) * RENODX_FAST_NOISE_W) + (x & 127u);
  return asfloat(FASTNoiseTexture.Load2(flat_index * RENODX_FAST_NOISE_ELEMENT_BYTES));
}

float RenoDX_ISFASTShadowAngle(uint2 pixel, uint frame, uint seed) {
  float2 noise = RenoDX_FASTNoiseLoad(pixel.x + (seed * 37u), pixel.y + (seed * 17u), frame + (seed * 11u));
  return frac(noise.x + (noise.y * 0.6180339887498948f)) * 6.2831854820251465f;
}

struct S_cbSharedPerViewData {
  float4 mProjection[4][1];
  float4 mProjectionPrev[4][1];
  float4 mViewToViewport[4][1];
  float4 mViewToWorld[3][1];
  float4 mViewToWorldPrev[3][1];
  float4 mWorldToView[3];
  float4 mWorldToViewPrev[3];
  float4 mProjToWorld[4];
  float4 mFxWorldToSampleSpace[4];
  float4 mViewToGlobalShadowVSPT[4];
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
  float4 mCinematicVolumeWorldToObject[3];
  float3 vCinematicVolumeBoxHalfSize;
  uint nCinematicVolumeEnabled;
  float3 vCinematicVolumeBoxFadeNeg;
  uint nCinematicVolumeRemoveCSM;
  float3 vCinematicVolumeBoxFadePos;
  uint nPadCinematicVolume1;
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

SamplerComparisonState samplerLinearPCFBorderBlackNode : register(s13);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

groupshared uint _global_0;
groupshared uint _global_1;
groupshared uint _global_2;
groupshared uint _global_3[64];
groupshared uint _global_4[64];
groupshared uint _global_5[64];
groupshared uint _global_6[64];
static const float _global_7[128] = { 1.0f, 0.0f, -0.7373688817024231f, 0.6754903197288513f, 0.08742572367191315f, -0.9961710572242737f, 0.6084388494491577f, 0.7936007380485535f, -0.9847134947776794f, -0.1741819530725479f, 0.843755304813385f, -0.536728024482727f, -0.2596043050289154f, 0.9657150506973267f, -0.4609070122241974f, -0.8874484300613403f, 0.9393212795257568f, 0.3430386185646057f, -0.9243455529212952f, 0.3815564215183258f, 0.4238460063934326f, -0.9057343006134033f, 0.29928386211395264f, 0.9541641473770142f, -0.8652111887931824f, -0.5014075636863708f, 0.9766757488250732f, -0.21471942961215973f, -0.5751294493675232f, 0.818062424659729f, -0.12851068377494812f, -0.9917080998420715f, 0.764648973941803f, 0.6444469690322876f, -0.999146044254303f, 0.04131782799959183f, 0.708829402923584f, -0.7053799629211426f, -0.04619144648313522f, 0.9989326000213623f, -0.6407091617584229f, -0.7677837014198303f, 0.9910694360733032f, 0.13334698975086212f, -0.820858359336853f, 0.5711318254470825f, 0.21948136389255524f, -0.9756166934967041f, 0.49718087911605835f, 0.8676469326019287f, -0.9526928067207336f, -0.3039349913597107f, 0.9077911376953125f, -0.41942253708839417f, -0.38606107234954834f, 0.9224731922149658f, -0.3384522795677185f, -0.9409835338592529f, 0.885189414024353f, 0.4652307629585266f, -0.9669700264930725f, 0.25489020347595215f, 0.5408377647399902f, -0.8411269187927246f, 0.1693761795759201f, 0.9855514764785767f, -0.7906231880187988f, -0.6123030185699463f, 0.9965856671333313f, -0.08256508409976959f, -0.6790793538093567f, 0.7340648770332336f, 0.004878276959061623f, -0.9999880790710449f, 0.6718851923942566f, 0.7406553626060486f, -0.9957327246665955f, -0.09228428453207016f, 0.7965594530105591f, -0.6045601963996887f, -0.17898358404636383f, 0.9838520884513855f, -0.5326055884361267f, -0.8463635444641113f, 0.9644371867179871f, 0.2643122375011444f, -0.8896862864494324f, 0.4565723240375519f, 0.3476168215274811f, -0.93763667345047f, 0.37704265117645264f, 0.9261959195137024f, -0.9036558866500854f, -0.42825937271118164f, 0.9556127786636353f, -0.2946256399154663f, -0.5056223273277283f, 0.8627548813819885f, -0.20995238423347473f, -0.9777116179466248f, 0.8152470588684082f, 0.5791133046150208f, -0.9923232197761536f, 0.12367133051156998f, 0.6481694579124451f, -0.7614961266517639f, 0.03644322231411934f, 0.9993357062339783f, -0.7019136548042297f, -0.7122620344161987f, 0.9986953735351562f, 0.05106396600604057f, -0.7709001302719116f, 0.6369560360908508f, 0.13818010687828064f, -0.9904071092605591f, 0.5671206712722778f, 0.823634684085846f, -0.9745343923568726f, -0.2242380827665329f, 0.870061993598938f, -0.49294233322143555f, -0.30857884883880615f, 0.9511987566947937f, -0.41498908400535583f, -0.909826397895813f, 0.9205789566040039f, 0.39055657386779785f };

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  uint _54;
  int _60;
  uint _65;
  uint _66;
  uint _73;
  int _76;
  int _91;
  float _268;
  float _269;
  float _270;
  float _271;
  float _361;
  float _362;
  float _400;
  int _439;
  float _440;
  float _441;
  float _442;
  int _561;
  float _562;
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
  float _690;
  float _691;
  float _692;
  float _779;
  float _780;
  float _781;
  float _799;
  float _800;
  float _801;
  float _833;
  float _834;
  float _835;
  float _836;
  float _837;
  float _838;
  float _839;
  float _853;
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
  float _871;
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
  float _933;
  float _934;
  float _935;
  float _955;
  float _956;
  float _957;
  float _968;
  float _969;
  float _970;
  float _971;
  float _972;
  float _973;
  float _976;
  float _977;
  float _978;
  float _979;
  float _980;
  float _981;
  float _982;
  float _996;
  float _997;
  float _998;
  float _999;
  float _1000;
  float _1001;
  float _1030;
  float _1031;
  float _1032;
  float _1052;
  float _1053;
  float _1054;
  float _1065;
  float _1066;
  float _1067;
  float _1068;
  float _1069;
  float _1070;
  float _1089;
  float _1090;
  float _1091;
  float _1092;
  float _1093;
  float _1094;
  float _1113;
  float _1114;
  float _1115;
  int _1156;
  float _1157;
  float _1275;
  float _1280;
  float _1310;
  float _1367;
  float _1383;
  float _1436;
  float _1437;
  float _1438;
  float _1491;
  float _1492;
  float _1493;
  float _1603;
  float _1608;
  float _1609;
  float _1610;
  float _1611;
  float _1612;
  float _1613;
  int _1614;
  float _2285;
  float _2286;
  float _2287;
  float _2288;
  float _2378;
  float _2387;
  float _2396;
  float _2404;
  float _2475;
  float _2484;
  float _2493;
  float _2501;
  float _2574;
  float _2583;
  float _2592;
  float _2600;
  float _2673;
  float _2682;
  float _2691;
  float _2699;
  float _2751;
  float _2756;
  float _2757;
  float _2758;
  float _2855;
  float _2856;
  float _2857;
  float _2878;
  float _2879;
  float _2880;
  int _2899;
  float _2916;
  float _2920;
  float _2936;
  float _2937;
  float _2938;
  float _2974;
  float _3006;
  float _3116;
  float _3117;
  float _3129;
  float _3141;
  float _3212;
  float _3213;
  float _3214;
  float _3222;
  int _3307;
  float _3358;
  float _3359;
  float _3360;
  float _3361;
  float _3362;
  float _3363;
  int _3364;
  bool _3391;
  bool _3393;
  float _3416;
  float _3417;
  float _3418;
  float _3438;
  float _3439;
  float _3440;
  float _3469;
  float _3579;
  float _3580;
  float _3592;
  float _3604;
  float _3666;
  float _3667;
  float _3668;
  float _3699;
  float _3728;
  float _3729;
  float _3730;
  float _3746;
  float _3747;
  float _3748;
  float _3761;
  float _3762;
  float _3763;
  float _3932;
  float _3933;
  float _3934;
  float _3935;
  float _3936;
  float _3937;
  float _3938;
  float _3939;
  float _4031;
  float _4032;
  float _4033;
  float _4034;
  float _4035;
  float _4138;
  float _4147;
  float _4156;
  float _4164;
  float _4235;
  float _4244;
  float _4253;
  float _4261;
  float _4334;
  float _4343;
  float _4352;
  float _4360;
  float _4433;
  float _4442;
  float _4451;
  float _4459;
  float _4848;
  float _4849;
  float _4850;
  int _4851;
  float _4852;
  float _4881;
  float _4882;
  float _4883;
  float _4884;
  float _4885;
  float _4987;
  float _4996;
  float _5005;
  float _5013;
  float _5084;
  float _5093;
  float _5102;
  float _5110;
  float _5183;
  float _5192;
  float _5201;
  float _5209;
  float _5282;
  float _5291;
  float _5300;
  float _5308;
  float _5642;
  float _5643;
  bool _5644;
  float _5659;
  float _5660;
  float _5661;
  float _5720;
  float _5721;
  float _5746;
  float _5747;
  float _5842;
  float _5845;
  float _5846;
  float _5847;
  float _5848;
  float _5868;
  float _5869;
  float _5870;
  int _5888;
  float _5905;
  float _5909;
  float _5924;
  float _5925;
  float _5926;
  float _5949;
  float _5950;
  float _5951;
  float _5982;
  float _6011;
  float _6012;
  float _6013;
  float _6029;
  float _6030;
  float _6031;
  float _6032;
  float _6033;
  float _6034;
  float _6070;
  float _6118;
  float _6119;
  float _6120;
  float _6136;
  float _6196;
  float _6197;
  float _6198;
  float _6319;
  float _6320;
  float _6333;
  float _6345;
  float _6346;
  float _6366;
  float _6439;
  float _6440;
  float _6441;
  float _6562;
  float _7192;
  float _7193;
  float _7194;
  float _7195;
  float _7285;
  float _7294;
  float _7303;
  float _7311;
  float _7382;
  float _7391;
  float _7400;
  float _7408;
  float _7481;
  float _7490;
  float _7499;
  float _7507;
  float _7580;
  float _7589;
  float _7598;
  float _7606;
  float _7658;
  float _7663;
  float _7664;
  float _7665;
  float _7762;
  float _7763;
  float _7764;
  float _7785;
  float _7786;
  float _7787;
  int _7806;
  float _7823;
  float _7831;
  float _7846;
  float _7847;
  float _7848;
  float _7871;
  float _7872;
  float _7873;
  float _7904;
  float _7933;
  float _7934;
  float _7935;
  float _7951;
  float _7952;
  float _7953;
  float _7954;
  float _7955;
  float _7956;
  float _7992;
  float _8040;
  float _8041;
  float _8042;
  float _8058;
  float _8118;
  float _8119;
  float _8120;
  float _8241;
  float _8242;
  float _8255;
  float _8267;
  float _8268;
  float _8288;
  float _8361;
  float _8362;
  float _8363;
  float _8494;
  float _8495;
  float _8519;
  float _8520;
  float _8545;
  float _8546;
  float _8571;
  float _8572;
  float _8715;
  float _8716;
  float _8717;
  float _8741;
  float _8832;
  float _8833;
  float _8834;
  float _8848;
  float _8849;
  float _8850;
  float _8851;
  float _8852;
  float _8853;
  float _8858;
  float _8859;
  float _8860;
  float _8861;
  float _8862;
  float _8863;
  float _9012;
  float _9013;
  float _9014;
  float _9023;
  float _9024;
  float _9025;
  float _9026;
  float _9027;
  float _9028;
  float _9029;
  float _9030;
  float _9031;
  int _87;
  uint _93;
  int _100;
  int _105;
  int _108;
  int _110;
  int _112;
  int _114;
  float4 _119;
  float _127;
  float _128;
  float _136;
  float _137;
  float4 _140;
  float4 _144;
  float4 _150;
  float4 _154;
  float _161;
  float _162;
  float _163;
  float _168;
  float _173;
  float _174;
  float _178;
  float _180;
  float _181;
  float _186;
  float _187;
  float _189;
  float _190;
  float _191;
  float _192;
  int _196;
  float _202;
  float _203;
  float _210;
  float _211;
  float _212;
  float _218;
  float _222;
  float _228;
  float _229;
  float _230;
  float _231;
  bool _233;
  int _234;
  int _240;
  uint _244;
  float _250;
  float4 _259;
  float _280;
  float _281;
  float _296;
  float _297;
  float _300;
  float _301;
  float _304;
  float _305;
  float4 _310;
  float _344;
  float _346;
  bool _347;
  float _349;
  float _351;
  bool _352;
  float4 _365;
  float _369;
  float _381;
  float _382;
  float _383;
  float _384;
  float _385;
  float _386;
  bool _389;
  bool _404;
  int _405;
  float2 _408;
  float _413;
  float _414;
  float _418;
  float _420;
  float _421;
  float _426;
  float _427;
  float _429;
  float _430;
  float _431;
  float _432;
  float _434;
  float _443;
  float _447;
  float _448;
  float _450;
  float _451;
  float _452;
  int _460;
  int _461;
  int _462;
  int _463;
  float _467;
  float _469;
  float _470;
  float _480;
  float _485;
  float _489;
  float _490;
  float _493;
  float _506;
  float _507;
  float _508;
  float _512;
  float _527;
  float _530;
  float _533;
  float _536;
  float _539;
  float _542;
  int _578;
  int _579;
  float _582;
  float _583;
  float _584;
  float _585;
  float _588;
  float _589;
  float _590;
  float _591;
  float _594;
  float _595;
  float _596;
  float _597;
  float _600;
  float _601;
  float _602;
  float _603;
  float _606;
  float _607;
  float _608;
  float _609;
  float _612;
  float _613;
  float _614;
  float _615;
  int _618;
  float _621;
  float _622;
  float _623;
  float _626;
  float _627;
  float _628;
  int _631;
  int _634;
  int _637;
  float _666;
  float _669;
  float _672;
  float _673;
  float4 _679;
  float4 _685;
  float _694;
  float _698;
  float _701;
  float _704;
  float _745;
  float _750;
  float _752;
  float _754;
  float _761;
  float _762;
  float4 _768;
  float4 _774;
  float _782;
  float4 _788;
  float4 _794;
  float _811;
  float _812;
  float _813;
  float _814;
  float _815;
  float _816;
  float _817;
  float _818;
  float _819;
  uint _867;
  bool _890;
  int _900;
  float _902;
  float _903;
  float _910;
  float _915;
  float _916;
  bool _917;
  float4 _922;
  float4 _928;
  float _939;
  float4 _944;
  float4 _950;
  float _988;
  int _1008;
  float _1009;
  float _1012;
  float _1013;
  bool _1014;
  float4 _1019;
  float4 _1025;
  float _1036;
  float4 _1041;
  float4 _1047;
  float _1075;
  float _1128;
  float4 _1131;
  float _1134;
  float _1135;
  float _1139;
  float _1143;
  float _1144;
  float _1145;
  float _1152;
  uint _1158;
  int _1161;
  int _1162;
  int _1166;
  int _1170;
  float _1182;
  float _1187;
  float _1188;
  float _1189;
  float _1190;
  float _1193;
  float _1194;
  float _1195;
  float _1196;
  float _1199;
  float _1200;
  float _1201;
  float _1202;
  int _1205;
  int _1208;
  int _1211;
  int _1214;
  float _1229;
  float _1233;
  float _1237;
  float _1262;
  float _1263;
  float _1264;
  float _1267;
  uint _1276;
  float _1284;
  float _1291;
  float _1292;
  float _1293;
  float _1294;
  bool _1298;
  float _1313;
  float _1315;
  float _1316;
  float _1317;
  float _1318;
  float _1323;
  float _1324;
  float _1325;
  float _1326;
  float _1328;
  float _1337;
  float _1338;
  float _1343;
  float _1349;
  float _1357;
  float _1370;
  float _1373;
  float _1376;
  int _1386;
  int _1389;
  int _1390;
  int _1391;
  int _1397;
  int _1398;
  int _1399;
  int _1405;
  int _1406;
  int _1407;
  float _1413;
  float _1417;
  float _1421;
  float _1428;
  int _1441;
  int _1444;
  int _1445;
  int _1446;
  int _1452;
  int _1453;
  int _1454;
  int _1460;
  int _1461;
  int _1462;
  float _1468;
  float _1472;
  float _1476;
  float _1483;
  float _1516;
  float _1520;
  float _1524;
  float _1543;
  float _1547;
  float _1551;
  float _1564;
  float _1565;
  float _1566;
  uint _1604;
  int _1616;
  int _1620;
  int _1621;
  int _1622;
  int _1623;
  int _1635;
  int _1639;
  float _1651;
  int _1654;
  float _1671;
  float _1676;
  float _1677;
  float _1678;
  float _1679;
  float _1682;
  float _1683;
  float _1684;
  float _1685;
  float _1688;
  float _1689;
  float _1690;
  float _1691;
  int _1694;
  int _1697;
  int _1700;
  int _1703;
  int _1706;
  float _1708;
  float _1709;
  float _1711;
  float _1715;
  float _1728;
  float _1732;
  float _1736;
  float _1761;
  float _1762;
  float _1763;
  float _1766;
  float _1767;
  float _1774;
  float _1795;
  float _1796;
  float _1797;
  float _1798;
  float _1801;
  float _1802;
  float _1803;
  float _1804;
  float _1807;
  float _1808;
  float _1809;
  float _1810;
  float _1813;
  float _1814;
  float _1815;
  float _1818;
  int _1821;
  int _1824;
  int _1827;
  int _1830;
  int _1833;
  float _1836;
  float _1837;
  float _1838;
  float _1839;
  int _1842;
  int _1845;
  int _1848;
  int _1851;
  int _1854;
  int _1857;
  int _1860;
  int _1863;
  float _1865;
  float _1866;
  float _1868;
  float _1872;
  float _1875;
  float _1877;
  int _1880;
  float _1890;
  float _1891;
  float _1893;
  float _1894;
  float _1895;
  float _1896;
  float _1915;
  float _1919;
  float _1920;
  float _1921;
  float _1925;
  float _1929;
  float _1933;
  float _1934;
  float _1957;
  float _1958;
  float _1959;
  float _1962;
  float _1963;
  bool _1965;
  float _1970;
  float _1971;
  float _1972;
  float _1977;
  float _1979;
  float _1980;
  float _1983;
  float _1987;
  float _1996;
  float _1997;
  float _1998;
  int _1999;
  float _2004;
  float _2013;
  float _2014;
  float _2016;
  float4 _2021;
  float _2026;
  float _2028;
  float _2030;
  float _2032;
  float _2036;
  float _2038;
  float _2042;
  float _2044;
  int _2051;
  float _2056;
  float _2065;
  float _2066;
  float4 _2072;
  float _2077;
  float _2079;
  float _2083;
  float _2085;
  float _2089;
  float _2091;
  float _2095;
  float _2097;
  int _2104;
  float _2109;
  float _2118;
  float _2119;
  float4 _2125;
  float _2130;
  float _2132;
  float _2136;
  float _2138;
  float _2142;
  float _2144;
  float _2148;
  float _2150;
  int _2157;
  float _2162;
  float _2171;
  float _2172;
  float4 _2178;
  float _2183;
  float _2185;
  float _2189;
  float _2191;
  float _2195;
  float _2197;
  float _2201;
  float _2203;
  float _2204;
  float _2215;
  float _2221;
  float _2223;
  float _2225;
  float _2232;
  float _2237;
  float _2238;
  float _2239;
  float _2240;
  float4 _2242;
  float _2250;
  float _2251;
  float4 _2252;
  float _2257;
  float _2262;
  float4 _2263;
  float _2268;
  float4 _2273;
  float _2282;
  float _2291;
  float _2292;
  float _2301;
  float _2305;
  float _2314;
  float _2315;
  float _2316;
  float _2321;
  int _2322;
  float _2327;
  float _2336;
  float _2337;
  float _2339;
  float _2341;
  float _2342;
  float4 _2344;
  float _2348;
  float _2349;
  float _2352;
  float _2353;
  float _2358;
  float _2359;
  float _2362;
  float _2363;
  float _2365;
  float _2367;
  bool _2368;
  bool _2369;
  bool _2379;
  bool _2388;
  float _2405;
  float _2407;
  float _2409;
  float _2411;
  float _2415;
  float _2417;
  float _2421;
  float _2423;
  int _2430;
  float _2435;
  float _2444;
  float _2445;
  float _2448;
  float _2449;
  float4 _2451;
  float _2455;
  float _2456;
  float _2459;
  float _2460;
  float _2462;
  float _2464;
  bool _2465;
  bool _2466;
  bool _2476;
  bool _2485;
  float _2502;
  float _2504;
  float _2508;
  float _2510;
  float _2514;
  float _2516;
  float _2520;
  float _2522;
  int _2529;
  float _2534;
  float _2543;
  float _2544;
  float _2547;
  float _2548;
  float4 _2550;
  float _2554;
  float _2555;
  float _2558;
  float _2559;
  float _2561;
  float _2563;
  bool _2564;
  bool _2565;
  bool _2575;
  bool _2584;
  float _2601;
  float _2603;
  float _2607;
  float _2609;
  float _2613;
  float _2615;
  float _2619;
  float _2621;
  int _2628;
  float _2633;
  float _2642;
  float _2643;
  float _2646;
  float _2647;
  float4 _2649;
  float _2653;
  float _2654;
  float _2657;
  float _2658;
  float _2660;
  float _2662;
  bool _2663;
  bool _2664;
  bool _2674;
  bool _2683;
  float _2700;
  float _2702;
  float _2706;
  float _2708;
  float _2712;
  float _2714;
  float _2718;
  float _2720;
  float _2721;
  float _2732;
  float _2738;
  float _2740;
  float _2742;
  float _2764;
  float4 _2771;
  float _2785;
  float _2786;
  float _2787;
  float _2788;
  float _2790;
  float _2795;
  float _2798;
  float _2799;
  float _2801;
  float _2802;
  float _2807;
  float _2812;
  float _2814;
  float _2817;
  float _2818;
  float _2823;
  float _2825;
  float _2827;
  float _2829;
  float _2834;
  float _2840;
  float _2842;
  float3 _2870;
  float _2881;
  float4 _2902;
  float _2931;
  int _2945;
  int _2950;
  int _2952;
  int _2953;
  int _2955;
  int _2956;
  int _2965;
  bool _2978;
  float _2981;
  float _2983;
  float _2984;
  float _2985;
  float _2986;
  float _2987;
  float _2988;
  float _2996;
  float _3001;
  float _3007;
  float _3011;
  float _3013;
  float _3014;
  float _3015;
  float _3018;
  bool _3025;
  float _3029;
  float _3031;
  float _3032;
  float _3040;
  float _3043;
  float _3044;
  float _3049;
  float _3058;
  float _3059;
  float _3062;
  float _3064;
  float _3065;
  float _3066;
  float _3068;
  float _3069;
  float _3070;
  float _3071;
  float _3076;
  float _3090;
  float _3095;
  float _3096;
  float _3098;
  float _3104;
  float _3107;
  float _3118;
  float _3119;
  float _3130;
  float _3145;
  float _3152;
  float _3155;
  float _3156;
  float _3168;
  float _3171;
  float _3172;
  float _3173;
  float _3174;
  float _3195;
  float _3225;
  float _3226;
  float _3227;
  float _3228;
  float _3231;
  float _3232;
  float _3233;
  float _3234;
  float _3237;
  float _3238;
  float _3239;
  float _3240;
  float _3243;
  float _3244;
  float _3245;
  int _3248;
  int _3251;
  int _3254;
  int _3257;
  int _3260;
  int _3263;
  float _3266;
  float _3270;
  float _3272;
  int _3274;
  float _3288;
  float _3292;
  float2 _3298;
  int _3303;
  int _3310;
  int _3322;
  float _3325;
  float _3326;
  float _3327;
  float _3330;
  float _3331;
  float _3332;
  float _3335;
  float _3336;
  float _3337;
  float _3338;
  float _3339;
  float _3340;
  int _3343;
  float _3345;
  float _3346;
  float _3347;
  float _3348;
  float _3349;
  float _3350;
  int _3353;
  uint _3388;
  float3 _3408;
  float _3427;
  float _3443;
  float _3446;
  float _3447;
  float _3448;
  float _3449;
  float _3450;
  float _3451;
  float _3459;
  float _3464;
  float _3470;
  float _3474;
  float _3476;
  float _3477;
  float _3478;
  float _3481;
  bool _3488;
  float _3492;
  float _3494;
  float _3495;
  float _3503;
  float _3506;
  float _3507;
  float _3512;
  float _3521;
  float _3522;
  float _3525;
  float _3527;
  float _3528;
  float _3529;
  float _3531;
  float _3532;
  float _3533;
  float _3534;
  float _3539;
  float _3553;
  float _3558;
  float _3559;
  float _3561;
  float _3567;
  float _3570;
  float _3581;
  float _3582;
  float _3593;
  float _3608;
  float _3618;
  float _3627;
  float _3628;
  float _3640;
  float _3643;
  float _3656;
  bool _3669;
  float _3670;
  float _3671;
  float _3672;
  bool _3673;
  float _3675;
  float _3676;
  float _3680;
  float _3686;
  float _3700;
  float _3701;
  float _3704;
  float _3708;
  int _3709;
  float _3711;
  float _3713;
  float _3716;
  float _3720;
  float _3731;
  float _3732;
  float _3733;
  float _3735;
  float _3749;
  float _3750;
  float _3751;
  float _3767;
  float _3768;
  float _3769;
  float _3772;
  float _3793;
  float _3794;
  float _3795;
  float _3798;
  float _3799;
  float _3800;
  float _3803;
  float _3804;
  float _3805;
  float _3808;
  float _3809;
  float _3810;
  float _3813;
  float _3814;
  float _3815;
  int _3818;
  int _3821;
  int _3824;
  int _3827;
  int _3830;
  int _3833;
  int _3836;
  int _3839;
  int _3842;
  int _3845;
  int _3848;
  float _3851;
  float _3852;
  float _3853;
  float _3854;
  int _3857;
  int _3860;
  int _3863;
  int _3866;
  float _3868;
  float _3869;
  float _3871;
  float _3875;
  float _3878;
  float _3879;
  float _3881;
  float _3885;
  float _3887;
  float _3888;
  float _3890;
  float _3891;
  int _3893;
  bool _3897;
  float _3905;
  float _3906;
  float _3908;
  float _3911;
  float _3912;
  float _3914;
  float _3915;
  float _3917;
  float _3918;
  float _3922;
  float _3928;
  float _3929;
  float _3930;
  float _3943;
  float _3944;
  float _3945;
  float _3946;
  float _3947;
  float _3948;
  float _3949;
  float _3950;
  float _3951;
  float _3954;
  float _3955;
  float _3956;
  float _3959;
  float _3966;
  float _3979;
  float _3983;
  float _3987;
  float _3988;
  float _3989;
  float _3992;
  float _3995;
  bool _3997;
  float _4003;
  float _4004;
  float _4005;
  float _4010;
  float _4011;
  float _4012;
  bool _4016;
  bool _4022;
  bool _4026;
  float _4036;
  float _4041;
  float _4050;
  float _4051;
  float _4052;
  float _4057;
  float _4058;
  float _4061;
  float _4065;
  float _4074;
  float _4075;
  float _4076;
  float _4081;
  int _4082;
  float _4087;
  float _4096;
  float _4097;
  float _4099;
  float _4101;
  float _4102;
  float4 _4104;
  float _4108;
  float _4109;
  float _4112;
  float _4113;
  float _4118;
  float _4119;
  float _4122;
  float _4123;
  float _4125;
  float _4127;
  bool _4128;
  bool _4129;
  bool _4139;
  bool _4148;
  float _4165;
  float _4167;
  float _4169;
  float _4171;
  float _4175;
  float _4177;
  float _4181;
  float _4183;
  int _4190;
  float _4195;
  float _4204;
  float _4205;
  float _4208;
  float _4209;
  float4 _4211;
  float _4215;
  float _4216;
  float _4219;
  float _4220;
  float _4222;
  float _4224;
  bool _4225;
  bool _4226;
  bool _4236;
  bool _4245;
  float _4262;
  float _4264;
  float _4268;
  float _4270;
  float _4274;
  float _4276;
  float _4280;
  float _4282;
  int _4289;
  float _4294;
  float _4303;
  float _4304;
  float _4307;
  float _4308;
  float4 _4310;
  float _4314;
  float _4315;
  float _4318;
  float _4319;
  float _4321;
  float _4323;
  bool _4324;
  bool _4325;
  bool _4335;
  bool _4344;
  float _4361;
  float _4363;
  float _4367;
  float _4369;
  float _4373;
  float _4375;
  float _4379;
  float _4381;
  int _4388;
  float _4393;
  float _4402;
  float _4403;
  float _4406;
  float _4407;
  float4 _4409;
  float _4413;
  float _4414;
  float _4417;
  float _4418;
  float _4420;
  float _4422;
  bool _4423;
  bool _4424;
  bool _4434;
  bool _4443;
  float _4460;
  float _4462;
  float _4466;
  float _4468;
  float _4472;
  float _4474;
  float _4478;
  float _4480;
  float _4481;
  float _4492;
  float _4498;
  float _4500;
  float _4502;
  float _4514;
  float _4517;
  float _4518;
  float _4521;
  float _4532;
  float _4533;
  float _4534;
  float _4538;
  float _4547;
  float _4548;
  float _4549;
  int _4550;
  float _4555;
  float _4564;
  float _4565;
  float _4567;
  float4 _4572;
  float _4577;
  float _4579;
  float _4581;
  float _4583;
  float _4587;
  float _4589;
  float _4593;
  float _4595;
  int _4602;
  float _4607;
  float _4616;
  float _4617;
  float4 _4623;
  float _4628;
  float _4630;
  float _4634;
  float _4636;
  float _4640;
  float _4642;
  float _4646;
  float _4648;
  int _4655;
  float _4660;
  float _4669;
  float _4670;
  float4 _4676;
  float _4681;
  float _4683;
  float _4687;
  float _4689;
  float _4693;
  float _4695;
  float _4699;
  float _4701;
  int _4708;
  float _4713;
  float _4722;
  float _4723;
  float4 _4729;
  float _4734;
  float _4736;
  float _4740;
  float _4742;
  float _4746;
  float _4748;
  float _4752;
  float _4754;
  float _4755;
  float _4766;
  float _4772;
  float _4774;
  float _4776;
  float _4784;
  float _4791;
  float _4793;
  float _4800;
  float _4801;
  float _4802;
  float _4803;
  float4 _4805;
  float _4814;
  float4 _4815;
  float _4820;
  float _4826;
  float4 _4827;
  float _4832;
  float4 _4837;
  float _4860;
  float _4861;
  float _4862;
  bool _4866;
  bool _4872;
  bool _4876;
  float _4886;
  float _4891;
  float _4900;
  float _4901;
  float _4906;
  float _4907;
  float _4910;
  float _4914;
  float _4923;
  float _4924;
  float _4925;
  float _4930;
  int _4931;
  float _4936;
  float _4945;
  float _4946;
  float _4948;
  float _4950;
  float _4951;
  float4 _4953;
  float _4957;
  float _4958;
  float _4961;
  float _4962;
  float _4967;
  float _4968;
  float _4971;
  float _4972;
  float _4974;
  float _4976;
  bool _4977;
  bool _4978;
  bool _4988;
  bool _4997;
  float _5014;
  float _5016;
  float _5018;
  float _5020;
  float _5024;
  float _5026;
  float _5030;
  float _5032;
  int _5039;
  float _5044;
  float _5053;
  float _5054;
  float _5057;
  float _5058;
  float4 _5060;
  float _5064;
  float _5065;
  float _5068;
  float _5069;
  float _5071;
  float _5073;
  bool _5074;
  bool _5075;
  bool _5085;
  bool _5094;
  float _5111;
  float _5113;
  float _5117;
  float _5119;
  float _5123;
  float _5125;
  float _5129;
  float _5131;
  int _5138;
  float _5143;
  float _5152;
  float _5153;
  float _5156;
  float _5157;
  float4 _5159;
  float _5163;
  float _5164;
  float _5167;
  float _5168;
  float _5170;
  float _5172;
  bool _5173;
  bool _5174;
  bool _5184;
  bool _5193;
  float _5210;
  float _5212;
  float _5216;
  float _5218;
  float _5222;
  float _5224;
  float _5228;
  float _5230;
  int _5237;
  float _5242;
  float _5251;
  float _5252;
  float _5255;
  float _5256;
  float4 _5258;
  float _5262;
  float _5263;
  float _5266;
  float _5267;
  float _5269;
  float _5271;
  bool _5272;
  bool _5273;
  bool _5283;
  bool _5292;
  float _5309;
  float _5311;
  float _5315;
  float _5317;
  float _5321;
  float _5323;
  float _5327;
  float _5329;
  float _5330;
  float _5341;
  float _5347;
  float _5349;
  float _5351;
  float _5360;
  float _5363;
  float _5364;
  float _5377;
  float _5378;
  float _5379;
  float _5383;
  float _5392;
  float _5393;
  float _5394;
  int _5395;
  float _5400;
  float _5409;
  float _5410;
  float _5412;
  float4 _5417;
  float _5422;
  float _5424;
  float _5426;
  float _5428;
  float _5432;
  float _5434;
  float _5438;
  float _5440;
  int _5447;
  float _5452;
  float _5461;
  float _5462;
  float4 _5468;
  float _5473;
  float _5475;
  float _5479;
  float _5481;
  float _5485;
  float _5487;
  float _5491;
  float _5493;
  int _5500;
  float _5505;
  float _5514;
  float _5515;
  float4 _5521;
  float _5526;
  float _5528;
  float _5532;
  float _5534;
  float _5538;
  float _5540;
  float _5544;
  float _5546;
  int _5553;
  float _5558;
  float _5567;
  float _5568;
  float4 _5574;
  float _5579;
  float _5581;
  float _5585;
  float _5587;
  float _5591;
  float _5593;
  float _5597;
  float _5599;
  float _5600;
  float _5611;
  float _5617;
  float _5619;
  float _5621;
  float _5629;
  float _5636;
  float _5638;
  float _5664;
  float _5667;
  float _5668;
  float _5669;
  float _5684;
  float _5687;
  float _5690;
  float _5692;
  float _5693;
  float _5694;
  float _5695;
  float _5703;
  float _5704;
  float _5705;
  bool _5707;
  float _5727;
  float4 _5752;
  float _5772;
  float _5773;
  float _5774;
  float _5775;
  float _5777;
  float _5782;
  float _5785;
  float _5786;
  float _5788;
  float _5789;
  float _5794;
  float _5799;
  float _5801;
  float _5804;
  float _5805;
  float _5810;
  float _5812;
  float _5814;
  float _5816;
  float _5821;
  float _5827;
  float _5829;
  float3 _5860;
  float4 _5891;
  float _5919;
  float _5939;
  bool _5952;
  float _5953;
  float _5954;
  float _5955;
  bool _5956;
  float _5958;
  float _5959;
  float _5963;
  float _5969;
  float _5983;
  float _5984;
  float _5987;
  float _5991;
  int _5992;
  float _5994;
  float _5996;
  float _5999;
  float _6003;
  float _6014;
  float _6015;
  float _6016;
  float _6018;
  int _6041;
  int _6046;
  int _6048;
  int _6049;
  int _6051;
  int _6052;
  int _6061;
  bool _6074;
  float _6077;
  float _6079;
  float _6080;
  float _6081;
  float _6082;
  float _6083;
  float _6084;
  float _6085;
  float _6086;
  float _6087;
  float _6088;
  float _6089;
  float _6090;
  bool _6091;
  float _6092;
  float _6093;
  float _6096;
  float _6097;
  float _6099;
  float _6126;
  float _6131;
  float _6138;
  float _6139;
  float _6140;
  float _6142;
  float _6146;
  float _6147;
  float _6148;
  float _6149;
  float _6150;
  float _6151;
  float _6152;
  float _6158;
  float _6167;
  float _6171;
  float _6172;
  float _6173;
  float _6174;
  float _6178;
  float _6179;
  float _6180;
  float _6188;
  float _6200;
  float _6201;
  float _6202;
  float _6203;
  float _6204;
  float _6208;
  float _6210;
  float _6212;
  float _6216;
  float _6217;
  float _6218;
  float _6221;
  bool _6228;
  float _6232;
  float _6234;
  float _6235;
  float _6243;
  float _6246;
  float _6247;
  float _6252;
  float _6261;
  float _6262;
  float _6265;
  float _6267;
  float _6268;
  float _6269;
  float _6271;
  float _6272;
  float _6273;
  float _6274;
  float _6279;
  float _6293;
  float _6298;
  float _6299;
  float _6301;
  float _6307;
  float _6310;
  float _6321;
  float _6323;
  float _6342;
  float _6353;
  float _6370;
  float _6377;
  float _6380;
  float _6381;
  float _6382;
  float _6394;
  float _6397;
  float _6398;
  float _6399;
  float _6400;
  float _6422;
  float _6453;
  float _6454;
  float _6455;
  float _6458;
  float _6459;
  float _6460;
  float _6463;
  int _6466;
  int _6469;
  int _6472;
  float _6481;
  float _6484;
  float _6487;
  float _6494;
  float _6499;
  float _6501;
  float _6503;
  float _6504;
  float _6505;
  float _6507;
  float _6508;
  float _6509;
  float _6512;
  float _6513;
  float _6514;
  float _6517;
  float _6524;
  int _6533;
  int _6538;
  int _6540;
  int _6541;
  int _6543;
  int _6544;
  int _6553;
  bool _6566;
  float _6568;
  float _6569;
  float _6570;
  float _6571;
  float _6574;
  float _6577;
  float _6581;
  float _6582;
  float _6583;
  float _6587;
  float _6594;
  float _6597;
  float _6598;
  float _6599;
  float _6611;
  float _6613;
  float _6614;
  float _6615;
  float _6616;
  float _6623;
  float _6624;
  float _6625;
  float _6640;
  float _6661;
  float _6662;
  float _6663;
  float _6666;
  float _6667;
  float _6668;
  float _6671;
  float _6672;
  float _6673;
  float _6676;
  float _6677;
  float _6678;
  float _6681;
  float _6682;
  float _6683;
  float _6686;
  float _6687;
  float _6688;
  int _6691;
  int _6694;
  int _6697;
  int _6700;
  float _6703;
  float _6704;
  float _6705;
  float _6706;
  int _6709;
  int _6712;
  int _6715;
  int _6718;
  int _6721;
  int _6724;
  int _6727;
  float _6730;
  float _6731;
  float _6732;
  float _6733;
  int _6736;
  int _6739;
  int _6742;
  float _6744;
  float _6745;
  float _6747;
  float _6751;
  float _6754;
  float _6755;
  float _6757;
  float _6761;
  int _6765;
  bool _6771;
  float _6782;
  float _6783;
  float _6785;
  float _6786;
  float _6787;
  float _6788;
  float _6789;
  float _6790;
  float _6791;
  float _6792;
  float _6793;
  float _6794;
  float _6795;
  float _6796;
  float _6797;
  float _6800;
  float _6801;
  float _6802;
  float _6805;
  float _6816;
  float _6820;
  float _6827;
  float _6828;
  float _6829;
  float _6841;
  float _6842;
  float _6843;
  float _6844;
  float _6847;
  float _6848;
  float _6851;
  float _6852;
  float _6859;
  float _6861;
  float _6867;
  float _6877;
  float _6878;
  float _6879;
  float _6884;
  float _6886;
  float _6887;
  float _6890;
  float _6894;
  float _6903;
  float _6904;
  float _6905;
  int _6906;
  float _6911;
  float _6920;
  float _6921;
  float _6923;
  float4 _6928;
  float _6933;
  float _6935;
  float _6937;
  float _6939;
  float _6943;
  float _6945;
  float _6949;
  float _6951;
  int _6958;
  float _6963;
  float _6972;
  float _6973;
  float4 _6979;
  float _6984;
  float _6986;
  float _6990;
  float _6992;
  float _6996;
  float _6998;
  float _7002;
  float _7004;
  int _7011;
  float _7016;
  float _7025;
  float _7026;
  float4 _7032;
  float _7037;
  float _7039;
  float _7043;
  float _7045;
  float _7049;
  float _7051;
  float _7055;
  float _7057;
  int _7064;
  float _7069;
  float _7078;
  float _7079;
  float4 _7085;
  float _7090;
  float _7092;
  float _7096;
  float _7098;
  float _7102;
  float _7104;
  float _7108;
  float _7110;
  float _7111;
  float _7122;
  float _7128;
  float _7130;
  float _7132;
  float _7139;
  float _7144;
  float _7145;
  float _7146;
  float _7147;
  float4 _7149;
  float _7157;
  float _7158;
  float4 _7159;
  float _7164;
  float _7169;
  float4 _7170;
  float _7175;
  float4 _7180;
  float _7189;
  float _7198;
  float _7199;
  float _7208;
  float _7212;
  float _7221;
  float _7222;
  float _7223;
  float _7228;
  int _7229;
  float _7234;
  float _7243;
  float _7244;
  float _7246;
  float _7248;
  float _7249;
  float4 _7251;
  float _7255;
  float _7256;
  float _7259;
  float _7260;
  float _7265;
  float _7266;
  float _7269;
  float _7270;
  float _7272;
  float _7274;
  bool _7275;
  bool _7276;
  bool _7286;
  bool _7295;
  float _7312;
  float _7314;
  float _7316;
  float _7318;
  float _7322;
  float _7324;
  float _7328;
  float _7330;
  int _7337;
  float _7342;
  float _7351;
  float _7352;
  float _7355;
  float _7356;
  float4 _7358;
  float _7362;
  float _7363;
  float _7366;
  float _7367;
  float _7369;
  float _7371;
  bool _7372;
  bool _7373;
  bool _7383;
  bool _7392;
  float _7409;
  float _7411;
  float _7415;
  float _7417;
  float _7421;
  float _7423;
  float _7427;
  float _7429;
  int _7436;
  float _7441;
  float _7450;
  float _7451;
  float _7454;
  float _7455;
  float4 _7457;
  float _7461;
  float _7462;
  float _7465;
  float _7466;
  float _7468;
  float _7470;
  bool _7471;
  bool _7472;
  bool _7482;
  bool _7491;
  float _7508;
  float _7510;
  float _7514;
  float _7516;
  float _7520;
  float _7522;
  float _7526;
  float _7528;
  int _7535;
  float _7540;
  float _7549;
  float _7550;
  float _7553;
  float _7554;
  float4 _7556;
  float _7560;
  float _7561;
  float _7564;
  float _7565;
  float _7567;
  float _7569;
  bool _7570;
  bool _7571;
  bool _7581;
  bool _7590;
  float _7607;
  float _7609;
  float _7613;
  float _7615;
  float _7619;
  float _7621;
  float _7625;
  float _7627;
  float _7628;
  float _7639;
  float _7645;
  float _7647;
  float _7649;
  float _7671;
  float4 _7678;
  float _7692;
  float _7693;
  float _7694;
  float _7695;
  float _7697;
  float _7702;
  float _7705;
  float _7706;
  float _7708;
  float _7709;
  float _7714;
  float _7719;
  float _7721;
  float _7724;
  float _7725;
  float _7730;
  float _7732;
  float _7734;
  float _7736;
  float _7741;
  float _7747;
  float _7749;
  float3 _7777;
  float _7788;
  float4 _7809;
  float _7841;
  float _7861;
  bool _7874;
  float _7875;
  float _7876;
  float _7877;
  bool _7878;
  float _7880;
  float _7881;
  float _7885;
  float _7891;
  float _7905;
  float _7906;
  float _7909;
  float _7913;
  int _7914;
  float _7916;
  float _7918;
  float _7921;
  float _7925;
  float _7936;
  float _7937;
  float _7938;
  float _7940;
  int _7963;
  int _7968;
  int _7970;
  int _7971;
  int _7973;
  int _7974;
  int _7983;
  bool _7996;
  float _7999;
  float _8001;
  float _8002;
  float _8003;
  float _8004;
  float _8005;
  float _8006;
  float _8007;
  float _8008;
  float _8009;
  float _8010;
  float _8011;
  float _8012;
  bool _8013;
  float _8014;
  float _8015;
  float _8018;
  float _8019;
  float _8021;
  float _8048;
  float _8053;
  float _8060;
  float _8061;
  float _8062;
  float _8064;
  float _8068;
  float _8069;
  float _8070;
  float _8071;
  float _8072;
  float _8073;
  float _8074;
  float _8080;
  float _8089;
  float _8093;
  float _8094;
  float _8095;
  float _8096;
  float _8100;
  float _8101;
  float _8102;
  float _8110;
  float _8122;
  float _8123;
  float _8124;
  float _8125;
  float _8126;
  float _8130;
  float _8132;
  float _8134;
  float _8138;
  float _8139;
  float _8140;
  float _8143;
  bool _8150;
  float _8154;
  float _8156;
  float _8157;
  float _8165;
  float _8168;
  float _8169;
  float _8174;
  float _8183;
  float _8184;
  float _8187;
  float _8189;
  float _8190;
  float _8191;
  float _8193;
  float _8194;
  float _8195;
  float _8196;
  float _8201;
  float _8215;
  float _8220;
  float _8221;
  float _8223;
  float _8229;
  float _8232;
  float _8243;
  float _8245;
  float _8264;
  float _8275;
  float _8292;
  float _8299;
  float _8302;
  float _8303;
  float _8304;
  float _8316;
  float _8319;
  float _8320;
  float _8321;
  float _8322;
  float _8344;
  float _8375;
  float _8376;
  float _8377;
  float _8378;
  float _8381;
  float _8382;
  float _8383;
  float _8384;
  float _8387;
  float _8388;
  float _8389;
  float _8390;
  float _8393;
  float _8394;
  int _8397;
  int _8400;
  int _8403;
  int _8406;
  float _8409;
  float _8411;
  float _8412;
  float _8414;
  float _8418;
  float _8420;
  float _8424;
  float _8428;
  float _8432;
  float _8435;
  float _8438;
  float _8441;
  float _8453;
  float _8454;
  float _8455;
  float _8456;
  float _8457;
  float _8458;
  float _8459;
  float _8460;
  float _8461;
  float _8462;
  float _8463;
  float _8465;
  float _8467;
  float _8469;
  float _8471;
  float _8472;
  float _8478;
  float _8480;
  float _8487;
  float _8502;
  float _8504;
  float _8511;
  float _8521;
  float _8527;
  float _8529;
  float _8536;
  float _8553;
  float _8555;
  float _8562;
  float _8581;
  float _8582;
  float _8583;
  float _8584;
  float _8586;
  float _8588;
  float _8589;
  float _8590;
  float _8591;
  float _8592;
  float _8593;
  float _8594;
  float _8595;
  float _8597;
  float _8599;
  float _8600;
  float _8601;
  float _8602;
  float _8603;
  float _8604;
  float _8605;
  float _8607;
  float _8609;
  float _8616;
  bool _8629;
  float _8631;
  float _8637;
  float _8641;
  float _8643;
  float _8644;
  bool _8645;
  float _8647;
  float _8653;
  float _8654;
  float _8659;
  float _8660;
  float _8663;
  float _8665;
  float _8672;
  float _8685;
  float _8687;
  float _8694;
  float _8723;
  float _8724;
  float _8733;
  float _8742;
  float _8743;
  float _8749;
  float _8754;
  float _8763;
  float _8770;
  float _8773;
  float4 _8781;
  float _8783;
  float4 _8784;
  float _8793;
  float _8811;
  float _8812;
  float _8840;
  uint _8854;
  float _8865;
  float _8872;
  float _8883;
  float _8902;
  float _8905;
  float _8908;
  float4 _8929;
  float _8933;
  float _8934;
  float _8935;
  float _8937;
  float _8938;
  float _8939;
  float _8940;
  float _8941;
  float _8942;
  float _8943;
  float _8944;
  float _8945;
  float _8950;
  float _8955;
  float _8968;
  float4 _8976;
  float _8978;
  float _8985;
  bool _9018;
  int __loop_jump_target = -1;
  _54 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _60 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _65 = ((uint)(((int)(_60 << 3)) & 524280)) + SV_GroupThreadID.x;
  _66 = ((uint)(((uint)(_60) >> 16) << 3)) + SV_GroupThreadID.y;
  _73 = ((int)((((uint)(_66) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_65) >> 4)))) << 6;
  _76 = srvDeferredClusters[_73];
  if (_54 == 0) {
    _global_2 = (_76 & 255);
    _global_0 = (((uint)(_76) >> 16) & 255);
    _global_1 = (((uint)(_76) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _87 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_87 == 0)) {
    _91 = 0;
    while(true) {
      _93 = (_91 << 6) + _54;
      if ((uint)_93 < (uint)_global_2) {
        _100 = srvDeferredClusters[((int)(((uint)(_73 | 1)) + _93))];
        _global_3[min((uint)(_93), 63u)] = _100;
        _105 = _100 & 4095;
        _108 = srvLightInfoBase[_105].nFlags;
        _110 = srvLightInfoBase[_105].nRoomMask;
        _112 = srvLightInfoBase[_105].nBufferOffset;
        _global_4[min((uint)(_93), 63u)] = _108;
        _global_5[min((uint)(_93), 63u)] = _110;
        _global_6[min((uint)(_93), 63u)] = _112;
      }
      _114 = _91 + 1;
      if (!(_114 == _87)) {
        _91 = _114;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _119 = srvGlobalGBuffer0.Load(int3(_65, _66, 0));
  [branch]
  if (_119.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_65, _66)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_65, _66)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _127 = (float)((uint)_65);
    _128 = (float)((uint)_66);
    _136 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _127) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
    _137 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _128) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
    [branch]
    if (_119.x > 0.0f) {
      _140 = srvGlobalGBuffer1.Load(int3(_65, _66, 0));
      _144 = srvGlobalGBuffer2.Load(int3(_65, _66, 0));
      _150 = srvGlobalGBuffer3.Load(int3(_65, _66, 0));
      _154 = srvGlobalGBuffer4.Load(int3(_65, _66, 0));
      _161 = saturate(_144.x);
      _162 = saturate(_144.y);
      _163 = saturate(_144.z);
      _168 = saturate(_154.y);
      _173 = (saturate(_140.x) * 2.0f) + -1.0f;
      _174 = (saturate(_140.y) * 2.0f) + -1.0f;
      _178 = (1.0f - abs(_173)) - abs(_174);
      _180 = saturate(-0.0f - _178);
      _181 = -0.0f - _180;
      _186 = select((_173 >= 0.0f), _181, _180) + _173;
      _187 = select((_174 >= 0.0f), _181, _180) + _174;
      _189 = rsqrt(dot(float3(_186, _187, _178), float3(_186, _187, _178)));
      _190 = _186 * _189;
      _191 = _187 * _189;
      _192 = _189 * _178;
      _196 = (uint)(uint((saturate(_144.w) * 255.0f) + 0.5f)) >> 6;
      _202 = saturate(_150.x);
      _203 = saturate(_150.y) * 0.07999999821186066f;
      _210 = (_202 * (_161 - _203)) + _203;
      _211 = (_202 * (_162 - _203)) + _203;
      _212 = (_202 * (_163 - _203)) + _203;
      _218 = min(1.0f, max(saturate(_154.x), 0.019999999552965164f));
      _222 = (_202 * (1.0f - _203)) + _203;
      _228 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _119.x) - cbSharedPerViewData.vViewRemap.y);
      _229 = _228 * _136;
      _230 = _228 * _137;
      _231 = -0.0f - _228;
      _233 = ((_196 & 1) != 0);
      _234 = _196 & 3;
      _240 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _244 = srvReflectionsWeight.Load(int3(((uint)(_65) >> _240), ((uint)(_66) >> _240), 0));
      _250 = ((float)((uint)((uint)(_244.x & 254)))) * 0.003921568859368563f;
      if ((_244.x & 1) == 0) {
        _259 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _127), (cbSharedPerViewData.vViewportSize.y * _128)), 0.0f);
        _268 = (1.0f - _250);
        _269 = (_259.x * _250);
        _270 = (_259.y * _250);
        _271 = (_259.z * _250);
      } else {
        _268 = 1.0f;
        _269 = 0.0f;
        _270 = 0.0f;
        _271 = 0.0f;
      }
      _280 = cbSharedPerViewData.vViewportSize.x * (_127 + 0.5f);
      _281 = cbSharedPerViewData.vViewportSize.y * (_128 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _296 = (floor((_280 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _297 = (floor((_281 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _300 = max(_296, cbDeferredShading.vScreenPixelSize.z);
        _301 = max(_297, cbDeferredShading.vScreenPixelSize.w);
        _304 = min((_296 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _305 = min((_297 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _310 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_300 + cbDeferredShading.vScreenPixelSize.z), (_301 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _310.x) - cbSharedPerViewData.vViewRemap.y)) - _228) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _310.y) - cbSharedPerViewData.vViewRemap.y)) - _228) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _310.z) - cbSharedPerViewData.vViewRemap.y)) - _228) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _310.w) - cbSharedPerViewData.vViewRemap.y)) - _228) > 0.029999999329447746f)) {
          _344 = abs(_119.x - _310.w);
          _346 = abs(_119.x - _310.z);
          _347 = (_346 < _344);
          _349 = select(_347, _346, _344);
          _351 = abs(_119.x - _310.x);
          _352 = (_351 < _349);
          if (abs(_119.x - _310.y) < select(_352, _351, _349)) {
            _361 = _304;
            _362 = _305;
          } else {
            _361 = select(_352, _300, select(_347, _304, _300));
            _362 = select(_352, _305, _301);
          }
        } else {
          _361 = _280;
          _362 = _281;
        }
      } else {
        _361 = _280;
        _362 = _281;
      }
      _365 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_361, _362), 0.0f);
      _369 = _365.x - _365.z;
      _381 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_365.y + _369)), 0.0f);
      _382 = -0.0f - _381;
      _383 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_365.x + _365.z)), 0.0f);
      _384 = -0.0f - _383;
      _385 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_369 - _365.y)), 0.0f);
      _386 = -0.0f - _385;
      _389 = (cbSharedPerViewData.nSSGIEnabled == 0);
      if (!_389) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _400 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_361, _362), 0.0f)).x);
        } else {
          _400 = 1.0f;
        }
      } else {
        _400 = 1.0f;
      }
      if (!_389) {
        _404 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
        _405 = (int)(uint)(_404);
        if (_404) {
          _408 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_361, _362), 0.0f);
          _413 = (_408.x * 2.0f) + -1.0f;
          _414 = (_408.y * 2.0f) + -1.0f;
          _418 = (1.0f - abs(_413)) - abs(_414);
          _420 = saturate(-0.0f - _418);
          _421 = -0.0f - _420;
          _426 = select((_413 >= 0.0f), _421, _420) + _413;
          _427 = select((_414 >= 0.0f), _421, _420) + _414;
          _429 = rsqrt(dot(float3(_426, _427, _418), float3(_426, _427, _418)));
          _430 = _426 * _429;
          _431 = _427 * _429;
          _432 = _429 * _418;
          _434 = rsqrt(dot(float3(_430, _431, _432), float3(_430, _431, _432)));
          _439 = _405;
          _440 = (_430 * _434);
          _441 = (_431 * _434);
          _442 = (_434 * _432);
        } else {
          _439 = _405;
          _440 = 0.0f;
          _441 = 0.0f;
          _442 = 0.0f;
        }
      } else {
        _439 = 0;
        _440 = 0.0f;
        _441 = 0.0f;
        _442 = 0.0f;
      }
      _443 = 1.0f - _202;
      _447 = -0.0f - _136;
      _448 = -0.0f - _137;
      _450 = rsqrt(dot(float3(_447, _448, 1.0f), float3(_447, _448, 1.0f)));
      _451 = _450 * _447;
      _452 = _450 * _448;
      _460 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _66) + _65))];
      _461 = _460 & 255;
      _462 = (uint)(_460) >> 8;
      _463 = _462 & 255;
      _467 = ((float)((uint)((uint)(((uint)(_460) >> 16) & 255)))) * 0.003921568859368563f;
      _469 = (float)((uint)((uint)((uint)(_460) >> 24)));
      _470 = _469 * 0.003921568859368563f;
      [branch]
      if (!((_234 == 2) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _480 = _218 * 4.0f;
        _485 = dot(float3((-0.0f - _451), (-0.0f - _452), (-0.0f - _450)), float3(_190, _191, _192)) * 2.0f;
        _489 = _218 * _218;
        _490 = 1.0f - _489;
        _493 = (sqrt(_490) + _489) * _490;
        _506 = (_493 * (((-0.0f - _190) - _451) - (_485 * _190))) + _190;
        _507 = (_493 * (((-0.0f - _191) - _452) - (_485 * _191))) + _191;
        _508 = (_493 * (((-0.0f - _192) - _450) - (_485 * _192))) + _192;
        _512 = saturate(1.0f - ((_218 + -0.30000001192092896f) * 3.3333332538604736f));
        _527 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _508, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _507, (_506 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _530 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _508, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _507, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _506)));
        _533 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _508, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _507, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _506)));
        _536 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _192, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _191, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _190)));
        _539 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _192, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _191, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _190)));
        _542 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _192, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _191, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _190)));
        if (!(_global_0 == 0)) {
          _561 = 0;
          _562 = 0.0f;
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
          while(true) {
            _853 = _562;
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
            _578 = _global_5[min((uint)(_561), 63u)];
            _579 = _global_6[min((uint)(_561), 63u)];
            _582 = asfloat(srvLightInfoProperties.Load4(_579)).x;
            _583 = asfloat(srvLightInfoProperties.Load4(_579)).y;
            _584 = asfloat(srvLightInfoProperties.Load4(_579)).z;
            _585 = asfloat(srvLightInfoProperties.Load4(_579)).w;
            _588 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 16u)))).x;
            _589 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 16u)))).y;
            _590 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 16u)))).z;
            _591 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 16u)))).w;
            _594 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 32u)))).x;
            _595 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 32u)))).y;
            _596 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 32u)))).z;
            _597 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 32u)))).w;
            _600 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 48u)))).x;
            _601 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 48u)))).y;
            _602 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 48u)))).z;
            _603 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 48u)))).w;
            _606 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 64u)))).x;
            _607 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 64u)))).y;
            _608 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 64u)))).z;
            _609 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 64u)))).w;
            _612 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 80u)))).x;
            _613 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 80u)))).y;
            _614 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 80u)))).z;
            _615 = asfloat(srvLightInfoProperties.Load4(((int)(_579 + 80u)))).w;
            _618 = asint(srvLightInfoProperties.Load(((int)(_579 + 96u))));
            _621 = asfloat(srvLightInfoProperties.Load3(((int)(_579 + 100u)))).x;
            _622 = asfloat(srvLightInfoProperties.Load3(((int)(_579 + 100u)))).y;
            _623 = asfloat(srvLightInfoProperties.Load3(((int)(_579 + 100u)))).z;
            _626 = asfloat(srvLightInfoProperties.Load3(((int)(_579 + 112u)))).x;
            _627 = asfloat(srvLightInfoProperties.Load3(((int)(_579 + 112u)))).y;
            _628 = asfloat(srvLightInfoProperties.Load3(((int)(_579 + 112u)))).z;
            _631 = asint(srvLightInfoProperties.Load(((int)(_579 + 124u))));
            _634 = asint(srvLightInfoProperties.Load(((int)(_579 + 128u))));
            _637 = _618 & 65535;
            _666 = ((saturate(1.0f - abs(mad(_584, _231, mad(_583, _230, (_582 * _229))) + _585)) * f16tof32(((uint)((uint)(_618) >> 16)))) * saturate(1.0f - abs(mad(_590, _231, mad(_589, _230, (_588 * _229))) + _591))) * saturate(1.0f - abs(mad(_596, _231, mad(_595, _230, (_594 * _229))) + _597));
            [branch]
            if (_666 > 0.0f) {
              _669 = _666 * _666;
              [branch]
              if (_512 < 1.0f) {
                _672 = (float)((uint)_637);
                _673 = -0.0f - _527;
                [branch]
                if (!(_672 >= 341.0f)) {
                  _685 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_673, _530, _533, _672), _480);
                  _690 = _685.x;
                  _691 = _685.y;
                  _692 = _685.z;
                } else {
                  _679 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_673, _530, _533, (_672 + -341.0f)), _480);
                  _690 = _679.x;
                  _691 = _679.y;
                  _692 = _679.z;
                }
              } else {
                _690 = 0.0f;
                _691 = 0.0f;
                _692 = 0.0f;
              }
              _694 = (float)((uint)_637);
              [branch]
              if (_512 > 0.0f) {
                _698 = mad(_602, _508, mad(_601, _507, (_600 * _506)));
                _701 = mad(_608, _508, mad(_607, _507, (_606 * _506)));
                _704 = mad(_614, _508, mad(_613, _507, (_612 * _506)));
                _745 = min(((((float((int)(((int)(uint)((int)(_698 > 0.0f))) - ((int)(uint)((int)(_698 < 0.0f))))) * _621) - _603) - mad(_602, _231, mad(_601, _230, (_600 * _229)))) / _698), min(((((float((int)(((int)(uint)((int)(_701 > 0.0f))) - ((int)(uint)((int)(_701 < 0.0f))))) * _622) - _609) - mad(_608, _231, mad(_607, _230, (_606 * _229)))) / _701), ((((float((int)(((int)(uint)((int)(_704 > 0.0f))) - ((int)(uint)((int)(_704 < 0.0f))))) * _623) - _615) - mad(_614, _231, mad(_613, _230, (_612 * _229)))) / _704)));
                _750 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _231, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _230, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _229))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _626) + (_745 * _527);
                _752 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _231, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _230, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _229))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _627) + (_745 * _530);
                _754 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _231, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _230, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _229))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _628) + (_745 * _533);
                _761 = (max(log2((_745 * _745) / dot(float3(_750, _752, _754), float3(_750, _752, _754))), -1.0f) * 0.3333333432674408f) + _480;
                _762 = -0.0f - _750;
                [branch]
                if (!(_694 >= 341.0f)) {
                  _774 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_762, _752, _754, _694), _761);
                  _779 = _774.x;
                  _780 = _774.y;
                  _781 = _774.z;
                } else {
                  _768 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_762, _752, _754, (_694 + -341.0f)), _761);
                  _779 = _768.x;
                  _780 = _768.y;
                  _781 = _768.z;
                }
              } else {
                _779 = 0.0f;
                _780 = 0.0f;
                _781 = 0.0f;
              }
              _782 = -0.0f - _536;
              [branch]
              if (!(_694 >= 341.0f)) {
                _794 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_782, _539, _542, _694), 0.0f);
                _799 = _794.x;
                _800 = _794.y;
                _801 = _794.z;
              } else {
                _788 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_782, _539, _542, (_694 + -341.0f)), 0.0f);
                _799 = _788.x;
                _800 = _788.y;
                _801 = _788.z;
              }
              _811 = _669 * f16tof32(((uint)((uint)(_631) >> 16)));
              _812 = _811 * _799;
              _813 = _669 * f16tof32(_631);
              _814 = _813 * _800;
              _815 = _669 * f16tof32(((uint)((uint)(_634) >> 16)));
              _816 = _815 * _801;
              _817 = _811 * (lerp(_690, _779, _512));
              _818 = _813 * (lerp(_691, _780, _512));
              _819 = _815 * (lerp(_692, _781, _512));
              [branch]
              if (!((_578 & ((int)(1 << (_460 & 31)))) == 0)) {
                _833 = (_812 + _562);
                _834 = (_814 + _563);
                _835 = (_816 + _564);
                _836 = (_817 + _565);
                _837 = (_818 + _566);
                _838 = (_819 + _567);
                _839 = (_669 + _568);
              } else {
                _833 = _562;
                _834 = _563;
                _835 = _564;
                _836 = _565;
                _837 = _566;
                _838 = _567;
                _839 = _568;
              }
              [branch]
              if (!((_578 & ((int)(1 << (_462 & 31)))) == 0)) {
                _853 = _833;
                _854 = _834;
                _855 = _835;
                _856 = _836;
                _857 = _837;
                _858 = _838;
                _859 = _839;
                _860 = (_812 + _569);
                _861 = (_814 + _570);
                _862 = (_816 + _571);
                _863 = (_817 + _572);
                _864 = (_818 + _573);
                _865 = (_819 + _574);
                _866 = (_669 + _575);
              } else {
                _853 = _833;
                _854 = _834;
                _855 = _835;
                _856 = _836;
                _857 = _837;
                _858 = _838;
                _859 = _839;
                _860 = _569;
                _861 = _570;
                _862 = _571;
                _863 = _572;
                _864 = _573;
                _865 = _574;
                _866 = _575;
              }
            } else {
              _853 = _562;
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
            }
            _867 = _561 + 1u;
            if (!(_867 == _global_0)) {
              _561 = _867;
              _562 = _853;
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
              continue;
            }
            _871 = _853;
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
            break;
          }
        } else {
          _871 = 0.0f;
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
        }
        _890 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_460 & 31)))) != 0);
        if ((_467 > 0.0f) || ((_470 > 0.0f) || _890)) {
          _900 = srvFallbackInfo[((_461 << 2) | 3)].x;
          _902 = select(_890, 9.999999747378752e-05f, (_469 * 3.921568847431445e-09f));
          _903 = _877 * 0.20000000298023224f;
          _910 = saturate((_902 - _903) / (((_877 * 0.4000000059604645f) + 9.99999993922529e-09f) - _903)) * _902;
          [branch]
          if (_910 > 0.0f) {
            [branch]
            if ((int)_900 > (int)-1) {
              _915 = float((int)(_900));
              _916 = -0.0f - _527;
              _917 = !(_915 >= 341.0f);
              [branch]
              if (_917) {
                _928 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_916, _530, _533, _915), _480);
                _933 = _928.x;
                _934 = _928.y;
                _935 = _928.z;
              } else {
                _922 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_916, _530, _533, (_915 + -341.0f)), _480);
                _933 = _922.x;
                _934 = _922.y;
                _935 = _922.z;
              }
              _939 = -0.0f - _536;
              [branch]
              if (_917) {
                _950 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_939, _539, _542, _915), 0.0f);
                _955 = _950.x;
                _956 = _950.y;
                _957 = _950.z;
              } else {
                _944 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_939, _539, _542, (_915 + -341.0f)), 0.0f);
                _955 = _944.x;
                _956 = _944.y;
                _957 = _944.z;
              }
              _968 = ((_933 * _910) + _874);
              _969 = ((_934 * _910) + _875);
              _970 = ((_935 * _910) + _876);
              _971 = ((_955 * _910) + _871);
              _972 = ((_956 * _910) + _872);
              _973 = ((_957 * _910) + _873);
            } else {
              _968 = _874;
              _969 = _875;
              _970 = _876;
              _971 = _871;
              _972 = _872;
              _973 = _873;
            }
            _976 = (_910 + _877);
            _977 = _968;
            _978 = _969;
            _979 = _970;
            _980 = _971;
            _981 = _972;
            _982 = _973;
          } else {
            _976 = _877;
            _977 = _874;
            _978 = _875;
            _979 = _876;
            _980 = _871;
            _981 = _872;
            _982 = _873;
          }
          if (_976 > 0.0f) {
            _988 = (cbSharedPerViewData.vHDRScale.x * _467) / _976;
            _996 = (_988 * _980);
            _997 = (_988 * _981);
            _998 = (_988 * _982);
            _999 = (_988 * _977);
            _1000 = (_988 * _978);
            _1001 = (_988 * _979);
          } else {
            _996 = 0.0f;
            _997 = 0.0f;
            _998 = 0.0f;
            _999 = 0.0f;
            _1000 = 0.0f;
            _1001 = 0.0f;
          }
        } else {
          _996 = 0.0f;
          _997 = 0.0f;
          _998 = 0.0f;
          _999 = 0.0f;
          _1000 = 0.0f;
          _1001 = 0.0f;
        }
        [branch]
        if (!(_470 == 0.0f)) {
          _1008 = srvFallbackInfo[((_463 << 2) | 3)].x;
          _1009 = _469 * 3.921568847431445e-09f;
          [branch]
          if ((int)_1008 > (int)-1) {
            _1012 = float((int)(_1008));
            _1013 = -0.0f - _527;
            _1014 = !(_1012 >= 341.0f);
            [branch]
            if (_1014) {
              _1025 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1013, _530, _533, _1012), _480);
              _1030 = _1025.x;
              _1031 = _1025.y;
              _1032 = _1025.z;
            } else {
              _1019 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1013, _530, _533, (_1012 + -341.0f)), _480);
              _1030 = _1019.x;
              _1031 = _1019.y;
              _1032 = _1019.z;
            }
            _1036 = -0.0f - _536;
            [branch]
            if (_1014) {
              _1047 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1036, _539, _542, _1012), 0.0f);
              _1052 = _1047.x;
              _1053 = _1047.y;
              _1054 = _1047.z;
            } else {
              _1041 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1036, _539, _542, (_1012 + -341.0f)), 0.0f);
              _1052 = _1041.x;
              _1053 = _1041.y;
              _1054 = _1041.z;
            }
            _1065 = ((_1030 * _1009) + _881);
            _1066 = ((_1031 * _1009) + _882);
            _1067 = ((_1032 * _1009) + _883);
            _1068 = ((_1052 * _1009) + _878);
            _1069 = ((_1053 * _1009) + _879);
            _1070 = ((_1054 * _1009) + _880);
          } else {
            _1065 = _881;
            _1066 = _882;
            _1067 = _883;
            _1068 = _878;
            _1069 = _879;
            _1070 = _880;
          }
          _1075 = (cbSharedPerViewData.vHDRScale.x * _470) / (_884 + _1009);
          _1089 = ((_1075 * _1068) + _996);
          _1090 = ((_1075 * _1069) + _997);
          _1091 = ((_1075 * _1070) + _998);
          _1092 = ((_1075 * _1065) + _999);
          _1093 = ((_1075 * _1066) + _1000);
          _1094 = ((_1075 * _1067) + _1001);
        } else {
          _1089 = _996;
          _1090 = _997;
          _1091 = _998;
          _1092 = _999;
          _1093 = _1000;
          _1094 = _1001;
        }
      } else {
        _1089 = 0.0f;
        _1090 = 0.0f;
        _1091 = 0.0f;
        _1092 = 0.0f;
        _1093 = 0.0f;
        _1094 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1113 = (min((_382 / max(9.999999747378752e-05f, _1089)), 1.0f) * _1092);
        _1114 = (min((_384 / max(9.999999747378752e-05f, _1090)), 1.0f) * _1093);
        _1115 = (min((_386 / max(9.999999747378752e-05f, _1091)), 1.0f) * _1094);
      } else {
        _1113 = _1092;
        _1114 = _1093;
        _1115 = _1094;
      }
      _1128 = saturate(dot(float3(_451, _452, _450), float3(_190, _191, _192)));
      _1131 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1128, _218), 0.0f);
      _1134 = _1131.x + _1131.y;
      _1135 = 1.0f - _1134;
      _1139 = max(9.999999747378752e-06f, _1134);
      _1143 = ((_1135 * _210) / _1139) + 1.0f;
      _1144 = ((_1135 * _211) / _1139) + 1.0f;
      _1145 = ((_1135 * _212) / _1139) + 1.0f;
      _1152 = min((_168 * _168), _400);
      if (!(_global_1 == 0)) {
        _1156 = 0;
        _1157 = _1152;
        while(true) {
          _1275 = _1157;
          _1158 = _1156 + (uint)(_global_0);
          _1161 = _global_5[min((uint)(_1158), 63u)];
          _1162 = _global_6[min((uint)(_1158), 63u)];
          _1166 = (int)((int)(_1161 << (((int)(31u - _460)) & 31))) >> 31;
          _1170 = (int)((int)(_1161 << ((31 - _462) & 31))) >> 31;
          _1182 = saturate((asfloat((_1166 & asint(_467))) + asfloat((_1170 & asint(_470)))) + asfloat(((_1170 & 1065353216) & _1166)));
          [branch]
          if (!(_1182 == 0.0f)) {
            _1187 = asfloat(srvLightInfoProperties.Load4(_1162)).x;
            _1188 = asfloat(srvLightInfoProperties.Load4(_1162)).y;
            _1189 = asfloat(srvLightInfoProperties.Load4(_1162)).z;
            _1190 = asfloat(srvLightInfoProperties.Load4(_1162)).w;
            _1193 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 16u)))).x;
            _1194 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 16u)))).y;
            _1195 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 16u)))).z;
            _1196 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 16u)))).w;
            _1199 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 32u)))).x;
            _1200 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 32u)))).y;
            _1201 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 32u)))).z;
            _1202 = asfloat(srvLightInfoProperties.Load4(((int)(_1162 + 32u)))).w;
            _1205 = asint(srvLightInfoProperties.Load(((int)(_1162 + 48u))));
            _1208 = asint(srvLightInfoProperties.Load(((int)(_1162 + 52u))));
            _1211 = asint(srvLightInfoProperties.Load(((int)(_1162 + 56u))));
            _1214 = asint(srvLightInfoProperties.Load(((int)(_1162 + 60u))));
            _1229 = mad(_1189, _231, mad(_1188, _230, (_1187 * _229))) + _1190;
            _1233 = mad(_1195, _231, mad(_1194, _230, (_1193 * _229))) + _1196;
            _1237 = mad(_1201, _231, mad(_1200, _230, (_1199 * _229))) + _1202;
            _1262 = saturate(1.0f - ((_1229 + 1.0f) * f16tof32(_1208))) + saturate(1.0f - ((1.0f - _1229) * f16tof32(((uint)((uint)(_1208) >> 16)))));
            _1263 = saturate(1.0f - ((_1233 + 1.0f) * f16tof32(_1211))) + saturate(1.0f - ((1.0f - _1233) * f16tof32(((uint)((uint)(_1211) >> 16)))));
            _1264 = saturate(1.0f - ((_1237 + 1.0f) * f16tof32(_1214))) + saturate(1.0f - ((1.0f - _1237) * f16tof32(((uint)((uint)(_1214) >> 16)))));
            _1267 = saturate(1.0f - dot(float3(_1262, _1263, _1264), float3(_1262, _1263, _1264)));
            _1275 = (saturate(1.0f - ((_1267 * _1267) * (f16tof32(((uint)((uint)(_1205) >> 16))) * _1182))) * _1157);
          } else {
            _1275 = _1157;
          }
          _1276 = _1156 + 1u;
          if (!(_1276 == _global_1)) {
            _1156 = _1276;
            _1157 = _1275;
            continue;
          }
          _1280 = _1275;
          break;
        }
      } else {
        _1280 = _1152;
      }
      _1284 = dot(float3(_161, _162, _163), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      _1291 = _1280 * saturate(_150.w);
      _1292 = saturate((_161 * 2.0f) - _1284) * _1291;
      _1293 = saturate((_162 * 2.0f) - _1284) * _1291;
      _1294 = saturate((_163 * 2.0f) - _1284) * _1291;
      _1298 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
      if (_1298) {
        _1310 = saturate((_1280 + -1.0f) + exp2((_218 * _218) * log2(max((_1280 + _1128), 0.0f))));
      } else {
        _1310 = _1280;
      }
      if (!(_439 == 0)) {
        _1313 = rsqrt(dot(float3(_440, _441, _442), float3(_440, _441, _442)));
        _1315 = rsqrt(dot(float3(_190, _191, _192), float3(_190, _191, _192)));
        _1316 = _1315 * _190;
        _1317 = _1315 * _191;
        _1318 = _1315 * _192;
        if (_1298) {
          _1323 = max(_218, 0.10000000149011612f);
          _1324 = -0.0f - _451;
          _1325 = -0.0f - _452;
          _1326 = -0.0f - _450;
          _1328 = dot(float3(_1324, _1325, _1326), float3(_1316, _1317, _1318)) * 2.0f;
          _1337 = min(max(dot(float3((_1313 * _440), (_1313 * _441), (_1313 * _442)), float3((_1324 - (_1328 * _1316)), (_1325 - (_1328 * _1317)), (_1326 - (_1328 * _1318)))), -1.0f), 1.0f);
          _1338 = abs(_1337);
          _1343 = (1.5707963705062866f - (_1338 * 0.1565829962491989f)) * sqrt(1.0f - _1338);
          _1349 = abs((_1323 - _1280) * 3.1415927410125732f);
          _1357 = saturate(1.0f - saturate((select((_1337 >= 0.0f), _1343, (3.1415927410125732f - _1343)) - _1349) / (((_1323 + _1280) * 3.1415927410125732f) - _1349)));
          _1367 = (((_1357 * _1357) * saturate((_1280 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1357 * 2.0f)));
        } else {
          _1367 = _1280;
        }
      } else {
        _1367 = _1310;
      }
      _1370 = ((_1143 * ((cbSharedPerViewData.vHDRScale.x * _269) + (_1113 * _268))) * ((_1131.x * _210) + _1131.y)) * _1367;
      _1373 = ((((_1131.x * _211) + _1131.y) * ((cbSharedPerViewData.vHDRScale.x * _270) + (_1114 * _268))) * _1144) * _1367;
      _1376 = ((((_1131.x * _212) + _1131.y) * ((cbSharedPerViewData.vHDRScale.x * _271) + (_1115 * _268))) * _1145) * _1367;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1383 = _1280;
      } else {
        _1383 = 1.0f;
      }
      if (_467 > 0.0f) {
        _1386 = _461 * 3;
        _1389 = srvRoomInfo[_1386].x;
        _1390 = srvRoomInfo[_1386].y;
        _1391 = srvRoomInfo[_1386].z;
        _1397 = srvRoomInfo[(_1386 + 1)].x;
        _1398 = srvRoomInfo[(_1386 + 1)].y;
        _1399 = srvRoomInfo[(_1386 + 1)].z;
        _1405 = srvRoomInfo[(_1386 + 2)].x;
        _1406 = srvRoomInfo[(_1386 + 2)].y;
        _1407 = srvRoomInfo[(_1386 + 2)].z;
        _1413 = saturate(dot(float3(_190, _191, _192), float3(asfloat(_1389), asfloat(_1390), asfloat(_1391))) + 0.5f);
        _1417 = (_1413 * _1413) * (3.0f - (_1413 * 2.0f));
        _1421 = 1.0f - _1417;
        _1428 = _1383 * _467;
        _1436 = ((_1428 * ((_1421 * asfloat(_1405)) + (_1417 * asfloat(_1397)))) - _381);
        _1437 = ((_1428 * ((_1421 * asfloat(_1406)) + (_1417 * asfloat(_1398)))) - _383);
        _1438 = ((_1428 * ((_1421 * asfloat(_1407)) + (_1417 * asfloat(_1399)))) - _385);
      } else {
        _1436 = _382;
        _1437 = _384;
        _1438 = _386;
      }
      if (_470 > 0.0f) {
        _1441 = _463 * 3;
        _1444 = srvRoomInfo[_1441].x;
        _1445 = srvRoomInfo[_1441].y;
        _1446 = srvRoomInfo[_1441].z;
        _1452 = srvRoomInfo[(_1441 + 1)].x;
        _1453 = srvRoomInfo[(_1441 + 1)].y;
        _1454 = srvRoomInfo[(_1441 + 1)].z;
        _1460 = srvRoomInfo[(_1441 + 2)].x;
        _1461 = srvRoomInfo[(_1441 + 2)].y;
        _1462 = srvRoomInfo[(_1441 + 2)].z;
        _1468 = saturate(dot(float3(_190, _191, _192), float3(asfloat(_1444), asfloat(_1445), asfloat(_1446))) + 0.5f);
        _1472 = (_1468 * _1468) * (3.0f - (_1468 * 2.0f));
        _1476 = 1.0f - _1472;
        _1483 = _1383 * _470;
        _1491 = ((_1483 * ((_1476 * asfloat(_1460)) + (_1472 * asfloat(_1452)))) + _1436);
        _1492 = ((_1483 * ((_1476 * asfloat(_1461)) + (_1472 * asfloat(_1453)))) + _1437);
        _1493 = ((_1483 * ((_1476 * asfloat(_1462)) + (_1472 * asfloat(_1454)))) + _1438);
      } else {
        _1491 = _1436;
        _1492 = _1437;
        _1493 = _1438;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1516 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _231, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _230, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _229))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1520 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _231, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _230, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _229))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1524 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _231, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _230, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _229))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1543 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1524, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1520, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1516))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1547 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1524, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1520, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1516))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1551 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1524, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1520, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1516))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1564 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1565 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1566 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1603 = min(min(saturate((_1543 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1564), 9.999999747378752e-06f)), saturate((1.0f - _1543) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1564), 9.999999747378752e-06f))), min(min(saturate((_1547 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1565), 9.999999747378752e-06f)), saturate((1.0f - _1547) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1565), 9.999999747378752e-06f))), min(saturate((_1551 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1566), 9.999999747378752e-06f)), saturate((1.0f - _1551) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1566), 9.999999747378752e-06f)))));
      } else {
        _1603 = 0.0f;
      }
      _1604 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1604 < (uint)_global_2) {
        _1608 = _1491;
        _1609 = _1492;
        _1610 = _1493;
        _1611 = _1370;
        _1612 = _1373;
        _1613 = _1376;
        _1614 = _1604;
        while(true) {
          _8848 = _1608;
          _8849 = _1609;
          _8850 = _1610;
          _8851 = _1611;
          _8852 = _1612;
          _8853 = _1613;
          _1616 = _global_3[min((uint)(_1614), 63u)];
          _1620 = _global_4[min((uint)(_1614), 63u)];
          _1621 = _global_5[min((uint)(_1614), 63u)];
          _1622 = _global_6[min((uint)(_1614), 63u)];
          _1623 = _1616 & 4095;
          [branch]
          if (((((int)(uint(saturate(_154.w) * 255.0f)) & 64) != 0) || ((_1620 & 8388608) == 0)) && (((int)(uint((saturate(_154.z) * 1.9921875f) + 0.003921568859368563f)) != 0) || ((_1620 & 16777216) == 0))) {
            _1635 = (int)((int)(_1621 << (((int)(31u - _460)) & 31))) >> 31;
            _1639 = (int)((int)(_1621 << ((31 - _462) & 31))) >> 31;
            _1651 = saturate((asfloat((_1635 & asint(_467))) + asfloat((_1639 & asint(_470)))) + asfloat(((_1639 & 1065353216) & _1635)));
            [branch]
            if (!(_1651 == 0.0f)) {
              _1654 = (uint)(_1616) >> 12;
              if (_1654 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _3222 = (_1651 * select(((_1620 & 67108864) != 0), 1.0f, (1.0f - _1603)));
                } else {
                  _3222 = _1651;
                }
                _3225 = asfloat(srvLightInfoProperties.Load4(_1622)).x;
                _3226 = asfloat(srvLightInfoProperties.Load4(_1622)).y;
                _3227 = asfloat(srvLightInfoProperties.Load4(_1622)).z;
                _3228 = asfloat(srvLightInfoProperties.Load4(_1622)).w;
                _3231 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).x;
                _3232 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).y;
                _3233 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).z;
                _3234 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).w;
                _3237 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).x;
                _3238 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).y;
                _3239 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).z;
                _3240 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).w;
                _3243 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).x;
                _3244 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).y;
                _3245 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).z;
                _3248 = asint(srvLightInfoProperties.Load(((int)(_1622 + 68u))));
                _3251 = asint(srvLightInfoProperties.Load(((int)(_1622 + 72u))));
                _3254 = asint(srvLightInfoProperties.Load(((int)(_1622 + 76u))));
                _3257 = asint(srvLightInfoProperties.Load(((int)(_1622 + 84u))));
                _3260 = asint(srvLightInfoProperties.Load(((int)(_1622 + 88u))));
                _3263 = asint(srvLightInfoProperties.Load(((int)(_1622 + 92u))));
                _3266 = (float)((uint)((uint)(((uint)(_3248) >> 8) & 255)));
                _3270 = ((float)((uint)((uint)(_3248 & 255)))) * 0.003921499941498041f;
                _3272 = f16tof32(((uint)((uint)(_3251) >> 16)));
                _3274 = (uint)(_3254) >> 16;
                _3288 = mad(_3227, _231, mad(_3226, _230, (_3225 * _229))) + _3228;
                _3292 = mad(_3233, _231, mad(_3232, _230, (_3231 * _229))) + _3234;
                _3298 = srvDeferredShadingPass_DeferredShadows.Load(int3(_65, _66, 0));
                _3303 = min((int)(cbSharedPerViewData.nNumCSMCascades), (int)(3));
                if (!(_3303 == 0)) {
                  _3307 = 0;
                  while(true) {
                    _3310 = srvLightInfoBase[_1623].nBufferOffset;
                    _3322 = asint(srvLightInfoProperties.Load(((int)(_3310 + 160u))));
                    _3325 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 164u)))).x;
                    _3326 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 164u)))).y;
                    _3327 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 164u)))).z;
                    _3330 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 176u)))).x;
                    _3331 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 176u)))).y;
                    _3332 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 176u)))).z;
                    [branch]
                    if (_3307 == 0) {
                      _3335 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 112u)))).z;
                      _3336 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 112u)))).y;
                      _3337 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 112u)))).x;
                      _3338 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 100u)))).z;
                      _3339 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 100u)))).y;
                      _3340 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 100u)))).x;
                      _3343 = asint(srvLightInfoProperties.Load(((int)(_3310 + 96u))));
                      _3358 = _3340;
                      _3359 = _3339;
                      _3360 = _3338;
                      _3361 = _3337;
                      _3362 = _3336;
                      _3363 = _3335;
                      _3364 = _3343;
                      if (!((uint)_3364 < (uint)65536)) {
                        if (!((((0.5f - abs(((_3358 * _3288) + -0.5f) + _3361)) >= 0.0f) && ((0.5f - abs(((_3359 * _3292) + -0.5f) + _3362)) >= 0.0f)) && ((0.5f - abs(((_3360 * (mad(_3239, _231, mad(_3238, _230, (_3237 * _229))) + _3240)) + -0.5f) + _3363)) >= 0.0f))) {
                          _3388 = _3307 + 1u;
                          if ((uint)_3388 < (uint)_3303) {
                            _3307 = _3388;
                            continue;
                          } else {
                            _3391 = false;
                          }
                        } else {
                          _3391 = true;
                        }
                      } else {
                        _3391 = false;
                      }
                    } else {
                      _3345 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 144u)))).z;
                      _3346 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 144u)))).y;
                      _3347 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 144u)))).x;
                      _3348 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 132u)))).z;
                      _3349 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 132u)))).y;
                      _3350 = asfloat(srvLightInfoProperties.Load3(((int)(_3310 + 132u)))).x;
                      _3353 = asint(srvLightInfoProperties.Load(((int)(_3310 + 128u))));
                      bool __branch_chain_3344;
                      if (_3307 == 1) {
                        _3358 = _3350;
                        _3359 = _3349;
                        _3360 = _3348;
                        _3361 = _3347;
                        _3362 = _3346;
                        _3363 = _3345;
                        _3364 = _3353;
                        __branch_chain_3344 = true;
                      } else {
                        if (_3307 == 2) {
                          _3358 = _3325;
                          _3359 = _3326;
                          _3360 = _3327;
                          _3361 = _3330;
                          _3362 = _3331;
                          _3363 = _3332;
                          _3364 = _3322;
                          __branch_chain_3344 = true;
                        } else {
                          _3391 = false;
                          __branch_chain_3344 = false;
                        }
                      }
                      if (__branch_chain_3344) {
                        if (!((uint)_3364 < (uint)65536)) {
                          if (!((((0.5f - abs(((_3358 * _3288) + -0.5f) + _3361)) >= 0.0f) && ((0.5f - abs(((_3359 * _3292) + -0.5f) + _3362)) >= 0.0f)) && ((0.5f - abs(((_3360 * (mad(_3239, _231, mad(_3238, _230, (_3237 * _229))) + _3240)) + -0.5f) + _3363)) >= 0.0f))) {
                            _3388 = _3307 + 1u;
                            if ((uint)_3388 < (uint)_3303) {
                              _3307 = _3388;
                              continue;
                            } else {
                              _3391 = false;
                            }
                          } else {
                            _3391 = true;
                          }
                        } else {
                          _3391 = false;
                        }
                      }
                    }
                    _3393 = _3391;
                    break;
                  }
                } else {
                  _3393 = false;
                }
                [branch]
                if (!(_3298.x == 0.0f)) {
                  [branch]
                  if (!(_3274 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3274)))];
                    _3408 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2(((_3288 * f16tof32(((uint)((uint)(_3260) >> 16)))) + f16tof32(((uint)((uint)(_3263) >> 16)))), ((_3292 * f16tof32(_3260)) + f16tof32(_3263))), 0.0f);
                    _3416 = (_3408.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _3417 = (_3408.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _3418 = (_3408.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _3416 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _3417 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _3418 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  if (((_234 == 3) || (!_233)) && _3393) {
                    _3427 = (_3298.x * _3222) * saturate(0.30000001192092896f - dot(float3(_3243, _3244, _3245), float3(_190, _191, _192)));
                    _3438 = (((_3416 * _1292) * _3427) + _1611);
                    _3439 = (((_3417 * _1293) * _3427) + _1612);
                    _3440 = (((_3418 * _1294) * _3427) + _1613);
                  } else {
                    _3438 = _1611;
                    _3439 = _1612;
                    _3440 = _1613;
                  }
                  _3443 = min(_3298.x, _3298.y) * _3222;
                  [branch]
                  if (_3443 > 0.0f) {
                    _3446 = dot(float3(_3243, _3244, _3245), float3(_3243, _3244, _3245));
                    _3447 = rsqrt(_3446);
                    _3448 = _3447 * _3243;
                    _3449 = _3447 * _3244;
                    _3450 = _3447 * _3245;
                    _3451 = dot(float3(_190, _191, _192), float3(_3448, _3449, _3450));
                    if (_3272 > 0.0f) {
                      _3459 = sqrt(saturate((_3272 * _3272) * (1.0f / (_3446 + 1.0f))));
                      if (_3451 < _3459) {
                        _3464 = max(_3451, (-0.0f - _3459)) + _3459;
                        _3469 = ((_3464 * _3464) / (_3459 * 4.0f));
                      } else {
                        _3469 = _3451;
                      }
                    } else {
                      _3469 = _3451;
                    }
                    _3470 = _218 * _218;
                    _3474 = saturate((_3272 * (1.0f - _3470)) * _3447);
                    _3476 = saturate(_3447 * f16tof32(_3251));
                    _3477 = dot(float3(_190, _191, _192), float3(_451, _452, _450));
                    _3478 = dot(float3(_451, _452, _450), float3(_3448, _3449, _3450));
                    _3481 = rsqrt((_3478 * 2.0f) + 2.0f);
                    _3488 = (_3474 > 0.0f);
                    if (_3488) {
                      _3492 = sqrt(1.0f - (_3474 * _3474));
                      _3494 = (_3451 * 2.0f) * _3477;
                      _3495 = _3494 - _3478;
                      if (!(_3495 >= _3492)) {
                        _3503 = rsqrt(1.0f - (_3495 * _3495)) * _3474;
                        _3506 = _3503 * (_3477 - (_3495 * _3451));
                        _3507 = _3477 * _3477;
                        _3512 = _3503 * (((_3507 * 2.0f) + -1.0f) - (_3495 * _3478));
                        _3521 = sqrt(saturate((((1.0f - (_3451 * _3451)) - _3507) - (_3478 * _3478)) + (_3494 * _3478)));
                        _3522 = _3521 * _3503;
                        _3525 = ((_3477 * 2.0f) * _3503) * _3521;
                        _3527 = (_3492 * _3451) + _3477;
                        _3528 = _3527 + _3506;
                        _3529 = _3492 * _3478;
                        _3531 = (_3529 + 1.0f) + _3512;
                        _3532 = _3522 * _3531;
                        _3533 = _3528 * _3531;
                        _3534 = _3525 * _3528;
                        _3539 = (((_3528 * 0.25f) * _3525) - (_3532 * 0.5f)) * _3533;
                        _3553 = (((_3534 - (_3532 * 2.0f)) * _3534) + (_3532 * _3532)) + ((((-0.5f - ((_3531 + _3529) * 0.5f)) * _3533) + ((_3531 * _3531) * _3527)) * _3528);
                        _3558 = (_3539 * 2.0f) / ((_3553 * _3553) + (_3539 * _3539));
                        _3559 = _3553 * _3558;
                        _3561 = 1.0f - (_3539 * _3558);
                        _3567 = ((_3559 * _3525) + _3529) + (_3561 * _3512);
                        _3570 = rsqrt((_3567 * 2.0f) + 2.0f);
                        _3579 = saturate((_3567 * _3570) + _3570);
                        _3580 = saturate(((_3527 + (_3559 * _3522)) + (_3561 * _3506)) * _3570);
                      } else {
                        _3579 = abs(_3477);
                        _3580 = 1.0f;
                      }
                    } else {
                      _3579 = saturate((_3481 * _3478) + _3481);
                      _3580 = saturate(_3481 * (_3477 + _3451));
                    }
                    _3581 = saturate(_3469);
                    _3582 = _3470 * _3470;
                    if (_3476 > 0.0f) {
                      _3592 = saturate(((_3476 * _3476) / ((_3579 * 3.5999999046325684f) + 0.4000000059604645f)) + _3582);
                    } else {
                      _3592 = _3582;
                    }
                    _3593 = sqrt(_3592);
                    if (_3488) {
                      _3604 = (_3592 / ((((_3474 * 0.25f) * ((_3593 * 3.0f) + _3474)) / (_3579 + 0.0010000000474974513f)) + _3592));
                    } else {
                      _3604 = 1.0f;
                    }
                    _3608 = (((_3592 * _3580) - _3580) * _3580) + 1.0f;
                    _3618 = exp2(log2(1.0f - saturate(_3579)) * 5.0f);
                    _3627 = saturate(abs(_3477) + 9.999999747378752e-06f);
                    _3628 = 1.0f - _3593;
                    _3640 = saturate((_3451 + _3270) / (_3270 + 1.0f));
                    _3643 = ((_3604 * _3581) * (_3592 / (_3608 * _3608))) * (0.5f / ((((_3628 * _3627) + _3593) * _3581) + (((_3628 * _3581) + _3593) * _3627)));
                    [branch]
                    if (!((_3257 & 1) == 0)) {
                      _3656 = max(max(_3416, _3417), _3418);
                      if (_3656 > 0.0f) {
                        _3666 = saturate(_3416 / _3656);
                        _3667 = saturate(_3417 / _3656);
                        _3668 = saturate(_3418 / _3656);
                      } else {
                        _3666 = _3416;
                        _3667 = _3417;
                        _3668 = _3418;
                      }
                      _3669 = (_3667 < _3668);
                      _3670 = select(_3669, _3668, _3667);
                      _3671 = select(_3669, _3667, _3668);
                      _3672 = select(_3669, -1.0f, 0.0f);
                      _3673 = (_3666 < _3670);
                      _3675 = select(_3673, _3670, _3666);
                      _3676 = select(_3673, _3666, _3670);
                      _3680 = _3675 - select((_3676 < _3671), _3676, _3671);
                      _3686 = abs(select(_3673, (-0.3333333432674408f - _3672), _3672) + ((_3676 - _3671) / ((_3680 * 6.0f) + 9.999999682655225e-21f)));
                      if (_3686 < 0.6666666865348816f) {
                        _3699 = ((saturate(((float)((uint)((uint)(((uint)(_3257) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3686 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3686)) + _3686);
                      } else {
                        _3699 = _3686;
                      }
                      _3700 = saturate((_3680 / (_3675 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3257) >> 1) & 255)))) * 0.003921499941498041f));
                      _3701 = saturate(_3675);
                      if (!(_3700 <= 0.0f)) {
                        _3704 = saturate(_3699);
                        _3708 = select(((_3704 * 360.0f) >= 360.0f), 0.0f, (_3704 * 6.0f));
                        _3709 = int(_3708);
                        _3711 = _3708 - float((int)(_3709));
                        _3713 = _3701 * (1.0f - _3700);
                        _3716 = (1.0f - (_3711 * _3700)) * _3701;
                        _3720 = (1.0f - ((1.0f - _3711) * _3700)) * _3701;
                        switch (_3709) {
                          case 0: {
                            _3728 = _3701;
                            _3729 = _3720;
                            _3730 = _3713;
                            break;
                          }
                          case 1: {
                            _3728 = _3716;
                            _3729 = _3701;
                            _3730 = _3713;
                            break;
                          }
                          case 2: {
                            _3728 = _3713;
                            _3729 = _3701;
                            _3730 = _3720;
                            break;
                          }
                          case 3: {
                            _3728 = _3713;
                            _3729 = _3716;
                            _3730 = _3701;
                            break;
                          }
                          case 4: {
                            _3728 = _3720;
                            _3729 = _3713;
                            _3730 = _3701;
                            break;
                          }
                          case 5: {
                            _3728 = _3701;
                            _3729 = _3713;
                            _3730 = _3716;
                            break;
                          }
                          default: {
                            _3728 = 0.0f;
                            _3729 = 0.0f;
                            _3730 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _3728 = _3701;
                        _3729 = _3701;
                        _3730 = _3701;
                      }
                      _3731 = _3728 * _3656;
                      _3732 = _3729 * _3656;
                      _3733 = _3730 * _3656;
                      _3735 = saturate(_3443 * 1.0101009607315063f);
                      _3746 = ((_3735 * (_3416 - _3731)) + _3731);
                      _3747 = ((_3735 * (_3417 - _3732)) + _3732);
                      _3748 = (lerp(_3733, _3418, _3735));
                    } else {
                      _3746 = _3416;
                      _3747 = _3417;
                      _3748 = _3418;
                    }
                    _3749 = _3746 * _3443;
                    _3750 = _3747 * _3443;
                    _3751 = _3748 * _3443;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _3761 = (_3749 * _1280);
                      _3762 = (_3750 * _1280);
                      _3763 = (_3751 * _1280);
                    } else {
                      _3761 = _3749;
                      _3762 = _3750;
                      _3763 = _3751;
                    }
                    _3767 = (_3761 * _3640) + _1608;
                    _3768 = (_3762 * _3640) + _1609;
                    _3769 = (_3763 * _3640) + _1610;
                    if ((_3266 * 0.003921499941498041f) > 0.0f) {
                      _3772 = (_1367 * 0.003921499941498041f) * _3266;
                      _8848 = _3767;
                      _8849 = _3768;
                      _8850 = _3769;
                      _8851 = (((((_3772 * _1143) * ((_3618 * (1.0f - _210)) + _210)) * _3643) * _3761) + _3438);
                      _8852 = (((((_3772 * _1144) * ((_3618 * (1.0f - _211)) + _211)) * _3643) * _3762) + _3439);
                      _8853 = (((((_3772 * _1145) * ((_3618 * (1.0f - _212)) + _212)) * _3643) * _3763) + _3440);
                    } else {
                      _8848 = _3767;
                      _8849 = _3768;
                      _8850 = _3769;
                      _8851 = _3438;
                      _8852 = _3439;
                      _8853 = _3440;
                    }
                  } else {
                    _8848 = _1608;
                    _8849 = _1609;
                    _8850 = _1610;
                    _8851 = _3438;
                    _8852 = _3439;
                    _8853 = _3440;
                  }
                } else {
                  _8848 = _1608;
                  _8849 = _1609;
                  _8850 = _1610;
                  _8851 = _1611;
                  _8852 = _1612;
                  _8853 = _1613;
                }
              } else {
                _1671 = _1651 * select(((_1620 & 67108864) != 0), 1.0f, (1.0f - _1603));
                [branch]
                if (_1654 == 4) {
                  _1676 = asfloat(srvLightInfoProperties.Load4(_1622)).x;
                  _1677 = asfloat(srvLightInfoProperties.Load4(_1622)).y;
                  _1678 = asfloat(srvLightInfoProperties.Load4(_1622)).z;
                  _1679 = asfloat(srvLightInfoProperties.Load4(_1622)).w;
                  _1682 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).x;
                  _1683 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).y;
                  _1684 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).z;
                  _1685 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).w;
                  _1688 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).x;
                  _1689 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).y;
                  _1690 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).z;
                  _1691 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).w;
                  _1694 = asint(srvLightInfoProperties.Load(((int)(_1622 + 48u))));
                  _1697 = asint(srvLightInfoProperties.Load(((int)(_1622 + 52u))));
                  _1700 = asint(srvLightInfoProperties.Load(((int)(_1622 + 64u))));
                  _1703 = asint(srvLightInfoProperties.Load(((int)(_1622 + 68u))));
                  _1706 = asint(srvLightInfoProperties.Load(((int)(_1622 + 72u))));
                  _1708 = f16tof32(((uint)((uint)(_1694) >> 16)));
                  _1709 = f16tof32(_1694);
                  _1711 = f16tof32(((uint)((uint)(_1697) >> 16)));
                  _1715 = ((float)((uint)((uint)(((uint)(_1697) >> 8) & 255)))) * 0.003921499941498041f;
                  _1728 = mad(_1678, _231, mad(_1677, _230, (_1676 * _229))) + _1679;
                  _1732 = mad(_1684, _231, mad(_1683, _230, (_1682 * _229))) + _1685;
                  _1736 = mad(_1690, _231, mad(_1689, _230, (_1688 * _229))) + _1691;
                  _1761 = saturate(1.0f - ((_1728 + 1.0f) * f16tof32(_1700))) + saturate(1.0f - ((1.0f - _1728) * f16tof32(((uint)((uint)(_1700) >> 16)))));
                  _1762 = saturate(1.0f - ((_1732 + 1.0f) * f16tof32(_1703))) + saturate(1.0f - ((1.0f - _1732) * f16tof32(((uint)((uint)(_1703) >> 16)))));
                  _1763 = saturate(1.0f - ((_1736 + 1.0f) * f16tof32(_1706))) + saturate(1.0f - ((1.0f - _1736) * f16tof32(((uint)((uint)(_1706) >> 16)))));
                  _1766 = saturate(1.0f - dot(float3(_1761, _1762, _1763), float3(_1761, _1762, _1763)));
                  _1767 = _1766 * _1766;
                  _1774 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1767 * _1280), _1767) * _1671;
                  _8848 = ((_1774 * _1708) + _1608);
                  _8849 = ((_1774 * _1709) + _1609);
                  _8850 = ((_1774 * _1711) + _1610);
                  _8851 = (((_1715 * _1708) * _1774) + _1611);
                  _8852 = (((_1715 * _1709) * _1774) + _1612);
                  _8853 = (((_1711 * _1715) * _1774) + _1613);
                } else {
                  if (_1654 == 5) {
                    _1795 = asfloat(srvLightInfoProperties.Load4(_1622)).x;
                    _1796 = asfloat(srvLightInfoProperties.Load4(_1622)).y;
                    _1797 = asfloat(srvLightInfoProperties.Load4(_1622)).z;
                    _1798 = asfloat(srvLightInfoProperties.Load4(_1622)).w;
                    _1801 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).x;
                    _1802 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).y;
                    _1803 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).z;
                    _1804 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).w;
                    _1807 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).x;
                    _1808 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).y;
                    _1809 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).z;
                    _1810 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).w;
                    _1813 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).x;
                    _1814 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).y;
                    _1815 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).z;
                    _1818 = asfloat(srvLightInfoProperties.Load(((int)(_1622 + 60u))));
                    _1821 = asint(srvLightInfoProperties.Load(((int)(_1622 + 64u))));
                    _1824 = asint(srvLightInfoProperties.Load(((int)(_1622 + 68u))));
                    _1827 = asint(srvLightInfoProperties.Load(((int)(_1622 + 80u))));
                    _1830 = asint(srvLightInfoProperties.Load(((int)(_1622 + 84u))));
                    _1833 = asint(srvLightInfoProperties.Load(((int)(_1622 + 88u))));
                    _1836 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 92u)))).x;
                    _1837 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 92u)))).y;
                    _1838 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 92u)))).z;
                    _1839 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 92u)))).w;
                    _1842 = asint(srvLightInfoProperties.Load(((int)(_1622 + 108u))));
                    _1845 = asint(srvLightInfoProperties.Load(((int)(_1622 + 112u))));
                    _1848 = asint(srvLightInfoProperties.Load(((int)(_1622 + 120u))));
                    _1851 = asint(srvLightInfoProperties.Load(((int)(_1622 + 124u))));
                    _1854 = asint(srvLightInfoProperties.Load(((int)(_1622 + 128u))));
                    _1857 = asint(srvLightInfoProperties.Load(((int)(_1622 + 132u))));
                    _1860 = asint(srvLightInfoProperties.Load(((int)(_1622 + 136u))));
                    _1863 = asint(srvLightInfoProperties.Load(((int)(_1622 + 140u))));
                    _1865 = f16tof32(((uint)((uint)(_1821) >> 16)));
                    _1866 = f16tof32(_1821);
                    _1868 = f16tof32(((uint)((uint)(_1824) >> 16)));
                    _1872 = ((float)((uint)((uint)(((uint)(_1824) >> 8) & 255)))) * 0.003921499941498041f;
                    _1875 = ((float)((uint)((uint)(_1824 & 255)))) * 0.003921499941498041f;
                    _1877 = f16tof32(((uint)((uint)(_1827) >> 16)));
                    _1880 = _1830 & 65535;
                    _1890 = f16tof32(((uint)((uint)(_1845) >> 16)));
                    _1891 = f16tof32(_1845);
                    _1893 = f16tof32(((uint)((uint)(_1848) >> 16)));
                    _1894 = 1.0f / _1893;
                    _1895 = _1893 + -1.0f;
                    _1896 = f16tof32(_1848);
                    _1915 = saturate(1.0f - dot(float3(_190, _191, _192), float3(_1813, _1814, _1815))) * f16tof32(_1842);
                    _1919 = (_1915 * _190) + _229;
                    _1920 = (_1915 * _191) + _230;
                    _1921 = (_1915 * _192) - _228;
                    _1925 = mad(_1797, _1921, mad(_1796, _1920, (_1919 * _1795))) + _1798;
                    _1929 = mad(_1803, _1921, mad(_1802, _1920, (_1919 * _1801))) + _1804;
                    _1933 = mad(_1809, _1921, mad(_1808, _1920, (_1919 * _1807))) + _1810;
                    _1934 = saturate(_1933);
                    _1957 = saturate(1.0f - (_1925 * f16tof32(_1857))) + saturate(1.0f - ((1.0f - _1925) * f16tof32(((uint)((uint)(_1857) >> 16)))));
                    _1958 = saturate(1.0f - (_1929 * f16tof32(_1860))) + saturate(1.0f - ((1.0f - _1929) * f16tof32(((uint)((uint)(_1860) >> 16)))));
                    _1959 = saturate(1.0f - (_1933 * f16tof32(_1863))) + saturate(1.0f - ((1.0f - _1933) * f16tof32(((uint)((uint)(_1863) >> 16)))));
                    _1962 = saturate(1.0f - dot(float3(_1957, _1958, _1959), float3(_1957, _1958, _1959)));
                    _1963 = _1962 * _1962;
                    _1965 = ((_1620 & 3584) == 0);
                    if (!((!(_1963 > 0.0f)) || _1965)) {
                      _1970 = 1.0f - _1934;
                      _1971 = saturate(_1925);
                      _1972 = saturate(_1929);
                      bool __branch_chain_1967;
                      [branch]
                      if ((_1620 & 1024) == 0) {
                        _2285 = 1.0f;
                        _2286 = 1.0f;
                        _2287 = 0.0f;
                        _2288 = _1970;
                        __branch_chain_1967 = true;
                      } else {
                        _1977 = ((_1971 * _1895) + 0.5f) * _1894;
                        _1979 = ((_1972 * _1895) + 0.5f) * _1894;
                        _1980 = _1970 + f16tof32(((uint)((uint)(_1842) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1830) >> 16))];
                        _1983 = saturate(_1980);
                        _1987 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1996 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1987 * 32.665000915527344f) + _127), ((_1987 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1997 = sin(_1996);
                        _1998 = cos(_1996);
                        _1999 = cbSharedPerViewData.nFrameCounter & 3;
                        _2004 = sqrt((float((int)(_1999)) * 0.25f) + 0.125f) * _1890;
                        _2013 = (_global_7[min((uint)(((int)(0u + (_1999 * 2)))), 127u)]) * _2004;
                        _2014 = (_global_7[min((uint)(((int)(1u + (_1999 * 2)))), 127u)]) * _2004;
                        _2016 = -0.0f - _1997;
                        _2021 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2013, _2014), float2(_1998, _1997)) + _1977), (dot(float2(_2013, _2014), float2(_2016, _1998)) + _1979)));
                        _2026 = _2021.x - _1983;
                        _2028 = select((_2026 < 0.0f), 0.0f, 1.0f);
                        _2030 = _2021.y - _1983;
                        _2032 = select((_2030 < 0.0f), 0.0f, 1.0f);
                        _2036 = _2021.z - _1983;
                        _2038 = select((_2036 < 0.0f), 0.0f, 1.0f);
                        _2042 = _2021.w - _1983;
                        _2044 = select((_2042 < 0.0f), 0.0f, 1.0f);
                        _2051 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _2056 = sqrt((float((int)(_2051)) * 0.25f) + 0.125f) * _1890;
                        _2065 = (_global_7[min((uint)(((int)(0u + (_2051 * 2)))), 127u)]) * _2056;
                        _2066 = (_global_7[min((uint)(((int)(1u + (_2051 * 2)))), 127u)]) * _2056;
                        _2072 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2065, _2066), float2(_1998, _1997)) + _1977), (dot(float2(_2065, _2066), float2(_2016, _1998)) + _1979)));
                        _2077 = _2072.x - _1983;
                        _2079 = select((_2077 < 0.0f), 0.0f, 1.0f);
                        _2083 = _2072.y - _1983;
                        _2085 = select((_2083 < 0.0f), 0.0f, 1.0f);
                        _2089 = _2072.z - _1983;
                        _2091 = select((_2089 < 0.0f), 0.0f, 1.0f);
                        _2095 = _2072.w - _1983;
                        _2097 = select((_2095 < 0.0f), 0.0f, 1.0f);
                        _2104 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _2109 = sqrt((float((int)(_2104)) * 0.25f) + 0.125f) * _1890;
                        _2118 = (_global_7[min((uint)(((int)(0u + (_2104 * 2)))), 127u)]) * _2109;
                        _2119 = (_global_7[min((uint)(((int)(1u + (_2104 * 2)))), 127u)]) * _2109;
                        _2125 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2118, _2119), float2(_1998, _1997)) + _1977), (dot(float2(_2118, _2119), float2(_2016, _1998)) + _1979)));
                        _2130 = _2125.x - _1983;
                        _2132 = select((_2130 < 0.0f), 0.0f, 1.0f);
                        _2136 = _2125.y - _1983;
                        _2138 = select((_2136 < 0.0f), 0.0f, 1.0f);
                        _2142 = _2125.z - _1983;
                        _2144 = select((_2142 < 0.0f), 0.0f, 1.0f);
                        _2148 = _2125.w - _1983;
                        _2150 = select((_2148 < 0.0f), 0.0f, 1.0f);
                        _2157 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _2162 = sqrt((float((int)(_2157)) * 0.25f) + 0.125f) * _1890;
                        _2171 = (_global_7[min((uint)(((int)(0u + (_2157 * 2)))), 127u)]) * _2162;
                        _2172 = (_global_7[min((uint)(((int)(1u + (_2157 * 2)))), 127u)]) * _2162;
                        _2178 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2171, _2172), float2(_1998, _1997)) + _1977), (dot(float2(_2171, _2172), float2(_2016, _1998)) + _1979)));
                        _2183 = _2178.x - _1983;
                        _2185 = select((_2183 < 0.0f), 0.0f, 1.0f);
                        _2189 = _2178.y - _1983;
                        _2191 = select((_2189 < 0.0f), 0.0f, 1.0f);
                        _2195 = _2178.z - _1983;
                        _2197 = select((_2195 < 0.0f), 0.0f, 1.0f);
                        _2201 = _2178.w - _1983;
                        _2203 = select((_2201 < 0.0f), 0.0f, 1.0f);
                        _2204 = ((((((((((((((_2028 + _2032) + _2038) + _2044) + _2079) + _2085) + _2091) + _2097) + _2132) + _2138) + _2144) + _2150) + _2185) + _2191) + _2197) + _2203;
                        _2215 = (saturate(_2204 * 0.0625f) * 2.0f) + -1.0f;
                        _2221 = float((int)(((int)(uint)((int)(_2215 > 0.0f))) - ((int)(uint)((int)(_2215 < 0.0f)))));
                        _2223 = 1.0f - (_2221 * _2215);
                        _2225 = (_2223 * _2223) * _2223;
                        _2232 = 0.5f - ((_2221 * 0.5f) * ((1.0f - _2225) - ((_2223 - _2225) * saturate(((1.0f / _1983) * (1.0f / _2204)) * ((((((((((((((((_2028 * _2026) + (_2032 * _2030)) + (_2038 * _2036)) + (_2044 * _2042)) + (_2079 * _2077)) + (_2085 * _2083)) + (_2091 * _2089)) + (_2097 * _2095)) + (_2132 * _2130)) + (_2138 * _2136)) + (_2144 * _2142)) + (_2150 * _2148)) + (_2185 * _2183)) + (_2191 * _2189)) + (_2197 * _2195)) + (_2203 * _2201))))));
                        _2237 = frac((_1977 * _1893) + 0.5f);
                        _2238 = frac((_1979 * _1893) + 0.5f);
                        _2239 = _1977 + _1894;
                        _2240 = _1979 + _1894;
                        _2242 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2239, _2240), _1980);
                        _2250 = _1894 * 2.0f;
                        _2251 = _2239 - _2250;
                        _2252 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2251, _2240), _1980);
                        _2257 = 1.0f - _2237;
                        _2262 = _2240 - _2250;
                        _2263 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2251, _2262), _1980);
                        _2268 = 1.0f - _2238;
                        _2273 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2239, _2262), _1980);
                        _2282 = (((mad(mad(_2252.x, _2257, _2252.y), _2238, mad(_2252.w, _2257, _2252.z)) + mad(mad(_2242.y, _2237, _2242.x), _2238, mad(_2242.z, _2237, _2242.w))) + mad(mad(_2263.w, _2257, _2263.z), _2268, mad(_2263.x, _2257, _2263.y))) + mad(mad(_2273.z, _2237, _2273.w), _2268, mad(_2273.y, _2237, _2273.x))) * 0.1111111119389534f;
                        [branch]
                        if (_1896 < 1.0f) {
                          _2285 = _2232;
                          _2286 = _2282;
                          _2287 = _1896;
                          _2288 = _1980;
                          __branch_chain_1967 = true;
                        } else {
                          _2756 = _2282;
                          _2757 = _1896;
                          _2758 = _2232;
                          __branch_chain_1967 = false;
                        }
                      }
                      if (__branch_chain_1967) {
                        _2291 = (_1971 * _1836) + _1838;
                        _2292 = (_1972 * _1837) + _1839;
                        if (!((_1620 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _2301 = saturate(_2288);
                          _2305 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2314 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2305 * 32.665000915527344f) + _127), ((_2305 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2315 = sin(_2314);
                          _2316 = cos(_2314);
                          _2321 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2291, _2292), 0.0f))).x) > _2301), 1.0f, 0.0f);
                          _2322 = cbSharedPerViewData.nFrameCounter & 3;
                          _2327 = sqrt((float((int)(_2322)) * 0.25f) + 0.125f) * _1891;
                          _2336 = (_global_7[min((uint)(((int)(0u + (_2322 * 2)))), 127u)]) * _2327;
                          _2337 = (_global_7[min((uint)(((int)(1u + (_2322 * 2)))), 127u)]) * _2327;
                          _2339 = -0.0f - _2315;
                          _2341 = dot(float2(_2336, _2337), float2(_2316, _2315)) + _2291;
                          _2342 = dot(float2(_2336, _2337), float2(_2339, _2316)) + _2292;
                          _2344 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2341, _2342));
                          _2348 = _2341 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2349 = _2342 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2352 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1838);
                          _2353 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1839);
                          _2358 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1836 + _1838)) + 0.5f);
                          _2359 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1837 + _1839)) + 0.5f);
                          _2362 = floor(_2348 + -0.5f);
                          _2363 = floor(_2349 + 0.5f);
                          _2365 = floor(_2348 + 0.5f);
                          _2367 = floor(_2349 + -0.5f);
                          _2368 = (_2362 < _2352);
                          _2369 = (_2363 < _2353);
                          if ((_2368 || _2369) | ((_2362 >= _2358) || (_2363 >= _2359))) {
                            _2378 = _2321;
                          } else {
                            _2378 = _2344.x;
                          }
                          _2379 = (_2365 < _2352);
                          if ((_2379 || _2369) | ((_2365 >= _2358) || (_2363 >= _2359))) {
                            _2387 = _2321;
                          } else {
                            _2387 = _2344.y;
                          }
                          _2388 = (_2367 < _2353);
                          if ((_2379 || _2388) | ((_2365 >= _2358) || (_2367 >= _2359))) {
                            _2396 = _2321;
                          } else {
                            _2396 = _2344.z;
                          }
                          if ((_2368 || _2388) | ((_2362 >= _2358) || (_2367 >= _2359))) {
                            _2404 = _2321;
                          } else {
                            _2404 = _2344.w;
                          }
                          _2405 = _2378 - _2301;
                          _2407 = select((_2405 < 0.0f), 0.0f, 1.0f);
                          _2409 = _2387 - _2301;
                          _2411 = select((_2409 < 0.0f), 0.0f, 1.0f);
                          _2415 = _2396 - _2301;
                          _2417 = select((_2415 < 0.0f), 0.0f, 1.0f);
                          _2421 = _2404 - _2301;
                          _2423 = select((_2421 < 0.0f), 0.0f, 1.0f);
                          _2430 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2435 = sqrt((float((int)(_2430)) * 0.25f) + 0.125f) * _1891;
                          _2444 = (_global_7[min((uint)(((int)(0u + (_2430 * 2)))), 127u)]) * _2435;
                          _2445 = (_global_7[min((uint)(((int)(1u + (_2430 * 2)))), 127u)]) * _2435;
                          _2448 = dot(float2(_2444, _2445), float2(_2316, _2315)) + _2291;
                          _2449 = dot(float2(_2444, _2445), float2(_2339, _2316)) + _2292;
                          _2451 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2448, _2449));
                          _2455 = _2448 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2456 = _2449 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2459 = floor(_2455 + -0.5f);
                          _2460 = floor(_2456 + 0.5f);
                          _2462 = floor(_2455 + 0.5f);
                          _2464 = floor(_2456 + -0.5f);
                          _2465 = (_2459 < _2352);
                          _2466 = (_2460 < _2353);
                          if ((_2465 || _2466) | ((_2459 >= _2358) || (_2460 >= _2359))) {
                            _2475 = _2321;
                          } else {
                            _2475 = _2451.x;
                          }
                          _2476 = (_2462 < _2352);
                          if ((_2476 || _2466) | ((_2462 >= _2358) || (_2460 >= _2359))) {
                            _2484 = _2321;
                          } else {
                            _2484 = _2451.y;
                          }
                          _2485 = (_2464 < _2353);
                          if ((_2476 || _2485) | ((_2462 >= _2358) || (_2464 >= _2359))) {
                            _2493 = _2321;
                          } else {
                            _2493 = _2451.z;
                          }
                          if ((_2465 || _2485) | ((_2459 >= _2358) || (_2464 >= _2359))) {
                            _2501 = _2321;
                          } else {
                            _2501 = _2451.w;
                          }
                          _2502 = _2475 - _2301;
                          _2504 = select((_2502 < 0.0f), 0.0f, 1.0f);
                          _2508 = _2484 - _2301;
                          _2510 = select((_2508 < 0.0f), 0.0f, 1.0f);
                          _2514 = _2493 - _2301;
                          _2516 = select((_2514 < 0.0f), 0.0f, 1.0f);
                          _2520 = _2501 - _2301;
                          _2522 = select((_2520 < 0.0f), 0.0f, 1.0f);
                          _2529 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2534 = sqrt((float((int)(_2529)) * 0.25f) + 0.125f) * _1891;
                          _2543 = (_global_7[min((uint)(((int)(0u + (_2529 * 2)))), 127u)]) * _2534;
                          _2544 = (_global_7[min((uint)(((int)(1u + (_2529 * 2)))), 127u)]) * _2534;
                          _2547 = dot(float2(_2543, _2544), float2(_2316, _2315)) + _2291;
                          _2548 = dot(float2(_2543, _2544), float2(_2339, _2316)) + _2292;
                          _2550 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2547, _2548));
                          _2554 = _2547 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2555 = _2548 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2558 = floor(_2554 + -0.5f);
                          _2559 = floor(_2555 + 0.5f);
                          _2561 = floor(_2554 + 0.5f);
                          _2563 = floor(_2555 + -0.5f);
                          _2564 = (_2558 < _2352);
                          _2565 = (_2559 < _2353);
                          if ((_2564 || _2565) | ((_2558 >= _2358) || (_2559 >= _2359))) {
                            _2574 = _2321;
                          } else {
                            _2574 = _2550.x;
                          }
                          _2575 = (_2561 < _2352);
                          if ((_2575 || _2565) | ((_2561 >= _2358) || (_2559 >= _2359))) {
                            _2583 = _2321;
                          } else {
                            _2583 = _2550.y;
                          }
                          _2584 = (_2563 < _2353);
                          if ((_2575 || _2584) | ((_2561 >= _2358) || (_2563 >= _2359))) {
                            _2592 = _2321;
                          } else {
                            _2592 = _2550.z;
                          }
                          if ((_2564 || _2584) | ((_2558 >= _2358) || (_2563 >= _2359))) {
                            _2600 = _2321;
                          } else {
                            _2600 = _2550.w;
                          }
                          _2601 = _2574 - _2301;
                          _2603 = select((_2601 < 0.0f), 0.0f, 1.0f);
                          _2607 = _2583 - _2301;
                          _2609 = select((_2607 < 0.0f), 0.0f, 1.0f);
                          _2613 = _2592 - _2301;
                          _2615 = select((_2613 < 0.0f), 0.0f, 1.0f);
                          _2619 = _2600 - _2301;
                          _2621 = select((_2619 < 0.0f), 0.0f, 1.0f);
                          _2628 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2633 = sqrt((float((int)(_2628)) * 0.25f) + 0.125f) * _1891;
                          _2642 = (_global_7[min((uint)(((int)(0u + (_2628 * 2)))), 127u)]) * _2633;
                          _2643 = (_global_7[min((uint)(((int)(1u + (_2628 * 2)))), 127u)]) * _2633;
                          _2646 = dot(float2(_2642, _2643), float2(_2316, _2315)) + _2291;
                          _2647 = dot(float2(_2642, _2643), float2(_2339, _2316)) + _2292;
                          _2649 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2646, _2647));
                          _2653 = _2646 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2654 = _2647 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2657 = floor(_2653 + -0.5f);
                          _2658 = floor(_2654 + 0.5f);
                          _2660 = floor(_2653 + 0.5f);
                          _2662 = floor(_2654 + -0.5f);
                          _2663 = (_2657 < _2352);
                          _2664 = (_2658 < _2353);
                          if ((_2663 || _2664) | ((_2657 >= _2358) || (_2658 >= _2359))) {
                            _2673 = _2321;
                          } else {
                            _2673 = _2649.x;
                          }
                          _2674 = (_2660 < _2352);
                          if ((_2674 || _2664) | ((_2660 >= _2358) || (_2658 >= _2359))) {
                            _2682 = _2321;
                          } else {
                            _2682 = _2649.y;
                          }
                          _2683 = (_2662 < _2353);
                          if ((_2674 || _2683) | ((_2660 >= _2358) || (_2662 >= _2359))) {
                            _2691 = _2321;
                          } else {
                            _2691 = _2649.z;
                          }
                          if ((_2663 || _2683) | ((_2657 >= _2358) || (_2662 >= _2359))) {
                            _2699 = _2321;
                          } else {
                            _2699 = _2649.w;
                          }
                          _2700 = _2673 - _2301;
                          _2702 = select((_2700 < 0.0f), 0.0f, 1.0f);
                          _2706 = _2682 - _2301;
                          _2708 = select((_2706 < 0.0f), 0.0f, 1.0f);
                          _2712 = _2691 - _2301;
                          _2714 = select((_2712 < 0.0f), 0.0f, 1.0f);
                          _2718 = _2699 - _2301;
                          _2720 = select((_2718 < 0.0f), 0.0f, 1.0f);
                          _2721 = ((((((((((((((_2411 + _2407) + _2417) + _2423) + _2504) + _2510) + _2516) + _2522) + _2603) + _2609) + _2615) + _2621) + _2702) + _2708) + _2714) + _2720;
                          _2732 = (saturate(_2721 * 0.0625f) * 2.0f) + -1.0f;
                          _2738 = float((int)(((int)(uint)((int)(_2732 > 0.0f))) - ((int)(uint)((int)(_2732 < 0.0f)))));
                          _2740 = 1.0f - (_2738 * _2732);
                          _2742 = (_2740 * _2740) * _2740;
                          _2751 = (0.5f - ((_2738 * 0.5f) * ((1.0f - _2742) - ((_2740 - _2742) * saturate(((1.0f / _2301) * (1.0f / _2721)) * ((((((((((((((((_2411 * _2409) + (_2407 * _2405)) + (_2417 * _2415)) + (_2423 * _2421)) + (_2504 * _2502)) + (_2510 * _2508)) + (_2516 * _2514)) + (_2522 * _2520)) + (_2603 * _2601)) + (_2609 * _2607)) + (_2615 * _2613)) + (_2621 * _2619)) + (_2702 * _2700)) + (_2708 * _2706)) + (_2714 * _2712)) + (_2720 * _2718)))))));
                        } else {
                          _2751 = 1.0f;
                        }
                        _2756 = _2286;
                        _2757 = _2287;
                        _2758 = (lerp(_2751, _2285, _2287));
                      }
                      [branch]
                      if (!((_1620 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1833) >> 16))];
                        _2764 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1925, _1929), 0.0f);
                        if (_2764.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1833 & 65535))];
                          _2771 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1925, _1929), 0.0f);
                          _2785 = mad(saturate(((log2(_1934 * _1818) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2786 = max(9.999999747378752e-06f, _2764.x);
                          _2787 = _2771.x / _2786;
                          _2788 = _2771.y / _2786;
                          _2790 = _2771.w / _2786;
                          _2795 = ((0.375f - _2788) * 4.999999873689376e-06f) + _2788;
                          _2798 = -0.0f - _2787;
                          _2799 = mad(_2798, _2795, (_2771.z / _2786));
                          _2801 = 1.0f / mad(_2798, _2787, _2795);
                          _2802 = _2801 * _2799;
                          _2807 = _2785 - _2787;
                          _2812 = (((_2785 * _2785) - _2795) - (_2802 * _2807)) / mad((-0.0f - _2799), _2802, mad((-0.0f - _2795), _2795, (((0.375f - _2790) * 4.999999873689376e-06f) + _2790)));
                          _2814 = (_2801 * _2807) - (_2812 * _2802);
                          _2817 = 1.0f / _2812;
                          _2818 = _2814 * _2817;
                          _2823 = sqrt(((_2818 * _2818) * 0.25f) - ((1.0f - dot(float2(_2814, _2812), float2(_2787, _2795))) * _2817));
                          _2825 = (_2818 * -0.5f) - _2823;
                          _2827 = _2823 - (_2818 * 0.5f);
                          _2829 = select((_2825 < _2785), 1.0f, 0.0f);
                          _2834 = (_2829 + -0.05000000074505806f) / (_2825 - _2785);
                          _2840 = (((select((_2827 < _2785), 1.0f, 0.0f) - _2829) / (_2827 - _2825)) - _2834) / (_2827 - _2785);
                          _2842 = _2834 - (_2840 * _2825);
                          _2855 = _2757;
                          _2856 = (exp2((_2764.x * -1.4426950216293335f) * saturate((dot(float2(_2787, _2795), float2((_2842 - (_2840 * _2785)), _2840)) + 0.05000000074505806f) - (_2842 * _2785))) * _2758);
                          _2857 = _2756;
                        } else {
                          _2855 = _2757;
                          _2856 = _2758;
                          _2857 = _2756;
                        }
                      } else {
                        _2855 = _2757;
                        _2856 = _2758;
                        _2857 = _2756;
                      }
                    } else {
                      _2855 = 0.0f;
                      _2856 = 1.0f;
                      _2857 = 0.0f;
                    }
                    [branch]
                    if (!(_1880 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1880)))];
                      _2870 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1925 * f16tof32(((uint)((uint)(_1851) >> 16)))) + f16tof32(((uint)((uint)(_1854) >> 16)))), ((_1929 * f16tof32(_1851)) + f16tof32(_1854))), 0.0f);
                      _2878 = (_2870.x * _1865);
                      _2879 = (_2870.y * _1866);
                      _2880 = (_2870.z * _1868);
                    } else {
                      _2878 = _1865;
                      _2879 = _1866;
                      _2880 = _1868;
                    }
                    _2881 = _2856 * _1963;
                    [branch]
                    if (!(_2881 == 0.0f)) {
                      bool __branch_chain_2883;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2899 = 0;
                        __branch_chain_2883 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2899 = 1;
                          __branch_chain_2883 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2899 = 2;
                            __branch_chain_2883 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2899 = 3;
                              __branch_chain_2883 = true;
                            } else {
                              _2920 = _2881;
                              __branch_chain_2883 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2883) {
                        while(true) {
                          _2902 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                          if (_2899 == 0) {
                            _2916 = _2902.x;
                          } else {
                            if (_2899 == 1) {
                              _2916 = _2902.y;
                            } else {
                              if (_2899 == 2) {
                                _2916 = _2902.z;
                              } else {
                                _2916 = _2902.w;
                              }
                            }
                          }
                          _2920 = ((_2916 * _2916) * _1963);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2920 == 0.0f)) {
                          [branch]
                          if (!(_233 || _1965)) {
                            _2931 = ((_2855 * _1963) * _2857) * saturate(0.30000001192092896f - dot(float3(_1813, _1814, _1815), float3(_190, _191, _192)));
                            _2936 = (_2931 * _1292);
                            _2937 = (_2931 * _1293);
                            _2938 = (_2931 * _1294);
                          } else {
                            _2936 = 0.0f;
                            _2937 = 0.0f;
                            _2938 = 0.0f;
                          }
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2945 = srvLightMappingData[_1623];
                            if (!(_2945 == -1)) {
                              _2950 = srvLightIndexData[_2945].nLayerIndex;
                              _2952 = srvLightIndexData[_2945].vAtlasOrigin.x;
                              _2953 = srvLightIndexData[_2945].vAtlasOrigin.y;
                              _2955 = srvLightIndexData[_2945].vScreenOrigin.x;
                              _2956 = srvLightIndexData[_2945].vScreenOrigin.y;
                              _2965 = ((int)(_2950 * 5)) & 31;
                              _2974 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2952 + _65) - _2955)), ((int)((_2953 + _66) - _2956)), 0)))).x) & ((int)(31 << _2965)))) >> _2965)) >> 1)))) * 0.06666667014360428f) * _2920);
                            } else {
                              _2974 = _2920;
                            }
                          } else {
                            _2974 = _2920;
                          }
                          _2978 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2981 = select(_2978, (_2974 * _1280), _2974);
                          _2983 = dot(float3(_1813, _1814, _1815), float3(_1813, _1814, _1815));
                          _2984 = rsqrt(_2983);
                          _2985 = _2984 * _1813;
                          _2986 = _2984 * _1814;
                          _2987 = _2984 * _1815;
                          _2988 = dot(float3(_190, _191, _192), float3(_2985, _2986, _2987));
                          if (_1877 > 0.0f) {
                            _2996 = sqrt(saturate((_1877 * _1877) * (1.0f / (_2983 + 1.0f))));
                            if (_2988 < _2996) {
                              _3001 = max(_2988, (-0.0f - _2996)) + _2996;
                              _3006 = ((_3001 * _3001) / (_2996 * 4.0f));
                            } else {
                              _3006 = _2988;
                            }
                          } else {
                            _3006 = _2988;
                          }
                          _3007 = _218 * _218;
                          _3011 = saturate((_1877 * (1.0f - _3007)) * _2984);
                          _3013 = saturate(_2984 * f16tof32(_1827));
                          _3014 = dot(float3(_190, _191, _192), float3(_451, _452, _450));
                          _3015 = dot(float3(_451, _452, _450), float3(_2985, _2986, _2987));
                          _3018 = rsqrt((_3015 * 2.0f) + 2.0f);
                          _3025 = (_3011 > 0.0f);
                          if (_3025) {
                            _3029 = sqrt(1.0f - (_3011 * _3011));
                            _3031 = (_2988 * 2.0f) * _3014;
                            _3032 = _3031 - _3015;
                            if (!(_3032 >= _3029)) {
                              _3040 = rsqrt(1.0f - (_3032 * _3032)) * _3011;
                              _3043 = _3040 * (_3014 - (_3032 * _2988));
                              _3044 = _3014 * _3014;
                              _3049 = _3040 * (((_3044 * 2.0f) + -1.0f) - (_3032 * _3015));
                              _3058 = sqrt(saturate((((1.0f - (_2988 * _2988)) - _3044) - (_3015 * _3015)) + (_3031 * _3015)));
                              _3059 = _3058 * _3040;
                              _3062 = ((_3014 * 2.0f) * _3040) * _3058;
                              _3064 = (_3029 * _2988) + _3014;
                              _3065 = _3064 + _3043;
                              _3066 = _3029 * _3015;
                              _3068 = (_3066 + 1.0f) + _3049;
                              _3069 = _3059 * _3068;
                              _3070 = _3065 * _3068;
                              _3071 = _3062 * _3065;
                              _3076 = (((_3065 * 0.25f) * _3062) - (_3069 * 0.5f)) * _3070;
                              _3090 = (((_3071 - (_3069 * 2.0f)) * _3071) + (_3069 * _3069)) + ((((-0.5f - ((_3068 + _3066) * 0.5f)) * _3070) + ((_3068 * _3068) * _3064)) * _3065);
                              _3095 = (_3076 * 2.0f) / ((_3090 * _3090) + (_3076 * _3076));
                              _3096 = _3090 * _3095;
                              _3098 = 1.0f - (_3076 * _3095);
                              _3104 = ((_3096 * _3062) + _3066) + (_3098 * _3049);
                              _3107 = rsqrt((_3104 * 2.0f) + 2.0f);
                              _3116 = saturate((_3104 * _3107) + _3107);
                              _3117 = saturate(((_3064 + (_3096 * _3059)) + (_3098 * _3043)) * _3107);
                            } else {
                              _3116 = abs(_3014);
                              _3117 = 1.0f;
                            }
                          } else {
                            _3116 = saturate((_3018 * _3015) + _3018);
                            _3117 = saturate(_3018 * (_3014 + _2988));
                          }
                          _3118 = saturate(_3006);
                          _3119 = _3007 * _3007;
                          if (_3013 > 0.0f) {
                            _3129 = saturate(((_3013 * _3013) / ((_3116 * 3.5999999046325684f) + 0.4000000059604645f)) + _3119);
                          } else {
                            _3129 = _3119;
                          }
                          _3130 = sqrt(_3129);
                          if (_3025) {
                            _3141 = (_3129 / ((((_3011 * 0.25f) * ((_3130 * 3.0f) + _3011)) / (_3116 + 0.0010000000474974513f)) + _3129));
                          } else {
                            _3141 = 1.0f;
                          }
                          _3145 = (((_3129 * _3117) - _3117) * _3117) + 1.0f;
                          _3152 = exp2(log2(1.0f - saturate(_3116)) * 5.0f);
                          _3155 = saturate(abs(_3014) + 9.999999747378752e-06f);
                          _3156 = 1.0f - _3130;
                          _3168 = saturate((_2988 + _1875) / (_1875 + 1.0f));
                          _3171 = ((_3141 * _3118) * (_3129 / (_3145 * _3145))) * (0.5f / ((((_3156 * _3155) + _3130) * _3118) + (((_3156 * _3118) + _3130) * _3155)));
                          _3172 = _2878 * _1671;
                          _3173 = _2879 * _1671;
                          _3174 = _2880 * _1671;
                          if (_1872 > 0.0f) {
                            _3195 = (_1872 * _1367) * select(_2978, (_2974 * _1280), _2974);
                            _3212 = (((((_3172 * _1143) * _3195) * ((_3152 * (1.0f - _210)) + _210)) * _3171) + _1611);
                            _3213 = (((((_3173 * _1144) * _3195) * ((_3152 * (1.0f - _211)) + _211)) * _3171) + _1612);
                            _3214 = (((((_3174 * _1145) * _3195) * ((_3152 * (1.0f - _212)) + _212)) * _3171) + _1613);
                          } else {
                            _3212 = _1611;
                            _3213 = _1612;
                            _3214 = _1613;
                          }
                          _8848 = (((_2981 * _3172) * _3168) + _1608);
                          _8849 = (((_2981 * _3173) * _3168) + _1609);
                          _8850 = (((_2981 * _3174) * _3168) + _1610);
                          _8851 = (_3212 + (_2936 * _3172));
                          _8852 = (_3213 + (_2937 * _3173));
                          _8853 = (_3214 + (_2938 * _3174));
                        } else {
                          _8848 = _1608;
                          _8849 = _1609;
                          _8850 = _1610;
                          _8851 = _1611;
                          _8852 = _1612;
                          _8853 = _1613;
                        }
                        break;
                      }
                    } else {
                      _8848 = _1608;
                      _8849 = _1609;
                      _8850 = _1610;
                      _8851 = _1611;
                      _8852 = _1612;
                      _8853 = _1613;
                    }
                  } else {
                    if (_1654 == 7) {
                      _3793 = asfloat(srvLightInfoProperties.Load3(_1622)).x;
                      _3794 = asfloat(srvLightInfoProperties.Load3(_1622)).y;
                      _3795 = asfloat(srvLightInfoProperties.Load3(_1622)).z;
                      _3798 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 12u)))).x;
                      _3799 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 12u)))).y;
                      _3800 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 12u)))).z;
                      _3803 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 24u)))).x;
                      _3804 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 24u)))).y;
                      _3805 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 24u)))).z;
                      _3808 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 36u)))).x;
                      _3809 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 36u)))).y;
                      _3810 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 36u)))).z;
                      _3813 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).x;
                      _3814 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).y;
                      _3815 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 48u)))).z;
                      _3818 = asint(srvLightInfoProperties.Load(((int)(_1622 + 60u))));
                      _3821 = asint(srvLightInfoProperties.Load(((int)(_1622 + 64u))));
                      _3824 = asint(srvLightInfoProperties.Load(((int)(_1622 + 72u))));
                      _3827 = asint(srvLightInfoProperties.Load(((int)(_1622 + 76u))));
                      _3830 = asint(srvLightInfoProperties.Load(((int)(_1622 + 80u))));
                      _3833 = asint(srvLightInfoProperties.Load(((int)(_1622 + 84u))));
                      _3836 = asint(srvLightInfoProperties.Load(((int)(_1622 + 88u))));
                      _3839 = asint(srvLightInfoProperties.Load(((int)(_1622 + 92u))));
                      _3842 = asint(srvLightInfoProperties.Load(((int)(_1622 + 96u))));
                      _3845 = asint(srvLightInfoProperties.Load(((int)(_1622 + 100u))));
                      _3848 = asint(srvLightInfoProperties.Load(((int)(_1622 + 104u))));
                      _3851 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).x;
                      _3852 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).y;
                      _3853 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).z;
                      _3854 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).w;
                      _3857 = asint(srvLightInfoProperties.Load(((int)(_1622 + 124u))));
                      _3860 = asint(srvLightInfoProperties.Load(((int)(_1622 + 128u))));
                      _3863 = asint(srvLightInfoProperties.Load(((int)(_1622 + 136u))));
                      _3866 = asint(srvLightInfoProperties.Load(((int)(_1622 + 140u))));
                      _3868 = f16tof32(((uint)((uint)(_3818) >> 16)));
                      _3869 = f16tof32(_3818);
                      _3871 = f16tof32(((uint)((uint)(_3821) >> 16)));
                      _3875 = ((float)((uint)((uint)(((uint)(_3821) >> 8) & 255)))) * 0.003921499941498041f;
                      _3878 = ((float)((uint)((uint)(_3821 & 255)))) * 0.003921499941498041f;
                      _3879 = f16tof32(_3824);
                      _3881 = f16tof32(((uint)((uint)(_3827) >> 16)));
                      _3885 = f16tof32(_3830);
                      _3887 = f16tof32(((uint)((uint)(_3833) >> 16)));
                      _3888 = f16tof32(_3833);
                      _3890 = f16tof32(((uint)((uint)(_3836) >> 16)));
                      _3891 = f16tof32(_3836);
                      _3893 = _3839 & 65535;
                      _3897 = ((_1620 & 4194304) != 0);
                      _3905 = f16tof32(((uint)((uint)(_3848) >> 16)));
                      _3906 = f16tof32(_3848);
                      _3908 = f16tof32(((uint)((uint)(_3857) >> 16)));
                      _3911 = f16tof32(((uint)((uint)(_3860) >> 16)));
                      _3912 = f16tof32(_3860);
                      _3914 = f16tof32(((uint)((uint)(_3863) >> 16)));
                      _3915 = _3914 + -1.0f;
                      if (_3897) {
                        _3917 = 0.5f / _3914;
                        _3918 = 0.3333333432674408f / _3914;
                        _3922 = (_3914 * 0.5f) + 0.5f;
                        _3932 = (_3917 * _3915);
                        _3933 = (_3918 * _3915);
                        _3934 = (_3917 * _3922);
                        _3935 = (_3918 * _3922);
                        _3936 = (_3914 * 2.0f);
                        _3937 = (_3914 * 3.0f);
                        _3938 = _3917;
                        _3939 = _3918;
                      } else {
                        _3928 = 1.0f / _3914;
                        _3929 = _3928 * _3915;
                        _3930 = _3928 * 0.5f;
                        _3932 = _3929;
                        _3933 = _3929;
                        _3934 = _3930;
                        _3935 = _3930;
                        _3936 = _3914;
                        _3937 = _3914;
                        _3938 = _3928;
                        _3939 = _3928;
                      }
                      _3943 = _3808 - _229;
                      _3944 = _3809 - _230;
                      _3945 = _3810 + _228;
                      _3946 = dot(float3(_3943, _3944, _3945), float3(_3943, _3944, _3945));
                      _3947 = rsqrt(_3946);
                      _3948 = _3947 * _3946;
                      _3949 = _3947 * _3943;
                      _3950 = _3947 * _3944;
                      _3951 = _3947 * _3945;
                      _3954 = max(0.0f, (_3948 - abs(_3885)));
                      _3955 = _3954 * f16tof32(((uint)((uint)(_3830) >> 16)));
                      _3956 = _3955 * _3955;
                      _3959 = saturate(1.0f - (_3956 * _3956));
                      _3966 = (_3959 * _3959) / (select((_3885 < 0.0f), (_3956 * 16.0f), (_3954 * _3954)) + 1.0f);
                      _3979 = saturate(1.0f - dot(float3(_190, _191, _192), float3(_3949, _3950, _3951))) * f16tof32(_3857);
                      _3983 = abs(_3945);
                      _3987 = _3943 - ((_3979 * _190) * _3983);
                      _3988 = _3944 - ((_3979 * _191) * _3983);
                      _3989 = _3945 - ((_3979 * _192) * _3983);
                      _3992 = mad(_3989, _3804, mad(_3988, _3799, (_3987 * _3794)));
                      _3995 = mad(_3989, _3805, mad(_3988, _3800, (_3987 * _3795)));
                      _3997 = ((_1620 & 3584) != 0);
                      if (_3997 && (_3966 > 0.0f)) {
                        _4003 = mad(_3989, _3803, mad(_3988, _3798, (_3987 * _3793)));
                        _4004 = -0.0f - _3995;
                        _4005 = -0.0f - _3992;
                        [branch]
                        if (!((_1620 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3839) >> 16))];
                          [branch]
                          if (_3897) {
                            _4010 = abs(_4003);
                            _4011 = abs(_4004);
                            _4012 = abs(_4005);
                            if (_4010 > max(_4011, _4012)) {
                              _4016 = (_4003 > 0.0f);
                              _4031 = select(_4016, 0.0f, 1.0f);
                              _4032 = 0.0f;
                              _4033 = select(_4016, _3992, _4005);
                              _4034 = _3995;
                              _4035 = _4010;
                            } else {
                              if (_4011 > _4012) {
                                _4022 = (_3995 < -0.0f);
                                _4031 = select(_4022, 0.0f, 1.0f);
                                _4032 = 1.0f;
                                _4033 = _4003;
                                _4034 = select(_4022, _4005, _3992);
                                _4035 = _4011;
                              } else {
                                _4026 = (_3992 < -0.0f);
                                _4031 = select(_4026, 0.0f, 1.0f);
                                _4032 = 2.0f;
                                _4033 = select(_4026, _4003, (-0.0f - _4003));
                                _4034 = _3995;
                                _4035 = _4012;
                              }
                            }
                            _4036 = _4035 * 2.0f;
                            _4041 = -0.0f - _3906;
                            _4050 = ((min(max((_4033 / _4036), _4041), _3906) + _4031) * _3932) + _3934;
                            _4051 = ((min(max((_4034 / _4036), _4041), _3906) + _4032) * _3933) + _3935;
                            _4052 = (1.0f - (_4035 * _3890)) + _3908;
                            _4057 = ((_4031 + -0.5f) * _3932) + _3934;
                            _4058 = ((_4032 + -0.5f) * _3933) + _3935;
                            _4061 = saturate(_4052);
                            _4065 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4074 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_4065 * 32.665000915527344f) + _127), ((_4065 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4075 = sin(_4074);
                            _4076 = cos(_4074);
                            _4081 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_4050, _4051), 0.0f))).x) > _4061), 1.0f, 0.0f);
                            _4082 = cbSharedPerViewData.nFrameCounter & 3;
                            _4087 = sqrt((float((int)(_4082)) * 0.25f) + 0.125f) * _3911;
                            _4096 = (_global_7[min((uint)(((int)(0u + (_4082 * 2)))), 127u)]) * _4087;
                            _4097 = (_global_7[min((uint)(((int)(1u + (_4082 * 2)))), 127u)]) * _4087;
                            _4099 = -0.0f - _4075;
                            _4101 = dot(float2(_4096, _4097), float2(_4076, _4075)) + _4050;
                            _4102 = dot(float2(_4096, _4097), float2(_4099, _4076)) + _4051;
                            _4104 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4101, _4102));
                            _4108 = _4101 * _3936;
                            _4109 = _4102 * _3937;
                            _4112 = floor(_4057 * _3936);
                            _4113 = floor(_4058 * _3937);
                            _4118 = floor(((_4057 + _3932) * _3936) + 0.5f);
                            _4119 = floor(((_4058 + _3933) * _3937) + 0.5f);
                            _4122 = floor(_4108 + -0.5f);
                            _4123 = floor(_4109 + 0.5f);
                            _4125 = floor(_4108 + 0.5f);
                            _4127 = floor(_4109 + -0.5f);
                            _4128 = (_4122 < _4112);
                            _4129 = (_4123 < _4113);
                            if ((_4128 || _4129) | ((_4122 >= _4118) || (_4123 >= _4119))) {
                              _4138 = _4081;
                            } else {
                              _4138 = _4104.x;
                            }
                            _4139 = (_4125 < _4112);
                            if ((_4139 || _4129) | ((_4125 >= _4118) || (_4123 >= _4119))) {
                              _4147 = _4081;
                            } else {
                              _4147 = _4104.y;
                            }
                            _4148 = (_4127 < _4113);
                            if ((_4139 || _4148) | ((_4125 >= _4118) || (_4127 >= _4119))) {
                              _4156 = _4081;
                            } else {
                              _4156 = _4104.z;
                            }
                            if ((_4128 || _4148) | ((_4122 >= _4118) || (_4127 >= _4119))) {
                              _4164 = _4081;
                            } else {
                              _4164 = _4104.w;
                            }
                            _4165 = _4138 - _4061;
                            _4167 = select((_4165 < 0.0f), 0.0f, 1.0f);
                            _4169 = _4147 - _4061;
                            _4171 = select((_4169 < 0.0f), 0.0f, 1.0f);
                            _4175 = _4156 - _4061;
                            _4177 = select((_4175 < 0.0f), 0.0f, 1.0f);
                            _4181 = _4164 - _4061;
                            _4183 = select((_4181 < 0.0f), 0.0f, 1.0f);
                            _4190 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _4195 = sqrt((float((int)(_4190)) * 0.25f) + 0.125f) * _3911;
                            _4204 = (_global_7[min((uint)(((int)(0u + (_4190 * 2)))), 127u)]) * _4195;
                            _4205 = (_global_7[min((uint)(((int)(1u + (_4190 * 2)))), 127u)]) * _4195;
                            _4208 = dot(float2(_4204, _4205), float2(_4076, _4075)) + _4050;
                            _4209 = dot(float2(_4204, _4205), float2(_4099, _4076)) + _4051;
                            _4211 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4208, _4209));
                            _4215 = _4208 * _3936;
                            _4216 = _4209 * _3937;
                            _4219 = floor(_4215 + -0.5f);
                            _4220 = floor(_4216 + 0.5f);
                            _4222 = floor(_4215 + 0.5f);
                            _4224 = floor(_4216 + -0.5f);
                            _4225 = (_4219 < _4112);
                            _4226 = (_4220 < _4113);
                            if ((_4225 || _4226) | ((_4219 >= _4118) || (_4220 >= _4119))) {
                              _4235 = _4081;
                            } else {
                              _4235 = _4211.x;
                            }
                            _4236 = (_4222 < _4112);
                            if ((_4236 || _4226) | ((_4222 >= _4118) || (_4220 >= _4119))) {
                              _4244 = _4081;
                            } else {
                              _4244 = _4211.y;
                            }
                            _4245 = (_4224 < _4113);
                            if ((_4236 || _4245) | ((_4222 >= _4118) || (_4224 >= _4119))) {
                              _4253 = _4081;
                            } else {
                              _4253 = _4211.z;
                            }
                            if ((_4225 || _4245) | ((_4219 >= _4118) || (_4224 >= _4119))) {
                              _4261 = _4081;
                            } else {
                              _4261 = _4211.w;
                            }
                            _4262 = _4235 - _4061;
                            _4264 = select((_4262 < 0.0f), 0.0f, 1.0f);
                            _4268 = _4244 - _4061;
                            _4270 = select((_4268 < 0.0f), 0.0f, 1.0f);
                            _4274 = _4253 - _4061;
                            _4276 = select((_4274 < 0.0f), 0.0f, 1.0f);
                            _4280 = _4261 - _4061;
                            _4282 = select((_4280 < 0.0f), 0.0f, 1.0f);
                            _4289 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4294 = sqrt((float((int)(_4289)) * 0.25f) + 0.125f) * _3911;
                            _4303 = (_global_7[min((uint)(((int)(0u + (_4289 * 2)))), 127u)]) * _4294;
                            _4304 = (_global_7[min((uint)(((int)(1u + (_4289 * 2)))), 127u)]) * _4294;
                            _4307 = dot(float2(_4303, _4304), float2(_4076, _4075)) + _4050;
                            _4308 = dot(float2(_4303, _4304), float2(_4099, _4076)) + _4051;
                            _4310 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4307, _4308));
                            _4314 = _4307 * _3936;
                            _4315 = _4308 * _3937;
                            _4318 = floor(_4314 + -0.5f);
                            _4319 = floor(_4315 + 0.5f);
                            _4321 = floor(_4314 + 0.5f);
                            _4323 = floor(_4315 + -0.5f);
                            _4324 = (_4318 < _4112);
                            _4325 = (_4319 < _4113);
                            if ((_4324 || _4325) | ((_4318 >= _4118) || (_4319 >= _4119))) {
                              _4334 = _4081;
                            } else {
                              _4334 = _4310.x;
                            }
                            _4335 = (_4321 < _4112);
                            if ((_4335 || _4325) | ((_4321 >= _4118) || (_4319 >= _4119))) {
                              _4343 = _4081;
                            } else {
                              _4343 = _4310.y;
                            }
                            _4344 = (_4323 < _4113);
                            if ((_4335 || _4344) | ((_4321 >= _4118) || (_4323 >= _4119))) {
                              _4352 = _4081;
                            } else {
                              _4352 = _4310.z;
                            }
                            if ((_4324 || _4344) | ((_4318 >= _4118) || (_4323 >= _4119))) {
                              _4360 = _4081;
                            } else {
                              _4360 = _4310.w;
                            }
                            _4361 = _4334 - _4061;
                            _4363 = select((_4361 < 0.0f), 0.0f, 1.0f);
                            _4367 = _4343 - _4061;
                            _4369 = select((_4367 < 0.0f), 0.0f, 1.0f);
                            _4373 = _4352 - _4061;
                            _4375 = select((_4373 < 0.0f), 0.0f, 1.0f);
                            _4379 = _4360 - _4061;
                            _4381 = select((_4379 < 0.0f), 0.0f, 1.0f);
                            _4388 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4393 = sqrt((float((int)(_4388)) * 0.25f) + 0.125f) * _3911;
                            _4402 = (_global_7[min((uint)(((int)(0u + (_4388 * 2)))), 127u)]) * _4393;
                            _4403 = (_global_7[min((uint)(((int)(1u + (_4388 * 2)))), 127u)]) * _4393;
                            _4406 = dot(float2(_4402, _4403), float2(_4076, _4075)) + _4050;
                            _4407 = dot(float2(_4402, _4403), float2(_4099, _4076)) + _4051;
                            _4409 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4406, _4407));
                            _4413 = _4406 * _3936;
                            _4414 = _4407 * _3937;
                            _4417 = floor(_4413 + -0.5f);
                            _4418 = floor(_4414 + 0.5f);
                            _4420 = floor(_4413 + 0.5f);
                            _4422 = floor(_4414 + -0.5f);
                            _4423 = (_4417 < _4112);
                            _4424 = (_4418 < _4113);
                            if ((_4423 || _4424) | ((_4417 >= _4118) || (_4418 >= _4119))) {
                              _4433 = _4081;
                            } else {
                              _4433 = _4409.x;
                            }
                            _4434 = (_4420 < _4112);
                            if ((_4434 || _4424) | ((_4420 >= _4118) || (_4418 >= _4119))) {
                              _4442 = _4081;
                            } else {
                              _4442 = _4409.y;
                            }
                            _4443 = (_4422 < _4113);
                            if ((_4434 || _4443) | ((_4420 >= _4118) || (_4422 >= _4119))) {
                              _4451 = _4081;
                            } else {
                              _4451 = _4409.z;
                            }
                            if ((_4423 || _4443) | ((_4417 >= _4118) || (_4422 >= _4119))) {
                              _4459 = _4081;
                            } else {
                              _4459 = _4409.w;
                            }
                            _4460 = _4433 - _4061;
                            _4462 = select((_4460 < 0.0f), 0.0f, 1.0f);
                            _4466 = _4442 - _4061;
                            _4468 = select((_4466 < 0.0f), 0.0f, 1.0f);
                            _4472 = _4451 - _4061;
                            _4474 = select((_4472 < 0.0f), 0.0f, 1.0f);
                            _4478 = _4459 - _4061;
                            _4480 = select((_4478 < 0.0f), 0.0f, 1.0f);
                            _4481 = ((((((((((((((_4171 + _4167) + _4177) + _4183) + _4264) + _4270) + _4276) + _4282) + _4363) + _4369) + _4375) + _4381) + _4462) + _4468) + _4474) + _4480;
                            _4492 = (saturate(_4481 * 0.0625f) * 2.0f) + -1.0f;
                            _4498 = float((int)(((int)(uint)((int)(_4492 > 0.0f))) - ((int)(uint)((int)(_4492 < 0.0f)))));
                            _4500 = 1.0f - (_4498 * _4492);
                            _4502 = (_4500 * _4500) * _4500;
                            _4848 = (0.5f - ((_4498 * 0.5f) * ((1.0f - _4502) - ((_4500 - _4502) * saturate(((1.0f / _4061) * (1.0f / _4481)) * ((((((((((((((((_4171 * _4169) + (_4167 * _4165)) + (_4177 * _4175)) + (_4183 * _4181)) + (_4264 * _4262)) + (_4270 * _4268)) + (_4276 * _4274)) + (_4282 * _4280)) + (_4363 * _4361)) + (_4369 * _4367)) + (_4375 * _4373)) + (_4381 * _4379)) + (_4462 * _4460)) + (_4468 * _4466)) + (_4474 * _4472)) + (_4480 * _4478)))))));
                            _4849 = (((float4)(_HeapResource_22.SampleCmpLevelZero(samplerLinearPCFBorderBlackNode, float2(_4050, _4051), _4052))).x);
                            _4850 = 1.0f;
                            _4851 = 1;
                            _4852 = _3891;
                          } else {
                            _4514 = f16tof32(_3866) / _4005;
                            _4517 = mad((_4514 * _4003), 0.5f, 0.5f);
                            _4518 = mad((_4514 * _4004), 0.5f, 0.5f);
                            _4521 = (1.0f - (_3992 * _3890)) + _3908;
                            if (_3992 > -0.0f) {
                              if ((saturate(_4517) == _4517) && (saturate(_4518) == _4518)) {
                                _4532 = (_4517 * _3932) + _3934;
                                _4533 = (_4518 * _3933) + _3935;
                                _4534 = saturate(_4521);
                                _4538 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4547 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_4538 * 32.665000915527344f) + _127), ((_4538 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4548 = sin(_4547);
                                _4549 = cos(_4547);
                                _4550 = cbSharedPerViewData.nFrameCounter & 3;
                                _4555 = sqrt((float((int)(_4550)) * 0.25f) + 0.125f) * _3911;
                                _4564 = (_global_7[min((uint)(((int)(0u + (_4550 * 2)))), 127u)]) * _4555;
                                _4565 = (_global_7[min((uint)(((int)(1u + (_4550 * 2)))), 127u)]) * _4555;
                                _4567 = -0.0f - _4548;
                                _4572 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4564, _4565), float2(_4549, _4548)) + _4532), (dot(float2(_4564, _4565), float2(_4567, _4549)) + _4533)));
                                _4577 = _4572.x - _4534;
                                _4579 = select((_4577 < 0.0f), 0.0f, 1.0f);
                                _4581 = _4572.y - _4534;
                                _4583 = select((_4581 < 0.0f), 0.0f, 1.0f);
                                _4587 = _4572.z - _4534;
                                _4589 = select((_4587 < 0.0f), 0.0f, 1.0f);
                                _4593 = _4572.w - _4534;
                                _4595 = select((_4593 < 0.0f), 0.0f, 1.0f);
                                _4602 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4607 = sqrt((float((int)(_4602)) * 0.25f) + 0.125f) * _3911;
                                _4616 = (_global_7[min((uint)(((int)(0u + (_4602 * 2)))), 127u)]) * _4607;
                                _4617 = (_global_7[min((uint)(((int)(1u + (_4602 * 2)))), 127u)]) * _4607;
                                _4623 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4616, _4617), float2(_4549, _4548)) + _4532), (dot(float2(_4616, _4617), float2(_4567, _4549)) + _4533)));
                                _4628 = _4623.x - _4534;
                                _4630 = select((_4628 < 0.0f), 0.0f, 1.0f);
                                _4634 = _4623.y - _4534;
                                _4636 = select((_4634 < 0.0f), 0.0f, 1.0f);
                                _4640 = _4623.z - _4534;
                                _4642 = select((_4640 < 0.0f), 0.0f, 1.0f);
                                _4646 = _4623.w - _4534;
                                _4648 = select((_4646 < 0.0f), 0.0f, 1.0f);
                                _4655 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _4660 = sqrt((float((int)(_4655)) * 0.25f) + 0.125f) * _3911;
                                _4669 = (_global_7[min((uint)(((int)(0u + (_4655 * 2)))), 127u)]) * _4660;
                                _4670 = (_global_7[min((uint)(((int)(1u + (_4655 * 2)))), 127u)]) * _4660;
                                _4676 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4669, _4670), float2(_4549, _4548)) + _4532), (dot(float2(_4669, _4670), float2(_4567, _4549)) + _4533)));
                                _4681 = _4676.x - _4534;
                                _4683 = select((_4681 < 0.0f), 0.0f, 1.0f);
                                _4687 = _4676.y - _4534;
                                _4689 = select((_4687 < 0.0f), 0.0f, 1.0f);
                                _4693 = _4676.z - _4534;
                                _4695 = select((_4693 < 0.0f), 0.0f, 1.0f);
                                _4699 = _4676.w - _4534;
                                _4701 = select((_4699 < 0.0f), 0.0f, 1.0f);
                                _4708 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _4713 = sqrt((float((int)(_4708)) * 0.25f) + 0.125f) * _3911;
                                _4722 = (_global_7[min((uint)(((int)(0u + (_4708 * 2)))), 127u)]) * _4713;
                                _4723 = (_global_7[min((uint)(((int)(1u + (_4708 * 2)))), 127u)]) * _4713;
                                _4729 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4722, _4723), float2(_4549, _4548)) + _4532), (dot(float2(_4722, _4723), float2(_4567, _4549)) + _4533)));
                                _4734 = _4729.x - _4534;
                                _4736 = select((_4734 < 0.0f), 0.0f, 1.0f);
                                _4740 = _4729.y - _4534;
                                _4742 = select((_4740 < 0.0f), 0.0f, 1.0f);
                                _4746 = _4729.z - _4534;
                                _4748 = select((_4746 < 0.0f), 0.0f, 1.0f);
                                _4752 = _4729.w - _4534;
                                _4754 = select((_4752 < 0.0f), 0.0f, 1.0f);
                                _4755 = ((((((((((((((_4579 + _4583) + _4589) + _4595) + _4630) + _4636) + _4642) + _4648) + _4683) + _4689) + _4695) + _4701) + _4736) + _4742) + _4748) + _4754;
                                _4766 = (saturate(_4755 * 0.0625f) * 2.0f) + -1.0f;
                                _4772 = float((int)(((int)(uint)((int)(_4766 > 0.0f))) - ((int)(uint)((int)(_4766 < 0.0f)))));
                                _4774 = 1.0f - (_4772 * _4766);
                                _4776 = (_4774 * _4774) * _4774;
                                _4784 = -0.0f - _4003;
                                _4791 = saturate((saturate(rsqrt(dot(float3(_4784, _3995, _3992), float3(_4784, _3995, _3992))) * _3992) * _3888) + _3887);
                                _4793 = 1.0f - (_4791 * _4791);
                                _4800 = frac((_4532 * _3936) + 0.5f);
                                _4801 = frac((_4533 * _3937) + 0.5f);
                                _4802 = _4532 + _3938;
                                _4803 = _4533 + _3939;
                                _4805 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4802, _4803), _4521);
                                _4814 = _4802 - (_3938 * 2.0f);
                                _4815 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4814, _4803), _4521);
                                _4820 = 1.0f - _4800;
                                _4826 = _4803 - (_3939 * 2.0f);
                                _4827 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4814, _4826), _4521);
                                _4832 = 1.0f - _4801;
                                _4837 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4802, _4826), _4521);
                                _4848 = (0.5f - ((_4772 * 0.5f) * ((1.0f - _4776) - ((_4774 - _4776) * saturate(((1.0f / _4534) * (1.0f / _4755)) * ((((((((((((((((_4579 * _4577) + (_4583 * _4581)) + (_4589 * _4587)) + (_4595 * _4593)) + (_4630 * _4628)) + (_4636 * _4634)) + (_4642 * _4640)) + (_4648 * _4646)) + (_4683 * _4681)) + (_4689 * _4687)) + (_4695 * _4693)) + (_4701 * _4699)) + (_4736 * _4734)) + (_4742 * _4740)) + (_4748 * _4746)) + (_4754 * _4752)))))));
                                _4849 = ((((mad(mad(_4815.x, _4820, _4815.y), _4801, mad(_4815.w, _4820, _4815.z)) + mad(mad(_4805.y, _4800, _4805.x), _4801, mad(_4805.z, _4800, _4805.w))) + mad(mad(_4827.w, _4820, _4827.z), _4832, mad(_4827.x, _4820, _4827.y))) + mad(mad(_4837.z, _4800, _4837.w), _4832, mad(_4837.y, _4800, _4837.x))) * 0.1111111119389534f);
                                _4850 = (1.0f - (_4793 * _4793));
                                _4851 = 1;
                                _4852 = _3891;
                              } else {
                                _4848 = 1.0f;
                                _4849 = 0.0f;
                                _4850 = 1.0f;
                                _4851 = 0;
                                _4852 = _3891;
                              }
                            } else {
                              _4848 = 1.0f;
                              _4849 = 0.0f;
                              _4850 = 1.0f;
                              _4851 = 0;
                              _4852 = _3891;
                            }
                          }
                        } else {
                          _4848 = 1.0f;
                          _4849 = 1.0f;
                          _4850 = 1.0f;
                          _4851 = 0;
                          _4852 = 0.0f;
                        }
                        [branch]
                        if (!((_1620 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1620 & 2097152) == 0)) {
                            _4860 = abs(_4003);
                            _4861 = abs(_4004);
                            _4862 = abs(_4005);
                            if (_4860 > max(_4861, _4862)) {
                              _4866 = (_4003 > 0.0f);
                              _4881 = select(_4866, 0.0f, 1.0f);
                              _4882 = 0.0f;
                              _4883 = select(_4866, _3992, _4005);
                              _4884 = _3995;
                              _4885 = _4860;
                            } else {
                              if (_4861 > _4862) {
                                _4872 = (_3995 < -0.0f);
                                _4881 = select(_4872, 0.0f, 1.0f);
                                _4882 = 1.0f;
                                _4883 = _4003;
                                _4884 = select(_4872, _4005, _3992);
                                _4885 = _4861;
                              } else {
                                _4876 = (_3992 < -0.0f);
                                _4881 = select(_4876, 0.0f, 1.0f);
                                _4882 = 2.0f;
                                _4883 = select(_4876, _4003, (-0.0f - _4003));
                                _4884 = _3995;
                                _4885 = _4862;
                              }
                            }
                            _4886 = _4885 * 2.0f;
                            _4891 = -0.0f - _3905;
                            _4900 = ((min(max((_4883 / _4886), _4891), _3905) + _4881) * _3851) + _3853;
                            _4901 = ((min(max((_4884 / _4886), _4891), _3905) + _4882) * _3852) + _3854;
                            _4906 = ((_4881 + -0.5f) * _3851) + _3853;
                            _4907 = ((_4882 + -0.5f) * _3852) + _3854;
                            _4910 = saturate(1.0f - (_4885 * _3890));
                            _4914 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4923 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_4914 * 32.665000915527344f) + _127), ((_4914 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4924 = sin(_4923);
                            _4925 = cos(_4923);
                            _4930 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4900, _4901), 0.0f))).x) > _4910), 1.0f, 0.0f);
                            _4931 = cbSharedPerViewData.nFrameCounter & 3;
                            _4936 = sqrt((float((int)(_4931)) * 0.25f) + 0.125f) * _3912;
                            _4945 = (_global_7[min((uint)(((int)(0u + (_4931 * 2)))), 127u)]) * _4936;
                            _4946 = (_global_7[min((uint)(((int)(1u + (_4931 * 2)))), 127u)]) * _4936;
                            _4948 = -0.0f - _4924;
                            _4950 = dot(float2(_4945, _4946), float2(_4925, _4924)) + _4900;
                            _4951 = dot(float2(_4945, _4946), float2(_4948, _4925)) + _4901;
                            _4953 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4950, _4951));
                            _4957 = _4950 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4958 = _4951 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4961 = floor(_4906 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _4962 = floor(_4907 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _4967 = floor(((_4906 + _3851) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _4968 = floor(((_4907 + _3852) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _4971 = floor(_4957 + -0.5f);
                            _4972 = floor(_4958 + 0.5f);
                            _4974 = floor(_4957 + 0.5f);
                            _4976 = floor(_4958 + -0.5f);
                            _4977 = (_4971 < _4961);
                            _4978 = (_4972 < _4962);
                            if ((_4977 || _4978) | ((_4971 >= _4967) || (_4972 >= _4968))) {
                              _4987 = _4930;
                            } else {
                              _4987 = _4953.x;
                            }
                            _4988 = (_4974 < _4961);
                            if ((_4988 || _4978) | ((_4974 >= _4967) || (_4972 >= _4968))) {
                              _4996 = _4930;
                            } else {
                              _4996 = _4953.y;
                            }
                            _4997 = (_4976 < _4962);
                            if ((_4988 || _4997) | ((_4974 >= _4967) || (_4976 >= _4968))) {
                              _5005 = _4930;
                            } else {
                              _5005 = _4953.z;
                            }
                            if ((_4977 || _4997) | ((_4971 >= _4967) || (_4976 >= _4968))) {
                              _5013 = _4930;
                            } else {
                              _5013 = _4953.w;
                            }
                            _5014 = _4987 - _4910;
                            _5016 = select((_5014 < 0.0f), 0.0f, 1.0f);
                            _5018 = _4996 - _4910;
                            _5020 = select((_5018 < 0.0f), 0.0f, 1.0f);
                            _5024 = _5005 - _4910;
                            _5026 = select((_5024 < 0.0f), 0.0f, 1.0f);
                            _5030 = _5013 - _4910;
                            _5032 = select((_5030 < 0.0f), 0.0f, 1.0f);
                            _5039 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _5044 = sqrt((float((int)(_5039)) * 0.25f) + 0.125f) * _3912;
                            _5053 = (_global_7[min((uint)(((int)(0u + (_5039 * 2)))), 127u)]) * _5044;
                            _5054 = (_global_7[min((uint)(((int)(1u + (_5039 * 2)))), 127u)]) * _5044;
                            _5057 = dot(float2(_5053, _5054), float2(_4925, _4924)) + _4900;
                            _5058 = dot(float2(_5053, _5054), float2(_4948, _4925)) + _4901;
                            _5060 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5057, _5058));
                            _5064 = _5057 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5065 = _5058 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5068 = floor(_5064 + -0.5f);
                            _5069 = floor(_5065 + 0.5f);
                            _5071 = floor(_5064 + 0.5f);
                            _5073 = floor(_5065 + -0.5f);
                            _5074 = (_5068 < _4961);
                            _5075 = (_5069 < _4962);
                            if ((_5074 || _5075) | ((_5068 >= _4967) || (_5069 >= _4968))) {
                              _5084 = _4930;
                            } else {
                              _5084 = _5060.x;
                            }
                            _5085 = (_5071 < _4961);
                            if ((_5085 || _5075) | ((_5071 >= _4967) || (_5069 >= _4968))) {
                              _5093 = _4930;
                            } else {
                              _5093 = _5060.y;
                            }
                            _5094 = (_5073 < _4962);
                            if ((_5085 || _5094) | ((_5071 >= _4967) || (_5073 >= _4968))) {
                              _5102 = _4930;
                            } else {
                              _5102 = _5060.z;
                            }
                            if ((_5074 || _5094) | ((_5068 >= _4967) || (_5073 >= _4968))) {
                              _5110 = _4930;
                            } else {
                              _5110 = _5060.w;
                            }
                            _5111 = _5084 - _4910;
                            _5113 = select((_5111 < 0.0f), 0.0f, 1.0f);
                            _5117 = _5093 - _4910;
                            _5119 = select((_5117 < 0.0f), 0.0f, 1.0f);
                            _5123 = _5102 - _4910;
                            _5125 = select((_5123 < 0.0f), 0.0f, 1.0f);
                            _5129 = _5110 - _4910;
                            _5131 = select((_5129 < 0.0f), 0.0f, 1.0f);
                            _5138 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _5143 = sqrt((float((int)(_5138)) * 0.25f) + 0.125f) * _3912;
                            _5152 = (_global_7[min((uint)(((int)(0u + (_5138 * 2)))), 127u)]) * _5143;
                            _5153 = (_global_7[min((uint)(((int)(1u + (_5138 * 2)))), 127u)]) * _5143;
                            _5156 = dot(float2(_5152, _5153), float2(_4925, _4924)) + _4900;
                            _5157 = dot(float2(_5152, _5153), float2(_4948, _4925)) + _4901;
                            _5159 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5156, _5157));
                            _5163 = _5156 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5164 = _5157 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5167 = floor(_5163 + -0.5f);
                            _5168 = floor(_5164 + 0.5f);
                            _5170 = floor(_5163 + 0.5f);
                            _5172 = floor(_5164 + -0.5f);
                            _5173 = (_5167 < _4961);
                            _5174 = (_5168 < _4962);
                            if ((_5173 || _5174) | ((_5167 >= _4967) || (_5168 >= _4968))) {
                              _5183 = _4930;
                            } else {
                              _5183 = _5159.x;
                            }
                            _5184 = (_5170 < _4961);
                            if ((_5184 || _5174) | ((_5170 >= _4967) || (_5168 >= _4968))) {
                              _5192 = _4930;
                            } else {
                              _5192 = _5159.y;
                            }
                            _5193 = (_5172 < _4962);
                            if ((_5184 || _5193) | ((_5170 >= _4967) || (_5172 >= _4968))) {
                              _5201 = _4930;
                            } else {
                              _5201 = _5159.z;
                            }
                            if ((_5173 || _5193) | ((_5167 >= _4967) || (_5172 >= _4968))) {
                              _5209 = _4930;
                            } else {
                              _5209 = _5159.w;
                            }
                            _5210 = _5183 - _4910;
                            _5212 = select((_5210 < 0.0f), 0.0f, 1.0f);
                            _5216 = _5192 - _4910;
                            _5218 = select((_5216 < 0.0f), 0.0f, 1.0f);
                            _5222 = _5201 - _4910;
                            _5224 = select((_5222 < 0.0f), 0.0f, 1.0f);
                            _5228 = _5209 - _4910;
                            _5230 = select((_5228 < 0.0f), 0.0f, 1.0f);
                            _5237 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _5242 = sqrt((float((int)(_5237)) * 0.25f) + 0.125f) * _3912;
                            _5251 = (_global_7[min((uint)(((int)(0u + (_5237 * 2)))), 127u)]) * _5242;
                            _5252 = (_global_7[min((uint)(((int)(1u + (_5237 * 2)))), 127u)]) * _5242;
                            _5255 = dot(float2(_5251, _5252), float2(_4925, _4924)) + _4900;
                            _5256 = dot(float2(_5251, _5252), float2(_4948, _4925)) + _4901;
                            _5258 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5255, _5256));
                            _5262 = _5255 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5263 = _5256 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5266 = floor(_5262 + -0.5f);
                            _5267 = floor(_5263 + 0.5f);
                            _5269 = floor(_5262 + 0.5f);
                            _5271 = floor(_5263 + -0.5f);
                            _5272 = (_5266 < _4961);
                            _5273 = (_5267 < _4962);
                            if ((_5272 || _5273) | ((_5266 >= _4967) || (_5267 >= _4968))) {
                              _5282 = _4930;
                            } else {
                              _5282 = _5258.x;
                            }
                            _5283 = (_5269 < _4961);
                            if ((_5283 || _5273) | ((_5269 >= _4967) || (_5267 >= _4968))) {
                              _5291 = _4930;
                            } else {
                              _5291 = _5258.y;
                            }
                            _5292 = (_5271 < _4962);
                            if ((_5283 || _5292) | ((_5269 >= _4967) || (_5271 >= _4968))) {
                              _5300 = _4930;
                            } else {
                              _5300 = _5258.z;
                            }
                            if ((_5272 || _5292) | ((_5266 >= _4967) || (_5271 >= _4968))) {
                              _5308 = _4930;
                            } else {
                              _5308 = _5258.w;
                            }
                            _5309 = _5282 - _4910;
                            _5311 = select((_5309 < 0.0f), 0.0f, 1.0f);
                            _5315 = _5291 - _4910;
                            _5317 = select((_5315 < 0.0f), 0.0f, 1.0f);
                            _5321 = _5300 - _4910;
                            _5323 = select((_5321 < 0.0f), 0.0f, 1.0f);
                            _5327 = _5308 - _4910;
                            _5329 = select((_5327 < 0.0f), 0.0f, 1.0f);
                            _5330 = ((((((((((((((_5020 + _5016) + _5026) + _5032) + _5113) + _5119) + _5125) + _5131) + _5212) + _5218) + _5224) + _5230) + _5311) + _5317) + _5323) + _5329;
                            _5341 = (saturate(_5330 * 0.0625f) * 2.0f) + -1.0f;
                            _5347 = float((int)(((int)(uint)((int)(_5341 > 0.0f))) - ((int)(uint)((int)(_5341 < 0.0f)))));
                            _5349 = 1.0f - (_5347 * _5341);
                            _5351 = (_5349 * _5349) * _5349;
                            _5642 = (0.5f - ((_5347 * 0.5f) * ((1.0f - _5351) - ((_5349 - _5351) * saturate(((1.0f / _4910) * (1.0f / _5330)) * ((((((((((((((((_5020 * _5018) + (_5016 * _5014)) + (_5026 * _5024)) + (_5032 * _5030)) + (_5113 * _5111)) + (_5119 * _5117)) + (_5125 * _5123)) + (_5131 * _5129)) + (_5212 * _5210)) + (_5218 * _5216)) + (_5224 * _5222)) + (_5230 * _5228)) + (_5311 * _5309)) + (_5317 * _5315)) + (_5323 * _5321)) + (_5329 * _5327)))))));
                            _5643 = 1.0f;
                            _5644 = false;
                          } else {
                            _5360 = f16tof32(((uint)((uint)(_3866) >> 16))) / _4005;
                            _5363 = mad((_5360 * _4003), 0.5f, 0.5f);
                            _5364 = mad((_5360 * _4004), 0.5f, 0.5f);
                            if (_3992 > -0.0f) {
                              if ((saturate(_5363) == _5363) && (saturate(_5364) == _5364)) {
                                _5377 = (_5363 * _3851) + _3853;
                                _5378 = (_5364 * _3852) + _3854;
                                _5379 = saturate(1.0f - (_3992 * _3890));
                                _5383 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _5392 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_5383 * 32.665000915527344f) + _127), ((_5383 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _5393 = sin(_5392);
                                _5394 = cos(_5392);
                                _5395 = cbSharedPerViewData.nFrameCounter & 3;
                                _5400 = sqrt((float((int)(_5395)) * 0.25f) + 0.125f) * _3912;
                                _5409 = (_global_7[min((uint)(((int)(0u + (_5395 * 2)))), 127u)]) * _5400;
                                _5410 = (_global_7[min((uint)(((int)(1u + (_5395 * 2)))), 127u)]) * _5400;
                                _5412 = -0.0f - _5393;
                                _5417 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5409, _5410), float2(_5394, _5393)) + _5377), (dot(float2(_5409, _5410), float2(_5412, _5394)) + _5378)));
                                _5422 = _5417.x - _5379;
                                _5424 = select((_5422 < 0.0f), 0.0f, 1.0f);
                                _5426 = _5417.y - _5379;
                                _5428 = select((_5426 < 0.0f), 0.0f, 1.0f);
                                _5432 = _5417.z - _5379;
                                _5434 = select((_5432 < 0.0f), 0.0f, 1.0f);
                                _5438 = _5417.w - _5379;
                                _5440 = select((_5438 < 0.0f), 0.0f, 1.0f);
                                _5447 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _5452 = sqrt((float((int)(_5447)) * 0.25f) + 0.125f) * _3912;
                                _5461 = (_global_7[min((uint)(((int)(0u + (_5447 * 2)))), 127u)]) * _5452;
                                _5462 = (_global_7[min((uint)(((int)(1u + (_5447 * 2)))), 127u)]) * _5452;
                                _5468 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5461, _5462), float2(_5394, _5393)) + _5377), (dot(float2(_5461, _5462), float2(_5412, _5394)) + _5378)));
                                _5473 = _5468.x - _5379;
                                _5475 = select((_5473 < 0.0f), 0.0f, 1.0f);
                                _5479 = _5468.y - _5379;
                                _5481 = select((_5479 < 0.0f), 0.0f, 1.0f);
                                _5485 = _5468.z - _5379;
                                _5487 = select((_5485 < 0.0f), 0.0f, 1.0f);
                                _5491 = _5468.w - _5379;
                                _5493 = select((_5491 < 0.0f), 0.0f, 1.0f);
                                _5500 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _5505 = sqrt((float((int)(_5500)) * 0.25f) + 0.125f) * _3912;
                                _5514 = (_global_7[min((uint)(((int)(0u + (_5500 * 2)))), 127u)]) * _5505;
                                _5515 = (_global_7[min((uint)(((int)(1u + (_5500 * 2)))), 127u)]) * _5505;
                                _5521 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5514, _5515), float2(_5394, _5393)) + _5377), (dot(float2(_5514, _5515), float2(_5412, _5394)) + _5378)));
                                _5526 = _5521.x - _5379;
                                _5528 = select((_5526 < 0.0f), 0.0f, 1.0f);
                                _5532 = _5521.y - _5379;
                                _5534 = select((_5532 < 0.0f), 0.0f, 1.0f);
                                _5538 = _5521.z - _5379;
                                _5540 = select((_5538 < 0.0f), 0.0f, 1.0f);
                                _5544 = _5521.w - _5379;
                                _5546 = select((_5544 < 0.0f), 0.0f, 1.0f);
                                _5553 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _5558 = sqrt((float((int)(_5553)) * 0.25f) + 0.125f) * _3912;
                                _5567 = (_global_7[min((uint)(((int)(0u + (_5553 * 2)))), 127u)]) * _5558;
                                _5568 = (_global_7[min((uint)(((int)(1u + (_5553 * 2)))), 127u)]) * _5558;
                                _5574 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5567, _5568), float2(_5394, _5393)) + _5377), (dot(float2(_5567, _5568), float2(_5412, _5394)) + _5378)));
                                _5579 = _5574.x - _5379;
                                _5581 = select((_5579 < 0.0f), 0.0f, 1.0f);
                                _5585 = _5574.y - _5379;
                                _5587 = select((_5585 < 0.0f), 0.0f, 1.0f);
                                _5591 = _5574.z - _5379;
                                _5593 = select((_5591 < 0.0f), 0.0f, 1.0f);
                                _5597 = _5574.w - _5379;
                                _5599 = select((_5597 < 0.0f), 0.0f, 1.0f);
                                _5600 = ((((((((((((((_5424 + _5428) + _5434) + _5440) + _5475) + _5481) + _5487) + _5493) + _5528) + _5534) + _5540) + _5546) + _5581) + _5587) + _5593) + _5599;
                                _5611 = (saturate(_5600 * 0.0625f) * 2.0f) + -1.0f;
                                _5617 = float((int)(((int)(uint)((int)(_5611 > 0.0f))) - ((int)(uint)((int)(_5611 < 0.0f)))));
                                _5619 = 1.0f - (_5617 * _5611);
                                _5621 = (_5619 * _5619) * _5619;
                                _5629 = -0.0f - _4003;
                                _5636 = saturate((saturate(rsqrt(dot(float3(_5629, _3995, _3992), float3(_5629, _3995, _3992))) * _3992) * _3888) + _3887);
                                _5638 = 1.0f - (_5636 * _5636);
                                _5642 = (0.5f - ((_5617 * 0.5f) * ((1.0f - _5621) - ((_5619 - _5621) * saturate(((1.0f / _5379) * (1.0f / _5600)) * ((((((((((((((((_5424 * _5422) + (_5428 * _5426)) + (_5434 * _5432)) + (_5440 * _5438)) + (_5475 * _5473)) + (_5481 * _5479)) + (_5487 * _5485)) + (_5493 * _5491)) + (_5528 * _5526)) + (_5534 * _5532)) + (_5540 * _5538)) + (_5546 * _5544)) + (_5581 * _5579)) + (_5587 * _5585)) + (_5593 * _5591)) + (_5599 * _5597)))))));
                                _5643 = (1.0f - (_5638 * _5638));
                                _5644 = false;
                              } else {
                                _5642 = 1.0f;
                                _5643 = 1.0f;
                                _5644 = true;
                              }
                            } else {
                              _5642 = 1.0f;
                              _5643 = 1.0f;
                              _5644 = true;
                            }
                          }
                        } else {
                          _5642 = 1.0f;
                          _5643 = 1.0f;
                          _5644 = true;
                        }
                        if (_4851 == 0) {
                          if (!_5644) {
                            _5659 = _4848;
                            _5660 = ((_5643 * (_5642 + -1.0f)) + 1.0f);
                            _5661 = 0.0f;
                          } else {
                            _5659 = _4848;
                            _5660 = _5642;
                            _5661 = 0.0f;
                          }
                        } else {
                          if (_5644) {
                            _5659 = ((_4850 * (_4848 + -1.0f)) + 1.0f);
                            _5660 = _5642;
                            _5661 = 1.0f;
                          } else {
                            _5659 = _4848;
                            _5660 = _5642;
                            _5661 = (_4850 * _3891);
                          }
                        }
                        _5664 = (_5661 * (_5659 - _5660)) + _5660;
                        [branch]
                        if (!((_1620 & 2048) == 0)) {
                          _5667 = _229 - _3808;
                          _5668 = _230 - _3809;
                          _5669 = _231 - _3810;
                          _5684 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5669, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5668, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5667)));
                          _5687 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _5669, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _5668, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _5667)));
                          _5690 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _5669, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _5668, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _5667)));
                          _5692 = rsqrt(dot(float3(_5684, _5687, _5690), float3(_5684, _5687, _5690)));
                          _5693 = _5692 * _5684;
                          _5694 = _5692 * _5687;
                          _5695 = _5692 * _5690;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3842) >> 16))];
                          _5703 = (abs(_5694) + abs(_5693)) + abs(_5695);
                          _5704 = _5693 / _5703;
                          _5705 = _5694 / _5703;
                          _5707 = !((_5695 / _5703) >= 0.0f);
                          if (_5707) {
                            _5720 = ((1.0f - abs(_5705)) * select((_5704 >= 0.0f), 1.0f, -1.0f));
                            _5721 = ((1.0f - abs(_5704)) * select((_5705 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _5720 = _5704;
                            _5721 = _5705;
                          }
                          _5727 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5720 * 0.5f) + 0.5f), ((_5721 * 0.5f) + 0.5f)), 0.0f);
                          if (_5727.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3842 & 65535))];
                            if (_5707) {
                              _5746 = ((1.0f - abs(_5705)) * select((_5704 >= 0.0f), 1.0f, -1.0f));
                              _5747 = ((1.0f - abs(_5704)) * select((_5705 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _5746 = _5704;
                              _5747 = _5705;
                            }
                            _5752 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5746 * 0.5f) + 0.5f), ((_5747 * 0.5f) + 0.5f)), 0.0f);
                            _5772 = mad(saturate(((log2(sqrt(((_5667 * _5667) + (_5668 * _5668)) + (_5669 * _5669))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _5773 = max(9.999999747378752e-06f, _5727.x);
                            _5774 = _5752.x / _5773;
                            _5775 = _5752.y / _5773;
                            _5777 = _5752.w / _5773;
                            _5782 = ((0.375f - _5775) * 4.999999873689376e-06f) + _5775;
                            _5785 = -0.0f - _5774;
                            _5786 = mad(_5785, _5782, (_5752.z / _5773));
                            _5788 = 1.0f / mad(_5785, _5774, _5782);
                            _5789 = _5788 * _5786;
                            _5794 = _5772 - _5774;
                            _5799 = (((_5772 * _5772) - _5782) - (_5789 * _5794)) / mad((-0.0f - _5786), _5789, mad((-0.0f - _5782), _5782, (((0.375f - _5777) * 4.999999873689376e-06f) + _5777)));
                            _5801 = (_5788 * _5794) - (_5799 * _5789);
                            _5804 = 1.0f / _5799;
                            _5805 = _5801 * _5804;
                            _5810 = sqrt(((_5805 * _5805) * 0.25f) - ((1.0f - dot(float2(_5801, _5799), float2(_5774, _5782))) * _5804));
                            _5812 = (_5805 * -0.5f) - _5810;
                            _5814 = _5810 - (_5805 * 0.5f);
                            _5816 = select((_5812 < _5772), 1.0f, 0.0f);
                            _5821 = (_5816 + -0.05000000074505806f) / (_5812 - _5772);
                            _5827 = (((select((_5814 < _5772), 1.0f, 0.0f) - _5816) / (_5814 - _5812)) - _5821) / (_5814 - _5772);
                            _5829 = _5821 - (_5827 * _5812);
                            _5842 = (exp2((_5727.x * -1.4426950216293335f) * saturate((dot(float2(_5774, _5782), float2((_5829 - (_5827 * _5772)), _5827)) + 0.05000000074505806f) - (_5829 * _5772))) * _5664);
                          } else {
                            _5842 = _5664;
                          }
                        } else {
                          _5842 = _5664;
                        }
                        _5845 = (_5842 * _3966);
                        _5846 = _4852;
                        _5847 = (_4850 * _4849);
                        _5848 = _5842;
                      } else {
                        _5845 = _3966;
                        _5846 = 0.0f;
                        _5847 = 0.0f;
                        _5848 = 1.0f;
                      }
                      [branch]
                      if (!(_3893 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3893)))];
                        _5860 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3945, _3803, mad(_3944, _3798, (_3943 * _3793)))), (-0.0f - mad(_3945, _3804, mad(_3944, _3799, (_3943 * _3794)))), (-0.0f - mad(_3945, _3805, mad(_3944, _3800, (_3943 * _3795))))), 0.0f);
                        _5868 = (_5860.x * _3868);
                        _5869 = (_5860.y * _3869);
                        _5870 = (_5860.z * _3871);
                      } else {
                        _5868 = _3868;
                        _5869 = _3869;
                        _5870 = _3871;
                      }
                      [branch]
                      if (!(_5845 == 0.0f)) {
                        bool __branch_chain_5872;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _5888 = 0;
                          __branch_chain_5872 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _5888 = 1;
                            __branch_chain_5872 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _5888 = 2;
                              __branch_chain_5872 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _5888 = 3;
                                __branch_chain_5872 = true;
                              } else {
                                _5909 = _5845;
                                __branch_chain_5872 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_5872) {
                          while(true) {
                            _5891 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                            if (_5888 == 0) {
                              _5905 = _5891.x;
                            } else {
                              if (_5888 == 1) {
                                _5905 = _5891.y;
                              } else {
                                if (_5888 == 2) {
                                  _5905 = _5891.z;
                                } else {
                                  _5905 = _5891.w;
                                }
                              }
                            }
                            _5909 = ((_5905 * _5905) * _3966);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_5909 == 0.0f)) {
                            [branch]
                            if (_3997) {
                              if (!_233) {
                                _5919 = ((_5846 * _3966) * _5847) * saturate(0.30000001192092896f - dot(float3(_3949, _3950, _3951), float3(_190, _191, _192)));
                                _5924 = (_5919 * _1292);
                                _5925 = (_5919 * _1293);
                                _5926 = (_5919 * _1294);
                              } else {
                                _5924 = 0.0f;
                                _5925 = 0.0f;
                                _5926 = 0.0f;
                              }
                              [branch]
                              if (!((_3845 & 1) == 0)) {
                                _5939 = max(max(_5868, _5869), _5870);
                                if (_5939 > 0.0f) {
                                  _5949 = saturate(_5868 / _5939);
                                  _5950 = saturate(_5869 / _5939);
                                  _5951 = saturate(_5870 / _5939);
                                } else {
                                  _5949 = _5868;
                                  _5950 = _5869;
                                  _5951 = _5870;
                                }
                                _5952 = (_5950 < _5951);
                                _5953 = select(_5952, _5951, _5950);
                                _5954 = select(_5952, _5950, _5951);
                                _5955 = select(_5952, -1.0f, 0.0f);
                                _5956 = (_5949 < _5953);
                                _5958 = select(_5956, _5953, _5949);
                                _5959 = select(_5956, _5949, _5953);
                                _5963 = _5958 - select((_5959 < _5954), _5959, _5954);
                                _5969 = abs(select(_5956, (-0.3333333432674408f - _5955), _5955) + ((_5959 - _5954) / ((_5963 * 6.0f) + 9.999999682655225e-21f)));
                                if (_5969 < 0.6666666865348816f) {
                                  _5982 = ((saturate(((float)((uint)((uint)(((uint)(_3845) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5969 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5969)) + _5969);
                                } else {
                                  _5982 = _5969;
                                }
                                _5983 = saturate((_5963 / (_5958 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3845) >> 1) & 255)))) * 0.003921499941498041f));
                                _5984 = saturate(_5958);
                                if (!(_5983 <= 0.0f)) {
                                  _5987 = saturate(_5982);
                                  _5991 = select(((_5987 * 360.0f) >= 360.0f), 0.0f, (_5987 * 6.0f));
                                  _5992 = int(_5991);
                                  _5994 = _5991 - float((int)(_5992));
                                  _5996 = _5984 * (1.0f - _5983);
                                  _5999 = (1.0f - (_5994 * _5983)) * _5984;
                                  _6003 = (1.0f - ((1.0f - _5994) * _5983)) * _5984;
                                  switch (_5992) {
                                    case 0: {
                                      _6011 = _5984;
                                      _6012 = _6003;
                                      _6013 = _5996;
                                      break;
                                    }
                                    case 1: {
                                      _6011 = _5999;
                                      _6012 = _5984;
                                      _6013 = _5996;
                                      break;
                                    }
                                    case 2: {
                                      _6011 = _5996;
                                      _6012 = _5984;
                                      _6013 = _6003;
                                      break;
                                    }
                                    case 3: {
                                      _6011 = _5996;
                                      _6012 = _5999;
                                      _6013 = _5984;
                                      break;
                                    }
                                    case 4: {
                                      _6011 = _6003;
                                      _6012 = _5996;
                                      _6013 = _5984;
                                      break;
                                    }
                                    case 5: {
                                      _6011 = _5984;
                                      _6012 = _5996;
                                      _6013 = _5999;
                                      break;
                                    }
                                    default: {
                                      _6011 = 0.0f;
                                      _6012 = 0.0f;
                                      _6013 = 0.0f;
                                      break;
                                    }
                                  }
                                } else {
                                  _6011 = _5984;
                                  _6012 = _5984;
                                  _6013 = _5984;
                                }
                                _6014 = _6011 * _5939;
                                _6015 = _6012 * _5939;
                                _6016 = _6013 * _5939;
                                _6018 = saturate(_5848 * 1.0101009607315063f);
                                _6029 = ((_6018 * (_5868 - _6014)) + _6014);
                                _6030 = ((_6018 * (_5869 - _6015)) + _6015);
                                _6031 = (lerp(_6016, _5870, _6018));
                                _6032 = _5924;
                                _6033 = _5925;
                                _6034 = _5926;
                              } else {
                                _6029 = _5868;
                                _6030 = _5869;
                                _6031 = _5870;
                                _6032 = _5924;
                                _6033 = _5925;
                                _6034 = _5926;
                              }
                            } else {
                              _6029 = _5868;
                              _6030 = _5869;
                              _6031 = _5870;
                              _6032 = 0.0f;
                              _6033 = 0.0f;
                              _6034 = 0.0f;
                            }
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _6041 = srvLightMappingData[_1623];
                              if (!(_6041 == -1)) {
                                _6046 = srvLightIndexData[_6041].nLayerIndex;
                                _6048 = srvLightIndexData[_6041].vAtlasOrigin.x;
                                _6049 = srvLightIndexData[_6041].vAtlasOrigin.y;
                                _6051 = srvLightIndexData[_6041].vScreenOrigin.x;
                                _6052 = srvLightIndexData[_6041].vScreenOrigin.y;
                                _6061 = ((int)(_6046 * 5)) & 31;
                                _6070 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6048 + _65) - _6051)), ((int)((_6049 + _66) - _6052)), 0)))).x) & ((int)(31 << _6061)))) >> _6061)) >> 1)))) * 0.06666667014360428f) * _5909);
                              } else {
                                _6070 = _5909;
                              }
                            } else {
                              _6070 = _5909;
                            }
                            _6074 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _6077 = select(_6074, (_6070 * _1280), _6070);
                            _6079 = _3949 * _3948;
                            _6080 = _3950 * _3948;
                            _6081 = _3951 * _3948;
                            _6082 = _3879 * _3813;
                            _6083 = _3879 * _3814;
                            _6084 = _3879 * _3815;
                            _6085 = _6079 + _6082;
                            _6086 = _6080 + _6083;
                            _6087 = _6081 + _6084;
                            _6088 = _6079 - _6082;
                            _6089 = _6080 - _6083;
                            _6090 = _6081 - _6084;
                            _6091 = (_3879 > 0.0f);
                            _6092 = dot(float3(_6085, _6086, _6087), float3(_6085, _6086, _6087));
                            _6093 = rsqrt(_6092);
                            [branch]
                            if (_6091) {
                              _6096 = rsqrt(dot(float3(_6088, _6089, _6090), float3(_6088, _6089, _6090)));
                              _6097 = _6096 * _6093;
                              _6099 = dot(float3(_6085, _6086, _6087), float3(_6088, _6089, _6090)) * _6097;
                              _6118 = (_6097 / ((_6097 + 0.5f) + (_6099 * 0.5f)));
                              _6119 = (((dot(float3(_190, _191, _192), float3(_6088, _6089, _6090)) * _6096) + (dot(float3(_190, _191, _192), float3(_6085, _6086, _6087)) * _6093)) * 0.5f);
                              _6120 = _6099;
                            } else {
                              _6118 = (1.0f / (_6092 + 1.0f));
                              _6119 = dot(float3(_190, _191, _192), float3((_6093 * _6085), (_6093 * _6086), (_6093 * _6087)));
                              _6120 = 1.0f;
                            }
                            if (_3881 > 0.0f) {
                              _6126 = sqrt(saturate((_3881 * _3881) * _6118));
                              if (_6119 < _6126) {
                                _6131 = max(_6119, (-0.0f - _6126)) + _6126;
                                _6136 = ((_6131 * _6131) / (_6126 * 4.0f));
                              } else {
                                _6136 = _6119;
                              }
                            } else {
                              _6136 = _6119;
                            }
                            if (_6091) {
                              _6138 = -0.0f - _451;
                              _6139 = -0.0f - _452;
                              _6140 = -0.0f - _450;
                              _6142 = dot(float3(_6138, _6139, _6140), float3(_190, _191, _192)) * 2.0f;
                              _6146 = _6138 - (_6142 * _190);
                              _6147 = _6139 - (_6142 * _191);
                              _6148 = _6140 - (_6142 * _192);
                              _6149 = _6088 - _6085;
                              _6150 = _6089 - _6086;
                              _6151 = _6090 - _6087;
                              _6152 = dot(float3(_6146, _6147, _6148), float3(_6149, _6150, _6151));
                              _6158 = sqrt(((_6149 * _6149) + (_6150 * _6150)) + (_6151 * _6151));
                              _6167 = saturate(((dot(float3(_6146, _6147, _6148), float3(_6085, _6086, _6087)) * _6152) - dot(float3(_6085, _6086, _6087), float3(_6149, _6150, _6151))) / ((_6158 * _6158) - (_6152 * _6152)));
                              _6171 = (_6167 * _6149) + _6085;
                              _6172 = (_6167 * _6150) + _6086;
                              _6173 = (_6167 * _6151) + _6087;
                              _6174 = dot(float3(_6171, _6172, _6173), float3(_6146, _6147, _6148));
                              _6178 = (_6174 * _6146) - _6171;
                              _6179 = (_6174 * _6147) - _6172;
                              _6180 = (_6174 * _6148) - _6173;
                              _6188 = saturate(0.009999999776482582f / sqrt(((_6178 * _6178) + (_6179 * _6179)) + (_6180 * _6180)));
                              _6196 = ((_6188 * _6178) + _6171);
                              _6197 = ((_6188 * _6179) + _6172);
                              _6198 = ((_6188 * _6180) + _6173);
                            } else {
                              _6196 = _6085;
                              _6197 = _6086;
                              _6198 = _6087;
                            }
                            _6200 = rsqrt(dot(float3(_6196, _6197, _6198), float3(_6196, _6197, _6198)));
                            _6201 = _6200 * _6196;
                            _6202 = _6200 * _6197;
                            _6203 = _6200 * _6198;
                            _6204 = _218 * _218;
                            _6208 = saturate((_3881 * (1.0f - _6204)) * _6200);
                            _6210 = saturate(_6200 * f16tof32(_3827));
                            _6212 = rsqrt(dot(float3(_6079, _6080, _6081), float3(_6079, _6080, _6081)));
                            _6216 = dot(float3(_190, _191, _192), float3(_6201, _6202, _6203));
                            _6217 = dot(float3(_190, _191, _192), float3(_451, _452, _450));
                            _6218 = dot(float3(_451, _452, _450), float3(_6201, _6202, _6203));
                            _6221 = rsqrt((_6218 * 2.0f) + 2.0f);
                            _6228 = (_6208 > 0.0f);
                            if (_6228) {
                              _6232 = sqrt(1.0f - (_6208 * _6208));
                              _6234 = (_6216 * 2.0f) * _6217;
                              _6235 = _6234 - _6218;
                              if (!(_6235 >= _6232)) {
                                _6243 = rsqrt(1.0f - (_6235 * _6235)) * _6208;
                                _6246 = _6243 * (_6217 - (_6235 * _6216));
                                _6247 = _6217 * _6217;
                                _6252 = _6243 * (((_6247 * 2.0f) + -1.0f) - (_6235 * _6218));
                                _6261 = sqrt(saturate((((1.0f - (_6216 * _6216)) - _6247) - (_6218 * _6218)) + (_6234 * _6218)));
                                _6262 = _6261 * _6243;
                                _6265 = ((_6217 * 2.0f) * _6243) * _6261;
                                _6267 = (_6232 * _6216) + _6217;
                                _6268 = _6267 + _6246;
                                _6269 = _6232 * _6218;
                                _6271 = (_6269 + 1.0f) + _6252;
                                _6272 = _6262 * _6271;
                                _6273 = _6268 * _6271;
                                _6274 = _6265 * _6268;
                                _6279 = (((_6268 * 0.25f) * _6265) - (_6272 * 0.5f)) * _6273;
                                _6293 = (((_6274 - (_6272 * 2.0f)) * _6274) + (_6272 * _6272)) + ((((-0.5f - ((_6271 + _6269) * 0.5f)) * _6273) + ((_6271 * _6271) * _6267)) * _6268);
                                _6298 = (_6279 * 2.0f) / ((_6293 * _6293) + (_6279 * _6279));
                                _6299 = _6293 * _6298;
                                _6301 = 1.0f - (_6279 * _6298);
                                _6307 = ((_6299 * _6265) + _6269) + (_6301 * _6252);
                                _6310 = rsqrt((_6307 * 2.0f) + 2.0f);
                                _6319 = saturate((_6307 * _6310) + _6310);
                                _6320 = saturate(((_6267 + (_6299 * _6262)) + (_6301 * _6246)) * _6310);
                              } else {
                                _6319 = abs(_6217);
                                _6320 = 1.0f;
                              }
                            } else {
                              _6319 = saturate((_6221 * _6218) + _6221);
                              _6320 = saturate(_6221 * (_6217 + _6216));
                            }
                            _6321 = saturate(_6136);
                            _6323 = _6204 * _6204;
                            if (_6210 > 0.0f) {
                              _6333 = saturate(((_6210 * _6210) / ((_6319 * 3.5999999046325684f) + 0.4000000059604645f)) + _6323);
                            } else {
                              _6333 = _6323;
                            }
                            if (_6228) {
                              _6342 = (((_6208 * 0.25f) * ((sqrt(_6333) * 3.0f) + _6208)) / (_6319 + 0.0010000000474974513f)) + _6333;
                              _6345 = _6342;
                              _6346 = (_6333 / _6342);
                            } else {
                              _6345 = _6333;
                              _6346 = 1.0f;
                            }
                            if (_6120 < 1.0f) {
                              _6353 = sqrt((1.000100016593933f - _6120) / max(9.999999974752427e-07f, (_6120 + 1.0f)));
                              _6366 = (sqrt(_6345 / ((((_6353 * 0.25f) * ((sqrt(_6345) * 3.0f) + _6353)) / (_6319 + 0.0010000000474974513f)) + _6345)) * _6346);
                            } else {
                              _6366 = _6346;
                            }
                            _6370 = (((_6333 * _6320) - _6320) * _6320) + 1.0f;
                            _6377 = exp2(log2(1.0f - saturate(_6319)) * 5.0f);
                            _6380 = saturate(abs(_6217) + 9.999999747378752e-06f);
                            _6381 = sqrt(_6333);
                            _6382 = 1.0f - _6381;
                            _6394 = saturate((dot(float3(_190, _191, _192), float3((_6212 * _6079), (_6212 * _6080), (_6212 * _6081))) + _3878) / (_3878 + 1.0f));
                            _6397 = ((_6366 * _6321) * (_6333 / (_6370 * _6370))) * (0.5f / ((((_6382 * _6380) + _6381) * _6321) + (((_6382 * _6321) + _6381) * _6380)));
                            _6398 = _6029 * _1671;
                            _6399 = _6030 * _1671;
                            _6400 = _6031 * _1671;
                            if (_3875 > 0.0f) {
                              _6422 = (_3875 * _1367) * select(_6074, (_6070 * _1280), _6070);
                              _6439 = (((((_6398 * _1143) * _6422) * ((_6377 * (1.0f - _210)) + _210)) * _6397) + _1611);
                              _6440 = (((((_6399 * _1144) * _6422) * ((_6377 * (1.0f - _211)) + _211)) * _6397) + _1612);
                              _6441 = (((((_6400 * _1145) * _6422) * ((_6377 * (1.0f - _212)) + _212)) * _6397) + _1613);
                            } else {
                              _6439 = _1611;
                              _6440 = _1612;
                              _6441 = _1613;
                            }
                            _8848 = (((_6077 * _6398) * _6394) + _1608);
                            _8849 = (((_6077 * _6399) * _6394) + _1609);
                            _8850 = (((_6077 * _6400) * _6394) + _1610);
                            _8851 = (_6439 + (_6032 * _6398));
                            _8852 = (_6440 + (_6033 * _6399));
                            _8853 = (_6441 + (_6034 * _6400));
                          } else {
                            _8848 = _1608;
                            _8849 = _1609;
                            _8850 = _1610;
                            _8851 = _1611;
                            _8852 = _1612;
                            _8853 = _1613;
                          }
                          break;
                        }
                      } else {
                        _8848 = _1608;
                        _8849 = _1609;
                        _8850 = _1610;
                        _8851 = _1611;
                        _8852 = _1612;
                        _8853 = _1613;
                      }
                    } else {
                      if (_1654 == 8) {
                        _6453 = asfloat(srvLightInfoProperties.Load3(_1622)).x;
                        _6454 = asfloat(srvLightInfoProperties.Load3(_1622)).y;
                        _6455 = asfloat(srvLightInfoProperties.Load3(_1622)).z;
                        _6458 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 12u)))).x;
                        _6459 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 12u)))).y;
                        _6460 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 12u)))).z;
                        _6463 = asfloat(srvLightInfoProperties.Load(((int)(_1622 + 24u))));
                        _6466 = asint(srvLightInfoProperties.Load(((int)(_1622 + 28u))));
                        _6469 = asint(srvLightInfoProperties.Load(((int)(_1622 + 32u))));
                        _6472 = asint(srvLightInfoProperties.Load(((int)(_1622 + 44u))));
                        _6481 = ((float)((uint)((uint)(((uint)(_6469) >> 8) & 255)))) * 0.003921499941498041f;
                        _6484 = ((float)((uint)((uint)(_6469 & 255)))) * 0.003921499941498041f;
                        _6487 = f16tof32(_6472);
                        _6494 = min(max(dot(float3((_229 - _6453), (_230 - _6454), (_231 - _6455)), float3(_6458, _6459, _6460)), (-0.0f - _6463)), _6463);
                        _6499 = (_6453 - _229) + (_6494 * _6458);
                        _6501 = (_6454 - _230) + (_6494 * _6459);
                        _6503 = (_6455 + _228) + (_6494 * _6460);
                        _6504 = dot(float3(_6499, _6501, _6503), float3(_6499, _6501, _6503));
                        _6505 = rsqrt(_6504);
                        _6507 = _6499 * _6505;
                        _6508 = _6501 * _6505;
                        _6509 = _6503 * _6505;
                        _6512 = max(0.0f, ((_6505 * _6504) - abs(_6487)));
                        _6513 = _6512 * f16tof32(((uint)((uint)(_6472) >> 16)));
                        _6514 = _6513 * _6513;
                        _6517 = saturate(1.0f - (_6514 * _6514));
                        _6524 = (_6517 * _6517) / (select((_6487 < 0.0f), (_6514 * 16.0f), (_6512 * _6512)) + 1.0f);
                        [branch]
                        if (!(_6524 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _6533 = srvLightMappingData[_1623];
                            if (!(_6533 == -1)) {
                              _6538 = srvLightIndexData[_6533].nLayerIndex;
                              _6540 = srvLightIndexData[_6533].vAtlasOrigin.x;
                              _6541 = srvLightIndexData[_6533].vAtlasOrigin.y;
                              _6543 = srvLightIndexData[_6533].vScreenOrigin.x;
                              _6544 = srvLightIndexData[_6533].vScreenOrigin.y;
                              _6553 = ((int)(_6538 * 5)) & 31;
                              _6562 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6540 + _65) - _6543)), ((int)((_6541 + _66) - _6544)), 0)))).x) & ((int)(31 << _6553)))) >> _6553)) >> 1)))) * 0.06666667014360428f) * _6524);
                            } else {
                              _6562 = _6524;
                            }
                          } else {
                            _6562 = _6524;
                          }
                          _6566 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _6568 = select(_6566, (_6562 * _1280), _6562);
                          _6569 = dot(float3(_190, _191, _192), float3(_6507, _6508, _6509));
                          _6570 = dot(float3(_190, _191, _192), float3(_451, _452, _450));
                          _6571 = dot(float3(_451, _452, _450), float3(_6507, _6508, _6509));
                          _6574 = rsqrt((_6571 * 2.0f) + 2.0f);
                          _6577 = saturate(_6574 * (_6570 + _6569));
                          _6581 = saturate(_6569);
                          _6582 = _218 * _218;
                          _6583 = _6582 * _6582;
                          _6587 = (((_6577 * _6583) - _6577) * _6577) + 1.0f;
                          _6594 = exp2(log2(1.0f - saturate(saturate((_6574 * _6571) + _6574))) * 5.0f);
                          _6597 = saturate(abs(_6570) + 9.999999747378752e-06f);
                          _6598 = sqrt(_6583);
                          _6599 = 1.0f - _6598;
                          _6611 = saturate((_6569 + _6484) / (_6484 + 1.0f));
                          _6613 = ((_6583 / (_6587 * _6587)) * _6581) * (0.5f / ((((_6599 * _6597) + _6598) * _6581) + (((_6599 * _6581) + _6598) * _6597)));
                          _6614 = f16tof32(((uint)((uint)(_6466) >> 16))) * _1671;
                          _6615 = f16tof32(_6466) * _1671;
                          _6616 = f16tof32(((uint)((uint)(_6469) >> 16))) * _1671;
                          _6623 = ((_6568 * _6614) * _6611) + _1608;
                          _6624 = ((_6568 * _6615) * _6611) + _1609;
                          _6625 = ((_6568 * _6616) * _6611) + _1610;
                          if (_6481 > 0.0f) {
                            _6640 = (_6481 * _1367) * select(_6566, (_6562 * _1280), _6562);
                            _8848 = _6623;
                            _8849 = _6624;
                            _8850 = _6625;
                            _8851 = (((((_6614 * _1143) * _6640) * ((_6594 * (1.0f - _210)) + _210)) * _6613) + _1611);
                            _8852 = (((((_6615 * _1144) * _6640) * ((_6594 * (1.0f - _211)) + _211)) * _6613) + _1612);
                            _8853 = (((((_6616 * _1145) * _6640) * ((_6594 * (1.0f - _212)) + _212)) * _6613) + _1613);
                          } else {
                            _8848 = _6623;
                            _8849 = _6624;
                            _8850 = _6625;
                            _8851 = _1611;
                            _8852 = _1612;
                            _8853 = _1613;
                          }
                        } else {
                          _8848 = _1608;
                          _8849 = _1609;
                          _8850 = _1610;
                          _8851 = _1611;
                          _8852 = _1612;
                          _8853 = _1613;
                        }
                      } else {
                        if (_1654 == 9) {
                          _6661 = asfloat(srvLightInfoProperties.Load4(_1622)).x;
                          _6662 = asfloat(srvLightInfoProperties.Load4(_1622)).y;
                          _6663 = asfloat(srvLightInfoProperties.Load4(_1622)).w;
                          _6666 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).x;
                          _6667 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).y;
                          _6668 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).w;
                          _6671 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).x;
                          _6672 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).y;
                          _6673 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).w;
                          _6676 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 48u)))).x;
                          _6677 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 48u)))).y;
                          _6678 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 48u)))).w;
                          _6681 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 64u)))).x;
                          _6682 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 64u)))).y;
                          _6683 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 64u)))).z;
                          _6686 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 76u)))).x;
                          _6687 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 76u)))).y;
                          _6688 = asfloat(srvLightInfoProperties.Load3(((int)(_1622 + 76u)))).z;
                          _6691 = asint(srvLightInfoProperties.Load(((int)(_1622 + 88u))));
                          _6694 = asint(srvLightInfoProperties.Load(((int)(_1622 + 92u))));
                          _6697 = asint(srvLightInfoProperties.Load(((int)(_1622 + 100u))));
                          _6700 = asint(srvLightInfoProperties.Load(((int)(_1622 + 104u))));
                          _6703 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).x;
                          _6704 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).y;
                          _6705 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).z;
                          _6706 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 108u)))).w;
                          _6709 = asint(srvLightInfoProperties.Load(((int)(_1622 + 124u))));
                          _6712 = asint(srvLightInfoProperties.Load(((int)(_1622 + 128u))));
                          _6715 = asint(srvLightInfoProperties.Load(((int)(_1622 + 132u))));
                          _6718 = asint(srvLightInfoProperties.Load(((int)(_1622 + 136u))));
                          _6721 = asint(srvLightInfoProperties.Load(((int)(_1622 + 140u))));
                          _6724 = asint(srvLightInfoProperties.Load(((int)(_1622 + 144u))));
                          _6727 = asint(srvLightInfoProperties.Load(((int)(_1622 + 148u))));
                          _6730 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 152u)))).x;
                          _6731 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 152u)))).y;
                          _6732 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 152u)))).z;
                          _6733 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 152u)))).w;
                          _6736 = asint(srvLightInfoProperties.Load(((int)(_1622 + 168u))));
                          _6739 = asint(srvLightInfoProperties.Load(((int)(_1622 + 172u))));
                          _6742 = asint(srvLightInfoProperties.Load(((int)(_1622 + 180u))));
                          _6744 = f16tof32(((uint)((uint)(_6691) >> 16)));
                          _6745 = f16tof32(_6691);
                          _6747 = f16tof32(((uint)((uint)(_6694) >> 16)));
                          _6751 = ((float)((uint)((uint)(((uint)(_6694) >> 8) & 255)))) * 0.003921499941498041f;
                          _6754 = ((float)((uint)((uint)(_6694 & 255)))) * 0.003921499941498041f;
                          _6755 = f16tof32(_6697);
                          _6757 = f16tof32(((uint)((uint)(_6700) >> 16)));
                          _6761 = f16tof32(_6709);
                          _6765 = _6715 & 65535;
                          _6771 = ((_1620 & 3584) != 0);
                          _6782 = f16tof32(((uint)((uint)(_6739) >> 16)));
                          _6783 = f16tof32(_6739);
                          _6785 = f16tof32(((uint)((uint)(_6742) >> 16)));
                          _6786 = 1.0f / _6785;
                          _6787 = _6785 + -1.0f;
                          _6788 = f16tof32(_6742);
                          _6789 = _6681 - _229;
                          _6790 = _6682 - _230;
                          _6791 = _6683 + _228;
                          _6792 = dot(float3(_6789, _6790, _6791), float3(_6789, _6790, _6791));
                          _6793 = rsqrt(_6792);
                          _6794 = _6793 * _6792;
                          _6795 = _6793 * _6789;
                          _6796 = _6793 * _6790;
                          _6797 = _6793 * _6791;
                          _6800 = max(0.0f, (_6794 - abs(_6761)));
                          _6801 = _6800 * f16tof32(((uint)((uint)(_6709) >> 16)));
                          _6802 = _6801 * _6801;
                          _6805 = saturate(1.0f - (_6802 * _6802));
                          _6816 = mad(_231, _6673, mad(_230, _6668, (_6663 * _229))) + _6678;
                          _6820 = saturate(1.0f - dot(float3(_190, _191, _192), float3(_6795, _6796, _6797))) * f16tof32(_6736);
                          _6827 = ((_6816 * _190) * _6820) + _229;
                          _6828 = ((_6816 * _191) * _6820) + _230;
                          _6829 = ((_6816 * _192) * _6820) - _228;
                          _6841 = mad(_6829, _6673, mad(_6828, _6668, (_6827 * _6663))) + _6678;
                          _6842 = 1.0f / _6841;
                          _6843 = _6842 * (mad(_6829, _6671, mad(_6828, _6666, (_6827 * _6661))) + _6676);
                          _6844 = _6842 * (mad(_6829, _6672, mad(_6828, _6667, (_6827 * _6662))) + _6677);
                          _6847 = (_6843 * _6703) + _6704;
                          _6848 = (_6844 * _6703) + _6704;
                          _6851 = _6847 - saturate(_6847);
                          _6852 = _6848 - saturate(_6848);
                          _6859 = saturate((sqrt((_6851 * _6851) + (_6852 * _6852)) * _6705) + _6706);
                          _6861 = 1.0f - (_6859 * _6859);
                          _6867 = (_6861 * _6861) * (((float)((bool)(uint)((_6841 - f16tof32(((uint)((uint)(_6712) >> 16)))) > 0.0f))) * ((_6805 * _6805) / (select((_6761 < 0.0f), (_6802 * 16.0f), (_6800 * _6800)) + 1.0f)));
                          if (!((!(_6867 > 0.0f)) || (!_6771))) {
                            _6877 = 1.0f - saturate(f16tof32(_6712) * _6841);
                            _6878 = saturate(_6843);
                            _6879 = saturate(_6844);
                            bool __branch_chain_6871;
                            [branch]
                            if ((_1620 & 1024) == 0) {
                              _7192 = 1.0f;
                              _7193 = 1.0f;
                              _7194 = 0.0f;
                              _7195 = _6877;
                              __branch_chain_6871 = true;
                            } else {
                              _6884 = ((_6878 * _6787) + 0.5f) * _6786;
                              _6886 = ((_6879 * _6787) + 0.5f) * _6786;
                              _6887 = _6877 + f16tof32(((uint)((uint)(_6736) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6715) >> 16))];
                              _6890 = saturate(_6887);
                              _6894 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _6903 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_6894 * 32.665000915527344f) + _127), ((_6894 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _6904 = sin(_6903);
                              _6905 = cos(_6903);
                              _6906 = cbSharedPerViewData.nFrameCounter & 3;
                              _6911 = sqrt((float((int)(_6906)) * 0.25f) + 0.125f) * _6782;
                              _6920 = (_global_7[min((uint)(((int)(0u + (_6906 * 2)))), 127u)]) * _6911;
                              _6921 = (_global_7[min((uint)(((int)(1u + (_6906 * 2)))), 127u)]) * _6911;
                              _6923 = -0.0f - _6904;
                              _6928 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6920, _6921), float2(_6905, _6904)) + _6884), (dot(float2(_6920, _6921), float2(_6923, _6905)) + _6886)));
                              _6933 = _6928.x - _6890;
                              _6935 = select((_6933 < 0.0f), 0.0f, 1.0f);
                              _6937 = _6928.y - _6890;
                              _6939 = select((_6937 < 0.0f), 0.0f, 1.0f);
                              _6943 = _6928.z - _6890;
                              _6945 = select((_6943 < 0.0f), 0.0f, 1.0f);
                              _6949 = _6928.w - _6890;
                              _6951 = select((_6949 < 0.0f), 0.0f, 1.0f);
                              _6958 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _6963 = sqrt((float((int)(_6958)) * 0.25f) + 0.125f) * _6782;
                              _6972 = (_global_7[min((uint)(((int)(0u + (_6958 * 2)))), 127u)]) * _6963;
                              _6973 = (_global_7[min((uint)(((int)(1u + (_6958 * 2)))), 127u)]) * _6963;
                              _6979 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6972, _6973), float2(_6905, _6904)) + _6884), (dot(float2(_6972, _6973), float2(_6923, _6905)) + _6886)));
                              _6984 = _6979.x - _6890;
                              _6986 = select((_6984 < 0.0f), 0.0f, 1.0f);
                              _6990 = _6979.y - _6890;
                              _6992 = select((_6990 < 0.0f), 0.0f, 1.0f);
                              _6996 = _6979.z - _6890;
                              _6998 = select((_6996 < 0.0f), 0.0f, 1.0f);
                              _7002 = _6979.w - _6890;
                              _7004 = select((_7002 < 0.0f), 0.0f, 1.0f);
                              _7011 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _7016 = sqrt((float((int)(_7011)) * 0.25f) + 0.125f) * _6782;
                              _7025 = (_global_7[min((uint)(((int)(0u + (_7011 * 2)))), 127u)]) * _7016;
                              _7026 = (_global_7[min((uint)(((int)(1u + (_7011 * 2)))), 127u)]) * _7016;
                              _7032 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7025, _7026), float2(_6905, _6904)) + _6884), (dot(float2(_7025, _7026), float2(_6923, _6905)) + _6886)));
                              _7037 = _7032.x - _6890;
                              _7039 = select((_7037 < 0.0f), 0.0f, 1.0f);
                              _7043 = _7032.y - _6890;
                              _7045 = select((_7043 < 0.0f), 0.0f, 1.0f);
                              _7049 = _7032.z - _6890;
                              _7051 = select((_7049 < 0.0f), 0.0f, 1.0f);
                              _7055 = _7032.w - _6890;
                              _7057 = select((_7055 < 0.0f), 0.0f, 1.0f);
                              _7064 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _7069 = sqrt((float((int)(_7064)) * 0.25f) + 0.125f) * _6782;
                              _7078 = (_global_7[min((uint)(((int)(0u + (_7064 * 2)))), 127u)]) * _7069;
                              _7079 = (_global_7[min((uint)(((int)(1u + (_7064 * 2)))), 127u)]) * _7069;
                              _7085 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7078, _7079), float2(_6905, _6904)) + _6884), (dot(float2(_7078, _7079), float2(_6923, _6905)) + _6886)));
                              _7090 = _7085.x - _6890;
                              _7092 = select((_7090 < 0.0f), 0.0f, 1.0f);
                              _7096 = _7085.y - _6890;
                              _7098 = select((_7096 < 0.0f), 0.0f, 1.0f);
                              _7102 = _7085.z - _6890;
                              _7104 = select((_7102 < 0.0f), 0.0f, 1.0f);
                              _7108 = _7085.w - _6890;
                              _7110 = select((_7108 < 0.0f), 0.0f, 1.0f);
                              _7111 = ((((((((((((((_6935 + _6939) + _6945) + _6951) + _6986) + _6992) + _6998) + _7004) + _7039) + _7045) + _7051) + _7057) + _7092) + _7098) + _7104) + _7110;
                              _7122 = (saturate(_7111 * 0.0625f) * 2.0f) + -1.0f;
                              _7128 = float((int)(((int)(uint)((int)(_7122 > 0.0f))) - ((int)(uint)((int)(_7122 < 0.0f)))));
                              _7130 = 1.0f - (_7128 * _7122);
                              _7132 = (_7130 * _7130) * _7130;
                              _7139 = 0.5f - ((_7128 * 0.5f) * ((1.0f - _7132) - ((_7130 - _7132) * saturate(((1.0f / _6890) * (1.0f / _7111)) * ((((((((((((((((_6935 * _6933) + (_6939 * _6937)) + (_6945 * _6943)) + (_6951 * _6949)) + (_6986 * _6984)) + (_6992 * _6990)) + (_6998 * _6996)) + (_7004 * _7002)) + (_7039 * _7037)) + (_7045 * _7043)) + (_7051 * _7049)) + (_7057 * _7055)) + (_7092 * _7090)) + (_7098 * _7096)) + (_7104 * _7102)) + (_7110 * _7108))))));
                              _7144 = frac((_6884 * _6785) + 0.5f);
                              _7145 = frac((_6886 * _6785) + 0.5f);
                              _7146 = _6884 + _6786;
                              _7147 = _6886 + _6786;
                              _7149 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7146, _7147), _6887);
                              _7157 = _6786 * 2.0f;
                              _7158 = _7146 - _7157;
                              _7159 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7158, _7147), _6887);
                              _7164 = 1.0f - _7144;
                              _7169 = _7147 - _7157;
                              _7170 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7158, _7169), _6887);
                              _7175 = 1.0f - _7145;
                              _7180 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7146, _7169), _6887);
                              _7189 = (((mad(mad(_7159.x, _7164, _7159.y), _7145, mad(_7159.w, _7164, _7159.z)) + mad(mad(_7149.y, _7144, _7149.x), _7145, mad(_7149.z, _7144, _7149.w))) + mad(mad(_7170.w, _7164, _7170.z), _7175, mad(_7170.x, _7164, _7170.y))) + mad(mad(_7180.z, _7144, _7180.w), _7175, mad(_7180.y, _7144, _7180.x))) * 0.1111111119389534f;
                              [branch]
                              if (_6788 < 1.0f) {
                                _7192 = _7139;
                                _7193 = _7189;
                                _7194 = _6788;
                                _7195 = _6887;
                                __branch_chain_6871 = true;
                              } else {
                                _7663 = _7189;
                                _7664 = _6788;
                                _7665 = _7139;
                                __branch_chain_6871 = false;
                              }
                            }
                            if (__branch_chain_6871) {
                              _7198 = (_6878 * _6730) + _6732;
                              _7199 = (_6879 * _6731) + _6733;
                              if (!((_1620 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _7208 = saturate(_7195);
                                _7212 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _7221 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_7212 * 32.665000915527344f) + _127), ((_7212 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7222 = sin(_7221);
                                _7223 = cos(_7221);
                                _7228 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_7198, _7199), 0.0f))).x) > _7208), 1.0f, 0.0f);
                                _7229 = cbSharedPerViewData.nFrameCounter & 3;
                                _7234 = sqrt((float((int)(_7229)) * 0.25f) + 0.125f) * _6783;
                                _7243 = (_global_7[min((uint)(((int)(0u + (_7229 * 2)))), 127u)]) * _7234;
                                _7244 = (_global_7[min((uint)(((int)(1u + (_7229 * 2)))), 127u)]) * _7234;
                                _7246 = -0.0f - _7222;
                                _7248 = dot(float2(_7243, _7244), float2(_7223, _7222)) + _7198;
                                _7249 = dot(float2(_7243, _7244), float2(_7246, _7223)) + _7199;
                                _7251 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7248, _7249));
                                _7255 = _7248 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7256 = _7249 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7259 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6732);
                                _7260 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6733);
                                _7265 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6730 + _6732)) + 0.5f);
                                _7266 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6731 + _6733)) + 0.5f);
                                _7269 = floor(_7255 + -0.5f);
                                _7270 = floor(_7256 + 0.5f);
                                _7272 = floor(_7255 + 0.5f);
                                _7274 = floor(_7256 + -0.5f);
                                _7275 = (_7269 < _7259);
                                _7276 = (_7270 < _7260);
                                if ((_7275 || _7276) | ((_7269 >= _7265) || (_7270 >= _7266))) {
                                  _7285 = _7228;
                                } else {
                                  _7285 = _7251.x;
                                }
                                _7286 = (_7272 < _7259);
                                if ((_7286 || _7276) | ((_7272 >= _7265) || (_7270 >= _7266))) {
                                  _7294 = _7228;
                                } else {
                                  _7294 = _7251.y;
                                }
                                _7295 = (_7274 < _7260);
                                if ((_7286 || _7295) | ((_7272 >= _7265) || (_7274 >= _7266))) {
                                  _7303 = _7228;
                                } else {
                                  _7303 = _7251.z;
                                }
                                if ((_7275 || _7295) | ((_7269 >= _7265) || (_7274 >= _7266))) {
                                  _7311 = _7228;
                                } else {
                                  _7311 = _7251.w;
                                }
                                _7312 = _7285 - _7208;
                                _7314 = select((_7312 < 0.0f), 0.0f, 1.0f);
                                _7316 = _7294 - _7208;
                                _7318 = select((_7316 < 0.0f), 0.0f, 1.0f);
                                _7322 = _7303 - _7208;
                                _7324 = select((_7322 < 0.0f), 0.0f, 1.0f);
                                _7328 = _7311 - _7208;
                                _7330 = select((_7328 < 0.0f), 0.0f, 1.0f);
                                _7337 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _7342 = sqrt((float((int)(_7337)) * 0.25f) + 0.125f) * _6783;
                                _7351 = (_global_7[min((uint)(((int)(0u + (_7337 * 2)))), 127u)]) * _7342;
                                _7352 = (_global_7[min((uint)(((int)(1u + (_7337 * 2)))), 127u)]) * _7342;
                                _7355 = dot(float2(_7351, _7352), float2(_7223, _7222)) + _7198;
                                _7356 = dot(float2(_7351, _7352), float2(_7246, _7223)) + _7199;
                                _7358 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7355, _7356));
                                _7362 = _7355 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7363 = _7356 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7366 = floor(_7362 + -0.5f);
                                _7367 = floor(_7363 + 0.5f);
                                _7369 = floor(_7362 + 0.5f);
                                _7371 = floor(_7363 + -0.5f);
                                _7372 = (_7366 < _7259);
                                _7373 = (_7367 < _7260);
                                if ((_7372 || _7373) | ((_7366 >= _7265) || (_7367 >= _7266))) {
                                  _7382 = _7228;
                                } else {
                                  _7382 = _7358.x;
                                }
                                _7383 = (_7369 < _7259);
                                if ((_7383 || _7373) | ((_7369 >= _7265) || (_7367 >= _7266))) {
                                  _7391 = _7228;
                                } else {
                                  _7391 = _7358.y;
                                }
                                _7392 = (_7371 < _7260);
                                if ((_7383 || _7392) | ((_7369 >= _7265) || (_7371 >= _7266))) {
                                  _7400 = _7228;
                                } else {
                                  _7400 = _7358.z;
                                }
                                if ((_7372 || _7392) | ((_7366 >= _7265) || (_7371 >= _7266))) {
                                  _7408 = _7228;
                                } else {
                                  _7408 = _7358.w;
                                }
                                _7409 = _7382 - _7208;
                                _7411 = select((_7409 < 0.0f), 0.0f, 1.0f);
                                _7415 = _7391 - _7208;
                                _7417 = select((_7415 < 0.0f), 0.0f, 1.0f);
                                _7421 = _7400 - _7208;
                                _7423 = select((_7421 < 0.0f), 0.0f, 1.0f);
                                _7427 = _7408 - _7208;
                                _7429 = select((_7427 < 0.0f), 0.0f, 1.0f);
                                _7436 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _7441 = sqrt((float((int)(_7436)) * 0.25f) + 0.125f) * _6783;
                                _7450 = (_global_7[min((uint)(((int)(0u + (_7436 * 2)))), 127u)]) * _7441;
                                _7451 = (_global_7[min((uint)(((int)(1u + (_7436 * 2)))), 127u)]) * _7441;
                                _7454 = dot(float2(_7450, _7451), float2(_7223, _7222)) + _7198;
                                _7455 = dot(float2(_7450, _7451), float2(_7246, _7223)) + _7199;
                                _7457 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7454, _7455));
                                _7461 = _7454 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7462 = _7455 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7465 = floor(_7461 + -0.5f);
                                _7466 = floor(_7462 + 0.5f);
                                _7468 = floor(_7461 + 0.5f);
                                _7470 = floor(_7462 + -0.5f);
                                _7471 = (_7465 < _7259);
                                _7472 = (_7466 < _7260);
                                if ((_7471 || _7472) | ((_7465 >= _7265) || (_7466 >= _7266))) {
                                  _7481 = _7228;
                                } else {
                                  _7481 = _7457.x;
                                }
                                _7482 = (_7468 < _7259);
                                if ((_7482 || _7472) | ((_7468 >= _7265) || (_7466 >= _7266))) {
                                  _7490 = _7228;
                                } else {
                                  _7490 = _7457.y;
                                }
                                _7491 = (_7470 < _7260);
                                if ((_7482 || _7491) | ((_7468 >= _7265) || (_7470 >= _7266))) {
                                  _7499 = _7228;
                                } else {
                                  _7499 = _7457.z;
                                }
                                if ((_7471 || _7491) | ((_7465 >= _7265) || (_7470 >= _7266))) {
                                  _7507 = _7228;
                                } else {
                                  _7507 = _7457.w;
                                }
                                _7508 = _7481 - _7208;
                                _7510 = select((_7508 < 0.0f), 0.0f, 1.0f);
                                _7514 = _7490 - _7208;
                                _7516 = select((_7514 < 0.0f), 0.0f, 1.0f);
                                _7520 = _7499 - _7208;
                                _7522 = select((_7520 < 0.0f), 0.0f, 1.0f);
                                _7526 = _7507 - _7208;
                                _7528 = select((_7526 < 0.0f), 0.0f, 1.0f);
                                _7535 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _7540 = sqrt((float((int)(_7535)) * 0.25f) + 0.125f) * _6783;
                                _7549 = (_global_7[min((uint)(((int)(0u + (_7535 * 2)))), 127u)]) * _7540;
                                _7550 = (_global_7[min((uint)(((int)(1u + (_7535 * 2)))), 127u)]) * _7540;
                                _7553 = dot(float2(_7549, _7550), float2(_7223, _7222)) + _7198;
                                _7554 = dot(float2(_7549, _7550), float2(_7246, _7223)) + _7199;
                                _7556 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7553, _7554));
                                _7560 = _7553 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7561 = _7554 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7564 = floor(_7560 + -0.5f);
                                _7565 = floor(_7561 + 0.5f);
                                _7567 = floor(_7560 + 0.5f);
                                _7569 = floor(_7561 + -0.5f);
                                _7570 = (_7564 < _7259);
                                _7571 = (_7565 < _7260);
                                if ((_7570 || _7571) | ((_7564 >= _7265) || (_7565 >= _7266))) {
                                  _7580 = _7228;
                                } else {
                                  _7580 = _7556.x;
                                }
                                _7581 = (_7567 < _7259);
                                if ((_7581 || _7571) | ((_7567 >= _7265) || (_7565 >= _7266))) {
                                  _7589 = _7228;
                                } else {
                                  _7589 = _7556.y;
                                }
                                _7590 = (_7569 < _7260);
                                if ((_7581 || _7590) | ((_7567 >= _7265) || (_7569 >= _7266))) {
                                  _7598 = _7228;
                                } else {
                                  _7598 = _7556.z;
                                }
                                if ((_7570 || _7590) | ((_7564 >= _7265) || (_7569 >= _7266))) {
                                  _7606 = _7228;
                                } else {
                                  _7606 = _7556.w;
                                }
                                _7607 = _7580 - _7208;
                                _7609 = select((_7607 < 0.0f), 0.0f, 1.0f);
                                _7613 = _7589 - _7208;
                                _7615 = select((_7613 < 0.0f), 0.0f, 1.0f);
                                _7619 = _7598 - _7208;
                                _7621 = select((_7619 < 0.0f), 0.0f, 1.0f);
                                _7625 = _7606 - _7208;
                                _7627 = select((_7625 < 0.0f), 0.0f, 1.0f);
                                _7628 = ((((((((((((((_7318 + _7314) + _7324) + _7330) + _7411) + _7417) + _7423) + _7429) + _7510) + _7516) + _7522) + _7528) + _7609) + _7615) + _7621) + _7627;
                                _7639 = (saturate(_7628 * 0.0625f) * 2.0f) + -1.0f;
                                _7645 = float((int)(((int)(uint)((int)(_7639 > 0.0f))) - ((int)(uint)((int)(_7639 < 0.0f)))));
                                _7647 = 1.0f - (_7645 * _7639);
                                _7649 = (_7647 * _7647) * _7647;
                                _7658 = (0.5f - ((_7645 * 0.5f) * ((1.0f - _7649) - ((_7647 - _7649) * saturate(((1.0f / _7208) * (1.0f / _7628)) * ((((((((((((((((_7318 * _7316) + (_7314 * _7312)) + (_7324 * _7322)) + (_7330 * _7328)) + (_7411 * _7409)) + (_7417 * _7415)) + (_7423 * _7421)) + (_7429 * _7427)) + (_7510 * _7508)) + (_7516 * _7514)) + (_7522 * _7520)) + (_7528 * _7526)) + (_7609 * _7607)) + (_7615 * _7613)) + (_7621 * _7619)) + (_7627 * _7625)))))));
                              } else {
                                _7658 = 1.0f;
                              }
                              _7663 = _7193;
                              _7664 = _7194;
                              _7665 = (lerp(_7658, _7192, _7194));
                            }
                            [branch]
                            if (!((_1620 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6718) >> 16))];
                              _7671 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6843, _6844), 0.0f);
                              if (_7671.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6718 & 65535))];
                                _7678 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6843, _6844), 0.0f);
                                _7692 = mad(saturate(((log2(_6794) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _7693 = max(9.999999747378752e-06f, _7671.x);
                                _7694 = _7678.x / _7693;
                                _7695 = _7678.y / _7693;
                                _7697 = _7678.w / _7693;
                                _7702 = ((0.375f - _7695) * 4.999999873689376e-06f) + _7695;
                                _7705 = -0.0f - _7694;
                                _7706 = mad(_7705, _7702, (_7678.z / _7693));
                                _7708 = 1.0f / mad(_7705, _7694, _7702);
                                _7709 = _7708 * _7706;
                                _7714 = _7692 - _7694;
                                _7719 = (((_7692 * _7692) - _7702) - (_7709 * _7714)) / mad((-0.0f - _7706), _7709, mad((-0.0f - _7702), _7702, (((0.375f - _7697) * 4.999999873689376e-06f) + _7697)));
                                _7721 = (_7708 * _7714) - (_7719 * _7709);
                                _7724 = 1.0f / _7719;
                                _7725 = _7721 * _7724;
                                _7730 = sqrt(((_7725 * _7725) * 0.25f) - ((1.0f - dot(float2(_7721, _7719), float2(_7694, _7702))) * _7724));
                                _7732 = (_7725 * -0.5f) - _7730;
                                _7734 = _7730 - (_7725 * 0.5f);
                                _7736 = select((_7732 < _7692), 1.0f, 0.0f);
                                _7741 = (_7736 + -0.05000000074505806f) / (_7732 - _7692);
                                _7747 = (((select((_7734 < _7692), 1.0f, 0.0f) - _7736) / (_7734 - _7732)) - _7741) / (_7734 - _7692);
                                _7749 = _7741 - (_7747 * _7732);
                                _7762 = _7664;
                                _7763 = (exp2((_7671.x * -1.4426950216293335f) * saturate((dot(float2(_7694, _7702), float2((_7749 - (_7747 * _7692)), _7747)) + 0.05000000074505806f) - (_7749 * _7692))) * _7665);
                                _7764 = _7663;
                              } else {
                                _7762 = _7664;
                                _7763 = _7665;
                                _7764 = _7663;
                              }
                            } else {
                              _7762 = _7664;
                              _7763 = _7665;
                              _7764 = _7663;
                            }
                          } else {
                            _7762 = 0.0f;
                            _7763 = 1.0f;
                            _7764 = 0.0f;
                          }
                          [branch]
                          if (!(_6765 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6765)))];
                            _7777 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6843 * f16tof32(((uint)((uint)(_6724) >> 16)))) + f16tof32(((uint)((uint)(_6727) >> 16)))), ((_6844 * f16tof32(_6724)) + f16tof32(_6727))), 0.0f);
                            _7785 = (_7777.x * _6744);
                            _7786 = (_7777.y * _6745);
                            _7787 = (_7777.z * _6747);
                          } else {
                            _7785 = _6744;
                            _7786 = _6745;
                            _7787 = _6747;
                          }
                          _7788 = _7763 * _6867;
                          [branch]
                          if (!(_7788 == 0.0f)) {
                            bool __branch_chain_7790;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _7806 = 0;
                              __branch_chain_7790 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _7806 = 1;
                                __branch_chain_7790 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _7806 = 2;
                                  __branch_chain_7790 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1623) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _7806 = 3;
                                    __branch_chain_7790 = true;
                                  } else {
                                    _7831 = _7788;
                                    __branch_chain_7790 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_7790) {
                              while(true) {
                                _7809 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                                if (_7806 == 0) {
                                  _7823 = _7809.x;
                                } else {
                                  if (_7806 == 1) {
                                    _7823 = _7809.y;
                                  } else {
                                    if (_7806 == 2) {
                                      _7823 = _7809.z;
                                    } else {
                                      _7823 = _7809.w;
                                    }
                                  }
                                }
                                _7831 = ((((_7762 * _7762) * ((_7823 * _7823) + -1.0f)) + 1.0f) * _6867);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_7831 > 0.0f) {
                                if (_6771) {
                                  if (!_233) {
                                    _7841 = ((_7762 * _6867) * _7764) * saturate(0.30000001192092896f - dot(float3(_6795, _6796, _6797), float3(_190, _191, _192)));
                                    _7846 = (_7841 * _1292);
                                    _7847 = (_7841 * _1293);
                                    _7848 = (_7841 * _1294);
                                  } else {
                                    _7846 = 0.0f;
                                    _7847 = 0.0f;
                                    _7848 = 0.0f;
                                  }
                                  [branch]
                                  if (!((_6721 & 1) == 0)) {
                                    _7861 = max(max(_7785, _7786), _7787);
                                    if (_7861 > 0.0f) {
                                      _7871 = saturate(_7785 / _7861);
                                      _7872 = saturate(_7786 / _7861);
                                      _7873 = saturate(_7787 / _7861);
                                    } else {
                                      _7871 = _7785;
                                      _7872 = _7786;
                                      _7873 = _7787;
                                    }
                                    _7874 = (_7872 < _7873);
                                    _7875 = select(_7874, _7873, _7872);
                                    _7876 = select(_7874, _7872, _7873);
                                    _7877 = select(_7874, -1.0f, 0.0f);
                                    _7878 = (_7871 < _7875);
                                    _7880 = select(_7878, _7875, _7871);
                                    _7881 = select(_7878, _7871, _7875);
                                    _7885 = _7880 - select((_7881 < _7876), _7881, _7876);
                                    _7891 = abs(select(_7878, (-0.3333333432674408f - _7877), _7877) + ((_7881 - _7876) / ((_7885 * 6.0f) + 9.999999682655225e-21f)));
                                    if (_7891 < 0.6666666865348816f) {
                                      _7904 = ((saturate(((float)((uint)((uint)(((uint)(_6721) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7891 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7891)) + _7891);
                                    } else {
                                      _7904 = _7891;
                                    }
                                    _7905 = saturate((_7885 / (_7880 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6721) >> 1) & 255)))) * 0.003921499941498041f));
                                    _7906 = saturate(_7880);
                                    if (!(_7905 <= 0.0f)) {
                                      _7909 = saturate(_7904);
                                      _7913 = select(((_7909 * 360.0f) >= 360.0f), 0.0f, (_7909 * 6.0f));
                                      _7914 = int(_7913);
                                      _7916 = _7913 - float((int)(_7914));
                                      _7918 = _7906 * (1.0f - _7905);
                                      _7921 = (1.0f - (_7916 * _7905)) * _7906;
                                      _7925 = (1.0f - ((1.0f - _7916) * _7905)) * _7906;
                                      switch (_7914) {
                                        case 0: {
                                          _7933 = _7906;
                                          _7934 = _7925;
                                          _7935 = _7918;
                                          break;
                                        }
                                        case 1: {
                                          _7933 = _7921;
                                          _7934 = _7906;
                                          _7935 = _7918;
                                          break;
                                        }
                                        case 2: {
                                          _7933 = _7918;
                                          _7934 = _7906;
                                          _7935 = _7925;
                                          break;
                                        }
                                        case 3: {
                                          _7933 = _7918;
                                          _7934 = _7921;
                                          _7935 = _7906;
                                          break;
                                        }
                                        case 4: {
                                          _7933 = _7925;
                                          _7934 = _7918;
                                          _7935 = _7906;
                                          break;
                                        }
                                        case 5: {
                                          _7933 = _7906;
                                          _7934 = _7918;
                                          _7935 = _7921;
                                          break;
                                        }
                                        default: {
                                          _7933 = 0.0f;
                                          _7934 = 0.0f;
                                          _7935 = 0.0f;
                                          break;
                                        }
                                      }
                                    } else {
                                      _7933 = _7906;
                                      _7934 = _7906;
                                      _7935 = _7906;
                                    }
                                    _7936 = _7933 * _7861;
                                    _7937 = _7934 * _7861;
                                    _7938 = _7935 * _7861;
                                    _7940 = saturate(_7763 * 1.0101009607315063f);
                                    _7951 = ((_7940 * (_7785 - _7936)) + _7936);
                                    _7952 = ((_7940 * (_7786 - _7937)) + _7937);
                                    _7953 = (lerp(_7938, _7787, _7940));
                                    _7954 = _7846;
                                    _7955 = _7847;
                                    _7956 = _7848;
                                  } else {
                                    _7951 = _7785;
                                    _7952 = _7786;
                                    _7953 = _7787;
                                    _7954 = _7846;
                                    _7955 = _7847;
                                    _7956 = _7848;
                                  }
                                } else {
                                  _7951 = _7785;
                                  _7952 = _7786;
                                  _7953 = _7787;
                                  _7954 = 0.0f;
                                  _7955 = 0.0f;
                                  _7956 = 0.0f;
                                }
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _7963 = srvLightMappingData[_1623];
                                  if (!(_7963 == -1)) {
                                    _7968 = srvLightIndexData[_7963].nLayerIndex;
                                    _7970 = srvLightIndexData[_7963].vAtlasOrigin.x;
                                    _7971 = srvLightIndexData[_7963].vAtlasOrigin.y;
                                    _7973 = srvLightIndexData[_7963].vScreenOrigin.x;
                                    _7974 = srvLightIndexData[_7963].vScreenOrigin.y;
                                    _7983 = ((int)(_7968 * 5)) & 31;
                                    _7992 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7970 + _65) - _7973)), ((int)((_7971 + _66) - _7974)), 0)))).x) & ((int)(31 << _7983)))) >> _7983)) >> 1)))) * 0.06666667014360428f) * _7831);
                                  } else {
                                    _7992 = _7831;
                                  }
                                } else {
                                  _7992 = _7831;
                                }
                                _7996 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _7999 = select(_7996, (_7992 * _1280), _7992);
                                _8001 = _6795 * _6794;
                                _8002 = _6796 * _6794;
                                _8003 = _6797 * _6794;
                                _8004 = _6755 * _6686;
                                _8005 = _6755 * _6687;
                                _8006 = _6755 * _6688;
                                _8007 = _8001 + _8004;
                                _8008 = _8002 + _8005;
                                _8009 = _8003 + _8006;
                                _8010 = _8001 - _8004;
                                _8011 = _8002 - _8005;
                                _8012 = _8003 - _8006;
                                _8013 = (_6755 > 0.0f);
                                _8014 = dot(float3(_8007, _8008, _8009), float3(_8007, _8008, _8009));
                                _8015 = rsqrt(_8014);
                                [branch]
                                if (_8013) {
                                  _8018 = rsqrt(dot(float3(_8010, _8011, _8012), float3(_8010, _8011, _8012)));
                                  _8019 = _8018 * _8015;
                                  _8021 = dot(float3(_8007, _8008, _8009), float3(_8010, _8011, _8012)) * _8019;
                                  _8040 = (_8019 / ((_8019 + 0.5f) + (_8021 * 0.5f)));
                                  _8041 = (((dot(float3(_190, _191, _192), float3(_8010, _8011, _8012)) * _8018) + (dot(float3(_190, _191, _192), float3(_8007, _8008, _8009)) * _8015)) * 0.5f);
                                  _8042 = _8021;
                                } else {
                                  _8040 = (1.0f / (_8014 + 1.0f));
                                  _8041 = dot(float3(_190, _191, _192), float3((_8015 * _8007), (_8015 * _8008), (_8015 * _8009)));
                                  _8042 = 1.0f;
                                }
                                if (_6757 > 0.0f) {
                                  _8048 = sqrt(saturate((_6757 * _6757) * _8040));
                                  if (_8041 < _8048) {
                                    _8053 = max(_8041, (-0.0f - _8048)) + _8048;
                                    _8058 = ((_8053 * _8053) / (_8048 * 4.0f));
                                  } else {
                                    _8058 = _8041;
                                  }
                                } else {
                                  _8058 = _8041;
                                }
                                if (_8013) {
                                  _8060 = -0.0f - _451;
                                  _8061 = -0.0f - _452;
                                  _8062 = -0.0f - _450;
                                  _8064 = dot(float3(_8060, _8061, _8062), float3(_190, _191, _192)) * 2.0f;
                                  _8068 = _8060 - (_8064 * _190);
                                  _8069 = _8061 - (_8064 * _191);
                                  _8070 = _8062 - (_8064 * _192);
                                  _8071 = _8010 - _8007;
                                  _8072 = _8011 - _8008;
                                  _8073 = _8012 - _8009;
                                  _8074 = dot(float3(_8068, _8069, _8070), float3(_8071, _8072, _8073));
                                  _8080 = sqrt(((_8071 * _8071) + (_8072 * _8072)) + (_8073 * _8073));
                                  _8089 = saturate(((dot(float3(_8068, _8069, _8070), float3(_8007, _8008, _8009)) * _8074) - dot(float3(_8007, _8008, _8009), float3(_8071, _8072, _8073))) / ((_8080 * _8080) - (_8074 * _8074)));
                                  _8093 = (_8089 * _8071) + _8007;
                                  _8094 = (_8089 * _8072) + _8008;
                                  _8095 = (_8089 * _8073) + _8009;
                                  _8096 = dot(float3(_8093, _8094, _8095), float3(_8068, _8069, _8070));
                                  _8100 = (_8096 * _8068) - _8093;
                                  _8101 = (_8096 * _8069) - _8094;
                                  _8102 = (_8096 * _8070) - _8095;
                                  _8110 = saturate(0.009999999776482582f / sqrt(((_8100 * _8100) + (_8101 * _8101)) + (_8102 * _8102)));
                                  _8118 = ((_8110 * _8100) + _8093);
                                  _8119 = ((_8110 * _8101) + _8094);
                                  _8120 = ((_8110 * _8102) + _8095);
                                } else {
                                  _8118 = _8007;
                                  _8119 = _8008;
                                  _8120 = _8009;
                                }
                                _8122 = rsqrt(dot(float3(_8118, _8119, _8120), float3(_8118, _8119, _8120)));
                                _8123 = _8122 * _8118;
                                _8124 = _8122 * _8119;
                                _8125 = _8122 * _8120;
                                _8126 = _218 * _218;
                                _8130 = saturate((_6757 * (1.0f - _8126)) * _8122);
                                _8132 = saturate(_8122 * f16tof32(_6700));
                                _8134 = rsqrt(dot(float3(_8001, _8002, _8003), float3(_8001, _8002, _8003)));
                                _8138 = dot(float3(_190, _191, _192), float3(_8123, _8124, _8125));
                                _8139 = dot(float3(_190, _191, _192), float3(_451, _452, _450));
                                _8140 = dot(float3(_451, _452, _450), float3(_8123, _8124, _8125));
                                _8143 = rsqrt((_8140 * 2.0f) + 2.0f);
                                _8150 = (_8130 > 0.0f);
                                if (_8150) {
                                  _8154 = sqrt(1.0f - (_8130 * _8130));
                                  _8156 = (_8138 * 2.0f) * _8139;
                                  _8157 = _8156 - _8140;
                                  if (!(_8157 >= _8154)) {
                                    _8165 = rsqrt(1.0f - (_8157 * _8157)) * _8130;
                                    _8168 = _8165 * (_8139 - (_8157 * _8138));
                                    _8169 = _8139 * _8139;
                                    _8174 = _8165 * (((_8169 * 2.0f) + -1.0f) - (_8157 * _8140));
                                    _8183 = sqrt(saturate((((1.0f - (_8138 * _8138)) - _8169) - (_8140 * _8140)) + (_8156 * _8140)));
                                    _8184 = _8183 * _8165;
                                    _8187 = ((_8139 * 2.0f) * _8165) * _8183;
                                    _8189 = (_8154 * _8138) + _8139;
                                    _8190 = _8189 + _8168;
                                    _8191 = _8154 * _8140;
                                    _8193 = (_8191 + 1.0f) + _8174;
                                    _8194 = _8184 * _8193;
                                    _8195 = _8190 * _8193;
                                    _8196 = _8187 * _8190;
                                    _8201 = (((_8190 * 0.25f) * _8187) - (_8194 * 0.5f)) * _8195;
                                    _8215 = (((_8196 - (_8194 * 2.0f)) * _8196) + (_8194 * _8194)) + ((((-0.5f - ((_8193 + _8191) * 0.5f)) * _8195) + ((_8193 * _8193) * _8189)) * _8190);
                                    _8220 = (_8201 * 2.0f) / ((_8215 * _8215) + (_8201 * _8201));
                                    _8221 = _8215 * _8220;
                                    _8223 = 1.0f - (_8201 * _8220);
                                    _8229 = ((_8221 * _8187) + _8191) + (_8223 * _8174);
                                    _8232 = rsqrt((_8229 * 2.0f) + 2.0f);
                                    _8241 = saturate((_8229 * _8232) + _8232);
                                    _8242 = saturate(((_8189 + (_8221 * _8184)) + (_8223 * _8168)) * _8232);
                                  } else {
                                    _8241 = abs(_8139);
                                    _8242 = 1.0f;
                                  }
                                } else {
                                  _8241 = saturate((_8143 * _8140) + _8143);
                                  _8242 = saturate(_8143 * (_8139 + _8138));
                                }
                                _8243 = saturate(_8058);
                                _8245 = _8126 * _8126;
                                if (_8132 > 0.0f) {
                                  _8255 = saturate(((_8132 * _8132) / ((_8241 * 3.5999999046325684f) + 0.4000000059604645f)) + _8245);
                                } else {
                                  _8255 = _8245;
                                }
                                if (_8150) {
                                  _8264 = (((_8130 * 0.25f) * ((sqrt(_8255) * 3.0f) + _8130)) / (_8241 + 0.0010000000474974513f)) + _8255;
                                  _8267 = _8264;
                                  _8268 = (_8255 / _8264);
                                } else {
                                  _8267 = _8255;
                                  _8268 = 1.0f;
                                }
                                if (_8042 < 1.0f) {
                                  _8275 = sqrt((1.000100016593933f - _8042) / max(9.999999974752427e-07f, (_8042 + 1.0f)));
                                  _8288 = (sqrt(_8267 / ((((_8275 * 0.25f) * ((sqrt(_8267) * 3.0f) + _8275)) / (_8241 + 0.0010000000474974513f)) + _8267)) * _8268);
                                } else {
                                  _8288 = _8268;
                                }
                                _8292 = (((_8255 * _8242) - _8242) * _8242) + 1.0f;
                                _8299 = exp2(log2(1.0f - saturate(_8241)) * 5.0f);
                                _8302 = saturate(abs(_8139) + 9.999999747378752e-06f);
                                _8303 = sqrt(_8255);
                                _8304 = 1.0f - _8303;
                                _8316 = saturate((dot(float3(_190, _191, _192), float3((_8134 * _8001), (_8134 * _8002), (_8134 * _8003))) + _6754) / (_6754 + 1.0f));
                                _8319 = ((_8288 * _8243) * (_8255 / (_8292 * _8292))) * (0.5f / ((((_8304 * _8302) + _8303) * _8243) + (((_8304 * _8243) + _8303) * _8302)));
                                _8320 = _7951 * _1671;
                                _8321 = _7952 * _1671;
                                _8322 = _7953 * _1671;
                                if (_6751 > 0.0f) {
                                  _8344 = (_6751 * _1367) * select(_7996, (_7992 * _1280), _7992);
                                  _8361 = (((((_8320 * _1143) * _8344) * ((_8299 * (1.0f - _210)) + _210)) * _8319) + _1611);
                                  _8362 = (((((_8321 * _1144) * _8344) * ((_8299 * (1.0f - _211)) + _211)) * _8319) + _1612);
                                  _8363 = (((((_8322 * _1145) * _8344) * ((_8299 * (1.0f - _212)) + _212)) * _8319) + _1613);
                                } else {
                                  _8361 = _1611;
                                  _8362 = _1612;
                                  _8363 = _1613;
                                }
                                _8848 = (((_7999 * _8320) * _8316) + _1608);
                                _8849 = (((_7999 * _8321) * _8316) + _1609);
                                _8850 = (((_7999 * _8322) * _8316) + _1610);
                                _8851 = (_8361 + (_7954 * _8320));
                                _8852 = (_8362 + (_7955 * _8321));
                                _8853 = (_8363 + (_7956 * _8322));
                              } else {
                                _8848 = _1608;
                                _8849 = _1609;
                                _8850 = _1610;
                                _8851 = _1611;
                                _8852 = _1612;
                                _8853 = _1613;
                              }
                              break;
                            }
                          } else {
                            _8848 = _1608;
                            _8849 = _1609;
                            _8850 = _1610;
                            _8851 = _1611;
                            _8852 = _1612;
                            _8853 = _1613;
                          }
                        } else {
                          if (_1654 == 10) {
                            _8375 = asfloat(srvLightInfoProperties.Load4(_1622)).x;
                            _8376 = asfloat(srvLightInfoProperties.Load4(_1622)).y;
                            _8377 = asfloat(srvLightInfoProperties.Load4(_1622)).z;
                            _8378 = asfloat(srvLightInfoProperties.Load4(_1622)).w;
                            _8381 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).x;
                            _8382 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).y;
                            _8383 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).z;
                            _8384 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 16u)))).w;
                            _8387 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).x;
                            _8388 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).y;
                            _8389 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).z;
                            _8390 = asfloat(srvLightInfoProperties.Load4(((int)(_1622 + 32u)))).w;
                            _8393 = asfloat(srvLightInfoProperties.Load2(((int)(_1622 + 72u)))).x;
                            _8394 = asfloat(srvLightInfoProperties.Load2(((int)(_1622 + 72u)))).y;
                            _8397 = asint(srvLightInfoProperties.Load(((int)(_1622 + 80u))));
                            _8400 = asint(srvLightInfoProperties.Load(((int)(_1622 + 84u))));
                            _8403 = asint(srvLightInfoProperties.Load(((int)(_1622 + 88u))));
                            _8406 = asint(srvLightInfoProperties.Load(((int)(_1622 + 96u))));
                            _8409 = f16tof32(_8397);
                            _8411 = f16tof32(((uint)((uint)(_8400) >> 16)));
                            _8412 = f16tof32(_8400);
                            _8414 = f16tof32(((uint)((uint)(_8403) >> 16)));
                            _8418 = ((float)((uint)((uint)(((uint)(_8403) >> 8) & 255)))) * 0.003921499941498041f;
                            _8420 = (float)((uint)((uint)(_8406 & 65535)));
                            _8424 = mad(_8377, _231, mad(_8376, _230, (_8375 * _229))) + _8378;
                            _8428 = mad(_8383, _231, mad(_8382, _230, (_8381 * _229))) + _8384;
                            _8432 = mad(_8389, _231, mad(_8388, _230, (_8387 * _229))) + _8390;
                            _8435 = mad(_8377, _192, mad(_8376, _191, (_8375 * _190)));
                            _8438 = mad(_8383, _192, mad(_8382, _191, (_8381 * _190)));
                            _8441 = mad(_8389, _192, mad(_8388, _191, (_8387 * _190)));
                            _8453 = -0.0f - mad(_8389, _450, mad(_8388, _452, (_8387 * _451)));
                            _8454 = _8393 * 0.5f;
                            _8455 = _8394 * 0.5f;
                            _8456 = -0.0f - _8454;
                            _8457 = -0.0f - _8455;
                            _8458 = _8456 - _8424;
                            _8459 = _8457 - _8428;
                            _8460 = -0.0f - _8432;
                            _8461 = _8454 - _8424;
                            _8462 = _8455 - _8428;
                            _8463 = dot(float3(_8424, _8428, _8432), float3(_8435, _8438, _8441));
                            _8465 = dot(float3(_8456, _8457, 0.0f), float3(_8435, _8438, _8441)) - _8463;
                            _8467 = dot(float3(_8454, _8457, 0.0f), float3(_8435, _8438, _8441)) - _8463;
                            _8469 = dot(float3(_8454, _8455, 0.0f), float3(_8435, _8438, _8441)) - _8463;
                            _8471 = dot(float3(_8456, _8455, 0.0f), float3(_8435, _8438, _8441)) - _8463;
                            _8472 = min(_8465, _8467);
                            [branch]
                            if (!(!(_8472 >= 0.0f))) {
                              _8478 = rsqrt(dot(float3(_8461, _8459, _8460), float3(_8461, _8459, _8460)) * dot(float3(_8458, _8459, _8460), float3(_8458, _8459, _8460)));
                              _8480 = dot(float3(_8458, _8459, _8460), float3(_8461, _8459, _8460)) * _8478;
                              _8487 = rsqrt(max(((((_8480 * 0.09300000220537186f) + 0.5f) * _8480) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8478;
                              _8494 = (_8487 * (_8393 * _8460));
                              _8495 = (_8487 * (_8459 * (_8456 - _8454)));
                            } else {
                              _8494 = 0.0f;
                              _8495 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_8467, _8469) >= 0.0f))) {
                              _8502 = rsqrt(dot(float3(_8461, _8462, _8460), float3(_8461, _8462, _8460)) * dot(float3(_8461, _8459, _8460), float3(_8461, _8459, _8460)));
                              _8504 = dot(float3(_8461, _8459, _8460), float3(_8461, _8462, _8460)) * _8502;
                              _8511 = rsqrt(max(((((_8504 * 0.09300000220537186f) + 0.5f) * _8504) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8502;
                              _8519 = (_8511 * ((_8457 - _8455) * _8460));
                              _8520 = ((_8511 * (_8394 * _8461)) + _8495);
                            } else {
                              _8519 = 0.0f;
                              _8520 = _8495;
                            }
                            _8521 = min(_8469, _8471);
                            [branch]
                            if (!(!(_8521 >= 0.0f))) {
                              _8527 = rsqrt(dot(float3(_8458, _8462, _8460), float3(_8458, _8462, _8460)) * dot(float3(_8461, _8462, _8460), float3(_8461, _8462, _8460)));
                              _8529 = dot(float3(_8461, _8462, _8460), float3(_8458, _8462, _8460)) * _8527;
                              _8536 = rsqrt(max(((((_8529 * 0.09300000220537186f) + 0.5f) * _8529) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8527;
                              _8545 = ((_8536 * ((_8456 - _8454) * _8460)) + _8494);
                              _8546 = ((_8536 * (_8393 * _8462)) + _8520);
                            } else {
                              _8545 = _8494;
                              _8546 = _8520;
                            }
                            [branch]
                            if (!(!(min(_8471, _8465) >= 0.0f))) {
                              _8553 = rsqrt(dot(float3(_8458, _8459, _8460), float3(_8458, _8459, _8460)) * dot(float3(_8458, _8462, _8460), float3(_8458, _8462, _8460)));
                              _8555 = dot(float3(_8458, _8462, _8460), float3(_8458, _8459, _8460)) * _8553;
                              _8562 = rsqrt(max(((((_8555 * 0.09300000220537186f) + 0.5f) * _8555) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8553;
                              _8571 = ((_8562 * (_8394 * _8460)) + _8519);
                              _8572 = ((_8562 * (_8458 * (_8457 - _8455))) + _8546);
                            } else {
                              _8571 = _8519;
                              _8572 = _8546;
                            }
                            if (min(_8472, _8521) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_8465, _8467), max(_8469, _8471)) >= 0.0f))) {
                                _8581 = -0.0f - _8435;
                                _8582 = _8463 / _8438;
                                _8583 = _8456 / _8438;
                                _8584 = _8454 / _8438;
                                _8586 = (_8457 - _8582) / _8581;
                                _8588 = (_8455 - _8582) / _8581;
                                _8589 = min(_8583, _8584);
                                _8590 = max(_8583, _8584);
                                _8591 = min(_8586, _8588);
                                _8592 = max(_8586, _8588);
                                _8593 = max(_8589, _8591);
                                _8594 = min(_8590, _8592);
                                _8595 = _8593 * _8438;
                                _8597 = _8594 * _8438;
                                _8599 = _8595 - _8424;
                                _8600 = _8582 - _8428;
                                _8601 = _8600 + (_8593 * _8581);
                                _8602 = _8597 - _8424;
                                _8603 = _8600 + (_8594 * _8581);
                                _8604 = dot(float3(_8599, _8601, _8460), float3(_8599, _8601, _8460));
                                _8605 = dot(float3(_8602, _8603, _8460), float3(_8602, _8603, _8460));
                                _8607 = rsqrt(_8605 * _8604);
                                _8609 = dot(float3(_8599, _8601, _8460), float3(_8602, _8603, _8460)) * _8607;
                                _8616 = rsqrt(max(((((_8609 * 0.09300000220537186f) + 0.5f) * _8609) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8607;
                                _8629 = (_8589 > _8591);
                                _8631 = select(_8629, _8438, _8435);
                                _8637 = float((int)(((int)(uint)((int)(_8631 > 0.0f))) - ((int)(uint)((int)(_8631 < 0.0f)))));
                                _8641 = ((1.0f - (((float)((bool)_8629)) * 2.0f)) * _8454) * _8637;
                                _8643 = _8641 - _8424;
                                _8644 = (_8637 * _8455) - _8428;
                                _8645 = (_8590 < _8592);
                                _8647 = select(_8645, _8438, _8435);
                                _8653 = float((int)(((int)(uint)((int)(_8647 > 0.0f))) - ((int)(uint)((int)(_8647 < 0.0f)))));
                                _8654 = _8653 * _8454;
                                _8659 = _8654 - _8424;
                                _8660 = ((((((float)((bool)_8645)) * 2.0f) + -1.0f) * _8455) * _8653) - _8428;
                                _8663 = rsqrt(_8604 * dot(float3(_8643, _8644, _8460), float3(_8643, _8644, _8460)));
                                _8665 = dot(float3(_8643, _8644, _8460), float3(_8599, _8601, _8460)) * _8663;
                                _8672 = rsqrt(max(((((_8665 * 0.09300000220537186f) + 0.5f) * _8665) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8663;
                                _8685 = rsqrt(dot(float3(_8659, _8660, _8460), float3(_8659, _8660, _8460)) * _8605);
                                _8687 = dot(float3(_8602, _8603, _8460), float3(_8659, _8660, _8460)) * _8685;
                                _8694 = rsqrt(max(((((_8687 * 0.09300000220537186f) + 0.5f) * _8687) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8685;
                                _8715 = ((((_8616 * (((_8593 - _8594) * _8581) * _8460)) + _8571) + (_8672 * ((_8644 - _8601) * _8460))) + (_8694 * ((_8603 - _8660) * _8460)));
                                _8716 = ((((_8616 * ((_8438 * (_8594 - _8593)) * _8460)) + _8545) + (_8672 * ((_8595 - _8641) * _8460))) + (_8694 * ((_8654 - _8597) * _8460)));
                                _8717 = ((((_8616 * ((_8603 * _8599) - (_8602 * _8601))) + _8572) + (_8672 * ((_8643 * _8601) - (_8644 * _8599)))) + (_8694 * ((_8660 * _8602) - (_8659 * _8603))));
                              } else {
                                _8715 = _8571;
                                _8716 = _8545;
                                _8717 = _8572;
                              }
                            } else {
                              _8715 = _8571;
                              _8716 = _8545;
                              _8717 = _8572;
                            }
                            _8723 = sqrt(((_8716 * _8716) + (_8715 * _8715)) + (_8717 * _8717));
                            _8724 = _8723 * 0.15915493667125702f;
                            [branch]
                            if (!(_8724 == 0.0f)) {
                              _8733 = saturate((_8724 - _8409) / (1.0f - _8409)) * ((float)((bool)(uint)(_8432 <= 0.0f)));
                              [branch]
                              if (!(_8733 == 0.0f)) {
                                if (_8723 > 0.0f) {
                                  _8741 = (dot(float3(_8435, _8438, _8441), float3(_8715, _8716, _8717)) / _8723);
                                } else {
                                  _8741 = 0.0f;
                                }
                                _8742 = 1.0f - _218;
                                _8743 = _8742 * _8742;
                                _8749 = exp2(log2(1.0f - saturate(dot(float3(_190, _191, _192), float3(_451, _452, _450)))) * 5.0f);
                                _8754 = min(_218, 0.800000011920929f);
                                _8763 = exp2(((((((_8754 * 3.322999954223633f) + -3.7669999599456787f) * _8754) + -0.3479999899864197f) * _8754) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _8770 = _8460 / (_8453 - ((_8441 * 2.0f) * dot(float3((-0.0f - mad(_8377, _450, mad(_8376, _452, (_8375 * _451)))), (-0.0f - mad(_8383, _450, mad(_8382, _452, (_8381 * _451)))), _8453), float3(_8435, _8438, _8441))));
                                _8773 = (_8770 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8763) * saturate((_218 + -0.5f) * 2.500000238418579f)) + _8763);
                                _8781 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8420), ((log2((_8773 * _8773) * f16tof32(((uint)((uint)(_8397) >> 16)))) * 0.5f) + 5.5f));
                                _8783 = (float)((bool)(uint)(_8770 > 0.0f));
                                _8784 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8420), 10.0f);
                                _8793 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8733 * _1280), _8733);
                                if (_8418 > 0.0f) {
                                  _8811 = _8418 * _1367;
                                  _8812 = _8793 * _1671;
                                  _8832 = ((((((_8811 * _8411) * _8783) * _8781.x) * _8812) * (((max(_8743, _210) - _210) * _8749) + _210)) + _1611);
                                  _8833 = ((((((_8811 * _8412) * _8783) * _8781.y) * _8812) * (((max(_8743, _211) - _211) * _8749) + _211)) + _1612);
                                  _8834 = ((((((_8414 * _8811) * _8783) * _8781.z) * _8812) * (((max(_8743, _212) - _212) * _8749) + _212)) + _1613);
                                } else {
                                  _8832 = _1611;
                                  _8833 = _1612;
                                  _8834 = _1613;
                                }
                                _8840 = ((_1671 * 5.4256415367126465f) * _8741) * _8793;
                                _8848 = (((_8784.x * _8411) * _8840) + _1608);
                                _8849 = (((_8784.y * _8412) * _8840) + _1609);
                                _8850 = (((_8784.z * _8414) * _8840) + _1610);
                                _8851 = _8832;
                                _8852 = _8833;
                                _8853 = _8834;
                              } else {
                                _8848 = _1608;
                                _8849 = _1609;
                                _8850 = _1610;
                                _8851 = _1611;
                                _8852 = _1612;
                                _8853 = _1613;
                              }
                            } else {
                              _8848 = _1608;
                              _8849 = _1609;
                              _8850 = _1610;
                              _8851 = _1611;
                              _8852 = _1612;
                              _8853 = _1613;
                            }
                          } else {
                            _8848 = _1608;
                            _8849 = _1609;
                            _8850 = _1610;
                            _8851 = _1611;
                            _8852 = _1612;
                            _8853 = _1613;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _8848 = _1608;
              _8849 = _1609;
              _8850 = _1610;
              _8851 = _1611;
              _8852 = _1612;
              _8853 = _1613;
            }
          } else {
            _8848 = _1608;
            _8849 = _1609;
            _8850 = _1610;
            _8851 = _1611;
            _8852 = _1612;
            _8853 = _1613;
          }
          _8854 = _1614 + 1u;
          if (!(_8854 == _global_2)) {
            _1608 = _8848;
            _1609 = _8849;
            _1610 = _8850;
            _1611 = _8851;
            _1612 = _8852;
            _1613 = _8853;
            _1614 = _8854;
            continue;
          }
          _8858 = _8848;
          _8859 = _8849;
          _8860 = _8850;
          _8861 = _8851;
          _8862 = _8852;
          _8863 = _8853;
          break;
        }
      } else {
        _8858 = _1491;
        _8859 = _1492;
        _8860 = _1493;
        _8861 = _1370;
        _8862 = _1373;
        _8863 = _1376;
      }
      _8865 = rsqrt(dot(float3(_136, _137, -1.0f), float3(_136, _137, -1.0f)));
      _8872 = 1.0f - _218;
      _8883 = (1.0f - _222) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_190, _191, _192), float3((-0.0f - (_136 * _8865)), (-0.0f - (_137 * _8865)), _8865))))) * 5.0f) * (max((_8872 * _8872), _222) - _222));
      _9023 = (_8883 * _8858);
      _9024 = (_8883 * _8859);
      _9025 = (_8883 * _8860);
      _9026 = _8861;
      _9027 = _8862;
      _9028 = _8863;
      _9029 = (_443 * _161);
      _9030 = (_443 * _162);
      _9031 = (_443 * _163);
    } else {
      _8902 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _137, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _136)));
      _8905 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _137, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _136)));
      _8908 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _137, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _136)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _9012 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _9013 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _9014 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _8929 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8902, _8905, _8908), 0.0f);
        _8933 = _8929.x * 32.0f;
        _8934 = _8929.y * 32.0f;
        _8935 = _8929.z * 32.0f;
        _8937 = rsqrt(dot(float3(_8902, _8905, _8908), float3(_8902, _8905, _8908)));
        _8938 = _8937 * _8902;
        _8939 = _8937 * _8905;
        _8940 = _8937 * _8908;
        _8941 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _8942 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _8943 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _8944 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _8945 = dot(float3(_8938, _8939, _8940), float3(_8942, _8943, _8944));
        _8950 = (_8945 * _8945) - (dot(float3(_8942, _8943, _8944), float3(_8942, _8943, _8944)) - (_8941 * _8941));
        if ((_8945 > -0.0f) && (_8950 > 0.0f)) {
          _8955 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _8968 = 74.80000305175781f / ((dot(float3(_8938, _8939, _8940), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8941) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _8976 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8938, _8940), float2(_8955, cbDeferredShading.vSunDirWS.x)) * _8968) + 0.5f), ((dot(float3(_8938, _8939, _8940), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8955)), (cbDeferredShading.vSunDirWS.y * _8955))) * _8968) + 0.5f)), 0.0f);
          _8978 = _8950 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_8978 > 0.0f) {
            _8985 = saturate(_8978 * 5.0f);
            _9012 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8976.x) * _8985) + _8933);
            _9013 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8976.y) * _8985) + _8934);
            _9014 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8976.z) * _8985) + _8935);
          } else {
            _9012 = _8933;
            _9013 = _8934;
            _9014 = _8935;
          }
        } else {
          _9012 = _8933;
          _9013 = _8934;
          _9014 = _8935;
        }
      }
      _9018 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _9023 = 0.0f;
      _9024 = 0.0f;
      _9025 = 0.0f;
      _9026 = select(_9018, 0.0f, _9012);
      _9027 = select(_9018, 0.0f, _9013);
      _9028 = select(_9018, 0.0f, _9014);
      _9029 = 0.0f;
      _9030 = 0.0f;
      _9031 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_65, _66)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_9029 * _9023) + _9026)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_9030 * _9024) + _9027)), 7936.0f), 5.960464477539063e-08f), max(min((((_9031 * _9025) + _9028) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_65, _66)] = float3(0.0f, 0.0f, 0.0f);
  }
}