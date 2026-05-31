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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float3 RenoDX_DecodeDeferredNormal(float2 encoded_normal) {
  float nx = (saturate(encoded_normal.x) * 2.0f) + -1.0f;
  float ny = (saturate(encoded_normal.y) * 2.0f) + -1.0f;
  float nz = (1.0f - abs(nx)) - abs(ny);
  float t = saturate(-0.0f - nz);
  nx += (nx >= 0.0f) ? (-0.0f - t) : t;
  ny += (ny >= 0.0f) ? (-0.0f - t) : t;
  return float3(nx, ny, nz) * rsqrt(dot(float3(nx, ny, nz), float3(nx, ny, nz)));
}

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
  uint _53;
  int _59;
  uint _64;
  uint _65;
  uint _72;
  int _75;
  int _90;
  float _261;
  float _262;
  float _263;
  float _264;
  float _354;
  float _355;
  float _393;
  int _432;
  float _433;
  float _434;
  float _435;
  int _554;
  float _555;
  float _556;
  float _557;
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
  float _683;
  float _684;
  float _685;
  float _772;
  float _773;
  float _774;
  float _792;
  float _793;
  float _794;
  float _826;
  float _827;
  float _828;
  float _829;
  float _830;
  float _831;
  float _832;
  float _846;
  float _847;
  float _848;
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
  float _864;
  float _865;
  float _866;
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
  float _926;
  float _927;
  float _928;
  float _948;
  float _949;
  float _950;
  float _961;
  float _962;
  float _963;
  float _964;
  float _965;
  float _966;
  float _969;
  float _970;
  float _971;
  float _972;
  float _973;
  float _974;
  float _975;
  float _989;
  float _990;
  float _991;
  float _992;
  float _993;
  float _994;
  float _1023;
  float _1024;
  float _1025;
  float _1045;
  float _1046;
  float _1047;
  float _1058;
  float _1059;
  float _1060;
  float _1061;
  float _1062;
  float _1063;
  float _1082;
  float _1083;
  float _1084;
  float _1085;
  float _1086;
  float _1087;
  float _1106;
  float _1107;
  float _1108;
  int _1149;
  float _1150;
  float _1268;
  float _1273;
  float _1289;
  float _1346;
  float _1362;
  float _1415;
  float _1416;
  float _1417;
  float _1470;
  float _1471;
  float _1472;
  float _1582;
  float _1587;
  float _1588;
  float _1589;
  float _1590;
  float _1591;
  float _1592;
  int _1593;
  float _2214;
  float _2215;
  float _2216;
  float _2306;
  float _2315;
  float _2324;
  float _2332;
  float _2403;
  float _2412;
  float _2421;
  float _2429;
  float _2502;
  float _2511;
  float _2520;
  float _2528;
  float _2601;
  float _2610;
  float _2619;
  float _2627;
  float _2679;
  float _2684;
  float _2781;
  float _2802;
  float _2803;
  float _2804;
  int _2823;
  float _2840;
  float _2844;
  float _2883;
  float _2915;
  float _3025;
  float _3026;
  float _3038;
  float _3050;
  float _3121;
  float _3212;
  float _3213;
  float _3214;
  float _3243;
  float _3353;
  float _3354;
  float _3366;
  float _3378;
  float _3440;
  float _3441;
  float _3442;
  float _3473;
  float _3502;
  float _3503;
  float _3504;
  float _3520;
  float _3521;
  float _3522;
  float _3535;
  float _3536;
  float _3537;
  float _3706;
  float _3707;
  float _3708;
  float _3709;
  float _3710;
  float _3711;
  float _3803;
  float _3804;
  float _3805;
  float _3806;
  float _3807;
  float _3910;
  float _3919;
  float _3928;
  float _3936;
  float _4007;
  float _4016;
  float _4025;
  float _4033;
  float _4106;
  float _4115;
  float _4124;
  float _4132;
  float _4205;
  float _4214;
  float _4223;
  float _4231;
  float _4566;
  float _4567;
  int _4568;
  float _4597;
  float _4598;
  float _4599;
  float _4600;
  float _4601;
  float _4703;
  float _4712;
  float _4721;
  float _4729;
  float _4800;
  float _4809;
  float _4818;
  float _4826;
  float _4899;
  float _4908;
  float _4917;
  float _4925;
  float _4998;
  float _5007;
  float _5016;
  float _5024;
  float _5358;
  float _5359;
  bool _5360;
  float _5375;
  float _5376;
  float _5377;
  float _5435;
  float _5436;
  float _5461;
  float _5462;
  float _5557;
  float _5560;
  float _5561;
  float _5581;
  float _5582;
  float _5583;
  int _5601;
  float _5618;
  float _5622;
  float _5649;
  float _5650;
  float _5651;
  float _5682;
  float _5711;
  float _5712;
  float _5713;
  float _5729;
  float _5730;
  float _5731;
  float _5767;
  float _5815;
  float _5816;
  float _5817;
  float _5833;
  float _5893;
  float _5894;
  float _5895;
  float _6016;
  float _6017;
  float _6030;
  float _6042;
  float _6043;
  float _6063;
  float _6249;
  float _6828;
  float _6829;
  float _6830;
  float _6920;
  float _6929;
  float _6938;
  float _6946;
  float _7017;
  float _7026;
  float _7035;
  float _7043;
  float _7116;
  float _7125;
  float _7134;
  float _7142;
  float _7215;
  float _7224;
  float _7233;
  float _7241;
  float _7293;
  float _7298;
  float _7299;
  float _7396;
  float _7397;
  float _7418;
  float _7419;
  float _7420;
  int _7439;
  float _7456;
  float _7464;
  float _7490;
  float _7491;
  float _7492;
  float _7523;
  float _7552;
  float _7553;
  float _7554;
  float _7570;
  float _7571;
  float _7572;
  float _7608;
  float _7656;
  float _7657;
  float _7658;
  float _7674;
  float _7734;
  float _7735;
  float _7736;
  float _7857;
  float _7858;
  float _7871;
  float _7883;
  float _7884;
  float _7904;
  float _8100;
  float _8101;
  float _8125;
  float _8126;
  float _8151;
  float _8152;
  float _8177;
  float _8178;
  float _8321;
  float _8322;
  float _8323;
  float _8347;
  float _8438;
  float _8439;
  float _8440;
  float _8454;
  float _8455;
  float _8456;
  float _8457;
  float _8458;
  float _8459;
  float _8464;
  float _8465;
  float _8466;
  float _8467;
  float _8468;
  float _8469;
  float _8618;
  float _8619;
  float _8620;
  float _8629;
  float _8630;
  float _8631;
  float _8632;
  float _8633;
  float _8634;
  float _8635;
  float _8636;
  float _8637;
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
  float _198;
  float _199;
  float _206;
  float _207;
  float _208;
  float _214;
  float _218;
  float _224;
  float _225;
  float _226;
  float _227;
  int _233;
  uint _237;
  float _243;
  float4 _252;
  float _273;
  float _274;
  float _289;
  float _290;
  float _293;
  float _294;
  float _297;
  float _298;
  float4 _303;
  float _337;
  float _339;
  bool _340;
  float _342;
  float _344;
  bool _345;
  float4 _358;
  float _362;
  float _374;
  float _375;
  float _376;
  float _377;
  float _378;
  float _379;
  bool _382;
  bool _397;
  int _398;
  float2 _401;
  float _406;
  float _407;
  float _411;
  float _413;
  float _414;
  float _419;
  float _420;
  float _422;
  float _423;
  float _424;
  float _425;
  float _427;
  float _436;
  float _440;
  float _441;
  float _443;
  float _444;
  float _445;
  int _453;
  int _454;
  int _455;
  int _456;
  float _460;
  float _462;
  float _463;
  float _473;
  float _478;
  float _482;
  float _483;
  float _486;
  float _499;
  float _500;
  float _501;
  float _505;
  float _520;
  float _523;
  float _526;
  float _529;
  float _532;
  float _535;
  int _571;
  int _572;
  float _575;
  float _576;
  float _577;
  float _578;
  float _581;
  float _582;
  float _583;
  float _584;
  float _587;
  float _588;
  float _589;
  float _590;
  float _593;
  float _594;
  float _595;
  float _596;
  float _599;
  float _600;
  float _601;
  float _602;
  float _605;
  float _606;
  float _607;
  float _608;
  int _611;
  float _614;
  float _615;
  float _616;
  float _619;
  float _620;
  float _621;
  int _624;
  int _627;
  int _630;
  float _659;
  float _662;
  float _665;
  float _666;
  float4 _672;
  float4 _678;
  float _687;
  float _691;
  float _694;
  float _697;
  float _738;
  float _743;
  float _745;
  float _747;
  float _754;
  float _755;
  float4 _761;
  float4 _767;
  float _775;
  float4 _781;
  float4 _787;
  float _804;
  float _805;
  float _806;
  float _807;
  float _808;
  float _809;
  float _810;
  float _811;
  float _812;
  uint _860;
  bool _883;
  int _893;
  float _895;
  float _896;
  float _903;
  float _908;
  float _909;
  bool _910;
  float4 _915;
  float4 _921;
  float _932;
  float4 _937;
  float4 _943;
  float _981;
  int _1001;
  float _1002;
  float _1005;
  float _1006;
  bool _1007;
  float4 _1012;
  float4 _1018;
  float _1029;
  float4 _1034;
  float4 _1040;
  float _1068;
  float _1121;
  float4 _1124;
  float _1127;
  float _1128;
  float _1132;
  float _1136;
  float _1137;
  float _1138;
  float _1145;
  uint _1151;
  int _1154;
  int _1155;
  int _1159;
  int _1163;
  float _1175;
  float _1180;
  float _1181;
  float _1182;
  float _1183;
  float _1186;
  float _1187;
  float _1188;
  float _1189;
  float _1192;
  float _1193;
  float _1194;
  float _1195;
  int _1198;
  int _1201;
  int _1204;
  int _1207;
  float _1222;
  float _1226;
  float _1230;
  float _1255;
  float _1256;
  float _1257;
  float _1260;
  uint _1269;
  bool _1277;
  float _1292;
  float _1294;
  float _1295;
  float _1296;
  float _1297;
  float _1302;
  float _1303;
  float _1304;
  float _1305;
  float _1307;
  float _1316;
  float _1317;
  float _1322;
  float _1328;
  float _1336;
  float _1349;
  float _1352;
  float _1355;
  int _1365;
  int _1368;
  int _1369;
  int _1370;
  int _1376;
  int _1377;
  int _1378;
  int _1384;
  int _1385;
  int _1386;
  float _1392;
  float _1396;
  float _1400;
  float _1407;
  int _1420;
  int _1423;
  int _1424;
  int _1425;
  int _1431;
  int _1432;
  int _1433;
  int _1439;
  int _1440;
  int _1441;
  float _1447;
  float _1451;
  float _1455;
  float _1462;
  float _1495;
  float _1499;
  float _1503;
  float _1522;
  float _1526;
  float _1530;
  float _1543;
  float _1544;
  float _1545;
  uint _1583;
  int _1595;
  int _1599;
  int _1600;
  int _1601;
  int _1602;
  int _1614;
  int _1618;
  float _1630;
  int _1633;
  float _1650;
  float _1655;
  float _1656;
  float _1657;
  float _1658;
  float _1661;
  float _1662;
  float _1663;
  float _1664;
  float _1667;
  float _1668;
  float _1669;
  float _1670;
  int _1673;
  int _1676;
  int _1679;
  int _1682;
  int _1685;
  float _1687;
  float _1688;
  float _1690;
  float _1694;
  float _1707;
  float _1711;
  float _1715;
  float _1740;
  float _1741;
  float _1742;
  float _1745;
  float _1746;
  float _1753;
  float _1774;
  float _1775;
  float _1776;
  float _1777;
  float _1780;
  float _1781;
  float _1782;
  float _1783;
  float _1786;
  float _1787;
  float _1788;
  float _1789;
  float _1792;
  float _1793;
  float _1794;
  float _1797;
  int _1800;
  int _1803;
  int _1806;
  int _1809;
  int _1812;
  float _1815;
  float _1816;
  float _1817;
  float _1818;
  int _1821;
  int _1824;
  int _1827;
  int _1830;
  int _1833;
  int _1836;
  int _1839;
  int _1842;
  float _1844;
  float _1845;
  float _1847;
  float _1851;
  float _1854;
  float _1856;
  int _1859;
  float _1869;
  float _1870;
  float _1872;
  float _1873;
  float _1874;
  float _1875;
  float _1894;
  float _1898;
  float _1899;
  float _1900;
  float _1904;
  float _1908;
  float _1912;
  float _1913;
  float _1936;
  float _1937;
  float _1938;
  float _1941;
  float _1942;
  float _1949;
  float _1950;
  float _1951;
  float _1956;
  float _1958;
  float _1959;
  float _1962;
  float _1966;
  float _1975;
  float _1976;
  float _1977;
  int _1978;
  float _1983;
  float _1992;
  float _1993;
  float _1995;
  float4 _2000;
  float _2005;
  float _2007;
  float _2009;
  float _2011;
  float _2015;
  float _2017;
  float _2021;
  float _2023;
  int _2030;
  float _2035;
  float _2044;
  float _2045;
  float4 _2051;
  float _2056;
  float _2058;
  float _2062;
  float _2064;
  float _2068;
  float _2070;
  float _2074;
  float _2076;
  int _2083;
  float _2088;
  float _2097;
  float _2098;
  float4 _2104;
  float _2109;
  float _2111;
  float _2115;
  float _2117;
  float _2121;
  float _2123;
  float _2127;
  float _2129;
  int _2136;
  float _2141;
  float _2150;
  float _2151;
  float4 _2157;
  float _2162;
  float _2164;
  float _2168;
  float _2170;
  float _2174;
  float _2176;
  float _2180;
  float _2182;
  float _2183;
  float _2194;
  float _2200;
  float _2202;
  float _2204;
  float _2211;
  float _2219;
  float _2220;
  float _2229;
  float _2233;
  float _2242;
  float _2243;
  float _2244;
  float _2249;
  int _2250;
  float _2255;
  float _2264;
  float _2265;
  float _2267;
  float _2269;
  float _2270;
  float4 _2272;
  float _2276;
  float _2277;
  float _2280;
  float _2281;
  float _2286;
  float _2287;
  float _2290;
  float _2291;
  float _2293;
  float _2295;
  bool _2296;
  bool _2297;
  bool _2307;
  bool _2316;
  float _2333;
  float _2335;
  float _2337;
  float _2339;
  float _2343;
  float _2345;
  float _2349;
  float _2351;
  int _2358;
  float _2363;
  float _2372;
  float _2373;
  float _2376;
  float _2377;
  float4 _2379;
  float _2383;
  float _2384;
  float _2387;
  float _2388;
  float _2390;
  float _2392;
  bool _2393;
  bool _2394;
  bool _2404;
  bool _2413;
  float _2430;
  float _2432;
  float _2436;
  float _2438;
  float _2442;
  float _2444;
  float _2448;
  float _2450;
  int _2457;
  float _2462;
  float _2471;
  float _2472;
  float _2475;
  float _2476;
  float4 _2478;
  float _2482;
  float _2483;
  float _2486;
  float _2487;
  float _2489;
  float _2491;
  bool _2492;
  bool _2493;
  bool _2503;
  bool _2512;
  float _2529;
  float _2531;
  float _2535;
  float _2537;
  float _2541;
  float _2543;
  float _2547;
  float _2549;
  int _2556;
  float _2561;
  float _2570;
  float _2571;
  float _2574;
  float _2575;
  float4 _2577;
  float _2581;
  float _2582;
  float _2585;
  float _2586;
  float _2588;
  float _2590;
  bool _2591;
  bool _2592;
  bool _2602;
  bool _2611;
  float _2628;
  float _2630;
  float _2634;
  float _2636;
  float _2640;
  float _2642;
  float _2646;
  float _2648;
  float _2649;
  float _2660;
  float _2666;
  float _2668;
  float _2670;
  float _2690;
  float4 _2697;
  float _2711;
  float _2712;
  float _2713;
  float _2714;
  float _2716;
  float _2721;
  float _2724;
  float _2725;
  float _2727;
  float _2728;
  float _2733;
  float _2738;
  float _2740;
  float _2743;
  float _2744;
  float _2749;
  float _2751;
  float _2753;
  float _2755;
  float _2760;
  float _2766;
  float _2768;
  float3 _2794;
  float _2805;
  float4 _2826;
  int _2854;
  int _2859;
  int _2861;
  int _2862;
  int _2864;
  int _2865;
  int _2874;
  bool _2887;
  float _2890;
  float _2892;
  float _2893;
  float _2894;
  float _2895;
  float _2896;
  float _2897;
  float _2905;
  float _2910;
  float _2916;
  float _2920;
  float _2922;
  float _2923;
  float _2924;
  float _2927;
  bool _2934;
  float _2938;
  float _2940;
  float _2941;
  float _2949;
  float _2952;
  float _2953;
  float _2958;
  float _2967;
  float _2968;
  float _2971;
  float _2973;
  float _2974;
  float _2975;
  float _2977;
  float _2978;
  float _2979;
  float _2980;
  float _2985;
  float _2999;
  float _3004;
  float _3005;
  float _3007;
  float _3013;
  float _3016;
  float _3027;
  float _3028;
  float _3039;
  float _3054;
  float _3061;
  float _3064;
  float _3065;
  float _3077;
  float _3080;
  float _3081;
  float _3082;
  float _3083;
  float _3090;
  float _3091;
  float _3092;
  float _3104;
  float _3124;
  float _3125;
  float _3126;
  float _3127;
  float _3130;
  float _3131;
  float _3132;
  float _3133;
  float _3136;
  float _3137;
  float _3138;
  int _3141;
  int _3144;
  int _3147;
  int _3150;
  int _3153;
  int _3156;
  float _3159;
  float _3163;
  float _3165;
  int _3167;
  float2 _3187;
  float3 _3204;
  float _3217;
  float _3220;
  float _3221;
  float _3222;
  float _3223;
  float _3224;
  float _3225;
  float _3233;
  float _3238;
  float _3244;
  float _3248;
  float _3250;
  float _3251;
  float _3252;
  float _3255;
  bool _3262;
  float _3266;
  float _3268;
  float _3269;
  float _3277;
  float _3280;
  float _3281;
  float _3286;
  float _3295;
  float _3296;
  float _3299;
  float _3301;
  float _3302;
  float _3303;
  float _3305;
  float _3306;
  float _3307;
  float _3308;
  float _3313;
  float _3327;
  float _3332;
  float _3333;
  float _3335;
  float _3341;
  float _3344;
  float _3355;
  float _3356;
  float _3367;
  float _3382;
  float _3392;
  float _3401;
  float _3402;
  float _3414;
  float _3417;
  float _3430;
  bool _3443;
  float _3444;
  float _3445;
  float _3446;
  bool _3447;
  float _3449;
  float _3450;
  float _3454;
  float _3460;
  float _3474;
  float _3475;
  float _3478;
  float _3482;
  int _3483;
  float _3485;
  float _3487;
  float _3490;
  float _3494;
  float _3505;
  float _3506;
  float _3507;
  float _3509;
  float _3523;
  float _3524;
  float _3525;
  float _3541;
  float _3542;
  float _3543;
  float _3546;
  float _3567;
  float _3568;
  float _3569;
  float _3572;
  float _3573;
  float _3574;
  float _3577;
  float _3578;
  float _3579;
  float _3582;
  float _3583;
  float _3584;
  float _3587;
  float _3588;
  float _3589;
  int _3592;
  int _3595;
  int _3598;
  int _3601;
  int _3604;
  int _3607;
  int _3610;
  int _3613;
  int _3616;
  int _3619;
  int _3622;
  float _3625;
  float _3626;
  float _3627;
  float _3628;
  int _3631;
  int _3634;
  int _3637;
  int _3640;
  float _3642;
  float _3643;
  float _3645;
  float _3649;
  float _3652;
  float _3653;
  float _3655;
  float _3659;
  float _3661;
  float _3662;
  float _3664;
  int _3667;
  bool _3671;
  float _3679;
  float _3680;
  float _3682;
  float _3685;
  float _3686;
  float _3688;
  float _3689;
  float _3691;
  float _3692;
  float _3696;
  float _3702;
  float _3703;
  float _3704;
  float _3715;
  float _3716;
  float _3717;
  float _3718;
  float _3719;
  float _3720;
  float _3721;
  float _3722;
  float _3723;
  float _3726;
  float _3727;
  float _3728;
  float _3731;
  float _3738;
  float _3751;
  float _3755;
  float _3759;
  float _3760;
  float _3761;
  float _3764;
  float _3767;
  bool _3769;
  float _3775;
  float _3776;
  float _3777;
  float _3782;
  float _3783;
  float _3784;
  bool _3788;
  bool _3794;
  bool _3798;
  float _3808;
  float _3812;
  float _3821;
  float _3822;
  float _3829;
  float _3830;
  float _3833;
  float _3837;
  float _3846;
  float _3847;
  float _3848;
  float _3853;
  int _3854;
  float _3859;
  float _3868;
  float _3869;
  float _3871;
  float _3873;
  float _3874;
  float4 _3876;
  float _3880;
  float _3881;
  float _3884;
  float _3885;
  float _3890;
  float _3891;
  float _3894;
  float _3895;
  float _3897;
  float _3899;
  bool _3900;
  bool _3901;
  bool _3911;
  bool _3920;
  float _3937;
  float _3939;
  float _3941;
  float _3943;
  float _3947;
  float _3949;
  float _3953;
  float _3955;
  int _3962;
  float _3967;
  float _3976;
  float _3977;
  float _3980;
  float _3981;
  float4 _3983;
  float _3987;
  float _3988;
  float _3991;
  float _3992;
  float _3994;
  float _3996;
  bool _3997;
  bool _3998;
  bool _4008;
  bool _4017;
  float _4034;
  float _4036;
  float _4040;
  float _4042;
  float _4046;
  float _4048;
  float _4052;
  float _4054;
  int _4061;
  float _4066;
  float _4075;
  float _4076;
  float _4079;
  float _4080;
  float4 _4082;
  float _4086;
  float _4087;
  float _4090;
  float _4091;
  float _4093;
  float _4095;
  bool _4096;
  bool _4097;
  bool _4107;
  bool _4116;
  float _4133;
  float _4135;
  float _4139;
  float _4141;
  float _4145;
  float _4147;
  float _4151;
  float _4153;
  int _4160;
  float _4165;
  float _4174;
  float _4175;
  float _4178;
  float _4179;
  float4 _4181;
  float _4185;
  float _4186;
  float _4189;
  float _4190;
  float _4192;
  float _4194;
  bool _4195;
  bool _4196;
  bool _4206;
  bool _4215;
  float _4232;
  float _4234;
  float _4238;
  float _4240;
  float _4244;
  float _4246;
  float _4250;
  float _4252;
  float _4253;
  float _4264;
  float _4270;
  float _4272;
  float _4274;
  float _4283;
  float _4286;
  float _4287;
  float _4301;
  float _4302;
  float _4303;
  float _4307;
  float _4316;
  float _4317;
  float _4318;
  int _4319;
  float _4324;
  float _4333;
  float _4334;
  float _4336;
  float4 _4341;
  float _4346;
  float _4348;
  float _4350;
  float _4352;
  float _4356;
  float _4358;
  float _4362;
  float _4364;
  int _4371;
  float _4376;
  float _4385;
  float _4386;
  float4 _4392;
  float _4397;
  float _4399;
  float _4403;
  float _4405;
  float _4409;
  float _4411;
  float _4415;
  float _4417;
  int _4424;
  float _4429;
  float _4438;
  float _4439;
  float4 _4445;
  float _4450;
  float _4452;
  float _4456;
  float _4458;
  float _4462;
  float _4464;
  float _4468;
  float _4470;
  int _4477;
  float _4482;
  float _4491;
  float _4492;
  float4 _4498;
  float _4503;
  float _4505;
  float _4509;
  float _4511;
  float _4515;
  float _4517;
  float _4521;
  float _4523;
  float _4524;
  float _4535;
  float _4541;
  float _4543;
  float _4545;
  float _4553;
  float _4560;
  float _4562;
  float _4576;
  float _4577;
  float _4578;
  bool _4582;
  bool _4588;
  bool _4592;
  float _4602;
  float _4607;
  float _4616;
  float _4617;
  float _4622;
  float _4623;
  float _4626;
  float _4630;
  float _4639;
  float _4640;
  float _4641;
  float _4646;
  int _4647;
  float _4652;
  float _4661;
  float _4662;
  float _4664;
  float _4666;
  float _4667;
  float4 _4669;
  float _4673;
  float _4674;
  float _4677;
  float _4678;
  float _4683;
  float _4684;
  float _4687;
  float _4688;
  float _4690;
  float _4692;
  bool _4693;
  bool _4694;
  bool _4704;
  bool _4713;
  float _4730;
  float _4732;
  float _4734;
  float _4736;
  float _4740;
  float _4742;
  float _4746;
  float _4748;
  int _4755;
  float _4760;
  float _4769;
  float _4770;
  float _4773;
  float _4774;
  float4 _4776;
  float _4780;
  float _4781;
  float _4784;
  float _4785;
  float _4787;
  float _4789;
  bool _4790;
  bool _4791;
  bool _4801;
  bool _4810;
  float _4827;
  float _4829;
  float _4833;
  float _4835;
  float _4839;
  float _4841;
  float _4845;
  float _4847;
  int _4854;
  float _4859;
  float _4868;
  float _4869;
  float _4872;
  float _4873;
  float4 _4875;
  float _4879;
  float _4880;
  float _4883;
  float _4884;
  float _4886;
  float _4888;
  bool _4889;
  bool _4890;
  bool _4900;
  bool _4909;
  float _4926;
  float _4928;
  float _4932;
  float _4934;
  float _4938;
  float _4940;
  float _4944;
  float _4946;
  int _4953;
  float _4958;
  float _4967;
  float _4968;
  float _4971;
  float _4972;
  float4 _4974;
  float _4978;
  float _4979;
  float _4982;
  float _4983;
  float _4985;
  float _4987;
  bool _4988;
  bool _4989;
  bool _4999;
  bool _5008;
  float _5025;
  float _5027;
  float _5031;
  float _5033;
  float _5037;
  float _5039;
  float _5043;
  float _5045;
  float _5046;
  float _5057;
  float _5063;
  float _5065;
  float _5067;
  float _5076;
  float _5079;
  float _5080;
  float _5093;
  float _5094;
  float _5095;
  float _5099;
  float _5108;
  float _5109;
  float _5110;
  int _5111;
  float _5116;
  float _5125;
  float _5126;
  float _5128;
  float4 _5133;
  float _5138;
  float _5140;
  float _5142;
  float _5144;
  float _5148;
  float _5150;
  float _5154;
  float _5156;
  int _5163;
  float _5168;
  float _5177;
  float _5178;
  float4 _5184;
  float _5189;
  float _5191;
  float _5195;
  float _5197;
  float _5201;
  float _5203;
  float _5207;
  float _5209;
  int _5216;
  float _5221;
  float _5230;
  float _5231;
  float4 _5237;
  float _5242;
  float _5244;
  float _5248;
  float _5250;
  float _5254;
  float _5256;
  float _5260;
  float _5262;
  int _5269;
  float _5274;
  float _5283;
  float _5284;
  float4 _5290;
  float _5295;
  float _5297;
  float _5301;
  float _5303;
  float _5307;
  float _5309;
  float _5313;
  float _5315;
  float _5316;
  float _5327;
  float _5333;
  float _5335;
  float _5337;
  float _5345;
  float _5352;
  float _5354;
  float _5380;
  float _5382;
  float _5383;
  float _5384;
  float _5399;
  float _5402;
  float _5405;
  float _5407;
  float _5408;
  float _5409;
  float _5410;
  float _5418;
  float _5419;
  float _5420;
  bool _5422;
  float _5442;
  float4 _5467;
  float _5487;
  float _5488;
  float _5489;
  float _5490;
  float _5492;
  float _5497;
  float _5500;
  float _5501;
  float _5503;
  float _5504;
  float _5509;
  float _5514;
  float _5516;
  float _5519;
  float _5520;
  float _5525;
  float _5527;
  float _5529;
  float _5531;
  float _5536;
  float _5542;
  float _5544;
  float3 _5573;
  float4 _5604;
  float _5639;
  bool _5652;
  float _5653;
  float _5654;
  float _5655;
  bool _5656;
  float _5658;
  float _5659;
  float _5663;
  float _5669;
  float _5683;
  float _5684;
  float _5687;
  float _5691;
  int _5692;
  float _5694;
  float _5696;
  float _5699;
  float _5703;
  float _5714;
  float _5715;
  float _5716;
  float _5718;
  int _5738;
  int _5743;
  int _5745;
  int _5746;
  int _5748;
  int _5749;
  int _5758;
  bool _5771;
  float _5774;
  float _5776;
  float _5777;
  float _5778;
  float _5779;
  float _5780;
  float _5781;
  float _5782;
  float _5783;
  float _5784;
  float _5785;
  float _5786;
  float _5787;
  bool _5788;
  float _5789;
  float _5790;
  float _5793;
  float _5794;
  float _5796;
  float _5823;
  float _5828;
  float _5835;
  float _5836;
  float _5837;
  float _5839;
  float _5843;
  float _5844;
  float _5845;
  float _5846;
  float _5847;
  float _5848;
  float _5849;
  float _5855;
  float _5864;
  float _5868;
  float _5869;
  float _5870;
  float _5871;
  float _5875;
  float _5876;
  float _5877;
  float _5885;
  float _5897;
  float _5898;
  float _5899;
  float _5900;
  float _5901;
  float _5905;
  float _5907;
  float _5909;
  float _5913;
  float _5914;
  float _5915;
  float _5918;
  bool _5925;
  float _5929;
  float _5931;
  float _5932;
  float _5940;
  float _5943;
  float _5944;
  float _5949;
  float _5958;
  float _5959;
  float _5962;
  float _5964;
  float _5965;
  float _5966;
  float _5968;
  float _5969;
  float _5970;
  float _5971;
  float _5976;
  float _5990;
  float _5995;
  float _5996;
  float _5998;
  float _6004;
  float _6007;
  float _6018;
  float _6020;
  float _6039;
  float _6050;
  float _6067;
  float _6074;
  float _6077;
  float _6078;
  float _6079;
  float _6091;
  float _6094;
  float _6095;
  float _6096;
  float _6097;
  float _6104;
  float _6105;
  float _6106;
  float _6119;
  float _6140;
  float _6141;
  float _6142;
  float _6145;
  float _6146;
  float _6147;
  float _6150;
  int _6153;
  int _6156;
  int _6159;
  float _6168;
  float _6171;
  float _6174;
  float _6181;
  float _6186;
  float _6188;
  float _6190;
  float _6191;
  float _6192;
  float _6194;
  float _6195;
  float _6196;
  float _6199;
  float _6200;
  float _6201;
  float _6204;
  float _6211;
  int _6220;
  int _6225;
  int _6227;
  int _6228;
  int _6230;
  int _6231;
  int _6240;
  bool _6253;
  float _6255;
  float _6256;
  float _6257;
  float _6258;
  float _6261;
  float _6264;
  float _6268;
  float _6269;
  float _6270;
  float _6274;
  float _6281;
  float _6284;
  float _6285;
  float _6286;
  float _6298;
  float _6300;
  float _6301;
  float _6302;
  float _6303;
  float _6310;
  float _6311;
  float _6312;
  float _6327;
  float _6348;
  float _6349;
  float _6350;
  float _6353;
  float _6354;
  float _6355;
  float _6358;
  float _6359;
  float _6360;
  float _6363;
  float _6364;
  float _6365;
  float _6368;
  float _6369;
  float _6370;
  float _6373;
  float _6374;
  float _6375;
  int _6378;
  int _6381;
  int _6384;
  int _6387;
  float _6390;
  float _6391;
  float _6392;
  float _6393;
  int _6396;
  int _6399;
  int _6402;
  int _6405;
  int _6408;
  int _6411;
  int _6414;
  float _6417;
  float _6418;
  float _6419;
  float _6420;
  int _6423;
  int _6426;
  int _6429;
  float _6431;
  float _6432;
  float _6434;
  float _6438;
  float _6441;
  float _6442;
  float _6444;
  float _6448;
  int _6452;
  float _6468;
  float _6469;
  float _6471;
  float _6472;
  float _6473;
  float _6474;
  float _6475;
  float _6476;
  float _6477;
  float _6478;
  float _6479;
  float _6480;
  float _6481;
  float _6482;
  float _6483;
  float _6486;
  float _6487;
  float _6488;
  float _6491;
  float _6502;
  float _6506;
  float _6513;
  float _6514;
  float _6515;
  float _6527;
  float _6528;
  float _6529;
  float _6530;
  float _6533;
  float _6534;
  float _6537;
  float _6538;
  float _6545;
  float _6547;
  float _6553;
  bool _6555;
  float _6563;
  float _6564;
  float _6565;
  float _6570;
  float _6572;
  float _6573;
  float _6576;
  float _6580;
  float _6589;
  float _6590;
  float _6591;
  int _6592;
  float _6597;
  float _6606;
  float _6607;
  float _6609;
  float4 _6614;
  float _6619;
  float _6621;
  float _6623;
  float _6625;
  float _6629;
  float _6631;
  float _6635;
  float _6637;
  int _6644;
  float _6649;
  float _6658;
  float _6659;
  float4 _6665;
  float _6670;
  float _6672;
  float _6676;
  float _6678;
  float _6682;
  float _6684;
  float _6688;
  float _6690;
  int _6697;
  float _6702;
  float _6711;
  float _6712;
  float4 _6718;
  float _6723;
  float _6725;
  float _6729;
  float _6731;
  float _6735;
  float _6737;
  float _6741;
  float _6743;
  int _6750;
  float _6755;
  float _6764;
  float _6765;
  float4 _6771;
  float _6776;
  float _6778;
  float _6782;
  float _6784;
  float _6788;
  float _6790;
  float _6794;
  float _6796;
  float _6797;
  float _6808;
  float _6814;
  float _6816;
  float _6818;
  float _6825;
  float _6833;
  float _6834;
  float _6843;
  float _6847;
  float _6856;
  float _6857;
  float _6858;
  float _6863;
  int _6864;
  float _6869;
  float _6878;
  float _6879;
  float _6881;
  float _6883;
  float _6884;
  float4 _6886;
  float _6890;
  float _6891;
  float _6894;
  float _6895;
  float _6900;
  float _6901;
  float _6904;
  float _6905;
  float _6907;
  float _6909;
  bool _6910;
  bool _6911;
  bool _6921;
  bool _6930;
  float _6947;
  float _6949;
  float _6951;
  float _6953;
  float _6957;
  float _6959;
  float _6963;
  float _6965;
  int _6972;
  float _6977;
  float _6986;
  float _6987;
  float _6990;
  float _6991;
  float4 _6993;
  float _6997;
  float _6998;
  float _7001;
  float _7002;
  float _7004;
  float _7006;
  bool _7007;
  bool _7008;
  bool _7018;
  bool _7027;
  float _7044;
  float _7046;
  float _7050;
  float _7052;
  float _7056;
  float _7058;
  float _7062;
  float _7064;
  int _7071;
  float _7076;
  float _7085;
  float _7086;
  float _7089;
  float _7090;
  float4 _7092;
  float _7096;
  float _7097;
  float _7100;
  float _7101;
  float _7103;
  float _7105;
  bool _7106;
  bool _7107;
  bool _7117;
  bool _7126;
  float _7143;
  float _7145;
  float _7149;
  float _7151;
  float _7155;
  float _7157;
  float _7161;
  float _7163;
  int _7170;
  float _7175;
  float _7184;
  float _7185;
  float _7188;
  float _7189;
  float4 _7191;
  float _7195;
  float _7196;
  float _7199;
  float _7200;
  float _7202;
  float _7204;
  bool _7205;
  bool _7206;
  bool _7216;
  bool _7225;
  float _7242;
  float _7244;
  float _7248;
  float _7250;
  float _7254;
  float _7256;
  float _7260;
  float _7262;
  float _7263;
  float _7274;
  float _7280;
  float _7282;
  float _7284;
  float _7305;
  float4 _7312;
  float _7326;
  float _7327;
  float _7328;
  float _7329;
  float _7331;
  float _7336;
  float _7339;
  float _7340;
  float _7342;
  float _7343;
  float _7348;
  float _7353;
  float _7355;
  float _7358;
  float _7359;
  float _7364;
  float _7366;
  float _7368;
  float _7370;
  float _7375;
  float _7381;
  float _7383;
  float3 _7410;
  float _7421;
  float4 _7442;
  float _7480;
  bool _7493;
  float _7494;
  float _7495;
  float _7496;
  bool _7497;
  float _7499;
  float _7500;
  float _7504;
  float _7510;
  float _7524;
  float _7525;
  float _7528;
  float _7532;
  int _7533;
  float _7535;
  float _7537;
  float _7540;
  float _7544;
  float _7555;
  float _7556;
  float _7557;
  float _7559;
  int _7579;
  int _7584;
  int _7586;
  int _7587;
  int _7589;
  int _7590;
  int _7599;
  bool _7612;
  float _7615;
  float _7617;
  float _7618;
  float _7619;
  float _7620;
  float _7621;
  float _7622;
  float _7623;
  float _7624;
  float _7625;
  float _7626;
  float _7627;
  float _7628;
  bool _7629;
  float _7630;
  float _7631;
  float _7634;
  float _7635;
  float _7637;
  float _7664;
  float _7669;
  float _7676;
  float _7677;
  float _7678;
  float _7680;
  float _7684;
  float _7685;
  float _7686;
  float _7687;
  float _7688;
  float _7689;
  float _7690;
  float _7696;
  float _7705;
  float _7709;
  float _7710;
  float _7711;
  float _7712;
  float _7716;
  float _7717;
  float _7718;
  float _7726;
  float _7738;
  float _7739;
  float _7740;
  float _7741;
  float _7742;
  float _7746;
  float _7748;
  float _7750;
  float _7754;
  float _7755;
  float _7756;
  float _7759;
  bool _7766;
  float _7770;
  float _7772;
  float _7773;
  float _7781;
  float _7784;
  float _7785;
  float _7790;
  float _7799;
  float _7800;
  float _7803;
  float _7805;
  float _7806;
  float _7807;
  float _7809;
  float _7810;
  float _7811;
  float _7812;
  float _7817;
  float _7831;
  float _7836;
  float _7837;
  float _7839;
  float _7845;
  float _7848;
  float _7859;
  float _7861;
  float _7880;
  float _7891;
  float _7908;
  float _7915;
  float _7918;
  float _7919;
  float _7920;
  float _7932;
  float _7935;
  float _7936;
  float _7937;
  float _7938;
  float _7945;
  float _7946;
  float _7947;
  float _7960;
  float _7981;
  float _7982;
  float _7983;
  float _7984;
  float _7987;
  float _7988;
  float _7989;
  float _7990;
  float _7993;
  float _7994;
  float _7995;
  float _7996;
  float _7999;
  float _8000;
  int _8003;
  int _8006;
  int _8009;
  int _8012;
  float _8015;
  float _8017;
  float _8018;
  float _8020;
  float _8024;
  float _8026;
  float _8030;
  float _8034;
  float _8038;
  float _8041;
  float _8044;
  float _8047;
  float _8059;
  float _8060;
  float _8061;
  float _8062;
  float _8063;
  float _8064;
  float _8065;
  float _8066;
  float _8067;
  float _8068;
  float _8069;
  float _8071;
  float _8073;
  float _8075;
  float _8077;
  float _8078;
  float _8084;
  float _8086;
  float _8093;
  float _8108;
  float _8110;
  float _8117;
  float _8127;
  float _8133;
  float _8135;
  float _8142;
  float _8159;
  float _8161;
  float _8168;
  float _8187;
  float _8188;
  float _8189;
  float _8190;
  float _8192;
  float _8194;
  float _8195;
  float _8196;
  float _8197;
  float _8198;
  float _8199;
  float _8200;
  float _8201;
  float _8203;
  float _8205;
  float _8206;
  float _8207;
  float _8208;
  float _8209;
  float _8210;
  float _8211;
  float _8213;
  float _8215;
  float _8222;
  bool _8235;
  float _8237;
  float _8243;
  float _8247;
  float _8249;
  float _8250;
  bool _8251;
  float _8253;
  float _8259;
  float _8260;
  float _8265;
  float _8266;
  float _8269;
  float _8271;
  float _8278;
  float _8291;
  float _8293;
  float _8300;
  float _8329;
  float _8330;
  float _8339;
  float _8348;
  float _8349;
  float _8355;
  float _8360;
  float _8369;
  float _8376;
  float _8379;
  float4 _8387;
  float _8389;
  float4 _8390;
  float _8399;
  float _8417;
  float _8418;
  float _8446;
  uint _8460;
  float _8471;
  float _8478;
  float _8489;
  float _8508;
  float _8511;
  float _8514;
  float4 _8535;
  float _8539;
  float _8540;
  float _8541;
  float _8543;
  float _8544;
  float _8545;
  float _8546;
  float _8547;
  float _8548;
  float _8549;
  float _8550;
  float _8551;
  float _8556;
  float _8561;
  float _8574;
  float4 _8582;
  float _8584;
  float _8591;
  bool _8624;
  int __loop_jump_target = -1;
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
    while(true) {
      _92 = (_90 << 6) + _53;
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
      if (!(_113 == _86)) {
        _90 = _113;
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
      _198 = saturate(_149.x);
      _199 = saturate(_149.y) * 0.07999999821186066f;
      _206 = (_198 * (_159 - _199)) + _199;
      _207 = (_198 * (_160 - _199)) + _199;
      _208 = (_198 * (_161 - _199)) + _199;
      _214 = min(1.0f, max(saturate(_152.x), 0.019999999552965164f));
      _218 = (_198 * (1.0f - _199)) + _199;
      _224 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _118.x) - cbSharedPerViewData.vViewRemap.y);
      _225 = _224 * _135;
      _226 = _224 * _136;
      _227 = -0.0f - _224;
      _233 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _237 = srvReflectionsWeight.Load(int3(((uint)(_64) >> _233), ((uint)(_65) >> _233), 0));
      _243 = ((float)((uint)((uint)(_237.x & 254)))) * 0.003921568859368563f;
      if ((_237.x & 1) == 0) {
        if (CUSTOM_SSR_REFLECTION_FIX >= 1.5f) {
          int2 renodx_ssr_pixel = int2(((uint)(_64) >> _233), ((uint)(_65) >> _233));
          int renodx_gbuffer_step = (int)(1u << (uint)(_233));
          uint renodx_ssr_width;
          uint renodx_ssr_height;
          uint renodx_gbuffer_width;
          uint renodx_gbuffer_height;
          srvReflectionsWeight.GetDimensions(renodx_ssr_width, renodx_ssr_height);
          srvGlobalGBuffer0.GetDimensions(renodx_gbuffer_width, renodx_gbuffer_height);

          float renodx_center_reflection_weight = _243;
          float3 renodx_center_reflection_color = srvReflectionsColor.Load(int3(renodx_ssr_pixel, 0)).xyz;
          float3 renodx_center_normal = float3(_187, _188, _189);
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
                    float renodx_depth_sigma = max(0.05000000074505806f, abs(_224) * 0.029999999329447746f);
                    float renodx_depth_weight = saturate(1.0f - (abs(renodx_sample_view_depth - _224) / renodx_depth_sigma));
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
            _243 = renodx_center_reflection_weight;
            _252 = float4(lerp(renodx_center_reflection_color, renodx_filtered_reflection_color, 0.8500000238418579f), 1.0f);
          } else {
            _252 = float4(renodx_center_reflection_color, 1.0f);
          }
        } else if (CUSTOM_SSR_REFLECTION_FIX != 0.0f) {
          _252 = srvReflectionsColor.Load(int3(((uint)(_64) >> _233), ((uint)(_65) >> _233), 0));
        } else {
          _252 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _126), (cbSharedPerViewData.vViewportSize.y * _127)), 0.0f);
        }
        _261 = (1.0f - _243);
        _262 = (_252.x * _243);
        _263 = (_252.y * _243);
        _264 = (_252.z * _243);
      } else {
        _261 = 1.0f;
        _262 = 0.0f;
        _263 = 0.0f;
        _264 = 0.0f;
      }
      _273 = cbSharedPerViewData.vViewportSize.x * (_126 + 0.5f);
      _274 = cbSharedPerViewData.vViewportSize.y * (_127 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _289 = (floor((_273 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _290 = (floor((_274 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _293 = max(_289, cbDeferredShading.vScreenPixelSize.z);
        _294 = max(_290, cbDeferredShading.vScreenPixelSize.w);
        _297 = min((_289 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _298 = min((_290 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _303 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_293 + cbDeferredShading.vScreenPixelSize.z), (_294 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _303.x) - cbSharedPerViewData.vViewRemap.y)) - _224) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _303.y) - cbSharedPerViewData.vViewRemap.y)) - _224) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _303.z) - cbSharedPerViewData.vViewRemap.y)) - _224) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _303.w) - cbSharedPerViewData.vViewRemap.y)) - _224) > 0.029999999329447746f)) {
          _337 = abs(_118.x - _303.w);
          _339 = abs(_118.x - _303.z);
          _340 = (_339 < _337);
          _342 = select(_340, _339, _337);
          _344 = abs(_118.x - _303.x);
          _345 = (_344 < _342);
          if (abs(_118.x - _303.y) < select(_345, _344, _342)) {
            _354 = _297;
            _355 = _298;
          } else {
            _354 = select(_345, _293, select(_340, _297, _293));
            _355 = select(_345, _298, _294);
          }
        } else {
          _354 = _273;
          _355 = _274;
        }
      } else {
        _354 = _273;
        _355 = _274;
      }
      _358 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_354, _355), 0.0f);
      _362 = _358.x - _358.z;
      _374 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_358.y + _362)), 0.0f);
      _375 = -0.0f - _374;
      _376 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_358.x + _358.z)), 0.0f);
      _377 = -0.0f - _376;
      _378 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_362 - _358.y)), 0.0f);
      _379 = -0.0f - _378;
      _382 = (cbSharedPerViewData.nSSGIEnabled == 0);
      if (!_382) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _393 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_354, _355), 0.0f)).x);
        } else {
          _393 = 1.0f;
        }
      } else {
        _393 = 1.0f;
      }
      if (!_382) {
        _397 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
        _398 = (int)(uint)(_397);
        if (_397) {
          _401 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_354, _355), 0.0f);
          _406 = (_401.x * 2.0f) + -1.0f;
          _407 = (_401.y * 2.0f) + -1.0f;
          _411 = (1.0f - abs(_406)) - abs(_407);
          _413 = saturate(-0.0f - _411);
          _414 = -0.0f - _413;
          _419 = select((_406 >= 0.0f), _414, _413) + _406;
          _420 = select((_407 >= 0.0f), _414, _413) + _407;
          _422 = rsqrt(dot(float3(_419, _420, _411), float3(_419, _420, _411)));
          _423 = _419 * _422;
          _424 = _420 * _422;
          _425 = _422 * _411;
          _427 = rsqrt(dot(float3(_423, _424, _425), float3(_423, _424, _425)));
          _432 = _398;
          _433 = (_423 * _427);
          _434 = (_424 * _427);
          _435 = (_427 * _425);
        } else {
          _432 = _398;
          _433 = 0.0f;
          _434 = 0.0f;
          _435 = 0.0f;
        }
      } else {
        _432 = 0;
        _433 = 0.0f;
        _434 = 0.0f;
        _435 = 0.0f;
      }
      _436 = 1.0f - _198;
      _440 = -0.0f - _135;
      _441 = -0.0f - _136;
      _443 = rsqrt(dot(float3(_440, _441, 1.0f), float3(_440, _441, 1.0f)));
      _444 = _443 * _440;
      _445 = _443 * _441;
      _453 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _65) + _64))];
      _454 = _453 & 255;
      _455 = (uint)(_453) >> 8;
      _456 = _455 & 255;
      _460 = ((float)((uint)((uint)(((uint)(_453) >> 16) & 255)))) * 0.003921568859368563f;
      _462 = (float)((uint)((uint)((uint)(_453) >> 24)));
      _463 = _462 * 0.003921568859368563f;
      [branch]
      if (!((((int)(uint((saturate(_143.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _473 = _214 * 4.0f;
        _478 = dot(float3((-0.0f - _444), (-0.0f - _445), (-0.0f - _443)), float3(_187, _188, _189)) * 2.0f;
        _482 = _214 * _214;
        _483 = 1.0f - _482;
        _486 = (sqrt(_483) + _482) * _483;
        _499 = (_486 * (((-0.0f - _187) - _444) - (_478 * _187))) + _187;
        _500 = (_486 * (((-0.0f - _188) - _445) - (_478 * _188))) + _188;
        _501 = (_486 * (((-0.0f - _189) - _443) - (_478 * _189))) + _189;
        _505 = saturate(1.0f - ((_214 + -0.30000001192092896f) * 3.3333332538604736f));
        _520 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _501, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _500, (_499 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _523 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _501, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _500, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _499)));
        _526 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _501, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _500, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _499)));
        _529 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _189, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _188, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _187)));
        _532 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _189, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _188, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _187)));
        _535 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _189, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _188, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _187)));
        if (!(_global_0 == 0)) {
          _554 = 0;
          _555 = 0.0f;
          _556 = 0.0f;
          _557 = 0.0f;
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
          while(true) {
            _846 = _555;
            _847 = _556;
            _848 = _557;
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
            _571 = _global_5[min((uint)(_554), 63u)];
            _572 = _global_6[min((uint)(_554), 63u)];
            _575 = asfloat(srvLightInfoProperties.Load4(_572)).x;
            _576 = asfloat(srvLightInfoProperties.Load4(_572)).y;
            _577 = asfloat(srvLightInfoProperties.Load4(_572)).z;
            _578 = asfloat(srvLightInfoProperties.Load4(_572)).w;
            _581 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 16u)))).x;
            _582 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 16u)))).y;
            _583 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 16u)))).z;
            _584 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 16u)))).w;
            _587 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 32u)))).x;
            _588 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 32u)))).y;
            _589 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 32u)))).z;
            _590 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 32u)))).w;
            _593 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 48u)))).x;
            _594 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 48u)))).y;
            _595 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 48u)))).z;
            _596 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 48u)))).w;
            _599 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 64u)))).x;
            _600 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 64u)))).y;
            _601 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 64u)))).z;
            _602 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 64u)))).w;
            _605 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 80u)))).x;
            _606 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 80u)))).y;
            _607 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 80u)))).z;
            _608 = asfloat(srvLightInfoProperties.Load4(((int)(_572 + 80u)))).w;
            _611 = asint(srvLightInfoProperties.Load(((int)(_572 + 96u))));
            _614 = asfloat(srvLightInfoProperties.Load3(((int)(_572 + 100u)))).x;
            _615 = asfloat(srvLightInfoProperties.Load3(((int)(_572 + 100u)))).y;
            _616 = asfloat(srvLightInfoProperties.Load3(((int)(_572 + 100u)))).z;
            _619 = asfloat(srvLightInfoProperties.Load3(((int)(_572 + 112u)))).x;
            _620 = asfloat(srvLightInfoProperties.Load3(((int)(_572 + 112u)))).y;
            _621 = asfloat(srvLightInfoProperties.Load3(((int)(_572 + 112u)))).z;
            _624 = asint(srvLightInfoProperties.Load(((int)(_572 + 124u))));
            _627 = asint(srvLightInfoProperties.Load(((int)(_572 + 128u))));
            _630 = _611 & 65535;
            _659 = ((saturate(1.0f - abs(mad(_577, _227, mad(_576, _226, (_575 * _225))) + _578)) * f16tof32(((uint)((uint)(_611) >> 16)))) * saturate(1.0f - abs(mad(_583, _227, mad(_582, _226, (_581 * _225))) + _584))) * saturate(1.0f - abs(mad(_589, _227, mad(_588, _226, (_587 * _225))) + _590));
            [branch]
            if (_659 > 0.0f) {
              _662 = _659 * _659;
              [branch]
              if (_505 < 1.0f) {
                _665 = (float)((uint)_630);
                _666 = -0.0f - _520;
                [branch]
                if (!(_665 >= 341.0f)) {
                  _678 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_666, _523, _526, _665), _473);
                  _683 = _678.x;
                  _684 = _678.y;
                  _685 = _678.z;
                } else {
                  _672 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_666, _523, _526, (_665 + -341.0f)), _473);
                  _683 = _672.x;
                  _684 = _672.y;
                  _685 = _672.z;
                }
              } else {
                _683 = 0.0f;
                _684 = 0.0f;
                _685 = 0.0f;
              }
              _687 = (float)((uint)_630);
              [branch]
              if (_505 > 0.0f) {
                _691 = mad(_595, _501, mad(_594, _500, (_593 * _499)));
                _694 = mad(_601, _501, mad(_600, _500, (_599 * _499)));
                _697 = mad(_607, _501, mad(_606, _500, (_605 * _499)));
                _738 = min(((((float((int)(((int)(uint)((int)(_691 > 0.0f))) - ((int)(uint)((int)(_691 < 0.0f))))) * _614) - _596) - mad(_595, _227, mad(_594, _226, (_593 * _225)))) / _691), min(((((float((int)(((int)(uint)((int)(_694 > 0.0f))) - ((int)(uint)((int)(_694 < 0.0f))))) * _615) - _602) - mad(_601, _227, mad(_600, _226, (_599 * _225)))) / _694), ((((float((int)(((int)(uint)((int)(_697 > 0.0f))) - ((int)(uint)((int)(_697 < 0.0f))))) * _616) - _608) - mad(_607, _227, mad(_606, _226, (_605 * _225)))) / _697)));
                _743 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _227, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _226, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _225))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _619) + (_738 * _520);
                _745 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _227, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _226, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _225))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _620) + (_738 * _523);
                _747 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _227, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _226, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _225))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _621) + (_738 * _526);
                _754 = (max(log2((_738 * _738) / dot(float3(_743, _745, _747), float3(_743, _745, _747))), -1.0f) * 0.3333333432674408f) + _473;
                _755 = -0.0f - _743;
                [branch]
                if (!(_687 >= 341.0f)) {
                  _767 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_755, _745, _747, _687), _754);
                  _772 = _767.x;
                  _773 = _767.y;
                  _774 = _767.z;
                } else {
                  _761 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_755, _745, _747, (_687 + -341.0f)), _754);
                  _772 = _761.x;
                  _773 = _761.y;
                  _774 = _761.z;
                }
              } else {
                _772 = 0.0f;
                _773 = 0.0f;
                _774 = 0.0f;
              }
              _775 = -0.0f - _529;
              [branch]
              if (!(_687 >= 341.0f)) {
                _787 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_775, _532, _535, _687), 0.0f);
                _792 = _787.x;
                _793 = _787.y;
                _794 = _787.z;
              } else {
                _781 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_775, _532, _535, (_687 + -341.0f)), 0.0f);
                _792 = _781.x;
                _793 = _781.y;
                _794 = _781.z;
              }
              _804 = _662 * f16tof32(((uint)((uint)(_624) >> 16)));
              _805 = _804 * _792;
              _806 = _662 * f16tof32(_624);
              _807 = _806 * _793;
              _808 = _662 * f16tof32(((uint)((uint)(_627) >> 16)));
              _809 = _808 * _794;
              _810 = _804 * (lerp(_683, _772, _505));
              _811 = _806 * (lerp(_684, _773, _505));
              _812 = _808 * (lerp(_685, _774, _505));
              [branch]
              if (!((_571 & ((int)(1 << (_453 & 31)))) == 0)) {
                _826 = (_805 + _555);
                _827 = (_807 + _556);
                _828 = (_809 + _557);
                _829 = (_810 + _558);
                _830 = (_811 + _559);
                _831 = (_812 + _560);
                _832 = (_662 + _561);
              } else {
                _826 = _555;
                _827 = _556;
                _828 = _557;
                _829 = _558;
                _830 = _559;
                _831 = _560;
                _832 = _561;
              }
              [branch]
              if (!((_571 & ((int)(1 << (_455 & 31)))) == 0)) {
                _846 = _826;
                _847 = _827;
                _848 = _828;
                _849 = _829;
                _850 = _830;
                _851 = _831;
                _852 = _832;
                _853 = (_805 + _562);
                _854 = (_807 + _563);
                _855 = (_809 + _564);
                _856 = (_810 + _565);
                _857 = (_811 + _566);
                _858 = (_812 + _567);
                _859 = (_662 + _568);
              } else {
                _846 = _826;
                _847 = _827;
                _848 = _828;
                _849 = _829;
                _850 = _830;
                _851 = _831;
                _852 = _832;
                _853 = _562;
                _854 = _563;
                _855 = _564;
                _856 = _565;
                _857 = _566;
                _858 = _567;
                _859 = _568;
              }
            } else {
              _846 = _555;
              _847 = _556;
              _848 = _557;
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
            }
            _860 = _554 + 1u;
            if (!(_860 == _global_0)) {
              _554 = _860;
              _555 = _846;
              _556 = _847;
              _557 = _848;
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
              continue;
            }
            _864 = _846;
            _865 = _847;
            _866 = _848;
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
            break;
          }
        } else {
          _864 = 0.0f;
          _865 = 0.0f;
          _866 = 0.0f;
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
        }
        _883 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_453 & 31)))) != 0);
        if ((_460 > 0.0f) || ((_463 > 0.0f) || _883)) {
          _893 = srvFallbackInfo[((_454 << 2) | 3)].x;
          _895 = select(_883, 9.999999747378752e-05f, (_462 * 3.921568847431445e-09f));
          _896 = _870 * 0.20000000298023224f;
          _903 = saturate((_895 - _896) / (((_870 * 0.4000000059604645f) + 9.99999993922529e-09f) - _896)) * _895;
          [branch]
          if (_903 > 0.0f) {
            [branch]
            if ((int)_893 > (int)-1) {
              _908 = float((int)(_893));
              _909 = -0.0f - _520;
              _910 = !(_908 >= 341.0f);
              [branch]
              if (_910) {
                _921 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_909, _523, _526, _908), _473);
                _926 = _921.x;
                _927 = _921.y;
                _928 = _921.z;
              } else {
                _915 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_909, _523, _526, (_908 + -341.0f)), _473);
                _926 = _915.x;
                _927 = _915.y;
                _928 = _915.z;
              }
              _932 = -0.0f - _529;
              [branch]
              if (_910) {
                _943 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_932, _532, _535, _908), 0.0f);
                _948 = _943.x;
                _949 = _943.y;
                _950 = _943.z;
              } else {
                _937 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_932, _532, _535, (_908 + -341.0f)), 0.0f);
                _948 = _937.x;
                _949 = _937.y;
                _950 = _937.z;
              }
              _961 = ((_926 * _903) + _867);
              _962 = ((_927 * _903) + _868);
              _963 = ((_928 * _903) + _869);
              _964 = ((_948 * _903) + _864);
              _965 = ((_949 * _903) + _865);
              _966 = ((_950 * _903) + _866);
            } else {
              _961 = _867;
              _962 = _868;
              _963 = _869;
              _964 = _864;
              _965 = _865;
              _966 = _866;
            }
            _969 = (_903 + _870);
            _970 = _961;
            _971 = _962;
            _972 = _963;
            _973 = _964;
            _974 = _965;
            _975 = _966;
          } else {
            _969 = _870;
            _970 = _867;
            _971 = _868;
            _972 = _869;
            _973 = _864;
            _974 = _865;
            _975 = _866;
          }
          if (_969 > 0.0f) {
            _981 = (cbSharedPerViewData.vHDRScale.x * _460) / _969;
            _989 = (_981 * _973);
            _990 = (_981 * _974);
            _991 = (_981 * _975);
            _992 = (_981 * _970);
            _993 = (_981 * _971);
            _994 = (_981 * _972);
          } else {
            _989 = 0.0f;
            _990 = 0.0f;
            _991 = 0.0f;
            _992 = 0.0f;
            _993 = 0.0f;
            _994 = 0.0f;
          }
        } else {
          _989 = 0.0f;
          _990 = 0.0f;
          _991 = 0.0f;
          _992 = 0.0f;
          _993 = 0.0f;
          _994 = 0.0f;
        }
        [branch]
        if (!(_463 == 0.0f)) {
          _1001 = srvFallbackInfo[((_456 << 2) | 3)].x;
          _1002 = _462 * 3.921568847431445e-09f;
          [branch]
          if ((int)_1001 > (int)-1) {
            _1005 = float((int)(_1001));
            _1006 = -0.0f - _520;
            _1007 = !(_1005 >= 341.0f);
            [branch]
            if (_1007) {
              _1018 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1006, _523, _526, _1005), _473);
              _1023 = _1018.x;
              _1024 = _1018.y;
              _1025 = _1018.z;
            } else {
              _1012 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1006, _523, _526, (_1005 + -341.0f)), _473);
              _1023 = _1012.x;
              _1024 = _1012.y;
              _1025 = _1012.z;
            }
            _1029 = -0.0f - _529;
            [branch]
            if (_1007) {
              _1040 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1029, _532, _535, _1005), 0.0f);
              _1045 = _1040.x;
              _1046 = _1040.y;
              _1047 = _1040.z;
            } else {
              _1034 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1029, _532, _535, (_1005 + -341.0f)), 0.0f);
              _1045 = _1034.x;
              _1046 = _1034.y;
              _1047 = _1034.z;
            }
            _1058 = ((_1023 * _1002) + _874);
            _1059 = ((_1024 * _1002) + _875);
            _1060 = ((_1025 * _1002) + _876);
            _1061 = ((_1045 * _1002) + _871);
            _1062 = ((_1046 * _1002) + _872);
            _1063 = ((_1047 * _1002) + _873);
          } else {
            _1058 = _874;
            _1059 = _875;
            _1060 = _876;
            _1061 = _871;
            _1062 = _872;
            _1063 = _873;
          }
          _1068 = (cbSharedPerViewData.vHDRScale.x * _463) / (_877 + _1002);
          _1082 = ((_1068 * _1061) + _989);
          _1083 = ((_1068 * _1062) + _990);
          _1084 = ((_1068 * _1063) + _991);
          _1085 = ((_1068 * _1058) + _992);
          _1086 = ((_1068 * _1059) + _993);
          _1087 = ((_1068 * _1060) + _994);
        } else {
          _1082 = _989;
          _1083 = _990;
          _1084 = _991;
          _1085 = _992;
          _1086 = _993;
          _1087 = _994;
        }
      } else {
        _1082 = 0.0f;
        _1083 = 0.0f;
        _1084 = 0.0f;
        _1085 = 0.0f;
        _1086 = 0.0f;
        _1087 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1106 = (min((_375 / max(9.999999747378752e-05f, _1082)), 1.0f) * _1085);
        _1107 = (min((_377 / max(9.999999747378752e-05f, _1083)), 1.0f) * _1086);
        _1108 = (min((_379 / max(9.999999747378752e-05f, _1084)), 1.0f) * _1087);
      } else {
        _1106 = _1085;
        _1107 = _1086;
        _1108 = _1087;
      }
      _1121 = saturate(dot(float3(_444, _445, _443), float3(_187, _188, _189)));
      _1124 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1121, _214), 0.0f);
      _1127 = _1124.x + _1124.y;
      _1128 = 1.0f - _1127;
      _1132 = max(9.999999747378752e-06f, _1127);
      _1136 = ((_1128 * _206) / _1132) + 1.0f;
      _1137 = ((_1128 * _207) / _1132) + 1.0f;
      _1138 = ((_1128 * _208) / _1132) + 1.0f;
      _1145 = min((_165 * _165), _393);
      if (!(_global_1 == 0)) {
        _1149 = 0;
        _1150 = _1145;
        while(true) {
          _1268 = _1150;
          _1151 = _1149 + (uint)(_global_0);
          _1154 = _global_5[min((uint)(_1151), 63u)];
          _1155 = _global_6[min((uint)(_1151), 63u)];
          _1159 = (int)((int)(_1154 << (((int)(31u - _453)) & 31))) >> 31;
          _1163 = (int)((int)(_1154 << ((31 - _455) & 31))) >> 31;
          _1175 = saturate((asfloat((_1159 & asint(_460))) + asfloat((_1163 & asint(_463)))) + asfloat(((_1163 & 1065353216) & _1159)));
          [branch]
          if (!(_1175 == 0.0f)) {
            _1180 = asfloat(srvLightInfoProperties.Load4(_1155)).x;
            _1181 = asfloat(srvLightInfoProperties.Load4(_1155)).y;
            _1182 = asfloat(srvLightInfoProperties.Load4(_1155)).z;
            _1183 = asfloat(srvLightInfoProperties.Load4(_1155)).w;
            _1186 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 16u)))).x;
            _1187 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 16u)))).y;
            _1188 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 16u)))).z;
            _1189 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 16u)))).w;
            _1192 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 32u)))).x;
            _1193 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 32u)))).y;
            _1194 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 32u)))).z;
            _1195 = asfloat(srvLightInfoProperties.Load4(((int)(_1155 + 32u)))).w;
            _1198 = asint(srvLightInfoProperties.Load(((int)(_1155 + 48u))));
            _1201 = asint(srvLightInfoProperties.Load(((int)(_1155 + 52u))));
            _1204 = asint(srvLightInfoProperties.Load(((int)(_1155 + 56u))));
            _1207 = asint(srvLightInfoProperties.Load(((int)(_1155 + 60u))));
            _1222 = mad(_1182, _227, mad(_1181, _226, (_1180 * _225))) + _1183;
            _1226 = mad(_1188, _227, mad(_1187, _226, (_1186 * _225))) + _1189;
            _1230 = mad(_1194, _227, mad(_1193, _226, (_1192 * _225))) + _1195;
            _1255 = saturate(1.0f - ((_1222 + 1.0f) * f16tof32(_1201))) + saturate(1.0f - ((1.0f - _1222) * f16tof32(((uint)((uint)(_1201) >> 16)))));
            _1256 = saturate(1.0f - ((_1226 + 1.0f) * f16tof32(_1204))) + saturate(1.0f - ((1.0f - _1226) * f16tof32(((uint)((uint)(_1204) >> 16)))));
            _1257 = saturate(1.0f - ((_1230 + 1.0f) * f16tof32(_1207))) + saturate(1.0f - ((1.0f - _1230) * f16tof32(((uint)((uint)(_1207) >> 16)))));
            _1260 = saturate(1.0f - dot(float3(_1255, _1256, _1257), float3(_1255, _1256, _1257)));
            _1268 = (saturate(1.0f - ((_1260 * _1260) * (f16tof32(((uint)((uint)(_1198) >> 16))) * _1175))) * _1150);
          } else {
            _1268 = _1150;
          }
          _1269 = _1149 + 1u;
          if (!(_1269 == _global_1)) {
            _1149 = _1269;
            _1150 = _1268;
            continue;
          }
          _1273 = _1268;
          break;
        }
      } else {
        _1273 = _1145;
      }
      _1277 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
      if (_1277) {
        _1289 = saturate((_1273 + -1.0f) + exp2((_214 * _214) * log2(max((_1273 + _1121), 0.0f))));
      } else {
        _1289 = _1273;
      }
      if (!(_432 == 0)) {
        _1292 = rsqrt(dot(float3(_433, _434, _435), float3(_433, _434, _435)));
        _1294 = rsqrt(dot(float3(_187, _188, _189), float3(_187, _188, _189)));
        _1295 = _1294 * _187;
        _1296 = _1294 * _188;
        _1297 = _1294 * _189;
        if (_1277) {
          _1302 = max(_214, 0.10000000149011612f);
          _1303 = -0.0f - _444;
          _1304 = -0.0f - _445;
          _1305 = -0.0f - _443;
          _1307 = dot(float3(_1303, _1304, _1305), float3(_1295, _1296, _1297)) * 2.0f;
          _1316 = min(max(dot(float3((_1292 * _433), (_1292 * _434), (_1292 * _435)), float3((_1303 - (_1307 * _1295)), (_1304 - (_1307 * _1296)), (_1305 - (_1307 * _1297)))), -1.0f), 1.0f);
          _1317 = abs(_1316);
          _1322 = (1.5707963705062866f - (_1317 * 0.1565829962491989f)) * sqrt(1.0f - _1317);
          _1328 = abs((_1302 - _1273) * 3.1415927410125732f);
          _1336 = saturate(1.0f - saturate((select((_1316 >= 0.0f), _1322, (3.1415927410125732f - _1322)) - _1328) / (((_1302 + _1273) * 3.1415927410125732f) - _1328)));
          _1346 = (((_1336 * _1336) * saturate((_1273 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1336 * 2.0f)));
        } else {
          _1346 = _1273;
        }
      } else {
        _1346 = _1289;
      }
      _1349 = ((_1136 * ((cbSharedPerViewData.vHDRScale.x * _262) + (_1106 * _261))) * ((_1124.x * _206) + _1124.y)) * _1346;
      _1352 = ((((_1124.x * _207) + _1124.y) * ((cbSharedPerViewData.vHDRScale.x * _263) + (_1107 * _261))) * _1137) * _1346;
      _1355 = ((((_1124.x * _208) + _1124.y) * ((cbSharedPerViewData.vHDRScale.x * _264) + (_1108 * _261))) * _1138) * _1346;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1362 = _1273;
      } else {
        _1362 = 1.0f;
      }
      if (_460 > 0.0f) {
        _1365 = _454 * 3;
        _1368 = srvRoomInfo[_1365].x;
        _1369 = srvRoomInfo[_1365].y;
        _1370 = srvRoomInfo[_1365].z;
        _1376 = srvRoomInfo[(_1365 + 1)].x;
        _1377 = srvRoomInfo[(_1365 + 1)].y;
        _1378 = srvRoomInfo[(_1365 + 1)].z;
        _1384 = srvRoomInfo[(_1365 + 2)].x;
        _1385 = srvRoomInfo[(_1365 + 2)].y;
        _1386 = srvRoomInfo[(_1365 + 2)].z;
        _1392 = saturate(dot(float3(_187, _188, _189), float3(asfloat(_1368), asfloat(_1369), asfloat(_1370))) + 0.5f);
        _1396 = (_1392 * _1392) * (3.0f - (_1392 * 2.0f));
        _1400 = 1.0f - _1396;
        _1407 = _1362 * _460;
        _1415 = ((_1407 * ((_1400 * asfloat(_1384)) + (_1396 * asfloat(_1376)))) - _374);
        _1416 = ((_1407 * ((_1400 * asfloat(_1385)) + (_1396 * asfloat(_1377)))) - _376);
        _1417 = ((_1407 * ((_1400 * asfloat(_1386)) + (_1396 * asfloat(_1378)))) - _378);
      } else {
        _1415 = _375;
        _1416 = _377;
        _1417 = _379;
      }
      if (_463 > 0.0f) {
        _1420 = _456 * 3;
        _1423 = srvRoomInfo[_1420].x;
        _1424 = srvRoomInfo[_1420].y;
        _1425 = srvRoomInfo[_1420].z;
        _1431 = srvRoomInfo[(_1420 + 1)].x;
        _1432 = srvRoomInfo[(_1420 + 1)].y;
        _1433 = srvRoomInfo[(_1420 + 1)].z;
        _1439 = srvRoomInfo[(_1420 + 2)].x;
        _1440 = srvRoomInfo[(_1420 + 2)].y;
        _1441 = srvRoomInfo[(_1420 + 2)].z;
        _1447 = saturate(dot(float3(_187, _188, _189), float3(asfloat(_1423), asfloat(_1424), asfloat(_1425))) + 0.5f);
        _1451 = (_1447 * _1447) * (3.0f - (_1447 * 2.0f));
        _1455 = 1.0f - _1451;
        _1462 = _1362 * _463;
        _1470 = ((_1462 * ((_1455 * asfloat(_1439)) + (_1451 * asfloat(_1431)))) + _1415);
        _1471 = ((_1462 * ((_1455 * asfloat(_1440)) + (_1451 * asfloat(_1432)))) + _1416);
        _1472 = ((_1462 * ((_1455 * asfloat(_1441)) + (_1451 * asfloat(_1433)))) + _1417);
      } else {
        _1470 = _1415;
        _1471 = _1416;
        _1472 = _1417;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1495 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _227, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _226, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _225))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1499 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _227, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _226, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _225))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1503 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _227, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _226, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _225))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1522 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1503, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1499, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1495))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1526 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1503, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1499, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1495))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1530 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1503, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1499, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1495))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1543 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1544 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1545 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1582 = min(min(saturate((_1522 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1543), 9.999999747378752e-06f)), saturate((1.0f - _1522) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1543), 9.999999747378752e-06f))), min(min(saturate((_1526 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1544), 9.999999747378752e-06f)), saturate((1.0f - _1526) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1544), 9.999999747378752e-06f))), min(saturate((_1530 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1545), 9.999999747378752e-06f)), saturate((1.0f - _1530) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1545), 9.999999747378752e-06f)))));
      } else {
        _1582 = 0.0f;
      }
      _1583 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1583 < (uint)_global_2) {
        _1587 = _1470;
        _1588 = _1471;
        _1589 = _1472;
        _1590 = _1349;
        _1591 = _1352;
        _1592 = _1355;
        _1593 = _1583;
        while(true) {
          _8454 = _1587;
          _8455 = _1588;
          _8456 = _1589;
          _8457 = _1590;
          _8458 = _1591;
          _8459 = _1592;
          _1595 = _global_3[min((uint)(_1593), 63u)];
          _1599 = _global_4[min((uint)(_1593), 63u)];
          _1600 = _global_5[min((uint)(_1593), 63u)];
          _1601 = _global_6[min((uint)(_1593), 63u)];
          _1602 = _1595 & 4095;
          [branch]
          if (((((int)(uint(saturate(_152.w) * 255.0f)) & 64) != 0) || ((_1599 & 8388608) == 0)) && (((int)(uint((saturate(_152.z) * 1.9921875f) + 0.003921568859368563f)) != 0) || ((_1599 & 16777216) == 0))) {
            _1614 = (int)((int)(_1600 << (((int)(31u - _453)) & 31))) >> 31;
            _1618 = (int)((int)(_1600 << ((31 - _455) & 31))) >> 31;
            _1630 = saturate((asfloat((_1614 & asint(_460))) + asfloat((_1618 & asint(_463)))) + asfloat(((_1618 & 1065353216) & _1614)));
            [branch]
            if (!(_1630 == 0.0f)) {
              _1633 = (uint)(_1595) >> 12;
              if (_1633 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _3121 = (_1630 * select(((_1599 & 67108864) != 0), 1.0f, (1.0f - _1582)));
                } else {
                  _3121 = _1630;
                }
                _3124 = asfloat(srvLightInfoProperties.Load4(_1601)).x;
                _3125 = asfloat(srvLightInfoProperties.Load4(_1601)).y;
                _3126 = asfloat(srvLightInfoProperties.Load4(_1601)).z;
                _3127 = asfloat(srvLightInfoProperties.Load4(_1601)).w;
                _3130 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).x;
                _3131 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).y;
                _3132 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).z;
                _3133 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).w;
                _3136 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).x;
                _3137 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).y;
                _3138 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).z;
                _3141 = asint(srvLightInfoProperties.Load(((int)(_1601 + 68u))));
                _3144 = asint(srvLightInfoProperties.Load(((int)(_1601 + 72u))));
                _3147 = asint(srvLightInfoProperties.Load(((int)(_1601 + 76u))));
                _3150 = asint(srvLightInfoProperties.Load(((int)(_1601 + 84u))));
                _3153 = asint(srvLightInfoProperties.Load(((int)(_1601 + 88u))));
                _3156 = asint(srvLightInfoProperties.Load(((int)(_1601 + 92u))));
                _3159 = (float)((uint)((uint)(((uint)(_3141) >> 8) & 255)));
                _3163 = ((float)((uint)((uint)(_3141 & 255)))) * 0.003921499941498041f;
                _3165 = f16tof32(((uint)((uint)(_3144) >> 16)));
                _3167 = (uint)(_3147) >> 16;
                _3187 = srvDeferredShadingPass_DeferredShadows.Load(int3(_64, _65, 0));
                [branch]
                if (!(_3187.x == 0.0f)) {
                  [branch]
                  if (!(_3167 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3167)))];
                    _3204 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3126, _227, mad(_3125, _226, (_3124 * _225))) + _3127) * f16tof32(((uint)((uint)(_3153) >> 16)))) + f16tof32(((uint)((uint)(_3156) >> 16)))), (((mad(_3132, _227, mad(_3131, _226, (_3130 * _225))) + _3133) * f16tof32(_3153)) + f16tof32(_3156))), 0.0f);
                    _3212 = (_3204.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _3213 = (_3204.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _3214 = (_3204.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _3212 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _3213 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _3214 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  _3217 = min(_3187.x, _3187.y) * _3121;
                  [branch]
                  if (_3217 > 0.0f) {
                    _3220 = dot(float3(_3136, _3137, _3138), float3(_3136, _3137, _3138));
                    _3221 = rsqrt(_3220);
                    _3222 = _3221 * _3136;
                    _3223 = _3221 * _3137;
                    _3224 = _3221 * _3138;
                    _3225 = dot(float3(_187, _188, _189), float3(_3222, _3223, _3224));
                    if (_3165 > 0.0f) {
                      _3233 = sqrt(saturate((_3165 * _3165) * (1.0f / (_3220 + 1.0f))));
                      if (_3225 < _3233) {
                        _3238 = max(_3225, (-0.0f - _3233)) + _3233;
                        _3243 = ((_3238 * _3238) / (_3233 * 4.0f));
                      } else {
                        _3243 = _3225;
                      }
                    } else {
                      _3243 = _3225;
                    }
                    _3244 = _214 * _214;
                    _3248 = saturate((_3165 * (1.0f - _3244)) * _3221);
                    _3250 = saturate(_3221 * f16tof32(_3144));
                    _3251 = dot(float3(_187, _188, _189), float3(_444, _445, _443));
                    _3252 = dot(float3(_444, _445, _443), float3(_3222, _3223, _3224));
                    _3255 = rsqrt((_3252 * 2.0f) + 2.0f);
                    _3262 = (_3248 > 0.0f);
                    if (_3262) {
                      _3266 = sqrt(1.0f - (_3248 * _3248));
                      _3268 = (_3225 * 2.0f) * _3251;
                      _3269 = _3268 - _3252;
                      if (!(_3269 >= _3266)) {
                        _3277 = rsqrt(1.0f - (_3269 * _3269)) * _3248;
                        _3280 = _3277 * (_3251 - (_3269 * _3225));
                        _3281 = _3251 * _3251;
                        _3286 = _3277 * (((_3281 * 2.0f) + -1.0f) - (_3269 * _3252));
                        _3295 = sqrt(saturate((((1.0f - (_3225 * _3225)) - _3281) - (_3252 * _3252)) + (_3268 * _3252)));
                        _3296 = _3295 * _3277;
                        _3299 = ((_3251 * 2.0f) * _3277) * _3295;
                        _3301 = (_3266 * _3225) + _3251;
                        _3302 = _3301 + _3280;
                        _3303 = _3266 * _3252;
                        _3305 = (_3303 + 1.0f) + _3286;
                        _3306 = _3296 * _3305;
                        _3307 = _3302 * _3305;
                        _3308 = _3299 * _3302;
                        _3313 = (((_3302 * 0.25f) * _3299) - (_3306 * 0.5f)) * _3307;
                        _3327 = (((_3308 - (_3306 * 2.0f)) * _3308) + (_3306 * _3306)) + ((((-0.5f - ((_3305 + _3303) * 0.5f)) * _3307) + ((_3305 * _3305) * _3301)) * _3302);
                        _3332 = (_3313 * 2.0f) / ((_3327 * _3327) + (_3313 * _3313));
                        _3333 = _3327 * _3332;
                        _3335 = 1.0f - (_3313 * _3332);
                        _3341 = ((_3333 * _3299) + _3303) + (_3335 * _3286);
                        _3344 = rsqrt((_3341 * 2.0f) + 2.0f);
                        _3353 = saturate((_3341 * _3344) + _3344);
                        _3354 = saturate(((_3301 + (_3333 * _3296)) + (_3335 * _3280)) * _3344);
                      } else {
                        _3353 = abs(_3251);
                        _3354 = 1.0f;
                      }
                    } else {
                      _3353 = saturate((_3255 * _3252) + _3255);
                      _3354 = saturate(_3255 * (_3251 + _3225));
                    }
                    _3355 = saturate(_3243);
                    _3356 = _3244 * _3244;
                    if (_3250 > 0.0f) {
                      _3366 = saturate(((_3250 * _3250) / ((_3353 * 3.5999999046325684f) + 0.4000000059604645f)) + _3356);
                    } else {
                      _3366 = _3356;
                    }
                    _3367 = sqrt(_3366);
                    if (_3262) {
                      _3378 = (_3366 / ((((_3248 * 0.25f) * ((_3367 * 3.0f) + _3248)) / (_3353 + 0.0010000000474974513f)) + _3366));
                    } else {
                      _3378 = 1.0f;
                    }
                    _3382 = (((_3366 * _3354) - _3354) * _3354) + 1.0f;
                    _3392 = exp2(log2(1.0f - saturate(_3353)) * 5.0f);
                    _3401 = saturate(abs(_3251) + 9.999999747378752e-06f);
                    _3402 = 1.0f - _3367;
                    _3414 = saturate((_3225 + _3163) / (_3163 + 1.0f));
                    _3417 = ((_3378 * _3355) * (_3366 / (_3382 * _3382))) * (0.5f / ((((_3402 * _3401) + _3367) * _3355) + (((_3402 * _3355) + _3367) * _3401)));
                    [branch]
                    if (!((_3150 & 1) == 0)) {
                      _3430 = max(max(_3212, _3213), _3214);
                      if (_3430 > 0.0f) {
                        _3440 = saturate(_3212 / _3430);
                        _3441 = saturate(_3213 / _3430);
                        _3442 = saturate(_3214 / _3430);
                      } else {
                        _3440 = _3212;
                        _3441 = _3213;
                        _3442 = _3214;
                      }
                      _3443 = (_3441 < _3442);
                      _3444 = select(_3443, _3442, _3441);
                      _3445 = select(_3443, _3441, _3442);
                      _3446 = select(_3443, -1.0f, 0.0f);
                      _3447 = (_3440 < _3444);
                      _3449 = select(_3447, _3444, _3440);
                      _3450 = select(_3447, _3440, _3444);
                      _3454 = _3449 - select((_3450 < _3445), _3450, _3445);
                      _3460 = abs(select(_3447, (-0.3333333432674408f - _3446), _3446) + ((_3450 - _3445) / ((_3454 * 6.0f) + 9.999999682655225e-21f)));
                      if (_3460 < 0.6666666865348816f) {
                        _3473 = ((saturate(((float)((uint)((uint)(((uint)(_3150) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3460 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3460)) + _3460);
                      } else {
                        _3473 = _3460;
                      }
                      _3474 = saturate((_3454 / (_3449 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3150) >> 1) & 255)))) * 0.003921499941498041f));
                      _3475 = saturate(_3449);
                      if (!(_3474 <= 0.0f)) {
                        _3478 = saturate(_3473);
                        _3482 = select(((_3478 * 360.0f) >= 360.0f), 0.0f, (_3478 * 6.0f));
                        _3483 = int(_3482);
                        _3485 = _3482 - float((int)(_3483));
                        _3487 = _3475 * (1.0f - _3474);
                        _3490 = (1.0f - (_3485 * _3474)) * _3475;
                        _3494 = (1.0f - ((1.0f - _3485) * _3474)) * _3475;
                        switch (_3483) {
                          case 0: {
                            _3502 = _3475;
                            _3503 = _3494;
                            _3504 = _3487;
                            break;
                          }
                          case 1: {
                            _3502 = _3490;
                            _3503 = _3475;
                            _3504 = _3487;
                            break;
                          }
                          case 2: {
                            _3502 = _3487;
                            _3503 = _3475;
                            _3504 = _3494;
                            break;
                          }
                          case 3: {
                            _3502 = _3487;
                            _3503 = _3490;
                            _3504 = _3475;
                            break;
                          }
                          case 4: {
                            _3502 = _3494;
                            _3503 = _3487;
                            _3504 = _3475;
                            break;
                          }
                          case 5: {
                            _3502 = _3475;
                            _3503 = _3487;
                            _3504 = _3490;
                            break;
                          }
                          default: {
                            _3502 = 0.0f;
                            _3503 = 0.0f;
                            _3504 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _3502 = _3475;
                        _3503 = _3475;
                        _3504 = _3475;
                      }
                      _3505 = _3502 * _3430;
                      _3506 = _3503 * _3430;
                      _3507 = _3504 * _3430;
                      _3509 = saturate(_3217 * 1.0101009607315063f);
                      _3520 = ((_3509 * (_3212 - _3505)) + _3505);
                      _3521 = ((_3509 * (_3213 - _3506)) + _3506);
                      _3522 = (lerp(_3507, _3214, _3509));
                    } else {
                      _3520 = _3212;
                      _3521 = _3213;
                      _3522 = _3214;
                    }
                    _3523 = _3520 * _3217;
                    _3524 = _3521 * _3217;
                    _3525 = _3522 * _3217;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _3535 = (_3523 * _1273);
                      _3536 = (_3524 * _1273);
                      _3537 = (_3525 * _1273);
                    } else {
                      _3535 = _3523;
                      _3536 = _3524;
                      _3537 = _3525;
                    }
                    _3541 = (_3535 * _3414) + _1587;
                    _3542 = (_3536 * _3414) + _1588;
                    _3543 = (_3537 * _3414) + _1589;
                    if ((_3159 * 0.003921499941498041f) > 0.0f) {
                      _3546 = (_1346 * 0.003921499941498041f) * _3159;
                      _8454 = _3541;
                      _8455 = _3542;
                      _8456 = _3543;
                      _8457 = (((((_3546 * _1136) * ((_3392 * (1.0f - _206)) + _206)) * _3417) * _3535) + _1590);
                      _8458 = (((((_3546 * _1137) * ((_3392 * (1.0f - _207)) + _207)) * _3417) * _3536) + _1591);
                      _8459 = (((((_3546 * _1138) * ((_3392 * (1.0f - _208)) + _208)) * _3417) * _3537) + _1592);
                    } else {
                      _8454 = _3541;
                      _8455 = _3542;
                      _8456 = _3543;
                      _8457 = _1590;
                      _8458 = _1591;
                      _8459 = _1592;
                    }
                  } else {
                    _8454 = _1587;
                    _8455 = _1588;
                    _8456 = _1589;
                    _8457 = _1590;
                    _8458 = _1591;
                    _8459 = _1592;
                  }
                } else {
                  _8454 = _1587;
                  _8455 = _1588;
                  _8456 = _1589;
                  _8457 = _1590;
                  _8458 = _1591;
                  _8459 = _1592;
                }
              } else {
                _1650 = _1630 * select(((_1599 & 67108864) != 0), 1.0f, (1.0f - _1582));
                [branch]
                if (_1633 == 4) {
                  _1655 = asfloat(srvLightInfoProperties.Load4(_1601)).x;
                  _1656 = asfloat(srvLightInfoProperties.Load4(_1601)).y;
                  _1657 = asfloat(srvLightInfoProperties.Load4(_1601)).z;
                  _1658 = asfloat(srvLightInfoProperties.Load4(_1601)).w;
                  _1661 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).x;
                  _1662 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).y;
                  _1663 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).z;
                  _1664 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).w;
                  _1667 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).x;
                  _1668 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).y;
                  _1669 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).z;
                  _1670 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).w;
                  _1673 = asint(srvLightInfoProperties.Load(((int)(_1601 + 48u))));
                  _1676 = asint(srvLightInfoProperties.Load(((int)(_1601 + 52u))));
                  _1679 = asint(srvLightInfoProperties.Load(((int)(_1601 + 64u))));
                  _1682 = asint(srvLightInfoProperties.Load(((int)(_1601 + 68u))));
                  _1685 = asint(srvLightInfoProperties.Load(((int)(_1601 + 72u))));
                  _1687 = f16tof32(((uint)((uint)(_1673) >> 16)));
                  _1688 = f16tof32(_1673);
                  _1690 = f16tof32(((uint)((uint)(_1676) >> 16)));
                  _1694 = ((float)((uint)((uint)(((uint)(_1676) >> 8) & 255)))) * 0.003921499941498041f;
                  _1707 = mad(_1657, _227, mad(_1656, _226, (_1655 * _225))) + _1658;
                  _1711 = mad(_1663, _227, mad(_1662, _226, (_1661 * _225))) + _1664;
                  _1715 = mad(_1669, _227, mad(_1668, _226, (_1667 * _225))) + _1670;
                  _1740 = saturate(1.0f - ((_1707 + 1.0f) * f16tof32(_1679))) + saturate(1.0f - ((1.0f - _1707) * f16tof32(((uint)((uint)(_1679) >> 16)))));
                  _1741 = saturate(1.0f - ((_1711 + 1.0f) * f16tof32(_1682))) + saturate(1.0f - ((1.0f - _1711) * f16tof32(((uint)((uint)(_1682) >> 16)))));
                  _1742 = saturate(1.0f - ((_1715 + 1.0f) * f16tof32(_1685))) + saturate(1.0f - ((1.0f - _1715) * f16tof32(((uint)((uint)(_1685) >> 16)))));
                  _1745 = saturate(1.0f - dot(float3(_1740, _1741, _1742), float3(_1740, _1741, _1742)));
                  _1746 = _1745 * _1745;
                  _1753 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1746 * _1273), _1746) * _1650;
                  _8454 = ((_1753 * _1687) + _1587);
                  _8455 = ((_1753 * _1688) + _1588);
                  _8456 = ((_1753 * _1690) + _1589);
                  _8457 = (((_1694 * _1687) * _1753) + _1590);
                  _8458 = (((_1694 * _1688) * _1753) + _1591);
                  _8459 = (((_1690 * _1694) * _1753) + _1592);
                } else {
                  if (_1633 == 5) {
                    _1774 = asfloat(srvLightInfoProperties.Load4(_1601)).x;
                    _1775 = asfloat(srvLightInfoProperties.Load4(_1601)).y;
                    _1776 = asfloat(srvLightInfoProperties.Load4(_1601)).z;
                    _1777 = asfloat(srvLightInfoProperties.Load4(_1601)).w;
                    _1780 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).x;
                    _1781 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).y;
                    _1782 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).z;
                    _1783 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).w;
                    _1786 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).x;
                    _1787 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).y;
                    _1788 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).z;
                    _1789 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).w;
                    _1792 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).x;
                    _1793 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).y;
                    _1794 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).z;
                    _1797 = asfloat(srvLightInfoProperties.Load(((int)(_1601 + 60u))));
                    _1800 = asint(srvLightInfoProperties.Load(((int)(_1601 + 64u))));
                    _1803 = asint(srvLightInfoProperties.Load(((int)(_1601 + 68u))));
                    _1806 = asint(srvLightInfoProperties.Load(((int)(_1601 + 80u))));
                    _1809 = asint(srvLightInfoProperties.Load(((int)(_1601 + 84u))));
                    _1812 = asint(srvLightInfoProperties.Load(((int)(_1601 + 88u))));
                    _1815 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 92u)))).x;
                    _1816 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 92u)))).y;
                    _1817 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 92u)))).z;
                    _1818 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 92u)))).w;
                    _1821 = asint(srvLightInfoProperties.Load(((int)(_1601 + 108u))));
                    _1824 = asint(srvLightInfoProperties.Load(((int)(_1601 + 112u))));
                    _1827 = asint(srvLightInfoProperties.Load(((int)(_1601 + 120u))));
                    _1830 = asint(srvLightInfoProperties.Load(((int)(_1601 + 124u))));
                    _1833 = asint(srvLightInfoProperties.Load(((int)(_1601 + 128u))));
                    _1836 = asint(srvLightInfoProperties.Load(((int)(_1601 + 132u))));
                    _1839 = asint(srvLightInfoProperties.Load(((int)(_1601 + 136u))));
                    _1842 = asint(srvLightInfoProperties.Load(((int)(_1601 + 140u))));
                    _1844 = f16tof32(((uint)((uint)(_1800) >> 16)));
                    _1845 = f16tof32(_1800);
                    _1847 = f16tof32(((uint)((uint)(_1803) >> 16)));
                    _1851 = ((float)((uint)((uint)(((uint)(_1803) >> 8) & 255)))) * 0.003921499941498041f;
                    _1854 = ((float)((uint)((uint)(_1803 & 255)))) * 0.003921499941498041f;
                    _1856 = f16tof32(((uint)((uint)(_1806) >> 16)));
                    _1859 = _1809 & 65535;
                    _1869 = f16tof32(((uint)((uint)(_1824) >> 16)));
                    _1870 = f16tof32(_1824);
                    _1872 = f16tof32(((uint)((uint)(_1827) >> 16)));
                    _1873 = 1.0f / _1872;
                    _1874 = _1872 + -1.0f;
                    _1875 = f16tof32(_1827);
                    _1894 = saturate(1.0f - dot(float3(_187, _188, _189), float3(_1792, _1793, _1794))) * f16tof32(_1821);
                    _1898 = (_1894 * _187) + _225;
                    _1899 = (_1894 * _188) + _226;
                    _1900 = (_1894 * _189) - _224;
                    _1904 = mad(_1776, _1900, mad(_1775, _1899, (_1898 * _1774))) + _1777;
                    _1908 = mad(_1782, _1900, mad(_1781, _1899, (_1898 * _1780))) + _1783;
                    _1912 = mad(_1788, _1900, mad(_1787, _1899, (_1898 * _1786))) + _1789;
                    _1913 = saturate(_1912);
                    _1936 = saturate(1.0f - (_1904 * f16tof32(_1836))) + saturate(1.0f - ((1.0f - _1904) * f16tof32(((uint)((uint)(_1836) >> 16)))));
                    _1937 = saturate(1.0f - (_1908 * f16tof32(_1839))) + saturate(1.0f - ((1.0f - _1908) * f16tof32(((uint)((uint)(_1839) >> 16)))));
                    _1938 = saturate(1.0f - (_1912 * f16tof32(_1842))) + saturate(1.0f - ((1.0f - _1912) * f16tof32(((uint)((uint)(_1842) >> 16)))));
                    _1941 = saturate(1.0f - dot(float3(_1936, _1937, _1938), float3(_1936, _1937, _1938)));
                    _1942 = _1941 * _1941;
                    if (!(((_1599 & 3584) == 0) || (!(_1942 > 0.0f)))) {
                      _1949 = 1.0f - _1913;
                      _1950 = saturate(_1904);
                      _1951 = saturate(_1908);
                      bool __branch_chain_1946;
                      [branch]
                      if ((_1599 & 1024) == 0) {
                        _2214 = 1.0f;
                        _2215 = 0.0f;
                        _2216 = _1949;
                        __branch_chain_1946 = true;
                      } else {
                        _1956 = ((_1950 * _1874) + 0.5f) * _1873;
                        _1958 = ((_1951 * _1874) + 0.5f) * _1873;
                        _1959 = _1949 + f16tof32(((uint)((uint)(_1821) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1809) >> 16))];
                        _1962 = saturate(_1959);
                        _1966 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1975 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1966 * 32.665000915527344f) + _126), ((_1966 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1976 = sin(_1975);
                        _1977 = cos(_1975);
                        _1978 = cbSharedPerViewData.nFrameCounter & 3;
                        _1983 = sqrt((float((int)(_1978)) * 0.25f) + 0.125f) * _1869;
                        _1992 = (_global_7[min((uint)(((int)(0u + (_1978 * 2)))), 127u)]) * _1983;
                        _1993 = (_global_7[min((uint)(((int)(1u + (_1978 * 2)))), 127u)]) * _1983;
                        _1995 = -0.0f - _1976;
                        _2000 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1992, _1993), float2(_1977, _1976)) + _1956), (dot(float2(_1992, _1993), float2(_1995, _1977)) + _1958)));
                        _2005 = _2000.x - _1962;
                        _2007 = select((_2005 < 0.0f), 0.0f, 1.0f);
                        _2009 = _2000.y - _1962;
                        _2011 = select((_2009 < 0.0f), 0.0f, 1.0f);
                        _2015 = _2000.z - _1962;
                        _2017 = select((_2015 < 0.0f), 0.0f, 1.0f);
                        _2021 = _2000.w - _1962;
                        _2023 = select((_2021 < 0.0f), 0.0f, 1.0f);
                        _2030 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _2035 = sqrt((float((int)(_2030)) * 0.25f) + 0.125f) * _1869;
                        _2044 = (_global_7[min((uint)(((int)(0u + (_2030 * 2)))), 127u)]) * _2035;
                        _2045 = (_global_7[min((uint)(((int)(1u + (_2030 * 2)))), 127u)]) * _2035;
                        _2051 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2044, _2045), float2(_1977, _1976)) + _1956), (dot(float2(_2044, _2045), float2(_1995, _1977)) + _1958)));
                        _2056 = _2051.x - _1962;
                        _2058 = select((_2056 < 0.0f), 0.0f, 1.0f);
                        _2062 = _2051.y - _1962;
                        _2064 = select((_2062 < 0.0f), 0.0f, 1.0f);
                        _2068 = _2051.z - _1962;
                        _2070 = select((_2068 < 0.0f), 0.0f, 1.0f);
                        _2074 = _2051.w - _1962;
                        _2076 = select((_2074 < 0.0f), 0.0f, 1.0f);
                        _2083 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _2088 = sqrt((float((int)(_2083)) * 0.25f) + 0.125f) * _1869;
                        _2097 = (_global_7[min((uint)(((int)(0u + (_2083 * 2)))), 127u)]) * _2088;
                        _2098 = (_global_7[min((uint)(((int)(1u + (_2083 * 2)))), 127u)]) * _2088;
                        _2104 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2097, _2098), float2(_1977, _1976)) + _1956), (dot(float2(_2097, _2098), float2(_1995, _1977)) + _1958)));
                        _2109 = _2104.x - _1962;
                        _2111 = select((_2109 < 0.0f), 0.0f, 1.0f);
                        _2115 = _2104.y - _1962;
                        _2117 = select((_2115 < 0.0f), 0.0f, 1.0f);
                        _2121 = _2104.z - _1962;
                        _2123 = select((_2121 < 0.0f), 0.0f, 1.0f);
                        _2127 = _2104.w - _1962;
                        _2129 = select((_2127 < 0.0f), 0.0f, 1.0f);
                        _2136 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _2141 = sqrt((float((int)(_2136)) * 0.25f) + 0.125f) * _1869;
                        _2150 = (_global_7[min((uint)(((int)(0u + (_2136 * 2)))), 127u)]) * _2141;
                        _2151 = (_global_7[min((uint)(((int)(1u + (_2136 * 2)))), 127u)]) * _2141;
                        _2157 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2150, _2151), float2(_1977, _1976)) + _1956), (dot(float2(_2150, _2151), float2(_1995, _1977)) + _1958)));
                        _2162 = _2157.x - _1962;
                        _2164 = select((_2162 < 0.0f), 0.0f, 1.0f);
                        _2168 = _2157.y - _1962;
                        _2170 = select((_2168 < 0.0f), 0.0f, 1.0f);
                        _2174 = _2157.z - _1962;
                        _2176 = select((_2174 < 0.0f), 0.0f, 1.0f);
                        _2180 = _2157.w - _1962;
                        _2182 = select((_2180 < 0.0f), 0.0f, 1.0f);
                        _2183 = ((((((((((((((_2007 + _2011) + _2017) + _2023) + _2058) + _2064) + _2070) + _2076) + _2111) + _2117) + _2123) + _2129) + _2164) + _2170) + _2176) + _2182;
                        _2194 = (saturate(_2183 * 0.0625f) * 2.0f) + -1.0f;
                        _2200 = float((int)(((int)(uint)((int)(_2194 > 0.0f))) - ((int)(uint)((int)(_2194 < 0.0f)))));
                        _2202 = 1.0f - (_2200 * _2194);
                        _2204 = (_2202 * _2202) * _2202;
                        _2211 = 0.5f - ((_2200 * 0.5f) * ((1.0f - _2204) - ((_2202 - _2204) * saturate(((1.0f / _1962) * (1.0f / _2183)) * ((((((((((((((((_2007 * _2005) + (_2011 * _2009)) + (_2017 * _2015)) + (_2023 * _2021)) + (_2058 * _2056)) + (_2064 * _2062)) + (_2070 * _2068)) + (_2076 * _2074)) + (_2111 * _2109)) + (_2117 * _2115)) + (_2123 * _2121)) + (_2129 * _2127)) + (_2164 * _2162)) + (_2170 * _2168)) + (_2176 * _2174)) + (_2182 * _2180))))));
                        [branch]
                        if (_1875 < 1.0f) {
                          _2214 = _2211;
                          _2215 = _1875;
                          _2216 = _1959;
                          __branch_chain_1946 = true;
                        } else {
                          _2684 = _2211;
                          __branch_chain_1946 = false;
                        }
                      }
                      if (__branch_chain_1946) {
                        _2219 = (_1950 * _1815) + _1817;
                        _2220 = (_1951 * _1816) + _1818;
                        if (!((_1599 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _2229 = saturate(_2216);
                          _2233 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2242 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2233 * 32.665000915527344f) + _126), ((_2233 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2243 = sin(_2242);
                          _2244 = cos(_2242);
                          _2249 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2219, _2220), 0.0f))).x) > _2229), 1.0f, 0.0f);
                          _2250 = cbSharedPerViewData.nFrameCounter & 3;
                          _2255 = sqrt((float((int)(_2250)) * 0.25f) + 0.125f) * _1870;
                          _2264 = (_global_7[min((uint)(((int)(0u + (_2250 * 2)))), 127u)]) * _2255;
                          _2265 = (_global_7[min((uint)(((int)(1u + (_2250 * 2)))), 127u)]) * _2255;
                          _2267 = -0.0f - _2243;
                          _2269 = dot(float2(_2264, _2265), float2(_2244, _2243)) + _2219;
                          _2270 = dot(float2(_2264, _2265), float2(_2267, _2244)) + _2220;
                          _2272 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2269, _2270));
                          _2276 = _2269 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2277 = _2270 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2280 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1817);
                          _2281 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1818);
                          _2286 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1815 + _1817)) + 0.5f);
                          _2287 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1816 + _1818)) + 0.5f);
                          _2290 = floor(_2276 + -0.5f);
                          _2291 = floor(_2277 + 0.5f);
                          _2293 = floor(_2276 + 0.5f);
                          _2295 = floor(_2277 + -0.5f);
                          _2296 = (_2290 < _2280);
                          _2297 = (_2291 < _2281);
                          if ((_2296 || _2297) | ((_2290 >= _2286) || (_2291 >= _2287))) {
                            _2306 = _2249;
                          } else {
                            _2306 = _2272.x;
                          }
                          _2307 = (_2293 < _2280);
                          if ((_2307 || _2297) | ((_2293 >= _2286) || (_2291 >= _2287))) {
                            _2315 = _2249;
                          } else {
                            _2315 = _2272.y;
                          }
                          _2316 = (_2295 < _2281);
                          if ((_2307 || _2316) | ((_2293 >= _2286) || (_2295 >= _2287))) {
                            _2324 = _2249;
                          } else {
                            _2324 = _2272.z;
                          }
                          if ((_2296 || _2316) | ((_2290 >= _2286) || (_2295 >= _2287))) {
                            _2332 = _2249;
                          } else {
                            _2332 = _2272.w;
                          }
                          _2333 = _2306 - _2229;
                          _2335 = select((_2333 < 0.0f), 0.0f, 1.0f);
                          _2337 = _2315 - _2229;
                          _2339 = select((_2337 < 0.0f), 0.0f, 1.0f);
                          _2343 = _2324 - _2229;
                          _2345 = select((_2343 < 0.0f), 0.0f, 1.0f);
                          _2349 = _2332 - _2229;
                          _2351 = select((_2349 < 0.0f), 0.0f, 1.0f);
                          _2358 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2363 = sqrt((float((int)(_2358)) * 0.25f) + 0.125f) * _1870;
                          _2372 = (_global_7[min((uint)(((int)(0u + (_2358 * 2)))), 127u)]) * _2363;
                          _2373 = (_global_7[min((uint)(((int)(1u + (_2358 * 2)))), 127u)]) * _2363;
                          _2376 = dot(float2(_2372, _2373), float2(_2244, _2243)) + _2219;
                          _2377 = dot(float2(_2372, _2373), float2(_2267, _2244)) + _2220;
                          _2379 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2376, _2377));
                          _2383 = _2376 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2384 = _2377 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2387 = floor(_2383 + -0.5f);
                          _2388 = floor(_2384 + 0.5f);
                          _2390 = floor(_2383 + 0.5f);
                          _2392 = floor(_2384 + -0.5f);
                          _2393 = (_2387 < _2280);
                          _2394 = (_2388 < _2281);
                          if ((_2393 || _2394) | ((_2387 >= _2286) || (_2388 >= _2287))) {
                            _2403 = _2249;
                          } else {
                            _2403 = _2379.x;
                          }
                          _2404 = (_2390 < _2280);
                          if ((_2404 || _2394) | ((_2390 >= _2286) || (_2388 >= _2287))) {
                            _2412 = _2249;
                          } else {
                            _2412 = _2379.y;
                          }
                          _2413 = (_2392 < _2281);
                          if ((_2404 || _2413) | ((_2390 >= _2286) || (_2392 >= _2287))) {
                            _2421 = _2249;
                          } else {
                            _2421 = _2379.z;
                          }
                          if ((_2393 || _2413) | ((_2387 >= _2286) || (_2392 >= _2287))) {
                            _2429 = _2249;
                          } else {
                            _2429 = _2379.w;
                          }
                          _2430 = _2403 - _2229;
                          _2432 = select((_2430 < 0.0f), 0.0f, 1.0f);
                          _2436 = _2412 - _2229;
                          _2438 = select((_2436 < 0.0f), 0.0f, 1.0f);
                          _2442 = _2421 - _2229;
                          _2444 = select((_2442 < 0.0f), 0.0f, 1.0f);
                          _2448 = _2429 - _2229;
                          _2450 = select((_2448 < 0.0f), 0.0f, 1.0f);
                          _2457 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2462 = sqrt((float((int)(_2457)) * 0.25f) + 0.125f) * _1870;
                          _2471 = (_global_7[min((uint)(((int)(0u + (_2457 * 2)))), 127u)]) * _2462;
                          _2472 = (_global_7[min((uint)(((int)(1u + (_2457 * 2)))), 127u)]) * _2462;
                          _2475 = dot(float2(_2471, _2472), float2(_2244, _2243)) + _2219;
                          _2476 = dot(float2(_2471, _2472), float2(_2267, _2244)) + _2220;
                          _2478 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2475, _2476));
                          _2482 = _2475 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2483 = _2476 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2486 = floor(_2482 + -0.5f);
                          _2487 = floor(_2483 + 0.5f);
                          _2489 = floor(_2482 + 0.5f);
                          _2491 = floor(_2483 + -0.5f);
                          _2492 = (_2486 < _2280);
                          _2493 = (_2487 < _2281);
                          if ((_2492 || _2493) | ((_2486 >= _2286) || (_2487 >= _2287))) {
                            _2502 = _2249;
                          } else {
                            _2502 = _2478.x;
                          }
                          _2503 = (_2489 < _2280);
                          if ((_2503 || _2493) | ((_2489 >= _2286) || (_2487 >= _2287))) {
                            _2511 = _2249;
                          } else {
                            _2511 = _2478.y;
                          }
                          _2512 = (_2491 < _2281);
                          if ((_2503 || _2512) | ((_2489 >= _2286) || (_2491 >= _2287))) {
                            _2520 = _2249;
                          } else {
                            _2520 = _2478.z;
                          }
                          if ((_2492 || _2512) | ((_2486 >= _2286) || (_2491 >= _2287))) {
                            _2528 = _2249;
                          } else {
                            _2528 = _2478.w;
                          }
                          _2529 = _2502 - _2229;
                          _2531 = select((_2529 < 0.0f), 0.0f, 1.0f);
                          _2535 = _2511 - _2229;
                          _2537 = select((_2535 < 0.0f), 0.0f, 1.0f);
                          _2541 = _2520 - _2229;
                          _2543 = select((_2541 < 0.0f), 0.0f, 1.0f);
                          _2547 = _2528 - _2229;
                          _2549 = select((_2547 < 0.0f), 0.0f, 1.0f);
                          _2556 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2561 = sqrt((float((int)(_2556)) * 0.25f) + 0.125f) * _1870;
                          _2570 = (_global_7[min((uint)(((int)(0u + (_2556 * 2)))), 127u)]) * _2561;
                          _2571 = (_global_7[min((uint)(((int)(1u + (_2556 * 2)))), 127u)]) * _2561;
                          _2574 = dot(float2(_2570, _2571), float2(_2244, _2243)) + _2219;
                          _2575 = dot(float2(_2570, _2571), float2(_2267, _2244)) + _2220;
                          _2577 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2574, _2575));
                          _2581 = _2574 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2582 = _2575 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2585 = floor(_2581 + -0.5f);
                          _2586 = floor(_2582 + 0.5f);
                          _2588 = floor(_2581 + 0.5f);
                          _2590 = floor(_2582 + -0.5f);
                          _2591 = (_2585 < _2280);
                          _2592 = (_2586 < _2281);
                          if ((_2591 || _2592) | ((_2585 >= _2286) || (_2586 >= _2287))) {
                            _2601 = _2249;
                          } else {
                            _2601 = _2577.x;
                          }
                          _2602 = (_2588 < _2280);
                          if ((_2602 || _2592) | ((_2588 >= _2286) || (_2586 >= _2287))) {
                            _2610 = _2249;
                          } else {
                            _2610 = _2577.y;
                          }
                          _2611 = (_2590 < _2281);
                          if ((_2602 || _2611) | ((_2588 >= _2286) || (_2590 >= _2287))) {
                            _2619 = _2249;
                          } else {
                            _2619 = _2577.z;
                          }
                          if ((_2591 || _2611) | ((_2585 >= _2286) || (_2590 >= _2287))) {
                            _2627 = _2249;
                          } else {
                            _2627 = _2577.w;
                          }
                          _2628 = _2601 - _2229;
                          _2630 = select((_2628 < 0.0f), 0.0f, 1.0f);
                          _2634 = _2610 - _2229;
                          _2636 = select((_2634 < 0.0f), 0.0f, 1.0f);
                          _2640 = _2619 - _2229;
                          _2642 = select((_2640 < 0.0f), 0.0f, 1.0f);
                          _2646 = _2627 - _2229;
                          _2648 = select((_2646 < 0.0f), 0.0f, 1.0f);
                          _2649 = ((((((((((((((_2339 + _2335) + _2345) + _2351) + _2432) + _2438) + _2444) + _2450) + _2531) + _2537) + _2543) + _2549) + _2630) + _2636) + _2642) + _2648;
                          _2660 = (saturate(_2649 * 0.0625f) * 2.0f) + -1.0f;
                          _2666 = float((int)(((int)(uint)((int)(_2660 > 0.0f))) - ((int)(uint)((int)(_2660 < 0.0f)))));
                          _2668 = 1.0f - (_2666 * _2660);
                          _2670 = (_2668 * _2668) * _2668;
                          _2679 = (0.5f - ((_2666 * 0.5f) * ((1.0f - _2670) - ((_2668 - _2670) * saturate(((1.0f / _2229) * (1.0f / _2649)) * ((((((((((((((((_2339 * _2337) + (_2335 * _2333)) + (_2345 * _2343)) + (_2351 * _2349)) + (_2432 * _2430)) + (_2438 * _2436)) + (_2444 * _2442)) + (_2450 * _2448)) + (_2531 * _2529)) + (_2537 * _2535)) + (_2543 * _2541)) + (_2549 * _2547)) + (_2630 * _2628)) + (_2636 * _2634)) + (_2642 * _2640)) + (_2648 * _2646)))))));
                        } else {
                          _2679 = 1.0f;
                        }
                        _2684 = (lerp(_2679, _2214, _2215));
                      }
                      [branch]
                      if (!((_1599 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1812) >> 16))];
                        _2690 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1904, _1908), 0.0f);
                        if (_2690.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1812 & 65535))];
                          _2697 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1904, _1908), 0.0f);
                          _2711 = mad(saturate(((log2(_1913 * _1797) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2712 = max(9.999999747378752e-06f, _2690.x);
                          _2713 = _2697.x / _2712;
                          _2714 = _2697.y / _2712;
                          _2716 = _2697.w / _2712;
                          _2721 = ((0.375f - _2714) * 4.999999873689376e-06f) + _2714;
                          _2724 = -0.0f - _2713;
                          _2725 = mad(_2724, _2721, (_2697.z / _2712));
                          _2727 = 1.0f / mad(_2724, _2713, _2721);
                          _2728 = _2727 * _2725;
                          _2733 = _2711 - _2713;
                          _2738 = (((_2711 * _2711) - _2721) - (_2728 * _2733)) / mad((-0.0f - _2725), _2728, mad((-0.0f - _2721), _2721, (((0.375f - _2716) * 4.999999873689376e-06f) + _2716)));
                          _2740 = (_2727 * _2733) - (_2738 * _2728);
                          _2743 = 1.0f / _2738;
                          _2744 = _2740 * _2743;
                          _2749 = sqrt(((_2744 * _2744) * 0.25f) - ((1.0f - dot(float2(_2740, _2738), float2(_2713, _2721))) * _2743));
                          _2751 = (_2744 * -0.5f) - _2749;
                          _2753 = _2749 - (_2744 * 0.5f);
                          _2755 = select((_2751 < _2711), 1.0f, 0.0f);
                          _2760 = (_2755 + -0.05000000074505806f) / (_2751 - _2711);
                          _2766 = (((select((_2753 < _2711), 1.0f, 0.0f) - _2755) / (_2753 - _2751)) - _2760) / (_2753 - _2711);
                          _2768 = _2760 - (_2766 * _2751);
                          _2781 = (exp2((_2690.x * -1.4426950216293335f) * saturate((dot(float2(_2713, _2721), float2((_2768 - (_2766 * _2711)), _2766)) + 0.05000000074505806f) - (_2768 * _2711))) * _2684);
                        } else {
                          _2781 = _2684;
                        }
                      } else {
                        _2781 = _2684;
                      }
                    } else {
                      _2781 = 1.0f;
                    }
                    [branch]
                    if (!(_1859 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1859)))];
                      _2794 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1904 * f16tof32(((uint)((uint)(_1830) >> 16)))) + f16tof32(((uint)((uint)(_1833) >> 16)))), ((_1908 * f16tof32(_1830)) + f16tof32(_1833))), 0.0f);
                      _2802 = (_2794.x * _1844);
                      _2803 = (_2794.y * _1845);
                      _2804 = (_2794.z * _1847);
                    } else {
                      _2802 = _1844;
                      _2803 = _1845;
                      _2804 = _1847;
                    }
                    _2805 = _2781 * _1942;
                    [branch]
                    if (!(_2805 == 0.0f)) {
                      bool __branch_chain_2807;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2823 = 0;
                        __branch_chain_2807 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2823 = 1;
                          __branch_chain_2807 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2823 = 2;
                            __branch_chain_2807 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2823 = 3;
                              __branch_chain_2807 = true;
                            } else {
                              _2844 = _2805;
                              __branch_chain_2807 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2807) {
                        while(true) {
                          _2826 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_64, _65, 0));
                          if (_2823 == 0) {
                            _2840 = _2826.x;
                          } else {
                            if (_2823 == 1) {
                              _2840 = _2826.y;
                            } else {
                              if (_2823 == 2) {
                                _2840 = _2826.z;
                              } else {
                                _2840 = _2826.w;
                              }
                            }
                          }
                          _2844 = ((_2840 * _2840) * _1942);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2844 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2854 = srvLightMappingData[_1602];
                            if (!(_2854 == -1)) {
                              _2859 = srvLightIndexData[_2854].nLayerIndex;
                              _2861 = srvLightIndexData[_2854].vAtlasOrigin.x;
                              _2862 = srvLightIndexData[_2854].vAtlasOrigin.y;
                              _2864 = srvLightIndexData[_2854].vScreenOrigin.x;
                              _2865 = srvLightIndexData[_2854].vScreenOrigin.y;
                              _2874 = ((int)(_2859 * 5)) & 31;
                              _2883 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2861 + _64) - _2864)), ((int)((_2862 + _65) - _2865)), 0)))).x) & ((int)(31 << _2874)))) >> _2874)) >> 1)))) * 0.06666667014360428f) * _2844);
                            } else {
                              _2883 = _2844;
                            }
                          } else {
                            _2883 = _2844;
                          }
                          _2887 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2890 = select(_2887, (_2883 * _1273), _2883);
                          _2892 = dot(float3(_1792, _1793, _1794), float3(_1792, _1793, _1794));
                          _2893 = rsqrt(_2892);
                          _2894 = _2893 * _1792;
                          _2895 = _2893 * _1793;
                          _2896 = _2893 * _1794;
                          _2897 = dot(float3(_187, _188, _189), float3(_2894, _2895, _2896));
                          if (_1856 > 0.0f) {
                            _2905 = sqrt(saturate((_1856 * _1856) * (1.0f / (_2892 + 1.0f))));
                            if (_2897 < _2905) {
                              _2910 = max(_2897, (-0.0f - _2905)) + _2905;
                              _2915 = ((_2910 * _2910) / (_2905 * 4.0f));
                            } else {
                              _2915 = _2897;
                            }
                          } else {
                            _2915 = _2897;
                          }
                          _2916 = _214 * _214;
                          _2920 = saturate((_1856 * (1.0f - _2916)) * _2893);
                          _2922 = saturate(_2893 * f16tof32(_1806));
                          _2923 = dot(float3(_187, _188, _189), float3(_444, _445, _443));
                          _2924 = dot(float3(_444, _445, _443), float3(_2894, _2895, _2896));
                          _2927 = rsqrt((_2924 * 2.0f) + 2.0f);
                          _2934 = (_2920 > 0.0f);
                          if (_2934) {
                            _2938 = sqrt(1.0f - (_2920 * _2920));
                            _2940 = (_2897 * 2.0f) * _2923;
                            _2941 = _2940 - _2924;
                            if (!(_2941 >= _2938)) {
                              _2949 = rsqrt(1.0f - (_2941 * _2941)) * _2920;
                              _2952 = _2949 * (_2923 - (_2941 * _2897));
                              _2953 = _2923 * _2923;
                              _2958 = _2949 * (((_2953 * 2.0f) + -1.0f) - (_2941 * _2924));
                              _2967 = sqrt(saturate((((1.0f - (_2897 * _2897)) - _2953) - (_2924 * _2924)) + (_2940 * _2924)));
                              _2968 = _2967 * _2949;
                              _2971 = ((_2923 * 2.0f) * _2949) * _2967;
                              _2973 = (_2938 * _2897) + _2923;
                              _2974 = _2973 + _2952;
                              _2975 = _2938 * _2924;
                              _2977 = (_2975 + 1.0f) + _2958;
                              _2978 = _2968 * _2977;
                              _2979 = _2974 * _2977;
                              _2980 = _2971 * _2974;
                              _2985 = (((_2974 * 0.25f) * _2971) - (_2978 * 0.5f)) * _2979;
                              _2999 = (((_2980 - (_2978 * 2.0f)) * _2980) + (_2978 * _2978)) + ((((-0.5f - ((_2977 + _2975) * 0.5f)) * _2979) + ((_2977 * _2977) * _2973)) * _2974);
                              _3004 = (_2985 * 2.0f) / ((_2999 * _2999) + (_2985 * _2985));
                              _3005 = _2999 * _3004;
                              _3007 = 1.0f - (_2985 * _3004);
                              _3013 = ((_3005 * _2971) + _2975) + (_3007 * _2958);
                              _3016 = rsqrt((_3013 * 2.0f) + 2.0f);
                              _3025 = saturate((_3013 * _3016) + _3016);
                              _3026 = saturate(((_2973 + (_3005 * _2968)) + (_3007 * _2952)) * _3016);
                            } else {
                              _3025 = abs(_2923);
                              _3026 = 1.0f;
                            }
                          } else {
                            _3025 = saturate((_2927 * _2924) + _2927);
                            _3026 = saturate(_2927 * (_2923 + _2897));
                          }
                          _3027 = saturate(_2915);
                          _3028 = _2916 * _2916;
                          if (_2922 > 0.0f) {
                            _3038 = saturate(((_2922 * _2922) / ((_3025 * 3.5999999046325684f) + 0.4000000059604645f)) + _3028);
                          } else {
                            _3038 = _3028;
                          }
                          _3039 = sqrt(_3038);
                          if (_2934) {
                            _3050 = (_3038 / ((((_2920 * 0.25f) * ((_3039 * 3.0f) + _2920)) / (_3025 + 0.0010000000474974513f)) + _3038));
                          } else {
                            _3050 = 1.0f;
                          }
                          _3054 = (((_3038 * _3026) - _3026) * _3026) + 1.0f;
                          _3061 = exp2(log2(1.0f - saturate(_3025)) * 5.0f);
                          _3064 = saturate(abs(_2923) + 9.999999747378752e-06f);
                          _3065 = 1.0f - _3039;
                          _3077 = saturate((_2897 + _1854) / (_1854 + 1.0f));
                          _3080 = ((_3050 * _3027) * (_3038 / (_3054 * _3054))) * (0.5f / ((((_3065 * _3064) + _3039) * _3027) + (((_3065 * _3027) + _3039) * _3064)));
                          _3081 = _2802 * _1650;
                          _3082 = _2803 * _1650;
                          _3083 = _2804 * _1650;
                          _3090 = ((_2890 * _3081) * _3077) + _1587;
                          _3091 = ((_2890 * _3082) * _3077) + _1588;
                          _3092 = ((_2890 * _3083) * _3077) + _1589;
                          if (_1851 > 0.0f) {
                            _3104 = (_1851 * _1346) * select(_2887, (_2883 * _1273), _2883);
                            _8454 = _3090;
                            _8455 = _3091;
                            _8456 = _3092;
                            _8457 = (((((_3081 * _1136) * _3104) * ((_3061 * (1.0f - _206)) + _206)) * _3080) + _1590);
                            _8458 = (((((_3082 * _1137) * _3104) * ((_3061 * (1.0f - _207)) + _207)) * _3080) + _1591);
                            _8459 = (((((_3083 * _1138) * _3104) * ((_3061 * (1.0f - _208)) + _208)) * _3080) + _1592);
                          } else {
                            _8454 = _3090;
                            _8455 = _3091;
                            _8456 = _3092;
                            _8457 = _1590;
                            _8458 = _1591;
                            _8459 = _1592;
                          }
                        } else {
                          _8454 = _1587;
                          _8455 = _1588;
                          _8456 = _1589;
                          _8457 = _1590;
                          _8458 = _1591;
                          _8459 = _1592;
                        }
                        break;
                      }
                    } else {
                      _8454 = _1587;
                      _8455 = _1588;
                      _8456 = _1589;
                      _8457 = _1590;
                      _8458 = _1591;
                      _8459 = _1592;
                    }
                  } else {
                    if (_1633 == 7) {
                      _3567 = asfloat(srvLightInfoProperties.Load3(_1601)).x;
                      _3568 = asfloat(srvLightInfoProperties.Load3(_1601)).y;
                      _3569 = asfloat(srvLightInfoProperties.Load3(_1601)).z;
                      _3572 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 12u)))).x;
                      _3573 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 12u)))).y;
                      _3574 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 12u)))).z;
                      _3577 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 24u)))).x;
                      _3578 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 24u)))).y;
                      _3579 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 24u)))).z;
                      _3582 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 36u)))).x;
                      _3583 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 36u)))).y;
                      _3584 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 36u)))).z;
                      _3587 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).x;
                      _3588 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).y;
                      _3589 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 48u)))).z;
                      _3592 = asint(srvLightInfoProperties.Load(((int)(_1601 + 60u))));
                      _3595 = asint(srvLightInfoProperties.Load(((int)(_1601 + 64u))));
                      _3598 = asint(srvLightInfoProperties.Load(((int)(_1601 + 72u))));
                      _3601 = asint(srvLightInfoProperties.Load(((int)(_1601 + 76u))));
                      _3604 = asint(srvLightInfoProperties.Load(((int)(_1601 + 80u))));
                      _3607 = asint(srvLightInfoProperties.Load(((int)(_1601 + 84u))));
                      _3610 = asint(srvLightInfoProperties.Load(((int)(_1601 + 88u))));
                      _3613 = asint(srvLightInfoProperties.Load(((int)(_1601 + 92u))));
                      _3616 = asint(srvLightInfoProperties.Load(((int)(_1601 + 96u))));
                      _3619 = asint(srvLightInfoProperties.Load(((int)(_1601 + 100u))));
                      _3622 = asint(srvLightInfoProperties.Load(((int)(_1601 + 104u))));
                      _3625 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).x;
                      _3626 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).y;
                      _3627 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).z;
                      _3628 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).w;
                      _3631 = asint(srvLightInfoProperties.Load(((int)(_1601 + 124u))));
                      _3634 = asint(srvLightInfoProperties.Load(((int)(_1601 + 128u))));
                      _3637 = asint(srvLightInfoProperties.Load(((int)(_1601 + 136u))));
                      _3640 = asint(srvLightInfoProperties.Load(((int)(_1601 + 140u))));
                      _3642 = f16tof32(((uint)((uint)(_3592) >> 16)));
                      _3643 = f16tof32(_3592);
                      _3645 = f16tof32(((uint)((uint)(_3595) >> 16)));
                      _3649 = ((float)((uint)((uint)(((uint)(_3595) >> 8) & 255)))) * 0.003921499941498041f;
                      _3652 = ((float)((uint)((uint)(_3595 & 255)))) * 0.003921499941498041f;
                      _3653 = f16tof32(_3598);
                      _3655 = f16tof32(((uint)((uint)(_3601) >> 16)));
                      _3659 = f16tof32(_3604);
                      _3661 = f16tof32(((uint)((uint)(_3607) >> 16)));
                      _3662 = f16tof32(_3607);
                      _3664 = f16tof32(((uint)((uint)(_3610) >> 16)));
                      _3667 = _3613 & 65535;
                      _3671 = ((_1599 & 4194304) != 0);
                      _3679 = f16tof32(((uint)((uint)(_3622) >> 16)));
                      _3680 = f16tof32(_3622);
                      _3682 = f16tof32(((uint)((uint)(_3631) >> 16)));
                      _3685 = f16tof32(((uint)((uint)(_3634) >> 16)));
                      _3686 = f16tof32(_3634);
                      _3688 = f16tof32(((uint)((uint)(_3637) >> 16)));
                      _3689 = _3688 + -1.0f;
                      if (_3671) {
                        _3691 = 0.5f / _3688;
                        _3692 = 0.3333333432674408f / _3688;
                        _3696 = (_3688 * 0.5f) + 0.5f;
                        _3706 = (_3691 * _3689);
                        _3707 = (_3692 * _3689);
                        _3708 = (_3691 * _3696);
                        _3709 = (_3692 * _3696);
                        _3710 = (_3688 * 2.0f);
                        _3711 = (_3688 * 3.0f);
                      } else {
                        _3702 = 1.0f / _3688;
                        _3703 = _3702 * _3689;
                        _3704 = _3702 * 0.5f;
                        _3706 = _3703;
                        _3707 = _3703;
                        _3708 = _3704;
                        _3709 = _3704;
                        _3710 = _3688;
                        _3711 = _3688;
                      }
                      _3715 = _3582 - _225;
                      _3716 = _3583 - _226;
                      _3717 = _3584 + _224;
                      _3718 = dot(float3(_3715, _3716, _3717), float3(_3715, _3716, _3717));
                      _3719 = rsqrt(_3718);
                      _3720 = _3719 * _3718;
                      _3721 = _3719 * _3715;
                      _3722 = _3719 * _3716;
                      _3723 = _3719 * _3717;
                      _3726 = max(0.0f, (_3720 - abs(_3659)));
                      _3727 = _3726 * f16tof32(((uint)((uint)(_3604) >> 16)));
                      _3728 = _3727 * _3727;
                      _3731 = saturate(1.0f - (_3728 * _3728));
                      _3738 = (_3731 * _3731) / (select((_3659 < 0.0f), (_3728 * 16.0f), (_3726 * _3726)) + 1.0f);
                      _3751 = saturate(1.0f - dot(float3(_187, _188, _189), float3(_3721, _3722, _3723))) * f16tof32(_3631);
                      _3755 = abs(_3717);
                      _3759 = _3715 - ((_3751 * _187) * _3755);
                      _3760 = _3716 - ((_3751 * _188) * _3755);
                      _3761 = _3717 - ((_3751 * _189) * _3755);
                      _3764 = mad(_3761, _3578, mad(_3760, _3573, (_3759 * _3568)));
                      _3767 = mad(_3761, _3579, mad(_3760, _3574, (_3759 * _3569)));
                      _3769 = ((_1599 & 3584) != 0);
                      if (_3769 && (_3738 > 0.0f)) {
                        _3775 = mad(_3761, _3577, mad(_3760, _3572, (_3759 * _3567)));
                        _3776 = -0.0f - _3767;
                        _3777 = -0.0f - _3764;
                        [branch]
                        if (!((_1599 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3613) >> 16))];
                          [branch]
                          if (_3671) {
                            _3782 = abs(_3775);
                            _3783 = abs(_3776);
                            _3784 = abs(_3777);
                            if (_3782 > max(_3783, _3784)) {
                              _3788 = (_3775 > 0.0f);
                              _3803 = select(_3788, 0.0f, 1.0f);
                              _3804 = 0.0f;
                              _3805 = select(_3788, _3764, _3777);
                              _3806 = _3767;
                              _3807 = _3782;
                            } else {
                              if (_3783 > _3784) {
                                _3794 = (_3767 < -0.0f);
                                _3803 = select(_3794, 0.0f, 1.0f);
                                _3804 = 1.0f;
                                _3805 = _3775;
                                _3806 = select(_3794, _3777, _3764);
                                _3807 = _3783;
                              } else {
                                _3798 = (_3764 < -0.0f);
                                _3803 = select(_3798, 0.0f, 1.0f);
                                _3804 = 2.0f;
                                _3805 = select(_3798, _3775, (-0.0f - _3775));
                                _3806 = _3767;
                                _3807 = _3784;
                              }
                            }
                            _3808 = _3807 * 2.0f;
                            _3812 = -0.0f - _3680;
                            _3821 = ((min(max((_3805 / _3808), _3812), _3680) + _3803) * _3706) + _3708;
                            _3822 = ((min(max((_3806 / _3808), _3812), _3680) + _3804) * _3707) + _3709;
                            _3829 = ((_3803 + -0.5f) * _3706) + _3708;
                            _3830 = ((_3804 + -0.5f) * _3707) + _3709;
                            _3833 = saturate((_3682 + 1.0f) - (_3807 * _3664));
                            _3837 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _3846 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_3837 * 32.665000915527344f) + _126), ((_3837 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _3847 = sin(_3846);
                            _3848 = cos(_3846);
                            _3853 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_3821, _3822), 0.0f))).x) > _3833), 1.0f, 0.0f);
                            _3854 = cbSharedPerViewData.nFrameCounter & 3;
                            _3859 = sqrt((float((int)(_3854)) * 0.25f) + 0.125f) * _3685;
                            _3868 = (_global_7[min((uint)(((int)(0u + (_3854 * 2)))), 127u)]) * _3859;
                            _3869 = (_global_7[min((uint)(((int)(1u + (_3854 * 2)))), 127u)]) * _3859;
                            _3871 = -0.0f - _3847;
                            _3873 = dot(float2(_3868, _3869), float2(_3848, _3847)) + _3821;
                            _3874 = dot(float2(_3868, _3869), float2(_3871, _3848)) + _3822;
                            _3876 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3873, _3874));
                            _3880 = _3873 * _3710;
                            _3881 = _3874 * _3711;
                            _3884 = floor(_3829 * _3710);
                            _3885 = floor(_3830 * _3711);
                            _3890 = floor(((_3829 + _3706) * _3710) + 0.5f);
                            _3891 = floor(((_3830 + _3707) * _3711) + 0.5f);
                            _3894 = floor(_3880 + -0.5f);
                            _3895 = floor(_3881 + 0.5f);
                            _3897 = floor(_3880 + 0.5f);
                            _3899 = floor(_3881 + -0.5f);
                            _3900 = (_3894 < _3884);
                            _3901 = (_3895 < _3885);
                            if ((_3900 || _3901) | ((_3894 >= _3890) || (_3895 >= _3891))) {
                              _3910 = _3853;
                            } else {
                              _3910 = _3876.x;
                            }
                            _3911 = (_3897 < _3884);
                            if ((_3911 || _3901) | ((_3897 >= _3890) || (_3895 >= _3891))) {
                              _3919 = _3853;
                            } else {
                              _3919 = _3876.y;
                            }
                            _3920 = (_3899 < _3885);
                            if ((_3911 || _3920) | ((_3897 >= _3890) || (_3899 >= _3891))) {
                              _3928 = _3853;
                            } else {
                              _3928 = _3876.z;
                            }
                            if ((_3900 || _3920) | ((_3894 >= _3890) || (_3899 >= _3891))) {
                              _3936 = _3853;
                            } else {
                              _3936 = _3876.w;
                            }
                            _3937 = _3910 - _3833;
                            _3939 = select((_3937 < 0.0f), 0.0f, 1.0f);
                            _3941 = _3919 - _3833;
                            _3943 = select((_3941 < 0.0f), 0.0f, 1.0f);
                            _3947 = _3928 - _3833;
                            _3949 = select((_3947 < 0.0f), 0.0f, 1.0f);
                            _3953 = _3936 - _3833;
                            _3955 = select((_3953 < 0.0f), 0.0f, 1.0f);
                            _3962 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _3967 = sqrt((float((int)(_3962)) * 0.25f) + 0.125f) * _3685;
                            _3976 = (_global_7[min((uint)(((int)(0u + (_3962 * 2)))), 127u)]) * _3967;
                            _3977 = (_global_7[min((uint)(((int)(1u + (_3962 * 2)))), 127u)]) * _3967;
                            _3980 = dot(float2(_3976, _3977), float2(_3848, _3847)) + _3821;
                            _3981 = dot(float2(_3976, _3977), float2(_3871, _3848)) + _3822;
                            _3983 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3980, _3981));
                            _3987 = _3980 * _3710;
                            _3988 = _3981 * _3711;
                            _3991 = floor(_3987 + -0.5f);
                            _3992 = floor(_3988 + 0.5f);
                            _3994 = floor(_3987 + 0.5f);
                            _3996 = floor(_3988 + -0.5f);
                            _3997 = (_3991 < _3884);
                            _3998 = (_3992 < _3885);
                            if ((_3997 || _3998) | ((_3991 >= _3890) || (_3992 >= _3891))) {
                              _4007 = _3853;
                            } else {
                              _4007 = _3983.x;
                            }
                            _4008 = (_3994 < _3884);
                            if ((_4008 || _3998) | ((_3994 >= _3890) || (_3992 >= _3891))) {
                              _4016 = _3853;
                            } else {
                              _4016 = _3983.y;
                            }
                            _4017 = (_3996 < _3885);
                            if ((_4008 || _4017) | ((_3994 >= _3890) || (_3996 >= _3891))) {
                              _4025 = _3853;
                            } else {
                              _4025 = _3983.z;
                            }
                            if ((_3997 || _4017) | ((_3991 >= _3890) || (_3996 >= _3891))) {
                              _4033 = _3853;
                            } else {
                              _4033 = _3983.w;
                            }
                            _4034 = _4007 - _3833;
                            _4036 = select((_4034 < 0.0f), 0.0f, 1.0f);
                            _4040 = _4016 - _3833;
                            _4042 = select((_4040 < 0.0f), 0.0f, 1.0f);
                            _4046 = _4025 - _3833;
                            _4048 = select((_4046 < 0.0f), 0.0f, 1.0f);
                            _4052 = _4033 - _3833;
                            _4054 = select((_4052 < 0.0f), 0.0f, 1.0f);
                            _4061 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4066 = sqrt((float((int)(_4061)) * 0.25f) + 0.125f) * _3685;
                            _4075 = (_global_7[min((uint)(((int)(0u + (_4061 * 2)))), 127u)]) * _4066;
                            _4076 = (_global_7[min((uint)(((int)(1u + (_4061 * 2)))), 127u)]) * _4066;
                            _4079 = dot(float2(_4075, _4076), float2(_3848, _3847)) + _3821;
                            _4080 = dot(float2(_4075, _4076), float2(_3871, _3848)) + _3822;
                            _4082 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4079, _4080));
                            _4086 = _4079 * _3710;
                            _4087 = _4080 * _3711;
                            _4090 = floor(_4086 + -0.5f);
                            _4091 = floor(_4087 + 0.5f);
                            _4093 = floor(_4086 + 0.5f);
                            _4095 = floor(_4087 + -0.5f);
                            _4096 = (_4090 < _3884);
                            _4097 = (_4091 < _3885);
                            if ((_4096 || _4097) | ((_4090 >= _3890) || (_4091 >= _3891))) {
                              _4106 = _3853;
                            } else {
                              _4106 = _4082.x;
                            }
                            _4107 = (_4093 < _3884);
                            if ((_4107 || _4097) | ((_4093 >= _3890) || (_4091 >= _3891))) {
                              _4115 = _3853;
                            } else {
                              _4115 = _4082.y;
                            }
                            _4116 = (_4095 < _3885);
                            if ((_4107 || _4116) | ((_4093 >= _3890) || (_4095 >= _3891))) {
                              _4124 = _3853;
                            } else {
                              _4124 = _4082.z;
                            }
                            if ((_4096 || _4116) | ((_4090 >= _3890) || (_4095 >= _3891))) {
                              _4132 = _3853;
                            } else {
                              _4132 = _4082.w;
                            }
                            _4133 = _4106 - _3833;
                            _4135 = select((_4133 < 0.0f), 0.0f, 1.0f);
                            _4139 = _4115 - _3833;
                            _4141 = select((_4139 < 0.0f), 0.0f, 1.0f);
                            _4145 = _4124 - _3833;
                            _4147 = select((_4145 < 0.0f), 0.0f, 1.0f);
                            _4151 = _4132 - _3833;
                            _4153 = select((_4151 < 0.0f), 0.0f, 1.0f);
                            _4160 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4165 = sqrt((float((int)(_4160)) * 0.25f) + 0.125f) * _3685;
                            _4174 = (_global_7[min((uint)(((int)(0u + (_4160 * 2)))), 127u)]) * _4165;
                            _4175 = (_global_7[min((uint)(((int)(1u + (_4160 * 2)))), 127u)]) * _4165;
                            _4178 = dot(float2(_4174, _4175), float2(_3848, _3847)) + _3821;
                            _4179 = dot(float2(_4174, _4175), float2(_3871, _3848)) + _3822;
                            _4181 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4178, _4179));
                            _4185 = _4178 * _3710;
                            _4186 = _4179 * _3711;
                            _4189 = floor(_4185 + -0.5f);
                            _4190 = floor(_4186 + 0.5f);
                            _4192 = floor(_4185 + 0.5f);
                            _4194 = floor(_4186 + -0.5f);
                            _4195 = (_4189 < _3884);
                            _4196 = (_4190 < _3885);
                            if ((_4195 || _4196) | ((_4189 >= _3890) || (_4190 >= _3891))) {
                              _4205 = _3853;
                            } else {
                              _4205 = _4181.x;
                            }
                            _4206 = (_4192 < _3884);
                            if ((_4206 || _4196) | ((_4192 >= _3890) || (_4190 >= _3891))) {
                              _4214 = _3853;
                            } else {
                              _4214 = _4181.y;
                            }
                            _4215 = (_4194 < _3885);
                            if ((_4206 || _4215) | ((_4192 >= _3890) || (_4194 >= _3891))) {
                              _4223 = _3853;
                            } else {
                              _4223 = _4181.z;
                            }
                            if ((_4195 || _4215) | ((_4189 >= _3890) || (_4194 >= _3891))) {
                              _4231 = _3853;
                            } else {
                              _4231 = _4181.w;
                            }
                            _4232 = _4205 - _3833;
                            _4234 = select((_4232 < 0.0f), 0.0f, 1.0f);
                            _4238 = _4214 - _3833;
                            _4240 = select((_4238 < 0.0f), 0.0f, 1.0f);
                            _4244 = _4223 - _3833;
                            _4246 = select((_4244 < 0.0f), 0.0f, 1.0f);
                            _4250 = _4231 - _3833;
                            _4252 = select((_4250 < 0.0f), 0.0f, 1.0f);
                            _4253 = ((((((((((((((_3943 + _3939) + _3949) + _3955) + _4036) + _4042) + _4048) + _4054) + _4135) + _4141) + _4147) + _4153) + _4234) + _4240) + _4246) + _4252;
                            _4264 = (saturate(_4253 * 0.0625f) * 2.0f) + -1.0f;
                            _4270 = float((int)(((int)(uint)((int)(_4264 > 0.0f))) - ((int)(uint)((int)(_4264 < 0.0f)))));
                            _4272 = 1.0f - (_4270 * _4264);
                            _4274 = (_4272 * _4272) * _4272;
                            _4566 = (0.5f - ((_4270 * 0.5f) * ((1.0f - _4274) - ((_4272 - _4274) * saturate(((1.0f / _3833) * (1.0f / _4253)) * ((((((((((((((((_3943 * _3941) + (_3939 * _3937)) + (_3949 * _3947)) + (_3955 * _3953)) + (_4036 * _4034)) + (_4042 * _4040)) + (_4048 * _4046)) + (_4054 * _4052)) + (_4135 * _4133)) + (_4141 * _4139)) + (_4147 * _4145)) + (_4153 * _4151)) + (_4234 * _4232)) + (_4240 * _4238)) + (_4246 * _4244)) + (_4252 * _4250)))))));
                            _4567 = 1.0f;
                            _4568 = 1;
                          } else {
                            _4283 = f16tof32(_3640) / _3777;
                            _4286 = mad((_4283 * _3775), 0.5f, 0.5f);
                            _4287 = mad((_4283 * _3776), 0.5f, 0.5f);
                            if (_3764 > -0.0f) {
                              if ((saturate(_4286) == _4286) && (saturate(_4287) == _4287)) {
                                _4301 = (_4286 * _3706) + _3708;
                                _4302 = (_4287 * _3707) + _3709;
                                _4303 = saturate((_3682 + 1.0f) - (_3764 * _3664));
                                _4307 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4316 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_4307 * 32.665000915527344f) + _126), ((_4307 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4317 = sin(_4316);
                                _4318 = cos(_4316);
                                _4319 = cbSharedPerViewData.nFrameCounter & 3;
                                _4324 = sqrt((float((int)(_4319)) * 0.25f) + 0.125f) * _3685;
                                _4333 = (_global_7[min((uint)(((int)(0u + (_4319 * 2)))), 127u)]) * _4324;
                                _4334 = (_global_7[min((uint)(((int)(1u + (_4319 * 2)))), 127u)]) * _4324;
                                _4336 = -0.0f - _4317;
                                _4341 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4333, _4334), float2(_4318, _4317)) + _4301), (dot(float2(_4333, _4334), float2(_4336, _4318)) + _4302)));
                                _4346 = _4341.x - _4303;
                                _4348 = select((_4346 < 0.0f), 0.0f, 1.0f);
                                _4350 = _4341.y - _4303;
                                _4352 = select((_4350 < 0.0f), 0.0f, 1.0f);
                                _4356 = _4341.z - _4303;
                                _4358 = select((_4356 < 0.0f), 0.0f, 1.0f);
                                _4362 = _4341.w - _4303;
                                _4364 = select((_4362 < 0.0f), 0.0f, 1.0f);
                                _4371 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4376 = sqrt((float((int)(_4371)) * 0.25f) + 0.125f) * _3685;
                                _4385 = (_global_7[min((uint)(((int)(0u + (_4371 * 2)))), 127u)]) * _4376;
                                _4386 = (_global_7[min((uint)(((int)(1u + (_4371 * 2)))), 127u)]) * _4376;
                                _4392 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4385, _4386), float2(_4318, _4317)) + _4301), (dot(float2(_4385, _4386), float2(_4336, _4318)) + _4302)));
                                _4397 = _4392.x - _4303;
                                _4399 = select((_4397 < 0.0f), 0.0f, 1.0f);
                                _4403 = _4392.y - _4303;
                                _4405 = select((_4403 < 0.0f), 0.0f, 1.0f);
                                _4409 = _4392.z - _4303;
                                _4411 = select((_4409 < 0.0f), 0.0f, 1.0f);
                                _4415 = _4392.w - _4303;
                                _4417 = select((_4415 < 0.0f), 0.0f, 1.0f);
                                _4424 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _4429 = sqrt((float((int)(_4424)) * 0.25f) + 0.125f) * _3685;
                                _4438 = (_global_7[min((uint)(((int)(0u + (_4424 * 2)))), 127u)]) * _4429;
                                _4439 = (_global_7[min((uint)(((int)(1u + (_4424 * 2)))), 127u)]) * _4429;
                                _4445 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4438, _4439), float2(_4318, _4317)) + _4301), (dot(float2(_4438, _4439), float2(_4336, _4318)) + _4302)));
                                _4450 = _4445.x - _4303;
                                _4452 = select((_4450 < 0.0f), 0.0f, 1.0f);
                                _4456 = _4445.y - _4303;
                                _4458 = select((_4456 < 0.0f), 0.0f, 1.0f);
                                _4462 = _4445.z - _4303;
                                _4464 = select((_4462 < 0.0f), 0.0f, 1.0f);
                                _4468 = _4445.w - _4303;
                                _4470 = select((_4468 < 0.0f), 0.0f, 1.0f);
                                _4477 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _4482 = sqrt((float((int)(_4477)) * 0.25f) + 0.125f) * _3685;
                                _4491 = (_global_7[min((uint)(((int)(0u + (_4477 * 2)))), 127u)]) * _4482;
                                _4492 = (_global_7[min((uint)(((int)(1u + (_4477 * 2)))), 127u)]) * _4482;
                                _4498 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4491, _4492), float2(_4318, _4317)) + _4301), (dot(float2(_4491, _4492), float2(_4336, _4318)) + _4302)));
                                _4503 = _4498.x - _4303;
                                _4505 = select((_4503 < 0.0f), 0.0f, 1.0f);
                                _4509 = _4498.y - _4303;
                                _4511 = select((_4509 < 0.0f), 0.0f, 1.0f);
                                _4515 = _4498.z - _4303;
                                _4517 = select((_4515 < 0.0f), 0.0f, 1.0f);
                                _4521 = _4498.w - _4303;
                                _4523 = select((_4521 < 0.0f), 0.0f, 1.0f);
                                _4524 = ((((((((((((((_4348 + _4352) + _4358) + _4364) + _4399) + _4405) + _4411) + _4417) + _4452) + _4458) + _4464) + _4470) + _4505) + _4511) + _4517) + _4523;
                                _4535 = (saturate(_4524 * 0.0625f) * 2.0f) + -1.0f;
                                _4541 = float((int)(((int)(uint)((int)(_4535 > 0.0f))) - ((int)(uint)((int)(_4535 < 0.0f)))));
                                _4543 = 1.0f - (_4541 * _4535);
                                _4545 = (_4543 * _4543) * _4543;
                                _4553 = -0.0f - _3775;
                                _4560 = saturate((saturate(rsqrt(dot(float3(_4553, _3767, _3764), float3(_4553, _3767, _3764))) * _3764) * _3662) + _3661);
                                _4562 = 1.0f - (_4560 * _4560);
                                _4566 = (0.5f - ((_4541 * 0.5f) * ((1.0f - _4545) - ((_4543 - _4545) * saturate(((1.0f / _4303) * (1.0f / _4524)) * ((((((((((((((((_4348 * _4346) + (_4352 * _4350)) + (_4358 * _4356)) + (_4364 * _4362)) + (_4399 * _4397)) + (_4405 * _4403)) + (_4411 * _4409)) + (_4417 * _4415)) + (_4452 * _4450)) + (_4458 * _4456)) + (_4464 * _4462)) + (_4470 * _4468)) + (_4505 * _4503)) + (_4511 * _4509)) + (_4517 * _4515)) + (_4523 * _4521)))))));
                                _4567 = (1.0f - (_4562 * _4562));
                                _4568 = 1;
                              } else {
                                _4566 = 1.0f;
                                _4567 = 1.0f;
                                _4568 = 0;
                              }
                            } else {
                              _4566 = 1.0f;
                              _4567 = 1.0f;
                              _4568 = 0;
                            }
                          }
                        } else {
                          _4566 = 1.0f;
                          _4567 = 1.0f;
                          _4568 = 0;
                        }
                        [branch]
                        if (!((_1599 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1599 & 2097152) == 0)) {
                            _4576 = abs(_3775);
                            _4577 = abs(_3776);
                            _4578 = abs(_3777);
                            if (_4576 > max(_4577, _4578)) {
                              _4582 = (_3775 > 0.0f);
                              _4597 = select(_4582, 0.0f, 1.0f);
                              _4598 = 0.0f;
                              _4599 = select(_4582, _3764, _3777);
                              _4600 = _3767;
                              _4601 = _4576;
                            } else {
                              if (_4577 > _4578) {
                                _4588 = (_3767 < -0.0f);
                                _4597 = select(_4588, 0.0f, 1.0f);
                                _4598 = 1.0f;
                                _4599 = _3775;
                                _4600 = select(_4588, _3777, _3764);
                                _4601 = _4577;
                              } else {
                                _4592 = (_3764 < -0.0f);
                                _4597 = select(_4592, 0.0f, 1.0f);
                                _4598 = 2.0f;
                                _4599 = select(_4592, _3775, (-0.0f - _3775));
                                _4600 = _3767;
                                _4601 = _4578;
                              }
                            }
                            _4602 = _4601 * 2.0f;
                            _4607 = -0.0f - _3679;
                            _4616 = ((min(max((_4599 / _4602), _4607), _3679) + _4597) * _3625) + _3627;
                            _4617 = ((min(max((_4600 / _4602), _4607), _3679) + _4598) * _3626) + _3628;
                            _4622 = ((_4597 + -0.5f) * _3625) + _3627;
                            _4623 = ((_4598 + -0.5f) * _3626) + _3628;
                            _4626 = saturate(1.0f - (_4601 * _3664));
                            _4630 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4639 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_4630 * 32.665000915527344f) + _126), ((_4630 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4640 = sin(_4639);
                            _4641 = cos(_4639);
                            _4646 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4616, _4617), 0.0f))).x) > _4626), 1.0f, 0.0f);
                            _4647 = cbSharedPerViewData.nFrameCounter & 3;
                            _4652 = sqrt((float((int)(_4647)) * 0.25f) + 0.125f) * _3686;
                            _4661 = (_global_7[min((uint)(((int)(0u + (_4647 * 2)))), 127u)]) * _4652;
                            _4662 = (_global_7[min((uint)(((int)(1u + (_4647 * 2)))), 127u)]) * _4652;
                            _4664 = -0.0f - _4640;
                            _4666 = dot(float2(_4661, _4662), float2(_4641, _4640)) + _4616;
                            _4667 = dot(float2(_4661, _4662), float2(_4664, _4641)) + _4617;
                            _4669 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4666, _4667));
                            _4673 = _4666 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4674 = _4667 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4677 = floor(_4622 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _4678 = floor(_4623 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _4683 = floor(((_4622 + _3625) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _4684 = floor(((_4623 + _3626) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _4687 = floor(_4673 + -0.5f);
                            _4688 = floor(_4674 + 0.5f);
                            _4690 = floor(_4673 + 0.5f);
                            _4692 = floor(_4674 + -0.5f);
                            _4693 = (_4687 < _4677);
                            _4694 = (_4688 < _4678);
                            if ((_4693 || _4694) | ((_4687 >= _4683) || (_4688 >= _4684))) {
                              _4703 = _4646;
                            } else {
                              _4703 = _4669.x;
                            }
                            _4704 = (_4690 < _4677);
                            if ((_4704 || _4694) | ((_4690 >= _4683) || (_4688 >= _4684))) {
                              _4712 = _4646;
                            } else {
                              _4712 = _4669.y;
                            }
                            _4713 = (_4692 < _4678);
                            if ((_4704 || _4713) | ((_4690 >= _4683) || (_4692 >= _4684))) {
                              _4721 = _4646;
                            } else {
                              _4721 = _4669.z;
                            }
                            if ((_4693 || _4713) | ((_4687 >= _4683) || (_4692 >= _4684))) {
                              _4729 = _4646;
                            } else {
                              _4729 = _4669.w;
                            }
                            _4730 = _4703 - _4626;
                            _4732 = select((_4730 < 0.0f), 0.0f, 1.0f);
                            _4734 = _4712 - _4626;
                            _4736 = select((_4734 < 0.0f), 0.0f, 1.0f);
                            _4740 = _4721 - _4626;
                            _4742 = select((_4740 < 0.0f), 0.0f, 1.0f);
                            _4746 = _4729 - _4626;
                            _4748 = select((_4746 < 0.0f), 0.0f, 1.0f);
                            _4755 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _4760 = sqrt((float((int)(_4755)) * 0.25f) + 0.125f) * _3686;
                            _4769 = (_global_7[min((uint)(((int)(0u + (_4755 * 2)))), 127u)]) * _4760;
                            _4770 = (_global_7[min((uint)(((int)(1u + (_4755 * 2)))), 127u)]) * _4760;
                            _4773 = dot(float2(_4769, _4770), float2(_4641, _4640)) + _4616;
                            _4774 = dot(float2(_4769, _4770), float2(_4664, _4641)) + _4617;
                            _4776 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4773, _4774));
                            _4780 = _4773 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4781 = _4774 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4784 = floor(_4780 + -0.5f);
                            _4785 = floor(_4781 + 0.5f);
                            _4787 = floor(_4780 + 0.5f);
                            _4789 = floor(_4781 + -0.5f);
                            _4790 = (_4784 < _4677);
                            _4791 = (_4785 < _4678);
                            if ((_4790 || _4791) | ((_4784 >= _4683) || (_4785 >= _4684))) {
                              _4800 = _4646;
                            } else {
                              _4800 = _4776.x;
                            }
                            _4801 = (_4787 < _4677);
                            if ((_4801 || _4791) | ((_4787 >= _4683) || (_4785 >= _4684))) {
                              _4809 = _4646;
                            } else {
                              _4809 = _4776.y;
                            }
                            _4810 = (_4789 < _4678);
                            if ((_4801 || _4810) | ((_4787 >= _4683) || (_4789 >= _4684))) {
                              _4818 = _4646;
                            } else {
                              _4818 = _4776.z;
                            }
                            if ((_4790 || _4810) | ((_4784 >= _4683) || (_4789 >= _4684))) {
                              _4826 = _4646;
                            } else {
                              _4826 = _4776.w;
                            }
                            _4827 = _4800 - _4626;
                            _4829 = select((_4827 < 0.0f), 0.0f, 1.0f);
                            _4833 = _4809 - _4626;
                            _4835 = select((_4833 < 0.0f), 0.0f, 1.0f);
                            _4839 = _4818 - _4626;
                            _4841 = select((_4839 < 0.0f), 0.0f, 1.0f);
                            _4845 = _4826 - _4626;
                            _4847 = select((_4845 < 0.0f), 0.0f, 1.0f);
                            _4854 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4859 = sqrt((float((int)(_4854)) * 0.25f) + 0.125f) * _3686;
                            _4868 = (_global_7[min((uint)(((int)(0u + (_4854 * 2)))), 127u)]) * _4859;
                            _4869 = (_global_7[min((uint)(((int)(1u + (_4854 * 2)))), 127u)]) * _4859;
                            _4872 = dot(float2(_4868, _4869), float2(_4641, _4640)) + _4616;
                            _4873 = dot(float2(_4868, _4869), float2(_4664, _4641)) + _4617;
                            _4875 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4872, _4873));
                            _4879 = _4872 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4880 = _4873 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4883 = floor(_4879 + -0.5f);
                            _4884 = floor(_4880 + 0.5f);
                            _4886 = floor(_4879 + 0.5f);
                            _4888 = floor(_4880 + -0.5f);
                            _4889 = (_4883 < _4677);
                            _4890 = (_4884 < _4678);
                            if ((_4889 || _4890) | ((_4883 >= _4683) || (_4884 >= _4684))) {
                              _4899 = _4646;
                            } else {
                              _4899 = _4875.x;
                            }
                            _4900 = (_4886 < _4677);
                            if ((_4900 || _4890) | ((_4886 >= _4683) || (_4884 >= _4684))) {
                              _4908 = _4646;
                            } else {
                              _4908 = _4875.y;
                            }
                            _4909 = (_4888 < _4678);
                            if ((_4900 || _4909) | ((_4886 >= _4683) || (_4888 >= _4684))) {
                              _4917 = _4646;
                            } else {
                              _4917 = _4875.z;
                            }
                            if ((_4889 || _4909) | ((_4883 >= _4683) || (_4888 >= _4684))) {
                              _4925 = _4646;
                            } else {
                              _4925 = _4875.w;
                            }
                            _4926 = _4899 - _4626;
                            _4928 = select((_4926 < 0.0f), 0.0f, 1.0f);
                            _4932 = _4908 - _4626;
                            _4934 = select((_4932 < 0.0f), 0.0f, 1.0f);
                            _4938 = _4917 - _4626;
                            _4940 = select((_4938 < 0.0f), 0.0f, 1.0f);
                            _4944 = _4925 - _4626;
                            _4946 = select((_4944 < 0.0f), 0.0f, 1.0f);
                            _4953 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4958 = sqrt((float((int)(_4953)) * 0.25f) + 0.125f) * _3686;
                            _4967 = (_global_7[min((uint)(((int)(0u + (_4953 * 2)))), 127u)]) * _4958;
                            _4968 = (_global_7[min((uint)(((int)(1u + (_4953 * 2)))), 127u)]) * _4958;
                            _4971 = dot(float2(_4967, _4968), float2(_4641, _4640)) + _4616;
                            _4972 = dot(float2(_4967, _4968), float2(_4664, _4641)) + _4617;
                            _4974 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4971, _4972));
                            _4978 = _4971 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4979 = _4972 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4982 = floor(_4978 + -0.5f);
                            _4983 = floor(_4979 + 0.5f);
                            _4985 = floor(_4978 + 0.5f);
                            _4987 = floor(_4979 + -0.5f);
                            _4988 = (_4982 < _4677);
                            _4989 = (_4983 < _4678);
                            if ((_4988 || _4989) | ((_4982 >= _4683) || (_4983 >= _4684))) {
                              _4998 = _4646;
                            } else {
                              _4998 = _4974.x;
                            }
                            _4999 = (_4985 < _4677);
                            if ((_4999 || _4989) | ((_4985 >= _4683) || (_4983 >= _4684))) {
                              _5007 = _4646;
                            } else {
                              _5007 = _4974.y;
                            }
                            _5008 = (_4987 < _4678);
                            if ((_4999 || _5008) | ((_4985 >= _4683) || (_4987 >= _4684))) {
                              _5016 = _4646;
                            } else {
                              _5016 = _4974.z;
                            }
                            if ((_4988 || _5008) | ((_4982 >= _4683) || (_4987 >= _4684))) {
                              _5024 = _4646;
                            } else {
                              _5024 = _4974.w;
                            }
                            _5025 = _4998 - _4626;
                            _5027 = select((_5025 < 0.0f), 0.0f, 1.0f);
                            _5031 = _5007 - _4626;
                            _5033 = select((_5031 < 0.0f), 0.0f, 1.0f);
                            _5037 = _5016 - _4626;
                            _5039 = select((_5037 < 0.0f), 0.0f, 1.0f);
                            _5043 = _5024 - _4626;
                            _5045 = select((_5043 < 0.0f), 0.0f, 1.0f);
                            _5046 = ((((((((((((((_4736 + _4732) + _4742) + _4748) + _4829) + _4835) + _4841) + _4847) + _4928) + _4934) + _4940) + _4946) + _5027) + _5033) + _5039) + _5045;
                            _5057 = (saturate(_5046 * 0.0625f) * 2.0f) + -1.0f;
                            _5063 = float((int)(((int)(uint)((int)(_5057 > 0.0f))) - ((int)(uint)((int)(_5057 < 0.0f)))));
                            _5065 = 1.0f - (_5063 * _5057);
                            _5067 = (_5065 * _5065) * _5065;
                            _5358 = (0.5f - ((_5063 * 0.5f) * ((1.0f - _5067) - ((_5065 - _5067) * saturate(((1.0f / _4626) * (1.0f / _5046)) * ((((((((((((((((_4736 * _4734) + (_4732 * _4730)) + (_4742 * _4740)) + (_4748 * _4746)) + (_4829 * _4827)) + (_4835 * _4833)) + (_4841 * _4839)) + (_4847 * _4845)) + (_4928 * _4926)) + (_4934 * _4932)) + (_4940 * _4938)) + (_4946 * _4944)) + (_5027 * _5025)) + (_5033 * _5031)) + (_5039 * _5037)) + (_5045 * _5043)))))));
                            _5359 = 1.0f;
                            _5360 = false;
                          } else {
                            _5076 = f16tof32(((uint)((uint)(_3640) >> 16))) / _3777;
                            _5079 = mad((_5076 * _3775), 0.5f, 0.5f);
                            _5080 = mad((_5076 * _3776), 0.5f, 0.5f);
                            if (_3764 > -0.0f) {
                              if ((saturate(_5079) == _5079) && (saturate(_5080) == _5080)) {
                                _5093 = (_5079 * _3625) + _3627;
                                _5094 = (_5080 * _3626) + _3628;
                                _5095 = saturate(1.0f - (_3764 * _3664));
                                _5099 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _5108 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_5099 * 32.665000915527344f) + _126), ((_5099 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _5109 = sin(_5108);
                                _5110 = cos(_5108);
                                _5111 = cbSharedPerViewData.nFrameCounter & 3;
                                _5116 = sqrt((float((int)(_5111)) * 0.25f) + 0.125f) * _3686;
                                _5125 = (_global_7[min((uint)(((int)(0u + (_5111 * 2)))), 127u)]) * _5116;
                                _5126 = (_global_7[min((uint)(((int)(1u + (_5111 * 2)))), 127u)]) * _5116;
                                _5128 = -0.0f - _5109;
                                _5133 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5125, _5126), float2(_5110, _5109)) + _5093), (dot(float2(_5125, _5126), float2(_5128, _5110)) + _5094)));
                                _5138 = _5133.x - _5095;
                                _5140 = select((_5138 < 0.0f), 0.0f, 1.0f);
                                _5142 = _5133.y - _5095;
                                _5144 = select((_5142 < 0.0f), 0.0f, 1.0f);
                                _5148 = _5133.z - _5095;
                                _5150 = select((_5148 < 0.0f), 0.0f, 1.0f);
                                _5154 = _5133.w - _5095;
                                _5156 = select((_5154 < 0.0f), 0.0f, 1.0f);
                                _5163 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _5168 = sqrt((float((int)(_5163)) * 0.25f) + 0.125f) * _3686;
                                _5177 = (_global_7[min((uint)(((int)(0u + (_5163 * 2)))), 127u)]) * _5168;
                                _5178 = (_global_7[min((uint)(((int)(1u + (_5163 * 2)))), 127u)]) * _5168;
                                _5184 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5177, _5178), float2(_5110, _5109)) + _5093), (dot(float2(_5177, _5178), float2(_5128, _5110)) + _5094)));
                                _5189 = _5184.x - _5095;
                                _5191 = select((_5189 < 0.0f), 0.0f, 1.0f);
                                _5195 = _5184.y - _5095;
                                _5197 = select((_5195 < 0.0f), 0.0f, 1.0f);
                                _5201 = _5184.z - _5095;
                                _5203 = select((_5201 < 0.0f), 0.0f, 1.0f);
                                _5207 = _5184.w - _5095;
                                _5209 = select((_5207 < 0.0f), 0.0f, 1.0f);
                                _5216 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _5221 = sqrt((float((int)(_5216)) * 0.25f) + 0.125f) * _3686;
                                _5230 = (_global_7[min((uint)(((int)(0u + (_5216 * 2)))), 127u)]) * _5221;
                                _5231 = (_global_7[min((uint)(((int)(1u + (_5216 * 2)))), 127u)]) * _5221;
                                _5237 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5230, _5231), float2(_5110, _5109)) + _5093), (dot(float2(_5230, _5231), float2(_5128, _5110)) + _5094)));
                                _5242 = _5237.x - _5095;
                                _5244 = select((_5242 < 0.0f), 0.0f, 1.0f);
                                _5248 = _5237.y - _5095;
                                _5250 = select((_5248 < 0.0f), 0.0f, 1.0f);
                                _5254 = _5237.z - _5095;
                                _5256 = select((_5254 < 0.0f), 0.0f, 1.0f);
                                _5260 = _5237.w - _5095;
                                _5262 = select((_5260 < 0.0f), 0.0f, 1.0f);
                                _5269 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _5274 = sqrt((float((int)(_5269)) * 0.25f) + 0.125f) * _3686;
                                _5283 = (_global_7[min((uint)(((int)(0u + (_5269 * 2)))), 127u)]) * _5274;
                                _5284 = (_global_7[min((uint)(((int)(1u + (_5269 * 2)))), 127u)]) * _5274;
                                _5290 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5283, _5284), float2(_5110, _5109)) + _5093), (dot(float2(_5283, _5284), float2(_5128, _5110)) + _5094)));
                                _5295 = _5290.x - _5095;
                                _5297 = select((_5295 < 0.0f), 0.0f, 1.0f);
                                _5301 = _5290.y - _5095;
                                _5303 = select((_5301 < 0.0f), 0.0f, 1.0f);
                                _5307 = _5290.z - _5095;
                                _5309 = select((_5307 < 0.0f), 0.0f, 1.0f);
                                _5313 = _5290.w - _5095;
                                _5315 = select((_5313 < 0.0f), 0.0f, 1.0f);
                                _5316 = ((((((((((((((_5140 + _5144) + _5150) + _5156) + _5191) + _5197) + _5203) + _5209) + _5244) + _5250) + _5256) + _5262) + _5297) + _5303) + _5309) + _5315;
                                _5327 = (saturate(_5316 * 0.0625f) * 2.0f) + -1.0f;
                                _5333 = float((int)(((int)(uint)((int)(_5327 > 0.0f))) - ((int)(uint)((int)(_5327 < 0.0f)))));
                                _5335 = 1.0f - (_5333 * _5327);
                                _5337 = (_5335 * _5335) * _5335;
                                _5345 = -0.0f - _3775;
                                _5352 = saturate((saturate(rsqrt(dot(float3(_5345, _3767, _3764), float3(_5345, _3767, _3764))) * _3764) * _3662) + _3661);
                                _5354 = 1.0f - (_5352 * _5352);
                                _5358 = (0.5f - ((_5333 * 0.5f) * ((1.0f - _5337) - ((_5335 - _5337) * saturate(((1.0f / _5095) * (1.0f / _5316)) * ((((((((((((((((_5140 * _5138) + (_5144 * _5142)) + (_5150 * _5148)) + (_5156 * _5154)) + (_5191 * _5189)) + (_5197 * _5195)) + (_5203 * _5201)) + (_5209 * _5207)) + (_5244 * _5242)) + (_5250 * _5248)) + (_5256 * _5254)) + (_5262 * _5260)) + (_5297 * _5295)) + (_5303 * _5301)) + (_5309 * _5307)) + (_5315 * _5313)))))));
                                _5359 = (1.0f - (_5354 * _5354));
                                _5360 = false;
                              } else {
                                _5358 = 1.0f;
                                _5359 = 1.0f;
                                _5360 = true;
                              }
                            } else {
                              _5358 = 1.0f;
                              _5359 = 1.0f;
                              _5360 = true;
                            }
                          }
                        } else {
                          _5358 = 1.0f;
                          _5359 = 1.0f;
                          _5360 = true;
                        }
                        if (_4568 == 0) {
                          if (!_5360) {
                            _5375 = _4566;
                            _5376 = ((_5359 * (_5358 + -1.0f)) + 1.0f);
                            _5377 = 0.0f;
                          } else {
                            _5375 = _4566;
                            _5376 = _5358;
                            _5377 = 0.0f;
                          }
                        } else {
                          if (_5360) {
                            _5375 = ((_4567 * (_4566 + -1.0f)) + 1.0f);
                            _5376 = _5358;
                            _5377 = 1.0f;
                          } else {
                            _5375 = _4566;
                            _5376 = _5358;
                            _5377 = (_4567 * f16tof32(_3610));
                          }
                        }
                        _5380 = (_5377 * (_5375 - _5376)) + _5376;
                        [branch]
                        if (!((_1599 & 2048) == 0)) {
                          _5382 = _225 - _3582;
                          _5383 = _226 - _3583;
                          _5384 = _227 - _3584;
                          _5399 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5384, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5383, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5382)));
                          _5402 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _5384, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _5383, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _5382)));
                          _5405 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _5384, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _5383, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _5382)));
                          _5407 = rsqrt(dot(float3(_5399, _5402, _5405), float3(_5399, _5402, _5405)));
                          _5408 = _5407 * _5399;
                          _5409 = _5407 * _5402;
                          _5410 = _5407 * _5405;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3616) >> 16))];
                          _5418 = (abs(_5409) + abs(_5408)) + abs(_5410);
                          _5419 = _5408 / _5418;
                          _5420 = _5409 / _5418;
                          _5422 = !((_5410 / _5418) >= 0.0f);
                          if (_5422) {
                            _5435 = ((1.0f - abs(_5420)) * select((_5419 >= 0.0f), 1.0f, -1.0f));
                            _5436 = ((1.0f - abs(_5419)) * select((_5420 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _5435 = _5419;
                            _5436 = _5420;
                          }
                          _5442 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5435 * 0.5f) + 0.5f), ((_5436 * 0.5f) + 0.5f)), 0.0f);
                          if (_5442.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3616 & 65535))];
                            if (_5422) {
                              _5461 = ((1.0f - abs(_5420)) * select((_5419 >= 0.0f), 1.0f, -1.0f));
                              _5462 = ((1.0f - abs(_5419)) * select((_5420 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _5461 = _5419;
                              _5462 = _5420;
                            }
                            _5467 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5461 * 0.5f) + 0.5f), ((_5462 * 0.5f) + 0.5f)), 0.0f);
                            _5487 = mad(saturate(((log2(sqrt(((_5382 * _5382) + (_5383 * _5383)) + (_5384 * _5384))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _5488 = max(9.999999747378752e-06f, _5442.x);
                            _5489 = _5467.x / _5488;
                            _5490 = _5467.y / _5488;
                            _5492 = _5467.w / _5488;
                            _5497 = ((0.375f - _5490) * 4.999999873689376e-06f) + _5490;
                            _5500 = -0.0f - _5489;
                            _5501 = mad(_5500, _5497, (_5467.z / _5488));
                            _5503 = 1.0f / mad(_5500, _5489, _5497);
                            _5504 = _5503 * _5501;
                            _5509 = _5487 - _5489;
                            _5514 = (((_5487 * _5487) - _5497) - (_5504 * _5509)) / mad((-0.0f - _5501), _5504, mad((-0.0f - _5497), _5497, (((0.375f - _5492) * 4.999999873689376e-06f) + _5492)));
                            _5516 = (_5503 * _5509) - (_5514 * _5504);
                            _5519 = 1.0f / _5514;
                            _5520 = _5516 * _5519;
                            _5525 = sqrt(((_5520 * _5520) * 0.25f) - ((1.0f - dot(float2(_5516, _5514), float2(_5489, _5497))) * _5519));
                            _5527 = (_5520 * -0.5f) - _5525;
                            _5529 = _5525 - (_5520 * 0.5f);
                            _5531 = select((_5527 < _5487), 1.0f, 0.0f);
                            _5536 = (_5531 + -0.05000000074505806f) / (_5527 - _5487);
                            _5542 = (((select((_5529 < _5487), 1.0f, 0.0f) - _5531) / (_5529 - _5527)) - _5536) / (_5529 - _5487);
                            _5544 = _5536 - (_5542 * _5527);
                            _5557 = (exp2((_5442.x * -1.4426950216293335f) * saturate((dot(float2(_5489, _5497), float2((_5544 - (_5542 * _5487)), _5542)) + 0.05000000074505806f) - (_5544 * _5487))) * _5380);
                          } else {
                            _5557 = _5380;
                          }
                        } else {
                          _5557 = _5380;
                        }
                        _5560 = (_5557 * _3738);
                        _5561 = _5557;
                      } else {
                        _5560 = _3738;
                        _5561 = 1.0f;
                      }
                      [branch]
                      if (!(_3667 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3667)))];
                        _5573 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3717, _3577, mad(_3716, _3572, (_3715 * _3567)))), (-0.0f - mad(_3717, _3578, mad(_3716, _3573, (_3715 * _3568)))), (-0.0f - mad(_3717, _3579, mad(_3716, _3574, (_3715 * _3569))))), 0.0f);
                        _5581 = (_5573.x * _3642);
                        _5582 = (_5573.y * _3643);
                        _5583 = (_5573.z * _3645);
                      } else {
                        _5581 = _3642;
                        _5582 = _3643;
                        _5583 = _3645;
                      }
                      [branch]
                      if (!(_5560 == 0.0f)) {
                        bool __branch_chain_5585;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _5601 = 0;
                          __branch_chain_5585 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _5601 = 1;
                            __branch_chain_5585 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _5601 = 2;
                              __branch_chain_5585 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _5601 = 3;
                                __branch_chain_5585 = true;
                              } else {
                                _5622 = _5560;
                                __branch_chain_5585 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_5585) {
                          while(true) {
                            _5604 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_64, _65, 0));
                            if (_5601 == 0) {
                              _5618 = _5604.x;
                            } else {
                              if (_5601 == 1) {
                                _5618 = _5604.y;
                              } else {
                                if (_5601 == 2) {
                                  _5618 = _5604.z;
                                } else {
                                  _5618 = _5604.w;
                                }
                              }
                            }
                            _5622 = ((_5618 * _5618) * _3738);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_5622 == 0.0f)) {
                            [branch]
                            if (!(((_3619 & 1) == 0) || (!_3769))) {
                              _5639 = max(max(_5581, _5582), _5583);
                              if (_5639 > 0.0f) {
                                _5649 = saturate(_5581 / _5639);
                                _5650 = saturate(_5582 / _5639);
                                _5651 = saturate(_5583 / _5639);
                              } else {
                                _5649 = _5581;
                                _5650 = _5582;
                                _5651 = _5583;
                              }
                              _5652 = (_5650 < _5651);
                              _5653 = select(_5652, _5651, _5650);
                              _5654 = select(_5652, _5650, _5651);
                              _5655 = select(_5652, -1.0f, 0.0f);
                              _5656 = (_5649 < _5653);
                              _5658 = select(_5656, _5653, _5649);
                              _5659 = select(_5656, _5649, _5653);
                              _5663 = _5658 - select((_5659 < _5654), _5659, _5654);
                              _5669 = abs(select(_5656, (-0.3333333432674408f - _5655), _5655) + ((_5659 - _5654) / ((_5663 * 6.0f) + 9.999999682655225e-21f)));
                              if (_5669 < 0.6666666865348816f) {
                                _5682 = ((saturate(((float)((uint)((uint)(((uint)(_3619) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5669 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5669)) + _5669);
                              } else {
                                _5682 = _5669;
                              }
                              _5683 = saturate((_5663 / (_5658 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3619) >> 1) & 255)))) * 0.003921499941498041f));
                              _5684 = saturate(_5658);
                              if (!(_5683 <= 0.0f)) {
                                _5687 = saturate(_5682);
                                _5691 = select(((_5687 * 360.0f) >= 360.0f), 0.0f, (_5687 * 6.0f));
                                _5692 = int(_5691);
                                _5694 = _5691 - float((int)(_5692));
                                _5696 = _5684 * (1.0f - _5683);
                                _5699 = (1.0f - (_5694 * _5683)) * _5684;
                                _5703 = (1.0f - ((1.0f - _5694) * _5683)) * _5684;
                                switch (_5692) {
                                  case 0: {
                                    _5711 = _5684;
                                    _5712 = _5703;
                                    _5713 = _5696;
                                    break;
                                  }
                                  case 1: {
                                    _5711 = _5699;
                                    _5712 = _5684;
                                    _5713 = _5696;
                                    break;
                                  }
                                  case 2: {
                                    _5711 = _5696;
                                    _5712 = _5684;
                                    _5713 = _5703;
                                    break;
                                  }
                                  case 3: {
                                    _5711 = _5696;
                                    _5712 = _5699;
                                    _5713 = _5684;
                                    break;
                                  }
                                  case 4: {
                                    _5711 = _5703;
                                    _5712 = _5696;
                                    _5713 = _5684;
                                    break;
                                  }
                                  case 5: {
                                    _5711 = _5684;
                                    _5712 = _5696;
                                    _5713 = _5699;
                                    break;
                                  }
                                  default: {
                                    _5711 = 0.0f;
                                    _5712 = 0.0f;
                                    _5713 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _5711 = _5684;
                                _5712 = _5684;
                                _5713 = _5684;
                              }
                              _5714 = _5711 * _5639;
                              _5715 = _5712 * _5639;
                              _5716 = _5713 * _5639;
                              _5718 = saturate(_5561 * 1.0101009607315063f);
                              _5729 = ((_5718 * (_5581 - _5714)) + _5714);
                              _5730 = ((_5718 * (_5582 - _5715)) + _5715);
                              _5731 = (lerp(_5716, _5583, _5718));
                            } else {
                              _5729 = _5581;
                              _5730 = _5582;
                              _5731 = _5583;
                            }
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _5738 = srvLightMappingData[_1602];
                              if (!(_5738 == -1)) {
                                _5743 = srvLightIndexData[_5738].nLayerIndex;
                                _5745 = srvLightIndexData[_5738].vAtlasOrigin.x;
                                _5746 = srvLightIndexData[_5738].vAtlasOrigin.y;
                                _5748 = srvLightIndexData[_5738].vScreenOrigin.x;
                                _5749 = srvLightIndexData[_5738].vScreenOrigin.y;
                                _5758 = ((int)(_5743 * 5)) & 31;
                                _5767 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5745 + _64) - _5748)), ((int)((_5746 + _65) - _5749)), 0)))).x) & ((int)(31 << _5758)))) >> _5758)) >> 1)))) * 0.06666667014360428f) * _5622);
                              } else {
                                _5767 = _5622;
                              }
                            } else {
                              _5767 = _5622;
                            }
                            _5771 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _5774 = select(_5771, (_5767 * _1273), _5767);
                            _5776 = _3721 * _3720;
                            _5777 = _3722 * _3720;
                            _5778 = _3723 * _3720;
                            _5779 = _3653 * _3587;
                            _5780 = _3653 * _3588;
                            _5781 = _3653 * _3589;
                            _5782 = _5776 + _5779;
                            _5783 = _5777 + _5780;
                            _5784 = _5778 + _5781;
                            _5785 = _5776 - _5779;
                            _5786 = _5777 - _5780;
                            _5787 = _5778 - _5781;
                            _5788 = (_3653 > 0.0f);
                            _5789 = dot(float3(_5782, _5783, _5784), float3(_5782, _5783, _5784));
                            _5790 = rsqrt(_5789);
                            [branch]
                            if (_5788) {
                              _5793 = rsqrt(dot(float3(_5785, _5786, _5787), float3(_5785, _5786, _5787)));
                              _5794 = _5793 * _5790;
                              _5796 = dot(float3(_5782, _5783, _5784), float3(_5785, _5786, _5787)) * _5794;
                              _5815 = (_5794 / ((_5794 + 0.5f) + (_5796 * 0.5f)));
                              _5816 = (((dot(float3(_187, _188, _189), float3(_5785, _5786, _5787)) * _5793) + (dot(float3(_187, _188, _189), float3(_5782, _5783, _5784)) * _5790)) * 0.5f);
                              _5817 = _5796;
                            } else {
                              _5815 = (1.0f / (_5789 + 1.0f));
                              _5816 = dot(float3(_187, _188, _189), float3((_5790 * _5782), (_5790 * _5783), (_5790 * _5784)));
                              _5817 = 1.0f;
                            }
                            if (_3655 > 0.0f) {
                              _5823 = sqrt(saturate((_3655 * _3655) * _5815));
                              if (_5816 < _5823) {
                                _5828 = max(_5816, (-0.0f - _5823)) + _5823;
                                _5833 = ((_5828 * _5828) / (_5823 * 4.0f));
                              } else {
                                _5833 = _5816;
                              }
                            } else {
                              _5833 = _5816;
                            }
                            if (_5788) {
                              _5835 = -0.0f - _444;
                              _5836 = -0.0f - _445;
                              _5837 = -0.0f - _443;
                              _5839 = dot(float3(_5835, _5836, _5837), float3(_187, _188, _189)) * 2.0f;
                              _5843 = _5835 - (_5839 * _187);
                              _5844 = _5836 - (_5839 * _188);
                              _5845 = _5837 - (_5839 * _189);
                              _5846 = _5785 - _5782;
                              _5847 = _5786 - _5783;
                              _5848 = _5787 - _5784;
                              _5849 = dot(float3(_5843, _5844, _5845), float3(_5846, _5847, _5848));
                              _5855 = sqrt(((_5846 * _5846) + (_5847 * _5847)) + (_5848 * _5848));
                              _5864 = saturate(((dot(float3(_5843, _5844, _5845), float3(_5782, _5783, _5784)) * _5849) - dot(float3(_5782, _5783, _5784), float3(_5846, _5847, _5848))) / ((_5855 * _5855) - (_5849 * _5849)));
                              _5868 = (_5864 * _5846) + _5782;
                              _5869 = (_5864 * _5847) + _5783;
                              _5870 = (_5864 * _5848) + _5784;
                              _5871 = dot(float3(_5868, _5869, _5870), float3(_5843, _5844, _5845));
                              _5875 = (_5871 * _5843) - _5868;
                              _5876 = (_5871 * _5844) - _5869;
                              _5877 = (_5871 * _5845) - _5870;
                              _5885 = saturate(0.009999999776482582f / sqrt(((_5875 * _5875) + (_5876 * _5876)) + (_5877 * _5877)));
                              _5893 = ((_5885 * _5875) + _5868);
                              _5894 = ((_5885 * _5876) + _5869);
                              _5895 = ((_5885 * _5877) + _5870);
                            } else {
                              _5893 = _5782;
                              _5894 = _5783;
                              _5895 = _5784;
                            }
                            _5897 = rsqrt(dot(float3(_5893, _5894, _5895), float3(_5893, _5894, _5895)));
                            _5898 = _5897 * _5893;
                            _5899 = _5897 * _5894;
                            _5900 = _5897 * _5895;
                            _5901 = _214 * _214;
                            _5905 = saturate((_3655 * (1.0f - _5901)) * _5897);
                            _5907 = saturate(_5897 * f16tof32(_3601));
                            _5909 = rsqrt(dot(float3(_5776, _5777, _5778), float3(_5776, _5777, _5778)));
                            _5913 = dot(float3(_187, _188, _189), float3(_5898, _5899, _5900));
                            _5914 = dot(float3(_187, _188, _189), float3(_444, _445, _443));
                            _5915 = dot(float3(_444, _445, _443), float3(_5898, _5899, _5900));
                            _5918 = rsqrt((_5915 * 2.0f) + 2.0f);
                            _5925 = (_5905 > 0.0f);
                            if (_5925) {
                              _5929 = sqrt(1.0f - (_5905 * _5905));
                              _5931 = (_5913 * 2.0f) * _5914;
                              _5932 = _5931 - _5915;
                              if (!(_5932 >= _5929)) {
                                _5940 = rsqrt(1.0f - (_5932 * _5932)) * _5905;
                                _5943 = _5940 * (_5914 - (_5932 * _5913));
                                _5944 = _5914 * _5914;
                                _5949 = _5940 * (((_5944 * 2.0f) + -1.0f) - (_5932 * _5915));
                                _5958 = sqrt(saturate((((1.0f - (_5913 * _5913)) - _5944) - (_5915 * _5915)) + (_5931 * _5915)));
                                _5959 = _5958 * _5940;
                                _5962 = ((_5914 * 2.0f) * _5940) * _5958;
                                _5964 = (_5929 * _5913) + _5914;
                                _5965 = _5964 + _5943;
                                _5966 = _5929 * _5915;
                                _5968 = (_5966 + 1.0f) + _5949;
                                _5969 = _5959 * _5968;
                                _5970 = _5965 * _5968;
                                _5971 = _5962 * _5965;
                                _5976 = (((_5965 * 0.25f) * _5962) - (_5969 * 0.5f)) * _5970;
                                _5990 = (((_5971 - (_5969 * 2.0f)) * _5971) + (_5969 * _5969)) + ((((-0.5f - ((_5968 + _5966) * 0.5f)) * _5970) + ((_5968 * _5968) * _5964)) * _5965);
                                _5995 = (_5976 * 2.0f) / ((_5990 * _5990) + (_5976 * _5976));
                                _5996 = _5990 * _5995;
                                _5998 = 1.0f - (_5976 * _5995);
                                _6004 = ((_5996 * _5962) + _5966) + (_5998 * _5949);
                                _6007 = rsqrt((_6004 * 2.0f) + 2.0f);
                                _6016 = saturate((_6004 * _6007) + _6007);
                                _6017 = saturate(((_5964 + (_5996 * _5959)) + (_5998 * _5943)) * _6007);
                              } else {
                                _6016 = abs(_5914);
                                _6017 = 1.0f;
                              }
                            } else {
                              _6016 = saturate((_5918 * _5915) + _5918);
                              _6017 = saturate(_5918 * (_5914 + _5913));
                            }
                            _6018 = saturate(_5833);
                            _6020 = _5901 * _5901;
                            if (_5907 > 0.0f) {
                              _6030 = saturate(((_5907 * _5907) / ((_6016 * 3.5999999046325684f) + 0.4000000059604645f)) + _6020);
                            } else {
                              _6030 = _6020;
                            }
                            if (_5925) {
                              _6039 = (((_5905 * 0.25f) * ((sqrt(_6030) * 3.0f) + _5905)) / (_6016 + 0.0010000000474974513f)) + _6030;
                              _6042 = _6039;
                              _6043 = (_6030 / _6039);
                            } else {
                              _6042 = _6030;
                              _6043 = 1.0f;
                            }
                            if (_5817 < 1.0f) {
                              _6050 = sqrt((1.000100016593933f - _5817) / max(9.999999974752427e-07f, (_5817 + 1.0f)));
                              _6063 = (sqrt(_6042 / ((((_6050 * 0.25f) * ((sqrt(_6042) * 3.0f) + _6050)) / (_6016 + 0.0010000000474974513f)) + _6042)) * _6043);
                            } else {
                              _6063 = _6043;
                            }
                            _6067 = (((_6030 * _6017) - _6017) * _6017) + 1.0f;
                            _6074 = exp2(log2(1.0f - saturate(_6016)) * 5.0f);
                            _6077 = saturate(abs(_5914) + 9.999999747378752e-06f);
                            _6078 = sqrt(_6030);
                            _6079 = 1.0f - _6078;
                            _6091 = saturate((dot(float3(_187, _188, _189), float3((_5909 * _5776), (_5909 * _5777), (_5909 * _5778))) + _3652) / (_3652 + 1.0f));
                            _6094 = ((_6063 * _6018) * (_6030 / (_6067 * _6067))) * (0.5f / ((((_6079 * _6077) + _6078) * _6018) + (((_6079 * _6018) + _6078) * _6077)));
                            _6095 = _5729 * _1650;
                            _6096 = _5730 * _1650;
                            _6097 = _5731 * _1650;
                            _6104 = ((_5774 * _6095) * _6091) + _1587;
                            _6105 = ((_5774 * _6096) * _6091) + _1588;
                            _6106 = ((_5774 * _6097) * _6091) + _1589;
                            if (_3649 > 0.0f) {
                              _6119 = (_3649 * _1346) * select(_5771, (_5767 * _1273), _5767);
                              _8454 = _6104;
                              _8455 = _6105;
                              _8456 = _6106;
                              _8457 = (((((_6095 * _1136) * _6119) * ((_6074 * (1.0f - _206)) + _206)) * _6094) + _1590);
                              _8458 = (((((_6096 * _1137) * _6119) * ((_6074 * (1.0f - _207)) + _207)) * _6094) + _1591);
                              _8459 = (((((_6097 * _1138) * _6119) * ((_6074 * (1.0f - _208)) + _208)) * _6094) + _1592);
                            } else {
                              _8454 = _6104;
                              _8455 = _6105;
                              _8456 = _6106;
                              _8457 = _1590;
                              _8458 = _1591;
                              _8459 = _1592;
                            }
                          } else {
                            _8454 = _1587;
                            _8455 = _1588;
                            _8456 = _1589;
                            _8457 = _1590;
                            _8458 = _1591;
                            _8459 = _1592;
                          }
                          break;
                        }
                      } else {
                        _8454 = _1587;
                        _8455 = _1588;
                        _8456 = _1589;
                        _8457 = _1590;
                        _8458 = _1591;
                        _8459 = _1592;
                      }
                    } else {
                      if (_1633 == 8) {
                        _6140 = asfloat(srvLightInfoProperties.Load3(_1601)).x;
                        _6141 = asfloat(srvLightInfoProperties.Load3(_1601)).y;
                        _6142 = asfloat(srvLightInfoProperties.Load3(_1601)).z;
                        _6145 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 12u)))).x;
                        _6146 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 12u)))).y;
                        _6147 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 12u)))).z;
                        _6150 = asfloat(srvLightInfoProperties.Load(((int)(_1601 + 24u))));
                        _6153 = asint(srvLightInfoProperties.Load(((int)(_1601 + 28u))));
                        _6156 = asint(srvLightInfoProperties.Load(((int)(_1601 + 32u))));
                        _6159 = asint(srvLightInfoProperties.Load(((int)(_1601 + 44u))));
                        _6168 = ((float)((uint)((uint)(((uint)(_6156) >> 8) & 255)))) * 0.003921499941498041f;
                        _6171 = ((float)((uint)((uint)(_6156 & 255)))) * 0.003921499941498041f;
                        _6174 = f16tof32(_6159);
                        _6181 = min(max(dot(float3((_225 - _6140), (_226 - _6141), (_227 - _6142)), float3(_6145, _6146, _6147)), (-0.0f - _6150)), _6150);
                        _6186 = (_6140 - _225) + (_6181 * _6145);
                        _6188 = (_6141 - _226) + (_6181 * _6146);
                        _6190 = (_6142 + _224) + (_6181 * _6147);
                        _6191 = dot(float3(_6186, _6188, _6190), float3(_6186, _6188, _6190));
                        _6192 = rsqrt(_6191);
                        _6194 = _6186 * _6192;
                        _6195 = _6188 * _6192;
                        _6196 = _6190 * _6192;
                        _6199 = max(0.0f, ((_6192 * _6191) - abs(_6174)));
                        _6200 = _6199 * f16tof32(((uint)((uint)(_6159) >> 16)));
                        _6201 = _6200 * _6200;
                        _6204 = saturate(1.0f - (_6201 * _6201));
                        _6211 = (_6204 * _6204) / (select((_6174 < 0.0f), (_6201 * 16.0f), (_6199 * _6199)) + 1.0f);
                        [branch]
                        if (!(_6211 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _6220 = srvLightMappingData[_1602];
                            if (!(_6220 == -1)) {
                              _6225 = srvLightIndexData[_6220].nLayerIndex;
                              _6227 = srvLightIndexData[_6220].vAtlasOrigin.x;
                              _6228 = srvLightIndexData[_6220].vAtlasOrigin.y;
                              _6230 = srvLightIndexData[_6220].vScreenOrigin.x;
                              _6231 = srvLightIndexData[_6220].vScreenOrigin.y;
                              _6240 = ((int)(_6225 * 5)) & 31;
                              _6249 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6227 + _64) - _6230)), ((int)((_6228 + _65) - _6231)), 0)))).x) & ((int)(31 << _6240)))) >> _6240)) >> 1)))) * 0.06666667014360428f) * _6211);
                            } else {
                              _6249 = _6211;
                            }
                          } else {
                            _6249 = _6211;
                          }
                          _6253 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _6255 = select(_6253, (_6249 * _1273), _6249);
                          _6256 = dot(float3(_187, _188, _189), float3(_6194, _6195, _6196));
                          _6257 = dot(float3(_187, _188, _189), float3(_444, _445, _443));
                          _6258 = dot(float3(_444, _445, _443), float3(_6194, _6195, _6196));
                          _6261 = rsqrt((_6258 * 2.0f) + 2.0f);
                          _6264 = saturate(_6261 * (_6257 + _6256));
                          _6268 = saturate(_6256);
                          _6269 = _214 * _214;
                          _6270 = _6269 * _6269;
                          _6274 = (((_6264 * _6270) - _6264) * _6264) + 1.0f;
                          _6281 = exp2(log2(1.0f - saturate(saturate((_6261 * _6258) + _6261))) * 5.0f);
                          _6284 = saturate(abs(_6257) + 9.999999747378752e-06f);
                          _6285 = sqrt(_6270);
                          _6286 = 1.0f - _6285;
                          _6298 = saturate((_6256 + _6171) / (_6171 + 1.0f));
                          _6300 = ((_6270 / (_6274 * _6274)) * _6268) * (0.5f / ((((_6286 * _6284) + _6285) * _6268) + (((_6286 * _6268) + _6285) * _6284)));
                          _6301 = f16tof32(((uint)((uint)(_6153) >> 16))) * _1650;
                          _6302 = f16tof32(_6153) * _1650;
                          _6303 = f16tof32(((uint)((uint)(_6156) >> 16))) * _1650;
                          _6310 = ((_6255 * _6301) * _6298) + _1587;
                          _6311 = ((_6255 * _6302) * _6298) + _1588;
                          _6312 = ((_6255 * _6303) * _6298) + _1589;
                          if (_6168 > 0.0f) {
                            _6327 = (_6168 * _1346) * select(_6253, (_6249 * _1273), _6249);
                            _8454 = _6310;
                            _8455 = _6311;
                            _8456 = _6312;
                            _8457 = (((((_6301 * _1136) * _6327) * ((_6281 * (1.0f - _206)) + _206)) * _6300) + _1590);
                            _8458 = (((((_6302 * _1137) * _6327) * ((_6281 * (1.0f - _207)) + _207)) * _6300) + _1591);
                            _8459 = (((((_6303 * _1138) * _6327) * ((_6281 * (1.0f - _208)) + _208)) * _6300) + _1592);
                          } else {
                            _8454 = _6310;
                            _8455 = _6311;
                            _8456 = _6312;
                            _8457 = _1590;
                            _8458 = _1591;
                            _8459 = _1592;
                          }
                        } else {
                          _8454 = _1587;
                          _8455 = _1588;
                          _8456 = _1589;
                          _8457 = _1590;
                          _8458 = _1591;
                          _8459 = _1592;
                        }
                      } else {
                        if (_1633 == 9) {
                          _6348 = asfloat(srvLightInfoProperties.Load4(_1601)).x;
                          _6349 = asfloat(srvLightInfoProperties.Load4(_1601)).y;
                          _6350 = asfloat(srvLightInfoProperties.Load4(_1601)).w;
                          _6353 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).x;
                          _6354 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).y;
                          _6355 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).w;
                          _6358 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).x;
                          _6359 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).y;
                          _6360 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).w;
                          _6363 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 48u)))).x;
                          _6364 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 48u)))).y;
                          _6365 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 48u)))).w;
                          _6368 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 64u)))).x;
                          _6369 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 64u)))).y;
                          _6370 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 64u)))).z;
                          _6373 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 76u)))).x;
                          _6374 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 76u)))).y;
                          _6375 = asfloat(srvLightInfoProperties.Load3(((int)(_1601 + 76u)))).z;
                          _6378 = asint(srvLightInfoProperties.Load(((int)(_1601 + 88u))));
                          _6381 = asint(srvLightInfoProperties.Load(((int)(_1601 + 92u))));
                          _6384 = asint(srvLightInfoProperties.Load(((int)(_1601 + 100u))));
                          _6387 = asint(srvLightInfoProperties.Load(((int)(_1601 + 104u))));
                          _6390 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).x;
                          _6391 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).y;
                          _6392 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).z;
                          _6393 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 108u)))).w;
                          _6396 = asint(srvLightInfoProperties.Load(((int)(_1601 + 124u))));
                          _6399 = asint(srvLightInfoProperties.Load(((int)(_1601 + 128u))));
                          _6402 = asint(srvLightInfoProperties.Load(((int)(_1601 + 132u))));
                          _6405 = asint(srvLightInfoProperties.Load(((int)(_1601 + 136u))));
                          _6408 = asint(srvLightInfoProperties.Load(((int)(_1601 + 140u))));
                          _6411 = asint(srvLightInfoProperties.Load(((int)(_1601 + 144u))));
                          _6414 = asint(srvLightInfoProperties.Load(((int)(_1601 + 148u))));
                          _6417 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 152u)))).x;
                          _6418 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 152u)))).y;
                          _6419 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 152u)))).z;
                          _6420 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 152u)))).w;
                          _6423 = asint(srvLightInfoProperties.Load(((int)(_1601 + 168u))));
                          _6426 = asint(srvLightInfoProperties.Load(((int)(_1601 + 172u))));
                          _6429 = asint(srvLightInfoProperties.Load(((int)(_1601 + 180u))));
                          _6431 = f16tof32(((uint)((uint)(_6378) >> 16)));
                          _6432 = f16tof32(_6378);
                          _6434 = f16tof32(((uint)((uint)(_6381) >> 16)));
                          _6438 = ((float)((uint)((uint)(((uint)(_6381) >> 8) & 255)))) * 0.003921499941498041f;
                          _6441 = ((float)((uint)((uint)(_6381 & 255)))) * 0.003921499941498041f;
                          _6442 = f16tof32(_6384);
                          _6444 = f16tof32(((uint)((uint)(_6387) >> 16)));
                          _6448 = f16tof32(_6396);
                          _6452 = _6402 & 65535;
                          _6468 = f16tof32(((uint)((uint)(_6426) >> 16)));
                          _6469 = f16tof32(_6426);
                          _6471 = f16tof32(((uint)((uint)(_6429) >> 16)));
                          _6472 = 1.0f / _6471;
                          _6473 = _6471 + -1.0f;
                          _6474 = f16tof32(_6429);
                          _6475 = _6368 - _225;
                          _6476 = _6369 - _226;
                          _6477 = _6370 + _224;
                          _6478 = dot(float3(_6475, _6476, _6477), float3(_6475, _6476, _6477));
                          _6479 = rsqrt(_6478);
                          _6480 = _6479 * _6478;
                          _6481 = _6479 * _6475;
                          _6482 = _6479 * _6476;
                          _6483 = _6479 * _6477;
                          _6486 = max(0.0f, (_6480 - abs(_6448)));
                          _6487 = _6486 * f16tof32(((uint)((uint)(_6396) >> 16)));
                          _6488 = _6487 * _6487;
                          _6491 = saturate(1.0f - (_6488 * _6488));
                          _6502 = mad(_227, _6360, mad(_226, _6355, (_6350 * _225))) + _6365;
                          _6506 = saturate(1.0f - dot(float3(_187, _188, _189), float3(_6481, _6482, _6483))) * f16tof32(_6423);
                          _6513 = ((_6502 * _187) * _6506) + _225;
                          _6514 = ((_6502 * _188) * _6506) + _226;
                          _6515 = ((_6502 * _189) * _6506) - _224;
                          _6527 = mad(_6515, _6360, mad(_6514, _6355, (_6513 * _6350))) + _6365;
                          _6528 = 1.0f / _6527;
                          _6529 = _6528 * (mad(_6515, _6358, mad(_6514, _6353, (_6513 * _6348))) + _6363);
                          _6530 = _6528 * (mad(_6515, _6359, mad(_6514, _6354, (_6513 * _6349))) + _6364);
                          _6533 = (_6529 * _6390) + _6391;
                          _6534 = (_6530 * _6390) + _6391;
                          _6537 = _6533 - saturate(_6533);
                          _6538 = _6534 - saturate(_6534);
                          _6545 = saturate((sqrt((_6537 * _6537) + (_6538 * _6538)) * _6392) + _6393);
                          _6547 = 1.0f - (_6545 * _6545);
                          _6553 = (_6547 * _6547) * (((float)((bool)(uint)((_6527 - f16tof32(((uint)((uint)(_6399) >> 16)))) > 0.0f))) * ((_6491 * _6491) / (select((_6448 < 0.0f), (_6488 * 16.0f), (_6486 * _6486)) + 1.0f)));
                          _6555 = ((_1599 & 3584) == 0);
                          if (!((!(_6553 > 0.0f)) || _6555)) {
                            _6563 = 1.0f - saturate(f16tof32(_6399) * _6527);
                            _6564 = saturate(_6529);
                            _6565 = saturate(_6530);
                            bool __branch_chain_6557;
                            [branch]
                            if ((_1599 & 1024) == 0) {
                              _6828 = 1.0f;
                              _6829 = 0.0f;
                              _6830 = _6563;
                              __branch_chain_6557 = true;
                            } else {
                              _6570 = ((_6564 * _6473) + 0.5f) * _6472;
                              _6572 = ((_6565 * _6473) + 0.5f) * _6472;
                              _6573 = _6563 + f16tof32(((uint)((uint)(_6423) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6402) >> 16))];
                              _6576 = saturate(_6573);
                              _6580 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _6589 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_6580 * 32.665000915527344f) + _126), ((_6580 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _6590 = sin(_6589);
                              _6591 = cos(_6589);
                              _6592 = cbSharedPerViewData.nFrameCounter & 3;
                              _6597 = sqrt((float((int)(_6592)) * 0.25f) + 0.125f) * _6468;
                              _6606 = (_global_7[min((uint)(((int)(0u + (_6592 * 2)))), 127u)]) * _6597;
                              _6607 = (_global_7[min((uint)(((int)(1u + (_6592 * 2)))), 127u)]) * _6597;
                              _6609 = -0.0f - _6590;
                              _6614 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6606, _6607), float2(_6591, _6590)) + _6570), (dot(float2(_6606, _6607), float2(_6609, _6591)) + _6572)));
                              _6619 = _6614.x - _6576;
                              _6621 = select((_6619 < 0.0f), 0.0f, 1.0f);
                              _6623 = _6614.y - _6576;
                              _6625 = select((_6623 < 0.0f), 0.0f, 1.0f);
                              _6629 = _6614.z - _6576;
                              _6631 = select((_6629 < 0.0f), 0.0f, 1.0f);
                              _6635 = _6614.w - _6576;
                              _6637 = select((_6635 < 0.0f), 0.0f, 1.0f);
                              _6644 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _6649 = sqrt((float((int)(_6644)) * 0.25f) + 0.125f) * _6468;
                              _6658 = (_global_7[min((uint)(((int)(0u + (_6644 * 2)))), 127u)]) * _6649;
                              _6659 = (_global_7[min((uint)(((int)(1u + (_6644 * 2)))), 127u)]) * _6649;
                              _6665 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6658, _6659), float2(_6591, _6590)) + _6570), (dot(float2(_6658, _6659), float2(_6609, _6591)) + _6572)));
                              _6670 = _6665.x - _6576;
                              _6672 = select((_6670 < 0.0f), 0.0f, 1.0f);
                              _6676 = _6665.y - _6576;
                              _6678 = select((_6676 < 0.0f), 0.0f, 1.0f);
                              _6682 = _6665.z - _6576;
                              _6684 = select((_6682 < 0.0f), 0.0f, 1.0f);
                              _6688 = _6665.w - _6576;
                              _6690 = select((_6688 < 0.0f), 0.0f, 1.0f);
                              _6697 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _6702 = sqrt((float((int)(_6697)) * 0.25f) + 0.125f) * _6468;
                              _6711 = (_global_7[min((uint)(((int)(0u + (_6697 * 2)))), 127u)]) * _6702;
                              _6712 = (_global_7[min((uint)(((int)(1u + (_6697 * 2)))), 127u)]) * _6702;
                              _6718 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6711, _6712), float2(_6591, _6590)) + _6570), (dot(float2(_6711, _6712), float2(_6609, _6591)) + _6572)));
                              _6723 = _6718.x - _6576;
                              _6725 = select((_6723 < 0.0f), 0.0f, 1.0f);
                              _6729 = _6718.y - _6576;
                              _6731 = select((_6729 < 0.0f), 0.0f, 1.0f);
                              _6735 = _6718.z - _6576;
                              _6737 = select((_6735 < 0.0f), 0.0f, 1.0f);
                              _6741 = _6718.w - _6576;
                              _6743 = select((_6741 < 0.0f), 0.0f, 1.0f);
                              _6750 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _6755 = sqrt((float((int)(_6750)) * 0.25f) + 0.125f) * _6468;
                              _6764 = (_global_7[min((uint)(((int)(0u + (_6750 * 2)))), 127u)]) * _6755;
                              _6765 = (_global_7[min((uint)(((int)(1u + (_6750 * 2)))), 127u)]) * _6755;
                              _6771 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6764, _6765), float2(_6591, _6590)) + _6570), (dot(float2(_6764, _6765), float2(_6609, _6591)) + _6572)));
                              _6776 = _6771.x - _6576;
                              _6778 = select((_6776 < 0.0f), 0.0f, 1.0f);
                              _6782 = _6771.y - _6576;
                              _6784 = select((_6782 < 0.0f), 0.0f, 1.0f);
                              _6788 = _6771.z - _6576;
                              _6790 = select((_6788 < 0.0f), 0.0f, 1.0f);
                              _6794 = _6771.w - _6576;
                              _6796 = select((_6794 < 0.0f), 0.0f, 1.0f);
                              _6797 = ((((((((((((((_6621 + _6625) + _6631) + _6637) + _6672) + _6678) + _6684) + _6690) + _6725) + _6731) + _6737) + _6743) + _6778) + _6784) + _6790) + _6796;
                              _6808 = (saturate(_6797 * 0.0625f) * 2.0f) + -1.0f;
                              _6814 = float((int)(((int)(uint)((int)(_6808 > 0.0f))) - ((int)(uint)((int)(_6808 < 0.0f)))));
                              _6816 = 1.0f - (_6814 * _6808);
                              _6818 = (_6816 * _6816) * _6816;
                              _6825 = 0.5f - ((_6814 * 0.5f) * ((1.0f - _6818) - ((_6816 - _6818) * saturate(((1.0f / _6576) * (1.0f / _6797)) * ((((((((((((((((_6621 * _6619) + (_6625 * _6623)) + (_6631 * _6629)) + (_6637 * _6635)) + (_6672 * _6670)) + (_6678 * _6676)) + (_6684 * _6682)) + (_6690 * _6688)) + (_6725 * _6723)) + (_6731 * _6729)) + (_6737 * _6735)) + (_6743 * _6741)) + (_6778 * _6776)) + (_6784 * _6782)) + (_6790 * _6788)) + (_6796 * _6794))))));
                              [branch]
                              if (_6474 < 1.0f) {
                                _6828 = _6825;
                                _6829 = _6474;
                                _6830 = _6573;
                                __branch_chain_6557 = true;
                              } else {
                                _7298 = _6474;
                                _7299 = _6825;
                                __branch_chain_6557 = false;
                              }
                            }
                            if (__branch_chain_6557) {
                              _6833 = (_6564 * _6417) + _6419;
                              _6834 = (_6565 * _6418) + _6420;
                              if (!((_1599 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _6843 = saturate(_6830);
                                _6847 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _6856 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_6847 * 32.665000915527344f) + _126), ((_6847 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _6857 = sin(_6856);
                                _6858 = cos(_6856);
                                _6863 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_6833, _6834), 0.0f))).x) > _6843), 1.0f, 0.0f);
                                _6864 = cbSharedPerViewData.nFrameCounter & 3;
                                _6869 = sqrt((float((int)(_6864)) * 0.25f) + 0.125f) * _6469;
                                _6878 = (_global_7[min((uint)(((int)(0u + (_6864 * 2)))), 127u)]) * _6869;
                                _6879 = (_global_7[min((uint)(((int)(1u + (_6864 * 2)))), 127u)]) * _6869;
                                _6881 = -0.0f - _6857;
                                _6883 = dot(float2(_6878, _6879), float2(_6858, _6857)) + _6833;
                                _6884 = dot(float2(_6878, _6879), float2(_6881, _6858)) + _6834;
                                _6886 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6883, _6884));
                                _6890 = _6883 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6891 = _6884 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6894 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6419);
                                _6895 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6420);
                                _6900 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6417 + _6419)) + 0.5f);
                                _6901 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6418 + _6420)) + 0.5f);
                                _6904 = floor(_6890 + -0.5f);
                                _6905 = floor(_6891 + 0.5f);
                                _6907 = floor(_6890 + 0.5f);
                                _6909 = floor(_6891 + -0.5f);
                                _6910 = (_6904 < _6894);
                                _6911 = (_6905 < _6895);
                                if ((_6910 || _6911) | ((_6904 >= _6900) || (_6905 >= _6901))) {
                                  _6920 = _6863;
                                } else {
                                  _6920 = _6886.x;
                                }
                                _6921 = (_6907 < _6894);
                                if ((_6921 || _6911) | ((_6907 >= _6900) || (_6905 >= _6901))) {
                                  _6929 = _6863;
                                } else {
                                  _6929 = _6886.y;
                                }
                                _6930 = (_6909 < _6895);
                                if ((_6921 || _6930) | ((_6907 >= _6900) || (_6909 >= _6901))) {
                                  _6938 = _6863;
                                } else {
                                  _6938 = _6886.z;
                                }
                                if ((_6910 || _6930) | ((_6904 >= _6900) || (_6909 >= _6901))) {
                                  _6946 = _6863;
                                } else {
                                  _6946 = _6886.w;
                                }
                                _6947 = _6920 - _6843;
                                _6949 = select((_6947 < 0.0f), 0.0f, 1.0f);
                                _6951 = _6929 - _6843;
                                _6953 = select((_6951 < 0.0f), 0.0f, 1.0f);
                                _6957 = _6938 - _6843;
                                _6959 = select((_6957 < 0.0f), 0.0f, 1.0f);
                                _6963 = _6946 - _6843;
                                _6965 = select((_6963 < 0.0f), 0.0f, 1.0f);
                                _6972 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _6977 = sqrt((float((int)(_6972)) * 0.25f) + 0.125f) * _6469;
                                _6986 = (_global_7[min((uint)(((int)(0u + (_6972 * 2)))), 127u)]) * _6977;
                                _6987 = (_global_7[min((uint)(((int)(1u + (_6972 * 2)))), 127u)]) * _6977;
                                _6990 = dot(float2(_6986, _6987), float2(_6858, _6857)) + _6833;
                                _6991 = dot(float2(_6986, _6987), float2(_6881, _6858)) + _6834;
                                _6993 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6990, _6991));
                                _6997 = _6990 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6998 = _6991 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7001 = floor(_6997 + -0.5f);
                                _7002 = floor(_6998 + 0.5f);
                                _7004 = floor(_6997 + 0.5f);
                                _7006 = floor(_6998 + -0.5f);
                                _7007 = (_7001 < _6894);
                                _7008 = (_7002 < _6895);
                                if ((_7007 || _7008) | ((_7001 >= _6900) || (_7002 >= _6901))) {
                                  _7017 = _6863;
                                } else {
                                  _7017 = _6993.x;
                                }
                                _7018 = (_7004 < _6894);
                                if ((_7018 || _7008) | ((_7004 >= _6900) || (_7002 >= _6901))) {
                                  _7026 = _6863;
                                } else {
                                  _7026 = _6993.y;
                                }
                                _7027 = (_7006 < _6895);
                                if ((_7018 || _7027) | ((_7004 >= _6900) || (_7006 >= _6901))) {
                                  _7035 = _6863;
                                } else {
                                  _7035 = _6993.z;
                                }
                                if ((_7007 || _7027) | ((_7001 >= _6900) || (_7006 >= _6901))) {
                                  _7043 = _6863;
                                } else {
                                  _7043 = _6993.w;
                                }
                                _7044 = _7017 - _6843;
                                _7046 = select((_7044 < 0.0f), 0.0f, 1.0f);
                                _7050 = _7026 - _6843;
                                _7052 = select((_7050 < 0.0f), 0.0f, 1.0f);
                                _7056 = _7035 - _6843;
                                _7058 = select((_7056 < 0.0f), 0.0f, 1.0f);
                                _7062 = _7043 - _6843;
                                _7064 = select((_7062 < 0.0f), 0.0f, 1.0f);
                                _7071 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _7076 = sqrt((float((int)(_7071)) * 0.25f) + 0.125f) * _6469;
                                _7085 = (_global_7[min((uint)(((int)(0u + (_7071 * 2)))), 127u)]) * _7076;
                                _7086 = (_global_7[min((uint)(((int)(1u + (_7071 * 2)))), 127u)]) * _7076;
                                _7089 = dot(float2(_7085, _7086), float2(_6858, _6857)) + _6833;
                                _7090 = dot(float2(_7085, _7086), float2(_6881, _6858)) + _6834;
                                _7092 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7089, _7090));
                                _7096 = _7089 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7097 = _7090 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7100 = floor(_7096 + -0.5f);
                                _7101 = floor(_7097 + 0.5f);
                                _7103 = floor(_7096 + 0.5f);
                                _7105 = floor(_7097 + -0.5f);
                                _7106 = (_7100 < _6894);
                                _7107 = (_7101 < _6895);
                                if ((_7106 || _7107) | ((_7100 >= _6900) || (_7101 >= _6901))) {
                                  _7116 = _6863;
                                } else {
                                  _7116 = _7092.x;
                                }
                                _7117 = (_7103 < _6894);
                                if ((_7117 || _7107) | ((_7103 >= _6900) || (_7101 >= _6901))) {
                                  _7125 = _6863;
                                } else {
                                  _7125 = _7092.y;
                                }
                                _7126 = (_7105 < _6895);
                                if ((_7117 || _7126) | ((_7103 >= _6900) || (_7105 >= _6901))) {
                                  _7134 = _6863;
                                } else {
                                  _7134 = _7092.z;
                                }
                                if ((_7106 || _7126) | ((_7100 >= _6900) || (_7105 >= _6901))) {
                                  _7142 = _6863;
                                } else {
                                  _7142 = _7092.w;
                                }
                                _7143 = _7116 - _6843;
                                _7145 = select((_7143 < 0.0f), 0.0f, 1.0f);
                                _7149 = _7125 - _6843;
                                _7151 = select((_7149 < 0.0f), 0.0f, 1.0f);
                                _7155 = _7134 - _6843;
                                _7157 = select((_7155 < 0.0f), 0.0f, 1.0f);
                                _7161 = _7142 - _6843;
                                _7163 = select((_7161 < 0.0f), 0.0f, 1.0f);
                                _7170 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _7175 = sqrt((float((int)(_7170)) * 0.25f) + 0.125f) * _6469;
                                _7184 = (_global_7[min((uint)(((int)(0u + (_7170 * 2)))), 127u)]) * _7175;
                                _7185 = (_global_7[min((uint)(((int)(1u + (_7170 * 2)))), 127u)]) * _7175;
                                _7188 = dot(float2(_7184, _7185), float2(_6858, _6857)) + _6833;
                                _7189 = dot(float2(_7184, _7185), float2(_6881, _6858)) + _6834;
                                _7191 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7188, _7189));
                                _7195 = _7188 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _7196 = _7189 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7199 = floor(_7195 + -0.5f);
                                _7200 = floor(_7196 + 0.5f);
                                _7202 = floor(_7195 + 0.5f);
                                _7204 = floor(_7196 + -0.5f);
                                _7205 = (_7199 < _6894);
                                _7206 = (_7200 < _6895);
                                if ((_7205 || _7206) | ((_7199 >= _6900) || (_7200 >= _6901))) {
                                  _7215 = _6863;
                                } else {
                                  _7215 = _7191.x;
                                }
                                _7216 = (_7202 < _6894);
                                if ((_7216 || _7206) | ((_7202 >= _6900) || (_7200 >= _6901))) {
                                  _7224 = _6863;
                                } else {
                                  _7224 = _7191.y;
                                }
                                _7225 = (_7204 < _6895);
                                if ((_7216 || _7225) | ((_7202 >= _6900) || (_7204 >= _6901))) {
                                  _7233 = _6863;
                                } else {
                                  _7233 = _7191.z;
                                }
                                if ((_7205 || _7225) | ((_7199 >= _6900) || (_7204 >= _6901))) {
                                  _7241 = _6863;
                                } else {
                                  _7241 = _7191.w;
                                }
                                _7242 = _7215 - _6843;
                                _7244 = select((_7242 < 0.0f), 0.0f, 1.0f);
                                _7248 = _7224 - _6843;
                                _7250 = select((_7248 < 0.0f), 0.0f, 1.0f);
                                _7254 = _7233 - _6843;
                                _7256 = select((_7254 < 0.0f), 0.0f, 1.0f);
                                _7260 = _7241 - _6843;
                                _7262 = select((_7260 < 0.0f), 0.0f, 1.0f);
                                _7263 = ((((((((((((((_6953 + _6949) + _6959) + _6965) + _7046) + _7052) + _7058) + _7064) + _7145) + _7151) + _7157) + _7163) + _7244) + _7250) + _7256) + _7262;
                                _7274 = (saturate(_7263 * 0.0625f) * 2.0f) + -1.0f;
                                _7280 = float((int)(((int)(uint)((int)(_7274 > 0.0f))) - ((int)(uint)((int)(_7274 < 0.0f)))));
                                _7282 = 1.0f - (_7280 * _7274);
                                _7284 = (_7282 * _7282) * _7282;
                                _7293 = (0.5f - ((_7280 * 0.5f) * ((1.0f - _7284) - ((_7282 - _7284) * saturate(((1.0f / _6843) * (1.0f / _7263)) * ((((((((((((((((_6953 * _6951) + (_6949 * _6947)) + (_6959 * _6957)) + (_6965 * _6963)) + (_7046 * _7044)) + (_7052 * _7050)) + (_7058 * _7056)) + (_7064 * _7062)) + (_7145 * _7143)) + (_7151 * _7149)) + (_7157 * _7155)) + (_7163 * _7161)) + (_7244 * _7242)) + (_7250 * _7248)) + (_7256 * _7254)) + (_7262 * _7260)))))));
                              } else {
                                _7293 = 1.0f;
                              }
                              _7298 = _6829;
                              _7299 = (lerp(_7293, _6828, _6829));
                            }
                            [branch]
                            if (!((_1599 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6405) >> 16))];
                              _7305 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6529, _6530), 0.0f);
                              if (_7305.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6405 & 65535))];
                                _7312 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6529, _6530), 0.0f);
                                _7326 = mad(saturate(((log2(_6480) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _7327 = max(9.999999747378752e-06f, _7305.x);
                                _7328 = _7312.x / _7327;
                                _7329 = _7312.y / _7327;
                                _7331 = _7312.w / _7327;
                                _7336 = ((0.375f - _7329) * 4.999999873689376e-06f) + _7329;
                                _7339 = -0.0f - _7328;
                                _7340 = mad(_7339, _7336, (_7312.z / _7327));
                                _7342 = 1.0f / mad(_7339, _7328, _7336);
                                _7343 = _7342 * _7340;
                                _7348 = _7326 - _7328;
                                _7353 = (((_7326 * _7326) - _7336) - (_7343 * _7348)) / mad((-0.0f - _7340), _7343, mad((-0.0f - _7336), _7336, (((0.375f - _7331) * 4.999999873689376e-06f) + _7331)));
                                _7355 = (_7342 * _7348) - (_7353 * _7343);
                                _7358 = 1.0f / _7353;
                                _7359 = _7355 * _7358;
                                _7364 = sqrt(((_7359 * _7359) * 0.25f) - ((1.0f - dot(float2(_7355, _7353), float2(_7328, _7336))) * _7358));
                                _7366 = (_7359 * -0.5f) - _7364;
                                _7368 = _7364 - (_7359 * 0.5f);
                                _7370 = select((_7366 < _7326), 1.0f, 0.0f);
                                _7375 = (_7370 + -0.05000000074505806f) / (_7366 - _7326);
                                _7381 = (((select((_7368 < _7326), 1.0f, 0.0f) - _7370) / (_7368 - _7366)) - _7375) / (_7368 - _7326);
                                _7383 = _7375 - (_7381 * _7366);
                                _7396 = _7298;
                                _7397 = (exp2((_7305.x * -1.4426950216293335f) * saturate((dot(float2(_7328, _7336), float2((_7383 - (_7381 * _7326)), _7381)) + 0.05000000074505806f) - (_7383 * _7326))) * _7299);
                              } else {
                                _7396 = _7298;
                                _7397 = _7299;
                              }
                            } else {
                              _7396 = _7298;
                              _7397 = _7299;
                            }
                          } else {
                            _7396 = 0.0f;
                            _7397 = 1.0f;
                          }
                          [branch]
                          if (!(_6452 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6452)))];
                            _7410 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6529 * f16tof32(((uint)((uint)(_6411) >> 16)))) + f16tof32(((uint)((uint)(_6414) >> 16)))), ((_6530 * f16tof32(_6411)) + f16tof32(_6414))), 0.0f);
                            _7418 = (_7410.x * _6431);
                            _7419 = (_7410.y * _6432);
                            _7420 = (_7410.z * _6434);
                          } else {
                            _7418 = _6431;
                            _7419 = _6432;
                            _7420 = _6434;
                          }
                          _7421 = _7397 * _6553;
                          [branch]
                          if (!(_7421 == 0.0f)) {
                            bool __branch_chain_7423;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _7439 = 0;
                              __branch_chain_7423 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _7439 = 1;
                                __branch_chain_7423 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _7439 = 2;
                                  __branch_chain_7423 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1602) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _7439 = 3;
                                    __branch_chain_7423 = true;
                                  } else {
                                    _7464 = _7421;
                                    __branch_chain_7423 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_7423) {
                              while(true) {
                                _7442 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_64, _65, 0));
                                if (_7439 == 0) {
                                  _7456 = _7442.x;
                                } else {
                                  if (_7439 == 1) {
                                    _7456 = _7442.y;
                                  } else {
                                    if (_7439 == 2) {
                                      _7456 = _7442.z;
                                    } else {
                                      _7456 = _7442.w;
                                    }
                                  }
                                }
                                _7464 = ((((_7396 * _7396) * ((_7456 * _7456) + -1.0f)) + 1.0f) * _6553);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_7464 > 0.0f) {
                                if (!(((_6408 & 1) == 0) || _6555)) {
                                  _7480 = max(max(_7418, _7419), _7420);
                                  if (_7480 > 0.0f) {
                                    _7490 = saturate(_7418 / _7480);
                                    _7491 = saturate(_7419 / _7480);
                                    _7492 = saturate(_7420 / _7480);
                                  } else {
                                    _7490 = _7418;
                                    _7491 = _7419;
                                    _7492 = _7420;
                                  }
                                  _7493 = (_7491 < _7492);
                                  _7494 = select(_7493, _7492, _7491);
                                  _7495 = select(_7493, _7491, _7492);
                                  _7496 = select(_7493, -1.0f, 0.0f);
                                  _7497 = (_7490 < _7494);
                                  _7499 = select(_7497, _7494, _7490);
                                  _7500 = select(_7497, _7490, _7494);
                                  _7504 = _7499 - select((_7500 < _7495), _7500, _7495);
                                  _7510 = abs(select(_7497, (-0.3333333432674408f - _7496), _7496) + ((_7500 - _7495) / ((_7504 * 6.0f) + 9.999999682655225e-21f)));
                                  if (_7510 < 0.6666666865348816f) {
                                    _7523 = ((saturate(((float)((uint)((uint)(((uint)(_6408) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7510 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7510)) + _7510);
                                  } else {
                                    _7523 = _7510;
                                  }
                                  _7524 = saturate((_7504 / (_7499 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6408) >> 1) & 255)))) * 0.003921499941498041f));
                                  _7525 = saturate(_7499);
                                  if (!(_7524 <= 0.0f)) {
                                    _7528 = saturate(_7523);
                                    _7532 = select(((_7528 * 360.0f) >= 360.0f), 0.0f, (_7528 * 6.0f));
                                    _7533 = int(_7532);
                                    _7535 = _7532 - float((int)(_7533));
                                    _7537 = _7525 * (1.0f - _7524);
                                    _7540 = (1.0f - (_7535 * _7524)) * _7525;
                                    _7544 = (1.0f - ((1.0f - _7535) * _7524)) * _7525;
                                    switch (_7533) {
                                      case 0: {
                                        _7552 = _7525;
                                        _7553 = _7544;
                                        _7554 = _7537;
                                        break;
                                      }
                                      case 1: {
                                        _7552 = _7540;
                                        _7553 = _7525;
                                        _7554 = _7537;
                                        break;
                                      }
                                      case 2: {
                                        _7552 = _7537;
                                        _7553 = _7525;
                                        _7554 = _7544;
                                        break;
                                      }
                                      case 3: {
                                        _7552 = _7537;
                                        _7553 = _7540;
                                        _7554 = _7525;
                                        break;
                                      }
                                      case 4: {
                                        _7552 = _7544;
                                        _7553 = _7537;
                                        _7554 = _7525;
                                        break;
                                      }
                                      case 5: {
                                        _7552 = _7525;
                                        _7553 = _7537;
                                        _7554 = _7540;
                                        break;
                                      }
                                      default: {
                                        _7552 = 0.0f;
                                        _7553 = 0.0f;
                                        _7554 = 0.0f;
                                        break;
                                      }
                                    }
                                  } else {
                                    _7552 = _7525;
                                    _7553 = _7525;
                                    _7554 = _7525;
                                  }
                                  _7555 = _7552 * _7480;
                                  _7556 = _7553 * _7480;
                                  _7557 = _7554 * _7480;
                                  _7559 = saturate(_7397 * 1.0101009607315063f);
                                  _7570 = ((_7559 * (_7418 - _7555)) + _7555);
                                  _7571 = ((_7559 * (_7419 - _7556)) + _7556);
                                  _7572 = (lerp(_7557, _7420, _7559));
                                } else {
                                  _7570 = _7418;
                                  _7571 = _7419;
                                  _7572 = _7420;
                                }
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _7579 = srvLightMappingData[_1602];
                                  if (!(_7579 == -1)) {
                                    _7584 = srvLightIndexData[_7579].nLayerIndex;
                                    _7586 = srvLightIndexData[_7579].vAtlasOrigin.x;
                                    _7587 = srvLightIndexData[_7579].vAtlasOrigin.y;
                                    _7589 = srvLightIndexData[_7579].vScreenOrigin.x;
                                    _7590 = srvLightIndexData[_7579].vScreenOrigin.y;
                                    _7599 = ((int)(_7584 * 5)) & 31;
                                    _7608 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7586 + _64) - _7589)), ((int)((_7587 + _65) - _7590)), 0)))).x) & ((int)(31 << _7599)))) >> _7599)) >> 1)))) * 0.06666667014360428f) * _7464);
                                  } else {
                                    _7608 = _7464;
                                  }
                                } else {
                                  _7608 = _7464;
                                }
                                _7612 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _7615 = select(_7612, (_7608 * _1273), _7608);
                                _7617 = _6481 * _6480;
                                _7618 = _6482 * _6480;
                                _7619 = _6483 * _6480;
                                _7620 = _6442 * _6373;
                                _7621 = _6442 * _6374;
                                _7622 = _6442 * _6375;
                                _7623 = _7617 + _7620;
                                _7624 = _7618 + _7621;
                                _7625 = _7619 + _7622;
                                _7626 = _7617 - _7620;
                                _7627 = _7618 - _7621;
                                _7628 = _7619 - _7622;
                                _7629 = (_6442 > 0.0f);
                                _7630 = dot(float3(_7623, _7624, _7625), float3(_7623, _7624, _7625));
                                _7631 = rsqrt(_7630);
                                [branch]
                                if (_7629) {
                                  _7634 = rsqrt(dot(float3(_7626, _7627, _7628), float3(_7626, _7627, _7628)));
                                  _7635 = _7634 * _7631;
                                  _7637 = dot(float3(_7623, _7624, _7625), float3(_7626, _7627, _7628)) * _7635;
                                  _7656 = (_7635 / ((_7635 + 0.5f) + (_7637 * 0.5f)));
                                  _7657 = (((dot(float3(_187, _188, _189), float3(_7626, _7627, _7628)) * _7634) + (dot(float3(_187, _188, _189), float3(_7623, _7624, _7625)) * _7631)) * 0.5f);
                                  _7658 = _7637;
                                } else {
                                  _7656 = (1.0f / (_7630 + 1.0f));
                                  _7657 = dot(float3(_187, _188, _189), float3((_7631 * _7623), (_7631 * _7624), (_7631 * _7625)));
                                  _7658 = 1.0f;
                                }
                                if (_6444 > 0.0f) {
                                  _7664 = sqrt(saturate((_6444 * _6444) * _7656));
                                  if (_7657 < _7664) {
                                    _7669 = max(_7657, (-0.0f - _7664)) + _7664;
                                    _7674 = ((_7669 * _7669) / (_7664 * 4.0f));
                                  } else {
                                    _7674 = _7657;
                                  }
                                } else {
                                  _7674 = _7657;
                                }
                                if (_7629) {
                                  _7676 = -0.0f - _444;
                                  _7677 = -0.0f - _445;
                                  _7678 = -0.0f - _443;
                                  _7680 = dot(float3(_7676, _7677, _7678), float3(_187, _188, _189)) * 2.0f;
                                  _7684 = _7676 - (_7680 * _187);
                                  _7685 = _7677 - (_7680 * _188);
                                  _7686 = _7678 - (_7680 * _189);
                                  _7687 = _7626 - _7623;
                                  _7688 = _7627 - _7624;
                                  _7689 = _7628 - _7625;
                                  _7690 = dot(float3(_7684, _7685, _7686), float3(_7687, _7688, _7689));
                                  _7696 = sqrt(((_7687 * _7687) + (_7688 * _7688)) + (_7689 * _7689));
                                  _7705 = saturate(((dot(float3(_7684, _7685, _7686), float3(_7623, _7624, _7625)) * _7690) - dot(float3(_7623, _7624, _7625), float3(_7687, _7688, _7689))) / ((_7696 * _7696) - (_7690 * _7690)));
                                  _7709 = (_7705 * _7687) + _7623;
                                  _7710 = (_7705 * _7688) + _7624;
                                  _7711 = (_7705 * _7689) + _7625;
                                  _7712 = dot(float3(_7709, _7710, _7711), float3(_7684, _7685, _7686));
                                  _7716 = (_7712 * _7684) - _7709;
                                  _7717 = (_7712 * _7685) - _7710;
                                  _7718 = (_7712 * _7686) - _7711;
                                  _7726 = saturate(0.009999999776482582f / sqrt(((_7716 * _7716) + (_7717 * _7717)) + (_7718 * _7718)));
                                  _7734 = ((_7726 * _7716) + _7709);
                                  _7735 = ((_7726 * _7717) + _7710);
                                  _7736 = ((_7726 * _7718) + _7711);
                                } else {
                                  _7734 = _7623;
                                  _7735 = _7624;
                                  _7736 = _7625;
                                }
                                _7738 = rsqrt(dot(float3(_7734, _7735, _7736), float3(_7734, _7735, _7736)));
                                _7739 = _7738 * _7734;
                                _7740 = _7738 * _7735;
                                _7741 = _7738 * _7736;
                                _7742 = _214 * _214;
                                _7746 = saturate((_6444 * (1.0f - _7742)) * _7738);
                                _7748 = saturate(_7738 * f16tof32(_6387));
                                _7750 = rsqrt(dot(float3(_7617, _7618, _7619), float3(_7617, _7618, _7619)));
                                _7754 = dot(float3(_187, _188, _189), float3(_7739, _7740, _7741));
                                _7755 = dot(float3(_187, _188, _189), float3(_444, _445, _443));
                                _7756 = dot(float3(_444, _445, _443), float3(_7739, _7740, _7741));
                                _7759 = rsqrt((_7756 * 2.0f) + 2.0f);
                                _7766 = (_7746 > 0.0f);
                                if (_7766) {
                                  _7770 = sqrt(1.0f - (_7746 * _7746));
                                  _7772 = (_7754 * 2.0f) * _7755;
                                  _7773 = _7772 - _7756;
                                  if (!(_7773 >= _7770)) {
                                    _7781 = rsqrt(1.0f - (_7773 * _7773)) * _7746;
                                    _7784 = _7781 * (_7755 - (_7773 * _7754));
                                    _7785 = _7755 * _7755;
                                    _7790 = _7781 * (((_7785 * 2.0f) + -1.0f) - (_7773 * _7756));
                                    _7799 = sqrt(saturate((((1.0f - (_7754 * _7754)) - _7785) - (_7756 * _7756)) + (_7772 * _7756)));
                                    _7800 = _7799 * _7781;
                                    _7803 = ((_7755 * 2.0f) * _7781) * _7799;
                                    _7805 = (_7770 * _7754) + _7755;
                                    _7806 = _7805 + _7784;
                                    _7807 = _7770 * _7756;
                                    _7809 = (_7807 + 1.0f) + _7790;
                                    _7810 = _7800 * _7809;
                                    _7811 = _7806 * _7809;
                                    _7812 = _7803 * _7806;
                                    _7817 = (((_7806 * 0.25f) * _7803) - (_7810 * 0.5f)) * _7811;
                                    _7831 = (((_7812 - (_7810 * 2.0f)) * _7812) + (_7810 * _7810)) + ((((-0.5f - ((_7809 + _7807) * 0.5f)) * _7811) + ((_7809 * _7809) * _7805)) * _7806);
                                    _7836 = (_7817 * 2.0f) / ((_7831 * _7831) + (_7817 * _7817));
                                    _7837 = _7831 * _7836;
                                    _7839 = 1.0f - (_7817 * _7836);
                                    _7845 = ((_7837 * _7803) + _7807) + (_7839 * _7790);
                                    _7848 = rsqrt((_7845 * 2.0f) + 2.0f);
                                    _7857 = saturate((_7845 * _7848) + _7848);
                                    _7858 = saturate(((_7805 + (_7837 * _7800)) + (_7839 * _7784)) * _7848);
                                  } else {
                                    _7857 = abs(_7755);
                                    _7858 = 1.0f;
                                  }
                                } else {
                                  _7857 = saturate((_7759 * _7756) + _7759);
                                  _7858 = saturate(_7759 * (_7755 + _7754));
                                }
                                _7859 = saturate(_7674);
                                _7861 = _7742 * _7742;
                                if (_7748 > 0.0f) {
                                  _7871 = saturate(((_7748 * _7748) / ((_7857 * 3.5999999046325684f) + 0.4000000059604645f)) + _7861);
                                } else {
                                  _7871 = _7861;
                                }
                                if (_7766) {
                                  _7880 = (((_7746 * 0.25f) * ((sqrt(_7871) * 3.0f) + _7746)) / (_7857 + 0.0010000000474974513f)) + _7871;
                                  _7883 = _7880;
                                  _7884 = (_7871 / _7880);
                                } else {
                                  _7883 = _7871;
                                  _7884 = 1.0f;
                                }
                                if (_7658 < 1.0f) {
                                  _7891 = sqrt((1.000100016593933f - _7658) / max(9.999999974752427e-07f, (_7658 + 1.0f)));
                                  _7904 = (sqrt(_7883 / ((((_7891 * 0.25f) * ((sqrt(_7883) * 3.0f) + _7891)) / (_7857 + 0.0010000000474974513f)) + _7883)) * _7884);
                                } else {
                                  _7904 = _7884;
                                }
                                _7908 = (((_7871 * _7858) - _7858) * _7858) + 1.0f;
                                _7915 = exp2(log2(1.0f - saturate(_7857)) * 5.0f);
                                _7918 = saturate(abs(_7755) + 9.999999747378752e-06f);
                                _7919 = sqrt(_7871);
                                _7920 = 1.0f - _7919;
                                _7932 = saturate((dot(float3(_187, _188, _189), float3((_7750 * _7617), (_7750 * _7618), (_7750 * _7619))) + _6441) / (_6441 + 1.0f));
                                _7935 = ((_7904 * _7859) * (_7871 / (_7908 * _7908))) * (0.5f / ((((_7920 * _7918) + _7919) * _7859) + (((_7920 * _7859) + _7919) * _7918)));
                                _7936 = _7570 * _1650;
                                _7937 = _7571 * _1650;
                                _7938 = _7572 * _1650;
                                _7945 = ((_7615 * _7936) * _7932) + _1587;
                                _7946 = ((_7615 * _7937) * _7932) + _1588;
                                _7947 = ((_7615 * _7938) * _7932) + _1589;
                                if (_6438 > 0.0f) {
                                  _7960 = (_6438 * _1346) * select(_7612, (_7608 * _1273), _7608);
                                  _8454 = _7945;
                                  _8455 = _7946;
                                  _8456 = _7947;
                                  _8457 = (((((_7936 * _1136) * _7960) * ((_7915 * (1.0f - _206)) + _206)) * _7935) + _1590);
                                  _8458 = (((((_7937 * _1137) * _7960) * ((_7915 * (1.0f - _207)) + _207)) * _7935) + _1591);
                                  _8459 = (((((_7938 * _1138) * _7960) * ((_7915 * (1.0f - _208)) + _208)) * _7935) + _1592);
                                } else {
                                  _8454 = _7945;
                                  _8455 = _7946;
                                  _8456 = _7947;
                                  _8457 = _1590;
                                  _8458 = _1591;
                                  _8459 = _1592;
                                }
                              } else {
                                _8454 = _1587;
                                _8455 = _1588;
                                _8456 = _1589;
                                _8457 = _1590;
                                _8458 = _1591;
                                _8459 = _1592;
                              }
                              break;
                            }
                          } else {
                            _8454 = _1587;
                            _8455 = _1588;
                            _8456 = _1589;
                            _8457 = _1590;
                            _8458 = _1591;
                            _8459 = _1592;
                          }
                        } else {
                          if (_1633 == 10) {
                            _7981 = asfloat(srvLightInfoProperties.Load4(_1601)).x;
                            _7982 = asfloat(srvLightInfoProperties.Load4(_1601)).y;
                            _7983 = asfloat(srvLightInfoProperties.Load4(_1601)).z;
                            _7984 = asfloat(srvLightInfoProperties.Load4(_1601)).w;
                            _7987 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).x;
                            _7988 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).y;
                            _7989 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).z;
                            _7990 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 16u)))).w;
                            _7993 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).x;
                            _7994 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).y;
                            _7995 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).z;
                            _7996 = asfloat(srvLightInfoProperties.Load4(((int)(_1601 + 32u)))).w;
                            _7999 = asfloat(srvLightInfoProperties.Load2(((int)(_1601 + 72u)))).x;
                            _8000 = asfloat(srvLightInfoProperties.Load2(((int)(_1601 + 72u)))).y;
                            _8003 = asint(srvLightInfoProperties.Load(((int)(_1601 + 80u))));
                            _8006 = asint(srvLightInfoProperties.Load(((int)(_1601 + 84u))));
                            _8009 = asint(srvLightInfoProperties.Load(((int)(_1601 + 88u))));
                            _8012 = asint(srvLightInfoProperties.Load(((int)(_1601 + 96u))));
                            _8015 = f16tof32(_8003);
                            _8017 = f16tof32(((uint)((uint)(_8006) >> 16)));
                            _8018 = f16tof32(_8006);
                            _8020 = f16tof32(((uint)((uint)(_8009) >> 16)));
                            _8024 = ((float)((uint)((uint)(((uint)(_8009) >> 8) & 255)))) * 0.003921499941498041f;
                            _8026 = (float)((uint)((uint)(_8012 & 65535)));
                            _8030 = mad(_7983, _227, mad(_7982, _226, (_7981 * _225))) + _7984;
                            _8034 = mad(_7989, _227, mad(_7988, _226, (_7987 * _225))) + _7990;
                            _8038 = mad(_7995, _227, mad(_7994, _226, (_7993 * _225))) + _7996;
                            _8041 = mad(_7983, _189, mad(_7982, _188, (_7981 * _187)));
                            _8044 = mad(_7989, _189, mad(_7988, _188, (_7987 * _187)));
                            _8047 = mad(_7995, _189, mad(_7994, _188, (_7993 * _187)));
                            _8059 = -0.0f - mad(_7995, _443, mad(_7994, _445, (_7993 * _444)));
                            _8060 = _7999 * 0.5f;
                            _8061 = _8000 * 0.5f;
                            _8062 = -0.0f - _8060;
                            _8063 = -0.0f - _8061;
                            _8064 = _8062 - _8030;
                            _8065 = _8063 - _8034;
                            _8066 = -0.0f - _8038;
                            _8067 = _8060 - _8030;
                            _8068 = _8061 - _8034;
                            _8069 = dot(float3(_8030, _8034, _8038), float3(_8041, _8044, _8047));
                            _8071 = dot(float3(_8062, _8063, 0.0f), float3(_8041, _8044, _8047)) - _8069;
                            _8073 = dot(float3(_8060, _8063, 0.0f), float3(_8041, _8044, _8047)) - _8069;
                            _8075 = dot(float3(_8060, _8061, 0.0f), float3(_8041, _8044, _8047)) - _8069;
                            _8077 = dot(float3(_8062, _8061, 0.0f), float3(_8041, _8044, _8047)) - _8069;
                            _8078 = min(_8071, _8073);
                            [branch]
                            if (!(!(_8078 >= 0.0f))) {
                              _8084 = rsqrt(dot(float3(_8067, _8065, _8066), float3(_8067, _8065, _8066)) * dot(float3(_8064, _8065, _8066), float3(_8064, _8065, _8066)));
                              _8086 = dot(float3(_8064, _8065, _8066), float3(_8067, _8065, _8066)) * _8084;
                              _8093 = rsqrt(max(((((_8086 * 0.09300000220537186f) + 0.5f) * _8086) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8084;
                              _8100 = (_8093 * (_7999 * _8066));
                              _8101 = (_8093 * (_8065 * (_8062 - _8060)));
                            } else {
                              _8100 = 0.0f;
                              _8101 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_8073, _8075) >= 0.0f))) {
                              _8108 = rsqrt(dot(float3(_8067, _8068, _8066), float3(_8067, _8068, _8066)) * dot(float3(_8067, _8065, _8066), float3(_8067, _8065, _8066)));
                              _8110 = dot(float3(_8067, _8065, _8066), float3(_8067, _8068, _8066)) * _8108;
                              _8117 = rsqrt(max(((((_8110 * 0.09300000220537186f) + 0.5f) * _8110) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8108;
                              _8125 = (_8117 * ((_8063 - _8061) * _8066));
                              _8126 = ((_8117 * (_8000 * _8067)) + _8101);
                            } else {
                              _8125 = 0.0f;
                              _8126 = _8101;
                            }
                            _8127 = min(_8075, _8077);
                            [branch]
                            if (!(!(_8127 >= 0.0f))) {
                              _8133 = rsqrt(dot(float3(_8064, _8068, _8066), float3(_8064, _8068, _8066)) * dot(float3(_8067, _8068, _8066), float3(_8067, _8068, _8066)));
                              _8135 = dot(float3(_8067, _8068, _8066), float3(_8064, _8068, _8066)) * _8133;
                              _8142 = rsqrt(max(((((_8135 * 0.09300000220537186f) + 0.5f) * _8135) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8133;
                              _8151 = ((_8142 * ((_8062 - _8060) * _8066)) + _8100);
                              _8152 = ((_8142 * (_7999 * _8068)) + _8126);
                            } else {
                              _8151 = _8100;
                              _8152 = _8126;
                            }
                            [branch]
                            if (!(!(min(_8077, _8071) >= 0.0f))) {
                              _8159 = rsqrt(dot(float3(_8064, _8065, _8066), float3(_8064, _8065, _8066)) * dot(float3(_8064, _8068, _8066), float3(_8064, _8068, _8066)));
                              _8161 = dot(float3(_8064, _8068, _8066), float3(_8064, _8065, _8066)) * _8159;
                              _8168 = rsqrt(max(((((_8161 * 0.09300000220537186f) + 0.5f) * _8161) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8159;
                              _8177 = ((_8168 * (_8000 * _8066)) + _8125);
                              _8178 = ((_8168 * (_8064 * (_8063 - _8061))) + _8152);
                            } else {
                              _8177 = _8125;
                              _8178 = _8152;
                            }
                            if (min(_8078, _8127) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_8071, _8073), max(_8075, _8077)) >= 0.0f))) {
                                _8187 = -0.0f - _8041;
                                _8188 = _8069 / _8044;
                                _8189 = _8062 / _8044;
                                _8190 = _8060 / _8044;
                                _8192 = (_8063 - _8188) / _8187;
                                _8194 = (_8061 - _8188) / _8187;
                                _8195 = min(_8189, _8190);
                                _8196 = max(_8189, _8190);
                                _8197 = min(_8192, _8194);
                                _8198 = max(_8192, _8194);
                                _8199 = max(_8195, _8197);
                                _8200 = min(_8196, _8198);
                                _8201 = _8199 * _8044;
                                _8203 = _8200 * _8044;
                                _8205 = _8201 - _8030;
                                _8206 = _8188 - _8034;
                                _8207 = _8206 + (_8199 * _8187);
                                _8208 = _8203 - _8030;
                                _8209 = _8206 + (_8200 * _8187);
                                _8210 = dot(float3(_8205, _8207, _8066), float3(_8205, _8207, _8066));
                                _8211 = dot(float3(_8208, _8209, _8066), float3(_8208, _8209, _8066));
                                _8213 = rsqrt(_8211 * _8210);
                                _8215 = dot(float3(_8205, _8207, _8066), float3(_8208, _8209, _8066)) * _8213;
                                _8222 = rsqrt(max(((((_8215 * 0.09300000220537186f) + 0.5f) * _8215) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8213;
                                _8235 = (_8195 > _8197);
                                _8237 = select(_8235, _8044, _8041);
                                _8243 = float((int)(((int)(uint)((int)(_8237 > 0.0f))) - ((int)(uint)((int)(_8237 < 0.0f)))));
                                _8247 = ((1.0f - (((float)((bool)_8235)) * 2.0f)) * _8060) * _8243;
                                _8249 = _8247 - _8030;
                                _8250 = (_8243 * _8061) - _8034;
                                _8251 = (_8196 < _8198);
                                _8253 = select(_8251, _8044, _8041);
                                _8259 = float((int)(((int)(uint)((int)(_8253 > 0.0f))) - ((int)(uint)((int)(_8253 < 0.0f)))));
                                _8260 = _8259 * _8060;
                                _8265 = _8260 - _8030;
                                _8266 = ((((((float)((bool)_8251)) * 2.0f) + -1.0f) * _8061) * _8259) - _8034;
                                _8269 = rsqrt(_8210 * dot(float3(_8249, _8250, _8066), float3(_8249, _8250, _8066)));
                                _8271 = dot(float3(_8249, _8250, _8066), float3(_8205, _8207, _8066)) * _8269;
                                _8278 = rsqrt(max(((((_8271 * 0.09300000220537186f) + 0.5f) * _8271) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8269;
                                _8291 = rsqrt(dot(float3(_8265, _8266, _8066), float3(_8265, _8266, _8066)) * _8211);
                                _8293 = dot(float3(_8208, _8209, _8066), float3(_8265, _8266, _8066)) * _8291;
                                _8300 = rsqrt(max(((((_8293 * 0.09300000220537186f) + 0.5f) * _8293) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8291;
                                _8321 = ((((_8222 * (((_8199 - _8200) * _8187) * _8066)) + _8177) + (_8278 * ((_8250 - _8207) * _8066))) + (_8300 * ((_8209 - _8266) * _8066)));
                                _8322 = ((((_8222 * ((_8044 * (_8200 - _8199)) * _8066)) + _8151) + (_8278 * ((_8201 - _8247) * _8066))) + (_8300 * ((_8260 - _8203) * _8066)));
                                _8323 = ((((_8222 * ((_8209 * _8205) - (_8208 * _8207))) + _8178) + (_8278 * ((_8249 * _8207) - (_8250 * _8205)))) + (_8300 * ((_8266 * _8208) - (_8265 * _8209))));
                              } else {
                                _8321 = _8177;
                                _8322 = _8151;
                                _8323 = _8178;
                              }
                            } else {
                              _8321 = _8177;
                              _8322 = _8151;
                              _8323 = _8178;
                            }
                            _8329 = sqrt(((_8322 * _8322) + (_8321 * _8321)) + (_8323 * _8323));
                            _8330 = _8329 * 0.15915493667125702f;
                            [branch]
                            if (!(_8330 == 0.0f)) {
                              _8339 = saturate((_8330 - _8015) / (1.0f - _8015)) * ((float)((bool)(uint)(_8038 <= 0.0f)));
                              [branch]
                              if (!(_8339 == 0.0f)) {
                                if (_8329 > 0.0f) {
                                  _8347 = (dot(float3(_8041, _8044, _8047), float3(_8321, _8322, _8323)) / _8329);
                                } else {
                                  _8347 = 0.0f;
                                }
                                _8348 = 1.0f - _214;
                                _8349 = _8348 * _8348;
                                _8355 = exp2(log2(1.0f - saturate(dot(float3(_187, _188, _189), float3(_444, _445, _443)))) * 5.0f);
                                _8360 = min(_214, 0.800000011920929f);
                                _8369 = exp2(((((((_8360 * 3.322999954223633f) + -3.7669999599456787f) * _8360) + -0.3479999899864197f) * _8360) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _8376 = _8066 / (_8059 - ((_8047 * 2.0f) * dot(float3((-0.0f - mad(_7983, _443, mad(_7982, _445, (_7981 * _444)))), (-0.0f - mad(_7989, _443, mad(_7988, _445, (_7987 * _444)))), _8059), float3(_8041, _8044, _8047))));
                                _8379 = (_8376 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8369) * saturate((_214 + -0.5f) * 2.500000238418579f)) + _8369);
                                _8387 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8026), ((log2((_8379 * _8379) * f16tof32(((uint)((uint)(_8003) >> 16)))) * 0.5f) + 5.5f));
                                _8389 = (float)((bool)(uint)(_8376 > 0.0f));
                                _8390 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8026), 10.0f);
                                _8399 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8339 * _1273), _8339);
                                if (_8024 > 0.0f) {
                                  _8417 = _8024 * _1346;
                                  _8418 = _8399 * _1650;
                                  _8438 = ((((((_8417 * _8017) * _8389) * _8387.x) * _8418) * (((max(_8349, _206) - _206) * _8355) + _206)) + _1590);
                                  _8439 = ((((((_8417 * _8018) * _8389) * _8387.y) * _8418) * (((max(_8349, _207) - _207) * _8355) + _207)) + _1591);
                                  _8440 = ((((((_8020 * _8417) * _8389) * _8387.z) * _8418) * (((max(_8349, _208) - _208) * _8355) + _208)) + _1592);
                                } else {
                                  _8438 = _1590;
                                  _8439 = _1591;
                                  _8440 = _1592;
                                }
                                _8446 = ((_1650 * 5.4256415367126465f) * _8347) * _8399;
                                _8454 = (((_8390.x * _8017) * _8446) + _1587);
                                _8455 = (((_8390.y * _8018) * _8446) + _1588);
                                _8456 = (((_8390.z * _8020) * _8446) + _1589);
                                _8457 = _8438;
                                _8458 = _8439;
                                _8459 = _8440;
                              } else {
                                _8454 = _1587;
                                _8455 = _1588;
                                _8456 = _1589;
                                _8457 = _1590;
                                _8458 = _1591;
                                _8459 = _1592;
                              }
                            } else {
                              _8454 = _1587;
                              _8455 = _1588;
                              _8456 = _1589;
                              _8457 = _1590;
                              _8458 = _1591;
                              _8459 = _1592;
                            }
                          } else {
                            _8454 = _1587;
                            _8455 = _1588;
                            _8456 = _1589;
                            _8457 = _1590;
                            _8458 = _1591;
                            _8459 = _1592;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _8454 = _1587;
              _8455 = _1588;
              _8456 = _1589;
              _8457 = _1590;
              _8458 = _1591;
              _8459 = _1592;
            }
          } else {
            _8454 = _1587;
            _8455 = _1588;
            _8456 = _1589;
            _8457 = _1590;
            _8458 = _1591;
            _8459 = _1592;
          }
          _8460 = _1593 + 1u;
          if (!(_8460 == _global_2)) {
            _1587 = _8454;
            _1588 = _8455;
            _1589 = _8456;
            _1590 = _8457;
            _1591 = _8458;
            _1592 = _8459;
            _1593 = _8460;
            continue;
          }
          _8464 = _8454;
          _8465 = _8455;
          _8466 = _8456;
          _8467 = _8457;
          _8468 = _8458;
          _8469 = _8459;
          break;
        }
      } else {
        _8464 = _1470;
        _8465 = _1471;
        _8466 = _1472;
        _8467 = _1349;
        _8468 = _1352;
        _8469 = _1355;
      }
      _8471 = rsqrt(dot(float3(_135, _136, -1.0f), float3(_135, _136, -1.0f)));
      _8478 = 1.0f - _214;
      _8489 = (1.0f - _218) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_187, _188, _189), float3((-0.0f - (_135 * _8471)), (-0.0f - (_136 * _8471)), _8471))))) * 5.0f) * (max((_8478 * _8478), _218) - _218));
      _8629 = (_8489 * _8464);
      _8630 = (_8489 * _8465);
      _8631 = (_8489 * _8466);
      _8632 = _8467;
      _8633 = _8468;
      _8634 = _8469;
      _8635 = (_436 * _159);
      _8636 = (_436 * _160);
      _8637 = (_436 * _161);
    } else {
      _8508 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _136, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _135)));
      _8511 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _136, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _135)));
      _8514 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _136, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _135)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _8618 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _8619 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _8620 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _8535 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8508, _8511, _8514), 0.0f);
        _8539 = _8535.x * 32.0f;
        _8540 = _8535.y * 32.0f;
        _8541 = _8535.z * 32.0f;
        _8543 = rsqrt(dot(float3(_8508, _8511, _8514), float3(_8508, _8511, _8514)));
        _8544 = _8543 * _8508;
        _8545 = _8543 * _8511;
        _8546 = _8543 * _8514;
        _8547 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _8548 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _8549 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _8550 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _8551 = dot(float3(_8544, _8545, _8546), float3(_8548, _8549, _8550));
        _8556 = (_8551 * _8551) - (dot(float3(_8548, _8549, _8550), float3(_8548, _8549, _8550)) - (_8547 * _8547));
        if ((_8551 > -0.0f) && (_8556 > 0.0f)) {
          _8561 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _8574 = 74.80000305175781f / ((dot(float3(_8544, _8545, _8546), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8547) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _8582 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8544, _8546), float2(_8561, cbDeferredShading.vSunDirWS.x)) * _8574) + 0.5f), ((dot(float3(_8544, _8545, _8546), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8561)), (cbDeferredShading.vSunDirWS.y * _8561))) * _8574) + 0.5f)), 0.0f);
          _8584 = _8556 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_8584 > 0.0f) {
            _8591 = saturate(_8584 * 5.0f);
            _8618 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8582.x) * _8591) + _8539);
            _8619 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8582.y) * _8591) + _8540);
            _8620 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8582.z) * _8591) + _8541);
          } else {
            _8618 = _8539;
            _8619 = _8540;
            _8620 = _8541;
          }
        } else {
          _8618 = _8539;
          _8619 = _8540;
          _8620 = _8541;
        }
      }
      _8624 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _8629 = 0.0f;
      _8630 = 0.0f;
      _8631 = 0.0f;
      _8632 = select(_8624, 0.0f, _8618);
      _8633 = select(_8624, 0.0f, _8619);
      _8634 = select(_8624, 0.0f, _8620);
      _8635 = 0.0f;
      _8636 = 0.0f;
      _8637 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_64, _65)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_8635 * _8629) + _8632)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_8636 * _8630) + _8633)), 7936.0f), 5.960464477539063e-08f), max(min((((_8637 * _8631) + _8634) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_64, _65)] = float3(0.0f, 0.0f, 0.0f);
  }
}