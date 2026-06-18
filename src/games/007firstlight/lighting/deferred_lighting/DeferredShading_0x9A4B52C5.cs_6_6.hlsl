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
  uint _52;
  int _58;
  uint _63;
  uint _64;
  uint _71;
  int _74;
  int _89;
  float _258;
  float _259;
  float _260;
  float _261;
  float _351;
  float _352;
  float _390;
  int _429;
  float _430;
  float _431;
  float _432;
  int _547;
  float _548;
  float _549;
  float _550;
  float _551;
  float _552;
  float _553;
  float _554;
  float _555;
  float _556;
  float _557;
  float _558;
  float _559;
  float _560;
  float _561;
  float _676;
  float _677;
  float _678;
  float _765;
  float _766;
  float _767;
  float _785;
  float _786;
  float _787;
  float _819;
  float _820;
  float _821;
  float _822;
  float _823;
  float _824;
  float _825;
  float _839;
  float _840;
  float _841;
  float _842;
  float _843;
  float _844;
  float _845;
  float _846;
  float _847;
  float _848;
  float _849;
  float _850;
  float _851;
  float _852;
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
  float _868;
  float _869;
  float _870;
  float _919;
  float _920;
  float _921;
  float _941;
  float _942;
  float _943;
  float _954;
  float _955;
  float _956;
  float _957;
  float _958;
  float _959;
  float _962;
  float _963;
  float _964;
  float _965;
  float _966;
  float _967;
  float _968;
  float _982;
  float _983;
  float _984;
  float _985;
  float _986;
  float _987;
  float _1016;
  float _1017;
  float _1018;
  float _1038;
  float _1039;
  float _1040;
  float _1051;
  float _1052;
  float _1053;
  float _1054;
  float _1055;
  float _1056;
  float _1075;
  float _1076;
  float _1077;
  float _1078;
  float _1079;
  float _1080;
  float _1099;
  float _1100;
  float _1101;
  int _1142;
  float _1143;
  float _1261;
  float _1266;
  float _1282;
  float _1339;
  float _1349;
  float _1402;
  float _1403;
  float _1404;
  float _1457;
  float _1458;
  float _1459;
  float _1569;
  float _1574;
  float _1575;
  float _1576;
  float _1577;
  float _1578;
  float _1579;
  int _1580;
  float _2198;
  float _2199;
  float _2200;
  float _2290;
  float _2299;
  float _2308;
  float _2316;
  float _2387;
  float _2396;
  float _2405;
  float _2413;
  float _2486;
  float _2495;
  float _2504;
  float _2512;
  float _2585;
  float _2594;
  float _2603;
  float _2611;
  float _2663;
  float _2668;
  float _2765;
  float _2786;
  float _2787;
  float _2788;
  int _2807;
  float _2824;
  float _2828;
  float _2867;
  float _2899;
  float _3008;
  float _3009;
  float _3022;
  float _3034;
  float _3213;
  float _3214;
  float _3272;
  float _3360;
  float _3361;
  float _3362;
  float _3391;
  float _3500;
  float _3501;
  float _3514;
  float _3526;
  float _3705;
  float _3706;
  float _3758;
  float _3759;
  float _3760;
  float _3791;
  float _3820;
  float _3821;
  float _3822;
  float _3838;
  float _3839;
  float _3840;
  float _3853;
  float _3854;
  float _3855;
  float _4018;
  float _4019;
  float _4020;
  float _4021;
  float _4022;
  float _4023;
  float _4115;
  float _4116;
  float _4117;
  float _4118;
  float _4119;
  float _4222;
  float _4231;
  float _4240;
  float _4248;
  float _4319;
  float _4328;
  float _4337;
  float _4345;
  float _4418;
  float _4427;
  float _4436;
  float _4444;
  float _4517;
  float _4526;
  float _4535;
  float _4543;
  float _4878;
  float _4879;
  int _4880;
  float _4909;
  float _4910;
  float _4911;
  float _4912;
  float _4913;
  float _5015;
  float _5024;
  float _5033;
  float _5041;
  float _5112;
  float _5121;
  float _5130;
  float _5138;
  float _5211;
  float _5220;
  float _5229;
  float _5237;
  float _5310;
  float _5319;
  float _5328;
  float _5336;
  float _5670;
  float _5671;
  bool _5672;
  float _5687;
  float _5688;
  float _5689;
  float _5747;
  float _5748;
  float _5773;
  float _5774;
  float _5869;
  float _5872;
  float _5873;
  float _5893;
  float _5894;
  float _5895;
  int _5913;
  float _5930;
  float _5934;
  float _5961;
  float _5962;
  float _5963;
  float _5994;
  float _6023;
  float _6024;
  float _6025;
  float _6041;
  float _6042;
  float _6043;
  float _6079;
  float _6127;
  float _6128;
  float _6129;
  float _6145;
  float _6205;
  float _6206;
  float _6207;
  float _6327;
  float _6328;
  float _6342;
  float _6354;
  float _6355;
  float _6375;
  float _6562;
  float _6563;
  float _6732;
  float _6933;
  float _6934;
  float _7474;
  float _7475;
  float _7476;
  float _7566;
  float _7575;
  float _7584;
  float _7592;
  float _7663;
  float _7672;
  float _7681;
  float _7689;
  float _7762;
  float _7771;
  float _7780;
  float _7788;
  float _7861;
  float _7870;
  float _7879;
  float _7887;
  float _7939;
  float _7944;
  float _7945;
  float _8042;
  float _8043;
  float _8064;
  float _8065;
  float _8066;
  int _8085;
  float _8102;
  float _8110;
  float _8136;
  float _8137;
  float _8138;
  float _8169;
  float _8198;
  float _8199;
  float _8200;
  float _8216;
  float _8217;
  float _8218;
  float _8254;
  float _8302;
  float _8303;
  float _8304;
  float _8320;
  float _8380;
  float _8381;
  float _8382;
  float _8502;
  float _8503;
  float _8517;
  float _8529;
  float _8530;
  float _8550;
  float _8737;
  float _8738;
  float _8920;
  float _8921;
  float _8945;
  float _8946;
  float _8971;
  float _8972;
  float _8997;
  float _8998;
  float _9141;
  float _9142;
  float _9143;
  float _9167;
  float _9238;
  float _9239;
  float _9240;
  float _9254;
  float _9255;
  float _9256;
  float _9257;
  float _9258;
  float _9259;
  float _9387;
  float _9388;
  float _9389;
  float _9399;
  float _9400;
  float _9401;
  float _9402;
  float _9403;
  float _9404;
  float _9405;
  float _9406;
  float _9407;
  int _85;
  uint _91;
  int _98;
  int _103;
  int _106;
  int _108;
  int _110;
  int _112;
  float4 _117;
  float _125;
  float _126;
  float _134;
  float _135;
  float4 _138;
  float4 _142;
  float4 _148;
  float4 _154;
  float _161;
  float _162;
  float _163;
  float _165;
  float _166;
  float _167;
  float _168;
  float _170;
  float _171;
  float _175;
  float _176;
  float _180;
  float _182;
  float _183;
  float _188;
  float _189;
  float _191;
  float _192;
  float _193;
  float _194;
  bool _205;
  float _207;
  float _208;
  float _209;
  float _212;
  float _214;
  float _221;
  float _222;
  float _223;
  float _224;
  int _230;
  uint _234;
  float _240;
  float4 _249;
  float _270;
  float _271;
  float _286;
  float _287;
  float _290;
  float _291;
  float _294;
  float _295;
  float4 _300;
  float _334;
  float _336;
  bool _337;
  float _339;
  float _341;
  bool _342;
  float4 _355;
  float _359;
  float _371;
  float _372;
  float _373;
  float _374;
  float _375;
  float _376;
  bool _379;
  bool _394;
  int _395;
  float2 _398;
  float _403;
  float _404;
  float _408;
  float _410;
  float _411;
  float _416;
  float _417;
  float _419;
  float _420;
  float _421;
  float _422;
  float _424;
  float _433;
  float _434;
  float _436;
  float _437;
  float _438;
  int _446;
  int _447;
  int _448;
  int _449;
  float _453;
  float _455;
  float _456;
  float _466;
  float _471;
  float _475;
  float _476;
  float _479;
  float _492;
  float _493;
  float _494;
  float _498;
  float _513;
  float _516;
  float _519;
  float _522;
  float _525;
  float _528;
  int _564;
  int _565;
  float _568;
  float _569;
  float _570;
  float _571;
  float _574;
  float _575;
  float _576;
  float _577;
  float _580;
  float _581;
  float _582;
  float _583;
  float _586;
  float _587;
  float _588;
  float _589;
  float _592;
  float _593;
  float _594;
  float _595;
  float _598;
  float _599;
  float _600;
  float _601;
  int _604;
  float _607;
  float _608;
  float _609;
  float _612;
  float _613;
  float _614;
  int _617;
  int _620;
  int _623;
  float _652;
  float _655;
  float _658;
  float _659;
  float4 _665;
  float4 _671;
  float _680;
  float _684;
  float _687;
  float _690;
  float _731;
  float _736;
  float _738;
  float _740;
  float _747;
  float _748;
  float4 _754;
  float4 _760;
  float _768;
  float4 _774;
  float4 _780;
  float _797;
  float _798;
  float _799;
  float _800;
  float _801;
  float _802;
  float _803;
  float _804;
  float _805;
  uint _853;
  bool _876;
  int _886;
  float _888;
  float _889;
  float _896;
  float _901;
  float _902;
  bool _903;
  float4 _908;
  float4 _914;
  float _925;
  float4 _930;
  float4 _936;
  float _974;
  int _994;
  float _995;
  float _998;
  float _999;
  bool _1000;
  float4 _1005;
  float4 _1011;
  float _1022;
  float4 _1027;
  float4 _1033;
  float _1061;
  float _1115;
  float _1116;
  float _1123;
  float _1124;
  float _1128;
  float _1132;
  float _1133;
  float _1134;
  float _1138;
  uint _1144;
  int _1147;
  int _1148;
  int _1152;
  int _1156;
  float _1168;
  float _1173;
  float _1174;
  float _1175;
  float _1176;
  float _1179;
  float _1180;
  float _1181;
  float _1182;
  float _1185;
  float _1186;
  float _1187;
  float _1188;
  int _1191;
  int _1194;
  int _1197;
  int _1200;
  float _1215;
  float _1219;
  float _1223;
  float _1248;
  float _1249;
  float _1250;
  float _1253;
  uint _1262;
  bool _1270;
  float _1285;
  float _1287;
  float _1288;
  float _1289;
  float _1290;
  float _1295;
  float _1296;
  float _1297;
  float _1298;
  float _1300;
  float _1309;
  float _1310;
  float _1315;
  float _1321;
  float _1329;
  float _1340;
  float _1341;
  float _1342;
  int _1352;
  int _1355;
  int _1356;
  int _1357;
  int _1363;
  int _1364;
  int _1365;
  int _1371;
  int _1372;
  int _1373;
  float _1379;
  float _1383;
  float _1387;
  float _1394;
  int _1407;
  int _1410;
  int _1411;
  int _1412;
  int _1418;
  int _1419;
  int _1420;
  int _1426;
  int _1427;
  int _1428;
  float _1434;
  float _1438;
  float _1442;
  float _1449;
  float _1482;
  float _1486;
  float _1490;
  float _1509;
  float _1513;
  float _1517;
  float _1530;
  float _1531;
  float _1532;
  uint _1570;
  int _1582;
  int _1586;
  int _1587;
  int _1588;
  int _1589;
  int _1601;
  int _1605;
  float _1617;
  int _1620;
  float _1637;
  float _1642;
  float _1643;
  float _1644;
  float _1645;
  float _1648;
  float _1649;
  float _1650;
  float _1651;
  float _1654;
  float _1655;
  float _1656;
  float _1657;
  int _1660;
  int _1663;
  int _1666;
  int _1669;
  int _1672;
  float _1674;
  float _1675;
  float _1677;
  float _1681;
  float _1694;
  float _1698;
  float _1702;
  float _1727;
  float _1728;
  float _1729;
  float _1732;
  float _1733;
  float _1740;
  float _1761;
  float _1762;
  float _1763;
  float _1764;
  float _1767;
  float _1768;
  float _1769;
  float _1770;
  float _1773;
  float _1774;
  float _1775;
  float _1776;
  float _1779;
  float _1780;
  float _1781;
  float _1784;
  int _1787;
  int _1790;
  int _1793;
  int _1796;
  int _1799;
  float _1802;
  float _1803;
  float _1804;
  float _1805;
  int _1808;
  int _1811;
  int _1814;
  int _1817;
  int _1820;
  int _1823;
  int _1826;
  int _1829;
  float _1831;
  float _1832;
  float _1834;
  float _1838;
  float _1840;
  int _1843;
  float _1853;
  float _1854;
  float _1856;
  float _1857;
  float _1858;
  float _1859;
  float _1878;
  float _1882;
  float _1883;
  float _1884;
  float _1888;
  float _1892;
  float _1896;
  float _1897;
  float _1920;
  float _1921;
  float _1922;
  float _1925;
  float _1926;
  float _1933;
  float _1934;
  float _1935;
  float _1940;
  float _1942;
  float _1943;
  float _1946;
  float _1950;
  float _1959;
  float _1960;
  float _1961;
  int _1962;
  float _1967;
  float _1976;
  float _1977;
  float _1979;
  float4 _1984;
  float _1989;
  float _1991;
  float _1993;
  float _1995;
  float _1999;
  float _2001;
  float _2005;
  float _2007;
  int _2014;
  float _2019;
  float _2028;
  float _2029;
  float4 _2035;
  float _2040;
  float _2042;
  float _2046;
  float _2048;
  float _2052;
  float _2054;
  float _2058;
  float _2060;
  int _2067;
  float _2072;
  float _2081;
  float _2082;
  float4 _2088;
  float _2093;
  float _2095;
  float _2099;
  float _2101;
  float _2105;
  float _2107;
  float _2111;
  float _2113;
  int _2120;
  float _2125;
  float _2134;
  float _2135;
  float4 _2141;
  float _2146;
  float _2148;
  float _2152;
  float _2154;
  float _2158;
  float _2160;
  float _2164;
  float _2166;
  float _2167;
  float _2178;
  float _2184;
  float _2186;
  float _2188;
  float _2195;
  float _2203;
  float _2204;
  float _2213;
  float _2217;
  float _2226;
  float _2227;
  float _2228;
  float _2233;
  int _2234;
  float _2239;
  float _2248;
  float _2249;
  float _2251;
  float _2253;
  float _2254;
  float4 _2256;
  float _2260;
  float _2261;
  float _2264;
  float _2265;
  float _2270;
  float _2271;
  float _2274;
  float _2275;
  float _2277;
  float _2279;
  bool _2280;
  bool _2281;
  bool _2291;
  bool _2300;
  float _2317;
  float _2319;
  float _2321;
  float _2323;
  float _2327;
  float _2329;
  float _2333;
  float _2335;
  int _2342;
  float _2347;
  float _2356;
  float _2357;
  float _2360;
  float _2361;
  float4 _2363;
  float _2367;
  float _2368;
  float _2371;
  float _2372;
  float _2374;
  float _2376;
  bool _2377;
  bool _2378;
  bool _2388;
  bool _2397;
  float _2414;
  float _2416;
  float _2420;
  float _2422;
  float _2426;
  float _2428;
  float _2432;
  float _2434;
  int _2441;
  float _2446;
  float _2455;
  float _2456;
  float _2459;
  float _2460;
  float4 _2462;
  float _2466;
  float _2467;
  float _2470;
  float _2471;
  float _2473;
  float _2475;
  bool _2476;
  bool _2477;
  bool _2487;
  bool _2496;
  float _2513;
  float _2515;
  float _2519;
  float _2521;
  float _2525;
  float _2527;
  float _2531;
  float _2533;
  int _2540;
  float _2545;
  float _2554;
  float _2555;
  float _2558;
  float _2559;
  float4 _2561;
  float _2565;
  float _2566;
  float _2569;
  float _2570;
  float _2572;
  float _2574;
  bool _2575;
  bool _2576;
  bool _2586;
  bool _2595;
  float _2612;
  float _2614;
  float _2618;
  float _2620;
  float _2624;
  float _2626;
  float _2630;
  float _2632;
  float _2633;
  float _2644;
  float _2650;
  float _2652;
  float _2654;
  float _2674;
  float4 _2681;
  float _2695;
  float _2696;
  float _2697;
  float _2698;
  float _2700;
  float _2705;
  float _2708;
  float _2709;
  float _2711;
  float _2712;
  float _2717;
  float _2722;
  float _2724;
  float _2727;
  float _2728;
  float _2733;
  float _2735;
  float _2737;
  float _2739;
  float _2744;
  float _2750;
  float _2752;
  float3 _2778;
  float _2789;
  float4 _2810;
  int _2838;
  int _2843;
  int _2845;
  int _2846;
  int _2848;
  int _2849;
  int _2858;
  bool _2871;
  float _2874;
  float _2876;
  float _2877;
  float _2878;
  float _2879;
  float _2880;
  float _2881;
  float _2889;
  float _2894;
  float _2900;
  float _2904;
  float _2906;
  float _2907;
  float _2910;
  float _2913;
  bool _2917;
  float _2921;
  float _2923;
  float _2924;
  float _2932;
  float _2935;
  float _2936;
  float _2941;
  float _2950;
  float _2951;
  float _2954;
  float _2956;
  float _2957;
  float _2958;
  float _2960;
  float _2961;
  float _2962;
  float _2963;
  float _2968;
  float _2982;
  float _2987;
  float _2988;
  float _2990;
  float _2996;
  float _2999;
  float _3010;
  float _3011;
  float _3012;
  float _3023;
  float _3038;
  float _3041;
  float _3049;
  float _3053;
  float _3054;
  float _3055;
  float _3058;
  float _3059;
  float _3067;
  float _3073;
  float _3075;
  float _3099;
  float _3100;
  float _3101;
  float _3102;
  bool _3105;
  float _3106;
  float _3107;
  float _3108;
  float _3110;
  float _3113;
  float _3115;
  float _3116;
  float _3117;
  float _3118;
  float _3121;
  float _3124;
  float _3127;
  float _3129;
  float _3133;
  float _3142;
  float _3143;
  float _3145;
  float _3146;
  float _3147;
  float _3154;
  float _3155;
  float _3156;
  float _3159;
  float _3162;
  float _3165;
  float _3166;
  float _3167;
  float _3170;
  float _3171;
  float _3177;
  float _3181;
  float _3182;
  float _3183;
  float _3184;
  float _3185;
  float _3186;
  float _3191;
  float _3192;
  float _3200;
  float _3201;
  float _3216;
  float _3231;
  float _3238;
  float _3239;
  float _3240;
  float _3253;
  float _3254;
  float _3255;
  float _3258;
  float _3275;
  float _3276;
  float _3277;
  float _3278;
  float _3281;
  float _3282;
  float _3283;
  float _3284;
  float _3287;
  float _3288;
  float _3289;
  int _3292;
  int _3295;
  int _3298;
  int _3301;
  int _3304;
  int _3307;
  float _3310;
  float _3313;
  int _3315;
  float2 _3335;
  float3 _3352;
  float _3365;
  float _3368;
  float _3369;
  float _3370;
  float _3371;
  float _3372;
  float _3373;
  float _3381;
  float _3386;
  float _3392;
  float _3396;
  float _3398;
  float _3399;
  float _3402;
  float _3405;
  bool _3409;
  float _3413;
  float _3415;
  float _3416;
  float _3424;
  float _3427;
  float _3428;
  float _3433;
  float _3442;
  float _3443;
  float _3446;
  float _3448;
  float _3449;
  float _3450;
  float _3452;
  float _3453;
  float _3454;
  float _3455;
  float _3460;
  float _3474;
  float _3479;
  float _3480;
  float _3482;
  float _3488;
  float _3491;
  float _3502;
  float _3503;
  float _3504;
  float _3515;
  float _3530;
  float _3533;
  float _3541;
  float _3545;
  float _3546;
  float _3547;
  float _3550;
  float _3551;
  float _3559;
  float _3565;
  float _3567;
  float _3591;
  float _3592;
  float _3593;
  float _3594;
  bool _3597;
  float _3598;
  float _3599;
  float _3600;
  float _3602;
  float _3605;
  float _3607;
  float _3608;
  float _3609;
  float _3610;
  float _3613;
  float _3616;
  float _3619;
  float _3621;
  float _3625;
  float _3634;
  float _3635;
  float _3637;
  float _3638;
  float _3639;
  float _3646;
  float _3647;
  float _3648;
  float _3651;
  float _3654;
  float _3657;
  float _3658;
  float _3659;
  float _3662;
  float _3663;
  float _3669;
  float _3673;
  float _3674;
  float _3675;
  float _3676;
  float _3677;
  float _3678;
  float _3683;
  float _3684;
  float _3692;
  float _3693;
  float _3708;
  float _3723;
  float _3748;
  bool _3761;
  float _3762;
  float _3763;
  float _3764;
  bool _3765;
  float _3767;
  float _3768;
  float _3772;
  float _3778;
  float _3792;
  float _3793;
  float _3796;
  float _3800;
  int _3801;
  float _3803;
  float _3805;
  float _3808;
  float _3812;
  float _3823;
  float _3824;
  float _3825;
  float _3827;
  float _3841;
  float _3842;
  float _3843;
  float _3859;
  float _3860;
  float _3861;
  float _3864;
  float _3882;
  float _3883;
  float _3884;
  float _3887;
  float _3888;
  float _3889;
  float _3892;
  float _3893;
  float _3894;
  float _3897;
  float _3898;
  float _3899;
  float _3902;
  float _3903;
  float _3904;
  int _3907;
  int _3910;
  int _3913;
  int _3916;
  int _3919;
  int _3922;
  int _3925;
  int _3928;
  int _3931;
  int _3934;
  int _3937;
  float _3940;
  float _3941;
  float _3942;
  float _3943;
  int _3946;
  int _3949;
  int _3952;
  int _3955;
  float _3957;
  float _3958;
  float _3960;
  float _3964;
  float _3965;
  float _3967;
  float _3971;
  float _3973;
  float _3974;
  float _3976;
  int _3979;
  bool _3983;
  float _3991;
  float _3992;
  float _3994;
  float _3997;
  float _3998;
  float _4000;
  float _4001;
  float _4003;
  float _4004;
  float _4008;
  float _4014;
  float _4015;
  float _4016;
  float _4027;
  float _4028;
  float _4029;
  float _4030;
  float _4031;
  float _4032;
  float _4033;
  float _4034;
  float _4035;
  float _4038;
  float _4039;
  float _4040;
  float _4043;
  float _4050;
  float _4063;
  float _4067;
  float _4071;
  float _4072;
  float _4073;
  float _4076;
  float _4079;
  bool _4081;
  float _4087;
  float _4088;
  float _4089;
  float _4094;
  float _4095;
  float _4096;
  bool _4100;
  bool _4106;
  bool _4110;
  float _4120;
  float _4124;
  float _4133;
  float _4134;
  float _4141;
  float _4142;
  float _4145;
  float _4149;
  float _4158;
  float _4159;
  float _4160;
  float _4165;
  int _4166;
  float _4171;
  float _4180;
  float _4181;
  float _4183;
  float _4185;
  float _4186;
  float4 _4188;
  float _4192;
  float _4193;
  float _4196;
  float _4197;
  float _4202;
  float _4203;
  float _4206;
  float _4207;
  float _4209;
  float _4211;
  bool _4212;
  bool _4213;
  bool _4223;
  bool _4232;
  float _4249;
  float _4251;
  float _4253;
  float _4255;
  float _4259;
  float _4261;
  float _4265;
  float _4267;
  int _4274;
  float _4279;
  float _4288;
  float _4289;
  float _4292;
  float _4293;
  float4 _4295;
  float _4299;
  float _4300;
  float _4303;
  float _4304;
  float _4306;
  float _4308;
  bool _4309;
  bool _4310;
  bool _4320;
  bool _4329;
  float _4346;
  float _4348;
  float _4352;
  float _4354;
  float _4358;
  float _4360;
  float _4364;
  float _4366;
  int _4373;
  float _4378;
  float _4387;
  float _4388;
  float _4391;
  float _4392;
  float4 _4394;
  float _4398;
  float _4399;
  float _4402;
  float _4403;
  float _4405;
  float _4407;
  bool _4408;
  bool _4409;
  bool _4419;
  bool _4428;
  float _4445;
  float _4447;
  float _4451;
  float _4453;
  float _4457;
  float _4459;
  float _4463;
  float _4465;
  int _4472;
  float _4477;
  float _4486;
  float _4487;
  float _4490;
  float _4491;
  float4 _4493;
  float _4497;
  float _4498;
  float _4501;
  float _4502;
  float _4504;
  float _4506;
  bool _4507;
  bool _4508;
  bool _4518;
  bool _4527;
  float _4544;
  float _4546;
  float _4550;
  float _4552;
  float _4556;
  float _4558;
  float _4562;
  float _4564;
  float _4565;
  float _4576;
  float _4582;
  float _4584;
  float _4586;
  float _4595;
  float _4598;
  float _4599;
  float _4613;
  float _4614;
  float _4615;
  float _4619;
  float _4628;
  float _4629;
  float _4630;
  int _4631;
  float _4636;
  float _4645;
  float _4646;
  float _4648;
  float4 _4653;
  float _4658;
  float _4660;
  float _4662;
  float _4664;
  float _4668;
  float _4670;
  float _4674;
  float _4676;
  int _4683;
  float _4688;
  float _4697;
  float _4698;
  float4 _4704;
  float _4709;
  float _4711;
  float _4715;
  float _4717;
  float _4721;
  float _4723;
  float _4727;
  float _4729;
  int _4736;
  float _4741;
  float _4750;
  float _4751;
  float4 _4757;
  float _4762;
  float _4764;
  float _4768;
  float _4770;
  float _4774;
  float _4776;
  float _4780;
  float _4782;
  int _4789;
  float _4794;
  float _4803;
  float _4804;
  float4 _4810;
  float _4815;
  float _4817;
  float _4821;
  float _4823;
  float _4827;
  float _4829;
  float _4833;
  float _4835;
  float _4836;
  float _4847;
  float _4853;
  float _4855;
  float _4857;
  float _4865;
  float _4872;
  float _4874;
  float _4888;
  float _4889;
  float _4890;
  bool _4894;
  bool _4900;
  bool _4904;
  float _4914;
  float _4919;
  float _4928;
  float _4929;
  float _4934;
  float _4935;
  float _4938;
  float _4942;
  float _4951;
  float _4952;
  float _4953;
  float _4958;
  int _4959;
  float _4964;
  float _4973;
  float _4974;
  float _4976;
  float _4978;
  float _4979;
  float4 _4981;
  float _4985;
  float _4986;
  float _4989;
  float _4990;
  float _4995;
  float _4996;
  float _4999;
  float _5000;
  float _5002;
  float _5004;
  bool _5005;
  bool _5006;
  bool _5016;
  bool _5025;
  float _5042;
  float _5044;
  float _5046;
  float _5048;
  float _5052;
  float _5054;
  float _5058;
  float _5060;
  int _5067;
  float _5072;
  float _5081;
  float _5082;
  float _5085;
  float _5086;
  float4 _5088;
  float _5092;
  float _5093;
  float _5096;
  float _5097;
  float _5099;
  float _5101;
  bool _5102;
  bool _5103;
  bool _5113;
  bool _5122;
  float _5139;
  float _5141;
  float _5145;
  float _5147;
  float _5151;
  float _5153;
  float _5157;
  float _5159;
  int _5166;
  float _5171;
  float _5180;
  float _5181;
  float _5184;
  float _5185;
  float4 _5187;
  float _5191;
  float _5192;
  float _5195;
  float _5196;
  float _5198;
  float _5200;
  bool _5201;
  bool _5202;
  bool _5212;
  bool _5221;
  float _5238;
  float _5240;
  float _5244;
  float _5246;
  float _5250;
  float _5252;
  float _5256;
  float _5258;
  int _5265;
  float _5270;
  float _5279;
  float _5280;
  float _5283;
  float _5284;
  float4 _5286;
  float _5290;
  float _5291;
  float _5294;
  float _5295;
  float _5297;
  float _5299;
  bool _5300;
  bool _5301;
  bool _5311;
  bool _5320;
  float _5337;
  float _5339;
  float _5343;
  float _5345;
  float _5349;
  float _5351;
  float _5355;
  float _5357;
  float _5358;
  float _5369;
  float _5375;
  float _5377;
  float _5379;
  float _5388;
  float _5391;
  float _5392;
  float _5405;
  float _5406;
  float _5407;
  float _5411;
  float _5420;
  float _5421;
  float _5422;
  int _5423;
  float _5428;
  float _5437;
  float _5438;
  float _5440;
  float4 _5445;
  float _5450;
  float _5452;
  float _5454;
  float _5456;
  float _5460;
  float _5462;
  float _5466;
  float _5468;
  int _5475;
  float _5480;
  float _5489;
  float _5490;
  float4 _5496;
  float _5501;
  float _5503;
  float _5507;
  float _5509;
  float _5513;
  float _5515;
  float _5519;
  float _5521;
  int _5528;
  float _5533;
  float _5542;
  float _5543;
  float4 _5549;
  float _5554;
  float _5556;
  float _5560;
  float _5562;
  float _5566;
  float _5568;
  float _5572;
  float _5574;
  int _5581;
  float _5586;
  float _5595;
  float _5596;
  float4 _5602;
  float _5607;
  float _5609;
  float _5613;
  float _5615;
  float _5619;
  float _5621;
  float _5625;
  float _5627;
  float _5628;
  float _5639;
  float _5645;
  float _5647;
  float _5649;
  float _5657;
  float _5664;
  float _5666;
  float _5692;
  float _5694;
  float _5695;
  float _5696;
  float _5711;
  float _5714;
  float _5717;
  float _5719;
  float _5720;
  float _5721;
  float _5722;
  float _5730;
  float _5731;
  float _5732;
  bool _5734;
  float _5754;
  float4 _5779;
  float _5799;
  float _5800;
  float _5801;
  float _5802;
  float _5804;
  float _5809;
  float _5812;
  float _5813;
  float _5815;
  float _5816;
  float _5821;
  float _5826;
  float _5828;
  float _5831;
  float _5832;
  float _5837;
  float _5839;
  float _5841;
  float _5843;
  float _5848;
  float _5854;
  float _5856;
  float3 _5885;
  float4 _5916;
  float _5951;
  bool _5964;
  float _5965;
  float _5966;
  float _5967;
  bool _5968;
  float _5970;
  float _5971;
  float _5975;
  float _5981;
  float _5995;
  float _5996;
  float _5999;
  float _6003;
  int _6004;
  float _6006;
  float _6008;
  float _6011;
  float _6015;
  float _6026;
  float _6027;
  float _6028;
  float _6030;
  int _6050;
  int _6055;
  int _6057;
  int _6058;
  int _6060;
  int _6061;
  int _6070;
  bool _6083;
  float _6086;
  float _6088;
  float _6089;
  float _6090;
  float _6091;
  float _6092;
  float _6093;
  float _6094;
  float _6095;
  float _6096;
  float _6097;
  float _6098;
  float _6099;
  bool _6100;
  float _6101;
  float _6102;
  float _6105;
  float _6106;
  float _6108;
  float _6135;
  float _6140;
  float _6147;
  float _6148;
  float _6149;
  float _6151;
  float _6155;
  float _6156;
  float _6157;
  float _6158;
  float _6159;
  float _6160;
  float _6161;
  float _6167;
  float _6176;
  float _6180;
  float _6181;
  float _6182;
  float _6183;
  float _6187;
  float _6188;
  float _6189;
  float _6197;
  float _6209;
  float _6210;
  float _6211;
  float _6212;
  float _6213;
  float _6217;
  float _6219;
  float _6221;
  float _6222;
  float _6223;
  float _6224;
  float _6225;
  float _6226;
  float _6229;
  bool _6236;
  float _6240;
  float _6242;
  float _6243;
  float _6251;
  float _6254;
  float _6255;
  float _6260;
  float _6269;
  float _6270;
  float _6273;
  float _6275;
  float _6276;
  float _6277;
  float _6279;
  float _6280;
  float _6281;
  float _6282;
  float _6287;
  float _6301;
  float _6306;
  float _6307;
  float _6309;
  float _6315;
  float _6318;
  float _6329;
  float _6330;
  float _6331;
  float _6332;
  float _6351;
  float _6362;
  float _6379;
  float _6382;
  float _6390;
  float _6394;
  float _6395;
  float _6396;
  float _6399;
  float _6400;
  float _6401;
  float _6409;
  float _6415;
  float _6417;
  float _6441;
  float _6442;
  float _6443;
  float _6444;
  bool _6447;
  float _6448;
  float _6449;
  float _6450;
  float _6452;
  float _6455;
  float _6457;
  float _6458;
  float _6459;
  float _6460;
  float _6463;
  float _6466;
  float _6469;
  float _6471;
  float _6475;
  float _6484;
  float _6485;
  float _6487;
  float _6488;
  float _6489;
  float _6496;
  float _6497;
  float _6498;
  float _6501;
  float _6504;
  float _6507;
  float _6511;
  float _6515;
  float _6516;
  float _6519;
  float _6520;
  float _6526;
  float _6530;
  float _6531;
  float _6532;
  float _6533;
  float _6534;
  float _6535;
  float _6540;
  float _6541;
  float _6549;
  float _6550;
  float _6565;
  float _6580;
  float _6587;
  float _6588;
  float _6589;
  float _6602;
  float _6603;
  float _6604;
  float _6608;
  float _6626;
  float _6627;
  float _6628;
  float _6631;
  float _6632;
  float _6633;
  float _6636;
  int _6639;
  int _6642;
  int _6645;
  float _6654;
  float _6657;
  float _6664;
  float _6669;
  float _6671;
  float _6673;
  float _6674;
  float _6675;
  float _6677;
  float _6678;
  float _6679;
  float _6682;
  float _6683;
  float _6684;
  float _6687;
  float _6694;
  int _6703;
  int _6708;
  int _6710;
  int _6711;
  int _6713;
  int _6714;
  int _6723;
  bool _6736;
  float _6739;
  float _6741;
  float _6742;
  float _6745;
  float _6748;
  float _6752;
  float _6753;
  float _6754;
  float _6758;
  float _6760;
  float _6768;
  float _6772;
  float _6773;
  float _6774;
  float _6777;
  float _6778;
  float _6779;
  float _6787;
  float _6793;
  float _6795;
  float _6819;
  float _6820;
  float _6821;
  float _6822;
  bool _6825;
  float _6826;
  float _6827;
  float _6828;
  float _6830;
  float _6833;
  float _6835;
  float _6836;
  float _6837;
  float _6838;
  float _6841;
  float _6844;
  float _6847;
  float _6849;
  float _6853;
  float _6862;
  float _6863;
  float _6865;
  float _6866;
  float _6867;
  float _6874;
  float _6875;
  float _6876;
  float _6879;
  float _6882;
  float _6885;
  float _6886;
  float _6887;
  float _6890;
  float _6891;
  float _6897;
  float _6901;
  float _6902;
  float _6903;
  float _6904;
  float _6905;
  float _6906;
  float _6911;
  float _6912;
  float _6920;
  float _6921;
  float _6936;
  float _6951;
  float _6958;
  float _6959;
  float _6960;
  float _6973;
  float _6974;
  float _6975;
  float _6979;
  float _6997;
  float _6998;
  float _6999;
  float _7002;
  float _7003;
  float _7004;
  float _7007;
  float _7008;
  float _7009;
  float _7012;
  float _7013;
  float _7014;
  float _7017;
  float _7018;
  float _7019;
  float _7022;
  float _7023;
  float _7024;
  int _7027;
  int _7030;
  int _7033;
  int _7036;
  float _7039;
  float _7040;
  float _7041;
  float _7042;
  int _7045;
  int _7048;
  int _7051;
  int _7054;
  int _7057;
  int _7060;
  int _7063;
  float _7066;
  float _7067;
  float _7068;
  float _7069;
  int _7072;
  int _7075;
  int _7078;
  float _7080;
  float _7081;
  float _7083;
  float _7087;
  float _7088;
  float _7090;
  float _7094;
  int _7098;
  float _7114;
  float _7115;
  float _7117;
  float _7118;
  float _7119;
  float _7120;
  float _7121;
  float _7122;
  float _7123;
  float _7124;
  float _7125;
  float _7126;
  float _7127;
  float _7128;
  float _7129;
  float _7132;
  float _7133;
  float _7134;
  float _7137;
  float _7148;
  float _7152;
  float _7159;
  float _7160;
  float _7161;
  float _7173;
  float _7174;
  float _7175;
  float _7176;
  float _7179;
  float _7180;
  float _7183;
  float _7184;
  float _7191;
  float _7193;
  float _7199;
  bool _7201;
  float _7209;
  float _7210;
  float _7211;
  float _7216;
  float _7218;
  float _7219;
  float _7222;
  float _7226;
  float _7235;
  float _7236;
  float _7237;
  int _7238;
  float _7243;
  float _7252;
  float _7253;
  float _7255;
  float4 _7260;
  float _7265;
  float _7267;
  float _7269;
  float _7271;
  float _7275;
  float _7277;
  float _7281;
  float _7283;
  int _7290;
  float _7295;
  float _7304;
  float _7305;
  float4 _7311;
  float _7316;
  float _7318;
  float _7322;
  float _7324;
  float _7328;
  float _7330;
  float _7334;
  float _7336;
  int _7343;
  float _7348;
  float _7357;
  float _7358;
  float4 _7364;
  float _7369;
  float _7371;
  float _7375;
  float _7377;
  float _7381;
  float _7383;
  float _7387;
  float _7389;
  int _7396;
  float _7401;
  float _7410;
  float _7411;
  float4 _7417;
  float _7422;
  float _7424;
  float _7428;
  float _7430;
  float _7434;
  float _7436;
  float _7440;
  float _7442;
  float _7443;
  float _7454;
  float _7460;
  float _7462;
  float _7464;
  float _7471;
  float _7479;
  float _7480;
  float _7489;
  float _7493;
  float _7502;
  float _7503;
  float _7504;
  float _7509;
  int _7510;
  float _7515;
  float _7524;
  float _7525;
  float _7527;
  float _7529;
  float _7530;
  float4 _7532;
  float _7536;
  float _7537;
  float _7540;
  float _7541;
  float _7546;
  float _7547;
  float _7550;
  float _7551;
  float _7553;
  float _7555;
  bool _7556;
  bool _7557;
  bool _7567;
  bool _7576;
  float _7593;
  float _7595;
  float _7597;
  float _7599;
  float _7603;
  float _7605;
  float _7609;
  float _7611;
  int _7618;
  float _7623;
  float _7632;
  float _7633;
  float _7636;
  float _7637;
  float4 _7639;
  float _7643;
  float _7644;
  float _7647;
  float _7648;
  float _7650;
  float _7652;
  bool _7653;
  bool _7654;
  bool _7664;
  bool _7673;
  float _7690;
  float _7692;
  float _7696;
  float _7698;
  float _7702;
  float _7704;
  float _7708;
  float _7710;
  int _7717;
  float _7722;
  float _7731;
  float _7732;
  float _7735;
  float _7736;
  float4 _7738;
  float _7742;
  float _7743;
  float _7746;
  float _7747;
  float _7749;
  float _7751;
  bool _7752;
  bool _7753;
  bool _7763;
  bool _7772;
  float _7789;
  float _7791;
  float _7795;
  float _7797;
  float _7801;
  float _7803;
  float _7807;
  float _7809;
  int _7816;
  float _7821;
  float _7830;
  float _7831;
  float _7834;
  float _7835;
  float4 _7837;
  float _7841;
  float _7842;
  float _7845;
  float _7846;
  float _7848;
  float _7850;
  bool _7851;
  bool _7852;
  bool _7862;
  bool _7871;
  float _7888;
  float _7890;
  float _7894;
  float _7896;
  float _7900;
  float _7902;
  float _7906;
  float _7908;
  float _7909;
  float _7920;
  float _7926;
  float _7928;
  float _7930;
  float _7951;
  float4 _7958;
  float _7972;
  float _7973;
  float _7974;
  float _7975;
  float _7977;
  float _7982;
  float _7985;
  float _7986;
  float _7988;
  float _7989;
  float _7994;
  float _7999;
  float _8001;
  float _8004;
  float _8005;
  float _8010;
  float _8012;
  float _8014;
  float _8016;
  float _8021;
  float _8027;
  float _8029;
  float3 _8056;
  float _8067;
  float4 _8088;
  float _8126;
  bool _8139;
  float _8140;
  float _8141;
  float _8142;
  bool _8143;
  float _8145;
  float _8146;
  float _8150;
  float _8156;
  float _8170;
  float _8171;
  float _8174;
  float _8178;
  int _8179;
  float _8181;
  float _8183;
  float _8186;
  float _8190;
  float _8201;
  float _8202;
  float _8203;
  float _8205;
  int _8225;
  int _8230;
  int _8232;
  int _8233;
  int _8235;
  int _8236;
  int _8245;
  bool _8258;
  float _8261;
  float _8263;
  float _8264;
  float _8265;
  float _8266;
  float _8267;
  float _8268;
  float _8269;
  float _8270;
  float _8271;
  float _8272;
  float _8273;
  float _8274;
  bool _8275;
  float _8276;
  float _8277;
  float _8280;
  float _8281;
  float _8283;
  float _8310;
  float _8315;
  float _8322;
  float _8323;
  float _8324;
  float _8326;
  float _8330;
  float _8331;
  float _8332;
  float _8333;
  float _8334;
  float _8335;
  float _8336;
  float _8342;
  float _8351;
  float _8355;
  float _8356;
  float _8357;
  float _8358;
  float _8362;
  float _8363;
  float _8364;
  float _8372;
  float _8384;
  float _8385;
  float _8386;
  float _8387;
  float _8388;
  float _8392;
  float _8394;
  float _8396;
  float _8397;
  float _8398;
  float _8399;
  float _8400;
  float _8401;
  float _8404;
  bool _8411;
  float _8415;
  float _8417;
  float _8418;
  float _8426;
  float _8429;
  float _8430;
  float _8435;
  float _8444;
  float _8445;
  float _8448;
  float _8450;
  float _8451;
  float _8452;
  float _8454;
  float _8455;
  float _8456;
  float _8457;
  float _8462;
  float _8476;
  float _8481;
  float _8482;
  float _8484;
  float _8490;
  float _8493;
  float _8504;
  float _8505;
  float _8506;
  float _8507;
  float _8526;
  float _8537;
  float _8554;
  float _8557;
  float _8565;
  float _8569;
  float _8570;
  float _8571;
  float _8574;
  float _8575;
  float _8576;
  float _8584;
  float _8590;
  float _8592;
  float _8616;
  float _8617;
  float _8618;
  float _8619;
  bool _8622;
  float _8623;
  float _8624;
  float _8625;
  float _8627;
  float _8630;
  float _8632;
  float _8633;
  float _8634;
  float _8635;
  float _8638;
  float _8641;
  float _8644;
  float _8646;
  float _8650;
  float _8659;
  float _8660;
  float _8662;
  float _8663;
  float _8664;
  float _8671;
  float _8672;
  float _8673;
  float _8676;
  float _8679;
  float _8682;
  float _8686;
  float _8690;
  float _8691;
  float _8694;
  float _8695;
  float _8701;
  float _8705;
  float _8706;
  float _8707;
  float _8708;
  float _8709;
  float _8710;
  float _8715;
  float _8716;
  float _8724;
  float _8725;
  float _8740;
  float _8755;
  float _8762;
  float _8763;
  float _8764;
  float _8777;
  float _8778;
  float _8779;
  float _8783;
  float _8801;
  float _8802;
  float _8803;
  float _8804;
  float _8807;
  float _8808;
  float _8809;
  float _8810;
  float _8813;
  float _8814;
  float _8815;
  float _8816;
  float _8819;
  float _8820;
  int _8823;
  int _8826;
  int _8829;
  int _8832;
  float _8835;
  float _8837;
  float _8838;
  float _8840;
  float _8844;
  float _8846;
  float _8850;
  float _8854;
  float _8858;
  float _8861;
  float _8864;
  float _8867;
  float _8879;
  float _8880;
  float _8881;
  float _8882;
  float _8883;
  float _8884;
  float _8885;
  float _8886;
  float _8887;
  float _8888;
  float _8889;
  float _8891;
  float _8893;
  float _8895;
  float _8897;
  float _8898;
  float _8904;
  float _8906;
  float _8913;
  float _8928;
  float _8930;
  float _8937;
  float _8947;
  float _8953;
  float _8955;
  float _8962;
  float _8979;
  float _8981;
  float _8988;
  float _9007;
  float _9008;
  float _9009;
  float _9010;
  float _9012;
  float _9014;
  float _9015;
  float _9016;
  float _9017;
  float _9018;
  float _9019;
  float _9020;
  float _9021;
  float _9023;
  float _9025;
  float _9026;
  float _9027;
  float _9028;
  float _9029;
  float _9030;
  float _9031;
  float _9033;
  float _9035;
  float _9042;
  bool _9055;
  float _9057;
  float _9063;
  float _9067;
  float _9069;
  float _9070;
  bool _9071;
  float _9073;
  float _9079;
  float _9080;
  float _9085;
  float _9086;
  float _9089;
  float _9091;
  float _9098;
  float _9111;
  float _9113;
  float _9120;
  float _9149;
  float _9150;
  float _9159;
  float _9172;
  float _9181;
  float _9188;
  float _9191;
  float4 _9199;
  float _9201;
  float4 _9202;
  float _9211;
  float _9217;
  float _9218;
  float _9246;
  uint _9260;
  float _9277;
  float _9280;
  float _9283;
  float4 _9304;
  float _9308;
  float _9309;
  float _9310;
  float _9312;
  float _9313;
  float _9314;
  float _9315;
  float _9316;
  float _9317;
  float _9318;
  float _9319;
  float _9320;
  float _9325;
  float _9330;
  float _9343;
  float4 _9351;
  float _9353;
  float _9360;
  bool _9393;
  int __loop_jump_target = -1;
  _52 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _58 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _63 = ((uint)(((int)(_58 << 3)) & 524280)) + SV_GroupThreadID.x;
  _64 = ((uint)(((uint)(_58) >> 16) << 3)) + SV_GroupThreadID.y;
  _71 = ((int)((((uint)(_64) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_63) >> 4)))) << 6;
  _74 = srvDeferredClusters[_71];
  if (_52 == 0) {
    _global_2 = (_74 & 255);
    _global_0 = (((uint)(_74) >> 16) & 255);
    _global_1 = (((uint)(_74) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _85 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_85 == 0)) {
    _89 = 0;
    while(true) {
      _91 = (_89 << 6) + _52;
      if ((uint)_91 < (uint)_global_2) {
        _98 = srvDeferredClusters[((int)(((uint)(_71 | 1)) + _91))];
        _global_3[min((uint)(_91), 63u)] = _98;
        _103 = _98 & 4095;
        _106 = srvLightInfoBase[_103].nFlags;
        _108 = srvLightInfoBase[_103].nRoomMask;
        _110 = srvLightInfoBase[_103].nBufferOffset;
        _global_4[min((uint)(_91), 63u)] = _106;
        _global_5[min((uint)(_91), 63u)] = _108;
        _global_6[min((uint)(_91), 63u)] = _110;
      }
      _112 = _89 + 1;
      if (!(_112 == _85)) {
        _89 = _112;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _117 = srvGlobalGBuffer0.Load(int3(_63, _64, 0));
  [branch]
  if (_117.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_63, _64)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_63, _64)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _125 = (float)((uint)_63);
    _126 = (float)((uint)_64);
    _134 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _125) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
    _135 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _126) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
    [branch]
    if (_117.x > 0.0f) {
      _138 = srvGlobalGBuffer1.Load(int3(_63, _64, 0));
      _142 = srvGlobalGBuffer2.Load(int3(_63, _64, 0));
      _148 = srvGlobalGBuffer3.Load(int3(_63, _64, 0));
      _154 = srvGlobalGBuffer4.Load(int3(_63, _64, 0));
      _161 = saturate(_142.x);
      _162 = saturate(_142.y);
      _163 = saturate(_142.z);
      _165 = saturate(_148.x);
      _166 = saturate(_148.y);
      _167 = saturate(_148.z);
      _168 = saturate(_148.w);
      _170 = saturate(_154.y);
      _171 = saturate(_154.z);
      _175 = (saturate(_138.x) * 2.0f) + -1.0f;
      _176 = (saturate(_138.y) * 2.0f) + -1.0f;
      _180 = (1.0f - abs(_175)) - abs(_176);
      _182 = saturate(-0.0f - _180);
      _183 = -0.0f - _182;
      _188 = select((_175 >= 0.0f), _183, _182) + _175;
      _189 = select((_176 >= 0.0f), _183, _182) + _176;
      _191 = rsqrt(dot(float3(_188, _189, _180), float3(_188, _189, _180)));
      _192 = _188 * _191;
      _193 = _189 * _191;
      _194 = _191 * _180;
      _205 = ((int)(uint((_171 * 1.9921875f) + 0.003921568859368563f)) != 0);
      _207 = _165 * _165;
      _208 = _166 * _166;
      _209 = _167 * _167;
      _212 = (_171 - (((float)((bool)_205)) * 0.501960813999176f)) * 2.007874011993408f;
      _214 = min(1.0f, max(saturate(_154.x), 0.019999999552965164f));
      _221 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _117.x) - cbSharedPerViewData.vViewRemap.y);
      _222 = _221 * _134;
      _223 = _221 * _135;
      _224 = -0.0f - _221;
      _230 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _234 = srvReflectionsWeight.Load(int3(((uint)(_63) >> _230), ((uint)(_64) >> _230), 0));
      _240 = ((float)((uint)((uint)(_234.x & 254)))) * 0.003921568859368563f;
      if ((_234.x & 1) == 0) {
        _249 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _125), (cbSharedPerViewData.vViewportSize.y * _126)), 0.0f);
        _258 = (1.0f - _240);
        _259 = (_249.x * _240);
        _260 = (_249.y * _240);
        _261 = (_249.z * _240);
      } else {
        _258 = 1.0f;
        _259 = 0.0f;
        _260 = 0.0f;
        _261 = 0.0f;
      }
      _270 = cbSharedPerViewData.vViewportSize.x * (_125 + 0.5f);
      _271 = cbSharedPerViewData.vViewportSize.y * (_126 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _286 = (floor((_270 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _287 = (floor((_271 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _290 = max(_286, cbDeferredShading.vScreenPixelSize.z);
        _291 = max(_287, cbDeferredShading.vScreenPixelSize.w);
        _294 = min((_286 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _295 = min((_287 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _300 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_290 + cbDeferredShading.vScreenPixelSize.z), (_291 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _300.x) - cbSharedPerViewData.vViewRemap.y)) - _221) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _300.y) - cbSharedPerViewData.vViewRemap.y)) - _221) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _300.z) - cbSharedPerViewData.vViewRemap.y)) - _221) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _300.w) - cbSharedPerViewData.vViewRemap.y)) - _221) > 0.029999999329447746f)) {
          _334 = abs(_117.x - _300.w);
          _336 = abs(_117.x - _300.z);
          _337 = (_336 < _334);
          _339 = select(_337, _336, _334);
          _341 = abs(_117.x - _300.x);
          _342 = (_341 < _339);
          if (abs(_117.x - _300.y) < select(_342, _341, _339)) {
            _351 = _294;
            _352 = _295;
          } else {
            _351 = select(_342, _290, select(_337, _294, _290));
            _352 = select(_342, _295, _291);
          }
        } else {
          _351 = _270;
          _352 = _271;
        }
      } else {
        _351 = _270;
        _352 = _271;
      }
      _355 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_351, _352), 0.0f);
      _359 = _355.x - _355.z;
      _371 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_355.y + _359)), 0.0f);
      _372 = -0.0f - _371;
      _373 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_355.x + _355.z)), 0.0f);
      _374 = -0.0f - _373;
      _375 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_359 - _355.y)), 0.0f);
      _376 = -0.0f - _375;
      _379 = (cbSharedPerViewData.nSSGIEnabled == 0);
      if (!_379) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _390 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_351, _352), 0.0f)).x);
        } else {
          _390 = 1.0f;
        }
      } else {
        _390 = 1.0f;
      }
      if (!_379) {
        _394 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
        _395 = (int)(uint)(_394);
        if (_394) {
          _398 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_351, _352), 0.0f);
          _403 = (_398.x * 2.0f) + -1.0f;
          _404 = (_398.y * 2.0f) + -1.0f;
          _408 = (1.0f - abs(_403)) - abs(_404);
          _410 = saturate(-0.0f - _408);
          _411 = -0.0f - _410;
          _416 = select((_403 >= 0.0f), _411, _410) + _403;
          _417 = select((_404 >= 0.0f), _411, _410) + _404;
          _419 = rsqrt(dot(float3(_416, _417, _408), float3(_416, _417, _408)));
          _420 = _416 * _419;
          _421 = _417 * _419;
          _422 = _419 * _408;
          _424 = rsqrt(dot(float3(_420, _421, _422), float3(_420, _421, _422)));
          _429 = _395;
          _430 = (_420 * _424);
          _431 = (_421 * _424);
          _432 = (_424 * _422);
        } else {
          _429 = _395;
          _430 = 0.0f;
          _431 = 0.0f;
          _432 = 0.0f;
        }
      } else {
        _429 = 0;
        _430 = 0.0f;
        _431 = 0.0f;
        _432 = 0.0f;
      }
      _433 = -0.0f - _134;
      _434 = -0.0f - _135;
      _436 = rsqrt(dot(float3(_433, _434, 1.0f), float3(_433, _434, 1.0f)));
      _437 = _436 * _433;
      _438 = _436 * _434;
      _446 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _64) + _63))];
      _447 = _446 & 255;
      _448 = (uint)(_446) >> 8;
      _449 = _448 & 255;
      _453 = ((float)((uint)((uint)(((uint)(_446) >> 16) & 255)))) * 0.003921568859368563f;
      _455 = (float)((uint)((uint)((uint)(_446) >> 24)));
      _456 = _455 * 0.003921568859368563f;
      [branch]
      if (!((((int)(uint((saturate(_142.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _466 = _214 * 4.0f;
        _471 = dot(float3((-0.0f - _437), (-0.0f - _438), (-0.0f - _436)), float3(_192, _193, _194)) * 2.0f;
        _475 = _214 * _214;
        _476 = 1.0f - _475;
        _479 = (sqrt(_476) + _475) * _476;
        _492 = (_479 * (((-0.0f - _192) - _437) - (_471 * _192))) + _192;
        _493 = (_479 * (((-0.0f - _193) - _438) - (_471 * _193))) + _193;
        _494 = (_479 * (((-0.0f - _194) - _436) - (_471 * _194))) + _194;
        _498 = saturate(1.0f - ((_214 + -0.30000001192092896f) * 3.3333332538604736f));
        _513 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _494, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _493, (_492 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _516 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _494, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _493, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _492)));
        _519 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _494, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _493, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _492)));
        _522 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _194, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _193, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _192)));
        _525 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _194, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _193, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _192)));
        _528 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _194, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _193, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _192)));
        if (!(_global_0 == 0)) {
          _547 = 0;
          _548 = 0.0f;
          _549 = 0.0f;
          _550 = 0.0f;
          _551 = 0.0f;
          _552 = 0.0f;
          _553 = 0.0f;
          _554 = 0.0f;
          _555 = 0.0f;
          _556 = 0.0f;
          _557 = 0.0f;
          _558 = 0.0f;
          _559 = 0.0f;
          _560 = 0.0f;
          _561 = 0.0f;
          while(true) {
            _839 = _548;
            _840 = _549;
            _841 = _550;
            _842 = _551;
            _843 = _552;
            _844 = _553;
            _845 = _554;
            _846 = _555;
            _847 = _556;
            _848 = _557;
            _849 = _558;
            _850 = _559;
            _851 = _560;
            _852 = _561;
            _564 = _global_5[min((uint)(_547), 63u)];
            _565 = _global_6[min((uint)(_547), 63u)];
            _568 = asfloat(srvLightInfoProperties.Load4(_565)).x;
            _569 = asfloat(srvLightInfoProperties.Load4(_565)).y;
            _570 = asfloat(srvLightInfoProperties.Load4(_565)).z;
            _571 = asfloat(srvLightInfoProperties.Load4(_565)).w;
            _574 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 16u)))).x;
            _575 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 16u)))).y;
            _576 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 16u)))).z;
            _577 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 16u)))).w;
            _580 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 32u)))).x;
            _581 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 32u)))).y;
            _582 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 32u)))).z;
            _583 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 32u)))).w;
            _586 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 48u)))).x;
            _587 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 48u)))).y;
            _588 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 48u)))).z;
            _589 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 48u)))).w;
            _592 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 64u)))).x;
            _593 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 64u)))).y;
            _594 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 64u)))).z;
            _595 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 64u)))).w;
            _598 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 80u)))).x;
            _599 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 80u)))).y;
            _600 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 80u)))).z;
            _601 = asfloat(srvLightInfoProperties.Load4(((int)(_565 + 80u)))).w;
            _604 = asint(srvLightInfoProperties.Load(((int)(_565 + 96u))));
            _607 = asfloat(srvLightInfoProperties.Load3(((int)(_565 + 100u)))).x;
            _608 = asfloat(srvLightInfoProperties.Load3(((int)(_565 + 100u)))).y;
            _609 = asfloat(srvLightInfoProperties.Load3(((int)(_565 + 100u)))).z;
            _612 = asfloat(srvLightInfoProperties.Load3(((int)(_565 + 112u)))).x;
            _613 = asfloat(srvLightInfoProperties.Load3(((int)(_565 + 112u)))).y;
            _614 = asfloat(srvLightInfoProperties.Load3(((int)(_565 + 112u)))).z;
            _617 = asint(srvLightInfoProperties.Load(((int)(_565 + 124u))));
            _620 = asint(srvLightInfoProperties.Load(((int)(_565 + 128u))));
            _623 = _604 & 65535;
            _652 = ((saturate(1.0f - abs(mad(_570, _224, mad(_569, _223, (_568 * _222))) + _571)) * f16tof32(((uint)((uint)(_604) >> 16)))) * saturate(1.0f - abs(mad(_576, _224, mad(_575, _223, (_574 * _222))) + _577))) * saturate(1.0f - abs(mad(_582, _224, mad(_581, _223, (_580 * _222))) + _583));
            [branch]
            if (_652 > 0.0f) {
              _655 = _652 * _652;
              [branch]
              if (_498 < 1.0f) {
                _658 = (float)((uint)_623);
                _659 = -0.0f - _513;
                [branch]
                if (!(_658 >= 341.0f)) {
                  _671 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_659, _516, _519, _658), _466);
                  _676 = _671.x;
                  _677 = _671.y;
                  _678 = _671.z;
                } else {
                  _665 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_659, _516, _519, (_658 + -341.0f)), _466);
                  _676 = _665.x;
                  _677 = _665.y;
                  _678 = _665.z;
                }
              } else {
                _676 = 0.0f;
                _677 = 0.0f;
                _678 = 0.0f;
              }
              _680 = (float)((uint)_623);
              [branch]
              if (_498 > 0.0f) {
                _684 = mad(_588, _494, mad(_587, _493, (_586 * _492)));
                _687 = mad(_594, _494, mad(_593, _493, (_592 * _492)));
                _690 = mad(_600, _494, mad(_599, _493, (_598 * _492)));
                _731 = min(((((float((int)(((int)(uint)((int)(_684 > 0.0f))) - ((int)(uint)((int)(_684 < 0.0f))))) * _607) - _589) - mad(_588, _224, mad(_587, _223, (_586 * _222)))) / _684), min(((((float((int)(((int)(uint)((int)(_687 > 0.0f))) - ((int)(uint)((int)(_687 < 0.0f))))) * _608) - _595) - mad(_594, _224, mad(_593, _223, (_592 * _222)))) / _687), ((((float((int)(((int)(uint)((int)(_690 > 0.0f))) - ((int)(uint)((int)(_690 < 0.0f))))) * _609) - _601) - mad(_600, _224, mad(_599, _223, (_598 * _222)))) / _690)));
                _736 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _224, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _223, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _222))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _612) + (_731 * _513);
                _738 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _224, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _223, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _222))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _613) + (_731 * _516);
                _740 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _224, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _223, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _222))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _614) + (_731 * _519);
                _747 = (max(log2((_731 * _731) / dot(float3(_736, _738, _740), float3(_736, _738, _740))), -1.0f) * 0.3333333432674408f) + _466;
                _748 = -0.0f - _736;
                [branch]
                if (!(_680 >= 341.0f)) {
                  _760 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_748, _738, _740, _680), _747);
                  _765 = _760.x;
                  _766 = _760.y;
                  _767 = _760.z;
                } else {
                  _754 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_748, _738, _740, (_680 + -341.0f)), _747);
                  _765 = _754.x;
                  _766 = _754.y;
                  _767 = _754.z;
                }
              } else {
                _765 = 0.0f;
                _766 = 0.0f;
                _767 = 0.0f;
              }
              _768 = -0.0f - _522;
              [branch]
              if (!(_680 >= 341.0f)) {
                _780 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_768, _525, _528, _680), 0.0f);
                _785 = _780.x;
                _786 = _780.y;
                _787 = _780.z;
              } else {
                _774 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_768, _525, _528, (_680 + -341.0f)), 0.0f);
                _785 = _774.x;
                _786 = _774.y;
                _787 = _774.z;
              }
              _797 = _655 * f16tof32(((uint)((uint)(_617) >> 16)));
              _798 = _797 * _785;
              _799 = _655 * f16tof32(_617);
              _800 = _799 * _786;
              _801 = _655 * f16tof32(((uint)((uint)(_620) >> 16)));
              _802 = _801 * _787;
              _803 = _797 * (lerp(_676, _765, _498));
              _804 = _799 * (lerp(_677, _766, _498));
              _805 = _801 * (lerp(_678, _767, _498));
              [branch]
              if (!((_564 & ((int)(1 << (_446 & 31)))) == 0)) {
                _819 = (_798 + _548);
                _820 = (_800 + _549);
                _821 = (_802 + _550);
                _822 = (_803 + _551);
                _823 = (_804 + _552);
                _824 = (_805 + _553);
                _825 = (_655 + _554);
              } else {
                _819 = _548;
                _820 = _549;
                _821 = _550;
                _822 = _551;
                _823 = _552;
                _824 = _553;
                _825 = _554;
              }
              [branch]
              if (!((_564 & ((int)(1 << (_448 & 31)))) == 0)) {
                _839 = _819;
                _840 = _820;
                _841 = _821;
                _842 = _822;
                _843 = _823;
                _844 = _824;
                _845 = _825;
                _846 = (_798 + _555);
                _847 = (_800 + _556);
                _848 = (_802 + _557);
                _849 = (_803 + _558);
                _850 = (_804 + _559);
                _851 = (_805 + _560);
                _852 = (_655 + _561);
              } else {
                _839 = _819;
                _840 = _820;
                _841 = _821;
                _842 = _822;
                _843 = _823;
                _844 = _824;
                _845 = _825;
                _846 = _555;
                _847 = _556;
                _848 = _557;
                _849 = _558;
                _850 = _559;
                _851 = _560;
                _852 = _561;
              }
            } else {
              _839 = _548;
              _840 = _549;
              _841 = _550;
              _842 = _551;
              _843 = _552;
              _844 = _553;
              _845 = _554;
              _846 = _555;
              _847 = _556;
              _848 = _557;
              _849 = _558;
              _850 = _559;
              _851 = _560;
              _852 = _561;
            }
            _853 = _547 + 1u;
            if (!(_853 == _global_0)) {
              _547 = _853;
              _548 = _839;
              _549 = _840;
              _550 = _841;
              _551 = _842;
              _552 = _843;
              _553 = _844;
              _554 = _845;
              _555 = _846;
              _556 = _847;
              _557 = _848;
              _558 = _849;
              _559 = _850;
              _560 = _851;
              _561 = _852;
              continue;
            }
            _857 = _839;
            _858 = _840;
            _859 = _841;
            _860 = _842;
            _861 = _843;
            _862 = _844;
            _863 = _845;
            _864 = _846;
            _865 = _847;
            _866 = _848;
            _867 = _849;
            _868 = _850;
            _869 = _851;
            _870 = _852;
            break;
          }
        } else {
          _857 = 0.0f;
          _858 = 0.0f;
          _859 = 0.0f;
          _860 = 0.0f;
          _861 = 0.0f;
          _862 = 0.0f;
          _863 = 0.0f;
          _864 = 0.0f;
          _865 = 0.0f;
          _866 = 0.0f;
          _867 = 0.0f;
          _868 = 0.0f;
          _869 = 0.0f;
          _870 = 0.0f;
        }
        _876 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_446 & 31)))) != 0);
        if ((_453 > 0.0f) || ((_456 > 0.0f) || _876)) {
          _886 = srvFallbackInfo[((_447 << 2) | 3)].x;
          _888 = select(_876, 9.999999747378752e-05f, (_455 * 3.921568847431445e-09f));
          _889 = _863 * 0.20000000298023224f;
          _896 = saturate((_888 - _889) / (((_863 * 0.4000000059604645f) + 9.99999993922529e-09f) - _889)) * _888;
          [branch]
          if (_896 > 0.0f) {
            [branch]
            if ((int)_886 > (int)-1) {
              _901 = float((int)(_886));
              _902 = -0.0f - _513;
              _903 = !(_901 >= 341.0f);
              [branch]
              if (_903) {
                _914 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_902, _516, _519, _901), _466);
                _919 = _914.x;
                _920 = _914.y;
                _921 = _914.z;
              } else {
                _908 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_902, _516, _519, (_901 + -341.0f)), _466);
                _919 = _908.x;
                _920 = _908.y;
                _921 = _908.z;
              }
              _925 = -0.0f - _522;
              [branch]
              if (_903) {
                _936 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_925, _525, _528, _901), 0.0f);
                _941 = _936.x;
                _942 = _936.y;
                _943 = _936.z;
              } else {
                _930 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_925, _525, _528, (_901 + -341.0f)), 0.0f);
                _941 = _930.x;
                _942 = _930.y;
                _943 = _930.z;
              }
              _954 = ((_919 * _896) + _860);
              _955 = ((_920 * _896) + _861);
              _956 = ((_921 * _896) + _862);
              _957 = ((_941 * _896) + _857);
              _958 = ((_942 * _896) + _858);
              _959 = ((_943 * _896) + _859);
            } else {
              _954 = _860;
              _955 = _861;
              _956 = _862;
              _957 = _857;
              _958 = _858;
              _959 = _859;
            }
            _962 = (_896 + _863);
            _963 = _954;
            _964 = _955;
            _965 = _956;
            _966 = _957;
            _967 = _958;
            _968 = _959;
          } else {
            _962 = _863;
            _963 = _860;
            _964 = _861;
            _965 = _862;
            _966 = _857;
            _967 = _858;
            _968 = _859;
          }
          if (_962 > 0.0f) {
            _974 = (cbSharedPerViewData.vHDRScale.x * _453) / _962;
            _982 = (_974 * _966);
            _983 = (_974 * _967);
            _984 = (_974 * _968);
            _985 = (_974 * _963);
            _986 = (_974 * _964);
            _987 = (_974 * _965);
          } else {
            _982 = 0.0f;
            _983 = 0.0f;
            _984 = 0.0f;
            _985 = 0.0f;
            _986 = 0.0f;
            _987 = 0.0f;
          }
        } else {
          _982 = 0.0f;
          _983 = 0.0f;
          _984 = 0.0f;
          _985 = 0.0f;
          _986 = 0.0f;
          _987 = 0.0f;
        }
        [branch]
        if (!(_456 == 0.0f)) {
          _994 = srvFallbackInfo[((_449 << 2) | 3)].x;
          _995 = _455 * 3.921568847431445e-09f;
          [branch]
          if ((int)_994 > (int)-1) {
            _998 = float((int)(_994));
            _999 = -0.0f - _513;
            _1000 = !(_998 >= 341.0f);
            [branch]
            if (_1000) {
              _1011 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_999, _516, _519, _998), _466);
              _1016 = _1011.x;
              _1017 = _1011.y;
              _1018 = _1011.z;
            } else {
              _1005 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_999, _516, _519, (_998 + -341.0f)), _466);
              _1016 = _1005.x;
              _1017 = _1005.y;
              _1018 = _1005.z;
            }
            _1022 = -0.0f - _522;
            [branch]
            if (_1000) {
              _1033 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1022, _525, _528, _998), 0.0f);
              _1038 = _1033.x;
              _1039 = _1033.y;
              _1040 = _1033.z;
            } else {
              _1027 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1022, _525, _528, (_998 + -341.0f)), 0.0f);
              _1038 = _1027.x;
              _1039 = _1027.y;
              _1040 = _1027.z;
            }
            _1051 = ((_1016 * _995) + _867);
            _1052 = ((_1017 * _995) + _868);
            _1053 = ((_1018 * _995) + _869);
            _1054 = ((_1038 * _995) + _864);
            _1055 = ((_1039 * _995) + _865);
            _1056 = ((_1040 * _995) + _866);
          } else {
            _1051 = _867;
            _1052 = _868;
            _1053 = _869;
            _1054 = _864;
            _1055 = _865;
            _1056 = _866;
          }
          _1061 = (cbSharedPerViewData.vHDRScale.x * _456) / (_870 + _995);
          _1075 = ((_1061 * _1054) + _982);
          _1076 = ((_1061 * _1055) + _983);
          _1077 = ((_1061 * _1056) + _984);
          _1078 = ((_1061 * _1051) + _985);
          _1079 = ((_1061 * _1052) + _986);
          _1080 = ((_1061 * _1053) + _987);
        } else {
          _1075 = _982;
          _1076 = _983;
          _1077 = _984;
          _1078 = _985;
          _1079 = _986;
          _1080 = _987;
        }
      } else {
        _1075 = 0.0f;
        _1076 = 0.0f;
        _1077 = 0.0f;
        _1078 = 0.0f;
        _1079 = 0.0f;
        _1080 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1099 = (min((_372 / max(9.999999747378752e-05f, _1075)), 1.0f) * _1078);
        _1100 = (min((_374 / max(9.999999747378752e-05f, _1076)), 1.0f) * _1079);
        _1101 = (min((_376 / max(9.999999747378752e-05f, _1077)), 1.0f) * _1080);
      } else {
        _1099 = _1078;
        _1100 = _1079;
        _1101 = _1080;
      }
      _1115 = 1.0f - _214;
      _1116 = _1115 * _1115;
      _1123 = dot(float3(_192, _193, _194), float3(_437, _438, _436));
      _1124 = saturate(_1123);
      _1128 = exp2(log2(1.0f - _1124) * 5.0f);
      _1132 = (_1128 * (max(_1116, _207) - _207)) + _207;
      _1133 = (_1128 * (max(_1116, _208) - _208)) + _208;
      _1134 = (_1128 * (max(_1116, _209) - _209)) + _209;
      _1138 = min((_170 * _170), _390);
      if (!(_global_1 == 0)) {
        _1142 = 0;
        _1143 = _1138;
        while(true) {
          _1261 = _1143;
          _1144 = _1142 + (uint)(_global_0);
          _1147 = _global_5[min((uint)(_1144), 63u)];
          _1148 = _global_6[min((uint)(_1144), 63u)];
          _1152 = (int)((int)(_1147 << (((int)(31u - _446)) & 31))) >> 31;
          _1156 = (int)((int)(_1147 << ((31 - _448) & 31))) >> 31;
          _1168 = saturate((asfloat((_1152 & asint(_453))) + asfloat((_1156 & asint(_456)))) + asfloat(((_1156 & 1065353216) & _1152)));
          [branch]
          if (!(_1168 == 0.0f)) {
            _1173 = asfloat(srvLightInfoProperties.Load4(_1148)).x;
            _1174 = asfloat(srvLightInfoProperties.Load4(_1148)).y;
            _1175 = asfloat(srvLightInfoProperties.Load4(_1148)).z;
            _1176 = asfloat(srvLightInfoProperties.Load4(_1148)).w;
            _1179 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 16u)))).x;
            _1180 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 16u)))).y;
            _1181 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 16u)))).z;
            _1182 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 16u)))).w;
            _1185 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 32u)))).x;
            _1186 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 32u)))).y;
            _1187 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 32u)))).z;
            _1188 = asfloat(srvLightInfoProperties.Load4(((int)(_1148 + 32u)))).w;
            _1191 = asint(srvLightInfoProperties.Load(((int)(_1148 + 48u))));
            _1194 = asint(srvLightInfoProperties.Load(((int)(_1148 + 52u))));
            _1197 = asint(srvLightInfoProperties.Load(((int)(_1148 + 56u))));
            _1200 = asint(srvLightInfoProperties.Load(((int)(_1148 + 60u))));
            _1215 = mad(_1175, _224, mad(_1174, _223, (_1173 * _222))) + _1176;
            _1219 = mad(_1181, _224, mad(_1180, _223, (_1179 * _222))) + _1182;
            _1223 = mad(_1187, _224, mad(_1186, _223, (_1185 * _222))) + _1188;
            _1248 = saturate(1.0f - ((_1215 + 1.0f) * f16tof32(_1194))) + saturate(1.0f - ((1.0f - _1215) * f16tof32(((uint)((uint)(_1194) >> 16)))));
            _1249 = saturate(1.0f - ((_1219 + 1.0f) * f16tof32(_1197))) + saturate(1.0f - ((1.0f - _1219) * f16tof32(((uint)((uint)(_1197) >> 16)))));
            _1250 = saturate(1.0f - ((_1223 + 1.0f) * f16tof32(_1200))) + saturate(1.0f - ((1.0f - _1223) * f16tof32(((uint)((uint)(_1200) >> 16)))));
            _1253 = saturate(1.0f - dot(float3(_1248, _1249, _1250), float3(_1248, _1249, _1250)));
            _1261 = (saturate(1.0f - ((_1253 * _1253) * (f16tof32(((uint)((uint)(_1191) >> 16))) * _1168))) * _1143);
          } else {
            _1261 = _1143;
          }
          _1262 = _1142 + 1u;
          if (!(_1262 == _global_1)) {
            _1142 = _1262;
            _1143 = _1261;
            continue;
          }
          _1266 = _1261;
          break;
        }
      } else {
        _1266 = _1138;
      }
      _1270 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
      if (_1270) {
        _1282 = saturate((_1266 + -1.0f) + exp2((_214 * _214) * log2(max((_1266 + saturate(dot(float3(_437, _438, _436), float3(_192, _193, _194)))), 0.0f))));
      } else {
        _1282 = _1266;
      }
      if (!(_429 == 0)) {
        _1285 = rsqrt(dot(float3(_430, _431, _432), float3(_430, _431, _432)));
        _1287 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
        _1288 = _1287 * _192;
        _1289 = _1287 * _193;
        _1290 = _1287 * _194;
        if (_1270) {
          _1295 = max(_214, 0.10000000149011612f);
          _1296 = -0.0f - _437;
          _1297 = -0.0f - _438;
          _1298 = -0.0f - _436;
          _1300 = dot(float3(_1296, _1297, _1298), float3(_1288, _1289, _1290)) * 2.0f;
          _1309 = min(max(dot(float3((_1285 * _430), (_1285 * _431), (_1285 * _432)), float3((_1296 - (_1300 * _1288)), (_1297 - (_1300 * _1289)), (_1298 - (_1300 * _1290)))), -1.0f), 1.0f);
          _1310 = abs(_1309);
          _1315 = (1.5707963705062866f - (_1310 * 0.1565829962491989f)) * sqrt(1.0f - _1310);
          _1321 = abs((_1295 - _1266) * 3.1415927410125732f);
          _1329 = saturate(1.0f - saturate((select((_1309 >= 0.0f), _1315, (3.1415927410125732f - _1315)) - _1321) / (((_1295 + _1266) * 3.1415927410125732f) - _1321)));
          _1339 = (((_1329 * _1329) * saturate((_1266 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1329 * 2.0f)));
        } else {
          _1339 = _1266;
        }
      } else {
        _1339 = _1282;
      }
      _1340 = (_1132 * ((cbSharedPerViewData.vHDRScale.x * _259) + (_1099 * _258))) * _1339;
      _1341 = (_1133 * ((cbSharedPerViewData.vHDRScale.x * _260) + (_1100 * _258))) * _1339;
      _1342 = (_1134 * ((cbSharedPerViewData.vHDRScale.x * _261) + (_1101 * _258))) * _1339;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1349 = _1266;
      } else {
        _1349 = 1.0f;
      }
      if (_453 > 0.0f) {
        _1352 = _447 * 3;
        _1355 = srvRoomInfo[_1352].x;
        _1356 = srvRoomInfo[_1352].y;
        _1357 = srvRoomInfo[_1352].z;
        _1363 = srvRoomInfo[(_1352 + 1)].x;
        _1364 = srvRoomInfo[(_1352 + 1)].y;
        _1365 = srvRoomInfo[(_1352 + 1)].z;
        _1371 = srvRoomInfo[(_1352 + 2)].x;
        _1372 = srvRoomInfo[(_1352 + 2)].y;
        _1373 = srvRoomInfo[(_1352 + 2)].z;
        _1379 = saturate(dot(float3(_192, _193, _194), float3(asfloat(_1355), asfloat(_1356), asfloat(_1357))) + 0.5f);
        _1383 = (_1379 * _1379) * (3.0f - (_1379 * 2.0f));
        _1387 = 1.0f - _1383;
        _1394 = _1349 * _453;
        _1402 = ((_1394 * ((_1387 * asfloat(_1371)) + (_1383 * asfloat(_1363)))) - _371);
        _1403 = ((_1394 * ((_1387 * asfloat(_1372)) + (_1383 * asfloat(_1364)))) - _373);
        _1404 = ((_1394 * ((_1387 * asfloat(_1373)) + (_1383 * asfloat(_1365)))) - _375);
      } else {
        _1402 = _372;
        _1403 = _374;
        _1404 = _376;
      }
      if (_456 > 0.0f) {
        _1407 = _449 * 3;
        _1410 = srvRoomInfo[_1407].x;
        _1411 = srvRoomInfo[_1407].y;
        _1412 = srvRoomInfo[_1407].z;
        _1418 = srvRoomInfo[(_1407 + 1)].x;
        _1419 = srvRoomInfo[(_1407 + 1)].y;
        _1420 = srvRoomInfo[(_1407 + 1)].z;
        _1426 = srvRoomInfo[(_1407 + 2)].x;
        _1427 = srvRoomInfo[(_1407 + 2)].y;
        _1428 = srvRoomInfo[(_1407 + 2)].z;
        _1434 = saturate(dot(float3(_192, _193, _194), float3(asfloat(_1410), asfloat(_1411), asfloat(_1412))) + 0.5f);
        _1438 = (_1434 * _1434) * (3.0f - (_1434 * 2.0f));
        _1442 = 1.0f - _1438;
        _1449 = _1349 * _456;
        _1457 = ((_1449 * ((_1442 * asfloat(_1426)) + (_1438 * asfloat(_1418)))) + _1402);
        _1458 = ((_1449 * ((_1442 * asfloat(_1427)) + (_1438 * asfloat(_1419)))) + _1403);
        _1459 = ((_1449 * ((_1442 * asfloat(_1428)) + (_1438 * asfloat(_1420)))) + _1404);
      } else {
        _1457 = _1402;
        _1458 = _1403;
        _1459 = _1404;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1482 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _224, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _223, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _222))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1486 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _224, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _223, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _222))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1490 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _224, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _223, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _222))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1509 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1490, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1486, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1482))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1513 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1490, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1486, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1482))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1517 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1490, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1486, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1482))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1530 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1531 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1532 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1569 = min(min(saturate((_1509 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1530), 9.999999747378752e-06f)), saturate((1.0f - _1509) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1530), 9.999999747378752e-06f))), min(min(saturate((_1513 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1531), 9.999999747378752e-06f)), saturate((1.0f - _1513) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1531), 9.999999747378752e-06f))), min(saturate((_1517 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1532), 9.999999747378752e-06f)), saturate((1.0f - _1517) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1532), 9.999999747378752e-06f)))));
      } else {
        _1569 = 0.0f;
      }
      _1570 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1570 < (uint)_global_2) {
        _1574 = _1457;
        _1575 = _1458;
        _1576 = _1459;
        _1577 = _1340;
        _1578 = _1341;
        _1579 = _1342;
        _1580 = _1570;
        while(true) {
          _9254 = _1574;
          _9255 = _1575;
          _9256 = _1576;
          _9257 = _1577;
          _9258 = _1578;
          _9259 = _1579;
          _1582 = _global_3[min((uint)(_1580), 63u)];
          _1586 = _global_4[min((uint)(_1580), 63u)];
          _1587 = _global_5[min((uint)(_1580), 63u)];
          _1588 = _global_6[min((uint)(_1580), 63u)];
          _1589 = _1582 & 4095;
          [branch]
          if (((((int)(uint(saturate(_154.w) * 255.0f)) & 64) != 0) || ((_1586 & 8388608) == 0)) && (_205 || ((_1586 & 16777216) == 0))) {
            _1601 = (int)((int)(_1587 << (((int)(31u - _446)) & 31))) >> 31;
            _1605 = (int)((int)(_1587 << ((31 - _448) & 31))) >> 31;
            _1617 = saturate((asfloat((_1601 & asint(_453))) + asfloat((_1605 & asint(_456)))) + asfloat(((_1605 & 1065353216) & _1601)));
            [branch]
            if (!(_1617 == 0.0f)) {
              _1620 = (uint)(_1582) >> 12;
              if (_1620 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _3272 = (_1617 * select(((_1586 & 67108864) != 0), 1.0f, (1.0f - _1569)));
                } else {
                  _3272 = _1617;
                }
                _3275 = asfloat(srvLightInfoProperties.Load4(_1588)).x;
                _3276 = asfloat(srvLightInfoProperties.Load4(_1588)).y;
                _3277 = asfloat(srvLightInfoProperties.Load4(_1588)).z;
                _3278 = asfloat(srvLightInfoProperties.Load4(_1588)).w;
                _3281 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).x;
                _3282 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).y;
                _3283 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).z;
                _3284 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).w;
                _3287 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).x;
                _3288 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).y;
                _3289 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).z;
                _3292 = asint(srvLightInfoProperties.Load(((int)(_1588 + 68u))));
                _3295 = asint(srvLightInfoProperties.Load(((int)(_1588 + 72u))));
                _3298 = asint(srvLightInfoProperties.Load(((int)(_1588 + 76u))));
                _3301 = asint(srvLightInfoProperties.Load(((int)(_1588 + 84u))));
                _3304 = asint(srvLightInfoProperties.Load(((int)(_1588 + 88u))));
                _3307 = asint(srvLightInfoProperties.Load(((int)(_1588 + 92u))));
                _3310 = (float)((uint)((uint)(((uint)(_3292) >> 8) & 255)));
                _3313 = f16tof32(((uint)((uint)(_3295) >> 16)));
                _3315 = (uint)(_3298) >> 16;
                _3335 = srvDeferredShadingPass_DeferredShadows.Load(int3(_63, _64, 0));
                [branch]
                if (!(_3335.x == 0.0f)) {
                  [branch]
                  if (!(_3315 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3315)))];
                    _3352 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3277, _224, mad(_3276, _223, (_3275 * _222))) + _3278) * f16tof32(((uint)((uint)(_3304) >> 16)))) + f16tof32(((uint)((uint)(_3307) >> 16)))), (((mad(_3283, _224, mad(_3282, _223, (_3281 * _222))) + _3284) * f16tof32(_3304)) + f16tof32(_3307))), 0.0f);
                    _3360 = (_3352.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _3361 = (_3352.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _3362 = (_3352.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _3360 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _3361 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _3362 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  _3365 = min(_3335.x, _3335.y) * _3272;
                  [branch]
                  if (_3365 > 0.0f) {
                    _3368 = dot(float3(_3287, _3288, _3289), float3(_3287, _3288, _3289));
                    _3369 = rsqrt(_3368);
                    _3370 = _3369 * _3287;
                    _3371 = _3369 * _3288;
                    _3372 = _3369 * _3289;
                    _3373 = dot(float3(_192, _193, _194), float3(_3370, _3371, _3372));
                    if (_3313 > 0.0f) {
                      _3381 = sqrt(saturate((_3313 * _3313) * (1.0f / (_3368 + 1.0f))));
                      if (_3373 < _3381) {
                        _3386 = max(_3373, (-0.0f - _3381)) + _3381;
                        _3391 = ((_3386 * _3386) / (_3381 * 4.0f));
                      } else {
                        _3391 = _3373;
                      }
                    } else {
                      _3391 = _3373;
                    }
                    _3392 = _214 * _214;
                    _3396 = saturate((_3313 * (1.0f - _3392)) * _3369);
                    _3398 = saturate(_3369 * f16tof32(_3295));
                    _3399 = dot(float3(_437, _438, _436), float3(_3370, _3371, _3372));
                    _3402 = rsqrt((_3399 * 2.0f) + 2.0f);
                    _3405 = saturate(_3402 * (_1123 + _3373));
                    _3409 = (_3396 > 0.0f);
                    if (_3409) {
                      _3413 = sqrt(1.0f - (_3396 * _3396));
                      _3415 = (_3373 * 2.0f) * _1123;
                      _3416 = _3415 - _3399;
                      if (!(_3416 >= _3413)) {
                        _3424 = rsqrt(1.0f - (_3416 * _3416)) * _3396;
                        _3427 = _3424 * (_1123 - (_3416 * _3373));
                        _3428 = _1123 * _1123;
                        _3433 = _3424 * (((_3428 * 2.0f) + -1.0f) - (_3416 * _3399));
                        _3442 = sqrt(saturate((((1.0f - (_3373 * _3373)) - _3428) - (_3399 * _3399)) + (_3415 * _3399)));
                        _3443 = _3442 * _3424;
                        _3446 = ((_1123 * 2.0f) * _3424) * _3442;
                        _3448 = (_3413 * _3373) + _1123;
                        _3449 = _3448 + _3427;
                        _3450 = _3413 * _3399;
                        _3452 = (_3450 + 1.0f) + _3433;
                        _3453 = _3443 * _3452;
                        _3454 = _3449 * _3452;
                        _3455 = _3446 * _3449;
                        _3460 = (((_3449 * 0.25f) * _3446) - (_3453 * 0.5f)) * _3454;
                        _3474 = (((_3455 - (_3453 * 2.0f)) * _3455) + (_3453 * _3453)) + ((((-0.5f - ((_3452 + _3450) * 0.5f)) * _3454) + ((_3452 * _3452) * _3448)) * _3449);
                        _3479 = (_3460 * 2.0f) / ((_3474 * _3474) + (_3460 * _3460));
                        _3480 = _3474 * _3479;
                        _3482 = 1.0f - (_3460 * _3479);
                        _3488 = ((_3480 * _3446) + _3450) + (_3482 * _3433);
                        _3491 = rsqrt((_3488 * 2.0f) + 2.0f);
                        _3500 = saturate((_3488 * _3491) + _3491);
                        _3501 = saturate(((_3448 + (_3480 * _3443)) + (_3482 * _3427)) * _3491);
                      } else {
                        _3500 = abs(_1123);
                        _3501 = 1.0f;
                      }
                    } else {
                      _3500 = saturate((_3402 * _3399) + _3402);
                      _3501 = _3405;
                    }
                    _3502 = saturate(_3391);
                    _3503 = saturate(_3373);
                    _3504 = _3392 * _3392;
                    if (_3398 > 0.0f) {
                      _3514 = saturate(((_3398 * _3398) / ((_3500 * 3.5999999046325684f) + 0.4000000059604645f)) + _3504);
                    } else {
                      _3514 = _3504;
                    }
                    _3515 = sqrt(_3514);
                    if (_3409) {
                      _3526 = (_3514 / ((((_3396 * 0.25f) * ((_3515 * 3.0f) + _3396)) / (_3500 + 0.0010000000474974513f)) + _3514));
                    } else {
                      _3526 = 1.0f;
                    }
                    _3530 = (((_3514 * _3501) - _3501) * _3501) + 1.0f;
                    _3533 = (_3514 / (_3530 * _3530)) * _3526;
                    _3541 = exp2(log2(1.0f - saturate(_3500)) * 5.0f);
                    _3545 = (_3541 * (1.0f - _207)) + _207;
                    _3546 = (_3541 * (1.0f - _208)) + _208;
                    _3547 = (_3541 * (1.0f - _209)) + _209;
                    _3550 = saturate(abs(_1123) + 9.999999747378752e-06f);
                    _3551 = 1.0f - _3515;
                    _3559 = 0.5f / ((((_3551 * _3550) + _3515) * _3502) + (((_3551 * _3502) + _3515) * _3550));
                    if (_212 < 0.007874015718698502f) {
                      _3565 = _3501 * _3501;
                      _3567 = max((1.0f - _3565), 9.999999747378752e-05f);
                      _3705 = (((((((exp2(((-0.0f - (_3565 / _3567)) / _3514) * 1.4426950216293335f) * 4.0f) / (_3567 * _3567)) + 1.0f) * (1.0f / ((_3514 * 4.0f) + 1.0f))) - _3533) * _168) + _3533);
                      _3706 = (((saturate(0.25f / ((_3503 + _1124) - (_3503 * _1124))) - _3559) * _168) + _3559);
                    } else {
                      _3591 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
                      _3592 = _3591 * _192;
                      _3593 = _3591 * _193;
                      _3594 = _3591 * _194;
                      _3597 = (abs(_3592) < abs(_3593));
                      _3598 = select(_3597, 1.0f, 0.0f);
                      _3599 = select(_3597, 0.0f, 1.0f);
                      _3600 = _3599 * _3594;
                      _3602 = -0.0f - (_3594 * _3598);
                      _3605 = (_3598 * _3593) - (_3599 * _3592);
                      _3607 = rsqrt(dot(float3(_3600, _3602, _3605), float3(_3600, _3602, _3605)));
                      _3608 = _3600 * _3607;
                      _3609 = _3607 * _3602;
                      _3610 = _3605 * _3607;
                      _3613 = (_3609 * _3594) - (_3610 * _3593);
                      _3616 = (_3610 * _3592) - (_3608 * _3594);
                      _3619 = (_3608 * _3593) - (_3609 * _3592);
                      _3621 = rsqrt(dot(float3(_3613, _3616, _3619), float3(_3613, _3616, _3619)));
                      _3625 = _168 * 4.0f;
                      _3634 = saturate(abs(_3625 + -2.5f) + -0.5f) + -0.5f;
                      _3635 = saturate(1.5f - abs(_3625 + -1.5f)) + -0.5f;
                      _3637 = rsqrt(dot(float2(_3634, _3635), float2(_3634, _3635)));
                      _3638 = _3637 * _3634;
                      _3639 = _3637 * _3635;
                      _3646 = ((_3613 * _3621) * _3638) + (_3639 * _3608);
                      _3647 = ((_3616 * _3621) * _3638) + (_3639 * _3609);
                      _3648 = ((_3619 * _3621) * _3638) + (_3639 * _3610);
                      _3651 = (_3647 * _194) - (_3648 * _193);
                      _3654 = (_3648 * _192) - (_3646 * _194);
                      _3657 = (_3646 * _193) - (_3647 * _192);
                      _3658 = dot(float3(_3646, _3647, _3648), float3(_3370, _3371, _3372));
                      _3659 = dot(float3(_3646, _3647, _3648), float3(_437, _438, _436));
                      _3662 = dot(float3(_3651, _3654, _3657), float3(_3370, _3371, _3372));
                      _3663 = dot(float3(_3651, _3654, _3657), float3(_437, _438, _436));
                      _3669 = min(max((_3392 * (_212 + 1.0f)), 0.0010000000474974513f), 1.0f);
                      _3673 = min(max((_3392 * (1.0f - _212)), 0.0010000000474974513f), 1.0f);
                      _3674 = _3673 * _3669;
                      _3675 = ((_3659 + _3658) * _3402) * _3673;
                      _3676 = ((_3663 + _3662) * _3402) * _3669;
                      _3677 = _3674 * _3405;
                      _3678 = dot(float3(_3675, _3676, _3677), float3(_3675, _3676, _3677));
                      _3683 = _3669 * _3659;
                      _3684 = _3673 * _3663;
                      _3692 = _3669 * _3658;
                      _3693 = _3673 * _3662;
                      _3705 = (((_3674 * _3674) * _3674) / (_3678 * _3678));
                      _3706 = saturate(0.5f / ((sqrt(((_3692 * _3692) + (_3503 * _3503)) + (_3693 * _3693)) * _3550) + (sqrt(((_3684 * _3684) + (_3683 * _3683)) + (_3550 * _3550)) * _3503)));
                    }
                    _3708 = (_3705 * _3503) * _3706;
                    _3723 = saturate((_3373 + 0.5f) * 0.6666666865348816f);
                    [branch]
                    if (!((_3301 & 1) == 0)) {
                      _3748 = max(max(_3360, _3361), _3362);
                      if (_3748 > 0.0f) {
                        _3758 = saturate(_3360 / _3748);
                        _3759 = saturate(_3361 / _3748);
                        _3760 = saturate(_3362 / _3748);
                      } else {
                        _3758 = _3360;
                        _3759 = _3361;
                        _3760 = _3362;
                      }
                      _3761 = (_3759 < _3760);
                      _3762 = select(_3761, _3760, _3759);
                      _3763 = select(_3761, _3759, _3760);
                      _3764 = select(_3761, -1.0f, 0.0f);
                      _3765 = (_3758 < _3762);
                      _3767 = select(_3765, _3762, _3758);
                      _3768 = select(_3765, _3758, _3762);
                      _3772 = _3767 - select((_3768 < _3763), _3768, _3763);
                      _3778 = abs(select(_3765, (-0.3333333432674408f - _3764), _3764) + ((_3768 - _3763) / ((_3772 * 6.0f) + 9.999999682655225e-21f)));
                      if (_3778 < 0.6666666865348816f) {
                        _3791 = ((saturate(((float)((uint)((uint)(((uint)(_3301) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3778 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3778)) + _3778);
                      } else {
                        _3791 = _3778;
                      }
                      _3792 = saturate((_3772 / (_3767 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3301) >> 1) & 255)))) * 0.003921499941498041f));
                      _3793 = saturate(_3767);
                      if (!(_3792 <= 0.0f)) {
                        _3796 = saturate(_3791);
                        _3800 = select(((_3796 * 360.0f) >= 360.0f), 0.0f, (_3796 * 6.0f));
                        _3801 = int(_3800);
                        _3803 = _3800 - float((int)(_3801));
                        _3805 = _3793 * (1.0f - _3792);
                        _3808 = (1.0f - (_3803 * _3792)) * _3793;
                        _3812 = (1.0f - ((1.0f - _3803) * _3792)) * _3793;
                        switch (_3801) {
                          case 0: {
                            _3820 = _3793;
                            _3821 = _3812;
                            _3822 = _3805;
                            break;
                          }
                          case 1: {
                            _3820 = _3808;
                            _3821 = _3793;
                            _3822 = _3805;
                            break;
                          }
                          case 2: {
                            _3820 = _3805;
                            _3821 = _3793;
                            _3822 = _3812;
                            break;
                          }
                          case 3: {
                            _3820 = _3805;
                            _3821 = _3808;
                            _3822 = _3793;
                            break;
                          }
                          case 4: {
                            _3820 = _3812;
                            _3821 = _3805;
                            _3822 = _3793;
                            break;
                          }
                          case 5: {
                            _3820 = _3793;
                            _3821 = _3805;
                            _3822 = _3808;
                            break;
                          }
                          default: {
                            _3820 = 0.0f;
                            _3821 = 0.0f;
                            _3822 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _3820 = _3793;
                        _3821 = _3793;
                        _3822 = _3793;
                      }
                      _3823 = _3820 * _3748;
                      _3824 = _3821 * _3748;
                      _3825 = _3822 * _3748;
                      _3827 = saturate(_3365 * 1.0101009607315063f);
                      _3838 = ((_3827 * (_3360 - _3823)) + _3823);
                      _3839 = ((_3827 * (_3361 - _3824)) + _3824);
                      _3840 = (lerp(_3825, _3362, _3827));
                    } else {
                      _3838 = _3360;
                      _3839 = _3361;
                      _3840 = _3362;
                    }
                    _3841 = _3838 * _3365;
                    _3842 = _3839 * _3365;
                    _3843 = _3840 * _3365;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _3853 = (_3841 * _1266);
                      _3854 = (_3842 * _1266);
                      _3855 = (_3843 * _1266);
                    } else {
                      _3853 = _3841;
                      _3854 = _3842;
                      _3855 = _3843;
                    }
                    _3859 = (((_3723 * (1.0f - _3545)) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _3503)) * _3853) + _1574;
                    _3860 = (((_3723 * (1.0f - _3546)) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _3503)) * _3854) + _1575;
                    _3861 = (((_3723 * (1.0f - _3547)) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _3503)) * _3855) + _1576;
                    if ((_3310 * 0.003921499941498041f) > 0.0f) {
                      _3864 = (_1339 * 0.003921499941498041f) * _3310;
                      _9254 = _3859;
                      _9255 = _3860;
                      _9256 = _3861;
                      _9257 = ((((_3545 * _3864) * _3708) * _3853) + _1577);
                      _9258 = ((((_3546 * _3864) * _3708) * _3854) + _1578);
                      _9259 = ((((_3547 * _3864) * _3708) * _3855) + _1579);
                    } else {
                      _9254 = _3859;
                      _9255 = _3860;
                      _9256 = _3861;
                      _9257 = _1577;
                      _9258 = _1578;
                      _9259 = _1579;
                    }
                  } else {
                    _9254 = _1574;
                    _9255 = _1575;
                    _9256 = _1576;
                    _9257 = _1577;
                    _9258 = _1578;
                    _9259 = _1579;
                  }
                } else {
                  _9254 = _1574;
                  _9255 = _1575;
                  _9256 = _1576;
                  _9257 = _1577;
                  _9258 = _1578;
                  _9259 = _1579;
                }
              } else {
                _1637 = _1617 * select(((_1586 & 67108864) != 0), 1.0f, (1.0f - _1569));
                [branch]
                if (_1620 == 4) {
                  _1642 = asfloat(srvLightInfoProperties.Load4(_1588)).x;
                  _1643 = asfloat(srvLightInfoProperties.Load4(_1588)).y;
                  _1644 = asfloat(srvLightInfoProperties.Load4(_1588)).z;
                  _1645 = asfloat(srvLightInfoProperties.Load4(_1588)).w;
                  _1648 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).x;
                  _1649 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).y;
                  _1650 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).z;
                  _1651 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).w;
                  _1654 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).x;
                  _1655 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).y;
                  _1656 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).z;
                  _1657 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).w;
                  _1660 = asint(srvLightInfoProperties.Load(((int)(_1588 + 48u))));
                  _1663 = asint(srvLightInfoProperties.Load(((int)(_1588 + 52u))));
                  _1666 = asint(srvLightInfoProperties.Load(((int)(_1588 + 64u))));
                  _1669 = asint(srvLightInfoProperties.Load(((int)(_1588 + 68u))));
                  _1672 = asint(srvLightInfoProperties.Load(((int)(_1588 + 72u))));
                  _1674 = f16tof32(((uint)((uint)(_1660) >> 16)));
                  _1675 = f16tof32(_1660);
                  _1677 = f16tof32(((uint)((uint)(_1663) >> 16)));
                  _1681 = ((float)((uint)((uint)(((uint)(_1663) >> 8) & 255)))) * 0.003921499941498041f;
                  _1694 = mad(_1644, _224, mad(_1643, _223, (_1642 * _222))) + _1645;
                  _1698 = mad(_1650, _224, mad(_1649, _223, (_1648 * _222))) + _1651;
                  _1702 = mad(_1656, _224, mad(_1655, _223, (_1654 * _222))) + _1657;
                  _1727 = saturate(1.0f - ((_1694 + 1.0f) * f16tof32(_1666))) + saturate(1.0f - ((1.0f - _1694) * f16tof32(((uint)((uint)(_1666) >> 16)))));
                  _1728 = saturate(1.0f - ((_1698 + 1.0f) * f16tof32(_1669))) + saturate(1.0f - ((1.0f - _1698) * f16tof32(((uint)((uint)(_1669) >> 16)))));
                  _1729 = saturate(1.0f - ((_1702 + 1.0f) * f16tof32(_1672))) + saturate(1.0f - ((1.0f - _1702) * f16tof32(((uint)((uint)(_1672) >> 16)))));
                  _1732 = saturate(1.0f - dot(float3(_1727, _1728, _1729), float3(_1727, _1728, _1729)));
                  _1733 = _1732 * _1732;
                  _1740 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1733 * _1266), _1733) * _1637;
                  _9254 = ((_1740 * _1674) + _1574);
                  _9255 = ((_1740 * _1675) + _1575);
                  _9256 = ((_1740 * _1677) + _1576);
                  _9257 = (((_1681 * _1674) * _1740) + _1577);
                  _9258 = (((_1681 * _1675) * _1740) + _1578);
                  _9259 = (((_1677 * _1681) * _1740) + _1579);
                } else {
                  if (_1620 == 5) {
                    _1761 = asfloat(srvLightInfoProperties.Load4(_1588)).x;
                    _1762 = asfloat(srvLightInfoProperties.Load4(_1588)).y;
                    _1763 = asfloat(srvLightInfoProperties.Load4(_1588)).z;
                    _1764 = asfloat(srvLightInfoProperties.Load4(_1588)).w;
                    _1767 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).x;
                    _1768 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).y;
                    _1769 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).z;
                    _1770 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).w;
                    _1773 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).x;
                    _1774 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).y;
                    _1775 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).z;
                    _1776 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).w;
                    _1779 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).x;
                    _1780 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).y;
                    _1781 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).z;
                    _1784 = asfloat(srvLightInfoProperties.Load(((int)(_1588 + 60u))));
                    _1787 = asint(srvLightInfoProperties.Load(((int)(_1588 + 64u))));
                    _1790 = asint(srvLightInfoProperties.Load(((int)(_1588 + 68u))));
                    _1793 = asint(srvLightInfoProperties.Load(((int)(_1588 + 80u))));
                    _1796 = asint(srvLightInfoProperties.Load(((int)(_1588 + 84u))));
                    _1799 = asint(srvLightInfoProperties.Load(((int)(_1588 + 88u))));
                    _1802 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 92u)))).x;
                    _1803 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 92u)))).y;
                    _1804 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 92u)))).z;
                    _1805 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 92u)))).w;
                    _1808 = asint(srvLightInfoProperties.Load(((int)(_1588 + 108u))));
                    _1811 = asint(srvLightInfoProperties.Load(((int)(_1588 + 112u))));
                    _1814 = asint(srvLightInfoProperties.Load(((int)(_1588 + 120u))));
                    _1817 = asint(srvLightInfoProperties.Load(((int)(_1588 + 124u))));
                    _1820 = asint(srvLightInfoProperties.Load(((int)(_1588 + 128u))));
                    _1823 = asint(srvLightInfoProperties.Load(((int)(_1588 + 132u))));
                    _1826 = asint(srvLightInfoProperties.Load(((int)(_1588 + 136u))));
                    _1829 = asint(srvLightInfoProperties.Load(((int)(_1588 + 140u))));
                    _1831 = f16tof32(((uint)((uint)(_1787) >> 16)));
                    _1832 = f16tof32(_1787);
                    _1834 = f16tof32(((uint)((uint)(_1790) >> 16)));
                    _1838 = ((float)((uint)((uint)(((uint)(_1790) >> 8) & 255)))) * 0.003921499941498041f;
                    _1840 = f16tof32(((uint)((uint)(_1793) >> 16)));
                    _1843 = _1796 & 65535;
                    _1853 = f16tof32(((uint)((uint)(_1811) >> 16)));
                    _1854 = f16tof32(_1811);
                    _1856 = f16tof32(((uint)((uint)(_1814) >> 16)));
                    _1857 = 1.0f / _1856;
                    _1858 = _1856 + -1.0f;
                    _1859 = f16tof32(_1814);
                    _1878 = saturate(1.0f - dot(float3(_192, _193, _194), float3(_1779, _1780, _1781))) * f16tof32(_1808);
                    _1882 = (_1878 * _192) + _222;
                    _1883 = (_1878 * _193) + _223;
                    _1884 = (_1878 * _194) - _221;
                    _1888 = mad(_1763, _1884, mad(_1762, _1883, (_1882 * _1761))) + _1764;
                    _1892 = mad(_1769, _1884, mad(_1768, _1883, (_1882 * _1767))) + _1770;
                    _1896 = mad(_1775, _1884, mad(_1774, _1883, (_1882 * _1773))) + _1776;
                    _1897 = saturate(_1896);
                    _1920 = saturate(1.0f - (_1888 * f16tof32(_1823))) + saturate(1.0f - ((1.0f - _1888) * f16tof32(((uint)((uint)(_1823) >> 16)))));
                    _1921 = saturate(1.0f - (_1892 * f16tof32(_1826))) + saturate(1.0f - ((1.0f - _1892) * f16tof32(((uint)((uint)(_1826) >> 16)))));
                    _1922 = saturate(1.0f - (_1896 * f16tof32(_1829))) + saturate(1.0f - ((1.0f - _1896) * f16tof32(((uint)((uint)(_1829) >> 16)))));
                    _1925 = saturate(1.0f - dot(float3(_1920, _1921, _1922), float3(_1920, _1921, _1922)));
                    _1926 = _1925 * _1925;
                    if (!(((_1586 & 3584) == 0) || (!(_1926 > 0.0f)))) {
                      _1933 = 1.0f - _1897;
                      _1934 = saturate(_1888);
                      _1935 = saturate(_1892);
                      bool __branch_chain_1930;
                      [branch]
                      if ((_1586 & 1024) == 0) {
                        _2198 = 1.0f;
                        _2199 = 0.0f;
                        _2200 = _1933;
                        __branch_chain_1930 = true;
                      } else {
                        _1940 = ((_1934 * _1858) + 0.5f) * _1857;
                        _1942 = ((_1935 * _1858) + 0.5f) * _1857;
                        _1943 = _1933 + f16tof32(((uint)((uint)(_1808) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1796) >> 16))];
                        _1946 = saturate(_1943);
                        _1950 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1959 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1950 * 32.665000915527344f) + _125), ((_1950 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1960 = sin(_1959);
                        _1961 = cos(_1959);
                        _1962 = cbSharedPerViewData.nFrameCounter & 3;
                        _1967 = sqrt((float((int)(_1962)) * 0.25f) + 0.125f) * _1853;
                        _1976 = (_global_7[min((uint)(((int)(0u + (_1962 * 2)))), 127u)]) * _1967;
                        _1977 = (_global_7[min((uint)(((int)(1u + (_1962 * 2)))), 127u)]) * _1967;
                        _1979 = -0.0f - _1960;
                        _1984 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1976, _1977), float2(_1961, _1960)) + _1940), (dot(float2(_1976, _1977), float2(_1979, _1961)) + _1942)));
                        _1989 = _1984.x - _1946;
                        _1991 = select((_1989 < 0.0f), 0.0f, 1.0f);
                        _1993 = _1984.y - _1946;
                        _1995 = select((_1993 < 0.0f), 0.0f, 1.0f);
                        _1999 = _1984.z - _1946;
                        _2001 = select((_1999 < 0.0f), 0.0f, 1.0f);
                        _2005 = _1984.w - _1946;
                        _2007 = select((_2005 < 0.0f), 0.0f, 1.0f);
                        _2014 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _2019 = sqrt((float((int)(_2014)) * 0.25f) + 0.125f) * _1853;
                        _2028 = (_global_7[min((uint)(((int)(0u + (_2014 * 2)))), 127u)]) * _2019;
                        _2029 = (_global_7[min((uint)(((int)(1u + (_2014 * 2)))), 127u)]) * _2019;
                        _2035 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2028, _2029), float2(_1961, _1960)) + _1940), (dot(float2(_2028, _2029), float2(_1979, _1961)) + _1942)));
                        _2040 = _2035.x - _1946;
                        _2042 = select((_2040 < 0.0f), 0.0f, 1.0f);
                        _2046 = _2035.y - _1946;
                        _2048 = select((_2046 < 0.0f), 0.0f, 1.0f);
                        _2052 = _2035.z - _1946;
                        _2054 = select((_2052 < 0.0f), 0.0f, 1.0f);
                        _2058 = _2035.w - _1946;
                        _2060 = select((_2058 < 0.0f), 0.0f, 1.0f);
                        _2067 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _2072 = sqrt((float((int)(_2067)) * 0.25f) + 0.125f) * _1853;
                        _2081 = (_global_7[min((uint)(((int)(0u + (_2067 * 2)))), 127u)]) * _2072;
                        _2082 = (_global_7[min((uint)(((int)(1u + (_2067 * 2)))), 127u)]) * _2072;
                        _2088 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2081, _2082), float2(_1961, _1960)) + _1940), (dot(float2(_2081, _2082), float2(_1979, _1961)) + _1942)));
                        _2093 = _2088.x - _1946;
                        _2095 = select((_2093 < 0.0f), 0.0f, 1.0f);
                        _2099 = _2088.y - _1946;
                        _2101 = select((_2099 < 0.0f), 0.0f, 1.0f);
                        _2105 = _2088.z - _1946;
                        _2107 = select((_2105 < 0.0f), 0.0f, 1.0f);
                        _2111 = _2088.w - _1946;
                        _2113 = select((_2111 < 0.0f), 0.0f, 1.0f);
                        _2120 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _2125 = sqrt((float((int)(_2120)) * 0.25f) + 0.125f) * _1853;
                        _2134 = (_global_7[min((uint)(((int)(0u + (_2120 * 2)))), 127u)]) * _2125;
                        _2135 = (_global_7[min((uint)(((int)(1u + (_2120 * 2)))), 127u)]) * _2125;
                        _2141 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2134, _2135), float2(_1961, _1960)) + _1940), (dot(float2(_2134, _2135), float2(_1979, _1961)) + _1942)));
                        _2146 = _2141.x - _1946;
                        _2148 = select((_2146 < 0.0f), 0.0f, 1.0f);
                        _2152 = _2141.y - _1946;
                        _2154 = select((_2152 < 0.0f), 0.0f, 1.0f);
                        _2158 = _2141.z - _1946;
                        _2160 = select((_2158 < 0.0f), 0.0f, 1.0f);
                        _2164 = _2141.w - _1946;
                        _2166 = select((_2164 < 0.0f), 0.0f, 1.0f);
                        _2167 = ((((((((((((((_1991 + _1995) + _2001) + _2007) + _2042) + _2048) + _2054) + _2060) + _2095) + _2101) + _2107) + _2113) + _2148) + _2154) + _2160) + _2166;
                        _2178 = (saturate(_2167 * 0.0625f) * 2.0f) + -1.0f;
                        _2184 = float((int)(((int)(uint)((int)(_2178 > 0.0f))) - ((int)(uint)((int)(_2178 < 0.0f)))));
                        _2186 = 1.0f - (_2184 * _2178);
                        _2188 = (_2186 * _2186) * _2186;
                        _2195 = 0.5f - ((_2184 * 0.5f) * ((1.0f - _2188) - ((_2186 - _2188) * saturate(((1.0f / _1946) * (1.0f / _2167)) * ((((((((((((((((_1991 * _1989) + (_1995 * _1993)) + (_2001 * _1999)) + (_2007 * _2005)) + (_2042 * _2040)) + (_2048 * _2046)) + (_2054 * _2052)) + (_2060 * _2058)) + (_2095 * _2093)) + (_2101 * _2099)) + (_2107 * _2105)) + (_2113 * _2111)) + (_2148 * _2146)) + (_2154 * _2152)) + (_2160 * _2158)) + (_2166 * _2164))))));
                        [branch]
                        if (_1859 < 1.0f) {
                          _2198 = _2195;
                          _2199 = _1859;
                          _2200 = _1943;
                          __branch_chain_1930 = true;
                        } else {
                          _2668 = _2195;
                          __branch_chain_1930 = false;
                        }
                      }
                      if (__branch_chain_1930) {
                        _2203 = (_1934 * _1802) + _1804;
                        _2204 = (_1935 * _1803) + _1805;
                        if (!((_1586 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _2213 = saturate(_2200);
                          _2217 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2226 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2217 * 32.665000915527344f) + _125), ((_2217 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2227 = sin(_2226);
                          _2228 = cos(_2226);
                          _2233 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2203, _2204), 0.0f))).x) > _2213), 1.0f, 0.0f);
                          _2234 = cbSharedPerViewData.nFrameCounter & 3;
                          _2239 = sqrt((float((int)(_2234)) * 0.25f) + 0.125f) * _1854;
                          _2248 = (_global_7[min((uint)(((int)(0u + (_2234 * 2)))), 127u)]) * _2239;
                          _2249 = (_global_7[min((uint)(((int)(1u + (_2234 * 2)))), 127u)]) * _2239;
                          _2251 = -0.0f - _2227;
                          _2253 = dot(float2(_2248, _2249), float2(_2228, _2227)) + _2203;
                          _2254 = dot(float2(_2248, _2249), float2(_2251, _2228)) + _2204;
                          _2256 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2253, _2254));
                          _2260 = _2253 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2261 = _2254 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2264 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1804);
                          _2265 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1805);
                          _2270 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1802 + _1804)) + 0.5f);
                          _2271 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1803 + _1805)) + 0.5f);
                          _2274 = floor(_2260 + -0.5f);
                          _2275 = floor(_2261 + 0.5f);
                          _2277 = floor(_2260 + 0.5f);
                          _2279 = floor(_2261 + -0.5f);
                          _2280 = (_2274 < _2264);
                          _2281 = (_2275 < _2265);
                          if ((_2280 || _2281) | ((_2274 >= _2270) || (_2275 >= _2271))) {
                            _2290 = _2233;
                          } else {
                            _2290 = _2256.x;
                          }
                          _2291 = (_2277 < _2264);
                          if ((_2291 || _2281) | ((_2277 >= _2270) || (_2275 >= _2271))) {
                            _2299 = _2233;
                          } else {
                            _2299 = _2256.y;
                          }
                          _2300 = (_2279 < _2265);
                          if ((_2291 || _2300) | ((_2277 >= _2270) || (_2279 >= _2271))) {
                            _2308 = _2233;
                          } else {
                            _2308 = _2256.z;
                          }
                          if ((_2280 || _2300) | ((_2274 >= _2270) || (_2279 >= _2271))) {
                            _2316 = _2233;
                          } else {
                            _2316 = _2256.w;
                          }
                          _2317 = _2290 - _2213;
                          _2319 = select((_2317 < 0.0f), 0.0f, 1.0f);
                          _2321 = _2299 - _2213;
                          _2323 = select((_2321 < 0.0f), 0.0f, 1.0f);
                          _2327 = _2308 - _2213;
                          _2329 = select((_2327 < 0.0f), 0.0f, 1.0f);
                          _2333 = _2316 - _2213;
                          _2335 = select((_2333 < 0.0f), 0.0f, 1.0f);
                          _2342 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2347 = sqrt((float((int)(_2342)) * 0.25f) + 0.125f) * _1854;
                          _2356 = (_global_7[min((uint)(((int)(0u + (_2342 * 2)))), 127u)]) * _2347;
                          _2357 = (_global_7[min((uint)(((int)(1u + (_2342 * 2)))), 127u)]) * _2347;
                          _2360 = dot(float2(_2356, _2357), float2(_2228, _2227)) + _2203;
                          _2361 = dot(float2(_2356, _2357), float2(_2251, _2228)) + _2204;
                          _2363 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2360, _2361));
                          _2367 = _2360 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2368 = _2361 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2371 = floor(_2367 + -0.5f);
                          _2372 = floor(_2368 + 0.5f);
                          _2374 = floor(_2367 + 0.5f);
                          _2376 = floor(_2368 + -0.5f);
                          _2377 = (_2371 < _2264);
                          _2378 = (_2372 < _2265);
                          if ((_2377 || _2378) | ((_2371 >= _2270) || (_2372 >= _2271))) {
                            _2387 = _2233;
                          } else {
                            _2387 = _2363.x;
                          }
                          _2388 = (_2374 < _2264);
                          if ((_2388 || _2378) | ((_2374 >= _2270) || (_2372 >= _2271))) {
                            _2396 = _2233;
                          } else {
                            _2396 = _2363.y;
                          }
                          _2397 = (_2376 < _2265);
                          if ((_2388 || _2397) | ((_2374 >= _2270) || (_2376 >= _2271))) {
                            _2405 = _2233;
                          } else {
                            _2405 = _2363.z;
                          }
                          if ((_2377 || _2397) | ((_2371 >= _2270) || (_2376 >= _2271))) {
                            _2413 = _2233;
                          } else {
                            _2413 = _2363.w;
                          }
                          _2414 = _2387 - _2213;
                          _2416 = select((_2414 < 0.0f), 0.0f, 1.0f);
                          _2420 = _2396 - _2213;
                          _2422 = select((_2420 < 0.0f), 0.0f, 1.0f);
                          _2426 = _2405 - _2213;
                          _2428 = select((_2426 < 0.0f), 0.0f, 1.0f);
                          _2432 = _2413 - _2213;
                          _2434 = select((_2432 < 0.0f), 0.0f, 1.0f);
                          _2441 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2446 = sqrt((float((int)(_2441)) * 0.25f) + 0.125f) * _1854;
                          _2455 = (_global_7[min((uint)(((int)(0u + (_2441 * 2)))), 127u)]) * _2446;
                          _2456 = (_global_7[min((uint)(((int)(1u + (_2441 * 2)))), 127u)]) * _2446;
                          _2459 = dot(float2(_2455, _2456), float2(_2228, _2227)) + _2203;
                          _2460 = dot(float2(_2455, _2456), float2(_2251, _2228)) + _2204;
                          _2462 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2459, _2460));
                          _2466 = _2459 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2467 = _2460 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2470 = floor(_2466 + -0.5f);
                          _2471 = floor(_2467 + 0.5f);
                          _2473 = floor(_2466 + 0.5f);
                          _2475 = floor(_2467 + -0.5f);
                          _2476 = (_2470 < _2264);
                          _2477 = (_2471 < _2265);
                          if ((_2476 || _2477) | ((_2470 >= _2270) || (_2471 >= _2271))) {
                            _2486 = _2233;
                          } else {
                            _2486 = _2462.x;
                          }
                          _2487 = (_2473 < _2264);
                          if ((_2487 || _2477) | ((_2473 >= _2270) || (_2471 >= _2271))) {
                            _2495 = _2233;
                          } else {
                            _2495 = _2462.y;
                          }
                          _2496 = (_2475 < _2265);
                          if ((_2487 || _2496) | ((_2473 >= _2270) || (_2475 >= _2271))) {
                            _2504 = _2233;
                          } else {
                            _2504 = _2462.z;
                          }
                          if ((_2476 || _2496) | ((_2470 >= _2270) || (_2475 >= _2271))) {
                            _2512 = _2233;
                          } else {
                            _2512 = _2462.w;
                          }
                          _2513 = _2486 - _2213;
                          _2515 = select((_2513 < 0.0f), 0.0f, 1.0f);
                          _2519 = _2495 - _2213;
                          _2521 = select((_2519 < 0.0f), 0.0f, 1.0f);
                          _2525 = _2504 - _2213;
                          _2527 = select((_2525 < 0.0f), 0.0f, 1.0f);
                          _2531 = _2512 - _2213;
                          _2533 = select((_2531 < 0.0f), 0.0f, 1.0f);
                          _2540 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2545 = sqrt((float((int)(_2540)) * 0.25f) + 0.125f) * _1854;
                          _2554 = (_global_7[min((uint)(((int)(0u + (_2540 * 2)))), 127u)]) * _2545;
                          _2555 = (_global_7[min((uint)(((int)(1u + (_2540 * 2)))), 127u)]) * _2545;
                          _2558 = dot(float2(_2554, _2555), float2(_2228, _2227)) + _2203;
                          _2559 = dot(float2(_2554, _2555), float2(_2251, _2228)) + _2204;
                          _2561 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2558, _2559));
                          _2565 = _2558 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2566 = _2559 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2569 = floor(_2565 + -0.5f);
                          _2570 = floor(_2566 + 0.5f);
                          _2572 = floor(_2565 + 0.5f);
                          _2574 = floor(_2566 + -0.5f);
                          _2575 = (_2569 < _2264);
                          _2576 = (_2570 < _2265);
                          if ((_2575 || _2576) | ((_2569 >= _2270) || (_2570 >= _2271))) {
                            _2585 = _2233;
                          } else {
                            _2585 = _2561.x;
                          }
                          _2586 = (_2572 < _2264);
                          if ((_2586 || _2576) | ((_2572 >= _2270) || (_2570 >= _2271))) {
                            _2594 = _2233;
                          } else {
                            _2594 = _2561.y;
                          }
                          _2595 = (_2574 < _2265);
                          if ((_2586 || _2595) | ((_2572 >= _2270) || (_2574 >= _2271))) {
                            _2603 = _2233;
                          } else {
                            _2603 = _2561.z;
                          }
                          if ((_2575 || _2595) | ((_2569 >= _2270) || (_2574 >= _2271))) {
                            _2611 = _2233;
                          } else {
                            _2611 = _2561.w;
                          }
                          _2612 = _2585 - _2213;
                          _2614 = select((_2612 < 0.0f), 0.0f, 1.0f);
                          _2618 = _2594 - _2213;
                          _2620 = select((_2618 < 0.0f), 0.0f, 1.0f);
                          _2624 = _2603 - _2213;
                          _2626 = select((_2624 < 0.0f), 0.0f, 1.0f);
                          _2630 = _2611 - _2213;
                          _2632 = select((_2630 < 0.0f), 0.0f, 1.0f);
                          _2633 = ((((((((((((((_2323 + _2319) + _2329) + _2335) + _2416) + _2422) + _2428) + _2434) + _2515) + _2521) + _2527) + _2533) + _2614) + _2620) + _2626) + _2632;
                          _2644 = (saturate(_2633 * 0.0625f) * 2.0f) + -1.0f;
                          _2650 = float((int)(((int)(uint)((int)(_2644 > 0.0f))) - ((int)(uint)((int)(_2644 < 0.0f)))));
                          _2652 = 1.0f - (_2650 * _2644);
                          _2654 = (_2652 * _2652) * _2652;
                          _2663 = (0.5f - ((_2650 * 0.5f) * ((1.0f - _2654) - ((_2652 - _2654) * saturate(((1.0f / _2213) * (1.0f / _2633)) * ((((((((((((((((_2323 * _2321) + (_2319 * _2317)) + (_2329 * _2327)) + (_2335 * _2333)) + (_2416 * _2414)) + (_2422 * _2420)) + (_2428 * _2426)) + (_2434 * _2432)) + (_2515 * _2513)) + (_2521 * _2519)) + (_2527 * _2525)) + (_2533 * _2531)) + (_2614 * _2612)) + (_2620 * _2618)) + (_2626 * _2624)) + (_2632 * _2630)))))));
                        } else {
                          _2663 = 1.0f;
                        }
                        _2668 = (lerp(_2663, _2198, _2199));
                      }
                      [branch]
                      if (!((_1586 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1799) >> 16))];
                        _2674 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1888, _1892), 0.0f);
                        if (_2674.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1799 & 65535))];
                          _2681 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1888, _1892), 0.0f);
                          _2695 = mad(saturate(((log2(_1897 * _1784) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2696 = max(9.999999747378752e-06f, _2674.x);
                          _2697 = _2681.x / _2696;
                          _2698 = _2681.y / _2696;
                          _2700 = _2681.w / _2696;
                          _2705 = ((0.375f - _2698) * 4.999999873689376e-06f) + _2698;
                          _2708 = -0.0f - _2697;
                          _2709 = mad(_2708, _2705, (_2681.z / _2696));
                          _2711 = 1.0f / mad(_2708, _2697, _2705);
                          _2712 = _2711 * _2709;
                          _2717 = _2695 - _2697;
                          _2722 = (((_2695 * _2695) - _2705) - (_2712 * _2717)) / mad((-0.0f - _2709), _2712, mad((-0.0f - _2705), _2705, (((0.375f - _2700) * 4.999999873689376e-06f) + _2700)));
                          _2724 = (_2711 * _2717) - (_2722 * _2712);
                          _2727 = 1.0f / _2722;
                          _2728 = _2724 * _2727;
                          _2733 = sqrt(((_2728 * _2728) * 0.25f) - ((1.0f - dot(float2(_2724, _2722), float2(_2697, _2705))) * _2727));
                          _2735 = (_2728 * -0.5f) - _2733;
                          _2737 = _2733 - (_2728 * 0.5f);
                          _2739 = select((_2735 < _2695), 1.0f, 0.0f);
                          _2744 = (_2739 + -0.05000000074505806f) / (_2735 - _2695);
                          _2750 = (((select((_2737 < _2695), 1.0f, 0.0f) - _2739) / (_2737 - _2735)) - _2744) / (_2737 - _2695);
                          _2752 = _2744 - (_2750 * _2735);
                          _2765 = (exp2((_2674.x * -1.4426950216293335f) * saturate((dot(float2(_2697, _2705), float2((_2752 - (_2750 * _2695)), _2750)) + 0.05000000074505806f) - (_2752 * _2695))) * _2668);
                        } else {
                          _2765 = _2668;
                        }
                      } else {
                        _2765 = _2668;
                      }
                    } else {
                      _2765 = 1.0f;
                    }
                    [branch]
                    if (!(_1843 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1843)))];
                      _2778 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1888 * f16tof32(((uint)((uint)(_1817) >> 16)))) + f16tof32(((uint)((uint)(_1820) >> 16)))), ((_1892 * f16tof32(_1817)) + f16tof32(_1820))), 0.0f);
                      _2786 = (_2778.x * _1831);
                      _2787 = (_2778.y * _1832);
                      _2788 = (_2778.z * _1834);
                    } else {
                      _2786 = _1831;
                      _2787 = _1832;
                      _2788 = _1834;
                    }
                    _2789 = _2765 * _1926;
                    [branch]
                    if (!(_2789 == 0.0f)) {
                      bool __branch_chain_2791;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2807 = 0;
                        __branch_chain_2791 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2807 = 1;
                          __branch_chain_2791 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2807 = 2;
                            __branch_chain_2791 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2807 = 3;
                              __branch_chain_2791 = true;
                            } else {
                              _2828 = _2789;
                              __branch_chain_2791 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2791) {
                        while(true) {
                          _2810 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                          if (_2807 == 0) {
                            _2824 = _2810.x;
                          } else {
                            if (_2807 == 1) {
                              _2824 = _2810.y;
                            } else {
                              if (_2807 == 2) {
                                _2824 = _2810.z;
                              } else {
                                _2824 = _2810.w;
                              }
                            }
                          }
                          _2828 = ((_2824 * _2824) * _1926);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2828 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2838 = srvLightMappingData[_1589];
                            if (!(_2838 == -1)) {
                              _2843 = srvLightIndexData[_2838].nLayerIndex;
                              _2845 = srvLightIndexData[_2838].vAtlasOrigin.x;
                              _2846 = srvLightIndexData[_2838].vAtlasOrigin.y;
                              _2848 = srvLightIndexData[_2838].vScreenOrigin.x;
                              _2849 = srvLightIndexData[_2838].vScreenOrigin.y;
                              _2858 = ((int)(_2843 * 5)) & 31;
                              _2867 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2845 + _63) - _2848)), ((int)((_2846 + _64) - _2849)), 0)))).x) & ((int)(31 << _2858)))) >> _2858)) >> 1)))) * 0.06666667014360428f) * _2828);
                            } else {
                              _2867 = _2828;
                            }
                          } else {
                            _2867 = _2828;
                          }
                          _2871 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2874 = select(_2871, (_2867 * _1266), _2867);
                          _2876 = dot(float3(_1779, _1780, _1781), float3(_1779, _1780, _1781));
                          _2877 = rsqrt(_2876);
                          _2878 = _2877 * _1779;
                          _2879 = _2877 * _1780;
                          _2880 = _2877 * _1781;
                          _2881 = dot(float3(_192, _193, _194), float3(_2878, _2879, _2880));
                          if (_1840 > 0.0f) {
                            _2889 = sqrt(saturate((_1840 * _1840) * (1.0f / (_2876 + 1.0f))));
                            if (_2881 < _2889) {
                              _2894 = max(_2881, (-0.0f - _2889)) + _2889;
                              _2899 = ((_2894 * _2894) / (_2889 * 4.0f));
                            } else {
                              _2899 = _2881;
                            }
                          } else {
                            _2899 = _2881;
                          }
                          _2900 = _214 * _214;
                          _2904 = saturate((_1840 * (1.0f - _2900)) * _2877);
                          _2906 = saturate(_2877 * f16tof32(_1793));
                          _2907 = dot(float3(_437, _438, _436), float3(_2878, _2879, _2880));
                          _2910 = rsqrt((_2907 * 2.0f) + 2.0f);
                          _2913 = saturate(_2910 * (_1123 + _2881));
                          _2917 = (_2904 > 0.0f);
                          if (_2917) {
                            _2921 = sqrt(1.0f - (_2904 * _2904));
                            _2923 = (_2881 * 2.0f) * _1123;
                            _2924 = _2923 - _2907;
                            if (!(_2924 >= _2921)) {
                              _2932 = rsqrt(1.0f - (_2924 * _2924)) * _2904;
                              _2935 = _2932 * (_1123 - (_2924 * _2881));
                              _2936 = _1123 * _1123;
                              _2941 = _2932 * (((_2936 * 2.0f) + -1.0f) - (_2924 * _2907));
                              _2950 = sqrt(saturate((((1.0f - (_2881 * _2881)) - _2936) - (_2907 * _2907)) + (_2923 * _2907)));
                              _2951 = _2950 * _2932;
                              _2954 = ((_1123 * 2.0f) * _2932) * _2950;
                              _2956 = (_2921 * _2881) + _1123;
                              _2957 = _2956 + _2935;
                              _2958 = _2921 * _2907;
                              _2960 = (_2958 + 1.0f) + _2941;
                              _2961 = _2951 * _2960;
                              _2962 = _2957 * _2960;
                              _2963 = _2954 * _2957;
                              _2968 = (((_2957 * 0.25f) * _2954) - (_2961 * 0.5f)) * _2962;
                              _2982 = (((_2963 - (_2961 * 2.0f)) * _2963) + (_2961 * _2961)) + ((((-0.5f - ((_2960 + _2958) * 0.5f)) * _2962) + ((_2960 * _2960) * _2956)) * _2957);
                              _2987 = (_2968 * 2.0f) / ((_2982 * _2982) + (_2968 * _2968));
                              _2988 = _2982 * _2987;
                              _2990 = 1.0f - (_2968 * _2987);
                              _2996 = ((_2988 * _2954) + _2958) + (_2990 * _2941);
                              _2999 = rsqrt((_2996 * 2.0f) + 2.0f);
                              _3008 = saturate((_2996 * _2999) + _2999);
                              _3009 = saturate(((_2956 + (_2988 * _2951)) + (_2990 * _2935)) * _2999);
                            } else {
                              _3008 = abs(_1123);
                              _3009 = 1.0f;
                            }
                          } else {
                            _3008 = saturate((_2910 * _2907) + _2910);
                            _3009 = _2913;
                          }
                          _3010 = saturate(_2899);
                          _3011 = saturate(_2881);
                          _3012 = _2900 * _2900;
                          if (_2906 > 0.0f) {
                            _3022 = saturate(((_2906 * _2906) / ((_3008 * 3.5999999046325684f) + 0.4000000059604645f)) + _3012);
                          } else {
                            _3022 = _3012;
                          }
                          _3023 = sqrt(_3022);
                          if (_2917) {
                            _3034 = (_3022 / ((((_2904 * 0.25f) * ((_3023 * 3.0f) + _2904)) / (_3008 + 0.0010000000474974513f)) + _3022));
                          } else {
                            _3034 = 1.0f;
                          }
                          _3038 = (((_3022 * _3009) - _3009) * _3009) + 1.0f;
                          _3041 = (_3022 / (_3038 * _3038)) * _3034;
                          _3049 = exp2(log2(1.0f - saturate(_3008)) * 5.0f);
                          _3053 = (_3049 * (1.0f - _207)) + _207;
                          _3054 = (_3049 * (1.0f - _208)) + _208;
                          _3055 = (_3049 * (1.0f - _209)) + _209;
                          _3058 = saturate(abs(_1123) + 9.999999747378752e-06f);
                          _3059 = 1.0f - _3023;
                          _3067 = 0.5f / ((((_3059 * _3058) + _3023) * _3010) + (((_3059 * _3010) + _3023) * _3058));
                          if (_212 < 0.007874015718698502f) {
                            _3073 = _3009 * _3009;
                            _3075 = max((1.0f - _3073), 9.999999747378752e-05f);
                            _3213 = (((((((exp2(((-0.0f - (_3073 / _3075)) / _3022) * 1.4426950216293335f) * 4.0f) / (_3075 * _3075)) + 1.0f) * (1.0f / ((_3022 * 4.0f) + 1.0f))) - _3041) * _168) + _3041);
                            _3214 = (((saturate(0.25f / ((_3011 + _1124) - (_3011 * _1124))) - _3067) * _168) + _3067);
                          } else {
                            _3099 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
                            _3100 = _3099 * _192;
                            _3101 = _3099 * _193;
                            _3102 = _3099 * _194;
                            _3105 = (abs(_3100) < abs(_3101));
                            _3106 = select(_3105, 1.0f, 0.0f);
                            _3107 = select(_3105, 0.0f, 1.0f);
                            _3108 = _3107 * _3102;
                            _3110 = -0.0f - (_3102 * _3106);
                            _3113 = (_3106 * _3101) - (_3107 * _3100);
                            _3115 = rsqrt(dot(float3(_3108, _3110, _3113), float3(_3108, _3110, _3113)));
                            _3116 = _3108 * _3115;
                            _3117 = _3115 * _3110;
                            _3118 = _3113 * _3115;
                            _3121 = (_3117 * _3102) - (_3118 * _3101);
                            _3124 = (_3118 * _3100) - (_3116 * _3102);
                            _3127 = (_3116 * _3101) - (_3117 * _3100);
                            _3129 = rsqrt(dot(float3(_3121, _3124, _3127), float3(_3121, _3124, _3127)));
                            _3133 = _168 * 4.0f;
                            _3142 = saturate(abs(_3133 + -2.5f) + -0.5f) + -0.5f;
                            _3143 = saturate(1.5f - abs(_3133 + -1.5f)) + -0.5f;
                            _3145 = rsqrt(dot(float2(_3142, _3143), float2(_3142, _3143)));
                            _3146 = _3145 * _3142;
                            _3147 = _3145 * _3143;
                            _3154 = ((_3121 * _3129) * _3146) + (_3147 * _3116);
                            _3155 = ((_3124 * _3129) * _3146) + (_3147 * _3117);
                            _3156 = ((_3127 * _3129) * _3146) + (_3147 * _3118);
                            _3159 = (_3155 * _194) - (_3156 * _193);
                            _3162 = (_3156 * _192) - (_3154 * _194);
                            _3165 = (_3154 * _193) - (_3155 * _192);
                            _3166 = dot(float3(_3154, _3155, _3156), float3(_2878, _2879, _2880));
                            _3167 = dot(float3(_3154, _3155, _3156), float3(_437, _438, _436));
                            _3170 = dot(float3(_3159, _3162, _3165), float3(_2878, _2879, _2880));
                            _3171 = dot(float3(_3159, _3162, _3165), float3(_437, _438, _436));
                            _3177 = min(max((_2900 * (_212 + 1.0f)), 0.0010000000474974513f), 1.0f);
                            _3181 = min(max((_2900 * (1.0f - _212)), 0.0010000000474974513f), 1.0f);
                            _3182 = _3181 * _3177;
                            _3183 = ((_3167 + _3166) * _2910) * _3181;
                            _3184 = ((_3171 + _3170) * _2910) * _3177;
                            _3185 = _3182 * _2913;
                            _3186 = dot(float3(_3183, _3184, _3185), float3(_3183, _3184, _3185));
                            _3191 = _3177 * _3167;
                            _3192 = _3181 * _3171;
                            _3200 = _3177 * _3166;
                            _3201 = _3181 * _3170;
                            _3213 = (((_3182 * _3182) * _3182) / (_3186 * _3186));
                            _3214 = saturate(0.5f / ((sqrt(((_3200 * _3200) + (_3011 * _3011)) + (_3201 * _3201)) * _3058) + (sqrt(((_3192 * _3192) + (_3191 * _3191)) + (_3058 * _3058)) * _3011)));
                          }
                          _3216 = (_3213 * _3011) * _3214;
                          _3231 = saturate((_2881 + 0.5f) * 0.6666666865348816f);
                          _3238 = _2786 * _1637;
                          _3239 = _2787 * _1637;
                          _3240 = _2788 * _1637;
                          _3253 = ((((_2874 * _3238) * (1.0f - _3053)) * _3231) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _3011)) + _1574;
                          _3254 = ((((_2874 * _3239) * (1.0f - _3054)) * _3231) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _3011)) + _1575;
                          _3255 = ((((_2874 * _3240) * (1.0f - _3055)) * _3231) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _3011)) + _1576;
                          if (_1838 > 0.0f) {
                            _3258 = (_1838 * _1339) * select(_2871, (_2867 * _1266), _2867);
                            _9254 = _3253;
                            _9255 = _3254;
                            _9256 = _3255;
                            _9257 = ((((_3258 * _3238) * _3053) * _3216) + _1577);
                            _9258 = ((((_3258 * _3239) * _3054) * _3216) + _1578);
                            _9259 = ((((_3258 * _3240) * _3055) * _3216) + _1579);
                          } else {
                            _9254 = _3253;
                            _9255 = _3254;
                            _9256 = _3255;
                            _9257 = _1577;
                            _9258 = _1578;
                            _9259 = _1579;
                          }
                        } else {
                          _9254 = _1574;
                          _9255 = _1575;
                          _9256 = _1576;
                          _9257 = _1577;
                          _9258 = _1578;
                          _9259 = _1579;
                        }
                        break;
                      }
                    } else {
                      _9254 = _1574;
                      _9255 = _1575;
                      _9256 = _1576;
                      _9257 = _1577;
                      _9258 = _1578;
                      _9259 = _1579;
                    }
                  } else {
                    if (_1620 == 7) {
                      _3882 = asfloat(srvLightInfoProperties.Load3(_1588)).x;
                      _3883 = asfloat(srvLightInfoProperties.Load3(_1588)).y;
                      _3884 = asfloat(srvLightInfoProperties.Load3(_1588)).z;
                      _3887 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 12u)))).x;
                      _3888 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 12u)))).y;
                      _3889 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 12u)))).z;
                      _3892 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 24u)))).x;
                      _3893 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 24u)))).y;
                      _3894 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 24u)))).z;
                      _3897 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 36u)))).x;
                      _3898 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 36u)))).y;
                      _3899 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 36u)))).z;
                      _3902 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).x;
                      _3903 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).y;
                      _3904 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 48u)))).z;
                      _3907 = asint(srvLightInfoProperties.Load(((int)(_1588 + 60u))));
                      _3910 = asint(srvLightInfoProperties.Load(((int)(_1588 + 64u))));
                      _3913 = asint(srvLightInfoProperties.Load(((int)(_1588 + 72u))));
                      _3916 = asint(srvLightInfoProperties.Load(((int)(_1588 + 76u))));
                      _3919 = asint(srvLightInfoProperties.Load(((int)(_1588 + 80u))));
                      _3922 = asint(srvLightInfoProperties.Load(((int)(_1588 + 84u))));
                      _3925 = asint(srvLightInfoProperties.Load(((int)(_1588 + 88u))));
                      _3928 = asint(srvLightInfoProperties.Load(((int)(_1588 + 92u))));
                      _3931 = asint(srvLightInfoProperties.Load(((int)(_1588 + 96u))));
                      _3934 = asint(srvLightInfoProperties.Load(((int)(_1588 + 100u))));
                      _3937 = asint(srvLightInfoProperties.Load(((int)(_1588 + 104u))));
                      _3940 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).x;
                      _3941 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).y;
                      _3942 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).z;
                      _3943 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).w;
                      _3946 = asint(srvLightInfoProperties.Load(((int)(_1588 + 124u))));
                      _3949 = asint(srvLightInfoProperties.Load(((int)(_1588 + 128u))));
                      _3952 = asint(srvLightInfoProperties.Load(((int)(_1588 + 136u))));
                      _3955 = asint(srvLightInfoProperties.Load(((int)(_1588 + 140u))));
                      _3957 = f16tof32(((uint)((uint)(_3907) >> 16)));
                      _3958 = f16tof32(_3907);
                      _3960 = f16tof32(((uint)((uint)(_3910) >> 16)));
                      _3964 = ((float)((uint)((uint)(((uint)(_3910) >> 8) & 255)))) * 0.003921499941498041f;
                      _3965 = f16tof32(_3913);
                      _3967 = f16tof32(((uint)((uint)(_3916) >> 16)));
                      _3971 = f16tof32(_3919);
                      _3973 = f16tof32(((uint)((uint)(_3922) >> 16)));
                      _3974 = f16tof32(_3922);
                      _3976 = f16tof32(((uint)((uint)(_3925) >> 16)));
                      _3979 = _3928 & 65535;
                      _3983 = ((_1586 & 4194304) != 0);
                      _3991 = f16tof32(((uint)((uint)(_3937) >> 16)));
                      _3992 = f16tof32(_3937);
                      _3994 = f16tof32(((uint)((uint)(_3946) >> 16)));
                      _3997 = f16tof32(((uint)((uint)(_3949) >> 16)));
                      _3998 = f16tof32(_3949);
                      _4000 = f16tof32(((uint)((uint)(_3952) >> 16)));
                      _4001 = _4000 + -1.0f;
                      if (_3983) {
                        _4003 = 0.5f / _4000;
                        _4004 = 0.3333333432674408f / _4000;
                        _4008 = (_4000 * 0.5f) + 0.5f;
                        _4018 = (_4003 * _4001);
                        _4019 = (_4004 * _4001);
                        _4020 = (_4003 * _4008);
                        _4021 = (_4004 * _4008);
                        _4022 = (_4000 * 2.0f);
                        _4023 = (_4000 * 3.0f);
                      } else {
                        _4014 = 1.0f / _4000;
                        _4015 = _4014 * _4001;
                        _4016 = _4014 * 0.5f;
                        _4018 = _4015;
                        _4019 = _4015;
                        _4020 = _4016;
                        _4021 = _4016;
                        _4022 = _4000;
                        _4023 = _4000;
                      }
                      _4027 = _3897 - _222;
                      _4028 = _3898 - _223;
                      _4029 = _3899 + _221;
                      _4030 = dot(float3(_4027, _4028, _4029), float3(_4027, _4028, _4029));
                      _4031 = rsqrt(_4030);
                      _4032 = _4031 * _4030;
                      _4033 = _4031 * _4027;
                      _4034 = _4031 * _4028;
                      _4035 = _4031 * _4029;
                      _4038 = max(0.0f, (_4032 - abs(_3971)));
                      _4039 = _4038 * f16tof32(((uint)((uint)(_3919) >> 16)));
                      _4040 = _4039 * _4039;
                      _4043 = saturate(1.0f - (_4040 * _4040));
                      _4050 = (_4043 * _4043) / (select((_3971 < 0.0f), (_4040 * 16.0f), (_4038 * _4038)) + 1.0f);
                      _4063 = saturate(1.0f - dot(float3(_192, _193, _194), float3(_4033, _4034, _4035))) * f16tof32(_3946);
                      _4067 = abs(_4029);
                      _4071 = _4027 - ((_4063 * _192) * _4067);
                      _4072 = _4028 - ((_4063 * _193) * _4067);
                      _4073 = _4029 - ((_4063 * _194) * _4067);
                      _4076 = mad(_4073, _3893, mad(_4072, _3888, (_4071 * _3883)));
                      _4079 = mad(_4073, _3894, mad(_4072, _3889, (_4071 * _3884)));
                      _4081 = ((_1586 & 3584) != 0);
                      if (_4081 && (_4050 > 0.0f)) {
                        _4087 = mad(_4073, _3892, mad(_4072, _3887, (_4071 * _3882)));
                        _4088 = -0.0f - _4079;
                        _4089 = -0.0f - _4076;
                        [branch]
                        if (!((_1586 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3928) >> 16))];
                          [branch]
                          if (_3983) {
                            _4094 = abs(_4087);
                            _4095 = abs(_4088);
                            _4096 = abs(_4089);
                            if (_4094 > max(_4095, _4096)) {
                              _4100 = (_4087 > 0.0f);
                              _4115 = select(_4100, 0.0f, 1.0f);
                              _4116 = 0.0f;
                              _4117 = select(_4100, _4076, _4089);
                              _4118 = _4079;
                              _4119 = _4094;
                            } else {
                              if (_4095 > _4096) {
                                _4106 = (_4079 < -0.0f);
                                _4115 = select(_4106, 0.0f, 1.0f);
                                _4116 = 1.0f;
                                _4117 = _4087;
                                _4118 = select(_4106, _4089, _4076);
                                _4119 = _4095;
                              } else {
                                _4110 = (_4076 < -0.0f);
                                _4115 = select(_4110, 0.0f, 1.0f);
                                _4116 = 2.0f;
                                _4117 = select(_4110, _4087, (-0.0f - _4087));
                                _4118 = _4079;
                                _4119 = _4096;
                              }
                            }
                            _4120 = _4119 * 2.0f;
                            _4124 = -0.0f - _3992;
                            _4133 = ((min(max((_4117 / _4120), _4124), _3992) + _4115) * _4018) + _4020;
                            _4134 = ((min(max((_4118 / _4120), _4124), _3992) + _4116) * _4019) + _4021;
                            _4141 = ((_4115 + -0.5f) * _4018) + _4020;
                            _4142 = ((_4116 + -0.5f) * _4019) + _4021;
                            _4145 = saturate((_3994 + 1.0f) - (_4119 * _3976));
                            _4149 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4158 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_4149 * 32.665000915527344f) + _125), ((_4149 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4159 = sin(_4158);
                            _4160 = cos(_4158);
                            _4165 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_4133, _4134), 0.0f))).x) > _4145), 1.0f, 0.0f);
                            _4166 = cbSharedPerViewData.nFrameCounter & 3;
                            _4171 = sqrt((float((int)(_4166)) * 0.25f) + 0.125f) * _3997;
                            _4180 = (_global_7[min((uint)(((int)(0u + (_4166 * 2)))), 127u)]) * _4171;
                            _4181 = (_global_7[min((uint)(((int)(1u + (_4166 * 2)))), 127u)]) * _4171;
                            _4183 = -0.0f - _4159;
                            _4185 = dot(float2(_4180, _4181), float2(_4160, _4159)) + _4133;
                            _4186 = dot(float2(_4180, _4181), float2(_4183, _4160)) + _4134;
                            _4188 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4185, _4186));
                            _4192 = _4185 * _4022;
                            _4193 = _4186 * _4023;
                            _4196 = floor(_4141 * _4022);
                            _4197 = floor(_4142 * _4023);
                            _4202 = floor(((_4141 + _4018) * _4022) + 0.5f);
                            _4203 = floor(((_4142 + _4019) * _4023) + 0.5f);
                            _4206 = floor(_4192 + -0.5f);
                            _4207 = floor(_4193 + 0.5f);
                            _4209 = floor(_4192 + 0.5f);
                            _4211 = floor(_4193 + -0.5f);
                            _4212 = (_4206 < _4196);
                            _4213 = (_4207 < _4197);
                            if ((_4212 || _4213) | ((_4206 >= _4202) || (_4207 >= _4203))) {
                              _4222 = _4165;
                            } else {
                              _4222 = _4188.x;
                            }
                            _4223 = (_4209 < _4196);
                            if ((_4223 || _4213) | ((_4209 >= _4202) || (_4207 >= _4203))) {
                              _4231 = _4165;
                            } else {
                              _4231 = _4188.y;
                            }
                            _4232 = (_4211 < _4197);
                            if ((_4223 || _4232) | ((_4209 >= _4202) || (_4211 >= _4203))) {
                              _4240 = _4165;
                            } else {
                              _4240 = _4188.z;
                            }
                            if ((_4212 || _4232) | ((_4206 >= _4202) || (_4211 >= _4203))) {
                              _4248 = _4165;
                            } else {
                              _4248 = _4188.w;
                            }
                            _4249 = _4222 - _4145;
                            _4251 = select((_4249 < 0.0f), 0.0f, 1.0f);
                            _4253 = _4231 - _4145;
                            _4255 = select((_4253 < 0.0f), 0.0f, 1.0f);
                            _4259 = _4240 - _4145;
                            _4261 = select((_4259 < 0.0f), 0.0f, 1.0f);
                            _4265 = _4248 - _4145;
                            _4267 = select((_4265 < 0.0f), 0.0f, 1.0f);
                            _4274 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _4279 = sqrt((float((int)(_4274)) * 0.25f) + 0.125f) * _3997;
                            _4288 = (_global_7[min((uint)(((int)(0u + (_4274 * 2)))), 127u)]) * _4279;
                            _4289 = (_global_7[min((uint)(((int)(1u + (_4274 * 2)))), 127u)]) * _4279;
                            _4292 = dot(float2(_4288, _4289), float2(_4160, _4159)) + _4133;
                            _4293 = dot(float2(_4288, _4289), float2(_4183, _4160)) + _4134;
                            _4295 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4292, _4293));
                            _4299 = _4292 * _4022;
                            _4300 = _4293 * _4023;
                            _4303 = floor(_4299 + -0.5f);
                            _4304 = floor(_4300 + 0.5f);
                            _4306 = floor(_4299 + 0.5f);
                            _4308 = floor(_4300 + -0.5f);
                            _4309 = (_4303 < _4196);
                            _4310 = (_4304 < _4197);
                            if ((_4309 || _4310) | ((_4303 >= _4202) || (_4304 >= _4203))) {
                              _4319 = _4165;
                            } else {
                              _4319 = _4295.x;
                            }
                            _4320 = (_4306 < _4196);
                            if ((_4320 || _4310) | ((_4306 >= _4202) || (_4304 >= _4203))) {
                              _4328 = _4165;
                            } else {
                              _4328 = _4295.y;
                            }
                            _4329 = (_4308 < _4197);
                            if ((_4320 || _4329) | ((_4306 >= _4202) || (_4308 >= _4203))) {
                              _4337 = _4165;
                            } else {
                              _4337 = _4295.z;
                            }
                            if ((_4309 || _4329) | ((_4303 >= _4202) || (_4308 >= _4203))) {
                              _4345 = _4165;
                            } else {
                              _4345 = _4295.w;
                            }
                            _4346 = _4319 - _4145;
                            _4348 = select((_4346 < 0.0f), 0.0f, 1.0f);
                            _4352 = _4328 - _4145;
                            _4354 = select((_4352 < 0.0f), 0.0f, 1.0f);
                            _4358 = _4337 - _4145;
                            _4360 = select((_4358 < 0.0f), 0.0f, 1.0f);
                            _4364 = _4345 - _4145;
                            _4366 = select((_4364 < 0.0f), 0.0f, 1.0f);
                            _4373 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4378 = sqrt((float((int)(_4373)) * 0.25f) + 0.125f) * _3997;
                            _4387 = (_global_7[min((uint)(((int)(0u + (_4373 * 2)))), 127u)]) * _4378;
                            _4388 = (_global_7[min((uint)(((int)(1u + (_4373 * 2)))), 127u)]) * _4378;
                            _4391 = dot(float2(_4387, _4388), float2(_4160, _4159)) + _4133;
                            _4392 = dot(float2(_4387, _4388), float2(_4183, _4160)) + _4134;
                            _4394 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4391, _4392));
                            _4398 = _4391 * _4022;
                            _4399 = _4392 * _4023;
                            _4402 = floor(_4398 + -0.5f);
                            _4403 = floor(_4399 + 0.5f);
                            _4405 = floor(_4398 + 0.5f);
                            _4407 = floor(_4399 + -0.5f);
                            _4408 = (_4402 < _4196);
                            _4409 = (_4403 < _4197);
                            if ((_4408 || _4409) | ((_4402 >= _4202) || (_4403 >= _4203))) {
                              _4418 = _4165;
                            } else {
                              _4418 = _4394.x;
                            }
                            _4419 = (_4405 < _4196);
                            if ((_4419 || _4409) | ((_4405 >= _4202) || (_4403 >= _4203))) {
                              _4427 = _4165;
                            } else {
                              _4427 = _4394.y;
                            }
                            _4428 = (_4407 < _4197);
                            if ((_4419 || _4428) | ((_4405 >= _4202) || (_4407 >= _4203))) {
                              _4436 = _4165;
                            } else {
                              _4436 = _4394.z;
                            }
                            if ((_4408 || _4428) | ((_4402 >= _4202) || (_4407 >= _4203))) {
                              _4444 = _4165;
                            } else {
                              _4444 = _4394.w;
                            }
                            _4445 = _4418 - _4145;
                            _4447 = select((_4445 < 0.0f), 0.0f, 1.0f);
                            _4451 = _4427 - _4145;
                            _4453 = select((_4451 < 0.0f), 0.0f, 1.0f);
                            _4457 = _4436 - _4145;
                            _4459 = select((_4457 < 0.0f), 0.0f, 1.0f);
                            _4463 = _4444 - _4145;
                            _4465 = select((_4463 < 0.0f), 0.0f, 1.0f);
                            _4472 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4477 = sqrt((float((int)(_4472)) * 0.25f) + 0.125f) * _3997;
                            _4486 = (_global_7[min((uint)(((int)(0u + (_4472 * 2)))), 127u)]) * _4477;
                            _4487 = (_global_7[min((uint)(((int)(1u + (_4472 * 2)))), 127u)]) * _4477;
                            _4490 = dot(float2(_4486, _4487), float2(_4160, _4159)) + _4133;
                            _4491 = dot(float2(_4486, _4487), float2(_4183, _4160)) + _4134;
                            _4493 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4490, _4491));
                            _4497 = _4490 * _4022;
                            _4498 = _4491 * _4023;
                            _4501 = floor(_4497 + -0.5f);
                            _4502 = floor(_4498 + 0.5f);
                            _4504 = floor(_4497 + 0.5f);
                            _4506 = floor(_4498 + -0.5f);
                            _4507 = (_4501 < _4196);
                            _4508 = (_4502 < _4197);
                            if ((_4507 || _4508) | ((_4501 >= _4202) || (_4502 >= _4203))) {
                              _4517 = _4165;
                            } else {
                              _4517 = _4493.x;
                            }
                            _4518 = (_4504 < _4196);
                            if ((_4518 || _4508) | ((_4504 >= _4202) || (_4502 >= _4203))) {
                              _4526 = _4165;
                            } else {
                              _4526 = _4493.y;
                            }
                            _4527 = (_4506 < _4197);
                            if ((_4518 || _4527) | ((_4504 >= _4202) || (_4506 >= _4203))) {
                              _4535 = _4165;
                            } else {
                              _4535 = _4493.z;
                            }
                            if ((_4507 || _4527) | ((_4501 >= _4202) || (_4506 >= _4203))) {
                              _4543 = _4165;
                            } else {
                              _4543 = _4493.w;
                            }
                            _4544 = _4517 - _4145;
                            _4546 = select((_4544 < 0.0f), 0.0f, 1.0f);
                            _4550 = _4526 - _4145;
                            _4552 = select((_4550 < 0.0f), 0.0f, 1.0f);
                            _4556 = _4535 - _4145;
                            _4558 = select((_4556 < 0.0f), 0.0f, 1.0f);
                            _4562 = _4543 - _4145;
                            _4564 = select((_4562 < 0.0f), 0.0f, 1.0f);
                            _4565 = ((((((((((((((_4255 + _4251) + _4261) + _4267) + _4348) + _4354) + _4360) + _4366) + _4447) + _4453) + _4459) + _4465) + _4546) + _4552) + _4558) + _4564;
                            _4576 = (saturate(_4565 * 0.0625f) * 2.0f) + -1.0f;
                            _4582 = float((int)(((int)(uint)((int)(_4576 > 0.0f))) - ((int)(uint)((int)(_4576 < 0.0f)))));
                            _4584 = 1.0f - (_4582 * _4576);
                            _4586 = (_4584 * _4584) * _4584;
                            _4878 = (0.5f - ((_4582 * 0.5f) * ((1.0f - _4586) - ((_4584 - _4586) * saturate(((1.0f / _4145) * (1.0f / _4565)) * ((((((((((((((((_4255 * _4253) + (_4251 * _4249)) + (_4261 * _4259)) + (_4267 * _4265)) + (_4348 * _4346)) + (_4354 * _4352)) + (_4360 * _4358)) + (_4366 * _4364)) + (_4447 * _4445)) + (_4453 * _4451)) + (_4459 * _4457)) + (_4465 * _4463)) + (_4546 * _4544)) + (_4552 * _4550)) + (_4558 * _4556)) + (_4564 * _4562)))))));
                            _4879 = 1.0f;
                            _4880 = 1;
                          } else {
                            _4595 = f16tof32(_3955) / _4089;
                            _4598 = mad((_4595 * _4087), 0.5f, 0.5f);
                            _4599 = mad((_4595 * _4088), 0.5f, 0.5f);
                            if (_4076 > -0.0f) {
                              if ((saturate(_4598) == _4598) && (saturate(_4599) == _4599)) {
                                _4613 = (_4598 * _4018) + _4020;
                                _4614 = (_4599 * _4019) + _4021;
                                _4615 = saturate((_3994 + 1.0f) - (_4076 * _3976));
                                _4619 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4628 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_4619 * 32.665000915527344f) + _125), ((_4619 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4629 = sin(_4628);
                                _4630 = cos(_4628);
                                _4631 = cbSharedPerViewData.nFrameCounter & 3;
                                _4636 = sqrt((float((int)(_4631)) * 0.25f) + 0.125f) * _3997;
                                _4645 = (_global_7[min((uint)(((int)(0u + (_4631 * 2)))), 127u)]) * _4636;
                                _4646 = (_global_7[min((uint)(((int)(1u + (_4631 * 2)))), 127u)]) * _4636;
                                _4648 = -0.0f - _4629;
                                _4653 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4645, _4646), float2(_4630, _4629)) + _4613), (dot(float2(_4645, _4646), float2(_4648, _4630)) + _4614)));
                                _4658 = _4653.x - _4615;
                                _4660 = select((_4658 < 0.0f), 0.0f, 1.0f);
                                _4662 = _4653.y - _4615;
                                _4664 = select((_4662 < 0.0f), 0.0f, 1.0f);
                                _4668 = _4653.z - _4615;
                                _4670 = select((_4668 < 0.0f), 0.0f, 1.0f);
                                _4674 = _4653.w - _4615;
                                _4676 = select((_4674 < 0.0f), 0.0f, 1.0f);
                                _4683 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4688 = sqrt((float((int)(_4683)) * 0.25f) + 0.125f) * _3997;
                                _4697 = (_global_7[min((uint)(((int)(0u + (_4683 * 2)))), 127u)]) * _4688;
                                _4698 = (_global_7[min((uint)(((int)(1u + (_4683 * 2)))), 127u)]) * _4688;
                                _4704 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4697, _4698), float2(_4630, _4629)) + _4613), (dot(float2(_4697, _4698), float2(_4648, _4630)) + _4614)));
                                _4709 = _4704.x - _4615;
                                _4711 = select((_4709 < 0.0f), 0.0f, 1.0f);
                                _4715 = _4704.y - _4615;
                                _4717 = select((_4715 < 0.0f), 0.0f, 1.0f);
                                _4721 = _4704.z - _4615;
                                _4723 = select((_4721 < 0.0f), 0.0f, 1.0f);
                                _4727 = _4704.w - _4615;
                                _4729 = select((_4727 < 0.0f), 0.0f, 1.0f);
                                _4736 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _4741 = sqrt((float((int)(_4736)) * 0.25f) + 0.125f) * _3997;
                                _4750 = (_global_7[min((uint)(((int)(0u + (_4736 * 2)))), 127u)]) * _4741;
                                _4751 = (_global_7[min((uint)(((int)(1u + (_4736 * 2)))), 127u)]) * _4741;
                                _4757 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4750, _4751), float2(_4630, _4629)) + _4613), (dot(float2(_4750, _4751), float2(_4648, _4630)) + _4614)));
                                _4762 = _4757.x - _4615;
                                _4764 = select((_4762 < 0.0f), 0.0f, 1.0f);
                                _4768 = _4757.y - _4615;
                                _4770 = select((_4768 < 0.0f), 0.0f, 1.0f);
                                _4774 = _4757.z - _4615;
                                _4776 = select((_4774 < 0.0f), 0.0f, 1.0f);
                                _4780 = _4757.w - _4615;
                                _4782 = select((_4780 < 0.0f), 0.0f, 1.0f);
                                _4789 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _4794 = sqrt((float((int)(_4789)) * 0.25f) + 0.125f) * _3997;
                                _4803 = (_global_7[min((uint)(((int)(0u + (_4789 * 2)))), 127u)]) * _4794;
                                _4804 = (_global_7[min((uint)(((int)(1u + (_4789 * 2)))), 127u)]) * _4794;
                                _4810 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4803, _4804), float2(_4630, _4629)) + _4613), (dot(float2(_4803, _4804), float2(_4648, _4630)) + _4614)));
                                _4815 = _4810.x - _4615;
                                _4817 = select((_4815 < 0.0f), 0.0f, 1.0f);
                                _4821 = _4810.y - _4615;
                                _4823 = select((_4821 < 0.0f), 0.0f, 1.0f);
                                _4827 = _4810.z - _4615;
                                _4829 = select((_4827 < 0.0f), 0.0f, 1.0f);
                                _4833 = _4810.w - _4615;
                                _4835 = select((_4833 < 0.0f), 0.0f, 1.0f);
                                _4836 = ((((((((((((((_4660 + _4664) + _4670) + _4676) + _4711) + _4717) + _4723) + _4729) + _4764) + _4770) + _4776) + _4782) + _4817) + _4823) + _4829) + _4835;
                                _4847 = (saturate(_4836 * 0.0625f) * 2.0f) + -1.0f;
                                _4853 = float((int)(((int)(uint)((int)(_4847 > 0.0f))) - ((int)(uint)((int)(_4847 < 0.0f)))));
                                _4855 = 1.0f - (_4853 * _4847);
                                _4857 = (_4855 * _4855) * _4855;
                                _4865 = -0.0f - _4087;
                                _4872 = saturate((saturate(rsqrt(dot(float3(_4865, _4079, _4076), float3(_4865, _4079, _4076))) * _4076) * _3974) + _3973);
                                _4874 = 1.0f - (_4872 * _4872);
                                _4878 = (0.5f - ((_4853 * 0.5f) * ((1.0f - _4857) - ((_4855 - _4857) * saturate(((1.0f / _4615) * (1.0f / _4836)) * ((((((((((((((((_4660 * _4658) + (_4664 * _4662)) + (_4670 * _4668)) + (_4676 * _4674)) + (_4711 * _4709)) + (_4717 * _4715)) + (_4723 * _4721)) + (_4729 * _4727)) + (_4764 * _4762)) + (_4770 * _4768)) + (_4776 * _4774)) + (_4782 * _4780)) + (_4817 * _4815)) + (_4823 * _4821)) + (_4829 * _4827)) + (_4835 * _4833)))))));
                                _4879 = (1.0f - (_4874 * _4874));
                                _4880 = 1;
                              } else {
                                _4878 = 1.0f;
                                _4879 = 1.0f;
                                _4880 = 0;
                              }
                            } else {
                              _4878 = 1.0f;
                              _4879 = 1.0f;
                              _4880 = 0;
                            }
                          }
                        } else {
                          _4878 = 1.0f;
                          _4879 = 1.0f;
                          _4880 = 0;
                        }
                        [branch]
                        if (!((_1586 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1586 & 2097152) == 0)) {
                            _4888 = abs(_4087);
                            _4889 = abs(_4088);
                            _4890 = abs(_4089);
                            if (_4888 > max(_4889, _4890)) {
                              _4894 = (_4087 > 0.0f);
                              _4909 = select(_4894, 0.0f, 1.0f);
                              _4910 = 0.0f;
                              _4911 = select(_4894, _4076, _4089);
                              _4912 = _4079;
                              _4913 = _4888;
                            } else {
                              if (_4889 > _4890) {
                                _4900 = (_4079 < -0.0f);
                                _4909 = select(_4900, 0.0f, 1.0f);
                                _4910 = 1.0f;
                                _4911 = _4087;
                                _4912 = select(_4900, _4089, _4076);
                                _4913 = _4889;
                              } else {
                                _4904 = (_4076 < -0.0f);
                                _4909 = select(_4904, 0.0f, 1.0f);
                                _4910 = 2.0f;
                                _4911 = select(_4904, _4087, (-0.0f - _4087));
                                _4912 = _4079;
                                _4913 = _4890;
                              }
                            }
                            _4914 = _4913 * 2.0f;
                            _4919 = -0.0f - _3991;
                            _4928 = ((min(max((_4911 / _4914), _4919), _3991) + _4909) * _3940) + _3942;
                            _4929 = ((min(max((_4912 / _4914), _4919), _3991) + _4910) * _3941) + _3943;
                            _4934 = ((_4909 + -0.5f) * _3940) + _3942;
                            _4935 = ((_4910 + -0.5f) * _3941) + _3943;
                            _4938 = saturate(1.0f - (_4913 * _3976));
                            _4942 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4951 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_4942 * 32.665000915527344f) + _125), ((_4942 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4952 = sin(_4951);
                            _4953 = cos(_4951);
                            _4958 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4928, _4929), 0.0f))).x) > _4938), 1.0f, 0.0f);
                            _4959 = cbSharedPerViewData.nFrameCounter & 3;
                            _4964 = sqrt((float((int)(_4959)) * 0.25f) + 0.125f) * _3998;
                            _4973 = (_global_7[min((uint)(((int)(0u + (_4959 * 2)))), 127u)]) * _4964;
                            _4974 = (_global_7[min((uint)(((int)(1u + (_4959 * 2)))), 127u)]) * _4964;
                            _4976 = -0.0f - _4952;
                            _4978 = dot(float2(_4973, _4974), float2(_4953, _4952)) + _4928;
                            _4979 = dot(float2(_4973, _4974), float2(_4976, _4953)) + _4929;
                            _4981 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4978, _4979));
                            _4985 = _4978 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4986 = _4979 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4989 = floor(_4934 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _4990 = floor(_4935 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _4995 = floor(((_4934 + _3940) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _4996 = floor(((_4935 + _3941) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _4999 = floor(_4985 + -0.5f);
                            _5000 = floor(_4986 + 0.5f);
                            _5002 = floor(_4985 + 0.5f);
                            _5004 = floor(_4986 + -0.5f);
                            _5005 = (_4999 < _4989);
                            _5006 = (_5000 < _4990);
                            if ((_5005 || _5006) | ((_4999 >= _4995) || (_5000 >= _4996))) {
                              _5015 = _4958;
                            } else {
                              _5015 = _4981.x;
                            }
                            _5016 = (_5002 < _4989);
                            if ((_5016 || _5006) | ((_5002 >= _4995) || (_5000 >= _4996))) {
                              _5024 = _4958;
                            } else {
                              _5024 = _4981.y;
                            }
                            _5025 = (_5004 < _4990);
                            if ((_5016 || _5025) | ((_5002 >= _4995) || (_5004 >= _4996))) {
                              _5033 = _4958;
                            } else {
                              _5033 = _4981.z;
                            }
                            if ((_5005 || _5025) | ((_4999 >= _4995) || (_5004 >= _4996))) {
                              _5041 = _4958;
                            } else {
                              _5041 = _4981.w;
                            }
                            _5042 = _5015 - _4938;
                            _5044 = select((_5042 < 0.0f), 0.0f, 1.0f);
                            _5046 = _5024 - _4938;
                            _5048 = select((_5046 < 0.0f), 0.0f, 1.0f);
                            _5052 = _5033 - _4938;
                            _5054 = select((_5052 < 0.0f), 0.0f, 1.0f);
                            _5058 = _5041 - _4938;
                            _5060 = select((_5058 < 0.0f), 0.0f, 1.0f);
                            _5067 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _5072 = sqrt((float((int)(_5067)) * 0.25f) + 0.125f) * _3998;
                            _5081 = (_global_7[min((uint)(((int)(0u + (_5067 * 2)))), 127u)]) * _5072;
                            _5082 = (_global_7[min((uint)(((int)(1u + (_5067 * 2)))), 127u)]) * _5072;
                            _5085 = dot(float2(_5081, _5082), float2(_4953, _4952)) + _4928;
                            _5086 = dot(float2(_5081, _5082), float2(_4976, _4953)) + _4929;
                            _5088 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5085, _5086));
                            _5092 = _5085 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5093 = _5086 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5096 = floor(_5092 + -0.5f);
                            _5097 = floor(_5093 + 0.5f);
                            _5099 = floor(_5092 + 0.5f);
                            _5101 = floor(_5093 + -0.5f);
                            _5102 = (_5096 < _4989);
                            _5103 = (_5097 < _4990);
                            if ((_5102 || _5103) | ((_5096 >= _4995) || (_5097 >= _4996))) {
                              _5112 = _4958;
                            } else {
                              _5112 = _5088.x;
                            }
                            _5113 = (_5099 < _4989);
                            if ((_5113 || _5103) | ((_5099 >= _4995) || (_5097 >= _4996))) {
                              _5121 = _4958;
                            } else {
                              _5121 = _5088.y;
                            }
                            _5122 = (_5101 < _4990);
                            if ((_5113 || _5122) | ((_5099 >= _4995) || (_5101 >= _4996))) {
                              _5130 = _4958;
                            } else {
                              _5130 = _5088.z;
                            }
                            if ((_5102 || _5122) | ((_5096 >= _4995) || (_5101 >= _4996))) {
                              _5138 = _4958;
                            } else {
                              _5138 = _5088.w;
                            }
                            _5139 = _5112 - _4938;
                            _5141 = select((_5139 < 0.0f), 0.0f, 1.0f);
                            _5145 = _5121 - _4938;
                            _5147 = select((_5145 < 0.0f), 0.0f, 1.0f);
                            _5151 = _5130 - _4938;
                            _5153 = select((_5151 < 0.0f), 0.0f, 1.0f);
                            _5157 = _5138 - _4938;
                            _5159 = select((_5157 < 0.0f), 0.0f, 1.0f);
                            _5166 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _5171 = sqrt((float((int)(_5166)) * 0.25f) + 0.125f) * _3998;
                            _5180 = (_global_7[min((uint)(((int)(0u + (_5166 * 2)))), 127u)]) * _5171;
                            _5181 = (_global_7[min((uint)(((int)(1u + (_5166 * 2)))), 127u)]) * _5171;
                            _5184 = dot(float2(_5180, _5181), float2(_4953, _4952)) + _4928;
                            _5185 = dot(float2(_5180, _5181), float2(_4976, _4953)) + _4929;
                            _5187 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5184, _5185));
                            _5191 = _5184 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5192 = _5185 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5195 = floor(_5191 + -0.5f);
                            _5196 = floor(_5192 + 0.5f);
                            _5198 = floor(_5191 + 0.5f);
                            _5200 = floor(_5192 + -0.5f);
                            _5201 = (_5195 < _4989);
                            _5202 = (_5196 < _4990);
                            if ((_5201 || _5202) | ((_5195 >= _4995) || (_5196 >= _4996))) {
                              _5211 = _4958;
                            } else {
                              _5211 = _5187.x;
                            }
                            _5212 = (_5198 < _4989);
                            if ((_5212 || _5202) | ((_5198 >= _4995) || (_5196 >= _4996))) {
                              _5220 = _4958;
                            } else {
                              _5220 = _5187.y;
                            }
                            _5221 = (_5200 < _4990);
                            if ((_5212 || _5221) | ((_5198 >= _4995) || (_5200 >= _4996))) {
                              _5229 = _4958;
                            } else {
                              _5229 = _5187.z;
                            }
                            if ((_5201 || _5221) | ((_5195 >= _4995) || (_5200 >= _4996))) {
                              _5237 = _4958;
                            } else {
                              _5237 = _5187.w;
                            }
                            _5238 = _5211 - _4938;
                            _5240 = select((_5238 < 0.0f), 0.0f, 1.0f);
                            _5244 = _5220 - _4938;
                            _5246 = select((_5244 < 0.0f), 0.0f, 1.0f);
                            _5250 = _5229 - _4938;
                            _5252 = select((_5250 < 0.0f), 0.0f, 1.0f);
                            _5256 = _5237 - _4938;
                            _5258 = select((_5256 < 0.0f), 0.0f, 1.0f);
                            _5265 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _5270 = sqrt((float((int)(_5265)) * 0.25f) + 0.125f) * _3998;
                            _5279 = (_global_7[min((uint)(((int)(0u + (_5265 * 2)))), 127u)]) * _5270;
                            _5280 = (_global_7[min((uint)(((int)(1u + (_5265 * 2)))), 127u)]) * _5270;
                            _5283 = dot(float2(_5279, _5280), float2(_4953, _4952)) + _4928;
                            _5284 = dot(float2(_5279, _5280), float2(_4976, _4953)) + _4929;
                            _5286 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5283, _5284));
                            _5290 = _5283 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _5291 = _5284 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _5294 = floor(_5290 + -0.5f);
                            _5295 = floor(_5291 + 0.5f);
                            _5297 = floor(_5290 + 0.5f);
                            _5299 = floor(_5291 + -0.5f);
                            _5300 = (_5294 < _4989);
                            _5301 = (_5295 < _4990);
                            if ((_5300 || _5301) | ((_5294 >= _4995) || (_5295 >= _4996))) {
                              _5310 = _4958;
                            } else {
                              _5310 = _5286.x;
                            }
                            _5311 = (_5297 < _4989);
                            if ((_5311 || _5301) | ((_5297 >= _4995) || (_5295 >= _4996))) {
                              _5319 = _4958;
                            } else {
                              _5319 = _5286.y;
                            }
                            _5320 = (_5299 < _4990);
                            if ((_5311 || _5320) | ((_5297 >= _4995) || (_5299 >= _4996))) {
                              _5328 = _4958;
                            } else {
                              _5328 = _5286.z;
                            }
                            if ((_5300 || _5320) | ((_5294 >= _4995) || (_5299 >= _4996))) {
                              _5336 = _4958;
                            } else {
                              _5336 = _5286.w;
                            }
                            _5337 = _5310 - _4938;
                            _5339 = select((_5337 < 0.0f), 0.0f, 1.0f);
                            _5343 = _5319 - _4938;
                            _5345 = select((_5343 < 0.0f), 0.0f, 1.0f);
                            _5349 = _5328 - _4938;
                            _5351 = select((_5349 < 0.0f), 0.0f, 1.0f);
                            _5355 = _5336 - _4938;
                            _5357 = select((_5355 < 0.0f), 0.0f, 1.0f);
                            _5358 = ((((((((((((((_5048 + _5044) + _5054) + _5060) + _5141) + _5147) + _5153) + _5159) + _5240) + _5246) + _5252) + _5258) + _5339) + _5345) + _5351) + _5357;
                            _5369 = (saturate(_5358 * 0.0625f) * 2.0f) + -1.0f;
                            _5375 = float((int)(((int)(uint)((int)(_5369 > 0.0f))) - ((int)(uint)((int)(_5369 < 0.0f)))));
                            _5377 = 1.0f - (_5375 * _5369);
                            _5379 = (_5377 * _5377) * _5377;
                            _5670 = (0.5f - ((_5375 * 0.5f) * ((1.0f - _5379) - ((_5377 - _5379) * saturate(((1.0f / _4938) * (1.0f / _5358)) * ((((((((((((((((_5048 * _5046) + (_5044 * _5042)) + (_5054 * _5052)) + (_5060 * _5058)) + (_5141 * _5139)) + (_5147 * _5145)) + (_5153 * _5151)) + (_5159 * _5157)) + (_5240 * _5238)) + (_5246 * _5244)) + (_5252 * _5250)) + (_5258 * _5256)) + (_5339 * _5337)) + (_5345 * _5343)) + (_5351 * _5349)) + (_5357 * _5355)))))));
                            _5671 = 1.0f;
                            _5672 = false;
                          } else {
                            _5388 = f16tof32(((uint)((uint)(_3955) >> 16))) / _4089;
                            _5391 = mad((_5388 * _4087), 0.5f, 0.5f);
                            _5392 = mad((_5388 * _4088), 0.5f, 0.5f);
                            if (_4076 > -0.0f) {
                              if ((saturate(_5391) == _5391) && (saturate(_5392) == _5392)) {
                                _5405 = (_5391 * _3940) + _3942;
                                _5406 = (_5392 * _3941) + _3943;
                                _5407 = saturate(1.0f - (_4076 * _3976));
                                _5411 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _5420 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_5411 * 32.665000915527344f) + _125), ((_5411 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _5421 = sin(_5420);
                                _5422 = cos(_5420);
                                _5423 = cbSharedPerViewData.nFrameCounter & 3;
                                _5428 = sqrt((float((int)(_5423)) * 0.25f) + 0.125f) * _3998;
                                _5437 = (_global_7[min((uint)(((int)(0u + (_5423 * 2)))), 127u)]) * _5428;
                                _5438 = (_global_7[min((uint)(((int)(1u + (_5423 * 2)))), 127u)]) * _5428;
                                _5440 = -0.0f - _5421;
                                _5445 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5437, _5438), float2(_5422, _5421)) + _5405), (dot(float2(_5437, _5438), float2(_5440, _5422)) + _5406)));
                                _5450 = _5445.x - _5407;
                                _5452 = select((_5450 < 0.0f), 0.0f, 1.0f);
                                _5454 = _5445.y - _5407;
                                _5456 = select((_5454 < 0.0f), 0.0f, 1.0f);
                                _5460 = _5445.z - _5407;
                                _5462 = select((_5460 < 0.0f), 0.0f, 1.0f);
                                _5466 = _5445.w - _5407;
                                _5468 = select((_5466 < 0.0f), 0.0f, 1.0f);
                                _5475 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _5480 = sqrt((float((int)(_5475)) * 0.25f) + 0.125f) * _3998;
                                _5489 = (_global_7[min((uint)(((int)(0u + (_5475 * 2)))), 127u)]) * _5480;
                                _5490 = (_global_7[min((uint)(((int)(1u + (_5475 * 2)))), 127u)]) * _5480;
                                _5496 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5489, _5490), float2(_5422, _5421)) + _5405), (dot(float2(_5489, _5490), float2(_5440, _5422)) + _5406)));
                                _5501 = _5496.x - _5407;
                                _5503 = select((_5501 < 0.0f), 0.0f, 1.0f);
                                _5507 = _5496.y - _5407;
                                _5509 = select((_5507 < 0.0f), 0.0f, 1.0f);
                                _5513 = _5496.z - _5407;
                                _5515 = select((_5513 < 0.0f), 0.0f, 1.0f);
                                _5519 = _5496.w - _5407;
                                _5521 = select((_5519 < 0.0f), 0.0f, 1.0f);
                                _5528 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _5533 = sqrt((float((int)(_5528)) * 0.25f) + 0.125f) * _3998;
                                _5542 = (_global_7[min((uint)(((int)(0u + (_5528 * 2)))), 127u)]) * _5533;
                                _5543 = (_global_7[min((uint)(((int)(1u + (_5528 * 2)))), 127u)]) * _5533;
                                _5549 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5542, _5543), float2(_5422, _5421)) + _5405), (dot(float2(_5542, _5543), float2(_5440, _5422)) + _5406)));
                                _5554 = _5549.x - _5407;
                                _5556 = select((_5554 < 0.0f), 0.0f, 1.0f);
                                _5560 = _5549.y - _5407;
                                _5562 = select((_5560 < 0.0f), 0.0f, 1.0f);
                                _5566 = _5549.z - _5407;
                                _5568 = select((_5566 < 0.0f), 0.0f, 1.0f);
                                _5572 = _5549.w - _5407;
                                _5574 = select((_5572 < 0.0f), 0.0f, 1.0f);
                                _5581 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _5586 = sqrt((float((int)(_5581)) * 0.25f) + 0.125f) * _3998;
                                _5595 = (_global_7[min((uint)(((int)(0u + (_5581 * 2)))), 127u)]) * _5586;
                                _5596 = (_global_7[min((uint)(((int)(1u + (_5581 * 2)))), 127u)]) * _5586;
                                _5602 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5595, _5596), float2(_5422, _5421)) + _5405), (dot(float2(_5595, _5596), float2(_5440, _5422)) + _5406)));
                                _5607 = _5602.x - _5407;
                                _5609 = select((_5607 < 0.0f), 0.0f, 1.0f);
                                _5613 = _5602.y - _5407;
                                _5615 = select((_5613 < 0.0f), 0.0f, 1.0f);
                                _5619 = _5602.z - _5407;
                                _5621 = select((_5619 < 0.0f), 0.0f, 1.0f);
                                _5625 = _5602.w - _5407;
                                _5627 = select((_5625 < 0.0f), 0.0f, 1.0f);
                                _5628 = ((((((((((((((_5452 + _5456) + _5462) + _5468) + _5503) + _5509) + _5515) + _5521) + _5556) + _5562) + _5568) + _5574) + _5609) + _5615) + _5621) + _5627;
                                _5639 = (saturate(_5628 * 0.0625f) * 2.0f) + -1.0f;
                                _5645 = float((int)(((int)(uint)((int)(_5639 > 0.0f))) - ((int)(uint)((int)(_5639 < 0.0f)))));
                                _5647 = 1.0f - (_5645 * _5639);
                                _5649 = (_5647 * _5647) * _5647;
                                _5657 = -0.0f - _4087;
                                _5664 = saturate((saturate(rsqrt(dot(float3(_5657, _4079, _4076), float3(_5657, _4079, _4076))) * _4076) * _3974) + _3973);
                                _5666 = 1.0f - (_5664 * _5664);
                                _5670 = (0.5f - ((_5645 * 0.5f) * ((1.0f - _5649) - ((_5647 - _5649) * saturate(((1.0f / _5407) * (1.0f / _5628)) * ((((((((((((((((_5452 * _5450) + (_5456 * _5454)) + (_5462 * _5460)) + (_5468 * _5466)) + (_5503 * _5501)) + (_5509 * _5507)) + (_5515 * _5513)) + (_5521 * _5519)) + (_5556 * _5554)) + (_5562 * _5560)) + (_5568 * _5566)) + (_5574 * _5572)) + (_5609 * _5607)) + (_5615 * _5613)) + (_5621 * _5619)) + (_5627 * _5625)))))));
                                _5671 = (1.0f - (_5666 * _5666));
                                _5672 = false;
                              } else {
                                _5670 = 1.0f;
                                _5671 = 1.0f;
                                _5672 = true;
                              }
                            } else {
                              _5670 = 1.0f;
                              _5671 = 1.0f;
                              _5672 = true;
                            }
                          }
                        } else {
                          _5670 = 1.0f;
                          _5671 = 1.0f;
                          _5672 = true;
                        }
                        if (_4880 == 0) {
                          if (!_5672) {
                            _5687 = _4878;
                            _5688 = ((_5671 * (_5670 + -1.0f)) + 1.0f);
                            _5689 = 0.0f;
                          } else {
                            _5687 = _4878;
                            _5688 = _5670;
                            _5689 = 0.0f;
                          }
                        } else {
                          if (_5672) {
                            _5687 = ((_4879 * (_4878 + -1.0f)) + 1.0f);
                            _5688 = _5670;
                            _5689 = 1.0f;
                          } else {
                            _5687 = _4878;
                            _5688 = _5670;
                            _5689 = (_4879 * f16tof32(_3925));
                          }
                        }
                        _5692 = (_5689 * (_5687 - _5688)) + _5688;
                        [branch]
                        if (!((_1586 & 2048) == 0)) {
                          _5694 = _222 - _3897;
                          _5695 = _223 - _3898;
                          _5696 = _224 - _3899;
                          _5711 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5696, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5695, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5694)));
                          _5714 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _5696, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _5695, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _5694)));
                          _5717 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _5696, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _5695, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _5694)));
                          _5719 = rsqrt(dot(float3(_5711, _5714, _5717), float3(_5711, _5714, _5717)));
                          _5720 = _5719 * _5711;
                          _5721 = _5719 * _5714;
                          _5722 = _5719 * _5717;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3931) >> 16))];
                          _5730 = (abs(_5721) + abs(_5720)) + abs(_5722);
                          _5731 = _5720 / _5730;
                          _5732 = _5721 / _5730;
                          _5734 = !((_5722 / _5730) >= 0.0f);
                          if (_5734) {
                            _5747 = ((1.0f - abs(_5732)) * select((_5731 >= 0.0f), 1.0f, -1.0f));
                            _5748 = ((1.0f - abs(_5731)) * select((_5732 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _5747 = _5731;
                            _5748 = _5732;
                          }
                          _5754 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5747 * 0.5f) + 0.5f), ((_5748 * 0.5f) + 0.5f)), 0.0f);
                          if (_5754.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3931 & 65535))];
                            if (_5734) {
                              _5773 = ((1.0f - abs(_5732)) * select((_5731 >= 0.0f), 1.0f, -1.0f));
                              _5774 = ((1.0f - abs(_5731)) * select((_5732 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _5773 = _5731;
                              _5774 = _5732;
                            }
                            _5779 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5773 * 0.5f) + 0.5f), ((_5774 * 0.5f) + 0.5f)), 0.0f);
                            _5799 = mad(saturate(((log2(sqrt(((_5694 * _5694) + (_5695 * _5695)) + (_5696 * _5696))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _5800 = max(9.999999747378752e-06f, _5754.x);
                            _5801 = _5779.x / _5800;
                            _5802 = _5779.y / _5800;
                            _5804 = _5779.w / _5800;
                            _5809 = ((0.375f - _5802) * 4.999999873689376e-06f) + _5802;
                            _5812 = -0.0f - _5801;
                            _5813 = mad(_5812, _5809, (_5779.z / _5800));
                            _5815 = 1.0f / mad(_5812, _5801, _5809);
                            _5816 = _5815 * _5813;
                            _5821 = _5799 - _5801;
                            _5826 = (((_5799 * _5799) - _5809) - (_5816 * _5821)) / mad((-0.0f - _5813), _5816, mad((-0.0f - _5809), _5809, (((0.375f - _5804) * 4.999999873689376e-06f) + _5804)));
                            _5828 = (_5815 * _5821) - (_5826 * _5816);
                            _5831 = 1.0f / _5826;
                            _5832 = _5828 * _5831;
                            _5837 = sqrt(((_5832 * _5832) * 0.25f) - ((1.0f - dot(float2(_5828, _5826), float2(_5801, _5809))) * _5831));
                            _5839 = (_5832 * -0.5f) - _5837;
                            _5841 = _5837 - (_5832 * 0.5f);
                            _5843 = select((_5839 < _5799), 1.0f, 0.0f);
                            _5848 = (_5843 + -0.05000000074505806f) / (_5839 - _5799);
                            _5854 = (((select((_5841 < _5799), 1.0f, 0.0f) - _5843) / (_5841 - _5839)) - _5848) / (_5841 - _5799);
                            _5856 = _5848 - (_5854 * _5839);
                            _5869 = (exp2((_5754.x * -1.4426950216293335f) * saturate((dot(float2(_5801, _5809), float2((_5856 - (_5854 * _5799)), _5854)) + 0.05000000074505806f) - (_5856 * _5799))) * _5692);
                          } else {
                            _5869 = _5692;
                          }
                        } else {
                          _5869 = _5692;
                        }
                        _5872 = (_5869 * _4050);
                        _5873 = _5869;
                      } else {
                        _5872 = _4050;
                        _5873 = 1.0f;
                      }
                      [branch]
                      if (!(_3979 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3979)))];
                        _5885 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_4029, _3892, mad(_4028, _3887, (_4027 * _3882)))), (-0.0f - mad(_4029, _3893, mad(_4028, _3888, (_4027 * _3883)))), (-0.0f - mad(_4029, _3894, mad(_4028, _3889, (_4027 * _3884))))), 0.0f);
                        _5893 = (_5885.x * _3957);
                        _5894 = (_5885.y * _3958);
                        _5895 = (_5885.z * _3960);
                      } else {
                        _5893 = _3957;
                        _5894 = _3958;
                        _5895 = _3960;
                      }
                      [branch]
                      if (!(_5872 == 0.0f)) {
                        bool __branch_chain_5897;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _5913 = 0;
                          __branch_chain_5897 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _5913 = 1;
                            __branch_chain_5897 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _5913 = 2;
                              __branch_chain_5897 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _5913 = 3;
                                __branch_chain_5897 = true;
                              } else {
                                _5934 = _5872;
                                __branch_chain_5897 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_5897) {
                          while(true) {
                            _5916 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                            if (_5913 == 0) {
                              _5930 = _5916.x;
                            } else {
                              if (_5913 == 1) {
                                _5930 = _5916.y;
                              } else {
                                if (_5913 == 2) {
                                  _5930 = _5916.z;
                                } else {
                                  _5930 = _5916.w;
                                }
                              }
                            }
                            _5934 = ((_5930 * _5930) * _4050);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_5934 == 0.0f)) {
                            [branch]
                            if (!(((_3934 & 1) == 0) || (!_4081))) {
                              _5951 = max(max(_5893, _5894), _5895);
                              if (_5951 > 0.0f) {
                                _5961 = saturate(_5893 / _5951);
                                _5962 = saturate(_5894 / _5951);
                                _5963 = saturate(_5895 / _5951);
                              } else {
                                _5961 = _5893;
                                _5962 = _5894;
                                _5963 = _5895;
                              }
                              _5964 = (_5962 < _5963);
                              _5965 = select(_5964, _5963, _5962);
                              _5966 = select(_5964, _5962, _5963);
                              _5967 = select(_5964, -1.0f, 0.0f);
                              _5968 = (_5961 < _5965);
                              _5970 = select(_5968, _5965, _5961);
                              _5971 = select(_5968, _5961, _5965);
                              _5975 = _5970 - select((_5971 < _5966), _5971, _5966);
                              _5981 = abs(select(_5968, (-0.3333333432674408f - _5967), _5967) + ((_5971 - _5966) / ((_5975 * 6.0f) + 9.999999682655225e-21f)));
                              if (_5981 < 0.6666666865348816f) {
                                _5994 = ((saturate(((float)((uint)((uint)(((uint)(_3934) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5981 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5981)) + _5981);
                              } else {
                                _5994 = _5981;
                              }
                              _5995 = saturate((_5975 / (_5970 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3934) >> 1) & 255)))) * 0.003921499941498041f));
                              _5996 = saturate(_5970);
                              if (!(_5995 <= 0.0f)) {
                                _5999 = saturate(_5994);
                                _6003 = select(((_5999 * 360.0f) >= 360.0f), 0.0f, (_5999 * 6.0f));
                                _6004 = int(_6003);
                                _6006 = _6003 - float((int)(_6004));
                                _6008 = _5996 * (1.0f - _5995);
                                _6011 = (1.0f - (_6006 * _5995)) * _5996;
                                _6015 = (1.0f - ((1.0f - _6006) * _5995)) * _5996;
                                switch (_6004) {
                                  case 0: {
                                    _6023 = _5996;
                                    _6024 = _6015;
                                    _6025 = _6008;
                                    break;
                                  }
                                  case 1: {
                                    _6023 = _6011;
                                    _6024 = _5996;
                                    _6025 = _6008;
                                    break;
                                  }
                                  case 2: {
                                    _6023 = _6008;
                                    _6024 = _5996;
                                    _6025 = _6015;
                                    break;
                                  }
                                  case 3: {
                                    _6023 = _6008;
                                    _6024 = _6011;
                                    _6025 = _5996;
                                    break;
                                  }
                                  case 4: {
                                    _6023 = _6015;
                                    _6024 = _6008;
                                    _6025 = _5996;
                                    break;
                                  }
                                  case 5: {
                                    _6023 = _5996;
                                    _6024 = _6008;
                                    _6025 = _6011;
                                    break;
                                  }
                                  default: {
                                    _6023 = 0.0f;
                                    _6024 = 0.0f;
                                    _6025 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _6023 = _5996;
                                _6024 = _5996;
                                _6025 = _5996;
                              }
                              _6026 = _6023 * _5951;
                              _6027 = _6024 * _5951;
                              _6028 = _6025 * _5951;
                              _6030 = saturate(_5873 * 1.0101009607315063f);
                              _6041 = ((_6030 * (_5893 - _6026)) + _6026);
                              _6042 = ((_6030 * (_5894 - _6027)) + _6027);
                              _6043 = (lerp(_6028, _5895, _6030));
                            } else {
                              _6041 = _5893;
                              _6042 = _5894;
                              _6043 = _5895;
                            }
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _6050 = srvLightMappingData[_1589];
                              if (!(_6050 == -1)) {
                                _6055 = srvLightIndexData[_6050].nLayerIndex;
                                _6057 = srvLightIndexData[_6050].vAtlasOrigin.x;
                                _6058 = srvLightIndexData[_6050].vAtlasOrigin.y;
                                _6060 = srvLightIndexData[_6050].vScreenOrigin.x;
                                _6061 = srvLightIndexData[_6050].vScreenOrigin.y;
                                _6070 = ((int)(_6055 * 5)) & 31;
                                _6079 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6057 + _63) - _6060)), ((int)((_6058 + _64) - _6061)), 0)))).x) & ((int)(31 << _6070)))) >> _6070)) >> 1)))) * 0.06666667014360428f) * _5934);
                              } else {
                                _6079 = _5934;
                              }
                            } else {
                              _6079 = _5934;
                            }
                            _6083 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _6086 = select(_6083, (_6079 * _1266), _6079);
                            _6088 = _4033 * _4032;
                            _6089 = _4034 * _4032;
                            _6090 = _4035 * _4032;
                            _6091 = _3965 * _3902;
                            _6092 = _3965 * _3903;
                            _6093 = _3965 * _3904;
                            _6094 = _6088 + _6091;
                            _6095 = _6089 + _6092;
                            _6096 = _6090 + _6093;
                            _6097 = _6088 - _6091;
                            _6098 = _6089 - _6092;
                            _6099 = _6090 - _6093;
                            _6100 = (_3965 > 0.0f);
                            _6101 = dot(float3(_6094, _6095, _6096), float3(_6094, _6095, _6096));
                            _6102 = rsqrt(_6101);
                            [branch]
                            if (_6100) {
                              _6105 = rsqrt(dot(float3(_6097, _6098, _6099), float3(_6097, _6098, _6099)));
                              _6106 = _6105 * _6102;
                              _6108 = dot(float3(_6094, _6095, _6096), float3(_6097, _6098, _6099)) * _6106;
                              _6127 = (_6106 / ((_6106 + 0.5f) + (_6108 * 0.5f)));
                              _6128 = (((dot(float3(_192, _193, _194), float3(_6097, _6098, _6099)) * _6105) + (dot(float3(_192, _193, _194), float3(_6094, _6095, _6096)) * _6102)) * 0.5f);
                              _6129 = _6108;
                            } else {
                              _6127 = (1.0f / (_6101 + 1.0f));
                              _6128 = dot(float3(_192, _193, _194), float3((_6102 * _6094), (_6102 * _6095), (_6102 * _6096)));
                              _6129 = 1.0f;
                            }
                            if (_3967 > 0.0f) {
                              _6135 = sqrt(saturate((_3967 * _3967) * _6127));
                              if (_6128 < _6135) {
                                _6140 = max(_6128, (-0.0f - _6135)) + _6135;
                                _6145 = ((_6140 * _6140) / (_6135 * 4.0f));
                              } else {
                                _6145 = _6128;
                              }
                            } else {
                              _6145 = _6128;
                            }
                            if (_6100) {
                              _6147 = -0.0f - _437;
                              _6148 = -0.0f - _438;
                              _6149 = -0.0f - _436;
                              _6151 = dot(float3(_6147, _6148, _6149), float3(_192, _193, _194)) * 2.0f;
                              _6155 = _6147 - (_6151 * _192);
                              _6156 = _6148 - (_6151 * _193);
                              _6157 = _6149 - (_6151 * _194);
                              _6158 = _6097 - _6094;
                              _6159 = _6098 - _6095;
                              _6160 = _6099 - _6096;
                              _6161 = dot(float3(_6155, _6156, _6157), float3(_6158, _6159, _6160));
                              _6167 = sqrt(((_6158 * _6158) + (_6159 * _6159)) + (_6160 * _6160));
                              _6176 = saturate(((dot(float3(_6155, _6156, _6157), float3(_6094, _6095, _6096)) * _6161) - dot(float3(_6094, _6095, _6096), float3(_6158, _6159, _6160))) / ((_6167 * _6167) - (_6161 * _6161)));
                              _6180 = (_6176 * _6158) + _6094;
                              _6181 = (_6176 * _6159) + _6095;
                              _6182 = (_6176 * _6160) + _6096;
                              _6183 = dot(float3(_6180, _6181, _6182), float3(_6155, _6156, _6157));
                              _6187 = (_6183 * _6155) - _6180;
                              _6188 = (_6183 * _6156) - _6181;
                              _6189 = (_6183 * _6157) - _6182;
                              _6197 = saturate(0.009999999776482582f / sqrt(((_6187 * _6187) + (_6188 * _6188)) + (_6189 * _6189)));
                              _6205 = ((_6197 * _6187) + _6180);
                              _6206 = ((_6197 * _6188) + _6181);
                              _6207 = ((_6197 * _6189) + _6182);
                            } else {
                              _6205 = _6094;
                              _6206 = _6095;
                              _6207 = _6096;
                            }
                            _6209 = rsqrt(dot(float3(_6205, _6206, _6207), float3(_6205, _6206, _6207)));
                            _6210 = _6209 * _6205;
                            _6211 = _6209 * _6206;
                            _6212 = _6209 * _6207;
                            _6213 = _214 * _214;
                            _6217 = saturate((_3967 * (1.0f - _6213)) * _6209);
                            _6219 = saturate(_6209 * f16tof32(_3916));
                            _6221 = rsqrt(dot(float3(_6088, _6089, _6090), float3(_6088, _6089, _6090)));
                            _6222 = _6221 * _6088;
                            _6223 = _6221 * _6089;
                            _6224 = _6221 * _6090;
                            _6225 = dot(float3(_192, _193, _194), float3(_6210, _6211, _6212));
                            _6226 = dot(float3(_437, _438, _436), float3(_6210, _6211, _6212));
                            _6229 = rsqrt((_6226 * 2.0f) + 2.0f);
                            _6236 = (_6217 > 0.0f);
                            if (_6236) {
                              _6240 = sqrt(1.0f - (_6217 * _6217));
                              _6242 = (_6225 * 2.0f) * _1123;
                              _6243 = _6242 - _6226;
                              if (!(_6243 >= _6240)) {
                                _6251 = rsqrt(1.0f - (_6243 * _6243)) * _6217;
                                _6254 = _6251 * (_1123 - (_6243 * _6225));
                                _6255 = _1123 * _1123;
                                _6260 = _6251 * (((_6255 * 2.0f) + -1.0f) - (_6243 * _6226));
                                _6269 = sqrt(saturate((((1.0f - (_6225 * _6225)) - _6255) - (_6226 * _6226)) + (_6242 * _6226)));
                                _6270 = _6269 * _6251;
                                _6273 = ((_1123 * 2.0f) * _6251) * _6269;
                                _6275 = (_6240 * _6225) + _1123;
                                _6276 = _6275 + _6254;
                                _6277 = _6240 * _6226;
                                _6279 = (_6277 + 1.0f) + _6260;
                                _6280 = _6270 * _6279;
                                _6281 = _6276 * _6279;
                                _6282 = _6273 * _6276;
                                _6287 = (((_6276 * 0.25f) * _6273) - (_6280 * 0.5f)) * _6281;
                                _6301 = (((_6282 - (_6280 * 2.0f)) * _6282) + (_6280 * _6280)) + ((((-0.5f - ((_6279 + _6277) * 0.5f)) * _6281) + ((_6279 * _6279) * _6275)) * _6276);
                                _6306 = (_6287 * 2.0f) / ((_6301 * _6301) + (_6287 * _6287));
                                _6307 = _6301 * _6306;
                                _6309 = 1.0f - (_6287 * _6306);
                                _6315 = ((_6307 * _6273) + _6277) + (_6309 * _6260);
                                _6318 = rsqrt((_6315 * 2.0f) + 2.0f);
                                _6327 = saturate((_6315 * _6318) + _6318);
                                _6328 = saturate(((_6275 + (_6307 * _6270)) + (_6309 * _6254)) * _6318);
                              } else {
                                _6327 = abs(_1123);
                                _6328 = 1.0f;
                              }
                            } else {
                              _6327 = saturate((_6229 * _6226) + _6229);
                              _6328 = saturate(_6229 * (_1123 + _6225));
                            }
                            _6329 = saturate(_6145);
                            _6330 = dot(float3(_192, _193, _194), float3(_6222, _6223, _6224));
                            _6331 = saturate(_6330);
                            _6332 = _6213 * _6213;
                            if (_6219 > 0.0f) {
                              _6342 = saturate(((_6219 * _6219) / ((_6327 * 3.5999999046325684f) + 0.4000000059604645f)) + _6332);
                            } else {
                              _6342 = _6332;
                            }
                            if (_6236) {
                              _6351 = (((_6217 * 0.25f) * ((sqrt(_6342) * 3.0f) + _6217)) / (_6327 + 0.0010000000474974513f)) + _6342;
                              _6354 = _6351;
                              _6355 = (_6342 / _6351);
                            } else {
                              _6354 = _6342;
                              _6355 = 1.0f;
                            }
                            if (_6129 < 1.0f) {
                              _6362 = sqrt((1.000100016593933f - _6129) / max(9.999999974752427e-07f, (_6129 + 1.0f)));
                              _6375 = (sqrt(_6354 / ((((_6362 * 0.25f) * ((sqrt(_6354) * 3.0f) + _6362)) / (_6327 + 0.0010000000474974513f)) + _6354)) * _6355);
                            } else {
                              _6375 = _6355;
                            }
                            _6379 = (((_6342 * _6328) - _6328) * _6328) + 1.0f;
                            _6382 = (_6342 / (_6379 * _6379)) * _6375;
                            _6390 = exp2(log2(1.0f - saturate(_6327)) * 5.0f);
                            _6394 = (_6390 * (1.0f - _207)) + _207;
                            _6395 = (_6390 * (1.0f - _208)) + _208;
                            _6396 = (_6390 * (1.0f - _209)) + _209;
                            _6399 = saturate(abs(_1123) + 9.999999747378752e-06f);
                            _6400 = sqrt(_6342);
                            _6401 = 1.0f - _6400;
                            _6409 = 0.5f / ((((_6401 * _6399) + _6400) * _6329) + (((_6401 * _6329) + _6400) * _6399));
                            if (_212 < 0.007874015718698502f) {
                              _6415 = _6328 * _6328;
                              _6417 = max((1.0f - _6415), 9.999999747378752e-05f);
                              _6562 = (((((((exp2(((-0.0f - (_6415 / _6417)) / _6342) * 1.4426950216293335f) * 4.0f) / (_6417 * _6417)) + 1.0f) * (1.0f / ((_6342 * 4.0f) + 1.0f))) - _6382) * _168) + _6382);
                              _6563 = (((saturate(0.25f / ((_6331 + _1124) - (_6331 * _1124))) - _6409) * _168) + _6409);
                            } else {
                              _6441 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
                              _6442 = _6441 * _192;
                              _6443 = _6441 * _193;
                              _6444 = _6441 * _194;
                              _6447 = (abs(_6442) < abs(_6443));
                              _6448 = select(_6447, 1.0f, 0.0f);
                              _6449 = select(_6447, 0.0f, 1.0f);
                              _6450 = _6449 * _6444;
                              _6452 = -0.0f - (_6444 * _6448);
                              _6455 = (_6448 * _6443) - (_6449 * _6442);
                              _6457 = rsqrt(dot(float3(_6450, _6452, _6455), float3(_6450, _6452, _6455)));
                              _6458 = _6450 * _6457;
                              _6459 = _6457 * _6452;
                              _6460 = _6455 * _6457;
                              _6463 = (_6459 * _6444) - (_6460 * _6443);
                              _6466 = (_6460 * _6442) - (_6458 * _6444);
                              _6469 = (_6458 * _6443) - (_6459 * _6442);
                              _6471 = rsqrt(dot(float3(_6463, _6466, _6469), float3(_6463, _6466, _6469)));
                              _6475 = _168 * 4.0f;
                              _6484 = saturate(abs(_6475 + -2.5f) + -0.5f) + -0.5f;
                              _6485 = saturate(1.5f - abs(_6475 + -1.5f)) + -0.5f;
                              _6487 = rsqrt(dot(float2(_6484, _6485), float2(_6484, _6485)));
                              _6488 = _6487 * _6484;
                              _6489 = _6487 * _6485;
                              _6496 = ((_6463 * _6471) * _6488) + (_6489 * _6458);
                              _6497 = ((_6466 * _6471) * _6488) + (_6489 * _6459);
                              _6498 = ((_6469 * _6471) * _6488) + (_6489 * _6460);
                              _6501 = (_6497 * _194) - (_6498 * _193);
                              _6504 = (_6498 * _192) - (_6496 * _194);
                              _6507 = (_6496 * _193) - (_6497 * _192);
                              _6511 = rsqrt((dot(float3(_437, _438, _436), float3(_6222, _6223, _6224)) * 2.0f) + 2.0f);
                              _6515 = dot(float3(_6496, _6497, _6498), float3(_6222, _6223, _6224));
                              _6516 = dot(float3(_6496, _6497, _6498), float3(_437, _438, _436));
                              _6519 = dot(float3(_6501, _6504, _6507), float3(_6222, _6223, _6224));
                              _6520 = dot(float3(_6501, _6504, _6507), float3(_437, _438, _436));
                              _6526 = min(max((_6213 * (_212 + 1.0f)), 0.0010000000474974513f), 1.0f);
                              _6530 = min(max((_6213 * (1.0f - _212)), 0.0010000000474974513f), 1.0f);
                              _6531 = _6530 * _6526;
                              _6532 = ((_6516 + _6515) * _6511) * _6530;
                              _6533 = ((_6520 + _6519) * _6511) * _6526;
                              _6534 = _6531 * saturate(_6511 * (_1123 + _6330));
                              _6535 = dot(float3(_6532, _6533, _6534), float3(_6532, _6533, _6534));
                              _6540 = _6526 * _6516;
                              _6541 = _6530 * _6520;
                              _6549 = _6526 * _6515;
                              _6550 = _6530 * _6519;
                              _6562 = (((_6531 * _6531) * _6531) / (_6535 * _6535));
                              _6563 = saturate(0.5f / ((sqrt(((_6549 * _6549) + (_6331 * _6331)) + (_6550 * _6550)) * _6399) + (sqrt(((_6541 * _6541) + (_6540 * _6540)) + (_6399 * _6399)) * _6331)));
                            }
                            _6565 = (_6562 * _6331) * _6563;
                            _6580 = saturate((_6330 + 0.5f) * 0.6666666865348816f);
                            _6587 = _6041 * _1637;
                            _6588 = _6042 * _1637;
                            _6589 = _6043 * _1637;
                            _6602 = ((((_6086 * _6587) * (1.0f - _6394)) * _6580) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _6331)) + _1574;
                            _6603 = ((((_6086 * _6588) * (1.0f - _6395)) * _6580) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _6331)) + _1575;
                            _6604 = ((((_6086 * _6589) * (1.0f - _6396)) * _6580) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _6331)) + _1576;
                            if (_3964 > 0.0f) {
                              _6608 = (_3964 * _1339) * select(_6083, (_6079 * _1266), _6079);
                              _9254 = _6602;
                              _9255 = _6603;
                              _9256 = _6604;
                              _9257 = ((((_6608 * _6587) * _6394) * _6565) + _1577);
                              _9258 = ((((_6608 * _6588) * _6395) * _6565) + _1578);
                              _9259 = ((((_6608 * _6589) * _6396) * _6565) + _1579);
                            } else {
                              _9254 = _6602;
                              _9255 = _6603;
                              _9256 = _6604;
                              _9257 = _1577;
                              _9258 = _1578;
                              _9259 = _1579;
                            }
                          } else {
                            _9254 = _1574;
                            _9255 = _1575;
                            _9256 = _1576;
                            _9257 = _1577;
                            _9258 = _1578;
                            _9259 = _1579;
                          }
                          break;
                        }
                      } else {
                        _9254 = _1574;
                        _9255 = _1575;
                        _9256 = _1576;
                        _9257 = _1577;
                        _9258 = _1578;
                        _9259 = _1579;
                      }
                    } else {
                      if (_1620 == 8) {
                        _6626 = asfloat(srvLightInfoProperties.Load3(_1588)).x;
                        _6627 = asfloat(srvLightInfoProperties.Load3(_1588)).y;
                        _6628 = asfloat(srvLightInfoProperties.Load3(_1588)).z;
                        _6631 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 12u)))).x;
                        _6632 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 12u)))).y;
                        _6633 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 12u)))).z;
                        _6636 = asfloat(srvLightInfoProperties.Load(((int)(_1588 + 24u))));
                        _6639 = asint(srvLightInfoProperties.Load(((int)(_1588 + 28u))));
                        _6642 = asint(srvLightInfoProperties.Load(((int)(_1588 + 32u))));
                        _6645 = asint(srvLightInfoProperties.Load(((int)(_1588 + 44u))));
                        _6654 = ((float)((uint)((uint)(((uint)(_6642) >> 8) & 255)))) * 0.003921499941498041f;
                        _6657 = f16tof32(_6645);
                        _6664 = min(max(dot(float3((_222 - _6626), (_223 - _6627), (_224 - _6628)), float3(_6631, _6632, _6633)), (-0.0f - _6636)), _6636);
                        _6669 = (_6626 - _222) + (_6664 * _6631);
                        _6671 = (_6627 - _223) + (_6664 * _6632);
                        _6673 = (_6628 + _221) + (_6664 * _6633);
                        _6674 = dot(float3(_6669, _6671, _6673), float3(_6669, _6671, _6673));
                        _6675 = rsqrt(_6674);
                        _6677 = _6669 * _6675;
                        _6678 = _6671 * _6675;
                        _6679 = _6673 * _6675;
                        _6682 = max(0.0f, ((_6675 * _6674) - abs(_6657)));
                        _6683 = _6682 * f16tof32(((uint)((uint)(_6645) >> 16)));
                        _6684 = _6683 * _6683;
                        _6687 = saturate(1.0f - (_6684 * _6684));
                        _6694 = (_6687 * _6687) / (select((_6657 < 0.0f), (_6684 * 16.0f), (_6682 * _6682)) + 1.0f);
                        [branch]
                        if (!(_6694 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _6703 = srvLightMappingData[_1589];
                            if (!(_6703 == -1)) {
                              _6708 = srvLightIndexData[_6703].nLayerIndex;
                              _6710 = srvLightIndexData[_6703].vAtlasOrigin.x;
                              _6711 = srvLightIndexData[_6703].vAtlasOrigin.y;
                              _6713 = srvLightIndexData[_6703].vScreenOrigin.x;
                              _6714 = srvLightIndexData[_6703].vScreenOrigin.y;
                              _6723 = ((int)(_6708 * 5)) & 31;
                              _6732 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6710 + _63) - _6713)), ((int)((_6711 + _64) - _6714)), 0)))).x) & ((int)(31 << _6723)))) >> _6723)) >> 1)))) * 0.06666667014360428f) * _6694);
                            } else {
                              _6732 = _6694;
                            }
                          } else {
                            _6732 = _6694;
                          }
                          _6736 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _6739 = select(_6736, (_6732 * _1266), _6732);
                          _6741 = dot(float3(_192, _193, _194), float3(_6677, _6678, _6679));
                          _6742 = dot(float3(_437, _438, _436), float3(_6677, _6678, _6679));
                          _6745 = rsqrt((_6742 * 2.0f) + 2.0f);
                          _6748 = saturate(_6745 * (_1123 + _6741));
                          _6752 = saturate(_6741);
                          _6753 = _214 * _214;
                          _6754 = _6753 * _6753;
                          _6758 = (((_6748 * _6754) - _6748) * _6748) + 1.0f;
                          _6760 = _6754 / (_6758 * _6758);
                          _6768 = exp2(log2(1.0f - saturate(saturate((_6745 * _6742) + _6745))) * 5.0f);
                          _6772 = (_6768 * (1.0f - _207)) + _207;
                          _6773 = (_6768 * (1.0f - _208)) + _208;
                          _6774 = (_6768 * (1.0f - _209)) + _209;
                          _6777 = saturate(abs(_1123) + 9.999999747378752e-06f);
                          _6778 = sqrt(_6754);
                          _6779 = 1.0f - _6778;
                          _6787 = 0.5f / ((((_6779 * _6777) + _6778) * _6752) + (((_6779 * _6752) + _6778) * _6777));
                          if (_212 < 0.007874015718698502f) {
                            _6793 = _6748 * _6748;
                            _6795 = max((1.0f - _6793), 9.999999747378752e-05f);
                            _6933 = (((((((exp2(((-0.0f - (_6793 / _6795)) / _6754) * 1.4426950216293335f) * 4.0f) / (_6795 * _6795)) + 1.0f) * (1.0f / ((_6754 * 4.0f) + 1.0f))) - _6760) * _168) + _6760);
                            _6934 = (((saturate(0.25f / ((_6752 + _1124) - (_6752 * _1124))) - _6787) * _168) + _6787);
                          } else {
                            _6819 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
                            _6820 = _6819 * _192;
                            _6821 = _6819 * _193;
                            _6822 = _6819 * _194;
                            _6825 = (abs(_6820) < abs(_6821));
                            _6826 = select(_6825, 1.0f, 0.0f);
                            _6827 = select(_6825, 0.0f, 1.0f);
                            _6828 = _6827 * _6822;
                            _6830 = -0.0f - (_6822 * _6826);
                            _6833 = (_6826 * _6821) - (_6827 * _6820);
                            _6835 = rsqrt(dot(float3(_6828, _6830, _6833), float3(_6828, _6830, _6833)));
                            _6836 = _6828 * _6835;
                            _6837 = _6835 * _6830;
                            _6838 = _6833 * _6835;
                            _6841 = (_6837 * _6822) - (_6838 * _6821);
                            _6844 = (_6838 * _6820) - (_6836 * _6822);
                            _6847 = (_6836 * _6821) - (_6837 * _6820);
                            _6849 = rsqrt(dot(float3(_6841, _6844, _6847), float3(_6841, _6844, _6847)));
                            _6853 = _168 * 4.0f;
                            _6862 = saturate(abs(_6853 + -2.5f) + -0.5f) + -0.5f;
                            _6863 = saturate(1.5f - abs(_6853 + -1.5f)) + -0.5f;
                            _6865 = rsqrt(dot(float2(_6862, _6863), float2(_6862, _6863)));
                            _6866 = _6865 * _6862;
                            _6867 = _6865 * _6863;
                            _6874 = ((_6841 * _6849) * _6866) + (_6867 * _6836);
                            _6875 = ((_6844 * _6849) * _6866) + (_6867 * _6837);
                            _6876 = ((_6847 * _6849) * _6866) + (_6867 * _6838);
                            _6879 = (_6875 * _194) - (_6876 * _193);
                            _6882 = (_6876 * _192) - (_6874 * _194);
                            _6885 = (_6874 * _193) - (_6875 * _192);
                            _6886 = dot(float3(_6874, _6875, _6876), float3(_6677, _6678, _6679));
                            _6887 = dot(float3(_6874, _6875, _6876), float3(_437, _438, _436));
                            _6890 = dot(float3(_6879, _6882, _6885), float3(_6677, _6678, _6679));
                            _6891 = dot(float3(_6879, _6882, _6885), float3(_437, _438, _436));
                            _6897 = min(max((_6753 * (_212 + 1.0f)), 0.0010000000474974513f), 1.0f);
                            _6901 = min(max((_6753 * (1.0f - _212)), 0.0010000000474974513f), 1.0f);
                            _6902 = _6901 * _6897;
                            _6903 = ((_6887 + _6886) * _6745) * _6901;
                            _6904 = ((_6891 + _6890) * _6745) * _6897;
                            _6905 = _6902 * _6748;
                            _6906 = dot(float3(_6903, _6904, _6905), float3(_6903, _6904, _6905));
                            _6911 = _6897 * _6887;
                            _6912 = _6901 * _6891;
                            _6920 = _6897 * _6886;
                            _6921 = _6901 * _6890;
                            _6933 = (((_6902 * _6902) * _6902) / (_6906 * _6906));
                            _6934 = saturate(0.5f / ((sqrt(((_6920 * _6920) + (_6752 * _6752)) + (_6921 * _6921)) * _6777) + (sqrt(((_6912 * _6912) + (_6911 * _6911)) + (_6777 * _6777)) * _6752)));
                          }
                          _6936 = (_6933 * _6752) * _6934;
                          _6951 = saturate((_6741 + 0.5f) * 0.6666666865348816f);
                          _6958 = f16tof32(((uint)((uint)(_6639) >> 16))) * _1637;
                          _6959 = f16tof32(_6639) * _1637;
                          _6960 = f16tof32(((uint)((uint)(_6642) >> 16))) * _1637;
                          _6973 = ((((_6739 * _6958) * (1.0f - _6772)) * _6951) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _6752)) + _1574;
                          _6974 = ((((_6739 * _6959) * (1.0f - _6773)) * _6951) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _6752)) + _1575;
                          _6975 = ((((_6739 * _6960) * (1.0f - _6774)) * _6951) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _6752)) + _1576;
                          if (_6654 > 0.0f) {
                            _6979 = (_6654 * _1339) * select(_6736, (_6732 * _1266), _6732);
                            _9254 = _6973;
                            _9255 = _6974;
                            _9256 = _6975;
                            _9257 = ((((_6979 * _6958) * _6772) * _6936) + _1577);
                            _9258 = ((((_6979 * _6959) * _6773) * _6936) + _1578);
                            _9259 = ((((_6979 * _6960) * _6774) * _6936) + _1579);
                          } else {
                            _9254 = _6973;
                            _9255 = _6974;
                            _9256 = _6975;
                            _9257 = _1577;
                            _9258 = _1578;
                            _9259 = _1579;
                          }
                        } else {
                          _9254 = _1574;
                          _9255 = _1575;
                          _9256 = _1576;
                          _9257 = _1577;
                          _9258 = _1578;
                          _9259 = _1579;
                        }
                      } else {
                        if (_1620 == 9) {
                          _6997 = asfloat(srvLightInfoProperties.Load4(_1588)).x;
                          _6998 = asfloat(srvLightInfoProperties.Load4(_1588)).y;
                          _6999 = asfloat(srvLightInfoProperties.Load4(_1588)).w;
                          _7002 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).x;
                          _7003 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).y;
                          _7004 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).w;
                          _7007 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).x;
                          _7008 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).y;
                          _7009 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).w;
                          _7012 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 48u)))).x;
                          _7013 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 48u)))).y;
                          _7014 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 48u)))).w;
                          _7017 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 64u)))).x;
                          _7018 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 64u)))).y;
                          _7019 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 64u)))).z;
                          _7022 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 76u)))).x;
                          _7023 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 76u)))).y;
                          _7024 = asfloat(srvLightInfoProperties.Load3(((int)(_1588 + 76u)))).z;
                          _7027 = asint(srvLightInfoProperties.Load(((int)(_1588 + 88u))));
                          _7030 = asint(srvLightInfoProperties.Load(((int)(_1588 + 92u))));
                          _7033 = asint(srvLightInfoProperties.Load(((int)(_1588 + 100u))));
                          _7036 = asint(srvLightInfoProperties.Load(((int)(_1588 + 104u))));
                          _7039 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).x;
                          _7040 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).y;
                          _7041 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).z;
                          _7042 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 108u)))).w;
                          _7045 = asint(srvLightInfoProperties.Load(((int)(_1588 + 124u))));
                          _7048 = asint(srvLightInfoProperties.Load(((int)(_1588 + 128u))));
                          _7051 = asint(srvLightInfoProperties.Load(((int)(_1588 + 132u))));
                          _7054 = asint(srvLightInfoProperties.Load(((int)(_1588 + 136u))));
                          _7057 = asint(srvLightInfoProperties.Load(((int)(_1588 + 140u))));
                          _7060 = asint(srvLightInfoProperties.Load(((int)(_1588 + 144u))));
                          _7063 = asint(srvLightInfoProperties.Load(((int)(_1588 + 148u))));
                          _7066 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 152u)))).x;
                          _7067 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 152u)))).y;
                          _7068 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 152u)))).z;
                          _7069 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 152u)))).w;
                          _7072 = asint(srvLightInfoProperties.Load(((int)(_1588 + 168u))));
                          _7075 = asint(srvLightInfoProperties.Load(((int)(_1588 + 172u))));
                          _7078 = asint(srvLightInfoProperties.Load(((int)(_1588 + 180u))));
                          _7080 = f16tof32(((uint)((uint)(_7027) >> 16)));
                          _7081 = f16tof32(_7027);
                          _7083 = f16tof32(((uint)((uint)(_7030) >> 16)));
                          _7087 = ((float)((uint)((uint)(((uint)(_7030) >> 8) & 255)))) * 0.003921499941498041f;
                          _7088 = f16tof32(_7033);
                          _7090 = f16tof32(((uint)((uint)(_7036) >> 16)));
                          _7094 = f16tof32(_7045);
                          _7098 = _7051 & 65535;
                          _7114 = f16tof32(((uint)((uint)(_7075) >> 16)));
                          _7115 = f16tof32(_7075);
                          _7117 = f16tof32(((uint)((uint)(_7078) >> 16)));
                          _7118 = 1.0f / _7117;
                          _7119 = _7117 + -1.0f;
                          _7120 = f16tof32(_7078);
                          _7121 = _7017 - _222;
                          _7122 = _7018 - _223;
                          _7123 = _7019 + _221;
                          _7124 = dot(float3(_7121, _7122, _7123), float3(_7121, _7122, _7123));
                          _7125 = rsqrt(_7124);
                          _7126 = _7125 * _7124;
                          _7127 = _7125 * _7121;
                          _7128 = _7125 * _7122;
                          _7129 = _7125 * _7123;
                          _7132 = max(0.0f, (_7126 - abs(_7094)));
                          _7133 = _7132 * f16tof32(((uint)((uint)(_7045) >> 16)));
                          _7134 = _7133 * _7133;
                          _7137 = saturate(1.0f - (_7134 * _7134));
                          _7148 = mad(_224, _7009, mad(_223, _7004, (_6999 * _222))) + _7014;
                          _7152 = saturate(1.0f - dot(float3(_192, _193, _194), float3(_7127, _7128, _7129))) * f16tof32(_7072);
                          _7159 = ((_7148 * _192) * _7152) + _222;
                          _7160 = ((_7148 * _193) * _7152) + _223;
                          _7161 = ((_7148 * _194) * _7152) - _221;
                          _7173 = mad(_7161, _7009, mad(_7160, _7004, (_7159 * _6999))) + _7014;
                          _7174 = 1.0f / _7173;
                          _7175 = _7174 * (mad(_7161, _7007, mad(_7160, _7002, (_7159 * _6997))) + _7012);
                          _7176 = _7174 * (mad(_7161, _7008, mad(_7160, _7003, (_7159 * _6998))) + _7013);
                          _7179 = (_7175 * _7039) + _7040;
                          _7180 = (_7176 * _7039) + _7040;
                          _7183 = _7179 - saturate(_7179);
                          _7184 = _7180 - saturate(_7180);
                          _7191 = saturate((sqrt((_7183 * _7183) + (_7184 * _7184)) * _7041) + _7042);
                          _7193 = 1.0f - (_7191 * _7191);
                          _7199 = (_7193 * _7193) * (((float)((bool)(uint)((_7173 - f16tof32(((uint)((uint)(_7048) >> 16)))) > 0.0f))) * ((_7137 * _7137) / (select((_7094 < 0.0f), (_7134 * 16.0f), (_7132 * _7132)) + 1.0f)));
                          _7201 = ((_1586 & 3584) == 0);
                          if (!((!(_7199 > 0.0f)) || _7201)) {
                            _7209 = 1.0f - saturate(f16tof32(_7048) * _7173);
                            _7210 = saturate(_7175);
                            _7211 = saturate(_7176);
                            bool __branch_chain_7203;
                            [branch]
                            if ((_1586 & 1024) == 0) {
                              _7474 = 1.0f;
                              _7475 = 0.0f;
                              _7476 = _7209;
                              __branch_chain_7203 = true;
                            } else {
                              _7216 = ((_7210 * _7119) + 0.5f) * _7118;
                              _7218 = ((_7211 * _7119) + 0.5f) * _7118;
                              _7219 = _7209 + f16tof32(((uint)((uint)(_7072) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7051) >> 16))];
                              _7222 = saturate(_7219);
                              _7226 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _7235 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_7226 * 32.665000915527344f) + _125), ((_7226 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _7236 = sin(_7235);
                              _7237 = cos(_7235);
                              _7238 = cbSharedPerViewData.nFrameCounter & 3;
                              _7243 = sqrt((float((int)(_7238)) * 0.25f) + 0.125f) * _7114;
                              _7252 = (_global_7[min((uint)(((int)(0u + (_7238 * 2)))), 127u)]) * _7243;
                              _7253 = (_global_7[min((uint)(((int)(1u + (_7238 * 2)))), 127u)]) * _7243;
                              _7255 = -0.0f - _7236;
                              _7260 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7252, _7253), float2(_7237, _7236)) + _7216), (dot(float2(_7252, _7253), float2(_7255, _7237)) + _7218)));
                              _7265 = _7260.x - _7222;
                              _7267 = select((_7265 < 0.0f), 0.0f, 1.0f);
                              _7269 = _7260.y - _7222;
                              _7271 = select((_7269 < 0.0f), 0.0f, 1.0f);
                              _7275 = _7260.z - _7222;
                              _7277 = select((_7275 < 0.0f), 0.0f, 1.0f);
                              _7281 = _7260.w - _7222;
                              _7283 = select((_7281 < 0.0f), 0.0f, 1.0f);
                              _7290 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _7295 = sqrt((float((int)(_7290)) * 0.25f) + 0.125f) * _7114;
                              _7304 = (_global_7[min((uint)(((int)(0u + (_7290 * 2)))), 127u)]) * _7295;
                              _7305 = (_global_7[min((uint)(((int)(1u + (_7290 * 2)))), 127u)]) * _7295;
                              _7311 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7304, _7305), float2(_7237, _7236)) + _7216), (dot(float2(_7304, _7305), float2(_7255, _7237)) + _7218)));
                              _7316 = _7311.x - _7222;
                              _7318 = select((_7316 < 0.0f), 0.0f, 1.0f);
                              _7322 = _7311.y - _7222;
                              _7324 = select((_7322 < 0.0f), 0.0f, 1.0f);
                              _7328 = _7311.z - _7222;
                              _7330 = select((_7328 < 0.0f), 0.0f, 1.0f);
                              _7334 = _7311.w - _7222;
                              _7336 = select((_7334 < 0.0f), 0.0f, 1.0f);
                              _7343 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _7348 = sqrt((float((int)(_7343)) * 0.25f) + 0.125f) * _7114;
                              _7357 = (_global_7[min((uint)(((int)(0u + (_7343 * 2)))), 127u)]) * _7348;
                              _7358 = (_global_7[min((uint)(((int)(1u + (_7343 * 2)))), 127u)]) * _7348;
                              _7364 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7357, _7358), float2(_7237, _7236)) + _7216), (dot(float2(_7357, _7358), float2(_7255, _7237)) + _7218)));
                              _7369 = _7364.x - _7222;
                              _7371 = select((_7369 < 0.0f), 0.0f, 1.0f);
                              _7375 = _7364.y - _7222;
                              _7377 = select((_7375 < 0.0f), 0.0f, 1.0f);
                              _7381 = _7364.z - _7222;
                              _7383 = select((_7381 < 0.0f), 0.0f, 1.0f);
                              _7387 = _7364.w - _7222;
                              _7389 = select((_7387 < 0.0f), 0.0f, 1.0f);
                              _7396 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _7401 = sqrt((float((int)(_7396)) * 0.25f) + 0.125f) * _7114;
                              _7410 = (_global_7[min((uint)(((int)(0u + (_7396 * 2)))), 127u)]) * _7401;
                              _7411 = (_global_7[min((uint)(((int)(1u + (_7396 * 2)))), 127u)]) * _7401;
                              _7417 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7410, _7411), float2(_7237, _7236)) + _7216), (dot(float2(_7410, _7411), float2(_7255, _7237)) + _7218)));
                              _7422 = _7417.x - _7222;
                              _7424 = select((_7422 < 0.0f), 0.0f, 1.0f);
                              _7428 = _7417.y - _7222;
                              _7430 = select((_7428 < 0.0f), 0.0f, 1.0f);
                              _7434 = _7417.z - _7222;
                              _7436 = select((_7434 < 0.0f), 0.0f, 1.0f);
                              _7440 = _7417.w - _7222;
                              _7442 = select((_7440 < 0.0f), 0.0f, 1.0f);
                              _7443 = ((((((((((((((_7267 + _7271) + _7277) + _7283) + _7318) + _7324) + _7330) + _7336) + _7371) + _7377) + _7383) + _7389) + _7424) + _7430) + _7436) + _7442;
                              _7454 = (saturate(_7443 * 0.0625f) * 2.0f) + -1.0f;
                              _7460 = float((int)(((int)(uint)((int)(_7454 > 0.0f))) - ((int)(uint)((int)(_7454 < 0.0f)))));
                              _7462 = 1.0f - (_7460 * _7454);
                              _7464 = (_7462 * _7462) * _7462;
                              _7471 = 0.5f - ((_7460 * 0.5f) * ((1.0f - _7464) - ((_7462 - _7464) * saturate(((1.0f / _7222) * (1.0f / _7443)) * ((((((((((((((((_7267 * _7265) + (_7271 * _7269)) + (_7277 * _7275)) + (_7283 * _7281)) + (_7318 * _7316)) + (_7324 * _7322)) + (_7330 * _7328)) + (_7336 * _7334)) + (_7371 * _7369)) + (_7377 * _7375)) + (_7383 * _7381)) + (_7389 * _7387)) + (_7424 * _7422)) + (_7430 * _7428)) + (_7436 * _7434)) + (_7442 * _7440))))));
                              [branch]
                              if (_7120 < 1.0f) {
                                _7474 = _7471;
                                _7475 = _7120;
                                _7476 = _7219;
                                __branch_chain_7203 = true;
                              } else {
                                _7944 = _7120;
                                _7945 = _7471;
                                __branch_chain_7203 = false;
                              }
                            }
                            if (__branch_chain_7203) {
                              _7479 = (_7210 * _7066) + _7068;
                              _7480 = (_7211 * _7067) + _7069;
                              if (!((_1586 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _7489 = saturate(_7476);
                                _7493 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _7502 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_7493 * 32.665000915527344f) + _125), ((_7493 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7503 = sin(_7502);
                                _7504 = cos(_7502);
                                _7509 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_7479, _7480), 0.0f))).x) > _7489), 1.0f, 0.0f);
                                _7510 = cbSharedPerViewData.nFrameCounter & 3;
                                _7515 = sqrt((float((int)(_7510)) * 0.25f) + 0.125f) * _7115;
                                _7524 = (_global_7[min((uint)(((int)(0u + (_7510 * 2)))), 127u)]) * _7515;
                                _7525 = (_global_7[min((uint)(((int)(1u + (_7510 * 2)))), 127u)]) * _7515;
                                _7527 = -0.0f - _7503;
                                _7529 = dot(float2(_7524, _7525), float2(_7504, _7503)) + _7479;
                                _7530 = dot(float2(_7524, _7525), float2(_7527, _7504)) + _7480;
                                _7532 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7529, _7530));
                                _7536 = _7529 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7537 = _7530 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7540 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _7068);
                                _7541 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _7069);
                                _7546 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_7066 + _7068)) + 0.5f);
                                _7547 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_7067 + _7069)) + 0.5f);
                                _7550 = floor(_7536 + -0.5f);
                                _7551 = floor(_7537 + 0.5f);
                                _7553 = floor(_7536 + 0.5f);
                                _7555 = floor(_7537 + -0.5f);
                                _7556 = (_7550 < _7540);
                                _7557 = (_7551 < _7541);
                                if ((_7556 || _7557) | ((_7550 >= _7546) || (_7551 >= _7547))) {
                                  _7566 = _7509;
                                } else {
                                  _7566 = _7532.x;
                                }
                                _7567 = (_7553 < _7540);
                                if ((_7567 || _7557) | ((_7553 >= _7546) || (_7551 >= _7547))) {
                                  _7575 = _7509;
                                } else {
                                  _7575 = _7532.y;
                                }
                                _7576 = (_7555 < _7541);
                                if ((_7567 || _7576) | ((_7553 >= _7546) || (_7555 >= _7547))) {
                                  _7584 = _7509;
                                } else {
                                  _7584 = _7532.z;
                                }
                                if ((_7556 || _7576) | ((_7550 >= _7546) || (_7555 >= _7547))) {
                                  _7592 = _7509;
                                } else {
                                  _7592 = _7532.w;
                                }
                                _7593 = _7566 - _7489;
                                _7595 = select((_7593 < 0.0f), 0.0f, 1.0f);
                                _7597 = _7575 - _7489;
                                _7599 = select((_7597 < 0.0f), 0.0f, 1.0f);
                                _7603 = _7584 - _7489;
                                _7605 = select((_7603 < 0.0f), 0.0f, 1.0f);
                                _7609 = _7592 - _7489;
                                _7611 = select((_7609 < 0.0f), 0.0f, 1.0f);
                                _7618 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _7623 = sqrt((float((int)(_7618)) * 0.25f) + 0.125f) * _7115;
                                _7632 = (_global_7[min((uint)(((int)(0u + (_7618 * 2)))), 127u)]) * _7623;
                                _7633 = (_global_7[min((uint)(((int)(1u + (_7618 * 2)))), 127u)]) * _7623;
                                _7636 = dot(float2(_7632, _7633), float2(_7504, _7503)) + _7479;
                                _7637 = dot(float2(_7632, _7633), float2(_7527, _7504)) + _7480;
                                _7639 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7636, _7637));
                                _7643 = _7636 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7644 = _7637 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7647 = floor(_7643 + -0.5f);
                                _7648 = floor(_7644 + 0.5f);
                                _7650 = floor(_7643 + 0.5f);
                                _7652 = floor(_7644 + -0.5f);
                                _7653 = (_7647 < _7540);
                                _7654 = (_7648 < _7541);
                                if ((_7653 || _7654) | ((_7647 >= _7546) || (_7648 >= _7547))) {
                                  _7663 = _7509;
                                } else {
                                  _7663 = _7639.x;
                                }
                                _7664 = (_7650 < _7540);
                                if ((_7664 || _7654) | ((_7650 >= _7546) || (_7648 >= _7547))) {
                                  _7672 = _7509;
                                } else {
                                  _7672 = _7639.y;
                                }
                                _7673 = (_7652 < _7541);
                                if ((_7664 || _7673) | ((_7650 >= _7546) || (_7652 >= _7547))) {
                                  _7681 = _7509;
                                } else {
                                  _7681 = _7639.z;
                                }
                                if ((_7653 || _7673) | ((_7647 >= _7546) || (_7652 >= _7547))) {
                                  _7689 = _7509;
                                } else {
                                  _7689 = _7639.w;
                                }
                                _7690 = _7663 - _7489;
                                _7692 = select((_7690 < 0.0f), 0.0f, 1.0f);
                                _7696 = _7672 - _7489;
                                _7698 = select((_7696 < 0.0f), 0.0f, 1.0f);
                                _7702 = _7681 - _7489;
                                _7704 = select((_7702 < 0.0f), 0.0f, 1.0f);
                                _7708 = _7689 - _7489;
                                _7710 = select((_7708 < 0.0f), 0.0f, 1.0f);
                                _7717 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _7722 = sqrt((float((int)(_7717)) * 0.25f) + 0.125f) * _7115;
                                _7731 = (_global_7[min((uint)(((int)(0u + (_7717 * 2)))), 127u)]) * _7722;
                                _7732 = (_global_7[min((uint)(((int)(1u + (_7717 * 2)))), 127u)]) * _7722;
                                _7735 = dot(float2(_7731, _7732), float2(_7504, _7503)) + _7479;
                                _7736 = dot(float2(_7731, _7732), float2(_7527, _7504)) + _7480;
                                _7738 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7735, _7736));
                                _7742 = _7735 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7743 = _7736 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7746 = floor(_7742 + -0.5f);
                                _7747 = floor(_7743 + 0.5f);
                                _7749 = floor(_7742 + 0.5f);
                                _7751 = floor(_7743 + -0.5f);
                                _7752 = (_7746 < _7540);
                                _7753 = (_7747 < _7541);
                                if ((_7752 || _7753) | ((_7746 >= _7546) || (_7747 >= _7547))) {
                                  _7762 = _7509;
                                } else {
                                  _7762 = _7738.x;
                                }
                                _7763 = (_7749 < _7540);
                                if ((_7763 || _7753) | ((_7749 >= _7546) || (_7747 >= _7547))) {
                                  _7771 = _7509;
                                } else {
                                  _7771 = _7738.y;
                                }
                                _7772 = (_7751 < _7541);
                                if ((_7763 || _7772) | ((_7749 >= _7546) || (_7751 >= _7547))) {
                                  _7780 = _7509;
                                } else {
                                  _7780 = _7738.z;
                                }
                                if ((_7752 || _7772) | ((_7746 >= _7546) || (_7751 >= _7547))) {
                                  _7788 = _7509;
                                } else {
                                  _7788 = _7738.w;
                                }
                                _7789 = _7762 - _7489;
                                _7791 = select((_7789 < 0.0f), 0.0f, 1.0f);
                                _7795 = _7771 - _7489;
                                _7797 = select((_7795 < 0.0f), 0.0f, 1.0f);
                                _7801 = _7780 - _7489;
                                _7803 = select((_7801 < 0.0f), 0.0f, 1.0f);
                                _7807 = _7788 - _7489;
                                _7809 = select((_7807 < 0.0f), 0.0f, 1.0f);
                                _7816 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _7821 = sqrt((float((int)(_7816)) * 0.25f) + 0.125f) * _7115;
                                _7830 = (_global_7[min((uint)(((int)(0u + (_7816 * 2)))), 127u)]) * _7821;
                                _7831 = (_global_7[min((uint)(((int)(1u + (_7816 * 2)))), 127u)]) * _7821;
                                _7834 = dot(float2(_7830, _7831), float2(_7504, _7503)) + _7479;
                                _7835 = dot(float2(_7830, _7831), float2(_7527, _7504)) + _7480;
                                _7837 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7834, _7835));
                                _7841 = _7834 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7842 = _7835 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7845 = floor(_7841 + -0.5f);
                                _7846 = floor(_7842 + 0.5f);
                                _7848 = floor(_7841 + 0.5f);
                                _7850 = floor(_7842 + -0.5f);
                                _7851 = (_7845 < _7540);
                                _7852 = (_7846 < _7541);
                                if ((_7851 || _7852) | ((_7845 >= _7546) || (_7846 >= _7547))) {
                                  _7861 = _7509;
                                } else {
                                  _7861 = _7837.x;
                                }
                                _7862 = (_7848 < _7540);
                                if ((_7862 || _7852) | ((_7848 >= _7546) || (_7846 >= _7547))) {
                                  _7870 = _7509;
                                } else {
                                  _7870 = _7837.y;
                                }
                                _7871 = (_7850 < _7541);
                                if ((_7862 || _7871) | ((_7848 >= _7546) || (_7850 >= _7547))) {
                                  _7879 = _7509;
                                } else {
                                  _7879 = _7837.z;
                                }
                                if ((_7851 || _7871) | ((_7845 >= _7546) || (_7850 >= _7547))) {
                                  _7887 = _7509;
                                } else {
                                  _7887 = _7837.w;
                                }
                                _7888 = _7861 - _7489;
                                _7890 = select((_7888 < 0.0f), 0.0f, 1.0f);
                                _7894 = _7870 - _7489;
                                _7896 = select((_7894 < 0.0f), 0.0f, 1.0f);
                                _7900 = _7879 - _7489;
                                _7902 = select((_7900 < 0.0f), 0.0f, 1.0f);
                                _7906 = _7887 - _7489;
                                _7908 = select((_7906 < 0.0f), 0.0f, 1.0f);
                                _7909 = ((((((((((((((_7599 + _7595) + _7605) + _7611) + _7692) + _7698) + _7704) + _7710) + _7791) + _7797) + _7803) + _7809) + _7890) + _7896) + _7902) + _7908;
                                _7920 = (saturate(_7909 * 0.0625f) * 2.0f) + -1.0f;
                                _7926 = float((int)(((int)(uint)((int)(_7920 > 0.0f))) - ((int)(uint)((int)(_7920 < 0.0f)))));
                                _7928 = 1.0f - (_7926 * _7920);
                                _7930 = (_7928 * _7928) * _7928;
                                _7939 = (0.5f - ((_7926 * 0.5f) * ((1.0f - _7930) - ((_7928 - _7930) * saturate(((1.0f / _7489) * (1.0f / _7909)) * ((((((((((((((((_7599 * _7597) + (_7595 * _7593)) + (_7605 * _7603)) + (_7611 * _7609)) + (_7692 * _7690)) + (_7698 * _7696)) + (_7704 * _7702)) + (_7710 * _7708)) + (_7791 * _7789)) + (_7797 * _7795)) + (_7803 * _7801)) + (_7809 * _7807)) + (_7890 * _7888)) + (_7896 * _7894)) + (_7902 * _7900)) + (_7908 * _7906)))))));
                              } else {
                                _7939 = 1.0f;
                              }
                              _7944 = _7475;
                              _7945 = (lerp(_7939, _7474, _7475));
                            }
                            [branch]
                            if (!((_1586 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7054) >> 16))];
                              _7951 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_7175, _7176), 0.0f);
                              if (_7951.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_7054 & 65535))];
                                _7958 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_7175, _7176), 0.0f);
                                _7972 = mad(saturate(((log2(_7126) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _7973 = max(9.999999747378752e-06f, _7951.x);
                                _7974 = _7958.x / _7973;
                                _7975 = _7958.y / _7973;
                                _7977 = _7958.w / _7973;
                                _7982 = ((0.375f - _7975) * 4.999999873689376e-06f) + _7975;
                                _7985 = -0.0f - _7974;
                                _7986 = mad(_7985, _7982, (_7958.z / _7973));
                                _7988 = 1.0f / mad(_7985, _7974, _7982);
                                _7989 = _7988 * _7986;
                                _7994 = _7972 - _7974;
                                _7999 = (((_7972 * _7972) - _7982) - (_7989 * _7994)) / mad((-0.0f - _7986), _7989, mad((-0.0f - _7982), _7982, (((0.375f - _7977) * 4.999999873689376e-06f) + _7977)));
                                _8001 = (_7988 * _7994) - (_7999 * _7989);
                                _8004 = 1.0f / _7999;
                                _8005 = _8001 * _8004;
                                _8010 = sqrt(((_8005 * _8005) * 0.25f) - ((1.0f - dot(float2(_8001, _7999), float2(_7974, _7982))) * _8004));
                                _8012 = (_8005 * -0.5f) - _8010;
                                _8014 = _8010 - (_8005 * 0.5f);
                                _8016 = select((_8012 < _7972), 1.0f, 0.0f);
                                _8021 = (_8016 + -0.05000000074505806f) / (_8012 - _7972);
                                _8027 = (((select((_8014 < _7972), 1.0f, 0.0f) - _8016) / (_8014 - _8012)) - _8021) / (_8014 - _7972);
                                _8029 = _8021 - (_8027 * _8012);
                                _8042 = _7944;
                                _8043 = (exp2((_7951.x * -1.4426950216293335f) * saturate((dot(float2(_7974, _7982), float2((_8029 - (_8027 * _7972)), _8027)) + 0.05000000074505806f) - (_8029 * _7972))) * _7945);
                              } else {
                                _8042 = _7944;
                                _8043 = _7945;
                              }
                            } else {
                              _8042 = _7944;
                              _8043 = _7945;
                            }
                          } else {
                            _8042 = 0.0f;
                            _8043 = 1.0f;
                          }
                          [branch]
                          if (!(_7098 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _7098)))];
                            _8056 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_7175 * f16tof32(((uint)((uint)(_7060) >> 16)))) + f16tof32(((uint)((uint)(_7063) >> 16)))), ((_7176 * f16tof32(_7060)) + f16tof32(_7063))), 0.0f);
                            _8064 = (_8056.x * _7080);
                            _8065 = (_8056.y * _7081);
                            _8066 = (_8056.z * _7083);
                          } else {
                            _8064 = _7080;
                            _8065 = _7081;
                            _8066 = _7083;
                          }
                          _8067 = _8043 * _7199;
                          [branch]
                          if (!(_8067 == 0.0f)) {
                            bool __branch_chain_8069;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _8085 = 0;
                              __branch_chain_8069 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _8085 = 1;
                                __branch_chain_8069 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _8085 = 2;
                                  __branch_chain_8069 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1589) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _8085 = 3;
                                    __branch_chain_8069 = true;
                                  } else {
                                    _8110 = _8067;
                                    __branch_chain_8069 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_8069) {
                              while(true) {
                                _8088 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                if (_8085 == 0) {
                                  _8102 = _8088.x;
                                } else {
                                  if (_8085 == 1) {
                                    _8102 = _8088.y;
                                  } else {
                                    if (_8085 == 2) {
                                      _8102 = _8088.z;
                                    } else {
                                      _8102 = _8088.w;
                                    }
                                  }
                                }
                                _8110 = ((((_8042 * _8042) * ((_8102 * _8102) + -1.0f)) + 1.0f) * _7199);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_8110 > 0.0f) {
                                if (!(((_7057 & 1) == 0) || _7201)) {
                                  _8126 = max(max(_8064, _8065), _8066);
                                  if (_8126 > 0.0f) {
                                    _8136 = saturate(_8064 / _8126);
                                    _8137 = saturate(_8065 / _8126);
                                    _8138 = saturate(_8066 / _8126);
                                  } else {
                                    _8136 = _8064;
                                    _8137 = _8065;
                                    _8138 = _8066;
                                  }
                                  _8139 = (_8137 < _8138);
                                  _8140 = select(_8139, _8138, _8137);
                                  _8141 = select(_8139, _8137, _8138);
                                  _8142 = select(_8139, -1.0f, 0.0f);
                                  _8143 = (_8136 < _8140);
                                  _8145 = select(_8143, _8140, _8136);
                                  _8146 = select(_8143, _8136, _8140);
                                  _8150 = _8145 - select((_8146 < _8141), _8146, _8141);
                                  _8156 = abs(select(_8143, (-0.3333333432674408f - _8142), _8142) + ((_8146 - _8141) / ((_8150 * 6.0f) + 9.999999682655225e-21f)));
                                  if (_8156 < 0.6666666865348816f) {
                                    _8169 = ((saturate(((float)((uint)((uint)(((uint)(_7057) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8156 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8156)) + _8156);
                                  } else {
                                    _8169 = _8156;
                                  }
                                  _8170 = saturate((_8150 / (_8145 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7057) >> 1) & 255)))) * 0.003921499941498041f));
                                  _8171 = saturate(_8145);
                                  if (!(_8170 <= 0.0f)) {
                                    _8174 = saturate(_8169);
                                    _8178 = select(((_8174 * 360.0f) >= 360.0f), 0.0f, (_8174 * 6.0f));
                                    _8179 = int(_8178);
                                    _8181 = _8178 - float((int)(_8179));
                                    _8183 = _8171 * (1.0f - _8170);
                                    _8186 = (1.0f - (_8181 * _8170)) * _8171;
                                    _8190 = (1.0f - ((1.0f - _8181) * _8170)) * _8171;
                                    switch (_8179) {
                                      case 0: {
                                        _8198 = _8171;
                                        _8199 = _8190;
                                        _8200 = _8183;
                                        break;
                                      }
                                      case 1: {
                                        _8198 = _8186;
                                        _8199 = _8171;
                                        _8200 = _8183;
                                        break;
                                      }
                                      case 2: {
                                        _8198 = _8183;
                                        _8199 = _8171;
                                        _8200 = _8190;
                                        break;
                                      }
                                      case 3: {
                                        _8198 = _8183;
                                        _8199 = _8186;
                                        _8200 = _8171;
                                        break;
                                      }
                                      case 4: {
                                        _8198 = _8190;
                                        _8199 = _8183;
                                        _8200 = _8171;
                                        break;
                                      }
                                      case 5: {
                                        _8198 = _8171;
                                        _8199 = _8183;
                                        _8200 = _8186;
                                        break;
                                      }
                                      default: {
                                        _8198 = 0.0f;
                                        _8199 = 0.0f;
                                        _8200 = 0.0f;
                                        break;
                                      }
                                    }
                                  } else {
                                    _8198 = _8171;
                                    _8199 = _8171;
                                    _8200 = _8171;
                                  }
                                  _8201 = _8198 * _8126;
                                  _8202 = _8199 * _8126;
                                  _8203 = _8200 * _8126;
                                  _8205 = saturate(_8043 * 1.0101009607315063f);
                                  _8216 = ((_8205 * (_8064 - _8201)) + _8201);
                                  _8217 = ((_8205 * (_8065 - _8202)) + _8202);
                                  _8218 = (lerp(_8203, _8066, _8205));
                                } else {
                                  _8216 = _8064;
                                  _8217 = _8065;
                                  _8218 = _8066;
                                }
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _8225 = srvLightMappingData[_1589];
                                  if (!(_8225 == -1)) {
                                    _8230 = srvLightIndexData[_8225].nLayerIndex;
                                    _8232 = srvLightIndexData[_8225].vAtlasOrigin.x;
                                    _8233 = srvLightIndexData[_8225].vAtlasOrigin.y;
                                    _8235 = srvLightIndexData[_8225].vScreenOrigin.x;
                                    _8236 = srvLightIndexData[_8225].vScreenOrigin.y;
                                    _8245 = ((int)(_8230 * 5)) & 31;
                                    _8254 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8232 + _63) - _8235)), ((int)((_8233 + _64) - _8236)), 0)))).x) & ((int)(31 << _8245)))) >> _8245)) >> 1)))) * 0.06666667014360428f) * _8110);
                                  } else {
                                    _8254 = _8110;
                                  }
                                } else {
                                  _8254 = _8110;
                                }
                                _8258 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _8261 = select(_8258, (_8254 * _1266), _8254);
                                _8263 = _7127 * _7126;
                                _8264 = _7128 * _7126;
                                _8265 = _7129 * _7126;
                                _8266 = _7088 * _7022;
                                _8267 = _7088 * _7023;
                                _8268 = _7088 * _7024;
                                _8269 = _8263 + _8266;
                                _8270 = _8264 + _8267;
                                _8271 = _8265 + _8268;
                                _8272 = _8263 - _8266;
                                _8273 = _8264 - _8267;
                                _8274 = _8265 - _8268;
                                _8275 = (_7088 > 0.0f);
                                _8276 = dot(float3(_8269, _8270, _8271), float3(_8269, _8270, _8271));
                                _8277 = rsqrt(_8276);
                                [branch]
                                if (_8275) {
                                  _8280 = rsqrt(dot(float3(_8272, _8273, _8274), float3(_8272, _8273, _8274)));
                                  _8281 = _8280 * _8277;
                                  _8283 = dot(float3(_8269, _8270, _8271), float3(_8272, _8273, _8274)) * _8281;
                                  _8302 = (_8281 / ((_8281 + 0.5f) + (_8283 * 0.5f)));
                                  _8303 = (((dot(float3(_192, _193, _194), float3(_8272, _8273, _8274)) * _8280) + (dot(float3(_192, _193, _194), float3(_8269, _8270, _8271)) * _8277)) * 0.5f);
                                  _8304 = _8283;
                                } else {
                                  _8302 = (1.0f / (_8276 + 1.0f));
                                  _8303 = dot(float3(_192, _193, _194), float3((_8277 * _8269), (_8277 * _8270), (_8277 * _8271)));
                                  _8304 = 1.0f;
                                }
                                if (_7090 > 0.0f) {
                                  _8310 = sqrt(saturate((_7090 * _7090) * _8302));
                                  if (_8303 < _8310) {
                                    _8315 = max(_8303, (-0.0f - _8310)) + _8310;
                                    _8320 = ((_8315 * _8315) / (_8310 * 4.0f));
                                  } else {
                                    _8320 = _8303;
                                  }
                                } else {
                                  _8320 = _8303;
                                }
                                if (_8275) {
                                  _8322 = -0.0f - _437;
                                  _8323 = -0.0f - _438;
                                  _8324 = -0.0f - _436;
                                  _8326 = dot(float3(_8322, _8323, _8324), float3(_192, _193, _194)) * 2.0f;
                                  _8330 = _8322 - (_8326 * _192);
                                  _8331 = _8323 - (_8326 * _193);
                                  _8332 = _8324 - (_8326 * _194);
                                  _8333 = _8272 - _8269;
                                  _8334 = _8273 - _8270;
                                  _8335 = _8274 - _8271;
                                  _8336 = dot(float3(_8330, _8331, _8332), float3(_8333, _8334, _8335));
                                  _8342 = sqrt(((_8333 * _8333) + (_8334 * _8334)) + (_8335 * _8335));
                                  _8351 = saturate(((dot(float3(_8330, _8331, _8332), float3(_8269, _8270, _8271)) * _8336) - dot(float3(_8269, _8270, _8271), float3(_8333, _8334, _8335))) / ((_8342 * _8342) - (_8336 * _8336)));
                                  _8355 = (_8351 * _8333) + _8269;
                                  _8356 = (_8351 * _8334) + _8270;
                                  _8357 = (_8351 * _8335) + _8271;
                                  _8358 = dot(float3(_8355, _8356, _8357), float3(_8330, _8331, _8332));
                                  _8362 = (_8358 * _8330) - _8355;
                                  _8363 = (_8358 * _8331) - _8356;
                                  _8364 = (_8358 * _8332) - _8357;
                                  _8372 = saturate(0.009999999776482582f / sqrt(((_8362 * _8362) + (_8363 * _8363)) + (_8364 * _8364)));
                                  _8380 = ((_8372 * _8362) + _8355);
                                  _8381 = ((_8372 * _8363) + _8356);
                                  _8382 = ((_8372 * _8364) + _8357);
                                } else {
                                  _8380 = _8269;
                                  _8381 = _8270;
                                  _8382 = _8271;
                                }
                                _8384 = rsqrt(dot(float3(_8380, _8381, _8382), float3(_8380, _8381, _8382)));
                                _8385 = _8384 * _8380;
                                _8386 = _8384 * _8381;
                                _8387 = _8384 * _8382;
                                _8388 = _214 * _214;
                                _8392 = saturate((_7090 * (1.0f - _8388)) * _8384);
                                _8394 = saturate(_8384 * f16tof32(_7036));
                                _8396 = rsqrt(dot(float3(_8263, _8264, _8265), float3(_8263, _8264, _8265)));
                                _8397 = _8396 * _8263;
                                _8398 = _8396 * _8264;
                                _8399 = _8396 * _8265;
                                _8400 = dot(float3(_192, _193, _194), float3(_8385, _8386, _8387));
                                _8401 = dot(float3(_437, _438, _436), float3(_8385, _8386, _8387));
                                _8404 = rsqrt((_8401 * 2.0f) + 2.0f);
                                _8411 = (_8392 > 0.0f);
                                if (_8411) {
                                  _8415 = sqrt(1.0f - (_8392 * _8392));
                                  _8417 = (_8400 * 2.0f) * _1123;
                                  _8418 = _8417 - _8401;
                                  if (!(_8418 >= _8415)) {
                                    _8426 = rsqrt(1.0f - (_8418 * _8418)) * _8392;
                                    _8429 = _8426 * (_1123 - (_8418 * _8400));
                                    _8430 = _1123 * _1123;
                                    _8435 = _8426 * (((_8430 * 2.0f) + -1.0f) - (_8418 * _8401));
                                    _8444 = sqrt(saturate((((1.0f - (_8400 * _8400)) - _8430) - (_8401 * _8401)) + (_8417 * _8401)));
                                    _8445 = _8444 * _8426;
                                    _8448 = ((_1123 * 2.0f) * _8426) * _8444;
                                    _8450 = (_8415 * _8400) + _1123;
                                    _8451 = _8450 + _8429;
                                    _8452 = _8415 * _8401;
                                    _8454 = (_8452 + 1.0f) + _8435;
                                    _8455 = _8445 * _8454;
                                    _8456 = _8451 * _8454;
                                    _8457 = _8448 * _8451;
                                    _8462 = (((_8451 * 0.25f) * _8448) - (_8455 * 0.5f)) * _8456;
                                    _8476 = (((_8457 - (_8455 * 2.0f)) * _8457) + (_8455 * _8455)) + ((((-0.5f - ((_8454 + _8452) * 0.5f)) * _8456) + ((_8454 * _8454) * _8450)) * _8451);
                                    _8481 = (_8462 * 2.0f) / ((_8476 * _8476) + (_8462 * _8462));
                                    _8482 = _8476 * _8481;
                                    _8484 = 1.0f - (_8462 * _8481);
                                    _8490 = ((_8482 * _8448) + _8452) + (_8484 * _8435);
                                    _8493 = rsqrt((_8490 * 2.0f) + 2.0f);
                                    _8502 = saturate((_8490 * _8493) + _8493);
                                    _8503 = saturate(((_8450 + (_8482 * _8445)) + (_8484 * _8429)) * _8493);
                                  } else {
                                    _8502 = abs(_1123);
                                    _8503 = 1.0f;
                                  }
                                } else {
                                  _8502 = saturate((_8404 * _8401) + _8404);
                                  _8503 = saturate(_8404 * (_1123 + _8400));
                                }
                                _8504 = saturate(_8320);
                                _8505 = dot(float3(_192, _193, _194), float3(_8397, _8398, _8399));
                                _8506 = saturate(_8505);
                                _8507 = _8388 * _8388;
                                if (_8394 > 0.0f) {
                                  _8517 = saturate(((_8394 * _8394) / ((_8502 * 3.5999999046325684f) + 0.4000000059604645f)) + _8507);
                                } else {
                                  _8517 = _8507;
                                }
                                if (_8411) {
                                  _8526 = (((_8392 * 0.25f) * ((sqrt(_8517) * 3.0f) + _8392)) / (_8502 + 0.0010000000474974513f)) + _8517;
                                  _8529 = _8526;
                                  _8530 = (_8517 / _8526);
                                } else {
                                  _8529 = _8517;
                                  _8530 = 1.0f;
                                }
                                if (_8304 < 1.0f) {
                                  _8537 = sqrt((1.000100016593933f - _8304) / max(9.999999974752427e-07f, (_8304 + 1.0f)));
                                  _8550 = (sqrt(_8529 / ((((_8537 * 0.25f) * ((sqrt(_8529) * 3.0f) + _8537)) / (_8502 + 0.0010000000474974513f)) + _8529)) * _8530);
                                } else {
                                  _8550 = _8530;
                                }
                                _8554 = (((_8517 * _8503) - _8503) * _8503) + 1.0f;
                                _8557 = (_8517 / (_8554 * _8554)) * _8550;
                                _8565 = exp2(log2(1.0f - saturate(_8502)) * 5.0f);
                                _8569 = (_8565 * (1.0f - _207)) + _207;
                                _8570 = (_8565 * (1.0f - _208)) + _208;
                                _8571 = (_8565 * (1.0f - _209)) + _209;
                                _8574 = saturate(abs(_1123) + 9.999999747378752e-06f);
                                _8575 = sqrt(_8517);
                                _8576 = 1.0f - _8575;
                                _8584 = 0.5f / ((((_8576 * _8574) + _8575) * _8504) + (((_8576 * _8504) + _8575) * _8574));
                                if (_212 < 0.007874015718698502f) {
                                  _8590 = _8503 * _8503;
                                  _8592 = max((1.0f - _8590), 9.999999747378752e-05f);
                                  _8737 = (((((((exp2(((-0.0f - (_8590 / _8592)) / _8517) * 1.4426950216293335f) * 4.0f) / (_8592 * _8592)) + 1.0f) * (1.0f / ((_8517 * 4.0f) + 1.0f))) - _8557) * _168) + _8557);
                                  _8738 = (((saturate(0.25f / ((_8506 + _1124) - (_8506 * _1124))) - _8584) * _168) + _8584);
                                } else {
                                  _8616 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
                                  _8617 = _8616 * _192;
                                  _8618 = _8616 * _193;
                                  _8619 = _8616 * _194;
                                  _8622 = (abs(_8617) < abs(_8618));
                                  _8623 = select(_8622, 1.0f, 0.0f);
                                  _8624 = select(_8622, 0.0f, 1.0f);
                                  _8625 = _8624 * _8619;
                                  _8627 = -0.0f - (_8619 * _8623);
                                  _8630 = (_8623 * _8618) - (_8624 * _8617);
                                  _8632 = rsqrt(dot(float3(_8625, _8627, _8630), float3(_8625, _8627, _8630)));
                                  _8633 = _8625 * _8632;
                                  _8634 = _8632 * _8627;
                                  _8635 = _8630 * _8632;
                                  _8638 = (_8634 * _8619) - (_8635 * _8618);
                                  _8641 = (_8635 * _8617) - (_8633 * _8619);
                                  _8644 = (_8633 * _8618) - (_8634 * _8617);
                                  _8646 = rsqrt(dot(float3(_8638, _8641, _8644), float3(_8638, _8641, _8644)));
                                  _8650 = _168 * 4.0f;
                                  _8659 = saturate(abs(_8650 + -2.5f) + -0.5f) + -0.5f;
                                  _8660 = saturate(1.5f - abs(_8650 + -1.5f)) + -0.5f;
                                  _8662 = rsqrt(dot(float2(_8659, _8660), float2(_8659, _8660)));
                                  _8663 = _8662 * _8659;
                                  _8664 = _8662 * _8660;
                                  _8671 = ((_8638 * _8646) * _8663) + (_8664 * _8633);
                                  _8672 = ((_8641 * _8646) * _8663) + (_8664 * _8634);
                                  _8673 = ((_8644 * _8646) * _8663) + (_8664 * _8635);
                                  _8676 = (_8672 * _194) - (_8673 * _193);
                                  _8679 = (_8673 * _192) - (_8671 * _194);
                                  _8682 = (_8671 * _193) - (_8672 * _192);
                                  _8686 = rsqrt((dot(float3(_437, _438, _436), float3(_8397, _8398, _8399)) * 2.0f) + 2.0f);
                                  _8690 = dot(float3(_8671, _8672, _8673), float3(_8397, _8398, _8399));
                                  _8691 = dot(float3(_8671, _8672, _8673), float3(_437, _438, _436));
                                  _8694 = dot(float3(_8676, _8679, _8682), float3(_8397, _8398, _8399));
                                  _8695 = dot(float3(_8676, _8679, _8682), float3(_437, _438, _436));
                                  _8701 = min(max((_8388 * (_212 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                  _8705 = min(max((_8388 * (1.0f - _212)), 0.0010000000474974513f), 1.0f);
                                  _8706 = _8705 * _8701;
                                  _8707 = ((_8691 + _8690) * _8686) * _8705;
                                  _8708 = ((_8695 + _8694) * _8686) * _8701;
                                  _8709 = _8706 * saturate(_8686 * (_1123 + _8505));
                                  _8710 = dot(float3(_8707, _8708, _8709), float3(_8707, _8708, _8709));
                                  _8715 = _8701 * _8691;
                                  _8716 = _8705 * _8695;
                                  _8724 = _8701 * _8690;
                                  _8725 = _8705 * _8694;
                                  _8737 = (((_8706 * _8706) * _8706) / (_8710 * _8710));
                                  _8738 = saturate(0.5f / ((sqrt(((_8724 * _8724) + (_8506 * _8506)) + (_8725 * _8725)) * _8574) + (sqrt(((_8716 * _8716) + (_8715 * _8715)) + (_8574 * _8574)) * _8506)));
                                }
                                _8740 = (_8737 * _8506) * _8738;
                                _8755 = saturate((_8505 + 0.5f) * 0.6666666865348816f);
                                _8762 = _8216 * _1637;
                                _8763 = _8217 * _1637;
                                _8764 = _8218 * _1637;
                                _8777 = ((((_8261 * _8762) * (1.0f - _8569)) * _8755) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _8506)) + _1574;
                                _8778 = ((((_8261 * _8763) * (1.0f - _8570)) * _8755) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _8506)) + _1575;
                                _8779 = ((((_8261 * _8764) * (1.0f - _8571)) * _8755) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _8506)) + _1576;
                                if (_7087 > 0.0f) {
                                  _8783 = (_7087 * _1339) * select(_8258, (_8254 * _1266), _8254);
                                  _9254 = _8777;
                                  _9255 = _8778;
                                  _9256 = _8779;
                                  _9257 = ((((_8783 * _8762) * _8569) * _8740) + _1577);
                                  _9258 = ((((_8783 * _8763) * _8570) * _8740) + _1578);
                                  _9259 = ((((_8783 * _8764) * _8571) * _8740) + _1579);
                                } else {
                                  _9254 = _8777;
                                  _9255 = _8778;
                                  _9256 = _8779;
                                  _9257 = _1577;
                                  _9258 = _1578;
                                  _9259 = _1579;
                                }
                              } else {
                                _9254 = _1574;
                                _9255 = _1575;
                                _9256 = _1576;
                                _9257 = _1577;
                                _9258 = _1578;
                                _9259 = _1579;
                              }
                              break;
                            }
                          } else {
                            _9254 = _1574;
                            _9255 = _1575;
                            _9256 = _1576;
                            _9257 = _1577;
                            _9258 = _1578;
                            _9259 = _1579;
                          }
                        } else {
                          if (_1620 == 10) {
                            _8801 = asfloat(srvLightInfoProperties.Load4(_1588)).x;
                            _8802 = asfloat(srvLightInfoProperties.Load4(_1588)).y;
                            _8803 = asfloat(srvLightInfoProperties.Load4(_1588)).z;
                            _8804 = asfloat(srvLightInfoProperties.Load4(_1588)).w;
                            _8807 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).x;
                            _8808 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).y;
                            _8809 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).z;
                            _8810 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 16u)))).w;
                            _8813 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).x;
                            _8814 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).y;
                            _8815 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).z;
                            _8816 = asfloat(srvLightInfoProperties.Load4(((int)(_1588 + 32u)))).w;
                            _8819 = asfloat(srvLightInfoProperties.Load2(((int)(_1588 + 72u)))).x;
                            _8820 = asfloat(srvLightInfoProperties.Load2(((int)(_1588 + 72u)))).y;
                            _8823 = asint(srvLightInfoProperties.Load(((int)(_1588 + 80u))));
                            _8826 = asint(srvLightInfoProperties.Load(((int)(_1588 + 84u))));
                            _8829 = asint(srvLightInfoProperties.Load(((int)(_1588 + 88u))));
                            _8832 = asint(srvLightInfoProperties.Load(((int)(_1588 + 96u))));
                            _8835 = f16tof32(_8823);
                            _8837 = f16tof32(((uint)((uint)(_8826) >> 16)));
                            _8838 = f16tof32(_8826);
                            _8840 = f16tof32(((uint)((uint)(_8829) >> 16)));
                            _8844 = ((float)((uint)((uint)(((uint)(_8829) >> 8) & 255)))) * 0.003921499941498041f;
                            _8846 = (float)((uint)((uint)(_8832 & 65535)));
                            _8850 = mad(_8803, _224, mad(_8802, _223, (_8801 * _222))) + _8804;
                            _8854 = mad(_8809, _224, mad(_8808, _223, (_8807 * _222))) + _8810;
                            _8858 = mad(_8815, _224, mad(_8814, _223, (_8813 * _222))) + _8816;
                            _8861 = mad(_8803, _194, mad(_8802, _193, (_8801 * _192)));
                            _8864 = mad(_8809, _194, mad(_8808, _193, (_8807 * _192)));
                            _8867 = mad(_8815, _194, mad(_8814, _193, (_8813 * _192)));
                            _8879 = -0.0f - mad(_8815, _436, mad(_8814, _438, (_8813 * _437)));
                            _8880 = _8819 * 0.5f;
                            _8881 = _8820 * 0.5f;
                            _8882 = -0.0f - _8880;
                            _8883 = -0.0f - _8881;
                            _8884 = _8882 - _8850;
                            _8885 = _8883 - _8854;
                            _8886 = -0.0f - _8858;
                            _8887 = _8880 - _8850;
                            _8888 = _8881 - _8854;
                            _8889 = dot(float3(_8850, _8854, _8858), float3(_8861, _8864, _8867));
                            _8891 = dot(float3(_8882, _8883, 0.0f), float3(_8861, _8864, _8867)) - _8889;
                            _8893 = dot(float3(_8880, _8883, 0.0f), float3(_8861, _8864, _8867)) - _8889;
                            _8895 = dot(float3(_8880, _8881, 0.0f), float3(_8861, _8864, _8867)) - _8889;
                            _8897 = dot(float3(_8882, _8881, 0.0f), float3(_8861, _8864, _8867)) - _8889;
                            _8898 = min(_8891, _8893);
                            [branch]
                            if (!(!(_8898 >= 0.0f))) {
                              _8904 = rsqrt(dot(float3(_8887, _8885, _8886), float3(_8887, _8885, _8886)) * dot(float3(_8884, _8885, _8886), float3(_8884, _8885, _8886)));
                              _8906 = dot(float3(_8884, _8885, _8886), float3(_8887, _8885, _8886)) * _8904;
                              _8913 = rsqrt(max(((((_8906 * 0.09300000220537186f) + 0.5f) * _8906) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8904;
                              _8920 = (_8913 * (_8819 * _8886));
                              _8921 = (_8913 * (_8885 * (_8882 - _8880)));
                            } else {
                              _8920 = 0.0f;
                              _8921 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_8893, _8895) >= 0.0f))) {
                              _8928 = rsqrt(dot(float3(_8887, _8888, _8886), float3(_8887, _8888, _8886)) * dot(float3(_8887, _8885, _8886), float3(_8887, _8885, _8886)));
                              _8930 = dot(float3(_8887, _8885, _8886), float3(_8887, _8888, _8886)) * _8928;
                              _8937 = rsqrt(max(((((_8930 * 0.09300000220537186f) + 0.5f) * _8930) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8928;
                              _8945 = (_8937 * ((_8883 - _8881) * _8886));
                              _8946 = ((_8937 * (_8820 * _8887)) + _8921);
                            } else {
                              _8945 = 0.0f;
                              _8946 = _8921;
                            }
                            _8947 = min(_8895, _8897);
                            [branch]
                            if (!(!(_8947 >= 0.0f))) {
                              _8953 = rsqrt(dot(float3(_8884, _8888, _8886), float3(_8884, _8888, _8886)) * dot(float3(_8887, _8888, _8886), float3(_8887, _8888, _8886)));
                              _8955 = dot(float3(_8887, _8888, _8886), float3(_8884, _8888, _8886)) * _8953;
                              _8962 = rsqrt(max(((((_8955 * 0.09300000220537186f) + 0.5f) * _8955) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8953;
                              _8971 = ((_8962 * ((_8882 - _8880) * _8886)) + _8920);
                              _8972 = ((_8962 * (_8819 * _8888)) + _8946);
                            } else {
                              _8971 = _8920;
                              _8972 = _8946;
                            }
                            [branch]
                            if (!(!(min(_8897, _8891) >= 0.0f))) {
                              _8979 = rsqrt(dot(float3(_8884, _8885, _8886), float3(_8884, _8885, _8886)) * dot(float3(_8884, _8888, _8886), float3(_8884, _8888, _8886)));
                              _8981 = dot(float3(_8884, _8888, _8886), float3(_8884, _8885, _8886)) * _8979;
                              _8988 = rsqrt(max(((((_8981 * 0.09300000220537186f) + 0.5f) * _8981) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8979;
                              _8997 = ((_8988 * (_8820 * _8886)) + _8945);
                              _8998 = ((_8988 * (_8884 * (_8883 - _8881))) + _8972);
                            } else {
                              _8997 = _8945;
                              _8998 = _8972;
                            }
                            if (min(_8898, _8947) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_8891, _8893), max(_8895, _8897)) >= 0.0f))) {
                                _9007 = -0.0f - _8861;
                                _9008 = _8889 / _8864;
                                _9009 = _8882 / _8864;
                                _9010 = _8880 / _8864;
                                _9012 = (_8883 - _9008) / _9007;
                                _9014 = (_8881 - _9008) / _9007;
                                _9015 = min(_9009, _9010);
                                _9016 = max(_9009, _9010);
                                _9017 = min(_9012, _9014);
                                _9018 = max(_9012, _9014);
                                _9019 = max(_9015, _9017);
                                _9020 = min(_9016, _9018);
                                _9021 = _9019 * _8864;
                                _9023 = _9020 * _8864;
                                _9025 = _9021 - _8850;
                                _9026 = _9008 - _8854;
                                _9027 = _9026 + (_9019 * _9007);
                                _9028 = _9023 - _8850;
                                _9029 = _9026 + (_9020 * _9007);
                                _9030 = dot(float3(_9025, _9027, _8886), float3(_9025, _9027, _8886));
                                _9031 = dot(float3(_9028, _9029, _8886), float3(_9028, _9029, _8886));
                                _9033 = rsqrt(_9031 * _9030);
                                _9035 = dot(float3(_9025, _9027, _8886), float3(_9028, _9029, _8886)) * _9033;
                                _9042 = rsqrt(max(((((_9035 * 0.09300000220537186f) + 0.5f) * _9035) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9033;
                                _9055 = (_9015 > _9017);
                                _9057 = select(_9055, _8864, _8861);
                                _9063 = float((int)(((int)(uint)((int)(_9057 > 0.0f))) - ((int)(uint)((int)(_9057 < 0.0f)))));
                                _9067 = ((1.0f - (((float)((bool)_9055)) * 2.0f)) * _8880) * _9063;
                                _9069 = _9067 - _8850;
                                _9070 = (_9063 * _8881) - _8854;
                                _9071 = (_9016 < _9018);
                                _9073 = select(_9071, _8864, _8861);
                                _9079 = float((int)(((int)(uint)((int)(_9073 > 0.0f))) - ((int)(uint)((int)(_9073 < 0.0f)))));
                                _9080 = _9079 * _8880;
                                _9085 = _9080 - _8850;
                                _9086 = ((((((float)((bool)_9071)) * 2.0f) + -1.0f) * _8881) * _9079) - _8854;
                                _9089 = rsqrt(_9030 * dot(float3(_9069, _9070, _8886), float3(_9069, _9070, _8886)));
                                _9091 = dot(float3(_9069, _9070, _8886), float3(_9025, _9027, _8886)) * _9089;
                                _9098 = rsqrt(max(((((_9091 * 0.09300000220537186f) + 0.5f) * _9091) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9089;
                                _9111 = rsqrt(dot(float3(_9085, _9086, _8886), float3(_9085, _9086, _8886)) * _9031);
                                _9113 = dot(float3(_9028, _9029, _8886), float3(_9085, _9086, _8886)) * _9111;
                                _9120 = rsqrt(max(((((_9113 * 0.09300000220537186f) + 0.5f) * _9113) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9111;
                                _9141 = ((((_9042 * (((_9019 - _9020) * _9007) * _8886)) + _8997) + (_9098 * ((_9070 - _9027) * _8886))) + (_9120 * ((_9029 - _9086) * _8886)));
                                _9142 = ((((_9042 * ((_8864 * (_9020 - _9019)) * _8886)) + _8971) + (_9098 * ((_9021 - _9067) * _8886))) + (_9120 * ((_9080 - _9023) * _8886)));
                                _9143 = ((((_9042 * ((_9029 * _9025) - (_9028 * _9027))) + _8998) + (_9098 * ((_9069 * _9027) - (_9070 * _9025)))) + (_9120 * ((_9086 * _9028) - (_9085 * _9029))));
                              } else {
                                _9141 = _8997;
                                _9142 = _8971;
                                _9143 = _8998;
                              }
                            } else {
                              _9141 = _8997;
                              _9142 = _8971;
                              _9143 = _8998;
                            }
                            _9149 = sqrt(((_9142 * _9142) + (_9141 * _9141)) + (_9143 * _9143));
                            _9150 = _9149 * 0.15915493667125702f;
                            [branch]
                            if (!(_9150 == 0.0f)) {
                              _9159 = saturate((_9150 - _8835) / (1.0f - _8835)) * ((float)((bool)(uint)(_8858 <= 0.0f)));
                              [branch]
                              if (!(_9159 == 0.0f)) {
                                if (_9149 > 0.0f) {
                                  _9167 = (dot(float3(_8861, _8864, _8867), float3(_9141, _9142, _9143)) / _9149);
                                } else {
                                  _9167 = 0.0f;
                                }
                                _9172 = min(_214, 0.800000011920929f);
                                _9181 = exp2(((((((_9172 * 3.322999954223633f) + -3.7669999599456787f) * _9172) + -0.3479999899864197f) * _9172) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _9188 = _8886 / (_8879 - ((_8867 * 2.0f) * dot(float3((-0.0f - mad(_8803, _436, mad(_8802, _438, (_8801 * _437)))), (-0.0f - mad(_8809, _436, mad(_8808, _438, (_8807 * _437)))), _8879), float3(_8861, _8864, _8867))));
                                _9191 = (_9188 * 2.0f) * rsqrt(((9.999999747378752e-05f - _9181) * saturate((_214 + -0.5f) * 2.500000238418579f)) + _9181);
                                _9199 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8846), ((log2((_9191 * _9191) * f16tof32(((uint)((uint)(_8823) >> 16)))) * 0.5f) + 5.5f));
                                _9201 = (float)((bool)(uint)(_9188 > 0.0f));
                                _9202 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8846), 10.0f);
                                _9211 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_9159 * _1266), _9159);
                                if (_8844 > 0.0f) {
                                  _9217 = _8844 * _1339;
                                  _9218 = _9211 * _1637;
                                  _9238 = ((((((_9217 * _8837) * _9201) * _9199.x) * _9218) * _1132) + _1577);
                                  _9239 = ((((((_9217 * _8838) * _9201) * _9199.y) * _9218) * _1133) + _1578);
                                  _9240 = ((((((_8840 * _9217) * _9201) * _9199.z) * _9218) * _1134) + _1579);
                                } else {
                                  _9238 = _1577;
                                  _9239 = _1578;
                                  _9240 = _1579;
                                }
                                _9246 = ((_1637 * 5.4256415367126465f) * _9167) * _9211;
                                _9254 = (((_9202.x * _8837) * _9246) + _1574);
                                _9255 = (((_9202.y * _8838) * _9246) + _1575);
                                _9256 = (((_9202.z * _8840) * _9246) + _1576);
                                _9257 = _9238;
                                _9258 = _9239;
                                _9259 = _9240;
                              } else {
                                _9254 = _1574;
                                _9255 = _1575;
                                _9256 = _1576;
                                _9257 = _1577;
                                _9258 = _1578;
                                _9259 = _1579;
                              }
                            } else {
                              _9254 = _1574;
                              _9255 = _1575;
                              _9256 = _1576;
                              _9257 = _1577;
                              _9258 = _1578;
                              _9259 = _1579;
                            }
                          } else {
                            _9254 = _1574;
                            _9255 = _1575;
                            _9256 = _1576;
                            _9257 = _1577;
                            _9258 = _1578;
                            _9259 = _1579;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _9254 = _1574;
              _9255 = _1575;
              _9256 = _1576;
              _9257 = _1577;
              _9258 = _1578;
              _9259 = _1579;
            }
          } else {
            _9254 = _1574;
            _9255 = _1575;
            _9256 = _1576;
            _9257 = _1577;
            _9258 = _1578;
            _9259 = _1579;
          }
          _9260 = _1580 + 1u;
          if (!(_9260 == _global_2)) {
            _1574 = _9254;
            _1575 = _9255;
            _1576 = _9256;
            _1577 = _9257;
            _1578 = _9258;
            _1579 = _9259;
            _1580 = _9260;
            continue;
          }
          _9399 = _9254;
          _9400 = _9255;
          _9401 = _9256;
          _9402 = _9257;
          _9403 = _9258;
          _9404 = _9259;
          _9405 = _161;
          _9406 = _162;
          _9407 = _163;
          break;
        }
      } else {
        _9399 = _1457;
        _9400 = _1458;
        _9401 = _1459;
        _9402 = _1340;
        _9403 = _1341;
        _9404 = _1342;
        _9405 = _161;
        _9406 = _162;
        _9407 = _163;
      }
    } else {
      _9277 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _135, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _134)));
      _9280 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _135, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _134)));
      _9283 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _135, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _134)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _9387 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _9388 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _9389 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _9304 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_9277, _9280, _9283), 0.0f);
        _9308 = _9304.x * 32.0f;
        _9309 = _9304.y * 32.0f;
        _9310 = _9304.z * 32.0f;
        _9312 = rsqrt(dot(float3(_9277, _9280, _9283), float3(_9277, _9280, _9283)));
        _9313 = _9312 * _9277;
        _9314 = _9312 * _9280;
        _9315 = _9312 * _9283;
        _9316 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _9317 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _9318 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _9319 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _9320 = dot(float3(_9313, _9314, _9315), float3(_9317, _9318, _9319));
        _9325 = (_9320 * _9320) - (dot(float3(_9317, _9318, _9319), float3(_9317, _9318, _9319)) - (_9316 * _9316));
        if ((_9320 > -0.0f) && (_9325 > 0.0f)) {
          _9330 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _9343 = 74.80000305175781f / ((dot(float3(_9313, _9314, _9315), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _9316) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _9351 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_9313, _9315), float2(_9330, cbDeferredShading.vSunDirWS.x)) * _9343) + 0.5f), ((dot(float3(_9313, _9314, _9315), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _9330)), (cbDeferredShading.vSunDirWS.y * _9330))) * _9343) + 0.5f)), 0.0f);
          _9353 = _9325 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_9353 > 0.0f) {
            _9360 = saturate(_9353 * 5.0f);
            _9387 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _9351.x) * _9360) + _9308);
            _9388 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _9351.y) * _9360) + _9309);
            _9389 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _9351.z) * _9360) + _9310);
          } else {
            _9387 = _9308;
            _9388 = _9309;
            _9389 = _9310;
          }
        } else {
          _9387 = _9308;
          _9388 = _9309;
          _9389 = _9310;
        }
      }
      _9393 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _9399 = 0.0f;
      _9400 = 0.0f;
      _9401 = 0.0f;
      _9402 = select(_9393, 0.0f, _9387);
      _9403 = select(_9393, 0.0f, _9388);
      _9404 = select(_9393, 0.0f, _9389);
      _9405 = 0.0f;
      _9406 = 0.0f;
      _9407 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_63, _64)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_9405 * _9399) + _9402)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_9406 * _9400) + _9403)), 7936.0f), 5.960464477539063e-08f), max(min((((_9407 * _9401) + _9404) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_63, _64)] = float3(0.0f, 0.0f, 0.0f);
  }
}