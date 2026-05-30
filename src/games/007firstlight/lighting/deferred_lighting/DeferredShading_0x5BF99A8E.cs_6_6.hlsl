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

Texture2D<float4> srvGlobalGBuffer5 : register(t69);

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

Texture2D<float> srvContactShadowsCSMMask : register(t89);

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
  uint _56;
  int _62;
  uint _67;
  uint _68;
  uint _75;
  int _78;
  int _93;
  float _270;
  float _271;
  float _272;
  float _273;
  float _363;
  float _364;
  float _402;
  int _441;
  float _442;
  float _443;
  float _444;
  int _557;
  float _558;
  float _559;
  float _560;
  float _561;
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
  float _686;
  float _687;
  float _688;
  float _775;
  float _776;
  float _777;
  float _795;
  float _796;
  float _797;
  float _829;
  float _830;
  float _831;
  float _832;
  float _833;
  float _834;
  float _835;
  float _849;
  float _850;
  float _851;
  float _852;
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
  float _867;
  float _868;
  float _869;
  float _870;
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
  float _929;
  float _930;
  float _931;
  float _951;
  float _952;
  float _953;
  float _964;
  float _965;
  float _966;
  float _967;
  float _968;
  float _969;
  float _972;
  float _973;
  float _974;
  float _975;
  float _976;
  float _977;
  float _978;
  float _992;
  float _993;
  float _994;
  float _995;
  float _996;
  float _997;
  float _1026;
  float _1027;
  float _1028;
  float _1048;
  float _1049;
  float _1050;
  float _1061;
  float _1062;
  float _1063;
  float _1064;
  float _1065;
  float _1066;
  float _1085;
  float _1086;
  float _1087;
  float _1088;
  float _1089;
  float _1090;
  float _1091;
  float _1110;
  float _1111;
  float _1112;
  int _1143;
  float _1144;
  float _1262;
  float _1267;
  float _1283;
  float _1358;
  float _1377;
  float _1430;
  float _1431;
  float _1432;
  float _1485;
  float _1486;
  float _1487;
  float _1597;
  float _1602;
  float _1603;
  float _1604;
  float _1605;
  float _1606;
  float _1607;
  int _1608;
  float _2271;
  float _2272;
  float _2273;
  float _2274;
  float _2364;
  float _2373;
  float _2382;
  float _2390;
  float _2461;
  float _2470;
  float _2479;
  float _2487;
  float _2560;
  float _2569;
  float _2578;
  float _2586;
  float _2659;
  float _2668;
  float _2677;
  float _2685;
  float _2737;
  float _2742;
  float _2743;
  float _2744;
  float _2841;
  float _2846;
  float _2847;
  float _2848;
  float _2869;
  float _2870;
  float _2871;
  int _2891;
  float _2908;
  float _2912;
  float _2918;
  float _2958;
  float _2959;
  float _3196;
  float _3358;
  float _3359;
  float _3360;
  float _3386;
  float _3468;
  float _3469;
  float _3470;
  float _3858;
  float _3859;
  float _3860;
  float _3883;
  float _3884;
  float _3885;
  float _3916;
  float _3945;
  float _3946;
  float _3947;
  float _3963;
  float _3964;
  float _3965;
  float _3978;
  float _3979;
  float _3980;
  float _4145;
  float _4146;
  float _4147;
  float _4148;
  float _4149;
  float _4150;
  float _4151;
  float _4152;
  float _4244;
  float _4245;
  float _4246;
  float _4247;
  float _4248;
  float _4351;
  float _4360;
  float _4369;
  float _4377;
  float _4448;
  float _4457;
  float _4466;
  float _4474;
  float _4547;
  float _4556;
  float _4565;
  float _4573;
  float _4646;
  float _4655;
  float _4664;
  float _4672;
  float _5061;
  float _5062;
  float _5063;
  int _5064;
  float _5093;
  float _5094;
  float _5095;
  float _5096;
  float _5097;
  float _5199;
  float _5208;
  float _5217;
  float _5225;
  float _5296;
  float _5305;
  float _5314;
  float _5322;
  float _5395;
  float _5404;
  float _5413;
  float _5421;
  float _5494;
  float _5503;
  float _5512;
  float _5520;
  float _5854;
  float _5855;
  bool _5856;
  float _5874;
  float _5875;
  float _5876;
  float _5877;
  float _5935;
  float _5936;
  float _5961;
  float _5962;
  float _6057;
  float _6063;
  float _6064;
  float _6065;
  float _6066;
  float _6086;
  float _6087;
  float _6088;
  int _6107;
  float _6124;
  float _6128;
  float _6155;
  float _6156;
  float _6157;
  float _6188;
  float _6217;
  float _6218;
  float _6219;
  float _6235;
  float _6236;
  float _6237;
  float _6277;
  float _6278;
  float _6359;
  float _6360;
  float _6361;
  float _6592;
  float _6755;
  float _6756;
  float _6757;
  float _6898;
  float _6899;
  float _7280;
  float _7281;
  float _7282;
  float _7835;
  float _7836;
  float _7837;
  float _7838;
  float _7928;
  float _7937;
  float _7946;
  float _7954;
  float _8025;
  float _8034;
  float _8043;
  float _8051;
  float _8124;
  float _8133;
  float _8142;
  float _8150;
  float _8223;
  float _8232;
  float _8241;
  float _8249;
  float _8301;
  float _8306;
  float _8307;
  float _8308;
  float _8405;
  float _8410;
  float _8411;
  float _8412;
  float _8433;
  float _8434;
  float _8435;
  int _8455;
  float _8472;
  float _8480;
  float _8506;
  float _8507;
  float _8508;
  float _8539;
  float _8568;
  float _8569;
  float _8570;
  float _8586;
  float _8587;
  float _8588;
  float _8589;
  float _8629;
  float _8630;
  float _8711;
  float _8712;
  float _8713;
  float _8944;
  float _9107;
  float _9108;
  float _9109;
  float _9259;
  float _9260;
  float _9284;
  float _9285;
  float _9310;
  float _9311;
  float _9336;
  float _9337;
  float _9480;
  float _9481;
  float _9482;
  float _9506;
  float _9559;
  float _9560;
  float _9561;
  float _9575;
  float _9576;
  float _9577;
  float _9578;
  float _9579;
  float _9580;
  float _9585;
  float _9586;
  float _9587;
  float _9588;
  float _9589;
  float _9590;
  float _9739;
  float _9740;
  float _9741;
  float _9750;
  float _9751;
  float _9752;
  float _9753;
  float _9754;
  float _9755;
  float _9756;
  float _9757;
  float _9758;
  int _89;
  uint _95;
  int _102;
  int _107;
  int _110;
  int _112;
  int _114;
  int _116;
  float4 _121;
  float _129;
  float _130;
  float _138;
  float _139;
  float4 _142;
  float4 _146;
  float4 _152;
  float4 _156;
  float4 _162;
  float _168;
  float _169;
  float _170;
  float _172;
  float _173;
  float _178;
  float _180;
  float _183;
  float _184;
  float _188;
  float _190;
  float _191;
  float _196;
  float _197;
  float _199;
  float _200;
  float _201;
  float _202;
  float _203;
  float _204;
  float _205;
  float _213;
  float _219;
  uint _222;
  float _226;
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
  bool _406;
  int _407;
  float2 _410;
  float _415;
  float _416;
  float _420;
  float _422;
  float _423;
  float _428;
  float _429;
  float _431;
  float _432;
  float _433;
  float _434;
  float _436;
  float _445;
  float _446;
  float _448;
  float _449;
  float _450;
  int _458;
  int _459;
  int _460;
  int _461;
  float _465;
  float _467;
  float _468;
  float _478;
  float _479;
  float _484;
  float _488;
  float _489;
  float _492;
  float _502;
  float _503;
  float _504;
  float _508;
  float _523;
  float _526;
  float _529;
  float _532;
  float _535;
  float _538;
  int _574;
  int _575;
  float _578;
  float _579;
  float _580;
  float _581;
  float _584;
  float _585;
  float _586;
  float _587;
  float _590;
  float _591;
  float _592;
  float _593;
  float _596;
  float _597;
  float _598;
  float _599;
  float _602;
  float _603;
  float _604;
  float _605;
  float _608;
  float _609;
  float _610;
  float _611;
  int _614;
  float _617;
  float _618;
  float _619;
  float _622;
  float _623;
  float _624;
  int _627;
  int _630;
  int _633;
  float _662;
  float _665;
  float _668;
  float _669;
  float4 _675;
  float4 _681;
  float _690;
  float _694;
  float _697;
  float _700;
  float _741;
  float _746;
  float _748;
  float _750;
  float _757;
  float _758;
  float4 _764;
  float4 _770;
  float _778;
  float4 _784;
  float4 _790;
  float _807;
  float _808;
  float _809;
  float _810;
  float _811;
  float _812;
  float _813;
  float _814;
  float _815;
  uint _863;
  bool _886;
  int _896;
  float _898;
  float _899;
  float _906;
  float _911;
  float _912;
  bool _913;
  float4 _918;
  float4 _924;
  float _935;
  float4 _940;
  float4 _946;
  float _984;
  int _1004;
  float _1005;
  float _1008;
  float _1009;
  bool _1010;
  float4 _1015;
  float4 _1021;
  float _1032;
  float4 _1037;
  float4 _1043;
  float _1071;
  float _1125;
  float4 _1128;
  float _1131;
  float _1136;
  float _1138;
  float _1139;
  uint _1145;
  int _1148;
  int _1149;
  int _1153;
  int _1157;
  float _1169;
  float _1174;
  float _1175;
  float _1176;
  float _1177;
  float _1180;
  float _1181;
  float _1182;
  float _1183;
  float _1186;
  float _1187;
  float _1188;
  float _1189;
  int _1192;
  int _1195;
  int _1198;
  int _1201;
  float _1216;
  float _1220;
  float _1224;
  float _1249;
  float _1250;
  float _1251;
  float _1254;
  uint _1263;
  bool _1271;
  float _1286;
  float _1304;
  float _1306;
  float _1307;
  float _1308;
  float _1309;
  float _1314;
  float _1315;
  float _1316;
  float _1317;
  float _1319;
  float _1328;
  float _1329;
  float _1334;
  float _1340;
  float _1348;
  float _1362;
  float _1366;
  float _1370;
  int _1380;
  int _1383;
  int _1384;
  int _1385;
  int _1391;
  int _1392;
  int _1393;
  int _1399;
  int _1400;
  int _1401;
  float _1407;
  float _1411;
  float _1415;
  float _1422;
  int _1435;
  int _1438;
  int _1439;
  int _1440;
  int _1446;
  int _1447;
  int _1448;
  int _1454;
  int _1455;
  int _1456;
  float _1462;
  float _1466;
  float _1470;
  float _1477;
  float _1510;
  float _1514;
  float _1518;
  float _1537;
  float _1541;
  float _1545;
  float _1558;
  float _1559;
  float _1560;
  uint _1598;
  int _1610;
  int _1614;
  int _1615;
  int _1616;
  int _1617;
  int _1629;
  int _1633;
  float _1645;
  int _1648;
  float _1665;
  float _1670;
  float _1671;
  float _1672;
  float _1673;
  float _1676;
  float _1677;
  float _1678;
  float _1679;
  float _1682;
  float _1683;
  float _1684;
  float _1685;
  int _1688;
  int _1691;
  int _1694;
  int _1697;
  int _1700;
  float _1702;
  float _1703;
  float _1705;
  float _1709;
  float _1722;
  float _1726;
  float _1730;
  float _1755;
  float _1756;
  float _1757;
  float _1760;
  float _1761;
  float _1768;
  float _1789;
  float _1790;
  float _1791;
  float _1792;
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
  float _1812;
  int _1815;
  int _1818;
  int _1821;
  int _1824;
  float _1827;
  float _1828;
  float _1829;
  float _1830;
  int _1833;
  int _1836;
  int _1839;
  int _1842;
  int _1845;
  int _1848;
  int _1851;
  int _1854;
  float _1856;
  float _1857;
  float _1859;
  float _1863;
  int _1865;
  bool _1871;
  float _1876;
  float _1877;
  float _1879;
  float _1880;
  float _1881;
  float _1882;
  float _1901;
  float _1905;
  float _1906;
  float _1907;
  float _1911;
  float _1915;
  float _1919;
  float _1920;
  float _1943;
  float _1944;
  float _1945;
  float _1948;
  float _1949;
  float _1956;
  float _1957;
  float _1958;
  float _1963;
  float _1965;
  float _1966;
  float _1969;
  float _1973;
  float _1982;
  float _1983;
  float _1984;
  int _1985;
  float _1990;
  float _1999;
  float _2000;
  float _2002;
  float4 _2007;
  float _2012;
  float _2014;
  float _2016;
  float _2018;
  float _2022;
  float _2024;
  float _2028;
  float _2030;
  int _2037;
  float _2042;
  float _2051;
  float _2052;
  float4 _2058;
  float _2063;
  float _2065;
  float _2069;
  float _2071;
  float _2075;
  float _2077;
  float _2081;
  float _2083;
  int _2090;
  float _2095;
  float _2104;
  float _2105;
  float4 _2111;
  float _2116;
  float _2118;
  float _2122;
  float _2124;
  float _2128;
  float _2130;
  float _2134;
  float _2136;
  int _2143;
  float _2148;
  float _2157;
  float _2158;
  float4 _2164;
  float _2169;
  float _2171;
  float _2175;
  float _2177;
  float _2181;
  float _2183;
  float _2187;
  float _2189;
  float _2190;
  float _2201;
  float _2207;
  float _2209;
  float _2211;
  float _2218;
  float _2223;
  float _2224;
  float _2225;
  float _2226;
  float4 _2228;
  float _2236;
  float _2237;
  float4 _2238;
  float _2243;
  float _2248;
  float4 _2249;
  float _2254;
  float4 _2259;
  float _2268;
  float _2277;
  float _2278;
  float _2287;
  float _2291;
  float _2300;
  float _2301;
  float _2302;
  float _2307;
  int _2308;
  float _2313;
  float _2322;
  float _2323;
  float _2325;
  float _2327;
  float _2328;
  float4 _2330;
  float _2334;
  float _2335;
  float _2338;
  float _2339;
  float _2344;
  float _2345;
  float _2348;
  float _2349;
  float _2351;
  float _2353;
  bool _2354;
  bool _2355;
  bool _2365;
  bool _2374;
  float _2391;
  float _2393;
  float _2395;
  float _2397;
  float _2401;
  float _2403;
  float _2407;
  float _2409;
  int _2416;
  float _2421;
  float _2430;
  float _2431;
  float _2434;
  float _2435;
  float4 _2437;
  float _2441;
  float _2442;
  float _2445;
  float _2446;
  float _2448;
  float _2450;
  bool _2451;
  bool _2452;
  bool _2462;
  bool _2471;
  float _2488;
  float _2490;
  float _2494;
  float _2496;
  float _2500;
  float _2502;
  float _2506;
  float _2508;
  int _2515;
  float _2520;
  float _2529;
  float _2530;
  float _2533;
  float _2534;
  float4 _2536;
  float _2540;
  float _2541;
  float _2544;
  float _2545;
  float _2547;
  float _2549;
  bool _2550;
  bool _2551;
  bool _2561;
  bool _2570;
  float _2587;
  float _2589;
  float _2593;
  float _2595;
  float _2599;
  float _2601;
  float _2605;
  float _2607;
  int _2614;
  float _2619;
  float _2628;
  float _2629;
  float _2632;
  float _2633;
  float4 _2635;
  float _2639;
  float _2640;
  float _2643;
  float _2644;
  float _2646;
  float _2648;
  bool _2649;
  bool _2650;
  bool _2660;
  bool _2669;
  float _2686;
  float _2688;
  float _2692;
  float _2694;
  float _2698;
  float _2700;
  float _2704;
  float _2706;
  float _2707;
  float _2718;
  float _2724;
  float _2726;
  float _2728;
  float _2750;
  float4 _2757;
  float _2771;
  float _2772;
  float _2773;
  float _2774;
  float _2776;
  float _2781;
  float _2784;
  float _2785;
  float _2787;
  float _2788;
  float _2793;
  float _2798;
  float _2800;
  float _2803;
  float _2804;
  float _2809;
  float _2811;
  float _2813;
  float _2815;
  float _2820;
  float _2826;
  float _2828;
  float3 _2861;
  float _2872;
  float _2873;
  float4 _2894;
  int _2925;
  int _2930;
  int _2932;
  int _2933;
  int _2935;
  int _2936;
  int _2945;
  int _2948;
  bool _2963;
  float _2966;
  float _2969;
  float _2970;
  float _2971;
  float _2972;
  float _2973;
  float _2974;
  uint _2977;
  float _2986;
  float _2987;
  float _2988;
  float _3004;
  float _3011;
  float _3014;
  float _3019;
  float _3026;
  float _3027;
  float _3028;
  float _3029;
  float _3051;
  float _3052;
  float _3053;
  float _3055;
  float _3070;
  float _3071;
  float _3072;
  float _3073;
  bool _3076;
  float _3077;
  float _3078;
  float _3079;
  float _3081;
  float _3084;
  float _3086;
  float _3087;
  float _3088;
  float _3089;
  float _3092;
  float _3095;
  float _3098;
  float _3100;
  float _3104;
  float _3113;
  float _3114;
  float _3116;
  float _3117;
  float _3118;
  float _3125;
  float _3126;
  float _3127;
  float _3128;
  float _3131;
  float _3134;
  float _3135;
  float _3140;
  float _3144;
  float _3149;
  float _3156;
  float _3160;
  float _3161;
  float _3162;
  float _3166;
  float _3167;
  float _3168;
  float _3175;
  float _3179;
  float _3183;
  float _3184;
  float _3185;
  float _3189;
  float _3199;
  float _3209;
  float _3211;
  float _3224;
  float _3225;
  float _3231;
  float _3234;
  float _3243;
  float _3245;
  float _3254;
  float _3259;
  float _3265;
  float _3266;
  float _3270;
  float _3271;
  float _3276;
  float _3295;
  float _3298;
  float _3301;
  float _3315;
  float _3325;
  float _3326;
  float _3330;
  float _3332;
  float _3334;
  float _3337;
  float _3350;
  float _3361;
  float _3362;
  float _3363;
  float _3370;
  float _3371;
  float _3372;
  float _3375;
  float _3389;
  float _3390;
  float _3391;
  float _3392;
  float _3395;
  float _3396;
  float _3397;
  float _3398;
  float _3401;
  float _3402;
  float _3403;
  int _3406;
  int _3409;
  int _3412;
  int _3415;
  int _3418;
  float _3422;
  int _3423;
  float2 _3443;
  float3 _3460;
  float _3473;
  float _3477;
  float _3478;
  float _3479;
  float _3480;
  float _3481;
  float _3482;
  uint _3485;
  float _3494;
  float _3495;
  float _3496;
  float _3512;
  float _3519;
  float _3522;
  float _3527;
  float _3534;
  float _3535;
  float _3536;
  float _3537;
  float _3559;
  float _3560;
  float _3561;
  float _3563;
  float _3578;
  float _3579;
  float _3580;
  float _3581;
  bool _3584;
  float _3585;
  float _3586;
  float _3587;
  float _3589;
  float _3592;
  float _3594;
  float _3595;
  float _3596;
  float _3597;
  float _3600;
  float _3603;
  float _3606;
  float _3608;
  float _3612;
  float _3621;
  float _3622;
  float _3624;
  float _3625;
  float _3626;
  float _3633;
  float _3634;
  float _3635;
  float _3636;
  float _3639;
  float _3642;
  float _3643;
  float _3648;
  float _3652;
  float _3657;
  float _3664;
  float _3668;
  float _3669;
  float _3670;
  float _3674;
  float _3675;
  float _3676;
  float _3683;
  float _3687;
  float _3691;
  float _3692;
  float _3693;
  float _3696;
  float _3699;
  float _3709;
  float _3711;
  float _3724;
  float _3725;
  float _3731;
  float _3734;
  float _3743;
  float _3745;
  float _3754;
  float _3759;
  float _3765;
  float _3766;
  float _3770;
  float _3771;
  float _3776;
  float _3795;
  float _3798;
  float _3801;
  float _3815;
  float _3825;
  float _3826;
  float _3830;
  float _3832;
  float _3834;
  float _3837;
  float _3850;
  float _3873;
  bool _3886;
  float _3887;
  float _3888;
  float _3889;
  bool _3890;
  float _3892;
  float _3893;
  float _3897;
  float _3903;
  float _3917;
  float _3918;
  float _3921;
  float _3925;
  int _3926;
  float _3928;
  float _3930;
  float _3933;
  float _3937;
  float _3948;
  float _3949;
  float _3950;
  float _3952;
  float _3966;
  float _3967;
  float _3968;
  float _3984;
  float _3985;
  float _3986;
  float _4000;
  float _4015;
  float _4016;
  float _4017;
  float _4020;
  float _4021;
  float _4022;
  float _4025;
  float _4026;
  float _4027;
  float _4030;
  float _4031;
  float _4032;
  float _4035;
  float _4036;
  float _4037;
  int _4040;
  int _4043;
  int _4046;
  int _4049;
  int _4052;
  int _4055;
  int _4058;
  int _4061;
  int _4064;
  int _4067;
  float _4070;
  float _4071;
  float _4072;
  float _4073;
  int _4076;
  int _4079;
  int _4082;
  int _4085;
  float _4087;
  float _4088;
  float _4090;
  float _4094;
  float _4095;
  float _4098;
  float _4100;
  float _4101;
  float _4103;
  int _4106;
  bool _4110;
  float _4118;
  float _4119;
  float _4121;
  float _4124;
  float _4125;
  float _4127;
  float _4128;
  float _4130;
  float _4131;
  float _4135;
  float _4141;
  float _4142;
  float _4143;
  float _4156;
  float _4157;
  float _4158;
  float _4159;
  float _4160;
  float _4161;
  float _4162;
  float _4163;
  float _4164;
  float _4167;
  float _4168;
  float _4169;
  float _4172;
  float _4179;
  float _4192;
  float _4196;
  float _4200;
  float _4201;
  float _4202;
  float _4205;
  float _4208;
  bool _4210;
  float _4216;
  float _4217;
  float _4218;
  float _4223;
  float _4224;
  float _4225;
  bool _4229;
  bool _4235;
  bool _4239;
  float _4249;
  float _4254;
  float _4263;
  float _4264;
  float _4265;
  float _4270;
  float _4271;
  float _4274;
  float _4278;
  float _4287;
  float _4288;
  float _4289;
  float _4294;
  int _4295;
  float _4300;
  float _4309;
  float _4310;
  float _4312;
  float _4314;
  float _4315;
  float4 _4317;
  float _4321;
  float _4322;
  float _4325;
  float _4326;
  float _4331;
  float _4332;
  float _4335;
  float _4336;
  float _4338;
  float _4340;
  bool _4341;
  bool _4342;
  bool _4352;
  bool _4361;
  float _4378;
  float _4380;
  float _4382;
  float _4384;
  float _4388;
  float _4390;
  float _4394;
  float _4396;
  int _4403;
  float _4408;
  float _4417;
  float _4418;
  float _4421;
  float _4422;
  float4 _4424;
  float _4428;
  float _4429;
  float _4432;
  float _4433;
  float _4435;
  float _4437;
  bool _4438;
  bool _4439;
  bool _4449;
  bool _4458;
  float _4475;
  float _4477;
  float _4481;
  float _4483;
  float _4487;
  float _4489;
  float _4493;
  float _4495;
  int _4502;
  float _4507;
  float _4516;
  float _4517;
  float _4520;
  float _4521;
  float4 _4523;
  float _4527;
  float _4528;
  float _4531;
  float _4532;
  float _4534;
  float _4536;
  bool _4537;
  bool _4538;
  bool _4548;
  bool _4557;
  float _4574;
  float _4576;
  float _4580;
  float _4582;
  float _4586;
  float _4588;
  float _4592;
  float _4594;
  int _4601;
  float _4606;
  float _4615;
  float _4616;
  float _4619;
  float _4620;
  float4 _4622;
  float _4626;
  float _4627;
  float _4630;
  float _4631;
  float _4633;
  float _4635;
  bool _4636;
  bool _4637;
  bool _4647;
  bool _4656;
  float _4673;
  float _4675;
  float _4679;
  float _4681;
  float _4685;
  float _4687;
  float _4691;
  float _4693;
  float _4694;
  float _4705;
  float _4711;
  float _4713;
  float _4715;
  float _4727;
  float _4730;
  float _4731;
  float _4734;
  float _4745;
  float _4746;
  float _4747;
  float _4751;
  float _4760;
  float _4761;
  float _4762;
  int _4763;
  float _4768;
  float _4777;
  float _4778;
  float _4780;
  float4 _4785;
  float _4790;
  float _4792;
  float _4794;
  float _4796;
  float _4800;
  float _4802;
  float _4806;
  float _4808;
  int _4815;
  float _4820;
  float _4829;
  float _4830;
  float4 _4836;
  float _4841;
  float _4843;
  float _4847;
  float _4849;
  float _4853;
  float _4855;
  float _4859;
  float _4861;
  int _4868;
  float _4873;
  float _4882;
  float _4883;
  float4 _4889;
  float _4894;
  float _4896;
  float _4900;
  float _4902;
  float _4906;
  float _4908;
  float _4912;
  float _4914;
  int _4921;
  float _4926;
  float _4935;
  float _4936;
  float4 _4942;
  float _4947;
  float _4949;
  float _4953;
  float _4955;
  float _4959;
  float _4961;
  float _4965;
  float _4967;
  float _4968;
  float _4979;
  float _4985;
  float _4987;
  float _4989;
  float _4997;
  float _5004;
  float _5006;
  float _5013;
  float _5014;
  float _5015;
  float _5016;
  float4 _5018;
  float _5027;
  float4 _5028;
  float _5033;
  float _5039;
  float4 _5040;
  float _5045;
  float4 _5050;
  float _5072;
  float _5073;
  float _5074;
  bool _5078;
  bool _5084;
  bool _5088;
  float _5098;
  float _5103;
  float _5112;
  float _5113;
  float _5118;
  float _5119;
  float _5122;
  float _5126;
  float _5135;
  float _5136;
  float _5137;
  float _5142;
  int _5143;
  float _5148;
  float _5157;
  float _5158;
  float _5160;
  float _5162;
  float _5163;
  float4 _5165;
  float _5169;
  float _5170;
  float _5173;
  float _5174;
  float _5179;
  float _5180;
  float _5183;
  float _5184;
  float _5186;
  float _5188;
  bool _5189;
  bool _5190;
  bool _5200;
  bool _5209;
  float _5226;
  float _5228;
  float _5230;
  float _5232;
  float _5236;
  float _5238;
  float _5242;
  float _5244;
  int _5251;
  float _5256;
  float _5265;
  float _5266;
  float _5269;
  float _5270;
  float4 _5272;
  float _5276;
  float _5277;
  float _5280;
  float _5281;
  float _5283;
  float _5285;
  bool _5286;
  bool _5287;
  bool _5297;
  bool _5306;
  float _5323;
  float _5325;
  float _5329;
  float _5331;
  float _5335;
  float _5337;
  float _5341;
  float _5343;
  int _5350;
  float _5355;
  float _5364;
  float _5365;
  float _5368;
  float _5369;
  float4 _5371;
  float _5375;
  float _5376;
  float _5379;
  float _5380;
  float _5382;
  float _5384;
  bool _5385;
  bool _5386;
  bool _5396;
  bool _5405;
  float _5422;
  float _5424;
  float _5428;
  float _5430;
  float _5434;
  float _5436;
  float _5440;
  float _5442;
  int _5449;
  float _5454;
  float _5463;
  float _5464;
  float _5467;
  float _5468;
  float4 _5470;
  float _5474;
  float _5475;
  float _5478;
  float _5479;
  float _5481;
  float _5483;
  bool _5484;
  bool _5485;
  bool _5495;
  bool _5504;
  float _5521;
  float _5523;
  float _5527;
  float _5529;
  float _5533;
  float _5535;
  float _5539;
  float _5541;
  float _5542;
  float _5553;
  float _5559;
  float _5561;
  float _5563;
  float _5572;
  float _5575;
  float _5576;
  float _5589;
  float _5590;
  float _5591;
  float _5595;
  float _5604;
  float _5605;
  float _5606;
  int _5607;
  float _5612;
  float _5621;
  float _5622;
  float _5624;
  float4 _5629;
  float _5634;
  float _5636;
  float _5638;
  float _5640;
  float _5644;
  float _5646;
  float _5650;
  float _5652;
  int _5659;
  float _5664;
  float _5673;
  float _5674;
  float4 _5680;
  float _5685;
  float _5687;
  float _5691;
  float _5693;
  float _5697;
  float _5699;
  float _5703;
  float _5705;
  int _5712;
  float _5717;
  float _5726;
  float _5727;
  float4 _5733;
  float _5738;
  float _5740;
  float _5744;
  float _5746;
  float _5750;
  float _5752;
  float _5756;
  float _5758;
  int _5765;
  float _5770;
  float _5779;
  float _5780;
  float4 _5786;
  float _5791;
  float _5793;
  float _5797;
  float _5799;
  float _5803;
  float _5805;
  float _5809;
  float _5811;
  float _5812;
  float _5823;
  float _5829;
  float _5831;
  float _5833;
  float _5841;
  float _5848;
  float _5850;
  float _5880;
  float _5882;
  float _5883;
  float _5884;
  float _5899;
  float _5902;
  float _5905;
  float _5907;
  float _5908;
  float _5909;
  float _5910;
  float _5918;
  float _5919;
  float _5920;
  bool _5922;
  float _5942;
  float4 _5967;
  float _5987;
  float _5988;
  float _5989;
  float _5990;
  float _5992;
  float _5997;
  float _6000;
  float _6001;
  float _6003;
  float _6004;
  float _6009;
  float _6014;
  float _6016;
  float _6019;
  float _6020;
  float _6025;
  float _6027;
  float _6029;
  float _6031;
  float _6036;
  float _6042;
  float _6044;
  float3 _6078;
  float _6089;
  float4 _6110;
  float _6145;
  bool _6158;
  float _6159;
  float _6160;
  float _6161;
  bool _6162;
  float _6164;
  float _6165;
  float _6169;
  float _6175;
  float _6189;
  float _6190;
  float _6193;
  float _6197;
  int _6198;
  float _6200;
  float _6202;
  float _6205;
  float _6209;
  float _6220;
  float _6221;
  float _6222;
  float _6224;
  int _6244;
  int _6249;
  int _6251;
  int _6252;
  int _6254;
  int _6255;
  int _6264;
  int _6267;
  bool _6282;
  float _6285;
  float _6287;
  float _6288;
  float _6289;
  float _6290;
  float _6291;
  float _6292;
  float _6293;
  float _6294;
  float _6295;
  float _6297;
  float _6298;
  float _6299;
  float _6305;
  float _6309;
  float _6310;
  float _6311;
  float _6312;
  float _6313;
  float _6314;
  float _6315;
  float _6321;
  float _6330;
  float _6334;
  float _6335;
  float _6336;
  float _6337;
  float _6341;
  float _6342;
  float _6343;
  float _6351;
  float _6363;
  float _6364;
  float _6365;
  float _6366;
  float _6368;
  float _6369;
  float _6370;
  float _6371;
  float _6373;
  uint _6376;
  float _6385;
  float _6386;
  float _6387;
  float _6400;
  float _6407;
  float _6410;
  float _6415;
  float _6422;
  float _6423;
  float _6424;
  float _6425;
  float _6447;
  float _6448;
  float _6449;
  float _6451;
  float _6466;
  float _6467;
  float _6468;
  float _6469;
  bool _6472;
  float _6473;
  float _6474;
  float _6475;
  float _6477;
  float _6480;
  float _6482;
  float _6483;
  float _6484;
  float _6485;
  float _6488;
  float _6491;
  float _6494;
  float _6496;
  float _6500;
  float _6509;
  float _6510;
  float _6512;
  float _6513;
  float _6514;
  float _6521;
  float _6522;
  float _6523;
  float _6524;
  float _6527;
  float _6530;
  float _6531;
  float _6536;
  float _6540;
  float _6545;
  float _6552;
  float _6556;
  float _6557;
  float _6558;
  float _6562;
  float _6563;
  float _6564;
  float _6571;
  float _6575;
  float _6579;
  float _6580;
  float _6581;
  float _6585;
  float _6596;
  float _6606;
  float _6608;
  float _6621;
  float _6622;
  float _6628;
  float _6631;
  float _6640;
  float _6642;
  float _6651;
  float _6656;
  float _6662;
  float _6663;
  float _6667;
  float _6668;
  float _6673;
  float _6692;
  float _6695;
  float _6698;
  float _6712;
  float _6722;
  float _6723;
  float _6727;
  float _6729;
  float _6731;
  float _6734;
  float _6747;
  float _6758;
  float _6759;
  float _6760;
  float _6767;
  float _6768;
  float _6769;
  float _6773;
  float _6788;
  float _6789;
  float _6790;
  float _6793;
  float _6794;
  float _6795;
  float _6798;
  int _6801;
  int _6804;
  int _6807;
  float _6816;
  float _6819;
  float _6826;
  float _6831;
  float _6833;
  float _6835;
  float _6836;
  float _6837;
  float _6839;
  float _6840;
  float _6841;
  float _6844;
  float _6845;
  float _6846;
  float _6849;
  float _6856;
  int _6865;
  int _6870;
  int _6872;
  int _6873;
  int _6875;
  int _6876;
  int _6885;
  int _6888;
  bool _6903;
  float _6906;
  float _6908;
  float _6909;
  uint _6912;
  float _6921;
  float _6922;
  float _6923;
  float _6939;
  float _6946;
  float _6949;
  float _6954;
  float _6961;
  float _6962;
  float _6963;
  float _6964;
  float _6986;
  float _6987;
  float _6988;
  float _6990;
  float _7002;
  float _7003;
  float _7004;
  float _7005;
  bool _7008;
  float _7009;
  float _7010;
  float _7011;
  float _7013;
  float _7016;
  float _7018;
  float _7019;
  float _7020;
  float _7021;
  float _7024;
  float _7027;
  float _7030;
  float _7032;
  float _7036;
  float _7045;
  float _7046;
  float _7048;
  float _7049;
  float _7050;
  float _7057;
  float _7058;
  float _7059;
  float _7060;
  float _7063;
  float _7066;
  float _7067;
  float _7072;
  float _7076;
  float _7081;
  float _7088;
  float _7092;
  float _7093;
  float _7094;
  float _7098;
  float _7099;
  float _7100;
  float _7107;
  float _7111;
  float _7115;
  float _7116;
  float _7117;
  float _7118;
  float _7121;
  float _7131;
  float _7133;
  float _7146;
  float _7147;
  float _7153;
  float _7156;
  float _7165;
  float _7167;
  float _7176;
  float _7181;
  float _7187;
  float _7188;
  float _7192;
  float _7193;
  float _7198;
  float _7217;
  float _7220;
  float _7223;
  float _7237;
  float _7247;
  float _7248;
  float _7252;
  float _7254;
  float _7256;
  float _7259;
  float _7272;
  float _7283;
  float _7284;
  float _7285;
  float _7292;
  float _7293;
  float _7294;
  float _7298;
  float _7313;
  float _7314;
  float _7315;
  float _7318;
  float _7319;
  float _7320;
  float _7323;
  float _7324;
  float _7325;
  float _7328;
  float _7329;
  float _7330;
  float _7333;
  float _7334;
  float _7335;
  float _7338;
  float _7339;
  float _7340;
  int _7343;
  int _7346;
  int _7349;
  float _7352;
  float _7353;
  float _7354;
  float _7355;
  int _7358;
  int _7361;
  int _7364;
  int _7367;
  int _7370;
  int _7373;
  int _7376;
  float _7379;
  float _7380;
  float _7381;
  float _7382;
  int _7385;
  int _7388;
  int _7391;
  float _7393;
  float _7394;
  float _7396;
  float _7400;
  float _7401;
  float _7404;
  int _7408;
  bool _7414;
  float _7425;
  float _7426;
  float _7428;
  float _7429;
  float _7430;
  float _7431;
  float _7432;
  float _7433;
  float _7434;
  float _7435;
  float _7436;
  float _7437;
  float _7438;
  float _7439;
  float _7440;
  float _7443;
  float _7444;
  float _7445;
  float _7448;
  float _7459;
  float _7463;
  float _7470;
  float _7471;
  float _7472;
  float _7484;
  float _7485;
  float _7486;
  float _7487;
  float _7490;
  float _7491;
  float _7494;
  float _7495;
  float _7502;
  float _7504;
  float _7510;
  float _7520;
  float _7521;
  float _7522;
  float _7527;
  float _7529;
  float _7530;
  float _7533;
  float _7537;
  float _7546;
  float _7547;
  float _7548;
  int _7549;
  float _7554;
  float _7563;
  float _7564;
  float _7566;
  float4 _7571;
  float _7576;
  float _7578;
  float _7580;
  float _7582;
  float _7586;
  float _7588;
  float _7592;
  float _7594;
  int _7601;
  float _7606;
  float _7615;
  float _7616;
  float4 _7622;
  float _7627;
  float _7629;
  float _7633;
  float _7635;
  float _7639;
  float _7641;
  float _7645;
  float _7647;
  int _7654;
  float _7659;
  float _7668;
  float _7669;
  float4 _7675;
  float _7680;
  float _7682;
  float _7686;
  float _7688;
  float _7692;
  float _7694;
  float _7698;
  float _7700;
  int _7707;
  float _7712;
  float _7721;
  float _7722;
  float4 _7728;
  float _7733;
  float _7735;
  float _7739;
  float _7741;
  float _7745;
  float _7747;
  float _7751;
  float _7753;
  float _7754;
  float _7765;
  float _7771;
  float _7773;
  float _7775;
  float _7782;
  float _7787;
  float _7788;
  float _7789;
  float _7790;
  float4 _7792;
  float _7800;
  float _7801;
  float4 _7802;
  float _7807;
  float _7812;
  float4 _7813;
  float _7818;
  float4 _7823;
  float _7832;
  float _7841;
  float _7842;
  float _7851;
  float _7855;
  float _7864;
  float _7865;
  float _7866;
  float _7871;
  int _7872;
  float _7877;
  float _7886;
  float _7887;
  float _7889;
  float _7891;
  float _7892;
  float4 _7894;
  float _7898;
  float _7899;
  float _7902;
  float _7903;
  float _7908;
  float _7909;
  float _7912;
  float _7913;
  float _7915;
  float _7917;
  bool _7918;
  bool _7919;
  bool _7929;
  bool _7938;
  float _7955;
  float _7957;
  float _7959;
  float _7961;
  float _7965;
  float _7967;
  float _7971;
  float _7973;
  int _7980;
  float _7985;
  float _7994;
  float _7995;
  float _7998;
  float _7999;
  float4 _8001;
  float _8005;
  float _8006;
  float _8009;
  float _8010;
  float _8012;
  float _8014;
  bool _8015;
  bool _8016;
  bool _8026;
  bool _8035;
  float _8052;
  float _8054;
  float _8058;
  float _8060;
  float _8064;
  float _8066;
  float _8070;
  float _8072;
  int _8079;
  float _8084;
  float _8093;
  float _8094;
  float _8097;
  float _8098;
  float4 _8100;
  float _8104;
  float _8105;
  float _8108;
  float _8109;
  float _8111;
  float _8113;
  bool _8114;
  bool _8115;
  bool _8125;
  bool _8134;
  float _8151;
  float _8153;
  float _8157;
  float _8159;
  float _8163;
  float _8165;
  float _8169;
  float _8171;
  int _8178;
  float _8183;
  float _8192;
  float _8193;
  float _8196;
  float _8197;
  float4 _8199;
  float _8203;
  float _8204;
  float _8207;
  float _8208;
  float _8210;
  float _8212;
  bool _8213;
  bool _8214;
  bool _8224;
  bool _8233;
  float _8250;
  float _8252;
  float _8256;
  float _8258;
  float _8262;
  float _8264;
  float _8268;
  float _8270;
  float _8271;
  float _8282;
  float _8288;
  float _8290;
  float _8292;
  float _8314;
  float4 _8321;
  float _8335;
  float _8336;
  float _8337;
  float _8338;
  float _8340;
  float _8345;
  float _8348;
  float _8349;
  float _8351;
  float _8352;
  float _8357;
  float _8362;
  float _8364;
  float _8367;
  float _8368;
  float _8373;
  float _8375;
  float _8377;
  float _8379;
  float _8384;
  float _8390;
  float _8392;
  float3 _8425;
  float _8436;
  float _8437;
  float4 _8458;
  float _8496;
  bool _8509;
  float _8510;
  float _8511;
  float _8512;
  bool _8513;
  float _8515;
  float _8516;
  float _8520;
  float _8526;
  float _8540;
  float _8541;
  float _8544;
  float _8548;
  int _8549;
  float _8551;
  float _8553;
  float _8556;
  float _8560;
  float _8571;
  float _8572;
  float _8573;
  float _8575;
  int _8596;
  int _8601;
  int _8603;
  int _8604;
  int _8606;
  int _8607;
  int _8616;
  int _8619;
  bool _8634;
  float _8637;
  float _8639;
  float _8640;
  float _8641;
  float _8642;
  float _8643;
  float _8644;
  float _8645;
  float _8646;
  float _8647;
  float _8649;
  float _8650;
  float _8651;
  float _8657;
  float _8661;
  float _8662;
  float _8663;
  float _8664;
  float _8665;
  float _8666;
  float _8667;
  float _8673;
  float _8682;
  float _8686;
  float _8687;
  float _8688;
  float _8689;
  float _8693;
  float _8694;
  float _8695;
  float _8703;
  float _8715;
  float _8716;
  float _8717;
  float _8718;
  float _8720;
  float _8721;
  float _8722;
  float _8723;
  float _8725;
  uint _8728;
  float _8737;
  float _8738;
  float _8739;
  float _8752;
  float _8759;
  float _8762;
  float _8767;
  float _8774;
  float _8775;
  float _8776;
  float _8777;
  float _8799;
  float _8800;
  float _8801;
  float _8803;
  float _8818;
  float _8819;
  float _8820;
  float _8821;
  bool _8824;
  float _8825;
  float _8826;
  float _8827;
  float _8829;
  float _8832;
  float _8834;
  float _8835;
  float _8836;
  float _8837;
  float _8840;
  float _8843;
  float _8846;
  float _8848;
  float _8852;
  float _8861;
  float _8862;
  float _8864;
  float _8865;
  float _8866;
  float _8873;
  float _8874;
  float _8875;
  float _8876;
  float _8879;
  float _8882;
  float _8883;
  float _8888;
  float _8892;
  float _8897;
  float _8904;
  float _8908;
  float _8909;
  float _8910;
  float _8914;
  float _8915;
  float _8916;
  float _8923;
  float _8927;
  float _8931;
  float _8932;
  float _8933;
  float _8937;
  float _8948;
  float _8958;
  float _8960;
  float _8973;
  float _8974;
  float _8980;
  float _8983;
  float _8992;
  float _8994;
  float _9003;
  float _9008;
  float _9014;
  float _9015;
  float _9019;
  float _9020;
  float _9025;
  float _9044;
  float _9047;
  float _9050;
  float _9064;
  float _9074;
  float _9075;
  float _9079;
  float _9081;
  float _9083;
  float _9086;
  float _9099;
  float _9110;
  float _9111;
  float _9112;
  float _9119;
  float _9120;
  float _9121;
  float _9125;
  float _9140;
  float _9141;
  float _9142;
  float _9143;
  float _9146;
  float _9147;
  float _9148;
  float _9149;
  float _9152;
  float _9153;
  float _9154;
  float _9155;
  float _9158;
  float _9159;
  int _9162;
  int _9165;
  int _9168;
  int _9171;
  float _9174;
  float _9176;
  float _9177;
  float _9179;
  float _9183;
  float _9185;
  float _9189;
  float _9193;
  float _9197;
  float _9200;
  float _9203;
  float _9206;
  float _9218;
  float _9219;
  float _9220;
  float _9221;
  float _9222;
  float _9223;
  float _9224;
  float _9225;
  float _9226;
  float _9227;
  float _9228;
  float _9230;
  float _9232;
  float _9234;
  float _9236;
  float _9237;
  float _9243;
  float _9245;
  float _9252;
  float _9267;
  float _9269;
  float _9276;
  float _9286;
  float _9292;
  float _9294;
  float _9301;
  float _9318;
  float _9320;
  float _9327;
  float _9346;
  float _9347;
  float _9348;
  float _9349;
  float _9351;
  float _9353;
  float _9354;
  float _9355;
  float _9356;
  float _9357;
  float _9358;
  float _9359;
  float _9360;
  float _9362;
  float _9364;
  float _9365;
  float _9366;
  float _9367;
  float _9368;
  float _9369;
  float _9370;
  float _9372;
  float _9374;
  float _9381;
  bool _9394;
  float _9396;
  float _9402;
  float _9406;
  float _9408;
  float _9409;
  bool _9410;
  float _9412;
  float _9418;
  float _9419;
  float _9424;
  float _9425;
  float _9428;
  float _9430;
  float _9437;
  float _9450;
  float _9452;
  float _9459;
  float _9488;
  float _9489;
  float _9498;
  float _9511;
  float _9512;
  float4 _9520;
  float _9522;
  float4 _9523;
  float _9532;
  float _9538;
  float _9539;
  float _9567;
  uint _9581;
  float _9592;
  float _9599;
  float _9610;
  float _9629;
  float _9632;
  float _9635;
  float4 _9656;
  float _9660;
  float _9661;
  float _9662;
  float _9664;
  float _9665;
  float _9666;
  float _9667;
  float _9668;
  float _9669;
  float _9670;
  float _9671;
  float _9672;
  float _9677;
  float _9682;
  float _9695;
  float4 _9703;
  float _9705;
  float _9712;
  bool _9745;
  int __loop_jump_target = -1;
  _56 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _62 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _67 = ((uint)(((int)(_62 << 3)) & 524280)) + SV_GroupThreadID.x;
  _68 = ((uint)(((uint)(_62) >> 16) << 3)) + SV_GroupThreadID.y;
  _75 = ((int)((((uint)(_68) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_67) >> 4)))) << 6;
  _78 = srvDeferredClusters[_75];
  if (_56 == 0) {
    _global_2 = (_78 & 255);
    _global_0 = (((uint)(_78) >> 16) & 255);
    _global_1 = (((uint)(_78) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _89 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_89 == 0)) {
    _93 = 0;
    while(true) {
      _95 = (_93 << 6) + _56;
      if ((uint)_95 < (uint)_global_2) {
        _102 = srvDeferredClusters[((int)(((uint)(_75 | 1)) + _95))];
        _global_3[min((uint)(_95), 63u)] = _102;
        _107 = _102 & 4095;
        _110 = srvLightInfoBase[_107].nFlags;
        _112 = srvLightInfoBase[_107].nRoomMask;
        _114 = srvLightInfoBase[_107].nBufferOffset;
        _global_4[min((uint)(_95), 63u)] = _110;
        _global_5[min((uint)(_95), 63u)] = _112;
        _global_6[min((uint)(_95), 63u)] = _114;
      }
      _116 = _93 + 1;
      if (!(_116 == _89)) {
        _93 = _116;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _121 = srvGlobalGBuffer0.Load(int3(_67, _68, 0));
  [branch]
  if (_121.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_67, _68)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_67, _68)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _129 = (float)((uint)_67);
    _130 = (float)((uint)_68);
    _138 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _129) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
    _139 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _130) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
    [branch]
    if (_121.x > 0.0f) {
      _142 = srvGlobalGBuffer1.Load(int3(_67, _68, 0));
      _146 = srvGlobalGBuffer2.Load(int3(_67, _68, 0));
      _152 = srvGlobalGBuffer3.Load(int3(_67, _68, 0));
      _156 = srvGlobalGBuffer4.Load(int3(_67, _68, 0));
      _162 = srvGlobalGBuffer5.Load(int3(_67, _68, 0));
      _168 = saturate(_146.x);
      _169 = saturate(_146.y);
      _170 = saturate(_146.z);
      _172 = saturate(_152.x);
      _173 = saturate(_152.y);
      _178 = saturate(_162.x);
      _180 = saturate(_162.z);
      _183 = (saturate(_142.x) * 2.0f) + -1.0f;
      _184 = (saturate(_142.y) * 2.0f) + -1.0f;
      _188 = (1.0f - abs(_183)) - abs(_184);
      _190 = saturate(-0.0f - _188);
      _191 = -0.0f - _190;
      _196 = select((_183 >= 0.0f), _191, _190) + _183;
      _197 = select((_184 >= 0.0f), _191, _190) + _184;
      _199 = rsqrt(dot(float3(_196, _197, _188), float3(_196, _197, _188)));
      _200 = _196 * _199;
      _201 = -0.0f - _200;
      _202 = _197 * _199;
      _203 = -0.0f - _202;
      _204 = _199 * _188;
      _205 = -0.0f - _204;
      _213 = _173 * 0.07999999821186066f;
      _219 = min(1.0f, max(saturate(_156.x), 0.019999999552965164f));
      _222 = uint((saturate(_162.y) * 255.0f) + 0.5f);
      _226 = saturate(_156.y) * (((float)((uint)((uint)((uint)(_222) >> 1)))) * 0.007874015718698502f);
      _233 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _121.x) - cbSharedPerViewData.vViewRemap.y);
      _234 = _233 * _138;
      _235 = _233 * _139;
      _236 = -0.0f - _233;
      _242 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _246 = srvReflectionsWeight.Load(int3(((uint)(_67) >> _242), ((uint)(_68) >> _242), 0));
      _252 = ((float)((uint)((uint)(_246.x & 254)))) * 0.003921568859368563f;
      if ((_246.x & 1) == 0) {
        _261 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _129), (cbSharedPerViewData.vViewportSize.y * _130)), 0.0f);
        _270 = (1.0f - _252);
        _271 = (_261.x * _252);
        _272 = (_261.y * _252);
        _273 = (_261.z * _252);
      } else {
        _270 = 1.0f;
        _271 = 0.0f;
        _272 = 0.0f;
        _273 = 0.0f;
      }
      _282 = cbSharedPerViewData.vViewportSize.x * (_129 + 0.5f);
      _283 = cbSharedPerViewData.vViewportSize.y * (_130 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _298 = (floor((_282 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _299 = (floor((_283 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _302 = max(_298, cbDeferredShading.vScreenPixelSize.z);
        _303 = max(_299, cbDeferredShading.vScreenPixelSize.w);
        _306 = min((_298 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _307 = min((_299 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _312 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_302 + cbDeferredShading.vScreenPixelSize.z), (_303 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.x) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.y) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.z) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.w) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f)) {
          _346 = abs(_121.x - _312.w);
          _348 = abs(_121.x - _312.z);
          _349 = (_348 < _346);
          _351 = select(_349, _348, _346);
          _353 = abs(_121.x - _312.x);
          _354 = (_353 < _351);
          if (abs(_121.x - _312.y) < select(_354, _353, _351)) {
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
      } else {
        _363 = _282;
        _364 = _283;
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
      if (!_391) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _402 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_363, _364), 0.0f)).x);
        } else {
          _402 = 1.0f;
        }
      } else {
        _402 = 1.0f;
      }
      if (!_391) {
        _406 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
        _407 = (int)(uint)(_406);
        if (_406) {
          _410 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_363, _364), 0.0f);
          _415 = (_410.x * 2.0f) + -1.0f;
          _416 = (_410.y * 2.0f) + -1.0f;
          _420 = (1.0f - abs(_415)) - abs(_416);
          _422 = saturate(-0.0f - _420);
          _423 = -0.0f - _422;
          _428 = select((_415 >= 0.0f), _423, _422) + _415;
          _429 = select((_416 >= 0.0f), _423, _422) + _416;
          _431 = rsqrt(dot(float3(_428, _429, _420), float3(_428, _429, _420)));
          _432 = _428 * _431;
          _433 = _429 * _431;
          _434 = _431 * _420;
          _436 = rsqrt(dot(float3(_432, _433, _434), float3(_432, _433, _434)));
          _441 = _407;
          _442 = (_432 * _436);
          _443 = (_433 * _436);
          _444 = (_436 * _434);
        } else {
          _441 = _407;
          _442 = 0.0f;
          _443 = 0.0f;
          _444 = 0.0f;
        }
      } else {
        _441 = 0;
        _442 = 0.0f;
        _443 = 0.0f;
        _444 = 0.0f;
      }
      _445 = -0.0f - _138;
      _446 = -0.0f - _139;
      _448 = rsqrt(dot(float3(_445, _446, 1.0f), float3(_445, _446, 1.0f)));
      _449 = _448 * _445;
      _450 = _448 * _446;
      _458 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _68) + _67))];
      _459 = _458 & 255;
      _460 = (uint)(_458) >> 8;
      _461 = _460 & 255;
      _465 = ((float)((uint)((uint)(((uint)(_458) >> 16) & 255)))) * 0.003921568859368563f;
      _467 = (float)((uint)((uint)((uint)(_458) >> 24)));
      _468 = _467 * 0.003921568859368563f;
      [branch]
      if (!((((int)(uint((saturate(_146.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _478 = _219 + 0.4000000059604645f;
        _479 = _478 * 4.0f;
        _484 = dot(float3((-0.0f - _449), (-0.0f - _450), (-0.0f - _448)), float3(_200, _202, _204)) * 2.0f;
        _488 = _478 * _478;
        _489 = 1.0f - _488;
        _492 = (sqrt(_489) + _488) * _489;
        _502 = (_492 * ((_201 - _449) - (_484 * _200))) + _200;
        _503 = (_492 * ((_203 - _450) - (_484 * _202))) + _202;
        _504 = (_492 * ((_205 - _448) - (_484 * _204))) + _204;
        _508 = saturate(1.0f - ((_219 + 0.09999999403953552f) * 3.3333332538604736f));
        _523 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _504, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _503, (_502 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _526 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _504, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _503, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _502)));
        _529 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _504, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _503, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _502)));
        _532 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _204, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _202, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _200)));
        _535 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _204, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _202, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _200)));
        _538 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _204, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _202, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _200)));
        if (!(_global_0 == 0)) {
          _557 = 0;
          _558 = 0.0f;
          _559 = 0.0f;
          _560 = 0.0f;
          _561 = 0.0f;
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
          while(true) {
            _849 = _558;
            _850 = _559;
            _851 = _560;
            _852 = _561;
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
            _574 = _global_5[min((uint)(_557), 63u)];
            _575 = _global_6[min((uint)(_557), 63u)];
            _578 = asfloat(srvLightInfoProperties.Load4(_575)).x;
            _579 = asfloat(srvLightInfoProperties.Load4(_575)).y;
            _580 = asfloat(srvLightInfoProperties.Load4(_575)).z;
            _581 = asfloat(srvLightInfoProperties.Load4(_575)).w;
            _584 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 16u)))).x;
            _585 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 16u)))).y;
            _586 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 16u)))).z;
            _587 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 16u)))).w;
            _590 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 32u)))).x;
            _591 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 32u)))).y;
            _592 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 32u)))).z;
            _593 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 32u)))).w;
            _596 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 48u)))).x;
            _597 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 48u)))).y;
            _598 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 48u)))).z;
            _599 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 48u)))).w;
            _602 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 64u)))).x;
            _603 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 64u)))).y;
            _604 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 64u)))).z;
            _605 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 64u)))).w;
            _608 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 80u)))).x;
            _609 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 80u)))).y;
            _610 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 80u)))).z;
            _611 = asfloat(srvLightInfoProperties.Load4(((int)(_575 + 80u)))).w;
            _614 = asint(srvLightInfoProperties.Load(((int)(_575 + 96u))));
            _617 = asfloat(srvLightInfoProperties.Load3(((int)(_575 + 100u)))).x;
            _618 = asfloat(srvLightInfoProperties.Load3(((int)(_575 + 100u)))).y;
            _619 = asfloat(srvLightInfoProperties.Load3(((int)(_575 + 100u)))).z;
            _622 = asfloat(srvLightInfoProperties.Load3(((int)(_575 + 112u)))).x;
            _623 = asfloat(srvLightInfoProperties.Load3(((int)(_575 + 112u)))).y;
            _624 = asfloat(srvLightInfoProperties.Load3(((int)(_575 + 112u)))).z;
            _627 = asint(srvLightInfoProperties.Load(((int)(_575 + 124u))));
            _630 = asint(srvLightInfoProperties.Load(((int)(_575 + 128u))));
            _633 = _614 & 65535;
            _662 = ((saturate(1.0f - abs(mad(_580, _236, mad(_579, _235, (_578 * _234))) + _581)) * f16tof32(((uint)((uint)(_614) >> 16)))) * saturate(1.0f - abs(mad(_586, _236, mad(_585, _235, (_584 * _234))) + _587))) * saturate(1.0f - abs(mad(_592, _236, mad(_591, _235, (_590 * _234))) + _593));
            [branch]
            if (_662 > 0.0f) {
              _665 = _662 * _662;
              [branch]
              if (_508 < 1.0f) {
                _668 = (float)((uint)_633);
                _669 = -0.0f - _523;
                [branch]
                if (!(_668 >= 341.0f)) {
                  _681 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_669, _526, _529, _668), _479);
                  _686 = _681.x;
                  _687 = _681.y;
                  _688 = _681.z;
                } else {
                  _675 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_669, _526, _529, (_668 + -341.0f)), _479);
                  _686 = _675.x;
                  _687 = _675.y;
                  _688 = _675.z;
                }
              } else {
                _686 = 0.0f;
                _687 = 0.0f;
                _688 = 0.0f;
              }
              _690 = (float)((uint)_633);
              [branch]
              if (_508 > 0.0f) {
                _694 = mad(_598, _504, mad(_597, _503, (_596 * _502)));
                _697 = mad(_604, _504, mad(_603, _503, (_602 * _502)));
                _700 = mad(_610, _504, mad(_609, _503, (_608 * _502)));
                _741 = min(((((float((int)(((int)(uint)((int)(_694 > 0.0f))) - ((int)(uint)((int)(_694 < 0.0f))))) * _617) - _599) - mad(_598, _236, mad(_597, _235, (_596 * _234)))) / _694), min(((((float((int)(((int)(uint)((int)(_697 > 0.0f))) - ((int)(uint)((int)(_697 < 0.0f))))) * _618) - _605) - mad(_604, _236, mad(_603, _235, (_602 * _234)))) / _697), ((((float((int)(((int)(uint)((int)(_700 > 0.0f))) - ((int)(uint)((int)(_700 < 0.0f))))) * _619) - _611) - mad(_610, _236, mad(_609, _235, (_608 * _234)))) / _700)));
                _746 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _235, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _622) + (_741 * _523);
                _748 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _235, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _623) + (_741 * _526);
                _750 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _235, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _624) + (_741 * _529);
                _757 = (max(log2((_741 * _741) / dot(float3(_746, _748, _750), float3(_746, _748, _750))), -1.0f) * 0.3333333432674408f) + _479;
                _758 = -0.0f - _746;
                [branch]
                if (!(_690 >= 341.0f)) {
                  _770 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_758, _748, _750, _690), _757);
                  _775 = _770.x;
                  _776 = _770.y;
                  _777 = _770.z;
                } else {
                  _764 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_758, _748, _750, (_690 + -341.0f)), _757);
                  _775 = _764.x;
                  _776 = _764.y;
                  _777 = _764.z;
                }
              } else {
                _775 = 0.0f;
                _776 = 0.0f;
                _777 = 0.0f;
              }
              _778 = -0.0f - _532;
              [branch]
              if (!(_690 >= 341.0f)) {
                _790 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_778, _535, _538, _690), 0.0f);
                _795 = _790.x;
                _796 = _790.y;
                _797 = _790.z;
              } else {
                _784 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_778, _535, _538, (_690 + -341.0f)), 0.0f);
                _795 = _784.x;
                _796 = _784.y;
                _797 = _784.z;
              }
              _807 = _665 * f16tof32(((uint)((uint)(_627) >> 16)));
              _808 = _807 * _795;
              _809 = _665 * f16tof32(_627);
              _810 = _809 * _796;
              _811 = _665 * f16tof32(((uint)((uint)(_630) >> 16)));
              _812 = _811 * _797;
              _813 = _807 * (lerp(_686, _775, _508));
              _814 = _809 * (lerp(_687, _776, _508));
              _815 = _811 * (lerp(_688, _777, _508));
              [branch]
              if (!((_574 & ((int)(1 << (_458 & 31)))) == 0)) {
                _829 = (_808 + _558);
                _830 = (_810 + _559);
                _831 = (_812 + _560);
                _832 = (_813 + _561);
                _833 = (_814 + _562);
                _834 = (_815 + _563);
                _835 = (_665 + _564);
              } else {
                _829 = _558;
                _830 = _559;
                _831 = _560;
                _832 = _561;
                _833 = _562;
                _834 = _563;
                _835 = _564;
              }
              [branch]
              if (!((_574 & ((int)(1 << (_460 & 31)))) == 0)) {
                _849 = _829;
                _850 = _830;
                _851 = _831;
                _852 = _832;
                _853 = _833;
                _854 = _834;
                _855 = _835;
                _856 = (_808 + _565);
                _857 = (_810 + _566);
                _858 = (_812 + _567);
                _859 = (_813 + _568);
                _860 = (_814 + _569);
                _861 = (_815 + _570);
                _862 = (_665 + _571);
              } else {
                _849 = _829;
                _850 = _830;
                _851 = _831;
                _852 = _832;
                _853 = _833;
                _854 = _834;
                _855 = _835;
                _856 = _565;
                _857 = _566;
                _858 = _567;
                _859 = _568;
                _860 = _569;
                _861 = _570;
                _862 = _571;
              }
            } else {
              _849 = _558;
              _850 = _559;
              _851 = _560;
              _852 = _561;
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
            }
            _863 = _557 + 1u;
            if (!(_863 == _global_0)) {
              _557 = _863;
              _558 = _849;
              _559 = _850;
              _560 = _851;
              _561 = _852;
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
              continue;
            }
            _867 = _849;
            _868 = _850;
            _869 = _851;
            _870 = _852;
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
            break;
          }
        } else {
          _867 = 0.0f;
          _868 = 0.0f;
          _869 = 0.0f;
          _870 = 0.0f;
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
        }
        _886 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_458 & 31)))) != 0);
        if ((_465 > 0.0f) || ((_468 > 0.0f) || _886)) {
          _896 = srvFallbackInfo[((_459 << 2) | 3)].x;
          _898 = select(_886, 9.999999747378752e-05f, (_467 * 3.921568847431445e-09f));
          _899 = _873 * 0.20000000298023224f;
          _906 = saturate((_898 - _899) / (((_873 * 0.4000000059604645f) + 9.99999993922529e-09f) - _899)) * _898;
          [branch]
          if (_906 > 0.0f) {
            [branch]
            if ((int)_896 > (int)-1) {
              _911 = float((int)(_896));
              _912 = -0.0f - _523;
              _913 = !(_911 >= 341.0f);
              [branch]
              if (_913) {
                _924 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_912, _526, _529, _911), _479);
                _929 = _924.x;
                _930 = _924.y;
                _931 = _924.z;
              } else {
                _918 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_912, _526, _529, (_911 + -341.0f)), _479);
                _929 = _918.x;
                _930 = _918.y;
                _931 = _918.z;
              }
              _935 = -0.0f - _532;
              [branch]
              if (_913) {
                _946 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_935, _535, _538, _911), 0.0f);
                _951 = _946.x;
                _952 = _946.y;
                _953 = _946.z;
              } else {
                _940 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_935, _535, _538, (_911 + -341.0f)), 0.0f);
                _951 = _940.x;
                _952 = _940.y;
                _953 = _940.z;
              }
              _964 = ((_929 * _906) + _870);
              _965 = ((_930 * _906) + _871);
              _966 = ((_931 * _906) + _872);
              _967 = ((_951 * _906) + _867);
              _968 = ((_952 * _906) + _868);
              _969 = ((_953 * _906) + _869);
            } else {
              _964 = _870;
              _965 = _871;
              _966 = _872;
              _967 = _867;
              _968 = _868;
              _969 = _869;
            }
            _972 = (_906 + _873);
            _973 = _964;
            _974 = _965;
            _975 = _966;
            _976 = _967;
            _977 = _968;
            _978 = _969;
          } else {
            _972 = _873;
            _973 = _870;
            _974 = _871;
            _975 = _872;
            _976 = _867;
            _977 = _868;
            _978 = _869;
          }
          if (_972 > 0.0f) {
            _984 = (cbSharedPerViewData.vHDRScale.x * _465) / _972;
            _992 = (_984 * _976);
            _993 = (_984 * _977);
            _994 = (_984 * _978);
            _995 = (_984 * _973);
            _996 = (_984 * _974);
            _997 = (_984 * _975);
          } else {
            _992 = 0.0f;
            _993 = 0.0f;
            _994 = 0.0f;
            _995 = 0.0f;
            _996 = 0.0f;
            _997 = 0.0f;
          }
        } else {
          _992 = 0.0f;
          _993 = 0.0f;
          _994 = 0.0f;
          _995 = 0.0f;
          _996 = 0.0f;
          _997 = 0.0f;
        }
        [branch]
        if (!(_468 == 0.0f)) {
          _1004 = srvFallbackInfo[((_461 << 2) | 3)].x;
          _1005 = _467 * 3.921568847431445e-09f;
          [branch]
          if ((int)_1004 > (int)-1) {
            _1008 = float((int)(_1004));
            _1009 = -0.0f - _523;
            _1010 = !(_1008 >= 341.0f);
            [branch]
            if (_1010) {
              _1021 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1009, _526, _529, _1008), _479);
              _1026 = _1021.x;
              _1027 = _1021.y;
              _1028 = _1021.z;
            } else {
              _1015 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1009, _526, _529, (_1008 + -341.0f)), _479);
              _1026 = _1015.x;
              _1027 = _1015.y;
              _1028 = _1015.z;
            }
            _1032 = -0.0f - _532;
            [branch]
            if (_1010) {
              _1043 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1032, _535, _538, _1008), 0.0f);
              _1048 = _1043.x;
              _1049 = _1043.y;
              _1050 = _1043.z;
            } else {
              _1037 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1032, _535, _538, (_1008 + -341.0f)), 0.0f);
              _1048 = _1037.x;
              _1049 = _1037.y;
              _1050 = _1037.z;
            }
            _1061 = ((_1026 * _1005) + _877);
            _1062 = ((_1027 * _1005) + _878);
            _1063 = ((_1028 * _1005) + _879);
            _1064 = ((_1048 * _1005) + _874);
            _1065 = ((_1049 * _1005) + _875);
            _1066 = ((_1050 * _1005) + _876);
          } else {
            _1061 = _877;
            _1062 = _878;
            _1063 = _879;
            _1064 = _874;
            _1065 = _875;
            _1066 = _876;
          }
          _1071 = (cbSharedPerViewData.vHDRScale.x * _468) / (_880 + _1005);
          _1085 = ((_1071 * _1064) + _992);
          _1086 = ((_1071 * _1065) + _993);
          _1087 = ((_1071 * _1066) + _994);
          _1088 = ((_1071 * _1061) + _995);
          _1089 = ((_1071 * _1062) + _996);
          _1090 = ((_1071 * _1063) + _997);
          _1091 = _478;
        } else {
          _1085 = _992;
          _1086 = _993;
          _1087 = _994;
          _1088 = _995;
          _1089 = _996;
          _1090 = _997;
          _1091 = _478;
        }
      } else {
        _1085 = 0.0f;
        _1086 = 0.0f;
        _1087 = 0.0f;
        _1088 = 0.0f;
        _1089 = 0.0f;
        _1090 = 0.0f;
        _1091 = _219;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1110 = (min((_384 / max(9.999999747378752e-05f, _1085)), 1.0f) * _1088);
        _1111 = (min((_386 / max(9.999999747378752e-05f, _1086)), 1.0f) * _1089);
        _1112 = (min((_388 / max(9.999999747378752e-05f, _1087)), 1.0f) * _1090);
      } else {
        _1110 = _1088;
        _1111 = _1089;
        _1112 = _1090;
      }
      _1125 = saturate(dot(float3(_449, _450, _448), float3(_200, _202, _204)));
      _1128 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1125, _1091), 0.0f);
      _1131 = _1128.x + _1128.y;
      _1136 = (((1.0f - _1131) * _213) / max(9.999999747378752e-06f, _1131)) + 1.0f;
      _1138 = (_1128.x * _213) + _1128.y;
      _1139 = min((_226 * _226), _402);
      if (!(_global_1 == 0)) {
        _1143 = 0;
        _1144 = _1139;
        while(true) {
          _1262 = _1144;
          _1145 = _1143 + (uint)(_global_0);
          _1148 = _global_5[min((uint)(_1145), 63u)];
          _1149 = _global_6[min((uint)(_1145), 63u)];
          _1153 = (int)((int)(_1148 << (((int)(31u - _458)) & 31))) >> 31;
          _1157 = (int)((int)(_1148 << ((31 - _460) & 31))) >> 31;
          _1169 = saturate((asfloat((_1153 & asint(_465))) + asfloat((_1157 & asint(_468)))) + asfloat(((_1157 & 1065353216) & _1153)));
          [branch]
          if (!(_1169 == 0.0f)) {
            _1174 = asfloat(srvLightInfoProperties.Load4(_1149)).x;
            _1175 = asfloat(srvLightInfoProperties.Load4(_1149)).y;
            _1176 = asfloat(srvLightInfoProperties.Load4(_1149)).z;
            _1177 = asfloat(srvLightInfoProperties.Load4(_1149)).w;
            _1180 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 16u)))).x;
            _1181 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 16u)))).y;
            _1182 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 16u)))).z;
            _1183 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 16u)))).w;
            _1186 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 32u)))).x;
            _1187 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 32u)))).y;
            _1188 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 32u)))).z;
            _1189 = asfloat(srvLightInfoProperties.Load4(((int)(_1149 + 32u)))).w;
            _1192 = asint(srvLightInfoProperties.Load(((int)(_1149 + 48u))));
            _1195 = asint(srvLightInfoProperties.Load(((int)(_1149 + 52u))));
            _1198 = asint(srvLightInfoProperties.Load(((int)(_1149 + 56u))));
            _1201 = asint(srvLightInfoProperties.Load(((int)(_1149 + 60u))));
            _1216 = mad(_1176, _236, mad(_1175, _235, (_1174 * _234))) + _1177;
            _1220 = mad(_1182, _236, mad(_1181, _235, (_1180 * _234))) + _1183;
            _1224 = mad(_1188, _236, mad(_1187, _235, (_1186 * _234))) + _1189;
            _1249 = saturate(1.0f - ((_1216 + 1.0f) * f16tof32(_1195))) + saturate(1.0f - ((1.0f - _1216) * f16tof32(((uint)((uint)(_1195) >> 16)))));
            _1250 = saturate(1.0f - ((_1220 + 1.0f) * f16tof32(_1198))) + saturate(1.0f - ((1.0f - _1220) * f16tof32(((uint)((uint)(_1198) >> 16)))));
            _1251 = saturate(1.0f - ((_1224 + 1.0f) * f16tof32(_1201))) + saturate(1.0f - ((1.0f - _1224) * f16tof32(((uint)((uint)(_1201) >> 16)))));
            _1254 = saturate(1.0f - dot(float3(_1249, _1250, _1251), float3(_1249, _1250, _1251)));
            _1262 = (saturate(1.0f - ((_1254 * _1254) * (f16tof32(((uint)((uint)(_1192) >> 16))) * _1169))) * _1144);
          } else {
            _1262 = _1144;
          }
          _1263 = _1143 + 1u;
          if (!(_1263 == _global_1)) {
            _1143 = _1263;
            _1144 = _1262;
            continue;
          }
          _1267 = _1262;
          break;
        }
      } else {
        _1267 = _1139;
      }
      _1271 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
      if (_1271) {
        _1283 = saturate((_1267 + -1.0f) + exp2((_1091 * _1091) * log2(max((_1267 + _1125), 0.0f))));
      } else {
        _1283 = _1267;
      }
      _1286 = max(9.999999747378752e-06f, max(_170, max(_168, _169)));
      if (!(_441 == 0)) {
        _1304 = rsqrt(dot(float3(_442, _443, _444), float3(_442, _443, _444)));
        _1306 = rsqrt(dot(float3(_200, _202, _204), float3(_200, _202, _204)));
        _1307 = _1306 * _200;
        _1308 = _1306 * _202;
        _1309 = _1306 * _204;
        if (_1271) {
          _1314 = max(_1091, 0.10000000149011612f);
          _1315 = -0.0f - _449;
          _1316 = -0.0f - _450;
          _1317 = -0.0f - _448;
          _1319 = dot(float3(_1315, _1316, _1317), float3(_1307, _1308, _1309)) * 2.0f;
          _1328 = min(max(dot(float3((_1304 * _442), (_1304 * _443), (_1304 * _444)), float3((_1315 - (_1319 * _1307)), (_1316 - (_1319 * _1308)), (_1317 - (_1319 * _1309)))), -1.0f), 1.0f);
          _1329 = abs(_1328);
          _1334 = (1.5707963705062866f - (_1329 * 0.1565829962491989f)) * sqrt(1.0f - _1329);
          _1340 = abs((_1314 - _1267) * 3.1415927410125732f);
          _1348 = saturate(1.0f - saturate((select((_1328 >= 0.0f), _1334, (3.1415927410125732f - _1334)) - _1340) / (((_1314 + _1267) * 3.1415927410125732f) - _1340)));
          _1358 = (((_1348 * _1348) * saturate((_1267 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1348 * 2.0f)));
        } else {
          _1358 = _1267;
        }
      } else {
        _1358 = _1283;
      }
      _1362 = (((_1136 * ((cbSharedPerViewData.vHDRScale.x * _271) + (_1110 * _270))) * _1138) * (((saturate(_168 / _1286) + -1.0f) * 0.5f) + 1.0f)) * _1358;
      _1366 = (((_1138 * ((cbSharedPerViewData.vHDRScale.x * _272) + (_1111 * _270))) * _1136) * (((saturate(_169 / _1286) + -1.0f) * 0.5f) + 1.0f)) * _1358;
      _1370 = (((_1138 * ((cbSharedPerViewData.vHDRScale.x * _273) + (_1112 * _270))) * _1136) * (((saturate(_170 / _1286) + -1.0f) * 0.5f) + 1.0f)) * _1358;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1377 = _1267;
      } else {
        _1377 = 1.0f;
      }
      if (_465 > 0.0f) {
        _1380 = _459 * 3;
        _1383 = srvRoomInfo[_1380].x;
        _1384 = srvRoomInfo[_1380].y;
        _1385 = srvRoomInfo[_1380].z;
        _1391 = srvRoomInfo[(_1380 + 1)].x;
        _1392 = srvRoomInfo[(_1380 + 1)].y;
        _1393 = srvRoomInfo[(_1380 + 1)].z;
        _1399 = srvRoomInfo[(_1380 + 2)].x;
        _1400 = srvRoomInfo[(_1380 + 2)].y;
        _1401 = srvRoomInfo[(_1380 + 2)].z;
        _1407 = saturate(dot(float3(_200, _202, _204), float3(asfloat(_1383), asfloat(_1384), asfloat(_1385))) + 0.5f);
        _1411 = (_1407 * _1407) * (3.0f - (_1407 * 2.0f));
        _1415 = 1.0f - _1411;
        _1422 = _1377 * _465;
        _1430 = ((_1422 * ((_1415 * asfloat(_1399)) + (_1411 * asfloat(_1391)))) - _383);
        _1431 = ((_1422 * ((_1415 * asfloat(_1400)) + (_1411 * asfloat(_1392)))) - _385);
        _1432 = ((_1422 * ((_1415 * asfloat(_1401)) + (_1411 * asfloat(_1393)))) - _387);
      } else {
        _1430 = _384;
        _1431 = _386;
        _1432 = _388;
      }
      if (_468 > 0.0f) {
        _1435 = _461 * 3;
        _1438 = srvRoomInfo[_1435].x;
        _1439 = srvRoomInfo[_1435].y;
        _1440 = srvRoomInfo[_1435].z;
        _1446 = srvRoomInfo[(_1435 + 1)].x;
        _1447 = srvRoomInfo[(_1435 + 1)].y;
        _1448 = srvRoomInfo[(_1435 + 1)].z;
        _1454 = srvRoomInfo[(_1435 + 2)].x;
        _1455 = srvRoomInfo[(_1435 + 2)].y;
        _1456 = srvRoomInfo[(_1435 + 2)].z;
        _1462 = saturate(dot(float3(_200, _202, _204), float3(asfloat(_1438), asfloat(_1439), asfloat(_1440))) + 0.5f);
        _1466 = (_1462 * _1462) * (3.0f - (_1462 * 2.0f));
        _1470 = 1.0f - _1466;
        _1477 = _1377 * _468;
        _1485 = ((_1477 * ((_1470 * asfloat(_1454)) + (_1466 * asfloat(_1446)))) + _1430);
        _1486 = ((_1477 * ((_1470 * asfloat(_1455)) + (_1466 * asfloat(_1447)))) + _1431);
        _1487 = ((_1477 * ((_1470 * asfloat(_1456)) + (_1466 * asfloat(_1448)))) + _1432);
      } else {
        _1485 = _1430;
        _1486 = _1431;
        _1487 = _1432;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1510 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _235, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1514 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _235, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1518 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _235, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1537 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1518, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1514, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1510))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1541 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1518, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1514, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1510))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1545 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1518, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1514, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1510))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1558 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1559 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1560 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1597 = min(min(saturate((_1537 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1558), 9.999999747378752e-06f)), saturate((1.0f - _1537) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1558), 9.999999747378752e-06f))), min(min(saturate((_1541 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1559), 9.999999747378752e-06f)), saturate((1.0f - _1541) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1559), 9.999999747378752e-06f))), min(saturate((_1545 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1560), 9.999999747378752e-06f)), saturate((1.0f - _1545) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1560), 9.999999747378752e-06f)))));
      } else {
        _1597 = 0.0f;
      }
      _1598 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1598 < (uint)_global_2) {
        _1602 = _1485;
        _1603 = _1486;
        _1604 = _1487;
        _1605 = _1362;
        _1606 = _1366;
        _1607 = _1370;
        _1608 = _1598;
        while(true) {
          _9575 = _1602;
          _9576 = _1603;
          _9577 = _1604;
          _9578 = _1605;
          _9579 = _1606;
          _9580 = _1607;
          _1610 = _global_3[min((uint)(_1608), 63u)];
          _1614 = _global_4[min((uint)(_1608), 63u)];
          _1615 = _global_5[min((uint)(_1608), 63u)];
          _1616 = _global_6[min((uint)(_1608), 63u)];
          _1617 = _1610 & 4095;
          [branch]
          if (((((int)(uint(saturate(_156.w) * 255.0f)) & 64) != 0) || ((_1614 & 8388608) == 0)) && (((int)(uint((saturate(_156.z) * 1.9921875f) + 0.003921568859368563f)) != 0) || ((_1614 & 16777216) == 0))) {
            _1629 = (int)((int)(_1615 << (((int)(31u - _458)) & 31))) >> 31;
            _1633 = (int)((int)(_1615 << ((31 - _460) & 31))) >> 31;
            _1645 = saturate((asfloat((_1629 & asint(_465))) + asfloat((_1633 & asint(_468)))) + asfloat(((_1633 & 1065353216) & _1629)));
            [branch]
            if (!(_1645 == 0.0f)) {
              _1648 = (uint)(_1610) >> 12;
              if (_1648 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _3386 = (_1645 * select(((_1614 & 67108864) != 0), 1.0f, (1.0f - _1597)));
                } else {
                  _3386 = _1645;
                }
                _3389 = asfloat(srvLightInfoProperties.Load4(_1616)).x;
                _3390 = asfloat(srvLightInfoProperties.Load4(_1616)).y;
                _3391 = asfloat(srvLightInfoProperties.Load4(_1616)).z;
                _3392 = asfloat(srvLightInfoProperties.Load4(_1616)).w;
                _3395 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).x;
                _3396 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).y;
                _3397 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).z;
                _3398 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).w;
                _3401 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).x;
                _3402 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).y;
                _3403 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).z;
                _3406 = asint(srvLightInfoProperties.Load(((int)(_1616 + 68u))));
                _3409 = asint(srvLightInfoProperties.Load(((int)(_1616 + 76u))));
                _3412 = asint(srvLightInfoProperties.Load(((int)(_1616 + 84u))));
                _3415 = asint(srvLightInfoProperties.Load(((int)(_1616 + 88u))));
                _3418 = asint(srvLightInfoProperties.Load(((int)(_1616 + 92u))));
                _3422 = ((float)((uint)((uint)(((uint)(_3406) >> 8) & 255)))) * 0.003921499941498041f;
                _3423 = (uint)(_3409) >> 16;
                _3443 = srvDeferredShadingPass_DeferredShadows.Load(int3(_67, _68, 0));
                [branch]
                if (!(_3443.x == 0.0f)) {
                  [branch]
                  if (!(_3423 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3423)))];
                    _3460 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3391, _236, mad(_3390, _235, (_3389 * _234))) + _3392) * f16tof32(((uint)((uint)(_3415) >> 16)))) + f16tof32(((uint)((uint)(_3418) >> 16)))), (((mad(_3397, _236, mad(_3396, _235, (_3395 * _234))) + _3398) * f16tof32(_3415)) + f16tof32(_3418))), 0.0f);
                    _3468 = (_3460.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _3469 = (_3460.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _3470 = (_3460.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _3468 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _3469 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _3470 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  _3473 = min(_3443.x, _3443.y) * _3386;
                  [branch]
                  if (_3473 > 0.0f) {
                    _3477 = rsqrt(dot(float3(_3401, _3402, _3403), float3(_3401, _3402, _3403)));
                    _3478 = _3477 * _3401;
                    _3479 = _3477 * _3402;
                    _3480 = _3477 * _3403;
                    _3481 = dot(float3(_200, _202, _204), float3(_3478, _3479, _3480));
                    _3482 = saturate(_3481);
                    _3485 = uint((_180 * 255.0f) + 0.5f);
                    _3494 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                    _3495 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                    _3496 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                    _3512 = ((dot(float3(_201, _203, _205), float3(_3478, _3479, _3480)) + dot(float3((-0.0f - _449), (-0.0f - _450), (-0.0f - _448)), float3(_3478, _3479, _3480))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_200, _202, _204), float3(_449, _450, _448)))) * (11.0f - (((float)((uint)((uint)((uint)(_3485) >> 2)))) * 0.1666666716337204f)));
                    _3519 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                    _3522 = saturate((_3519 + -0.009999999776482582f) * -100.0f);
                    _3527 = ((_3522 * _3522) * 3.0f) * (3.0f - (_3522 * 2.0f));
                    _3534 = 10.0f - (exp2(log2(saturate(_3519 * 5.0f)) * 3.0f) * 9.0f);
                    _3535 = saturate(_3482 + _3494) * _3482;
                    _3536 = saturate(_3482 + _3495) * _3482;
                    _3537 = saturate(_3482 + _3496) * _3482;
                    _3559 = _3478 + _449;
                    _3560 = _3479 + _450;
                    _3561 = _3480 + _448;
                    _3563 = rsqrt(dot(float3(_3559, _3560, _3561), float3(_3559, _3560, _3561)));
                    if (!(select(((_222 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                      _3578 = rsqrt(dot(float3(_200, _202, _204), float3(_200, _202, _204)));
                      _3579 = _3578 * _200;
                      _3580 = _3578 * _202;
                      _3581 = _3578 * _204;
                      _3584 = (abs(_3579) < abs(_3580));
                      _3585 = select(_3584, 1.0f, 0.0f);
                      _3586 = select(_3584, 0.0f, 1.0f);
                      _3587 = _3586 * _3581;
                      _3589 = -0.0f - (_3581 * _3585);
                      _3592 = (_3585 * _3580) - (_3586 * _3579);
                      _3594 = rsqrt(dot(float3(_3587, _3589, _3592), float3(_3587, _3589, _3592)));
                      _3595 = _3587 * _3594;
                      _3596 = _3594 * _3589;
                      _3597 = _3592 * _3594;
                      _3600 = (_3596 * _3581) - (_3597 * _3580);
                      _3603 = (_3597 * _3579) - (_3595 * _3581);
                      _3606 = (_3595 * _3580) - (_3596 * _3579);
                      _3608 = rsqrt(dot(float3(_3600, _3603, _3606), float3(_3600, _3603, _3606)));
                      _3612 = _178 * 4.0f;
                      _3621 = saturate(abs(_3612 + -2.5f) + -0.5f) + -0.5f;
                      _3622 = saturate(1.5f - abs(_3612 + -1.5f)) + -0.5f;
                      _3624 = rsqrt(dot(float2(_3621, _3622), float2(_3621, _3622)));
                      _3625 = _3624 * _3621;
                      _3626 = _3624 * _3622;
                      _3633 = ((_3600 * _3608) * _3625) + (_3626 * _3595);
                      _3634 = ((_3603 * _3608) * _3625) + (_3626 * _3596);
                      _3635 = ((_3606 * _3608) * _3625) + (_3626 * _3597);
                      _3636 = dot(float3(_449, _450, _448), float3(_3478, _3479, _3480));
                      _3639 = min(max(dot(float3(_3633, _3634, _3635), float3(_3478, _3479, _3480)), -1.0f), 1.0f);
                      _3642 = min(max(dot(float3(_3633, _3634, _3635), float3(_449, _450, _448)), -1.0f), 1.0f);
                      _3643 = abs(_3642);
                      _3648 = (1.5707963705062866f - (_3643 * 0.1565829962491989f)) * sqrt(1.0f - _3643);
                      _3652 = abs(_3639);
                      _3657 = (1.5707963705062866f - (_3652 * 0.1565829962491989f)) * sqrt(1.0f - _3652);
                      _3664 = cos(abs(select((_3639 >= 0.0f), _3657, (3.1415927410125732f - _3657)) - select((_3642 >= 0.0f), _3648, (3.1415927410125732f - _3648))) * 0.5f);
                      _3668 = _3478 - (_3639 * _3633);
                      _3669 = _3479 - (_3639 * _3634);
                      _3670 = _3480 - (_3639 * _3635);
                      _3674 = _449 - (_3642 * _3633);
                      _3675 = _450 - (_3642 * _3634);
                      _3676 = _448 - (_3642 * _3635);
                      _3683 = rsqrt((dot(float3(_3674, _3675, _3676), float3(_3674, _3675, _3676)) * dot(float3(_3668, _3669, _3670), float3(_3668, _3669, _3670))) + 9.999999747378752e-05f) * dot(float3(_3668, _3669, _3670), float3(_3674, _3675, _3676));
                      _3687 = sqrt(saturate((_3683 * 0.5f) + 0.5f));
                      _3691 = _219 * _219;
                      _3692 = _3691 * 0.5f;
                      _3693 = _3691 * 2.0f;
                      _3696 = select((((_3485 & 1) != 0) && (select(((_3485 & 2) != 0), 1.0f, 0.0f) == 0.0f)), 0.0f, 1.0f);
                      _3699 = saturate((_3481 + 0.5f) * 0.6666666865348816f);
                      _3709 = (_3642 + _3639) + ((((_3687 * 0.9975510239601135f) * sqrt(1.0f - (_3642 * _3642))) - (_3642 * 0.06994284689426422f)) * 0.13988569378852844f);
                      _3711 = (_3691 * 1.4142135381698608f) * _3687;
                      _3724 = 1.0f - sqrt(saturate((_3636 * 0.5f) + 0.5f));
                      _3725 = _3724 * _3724;
                      _3731 = saturate(-0.0f - _3636);
                      _3734 = (1.0f - saturate(_3731)) * _3699;
                      _3743 = ((((_3687 * 0.5f) * (exp2((((_3709 * _3709) * -0.5f) / (_3711 * _3711)) * 1.4426950216293335f) / (_3711 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_3725 * _3725) * (_3724 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3734, 1.0f, _3696));
                      _3745 = (_3639 + -0.03500000014901161f) + _3642;
                      _3754 = 1.0f / ((1.190000057220459f / _3664) + (_3664 * 0.36000001430511475f));
                      _3759 = ((_3754 * (0.6000000238418579f - (_3683 * 0.800000011920929f))) + 1.0f) * _3687;
                      _3765 = 1.0f - (sqrt(saturate(1.0f - (_3759 * _3759))) * _3664);
                      _3766 = _3765 * _3765;
                      _3770 = 0.9534794092178345f - ((_3766 * _3766) * (_3765 * 0.9534794092178345f));
                      _3771 = _3759 * _3754;
                      _3776 = (sqrt(1.0f - (_3771 * _3771)) * 0.5f) / _3664;
                      _3795 = 1.0f - saturate((_3731 + -0.44999998807907104f) * 2.222222328186035f);
                      _3798 = ((1.0f - _3699) * _3696) + _3699;
                      _3801 = ((_3770 * _3770) * (exp2((((_3745 * _3745) * -0.5f) / (_3692 * _3692)) * 1.4426950216293335f) / (_3691 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3683 * 5.2658371925354f));
                      _3815 = (_3639 + -0.14000000059604645f) + _3642;
                      _3825 = 1.0f - (_3664 * 0.5f);
                      _3826 = _3825 * _3825;
                      _3830 = (_3826 * _3826) * (0.9534794092178345f - (_3664 * 0.47673970460891724f));
                      _3832 = 0.9534794092178345f - _3830;
                      _3834 = (_3832 * _3832) * (_3830 + 0.04652056470513344f);
                      _3837 = exp2((_3683 * 24.525815963745117f) + -24.208423614501953f);
                      _3850 = ((exp2((((_3815 * _3815) * -0.5f) / (_3693 * _3693)) * 1.4426950216293335f) / (_3691 * 5.013256549835205f)) * (lerp(_3834, 1.0f, _172))) * (((exp2((saturate(dot(float3((_3563 * _3559), (_3563 * _3560), (_3563 * _3561)), float3(_200, _202, _204))) * 17.312339782714844f) + -14.109557151794434f) - _3837) * _172) + _3837);
                      _3858 = (((((exp2(log2(max(_168, 0.0f)) * _3776) * _3798) * _3801) * _3795) + _3743) + (_3850 * _168));
                      _3859 = (((((exp2(log2(max(_169, 0.0f)) * _3776) * _3798) * _3801) * _3795) + _3743) + (_3850 * _169));
                      _3860 = (((((exp2(log2(max(_170, 0.0f)) * _3776) * _3798) * _3801) * _3795) + _3743) + (_3850 * _170));
                    } else {
                      _3858 = 0.0f;
                      _3859 = 0.0f;
                      _3860 = 0.0f;
                    }
                    [branch]
                    if (!((_3412 & 1) == 0)) {
                      _3873 = max(max(_3468, _3469), _3470);
                      if (_3873 > 0.0f) {
                        _3883 = saturate(_3468 / _3873);
                        _3884 = saturate(_3469 / _3873);
                        _3885 = saturate(_3470 / _3873);
                      } else {
                        _3883 = _3468;
                        _3884 = _3469;
                        _3885 = _3470;
                      }
                      _3886 = (_3884 < _3885);
                      _3887 = select(_3886, _3885, _3884);
                      _3888 = select(_3886, _3884, _3885);
                      _3889 = select(_3886, -1.0f, 0.0f);
                      _3890 = (_3883 < _3887);
                      _3892 = select(_3890, _3887, _3883);
                      _3893 = select(_3890, _3883, _3887);
                      _3897 = _3892 - select((_3893 < _3888), _3893, _3888);
                      _3903 = abs(select(_3890, (-0.3333333432674408f - _3889), _3889) + ((_3893 - _3888) / ((_3897 * 6.0f) + 9.999999682655225e-21f)));
                      if (_3903 < 0.6666666865348816f) {
                        _3916 = ((saturate(((float)((uint)((uint)(((uint)(_3412) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3903 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3903)) + _3903);
                      } else {
                        _3916 = _3903;
                      }
                      _3917 = saturate((_3897 / (_3892 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3412) >> 1) & 255)))) * 0.003921499941498041f));
                      _3918 = saturate(_3892);
                      if (!(_3917 <= 0.0f)) {
                        _3921 = saturate(_3916);
                        _3925 = select(((_3921 * 360.0f) >= 360.0f), 0.0f, (_3921 * 6.0f));
                        _3926 = int(_3925);
                        _3928 = _3925 - float((int)(_3926));
                        _3930 = _3918 * (1.0f - _3917);
                        _3933 = (1.0f - (_3928 * _3917)) * _3918;
                        _3937 = (1.0f - ((1.0f - _3928) * _3917)) * _3918;
                        switch (_3926) {
                          case 0: {
                            _3945 = _3918;
                            _3946 = _3937;
                            _3947 = _3930;
                            break;
                          }
                          case 1: {
                            _3945 = _3933;
                            _3946 = _3918;
                            _3947 = _3930;
                            break;
                          }
                          case 2: {
                            _3945 = _3930;
                            _3946 = _3918;
                            _3947 = _3937;
                            break;
                          }
                          case 3: {
                            _3945 = _3930;
                            _3946 = _3933;
                            _3947 = _3918;
                            break;
                          }
                          case 4: {
                            _3945 = _3937;
                            _3946 = _3930;
                            _3947 = _3918;
                            break;
                          }
                          case 5: {
                            _3945 = _3918;
                            _3946 = _3930;
                            _3947 = _3933;
                            break;
                          }
                          default: {
                            _3945 = 0.0f;
                            _3946 = 0.0f;
                            _3947 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _3945 = _3918;
                        _3946 = _3918;
                        _3947 = _3918;
                      }
                      _3948 = _3945 * _3873;
                      _3949 = _3946 * _3873;
                      _3950 = _3947 * _3873;
                      _3952 = saturate(_3473 * 1.0101009607315063f);
                      _3963 = ((_3952 * (_3468 - _3948)) + _3948);
                      _3964 = ((_3952 * (_3469 - _3949)) + _3949);
                      _3965 = (lerp(_3950, _3470, _3952));
                    } else {
                      _3963 = _3468;
                      _3964 = _3469;
                      _3965 = _3470;
                    }
                    _3966 = _3963 * _3473;
                    _3967 = _3964 * _3473;
                    _3968 = _3965 * _3473;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _3978 = (_3966 * _1267);
                      _3979 = (_3967 * _1267);
                      _3980 = (_3968 * _1267);
                    } else {
                      _3978 = _3966;
                      _3979 = _3967;
                      _3980 = _3968;
                    }
                    _3984 = (_3978 * ((max(((_3527 + _3494) * _3512), 0.0f) * _3534) + sqrt(_3535 * _3535))) + _1602;
                    _3985 = (_3979 * ((max(((_3527 + _3495) * _3512), 0.0f) * _3534) + sqrt(_3536 * _3536))) + _1603;
                    _3986 = (_3980 * ((max(((_3527 + _3496) * _3512), 0.0f) * _3534) + sqrt(_3537 * _3537))) + _1604;
                    if (_3422 > 0.0f) {
                      _4000 = (_3422 * _1358) * ((float)((bool)(uint)(((srvContactShadowsCSMMask.SampleLevel(samplerPointClampNode, float2((cbSharedPerViewData.vViewportSize.x * _129), (cbSharedPerViewData.vViewportSize.y * _130)), 0.0f)).x) == 1.0f)));
                      _9575 = _3984;
                      _9576 = _3985;
                      _9577 = _3986;
                      _9578 = (((_3978 * _3858) * _4000) + _1605);
                      _9579 = (((_3979 * _3859) * _4000) + _1606);
                      _9580 = (((_3980 * _3860) * _4000) + _1607);
                    } else {
                      _9575 = _3984;
                      _9576 = _3985;
                      _9577 = _3986;
                      _9578 = _1605;
                      _9579 = _1606;
                      _9580 = _1607;
                    }
                  } else {
                    _9575 = _1602;
                    _9576 = _1603;
                    _9577 = _1604;
                    _9578 = _1605;
                    _9579 = _1606;
                    _9580 = _1607;
                  }
                } else {
                  _9575 = _1602;
                  _9576 = _1603;
                  _9577 = _1604;
                  _9578 = _1605;
                  _9579 = _1606;
                  _9580 = _1607;
                }
              } else {
                _1665 = _1645 * select(((_1614 & 67108864) != 0), 1.0f, (1.0f - _1597));
                [branch]
                if (_1648 == 4) {
                  _1670 = asfloat(srvLightInfoProperties.Load4(_1616)).x;
                  _1671 = asfloat(srvLightInfoProperties.Load4(_1616)).y;
                  _1672 = asfloat(srvLightInfoProperties.Load4(_1616)).z;
                  _1673 = asfloat(srvLightInfoProperties.Load4(_1616)).w;
                  _1676 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).x;
                  _1677 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).y;
                  _1678 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).z;
                  _1679 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).w;
                  _1682 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).x;
                  _1683 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).y;
                  _1684 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).z;
                  _1685 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).w;
                  _1688 = asint(srvLightInfoProperties.Load(((int)(_1616 + 48u))));
                  _1691 = asint(srvLightInfoProperties.Load(((int)(_1616 + 52u))));
                  _1694 = asint(srvLightInfoProperties.Load(((int)(_1616 + 64u))));
                  _1697 = asint(srvLightInfoProperties.Load(((int)(_1616 + 68u))));
                  _1700 = asint(srvLightInfoProperties.Load(((int)(_1616 + 72u))));
                  _1702 = f16tof32(((uint)((uint)(_1688) >> 16)));
                  _1703 = f16tof32(_1688);
                  _1705 = f16tof32(((uint)((uint)(_1691) >> 16)));
                  _1709 = ((float)((uint)((uint)(((uint)(_1691) >> 8) & 255)))) * 0.003921499941498041f;
                  _1722 = mad(_1672, _236, mad(_1671, _235, (_1670 * _234))) + _1673;
                  _1726 = mad(_1678, _236, mad(_1677, _235, (_1676 * _234))) + _1679;
                  _1730 = mad(_1684, _236, mad(_1683, _235, (_1682 * _234))) + _1685;
                  _1755 = saturate(1.0f - ((_1722 + 1.0f) * f16tof32(_1694))) + saturate(1.0f - ((1.0f - _1722) * f16tof32(((uint)((uint)(_1694) >> 16)))));
                  _1756 = saturate(1.0f - ((_1726 + 1.0f) * f16tof32(_1697))) + saturate(1.0f - ((1.0f - _1726) * f16tof32(((uint)((uint)(_1697) >> 16)))));
                  _1757 = saturate(1.0f - ((_1730 + 1.0f) * f16tof32(_1700))) + saturate(1.0f - ((1.0f - _1730) * f16tof32(((uint)((uint)(_1700) >> 16)))));
                  _1760 = saturate(1.0f - dot(float3(_1755, _1756, _1757), float3(_1755, _1756, _1757)));
                  _1761 = _1760 * _1760;
                  _1768 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1761 * _1267), _1761) * _1665;
                  _9575 = ((_1768 * _1702) + _1602);
                  _9576 = ((_1768 * _1703) + _1603);
                  _9577 = ((_1768 * _1705) + _1604);
                  _9578 = (((_1709 * _1702) * _1768) + _1605);
                  _9579 = (((_1709 * _1703) * _1768) + _1606);
                  _9580 = (((_1705 * _1709) * _1768) + _1607);
                } else {
                  if (_1648 == 5) {
                    _1789 = asfloat(srvLightInfoProperties.Load4(_1616)).x;
                    _1790 = asfloat(srvLightInfoProperties.Load4(_1616)).y;
                    _1791 = asfloat(srvLightInfoProperties.Load4(_1616)).z;
                    _1792 = asfloat(srvLightInfoProperties.Load4(_1616)).w;
                    _1795 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).x;
                    _1796 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).y;
                    _1797 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).z;
                    _1798 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).w;
                    _1801 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).x;
                    _1802 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).y;
                    _1803 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).z;
                    _1804 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).w;
                    _1807 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).x;
                    _1808 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).y;
                    _1809 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).z;
                    _1812 = asfloat(srvLightInfoProperties.Load(((int)(_1616 + 60u))));
                    _1815 = asint(srvLightInfoProperties.Load(((int)(_1616 + 64u))));
                    _1818 = asint(srvLightInfoProperties.Load(((int)(_1616 + 68u))));
                    _1821 = asint(srvLightInfoProperties.Load(((int)(_1616 + 84u))));
                    _1824 = asint(srvLightInfoProperties.Load(((int)(_1616 + 88u))));
                    _1827 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 92u)))).x;
                    _1828 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 92u)))).y;
                    _1829 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 92u)))).z;
                    _1830 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 92u)))).w;
                    _1833 = asint(srvLightInfoProperties.Load(((int)(_1616 + 108u))));
                    _1836 = asint(srvLightInfoProperties.Load(((int)(_1616 + 112u))));
                    _1839 = asint(srvLightInfoProperties.Load(((int)(_1616 + 120u))));
                    _1842 = asint(srvLightInfoProperties.Load(((int)(_1616 + 124u))));
                    _1845 = asint(srvLightInfoProperties.Load(((int)(_1616 + 128u))));
                    _1848 = asint(srvLightInfoProperties.Load(((int)(_1616 + 132u))));
                    _1851 = asint(srvLightInfoProperties.Load(((int)(_1616 + 136u))));
                    _1854 = asint(srvLightInfoProperties.Load(((int)(_1616 + 140u))));
                    _1856 = f16tof32(((uint)((uint)(_1815) >> 16)));
                    _1857 = f16tof32(_1815);
                    _1859 = f16tof32(((uint)((uint)(_1818) >> 16)));
                    _1863 = ((float)((uint)((uint)(((uint)(_1818) >> 8) & 255)))) * 0.003921499941498041f;
                    _1865 = _1821 & 65535;
                    _1871 = ((_1614 & 3584) != 0);
                    _1876 = f16tof32(((uint)((uint)(_1836) >> 16)));
                    _1877 = f16tof32(_1836);
                    _1879 = f16tof32(((uint)((uint)(_1839) >> 16)));
                    _1880 = 1.0f / _1879;
                    _1881 = _1879 + -1.0f;
                    _1882 = f16tof32(_1839);
                    _1901 = saturate(1.0f - dot(float3(_200, _202, _204), float3(_1807, _1808, _1809))) * f16tof32(_1833);
                    _1905 = (_1901 * _200) + _234;
                    _1906 = (_1901 * _202) + _235;
                    _1907 = (_1901 * _204) - _233;
                    _1911 = mad(_1791, _1907, mad(_1790, _1906, (_1905 * _1789))) + _1792;
                    _1915 = mad(_1797, _1907, mad(_1796, _1906, (_1905 * _1795))) + _1798;
                    _1919 = mad(_1803, _1907, mad(_1802, _1906, (_1905 * _1801))) + _1804;
                    _1920 = saturate(_1919);
                    _1943 = saturate(1.0f - (_1911 * f16tof32(_1848))) + saturate(1.0f - ((1.0f - _1911) * f16tof32(((uint)((uint)(_1848) >> 16)))));
                    _1944 = saturate(1.0f - (_1915 * f16tof32(_1851))) + saturate(1.0f - ((1.0f - _1915) * f16tof32(((uint)((uint)(_1851) >> 16)))));
                    _1945 = saturate(1.0f - (_1919 * f16tof32(_1854))) + saturate(1.0f - ((1.0f - _1919) * f16tof32(((uint)((uint)(_1854) >> 16)))));
                    _1948 = saturate(1.0f - dot(float3(_1943, _1944, _1945), float3(_1943, _1944, _1945)));
                    _1949 = _1948 * _1948;
                    if (!((!(_1949 > 0.0f)) || (!_1871))) {
                      _1956 = 1.0f - _1920;
                      _1957 = saturate(_1911);
                      _1958 = saturate(_1915);
                      bool __branch_chain_1953;
                      [branch]
                      if ((_1614 & 1024) == 0) {
                        _2271 = 1.0f;
                        _2272 = 1.0f;
                        _2273 = 0.0f;
                        _2274 = _1956;
                        __branch_chain_1953 = true;
                      } else {
                        _1963 = ((_1957 * _1881) + 0.5f) * _1880;
                        _1965 = ((_1958 * _1881) + 0.5f) * _1880;
                        _1966 = _1956 + f16tof32(((uint)((uint)(_1833) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1821) >> 16))];
                        _1969 = saturate(_1966);
                        _1973 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1982 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1973 * 32.665000915527344f) + _129), ((_1973 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1983 = sin(_1982);
                        _1984 = cos(_1982);
                        _1985 = cbSharedPerViewData.nFrameCounter & 3;
                        _1990 = sqrt((float((int)(_1985)) * 0.25f) + 0.125f) * _1876;
                        _1999 = (_global_7[min((uint)(((int)(0u + (_1985 * 2)))), 127u)]) * _1990;
                        _2000 = (_global_7[min((uint)(((int)(1u + (_1985 * 2)))), 127u)]) * _1990;
                        _2002 = -0.0f - _1983;
                        _2007 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1999, _2000), float2(_1984, _1983)) + _1963), (dot(float2(_1999, _2000), float2(_2002, _1984)) + _1965)));
                        _2012 = _2007.x - _1969;
                        _2014 = select((_2012 < 0.0f), 0.0f, 1.0f);
                        _2016 = _2007.y - _1969;
                        _2018 = select((_2016 < 0.0f), 0.0f, 1.0f);
                        _2022 = _2007.z - _1969;
                        _2024 = select((_2022 < 0.0f), 0.0f, 1.0f);
                        _2028 = _2007.w - _1969;
                        _2030 = select((_2028 < 0.0f), 0.0f, 1.0f);
                        _2037 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _2042 = sqrt((float((int)(_2037)) * 0.25f) + 0.125f) * _1876;
                        _2051 = (_global_7[min((uint)(((int)(0u + (_2037 * 2)))), 127u)]) * _2042;
                        _2052 = (_global_7[min((uint)(((int)(1u + (_2037 * 2)))), 127u)]) * _2042;
                        _2058 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2051, _2052), float2(_1984, _1983)) + _1963), (dot(float2(_2051, _2052), float2(_2002, _1984)) + _1965)));
                        _2063 = _2058.x - _1969;
                        _2065 = select((_2063 < 0.0f), 0.0f, 1.0f);
                        _2069 = _2058.y - _1969;
                        _2071 = select((_2069 < 0.0f), 0.0f, 1.0f);
                        _2075 = _2058.z - _1969;
                        _2077 = select((_2075 < 0.0f), 0.0f, 1.0f);
                        _2081 = _2058.w - _1969;
                        _2083 = select((_2081 < 0.0f), 0.0f, 1.0f);
                        _2090 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _2095 = sqrt((float((int)(_2090)) * 0.25f) + 0.125f) * _1876;
                        _2104 = (_global_7[min((uint)(((int)(0u + (_2090 * 2)))), 127u)]) * _2095;
                        _2105 = (_global_7[min((uint)(((int)(1u + (_2090 * 2)))), 127u)]) * _2095;
                        _2111 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2104, _2105), float2(_1984, _1983)) + _1963), (dot(float2(_2104, _2105), float2(_2002, _1984)) + _1965)));
                        _2116 = _2111.x - _1969;
                        _2118 = select((_2116 < 0.0f), 0.0f, 1.0f);
                        _2122 = _2111.y - _1969;
                        _2124 = select((_2122 < 0.0f), 0.0f, 1.0f);
                        _2128 = _2111.z - _1969;
                        _2130 = select((_2128 < 0.0f), 0.0f, 1.0f);
                        _2134 = _2111.w - _1969;
                        _2136 = select((_2134 < 0.0f), 0.0f, 1.0f);
                        _2143 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _2148 = sqrt((float((int)(_2143)) * 0.25f) + 0.125f) * _1876;
                        _2157 = (_global_7[min((uint)(((int)(0u + (_2143 * 2)))), 127u)]) * _2148;
                        _2158 = (_global_7[min((uint)(((int)(1u + (_2143 * 2)))), 127u)]) * _2148;
                        _2164 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2157, _2158), float2(_1984, _1983)) + _1963), (dot(float2(_2157, _2158), float2(_2002, _1984)) + _1965)));
                        _2169 = _2164.x - _1969;
                        _2171 = select((_2169 < 0.0f), 0.0f, 1.0f);
                        _2175 = _2164.y - _1969;
                        _2177 = select((_2175 < 0.0f), 0.0f, 1.0f);
                        _2181 = _2164.z - _1969;
                        _2183 = select((_2181 < 0.0f), 0.0f, 1.0f);
                        _2187 = _2164.w - _1969;
                        _2189 = select((_2187 < 0.0f), 0.0f, 1.0f);
                        _2190 = ((((((((((((((_2014 + _2018) + _2024) + _2030) + _2065) + _2071) + _2077) + _2083) + _2118) + _2124) + _2130) + _2136) + _2171) + _2177) + _2183) + _2189;
                        _2201 = (saturate(_2190 * 0.0625f) * 2.0f) + -1.0f;
                        _2207 = float((int)(((int)(uint)((int)(_2201 > 0.0f))) - ((int)(uint)((int)(_2201 < 0.0f)))));
                        _2209 = 1.0f - (_2207 * _2201);
                        _2211 = (_2209 * _2209) * _2209;
                        _2218 = 0.5f - ((_2207 * 0.5f) * ((1.0f - _2211) - ((_2209 - _2211) * saturate(((1.0f / _1969) * (1.0f / _2190)) * ((((((((((((((((_2014 * _2012) + (_2018 * _2016)) + (_2024 * _2022)) + (_2030 * _2028)) + (_2065 * _2063)) + (_2071 * _2069)) + (_2077 * _2075)) + (_2083 * _2081)) + (_2118 * _2116)) + (_2124 * _2122)) + (_2130 * _2128)) + (_2136 * _2134)) + (_2171 * _2169)) + (_2177 * _2175)) + (_2183 * _2181)) + (_2189 * _2187))))));
                        _2223 = frac((_1963 * _1879) + 0.5f);
                        _2224 = frac((_1965 * _1879) + 0.5f);
                        _2225 = _1963 + _1880;
                        _2226 = _1965 + _1880;
                        _2228 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2225, _2226), _1966);
                        _2236 = _1880 * 2.0f;
                        _2237 = _2225 - _2236;
                        _2238 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2237, _2226), _1966);
                        _2243 = 1.0f - _2223;
                        _2248 = _2226 - _2236;
                        _2249 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2237, _2248), _1966);
                        _2254 = 1.0f - _2224;
                        _2259 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2225, _2248), _1966);
                        _2268 = (((mad(mad(_2238.x, _2243, _2238.y), _2224, mad(_2238.w, _2243, _2238.z)) + mad(mad(_2228.y, _2223, _2228.x), _2224, mad(_2228.z, _2223, _2228.w))) + mad(mad(_2249.w, _2243, _2249.z), _2254, mad(_2249.x, _2243, _2249.y))) + mad(mad(_2259.z, _2223, _2259.w), _2254, mad(_2259.y, _2223, _2259.x))) * 0.1111111119389534f;
                        [branch]
                        if (_1882 < 1.0f) {
                          _2271 = _2218;
                          _2272 = _2268;
                          _2273 = _1882;
                          _2274 = _1966;
                          __branch_chain_1953 = true;
                        } else {
                          _2742 = _2268;
                          _2743 = _1882;
                          _2744 = _2218;
                          __branch_chain_1953 = false;
                        }
                      }
                      if (__branch_chain_1953) {
                        _2277 = (_1957 * _1827) + _1829;
                        _2278 = (_1958 * _1828) + _1830;
                        if (!((_1614 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _2287 = saturate(_2274);
                          _2291 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2300 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2291 * 32.665000915527344f) + _129), ((_2291 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2301 = sin(_2300);
                          _2302 = cos(_2300);
                          _2307 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2277, _2278), 0.0f))).x) > _2287), 1.0f, 0.0f);
                          _2308 = cbSharedPerViewData.nFrameCounter & 3;
                          _2313 = sqrt((float((int)(_2308)) * 0.25f) + 0.125f) * _1877;
                          _2322 = (_global_7[min((uint)(((int)(0u + (_2308 * 2)))), 127u)]) * _2313;
                          _2323 = (_global_7[min((uint)(((int)(1u + (_2308 * 2)))), 127u)]) * _2313;
                          _2325 = -0.0f - _2301;
                          _2327 = dot(float2(_2322, _2323), float2(_2302, _2301)) + _2277;
                          _2328 = dot(float2(_2322, _2323), float2(_2325, _2302)) + _2278;
                          _2330 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2327, _2328));
                          _2334 = _2327 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2335 = _2328 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2338 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1829);
                          _2339 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1830);
                          _2344 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1827 + _1829)) + 0.5f);
                          _2345 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1828 + _1830)) + 0.5f);
                          _2348 = floor(_2334 + -0.5f);
                          _2349 = floor(_2335 + 0.5f);
                          _2351 = floor(_2334 + 0.5f);
                          _2353 = floor(_2335 + -0.5f);
                          _2354 = (_2348 < _2338);
                          _2355 = (_2349 < _2339);
                          if ((_2354 || _2355) | ((_2348 >= _2344) || (_2349 >= _2345))) {
                            _2364 = _2307;
                          } else {
                            _2364 = _2330.x;
                          }
                          _2365 = (_2351 < _2338);
                          if ((_2365 || _2355) | ((_2351 >= _2344) || (_2349 >= _2345))) {
                            _2373 = _2307;
                          } else {
                            _2373 = _2330.y;
                          }
                          _2374 = (_2353 < _2339);
                          if ((_2365 || _2374) | ((_2351 >= _2344) || (_2353 >= _2345))) {
                            _2382 = _2307;
                          } else {
                            _2382 = _2330.z;
                          }
                          if ((_2354 || _2374) | ((_2348 >= _2344) || (_2353 >= _2345))) {
                            _2390 = _2307;
                          } else {
                            _2390 = _2330.w;
                          }
                          _2391 = _2364 - _2287;
                          _2393 = select((_2391 < 0.0f), 0.0f, 1.0f);
                          _2395 = _2373 - _2287;
                          _2397 = select((_2395 < 0.0f), 0.0f, 1.0f);
                          _2401 = _2382 - _2287;
                          _2403 = select((_2401 < 0.0f), 0.0f, 1.0f);
                          _2407 = _2390 - _2287;
                          _2409 = select((_2407 < 0.0f), 0.0f, 1.0f);
                          _2416 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2421 = sqrt((float((int)(_2416)) * 0.25f) + 0.125f) * _1877;
                          _2430 = (_global_7[min((uint)(((int)(0u + (_2416 * 2)))), 127u)]) * _2421;
                          _2431 = (_global_7[min((uint)(((int)(1u + (_2416 * 2)))), 127u)]) * _2421;
                          _2434 = dot(float2(_2430, _2431), float2(_2302, _2301)) + _2277;
                          _2435 = dot(float2(_2430, _2431), float2(_2325, _2302)) + _2278;
                          _2437 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2434, _2435));
                          _2441 = _2434 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2442 = _2435 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2445 = floor(_2441 + -0.5f);
                          _2446 = floor(_2442 + 0.5f);
                          _2448 = floor(_2441 + 0.5f);
                          _2450 = floor(_2442 + -0.5f);
                          _2451 = (_2445 < _2338);
                          _2452 = (_2446 < _2339);
                          if ((_2451 || _2452) | ((_2445 >= _2344) || (_2446 >= _2345))) {
                            _2461 = _2307;
                          } else {
                            _2461 = _2437.x;
                          }
                          _2462 = (_2448 < _2338);
                          if ((_2462 || _2452) | ((_2448 >= _2344) || (_2446 >= _2345))) {
                            _2470 = _2307;
                          } else {
                            _2470 = _2437.y;
                          }
                          _2471 = (_2450 < _2339);
                          if ((_2462 || _2471) | ((_2448 >= _2344) || (_2450 >= _2345))) {
                            _2479 = _2307;
                          } else {
                            _2479 = _2437.z;
                          }
                          if ((_2451 || _2471) | ((_2445 >= _2344) || (_2450 >= _2345))) {
                            _2487 = _2307;
                          } else {
                            _2487 = _2437.w;
                          }
                          _2488 = _2461 - _2287;
                          _2490 = select((_2488 < 0.0f), 0.0f, 1.0f);
                          _2494 = _2470 - _2287;
                          _2496 = select((_2494 < 0.0f), 0.0f, 1.0f);
                          _2500 = _2479 - _2287;
                          _2502 = select((_2500 < 0.0f), 0.0f, 1.0f);
                          _2506 = _2487 - _2287;
                          _2508 = select((_2506 < 0.0f), 0.0f, 1.0f);
                          _2515 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2520 = sqrt((float((int)(_2515)) * 0.25f) + 0.125f) * _1877;
                          _2529 = (_global_7[min((uint)(((int)(0u + (_2515 * 2)))), 127u)]) * _2520;
                          _2530 = (_global_7[min((uint)(((int)(1u + (_2515 * 2)))), 127u)]) * _2520;
                          _2533 = dot(float2(_2529, _2530), float2(_2302, _2301)) + _2277;
                          _2534 = dot(float2(_2529, _2530), float2(_2325, _2302)) + _2278;
                          _2536 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2533, _2534));
                          _2540 = _2533 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2541 = _2534 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2544 = floor(_2540 + -0.5f);
                          _2545 = floor(_2541 + 0.5f);
                          _2547 = floor(_2540 + 0.5f);
                          _2549 = floor(_2541 + -0.5f);
                          _2550 = (_2544 < _2338);
                          _2551 = (_2545 < _2339);
                          if ((_2550 || _2551) | ((_2544 >= _2344) || (_2545 >= _2345))) {
                            _2560 = _2307;
                          } else {
                            _2560 = _2536.x;
                          }
                          _2561 = (_2547 < _2338);
                          if ((_2561 || _2551) | ((_2547 >= _2344) || (_2545 >= _2345))) {
                            _2569 = _2307;
                          } else {
                            _2569 = _2536.y;
                          }
                          _2570 = (_2549 < _2339);
                          if ((_2561 || _2570) | ((_2547 >= _2344) || (_2549 >= _2345))) {
                            _2578 = _2307;
                          } else {
                            _2578 = _2536.z;
                          }
                          if ((_2550 || _2570) | ((_2544 >= _2344) || (_2549 >= _2345))) {
                            _2586 = _2307;
                          } else {
                            _2586 = _2536.w;
                          }
                          _2587 = _2560 - _2287;
                          _2589 = select((_2587 < 0.0f), 0.0f, 1.0f);
                          _2593 = _2569 - _2287;
                          _2595 = select((_2593 < 0.0f), 0.0f, 1.0f);
                          _2599 = _2578 - _2287;
                          _2601 = select((_2599 < 0.0f), 0.0f, 1.0f);
                          _2605 = _2586 - _2287;
                          _2607 = select((_2605 < 0.0f), 0.0f, 1.0f);
                          _2614 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2619 = sqrt((float((int)(_2614)) * 0.25f) + 0.125f) * _1877;
                          _2628 = (_global_7[min((uint)(((int)(0u + (_2614 * 2)))), 127u)]) * _2619;
                          _2629 = (_global_7[min((uint)(((int)(1u + (_2614 * 2)))), 127u)]) * _2619;
                          _2632 = dot(float2(_2628, _2629), float2(_2302, _2301)) + _2277;
                          _2633 = dot(float2(_2628, _2629), float2(_2325, _2302)) + _2278;
                          _2635 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2632, _2633));
                          _2639 = _2632 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2640 = _2633 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2643 = floor(_2639 + -0.5f);
                          _2644 = floor(_2640 + 0.5f);
                          _2646 = floor(_2639 + 0.5f);
                          _2648 = floor(_2640 + -0.5f);
                          _2649 = (_2643 < _2338);
                          _2650 = (_2644 < _2339);
                          if ((_2649 || _2650) | ((_2643 >= _2344) || (_2644 >= _2345))) {
                            _2659 = _2307;
                          } else {
                            _2659 = _2635.x;
                          }
                          _2660 = (_2646 < _2338);
                          if ((_2660 || _2650) | ((_2646 >= _2344) || (_2644 >= _2345))) {
                            _2668 = _2307;
                          } else {
                            _2668 = _2635.y;
                          }
                          _2669 = (_2648 < _2339);
                          if ((_2660 || _2669) | ((_2646 >= _2344) || (_2648 >= _2345))) {
                            _2677 = _2307;
                          } else {
                            _2677 = _2635.z;
                          }
                          if ((_2649 || _2669) | ((_2643 >= _2344) || (_2648 >= _2345))) {
                            _2685 = _2307;
                          } else {
                            _2685 = _2635.w;
                          }
                          _2686 = _2659 - _2287;
                          _2688 = select((_2686 < 0.0f), 0.0f, 1.0f);
                          _2692 = _2668 - _2287;
                          _2694 = select((_2692 < 0.0f), 0.0f, 1.0f);
                          _2698 = _2677 - _2287;
                          _2700 = select((_2698 < 0.0f), 0.0f, 1.0f);
                          _2704 = _2685 - _2287;
                          _2706 = select((_2704 < 0.0f), 0.0f, 1.0f);
                          _2707 = ((((((((((((((_2397 + _2393) + _2403) + _2409) + _2490) + _2496) + _2502) + _2508) + _2589) + _2595) + _2601) + _2607) + _2688) + _2694) + _2700) + _2706;
                          _2718 = (saturate(_2707 * 0.0625f) * 2.0f) + -1.0f;
                          _2724 = float((int)(((int)(uint)((int)(_2718 > 0.0f))) - ((int)(uint)((int)(_2718 < 0.0f)))));
                          _2726 = 1.0f - (_2724 * _2718);
                          _2728 = (_2726 * _2726) * _2726;
                          _2737 = (0.5f - ((_2724 * 0.5f) * ((1.0f - _2728) - ((_2726 - _2728) * saturate(((1.0f / _2287) * (1.0f / _2707)) * ((((((((((((((((_2397 * _2395) + (_2393 * _2391)) + (_2403 * _2401)) + (_2409 * _2407)) + (_2490 * _2488)) + (_2496 * _2494)) + (_2502 * _2500)) + (_2508 * _2506)) + (_2589 * _2587)) + (_2595 * _2593)) + (_2601 * _2599)) + (_2607 * _2605)) + (_2688 * _2686)) + (_2694 * _2692)) + (_2700 * _2698)) + (_2706 * _2704)))))));
                        } else {
                          _2737 = 1.0f;
                        }
                        _2742 = _2272;
                        _2743 = _2273;
                        _2744 = (lerp(_2737, _2271, _2273));
                      }
                      [branch]
                      if (!((_1614 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1824) >> 16))];
                        _2750 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1911, _1915), 0.0f);
                        if (_2750.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1824 & 65535))];
                          _2757 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1911, _1915), 0.0f);
                          _2771 = mad(saturate(((log2(_1920 * _1812) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2772 = max(9.999999747378752e-06f, _2750.x);
                          _2773 = _2757.x / _2772;
                          _2774 = _2757.y / _2772;
                          _2776 = _2757.w / _2772;
                          _2781 = ((0.375f - _2774) * 4.999999873689376e-06f) + _2774;
                          _2784 = -0.0f - _2773;
                          _2785 = mad(_2784, _2781, (_2757.z / _2772));
                          _2787 = 1.0f / mad(_2784, _2773, _2781);
                          _2788 = _2787 * _2785;
                          _2793 = _2771 - _2773;
                          _2798 = (((_2771 * _2771) - _2781) - (_2788 * _2793)) / mad((-0.0f - _2785), _2788, mad((-0.0f - _2781), _2781, (((0.375f - _2776) * 4.999999873689376e-06f) + _2776)));
                          _2800 = (_2787 * _2793) - (_2798 * _2788);
                          _2803 = 1.0f / _2798;
                          _2804 = _2800 * _2803;
                          _2809 = sqrt(((_2804 * _2804) * 0.25f) - ((1.0f - dot(float2(_2800, _2798), float2(_2773, _2781))) * _2803));
                          _2811 = (_2804 * -0.5f) - _2809;
                          _2813 = _2809 - (_2804 * 0.5f);
                          _2815 = select((_2811 < _2771), 1.0f, 0.0f);
                          _2820 = (_2815 + -0.05000000074505806f) / (_2811 - _2771);
                          _2826 = (((select((_2813 < _2771), 1.0f, 0.0f) - _2815) / (_2813 - _2811)) - _2820) / (_2813 - _2771);
                          _2828 = _2820 - (_2826 * _2811);
                          _2841 = (exp2((_2750.x * -1.4426950216293335f) * saturate((dot(float2(_2773, _2781), float2((_2828 - (_2826 * _2771)), _2826)) + 0.05000000074505806f) - (_2828 * _2771))) * _2744);
                        } else {
                          _2841 = _2744;
                        }
                      } else {
                        _2841 = _2744;
                      }
                      _2846 = _2743;
                      _2847 = _2841;
                      _2848 = (lerp(_2841, _2742, _2743));
                    } else {
                      _2846 = 0.0f;
                      _2847 = 1.0f;
                      _2848 = 1.0f;
                    }
                    [branch]
                    if (!(_1865 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1865)))];
                      _2861 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1911 * f16tof32(((uint)((uint)(_1842) >> 16)))) + f16tof32(((uint)((uint)(_1845) >> 16)))), ((_1915 * f16tof32(_1842)) + f16tof32(_1845))), 0.0f);
                      _2869 = (_2861.x * _1856);
                      _2870 = (_2861.y * _1857);
                      _2871 = (_2861.z * _1859);
                    } else {
                      _2869 = _1856;
                      _2870 = _1857;
                      _2871 = _1859;
                    }
                    _2872 = _2847 * _1949;
                    _2873 = _2848 * _1949;
                    [branch]
                    if (!(_2872 == 0.0f)) {
                      bool __branch_chain_2875;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2891 = 0;
                        __branch_chain_2875 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2891 = 1;
                          __branch_chain_2875 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2891 = 2;
                            __branch_chain_2875 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2891 = 3;
                              __branch_chain_2875 = true;
                            } else {
                              _2912 = _2872;
                              __branch_chain_2875 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2875) {
                        while(true) {
                          _2894 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_67, _68, 0));
                          if (_2891 == 0) {
                            _2908 = _2894.x;
                          } else {
                            if (_2891 == 1) {
                              _2908 = _2894.y;
                            } else {
                              if (_2891 == 2) {
                                _2908 = _2894.z;
                              } else {
                                _2908 = _2894.w;
                              }
                            }
                          }
                          _2912 = ((_2908 * _2908) * _1949);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2912 == 0.0f)) {
                          [branch]
                          if (_1871) {
                            _2918 = _2846;
                          } else {
                            _2918 = 0.0f;
                          }
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2925 = srvLightMappingData[_1617];
                            if (!(_2925 == -1)) {
                              _2930 = srvLightIndexData[_2925].nLayerIndex;
                              _2932 = srvLightIndexData[_2925].vAtlasOrigin.x;
                              _2933 = srvLightIndexData[_2925].vAtlasOrigin.y;
                              _2935 = srvLightIndexData[_2925].vScreenOrigin.x;
                              _2936 = srvLightIndexData[_2925].vScreenOrigin.y;
                              _2945 = ((int)(_2930 * 5)) & 31;
                              _2948 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2932 + _67) - _2935)), ((int)((_2933 + _68) - _2936)), 0)))).x) & ((int)(31 << _2945)))) >> _2945;
                              _2958 = ((_2873 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_2948) >> 1)))));
                              _2959 = (((float)((bool)(uint)((_2948 & 1) != 0))) * _2873);
                            } else {
                              _2958 = _2873;
                              _2959 = _2873;
                            }
                          } else {
                            _2958 = _2873;
                            _2959 = _2873;
                          }
                          _2963 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2966 = select(_2963, (_2958 * _1267), _2958);
                          _2969 = rsqrt(dot(float3(_1807, _1808, _1809), float3(_1807, _1808, _1809)));
                          _2970 = _2969 * _1807;
                          _2971 = _2969 * _1808;
                          _2972 = _2969 * _1809;
                          _2973 = dot(float3(_200, _202, _204), float3(_2970, _2971, _2972));
                          _2974 = saturate(_2973);
                          _2977 = uint((_180 * 255.0f) + 0.5f);
                          _2986 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                          _2987 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                          _2988 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                          _3004 = ((dot(float3(_201, _203, _205), float3(_2970, _2971, _2972)) + dot(float3((-0.0f - _449), (-0.0f - _450), (-0.0f - _448)), float3(_2970, _2971, _2972))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_200, _202, _204), float3(_449, _450, _448)))) * (11.0f - (((float)((uint)((uint)((uint)(_2977) >> 2)))) * 0.1666666716337204f)));
                          _3011 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                          _3014 = saturate((_3011 + -0.009999999776482582f) * -100.0f);
                          _3019 = ((_3014 * _3014) * 3.0f) * (3.0f - (_3014 * 2.0f));
                          _3026 = 10.0f - (exp2(log2(saturate(_3011 * 5.0f)) * 3.0f) * 9.0f);
                          _3027 = saturate(_2974 + _2986) * _2974;
                          _3028 = saturate(_2974 + _2987) * _2974;
                          _3029 = saturate(_2974 + _2988) * _2974;
                          _3051 = _2970 + _449;
                          _3052 = _2971 + _450;
                          _3053 = _2972 + _448;
                          _3055 = rsqrt(dot(float3(_3051, _3052, _3053), float3(_3051, _3052, _3053)));
                          if (!(select(((_222 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                            _3070 = rsqrt(dot(float3(_200, _202, _204), float3(_200, _202, _204)));
                            _3071 = _3070 * _200;
                            _3072 = _3070 * _202;
                            _3073 = _3070 * _204;
                            _3076 = (abs(_3071) < abs(_3072));
                            _3077 = select(_3076, 1.0f, 0.0f);
                            _3078 = select(_3076, 0.0f, 1.0f);
                            _3079 = _3078 * _3073;
                            _3081 = -0.0f - (_3073 * _3077);
                            _3084 = (_3077 * _3072) - (_3078 * _3071);
                            _3086 = rsqrt(dot(float3(_3079, _3081, _3084), float3(_3079, _3081, _3084)));
                            _3087 = _3079 * _3086;
                            _3088 = _3086 * _3081;
                            _3089 = _3084 * _3086;
                            _3092 = (_3088 * _3073) - (_3089 * _3072);
                            _3095 = (_3089 * _3071) - (_3087 * _3073);
                            _3098 = (_3087 * _3072) - (_3088 * _3071);
                            _3100 = rsqrt(dot(float3(_3092, _3095, _3098), float3(_3092, _3095, _3098)));
                            _3104 = _178 * 4.0f;
                            _3113 = saturate(abs(_3104 + -2.5f) + -0.5f) + -0.5f;
                            _3114 = saturate(1.5f - abs(_3104 + -1.5f)) + -0.5f;
                            _3116 = rsqrt(dot(float2(_3113, _3114), float2(_3113, _3114)));
                            _3117 = _3116 * _3113;
                            _3118 = _3116 * _3114;
                            _3125 = ((_3092 * _3100) * _3117) + (_3118 * _3087);
                            _3126 = ((_3095 * _3100) * _3117) + (_3118 * _3088);
                            _3127 = ((_3098 * _3100) * _3117) + (_3118 * _3089);
                            _3128 = dot(float3(_449, _450, _448), float3(_2970, _2971, _2972));
                            _3131 = min(max(dot(float3(_3125, _3126, _3127), float3(_2970, _2971, _2972)), -1.0f), 1.0f);
                            _3134 = min(max(dot(float3(_3125, _3126, _3127), float3(_449, _450, _448)), -1.0f), 1.0f);
                            _3135 = abs(_3134);
                            _3140 = (1.5707963705062866f - (_3135 * 0.1565829962491989f)) * sqrt(1.0f - _3135);
                            _3144 = abs(_3131);
                            _3149 = (1.5707963705062866f - (_3144 * 0.1565829962491989f)) * sqrt(1.0f - _3144);
                            _3156 = cos(abs(select((_3131 >= 0.0f), _3149, (3.1415927410125732f - _3149)) - select((_3134 >= 0.0f), _3140, (3.1415927410125732f - _3140))) * 0.5f);
                            _3160 = _2970 - (_3131 * _3125);
                            _3161 = _2971 - (_3131 * _3126);
                            _3162 = _2972 - (_3131 * _3127);
                            _3166 = _449 - (_3134 * _3125);
                            _3167 = _450 - (_3134 * _3126);
                            _3168 = _448 - (_3134 * _3127);
                            _3175 = rsqrt((dot(float3(_3166, _3167, _3168), float3(_3166, _3167, _3168)) * dot(float3(_3160, _3161, _3162), float3(_3160, _3161, _3162))) + 9.999999747378752e-05f) * dot(float3(_3160, _3161, _3162), float3(_3166, _3167, _3168));
                            _3179 = sqrt(saturate((_3175 * 0.5f) + 0.5f));
                            _3183 = _219 * _219;
                            _3184 = _3183 * 0.5f;
                            _3185 = _3183 * 2.0f;
                            _3189 = exp2((1.0f - abs(_2918)) * -72.13475036621094f);
                            if (!((_2977 & 1) == 0)) {
                              _3196 = select(((select(((_2977 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_2918 == -1.0f))), 0.0f, _3189);
                            } else {
                              _3196 = _3189;
                            }
                            _3199 = saturate((_2973 + 0.5f) * 0.6666666865348816f);
                            _3209 = (_3134 + _3131) + ((((_3179 * 0.9975510239601135f) * sqrt(1.0f - (_3134 * _3134))) - (_3134 * 0.06994284689426422f)) * 0.13988569378852844f);
                            _3211 = (_3183 * 1.4142135381698608f) * _3179;
                            _3224 = 1.0f - sqrt(saturate((_3128 * 0.5f) + 0.5f));
                            _3225 = _3224 * _3224;
                            _3231 = saturate(-0.0f - _3128);
                            _3234 = (1.0f - saturate(_3231)) * _3199;
                            _3243 = ((((_3179 * 0.5f) * (exp2((((_3209 * _3209) * -0.5f) / (_3211 * _3211)) * 1.4426950216293335f) / (_3211 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_3225 * _3225) * (_3224 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3234, 1.0f, _3196));
                            _3245 = (_3131 + -0.03500000014901161f) + _3134;
                            _3254 = 1.0f / ((1.190000057220459f / _3156) + (_3156 * 0.36000001430511475f));
                            _3259 = ((_3254 * (0.6000000238418579f - (_3175 * 0.800000011920929f))) + 1.0f) * _3179;
                            _3265 = 1.0f - (sqrt(saturate(1.0f - (_3259 * _3259))) * _3156);
                            _3266 = _3265 * _3265;
                            _3270 = 0.9534794092178345f - ((_3266 * _3266) * (_3265 * 0.9534794092178345f));
                            _3271 = _3259 * _3254;
                            _3276 = (sqrt(1.0f - (_3271 * _3271)) * 0.5f) / _3156;
                            _3295 = 1.0f - saturate((_3231 + -0.44999998807907104f) * 2.222222328186035f);
                            _3298 = ((1.0f - _3199) * _3196) + _3199;
                            _3301 = ((_3270 * _3270) * (exp2((((_3245 * _3245) * -0.5f) / (_3184 * _3184)) * 1.4426950216293335f) / (_3183 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3175 * 5.2658371925354f));
                            _3315 = (_3131 + -0.14000000059604645f) + _3134;
                            _3325 = 1.0f - (_3156 * 0.5f);
                            _3326 = _3325 * _3325;
                            _3330 = (_3326 * _3326) * (0.9534794092178345f - (_3156 * 0.47673970460891724f));
                            _3332 = 0.9534794092178345f - _3330;
                            _3334 = (_3332 * _3332) * (_3330 + 0.04652056470513344f);
                            _3337 = exp2((_3175 * 24.525815963745117f) + -24.208423614501953f);
                            _3350 = ((exp2((((_3315 * _3315) * -0.5f) / (_3185 * _3185)) * 1.4426950216293335f) / (_3183 * 5.013256549835205f)) * (lerp(_3334, 1.0f, _172))) * (((exp2((saturate(dot(float3((_3055 * _3051), (_3055 * _3052), (_3055 * _3053)), float3(_200, _202, _204))) * 17.312339782714844f) + -14.109557151794434f) - _3337) * _172) + _3337);
                            _3358 = (((((exp2(log2(max(_168, 0.0f)) * _3276) * _3298) * _3301) * _3295) + _3243) + (_3350 * _168));
                            _3359 = (((((exp2(log2(max(_169, 0.0f)) * _3276) * _3298) * _3301) * _3295) + _3243) + (_3350 * _169));
                            _3360 = (((((exp2(log2(max(_170, 0.0f)) * _3276) * _3298) * _3301) * _3295) + _3243) + (_3350 * _170));
                          } else {
                            _3358 = 0.0f;
                            _3359 = 0.0f;
                            _3360 = 0.0f;
                          }
                          _3361 = _2869 * _1665;
                          _3362 = _2870 * _1665;
                          _3363 = _2871 * _1665;
                          _3370 = ((_2966 * _3361) * ((max(((_3019 + _2986) * _3004), 0.0f) * _3026) + sqrt(_3027 * _3027))) + _1602;
                          _3371 = ((_2966 * _3362) * ((max(((_3019 + _2987) * _3004), 0.0f) * _3026) + sqrt(_3028 * _3028))) + _1603;
                          _3372 = ((_2966 * _3363) * ((max(((_3019 + _2988) * _3004), 0.0f) * _3026) + sqrt(_3029 * _3029))) + _1604;
                          if (_1863 > 0.0f) {
                            _3375 = (_1863 * _1358) * select(_2963, (_2959 * _1267), _2959);
                            _9575 = _3370;
                            _9576 = _3371;
                            _9577 = _3372;
                            _9578 = (((_3375 * _3361) * _3358) + _1605);
                            _9579 = (((_3375 * _3362) * _3359) + _1606);
                            _9580 = (((_3375 * _3363) * _3360) + _1607);
                          } else {
                            _9575 = _3370;
                            _9576 = _3371;
                            _9577 = _3372;
                            _9578 = _1605;
                            _9579 = _1606;
                            _9580 = _1607;
                          }
                        } else {
                          _9575 = _1602;
                          _9576 = _1603;
                          _9577 = _1604;
                          _9578 = _1605;
                          _9579 = _1606;
                          _9580 = _1607;
                        }
                        break;
                      }
                    } else {
                      _9575 = _1602;
                      _9576 = _1603;
                      _9577 = _1604;
                      _9578 = _1605;
                      _9579 = _1606;
                      _9580 = _1607;
                    }
                  } else {
                    if (_1648 == 7) {
                      _4015 = asfloat(srvLightInfoProperties.Load3(_1616)).x;
                      _4016 = asfloat(srvLightInfoProperties.Load3(_1616)).y;
                      _4017 = asfloat(srvLightInfoProperties.Load3(_1616)).z;
                      _4020 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 12u)))).x;
                      _4021 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 12u)))).y;
                      _4022 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 12u)))).z;
                      _4025 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 24u)))).x;
                      _4026 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 24u)))).y;
                      _4027 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 24u)))).z;
                      _4030 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 36u)))).x;
                      _4031 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 36u)))).y;
                      _4032 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 36u)))).z;
                      _4035 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).x;
                      _4036 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).y;
                      _4037 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 48u)))).z;
                      _4040 = asint(srvLightInfoProperties.Load(((int)(_1616 + 60u))));
                      _4043 = asint(srvLightInfoProperties.Load(((int)(_1616 + 64u))));
                      _4046 = asint(srvLightInfoProperties.Load(((int)(_1616 + 72u))));
                      _4049 = asint(srvLightInfoProperties.Load(((int)(_1616 + 80u))));
                      _4052 = asint(srvLightInfoProperties.Load(((int)(_1616 + 84u))));
                      _4055 = asint(srvLightInfoProperties.Load(((int)(_1616 + 88u))));
                      _4058 = asint(srvLightInfoProperties.Load(((int)(_1616 + 92u))));
                      _4061 = asint(srvLightInfoProperties.Load(((int)(_1616 + 96u))));
                      _4064 = asint(srvLightInfoProperties.Load(((int)(_1616 + 100u))));
                      _4067 = asint(srvLightInfoProperties.Load(((int)(_1616 + 104u))));
                      _4070 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).x;
                      _4071 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).y;
                      _4072 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).z;
                      _4073 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).w;
                      _4076 = asint(srvLightInfoProperties.Load(((int)(_1616 + 124u))));
                      _4079 = asint(srvLightInfoProperties.Load(((int)(_1616 + 128u))));
                      _4082 = asint(srvLightInfoProperties.Load(((int)(_1616 + 136u))));
                      _4085 = asint(srvLightInfoProperties.Load(((int)(_1616 + 140u))));
                      _4087 = f16tof32(((uint)((uint)(_4040) >> 16)));
                      _4088 = f16tof32(_4040);
                      _4090 = f16tof32(((uint)((uint)(_4043) >> 16)));
                      _4094 = ((float)((uint)((uint)(((uint)(_4043) >> 8) & 255)))) * 0.003921499941498041f;
                      _4095 = f16tof32(_4046);
                      _4098 = f16tof32(_4049);
                      _4100 = f16tof32(((uint)((uint)(_4052) >> 16)));
                      _4101 = f16tof32(_4052);
                      _4103 = f16tof32(((uint)((uint)(_4055) >> 16)));
                      _4106 = _4058 & 65535;
                      _4110 = ((_1614 & 4194304) != 0);
                      _4118 = f16tof32(((uint)((uint)(_4067) >> 16)));
                      _4119 = f16tof32(_4067);
                      _4121 = f16tof32(((uint)((uint)(_4076) >> 16)));
                      _4124 = f16tof32(((uint)((uint)(_4079) >> 16)));
                      _4125 = f16tof32(_4079);
                      _4127 = f16tof32(((uint)((uint)(_4082) >> 16)));
                      _4128 = _4127 + -1.0f;
                      if (_4110) {
                        _4130 = 0.5f / _4127;
                        _4131 = 0.3333333432674408f / _4127;
                        _4135 = (_4127 * 0.5f) + 0.5f;
                        _4145 = (_4130 * _4128);
                        _4146 = (_4131 * _4128);
                        _4147 = (_4130 * _4135);
                        _4148 = (_4131 * _4135);
                        _4149 = (_4127 * 2.0f);
                        _4150 = (_4127 * 3.0f);
                        _4151 = _4130;
                        _4152 = _4131;
                      } else {
                        _4141 = 1.0f / _4127;
                        _4142 = _4141 * _4128;
                        _4143 = _4141 * 0.5f;
                        _4145 = _4142;
                        _4146 = _4142;
                        _4147 = _4143;
                        _4148 = _4143;
                        _4149 = _4127;
                        _4150 = _4127;
                        _4151 = _4141;
                        _4152 = _4141;
                      }
                      _4156 = _4030 - _234;
                      _4157 = _4031 - _235;
                      _4158 = _4032 + _233;
                      _4159 = dot(float3(_4156, _4157, _4158), float3(_4156, _4157, _4158));
                      _4160 = rsqrt(_4159);
                      _4161 = _4160 * _4159;
                      _4162 = _4160 * _4156;
                      _4163 = _4160 * _4157;
                      _4164 = _4160 * _4158;
                      _4167 = max(0.0f, (_4161 - abs(_4098)));
                      _4168 = _4167 * f16tof32(((uint)((uint)(_4049) >> 16)));
                      _4169 = _4168 * _4168;
                      _4172 = saturate(1.0f - (_4169 * _4169));
                      _4179 = (_4172 * _4172) / (select((_4098 < 0.0f), (_4169 * 16.0f), (_4167 * _4167)) + 1.0f);
                      _4192 = saturate(1.0f - dot(float3(_200, _202, _204), float3(_4162, _4163, _4164))) * f16tof32(_4076);
                      _4196 = abs(_4158);
                      _4200 = _4156 - ((_4192 * _200) * _4196);
                      _4201 = _4157 - ((_4192 * _202) * _4196);
                      _4202 = _4158 - ((_4192 * _204) * _4196);
                      _4205 = mad(_4202, _4026, mad(_4201, _4021, (_4200 * _4016)));
                      _4208 = mad(_4202, _4027, mad(_4201, _4022, (_4200 * _4017)));
                      _4210 = ((_1614 & 3584) != 0);
                      if (_4210 && (_4179 > 0.0f)) {
                        _4216 = mad(_4202, _4025, mad(_4201, _4020, (_4200 * _4015)));
                        _4217 = -0.0f - _4208;
                        _4218 = -0.0f - _4205;
                        [branch]
                        if (!((_1614 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_4058) >> 16))];
                          [branch]
                          if (_4110) {
                            _4223 = abs(_4216);
                            _4224 = abs(_4217);
                            _4225 = abs(_4218);
                            if (_4223 > max(_4224, _4225)) {
                              _4229 = (_4216 > 0.0f);
                              _4244 = select(_4229, 0.0f, 1.0f);
                              _4245 = 0.0f;
                              _4246 = select(_4229, _4205, _4218);
                              _4247 = _4208;
                              _4248 = _4223;
                            } else {
                              if (_4224 > _4225) {
                                _4235 = (_4208 < -0.0f);
                                _4244 = select(_4235, 0.0f, 1.0f);
                                _4245 = 1.0f;
                                _4246 = _4216;
                                _4247 = select(_4235, _4218, _4205);
                                _4248 = _4224;
                              } else {
                                _4239 = (_4205 < -0.0f);
                                _4244 = select(_4239, 0.0f, 1.0f);
                                _4245 = 2.0f;
                                _4246 = select(_4239, _4216, (-0.0f - _4216));
                                _4247 = _4208;
                                _4248 = _4225;
                              }
                            }
                            _4249 = _4248 * 2.0f;
                            _4254 = -0.0f - _4119;
                            _4263 = ((min(max((_4246 / _4249), _4254), _4119) + _4244) * _4145) + _4147;
                            _4264 = ((min(max((_4247 / _4249), _4254), _4119) + _4245) * _4146) + _4148;
                            _4265 = (1.0f - (_4248 * _4103)) + _4121;
                            _4270 = ((_4244 + -0.5f) * _4145) + _4147;
                            _4271 = ((_4245 + -0.5f) * _4146) + _4148;
                            _4274 = saturate(_4265);
                            _4278 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4287 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_4278 * 32.665000915527344f) + _129), ((_4278 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4288 = sin(_4287);
                            _4289 = cos(_4287);
                            _4294 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_4263, _4264), 0.0f))).x) > _4274), 1.0f, 0.0f);
                            _4295 = cbSharedPerViewData.nFrameCounter & 3;
                            _4300 = sqrt((float((int)(_4295)) * 0.25f) + 0.125f) * _4124;
                            _4309 = (_global_7[min((uint)(((int)(0u + (_4295 * 2)))), 127u)]) * _4300;
                            _4310 = (_global_7[min((uint)(((int)(1u + (_4295 * 2)))), 127u)]) * _4300;
                            _4312 = -0.0f - _4288;
                            _4314 = dot(float2(_4309, _4310), float2(_4289, _4288)) + _4263;
                            _4315 = dot(float2(_4309, _4310), float2(_4312, _4289)) + _4264;
                            _4317 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4314, _4315));
                            _4321 = _4314 * _4149;
                            _4322 = _4315 * _4150;
                            _4325 = floor(_4270 * _4149);
                            _4326 = floor(_4271 * _4150);
                            _4331 = floor(((_4270 + _4145) * _4149) + 0.5f);
                            _4332 = floor(((_4271 + _4146) * _4150) + 0.5f);
                            _4335 = floor(_4321 + -0.5f);
                            _4336 = floor(_4322 + 0.5f);
                            _4338 = floor(_4321 + 0.5f);
                            _4340 = floor(_4322 + -0.5f);
                            _4341 = (_4335 < _4325);
                            _4342 = (_4336 < _4326);
                            if ((_4341 || _4342) | ((_4335 >= _4331) || (_4336 >= _4332))) {
                              _4351 = _4294;
                            } else {
                              _4351 = _4317.x;
                            }
                            _4352 = (_4338 < _4325);
                            if ((_4352 || _4342) | ((_4338 >= _4331) || (_4336 >= _4332))) {
                              _4360 = _4294;
                            } else {
                              _4360 = _4317.y;
                            }
                            _4361 = (_4340 < _4326);
                            if ((_4352 || _4361) | ((_4338 >= _4331) || (_4340 >= _4332))) {
                              _4369 = _4294;
                            } else {
                              _4369 = _4317.z;
                            }
                            if ((_4341 || _4361) | ((_4335 >= _4331) || (_4340 >= _4332))) {
                              _4377 = _4294;
                            } else {
                              _4377 = _4317.w;
                            }
                            _4378 = _4351 - _4274;
                            _4380 = select((_4378 < 0.0f), 0.0f, 1.0f);
                            _4382 = _4360 - _4274;
                            _4384 = select((_4382 < 0.0f), 0.0f, 1.0f);
                            _4388 = _4369 - _4274;
                            _4390 = select((_4388 < 0.0f), 0.0f, 1.0f);
                            _4394 = _4377 - _4274;
                            _4396 = select((_4394 < 0.0f), 0.0f, 1.0f);
                            _4403 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _4408 = sqrt((float((int)(_4403)) * 0.25f) + 0.125f) * _4124;
                            _4417 = (_global_7[min((uint)(((int)(0u + (_4403 * 2)))), 127u)]) * _4408;
                            _4418 = (_global_7[min((uint)(((int)(1u + (_4403 * 2)))), 127u)]) * _4408;
                            _4421 = dot(float2(_4417, _4418), float2(_4289, _4288)) + _4263;
                            _4422 = dot(float2(_4417, _4418), float2(_4312, _4289)) + _4264;
                            _4424 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4421, _4422));
                            _4428 = _4421 * _4149;
                            _4429 = _4422 * _4150;
                            _4432 = floor(_4428 + -0.5f);
                            _4433 = floor(_4429 + 0.5f);
                            _4435 = floor(_4428 + 0.5f);
                            _4437 = floor(_4429 + -0.5f);
                            _4438 = (_4432 < _4325);
                            _4439 = (_4433 < _4326);
                            if ((_4438 || _4439) | ((_4432 >= _4331) || (_4433 >= _4332))) {
                              _4448 = _4294;
                            } else {
                              _4448 = _4424.x;
                            }
                            _4449 = (_4435 < _4325);
                            if ((_4449 || _4439) | ((_4435 >= _4331) || (_4433 >= _4332))) {
                              _4457 = _4294;
                            } else {
                              _4457 = _4424.y;
                            }
                            _4458 = (_4437 < _4326);
                            if ((_4449 || _4458) | ((_4435 >= _4331) || (_4437 >= _4332))) {
                              _4466 = _4294;
                            } else {
                              _4466 = _4424.z;
                            }
                            if ((_4438 || _4458) | ((_4432 >= _4331) || (_4437 >= _4332))) {
                              _4474 = _4294;
                            } else {
                              _4474 = _4424.w;
                            }
                            _4475 = _4448 - _4274;
                            _4477 = select((_4475 < 0.0f), 0.0f, 1.0f);
                            _4481 = _4457 - _4274;
                            _4483 = select((_4481 < 0.0f), 0.0f, 1.0f);
                            _4487 = _4466 - _4274;
                            _4489 = select((_4487 < 0.0f), 0.0f, 1.0f);
                            _4493 = _4474 - _4274;
                            _4495 = select((_4493 < 0.0f), 0.0f, 1.0f);
                            _4502 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4507 = sqrt((float((int)(_4502)) * 0.25f) + 0.125f) * _4124;
                            _4516 = (_global_7[min((uint)(((int)(0u + (_4502 * 2)))), 127u)]) * _4507;
                            _4517 = (_global_7[min((uint)(((int)(1u + (_4502 * 2)))), 127u)]) * _4507;
                            _4520 = dot(float2(_4516, _4517), float2(_4289, _4288)) + _4263;
                            _4521 = dot(float2(_4516, _4517), float2(_4312, _4289)) + _4264;
                            _4523 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4520, _4521));
                            _4527 = _4520 * _4149;
                            _4528 = _4521 * _4150;
                            _4531 = floor(_4527 + -0.5f);
                            _4532 = floor(_4528 + 0.5f);
                            _4534 = floor(_4527 + 0.5f);
                            _4536 = floor(_4528 + -0.5f);
                            _4537 = (_4531 < _4325);
                            _4538 = (_4532 < _4326);
                            if ((_4537 || _4538) | ((_4531 >= _4331) || (_4532 >= _4332))) {
                              _4547 = _4294;
                            } else {
                              _4547 = _4523.x;
                            }
                            _4548 = (_4534 < _4325);
                            if ((_4548 || _4538) | ((_4534 >= _4331) || (_4532 >= _4332))) {
                              _4556 = _4294;
                            } else {
                              _4556 = _4523.y;
                            }
                            _4557 = (_4536 < _4326);
                            if ((_4548 || _4557) | ((_4534 >= _4331) || (_4536 >= _4332))) {
                              _4565 = _4294;
                            } else {
                              _4565 = _4523.z;
                            }
                            if ((_4537 || _4557) | ((_4531 >= _4331) || (_4536 >= _4332))) {
                              _4573 = _4294;
                            } else {
                              _4573 = _4523.w;
                            }
                            _4574 = _4547 - _4274;
                            _4576 = select((_4574 < 0.0f), 0.0f, 1.0f);
                            _4580 = _4556 - _4274;
                            _4582 = select((_4580 < 0.0f), 0.0f, 1.0f);
                            _4586 = _4565 - _4274;
                            _4588 = select((_4586 < 0.0f), 0.0f, 1.0f);
                            _4592 = _4573 - _4274;
                            _4594 = select((_4592 < 0.0f), 0.0f, 1.0f);
                            _4601 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4606 = sqrt((float((int)(_4601)) * 0.25f) + 0.125f) * _4124;
                            _4615 = (_global_7[min((uint)(((int)(0u + (_4601 * 2)))), 127u)]) * _4606;
                            _4616 = (_global_7[min((uint)(((int)(1u + (_4601 * 2)))), 127u)]) * _4606;
                            _4619 = dot(float2(_4615, _4616), float2(_4289, _4288)) + _4263;
                            _4620 = dot(float2(_4615, _4616), float2(_4312, _4289)) + _4264;
                            _4622 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4619, _4620));
                            _4626 = _4619 * _4149;
                            _4627 = _4620 * _4150;
                            _4630 = floor(_4626 + -0.5f);
                            _4631 = floor(_4627 + 0.5f);
                            _4633 = floor(_4626 + 0.5f);
                            _4635 = floor(_4627 + -0.5f);
                            _4636 = (_4630 < _4325);
                            _4637 = (_4631 < _4326);
                            if ((_4636 || _4637) | ((_4630 >= _4331) || (_4631 >= _4332))) {
                              _4646 = _4294;
                            } else {
                              _4646 = _4622.x;
                            }
                            _4647 = (_4633 < _4325);
                            if ((_4647 || _4637) | ((_4633 >= _4331) || (_4631 >= _4332))) {
                              _4655 = _4294;
                            } else {
                              _4655 = _4622.y;
                            }
                            _4656 = (_4635 < _4326);
                            if ((_4647 || _4656) | ((_4633 >= _4331) || (_4635 >= _4332))) {
                              _4664 = _4294;
                            } else {
                              _4664 = _4622.z;
                            }
                            if ((_4636 || _4656) | ((_4630 >= _4331) || (_4635 >= _4332))) {
                              _4672 = _4294;
                            } else {
                              _4672 = _4622.w;
                            }
                            _4673 = _4646 - _4274;
                            _4675 = select((_4673 < 0.0f), 0.0f, 1.0f);
                            _4679 = _4655 - _4274;
                            _4681 = select((_4679 < 0.0f), 0.0f, 1.0f);
                            _4685 = _4664 - _4274;
                            _4687 = select((_4685 < 0.0f), 0.0f, 1.0f);
                            _4691 = _4672 - _4274;
                            _4693 = select((_4691 < 0.0f), 0.0f, 1.0f);
                            _4694 = ((((((((((((((_4384 + _4380) + _4390) + _4396) + _4477) + _4483) + _4489) + _4495) + _4576) + _4582) + _4588) + _4594) + _4675) + _4681) + _4687) + _4693;
                            _4705 = (saturate(_4694 * 0.0625f) * 2.0f) + -1.0f;
                            _4711 = float((int)(((int)(uint)((int)(_4705 > 0.0f))) - ((int)(uint)((int)(_4705 < 0.0f)))));
                            _4713 = 1.0f - (_4711 * _4705);
                            _4715 = (_4713 * _4713) * _4713;
                            _5061 = (0.5f - ((_4711 * 0.5f) * ((1.0f - _4715) - ((_4713 - _4715) * saturate(((1.0f / _4274) * (1.0f / _4694)) * ((((((((((((((((_4384 * _4382) + (_4380 * _4378)) + (_4390 * _4388)) + (_4396 * _4394)) + (_4477 * _4475)) + (_4483 * _4481)) + (_4489 * _4487)) + (_4495 * _4493)) + (_4576 * _4574)) + (_4582 * _4580)) + (_4588 * _4586)) + (_4594 * _4592)) + (_4675 * _4673)) + (_4681 * _4679)) + (_4687 * _4685)) + (_4693 * _4691)))))));
                            _5062 = (((float4)(_HeapResource_22.SampleCmpLevelZero(samplerLinearPCFBorderBlackNode, float2(_4263, _4264), _4265))).x);
                            _5063 = 1.0f;
                            _5064 = 1;
                          } else {
                            _4727 = f16tof32(_4085) / _4218;
                            _4730 = mad((_4727 * _4216), 0.5f, 0.5f);
                            _4731 = mad((_4727 * _4217), 0.5f, 0.5f);
                            _4734 = (1.0f - (_4205 * _4103)) + _4121;
                            if (_4205 > -0.0f) {
                              if ((saturate(_4730) == _4730) && (saturate(_4731) == _4731)) {
                                _4745 = (_4730 * _4145) + _4147;
                                _4746 = (_4731 * _4146) + _4148;
                                _4747 = saturate(_4734);
                                _4751 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4760 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_4751 * 32.665000915527344f) + _129), ((_4751 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4761 = sin(_4760);
                                _4762 = cos(_4760);
                                _4763 = cbSharedPerViewData.nFrameCounter & 3;
                                _4768 = sqrt((float((int)(_4763)) * 0.25f) + 0.125f) * _4124;
                                _4777 = (_global_7[min((uint)(((int)(0u + (_4763 * 2)))), 127u)]) * _4768;
                                _4778 = (_global_7[min((uint)(((int)(1u + (_4763 * 2)))), 127u)]) * _4768;
                                _4780 = -0.0f - _4761;
                                _4785 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4777, _4778), float2(_4762, _4761)) + _4745), (dot(float2(_4777, _4778), float2(_4780, _4762)) + _4746)));
                                _4790 = _4785.x - _4747;
                                _4792 = select((_4790 < 0.0f), 0.0f, 1.0f);
                                _4794 = _4785.y - _4747;
                                _4796 = select((_4794 < 0.0f), 0.0f, 1.0f);
                                _4800 = _4785.z - _4747;
                                _4802 = select((_4800 < 0.0f), 0.0f, 1.0f);
                                _4806 = _4785.w - _4747;
                                _4808 = select((_4806 < 0.0f), 0.0f, 1.0f);
                                _4815 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4820 = sqrt((float((int)(_4815)) * 0.25f) + 0.125f) * _4124;
                                _4829 = (_global_7[min((uint)(((int)(0u + (_4815 * 2)))), 127u)]) * _4820;
                                _4830 = (_global_7[min((uint)(((int)(1u + (_4815 * 2)))), 127u)]) * _4820;
                                _4836 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4829, _4830), float2(_4762, _4761)) + _4745), (dot(float2(_4829, _4830), float2(_4780, _4762)) + _4746)));
                                _4841 = _4836.x - _4747;
                                _4843 = select((_4841 < 0.0f), 0.0f, 1.0f);
                                _4847 = _4836.y - _4747;
                                _4849 = select((_4847 < 0.0f), 0.0f, 1.0f);
                                _4853 = _4836.z - _4747;
                                _4855 = select((_4853 < 0.0f), 0.0f, 1.0f);
                                _4859 = _4836.w - _4747;
                                _4861 = select((_4859 < 0.0f), 0.0f, 1.0f);
                                _4868 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _4873 = sqrt((float((int)(_4868)) * 0.25f) + 0.125f) * _4124;
                                _4882 = (_global_7[min((uint)(((int)(0u + (_4868 * 2)))), 127u)]) * _4873;
                                _4883 = (_global_7[min((uint)(((int)(1u + (_4868 * 2)))), 127u)]) * _4873;
                                _4889 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4882, _4883), float2(_4762, _4761)) + _4745), (dot(float2(_4882, _4883), float2(_4780, _4762)) + _4746)));
                                _4894 = _4889.x - _4747;
                                _4896 = select((_4894 < 0.0f), 0.0f, 1.0f);
                                _4900 = _4889.y - _4747;
                                _4902 = select((_4900 < 0.0f), 0.0f, 1.0f);
                                _4906 = _4889.z - _4747;
                                _4908 = select((_4906 < 0.0f), 0.0f, 1.0f);
                                _4912 = _4889.w - _4747;
                                _4914 = select((_4912 < 0.0f), 0.0f, 1.0f);
                                _4921 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _4926 = sqrt((float((int)(_4921)) * 0.25f) + 0.125f) * _4124;
                                _4935 = (_global_7[min((uint)(((int)(0u + (_4921 * 2)))), 127u)]) * _4926;
                                _4936 = (_global_7[min((uint)(((int)(1u + (_4921 * 2)))), 127u)]) * _4926;
                                _4942 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4935, _4936), float2(_4762, _4761)) + _4745), (dot(float2(_4935, _4936), float2(_4780, _4762)) + _4746)));
                                _4947 = _4942.x - _4747;
                                _4949 = select((_4947 < 0.0f), 0.0f, 1.0f);
                                _4953 = _4942.y - _4747;
                                _4955 = select((_4953 < 0.0f), 0.0f, 1.0f);
                                _4959 = _4942.z - _4747;
                                _4961 = select((_4959 < 0.0f), 0.0f, 1.0f);
                                _4965 = _4942.w - _4747;
                                _4967 = select((_4965 < 0.0f), 0.0f, 1.0f);
                                _4968 = ((((((((((((((_4792 + _4796) + _4802) + _4808) + _4843) + _4849) + _4855) + _4861) + _4896) + _4902) + _4908) + _4914) + _4949) + _4955) + _4961) + _4967;
                                _4979 = (saturate(_4968 * 0.0625f) * 2.0f) + -1.0f;
                                _4985 = float((int)(((int)(uint)((int)(_4979 > 0.0f))) - ((int)(uint)((int)(_4979 < 0.0f)))));
                                _4987 = 1.0f - (_4985 * _4979);
                                _4989 = (_4987 * _4987) * _4987;
                                _4997 = -0.0f - _4216;
                                _5004 = saturate((saturate(rsqrt(dot(float3(_4997, _4208, _4205), float3(_4997, _4208, _4205))) * _4205) * _4101) + _4100);
                                _5006 = 1.0f - (_5004 * _5004);
                                _5013 = frac((_4745 * _4149) + 0.5f);
                                _5014 = frac((_4746 * _4150) + 0.5f);
                                _5015 = _4745 + _4151;
                                _5016 = _4746 + _4152;
                                _5018 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5015, _5016), _4734);
                                _5027 = _5015 - (_4151 * 2.0f);
                                _5028 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5027, _5016), _4734);
                                _5033 = 1.0f - _5013;
                                _5039 = _5016 - (_4152 * 2.0f);
                                _5040 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5027, _5039), _4734);
                                _5045 = 1.0f - _5014;
                                _5050 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5015, _5039), _4734);
                                _5061 = (0.5f - ((_4985 * 0.5f) * ((1.0f - _4989) - ((_4987 - _4989) * saturate(((1.0f / _4747) * (1.0f / _4968)) * ((((((((((((((((_4792 * _4790) + (_4796 * _4794)) + (_4802 * _4800)) + (_4808 * _4806)) + (_4843 * _4841)) + (_4849 * _4847)) + (_4855 * _4853)) + (_4861 * _4859)) + (_4896 * _4894)) + (_4902 * _4900)) + (_4908 * _4906)) + (_4914 * _4912)) + (_4949 * _4947)) + (_4955 * _4953)) + (_4961 * _4959)) + (_4967 * _4965)))))));
                                _5062 = ((((mad(mad(_5028.x, _5033, _5028.y), _5014, mad(_5028.w, _5033, _5028.z)) + mad(mad(_5018.y, _5013, _5018.x), _5014, mad(_5018.z, _5013, _5018.w))) + mad(mad(_5040.w, _5033, _5040.z), _5045, mad(_5040.x, _5033, _5040.y))) + mad(mad(_5050.z, _5013, _5050.w), _5045, mad(_5050.y, _5013, _5050.x))) * 0.1111111119389534f);
                                _5063 = (1.0f - (_5006 * _5006));
                                _5064 = 1;
                              } else {
                                _5061 = 1.0f;
                                _5062 = 0.0f;
                                _5063 = 1.0f;
                                _5064 = 0;
                              }
                            } else {
                              _5061 = 1.0f;
                              _5062 = 0.0f;
                              _5063 = 1.0f;
                              _5064 = 0;
                            }
                          }
                        } else {
                          _5061 = 1.0f;
                          _5062 = 1.0f;
                          _5063 = 1.0f;
                          _5064 = 0;
                        }
                        [branch]
                        if (!((_1614 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1614 & 2097152) == 0)) {
                            _5072 = abs(_4216);
                            _5073 = abs(_4217);
                            _5074 = abs(_4218);
                            if (_5072 > max(_5073, _5074)) {
                              _5078 = (_4216 > 0.0f);
                              _5093 = select(_5078, 0.0f, 1.0f);
                              _5094 = 0.0f;
                              _5095 = select(_5078, _4205, _4218);
                              _5096 = _4208;
                              _5097 = _5072;
                            } else {
                              if (_5073 > _5074) {
                                _5084 = (_4208 < -0.0f);
                                _5093 = select(_5084, 0.0f, 1.0f);
                                _5094 = 1.0f;
                                _5095 = _4216;
                                _5096 = select(_5084, _4218, _4205);
                                _5097 = _5073;
                              } else {
                                _5088 = (_4205 < -0.0f);
                                _5093 = select(_5088, 0.0f, 1.0f);
                                _5094 = 2.0f;
                                _5095 = select(_5088, _4216, (-0.0f - _4216));
                                _5096 = _4208;
                                _5097 = _5074;
                              }
                            }
                            _5098 = _5097 * 2.0f;
                            _5103 = -0.0f - _4118;
                            _5112 = ((min(max((_5095 / _5098), _5103), _4118) + _5093) * _4070) + _4072;
                            _5113 = ((min(max((_5096 / _5098), _5103), _4118) + _5094) * _4071) + _4073;
                            _5118 = ((_5093 + -0.5f) * _4070) + _4072;
                            _5119 = ((_5094 + -0.5f) * _4071) + _4073;
                            _5122 = saturate(1.0f - (_5097 * _4103));
                            _5126 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _5135 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_5126 * 32.665000915527344f) + _129), ((_5126 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _5136 = sin(_5135);
                            _5137 = cos(_5135);
                            _5142 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_5112, _5113), 0.0f))).x) > _5122), 1.0f, 0.0f);
                            _5143 = cbSharedPerViewData.nFrameCounter & 3;
                            _5148 = sqrt((float((int)(_5143)) * 0.25f) + 0.125f) * _4125;
                            _5157 = (_global_7[min((uint)(((int)(0u + (_5143 * 2)))), 127u)]) * _5148;
                            _5158 = (_global_7[min((uint)(((int)(1u + (_5143 * 2)))), 127u)]) * _5148;
                            _5160 = -0.0f - _5136;
                            _5162 = dot(float2(_5157, _5158), float2(_5137, _5136)) + _5112;
                            _5163 = dot(float2(_5157, _5158), float2(_5160, _5137)) + _5113;
                            _5165 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5162, _5163));
                            _5169 = _5162 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5170 = _5163 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5173 = floor(_5118 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _5174 = floor(_5119 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _5179 = floor(((_5118 + _4070) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _5180 = floor(((_5119 + _4071) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _5183 = floor(_5169 + -0.5f);
                            _5184 = floor(_5170 + 0.5f);
                            _5186 = floor(_5169 + 0.5f);
                            _5188 = floor(_5170 + -0.5f);
                            _5189 = (_5183 < _5173);
                            _5190 = (_5184 < _5174);
                            if ((_5189 || _5190) | ((_5183 >= _5179) || (_5184 >= _5180))) {
                              _5199 = _5142;
                            } else {
                              _5199 = _5165.x;
                            }
                            _5200 = (_5186 < _5173);
                            if ((_5200 || _5190) | ((_5186 >= _5179) || (_5184 >= _5180))) {
                              _5208 = _5142;
                            } else {
                              _5208 = _5165.y;
                            }
                            _5209 = (_5188 < _5174);
                            if ((_5200 || _5209) | ((_5186 >= _5179) || (_5188 >= _5180))) {
                              _5217 = _5142;
                            } else {
                              _5217 = _5165.z;
                            }
                            if ((_5189 || _5209) | ((_5183 >= _5179) || (_5188 >= _5180))) {
                              _5225 = _5142;
                            } else {
                              _5225 = _5165.w;
                            }
                            _5226 = _5199 - _5122;
                            _5228 = select((_5226 < 0.0f), 0.0f, 1.0f);
                            _5230 = _5208 - _5122;
                            _5232 = select((_5230 < 0.0f), 0.0f, 1.0f);
                            _5236 = _5217 - _5122;
                            _5238 = select((_5236 < 0.0f), 0.0f, 1.0f);
                            _5242 = _5225 - _5122;
                            _5244 = select((_5242 < 0.0f), 0.0f, 1.0f);
                            _5251 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _5256 = sqrt((float((int)(_5251)) * 0.25f) + 0.125f) * _4125;
                            _5265 = (_global_7[min((uint)(((int)(0u + (_5251 * 2)))), 127u)]) * _5256;
                            _5266 = (_global_7[min((uint)(((int)(1u + (_5251 * 2)))), 127u)]) * _5256;
                            _5269 = dot(float2(_5265, _5266), float2(_5137, _5136)) + _5112;
                            _5270 = dot(float2(_5265, _5266), float2(_5160, _5137)) + _5113;
                            _5272 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5269, _5270));
                            _5276 = _5269 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5277 = _5270 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5280 = floor(_5276 + -0.5f);
                            _5281 = floor(_5277 + 0.5f);
                            _5283 = floor(_5276 + 0.5f);
                            _5285 = floor(_5277 + -0.5f);
                            _5286 = (_5280 < _5173);
                            _5287 = (_5281 < _5174);
                            if ((_5286 || _5287) | ((_5280 >= _5179) || (_5281 >= _5180))) {
                              _5296 = _5142;
                            } else {
                              _5296 = _5272.x;
                            }
                            _5297 = (_5283 < _5173);
                            if ((_5297 || _5287) | ((_5283 >= _5179) || (_5281 >= _5180))) {
                              _5305 = _5142;
                            } else {
                              _5305 = _5272.y;
                            }
                            _5306 = (_5285 < _5174);
                            if ((_5297 || _5306) | ((_5283 >= _5179) || (_5285 >= _5180))) {
                              _5314 = _5142;
                            } else {
                              _5314 = _5272.z;
                            }
                            if ((_5286 || _5306) | ((_5280 >= _5179) || (_5285 >= _5180))) {
                              _5322 = _5142;
                            } else {
                              _5322 = _5272.w;
                            }
                            _5323 = _5296 - _5122;
                            _5325 = select((_5323 < 0.0f), 0.0f, 1.0f);
                            _5329 = _5305 - _5122;
                            _5331 = select((_5329 < 0.0f), 0.0f, 1.0f);
                            _5335 = _5314 - _5122;
                            _5337 = select((_5335 < 0.0f), 0.0f, 1.0f);
                            _5341 = _5322 - _5122;
                            _5343 = select((_5341 < 0.0f), 0.0f, 1.0f);
                            _5350 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _5355 = sqrt((float((int)(_5350)) * 0.25f) + 0.125f) * _4125;
                            _5364 = (_global_7[min((uint)(((int)(0u + (_5350 * 2)))), 127u)]) * _5355;
                            _5365 = (_global_7[min((uint)(((int)(1u + (_5350 * 2)))), 127u)]) * _5355;
                            _5368 = dot(float2(_5364, _5365), float2(_5137, _5136)) + _5112;
                            _5369 = dot(float2(_5364, _5365), float2(_5160, _5137)) + _5113;
                            _5371 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5368, _5369));
                            _5375 = _5368 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5376 = _5369 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5379 = floor(_5375 + -0.5f);
                            _5380 = floor(_5376 + 0.5f);
                            _5382 = floor(_5375 + 0.5f);
                            _5384 = floor(_5376 + -0.5f);
                            _5385 = (_5379 < _5173);
                            _5386 = (_5380 < _5174);
                            if ((_5385 || _5386) | ((_5379 >= _5179) || (_5380 >= _5180))) {
                              _5395 = _5142;
                            } else {
                              _5395 = _5371.x;
                            }
                            _5396 = (_5382 < _5173);
                            if ((_5396 || _5386) | ((_5382 >= _5179) || (_5380 >= _5180))) {
                              _5404 = _5142;
                            } else {
                              _5404 = _5371.y;
                            }
                            _5405 = (_5384 < _5174);
                            if ((_5396 || _5405) | ((_5382 >= _5179) || (_5384 >= _5180))) {
                              _5413 = _5142;
                            } else {
                              _5413 = _5371.z;
                            }
                            if ((_5385 || _5405) | ((_5379 >= _5179) || (_5384 >= _5180))) {
                              _5421 = _5142;
                            } else {
                              _5421 = _5371.w;
                            }
                            _5422 = _5395 - _5122;
                            _5424 = select((_5422 < 0.0f), 0.0f, 1.0f);
                            _5428 = _5404 - _5122;
                            _5430 = select((_5428 < 0.0f), 0.0f, 1.0f);
                            _5434 = _5413 - _5122;
                            _5436 = select((_5434 < 0.0f), 0.0f, 1.0f);
                            _5440 = _5421 - _5122;
                            _5442 = select((_5440 < 0.0f), 0.0f, 1.0f);
                            _5449 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _5454 = sqrt((float((int)(_5449)) * 0.25f) + 0.125f) * _4125;
                            _5463 = (_global_7[min((uint)(((int)(0u + (_5449 * 2)))), 127u)]) * _5454;
                            _5464 = (_global_7[min((uint)(((int)(1u + (_5449 * 2)))), 127u)]) * _5454;
                            _5467 = dot(float2(_5463, _5464), float2(_5137, _5136)) + _5112;
                            _5468 = dot(float2(_5463, _5464), float2(_5160, _5137)) + _5113;
                            _5470 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5467, _5468));
                            _5474 = _5467 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5475 = _5468 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5478 = floor(_5474 + -0.5f);
                            _5479 = floor(_5475 + 0.5f);
                            _5481 = floor(_5474 + 0.5f);
                            _5483 = floor(_5475 + -0.5f);
                            _5484 = (_5478 < _5173);
                            _5485 = (_5479 < _5174);
                            if ((_5484 || _5485) | ((_5478 >= _5179) || (_5479 >= _5180))) {
                              _5494 = _5142;
                            } else {
                              _5494 = _5470.x;
                            }
                            _5495 = (_5481 < _5173);
                            if ((_5495 || _5485) | ((_5481 >= _5179) || (_5479 >= _5180))) {
                              _5503 = _5142;
                            } else {
                              _5503 = _5470.y;
                            }
                            _5504 = (_5483 < _5174);
                            if ((_5495 || _5504) | ((_5481 >= _5179) || (_5483 >= _5180))) {
                              _5512 = _5142;
                            } else {
                              _5512 = _5470.z;
                            }
                            if ((_5484 || _5504) | ((_5478 >= _5179) || (_5483 >= _5180))) {
                              _5520 = _5142;
                            } else {
                              _5520 = _5470.w;
                            }
                            _5521 = _5494 - _5122;
                            _5523 = select((_5521 < 0.0f), 0.0f, 1.0f);
                            _5527 = _5503 - _5122;
                            _5529 = select((_5527 < 0.0f), 0.0f, 1.0f);
                            _5533 = _5512 - _5122;
                            _5535 = select((_5533 < 0.0f), 0.0f, 1.0f);
                            _5539 = _5520 - _5122;
                            _5541 = select((_5539 < 0.0f), 0.0f, 1.0f);
                            _5542 = ((((((((((((((_5232 + _5228) + _5238) + _5244) + _5325) + _5331) + _5337) + _5343) + _5424) + _5430) + _5436) + _5442) + _5523) + _5529) + _5535) + _5541;
                            _5553 = (saturate(_5542 * 0.0625f) * 2.0f) + -1.0f;
                            _5559 = float((int)(((int)(uint)((int)(_5553 > 0.0f))) - ((int)(uint)((int)(_5553 < 0.0f)))));
                            _5561 = 1.0f - (_5559 * _5553);
                            _5563 = (_5561 * _5561) * _5561;
                            _5854 = (0.5f - ((_5559 * 0.5f) * ((1.0f - _5563) - ((_5561 - _5563) * saturate(((1.0f / _5122) * (1.0f / _5542)) * ((((((((((((((((_5232 * _5230) + (_5228 * _5226)) + (_5238 * _5236)) + (_5244 * _5242)) + (_5325 * _5323)) + (_5331 * _5329)) + (_5337 * _5335)) + (_5343 * _5341)) + (_5424 * _5422)) + (_5430 * _5428)) + (_5436 * _5434)) + (_5442 * _5440)) + (_5523 * _5521)) + (_5529 * _5527)) + (_5535 * _5533)) + (_5541 * _5539)))))));
                            _5855 = 1.0f;
                            _5856 = false;
                          } else {
                            _5572 = f16tof32(((uint)((uint)(_4085) >> 16))) / _4218;
                            _5575 = mad((_5572 * _4216), 0.5f, 0.5f);
                            _5576 = mad((_5572 * _4217), 0.5f, 0.5f);
                            if (_4205 > -0.0f) {
                              if ((saturate(_5575) == _5575) && (saturate(_5576) == _5576)) {
                                _5589 = (_5575 * _4070) + _4072;
                                _5590 = (_5576 * _4071) + _4073;
                                _5591 = saturate(1.0f - (_4205 * _4103));
                                _5595 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _5604 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_5595 * 32.665000915527344f) + _129), ((_5595 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _5605 = sin(_5604);
                                _5606 = cos(_5604);
                                _5607 = cbSharedPerViewData.nFrameCounter & 3;
                                _5612 = sqrt((float((int)(_5607)) * 0.25f) + 0.125f) * _4125;
                                _5621 = (_global_7[min((uint)(((int)(0u + (_5607 * 2)))), 127u)]) * _5612;
                                _5622 = (_global_7[min((uint)(((int)(1u + (_5607 * 2)))), 127u)]) * _5612;
                                _5624 = -0.0f - _5605;
                                _5629 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5621, _5622), float2(_5606, _5605)) + _5589), (dot(float2(_5621, _5622), float2(_5624, _5606)) + _5590)));
                                _5634 = _5629.x - _5591;
                                _5636 = select((_5634 < 0.0f), 0.0f, 1.0f);
                                _5638 = _5629.y - _5591;
                                _5640 = select((_5638 < 0.0f), 0.0f, 1.0f);
                                _5644 = _5629.z - _5591;
                                _5646 = select((_5644 < 0.0f), 0.0f, 1.0f);
                                _5650 = _5629.w - _5591;
                                _5652 = select((_5650 < 0.0f), 0.0f, 1.0f);
                                _5659 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _5664 = sqrt((float((int)(_5659)) * 0.25f) + 0.125f) * _4125;
                                _5673 = (_global_7[min((uint)(((int)(0u + (_5659 * 2)))), 127u)]) * _5664;
                                _5674 = (_global_7[min((uint)(((int)(1u + (_5659 * 2)))), 127u)]) * _5664;
                                _5680 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5673, _5674), float2(_5606, _5605)) + _5589), (dot(float2(_5673, _5674), float2(_5624, _5606)) + _5590)));
                                _5685 = _5680.x - _5591;
                                _5687 = select((_5685 < 0.0f), 0.0f, 1.0f);
                                _5691 = _5680.y - _5591;
                                _5693 = select((_5691 < 0.0f), 0.0f, 1.0f);
                                _5697 = _5680.z - _5591;
                                _5699 = select((_5697 < 0.0f), 0.0f, 1.0f);
                                _5703 = _5680.w - _5591;
                                _5705 = select((_5703 < 0.0f), 0.0f, 1.0f);
                                _5712 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _5717 = sqrt((float((int)(_5712)) * 0.25f) + 0.125f) * _4125;
                                _5726 = (_global_7[min((uint)(((int)(0u + (_5712 * 2)))), 127u)]) * _5717;
                                _5727 = (_global_7[min((uint)(((int)(1u + (_5712 * 2)))), 127u)]) * _5717;
                                _5733 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5726, _5727), float2(_5606, _5605)) + _5589), (dot(float2(_5726, _5727), float2(_5624, _5606)) + _5590)));
                                _5738 = _5733.x - _5591;
                                _5740 = select((_5738 < 0.0f), 0.0f, 1.0f);
                                _5744 = _5733.y - _5591;
                                _5746 = select((_5744 < 0.0f), 0.0f, 1.0f);
                                _5750 = _5733.z - _5591;
                                _5752 = select((_5750 < 0.0f), 0.0f, 1.0f);
                                _5756 = _5733.w - _5591;
                                _5758 = select((_5756 < 0.0f), 0.0f, 1.0f);
                                _5765 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _5770 = sqrt((float((int)(_5765)) * 0.25f) + 0.125f) * _4125;
                                _5779 = (_global_7[min((uint)(((int)(0u + (_5765 * 2)))), 127u)]) * _5770;
                                _5780 = (_global_7[min((uint)(((int)(1u + (_5765 * 2)))), 127u)]) * _5770;
                                _5786 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5779, _5780), float2(_5606, _5605)) + _5589), (dot(float2(_5779, _5780), float2(_5624, _5606)) + _5590)));
                                _5791 = _5786.x - _5591;
                                _5793 = select((_5791 < 0.0f), 0.0f, 1.0f);
                                _5797 = _5786.y - _5591;
                                _5799 = select((_5797 < 0.0f), 0.0f, 1.0f);
                                _5803 = _5786.z - _5591;
                                _5805 = select((_5803 < 0.0f), 0.0f, 1.0f);
                                _5809 = _5786.w - _5591;
                                _5811 = select((_5809 < 0.0f), 0.0f, 1.0f);
                                _5812 = ((((((((((((((_5636 + _5640) + _5646) + _5652) + _5687) + _5693) + _5699) + _5705) + _5740) + _5746) + _5752) + _5758) + _5793) + _5799) + _5805) + _5811;
                                _5823 = (saturate(_5812 * 0.0625f) * 2.0f) + -1.0f;
                                _5829 = float((int)(((int)(uint)((int)(_5823 > 0.0f))) - ((int)(uint)((int)(_5823 < 0.0f)))));
                                _5831 = 1.0f - (_5829 * _5823);
                                _5833 = (_5831 * _5831) * _5831;
                                _5841 = -0.0f - _4216;
                                _5848 = saturate((saturate(rsqrt(dot(float3(_5841, _4208, _4205), float3(_5841, _4208, _4205))) * _4205) * _4101) + _4100);
                                _5850 = 1.0f - (_5848 * _5848);
                                _5854 = (0.5f - ((_5829 * 0.5f) * ((1.0f - _5833) - ((_5831 - _5833) * saturate(((1.0f / _5591) * (1.0f / _5812)) * ((((((((((((((((_5636 * _5634) + (_5640 * _5638)) + (_5646 * _5644)) + (_5652 * _5650)) + (_5687 * _5685)) + (_5693 * _5691)) + (_5699 * _5697)) + (_5705 * _5703)) + (_5740 * _5738)) + (_5746 * _5744)) + (_5752 * _5750)) + (_5758 * _5756)) + (_5793 * _5791)) + (_5799 * _5797)) + (_5805 * _5803)) + (_5811 * _5809)))))));
                                _5855 = (1.0f - (_5850 * _5850));
                                _5856 = false;
                              } else {
                                _5854 = 1.0f;
                                _5855 = 1.0f;
                                _5856 = true;
                              }
                            } else {
                              _5854 = 1.0f;
                              _5855 = 1.0f;
                              _5856 = true;
                            }
                          }
                        } else {
                          _5854 = 1.0f;
                          _5855 = 1.0f;
                          _5856 = true;
                        }
                        if (_5064 == 0) {
                          if (!_5856) {
                            _5874 = _5061;
                            _5875 = ((_5855 * (_5854 + -1.0f)) + 1.0f);
                            _5876 = 0.0f;
                            _5877 = _5062;
                          } else {
                            _5874 = _5061;
                            _5875 = _5854;
                            _5876 = 0.0f;
                            _5877 = _5062;
                          }
                        } else {
                          if (_5856) {
                            _5874 = ((_5063 * (_5061 + -1.0f)) + 1.0f);
                            _5875 = _5854;
                            _5876 = 1.0f;
                            _5877 = ((_5063 * (_5062 + -1.0f)) + 1.0f);
                          } else {
                            _5874 = _5061;
                            _5875 = _5854;
                            _5876 = (_5063 * f16tof32(_4055));
                            _5877 = _5062;
                          }
                        }
                        _5880 = (_5876 * (_5874 - _5875)) + _5875;
                        [branch]
                        if (!((_1614 & 2048) == 0)) {
                          _5882 = _234 - _4030;
                          _5883 = _235 - _4031;
                          _5884 = _236 - _4032;
                          _5899 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5884, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5883, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5882)));
                          _5902 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _5884, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _5883, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _5882)));
                          _5905 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _5884, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _5883, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _5882)));
                          _5907 = rsqrt(dot(float3(_5899, _5902, _5905), float3(_5899, _5902, _5905)));
                          _5908 = _5907 * _5899;
                          _5909 = _5907 * _5902;
                          _5910 = _5907 * _5905;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_4061) >> 16))];
                          _5918 = (abs(_5909) + abs(_5908)) + abs(_5910);
                          _5919 = _5908 / _5918;
                          _5920 = _5909 / _5918;
                          _5922 = !((_5910 / _5918) >= 0.0f);
                          if (_5922) {
                            _5935 = ((1.0f - abs(_5920)) * select((_5919 >= 0.0f), 1.0f, -1.0f));
                            _5936 = ((1.0f - abs(_5919)) * select((_5920 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _5935 = _5919;
                            _5936 = _5920;
                          }
                          _5942 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5935 * 0.5f) + 0.5f), ((_5936 * 0.5f) + 0.5f)), 0.0f);
                          if (_5942.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_4061 & 65535))];
                            if (_5922) {
                              _5961 = ((1.0f - abs(_5920)) * select((_5919 >= 0.0f), 1.0f, -1.0f));
                              _5962 = ((1.0f - abs(_5919)) * select((_5920 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _5961 = _5919;
                              _5962 = _5920;
                            }
                            _5967 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5961 * 0.5f) + 0.5f), ((_5962 * 0.5f) + 0.5f)), 0.0f);
                            _5987 = mad(saturate(((log2(sqrt(((_5882 * _5882) + (_5883 * _5883)) + (_5884 * _5884))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _5988 = max(9.999999747378752e-06f, _5942.x);
                            _5989 = _5967.x / _5988;
                            _5990 = _5967.y / _5988;
                            _5992 = _5967.w / _5988;
                            _5997 = ((0.375f - _5990) * 4.999999873689376e-06f) + _5990;
                            _6000 = -0.0f - _5989;
                            _6001 = mad(_6000, _5997, (_5967.z / _5988));
                            _6003 = 1.0f / mad(_6000, _5989, _5997);
                            _6004 = _6003 * _6001;
                            _6009 = _5987 - _5989;
                            _6014 = (((_5987 * _5987) - _5997) - (_6004 * _6009)) / mad((-0.0f - _6001), _6004, mad((-0.0f - _5997), _5997, (((0.375f - _5992) * 4.999999873689376e-06f) + _5992)));
                            _6016 = (_6003 * _6009) - (_6014 * _6004);
                            _6019 = 1.0f / _6014;
                            _6020 = _6016 * _6019;
                            _6025 = sqrt(((_6020 * _6020) * 0.25f) - ((1.0f - dot(float2(_6016, _6014), float2(_5989, _5997))) * _6019));
                            _6027 = (_6020 * -0.5f) - _6025;
                            _6029 = _6025 - (_6020 * 0.5f);
                            _6031 = select((_6027 < _5987), 1.0f, 0.0f);
                            _6036 = (_6031 + -0.05000000074505806f) / (_6027 - _5987);
                            _6042 = (((select((_6029 < _5987), 1.0f, 0.0f) - _6031) / (_6029 - _6027)) - _6036) / (_6029 - _5987);
                            _6044 = _6036 - (_6042 * _6027);
                            _6057 = (exp2((_5942.x * -1.4426950216293335f) * saturate((dot(float2(_5989, _5997), float2((_6044 - (_6042 * _5987)), _6042)) + 0.05000000074505806f) - (_6044 * _5987))) * _5880);
                          } else {
                            _6057 = _5880;
                          }
                        } else {
                          _6057 = _5880;
                        }
                        _6063 = (_6057 * _4179);
                        _6064 = (lerp(_6057, _5877, _5876));
                        _6065 = _5876;
                        _6066 = _6057;
                      } else {
                        _6063 = _4179;
                        _6064 = 1.0f;
                        _6065 = 0.0f;
                        _6066 = 1.0f;
                      }
                      [branch]
                      if (!(_4106 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _4106)))];
                        _6078 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_4158, _4025, mad(_4157, _4020, (_4156 * _4015)))), (-0.0f - mad(_4158, _4026, mad(_4157, _4021, (_4156 * _4016)))), (-0.0f - mad(_4158, _4027, mad(_4157, _4022, (_4156 * _4017))))), 0.0f);
                        _6086 = (_6078.x * _4087);
                        _6087 = (_6078.y * _4088);
                        _6088 = (_6078.z * _4090);
                      } else {
                        _6086 = _4087;
                        _6087 = _4088;
                        _6088 = _4090;
                      }
                      _6089 = _6064 * _4179;
                      [branch]
                      if (!(_6063 == 0.0f)) {
                        bool __branch_chain_6091;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _6107 = 0;
                          __branch_chain_6091 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _6107 = 1;
                            __branch_chain_6091 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _6107 = 2;
                              __branch_chain_6091 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _6107 = 3;
                                __branch_chain_6091 = true;
                              } else {
                                _6128 = _6063;
                                __branch_chain_6091 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_6091) {
                          while(true) {
                            _6110 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_67, _68, 0));
                            if (_6107 == 0) {
                              _6124 = _6110.x;
                            } else {
                              if (_6107 == 1) {
                                _6124 = _6110.y;
                              } else {
                                if (_6107 == 2) {
                                  _6124 = _6110.z;
                                } else {
                                  _6124 = _6110.w;
                                }
                              }
                            }
                            _6128 = ((_6124 * _6124) * _4179);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_6128 == 0.0f)) {
                            [branch]
                            if (!(((_4064 & 1) == 0) || (!_4210))) {
                              _6145 = max(max(_6086, _6087), _6088);
                              if (_6145 > 0.0f) {
                                _6155 = saturate(_6086 / _6145);
                                _6156 = saturate(_6087 / _6145);
                                _6157 = saturate(_6088 / _6145);
                              } else {
                                _6155 = _6086;
                                _6156 = _6087;
                                _6157 = _6088;
                              }
                              _6158 = (_6156 < _6157);
                              _6159 = select(_6158, _6157, _6156);
                              _6160 = select(_6158, _6156, _6157);
                              _6161 = select(_6158, -1.0f, 0.0f);
                              _6162 = (_6155 < _6159);
                              _6164 = select(_6162, _6159, _6155);
                              _6165 = select(_6162, _6155, _6159);
                              _6169 = _6164 - select((_6165 < _6160), _6165, _6160);
                              _6175 = abs(select(_6162, (-0.3333333432674408f - _6161), _6161) + ((_6165 - _6160) / ((_6169 * 6.0f) + 9.999999682655225e-21f)));
                              if (_6175 < 0.6666666865348816f) {
                                _6188 = ((saturate(((float)((uint)((uint)(((uint)(_4064) >> 9) & 255)))) * 0.003921499941498041f) * (select((_6175 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _6175)) + _6175);
                              } else {
                                _6188 = _6175;
                              }
                              _6189 = saturate((_6169 / (_6164 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_4064) >> 1) & 255)))) * 0.003921499941498041f));
                              _6190 = saturate(_6164);
                              if (!(_6189 <= 0.0f)) {
                                _6193 = saturate(_6188);
                                _6197 = select(((_6193 * 360.0f) >= 360.0f), 0.0f, (_6193 * 6.0f));
                                _6198 = int(_6197);
                                _6200 = _6197 - float((int)(_6198));
                                _6202 = _6190 * (1.0f - _6189);
                                _6205 = (1.0f - (_6200 * _6189)) * _6190;
                                _6209 = (1.0f - ((1.0f - _6200) * _6189)) * _6190;
                                switch (_6198) {
                                  case 0: {
                                    _6217 = _6190;
                                    _6218 = _6209;
                                    _6219 = _6202;
                                    break;
                                  }
                                  case 1: {
                                    _6217 = _6205;
                                    _6218 = _6190;
                                    _6219 = _6202;
                                    break;
                                  }
                                  case 2: {
                                    _6217 = _6202;
                                    _6218 = _6190;
                                    _6219 = _6209;
                                    break;
                                  }
                                  case 3: {
                                    _6217 = _6202;
                                    _6218 = _6205;
                                    _6219 = _6190;
                                    break;
                                  }
                                  case 4: {
                                    _6217 = _6209;
                                    _6218 = _6202;
                                    _6219 = _6190;
                                    break;
                                  }
                                  case 5: {
                                    _6217 = _6190;
                                    _6218 = _6202;
                                    _6219 = _6205;
                                    break;
                                  }
                                  default: {
                                    _6217 = 0.0f;
                                    _6218 = 0.0f;
                                    _6219 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _6217 = _6190;
                                _6218 = _6190;
                                _6219 = _6190;
                              }
                              _6220 = _6217 * _6145;
                              _6221 = _6218 * _6145;
                              _6222 = _6219 * _6145;
                              _6224 = saturate(_6066 * 1.0101009607315063f);
                              _6235 = ((_6224 * (_6086 - _6220)) + _6220);
                              _6236 = ((_6224 * (_6087 - _6221)) + _6221);
                              _6237 = (lerp(_6222, _6088, _6224));
                            } else {
                              _6235 = _6086;
                              _6236 = _6087;
                              _6237 = _6088;
                            }
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _6244 = srvLightMappingData[_1617];
                              if (!(_6244 == -1)) {
                                _6249 = srvLightIndexData[_6244].nLayerIndex;
                                _6251 = srvLightIndexData[_6244].vAtlasOrigin.x;
                                _6252 = srvLightIndexData[_6244].vAtlasOrigin.y;
                                _6254 = srvLightIndexData[_6244].vScreenOrigin.x;
                                _6255 = srvLightIndexData[_6244].vScreenOrigin.y;
                                _6264 = ((int)(_6249 * 5)) & 31;
                                _6267 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6251 + _67) - _6254)), ((int)((_6252 + _68) - _6255)), 0)))).x) & ((int)(31 << _6264)))) >> _6264;
                                _6277 = ((_6089 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_6267) >> 1)))));
                                _6278 = (((float)((bool)(uint)((_6267 & 1) != 0))) * _6089);
                              } else {
                                _6277 = _6089;
                                _6278 = _6089;
                              }
                            } else {
                              _6277 = _6089;
                              _6278 = _6089;
                            }
                            _6282 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _6285 = select(_6282, (_6277 * _1267), _6277);
                            _6287 = _4162 * _4161;
                            _6288 = _4163 * _4161;
                            _6289 = _4164 * _4161;
                            _6290 = _4095 * _4035;
                            _6291 = _4095 * _4036;
                            _6292 = _4095 * _4037;
                            _6293 = _6287 + _6290;
                            _6294 = _6288 + _6291;
                            _6295 = _6289 + _6292;
                            _6297 = -0.0f - _449;
                            _6298 = -0.0f - _450;
                            _6299 = -0.0f - _448;
                            if (_4095 > 0.0f) {
                              _6305 = dot(float3(_6297, _6298, _6299), float3(_200, _202, _204)) * 2.0f;
                              _6309 = _6297 - (_6305 * _200);
                              _6310 = _6298 - (_6305 * _202);
                              _6311 = _6299 - (_6305 * _204);
                              _6312 = (_6287 - _6290) - _6293;
                              _6313 = (_6288 - _6291) - _6294;
                              _6314 = (_6289 - _6292) - _6295;
                              _6315 = dot(float3(_6309, _6310, _6311), float3(_6312, _6313, _6314));
                              _6321 = sqrt(((_6312 * _6312) + (_6313 * _6313)) + (_6314 * _6314));
                              _6330 = saturate(((dot(float3(_6309, _6310, _6311), float3(_6293, _6294, _6295)) * _6315) - dot(float3(_6293, _6294, _6295), float3(_6312, _6313, _6314))) / ((_6321 * _6321) - (_6315 * _6315)));
                              _6334 = (_6330 * _6312) + _6293;
                              _6335 = (_6330 * _6313) + _6294;
                              _6336 = (_6330 * _6314) + _6295;
                              _6337 = dot(float3(_6334, _6335, _6336), float3(_6309, _6310, _6311));
                              _6341 = (_6337 * _6309) - _6334;
                              _6342 = (_6337 * _6310) - _6335;
                              _6343 = (_6337 * _6311) - _6336;
                              _6351 = saturate(0.009999999776482582f / sqrt(((_6341 * _6341) + (_6342 * _6342)) + (_6343 * _6343)));
                              _6359 = ((_6351 * _6341) + _6334);
                              _6360 = ((_6351 * _6342) + _6335);
                              _6361 = ((_6351 * _6343) + _6336);
                            } else {
                              _6359 = _6293;
                              _6360 = _6294;
                              _6361 = _6295;
                            }
                            _6363 = rsqrt(dot(float3(_6359, _6360, _6361), float3(_6359, _6360, _6361)));
                            _6364 = _6363 * _6359;
                            _6365 = _6363 * _6360;
                            _6366 = _6363 * _6361;
                            _6368 = rsqrt(dot(float3(_6287, _6288, _6289), float3(_6287, _6288, _6289)));
                            _6369 = _6368 * _6287;
                            _6370 = _6368 * _6288;
                            _6371 = _6368 * _6289;
                            _6373 = saturate(dot(float3(_200, _202, _204), float3(_6369, _6370, _6371)));
                            _6376 = uint((_180 * 255.0f) + 0.5f);
                            _6385 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                            _6386 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                            _6387 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                            _6400 = ((dot(float3(_201, _203, _205), float3(_6369, _6370, _6371)) + dot(float3(_6297, _6298, _6299), float3(_6369, _6370, _6371))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_200, _202, _204), float3(_449, _450, _448)))) * (11.0f - (((float)((uint)((uint)((uint)(_6376) >> 2)))) * 0.1666666716337204f)));
                            _6407 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                            _6410 = saturate((_6407 + -0.009999999776482582f) * -100.0f);
                            _6415 = ((_6410 * _6410) * 3.0f) * (3.0f - (_6410 * 2.0f));
                            _6422 = 10.0f - (exp2(log2(saturate(_6407 * 5.0f)) * 3.0f) * 9.0f);
                            _6423 = saturate(_6373 + _6385) * _6373;
                            _6424 = saturate(_6373 + _6386) * _6373;
                            _6425 = saturate(_6373 + _6387) * _6373;
                            _6447 = _6364 + _449;
                            _6448 = _6365 + _450;
                            _6449 = _6366 + _448;
                            _6451 = rsqrt(dot(float3(_6447, _6448, _6449), float3(_6447, _6448, _6449)));
                            if (!(select(((_222 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                              _6466 = rsqrt(dot(float3(_200, _202, _204), float3(_200, _202, _204)));
                              _6467 = _6466 * _200;
                              _6468 = _6466 * _202;
                              _6469 = _6466 * _204;
                              _6472 = (abs(_6467) < abs(_6468));
                              _6473 = select(_6472, 1.0f, 0.0f);
                              _6474 = select(_6472, 0.0f, 1.0f);
                              _6475 = _6474 * _6469;
                              _6477 = -0.0f - (_6469 * _6473);
                              _6480 = (_6473 * _6468) - (_6474 * _6467);
                              _6482 = rsqrt(dot(float3(_6475, _6477, _6480), float3(_6475, _6477, _6480)));
                              _6483 = _6475 * _6482;
                              _6484 = _6482 * _6477;
                              _6485 = _6480 * _6482;
                              _6488 = (_6484 * _6469) - (_6485 * _6468);
                              _6491 = (_6485 * _6467) - (_6483 * _6469);
                              _6494 = (_6483 * _6468) - (_6484 * _6467);
                              _6496 = rsqrt(dot(float3(_6488, _6491, _6494), float3(_6488, _6491, _6494)));
                              _6500 = _178 * 4.0f;
                              _6509 = saturate(abs(_6500 + -2.5f) + -0.5f) + -0.5f;
                              _6510 = saturate(1.5f - abs(_6500 + -1.5f)) + -0.5f;
                              _6512 = rsqrt(dot(float2(_6509, _6510), float2(_6509, _6510)));
                              _6513 = _6512 * _6509;
                              _6514 = _6512 * _6510;
                              _6521 = ((_6488 * _6496) * _6513) + (_6514 * _6483);
                              _6522 = ((_6491 * _6496) * _6513) + (_6514 * _6484);
                              _6523 = ((_6494 * _6496) * _6513) + (_6514 * _6485);
                              _6524 = dot(float3(_449, _450, _448), float3(_6364, _6365, _6366));
                              _6527 = min(max(dot(float3(_6521, _6522, _6523), float3(_6364, _6365, _6366)), -1.0f), 1.0f);
                              _6530 = min(max(dot(float3(_6521, _6522, _6523), float3(_449, _450, _448)), -1.0f), 1.0f);
                              _6531 = abs(_6530);
                              _6536 = (1.5707963705062866f - (_6531 * 0.1565829962491989f)) * sqrt(1.0f - _6531);
                              _6540 = abs(_6527);
                              _6545 = (1.5707963705062866f - (_6540 * 0.1565829962491989f)) * sqrt(1.0f - _6540);
                              _6552 = cos(abs(select((_6527 >= 0.0f), _6545, (3.1415927410125732f - _6545)) - select((_6530 >= 0.0f), _6536, (3.1415927410125732f - _6536))) * 0.5f);
                              _6556 = _6364 - (_6527 * _6521);
                              _6557 = _6365 - (_6527 * _6522);
                              _6558 = _6366 - (_6527 * _6523);
                              _6562 = _449 - (_6530 * _6521);
                              _6563 = _450 - (_6530 * _6522);
                              _6564 = _448 - (_6530 * _6523);
                              _6571 = rsqrt((dot(float3(_6562, _6563, _6564), float3(_6562, _6563, _6564)) * dot(float3(_6556, _6557, _6558), float3(_6556, _6557, _6558))) + 9.999999747378752e-05f) * dot(float3(_6556, _6557, _6558), float3(_6562, _6563, _6564));
                              _6575 = sqrt(saturate((_6571 * 0.5f) + 0.5f));
                              _6579 = _219 * _219;
                              _6580 = _6579 * 0.5f;
                              _6581 = _6579 * 2.0f;
                              _6585 = exp2((1.0f - abs(_6065)) * -72.13475036621094f);
                              if (!((_6376 & 1) == 0)) {
                                _6592 = select(((select(((_6376 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_6065 == -1.0f))), 0.0f, _6585);
                              } else {
                                _6592 = _6585;
                              }
                              _6596 = saturate((dot(float3(_200, _202, _204), float3(_6364, _6365, _6366)) + 0.5f) * 0.6666666865348816f);
                              _6606 = (_6530 + _6527) + ((((_6575 * 0.9975510239601135f) * sqrt(1.0f - (_6530 * _6530))) - (_6530 * 0.06994284689426422f)) * 0.13988569378852844f);
                              _6608 = (_6579 * 1.4142135381698608f) * _6575;
                              _6621 = 1.0f - sqrt(saturate((_6524 * 0.5f) + 0.5f));
                              _6622 = _6621 * _6621;
                              _6628 = saturate(-0.0f - _6524);
                              _6631 = (1.0f - saturate(_6628)) * _6596;
                              _6640 = ((((_6575 * 0.5f) * (exp2((((_6606 * _6606) * -0.5f) / (_6608 * _6608)) * 1.4426950216293335f) / (_6608 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_6622 * _6622) * (_6621 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_6631, 1.0f, _6592));
                              _6642 = (_6527 + -0.03500000014901161f) + _6530;
                              _6651 = 1.0f / ((1.190000057220459f / _6552) + (_6552 * 0.36000001430511475f));
                              _6656 = ((_6651 * (0.6000000238418579f - (_6571 * 0.800000011920929f))) + 1.0f) * _6575;
                              _6662 = 1.0f - (sqrt(saturate(1.0f - (_6656 * _6656))) * _6552);
                              _6663 = _6662 * _6662;
                              _6667 = 0.9534794092178345f - ((_6663 * _6663) * (_6662 * 0.9534794092178345f));
                              _6668 = _6656 * _6651;
                              _6673 = (sqrt(1.0f - (_6668 * _6668)) * 0.5f) / _6552;
                              _6692 = 1.0f - saturate((_6628 + -0.44999998807907104f) * 2.222222328186035f);
                              _6695 = ((1.0f - _6596) * _6592) + _6596;
                              _6698 = ((_6667 * _6667) * (exp2((((_6642 * _6642) * -0.5f) / (_6580 * _6580)) * 1.4426950216293335f) / (_6579 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_6571 * 5.2658371925354f));
                              _6712 = (_6527 + -0.14000000059604645f) + _6530;
                              _6722 = 1.0f - (_6552 * 0.5f);
                              _6723 = _6722 * _6722;
                              _6727 = (_6723 * _6723) * (0.9534794092178345f - (_6552 * 0.47673970460891724f));
                              _6729 = 0.9534794092178345f - _6727;
                              _6731 = (_6729 * _6729) * (_6727 + 0.04652056470513344f);
                              _6734 = exp2((_6571 * 24.525815963745117f) + -24.208423614501953f);
                              _6747 = ((exp2((((_6712 * _6712) * -0.5f) / (_6581 * _6581)) * 1.4426950216293335f) / (_6579 * 5.013256549835205f)) * (lerp(_6731, 1.0f, _172))) * (((exp2((saturate(dot(float3((_6451 * _6447), (_6451 * _6448), (_6451 * _6449)), float3(_200, _202, _204))) * 17.312339782714844f) + -14.109557151794434f) - _6734) * _172) + _6734);
                              _6755 = (((((exp2(log2(max(_168, 0.0f)) * _6673) * _6695) * _6698) * _6692) + _6640) + (_6747 * _168));
                              _6756 = (((((exp2(log2(max(_169, 0.0f)) * _6673) * _6695) * _6698) * _6692) + _6640) + (_6747 * _169));
                              _6757 = (((((exp2(log2(max(_170, 0.0f)) * _6673) * _6695) * _6698) * _6692) + _6640) + (_6747 * _170));
                            } else {
                              _6755 = 0.0f;
                              _6756 = 0.0f;
                              _6757 = 0.0f;
                            }
                            _6758 = _6235 * _1665;
                            _6759 = _6236 * _1665;
                            _6760 = _6237 * _1665;
                            _6767 = ((_6285 * _6758) * ((max(((_6415 + _6385) * _6400), 0.0f) * _6422) + sqrt(_6423 * _6423))) + _1602;
                            _6768 = ((_6285 * _6759) * ((max(((_6415 + _6386) * _6400), 0.0f) * _6422) + sqrt(_6424 * _6424))) + _1603;
                            _6769 = ((_6285 * _6760) * ((max(((_6415 + _6387) * _6400), 0.0f) * _6422) + sqrt(_6425 * _6425))) + _1604;
                            if (_4094 > 0.0f) {
                              _6773 = (_4094 * _1358) * select(_6282, (_6278 * _1267), _6278);
                              _9575 = _6767;
                              _9576 = _6768;
                              _9577 = _6769;
                              _9578 = (((_6773 * _6758) * _6755) + _1605);
                              _9579 = (((_6773 * _6759) * _6756) + _1606);
                              _9580 = (((_6773 * _6760) * _6757) + _1607);
                            } else {
                              _9575 = _6767;
                              _9576 = _6768;
                              _9577 = _6769;
                              _9578 = _1605;
                              _9579 = _1606;
                              _9580 = _1607;
                            }
                          } else {
                            _9575 = _1602;
                            _9576 = _1603;
                            _9577 = _1604;
                            _9578 = _1605;
                            _9579 = _1606;
                            _9580 = _1607;
                          }
                          break;
                        }
                      } else {
                        _9575 = _1602;
                        _9576 = _1603;
                        _9577 = _1604;
                        _9578 = _1605;
                        _9579 = _1606;
                        _9580 = _1607;
                      }
                    } else {
                      if (_1648 == 8) {
                        _6788 = asfloat(srvLightInfoProperties.Load3(_1616)).x;
                        _6789 = asfloat(srvLightInfoProperties.Load3(_1616)).y;
                        _6790 = asfloat(srvLightInfoProperties.Load3(_1616)).z;
                        _6793 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 12u)))).x;
                        _6794 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 12u)))).y;
                        _6795 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 12u)))).z;
                        _6798 = asfloat(srvLightInfoProperties.Load(((int)(_1616 + 24u))));
                        _6801 = asint(srvLightInfoProperties.Load(((int)(_1616 + 28u))));
                        _6804 = asint(srvLightInfoProperties.Load(((int)(_1616 + 32u))));
                        _6807 = asint(srvLightInfoProperties.Load(((int)(_1616 + 44u))));
                        _6816 = ((float)((uint)((uint)(((uint)(_6804) >> 8) & 255)))) * 0.003921499941498041f;
                        _6819 = f16tof32(_6807);
                        _6826 = min(max(dot(float3((_234 - _6788), (_235 - _6789), (_236 - _6790)), float3(_6793, _6794, _6795)), (-0.0f - _6798)), _6798);
                        _6831 = (_6788 - _234) + (_6826 * _6793);
                        _6833 = (_6789 - _235) + (_6826 * _6794);
                        _6835 = (_6790 + _233) + (_6826 * _6795);
                        _6836 = dot(float3(_6831, _6833, _6835), float3(_6831, _6833, _6835));
                        _6837 = rsqrt(_6836);
                        _6839 = _6831 * _6837;
                        _6840 = _6833 * _6837;
                        _6841 = _6835 * _6837;
                        _6844 = max(0.0f, ((_6837 * _6836) - abs(_6819)));
                        _6845 = _6844 * f16tof32(((uint)((uint)(_6807) >> 16)));
                        _6846 = _6845 * _6845;
                        _6849 = saturate(1.0f - (_6846 * _6846));
                        _6856 = (_6849 * _6849) / (select((_6819 < 0.0f), (_6846 * 16.0f), (_6844 * _6844)) + 1.0f);
                        [branch]
                        if (!(_6856 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _6865 = srvLightMappingData[_1617];
                            if (!(_6865 == -1)) {
                              _6870 = srvLightIndexData[_6865].nLayerIndex;
                              _6872 = srvLightIndexData[_6865].vAtlasOrigin.x;
                              _6873 = srvLightIndexData[_6865].vAtlasOrigin.y;
                              _6875 = srvLightIndexData[_6865].vScreenOrigin.x;
                              _6876 = srvLightIndexData[_6865].vScreenOrigin.y;
                              _6885 = ((int)(_6870 * 5)) & 31;
                              _6888 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6872 + _67) - _6875)), ((int)((_6873 + _68) - _6876)), 0)))).x) & ((int)(31 << _6885)))) >> _6885;
                              _6898 = ((_6856 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_6888) >> 1)))));
                              _6899 = (((float)((bool)(uint)((_6888 & 1) != 0))) * _6856);
                            } else {
                              _6898 = _6856;
                              _6899 = _6856;
                            }
                          } else {
                            _6898 = _6856;
                            _6899 = _6856;
                          }
                          _6903 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _6906 = select(_6903, (_6898 * _1267), _6898);
                          _6908 = dot(float3(_200, _202, _204), float3(_6839, _6840, _6841));
                          _6909 = saturate(_6908);
                          _6912 = uint((_180 * 255.0f) + 0.5f);
                          _6921 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                          _6922 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                          _6923 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                          _6939 = ((dot(float3(_201, _203, _205), float3(_6839, _6840, _6841)) + dot(float3((-0.0f - _449), (-0.0f - _450), (-0.0f - _448)), float3(_6839, _6840, _6841))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_200, _202, _204), float3(_449, _450, _448)))) * (11.0f - (((float)((uint)((uint)((uint)(_6912) >> 2)))) * 0.1666666716337204f)));
                          _6946 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                          _6949 = saturate((_6946 + -0.009999999776482582f) * -100.0f);
                          _6954 = ((_6949 * _6949) * 3.0f) * (3.0f - (_6949 * 2.0f));
                          _6961 = 10.0f - (exp2(log2(saturate(_6946 * 5.0f)) * 3.0f) * 9.0f);
                          _6962 = saturate(_6909 + _6921) * _6909;
                          _6963 = saturate(_6909 + _6922) * _6909;
                          _6964 = saturate(_6909 + _6923) * _6909;
                          _6986 = _6839 + _449;
                          _6987 = _6840 + _450;
                          _6988 = _6841 + _448;
                          _6990 = rsqrt(dot(float3(_6986, _6987, _6988), float3(_6986, _6987, _6988)));
                          if (!(select(((_222 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                            _7002 = rsqrt(dot(float3(_200, _202, _204), float3(_200, _202, _204)));
                            _7003 = _7002 * _200;
                            _7004 = _7002 * _202;
                            _7005 = _7002 * _204;
                            _7008 = (abs(_7003) < abs(_7004));
                            _7009 = select(_7008, 1.0f, 0.0f);
                            _7010 = select(_7008, 0.0f, 1.0f);
                            _7011 = _7010 * _7005;
                            _7013 = -0.0f - (_7005 * _7009);
                            _7016 = (_7009 * _7004) - (_7010 * _7003);
                            _7018 = rsqrt(dot(float3(_7011, _7013, _7016), float3(_7011, _7013, _7016)));
                            _7019 = _7011 * _7018;
                            _7020 = _7018 * _7013;
                            _7021 = _7016 * _7018;
                            _7024 = (_7020 * _7005) - (_7021 * _7004);
                            _7027 = (_7021 * _7003) - (_7019 * _7005);
                            _7030 = (_7019 * _7004) - (_7020 * _7003);
                            _7032 = rsqrt(dot(float3(_7024, _7027, _7030), float3(_7024, _7027, _7030)));
                            _7036 = _178 * 4.0f;
                            _7045 = saturate(abs(_7036 + -2.5f) + -0.5f) + -0.5f;
                            _7046 = saturate(1.5f - abs(_7036 + -1.5f)) + -0.5f;
                            _7048 = rsqrt(dot(float2(_7045, _7046), float2(_7045, _7046)));
                            _7049 = _7048 * _7045;
                            _7050 = _7048 * _7046;
                            _7057 = ((_7024 * _7032) * _7049) + (_7050 * _7019);
                            _7058 = ((_7027 * _7032) * _7049) + (_7050 * _7020);
                            _7059 = ((_7030 * _7032) * _7049) + (_7050 * _7021);
                            _7060 = dot(float3(_449, _450, _448), float3(_6839, _6840, _6841));
                            _7063 = min(max(dot(float3(_7057, _7058, _7059), float3(_6839, _6840, _6841)), -1.0f), 1.0f);
                            _7066 = min(max(dot(float3(_7057, _7058, _7059), float3(_449, _450, _448)), -1.0f), 1.0f);
                            _7067 = abs(_7066);
                            _7072 = (1.5707963705062866f - (_7067 * 0.1565829962491989f)) * sqrt(1.0f - _7067);
                            _7076 = abs(_7063);
                            _7081 = (1.5707963705062866f - (_7076 * 0.1565829962491989f)) * sqrt(1.0f - _7076);
                            _7088 = cos(abs(select((_7063 >= 0.0f), _7081, (3.1415927410125732f - _7081)) - select((_7066 >= 0.0f), _7072, (3.1415927410125732f - _7072))) * 0.5f);
                            _7092 = _6839 - (_7063 * _7057);
                            _7093 = _6840 - (_7063 * _7058);
                            _7094 = _6841 - (_7063 * _7059);
                            _7098 = _449 - (_7066 * _7057);
                            _7099 = _450 - (_7066 * _7058);
                            _7100 = _448 - (_7066 * _7059);
                            _7107 = rsqrt((dot(float3(_7098, _7099, _7100), float3(_7098, _7099, _7100)) * dot(float3(_7092, _7093, _7094), float3(_7092, _7093, _7094))) + 9.999999747378752e-05f) * dot(float3(_7092, _7093, _7094), float3(_7098, _7099, _7100));
                            _7111 = sqrt(saturate((_7107 * 0.5f) + 0.5f));
                            _7115 = _219 * _219;
                            _7116 = _7115 * 0.5f;
                            _7117 = _7115 * 2.0f;
                            _7118 = select(((_6912 & 1) != 0), 0.0f, 1.9287520390554007e-22f);
                            _7121 = saturate((_6908 + 0.5f) * 0.6666666865348816f);
                            _7131 = (_7066 + _7063) + ((((_7111 * 0.9975510239601135f) * sqrt(1.0f - (_7066 * _7066))) - (_7066 * 0.06994284689426422f)) * 0.13988569378852844f);
                            _7133 = (_7115 * 1.4142135381698608f) * _7111;
                            _7146 = 1.0f - sqrt(saturate((_7060 * 0.5f) + 0.5f));
                            _7147 = _7146 * _7146;
                            _7153 = saturate(-0.0f - _7060);
                            _7156 = (1.0f - saturate(_7153)) * _7121;
                            _7165 = ((((_7111 * 0.5f) * (exp2((((_7131 * _7131) * -0.5f) / (_7133 * _7133)) * 1.4426950216293335f) / (_7133 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_7147 * _7147) * (_7146 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_7156, 1.0f, _7118));
                            _7167 = (_7063 + -0.03500000014901161f) + _7066;
                            _7176 = 1.0f / ((1.190000057220459f / _7088) + (_7088 * 0.36000001430511475f));
                            _7181 = ((_7176 * (0.6000000238418579f - (_7107 * 0.800000011920929f))) + 1.0f) * _7111;
                            _7187 = 1.0f - (sqrt(saturate(1.0f - (_7181 * _7181))) * _7088);
                            _7188 = _7187 * _7187;
                            _7192 = 0.9534794092178345f - ((_7188 * _7188) * (_7187 * 0.9534794092178345f));
                            _7193 = _7181 * _7176;
                            _7198 = (sqrt(1.0f - (_7193 * _7193)) * 0.5f) / _7088;
                            _7217 = 1.0f - saturate((_7153 + -0.44999998807907104f) * 2.222222328186035f);
                            _7220 = ((1.0f - _7121) * _7118) + _7121;
                            _7223 = ((_7192 * _7192) * (exp2((((_7167 * _7167) * -0.5f) / (_7116 * _7116)) * 1.4426950216293335f) / (_7115 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_7107 * 5.2658371925354f));
                            _7237 = (_7063 + -0.14000000059604645f) + _7066;
                            _7247 = 1.0f - (_7088 * 0.5f);
                            _7248 = _7247 * _7247;
                            _7252 = (_7248 * _7248) * (0.9534794092178345f - (_7088 * 0.47673970460891724f));
                            _7254 = 0.9534794092178345f - _7252;
                            _7256 = (_7254 * _7254) * (_7252 + 0.04652056470513344f);
                            _7259 = exp2((_7107 * 24.525815963745117f) + -24.208423614501953f);
                            _7272 = ((exp2((((_7237 * _7237) * -0.5f) / (_7117 * _7117)) * 1.4426950216293335f) / (_7115 * 5.013256549835205f)) * (lerp(_7256, 1.0f, _172))) * (((exp2((saturate(dot(float3((_6990 * _6986), (_6990 * _6987), (_6990 * _6988)), float3(_200, _202, _204))) * 17.312339782714844f) + -14.109557151794434f) - _7259) * _172) + _7259);
                            _7280 = (((((exp2(log2(max(_168, 0.0f)) * _7198) * _7220) * _7223) * _7217) + _7165) + (_7272 * _168));
                            _7281 = (((((exp2(log2(max(_169, 0.0f)) * _7198) * _7220) * _7223) * _7217) + _7165) + (_7272 * _169));
                            _7282 = (((((exp2(log2(max(_170, 0.0f)) * _7198) * _7220) * _7223) * _7217) + _7165) + (_7272 * _170));
                          } else {
                            _7280 = 0.0f;
                            _7281 = 0.0f;
                            _7282 = 0.0f;
                          }
                          _7283 = f16tof32(((uint)((uint)(_6801) >> 16))) * _1665;
                          _7284 = f16tof32(_6801) * _1665;
                          _7285 = f16tof32(((uint)((uint)(_6804) >> 16))) * _1665;
                          _7292 = ((_6906 * _7283) * ((max(((_6954 + _6921) * _6939), 0.0f) * _6961) + sqrt(_6962 * _6962))) + _1602;
                          _7293 = ((_6906 * _7284) * ((max(((_6954 + _6922) * _6939), 0.0f) * _6961) + sqrt(_6963 * _6963))) + _1603;
                          _7294 = ((_6906 * _7285) * ((max(((_6954 + _6923) * _6939), 0.0f) * _6961) + sqrt(_6964 * _6964))) + _1604;
                          if (_6816 > 0.0f) {
                            _7298 = (_6816 * _1358) * select(_6903, (_6899 * _1267), _6899);
                            _9575 = _7292;
                            _9576 = _7293;
                            _9577 = _7294;
                            _9578 = (((_7298 * _7283) * _7280) + _1605);
                            _9579 = (((_7298 * _7284) * _7281) + _1606);
                            _9580 = (((_7298 * _7285) * _7282) + _1607);
                          } else {
                            _9575 = _7292;
                            _9576 = _7293;
                            _9577 = _7294;
                            _9578 = _1605;
                            _9579 = _1606;
                            _9580 = _1607;
                          }
                        } else {
                          _9575 = _1602;
                          _9576 = _1603;
                          _9577 = _1604;
                          _9578 = _1605;
                          _9579 = _1606;
                          _9580 = _1607;
                        }
                      } else {
                        if (_1648 == 9) {
                          _7313 = asfloat(srvLightInfoProperties.Load4(_1616)).x;
                          _7314 = asfloat(srvLightInfoProperties.Load4(_1616)).y;
                          _7315 = asfloat(srvLightInfoProperties.Load4(_1616)).w;
                          _7318 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).x;
                          _7319 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).y;
                          _7320 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).w;
                          _7323 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).x;
                          _7324 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).y;
                          _7325 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).w;
                          _7328 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 48u)))).x;
                          _7329 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 48u)))).y;
                          _7330 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 48u)))).w;
                          _7333 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 64u)))).x;
                          _7334 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 64u)))).y;
                          _7335 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 64u)))).z;
                          _7338 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 76u)))).x;
                          _7339 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 76u)))).y;
                          _7340 = asfloat(srvLightInfoProperties.Load3(((int)(_1616 + 76u)))).z;
                          _7343 = asint(srvLightInfoProperties.Load(((int)(_1616 + 88u))));
                          _7346 = asint(srvLightInfoProperties.Load(((int)(_1616 + 92u))));
                          _7349 = asint(srvLightInfoProperties.Load(((int)(_1616 + 100u))));
                          _7352 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).x;
                          _7353 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).y;
                          _7354 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).z;
                          _7355 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 108u)))).w;
                          _7358 = asint(srvLightInfoProperties.Load(((int)(_1616 + 124u))));
                          _7361 = asint(srvLightInfoProperties.Load(((int)(_1616 + 128u))));
                          _7364 = asint(srvLightInfoProperties.Load(((int)(_1616 + 132u))));
                          _7367 = asint(srvLightInfoProperties.Load(((int)(_1616 + 136u))));
                          _7370 = asint(srvLightInfoProperties.Load(((int)(_1616 + 140u))));
                          _7373 = asint(srvLightInfoProperties.Load(((int)(_1616 + 144u))));
                          _7376 = asint(srvLightInfoProperties.Load(((int)(_1616 + 148u))));
                          _7379 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 152u)))).x;
                          _7380 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 152u)))).y;
                          _7381 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 152u)))).z;
                          _7382 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 152u)))).w;
                          _7385 = asint(srvLightInfoProperties.Load(((int)(_1616 + 168u))));
                          _7388 = asint(srvLightInfoProperties.Load(((int)(_1616 + 172u))));
                          _7391 = asint(srvLightInfoProperties.Load(((int)(_1616 + 180u))));
                          _7393 = f16tof32(((uint)((uint)(_7343) >> 16)));
                          _7394 = f16tof32(_7343);
                          _7396 = f16tof32(((uint)((uint)(_7346) >> 16)));
                          _7400 = ((float)((uint)((uint)(((uint)(_7346) >> 8) & 255)))) * 0.003921499941498041f;
                          _7401 = f16tof32(_7349);
                          _7404 = f16tof32(_7358);
                          _7408 = _7364 & 65535;
                          _7414 = ((_1614 & 3584) != 0);
                          _7425 = f16tof32(((uint)((uint)(_7388) >> 16)));
                          _7426 = f16tof32(_7388);
                          _7428 = f16tof32(((uint)((uint)(_7391) >> 16)));
                          _7429 = 1.0f / _7428;
                          _7430 = _7428 + -1.0f;
                          _7431 = f16tof32(_7391);
                          _7432 = _7333 - _234;
                          _7433 = _7334 - _235;
                          _7434 = _7335 + _233;
                          _7435 = dot(float3(_7432, _7433, _7434), float3(_7432, _7433, _7434));
                          _7436 = rsqrt(_7435);
                          _7437 = _7436 * _7435;
                          _7438 = _7436 * _7432;
                          _7439 = _7436 * _7433;
                          _7440 = _7436 * _7434;
                          _7443 = max(0.0f, (_7437 - abs(_7404)));
                          _7444 = _7443 * f16tof32(((uint)((uint)(_7358) >> 16)));
                          _7445 = _7444 * _7444;
                          _7448 = saturate(1.0f - (_7445 * _7445));
                          _7459 = mad(_236, _7325, mad(_235, _7320, (_7315 * _234))) + _7330;
                          _7463 = saturate(1.0f - dot(float3(_200, _202, _204), float3(_7438, _7439, _7440))) * f16tof32(_7385);
                          _7470 = ((_7459 * _200) * _7463) + _234;
                          _7471 = ((_7459 * _202) * _7463) + _235;
                          _7472 = ((_7459 * _204) * _7463) - _233;
                          _7484 = mad(_7472, _7325, mad(_7471, _7320, (_7470 * _7315))) + _7330;
                          _7485 = 1.0f / _7484;
                          _7486 = _7485 * (mad(_7472, _7323, mad(_7471, _7318, (_7470 * _7313))) + _7328);
                          _7487 = _7485 * (mad(_7472, _7324, mad(_7471, _7319, (_7470 * _7314))) + _7329);
                          _7490 = (_7486 * _7352) + _7353;
                          _7491 = (_7487 * _7352) + _7353;
                          _7494 = _7490 - saturate(_7490);
                          _7495 = _7491 - saturate(_7491);
                          _7502 = saturate((sqrt((_7494 * _7494) + (_7495 * _7495)) * _7354) + _7355);
                          _7504 = 1.0f - (_7502 * _7502);
                          _7510 = (_7504 * _7504) * (((float)((bool)(uint)((_7484 - f16tof32(((uint)((uint)(_7361) >> 16)))) > 0.0f))) * ((_7448 * _7448) / (select((_7404 < 0.0f), (_7445 * 16.0f), (_7443 * _7443)) + 1.0f)));
                          if (!((!(_7510 > 0.0f)) || (!_7414))) {
                            _7520 = 1.0f - saturate(f16tof32(_7361) * _7484);
                            _7521 = saturate(_7486);
                            _7522 = saturate(_7487);
                            bool __branch_chain_7514;
                            [branch]
                            if ((_1614 & 1024) == 0) {
                              _7835 = 1.0f;
                              _7836 = 1.0f;
                              _7837 = 0.0f;
                              _7838 = _7520;
                              __branch_chain_7514 = true;
                            } else {
                              _7527 = ((_7521 * _7430) + 0.5f) * _7429;
                              _7529 = ((_7522 * _7430) + 0.5f) * _7429;
                              _7530 = _7520 + f16tof32(((uint)((uint)(_7385) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7364) >> 16))];
                              _7533 = saturate(_7530);
                              _7537 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _7546 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_7537 * 32.665000915527344f) + _129), ((_7537 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _7547 = sin(_7546);
                              _7548 = cos(_7546);
                              _7549 = cbSharedPerViewData.nFrameCounter & 3;
                              _7554 = sqrt((float((int)(_7549)) * 0.25f) + 0.125f) * _7425;
                              _7563 = (_global_7[min((uint)(((int)(0u + (_7549 * 2)))), 127u)]) * _7554;
                              _7564 = (_global_7[min((uint)(((int)(1u + (_7549 * 2)))), 127u)]) * _7554;
                              _7566 = -0.0f - _7547;
                              _7571 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7563, _7564), float2(_7548, _7547)) + _7527), (dot(float2(_7563, _7564), float2(_7566, _7548)) + _7529)));
                              _7576 = _7571.x - _7533;
                              _7578 = select((_7576 < 0.0f), 0.0f, 1.0f);
                              _7580 = _7571.y - _7533;
                              _7582 = select((_7580 < 0.0f), 0.0f, 1.0f);
                              _7586 = _7571.z - _7533;
                              _7588 = select((_7586 < 0.0f), 0.0f, 1.0f);
                              _7592 = _7571.w - _7533;
                              _7594 = select((_7592 < 0.0f), 0.0f, 1.0f);
                              _7601 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _7606 = sqrt((float((int)(_7601)) * 0.25f) + 0.125f) * _7425;
                              _7615 = (_global_7[min((uint)(((int)(0u + (_7601 * 2)))), 127u)]) * _7606;
                              _7616 = (_global_7[min((uint)(((int)(1u + (_7601 * 2)))), 127u)]) * _7606;
                              _7622 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7615, _7616), float2(_7548, _7547)) + _7527), (dot(float2(_7615, _7616), float2(_7566, _7548)) + _7529)));
                              _7627 = _7622.x - _7533;
                              _7629 = select((_7627 < 0.0f), 0.0f, 1.0f);
                              _7633 = _7622.y - _7533;
                              _7635 = select((_7633 < 0.0f), 0.0f, 1.0f);
                              _7639 = _7622.z - _7533;
                              _7641 = select((_7639 < 0.0f), 0.0f, 1.0f);
                              _7645 = _7622.w - _7533;
                              _7647 = select((_7645 < 0.0f), 0.0f, 1.0f);
                              _7654 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _7659 = sqrt((float((int)(_7654)) * 0.25f) + 0.125f) * _7425;
                              _7668 = (_global_7[min((uint)(((int)(0u + (_7654 * 2)))), 127u)]) * _7659;
                              _7669 = (_global_7[min((uint)(((int)(1u + (_7654 * 2)))), 127u)]) * _7659;
                              _7675 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7668, _7669), float2(_7548, _7547)) + _7527), (dot(float2(_7668, _7669), float2(_7566, _7548)) + _7529)));
                              _7680 = _7675.x - _7533;
                              _7682 = select((_7680 < 0.0f), 0.0f, 1.0f);
                              _7686 = _7675.y - _7533;
                              _7688 = select((_7686 < 0.0f), 0.0f, 1.0f);
                              _7692 = _7675.z - _7533;
                              _7694 = select((_7692 < 0.0f), 0.0f, 1.0f);
                              _7698 = _7675.w - _7533;
                              _7700 = select((_7698 < 0.0f), 0.0f, 1.0f);
                              _7707 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _7712 = sqrt((float((int)(_7707)) * 0.25f) + 0.125f) * _7425;
                              _7721 = (_global_7[min((uint)(((int)(0u + (_7707 * 2)))), 127u)]) * _7712;
                              _7722 = (_global_7[min((uint)(((int)(1u + (_7707 * 2)))), 127u)]) * _7712;
                              _7728 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7721, _7722), float2(_7548, _7547)) + _7527), (dot(float2(_7721, _7722), float2(_7566, _7548)) + _7529)));
                              _7733 = _7728.x - _7533;
                              _7735 = select((_7733 < 0.0f), 0.0f, 1.0f);
                              _7739 = _7728.y - _7533;
                              _7741 = select((_7739 < 0.0f), 0.0f, 1.0f);
                              _7745 = _7728.z - _7533;
                              _7747 = select((_7745 < 0.0f), 0.0f, 1.0f);
                              _7751 = _7728.w - _7533;
                              _7753 = select((_7751 < 0.0f), 0.0f, 1.0f);
                              _7754 = ((((((((((((((_7578 + _7582) + _7588) + _7594) + _7629) + _7635) + _7641) + _7647) + _7682) + _7688) + _7694) + _7700) + _7735) + _7741) + _7747) + _7753;
                              _7765 = (saturate(_7754 * 0.0625f) * 2.0f) + -1.0f;
                              _7771 = float((int)(((int)(uint)((int)(_7765 > 0.0f))) - ((int)(uint)((int)(_7765 < 0.0f)))));
                              _7773 = 1.0f - (_7771 * _7765);
                              _7775 = (_7773 * _7773) * _7773;
                              _7782 = 0.5f - ((_7771 * 0.5f) * ((1.0f - _7775) - ((_7773 - _7775) * saturate(((1.0f / _7533) * (1.0f / _7754)) * ((((((((((((((((_7578 * _7576) + (_7582 * _7580)) + (_7588 * _7586)) + (_7594 * _7592)) + (_7629 * _7627)) + (_7635 * _7633)) + (_7641 * _7639)) + (_7647 * _7645)) + (_7682 * _7680)) + (_7688 * _7686)) + (_7694 * _7692)) + (_7700 * _7698)) + (_7735 * _7733)) + (_7741 * _7739)) + (_7747 * _7745)) + (_7753 * _7751))))));
                              _7787 = frac((_7527 * _7428) + 0.5f);
                              _7788 = frac((_7529 * _7428) + 0.5f);
                              _7789 = _7527 + _7429;
                              _7790 = _7529 + _7429;
                              _7792 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7789, _7790), _7530);
                              _7800 = _7429 * 2.0f;
                              _7801 = _7789 - _7800;
                              _7802 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7801, _7790), _7530);
                              _7807 = 1.0f - _7787;
                              _7812 = _7790 - _7800;
                              _7813 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7801, _7812), _7530);
                              _7818 = 1.0f - _7788;
                              _7823 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7789, _7812), _7530);
                              _7832 = (((mad(mad(_7802.x, _7807, _7802.y), _7788, mad(_7802.w, _7807, _7802.z)) + mad(mad(_7792.y, _7787, _7792.x), _7788, mad(_7792.z, _7787, _7792.w))) + mad(mad(_7813.w, _7807, _7813.z), _7818, mad(_7813.x, _7807, _7813.y))) + mad(mad(_7823.z, _7787, _7823.w), _7818, mad(_7823.y, _7787, _7823.x))) * 0.1111111119389534f;
                              [branch]
                              if (_7431 < 1.0f) {
                                _7835 = _7782;
                                _7836 = _7832;
                                _7837 = _7431;
                                _7838 = _7530;
                                __branch_chain_7514 = true;
                              } else {
                                _8306 = _7832;
                                _8307 = _7431;
                                _8308 = _7782;
                                __branch_chain_7514 = false;
                              }
                            }
                            if (__branch_chain_7514) {
                              _7841 = (_7521 * _7379) + _7381;
                              _7842 = (_7522 * _7380) + _7382;
                              if (!((_1614 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _7851 = saturate(_7838);
                                _7855 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _7864 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_7855 * 32.665000915527344f) + _129), ((_7855 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7865 = sin(_7864);
                                _7866 = cos(_7864);
                                _7871 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_7841, _7842), 0.0f))).x) > _7851), 1.0f, 0.0f);
                                _7872 = cbSharedPerViewData.nFrameCounter & 3;
                                _7877 = sqrt((float((int)(_7872)) * 0.25f) + 0.125f) * _7426;
                                _7886 = (_global_7[min((uint)(((int)(0u + (_7872 * 2)))), 127u)]) * _7877;
                                _7887 = (_global_7[min((uint)(((int)(1u + (_7872 * 2)))), 127u)]) * _7877;
                                _7889 = -0.0f - _7865;
                                _7891 = dot(float2(_7886, _7887), float2(_7866, _7865)) + _7841;
                                _7892 = dot(float2(_7886, _7887), float2(_7889, _7866)) + _7842;
                                _7894 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7891, _7892));
                                _7898 = _7891 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7899 = _7892 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7902 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _7381);
                                _7903 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _7382);
                                _7908 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_7379 + _7381)) + 0.5f);
                                _7909 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_7380 + _7382)) + 0.5f);
                                _7912 = floor(_7898 + -0.5f);
                                _7913 = floor(_7899 + 0.5f);
                                _7915 = floor(_7898 + 0.5f);
                                _7917 = floor(_7899 + -0.5f);
                                _7918 = (_7912 < _7902);
                                _7919 = (_7913 < _7903);
                                if ((_7918 || _7919) | ((_7912 >= _7908) || (_7913 >= _7909))) {
                                  _7928 = _7871;
                                } else {
                                  _7928 = _7894.x;
                                }
                                _7929 = (_7915 < _7902);
                                if ((_7929 || _7919) | ((_7915 >= _7908) || (_7913 >= _7909))) {
                                  _7937 = _7871;
                                } else {
                                  _7937 = _7894.y;
                                }
                                _7938 = (_7917 < _7903);
                                if ((_7929 || _7938) | ((_7915 >= _7908) || (_7917 >= _7909))) {
                                  _7946 = _7871;
                                } else {
                                  _7946 = _7894.z;
                                }
                                if ((_7918 || _7938) | ((_7912 >= _7908) || (_7917 >= _7909))) {
                                  _7954 = _7871;
                                } else {
                                  _7954 = _7894.w;
                                }
                                _7955 = _7928 - _7851;
                                _7957 = select((_7955 < 0.0f), 0.0f, 1.0f);
                                _7959 = _7937 - _7851;
                                _7961 = select((_7959 < 0.0f), 0.0f, 1.0f);
                                _7965 = _7946 - _7851;
                                _7967 = select((_7965 < 0.0f), 0.0f, 1.0f);
                                _7971 = _7954 - _7851;
                                _7973 = select((_7971 < 0.0f), 0.0f, 1.0f);
                                _7980 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _7985 = sqrt((float((int)(_7980)) * 0.25f) + 0.125f) * _7426;
                                _7994 = (_global_7[min((uint)(((int)(0u + (_7980 * 2)))), 127u)]) * _7985;
                                _7995 = (_global_7[min((uint)(((int)(1u + (_7980 * 2)))), 127u)]) * _7985;
                                _7998 = dot(float2(_7994, _7995), float2(_7866, _7865)) + _7841;
                                _7999 = dot(float2(_7994, _7995), float2(_7889, _7866)) + _7842;
                                _8001 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7998, _7999));
                                _8005 = _7998 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _8006 = _7999 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _8009 = floor(_8005 + -0.5f);
                                _8010 = floor(_8006 + 0.5f);
                                _8012 = floor(_8005 + 0.5f);
                                _8014 = floor(_8006 + -0.5f);
                                _8015 = (_8009 < _7902);
                                _8016 = (_8010 < _7903);
                                if ((_8015 || _8016) | ((_8009 >= _7908) || (_8010 >= _7909))) {
                                  _8025 = _7871;
                                } else {
                                  _8025 = _8001.x;
                                }
                                _8026 = (_8012 < _7902);
                                if ((_8026 || _8016) | ((_8012 >= _7908) || (_8010 >= _7909))) {
                                  _8034 = _7871;
                                } else {
                                  _8034 = _8001.y;
                                }
                                _8035 = (_8014 < _7903);
                                if ((_8026 || _8035) | ((_8012 >= _7908) || (_8014 >= _7909))) {
                                  _8043 = _7871;
                                } else {
                                  _8043 = _8001.z;
                                }
                                if ((_8015 || _8035) | ((_8009 >= _7908) || (_8014 >= _7909))) {
                                  _8051 = _7871;
                                } else {
                                  _8051 = _8001.w;
                                }
                                _8052 = _8025 - _7851;
                                _8054 = select((_8052 < 0.0f), 0.0f, 1.0f);
                                _8058 = _8034 - _7851;
                                _8060 = select((_8058 < 0.0f), 0.0f, 1.0f);
                                _8064 = _8043 - _7851;
                                _8066 = select((_8064 < 0.0f), 0.0f, 1.0f);
                                _8070 = _8051 - _7851;
                                _8072 = select((_8070 < 0.0f), 0.0f, 1.0f);
                                _8079 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _8084 = sqrt((float((int)(_8079)) * 0.25f) + 0.125f) * _7426;
                                _8093 = (_global_7[min((uint)(((int)(0u + (_8079 * 2)))), 127u)]) * _8084;
                                _8094 = (_global_7[min((uint)(((int)(1u + (_8079 * 2)))), 127u)]) * _8084;
                                _8097 = dot(float2(_8093, _8094), float2(_7866, _7865)) + _7841;
                                _8098 = dot(float2(_8093, _8094), float2(_7889, _7866)) + _7842;
                                _8100 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_8097, _8098));
                                _8104 = _8097 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _8105 = _8098 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _8108 = floor(_8104 + -0.5f);
                                _8109 = floor(_8105 + 0.5f);
                                _8111 = floor(_8104 + 0.5f);
                                _8113 = floor(_8105 + -0.5f);
                                _8114 = (_8108 < _7902);
                                _8115 = (_8109 < _7903);
                                if ((_8114 || _8115) | ((_8108 >= _7908) || (_8109 >= _7909))) {
                                  _8124 = _7871;
                                } else {
                                  _8124 = _8100.x;
                                }
                                _8125 = (_8111 < _7902);
                                if ((_8125 || _8115) | ((_8111 >= _7908) || (_8109 >= _7909))) {
                                  _8133 = _7871;
                                } else {
                                  _8133 = _8100.y;
                                }
                                _8134 = (_8113 < _7903);
                                if ((_8125 || _8134) | ((_8111 >= _7908) || (_8113 >= _7909))) {
                                  _8142 = _7871;
                                } else {
                                  _8142 = _8100.z;
                                }
                                if ((_8114 || _8134) | ((_8108 >= _7908) || (_8113 >= _7909))) {
                                  _8150 = _7871;
                                } else {
                                  _8150 = _8100.w;
                                }
                                _8151 = _8124 - _7851;
                                _8153 = select((_8151 < 0.0f), 0.0f, 1.0f);
                                _8157 = _8133 - _7851;
                                _8159 = select((_8157 < 0.0f), 0.0f, 1.0f);
                                _8163 = _8142 - _7851;
                                _8165 = select((_8163 < 0.0f), 0.0f, 1.0f);
                                _8169 = _8150 - _7851;
                                _8171 = select((_8169 < 0.0f), 0.0f, 1.0f);
                                _8178 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _8183 = sqrt((float((int)(_8178)) * 0.25f) + 0.125f) * _7426;
                                _8192 = (_global_7[min((uint)(((int)(0u + (_8178 * 2)))), 127u)]) * _8183;
                                _8193 = (_global_7[min((uint)(((int)(1u + (_8178 * 2)))), 127u)]) * _8183;
                                _8196 = dot(float2(_8192, _8193), float2(_7866, _7865)) + _7841;
                                _8197 = dot(float2(_8192, _8193), float2(_7889, _7866)) + _7842;
                                _8199 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_8196, _8197));
                                _8203 = _8196 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _8204 = _8197 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _8207 = floor(_8203 + -0.5f);
                                _8208 = floor(_8204 + 0.5f);
                                _8210 = floor(_8203 + 0.5f);
                                _8212 = floor(_8204 + -0.5f);
                                _8213 = (_8207 < _7902);
                                _8214 = (_8208 < _7903);
                                if ((_8213 || _8214) | ((_8207 >= _7908) || (_8208 >= _7909))) {
                                  _8223 = _7871;
                                } else {
                                  _8223 = _8199.x;
                                }
                                _8224 = (_8210 < _7902);
                                if ((_8224 || _8214) | ((_8210 >= _7908) || (_8208 >= _7909))) {
                                  _8232 = _7871;
                                } else {
                                  _8232 = _8199.y;
                                }
                                _8233 = (_8212 < _7903);
                                if ((_8224 || _8233) | ((_8210 >= _7908) || (_8212 >= _7909))) {
                                  _8241 = _7871;
                                } else {
                                  _8241 = _8199.z;
                                }
                                if ((_8213 || _8233) | ((_8207 >= _7908) || (_8212 >= _7909))) {
                                  _8249 = _7871;
                                } else {
                                  _8249 = _8199.w;
                                }
                                _8250 = _8223 - _7851;
                                _8252 = select((_8250 < 0.0f), 0.0f, 1.0f);
                                _8256 = _8232 - _7851;
                                _8258 = select((_8256 < 0.0f), 0.0f, 1.0f);
                                _8262 = _8241 - _7851;
                                _8264 = select((_8262 < 0.0f), 0.0f, 1.0f);
                                _8268 = _8249 - _7851;
                                _8270 = select((_8268 < 0.0f), 0.0f, 1.0f);
                                _8271 = ((((((((((((((_7961 + _7957) + _7967) + _7973) + _8054) + _8060) + _8066) + _8072) + _8153) + _8159) + _8165) + _8171) + _8252) + _8258) + _8264) + _8270;
                                _8282 = (saturate(_8271 * 0.0625f) * 2.0f) + -1.0f;
                                _8288 = float((int)(((int)(uint)((int)(_8282 > 0.0f))) - ((int)(uint)((int)(_8282 < 0.0f)))));
                                _8290 = 1.0f - (_8288 * _8282);
                                _8292 = (_8290 * _8290) * _8290;
                                _8301 = (0.5f - ((_8288 * 0.5f) * ((1.0f - _8292) - ((_8290 - _8292) * saturate(((1.0f / _7851) * (1.0f / _8271)) * ((((((((((((((((_7961 * _7959) + (_7957 * _7955)) + (_7967 * _7965)) + (_7973 * _7971)) + (_8054 * _8052)) + (_8060 * _8058)) + (_8066 * _8064)) + (_8072 * _8070)) + (_8153 * _8151)) + (_8159 * _8157)) + (_8165 * _8163)) + (_8171 * _8169)) + (_8252 * _8250)) + (_8258 * _8256)) + (_8264 * _8262)) + (_8270 * _8268)))))));
                              } else {
                                _8301 = 1.0f;
                              }
                              _8306 = _7836;
                              _8307 = _7837;
                              _8308 = (lerp(_8301, _7835, _7837));
                            }
                            [branch]
                            if (!((_1614 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7367) >> 16))];
                              _8314 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_7486, _7487), 0.0f);
                              if (_8314.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_7367 & 65535))];
                                _8321 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_7486, _7487), 0.0f);
                                _8335 = mad(saturate(((log2(_7437) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _8336 = max(9.999999747378752e-06f, _8314.x);
                                _8337 = _8321.x / _8336;
                                _8338 = _8321.y / _8336;
                                _8340 = _8321.w / _8336;
                                _8345 = ((0.375f - _8338) * 4.999999873689376e-06f) + _8338;
                                _8348 = -0.0f - _8337;
                                _8349 = mad(_8348, _8345, (_8321.z / _8336));
                                _8351 = 1.0f / mad(_8348, _8337, _8345);
                                _8352 = _8351 * _8349;
                                _8357 = _8335 - _8337;
                                _8362 = (((_8335 * _8335) - _8345) - (_8352 * _8357)) / mad((-0.0f - _8349), _8352, mad((-0.0f - _8345), _8345, (((0.375f - _8340) * 4.999999873689376e-06f) + _8340)));
                                _8364 = (_8351 * _8357) - (_8362 * _8352);
                                _8367 = 1.0f / _8362;
                                _8368 = _8364 * _8367;
                                _8373 = sqrt(((_8368 * _8368) * 0.25f) - ((1.0f - dot(float2(_8364, _8362), float2(_8337, _8345))) * _8367));
                                _8375 = (_8368 * -0.5f) - _8373;
                                _8377 = _8373 - (_8368 * 0.5f);
                                _8379 = select((_8375 < _8335), 1.0f, 0.0f);
                                _8384 = (_8379 + -0.05000000074505806f) / (_8375 - _8335);
                                _8390 = (((select((_8377 < _8335), 1.0f, 0.0f) - _8379) / (_8377 - _8375)) - _8384) / (_8377 - _8335);
                                _8392 = _8384 - (_8390 * _8375);
                                _8405 = (exp2((_8314.x * -1.4426950216293335f) * saturate((dot(float2(_8337, _8345), float2((_8392 - (_8390 * _8335)), _8390)) + 0.05000000074505806f) - (_8392 * _8335))) * _8308);
                              } else {
                                _8405 = _8308;
                              }
                            } else {
                              _8405 = _8308;
                            }
                            _8410 = _8307;
                            _8411 = _8405;
                            _8412 = (lerp(_8405, _8306, _8307));
                          } else {
                            _8410 = 0.0f;
                            _8411 = 1.0f;
                            _8412 = 1.0f;
                          }
                          [branch]
                          if (!(_7408 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _7408)))];
                            _8425 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_7486 * f16tof32(((uint)((uint)(_7373) >> 16)))) + f16tof32(((uint)((uint)(_7376) >> 16)))), ((_7487 * f16tof32(_7373)) + f16tof32(_7376))), 0.0f);
                            _8433 = (_8425.x * _7393);
                            _8434 = (_8425.y * _7394);
                            _8435 = (_8425.z * _7396);
                          } else {
                            _8433 = _7393;
                            _8434 = _7394;
                            _8435 = _7396;
                          }
                          _8436 = _8411 * _7510;
                          _8437 = _8412 * _7510;
                          [branch]
                          if (!(_8436 == 0.0f)) {
                            bool __branch_chain_8439;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _8455 = 0;
                              __branch_chain_8439 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _8455 = 1;
                                __branch_chain_8439 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _8455 = 2;
                                  __branch_chain_8439 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1617) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _8455 = 3;
                                    __branch_chain_8439 = true;
                                  } else {
                                    _8480 = _8436;
                                    __branch_chain_8439 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_8439) {
                              while(true) {
                                _8458 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_67, _68, 0));
                                if (_8455 == 0) {
                                  _8472 = _8458.x;
                                } else {
                                  if (_8455 == 1) {
                                    _8472 = _8458.y;
                                  } else {
                                    if (_8455 == 2) {
                                      _8472 = _8458.z;
                                    } else {
                                      _8472 = _8458.w;
                                    }
                                  }
                                }
                                _8480 = ((((_8410 * _8410) * ((_8472 * _8472) + -1.0f)) + 1.0f) * _7510);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_8480 > 0.0f) {
                                if (_7414) {
                                  [branch]
                                  if (!((_7370 & 1) == 0)) {
                                    _8496 = max(max(_8433, _8434), _8435);
                                    if (_8496 > 0.0f) {
                                      _8506 = saturate(_8433 / _8496);
                                      _8507 = saturate(_8434 / _8496);
                                      _8508 = saturate(_8435 / _8496);
                                    } else {
                                      _8506 = _8433;
                                      _8507 = _8434;
                                      _8508 = _8435;
                                    }
                                    _8509 = (_8507 < _8508);
                                    _8510 = select(_8509, _8508, _8507);
                                    _8511 = select(_8509, _8507, _8508);
                                    _8512 = select(_8509, -1.0f, 0.0f);
                                    _8513 = (_8506 < _8510);
                                    _8515 = select(_8513, _8510, _8506);
                                    _8516 = select(_8513, _8506, _8510);
                                    _8520 = _8515 - select((_8516 < _8511), _8516, _8511);
                                    _8526 = abs(select(_8513, (-0.3333333432674408f - _8512), _8512) + ((_8516 - _8511) / ((_8520 * 6.0f) + 9.999999682655225e-21f)));
                                    if (_8526 < 0.6666666865348816f) {
                                      _8539 = ((saturate(((float)((uint)((uint)(((uint)(_7370) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8526 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8526)) + _8526);
                                    } else {
                                      _8539 = _8526;
                                    }
                                    _8540 = saturate((_8520 / (_8515 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7370) >> 1) & 255)))) * 0.003921499941498041f));
                                    _8541 = saturate(_8515);
                                    if (!(_8540 <= 0.0f)) {
                                      _8544 = saturate(_8539);
                                      _8548 = select(((_8544 * 360.0f) >= 360.0f), 0.0f, (_8544 * 6.0f));
                                      _8549 = int(_8548);
                                      _8551 = _8548 - float((int)(_8549));
                                      _8553 = _8541 * (1.0f - _8540);
                                      _8556 = (1.0f - (_8551 * _8540)) * _8541;
                                      _8560 = (1.0f - ((1.0f - _8551) * _8540)) * _8541;
                                      switch (_8549) {
                                        case 0: {
                                          _8568 = _8541;
                                          _8569 = _8560;
                                          _8570 = _8553;
                                          break;
                                        }
                                        case 1: {
                                          _8568 = _8556;
                                          _8569 = _8541;
                                          _8570 = _8553;
                                          break;
                                        }
                                        case 2: {
                                          _8568 = _8553;
                                          _8569 = _8541;
                                          _8570 = _8560;
                                          break;
                                        }
                                        case 3: {
                                          _8568 = _8553;
                                          _8569 = _8556;
                                          _8570 = _8541;
                                          break;
                                        }
                                        case 4: {
                                          _8568 = _8560;
                                          _8569 = _8553;
                                          _8570 = _8541;
                                          break;
                                        }
                                        case 5: {
                                          _8568 = _8541;
                                          _8569 = _8553;
                                          _8570 = _8556;
                                          break;
                                        }
                                        default: {
                                          _8568 = 0.0f;
                                          _8569 = 0.0f;
                                          _8570 = 0.0f;
                                          break;
                                        }
                                      }
                                    } else {
                                      _8568 = _8541;
                                      _8569 = _8541;
                                      _8570 = _8541;
                                    }
                                    _8571 = _8568 * _8496;
                                    _8572 = _8569 * _8496;
                                    _8573 = _8570 * _8496;
                                    _8575 = saturate(_8411 * 1.0101009607315063f);
                                    _8586 = ((_8575 * (_8433 - _8571)) + _8571);
                                    _8587 = ((_8575 * (_8434 - _8572)) + _8572);
                                    _8588 = (lerp(_8573, _8435, _8575));
                                    _8589 = _8410;
                                  } else {
                                    _8586 = _8433;
                                    _8587 = _8434;
                                    _8588 = _8435;
                                    _8589 = _8410;
                                  }
                                } else {
                                  _8586 = _8433;
                                  _8587 = _8434;
                                  _8588 = _8435;
                                  _8589 = 0.0f;
                                }
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _8596 = srvLightMappingData[_1617];
                                  if (!(_8596 == -1)) {
                                    _8601 = srvLightIndexData[_8596].nLayerIndex;
                                    _8603 = srvLightIndexData[_8596].vAtlasOrigin.x;
                                    _8604 = srvLightIndexData[_8596].vAtlasOrigin.y;
                                    _8606 = srvLightIndexData[_8596].vScreenOrigin.x;
                                    _8607 = srvLightIndexData[_8596].vScreenOrigin.y;
                                    _8616 = ((int)(_8601 * 5)) & 31;
                                    _8619 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8603 + _67) - _8606)), ((int)((_8604 + _68) - _8607)), 0)))).x) & ((int)(31 << _8616)))) >> _8616;
                                    _8629 = ((_8437 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_8619) >> 1)))));
                                    _8630 = (((float)((bool)(uint)((_8619 & 1) != 0))) * _8437);
                                  } else {
                                    _8629 = _8437;
                                    _8630 = _8437;
                                  }
                                } else {
                                  _8629 = _8437;
                                  _8630 = _8437;
                                }
                                _8634 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _8637 = select(_8634, (_8629 * _1267), _8629);
                                _8639 = _7438 * _7437;
                                _8640 = _7439 * _7437;
                                _8641 = _7440 * _7437;
                                _8642 = _7401 * _7338;
                                _8643 = _7401 * _7339;
                                _8644 = _7401 * _7340;
                                _8645 = _8639 + _8642;
                                _8646 = _8640 + _8643;
                                _8647 = _8641 + _8644;
                                _8649 = -0.0f - _449;
                                _8650 = -0.0f - _450;
                                _8651 = -0.0f - _448;
                                if (_7401 > 0.0f) {
                                  _8657 = dot(float3(_8649, _8650, _8651), float3(_200, _202, _204)) * 2.0f;
                                  _8661 = _8649 - (_8657 * _200);
                                  _8662 = _8650 - (_8657 * _202);
                                  _8663 = _8651 - (_8657 * _204);
                                  _8664 = (_8639 - _8642) - _8645;
                                  _8665 = (_8640 - _8643) - _8646;
                                  _8666 = (_8641 - _8644) - _8647;
                                  _8667 = dot(float3(_8661, _8662, _8663), float3(_8664, _8665, _8666));
                                  _8673 = sqrt(((_8664 * _8664) + (_8665 * _8665)) + (_8666 * _8666));
                                  _8682 = saturate(((dot(float3(_8661, _8662, _8663), float3(_8645, _8646, _8647)) * _8667) - dot(float3(_8645, _8646, _8647), float3(_8664, _8665, _8666))) / ((_8673 * _8673) - (_8667 * _8667)));
                                  _8686 = (_8682 * _8664) + _8645;
                                  _8687 = (_8682 * _8665) + _8646;
                                  _8688 = (_8682 * _8666) + _8647;
                                  _8689 = dot(float3(_8686, _8687, _8688), float3(_8661, _8662, _8663));
                                  _8693 = (_8689 * _8661) - _8686;
                                  _8694 = (_8689 * _8662) - _8687;
                                  _8695 = (_8689 * _8663) - _8688;
                                  _8703 = saturate(0.009999999776482582f / sqrt(((_8693 * _8693) + (_8694 * _8694)) + (_8695 * _8695)));
                                  _8711 = ((_8703 * _8693) + _8686);
                                  _8712 = ((_8703 * _8694) + _8687);
                                  _8713 = ((_8703 * _8695) + _8688);
                                } else {
                                  _8711 = _8645;
                                  _8712 = _8646;
                                  _8713 = _8647;
                                }
                                _8715 = rsqrt(dot(float3(_8711, _8712, _8713), float3(_8711, _8712, _8713)));
                                _8716 = _8715 * _8711;
                                _8717 = _8715 * _8712;
                                _8718 = _8715 * _8713;
                                _8720 = rsqrt(dot(float3(_8639, _8640, _8641), float3(_8639, _8640, _8641)));
                                _8721 = _8720 * _8639;
                                _8722 = _8720 * _8640;
                                _8723 = _8720 * _8641;
                                _8725 = saturate(dot(float3(_200, _202, _204), float3(_8721, _8722, _8723)));
                                _8728 = uint((_180 * 255.0f) + 0.5f);
                                _8737 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                _8738 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                _8739 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                _8752 = ((dot(float3(_201, _203, _205), float3(_8721, _8722, _8723)) + dot(float3(_8649, _8650, _8651), float3(_8721, _8722, _8723))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_200, _202, _204), float3(_449, _450, _448)))) * (11.0f - (((float)((uint)((uint)((uint)(_8728) >> 2)))) * 0.1666666716337204f)));
                                _8759 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                _8762 = saturate((_8759 + -0.009999999776482582f) * -100.0f);
                                _8767 = ((_8762 * _8762) * 3.0f) * (3.0f - (_8762 * 2.0f));
                                _8774 = 10.0f - (exp2(log2(saturate(_8759 * 5.0f)) * 3.0f) * 9.0f);
                                _8775 = saturate(_8725 + _8737) * _8725;
                                _8776 = saturate(_8725 + _8738) * _8725;
                                _8777 = saturate(_8725 + _8739) * _8725;
                                _8799 = _8716 + _449;
                                _8800 = _8717 + _450;
                                _8801 = _8718 + _448;
                                _8803 = rsqrt(dot(float3(_8799, _8800, _8801), float3(_8799, _8800, _8801)));
                                if (!(select(((_222 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                  _8818 = rsqrt(dot(float3(_200, _202, _204), float3(_200, _202, _204)));
                                  _8819 = _8818 * _200;
                                  _8820 = _8818 * _202;
                                  _8821 = _8818 * _204;
                                  _8824 = (abs(_8819) < abs(_8820));
                                  _8825 = select(_8824, 1.0f, 0.0f);
                                  _8826 = select(_8824, 0.0f, 1.0f);
                                  _8827 = _8826 * _8821;
                                  _8829 = -0.0f - (_8821 * _8825);
                                  _8832 = (_8825 * _8820) - (_8826 * _8819);
                                  _8834 = rsqrt(dot(float3(_8827, _8829, _8832), float3(_8827, _8829, _8832)));
                                  _8835 = _8827 * _8834;
                                  _8836 = _8834 * _8829;
                                  _8837 = _8832 * _8834;
                                  _8840 = (_8836 * _8821) - (_8837 * _8820);
                                  _8843 = (_8837 * _8819) - (_8835 * _8821);
                                  _8846 = (_8835 * _8820) - (_8836 * _8819);
                                  _8848 = rsqrt(dot(float3(_8840, _8843, _8846), float3(_8840, _8843, _8846)));
                                  _8852 = _178 * 4.0f;
                                  _8861 = saturate(abs(_8852 + -2.5f) + -0.5f) + -0.5f;
                                  _8862 = saturate(1.5f - abs(_8852 + -1.5f)) + -0.5f;
                                  _8864 = rsqrt(dot(float2(_8861, _8862), float2(_8861, _8862)));
                                  _8865 = _8864 * _8861;
                                  _8866 = _8864 * _8862;
                                  _8873 = ((_8840 * _8848) * _8865) + (_8866 * _8835);
                                  _8874 = ((_8843 * _8848) * _8865) + (_8866 * _8836);
                                  _8875 = ((_8846 * _8848) * _8865) + (_8866 * _8837);
                                  _8876 = dot(float3(_449, _450, _448), float3(_8716, _8717, _8718));
                                  _8879 = min(max(dot(float3(_8873, _8874, _8875), float3(_8716, _8717, _8718)), -1.0f), 1.0f);
                                  _8882 = min(max(dot(float3(_8873, _8874, _8875), float3(_449, _450, _448)), -1.0f), 1.0f);
                                  _8883 = abs(_8882);
                                  _8888 = (1.5707963705062866f - (_8883 * 0.1565829962491989f)) * sqrt(1.0f - _8883);
                                  _8892 = abs(_8879);
                                  _8897 = (1.5707963705062866f - (_8892 * 0.1565829962491989f)) * sqrt(1.0f - _8892);
                                  _8904 = cos(abs(select((_8879 >= 0.0f), _8897, (3.1415927410125732f - _8897)) - select((_8882 >= 0.0f), _8888, (3.1415927410125732f - _8888))) * 0.5f);
                                  _8908 = _8716 - (_8879 * _8873);
                                  _8909 = _8717 - (_8879 * _8874);
                                  _8910 = _8718 - (_8879 * _8875);
                                  _8914 = _449 - (_8882 * _8873);
                                  _8915 = _450 - (_8882 * _8874);
                                  _8916 = _448 - (_8882 * _8875);
                                  _8923 = rsqrt((dot(float3(_8914, _8915, _8916), float3(_8914, _8915, _8916)) * dot(float3(_8908, _8909, _8910), float3(_8908, _8909, _8910))) + 9.999999747378752e-05f) * dot(float3(_8908, _8909, _8910), float3(_8914, _8915, _8916));
                                  _8927 = sqrt(saturate((_8923 * 0.5f) + 0.5f));
                                  _8931 = _219 * _219;
                                  _8932 = _8931 * 0.5f;
                                  _8933 = _8931 * 2.0f;
                                  _8937 = exp2((1.0f - abs(_8589)) * -72.13475036621094f);
                                  if (!((_8728 & 1) == 0)) {
                                    _8944 = select(((select(((_8728 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_8589 == -1.0f))), 0.0f, _8937);
                                  } else {
                                    _8944 = _8937;
                                  }
                                  _8948 = saturate((dot(float3(_200, _202, _204), float3(_8716, _8717, _8718)) + 0.5f) * 0.6666666865348816f);
                                  _8958 = (_8882 + _8879) + ((((_8927 * 0.9975510239601135f) * sqrt(1.0f - (_8882 * _8882))) - (_8882 * 0.06994284689426422f)) * 0.13988569378852844f);
                                  _8960 = (_8931 * 1.4142135381698608f) * _8927;
                                  _8973 = 1.0f - sqrt(saturate((_8876 * 0.5f) + 0.5f));
                                  _8974 = _8973 * _8973;
                                  _8980 = saturate(-0.0f - _8876);
                                  _8983 = (1.0f - saturate(_8980)) * _8948;
                                  _8992 = ((((_8927 * 0.5f) * (exp2((((_8958 * _8958) * -0.5f) / (_8960 * _8960)) * 1.4426950216293335f) / (_8960 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_8974 * _8974) * (_8973 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_8983, 1.0f, _8944));
                                  _8994 = (_8879 + -0.03500000014901161f) + _8882;
                                  _9003 = 1.0f / ((1.190000057220459f / _8904) + (_8904 * 0.36000001430511475f));
                                  _9008 = ((_9003 * (0.6000000238418579f - (_8923 * 0.800000011920929f))) + 1.0f) * _8927;
                                  _9014 = 1.0f - (sqrt(saturate(1.0f - (_9008 * _9008))) * _8904);
                                  _9015 = _9014 * _9014;
                                  _9019 = 0.9534794092178345f - ((_9015 * _9015) * (_9014 * 0.9534794092178345f));
                                  _9020 = _9008 * _9003;
                                  _9025 = (sqrt(1.0f - (_9020 * _9020)) * 0.5f) / _8904;
                                  _9044 = 1.0f - saturate((_8980 + -0.44999998807907104f) * 2.222222328186035f);
                                  _9047 = ((1.0f - _8948) * _8944) + _8948;
                                  _9050 = ((_9019 * _9019) * (exp2((((_8994 * _8994) * -0.5f) / (_8932 * _8932)) * 1.4426950216293335f) / (_8931 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_8923 * 5.2658371925354f));
                                  _9064 = (_8879 + -0.14000000059604645f) + _8882;
                                  _9074 = 1.0f - (_8904 * 0.5f);
                                  _9075 = _9074 * _9074;
                                  _9079 = (_9075 * _9075) * (0.9534794092178345f - (_8904 * 0.47673970460891724f));
                                  _9081 = 0.9534794092178345f - _9079;
                                  _9083 = (_9081 * _9081) * (_9079 + 0.04652056470513344f);
                                  _9086 = exp2((_8923 * 24.525815963745117f) + -24.208423614501953f);
                                  _9099 = ((exp2((((_9064 * _9064) * -0.5f) / (_8933 * _8933)) * 1.4426950216293335f) / (_8931 * 5.013256549835205f)) * (lerp(_9083, 1.0f, _172))) * (((exp2((saturate(dot(float3((_8803 * _8799), (_8803 * _8800), (_8803 * _8801)), float3(_200, _202, _204))) * 17.312339782714844f) + -14.109557151794434f) - _9086) * _172) + _9086);
                                  _9107 = (((((exp2(log2(max(_168, 0.0f)) * _9025) * _9047) * _9050) * _9044) + _8992) + (_9099 * _168));
                                  _9108 = (((((exp2(log2(max(_169, 0.0f)) * _9025) * _9047) * _9050) * _9044) + _8992) + (_9099 * _169));
                                  _9109 = (((((exp2(log2(max(_170, 0.0f)) * _9025) * _9047) * _9050) * _9044) + _8992) + (_9099 * _170));
                                } else {
                                  _9107 = 0.0f;
                                  _9108 = 0.0f;
                                  _9109 = 0.0f;
                                }
                                _9110 = _8586 * _1665;
                                _9111 = _8587 * _1665;
                                _9112 = _8588 * _1665;
                                _9119 = ((_8637 * _9110) * ((max(((_8767 + _8737) * _8752), 0.0f) * _8774) + sqrt(_8775 * _8775))) + _1602;
                                _9120 = ((_8637 * _9111) * ((max(((_8767 + _8738) * _8752), 0.0f) * _8774) + sqrt(_8776 * _8776))) + _1603;
                                _9121 = ((_8637 * _9112) * ((max(((_8767 + _8739) * _8752), 0.0f) * _8774) + sqrt(_8777 * _8777))) + _1604;
                                if (_7400 > 0.0f) {
                                  _9125 = (_7400 * _1358) * select(_8634, (_8630 * _1267), _8630);
                                  _9575 = _9119;
                                  _9576 = _9120;
                                  _9577 = _9121;
                                  _9578 = (((_9125 * _9110) * _9107) + _1605);
                                  _9579 = (((_9125 * _9111) * _9108) + _1606);
                                  _9580 = (((_9125 * _9112) * _9109) + _1607);
                                } else {
                                  _9575 = _9119;
                                  _9576 = _9120;
                                  _9577 = _9121;
                                  _9578 = _1605;
                                  _9579 = _1606;
                                  _9580 = _1607;
                                }
                              } else {
                                _9575 = _1602;
                                _9576 = _1603;
                                _9577 = _1604;
                                _9578 = _1605;
                                _9579 = _1606;
                                _9580 = _1607;
                              }
                              break;
                            }
                          } else {
                            _9575 = _1602;
                            _9576 = _1603;
                            _9577 = _1604;
                            _9578 = _1605;
                            _9579 = _1606;
                            _9580 = _1607;
                          }
                        } else {
                          if (_1648 == 10) {
                            _9140 = asfloat(srvLightInfoProperties.Load4(_1616)).x;
                            _9141 = asfloat(srvLightInfoProperties.Load4(_1616)).y;
                            _9142 = asfloat(srvLightInfoProperties.Load4(_1616)).z;
                            _9143 = asfloat(srvLightInfoProperties.Load4(_1616)).w;
                            _9146 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).x;
                            _9147 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).y;
                            _9148 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).z;
                            _9149 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 16u)))).w;
                            _9152 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).x;
                            _9153 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).y;
                            _9154 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).z;
                            _9155 = asfloat(srvLightInfoProperties.Load4(((int)(_1616 + 32u)))).w;
                            _9158 = asfloat(srvLightInfoProperties.Load2(((int)(_1616 + 72u)))).x;
                            _9159 = asfloat(srvLightInfoProperties.Load2(((int)(_1616 + 72u)))).y;
                            _9162 = asint(srvLightInfoProperties.Load(((int)(_1616 + 80u))));
                            _9165 = asint(srvLightInfoProperties.Load(((int)(_1616 + 84u))));
                            _9168 = asint(srvLightInfoProperties.Load(((int)(_1616 + 88u))));
                            _9171 = asint(srvLightInfoProperties.Load(((int)(_1616 + 96u))));
                            _9174 = f16tof32(_9162);
                            _9176 = f16tof32(((uint)((uint)(_9165) >> 16)));
                            _9177 = f16tof32(_9165);
                            _9179 = f16tof32(((uint)((uint)(_9168) >> 16)));
                            _9183 = ((float)((uint)((uint)(((uint)(_9168) >> 8) & 255)))) * 0.003921499941498041f;
                            _9185 = (float)((uint)((uint)(_9171 & 65535)));
                            _9189 = mad(_9142, _236, mad(_9141, _235, (_9140 * _234))) + _9143;
                            _9193 = mad(_9148, _236, mad(_9147, _235, (_9146 * _234))) + _9149;
                            _9197 = mad(_9154, _236, mad(_9153, _235, (_9152 * _234))) + _9155;
                            _9200 = mad(_9142, _204, mad(_9141, _202, (_9140 * _200)));
                            _9203 = mad(_9148, _204, mad(_9147, _202, (_9146 * _200)));
                            _9206 = mad(_9154, _204, mad(_9153, _202, (_9152 * _200)));
                            _9218 = -0.0f - mad(_9154, _448, mad(_9153, _450, (_9152 * _449)));
                            _9219 = _9158 * 0.5f;
                            _9220 = _9159 * 0.5f;
                            _9221 = -0.0f - _9219;
                            _9222 = -0.0f - _9220;
                            _9223 = _9221 - _9189;
                            _9224 = _9222 - _9193;
                            _9225 = -0.0f - _9197;
                            _9226 = _9219 - _9189;
                            _9227 = _9220 - _9193;
                            _9228 = dot(float3(_9189, _9193, _9197), float3(_9200, _9203, _9206));
                            _9230 = dot(float3(_9221, _9222, 0.0f), float3(_9200, _9203, _9206)) - _9228;
                            _9232 = dot(float3(_9219, _9222, 0.0f), float3(_9200, _9203, _9206)) - _9228;
                            _9234 = dot(float3(_9219, _9220, 0.0f), float3(_9200, _9203, _9206)) - _9228;
                            _9236 = dot(float3(_9221, _9220, 0.0f), float3(_9200, _9203, _9206)) - _9228;
                            _9237 = min(_9230, _9232);
                            [branch]
                            if (!(!(_9237 >= 0.0f))) {
                              _9243 = rsqrt(dot(float3(_9226, _9224, _9225), float3(_9226, _9224, _9225)) * dot(float3(_9223, _9224, _9225), float3(_9223, _9224, _9225)));
                              _9245 = dot(float3(_9223, _9224, _9225), float3(_9226, _9224, _9225)) * _9243;
                              _9252 = rsqrt(max(((((_9245 * 0.09300000220537186f) + 0.5f) * _9245) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9243;
                              _9259 = (_9252 * (_9158 * _9225));
                              _9260 = (_9252 * (_9224 * (_9221 - _9219)));
                            } else {
                              _9259 = 0.0f;
                              _9260 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_9232, _9234) >= 0.0f))) {
                              _9267 = rsqrt(dot(float3(_9226, _9227, _9225), float3(_9226, _9227, _9225)) * dot(float3(_9226, _9224, _9225), float3(_9226, _9224, _9225)));
                              _9269 = dot(float3(_9226, _9224, _9225), float3(_9226, _9227, _9225)) * _9267;
                              _9276 = rsqrt(max(((((_9269 * 0.09300000220537186f) + 0.5f) * _9269) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9267;
                              _9284 = (_9276 * ((_9222 - _9220) * _9225));
                              _9285 = ((_9276 * (_9159 * _9226)) + _9260);
                            } else {
                              _9284 = 0.0f;
                              _9285 = _9260;
                            }
                            _9286 = min(_9234, _9236);
                            [branch]
                            if (!(!(_9286 >= 0.0f))) {
                              _9292 = rsqrt(dot(float3(_9223, _9227, _9225), float3(_9223, _9227, _9225)) * dot(float3(_9226, _9227, _9225), float3(_9226, _9227, _9225)));
                              _9294 = dot(float3(_9226, _9227, _9225), float3(_9223, _9227, _9225)) * _9292;
                              _9301 = rsqrt(max(((((_9294 * 0.09300000220537186f) + 0.5f) * _9294) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9292;
                              _9310 = ((_9301 * ((_9221 - _9219) * _9225)) + _9259);
                              _9311 = ((_9301 * (_9158 * _9227)) + _9285);
                            } else {
                              _9310 = _9259;
                              _9311 = _9285;
                            }
                            [branch]
                            if (!(!(min(_9236, _9230) >= 0.0f))) {
                              _9318 = rsqrt(dot(float3(_9223, _9224, _9225), float3(_9223, _9224, _9225)) * dot(float3(_9223, _9227, _9225), float3(_9223, _9227, _9225)));
                              _9320 = dot(float3(_9223, _9227, _9225), float3(_9223, _9224, _9225)) * _9318;
                              _9327 = rsqrt(max(((((_9320 * 0.09300000220537186f) + 0.5f) * _9320) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9318;
                              _9336 = ((_9327 * (_9159 * _9225)) + _9284);
                              _9337 = ((_9327 * (_9223 * (_9222 - _9220))) + _9311);
                            } else {
                              _9336 = _9284;
                              _9337 = _9311;
                            }
                            if (min(_9237, _9286) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_9230, _9232), max(_9234, _9236)) >= 0.0f))) {
                                _9346 = -0.0f - _9200;
                                _9347 = _9228 / _9203;
                                _9348 = _9221 / _9203;
                                _9349 = _9219 / _9203;
                                _9351 = (_9222 - _9347) / _9346;
                                _9353 = (_9220 - _9347) / _9346;
                                _9354 = min(_9348, _9349);
                                _9355 = max(_9348, _9349);
                                _9356 = min(_9351, _9353);
                                _9357 = max(_9351, _9353);
                                _9358 = max(_9354, _9356);
                                _9359 = min(_9355, _9357);
                                _9360 = _9358 * _9203;
                                _9362 = _9359 * _9203;
                                _9364 = _9360 - _9189;
                                _9365 = _9347 - _9193;
                                _9366 = _9365 + (_9358 * _9346);
                                _9367 = _9362 - _9189;
                                _9368 = _9365 + (_9359 * _9346);
                                _9369 = dot(float3(_9364, _9366, _9225), float3(_9364, _9366, _9225));
                                _9370 = dot(float3(_9367, _9368, _9225), float3(_9367, _9368, _9225));
                                _9372 = rsqrt(_9370 * _9369);
                                _9374 = dot(float3(_9364, _9366, _9225), float3(_9367, _9368, _9225)) * _9372;
                                _9381 = rsqrt(max(((((_9374 * 0.09300000220537186f) + 0.5f) * _9374) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9372;
                                _9394 = (_9354 > _9356);
                                _9396 = select(_9394, _9203, _9200);
                                _9402 = float((int)(((int)(uint)((int)(_9396 > 0.0f))) - ((int)(uint)((int)(_9396 < 0.0f)))));
                                _9406 = ((1.0f - (((float)((bool)_9394)) * 2.0f)) * _9219) * _9402;
                                _9408 = _9406 - _9189;
                                _9409 = (_9402 * _9220) - _9193;
                                _9410 = (_9355 < _9357);
                                _9412 = select(_9410, _9203, _9200);
                                _9418 = float((int)(((int)(uint)((int)(_9412 > 0.0f))) - ((int)(uint)((int)(_9412 < 0.0f)))));
                                _9419 = _9418 * _9219;
                                _9424 = _9419 - _9189;
                                _9425 = ((((((float)((bool)_9410)) * 2.0f) + -1.0f) * _9220) * _9418) - _9193;
                                _9428 = rsqrt(_9369 * dot(float3(_9408, _9409, _9225), float3(_9408, _9409, _9225)));
                                _9430 = dot(float3(_9408, _9409, _9225), float3(_9364, _9366, _9225)) * _9428;
                                _9437 = rsqrt(max(((((_9430 * 0.09300000220537186f) + 0.5f) * _9430) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9428;
                                _9450 = rsqrt(dot(float3(_9424, _9425, _9225), float3(_9424, _9425, _9225)) * _9370);
                                _9452 = dot(float3(_9367, _9368, _9225), float3(_9424, _9425, _9225)) * _9450;
                                _9459 = rsqrt(max(((((_9452 * 0.09300000220537186f) + 0.5f) * _9452) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9450;
                                _9480 = ((((_9381 * (((_9358 - _9359) * _9346) * _9225)) + _9336) + (_9437 * ((_9409 - _9366) * _9225))) + (_9459 * ((_9368 - _9425) * _9225)));
                                _9481 = ((((_9381 * ((_9203 * (_9359 - _9358)) * _9225)) + _9310) + (_9437 * ((_9360 - _9406) * _9225))) + (_9459 * ((_9419 - _9362) * _9225)));
                                _9482 = ((((_9381 * ((_9368 * _9364) - (_9367 * _9366))) + _9337) + (_9437 * ((_9408 * _9366) - (_9409 * _9364)))) + (_9459 * ((_9425 * _9367) - (_9424 * _9368))));
                              } else {
                                _9480 = _9336;
                                _9481 = _9310;
                                _9482 = _9337;
                              }
                            } else {
                              _9480 = _9336;
                              _9481 = _9310;
                              _9482 = _9337;
                            }
                            _9488 = sqrt(((_9481 * _9481) + (_9480 * _9480)) + (_9482 * _9482));
                            _9489 = _9488 * 0.15915493667125702f;
                            [branch]
                            if (!(_9489 == 0.0f)) {
                              _9498 = saturate((_9489 - _9174) / (1.0f - _9174)) * ((float)((bool)(uint)(_9197 <= 0.0f)));
                              [branch]
                              if (!(_9498 == 0.0f)) {
                                if (_9488 > 0.0f) {
                                  _9506 = (dot(float3(_9200, _9203, _9206), float3(_9480, _9481, _9482)) / _9488);
                                } else {
                                  _9506 = 0.0f;
                                }
                                _9511 = _9225 / (_9218 - ((_9206 * 2.0f) * dot(float3((-0.0f - mad(_9142, _448, mad(_9141, _450, (_9140 * _449)))), (-0.0f - mad(_9148, _448, mad(_9147, _450, (_9146 * _449)))), _9218), float3(_9200, _9203, _9206))));
                                _9512 = _9511 * 200.0f;
                                _9520 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _9185), ((log2((_9512 * _9512) * f16tof32(((uint)((uint)(_9162) >> 16)))) * 0.5f) + 5.5f));
                                _9522 = (float)((bool)(uint)(_9511 > 0.0f));
                                _9523 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _9185), 10.0f);
                                _9532 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_9498 * _1267), _9498);
                                if (_9183 > 0.0f) {
                                  _9538 = _9183 * _1358;
                                  _9539 = _9532 * _1665;
                                  _9559 = ((((((_9176 * _213) * _9538) * _9522) * _9520.x) * _9539) + _1605);
                                  _9560 = ((((((_9177 * _213) * _9538) * _9522) * _9520.y) * _9539) + _1606);
                                  _9561 = ((((((_9538 * _213) * _9179) * _9522) * _9520.z) * _9539) + _1607);
                                } else {
                                  _9559 = _1605;
                                  _9560 = _1606;
                                  _9561 = _1607;
                                }
                                _9567 = ((_1665 * 5.4256415367126465f) * _9506) * _9532;
                                _9575 = (((_9523.x * _9176) * _9567) + _1602);
                                _9576 = (((_9523.y * _9177) * _9567) + _1603);
                                _9577 = (((_9523.z * _9179) * _9567) + _1604);
                                _9578 = _9559;
                                _9579 = _9560;
                                _9580 = _9561;
                              } else {
                                _9575 = _1602;
                                _9576 = _1603;
                                _9577 = _1604;
                                _9578 = _1605;
                                _9579 = _1606;
                                _9580 = _1607;
                              }
                            } else {
                              _9575 = _1602;
                              _9576 = _1603;
                              _9577 = _1604;
                              _9578 = _1605;
                              _9579 = _1606;
                              _9580 = _1607;
                            }
                          } else {
                            _9575 = _1602;
                            _9576 = _1603;
                            _9577 = _1604;
                            _9578 = _1605;
                            _9579 = _1606;
                            _9580 = _1607;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _9575 = _1602;
              _9576 = _1603;
              _9577 = _1604;
              _9578 = _1605;
              _9579 = _1606;
              _9580 = _1607;
            }
          } else {
            _9575 = _1602;
            _9576 = _1603;
            _9577 = _1604;
            _9578 = _1605;
            _9579 = _1606;
            _9580 = _1607;
          }
          _9581 = _1608 + 1u;
          if (!(_9581 == _global_2)) {
            _1602 = _9575;
            _1603 = _9576;
            _1604 = _9577;
            _1605 = _9578;
            _1606 = _9579;
            _1607 = _9580;
            _1608 = _9581;
            continue;
          }
          _9585 = _9575;
          _9586 = _9576;
          _9587 = _9577;
          _9588 = _9578;
          _9589 = _9579;
          _9590 = _9580;
          break;
        }
      } else {
        _9585 = _1485;
        _9586 = _1486;
        _9587 = _1487;
        _9588 = _1362;
        _9589 = _1366;
        _9590 = _1370;
      }
      _9592 = rsqrt(dot(float3(_138, _139, -1.0f), float3(_138, _139, -1.0f)));
      _9599 = 1.0f - _219;
      _9610 = (1.0f - _213) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_200, _202, _204), float3((-0.0f - (_138 * _9592)), (-0.0f - (_139 * _9592)), _9592))))) * 5.0f) * (max((_9599 * _9599), _213) - _213));
      _9750 = (_9610 * _9585);
      _9751 = (_9610 * _9586);
      _9752 = (_9610 * _9587);
      _9753 = _9588;
      _9754 = _9589;
      _9755 = _9590;
      _9756 = _168;
      _9757 = _169;
      _9758 = _170;
    } else {
      _9629 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _139, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _138)));
      _9632 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _139, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _138)));
      _9635 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _139, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _138)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _9739 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _9740 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _9741 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _9656 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_9629, _9632, _9635), 0.0f);
        _9660 = _9656.x * 32.0f;
        _9661 = _9656.y * 32.0f;
        _9662 = _9656.z * 32.0f;
        _9664 = rsqrt(dot(float3(_9629, _9632, _9635), float3(_9629, _9632, _9635)));
        _9665 = _9664 * _9629;
        _9666 = _9664 * _9632;
        _9667 = _9664 * _9635;
        _9668 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _9669 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _9670 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _9671 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _9672 = dot(float3(_9665, _9666, _9667), float3(_9669, _9670, _9671));
        _9677 = (_9672 * _9672) - (dot(float3(_9669, _9670, _9671), float3(_9669, _9670, _9671)) - (_9668 * _9668));
        if ((_9672 > -0.0f) && (_9677 > 0.0f)) {
          _9682 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _9695 = 74.80000305175781f / ((dot(float3(_9665, _9666, _9667), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _9668) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _9703 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_9665, _9667), float2(_9682, cbDeferredShading.vSunDirWS.x)) * _9695) + 0.5f), ((dot(float3(_9665, _9666, _9667), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _9682)), (cbDeferredShading.vSunDirWS.y * _9682))) * _9695) + 0.5f)), 0.0f);
          _9705 = _9677 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_9705 > 0.0f) {
            _9712 = saturate(_9705 * 5.0f);
            _9739 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _9703.x) * _9712) + _9660);
            _9740 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _9703.y) * _9712) + _9661);
            _9741 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _9703.z) * _9712) + _9662);
          } else {
            _9739 = _9660;
            _9740 = _9661;
            _9741 = _9662;
          }
        } else {
          _9739 = _9660;
          _9740 = _9661;
          _9741 = _9662;
        }
      }
      _9745 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _9750 = 0.0f;
      _9751 = 0.0f;
      _9752 = 0.0f;
      _9753 = select(_9745, 0.0f, _9739);
      _9754 = select(_9745, 0.0f, _9740);
      _9755 = select(_9745, 0.0f, _9741);
      _9756 = 0.0f;
      _9757 = 0.0f;
      _9758 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_67, _68)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_9756 * _9750) + _9753)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_9757 * _9751) + _9754)), 7936.0f), 5.960464477539063e-08f), max(min((((_9758 * _9752) + _9755) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_67, _68)] = float3(0.0f, 0.0f, 0.0f);
  }
}