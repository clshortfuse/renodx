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
  uint _51;
  int _57;
  uint _62;
  uint _63;
  uint _70;
  int _73;
  int _88;
  float _234;
  float _235;
  float _236;
  float _237;
  float _327;
  float _328;
  float _366;
  int _481;
  float _482;
  float _483;
  float _484;
  float _485;
  float _486;
  float _487;
  float _488;
  float _489;
  float _490;
  float _491;
  float _492;
  float _493;
  float _494;
  float _495;
  float _610;
  float _611;
  float _612;
  float _699;
  float _700;
  float _701;
  float _719;
  float _720;
  float _721;
  float _753;
  float _754;
  float _755;
  float _756;
  float _757;
  float _758;
  float _759;
  float _773;
  float _774;
  float _775;
  float _776;
  float _777;
  float _778;
  float _779;
  float _780;
  float _781;
  float _782;
  float _783;
  float _784;
  float _785;
  float _786;
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
  float _801;
  float _802;
  float _803;
  float _804;
  float _853;
  float _854;
  float _855;
  float _875;
  float _876;
  float _877;
  float _888;
  float _889;
  float _890;
  float _891;
  float _892;
  float _893;
  float _896;
  float _897;
  float _898;
  float _899;
  float _900;
  float _901;
  float _902;
  float _916;
  float _917;
  float _918;
  float _919;
  float _920;
  float _921;
  float _950;
  float _951;
  float _952;
  float _972;
  float _973;
  float _974;
  float _985;
  float _986;
  float _987;
  float _988;
  float _989;
  float _990;
  float _1009;
  float _1010;
  float _1011;
  float _1012;
  float _1013;
  float _1014;
  float _1033;
  float _1034;
  float _1035;
  int _1066;
  float _1067;
  float _1185;
  float _1190;
  float _1203;
  float _1256;
  float _1257;
  float _1258;
  float _1311;
  float _1312;
  float _1313;
  float _1423;
  float _1428;
  float _1429;
  float _1430;
  float _1431;
  float _1432;
  float _1433;
  int _1434;
  float _2054;
  float _2055;
  float _2056;
  float _2146;
  float _2155;
  float _2164;
  float _2172;
  float _2243;
  float _2252;
  float _2261;
  float _2269;
  float _2342;
  float _2351;
  float _2360;
  float _2368;
  float _2441;
  float _2450;
  float _2459;
  float _2467;
  float _2519;
  float _2524;
  float _2621;
  float _2642;
  float _2643;
  float _2644;
  int _2663;
  float _2680;
  float _2684;
  float _2723;
  float _2755;
  float _2865;
  float _2866;
  float _2878;
  float _2890;
  float _2953;
  float _3044;
  float _3045;
  float _3046;
  float _3075;
  float _3185;
  float _3186;
  float _3198;
  float _3210;
  float _3265;
  float _3266;
  float _3267;
  float _3298;
  float _3327;
  float _3328;
  float _3329;
  float _3345;
  float _3346;
  float _3347;
  float _3360;
  float _3361;
  float _3362;
  float _3523;
  float _3524;
  float _3525;
  float _3526;
  float _3527;
  float _3528;
  float _3620;
  float _3621;
  float _3622;
  float _3623;
  float _3624;
  float _3727;
  float _3736;
  float _3745;
  float _3753;
  float _3824;
  float _3833;
  float _3842;
  float _3850;
  float _3923;
  float _3932;
  float _3941;
  float _3949;
  float _4022;
  float _4031;
  float _4040;
  float _4048;
  float _4383;
  float _4384;
  int _4385;
  float _4414;
  float _4415;
  float _4416;
  float _4417;
  float _4418;
  float _4520;
  float _4529;
  float _4538;
  float _4546;
  float _4617;
  float _4626;
  float _4635;
  float _4643;
  float _4716;
  float _4725;
  float _4734;
  float _4742;
  float _4815;
  float _4824;
  float _4833;
  float _4841;
  float _5175;
  float _5176;
  bool _5177;
  float _5192;
  float _5193;
  float _5194;
  float _5252;
  float _5253;
  float _5278;
  float _5279;
  float _5374;
  float _5377;
  float _5378;
  float _5398;
  float _5399;
  float _5400;
  int _5418;
  float _5435;
  float _5439;
  float _5466;
  float _5467;
  float _5468;
  float _5499;
  float _5528;
  float _5529;
  float _5530;
  float _5546;
  float _5547;
  float _5548;
  float _5584;
  float _5632;
  float _5633;
  float _5634;
  float _5650;
  float _5710;
  float _5711;
  float _5712;
  float _5833;
  float _5834;
  float _5847;
  float _5859;
  float _5860;
  float _5880;
  float _6058;
  float _6629;
  float _6630;
  float _6631;
  float _6721;
  float _6730;
  float _6739;
  float _6747;
  float _6818;
  float _6827;
  float _6836;
  float _6844;
  float _6917;
  float _6926;
  float _6935;
  float _6943;
  float _7016;
  float _7025;
  float _7034;
  float _7042;
  float _7094;
  float _7099;
  float _7100;
  float _7197;
  float _7198;
  float _7219;
  float _7220;
  float _7221;
  int _7240;
  float _7257;
  float _7265;
  float _7291;
  float _7292;
  float _7293;
  float _7324;
  float _7353;
  float _7354;
  float _7355;
  float _7371;
  float _7372;
  float _7373;
  float _7409;
  float _7457;
  float _7458;
  float _7459;
  float _7475;
  float _7535;
  float _7536;
  float _7537;
  float _7658;
  float _7659;
  float _7672;
  float _7684;
  float _7685;
  float _7705;
  float _7893;
  float _7894;
  float _7918;
  float _7919;
  float _7944;
  float _7945;
  float _7970;
  float _7971;
  float _8114;
  float _8115;
  float _8116;
  float _8140;
  float _8222;
  float _8223;
  float _8224;
  float _8238;
  float _8239;
  float _8240;
  float _8241;
  float _8242;
  float _8243;
  float _8248;
  float _8249;
  float _8250;
  float _8251;
  float _8252;
  float _8253;
  float _8401;
  float _8402;
  float _8403;
  float _8412;
  float _8413;
  float _8414;
  float _8415;
  float _8416;
  float _8417;
  float _8418;
  float _8419;
  float _8420;
  int _84;
  uint _90;
  int _97;
  int _102;
  int _105;
  int _107;
  int _109;
  int _111;
  float4 _116;
  float _124;
  float _125;
  float _133;
  float _134;
  float4 _137;
  float4 _141;
  float4 _147;
  float _158;
  float _162;
  float _163;
  float _167;
  float _169;
  float _170;
  float _175;
  float _176;
  float _178;
  float _179;
  float _180;
  float _181;
  float _190;
  float _197;
  float _198;
  float _199;
  float _200;
  int _206;
  uint _210;
  float _216;
  float4 _225;
  float _246;
  float _247;
  float _262;
  float _263;
  float _266;
  float _267;
  float _270;
  float _271;
  float4 _276;
  float _310;
  float _312;
  bool _313;
  float _315;
  float _317;
  bool _318;
  float4 _331;
  float _335;
  float _347;
  float _348;
  float _349;
  float _350;
  float _351;
  float _352;
  float _367;
  float _368;
  float _370;
  float _371;
  float _372;
  int _380;
  int _381;
  int _382;
  int _383;
  float _387;
  float _389;
  float _390;
  float _400;
  float _405;
  float _409;
  float _410;
  float _413;
  float _426;
  float _427;
  float _428;
  float _432;
  float _447;
  float _450;
  float _453;
  float _456;
  float _459;
  float _462;
  int _498;
  int _499;
  float _502;
  float _503;
  float _504;
  float _505;
  float _508;
  float _509;
  float _510;
  float _511;
  float _514;
  float _515;
  float _516;
  float _517;
  float _520;
  float _521;
  float _522;
  float _523;
  float _526;
  float _527;
  float _528;
  float _529;
  float _532;
  float _533;
  float _534;
  float _535;
  int _538;
  float _541;
  float _542;
  float _543;
  float _546;
  float _547;
  float _548;
  int _551;
  int _554;
  int _557;
  float _586;
  float _589;
  float _592;
  float _593;
  float4 _599;
  float4 _605;
  float _614;
  float _618;
  float _621;
  float _624;
  float _665;
  float _670;
  float _672;
  float _674;
  float _681;
  float _682;
  float4 _688;
  float4 _694;
  float _702;
  float4 _708;
  float4 _714;
  float _731;
  float _732;
  float _733;
  float _734;
  float _735;
  float _736;
  float _737;
  float _738;
  float _739;
  uint _787;
  bool _810;
  int _820;
  float _822;
  float _823;
  float _830;
  float _835;
  float _836;
  bool _837;
  float4 _842;
  float4 _848;
  float _859;
  float4 _864;
  float4 _870;
  float _908;
  int _928;
  float _929;
  float _932;
  float _933;
  bool _934;
  float4 _939;
  float4 _945;
  float _956;
  float4 _961;
  float4 _967;
  float _995;
  float4 _1051;
  float _1054;
  float _1059;
  float _1061;
  float _1062;
  uint _1068;
  int _1071;
  int _1072;
  int _1076;
  int _1080;
  float _1092;
  float _1097;
  float _1098;
  float _1099;
  float _1100;
  float _1103;
  float _1104;
  float _1105;
  float _1106;
  float _1109;
  float _1110;
  float _1111;
  float _1112;
  int _1115;
  int _1118;
  int _1121;
  int _1124;
  float _1139;
  float _1143;
  float _1147;
  float _1172;
  float _1173;
  float _1174;
  float _1177;
  uint _1186;
  float _1192;
  float _1194;
  float _1196;
  int _1206;
  int _1209;
  int _1210;
  int _1211;
  int _1217;
  int _1218;
  int _1219;
  int _1225;
  int _1226;
  int _1227;
  float _1233;
  float _1237;
  float _1241;
  float _1248;
  int _1261;
  int _1264;
  int _1265;
  int _1266;
  int _1272;
  int _1273;
  int _1274;
  int _1280;
  int _1281;
  int _1282;
  float _1288;
  float _1292;
  float _1296;
  float _1303;
  float _1336;
  float _1340;
  float _1344;
  float _1363;
  float _1367;
  float _1371;
  float _1384;
  float _1385;
  float _1386;
  uint _1424;
  int _1436;
  int _1440;
  int _1441;
  int _1442;
  int _1443;
  int _1454;
  int _1458;
  float _1470;
  int _1473;
  float _1490;
  float _1495;
  float _1496;
  float _1497;
  float _1498;
  float _1501;
  float _1502;
  float _1503;
  float _1504;
  float _1507;
  float _1508;
  float _1509;
  float _1510;
  int _1513;
  int _1516;
  int _1519;
  int _1522;
  int _1525;
  float _1527;
  float _1528;
  float _1530;
  float _1534;
  float _1547;
  float _1551;
  float _1555;
  float _1580;
  float _1581;
  float _1582;
  float _1585;
  float _1586;
  float _1593;
  float _1614;
  float _1615;
  float _1616;
  float _1617;
  float _1620;
  float _1621;
  float _1622;
  float _1623;
  float _1626;
  float _1627;
  float _1628;
  float _1629;
  float _1632;
  float _1633;
  float _1634;
  float _1637;
  int _1640;
  int _1643;
  int _1646;
  int _1649;
  int _1652;
  float _1655;
  float _1656;
  float _1657;
  float _1658;
  int _1661;
  int _1664;
  int _1667;
  int _1670;
  int _1673;
  int _1676;
  int _1679;
  int _1682;
  float _1684;
  float _1685;
  float _1687;
  float _1691;
  float _1694;
  float _1696;
  int _1699;
  float _1709;
  float _1710;
  float _1712;
  float _1713;
  float _1714;
  float _1715;
  float _1734;
  float _1738;
  float _1739;
  float _1740;
  float _1744;
  float _1748;
  float _1752;
  float _1753;
  float _1776;
  float _1777;
  float _1778;
  float _1781;
  float _1782;
  float _1789;
  float _1790;
  float _1791;
  float _1796;
  float _1798;
  float _1799;
  float _1802;
  float _1806;
  float _1815;
  float _1816;
  float _1817;
  int _1818;
  float _1823;
  float _1832;
  float _1833;
  float _1835;
  float4 _1840;
  float _1845;
  float _1847;
  float _1849;
  float _1851;
  float _1855;
  float _1857;
  float _1861;
  float _1863;
  int _1870;
  float _1875;
  float _1884;
  float _1885;
  float4 _1891;
  float _1896;
  float _1898;
  float _1902;
  float _1904;
  float _1908;
  float _1910;
  float _1914;
  float _1916;
  int _1923;
  float _1928;
  float _1937;
  float _1938;
  float4 _1944;
  float _1949;
  float _1951;
  float _1955;
  float _1957;
  float _1961;
  float _1963;
  float _1967;
  float _1969;
  int _1976;
  float _1981;
  float _1990;
  float _1991;
  float4 _1997;
  float _2002;
  float _2004;
  float _2008;
  float _2010;
  float _2014;
  float _2016;
  float _2020;
  float _2022;
  float _2023;
  float _2034;
  float _2040;
  float _2042;
  float _2044;
  float _2051;
  float _2059;
  float _2060;
  float _2069;
  float _2073;
  float _2082;
  float _2083;
  float _2084;
  float _2089;
  int _2090;
  float _2095;
  float _2104;
  float _2105;
  float _2107;
  float _2109;
  float _2110;
  float4 _2112;
  float _2116;
  float _2117;
  float _2120;
  float _2121;
  float _2126;
  float _2127;
  float _2130;
  float _2131;
  float _2133;
  float _2135;
  bool _2136;
  bool _2137;
  bool _2147;
  bool _2156;
  float _2173;
  float _2175;
  float _2177;
  float _2179;
  float _2183;
  float _2185;
  float _2189;
  float _2191;
  int _2198;
  float _2203;
  float _2212;
  float _2213;
  float _2216;
  float _2217;
  float4 _2219;
  float _2223;
  float _2224;
  float _2227;
  float _2228;
  float _2230;
  float _2232;
  bool _2233;
  bool _2234;
  bool _2244;
  bool _2253;
  float _2270;
  float _2272;
  float _2276;
  float _2278;
  float _2282;
  float _2284;
  float _2288;
  float _2290;
  int _2297;
  float _2302;
  float _2311;
  float _2312;
  float _2315;
  float _2316;
  float4 _2318;
  float _2322;
  float _2323;
  float _2326;
  float _2327;
  float _2329;
  float _2331;
  bool _2332;
  bool _2333;
  bool _2343;
  bool _2352;
  float _2369;
  float _2371;
  float _2375;
  float _2377;
  float _2381;
  float _2383;
  float _2387;
  float _2389;
  int _2396;
  float _2401;
  float _2410;
  float _2411;
  float _2414;
  float _2415;
  float4 _2417;
  float _2421;
  float _2422;
  float _2425;
  float _2426;
  float _2428;
  float _2430;
  bool _2431;
  bool _2432;
  bool _2442;
  bool _2451;
  float _2468;
  float _2470;
  float _2474;
  float _2476;
  float _2480;
  float _2482;
  float _2486;
  float _2488;
  float _2489;
  float _2500;
  float _2506;
  float _2508;
  float _2510;
  float _2530;
  float4 _2537;
  float _2551;
  float _2552;
  float _2553;
  float _2554;
  float _2556;
  float _2561;
  float _2564;
  float _2565;
  float _2567;
  float _2568;
  float _2573;
  float _2578;
  float _2580;
  float _2583;
  float _2584;
  float _2589;
  float _2591;
  float _2593;
  float _2595;
  float _2600;
  float _2606;
  float _2608;
  float3 _2634;
  float _2645;
  float4 _2666;
  int _2694;
  int _2699;
  int _2701;
  int _2702;
  int _2704;
  int _2705;
  int _2714;
  bool _2727;
  float _2730;
  float _2732;
  float _2733;
  float _2734;
  float _2735;
  float _2736;
  float _2737;
  float _2745;
  float _2750;
  float _2756;
  float _2760;
  float _2762;
  float _2763;
  float _2764;
  float _2767;
  bool _2774;
  float _2778;
  float _2780;
  float _2781;
  float _2789;
  float _2792;
  float _2793;
  float _2798;
  float _2807;
  float _2808;
  float _2811;
  float _2813;
  float _2814;
  float _2815;
  float _2817;
  float _2818;
  float _2819;
  float _2820;
  float _2825;
  float _2839;
  float _2844;
  float _2845;
  float _2847;
  float _2853;
  float _2856;
  float _2867;
  float _2868;
  float _2879;
  float _2894;
  float _2899;
  float _2900;
  float _2912;
  float _2915;
  float _2916;
  float _2917;
  float _2918;
  float _2925;
  float _2926;
  float _2927;
  float _2935;
  float _2936;
  float _2956;
  float _2957;
  float _2958;
  float _2959;
  float _2962;
  float _2963;
  float _2964;
  float _2965;
  float _2968;
  float _2969;
  float _2970;
  int _2973;
  int _2976;
  int _2979;
  int _2982;
  int _2985;
  int _2988;
  float _2992;
  float _2995;
  float _2997;
  int _2999;
  float2 _3019;
  float3 _3036;
  float _3049;
  float _3052;
  float _3053;
  float _3054;
  float _3055;
  float _3056;
  float _3057;
  float _3065;
  float _3070;
  float _3076;
  float _3080;
  float _3082;
  float _3083;
  float _3084;
  float _3087;
  bool _3094;
  float _3098;
  float _3100;
  float _3101;
  float _3109;
  float _3112;
  float _3113;
  float _3118;
  float _3127;
  float _3128;
  float _3131;
  float _3133;
  float _3134;
  float _3135;
  float _3137;
  float _3138;
  float _3139;
  float _3140;
  float _3145;
  float _3159;
  float _3164;
  float _3165;
  float _3167;
  float _3173;
  float _3176;
  float _3187;
  float _3188;
  float _3199;
  float _3214;
  float _3226;
  float _3227;
  float _3239;
  float _3255;
  bool _3268;
  float _3269;
  float _3270;
  float _3271;
  bool _3272;
  float _3274;
  float _3275;
  float _3279;
  float _3285;
  float _3299;
  float _3300;
  float _3303;
  float _3307;
  int _3308;
  float _3310;
  float _3312;
  float _3315;
  float _3319;
  float _3330;
  float _3331;
  float _3332;
  float _3334;
  float _3348;
  float _3349;
  float _3350;
  float _3366;
  float _3367;
  float _3368;
  float _3372;
  float _3384;
  float _3385;
  float _3386;
  float _3389;
  float _3390;
  float _3391;
  float _3394;
  float _3395;
  float _3396;
  float _3399;
  float _3400;
  float _3401;
  float _3404;
  float _3405;
  float _3406;
  int _3409;
  int _3412;
  int _3415;
  int _3418;
  int _3421;
  int _3424;
  int _3427;
  int _3430;
  int _3433;
  int _3436;
  int _3439;
  float _3442;
  float _3443;
  float _3444;
  float _3445;
  int _3448;
  int _3451;
  int _3454;
  int _3457;
  float _3459;
  float _3460;
  float _3462;
  float _3466;
  float _3469;
  float _3470;
  float _3472;
  float _3476;
  float _3478;
  float _3479;
  float _3481;
  int _3484;
  bool _3488;
  float _3496;
  float _3497;
  float _3499;
  float _3502;
  float _3503;
  float _3505;
  float _3506;
  float _3508;
  float _3509;
  float _3513;
  float _3519;
  float _3520;
  float _3521;
  float _3532;
  float _3533;
  float _3534;
  float _3535;
  float _3536;
  float _3537;
  float _3538;
  float _3539;
  float _3540;
  float _3543;
  float _3544;
  float _3545;
  float _3548;
  float _3555;
  float _3568;
  float _3572;
  float _3576;
  float _3577;
  float _3578;
  float _3581;
  float _3584;
  bool _3586;
  float _3592;
  float _3593;
  float _3594;
  float _3599;
  float _3600;
  float _3601;
  bool _3605;
  bool _3611;
  bool _3615;
  float _3625;
  float _3629;
  float _3638;
  float _3639;
  float _3646;
  float _3647;
  float _3650;
  float _3654;
  float _3663;
  float _3664;
  float _3665;
  float _3670;
  int _3671;
  float _3676;
  float _3685;
  float _3686;
  float _3688;
  float _3690;
  float _3691;
  float4 _3693;
  float _3697;
  float _3698;
  float _3701;
  float _3702;
  float _3707;
  float _3708;
  float _3711;
  float _3712;
  float _3714;
  float _3716;
  bool _3717;
  bool _3718;
  bool _3728;
  bool _3737;
  float _3754;
  float _3756;
  float _3758;
  float _3760;
  float _3764;
  float _3766;
  float _3770;
  float _3772;
  int _3779;
  float _3784;
  float _3793;
  float _3794;
  float _3797;
  float _3798;
  float4 _3800;
  float _3804;
  float _3805;
  float _3808;
  float _3809;
  float _3811;
  float _3813;
  bool _3814;
  bool _3815;
  bool _3825;
  bool _3834;
  float _3851;
  float _3853;
  float _3857;
  float _3859;
  float _3863;
  float _3865;
  float _3869;
  float _3871;
  int _3878;
  float _3883;
  float _3892;
  float _3893;
  float _3896;
  float _3897;
  float4 _3899;
  float _3903;
  float _3904;
  float _3907;
  float _3908;
  float _3910;
  float _3912;
  bool _3913;
  bool _3914;
  bool _3924;
  bool _3933;
  float _3950;
  float _3952;
  float _3956;
  float _3958;
  float _3962;
  float _3964;
  float _3968;
  float _3970;
  int _3977;
  float _3982;
  float _3991;
  float _3992;
  float _3995;
  float _3996;
  float4 _3998;
  float _4002;
  float _4003;
  float _4006;
  float _4007;
  float _4009;
  float _4011;
  bool _4012;
  bool _4013;
  bool _4023;
  bool _4032;
  float _4049;
  float _4051;
  float _4055;
  float _4057;
  float _4061;
  float _4063;
  float _4067;
  float _4069;
  float _4070;
  float _4081;
  float _4087;
  float _4089;
  float _4091;
  float _4100;
  float _4103;
  float _4104;
  float _4118;
  float _4119;
  float _4120;
  float _4124;
  float _4133;
  float _4134;
  float _4135;
  int _4136;
  float _4141;
  float _4150;
  float _4151;
  float _4153;
  float4 _4158;
  float _4163;
  float _4165;
  float _4167;
  float _4169;
  float _4173;
  float _4175;
  float _4179;
  float _4181;
  int _4188;
  float _4193;
  float _4202;
  float _4203;
  float4 _4209;
  float _4214;
  float _4216;
  float _4220;
  float _4222;
  float _4226;
  float _4228;
  float _4232;
  float _4234;
  int _4241;
  float _4246;
  float _4255;
  float _4256;
  float4 _4262;
  float _4267;
  float _4269;
  float _4273;
  float _4275;
  float _4279;
  float _4281;
  float _4285;
  float _4287;
  int _4294;
  float _4299;
  float _4308;
  float _4309;
  float4 _4315;
  float _4320;
  float _4322;
  float _4326;
  float _4328;
  float _4332;
  float _4334;
  float _4338;
  float _4340;
  float _4341;
  float _4352;
  float _4358;
  float _4360;
  float _4362;
  float _4370;
  float _4377;
  float _4379;
  float _4393;
  float _4394;
  float _4395;
  bool _4399;
  bool _4405;
  bool _4409;
  float _4419;
  float _4424;
  float _4433;
  float _4434;
  float _4439;
  float _4440;
  float _4443;
  float _4447;
  float _4456;
  float _4457;
  float _4458;
  float _4463;
  int _4464;
  float _4469;
  float _4478;
  float _4479;
  float _4481;
  float _4483;
  float _4484;
  float4 _4486;
  float _4490;
  float _4491;
  float _4494;
  float _4495;
  float _4500;
  float _4501;
  float _4504;
  float _4505;
  float _4507;
  float _4509;
  bool _4510;
  bool _4511;
  bool _4521;
  bool _4530;
  float _4547;
  float _4549;
  float _4551;
  float _4553;
  float _4557;
  float _4559;
  float _4563;
  float _4565;
  int _4572;
  float _4577;
  float _4586;
  float _4587;
  float _4590;
  float _4591;
  float4 _4593;
  float _4597;
  float _4598;
  float _4601;
  float _4602;
  float _4604;
  float _4606;
  bool _4607;
  bool _4608;
  bool _4618;
  bool _4627;
  float _4644;
  float _4646;
  float _4650;
  float _4652;
  float _4656;
  float _4658;
  float _4662;
  float _4664;
  int _4671;
  float _4676;
  float _4685;
  float _4686;
  float _4689;
  float _4690;
  float4 _4692;
  float _4696;
  float _4697;
  float _4700;
  float _4701;
  float _4703;
  float _4705;
  bool _4706;
  bool _4707;
  bool _4717;
  bool _4726;
  float _4743;
  float _4745;
  float _4749;
  float _4751;
  float _4755;
  float _4757;
  float _4761;
  float _4763;
  int _4770;
  float _4775;
  float _4784;
  float _4785;
  float _4788;
  float _4789;
  float4 _4791;
  float _4795;
  float _4796;
  float _4799;
  float _4800;
  float _4802;
  float _4804;
  bool _4805;
  bool _4806;
  bool _4816;
  bool _4825;
  float _4842;
  float _4844;
  float _4848;
  float _4850;
  float _4854;
  float _4856;
  float _4860;
  float _4862;
  float _4863;
  float _4874;
  float _4880;
  float _4882;
  float _4884;
  float _4893;
  float _4896;
  float _4897;
  float _4910;
  float _4911;
  float _4912;
  float _4916;
  float _4925;
  float _4926;
  float _4927;
  int _4928;
  float _4933;
  float _4942;
  float _4943;
  float _4945;
  float4 _4950;
  float _4955;
  float _4957;
  float _4959;
  float _4961;
  float _4965;
  float _4967;
  float _4971;
  float _4973;
  int _4980;
  float _4985;
  float _4994;
  float _4995;
  float4 _5001;
  float _5006;
  float _5008;
  float _5012;
  float _5014;
  float _5018;
  float _5020;
  float _5024;
  float _5026;
  int _5033;
  float _5038;
  float _5047;
  float _5048;
  float4 _5054;
  float _5059;
  float _5061;
  float _5065;
  float _5067;
  float _5071;
  float _5073;
  float _5077;
  float _5079;
  int _5086;
  float _5091;
  float _5100;
  float _5101;
  float4 _5107;
  float _5112;
  float _5114;
  float _5118;
  float _5120;
  float _5124;
  float _5126;
  float _5130;
  float _5132;
  float _5133;
  float _5144;
  float _5150;
  float _5152;
  float _5154;
  float _5162;
  float _5169;
  float _5171;
  float _5197;
  float _5199;
  float _5200;
  float _5201;
  float _5216;
  float _5219;
  float _5222;
  float _5224;
  float _5225;
  float _5226;
  float _5227;
  float _5235;
  float _5236;
  float _5237;
  bool _5239;
  float _5259;
  float4 _5284;
  float _5304;
  float _5305;
  float _5306;
  float _5307;
  float _5309;
  float _5314;
  float _5317;
  float _5318;
  float _5320;
  float _5321;
  float _5326;
  float _5331;
  float _5333;
  float _5336;
  float _5337;
  float _5342;
  float _5344;
  float _5346;
  float _5348;
  float _5353;
  float _5359;
  float _5361;
  float3 _5390;
  float4 _5421;
  float _5456;
  bool _5469;
  float _5470;
  float _5471;
  float _5472;
  bool _5473;
  float _5475;
  float _5476;
  float _5480;
  float _5486;
  float _5500;
  float _5501;
  float _5504;
  float _5508;
  int _5509;
  float _5511;
  float _5513;
  float _5516;
  float _5520;
  float _5531;
  float _5532;
  float _5533;
  float _5535;
  int _5555;
  int _5560;
  int _5562;
  int _5563;
  int _5565;
  int _5566;
  int _5575;
  bool _5588;
  float _5591;
  float _5593;
  float _5594;
  float _5595;
  float _5596;
  float _5597;
  float _5598;
  float _5599;
  float _5600;
  float _5601;
  float _5602;
  float _5603;
  float _5604;
  bool _5605;
  float _5606;
  float _5607;
  float _5610;
  float _5611;
  float _5613;
  float _5640;
  float _5645;
  float _5652;
  float _5653;
  float _5654;
  float _5656;
  float _5660;
  float _5661;
  float _5662;
  float _5663;
  float _5664;
  float _5665;
  float _5666;
  float _5672;
  float _5681;
  float _5685;
  float _5686;
  float _5687;
  float _5688;
  float _5692;
  float _5693;
  float _5694;
  float _5702;
  float _5714;
  float _5715;
  float _5716;
  float _5717;
  float _5718;
  float _5722;
  float _5724;
  float _5726;
  float _5730;
  float _5731;
  float _5732;
  float _5735;
  bool _5742;
  float _5746;
  float _5748;
  float _5749;
  float _5757;
  float _5760;
  float _5761;
  float _5766;
  float _5775;
  float _5776;
  float _5779;
  float _5781;
  float _5782;
  float _5783;
  float _5785;
  float _5786;
  float _5787;
  float _5788;
  float _5793;
  float _5807;
  float _5812;
  float _5813;
  float _5815;
  float _5821;
  float _5824;
  float _5835;
  float _5837;
  float _5856;
  float _5867;
  float _5884;
  float _5889;
  float _5890;
  float _5891;
  float _5903;
  float _5906;
  float _5907;
  float _5908;
  float _5909;
  float _5916;
  float _5917;
  float _5918;
  float _5927;
  float _5928;
  float _5949;
  float _5950;
  float _5951;
  float _5954;
  float _5955;
  float _5956;
  float _5959;
  int _5962;
  int _5965;
  int _5968;
  float _5977;
  float _5980;
  float _5983;
  float _5990;
  float _5995;
  float _5997;
  float _5999;
  float _6000;
  float _6001;
  float _6003;
  float _6004;
  float _6005;
  float _6008;
  float _6009;
  float _6010;
  float _6013;
  float _6020;
  int _6029;
  int _6034;
  int _6036;
  int _6037;
  int _6039;
  int _6040;
  int _6049;
  bool _6062;
  float _6064;
  float _6065;
  float _6066;
  float _6067;
  float _6070;
  float _6073;
  float _6074;
  float _6075;
  float _6076;
  float _6080;
  float _6085;
  float _6086;
  float _6087;
  float _6099;
  float _6101;
  float _6102;
  float _6103;
  float _6104;
  float _6111;
  float _6112;
  float _6113;
  float _6125;
  float _6128;
  float _6149;
  float _6150;
  float _6151;
  float _6154;
  float _6155;
  float _6156;
  float _6159;
  float _6160;
  float _6161;
  float _6164;
  float _6165;
  float _6166;
  float _6169;
  float _6170;
  float _6171;
  float _6174;
  float _6175;
  float _6176;
  int _6179;
  int _6182;
  int _6185;
  int _6188;
  float _6191;
  float _6192;
  float _6193;
  float _6194;
  int _6197;
  int _6200;
  int _6203;
  int _6206;
  int _6209;
  int _6212;
  int _6215;
  float _6218;
  float _6219;
  float _6220;
  float _6221;
  int _6224;
  int _6227;
  int _6230;
  float _6232;
  float _6233;
  float _6235;
  float _6239;
  float _6242;
  float _6243;
  float _6245;
  float _6249;
  int _6253;
  float _6269;
  float _6270;
  float _6272;
  float _6273;
  float _6274;
  float _6275;
  float _6276;
  float _6277;
  float _6278;
  float _6279;
  float _6280;
  float _6281;
  float _6282;
  float _6283;
  float _6284;
  float _6287;
  float _6288;
  float _6289;
  float _6292;
  float _6303;
  float _6307;
  float _6314;
  float _6315;
  float _6316;
  float _6328;
  float _6329;
  float _6330;
  float _6331;
  float _6334;
  float _6335;
  float _6338;
  float _6339;
  float _6346;
  float _6348;
  float _6354;
  bool _6356;
  float _6364;
  float _6365;
  float _6366;
  float _6371;
  float _6373;
  float _6374;
  float _6377;
  float _6381;
  float _6390;
  float _6391;
  float _6392;
  int _6393;
  float _6398;
  float _6407;
  float _6408;
  float _6410;
  float4 _6415;
  float _6420;
  float _6422;
  float _6424;
  float _6426;
  float _6430;
  float _6432;
  float _6436;
  float _6438;
  int _6445;
  float _6450;
  float _6459;
  float _6460;
  float4 _6466;
  float _6471;
  float _6473;
  float _6477;
  float _6479;
  float _6483;
  float _6485;
  float _6489;
  float _6491;
  int _6498;
  float _6503;
  float _6512;
  float _6513;
  float4 _6519;
  float _6524;
  float _6526;
  float _6530;
  float _6532;
  float _6536;
  float _6538;
  float _6542;
  float _6544;
  int _6551;
  float _6556;
  float _6565;
  float _6566;
  float4 _6572;
  float _6577;
  float _6579;
  float _6583;
  float _6585;
  float _6589;
  float _6591;
  float _6595;
  float _6597;
  float _6598;
  float _6609;
  float _6615;
  float _6617;
  float _6619;
  float _6626;
  float _6634;
  float _6635;
  float _6644;
  float _6648;
  float _6657;
  float _6658;
  float _6659;
  float _6664;
  int _6665;
  float _6670;
  float _6679;
  float _6680;
  float _6682;
  float _6684;
  float _6685;
  float4 _6687;
  float _6691;
  float _6692;
  float _6695;
  float _6696;
  float _6701;
  float _6702;
  float _6705;
  float _6706;
  float _6708;
  float _6710;
  bool _6711;
  bool _6712;
  bool _6722;
  bool _6731;
  float _6748;
  float _6750;
  float _6752;
  float _6754;
  float _6758;
  float _6760;
  float _6764;
  float _6766;
  int _6773;
  float _6778;
  float _6787;
  float _6788;
  float _6791;
  float _6792;
  float4 _6794;
  float _6798;
  float _6799;
  float _6802;
  float _6803;
  float _6805;
  float _6807;
  bool _6808;
  bool _6809;
  bool _6819;
  bool _6828;
  float _6845;
  float _6847;
  float _6851;
  float _6853;
  float _6857;
  float _6859;
  float _6863;
  float _6865;
  int _6872;
  float _6877;
  float _6886;
  float _6887;
  float _6890;
  float _6891;
  float4 _6893;
  float _6897;
  float _6898;
  float _6901;
  float _6902;
  float _6904;
  float _6906;
  bool _6907;
  bool _6908;
  bool _6918;
  bool _6927;
  float _6944;
  float _6946;
  float _6950;
  float _6952;
  float _6956;
  float _6958;
  float _6962;
  float _6964;
  int _6971;
  float _6976;
  float _6985;
  float _6986;
  float _6989;
  float _6990;
  float4 _6992;
  float _6996;
  float _6997;
  float _7000;
  float _7001;
  float _7003;
  float _7005;
  bool _7006;
  bool _7007;
  bool _7017;
  bool _7026;
  float _7043;
  float _7045;
  float _7049;
  float _7051;
  float _7055;
  float _7057;
  float _7061;
  float _7063;
  float _7064;
  float _7075;
  float _7081;
  float _7083;
  float _7085;
  float _7106;
  float4 _7113;
  float _7127;
  float _7128;
  float _7129;
  float _7130;
  float _7132;
  float _7137;
  float _7140;
  float _7141;
  float _7143;
  float _7144;
  float _7149;
  float _7154;
  float _7156;
  float _7159;
  float _7160;
  float _7165;
  float _7167;
  float _7169;
  float _7171;
  float _7176;
  float _7182;
  float _7184;
  float3 _7211;
  float _7222;
  float4 _7243;
  float _7281;
  bool _7294;
  float _7295;
  float _7296;
  float _7297;
  bool _7298;
  float _7300;
  float _7301;
  float _7305;
  float _7311;
  float _7325;
  float _7326;
  float _7329;
  float _7333;
  int _7334;
  float _7336;
  float _7338;
  float _7341;
  float _7345;
  float _7356;
  float _7357;
  float _7358;
  float _7360;
  int _7380;
  int _7385;
  int _7387;
  int _7388;
  int _7390;
  int _7391;
  int _7400;
  bool _7413;
  float _7416;
  float _7418;
  float _7419;
  float _7420;
  float _7421;
  float _7422;
  float _7423;
  float _7424;
  float _7425;
  float _7426;
  float _7427;
  float _7428;
  float _7429;
  bool _7430;
  float _7431;
  float _7432;
  float _7435;
  float _7436;
  float _7438;
  float _7465;
  float _7470;
  float _7477;
  float _7478;
  float _7479;
  float _7481;
  float _7485;
  float _7486;
  float _7487;
  float _7488;
  float _7489;
  float _7490;
  float _7491;
  float _7497;
  float _7506;
  float _7510;
  float _7511;
  float _7512;
  float _7513;
  float _7517;
  float _7518;
  float _7519;
  float _7527;
  float _7539;
  float _7540;
  float _7541;
  float _7542;
  float _7543;
  float _7547;
  float _7549;
  float _7551;
  float _7555;
  float _7556;
  float _7557;
  float _7560;
  bool _7567;
  float _7571;
  float _7573;
  float _7574;
  float _7582;
  float _7585;
  float _7586;
  float _7591;
  float _7600;
  float _7601;
  float _7604;
  float _7606;
  float _7607;
  float _7608;
  float _7610;
  float _7611;
  float _7612;
  float _7613;
  float _7618;
  float _7632;
  float _7637;
  float _7638;
  float _7640;
  float _7646;
  float _7649;
  float _7660;
  float _7662;
  float _7681;
  float _7692;
  float _7709;
  float _7714;
  float _7715;
  float _7716;
  float _7728;
  float _7731;
  float _7732;
  float _7733;
  float _7734;
  float _7741;
  float _7742;
  float _7743;
  float _7752;
  float _7753;
  float _7774;
  float _7775;
  float _7776;
  float _7777;
  float _7780;
  float _7781;
  float _7782;
  float _7783;
  float _7786;
  float _7787;
  float _7788;
  float _7789;
  float _7792;
  float _7793;
  int _7796;
  int _7799;
  int _7802;
  int _7805;
  float _7808;
  float _7810;
  float _7811;
  float _7813;
  float _7817;
  float _7819;
  float _7823;
  float _7827;
  float _7831;
  float _7834;
  float _7837;
  float _7840;
  float _7852;
  float _7853;
  float _7854;
  float _7855;
  float _7856;
  float _7857;
  float _7858;
  float _7859;
  float _7860;
  float _7861;
  float _7862;
  float _7864;
  float _7866;
  float _7868;
  float _7870;
  float _7871;
  float _7877;
  float _7879;
  float _7886;
  float _7901;
  float _7903;
  float _7910;
  float _7920;
  float _7926;
  float _7928;
  float _7935;
  float _7952;
  float _7954;
  float _7961;
  float _7980;
  float _7981;
  float _7982;
  float _7983;
  float _7985;
  float _7987;
  float _7988;
  float _7989;
  float _7990;
  float _7991;
  float _7992;
  float _7993;
  float _7994;
  float _7996;
  float _7998;
  float _7999;
  float _8000;
  float _8001;
  float _8002;
  float _8003;
  float _8004;
  float _8006;
  float _8008;
  float _8015;
  bool _8028;
  float _8030;
  float _8036;
  float _8040;
  float _8042;
  float _8043;
  bool _8044;
  float _8046;
  float _8052;
  float _8053;
  float _8058;
  float _8059;
  float _8062;
  float _8064;
  float _8071;
  float _8084;
  float _8086;
  float _8093;
  float _8122;
  float _8123;
  float _8132;
  float _8141;
  float _8146;
  float _8155;
  float _8162;
  float _8165;
  float4 _8173;
  float _8175;
  float4 _8176;
  float _8185;
  float _8201;
  float _8202;
  float _8230;
  uint _8244;
  float _8255;
  float _8262;
  float _8272;
  float _8291;
  float _8294;
  float _8297;
  float4 _8318;
  float _8322;
  float _8323;
  float _8324;
  float _8326;
  float _8327;
  float _8328;
  float _8329;
  float _8330;
  float _8331;
  float _8332;
  float _8333;
  float _8334;
  float _8339;
  float _8344;
  float _8357;
  float4 _8365;
  float _8367;
  float _8374;
  bool _8407;
  int __loop_jump_target = -1;
  _51 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _57 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _62 = ((uint)(((int)(_57 << 3)) & 524280)) + SV_GroupThreadID.x;
  _63 = ((uint)(((uint)(_57) >> 16) << 3)) + SV_GroupThreadID.y;
  _70 = ((int)((((uint)(_63) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_62) >> 4)))) << 6;
  _73 = srvDeferredClusters[_70];
  if (_51 == 0) {
    _global_2 = (_73 & 255);
    _global_0 = (((uint)(_73) >> 16) & 255);
    _global_1 = (((uint)(_73) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _84 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_84 == 0)) {
    _88 = 0;
    while(true) {
      _90 = (_88 << 6) + _51;
      if ((uint)_90 < (uint)_global_2) {
        _97 = srvDeferredClusters[((int)(((uint)(_70 | 1)) + _90))];
        _global_3[min((uint)(_90), 63u)] = _97;
        _102 = _97 & 4095;
        _105 = srvLightInfoBase[_102].nFlags;
        _107 = srvLightInfoBase[_102].nRoomMask;
        _109 = srvLightInfoBase[_102].nBufferOffset;
        _global_4[min((uint)(_90), 63u)] = _105;
        _global_5[min((uint)(_90), 63u)] = _107;
        _global_6[min((uint)(_90), 63u)] = _109;
      }
      _111 = _88 + 1;
      if (!(_111 == _84)) {
        _88 = _111;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _116 = srvGlobalGBuffer0.Load(int3(_62, _63, 0));
  [branch]
  if (_116.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_62, _63)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_62, _63)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _124 = (float)((uint)_62);
    _125 = (float)((uint)_63);
    _133 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _124) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
    _134 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _125) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
    [branch]
    if (_116.x > 0.0f) {
      _137 = srvGlobalGBuffer1.Load(int3(_62, _63, 0));
      _141 = srvGlobalGBuffer2.Load(int3(_62, _63, 0));
      _147 = srvGlobalGBuffer4.Load(int3(_62, _63, 0));
      _158 = saturate(_147.y);
      _162 = (saturate(_137.x) * 2.0f) + -1.0f;
      _163 = (saturate(_137.y) * 2.0f) + -1.0f;
      _167 = (1.0f - abs(_162)) - abs(_163);
      _169 = saturate(-0.0f - _167);
      _170 = -0.0f - _169;
      _175 = select((_162 >= 0.0f), _170, _169) + _162;
      _176 = select((_163 >= 0.0f), _170, _169) + _163;
      _178 = rsqrt(dot(float3(_175, _176, _167), float3(_175, _176, _167)));
      _179 = _175 * _178;
      _180 = _176 * _178;
      _181 = _178 * _167;
      _190 = min(1.0f, max(saturate(_147.x), 0.019999999552965164f));
      _197 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _116.x) - cbSharedPerViewData.vViewRemap.y);
      _198 = _197 * _133;
      _199 = _197 * _134;
      _200 = -0.0f - _197;
      _206 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _210 = srvReflectionsWeight.Load(int3(((uint)(_62) >> _206), ((uint)(_63) >> _206), 0));
      _216 = ((float)((uint)((uint)(_210.x & 254)))) * 0.003921568859368563f;
      if ((_210.x & 1) == 0) {
        _225 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _124), (cbSharedPerViewData.vViewportSize.y * _125)), 0.0f);
        _234 = (1.0f - _216);
        _235 = (_225.x * _216);
        _236 = (_225.y * _216);
        _237 = (_225.z * _216);
      } else {
        _234 = 1.0f;
        _235 = 0.0f;
        _236 = 0.0f;
        _237 = 0.0f;
      }
      _246 = cbSharedPerViewData.vViewportSize.x * (_124 + 0.5f);
      _247 = cbSharedPerViewData.vViewportSize.y * (_125 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _262 = (floor((_246 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _263 = (floor((_247 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _266 = max(_262, cbDeferredShading.vScreenPixelSize.z);
        _267 = max(_263, cbDeferredShading.vScreenPixelSize.w);
        _270 = min((_262 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _271 = min((_263 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _276 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_266 + cbDeferredShading.vScreenPixelSize.z), (_267 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _276.x) - cbSharedPerViewData.vViewRemap.y)) - _197) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _276.y) - cbSharedPerViewData.vViewRemap.y)) - _197) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _276.z) - cbSharedPerViewData.vViewRemap.y)) - _197) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _276.w) - cbSharedPerViewData.vViewRemap.y)) - _197) > 0.029999999329447746f)) {
          _310 = abs(_116.x - _276.w);
          _312 = abs(_116.x - _276.z);
          _313 = (_312 < _310);
          _315 = select(_313, _312, _310);
          _317 = abs(_116.x - _276.x);
          _318 = (_317 < _315);
          if (abs(_116.x - _276.y) < select(_318, _317, _315)) {
            _327 = _270;
            _328 = _271;
          } else {
            _327 = select(_318, _266, select(_313, _270, _266));
            _328 = select(_318, _271, _267);
          }
        } else {
          _327 = _246;
          _328 = _247;
        }
      } else {
        _327 = _246;
        _328 = _247;
      }
      _331 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_327, _328), 0.0f);
      _335 = _331.x - _331.z;
      _347 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_331.y + _335)), 0.0f);
      _348 = -0.0f - _347;
      _349 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_331.x + _331.z)), 0.0f);
      _350 = -0.0f - _349;
      _351 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_335 - _331.y)), 0.0f);
      _352 = -0.0f - _351;
      if (!(cbSharedPerViewData.nSSGIEnabled == 0)) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _366 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_327, _328), 0.0f)).x);
        } else {
          _366 = 1.0f;
        }
      } else {
        _366 = 1.0f;
      }
      _367 = -0.0f - _133;
      _368 = -0.0f - _134;
      _370 = rsqrt(dot(float3(_367, _368, 1.0f), float3(_367, _368, 1.0f)));
      _371 = _370 * _367;
      _372 = _370 * _368;
      _380 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _63) + _62))];
      _381 = _380 & 255;
      _382 = (uint)(_380) >> 8;
      _383 = _382 & 255;
      _387 = ((float)((uint)((uint)(((uint)(_380) >> 16) & 255)))) * 0.003921568859368563f;
      _389 = (float)((uint)((uint)((uint)(_380) >> 24)));
      _390 = _389 * 0.003921568859368563f;
      [branch]
      if (!((((int)(uint((saturate(_141.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _400 = _190 * 4.0f;
        _405 = dot(float3((-0.0f - _371), (-0.0f - _372), (-0.0f - _370)), float3(_179, _180, _181)) * 2.0f;
        _409 = _190 * _190;
        _410 = 1.0f - _409;
        _413 = (sqrt(_410) + _409) * _410;
        _426 = (_413 * (((-0.0f - _179) - _371) - (_405 * _179))) + _179;
        _427 = (_413 * (((-0.0f - _180) - _372) - (_405 * _180))) + _180;
        _428 = (_413 * (((-0.0f - _181) - _370) - (_405 * _181))) + _181;
        _432 = saturate(1.0f - ((_190 + -0.30000001192092896f) * 3.3333332538604736f));
        _447 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _428, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _427, (_426 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _450 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _428, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _427, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _426)));
        _453 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _428, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _427, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _426)));
        _456 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _181, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _180, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _179)));
        _459 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _181, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _180, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _179)));
        _462 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _181, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _180, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _179)));
        if (!(_global_0 == 0)) {
          _481 = 0;
          _482 = 0.0f;
          _483 = 0.0f;
          _484 = 0.0f;
          _485 = 0.0f;
          _486 = 0.0f;
          _487 = 0.0f;
          _488 = 0.0f;
          _489 = 0.0f;
          _490 = 0.0f;
          _491 = 0.0f;
          _492 = 0.0f;
          _493 = 0.0f;
          _494 = 0.0f;
          _495 = 0.0f;
          while(true) {
            _773 = _482;
            _774 = _483;
            _775 = _484;
            _776 = _485;
            _777 = _486;
            _778 = _487;
            _779 = _488;
            _780 = _489;
            _781 = _490;
            _782 = _491;
            _783 = _492;
            _784 = _493;
            _785 = _494;
            _786 = _495;
            _498 = _global_5[min((uint)(_481), 63u)];
            _499 = _global_6[min((uint)(_481), 63u)];
            _502 = asfloat(srvLightInfoProperties.Load4(_499)).x;
            _503 = asfloat(srvLightInfoProperties.Load4(_499)).y;
            _504 = asfloat(srvLightInfoProperties.Load4(_499)).z;
            _505 = asfloat(srvLightInfoProperties.Load4(_499)).w;
            _508 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 16u)))).x;
            _509 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 16u)))).y;
            _510 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 16u)))).z;
            _511 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 16u)))).w;
            _514 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 32u)))).x;
            _515 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 32u)))).y;
            _516 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 32u)))).z;
            _517 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 32u)))).w;
            _520 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 48u)))).x;
            _521 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 48u)))).y;
            _522 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 48u)))).z;
            _523 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 48u)))).w;
            _526 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 64u)))).x;
            _527 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 64u)))).y;
            _528 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 64u)))).z;
            _529 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 64u)))).w;
            _532 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 80u)))).x;
            _533 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 80u)))).y;
            _534 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 80u)))).z;
            _535 = asfloat(srvLightInfoProperties.Load4(((int)(_499 + 80u)))).w;
            _538 = asint(srvLightInfoProperties.Load(((int)(_499 + 96u))));
            _541 = asfloat(srvLightInfoProperties.Load3(((int)(_499 + 100u)))).x;
            _542 = asfloat(srvLightInfoProperties.Load3(((int)(_499 + 100u)))).y;
            _543 = asfloat(srvLightInfoProperties.Load3(((int)(_499 + 100u)))).z;
            _546 = asfloat(srvLightInfoProperties.Load3(((int)(_499 + 112u)))).x;
            _547 = asfloat(srvLightInfoProperties.Load3(((int)(_499 + 112u)))).y;
            _548 = asfloat(srvLightInfoProperties.Load3(((int)(_499 + 112u)))).z;
            _551 = asint(srvLightInfoProperties.Load(((int)(_499 + 124u))));
            _554 = asint(srvLightInfoProperties.Load(((int)(_499 + 128u))));
            _557 = _538 & 65535;
            _586 = ((saturate(1.0f - abs(mad(_504, _200, mad(_503, _199, (_502 * _198))) + _505)) * f16tof32(((uint)((uint)(_538) >> 16)))) * saturate(1.0f - abs(mad(_510, _200, mad(_509, _199, (_508 * _198))) + _511))) * saturate(1.0f - abs(mad(_516, _200, mad(_515, _199, (_514 * _198))) + _517));
            [branch]
            if (_586 > 0.0f) {
              _589 = _586 * _586;
              [branch]
              if (_432 < 1.0f) {
                _592 = (float)((uint)_557);
                _593 = -0.0f - _447;
                [branch]
                if (!(_592 >= 341.0f)) {
                  _605 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_593, _450, _453, _592), _400);
                  _610 = _605.x;
                  _611 = _605.y;
                  _612 = _605.z;
                } else {
                  _599 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_593, _450, _453, (_592 + -341.0f)), _400);
                  _610 = _599.x;
                  _611 = _599.y;
                  _612 = _599.z;
                }
              } else {
                _610 = 0.0f;
                _611 = 0.0f;
                _612 = 0.0f;
              }
              _614 = (float)((uint)_557);
              [branch]
              if (_432 > 0.0f) {
                _618 = mad(_522, _428, mad(_521, _427, (_520 * _426)));
                _621 = mad(_528, _428, mad(_527, _427, (_526 * _426)));
                _624 = mad(_534, _428, mad(_533, _427, (_532 * _426)));
                _665 = min(((((float((int)(((int)(uint)((int)(_618 > 0.0f))) - ((int)(uint)((int)(_618 < 0.0f))))) * _541) - _523) - mad(_522, _200, mad(_521, _199, (_520 * _198)))) / _618), min(((((float((int)(((int)(uint)((int)(_621 > 0.0f))) - ((int)(uint)((int)(_621 < 0.0f))))) * _542) - _529) - mad(_528, _200, mad(_527, _199, (_526 * _198)))) / _621), ((((float((int)(((int)(uint)((int)(_624 > 0.0f))) - ((int)(uint)((int)(_624 < 0.0f))))) * _543) - _535) - mad(_534, _200, mad(_533, _199, (_532 * _198)))) / _624)));
                _670 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _200, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _199, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _198))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _546) + (_665 * _447);
                _672 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _200, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _199, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _198))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _547) + (_665 * _450);
                _674 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _200, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _199, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _198))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _548) + (_665 * _453);
                _681 = (max(log2((_665 * _665) / dot(float3(_670, _672, _674), float3(_670, _672, _674))), -1.0f) * 0.3333333432674408f) + _400;
                _682 = -0.0f - _670;
                [branch]
                if (!(_614 >= 341.0f)) {
                  _694 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_682, _672, _674, _614), _681);
                  _699 = _694.x;
                  _700 = _694.y;
                  _701 = _694.z;
                } else {
                  _688 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_682, _672, _674, (_614 + -341.0f)), _681);
                  _699 = _688.x;
                  _700 = _688.y;
                  _701 = _688.z;
                }
              } else {
                _699 = 0.0f;
                _700 = 0.0f;
                _701 = 0.0f;
              }
              _702 = -0.0f - _456;
              [branch]
              if (!(_614 >= 341.0f)) {
                _714 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_702, _459, _462, _614), 0.0f);
                _719 = _714.x;
                _720 = _714.y;
                _721 = _714.z;
              } else {
                _708 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_702, _459, _462, (_614 + -341.0f)), 0.0f);
                _719 = _708.x;
                _720 = _708.y;
                _721 = _708.z;
              }
              _731 = _589 * f16tof32(((uint)((uint)(_551) >> 16)));
              _732 = _731 * _719;
              _733 = _589 * f16tof32(_551);
              _734 = _733 * _720;
              _735 = _589 * f16tof32(((uint)((uint)(_554) >> 16)));
              _736 = _735 * _721;
              _737 = _731 * (lerp(_610, _699, _432));
              _738 = _733 * (lerp(_611, _700, _432));
              _739 = _735 * (lerp(_612, _701, _432));
              [branch]
              if (!((_498 & ((int)(1 << (_380 & 31)))) == 0)) {
                _753 = (_732 + _482);
                _754 = (_734 + _483);
                _755 = (_736 + _484);
                _756 = (_737 + _485);
                _757 = (_738 + _486);
                _758 = (_739 + _487);
                _759 = (_589 + _488);
              } else {
                _753 = _482;
                _754 = _483;
                _755 = _484;
                _756 = _485;
                _757 = _486;
                _758 = _487;
                _759 = _488;
              }
              [branch]
              if (!((_498 & ((int)(1 << (_382 & 31)))) == 0)) {
                _773 = _753;
                _774 = _754;
                _775 = _755;
                _776 = _756;
                _777 = _757;
                _778 = _758;
                _779 = _759;
                _780 = (_732 + _489);
                _781 = (_734 + _490);
                _782 = (_736 + _491);
                _783 = (_737 + _492);
                _784 = (_738 + _493);
                _785 = (_739 + _494);
                _786 = (_589 + _495);
              } else {
                _773 = _753;
                _774 = _754;
                _775 = _755;
                _776 = _756;
                _777 = _757;
                _778 = _758;
                _779 = _759;
                _780 = _489;
                _781 = _490;
                _782 = _491;
                _783 = _492;
                _784 = _493;
                _785 = _494;
                _786 = _495;
              }
            } else {
              _773 = _482;
              _774 = _483;
              _775 = _484;
              _776 = _485;
              _777 = _486;
              _778 = _487;
              _779 = _488;
              _780 = _489;
              _781 = _490;
              _782 = _491;
              _783 = _492;
              _784 = _493;
              _785 = _494;
              _786 = _495;
            }
            _787 = _481 + 1u;
            if (!(_787 == _global_0)) {
              _481 = _787;
              _482 = _773;
              _483 = _774;
              _484 = _775;
              _485 = _776;
              _486 = _777;
              _487 = _778;
              _488 = _779;
              _489 = _780;
              _490 = _781;
              _491 = _782;
              _492 = _783;
              _493 = _784;
              _494 = _785;
              _495 = _786;
              continue;
            }
            _791 = _773;
            _792 = _774;
            _793 = _775;
            _794 = _776;
            _795 = _777;
            _796 = _778;
            _797 = _779;
            _798 = _780;
            _799 = _781;
            _800 = _782;
            _801 = _783;
            _802 = _784;
            _803 = _785;
            _804 = _786;
            break;
          }
        } else {
          _791 = 0.0f;
          _792 = 0.0f;
          _793 = 0.0f;
          _794 = 0.0f;
          _795 = 0.0f;
          _796 = 0.0f;
          _797 = 0.0f;
          _798 = 0.0f;
          _799 = 0.0f;
          _800 = 0.0f;
          _801 = 0.0f;
          _802 = 0.0f;
          _803 = 0.0f;
          _804 = 0.0f;
        }
        _810 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_380 & 31)))) != 0);
        if ((_387 > 0.0f) || ((_390 > 0.0f) || _810)) {
          _820 = srvFallbackInfo[((_381 << 2) | 3)].x;
          _822 = select(_810, 9.999999747378752e-05f, (_389 * 3.921568847431445e-09f));
          _823 = _797 * 0.20000000298023224f;
          _830 = saturate((_822 - _823) / (((_797 * 0.4000000059604645f) + 9.99999993922529e-09f) - _823)) * _822;
          [branch]
          if (_830 > 0.0f) {
            [branch]
            if ((int)_820 > (int)-1) {
              _835 = float((int)(_820));
              _836 = -0.0f - _447;
              _837 = !(_835 >= 341.0f);
              [branch]
              if (_837) {
                _848 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_836, _450, _453, _835), _400);
                _853 = _848.x;
                _854 = _848.y;
                _855 = _848.z;
              } else {
                _842 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_836, _450, _453, (_835 + -341.0f)), _400);
                _853 = _842.x;
                _854 = _842.y;
                _855 = _842.z;
              }
              _859 = -0.0f - _456;
              [branch]
              if (_837) {
                _870 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_859, _459, _462, _835), 0.0f);
                _875 = _870.x;
                _876 = _870.y;
                _877 = _870.z;
              } else {
                _864 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_859, _459, _462, (_835 + -341.0f)), 0.0f);
                _875 = _864.x;
                _876 = _864.y;
                _877 = _864.z;
              }
              _888 = ((_853 * _830) + _794);
              _889 = ((_854 * _830) + _795);
              _890 = ((_855 * _830) + _796);
              _891 = ((_875 * _830) + _791);
              _892 = ((_876 * _830) + _792);
              _893 = ((_877 * _830) + _793);
            } else {
              _888 = _794;
              _889 = _795;
              _890 = _796;
              _891 = _791;
              _892 = _792;
              _893 = _793;
            }
            _896 = (_830 + _797);
            _897 = _888;
            _898 = _889;
            _899 = _890;
            _900 = _891;
            _901 = _892;
            _902 = _893;
          } else {
            _896 = _797;
            _897 = _794;
            _898 = _795;
            _899 = _796;
            _900 = _791;
            _901 = _792;
            _902 = _793;
          }
          if (_896 > 0.0f) {
            _908 = (cbSharedPerViewData.vHDRScale.x * _387) / _896;
            _916 = (_908 * _900);
            _917 = (_908 * _901);
            _918 = (_908 * _902);
            _919 = (_908 * _897);
            _920 = (_908 * _898);
            _921 = (_908 * _899);
          } else {
            _916 = 0.0f;
            _917 = 0.0f;
            _918 = 0.0f;
            _919 = 0.0f;
            _920 = 0.0f;
            _921 = 0.0f;
          }
        } else {
          _916 = 0.0f;
          _917 = 0.0f;
          _918 = 0.0f;
          _919 = 0.0f;
          _920 = 0.0f;
          _921 = 0.0f;
        }
        [branch]
        if (!(_390 == 0.0f)) {
          _928 = srvFallbackInfo[((_383 << 2) | 3)].x;
          _929 = _389 * 3.921568847431445e-09f;
          [branch]
          if ((int)_928 > (int)-1) {
            _932 = float((int)(_928));
            _933 = -0.0f - _447;
            _934 = !(_932 >= 341.0f);
            [branch]
            if (_934) {
              _945 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_933, _450, _453, _932), _400);
              _950 = _945.x;
              _951 = _945.y;
              _952 = _945.z;
            } else {
              _939 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_933, _450, _453, (_932 + -341.0f)), _400);
              _950 = _939.x;
              _951 = _939.y;
              _952 = _939.z;
            }
            _956 = -0.0f - _456;
            [branch]
            if (_934) {
              _967 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_956, _459, _462, _932), 0.0f);
              _972 = _967.x;
              _973 = _967.y;
              _974 = _967.z;
            } else {
              _961 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_956, _459, _462, (_932 + -341.0f)), 0.0f);
              _972 = _961.x;
              _973 = _961.y;
              _974 = _961.z;
            }
            _985 = ((_950 * _929) + _801);
            _986 = ((_951 * _929) + _802);
            _987 = ((_952 * _929) + _803);
            _988 = ((_972 * _929) + _798);
            _989 = ((_973 * _929) + _799);
            _990 = ((_974 * _929) + _800);
          } else {
            _985 = _801;
            _986 = _802;
            _987 = _803;
            _988 = _798;
            _989 = _799;
            _990 = _800;
          }
          _995 = (cbSharedPerViewData.vHDRScale.x * _390) / (_804 + _929);
          _1009 = ((_995 * _988) + _916);
          _1010 = ((_995 * _989) + _917);
          _1011 = ((_995 * _990) + _918);
          _1012 = ((_995 * _985) + _919);
          _1013 = ((_995 * _986) + _920);
          _1014 = ((_995 * _987) + _921);
        } else {
          _1009 = _916;
          _1010 = _917;
          _1011 = _918;
          _1012 = _919;
          _1013 = _920;
          _1014 = _921;
        }
      } else {
        _1009 = 0.0f;
        _1010 = 0.0f;
        _1011 = 0.0f;
        _1012 = 0.0f;
        _1013 = 0.0f;
        _1014 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1033 = (min((_348 / max(9.999999747378752e-05f, _1009)), 1.0f) * _1012);
        _1034 = (min((_350 / max(9.999999747378752e-05f, _1010)), 1.0f) * _1013);
        _1035 = (min((_352 / max(9.999999747378752e-05f, _1011)), 1.0f) * _1014);
      } else {
        _1033 = _1012;
        _1034 = _1013;
        _1035 = _1014;
      }
      _1051 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(saturate(dot(float3(_371, _372, _370), float3(_179, _180, _181))), _190), 0.0f);
      _1054 = _1051.x + _1051.y;
      _1059 = (((1.0f - _1054) * 0.03999999910593033f) / max(9.999999747378752e-06f, _1054)) + 1.0f;
      _1061 = (_1051.x * 0.03999999910593033f) + _1051.y;
      _1062 = min((_158 * _158), _366);
      if (!(_global_1 == 0)) {
        _1066 = 0;
        _1067 = _1062;
        while(true) {
          _1185 = _1067;
          _1068 = _1066 + (uint)(_global_0);
          _1071 = _global_5[min((uint)(_1068), 63u)];
          _1072 = _global_6[min((uint)(_1068), 63u)];
          _1076 = (int)((int)(_1071 << (((int)(31u - _380)) & 31))) >> 31;
          _1080 = (int)((int)(_1071 << ((31 - _382) & 31))) >> 31;
          _1092 = saturate((asfloat((_1076 & asint(_387))) + asfloat((_1080 & asint(_390)))) + asfloat(((_1080 & 1065353216) & _1076)));
          [branch]
          if (!(_1092 == 0.0f)) {
            _1097 = asfloat(srvLightInfoProperties.Load4(_1072)).x;
            _1098 = asfloat(srvLightInfoProperties.Load4(_1072)).y;
            _1099 = asfloat(srvLightInfoProperties.Load4(_1072)).z;
            _1100 = asfloat(srvLightInfoProperties.Load4(_1072)).w;
            _1103 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 16u)))).x;
            _1104 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 16u)))).y;
            _1105 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 16u)))).z;
            _1106 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 16u)))).w;
            _1109 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 32u)))).x;
            _1110 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 32u)))).y;
            _1111 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 32u)))).z;
            _1112 = asfloat(srvLightInfoProperties.Load4(((int)(_1072 + 32u)))).w;
            _1115 = asint(srvLightInfoProperties.Load(((int)(_1072 + 48u))));
            _1118 = asint(srvLightInfoProperties.Load(((int)(_1072 + 52u))));
            _1121 = asint(srvLightInfoProperties.Load(((int)(_1072 + 56u))));
            _1124 = asint(srvLightInfoProperties.Load(((int)(_1072 + 60u))));
            _1139 = mad(_1099, _200, mad(_1098, _199, (_1097 * _198))) + _1100;
            _1143 = mad(_1105, _200, mad(_1104, _199, (_1103 * _198))) + _1106;
            _1147 = mad(_1111, _200, mad(_1110, _199, (_1109 * _198))) + _1112;
            _1172 = saturate(1.0f - ((_1139 + 1.0f) * f16tof32(_1118))) + saturate(1.0f - ((1.0f - _1139) * f16tof32(((uint)((uint)(_1118) >> 16)))));
            _1173 = saturate(1.0f - ((_1143 + 1.0f) * f16tof32(_1121))) + saturate(1.0f - ((1.0f - _1143) * f16tof32(((uint)((uint)(_1121) >> 16)))));
            _1174 = saturate(1.0f - ((_1147 + 1.0f) * f16tof32(_1124))) + saturate(1.0f - ((1.0f - _1147) * f16tof32(((uint)((uint)(_1124) >> 16)))));
            _1177 = saturate(1.0f - dot(float3(_1172, _1173, _1174), float3(_1172, _1173, _1174)));
            _1185 = (saturate(1.0f - ((_1177 * _1177) * (f16tof32(((uint)((uint)(_1115) >> 16))) * _1092))) * _1067);
          } else {
            _1185 = _1067;
          }
          _1186 = _1066 + 1u;
          if (!(_1186 == _global_1)) {
            _1066 = _1186;
            _1067 = _1185;
            continue;
          }
          _1190 = _1185;
          break;
        }
      } else {
        _1190 = _1062;
      }
      _1192 = (_1059 * ((cbSharedPerViewData.vHDRScale.x * _235) + (_1033 * _234))) * _1061;
      _1194 = (_1061 * ((cbSharedPerViewData.vHDRScale.x * _236) + (_1034 * _234))) * _1059;
      _1196 = (_1061 * ((cbSharedPerViewData.vHDRScale.x * _237) + (_1035 * _234))) * _1059;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1203 = _1190;
      } else {
        _1203 = 1.0f;
      }
      if (_387 > 0.0f) {
        _1206 = _381 * 3;
        _1209 = srvRoomInfo[_1206].x;
        _1210 = srvRoomInfo[_1206].y;
        _1211 = srvRoomInfo[_1206].z;
        _1217 = srvRoomInfo[(_1206 + 1)].x;
        _1218 = srvRoomInfo[(_1206 + 1)].y;
        _1219 = srvRoomInfo[(_1206 + 1)].z;
        _1225 = srvRoomInfo[(_1206 + 2)].x;
        _1226 = srvRoomInfo[(_1206 + 2)].y;
        _1227 = srvRoomInfo[(_1206 + 2)].z;
        _1233 = saturate(dot(float3(_179, _180, _181), float3(asfloat(_1209), asfloat(_1210), asfloat(_1211))) + 0.5f);
        _1237 = (_1233 * _1233) * (3.0f - (_1233 * 2.0f));
        _1241 = 1.0f - _1237;
        _1248 = _1203 * _387;
        _1256 = ((_1248 * ((_1241 * asfloat(_1225)) + (_1237 * asfloat(_1217)))) - _347);
        _1257 = ((_1248 * ((_1241 * asfloat(_1226)) + (_1237 * asfloat(_1218)))) - _349);
        _1258 = ((_1248 * ((_1241 * asfloat(_1227)) + (_1237 * asfloat(_1219)))) - _351);
      } else {
        _1256 = _348;
        _1257 = _350;
        _1258 = _352;
      }
      if (_390 > 0.0f) {
        _1261 = _383 * 3;
        _1264 = srvRoomInfo[_1261].x;
        _1265 = srvRoomInfo[_1261].y;
        _1266 = srvRoomInfo[_1261].z;
        _1272 = srvRoomInfo[(_1261 + 1)].x;
        _1273 = srvRoomInfo[(_1261 + 1)].y;
        _1274 = srvRoomInfo[(_1261 + 1)].z;
        _1280 = srvRoomInfo[(_1261 + 2)].x;
        _1281 = srvRoomInfo[(_1261 + 2)].y;
        _1282 = srvRoomInfo[(_1261 + 2)].z;
        _1288 = saturate(dot(float3(_179, _180, _181), float3(asfloat(_1264), asfloat(_1265), asfloat(_1266))) + 0.5f);
        _1292 = (_1288 * _1288) * (3.0f - (_1288 * 2.0f));
        _1296 = 1.0f - _1292;
        _1303 = _1203 * _390;
        _1311 = ((_1303 * ((_1296 * asfloat(_1280)) + (_1292 * asfloat(_1272)))) + _1256);
        _1312 = ((_1303 * ((_1296 * asfloat(_1281)) + (_1292 * asfloat(_1273)))) + _1257);
        _1313 = ((_1303 * ((_1296 * asfloat(_1282)) + (_1292 * asfloat(_1274)))) + _1258);
      } else {
        _1311 = _1256;
        _1312 = _1257;
        _1313 = _1258;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1336 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _200, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _199, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _198))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1340 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _200, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _199, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _198))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1344 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _200, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _199, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _198))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1363 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1344, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1340, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1336))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1367 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1344, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1340, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1336))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1371 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1344, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1340, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1336))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1384 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1385 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1386 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1423 = min(min(saturate((_1363 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1384), 9.999999747378752e-06f)), saturate((1.0f - _1363) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1384), 9.999999747378752e-06f))), min(min(saturate((_1367 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1385), 9.999999747378752e-06f)), saturate((1.0f - _1367) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1385), 9.999999747378752e-06f))), min(saturate((_1371 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1386), 9.999999747378752e-06f)), saturate((1.0f - _1371) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1386), 9.999999747378752e-06f)))));
      } else {
        _1423 = 0.0f;
      }
      _1424 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1424 < (uint)_global_2) {
        _1428 = _1311;
        _1429 = _1312;
        _1430 = _1313;
        _1431 = _1192;
        _1432 = _1194;
        _1433 = _1196;
        _1434 = _1424;
        while(true) {
          _8238 = _1428;
          _8239 = _1429;
          _8240 = _1430;
          _8241 = _1431;
          _8242 = _1432;
          _8243 = _1433;
          _1436 = _global_3[min((uint)(_1434), 63u)];
          _1440 = _global_4[min((uint)(_1434), 63u)];
          _1441 = _global_5[min((uint)(_1434), 63u)];
          _1442 = _global_6[min((uint)(_1434), 63u)];
          _1443 = _1436 & 4095;
          [branch]
          if (((_1440 & 16777216) == 0) && ((((int)(uint(saturate(_147.w) * 255.0f)) & 64) != 0) || ((_1440 & 8388608) == 0))) {
            _1454 = (int)((int)(_1441 << (((int)(31u - _380)) & 31))) >> 31;
            _1458 = (int)((int)(_1441 << ((31 - _382) & 31))) >> 31;
            _1470 = saturate((asfloat((_1454 & asint(_387))) + asfloat((_1458 & asint(_390)))) + asfloat(((_1458 & 1065353216) & _1454)));
            [branch]
            if (!(_1470 == 0.0f)) {
              _1473 = (uint)(_1436) >> 12;
              if (_1473 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _2953 = (_1470 * select(((_1440 & 67108864) != 0), 1.0f, (1.0f - _1423)));
                } else {
                  _2953 = _1470;
                }
                _2956 = asfloat(srvLightInfoProperties.Load4(_1442)).x;
                _2957 = asfloat(srvLightInfoProperties.Load4(_1442)).y;
                _2958 = asfloat(srvLightInfoProperties.Load4(_1442)).z;
                _2959 = asfloat(srvLightInfoProperties.Load4(_1442)).w;
                _2962 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).x;
                _2963 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).y;
                _2964 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).z;
                _2965 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).w;
                _2968 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).x;
                _2969 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).y;
                _2970 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).z;
                _2973 = asint(srvLightInfoProperties.Load(((int)(_1442 + 68u))));
                _2976 = asint(srvLightInfoProperties.Load(((int)(_1442 + 72u))));
                _2979 = asint(srvLightInfoProperties.Load(((int)(_1442 + 76u))));
                _2982 = asint(srvLightInfoProperties.Load(((int)(_1442 + 84u))));
                _2985 = asint(srvLightInfoProperties.Load(((int)(_1442 + 88u))));
                _2988 = asint(srvLightInfoProperties.Load(((int)(_1442 + 92u))));
                _2992 = ((float)((uint)((uint)(((uint)(_2973) >> 8) & 255)))) * 0.003921499941498041f;
                _2995 = ((float)((uint)((uint)(_2973 & 255)))) * 0.003921499941498041f;
                _2997 = f16tof32(((uint)((uint)(_2976) >> 16)));
                _2999 = (uint)(_2979) >> 16;
                _3019 = srvDeferredShadingPass_DeferredShadows.Load(int3(_62, _63, 0));
                [branch]
                if (!(_3019.x == 0.0f)) {
                  [branch]
                  if (!(_2999 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _2999)))];
                    _3036 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_2958, _200, mad(_2957, _199, (_2956 * _198))) + _2959) * f16tof32(((uint)((uint)(_2985) >> 16)))) + f16tof32(((uint)((uint)(_2988) >> 16)))), (((mad(_2964, _200, mad(_2963, _199, (_2962 * _198))) + _2965) * f16tof32(_2985)) + f16tof32(_2988))), 0.0f);
                    _3044 = (_3036.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _3045 = (_3036.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _3046 = (_3036.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _3044 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _3045 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _3046 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  _3049 = min(_3019.x, _3019.y) * _2953;
                  [branch]
                  if (_3049 > 0.0f) {
                    _3052 = dot(float3(_2968, _2969, _2970), float3(_2968, _2969, _2970));
                    _3053 = rsqrt(_3052);
                    _3054 = _3053 * _2968;
                    _3055 = _3053 * _2969;
                    _3056 = _3053 * _2970;
                    _3057 = dot(float3(_179, _180, _181), float3(_3054, _3055, _3056));
                    if (_2997 > 0.0f) {
                      _3065 = sqrt(saturate((_2997 * _2997) * (1.0f / (_3052 + 1.0f))));
                      if (_3057 < _3065) {
                        _3070 = max(_3057, (-0.0f - _3065)) + _3065;
                        _3075 = ((_3070 * _3070) / (_3065 * 4.0f));
                      } else {
                        _3075 = _3057;
                      }
                    } else {
                      _3075 = _3057;
                    }
                    _3076 = _190 * _190;
                    _3080 = saturate((_2997 * (1.0f - _3076)) * _3053);
                    _3082 = saturate(_3053 * f16tof32(_2976));
                    _3083 = dot(float3(_179, _180, _181), float3(_371, _372, _370));
                    _3084 = dot(float3(_371, _372, _370), float3(_3054, _3055, _3056));
                    _3087 = rsqrt((_3084 * 2.0f) + 2.0f);
                    _3094 = (_3080 > 0.0f);
                    if (_3094) {
                      _3098 = sqrt(1.0f - (_3080 * _3080));
                      _3100 = (_3057 * 2.0f) * _3083;
                      _3101 = _3100 - _3084;
                      if (!(_3101 >= _3098)) {
                        _3109 = rsqrt(1.0f - (_3101 * _3101)) * _3080;
                        _3112 = _3109 * (_3083 - (_3101 * _3057));
                        _3113 = _3083 * _3083;
                        _3118 = _3109 * (((_3113 * 2.0f) + -1.0f) - (_3101 * _3084));
                        _3127 = sqrt(saturate((((1.0f - (_3057 * _3057)) - _3113) - (_3084 * _3084)) + (_3100 * _3084)));
                        _3128 = _3127 * _3109;
                        _3131 = ((_3083 * 2.0f) * _3109) * _3127;
                        _3133 = (_3098 * _3057) + _3083;
                        _3134 = _3133 + _3112;
                        _3135 = _3098 * _3084;
                        _3137 = (_3135 + 1.0f) + _3118;
                        _3138 = _3128 * _3137;
                        _3139 = _3134 * _3137;
                        _3140 = _3131 * _3134;
                        _3145 = (((_3134 * 0.25f) * _3131) - (_3138 * 0.5f)) * _3139;
                        _3159 = (((_3140 - (_3138 * 2.0f)) * _3140) + (_3138 * _3138)) + ((((-0.5f - ((_3137 + _3135) * 0.5f)) * _3139) + ((_3137 * _3137) * _3133)) * _3134);
                        _3164 = (_3145 * 2.0f) / ((_3159 * _3159) + (_3145 * _3145));
                        _3165 = _3159 * _3164;
                        _3167 = 1.0f - (_3145 * _3164);
                        _3173 = ((_3165 * _3131) + _3135) + (_3167 * _3118);
                        _3176 = rsqrt((_3173 * 2.0f) + 2.0f);
                        _3185 = saturate((_3173 * _3176) + _3176);
                        _3186 = saturate(((_3133 + (_3165 * _3128)) + (_3167 * _3112)) * _3176);
                      } else {
                        _3185 = abs(_3083);
                        _3186 = 1.0f;
                      }
                    } else {
                      _3185 = saturate((_3087 * _3084) + _3087);
                      _3186 = saturate(_3087 * (_3083 + _3057));
                    }
                    _3187 = saturate(_3075);
                    _3188 = _3076 * _3076;
                    if (_3082 > 0.0f) {
                      _3198 = saturate(((_3082 * _3082) / ((_3185 * 3.5999999046325684f) + 0.4000000059604645f)) + _3188);
                    } else {
                      _3198 = _3188;
                    }
                    _3199 = sqrt(_3198);
                    if (_3094) {
                      _3210 = (_3198 / ((((_3080 * 0.25f) * ((_3199 * 3.0f) + _3080)) / (_3185 + 0.0010000000474974513f)) + _3198));
                    } else {
                      _3210 = 1.0f;
                    }
                    _3214 = (((_3198 * _3186) - _3186) * _3186) + 1.0f;
                    _3226 = saturate(abs(_3083) + 9.999999747378752e-06f);
                    _3227 = 1.0f - _3199;
                    _3239 = saturate((_3057 + _2995) / (_2995 + 1.0f));
                    [branch]
                    if (!((_2982 & 1) == 0)) {
                      _3255 = max(max(_3044, _3045), _3046);
                      if (_3255 > 0.0f) {
                        _3265 = saturate(_3044 / _3255);
                        _3266 = saturate(_3045 / _3255);
                        _3267 = saturate(_3046 / _3255);
                      } else {
                        _3265 = _3044;
                        _3266 = _3045;
                        _3267 = _3046;
                      }
                      _3268 = (_3266 < _3267);
                      _3269 = select(_3268, _3267, _3266);
                      _3270 = select(_3268, _3266, _3267);
                      _3271 = select(_3268, -1.0f, 0.0f);
                      _3272 = (_3265 < _3269);
                      _3274 = select(_3272, _3269, _3265);
                      _3275 = select(_3272, _3265, _3269);
                      _3279 = _3274 - select((_3275 < _3270), _3275, _3270);
                      _3285 = abs(select(_3272, (-0.3333333432674408f - _3271), _3271) + ((_3275 - _3270) / ((_3279 * 6.0f) + 9.999999682655225e-21f)));
                      if (_3285 < 0.6666666865348816f) {
                        _3298 = ((saturate(((float)((uint)((uint)(((uint)(_2982) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3285 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3285)) + _3285);
                      } else {
                        _3298 = _3285;
                      }
                      _3299 = saturate((_3279 / (_3274 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_2982) >> 1) & 255)))) * 0.003921499941498041f));
                      _3300 = saturate(_3274);
                      if (!(_3299 <= 0.0f)) {
                        _3303 = saturate(_3298);
                        _3307 = select(((_3303 * 360.0f) >= 360.0f), 0.0f, (_3303 * 6.0f));
                        _3308 = int(_3307);
                        _3310 = _3307 - float((int)(_3308));
                        _3312 = _3300 * (1.0f - _3299);
                        _3315 = (1.0f - (_3310 * _3299)) * _3300;
                        _3319 = (1.0f - ((1.0f - _3310) * _3299)) * _3300;
                        switch (_3308) {
                          case 0: {
                            _3327 = _3300;
                            _3328 = _3319;
                            _3329 = _3312;
                            break;
                          }
                          case 1: {
                            _3327 = _3315;
                            _3328 = _3300;
                            _3329 = _3312;
                            break;
                          }
                          case 2: {
                            _3327 = _3312;
                            _3328 = _3300;
                            _3329 = _3319;
                            break;
                          }
                          case 3: {
                            _3327 = _3312;
                            _3328 = _3315;
                            _3329 = _3300;
                            break;
                          }
                          case 4: {
                            _3327 = _3319;
                            _3328 = _3312;
                            _3329 = _3300;
                            break;
                          }
                          case 5: {
                            _3327 = _3300;
                            _3328 = _3312;
                            _3329 = _3315;
                            break;
                          }
                          default: {
                            _3327 = 0.0f;
                            _3328 = 0.0f;
                            _3329 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _3327 = _3300;
                        _3328 = _3300;
                        _3329 = _3300;
                      }
                      _3330 = _3327 * _3255;
                      _3331 = _3328 * _3255;
                      _3332 = _3329 * _3255;
                      _3334 = saturate(_3049 * 1.0101009607315063f);
                      _3345 = ((_3334 * (_3044 - _3330)) + _3330);
                      _3346 = ((_3334 * (_3045 - _3331)) + _3331);
                      _3347 = (lerp(_3332, _3046, _3334));
                    } else {
                      _3345 = _3044;
                      _3346 = _3045;
                      _3347 = _3046;
                    }
                    _3348 = _3345 * _3049;
                    _3349 = _3346 * _3049;
                    _3350 = _3347 * _3049;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _3360 = (_3348 * _1190);
                      _3361 = (_3349 * _1190);
                      _3362 = (_3350 * _1190);
                    } else {
                      _3360 = _3348;
                      _3361 = _3349;
                      _3362 = _3350;
                    }
                    _3366 = (_3360 * _3239) + _1428;
                    _3367 = (_3361 * _3239) + _1429;
                    _3368 = (_3362 * _3239) + _1430;
                    if (_2992 > 0.0f) {
                      _3372 = ((_2992 * _1059) * ((exp2(log2(1.0f - saturate(_3185)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f)) * (((_3210 * _3187) * (_3198 / (_3214 * _3214))) * (0.5f / ((((_3227 * _3226) + _3199) * _3187) + (((_3227 * _3187) + _3199) * _3226))));
                      _8238 = _3366;
                      _8239 = _3367;
                      _8240 = _3368;
                      _8241 = ((_3372 * _3360) + _1431);
                      _8242 = ((_3372 * _3361) + _1432);
                      _8243 = ((_3372 * _3362) + _1433);
                    } else {
                      _8238 = _3366;
                      _8239 = _3367;
                      _8240 = _3368;
                      _8241 = _1431;
                      _8242 = _1432;
                      _8243 = _1433;
                    }
                  } else {
                    _8238 = _1428;
                    _8239 = _1429;
                    _8240 = _1430;
                    _8241 = _1431;
                    _8242 = _1432;
                    _8243 = _1433;
                  }
                } else {
                  _8238 = _1428;
                  _8239 = _1429;
                  _8240 = _1430;
                  _8241 = _1431;
                  _8242 = _1432;
                  _8243 = _1433;
                }
              } else {
                _1490 = _1470 * select(((_1440 & 67108864) != 0), 1.0f, (1.0f - _1423));
                [branch]
                if (_1473 == 4) {
                  _1495 = asfloat(srvLightInfoProperties.Load4(_1442)).x;
                  _1496 = asfloat(srvLightInfoProperties.Load4(_1442)).y;
                  _1497 = asfloat(srvLightInfoProperties.Load4(_1442)).z;
                  _1498 = asfloat(srvLightInfoProperties.Load4(_1442)).w;
                  _1501 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).x;
                  _1502 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).y;
                  _1503 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).z;
                  _1504 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).w;
                  _1507 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).x;
                  _1508 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).y;
                  _1509 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).z;
                  _1510 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).w;
                  _1513 = asint(srvLightInfoProperties.Load(((int)(_1442 + 48u))));
                  _1516 = asint(srvLightInfoProperties.Load(((int)(_1442 + 52u))));
                  _1519 = asint(srvLightInfoProperties.Load(((int)(_1442 + 64u))));
                  _1522 = asint(srvLightInfoProperties.Load(((int)(_1442 + 68u))));
                  _1525 = asint(srvLightInfoProperties.Load(((int)(_1442 + 72u))));
                  _1527 = f16tof32(((uint)((uint)(_1513) >> 16)));
                  _1528 = f16tof32(_1513);
                  _1530 = f16tof32(((uint)((uint)(_1516) >> 16)));
                  _1534 = ((float)((uint)((uint)(((uint)(_1516) >> 8) & 255)))) * 0.003921499941498041f;
                  _1547 = mad(_1497, _200, mad(_1496, _199, (_1495 * _198))) + _1498;
                  _1551 = mad(_1503, _200, mad(_1502, _199, (_1501 * _198))) + _1504;
                  _1555 = mad(_1509, _200, mad(_1508, _199, (_1507 * _198))) + _1510;
                  _1580 = saturate(1.0f - ((_1547 + 1.0f) * f16tof32(_1519))) + saturate(1.0f - ((1.0f - _1547) * f16tof32(((uint)((uint)(_1519) >> 16)))));
                  _1581 = saturate(1.0f - ((_1551 + 1.0f) * f16tof32(_1522))) + saturate(1.0f - ((1.0f - _1551) * f16tof32(((uint)((uint)(_1522) >> 16)))));
                  _1582 = saturate(1.0f - ((_1555 + 1.0f) * f16tof32(_1525))) + saturate(1.0f - ((1.0f - _1555) * f16tof32(((uint)((uint)(_1525) >> 16)))));
                  _1585 = saturate(1.0f - dot(float3(_1580, _1581, _1582), float3(_1580, _1581, _1582)));
                  _1586 = _1585 * _1585;
                  _1593 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1586 * _1190), _1586) * _1490;
                  _8238 = ((_1593 * _1527) + _1428);
                  _8239 = ((_1593 * _1528) + _1429);
                  _8240 = ((_1593 * _1530) + _1430);
                  _8241 = (((_1534 * _1527) * _1593) + _1431);
                  _8242 = (((_1534 * _1528) * _1593) + _1432);
                  _8243 = (((_1530 * _1534) * _1593) + _1433);
                } else {
                  if (_1473 == 5) {
                    _1614 = asfloat(srvLightInfoProperties.Load4(_1442)).x;
                    _1615 = asfloat(srvLightInfoProperties.Load4(_1442)).y;
                    _1616 = asfloat(srvLightInfoProperties.Load4(_1442)).z;
                    _1617 = asfloat(srvLightInfoProperties.Load4(_1442)).w;
                    _1620 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).x;
                    _1621 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).y;
                    _1622 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).z;
                    _1623 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).w;
                    _1626 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).x;
                    _1627 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).y;
                    _1628 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).z;
                    _1629 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).w;
                    _1632 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).x;
                    _1633 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).y;
                    _1634 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).z;
                    _1637 = asfloat(srvLightInfoProperties.Load(((int)(_1442 + 60u))));
                    _1640 = asint(srvLightInfoProperties.Load(((int)(_1442 + 64u))));
                    _1643 = asint(srvLightInfoProperties.Load(((int)(_1442 + 68u))));
                    _1646 = asint(srvLightInfoProperties.Load(((int)(_1442 + 80u))));
                    _1649 = asint(srvLightInfoProperties.Load(((int)(_1442 + 84u))));
                    _1652 = asint(srvLightInfoProperties.Load(((int)(_1442 + 88u))));
                    _1655 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 92u)))).x;
                    _1656 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 92u)))).y;
                    _1657 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 92u)))).z;
                    _1658 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 92u)))).w;
                    _1661 = asint(srvLightInfoProperties.Load(((int)(_1442 + 108u))));
                    _1664 = asint(srvLightInfoProperties.Load(((int)(_1442 + 112u))));
                    _1667 = asint(srvLightInfoProperties.Load(((int)(_1442 + 120u))));
                    _1670 = asint(srvLightInfoProperties.Load(((int)(_1442 + 124u))));
                    _1673 = asint(srvLightInfoProperties.Load(((int)(_1442 + 128u))));
                    _1676 = asint(srvLightInfoProperties.Load(((int)(_1442 + 132u))));
                    _1679 = asint(srvLightInfoProperties.Load(((int)(_1442 + 136u))));
                    _1682 = asint(srvLightInfoProperties.Load(((int)(_1442 + 140u))));
                    _1684 = f16tof32(((uint)((uint)(_1640) >> 16)));
                    _1685 = f16tof32(_1640);
                    _1687 = f16tof32(((uint)((uint)(_1643) >> 16)));
                    _1691 = ((float)((uint)((uint)(((uint)(_1643) >> 8) & 255)))) * 0.003921499941498041f;
                    _1694 = ((float)((uint)((uint)(_1643 & 255)))) * 0.003921499941498041f;
                    _1696 = f16tof32(((uint)((uint)(_1646) >> 16)));
                    _1699 = _1649 & 65535;
                    _1709 = f16tof32(((uint)((uint)(_1664) >> 16)));
                    _1710 = f16tof32(_1664);
                    _1712 = f16tof32(((uint)((uint)(_1667) >> 16)));
                    _1713 = 1.0f / _1712;
                    _1714 = _1712 + -1.0f;
                    _1715 = f16tof32(_1667);
                    _1734 = saturate(1.0f - dot(float3(_179, _180, _181), float3(_1632, _1633, _1634))) * f16tof32(_1661);
                    _1738 = (_1734 * _179) + _198;
                    _1739 = (_1734 * _180) + _199;
                    _1740 = (_1734 * _181) - _197;
                    _1744 = mad(_1616, _1740, mad(_1615, _1739, (_1738 * _1614))) + _1617;
                    _1748 = mad(_1622, _1740, mad(_1621, _1739, (_1738 * _1620))) + _1623;
                    _1752 = mad(_1628, _1740, mad(_1627, _1739, (_1738 * _1626))) + _1629;
                    _1753 = saturate(_1752);
                    _1776 = saturate(1.0f - (_1744 * f16tof32(_1676))) + saturate(1.0f - ((1.0f - _1744) * f16tof32(((uint)((uint)(_1676) >> 16)))));
                    _1777 = saturate(1.0f - (_1748 * f16tof32(_1679))) + saturate(1.0f - ((1.0f - _1748) * f16tof32(((uint)((uint)(_1679) >> 16)))));
                    _1778 = saturate(1.0f - (_1752 * f16tof32(_1682))) + saturate(1.0f - ((1.0f - _1752) * f16tof32(((uint)((uint)(_1682) >> 16)))));
                    _1781 = saturate(1.0f - dot(float3(_1776, _1777, _1778), float3(_1776, _1777, _1778)));
                    _1782 = _1781 * _1781;
                    if (!(((_1440 & 3584) == 0) || (!(_1782 > 0.0f)))) {
                      _1789 = 1.0f - _1753;
                      _1790 = saturate(_1744);
                      _1791 = saturate(_1748);
                      bool __branch_chain_1786;
                      [branch]
                      if ((_1440 & 1024) == 0) {
                        _2054 = 1.0f;
                        _2055 = 0.0f;
                        _2056 = _1789;
                        __branch_chain_1786 = true;
                      } else {
                        _1796 = ((_1790 * _1714) + 0.5f) * _1713;
                        _1798 = ((_1791 * _1714) + 0.5f) * _1713;
                        _1799 = _1789 + f16tof32(((uint)((uint)(_1661) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1649) >> 16))];
                        _1802 = saturate(_1799);
                        _1806 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1815 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1806 * 32.665000915527344f) + _124), ((_1806 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1816 = sin(_1815);
                        _1817 = cos(_1815);
                        _1818 = cbSharedPerViewData.nFrameCounter & 3;
                        _1823 = sqrt((float((int)(_1818)) * 0.25f) + 0.125f) * _1709;
                        _1832 = (_global_7[min((uint)(((int)(0u + (_1818 * 2)))), 127u)]) * _1823;
                        _1833 = (_global_7[min((uint)(((int)(1u + (_1818 * 2)))), 127u)]) * _1823;
                        _1835 = -0.0f - _1816;
                        _1840 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1832, _1833), float2(_1817, _1816)) + _1796), (dot(float2(_1832, _1833), float2(_1835, _1817)) + _1798)));
                        _1845 = _1840.x - _1802;
                        _1847 = select((_1845 < 0.0f), 0.0f, 1.0f);
                        _1849 = _1840.y - _1802;
                        _1851 = select((_1849 < 0.0f), 0.0f, 1.0f);
                        _1855 = _1840.z - _1802;
                        _1857 = select((_1855 < 0.0f), 0.0f, 1.0f);
                        _1861 = _1840.w - _1802;
                        _1863 = select((_1861 < 0.0f), 0.0f, 1.0f);
                        _1870 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _1875 = sqrt((float((int)(_1870)) * 0.25f) + 0.125f) * _1709;
                        _1884 = (_global_7[min((uint)(((int)(0u + (_1870 * 2)))), 127u)]) * _1875;
                        _1885 = (_global_7[min((uint)(((int)(1u + (_1870 * 2)))), 127u)]) * _1875;
                        _1891 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1884, _1885), float2(_1817, _1816)) + _1796), (dot(float2(_1884, _1885), float2(_1835, _1817)) + _1798)));
                        _1896 = _1891.x - _1802;
                        _1898 = select((_1896 < 0.0f), 0.0f, 1.0f);
                        _1902 = _1891.y - _1802;
                        _1904 = select((_1902 < 0.0f), 0.0f, 1.0f);
                        _1908 = _1891.z - _1802;
                        _1910 = select((_1908 < 0.0f), 0.0f, 1.0f);
                        _1914 = _1891.w - _1802;
                        _1916 = select((_1914 < 0.0f), 0.0f, 1.0f);
                        _1923 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _1928 = sqrt((float((int)(_1923)) * 0.25f) + 0.125f) * _1709;
                        _1937 = (_global_7[min((uint)(((int)(0u + (_1923 * 2)))), 127u)]) * _1928;
                        _1938 = (_global_7[min((uint)(((int)(1u + (_1923 * 2)))), 127u)]) * _1928;
                        _1944 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1937, _1938), float2(_1817, _1816)) + _1796), (dot(float2(_1937, _1938), float2(_1835, _1817)) + _1798)));
                        _1949 = _1944.x - _1802;
                        _1951 = select((_1949 < 0.0f), 0.0f, 1.0f);
                        _1955 = _1944.y - _1802;
                        _1957 = select((_1955 < 0.0f), 0.0f, 1.0f);
                        _1961 = _1944.z - _1802;
                        _1963 = select((_1961 < 0.0f), 0.0f, 1.0f);
                        _1967 = _1944.w - _1802;
                        _1969 = select((_1967 < 0.0f), 0.0f, 1.0f);
                        _1976 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _1981 = sqrt((float((int)(_1976)) * 0.25f) + 0.125f) * _1709;
                        _1990 = (_global_7[min((uint)(((int)(0u + (_1976 * 2)))), 127u)]) * _1981;
                        _1991 = (_global_7[min((uint)(((int)(1u + (_1976 * 2)))), 127u)]) * _1981;
                        _1997 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1990, _1991), float2(_1817, _1816)) + _1796), (dot(float2(_1990, _1991), float2(_1835, _1817)) + _1798)));
                        _2002 = _1997.x - _1802;
                        _2004 = select((_2002 < 0.0f), 0.0f, 1.0f);
                        _2008 = _1997.y - _1802;
                        _2010 = select((_2008 < 0.0f), 0.0f, 1.0f);
                        _2014 = _1997.z - _1802;
                        _2016 = select((_2014 < 0.0f), 0.0f, 1.0f);
                        _2020 = _1997.w - _1802;
                        _2022 = select((_2020 < 0.0f), 0.0f, 1.0f);
                        _2023 = ((((((((((((((_1847 + _1851) + _1857) + _1863) + _1898) + _1904) + _1910) + _1916) + _1951) + _1957) + _1963) + _1969) + _2004) + _2010) + _2016) + _2022;
                        _2034 = (saturate(_2023 * 0.0625f) * 2.0f) + -1.0f;
                        _2040 = float((int)(((int)(uint)((int)(_2034 > 0.0f))) - ((int)(uint)((int)(_2034 < 0.0f)))));
                        _2042 = 1.0f - (_2040 * _2034);
                        _2044 = (_2042 * _2042) * _2042;
                        _2051 = 0.5f - ((_2040 * 0.5f) * ((1.0f - _2044) - ((_2042 - _2044) * saturate(((1.0f / _1802) * (1.0f / _2023)) * ((((((((((((((((_1847 * _1845) + (_1851 * _1849)) + (_1857 * _1855)) + (_1863 * _1861)) + (_1898 * _1896)) + (_1904 * _1902)) + (_1910 * _1908)) + (_1916 * _1914)) + (_1951 * _1949)) + (_1957 * _1955)) + (_1963 * _1961)) + (_1969 * _1967)) + (_2004 * _2002)) + (_2010 * _2008)) + (_2016 * _2014)) + (_2022 * _2020))))));
                        [branch]
                        if (_1715 < 1.0f) {
                          _2054 = _2051;
                          _2055 = _1715;
                          _2056 = _1799;
                          __branch_chain_1786 = true;
                        } else {
                          _2524 = _2051;
                          __branch_chain_1786 = false;
                        }
                      }
                      if (__branch_chain_1786) {
                        _2059 = (_1790 * _1655) + _1657;
                        _2060 = (_1791 * _1656) + _1658;
                        if (!((_1440 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _2069 = saturate(_2056);
                          _2073 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2082 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2073 * 32.665000915527344f) + _124), ((_2073 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2083 = sin(_2082);
                          _2084 = cos(_2082);
                          _2089 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2059, _2060), 0.0f))).x) > _2069), 1.0f, 0.0f);
                          _2090 = cbSharedPerViewData.nFrameCounter & 3;
                          _2095 = sqrt((float((int)(_2090)) * 0.25f) + 0.125f) * _1710;
                          _2104 = (_global_7[min((uint)(((int)(0u + (_2090 * 2)))), 127u)]) * _2095;
                          _2105 = (_global_7[min((uint)(((int)(1u + (_2090 * 2)))), 127u)]) * _2095;
                          _2107 = -0.0f - _2083;
                          _2109 = dot(float2(_2104, _2105), float2(_2084, _2083)) + _2059;
                          _2110 = dot(float2(_2104, _2105), float2(_2107, _2084)) + _2060;
                          _2112 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2109, _2110));
                          _2116 = _2109 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2117 = _2110 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2120 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1657);
                          _2121 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1658);
                          _2126 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1655 + _1657)) + 0.5f);
                          _2127 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1656 + _1658)) + 0.5f);
                          _2130 = floor(_2116 + -0.5f);
                          _2131 = floor(_2117 + 0.5f);
                          _2133 = floor(_2116 + 0.5f);
                          _2135 = floor(_2117 + -0.5f);
                          _2136 = (_2130 < _2120);
                          _2137 = (_2131 < _2121);
                          if ((_2136 || _2137) | ((_2130 >= _2126) || (_2131 >= _2127))) {
                            _2146 = _2089;
                          } else {
                            _2146 = _2112.x;
                          }
                          _2147 = (_2133 < _2120);
                          if ((_2147 || _2137) | ((_2133 >= _2126) || (_2131 >= _2127))) {
                            _2155 = _2089;
                          } else {
                            _2155 = _2112.y;
                          }
                          _2156 = (_2135 < _2121);
                          if ((_2147 || _2156) | ((_2133 >= _2126) || (_2135 >= _2127))) {
                            _2164 = _2089;
                          } else {
                            _2164 = _2112.z;
                          }
                          if ((_2136 || _2156) | ((_2130 >= _2126) || (_2135 >= _2127))) {
                            _2172 = _2089;
                          } else {
                            _2172 = _2112.w;
                          }
                          _2173 = _2146 - _2069;
                          _2175 = select((_2173 < 0.0f), 0.0f, 1.0f);
                          _2177 = _2155 - _2069;
                          _2179 = select((_2177 < 0.0f), 0.0f, 1.0f);
                          _2183 = _2164 - _2069;
                          _2185 = select((_2183 < 0.0f), 0.0f, 1.0f);
                          _2189 = _2172 - _2069;
                          _2191 = select((_2189 < 0.0f), 0.0f, 1.0f);
                          _2198 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2203 = sqrt((float((int)(_2198)) * 0.25f) + 0.125f) * _1710;
                          _2212 = (_global_7[min((uint)(((int)(0u + (_2198 * 2)))), 127u)]) * _2203;
                          _2213 = (_global_7[min((uint)(((int)(1u + (_2198 * 2)))), 127u)]) * _2203;
                          _2216 = dot(float2(_2212, _2213), float2(_2084, _2083)) + _2059;
                          _2217 = dot(float2(_2212, _2213), float2(_2107, _2084)) + _2060;
                          _2219 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2216, _2217));
                          _2223 = _2216 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2224 = _2217 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2227 = floor(_2223 + -0.5f);
                          _2228 = floor(_2224 + 0.5f);
                          _2230 = floor(_2223 + 0.5f);
                          _2232 = floor(_2224 + -0.5f);
                          _2233 = (_2227 < _2120);
                          _2234 = (_2228 < _2121);
                          if ((_2233 || _2234) | ((_2227 >= _2126) || (_2228 >= _2127))) {
                            _2243 = _2089;
                          } else {
                            _2243 = _2219.x;
                          }
                          _2244 = (_2230 < _2120);
                          if ((_2244 || _2234) | ((_2230 >= _2126) || (_2228 >= _2127))) {
                            _2252 = _2089;
                          } else {
                            _2252 = _2219.y;
                          }
                          _2253 = (_2232 < _2121);
                          if ((_2244 || _2253) | ((_2230 >= _2126) || (_2232 >= _2127))) {
                            _2261 = _2089;
                          } else {
                            _2261 = _2219.z;
                          }
                          if ((_2233 || _2253) | ((_2227 >= _2126) || (_2232 >= _2127))) {
                            _2269 = _2089;
                          } else {
                            _2269 = _2219.w;
                          }
                          _2270 = _2243 - _2069;
                          _2272 = select((_2270 < 0.0f), 0.0f, 1.0f);
                          _2276 = _2252 - _2069;
                          _2278 = select((_2276 < 0.0f), 0.0f, 1.0f);
                          _2282 = _2261 - _2069;
                          _2284 = select((_2282 < 0.0f), 0.0f, 1.0f);
                          _2288 = _2269 - _2069;
                          _2290 = select((_2288 < 0.0f), 0.0f, 1.0f);
                          _2297 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2302 = sqrt((float((int)(_2297)) * 0.25f) + 0.125f) * _1710;
                          _2311 = (_global_7[min((uint)(((int)(0u + (_2297 * 2)))), 127u)]) * _2302;
                          _2312 = (_global_7[min((uint)(((int)(1u + (_2297 * 2)))), 127u)]) * _2302;
                          _2315 = dot(float2(_2311, _2312), float2(_2084, _2083)) + _2059;
                          _2316 = dot(float2(_2311, _2312), float2(_2107, _2084)) + _2060;
                          _2318 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2315, _2316));
                          _2322 = _2315 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2323 = _2316 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2326 = floor(_2322 + -0.5f);
                          _2327 = floor(_2323 + 0.5f);
                          _2329 = floor(_2322 + 0.5f);
                          _2331 = floor(_2323 + -0.5f);
                          _2332 = (_2326 < _2120);
                          _2333 = (_2327 < _2121);
                          if ((_2332 || _2333) | ((_2326 >= _2126) || (_2327 >= _2127))) {
                            _2342 = _2089;
                          } else {
                            _2342 = _2318.x;
                          }
                          _2343 = (_2329 < _2120);
                          if ((_2343 || _2333) | ((_2329 >= _2126) || (_2327 >= _2127))) {
                            _2351 = _2089;
                          } else {
                            _2351 = _2318.y;
                          }
                          _2352 = (_2331 < _2121);
                          if ((_2343 || _2352) | ((_2329 >= _2126) || (_2331 >= _2127))) {
                            _2360 = _2089;
                          } else {
                            _2360 = _2318.z;
                          }
                          if ((_2332 || _2352) | ((_2326 >= _2126) || (_2331 >= _2127))) {
                            _2368 = _2089;
                          } else {
                            _2368 = _2318.w;
                          }
                          _2369 = _2342 - _2069;
                          _2371 = select((_2369 < 0.0f), 0.0f, 1.0f);
                          _2375 = _2351 - _2069;
                          _2377 = select((_2375 < 0.0f), 0.0f, 1.0f);
                          _2381 = _2360 - _2069;
                          _2383 = select((_2381 < 0.0f), 0.0f, 1.0f);
                          _2387 = _2368 - _2069;
                          _2389 = select((_2387 < 0.0f), 0.0f, 1.0f);
                          _2396 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2401 = sqrt((float((int)(_2396)) * 0.25f) + 0.125f) * _1710;
                          _2410 = (_global_7[min((uint)(((int)(0u + (_2396 * 2)))), 127u)]) * _2401;
                          _2411 = (_global_7[min((uint)(((int)(1u + (_2396 * 2)))), 127u)]) * _2401;
                          _2414 = dot(float2(_2410, _2411), float2(_2084, _2083)) + _2059;
                          _2415 = dot(float2(_2410, _2411), float2(_2107, _2084)) + _2060;
                          _2417 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2414, _2415));
                          _2421 = _2414 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2422 = _2415 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2425 = floor(_2421 + -0.5f);
                          _2426 = floor(_2422 + 0.5f);
                          _2428 = floor(_2421 + 0.5f);
                          _2430 = floor(_2422 + -0.5f);
                          _2431 = (_2425 < _2120);
                          _2432 = (_2426 < _2121);
                          if ((_2431 || _2432) | ((_2425 >= _2126) || (_2426 >= _2127))) {
                            _2441 = _2089;
                          } else {
                            _2441 = _2417.x;
                          }
                          _2442 = (_2428 < _2120);
                          if ((_2442 || _2432) | ((_2428 >= _2126) || (_2426 >= _2127))) {
                            _2450 = _2089;
                          } else {
                            _2450 = _2417.y;
                          }
                          _2451 = (_2430 < _2121);
                          if ((_2442 || _2451) | ((_2428 >= _2126) || (_2430 >= _2127))) {
                            _2459 = _2089;
                          } else {
                            _2459 = _2417.z;
                          }
                          if ((_2431 || _2451) | ((_2425 >= _2126) || (_2430 >= _2127))) {
                            _2467 = _2089;
                          } else {
                            _2467 = _2417.w;
                          }
                          _2468 = _2441 - _2069;
                          _2470 = select((_2468 < 0.0f), 0.0f, 1.0f);
                          _2474 = _2450 - _2069;
                          _2476 = select((_2474 < 0.0f), 0.0f, 1.0f);
                          _2480 = _2459 - _2069;
                          _2482 = select((_2480 < 0.0f), 0.0f, 1.0f);
                          _2486 = _2467 - _2069;
                          _2488 = select((_2486 < 0.0f), 0.0f, 1.0f);
                          _2489 = ((((((((((((((_2179 + _2175) + _2185) + _2191) + _2272) + _2278) + _2284) + _2290) + _2371) + _2377) + _2383) + _2389) + _2470) + _2476) + _2482) + _2488;
                          _2500 = (saturate(_2489 * 0.0625f) * 2.0f) + -1.0f;
                          _2506 = float((int)(((int)(uint)((int)(_2500 > 0.0f))) - ((int)(uint)((int)(_2500 < 0.0f)))));
                          _2508 = 1.0f - (_2506 * _2500);
                          _2510 = (_2508 * _2508) * _2508;
                          _2519 = (0.5f - ((_2506 * 0.5f) * ((1.0f - _2510) - ((_2508 - _2510) * saturate(((1.0f / _2069) * (1.0f / _2489)) * ((((((((((((((((_2179 * _2177) + (_2175 * _2173)) + (_2185 * _2183)) + (_2191 * _2189)) + (_2272 * _2270)) + (_2278 * _2276)) + (_2284 * _2282)) + (_2290 * _2288)) + (_2371 * _2369)) + (_2377 * _2375)) + (_2383 * _2381)) + (_2389 * _2387)) + (_2470 * _2468)) + (_2476 * _2474)) + (_2482 * _2480)) + (_2488 * _2486)))))));
                        } else {
                          _2519 = 1.0f;
                        }
                        _2524 = (lerp(_2519, _2054, _2055));
                      }
                      [branch]
                      if (!((_1440 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1652) >> 16))];
                        _2530 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1744, _1748), 0.0f);
                        if (_2530.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1652 & 65535))];
                          _2537 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1744, _1748), 0.0f);
                          _2551 = mad(saturate(((log2(_1753 * _1637) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2552 = max(9.999999747378752e-06f, _2530.x);
                          _2553 = _2537.x / _2552;
                          _2554 = _2537.y / _2552;
                          _2556 = _2537.w / _2552;
                          _2561 = ((0.375f - _2554) * 4.999999873689376e-06f) + _2554;
                          _2564 = -0.0f - _2553;
                          _2565 = mad(_2564, _2561, (_2537.z / _2552));
                          _2567 = 1.0f / mad(_2564, _2553, _2561);
                          _2568 = _2567 * _2565;
                          _2573 = _2551 - _2553;
                          _2578 = (((_2551 * _2551) - _2561) - (_2568 * _2573)) / mad((-0.0f - _2565), _2568, mad((-0.0f - _2561), _2561, (((0.375f - _2556) * 4.999999873689376e-06f) + _2556)));
                          _2580 = (_2567 * _2573) - (_2578 * _2568);
                          _2583 = 1.0f / _2578;
                          _2584 = _2580 * _2583;
                          _2589 = sqrt(((_2584 * _2584) * 0.25f) - ((1.0f - dot(float2(_2580, _2578), float2(_2553, _2561))) * _2583));
                          _2591 = (_2584 * -0.5f) - _2589;
                          _2593 = _2589 - (_2584 * 0.5f);
                          _2595 = select((_2591 < _2551), 1.0f, 0.0f);
                          _2600 = (_2595 + -0.05000000074505806f) / (_2591 - _2551);
                          _2606 = (((select((_2593 < _2551), 1.0f, 0.0f) - _2595) / (_2593 - _2591)) - _2600) / (_2593 - _2551);
                          _2608 = _2600 - (_2606 * _2591);
                          _2621 = (exp2((_2530.x * -1.4426950216293335f) * saturate((dot(float2(_2553, _2561), float2((_2608 - (_2606 * _2551)), _2606)) + 0.05000000074505806f) - (_2608 * _2551))) * _2524);
                        } else {
                          _2621 = _2524;
                        }
                      } else {
                        _2621 = _2524;
                      }
                    } else {
                      _2621 = 1.0f;
                    }
                    [branch]
                    if (!(_1699 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1699)))];
                      _2634 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1744 * f16tof32(((uint)((uint)(_1670) >> 16)))) + f16tof32(((uint)((uint)(_1673) >> 16)))), ((_1748 * f16tof32(_1670)) + f16tof32(_1673))), 0.0f);
                      _2642 = (_2634.x * _1684);
                      _2643 = (_2634.y * _1685);
                      _2644 = (_2634.z * _1687);
                    } else {
                      _2642 = _1684;
                      _2643 = _1685;
                      _2644 = _1687;
                    }
                    _2645 = _2621 * _1782;
                    [branch]
                    if (!(_2645 == 0.0f)) {
                      bool __branch_chain_2647;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2663 = 0;
                        __branch_chain_2647 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2663 = 1;
                          __branch_chain_2647 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2663 = 2;
                            __branch_chain_2647 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2663 = 3;
                              __branch_chain_2647 = true;
                            } else {
                              _2684 = _2645;
                              __branch_chain_2647 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2647) {
                        while(true) {
                          _2666 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_62, _63, 0));
                          if (_2663 == 0) {
                            _2680 = _2666.x;
                          } else {
                            if (_2663 == 1) {
                              _2680 = _2666.y;
                            } else {
                              if (_2663 == 2) {
                                _2680 = _2666.z;
                              } else {
                                _2680 = _2666.w;
                              }
                            }
                          }
                          _2684 = ((_2680 * _2680) * _1782);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2684 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2694 = srvLightMappingData[_1443];
                            if (!(_2694 == -1)) {
                              _2699 = srvLightIndexData[_2694].nLayerIndex;
                              _2701 = srvLightIndexData[_2694].vAtlasOrigin.x;
                              _2702 = srvLightIndexData[_2694].vAtlasOrigin.y;
                              _2704 = srvLightIndexData[_2694].vScreenOrigin.x;
                              _2705 = srvLightIndexData[_2694].vScreenOrigin.y;
                              _2714 = ((int)(_2699 * 5)) & 31;
                              _2723 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2701 + _62) - _2704)), ((int)((_2702 + _63) - _2705)), 0)))).x) & ((int)(31 << _2714)))) >> _2714)) >> 1)))) * 0.06666667014360428f) * _2684);
                            } else {
                              _2723 = _2684;
                            }
                          } else {
                            _2723 = _2684;
                          }
                          _2727 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2730 = select(_2727, (_2723 * _1190), _2723);
                          _2732 = dot(float3(_1632, _1633, _1634), float3(_1632, _1633, _1634));
                          _2733 = rsqrt(_2732);
                          _2734 = _2733 * _1632;
                          _2735 = _2733 * _1633;
                          _2736 = _2733 * _1634;
                          _2737 = dot(float3(_179, _180, _181), float3(_2734, _2735, _2736));
                          if (_1696 > 0.0f) {
                            _2745 = sqrt(saturate((_1696 * _1696) * (1.0f / (_2732 + 1.0f))));
                            if (_2737 < _2745) {
                              _2750 = max(_2737, (-0.0f - _2745)) + _2745;
                              _2755 = ((_2750 * _2750) / (_2745 * 4.0f));
                            } else {
                              _2755 = _2737;
                            }
                          } else {
                            _2755 = _2737;
                          }
                          _2756 = _190 * _190;
                          _2760 = saturate((_1696 * (1.0f - _2756)) * _2733);
                          _2762 = saturate(_2733 * f16tof32(_1646));
                          _2763 = dot(float3(_179, _180, _181), float3(_371, _372, _370));
                          _2764 = dot(float3(_371, _372, _370), float3(_2734, _2735, _2736));
                          _2767 = rsqrt((_2764 * 2.0f) + 2.0f);
                          _2774 = (_2760 > 0.0f);
                          if (_2774) {
                            _2778 = sqrt(1.0f - (_2760 * _2760));
                            _2780 = (_2737 * 2.0f) * _2763;
                            _2781 = _2780 - _2764;
                            if (!(_2781 >= _2778)) {
                              _2789 = rsqrt(1.0f - (_2781 * _2781)) * _2760;
                              _2792 = _2789 * (_2763 - (_2781 * _2737));
                              _2793 = _2763 * _2763;
                              _2798 = _2789 * (((_2793 * 2.0f) + -1.0f) - (_2781 * _2764));
                              _2807 = sqrt(saturate((((1.0f - (_2737 * _2737)) - _2793) - (_2764 * _2764)) + (_2780 * _2764)));
                              _2808 = _2807 * _2789;
                              _2811 = ((_2763 * 2.0f) * _2789) * _2807;
                              _2813 = (_2778 * _2737) + _2763;
                              _2814 = _2813 + _2792;
                              _2815 = _2778 * _2764;
                              _2817 = (_2815 + 1.0f) + _2798;
                              _2818 = _2808 * _2817;
                              _2819 = _2814 * _2817;
                              _2820 = _2811 * _2814;
                              _2825 = (((_2814 * 0.25f) * _2811) - (_2818 * 0.5f)) * _2819;
                              _2839 = (((_2820 - (_2818 * 2.0f)) * _2820) + (_2818 * _2818)) + ((((-0.5f - ((_2817 + _2815) * 0.5f)) * _2819) + ((_2817 * _2817) * _2813)) * _2814);
                              _2844 = (_2825 * 2.0f) / ((_2839 * _2839) + (_2825 * _2825));
                              _2845 = _2839 * _2844;
                              _2847 = 1.0f - (_2825 * _2844);
                              _2853 = ((_2845 * _2811) + _2815) + (_2847 * _2798);
                              _2856 = rsqrt((_2853 * 2.0f) + 2.0f);
                              _2865 = saturate((_2853 * _2856) + _2856);
                              _2866 = saturate(((_2813 + (_2845 * _2808)) + (_2847 * _2792)) * _2856);
                            } else {
                              _2865 = abs(_2763);
                              _2866 = 1.0f;
                            }
                          } else {
                            _2865 = saturate((_2767 * _2764) + _2767);
                            _2866 = saturate(_2767 * (_2763 + _2737));
                          }
                          _2867 = saturate(_2755);
                          _2868 = _2756 * _2756;
                          if (_2762 > 0.0f) {
                            _2878 = saturate(((_2762 * _2762) / ((_2865 * 3.5999999046325684f) + 0.4000000059604645f)) + _2868);
                          } else {
                            _2878 = _2868;
                          }
                          _2879 = sqrt(_2878);
                          if (_2774) {
                            _2890 = (_2878 / ((((_2760 * 0.25f) * ((_2879 * 3.0f) + _2760)) / (_2865 + 0.0010000000474974513f)) + _2878));
                          } else {
                            _2890 = 1.0f;
                          }
                          _2894 = (((_2878 * _2866) - _2866) * _2866) + 1.0f;
                          _2899 = saturate(abs(_2763) + 9.999999747378752e-06f);
                          _2900 = 1.0f - _2879;
                          _2912 = saturate((_2737 + _1694) / (_1694 + 1.0f));
                          _2915 = ((_2890 * _2867) * (_2878 / (_2894 * _2894))) * (0.5f / ((((_2900 * _2899) + _2879) * _2867) + (((_2900 * _2867) + _2879) * _2899)));
                          _2916 = _2642 * _1490;
                          _2917 = _2643 * _1490;
                          _2918 = _2644 * _1490;
                          _2925 = ((_2730 * _2916) * _2912) + _1428;
                          _2926 = ((_2730 * _2917) * _2912) + _1429;
                          _2927 = ((_2730 * _2918) * _2912) + _1430;
                          if (_1691 > 0.0f) {
                            _2935 = (exp2(log2(1.0f - saturate(_2865)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                            _2936 = select(_2727, (_2723 * _1190), _2723) * _1691;
                            _8238 = _2925;
                            _8239 = _2926;
                            _8240 = _2927;
                            _8241 = (((((_2916 * _1059) * _2936) * _2935) * _2915) + _1431);
                            _8242 = (((((_2917 * _1059) * _2936) * _2935) * _2915) + _1432);
                            _8243 = (((((_2918 * _1059) * _2936) * _2935) * _2915) + _1433);
                          } else {
                            _8238 = _2925;
                            _8239 = _2926;
                            _8240 = _2927;
                            _8241 = _1431;
                            _8242 = _1432;
                            _8243 = _1433;
                          }
                        } else {
                          _8238 = _1428;
                          _8239 = _1429;
                          _8240 = _1430;
                          _8241 = _1431;
                          _8242 = _1432;
                          _8243 = _1433;
                        }
                        break;
                      }
                    } else {
                      _8238 = _1428;
                      _8239 = _1429;
                      _8240 = _1430;
                      _8241 = _1431;
                      _8242 = _1432;
                      _8243 = _1433;
                    }
                  } else {
                    if (_1473 == 7) {
                      _3384 = asfloat(srvLightInfoProperties.Load3(_1442)).x;
                      _3385 = asfloat(srvLightInfoProperties.Load3(_1442)).y;
                      _3386 = asfloat(srvLightInfoProperties.Load3(_1442)).z;
                      _3389 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 12u)))).x;
                      _3390 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 12u)))).y;
                      _3391 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 12u)))).z;
                      _3394 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 24u)))).x;
                      _3395 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 24u)))).y;
                      _3396 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 24u)))).z;
                      _3399 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 36u)))).x;
                      _3400 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 36u)))).y;
                      _3401 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 36u)))).z;
                      _3404 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).x;
                      _3405 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).y;
                      _3406 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 48u)))).z;
                      _3409 = asint(srvLightInfoProperties.Load(((int)(_1442 + 60u))));
                      _3412 = asint(srvLightInfoProperties.Load(((int)(_1442 + 64u))));
                      _3415 = asint(srvLightInfoProperties.Load(((int)(_1442 + 72u))));
                      _3418 = asint(srvLightInfoProperties.Load(((int)(_1442 + 76u))));
                      _3421 = asint(srvLightInfoProperties.Load(((int)(_1442 + 80u))));
                      _3424 = asint(srvLightInfoProperties.Load(((int)(_1442 + 84u))));
                      _3427 = asint(srvLightInfoProperties.Load(((int)(_1442 + 88u))));
                      _3430 = asint(srvLightInfoProperties.Load(((int)(_1442 + 92u))));
                      _3433 = asint(srvLightInfoProperties.Load(((int)(_1442 + 96u))));
                      _3436 = asint(srvLightInfoProperties.Load(((int)(_1442 + 100u))));
                      _3439 = asint(srvLightInfoProperties.Load(((int)(_1442 + 104u))));
                      _3442 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).x;
                      _3443 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).y;
                      _3444 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).z;
                      _3445 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).w;
                      _3448 = asint(srvLightInfoProperties.Load(((int)(_1442 + 124u))));
                      _3451 = asint(srvLightInfoProperties.Load(((int)(_1442 + 128u))));
                      _3454 = asint(srvLightInfoProperties.Load(((int)(_1442 + 136u))));
                      _3457 = asint(srvLightInfoProperties.Load(((int)(_1442 + 140u))));
                      _3459 = f16tof32(((uint)((uint)(_3409) >> 16)));
                      _3460 = f16tof32(_3409);
                      _3462 = f16tof32(((uint)((uint)(_3412) >> 16)));
                      _3466 = ((float)((uint)((uint)(((uint)(_3412) >> 8) & 255)))) * 0.003921499941498041f;
                      _3469 = ((float)((uint)((uint)(_3412 & 255)))) * 0.003921499941498041f;
                      _3470 = f16tof32(_3415);
                      _3472 = f16tof32(((uint)((uint)(_3418) >> 16)));
                      _3476 = f16tof32(_3421);
                      _3478 = f16tof32(((uint)((uint)(_3424) >> 16)));
                      _3479 = f16tof32(_3424);
                      _3481 = f16tof32(((uint)((uint)(_3427) >> 16)));
                      _3484 = _3430 & 65535;
                      _3488 = ((_1440 & 4194304) != 0);
                      _3496 = f16tof32(((uint)((uint)(_3439) >> 16)));
                      _3497 = f16tof32(_3439);
                      _3499 = f16tof32(((uint)((uint)(_3448) >> 16)));
                      _3502 = f16tof32(((uint)((uint)(_3451) >> 16)));
                      _3503 = f16tof32(_3451);
                      _3505 = f16tof32(((uint)((uint)(_3454) >> 16)));
                      _3506 = _3505 + -1.0f;
                      if (_3488) {
                        _3508 = 0.5f / _3505;
                        _3509 = 0.3333333432674408f / _3505;
                        _3513 = (_3505 * 0.5f) + 0.5f;
                        _3523 = (_3508 * _3506);
                        _3524 = (_3509 * _3506);
                        _3525 = (_3508 * _3513);
                        _3526 = (_3509 * _3513);
                        _3527 = (_3505 * 2.0f);
                        _3528 = (_3505 * 3.0f);
                      } else {
                        _3519 = 1.0f / _3505;
                        _3520 = _3519 * _3506;
                        _3521 = _3519 * 0.5f;
                        _3523 = _3520;
                        _3524 = _3520;
                        _3525 = _3521;
                        _3526 = _3521;
                        _3527 = _3505;
                        _3528 = _3505;
                      }
                      _3532 = _3399 - _198;
                      _3533 = _3400 - _199;
                      _3534 = _3401 + _197;
                      _3535 = dot(float3(_3532, _3533, _3534), float3(_3532, _3533, _3534));
                      _3536 = rsqrt(_3535);
                      _3537 = _3536 * _3535;
                      _3538 = _3536 * _3532;
                      _3539 = _3536 * _3533;
                      _3540 = _3536 * _3534;
                      _3543 = max(0.0f, (_3537 - abs(_3476)));
                      _3544 = _3543 * f16tof32(((uint)((uint)(_3421) >> 16)));
                      _3545 = _3544 * _3544;
                      _3548 = saturate(1.0f - (_3545 * _3545));
                      _3555 = (_3548 * _3548) / (select((_3476 < 0.0f), (_3545 * 16.0f), (_3543 * _3543)) + 1.0f);
                      _3568 = saturate(1.0f - dot(float3(_179, _180, _181), float3(_3538, _3539, _3540))) * f16tof32(_3448);
                      _3572 = abs(_3534);
                      _3576 = _3532 - ((_3568 * _179) * _3572);
                      _3577 = _3533 - ((_3568 * _180) * _3572);
                      _3578 = _3534 - ((_3568 * _181) * _3572);
                      _3581 = mad(_3578, _3395, mad(_3577, _3390, (_3576 * _3385)));
                      _3584 = mad(_3578, _3396, mad(_3577, _3391, (_3576 * _3386)));
                      _3586 = ((_1440 & 3584) != 0);
                      if (_3586 && (_3555 > 0.0f)) {
                        _3592 = mad(_3578, _3394, mad(_3577, _3389, (_3576 * _3384)));
                        _3593 = -0.0f - _3584;
                        _3594 = -0.0f - _3581;
                        [branch]
                        if (!((_1440 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3430) >> 16))];
                          [branch]
                          if (_3488) {
                            _3599 = abs(_3592);
                            _3600 = abs(_3593);
                            _3601 = abs(_3594);
                            if (_3599 > max(_3600, _3601)) {
                              _3605 = (_3592 > 0.0f);
                              _3620 = select(_3605, 0.0f, 1.0f);
                              _3621 = 0.0f;
                              _3622 = select(_3605, _3581, _3594);
                              _3623 = _3584;
                              _3624 = _3599;
                            } else {
                              if (_3600 > _3601) {
                                _3611 = (_3584 < -0.0f);
                                _3620 = select(_3611, 0.0f, 1.0f);
                                _3621 = 1.0f;
                                _3622 = _3592;
                                _3623 = select(_3611, _3594, _3581);
                                _3624 = _3600;
                              } else {
                                _3615 = (_3581 < -0.0f);
                                _3620 = select(_3615, 0.0f, 1.0f);
                                _3621 = 2.0f;
                                _3622 = select(_3615, _3592, (-0.0f - _3592));
                                _3623 = _3584;
                                _3624 = _3601;
                              }
                            }
                            _3625 = _3624 * 2.0f;
                            _3629 = -0.0f - _3497;
                            _3638 = ((min(max((_3622 / _3625), _3629), _3497) + _3620) * _3523) + _3525;
                            _3639 = ((min(max((_3623 / _3625), _3629), _3497) + _3621) * _3524) + _3526;
                            _3646 = ((_3620 + -0.5f) * _3523) + _3525;
                            _3647 = ((_3621 + -0.5f) * _3524) + _3526;
                            _3650 = saturate((_3499 + 1.0f) - (_3624 * _3481));
                            _3654 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _3663 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_3654 * 32.665000915527344f) + _124), ((_3654 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _3664 = sin(_3663);
                            _3665 = cos(_3663);
                            _3670 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_3638, _3639), 0.0f))).x) > _3650), 1.0f, 0.0f);
                            _3671 = cbSharedPerViewData.nFrameCounter & 3;
                            _3676 = sqrt((float((int)(_3671)) * 0.25f) + 0.125f) * _3502;
                            _3685 = (_global_7[min((uint)(((int)(0u + (_3671 * 2)))), 127u)]) * _3676;
                            _3686 = (_global_7[min((uint)(((int)(1u + (_3671 * 2)))), 127u)]) * _3676;
                            _3688 = -0.0f - _3664;
                            _3690 = dot(float2(_3685, _3686), float2(_3665, _3664)) + _3638;
                            _3691 = dot(float2(_3685, _3686), float2(_3688, _3665)) + _3639;
                            _3693 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3690, _3691));
                            _3697 = _3690 * _3527;
                            _3698 = _3691 * _3528;
                            _3701 = floor(_3646 * _3527);
                            _3702 = floor(_3647 * _3528);
                            _3707 = floor(((_3646 + _3523) * _3527) + 0.5f);
                            _3708 = floor(((_3647 + _3524) * _3528) + 0.5f);
                            _3711 = floor(_3697 + -0.5f);
                            _3712 = floor(_3698 + 0.5f);
                            _3714 = floor(_3697 + 0.5f);
                            _3716 = floor(_3698 + -0.5f);
                            _3717 = (_3711 < _3701);
                            _3718 = (_3712 < _3702);
                            if ((_3717 || _3718) | ((_3711 >= _3707) || (_3712 >= _3708))) {
                              _3727 = _3670;
                            } else {
                              _3727 = _3693.x;
                            }
                            _3728 = (_3714 < _3701);
                            if ((_3728 || _3718) | ((_3714 >= _3707) || (_3712 >= _3708))) {
                              _3736 = _3670;
                            } else {
                              _3736 = _3693.y;
                            }
                            _3737 = (_3716 < _3702);
                            if ((_3728 || _3737) | ((_3714 >= _3707) || (_3716 >= _3708))) {
                              _3745 = _3670;
                            } else {
                              _3745 = _3693.z;
                            }
                            if ((_3717 || _3737) | ((_3711 >= _3707) || (_3716 >= _3708))) {
                              _3753 = _3670;
                            } else {
                              _3753 = _3693.w;
                            }
                            _3754 = _3727 - _3650;
                            _3756 = select((_3754 < 0.0f), 0.0f, 1.0f);
                            _3758 = _3736 - _3650;
                            _3760 = select((_3758 < 0.0f), 0.0f, 1.0f);
                            _3764 = _3745 - _3650;
                            _3766 = select((_3764 < 0.0f), 0.0f, 1.0f);
                            _3770 = _3753 - _3650;
                            _3772 = select((_3770 < 0.0f), 0.0f, 1.0f);
                            _3779 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _3784 = sqrt((float((int)(_3779)) * 0.25f) + 0.125f) * _3502;
                            _3793 = (_global_7[min((uint)(((int)(0u + (_3779 * 2)))), 127u)]) * _3784;
                            _3794 = (_global_7[min((uint)(((int)(1u + (_3779 * 2)))), 127u)]) * _3784;
                            _3797 = dot(float2(_3793, _3794), float2(_3665, _3664)) + _3638;
                            _3798 = dot(float2(_3793, _3794), float2(_3688, _3665)) + _3639;
                            _3800 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3797, _3798));
                            _3804 = _3797 * _3527;
                            _3805 = _3798 * _3528;
                            _3808 = floor(_3804 + -0.5f);
                            _3809 = floor(_3805 + 0.5f);
                            _3811 = floor(_3804 + 0.5f);
                            _3813 = floor(_3805 + -0.5f);
                            _3814 = (_3808 < _3701);
                            _3815 = (_3809 < _3702);
                            if ((_3814 || _3815) | ((_3808 >= _3707) || (_3809 >= _3708))) {
                              _3824 = _3670;
                            } else {
                              _3824 = _3800.x;
                            }
                            _3825 = (_3811 < _3701);
                            if ((_3825 || _3815) | ((_3811 >= _3707) || (_3809 >= _3708))) {
                              _3833 = _3670;
                            } else {
                              _3833 = _3800.y;
                            }
                            _3834 = (_3813 < _3702);
                            if ((_3825 || _3834) | ((_3811 >= _3707) || (_3813 >= _3708))) {
                              _3842 = _3670;
                            } else {
                              _3842 = _3800.z;
                            }
                            if ((_3814 || _3834) | ((_3808 >= _3707) || (_3813 >= _3708))) {
                              _3850 = _3670;
                            } else {
                              _3850 = _3800.w;
                            }
                            _3851 = _3824 - _3650;
                            _3853 = select((_3851 < 0.0f), 0.0f, 1.0f);
                            _3857 = _3833 - _3650;
                            _3859 = select((_3857 < 0.0f), 0.0f, 1.0f);
                            _3863 = _3842 - _3650;
                            _3865 = select((_3863 < 0.0f), 0.0f, 1.0f);
                            _3869 = _3850 - _3650;
                            _3871 = select((_3869 < 0.0f), 0.0f, 1.0f);
                            _3878 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _3883 = sqrt((float((int)(_3878)) * 0.25f) + 0.125f) * _3502;
                            _3892 = (_global_7[min((uint)(((int)(0u + (_3878 * 2)))), 127u)]) * _3883;
                            _3893 = (_global_7[min((uint)(((int)(1u + (_3878 * 2)))), 127u)]) * _3883;
                            _3896 = dot(float2(_3892, _3893), float2(_3665, _3664)) + _3638;
                            _3897 = dot(float2(_3892, _3893), float2(_3688, _3665)) + _3639;
                            _3899 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3896, _3897));
                            _3903 = _3896 * _3527;
                            _3904 = _3897 * _3528;
                            _3907 = floor(_3903 + -0.5f);
                            _3908 = floor(_3904 + 0.5f);
                            _3910 = floor(_3903 + 0.5f);
                            _3912 = floor(_3904 + -0.5f);
                            _3913 = (_3907 < _3701);
                            _3914 = (_3908 < _3702);
                            if ((_3913 || _3914) | ((_3907 >= _3707) || (_3908 >= _3708))) {
                              _3923 = _3670;
                            } else {
                              _3923 = _3899.x;
                            }
                            _3924 = (_3910 < _3701);
                            if ((_3924 || _3914) | ((_3910 >= _3707) || (_3908 >= _3708))) {
                              _3932 = _3670;
                            } else {
                              _3932 = _3899.y;
                            }
                            _3933 = (_3912 < _3702);
                            if ((_3924 || _3933) | ((_3910 >= _3707) || (_3912 >= _3708))) {
                              _3941 = _3670;
                            } else {
                              _3941 = _3899.z;
                            }
                            if ((_3913 || _3933) | ((_3907 >= _3707) || (_3912 >= _3708))) {
                              _3949 = _3670;
                            } else {
                              _3949 = _3899.w;
                            }
                            _3950 = _3923 - _3650;
                            _3952 = select((_3950 < 0.0f), 0.0f, 1.0f);
                            _3956 = _3932 - _3650;
                            _3958 = select((_3956 < 0.0f), 0.0f, 1.0f);
                            _3962 = _3941 - _3650;
                            _3964 = select((_3962 < 0.0f), 0.0f, 1.0f);
                            _3968 = _3949 - _3650;
                            _3970 = select((_3968 < 0.0f), 0.0f, 1.0f);
                            _3977 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _3982 = sqrt((float((int)(_3977)) * 0.25f) + 0.125f) * _3502;
                            _3991 = (_global_7[min((uint)(((int)(0u + (_3977 * 2)))), 127u)]) * _3982;
                            _3992 = (_global_7[min((uint)(((int)(1u + (_3977 * 2)))), 127u)]) * _3982;
                            _3995 = dot(float2(_3991, _3992), float2(_3665, _3664)) + _3638;
                            _3996 = dot(float2(_3991, _3992), float2(_3688, _3665)) + _3639;
                            _3998 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3995, _3996));
                            _4002 = _3995 * _3527;
                            _4003 = _3996 * _3528;
                            _4006 = floor(_4002 + -0.5f);
                            _4007 = floor(_4003 + 0.5f);
                            _4009 = floor(_4002 + 0.5f);
                            _4011 = floor(_4003 + -0.5f);
                            _4012 = (_4006 < _3701);
                            _4013 = (_4007 < _3702);
                            if ((_4012 || _4013) | ((_4006 >= _3707) || (_4007 >= _3708))) {
                              _4022 = _3670;
                            } else {
                              _4022 = _3998.x;
                            }
                            _4023 = (_4009 < _3701);
                            if ((_4023 || _4013) | ((_4009 >= _3707) || (_4007 >= _3708))) {
                              _4031 = _3670;
                            } else {
                              _4031 = _3998.y;
                            }
                            _4032 = (_4011 < _3702);
                            if ((_4023 || _4032) | ((_4009 >= _3707) || (_4011 >= _3708))) {
                              _4040 = _3670;
                            } else {
                              _4040 = _3998.z;
                            }
                            if ((_4012 || _4032) | ((_4006 >= _3707) || (_4011 >= _3708))) {
                              _4048 = _3670;
                            } else {
                              _4048 = _3998.w;
                            }
                            _4049 = _4022 - _3650;
                            _4051 = select((_4049 < 0.0f), 0.0f, 1.0f);
                            _4055 = _4031 - _3650;
                            _4057 = select((_4055 < 0.0f), 0.0f, 1.0f);
                            _4061 = _4040 - _3650;
                            _4063 = select((_4061 < 0.0f), 0.0f, 1.0f);
                            _4067 = _4048 - _3650;
                            _4069 = select((_4067 < 0.0f), 0.0f, 1.0f);
                            _4070 = ((((((((((((((_3760 + _3756) + _3766) + _3772) + _3853) + _3859) + _3865) + _3871) + _3952) + _3958) + _3964) + _3970) + _4051) + _4057) + _4063) + _4069;
                            _4081 = (saturate(_4070 * 0.0625f) * 2.0f) + -1.0f;
                            _4087 = float((int)(((int)(uint)((int)(_4081 > 0.0f))) - ((int)(uint)((int)(_4081 < 0.0f)))));
                            _4089 = 1.0f - (_4087 * _4081);
                            _4091 = (_4089 * _4089) * _4089;
                            _4383 = (0.5f - ((_4087 * 0.5f) * ((1.0f - _4091) - ((_4089 - _4091) * saturate(((1.0f / _3650) * (1.0f / _4070)) * ((((((((((((((((_3760 * _3758) + (_3756 * _3754)) + (_3766 * _3764)) + (_3772 * _3770)) + (_3853 * _3851)) + (_3859 * _3857)) + (_3865 * _3863)) + (_3871 * _3869)) + (_3952 * _3950)) + (_3958 * _3956)) + (_3964 * _3962)) + (_3970 * _3968)) + (_4051 * _4049)) + (_4057 * _4055)) + (_4063 * _4061)) + (_4069 * _4067)))))));
                            _4384 = 1.0f;
                            _4385 = 1;
                          } else {
                            _4100 = f16tof32(_3457) / _3594;
                            _4103 = mad((_4100 * _3592), 0.5f, 0.5f);
                            _4104 = mad((_4100 * _3593), 0.5f, 0.5f);
                            if (_3581 > -0.0f) {
                              if ((saturate(_4103) == _4103) && (saturate(_4104) == _4104)) {
                                _4118 = (_4103 * _3523) + _3525;
                                _4119 = (_4104 * _3524) + _3526;
                                _4120 = saturate((_3499 + 1.0f) - (_3581 * _3481));
                                _4124 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4133 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_4124 * 32.665000915527344f) + _124), ((_4124 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4134 = sin(_4133);
                                _4135 = cos(_4133);
                                _4136 = cbSharedPerViewData.nFrameCounter & 3;
                                _4141 = sqrt((float((int)(_4136)) * 0.25f) + 0.125f) * _3502;
                                _4150 = (_global_7[min((uint)(((int)(0u + (_4136 * 2)))), 127u)]) * _4141;
                                _4151 = (_global_7[min((uint)(((int)(1u + (_4136 * 2)))), 127u)]) * _4141;
                                _4153 = -0.0f - _4134;
                                _4158 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4150, _4151), float2(_4135, _4134)) + _4118), (dot(float2(_4150, _4151), float2(_4153, _4135)) + _4119)));
                                _4163 = _4158.x - _4120;
                                _4165 = select((_4163 < 0.0f), 0.0f, 1.0f);
                                _4167 = _4158.y - _4120;
                                _4169 = select((_4167 < 0.0f), 0.0f, 1.0f);
                                _4173 = _4158.z - _4120;
                                _4175 = select((_4173 < 0.0f), 0.0f, 1.0f);
                                _4179 = _4158.w - _4120;
                                _4181 = select((_4179 < 0.0f), 0.0f, 1.0f);
                                _4188 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4193 = sqrt((float((int)(_4188)) * 0.25f) + 0.125f) * _3502;
                                _4202 = (_global_7[min((uint)(((int)(0u + (_4188 * 2)))), 127u)]) * _4193;
                                _4203 = (_global_7[min((uint)(((int)(1u + (_4188 * 2)))), 127u)]) * _4193;
                                _4209 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4202, _4203), float2(_4135, _4134)) + _4118), (dot(float2(_4202, _4203), float2(_4153, _4135)) + _4119)));
                                _4214 = _4209.x - _4120;
                                _4216 = select((_4214 < 0.0f), 0.0f, 1.0f);
                                _4220 = _4209.y - _4120;
                                _4222 = select((_4220 < 0.0f), 0.0f, 1.0f);
                                _4226 = _4209.z - _4120;
                                _4228 = select((_4226 < 0.0f), 0.0f, 1.0f);
                                _4232 = _4209.w - _4120;
                                _4234 = select((_4232 < 0.0f), 0.0f, 1.0f);
                                _4241 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _4246 = sqrt((float((int)(_4241)) * 0.25f) + 0.125f) * _3502;
                                _4255 = (_global_7[min((uint)(((int)(0u + (_4241 * 2)))), 127u)]) * _4246;
                                _4256 = (_global_7[min((uint)(((int)(1u + (_4241 * 2)))), 127u)]) * _4246;
                                _4262 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4255, _4256), float2(_4135, _4134)) + _4118), (dot(float2(_4255, _4256), float2(_4153, _4135)) + _4119)));
                                _4267 = _4262.x - _4120;
                                _4269 = select((_4267 < 0.0f), 0.0f, 1.0f);
                                _4273 = _4262.y - _4120;
                                _4275 = select((_4273 < 0.0f), 0.0f, 1.0f);
                                _4279 = _4262.z - _4120;
                                _4281 = select((_4279 < 0.0f), 0.0f, 1.0f);
                                _4285 = _4262.w - _4120;
                                _4287 = select((_4285 < 0.0f), 0.0f, 1.0f);
                                _4294 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _4299 = sqrt((float((int)(_4294)) * 0.25f) + 0.125f) * _3502;
                                _4308 = (_global_7[min((uint)(((int)(0u + (_4294 * 2)))), 127u)]) * _4299;
                                _4309 = (_global_7[min((uint)(((int)(1u + (_4294 * 2)))), 127u)]) * _4299;
                                _4315 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4308, _4309), float2(_4135, _4134)) + _4118), (dot(float2(_4308, _4309), float2(_4153, _4135)) + _4119)));
                                _4320 = _4315.x - _4120;
                                _4322 = select((_4320 < 0.0f), 0.0f, 1.0f);
                                _4326 = _4315.y - _4120;
                                _4328 = select((_4326 < 0.0f), 0.0f, 1.0f);
                                _4332 = _4315.z - _4120;
                                _4334 = select((_4332 < 0.0f), 0.0f, 1.0f);
                                _4338 = _4315.w - _4120;
                                _4340 = select((_4338 < 0.0f), 0.0f, 1.0f);
                                _4341 = ((((((((((((((_4165 + _4169) + _4175) + _4181) + _4216) + _4222) + _4228) + _4234) + _4269) + _4275) + _4281) + _4287) + _4322) + _4328) + _4334) + _4340;
                                _4352 = (saturate(_4341 * 0.0625f) * 2.0f) + -1.0f;
                                _4358 = float((int)(((int)(uint)((int)(_4352 > 0.0f))) - ((int)(uint)((int)(_4352 < 0.0f)))));
                                _4360 = 1.0f - (_4358 * _4352);
                                _4362 = (_4360 * _4360) * _4360;
                                _4370 = -0.0f - _3592;
                                _4377 = saturate((saturate(rsqrt(dot(float3(_4370, _3584, _3581), float3(_4370, _3584, _3581))) * _3581) * _3479) + _3478);
                                _4379 = 1.0f - (_4377 * _4377);
                                _4383 = (0.5f - ((_4358 * 0.5f) * ((1.0f - _4362) - ((_4360 - _4362) * saturate(((1.0f / _4120) * (1.0f / _4341)) * ((((((((((((((((_4165 * _4163) + (_4169 * _4167)) + (_4175 * _4173)) + (_4181 * _4179)) + (_4216 * _4214)) + (_4222 * _4220)) + (_4228 * _4226)) + (_4234 * _4232)) + (_4269 * _4267)) + (_4275 * _4273)) + (_4281 * _4279)) + (_4287 * _4285)) + (_4322 * _4320)) + (_4328 * _4326)) + (_4334 * _4332)) + (_4340 * _4338)))))));
                                _4384 = (1.0f - (_4379 * _4379));
                                _4385 = 1;
                              } else {
                                _4383 = 1.0f;
                                _4384 = 1.0f;
                                _4385 = 0;
                              }
                            } else {
                              _4383 = 1.0f;
                              _4384 = 1.0f;
                              _4385 = 0;
                            }
                          }
                        } else {
                          _4383 = 1.0f;
                          _4384 = 1.0f;
                          _4385 = 0;
                        }
                        [branch]
                        if (!((_1440 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1440 & 2097152) == 0)) {
                            _4393 = abs(_3592);
                            _4394 = abs(_3593);
                            _4395 = abs(_3594);
                            if (_4393 > max(_4394, _4395)) {
                              _4399 = (_3592 > 0.0f);
                              _4414 = select(_4399, 0.0f, 1.0f);
                              _4415 = 0.0f;
                              _4416 = select(_4399, _3581, _3594);
                              _4417 = _3584;
                              _4418 = _4393;
                            } else {
                              if (_4394 > _4395) {
                                _4405 = (_3584 < -0.0f);
                                _4414 = select(_4405, 0.0f, 1.0f);
                                _4415 = 1.0f;
                                _4416 = _3592;
                                _4417 = select(_4405, _3594, _3581);
                                _4418 = _4394;
                              } else {
                                _4409 = (_3581 < -0.0f);
                                _4414 = select(_4409, 0.0f, 1.0f);
                                _4415 = 2.0f;
                                _4416 = select(_4409, _3592, (-0.0f - _3592));
                                _4417 = _3584;
                                _4418 = _4395;
                              }
                            }
                            _4419 = _4418 * 2.0f;
                            _4424 = -0.0f - _3496;
                            _4433 = ((min(max((_4416 / _4419), _4424), _3496) + _4414) * _3442) + _3444;
                            _4434 = ((min(max((_4417 / _4419), _4424), _3496) + _4415) * _3443) + _3445;
                            _4439 = ((_4414 + -0.5f) * _3442) + _3444;
                            _4440 = ((_4415 + -0.5f) * _3443) + _3445;
                            _4443 = saturate(1.0f - (_4418 * _3481));
                            _4447 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _4456 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_4447 * 32.665000915527344f) + _124), ((_4447 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4457 = sin(_4456);
                            _4458 = cos(_4456);
                            _4463 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4433, _4434), 0.0f))).x) > _4443), 1.0f, 0.0f);
                            _4464 = cbSharedPerViewData.nFrameCounter & 3;
                            _4469 = sqrt((float((int)(_4464)) * 0.25f) + 0.125f) * _3503;
                            _4478 = (_global_7[min((uint)(((int)(0u + (_4464 * 2)))), 127u)]) * _4469;
                            _4479 = (_global_7[min((uint)(((int)(1u + (_4464 * 2)))), 127u)]) * _4469;
                            _4481 = -0.0f - _4457;
                            _4483 = dot(float2(_4478, _4479), float2(_4458, _4457)) + _4433;
                            _4484 = dot(float2(_4478, _4479), float2(_4481, _4458)) + _4434;
                            _4486 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4483, _4484));
                            _4490 = _4483 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4491 = _4484 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4494 = floor(_4439 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _4495 = floor(_4440 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _4500 = floor(((_4439 + _3442) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _4501 = floor(((_4440 + _3443) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _4504 = floor(_4490 + -0.5f);
                            _4505 = floor(_4491 + 0.5f);
                            _4507 = floor(_4490 + 0.5f);
                            _4509 = floor(_4491 + -0.5f);
                            _4510 = (_4504 < _4494);
                            _4511 = (_4505 < _4495);
                            if ((_4510 || _4511) | ((_4504 >= _4500) || (_4505 >= _4501))) {
                              _4520 = _4463;
                            } else {
                              _4520 = _4486.x;
                            }
                            _4521 = (_4507 < _4494);
                            if ((_4521 || _4511) | ((_4507 >= _4500) || (_4505 >= _4501))) {
                              _4529 = _4463;
                            } else {
                              _4529 = _4486.y;
                            }
                            _4530 = (_4509 < _4495);
                            if ((_4521 || _4530) | ((_4507 >= _4500) || (_4509 >= _4501))) {
                              _4538 = _4463;
                            } else {
                              _4538 = _4486.z;
                            }
                            if ((_4510 || _4530) | ((_4504 >= _4500) || (_4509 >= _4501))) {
                              _4546 = _4463;
                            } else {
                              _4546 = _4486.w;
                            }
                            _4547 = _4520 - _4443;
                            _4549 = select((_4547 < 0.0f), 0.0f, 1.0f);
                            _4551 = _4529 - _4443;
                            _4553 = select((_4551 < 0.0f), 0.0f, 1.0f);
                            _4557 = _4538 - _4443;
                            _4559 = select((_4557 < 0.0f), 0.0f, 1.0f);
                            _4563 = _4546 - _4443;
                            _4565 = select((_4563 < 0.0f), 0.0f, 1.0f);
                            _4572 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _4577 = sqrt((float((int)(_4572)) * 0.25f) + 0.125f) * _3503;
                            _4586 = (_global_7[min((uint)(((int)(0u + (_4572 * 2)))), 127u)]) * _4577;
                            _4587 = (_global_7[min((uint)(((int)(1u + (_4572 * 2)))), 127u)]) * _4577;
                            _4590 = dot(float2(_4586, _4587), float2(_4458, _4457)) + _4433;
                            _4591 = dot(float2(_4586, _4587), float2(_4481, _4458)) + _4434;
                            _4593 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4590, _4591));
                            _4597 = _4590 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4598 = _4591 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4601 = floor(_4597 + -0.5f);
                            _4602 = floor(_4598 + 0.5f);
                            _4604 = floor(_4597 + 0.5f);
                            _4606 = floor(_4598 + -0.5f);
                            _4607 = (_4601 < _4494);
                            _4608 = (_4602 < _4495);
                            if ((_4607 || _4608) | ((_4601 >= _4500) || (_4602 >= _4501))) {
                              _4617 = _4463;
                            } else {
                              _4617 = _4593.x;
                            }
                            _4618 = (_4604 < _4494);
                            if ((_4618 || _4608) | ((_4604 >= _4500) || (_4602 >= _4501))) {
                              _4626 = _4463;
                            } else {
                              _4626 = _4593.y;
                            }
                            _4627 = (_4606 < _4495);
                            if ((_4618 || _4627) | ((_4604 >= _4500) || (_4606 >= _4501))) {
                              _4635 = _4463;
                            } else {
                              _4635 = _4593.z;
                            }
                            if ((_4607 || _4627) | ((_4601 >= _4500) || (_4606 >= _4501))) {
                              _4643 = _4463;
                            } else {
                              _4643 = _4593.w;
                            }
                            _4644 = _4617 - _4443;
                            _4646 = select((_4644 < 0.0f), 0.0f, 1.0f);
                            _4650 = _4626 - _4443;
                            _4652 = select((_4650 < 0.0f), 0.0f, 1.0f);
                            _4656 = _4635 - _4443;
                            _4658 = select((_4656 < 0.0f), 0.0f, 1.0f);
                            _4662 = _4643 - _4443;
                            _4664 = select((_4662 < 0.0f), 0.0f, 1.0f);
                            _4671 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _4676 = sqrt((float((int)(_4671)) * 0.25f) + 0.125f) * _3503;
                            _4685 = (_global_7[min((uint)(((int)(0u + (_4671 * 2)))), 127u)]) * _4676;
                            _4686 = (_global_7[min((uint)(((int)(1u + (_4671 * 2)))), 127u)]) * _4676;
                            _4689 = dot(float2(_4685, _4686), float2(_4458, _4457)) + _4433;
                            _4690 = dot(float2(_4685, _4686), float2(_4481, _4458)) + _4434;
                            _4692 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4689, _4690));
                            _4696 = _4689 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4697 = _4690 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4700 = floor(_4696 + -0.5f);
                            _4701 = floor(_4697 + 0.5f);
                            _4703 = floor(_4696 + 0.5f);
                            _4705 = floor(_4697 + -0.5f);
                            _4706 = (_4700 < _4494);
                            _4707 = (_4701 < _4495);
                            if ((_4706 || _4707) | ((_4700 >= _4500) || (_4701 >= _4501))) {
                              _4716 = _4463;
                            } else {
                              _4716 = _4692.x;
                            }
                            _4717 = (_4703 < _4494);
                            if ((_4717 || _4707) | ((_4703 >= _4500) || (_4701 >= _4501))) {
                              _4725 = _4463;
                            } else {
                              _4725 = _4692.y;
                            }
                            _4726 = (_4705 < _4495);
                            if ((_4717 || _4726) | ((_4703 >= _4500) || (_4705 >= _4501))) {
                              _4734 = _4463;
                            } else {
                              _4734 = _4692.z;
                            }
                            if ((_4706 || _4726) | ((_4700 >= _4500) || (_4705 >= _4501))) {
                              _4742 = _4463;
                            } else {
                              _4742 = _4692.w;
                            }
                            _4743 = _4716 - _4443;
                            _4745 = select((_4743 < 0.0f), 0.0f, 1.0f);
                            _4749 = _4725 - _4443;
                            _4751 = select((_4749 < 0.0f), 0.0f, 1.0f);
                            _4755 = _4734 - _4443;
                            _4757 = select((_4755 < 0.0f), 0.0f, 1.0f);
                            _4761 = _4742 - _4443;
                            _4763 = select((_4761 < 0.0f), 0.0f, 1.0f);
                            _4770 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _4775 = sqrt((float((int)(_4770)) * 0.25f) + 0.125f) * _3503;
                            _4784 = (_global_7[min((uint)(((int)(0u + (_4770 * 2)))), 127u)]) * _4775;
                            _4785 = (_global_7[min((uint)(((int)(1u + (_4770 * 2)))), 127u)]) * _4775;
                            _4788 = dot(float2(_4784, _4785), float2(_4458, _4457)) + _4433;
                            _4789 = dot(float2(_4784, _4785), float2(_4481, _4458)) + _4434;
                            _4791 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4788, _4789));
                            _4795 = _4788 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _4796 = _4789 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _4799 = floor(_4795 + -0.5f);
                            _4800 = floor(_4796 + 0.5f);
                            _4802 = floor(_4795 + 0.5f);
                            _4804 = floor(_4796 + -0.5f);
                            _4805 = (_4799 < _4494);
                            _4806 = (_4800 < _4495);
                            if ((_4805 || _4806) | ((_4799 >= _4500) || (_4800 >= _4501))) {
                              _4815 = _4463;
                            } else {
                              _4815 = _4791.x;
                            }
                            _4816 = (_4802 < _4494);
                            if ((_4816 || _4806) | ((_4802 >= _4500) || (_4800 >= _4501))) {
                              _4824 = _4463;
                            } else {
                              _4824 = _4791.y;
                            }
                            _4825 = (_4804 < _4495);
                            if ((_4816 || _4825) | ((_4802 >= _4500) || (_4804 >= _4501))) {
                              _4833 = _4463;
                            } else {
                              _4833 = _4791.z;
                            }
                            if ((_4805 || _4825) | ((_4799 >= _4500) || (_4804 >= _4501))) {
                              _4841 = _4463;
                            } else {
                              _4841 = _4791.w;
                            }
                            _4842 = _4815 - _4443;
                            _4844 = select((_4842 < 0.0f), 0.0f, 1.0f);
                            _4848 = _4824 - _4443;
                            _4850 = select((_4848 < 0.0f), 0.0f, 1.0f);
                            _4854 = _4833 - _4443;
                            _4856 = select((_4854 < 0.0f), 0.0f, 1.0f);
                            _4860 = _4841 - _4443;
                            _4862 = select((_4860 < 0.0f), 0.0f, 1.0f);
                            _4863 = ((((((((((((((_4553 + _4549) + _4559) + _4565) + _4646) + _4652) + _4658) + _4664) + _4745) + _4751) + _4757) + _4763) + _4844) + _4850) + _4856) + _4862;
                            _4874 = (saturate(_4863 * 0.0625f) * 2.0f) + -1.0f;
                            _4880 = float((int)(((int)(uint)((int)(_4874 > 0.0f))) - ((int)(uint)((int)(_4874 < 0.0f)))));
                            _4882 = 1.0f - (_4880 * _4874);
                            _4884 = (_4882 * _4882) * _4882;
                            _5175 = (0.5f - ((_4880 * 0.5f) * ((1.0f - _4884) - ((_4882 - _4884) * saturate(((1.0f / _4443) * (1.0f / _4863)) * ((((((((((((((((_4553 * _4551) + (_4549 * _4547)) + (_4559 * _4557)) + (_4565 * _4563)) + (_4646 * _4644)) + (_4652 * _4650)) + (_4658 * _4656)) + (_4664 * _4662)) + (_4745 * _4743)) + (_4751 * _4749)) + (_4757 * _4755)) + (_4763 * _4761)) + (_4844 * _4842)) + (_4850 * _4848)) + (_4856 * _4854)) + (_4862 * _4860)))))));
                            _5176 = 1.0f;
                            _5177 = false;
                          } else {
                            _4893 = f16tof32(((uint)((uint)(_3457) >> 16))) / _3594;
                            _4896 = mad((_4893 * _3592), 0.5f, 0.5f);
                            _4897 = mad((_4893 * _3593), 0.5f, 0.5f);
                            if (_3581 > -0.0f) {
                              if ((saturate(_4896) == _4896) && (saturate(_4897) == _4897)) {
                                _4910 = (_4896 * _3442) + _3444;
                                _4911 = (_4897 * _3443) + _3445;
                                _4912 = saturate(1.0f - (_3581 * _3481));
                                _4916 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _4925 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_4916 * 32.665000915527344f) + _124), ((_4916 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _4926 = sin(_4925);
                                _4927 = cos(_4925);
                                _4928 = cbSharedPerViewData.nFrameCounter & 3;
                                _4933 = sqrt((float((int)(_4928)) * 0.25f) + 0.125f) * _3503;
                                _4942 = (_global_7[min((uint)(((int)(0u + (_4928 * 2)))), 127u)]) * _4933;
                                _4943 = (_global_7[min((uint)(((int)(1u + (_4928 * 2)))), 127u)]) * _4933;
                                _4945 = -0.0f - _4926;
                                _4950 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_4942, _4943), float2(_4927, _4926)) + _4910), (dot(float2(_4942, _4943), float2(_4945, _4927)) + _4911)));
                                _4955 = _4950.x - _4912;
                                _4957 = select((_4955 < 0.0f), 0.0f, 1.0f);
                                _4959 = _4950.y - _4912;
                                _4961 = select((_4959 < 0.0f), 0.0f, 1.0f);
                                _4965 = _4950.z - _4912;
                                _4967 = select((_4965 < 0.0f), 0.0f, 1.0f);
                                _4971 = _4950.w - _4912;
                                _4973 = select((_4971 < 0.0f), 0.0f, 1.0f);
                                _4980 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _4985 = sqrt((float((int)(_4980)) * 0.25f) + 0.125f) * _3503;
                                _4994 = (_global_7[min((uint)(((int)(0u + (_4980 * 2)))), 127u)]) * _4985;
                                _4995 = (_global_7[min((uint)(((int)(1u + (_4980 * 2)))), 127u)]) * _4985;
                                _5001 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_4994, _4995), float2(_4927, _4926)) + _4910), (dot(float2(_4994, _4995), float2(_4945, _4927)) + _4911)));
                                _5006 = _5001.x - _4912;
                                _5008 = select((_5006 < 0.0f), 0.0f, 1.0f);
                                _5012 = _5001.y - _4912;
                                _5014 = select((_5012 < 0.0f), 0.0f, 1.0f);
                                _5018 = _5001.z - _4912;
                                _5020 = select((_5018 < 0.0f), 0.0f, 1.0f);
                                _5024 = _5001.w - _4912;
                                _5026 = select((_5024 < 0.0f), 0.0f, 1.0f);
                                _5033 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _5038 = sqrt((float((int)(_5033)) * 0.25f) + 0.125f) * _3503;
                                _5047 = (_global_7[min((uint)(((int)(0u + (_5033 * 2)))), 127u)]) * _5038;
                                _5048 = (_global_7[min((uint)(((int)(1u + (_5033 * 2)))), 127u)]) * _5038;
                                _5054 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5047, _5048), float2(_4927, _4926)) + _4910), (dot(float2(_5047, _5048), float2(_4945, _4927)) + _4911)));
                                _5059 = _5054.x - _4912;
                                _5061 = select((_5059 < 0.0f), 0.0f, 1.0f);
                                _5065 = _5054.y - _4912;
                                _5067 = select((_5065 < 0.0f), 0.0f, 1.0f);
                                _5071 = _5054.z - _4912;
                                _5073 = select((_5071 < 0.0f), 0.0f, 1.0f);
                                _5077 = _5054.w - _4912;
                                _5079 = select((_5077 < 0.0f), 0.0f, 1.0f);
                                _5086 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _5091 = sqrt((float((int)(_5086)) * 0.25f) + 0.125f) * _3503;
                                _5100 = (_global_7[min((uint)(((int)(0u + (_5086 * 2)))), 127u)]) * _5091;
                                _5101 = (_global_7[min((uint)(((int)(1u + (_5086 * 2)))), 127u)]) * _5091;
                                _5107 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5100, _5101), float2(_4927, _4926)) + _4910), (dot(float2(_5100, _5101), float2(_4945, _4927)) + _4911)));
                                _5112 = _5107.x - _4912;
                                _5114 = select((_5112 < 0.0f), 0.0f, 1.0f);
                                _5118 = _5107.y - _4912;
                                _5120 = select((_5118 < 0.0f), 0.0f, 1.0f);
                                _5124 = _5107.z - _4912;
                                _5126 = select((_5124 < 0.0f), 0.0f, 1.0f);
                                _5130 = _5107.w - _4912;
                                _5132 = select((_5130 < 0.0f), 0.0f, 1.0f);
                                _5133 = ((((((((((((((_4957 + _4961) + _4967) + _4973) + _5008) + _5014) + _5020) + _5026) + _5061) + _5067) + _5073) + _5079) + _5114) + _5120) + _5126) + _5132;
                                _5144 = (saturate(_5133 * 0.0625f) * 2.0f) + -1.0f;
                                _5150 = float((int)(((int)(uint)((int)(_5144 > 0.0f))) - ((int)(uint)((int)(_5144 < 0.0f)))));
                                _5152 = 1.0f - (_5150 * _5144);
                                _5154 = (_5152 * _5152) * _5152;
                                _5162 = -0.0f - _3592;
                                _5169 = saturate((saturate(rsqrt(dot(float3(_5162, _3584, _3581), float3(_5162, _3584, _3581))) * _3581) * _3479) + _3478);
                                _5171 = 1.0f - (_5169 * _5169);
                                _5175 = (0.5f - ((_5150 * 0.5f) * ((1.0f - _5154) - ((_5152 - _5154) * saturate(((1.0f / _4912) * (1.0f / _5133)) * ((((((((((((((((_4957 * _4955) + (_4961 * _4959)) + (_4967 * _4965)) + (_4973 * _4971)) + (_5008 * _5006)) + (_5014 * _5012)) + (_5020 * _5018)) + (_5026 * _5024)) + (_5061 * _5059)) + (_5067 * _5065)) + (_5073 * _5071)) + (_5079 * _5077)) + (_5114 * _5112)) + (_5120 * _5118)) + (_5126 * _5124)) + (_5132 * _5130)))))));
                                _5176 = (1.0f - (_5171 * _5171));
                                _5177 = false;
                              } else {
                                _5175 = 1.0f;
                                _5176 = 1.0f;
                                _5177 = true;
                              }
                            } else {
                              _5175 = 1.0f;
                              _5176 = 1.0f;
                              _5177 = true;
                            }
                          }
                        } else {
                          _5175 = 1.0f;
                          _5176 = 1.0f;
                          _5177 = true;
                        }
                        if (_4385 == 0) {
                          if (!_5177) {
                            _5192 = _4383;
                            _5193 = ((_5176 * (_5175 + -1.0f)) + 1.0f);
                            _5194 = 0.0f;
                          } else {
                            _5192 = _4383;
                            _5193 = _5175;
                            _5194 = 0.0f;
                          }
                        } else {
                          if (_5177) {
                            _5192 = ((_4384 * (_4383 + -1.0f)) + 1.0f);
                            _5193 = _5175;
                            _5194 = 1.0f;
                          } else {
                            _5192 = _4383;
                            _5193 = _5175;
                            _5194 = (_4384 * f16tof32(_3427));
                          }
                        }
                        _5197 = (_5194 * (_5192 - _5193)) + _5193;
                        [branch]
                        if (!((_1440 & 2048) == 0)) {
                          _5199 = _198 - _3399;
                          _5200 = _199 - _3400;
                          _5201 = _200 - _3401;
                          _5216 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5201, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5200, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5199)));
                          _5219 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _5201, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _5200, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _5199)));
                          _5222 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _5201, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _5200, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _5199)));
                          _5224 = rsqrt(dot(float3(_5216, _5219, _5222), float3(_5216, _5219, _5222)));
                          _5225 = _5224 * _5216;
                          _5226 = _5224 * _5219;
                          _5227 = _5224 * _5222;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3433) >> 16))];
                          _5235 = (abs(_5226) + abs(_5225)) + abs(_5227);
                          _5236 = _5225 / _5235;
                          _5237 = _5226 / _5235;
                          _5239 = !((_5227 / _5235) >= 0.0f);
                          if (_5239) {
                            _5252 = ((1.0f - abs(_5237)) * select((_5236 >= 0.0f), 1.0f, -1.0f));
                            _5253 = ((1.0f - abs(_5236)) * select((_5237 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _5252 = _5236;
                            _5253 = _5237;
                          }
                          _5259 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5252 * 0.5f) + 0.5f), ((_5253 * 0.5f) + 0.5f)), 0.0f);
                          if (_5259.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3433 & 65535))];
                            if (_5239) {
                              _5278 = ((1.0f - abs(_5237)) * select((_5236 >= 0.0f), 1.0f, -1.0f));
                              _5279 = ((1.0f - abs(_5236)) * select((_5237 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _5278 = _5236;
                              _5279 = _5237;
                            }
                            _5284 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5278 * 0.5f) + 0.5f), ((_5279 * 0.5f) + 0.5f)), 0.0f);
                            _5304 = mad(saturate(((log2(sqrt(((_5199 * _5199) + (_5200 * _5200)) + (_5201 * _5201))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _5305 = max(9.999999747378752e-06f, _5259.x);
                            _5306 = _5284.x / _5305;
                            _5307 = _5284.y / _5305;
                            _5309 = _5284.w / _5305;
                            _5314 = ((0.375f - _5307) * 4.999999873689376e-06f) + _5307;
                            _5317 = -0.0f - _5306;
                            _5318 = mad(_5317, _5314, (_5284.z / _5305));
                            _5320 = 1.0f / mad(_5317, _5306, _5314);
                            _5321 = _5320 * _5318;
                            _5326 = _5304 - _5306;
                            _5331 = (((_5304 * _5304) - _5314) - (_5321 * _5326)) / mad((-0.0f - _5318), _5321, mad((-0.0f - _5314), _5314, (((0.375f - _5309) * 4.999999873689376e-06f) + _5309)));
                            _5333 = (_5320 * _5326) - (_5331 * _5321);
                            _5336 = 1.0f / _5331;
                            _5337 = _5333 * _5336;
                            _5342 = sqrt(((_5337 * _5337) * 0.25f) - ((1.0f - dot(float2(_5333, _5331), float2(_5306, _5314))) * _5336));
                            _5344 = (_5337 * -0.5f) - _5342;
                            _5346 = _5342 - (_5337 * 0.5f);
                            _5348 = select((_5344 < _5304), 1.0f, 0.0f);
                            _5353 = (_5348 + -0.05000000074505806f) / (_5344 - _5304);
                            _5359 = (((select((_5346 < _5304), 1.0f, 0.0f) - _5348) / (_5346 - _5344)) - _5353) / (_5346 - _5304);
                            _5361 = _5353 - (_5359 * _5344);
                            _5374 = (exp2((_5259.x * -1.4426950216293335f) * saturate((dot(float2(_5306, _5314), float2((_5361 - (_5359 * _5304)), _5359)) + 0.05000000074505806f) - (_5361 * _5304))) * _5197);
                          } else {
                            _5374 = _5197;
                          }
                        } else {
                          _5374 = _5197;
                        }
                        _5377 = (_5374 * _3555);
                        _5378 = _5374;
                      } else {
                        _5377 = _3555;
                        _5378 = 1.0f;
                      }
                      [branch]
                      if (!(_3484 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3484)))];
                        _5390 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3534, _3394, mad(_3533, _3389, (_3532 * _3384)))), (-0.0f - mad(_3534, _3395, mad(_3533, _3390, (_3532 * _3385)))), (-0.0f - mad(_3534, _3396, mad(_3533, _3391, (_3532 * _3386))))), 0.0f);
                        _5398 = (_5390.x * _3459);
                        _5399 = (_5390.y * _3460);
                        _5400 = (_5390.z * _3462);
                      } else {
                        _5398 = _3459;
                        _5399 = _3460;
                        _5400 = _3462;
                      }
                      [branch]
                      if (!(_5377 == 0.0f)) {
                        bool __branch_chain_5402;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _5418 = 0;
                          __branch_chain_5402 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _5418 = 1;
                            __branch_chain_5402 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _5418 = 2;
                              __branch_chain_5402 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _5418 = 3;
                                __branch_chain_5402 = true;
                              } else {
                                _5439 = _5377;
                                __branch_chain_5402 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_5402) {
                          while(true) {
                            _5421 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_62, _63, 0));
                            if (_5418 == 0) {
                              _5435 = _5421.x;
                            } else {
                              if (_5418 == 1) {
                                _5435 = _5421.y;
                              } else {
                                if (_5418 == 2) {
                                  _5435 = _5421.z;
                                } else {
                                  _5435 = _5421.w;
                                }
                              }
                            }
                            _5439 = ((_5435 * _5435) * _3555);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_5439 == 0.0f)) {
                            [branch]
                            if (!(((_3436 & 1) == 0) || (!_3586))) {
                              _5456 = max(max(_5398, _5399), _5400);
                              if (_5456 > 0.0f) {
                                _5466 = saturate(_5398 / _5456);
                                _5467 = saturate(_5399 / _5456);
                                _5468 = saturate(_5400 / _5456);
                              } else {
                                _5466 = _5398;
                                _5467 = _5399;
                                _5468 = _5400;
                              }
                              _5469 = (_5467 < _5468);
                              _5470 = select(_5469, _5468, _5467);
                              _5471 = select(_5469, _5467, _5468);
                              _5472 = select(_5469, -1.0f, 0.0f);
                              _5473 = (_5466 < _5470);
                              _5475 = select(_5473, _5470, _5466);
                              _5476 = select(_5473, _5466, _5470);
                              _5480 = _5475 - select((_5476 < _5471), _5476, _5471);
                              _5486 = abs(select(_5473, (-0.3333333432674408f - _5472), _5472) + ((_5476 - _5471) / ((_5480 * 6.0f) + 9.999999682655225e-21f)));
                              if (_5486 < 0.6666666865348816f) {
                                _5499 = ((saturate(((float)((uint)((uint)(((uint)(_3436) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5486 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5486)) + _5486);
                              } else {
                                _5499 = _5486;
                              }
                              _5500 = saturate((_5480 / (_5475 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3436) >> 1) & 255)))) * 0.003921499941498041f));
                              _5501 = saturate(_5475);
                              if (!(_5500 <= 0.0f)) {
                                _5504 = saturate(_5499);
                                _5508 = select(((_5504 * 360.0f) >= 360.0f), 0.0f, (_5504 * 6.0f));
                                _5509 = int(_5508);
                                _5511 = _5508 - float((int)(_5509));
                                _5513 = _5501 * (1.0f - _5500);
                                _5516 = (1.0f - (_5511 * _5500)) * _5501;
                                _5520 = (1.0f - ((1.0f - _5511) * _5500)) * _5501;
                                switch (_5509) {
                                  case 0: {
                                    _5528 = _5501;
                                    _5529 = _5520;
                                    _5530 = _5513;
                                    break;
                                  }
                                  case 1: {
                                    _5528 = _5516;
                                    _5529 = _5501;
                                    _5530 = _5513;
                                    break;
                                  }
                                  case 2: {
                                    _5528 = _5513;
                                    _5529 = _5501;
                                    _5530 = _5520;
                                    break;
                                  }
                                  case 3: {
                                    _5528 = _5513;
                                    _5529 = _5516;
                                    _5530 = _5501;
                                    break;
                                  }
                                  case 4: {
                                    _5528 = _5520;
                                    _5529 = _5513;
                                    _5530 = _5501;
                                    break;
                                  }
                                  case 5: {
                                    _5528 = _5501;
                                    _5529 = _5513;
                                    _5530 = _5516;
                                    break;
                                  }
                                  default: {
                                    _5528 = 0.0f;
                                    _5529 = 0.0f;
                                    _5530 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _5528 = _5501;
                                _5529 = _5501;
                                _5530 = _5501;
                              }
                              _5531 = _5528 * _5456;
                              _5532 = _5529 * _5456;
                              _5533 = _5530 * _5456;
                              _5535 = saturate(_5378 * 1.0101009607315063f);
                              _5546 = ((_5535 * (_5398 - _5531)) + _5531);
                              _5547 = ((_5535 * (_5399 - _5532)) + _5532);
                              _5548 = (lerp(_5533, _5400, _5535));
                            } else {
                              _5546 = _5398;
                              _5547 = _5399;
                              _5548 = _5400;
                            }
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _5555 = srvLightMappingData[_1443];
                              if (!(_5555 == -1)) {
                                _5560 = srvLightIndexData[_5555].nLayerIndex;
                                _5562 = srvLightIndexData[_5555].vAtlasOrigin.x;
                                _5563 = srvLightIndexData[_5555].vAtlasOrigin.y;
                                _5565 = srvLightIndexData[_5555].vScreenOrigin.x;
                                _5566 = srvLightIndexData[_5555].vScreenOrigin.y;
                                _5575 = ((int)(_5560 * 5)) & 31;
                                _5584 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5562 + _62) - _5565)), ((int)((_5563 + _63) - _5566)), 0)))).x) & ((int)(31 << _5575)))) >> _5575)) >> 1)))) * 0.06666667014360428f) * _5439);
                              } else {
                                _5584 = _5439;
                              }
                            } else {
                              _5584 = _5439;
                            }
                            _5588 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _5591 = select(_5588, (_5584 * _1190), _5584);
                            _5593 = _3538 * _3537;
                            _5594 = _3539 * _3537;
                            _5595 = _3540 * _3537;
                            _5596 = _3470 * _3404;
                            _5597 = _3470 * _3405;
                            _5598 = _3470 * _3406;
                            _5599 = _5593 + _5596;
                            _5600 = _5594 + _5597;
                            _5601 = _5595 + _5598;
                            _5602 = _5593 - _5596;
                            _5603 = _5594 - _5597;
                            _5604 = _5595 - _5598;
                            _5605 = (_3470 > 0.0f);
                            _5606 = dot(float3(_5599, _5600, _5601), float3(_5599, _5600, _5601));
                            _5607 = rsqrt(_5606);
                            [branch]
                            if (_5605) {
                              _5610 = rsqrt(dot(float3(_5602, _5603, _5604), float3(_5602, _5603, _5604)));
                              _5611 = _5610 * _5607;
                              _5613 = dot(float3(_5599, _5600, _5601), float3(_5602, _5603, _5604)) * _5611;
                              _5632 = (_5611 / ((_5611 + 0.5f) + (_5613 * 0.5f)));
                              _5633 = (((dot(float3(_179, _180, _181), float3(_5602, _5603, _5604)) * _5610) + (dot(float3(_179, _180, _181), float3(_5599, _5600, _5601)) * _5607)) * 0.5f);
                              _5634 = _5613;
                            } else {
                              _5632 = (1.0f / (_5606 + 1.0f));
                              _5633 = dot(float3(_179, _180, _181), float3((_5607 * _5599), (_5607 * _5600), (_5607 * _5601)));
                              _5634 = 1.0f;
                            }
                            if (_3472 > 0.0f) {
                              _5640 = sqrt(saturate((_3472 * _3472) * _5632));
                              if (_5633 < _5640) {
                                _5645 = max(_5633, (-0.0f - _5640)) + _5640;
                                _5650 = ((_5645 * _5645) / (_5640 * 4.0f));
                              } else {
                                _5650 = _5633;
                              }
                            } else {
                              _5650 = _5633;
                            }
                            if (_5605) {
                              _5652 = -0.0f - _371;
                              _5653 = -0.0f - _372;
                              _5654 = -0.0f - _370;
                              _5656 = dot(float3(_5652, _5653, _5654), float3(_179, _180, _181)) * 2.0f;
                              _5660 = _5652 - (_5656 * _179);
                              _5661 = _5653 - (_5656 * _180);
                              _5662 = _5654 - (_5656 * _181);
                              _5663 = _5602 - _5599;
                              _5664 = _5603 - _5600;
                              _5665 = _5604 - _5601;
                              _5666 = dot(float3(_5660, _5661, _5662), float3(_5663, _5664, _5665));
                              _5672 = sqrt(((_5663 * _5663) + (_5664 * _5664)) + (_5665 * _5665));
                              _5681 = saturate(((dot(float3(_5660, _5661, _5662), float3(_5599, _5600, _5601)) * _5666) - dot(float3(_5599, _5600, _5601), float3(_5663, _5664, _5665))) / ((_5672 * _5672) - (_5666 * _5666)));
                              _5685 = (_5681 * _5663) + _5599;
                              _5686 = (_5681 * _5664) + _5600;
                              _5687 = (_5681 * _5665) + _5601;
                              _5688 = dot(float3(_5685, _5686, _5687), float3(_5660, _5661, _5662));
                              _5692 = (_5688 * _5660) - _5685;
                              _5693 = (_5688 * _5661) - _5686;
                              _5694 = (_5688 * _5662) - _5687;
                              _5702 = saturate(0.009999999776482582f / sqrt(((_5692 * _5692) + (_5693 * _5693)) + (_5694 * _5694)));
                              _5710 = ((_5702 * _5692) + _5685);
                              _5711 = ((_5702 * _5693) + _5686);
                              _5712 = ((_5702 * _5694) + _5687);
                            } else {
                              _5710 = _5599;
                              _5711 = _5600;
                              _5712 = _5601;
                            }
                            _5714 = rsqrt(dot(float3(_5710, _5711, _5712), float3(_5710, _5711, _5712)));
                            _5715 = _5714 * _5710;
                            _5716 = _5714 * _5711;
                            _5717 = _5714 * _5712;
                            _5718 = _190 * _190;
                            _5722 = saturate((_3472 * (1.0f - _5718)) * _5714);
                            _5724 = saturate(_5714 * f16tof32(_3418));
                            _5726 = rsqrt(dot(float3(_5593, _5594, _5595), float3(_5593, _5594, _5595)));
                            _5730 = dot(float3(_179, _180, _181), float3(_5715, _5716, _5717));
                            _5731 = dot(float3(_179, _180, _181), float3(_371, _372, _370));
                            _5732 = dot(float3(_371, _372, _370), float3(_5715, _5716, _5717));
                            _5735 = rsqrt((_5732 * 2.0f) + 2.0f);
                            _5742 = (_5722 > 0.0f);
                            if (_5742) {
                              _5746 = sqrt(1.0f - (_5722 * _5722));
                              _5748 = (_5730 * 2.0f) * _5731;
                              _5749 = _5748 - _5732;
                              if (!(_5749 >= _5746)) {
                                _5757 = rsqrt(1.0f - (_5749 * _5749)) * _5722;
                                _5760 = _5757 * (_5731 - (_5749 * _5730));
                                _5761 = _5731 * _5731;
                                _5766 = _5757 * (((_5761 * 2.0f) + -1.0f) - (_5749 * _5732));
                                _5775 = sqrt(saturate((((1.0f - (_5730 * _5730)) - _5761) - (_5732 * _5732)) + (_5748 * _5732)));
                                _5776 = _5775 * _5757;
                                _5779 = ((_5731 * 2.0f) * _5757) * _5775;
                                _5781 = (_5746 * _5730) + _5731;
                                _5782 = _5781 + _5760;
                                _5783 = _5746 * _5732;
                                _5785 = (_5783 + 1.0f) + _5766;
                                _5786 = _5776 * _5785;
                                _5787 = _5782 * _5785;
                                _5788 = _5779 * _5782;
                                _5793 = (((_5782 * 0.25f) * _5779) - (_5786 * 0.5f)) * _5787;
                                _5807 = (((_5788 - (_5786 * 2.0f)) * _5788) + (_5786 * _5786)) + ((((-0.5f - ((_5785 + _5783) * 0.5f)) * _5787) + ((_5785 * _5785) * _5781)) * _5782);
                                _5812 = (_5793 * 2.0f) / ((_5807 * _5807) + (_5793 * _5793));
                                _5813 = _5807 * _5812;
                                _5815 = 1.0f - (_5793 * _5812);
                                _5821 = ((_5813 * _5779) + _5783) + (_5815 * _5766);
                                _5824 = rsqrt((_5821 * 2.0f) + 2.0f);
                                _5833 = saturate((_5821 * _5824) + _5824);
                                _5834 = saturate(((_5781 + (_5813 * _5776)) + (_5815 * _5760)) * _5824);
                              } else {
                                _5833 = abs(_5731);
                                _5834 = 1.0f;
                              }
                            } else {
                              _5833 = saturate((_5735 * _5732) + _5735);
                              _5834 = saturate(_5735 * (_5731 + _5730));
                            }
                            _5835 = saturate(_5650);
                            _5837 = _5718 * _5718;
                            if (_5724 > 0.0f) {
                              _5847 = saturate(((_5724 * _5724) / ((_5833 * 3.5999999046325684f) + 0.4000000059604645f)) + _5837);
                            } else {
                              _5847 = _5837;
                            }
                            if (_5742) {
                              _5856 = (((_5722 * 0.25f) * ((sqrt(_5847) * 3.0f) + _5722)) / (_5833 + 0.0010000000474974513f)) + _5847;
                              _5859 = _5856;
                              _5860 = (_5847 / _5856);
                            } else {
                              _5859 = _5847;
                              _5860 = 1.0f;
                            }
                            if (_5634 < 1.0f) {
                              _5867 = sqrt((1.000100016593933f - _5634) / max(9.999999974752427e-07f, (_5634 + 1.0f)));
                              _5880 = (sqrt(_5859 / ((((_5867 * 0.25f) * ((sqrt(_5859) * 3.0f) + _5867)) / (_5833 + 0.0010000000474974513f)) + _5859)) * _5860);
                            } else {
                              _5880 = _5860;
                            }
                            _5884 = (((_5847 * _5834) - _5834) * _5834) + 1.0f;
                            _5889 = saturate(abs(_5731) + 9.999999747378752e-06f);
                            _5890 = sqrt(_5847);
                            _5891 = 1.0f - _5890;
                            _5903 = saturate((dot(float3(_179, _180, _181), float3((_5726 * _5593), (_5726 * _5594), (_5726 * _5595))) + _3469) / (_3469 + 1.0f));
                            _5906 = ((_5880 * _5835) * (_5847 / (_5884 * _5884))) * (0.5f / ((((_5891 * _5889) + _5890) * _5835) + (((_5891 * _5835) + _5890) * _5889)));
                            _5907 = _5546 * _1490;
                            _5908 = _5547 * _1490;
                            _5909 = _5548 * _1490;
                            _5916 = ((_5591 * _5907) * _5903) + _1428;
                            _5917 = ((_5591 * _5908) * _5903) + _1429;
                            _5918 = ((_5591 * _5909) * _5903) + _1430;
                            if (_3466 > 0.0f) {
                              _5927 = (exp2(log2(1.0f - saturate(_5833)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                              _5928 = select(_5588, (_5584 * _1190), _5584) * _3466;
                              _8238 = _5916;
                              _8239 = _5917;
                              _8240 = _5918;
                              _8241 = (((((_5907 * _1059) * _5928) * _5927) * _5906) + _1431);
                              _8242 = (((((_5908 * _1059) * _5928) * _5927) * _5906) + _1432);
                              _8243 = (((((_5909 * _1059) * _5928) * _5927) * _5906) + _1433);
                            } else {
                              _8238 = _5916;
                              _8239 = _5917;
                              _8240 = _5918;
                              _8241 = _1431;
                              _8242 = _1432;
                              _8243 = _1433;
                            }
                          } else {
                            _8238 = _1428;
                            _8239 = _1429;
                            _8240 = _1430;
                            _8241 = _1431;
                            _8242 = _1432;
                            _8243 = _1433;
                          }
                          break;
                        }
                      } else {
                        _8238 = _1428;
                        _8239 = _1429;
                        _8240 = _1430;
                        _8241 = _1431;
                        _8242 = _1432;
                        _8243 = _1433;
                      }
                    } else {
                      if (_1473 == 8) {
                        _5949 = asfloat(srvLightInfoProperties.Load3(_1442)).x;
                        _5950 = asfloat(srvLightInfoProperties.Load3(_1442)).y;
                        _5951 = asfloat(srvLightInfoProperties.Load3(_1442)).z;
                        _5954 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 12u)))).x;
                        _5955 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 12u)))).y;
                        _5956 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 12u)))).z;
                        _5959 = asfloat(srvLightInfoProperties.Load(((int)(_1442 + 24u))));
                        _5962 = asint(srvLightInfoProperties.Load(((int)(_1442 + 28u))));
                        _5965 = asint(srvLightInfoProperties.Load(((int)(_1442 + 32u))));
                        _5968 = asint(srvLightInfoProperties.Load(((int)(_1442 + 44u))));
                        _5977 = ((float)((uint)((uint)(((uint)(_5965) >> 8) & 255)))) * 0.003921499941498041f;
                        _5980 = ((float)((uint)((uint)(_5965 & 255)))) * 0.003921499941498041f;
                        _5983 = f16tof32(_5968);
                        _5990 = min(max(dot(float3((_198 - _5949), (_199 - _5950), (_200 - _5951)), float3(_5954, _5955, _5956)), (-0.0f - _5959)), _5959);
                        _5995 = (_5949 - _198) + (_5990 * _5954);
                        _5997 = (_5950 - _199) + (_5990 * _5955);
                        _5999 = (_5951 + _197) + (_5990 * _5956);
                        _6000 = dot(float3(_5995, _5997, _5999), float3(_5995, _5997, _5999));
                        _6001 = rsqrt(_6000);
                        _6003 = _5995 * _6001;
                        _6004 = _5997 * _6001;
                        _6005 = _5999 * _6001;
                        _6008 = max(0.0f, ((_6001 * _6000) - abs(_5983)));
                        _6009 = _6008 * f16tof32(((uint)((uint)(_5968) >> 16)));
                        _6010 = _6009 * _6009;
                        _6013 = saturate(1.0f - (_6010 * _6010));
                        _6020 = (_6013 * _6013) / (select((_5983 < 0.0f), (_6010 * 16.0f), (_6008 * _6008)) + 1.0f);
                        [branch]
                        if (!(_6020 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _6029 = srvLightMappingData[_1443];
                            if (!(_6029 == -1)) {
                              _6034 = srvLightIndexData[_6029].nLayerIndex;
                              _6036 = srvLightIndexData[_6029].vAtlasOrigin.x;
                              _6037 = srvLightIndexData[_6029].vAtlasOrigin.y;
                              _6039 = srvLightIndexData[_6029].vScreenOrigin.x;
                              _6040 = srvLightIndexData[_6029].vScreenOrigin.y;
                              _6049 = ((int)(_6034 * 5)) & 31;
                              _6058 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6036 + _62) - _6039)), ((int)((_6037 + _63) - _6040)), 0)))).x) & ((int)(31 << _6049)))) >> _6049)) >> 1)))) * 0.06666667014360428f) * _6020);
                            } else {
                              _6058 = _6020;
                            }
                          } else {
                            _6058 = _6020;
                          }
                          _6062 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _6064 = select(_6062, (_6058 * _1190), _6058);
                          _6065 = dot(float3(_179, _180, _181), float3(_6003, _6004, _6005));
                          _6066 = dot(float3(_179, _180, _181), float3(_371, _372, _370));
                          _6067 = dot(float3(_371, _372, _370), float3(_6003, _6004, _6005));
                          _6070 = rsqrt((_6067 * 2.0f) + 2.0f);
                          _6073 = saturate(_6070 * (_6066 + _6065));
                          _6074 = saturate(_6065);
                          _6075 = _190 * _190;
                          _6076 = _6075 * _6075;
                          _6080 = (((_6073 * _6076) - _6073) * _6073) + 1.0f;
                          _6085 = saturate(abs(_6066) + 9.999999747378752e-06f);
                          _6086 = sqrt(_6076);
                          _6087 = 1.0f - _6086;
                          _6099 = saturate((_6065 + _5980) / (_5980 + 1.0f));
                          _6101 = ((_6076 / (_6080 * _6080)) * _6074) * (0.5f / ((((_6087 * _6085) + _6086) * _6074) + (((_6087 * _6074) + _6086) * _6085)));
                          _6102 = f16tof32(((uint)((uint)(_5962) >> 16))) * _1490;
                          _6103 = f16tof32(_5962) * _1490;
                          _6104 = f16tof32(((uint)((uint)(_5965) >> 16))) * _1490;
                          _6111 = ((_6064 * _6102) * _6099) + _1428;
                          _6112 = ((_6064 * _6103) * _6099) + _1429;
                          _6113 = ((_6064 * _6104) * _6099) + _1430;
                          if (_5977 > 0.0f) {
                            _6125 = (exp2(log2(1.0f - saturate(saturate((_6070 * _6067) + _6070))) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                            _6128 = select(_6062, (_6058 * _1190), _6058) * _5977;
                            _8238 = _6111;
                            _8239 = _6112;
                            _8240 = _6113;
                            _8241 = (((((_6102 * _1059) * _6128) * _6125) * _6101) + _1431);
                            _8242 = (((((_6103 * _1059) * _6128) * _6125) * _6101) + _1432);
                            _8243 = (((((_6104 * _1059) * _6128) * _6125) * _6101) + _1433);
                          } else {
                            _8238 = _6111;
                            _8239 = _6112;
                            _8240 = _6113;
                            _8241 = _1431;
                            _8242 = _1432;
                            _8243 = _1433;
                          }
                        } else {
                          _8238 = _1428;
                          _8239 = _1429;
                          _8240 = _1430;
                          _8241 = _1431;
                          _8242 = _1432;
                          _8243 = _1433;
                        }
                      } else {
                        if (_1473 == 9) {
                          _6149 = asfloat(srvLightInfoProperties.Load4(_1442)).x;
                          _6150 = asfloat(srvLightInfoProperties.Load4(_1442)).y;
                          _6151 = asfloat(srvLightInfoProperties.Load4(_1442)).w;
                          _6154 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).x;
                          _6155 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).y;
                          _6156 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).w;
                          _6159 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).x;
                          _6160 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).y;
                          _6161 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).w;
                          _6164 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 48u)))).x;
                          _6165 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 48u)))).y;
                          _6166 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 48u)))).w;
                          _6169 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 64u)))).x;
                          _6170 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 64u)))).y;
                          _6171 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 64u)))).z;
                          _6174 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 76u)))).x;
                          _6175 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 76u)))).y;
                          _6176 = asfloat(srvLightInfoProperties.Load3(((int)(_1442 + 76u)))).z;
                          _6179 = asint(srvLightInfoProperties.Load(((int)(_1442 + 88u))));
                          _6182 = asint(srvLightInfoProperties.Load(((int)(_1442 + 92u))));
                          _6185 = asint(srvLightInfoProperties.Load(((int)(_1442 + 100u))));
                          _6188 = asint(srvLightInfoProperties.Load(((int)(_1442 + 104u))));
                          _6191 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).x;
                          _6192 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).y;
                          _6193 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).z;
                          _6194 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 108u)))).w;
                          _6197 = asint(srvLightInfoProperties.Load(((int)(_1442 + 124u))));
                          _6200 = asint(srvLightInfoProperties.Load(((int)(_1442 + 128u))));
                          _6203 = asint(srvLightInfoProperties.Load(((int)(_1442 + 132u))));
                          _6206 = asint(srvLightInfoProperties.Load(((int)(_1442 + 136u))));
                          _6209 = asint(srvLightInfoProperties.Load(((int)(_1442 + 140u))));
                          _6212 = asint(srvLightInfoProperties.Load(((int)(_1442 + 144u))));
                          _6215 = asint(srvLightInfoProperties.Load(((int)(_1442 + 148u))));
                          _6218 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 152u)))).x;
                          _6219 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 152u)))).y;
                          _6220 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 152u)))).z;
                          _6221 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 152u)))).w;
                          _6224 = asint(srvLightInfoProperties.Load(((int)(_1442 + 168u))));
                          _6227 = asint(srvLightInfoProperties.Load(((int)(_1442 + 172u))));
                          _6230 = asint(srvLightInfoProperties.Load(((int)(_1442 + 180u))));
                          _6232 = f16tof32(((uint)((uint)(_6179) >> 16)));
                          _6233 = f16tof32(_6179);
                          _6235 = f16tof32(((uint)((uint)(_6182) >> 16)));
                          _6239 = ((float)((uint)((uint)(((uint)(_6182) >> 8) & 255)))) * 0.003921499941498041f;
                          _6242 = ((float)((uint)((uint)(_6182 & 255)))) * 0.003921499941498041f;
                          _6243 = f16tof32(_6185);
                          _6245 = f16tof32(((uint)((uint)(_6188) >> 16)));
                          _6249 = f16tof32(_6197);
                          _6253 = _6203 & 65535;
                          _6269 = f16tof32(((uint)((uint)(_6227) >> 16)));
                          _6270 = f16tof32(_6227);
                          _6272 = f16tof32(((uint)((uint)(_6230) >> 16)));
                          _6273 = 1.0f / _6272;
                          _6274 = _6272 + -1.0f;
                          _6275 = f16tof32(_6230);
                          _6276 = _6169 - _198;
                          _6277 = _6170 - _199;
                          _6278 = _6171 + _197;
                          _6279 = dot(float3(_6276, _6277, _6278), float3(_6276, _6277, _6278));
                          _6280 = rsqrt(_6279);
                          _6281 = _6280 * _6279;
                          _6282 = _6280 * _6276;
                          _6283 = _6280 * _6277;
                          _6284 = _6280 * _6278;
                          _6287 = max(0.0f, (_6281 - abs(_6249)));
                          _6288 = _6287 * f16tof32(((uint)((uint)(_6197) >> 16)));
                          _6289 = _6288 * _6288;
                          _6292 = saturate(1.0f - (_6289 * _6289));
                          _6303 = mad(_200, _6161, mad(_199, _6156, (_6151 * _198))) + _6166;
                          _6307 = saturate(1.0f - dot(float3(_179, _180, _181), float3(_6282, _6283, _6284))) * f16tof32(_6224);
                          _6314 = ((_6303 * _179) * _6307) + _198;
                          _6315 = ((_6303 * _180) * _6307) + _199;
                          _6316 = ((_6303 * _181) * _6307) - _197;
                          _6328 = mad(_6316, _6161, mad(_6315, _6156, (_6314 * _6151))) + _6166;
                          _6329 = 1.0f / _6328;
                          _6330 = _6329 * (mad(_6316, _6159, mad(_6315, _6154, (_6314 * _6149))) + _6164);
                          _6331 = _6329 * (mad(_6316, _6160, mad(_6315, _6155, (_6314 * _6150))) + _6165);
                          _6334 = (_6330 * _6191) + _6192;
                          _6335 = (_6331 * _6191) + _6192;
                          _6338 = _6334 - saturate(_6334);
                          _6339 = _6335 - saturate(_6335);
                          _6346 = saturate((sqrt((_6338 * _6338) + (_6339 * _6339)) * _6193) + _6194);
                          _6348 = 1.0f - (_6346 * _6346);
                          _6354 = (_6348 * _6348) * (((float)((bool)(uint)((_6328 - f16tof32(((uint)((uint)(_6200) >> 16)))) > 0.0f))) * ((_6292 * _6292) / (select((_6249 < 0.0f), (_6289 * 16.0f), (_6287 * _6287)) + 1.0f)));
                          _6356 = ((_1440 & 3584) == 0);
                          if (!((!(_6354 > 0.0f)) || _6356)) {
                            _6364 = 1.0f - saturate(f16tof32(_6200) * _6328);
                            _6365 = saturate(_6330);
                            _6366 = saturate(_6331);
                            bool __branch_chain_6358;
                            [branch]
                            if ((_1440 & 1024) == 0) {
                              _6629 = 1.0f;
                              _6630 = 0.0f;
                              _6631 = _6364;
                              __branch_chain_6358 = true;
                            } else {
                              _6371 = ((_6365 * _6274) + 0.5f) * _6273;
                              _6373 = ((_6366 * _6274) + 0.5f) * _6273;
                              _6374 = _6364 + f16tof32(((uint)((uint)(_6224) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6203) >> 16))];
                              _6377 = saturate(_6374);
                              _6381 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _6390 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_6381 * 32.665000915527344f) + _124), ((_6381 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _6391 = sin(_6390);
                              _6392 = cos(_6390);
                              _6393 = cbSharedPerViewData.nFrameCounter & 3;
                              _6398 = sqrt((float((int)(_6393)) * 0.25f) + 0.125f) * _6269;
                              _6407 = (_global_7[min((uint)(((int)(0u + (_6393 * 2)))), 127u)]) * _6398;
                              _6408 = (_global_7[min((uint)(((int)(1u + (_6393 * 2)))), 127u)]) * _6398;
                              _6410 = -0.0f - _6391;
                              _6415 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6407, _6408), float2(_6392, _6391)) + _6371), (dot(float2(_6407, _6408), float2(_6410, _6392)) + _6373)));
                              _6420 = _6415.x - _6377;
                              _6422 = select((_6420 < 0.0f), 0.0f, 1.0f);
                              _6424 = _6415.y - _6377;
                              _6426 = select((_6424 < 0.0f), 0.0f, 1.0f);
                              _6430 = _6415.z - _6377;
                              _6432 = select((_6430 < 0.0f), 0.0f, 1.0f);
                              _6436 = _6415.w - _6377;
                              _6438 = select((_6436 < 0.0f), 0.0f, 1.0f);
                              _6445 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _6450 = sqrt((float((int)(_6445)) * 0.25f) + 0.125f) * _6269;
                              _6459 = (_global_7[min((uint)(((int)(0u + (_6445 * 2)))), 127u)]) * _6450;
                              _6460 = (_global_7[min((uint)(((int)(1u + (_6445 * 2)))), 127u)]) * _6450;
                              _6466 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6459, _6460), float2(_6392, _6391)) + _6371), (dot(float2(_6459, _6460), float2(_6410, _6392)) + _6373)));
                              _6471 = _6466.x - _6377;
                              _6473 = select((_6471 < 0.0f), 0.0f, 1.0f);
                              _6477 = _6466.y - _6377;
                              _6479 = select((_6477 < 0.0f), 0.0f, 1.0f);
                              _6483 = _6466.z - _6377;
                              _6485 = select((_6483 < 0.0f), 0.0f, 1.0f);
                              _6489 = _6466.w - _6377;
                              _6491 = select((_6489 < 0.0f), 0.0f, 1.0f);
                              _6498 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _6503 = sqrt((float((int)(_6498)) * 0.25f) + 0.125f) * _6269;
                              _6512 = (_global_7[min((uint)(((int)(0u + (_6498 * 2)))), 127u)]) * _6503;
                              _6513 = (_global_7[min((uint)(((int)(1u + (_6498 * 2)))), 127u)]) * _6503;
                              _6519 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6512, _6513), float2(_6392, _6391)) + _6371), (dot(float2(_6512, _6513), float2(_6410, _6392)) + _6373)));
                              _6524 = _6519.x - _6377;
                              _6526 = select((_6524 < 0.0f), 0.0f, 1.0f);
                              _6530 = _6519.y - _6377;
                              _6532 = select((_6530 < 0.0f), 0.0f, 1.0f);
                              _6536 = _6519.z - _6377;
                              _6538 = select((_6536 < 0.0f), 0.0f, 1.0f);
                              _6542 = _6519.w - _6377;
                              _6544 = select((_6542 < 0.0f), 0.0f, 1.0f);
                              _6551 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _6556 = sqrt((float((int)(_6551)) * 0.25f) + 0.125f) * _6269;
                              _6565 = (_global_7[min((uint)(((int)(0u + (_6551 * 2)))), 127u)]) * _6556;
                              _6566 = (_global_7[min((uint)(((int)(1u + (_6551 * 2)))), 127u)]) * _6556;
                              _6572 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6565, _6566), float2(_6392, _6391)) + _6371), (dot(float2(_6565, _6566), float2(_6410, _6392)) + _6373)));
                              _6577 = _6572.x - _6377;
                              _6579 = select((_6577 < 0.0f), 0.0f, 1.0f);
                              _6583 = _6572.y - _6377;
                              _6585 = select((_6583 < 0.0f), 0.0f, 1.0f);
                              _6589 = _6572.z - _6377;
                              _6591 = select((_6589 < 0.0f), 0.0f, 1.0f);
                              _6595 = _6572.w - _6377;
                              _6597 = select((_6595 < 0.0f), 0.0f, 1.0f);
                              _6598 = ((((((((((((((_6422 + _6426) + _6432) + _6438) + _6473) + _6479) + _6485) + _6491) + _6526) + _6532) + _6538) + _6544) + _6579) + _6585) + _6591) + _6597;
                              _6609 = (saturate(_6598 * 0.0625f) * 2.0f) + -1.0f;
                              _6615 = float((int)(((int)(uint)((int)(_6609 > 0.0f))) - ((int)(uint)((int)(_6609 < 0.0f)))));
                              _6617 = 1.0f - (_6615 * _6609);
                              _6619 = (_6617 * _6617) * _6617;
                              _6626 = 0.5f - ((_6615 * 0.5f) * ((1.0f - _6619) - ((_6617 - _6619) * saturate(((1.0f / _6377) * (1.0f / _6598)) * ((((((((((((((((_6422 * _6420) + (_6426 * _6424)) + (_6432 * _6430)) + (_6438 * _6436)) + (_6473 * _6471)) + (_6479 * _6477)) + (_6485 * _6483)) + (_6491 * _6489)) + (_6526 * _6524)) + (_6532 * _6530)) + (_6538 * _6536)) + (_6544 * _6542)) + (_6579 * _6577)) + (_6585 * _6583)) + (_6591 * _6589)) + (_6597 * _6595))))));
                              [branch]
                              if (_6275 < 1.0f) {
                                _6629 = _6626;
                                _6630 = _6275;
                                _6631 = _6374;
                                __branch_chain_6358 = true;
                              } else {
                                _7099 = _6275;
                                _7100 = _6626;
                                __branch_chain_6358 = false;
                              }
                            }
                            if (__branch_chain_6358) {
                              _6634 = (_6365 * _6218) + _6220;
                              _6635 = (_6366 * _6219) + _6221;
                              if (!((_1440 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _6644 = saturate(_6631);
                                _6648 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _6657 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_6648 * 32.665000915527344f) + _124), ((_6648 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _6658 = sin(_6657);
                                _6659 = cos(_6657);
                                _6664 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_6634, _6635), 0.0f))).x) > _6644), 1.0f, 0.0f);
                                _6665 = cbSharedPerViewData.nFrameCounter & 3;
                                _6670 = sqrt((float((int)(_6665)) * 0.25f) + 0.125f) * _6270;
                                _6679 = (_global_7[min((uint)(((int)(0u + (_6665 * 2)))), 127u)]) * _6670;
                                _6680 = (_global_7[min((uint)(((int)(1u + (_6665 * 2)))), 127u)]) * _6670;
                                _6682 = -0.0f - _6658;
                                _6684 = dot(float2(_6679, _6680), float2(_6659, _6658)) + _6634;
                                _6685 = dot(float2(_6679, _6680), float2(_6682, _6659)) + _6635;
                                _6687 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6684, _6685));
                                _6691 = _6684 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6692 = _6685 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6695 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6220);
                                _6696 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6221);
                                _6701 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6218 + _6220)) + 0.5f);
                                _6702 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6219 + _6221)) + 0.5f);
                                _6705 = floor(_6691 + -0.5f);
                                _6706 = floor(_6692 + 0.5f);
                                _6708 = floor(_6691 + 0.5f);
                                _6710 = floor(_6692 + -0.5f);
                                _6711 = (_6705 < _6695);
                                _6712 = (_6706 < _6696);
                                if ((_6711 || _6712) | ((_6705 >= _6701) || (_6706 >= _6702))) {
                                  _6721 = _6664;
                                } else {
                                  _6721 = _6687.x;
                                }
                                _6722 = (_6708 < _6695);
                                if ((_6722 || _6712) | ((_6708 >= _6701) || (_6706 >= _6702))) {
                                  _6730 = _6664;
                                } else {
                                  _6730 = _6687.y;
                                }
                                _6731 = (_6710 < _6696);
                                if ((_6722 || _6731) | ((_6708 >= _6701) || (_6710 >= _6702))) {
                                  _6739 = _6664;
                                } else {
                                  _6739 = _6687.z;
                                }
                                if ((_6711 || _6731) | ((_6705 >= _6701) || (_6710 >= _6702))) {
                                  _6747 = _6664;
                                } else {
                                  _6747 = _6687.w;
                                }
                                _6748 = _6721 - _6644;
                                _6750 = select((_6748 < 0.0f), 0.0f, 1.0f);
                                _6752 = _6730 - _6644;
                                _6754 = select((_6752 < 0.0f), 0.0f, 1.0f);
                                _6758 = _6739 - _6644;
                                _6760 = select((_6758 < 0.0f), 0.0f, 1.0f);
                                _6764 = _6747 - _6644;
                                _6766 = select((_6764 < 0.0f), 0.0f, 1.0f);
                                _6773 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _6778 = sqrt((float((int)(_6773)) * 0.25f) + 0.125f) * _6270;
                                _6787 = (_global_7[min((uint)(((int)(0u + (_6773 * 2)))), 127u)]) * _6778;
                                _6788 = (_global_7[min((uint)(((int)(1u + (_6773 * 2)))), 127u)]) * _6778;
                                _6791 = dot(float2(_6787, _6788), float2(_6659, _6658)) + _6634;
                                _6792 = dot(float2(_6787, _6788), float2(_6682, _6659)) + _6635;
                                _6794 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6791, _6792));
                                _6798 = _6791 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6799 = _6792 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6802 = floor(_6798 + -0.5f);
                                _6803 = floor(_6799 + 0.5f);
                                _6805 = floor(_6798 + 0.5f);
                                _6807 = floor(_6799 + -0.5f);
                                _6808 = (_6802 < _6695);
                                _6809 = (_6803 < _6696);
                                if ((_6808 || _6809) | ((_6802 >= _6701) || (_6803 >= _6702))) {
                                  _6818 = _6664;
                                } else {
                                  _6818 = _6794.x;
                                }
                                _6819 = (_6805 < _6695);
                                if ((_6819 || _6809) | ((_6805 >= _6701) || (_6803 >= _6702))) {
                                  _6827 = _6664;
                                } else {
                                  _6827 = _6794.y;
                                }
                                _6828 = (_6807 < _6696);
                                if ((_6819 || _6828) | ((_6805 >= _6701) || (_6807 >= _6702))) {
                                  _6836 = _6664;
                                } else {
                                  _6836 = _6794.z;
                                }
                                if ((_6808 || _6828) | ((_6802 >= _6701) || (_6807 >= _6702))) {
                                  _6844 = _6664;
                                } else {
                                  _6844 = _6794.w;
                                }
                                _6845 = _6818 - _6644;
                                _6847 = select((_6845 < 0.0f), 0.0f, 1.0f);
                                _6851 = _6827 - _6644;
                                _6853 = select((_6851 < 0.0f), 0.0f, 1.0f);
                                _6857 = _6836 - _6644;
                                _6859 = select((_6857 < 0.0f), 0.0f, 1.0f);
                                _6863 = _6844 - _6644;
                                _6865 = select((_6863 < 0.0f), 0.0f, 1.0f);
                                _6872 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _6877 = sqrt((float((int)(_6872)) * 0.25f) + 0.125f) * _6270;
                                _6886 = (_global_7[min((uint)(((int)(0u + (_6872 * 2)))), 127u)]) * _6877;
                                _6887 = (_global_7[min((uint)(((int)(1u + (_6872 * 2)))), 127u)]) * _6877;
                                _6890 = dot(float2(_6886, _6887), float2(_6659, _6658)) + _6634;
                                _6891 = dot(float2(_6886, _6887), float2(_6682, _6659)) + _6635;
                                _6893 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6890, _6891));
                                _6897 = _6890 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6898 = _6891 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _6901 = floor(_6897 + -0.5f);
                                _6902 = floor(_6898 + 0.5f);
                                _6904 = floor(_6897 + 0.5f);
                                _6906 = floor(_6898 + -0.5f);
                                _6907 = (_6901 < _6695);
                                _6908 = (_6902 < _6696);
                                if ((_6907 || _6908) | ((_6901 >= _6701) || (_6902 >= _6702))) {
                                  _6917 = _6664;
                                } else {
                                  _6917 = _6893.x;
                                }
                                _6918 = (_6904 < _6695);
                                if ((_6918 || _6908) | ((_6904 >= _6701) || (_6902 >= _6702))) {
                                  _6926 = _6664;
                                } else {
                                  _6926 = _6893.y;
                                }
                                _6927 = (_6906 < _6696);
                                if ((_6918 || _6927) | ((_6904 >= _6701) || (_6906 >= _6702))) {
                                  _6935 = _6664;
                                } else {
                                  _6935 = _6893.z;
                                }
                                if ((_6907 || _6927) | ((_6901 >= _6701) || (_6906 >= _6702))) {
                                  _6943 = _6664;
                                } else {
                                  _6943 = _6893.w;
                                }
                                _6944 = _6917 - _6644;
                                _6946 = select((_6944 < 0.0f), 0.0f, 1.0f);
                                _6950 = _6926 - _6644;
                                _6952 = select((_6950 < 0.0f), 0.0f, 1.0f);
                                _6956 = _6935 - _6644;
                                _6958 = select((_6956 < 0.0f), 0.0f, 1.0f);
                                _6962 = _6943 - _6644;
                                _6964 = select((_6962 < 0.0f), 0.0f, 1.0f);
                                _6971 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _6976 = sqrt((float((int)(_6971)) * 0.25f) + 0.125f) * _6270;
                                _6985 = (_global_7[min((uint)(((int)(0u + (_6971 * 2)))), 127u)]) * _6976;
                                _6986 = (_global_7[min((uint)(((int)(1u + (_6971 * 2)))), 127u)]) * _6976;
                                _6989 = dot(float2(_6985, _6986), float2(_6659, _6658)) + _6634;
                                _6990 = dot(float2(_6985, _6986), float2(_6682, _6659)) + _6635;
                                _6992 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6989, _6990));
                                _6996 = _6989 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _6997 = _6990 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _7000 = floor(_6996 + -0.5f);
                                _7001 = floor(_6997 + 0.5f);
                                _7003 = floor(_6996 + 0.5f);
                                _7005 = floor(_6997 + -0.5f);
                                _7006 = (_7000 < _6695);
                                _7007 = (_7001 < _6696);
                                if ((_7006 || _7007) | ((_7000 >= _6701) || (_7001 >= _6702))) {
                                  _7016 = _6664;
                                } else {
                                  _7016 = _6992.x;
                                }
                                _7017 = (_7003 < _6695);
                                if ((_7017 || _7007) | ((_7003 >= _6701) || (_7001 >= _6702))) {
                                  _7025 = _6664;
                                } else {
                                  _7025 = _6992.y;
                                }
                                _7026 = (_7005 < _6696);
                                if ((_7017 || _7026) | ((_7003 >= _6701) || (_7005 >= _6702))) {
                                  _7034 = _6664;
                                } else {
                                  _7034 = _6992.z;
                                }
                                if ((_7006 || _7026) | ((_7000 >= _6701) || (_7005 >= _6702))) {
                                  _7042 = _6664;
                                } else {
                                  _7042 = _6992.w;
                                }
                                _7043 = _7016 - _6644;
                                _7045 = select((_7043 < 0.0f), 0.0f, 1.0f);
                                _7049 = _7025 - _6644;
                                _7051 = select((_7049 < 0.0f), 0.0f, 1.0f);
                                _7055 = _7034 - _6644;
                                _7057 = select((_7055 < 0.0f), 0.0f, 1.0f);
                                _7061 = _7042 - _6644;
                                _7063 = select((_7061 < 0.0f), 0.0f, 1.0f);
                                _7064 = ((((((((((((((_6754 + _6750) + _6760) + _6766) + _6847) + _6853) + _6859) + _6865) + _6946) + _6952) + _6958) + _6964) + _7045) + _7051) + _7057) + _7063;
                                _7075 = (saturate(_7064 * 0.0625f) * 2.0f) + -1.0f;
                                _7081 = float((int)(((int)(uint)((int)(_7075 > 0.0f))) - ((int)(uint)((int)(_7075 < 0.0f)))));
                                _7083 = 1.0f - (_7081 * _7075);
                                _7085 = (_7083 * _7083) * _7083;
                                _7094 = (0.5f - ((_7081 * 0.5f) * ((1.0f - _7085) - ((_7083 - _7085) * saturate(((1.0f / _6644) * (1.0f / _7064)) * ((((((((((((((((_6754 * _6752) + (_6750 * _6748)) + (_6760 * _6758)) + (_6766 * _6764)) + (_6847 * _6845)) + (_6853 * _6851)) + (_6859 * _6857)) + (_6865 * _6863)) + (_6946 * _6944)) + (_6952 * _6950)) + (_6958 * _6956)) + (_6964 * _6962)) + (_7045 * _7043)) + (_7051 * _7049)) + (_7057 * _7055)) + (_7063 * _7061)))))));
                              } else {
                                _7094 = 1.0f;
                              }
                              _7099 = _6630;
                              _7100 = (lerp(_7094, _6629, _6630));
                            }
                            [branch]
                            if (!((_1440 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6206) >> 16))];
                              _7106 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6330, _6331), 0.0f);
                              if (_7106.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6206 & 65535))];
                                _7113 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6330, _6331), 0.0f);
                                _7127 = mad(saturate(((log2(_6281) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _7128 = max(9.999999747378752e-06f, _7106.x);
                                _7129 = _7113.x / _7128;
                                _7130 = _7113.y / _7128;
                                _7132 = _7113.w / _7128;
                                _7137 = ((0.375f - _7130) * 4.999999873689376e-06f) + _7130;
                                _7140 = -0.0f - _7129;
                                _7141 = mad(_7140, _7137, (_7113.z / _7128));
                                _7143 = 1.0f / mad(_7140, _7129, _7137);
                                _7144 = _7143 * _7141;
                                _7149 = _7127 - _7129;
                                _7154 = (((_7127 * _7127) - _7137) - (_7144 * _7149)) / mad((-0.0f - _7141), _7144, mad((-0.0f - _7137), _7137, (((0.375f - _7132) * 4.999999873689376e-06f) + _7132)));
                                _7156 = (_7143 * _7149) - (_7154 * _7144);
                                _7159 = 1.0f / _7154;
                                _7160 = _7156 * _7159;
                                _7165 = sqrt(((_7160 * _7160) * 0.25f) - ((1.0f - dot(float2(_7156, _7154), float2(_7129, _7137))) * _7159));
                                _7167 = (_7160 * -0.5f) - _7165;
                                _7169 = _7165 - (_7160 * 0.5f);
                                _7171 = select((_7167 < _7127), 1.0f, 0.0f);
                                _7176 = (_7171 + -0.05000000074505806f) / (_7167 - _7127);
                                _7182 = (((select((_7169 < _7127), 1.0f, 0.0f) - _7171) / (_7169 - _7167)) - _7176) / (_7169 - _7127);
                                _7184 = _7176 - (_7182 * _7167);
                                _7197 = _7099;
                                _7198 = (exp2((_7106.x * -1.4426950216293335f) * saturate((dot(float2(_7129, _7137), float2((_7184 - (_7182 * _7127)), _7182)) + 0.05000000074505806f) - (_7184 * _7127))) * _7100);
                              } else {
                                _7197 = _7099;
                                _7198 = _7100;
                              }
                            } else {
                              _7197 = _7099;
                              _7198 = _7100;
                            }
                          } else {
                            _7197 = 0.0f;
                            _7198 = 1.0f;
                          }
                          [branch]
                          if (!(_6253 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6253)))];
                            _7211 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6330 * f16tof32(((uint)((uint)(_6212) >> 16)))) + f16tof32(((uint)((uint)(_6215) >> 16)))), ((_6331 * f16tof32(_6212)) + f16tof32(_6215))), 0.0f);
                            _7219 = (_7211.x * _6232);
                            _7220 = (_7211.y * _6233);
                            _7221 = (_7211.z * _6235);
                          } else {
                            _7219 = _6232;
                            _7220 = _6233;
                            _7221 = _6235;
                          }
                          _7222 = _7198 * _6354;
                          [branch]
                          if (!(_7222 == 0.0f)) {
                            bool __branch_chain_7224;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _7240 = 0;
                              __branch_chain_7224 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _7240 = 1;
                                __branch_chain_7224 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _7240 = 2;
                                  __branch_chain_7224 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1443) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _7240 = 3;
                                    __branch_chain_7224 = true;
                                  } else {
                                    _7265 = _7222;
                                    __branch_chain_7224 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_7224) {
                              while(true) {
                                _7243 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_62, _63, 0));
                                if (_7240 == 0) {
                                  _7257 = _7243.x;
                                } else {
                                  if (_7240 == 1) {
                                    _7257 = _7243.y;
                                  } else {
                                    if (_7240 == 2) {
                                      _7257 = _7243.z;
                                    } else {
                                      _7257 = _7243.w;
                                    }
                                  }
                                }
                                _7265 = ((((_7197 * _7197) * ((_7257 * _7257) + -1.0f)) + 1.0f) * _6354);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_7265 > 0.0f) {
                                if (!(((_6209 & 1) == 0) || _6356)) {
                                  _7281 = max(max(_7219, _7220), _7221);
                                  if (_7281 > 0.0f) {
                                    _7291 = saturate(_7219 / _7281);
                                    _7292 = saturate(_7220 / _7281);
                                    _7293 = saturate(_7221 / _7281);
                                  } else {
                                    _7291 = _7219;
                                    _7292 = _7220;
                                    _7293 = _7221;
                                  }
                                  _7294 = (_7292 < _7293);
                                  _7295 = select(_7294, _7293, _7292);
                                  _7296 = select(_7294, _7292, _7293);
                                  _7297 = select(_7294, -1.0f, 0.0f);
                                  _7298 = (_7291 < _7295);
                                  _7300 = select(_7298, _7295, _7291);
                                  _7301 = select(_7298, _7291, _7295);
                                  _7305 = _7300 - select((_7301 < _7296), _7301, _7296);
                                  _7311 = abs(select(_7298, (-0.3333333432674408f - _7297), _7297) + ((_7301 - _7296) / ((_7305 * 6.0f) + 9.999999682655225e-21f)));
                                  if (_7311 < 0.6666666865348816f) {
                                    _7324 = ((saturate(((float)((uint)((uint)(((uint)(_6209) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7311 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7311)) + _7311);
                                  } else {
                                    _7324 = _7311;
                                  }
                                  _7325 = saturate((_7305 / (_7300 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6209) >> 1) & 255)))) * 0.003921499941498041f));
                                  _7326 = saturate(_7300);
                                  if (!(_7325 <= 0.0f)) {
                                    _7329 = saturate(_7324);
                                    _7333 = select(((_7329 * 360.0f) >= 360.0f), 0.0f, (_7329 * 6.0f));
                                    _7334 = int(_7333);
                                    _7336 = _7333 - float((int)(_7334));
                                    _7338 = _7326 * (1.0f - _7325);
                                    _7341 = (1.0f - (_7336 * _7325)) * _7326;
                                    _7345 = (1.0f - ((1.0f - _7336) * _7325)) * _7326;
                                    switch (_7334) {
                                      case 0: {
                                        _7353 = _7326;
                                        _7354 = _7345;
                                        _7355 = _7338;
                                        break;
                                      }
                                      case 1: {
                                        _7353 = _7341;
                                        _7354 = _7326;
                                        _7355 = _7338;
                                        break;
                                      }
                                      case 2: {
                                        _7353 = _7338;
                                        _7354 = _7326;
                                        _7355 = _7345;
                                        break;
                                      }
                                      case 3: {
                                        _7353 = _7338;
                                        _7354 = _7341;
                                        _7355 = _7326;
                                        break;
                                      }
                                      case 4: {
                                        _7353 = _7345;
                                        _7354 = _7338;
                                        _7355 = _7326;
                                        break;
                                      }
                                      case 5: {
                                        _7353 = _7326;
                                        _7354 = _7338;
                                        _7355 = _7341;
                                        break;
                                      }
                                      default: {
                                        _7353 = 0.0f;
                                        _7354 = 0.0f;
                                        _7355 = 0.0f;
                                        break;
                                      }
                                    }
                                  } else {
                                    _7353 = _7326;
                                    _7354 = _7326;
                                    _7355 = _7326;
                                  }
                                  _7356 = _7353 * _7281;
                                  _7357 = _7354 * _7281;
                                  _7358 = _7355 * _7281;
                                  _7360 = saturate(_7198 * 1.0101009607315063f);
                                  _7371 = ((_7360 * (_7219 - _7356)) + _7356);
                                  _7372 = ((_7360 * (_7220 - _7357)) + _7357);
                                  _7373 = (lerp(_7358, _7221, _7360));
                                } else {
                                  _7371 = _7219;
                                  _7372 = _7220;
                                  _7373 = _7221;
                                }
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _7380 = srvLightMappingData[_1443];
                                  if (!(_7380 == -1)) {
                                    _7385 = srvLightIndexData[_7380].nLayerIndex;
                                    _7387 = srvLightIndexData[_7380].vAtlasOrigin.x;
                                    _7388 = srvLightIndexData[_7380].vAtlasOrigin.y;
                                    _7390 = srvLightIndexData[_7380].vScreenOrigin.x;
                                    _7391 = srvLightIndexData[_7380].vScreenOrigin.y;
                                    _7400 = ((int)(_7385 * 5)) & 31;
                                    _7409 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7387 + _62) - _7390)), ((int)((_7388 + _63) - _7391)), 0)))).x) & ((int)(31 << _7400)))) >> _7400)) >> 1)))) * 0.06666667014360428f) * _7265);
                                  } else {
                                    _7409 = _7265;
                                  }
                                } else {
                                  _7409 = _7265;
                                }
                                _7413 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _7416 = select(_7413, (_7409 * _1190), _7409);
                                _7418 = _6282 * _6281;
                                _7419 = _6283 * _6281;
                                _7420 = _6284 * _6281;
                                _7421 = _6243 * _6174;
                                _7422 = _6243 * _6175;
                                _7423 = _6243 * _6176;
                                _7424 = _7418 + _7421;
                                _7425 = _7419 + _7422;
                                _7426 = _7420 + _7423;
                                _7427 = _7418 - _7421;
                                _7428 = _7419 - _7422;
                                _7429 = _7420 - _7423;
                                _7430 = (_6243 > 0.0f);
                                _7431 = dot(float3(_7424, _7425, _7426), float3(_7424, _7425, _7426));
                                _7432 = rsqrt(_7431);
                                [branch]
                                if (_7430) {
                                  _7435 = rsqrt(dot(float3(_7427, _7428, _7429), float3(_7427, _7428, _7429)));
                                  _7436 = _7435 * _7432;
                                  _7438 = dot(float3(_7424, _7425, _7426), float3(_7427, _7428, _7429)) * _7436;
                                  _7457 = (_7436 / ((_7436 + 0.5f) + (_7438 * 0.5f)));
                                  _7458 = (((dot(float3(_179, _180, _181), float3(_7427, _7428, _7429)) * _7435) + (dot(float3(_179, _180, _181), float3(_7424, _7425, _7426)) * _7432)) * 0.5f);
                                  _7459 = _7438;
                                } else {
                                  _7457 = (1.0f / (_7431 + 1.0f));
                                  _7458 = dot(float3(_179, _180, _181), float3((_7432 * _7424), (_7432 * _7425), (_7432 * _7426)));
                                  _7459 = 1.0f;
                                }
                                if (_6245 > 0.0f) {
                                  _7465 = sqrt(saturate((_6245 * _6245) * _7457));
                                  if (_7458 < _7465) {
                                    _7470 = max(_7458, (-0.0f - _7465)) + _7465;
                                    _7475 = ((_7470 * _7470) / (_7465 * 4.0f));
                                  } else {
                                    _7475 = _7458;
                                  }
                                } else {
                                  _7475 = _7458;
                                }
                                if (_7430) {
                                  _7477 = -0.0f - _371;
                                  _7478 = -0.0f - _372;
                                  _7479 = -0.0f - _370;
                                  _7481 = dot(float3(_7477, _7478, _7479), float3(_179, _180, _181)) * 2.0f;
                                  _7485 = _7477 - (_7481 * _179);
                                  _7486 = _7478 - (_7481 * _180);
                                  _7487 = _7479 - (_7481 * _181);
                                  _7488 = _7427 - _7424;
                                  _7489 = _7428 - _7425;
                                  _7490 = _7429 - _7426;
                                  _7491 = dot(float3(_7485, _7486, _7487), float3(_7488, _7489, _7490));
                                  _7497 = sqrt(((_7488 * _7488) + (_7489 * _7489)) + (_7490 * _7490));
                                  _7506 = saturate(((dot(float3(_7485, _7486, _7487), float3(_7424, _7425, _7426)) * _7491) - dot(float3(_7424, _7425, _7426), float3(_7488, _7489, _7490))) / ((_7497 * _7497) - (_7491 * _7491)));
                                  _7510 = (_7506 * _7488) + _7424;
                                  _7511 = (_7506 * _7489) + _7425;
                                  _7512 = (_7506 * _7490) + _7426;
                                  _7513 = dot(float3(_7510, _7511, _7512), float3(_7485, _7486, _7487));
                                  _7517 = (_7513 * _7485) - _7510;
                                  _7518 = (_7513 * _7486) - _7511;
                                  _7519 = (_7513 * _7487) - _7512;
                                  _7527 = saturate(0.009999999776482582f / sqrt(((_7517 * _7517) + (_7518 * _7518)) + (_7519 * _7519)));
                                  _7535 = ((_7527 * _7517) + _7510);
                                  _7536 = ((_7527 * _7518) + _7511);
                                  _7537 = ((_7527 * _7519) + _7512);
                                } else {
                                  _7535 = _7424;
                                  _7536 = _7425;
                                  _7537 = _7426;
                                }
                                _7539 = rsqrt(dot(float3(_7535, _7536, _7537), float3(_7535, _7536, _7537)));
                                _7540 = _7539 * _7535;
                                _7541 = _7539 * _7536;
                                _7542 = _7539 * _7537;
                                _7543 = _190 * _190;
                                _7547 = saturate((_6245 * (1.0f - _7543)) * _7539);
                                _7549 = saturate(_7539 * f16tof32(_6188));
                                _7551 = rsqrt(dot(float3(_7418, _7419, _7420), float3(_7418, _7419, _7420)));
                                _7555 = dot(float3(_179, _180, _181), float3(_7540, _7541, _7542));
                                _7556 = dot(float3(_179, _180, _181), float3(_371, _372, _370));
                                _7557 = dot(float3(_371, _372, _370), float3(_7540, _7541, _7542));
                                _7560 = rsqrt((_7557 * 2.0f) + 2.0f);
                                _7567 = (_7547 > 0.0f);
                                if (_7567) {
                                  _7571 = sqrt(1.0f - (_7547 * _7547));
                                  _7573 = (_7555 * 2.0f) * _7556;
                                  _7574 = _7573 - _7557;
                                  if (!(_7574 >= _7571)) {
                                    _7582 = rsqrt(1.0f - (_7574 * _7574)) * _7547;
                                    _7585 = _7582 * (_7556 - (_7574 * _7555));
                                    _7586 = _7556 * _7556;
                                    _7591 = _7582 * (((_7586 * 2.0f) + -1.0f) - (_7574 * _7557));
                                    _7600 = sqrt(saturate((((1.0f - (_7555 * _7555)) - _7586) - (_7557 * _7557)) + (_7573 * _7557)));
                                    _7601 = _7600 * _7582;
                                    _7604 = ((_7556 * 2.0f) * _7582) * _7600;
                                    _7606 = (_7571 * _7555) + _7556;
                                    _7607 = _7606 + _7585;
                                    _7608 = _7571 * _7557;
                                    _7610 = (_7608 + 1.0f) + _7591;
                                    _7611 = _7601 * _7610;
                                    _7612 = _7607 * _7610;
                                    _7613 = _7604 * _7607;
                                    _7618 = (((_7607 * 0.25f) * _7604) - (_7611 * 0.5f)) * _7612;
                                    _7632 = (((_7613 - (_7611 * 2.0f)) * _7613) + (_7611 * _7611)) + ((((-0.5f - ((_7610 + _7608) * 0.5f)) * _7612) + ((_7610 * _7610) * _7606)) * _7607);
                                    _7637 = (_7618 * 2.0f) / ((_7632 * _7632) + (_7618 * _7618));
                                    _7638 = _7632 * _7637;
                                    _7640 = 1.0f - (_7618 * _7637);
                                    _7646 = ((_7638 * _7604) + _7608) + (_7640 * _7591);
                                    _7649 = rsqrt((_7646 * 2.0f) + 2.0f);
                                    _7658 = saturate((_7646 * _7649) + _7649);
                                    _7659 = saturate(((_7606 + (_7638 * _7601)) + (_7640 * _7585)) * _7649);
                                  } else {
                                    _7658 = abs(_7556);
                                    _7659 = 1.0f;
                                  }
                                } else {
                                  _7658 = saturate((_7560 * _7557) + _7560);
                                  _7659 = saturate(_7560 * (_7556 + _7555));
                                }
                                _7660 = saturate(_7475);
                                _7662 = _7543 * _7543;
                                if (_7549 > 0.0f) {
                                  _7672 = saturate(((_7549 * _7549) / ((_7658 * 3.5999999046325684f) + 0.4000000059604645f)) + _7662);
                                } else {
                                  _7672 = _7662;
                                }
                                if (_7567) {
                                  _7681 = (((_7547 * 0.25f) * ((sqrt(_7672) * 3.0f) + _7547)) / (_7658 + 0.0010000000474974513f)) + _7672;
                                  _7684 = _7681;
                                  _7685 = (_7672 / _7681);
                                } else {
                                  _7684 = _7672;
                                  _7685 = 1.0f;
                                }
                                if (_7459 < 1.0f) {
                                  _7692 = sqrt((1.000100016593933f - _7459) / max(9.999999974752427e-07f, (_7459 + 1.0f)));
                                  _7705 = (sqrt(_7684 / ((((_7692 * 0.25f) * ((sqrt(_7684) * 3.0f) + _7692)) / (_7658 + 0.0010000000474974513f)) + _7684)) * _7685);
                                } else {
                                  _7705 = _7685;
                                }
                                _7709 = (((_7672 * _7659) - _7659) * _7659) + 1.0f;
                                _7714 = saturate(abs(_7556) + 9.999999747378752e-06f);
                                _7715 = sqrt(_7672);
                                _7716 = 1.0f - _7715;
                                _7728 = saturate((dot(float3(_179, _180, _181), float3((_7551 * _7418), (_7551 * _7419), (_7551 * _7420))) + _6242) / (_6242 + 1.0f));
                                _7731 = ((_7705 * _7660) * (_7672 / (_7709 * _7709))) * (0.5f / ((((_7716 * _7714) + _7715) * _7660) + (((_7716 * _7660) + _7715) * _7714)));
                                _7732 = _7371 * _1490;
                                _7733 = _7372 * _1490;
                                _7734 = _7373 * _1490;
                                _7741 = ((_7416 * _7732) * _7728) + _1428;
                                _7742 = ((_7416 * _7733) * _7728) + _1429;
                                _7743 = ((_7416 * _7734) * _7728) + _1430;
                                if (_6239 > 0.0f) {
                                  _7752 = (exp2(log2(1.0f - saturate(_7658)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                  _7753 = select(_7413, (_7409 * _1190), _7409) * _6239;
                                  _8238 = _7741;
                                  _8239 = _7742;
                                  _8240 = _7743;
                                  _8241 = (((((_7732 * _1059) * _7753) * _7752) * _7731) + _1431);
                                  _8242 = (((((_7733 * _1059) * _7753) * _7752) * _7731) + _1432);
                                  _8243 = (((((_7734 * _1059) * _7753) * _7752) * _7731) + _1433);
                                } else {
                                  _8238 = _7741;
                                  _8239 = _7742;
                                  _8240 = _7743;
                                  _8241 = _1431;
                                  _8242 = _1432;
                                  _8243 = _1433;
                                }
                              } else {
                                _8238 = _1428;
                                _8239 = _1429;
                                _8240 = _1430;
                                _8241 = _1431;
                                _8242 = _1432;
                                _8243 = _1433;
                              }
                              break;
                            }
                          } else {
                            _8238 = _1428;
                            _8239 = _1429;
                            _8240 = _1430;
                            _8241 = _1431;
                            _8242 = _1432;
                            _8243 = _1433;
                          }
                        } else {
                          if (_1473 == 10) {
                            _7774 = asfloat(srvLightInfoProperties.Load4(_1442)).x;
                            _7775 = asfloat(srvLightInfoProperties.Load4(_1442)).y;
                            _7776 = asfloat(srvLightInfoProperties.Load4(_1442)).z;
                            _7777 = asfloat(srvLightInfoProperties.Load4(_1442)).w;
                            _7780 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).x;
                            _7781 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).y;
                            _7782 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).z;
                            _7783 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 16u)))).w;
                            _7786 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).x;
                            _7787 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).y;
                            _7788 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).z;
                            _7789 = asfloat(srvLightInfoProperties.Load4(((int)(_1442 + 32u)))).w;
                            _7792 = asfloat(srvLightInfoProperties.Load2(((int)(_1442 + 72u)))).x;
                            _7793 = asfloat(srvLightInfoProperties.Load2(((int)(_1442 + 72u)))).y;
                            _7796 = asint(srvLightInfoProperties.Load(((int)(_1442 + 80u))));
                            _7799 = asint(srvLightInfoProperties.Load(((int)(_1442 + 84u))));
                            _7802 = asint(srvLightInfoProperties.Load(((int)(_1442 + 88u))));
                            _7805 = asint(srvLightInfoProperties.Load(((int)(_1442 + 96u))));
                            _7808 = f16tof32(_7796);
                            _7810 = f16tof32(((uint)((uint)(_7799) >> 16)));
                            _7811 = f16tof32(_7799);
                            _7813 = f16tof32(((uint)((uint)(_7802) >> 16)));
                            _7817 = ((float)((uint)((uint)(((uint)(_7802) >> 8) & 255)))) * 0.003921499941498041f;
                            _7819 = (float)((uint)((uint)(_7805 & 65535)));
                            _7823 = mad(_7776, _200, mad(_7775, _199, (_7774 * _198))) + _7777;
                            _7827 = mad(_7782, _200, mad(_7781, _199, (_7780 * _198))) + _7783;
                            _7831 = mad(_7788, _200, mad(_7787, _199, (_7786 * _198))) + _7789;
                            _7834 = mad(_7776, _181, mad(_7775, _180, (_7774 * _179)));
                            _7837 = mad(_7782, _181, mad(_7781, _180, (_7780 * _179)));
                            _7840 = mad(_7788, _181, mad(_7787, _180, (_7786 * _179)));
                            _7852 = -0.0f - mad(_7788, _370, mad(_7787, _372, (_7786 * _371)));
                            _7853 = _7792 * 0.5f;
                            _7854 = _7793 * 0.5f;
                            _7855 = -0.0f - _7853;
                            _7856 = -0.0f - _7854;
                            _7857 = _7855 - _7823;
                            _7858 = _7856 - _7827;
                            _7859 = -0.0f - _7831;
                            _7860 = _7853 - _7823;
                            _7861 = _7854 - _7827;
                            _7862 = dot(float3(_7823, _7827, _7831), float3(_7834, _7837, _7840));
                            _7864 = dot(float3(_7855, _7856, 0.0f), float3(_7834, _7837, _7840)) - _7862;
                            _7866 = dot(float3(_7853, _7856, 0.0f), float3(_7834, _7837, _7840)) - _7862;
                            _7868 = dot(float3(_7853, _7854, 0.0f), float3(_7834, _7837, _7840)) - _7862;
                            _7870 = dot(float3(_7855, _7854, 0.0f), float3(_7834, _7837, _7840)) - _7862;
                            _7871 = min(_7864, _7866);
                            [branch]
                            if (!(!(_7871 >= 0.0f))) {
                              _7877 = rsqrt(dot(float3(_7860, _7858, _7859), float3(_7860, _7858, _7859)) * dot(float3(_7857, _7858, _7859), float3(_7857, _7858, _7859)));
                              _7879 = dot(float3(_7857, _7858, _7859), float3(_7860, _7858, _7859)) * _7877;
                              _7886 = rsqrt(max(((((_7879 * 0.09300000220537186f) + 0.5f) * _7879) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7877;
                              _7893 = (_7886 * (_7792 * _7859));
                              _7894 = (_7886 * (_7858 * (_7855 - _7853)));
                            } else {
                              _7893 = 0.0f;
                              _7894 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_7866, _7868) >= 0.0f))) {
                              _7901 = rsqrt(dot(float3(_7860, _7861, _7859), float3(_7860, _7861, _7859)) * dot(float3(_7860, _7858, _7859), float3(_7860, _7858, _7859)));
                              _7903 = dot(float3(_7860, _7858, _7859), float3(_7860, _7861, _7859)) * _7901;
                              _7910 = rsqrt(max(((((_7903 * 0.09300000220537186f) + 0.5f) * _7903) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7901;
                              _7918 = (_7910 * ((_7856 - _7854) * _7859));
                              _7919 = ((_7910 * (_7793 * _7860)) + _7894);
                            } else {
                              _7918 = 0.0f;
                              _7919 = _7894;
                            }
                            _7920 = min(_7868, _7870);
                            [branch]
                            if (!(!(_7920 >= 0.0f))) {
                              _7926 = rsqrt(dot(float3(_7857, _7861, _7859), float3(_7857, _7861, _7859)) * dot(float3(_7860, _7861, _7859), float3(_7860, _7861, _7859)));
                              _7928 = dot(float3(_7860, _7861, _7859), float3(_7857, _7861, _7859)) * _7926;
                              _7935 = rsqrt(max(((((_7928 * 0.09300000220537186f) + 0.5f) * _7928) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7926;
                              _7944 = ((_7935 * ((_7855 - _7853) * _7859)) + _7893);
                              _7945 = ((_7935 * (_7792 * _7861)) + _7919);
                            } else {
                              _7944 = _7893;
                              _7945 = _7919;
                            }
                            [branch]
                            if (!(!(min(_7870, _7864) >= 0.0f))) {
                              _7952 = rsqrt(dot(float3(_7857, _7858, _7859), float3(_7857, _7858, _7859)) * dot(float3(_7857, _7861, _7859), float3(_7857, _7861, _7859)));
                              _7954 = dot(float3(_7857, _7861, _7859), float3(_7857, _7858, _7859)) * _7952;
                              _7961 = rsqrt(max(((((_7954 * 0.09300000220537186f) + 0.5f) * _7954) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7952;
                              _7970 = ((_7961 * (_7793 * _7859)) + _7918);
                              _7971 = ((_7961 * (_7857 * (_7856 - _7854))) + _7945);
                            } else {
                              _7970 = _7918;
                              _7971 = _7945;
                            }
                            if (min(_7871, _7920) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_7864, _7866), max(_7868, _7870)) >= 0.0f))) {
                                _7980 = -0.0f - _7834;
                                _7981 = _7862 / _7837;
                                _7982 = _7855 / _7837;
                                _7983 = _7853 / _7837;
                                _7985 = (_7856 - _7981) / _7980;
                                _7987 = (_7854 - _7981) / _7980;
                                _7988 = min(_7982, _7983);
                                _7989 = max(_7982, _7983);
                                _7990 = min(_7985, _7987);
                                _7991 = max(_7985, _7987);
                                _7992 = max(_7988, _7990);
                                _7993 = min(_7989, _7991);
                                _7994 = _7992 * _7837;
                                _7996 = _7993 * _7837;
                                _7998 = _7994 - _7823;
                                _7999 = _7981 - _7827;
                                _8000 = _7999 + (_7992 * _7980);
                                _8001 = _7996 - _7823;
                                _8002 = _7999 + (_7993 * _7980);
                                _8003 = dot(float3(_7998, _8000, _7859), float3(_7998, _8000, _7859));
                                _8004 = dot(float3(_8001, _8002, _7859), float3(_8001, _8002, _7859));
                                _8006 = rsqrt(_8004 * _8003);
                                _8008 = dot(float3(_7998, _8000, _7859), float3(_8001, _8002, _7859)) * _8006;
                                _8015 = rsqrt(max(((((_8008 * 0.09300000220537186f) + 0.5f) * _8008) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8006;
                                _8028 = (_7988 > _7990);
                                _8030 = select(_8028, _7837, _7834);
                                _8036 = float((int)(((int)(uint)((int)(_8030 > 0.0f))) - ((int)(uint)((int)(_8030 < 0.0f)))));
                                _8040 = ((1.0f - (((float)((bool)_8028)) * 2.0f)) * _7853) * _8036;
                                _8042 = _8040 - _7823;
                                _8043 = (_8036 * _7854) - _7827;
                                _8044 = (_7989 < _7991);
                                _8046 = select(_8044, _7837, _7834);
                                _8052 = float((int)(((int)(uint)((int)(_8046 > 0.0f))) - ((int)(uint)((int)(_8046 < 0.0f)))));
                                _8053 = _8052 * _7853;
                                _8058 = _8053 - _7823;
                                _8059 = ((((((float)((bool)_8044)) * 2.0f) + -1.0f) * _7854) * _8052) - _7827;
                                _8062 = rsqrt(_8003 * dot(float3(_8042, _8043, _7859), float3(_8042, _8043, _7859)));
                                _8064 = dot(float3(_8042, _8043, _7859), float3(_7998, _8000, _7859)) * _8062;
                                _8071 = rsqrt(max(((((_8064 * 0.09300000220537186f) + 0.5f) * _8064) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8062;
                                _8084 = rsqrt(dot(float3(_8058, _8059, _7859), float3(_8058, _8059, _7859)) * _8004);
                                _8086 = dot(float3(_8001, _8002, _7859), float3(_8058, _8059, _7859)) * _8084;
                                _8093 = rsqrt(max(((((_8086 * 0.09300000220537186f) + 0.5f) * _8086) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8084;
                                _8114 = ((((_8015 * (((_7992 - _7993) * _7980) * _7859)) + _7970) + (_8071 * ((_8043 - _8000) * _7859))) + (_8093 * ((_8002 - _8059) * _7859)));
                                _8115 = ((((_8015 * ((_7837 * (_7993 - _7992)) * _7859)) + _7944) + (_8071 * ((_7994 - _8040) * _7859))) + (_8093 * ((_8053 - _7996) * _7859)));
                                _8116 = ((((_8015 * ((_8002 * _7998) - (_8001 * _8000))) + _7971) + (_8071 * ((_8042 * _8000) - (_8043 * _7998)))) + (_8093 * ((_8059 * _8001) - (_8058 * _8002))));
                              } else {
                                _8114 = _7970;
                                _8115 = _7944;
                                _8116 = _7971;
                              }
                            } else {
                              _8114 = _7970;
                              _8115 = _7944;
                              _8116 = _7971;
                            }
                            _8122 = sqrt(((_8115 * _8115) + (_8114 * _8114)) + (_8116 * _8116));
                            _8123 = _8122 * 0.15915493667125702f;
                            [branch]
                            if (!(_8123 == 0.0f)) {
                              _8132 = saturate((_8123 - _7808) / (1.0f - _7808)) * ((float)((bool)(uint)(_7831 <= 0.0f)));
                              [branch]
                              if (!(_8132 == 0.0f)) {
                                if (_8122 > 0.0f) {
                                  _8140 = (dot(float3(_7834, _7837, _7840), float3(_8114, _8115, _8116)) / _8122);
                                } else {
                                  _8140 = 0.0f;
                                }
                                _8141 = 1.0f - _190;
                                _8146 = min(_190, 0.800000011920929f);
                                _8155 = exp2(((((((_8146 * 3.322999954223633f) + -3.7669999599456787f) * _8146) + -0.3479999899864197f) * _8146) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _8162 = _7859 / (_7852 - ((_7840 * 2.0f) * dot(float3((-0.0f - mad(_7776, _370, mad(_7775, _372, (_7774 * _371)))), (-0.0f - mad(_7782, _370, mad(_7781, _372, (_7780 * _371)))), _7852), float3(_7834, _7837, _7840))));
                                _8165 = (_8162 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8155) * saturate((_190 + -0.5f) * 2.500000238418579f)) + _8155);
                                _8173 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7819), ((log2((_8165 * _8165) * f16tof32(((uint)((uint)(_7796) >> 16)))) * 0.5f) + 5.5f));
                                _8175 = (float)((bool)(uint)(_8162 > 0.0f));
                                _8176 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7819), 10.0f);
                                _8185 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8132 * _1190), _8132);
                                if (_7817 > 0.0f) {
                                  _8201 = ((max((_8141 * _8141), 0.03999999910593033f) + -0.03999999910593033f) * exp2(log2(1.0f - saturate(dot(float3(_179, _180, _181), float3(_371, _372, _370)))) * 5.0f)) + 0.03999999910593033f;
                                  _8202 = _8185 * _1490;
                                  _8222 = ((((((_7817 * _7810) * _8175) * _8173.x) * _8202) * _8201) + _1431);
                                  _8223 = ((((((_7811 * _7817) * _8175) * _8173.y) * _8202) * _8201) + _1432);
                                  _8224 = ((((((_7813 * _7817) * _8175) * _8173.z) * _8202) * _8201) + _1433);
                                } else {
                                  _8222 = _1431;
                                  _8223 = _1432;
                                  _8224 = _1433;
                                }
                                _8230 = ((_1490 * 5.4256415367126465f) * _8140) * _8185;
                                _8238 = (((_8176.x * _7810) * _8230) + _1428);
                                _8239 = (((_8176.y * _7811) * _8230) + _1429);
                                _8240 = (((_8176.z * _7813) * _8230) + _1430);
                                _8241 = _8222;
                                _8242 = _8223;
                                _8243 = _8224;
                              } else {
                                _8238 = _1428;
                                _8239 = _1429;
                                _8240 = _1430;
                                _8241 = _1431;
                                _8242 = _1432;
                                _8243 = _1433;
                              }
                            } else {
                              _8238 = _1428;
                              _8239 = _1429;
                              _8240 = _1430;
                              _8241 = _1431;
                              _8242 = _1432;
                              _8243 = _1433;
                            }
                          } else {
                            _8238 = _1428;
                            _8239 = _1429;
                            _8240 = _1430;
                            _8241 = _1431;
                            _8242 = _1432;
                            _8243 = _1433;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _8238 = _1428;
              _8239 = _1429;
              _8240 = _1430;
              _8241 = _1431;
              _8242 = _1432;
              _8243 = _1433;
            }
          } else {
            _8238 = _1428;
            _8239 = _1429;
            _8240 = _1430;
            _8241 = _1431;
            _8242 = _1432;
            _8243 = _1433;
          }
          _8244 = _1434 + 1u;
          if (!(_8244 == _global_2)) {
            _1428 = _8238;
            _1429 = _8239;
            _1430 = _8240;
            _1431 = _8241;
            _1432 = _8242;
            _1433 = _8243;
            _1434 = _8244;
            continue;
          }
          _8248 = _8238;
          _8249 = _8239;
          _8250 = _8240;
          _8251 = _8241;
          _8252 = _8242;
          _8253 = _8243;
          break;
        }
      } else {
        _8248 = _1311;
        _8249 = _1312;
        _8250 = _1313;
        _8251 = _1192;
        _8252 = _1194;
        _8253 = _1196;
      }
      _8255 = rsqrt(dot(float3(_133, _134, -1.0f), float3(_133, _134, -1.0f)));
      _8262 = 1.0f - _190;
      _8272 = 0.9599999785423279f - (exp2(log2(1.0f - saturate(saturate(dot(float3(_179, _180, _181), float3((-0.0f - (_133 * _8255)), (-0.0f - (_134 * _8255)), _8255))))) * 5.0f) * (max((_8262 * _8262), 0.03999999910593033f) + -0.03999999910593033f));
      _8412 = (_8272 * _8248);
      _8413 = (_8272 * _8249);
      _8414 = (_8272 * _8250);
      _8415 = _8251;
      _8416 = _8252;
      _8417 = _8253;
      _8418 = saturate(_141.x);
      _8419 = saturate(_141.y);
      _8420 = saturate(_141.z);
    } else {
      _8291 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _134, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _133)));
      _8294 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _134, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _133)));
      _8297 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _134, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _133)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _8401 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _8402 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _8403 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _8318 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8291, _8294, _8297), 0.0f);
        _8322 = _8318.x * 32.0f;
        _8323 = _8318.y * 32.0f;
        _8324 = _8318.z * 32.0f;
        _8326 = rsqrt(dot(float3(_8291, _8294, _8297), float3(_8291, _8294, _8297)));
        _8327 = _8326 * _8291;
        _8328 = _8326 * _8294;
        _8329 = _8326 * _8297;
        _8330 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _8331 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _8332 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _8333 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _8334 = dot(float3(_8327, _8328, _8329), float3(_8331, _8332, _8333));
        _8339 = (_8334 * _8334) - (dot(float3(_8331, _8332, _8333), float3(_8331, _8332, _8333)) - (_8330 * _8330));
        if ((_8334 > -0.0f) && (_8339 > 0.0f)) {
          _8344 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _8357 = 74.80000305175781f / ((dot(float3(_8327, _8328, _8329), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8330) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _8365 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8327, _8329), float2(_8344, cbDeferredShading.vSunDirWS.x)) * _8357) + 0.5f), ((dot(float3(_8327, _8328, _8329), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8344)), (cbDeferredShading.vSunDirWS.y * _8344))) * _8357) + 0.5f)), 0.0f);
          _8367 = _8339 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_8367 > 0.0f) {
            _8374 = saturate(_8367 * 5.0f);
            _8401 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8365.x) * _8374) + _8322);
            _8402 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8365.y) * _8374) + _8323);
            _8403 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8365.z) * _8374) + _8324);
          } else {
            _8401 = _8322;
            _8402 = _8323;
            _8403 = _8324;
          }
        } else {
          _8401 = _8322;
          _8402 = _8323;
          _8403 = _8324;
        }
      }
      _8407 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _8412 = 0.0f;
      _8413 = 0.0f;
      _8414 = 0.0f;
      _8415 = select(_8407, 0.0f, _8401);
      _8416 = select(_8407, 0.0f, _8402);
      _8417 = select(_8407, 0.0f, _8403);
      _8418 = 0.0f;
      _8419 = 0.0f;
      _8420 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_62, _63)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_8418 * _8412) + _8415)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_8419 * _8413) + _8416)), 7936.0f), 5.960464477539063e-08f), max(min((((_8420 * _8414) + _8417) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_62, _63)] = float3(0.0f, 0.0f, 0.0f);
  }
}