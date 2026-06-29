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
  float _248;
  float _249;
  float _250;
  float _251;
  float _341;
  float _342;
  float _380;
  int _495;
  float _496;
  float _497;
  float _498;
  float _499;
  float _500;
  float _501;
  float _502;
  float _503;
  float _504;
  float _505;
  float _506;
  float _507;
  float _508;
  float _509;
  float _624;
  float _625;
  float _626;
  float _713;
  float _714;
  float _715;
  float _733;
  float _734;
  float _735;
  float _767;
  float _768;
  float _769;
  float _770;
  float _771;
  float _772;
  float _773;
  float _787;
  float _788;
  float _789;
  float _790;
  float _791;
  float _792;
  float _793;
  float _794;
  float _795;
  float _796;
  float _797;
  float _798;
  float _799;
  float _800;
  float _805;
  float _806;
  float _807;
  float _808;
  float _809;
  float _810;
  float _811;
  float _812;
  float _813;
  float _814;
  float _815;
  float _816;
  float _817;
  float _818;
  float _867;
  float _868;
  float _869;
  float _889;
  float _890;
  float _891;
  float _902;
  float _903;
  float _904;
  float _905;
  float _906;
  float _907;
  float _910;
  float _911;
  float _912;
  float _913;
  float _914;
  float _915;
  float _916;
  float _930;
  float _931;
  float _932;
  float _933;
  float _934;
  float _935;
  float _964;
  float _965;
  float _966;
  float _986;
  float _987;
  float _988;
  float _999;
  float _1000;
  float _1001;
  float _1002;
  float _1003;
  float _1004;
  float _1023;
  float _1024;
  float _1025;
  float _1026;
  float _1027;
  float _1028;
  float _1047;
  float _1048;
  float _1049;
  int _1080;
  float _1081;
  float _1199;
  float _1204;
  float _1217;
  float _1270;
  float _1271;
  float _1272;
  float _1325;
  float _1326;
  float _1327;
  float _1437;
  float _1442;
  float _1443;
  float _1444;
  float _1445;
  float _1446;
  float _1447;
  int _1448;
  float _2068;
  float _2069;
  float _2070;
  float _2160;
  float _2169;
  float _2178;
  float _2186;
  float _2257;
  float _2266;
  float _2275;
  float _2283;
  float _2356;
  float _2365;
  float _2374;
  float _2382;
  float _2455;
  float _2464;
  float _2473;
  float _2481;
  float _2533;
  float _2538;
  float _2635;
  float _2656;
  float _2657;
  float _2658;
  int _2677;
  float _2694;
  float _2698;
  float _2737;
  float _2769;
  float _2879;
  float _2880;
  float _2892;
  float _2904;
  float _2967;
  float _2968;
  float _2969;
  float _2995;
  float _3086;
  float _3087;
  float _3088;
  float _3139;
  float _3249;
  float _3250;
  float _3262;
  float _3274;
  float _3329;
  float _3330;
  float _3331;
  float _3362;
  float _3391;
  float _3392;
  float _3393;
  float _3409;
  float _3410;
  float _3411;
  float _3424;
  float _3425;
  float _3426;
  float _3587;
  float _3588;
  float _3589;
  float _3590;
  float _3591;
  float _3592;
  float _3684;
  float _3685;
  float _3686;
  float _3687;
  float _3688;
  float _3791;
  float _3800;
  float _3809;
  float _3817;
  float _3888;
  float _3897;
  float _3906;
  float _3914;
  float _3987;
  float _3996;
  float _4005;
  float _4013;
  float _4086;
  float _4095;
  float _4104;
  float _4112;
  float _4447;
  float _4448;
  int _4449;
  float _4478;
  float _4479;
  float _4480;
  float _4481;
  float _4482;
  float _4584;
  float _4593;
  float _4602;
  float _4610;
  float _4681;
  float _4690;
  float _4699;
  float _4707;
  float _4780;
  float _4789;
  float _4798;
  float _4806;
  float _4879;
  float _4888;
  float _4897;
  float _4905;
  float _5239;
  float _5240;
  bool _5241;
  float _5256;
  float _5257;
  float _5258;
  float _5316;
  float _5317;
  float _5342;
  float _5343;
  float _5438;
  float _5441;
  float _5442;
  float _5462;
  float _5463;
  float _5464;
  int _5482;
  float _5499;
  float _5503;
  float _5530;
  float _5531;
  float _5532;
  float _5563;
  float _5592;
  float _5593;
  float _5594;
  float _5610;
  float _5611;
  float _5612;
  float _5648;
  float _5696;
  float _5697;
  float _5698;
  float _5714;
  float _5774;
  float _5775;
  float _5776;
  float _5897;
  float _5898;
  float _5911;
  float _5923;
  float _5924;
  float _5944;
  float _6009;
  float _6010;
  float _6011;
  float _6150;
  float _6721;
  float _6722;
  float _6723;
  float _6813;
  float _6822;
  float _6831;
  float _6839;
  float _6910;
  float _6919;
  float _6928;
  float _6936;
  float _7009;
  float _7018;
  float _7027;
  float _7035;
  float _7108;
  float _7117;
  float _7126;
  float _7134;
  float _7186;
  float _7191;
  float _7192;
  float _7289;
  float _7290;
  float _7311;
  float _7312;
  float _7313;
  int _7332;
  float _7349;
  float _7357;
  float _7383;
  float _7384;
  float _7385;
  float _7416;
  float _7445;
  float _7446;
  float _7447;
  float _7463;
  float _7464;
  float _7465;
  float _7501;
  float _7549;
  float _7550;
  float _7551;
  float _7567;
  float _7627;
  float _7628;
  float _7629;
  float _7750;
  float _7751;
  float _7764;
  float _7776;
  float _7777;
  float _7797;
  float _7862;
  float _7863;
  float _7864;
  float _8013;
  float _8014;
  float _8038;
  float _8039;
  float _8064;
  float _8065;
  float _8090;
  float _8091;
  float _8234;
  float _8235;
  float _8236;
  float _8260;
  float _8342;
  float _8343;
  float _8344;
  float _8358;
  float _8359;
  float _8360;
  float _8361;
  float _8362;
  float _8363;
  float _8368;
  float _8369;
  float _8370;
  float _8371;
  float _8372;
  float _8373;
  float _8521;
  float _8522;
  float _8523;
  float _8532;
  float _8533;
  float _8534;
  float _8535;
  float _8536;
  float _8537;
  float _8538;
  float _8539;
  float _8540;
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
  float _164;
  float _165;
  float _166;
  float _167;
  float _169;
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
  float _201;
  float _203;
  float _204;
  float _205;
  float _211;
  float _212;
  float _213;
  float _214;
  int _220;
  uint _224;
  float _230;
  float4 _239;
  float _260;
  float _261;
  float _276;
  float _277;
  float _280;
  float _281;
  float _284;
  float _285;
  float4 _290;
  float _324;
  float _326;
  bool _327;
  float _329;
  float _331;
  bool _332;
  float4 _345;
  float _349;
  float _361;
  float _362;
  float _363;
  float _364;
  float _365;
  float _366;
  float _381;
  float _382;
  float _384;
  float _385;
  float _386;
  int _394;
  int _395;
  int _396;
  int _397;
  float _401;
  float _403;
  float _404;
  float _414;
  float _419;
  float _423;
  float _424;
  float _427;
  float _440;
  float _441;
  float _442;
  float _446;
  float _461;
  float _464;
  float _467;
  float _470;
  float _473;
  float _476;
  int _512;
  int _513;
  float _516;
  float _517;
  float _518;
  float _519;
  float _522;
  float _523;
  float _524;
  float _525;
  float _528;
  float _529;
  float _530;
  float _531;
  float _534;
  float _535;
  float _536;
  float _537;
  float _540;
  float _541;
  float _542;
  float _543;
  float _546;
  float _547;
  float _548;
  float _549;
  int _552;
  float _555;
  float _556;
  float _557;
  float _560;
  float _561;
  float _562;
  int _565;
  int _568;
  int _571;
  float _600;
  float _603;
  float _606;
  float _607;
  float4 _613;
  float4 _619;
  float _628;
  float _632;
  float _635;
  float _638;
  float _679;
  float _684;
  float _686;
  float _688;
  float _695;
  float _696;
  float4 _702;
  float4 _708;
  float _716;
  float4 _722;
  float4 _728;
  float _745;
  float _746;
  float _747;
  float _748;
  float _749;
  float _750;
  float _751;
  float _752;
  float _753;
  uint _801;
  bool _824;
  int _834;
  float _836;
  float _837;
  float _844;
  float _849;
  float _850;
  bool _851;
  float4 _856;
  float4 _862;
  float _873;
  float4 _878;
  float4 _884;
  float _922;
  int _942;
  float _943;
  float _946;
  float _947;
  bool _948;
  float4 _953;
  float4 _959;
  float _970;
  float4 _975;
  float4 _981;
  float _1009;
  float4 _1065;
  float _1068;
  float _1073;
  float _1075;
  float _1076;
  uint _1082;
  int _1085;
  int _1086;
  int _1090;
  int _1094;
  float _1106;
  float _1111;
  float _1112;
  float _1113;
  float _1114;
  float _1117;
  float _1118;
  float _1119;
  float _1120;
  float _1123;
  float _1124;
  float _1125;
  float _1126;
  int _1129;
  int _1132;
  int _1135;
  int _1138;
  float _1153;
  float _1157;
  float _1161;
  float _1186;
  float _1187;
  float _1188;
  float _1191;
  uint _1200;
  float _1206;
  float _1208;
  float _1210;
  int _1220;
  int _1223;
  int _1224;
  int _1225;
  int _1231;
  int _1232;
  int _1233;
  int _1239;
  int _1240;
  int _1241;
  float _1247;
  float _1251;
  float _1255;
  float _1262;
  int _1275;
  int _1278;
  int _1279;
  int _1280;
  int _1286;
  int _1287;
  int _1288;
  int _1294;
  int _1295;
  int _1296;
  float _1302;
  float _1306;
  float _1310;
  float _1317;
  float _1350;
  float _1354;
  float _1358;
  float _1377;
  float _1381;
  float _1385;
  float _1398;
  float _1399;
  float _1400;
  uint _1438;
  int _1450;
  int _1454;
  int _1455;
  int _1456;
  int _1457;
  int _1468;
  int _1472;
  float _1484;
  int _1487;
  float _1504;
  float _1509;
  float _1510;
  float _1511;
  float _1512;
  float _1515;
  float _1516;
  float _1517;
  float _1518;
  float _1521;
  float _1522;
  float _1523;
  float _1524;
  int _1527;
  int _1530;
  int _1533;
  int _1536;
  int _1539;
  float _1541;
  float _1542;
  float _1544;
  float _1548;
  float _1561;
  float _1565;
  float _1569;
  float _1594;
  float _1595;
  float _1596;
  float _1599;
  float _1600;
  float _1607;
  float _1628;
  float _1629;
  float _1630;
  float _1631;
  float _1634;
  float _1635;
  float _1636;
  float _1637;
  float _1640;
  float _1641;
  float _1642;
  float _1643;
  float _1646;
  float _1647;
  float _1648;
  float _1651;
  int _1654;
  int _1657;
  int _1660;
  int _1663;
  int _1666;
  float _1669;
  float _1670;
  float _1671;
  float _1672;
  int _1675;
  int _1678;
  int _1681;
  int _1684;
  int _1687;
  int _1690;
  int _1693;
  int _1696;
  float _1698;
  float _1699;
  float _1701;
  float _1705;
  float _1708;
  float _1710;
  int _1713;
  float _1723;
  float _1724;
  float _1726;
  float _1727;
  float _1728;
  float _1729;
  float _1745;
  float _1748;
  float _1752;
  float _1753;
  float _1754;
  float _1758;
  float _1762;
  float _1766;
  float _1767;
  float _1790;
  float _1791;
  float _1792;
  float _1795;
  float _1796;
  float _1803;
  float _1804;
  float _1805;
  float _1810;
  float _1812;
  float _1813;
  float _1816;
  float _1820;
  float _1829;
  float _1830;
  float _1831;
  int _1832;
  float _1837;
  float _1846;
  float _1847;
  float _1849;
  float4 _1854;
  float _1859;
  float _1861;
  float _1863;
  float _1865;
  float _1869;
  float _1871;
  float _1875;
  float _1877;
  int _1884;
  float _1889;
  float _1898;
  float _1899;
  float4 _1905;
  float _1910;
  float _1912;
  float _1916;
  float _1918;
  float _1922;
  float _1924;
  float _1928;
  float _1930;
  int _1937;
  float _1942;
  float _1951;
  float _1952;
  float4 _1958;
  float _1963;
  float _1965;
  float _1969;
  float _1971;
  float _1975;
  float _1977;
  float _1981;
  float _1983;
  int _1990;
  float _1995;
  float _2004;
  float _2005;
  float4 _2011;
  float _2016;
  float _2018;
  float _2022;
  float _2024;
  float _2028;
  float _2030;
  float _2034;
  float _2036;
  float _2037;
  float _2048;
  float _2054;
  float _2056;
  float _2058;
  float _2065;
  float _2073;
  float _2074;
  float _2083;
  float _2087;
  float _2096;
  float _2097;
  float _2098;
  float _2103;
  int _2104;
  float _2109;
  float _2118;
  float _2119;
  float _2121;
  float _2123;
  float _2124;
  float4 _2126;
  float _2130;
  float _2131;
  float _2134;
  float _2135;
  float _2140;
  float _2141;
  float _2144;
  float _2145;
  float _2147;
  float _2149;
  bool _2150;
  bool _2151;
  bool _2161;
  bool _2170;
  float _2187;
  float _2189;
  float _2191;
  float _2193;
  float _2197;
  float _2199;
  float _2203;
  float _2205;
  int _2212;
  float _2217;
  float _2226;
  float _2227;
  float _2230;
  float _2231;
  float4 _2233;
  float _2237;
  float _2238;
  float _2241;
  float _2242;
  float _2244;
  float _2246;
  bool _2247;
  bool _2248;
  bool _2258;
  bool _2267;
  float _2284;
  float _2286;
  float _2290;
  float _2292;
  float _2296;
  float _2298;
  float _2302;
  float _2304;
  int _2311;
  float _2316;
  float _2325;
  float _2326;
  float _2329;
  float _2330;
  float4 _2332;
  float _2336;
  float _2337;
  float _2340;
  float _2341;
  float _2343;
  float _2345;
  bool _2346;
  bool _2347;
  bool _2357;
  bool _2366;
  float _2383;
  float _2385;
  float _2389;
  float _2391;
  float _2395;
  float _2397;
  float _2401;
  float _2403;
  int _2410;
  float _2415;
  float _2424;
  float _2425;
  float _2428;
  float _2429;
  float4 _2431;
  float _2435;
  float _2436;
  float _2439;
  float _2440;
  float _2442;
  float _2444;
  bool _2445;
  bool _2446;
  bool _2456;
  bool _2465;
  float _2482;
  float _2484;
  float _2488;
  float _2490;
  float _2494;
  float _2496;
  float _2500;
  float _2502;
  float _2503;
  float _2514;
  float _2520;
  float _2522;
  float _2524;
  float _2544;
  float4 _2551;
  float _2565;
  float _2566;
  float _2567;
  float _2568;
  float _2570;
  float _2575;
  float _2578;
  float _2579;
  float _2581;
  float _2582;
  float _2587;
  float _2592;
  float _2594;
  float _2597;
  float _2598;
  float _2603;
  float _2605;
  float _2607;
  float _2609;
  float _2614;
  float _2620;
  float _2622;
  float3 _2648;
  float _2659;
  float4 _2680;
  int _2708;
  int _2713;
  int _2715;
  int _2716;
  int _2718;
  int _2719;
  int _2728;
  bool _2741;
  float _2744;
  float _2746;
  float _2747;
  float _2748;
  float _2749;
  float _2750;
  float _2751;
  float _2759;
  float _2764;
  float _2770;
  float _2774;
  float _2776;
  float _2777;
  float _2778;
  float _2781;
  bool _2788;
  float _2792;
  float _2794;
  float _2795;
  float _2803;
  float _2806;
  float _2807;
  float _2812;
  float _2821;
  float _2822;
  float _2825;
  float _2827;
  float _2828;
  float _2829;
  float _2831;
  float _2832;
  float _2833;
  float _2834;
  float _2839;
  float _2853;
  float _2858;
  float _2859;
  float _2861;
  float _2867;
  float _2870;
  float _2881;
  float _2882;
  float _2893;
  float _2908;
  float _2913;
  float _2914;
  float _2926;
  float _2929;
  float _2930;
  float _2931;
  float _2932;
  float _2949;
  float _2950;
  float _2975;
  float _2978;
  float _2983;
  float _2984;
  float _2998;
  float _2999;
  float _3000;
  float _3001;
  float _3004;
  float _3005;
  float _3006;
  float _3007;
  float _3010;
  float _3011;
  float _3012;
  int _3015;
  int _3018;
  int _3021;
  int _3024;
  int _3027;
  int _3030;
  float _3034;
  float _3037;
  float _3039;
  int _3041;
  float2 _3061;
  float3 _3078;
  float _3095;
  float _3098;
  float _3104;
  float _3108;
  float _3109;
  float _3110;
  float _3113;
  float _3116;
  float _3117;
  float _3118;
  float _3119;
  float _3120;
  float _3121;
  float _3129;
  float _3134;
  float _3140;
  float _3144;
  float _3146;
  float _3147;
  float _3148;
  float _3151;
  bool _3158;
  float _3162;
  float _3164;
  float _3165;
  float _3173;
  float _3176;
  float _3177;
  float _3182;
  float _3191;
  float _3192;
  float _3195;
  float _3197;
  float _3198;
  float _3199;
  float _3201;
  float _3202;
  float _3203;
  float _3204;
  float _3209;
  float _3223;
  float _3228;
  float _3229;
  float _3231;
  float _3237;
  float _3240;
  float _3251;
  float _3252;
  float _3263;
  float _3278;
  float _3290;
  float _3291;
  float _3303;
  float _3319;
  bool _3332;
  float _3333;
  float _3334;
  float _3335;
  bool _3336;
  float _3338;
  float _3339;
  float _3343;
  float _3349;
  float _3363;
  float _3364;
  float _3367;
  float _3371;
  int _3372;
  float _3374;
  float _3376;
  float _3379;
  float _3383;
  float _3394;
  float _3395;
  float _3396;
  float _3398;
  float _3412;
  float _3413;
  float _3414;
  float _3430;
  float _3431;
  float _3432;
  float _3436;
  float _3448;
  float _3449;
  float _3450;
  float _3453;
  float _3454;
  float _3455;
  float _3458;
  float _3459;
  float _3460;
  float _3463;
  float _3464;
  float _3465;
  float _3468;
  float _3469;
  float _3470;
  int _3473;
  int _3476;
  int _3479;
  int _3482;
  int _3485;
  int _3488;
  int _3491;
  int _3494;
  int _3497;
  int _3500;
  int _3503;
  float _3506;
  float _3507;
  float _3508;
  float _3509;
  int _3512;
  int _3515;
  int _3518;
  int _3521;
  float _3523;
  float _3524;
  float _3526;
  float _3530;
  float _3533;
  float _3534;
  float _3536;
  float _3540;
  float _3542;
  float _3543;
  float _3545;
  int _3548;
  bool _3552;
  float _3560;
  float _3561;
  float _3563;
  float _3566;
  float _3567;
  float _3569;
  float _3570;
  float _3572;
  float _3573;
  float _3577;
  float _3583;
  float _3584;
  float _3585;
  float _3596;
  float _3597;
  float _3598;
  float _3599;
  float _3600;
  float _3601;
  float _3602;
  float _3603;
  float _3604;
  float _3607;
  float _3608;
  float _3609;
  float _3612;
  float _3619;
  float _3629;
  float _3632;
  float _3636;
  float _3640;
  float _3641;
  float _3642;
  float _3645;
  float _3648;
  bool _3650;
  float _3656;
  float _3657;
  float _3658;
  float _3663;
  float _3664;
  float _3665;
  bool _3669;
  bool _3675;
  bool _3679;
  float _3689;
  float _3693;
  float _3702;
  float _3703;
  float _3710;
  float _3711;
  float _3714;
  float _3718;
  float _3727;
  float _3728;
  float _3729;
  float _3734;
  int _3735;
  float _3740;
  float _3749;
  float _3750;
  float _3752;
  float _3754;
  float _3755;
  float4 _3757;
  float _3761;
  float _3762;
  float _3765;
  float _3766;
  float _3771;
  float _3772;
  float _3775;
  float _3776;
  float _3778;
  float _3780;
  bool _3781;
  bool _3782;
  bool _3792;
  bool _3801;
  float _3818;
  float _3820;
  float _3822;
  float _3824;
  float _3828;
  float _3830;
  float _3834;
  float _3836;
  int _3843;
  float _3848;
  float _3857;
  float _3858;
  float _3861;
  float _3862;
  float4 _3864;
  float _3868;
  float _3869;
  float _3872;
  float _3873;
  float _3875;
  float _3877;
  bool _3878;
  bool _3879;
  bool _3889;
  bool _3898;
  float _3915;
  float _3917;
  float _3921;
  float _3923;
  float _3927;
  float _3929;
  float _3933;
  float _3935;
  int _3942;
  float _3947;
  float _3956;
  float _3957;
  float _3960;
  float _3961;
  float4 _3963;
  float _3967;
  float _3968;
  float _3971;
  float _3972;
  float _3974;
  float _3976;
  bool _3977;
  bool _3978;
  bool _3988;
  bool _3997;
  float _4014;
  float _4016;
  float _4020;
  float _4022;
  float _4026;
  float _4028;
  float _4032;
  float _4034;
  int _4041;
  float _4046;
  float _4055;
  float _4056;
  float _4059;
  float _4060;
  float4 _4062;
  float _4066;
  float _4067;
  float _4070;
  float _4071;
  float _4073;
  float _4075;
  bool _4076;
  bool _4077;
  bool _4087;
  bool _4096;
  float _4113;
  float _4115;
  float _4119;
  float _4121;
  float _4125;
  float _4127;
  float _4131;
  float _4133;
  float _4134;
  float _4145;
  float _4151;
  float _4153;
  float _4155;
  float _4164;
  float _4167;
  float _4168;
  float _4182;
  float _4183;
  float _4184;
  float _4188;
  float _4197;
  float _4198;
  float _4199;
  int _4200;
  float _4205;
  float _4214;
  float _4215;
  float _4217;
  float4 _4222;
  float _4227;
  float _4229;
  float _4231;
  float _4233;
  float _4237;
  float _4239;
  float _4243;
  float _4245;
  int _4252;
  float _4257;
  float _4266;
  float _4267;
  float4 _4273;
  float _4278;
  float _4280;
  float _4284;
  float _4286;
  float _4290;
  float _4292;
  float _4296;
  float _4298;
  int _4305;
  float _4310;
  float _4319;
  float _4320;
  float4 _4326;
  float _4331;
  float _4333;
  float _4337;
  float _4339;
  float _4343;
  float _4345;
  float _4349;
  float _4351;
  int _4358;
  float _4363;
  float _4372;
  float _4373;
  float4 _4379;
  float _4384;
  float _4386;
  float _4390;
  float _4392;
  float _4396;
  float _4398;
  float _4402;
  float _4404;
  float _4405;
  float _4416;
  float _4422;
  float _4424;
  float _4426;
  float _4434;
  float _4441;
  float _4443;
  float _4457;
  float _4458;
  float _4459;
  bool _4463;
  bool _4469;
  bool _4473;
  float _4483;
  float _4488;
  float _4497;
  float _4498;
  float _4503;
  float _4504;
  float _4507;
  float _4511;
  float _4520;
  float _4521;
  float _4522;
  float _4527;
  int _4528;
  float _4533;
  float _4542;
  float _4543;
  float _4545;
  float _4547;
  float _4548;
  float4 _4550;
  float _4554;
  float _4555;
  float _4558;
  float _4559;
  float _4564;
  float _4565;
  float _4568;
  float _4569;
  float _4571;
  float _4573;
  bool _4574;
  bool _4575;
  bool _4585;
  bool _4594;
  float _4611;
  float _4613;
  float _4615;
  float _4617;
  float _4621;
  float _4623;
  float _4627;
  float _4629;
  int _4636;
  float _4641;
  float _4650;
  float _4651;
  float _4654;
  float _4655;
  float4 _4657;
  float _4661;
  float _4662;
  float _4665;
  float _4666;
  float _4668;
  float _4670;
  bool _4671;
  bool _4672;
  bool _4682;
  bool _4691;
  float _4708;
  float _4710;
  float _4714;
  float _4716;
  float _4720;
  float _4722;
  float _4726;
  float _4728;
  int _4735;
  float _4740;
  float _4749;
  float _4750;
  float _4753;
  float _4754;
  float4 _4756;
  float _4760;
  float _4761;
  float _4764;
  float _4765;
  float _4767;
  float _4769;
  bool _4770;
  bool _4771;
  bool _4781;
  bool _4790;
  float _4807;
  float _4809;
  float _4813;
  float _4815;
  float _4819;
  float _4821;
  float _4825;
  float _4827;
  int _4834;
  float _4839;
  float _4848;
  float _4849;
  float _4852;
  float _4853;
  float4 _4855;
  float _4859;
  float _4860;
  float _4863;
  float _4864;
  float _4866;
  float _4868;
  bool _4869;
  bool _4870;
  bool _4880;
  bool _4889;
  float _4906;
  float _4908;
  float _4912;
  float _4914;
  float _4918;
  float _4920;
  float _4924;
  float _4926;
  float _4927;
  float _4938;
  float _4944;
  float _4946;
  float _4948;
  float _4957;
  float _4960;
  float _4961;
  float _4974;
  float _4975;
  float _4976;
  float _4980;
  float _4989;
  float _4990;
  float _4991;
  int _4992;
  float _4997;
  float _5006;
  float _5007;
  float _5009;
  float4 _5014;
  float _5019;
  float _5021;
  float _5023;
  float _5025;
  float _5029;
  float _5031;
  float _5035;
  float _5037;
  int _5044;
  float _5049;
  float _5058;
  float _5059;
  float4 _5065;
  float _5070;
  float _5072;
  float _5076;
  float _5078;
  float _5082;
  float _5084;
  float _5088;
  float _5090;
  int _5097;
  float _5102;
  float _5111;
  float _5112;
  float4 _5118;
  float _5123;
  float _5125;
  float _5129;
  float _5131;
  float _5135;
  float _5137;
  float _5141;
  float _5143;
  int _5150;
  float _5155;
  float _5164;
  float _5165;
  float4 _5171;
  float _5176;
  float _5178;
  float _5182;
  float _5184;
  float _5188;
  float _5190;
  float _5194;
  float _5196;
  float _5197;
  float _5208;
  float _5214;
  float _5216;
  float _5218;
  float _5226;
  float _5233;
  float _5235;
  float _5261;
  float _5263;
  float _5264;
  float _5265;
  float _5280;
  float _5283;
  float _5286;
  float _5288;
  float _5289;
  float _5290;
  float _5291;
  float _5299;
  float _5300;
  float _5301;
  bool _5303;
  float _5323;
  float4 _5348;
  float _5368;
  float _5369;
  float _5370;
  float _5371;
  float _5373;
  float _5378;
  float _5381;
  float _5382;
  float _5384;
  float _5385;
  float _5390;
  float _5395;
  float _5397;
  float _5400;
  float _5401;
  float _5406;
  float _5408;
  float _5410;
  float _5412;
  float _5417;
  float _5423;
  float _5425;
  float3 _5454;
  float4 _5485;
  float _5520;
  bool _5533;
  float _5534;
  float _5535;
  float _5536;
  bool _5537;
  float _5539;
  float _5540;
  float _5544;
  float _5550;
  float _5564;
  float _5565;
  float _5568;
  float _5572;
  int _5573;
  float _5575;
  float _5577;
  float _5580;
  float _5584;
  float _5595;
  float _5596;
  float _5597;
  float _5599;
  int _5619;
  int _5624;
  int _5626;
  int _5627;
  int _5629;
  int _5630;
  int _5639;
  bool _5652;
  float _5655;
  float _5657;
  float _5658;
  float _5659;
  float _5660;
  float _5661;
  float _5662;
  float _5663;
  float _5664;
  float _5665;
  float _5666;
  float _5667;
  float _5668;
  bool _5669;
  float _5670;
  float _5671;
  float _5674;
  float _5675;
  float _5677;
  float _5704;
  float _5709;
  float _5716;
  float _5717;
  float _5718;
  float _5720;
  float _5724;
  float _5725;
  float _5726;
  float _5727;
  float _5728;
  float _5729;
  float _5730;
  float _5736;
  float _5745;
  float _5749;
  float _5750;
  float _5751;
  float _5752;
  float _5756;
  float _5757;
  float _5758;
  float _5766;
  float _5778;
  float _5779;
  float _5780;
  float _5781;
  float _5782;
  float _5786;
  float _5788;
  float _5790;
  float _5794;
  float _5795;
  float _5796;
  float _5799;
  bool _5806;
  float _5810;
  float _5812;
  float _5813;
  float _5821;
  float _5824;
  float _5825;
  float _5830;
  float _5839;
  float _5840;
  float _5843;
  float _5845;
  float _5846;
  float _5847;
  float _5849;
  float _5850;
  float _5851;
  float _5852;
  float _5857;
  float _5871;
  float _5876;
  float _5877;
  float _5879;
  float _5885;
  float _5888;
  float _5899;
  float _5901;
  float _5920;
  float _5931;
  float _5948;
  float _5953;
  float _5954;
  float _5955;
  float _5967;
  float _5970;
  float _5971;
  float _5972;
  float _5973;
  float _5991;
  float _5992;
  float _6017;
  float _6020;
  float _6025;
  float _6026;
  float _6041;
  float _6042;
  float _6043;
  float _6046;
  float _6047;
  float _6048;
  float _6051;
  int _6054;
  int _6057;
  int _6060;
  float _6069;
  float _6072;
  float _6075;
  float _6082;
  float _6087;
  float _6089;
  float _6091;
  float _6092;
  float _6093;
  float _6095;
  float _6096;
  float _6097;
  float _6100;
  float _6101;
  float _6102;
  float _6105;
  float _6112;
  int _6121;
  int _6126;
  int _6128;
  int _6129;
  int _6131;
  int _6132;
  int _6141;
  bool _6154;
  float _6156;
  float _6157;
  float _6158;
  float _6159;
  float _6162;
  float _6165;
  float _6166;
  float _6167;
  float _6168;
  float _6172;
  float _6177;
  float _6178;
  float _6179;
  float _6191;
  float _6193;
  float _6194;
  float _6195;
  float _6196;
  float _6203;
  float _6204;
  float _6205;
  float _6217;
  float _6220;
  float _6241;
  float _6242;
  float _6243;
  float _6246;
  float _6247;
  float _6248;
  float _6251;
  float _6252;
  float _6253;
  float _6256;
  float _6257;
  float _6258;
  float _6261;
  float _6262;
  float _6263;
  float _6266;
  float _6267;
  float _6268;
  int _6271;
  int _6274;
  int _6277;
  int _6280;
  float _6283;
  float _6284;
  float _6285;
  float _6286;
  int _6289;
  int _6292;
  int _6295;
  int _6298;
  int _6301;
  int _6304;
  int _6307;
  float _6310;
  float _6311;
  float _6312;
  float _6313;
  int _6316;
  int _6319;
  int _6322;
  float _6324;
  float _6325;
  float _6327;
  float _6331;
  float _6334;
  float _6335;
  float _6337;
  float _6341;
  int _6345;
  float _6361;
  float _6362;
  float _6364;
  float _6365;
  float _6366;
  float _6367;
  float _6368;
  float _6369;
  float _6370;
  float _6371;
  float _6372;
  float _6373;
  float _6374;
  float _6375;
  float _6376;
  float _6379;
  float _6380;
  float _6381;
  float _6384;
  float _6395;
  float _6396;
  float _6399;
  float _6406;
  float _6407;
  float _6408;
  float _6420;
  float _6421;
  float _6422;
  float _6423;
  float _6426;
  float _6427;
  float _6430;
  float _6431;
  float _6438;
  float _6440;
  float _6446;
  bool _6448;
  float _6456;
  float _6457;
  float _6458;
  float _6463;
  float _6465;
  float _6466;
  float _6469;
  float _6473;
  float _6482;
  float _6483;
  float _6484;
  int _6485;
  float _6490;
  float _6499;
  float _6500;
  float _6502;
  float4 _6507;
  float _6512;
  float _6514;
  float _6516;
  float _6518;
  float _6522;
  float _6524;
  float _6528;
  float _6530;
  int _6537;
  float _6542;
  float _6551;
  float _6552;
  float4 _6558;
  float _6563;
  float _6565;
  float _6569;
  float _6571;
  float _6575;
  float _6577;
  float _6581;
  float _6583;
  int _6590;
  float _6595;
  float _6604;
  float _6605;
  float4 _6611;
  float _6616;
  float _6618;
  float _6622;
  float _6624;
  float _6628;
  float _6630;
  float _6634;
  float _6636;
  int _6643;
  float _6648;
  float _6657;
  float _6658;
  float4 _6664;
  float _6669;
  float _6671;
  float _6675;
  float _6677;
  float _6681;
  float _6683;
  float _6687;
  float _6689;
  float _6690;
  float _6701;
  float _6707;
  float _6709;
  float _6711;
  float _6718;
  float _6726;
  float _6727;
  float _6736;
  float _6740;
  float _6749;
  float _6750;
  float _6751;
  float _6756;
  int _6757;
  float _6762;
  float _6771;
  float _6772;
  float _6774;
  float _6776;
  float _6777;
  float4 _6779;
  float _6783;
  float _6784;
  float _6787;
  float _6788;
  float _6793;
  float _6794;
  float _6797;
  float _6798;
  float _6800;
  float _6802;
  bool _6803;
  bool _6804;
  bool _6814;
  bool _6823;
  float _6840;
  float _6842;
  float _6844;
  float _6846;
  float _6850;
  float _6852;
  float _6856;
  float _6858;
  int _6865;
  float _6870;
  float _6879;
  float _6880;
  float _6883;
  float _6884;
  float4 _6886;
  float _6890;
  float _6891;
  float _6894;
  float _6895;
  float _6897;
  float _6899;
  bool _6900;
  bool _6901;
  bool _6911;
  bool _6920;
  float _6937;
  float _6939;
  float _6943;
  float _6945;
  float _6949;
  float _6951;
  float _6955;
  float _6957;
  int _6964;
  float _6969;
  float _6978;
  float _6979;
  float _6982;
  float _6983;
  float4 _6985;
  float _6989;
  float _6990;
  float _6993;
  float _6994;
  float _6996;
  float _6998;
  bool _6999;
  bool _7000;
  bool _7010;
  bool _7019;
  float _7036;
  float _7038;
  float _7042;
  float _7044;
  float _7048;
  float _7050;
  float _7054;
  float _7056;
  int _7063;
  float _7068;
  float _7077;
  float _7078;
  float _7081;
  float _7082;
  float4 _7084;
  float _7088;
  float _7089;
  float _7092;
  float _7093;
  float _7095;
  float _7097;
  bool _7098;
  bool _7099;
  bool _7109;
  bool _7118;
  float _7135;
  float _7137;
  float _7141;
  float _7143;
  float _7147;
  float _7149;
  float _7153;
  float _7155;
  float _7156;
  float _7167;
  float _7173;
  float _7175;
  float _7177;
  float _7198;
  float4 _7205;
  float _7219;
  float _7220;
  float _7221;
  float _7222;
  float _7224;
  float _7229;
  float _7232;
  float _7233;
  float _7235;
  float _7236;
  float _7241;
  float _7246;
  float _7248;
  float _7251;
  float _7252;
  float _7257;
  float _7259;
  float _7261;
  float _7263;
  float _7268;
  float _7274;
  float _7276;
  float3 _7303;
  float _7314;
  float4 _7335;
  float _7373;
  bool _7386;
  float _7387;
  float _7388;
  float _7389;
  bool _7390;
  float _7392;
  float _7393;
  float _7397;
  float _7403;
  float _7417;
  float _7418;
  float _7421;
  float _7425;
  int _7426;
  float _7428;
  float _7430;
  float _7433;
  float _7437;
  float _7448;
  float _7449;
  float _7450;
  float _7452;
  int _7472;
  int _7477;
  int _7479;
  int _7480;
  int _7482;
  int _7483;
  int _7492;
  bool _7505;
  float _7508;
  float _7510;
  float _7511;
  float _7512;
  float _7513;
  float _7514;
  float _7515;
  float _7516;
  float _7517;
  float _7518;
  float _7519;
  float _7520;
  float _7521;
  bool _7522;
  float _7523;
  float _7524;
  float _7527;
  float _7528;
  float _7530;
  float _7557;
  float _7562;
  float _7569;
  float _7570;
  float _7571;
  float _7573;
  float _7577;
  float _7578;
  float _7579;
  float _7580;
  float _7581;
  float _7582;
  float _7583;
  float _7589;
  float _7598;
  float _7602;
  float _7603;
  float _7604;
  float _7605;
  float _7609;
  float _7610;
  float _7611;
  float _7619;
  float _7631;
  float _7632;
  float _7633;
  float _7634;
  float _7635;
  float _7639;
  float _7641;
  float _7643;
  float _7647;
  float _7648;
  float _7649;
  float _7652;
  bool _7659;
  float _7663;
  float _7665;
  float _7666;
  float _7674;
  float _7677;
  float _7678;
  float _7683;
  float _7692;
  float _7693;
  float _7696;
  float _7698;
  float _7699;
  float _7700;
  float _7702;
  float _7703;
  float _7704;
  float _7705;
  float _7710;
  float _7724;
  float _7729;
  float _7730;
  float _7732;
  float _7738;
  float _7741;
  float _7752;
  float _7754;
  float _7773;
  float _7784;
  float _7801;
  float _7806;
  float _7807;
  float _7808;
  float _7820;
  float _7823;
  float _7824;
  float _7825;
  float _7826;
  float _7844;
  float _7845;
  float _7870;
  float _7873;
  float _7878;
  float _7879;
  float _7894;
  float _7895;
  float _7896;
  float _7897;
  float _7900;
  float _7901;
  float _7902;
  float _7903;
  float _7906;
  float _7907;
  float _7908;
  float _7909;
  float _7912;
  float _7913;
  int _7916;
  int _7919;
  int _7922;
  int _7925;
  float _7928;
  float _7930;
  float _7931;
  float _7933;
  float _7937;
  float _7939;
  float _7943;
  float _7947;
  float _7951;
  float _7954;
  float _7957;
  float _7960;
  float _7972;
  float _7973;
  float _7974;
  float _7975;
  float _7976;
  float _7977;
  float _7978;
  float _7979;
  float _7980;
  float _7981;
  float _7982;
  float _7984;
  float _7986;
  float _7988;
  float _7990;
  float _7991;
  float _7997;
  float _7999;
  float _8006;
  float _8021;
  float _8023;
  float _8030;
  float _8040;
  float _8046;
  float _8048;
  float _8055;
  float _8072;
  float _8074;
  float _8081;
  float _8100;
  float _8101;
  float _8102;
  float _8103;
  float _8105;
  float _8107;
  float _8108;
  float _8109;
  float _8110;
  float _8111;
  float _8112;
  float _8113;
  float _8114;
  float _8116;
  float _8118;
  float _8119;
  float _8120;
  float _8121;
  float _8122;
  float _8123;
  float _8124;
  float _8126;
  float _8128;
  float _8135;
  bool _8148;
  float _8150;
  float _8156;
  float _8160;
  float _8162;
  float _8163;
  bool _8164;
  float _8166;
  float _8172;
  float _8173;
  float _8178;
  float _8179;
  float _8182;
  float _8184;
  float _8191;
  float _8204;
  float _8206;
  float _8213;
  float _8242;
  float _8243;
  float _8252;
  float _8261;
  float _8266;
  float _8275;
  float _8282;
  float _8285;
  float4 _8293;
  float _8295;
  float4 _8296;
  float _8305;
  float _8321;
  float _8322;
  float _8350;
  uint _8364;
  float _8375;
  float _8382;
  float _8392;
  float _8411;
  float _8414;
  float _8417;
  float4 _8438;
  float _8442;
  float _8443;
  float _8444;
  float _8446;
  float _8447;
  float _8448;
  float _8449;
  float _8450;
  float _8451;
  float _8452;
  float _8453;
  float _8454;
  float _8459;
  float _8464;
  float _8477;
  float4 _8485;
  float _8487;
  float _8494;
  bool _8527;
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
      _164 = saturate(_148.x);
      _165 = saturate(_148.y);
      _166 = saturate(_148.z);
      _167 = saturate(_148.w);
      _169 = saturate(_154.y);
      _173 = (saturate(_138.x) * 2.0f) + -1.0f;
      _174 = (saturate(_138.y) * 2.0f) + -1.0f;
      _178 = (1.0f - abs(_173)) - abs(_174);
      _180 = saturate(-0.0f - _178);
      _181 = -0.0f - _180;
      _186 = select((_173 >= 0.0f), _181, _180) + _173;
      _187 = select((_174 >= 0.0f), _181, _180) + _174;
      _189 = rsqrt(dot(float3(_186, _187, _178), float3(_186, _187, _178)));
      _190 = _186 * _189;
      _191 = _187 * _189;
      _192 = _189 * _178;
      _201 = min(1.0f, max(saturate(_154.x), 0.019999999552965164f));
      _203 = _164 * _164;
      _204 = _165 * _165;
      _205 = _166 * _166;
      _211 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _117.x) - cbSharedPerViewData.vViewRemap.y);
      _212 = _211 * _134;
      _213 = _211 * _135;
      _214 = -0.0f - _211;
      _220 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _224 = srvReflectionsWeight.Load(int3(((uint)(_63) >> _220), ((uint)(_64) >> _220), 0));
      _230 = ((float)((uint)((uint)(_224.x & 254)))) * 0.003921568859368563f;
      if ((_224.x & 1) == 0) {
        _239 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _125), (cbSharedPerViewData.vViewportSize.y * _126)), 0.0f);
        _248 = (1.0f - _230);
        _249 = (_239.x * _230);
        _250 = (_239.y * _230);
        _251 = (_239.z * _230);
      } else {
        _248 = 1.0f;
        _249 = 0.0f;
        _250 = 0.0f;
        _251 = 0.0f;
      }
      _260 = cbSharedPerViewData.vViewportSize.x * (_125 + 0.5f);
      _261 = cbSharedPerViewData.vViewportSize.y * (_126 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _276 = (floor((_260 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _277 = (floor((_261 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _280 = max(_276, cbDeferredShading.vScreenPixelSize.z);
        _281 = max(_277, cbDeferredShading.vScreenPixelSize.w);
        _284 = min((_276 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _285 = min((_277 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _290 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_280 + cbDeferredShading.vScreenPixelSize.z), (_281 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _290.x) - cbSharedPerViewData.vViewRemap.y)) - _211) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _290.y) - cbSharedPerViewData.vViewRemap.y)) - _211) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _290.z) - cbSharedPerViewData.vViewRemap.y)) - _211) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _290.w) - cbSharedPerViewData.vViewRemap.y)) - _211) > 0.029999999329447746f)) {
          _324 = abs(_117.x - _290.w);
          _326 = abs(_117.x - _290.z);
          _327 = (_326 < _324);
          _329 = select(_327, _326, _324);
          _331 = abs(_117.x - _290.x);
          _332 = (_331 < _329);
          if (abs(_117.x - _290.y) < select(_332, _331, _329)) {
            _341 = _284;
            _342 = _285;
          } else {
            _341 = select(_332, _280, select(_327, _284, _280));
            _342 = select(_332, _285, _281);
          }
        } else {
          _341 = _260;
          _342 = _261;
        }
      } else {
        _341 = _260;
        _342 = _261;
      }
      _345 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_341, _342), 0.0f);
      _349 = _345.x - _345.z;
      _361 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_345.y + _349)), 0.0f);
      _362 = -0.0f - _361;
      _363 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_345.x + _345.z)), 0.0f);
      _364 = -0.0f - _363;
      _365 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_349 - _345.y)), 0.0f);
      _366 = -0.0f - _365;
      if (!(cbSharedPerViewData.nSSGIEnabled == 0)) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _380 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_341, _342), 0.0f)).x);
        } else {
          _380 = 1.0f;
        }
      } else {
        _380 = 1.0f;
      }
      _381 = -0.0f - _134;
      _382 = -0.0f - _135;
      _384 = rsqrt(dot(float3(_381, _382, 1.0f), float3(_381, _382, 1.0f)));
      _385 = _384 * _381;
      _386 = _384 * _382;
      _394 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _64) + _63))];
      _395 = _394 & 255;
      _396 = (uint)(_394) >> 8;
      _397 = _396 & 255;
      _401 = ((float)((uint)((uint)(((uint)(_394) >> 16) & 255)))) * 0.003921568859368563f;
      _403 = (float)((uint)((uint)((uint)(_394) >> 24)));
      _404 = _403 * 0.003921568859368563f;
      [branch]
      if (!((((int)(uint((saturate(_142.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _414 = _201 * 4.0f;
        _419 = dot(float3((-0.0f - _385), (-0.0f - _386), (-0.0f - _384)), float3(_190, _191, _192)) * 2.0f;
        _423 = _201 * _201;
        _424 = 1.0f - _423;
        _427 = (sqrt(_424) + _423) * _424;
        _440 = (_427 * (((-0.0f - _190) - _385) - (_419 * _190))) + _190;
        _441 = (_427 * (((-0.0f - _191) - _386) - (_419 * _191))) + _191;
        _442 = (_427 * (((-0.0f - _192) - _384) - (_419 * _192))) + _192;
        _446 = saturate(1.0f - ((_201 + -0.30000001192092896f) * 3.3333332538604736f));
        _461 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _442, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _441, (_440 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _464 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _442, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _441, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _440)));
        _467 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _442, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _441, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _440)));
        _470 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _192, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _191, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _190)));
        _473 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _192, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _191, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _190)));
        _476 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _192, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _191, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _190)));
        if (!(_global_0 == 0)) {
          _495 = 0;
          _496 = 0.0f;
          _497 = 0.0f;
          _498 = 0.0f;
          _499 = 0.0f;
          _500 = 0.0f;
          _501 = 0.0f;
          _502 = 0.0f;
          _503 = 0.0f;
          _504 = 0.0f;
          _505 = 0.0f;
          _506 = 0.0f;
          _507 = 0.0f;
          _508 = 0.0f;
          _509 = 0.0f;
          while(true) {
            _787 = _496;
            _788 = _497;
            _789 = _498;
            _790 = _499;
            _791 = _500;
            _792 = _501;
            _793 = _502;
            _794 = _503;
            _795 = _504;
            _796 = _505;
            _797 = _506;
            _798 = _507;
            _799 = _508;
            _800 = _509;
            _512 = _global_5[min((uint)(_495), 63u)];
            _513 = _global_6[min((uint)(_495), 63u)];
            _516 = asfloat(srvLightInfoProperties.Load4(_513)).x;
            _517 = asfloat(srvLightInfoProperties.Load4(_513)).y;
            _518 = asfloat(srvLightInfoProperties.Load4(_513)).z;
            _519 = asfloat(srvLightInfoProperties.Load4(_513)).w;
            _522 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 16u)))).x;
            _523 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 16u)))).y;
            _524 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 16u)))).z;
            _525 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 16u)))).w;
            _528 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 32u)))).x;
            _529 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 32u)))).y;
            _530 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 32u)))).z;
            _531 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 32u)))).w;
            _534 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 48u)))).x;
            _535 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 48u)))).y;
            _536 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 48u)))).z;
            _537 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 48u)))).w;
            _540 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 64u)))).x;
            _541 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 64u)))).y;
            _542 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 64u)))).z;
            _543 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 64u)))).w;
            _546 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 80u)))).x;
            _547 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 80u)))).y;
            _548 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 80u)))).z;
            _549 = asfloat(srvLightInfoProperties.Load4(((int)(_513 + 80u)))).w;
            _552 = asint(srvLightInfoProperties.Load(((int)(_513 + 96u))));
            _555 = asfloat(srvLightInfoProperties.Load3(((int)(_513 + 100u)))).x;
            _556 = asfloat(srvLightInfoProperties.Load3(((int)(_513 + 100u)))).y;
            _557 = asfloat(srvLightInfoProperties.Load3(((int)(_513 + 100u)))).z;
            _560 = asfloat(srvLightInfoProperties.Load3(((int)(_513 + 112u)))).x;
            _561 = asfloat(srvLightInfoProperties.Load3(((int)(_513 + 112u)))).y;
            _562 = asfloat(srvLightInfoProperties.Load3(((int)(_513 + 112u)))).z;
            _565 = asint(srvLightInfoProperties.Load(((int)(_513 + 124u))));
            _568 = asint(srvLightInfoProperties.Load(((int)(_513 + 128u))));
            _571 = _552 & 65535;
            _600 = ((saturate(1.0f - abs(mad(_518, _214, mad(_517, _213, (_516 * _212))) + _519)) * f16tof32(((uint)((uint)(_552) >> 16)))) * saturate(1.0f - abs(mad(_524, _214, mad(_523, _213, (_522 * _212))) + _525))) * saturate(1.0f - abs(mad(_530, _214, mad(_529, _213, (_528 * _212))) + _531));
            [branch]
            if (_600 > 0.0f) {
              _603 = _600 * _600;
              [branch]
              if (_446 < 1.0f) {
                _606 = (float)((uint)_571);
                _607 = -0.0f - _461;
                [branch]
                if (!(_606 >= 341.0f)) {
                  _619 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_607, _464, _467, _606), _414);
                  _624 = _619.x;
                  _625 = _619.y;
                  _626 = _619.z;
                } else {
                  _613 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_607, _464, _467, (_606 + -341.0f)), _414);
                  _624 = _613.x;
                  _625 = _613.y;
                  _626 = _613.z;
                }
              } else {
                _624 = 0.0f;
                _625 = 0.0f;
                _626 = 0.0f;
              }
              _628 = (float)((uint)_571);
              [branch]
              if (_446 > 0.0f) {
                _632 = mad(_536, _442, mad(_535, _441, (_534 * _440)));
                _635 = mad(_542, _442, mad(_541, _441, (_540 * _440)));
                _638 = mad(_548, _442, mad(_547, _441, (_546 * _440)));
                _679 = min(((((float((int)(((int)(uint)((int)(_632 > 0.0f))) - ((int)(uint)((int)(_632 < 0.0f))))) * _555) - _537) - mad(_536, _214, mad(_535, _213, (_534 * _212)))) / _632), min(((((float((int)(((int)(uint)((int)(_635 > 0.0f))) - ((int)(uint)((int)(_635 < 0.0f))))) * _556) - _543) - mad(_542, _214, mad(_541, _213, (_540 * _212)))) / _635), ((((float((int)(((int)(uint)((int)(_638 > 0.0f))) - ((int)(uint)((int)(_638 < 0.0f))))) * _557) - _549) - mad(_548, _214, mad(_547, _213, (_546 * _212)))) / _638)));
                _684 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _214, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _213, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _212))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _560) + (_679 * _461);
                _686 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _214, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _213, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _212))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _561) + (_679 * _464);
                _688 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _214, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _213, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _212))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _562) + (_679 * _467);
                _695 = (max(log2((_679 * _679) / dot(float3(_684, _686, _688), float3(_684, _686, _688))), -1.0f) * 0.3333333432674408f) + _414;
                _696 = -0.0f - _684;
                [branch]
                if (!(_628 >= 341.0f)) {
                  _708 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_696, _686, _688, _628), _695);
                  _713 = _708.x;
                  _714 = _708.y;
                  _715 = _708.z;
                } else {
                  _702 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_696, _686, _688, (_628 + -341.0f)), _695);
                  _713 = _702.x;
                  _714 = _702.y;
                  _715 = _702.z;
                }
              } else {
                _713 = 0.0f;
                _714 = 0.0f;
                _715 = 0.0f;
              }
              _716 = -0.0f - _470;
              [branch]
              if (!(_628 >= 341.0f)) {
                _728 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_716, _473, _476, _628), 0.0f);
                _733 = _728.x;
                _734 = _728.y;
                _735 = _728.z;
              } else {
                _722 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_716, _473, _476, (_628 + -341.0f)), 0.0f);
                _733 = _722.x;
                _734 = _722.y;
                _735 = _722.z;
              }
              _745 = _603 * f16tof32(((uint)((uint)(_565) >> 16)));
              _746 = _745 * _733;
              _747 = _603 * f16tof32(_565);
              _748 = _747 * _734;
              _749 = _603 * f16tof32(((uint)((uint)(_568) >> 16)));
              _750 = _749 * _735;
              _751 = _745 * (lerp(_624, _713, _446));
              _752 = _747 * (lerp(_625, _714, _446));
              _753 = _749 * (lerp(_626, _715, _446));
              [branch]
              if (!((_512 & ((int)(1 << (_394 & 31)))) == 0)) {
                _767 = (_746 + _496);
                _768 = (_748 + _497);
                _769 = (_750 + _498);
                _770 = (_751 + _499);
                _771 = (_752 + _500);
                _772 = (_753 + _501);
                _773 = (_603 + _502);
              } else {
                _767 = _496;
                _768 = _497;
                _769 = _498;
                _770 = _499;
                _771 = _500;
                _772 = _501;
                _773 = _502;
              }
              [branch]
              if (!((_512 & ((int)(1 << (_396 & 31)))) == 0)) {
                _787 = _767;
                _788 = _768;
                _789 = _769;
                _790 = _770;
                _791 = _771;
                _792 = _772;
                _793 = _773;
                _794 = (_746 + _503);
                _795 = (_748 + _504);
                _796 = (_750 + _505);
                _797 = (_751 + _506);
                _798 = (_752 + _507);
                _799 = (_753 + _508);
                _800 = (_603 + _509);
              } else {
                _787 = _767;
                _788 = _768;
                _789 = _769;
                _790 = _770;
                _791 = _771;
                _792 = _772;
                _793 = _773;
                _794 = _503;
                _795 = _504;
                _796 = _505;
                _797 = _506;
                _798 = _507;
                _799 = _508;
                _800 = _509;
              }
            } else {
              _787 = _496;
              _788 = _497;
              _789 = _498;
              _790 = _499;
              _791 = _500;
              _792 = _501;
              _793 = _502;
              _794 = _503;
              _795 = _504;
              _796 = _505;
              _797 = _506;
              _798 = _507;
              _799 = _508;
              _800 = _509;
            }
            _801 = _495 + 1u;
            if (!(_801 == _global_0)) {
              _495 = _801;
              _496 = _787;
              _497 = _788;
              _498 = _789;
              _499 = _790;
              _500 = _791;
              _501 = _792;
              _502 = _793;
              _503 = _794;
              _504 = _795;
              _505 = _796;
              _506 = _797;
              _507 = _798;
              _508 = _799;
              _509 = _800;
              continue;
            }
            _805 = _787;
            _806 = _788;
            _807 = _789;
            _808 = _790;
            _809 = _791;
            _810 = _792;
            _811 = _793;
            _812 = _794;
            _813 = _795;
            _814 = _796;
            _815 = _797;
            _816 = _798;
            _817 = _799;
            _818 = _800;
            break;
          }
        } else {
          _805 = 0.0f;
          _806 = 0.0f;
          _807 = 0.0f;
          _808 = 0.0f;
          _809 = 0.0f;
          _810 = 0.0f;
          _811 = 0.0f;
          _812 = 0.0f;
          _813 = 0.0f;
          _814 = 0.0f;
          _815 = 0.0f;
          _816 = 0.0f;
          _817 = 0.0f;
          _818 = 0.0f;
        }
        _824 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_394 & 31)))) != 0);
        if ((_401 > 0.0f) || ((_404 > 0.0f) || _824)) {
          _834 = srvFallbackInfo[((_395 << 2) | 3)].x;
          _836 = select(_824, 9.999999747378752e-05f, (_403 * 3.921568847431445e-09f));
          _837 = _811 * 0.20000000298023224f;
          _844 = saturate((_836 - _837) / (((_811 * 0.4000000059604645f) + 9.99999993922529e-09f) - _837)) * _836;
          [branch]
          if (_844 > 0.0f) {
            [branch]
            if ((int)_834 > (int)-1) {
              _849 = float((int)(_834));
              _850 = -0.0f - _461;
              _851 = !(_849 >= 341.0f);
              [branch]
              if (_851) {
                _862 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_850, _464, _467, _849), _414);
                _867 = _862.x;
                _868 = _862.y;
                _869 = _862.z;
              } else {
                _856 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_850, _464, _467, (_849 + -341.0f)), _414);
                _867 = _856.x;
                _868 = _856.y;
                _869 = _856.z;
              }
              _873 = -0.0f - _470;
              [branch]
              if (_851) {
                _884 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_873, _473, _476, _849), 0.0f);
                _889 = _884.x;
                _890 = _884.y;
                _891 = _884.z;
              } else {
                _878 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_873, _473, _476, (_849 + -341.0f)), 0.0f);
                _889 = _878.x;
                _890 = _878.y;
                _891 = _878.z;
              }
              _902 = ((_867 * _844) + _808);
              _903 = ((_868 * _844) + _809);
              _904 = ((_869 * _844) + _810);
              _905 = ((_889 * _844) + _805);
              _906 = ((_890 * _844) + _806);
              _907 = ((_891 * _844) + _807);
            } else {
              _902 = _808;
              _903 = _809;
              _904 = _810;
              _905 = _805;
              _906 = _806;
              _907 = _807;
            }
            _910 = (_844 + _811);
            _911 = _902;
            _912 = _903;
            _913 = _904;
            _914 = _905;
            _915 = _906;
            _916 = _907;
          } else {
            _910 = _811;
            _911 = _808;
            _912 = _809;
            _913 = _810;
            _914 = _805;
            _915 = _806;
            _916 = _807;
          }
          if (_910 > 0.0f) {
            _922 = (cbSharedPerViewData.vHDRScale.x * _401) / _910;
            _930 = (_922 * _914);
            _931 = (_922 * _915);
            _932 = (_922 * _916);
            _933 = (_922 * _911);
            _934 = (_922 * _912);
            _935 = (_922 * _913);
          } else {
            _930 = 0.0f;
            _931 = 0.0f;
            _932 = 0.0f;
            _933 = 0.0f;
            _934 = 0.0f;
            _935 = 0.0f;
          }
        } else {
          _930 = 0.0f;
          _931 = 0.0f;
          _932 = 0.0f;
          _933 = 0.0f;
          _934 = 0.0f;
          _935 = 0.0f;
        }
        [branch]
        if (!(_404 == 0.0f)) {
          _942 = srvFallbackInfo[((_397 << 2) | 3)].x;
          _943 = _403 * 3.921568847431445e-09f;
          [branch]
          if ((int)_942 > (int)-1) {
            _946 = float((int)(_942));
            _947 = -0.0f - _461;
            _948 = !(_946 >= 341.0f);
            [branch]
            if (_948) {
              _959 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_947, _464, _467, _946), _414);
              _964 = _959.x;
              _965 = _959.y;
              _966 = _959.z;
            } else {
              _953 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_947, _464, _467, (_946 + -341.0f)), _414);
              _964 = _953.x;
              _965 = _953.y;
              _966 = _953.z;
            }
            _970 = -0.0f - _470;
            [branch]
            if (_948) {
              _981 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_970, _473, _476, _946), 0.0f);
              _986 = _981.x;
              _987 = _981.y;
              _988 = _981.z;
            } else {
              _975 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_970, _473, _476, (_946 + -341.0f)), 0.0f);
              _986 = _975.x;
              _987 = _975.y;
              _988 = _975.z;
            }
            _999 = ((_964 * _943) + _815);
            _1000 = ((_965 * _943) + _816);
            _1001 = ((_966 * _943) + _817);
            _1002 = ((_986 * _943) + _812);
            _1003 = ((_987 * _943) + _813);
            _1004 = ((_988 * _943) + _814);
          } else {
            _999 = _815;
            _1000 = _816;
            _1001 = _817;
            _1002 = _812;
            _1003 = _813;
            _1004 = _814;
          }
          _1009 = (cbSharedPerViewData.vHDRScale.x * _404) / (_818 + _943);
          _1023 = ((_1009 * _1002) + _930);
          _1024 = ((_1009 * _1003) + _931);
          _1025 = ((_1009 * _1004) + _932);
          _1026 = ((_1009 * _999) + _933);
          _1027 = ((_1009 * _1000) + _934);
          _1028 = ((_1009 * _1001) + _935);
        } else {
          _1023 = _930;
          _1024 = _931;
          _1025 = _932;
          _1026 = _933;
          _1027 = _934;
          _1028 = _935;
        }
      } else {
        _1023 = 0.0f;
        _1024 = 0.0f;
        _1025 = 0.0f;
        _1026 = 0.0f;
        _1027 = 0.0f;
        _1028 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1047 = (min((_362 / max(9.999999747378752e-05f, _1023)), 1.0f) * _1026);
        _1048 = (min((_364 / max(9.999999747378752e-05f, _1024)), 1.0f) * _1027);
        _1049 = (min((_366 / max(9.999999747378752e-05f, _1025)), 1.0f) * _1028);
      } else {
        _1047 = _1026;
        _1048 = _1027;
        _1049 = _1028;
      }
      _1065 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(saturate(dot(float3(_385, _386, _384), float3(_190, _191, _192))), _201), 0.0f);
      _1068 = _1065.x + _1065.y;
      _1073 = (((1.0f - _1068) * 0.03999999910593033f) / max(9.999999747378752e-06f, _1068)) + 1.0f;
      _1075 = (_1065.x * 0.03999999910593033f) + _1065.y;
      _1076 = min((_169 * _169), _380);
      if (!(_global_1 == 0)) {
        _1080 = 0;
        _1081 = _1076;
        while(true) {
          _1199 = _1081;
          _1082 = _1080 + (uint)(_global_0);
          _1085 = _global_5[min((uint)(_1082), 63u)];
          _1086 = _global_6[min((uint)(_1082), 63u)];
          _1090 = (int)((int)(_1085 << (((int)(31u - _394)) & 31))) >> 31;
          _1094 = (int)((int)(_1085 << ((31 - _396) & 31))) >> 31;
          _1106 = saturate((asfloat((_1090 & asint(_401))) + asfloat((_1094 & asint(_404)))) + asfloat(((_1094 & 1065353216) & _1090)));
          [branch]
          if (!(_1106 == 0.0f)) {
            _1111 = asfloat(srvLightInfoProperties.Load4(_1086)).x;
            _1112 = asfloat(srvLightInfoProperties.Load4(_1086)).y;
            _1113 = asfloat(srvLightInfoProperties.Load4(_1086)).z;
            _1114 = asfloat(srvLightInfoProperties.Load4(_1086)).w;
            _1117 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 16u)))).x;
            _1118 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 16u)))).y;
            _1119 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 16u)))).z;
            _1120 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 16u)))).w;
            _1123 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 32u)))).x;
            _1124 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 32u)))).y;
            _1125 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 32u)))).z;
            _1126 = asfloat(srvLightInfoProperties.Load4(((int)(_1086 + 32u)))).w;
            _1129 = asint(srvLightInfoProperties.Load(((int)(_1086 + 48u))));
            _1132 = asint(srvLightInfoProperties.Load(((int)(_1086 + 52u))));
            _1135 = asint(srvLightInfoProperties.Load(((int)(_1086 + 56u))));
            _1138 = asint(srvLightInfoProperties.Load(((int)(_1086 + 60u))));
            _1153 = mad(_1113, _214, mad(_1112, _213, (_1111 * _212))) + _1114;
            _1157 = mad(_1119, _214, mad(_1118, _213, (_1117 * _212))) + _1120;
            _1161 = mad(_1125, _214, mad(_1124, _213, (_1123 * _212))) + _1126;
            _1186 = saturate(1.0f - ((_1153 + 1.0f) * f16tof32(_1132))) + saturate(1.0f - ((1.0f - _1153) * f16tof32(((uint)((uint)(_1132) >> 16)))));
            _1187 = saturate(1.0f - ((_1157 + 1.0f) * f16tof32(_1135))) + saturate(1.0f - ((1.0f - _1157) * f16tof32(((uint)((uint)(_1135) >> 16)))));
            _1188 = saturate(1.0f - ((_1161 + 1.0f) * f16tof32(_1138))) + saturate(1.0f - ((1.0f - _1161) * f16tof32(((uint)((uint)(_1138) >> 16)))));
            _1191 = saturate(1.0f - dot(float3(_1186, _1187, _1188), float3(_1186, _1187, _1188)));
            _1199 = (saturate(1.0f - ((_1191 * _1191) * (f16tof32(((uint)((uint)(_1129) >> 16))) * _1106))) * _1081);
          } else {
            _1199 = _1081;
          }
          _1200 = _1080 + 1u;
          if (!(_1200 == _global_1)) {
            _1080 = _1200;
            _1081 = _1199;
            continue;
          }
          _1204 = _1199;
          break;
        }
      } else {
        _1204 = _1076;
      }
      _1206 = (_1073 * ((cbSharedPerViewData.vHDRScale.x * _249) + (_1047 * _248))) * _1075;
      _1208 = (_1075 * ((cbSharedPerViewData.vHDRScale.x * _250) + (_1048 * _248))) * _1073;
      _1210 = (_1075 * ((cbSharedPerViewData.vHDRScale.x * _251) + (_1049 * _248))) * _1073;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1217 = _1204;
      } else {
        _1217 = 1.0f;
      }
      if (_401 > 0.0f) {
        _1220 = _395 * 3;
        _1223 = srvRoomInfo[_1220].x;
        _1224 = srvRoomInfo[_1220].y;
        _1225 = srvRoomInfo[_1220].z;
        _1231 = srvRoomInfo[(_1220 + 1)].x;
        _1232 = srvRoomInfo[(_1220 + 1)].y;
        _1233 = srvRoomInfo[(_1220 + 1)].z;
        _1239 = srvRoomInfo[(_1220 + 2)].x;
        _1240 = srvRoomInfo[(_1220 + 2)].y;
        _1241 = srvRoomInfo[(_1220 + 2)].z;
        _1247 = saturate(dot(float3(_190, _191, _192), float3(asfloat(_1223), asfloat(_1224), asfloat(_1225))) + 0.5f);
        _1251 = (_1247 * _1247) * (3.0f - (_1247 * 2.0f));
        _1255 = 1.0f - _1251;
        _1262 = _1217 * _401;
        _1270 = ((_1262 * ((_1255 * asfloat(_1239)) + (_1251 * asfloat(_1231)))) - _361);
        _1271 = ((_1262 * ((_1255 * asfloat(_1240)) + (_1251 * asfloat(_1232)))) - _363);
        _1272 = ((_1262 * ((_1255 * asfloat(_1241)) + (_1251 * asfloat(_1233)))) - _365);
      } else {
        _1270 = _362;
        _1271 = _364;
        _1272 = _366;
      }
      if (_404 > 0.0f) {
        _1275 = _397 * 3;
        _1278 = srvRoomInfo[_1275].x;
        _1279 = srvRoomInfo[_1275].y;
        _1280 = srvRoomInfo[_1275].z;
        _1286 = srvRoomInfo[(_1275 + 1)].x;
        _1287 = srvRoomInfo[(_1275 + 1)].y;
        _1288 = srvRoomInfo[(_1275 + 1)].z;
        _1294 = srvRoomInfo[(_1275 + 2)].x;
        _1295 = srvRoomInfo[(_1275 + 2)].y;
        _1296 = srvRoomInfo[(_1275 + 2)].z;
        _1302 = saturate(dot(float3(_190, _191, _192), float3(asfloat(_1278), asfloat(_1279), asfloat(_1280))) + 0.5f);
        _1306 = (_1302 * _1302) * (3.0f - (_1302 * 2.0f));
        _1310 = 1.0f - _1306;
        _1317 = _1217 * _404;
        _1325 = ((_1317 * ((_1310 * asfloat(_1294)) + (_1306 * asfloat(_1286)))) + _1270);
        _1326 = ((_1317 * ((_1310 * asfloat(_1295)) + (_1306 * asfloat(_1287)))) + _1271);
        _1327 = ((_1317 * ((_1310 * asfloat(_1296)) + (_1306 * asfloat(_1288)))) + _1272);
      } else {
        _1325 = _1270;
        _1326 = _1271;
        _1327 = _1272;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1350 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _214, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _213, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _212))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1354 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _214, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _213, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _212))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1358 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _214, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _213, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _212))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1377 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1358, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1354, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1350))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1381 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1358, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1354, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1350))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1385 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1358, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1354, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1350))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1398 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1399 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1400 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1437 = min(min(saturate((_1377 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1398), 9.999999747378752e-06f)), saturate((1.0f - _1377) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1398), 9.999999747378752e-06f))), min(min(saturate((_1381 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1399), 9.999999747378752e-06f)), saturate((1.0f - _1381) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1399), 9.999999747378752e-06f))), min(saturate((_1385 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1400), 9.999999747378752e-06f)), saturate((1.0f - _1385) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1400), 9.999999747378752e-06f)))));
      } else {
        _1437 = 0.0f;
      }
      _1438 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1438 < (uint)_global_2) {
        _1442 = _1325;
        _1443 = _1326;
        _1444 = _1327;
        _1445 = _1206;
        _1446 = _1208;
        _1447 = _1210;
        _1448 = _1438;
        while(true) {
          _8358 = _1442;
          _8359 = _1443;
          _8360 = _1444;
          _8361 = _1445;
          _8362 = _1446;
          _8363 = _1447;
          _1450 = _global_3[min((uint)(_1448), 63u)];
          _1454 = _global_4[min((uint)(_1448), 63u)];
          _1455 = _global_5[min((uint)(_1448), 63u)];
          _1456 = _global_6[min((uint)(_1448), 63u)];
          _1457 = _1450 & 4095;
          [branch]
          if (((_1454 & 16777216) == 0) && ((((int)(uint(saturate(_154.w) * 255.0f)) & 64) != 0) || ((_1454 & 8388608) == 0))) {
            _1468 = (int)((int)(_1455 << (((int)(31u - _394)) & 31))) >> 31;
            _1472 = (int)((int)(_1455 << ((31 - _396) & 31))) >> 31;
            _1484 = saturate((asfloat((_1468 & asint(_401))) + asfloat((_1472 & asint(_404)))) + asfloat(((_1472 & 1065353216) & _1468)));
            [branch]
            if (!(_1484 == 0.0f)) {
              _1487 = (uint)(_1450) >> 12;
              if (_1487 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _2995 = (_1484 * select(((_1454 & 67108864) != 0), 1.0f, (1.0f - _1437)));
                } else {
                  _2995 = _1484;
                }
                _2998 = asfloat(srvLightInfoProperties.Load4(_1456)).x;
                _2999 = asfloat(srvLightInfoProperties.Load4(_1456)).y;
                _3000 = asfloat(srvLightInfoProperties.Load4(_1456)).z;
                _3001 = asfloat(srvLightInfoProperties.Load4(_1456)).w;
                _3004 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).x;
                _3005 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).y;
                _3006 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).z;
                _3007 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).w;
                _3010 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).x;
                _3011 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).y;
                _3012 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).z;
                _3015 = asint(srvLightInfoProperties.Load(((int)(_1456 + 68u))));
                _3018 = asint(srvLightInfoProperties.Load(((int)(_1456 + 72u))));
                _3021 = asint(srvLightInfoProperties.Load(((int)(_1456 + 76u))));
                _3024 = asint(srvLightInfoProperties.Load(((int)(_1456 + 84u))));
                _3027 = asint(srvLightInfoProperties.Load(((int)(_1456 + 88u))));
                _3030 = asint(srvLightInfoProperties.Load(((int)(_1456 + 92u))));
                _3034 = ((float)((uint)((uint)(((uint)(_3015) >> 8) & 255)))) * 0.003921499941498041f;
                _3037 = ((float)((uint)((uint)(_3015 & 255)))) * 0.003921499941498041f;
                _3039 = f16tof32(((uint)((uint)(_3018) >> 16)));
                _3041 = (uint)(_3021) >> 16;
                _3061 = srvDeferredShadingPass_DeferredShadows.Load(int3(_63, _64, 0));
                [branch]
                if (!(_3061.x == 0.0f)) {
                  [branch]
                  if (!(_3041 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3041)))];
                    _3078 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3000, _214, mad(_2999, _213, (_2998 * _212))) + _3001) * f16tof32(((uint)((uint)(_3027) >> 16)))) + f16tof32(((uint)((uint)(_3030) >> 16)))), (((mad(_3006, _214, mad(_3005, _213, (_3004 * _212))) + _3007) * f16tof32(_3027)) + f16tof32(_3030))), 0.0f);
                    _3086 = (_3078.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _3087 = (_3078.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _3088 = (_3078.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _3086 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _3087 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _3088 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  _3095 = saturate(-0.0f - dot(float3(_385, _386, _384), float3(_3010, _3011, _3012)));
                  _3098 = 1.0f - ((_3095 * _3095) * 0.6399999856948853f);
                  _3104 = ((0.36000001430511475f / (_3098 * _3098)) * _2995) * saturate(0.30000001192092896f - dot(float3(_190, _191, _192), float3(_3010, _3011, _3012)));
                  _3108 = ((_167 * _203) * _3104) + _1445;
                  _3109 = ((_167 * _204) * _3104) + _1446;
                  _3110 = ((_205 * _167) * _3104) + _1447;
                  _3113 = min(_3061.x, _3061.y) * _2995;
                  [branch]
                  if (_3113 > 0.0f) {
                    _3116 = dot(float3(_3010, _3011, _3012), float3(_3010, _3011, _3012));
                    _3117 = rsqrt(_3116);
                    _3118 = _3117 * _3010;
                    _3119 = _3117 * _3011;
                    _3120 = _3117 * _3012;
                    _3121 = dot(float3(_190, _191, _192), float3(_3118, _3119, _3120));
                    if (_3039 > 0.0f) {
                      _3129 = sqrt(saturate((_3039 * _3039) * (1.0f / (_3116 + 1.0f))));
                      if (_3121 < _3129) {
                        _3134 = max(_3121, (-0.0f - _3129)) + _3129;
                        _3139 = ((_3134 * _3134) / (_3129 * 4.0f));
                      } else {
                        _3139 = _3121;
                      }
                    } else {
                      _3139 = _3121;
                    }
                    _3140 = _201 * _201;
                    _3144 = saturate((_3039 * (1.0f - _3140)) * _3117);
                    _3146 = saturate(_3117 * f16tof32(_3018));
                    _3147 = dot(float3(_190, _191, _192), float3(_385, _386, _384));
                    _3148 = dot(float3(_385, _386, _384), float3(_3118, _3119, _3120));
                    _3151 = rsqrt((_3148 * 2.0f) + 2.0f);
                    _3158 = (_3144 > 0.0f);
                    if (_3158) {
                      _3162 = sqrt(1.0f - (_3144 * _3144));
                      _3164 = (_3121 * 2.0f) * _3147;
                      _3165 = _3164 - _3148;
                      if (!(_3165 >= _3162)) {
                        _3173 = rsqrt(1.0f - (_3165 * _3165)) * _3144;
                        _3176 = _3173 * (_3147 - (_3165 * _3121));
                        _3177 = _3147 * _3147;
                        _3182 = _3173 * (((_3177 * 2.0f) + -1.0f) - (_3165 * _3148));
                        _3191 = sqrt(saturate((((1.0f - (_3121 * _3121)) - _3177) - (_3148 * _3148)) + (_3164 * _3148)));
                        _3192 = _3191 * _3173;
                        _3195 = ((_3147 * 2.0f) * _3173) * _3191;
                        _3197 = (_3162 * _3121) + _3147;
                        _3198 = _3197 + _3176;
                        _3199 = _3162 * _3148;
                        _3201 = (_3199 + 1.0f) + _3182;
                        _3202 = _3192 * _3201;
                        _3203 = _3198 * _3201;
                        _3204 = _3195 * _3198;
                        _3209 = (((_3198 * 0.25f) * _3195) - (_3202 * 0.5f)) * _3203;
                        _3223 = (((_3204 - (_3202 * 2.0f)) * _3204) + (_3202 * _3202)) + ((((-0.5f - ((_3201 + _3199) * 0.5f)) * _3203) + ((_3201 * _3201) * _3197)) * _3198);
                        _3228 = (_3209 * 2.0f) / ((_3223 * _3223) + (_3209 * _3209));
                        _3229 = _3223 * _3228;
                        _3231 = 1.0f - (_3209 * _3228);
                        _3237 = ((_3229 * _3195) + _3199) + (_3231 * _3182);
                        _3240 = rsqrt((_3237 * 2.0f) + 2.0f);
                        _3249 = saturate((_3237 * _3240) + _3240);
                        _3250 = saturate(((_3197 + (_3229 * _3192)) + (_3231 * _3176)) * _3240);
                      } else {
                        _3249 = abs(_3147);
                        _3250 = 1.0f;
                      }
                    } else {
                      _3249 = saturate((_3151 * _3148) + _3151);
                      _3250 = saturate(_3151 * (_3147 + _3121));
                    }
                    _3251 = saturate(_3139);
                    _3252 = _3140 * _3140;
                    if (_3146 > 0.0f) {
                      _3262 = saturate(((_3146 * _3146) / ((_3249 * 3.5999999046325684f) + 0.4000000059604645f)) + _3252);
                    } else {
                      _3262 = _3252;
                    }
                    _3263 = sqrt(_3262);
                    if (_3158) {
                      _3274 = (_3262 / ((((_3144 * 0.25f) * ((_3263 * 3.0f) + _3144)) / (_3249 + 0.0010000000474974513f)) + _3262));
                    } else {
                      _3274 = 1.0f;
                    }
                    _3278 = (((_3262 * _3250) - _3250) * _3250) + 1.0f;
                    _3290 = saturate(abs(_3147) + 9.999999747378752e-06f);
                    _3291 = 1.0f - _3263;
                    _3303 = saturate((_3121 + _3037) / (_3037 + 1.0f));
                    [branch]
                    if (!((_3024 & 1) == 0)) {
                      _3319 = max(max(_3086, _3087), _3088);
                      if (_3319 > 0.0f) {
                        _3329 = saturate(_3086 / _3319);
                        _3330 = saturate(_3087 / _3319);
                        _3331 = saturate(_3088 / _3319);
                      } else {
                        _3329 = _3086;
                        _3330 = _3087;
                        _3331 = _3088;
                      }
                      _3332 = (_3330 < _3331);
                      _3333 = select(_3332, _3331, _3330);
                      _3334 = select(_3332, _3330, _3331);
                      _3335 = select(_3332, -1.0f, 0.0f);
                      _3336 = (_3329 < _3333);
                      _3338 = select(_3336, _3333, _3329);
                      _3339 = select(_3336, _3329, _3333);
                      _3343 = _3338 - select((_3339 < _3334), _3339, _3334);
                      _3349 = abs(select(_3336, (-0.3333333432674408f - _3335), _3335) + ((_3339 - _3334) / ((_3343 * 6.0f) + 9.999999682655225e-21f)));
                      if (_3349 < 0.6666666865348816f) {
                        _3362 = ((saturate(((float)((uint)((uint)(((uint)(_3024) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3349 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3349)) + _3349);
                      } else {
                        _3362 = _3349;
                      }
                      _3363 = saturate((_3343 / (_3338 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3024) >> 1) & 255)))) * 0.003921499941498041f));
                      _3364 = saturate(_3338);
                      if (!(_3363 <= 0.0f)) {
                        _3367 = saturate(_3362);
                        _3371 = select(((_3367 * 360.0f) >= 360.0f), 0.0f, (_3367 * 6.0f));
                        _3372 = int(_3371);
                        _3374 = _3371 - float((int)(_3372));
                        _3376 = _3364 * (1.0f - _3363);
                        _3379 = (1.0f - (_3374 * _3363)) * _3364;
                        _3383 = (1.0f - ((1.0f - _3374) * _3363)) * _3364;
                        switch (_3372) {
                          case 0: {
                            _3391 = _3364;
                            _3392 = _3383;
                            _3393 = _3376;
                            break;
                          }
                          case 1: {
                            _3391 = _3379;
                            _3392 = _3364;
                            _3393 = _3376;
                            break;
                          }
                          case 2: {
                            _3391 = _3376;
                            _3392 = _3364;
                            _3393 = _3383;
                            break;
                          }
                          case 3: {
                            _3391 = _3376;
                            _3392 = _3379;
                            _3393 = _3364;
                            break;
                          }
                          case 4: {
                            _3391 = _3383;
                            _3392 = _3376;
                            _3393 = _3364;
                            break;
                          }
                          case 5: {
                            _3391 = _3364;
                            _3392 = _3376;
                            _3393 = _3379;
                            break;
                          }
                          default: {
                            _3391 = 0.0f;
                            _3392 = 0.0f;
                            _3393 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _3391 = _3364;
                        _3392 = _3364;
                        _3393 = _3364;
                      }
                      _3394 = _3391 * _3319;
                      _3395 = _3392 * _3319;
                      _3396 = _3393 * _3319;
                      _3398 = saturate(_3113 * 1.0101009607315063f);
                      _3409 = ((_3398 * (_3086 - _3394)) + _3394);
                      _3410 = ((_3398 * (_3087 - _3395)) + _3395);
                      _3411 = (lerp(_3396, _3088, _3398));
                    } else {
                      _3409 = _3086;
                      _3410 = _3087;
                      _3411 = _3088;
                    }
                    _3412 = _3409 * _3113;
                    _3413 = _3410 * _3113;
                    _3414 = _3411 * _3113;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _3424 = (_3412 * _1204);
                      _3425 = (_3413 * _1204);
                      _3426 = (_3414 * _1204);
                    } else {
                      _3424 = _3412;
                      _3425 = _3413;
                      _3426 = _3414;
                    }
                    _3430 = (_3424 * _3303) + _1442;
                    _3431 = (_3425 * _3303) + _1443;
                    _3432 = (_3426 * _3303) + _1444;
                    if (_3034 > 0.0f) {
                      _3436 = ((_3034 * _1073) * ((exp2(log2(1.0f - saturate(_3249)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f)) * (((_3274 * _3251) * (_3262 / (_3278 * _3278))) * (0.5f / ((((_3291 * _3290) + _3263) * _3251) + (((_3291 * _3251) + _3263) * _3290))));
                      _8358 = _3430;
                      _8359 = _3431;
                      _8360 = _3432;
                      _8361 = ((_3436 * _3424) + _3108);
                      _8362 = ((_3436 * _3425) + _3109);
                      _8363 = ((_3436 * _3426) + _3110);
                    } else {
                      _8358 = _3430;
                      _8359 = _3431;
                      _8360 = _3432;
                      _8361 = _3108;
                      _8362 = _3109;
                      _8363 = _3110;
                    }
                  } else {
                    _8358 = _1442;
                    _8359 = _1443;
                    _8360 = _1444;
                    _8361 = _3108;
                    _8362 = _3109;
                    _8363 = _3110;
                  }
                } else {
                  _8358 = _1442;
                  _8359 = _1443;
                  _8360 = _1444;
                  _8361 = _1445;
                  _8362 = _1446;
                  _8363 = _1447;
                }
              } else {
                _1504 = _1484 * select(((_1454 & 67108864) != 0), 1.0f, (1.0f - _1437));
                [branch]
                if (_1487 == 4) {
                  _1509 = asfloat(srvLightInfoProperties.Load4(_1456)).x;
                  _1510 = asfloat(srvLightInfoProperties.Load4(_1456)).y;
                  _1511 = asfloat(srvLightInfoProperties.Load4(_1456)).z;
                  _1512 = asfloat(srvLightInfoProperties.Load4(_1456)).w;
                  _1515 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).x;
                  _1516 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).y;
                  _1517 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).z;
                  _1518 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).w;
                  _1521 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).x;
                  _1522 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).y;
                  _1523 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).z;
                  _1524 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).w;
                  _1527 = asint(srvLightInfoProperties.Load(((int)(_1456 + 48u))));
                  _1530 = asint(srvLightInfoProperties.Load(((int)(_1456 + 52u))));
                  _1533 = asint(srvLightInfoProperties.Load(((int)(_1456 + 64u))));
                  _1536 = asint(srvLightInfoProperties.Load(((int)(_1456 + 68u))));
                  _1539 = asint(srvLightInfoProperties.Load(((int)(_1456 + 72u))));
                  _1541 = f16tof32(((uint)((uint)(_1527) >> 16)));
                  _1542 = f16tof32(_1527);
                  _1544 = f16tof32(((uint)((uint)(_1530) >> 16)));
                  _1548 = ((float)((uint)((uint)(((uint)(_1530) >> 8) & 255)))) * 0.003921499941498041f;
                  _1561 = mad(_1511, _214, mad(_1510, _213, (_1509 * _212))) + _1512;
                  _1565 = mad(_1517, _214, mad(_1516, _213, (_1515 * _212))) + _1518;
                  _1569 = mad(_1523, _214, mad(_1522, _213, (_1521 * _212))) + _1524;
                  _1594 = saturate(1.0f - ((_1561 + 1.0f) * f16tof32(_1533))) + saturate(1.0f - ((1.0f - _1561) * f16tof32(((uint)((uint)(_1533) >> 16)))));
                  _1595 = saturate(1.0f - ((_1565 + 1.0f) * f16tof32(_1536))) + saturate(1.0f - ((1.0f - _1565) * f16tof32(((uint)((uint)(_1536) >> 16)))));
                  _1596 = saturate(1.0f - ((_1569 + 1.0f) * f16tof32(_1539))) + saturate(1.0f - ((1.0f - _1569) * f16tof32(((uint)((uint)(_1539) >> 16)))));
                  _1599 = saturate(1.0f - dot(float3(_1594, _1595, _1596), float3(_1594, _1595, _1596)));
                  _1600 = _1599 * _1599;
                  _1607 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1600 * _1204), _1600) * _1504;
                  _8358 = ((_1607 * _1541) + _1442);
                  _8359 = ((_1607 * _1542) + _1443);
                  _8360 = ((_1607 * _1544) + _1444);
                  _8361 = (((_1548 * _1541) * _1607) + _1445);
                  _8362 = (((_1548 * _1542) * _1607) + _1446);
                  _8363 = (((_1544 * _1548) * _1607) + _1447);
                } else {
                  if (_1487 == 5) {
                    _1628 = asfloat(srvLightInfoProperties.Load4(_1456)).x;
                    _1629 = asfloat(srvLightInfoProperties.Load4(_1456)).y;
                    _1630 = asfloat(srvLightInfoProperties.Load4(_1456)).z;
                    _1631 = asfloat(srvLightInfoProperties.Load4(_1456)).w;
                    _1634 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).x;
                    _1635 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).y;
                    _1636 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).z;
                    _1637 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).w;
                    _1640 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).x;
                    _1641 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).y;
                    _1642 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).z;
                    _1643 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).w;
                    _1646 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).x;
                    _1647 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).y;
                    _1648 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).z;
                    _1651 = asfloat(srvLightInfoProperties.Load(((int)(_1456 + 60u))));
                    _1654 = asint(srvLightInfoProperties.Load(((int)(_1456 + 64u))));
                    _1657 = asint(srvLightInfoProperties.Load(((int)(_1456 + 68u))));
                    _1660 = asint(srvLightInfoProperties.Load(((int)(_1456 + 80u))));
                    _1663 = asint(srvLightInfoProperties.Load(((int)(_1456 + 84u))));
                    _1666 = asint(srvLightInfoProperties.Load(((int)(_1456 + 88u))));
                    _1669 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 92u)))).x;
                    _1670 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 92u)))).y;
                    _1671 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 92u)))).z;
                    _1672 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 92u)))).w;
                    _1675 = asint(srvLightInfoProperties.Load(((int)(_1456 + 108u))));
                    _1678 = asint(srvLightInfoProperties.Load(((int)(_1456 + 112u))));
                    _1681 = asint(srvLightInfoProperties.Load(((int)(_1456 + 120u))));
                    _1684 = asint(srvLightInfoProperties.Load(((int)(_1456 + 124u))));
                    _1687 = asint(srvLightInfoProperties.Load(((int)(_1456 + 128u))));
                    _1690 = asint(srvLightInfoProperties.Load(((int)(_1456 + 132u))));
                    _1693 = asint(srvLightInfoProperties.Load(((int)(_1456 + 136u))));
                    _1696 = asint(srvLightInfoProperties.Load(((int)(_1456 + 140u))));
                    _1698 = f16tof32(((uint)((uint)(_1654) >> 16)));
                    _1699 = f16tof32(_1654);
                    _1701 = f16tof32(((uint)((uint)(_1657) >> 16)));
                    _1705 = ((float)((uint)((uint)(((uint)(_1657) >> 8) & 255)))) * 0.003921499941498041f;
                    _1708 = ((float)((uint)((uint)(_1657 & 255)))) * 0.003921499941498041f;
                    _1710 = f16tof32(((uint)((uint)(_1660) >> 16)));
                    _1713 = _1663 & 65535;
                    _1723 = f16tof32(((uint)((uint)(_1678) >> 16)));
                    _1724 = f16tof32(_1678);
                    _1726 = f16tof32(((uint)((uint)(_1681) >> 16)));
                    _1727 = 1.0f / _1726;
                    _1728 = _1726 + -1.0f;
                    _1729 = f16tof32(_1681);
                    _1745 = dot(float3(_190, _191, _192), float3(_1646, _1647, _1648));
                    _1748 = saturate(1.0f - _1745) * f16tof32(_1675);
                    _1752 = (_1748 * _190) + _212;
                    _1753 = (_1748 * _191) + _213;
                    _1754 = (_1748 * _192) - _211;
                    _1758 = mad(_1630, _1754, mad(_1629, _1753, (_1752 * _1628))) + _1631;
                    _1762 = mad(_1636, _1754, mad(_1635, _1753, (_1752 * _1634))) + _1637;
                    _1766 = mad(_1642, _1754, mad(_1641, _1753, (_1752 * _1640))) + _1643;
                    _1767 = saturate(_1766);
                    _1790 = saturate(1.0f - (_1758 * f16tof32(_1690))) + saturate(1.0f - ((1.0f - _1758) * f16tof32(((uint)((uint)(_1690) >> 16)))));
                    _1791 = saturate(1.0f - (_1762 * f16tof32(_1693))) + saturate(1.0f - ((1.0f - _1762) * f16tof32(((uint)((uint)(_1693) >> 16)))));
                    _1792 = saturate(1.0f - (_1766 * f16tof32(_1696))) + saturate(1.0f - ((1.0f - _1766) * f16tof32(((uint)((uint)(_1696) >> 16)))));
                    _1795 = saturate(1.0f - dot(float3(_1790, _1791, _1792), float3(_1790, _1791, _1792)));
                    _1796 = _1795 * _1795;
                    if (!(((_1454 & 3584) == 0) || (!(_1796 > 0.0f)))) {
                      _1803 = 1.0f - _1767;
                      _1804 = saturate(_1758);
                      _1805 = saturate(_1762);
                      bool __branch_chain_1800;
                      [branch]
                      if ((_1454 & 1024) == 0) {
                        _2068 = 1.0f;
                        _2069 = 0.0f;
                        _2070 = _1803;
                        __branch_chain_1800 = true;
                      } else {
                        _1810 = ((_1804 * _1728) + 0.5f) * _1727;
                        _1812 = ((_1805 * _1728) + 0.5f) * _1727;
                        _1813 = _1803 + f16tof32(((uint)((uint)(_1675) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1663) >> 16))];
                        _1816 = saturate(_1813);
                        _1820 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1829 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1820 * 32.665000915527344f) + _125), ((_1820 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1830 = sin(_1829);
                        _1831 = cos(_1829);
                        _1832 = cbSharedPerViewData.nFrameCounter & 3;
                        _1837 = sqrt((float((int)(_1832)) * 0.25f) + 0.125f) * _1723;
                        _1846 = (_global_7[min((uint)(((int)(0u + (_1832 * 2)))), 127u)]) * _1837;
                        _1847 = (_global_7[min((uint)(((int)(1u + (_1832 * 2)))), 127u)]) * _1837;
                        _1849 = -0.0f - _1830;
                        _1854 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1846, _1847), float2(_1831, _1830)) + _1810), (dot(float2(_1846, _1847), float2(_1849, _1831)) + _1812)));
                        _1859 = _1854.x - _1816;
                        _1861 = select((_1859 < 0.0f), 0.0f, 1.0f);
                        _1863 = _1854.y - _1816;
                        _1865 = select((_1863 < 0.0f), 0.0f, 1.0f);
                        _1869 = _1854.z - _1816;
                        _1871 = select((_1869 < 0.0f), 0.0f, 1.0f);
                        _1875 = _1854.w - _1816;
                        _1877 = select((_1875 < 0.0f), 0.0f, 1.0f);
                        _1884 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _1889 = sqrt((float((int)(_1884)) * 0.25f) + 0.125f) * _1723;
                        _1898 = (_global_7[min((uint)(((int)(0u + (_1884 * 2)))), 127u)]) * _1889;
                        _1899 = (_global_7[min((uint)(((int)(1u + (_1884 * 2)))), 127u)]) * _1889;
                        _1905 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1898, _1899), float2(_1831, _1830)) + _1810), (dot(float2(_1898, _1899), float2(_1849, _1831)) + _1812)));
                        _1910 = _1905.x - _1816;
                        _1912 = select((_1910 < 0.0f), 0.0f, 1.0f);
                        _1916 = _1905.y - _1816;
                        _1918 = select((_1916 < 0.0f), 0.0f, 1.0f);
                        _1922 = _1905.z - _1816;
                        _1924 = select((_1922 < 0.0f), 0.0f, 1.0f);
                        _1928 = _1905.w - _1816;
                        _1930 = select((_1928 < 0.0f), 0.0f, 1.0f);
                        _1937 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _1942 = sqrt((float((int)(_1937)) * 0.25f) + 0.125f) * _1723;
                        _1951 = (_global_7[min((uint)(((int)(0u + (_1937 * 2)))), 127u)]) * _1942;
                        _1952 = (_global_7[min((uint)(((int)(1u + (_1937 * 2)))), 127u)]) * _1942;
                        _1958 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1951, _1952), float2(_1831, _1830)) + _1810), (dot(float2(_1951, _1952), float2(_1849, _1831)) + _1812)));
                        _1963 = _1958.x - _1816;
                        _1965 = select((_1963 < 0.0f), 0.0f, 1.0f);
                        _1969 = _1958.y - _1816;
                        _1971 = select((_1969 < 0.0f), 0.0f, 1.0f);
                        _1975 = _1958.z - _1816;
                        _1977 = select((_1975 < 0.0f), 0.0f, 1.0f);
                        _1981 = _1958.w - _1816;
                        _1983 = select((_1981 < 0.0f), 0.0f, 1.0f);
                        _1990 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _1995 = sqrt((float((int)(_1990)) * 0.25f) + 0.125f) * _1723;
                        _2004 = (_global_7[min((uint)(((int)(0u + (_1990 * 2)))), 127u)]) * _1995;
                        _2005 = (_global_7[min((uint)(((int)(1u + (_1990 * 2)))), 127u)]) * _1995;
                        _2011 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2004, _2005), float2(_1831, _1830)) + _1810), (dot(float2(_2004, _2005), float2(_1849, _1831)) + _1812)));
                        _2016 = _2011.x - _1816;
                        _2018 = select((_2016 < 0.0f), 0.0f, 1.0f);
                        _2022 = _2011.y - _1816;
                        _2024 = select((_2022 < 0.0f), 0.0f, 1.0f);
                        _2028 = _2011.z - _1816;
                        _2030 = select((_2028 < 0.0f), 0.0f, 1.0f);
                        _2034 = _2011.w - _1816;
                        _2036 = select((_2034 < 0.0f), 0.0f, 1.0f);
                        _2037 = ((((((((((((((_1861 + _1865) + _1871) + _1877) + _1912) + _1918) + _1924) + _1930) + _1965) + _1971) + _1977) + _1983) + _2018) + _2024) + _2030) + _2036;
                        _2048 = (saturate(_2037 * 0.0625f) * 2.0f) + -1.0f;
                        _2054 = float((int)(((int)(uint)((int)(_2048 > 0.0f))) - ((int)(uint)((int)(_2048 < 0.0f)))));
                        _2056 = 1.0f - (_2054 * _2048);
                        _2058 = (_2056 * _2056) * _2056;
                        _2065 = 0.5f - ((_2054 * 0.5f) * ((1.0f - _2058) - ((_2056 - _2058) * saturate(((1.0f / _1816) * (1.0f / _2037)) * ((((((((((((((((_1861 * _1859) + (_1865 * _1863)) + (_1871 * _1869)) + (_1877 * _1875)) + (_1912 * _1910)) + (_1918 * _1916)) + (_1924 * _1922)) + (_1930 * _1928)) + (_1965 * _1963)) + (_1971 * _1969)) + (_1977 * _1975)) + (_1983 * _1981)) + (_2018 * _2016)) + (_2024 * _2022)) + (_2030 * _2028)) + (_2036 * _2034))))));
                        [branch]
                        if (_1729 < 1.0f) {
                          _2068 = _2065;
                          _2069 = _1729;
                          _2070 = _1813;
                          __branch_chain_1800 = true;
                        } else {
                          _2538 = _2065;
                          __branch_chain_1800 = false;
                        }
                      }
                      if (__branch_chain_1800) {
                        _2073 = (_1804 * _1669) + _1671;
                        _2074 = (_1805 * _1670) + _1672;
                        if (!((_1454 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _2083 = saturate(_2070);
                          _2087 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2096 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2087 * 32.665000915527344f) + _125), ((_2087 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2097 = sin(_2096);
                          _2098 = cos(_2096);
                          _2103 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2073, _2074), 0.0f))).x) > _2083), 1.0f, 0.0f);
                          _2104 = cbSharedPerViewData.nFrameCounter & 3;
                          _2109 = sqrt((float((int)(_2104)) * 0.25f) + 0.125f) * _1724;
                          _2118 = (_global_7[min((uint)(((int)(0u + (_2104 * 2)))), 127u)]) * _2109;
                          _2119 = (_global_7[min((uint)(((int)(1u + (_2104 * 2)))), 127u)]) * _2109;
                          _2121 = -0.0f - _2097;
                          _2123 = dot(float2(_2118, _2119), float2(_2098, _2097)) + _2073;
                          _2124 = dot(float2(_2118, _2119), float2(_2121, _2098)) + _2074;
                          _2126 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2123, _2124));
                          _2130 = _2123 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2131 = _2124 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2134 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1671);
                          _2135 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1672);
                          _2140 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1669 + _1671)) + 0.5f);
                          _2141 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1670 + _1672)) + 0.5f);
                          _2144 = floor(_2130 + -0.5f);
                          _2145 = floor(_2131 + 0.5f);
                          _2147 = floor(_2130 + 0.5f);
                          _2149 = floor(_2131 + -0.5f);
                          _2150 = (_2144 < _2134);
                          _2151 = (_2145 < _2135);
                          if ((_2150 || _2151) | ((_2144 >= _2140) || (_2145 >= _2141))) {
                            _2160 = _2103;
                          } else {
                            _2160 = _2126.x;
                          }
                          _2161 = (_2147 < _2134);
                          if ((_2161 || _2151) | ((_2147 >= _2140) || (_2145 >= _2141))) {
                            _2169 = _2103;
                          } else {
                            _2169 = _2126.y;
                          }
                          _2170 = (_2149 < _2135);
                          if ((_2161 || _2170) | ((_2147 >= _2140) || (_2149 >= _2141))) {
                            _2178 = _2103;
                          } else {
                            _2178 = _2126.z;
                          }
                          if ((_2150 || _2170) | ((_2144 >= _2140) || (_2149 >= _2141))) {
                            _2186 = _2103;
                          } else {
                            _2186 = _2126.w;
                          }
                          _2187 = _2160 - _2083;
                          _2189 = select((_2187 < 0.0f), 0.0f, 1.0f);
                          _2191 = _2169 - _2083;
                          _2193 = select((_2191 < 0.0f), 0.0f, 1.0f);
                          _2197 = _2178 - _2083;
                          _2199 = select((_2197 < 0.0f), 0.0f, 1.0f);
                          _2203 = _2186 - _2083;
                          _2205 = select((_2203 < 0.0f), 0.0f, 1.0f);
                          _2212 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2217 = sqrt((float((int)(_2212)) * 0.25f) + 0.125f) * _1724;
                          _2226 = (_global_7[min((uint)(((int)(0u + (_2212 * 2)))), 127u)]) * _2217;
                          _2227 = (_global_7[min((uint)(((int)(1u + (_2212 * 2)))), 127u)]) * _2217;
                          _2230 = dot(float2(_2226, _2227), float2(_2098, _2097)) + _2073;
                          _2231 = dot(float2(_2226, _2227), float2(_2121, _2098)) + _2074;
                          _2233 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2230, _2231));
                          _2237 = _2230 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2238 = _2231 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2241 = floor(_2237 + -0.5f);
                          _2242 = floor(_2238 + 0.5f);
                          _2244 = floor(_2237 + 0.5f);
                          _2246 = floor(_2238 + -0.5f);
                          _2247 = (_2241 < _2134);
                          _2248 = (_2242 < _2135);
                          if ((_2247 || _2248) | ((_2241 >= _2140) || (_2242 >= _2141))) {
                            _2257 = _2103;
                          } else {
                            _2257 = _2233.x;
                          }
                          _2258 = (_2244 < _2134);
                          if ((_2258 || _2248) | ((_2244 >= _2140) || (_2242 >= _2141))) {
                            _2266 = _2103;
                          } else {
                            _2266 = _2233.y;
                          }
                          _2267 = (_2246 < _2135);
                          if ((_2258 || _2267) | ((_2244 >= _2140) || (_2246 >= _2141))) {
                            _2275 = _2103;
                          } else {
                            _2275 = _2233.z;
                          }
                          if ((_2247 || _2267) | ((_2241 >= _2140) || (_2246 >= _2141))) {
                            _2283 = _2103;
                          } else {
                            _2283 = _2233.w;
                          }
                          _2284 = _2257 - _2083;
                          _2286 = select((_2284 < 0.0f), 0.0f, 1.0f);
                          _2290 = _2266 - _2083;
                          _2292 = select((_2290 < 0.0f), 0.0f, 1.0f);
                          _2296 = _2275 - _2083;
                          _2298 = select((_2296 < 0.0f), 0.0f, 1.0f);
                          _2302 = _2283 - _2083;
                          _2304 = select((_2302 < 0.0f), 0.0f, 1.0f);
                          _2311 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2316 = sqrt((float((int)(_2311)) * 0.25f) + 0.125f) * _1724;
                          _2325 = (_global_7[min((uint)(((int)(0u + (_2311 * 2)))), 127u)]) * _2316;
                          _2326 = (_global_7[min((uint)(((int)(1u + (_2311 * 2)))), 127u)]) * _2316;
                          _2329 = dot(float2(_2325, _2326), float2(_2098, _2097)) + _2073;
                          _2330 = dot(float2(_2325, _2326), float2(_2121, _2098)) + _2074;
                          _2332 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2329, _2330));
                          _2336 = _2329 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2337 = _2330 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2340 = floor(_2336 + -0.5f);
                          _2341 = floor(_2337 + 0.5f);
                          _2343 = floor(_2336 + 0.5f);
                          _2345 = floor(_2337 + -0.5f);
                          _2346 = (_2340 < _2134);
                          _2347 = (_2341 < _2135);
                          if ((_2346 || _2347) | ((_2340 >= _2140) || (_2341 >= _2141))) {
                            _2356 = _2103;
                          } else {
                            _2356 = _2332.x;
                          }
                          _2357 = (_2343 < _2134);
                          if ((_2357 || _2347) | ((_2343 >= _2140) || (_2341 >= _2141))) {
                            _2365 = _2103;
                          } else {
                            _2365 = _2332.y;
                          }
                          _2366 = (_2345 < _2135);
                          if ((_2357 || _2366) | ((_2343 >= _2140) || (_2345 >= _2141))) {
                            _2374 = _2103;
                          } else {
                            _2374 = _2332.z;
                          }
                          if ((_2346 || _2366) | ((_2340 >= _2140) || (_2345 >= _2141))) {
                            _2382 = _2103;
                          } else {
                            _2382 = _2332.w;
                          }
                          _2383 = _2356 - _2083;
                          _2385 = select((_2383 < 0.0f), 0.0f, 1.0f);
                          _2389 = _2365 - _2083;
                          _2391 = select((_2389 < 0.0f), 0.0f, 1.0f);
                          _2395 = _2374 - _2083;
                          _2397 = select((_2395 < 0.0f), 0.0f, 1.0f);
                          _2401 = _2382 - _2083;
                          _2403 = select((_2401 < 0.0f), 0.0f, 1.0f);
                          _2410 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2415 = sqrt((float((int)(_2410)) * 0.25f) + 0.125f) * _1724;
                          _2424 = (_global_7[min((uint)(((int)(0u + (_2410 * 2)))), 127u)]) * _2415;
                          _2425 = (_global_7[min((uint)(((int)(1u + (_2410 * 2)))), 127u)]) * _2415;
                          _2428 = dot(float2(_2424, _2425), float2(_2098, _2097)) + _2073;
                          _2429 = dot(float2(_2424, _2425), float2(_2121, _2098)) + _2074;
                          _2431 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2428, _2429));
                          _2435 = _2428 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2436 = _2429 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2439 = floor(_2435 + -0.5f);
                          _2440 = floor(_2436 + 0.5f);
                          _2442 = floor(_2435 + 0.5f);
                          _2444 = floor(_2436 + -0.5f);
                          _2445 = (_2439 < _2134);
                          _2446 = (_2440 < _2135);
                          if ((_2445 || _2446) | ((_2439 >= _2140) || (_2440 >= _2141))) {
                            _2455 = _2103;
                          } else {
                            _2455 = _2431.x;
                          }
                          _2456 = (_2442 < _2134);
                          if ((_2456 || _2446) | ((_2442 >= _2140) || (_2440 >= _2141))) {
                            _2464 = _2103;
                          } else {
                            _2464 = _2431.y;
                          }
                          _2465 = (_2444 < _2135);
                          if ((_2456 || _2465) | ((_2442 >= _2140) || (_2444 >= _2141))) {
                            _2473 = _2103;
                          } else {
                            _2473 = _2431.z;
                          }
                          if ((_2445 || _2465) | ((_2439 >= _2140) || (_2444 >= _2141))) {
                            _2481 = _2103;
                          } else {
                            _2481 = _2431.w;
                          }
                          _2482 = _2455 - _2083;
                          _2484 = select((_2482 < 0.0f), 0.0f, 1.0f);
                          _2488 = _2464 - _2083;
                          _2490 = select((_2488 < 0.0f), 0.0f, 1.0f);
                          _2494 = _2473 - _2083;
                          _2496 = select((_2494 < 0.0f), 0.0f, 1.0f);
                          _2500 = _2481 - _2083;
                          _2502 = select((_2500 < 0.0f), 0.0f, 1.0f);
                          _2503 = ((((((((((((((_2193 + _2189) + _2199) + _2205) + _2286) + _2292) + _2298) + _2304) + _2385) + _2391) + _2397) + _2403) + _2484) + _2490) + _2496) + _2502;
                          _2514 = (saturate(_2503 * 0.0625f) * 2.0f) + -1.0f;
                          _2520 = float((int)(((int)(uint)((int)(_2514 > 0.0f))) - ((int)(uint)((int)(_2514 < 0.0f)))));
                          _2522 = 1.0f - (_2520 * _2514);
                          _2524 = (_2522 * _2522) * _2522;
                          _2533 = (0.5f - ((_2520 * 0.5f) * ((1.0f - _2524) - ((_2522 - _2524) * saturate(((1.0f / _2083) * (1.0f / _2503)) * ((((((((((((((((_2193 * _2191) + (_2189 * _2187)) + (_2199 * _2197)) + (_2205 * _2203)) + (_2286 * _2284)) + (_2292 * _2290)) + (_2298 * _2296)) + (_2304 * _2302)) + (_2385 * _2383)) + (_2391 * _2389)) + (_2397 * _2395)) + (_2403 * _2401)) + (_2484 * _2482)) + (_2490 * _2488)) + (_2496 * _2494)) + (_2502 * _2500)))))));
                        } else {
                          _2533 = 1.0f;
                        }
                        _2538 = (lerp(_2533, _2068, _2069));
                      }
                      [branch]
                      if (!((_1454 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1666) >> 16))];
                        _2544 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1758, _1762), 0.0f);
                        if (_2544.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1666 & 65535))];
                          _2551 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1758, _1762), 0.0f);
                          _2565 = mad(saturate(((log2(_1767 * _1651) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2566 = max(9.999999747378752e-06f, _2544.x);
                          _2567 = _2551.x / _2566;
                          _2568 = _2551.y / _2566;
                          _2570 = _2551.w / _2566;
                          _2575 = ((0.375f - _2568) * 4.999999873689376e-06f) + _2568;
                          _2578 = -0.0f - _2567;
                          _2579 = mad(_2578, _2575, (_2551.z / _2566));
                          _2581 = 1.0f / mad(_2578, _2567, _2575);
                          _2582 = _2581 * _2579;
                          _2587 = _2565 - _2567;
                          _2592 = (((_2565 * _2565) - _2575) - (_2582 * _2587)) / mad((-0.0f - _2579), _2582, mad((-0.0f - _2575), _2575, (((0.375f - _2570) * 4.999999873689376e-06f) + _2570)));
                          _2594 = (_2581 * _2587) - (_2592 * _2582);
                          _2597 = 1.0f / _2592;
                          _2598 = _2594 * _2597;
                          _2603 = sqrt(((_2598 * _2598) * 0.25f) - ((1.0f - dot(float2(_2594, _2592), float2(_2567, _2575))) * _2597));
                          _2605 = (_2598 * -0.5f) - _2603;
                          _2607 = _2603 - (_2598 * 0.5f);
                          _2609 = select((_2605 < _2565), 1.0f, 0.0f);
                          _2614 = (_2609 + -0.05000000074505806f) / (_2605 - _2565);
                          _2620 = (((select((_2607 < _2565), 1.0f, 0.0f) - _2609) / (_2607 - _2605)) - _2614) / (_2607 - _2565);
                          _2622 = _2614 - (_2620 * _2605);
                          _2635 = (exp2((_2544.x * -1.4426950216293335f) * saturate((dot(float2(_2567, _2575), float2((_2622 - (_2620 * _2565)), _2620)) + 0.05000000074505806f) - (_2622 * _2565))) * _2538);
                        } else {
                          _2635 = _2538;
                        }
                      } else {
                        _2635 = _2538;
                      }
                    } else {
                      _2635 = 1.0f;
                    }
                    [branch]
                    if (!(_1713 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1713)))];
                      _2648 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1758 * f16tof32(((uint)((uint)(_1684) >> 16)))) + f16tof32(((uint)((uint)(_1687) >> 16)))), ((_1762 * f16tof32(_1684)) + f16tof32(_1687))), 0.0f);
                      _2656 = (_2648.x * _1698);
                      _2657 = (_2648.y * _1699);
                      _2658 = (_2648.z * _1701);
                    } else {
                      _2656 = _1698;
                      _2657 = _1699;
                      _2658 = _1701;
                    }
                    _2659 = _2635 * _1796;
                    [branch]
                    if (!(_2659 == 0.0f)) {
                      bool __branch_chain_2661;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2677 = 0;
                        __branch_chain_2661 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2677 = 1;
                          __branch_chain_2661 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2677 = 2;
                            __branch_chain_2661 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2677 = 3;
                              __branch_chain_2661 = true;
                            } else {
                              _2698 = _2659;
                              __branch_chain_2661 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2661) {
                        while(true) {
                          _2680 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                          if (_2677 == 0) {
                            _2694 = _2680.x;
                          } else {
                            if (_2677 == 1) {
                              _2694 = _2680.y;
                            } else {
                              if (_2677 == 2) {
                                _2694 = _2680.z;
                              } else {
                                _2694 = _2680.w;
                              }
                            }
                          }
                          _2698 = ((_2694 * _2694) * _1796);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2698 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2708 = srvLightMappingData[_1457];
                            if (!(_2708 == -1)) {
                              _2713 = srvLightIndexData[_2708].nLayerIndex;
                              _2715 = srvLightIndexData[_2708].vAtlasOrigin.x;
                              _2716 = srvLightIndexData[_2708].vAtlasOrigin.y;
                              _2718 = srvLightIndexData[_2708].vScreenOrigin.x;
                              _2719 = srvLightIndexData[_2708].vScreenOrigin.y;
                              _2728 = ((int)(_2713 * 5)) & 31;
                              _2737 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2715 + _63) - _2718)), ((int)((_2716 + _64) - _2719)), 0)))).x) & ((int)(31 << _2728)))) >> _2728)) >> 1)))) * 0.06666667014360428f) * _2698);
                            } else {
                              _2737 = _2698;
                            }
                          } else {
                            _2737 = _2698;
                          }
                          _2741 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2744 = select(_2741, (_2737 * _1204), _2737);
                          _2746 = dot(float3(_1646, _1647, _1648), float3(_1646, _1647, _1648));
                          _2747 = rsqrt(_2746);
                          _2748 = _2747 * _1646;
                          _2749 = _2747 * _1647;
                          _2750 = _2747 * _1648;
                          _2751 = dot(float3(_190, _191, _192), float3(_2748, _2749, _2750));
                          if (_1710 > 0.0f) {
                            _2759 = sqrt(saturate((_1710 * _1710) * (1.0f / (_2746 + 1.0f))));
                            if (_2751 < _2759) {
                              _2764 = max(_2751, (-0.0f - _2759)) + _2759;
                              _2769 = ((_2764 * _2764) / (_2759 * 4.0f));
                            } else {
                              _2769 = _2751;
                            }
                          } else {
                            _2769 = _2751;
                          }
                          _2770 = _201 * _201;
                          _2774 = saturate((_1710 * (1.0f - _2770)) * _2747);
                          _2776 = saturate(_2747 * f16tof32(_1660));
                          _2777 = dot(float3(_190, _191, _192), float3(_385, _386, _384));
                          _2778 = dot(float3(_385, _386, _384), float3(_2748, _2749, _2750));
                          _2781 = rsqrt((_2778 * 2.0f) + 2.0f);
                          _2788 = (_2774 > 0.0f);
                          if (_2788) {
                            _2792 = sqrt(1.0f - (_2774 * _2774));
                            _2794 = (_2751 * 2.0f) * _2777;
                            _2795 = _2794 - _2778;
                            if (!(_2795 >= _2792)) {
                              _2803 = rsqrt(1.0f - (_2795 * _2795)) * _2774;
                              _2806 = _2803 * (_2777 - (_2795 * _2751));
                              _2807 = _2777 * _2777;
                              _2812 = _2803 * (((_2807 * 2.0f) + -1.0f) - (_2795 * _2778));
                              _2821 = sqrt(saturate((((1.0f - (_2751 * _2751)) - _2807) - (_2778 * _2778)) + (_2794 * _2778)));
                              _2822 = _2821 * _2803;
                              _2825 = ((_2777 * 2.0f) * _2803) * _2821;
                              _2827 = (_2792 * _2751) + _2777;
                              _2828 = _2827 + _2806;
                              _2829 = _2792 * _2778;
                              _2831 = (_2829 + 1.0f) + _2812;
                              _2832 = _2822 * _2831;
                              _2833 = _2828 * _2831;
                              _2834 = _2825 * _2828;
                              _2839 = (((_2828 * 0.25f) * _2825) - (_2832 * 0.5f)) * _2833;
                              _2853 = (((_2834 - (_2832 * 2.0f)) * _2834) + (_2832 * _2832)) + ((((-0.5f - ((_2831 + _2829) * 0.5f)) * _2833) + ((_2831 * _2831) * _2827)) * _2828);
                              _2858 = (_2839 * 2.0f) / ((_2853 * _2853) + (_2839 * _2839));
                              _2859 = _2853 * _2858;
                              _2861 = 1.0f - (_2839 * _2858);
                              _2867 = ((_2859 * _2825) + _2829) + (_2861 * _2812);
                              _2870 = rsqrt((_2867 * 2.0f) + 2.0f);
                              _2879 = saturate((_2867 * _2870) + _2870);
                              _2880 = saturate(((_2827 + (_2859 * _2822)) + (_2861 * _2806)) * _2870);
                            } else {
                              _2879 = abs(_2777);
                              _2880 = 1.0f;
                            }
                          } else {
                            _2879 = saturate((_2781 * _2778) + _2781);
                            _2880 = saturate(_2781 * (_2777 + _2751));
                          }
                          _2881 = saturate(_2769);
                          _2882 = _2770 * _2770;
                          if (_2776 > 0.0f) {
                            _2892 = saturate(((_2776 * _2776) / ((_2879 * 3.5999999046325684f) + 0.4000000059604645f)) + _2882);
                          } else {
                            _2892 = _2882;
                          }
                          _2893 = sqrt(_2892);
                          if (_2788) {
                            _2904 = (_2892 / ((((_2774 * 0.25f) * ((_2893 * 3.0f) + _2774)) / (_2879 + 0.0010000000474974513f)) + _2892));
                          } else {
                            _2904 = 1.0f;
                          }
                          _2908 = (((_2892 * _2880) - _2880) * _2880) + 1.0f;
                          _2913 = saturate(abs(_2777) + 9.999999747378752e-06f);
                          _2914 = 1.0f - _2893;
                          _2926 = saturate((_2751 + _1708) / (_1708 + 1.0f));
                          _2929 = ((_2904 * _2881) * (_2892 / (_2908 * _2908))) * (0.5f / ((((_2914 * _2913) + _2893) * _2881) + (((_2914 * _2881) + _2893) * _2913)));
                          _2930 = _2656 * _1504;
                          _2931 = _2657 * _1504;
                          _2932 = _2658 * _1504;
                          if (_1705 > 0.0f) {
                            _2949 = (exp2(log2(1.0f - saturate(_2879)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                            _2950 = select(_2741, (_2737 * _1204), _2737) * _1705;
                            _2967 = (((((_2930 * _1073) * _2950) * _2949) * _2929) + _1445);
                            _2968 = (((((_2931 * _1073) * _2950) * _2949) * _2929) + _1446);
                            _2969 = (((((_2932 * _1073) * _2950) * _2949) * _2929) + _1447);
                          } else {
                            _2967 = _1445;
                            _2968 = _1446;
                            _2969 = _1447;
                          }
                          _2975 = saturate(-0.0f - dot(float3(_385, _386, _384), float3(_1646, _1647, _1648)));
                          _2978 = 1.0f - ((_2975 * _2975) * 0.6399999856948853f);
                          _2983 = saturate(0.30000001192092896f - _1745) * (0.36000001430511475f / (_2978 * _2978));
                          _2984 = _1796 * _1504;
                          _8358 = (((_2744 * _2930) * _2926) + _1442);
                          _8359 = (((_2744 * _2931) * _2926) + _1443);
                          _8360 = (((_2744 * _2932) * _2926) + _1444);
                          _8361 = ((((_167 * _203) * _2984) * _2983) + _2967);
                          _8362 = ((((_167 * _204) * _2984) * _2983) + _2968);
                          _8363 = ((((_205 * _167) * _2984) * _2983) + _2969);
                        } else {
                          _8358 = _1442;
                          _8359 = _1443;
                          _8360 = _1444;
                          _8361 = _1445;
                          _8362 = _1446;
                          _8363 = _1447;
                        }
                        break;
                      }
                    } else {
                      _8358 = _1442;
                      _8359 = _1443;
                      _8360 = _1444;
                      _8361 = _1445;
                      _8362 = _1446;
                      _8363 = _1447;
                    }
                  } else {
                    if (_1487 == 7) {
                      _3448 = asfloat(srvLightInfoProperties.Load3(_1456)).x;
                      _3449 = asfloat(srvLightInfoProperties.Load3(_1456)).y;
                      _3450 = asfloat(srvLightInfoProperties.Load3(_1456)).z;
                      _3453 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 12u)))).x;
                      _3454 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 12u)))).y;
                      _3455 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 12u)))).z;
                      _3458 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 24u)))).x;
                      _3459 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 24u)))).y;
                      _3460 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 24u)))).z;
                      _3463 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 36u)))).x;
                      _3464 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 36u)))).y;
                      _3465 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 36u)))).z;
                      _3468 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).x;
                      _3469 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).y;
                      _3470 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 48u)))).z;
                      _3473 = asint(srvLightInfoProperties.Load(((int)(_1456 + 60u))));
                      _3476 = asint(srvLightInfoProperties.Load(((int)(_1456 + 64u))));
                      _3479 = asint(srvLightInfoProperties.Load(((int)(_1456 + 72u))));
                      _3482 = asint(srvLightInfoProperties.Load(((int)(_1456 + 76u))));
                      _3485 = asint(srvLightInfoProperties.Load(((int)(_1456 + 80u))));
                      _3488 = asint(srvLightInfoProperties.Load(((int)(_1456 + 84u))));
                      _3491 = asint(srvLightInfoProperties.Load(((int)(_1456 + 88u))));
                      _3494 = asint(srvLightInfoProperties.Load(((int)(_1456 + 92u))));
                      _3497 = asint(srvLightInfoProperties.Load(((int)(_1456 + 96u))));
                      _3500 = asint(srvLightInfoProperties.Load(((int)(_1456 + 100u))));
                      _3503 = asint(srvLightInfoProperties.Load(((int)(_1456 + 104u))));
                      _3506 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).x;
                      _3507 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).y;
                      _3508 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).z;
                      _3509 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).w;
                      _3512 = asint(srvLightInfoProperties.Load(((int)(_1456 + 124u))));
                      _3515 = asint(srvLightInfoProperties.Load(((int)(_1456 + 128u))));
                      _3518 = asint(srvLightInfoProperties.Load(((int)(_1456 + 136u))));
                      _3521 = asint(srvLightInfoProperties.Load(((int)(_1456 + 140u))));
                      _3523 = f16tof32(((uint)((uint)(_3473) >> 16)));
                      _3524 = f16tof32(_3473);
                      _3526 = f16tof32(((uint)((uint)(_3476) >> 16)));
                      _3530 = ((float)((uint)((uint)(((uint)(_3476) >> 8) & 255)))) * 0.003921499941498041f;
                      _3533 = ((float)((uint)((uint)(_3476 & 255)))) * 0.003921499941498041f;
                      _3534 = f16tof32(_3479);
                      _3536 = f16tof32(((uint)((uint)(_3482) >> 16)));
                      _3540 = f16tof32(_3485);
                      _3542 = f16tof32(((uint)((uint)(_3488) >> 16)));
                      _3543 = f16tof32(_3488);
                      _3545 = f16tof32(((uint)((uint)(_3491) >> 16)));
                      _3548 = _3494 & 65535;
                      _3552 = ((_1454 & 4194304) != 0);
                      _3560 = f16tof32(((uint)((uint)(_3503) >> 16)));
                      _3561 = f16tof32(_3503);
                      _3563 = f16tof32(((uint)((uint)(_3512) >> 16)));
                      _3566 = f16tof32(((uint)((uint)(_3515) >> 16)));
                      _3567 = f16tof32(_3515);
                      _3569 = f16tof32(((uint)((uint)(_3518) >> 16)));
                      _3570 = _3569 + -1.0f;
                      if (_3552) {
                        _3572 = 0.5f / _3569;
                        _3573 = 0.3333333432674408f / _3569;
                        _3577 = (_3569 * 0.5f) + 0.5f;
                        _3587 = (_3572 * _3570);
                        _3588 = (_3573 * _3570);
                        _3589 = (_3572 * _3577);
                        _3590 = (_3573 * _3577);
                        _3591 = (_3569 * 2.0f);
                        _3592 = (_3569 * 3.0f);
                      } else {
                        _3583 = 1.0f / _3569;
                        _3584 = _3583 * _3570;
                        _3585 = _3583 * 0.5f;
                        _3587 = _3584;
                        _3588 = _3584;
                        _3589 = _3585;
                        _3590 = _3585;
                        _3591 = _3569;
                        _3592 = _3569;
                      }
                      _3596 = _3463 - _212;
                      _3597 = _3464 - _213;
                      _3598 = _3465 + _211;
                      _3599 = dot(float3(_3596, _3597, _3598), float3(_3596, _3597, _3598));
                      _3600 = rsqrt(_3599);
                      _3601 = _3600 * _3599;
                      _3602 = _3600 * _3596;
                      _3603 = _3600 * _3597;
                      _3604 = _3600 * _3598;
                      _3607 = max(0.0f, (_3601 - abs(_3540)));
                      _3608 = _3607 * f16tof32(((uint)((uint)(_3485) >> 16)));
                      _3609 = _3608 * _3608;
                      _3612 = saturate(1.0f - (_3609 * _3609));
                      _3619 = (_3612 * _3612) / (select((_3540 < 0.0f), (_3609 * 16.0f), (_3607 * _3607)) + 1.0f);
                      _3629 = dot(float3(_190, _191, _192), float3(_3602, _3603, _3604));
                      _3632 = saturate(1.0f - _3629) * f16tof32(_3512);
                      _3636 = abs(_3598);
                      _3640 = _3596 - ((_3632 * _190) * _3636);
                      _3641 = _3597 - ((_3632 * _191) * _3636);
                      _3642 = _3598 - ((_3632 * _192) * _3636);
                      _3645 = mad(_3642, _3459, mad(_3641, _3454, (_3640 * _3449)));
                      _3648 = mad(_3642, _3460, mad(_3641, _3455, (_3640 * _3450)));
                      _3650 = ((_1454 & 3584) != 0);
                      if (_3650 && (_3619 > 0.0f)) {
                        _3656 = mad(_3642, _3458, mad(_3641, _3453, (_3640 * _3448)));
                        _3657 = -0.0f - _3648;
                        _3658 = -0.0f - _3645;
                        [branch]
                        if (!((_1454 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3494) >> 16))];
                          [branch]
                          if (_3552) {
                            _3663 = abs(_3656);
                            _3664 = abs(_3657);
                            _3665 = abs(_3658);
                            if (_3663 > max(_3664, _3665)) {
                              _3669 = (_3656 > 0.0f);
                              _3684 = select(_3669, 0.0f, 1.0f);
                              _3685 = 0.0f;
                              _3686 = select(_3669, _3645, _3658);
                              _3687 = _3648;
                              _3688 = _3663;
                            } else {
                              if (_3664 > _3665) {
                                _3675 = (_3648 < -0.0f);
                                _3684 = select(_3675, 0.0f, 1.0f);
                                _3685 = 1.0f;
                                _3686 = _3656;
                                _3687 = select(_3675, _3658, _3645);
                                _3688 = _3664;
                              } else {
                                _3679 = (_3645 < -0.0f);
                                _3684 = select(_3679, 0.0f, 1.0f);
                                _3685 = 2.0f;
                                _3686 = select(_3679, _3656, (-0.0f - _3656));
                                _3687 = _3648;
                                _3688 = _3665;
                              }
                            }
                            _3689 = _3688 * 2.0f;
                            _3693 = -0.0f - _3561;
                            _3702 = ((min(max((_3686 / _3689), _3693), _3561) + _3684) * _3587) + _3589;
                            _3703 = ((min(max((_3687 / _3689), _3693), _3561) + _3685) * _3588) + _3590;
                            _3710 = ((_3684 + -0.5f) * _3587) + _3589;
                            _3711 = ((_3685 + -0.5f) * _3588) + _3590;
                            _3714 = saturate((_3563 + 1.0f) - (_3688 * _3545));
                            _3718 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _3727 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_3718 * 32.665000915527344f) + _125), ((_3718 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _3728 = sin(_3727);
                            _3729 = cos(_3727);
                            _3734 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_3702, _3703), 0.0f))).x) > _3714), 1.0f, 0.0f);
                            _3735 = cbSharedPerViewData.nFrameCounter & 3;
                            _3740 = sqrt((float((int)(_3735)) * 0.25f) + 0.125f) * _3566;
                            _3749 = (_global_7[min((uint)(((int)(0u + (_3735 * 2)))), 127u)]) * _3740;
                            _3750 = (_global_7[min((uint)(((int)(1u + (_3735 * 2)))), 127u)]) * _3740;
                            _3752 = -0.0f - _3728;
                            _3754 = dot(float2(_3749, _3750), float2(_3729, _3728)) + _3702;
                            _3755 = dot(float2(_3749, _3750), float2(_3752, _3729)) + _3703;
                            _3757 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3754, _3755));
                            _3761 = _3754 * _3591;
                            _3762 = _3755 * _3592;
                            _3765 = floor(_3710 * _3591);
                            _3766 = floor(_3711 * _3592);
                            _3771 = floor(((_3710 + _3587) * _3591) + 0.5f);
                            _3772 = floor(((_3711 + _3588) * _3592) + 0.5f);
                            _3775 = floor(_3761 + -0.5f);
                            _3776 = floor(_3762 + 0.5f);
                            _3778 = floor(_3761 + 0.5f);
                            _3780 = floor(_3762 + -0.5f);
                            _3781 = (_3775 < _3765);
                            _3782 = (_3776 < _3766);
                            if ((_3781 || _3782) | ((_3775 >= _3771) || (_3776 >= _3772))) {
                              _3791 = _3734;
                            } else {
                              _3791 = _3757.x;
                            }
                            _3792 = (_3778 < _3765);
                            if ((_3792 || _3782) | ((_3778 >= _3771) || (_3776 >= _3772))) {
                              _3800 = _3734;
                            } else {
                              _3800 = _3757.y;
                            }
                            _3801 = (_3780 < _3766);
                            if ((_3792 || _3801) | ((_3778 >= _3771) || (_3780 >= _3772))) {
                              _3809 = _3734;
                            } else {
                              _3809 = _3757.z;
                            }
                            if ((_3781 || _3801) | ((_3775 >= _3771) || (_3780 >= _3772))) {
                              _3817 = _3734;
                            } else {
                              _3817 = _3757.w;
                            }
                            _3818 = _3791 - _3714;
                            _3820 = select((_3818 < 0.0f), 0.0f, 1.0f);
                            _3822 = _3800 - _3714;
                            _3824 = select((_3822 < 0.0f), 0.0f, 1.0f);
                            _3828 = _3809 - _3714;
                            _3830 = select((_3828 < 0.0f), 0.0f, 1.0f);
                            _3834 = _3817 - _3714;
                            _3836 = select((_3834 < 0.0f), 0.0f, 1.0f);
                            _3843 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _3848 = sqrt((float((int)(_3843)) * 0.25f) + 0.125f) * _3566;
                            _3857 = (_global_7[min((uint)(((int)(0u + (_3843 * 2)))), 127u)]) * _3848;
                            _3858 = (_global_7[min((uint)(((int)(1u + (_3843 * 2)))), 127u)]) * _3848;
                            _3861 = dot(float2(_3857, _3858), float2(_3729, _3728)) + _3702;
                            _3862 = dot(float2(_3857, _3858), float2(_3752, _3729)) + _3703;
                            _3864 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3861, _3862));
                            _3868 = _3861 * _3591;
                            _3869 = _3862 * _3592;
                            _3872 = floor(_3868 + -0.5f);
                            _3873 = floor(_3869 + 0.5f);
                            _3875 = floor(_3868 + 0.5f);
                            _3877 = floor(_3869 + -0.5f);
                            _3878 = (_3872 < _3765);
                            _3879 = (_3873 < _3766);
                            if ((_3878 || _3879) | ((_3872 >= _3771) || (_3873 >= _3772))) {
                              _3888 = _3734;
                            } else {
                              _3888 = _3864.x;
                            }
                            _3889 = (_3875 < _3765);
                            if ((_3889 || _3879) | ((_3875 >= _3771) || (_3873 >= _3772))) {
                              _3897 = _3734;
                            } else {
                              _3897 = _3864.y;
                            }
                            _3898 = (_3877 < _3766);
                            if ((_3889 || _3898) | ((_3875 >= _3771) || (_3877 >= _3772))) {
                              _3906 = _3734;
                            } else {
                              _3906 = _3864.z;
                            }
                            if ((_3878 || _3898) | ((_3872 >= _3771) || (_3877 >= _3772))) {
                              _3914 = _3734;
                            } else {
                              _3914 = _3864.w;
                            }
                            _3915 = _3888 - _3714;
                            _3917 = select((_3915 < 0.0f), 0.0f, 1.0f);
                            _3921 = _3897 - _3714;
                            _3923 = select((_3921 < 0.0f), 0.0f, 1.0f);
                            _3927 = _3906 - _3714;
                            _3929 = select((_3927 < 0.0f), 0.0f, 1.0f);
                            _3933 = _3914 - _3714;
                            _3935 = select((_3933 < 0.0f), 0.0f, 1.0f);
                            _3942 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _3947 = sqrt((float((int)(_3942)) * 0.25f) + 0.125f) * _3566;
                            _3956 = (_global_7[min((uint)(((int)(0u + (_3942 * 2)))), 127u)]) * _3947;
                            _3957 = (_global_7[min((uint)(((int)(1u + (_3942 * 2)))), 127u)]) * _3947;
                            _3960 = dot(float2(_3956, _3957), float2(_3729, _3728)) + _3702;
                            _3961 = dot(float2(_3956, _3957), float2(_3752, _3729)) + _3703;
                            _3963 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3960, _3961));
                            _3967 = _3960 * _3591;
                            _3968 = _3961 * _3592;
                            _3971 = floor(_3967 + -0.5f);
                            _3972 = floor(_3968 + 0.5f);
                            _3974 = floor(_3967 + 0.5f);
                            _3976 = floor(_3968 + -0.5f);
                            _3977 = (_3971 < _3765);
                            _3978 = (_3972 < _3766);
                            if ((_3977 || _3978) | ((_3971 >= _3771) || (_3972 >= _3772))) {
                              _3987 = _3734;
                            } else {
                              _3987 = _3963.x;
                            }
                            _3988 = (_3974 < _3765);
                            if ((_3988 || _3978) | ((_3974 >= _3771) || (_3972 >= _3772))) {
                              _3996 = _3734;
                            } else {
                              _3996 = _3963.y;
                            }
                            _3997 = (_3976 < _3766);
                            if ((_3988 || _3997) | ((_3974 >= _3771) || (_3976 >= _3772))) {
                              _4005 = _3734;
                            } else {
                              _4005 = _3963.z;
                            }
                            if ((_3977 || _3997) | ((_3971 >= _3771) || (_3976 >= _3772))) {
                              _4013 = _3734;
                            } else {
                              _4013 = _3963.w;
                            }
                            _4014 = _3987 - _3714;
                            _4016 = select((_4014 < 0.0f), 0.0f, 1.0f);
                            _4020 = _3996 - _3714;
                            _4022 = select((_4020 < 0.0f), 0.0f, 1.0f);
                            _4026 = _4005 - _3714;
                            _4028 = select((_4026 < 0.0f), 0.0f, 1.0f);
                            _4032 = _4013 - _3714;
                            _4034 = select((_4032 < 0.0f), 0.0f, 1.0f);
                            _4041 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4046 = sqrt((float((int)(_4041)) * 0.25f) + 0.125f) * _3566;
                            _4055 = (_global_7[min((uint)(((int)(0u + (_4041 * 2)))), 127u)]) * _4046;
                            _4056 = (_global_7[min((uint)(((int)(1u + (_4041 * 2)))), 127u)]) * _4046;
                            _4059 = dot(float2(_4055, _4056), float2(_3729, _3728)) + _3702;
                            _4060 = dot(float2(_4055, _4056), float2(_3752, _3729)) + _3703;
                            _4062 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4059, _4060));
                            _4066 = _4059 * _3591;
                            _4067 = _4060 * _3592;
                            _4070 = floor(_4066 + -0.5f);
                            _4071 = floor(_4067 + 0.5f);
                            _4073 = floor(_4066 + 0.5f);
                            _4075 = floor(_4067 + -0.5f);
                            _4076 = (_4070 < _3765);
                            _4077 = (_4071 < _3766);
                            if ((_4076 || _4077) | ((_4070 >= _3771) || (_4071 >= _3772))) {
                              _4086 = _3734;
                            } else {
                              _4086 = _4062.x;
                            }
                            _4087 = (_4073 < _3765);
                            if ((_4087 || _4077) | ((_4073 >= _3771) || (_4071 >= _3772))) {
                              _4095 = _3734;
                            } else {
                              _4095 = _4062.y;
                            }
                            _4096 = (_4075 < _3766);
                            if ((_4087 || _4096) | ((_4073 >= _3771) || (_4075 >= _3772))) {
                              _4104 = _3734;
                            } else {
                              _4104 = _4062.z;
                            }
                            if ((_4076 || _4096) | ((_4070 >= _3771) || (_4075 >= _3772))) {
                              _4112 = _3734;
                            } else {
                              _4112 = _4062.w;
                            }
                            _4113 = _4086 - _3714;
                            _4115 = select((_4113 < 0.0f), 0.0f, 1.0f);
                            _4119 = _4095 - _3714;
                            _4121 = select((_4119 < 0.0f), 0.0f, 1.0f);
                            _4125 = _4104 - _3714;
                            _4127 = select((_4125 < 0.0f), 0.0f, 1.0f);
                            _4131 = _4112 - _3714;
                            _4133 = select((_4131 < 0.0f), 0.0f, 1.0f);
                            _4134 = ((((((((((((((_3824 + _3820) + _3830) + _3836) + _3917) + _3923) + _3929) + _3935) + _4016) + _4022) + _4028) + _4034) + _4115) + _4121) + _4127) + _4133;
                            _4145 = (saturate(_4134 * 0.0625f) * 2.0f) + -1.0f;
                            _4151 = float((int)(((int)(uint)((int)(_4145 > 0.0f))) - ((int)(uint)((int)(_4145 < 0.0f)))));
                            _4153 = 1.0f - (_4151 * _4145);
                            _4155 = (_4153 * _4153) * _4153;
                            _4447 = (0.5f - ((_4151 * 0.5f) * ((1.0f - _4155) - ((_4153 - _4155) * saturate(((1.0f / _3714) * (1.0f / _4134)) * ((((((((((((((((_3824 * _3822) + (_3820 * _3818)) + (_3830 * _3828)) + (_3836 * _3834)) + (_3917 * _3915)) + (_3923 * _3921)) + (_3929 * _3927)) + (_3935 * _3933)) + (_4016 * _4014)) + (_4022 * _4020)) + (_4028 * _4026)) + (_4034 * _4032)) + (_4115 * _4113)) + (_4121 * _4119)) + (_4127 * _4125)) + (_4133 * _4131)))))));
                            _4448 = 1.0f;
                            _4449 = 1;
                          } else {
                            _4164 = f16tof32(_3521) / _3658;
                            _4167 = mad((_4164 * _3656), 0.5f, 0.5f);
                            _4168 = mad((_4164 * _3657), 0.5f, 0.5f);
                            if (_3645 > -0.0f) {
                              if ((saturate(_4167) == _4167) && (saturate(_4168) == _4168)) {
                                _4182 = (_4167 * _3587) + _3589;
                                _4183 = (_4168 * _3588) + _3590;
                                _4184 = saturate((_3563 + 1.0f) - (_3645 * _3545));
                                _4188 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4197 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_4188 * 32.665000915527344f) + _125), ((_4188 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4198 = sin(_4197);
                                _4199 = cos(_4197);
                                _4200 = cbSharedPerViewData.nFrameCounter & 3;
                                _4205 = sqrt((float((int)(_4200)) * 0.25f) + 0.125f) * _3566;
                                _4214 = (_global_7[min((uint)(((int)(0u + (_4200 * 2)))), 127u)]) * _4205;
                                _4215 = (_global_7[min((uint)(((int)(1u + (_4200 * 2)))), 127u)]) * _4205;
                                _4217 = -0.0f - _4198;
                                _4222 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4214, _4215), float2(_4199, _4198)) + _4182), (dot(float2(_4214, _4215), float2(_4217, _4199)) + _4183)));
                                _4227 = _4222.x - _4184;
                                _4229 = select((_4227 < 0.0f), 0.0f, 1.0f);
                                _4231 = _4222.y - _4184;
                                _4233 = select((_4231 < 0.0f), 0.0f, 1.0f);
                                _4237 = _4222.z - _4184;
                                _4239 = select((_4237 < 0.0f), 0.0f, 1.0f);
                                _4243 = _4222.w - _4184;
                                _4245 = select((_4243 < 0.0f), 0.0f, 1.0f);
                                _4252 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4257 = sqrt((float((int)(_4252)) * 0.25f) + 0.125f) * _3566;
                                _4266 = (_global_7[min((uint)(((int)(0u + (_4252 * 2)))), 127u)]) * _4257;
                                _4267 = (_global_7[min((uint)(((int)(1u + (_4252 * 2)))), 127u)]) * _4257;
                                _4273 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4266, _4267), float2(_4199, _4198)) + _4182), (dot(float2(_4266, _4267), float2(_4217, _4199)) + _4183)));
                                _4278 = _4273.x - _4184;
                                _4280 = select((_4278 < 0.0f), 0.0f, 1.0f);
                                _4284 = _4273.y - _4184;
                                _4286 = select((_4284 < 0.0f), 0.0f, 1.0f);
                                _4290 = _4273.z - _4184;
                                _4292 = select((_4290 < 0.0f), 0.0f, 1.0f);
                                _4296 = _4273.w - _4184;
                                _4298 = select((_4296 < 0.0f), 0.0f, 1.0f);
                                _4305 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _4310 = sqrt((float((int)(_4305)) * 0.25f) + 0.125f) * _3566;
                                _4319 = (_global_7[min((uint)(((int)(0u + (_4305 * 2)))), 127u)]) * _4310;
                                _4320 = (_global_7[min((uint)(((int)(1u + (_4305 * 2)))), 127u)]) * _4310;
                                _4326 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4319, _4320), float2(_4199, _4198)) + _4182), (dot(float2(_4319, _4320), float2(_4217, _4199)) + _4183)));
                                _4331 = _4326.x - _4184;
                                _4333 = select((_4331 < 0.0f), 0.0f, 1.0f);
                                _4337 = _4326.y - _4184;
                                _4339 = select((_4337 < 0.0f), 0.0f, 1.0f);
                                _4343 = _4326.z - _4184;
                                _4345 = select((_4343 < 0.0f), 0.0f, 1.0f);
                                _4349 = _4326.w - _4184;
                                _4351 = select((_4349 < 0.0f), 0.0f, 1.0f);
                                _4358 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _4363 = sqrt((float((int)(_4358)) * 0.25f) + 0.125f) * _3566;
                                _4372 = (_global_7[min((uint)(((int)(0u + (_4358 * 2)))), 127u)]) * _4363;
                                _4373 = (_global_7[min((uint)(((int)(1u + (_4358 * 2)))), 127u)]) * _4363;
                                _4379 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4372, _4373), float2(_4199, _4198)) + _4182), (dot(float2(_4372, _4373), float2(_4217, _4199)) + _4183)));
                                _4384 = _4379.x - _4184;
                                _4386 = select((_4384 < 0.0f), 0.0f, 1.0f);
                                _4390 = _4379.y - _4184;
                                _4392 = select((_4390 < 0.0f), 0.0f, 1.0f);
                                _4396 = _4379.z - _4184;
                                _4398 = select((_4396 < 0.0f), 0.0f, 1.0f);
                                _4402 = _4379.w - _4184;
                                _4404 = select((_4402 < 0.0f), 0.0f, 1.0f);
                                _4405 = ((((((((((((((_4229 + _4233) + _4239) + _4245) + _4280) + _4286) + _4292) + _4298) + _4333) + _4339) + _4345) + _4351) + _4386) + _4392) + _4398) + _4404;
                                _4416 = (saturate(_4405 * 0.0625f) * 2.0f) + -1.0f;
                                _4422 = float((int)(((int)(uint)((int)(_4416 > 0.0f))) - ((int)(uint)((int)(_4416 < 0.0f)))));
                                _4424 = 1.0f - (_4422 * _4416);
                                _4426 = (_4424 * _4424) * _4424;
                                _4434 = -0.0f - _3656;
                                _4441 = saturate((saturate(rsqrt(dot(float3(_4434, _3648, _3645), float3(_4434, _3648, _3645))) * _3645) * _3543) + _3542);
                                _4443 = 1.0f - (_4441 * _4441);
                                _4447 = (0.5f - ((_4422 * 0.5f) * ((1.0f - _4426) - ((_4424 - _4426) * saturate(((1.0f / _4184) * (1.0f / _4405)) * ((((((((((((((((_4229 * _4227) + (_4233 * _4231)) + (_4239 * _4237)) + (_4245 * _4243)) + (_4280 * _4278)) + (_4286 * _4284)) + (_4292 * _4290)) + (_4298 * _4296)) + (_4333 * _4331)) + (_4339 * _4337)) + (_4345 * _4343)) + (_4351 * _4349)) + (_4386 * _4384)) + (_4392 * _4390)) + (_4398 * _4396)) + (_4404 * _4402)))))));
                                _4448 = (1.0f - (_4443 * _4443));
                                _4449 = 1;
                              } else {
                                _4447 = 1.0f;
                                _4448 = 1.0f;
                                _4449 = 0;
                              }
                            } else {
                              _4447 = 1.0f;
                              _4448 = 1.0f;
                              _4449 = 0;
                            }
                          }
                        } else {
                          _4447 = 1.0f;
                          _4448 = 1.0f;
                          _4449 = 0;
                        }
                        [branch]
                        if (!((_1454 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1454 & 2097152) == 0)) {
                            _4457 = abs(_3656);
                            _4458 = abs(_3657);
                            _4459 = abs(_3658);
                            if (_4457 > max(_4458, _4459)) {
                              _4463 = (_3656 > 0.0f);
                              _4478 = select(_4463, 0.0f, 1.0f);
                              _4479 = 0.0f;
                              _4480 = select(_4463, _3645, _3658);
                              _4481 = _3648;
                              _4482 = _4457;
                            } else {
                              if (_4458 > _4459) {
                                _4469 = (_3648 < -0.0f);
                                _4478 = select(_4469, 0.0f, 1.0f);
                                _4479 = 1.0f;
                                _4480 = _3656;
                                _4481 = select(_4469, _3658, _3645);
                                _4482 = _4458;
                              } else {
                                _4473 = (_3645 < -0.0f);
                                _4478 = select(_4473, 0.0f, 1.0f);
                                _4479 = 2.0f;
                                _4480 = select(_4473, _3656, (-0.0f - _3656));
                                _4481 = _3648;
                                _4482 = _4459;
                              }
                            }
                            _4483 = _4482 * 2.0f;
                            _4488 = -0.0f - _3560;
                            _4497 = ((min(max((_4480 / _4483), _4488), _3560) + _4478) * _3506) + _3508;
                            _4498 = ((min(max((_4481 / _4483), _4488), _3560) + _4479) * _3507) + _3509;
                            _4503 = ((_4478 + -0.5f) * _3506) + _3508;
                            _4504 = ((_4479 + -0.5f) * _3507) + _3509;
                            _4507 = saturate(1.0f - (_4482 * _3545));
                            _4511 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4520 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_4511 * 32.665000915527344f) + _125), ((_4511 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4521 = sin(_4520);
                            _4522 = cos(_4520);
                            _4527 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4497, _4498), 0.0f))).x) > _4507), 1.0f, 0.0f);
                            _4528 = cbSharedPerViewData.nFrameCounter & 3;
                            _4533 = sqrt((float((int)(_4528)) * 0.25f) + 0.125f) * _3567;
                            _4542 = (_global_7[min((uint)(((int)(0u + (_4528 * 2)))), 127u)]) * _4533;
                            _4543 = (_global_7[min((uint)(((int)(1u + (_4528 * 2)))), 127u)]) * _4533;
                            _4545 = -0.0f - _4521;
                            _4547 = dot(float2(_4542, _4543), float2(_4522, _4521)) + _4497;
                            _4548 = dot(float2(_4542, _4543), float2(_4545, _4522)) + _4498;
                            _4550 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4547, _4548));
                            _4554 = _4547 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4555 = _4548 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4558 = floor(_4503 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _4559 = floor(_4504 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _4564 = floor(((_4503 + _3506) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _4565 = floor(((_4504 + _3507) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _4568 = floor(_4554 + -0.5f);
                            _4569 = floor(_4555 + 0.5f);
                            _4571 = floor(_4554 + 0.5f);
                            _4573 = floor(_4555 + -0.5f);
                            _4574 = (_4568 < _4558);
                            _4575 = (_4569 < _4559);
                            if ((_4574 || _4575) | ((_4568 >= _4564) || (_4569 >= _4565))) {
                              _4584 = _4527;
                            } else {
                              _4584 = _4550.x;
                            }
                            _4585 = (_4571 < _4558);
                            if ((_4585 || _4575) | ((_4571 >= _4564) || (_4569 >= _4565))) {
                              _4593 = _4527;
                            } else {
                              _4593 = _4550.y;
                            }
                            _4594 = (_4573 < _4559);
                            if ((_4585 || _4594) | ((_4571 >= _4564) || (_4573 >= _4565))) {
                              _4602 = _4527;
                            } else {
                              _4602 = _4550.z;
                            }
                            if ((_4574 || _4594) | ((_4568 >= _4564) || (_4573 >= _4565))) {
                              _4610 = _4527;
                            } else {
                              _4610 = _4550.w;
                            }
                            _4611 = _4584 - _4507;
                            _4613 = select((_4611 < 0.0f), 0.0f, 1.0f);
                            _4615 = _4593 - _4507;
                            _4617 = select((_4615 < 0.0f), 0.0f, 1.0f);
                            _4621 = _4602 - _4507;
                            _4623 = select((_4621 < 0.0f), 0.0f, 1.0f);
                            _4627 = _4610 - _4507;
                            _4629 = select((_4627 < 0.0f), 0.0f, 1.0f);
                            _4636 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _4641 = sqrt((float((int)(_4636)) * 0.25f) + 0.125f) * _3567;
                            _4650 = (_global_7[min((uint)(((int)(0u + (_4636 * 2)))), 127u)]) * _4641;
                            _4651 = (_global_7[min((uint)(((int)(1u + (_4636 * 2)))), 127u)]) * _4641;
                            _4654 = dot(float2(_4650, _4651), float2(_4522, _4521)) + _4497;
                            _4655 = dot(float2(_4650, _4651), float2(_4545, _4522)) + _4498;
                            _4657 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4654, _4655));
                            _4661 = _4654 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4662 = _4655 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4665 = floor(_4661 + -0.5f);
                            _4666 = floor(_4662 + 0.5f);
                            _4668 = floor(_4661 + 0.5f);
                            _4670 = floor(_4662 + -0.5f);
                            _4671 = (_4665 < _4558);
                            _4672 = (_4666 < _4559);
                            if ((_4671 || _4672) | ((_4665 >= _4564) || (_4666 >= _4565))) {
                              _4681 = _4527;
                            } else {
                              _4681 = _4657.x;
                            }
                            _4682 = (_4668 < _4558);
                            if ((_4682 || _4672) | ((_4668 >= _4564) || (_4666 >= _4565))) {
                              _4690 = _4527;
                            } else {
                              _4690 = _4657.y;
                            }
                            _4691 = (_4670 < _4559);
                            if ((_4682 || _4691) | ((_4668 >= _4564) || (_4670 >= _4565))) {
                              _4699 = _4527;
                            } else {
                              _4699 = _4657.z;
                            }
                            if ((_4671 || _4691) | ((_4665 >= _4564) || (_4670 >= _4565))) {
                              _4707 = _4527;
                            } else {
                              _4707 = _4657.w;
                            }
                            _4708 = _4681 - _4507;
                            _4710 = select((_4708 < 0.0f), 0.0f, 1.0f);
                            _4714 = _4690 - _4507;
                            _4716 = select((_4714 < 0.0f), 0.0f, 1.0f);
                            _4720 = _4699 - _4507;
                            _4722 = select((_4720 < 0.0f), 0.0f, 1.0f);
                            _4726 = _4707 - _4507;
                            _4728 = select((_4726 < 0.0f), 0.0f, 1.0f);
                            _4735 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4740 = sqrt((float((int)(_4735)) * 0.25f) + 0.125f) * _3567;
                            _4749 = (_global_7[min((uint)(((int)(0u + (_4735 * 2)))), 127u)]) * _4740;
                            _4750 = (_global_7[min((uint)(((int)(1u + (_4735 * 2)))), 127u)]) * _4740;
                            _4753 = dot(float2(_4749, _4750), float2(_4522, _4521)) + _4497;
                            _4754 = dot(float2(_4749, _4750), float2(_4545, _4522)) + _4498;
                            _4756 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4753, _4754));
                            _4760 = _4753 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4761 = _4754 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4764 = floor(_4760 + -0.5f);
                            _4765 = floor(_4761 + 0.5f);
                            _4767 = floor(_4760 + 0.5f);
                            _4769 = floor(_4761 + -0.5f);
                            _4770 = (_4764 < _4558);
                            _4771 = (_4765 < _4559);
                            if ((_4770 || _4771) | ((_4764 >= _4564) || (_4765 >= _4565))) {
                              _4780 = _4527;
                            } else {
                              _4780 = _4756.x;
                            }
                            _4781 = (_4767 < _4558);
                            if ((_4781 || _4771) | ((_4767 >= _4564) || (_4765 >= _4565))) {
                              _4789 = _4527;
                            } else {
                              _4789 = _4756.y;
                            }
                            _4790 = (_4769 < _4559);
                            if ((_4781 || _4790) | ((_4767 >= _4564) || (_4769 >= _4565))) {
                              _4798 = _4527;
                            } else {
                              _4798 = _4756.z;
                            }
                            if ((_4770 || _4790) | ((_4764 >= _4564) || (_4769 >= _4565))) {
                              _4806 = _4527;
                            } else {
                              _4806 = _4756.w;
                            }
                            _4807 = _4780 - _4507;
                            _4809 = select((_4807 < 0.0f), 0.0f, 1.0f);
                            _4813 = _4789 - _4507;
                            _4815 = select((_4813 < 0.0f), 0.0f, 1.0f);
                            _4819 = _4798 - _4507;
                            _4821 = select((_4819 < 0.0f), 0.0f, 1.0f);
                            _4825 = _4806 - _4507;
                            _4827 = select((_4825 < 0.0f), 0.0f, 1.0f);
                            _4834 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4839 = sqrt((float((int)(_4834)) * 0.25f) + 0.125f) * _3567;
                            _4848 = (_global_7[min((uint)(((int)(0u + (_4834 * 2)))), 127u)]) * _4839;
                            _4849 = (_global_7[min((uint)(((int)(1u + (_4834 * 2)))), 127u)]) * _4839;
                            _4852 = dot(float2(_4848, _4849), float2(_4522, _4521)) + _4497;
                            _4853 = dot(float2(_4848, _4849), float2(_4545, _4522)) + _4498;
                            _4855 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4852, _4853));
                            _4859 = _4852 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4860 = _4853 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4863 = floor(_4859 + -0.5f);
                            _4864 = floor(_4860 + 0.5f);
                            _4866 = floor(_4859 + 0.5f);
                            _4868 = floor(_4860 + -0.5f);
                            _4869 = (_4863 < _4558);
                            _4870 = (_4864 < _4559);
                            if ((_4869 || _4870) | ((_4863 >= _4564) || (_4864 >= _4565))) {
                              _4879 = _4527;
                            } else {
                              _4879 = _4855.x;
                            }
                            _4880 = (_4866 < _4558);
                            if ((_4880 || _4870) | ((_4866 >= _4564) || (_4864 >= _4565))) {
                              _4888 = _4527;
                            } else {
                              _4888 = _4855.y;
                            }
                            _4889 = (_4868 < _4559);
                            if ((_4880 || _4889) | ((_4866 >= _4564) || (_4868 >= _4565))) {
                              _4897 = _4527;
                            } else {
                              _4897 = _4855.z;
                            }
                            if ((_4869 || _4889) | ((_4863 >= _4564) || (_4868 >= _4565))) {
                              _4905 = _4527;
                            } else {
                              _4905 = _4855.w;
                            }
                            _4906 = _4879 - _4507;
                            _4908 = select((_4906 < 0.0f), 0.0f, 1.0f);
                            _4912 = _4888 - _4507;
                            _4914 = select((_4912 < 0.0f), 0.0f, 1.0f);
                            _4918 = _4897 - _4507;
                            _4920 = select((_4918 < 0.0f), 0.0f, 1.0f);
                            _4924 = _4905 - _4507;
                            _4926 = select((_4924 < 0.0f), 0.0f, 1.0f);
                            _4927 = ((((((((((((((_4617 + _4613) + _4623) + _4629) + _4710) + _4716) + _4722) + _4728) + _4809) + _4815) + _4821) + _4827) + _4908) + _4914) + _4920) + _4926;
                            _4938 = (saturate(_4927 * 0.0625f) * 2.0f) + -1.0f;
                            _4944 = float((int)(((int)(uint)((int)(_4938 > 0.0f))) - ((int)(uint)((int)(_4938 < 0.0f)))));
                            _4946 = 1.0f - (_4944 * _4938);
                            _4948 = (_4946 * _4946) * _4946;
                            _5239 = (0.5f - ((_4944 * 0.5f) * ((1.0f - _4948) - ((_4946 - _4948) * saturate(((1.0f / _4507) * (1.0f / _4927)) * ((((((((((((((((_4617 * _4615) + (_4613 * _4611)) + (_4623 * _4621)) + (_4629 * _4627)) + (_4710 * _4708)) + (_4716 * _4714)) + (_4722 * _4720)) + (_4728 * _4726)) + (_4809 * _4807)) + (_4815 * _4813)) + (_4821 * _4819)) + (_4827 * _4825)) + (_4908 * _4906)) + (_4914 * _4912)) + (_4920 * _4918)) + (_4926 * _4924)))))));
                            _5240 = 1.0f;
                            _5241 = false;
                          } else {
                            _4957 = f16tof32(((uint)((uint)(_3521) >> 16))) / _3658;
                            _4960 = mad((_4957 * _3656), 0.5f, 0.5f);
                            _4961 = mad((_4957 * _3657), 0.5f, 0.5f);
                            if (_3645 > -0.0f) {
                              if ((saturate(_4960) == _4960) && (saturate(_4961) == _4961)) {
                                _4974 = (_4960 * _3506) + _3508;
                                _4975 = (_4961 * _3507) + _3509;
                                _4976 = saturate(1.0f - (_3645 * _3545));
                                _4980 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4989 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_4980 * 32.665000915527344f) + _125), ((_4980 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4990 = sin(_4989);
                                _4991 = cos(_4989);
                                _4992 = cbSharedPerViewData.nFrameCounter & 3;
                                _4997 = sqrt((float((int)(_4992)) * 0.25f) + 0.125f) * _3567;
                                _5006 = (_global_7[min((uint)(((int)(0u + (_4992 * 2)))), 127u)]) * _4997;
                                _5007 = (_global_7[min((uint)(((int)(1u + (_4992 * 2)))), 127u)]) * _4997;
                                _5009 = -0.0f - _4990;
                                _5014 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5006, _5007), float2(_4991, _4990)) + _4974), (dot(float2(_5006, _5007), float2(_5009, _4991)) + _4975)));
                                _5019 = _5014.x - _4976;
                                _5021 = select((_5019 < 0.0f), 0.0f, 1.0f);
                                _5023 = _5014.y - _4976;
                                _5025 = select((_5023 < 0.0f), 0.0f, 1.0f);
                                _5029 = _5014.z - _4976;
                                _5031 = select((_5029 < 0.0f), 0.0f, 1.0f);
                                _5035 = _5014.w - _4976;
                                _5037 = select((_5035 < 0.0f), 0.0f, 1.0f);
                                _5044 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _5049 = sqrt((float((int)(_5044)) * 0.25f) + 0.125f) * _3567;
                                _5058 = (_global_7[min((uint)(((int)(0u + (_5044 * 2)))), 127u)]) * _5049;
                                _5059 = (_global_7[min((uint)(((int)(1u + (_5044 * 2)))), 127u)]) * _5049;
                                _5065 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5058, _5059), float2(_4991, _4990)) + _4974), (dot(float2(_5058, _5059), float2(_5009, _4991)) + _4975)));
                                _5070 = _5065.x - _4976;
                                _5072 = select((_5070 < 0.0f), 0.0f, 1.0f);
                                _5076 = _5065.y - _4976;
                                _5078 = select((_5076 < 0.0f), 0.0f, 1.0f);
                                _5082 = _5065.z - _4976;
                                _5084 = select((_5082 < 0.0f), 0.0f, 1.0f);
                                _5088 = _5065.w - _4976;
                                _5090 = select((_5088 < 0.0f), 0.0f, 1.0f);
                                _5097 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _5102 = sqrt((float((int)(_5097)) * 0.25f) + 0.125f) * _3567;
                                _5111 = (_global_7[min((uint)(((int)(0u + (_5097 * 2)))), 127u)]) * _5102;
                                _5112 = (_global_7[min((uint)(((int)(1u + (_5097 * 2)))), 127u)]) * _5102;
                                _5118 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5111, _5112), float2(_4991, _4990)) + _4974), (dot(float2(_5111, _5112), float2(_5009, _4991)) + _4975)));
                                _5123 = _5118.x - _4976;
                                _5125 = select((_5123 < 0.0f), 0.0f, 1.0f);
                                _5129 = _5118.y - _4976;
                                _5131 = select((_5129 < 0.0f), 0.0f, 1.0f);
                                _5135 = _5118.z - _4976;
                                _5137 = select((_5135 < 0.0f), 0.0f, 1.0f);
                                _5141 = _5118.w - _4976;
                                _5143 = select((_5141 < 0.0f), 0.0f, 1.0f);
                                _5150 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _5155 = sqrt((float((int)(_5150)) * 0.25f) + 0.125f) * _3567;
                                _5164 = (_global_7[min((uint)(((int)(0u + (_5150 * 2)))), 127u)]) * _5155;
                                _5165 = (_global_7[min((uint)(((int)(1u + (_5150 * 2)))), 127u)]) * _5155;
                                _5171 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5164, _5165), float2(_4991, _4990)) + _4974), (dot(float2(_5164, _5165), float2(_5009, _4991)) + _4975)));
                                _5176 = _5171.x - _4976;
                                _5178 = select((_5176 < 0.0f), 0.0f, 1.0f);
                                _5182 = _5171.y - _4976;
                                _5184 = select((_5182 < 0.0f), 0.0f, 1.0f);
                                _5188 = _5171.z - _4976;
                                _5190 = select((_5188 < 0.0f), 0.0f, 1.0f);
                                _5194 = _5171.w - _4976;
                                _5196 = select((_5194 < 0.0f), 0.0f, 1.0f);
                                _5197 = ((((((((((((((_5021 + _5025) + _5031) + _5037) + _5072) + _5078) + _5084) + _5090) + _5125) + _5131) + _5137) + _5143) + _5178) + _5184) + _5190) + _5196;
                                _5208 = (saturate(_5197 * 0.0625f) * 2.0f) + -1.0f;
                                _5214 = float((int)(((int)(uint)((int)(_5208 > 0.0f))) - ((int)(uint)((int)(_5208 < 0.0f)))));
                                _5216 = 1.0f - (_5214 * _5208);
                                _5218 = (_5216 * _5216) * _5216;
                                _5226 = -0.0f - _3656;
                                _5233 = saturate((saturate(rsqrt(dot(float3(_5226, _3648, _3645), float3(_5226, _3648, _3645))) * _3645) * _3543) + _3542);
                                _5235 = 1.0f - (_5233 * _5233);
                                _5239 = (0.5f - ((_5214 * 0.5f) * ((1.0f - _5218) - ((_5216 - _5218) * saturate(((1.0f / _4976) * (1.0f / _5197)) * ((((((((((((((((_5021 * _5019) + (_5025 * _5023)) + (_5031 * _5029)) + (_5037 * _5035)) + (_5072 * _5070)) + (_5078 * _5076)) + (_5084 * _5082)) + (_5090 * _5088)) + (_5125 * _5123)) + (_5131 * _5129)) + (_5137 * _5135)) + (_5143 * _5141)) + (_5178 * _5176)) + (_5184 * _5182)) + (_5190 * _5188)) + (_5196 * _5194)))))));
                                _5240 = (1.0f - (_5235 * _5235));
                                _5241 = false;
                              } else {
                                _5239 = 1.0f;
                                _5240 = 1.0f;
                                _5241 = true;
                              }
                            } else {
                              _5239 = 1.0f;
                              _5240 = 1.0f;
                              _5241 = true;
                            }
                          }
                        } else {
                          _5239 = 1.0f;
                          _5240 = 1.0f;
                          _5241 = true;
                        }
                        if (_4449 == 0) {
                          if (!_5241) {
                            _5256 = _4447;
                            _5257 = ((_5240 * (_5239 + -1.0f)) + 1.0f);
                            _5258 = 0.0f;
                          } else {
                            _5256 = _4447;
                            _5257 = _5239;
                            _5258 = 0.0f;
                          }
                        } else {
                          if (_5241) {
                            _5256 = ((_4448 * (_4447 + -1.0f)) + 1.0f);
                            _5257 = _5239;
                            _5258 = 1.0f;
                          } else {
                            _5256 = _4447;
                            _5257 = _5239;
                            _5258 = (_4448 * f16tof32(_3491));
                          }
                        }
                        _5261 = (_5258 * (_5256 - _5257)) + _5257;
                        [branch]
                        if (!((_1454 & 2048) == 0)) {
                          _5263 = _212 - _3463;
                          _5264 = _213 - _3464;
                          _5265 = _214 - _3465;
                          _5280 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5265, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5264, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5263)));
                          _5283 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _5265, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _5264, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _5263)));
                          _5286 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _5265, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _5264, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _5263)));
                          _5288 = rsqrt(dot(float3(_5280, _5283, _5286), float3(_5280, _5283, _5286)));
                          _5289 = _5288 * _5280;
                          _5290 = _5288 * _5283;
                          _5291 = _5288 * _5286;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3497) >> 16))];
                          _5299 = (abs(_5290) + abs(_5289)) + abs(_5291);
                          _5300 = _5289 / _5299;
                          _5301 = _5290 / _5299;
                          _5303 = !((_5291 / _5299) >= 0.0f);
                          if (_5303) {
                            _5316 = ((1.0f - abs(_5301)) * select((_5300 >= 0.0f), 1.0f, -1.0f));
                            _5317 = ((1.0f - abs(_5300)) * select((_5301 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _5316 = _5300;
                            _5317 = _5301;
                          }
                          _5323 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5316 * 0.5f) + 0.5f), ((_5317 * 0.5f) + 0.5f)), 0.0f);
                          if (_5323.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3497 & 65535))];
                            if (_5303) {
                              _5342 = ((1.0f - abs(_5301)) * select((_5300 >= 0.0f), 1.0f, -1.0f));
                              _5343 = ((1.0f - abs(_5300)) * select((_5301 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _5342 = _5300;
                              _5343 = _5301;
                            }
                            _5348 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5342 * 0.5f) + 0.5f), ((_5343 * 0.5f) + 0.5f)), 0.0f);
                            _5368 = mad(saturate(((log2(sqrt(((_5263 * _5263) + (_5264 * _5264)) + (_5265 * _5265))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _5369 = max(9.999999747378752e-06f, _5323.x);
                            _5370 = _5348.x / _5369;
                            _5371 = _5348.y / _5369;
                            _5373 = _5348.w / _5369;
                            _5378 = ((0.375f - _5371) * 4.999999873689376e-06f) + _5371;
                            _5381 = -0.0f - _5370;
                            _5382 = mad(_5381, _5378, (_5348.z / _5369));
                            _5384 = 1.0f / mad(_5381, _5370, _5378);
                            _5385 = _5384 * _5382;
                            _5390 = _5368 - _5370;
                            _5395 = (((_5368 * _5368) - _5378) - (_5385 * _5390)) / mad((-0.0f - _5382), _5385, mad((-0.0f - _5378), _5378, (((0.375f - _5373) * 4.999999873689376e-06f) + _5373)));
                            _5397 = (_5384 * _5390) - (_5395 * _5385);
                            _5400 = 1.0f / _5395;
                            _5401 = _5397 * _5400;
                            _5406 = sqrt(((_5401 * _5401) * 0.25f) - ((1.0f - dot(float2(_5397, _5395), float2(_5370, _5378))) * _5400));
                            _5408 = (_5401 * -0.5f) - _5406;
                            _5410 = _5406 - (_5401 * 0.5f);
                            _5412 = select((_5408 < _5368), 1.0f, 0.0f);
                            _5417 = (_5412 + -0.05000000074505806f) / (_5408 - _5368);
                            _5423 = (((select((_5410 < _5368), 1.0f, 0.0f) - _5412) / (_5410 - _5408)) - _5417) / (_5410 - _5368);
                            _5425 = _5417 - (_5423 * _5408);
                            _5438 = (exp2((_5323.x * -1.4426950216293335f) * saturate((dot(float2(_5370, _5378), float2((_5425 - (_5423 * _5368)), _5423)) + 0.05000000074505806f) - (_5425 * _5368))) * _5261);
                          } else {
                            _5438 = _5261;
                          }
                        } else {
                          _5438 = _5261;
                        }
                        _5441 = (_5438 * _3619);
                        _5442 = _5438;
                      } else {
                        _5441 = _3619;
                        _5442 = 1.0f;
                      }
                      [branch]
                      if (!(_3548 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3548)))];
                        _5454 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3598, _3458, mad(_3597, _3453, (_3596 * _3448)))), (-0.0f - mad(_3598, _3459, mad(_3597, _3454, (_3596 * _3449)))), (-0.0f - mad(_3598, _3460, mad(_3597, _3455, (_3596 * _3450))))), 0.0f);
                        _5462 = (_5454.x * _3523);
                        _5463 = (_5454.y * _3524);
                        _5464 = (_5454.z * _3526);
                      } else {
                        _5462 = _3523;
                        _5463 = _3524;
                        _5464 = _3526;
                      }
                      [branch]
                      if (!(_5441 == 0.0f)) {
                        bool __branch_chain_5466;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _5482 = 0;
                          __branch_chain_5466 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _5482 = 1;
                            __branch_chain_5466 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _5482 = 2;
                              __branch_chain_5466 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _5482 = 3;
                                __branch_chain_5466 = true;
                              } else {
                                _5503 = _5441;
                                __branch_chain_5466 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_5466) {
                          while(true) {
                            _5485 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                            if (_5482 == 0) {
                              _5499 = _5485.x;
                            } else {
                              if (_5482 == 1) {
                                _5499 = _5485.y;
                              } else {
                                if (_5482 == 2) {
                                  _5499 = _5485.z;
                                } else {
                                  _5499 = _5485.w;
                                }
                              }
                            }
                            _5503 = ((_5499 * _5499) * _3619);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_5503 == 0.0f)) {
                            [branch]
                            if (!(((_3500 & 1) == 0) || (!_3650))) {
                              _5520 = max(max(_5462, _5463), _5464);
                              if (_5520 > 0.0f) {
                                _5530 = saturate(_5462 / _5520);
                                _5531 = saturate(_5463 / _5520);
                                _5532 = saturate(_5464 / _5520);
                              } else {
                                _5530 = _5462;
                                _5531 = _5463;
                                _5532 = _5464;
                              }
                              _5533 = (_5531 < _5532);
                              _5534 = select(_5533, _5532, _5531);
                              _5535 = select(_5533, _5531, _5532);
                              _5536 = select(_5533, -1.0f, 0.0f);
                              _5537 = (_5530 < _5534);
                              _5539 = select(_5537, _5534, _5530);
                              _5540 = select(_5537, _5530, _5534);
                              _5544 = _5539 - select((_5540 < _5535), _5540, _5535);
                              _5550 = abs(select(_5537, (-0.3333333432674408f - _5536), _5536) + ((_5540 - _5535) / ((_5544 * 6.0f) + 9.999999682655225e-21f)));
                              if (_5550 < 0.6666666865348816f) {
                                _5563 = ((saturate(((float)((uint)((uint)(((uint)(_3500) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5550 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5550)) + _5550);
                              } else {
                                _5563 = _5550;
                              }
                              _5564 = saturate((_5544 / (_5539 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3500) >> 1) & 255)))) * 0.003921499941498041f));
                              _5565 = saturate(_5539);
                              if (!(_5564 <= 0.0f)) {
                                _5568 = saturate(_5563);
                                _5572 = select(((_5568 * 360.0f) >= 360.0f), 0.0f, (_5568 * 6.0f));
                                _5573 = int(_5572);
                                _5575 = _5572 - float((int)(_5573));
                                _5577 = _5565 * (1.0f - _5564);
                                _5580 = (1.0f - (_5575 * _5564)) * _5565;
                                _5584 = (1.0f - ((1.0f - _5575) * _5564)) * _5565;
                                switch (_5573) {
                                  case 0: {
                                    _5592 = _5565;
                                    _5593 = _5584;
                                    _5594 = _5577;
                                    break;
                                  }
                                  case 1: {
                                    _5592 = _5580;
                                    _5593 = _5565;
                                    _5594 = _5577;
                                    break;
                                  }
                                  case 2: {
                                    _5592 = _5577;
                                    _5593 = _5565;
                                    _5594 = _5584;
                                    break;
                                  }
                                  case 3: {
                                    _5592 = _5577;
                                    _5593 = _5580;
                                    _5594 = _5565;
                                    break;
                                  }
                                  case 4: {
                                    _5592 = _5584;
                                    _5593 = _5577;
                                    _5594 = _5565;
                                    break;
                                  }
                                  case 5: {
                                    _5592 = _5565;
                                    _5593 = _5577;
                                    _5594 = _5580;
                                    break;
                                  }
                                  default: {
                                    _5592 = 0.0f;
                                    _5593 = 0.0f;
                                    _5594 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _5592 = _5565;
                                _5593 = _5565;
                                _5594 = _5565;
                              }
                              _5595 = _5592 * _5520;
                              _5596 = _5593 * _5520;
                              _5597 = _5594 * _5520;
                              _5599 = saturate(_5442 * 1.0101009607315063f);
                              _5610 = ((_5599 * (_5462 - _5595)) + _5595);
                              _5611 = ((_5599 * (_5463 - _5596)) + _5596);
                              _5612 = (lerp(_5597, _5464, _5599));
                            } else {
                              _5610 = _5462;
                              _5611 = _5463;
                              _5612 = _5464;
                            }
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _5619 = srvLightMappingData[_1457];
                              if (!(_5619 == -1)) {
                                _5624 = srvLightIndexData[_5619].nLayerIndex;
                                _5626 = srvLightIndexData[_5619].vAtlasOrigin.x;
                                _5627 = srvLightIndexData[_5619].vAtlasOrigin.y;
                                _5629 = srvLightIndexData[_5619].vScreenOrigin.x;
                                _5630 = srvLightIndexData[_5619].vScreenOrigin.y;
                                _5639 = ((int)(_5624 * 5)) & 31;
                                _5648 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5626 + _63) - _5629)), ((int)((_5627 + _64) - _5630)), 0)))).x) & ((int)(31 << _5639)))) >> _5639)) >> 1)))) * 0.06666667014360428f) * _5503);
                              } else {
                                _5648 = _5503;
                              }
                            } else {
                              _5648 = _5503;
                            }
                            _5652 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _5655 = select(_5652, (_5648 * _1204), _5648);
                            _5657 = _3602 * _3601;
                            _5658 = _3603 * _3601;
                            _5659 = _3604 * _3601;
                            _5660 = _3534 * _3468;
                            _5661 = _3534 * _3469;
                            _5662 = _3534 * _3470;
                            _5663 = _5657 + _5660;
                            _5664 = _5658 + _5661;
                            _5665 = _5659 + _5662;
                            _5666 = _5657 - _5660;
                            _5667 = _5658 - _5661;
                            _5668 = _5659 - _5662;
                            _5669 = (_3534 > 0.0f);
                            _5670 = dot(float3(_5663, _5664, _5665), float3(_5663, _5664, _5665));
                            _5671 = rsqrt(_5670);
                            [branch]
                            if (_5669) {
                              _5674 = rsqrt(dot(float3(_5666, _5667, _5668), float3(_5666, _5667, _5668)));
                              _5675 = _5674 * _5671;
                              _5677 = dot(float3(_5663, _5664, _5665), float3(_5666, _5667, _5668)) * _5675;
                              _5696 = (_5675 / ((_5675 + 0.5f) + (_5677 * 0.5f)));
                              _5697 = (((dot(float3(_190, _191, _192), float3(_5666, _5667, _5668)) * _5674) + (dot(float3(_190, _191, _192), float3(_5663, _5664, _5665)) * _5671)) * 0.5f);
                              _5698 = _5677;
                            } else {
                              _5696 = (1.0f / (_5670 + 1.0f));
                              _5697 = dot(float3(_190, _191, _192), float3((_5671 * _5663), (_5671 * _5664), (_5671 * _5665)));
                              _5698 = 1.0f;
                            }
                            if (_3536 > 0.0f) {
                              _5704 = sqrt(saturate((_3536 * _3536) * _5696));
                              if (_5697 < _5704) {
                                _5709 = max(_5697, (-0.0f - _5704)) + _5704;
                                _5714 = ((_5709 * _5709) / (_5704 * 4.0f));
                              } else {
                                _5714 = _5697;
                              }
                            } else {
                              _5714 = _5697;
                            }
                            if (_5669) {
                              _5716 = -0.0f - _385;
                              _5717 = -0.0f - _386;
                              _5718 = -0.0f - _384;
                              _5720 = dot(float3(_5716, _5717, _5718), float3(_190, _191, _192)) * 2.0f;
                              _5724 = _5716 - (_5720 * _190);
                              _5725 = _5717 - (_5720 * _191);
                              _5726 = _5718 - (_5720 * _192);
                              _5727 = _5666 - _5663;
                              _5728 = _5667 - _5664;
                              _5729 = _5668 - _5665;
                              _5730 = dot(float3(_5724, _5725, _5726), float3(_5727, _5728, _5729));
                              _5736 = sqrt(((_5727 * _5727) + (_5728 * _5728)) + (_5729 * _5729));
                              _5745 = saturate(((dot(float3(_5724, _5725, _5726), float3(_5663, _5664, _5665)) * _5730) - dot(float3(_5663, _5664, _5665), float3(_5727, _5728, _5729))) / ((_5736 * _5736) - (_5730 * _5730)));
                              _5749 = (_5745 * _5727) + _5663;
                              _5750 = (_5745 * _5728) + _5664;
                              _5751 = (_5745 * _5729) + _5665;
                              _5752 = dot(float3(_5749, _5750, _5751), float3(_5724, _5725, _5726));
                              _5756 = (_5752 * _5724) - _5749;
                              _5757 = (_5752 * _5725) - _5750;
                              _5758 = (_5752 * _5726) - _5751;
                              _5766 = saturate(0.009999999776482582f / sqrt(((_5756 * _5756) + (_5757 * _5757)) + (_5758 * _5758)));
                              _5774 = ((_5766 * _5756) + _5749);
                              _5775 = ((_5766 * _5757) + _5750);
                              _5776 = ((_5766 * _5758) + _5751);
                            } else {
                              _5774 = _5663;
                              _5775 = _5664;
                              _5776 = _5665;
                            }
                            _5778 = rsqrt(dot(float3(_5774, _5775, _5776), float3(_5774, _5775, _5776)));
                            _5779 = _5778 * _5774;
                            _5780 = _5778 * _5775;
                            _5781 = _5778 * _5776;
                            _5782 = _201 * _201;
                            _5786 = saturate((_3536 * (1.0f - _5782)) * _5778);
                            _5788 = saturate(_5778 * f16tof32(_3482));
                            _5790 = rsqrt(dot(float3(_5657, _5658, _5659), float3(_5657, _5658, _5659)));
                            _5794 = dot(float3(_190, _191, _192), float3(_5779, _5780, _5781));
                            _5795 = dot(float3(_190, _191, _192), float3(_385, _386, _384));
                            _5796 = dot(float3(_385, _386, _384), float3(_5779, _5780, _5781));
                            _5799 = rsqrt((_5796 * 2.0f) + 2.0f);
                            _5806 = (_5786 > 0.0f);
                            if (_5806) {
                              _5810 = sqrt(1.0f - (_5786 * _5786));
                              _5812 = (_5794 * 2.0f) * _5795;
                              _5813 = _5812 - _5796;
                              if (!(_5813 >= _5810)) {
                                _5821 = rsqrt(1.0f - (_5813 * _5813)) * _5786;
                                _5824 = _5821 * (_5795 - (_5813 * _5794));
                                _5825 = _5795 * _5795;
                                _5830 = _5821 * (((_5825 * 2.0f) + -1.0f) - (_5813 * _5796));
                                _5839 = sqrt(saturate((((1.0f - (_5794 * _5794)) - _5825) - (_5796 * _5796)) + (_5812 * _5796)));
                                _5840 = _5839 * _5821;
                                _5843 = ((_5795 * 2.0f) * _5821) * _5839;
                                _5845 = (_5810 * _5794) + _5795;
                                _5846 = _5845 + _5824;
                                _5847 = _5810 * _5796;
                                _5849 = (_5847 + 1.0f) + _5830;
                                _5850 = _5840 * _5849;
                                _5851 = _5846 * _5849;
                                _5852 = _5843 * _5846;
                                _5857 = (((_5846 * 0.25f) * _5843) - (_5850 * 0.5f)) * _5851;
                                _5871 = (((_5852 - (_5850 * 2.0f)) * _5852) + (_5850 * _5850)) + ((((-0.5f - ((_5849 + _5847) * 0.5f)) * _5851) + ((_5849 * _5849) * _5845)) * _5846);
                                _5876 = (_5857 * 2.0f) / ((_5871 * _5871) + (_5857 * _5857));
                                _5877 = _5871 * _5876;
                                _5879 = 1.0f - (_5857 * _5876);
                                _5885 = ((_5877 * _5843) + _5847) + (_5879 * _5830);
                                _5888 = rsqrt((_5885 * 2.0f) + 2.0f);
                                _5897 = saturate((_5885 * _5888) + _5888);
                                _5898 = saturate(((_5845 + (_5877 * _5840)) + (_5879 * _5824)) * _5888);
                              } else {
                                _5897 = abs(_5795);
                                _5898 = 1.0f;
                              }
                            } else {
                              _5897 = saturate((_5799 * _5796) + _5799);
                              _5898 = saturate(_5799 * (_5795 + _5794));
                            }
                            _5899 = saturate(_5714);
                            _5901 = _5782 * _5782;
                            if (_5788 > 0.0f) {
                              _5911 = saturate(((_5788 * _5788) / ((_5897 * 3.5999999046325684f) + 0.4000000059604645f)) + _5901);
                            } else {
                              _5911 = _5901;
                            }
                            if (_5806) {
                              _5920 = (((_5786 * 0.25f) * ((sqrt(_5911) * 3.0f) + _5786)) / (_5897 + 0.0010000000474974513f)) + _5911;
                              _5923 = _5920;
                              _5924 = (_5911 / _5920);
                            } else {
                              _5923 = _5911;
                              _5924 = 1.0f;
                            }
                            if (_5698 < 1.0f) {
                              _5931 = sqrt((1.000100016593933f - _5698) / max(9.999999974752427e-07f, (_5698 + 1.0f)));
                              _5944 = (sqrt(_5923 / ((((_5931 * 0.25f) * ((sqrt(_5923) * 3.0f) + _5931)) / (_5897 + 0.0010000000474974513f)) + _5923)) * _5924);
                            } else {
                              _5944 = _5924;
                            }
                            _5948 = (((_5911 * _5898) - _5898) * _5898) + 1.0f;
                            _5953 = saturate(abs(_5795) + 9.999999747378752e-06f);
                            _5954 = sqrt(_5911);
                            _5955 = 1.0f - _5954;
                            _5967 = saturate((dot(float3(_190, _191, _192), float3((_5790 * _5657), (_5790 * _5658), (_5790 * _5659))) + _3533) / (_3533 + 1.0f));
                            _5970 = ((_5944 * _5899) * (_5911 / (_5948 * _5948))) * (0.5f / ((((_5955 * _5953) + _5954) * _5899) + (((_5955 * _5899) + _5954) * _5953)));
                            _5971 = _5610 * _1504;
                            _5972 = _5611 * _1504;
                            _5973 = _5612 * _1504;
                            if (_3530 > 0.0f) {
                              _5991 = (exp2(log2(1.0f - saturate(_5897)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                              _5992 = select(_5652, (_5648 * _1204), _5648) * _3530;
                              _6009 = (((((_5971 * _1073) * _5992) * _5991) * _5970) + _1445);
                              _6010 = (((((_5972 * _1073) * _5992) * _5991) * _5970) + _1446);
                              _6011 = (((((_5973 * _1073) * _5992) * _5991) * _5970) + _1447);
                            } else {
                              _6009 = _1445;
                              _6010 = _1446;
                              _6011 = _1447;
                            }
                            _6017 = saturate(-0.0f - dot(float3(_385, _386, _384), float3(_3602, _3603, _3604)));
                            _6020 = 1.0f - ((_6017 * _6017) * 0.6399999856948853f);
                            _6025 = saturate(0.30000001192092896f - _3629) * (0.36000001430511475f / (_6020 * _6020));
                            _6026 = _3619 * _1504;
                            _8358 = (((_5655 * _5971) * _5967) + _1442);
                            _8359 = (((_5655 * _5972) * _5967) + _1443);
                            _8360 = (((_5655 * _5973) * _5967) + _1444);
                            _8361 = ((((_167 * _203) * _6026) * _6025) + _6009);
                            _8362 = ((((_167 * _204) * _6026) * _6025) + _6010);
                            _8363 = ((((_205 * _167) * _6026) * _6025) + _6011);
                          } else {
                            _8358 = _1442;
                            _8359 = _1443;
                            _8360 = _1444;
                            _8361 = _1445;
                            _8362 = _1446;
                            _8363 = _1447;
                          }
                          break;
                        }
                      } else {
                        _8358 = _1442;
                        _8359 = _1443;
                        _8360 = _1444;
                        _8361 = _1445;
                        _8362 = _1446;
                        _8363 = _1447;
                      }
                    } else {
                      if (_1487 == 8) {
                        _6041 = asfloat(srvLightInfoProperties.Load3(_1456)).x;
                        _6042 = asfloat(srvLightInfoProperties.Load3(_1456)).y;
                        _6043 = asfloat(srvLightInfoProperties.Load3(_1456)).z;
                        _6046 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 12u)))).x;
                        _6047 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 12u)))).y;
                        _6048 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 12u)))).z;
                        _6051 = asfloat(srvLightInfoProperties.Load(((int)(_1456 + 24u))));
                        _6054 = asint(srvLightInfoProperties.Load(((int)(_1456 + 28u))));
                        _6057 = asint(srvLightInfoProperties.Load(((int)(_1456 + 32u))));
                        _6060 = asint(srvLightInfoProperties.Load(((int)(_1456 + 44u))));
                        _6069 = ((float)((uint)((uint)(((uint)(_6057) >> 8) & 255)))) * 0.003921499941498041f;
                        _6072 = ((float)((uint)((uint)(_6057 & 255)))) * 0.003921499941498041f;
                        _6075 = f16tof32(_6060);
                        _6082 = min(max(dot(float3((_212 - _6041), (_213 - _6042), (_214 - _6043)), float3(_6046, _6047, _6048)), (-0.0f - _6051)), _6051);
                        _6087 = (_6041 - _212) + (_6082 * _6046);
                        _6089 = (_6042 - _213) + (_6082 * _6047);
                        _6091 = (_6043 + _211) + (_6082 * _6048);
                        _6092 = dot(float3(_6087, _6089, _6091), float3(_6087, _6089, _6091));
                        _6093 = rsqrt(_6092);
                        _6095 = _6087 * _6093;
                        _6096 = _6089 * _6093;
                        _6097 = _6091 * _6093;
                        _6100 = max(0.0f, ((_6093 * _6092) - abs(_6075)));
                        _6101 = _6100 * f16tof32(((uint)((uint)(_6060) >> 16)));
                        _6102 = _6101 * _6101;
                        _6105 = saturate(1.0f - (_6102 * _6102));
                        _6112 = (_6105 * _6105) / (select((_6075 < 0.0f), (_6102 * 16.0f), (_6100 * _6100)) + 1.0f);
                        [branch]
                        if (!(_6112 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _6121 = srvLightMappingData[_1457];
                            if (!(_6121 == -1)) {
                              _6126 = srvLightIndexData[_6121].nLayerIndex;
                              _6128 = srvLightIndexData[_6121].vAtlasOrigin.x;
                              _6129 = srvLightIndexData[_6121].vAtlasOrigin.y;
                              _6131 = srvLightIndexData[_6121].vScreenOrigin.x;
                              _6132 = srvLightIndexData[_6121].vScreenOrigin.y;
                              _6141 = ((int)(_6126 * 5)) & 31;
                              _6150 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6128 + _63) - _6131)), ((int)((_6129 + _64) - _6132)), 0)))).x) & ((int)(31 << _6141)))) >> _6141)) >> 1)))) * 0.06666667014360428f) * _6112);
                            } else {
                              _6150 = _6112;
                            }
                          } else {
                            _6150 = _6112;
                          }
                          _6154 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _6156 = select(_6154, (_6150 * _1204), _6150);
                          _6157 = dot(float3(_190, _191, _192), float3(_6095, _6096, _6097));
                          _6158 = dot(float3(_190, _191, _192), float3(_385, _386, _384));
                          _6159 = dot(float3(_385, _386, _384), float3(_6095, _6096, _6097));
                          _6162 = rsqrt((_6159 * 2.0f) + 2.0f);
                          _6165 = saturate(_6162 * (_6158 + _6157));
                          _6166 = saturate(_6157);
                          _6167 = _201 * _201;
                          _6168 = _6167 * _6167;
                          _6172 = (((_6165 * _6168) - _6165) * _6165) + 1.0f;
                          _6177 = saturate(abs(_6158) + 9.999999747378752e-06f);
                          _6178 = sqrt(_6168);
                          _6179 = 1.0f - _6178;
                          _6191 = saturate((_6157 + _6072) / (_6072 + 1.0f));
                          _6193 = ((_6168 / (_6172 * _6172)) * _6166) * (0.5f / ((((_6179 * _6177) + _6178) * _6166) + (((_6179 * _6166) + _6178) * _6177)));
                          _6194 = f16tof32(((uint)((uint)(_6054) >> 16))) * _1504;
                          _6195 = f16tof32(_6054) * _1504;
                          _6196 = f16tof32(((uint)((uint)(_6057) >> 16))) * _1504;
                          _6203 = ((_6156 * _6194) * _6191) + _1442;
                          _6204 = ((_6156 * _6195) * _6191) + _1443;
                          _6205 = ((_6156 * _6196) * _6191) + _1444;
                          if (_6069 > 0.0f) {
                            _6217 = (exp2(log2(1.0f - saturate(saturate((_6162 * _6159) + _6162))) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                            _6220 = select(_6154, (_6150 * _1204), _6150) * _6069;
                            _8358 = _6203;
                            _8359 = _6204;
                            _8360 = _6205;
                            _8361 = (((((_6194 * _1073) * _6220) * _6217) * _6193) + _1445);
                            _8362 = (((((_6195 * _1073) * _6220) * _6217) * _6193) + _1446);
                            _8363 = (((((_6196 * _1073) * _6220) * _6217) * _6193) + _1447);
                          } else {
                            _8358 = _6203;
                            _8359 = _6204;
                            _8360 = _6205;
                            _8361 = _1445;
                            _8362 = _1446;
                            _8363 = _1447;
                          }
                        } else {
                          _8358 = _1442;
                          _8359 = _1443;
                          _8360 = _1444;
                          _8361 = _1445;
                          _8362 = _1446;
                          _8363 = _1447;
                        }
                      } else {
                        if (_1487 == 9) {
                          _6241 = asfloat(srvLightInfoProperties.Load4(_1456)).x;
                          _6242 = asfloat(srvLightInfoProperties.Load4(_1456)).y;
                          _6243 = asfloat(srvLightInfoProperties.Load4(_1456)).w;
                          _6246 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).x;
                          _6247 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).y;
                          _6248 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).w;
                          _6251 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).x;
                          _6252 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).y;
                          _6253 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).w;
                          _6256 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 48u)))).x;
                          _6257 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 48u)))).y;
                          _6258 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 48u)))).w;
                          _6261 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 64u)))).x;
                          _6262 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 64u)))).y;
                          _6263 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 64u)))).z;
                          _6266 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 76u)))).x;
                          _6267 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 76u)))).y;
                          _6268 = asfloat(srvLightInfoProperties.Load3(((int)(_1456 + 76u)))).z;
                          _6271 = asint(srvLightInfoProperties.Load(((int)(_1456 + 88u))));
                          _6274 = asint(srvLightInfoProperties.Load(((int)(_1456 + 92u))));
                          _6277 = asint(srvLightInfoProperties.Load(((int)(_1456 + 100u))));
                          _6280 = asint(srvLightInfoProperties.Load(((int)(_1456 + 104u))));
                          _6283 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).x;
                          _6284 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).y;
                          _6285 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).z;
                          _6286 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 108u)))).w;
                          _6289 = asint(srvLightInfoProperties.Load(((int)(_1456 + 124u))));
                          _6292 = asint(srvLightInfoProperties.Load(((int)(_1456 + 128u))));
                          _6295 = asint(srvLightInfoProperties.Load(((int)(_1456 + 132u))));
                          _6298 = asint(srvLightInfoProperties.Load(((int)(_1456 + 136u))));
                          _6301 = asint(srvLightInfoProperties.Load(((int)(_1456 + 140u))));
                          _6304 = asint(srvLightInfoProperties.Load(((int)(_1456 + 144u))));
                          _6307 = asint(srvLightInfoProperties.Load(((int)(_1456 + 148u))));
                          _6310 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 152u)))).x;
                          _6311 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 152u)))).y;
                          _6312 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 152u)))).z;
                          _6313 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 152u)))).w;
                          _6316 = asint(srvLightInfoProperties.Load(((int)(_1456 + 168u))));
                          _6319 = asint(srvLightInfoProperties.Load(((int)(_1456 + 172u))));
                          _6322 = asint(srvLightInfoProperties.Load(((int)(_1456 + 180u))));
                          _6324 = f16tof32(((uint)((uint)(_6271) >> 16)));
                          _6325 = f16tof32(_6271);
                          _6327 = f16tof32(((uint)((uint)(_6274) >> 16)));
                          _6331 = ((float)((uint)((uint)(((uint)(_6274) >> 8) & 255)))) * 0.003921499941498041f;
                          _6334 = ((float)((uint)((uint)(_6274 & 255)))) * 0.003921499941498041f;
                          _6335 = f16tof32(_6277);
                          _6337 = f16tof32(((uint)((uint)(_6280) >> 16)));
                          _6341 = f16tof32(_6289);
                          _6345 = _6295 & 65535;
                          _6361 = f16tof32(((uint)((uint)(_6319) >> 16)));
                          _6362 = f16tof32(_6319);
                          _6364 = f16tof32(((uint)((uint)(_6322) >> 16)));
                          _6365 = 1.0f / _6364;
                          _6366 = _6364 + -1.0f;
                          _6367 = f16tof32(_6322);
                          _6368 = _6261 - _212;
                          _6369 = _6262 - _213;
                          _6370 = _6263 + _211;
                          _6371 = dot(float3(_6368, _6369, _6370), float3(_6368, _6369, _6370));
                          _6372 = rsqrt(_6371);
                          _6373 = _6372 * _6371;
                          _6374 = _6372 * _6368;
                          _6375 = _6372 * _6369;
                          _6376 = _6372 * _6370;
                          _6379 = max(0.0f, (_6373 - abs(_6341)));
                          _6380 = _6379 * f16tof32(((uint)((uint)(_6289) >> 16)));
                          _6381 = _6380 * _6380;
                          _6384 = saturate(1.0f - (_6381 * _6381));
                          _6395 = mad(_214, _6253, mad(_213, _6248, (_6243 * _212))) + _6258;
                          _6396 = dot(float3(_190, _191, _192), float3(_6374, _6375, _6376));
                          _6399 = saturate(1.0f - _6396) * f16tof32(_6316);
                          _6406 = ((_6395 * _190) * _6399) + _212;
                          _6407 = ((_6395 * _191) * _6399) + _213;
                          _6408 = ((_6395 * _192) * _6399) - _211;
                          _6420 = mad(_6408, _6253, mad(_6407, _6248, (_6406 * _6243))) + _6258;
                          _6421 = 1.0f / _6420;
                          _6422 = _6421 * (mad(_6408, _6251, mad(_6407, _6246, (_6406 * _6241))) + _6256);
                          _6423 = _6421 * (mad(_6408, _6252, mad(_6407, _6247, (_6406 * _6242))) + _6257);
                          _6426 = (_6422 * _6283) + _6284;
                          _6427 = (_6423 * _6283) + _6284;
                          _6430 = _6426 - saturate(_6426);
                          _6431 = _6427 - saturate(_6427);
                          _6438 = saturate((sqrt((_6430 * _6430) + (_6431 * _6431)) * _6285) + _6286);
                          _6440 = 1.0f - (_6438 * _6438);
                          _6446 = (_6440 * _6440) * (((float)((bool)(uint)((_6420 - f16tof32(((uint)((uint)(_6292) >> 16)))) > 0.0f))) * ((_6384 * _6384) / (select((_6341 < 0.0f), (_6381 * 16.0f), (_6379 * _6379)) + 1.0f)));
                          _6448 = ((_1454 & 3584) == 0);
                          if (!((!(_6446 > 0.0f)) || _6448)) {
                            _6456 = 1.0f - saturate(f16tof32(_6292) * _6420);
                            _6457 = saturate(_6422);
                            _6458 = saturate(_6423);
                            bool __branch_chain_6450;
                            [branch]
                            if ((_1454 & 1024) == 0) {
                              _6721 = 1.0f;
                              _6722 = 0.0f;
                              _6723 = _6456;
                              __branch_chain_6450 = true;
                            } else {
                              _6463 = ((_6457 * _6366) + 0.5f) * _6365;
                              _6465 = ((_6458 * _6366) + 0.5f) * _6365;
                              _6466 = _6456 + f16tof32(((uint)((uint)(_6316) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6295) >> 16))];
                              _6469 = saturate(_6466);
                              _6473 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _6482 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_6473 * 32.665000915527344f) + _125), ((_6473 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _6483 = sin(_6482);
                              _6484 = cos(_6482);
                              _6485 = cbSharedPerViewData.nFrameCounter & 3;
                              _6490 = sqrt((float((int)(_6485)) * 0.25f) + 0.125f) * _6361;
                              _6499 = (_global_7[min((uint)(((int)(0u + (_6485 * 2)))), 127u)]) * _6490;
                              _6500 = (_global_7[min((uint)(((int)(1u + (_6485 * 2)))), 127u)]) * _6490;
                              _6502 = -0.0f - _6483;
                              _6507 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6499, _6500), float2(_6484, _6483)) + _6463), (dot(float2(_6499, _6500), float2(_6502, _6484)) + _6465)));
                              _6512 = _6507.x - _6469;
                              _6514 = select((_6512 < 0.0f), 0.0f, 1.0f);
                              _6516 = _6507.y - _6469;
                              _6518 = select((_6516 < 0.0f), 0.0f, 1.0f);
                              _6522 = _6507.z - _6469;
                              _6524 = select((_6522 < 0.0f), 0.0f, 1.0f);
                              _6528 = _6507.w - _6469;
                              _6530 = select((_6528 < 0.0f), 0.0f, 1.0f);
                              _6537 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _6542 = sqrt((float((int)(_6537)) * 0.25f) + 0.125f) * _6361;
                              _6551 = (_global_7[min((uint)(((int)(0u + (_6537 * 2)))), 127u)]) * _6542;
                              _6552 = (_global_7[min((uint)(((int)(1u + (_6537 * 2)))), 127u)]) * _6542;
                              _6558 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6551, _6552), float2(_6484, _6483)) + _6463), (dot(float2(_6551, _6552), float2(_6502, _6484)) + _6465)));
                              _6563 = _6558.x - _6469;
                              _6565 = select((_6563 < 0.0f), 0.0f, 1.0f);
                              _6569 = _6558.y - _6469;
                              _6571 = select((_6569 < 0.0f), 0.0f, 1.0f);
                              _6575 = _6558.z - _6469;
                              _6577 = select((_6575 < 0.0f), 0.0f, 1.0f);
                              _6581 = _6558.w - _6469;
                              _6583 = select((_6581 < 0.0f), 0.0f, 1.0f);
                              _6590 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _6595 = sqrt((float((int)(_6590)) * 0.25f) + 0.125f) * _6361;
                              _6604 = (_global_7[min((uint)(((int)(0u + (_6590 * 2)))), 127u)]) * _6595;
                              _6605 = (_global_7[min((uint)(((int)(1u + (_6590 * 2)))), 127u)]) * _6595;
                              _6611 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6604, _6605), float2(_6484, _6483)) + _6463), (dot(float2(_6604, _6605), float2(_6502, _6484)) + _6465)));
                              _6616 = _6611.x - _6469;
                              _6618 = select((_6616 < 0.0f), 0.0f, 1.0f);
                              _6622 = _6611.y - _6469;
                              _6624 = select((_6622 < 0.0f), 0.0f, 1.0f);
                              _6628 = _6611.z - _6469;
                              _6630 = select((_6628 < 0.0f), 0.0f, 1.0f);
                              _6634 = _6611.w - _6469;
                              _6636 = select((_6634 < 0.0f), 0.0f, 1.0f);
                              _6643 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _6648 = sqrt((float((int)(_6643)) * 0.25f) + 0.125f) * _6361;
                              _6657 = (_global_7[min((uint)(((int)(0u + (_6643 * 2)))), 127u)]) * _6648;
                              _6658 = (_global_7[min((uint)(((int)(1u + (_6643 * 2)))), 127u)]) * _6648;
                              _6664 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6657, _6658), float2(_6484, _6483)) + _6463), (dot(float2(_6657, _6658), float2(_6502, _6484)) + _6465)));
                              _6669 = _6664.x - _6469;
                              _6671 = select((_6669 < 0.0f), 0.0f, 1.0f);
                              _6675 = _6664.y - _6469;
                              _6677 = select((_6675 < 0.0f), 0.0f, 1.0f);
                              _6681 = _6664.z - _6469;
                              _6683 = select((_6681 < 0.0f), 0.0f, 1.0f);
                              _6687 = _6664.w - _6469;
                              _6689 = select((_6687 < 0.0f), 0.0f, 1.0f);
                              _6690 = ((((((((((((((_6514 + _6518) + _6524) + _6530) + _6565) + _6571) + _6577) + _6583) + _6618) + _6624) + _6630) + _6636) + _6671) + _6677) + _6683) + _6689;
                              _6701 = (saturate(_6690 * 0.0625f) * 2.0f) + -1.0f;
                              _6707 = float((int)(((int)(uint)((int)(_6701 > 0.0f))) - ((int)(uint)((int)(_6701 < 0.0f)))));
                              _6709 = 1.0f - (_6707 * _6701);
                              _6711 = (_6709 * _6709) * _6709;
                              _6718 = 0.5f - ((_6707 * 0.5f) * ((1.0f - _6711) - ((_6709 - _6711) * saturate(((1.0f / _6469) * (1.0f / _6690)) * ((((((((((((((((_6514 * _6512) + (_6518 * _6516)) + (_6524 * _6522)) + (_6530 * _6528)) + (_6565 * _6563)) + (_6571 * _6569)) + (_6577 * _6575)) + (_6583 * _6581)) + (_6618 * _6616)) + (_6624 * _6622)) + (_6630 * _6628)) + (_6636 * _6634)) + (_6671 * _6669)) + (_6677 * _6675)) + (_6683 * _6681)) + (_6689 * _6687))))));
                              [branch]
                              if (_6367 < 1.0f) {
                                _6721 = _6718;
                                _6722 = _6367;
                                _6723 = _6466;
                                __branch_chain_6450 = true;
                              } else {
                                _7191 = _6367;
                                _7192 = _6718;
                                __branch_chain_6450 = false;
                              }
                            }
                            if (__branch_chain_6450) {
                              _6726 = (_6457 * _6310) + _6312;
                              _6727 = (_6458 * _6311) + _6313;
                              if (!((_1454 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _6736 = saturate(_6723);
                                _6740 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _6749 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_6740 * 32.665000915527344f) + _125), ((_6740 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _6750 = sin(_6749);
                                _6751 = cos(_6749);
                                _6756 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_6726, _6727), 0.0f))).x) > _6736), 1.0f, 0.0f);
                                _6757 = cbSharedPerViewData.nFrameCounter & 3;
                                _6762 = sqrt((float((int)(_6757)) * 0.25f) + 0.125f) * _6362;
                                _6771 = (_global_7[min((uint)(((int)(0u + (_6757 * 2)))), 127u)]) * _6762;
                                _6772 = (_global_7[min((uint)(((int)(1u + (_6757 * 2)))), 127u)]) * _6762;
                                _6774 = -0.0f - _6750;
                                _6776 = dot(float2(_6771, _6772), float2(_6751, _6750)) + _6726;
                                _6777 = dot(float2(_6771, _6772), float2(_6774, _6751)) + _6727;
                                _6779 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6776, _6777));
                                _6783 = _6776 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6784 = _6777 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6787 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6312);
                                _6788 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6313);
                                _6793 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6310 + _6312)) + 0.5f);
                                _6794 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6311 + _6313)) + 0.5f);
                                _6797 = floor(_6783 + -0.5f);
                                _6798 = floor(_6784 + 0.5f);
                                _6800 = floor(_6783 + 0.5f);
                                _6802 = floor(_6784 + -0.5f);
                                _6803 = (_6797 < _6787);
                                _6804 = (_6798 < _6788);
                                if ((_6803 || _6804) | ((_6797 >= _6793) || (_6798 >= _6794))) {
                                  _6813 = _6756;
                                } else {
                                  _6813 = _6779.x;
                                }
                                _6814 = (_6800 < _6787);
                                if ((_6814 || _6804) | ((_6800 >= _6793) || (_6798 >= _6794))) {
                                  _6822 = _6756;
                                } else {
                                  _6822 = _6779.y;
                                }
                                _6823 = (_6802 < _6788);
                                if ((_6814 || _6823) | ((_6800 >= _6793) || (_6802 >= _6794))) {
                                  _6831 = _6756;
                                } else {
                                  _6831 = _6779.z;
                                }
                                if ((_6803 || _6823) | ((_6797 >= _6793) || (_6802 >= _6794))) {
                                  _6839 = _6756;
                                } else {
                                  _6839 = _6779.w;
                                }
                                _6840 = _6813 - _6736;
                                _6842 = select((_6840 < 0.0f), 0.0f, 1.0f);
                                _6844 = _6822 - _6736;
                                _6846 = select((_6844 < 0.0f), 0.0f, 1.0f);
                                _6850 = _6831 - _6736;
                                _6852 = select((_6850 < 0.0f), 0.0f, 1.0f);
                                _6856 = _6839 - _6736;
                                _6858 = select((_6856 < 0.0f), 0.0f, 1.0f);
                                _6865 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _6870 = sqrt((float((int)(_6865)) * 0.25f) + 0.125f) * _6362;
                                _6879 = (_global_7[min((uint)(((int)(0u + (_6865 * 2)))), 127u)]) * _6870;
                                _6880 = (_global_7[min((uint)(((int)(1u + (_6865 * 2)))), 127u)]) * _6870;
                                _6883 = dot(float2(_6879, _6880), float2(_6751, _6750)) + _6726;
                                _6884 = dot(float2(_6879, _6880), float2(_6774, _6751)) + _6727;
                                _6886 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6883, _6884));
                                _6890 = _6883 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6891 = _6884 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6894 = floor(_6890 + -0.5f);
                                _6895 = floor(_6891 + 0.5f);
                                _6897 = floor(_6890 + 0.5f);
                                _6899 = floor(_6891 + -0.5f);
                                _6900 = (_6894 < _6787);
                                _6901 = (_6895 < _6788);
                                if ((_6900 || _6901) | ((_6894 >= _6793) || (_6895 >= _6794))) {
                                  _6910 = _6756;
                                } else {
                                  _6910 = _6886.x;
                                }
                                _6911 = (_6897 < _6787);
                                if ((_6911 || _6901) | ((_6897 >= _6793) || (_6895 >= _6794))) {
                                  _6919 = _6756;
                                } else {
                                  _6919 = _6886.y;
                                }
                                _6920 = (_6899 < _6788);
                                if ((_6911 || _6920) | ((_6897 >= _6793) || (_6899 >= _6794))) {
                                  _6928 = _6756;
                                } else {
                                  _6928 = _6886.z;
                                }
                                if ((_6900 || _6920) | ((_6894 >= _6793) || (_6899 >= _6794))) {
                                  _6936 = _6756;
                                } else {
                                  _6936 = _6886.w;
                                }
                                _6937 = _6910 - _6736;
                                _6939 = select((_6937 < 0.0f), 0.0f, 1.0f);
                                _6943 = _6919 - _6736;
                                _6945 = select((_6943 < 0.0f), 0.0f, 1.0f);
                                _6949 = _6928 - _6736;
                                _6951 = select((_6949 < 0.0f), 0.0f, 1.0f);
                                _6955 = _6936 - _6736;
                                _6957 = select((_6955 < 0.0f), 0.0f, 1.0f);
                                _6964 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _6969 = sqrt((float((int)(_6964)) * 0.25f) + 0.125f) * _6362;
                                _6978 = (_global_7[min((uint)(((int)(0u + (_6964 * 2)))), 127u)]) * _6969;
                                _6979 = (_global_7[min((uint)(((int)(1u + (_6964 * 2)))), 127u)]) * _6969;
                                _6982 = dot(float2(_6978, _6979), float2(_6751, _6750)) + _6726;
                                _6983 = dot(float2(_6978, _6979), float2(_6774, _6751)) + _6727;
                                _6985 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6982, _6983));
                                _6989 = _6982 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6990 = _6983 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6993 = floor(_6989 + -0.5f);
                                _6994 = floor(_6990 + 0.5f);
                                _6996 = floor(_6989 + 0.5f);
                                _6998 = floor(_6990 + -0.5f);
                                _6999 = (_6993 < _6787);
                                _7000 = (_6994 < _6788);
                                if ((_6999 || _7000) | ((_6993 >= _6793) || (_6994 >= _6794))) {
                                  _7009 = _6756;
                                } else {
                                  _7009 = _6985.x;
                                }
                                _7010 = (_6996 < _6787);
                                if ((_7010 || _7000) | ((_6996 >= _6793) || (_6994 >= _6794))) {
                                  _7018 = _6756;
                                } else {
                                  _7018 = _6985.y;
                                }
                                _7019 = (_6998 < _6788);
                                if ((_7010 || _7019) | ((_6996 >= _6793) || (_6998 >= _6794))) {
                                  _7027 = _6756;
                                } else {
                                  _7027 = _6985.z;
                                }
                                if ((_6999 || _7019) | ((_6993 >= _6793) || (_6998 >= _6794))) {
                                  _7035 = _6756;
                                } else {
                                  _7035 = _6985.w;
                                }
                                _7036 = _7009 - _6736;
                                _7038 = select((_7036 < 0.0f), 0.0f, 1.0f);
                                _7042 = _7018 - _6736;
                                _7044 = select((_7042 < 0.0f), 0.0f, 1.0f);
                                _7048 = _7027 - _6736;
                                _7050 = select((_7048 < 0.0f), 0.0f, 1.0f);
                                _7054 = _7035 - _6736;
                                _7056 = select((_7054 < 0.0f), 0.0f, 1.0f);
                                _7063 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _7068 = sqrt((float((int)(_7063)) * 0.25f) + 0.125f) * _6362;
                                _7077 = (_global_7[min((uint)(((int)(0u + (_7063 * 2)))), 127u)]) * _7068;
                                _7078 = (_global_7[min((uint)(((int)(1u + (_7063 * 2)))), 127u)]) * _7068;
                                _7081 = dot(float2(_7077, _7078), float2(_6751, _6750)) + _6726;
                                _7082 = dot(float2(_7077, _7078), float2(_6774, _6751)) + _6727;
                                _7084 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7081, _7082));
                                _7088 = _7081 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7089 = _7082 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7092 = floor(_7088 + -0.5f);
                                _7093 = floor(_7089 + 0.5f);
                                _7095 = floor(_7088 + 0.5f);
                                _7097 = floor(_7089 + -0.5f);
                                _7098 = (_7092 < _6787);
                                _7099 = (_7093 < _6788);
                                if ((_7098 || _7099) | ((_7092 >= _6793) || (_7093 >= _6794))) {
                                  _7108 = _6756;
                                } else {
                                  _7108 = _7084.x;
                                }
                                _7109 = (_7095 < _6787);
                                if ((_7109 || _7099) | ((_7095 >= _6793) || (_7093 >= _6794))) {
                                  _7117 = _6756;
                                } else {
                                  _7117 = _7084.y;
                                }
                                _7118 = (_7097 < _6788);
                                if ((_7109 || _7118) | ((_7095 >= _6793) || (_7097 >= _6794))) {
                                  _7126 = _6756;
                                } else {
                                  _7126 = _7084.z;
                                }
                                if ((_7098 || _7118) | ((_7092 >= _6793) || (_7097 >= _6794))) {
                                  _7134 = _6756;
                                } else {
                                  _7134 = _7084.w;
                                }
                                _7135 = _7108 - _6736;
                                _7137 = select((_7135 < 0.0f), 0.0f, 1.0f);
                                _7141 = _7117 - _6736;
                                _7143 = select((_7141 < 0.0f), 0.0f, 1.0f);
                                _7147 = _7126 - _6736;
                                _7149 = select((_7147 < 0.0f), 0.0f, 1.0f);
                                _7153 = _7134 - _6736;
                                _7155 = select((_7153 < 0.0f), 0.0f, 1.0f);
                                _7156 = ((((((((((((((_6846 + _6842) + _6852) + _6858) + _6939) + _6945) + _6951) + _6957) + _7038) + _7044) + _7050) + _7056) + _7137) + _7143) + _7149) + _7155;
                                _7167 = (saturate(_7156 * 0.0625f) * 2.0f) + -1.0f;
                                _7173 = float((int)(((int)(uint)((int)(_7167 > 0.0f))) - ((int)(uint)((int)(_7167 < 0.0f)))));
                                _7175 = 1.0f - (_7173 * _7167);
                                _7177 = (_7175 * _7175) * _7175;
                                _7186 = (0.5f - ((_7173 * 0.5f) * ((1.0f - _7177) - ((_7175 - _7177) * saturate(((1.0f / _6736) * (1.0f / _7156)) * ((((((((((((((((_6846 * _6844) + (_6842 * _6840)) + (_6852 * _6850)) + (_6858 * _6856)) + (_6939 * _6937)) + (_6945 * _6943)) + (_6951 * _6949)) + (_6957 * _6955)) + (_7038 * _7036)) + (_7044 * _7042)) + (_7050 * _7048)) + (_7056 * _7054)) + (_7137 * _7135)) + (_7143 * _7141)) + (_7149 * _7147)) + (_7155 * _7153)))))));
                              } else {
                                _7186 = 1.0f;
                              }
                              _7191 = _6722;
                              _7192 = (lerp(_7186, _6721, _6722));
                            }
                            [branch]
                            if (!((_1454 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6298) >> 16))];
                              _7198 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6422, _6423), 0.0f);
                              if (_7198.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6298 & 65535))];
                                _7205 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6422, _6423), 0.0f);
                                _7219 = mad(saturate(((log2(_6373) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _7220 = max(9.999999747378752e-06f, _7198.x);
                                _7221 = _7205.x / _7220;
                                _7222 = _7205.y / _7220;
                                _7224 = _7205.w / _7220;
                                _7229 = ((0.375f - _7222) * 4.999999873689376e-06f) + _7222;
                                _7232 = -0.0f - _7221;
                                _7233 = mad(_7232, _7229, (_7205.z / _7220));
                                _7235 = 1.0f / mad(_7232, _7221, _7229);
                                _7236 = _7235 * _7233;
                                _7241 = _7219 - _7221;
                                _7246 = (((_7219 * _7219) - _7229) - (_7236 * _7241)) / mad((-0.0f - _7233), _7236, mad((-0.0f - _7229), _7229, (((0.375f - _7224) * 4.999999873689376e-06f) + _7224)));
                                _7248 = (_7235 * _7241) - (_7246 * _7236);
                                _7251 = 1.0f / _7246;
                                _7252 = _7248 * _7251;
                                _7257 = sqrt(((_7252 * _7252) * 0.25f) - ((1.0f - dot(float2(_7248, _7246), float2(_7221, _7229))) * _7251));
                                _7259 = (_7252 * -0.5f) - _7257;
                                _7261 = _7257 - (_7252 * 0.5f);
                                _7263 = select((_7259 < _7219), 1.0f, 0.0f);
                                _7268 = (_7263 + -0.05000000074505806f) / (_7259 - _7219);
                                _7274 = (((select((_7261 < _7219), 1.0f, 0.0f) - _7263) / (_7261 - _7259)) - _7268) / (_7261 - _7219);
                                _7276 = _7268 - (_7274 * _7259);
                                _7289 = _7191;
                                _7290 = (exp2((_7198.x * -1.4426950216293335f) * saturate((dot(float2(_7221, _7229), float2((_7276 - (_7274 * _7219)), _7274)) + 0.05000000074505806f) - (_7276 * _7219))) * _7192);
                              } else {
                                _7289 = _7191;
                                _7290 = _7192;
                              }
                            } else {
                              _7289 = _7191;
                              _7290 = _7192;
                            }
                          } else {
                            _7289 = 0.0f;
                            _7290 = 1.0f;
                          }
                          [branch]
                          if (!(_6345 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6345)))];
                            _7303 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6422 * f16tof32(((uint)((uint)(_6304) >> 16)))) + f16tof32(((uint)((uint)(_6307) >> 16)))), ((_6423 * f16tof32(_6304)) + f16tof32(_6307))), 0.0f);
                            _7311 = (_7303.x * _6324);
                            _7312 = (_7303.y * _6325);
                            _7313 = (_7303.z * _6327);
                          } else {
                            _7311 = _6324;
                            _7312 = _6325;
                            _7313 = _6327;
                          }
                          _7314 = _7290 * _6446;
                          [branch]
                          if (!(_7314 == 0.0f)) {
                            bool __branch_chain_7316;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _7332 = 0;
                              __branch_chain_7316 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _7332 = 1;
                                __branch_chain_7316 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _7332 = 2;
                                  __branch_chain_7316 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1457) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _7332 = 3;
                                    __branch_chain_7316 = true;
                                  } else {
                                    _7357 = _7314;
                                    __branch_chain_7316 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_7316) {
                              while(true) {
                                _7335 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                if (_7332 == 0) {
                                  _7349 = _7335.x;
                                } else {
                                  if (_7332 == 1) {
                                    _7349 = _7335.y;
                                  } else {
                                    if (_7332 == 2) {
                                      _7349 = _7335.z;
                                    } else {
                                      _7349 = _7335.w;
                                    }
                                  }
                                }
                                _7357 = ((((_7289 * _7289) * ((_7349 * _7349) + -1.0f)) + 1.0f) * _6446);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_7357 > 0.0f) {
                                if (!(((_6301 & 1) == 0) || _6448)) {
                                  _7373 = max(max(_7311, _7312), _7313);
                                  if (_7373 > 0.0f) {
                                    _7383 = saturate(_7311 / _7373);
                                    _7384 = saturate(_7312 / _7373);
                                    _7385 = saturate(_7313 / _7373);
                                  } else {
                                    _7383 = _7311;
                                    _7384 = _7312;
                                    _7385 = _7313;
                                  }
                                  _7386 = (_7384 < _7385);
                                  _7387 = select(_7386, _7385, _7384);
                                  _7388 = select(_7386, _7384, _7385);
                                  _7389 = select(_7386, -1.0f, 0.0f);
                                  _7390 = (_7383 < _7387);
                                  _7392 = select(_7390, _7387, _7383);
                                  _7393 = select(_7390, _7383, _7387);
                                  _7397 = _7392 - select((_7393 < _7388), _7393, _7388);
                                  _7403 = abs(select(_7390, (-0.3333333432674408f - _7389), _7389) + ((_7393 - _7388) / ((_7397 * 6.0f) + 9.999999682655225e-21f)));
                                  if (_7403 < 0.6666666865348816f) {
                                    _7416 = ((saturate(((float)((uint)((uint)(((uint)(_6301) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7403 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7403)) + _7403);
                                  } else {
                                    _7416 = _7403;
                                  }
                                  _7417 = saturate((_7397 / (_7392 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6301) >> 1) & 255)))) * 0.003921499941498041f));
                                  _7418 = saturate(_7392);
                                  if (!(_7417 <= 0.0f)) {
                                    _7421 = saturate(_7416);
                                    _7425 = select(((_7421 * 360.0f) >= 360.0f), 0.0f, (_7421 * 6.0f));
                                    _7426 = int(_7425);
                                    _7428 = _7425 - float((int)(_7426));
                                    _7430 = _7418 * (1.0f - _7417);
                                    _7433 = (1.0f - (_7428 * _7417)) * _7418;
                                    _7437 = (1.0f - ((1.0f - _7428) * _7417)) * _7418;
                                    switch (_7426) {
                                      case 0: {
                                        _7445 = _7418;
                                        _7446 = _7437;
                                        _7447 = _7430;
                                        break;
                                      }
                                      case 1: {
                                        _7445 = _7433;
                                        _7446 = _7418;
                                        _7447 = _7430;
                                        break;
                                      }
                                      case 2: {
                                        _7445 = _7430;
                                        _7446 = _7418;
                                        _7447 = _7437;
                                        break;
                                      }
                                      case 3: {
                                        _7445 = _7430;
                                        _7446 = _7433;
                                        _7447 = _7418;
                                        break;
                                      }
                                      case 4: {
                                        _7445 = _7437;
                                        _7446 = _7430;
                                        _7447 = _7418;
                                        break;
                                      }
                                      case 5: {
                                        _7445 = _7418;
                                        _7446 = _7430;
                                        _7447 = _7433;
                                        break;
                                      }
                                      default: {
                                        _7445 = 0.0f;
                                        _7446 = 0.0f;
                                        _7447 = 0.0f;
                                        break;
                                      }
                                    }
                                  } else {
                                    _7445 = _7418;
                                    _7446 = _7418;
                                    _7447 = _7418;
                                  }
                                  _7448 = _7445 * _7373;
                                  _7449 = _7446 * _7373;
                                  _7450 = _7447 * _7373;
                                  _7452 = saturate(_7290 * 1.0101009607315063f);
                                  _7463 = ((_7452 * (_7311 - _7448)) + _7448);
                                  _7464 = ((_7452 * (_7312 - _7449)) + _7449);
                                  _7465 = (lerp(_7450, _7313, _7452));
                                } else {
                                  _7463 = _7311;
                                  _7464 = _7312;
                                  _7465 = _7313;
                                }
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _7472 = srvLightMappingData[_1457];
                                  if (!(_7472 == -1)) {
                                    _7477 = srvLightIndexData[_7472].nLayerIndex;
                                    _7479 = srvLightIndexData[_7472].vAtlasOrigin.x;
                                    _7480 = srvLightIndexData[_7472].vAtlasOrigin.y;
                                    _7482 = srvLightIndexData[_7472].vScreenOrigin.x;
                                    _7483 = srvLightIndexData[_7472].vScreenOrigin.y;
                                    _7492 = ((int)(_7477 * 5)) & 31;
                                    _7501 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7479 + _63) - _7482)), ((int)((_7480 + _64) - _7483)), 0)))).x) & ((int)(31 << _7492)))) >> _7492)) >> 1)))) * 0.06666667014360428f) * _7357);
                                  } else {
                                    _7501 = _7357;
                                  }
                                } else {
                                  _7501 = _7357;
                                }
                                _7505 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _7508 = select(_7505, (_7501 * _1204), _7501);
                                _7510 = _6374 * _6373;
                                _7511 = _6375 * _6373;
                                _7512 = _6376 * _6373;
                                _7513 = _6335 * _6266;
                                _7514 = _6335 * _6267;
                                _7515 = _6335 * _6268;
                                _7516 = _7510 + _7513;
                                _7517 = _7511 + _7514;
                                _7518 = _7512 + _7515;
                                _7519 = _7510 - _7513;
                                _7520 = _7511 - _7514;
                                _7521 = _7512 - _7515;
                                _7522 = (_6335 > 0.0f);
                                _7523 = dot(float3(_7516, _7517, _7518), float3(_7516, _7517, _7518));
                                _7524 = rsqrt(_7523);
                                [branch]
                                if (_7522) {
                                  _7527 = rsqrt(dot(float3(_7519, _7520, _7521), float3(_7519, _7520, _7521)));
                                  _7528 = _7527 * _7524;
                                  _7530 = dot(float3(_7516, _7517, _7518), float3(_7519, _7520, _7521)) * _7528;
                                  _7549 = (_7528 / ((_7528 + 0.5f) + (_7530 * 0.5f)));
                                  _7550 = (((dot(float3(_190, _191, _192), float3(_7519, _7520, _7521)) * _7527) + (dot(float3(_190, _191, _192), float3(_7516, _7517, _7518)) * _7524)) * 0.5f);
                                  _7551 = _7530;
                                } else {
                                  _7549 = (1.0f / (_7523 + 1.0f));
                                  _7550 = dot(float3(_190, _191, _192), float3((_7524 * _7516), (_7524 * _7517), (_7524 * _7518)));
                                  _7551 = 1.0f;
                                }
                                if (_6337 > 0.0f) {
                                  _7557 = sqrt(saturate((_6337 * _6337) * _7549));
                                  if (_7550 < _7557) {
                                    _7562 = max(_7550, (-0.0f - _7557)) + _7557;
                                    _7567 = ((_7562 * _7562) / (_7557 * 4.0f));
                                  } else {
                                    _7567 = _7550;
                                  }
                                } else {
                                  _7567 = _7550;
                                }
                                if (_7522) {
                                  _7569 = -0.0f - _385;
                                  _7570 = -0.0f - _386;
                                  _7571 = -0.0f - _384;
                                  _7573 = dot(float3(_7569, _7570, _7571), float3(_190, _191, _192)) * 2.0f;
                                  _7577 = _7569 - (_7573 * _190);
                                  _7578 = _7570 - (_7573 * _191);
                                  _7579 = _7571 - (_7573 * _192);
                                  _7580 = _7519 - _7516;
                                  _7581 = _7520 - _7517;
                                  _7582 = _7521 - _7518;
                                  _7583 = dot(float3(_7577, _7578, _7579), float3(_7580, _7581, _7582));
                                  _7589 = sqrt(((_7580 * _7580) + (_7581 * _7581)) + (_7582 * _7582));
                                  _7598 = saturate(((dot(float3(_7577, _7578, _7579), float3(_7516, _7517, _7518)) * _7583) - dot(float3(_7516, _7517, _7518), float3(_7580, _7581, _7582))) / ((_7589 * _7589) - (_7583 * _7583)));
                                  _7602 = (_7598 * _7580) + _7516;
                                  _7603 = (_7598 * _7581) + _7517;
                                  _7604 = (_7598 * _7582) + _7518;
                                  _7605 = dot(float3(_7602, _7603, _7604), float3(_7577, _7578, _7579));
                                  _7609 = (_7605 * _7577) - _7602;
                                  _7610 = (_7605 * _7578) - _7603;
                                  _7611 = (_7605 * _7579) - _7604;
                                  _7619 = saturate(0.009999999776482582f / sqrt(((_7609 * _7609) + (_7610 * _7610)) + (_7611 * _7611)));
                                  _7627 = ((_7619 * _7609) + _7602);
                                  _7628 = ((_7619 * _7610) + _7603);
                                  _7629 = ((_7619 * _7611) + _7604);
                                } else {
                                  _7627 = _7516;
                                  _7628 = _7517;
                                  _7629 = _7518;
                                }
                                _7631 = rsqrt(dot(float3(_7627, _7628, _7629), float3(_7627, _7628, _7629)));
                                _7632 = _7631 * _7627;
                                _7633 = _7631 * _7628;
                                _7634 = _7631 * _7629;
                                _7635 = _201 * _201;
                                _7639 = saturate((_6337 * (1.0f - _7635)) * _7631);
                                _7641 = saturate(_7631 * f16tof32(_6280));
                                _7643 = rsqrt(dot(float3(_7510, _7511, _7512), float3(_7510, _7511, _7512)));
                                _7647 = dot(float3(_190, _191, _192), float3(_7632, _7633, _7634));
                                _7648 = dot(float3(_190, _191, _192), float3(_385, _386, _384));
                                _7649 = dot(float3(_385, _386, _384), float3(_7632, _7633, _7634));
                                _7652 = rsqrt((_7649 * 2.0f) + 2.0f);
                                _7659 = (_7639 > 0.0f);
                                if (_7659) {
                                  _7663 = sqrt(1.0f - (_7639 * _7639));
                                  _7665 = (_7647 * 2.0f) * _7648;
                                  _7666 = _7665 - _7649;
                                  if (!(_7666 >= _7663)) {
                                    _7674 = rsqrt(1.0f - (_7666 * _7666)) * _7639;
                                    _7677 = _7674 * (_7648 - (_7666 * _7647));
                                    _7678 = _7648 * _7648;
                                    _7683 = _7674 * (((_7678 * 2.0f) + -1.0f) - (_7666 * _7649));
                                    _7692 = sqrt(saturate((((1.0f - (_7647 * _7647)) - _7678) - (_7649 * _7649)) + (_7665 * _7649)));
                                    _7693 = _7692 * _7674;
                                    _7696 = ((_7648 * 2.0f) * _7674) * _7692;
                                    _7698 = (_7663 * _7647) + _7648;
                                    _7699 = _7698 + _7677;
                                    _7700 = _7663 * _7649;
                                    _7702 = (_7700 + 1.0f) + _7683;
                                    _7703 = _7693 * _7702;
                                    _7704 = _7699 * _7702;
                                    _7705 = _7696 * _7699;
                                    _7710 = (((_7699 * 0.25f) * _7696) - (_7703 * 0.5f)) * _7704;
                                    _7724 = (((_7705 - (_7703 * 2.0f)) * _7705) + (_7703 * _7703)) + ((((-0.5f - ((_7702 + _7700) * 0.5f)) * _7704) + ((_7702 * _7702) * _7698)) * _7699);
                                    _7729 = (_7710 * 2.0f) / ((_7724 * _7724) + (_7710 * _7710));
                                    _7730 = _7724 * _7729;
                                    _7732 = 1.0f - (_7710 * _7729);
                                    _7738 = ((_7730 * _7696) + _7700) + (_7732 * _7683);
                                    _7741 = rsqrt((_7738 * 2.0f) + 2.0f);
                                    _7750 = saturate((_7738 * _7741) + _7741);
                                    _7751 = saturate(((_7698 + (_7730 * _7693)) + (_7732 * _7677)) * _7741);
                                  } else {
                                    _7750 = abs(_7648);
                                    _7751 = 1.0f;
                                  }
                                } else {
                                  _7750 = saturate((_7652 * _7649) + _7652);
                                  _7751 = saturate(_7652 * (_7648 + _7647));
                                }
                                _7752 = saturate(_7567);
                                _7754 = _7635 * _7635;
                                if (_7641 > 0.0f) {
                                  _7764 = saturate(((_7641 * _7641) / ((_7750 * 3.5999999046325684f) + 0.4000000059604645f)) + _7754);
                                } else {
                                  _7764 = _7754;
                                }
                                if (_7659) {
                                  _7773 = (((_7639 * 0.25f) * ((sqrt(_7764) * 3.0f) + _7639)) / (_7750 + 0.0010000000474974513f)) + _7764;
                                  _7776 = _7773;
                                  _7777 = (_7764 / _7773);
                                } else {
                                  _7776 = _7764;
                                  _7777 = 1.0f;
                                }
                                if (_7551 < 1.0f) {
                                  _7784 = sqrt((1.000100016593933f - _7551) / max(9.999999974752427e-07f, (_7551 + 1.0f)));
                                  _7797 = (sqrt(_7776 / ((((_7784 * 0.25f) * ((sqrt(_7776) * 3.0f) + _7784)) / (_7750 + 0.0010000000474974513f)) + _7776)) * _7777);
                                } else {
                                  _7797 = _7777;
                                }
                                _7801 = (((_7764 * _7751) - _7751) * _7751) + 1.0f;
                                _7806 = saturate(abs(_7648) + 9.999999747378752e-06f);
                                _7807 = sqrt(_7764);
                                _7808 = 1.0f - _7807;
                                _7820 = saturate((dot(float3(_190, _191, _192), float3((_7643 * _7510), (_7643 * _7511), (_7643 * _7512))) + _6334) / (_6334 + 1.0f));
                                _7823 = ((_7797 * _7752) * (_7764 / (_7801 * _7801))) * (0.5f / ((((_7808 * _7806) + _7807) * _7752) + (((_7808 * _7752) + _7807) * _7806)));
                                _7824 = _7463 * _1504;
                                _7825 = _7464 * _1504;
                                _7826 = _7465 * _1504;
                                if (_6331 > 0.0f) {
                                  _7844 = (exp2(log2(1.0f - saturate(_7750)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                  _7845 = select(_7505, (_7501 * _1204), _7501) * _6331;
                                  _7862 = (((((_7824 * _1073) * _7845) * _7844) * _7823) + _1445);
                                  _7863 = (((((_7825 * _1073) * _7845) * _7844) * _7823) + _1446);
                                  _7864 = (((((_7826 * _1073) * _7845) * _7844) * _7823) + _1447);
                                } else {
                                  _7862 = _1445;
                                  _7863 = _1446;
                                  _7864 = _1447;
                                }
                                _7870 = saturate(-0.0f - dot(float3(_385, _386, _384), float3(_6374, _6375, _6376)));
                                _7873 = 1.0f - ((_7870 * _7870) * 0.6399999856948853f);
                                _7878 = saturate(0.30000001192092896f - _6396) * (0.36000001430511475f / (_7873 * _7873));
                                _7879 = _6446 * _1504;
                                _8358 = (((_7508 * _7824) * _7820) + _1442);
                                _8359 = (((_7508 * _7825) * _7820) + _1443);
                                _8360 = (((_7508 * _7826) * _7820) + _1444);
                                _8361 = ((((_167 * _203) * _7879) * _7878) + _7862);
                                _8362 = ((((_167 * _204) * _7879) * _7878) + _7863);
                                _8363 = ((((_205 * _167) * _7879) * _7878) + _7864);
                              } else {
                                _8358 = _1442;
                                _8359 = _1443;
                                _8360 = _1444;
                                _8361 = _1445;
                                _8362 = _1446;
                                _8363 = _1447;
                              }
                              break;
                            }
                          } else {
                            _8358 = _1442;
                            _8359 = _1443;
                            _8360 = _1444;
                            _8361 = _1445;
                            _8362 = _1446;
                            _8363 = _1447;
                          }
                        } else {
                          if (_1487 == 10) {
                            _7894 = asfloat(srvLightInfoProperties.Load4(_1456)).x;
                            _7895 = asfloat(srvLightInfoProperties.Load4(_1456)).y;
                            _7896 = asfloat(srvLightInfoProperties.Load4(_1456)).z;
                            _7897 = asfloat(srvLightInfoProperties.Load4(_1456)).w;
                            _7900 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).x;
                            _7901 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).y;
                            _7902 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).z;
                            _7903 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 16u)))).w;
                            _7906 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).x;
                            _7907 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).y;
                            _7908 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).z;
                            _7909 = asfloat(srvLightInfoProperties.Load4(((int)(_1456 + 32u)))).w;
                            _7912 = asfloat(srvLightInfoProperties.Load2(((int)(_1456 + 72u)))).x;
                            _7913 = asfloat(srvLightInfoProperties.Load2(((int)(_1456 + 72u)))).y;
                            _7916 = asint(srvLightInfoProperties.Load(((int)(_1456 + 80u))));
                            _7919 = asint(srvLightInfoProperties.Load(((int)(_1456 + 84u))));
                            _7922 = asint(srvLightInfoProperties.Load(((int)(_1456 + 88u))));
                            _7925 = asint(srvLightInfoProperties.Load(((int)(_1456 + 96u))));
                            _7928 = f16tof32(_7916);
                            _7930 = f16tof32(((uint)((uint)(_7919) >> 16)));
                            _7931 = f16tof32(_7919);
                            _7933 = f16tof32(((uint)((uint)(_7922) >> 16)));
                            _7937 = ((float)((uint)((uint)(((uint)(_7922) >> 8) & 255)))) * 0.003921499941498041f;
                            _7939 = (float)((uint)((uint)(_7925 & 65535)));
                            _7943 = mad(_7896, _214, mad(_7895, _213, (_7894 * _212))) + _7897;
                            _7947 = mad(_7902, _214, mad(_7901, _213, (_7900 * _212))) + _7903;
                            _7951 = mad(_7908, _214, mad(_7907, _213, (_7906 * _212))) + _7909;
                            _7954 = mad(_7896, _192, mad(_7895, _191, (_7894 * _190)));
                            _7957 = mad(_7902, _192, mad(_7901, _191, (_7900 * _190)));
                            _7960 = mad(_7908, _192, mad(_7907, _191, (_7906 * _190)));
                            _7972 = -0.0f - mad(_7908, _384, mad(_7907, _386, (_7906 * _385)));
                            _7973 = _7912 * 0.5f;
                            _7974 = _7913 * 0.5f;
                            _7975 = -0.0f - _7973;
                            _7976 = -0.0f - _7974;
                            _7977 = _7975 - _7943;
                            _7978 = _7976 - _7947;
                            _7979 = -0.0f - _7951;
                            _7980 = _7973 - _7943;
                            _7981 = _7974 - _7947;
                            _7982 = dot(float3(_7943, _7947, _7951), float3(_7954, _7957, _7960));
                            _7984 = dot(float3(_7975, _7976, 0.0f), float3(_7954, _7957, _7960)) - _7982;
                            _7986 = dot(float3(_7973, _7976, 0.0f), float3(_7954, _7957, _7960)) - _7982;
                            _7988 = dot(float3(_7973, _7974, 0.0f), float3(_7954, _7957, _7960)) - _7982;
                            _7990 = dot(float3(_7975, _7974, 0.0f), float3(_7954, _7957, _7960)) - _7982;
                            _7991 = min(_7984, _7986);
                            [branch]
                            if (!(!(_7991 >= 0.0f))) {
                              _7997 = rsqrt(dot(float3(_7980, _7978, _7979), float3(_7980, _7978, _7979)) * dot(float3(_7977, _7978, _7979), float3(_7977, _7978, _7979)));
                              _7999 = dot(float3(_7977, _7978, _7979), float3(_7980, _7978, _7979)) * _7997;
                              _8006 = rsqrt(max(((((_7999 * 0.09300000220537186f) + 0.5f) * _7999) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7997;
                              _8013 = (_8006 * (_7912 * _7979));
                              _8014 = (_8006 * (_7978 * (_7975 - _7973)));
                            } else {
                              _8013 = 0.0f;
                              _8014 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_7986, _7988) >= 0.0f))) {
                              _8021 = rsqrt(dot(float3(_7980, _7981, _7979), float3(_7980, _7981, _7979)) * dot(float3(_7980, _7978, _7979), float3(_7980, _7978, _7979)));
                              _8023 = dot(float3(_7980, _7978, _7979), float3(_7980, _7981, _7979)) * _8021;
                              _8030 = rsqrt(max(((((_8023 * 0.09300000220537186f) + 0.5f) * _8023) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8021;
                              _8038 = (_8030 * ((_7976 - _7974) * _7979));
                              _8039 = ((_8030 * (_7913 * _7980)) + _8014);
                            } else {
                              _8038 = 0.0f;
                              _8039 = _8014;
                            }
                            _8040 = min(_7988, _7990);
                            [branch]
                            if (!(!(_8040 >= 0.0f))) {
                              _8046 = rsqrt(dot(float3(_7977, _7981, _7979), float3(_7977, _7981, _7979)) * dot(float3(_7980, _7981, _7979), float3(_7980, _7981, _7979)));
                              _8048 = dot(float3(_7980, _7981, _7979), float3(_7977, _7981, _7979)) * _8046;
                              _8055 = rsqrt(max(((((_8048 * 0.09300000220537186f) + 0.5f) * _8048) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8046;
                              _8064 = ((_8055 * ((_7975 - _7973) * _7979)) + _8013);
                              _8065 = ((_8055 * (_7912 * _7981)) + _8039);
                            } else {
                              _8064 = _8013;
                              _8065 = _8039;
                            }
                            [branch]
                            if (!(!(min(_7990, _7984) >= 0.0f))) {
                              _8072 = rsqrt(dot(float3(_7977, _7978, _7979), float3(_7977, _7978, _7979)) * dot(float3(_7977, _7981, _7979), float3(_7977, _7981, _7979)));
                              _8074 = dot(float3(_7977, _7981, _7979), float3(_7977, _7978, _7979)) * _8072;
                              _8081 = rsqrt(max(((((_8074 * 0.09300000220537186f) + 0.5f) * _8074) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8072;
                              _8090 = ((_8081 * (_7913 * _7979)) + _8038);
                              _8091 = ((_8081 * (_7977 * (_7976 - _7974))) + _8065);
                            } else {
                              _8090 = _8038;
                              _8091 = _8065;
                            }
                            if (min(_7991, _8040) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_7984, _7986), max(_7988, _7990)) >= 0.0f))) {
                                _8100 = -0.0f - _7954;
                                _8101 = _7982 / _7957;
                                _8102 = _7975 / _7957;
                                _8103 = _7973 / _7957;
                                _8105 = (_7976 - _8101) / _8100;
                                _8107 = (_7974 - _8101) / _8100;
                                _8108 = min(_8102, _8103);
                                _8109 = max(_8102, _8103);
                                _8110 = min(_8105, _8107);
                                _8111 = max(_8105, _8107);
                                _8112 = max(_8108, _8110);
                                _8113 = min(_8109, _8111);
                                _8114 = _8112 * _7957;
                                _8116 = _8113 * _7957;
                                _8118 = _8114 - _7943;
                                _8119 = _8101 - _7947;
                                _8120 = _8119 + (_8112 * _8100);
                                _8121 = _8116 - _7943;
                                _8122 = _8119 + (_8113 * _8100);
                                _8123 = dot(float3(_8118, _8120, _7979), float3(_8118, _8120, _7979));
                                _8124 = dot(float3(_8121, _8122, _7979), float3(_8121, _8122, _7979));
                                _8126 = rsqrt(_8124 * _8123);
                                _8128 = dot(float3(_8118, _8120, _7979), float3(_8121, _8122, _7979)) * _8126;
                                _8135 = rsqrt(max(((((_8128 * 0.09300000220537186f) + 0.5f) * _8128) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8126;
                                _8148 = (_8108 > _8110);
                                _8150 = select(_8148, _7957, _7954);
                                _8156 = float((int)(((int)(uint)((int)(_8150 > 0.0f))) - ((int)(uint)((int)(_8150 < 0.0f)))));
                                _8160 = ((1.0f - (((float)((bool)_8148)) * 2.0f)) * _7973) * _8156;
                                _8162 = _8160 - _7943;
                                _8163 = (_8156 * _7974) - _7947;
                                _8164 = (_8109 < _8111);
                                _8166 = select(_8164, _7957, _7954);
                                _8172 = float((int)(((int)(uint)((int)(_8166 > 0.0f))) - ((int)(uint)((int)(_8166 < 0.0f)))));
                                _8173 = _8172 * _7973;
                                _8178 = _8173 - _7943;
                                _8179 = ((((((float)((bool)_8164)) * 2.0f) + -1.0f) * _7974) * _8172) - _7947;
                                _8182 = rsqrt(_8123 * dot(float3(_8162, _8163, _7979), float3(_8162, _8163, _7979)));
                                _8184 = dot(float3(_8162, _8163, _7979), float3(_8118, _8120, _7979)) * _8182;
                                _8191 = rsqrt(max(((((_8184 * 0.09300000220537186f) + 0.5f) * _8184) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8182;
                                _8204 = rsqrt(dot(float3(_8178, _8179, _7979), float3(_8178, _8179, _7979)) * _8124);
                                _8206 = dot(float3(_8121, _8122, _7979), float3(_8178, _8179, _7979)) * _8204;
                                _8213 = rsqrt(max(((((_8206 * 0.09300000220537186f) + 0.5f) * _8206) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8204;
                                _8234 = ((((_8135 * (((_8112 - _8113) * _8100) * _7979)) + _8090) + (_8191 * ((_8163 - _8120) * _7979))) + (_8213 * ((_8122 - _8179) * _7979)));
                                _8235 = ((((_8135 * ((_7957 * (_8113 - _8112)) * _7979)) + _8064) + (_8191 * ((_8114 - _8160) * _7979))) + (_8213 * ((_8173 - _8116) * _7979)));
                                _8236 = ((((_8135 * ((_8122 * _8118) - (_8121 * _8120))) + _8091) + (_8191 * ((_8162 * _8120) - (_8163 * _8118)))) + (_8213 * ((_8179 * _8121) - (_8178 * _8122))));
                              } else {
                                _8234 = _8090;
                                _8235 = _8064;
                                _8236 = _8091;
                              }
                            } else {
                              _8234 = _8090;
                              _8235 = _8064;
                              _8236 = _8091;
                            }
                            _8242 = sqrt(((_8235 * _8235) + (_8234 * _8234)) + (_8236 * _8236));
                            _8243 = _8242 * 0.15915493667125702f;
                            [branch]
                            if (!(_8243 == 0.0f)) {
                              _8252 = saturate((_8243 - _7928) / (1.0f - _7928)) * ((float)((bool)(uint)(_7951 <= 0.0f)));
                              [branch]
                              if (!(_8252 == 0.0f)) {
                                if (_8242 > 0.0f) {
                                  _8260 = (dot(float3(_7954, _7957, _7960), float3(_8234, _8235, _8236)) / _8242);
                                } else {
                                  _8260 = 0.0f;
                                }
                                _8261 = 1.0f - _201;
                                _8266 = min(_201, 0.800000011920929f);
                                _8275 = exp2(((((((_8266 * 3.322999954223633f) + -3.7669999599456787f) * _8266) + -0.3479999899864197f) * _8266) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _8282 = _7979 / (_7972 - ((_7960 * 2.0f) * dot(float3((-0.0f - mad(_7896, _384, mad(_7895, _386, (_7894 * _385)))), (-0.0f - mad(_7902, _384, mad(_7901, _386, (_7900 * _385)))), _7972), float3(_7954, _7957, _7960))));
                                _8285 = (_8282 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8275) * saturate((_201 + -0.5f) * 2.500000238418579f)) + _8275);
                                _8293 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7939), ((log2((_8285 * _8285) * f16tof32(((uint)((uint)(_7916) >> 16)))) * 0.5f) + 5.5f));
                                _8295 = (float)((bool)(uint)(_8282 > 0.0f));
                                _8296 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7939), 10.0f);
                                _8305 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8252 * _1204), _8252);
                                if (_7937 > 0.0f) {
                                  _8321 = ((max((_8261 * _8261), 0.03999999910593033f) + -0.03999999910593033f) * exp2(log2(1.0f - saturate(dot(float3(_190, _191, _192), float3(_385, _386, _384)))) * 5.0f)) + 0.03999999910593033f;
                                  _8322 = _8305 * _1504;
                                  _8342 = ((((((_7937 * _7930) * _8295) * _8293.x) * _8322) * _8321) + _1445);
                                  _8343 = ((((((_7931 * _7937) * _8295) * _8293.y) * _8322) * _8321) + _1446);
                                  _8344 = ((((((_7933 * _7937) * _8295) * _8293.z) * _8322) * _8321) + _1447);
                                } else {
                                  _8342 = _1445;
                                  _8343 = _1446;
                                  _8344 = _1447;
                                }
                                _8350 = ((_1504 * 5.4256415367126465f) * _8260) * _8305;
                                _8358 = (((_8296.x * _7930) * _8350) + _1442);
                                _8359 = (((_8296.y * _7931) * _8350) + _1443);
                                _8360 = (((_8296.z * _7933) * _8350) + _1444);
                                _8361 = _8342;
                                _8362 = _8343;
                                _8363 = _8344;
                              } else {
                                _8358 = _1442;
                                _8359 = _1443;
                                _8360 = _1444;
                                _8361 = _1445;
                                _8362 = _1446;
                                _8363 = _1447;
                              }
                            } else {
                              _8358 = _1442;
                              _8359 = _1443;
                              _8360 = _1444;
                              _8361 = _1445;
                              _8362 = _1446;
                              _8363 = _1447;
                            }
                          } else {
                            _8358 = _1442;
                            _8359 = _1443;
                            _8360 = _1444;
                            _8361 = _1445;
                            _8362 = _1446;
                            _8363 = _1447;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _8358 = _1442;
              _8359 = _1443;
              _8360 = _1444;
              _8361 = _1445;
              _8362 = _1446;
              _8363 = _1447;
            }
          } else {
            _8358 = _1442;
            _8359 = _1443;
            _8360 = _1444;
            _8361 = _1445;
            _8362 = _1446;
            _8363 = _1447;
          }
          _8364 = _1448 + 1u;
          if (!(_8364 == _global_2)) {
            _1442 = _8358;
            _1443 = _8359;
            _1444 = _8360;
            _1445 = _8361;
            _1446 = _8362;
            _1447 = _8363;
            _1448 = _8364;
            continue;
          }
          _8368 = _8358;
          _8369 = _8359;
          _8370 = _8360;
          _8371 = _8361;
          _8372 = _8362;
          _8373 = _8363;
          break;
        }
      } else {
        _8368 = _1325;
        _8369 = _1326;
        _8370 = _1327;
        _8371 = _1206;
        _8372 = _1208;
        _8373 = _1210;
      }
      _8375 = rsqrt(dot(float3(_134, _135, -1.0f), float3(_134, _135, -1.0f)));
      _8382 = 1.0f - _201;
      _8392 = 0.9599999785423279f - (exp2(log2(1.0f - saturate(saturate(dot(float3(_190, _191, _192), float3((-0.0f - (_134 * _8375)), (-0.0f - (_135 * _8375)), _8375))))) * 5.0f) * (max((_8382 * _8382), 0.03999999910593033f) + -0.03999999910593033f));
      _8532 = (_8392 * _8368);
      _8533 = (_8392 * _8369);
      _8534 = (_8392 * _8370);
      _8535 = _8371;
      _8536 = _8372;
      _8537 = _8373;
      _8538 = saturate(_142.x);
      _8539 = saturate(_142.y);
      _8540 = saturate(_142.z);
    } else {
      _8411 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _135, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _134)));
      _8414 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _135, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _134)));
      _8417 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _135, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _134)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _8521 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _8522 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _8523 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _8438 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8411, _8414, _8417), 0.0f);
        _8442 = _8438.x * 32.0f;
        _8443 = _8438.y * 32.0f;
        _8444 = _8438.z * 32.0f;
        _8446 = rsqrt(dot(float3(_8411, _8414, _8417), float3(_8411, _8414, _8417)));
        _8447 = _8446 * _8411;
        _8448 = _8446 * _8414;
        _8449 = _8446 * _8417;
        _8450 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _8451 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _8452 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _8453 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _8454 = dot(float3(_8447, _8448, _8449), float3(_8451, _8452, _8453));
        _8459 = (_8454 * _8454) - (dot(float3(_8451, _8452, _8453), float3(_8451, _8452, _8453)) - (_8450 * _8450));
        if ((_8454 > -0.0f) && (_8459 > 0.0f)) {
          _8464 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _8477 = 74.80000305175781f / ((dot(float3(_8447, _8448, _8449), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8450) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _8485 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8447, _8449), float2(_8464, cbDeferredShading.vSunDirWS.x)) * _8477) + 0.5f), ((dot(float3(_8447, _8448, _8449), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8464)), (cbDeferredShading.vSunDirWS.y * _8464))) * _8477) + 0.5f)), 0.0f);
          _8487 = _8459 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_8487 > 0.0f) {
            _8494 = saturate(_8487 * 5.0f);
            _8521 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8485.x) * _8494) + _8442);
            _8522 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8485.y) * _8494) + _8443);
            _8523 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8485.z) * _8494) + _8444);
          } else {
            _8521 = _8442;
            _8522 = _8443;
            _8523 = _8444;
          }
        } else {
          _8521 = _8442;
          _8522 = _8443;
          _8523 = _8444;
        }
      }
      _8527 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _8532 = 0.0f;
      _8533 = 0.0f;
      _8534 = 0.0f;
      _8535 = select(_8527, 0.0f, _8521);
      _8536 = select(_8527, 0.0f, _8522);
      _8537 = select(_8527, 0.0f, _8523);
      _8538 = 0.0f;
      _8539 = 0.0f;
      _8540 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_63, _64)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_8538 * _8532) + _8535)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_8539 * _8533) + _8536)), 7936.0f), 5.960464477539063e-08f), max(min((((_8540 * _8534) + _8537) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_63, _64)] = float3(0.0f, 0.0f, 0.0f);
  }
}