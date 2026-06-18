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

struct S_cbSkinFeatures {
  uint maxIndex;
  uint _pad_0;
  uint _pad_1;
  uint _pad_2;
  uint4 skinParams[128];
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

StructuredBuffer<uint> srvDeferredClusters : register(t46);

StructuredBuffer<uint4> srvFallbackInfo : register(t29);

StructuredBuffer<uint4> srvRoomInfo : register(t84);

Texture2DArray<float4> srvBillboardArray : register(t16);

Texture2D<float4> srvPreintegratedGGXLUT : register(t110);

Texture2D<float4> srvBlurredGbufNormal : register(t95);

TextureCubeArray<float4> srvBoxReflectionCube : register(t21);

TextureCubeArray<float4> srvBoxReflectionCube2 : register(t24);

StructuredBuffer<float3> srvBoxReflectionSH : register(t25);

StructuredBuffer<SCSLightData> srvLightIndexData : register(t86);

StructuredBuffer<uint> srvLightMappingData : register(t87);

Texture2D<uint> srvScreenSpaceContactLocalShadowMask : register(t88);

Texture2D<float> srvContactShadowsCSMMask : register(t89);

Texture2D<float2> srvDeferredShadingEvaluateAdaptationPass_DeferredShadows : register(t0);

Texture2D<float4> srvDeferredShadingEvaluateAdaptationPass_SoftShadowsMask : register(t1);

TextureCube<float4> srvDeferredShadingEvaluateAdaptationPass_BackdropCube : register(t2);

Texture2D<float4> srvDeferredShadingEvaluateAdaptationPass_SunDisc : register(t3);

RWTexture2D<float3> uavDeferredShadingEvaluateAdaptationPass_Luminance : register(u0);

cbuffer cbBindless : register(b0, space2) {
  SMaterialBindlessOffset cbBindless : packoffset(c000.x);
};

cbuffer _cbSharedPerViewData : register(b2) {
  S_cbSharedPerViewData cbSharedPerViewData : packoffset(c000.x);
};

cbuffer _cbDeferredShading : register(b4) {
  S_cbDeferredShading cbDeferredShading : packoffset(c000.x);
};

cbuffer _cbSkinFeatures : register(b5) {
  float4 _cbSkinFeatures_raw[129] : packoffset(c0);
  uint4 _cbSkinFeatures_raw_uint[129] : packoffset(c0);
};

SamplerState samplerPointClampNode : register(s0);

SamplerState samplerPointBorderWhiteNode : register(s3);

SamplerState samplerLinearClampNode : register(s4);

SamplerState samplerLinearWrapNode : register(s5);

SamplerState samplerLinearBorderBlackNode : register(s6);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

static const float _global_0[128] = { 1.0f, 0.0f, -0.7373688817024231f, 0.6754903197288513f, 0.08742572367191315f, -0.9961710572242737f, 0.6084388494491577f, 0.7936007380485535f, -0.9847134947776794f, -0.1741819530725479f, 0.843755304813385f, -0.536728024482727f, -0.2596043050289154f, 0.9657150506973267f, -0.4609070122241974f, -0.8874484300613403f, 0.9393212795257568f, 0.3430386185646057f, -0.9243455529212952f, 0.3815564215183258f, 0.4238460063934326f, -0.9057343006134033f, 0.29928386211395264f, 0.9541641473770142f, -0.8652111887931824f, -0.5014075636863708f, 0.9766757488250732f, -0.21471942961215973f, -0.5751294493675232f, 0.818062424659729f, -0.12851068377494812f, -0.9917080998420715f, 0.764648973941803f, 0.6444469690322876f, -0.999146044254303f, 0.04131782799959183f, 0.708829402923584f, -0.7053799629211426f, -0.04619144648313522f, 0.9989326000213623f, -0.6407091617584229f, -0.7677837014198303f, 0.9910694360733032f, 0.13334698975086212f, -0.820858359336853f, 0.5711318254470825f, 0.21948136389255524f, -0.9756166934967041f, 0.49718087911605835f, 0.8676469326019287f, -0.9526928067207336f, -0.3039349913597107f, 0.9077911376953125f, -0.41942253708839417f, -0.38606107234954834f, 0.9224731922149658f, -0.3384522795677185f, -0.9409835338592529f, 0.885189414024353f, 0.4652307629585266f, -0.9669700264930725f, 0.25489020347595215f, 0.5408377647399902f, -0.8411269187927246f, 0.1693761795759201f, 0.9855514764785767f, -0.7906231880187988f, -0.6123030185699463f, 0.9965856671333313f, -0.08256508409976959f, -0.6790793538093567f, 0.7340648770332336f, 0.004878276959061623f, -0.9999880790710449f, 0.6718851923942566f, 0.7406553626060486f, -0.9957327246665955f, -0.09228428453207016f, 0.7965594530105591f, -0.6045601963996887f, -0.17898358404636383f, 0.9838520884513855f, -0.5326055884361267f, -0.8463635444641113f, 0.9644371867179871f, 0.2643122375011444f, -0.8896862864494324f, 0.4565723240375519f, 0.3476168215274811f, -0.93763667345047f, 0.37704265117645264f, 0.9261959195137024f, -0.9036558866500854f, -0.42825937271118164f, 0.9556127786636353f, -0.2946256399154663f, -0.5056223273277283f, 0.8627548813819885f, -0.20995238423347473f, -0.9777116179466248f, 0.8152470588684082f, 0.5791133046150208f, -0.9923232197761536f, 0.12367133051156998f, 0.6481694579124451f, -0.7614961266517639f, 0.03644322231411934f, 0.9993357062339783f, -0.7019136548042297f, -0.7122620344161987f, 0.9986953735351562f, 0.05106396600604057f, -0.7709001302719116f, 0.6369560360908508f, 0.13818010687828064f, -0.9904071092605591f, 0.5671206712722778f, 0.823634684085846f, -0.9745343923568726f, -0.2242380827665329f, 0.870061993598938f, -0.49294233322143555f, -0.30857884883880615f, 0.9511987566947937f, -0.41498908400535583f, -0.909826397895813f, 0.9205789566040039f, 0.39055657386779785f };

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _58;
  float _59;
  uint _65;
  uint _66;
  float4 _68;
  float _169;
  float _170;
  float _201;
  float _202;
  float _203;
  float _204;
  float _205;
  float _206;
  float _207;
  float _217;
  int _218;
  float _219;
  float _257;
  int _258;
  int _259;
  int _260;
  int _261;
  int _262;
  float _263;
  float _264;
  float _265;
  int _434;
  float _435;
  float _436;
  float _437;
  float _438;
  float _439;
  float _440;
  float _441;
  float _442;
  float _564;
  float _565;
  float _566;
  float _653;
  float _654;
  float _655;
  float _681;
  float _682;
  float _683;
  float _684;
  float _695;
  float _696;
  float _697;
  float _698;
  float _699;
  float _700;
  float _701;
  float _702;
  float _707;
  float _708;
  float _709;
  float _710;
  float _711;
  float _712;
  float _713;
  float _714;
  float _763;
  float _764;
  float _765;
  float _773;
  float _774;
  float _775;
  float _778;
  float _779;
  float _780;
  float _781;
  float _792;
  float _793;
  float _794;
  float _823;
  float _824;
  float _825;
  float _833;
  float _834;
  float _835;
  float _848;
  float _849;
  float _850;
  float _855;
  float _856;
  float _857;
  int _888;
  float _889;
  float _1014;
  float _1019;
  float _1034;
  float _1048;
  float _1098;
  float _1099;
  float _1100;
  float _1153;
  float _1154;
  float _1155;
  float _1268;
  float _1274;
  float _1275;
  float _1276;
  float _1277;
  float _1278;
  float _1279;
  int _1280;
  float _1921;
  float _1922;
  float _1923;
  float _2014;
  float _2023;
  float _2032;
  float _2040;
  float _2111;
  float _2120;
  float _2129;
  float _2137;
  float _2210;
  float _2219;
  float _2228;
  float _2236;
  float _2309;
  float _2318;
  float _2327;
  float _2335;
  float _2387;
  float _2392;
  float _2393;
  float _2490;
  float _2495;
  float _2496;
  float _2497;
  float _2518;
  float _2519;
  float _2520;
  int _2540;
  float _2557;
  float _2561;
  float _2567;
  float _2609;
  float _2610;
  float _2642;
  float _2668;
  float _2669;
  float _2670;
  float _2774;
  float _2775;
  float _2789;
  float _2801;
  float _3051;
  float _3259;
  float _3271;
  float _3282;
  float _3294;
  float _3427;
  float _3449;
  float _3463;
  float _3476;
  float _3490;
  float _3503;
  float _3714;
  float _3715;
  float _3847;
  float _3848;
  float _3857;
  float _3869;
  float _3898;
  bool _3899;
  float _3917;
  float _3918;
  float _3919;
  float _3920;
  float _3921;
  float _3922;
  float _3948;
  float _4039;
  float _4040;
  float _4041;
  float _4070;
  float _4098;
  float _4099;
  float _4100;
  float _4204;
  float _4205;
  float _4219;
  float _4231;
  float _4681;
  float _4693;
  float _4704;
  float _4716;
  float _4849;
  float _4871;
  float _4885;
  float _4898;
  float _4912;
  float _4925;
  float _5136;
  float _5137;
  float _5269;
  float _5270;
  float _5279;
  float _5291;
  float _5320;
  bool _5321;
  float _5339;
  float _5340;
  float _5341;
  float _5342;
  float _5343;
  float _5344;
  float _5367;
  float _5368;
  float _5369;
  float _5400;
  float _5429;
  float _5430;
  float _5431;
  float _5447;
  float _5448;
  float _5449;
  float _5462;
  float _5463;
  float _5464;
  float _5484;
  float _5647;
  float _5648;
  float _5649;
  float _5650;
  float _5651;
  float _5652;
  float _5752;
  float _5753;
  float _5754;
  float _5755;
  float _5756;
  float _5860;
  float _5869;
  float _5878;
  float _5886;
  float _5957;
  float _5966;
  float _5975;
  float _5983;
  float _6056;
  float _6065;
  float _6074;
  float _6082;
  float _6155;
  float _6164;
  float _6173;
  float _6181;
  float _6517;
  float _6518;
  float _6519;
  int _6520;
  float _6521;
  float _6550;
  float _6551;
  float _6552;
  float _6553;
  float _6554;
  float _6657;
  float _6666;
  float _6675;
  float _6683;
  float _6754;
  float _6763;
  float _6772;
  float _6780;
  float _6853;
  float _6862;
  float _6871;
  float _6879;
  float _6952;
  float _6961;
  float _6970;
  float _6978;
  float _7313;
  float _7314;
  bool _7315;
  float _7333;
  float _7334;
  float _7335;
  float _7336;
  float _7394;
  float _7395;
  float _7420;
  float _7421;
  float _7516;
  float _7522;
  float _7523;
  float _7524;
  float _7525;
  float _7526;
  float _7546;
  float _7547;
  float _7548;
  int _7567;
  float _7584;
  float _7588;
  float _7614;
  float _7615;
  float _7616;
  float _7647;
  float _7676;
  float _7677;
  float _7678;
  float _7694;
  float _7695;
  float _7696;
  float _7697;
  float _7739;
  float _7740;
  float _7789;
  float _7790;
  float _7791;
  float _7807;
  float _7867;
  float _7868;
  float _7869;
  float _7906;
  float _7907;
  float _7908;
  float _8012;
  float _8013;
  float _8028;
  float _8040;
  float _8041;
  float _8061;
  float _8312;
  float _8521;
  float _8533;
  float _8534;
  float _8553;
  float _8564;
  float _8576;
  float _8577;
  float _8596;
  float _8729;
  float _8751;
  float _8765;
  float _8778;
  float _8792;
  float _8805;
  float _9023;
  float _9024;
  float _9156;
  float _9157;
  float _9166;
  float _9178;
  float _9179;
  float _9198;
  float _9228;
  bool _9229;
  float _9247;
  float _9248;
  float _9249;
  float _9250;
  float _9251;
  float _9252;
  float _9397;
  float _9398;
  float _9428;
  float _9429;
  float _9430;
  float _10015;
  float _10037;
  float _10051;
  float _10064;
  float _10078;
  float _10091;
  float _10302;
  float _10303;
  float _10363;
  bool _10364;
  float _10382;
  float _10383;
  float _10384;
  float _10385;
  float _10386;
  float _10387;
  float _10914;
  float _10915;
  float _10916;
  float _11007;
  float _11016;
  float _11025;
  float _11033;
  float _11104;
  float _11113;
  float _11122;
  float _11130;
  float _11203;
  float _11212;
  float _11221;
  float _11229;
  float _11302;
  float _11311;
  float _11320;
  float _11328;
  float _11380;
  float _11385;
  float _11386;
  float _11483;
  float _11488;
  float _11489;
  float _11490;
  float _11511;
  float _11512;
  float _11513;
  int _11533;
  float _11550;
  float _11558;
  float _11584;
  float _11585;
  float _11586;
  float _11617;
  float _11646;
  float _11647;
  float _11648;
  float _11664;
  float _11665;
  float _11666;
  float _11667;
  float _11709;
  float _11710;
  float _11758;
  float _11759;
  float _11760;
  float _11776;
  float _11836;
  float _11837;
  float _11838;
  float _11875;
  float _11876;
  float _11877;
  float _11981;
  float _11982;
  float _11997;
  float _12009;
  float _12010;
  float _12030;
  float _12281;
  float _12490;
  float _12502;
  float _12503;
  float _12522;
  float _12533;
  float _12545;
  float _12546;
  float _12565;
  float _12698;
  float _12720;
  float _12734;
  float _12747;
  float _12761;
  float _12774;
  float _12992;
  float _12993;
  float _13125;
  float _13126;
  float _13135;
  float _13147;
  float _13148;
  float _13167;
  float _13197;
  bool _13198;
  float _13216;
  float _13217;
  float _13218;
  float _13219;
  float _13220;
  float _13221;
  float _13371;
  float _13372;
  float _13396;
  float _13397;
  float _13422;
  float _13423;
  float _13448;
  float _13449;
  float _13592;
  float _13593;
  float _13594;
  float _13618;
  float _13713;
  float _13714;
  float _13715;
  float _13729;
  float _13730;
  float _13731;
  float _13732;
  float _13733;
  float _13734;
  float _13739;
  float _13740;
  float _13741;
  float _13742;
  float _13743;
  float _13744;
  float _13913;
  float _13914;
  float _13915;
  float _13988;
  float _14002;
  float _14003;
  float _14004;
  float _14005;
  float _14073;
  float _14074;
  float _14075;
  float _14095;
  float _14096;
  float _14097;
  float4 _85;
  float4 _89;
  float4 _95;
  float4 _101;
  float4 _107;
  float _113;
  float _114;
  float _115;
  float _117;
  float _118;
  float _119;
  float _122;
  float _123;
  float _130;
  float _131;
  float _135;
  float _137;
  float _138;
  float _143;
  float _144;
  float _146;
  float _147;
  float _148;
  float _149;
  uint _154;
  float _159;
  bool _162;
  bool _171;
  float _172;
  float _173;
  float _174;
  bool _187;
  bool _191;
  float _209;
  bool _212;
  float _220;
  float _223;
  uint _227;
  float _230;
  float4 _267;
  float _272;
  float _273;
  float _277;
  float _279;
  float _280;
  float _285;
  float _286;
  float _288;
  float _289;
  float _290;
  float _291;
  float _292;
  float _296;
  float _297;
  float _305;
  float _306;
  float _312;
  float _313;
  float _314;
  float _315;
  float _318;
  float _319;
  float _321;
  float _322;
  float _323;
  int _329;
  int _330;
  int _331;
  int _332;
  float _336;
  float _338;
  float _339;
  uint _346;
  int _349;
  int _350;
  int _351;
  int _352;
  int _353;
  float _361;
  float _366;
  float _370;
  float _371;
  float _374;
  float _387;
  float _388;
  float _389;
  float _393;
  float _408;
  float _411;
  float _414;
  int _447;
  int _448;
  int _451;
  int _453;
  float _456;
  float _457;
  float _458;
  float _459;
  float _462;
  float _463;
  float _464;
  float _465;
  float _468;
  float _469;
  float _470;
  float _471;
  float _474;
  float _475;
  float _476;
  float _477;
  float _480;
  float _481;
  float _482;
  float _483;
  float _486;
  float _487;
  float _488;
  float _489;
  int _492;
  float _495;
  float _496;
  float _497;
  float _500;
  float _501;
  float _502;
  int _505;
  int _508;
  int _511;
  float _540;
  float _543;
  float _546;
  float _547;
  float4 _553;
  float4 _559;
  float _568;
  float _572;
  float _575;
  float _578;
  float _619;
  float _624;
  float _626;
  float _628;
  float _635;
  float _636;
  float4 _642;
  float4 _648;
  float _668;
  float _669;
  float _670;
  int _703;
  bool _720;
  int _730;
  float _732;
  float _733;
  float _740;
  float _745;
  float _746;
  float4 _752;
  float4 _758;
  float _787;
  int _801;
  float _802;
  float _805;
  float _806;
  float4 _812;
  float4 _818;
  float _840;
  float _859;
  float4 _862;
  float _865;
  float _866;
  float _870;
  float _874;
  float _875;
  float _876;
  float _883;
  int _895;
  int _896;
  int _899;
  int _901;
  int _905;
  int _909;
  float _921;
  float _926;
  float _927;
  float _928;
  float _929;
  float _932;
  float _933;
  float _934;
  float _935;
  float _938;
  float _939;
  float _940;
  float _941;
  int _944;
  int _947;
  int _950;
  int _953;
  float _968;
  float _972;
  float _976;
  float _1001;
  float _1002;
  float _1003;
  float _1006;
  int _1015;
  float _1037;
  float _1040;
  float _1043;
  int _1051;
  int _1054;
  int _1055;
  int _1056;
  int _1062;
  int _1063;
  int _1064;
  int _1070;
  int _1071;
  int _1072;
  float _1078;
  float _1082;
  float _1086;
  float _1093;
  int _1103;
  int _1106;
  int _1107;
  int _1108;
  int _1114;
  int _1115;
  int _1116;
  int _1122;
  int _1123;
  int _1124;
  float _1130;
  float _1134;
  float _1138;
  float _1145;
  float _1181;
  float _1185;
  float _1189;
  float _1208;
  float _1212;
  float _1216;
  float _1229;
  float _1230;
  float _1231;
  int _1269;
  int _1285;
  int _1286;
  int _1289;
  int _1291;
  int _1293;
  int _1305;
  int _1309;
  float _1321;
  int _1324;
  float _1341;
  float _1346;
  float _1347;
  float _1348;
  float _1349;
  float _1352;
  float _1353;
  float _1354;
  float _1355;
  float _1358;
  float _1359;
  float _1360;
  float _1361;
  int _1364;
  int _1367;
  int _1370;
  int _1373;
  int _1376;
  float _1378;
  float _1379;
  float _1381;
  float _1385;
  float _1398;
  float _1402;
  float _1406;
  float _1431;
  float _1432;
  float _1433;
  float _1436;
  float _1437;
  float _1444;
  float _1465;
  float _1466;
  float _1467;
  float _1468;
  float _1471;
  float _1472;
  float _1473;
  float _1474;
  float _1477;
  float _1478;
  float _1479;
  float _1480;
  float _1483;
  float _1484;
  float _1485;
  float _1488;
  int _1491;
  int _1494;
  int _1497;
  int _1500;
  int _1503;
  float _1506;
  float _1507;
  float _1508;
  float _1509;
  int _1512;
  int _1515;
  int _1518;
  int _1521;
  int _1524;
  int _1527;
  int _1530;
  int _1533;
  int _1536;
  float _1538;
  float _1539;
  float _1541;
  float _1545;
  float _1548;
  float _1550;
  int _1553;
  bool _1559;
  float _1570;
  float _1571;
  float _1572;
  float _1573;
  bool _1593;
  bool _1595;
  bool _1596;
  float _1600;
  float _1604;
  float _1605;
  float _1606;
  float _1610;
  float _1614;
  float _1618;
  float _1619;
  float _1642;
  float _1643;
  float _1644;
  float _1647;
  float _1648;
  float _1655;
  float _1656;
  float _1657;
  float _1662;
  float _1664;
  float _1665;
  float _1668;
  float _1669;
  float _1673;
  float _1682;
  float _1683;
  float _1684;
  int _1685;
  float _1690;
  float _1699;
  float _1700;
  float _1702;
  float4 _1707;
  float _1712;
  float _1714;
  float _1716;
  float _1718;
  float _1722;
  float _1724;
  float _1728;
  float _1730;
  int _1737;
  float _1742;
  float _1751;
  float _1752;
  float4 _1758;
  float _1763;
  float _1765;
  float _1769;
  float _1771;
  float _1775;
  float _1777;
  float _1781;
  float _1783;
  int _1790;
  float _1795;
  float _1804;
  float _1805;
  float4 _1811;
  float _1816;
  float _1818;
  float _1822;
  float _1824;
  float _1828;
  float _1830;
  float _1834;
  float _1836;
  int _1843;
  float _1848;
  float _1857;
  float _1858;
  float4 _1864;
  float _1869;
  float _1871;
  float _1875;
  float _1877;
  float _1881;
  float _1883;
  float _1887;
  float _1889;
  float _1890;
  float _1901;
  float _1907;
  float _1909;
  float _1911;
  float _1918;
  float _1926;
  float _1927;
  float _1934;
  float _1937;
  float _1941;
  float _1950;
  float _1951;
  float _1952;
  float _1957;
  int _1958;
  float _1963;
  float _1972;
  float _1973;
  float _1975;
  float _1977;
  float _1978;
  float4 _1980;
  float _1984;
  float _1985;
  float _1988;
  float _1989;
  float _1994;
  float _1995;
  float _1998;
  float _1999;
  float _2001;
  float _2003;
  bool _2004;
  bool _2005;
  bool _2015;
  bool _2024;
  float _2041;
  float _2043;
  float _2045;
  float _2047;
  float _2051;
  float _2053;
  float _2057;
  float _2059;
  int _2066;
  float _2071;
  float _2080;
  float _2081;
  float _2084;
  float _2085;
  float4 _2087;
  float _2091;
  float _2092;
  float _2095;
  float _2096;
  float _2098;
  float _2100;
  bool _2101;
  bool _2102;
  bool _2112;
  bool _2121;
  float _2138;
  float _2140;
  float _2144;
  float _2146;
  float _2150;
  float _2152;
  float _2156;
  float _2158;
  int _2165;
  float _2170;
  float _2179;
  float _2180;
  float _2183;
  float _2184;
  float4 _2186;
  float _2190;
  float _2191;
  float _2194;
  float _2195;
  float _2197;
  float _2199;
  bool _2200;
  bool _2201;
  bool _2211;
  bool _2220;
  float _2237;
  float _2239;
  float _2243;
  float _2245;
  float _2249;
  float _2251;
  float _2255;
  float _2257;
  int _2264;
  float _2269;
  float _2278;
  float _2279;
  float _2282;
  float _2283;
  float4 _2285;
  float _2289;
  float _2290;
  float _2293;
  float _2294;
  float _2296;
  float _2298;
  bool _2299;
  bool _2300;
  bool _2310;
  bool _2319;
  float _2336;
  float _2338;
  float _2342;
  float _2344;
  float _2348;
  float _2350;
  float _2354;
  float _2356;
  float _2357;
  float _2368;
  float _2374;
  float _2376;
  float _2378;
  float _2399;
  float4 _2406;
  float _2420;
  float _2421;
  float _2422;
  float _2423;
  float _2425;
  float _2430;
  float _2433;
  float _2434;
  float _2436;
  float _2437;
  float _2442;
  float _2447;
  float _2449;
  float _2452;
  float _2453;
  float _2458;
  float _2460;
  float _2462;
  float _2464;
  float _2469;
  float _2475;
  float _2477;
  float3 _2510;
  float _2521;
  float4 _2543;
  float _2568;
  int _2575;
  int _2580;
  int _2582;
  int _2583;
  int _2585;
  int _2586;
  int _2595;
  int _2598;
  float _2603;
  bool _2614;
  float _2617;
  float _2619;
  float _2620;
  float _2621;
  float _2622;
  float _2623;
  float _2624;
  float _2632;
  float _2637;
  float _2643;
  float _2644;
  float _2647;
  float _2649;
  bool _2650;
  float _2652;
  float _2659;
  float _2660;
  float _2661;
  float _2663;
  float _2671;
  float _2672;
  float _2673;
  float _2676;
  float _2679;
  float _2682;
  bool _2683;
  float _2687;
  float _2689;
  float _2690;
  float _2698;
  float _2701;
  float _2702;
  float _2707;
  float _2716;
  float _2717;
  float _2720;
  float _2722;
  float _2723;
  float _2724;
  float _2726;
  float _2727;
  float _2728;
  float _2729;
  float _2734;
  float _2748;
  float _2753;
  float _2754;
  float _2756;
  float _2762;
  float _2765;
  float _2776;
  float _2777;
  float _2778;
  float _2779;
  bool _2780;
  float _2790;
  float _2805;
  float _2808;
  float _2809;
  float _2810;
  float _2811;
  float _2812;
  float _2813;
  float _2814;
  float _2816;
  float _2820;
  float _2821;
  float _2822;
  float _2823;
  float _2825;
  float _2826;
  float _2834;
  float _2844;
  float _2845;
  float _2846;
  float _2863;
  float _2870;
  float _2873;
  float _2878;
  float _2885;
  float _2886;
  float _2887;
  float _2888;
  float _2907;
  float _2908;
  float _2909;
  float _2910;
  float _2911;
  float _2912;
  float _2914;
  float _2928;
  float _2929;
  float _2930;
  float _2931;
  bool _2934;
  float _2935;
  float _2936;
  float _2937;
  float _2939;
  float _2942;
  float _2944;
  float _2945;
  float _2946;
  float _2947;
  float _2950;
  float _2953;
  float _2956;
  float _2958;
  float _2970;
  float _2971;
  float _2973;
  float _2974;
  float _2975;
  float _2982;
  float _2983;
  float _2984;
  float _2987;
  float _2990;
  float _2991;
  float _2996;
  float _3000;
  float _3005;
  float _3012;
  float _3016;
  float _3017;
  float _3018;
  float _3022;
  float _3023;
  float _3024;
  float _3031;
  float _3035;
  float _3039;
  float _3040;
  float _3044;
  float _3054;
  float _3064;
  float _3066;
  float _3079;
  float _3080;
  float _3086;
  float _3089;
  float _3098;
  float _3100;
  float _3109;
  float _3114;
  float _3120;
  float _3121;
  float _3125;
  float _3126;
  float _3131;
  float _3150;
  float _3153;
  float _3156;
  float _3170;
  float _3180;
  float _3181;
  float _3185;
  float _3187;
  float _3189;
  float _3192;
  float _3205;
  float _3223;
  float _3224;
  float _3227;
  float _3230;
  float _3233;
  float _3234;
  float _3238;
  float _3239;
  float _3240;
  float _3249;
  float _3250;
  float _3272;
  float _3273;
  float _3298;
  float _3301;
  float _3305;
  float _3312;
  float _3316;
  int4 _3321;
  float _3328;
  float _3331;
  float _3335;
  float _3339;
  float _3348;
  float _3351;
  float _3355;
  float _3359;
  float _3367;
  float _3373;
  float _3383;
  float _3386;
  float _3390;
  float _3394;
  float _3401;
  float _3415;
  bool _3416;
  float _3438;
  bool _3439;
  float _3515;
  float _3519;
  float _3524;
  float _3526;
  float _3529;
  float _3532;
  float _3534;
  float _3541;
  float _3560;
  float _3574;
  float _3576;
  float _3600;
  float _3601;
  float _3602;
  float _3603;
  bool _3606;
  float _3607;
  float _3608;
  float _3609;
  float _3611;
  float _3614;
  float _3616;
  float _3617;
  float _3618;
  float _3619;
  float _3622;
  float _3625;
  float _3628;
  float _3630;
  float _3634;
  float _3643;
  float _3644;
  float _3646;
  float _3647;
  float _3648;
  float _3655;
  float _3656;
  float _3657;
  float _3660;
  float _3663;
  float _3666;
  float _3667;
  float _3668;
  float _3671;
  float _3672;
  float _3678;
  float _3682;
  float _3683;
  float _3684;
  float _3685;
  float _3686;
  float _3687;
  float _3692;
  float _3693;
  float _3701;
  float _3702;
  float _3717;
  float _3735;
  float _3750;
  float _3751;
  float _3757;
  bool _3758;
  float _3762;
  float _3764;
  float _3765;
  float _3771;
  float _3774;
  float _3775;
  float _3780;
  float _3789;
  float _3790;
  float _3793;
  float _3795;
  float _3796;
  float _3797;
  float _3799;
  float _3800;
  float _3801;
  float _3802;
  float _3807;
  float _3821;
  float _3826;
  float _3827;
  float _3829;
  float _3835;
  float _3838;
  float _3858;
  float _3873;
  float _3883;
  float _3903;
  float _3905;
  float _3909;
  float _3910;
  float _3911;
  float _3923;
  float _3924;
  float _3925;
  float _3932;
  float _3933;
  float _3934;
  float _3937;
  float _3951;
  float _3952;
  float _3953;
  float _3954;
  float _3957;
  float _3958;
  float _3959;
  float _3960;
  float _3963;
  float _3964;
  float _3965;
  int _3968;
  int _3971;
  int _3974;
  int _3977;
  int _3980;
  int _3983;
  float _3987;
  float _3990;
  float _3992;
  int _3994;
  float2 _4014;
  float3 _4031;
  float _4044;
  float _4047;
  float _4048;
  float _4049;
  float _4050;
  float _4051;
  float _4052;
  float _4060;
  float _4065;
  float _4071;
  float _4072;
  float _4075;
  float _4077;
  bool _4080;
  float _4082;
  float _4089;
  float _4090;
  float _4091;
  float _4093;
  float _4101;
  float _4102;
  float _4103;
  float _4106;
  float _4109;
  float _4112;
  bool _4113;
  float _4117;
  float _4119;
  float _4120;
  float _4128;
  float _4131;
  float _4132;
  float _4137;
  float _4146;
  float _4147;
  float _4150;
  float _4152;
  float _4153;
  float _4154;
  float _4156;
  float _4157;
  float _4158;
  float _4159;
  float _4164;
  float _4178;
  float _4183;
  float _4184;
  float _4186;
  float _4192;
  float _4195;
  float _4206;
  float _4207;
  float _4208;
  float _4209;
  bool _4210;
  float _4220;
  float _4235;
  float _4238;
  float _4239;
  float _4240;
  float _4241;
  float _4242;
  float _4243;
  float _4244;
  float _4246;
  float _4250;
  float _4251;
  float _4252;
  float _4253;
  float _4255;
  float _4256;
  float _4264;
  float _4274;
  float _4275;
  float _4276;
  float _4293;
  float _4300;
  float _4303;
  float _4308;
  float _4315;
  float _4316;
  float _4317;
  float _4318;
  float _4337;
  float _4338;
  float _4339;
  float _4340;
  float _4341;
  float _4342;
  float _4344;
  float _4358;
  float _4359;
  float _4360;
  float _4361;
  bool _4364;
  float _4365;
  float _4366;
  float _4367;
  float _4369;
  float _4372;
  float _4374;
  float _4375;
  float _4376;
  float _4377;
  float _4380;
  float _4383;
  float _4386;
  float _4388;
  float _4400;
  float _4401;
  float _4403;
  float _4404;
  float _4405;
  float _4412;
  float _4413;
  float _4414;
  float _4417;
  float _4420;
  float _4421;
  float _4426;
  float _4430;
  float _4435;
  float _4442;
  float _4446;
  float _4447;
  float _4448;
  float _4452;
  float _4453;
  float _4454;
  float _4461;
  float _4465;
  float _4469;
  float _4470;
  float _4473;
  float _4476;
  float _4486;
  float _4488;
  float _4501;
  float _4502;
  float _4508;
  float _4511;
  float _4520;
  float _4522;
  float _4531;
  float _4536;
  float _4542;
  float _4543;
  float _4547;
  float _4548;
  float _4553;
  float _4572;
  float _4575;
  float _4578;
  float _4592;
  float _4602;
  float _4603;
  float _4607;
  float _4609;
  float _4611;
  float _4614;
  float _4627;
  float _4645;
  float _4646;
  float _4649;
  float _4652;
  float _4655;
  float _4656;
  float _4660;
  float _4661;
  float _4662;
  float _4671;
  float _4672;
  float _4694;
  float _4695;
  float _4720;
  float _4723;
  float _4727;
  float _4734;
  float _4738;
  int4 _4743;
  float _4750;
  float _4753;
  float _4757;
  float _4761;
  float _4770;
  float _4773;
  float _4777;
  float _4781;
  float _4789;
  float _4795;
  float _4805;
  float _4808;
  float _4812;
  float _4816;
  float _4823;
  float _4837;
  bool _4838;
  float _4860;
  bool _4861;
  float _4937;
  float _4941;
  float _4946;
  float _4948;
  float _4951;
  float _4954;
  float _4956;
  float _4963;
  float _4982;
  float _4996;
  float _4998;
  float _5022;
  float _5023;
  float _5024;
  float _5025;
  bool _5028;
  float _5029;
  float _5030;
  float _5031;
  float _5033;
  float _5036;
  float _5038;
  float _5039;
  float _5040;
  float _5041;
  float _5044;
  float _5047;
  float _5050;
  float _5052;
  float _5056;
  float _5065;
  float _5066;
  float _5068;
  float _5069;
  float _5070;
  float _5077;
  float _5078;
  float _5079;
  float _5082;
  float _5085;
  float _5088;
  float _5089;
  float _5090;
  float _5093;
  float _5094;
  float _5100;
  float _5104;
  float _5105;
  float _5106;
  float _5107;
  float _5108;
  float _5109;
  float _5114;
  float _5115;
  float _5123;
  float _5124;
  float _5139;
  float _5157;
  float _5172;
  float _5173;
  float _5179;
  bool _5180;
  float _5184;
  float _5186;
  float _5187;
  float _5193;
  float _5196;
  float _5197;
  float _5202;
  float _5211;
  float _5212;
  float _5215;
  float _5217;
  float _5218;
  float _5219;
  float _5221;
  float _5222;
  float _5223;
  float _5224;
  float _5229;
  float _5243;
  float _5248;
  float _5249;
  float _5251;
  float _5257;
  float _5260;
  float _5280;
  float _5295;
  float _5305;
  float _5325;
  float _5327;
  float _5331;
  float _5332;
  float _5333;
  float _5357;
  bool _5370;
  float _5371;
  float _5372;
  float _5373;
  bool _5374;
  float _5376;
  float _5377;
  float _5381;
  float _5387;
  float _5401;
  float _5402;
  float _5405;
  float _5409;
  int _5410;
  float _5412;
  float _5414;
  float _5417;
  float _5421;
  float _5432;
  float _5433;
  float _5434;
  float _5436;
  float _5450;
  float _5451;
  float _5452;
  float _5468;
  float _5469;
  float _5470;
  float _5487;
  float _5502;
  float _5503;
  float _5504;
  float _5507;
  float _5508;
  float _5509;
  float _5512;
  float _5513;
  float _5514;
  float _5517;
  float _5518;
  float _5519;
  float _5522;
  float _5523;
  float _5524;
  int _5527;
  int _5530;
  int _5533;
  int _5536;
  int _5539;
  int _5542;
  int _5545;
  int _5548;
  int _5551;
  int _5554;
  int _5557;
  float _5560;
  float _5561;
  float _5562;
  float _5563;
  int _5566;
  int _5569;
  int _5572;
  int _5575;
  int _5578;
  float _5580;
  float _5581;
  float _5583;
  float _5587;
  float _5590;
  float _5591;
  float _5593;
  float _5597;
  float _5599;
  float _5600;
  float _5602;
  float _5603;
  int _5605;
  bool _5609;
  float _5617;
  float _5618;
  float _5620;
  float _5623;
  float _5624;
  float _5626;
  float _5627;
  float _5629;
  float _5630;
  float _5632;
  float _5633;
  float _5637;
  float _5643;
  float _5644;
  float _5645;
  bool _5660;
  bool _5662;
  bool _5663;
  float _5664;
  float _5665;
  float _5666;
  float _5667;
  float _5668;
  float _5669;
  float _5670;
  float _5671;
  float _5672;
  float _5675;
  float _5676;
  float _5677;
  float _5680;
  float _5687;
  float _5700;
  float _5704;
  float _5708;
  float _5709;
  float _5710;
  float _5713;
  float _5716;
  bool _5718;
  float _5724;
  float _5725;
  float _5726;
  float _5731;
  float _5732;
  float _5733;
  bool _5737;
  bool _5743;
  bool _5747;
  float _5757;
  float _5761;
  float _5770;
  float _5771;
  float _5774;
  float _5779;
  float _5780;
  float _5783;
  float _5787;
  float _5796;
  float _5797;
  float _5798;
  float _5803;
  int _5804;
  float _5809;
  float _5818;
  float _5819;
  float _5821;
  float _5823;
  float _5824;
  float4 _5826;
  float _5830;
  float _5831;
  float _5834;
  float _5835;
  float _5840;
  float _5841;
  float _5844;
  float _5845;
  float _5847;
  float _5849;
  bool _5850;
  bool _5851;
  bool _5861;
  bool _5870;
  float _5887;
  float _5889;
  float _5891;
  float _5893;
  float _5897;
  float _5899;
  float _5903;
  float _5905;
  int _5912;
  float _5917;
  float _5926;
  float _5927;
  float _5930;
  float _5931;
  float4 _5933;
  float _5937;
  float _5938;
  float _5941;
  float _5942;
  float _5944;
  float _5946;
  bool _5947;
  bool _5948;
  bool _5958;
  bool _5967;
  float _5984;
  float _5986;
  float _5990;
  float _5992;
  float _5996;
  float _5998;
  float _6002;
  float _6004;
  int _6011;
  float _6016;
  float _6025;
  float _6026;
  float _6029;
  float _6030;
  float4 _6032;
  float _6036;
  float _6037;
  float _6040;
  float _6041;
  float _6043;
  float _6045;
  bool _6046;
  bool _6047;
  bool _6057;
  bool _6066;
  float _6083;
  float _6085;
  float _6089;
  float _6091;
  float _6095;
  float _6097;
  float _6101;
  float _6103;
  int _6110;
  float _6115;
  float _6124;
  float _6125;
  float _6128;
  float _6129;
  float4 _6131;
  float _6135;
  float _6136;
  float _6139;
  float _6140;
  float _6142;
  float _6144;
  bool _6145;
  bool _6146;
  bool _6156;
  bool _6165;
  float _6182;
  float _6184;
  float _6188;
  float _6190;
  float _6194;
  float _6196;
  float _6200;
  float _6202;
  float _6203;
  float _6214;
  float _6220;
  float _6222;
  float _6224;
  float _6233;
  float _6236;
  float _6237;
  float _6251;
  float _6252;
  float _6253;
  float _6254;
  float _6258;
  float _6267;
  float _6268;
  float _6269;
  int _6270;
  float _6275;
  float _6284;
  float _6285;
  float _6287;
  float4 _6292;
  float _6297;
  float _6299;
  float _6301;
  float _6303;
  float _6307;
  float _6309;
  float _6313;
  float _6315;
  int _6322;
  float _6327;
  float _6336;
  float _6337;
  float4 _6343;
  float _6348;
  float _6350;
  float _6354;
  float _6356;
  float _6360;
  float _6362;
  float _6366;
  float _6368;
  int _6375;
  float _6380;
  float _6389;
  float _6390;
  float4 _6396;
  float _6401;
  float _6403;
  float _6407;
  float _6409;
  float _6413;
  float _6415;
  float _6419;
  float _6421;
  int _6428;
  float _6433;
  float _6442;
  float _6443;
  float4 _6449;
  float _6454;
  float _6456;
  float _6460;
  float _6462;
  float _6466;
  float _6468;
  float _6472;
  float _6474;
  float _6475;
  float _6486;
  float _6492;
  float _6494;
  float _6496;
  float _6504;
  float _6511;
  float _6513;
  float _6529;
  float _6530;
  float _6531;
  bool _6535;
  bool _6541;
  bool _6545;
  float _6555;
  float _6560;
  float _6569;
  float _6570;
  float _6571;
  float _6576;
  float _6577;
  float _6580;
  float _6584;
  float _6593;
  float _6594;
  float _6595;
  float _6600;
  int _6601;
  float _6606;
  float _6615;
  float _6616;
  float _6618;
  float _6620;
  float _6621;
  float4 _6623;
  float _6627;
  float _6628;
  float _6631;
  float _6632;
  float _6637;
  float _6638;
  float _6641;
  float _6642;
  float _6644;
  float _6646;
  bool _6647;
  bool _6648;
  bool _6658;
  bool _6667;
  float _6684;
  float _6686;
  float _6688;
  float _6690;
  float _6694;
  float _6696;
  float _6700;
  float _6702;
  int _6709;
  float _6714;
  float _6723;
  float _6724;
  float _6727;
  float _6728;
  float4 _6730;
  float _6734;
  float _6735;
  float _6738;
  float _6739;
  float _6741;
  float _6743;
  bool _6744;
  bool _6745;
  bool _6755;
  bool _6764;
  float _6781;
  float _6783;
  float _6787;
  float _6789;
  float _6793;
  float _6795;
  float _6799;
  float _6801;
  int _6808;
  float _6813;
  float _6822;
  float _6823;
  float _6826;
  float _6827;
  float4 _6829;
  float _6833;
  float _6834;
  float _6837;
  float _6838;
  float _6840;
  float _6842;
  bool _6843;
  bool _6844;
  bool _6854;
  bool _6863;
  float _6880;
  float _6882;
  float _6886;
  float _6888;
  float _6892;
  float _6894;
  float _6898;
  float _6900;
  int _6907;
  float _6912;
  float _6921;
  float _6922;
  float _6925;
  float _6926;
  float4 _6928;
  float _6932;
  float _6933;
  float _6936;
  float _6937;
  float _6939;
  float _6941;
  bool _6942;
  bool _6943;
  bool _6953;
  bool _6962;
  float _6979;
  float _6981;
  float _6985;
  float _6987;
  float _6991;
  float _6993;
  float _6997;
  float _6999;
  float _7000;
  float _7011;
  float _7017;
  float _7019;
  float _7021;
  float _7030;
  float _7033;
  float _7034;
  float _7047;
  float _7048;
  float _7049;
  float _7050;
  float _7054;
  float _7063;
  float _7064;
  float _7065;
  int _7066;
  float _7071;
  float _7080;
  float _7081;
  float _7083;
  float4 _7088;
  float _7093;
  float _7095;
  float _7097;
  float _7099;
  float _7103;
  float _7105;
  float _7109;
  float _7111;
  int _7118;
  float _7123;
  float _7132;
  float _7133;
  float4 _7139;
  float _7144;
  float _7146;
  float _7150;
  float _7152;
  float _7156;
  float _7158;
  float _7162;
  float _7164;
  int _7171;
  float _7176;
  float _7185;
  float _7186;
  float4 _7192;
  float _7197;
  float _7199;
  float _7203;
  float _7205;
  float _7209;
  float _7211;
  float _7215;
  float _7217;
  int _7224;
  float _7229;
  float _7238;
  float _7239;
  float4 _7245;
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
  float _7300;
  float _7307;
  float _7309;
  float _7339;
  float _7341;
  float _7342;
  float _7343;
  float _7358;
  float _7361;
  float _7364;
  float _7366;
  float _7367;
  float _7368;
  float _7369;
  float _7377;
  float _7378;
  float _7379;
  bool _7381;
  float _7401;
  float4 _7426;
  float _7446;
  float _7447;
  float _7448;
  float _7449;
  float _7451;
  float _7456;
  float _7459;
  float _7460;
  float _7462;
  float _7463;
  float _7468;
  float _7473;
  float _7475;
  float _7478;
  float _7479;
  float _7484;
  float _7486;
  float _7488;
  float _7490;
  float _7495;
  float _7501;
  float _7503;
  float3 _7538;
  float4 _7570;
  float _7604;
  bool _7617;
  float _7618;
  float _7619;
  float _7620;
  bool _7621;
  float _7623;
  float _7624;
  float _7628;
  float _7634;
  float _7648;
  float _7649;
  float _7652;
  float _7656;
  int _7657;
  float _7659;
  float _7661;
  float _7664;
  float _7668;
  float _7679;
  float _7680;
  float _7681;
  float _7683;
  float _7698;
  int _7705;
  int _7710;
  int _7712;
  int _7713;
  int _7715;
  int _7716;
  int _7725;
  int _7728;
  float _7733;
  bool _7744;
  float _7747;
  float _7749;
  float _7750;
  float _7751;
  float _7752;
  float _7753;
  float _7754;
  float _7755;
  float _7756;
  float _7757;
  float _7758;
  float _7759;
  float _7760;
  float _7761;
  bool _7762;
  float _7763;
  float _7764;
  float _7767;
  float _7768;
  float _7770;
  float _7797;
  float _7802;
  float _7809;
  float _7810;
  float _7811;
  float _7813;
  float _7817;
  float _7818;
  float _7819;
  float _7820;
  float _7821;
  float _7822;
  float _7823;
  float _7829;
  float _7838;
  float _7842;
  float _7843;
  float _7844;
  float _7845;
  float _7849;
  float _7850;
  float _7851;
  float _7859;
  float _7871;
  float _7872;
  float _7873;
  float _7874;
  float _7875;
  float _7876;
  float _7879;
  float _7881;
  float _7883;
  float _7884;
  float _7885;
  float _7886;
  bool _7887;
  float _7890;
  float _7897;
  float _7898;
  float _7899;
  float _7901;
  float _7909;
  float _7910;
  float _7911;
  float _7914;
  float _7917;
  float _7920;
  bool _7921;
  float _7925;
  float _7927;
  float _7928;
  float _7936;
  float _7939;
  float _7940;
  float _7945;
  float _7954;
  float _7955;
  float _7958;
  float _7960;
  float _7961;
  float _7962;
  float _7964;
  float _7965;
  float _7966;
  float _7967;
  float _7972;
  float _7986;
  float _7991;
  float _7992;
  float _7994;
  float _8000;
  float _8003;
  float _8014;
  float _8015;
  float _8016;
  float _8017;
  float _8018;
  bool _8019;
  float _8037;
  bool _8042;
  float _8048;
  float _8065;
  float _8068;
  float _8069;
  float _8070;
  float _8071;
  float _8072;
  float _8073;
  float _8074;
  float _8076;
  float _8080;
  float _8081;
  float _8082;
  float _8083;
  float _8085;
  float _8086;
  float _8087;
  float _8095;
  float _8105;
  float _8106;
  float _8107;
  float _8124;
  float _8131;
  float _8134;
  float _8139;
  float _8146;
  float _8147;
  float _8148;
  float _8149;
  float _8168;
  float _8169;
  float _8170;
  float _8171;
  float _8172;
  float _8173;
  float _8175;
  float _8189;
  float _8190;
  float _8191;
  float _8192;
  bool _8195;
  float _8196;
  float _8197;
  float _8198;
  float _8200;
  float _8203;
  float _8205;
  float _8206;
  float _8207;
  float _8208;
  float _8211;
  float _8214;
  float _8217;
  float _8219;
  float _8231;
  float _8232;
  float _8234;
  float _8235;
  float _8236;
  float _8243;
  float _8244;
  float _8245;
  float _8248;
  float _8251;
  float _8252;
  float _8257;
  float _8261;
  float _8266;
  float _8273;
  float _8277;
  float _8278;
  float _8279;
  float _8283;
  float _8284;
  float _8285;
  float _8292;
  float _8296;
  float _8300;
  float _8301;
  float _8305;
  float _8316;
  float _8326;
  float _8328;
  float _8341;
  float _8342;
  float _8348;
  float _8351;
  float _8360;
  float _8362;
  float _8371;
  float _8376;
  float _8382;
  float _8383;
  float _8387;
  float _8388;
  float _8393;
  float _8412;
  float _8415;
  float _8418;
  float _8432;
  float _8442;
  float _8443;
  float _8447;
  float _8449;
  float _8451;
  float _8454;
  float _8467;
  float _8485;
  float _8486;
  float _8489;
  float _8492;
  float _8495;
  float _8496;
  float _8500;
  float _8501;
  float _8502;
  float _8511;
  float _8512;
  float _8530;
  float _8540;
  float _8554;
  float _8555;
  float _8573;
  float _8583;
  float _8600;
  float _8603;
  float _8607;
  float _8614;
  float _8618;
  int4 _8623;
  float _8630;
  float _8633;
  float _8637;
  float _8641;
  float _8650;
  float _8653;
  float _8657;
  float _8661;
  float _8669;
  float _8675;
  float _8685;
  float _8688;
  float _8692;
  float _8696;
  float _8703;
  float _8717;
  bool _8718;
  float _8740;
  bool _8741;
  float _8817;
  float _8821;
  float _8826;
  float _8828;
  float _8831;
  float _8834;
  float _8836;
  float _8843;
  float _8862;
  float _8876;
  float _8878;
  float _8902;
  float _8903;
  float _8904;
  float _8905;
  bool _8908;
  float _8909;
  float _8910;
  float _8911;
  float _8913;
  float _8916;
  float _8918;
  float _8919;
  float _8920;
  float _8921;
  float _8924;
  float _8927;
  float _8930;
  float _8932;
  float _8936;
  float _8945;
  float _8946;
  float _8948;
  float _8949;
  float _8950;
  float _8957;
  float _8958;
  float _8959;
  float _8962;
  float _8965;
  float _8968;
  float _8972;
  float _8976;
  float _8977;
  float _8980;
  float _8981;
  float _8987;
  float _8991;
  float _8992;
  float _8993;
  float _8994;
  float _8995;
  float _8996;
  float _9001;
  float _9002;
  float _9010;
  float _9011;
  float _9026;
  float _9044;
  float _9059;
  float _9060;
  float _9066;
  bool _9067;
  float _9071;
  float _9073;
  float _9074;
  float _9080;
  float _9083;
  float _9084;
  float _9089;
  float _9098;
  float _9099;
  float _9102;
  float _9104;
  float _9105;
  float _9106;
  float _9108;
  float _9109;
  float _9110;
  float _9111;
  float _9116;
  float _9130;
  float _9135;
  float _9136;
  float _9138;
  float _9144;
  float _9147;
  float _9175;
  float _9185;
  float _9202;
  float _9212;
  float _9213;
  float _9233;
  float _9235;
  float _9239;
  float _9240;
  float _9241;
  float _9253;
  float _9254;
  float _9255;
  float _9262;
  float _9263;
  float _9264;
  float _9268;
  float _9283;
  float _9284;
  float _9285;
  float _9288;
  float _9289;
  float _9290;
  float _9293;
  int _9296;
  int _9299;
  int _9302;
  float _9311;
  float _9314;
  float _9317;
  float _9324;
  float _9329;
  float _9331;
  float _9333;
  float _9334;
  float _9335;
  float _9337;
  float _9338;
  float _9339;
  float _9342;
  float _9343;
  float _9344;
  float _9347;
  float _9354;
  int _9363;
  int _9368;
  int _9370;
  int _9371;
  int _9373;
  int _9374;
  int _9383;
  int _9386;
  float _9391;
  bool _9402;
  float _9405;
  float _9407;
  bool _9410;
  float _9411;
  float _9419;
  float _9420;
  float _9421;
  float _9423;
  float _9431;
  float _9432;
  float _9433;
  float _9436;
  float _9439;
  float _9442;
  float _9443;
  float _9444;
  float _9445;
  float _9446;
  float _9450;
  float _9452;
  float _9453;
  float _9454;
  float _9455;
  float _9456;
  float _9457;
  float _9458;
  float _9460;
  float _9464;
  float _9465;
  float _9466;
  float _9469;
  float _9470;
  float _9471;
  float _9479;
  float _9489;
  float _9490;
  float _9491;
  float _9508;
  float _9515;
  float _9518;
  float _9523;
  float _9530;
  float _9531;
  float _9532;
  float _9533;
  float _9552;
  float _9553;
  float _9554;
  float _9555;
  float _9556;
  float _9557;
  float _9559;
  float _9570;
  float _9571;
  float _9572;
  float _9573;
  bool _9576;
  float _9577;
  float _9578;
  float _9579;
  float _9581;
  float _9584;
  float _9586;
  float _9587;
  float _9588;
  float _9589;
  float _9592;
  float _9595;
  float _9598;
  float _9600;
  float _9612;
  float _9613;
  float _9615;
  float _9616;
  float _9617;
  float _9624;
  float _9625;
  float _9626;
  float _9629;
  float _9632;
  float _9633;
  float _9638;
  float _9642;
  float _9647;
  float _9654;
  float _9658;
  float _9659;
  float _9660;
  float _9664;
  float _9665;
  float _9666;
  float _9673;
  float _9677;
  float _9681;
  float _9682;
  float _9683;
  float _9686;
  float _9696;
  float _9698;
  float _9711;
  float _9712;
  float _9718;
  float _9721;
  float _9730;
  float _9732;
  float _9741;
  float _9746;
  float _9752;
  float _9753;
  float _9757;
  float _9758;
  float _9763;
  float _9782;
  float _9785;
  float _9788;
  float _9802;
  float _9812;
  float _9813;
  float _9817;
  float _9819;
  float _9821;
  float _9824;
  float _9837;
  float _9855;
  float _9856;
  float _9859;
  float _9862;
  float _9865;
  float _9866;
  float _9870;
  float _9871;
  float _9872;
  float _9881;
  float _9882;
  float _9883;
  float _9884;
  float _9888;
  float _9890;
  float _9894;
  float _9900;
  float _9904;
  int4 _9909;
  float _9916;
  float _9919;
  float _9923;
  float _9927;
  float _9936;
  float _9939;
  float _9943;
  float _9947;
  float _9955;
  float _9961;
  float _9971;
  float _9974;
  float _9978;
  float _9982;
  float _9989;
  float _10003;
  bool _10004;
  float _10026;
  bool _10027;
  float _10103;
  float _10107;
  float _10112;
  float _10114;
  float _10117;
  float _10120;
  float _10122;
  float _10129;
  float _10148;
  float _10162;
  float _10164;
  float _10188;
  float _10189;
  float _10190;
  float _10191;
  bool _10194;
  float _10195;
  float _10196;
  float _10197;
  float _10199;
  float _10202;
  float _10204;
  float _10205;
  float _10206;
  float _10207;
  float _10210;
  float _10213;
  float _10216;
  float _10218;
  float _10222;
  float _10231;
  float _10232;
  float _10234;
  float _10235;
  float _10236;
  float _10243;
  float _10244;
  float _10245;
  float _10248;
  float _10251;
  float _10254;
  float _10255;
  float _10256;
  float _10259;
  float _10260;
  float _10266;
  float _10270;
  float _10271;
  float _10272;
  float _10273;
  float _10274;
  float _10275;
  float _10280;
  float _10281;
  float _10289;
  float _10290;
  float _10305;
  float _10323;
  float _10338;
  float _10339;
  float _10343;
  float _10348;
  float _10349;
  float _10368;
  float _10370;
  float _10374;
  float _10375;
  float _10376;
  float _10388;
  float _10389;
  float _10390;
  float _10397;
  float _10398;
  float _10399;
  float _10403;
  float _10418;
  float _10419;
  float _10420;
  float _10423;
  float _10424;
  float _10425;
  float _10428;
  float _10429;
  float _10430;
  float _10433;
  float _10434;
  float _10435;
  float _10438;
  float _10439;
  float _10440;
  float _10443;
  float _10444;
  float _10445;
  int _10448;
  int _10451;
  int _10454;
  int _10457;
  float _10460;
  float _10461;
  float _10462;
  float _10463;
  int _10466;
  int _10469;
  int _10472;
  int _10475;
  int _10478;
  int _10481;
  int _10484;
  float _10487;
  float _10488;
  float _10489;
  float _10490;
  int _10493;
  int _10496;
  int _10499;
  int _10502;
  float _10504;
  float _10505;
  float _10507;
  float _10511;
  float _10514;
  float _10515;
  float _10517;
  float _10521;
  int _10525;
  bool _10531;
  float _10548;
  float _10549;
  float _10550;
  float _10551;
  bool _10556;
  bool _10558;
  bool _10559;
  float _10560;
  float _10561;
  float _10562;
  float _10563;
  float _10564;
  float _10565;
  float _10566;
  float _10567;
  float _10568;
  float _10571;
  float _10572;
  float _10573;
  float _10576;
  float _10587;
  float _10591;
  float _10598;
  float _10599;
  float _10600;
  float _10612;
  float _10613;
  float _10614;
  float _10615;
  float _10618;
  float _10619;
  float _10622;
  float _10623;
  float _10630;
  float _10632;
  float _10638;
  float _10648;
  float _10649;
  float _10650;
  float _10655;
  float _10657;
  float _10658;
  float _10661;
  float _10662;
  float _10666;
  float _10675;
  float _10676;
  float _10677;
  int _10678;
  float _10683;
  float _10692;
  float _10693;
  float _10695;
  float4 _10700;
  float _10705;
  float _10707;
  float _10709;
  float _10711;
  float _10715;
  float _10717;
  float _10721;
  float _10723;
  int _10730;
  float _10735;
  float _10744;
  float _10745;
  float4 _10751;
  float _10756;
  float _10758;
  float _10762;
  float _10764;
  float _10768;
  float _10770;
  float _10774;
  float _10776;
  int _10783;
  float _10788;
  float _10797;
  float _10798;
  float4 _10804;
  float _10809;
  float _10811;
  float _10815;
  float _10817;
  float _10821;
  float _10823;
  float _10827;
  float _10829;
  int _10836;
  float _10841;
  float _10850;
  float _10851;
  float4 _10857;
  float _10862;
  float _10864;
  float _10868;
  float _10870;
  float _10874;
  float _10876;
  float _10880;
  float _10882;
  float _10883;
  float _10894;
  float _10900;
  float _10902;
  float _10904;
  float _10911;
  float _10919;
  float _10920;
  float _10927;
  float _10930;
  float _10934;
  float _10943;
  float _10944;
  float _10945;
  float _10950;
  int _10951;
  float _10956;
  float _10965;
  float _10966;
  float _10968;
  float _10970;
  float _10971;
  float4 _10973;
  float _10977;
  float _10978;
  float _10981;
  float _10982;
  float _10987;
  float _10988;
  float _10991;
  float _10992;
  float _10994;
  float _10996;
  bool _10997;
  bool _10998;
  bool _11008;
  bool _11017;
  float _11034;
  float _11036;
  float _11038;
  float _11040;
  float _11044;
  float _11046;
  float _11050;
  float _11052;
  int _11059;
  float _11064;
  float _11073;
  float _11074;
  float _11077;
  float _11078;
  float4 _11080;
  float _11084;
  float _11085;
  float _11088;
  float _11089;
  float _11091;
  float _11093;
  bool _11094;
  bool _11095;
  bool _11105;
  bool _11114;
  float _11131;
  float _11133;
  float _11137;
  float _11139;
  float _11143;
  float _11145;
  float _11149;
  float _11151;
  int _11158;
  float _11163;
  float _11172;
  float _11173;
  float _11176;
  float _11177;
  float4 _11179;
  float _11183;
  float _11184;
  float _11187;
  float _11188;
  float _11190;
  float _11192;
  bool _11193;
  bool _11194;
  bool _11204;
  bool _11213;
  float _11230;
  float _11232;
  float _11236;
  float _11238;
  float _11242;
  float _11244;
  float _11248;
  float _11250;
  int _11257;
  float _11262;
  float _11271;
  float _11272;
  float _11275;
  float _11276;
  float4 _11278;
  float _11282;
  float _11283;
  float _11286;
  float _11287;
  float _11289;
  float _11291;
  bool _11292;
  bool _11293;
  bool _11303;
  bool _11312;
  float _11329;
  float _11331;
  float _11335;
  float _11337;
  float _11341;
  float _11343;
  float _11347;
  float _11349;
  float _11350;
  float _11361;
  float _11367;
  float _11369;
  float _11371;
  float _11392;
  float4 _11399;
  float _11413;
  float _11414;
  float _11415;
  float _11416;
  float _11418;
  float _11423;
  float _11426;
  float _11427;
  float _11429;
  float _11430;
  float _11435;
  float _11440;
  float _11442;
  float _11445;
  float _11446;
  float _11451;
  float _11453;
  float _11455;
  float _11457;
  float _11462;
  float _11468;
  float _11470;
  float3 _11503;
  float _11514;
  float4 _11536;
  float _11574;
  bool _11587;
  float _11588;
  float _11589;
  float _11590;
  bool _11591;
  float _11593;
  float _11594;
  float _11598;
  float _11604;
  float _11618;
  float _11619;
  float _11622;
  float _11626;
  int _11627;
  float _11629;
  float _11631;
  float _11634;
  float _11638;
  float _11649;
  float _11650;
  float _11651;
  float _11653;
  float _11668;
  int _11675;
  int _11680;
  int _11682;
  int _11683;
  int _11685;
  int _11686;
  int _11695;
  int _11698;
  float _11703;
  bool _11714;
  float _11717;
  float _11719;
  float _11720;
  float _11721;
  float _11722;
  float _11723;
  float _11724;
  float _11725;
  float _11726;
  float _11727;
  float _11728;
  float _11729;
  float _11730;
  bool _11731;
  float _11732;
  float _11733;
  float _11736;
  float _11737;
  float _11739;
  float _11766;
  float _11771;
  float _11778;
  float _11779;
  float _11780;
  float _11782;
  float _11786;
  float _11787;
  float _11788;
  float _11789;
  float _11790;
  float _11791;
  float _11792;
  float _11798;
  float _11807;
  float _11811;
  float _11812;
  float _11813;
  float _11814;
  float _11818;
  float _11819;
  float _11820;
  float _11828;
  float _11840;
  float _11841;
  float _11842;
  float _11843;
  float _11844;
  float _11845;
  float _11848;
  float _11850;
  float _11852;
  float _11853;
  float _11854;
  float _11855;
  bool _11856;
  float _11859;
  float _11866;
  float _11867;
  float _11868;
  float _11870;
  float _11878;
  float _11879;
  float _11880;
  float _11883;
  float _11886;
  float _11889;
  bool _11890;
  float _11894;
  float _11896;
  float _11897;
  float _11905;
  float _11908;
  float _11909;
  float _11914;
  float _11923;
  float _11924;
  float _11927;
  float _11929;
  float _11930;
  float _11931;
  float _11933;
  float _11934;
  float _11935;
  float _11936;
  float _11941;
  float _11955;
  float _11960;
  float _11961;
  float _11963;
  float _11969;
  float _11972;
  float _11983;
  float _11984;
  float _11985;
  float _11986;
  float _11987;
  bool _11988;
  float _12006;
  bool _12011;
  float _12017;
  float _12034;
  float _12037;
  float _12038;
  float _12039;
  float _12040;
  float _12041;
  float _12042;
  float _12043;
  float _12045;
  float _12049;
  float _12050;
  float _12051;
  float _12052;
  float _12054;
  float _12055;
  float _12056;
  float _12064;
  float _12074;
  float _12075;
  float _12076;
  float _12093;
  float _12100;
  float _12103;
  float _12108;
  float _12115;
  float _12116;
  float _12117;
  float _12118;
  float _12137;
  float _12138;
  float _12139;
  float _12140;
  float _12141;
  float _12142;
  float _12144;
  float _12158;
  float _12159;
  float _12160;
  float _12161;
  bool _12164;
  float _12165;
  float _12166;
  float _12167;
  float _12169;
  float _12172;
  float _12174;
  float _12175;
  float _12176;
  float _12177;
  float _12180;
  float _12183;
  float _12186;
  float _12188;
  float _12200;
  float _12201;
  float _12203;
  float _12204;
  float _12205;
  float _12212;
  float _12213;
  float _12214;
  float _12217;
  float _12220;
  float _12221;
  float _12226;
  float _12230;
  float _12235;
  float _12242;
  float _12246;
  float _12247;
  float _12248;
  float _12252;
  float _12253;
  float _12254;
  float _12261;
  float _12265;
  float _12269;
  float _12270;
  float _12274;
  float _12285;
  float _12295;
  float _12297;
  float _12310;
  float _12311;
  float _12317;
  float _12320;
  float _12329;
  float _12331;
  float _12340;
  float _12345;
  float _12351;
  float _12352;
  float _12356;
  float _12357;
  float _12362;
  float _12381;
  float _12384;
  float _12387;
  float _12401;
  float _12411;
  float _12412;
  float _12416;
  float _12418;
  float _12420;
  float _12423;
  float _12436;
  float _12454;
  float _12455;
  float _12458;
  float _12461;
  float _12464;
  float _12465;
  float _12469;
  float _12470;
  float _12471;
  float _12480;
  float _12481;
  float _12499;
  float _12509;
  float _12523;
  float _12524;
  float _12542;
  float _12552;
  float _12569;
  float _12572;
  float _12576;
  float _12583;
  float _12587;
  int4 _12592;
  float _12599;
  float _12602;
  float _12606;
  float _12610;
  float _12619;
  float _12622;
  float _12626;
  float _12630;
  float _12638;
  float _12644;
  float _12654;
  float _12657;
  float _12661;
  float _12665;
  float _12672;
  float _12686;
  bool _12687;
  float _12709;
  bool _12710;
  float _12786;
  float _12790;
  float _12795;
  float _12797;
  float _12800;
  float _12803;
  float _12805;
  float _12812;
  float _12831;
  float _12845;
  float _12847;
  float _12871;
  float _12872;
  float _12873;
  float _12874;
  bool _12877;
  float _12878;
  float _12879;
  float _12880;
  float _12882;
  float _12885;
  float _12887;
  float _12888;
  float _12889;
  float _12890;
  float _12893;
  float _12896;
  float _12899;
  float _12901;
  float _12905;
  float _12914;
  float _12915;
  float _12917;
  float _12918;
  float _12919;
  float _12926;
  float _12927;
  float _12928;
  float _12931;
  float _12934;
  float _12937;
  float _12941;
  float _12945;
  float _12946;
  float _12949;
  float _12950;
  float _12956;
  float _12960;
  float _12961;
  float _12962;
  float _12963;
  float _12964;
  float _12965;
  float _12970;
  float _12971;
  float _12979;
  float _12980;
  float _12995;
  float _13013;
  float _13028;
  float _13029;
  float _13035;
  bool _13036;
  float _13040;
  float _13042;
  float _13043;
  float _13049;
  float _13052;
  float _13053;
  float _13058;
  float _13067;
  float _13068;
  float _13071;
  float _13073;
  float _13074;
  float _13075;
  float _13077;
  float _13078;
  float _13079;
  float _13080;
  float _13085;
  float _13099;
  float _13104;
  float _13105;
  float _13107;
  float _13113;
  float _13116;
  float _13144;
  float _13154;
  float _13171;
  float _13181;
  float _13182;
  float _13202;
  float _13204;
  float _13208;
  float _13209;
  float _13210;
  float _13222;
  float _13223;
  float _13224;
  float _13231;
  float _13232;
  float _13233;
  float _13237;
  float _13252;
  float _13253;
  float _13254;
  float _13255;
  float _13258;
  float _13259;
  float _13260;
  float _13261;
  float _13264;
  float _13265;
  float _13266;
  float _13267;
  float _13270;
  float _13271;
  int _13274;
  int _13277;
  int _13280;
  int _13283;
  float _13286;
  float _13288;
  float _13289;
  float _13291;
  float _13295;
  float _13297;
  float _13301;
  float _13305;
  float _13309;
  float _13312;
  float _13315;
  float _13318;
  float _13330;
  float _13331;
  float _13332;
  float _13333;
  float _13334;
  float _13335;
  float _13336;
  float _13337;
  float _13338;
  float _13339;
  float _13340;
  float _13342;
  float _13344;
  float _13346;
  float _13348;
  float _13349;
  float _13355;
  float _13357;
  float _13364;
  float _13379;
  float _13381;
  float _13388;
  float _13398;
  float _13404;
  float _13406;
  float _13413;
  float _13430;
  float _13432;
  float _13439;
  float _13458;
  float _13459;
  float _13460;
  float _13461;
  float _13463;
  float _13465;
  float _13466;
  float _13467;
  float _13468;
  float _13469;
  float _13470;
  float _13471;
  float _13472;
  float _13474;
  float _13476;
  float _13477;
  float _13478;
  float _13479;
  float _13480;
  float _13481;
  float _13482;
  float _13484;
  float _13486;
  float _13493;
  bool _13506;
  float _13508;
  float _13514;
  float _13518;
  float _13520;
  float _13521;
  bool _13522;
  float _13524;
  float _13530;
  float _13531;
  float _13536;
  float _13537;
  float _13540;
  float _13542;
  float _13549;
  float _13562;
  float _13564;
  float _13571;
  float _13600;
  float _13601;
  float _13610;
  float _13619;
  float _13620;
  float _13626;
  float _13631;
  float _13640;
  float _13648;
  float _13651;
  float4 _13659;
  float _13661;
  float4 _13662;
  float _13671;
  float _13692;
  float _13693;
  float _13721;
  int _13735;
  float _13746;
  float _13753;
  float _13764;
  float _13787;
  float _13788;
  float _13803;
  float _13806;
  float _13809;
  float4 _13830;
  float _13834;
  float _13835;
  float _13836;
  float _13838;
  float _13839;
  float _13840;
  float _13841;
  float _13842;
  float _13843;
  float _13844;
  float _13845;
  float _13846;
  float _13851;
  float _13856;
  float _13869;
  float4 _13877;
  float _13879;
  float _13886;
  bool _13919;
  float _13928;
  float _13929;
  float _13930;
  float _13931;
  float _13934;
  float _13935;
  float _13936;
  float _13937;
  float _13949;
  float _13952;
  float _13953;
  float _13955;
  float _13957;
  float _13964;
  float _13966;
  float _13968;
  float _13974;
  float _13975;
  float _13977;
  float _13994;
  float _14009;
  float _14020;
  float _14021;
  float _14025;
  float _14035;
  float _14038;
  float _14043;
  float _14044;
  float _14051;
  float _14062;
  float _14063;
  float _14064;
  float _14104;
  int __loop_jump_target = -1;
  _58 = ((((((float)((uint)SV_DispatchThreadID.x)) + 0.5f) * 0.015625f) * cbDeferredShading.adaptationBounds.x) + 0.5f) - (cbDeferredShading.adaptationBounds.x * 0.5f);
  _59 = ((((((float)((uint)SV_DispatchThreadID.y)) + 0.5f) * 0.015625f) * cbDeferredShading.adaptationBounds.y) + 0.5f) - (cbDeferredShading.adaptationBounds.y * 0.5f);
  _65 = uint(_58 * cbSharedPerViewData.vViewportSize.z);
  _66 = uint(_59 * cbSharedPerViewData.vViewportSize.w);
  _68 = srvGlobalGBuffer0.Load(int3(_65, _66, 0));
  if ((_68.x == 1.0f) || ((!(_68.x == 1.0f)) && ((_58 < 0.0f) || (_59 < 0.0f))) || (((!(_68.x == 1.0f)) && (!((_58 < 0.0f) || (_59 < 0.0f)))) && ((_58 > 1.0f) || (_59 > 1.0f)))) {
    uavDeferredShadingEvaluateAdaptationPass_Luminance[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3(0.0f, 0.0f, 0.0f);
  } else {
    if (_68.x > 0.0f) {
      _85 = srvGlobalGBuffer1.Load(int3(_65, _66, 0));
      _89 = srvGlobalGBuffer2.Load(int3(_65, _66, 0));
      _95 = srvGlobalGBuffer3.Load(int3(_65, _66, 0));
      _101 = srvGlobalGBuffer4.Load(int3(_65, _66, 0));
      _107 = srvGlobalGBuffer5.Load(int3(_65, _66, 0));
      _113 = saturate(_89.x);
      _114 = saturate(_89.y);
      _115 = saturate(_89.z);
      _117 = saturate(_95.x);
      _118 = saturate(_95.y);
      _119 = saturate(_95.z);
      _122 = saturate(_101.y);
      _123 = saturate(_101.z);
      _130 = (saturate(_85.x) * 2.0f) + -1.0f;
      _131 = (saturate(_85.y) * 2.0f) + -1.0f;
      _135 = (1.0f - abs(_130)) - abs(_131);
      _137 = saturate(-0.0f - _135);
      _138 = -0.0f - _137;
      _143 = select((_130 >= 0.0f), _138, _137) + _130;
      _144 = select((_131 >= 0.0f), _138, _137) + _131;
      _146 = rsqrt(dot(float3(_143, _144, _135), float3(_143, _144, _135)));
      _147 = _143 * _146;
      _148 = _144 * _146;
      _149 = _146 * _135;
      _154 = uint(saturate(_101.w) * 255.0f);
      _159 = ((float)((uint)((uint)(_154 & 7)))) * 0.003921568859368563f;
      _162 = (_159 >= 0.007843137718737125f) && (_159 < 0.0117647061124444f);
      if (!_162) {
        _169 = select(((_159 >= 0.003921568859368563f) && (_159 < 0.007843137718737125f)), 0.0f, _117);
        _170 = 0.0f;
      } else {
        _169 = 0.0f;
        _170 = _117;
      }
      _171 = (_159 >= 0.0235294122248888f);
      _172 = select(_171, 0.0f, _169);
      _173 = select(_171, 0.5f, _118);
      _174 = _173 * 0.07999999821186066f;
      _187 = ((int)(uint((_123 * 1.9921875f) + 0.003921568859368563f)) != 0);
      _191 = (_159 >= 0.01568627543747425f) && (_159 < 0.019607843831181526f);
      if (_191) {
        _201 = (_117 * _117);
        _202 = (_118 * _118);
        _203 = (_119 * _119);
        _204 = 0.0f;
        _205 = 0.5f;
        _206 = ((_123 - (((float)((bool)_187)) * 0.501960813999176f)) * 2.007874011993408f);
        _207 = saturate(_95.w);
      } else {
        _201 = ((_172 * (_113 - _174)) + _174);
        _202 = ((_172 * (_114 - _174)) + _174);
        _203 = ((_172 * (_115 - _174)) + _174);
        _204 = _172;
        _205 = _173;
        _206 = 0.0f;
        _207 = 0.0f;
      }
      _209 = min(1.0f, max(saturate(_101.x), 0.019999999552965164f));
      _212 = (_159 >= 0.019607843831181526f) && (_159 < 0.0235294122248888f);
      if (_212) {
        _217 = min(1.0f, max(_123, 0.019999999552965164f));
        _218 = 0;
        _219 = _209;
      } else {
        _217 = _209;
        _218 = ((int)(uint)(_187));
        _219 = 0.0f;
      }
      _220 = _122 * _122;
      _223 = (_204 * (1.0f - _174)) + _174;
      if (_162) {
        _227 = uint((saturate(_107.y) * 255.0f) + 0.5f);
        _230 = ((float)((uint)((uint)((uint)(_227) >> 1)))) * 0.007874015718698502f;
        _257 = (saturate(_107.x) * 4.0f);
        _258 = (_227 & 1);
        _259 = (int)(uint((saturate(_107.z) * 255.0f) + 0.5f));
        _260 = 0;
        _261 = 0;
        _262 = 0;
        _263 = 0.0f;
        _264 = 0.0f;
        _265 = ((_230 * _230) * _220);
      } else {
        if ((_159 >= 0.003921568859368563f) && (_159 < 0.007843137718737125f)) {
          _257 = 0.0f;
          _258 = 0;
          _259 = 0;
          _260 = (int)(uint((_117 * 255.0f) + 0.5f));
          _261 = (int)(uint((_119 * 255.0f) + 0.5f));
          _262 = ((int)(uint((_123 * 255.0f) + 0.5f)) & 127);
          _263 = 0.0f;
          _264 = 0.0f;
          _265 = _220;
        } else {
          _257 = 0.0f;
          _258 = 0;
          _259 = 0;
          _260 = 0;
          _261 = 0;
          _262 = 0;
          _263 = select(_212, _119, 0.0f);
          _264 = select(_212, _219, 0.0f);
          _265 = _220;
        }
      }
      _267 = srvBlurredGbufNormal.Load(int3(_65, _66, 0));
      _272 = (_267.x * 2.0f) + -1.0f;
      _273 = (_267.y * 2.0f) + -1.0f;
      _277 = (1.0f - abs(_272)) - abs(_273);
      _279 = saturate(-0.0f - _277);
      _280 = -0.0f - _279;
      _285 = select((_272 >= 0.0f), _280, _279) + _272;
      _286 = select((_273 >= 0.0f), _280, _279) + _273;
      _288 = rsqrt(dot(float3(_285, _286, _277), float3(_285, _286, _277)));
      _289 = _285 * _288;
      _290 = _286 * _288;
      _291 = _288 * _277;
      _292 = 1.0f - _204;
      _296 = (float)((uint)_65);
      _297 = (float)((uint)_66);
      _305 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _296) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
      _306 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _297) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
      _312 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _68.x) - cbSharedPerViewData.vViewRemap.y);
      _313 = _312 * _305;
      _314 = _312 * _306;
      _315 = -0.0f - _312;
      _318 = -0.0f - _305;
      _319 = -0.0f - _306;
      _321 = rsqrt(dot(float3(_318, _319, 1.0f), float3(_318, _319, 1.0f)));
      _322 = _321 * _318;
      _323 = _321 * _319;
      _329 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _66) + _65))];
      _330 = _329 & 255;
      _331 = (uint)(_329) >> 8;
      _332 = _331 & 255;
      _336 = ((float)((uint)((uint)(((uint)(_329) >> 16) & 255)))) * 0.003921568859368563f;
      _338 = (float)((uint)((uint)((uint)(_329) >> 24)));
      _339 = _338 * 0.003921568859368563f;
      _346 = ((int)((cbSharedPerViewData.viClusteredLightingClusterParams.x * ((uint)(_66) >> 4)) + ((uint)((uint)(_65) >> 4)))) << 6;
      _349 = srvDeferredClusters[_346];
      _350 = (uint)(_349) >> 16;
      _351 = _350 & 255;
      _352 = (uint)(_349) >> 8;
      _353 = _352 & 255;
      [branch]
      if (!((((int)(uint((saturate(_89.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _361 = _217 * 4.0f;
        _366 = dot(float3((-0.0f - _322), (-0.0f - _323), (-0.0f - _321)), float3(_147, _148, _149)) * 2.0f;
        _370 = _217 * _217;
        _371 = 1.0f - _370;
        _374 = (sqrt(_371) + _370) * _371;
        _387 = (_374 * (((-0.0f - _147) - _322) - (_366 * _147))) + _147;
        _388 = (_374 * (((-0.0f - _148) - _323) - (_366 * _148))) + _148;
        _389 = (_374 * (((-0.0f - _149) - _321) - (_366 * _149))) + _149;
        _393 = saturate(1.0f - ((_217 + -0.30000001192092896f) * 3.3333332538604736f));
        _408 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _389, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _388, (_387 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _411 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _389, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _388, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _387)));
        _414 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _389, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _388, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _387)));
        if (!(_351 == 0)) {
          _434 = 0;
          _435 = 0.0f;
          _436 = 0.0f;
          _437 = 0.0f;
          _438 = 0.0f;
          _439 = 0.0f;
          _440 = 0.0f;
          _441 = 0.0f;
          _442 = 0.0f;
          while(true) {
            _695 = _435;
            _696 = _436;
            _697 = _437;
            _698 = _438;
            _699 = _439;
            _700 = _440;
            _701 = _441;
            _702 = _442;
            _447 = srvDeferredClusters[((int)(((uint)(_346 | 1)) + _434))];
            _448 = _447 & 4095;
            _451 = srvLightInfoBase[_448].nRoomMask;
            _453 = srvLightInfoBase[_448].nBufferOffset;
            _456 = asfloat(srvLightInfoProperties.Load4(_453)).x;
            _457 = asfloat(srvLightInfoProperties.Load4(_453)).y;
            _458 = asfloat(srvLightInfoProperties.Load4(_453)).z;
            _459 = asfloat(srvLightInfoProperties.Load4(_453)).w;
            _462 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 16u)))).x;
            _463 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 16u)))).y;
            _464 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 16u)))).z;
            _465 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 16u)))).w;
            _468 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 32u)))).x;
            _469 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 32u)))).y;
            _470 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 32u)))).z;
            _471 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 32u)))).w;
            _474 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 48u)))).x;
            _475 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 48u)))).y;
            _476 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 48u)))).z;
            _477 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 48u)))).w;
            _480 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 64u)))).x;
            _481 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 64u)))).y;
            _482 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 64u)))).z;
            _483 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 64u)))).w;
            _486 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 80u)))).x;
            _487 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 80u)))).y;
            _488 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 80u)))).z;
            _489 = asfloat(srvLightInfoProperties.Load4(((int)(_453 + 80u)))).w;
            _492 = asint(srvLightInfoProperties.Load(((int)(_453 + 96u))));
            _495 = asfloat(srvLightInfoProperties.Load3(((int)(_453 + 100u)))).x;
            _496 = asfloat(srvLightInfoProperties.Load3(((int)(_453 + 100u)))).y;
            _497 = asfloat(srvLightInfoProperties.Load3(((int)(_453 + 100u)))).z;
            _500 = asfloat(srvLightInfoProperties.Load3(((int)(_453 + 112u)))).x;
            _501 = asfloat(srvLightInfoProperties.Load3(((int)(_453 + 112u)))).y;
            _502 = asfloat(srvLightInfoProperties.Load3(((int)(_453 + 112u)))).z;
            _505 = asint(srvLightInfoProperties.Load(((int)(_453 + 124u))));
            _508 = asint(srvLightInfoProperties.Load(((int)(_453 + 128u))));
            _511 = _492 & 65535;
            _540 = ((saturate(1.0f - abs(mad(_458, _315, mad(_457, _314, (_456 * _313))) + _459)) * f16tof32(((uint)((uint)(_492) >> 16)))) * saturate(1.0f - abs(mad(_464, _315, mad(_463, _314, (_462 * _313))) + _465))) * saturate(1.0f - abs(mad(_470, _315, mad(_469, _314, (_468 * _313))) + _471));
            [branch]
            if (_540 > 0.0f) {
              _543 = _540 * _540;
              [branch]
              if (_393 < 1.0f) {
                _546 = (float)((uint)_511);
                _547 = -0.0f - _408;
                [branch]
                if (!(_546 >= 341.0f)) {
                  _559 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_547, _411, _414, _546), _361);
                  _564 = _559.x;
                  _565 = _559.y;
                  _566 = _559.z;
                } else {
                  _553 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_547, _411, _414, (_546 + -341.0f)), _361);
                  _564 = _553.x;
                  _565 = _553.y;
                  _566 = _553.z;
                }
              } else {
                _564 = 0.0f;
                _565 = 0.0f;
                _566 = 0.0f;
              }
              _568 = (float)((uint)_511);
              [branch]
              if (_393 > 0.0f) {
                _572 = mad(_476, _389, mad(_475, _388, (_474 * _387)));
                _575 = mad(_482, _389, mad(_481, _388, (_480 * _387)));
                _578 = mad(_488, _389, mad(_487, _388, (_486 * _387)));
                _619 = min(((((float((int)(((int)(uint)((int)(_572 > 0.0f))) - ((int)(uint)((int)(_572 < 0.0f))))) * _495) - _477) - mad(_476, _315, mad(_475, _314, (_474 * _313)))) / _572), min(((((float((int)(((int)(uint)((int)(_575 > 0.0f))) - ((int)(uint)((int)(_575 < 0.0f))))) * _496) - _483) - mad(_482, _315, mad(_481, _314, (_480 * _313)))) / _575), ((((float((int)(((int)(uint)((int)(_578 > 0.0f))) - ((int)(uint)((int)(_578 < 0.0f))))) * _497) - _489) - mad(_488, _315, mad(_487, _314, (_486 * _313)))) / _578)));
                _624 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _315, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _314, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _313))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _500) + (_619 * _408);
                _626 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _315, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _314, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _313))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _501) + (_619 * _411);
                _628 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _315, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _314, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _313))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _502) + (_619 * _414);
                _635 = (max(log2((_619 * _619) / dot(float3(_624, _626, _628), float3(_624, _626, _628))), -1.0f) * 0.3333333432674408f) + _361;
                _636 = -0.0f - _624;
                [branch]
                if (!(_568 >= 341.0f)) {
                  _648 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_636, _626, _628, _568), _635);
                  _653 = _648.x;
                  _654 = _648.y;
                  _655 = _648.z;
                } else {
                  _642 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_636, _626, _628, (_568 + -341.0f)), _635);
                  _653 = _642.x;
                  _654 = _642.y;
                  _655 = _642.z;
                }
              } else {
                _653 = 0.0f;
                _654 = 0.0f;
                _655 = 0.0f;
              }
              _668 = (_543 * f16tof32(((uint)((uint)(_505) >> 16)))) * (lerp(_564, _653, _393));
              _669 = (_543 * f16tof32(_505)) * (lerp(_565, _654, _393));
              _670 = (_543 * f16tof32(((uint)((uint)(_508) >> 16)))) * (lerp(_566, _655, _393));
              [branch]
              if (!((_451 & ((int)(1 << (_329 & 31)))) == 0)) {
                _681 = (_668 + _435);
                _682 = (_669 + _436);
                _683 = (_670 + _437);
                _684 = (_543 + _438);
              } else {
                _681 = _435;
                _682 = _436;
                _683 = _437;
                _684 = _438;
              }
              [branch]
              if (!((_451 & ((int)(1 << (_331 & 31)))) == 0)) {
                _695 = _681;
                _696 = _682;
                _697 = _683;
                _698 = _684;
                _699 = (_668 + _439);
                _700 = (_669 + _440);
                _701 = (_670 + _441);
                _702 = (_543 + _442);
              } else {
                _695 = _681;
                _696 = _682;
                _697 = _683;
                _698 = _684;
                _699 = _439;
                _700 = _440;
                _701 = _441;
                _702 = _442;
              }
            } else {
              _695 = _435;
              _696 = _436;
              _697 = _437;
              _698 = _438;
              _699 = _439;
              _700 = _440;
              _701 = _441;
              _702 = _442;
            }
            _703 = _434 + 1;
            if (!(_703 == (_350 & 255))) {
              _434 = _703;
              _435 = _695;
              _436 = _696;
              _437 = _697;
              _438 = _698;
              _439 = _699;
              _440 = _700;
              _441 = _701;
              _442 = _702;
              continue;
            }
            _707 = _695;
            _708 = _696;
            _709 = _697;
            _710 = _698;
            _711 = _699;
            _712 = _700;
            _713 = _701;
            _714 = _702;
            break;
          }
        } else {
          _707 = 0.0f;
          _708 = 0.0f;
          _709 = 0.0f;
          _710 = 0.0f;
          _711 = 0.0f;
          _712 = 0.0f;
          _713 = 0.0f;
          _714 = 0.0f;
        }
        _720 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_329 & 31)))) != 0);
        if ((_336 > 0.0f) || ((_339 > 0.0f) || _720)) {
          _730 = srvFallbackInfo[((_330 << 2) | 3)].x;
          _732 = select(_720, 9.999999747378752e-05f, (_338 * 3.921568847431445e-09f));
          _733 = _710 * 0.20000000298023224f;
          _740 = saturate((_732 - _733) / (((_710 * 0.4000000059604645f) + 9.99999993922529e-09f) - _733)) * _732;
          [branch]
          if (_740 > 0.0f) {
            [branch]
            if ((int)_730 > (int)-1) {
              _745 = float((int)(_730));
              _746 = -0.0f - _408;
              [branch]
              if (!(_745 >= 341.0f)) {
                _758 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_746, _411, _414, _745), _361);
                _763 = _758.x;
                _764 = _758.y;
                _765 = _758.z;
              } else {
                _752 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_746, _411, _414, (_745 + -341.0f)), _361);
                _763 = _752.x;
                _764 = _752.y;
                _765 = _752.z;
              }
              _773 = ((_763 * _740) + _707);
              _774 = ((_764 * _740) + _708);
              _775 = ((_765 * _740) + _709);
            } else {
              _773 = _707;
              _774 = _708;
              _775 = _709;
            }
            _778 = (_740 + _710);
            _779 = _773;
            _780 = _774;
            _781 = _775;
          } else {
            _778 = _710;
            _779 = _707;
            _780 = _708;
            _781 = _709;
          }
          if (_778 > 0.0f) {
            _787 = (cbSharedPerViewData.vHDRScale.x * _336) / _778;
            _792 = (_787 * _779);
            _793 = (_787 * _780);
            _794 = (_787 * _781);
          } else {
            _792 = 0.0f;
            _793 = 0.0f;
            _794 = 0.0f;
          }
        } else {
          _792 = 0.0f;
          _793 = 0.0f;
          _794 = 0.0f;
        }
        [branch]
        if (!(_339 == 0.0f)) {
          _801 = srvFallbackInfo[((_332 << 2) | 3)].x;
          _802 = _338 * 3.921568847431445e-09f;
          [branch]
          if ((int)_801 > (int)-1) {
            _805 = float((int)(_801));
            _806 = -0.0f - _408;
            [branch]
            if (!(_805 >= 341.0f)) {
              _818 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_806, _411, _414, _805), _361);
              _823 = _818.x;
              _824 = _818.y;
              _825 = _818.z;
            } else {
              _812 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_806, _411, _414, (_805 + -341.0f)), _361);
              _823 = _812.x;
              _824 = _812.y;
              _825 = _812.z;
            }
            _833 = ((_823 * _802) + _711);
            _834 = ((_824 * _802) + _712);
            _835 = ((_825 * _802) + _713);
          } else {
            _833 = _711;
            _834 = _712;
            _835 = _713;
          }
          _840 = (cbSharedPerViewData.vHDRScale.x * _339) / (_714 + _802);
          _848 = ((_840 * _833) + _792);
          _849 = ((_840 * _834) + _793);
          _850 = ((_840 * _835) + _794);
        } else {
          _848 = _792;
          _849 = _793;
          _850 = _794;
        }
      } else {
        _848 = 0.0f;
        _849 = 0.0f;
        _850 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _855 = 0.0f;
        _856 = 0.0f;
        _857 = 0.0f;
      } else {
        _855 = _848;
        _856 = _849;
        _857 = _850;
      }
      _859 = saturate(dot(float3(_322, _323, _321), float3(_147, _148, _149)));
      _862 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_859, _217), 0.0f);
      _865 = _862.x + _862.y;
      _866 = 1.0f - _865;
      _870 = max(9.999999747378752e-06f, _865);
      _874 = ((_866 * _201) / _870) + 1.0f;
      _875 = ((_866 * _202) / _870) + 1.0f;
      _876 = ((_866 * _203) / _870) + 1.0f;
      _883 = min(_265, 1.0f);
      if (!(_353 == 0)) {
        _888 = 0;
        _889 = _883;
        while(true) {
          _1014 = _889;
          _895 = srvDeferredClusters[((int)((((uint)(_351 + 1)) + _346) + _888))];
          _896 = _895 & 4095;
          _899 = srvLightInfoBase[_896].nRoomMask;
          _901 = srvLightInfoBase[_896].nBufferOffset;
          _905 = (int)((int)(_899 << (((int)(31u - _329)) & 31))) >> 31;
          _909 = (int)((int)(_899 << ((31 - _331) & 31))) >> 31;
          _921 = saturate((asfloat((_905 & asint(_336))) + asfloat((_909 & asint(_339)))) + asfloat(((_909 & 1065353216) & _905)));
          [branch]
          if (!(_921 == 0.0f)) {
            _926 = asfloat(srvLightInfoProperties.Load4(_901)).x;
            _927 = asfloat(srvLightInfoProperties.Load4(_901)).y;
            _928 = asfloat(srvLightInfoProperties.Load4(_901)).z;
            _929 = asfloat(srvLightInfoProperties.Load4(_901)).w;
            _932 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 16u)))).x;
            _933 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 16u)))).y;
            _934 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 16u)))).z;
            _935 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 16u)))).w;
            _938 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 32u)))).x;
            _939 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 32u)))).y;
            _940 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 32u)))).z;
            _941 = asfloat(srvLightInfoProperties.Load4(((int)(_901 + 32u)))).w;
            _944 = asint(srvLightInfoProperties.Load(((int)(_901 + 48u))));
            _947 = asint(srvLightInfoProperties.Load(((int)(_901 + 52u))));
            _950 = asint(srvLightInfoProperties.Load(((int)(_901 + 56u))));
            _953 = asint(srvLightInfoProperties.Load(((int)(_901 + 60u))));
            _968 = mad(_928, _315, mad(_927, _314, (_926 * _313))) + _929;
            _972 = mad(_934, _315, mad(_933, _314, (_932 * _313))) + _935;
            _976 = mad(_940, _315, mad(_939, _314, (_938 * _313))) + _941;
            _1001 = saturate(1.0f - ((_968 + 1.0f) * f16tof32(_947))) + saturate(1.0f - ((1.0f - _968) * f16tof32(((uint)((uint)(_947) >> 16)))));
            _1002 = saturate(1.0f - ((_972 + 1.0f) * f16tof32(_950))) + saturate(1.0f - ((1.0f - _972) * f16tof32(((uint)((uint)(_950) >> 16)))));
            _1003 = saturate(1.0f - ((_976 + 1.0f) * f16tof32(_953))) + saturate(1.0f - ((1.0f - _976) * f16tof32(((uint)((uint)(_953) >> 16)))));
            _1006 = saturate(1.0f - dot(float3(_1001, _1002, _1003), float3(_1001, _1002, _1003)));
            _1014 = (saturate(1.0f - ((_1006 * _1006) * (f16tof32(((uint)((uint)(_944) >> 16))) * _921))) * _889);
          } else {
            _1014 = _889;
          }
          _1015 = _888 + 1;
          if (!(_1015 == (_352 & 255))) {
            _888 = _1015;
            _889 = _1014;
            continue;
          }
          _1019 = _1014;
          break;
        }
      } else {
        _1019 = _883;
      }
      if (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f) {
        _1034 = saturate((_1019 + -1.0f) + exp2((_217 * _217) * log2(max((_1019 + _859), 0.0f))));
      } else {
        _1034 = _1019;
      }
      _1037 = ((_874 * _855) * ((_862.x * _201) + _862.y)) * _1034;
      _1040 = ((((_862.x * _202) + _862.y) * _856) * _875) * _1034;
      _1043 = ((((_862.x * _203) + _862.y) * _857) * _876) * _1034;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1048 = _1019;
      } else {
        _1048 = 1.0f;
      }
      if (_336 > 0.0f) {
        _1051 = _330 * 3;
        _1054 = srvRoomInfo[_1051].x;
        _1055 = srvRoomInfo[_1051].y;
        _1056 = srvRoomInfo[_1051].z;
        _1062 = srvRoomInfo[(_1051 + 1)].x;
        _1063 = srvRoomInfo[(_1051 + 1)].y;
        _1064 = srvRoomInfo[(_1051 + 1)].z;
        _1070 = srvRoomInfo[(_1051 + 2)].x;
        _1071 = srvRoomInfo[(_1051 + 2)].y;
        _1072 = srvRoomInfo[(_1051 + 2)].z;
        _1078 = saturate(dot(float3(_147, _148, _149), float3(asfloat(_1054), asfloat(_1055), asfloat(_1056))) + 0.5f);
        _1082 = (_1078 * _1078) * (3.0f - (_1078 * 2.0f));
        _1086 = 1.0f - _1082;
        _1093 = _1048 * _336;
        _1098 = (_1093 * ((_1086 * asfloat(_1070)) + (_1082 * asfloat(_1062))));
        _1099 = (_1093 * ((_1086 * asfloat(_1071)) + (_1082 * asfloat(_1063))));
        _1100 = (_1093 * ((_1086 * asfloat(_1072)) + (_1082 * asfloat(_1064))));
      } else {
        _1098 = 0.0f;
        _1099 = 0.0f;
        _1100 = 0.0f;
      }
      if (_339 > 0.0f) {
        _1103 = _332 * 3;
        _1106 = srvRoomInfo[_1103].x;
        _1107 = srvRoomInfo[_1103].y;
        _1108 = srvRoomInfo[_1103].z;
        _1114 = srvRoomInfo[(_1103 + 1)].x;
        _1115 = srvRoomInfo[(_1103 + 1)].y;
        _1116 = srvRoomInfo[(_1103 + 1)].z;
        _1122 = srvRoomInfo[(_1103 + 2)].x;
        _1123 = srvRoomInfo[(_1103 + 2)].y;
        _1124 = srvRoomInfo[(_1103 + 2)].z;
        _1130 = saturate(dot(float3(_147, _148, _149), float3(asfloat(_1106), asfloat(_1107), asfloat(_1108))) + 0.5f);
        _1134 = (_1130 * _1130) * (3.0f - (_1130 * 2.0f));
        _1138 = 1.0f - _1134;
        _1145 = _1048 * _339;
        _1153 = ((_1145 * ((_1138 * asfloat(_1122)) + (_1134 * asfloat(_1114)))) + _1098);
        _1154 = ((_1145 * ((_1138 * asfloat(_1123)) + (_1134 * asfloat(_1115)))) + _1099);
        _1155 = ((_1145 * ((_1138 * asfloat(_1124)) + (_1134 * asfloat(_1116)))) + _1100);
      } else {
        _1153 = _1098;
        _1154 = _1099;
        _1155 = _1100;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1181 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _315, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _314, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _313))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1185 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _315, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _314, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _313))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1189 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _315, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _314, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _313))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1208 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1189, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1185, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1181))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1212 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1189, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1185, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1181))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1216 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1189, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1185, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1181))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1229 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1230 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1231 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1268 = min(min(saturate((_1208 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1229), 9.999999747378752e-06f)), saturate((1.0f - _1208) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1229), 9.999999747378752e-06f))), min(min(saturate((_1212 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1230), 9.999999747378752e-06f)), saturate((1.0f - _1212) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1230), 9.999999747378752e-06f))), min(saturate((_1216 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1231), 9.999999747378752e-06f)), saturate((1.0f - _1216) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1231), 9.999999747378752e-06f)))));
      } else {
        _1268 = 0.0f;
      }
      _1269 = _351 + _353;
      if ((uint)_1269 < (uint)(_349 & 255)) {
        _1274 = _1153;
        _1275 = _1154;
        _1276 = _1155;
        _1277 = _1037;
        _1278 = _1040;
        _1279 = _1043;
        _1280 = _1269;
        while(true) {
          _13729 = _1274;
          _13730 = _1275;
          _13731 = _1276;
          _13732 = _1277;
          _13733 = _1278;
          _13734 = _1279;
          _1285 = srvDeferredClusters[((int)(((uint)(_346 | 1)) + _1280))];
          _1286 = _1285 & 4095;
          _1289 = srvLightInfoBase[_1286].nFlags;
          _1291 = srvLightInfoBase[_1286].nRoomMask;
          _1293 = srvLightInfoBase[_1286].nBufferOffset;
          [branch]
          if ((((_154 & 64) != 0) || ((_1289 & 8388608) == 0)) && (((!(_159 >= 0.0235294122248888f)) && (_218 != 0)) || ((_1289 & 16777216) == 0))) {
            _1305 = (int)((int)(_1291 << (((int)(31u - _329)) & 31))) >> 31;
            _1309 = (int)((int)(_1291 << ((31 - _331) & 31))) >> 31;
            _1321 = saturate((asfloat((_1305 & asint(_336))) + asfloat((_1309 & asint(_339)))) + asfloat(((_1309 & 1065353216) & _1305)));
            [branch]
            if (!(_1321 == 0.0f)) {
              _1324 = (uint)(_1285) >> 12;
              if (_1324 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _3948 = (_1321 * select(((_1289 & 67108864) != 0), 1.0f, (1.0f - _1268)));
                } else {
                  _3948 = _1321;
                }
                _3951 = asfloat(srvLightInfoProperties.Load4(_1293)).x;
                _3952 = asfloat(srvLightInfoProperties.Load4(_1293)).y;
                _3953 = asfloat(srvLightInfoProperties.Load4(_1293)).z;
                _3954 = asfloat(srvLightInfoProperties.Load4(_1293)).w;
                _3957 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).x;
                _3958 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).y;
                _3959 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).z;
                _3960 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).w;
                _3963 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).x;
                _3964 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).y;
                _3965 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).z;
                _3968 = asint(srvLightInfoProperties.Load(((int)(_1293 + 68u))));
                _3971 = asint(srvLightInfoProperties.Load(((int)(_1293 + 72u))));
                _3974 = asint(srvLightInfoProperties.Load(((int)(_1293 + 76u))));
                _3977 = asint(srvLightInfoProperties.Load(((int)(_1293 + 84u))));
                _3980 = asint(srvLightInfoProperties.Load(((int)(_1293 + 88u))));
                _3983 = asint(srvLightInfoProperties.Load(((int)(_1293 + 92u))));
                _3987 = ((float)((uint)((uint)(((uint)(_3968) >> 8) & 255)))) * 0.003921499941498041f;
                _3990 = ((float)((uint)((uint)(_3968 & 255)))) * 0.003921499941498041f;
                _3992 = f16tof32(((uint)((uint)(_3971) >> 16)));
                _3994 = (uint)(_3974) >> 16;
                _4014 = srvDeferredShadingEvaluateAdaptationPass_DeferredShadows.Load(int3(_65, _66, 0));
                [branch]
                if (!(_4014.x == 0.0f)) {
                  [branch]
                  if (!(_3994 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3994)))];
                    _4031 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3953, _315, mad(_3952, _314, (_3951 * _313))) + _3954) * f16tof32(((uint)((uint)(_3980) >> 16)))) + f16tof32(((uint)((uint)(_3983) >> 16)))), (((mad(_3959, _315, mad(_3958, _314, (_3957 * _313))) + _3960) * f16tof32(_3980)) + f16tof32(_3983))), 0.0f);
                    _4039 = (_4031.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _4040 = (_4031.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _4041 = (_4031.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _4039 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _4040 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _4041 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  _4044 = min(_4014.x, _4014.y) * _3948;
                  [branch]
                  if (_4044 > 0.0f) {
                    _4047 = dot(float3(_3963, _3964, _3965), float3(_3963, _3964, _3965));
                    _4048 = rsqrt(_4047);
                    _4049 = _4048 * _3963;
                    _4050 = _4048 * _3964;
                    _4051 = _4048 * _3965;
                    _4052 = dot(float3(_147, _148, _149), float3(_4049, _4050, _4051));
                    if (_3992 > 0.0f) {
                      _4060 = sqrt(saturate((_3992 * _3992) * (1.0f / (_4047 + 1.0f))));
                      if (_4052 < _4060) {
                        _4065 = max(_4052, (-0.0f - _4060)) + _4060;
                        _4070 = ((_4065 * _4065) / (_4060 * 4.0f));
                      } else {
                        _4070 = _4052;
                      }
                    } else {
                      _4070 = _4052;
                    }
                    _4071 = _217 * _217;
                    _4072 = 1.0f - _4071;
                    _4075 = saturate((_3992 * _4072) * _4048);
                    _4077 = saturate(_4048 * f16tof32(_3971));
                    _4080 = (_159 >= 0.003921568859368563f) && (_159 < 0.007843137718737125f);
                    if (_4080) {
                      _4082 = saturate(_4052);
                      _4089 = (_4082 * (_147 - _289)) + _289;
                      _4090 = (_4082 * (_148 - _290)) + _290;
                      _4091 = (_4082 * (_149 - _291)) + _291;
                      _4093 = rsqrt(dot(float3(_4089, _4090, _4091), float3(_4089, _4090, _4091)));
                      _4098 = (_4089 * _4093);
                      _4099 = (_4090 * _4093);
                      _4100 = (_4091 * _4093);
                    } else {
                      _4098 = _147;
                      _4099 = _148;
                      _4100 = _149;
                    }
                    _4101 = dot(float3(_4098, _4099, _4100), float3(_4049, _4050, _4051));
                    _4102 = dot(float3(_4098, _4099, _4100), float3(_322, _323, _321));
                    _4103 = dot(float3(_322, _323, _321), float3(_4049, _4050, _4051));
                    _4106 = rsqrt((_4103 * 2.0f) + 2.0f);
                    _4109 = saturate(_4106 * (_4102 + _4101));
                    _4112 = saturate((_4106 * _4103) + _4106);
                    _4113 = (_4075 > 0.0f);
                    if (_4113) {
                      _4117 = sqrt(1.0f - (_4075 * _4075));
                      _4119 = (_4101 * 2.0f) * _4102;
                      _4120 = _4119 - _4103;
                      if (!(_4120 >= _4117)) {
                        _4128 = rsqrt(1.0f - (_4120 * _4120)) * _4075;
                        _4131 = _4128 * (_4102 - (_4120 * _4101));
                        _4132 = _4102 * _4102;
                        _4137 = _4128 * (((_4132 * 2.0f) + -1.0f) - (_4120 * _4103));
                        _4146 = sqrt(saturate((((1.0f - (_4101 * _4101)) - _4132) - (_4103 * _4103)) + (_4119 * _4103)));
                        _4147 = _4146 * _4128;
                        _4150 = ((_4102 * 2.0f) * _4128) * _4146;
                        _4152 = (_4117 * _4101) + _4102;
                        _4153 = _4152 + _4131;
                        _4154 = _4117 * _4103;
                        _4156 = (_4154 + 1.0f) + _4137;
                        _4157 = _4147 * _4156;
                        _4158 = _4153 * _4156;
                        _4159 = _4150 * _4153;
                        _4164 = (((_4153 * 0.25f) * _4150) - (_4157 * 0.5f)) * _4158;
                        _4178 = (((_4159 - (_4157 * 2.0f)) * _4159) + (_4157 * _4157)) + ((((-0.5f - ((_4156 + _4154) * 0.5f)) * _4158) + ((_4156 * _4156) * _4152)) * _4153);
                        _4183 = (_4164 * 2.0f) / ((_4178 * _4178) + (_4164 * _4164));
                        _4184 = _4178 * _4183;
                        _4186 = 1.0f - (_4164 * _4183);
                        _4192 = ((_4184 * _4150) + _4154) + (_4186 * _4137);
                        _4195 = rsqrt((_4192 * 2.0f) + 2.0f);
                        _4204 = saturate((_4192 * _4195) + _4195);
                        _4205 = saturate(((_4152 + (_4184 * _4147)) + (_4186 * _4131)) * _4195);
                      } else {
                        _4204 = abs(_4102);
                        _4205 = 1.0f;
                      }
                    } else {
                      _4204 = _4112;
                      _4205 = _4109;
                    }
                    _4206 = saturate(_4102);
                    _4207 = saturate(_4070);
                    _4208 = saturate(_4101);
                    _4209 = _4071 * _4071;
                    _4210 = (_4077 > 0.0f);
                    if (_4210) {
                      _4219 = saturate(((_4077 * _4077) / ((_4204 * 3.5999999046325684f) + 0.4000000059604645f)) + _4209);
                    } else {
                      _4219 = _4209;
                    }
                    _4220 = sqrt(_4219);
                    if (_4113) {
                      _4231 = (_4219 / ((((_4075 * 0.25f) * ((_4220 * 3.0f) + _4075)) / (_4204 + 0.0010000000474974513f)) + _4219));
                    } else {
                      _4231 = 1.0f;
                    }
                    _4235 = (((_4219 * _4205) - _4205) * _4205) + 1.0f;
                    _4238 = (_4219 / (_4235 * _4235)) * _4231;
                    _4239 = 1.0f - _201;
                    _4240 = 1.0f - _202;
                    _4241 = 1.0f - _203;
                    _4242 = saturate(_4204);
                    _4243 = 1.0f - _4242;
                    _4244 = log2(_4243);
                    _4246 = exp2(_4244 * 5.0f);
                    _4250 = (_4246 * _4239) + _201;
                    _4251 = (_4246 * _4240) + _202;
                    _4252 = (_4246 * _4241) + _203;
                    _4253 = abs(_4102);
                    _4255 = saturate(_4253 + 9.999999747378752e-06f);
                    _4256 = 1.0f - _4220;
                    _4264 = 0.5f / ((((_4256 * _4255) + _4220) * _4207) + (((_4256 * _4207) + _4220) * _4255));
                    if (_162) {
                      _4274 = ((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                      _4275 = ((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                      _4276 = ((_115 + -0.5f) * 0.5f) + 0.5f;
                      _4293 = ((dot(float3((-0.0f - _4098), (-0.0f - _4099), (-0.0f - _4100)), float3(_4049, _4050, _4051)) + dot(float3((-0.0f - _322), (-0.0f - _323), (-0.0f - _321)), float3(_4049, _4050, _4051))) * 0.5f) * exp2(log2(1.0f - _4206) * (11.0f - (((float)((uint)((uint)((uint)(_259) >> 2)))) * 0.1666666716337204f)));
                      _4300 = dot(float3(_113, _114, _115), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                      _4303 = saturate((_4300 + -0.009999999776482582f) * -100.0f);
                      _4308 = ((_4303 * _4303) * 3.0f) * (3.0f - (_4303 * 2.0f));
                      _4315 = 10.0f - (exp2(log2(saturate(_4300 * 5.0f)) * 3.0f) * 9.0f);
                      _4316 = saturate(_4208 + _4274) * _4208;
                      _4317 = saturate(_4208 + _4275) * _4208;
                      _4318 = saturate(_4208 + _4276) * _4208;
                      _4337 = (max(((_4308 + _4274) * _4293), 0.0f) * _4315) + sqrt(_4316 * _4316);
                      _4338 = (max(((_4308 + _4275) * _4293), 0.0f) * _4315) + sqrt(_4317 * _4317);
                      _4339 = (max(((_4308 + _4276) * _4293), 0.0f) * _4315) + sqrt(_4318 * _4318);
                      _4340 = _4049 + _322;
                      _4341 = _4050 + _323;
                      _4342 = _4051 + _321;
                      _4344 = rsqrt(dot(float3(_4340, _4341, _4342), float3(_4340, _4341, _4342)));
                      if (!(select((_258 != 0), 1.0f, 0.0f) < 1.0f)) {
                        _4358 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                        _4359 = _4358 * _147;
                        _4360 = _4358 * _148;
                        _4361 = _4358 * _149;
                        _4364 = (abs(_4359) < abs(_4360));
                        _4365 = select(_4364, 1.0f, 0.0f);
                        _4366 = select(_4364, 0.0f, 1.0f);
                        _4367 = _4366 * _4361;
                        _4369 = -0.0f - (_4361 * _4365);
                        _4372 = (_4365 * _4360) - (_4366 * _4359);
                        _4374 = rsqrt(dot(float3(_4367, _4369, _4372), float3(_4367, _4369, _4372)));
                        _4375 = _4367 * _4374;
                        _4376 = _4374 * _4369;
                        _4377 = _4372 * _4374;
                        _4380 = (_4376 * _4361) - (_4377 * _4360);
                        _4383 = (_4377 * _4359) - (_4375 * _4361);
                        _4386 = (_4375 * _4360) - (_4376 * _4359);
                        _4388 = rsqrt(dot(float3(_4380, _4383, _4386), float3(_4380, _4383, _4386)));
                        _4400 = saturate(abs(_257 + -2.5f) + -0.5f) + -0.5f;
                        _4401 = saturate(1.5f - abs(_257 + -1.5f)) + -0.5f;
                        _4403 = rsqrt(dot(float2(_4400, _4401), float2(_4400, _4401)));
                        _4404 = _4403 * _4400;
                        _4405 = _4403 * _4401;
                        _4412 = ((_4380 * _4388) * _4404) + (_4405 * _4375);
                        _4413 = ((_4383 * _4388) * _4404) + (_4405 * _4376);
                        _4414 = ((_4386 * _4388) * _4404) + (_4405 * _4377);
                        _4417 = min(max(dot(float3(_4412, _4413, _4414), float3(_4049, _4050, _4051)), -1.0f), 1.0f);
                        _4420 = min(max(dot(float3(_4412, _4413, _4414), float3(_322, _323, _321)), -1.0f), 1.0f);
                        _4421 = abs(_4420);
                        _4426 = (1.5707963705062866f - (_4421 * 0.1565829962491989f)) * sqrt(1.0f - _4421);
                        _4430 = abs(_4417);
                        _4435 = (1.5707963705062866f - (_4430 * 0.1565829962491989f)) * sqrt(1.0f - _4430);
                        _4442 = cos(abs(select((_4417 >= 0.0f), _4435, (3.1415927410125732f - _4435)) - select((_4420 >= 0.0f), _4426, (3.1415927410125732f - _4426))) * 0.5f);
                        _4446 = _4049 - (_4417 * _4412);
                        _4447 = _4050 - (_4417 * _4413);
                        _4448 = _4051 - (_4417 * _4414);
                        _4452 = _322 - (_4420 * _4412);
                        _4453 = _323 - (_4420 * _4413);
                        _4454 = _321 - (_4420 * _4414);
                        _4461 = rsqrt((dot(float3(_4452, _4453, _4454), float3(_4452, _4453, _4454)) * dot(float3(_4446, _4447, _4448), float3(_4446, _4447, _4448))) + 9.999999747378752e-05f) * dot(float3(_4446, _4447, _4448), float3(_4452, _4453, _4454));
                        _4465 = sqrt(saturate((_4461 * 0.5f) + 0.5f));
                        _4469 = _4071 * 0.5f;
                        _4470 = _4071 * 2.0f;
                        _4473 = select((((_259 & 1) != 0) && (select(((_259 & 2) != 0), 1.0f, 0.0f) == 0.0f)), 0.0f, 1.0f);
                        _4476 = saturate((_4052 + 0.5f) * 0.6666666865348816f);
                        _4486 = (_4420 + _4417) + ((((_4465 * 0.9975510239601135f) * sqrt(1.0f - (_4420 * _4420))) - (_4420 * 0.06994284689426422f)) * 0.13988569378852844f);
                        _4488 = (_4071 * 1.4142135381698608f) * _4465;
                        _4501 = 1.0f - sqrt(saturate((_4103 * 0.5f) + 0.5f));
                        _4502 = _4501 * _4501;
                        _4508 = saturate(-0.0f - _4103);
                        _4511 = (1.0f - saturate(_4508)) * _4476;
                        _4520 = ((((_4465 * 0.5f) * (exp2((((_4486 * _4486) * -0.5f) / (_4488 * _4488)) * 1.4426950216293335f) / (_4488 * 2.5066282749176025f))) * min(_205, 0.5f)) * (((_4502 * _4502) * (_4501 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_4511, 1.0f, _4473));
                        _4522 = (_4417 + -0.03500000014901161f) + _4420;
                        _4531 = 1.0f / ((1.190000057220459f / _4442) + (_4442 * 0.36000001430511475f));
                        _4536 = ((_4531 * (0.6000000238418579f - (_4461 * 0.800000011920929f))) + 1.0f) * _4465;
                        _4542 = 1.0f - (sqrt(saturate(1.0f - (_4536 * _4536))) * _4442);
                        _4543 = _4542 * _4542;
                        _4547 = 0.9534794092178345f - ((_4543 * _4543) * (_4542 * 0.9534794092178345f));
                        _4548 = _4536 * _4531;
                        _4553 = (sqrt(1.0f - (_4548 * _4548)) * 0.5f) / _4442;
                        _4572 = 1.0f - saturate((_4508 + -0.44999998807907104f) * 2.222222328186035f);
                        _4575 = ((1.0f - _4476) * _4473) + _4476;
                        _4578 = ((_4547 * _4547) * (exp2((((_4522 * _4522) * -0.5f) / (_4469 * _4469)) * 1.4426950216293335f) / (_4071 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_4461 * 5.2658371925354f));
                        _4592 = (_4417 + -0.14000000059604645f) + _4420;
                        _4602 = 1.0f - (_4442 * 0.5f);
                        _4603 = _4602 * _4602;
                        _4607 = (_4603 * _4603) * (0.9534794092178345f - (_4442 * 0.47673970460891724f));
                        _4609 = 0.9534794092178345f - _4607;
                        _4611 = (_4609 * _4609) * (_4607 + 0.04652056470513344f);
                        _4614 = exp2((_4461 * 24.525815963745117f) + -24.208423614501953f);
                        _4627 = ((exp2((((_4592 * _4592) * -0.5f) / (_4470 * _4470)) * 1.4426950216293335f) / (_4071 * 5.013256549835205f)) * (lerp(_4611, 1.0f, _170))) * (((exp2((saturate(dot(float3((_4344 * _4340), (_4344 * _4341), (_4344 * _4342)), float3(_147, _148, _149))) * 17.312339782714844f) + -14.109557151794434f) - _4614) * _170) + _4614);
                        _5339 = (((((exp2(log2(max(_113, 0.0f)) * _4553) * _4575) * _4578) * _4572) + _4520) + (_4627 * _113));
                        _5340 = (((((exp2(log2(max(_114, 0.0f)) * _4553) * _4575) * _4578) * _4572) + _4520) + (_4627 * _114));
                        _5341 = (((((exp2(log2(max(_115, 0.0f)) * _4553) * _4575) * _4578) * _4572) + _4520) + (_4627 * _115));
                        _5342 = _4337;
                        _5343 = _4338;
                        _5344 = _4339;
                      } else {
                        _5339 = 0.0f;
                        _5340 = 0.0f;
                        _5341 = 0.0f;
                        _5342 = _4337;
                        _5343 = _4338;
                        _5344 = _4339;
                      }
                    } else {
                      if (_4080) {
                        _4645 = ((float)((uint)((uint)(_261 & 15)))) * 0.06666667014360428f;
                        _4646 = _217 * 0.0317460335791111f;
                        _4649 = min(1.0f, max((_4646 * ((float)((uint)((uint)((uint)(_260) >> 2))))), 0.019999999552965164f));
                        _4652 = min(1.0f, max((_4646 * ((float)((uint)((uint)((((int)(_260 << 4)) & 48) | ((uint)(_261) >> 4)))))), 0.019999999552965164f));
                        _4655 = ((_4652 - _4649) * _4645) + _4649;
                        _4656 = _4655 * _4655;
                        _4660 = saturate(abs(_4206) + 9.999999747378752e-06f);
                        _4661 = sqrt(_4656 * _4656);
                        _4662 = 1.0f - _4661;
                        _4671 = _4649 * _4649;
                        _4672 = _4671 * _4671;
                        if (_4210) {
                          _4681 = saturate(((_4077 * _4077) / ((_4204 * 3.5999999046325684f) + 0.4000000059604645f)) + _4672);
                        } else {
                          _4681 = _4672;
                        }
                        if (_4113) {
                          _4693 = (_4681 / ((((_4075 * 0.25f) * ((sqrt(_4681) * 3.0f) + _4075)) / (_4204 + 0.0010000000474974513f)) + _4681));
                        } else {
                          _4693 = 1.0f;
                        }
                        _4694 = _4652 * _4652;
                        _4695 = _4694 * _4694;
                        if (_4210) {
                          _4704 = saturate(((_4077 * _4077) / ((_4204 * 3.5999999046325684f) + 0.4000000059604645f)) + _4695);
                        } else {
                          _4704 = _4695;
                        }
                        if (_4113) {
                          _4716 = (_4704 / ((((_4075 * 0.25f) * ((sqrt(_4704) * 3.0f) + _4075)) / (_4204 + 0.0010000000474974513f)) + _4704));
                        } else {
                          _4716 = 1.0f;
                        }
                        _4720 = (((_4681 * _4205) - _4205) * _4205) + 1.0f;
                        _4723 = (_4681 / (_4720 * _4720)) * _4693;
                        _4727 = (((_4704 * _4205) - _4205) * _4205) + 1.0f;
                        _4734 = saturate(_4205);
                        _4738 = saturate((_4101 + _3990) / (_3990 + 1.0f));
                        _4743 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_262)))) + 1u))]);
                        _4750 = ((float)((uint)((uint)((uint)((uint)(_4743.x)) >> 24)))) * 0.25f;
                        _4753 = ((float)((uint)((uint)(_4743.x & 255)))) * 0.003921568859368563f;
                        _4757 = ((float)((uint)((uint)(((uint)((uint)(_4743.x)) >> 8) & 255)))) * 0.003921568859368563f;
                        _4761 = ((float)((uint)((uint)(((uint)((uint)(_4743.x)) >> 16) & 255)))) * 0.003921568859368563f;
                        _4770 = ((float)((uint)((uint)((uint)((uint)(_4743.y)) >> 24)))) * 0.25f;
                        _4773 = ((float)((uint)((uint)(_4743.y & 255)))) * 0.003921568859368563f;
                        _4777 = ((float)((uint)((uint)(((uint)((uint)(_4743.y)) >> 8) & 255)))) * 0.003921568859368563f;
                        _4781 = ((float)((uint)((uint)(((uint)((uint)(_4743.y)) >> 16) & 255)))) * 0.003921568859368563f;
                        _4789 = (float)((uint)((uint)(_4743.w & 31)));
                        _4795 = (float)((uint)((uint)(((uint)((uint)(_4743.w)) >> 10) & 31)));
                        _4805 = (float)((uint)((uint)(((uint)((uint)(_4743.w)) >> 25) & 31)));
                        _4808 = ((float)((uint)((uint)(_4743.z & 255)))) * 0.003921568859368563f;
                        _4812 = ((float)((uint)((uint)(((uint)((uint)(_4743.z)) >> 8) & 255)))) * 0.003921568859368563f;
                        _4816 = ((float)((uint)((uint)(((uint)((uint)(_4743.z)) >> 16) & 255)))) * 0.003921568859368563f;
                        _4823 = (((float)((uint)((uint)((uint)((uint)(_4743.z)) >> 24)))) * 0.003921568859368563f) * select(((_4743.w & 1073741824) != 0), -1.0f, 1.0f);
                        _4837 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_4743.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _4242)));
                        _4838 = ((2.0f - (_4789 * 0.06451612710952759f)) > 0.0f);
                        if (_4838) {
                          _4849 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _4734))) * (10.0f - (_4789 * 0.32258063554763794f))) * _4837);
                        } else {
                          _4849 = _4837;
                        }
                        _4860 = exp2(log2(max(9.999999747378752e-06f, _4734)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_4743.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                        _4861 = ((2.0f - (_4795 * 0.06451612710952759f)) > 0.0f);
                        if (_4861) {
                          _4871 = (exp2(log2(max(9.999999747378752e-06f, _4243)) * (10.0f - (_4795 * 0.32258063554763794f))) * _4860);
                        } else {
                          _4871 = _4860;
                        }
                        if (_4838) {
                          _4885 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _4734))) * (10.0f - (_4789 * 0.32258063554763794f))) * _4837);
                        } else {
                          _4885 = _4837;
                        }
                        if (_4861) {
                          _4898 = (exp2(log2(max(9.999999747378752e-06f, _4243)) * (10.0f - (_4795 * 0.32258063554763794f))) * _4860);
                        } else {
                          _4898 = _4860;
                        }
                        if (_4838) {
                          _4912 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _4734))) * (10.0f - (_4789 * 0.32258063554763794f))) * _4837);
                        } else {
                          _4912 = _4837;
                        }
                        if (_4861) {
                          _4925 = (exp2(log2(max(9.999999747378752e-06f, _4243)) * (10.0f - (_4795 * 0.32258063554763794f))) * _4860);
                        } else {
                          _4925 = _4860;
                        }
                        _4937 = (1.0f - exp2(log2(1.0f - _4734) * 3.0f)) * (1.0f - exp2(_4244 * 3.0f));
                        _4941 = saturate(_4738 / (_4937 * (((float)((uint)((uint)(((uint)((uint)(_4743.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                        _4946 = ((_4941 * _4941) * (3.0f - (_4941 * 2.0f))) + -1.0f;
                        _4948 = ((((_4808 * _4808) * _4823) * _4937) * _4946) + 1.0f;
                        _4951 = ((((_4812 * _4812) * _4823) * _4937) * _4946) + 1.0f;
                        _4954 = ((((_4816 * _4816) * _4823) * _4937) * _4946) + 1.0f;
                        _4956 = saturate(_4805 * 0.06451612710952759f);
                        _4963 = exp2(log2(1.0f - _4204) * (10.0f - (_4805 * 0.32258063554763794f)));
                        _4982 = ((((((_4704 / (_4727 * _4727)) * _4716) - _4723) * _4645) + _4723) * (0.5f / ((((_4662 * _4660) + _4661) * _4207) + (((_4662 * _4207) + _4661) * _4660)))) * _4207;
                        _5339 = ((_4982 * _4948) * (((_4956 * _4239) * _4963) + _201));
                        _5340 = ((_4982 * _4951) * (((_4956 * _4240) * _4963) + _202));
                        _5341 = ((_4982 * _4954) * (((_4956 * _4241) * _4963) + _203));
                        _5342 = (((((_4849 * (((_4753 * _4753) * _4750) + -1.0f)) + 1.0f) * _4738) * ((_4871 * (((_4773 * _4773) * _4770) + -1.0f)) + 1.0f)) * _4948);
                        _5343 = (((((_4885 * (((_4757 * _4757) * _4750) + -1.0f)) + 1.0f) * _4738) * ((_4898 * (((_4777 * _4777) * _4770) + -1.0f)) + 1.0f)) * _4951);
                        _5344 = (((((_4912 * (((_4761 * _4761) * _4750) + -1.0f)) + 1.0f) * _4738) * ((_4925 * (((_4781 * _4781) * _4770) + -1.0f)) + 1.0f)) * _4954);
                      } else {
                        if (_191) {
                          if (_206 < 0.007874015718698502f) {
                            _4996 = _4205 * _4205;
                            _4998 = max((1.0f - _4996), 9.999999747378752e-05f);
                            _5136 = (((((((exp2(((-0.0f - (_4996 / _4998)) / _4219) * 1.4426950216293335f) * 4.0f) / (_4998 * _4998)) + 1.0f) * (1.0f / ((_4219 * 4.0f) + 1.0f))) - _4238) * _207) + _4238);
                            _5137 = (((saturate(0.25f / ((_4208 + _4206) - (_4208 * _4206))) - _4264) * _207) + _4264);
                          } else {
                            _5022 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                            _5023 = _5022 * _147;
                            _5024 = _5022 * _148;
                            _5025 = _5022 * _149;
                            _5028 = (abs(_5023) < abs(_5024));
                            _5029 = select(_5028, 1.0f, 0.0f);
                            _5030 = select(_5028, 0.0f, 1.0f);
                            _5031 = _5030 * _5025;
                            _5033 = -0.0f - (_5025 * _5029);
                            _5036 = (_5029 * _5024) - (_5030 * _5023);
                            _5038 = rsqrt(dot(float3(_5031, _5033, _5036), float3(_5031, _5033, _5036)));
                            _5039 = _5031 * _5038;
                            _5040 = _5038 * _5033;
                            _5041 = _5036 * _5038;
                            _5044 = (_5040 * _5025) - (_5041 * _5024);
                            _5047 = (_5041 * _5023) - (_5039 * _5025);
                            _5050 = (_5039 * _5024) - (_5040 * _5023);
                            _5052 = rsqrt(dot(float3(_5044, _5047, _5050), float3(_5044, _5047, _5050)));
                            _5056 = _207 * 4.0f;
                            _5065 = saturate(abs(_5056 + -2.5f) + -0.5f) + -0.5f;
                            _5066 = saturate(1.5f - abs(_5056 + -1.5f)) + -0.5f;
                            _5068 = rsqrt(dot(float2(_5065, _5066), float2(_5065, _5066)));
                            _5069 = _5068 * _5065;
                            _5070 = _5068 * _5066;
                            _5077 = ((_5044 * _5052) * _5069) + (_5070 * _5039);
                            _5078 = ((_5047 * _5052) * _5069) + (_5070 * _5040);
                            _5079 = ((_5050 * _5052) * _5069) + (_5070 * _5041);
                            _5082 = (_5078 * _149) - (_5079 * _148);
                            _5085 = (_5079 * _147) - (_5077 * _149);
                            _5088 = (_5077 * _148) - (_5078 * _147);
                            _5089 = dot(float3(_5077, _5078, _5079), float3(_4049, _4050, _4051));
                            _5090 = dot(float3(_5077, _5078, _5079), float3(_322, _323, _321));
                            _5093 = dot(float3(_5082, _5085, _5088), float3(_4049, _4050, _4051));
                            _5094 = dot(float3(_5082, _5085, _5088), float3(_322, _323, _321));
                            _5100 = min(max((_4071 * (_206 + 1.0f)), 0.0010000000474974513f), 1.0f);
                            _5104 = min(max((_4071 * (1.0f - _206)), 0.0010000000474974513f), 1.0f);
                            _5105 = _5104 * _5100;
                            _5106 = ((_5090 + _5089) * _4106) * _5104;
                            _5107 = ((_5094 + _5093) * _4106) * _5100;
                            _5108 = _5105 * _4109;
                            _5109 = dot(float3(_5106, _5107, _5108), float3(_5106, _5107, _5108));
                            _5114 = _5100 * _5090;
                            _5115 = _5104 * _5094;
                            _5123 = _5100 * _5089;
                            _5124 = _5104 * _5093;
                            _5136 = (((_5105 * _5105) * _5105) / (_5109 * _5109));
                            _5137 = saturate(0.5f / ((sqrt(((_5123 * _5123) + (_4208 * _4208)) + (_5124 * _5124)) * _4255) + (sqrt(((_5115 * _5115) + (_5114 * _5114)) + (_4255 * _4255)) * _4208)));
                          }
                          _5139 = (_5136 * _4208) * _5137;
                          _5157 = saturate((_4101 + 0.5f) * 0.6666666865348816f);
                          _5339 = (_5139 * _4250);
                          _5340 = (_5139 * _4251);
                          _5341 = (_5139 * _4252);
                          _5342 = ((_5157 * (1.0f - _4250)) * saturate((((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _4208));
                          _5343 = ((_5157 * (1.0f - _4251)) * saturate((((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _4208));
                          _5344 = ((_5157 * (1.0f - _4252)) * saturate((((_115 + -0.5f) * 0.5f) + 0.5f) + _4208));
                        } else {
                          if (_212) {
                            _5172 = _264 * _264;
                            _5173 = _5172 * _5172;
                            _5179 = saturate(select((_4072 > 0.0f), ((1.0f - _5172) / _4072), 0.0f) * _4075);
                            _5180 = (_5179 > 0.0f);
                            if (_5180) {
                              _5184 = sqrt(1.0f - (_5179 * _5179));
                              _5186 = (_4101 * 2.0f) * _4102;
                              _5187 = _5186 - _4103;
                              if (!(_5187 >= _5184)) {
                                _5193 = rsqrt(1.0f - (_5187 * _5187)) * _5179;
                                _5196 = _5193 * (_4102 - (_5187 * _4101));
                                _5197 = _4102 * _4102;
                                _5202 = _5193 * (((_5197 * 2.0f) + -1.0f) - (_5187 * _4103));
                                _5211 = sqrt(saturate((((1.0f - (_4101 * _4101)) - _5197) - (_4103 * _4103)) + (_5186 * _4103)));
                                _5212 = _5211 * _5193;
                                _5215 = ((_4102 * 2.0f) * _5193) * _5211;
                                _5217 = (_5184 * _4101) + _4102;
                                _5218 = _5217 + _5196;
                                _5219 = _5184 * _4103;
                                _5221 = (_5219 + 1.0f) + _5202;
                                _5222 = _5212 * _5221;
                                _5223 = _5218 * _5221;
                                _5224 = _5215 * _5218;
                                _5229 = (((_5218 * 0.25f) * _5215) - (_5222 * 0.5f)) * _5223;
                                _5243 = (((_5224 - (_5222 * 2.0f)) * _5224) + (_5222 * _5222)) + ((((-0.5f - ((_5221 + _5219) * 0.5f)) * _5223) + ((_5221 * _5221) * _5217)) * _5218);
                                _5248 = (_5229 * 2.0f) / ((_5243 * _5243) + (_5229 * _5229));
                                _5249 = _5243 * _5248;
                                _5251 = 1.0f - (_5229 * _5248);
                                _5257 = ((_5249 * _5215) + _5219) + (_5251 * _5202);
                                _5260 = rsqrt((_5257 * 2.0f) + 2.0f);
                                _5269 = saturate((_5257 * _5260) + _5260);
                                _5270 = saturate(((_5217 + (_5249 * _5212)) + (_5251 * _5196)) * _5260);
                              } else {
                                _5269 = _4253;
                                _5270 = 1.0f;
                              }
                            } else {
                              _5269 = _4112;
                              _5270 = _4109;
                            }
                            if (_4210) {
                              _5279 = saturate(((_4077 * _4077) / ((_5269 * 3.5999999046325684f) + 0.4000000059604645f)) + _5173);
                            } else {
                              _5279 = _5173;
                            }
                            _5280 = sqrt(_5279);
                            if (_5180) {
                              _5291 = (_5279 / ((((_5179 * 0.25f) * ((_5280 * 3.0f) + _5179)) / (_5269 + 0.0010000000474974513f)) + _5279));
                            } else {
                              _5291 = 1.0f;
                            }
                            _5295 = (((_5279 * _5270) - _5270) * _5270) + 1.0f;
                            _5305 = 1.0f - _5280;
                            _5320 = ((((exp2(log2(1.0f - saturate(_5269)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _263) * (((_5291 * _4207) * (_5279 / (_5295 * _5295))) * (0.5f / ((((_5305 * _4255) + _5280) * _4207) + (((_5305 * _4207) + _5280) * _4255)))));
                            _5321 = false;
                          } else {
                            _5320 = 0.0f;
                            _5321 = true;
                          }
                          _5325 = saturate((_4101 + _3990) / (_3990 + 1.0f));
                          _5327 = (_4238 * _4207) * _4264;
                          _5331 = _5320 + (_5327 * _4250);
                          _5332 = _5320 + (_5327 * _4251);
                          _5333 = _5320 + (_5327 * _4252);
                          [branch]
                          if (_5321) {
                            _5339 = (_5331 * _874);
                            _5340 = (_5332 * _875);
                            _5341 = (_5333 * _876);
                            _5342 = _5325;
                            _5343 = _5325;
                            _5344 = _5325;
                          } else {
                            _5339 = _5331;
                            _5340 = _5332;
                            _5341 = _5333;
                            _5342 = _5325;
                            _5343 = _5325;
                            _5344 = _5325;
                          }
                        }
                      }
                    }
                    [branch]
                    if (!((_3977 & 1) == 0)) {
                      _5357 = max(max(_4039, _4040), _4041);
                      if (_5357 > 0.0f) {
                        _5367 = saturate(_4039 / _5357);
                        _5368 = saturate(_4040 / _5357);
                        _5369 = saturate(_4041 / _5357);
                      } else {
                        _5367 = _4039;
                        _5368 = _4040;
                        _5369 = _4041;
                      }
                      _5370 = (_5368 < _5369);
                      _5371 = select(_5370, _5369, _5368);
                      _5372 = select(_5370, _5368, _5369);
                      _5373 = select(_5370, -1.0f, 0.0f);
                      _5374 = (_5367 < _5371);
                      _5376 = select(_5374, _5371, _5367);
                      _5377 = select(_5374, _5367, _5371);
                      _5381 = _5376 - select((_5377 < _5372), _5377, _5372);
                      _5387 = abs(select(_5374, (-0.3333333432674408f - _5373), _5373) + ((_5377 - _5372) / ((_5381 * 6.0f) + 9.999999682655225e-21f)));
                      if (_5387 < 0.6666666865348816f) {
                        _5400 = ((saturate(((float)((uint)((uint)(((uint)(_3977) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5387 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5387)) + _5387);
                      } else {
                        _5400 = _5387;
                      }
                      _5401 = saturate((_5381 / (_5376 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3977) >> 1) & 255)))) * 0.003921499941498041f));
                      _5402 = saturate(_5376);
                      if (!(_5401 <= 0.0f)) {
                        _5405 = saturate(_5400);
                        _5409 = select(((_5405 * 360.0f) >= 360.0f), 0.0f, (_5405 * 6.0f));
                        _5410 = int(_5409);
                        _5412 = _5409 - float((int)(_5410));
                        _5414 = _5402 * (1.0f - _5401);
                        _5417 = (1.0f - (_5412 * _5401)) * _5402;
                        _5421 = (1.0f - ((1.0f - _5412) * _5401)) * _5402;
                        switch (_5410) {
                          case 0: {
                            _5429 = _5402;
                            _5430 = _5421;
                            _5431 = _5414;
                            break;
                          }
                          case 1: {
                            _5429 = _5417;
                            _5430 = _5402;
                            _5431 = _5414;
                            break;
                          }
                          case 2: {
                            _5429 = _5414;
                            _5430 = _5402;
                            _5431 = _5421;
                            break;
                          }
                          case 3: {
                            _5429 = _5414;
                            _5430 = _5417;
                            _5431 = _5402;
                            break;
                          }
                          case 4: {
                            _5429 = _5421;
                            _5430 = _5414;
                            _5431 = _5402;
                            break;
                          }
                          case 5: {
                            _5429 = _5402;
                            _5430 = _5414;
                            _5431 = _5417;
                            break;
                          }
                          default: {
                            _5429 = 0.0f;
                            _5430 = 0.0f;
                            _5431 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _5429 = _5402;
                        _5430 = _5402;
                        _5431 = _5402;
                      }
                      _5432 = _5429 * _5357;
                      _5433 = _5430 * _5357;
                      _5434 = _5431 * _5357;
                      _5436 = saturate(_4044 * 1.0101009607315063f);
                      _5447 = ((_5436 * (_4039 - _5432)) + _5432);
                      _5448 = ((_5436 * (_4040 - _5433)) + _5433);
                      _5449 = (lerp(_5434, _4041, _5436));
                    } else {
                      _5447 = _4039;
                      _5448 = _4040;
                      _5449 = _4041;
                    }
                    _5450 = _5447 * _4044;
                    _5451 = _5448 * _4044;
                    _5452 = _5449 * _4044;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _5462 = (_5450 * _1019);
                      _5463 = (_5451 * _1019);
                      _5464 = (_5452 * _1019);
                    } else {
                      _5462 = _5450;
                      _5463 = _5451;
                      _5464 = _5452;
                    }
                    _5468 = (_5462 * _5342) + _1274;
                    _5469 = (_5463 * _5343) + _1275;
                    _5470 = (_5464 * _5344) + _1276;
                    if (_162) {
                      _5484 = ((float)((bool)(uint)(((srvContactShadowsCSMMask.SampleLevel(samplerPointClampNode, float2((cbSharedPerViewData.vViewportSize.x * _296), (cbSharedPerViewData.vViewportSize.y * _297)), 0.0f)).x) == 1.0f)));
                    } else {
                      _5484 = 1.0f;
                    }
                    if (_3987 > 0.0f) {
                      _5487 = (_3987 * _1034) * _5484;
                      _13729 = _5468;
                      _13730 = _5469;
                      _13731 = _5470;
                      _13732 = (((_5462 * _5339) * _5487) + _1277);
                      _13733 = (((_5463 * _5340) * _5487) + _1278);
                      _13734 = (((_5464 * _5341) * _5487) + _1279);
                    } else {
                      _13729 = _5468;
                      _13730 = _5469;
                      _13731 = _5470;
                      _13732 = _1277;
                      _13733 = _1278;
                      _13734 = _1279;
                    }
                  } else {
                    _13729 = _1274;
                    _13730 = _1275;
                    _13731 = _1276;
                    _13732 = _1277;
                    _13733 = _1278;
                    _13734 = _1279;
                  }
                } else {
                  _13729 = _1274;
                  _13730 = _1275;
                  _13731 = _1276;
                  _13732 = _1277;
                  _13733 = _1278;
                  _13734 = _1279;
                }
              } else {
                _1341 = _1321 * select(((_1289 & 67108864) != 0), 1.0f, (1.0f - _1268));
                [branch]
                if (_1324 == 4) {
                  _1346 = asfloat(srvLightInfoProperties.Load4(_1293)).x;
                  _1347 = asfloat(srvLightInfoProperties.Load4(_1293)).y;
                  _1348 = asfloat(srvLightInfoProperties.Load4(_1293)).z;
                  _1349 = asfloat(srvLightInfoProperties.Load4(_1293)).w;
                  _1352 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).x;
                  _1353 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).y;
                  _1354 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).z;
                  _1355 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).w;
                  _1358 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).x;
                  _1359 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).y;
                  _1360 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).z;
                  _1361 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).w;
                  _1364 = asint(srvLightInfoProperties.Load(((int)(_1293 + 48u))));
                  _1367 = asint(srvLightInfoProperties.Load(((int)(_1293 + 52u))));
                  _1370 = asint(srvLightInfoProperties.Load(((int)(_1293 + 64u))));
                  _1373 = asint(srvLightInfoProperties.Load(((int)(_1293 + 68u))));
                  _1376 = asint(srvLightInfoProperties.Load(((int)(_1293 + 72u))));
                  _1378 = f16tof32(((uint)((uint)(_1364) >> 16)));
                  _1379 = f16tof32(_1364);
                  _1381 = f16tof32(((uint)((uint)(_1367) >> 16)));
                  _1385 = ((float)((uint)((uint)(((uint)(_1367) >> 8) & 255)))) * 0.003921499941498041f;
                  _1398 = mad(_1348, _315, mad(_1347, _314, (_1346 * _313))) + _1349;
                  _1402 = mad(_1354, _315, mad(_1353, _314, (_1352 * _313))) + _1355;
                  _1406 = mad(_1360, _315, mad(_1359, _314, (_1358 * _313))) + _1361;
                  _1431 = saturate(1.0f - ((_1398 + 1.0f) * f16tof32(_1370))) + saturate(1.0f - ((1.0f - _1398) * f16tof32(((uint)((uint)(_1370) >> 16)))));
                  _1432 = saturate(1.0f - ((_1402 + 1.0f) * f16tof32(_1373))) + saturate(1.0f - ((1.0f - _1402) * f16tof32(((uint)((uint)(_1373) >> 16)))));
                  _1433 = saturate(1.0f - ((_1406 + 1.0f) * f16tof32(_1376))) + saturate(1.0f - ((1.0f - _1406) * f16tof32(((uint)((uint)(_1376) >> 16)))));
                  _1436 = saturate(1.0f - dot(float3(_1431, _1432, _1433), float3(_1431, _1432, _1433)));
                  _1437 = _1436 * _1436;
                  _1444 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1437 * _1019), _1437) * _1341;
                  _13729 = ((_1444 * _1378) + _1274);
                  _13730 = ((_1444 * _1379) + _1275);
                  _13731 = ((_1444 * _1381) + _1276);
                  _13732 = (((_1385 * _1378) * _1444) + _1277);
                  _13733 = (((_1385 * _1379) * _1444) + _1278);
                  _13734 = (((_1381 * _1385) * _1444) + _1279);
                } else {
                  if (_1324 == 5) {
                    _1465 = asfloat(srvLightInfoProperties.Load4(_1293)).x;
                    _1466 = asfloat(srvLightInfoProperties.Load4(_1293)).y;
                    _1467 = asfloat(srvLightInfoProperties.Load4(_1293)).z;
                    _1468 = asfloat(srvLightInfoProperties.Load4(_1293)).w;
                    _1471 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).x;
                    _1472 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).y;
                    _1473 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).z;
                    _1474 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).w;
                    _1477 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).x;
                    _1478 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).y;
                    _1479 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).z;
                    _1480 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).w;
                    _1483 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).x;
                    _1484 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).y;
                    _1485 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).z;
                    _1488 = asfloat(srvLightInfoProperties.Load(((int)(_1293 + 60u))));
                    _1491 = asint(srvLightInfoProperties.Load(((int)(_1293 + 64u))));
                    _1494 = asint(srvLightInfoProperties.Load(((int)(_1293 + 68u))));
                    _1497 = asint(srvLightInfoProperties.Load(((int)(_1293 + 80u))));
                    _1500 = asint(srvLightInfoProperties.Load(((int)(_1293 + 84u))));
                    _1503 = asint(srvLightInfoProperties.Load(((int)(_1293 + 88u))));
                    _1506 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 92u)))).x;
                    _1507 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 92u)))).y;
                    _1508 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 92u)))).z;
                    _1509 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 92u)))).w;
                    _1512 = asint(srvLightInfoProperties.Load(((int)(_1293 + 108u))));
                    _1515 = asint(srvLightInfoProperties.Load(((int)(_1293 + 112u))));
                    _1518 = asint(srvLightInfoProperties.Load(((int)(_1293 + 116u))));
                    _1521 = asint(srvLightInfoProperties.Load(((int)(_1293 + 120u))));
                    _1524 = asint(srvLightInfoProperties.Load(((int)(_1293 + 124u))));
                    _1527 = asint(srvLightInfoProperties.Load(((int)(_1293 + 128u))));
                    _1530 = asint(srvLightInfoProperties.Load(((int)(_1293 + 132u))));
                    _1533 = asint(srvLightInfoProperties.Load(((int)(_1293 + 136u))));
                    _1536 = asint(srvLightInfoProperties.Load(((int)(_1293 + 140u))));
                    _1538 = f16tof32(((uint)((uint)(_1491) >> 16)));
                    _1539 = f16tof32(_1491);
                    _1541 = f16tof32(((uint)((uint)(_1494) >> 16)));
                    _1545 = ((float)((uint)((uint)(((uint)(_1494) >> 8) & 255)))) * 0.003921499941498041f;
                    _1548 = ((float)((uint)((uint)(_1494 & 255)))) * 0.003921499941498041f;
                    _1550 = f16tof32(((uint)((uint)(_1497) >> 16)));
                    _1553 = _1500 & 65535;
                    _1559 = ((_1289 & 3584) != 0);
                    _1570 = f16tof32(((uint)((uint)(_1521) >> 16)));
                    _1571 = 1.0f / _1570;
                    _1572 = _1570 + -1.0f;
                    _1573 = f16tof32(_1521);
                    _1593 = (_159 >= 0.003921568859368563f);
                    _1595 = (_159 < 0.007843137718737125f);
                    _1596 = _1595 && (_1593 && ((cbSharedPerViewData.nLightingShadowFeatures & 1) != 0));
                    _1600 = saturate(1.0f - dot(float3(_147, _148, _149), float3(_1483, _1484, _1485))) * f16tof32(_1512);
                    _1604 = (_1600 * _147) + _313;
                    _1605 = (_1600 * _148) + _314;
                    _1606 = (_1600 * _149) - _312;
                    _1610 = mad(_1467, _1606, mad(_1466, _1605, (_1604 * _1465))) + _1468;
                    _1614 = mad(_1473, _1606, mad(_1472, _1605, (_1604 * _1471))) + _1474;
                    _1618 = mad(_1479, _1606, mad(_1478, _1605, (_1604 * _1477))) + _1480;
                    _1619 = saturate(_1618);
                    _1642 = saturate(1.0f - (_1610 * f16tof32(_1530))) + saturate(1.0f - ((1.0f - _1610) * f16tof32(((uint)((uint)(_1530) >> 16)))));
                    _1643 = saturate(1.0f - (_1614 * f16tof32(_1533))) + saturate(1.0f - ((1.0f - _1614) * f16tof32(((uint)((uint)(_1533) >> 16)))));
                    _1644 = saturate(1.0f - (_1618 * f16tof32(_1536))) + saturate(1.0f - ((1.0f - _1618) * f16tof32(((uint)((uint)(_1536) >> 16)))));
                    _1647 = saturate(1.0f - dot(float3(_1642, _1643, _1644), float3(_1642, _1643, _1644)));
                    _1648 = _1647 * _1647;
                    if (!((!(_1648 > 0.0f)) || (!_1559))) {
                      _1655 = 1.0f - _1619;
                      _1656 = saturate(_1610);
                      _1657 = saturate(_1614);
                      bool __branch_chain_1652;
                      [branch]
                      if ((_1289 & 1024) == 0) {
                        _1921 = 1.0f;
                        _1922 = 0.0f;
                        _1923 = _1655;
                        __branch_chain_1652 = true;
                      } else {
                        _1662 = ((_1656 * _1572) + 0.5f) * _1571;
                        _1664 = ((_1657 * _1572) + 0.5f) * _1571;
                        _1665 = _1655 + f16tof32(((uint)((uint)(_1512) >> 16)));
                        Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1500) >> 16))];
                        _1668 = select(_1596, f16tof32(((uint)((uint)(_1518) >> 16))), f16tof32(((uint)((uint)(_1515) >> 16))));
                        _1669 = saturate(_1665);
                        _1673 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                        _1682 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_1673 * 32.665000915527344f) + _296), ((_1673 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _1683 = sin(_1682);
                        _1684 = cos(_1682);
                        _1685 = cbSharedPerViewData.nFrameCounter & 3;
                        _1690 = sqrt((float((int)(_1685)) * 0.25f) + 0.125f) * _1668;
                        _1699 = (_global_0[min((uint)(((int)(0u + (_1685 * 2)))), 127u)]) * _1690;
                        _1700 = (_global_0[min((uint)(((int)(1u + (_1685 * 2)))), 127u)]) * _1690;
                        _1702 = -0.0f - _1683;
                        _1707 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1699, _1700), float2(_1684, _1683)) + _1662), (dot(float2(_1699, _1700), float2(_1702, _1684)) + _1664)));
                        _1712 = _1707.x - _1669;
                        _1714 = select((_1712 < 0.0f), 0.0f, 1.0f);
                        _1716 = _1707.y - _1669;
                        _1718 = select((_1716 < 0.0f), 0.0f, 1.0f);
                        _1722 = _1707.z - _1669;
                        _1724 = select((_1722 < 0.0f), 0.0f, 1.0f);
                        _1728 = _1707.w - _1669;
                        _1730 = select((_1728 < 0.0f), 0.0f, 1.0f);
                        _1737 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                        _1742 = sqrt((float((int)(_1737)) * 0.25f) + 0.125f) * _1668;
                        _1751 = (_global_0[min((uint)(((int)(0u + (_1737 * 2)))), 127u)]) * _1742;
                        _1752 = (_global_0[min((uint)(((int)(1u + (_1737 * 2)))), 127u)]) * _1742;
                        _1758 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1751, _1752), float2(_1684, _1683)) + _1662), (dot(float2(_1751, _1752), float2(_1702, _1684)) + _1664)));
                        _1763 = _1758.x - _1669;
                        _1765 = select((_1763 < 0.0f), 0.0f, 1.0f);
                        _1769 = _1758.y - _1669;
                        _1771 = select((_1769 < 0.0f), 0.0f, 1.0f);
                        _1775 = _1758.z - _1669;
                        _1777 = select((_1775 < 0.0f), 0.0f, 1.0f);
                        _1781 = _1758.w - _1669;
                        _1783 = select((_1781 < 0.0f), 0.0f, 1.0f);
                        _1790 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                        _1795 = sqrt((float((int)(_1790)) * 0.25f) + 0.125f) * _1668;
                        _1804 = (_global_0[min((uint)(((int)(0u + (_1790 * 2)))), 127u)]) * _1795;
                        _1805 = (_global_0[min((uint)(((int)(1u + (_1790 * 2)))), 127u)]) * _1795;
                        _1811 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1804, _1805), float2(_1684, _1683)) + _1662), (dot(float2(_1804, _1805), float2(_1702, _1684)) + _1664)));
                        _1816 = _1811.x - _1669;
                        _1818 = select((_1816 < 0.0f), 0.0f, 1.0f);
                        _1822 = _1811.y - _1669;
                        _1824 = select((_1822 < 0.0f), 0.0f, 1.0f);
                        _1828 = _1811.z - _1669;
                        _1830 = select((_1828 < 0.0f), 0.0f, 1.0f);
                        _1834 = _1811.w - _1669;
                        _1836 = select((_1834 < 0.0f), 0.0f, 1.0f);
                        _1843 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                        _1848 = sqrt((float((int)(_1843)) * 0.25f) + 0.125f) * _1668;
                        _1857 = (_global_0[min((uint)(((int)(0u + (_1843 * 2)))), 127u)]) * _1848;
                        _1858 = (_global_0[min((uint)(((int)(1u + (_1843 * 2)))), 127u)]) * _1848;
                        _1864 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1857, _1858), float2(_1684, _1683)) + _1662), (dot(float2(_1857, _1858), float2(_1702, _1684)) + _1664)));
                        _1869 = _1864.x - _1669;
                        _1871 = select((_1869 < 0.0f), 0.0f, 1.0f);
                        _1875 = _1864.y - _1669;
                        _1877 = select((_1875 < 0.0f), 0.0f, 1.0f);
                        _1881 = _1864.z - _1669;
                        _1883 = select((_1881 < 0.0f), 0.0f, 1.0f);
                        _1887 = _1864.w - _1669;
                        _1889 = select((_1887 < 0.0f), 0.0f, 1.0f);
                        _1890 = ((((((((((((((_1714 + _1718) + _1724) + _1730) + _1765) + _1771) + _1777) + _1783) + _1818) + _1824) + _1830) + _1836) + _1871) + _1877) + _1883) + _1889;
                        _1901 = (saturate(_1890 * 0.0625f) * 2.0f) + -1.0f;
                        _1907 = float((int)(((int)(uint)((int)(_1901 > 0.0f))) - ((int)(uint)((int)(_1901 < 0.0f)))));
                        _1909 = 1.0f - (_1907 * _1901);
                        _1911 = (_1909 * _1909) * _1909;
                        _1918 = 0.5f - ((_1907 * 0.5f) * ((1.0f - _1911) - ((_1909 - _1911) * saturate(((1.0f / _1669) * (1.0f / _1890)) * ((((((((((((((((_1714 * _1712) + (_1718 * _1716)) + (_1724 * _1722)) + (_1730 * _1728)) + (_1765 * _1763)) + (_1771 * _1769)) + (_1777 * _1775)) + (_1783 * _1781)) + (_1818 * _1816)) + (_1824 * _1822)) + (_1830 * _1828)) + (_1836 * _1834)) + (_1871 * _1869)) + (_1877 * _1875)) + (_1883 * _1881)) + (_1889 * _1887))))));
                        [branch]
                        if (_1573 < 1.0f) {
                          _1921 = _1918;
                          _1922 = _1573;
                          _1923 = _1665;
                          __branch_chain_1652 = true;
                        } else {
                          _2392 = _1573;
                          _2393 = _1918;
                          __branch_chain_1652 = false;
                        }
                      }
                      if (__branch_chain_1652) {
                        _1926 = (_1656 * _1506) + _1508;
                        _1927 = (_1657 * _1507) + _1509;
                        if (!((_1289 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                          _1934 = select(_1596, f16tof32(_1518), f16tof32(_1515));
                          _1937 = saturate(_1923);
                          _1941 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _1950 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_1941 * 32.665000915527344f) + _296), ((_1941 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _1951 = sin(_1950);
                          _1952 = cos(_1950);
                          _1957 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_1926, _1927), 0.0f))).x) > _1937), 1.0f, 0.0f);
                          _1958 = cbSharedPerViewData.nFrameCounter & 3;
                          _1963 = sqrt((float((int)(_1958)) * 0.25f) + 0.125f) * _1934;
                          _1972 = (_global_0[min((uint)(((int)(0u + (_1958 * 2)))), 127u)]) * _1963;
                          _1973 = (_global_0[min((uint)(((int)(1u + (_1958 * 2)))), 127u)]) * _1963;
                          _1975 = -0.0f - _1951;
                          _1977 = dot(float2(_1972, _1973), float2(_1952, _1951)) + _1926;
                          _1978 = dot(float2(_1972, _1973), float2(_1975, _1952)) + _1927;
                          _1980 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_1977, _1978));
                          _1984 = _1977 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _1985 = _1978 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _1988 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1508);
                          _1989 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1509);
                          _1994 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1506 + _1508)) + 0.5f);
                          _1995 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1507 + _1509)) + 0.5f);
                          _1998 = floor(_1984 + -0.5f);
                          _1999 = floor(_1985 + 0.5f);
                          _2001 = floor(_1984 + 0.5f);
                          _2003 = floor(_1985 + -0.5f);
                          _2004 = (_1998 < _1988);
                          _2005 = (_1999 < _1989);
                          if ((_2004 || _2005) | ((_1998 >= _1994) || (_1999 >= _1995))) {
                            _2014 = _1957;
                          } else {
                            _2014 = _1980.x;
                          }
                          _2015 = (_2001 < _1988);
                          if ((_2015 || _2005) | ((_2001 >= _1994) || (_1999 >= _1995))) {
                            _2023 = _1957;
                          } else {
                            _2023 = _1980.y;
                          }
                          _2024 = (_2003 < _1989);
                          if ((_2015 || _2024) | ((_2001 >= _1994) || (_2003 >= _1995))) {
                            _2032 = _1957;
                          } else {
                            _2032 = _1980.z;
                          }
                          if ((_2004 || _2024) | ((_1998 >= _1994) || (_2003 >= _1995))) {
                            _2040 = _1957;
                          } else {
                            _2040 = _1980.w;
                          }
                          _2041 = _2014 - _1937;
                          _2043 = select((_2041 < 0.0f), 0.0f, 1.0f);
                          _2045 = _2023 - _1937;
                          _2047 = select((_2045 < 0.0f), 0.0f, 1.0f);
                          _2051 = _2032 - _1937;
                          _2053 = select((_2051 < 0.0f), 0.0f, 1.0f);
                          _2057 = _2040 - _1937;
                          _2059 = select((_2057 < 0.0f), 0.0f, 1.0f);
                          _2066 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2071 = sqrt((float((int)(_2066)) * 0.25f) + 0.125f) * _1934;
                          _2080 = (_global_0[min((uint)(((int)(0u + (_2066 * 2)))), 127u)]) * _2071;
                          _2081 = (_global_0[min((uint)(((int)(1u + (_2066 * 2)))), 127u)]) * _2071;
                          _2084 = dot(float2(_2080, _2081), float2(_1952, _1951)) + _1926;
                          _2085 = dot(float2(_2080, _2081), float2(_1975, _1952)) + _1927;
                          _2087 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2084, _2085));
                          _2091 = _2084 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2092 = _2085 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2095 = floor(_2091 + -0.5f);
                          _2096 = floor(_2092 + 0.5f);
                          _2098 = floor(_2091 + 0.5f);
                          _2100 = floor(_2092 + -0.5f);
                          _2101 = (_2095 < _1988);
                          _2102 = (_2096 < _1989);
                          if ((_2101 || _2102) | ((_2095 >= _1994) || (_2096 >= _1995))) {
                            _2111 = _1957;
                          } else {
                            _2111 = _2087.x;
                          }
                          _2112 = (_2098 < _1988);
                          if ((_2112 || _2102) | ((_2098 >= _1994) || (_2096 >= _1995))) {
                            _2120 = _1957;
                          } else {
                            _2120 = _2087.y;
                          }
                          _2121 = (_2100 < _1989);
                          if ((_2112 || _2121) | ((_2098 >= _1994) || (_2100 >= _1995))) {
                            _2129 = _1957;
                          } else {
                            _2129 = _2087.z;
                          }
                          if ((_2101 || _2121) | ((_2095 >= _1994) || (_2100 >= _1995))) {
                            _2137 = _1957;
                          } else {
                            _2137 = _2087.w;
                          }
                          _2138 = _2111 - _1937;
                          _2140 = select((_2138 < 0.0f), 0.0f, 1.0f);
                          _2144 = _2120 - _1937;
                          _2146 = select((_2144 < 0.0f), 0.0f, 1.0f);
                          _2150 = _2129 - _1937;
                          _2152 = select((_2150 < 0.0f), 0.0f, 1.0f);
                          _2156 = _2137 - _1937;
                          _2158 = select((_2156 < 0.0f), 0.0f, 1.0f);
                          _2165 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2170 = sqrt((float((int)(_2165)) * 0.25f) + 0.125f) * _1934;
                          _2179 = (_global_0[min((uint)(((int)(0u + (_2165 * 2)))), 127u)]) * _2170;
                          _2180 = (_global_0[min((uint)(((int)(1u + (_2165 * 2)))), 127u)]) * _2170;
                          _2183 = dot(float2(_2179, _2180), float2(_1952, _1951)) + _1926;
                          _2184 = dot(float2(_2179, _2180), float2(_1975, _1952)) + _1927;
                          _2186 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2183, _2184));
                          _2190 = _2183 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2191 = _2184 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2194 = floor(_2190 + -0.5f);
                          _2195 = floor(_2191 + 0.5f);
                          _2197 = floor(_2190 + 0.5f);
                          _2199 = floor(_2191 + -0.5f);
                          _2200 = (_2194 < _1988);
                          _2201 = (_2195 < _1989);
                          if ((_2200 || _2201) | ((_2194 >= _1994) || (_2195 >= _1995))) {
                            _2210 = _1957;
                          } else {
                            _2210 = _2186.x;
                          }
                          _2211 = (_2197 < _1988);
                          if ((_2211 || _2201) | ((_2197 >= _1994) || (_2195 >= _1995))) {
                            _2219 = _1957;
                          } else {
                            _2219 = _2186.y;
                          }
                          _2220 = (_2199 < _1989);
                          if ((_2211 || _2220) | ((_2197 >= _1994) || (_2199 >= _1995))) {
                            _2228 = _1957;
                          } else {
                            _2228 = _2186.z;
                          }
                          if ((_2200 || _2220) | ((_2194 >= _1994) || (_2199 >= _1995))) {
                            _2236 = _1957;
                          } else {
                            _2236 = _2186.w;
                          }
                          _2237 = _2210 - _1937;
                          _2239 = select((_2237 < 0.0f), 0.0f, 1.0f);
                          _2243 = _2219 - _1937;
                          _2245 = select((_2243 < 0.0f), 0.0f, 1.0f);
                          _2249 = _2228 - _1937;
                          _2251 = select((_2249 < 0.0f), 0.0f, 1.0f);
                          _2255 = _2236 - _1937;
                          _2257 = select((_2255 < 0.0f), 0.0f, 1.0f);
                          _2264 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2269 = sqrt((float((int)(_2264)) * 0.25f) + 0.125f) * _1934;
                          _2278 = (_global_0[min((uint)(((int)(0u + (_2264 * 2)))), 127u)]) * _2269;
                          _2279 = (_global_0[min((uint)(((int)(1u + (_2264 * 2)))), 127u)]) * _2269;
                          _2282 = dot(float2(_2278, _2279), float2(_1952, _1951)) + _1926;
                          _2283 = dot(float2(_2278, _2279), float2(_1975, _1952)) + _1927;
                          _2285 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2282, _2283));
                          _2289 = _2282 * cbSharedPerViewData.vShadowAtlasSize.x;
                          _2290 = _2283 * cbSharedPerViewData.vShadowAtlasSize.y;
                          _2293 = floor(_2289 + -0.5f);
                          _2294 = floor(_2290 + 0.5f);
                          _2296 = floor(_2289 + 0.5f);
                          _2298 = floor(_2290 + -0.5f);
                          _2299 = (_2293 < _1988);
                          _2300 = (_2294 < _1989);
                          if ((_2299 || _2300) | ((_2293 >= _1994) || (_2294 >= _1995))) {
                            _2309 = _1957;
                          } else {
                            _2309 = _2285.x;
                          }
                          _2310 = (_2296 < _1988);
                          if ((_2310 || _2300) | ((_2296 >= _1994) || (_2294 >= _1995))) {
                            _2318 = _1957;
                          } else {
                            _2318 = _2285.y;
                          }
                          _2319 = (_2298 < _1989);
                          if ((_2310 || _2319) | ((_2296 >= _1994) || (_2298 >= _1995))) {
                            _2327 = _1957;
                          } else {
                            _2327 = _2285.z;
                          }
                          if ((_2299 || _2319) | ((_2293 >= _1994) || (_2298 >= _1995))) {
                            _2335 = _1957;
                          } else {
                            _2335 = _2285.w;
                          }
                          _2336 = _2309 - _1937;
                          _2338 = select((_2336 < 0.0f), 0.0f, 1.0f);
                          _2342 = _2318 - _1937;
                          _2344 = select((_2342 < 0.0f), 0.0f, 1.0f);
                          _2348 = _2327 - _1937;
                          _2350 = select((_2348 < 0.0f), 0.0f, 1.0f);
                          _2354 = _2335 - _1937;
                          _2356 = select((_2354 < 0.0f), 0.0f, 1.0f);
                          _2357 = ((((((((((((((_2047 + _2043) + _2053) + _2059) + _2140) + _2146) + _2152) + _2158) + _2239) + _2245) + _2251) + _2257) + _2338) + _2344) + _2350) + _2356;
                          _2368 = (saturate(_2357 * 0.0625f) * 2.0f) + -1.0f;
                          _2374 = float((int)(((int)(uint)((int)(_2368 > 0.0f))) - ((int)(uint)((int)(_2368 < 0.0f)))));
                          _2376 = 1.0f - (_2374 * _2368);
                          _2378 = (_2376 * _2376) * _2376;
                          _2387 = (0.5f - ((_2374 * 0.5f) * ((1.0f - _2378) - ((_2376 - _2378) * saturate(((1.0f / _1937) * (1.0f / _2357)) * ((((((((((((((((_2047 * _2045) + (_2043 * _2041)) + (_2053 * _2051)) + (_2059 * _2057)) + (_2140 * _2138)) + (_2146 * _2144)) + (_2152 * _2150)) + (_2158 * _2156)) + (_2239 * _2237)) + (_2245 * _2243)) + (_2251 * _2249)) + (_2257 * _2255)) + (_2338 * _2336)) + (_2344 * _2342)) + (_2350 * _2348)) + (_2356 * _2354)))))));
                        } else {
                          _2387 = 1.0f;
                        }
                        _2392 = _1922;
                        _2393 = (lerp(_2387, _1921, _1922));
                      }
                      [branch]
                      if (!((_1289 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1503) >> 16))];
                        _2399 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1610, _1614), 0.0f);
                        if (_2399.x > 0.0f) {
                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1503 & 65535))];
                          _2406 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1610, _1614), 0.0f);
                          _2420 = mad(saturate(((log2(_1619 * _1488) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                          _2421 = max(9.999999747378752e-06f, _2399.x);
                          _2422 = _2406.x / _2421;
                          _2423 = _2406.y / _2421;
                          _2425 = _2406.w / _2421;
                          _2430 = ((0.375f - _2423) * 4.999999873689376e-06f) + _2423;
                          _2433 = -0.0f - _2422;
                          _2434 = mad(_2433, _2430, (_2406.z / _2421));
                          _2436 = 1.0f / mad(_2433, _2422, _2430);
                          _2437 = _2436 * _2434;
                          _2442 = _2420 - _2422;
                          _2447 = (((_2420 * _2420) - _2430) - (_2437 * _2442)) / mad((-0.0f - _2434), _2437, mad((-0.0f - _2430), _2430, (((0.375f - _2425) * 4.999999873689376e-06f) + _2425)));
                          _2449 = (_2436 * _2442) - (_2447 * _2437);
                          _2452 = 1.0f / _2447;
                          _2453 = _2449 * _2452;
                          _2458 = sqrt(((_2453 * _2453) * 0.25f) - ((1.0f - dot(float2(_2449, _2447), float2(_2422, _2430))) * _2452));
                          _2460 = (_2453 * -0.5f) - _2458;
                          _2462 = _2458 - (_2453 * 0.5f);
                          _2464 = select((_2460 < _2420), 1.0f, 0.0f);
                          _2469 = (_2464 + -0.05000000074505806f) / (_2460 - _2420);
                          _2475 = (((select((_2462 < _2420), 1.0f, 0.0f) - _2464) / (_2462 - _2460)) - _2469) / (_2462 - _2420);
                          _2477 = _2469 - (_2475 * _2460);
                          _2490 = (exp2((_2399.x * -1.4426950216293335f) * saturate((dot(float2(_2422, _2430), float2((_2477 - (_2475 * _2420)), _2475)) + 0.05000000074505806f) - (_2477 * _2420))) * _2393);
                        } else {
                          _2490 = _2393;
                        }
                      } else {
                        _2490 = _2393;
                      }
                      _2495 = _2392;
                      _2496 = _2490;
                      _2497 = (lerp(_2490, 1.0f, _2392));
                    } else {
                      _2495 = 0.0f;
                      _2496 = 1.0f;
                      _2497 = 1.0f;
                    }
                    [branch]
                    if (!(_1553 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1553)))];
                      _2510 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1610 * f16tof32(((uint)((uint)(_1524) >> 16)))) + f16tof32(((uint)((uint)(_1527) >> 16)))), ((_1614 * f16tof32(_1524)) + f16tof32(_1527))), 0.0f);
                      _2518 = (_2510.x * _1538);
                      _2519 = (_2510.y * _1539);
                      _2520 = (_2510.z * _1541);
                    } else {
                      _2518 = _1538;
                      _2519 = _1539;
                      _2520 = _1541;
                    }
                    _2521 = _2496 * _1648;
                    [branch]
                    if (!(_2521 == 0.0f)) {
                      bool __branch_chain_2524;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _2540 = 0;
                        __branch_chain_2524 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _2540 = 1;
                          __branch_chain_2524 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _2540 = 2;
                            __branch_chain_2524 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _2540 = 3;
                              __branch_chain_2524 = true;
                            } else {
                              _2561 = _2521;
                              __branch_chain_2524 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_2524) {
                        while(true) {
                          _2543 = srvDeferredShadingEvaluateAdaptationPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                          if (_2540 == 0) {
                            _2557 = _2543.x;
                          } else {
                            if (_2540 == 1) {
                              _2557 = _2543.y;
                            } else {
                              if (_2540 == 2) {
                                _2557 = _2543.z;
                              } else {
                                _2557 = _2543.w;
                              }
                            }
                          }
                          _2561 = ((_2557 * _2557) * _1648);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_2561 == 0.0f)) {
                          [branch]
                          if (_1559) {
                            _2567 = _2495;
                          } else {
                            _2567 = 0.0f;
                          }
                          _2568 = select(_162, (_2497 * _1648), _2561);
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _2575 = srvLightMappingData[_1286];
                            if (!(_2575 == -1)) {
                              _2580 = srvLightIndexData[_2575].nLayerIndex;
                              _2582 = srvLightIndexData[_2575].vAtlasOrigin.x;
                              _2583 = srvLightIndexData[_2575].vAtlasOrigin.y;
                              _2585 = srvLightIndexData[_2575].vScreenOrigin.x;
                              _2586 = srvLightIndexData[_2575].vScreenOrigin.y;
                              _2595 = ((int)(_2580 * 5)) & 31;
                              _2598 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2582 + _65) - _2585)), ((int)((_2583 + _66) - _2586)), 0)))).x) & ((int)(31 << _2595)))) >> _2595;
                              _2603 = ((float)((uint)((uint)((uint)(_2598) >> 1)))) * 0.06666667014360428f;
                              _2609 = (_2603 * _2568);
                              _2610 = (select(_162, ((float)((bool)(uint)((_2598 & 1) != 0))), _2603) * _2568);
                            } else {
                              _2609 = _2568;
                              _2610 = _2568;
                            }
                          } else {
                            _2609 = _2568;
                            _2610 = _2568;
                          }
                          _2614 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _2617 = select(_2614, (_2609 * _1019), _2609);
                          _2619 = dot(float3(_1483, _1484, _1485), float3(_1483, _1484, _1485));
                          _2620 = rsqrt(_2619);
                          _2621 = _2620 * _1483;
                          _2622 = _2620 * _1484;
                          _2623 = _2620 * _1485;
                          _2624 = dot(float3(_147, _148, _149), float3(_2621, _2622, _2623));
                          if (_1550 > 0.0f) {
                            _2632 = sqrt(saturate((_1550 * _1550) * (1.0f / (_2619 + 1.0f))));
                            if (_2624 < _2632) {
                              _2637 = max(_2624, (-0.0f - _2632)) + _2632;
                              _2642 = ((_2637 * _2637) / (_2632 * 4.0f));
                            } else {
                              _2642 = _2624;
                            }
                          } else {
                            _2642 = _2624;
                          }
                          _2643 = _217 * _217;
                          _2644 = 1.0f - _2643;
                          _2647 = saturate((_1550 * _2644) * _2620);
                          _2649 = saturate(_2620 * f16tof32(_1497));
                          _2650 = _1593 && _1595;
                          if (_2650) {
                            _2652 = saturate(_2624);
                            _2659 = (_2652 * (_147 - _289)) + _289;
                            _2660 = (_2652 * (_148 - _290)) + _290;
                            _2661 = (_2652 * (_149 - _291)) + _291;
                            _2663 = rsqrt(dot(float3(_2659, _2660, _2661), float3(_2659, _2660, _2661)));
                            _2668 = (_2659 * _2663);
                            _2669 = (_2660 * _2663);
                            _2670 = (_2661 * _2663);
                          } else {
                            _2668 = _147;
                            _2669 = _148;
                            _2670 = _149;
                          }
                          _2671 = dot(float3(_2668, _2669, _2670), float3(_2621, _2622, _2623));
                          _2672 = dot(float3(_2668, _2669, _2670), float3(_322, _323, _321));
                          _2673 = dot(float3(_322, _323, _321), float3(_2621, _2622, _2623));
                          _2676 = rsqrt((_2673 * 2.0f) + 2.0f);
                          _2679 = saturate(_2676 * (_2672 + _2671));
                          _2682 = saturate((_2676 * _2673) + _2676);
                          _2683 = (_2647 > 0.0f);
                          if (_2683) {
                            _2687 = sqrt(1.0f - (_2647 * _2647));
                            _2689 = (_2671 * 2.0f) * _2672;
                            _2690 = _2689 - _2673;
                            if (!(_2690 >= _2687)) {
                              _2698 = rsqrt(1.0f - (_2690 * _2690)) * _2647;
                              _2701 = _2698 * (_2672 - (_2690 * _2671));
                              _2702 = _2672 * _2672;
                              _2707 = _2698 * (((_2702 * 2.0f) + -1.0f) - (_2690 * _2673));
                              _2716 = sqrt(saturate((((1.0f - (_2671 * _2671)) - _2702) - (_2673 * _2673)) + (_2689 * _2673)));
                              _2717 = _2716 * _2698;
                              _2720 = ((_2672 * 2.0f) * _2698) * _2716;
                              _2722 = (_2687 * _2671) + _2672;
                              _2723 = _2722 + _2701;
                              _2724 = _2687 * _2673;
                              _2726 = (_2724 + 1.0f) + _2707;
                              _2727 = _2717 * _2726;
                              _2728 = _2723 * _2726;
                              _2729 = _2720 * _2723;
                              _2734 = (((_2723 * 0.25f) * _2720) - (_2727 * 0.5f)) * _2728;
                              _2748 = (((_2729 - (_2727 * 2.0f)) * _2729) + (_2727 * _2727)) + ((((-0.5f - ((_2726 + _2724) * 0.5f)) * _2728) + ((_2726 * _2726) * _2722)) * _2723);
                              _2753 = (_2734 * 2.0f) / ((_2748 * _2748) + (_2734 * _2734));
                              _2754 = _2748 * _2753;
                              _2756 = 1.0f - (_2734 * _2753);
                              _2762 = ((_2754 * _2720) + _2724) + (_2756 * _2707);
                              _2765 = rsqrt((_2762 * 2.0f) + 2.0f);
                              _2774 = saturate((_2762 * _2765) + _2765);
                              _2775 = saturate(((_2722 + (_2754 * _2717)) + (_2756 * _2701)) * _2765);
                            } else {
                              _2774 = abs(_2672);
                              _2775 = 1.0f;
                            }
                          } else {
                            _2774 = _2682;
                            _2775 = _2679;
                          }
                          _2776 = saturate(_2672);
                          _2777 = saturate(_2642);
                          _2778 = saturate(_2671);
                          _2779 = _2643 * _2643;
                          _2780 = (_2649 > 0.0f);
                          if (_2780) {
                            _2789 = saturate(((_2649 * _2649) / ((_2774 * 3.5999999046325684f) + 0.4000000059604645f)) + _2779);
                          } else {
                            _2789 = _2779;
                          }
                          _2790 = sqrt(_2789);
                          if (_2683) {
                            _2801 = (_2789 / ((((_2647 * 0.25f) * ((_2790 * 3.0f) + _2647)) / (_2774 + 0.0010000000474974513f)) + _2789));
                          } else {
                            _2801 = 1.0f;
                          }
                          _2805 = (((_2789 * _2775) - _2775) * _2775) + 1.0f;
                          _2808 = (_2789 / (_2805 * _2805)) * _2801;
                          _2809 = 1.0f - _201;
                          _2810 = 1.0f - _202;
                          _2811 = 1.0f - _203;
                          _2812 = saturate(_2774);
                          _2813 = 1.0f - _2812;
                          _2814 = log2(_2813);
                          _2816 = exp2(_2814 * 5.0f);
                          _2820 = (_2816 * _2809) + _201;
                          _2821 = (_2816 * _2810) + _202;
                          _2822 = (_2816 * _2811) + _203;
                          _2823 = abs(_2672);
                          _2825 = saturate(_2823 + 9.999999747378752e-06f);
                          _2826 = 1.0f - _2790;
                          _2834 = 0.5f / ((((_2826 * _2825) + _2790) * _2777) + (((_2826 * _2777) + _2790) * _2825));
                          if (_162) {
                            _2844 = ((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                            _2845 = ((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                            _2846 = ((_115 + -0.5f) * 0.5f) + 0.5f;
                            _2863 = ((dot(float3((-0.0f - _2668), (-0.0f - _2669), (-0.0f - _2670)), float3(_2621, _2622, _2623)) + dot(float3((-0.0f - _322), (-0.0f - _323), (-0.0f - _321)), float3(_2621, _2622, _2623))) * 0.5f) * exp2(log2(1.0f - _2776) * (11.0f - (((float)((uint)((uint)((uint)(_259) >> 2)))) * 0.1666666716337204f)));
                            _2870 = dot(float3(_113, _114, _115), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                            _2873 = saturate((_2870 + -0.009999999776482582f) * -100.0f);
                            _2878 = ((_2873 * _2873) * 3.0f) * (3.0f - (_2873 * 2.0f));
                            _2885 = 10.0f - (exp2(log2(saturate(_2870 * 5.0f)) * 3.0f) * 9.0f);
                            _2886 = saturate(_2778 + _2844) * _2778;
                            _2887 = saturate(_2778 + _2845) * _2778;
                            _2888 = saturate(_2778 + _2846) * _2778;
                            _2907 = (max(((_2878 + _2844) * _2863), 0.0f) * _2885) + sqrt(_2886 * _2886);
                            _2908 = (max(((_2878 + _2845) * _2863), 0.0f) * _2885) + sqrt(_2887 * _2887);
                            _2909 = (max(((_2878 + _2846) * _2863), 0.0f) * _2885) + sqrt(_2888 * _2888);
                            _2910 = _2621 + _322;
                            _2911 = _2622 + _323;
                            _2912 = _2623 + _321;
                            _2914 = rsqrt(dot(float3(_2910, _2911, _2912), float3(_2910, _2911, _2912)));
                            if (!(select((_258 != 0), 1.0f, 0.0f) < 1.0f)) {
                              _2928 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                              _2929 = _2928 * _147;
                              _2930 = _2928 * _148;
                              _2931 = _2928 * _149;
                              _2934 = (abs(_2929) < abs(_2930));
                              _2935 = select(_2934, 1.0f, 0.0f);
                              _2936 = select(_2934, 0.0f, 1.0f);
                              _2937 = _2936 * _2931;
                              _2939 = -0.0f - (_2931 * _2935);
                              _2942 = (_2935 * _2930) - (_2936 * _2929);
                              _2944 = rsqrt(dot(float3(_2937, _2939, _2942), float3(_2937, _2939, _2942)));
                              _2945 = _2937 * _2944;
                              _2946 = _2944 * _2939;
                              _2947 = _2942 * _2944;
                              _2950 = (_2946 * _2931) - (_2947 * _2930);
                              _2953 = (_2947 * _2929) - (_2945 * _2931);
                              _2956 = (_2945 * _2930) - (_2946 * _2929);
                              _2958 = rsqrt(dot(float3(_2950, _2953, _2956), float3(_2950, _2953, _2956)));
                              _2970 = saturate(abs(_257 + -2.5f) + -0.5f) + -0.5f;
                              _2971 = saturate(1.5f - abs(_257 + -1.5f)) + -0.5f;
                              _2973 = rsqrt(dot(float2(_2970, _2971), float2(_2970, _2971)));
                              _2974 = _2973 * _2970;
                              _2975 = _2973 * _2971;
                              _2982 = ((_2950 * _2958) * _2974) + (_2975 * _2945);
                              _2983 = ((_2953 * _2958) * _2974) + (_2975 * _2946);
                              _2984 = ((_2956 * _2958) * _2974) + (_2975 * _2947);
                              _2987 = min(max(dot(float3(_2982, _2983, _2984), float3(_2621, _2622, _2623)), -1.0f), 1.0f);
                              _2990 = min(max(dot(float3(_2982, _2983, _2984), float3(_322, _323, _321)), -1.0f), 1.0f);
                              _2991 = abs(_2990);
                              _2996 = (1.5707963705062866f - (_2991 * 0.1565829962491989f)) * sqrt(1.0f - _2991);
                              _3000 = abs(_2987);
                              _3005 = (1.5707963705062866f - (_3000 * 0.1565829962491989f)) * sqrt(1.0f - _3000);
                              _3012 = cos(abs(select((_2987 >= 0.0f), _3005, (3.1415927410125732f - _3005)) - select((_2990 >= 0.0f), _2996, (3.1415927410125732f - _2996))) * 0.5f);
                              _3016 = _2621 - (_2987 * _2982);
                              _3017 = _2622 - (_2987 * _2983);
                              _3018 = _2623 - (_2987 * _2984);
                              _3022 = _322 - (_2990 * _2982);
                              _3023 = _323 - (_2990 * _2983);
                              _3024 = _321 - (_2990 * _2984);
                              _3031 = rsqrt((dot(float3(_3022, _3023, _3024), float3(_3022, _3023, _3024)) * dot(float3(_3016, _3017, _3018), float3(_3016, _3017, _3018))) + 9.999999747378752e-05f) * dot(float3(_3016, _3017, _3018), float3(_3022, _3023, _3024));
                              _3035 = sqrt(saturate((_3031 * 0.5f) + 0.5f));
                              _3039 = _2643 * 0.5f;
                              _3040 = _2643 * 2.0f;
                              _3044 = exp2((1.0f - abs(_2567)) * -72.13475036621094f);
                              if (!((_259 & 1) == 0)) {
                                _3051 = select(((select(((_259 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_2567 == -1.0f))), 0.0f, _3044);
                              } else {
                                _3051 = _3044;
                              }
                              _3054 = saturate((_2624 + 0.5f) * 0.6666666865348816f);
                              _3064 = (_2990 + _2987) + ((((_3035 * 0.9975510239601135f) * sqrt(1.0f - (_2990 * _2990))) - (_2990 * 0.06994284689426422f)) * 0.13988569378852844f);
                              _3066 = (_2643 * 1.4142135381698608f) * _3035;
                              _3079 = 1.0f - sqrt(saturate((_2673 * 0.5f) + 0.5f));
                              _3080 = _3079 * _3079;
                              _3086 = saturate(-0.0f - _2673);
                              _3089 = (1.0f - saturate(_3086)) * _3054;
                              _3098 = ((((_3035 * 0.5f) * (exp2((((_3064 * _3064) * -0.5f) / (_3066 * _3066)) * 1.4426950216293335f) / (_3066 * 2.5066282749176025f))) * min(_205, 0.5f)) * (((_3080 * _3080) * (_3079 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3089, 1.0f, _3051));
                              _3100 = (_2987 + -0.03500000014901161f) + _2990;
                              _3109 = 1.0f / ((1.190000057220459f / _3012) + (_3012 * 0.36000001430511475f));
                              _3114 = ((_3109 * (0.6000000238418579f - (_3031 * 0.800000011920929f))) + 1.0f) * _3035;
                              _3120 = 1.0f - (sqrt(saturate(1.0f - (_3114 * _3114))) * _3012);
                              _3121 = _3120 * _3120;
                              _3125 = 0.9534794092178345f - ((_3121 * _3121) * (_3120 * 0.9534794092178345f));
                              _3126 = _3114 * _3109;
                              _3131 = (sqrt(1.0f - (_3126 * _3126)) * 0.5f) / _3012;
                              _3150 = 1.0f - saturate((_3086 + -0.44999998807907104f) * 2.222222328186035f);
                              _3153 = ((1.0f - _3054) * _3051) + _3054;
                              _3156 = ((_3125 * _3125) * (exp2((((_3100 * _3100) * -0.5f) / (_3039 * _3039)) * 1.4426950216293335f) / (_2643 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3031 * 5.2658371925354f));
                              _3170 = (_2987 + -0.14000000059604645f) + _2990;
                              _3180 = 1.0f - (_3012 * 0.5f);
                              _3181 = _3180 * _3180;
                              _3185 = (_3181 * _3181) * (0.9534794092178345f - (_3012 * 0.47673970460891724f));
                              _3187 = 0.9534794092178345f - _3185;
                              _3189 = (_3187 * _3187) * (_3185 + 0.04652056470513344f);
                              _3192 = exp2((_3031 * 24.525815963745117f) + -24.208423614501953f);
                              _3205 = ((exp2((((_3170 * _3170) * -0.5f) / (_3040 * _3040)) * 1.4426950216293335f) / (_2643 * 5.013256549835205f)) * (lerp(_3189, 1.0f, _170))) * (((exp2((saturate(dot(float3((_2914 * _2910), (_2914 * _2911), (_2914 * _2912)), float3(_147, _148, _149))) * 17.312339782714844f) + -14.109557151794434f) - _3192) * _170) + _3192);
                              _3917 = (((((exp2(log2(max(_113, 0.0f)) * _3131) * _3153) * _3156) * _3150) + _3098) + (_3205 * _113));
                              _3918 = (((((exp2(log2(max(_114, 0.0f)) * _3131) * _3153) * _3156) * _3150) + _3098) + (_3205 * _114));
                              _3919 = (((((exp2(log2(max(_115, 0.0f)) * _3131) * _3153) * _3156) * _3150) + _3098) + (_3205 * _115));
                              _3920 = _2907;
                              _3921 = _2908;
                              _3922 = _2909;
                            } else {
                              _3917 = 0.0f;
                              _3918 = 0.0f;
                              _3919 = 0.0f;
                              _3920 = _2907;
                              _3921 = _2908;
                              _3922 = _2909;
                            }
                          } else {
                            if (_2650) {
                              _3223 = ((float)((uint)((uint)(_261 & 15)))) * 0.06666667014360428f;
                              _3224 = _217 * 0.0317460335791111f;
                              _3227 = min(1.0f, max((_3224 * ((float)((uint)((uint)((uint)(_260) >> 2))))), 0.019999999552965164f));
                              _3230 = min(1.0f, max((_3224 * ((float)((uint)((uint)((((int)(_260 << 4)) & 48) | ((uint)(_261) >> 4)))))), 0.019999999552965164f));
                              _3233 = ((_3230 - _3227) * _3223) + _3227;
                              _3234 = _3233 * _3233;
                              _3238 = saturate(abs(_2776) + 9.999999747378752e-06f);
                              _3239 = sqrt(_3234 * _3234);
                              _3240 = 1.0f - _3239;
                              _3249 = _3227 * _3227;
                              _3250 = _3249 * _3249;
                              if (_2780) {
                                _3259 = saturate(((_2649 * _2649) / ((_2774 * 3.5999999046325684f) + 0.4000000059604645f)) + _3250);
                              } else {
                                _3259 = _3250;
                              }
                              if (_2683) {
                                _3271 = (_3259 / ((((_2647 * 0.25f) * ((sqrt(_3259) * 3.0f) + _2647)) / (_2774 + 0.0010000000474974513f)) + _3259));
                              } else {
                                _3271 = 1.0f;
                              }
                              _3272 = _3230 * _3230;
                              _3273 = _3272 * _3272;
                              if (_2780) {
                                _3282 = saturate(((_2649 * _2649) / ((_2774 * 3.5999999046325684f) + 0.4000000059604645f)) + _3273);
                              } else {
                                _3282 = _3273;
                              }
                              if (_2683) {
                                _3294 = (_3282 / ((((_2647 * 0.25f) * ((sqrt(_3282) * 3.0f) + _2647)) / (_2774 + 0.0010000000474974513f)) + _3282));
                              } else {
                                _3294 = 1.0f;
                              }
                              _3298 = (((_3259 * _2775) - _2775) * _2775) + 1.0f;
                              _3301 = (_3259 / (_3298 * _3298)) * _3271;
                              _3305 = (((_3282 * _2775) - _2775) * _2775) + 1.0f;
                              _3312 = saturate(_2775);
                              _3316 = saturate((_2671 + _1548) / (_1548 + 1.0f));
                              _3321 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_262)))) + 1u))]);
                              _3328 = ((float)((uint)((uint)((uint)((uint)(_3321.x)) >> 24)))) * 0.25f;
                              _3331 = ((float)((uint)((uint)(_3321.x & 255)))) * 0.003921568859368563f;
                              _3335 = ((float)((uint)((uint)(((uint)((uint)(_3321.x)) >> 8) & 255)))) * 0.003921568859368563f;
                              _3339 = ((float)((uint)((uint)(((uint)((uint)(_3321.x)) >> 16) & 255)))) * 0.003921568859368563f;
                              _3348 = ((float)((uint)((uint)((uint)((uint)(_3321.y)) >> 24)))) * 0.25f;
                              _3351 = ((float)((uint)((uint)(_3321.y & 255)))) * 0.003921568859368563f;
                              _3355 = ((float)((uint)((uint)(((uint)((uint)(_3321.y)) >> 8) & 255)))) * 0.003921568859368563f;
                              _3359 = ((float)((uint)((uint)(((uint)((uint)(_3321.y)) >> 16) & 255)))) * 0.003921568859368563f;
                              _3367 = (float)((uint)((uint)(_3321.w & 31)));
                              _3373 = (float)((uint)((uint)(((uint)((uint)(_3321.w)) >> 10) & 31)));
                              _3383 = (float)((uint)((uint)(((uint)((uint)(_3321.w)) >> 25) & 31)));
                              _3386 = ((float)((uint)((uint)(_3321.z & 255)))) * 0.003921568859368563f;
                              _3390 = ((float)((uint)((uint)(((uint)((uint)(_3321.z)) >> 8) & 255)))) * 0.003921568859368563f;
                              _3394 = ((float)((uint)((uint)(((uint)((uint)(_3321.z)) >> 16) & 255)))) * 0.003921568859368563f;
                              _3401 = (((float)((uint)((uint)((uint)((uint)(_3321.z)) >> 24)))) * 0.003921568859368563f) * select(((_3321.w & 1073741824) != 0), -1.0f, 1.0f);
                              _3415 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_3321.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _2812)));
                              _3416 = ((2.0f - (_3367 * 0.06451612710952759f)) > 0.0f);
                              if (_3416) {
                                _3427 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _3312))) * (10.0f - (_3367 * 0.32258063554763794f))) * _3415);
                              } else {
                                _3427 = _3415;
                              }
                              _3438 = exp2(log2(max(9.999999747378752e-06f, _3312)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_3321.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                              _3439 = ((2.0f - (_3373 * 0.06451612710952759f)) > 0.0f);
                              if (_3439) {
                                _3449 = (exp2(log2(max(9.999999747378752e-06f, _2813)) * (10.0f - (_3373 * 0.32258063554763794f))) * _3438);
                              } else {
                                _3449 = _3438;
                              }
                              if (_3416) {
                                _3463 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _3312))) * (10.0f - (_3367 * 0.32258063554763794f))) * _3415);
                              } else {
                                _3463 = _3415;
                              }
                              if (_3439) {
                                _3476 = (exp2(log2(max(9.999999747378752e-06f, _2813)) * (10.0f - (_3373 * 0.32258063554763794f))) * _3438);
                              } else {
                                _3476 = _3438;
                              }
                              if (_3416) {
                                _3490 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _3312))) * (10.0f - (_3367 * 0.32258063554763794f))) * _3415);
                              } else {
                                _3490 = _3415;
                              }
                              if (_3439) {
                                _3503 = (exp2(log2(max(9.999999747378752e-06f, _2813)) * (10.0f - (_3373 * 0.32258063554763794f))) * _3438);
                              } else {
                                _3503 = _3438;
                              }
                              _3515 = (1.0f - exp2(log2(1.0f - _3312) * 3.0f)) * (1.0f - exp2(_2814 * 3.0f));
                              _3519 = saturate(_3316 / (_3515 * (((float)((uint)((uint)(((uint)((uint)(_3321.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                              _3524 = ((_3519 * _3519) * (3.0f - (_3519 * 2.0f))) + -1.0f;
                              _3526 = ((((_3386 * _3386) * _3401) * _3515) * _3524) + 1.0f;
                              _3529 = ((((_3390 * _3390) * _3401) * _3515) * _3524) + 1.0f;
                              _3532 = ((((_3394 * _3394) * _3401) * _3515) * _3524) + 1.0f;
                              _3534 = saturate(_3383 * 0.06451612710952759f);
                              _3541 = exp2(log2(1.0f - _2774) * (10.0f - (_3383 * 0.32258063554763794f)));
                              _3560 = ((((((_3282 / (_3305 * _3305)) * _3294) - _3301) * _3223) + _3301) * (0.5f / ((((_3240 * _3238) + _3239) * _2777) + (((_3240 * _2777) + _3239) * _3238)))) * _2777;
                              _3917 = ((_3560 * _3526) * (((_3534 * _2809) * _3541) + _201));
                              _3918 = ((_3560 * _3529) * (((_3534 * _2810) * _3541) + _202));
                              _3919 = ((_3560 * _3532) * (((_3534 * _2811) * _3541) + _203));
                              _3920 = (((((_3427 * (((_3331 * _3331) * _3328) + -1.0f)) + 1.0f) * _3316) * ((_3449 * (((_3351 * _3351) * _3348) + -1.0f)) + 1.0f)) * _3526);
                              _3921 = (((((_3463 * (((_3335 * _3335) * _3328) + -1.0f)) + 1.0f) * _3316) * ((_3476 * (((_3355 * _3355) * _3348) + -1.0f)) + 1.0f)) * _3529);
                              _3922 = (((((_3490 * (((_3339 * _3339) * _3328) + -1.0f)) + 1.0f) * _3316) * ((_3503 * (((_3359 * _3359) * _3348) + -1.0f)) + 1.0f)) * _3532);
                            } else {
                              if (_191) {
                                if (_206 < 0.007874015718698502f) {
                                  _3574 = _2775 * _2775;
                                  _3576 = max((1.0f - _3574), 9.999999747378752e-05f);
                                  _3714 = (((((((exp2(((-0.0f - (_3574 / _3576)) / _2789) * 1.4426950216293335f) * 4.0f) / (_3576 * _3576)) + 1.0f) * (1.0f / ((_2789 * 4.0f) + 1.0f))) - _2808) * _207) + _2808);
                                  _3715 = (((saturate(0.25f / ((_2778 + _2776) - (_2778 * _2776))) - _2834) * _207) + _2834);
                                } else {
                                  _3600 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                                  _3601 = _3600 * _147;
                                  _3602 = _3600 * _148;
                                  _3603 = _3600 * _149;
                                  _3606 = (abs(_3601) < abs(_3602));
                                  _3607 = select(_3606, 1.0f, 0.0f);
                                  _3608 = select(_3606, 0.0f, 1.0f);
                                  _3609 = _3608 * _3603;
                                  _3611 = -0.0f - (_3603 * _3607);
                                  _3614 = (_3607 * _3602) - (_3608 * _3601);
                                  _3616 = rsqrt(dot(float3(_3609, _3611, _3614), float3(_3609, _3611, _3614)));
                                  _3617 = _3609 * _3616;
                                  _3618 = _3616 * _3611;
                                  _3619 = _3614 * _3616;
                                  _3622 = (_3618 * _3603) - (_3619 * _3602);
                                  _3625 = (_3619 * _3601) - (_3617 * _3603);
                                  _3628 = (_3617 * _3602) - (_3618 * _3601);
                                  _3630 = rsqrt(dot(float3(_3622, _3625, _3628), float3(_3622, _3625, _3628)));
                                  _3634 = _207 * 4.0f;
                                  _3643 = saturate(abs(_3634 + -2.5f) + -0.5f) + -0.5f;
                                  _3644 = saturate(1.5f - abs(_3634 + -1.5f)) + -0.5f;
                                  _3646 = rsqrt(dot(float2(_3643, _3644), float2(_3643, _3644)));
                                  _3647 = _3646 * _3643;
                                  _3648 = _3646 * _3644;
                                  _3655 = ((_3622 * _3630) * _3647) + (_3648 * _3617);
                                  _3656 = ((_3625 * _3630) * _3647) + (_3648 * _3618);
                                  _3657 = ((_3628 * _3630) * _3647) + (_3648 * _3619);
                                  _3660 = (_3656 * _149) - (_3657 * _148);
                                  _3663 = (_3657 * _147) - (_3655 * _149);
                                  _3666 = (_3655 * _148) - (_3656 * _147);
                                  _3667 = dot(float3(_3655, _3656, _3657), float3(_2621, _2622, _2623));
                                  _3668 = dot(float3(_3655, _3656, _3657), float3(_322, _323, _321));
                                  _3671 = dot(float3(_3660, _3663, _3666), float3(_2621, _2622, _2623));
                                  _3672 = dot(float3(_3660, _3663, _3666), float3(_322, _323, _321));
                                  _3678 = min(max((_2643 * (_206 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                  _3682 = min(max((_2643 * (1.0f - _206)), 0.0010000000474974513f), 1.0f);
                                  _3683 = _3682 * _3678;
                                  _3684 = ((_3668 + _3667) * _2676) * _3682;
                                  _3685 = ((_3672 + _3671) * _2676) * _3678;
                                  _3686 = _3683 * _2679;
                                  _3687 = dot(float3(_3684, _3685, _3686), float3(_3684, _3685, _3686));
                                  _3692 = _3678 * _3668;
                                  _3693 = _3682 * _3672;
                                  _3701 = _3678 * _3667;
                                  _3702 = _3682 * _3671;
                                  _3714 = (((_3683 * _3683) * _3683) / (_3687 * _3687));
                                  _3715 = saturate(0.5f / ((sqrt(((_3701 * _3701) + (_2778 * _2778)) + (_3702 * _3702)) * _2825) + (sqrt(((_3693 * _3693) + (_3692 * _3692)) + (_2825 * _2825)) * _2778)));
                                }
                                _3717 = (_3714 * _2778) * _3715;
                                _3735 = saturate((_2671 + 0.5f) * 0.6666666865348816f);
                                _3917 = (_3717 * _2820);
                                _3918 = (_3717 * _2821);
                                _3919 = (_3717 * _2822);
                                _3920 = ((_3735 * (1.0f - _2820)) * saturate((((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _2778));
                                _3921 = ((_3735 * (1.0f - _2821)) * saturate((((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _2778));
                                _3922 = ((_3735 * (1.0f - _2822)) * saturate((((_115 + -0.5f) * 0.5f) + 0.5f) + _2778));
                              } else {
                                if (_212) {
                                  _3750 = _264 * _264;
                                  _3751 = _3750 * _3750;
                                  _3757 = saturate(select((_2644 > 0.0f), ((1.0f - _3750) / _2644), 0.0f) * _2647);
                                  _3758 = (_3757 > 0.0f);
                                  if (_3758) {
                                    _3762 = sqrt(1.0f - (_3757 * _3757));
                                    _3764 = (_2671 * 2.0f) * _2672;
                                    _3765 = _3764 - _2673;
                                    if (!(_3765 >= _3762)) {
                                      _3771 = rsqrt(1.0f - (_3765 * _3765)) * _3757;
                                      _3774 = _3771 * (_2672 - (_3765 * _2671));
                                      _3775 = _2672 * _2672;
                                      _3780 = _3771 * (((_3775 * 2.0f) + -1.0f) - (_3765 * _2673));
                                      _3789 = sqrt(saturate((((1.0f - (_2671 * _2671)) - _3775) - (_2673 * _2673)) + (_3764 * _2673)));
                                      _3790 = _3789 * _3771;
                                      _3793 = ((_2672 * 2.0f) * _3771) * _3789;
                                      _3795 = (_3762 * _2671) + _2672;
                                      _3796 = _3795 + _3774;
                                      _3797 = _3762 * _2673;
                                      _3799 = (_3797 + 1.0f) + _3780;
                                      _3800 = _3790 * _3799;
                                      _3801 = _3796 * _3799;
                                      _3802 = _3793 * _3796;
                                      _3807 = (((_3796 * 0.25f) * _3793) - (_3800 * 0.5f)) * _3801;
                                      _3821 = (((_3802 - (_3800 * 2.0f)) * _3802) + (_3800 * _3800)) + ((((-0.5f - ((_3799 + _3797) * 0.5f)) * _3801) + ((_3799 * _3799) * _3795)) * _3796);
                                      _3826 = (_3807 * 2.0f) / ((_3821 * _3821) + (_3807 * _3807));
                                      _3827 = _3821 * _3826;
                                      _3829 = 1.0f - (_3807 * _3826);
                                      _3835 = ((_3827 * _3793) + _3797) + (_3829 * _3780);
                                      _3838 = rsqrt((_3835 * 2.0f) + 2.0f);
                                      _3847 = saturate((_3835 * _3838) + _3838);
                                      _3848 = saturate(((_3795 + (_3827 * _3790)) + (_3829 * _3774)) * _3838);
                                    } else {
                                      _3847 = _2823;
                                      _3848 = 1.0f;
                                    }
                                  } else {
                                    _3847 = _2682;
                                    _3848 = _2679;
                                  }
                                  if (_2780) {
                                    _3857 = saturate(((_2649 * _2649) / ((_3847 * 3.5999999046325684f) + 0.4000000059604645f)) + _3751);
                                  } else {
                                    _3857 = _3751;
                                  }
                                  _3858 = sqrt(_3857);
                                  if (_3758) {
                                    _3869 = (_3857 / ((((_3757 * 0.25f) * ((_3858 * 3.0f) + _3757)) / (_3847 + 0.0010000000474974513f)) + _3857));
                                  } else {
                                    _3869 = 1.0f;
                                  }
                                  _3873 = (((_3857 * _3848) - _3848) * _3848) + 1.0f;
                                  _3883 = 1.0f - _3858;
                                  _3898 = ((((exp2(log2(1.0f - saturate(_3847)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _263) * (((_3869 * _2777) * (_3857 / (_3873 * _3873))) * (0.5f / ((((_3883 * _2825) + _3858) * _2777) + (((_3883 * _2777) + _3858) * _2825)))));
                                  _3899 = false;
                                } else {
                                  _3898 = 0.0f;
                                  _3899 = true;
                                }
                                _3903 = saturate((_2671 + _1548) / (_1548 + 1.0f));
                                _3905 = (_2808 * _2777) * _2834;
                                _3909 = _3898 + (_3905 * _2820);
                                _3910 = _3898 + (_3905 * _2821);
                                _3911 = _3898 + (_3905 * _2822);
                                [branch]
                                if (_3899) {
                                  _3917 = (_3909 * _874);
                                  _3918 = (_3910 * _875);
                                  _3919 = (_3911 * _876);
                                  _3920 = _3903;
                                  _3921 = _3903;
                                  _3922 = _3903;
                                } else {
                                  _3917 = _3909;
                                  _3918 = _3910;
                                  _3919 = _3911;
                                  _3920 = _3903;
                                  _3921 = _3903;
                                  _3922 = _3903;
                                }
                              }
                            }
                          }
                          _3923 = _2518 * _1341;
                          _3924 = _2519 * _1341;
                          _3925 = _2520 * _1341;
                          _3932 = ((_2617 * _3923) * _3920) + _1274;
                          _3933 = ((_2617 * _3924) * _3921) + _1275;
                          _3934 = ((_2617 * _3925) * _3922) + _1276;
                          if (_1545 > 0.0f) {
                            _3937 = (_1545 * _1034) * select(_2614, (_2610 * _1019), _2610);
                            _13729 = _3932;
                            _13730 = _3933;
                            _13731 = _3934;
                            _13732 = (((_3937 * _3923) * _3917) + _1277);
                            _13733 = (((_3937 * _3924) * _3918) + _1278);
                            _13734 = (((_3937 * _3925) * _3919) + _1279);
                          } else {
                            _13729 = _3932;
                            _13730 = _3933;
                            _13731 = _3934;
                            _13732 = _1277;
                            _13733 = _1278;
                            _13734 = _1279;
                          }
                        } else {
                          _13729 = _1274;
                          _13730 = _1275;
                          _13731 = _1276;
                          _13732 = _1277;
                          _13733 = _1278;
                          _13734 = _1279;
                        }
                        break;
                      }
                    } else {
                      _13729 = _1274;
                      _13730 = _1275;
                      _13731 = _1276;
                      _13732 = _1277;
                      _13733 = _1278;
                      _13734 = _1279;
                    }
                  } else {
                    if (_1324 == 7) {
                      _5502 = asfloat(srvLightInfoProperties.Load3(_1293)).x;
                      _5503 = asfloat(srvLightInfoProperties.Load3(_1293)).y;
                      _5504 = asfloat(srvLightInfoProperties.Load3(_1293)).z;
                      _5507 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 12u)))).x;
                      _5508 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 12u)))).y;
                      _5509 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 12u)))).z;
                      _5512 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 24u)))).x;
                      _5513 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 24u)))).y;
                      _5514 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 24u)))).z;
                      _5517 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 36u)))).x;
                      _5518 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 36u)))).y;
                      _5519 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 36u)))).z;
                      _5522 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).x;
                      _5523 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).y;
                      _5524 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 48u)))).z;
                      _5527 = asint(srvLightInfoProperties.Load(((int)(_1293 + 60u))));
                      _5530 = asint(srvLightInfoProperties.Load(((int)(_1293 + 64u))));
                      _5533 = asint(srvLightInfoProperties.Load(((int)(_1293 + 72u))));
                      _5536 = asint(srvLightInfoProperties.Load(((int)(_1293 + 76u))));
                      _5539 = asint(srvLightInfoProperties.Load(((int)(_1293 + 80u))));
                      _5542 = asint(srvLightInfoProperties.Load(((int)(_1293 + 84u))));
                      _5545 = asint(srvLightInfoProperties.Load(((int)(_1293 + 88u))));
                      _5548 = asint(srvLightInfoProperties.Load(((int)(_1293 + 92u))));
                      _5551 = asint(srvLightInfoProperties.Load(((int)(_1293 + 96u))));
                      _5554 = asint(srvLightInfoProperties.Load(((int)(_1293 + 100u))));
                      _5557 = asint(srvLightInfoProperties.Load(((int)(_1293 + 104u))));
                      _5560 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).x;
                      _5561 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).y;
                      _5562 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).z;
                      _5563 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).w;
                      _5566 = asint(srvLightInfoProperties.Load(((int)(_1293 + 124u))));
                      _5569 = asint(srvLightInfoProperties.Load(((int)(_1293 + 128u))));
                      _5572 = asint(srvLightInfoProperties.Load(((int)(_1293 + 132u))));
                      _5575 = asint(srvLightInfoProperties.Load(((int)(_1293 + 136u))));
                      _5578 = asint(srvLightInfoProperties.Load(((int)(_1293 + 140u))));
                      _5580 = f16tof32(((uint)((uint)(_5527) >> 16)));
                      _5581 = f16tof32(_5527);
                      _5583 = f16tof32(((uint)((uint)(_5530) >> 16)));
                      _5587 = ((float)((uint)((uint)(((uint)(_5530) >> 8) & 255)))) * 0.003921499941498041f;
                      _5590 = ((float)((uint)((uint)(_5530 & 255)))) * 0.003921499941498041f;
                      _5591 = f16tof32(_5533);
                      _5593 = f16tof32(((uint)((uint)(_5536) >> 16)));
                      _5597 = f16tof32(_5539);
                      _5599 = f16tof32(((uint)((uint)(_5542) >> 16)));
                      _5600 = f16tof32(_5542);
                      _5602 = f16tof32(((uint)((uint)(_5545) >> 16)));
                      _5603 = f16tof32(_5545);
                      _5605 = _5548 & 65535;
                      _5609 = ((_1289 & 4194304) != 0);
                      _5617 = f16tof32(((uint)((uint)(_5557) >> 16)));
                      _5618 = f16tof32(_5557);
                      _5620 = f16tof32(((uint)((uint)(_5566) >> 16)));
                      _5623 = f16tof32(((uint)((uint)(_5569) >> 16)));
                      _5624 = f16tof32(_5569);
                      _5626 = f16tof32(((uint)((uint)(_5572) >> 16)));
                      _5627 = f16tof32(_5572);
                      _5629 = f16tof32(((uint)((uint)(_5575) >> 16)));
                      _5630 = _5629 + -1.0f;
                      if (_5609) {
                        _5632 = 0.5f / _5629;
                        _5633 = 0.3333333432674408f / _5629;
                        _5637 = (_5629 * 0.5f) + 0.5f;
                        _5647 = (_5632 * _5630);
                        _5648 = (_5633 * _5630);
                        _5649 = (_5632 * _5637);
                        _5650 = (_5633 * _5637);
                        _5651 = (_5629 * 2.0f);
                        _5652 = (_5629 * 3.0f);
                      } else {
                        _5643 = 1.0f / _5629;
                        _5644 = _5643 * _5630;
                        _5645 = _5643 * 0.5f;
                        _5647 = _5644;
                        _5648 = _5644;
                        _5649 = _5645;
                        _5650 = _5645;
                        _5651 = _5629;
                        _5652 = _5629;
                      }
                      _5660 = (_159 >= 0.003921568859368563f);
                      _5662 = (_159 < 0.007843137718737125f);
                      _5663 = _5662 && (_5660 && ((cbSharedPerViewData.nLightingShadowFeatures & 1) != 0));
                      _5664 = _5517 - _313;
                      _5665 = _5518 - _314;
                      _5666 = _5519 + _312;
                      _5667 = dot(float3(_5664, _5665, _5666), float3(_5664, _5665, _5666));
                      _5668 = rsqrt(_5667);
                      _5669 = _5668 * _5667;
                      _5670 = _5668 * _5664;
                      _5671 = _5668 * _5665;
                      _5672 = _5668 * _5666;
                      _5675 = max(0.0f, (_5669 - abs(_5597)));
                      _5676 = _5675 * f16tof32(((uint)((uint)(_5539) >> 16)));
                      _5677 = _5676 * _5676;
                      _5680 = saturate(1.0f - (_5677 * _5677));
                      _5687 = (_5680 * _5680) / (select((_5597 < 0.0f), (_5677 * 16.0f), (_5675 * _5675)) + 1.0f);
                      _5700 = saturate(1.0f - dot(float3(_147, _148, _149), float3(_5670, _5671, _5672))) * f16tof32(_5566);
                      _5704 = abs(_5666);
                      _5708 = _5664 - ((_5700 * _147) * _5704);
                      _5709 = _5665 - ((_5700 * _148) * _5704);
                      _5710 = _5666 - ((_5700 * _149) * _5704);
                      _5713 = mad(_5710, _5513, mad(_5709, _5508, (_5708 * _5503)));
                      _5716 = mad(_5710, _5514, mad(_5709, _5509, (_5708 * _5504)));
                      _5718 = ((_1289 & 3584) != 0);
                      if (_5718 && (_5687 > 0.0f)) {
                        _5724 = mad(_5710, _5512, mad(_5709, _5507, (_5708 * _5502)));
                        _5725 = -0.0f - _5716;
                        _5726 = -0.0f - _5713;
                        [branch]
                        if (!((_1289 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_5548) >> 16))];
                          [branch]
                          if (_5609) {
                            _5731 = abs(_5724);
                            _5732 = abs(_5725);
                            _5733 = abs(_5726);
                            if (_5731 > max(_5732, _5733)) {
                              _5737 = (_5724 > 0.0f);
                              _5752 = select(_5737, 0.0f, 1.0f);
                              _5753 = 0.0f;
                              _5754 = select(_5737, _5713, _5726);
                              _5755 = _5716;
                              _5756 = _5731;
                            } else {
                              if (_5732 > _5733) {
                                _5743 = (_5716 < -0.0f);
                                _5752 = select(_5743, 0.0f, 1.0f);
                                _5753 = 1.0f;
                                _5754 = _5724;
                                _5755 = select(_5743, _5726, _5713);
                                _5756 = _5732;
                              } else {
                                _5747 = (_5713 < -0.0f);
                                _5752 = select(_5747, 0.0f, 1.0f);
                                _5753 = 2.0f;
                                _5754 = select(_5747, _5724, (-0.0f - _5724));
                                _5755 = _5716;
                                _5756 = _5733;
                              }
                            }
                            _5757 = _5756 * 2.0f;
                            _5761 = -0.0f - _5618;
                            _5770 = ((min(max((_5754 / _5757), _5761), _5618) + _5752) * _5647) + _5649;
                            _5771 = ((min(max((_5755 / _5757), _5761), _5618) + _5753) * _5648) + _5650;
                            _5774 = select(_5663, _5626, _5623);
                            _5779 = ((_5752 + -0.5f) * _5647) + _5649;
                            _5780 = ((_5753 + -0.5f) * _5648) + _5650;
                            _5783 = saturate((_5620 + 1.0f) - (_5756 * _5602));
                            _5787 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _5796 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_5787 * 32.665000915527344f) + _296), ((_5787 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _5797 = sin(_5796);
                            _5798 = cos(_5796);
                            _5803 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_5770, _5771), 0.0f))).x) > _5783), 1.0f, 0.0f);
                            _5804 = cbSharedPerViewData.nFrameCounter & 3;
                            _5809 = sqrt((float((int)(_5804)) * 0.25f) + 0.125f) * _5774;
                            _5818 = (_global_0[min((uint)(((int)(0u + (_5804 * 2)))), 127u)]) * _5809;
                            _5819 = (_global_0[min((uint)(((int)(1u + (_5804 * 2)))), 127u)]) * _5809;
                            _5821 = -0.0f - _5797;
                            _5823 = dot(float2(_5818, _5819), float2(_5798, _5797)) + _5770;
                            _5824 = dot(float2(_5818, _5819), float2(_5821, _5798)) + _5771;
                            _5826 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_5823, _5824));
                            _5830 = _5823 * _5651;
                            _5831 = _5824 * _5652;
                            _5834 = floor(_5779 * _5651);
                            _5835 = floor(_5780 * _5652);
                            _5840 = floor(((_5779 + _5647) * _5651) + 0.5f);
                            _5841 = floor(((_5780 + _5648) * _5652) + 0.5f);
                            _5844 = floor(_5830 + -0.5f);
                            _5845 = floor(_5831 + 0.5f);
                            _5847 = floor(_5830 + 0.5f);
                            _5849 = floor(_5831 + -0.5f);
                            _5850 = (_5844 < _5834);
                            _5851 = (_5845 < _5835);
                            if ((_5850 || _5851) | ((_5844 >= _5840) || (_5845 >= _5841))) {
                              _5860 = _5803;
                            } else {
                              _5860 = _5826.x;
                            }
                            _5861 = (_5847 < _5834);
                            if ((_5861 || _5851) | ((_5847 >= _5840) || (_5845 >= _5841))) {
                              _5869 = _5803;
                            } else {
                              _5869 = _5826.y;
                            }
                            _5870 = (_5849 < _5835);
                            if ((_5861 || _5870) | ((_5847 >= _5840) || (_5849 >= _5841))) {
                              _5878 = _5803;
                            } else {
                              _5878 = _5826.z;
                            }
                            if ((_5850 || _5870) | ((_5844 >= _5840) || (_5849 >= _5841))) {
                              _5886 = _5803;
                            } else {
                              _5886 = _5826.w;
                            }
                            _5887 = _5860 - _5783;
                            _5889 = select((_5887 < 0.0f), 0.0f, 1.0f);
                            _5891 = _5869 - _5783;
                            _5893 = select((_5891 < 0.0f), 0.0f, 1.0f);
                            _5897 = _5878 - _5783;
                            _5899 = select((_5897 < 0.0f), 0.0f, 1.0f);
                            _5903 = _5886 - _5783;
                            _5905 = select((_5903 < 0.0f), 0.0f, 1.0f);
                            _5912 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _5917 = sqrt((float((int)(_5912)) * 0.25f) + 0.125f) * _5774;
                            _5926 = (_global_0[min((uint)(((int)(0u + (_5912 * 2)))), 127u)]) * _5917;
                            _5927 = (_global_0[min((uint)(((int)(1u + (_5912 * 2)))), 127u)]) * _5917;
                            _5930 = dot(float2(_5926, _5927), float2(_5798, _5797)) + _5770;
                            _5931 = dot(float2(_5926, _5927), float2(_5821, _5798)) + _5771;
                            _5933 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_5930, _5931));
                            _5937 = _5930 * _5651;
                            _5938 = _5931 * _5652;
                            _5941 = floor(_5937 + -0.5f);
                            _5942 = floor(_5938 + 0.5f);
                            _5944 = floor(_5937 + 0.5f);
                            _5946 = floor(_5938 + -0.5f);
                            _5947 = (_5941 < _5834);
                            _5948 = (_5942 < _5835);
                            if ((_5947 || _5948) | ((_5941 >= _5840) || (_5942 >= _5841))) {
                              _5957 = _5803;
                            } else {
                              _5957 = _5933.x;
                            }
                            _5958 = (_5944 < _5834);
                            if ((_5958 || _5948) | ((_5944 >= _5840) || (_5942 >= _5841))) {
                              _5966 = _5803;
                            } else {
                              _5966 = _5933.y;
                            }
                            _5967 = (_5946 < _5835);
                            if ((_5958 || _5967) | ((_5944 >= _5840) || (_5946 >= _5841))) {
                              _5975 = _5803;
                            } else {
                              _5975 = _5933.z;
                            }
                            if ((_5947 || _5967) | ((_5941 >= _5840) || (_5946 >= _5841))) {
                              _5983 = _5803;
                            } else {
                              _5983 = _5933.w;
                            }
                            _5984 = _5957 - _5783;
                            _5986 = select((_5984 < 0.0f), 0.0f, 1.0f);
                            _5990 = _5966 - _5783;
                            _5992 = select((_5990 < 0.0f), 0.0f, 1.0f);
                            _5996 = _5975 - _5783;
                            _5998 = select((_5996 < 0.0f), 0.0f, 1.0f);
                            _6002 = _5983 - _5783;
                            _6004 = select((_6002 < 0.0f), 0.0f, 1.0f);
                            _6011 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _6016 = sqrt((float((int)(_6011)) * 0.25f) + 0.125f) * _5774;
                            _6025 = (_global_0[min((uint)(((int)(0u + (_6011 * 2)))), 127u)]) * _6016;
                            _6026 = (_global_0[min((uint)(((int)(1u + (_6011 * 2)))), 127u)]) * _6016;
                            _6029 = dot(float2(_6025, _6026), float2(_5798, _5797)) + _5770;
                            _6030 = dot(float2(_6025, _6026), float2(_5821, _5798)) + _5771;
                            _6032 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_6029, _6030));
                            _6036 = _6029 * _5651;
                            _6037 = _6030 * _5652;
                            _6040 = floor(_6036 + -0.5f);
                            _6041 = floor(_6037 + 0.5f);
                            _6043 = floor(_6036 + 0.5f);
                            _6045 = floor(_6037 + -0.5f);
                            _6046 = (_6040 < _5834);
                            _6047 = (_6041 < _5835);
                            if ((_6046 || _6047) | ((_6040 >= _5840) || (_6041 >= _5841))) {
                              _6056 = _5803;
                            } else {
                              _6056 = _6032.x;
                            }
                            _6057 = (_6043 < _5834);
                            if ((_6057 || _6047) | ((_6043 >= _5840) || (_6041 >= _5841))) {
                              _6065 = _5803;
                            } else {
                              _6065 = _6032.y;
                            }
                            _6066 = (_6045 < _5835);
                            if ((_6057 || _6066) | ((_6043 >= _5840) || (_6045 >= _5841))) {
                              _6074 = _5803;
                            } else {
                              _6074 = _6032.z;
                            }
                            if ((_6046 || _6066) | ((_6040 >= _5840) || (_6045 >= _5841))) {
                              _6082 = _5803;
                            } else {
                              _6082 = _6032.w;
                            }
                            _6083 = _6056 - _5783;
                            _6085 = select((_6083 < 0.0f), 0.0f, 1.0f);
                            _6089 = _6065 - _5783;
                            _6091 = select((_6089 < 0.0f), 0.0f, 1.0f);
                            _6095 = _6074 - _5783;
                            _6097 = select((_6095 < 0.0f), 0.0f, 1.0f);
                            _6101 = _6082 - _5783;
                            _6103 = select((_6101 < 0.0f), 0.0f, 1.0f);
                            _6110 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _6115 = sqrt((float((int)(_6110)) * 0.25f) + 0.125f) * _5774;
                            _6124 = (_global_0[min((uint)(((int)(0u + (_6110 * 2)))), 127u)]) * _6115;
                            _6125 = (_global_0[min((uint)(((int)(1u + (_6110 * 2)))), 127u)]) * _6115;
                            _6128 = dot(float2(_6124, _6125), float2(_5798, _5797)) + _5770;
                            _6129 = dot(float2(_6124, _6125), float2(_5821, _5798)) + _5771;
                            _6131 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_6128, _6129));
                            _6135 = _6128 * _5651;
                            _6136 = _6129 * _5652;
                            _6139 = floor(_6135 + -0.5f);
                            _6140 = floor(_6136 + 0.5f);
                            _6142 = floor(_6135 + 0.5f);
                            _6144 = floor(_6136 + -0.5f);
                            _6145 = (_6139 < _5834);
                            _6146 = (_6140 < _5835);
                            if ((_6145 || _6146) | ((_6139 >= _5840) || (_6140 >= _5841))) {
                              _6155 = _5803;
                            } else {
                              _6155 = _6131.x;
                            }
                            _6156 = (_6142 < _5834);
                            if ((_6156 || _6146) | ((_6142 >= _5840) || (_6140 >= _5841))) {
                              _6164 = _5803;
                            } else {
                              _6164 = _6131.y;
                            }
                            _6165 = (_6144 < _5835);
                            if ((_6156 || _6165) | ((_6142 >= _5840) || (_6144 >= _5841))) {
                              _6173 = _5803;
                            } else {
                              _6173 = _6131.z;
                            }
                            if ((_6145 || _6165) | ((_6139 >= _5840) || (_6144 >= _5841))) {
                              _6181 = _5803;
                            } else {
                              _6181 = _6131.w;
                            }
                            _6182 = _6155 - _5783;
                            _6184 = select((_6182 < 0.0f), 0.0f, 1.0f);
                            _6188 = _6164 - _5783;
                            _6190 = select((_6188 < 0.0f), 0.0f, 1.0f);
                            _6194 = _6173 - _5783;
                            _6196 = select((_6194 < 0.0f), 0.0f, 1.0f);
                            _6200 = _6181 - _5783;
                            _6202 = select((_6200 < 0.0f), 0.0f, 1.0f);
                            _6203 = ((((((((((((((_5893 + _5889) + _5899) + _5905) + _5986) + _5992) + _5998) + _6004) + _6085) + _6091) + _6097) + _6103) + _6184) + _6190) + _6196) + _6202;
                            _6214 = (saturate(_6203 * 0.0625f) * 2.0f) + -1.0f;
                            _6220 = float((int)(((int)(uint)((int)(_6214 > 0.0f))) - ((int)(uint)((int)(_6214 < 0.0f)))));
                            _6222 = 1.0f - (_6220 * _6214);
                            _6224 = (_6222 * _6222) * _6222;
                            _6517 = (0.5f - ((_6220 * 0.5f) * ((1.0f - _6224) - ((_6222 - _6224) * saturate(((1.0f / _5783) * (1.0f / _6203)) * ((((((((((((((((_5893 * _5891) + (_5889 * _5887)) + (_5899 * _5897)) + (_5905 * _5903)) + (_5986 * _5984)) + (_5992 * _5990)) + (_5998 * _5996)) + (_6004 * _6002)) + (_6085 * _6083)) + (_6091 * _6089)) + (_6097 * _6095)) + (_6103 * _6101)) + (_6184 * _6182)) + (_6190 * _6188)) + (_6196 * _6194)) + (_6202 * _6200)))))));
                            _6518 = 1.0f;
                            _6519 = 1.0f;
                            _6520 = 1;
                            _6521 = _5603;
                          } else {
                            _6233 = f16tof32(_5578) / _5726;
                            _6236 = mad((_6233 * _5724), 0.5f, 0.5f);
                            _6237 = mad((_6233 * _5725), 0.5f, 0.5f);
                            if (_5713 > -0.0f) {
                              if ((saturate(_6236) == _6236) && (saturate(_6237) == _6237)) {
                                _6251 = (_6236 * _5647) + _5649;
                                _6252 = (_6237 * _5648) + _5650;
                                _6253 = select(_5663, _5626, _5623);
                                _6254 = saturate((_5620 + 1.0f) - (_5713 * _5602));
                                _6258 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _6267 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_6258 * 32.665000915527344f) + _296), ((_6258 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _6268 = sin(_6267);
                                _6269 = cos(_6267);
                                _6270 = cbSharedPerViewData.nFrameCounter & 3;
                                _6275 = sqrt((float((int)(_6270)) * 0.25f) + 0.125f) * _6253;
                                _6284 = (_global_0[min((uint)(((int)(0u + (_6270 * 2)))), 127u)]) * _6275;
                                _6285 = (_global_0[min((uint)(((int)(1u + (_6270 * 2)))), 127u)]) * _6275;
                                _6287 = -0.0f - _6268;
                                _6292 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_6284, _6285), float2(_6269, _6268)) + _6251), (dot(float2(_6284, _6285), float2(_6287, _6269)) + _6252)));
                                _6297 = _6292.x - _6254;
                                _6299 = select((_6297 < 0.0f), 0.0f, 1.0f);
                                _6301 = _6292.y - _6254;
                                _6303 = select((_6301 < 0.0f), 0.0f, 1.0f);
                                _6307 = _6292.z - _6254;
                                _6309 = select((_6307 < 0.0f), 0.0f, 1.0f);
                                _6313 = _6292.w - _6254;
                                _6315 = select((_6313 < 0.0f), 0.0f, 1.0f);
                                _6322 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _6327 = sqrt((float((int)(_6322)) * 0.25f) + 0.125f) * _6253;
                                _6336 = (_global_0[min((uint)(((int)(0u + (_6322 * 2)))), 127u)]) * _6327;
                                _6337 = (_global_0[min((uint)(((int)(1u + (_6322 * 2)))), 127u)]) * _6327;
                                _6343 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_6336, _6337), float2(_6269, _6268)) + _6251), (dot(float2(_6336, _6337), float2(_6287, _6269)) + _6252)));
                                _6348 = _6343.x - _6254;
                                _6350 = select((_6348 < 0.0f), 0.0f, 1.0f);
                                _6354 = _6343.y - _6254;
                                _6356 = select((_6354 < 0.0f), 0.0f, 1.0f);
                                _6360 = _6343.z - _6254;
                                _6362 = select((_6360 < 0.0f), 0.0f, 1.0f);
                                _6366 = _6343.w - _6254;
                                _6368 = select((_6366 < 0.0f), 0.0f, 1.0f);
                                _6375 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _6380 = sqrt((float((int)(_6375)) * 0.25f) + 0.125f) * _6253;
                                _6389 = (_global_0[min((uint)(((int)(0u + (_6375 * 2)))), 127u)]) * _6380;
                                _6390 = (_global_0[min((uint)(((int)(1u + (_6375 * 2)))), 127u)]) * _6380;
                                _6396 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_6389, _6390), float2(_6269, _6268)) + _6251), (dot(float2(_6389, _6390), float2(_6287, _6269)) + _6252)));
                                _6401 = _6396.x - _6254;
                                _6403 = select((_6401 < 0.0f), 0.0f, 1.0f);
                                _6407 = _6396.y - _6254;
                                _6409 = select((_6407 < 0.0f), 0.0f, 1.0f);
                                _6413 = _6396.z - _6254;
                                _6415 = select((_6413 < 0.0f), 0.0f, 1.0f);
                                _6419 = _6396.w - _6254;
                                _6421 = select((_6419 < 0.0f), 0.0f, 1.0f);
                                _6428 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _6433 = sqrt((float((int)(_6428)) * 0.25f) + 0.125f) * _6253;
                                _6442 = (_global_0[min((uint)(((int)(0u + (_6428 * 2)))), 127u)]) * _6433;
                                _6443 = (_global_0[min((uint)(((int)(1u + (_6428 * 2)))), 127u)]) * _6433;
                                _6449 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_6442, _6443), float2(_6269, _6268)) + _6251), (dot(float2(_6442, _6443), float2(_6287, _6269)) + _6252)));
                                _6454 = _6449.x - _6254;
                                _6456 = select((_6454 < 0.0f), 0.0f, 1.0f);
                                _6460 = _6449.y - _6254;
                                _6462 = select((_6460 < 0.0f), 0.0f, 1.0f);
                                _6466 = _6449.z - _6254;
                                _6468 = select((_6466 < 0.0f), 0.0f, 1.0f);
                                _6472 = _6449.w - _6254;
                                _6474 = select((_6472 < 0.0f), 0.0f, 1.0f);
                                _6475 = ((((((((((((((_6299 + _6303) + _6309) + _6315) + _6350) + _6356) + _6362) + _6368) + _6403) + _6409) + _6415) + _6421) + _6456) + _6462) + _6468) + _6474;
                                _6486 = (saturate(_6475 * 0.0625f) * 2.0f) + -1.0f;
                                _6492 = float((int)(((int)(uint)((int)(_6486 > 0.0f))) - ((int)(uint)((int)(_6486 < 0.0f)))));
                                _6494 = 1.0f - (_6492 * _6486);
                                _6496 = (_6494 * _6494) * _6494;
                                _6504 = -0.0f - _5724;
                                _6511 = saturate((saturate(rsqrt(dot(float3(_6504, _5716, _5713), float3(_6504, _5716, _5713))) * _5713) * _5600) + _5599);
                                _6513 = 1.0f - (_6511 * _6511);
                                _6517 = (0.5f - ((_6492 * 0.5f) * ((1.0f - _6496) - ((_6494 - _6496) * saturate(((1.0f / _6254) * (1.0f / _6475)) * ((((((((((((((((_6299 * _6297) + (_6303 * _6301)) + (_6309 * _6307)) + (_6315 * _6313)) + (_6350 * _6348)) + (_6356 * _6354)) + (_6362 * _6360)) + (_6368 * _6366)) + (_6403 * _6401)) + (_6409 * _6407)) + (_6415 * _6413)) + (_6421 * _6419)) + (_6456 * _6454)) + (_6462 * _6460)) + (_6468 * _6466)) + (_6474 * _6472)))))));
                                _6518 = 1.0f;
                                _6519 = (1.0f - (_6513 * _6513));
                                _6520 = 1;
                                _6521 = _5603;
                              } else {
                                _6517 = 1.0f;
                                _6518 = 0.0f;
                                _6519 = 1.0f;
                                _6520 = 0;
                                _6521 = _5603;
                              }
                            } else {
                              _6517 = 1.0f;
                              _6518 = 0.0f;
                              _6519 = 1.0f;
                              _6520 = 0;
                              _6521 = _5603;
                            }
                          }
                        } else {
                          _6517 = 1.0f;
                          _6518 = 1.0f;
                          _6519 = 1.0f;
                          _6520 = 0;
                          _6521 = 0.0f;
                        }
                        [branch]
                        if (!((_1289 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1289 & 2097152) == 0)) {
                            _6529 = abs(_5724);
                            _6530 = abs(_5725);
                            _6531 = abs(_5726);
                            if (_6529 > max(_6530, _6531)) {
                              _6535 = (_5724 > 0.0f);
                              _6550 = select(_6535, 0.0f, 1.0f);
                              _6551 = 0.0f;
                              _6552 = select(_6535, _5713, _5726);
                              _6553 = _5716;
                              _6554 = _6529;
                            } else {
                              if (_6530 > _6531) {
                                _6541 = (_5716 < -0.0f);
                                _6550 = select(_6541, 0.0f, 1.0f);
                                _6551 = 1.0f;
                                _6552 = _5724;
                                _6553 = select(_6541, _5726, _5713);
                                _6554 = _6530;
                              } else {
                                _6545 = (_5713 < -0.0f);
                                _6550 = select(_6545, 0.0f, 1.0f);
                                _6551 = 2.0f;
                                _6552 = select(_6545, _5724, (-0.0f - _5724));
                                _6553 = _5716;
                                _6554 = _6531;
                              }
                            }
                            _6555 = _6554 * 2.0f;
                            _6560 = -0.0f - _5617;
                            _6569 = ((min(max((_6552 / _6555), _6560), _5617) + _6550) * _5560) + _5562;
                            _6570 = ((min(max((_6553 / _6555), _6560), _5617) + _6551) * _5561) + _5563;
                            _6571 = select(_5663, _5627, _5624);
                            _6576 = ((_6550 + -0.5f) * _5560) + _5562;
                            _6577 = ((_6551 + -0.5f) * _5561) + _5563;
                            _6580 = saturate(1.0f - (_6554 * _5602));
                            _6584 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _6593 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_6584 * 32.665000915527344f) + _296), ((_6584 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _6594 = sin(_6593);
                            _6595 = cos(_6593);
                            _6600 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_6569, _6570), 0.0f))).x) > _6580), 1.0f, 0.0f);
                            _6601 = cbSharedPerViewData.nFrameCounter & 3;
                            _6606 = sqrt((float((int)(_6601)) * 0.25f) + 0.125f) * _6571;
                            _6615 = (_global_0[min((uint)(((int)(0u + (_6601 * 2)))), 127u)]) * _6606;
                            _6616 = (_global_0[min((uint)(((int)(1u + (_6601 * 2)))), 127u)]) * _6606;
                            _6618 = -0.0f - _6594;
                            _6620 = dot(float2(_6615, _6616), float2(_6595, _6594)) + _6569;
                            _6621 = dot(float2(_6615, _6616), float2(_6618, _6595)) + _6570;
                            _6623 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_6620, _6621));
                            _6627 = _6620 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _6628 = _6621 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _6631 = floor(_6576 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _6632 = floor(_6577 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _6637 = floor(((_6576 + _5560) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _6638 = floor(((_6577 + _5561) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _6641 = floor(_6627 + -0.5f);
                            _6642 = floor(_6628 + 0.5f);
                            _6644 = floor(_6627 + 0.5f);
                            _6646 = floor(_6628 + -0.5f);
                            _6647 = (_6641 < _6631);
                            _6648 = (_6642 < _6632);
                            if ((_6647 || _6648) | ((_6641 >= _6637) || (_6642 >= _6638))) {
                              _6657 = _6600;
                            } else {
                              _6657 = _6623.x;
                            }
                            _6658 = (_6644 < _6631);
                            if ((_6658 || _6648) | ((_6644 >= _6637) || (_6642 >= _6638))) {
                              _6666 = _6600;
                            } else {
                              _6666 = _6623.y;
                            }
                            _6667 = (_6646 < _6632);
                            if ((_6658 || _6667) | ((_6644 >= _6637) || (_6646 >= _6638))) {
                              _6675 = _6600;
                            } else {
                              _6675 = _6623.z;
                            }
                            if ((_6647 || _6667) | ((_6641 >= _6637) || (_6646 >= _6638))) {
                              _6683 = _6600;
                            } else {
                              _6683 = _6623.w;
                            }
                            _6684 = _6657 - _6580;
                            _6686 = select((_6684 < 0.0f), 0.0f, 1.0f);
                            _6688 = _6666 - _6580;
                            _6690 = select((_6688 < 0.0f), 0.0f, 1.0f);
                            _6694 = _6675 - _6580;
                            _6696 = select((_6694 < 0.0f), 0.0f, 1.0f);
                            _6700 = _6683 - _6580;
                            _6702 = select((_6700 < 0.0f), 0.0f, 1.0f);
                            _6709 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _6714 = sqrt((float((int)(_6709)) * 0.25f) + 0.125f) * _6571;
                            _6723 = (_global_0[min((uint)(((int)(0u + (_6709 * 2)))), 127u)]) * _6714;
                            _6724 = (_global_0[min((uint)(((int)(1u + (_6709 * 2)))), 127u)]) * _6714;
                            _6727 = dot(float2(_6723, _6724), float2(_6595, _6594)) + _6569;
                            _6728 = dot(float2(_6723, _6724), float2(_6618, _6595)) + _6570;
                            _6730 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_6727, _6728));
                            _6734 = _6727 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _6735 = _6728 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _6738 = floor(_6734 + -0.5f);
                            _6739 = floor(_6735 + 0.5f);
                            _6741 = floor(_6734 + 0.5f);
                            _6743 = floor(_6735 + -0.5f);
                            _6744 = (_6738 < _6631);
                            _6745 = (_6739 < _6632);
                            if ((_6744 || _6745) | ((_6738 >= _6637) || (_6739 >= _6638))) {
                              _6754 = _6600;
                            } else {
                              _6754 = _6730.x;
                            }
                            _6755 = (_6741 < _6631);
                            if ((_6755 || _6745) | ((_6741 >= _6637) || (_6739 >= _6638))) {
                              _6763 = _6600;
                            } else {
                              _6763 = _6730.y;
                            }
                            _6764 = (_6743 < _6632);
                            if ((_6755 || _6764) | ((_6741 >= _6637) || (_6743 >= _6638))) {
                              _6772 = _6600;
                            } else {
                              _6772 = _6730.z;
                            }
                            if ((_6744 || _6764) | ((_6738 >= _6637) || (_6743 >= _6638))) {
                              _6780 = _6600;
                            } else {
                              _6780 = _6730.w;
                            }
                            _6781 = _6754 - _6580;
                            _6783 = select((_6781 < 0.0f), 0.0f, 1.0f);
                            _6787 = _6763 - _6580;
                            _6789 = select((_6787 < 0.0f), 0.0f, 1.0f);
                            _6793 = _6772 - _6580;
                            _6795 = select((_6793 < 0.0f), 0.0f, 1.0f);
                            _6799 = _6780 - _6580;
                            _6801 = select((_6799 < 0.0f), 0.0f, 1.0f);
                            _6808 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _6813 = sqrt((float((int)(_6808)) * 0.25f) + 0.125f) * _6571;
                            _6822 = (_global_0[min((uint)(((int)(0u + (_6808 * 2)))), 127u)]) * _6813;
                            _6823 = (_global_0[min((uint)(((int)(1u + (_6808 * 2)))), 127u)]) * _6813;
                            _6826 = dot(float2(_6822, _6823), float2(_6595, _6594)) + _6569;
                            _6827 = dot(float2(_6822, _6823), float2(_6618, _6595)) + _6570;
                            _6829 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_6826, _6827));
                            _6833 = _6826 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _6834 = _6827 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _6837 = floor(_6833 + -0.5f);
                            _6838 = floor(_6834 + 0.5f);
                            _6840 = floor(_6833 + 0.5f);
                            _6842 = floor(_6834 + -0.5f);
                            _6843 = (_6837 < _6631);
                            _6844 = (_6838 < _6632);
                            if ((_6843 || _6844) | ((_6837 >= _6637) || (_6838 >= _6638))) {
                              _6853 = _6600;
                            } else {
                              _6853 = _6829.x;
                            }
                            _6854 = (_6840 < _6631);
                            if ((_6854 || _6844) | ((_6840 >= _6637) || (_6838 >= _6638))) {
                              _6862 = _6600;
                            } else {
                              _6862 = _6829.y;
                            }
                            _6863 = (_6842 < _6632);
                            if ((_6854 || _6863) | ((_6840 >= _6637) || (_6842 >= _6638))) {
                              _6871 = _6600;
                            } else {
                              _6871 = _6829.z;
                            }
                            if ((_6843 || _6863) | ((_6837 >= _6637) || (_6842 >= _6638))) {
                              _6879 = _6600;
                            } else {
                              _6879 = _6829.w;
                            }
                            _6880 = _6853 - _6580;
                            _6882 = select((_6880 < 0.0f), 0.0f, 1.0f);
                            _6886 = _6862 - _6580;
                            _6888 = select((_6886 < 0.0f), 0.0f, 1.0f);
                            _6892 = _6871 - _6580;
                            _6894 = select((_6892 < 0.0f), 0.0f, 1.0f);
                            _6898 = _6879 - _6580;
                            _6900 = select((_6898 < 0.0f), 0.0f, 1.0f);
                            _6907 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _6912 = sqrt((float((int)(_6907)) * 0.25f) + 0.125f) * _6571;
                            _6921 = (_global_0[min((uint)(((int)(0u + (_6907 * 2)))), 127u)]) * _6912;
                            _6922 = (_global_0[min((uint)(((int)(1u + (_6907 * 2)))), 127u)]) * _6912;
                            _6925 = dot(float2(_6921, _6922), float2(_6595, _6594)) + _6569;
                            _6926 = dot(float2(_6921, _6922), float2(_6618, _6595)) + _6570;
                            _6928 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_6925, _6926));
                            _6932 = _6925 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _6933 = _6926 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _6936 = floor(_6932 + -0.5f);
                            _6937 = floor(_6933 + 0.5f);
                            _6939 = floor(_6932 + 0.5f);
                            _6941 = floor(_6933 + -0.5f);
                            _6942 = (_6936 < _6631);
                            _6943 = (_6937 < _6632);
                            if ((_6942 || _6943) | ((_6936 >= _6637) || (_6937 >= _6638))) {
                              _6952 = _6600;
                            } else {
                              _6952 = _6928.x;
                            }
                            _6953 = (_6939 < _6631);
                            if ((_6953 || _6943) | ((_6939 >= _6637) || (_6937 >= _6638))) {
                              _6961 = _6600;
                            } else {
                              _6961 = _6928.y;
                            }
                            _6962 = (_6941 < _6632);
                            if ((_6953 || _6962) | ((_6939 >= _6637) || (_6941 >= _6638))) {
                              _6970 = _6600;
                            } else {
                              _6970 = _6928.z;
                            }
                            if ((_6942 || _6962) | ((_6936 >= _6637) || (_6941 >= _6638))) {
                              _6978 = _6600;
                            } else {
                              _6978 = _6928.w;
                            }
                            _6979 = _6952 - _6580;
                            _6981 = select((_6979 < 0.0f), 0.0f, 1.0f);
                            _6985 = _6961 - _6580;
                            _6987 = select((_6985 < 0.0f), 0.0f, 1.0f);
                            _6991 = _6970 - _6580;
                            _6993 = select((_6991 < 0.0f), 0.0f, 1.0f);
                            _6997 = _6978 - _6580;
                            _6999 = select((_6997 < 0.0f), 0.0f, 1.0f);
                            _7000 = ((((((((((((((_6690 + _6686) + _6696) + _6702) + _6783) + _6789) + _6795) + _6801) + _6882) + _6888) + _6894) + _6900) + _6981) + _6987) + _6993) + _6999;
                            _7011 = (saturate(_7000 * 0.0625f) * 2.0f) + -1.0f;
                            _7017 = float((int)(((int)(uint)((int)(_7011 > 0.0f))) - ((int)(uint)((int)(_7011 < 0.0f)))));
                            _7019 = 1.0f - (_7017 * _7011);
                            _7021 = (_7019 * _7019) * _7019;
                            _7313 = (0.5f - ((_7017 * 0.5f) * ((1.0f - _7021) - ((_7019 - _7021) * saturate(((1.0f / _6580) * (1.0f / _7000)) * ((((((((((((((((_6690 * _6688) + (_6686 * _6684)) + (_6696 * _6694)) + (_6702 * _6700)) + (_6783 * _6781)) + (_6789 * _6787)) + (_6795 * _6793)) + (_6801 * _6799)) + (_6882 * _6880)) + (_6888 * _6886)) + (_6894 * _6892)) + (_6900 * _6898)) + (_6981 * _6979)) + (_6987 * _6985)) + (_6993 * _6991)) + (_6999 * _6997)))))));
                            _7314 = 1.0f;
                            _7315 = false;
                          } else {
                            _7030 = f16tof32(((uint)((uint)(_5578) >> 16))) / _5726;
                            _7033 = mad((_7030 * _5724), 0.5f, 0.5f);
                            _7034 = mad((_7030 * _5725), 0.5f, 0.5f);
                            if (_5713 > -0.0f) {
                              if ((saturate(_7033) == _7033) && (saturate(_7034) == _7034)) {
                                _7047 = (_7033 * _5560) + _5562;
                                _7048 = (_7034 * _5561) + _5563;
                                _7049 = select(_5663, _5627, _5624);
                                _7050 = saturate(1.0f - (_5713 * _5602));
                                _7054 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _7063 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_7054 * 32.665000915527344f) + _296), ((_7054 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7064 = sin(_7063);
                                _7065 = cos(_7063);
                                _7066 = cbSharedPerViewData.nFrameCounter & 3;
                                _7071 = sqrt((float((int)(_7066)) * 0.25f) + 0.125f) * _7049;
                                _7080 = (_global_0[min((uint)(((int)(0u + (_7066 * 2)))), 127u)]) * _7071;
                                _7081 = (_global_0[min((uint)(((int)(1u + (_7066 * 2)))), 127u)]) * _7071;
                                _7083 = -0.0f - _7064;
                                _7088 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_7080, _7081), float2(_7065, _7064)) + _7047), (dot(float2(_7080, _7081), float2(_7083, _7065)) + _7048)));
                                _7093 = _7088.x - _7050;
                                _7095 = select((_7093 < 0.0f), 0.0f, 1.0f);
                                _7097 = _7088.y - _7050;
                                _7099 = select((_7097 < 0.0f), 0.0f, 1.0f);
                                _7103 = _7088.z - _7050;
                                _7105 = select((_7103 < 0.0f), 0.0f, 1.0f);
                                _7109 = _7088.w - _7050;
                                _7111 = select((_7109 < 0.0f), 0.0f, 1.0f);
                                _7118 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _7123 = sqrt((float((int)(_7118)) * 0.25f) + 0.125f) * _7049;
                                _7132 = (_global_0[min((uint)(((int)(0u + (_7118 * 2)))), 127u)]) * _7123;
                                _7133 = (_global_0[min((uint)(((int)(1u + (_7118 * 2)))), 127u)]) * _7123;
                                _7139 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_7132, _7133), float2(_7065, _7064)) + _7047), (dot(float2(_7132, _7133), float2(_7083, _7065)) + _7048)));
                                _7144 = _7139.x - _7050;
                                _7146 = select((_7144 < 0.0f), 0.0f, 1.0f);
                                _7150 = _7139.y - _7050;
                                _7152 = select((_7150 < 0.0f), 0.0f, 1.0f);
                                _7156 = _7139.z - _7050;
                                _7158 = select((_7156 < 0.0f), 0.0f, 1.0f);
                                _7162 = _7139.w - _7050;
                                _7164 = select((_7162 < 0.0f), 0.0f, 1.0f);
                                _7171 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _7176 = sqrt((float((int)(_7171)) * 0.25f) + 0.125f) * _7049;
                                _7185 = (_global_0[min((uint)(((int)(0u + (_7171 * 2)))), 127u)]) * _7176;
                                _7186 = (_global_0[min((uint)(((int)(1u + (_7171 * 2)))), 127u)]) * _7176;
                                _7192 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_7185, _7186), float2(_7065, _7064)) + _7047), (dot(float2(_7185, _7186), float2(_7083, _7065)) + _7048)));
                                _7197 = _7192.x - _7050;
                                _7199 = select((_7197 < 0.0f), 0.0f, 1.0f);
                                _7203 = _7192.y - _7050;
                                _7205 = select((_7203 < 0.0f), 0.0f, 1.0f);
                                _7209 = _7192.z - _7050;
                                _7211 = select((_7209 < 0.0f), 0.0f, 1.0f);
                                _7215 = _7192.w - _7050;
                                _7217 = select((_7215 < 0.0f), 0.0f, 1.0f);
                                _7224 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _7229 = sqrt((float((int)(_7224)) * 0.25f) + 0.125f) * _7049;
                                _7238 = (_global_0[min((uint)(((int)(0u + (_7224 * 2)))), 127u)]) * _7229;
                                _7239 = (_global_0[min((uint)(((int)(1u + (_7224 * 2)))), 127u)]) * _7229;
                                _7245 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_7238, _7239), float2(_7065, _7064)) + _7047), (dot(float2(_7238, _7239), float2(_7083, _7065)) + _7048)));
                                _7250 = _7245.x - _7050;
                                _7252 = select((_7250 < 0.0f), 0.0f, 1.0f);
                                _7256 = _7245.y - _7050;
                                _7258 = select((_7256 < 0.0f), 0.0f, 1.0f);
                                _7262 = _7245.z - _7050;
                                _7264 = select((_7262 < 0.0f), 0.0f, 1.0f);
                                _7268 = _7245.w - _7050;
                                _7270 = select((_7268 < 0.0f), 0.0f, 1.0f);
                                _7271 = ((((((((((((((_7095 + _7099) + _7105) + _7111) + _7146) + _7152) + _7158) + _7164) + _7199) + _7205) + _7211) + _7217) + _7252) + _7258) + _7264) + _7270;
                                _7282 = (saturate(_7271 * 0.0625f) * 2.0f) + -1.0f;
                                _7288 = float((int)(((int)(uint)((int)(_7282 > 0.0f))) - ((int)(uint)((int)(_7282 < 0.0f)))));
                                _7290 = 1.0f - (_7288 * _7282);
                                _7292 = (_7290 * _7290) * _7290;
                                _7300 = -0.0f - _5724;
                                _7307 = saturate((saturate(rsqrt(dot(float3(_7300, _5716, _5713), float3(_7300, _5716, _5713))) * _5713) * _5600) + _5599);
                                _7309 = 1.0f - (_7307 * _7307);
                                _7313 = (0.5f - ((_7288 * 0.5f) * ((1.0f - _7292) - ((_7290 - _7292) * saturate(((1.0f / _7050) * (1.0f / _7271)) * ((((((((((((((((_7095 * _7093) + (_7099 * _7097)) + (_7105 * _7103)) + (_7111 * _7109)) + (_7146 * _7144)) + (_7152 * _7150)) + (_7158 * _7156)) + (_7164 * _7162)) + (_7199 * _7197)) + (_7205 * _7203)) + (_7211 * _7209)) + (_7217 * _7215)) + (_7252 * _7250)) + (_7258 * _7256)) + (_7264 * _7262)) + (_7270 * _7268)))))));
                                _7314 = (1.0f - (_7309 * _7309));
                                _7315 = false;
                              } else {
                                _7313 = 1.0f;
                                _7314 = 1.0f;
                                _7315 = true;
                              }
                            } else {
                              _7313 = 1.0f;
                              _7314 = 1.0f;
                              _7315 = true;
                            }
                          }
                        } else {
                          _7313 = 1.0f;
                          _7314 = 1.0f;
                          _7315 = true;
                        }
                        if (_6520 == 0) {
                          if (!_7315) {
                            _7333 = _6517;
                            _7334 = ((_7314 * (_7313 + -1.0f)) + 1.0f);
                            _7335 = 0.0f;
                            _7336 = _6518;
                          } else {
                            _7333 = _6517;
                            _7334 = _7313;
                            _7335 = 0.0f;
                            _7336 = _6518;
                          }
                        } else {
                          if (_7315) {
                            _7333 = ((_6519 * (_6517 + -1.0f)) + 1.0f);
                            _7334 = _7313;
                            _7335 = 1.0f;
                            _7336 = ((_6519 * (_6518 + -1.0f)) + 1.0f);
                          } else {
                            _7333 = _6517;
                            _7334 = _7313;
                            _7335 = (_6519 * _5603);
                            _7336 = _6518;
                          }
                        }
                        _7339 = (_7335 * (_7333 - _7334)) + _7334;
                        [branch]
                        if (!((_1289 & 2048) == 0)) {
                          _7341 = _313 - _5517;
                          _7342 = _314 - _5518;
                          _7343 = _315 - _5519;
                          _7358 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _7343, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _7342, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _7341)));
                          _7361 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _7343, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _7342, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _7341)));
                          _7364 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _7343, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _7342, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _7341)));
                          _7366 = rsqrt(dot(float3(_7358, _7361, _7364), float3(_7358, _7361, _7364)));
                          _7367 = _7366 * _7358;
                          _7368 = _7366 * _7361;
                          _7369 = _7366 * _7364;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_5551) >> 16))];
                          _7377 = (abs(_7368) + abs(_7367)) + abs(_7369);
                          _7378 = _7367 / _7377;
                          _7379 = _7368 / _7377;
                          _7381 = !((_7369 / _7377) >= 0.0f);
                          if (_7381) {
                            _7394 = ((1.0f - abs(_7379)) * select((_7378 >= 0.0f), 1.0f, -1.0f));
                            _7395 = ((1.0f - abs(_7378)) * select((_7379 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _7394 = _7378;
                            _7395 = _7379;
                          }
                          _7401 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_7394 * 0.5f) + 0.5f), ((_7395 * 0.5f) + 0.5f)), 0.0f);
                          if (_7401.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_5551 & 65535))];
                            if (_7381) {
                              _7420 = ((1.0f - abs(_7379)) * select((_7378 >= 0.0f), 1.0f, -1.0f));
                              _7421 = ((1.0f - abs(_7378)) * select((_7379 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _7420 = _7378;
                              _7421 = _7379;
                            }
                            _7426 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_7420 * 0.5f) + 0.5f), ((_7421 * 0.5f) + 0.5f)), 0.0f);
                            _7446 = mad(saturate(((log2(sqrt(((_7341 * _7341) + (_7342 * _7342)) + (_7343 * _7343))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _7447 = max(9.999999747378752e-06f, _7401.x);
                            _7448 = _7426.x / _7447;
                            _7449 = _7426.y / _7447;
                            _7451 = _7426.w / _7447;
                            _7456 = ((0.375f - _7449) * 4.999999873689376e-06f) + _7449;
                            _7459 = -0.0f - _7448;
                            _7460 = mad(_7459, _7456, (_7426.z / _7447));
                            _7462 = 1.0f / mad(_7459, _7448, _7456);
                            _7463 = _7462 * _7460;
                            _7468 = _7446 - _7448;
                            _7473 = (((_7446 * _7446) - _7456) - (_7463 * _7468)) / mad((-0.0f - _7460), _7463, mad((-0.0f - _7456), _7456, (((0.375f - _7451) * 4.999999873689376e-06f) + _7451)));
                            _7475 = (_7462 * _7468) - (_7473 * _7463);
                            _7478 = 1.0f / _7473;
                            _7479 = _7475 * _7478;
                            _7484 = sqrt(((_7479 * _7479) * 0.25f) - ((1.0f - dot(float2(_7475, _7473), float2(_7448, _7456))) * _7478));
                            _7486 = (_7479 * -0.5f) - _7484;
                            _7488 = _7484 - (_7479 * 0.5f);
                            _7490 = select((_7486 < _7446), 1.0f, 0.0f);
                            _7495 = (_7490 + -0.05000000074505806f) / (_7486 - _7446);
                            _7501 = (((select((_7488 < _7446), 1.0f, 0.0f) - _7490) / (_7488 - _7486)) - _7495) / (_7488 - _7446);
                            _7503 = _7495 - (_7501 * _7486);
                            _7516 = (exp2((_7401.x * -1.4426950216293335f) * saturate((dot(float2(_7448, _7456), float2((_7503 - (_7501 * _7446)), _7501)) + 0.05000000074505806f) - (_7503 * _7446))) * _7339);
                          } else {
                            _7516 = _7339;
                          }
                        } else {
                          _7516 = _7339;
                        }
                        _7522 = (_7516 * _5687);
                        _7523 = (lerp(_7516, _7336, _7335));
                        _7524 = _7335;
                        _7525 = _6521;
                        _7526 = _7516;
                      } else {
                        _7522 = _5687;
                        _7523 = 1.0f;
                        _7524 = 0.0f;
                        _7525 = 0.0f;
                        _7526 = 1.0f;
                      }
                      [branch]
                      if (!(_5605 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _5605)))];
                        _7538 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_5666, _5512, mad(_5665, _5507, (_5664 * _5502)))), (-0.0f - mad(_5666, _5513, mad(_5665, _5508, (_5664 * _5503)))), (-0.0f - mad(_5666, _5514, mad(_5665, _5509, (_5664 * _5504))))), 0.0f);
                        _7546 = (_7538.x * _5580);
                        _7547 = (_7538.y * _5581);
                        _7548 = (_7538.z * _5583);
                      } else {
                        _7546 = _5580;
                        _7547 = _5581;
                        _7548 = _5583;
                      }
                      [branch]
                      if (!(_7522 == 0.0f)) {
                        bool __branch_chain_7551;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _7567 = 0;
                          __branch_chain_7551 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _7567 = 1;
                            __branch_chain_7551 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _7567 = 2;
                              __branch_chain_7551 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _7567 = 3;
                                __branch_chain_7551 = true;
                              } else {
                                _7588 = _7522;
                                __branch_chain_7551 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_7551) {
                          while(true) {
                            _7570 = srvDeferredShadingEvaluateAdaptationPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                            if (_7567 == 0) {
                              _7584 = _7570.x;
                            } else {
                              if (_7567 == 1) {
                                _7584 = _7570.y;
                              } else {
                                if (_7567 == 2) {
                                  _7584 = _7570.z;
                                } else {
                                  _7584 = _7570.w;
                                }
                              }
                            }
                            _7588 = ((_7584 * _7584) * _5687);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_7588 == 0.0f)) {
                            [branch]
                            if (_5718) {
                              [branch]
                              if (!((_5554 & 1) == 0)) {
                                _7604 = max(max(_7546, _7547), _7548);
                                if (_7604 > 0.0f) {
                                  _7614 = saturate(_7546 / _7604);
                                  _7615 = saturate(_7547 / _7604);
                                  _7616 = saturate(_7548 / _7604);
                                } else {
                                  _7614 = _7546;
                                  _7615 = _7547;
                                  _7616 = _7548;
                                }
                                _7617 = (_7615 < _7616);
                                _7618 = select(_7617, _7616, _7615);
                                _7619 = select(_7617, _7615, _7616);
                                _7620 = select(_7617, -1.0f, 0.0f);
                                _7621 = (_7614 < _7618);
                                _7623 = select(_7621, _7618, _7614);
                                _7624 = select(_7621, _7614, _7618);
                                _7628 = _7623 - select((_7624 < _7619), _7624, _7619);
                                _7634 = abs(select(_7621, (-0.3333333432674408f - _7620), _7620) + ((_7624 - _7619) / ((_7628 * 6.0f) + 9.999999682655225e-21f)));
                                if (_7634 < 0.6666666865348816f) {
                                  _7647 = ((saturate(((float)((uint)((uint)(((uint)(_5554) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7634 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7634)) + _7634);
                                } else {
                                  _7647 = _7634;
                                }
                                _7648 = saturate((_7628 / (_7623 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_5554) >> 1) & 255)))) * 0.003921499941498041f));
                                _7649 = saturate(_7623);
                                if (!(_7648 <= 0.0f)) {
                                  _7652 = saturate(_7647);
                                  _7656 = select(((_7652 * 360.0f) >= 360.0f), 0.0f, (_7652 * 6.0f));
                                  _7657 = int(_7656);
                                  _7659 = _7656 - float((int)(_7657));
                                  _7661 = _7649 * (1.0f - _7648);
                                  _7664 = (1.0f - (_7659 * _7648)) * _7649;
                                  _7668 = (1.0f - ((1.0f - _7659) * _7648)) * _7649;
                                  switch (_7657) {
                                    case 0: {
                                      _7676 = _7649;
                                      _7677 = _7668;
                                      _7678 = _7661;
                                      break;
                                    }
                                    case 1: {
                                      _7676 = _7664;
                                      _7677 = _7649;
                                      _7678 = _7661;
                                      break;
                                    }
                                    case 2: {
                                      _7676 = _7661;
                                      _7677 = _7649;
                                      _7678 = _7668;
                                      break;
                                    }
                                    case 3: {
                                      _7676 = _7661;
                                      _7677 = _7664;
                                      _7678 = _7649;
                                      break;
                                    }
                                    case 4: {
                                      _7676 = _7668;
                                      _7677 = _7661;
                                      _7678 = _7649;
                                      break;
                                    }
                                    case 5: {
                                      _7676 = _7649;
                                      _7677 = _7661;
                                      _7678 = _7664;
                                      break;
                                    }
                                    default: {
                                      _7676 = 0.0f;
                                      _7677 = 0.0f;
                                      _7678 = 0.0f;
                                      break;
                                    }
                                  }
                                } else {
                                  _7676 = _7649;
                                  _7677 = _7649;
                                  _7678 = _7649;
                                }
                                _7679 = _7676 * _7604;
                                _7680 = _7677 * _7604;
                                _7681 = _7678 * _7604;
                                _7683 = saturate(_7526 * 1.0101009607315063f);
                                _7694 = ((_7683 * (_7546 - _7679)) + _7679);
                                _7695 = ((_7683 * (_7547 - _7680)) + _7680);
                                _7696 = (lerp(_7681, _7548, _7683));
                                _7697 = _7525;
                              } else {
                                _7694 = _7546;
                                _7695 = _7547;
                                _7696 = _7548;
                                _7697 = _7525;
                              }
                            } else {
                              _7694 = _7546;
                              _7695 = _7547;
                              _7696 = _7548;
                              _7697 = 0.0f;
                            }
                            _7698 = select(_162, (_7523 * _5687), _7588);
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _7705 = srvLightMappingData[_1286];
                              if (!(_7705 == -1)) {
                                _7710 = srvLightIndexData[_7705].nLayerIndex;
                                _7712 = srvLightIndexData[_7705].vAtlasOrigin.x;
                                _7713 = srvLightIndexData[_7705].vAtlasOrigin.y;
                                _7715 = srvLightIndexData[_7705].vScreenOrigin.x;
                                _7716 = srvLightIndexData[_7705].vScreenOrigin.y;
                                _7725 = ((int)(_7710 * 5)) & 31;
                                _7728 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7712 + _65) - _7715)), ((int)((_7713 + _66) - _7716)), 0)))).x) & ((int)(31 << _7725)))) >> _7725;
                                _7733 = ((float)((uint)((uint)((uint)(_7728) >> 1)))) * 0.06666667014360428f;
                                _7739 = (_7733 * _7698);
                                _7740 = (select(_162, ((float)((bool)(uint)((_7728 & 1) != 0))), _7733) * _7698);
                              } else {
                                _7739 = _7698;
                                _7740 = _7698;
                              }
                            } else {
                              _7739 = _7698;
                              _7740 = _7698;
                            }
                            _7744 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _7747 = select(_7744, (_7739 * _1019), _7739);
                            _7749 = select(_162, _7524, _7697);
                            _7750 = _5670 * _5669;
                            _7751 = _5671 * _5669;
                            _7752 = _5672 * _5669;
                            _7753 = _5591 * _5522;
                            _7754 = _5591 * _5523;
                            _7755 = _5591 * _5524;
                            _7756 = _7750 + _7753;
                            _7757 = _7751 + _7754;
                            _7758 = _7752 + _7755;
                            _7759 = _7750 - _7753;
                            _7760 = _7751 - _7754;
                            _7761 = _7752 - _7755;
                            _7762 = (_5591 > 0.0f);
                            _7763 = dot(float3(_7756, _7757, _7758), float3(_7756, _7757, _7758));
                            _7764 = rsqrt(_7763);
                            [branch]
                            if (_7762) {
                              _7767 = rsqrt(dot(float3(_7759, _7760, _7761), float3(_7759, _7760, _7761)));
                              _7768 = _7767 * _7764;
                              _7770 = dot(float3(_7756, _7757, _7758), float3(_7759, _7760, _7761)) * _7768;
                              _7789 = (_7768 / ((_7768 + 0.5f) + (_7770 * 0.5f)));
                              _7790 = (((dot(float3(_147, _148, _149), float3(_7759, _7760, _7761)) * _7767) + (dot(float3(_147, _148, _149), float3(_7756, _7757, _7758)) * _7764)) * 0.5f);
                              _7791 = _7770;
                            } else {
                              _7789 = (1.0f / (_7763 + 1.0f));
                              _7790 = dot(float3(_147, _148, _149), float3((_7764 * _7756), (_7764 * _7757), (_7764 * _7758)));
                              _7791 = 1.0f;
                            }
                            if (_5593 > 0.0f) {
                              _7797 = sqrt(saturate((_5593 * _5593) * _7789));
                              if (_7790 < _7797) {
                                _7802 = max(_7790, (-0.0f - _7797)) + _7797;
                                _7807 = ((_7802 * _7802) / (_7797 * 4.0f));
                              } else {
                                _7807 = _7790;
                              }
                            } else {
                              _7807 = _7790;
                            }
                            if (_7762) {
                              _7809 = -0.0f - _322;
                              _7810 = -0.0f - _323;
                              _7811 = -0.0f - _321;
                              _7813 = dot(float3(_7809, _7810, _7811), float3(_147, _148, _149)) * 2.0f;
                              _7817 = _7809 - (_7813 * _147);
                              _7818 = _7810 - (_7813 * _148);
                              _7819 = _7811 - (_7813 * _149);
                              _7820 = _7759 - _7756;
                              _7821 = _7760 - _7757;
                              _7822 = _7761 - _7758;
                              _7823 = dot(float3(_7817, _7818, _7819), float3(_7820, _7821, _7822));
                              _7829 = sqrt(((_7820 * _7820) + (_7821 * _7821)) + (_7822 * _7822));
                              _7838 = saturate(((dot(float3(_7817, _7818, _7819), float3(_7756, _7757, _7758)) * _7823) - dot(float3(_7756, _7757, _7758), float3(_7820, _7821, _7822))) / ((_7829 * _7829) - (_7823 * _7823)));
                              _7842 = (_7838 * _7820) + _7756;
                              _7843 = (_7838 * _7821) + _7757;
                              _7844 = (_7838 * _7822) + _7758;
                              _7845 = dot(float3(_7842, _7843, _7844), float3(_7817, _7818, _7819));
                              _7849 = (_7845 * _7817) - _7842;
                              _7850 = (_7845 * _7818) - _7843;
                              _7851 = (_7845 * _7819) - _7844;
                              _7859 = saturate(0.009999999776482582f / sqrt(((_7849 * _7849) + (_7850 * _7850)) + (_7851 * _7851)));
                              _7867 = ((_7859 * _7849) + _7842);
                              _7868 = ((_7859 * _7850) + _7843);
                              _7869 = ((_7859 * _7851) + _7844);
                            } else {
                              _7867 = _7756;
                              _7868 = _7757;
                              _7869 = _7758;
                            }
                            _7871 = rsqrt(dot(float3(_7867, _7868, _7869), float3(_7867, _7868, _7869)));
                            _7872 = _7871 * _7867;
                            _7873 = _7871 * _7868;
                            _7874 = _7871 * _7869;
                            _7875 = _217 * _217;
                            _7876 = 1.0f - _7875;
                            _7879 = saturate((_5593 * _7876) * _7871);
                            _7881 = saturate(_7871 * f16tof32(_5536));
                            _7883 = rsqrt(dot(float3(_7750, _7751, _7752), float3(_7750, _7751, _7752)));
                            _7884 = _7883 * _7750;
                            _7885 = _7883 * _7751;
                            _7886 = _7883 * _7752;
                            _7887 = _5660 && _5662;
                            if (_7887) {
                              _7890 = saturate(dot(float3(_147, _148, _149), float3(_7872, _7873, _7874)));
                              _7897 = (_7890 * (_147 - _289)) + _289;
                              _7898 = (_7890 * (_148 - _290)) + _290;
                              _7899 = (_7890 * (_149 - _291)) + _291;
                              _7901 = rsqrt(dot(float3(_7897, _7898, _7899), float3(_7897, _7898, _7899)));
                              _7906 = (_7897 * _7901);
                              _7907 = (_7898 * _7901);
                              _7908 = (_7899 * _7901);
                            } else {
                              _7906 = _147;
                              _7907 = _148;
                              _7908 = _149;
                            }
                            _7909 = dot(float3(_7906, _7907, _7908), float3(_7872, _7873, _7874));
                            _7910 = dot(float3(_7906, _7907, _7908), float3(_322, _323, _321));
                            _7911 = dot(float3(_322, _323, _321), float3(_7872, _7873, _7874));
                            _7914 = rsqrt((_7911 * 2.0f) + 2.0f);
                            _7917 = saturate(_7914 * (_7910 + _7909));
                            _7920 = saturate((_7914 * _7911) + _7914);
                            _7921 = (_7879 > 0.0f);
                            if (_7921) {
                              _7925 = sqrt(1.0f - (_7879 * _7879));
                              _7927 = (_7909 * 2.0f) * _7910;
                              _7928 = _7927 - _7911;
                              if (!(_7928 >= _7925)) {
                                _7936 = rsqrt(1.0f - (_7928 * _7928)) * _7879;
                                _7939 = _7936 * (_7910 - (_7928 * _7909));
                                _7940 = _7910 * _7910;
                                _7945 = _7936 * (((_7940 * 2.0f) + -1.0f) - (_7928 * _7911));
                                _7954 = sqrt(saturate((((1.0f - (_7909 * _7909)) - _7940) - (_7911 * _7911)) + (_7927 * _7911)));
                                _7955 = _7954 * _7936;
                                _7958 = ((_7910 * 2.0f) * _7936) * _7954;
                                _7960 = (_7925 * _7909) + _7910;
                                _7961 = _7960 + _7939;
                                _7962 = _7925 * _7911;
                                _7964 = (_7962 + 1.0f) + _7945;
                                _7965 = _7955 * _7964;
                                _7966 = _7961 * _7964;
                                _7967 = _7958 * _7961;
                                _7972 = (((_7961 * 0.25f) * _7958) - (_7965 * 0.5f)) * _7966;
                                _7986 = (((_7967 - (_7965 * 2.0f)) * _7967) + (_7965 * _7965)) + ((((-0.5f - ((_7964 + _7962) * 0.5f)) * _7966) + ((_7964 * _7964) * _7960)) * _7961);
                                _7991 = (_7972 * 2.0f) / ((_7986 * _7986) + (_7972 * _7972));
                                _7992 = _7986 * _7991;
                                _7994 = 1.0f - (_7972 * _7991);
                                _8000 = ((_7992 * _7958) + _7962) + (_7994 * _7945);
                                _8003 = rsqrt((_8000 * 2.0f) + 2.0f);
                                _8012 = saturate((_8000 * _8003) + _8003);
                                _8013 = saturate(((_7960 + (_7992 * _7955)) + (_7994 * _7939)) * _8003);
                              } else {
                                _8012 = abs(_7910);
                                _8013 = 1.0f;
                              }
                            } else {
                              _8012 = _7920;
                              _8013 = _7917;
                            }
                            _8014 = saturate(_7910);
                            _8015 = saturate(_7807);
                            _8016 = dot(float3(_7906, _7907, _7908), float3(_7884, _7885, _7886));
                            _8017 = saturate(_8016);
                            _8018 = _7875 * _7875;
                            _8019 = (_7881 > 0.0f);
                            if (_8019) {
                              _8028 = saturate(((_7881 * _7881) / ((_8012 * 3.5999999046325684f) + 0.4000000059604645f)) + _8018);
                            } else {
                              _8028 = _8018;
                            }
                            if (_7921) {
                              _8037 = (((_7879 * 0.25f) * ((sqrt(_8028) * 3.0f) + _7879)) / (_8012 + 0.0010000000474974513f)) + _8028;
                              _8040 = _8037;
                              _8041 = (_8028 / _8037);
                            } else {
                              _8040 = _8028;
                              _8041 = 1.0f;
                            }
                            _8042 = (_7791 < 1.0f);
                            if (_8042) {
                              _8048 = sqrt((1.000100016593933f - _7791) / max(9.999999974752427e-07f, (_7791 + 1.0f)));
                              _8061 = (sqrt(_8040 / ((((_8048 * 0.25f) * ((sqrt(_8040) * 3.0f) + _8048)) / (_8012 + 0.0010000000474974513f)) + _8040)) * _8041);
                            } else {
                              _8061 = _8041;
                            }
                            _8065 = (((_8028 * _8013) - _8013) * _8013) + 1.0f;
                            _8068 = (_8028 / (_8065 * _8065)) * _8061;
                            _8069 = 1.0f - _201;
                            _8070 = 1.0f - _202;
                            _8071 = 1.0f - _203;
                            _8072 = saturate(_8012);
                            _8073 = 1.0f - _8072;
                            _8074 = log2(_8073);
                            _8076 = exp2(_8074 * 5.0f);
                            _8080 = (_8076 * _8069) + _201;
                            _8081 = (_8076 * _8070) + _202;
                            _8082 = (_8076 * _8071) + _203;
                            _8083 = abs(_7910);
                            _8085 = saturate(_8083 + 9.999999747378752e-06f);
                            _8086 = sqrt(_8028);
                            _8087 = 1.0f - _8086;
                            _8095 = 0.5f / ((((_8087 * _8085) + _8086) * _8015) + (((_8087 * _8015) + _8086) * _8085));
                            if (_162) {
                              _8105 = ((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                              _8106 = ((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                              _8107 = ((_115 + -0.5f) * 0.5f) + 0.5f;
                              _8124 = ((dot(float3((-0.0f - _7906), (-0.0f - _7907), (-0.0f - _7908)), float3(_7884, _7885, _7886)) + dot(float3((-0.0f - _322), (-0.0f - _323), (-0.0f - _321)), float3(_7884, _7885, _7886))) * 0.5f) * exp2(log2(1.0f - _8014) * (11.0f - (((float)((uint)((uint)((uint)(_259) >> 2)))) * 0.1666666716337204f)));
                              _8131 = dot(float3(_113, _114, _115), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                              _8134 = saturate((_8131 + -0.009999999776482582f) * -100.0f);
                              _8139 = ((_8134 * _8134) * 3.0f) * (3.0f - (_8134 * 2.0f));
                              _8146 = 10.0f - (exp2(log2(saturate(_8131 * 5.0f)) * 3.0f) * 9.0f);
                              _8147 = saturate(_8017 + _8105) * _8017;
                              _8148 = saturate(_8017 + _8106) * _8017;
                              _8149 = saturate(_8017 + _8107) * _8017;
                              _8168 = (max(((_8139 + _8105) * _8124), 0.0f) * _8146) + sqrt(_8147 * _8147);
                              _8169 = (max(((_8139 + _8106) * _8124), 0.0f) * _8146) + sqrt(_8148 * _8148);
                              _8170 = (max(((_8139 + _8107) * _8124), 0.0f) * _8146) + sqrt(_8149 * _8149);
                              _8171 = _7872 + _322;
                              _8172 = _7873 + _323;
                              _8173 = _7874 + _321;
                              _8175 = rsqrt(dot(float3(_8171, _8172, _8173), float3(_8171, _8172, _8173)));
                              if (!(select((_258 != 0), 1.0f, 0.0f) < 1.0f)) {
                                _8189 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                                _8190 = _8189 * _147;
                                _8191 = _8189 * _148;
                                _8192 = _8189 * _149;
                                _8195 = (abs(_8190) < abs(_8191));
                                _8196 = select(_8195, 1.0f, 0.0f);
                                _8197 = select(_8195, 0.0f, 1.0f);
                                _8198 = _8197 * _8192;
                                _8200 = -0.0f - (_8192 * _8196);
                                _8203 = (_8196 * _8191) - (_8197 * _8190);
                                _8205 = rsqrt(dot(float3(_8198, _8200, _8203), float3(_8198, _8200, _8203)));
                                _8206 = _8198 * _8205;
                                _8207 = _8205 * _8200;
                                _8208 = _8203 * _8205;
                                _8211 = (_8207 * _8192) - (_8208 * _8191);
                                _8214 = (_8208 * _8190) - (_8206 * _8192);
                                _8217 = (_8206 * _8191) - (_8207 * _8190);
                                _8219 = rsqrt(dot(float3(_8211, _8214, _8217), float3(_8211, _8214, _8217)));
                                _8231 = saturate(abs(_257 + -2.5f) + -0.5f) + -0.5f;
                                _8232 = saturate(1.5f - abs(_257 + -1.5f)) + -0.5f;
                                _8234 = rsqrt(dot(float2(_8231, _8232), float2(_8231, _8232)));
                                _8235 = _8234 * _8231;
                                _8236 = _8234 * _8232;
                                _8243 = ((_8211 * _8219) * _8235) + (_8236 * _8206);
                                _8244 = ((_8214 * _8219) * _8235) + (_8236 * _8207);
                                _8245 = ((_8217 * _8219) * _8235) + (_8236 * _8208);
                                _8248 = min(max(dot(float3(_8243, _8244, _8245), float3(_7872, _7873, _7874)), -1.0f), 1.0f);
                                _8251 = min(max(dot(float3(_8243, _8244, _8245), float3(_322, _323, _321)), -1.0f), 1.0f);
                                _8252 = abs(_8251);
                                _8257 = (1.5707963705062866f - (_8252 * 0.1565829962491989f)) * sqrt(1.0f - _8252);
                                _8261 = abs(_8248);
                                _8266 = (1.5707963705062866f - (_8261 * 0.1565829962491989f)) * sqrt(1.0f - _8261);
                                _8273 = cos(abs(select((_8248 >= 0.0f), _8266, (3.1415927410125732f - _8266)) - select((_8251 >= 0.0f), _8257, (3.1415927410125732f - _8257))) * 0.5f);
                                _8277 = _7872 - (_8248 * _8243);
                                _8278 = _7873 - (_8248 * _8244);
                                _8279 = _7874 - (_8248 * _8245);
                                _8283 = _322 - (_8251 * _8243);
                                _8284 = _323 - (_8251 * _8244);
                                _8285 = _321 - (_8251 * _8245);
                                _8292 = rsqrt((dot(float3(_8283, _8284, _8285), float3(_8283, _8284, _8285)) * dot(float3(_8277, _8278, _8279), float3(_8277, _8278, _8279))) + 9.999999747378752e-05f) * dot(float3(_8277, _8278, _8279), float3(_8283, _8284, _8285));
                                _8296 = sqrt(saturate((_8292 * 0.5f) + 0.5f));
                                _8300 = _7875 * 0.5f;
                                _8301 = _7875 * 2.0f;
                                _8305 = exp2((1.0f - abs(_7749)) * -72.13475036621094f);
                                if (!((_259 & 1) == 0)) {
                                  _8312 = select(((select(((_259 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_7749 == -1.0f))), 0.0f, _8305);
                                } else {
                                  _8312 = _8305;
                                }
                                _8316 = saturate((dot(float3(_147, _148, _149), float3(_7872, _7873, _7874)) + 0.5f) * 0.6666666865348816f);
                                _8326 = (_8251 + _8248) + ((((_8296 * 0.9975510239601135f) * sqrt(1.0f - (_8251 * _8251))) - (_8251 * 0.06994284689426422f)) * 0.13988569378852844f);
                                _8328 = (_7875 * 1.4142135381698608f) * _8296;
                                _8341 = 1.0f - sqrt(saturate((_7911 * 0.5f) + 0.5f));
                                _8342 = _8341 * _8341;
                                _8348 = saturate(-0.0f - _7911);
                                _8351 = (1.0f - saturate(_8348)) * _8316;
                                _8360 = ((((_8296 * 0.5f) * (exp2((((_8326 * _8326) * -0.5f) / (_8328 * _8328)) * 1.4426950216293335f) / (_8328 * 2.5066282749176025f))) * min(_205, 0.5f)) * (((_8342 * _8342) * (_8341 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_8351, 1.0f, _8312));
                                _8362 = (_8248 + -0.03500000014901161f) + _8251;
                                _8371 = 1.0f / ((1.190000057220459f / _8273) + (_8273 * 0.36000001430511475f));
                                _8376 = ((_8371 * (0.6000000238418579f - (_8292 * 0.800000011920929f))) + 1.0f) * _8296;
                                _8382 = 1.0f - (sqrt(saturate(1.0f - (_8376 * _8376))) * _8273);
                                _8383 = _8382 * _8382;
                                _8387 = 0.9534794092178345f - ((_8383 * _8383) * (_8382 * 0.9534794092178345f));
                                _8388 = _8376 * _8371;
                                _8393 = (sqrt(1.0f - (_8388 * _8388)) * 0.5f) / _8273;
                                _8412 = 1.0f - saturate((_8348 + -0.44999998807907104f) * 2.222222328186035f);
                                _8415 = ((1.0f - _8316) * _8312) + _8316;
                                _8418 = ((_8387 * _8387) * (exp2((((_8362 * _8362) * -0.5f) / (_8300 * _8300)) * 1.4426950216293335f) / (_7875 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_8292 * 5.2658371925354f));
                                _8432 = (_8248 + -0.14000000059604645f) + _8251;
                                _8442 = 1.0f - (_8273 * 0.5f);
                                _8443 = _8442 * _8442;
                                _8447 = (_8443 * _8443) * (0.9534794092178345f - (_8273 * 0.47673970460891724f));
                                _8449 = 0.9534794092178345f - _8447;
                                _8451 = (_8449 * _8449) * (_8447 + 0.04652056470513344f);
                                _8454 = exp2((_8292 * 24.525815963745117f) + -24.208423614501953f);
                                _8467 = ((exp2((((_8432 * _8432) * -0.5f) / (_8301 * _8301)) * 1.4426950216293335f) / (_7875 * 5.013256549835205f)) * (lerp(_8451, 1.0f, _170))) * (((exp2((saturate(dot(float3((_8175 * _8171), (_8175 * _8172), (_8175 * _8173)), float3(_147, _148, _149))) * 17.312339782714844f) + -14.109557151794434f) - _8454) * _170) + _8454);
                                _9247 = (((((exp2(log2(max(_113, 0.0f)) * _8393) * _8415) * _8418) * _8412) + _8360) + (_8467 * _113));
                                _9248 = (((((exp2(log2(max(_114, 0.0f)) * _8393) * _8415) * _8418) * _8412) + _8360) + (_8467 * _114));
                                _9249 = (((((exp2(log2(max(_115, 0.0f)) * _8393) * _8415) * _8418) * _8412) + _8360) + (_8467 * _115));
                                _9250 = _8168;
                                _9251 = _8169;
                                _9252 = _8170;
                              } else {
                                _9247 = 0.0f;
                                _9248 = 0.0f;
                                _9249 = 0.0f;
                                _9250 = _8168;
                                _9251 = _8169;
                                _9252 = _8170;
                              }
                            } else {
                              if (_7887) {
                                _8485 = ((float)((uint)((uint)(_261 & 15)))) * 0.06666667014360428f;
                                _8486 = _217 * 0.0317460335791111f;
                                _8489 = min(1.0f, max((_8486 * ((float)((uint)((uint)((uint)(_260) >> 2))))), 0.019999999552965164f));
                                _8492 = min(1.0f, max((_8486 * ((float)((uint)((uint)((((int)(_260 << 4)) & 48) | ((uint)(_261) >> 4)))))), 0.019999999552965164f));
                                _8495 = ((_8492 - _8489) * _8485) + _8489;
                                _8496 = _8495 * _8495;
                                _8500 = saturate(abs(_8014) + 9.999999747378752e-06f);
                                _8501 = sqrt(_8496 * _8496);
                                _8502 = 1.0f - _8501;
                                _8511 = _8489 * _8489;
                                _8512 = _8511 * _8511;
                                if (_8019) {
                                  _8521 = saturate(((_7881 * _7881) / ((_8012 * 3.5999999046325684f) + 0.4000000059604645f)) + _8512);
                                } else {
                                  _8521 = _8512;
                                }
                                if (_7921) {
                                  _8530 = (((_7879 * 0.25f) * ((sqrt(_8521) * 3.0f) + _7879)) / (_8012 + 0.0010000000474974513f)) + _8521;
                                  _8533 = _8530;
                                  _8534 = (_8521 / _8530);
                                } else {
                                  _8533 = _8521;
                                  _8534 = 1.0f;
                                }
                                if (_8042) {
                                  _8540 = sqrt((1.000100016593933f - _7791) / max(9.999999974752427e-07f, (_7791 + 1.0f)));
                                  _8553 = (sqrt(_8533 / ((((_8540 * 0.25f) * ((sqrt(_8533) * 3.0f) + _8540)) / (_8012 + 0.0010000000474974513f)) + _8533)) * _8534);
                                } else {
                                  _8553 = _8534;
                                }
                                _8554 = _8492 * _8492;
                                _8555 = _8554 * _8554;
                                if (_8019) {
                                  _8564 = saturate(((_7881 * _7881) / ((_8012 * 3.5999999046325684f) + 0.4000000059604645f)) + _8555);
                                } else {
                                  _8564 = _8555;
                                }
                                if (_7921) {
                                  _8573 = (((_7879 * 0.25f) * ((sqrt(_8564) * 3.0f) + _7879)) / (_8012 + 0.0010000000474974513f)) + _8564;
                                  _8576 = _8573;
                                  _8577 = (_8564 / _8573);
                                } else {
                                  _8576 = _8564;
                                  _8577 = 1.0f;
                                }
                                if (_8042) {
                                  _8583 = sqrt((1.000100016593933f - _7791) / max(9.999999974752427e-07f, (_7791 + 1.0f)));
                                  _8596 = (sqrt(_8576 / ((((_8583 * 0.25f) * ((sqrt(_8576) * 3.0f) + _8583)) / (_8012 + 0.0010000000474974513f)) + _8576)) * _8577);
                                } else {
                                  _8596 = _8577;
                                }
                                _8600 = (((_8521 * _8013) - _8013) * _8013) + 1.0f;
                                _8603 = (_8521 / (_8600 * _8600)) * _8553;
                                _8607 = (((_8564 * _8013) - _8013) * _8013) + 1.0f;
                                _8614 = saturate(_8013);
                                _8618 = saturate((_8016 + _5590) / (_5590 + 1.0f));
                                _8623 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_262)))) + 1u))]);
                                _8630 = ((float)((uint)((uint)((uint)((uint)(_8623.x)) >> 24)))) * 0.25f;
                                _8633 = ((float)((uint)((uint)(_8623.x & 255)))) * 0.003921568859368563f;
                                _8637 = ((float)((uint)((uint)(((uint)((uint)(_8623.x)) >> 8) & 255)))) * 0.003921568859368563f;
                                _8641 = ((float)((uint)((uint)(((uint)((uint)(_8623.x)) >> 16) & 255)))) * 0.003921568859368563f;
                                _8650 = ((float)((uint)((uint)((uint)((uint)(_8623.y)) >> 24)))) * 0.25f;
                                _8653 = ((float)((uint)((uint)(_8623.y & 255)))) * 0.003921568859368563f;
                                _8657 = ((float)((uint)((uint)(((uint)((uint)(_8623.y)) >> 8) & 255)))) * 0.003921568859368563f;
                                _8661 = ((float)((uint)((uint)(((uint)((uint)(_8623.y)) >> 16) & 255)))) * 0.003921568859368563f;
                                _8669 = (float)((uint)((uint)(_8623.w & 31)));
                                _8675 = (float)((uint)((uint)(((uint)((uint)(_8623.w)) >> 10) & 31)));
                                _8685 = (float)((uint)((uint)(((uint)((uint)(_8623.w)) >> 25) & 31)));
                                _8688 = ((float)((uint)((uint)(_8623.z & 255)))) * 0.003921568859368563f;
                                _8692 = ((float)((uint)((uint)(((uint)((uint)(_8623.z)) >> 8) & 255)))) * 0.003921568859368563f;
                                _8696 = ((float)((uint)((uint)(((uint)((uint)(_8623.z)) >> 16) & 255)))) * 0.003921568859368563f;
                                _8703 = (((float)((uint)((uint)((uint)((uint)(_8623.z)) >> 24)))) * 0.003921568859368563f) * select(((_8623.w & 1073741824) != 0), -1.0f, 1.0f);
                                _8717 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_8623.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _8072)));
                                _8718 = ((2.0f - (_8669 * 0.06451612710952759f)) > 0.0f);
                                if (_8718) {
                                  _8729 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _8614))) * (10.0f - (_8669 * 0.32258063554763794f))) * _8717);
                                } else {
                                  _8729 = _8717;
                                }
                                _8740 = exp2(log2(max(9.999999747378752e-06f, _8614)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_8623.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                                _8741 = ((2.0f - (_8675 * 0.06451612710952759f)) > 0.0f);
                                if (_8741) {
                                  _8751 = (exp2(log2(max(9.999999747378752e-06f, _8073)) * (10.0f - (_8675 * 0.32258063554763794f))) * _8740);
                                } else {
                                  _8751 = _8740;
                                }
                                if (_8718) {
                                  _8765 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _8614))) * (10.0f - (_8669 * 0.32258063554763794f))) * _8717);
                                } else {
                                  _8765 = _8717;
                                }
                                if (_8741) {
                                  _8778 = (exp2(log2(max(9.999999747378752e-06f, _8073)) * (10.0f - (_8675 * 0.32258063554763794f))) * _8740);
                                } else {
                                  _8778 = _8740;
                                }
                                if (_8718) {
                                  _8792 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _8614))) * (10.0f - (_8669 * 0.32258063554763794f))) * _8717);
                                } else {
                                  _8792 = _8717;
                                }
                                if (_8741) {
                                  _8805 = (exp2(log2(max(9.999999747378752e-06f, _8073)) * (10.0f - (_8675 * 0.32258063554763794f))) * _8740);
                                } else {
                                  _8805 = _8740;
                                }
                                _8817 = (1.0f - exp2(log2(1.0f - _8614) * 3.0f)) * (1.0f - exp2(_8074 * 3.0f));
                                _8821 = saturate(_8618 / (_8817 * (((float)((uint)((uint)(((uint)((uint)(_8623.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                                _8826 = ((_8821 * _8821) * (3.0f - (_8821 * 2.0f))) + -1.0f;
                                _8828 = ((((_8688 * _8688) * _8703) * _8817) * _8826) + 1.0f;
                                _8831 = ((((_8692 * _8692) * _8703) * _8817) * _8826) + 1.0f;
                                _8834 = ((((_8696 * _8696) * _8703) * _8817) * _8826) + 1.0f;
                                _8836 = saturate(_8685 * 0.06451612710952759f);
                                _8843 = exp2(log2(1.0f - _8012) * (10.0f - (_8685 * 0.32258063554763794f)));
                                _8862 = ((((((_8564 / (_8607 * _8607)) * _8596) - _8603) * _8485) + _8603) * (0.5f / ((((_8502 * _8500) + _8501) * _8015) + (((_8502 * _8015) + _8501) * _8500)))) * _8015;
                                _9247 = ((_8862 * _8828) * (((_8836 * _8069) * _8843) + _201));
                                _9248 = ((_8862 * _8831) * (((_8836 * _8070) * _8843) + _202));
                                _9249 = ((_8862 * _8834) * (((_8836 * _8071) * _8843) + _203));
                                _9250 = (((((_8729 * (((_8633 * _8633) * _8630) + -1.0f)) + 1.0f) * _8618) * ((_8751 * (((_8653 * _8653) * _8650) + -1.0f)) + 1.0f)) * _8828);
                                _9251 = (((((_8765 * (((_8637 * _8637) * _8630) + -1.0f)) + 1.0f) * _8618) * ((_8778 * (((_8657 * _8657) * _8650) + -1.0f)) + 1.0f)) * _8831);
                                _9252 = (((((_8792 * (((_8641 * _8641) * _8630) + -1.0f)) + 1.0f) * _8618) * ((_8805 * (((_8661 * _8661) * _8650) + -1.0f)) + 1.0f)) * _8834);
                              } else {
                                if (_191) {
                                  if (_206 < 0.007874015718698502f) {
                                    _8876 = _8013 * _8013;
                                    _8878 = max((1.0f - _8876), 9.999999747378752e-05f);
                                    _9023 = (((((((exp2(((-0.0f - (_8876 / _8878)) / _8028) * 1.4426950216293335f) * 4.0f) / (_8878 * _8878)) + 1.0f) * (1.0f / ((_8028 * 4.0f) + 1.0f))) - _8068) * _207) + _8068);
                                    _9024 = (((saturate(0.25f / ((_8017 + _8014) - (_8017 * _8014))) - _8095) * _207) + _8095);
                                  } else {
                                    _8902 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                                    _8903 = _8902 * _147;
                                    _8904 = _8902 * _148;
                                    _8905 = _8902 * _149;
                                    _8908 = (abs(_8903) < abs(_8904));
                                    _8909 = select(_8908, 1.0f, 0.0f);
                                    _8910 = select(_8908, 0.0f, 1.0f);
                                    _8911 = _8910 * _8905;
                                    _8913 = -0.0f - (_8905 * _8909);
                                    _8916 = (_8909 * _8904) - (_8910 * _8903);
                                    _8918 = rsqrt(dot(float3(_8911, _8913, _8916), float3(_8911, _8913, _8916)));
                                    _8919 = _8911 * _8918;
                                    _8920 = _8918 * _8913;
                                    _8921 = _8916 * _8918;
                                    _8924 = (_8920 * _8905) - (_8921 * _8904);
                                    _8927 = (_8921 * _8903) - (_8919 * _8905);
                                    _8930 = (_8919 * _8904) - (_8920 * _8903);
                                    _8932 = rsqrt(dot(float3(_8924, _8927, _8930), float3(_8924, _8927, _8930)));
                                    _8936 = _207 * 4.0f;
                                    _8945 = saturate(abs(_8936 + -2.5f) + -0.5f) + -0.5f;
                                    _8946 = saturate(1.5f - abs(_8936 + -1.5f)) + -0.5f;
                                    _8948 = rsqrt(dot(float2(_8945, _8946), float2(_8945, _8946)));
                                    _8949 = _8948 * _8945;
                                    _8950 = _8948 * _8946;
                                    _8957 = ((_8924 * _8932) * _8949) + (_8950 * _8919);
                                    _8958 = ((_8927 * _8932) * _8949) + (_8950 * _8920);
                                    _8959 = ((_8930 * _8932) * _8949) + (_8950 * _8921);
                                    _8962 = (_8958 * _149) - (_8959 * _148);
                                    _8965 = (_8959 * _147) - (_8957 * _149);
                                    _8968 = (_8957 * _148) - (_8958 * _147);
                                    _8972 = rsqrt((dot(float3(_322, _323, _321), float3(_7884, _7885, _7886)) * 2.0f) + 2.0f);
                                    _8976 = dot(float3(_8957, _8958, _8959), float3(_7884, _7885, _7886));
                                    _8977 = dot(float3(_8957, _8958, _8959), float3(_322, _323, _321));
                                    _8980 = dot(float3(_8962, _8965, _8968), float3(_7884, _7885, _7886));
                                    _8981 = dot(float3(_8962, _8965, _8968), float3(_322, _323, _321));
                                    _8987 = min(max((_7875 * (_206 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                    _8991 = min(max((_7875 * (1.0f - _206)), 0.0010000000474974513f), 1.0f);
                                    _8992 = _8991 * _8987;
                                    _8993 = ((_8977 + _8976) * _8972) * _8991;
                                    _8994 = ((_8981 + _8980) * _8972) * _8987;
                                    _8995 = _8992 * saturate(_8972 * (_7910 + _8016));
                                    _8996 = dot(float3(_8993, _8994, _8995), float3(_8993, _8994, _8995));
                                    _9001 = _8987 * _8977;
                                    _9002 = _8991 * _8981;
                                    _9010 = _8987 * _8976;
                                    _9011 = _8991 * _8980;
                                    _9023 = (((_8992 * _8992) * _8992) / (_8996 * _8996));
                                    _9024 = saturate(0.5f / ((sqrt(((_9010 * _9010) + (_8017 * _8017)) + (_9011 * _9011)) * _8085) + (sqrt(((_9002 * _9002) + (_9001 * _9001)) + (_8085 * _8085)) * _8017)));
                                  }
                                  _9026 = (_9023 * _8017) * _9024;
                                  _9044 = saturate((_8016 + 0.5f) * 0.6666666865348816f);
                                  _9247 = (_9026 * _8080);
                                  _9248 = (_9026 * _8081);
                                  _9249 = (_9026 * _8082);
                                  _9250 = ((_9044 * (1.0f - _8080)) * saturate((((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _8017));
                                  _9251 = ((_9044 * (1.0f - _8081)) * saturate((((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _8017));
                                  _9252 = ((_9044 * (1.0f - _8082)) * saturate((((_115 + -0.5f) * 0.5f) + 0.5f) + _8017));
                                } else {
                                  if (_212) {
                                    _9059 = _264 * _264;
                                    _9060 = _9059 * _9059;
                                    _9066 = saturate(select((_7876 > 0.0f), ((1.0f - _9059) / _7876), 0.0f) * _7879);
                                    _9067 = (_9066 > 0.0f);
                                    if (_9067) {
                                      _9071 = sqrt(1.0f - (_9066 * _9066));
                                      _9073 = (_7909 * 2.0f) * _7910;
                                      _9074 = _9073 - _7911;
                                      if (!(_9074 >= _9071)) {
                                        _9080 = rsqrt(1.0f - (_9074 * _9074)) * _9066;
                                        _9083 = _9080 * (_7910 - (_9074 * _7909));
                                        _9084 = _7910 * _7910;
                                        _9089 = _9080 * (((_9084 * 2.0f) + -1.0f) - (_9074 * _7911));
                                        _9098 = sqrt(saturate((((1.0f - (_7909 * _7909)) - _9084) - (_7911 * _7911)) + (_9073 * _7911)));
                                        _9099 = _9098 * _9080;
                                        _9102 = ((_7910 * 2.0f) * _9080) * _9098;
                                        _9104 = (_9071 * _7909) + _7910;
                                        _9105 = _9104 + _9083;
                                        _9106 = _9071 * _7911;
                                        _9108 = (_9106 + 1.0f) + _9089;
                                        _9109 = _9099 * _9108;
                                        _9110 = _9105 * _9108;
                                        _9111 = _9102 * _9105;
                                        _9116 = (((_9105 * 0.25f) * _9102) - (_9109 * 0.5f)) * _9110;
                                        _9130 = (((_9111 - (_9109 * 2.0f)) * _9111) + (_9109 * _9109)) + ((((-0.5f - ((_9108 + _9106) * 0.5f)) * _9110) + ((_9108 * _9108) * _9104)) * _9105);
                                        _9135 = (_9116 * 2.0f) / ((_9130 * _9130) + (_9116 * _9116));
                                        _9136 = _9130 * _9135;
                                        _9138 = 1.0f - (_9116 * _9135);
                                        _9144 = ((_9136 * _9102) + _9106) + (_9138 * _9089);
                                        _9147 = rsqrt((_9144 * 2.0f) + 2.0f);
                                        _9156 = saturate((_9144 * _9147) + _9147);
                                        _9157 = saturate(((_9104 + (_9136 * _9099)) + (_9138 * _9083)) * _9147);
                                      } else {
                                        _9156 = _8083;
                                        _9157 = 1.0f;
                                      }
                                    } else {
                                      _9156 = _7920;
                                      _9157 = _7917;
                                    }
                                    if (_8019) {
                                      _9166 = saturate(((_7881 * _7881) / ((_9156 * 3.5999999046325684f) + 0.4000000059604645f)) + _9060);
                                    } else {
                                      _9166 = _9060;
                                    }
                                    if (_9067) {
                                      _9175 = (((_9066 * 0.25f) * ((sqrt(_9166) * 3.0f) + _9066)) / (_9156 + 0.0010000000474974513f)) + _9166;
                                      _9178 = _9175;
                                      _9179 = (_9166 / _9175);
                                    } else {
                                      _9178 = _9166;
                                      _9179 = 1.0f;
                                    }
                                    if (_8042) {
                                      _9185 = sqrt((1.000100016593933f - _7791) / max(9.999999974752427e-07f, (_7791 + 1.0f)));
                                      _9198 = (sqrt(_9178 / ((((_9185 * 0.25f) * ((sqrt(_9178) * 3.0f) + _9185)) / (_9156 + 0.0010000000474974513f)) + _9178)) * _9179);
                                    } else {
                                      _9198 = _9179;
                                    }
                                    _9202 = (((_9166 * _9157) - _9157) * _9157) + 1.0f;
                                    _9212 = sqrt(_9166);
                                    _9213 = 1.0f - _9212;
                                    _9228 = ((((exp2(log2(1.0f - saturate(_9156)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _263) * (((_9198 * _8015) * (_9166 / (_9202 * _9202))) * (0.5f / ((((_9213 * _8085) + _9212) * _8015) + (((_9213 * _8015) + _9212) * _8085)))));
                                    _9229 = false;
                                  } else {
                                    _9228 = 0.0f;
                                    _9229 = true;
                                  }
                                  _9233 = saturate((_8016 + _5590) / (_5590 + 1.0f));
                                  _9235 = (_8068 * _8015) * _8095;
                                  _9239 = _9228 + (_9235 * _8080);
                                  _9240 = _9228 + (_9235 * _8081);
                                  _9241 = _9228 + (_9235 * _8082);
                                  [branch]
                                  if (_9229) {
                                    _9247 = (_9239 * _874);
                                    _9248 = (_9240 * _875);
                                    _9249 = (_9241 * _876);
                                    _9250 = _9233;
                                    _9251 = _9233;
                                    _9252 = _9233;
                                  } else {
                                    _9247 = _9239;
                                    _9248 = _9240;
                                    _9249 = _9241;
                                    _9250 = _9233;
                                    _9251 = _9233;
                                    _9252 = _9233;
                                  }
                                }
                              }
                            }
                            _9253 = _7694 * _1341;
                            _9254 = _7695 * _1341;
                            _9255 = _7696 * _1341;
                            _9262 = ((_7747 * _9253) * _9250) + _1274;
                            _9263 = ((_7747 * _9254) * _9251) + _1275;
                            _9264 = ((_7747 * _9255) * _9252) + _1276;
                            if (_5587 > 0.0f) {
                              _9268 = (_5587 * _1034) * select(_7744, (_7740 * _1019), _7740);
                              _13729 = _9262;
                              _13730 = _9263;
                              _13731 = _9264;
                              _13732 = (((_9268 * _9253) * _9247) + _1277);
                              _13733 = (((_9268 * _9254) * _9248) + _1278);
                              _13734 = (((_9268 * _9255) * _9249) + _1279);
                            } else {
                              _13729 = _9262;
                              _13730 = _9263;
                              _13731 = _9264;
                              _13732 = _1277;
                              _13733 = _1278;
                              _13734 = _1279;
                            }
                          } else {
                            _13729 = _1274;
                            _13730 = _1275;
                            _13731 = _1276;
                            _13732 = _1277;
                            _13733 = _1278;
                            _13734 = _1279;
                          }
                          break;
                        }
                      } else {
                        _13729 = _1274;
                        _13730 = _1275;
                        _13731 = _1276;
                        _13732 = _1277;
                        _13733 = _1278;
                        _13734 = _1279;
                      }
                    } else {
                      if (_1324 == 8) {
                        _9283 = asfloat(srvLightInfoProperties.Load3(_1293)).x;
                        _9284 = asfloat(srvLightInfoProperties.Load3(_1293)).y;
                        _9285 = asfloat(srvLightInfoProperties.Load3(_1293)).z;
                        _9288 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 12u)))).x;
                        _9289 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 12u)))).y;
                        _9290 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 12u)))).z;
                        _9293 = asfloat(srvLightInfoProperties.Load(((int)(_1293 + 24u))));
                        _9296 = asint(srvLightInfoProperties.Load(((int)(_1293 + 28u))));
                        _9299 = asint(srvLightInfoProperties.Load(((int)(_1293 + 32u))));
                        _9302 = asint(srvLightInfoProperties.Load(((int)(_1293 + 44u))));
                        _9311 = ((float)((uint)((uint)(((uint)(_9299) >> 8) & 255)))) * 0.003921499941498041f;
                        _9314 = ((float)((uint)((uint)(_9299 & 255)))) * 0.003921499941498041f;
                        _9317 = f16tof32(_9302);
                        _9324 = min(max(dot(float3((_313 - _9283), (_314 - _9284), (_315 - _9285)), float3(_9288, _9289, _9290)), (-0.0f - _9293)), _9293);
                        _9329 = (_9283 - _313) + (_9324 * _9288);
                        _9331 = (_9284 - _314) + (_9324 * _9289);
                        _9333 = (_9285 + _312) + (_9324 * _9290);
                        _9334 = dot(float3(_9329, _9331, _9333), float3(_9329, _9331, _9333));
                        _9335 = rsqrt(_9334);
                        _9337 = _9329 * _9335;
                        _9338 = _9331 * _9335;
                        _9339 = _9333 * _9335;
                        _9342 = max(0.0f, ((_9335 * _9334) - abs(_9317)));
                        _9343 = _9342 * f16tof32(((uint)((uint)(_9302) >> 16)));
                        _9344 = _9343 * _9343;
                        _9347 = saturate(1.0f - (_9344 * _9344));
                        _9354 = (_9347 * _9347) / (select((_9317 < 0.0f), (_9344 * 16.0f), (_9342 * _9342)) + 1.0f);
                        [branch]
                        if (!(_9354 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _9363 = srvLightMappingData[_1286];
                            if (!(_9363 == -1)) {
                              _9368 = srvLightIndexData[_9363].nLayerIndex;
                              _9370 = srvLightIndexData[_9363].vAtlasOrigin.x;
                              _9371 = srvLightIndexData[_9363].vAtlasOrigin.y;
                              _9373 = srvLightIndexData[_9363].vScreenOrigin.x;
                              _9374 = srvLightIndexData[_9363].vScreenOrigin.y;
                              _9383 = ((int)(_9368 * 5)) & 31;
                              _9386 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_9370 + _65) - _9373)), ((int)((_9371 + _66) - _9374)), 0)))).x) & ((int)(31 << _9383)))) >> _9383;
                              _9391 = ((float)((uint)((uint)((uint)(_9386) >> 1)))) * 0.06666667014360428f;
                              _9397 = (_9391 * _9354);
                              _9398 = (select(_162, ((float)((bool)(uint)((_9386 & 1) != 0))), _9391) * _9354);
                            } else {
                              _9397 = _9354;
                              _9398 = _9354;
                            }
                          } else {
                            _9397 = _9354;
                            _9398 = _9354;
                          }
                          _9402 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _9405 = select(_9402, (_9397 * _1019), _9397);
                          _9407 = dot(float3(_147, _148, _149), float3(_9337, _9338, _9339));
                          _9410 = (_159 >= 0.003921568859368563f) && (_159 < 0.007843137718737125f);
                          _9411 = saturate(_9407);
                          if (_9410) {
                            _9419 = (_9411 * (_147 - _289)) + _289;
                            _9420 = (_9411 * (_148 - _290)) + _290;
                            _9421 = (_9411 * (_149 - _291)) + _291;
                            _9423 = rsqrt(dot(float3(_9419, _9420, _9421), float3(_9419, _9420, _9421)));
                            _9428 = (_9419 * _9423);
                            _9429 = (_9420 * _9423);
                            _9430 = (_9421 * _9423);
                          } else {
                            _9428 = _147;
                            _9429 = _148;
                            _9430 = _149;
                          }
                          _9431 = dot(float3(_9428, _9429, _9430), float3(_9337, _9338, _9339));
                          _9432 = dot(float3(_9428, _9429, _9430), float3(_322, _323, _321));
                          _9433 = dot(float3(_322, _323, _321), float3(_9337, _9338, _9339));
                          _9436 = rsqrt((_9433 * 2.0f) + 2.0f);
                          _9439 = saturate(_9436 * (_9432 + _9431));
                          _9442 = saturate((_9436 * _9433) + _9436);
                          _9443 = saturate(_9432);
                          _9444 = saturate(_9431);
                          _9445 = _217 * _217;
                          _9446 = _9445 * _9445;
                          _9450 = (((_9439 * _9446) - _9439) * _9439) + 1.0f;
                          _9452 = _9446 / (_9450 * _9450);
                          _9453 = 1.0f - _201;
                          _9454 = 1.0f - _202;
                          _9455 = 1.0f - _203;
                          _9456 = saturate(_9442);
                          _9457 = 1.0f - _9456;
                          _9458 = log2(_9457);
                          _9460 = exp2(_9458 * 5.0f);
                          _9464 = (_9460 * _9453) + _201;
                          _9465 = (_9460 * _9454) + _202;
                          _9466 = (_9460 * _9455) + _203;
                          _9469 = saturate(abs(_9432) + 9.999999747378752e-06f);
                          _9470 = sqrt(_9446);
                          _9471 = 1.0f - _9470;
                          _9479 = 0.5f / ((((_9471 * _9469) + _9470) * _9411) + (((_9471 * _9411) + _9470) * _9469));
                          if (_162) {
                            _9489 = ((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                            _9490 = ((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                            _9491 = ((_115 + -0.5f) * 0.5f) + 0.5f;
                            _9508 = ((dot(float3((-0.0f - _9428), (-0.0f - _9429), (-0.0f - _9430)), float3(_9337, _9338, _9339)) + dot(float3((-0.0f - _322), (-0.0f - _323), (-0.0f - _321)), float3(_9337, _9338, _9339))) * 0.5f) * exp2(log2(1.0f - _9443) * (11.0f - (((float)((uint)((uint)((uint)(_259) >> 2)))) * 0.1666666716337204f)));
                            _9515 = dot(float3(_113, _114, _115), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                            _9518 = saturate((_9515 + -0.009999999776482582f) * -100.0f);
                            _9523 = ((_9518 * _9518) * 3.0f) * (3.0f - (_9518 * 2.0f));
                            _9530 = 10.0f - (exp2(log2(saturate(_9515 * 5.0f)) * 3.0f) * 9.0f);
                            _9531 = saturate(_9444 + _9489) * _9444;
                            _9532 = saturate(_9444 + _9490) * _9444;
                            _9533 = saturate(_9444 + _9491) * _9444;
                            _9552 = (max(((_9523 + _9489) * _9508), 0.0f) * _9530) + sqrt(_9531 * _9531);
                            _9553 = (max(((_9523 + _9490) * _9508), 0.0f) * _9530) + sqrt(_9532 * _9532);
                            _9554 = (max(((_9523 + _9491) * _9508), 0.0f) * _9530) + sqrt(_9533 * _9533);
                            _9555 = _9337 + _322;
                            _9556 = _9338 + _323;
                            _9557 = _9339 + _321;
                            _9559 = rsqrt(dot(float3(_9555, _9556, _9557), float3(_9555, _9556, _9557)));
                            if (!(select((_258 != 0), 1.0f, 0.0f) < 1.0f)) {
                              _9570 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                              _9571 = _9570 * _147;
                              _9572 = _9570 * _148;
                              _9573 = _9570 * _149;
                              _9576 = (abs(_9571) < abs(_9572));
                              _9577 = select(_9576, 1.0f, 0.0f);
                              _9578 = select(_9576, 0.0f, 1.0f);
                              _9579 = _9578 * _9573;
                              _9581 = -0.0f - (_9573 * _9577);
                              _9584 = (_9577 * _9572) - (_9578 * _9571);
                              _9586 = rsqrt(dot(float3(_9579, _9581, _9584), float3(_9579, _9581, _9584)));
                              _9587 = _9579 * _9586;
                              _9588 = _9586 * _9581;
                              _9589 = _9584 * _9586;
                              _9592 = (_9588 * _9573) - (_9589 * _9572);
                              _9595 = (_9589 * _9571) - (_9587 * _9573);
                              _9598 = (_9587 * _9572) - (_9588 * _9571);
                              _9600 = rsqrt(dot(float3(_9592, _9595, _9598), float3(_9592, _9595, _9598)));
                              _9612 = saturate(abs(_257 + -2.5f) + -0.5f) + -0.5f;
                              _9613 = saturate(1.5f - abs(_257 + -1.5f)) + -0.5f;
                              _9615 = rsqrt(dot(float2(_9612, _9613), float2(_9612, _9613)));
                              _9616 = _9615 * _9612;
                              _9617 = _9615 * _9613;
                              _9624 = ((_9592 * _9600) * _9616) + (_9617 * _9587);
                              _9625 = ((_9595 * _9600) * _9616) + (_9617 * _9588);
                              _9626 = ((_9598 * _9600) * _9616) + (_9617 * _9589);
                              _9629 = min(max(dot(float3(_9624, _9625, _9626), float3(_9337, _9338, _9339)), -1.0f), 1.0f);
                              _9632 = min(max(dot(float3(_9624, _9625, _9626), float3(_322, _323, _321)), -1.0f), 1.0f);
                              _9633 = abs(_9632);
                              _9638 = (1.5707963705062866f - (_9633 * 0.1565829962491989f)) * sqrt(1.0f - _9633);
                              _9642 = abs(_9629);
                              _9647 = (1.5707963705062866f - (_9642 * 0.1565829962491989f)) * sqrt(1.0f - _9642);
                              _9654 = cos(abs(select((_9629 >= 0.0f), _9647, (3.1415927410125732f - _9647)) - select((_9632 >= 0.0f), _9638, (3.1415927410125732f - _9638))) * 0.5f);
                              _9658 = _9337 - (_9629 * _9624);
                              _9659 = _9338 - (_9629 * _9625);
                              _9660 = _9339 - (_9629 * _9626);
                              _9664 = _322 - (_9632 * _9624);
                              _9665 = _323 - (_9632 * _9625);
                              _9666 = _321 - (_9632 * _9626);
                              _9673 = rsqrt((dot(float3(_9664, _9665, _9666), float3(_9664, _9665, _9666)) * dot(float3(_9658, _9659, _9660), float3(_9658, _9659, _9660))) + 9.999999747378752e-05f) * dot(float3(_9658, _9659, _9660), float3(_9664, _9665, _9666));
                              _9677 = sqrt(saturate((_9673 * 0.5f) + 0.5f));
                              _9681 = _9445 * 0.5f;
                              _9682 = _9445 * 2.0f;
                              _9683 = select(((_259 & 1) != 0), 0.0f, 1.9287520390554007e-22f);
                              _9686 = saturate((_9407 + 0.5f) * 0.6666666865348816f);
                              _9696 = (_9632 + _9629) + ((((_9677 * 0.9975510239601135f) * sqrt(1.0f - (_9632 * _9632))) - (_9632 * 0.06994284689426422f)) * 0.13988569378852844f);
                              _9698 = (_9445 * 1.4142135381698608f) * _9677;
                              _9711 = 1.0f - sqrt(saturate((_9433 * 0.5f) + 0.5f));
                              _9712 = _9711 * _9711;
                              _9718 = saturate(-0.0f - _9433);
                              _9721 = (1.0f - saturate(_9718)) * _9686;
                              _9730 = ((((_9677 * 0.5f) * (exp2((((_9696 * _9696) * -0.5f) / (_9698 * _9698)) * 1.4426950216293335f) / (_9698 * 2.5066282749176025f))) * min(_205, 0.5f)) * (((_9712 * _9712) * (_9711 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_9721, 1.0f, _9683));
                              _9732 = (_9629 + -0.03500000014901161f) + _9632;
                              _9741 = 1.0f / ((1.190000057220459f / _9654) + (_9654 * 0.36000001430511475f));
                              _9746 = ((_9741 * (0.6000000238418579f - (_9673 * 0.800000011920929f))) + 1.0f) * _9677;
                              _9752 = 1.0f - (sqrt(saturate(1.0f - (_9746 * _9746))) * _9654);
                              _9753 = _9752 * _9752;
                              _9757 = 0.9534794092178345f - ((_9753 * _9753) * (_9752 * 0.9534794092178345f));
                              _9758 = _9746 * _9741;
                              _9763 = (sqrt(1.0f - (_9758 * _9758)) * 0.5f) / _9654;
                              _9782 = 1.0f - saturate((_9718 + -0.44999998807907104f) * 2.222222328186035f);
                              _9785 = ((1.0f - _9686) * _9683) + _9686;
                              _9788 = ((_9757 * _9757) * (exp2((((_9732 * _9732) * -0.5f) / (_9681 * _9681)) * 1.4426950216293335f) / (_9445 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_9673 * 5.2658371925354f));
                              _9802 = (_9629 + -0.14000000059604645f) + _9632;
                              _9812 = 1.0f - (_9654 * 0.5f);
                              _9813 = _9812 * _9812;
                              _9817 = (_9813 * _9813) * (0.9534794092178345f - (_9654 * 0.47673970460891724f));
                              _9819 = 0.9534794092178345f - _9817;
                              _9821 = (_9819 * _9819) * (_9817 + 0.04652056470513344f);
                              _9824 = exp2((_9673 * 24.525815963745117f) + -24.208423614501953f);
                              _9837 = ((exp2((((_9802 * _9802) * -0.5f) / (_9682 * _9682)) * 1.4426950216293335f) / (_9445 * 5.013256549835205f)) * (lerp(_9821, 1.0f, _170))) * (((exp2((saturate(dot(float3((_9559 * _9555), (_9559 * _9556), (_9559 * _9557)), float3(_147, _148, _149))) * 17.312339782714844f) + -14.109557151794434f) - _9824) * _170) + _9824);
                              _10382 = (((((exp2(log2(max(_113, 0.0f)) * _9763) * _9785) * _9788) * _9782) + _9730) + (_9837 * _113));
                              _10383 = (((((exp2(log2(max(_114, 0.0f)) * _9763) * _9785) * _9788) * _9782) + _9730) + (_9837 * _114));
                              _10384 = (((((exp2(log2(max(_115, 0.0f)) * _9763) * _9785) * _9788) * _9782) + _9730) + (_9837 * _115));
                              _10385 = _9552;
                              _10386 = _9553;
                              _10387 = _9554;
                            } else {
                              _10382 = 0.0f;
                              _10383 = 0.0f;
                              _10384 = 0.0f;
                              _10385 = _9552;
                              _10386 = _9553;
                              _10387 = _9554;
                            }
                          } else {
                            if (_9410) {
                              _9855 = ((float)((uint)((uint)(_261 & 15)))) * 0.06666667014360428f;
                              _9856 = _217 * 0.0317460335791111f;
                              _9859 = min(1.0f, max((_9856 * ((float)((uint)((uint)((uint)(_260) >> 2))))), 0.019999999552965164f));
                              _9862 = min(1.0f, max((_9856 * ((float)((uint)((uint)((((int)(_260 << 4)) & 48) | ((uint)(_261) >> 4)))))), 0.019999999552965164f));
                              _9865 = ((_9862 - _9859) * _9855) + _9859;
                              _9866 = _9865 * _9865;
                              _9870 = saturate(abs(_9443) + 9.999999747378752e-06f);
                              _9871 = sqrt(_9866 * _9866);
                              _9872 = 1.0f - _9871;
                              _9881 = _9859 * _9859;
                              _9882 = _9881 * _9881;
                              _9883 = _9862 * _9862;
                              _9884 = _9883 * _9883;
                              _9888 = (((_9882 * _9439) - _9439) * _9439) + 1.0f;
                              _9890 = _9882 / (_9888 * _9888);
                              _9894 = (((_9884 * _9439) - _9439) * _9439) + 1.0f;
                              _9900 = saturate(_9439);
                              _9904 = saturate((_9431 + _9314) / (_9314 + 1.0f));
                              _9909 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_262)))) + 1u))]);
                              _9916 = ((float)((uint)((uint)((uint)((uint)(_9909.x)) >> 24)))) * 0.25f;
                              _9919 = ((float)((uint)((uint)(_9909.x & 255)))) * 0.003921568859368563f;
                              _9923 = ((float)((uint)((uint)(((uint)((uint)(_9909.x)) >> 8) & 255)))) * 0.003921568859368563f;
                              _9927 = ((float)((uint)((uint)(((uint)((uint)(_9909.x)) >> 16) & 255)))) * 0.003921568859368563f;
                              _9936 = ((float)((uint)((uint)((uint)((uint)(_9909.y)) >> 24)))) * 0.25f;
                              _9939 = ((float)((uint)((uint)(_9909.y & 255)))) * 0.003921568859368563f;
                              _9943 = ((float)((uint)((uint)(((uint)((uint)(_9909.y)) >> 8) & 255)))) * 0.003921568859368563f;
                              _9947 = ((float)((uint)((uint)(((uint)((uint)(_9909.y)) >> 16) & 255)))) * 0.003921568859368563f;
                              _9955 = (float)((uint)((uint)(_9909.w & 31)));
                              _9961 = (float)((uint)((uint)(((uint)((uint)(_9909.w)) >> 10) & 31)));
                              _9971 = (float)((uint)((uint)(((uint)((uint)(_9909.w)) >> 25) & 31)));
                              _9974 = ((float)((uint)((uint)(_9909.z & 255)))) * 0.003921568859368563f;
                              _9978 = ((float)((uint)((uint)(((uint)((uint)(_9909.z)) >> 8) & 255)))) * 0.003921568859368563f;
                              _9982 = ((float)((uint)((uint)(((uint)((uint)(_9909.z)) >> 16) & 255)))) * 0.003921568859368563f;
                              _9989 = (((float)((uint)((uint)((uint)((uint)(_9909.z)) >> 24)))) * 0.003921568859368563f) * select(((_9909.w & 1073741824) != 0), -1.0f, 1.0f);
                              _10003 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_9909.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _9456)));
                              _10004 = ((2.0f - (_9955 * 0.06451612710952759f)) > 0.0f);
                              if (_10004) {
                                _10015 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _9900))) * (10.0f - (_9955 * 0.32258063554763794f))) * _10003);
                              } else {
                                _10015 = _10003;
                              }
                              _10026 = exp2(log2(max(9.999999747378752e-06f, _9900)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_9909.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                              _10027 = ((2.0f - (_9961 * 0.06451612710952759f)) > 0.0f);
                              if (_10027) {
                                _10037 = (exp2(log2(max(9.999999747378752e-06f, _9457)) * (10.0f - (_9961 * 0.32258063554763794f))) * _10026);
                              } else {
                                _10037 = _10026;
                              }
                              if (_10004) {
                                _10051 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _9900))) * (10.0f - (_9955 * 0.32258063554763794f))) * _10003);
                              } else {
                                _10051 = _10003;
                              }
                              if (_10027) {
                                _10064 = (exp2(log2(max(9.999999747378752e-06f, _9457)) * (10.0f - (_9961 * 0.32258063554763794f))) * _10026);
                              } else {
                                _10064 = _10026;
                              }
                              if (_10004) {
                                _10078 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _9900))) * (10.0f - (_9955 * 0.32258063554763794f))) * _10003);
                              } else {
                                _10078 = _10003;
                              }
                              if (_10027) {
                                _10091 = (exp2(log2(max(9.999999747378752e-06f, _9457)) * (10.0f - (_9961 * 0.32258063554763794f))) * _10026);
                              } else {
                                _10091 = _10026;
                              }
                              _10103 = (1.0f - exp2(log2(1.0f - _9900) * 3.0f)) * (1.0f - exp2(_9458 * 3.0f));
                              _10107 = saturate(_9904 / (_10103 * (((float)((uint)((uint)(((uint)((uint)(_9909.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                              _10112 = ((_10107 * _10107) * (3.0f - (_10107 * 2.0f))) + -1.0f;
                              _10114 = ((((_9974 * _9974) * _9989) * _10103) * _10112) + 1.0f;
                              _10117 = ((((_9978 * _9978) * _9989) * _10103) * _10112) + 1.0f;
                              _10120 = ((((_9982 * _9982) * _9989) * _10103) * _10112) + 1.0f;
                              _10122 = saturate(_9971 * 0.06451612710952759f);
                              _10129 = exp2(log2(1.0f - _9442) * (10.0f - (_9971 * 0.32258063554763794f)));
                              _10148 = (((((_9884 / (_9894 * _9894)) - _9890) * _9855) + _9890) * (0.5f / ((((_9872 * _9870) + _9871) * _9411) + (((_9872 * _9411) + _9871) * _9870)))) * _9411;
                              _10382 = ((_10148 * _10114) * (((_10122 * _9453) * _10129) + _201));
                              _10383 = ((_10148 * _10117) * (((_10122 * _9454) * _10129) + _202));
                              _10384 = ((_10148 * _10120) * (((_10122 * _9455) * _10129) + _203));
                              _10385 = (((((_10015 * (((_9919 * _9919) * _9916) + -1.0f)) + 1.0f) * _9904) * ((_10037 * (((_9939 * _9939) * _9936) + -1.0f)) + 1.0f)) * _10114);
                              _10386 = (((((_10051 * (((_9923 * _9923) * _9916) + -1.0f)) + 1.0f) * _9904) * ((_10064 * (((_9943 * _9943) * _9936) + -1.0f)) + 1.0f)) * _10117);
                              _10387 = (((((_10078 * (((_9927 * _9927) * _9916) + -1.0f)) + 1.0f) * _9904) * ((_10091 * (((_9947 * _9947) * _9936) + -1.0f)) + 1.0f)) * _10120);
                            } else {
                              if (_191) {
                                if (_206 < 0.007874015718698502f) {
                                  _10162 = _9439 * _9439;
                                  _10164 = max((1.0f - _10162), 9.999999747378752e-05f);
                                  _10302 = (((((((exp2(((-0.0f - (_10162 / _10164)) / _9446) * 1.4426950216293335f) * 4.0f) / (_10164 * _10164)) + 1.0f) * (1.0f / ((_9446 * 4.0f) + 1.0f))) - _9452) * _207) + _9452);
                                  _10303 = (((saturate(0.25f / ((_9444 + _9443) - (_9444 * _9443))) - _9479) * _207) + _9479);
                                } else {
                                  _10188 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                                  _10189 = _10188 * _147;
                                  _10190 = _10188 * _148;
                                  _10191 = _10188 * _149;
                                  _10194 = (abs(_10189) < abs(_10190));
                                  _10195 = select(_10194, 1.0f, 0.0f);
                                  _10196 = select(_10194, 0.0f, 1.0f);
                                  _10197 = _10196 * _10191;
                                  _10199 = -0.0f - (_10191 * _10195);
                                  _10202 = (_10195 * _10190) - (_10196 * _10189);
                                  _10204 = rsqrt(dot(float3(_10197, _10199, _10202), float3(_10197, _10199, _10202)));
                                  _10205 = _10197 * _10204;
                                  _10206 = _10204 * _10199;
                                  _10207 = _10202 * _10204;
                                  _10210 = (_10206 * _10191) - (_10207 * _10190);
                                  _10213 = (_10207 * _10189) - (_10205 * _10191);
                                  _10216 = (_10205 * _10190) - (_10206 * _10189);
                                  _10218 = rsqrt(dot(float3(_10210, _10213, _10216), float3(_10210, _10213, _10216)));
                                  _10222 = _207 * 4.0f;
                                  _10231 = saturate(abs(_10222 + -2.5f) + -0.5f) + -0.5f;
                                  _10232 = saturate(1.5f - abs(_10222 + -1.5f)) + -0.5f;
                                  _10234 = rsqrt(dot(float2(_10231, _10232), float2(_10231, _10232)));
                                  _10235 = _10234 * _10231;
                                  _10236 = _10234 * _10232;
                                  _10243 = ((_10210 * _10218) * _10235) + (_10236 * _10205);
                                  _10244 = ((_10213 * _10218) * _10235) + (_10236 * _10206);
                                  _10245 = ((_10216 * _10218) * _10235) + (_10236 * _10207);
                                  _10248 = (_10244 * _149) - (_10245 * _148);
                                  _10251 = (_10245 * _147) - (_10243 * _149);
                                  _10254 = (_10243 * _148) - (_10244 * _147);
                                  _10255 = dot(float3(_10243, _10244, _10245), float3(_9337, _9338, _9339));
                                  _10256 = dot(float3(_10243, _10244, _10245), float3(_322, _323, _321));
                                  _10259 = dot(float3(_10248, _10251, _10254), float3(_9337, _9338, _9339));
                                  _10260 = dot(float3(_10248, _10251, _10254), float3(_322, _323, _321));
                                  _10266 = min(max((_9445 * (_206 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                  _10270 = min(max((_9445 * (1.0f - _206)), 0.0010000000474974513f), 1.0f);
                                  _10271 = _10270 * _10266;
                                  _10272 = ((_10256 + _10255) * _9436) * _10270;
                                  _10273 = ((_10260 + _10259) * _9436) * _10266;
                                  _10274 = _10271 * _9439;
                                  _10275 = dot(float3(_10272, _10273, _10274), float3(_10272, _10273, _10274));
                                  _10280 = _10266 * _10256;
                                  _10281 = _10270 * _10260;
                                  _10289 = _10266 * _10255;
                                  _10290 = _10270 * _10259;
                                  _10302 = (((_10271 * _10271) * _10271) / (_10275 * _10275));
                                  _10303 = saturate(0.5f / ((sqrt(((_10289 * _10289) + (_9444 * _9444)) + (_10290 * _10290)) * _9469) + (sqrt(((_10281 * _10281) + (_10280 * _10280)) + (_9469 * _9469)) * _9444)));
                                }
                                _10305 = (_10302 * _9444) * _10303;
                                _10323 = saturate((_9431 + 0.5f) * 0.6666666865348816f);
                                _10382 = (_10305 * _9464);
                                _10383 = (_10305 * _9465);
                                _10384 = (_10305 * _9466);
                                _10385 = ((_10323 * (1.0f - _9464)) * saturate((((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _9444));
                                _10386 = ((_10323 * (1.0f - _9465)) * saturate((((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _9444));
                                _10387 = ((_10323 * (1.0f - _9466)) * saturate((((_115 + -0.5f) * 0.5f) + 0.5f) + _9444));
                              } else {
                                if (_212) {
                                  _10338 = _264 * _264;
                                  _10339 = _10338 * _10338;
                                  _10343 = (((_9439 * _10339) - _9439) * _9439) + 1.0f;
                                  _10348 = sqrt(_10339);
                                  _10349 = 1.0f - _10348;
                                  _10363 = ((((_9460 * 0.9599999785423279f) + 0.03999999910593033f) * _263) * (((_10339 / (_10343 * _10343)) * _9411) * (0.5f / ((((_10349 * _9469) + _10348) * _9411) + (((_10349 * _9411) + _10348) * _9469)))));
                                  _10364 = false;
                                } else {
                                  _10363 = 0.0f;
                                  _10364 = true;
                                }
                                _10368 = saturate((_9431 + _9314) / (_9314 + 1.0f));
                                _10370 = (_9452 * _9411) * _9479;
                                _10374 = _10363 + (_10370 * _9464);
                                _10375 = _10363 + (_10370 * _9465);
                                _10376 = _10363 + (_10370 * _9466);
                                [branch]
                                if (_10364) {
                                  _10382 = (_10374 * _874);
                                  _10383 = (_10375 * _875);
                                  _10384 = (_10376 * _876);
                                  _10385 = _10368;
                                  _10386 = _10368;
                                  _10387 = _10368;
                                } else {
                                  _10382 = _10374;
                                  _10383 = _10375;
                                  _10384 = _10376;
                                  _10385 = _10368;
                                  _10386 = _10368;
                                  _10387 = _10368;
                                }
                              }
                            }
                          }
                          _10388 = f16tof32(((uint)((uint)(_9296) >> 16))) * _1341;
                          _10389 = f16tof32(_9296) * _1341;
                          _10390 = f16tof32(((uint)((uint)(_9299) >> 16))) * _1341;
                          _10397 = ((_9405 * _10388) * _10385) + _1274;
                          _10398 = ((_9405 * _10389) * _10386) + _1275;
                          _10399 = ((_9405 * _10390) * _10387) + _1276;
                          if (_9311 > 0.0f) {
                            _10403 = (_9311 * _1034) * select(_9402, (_9398 * _1019), _9398);
                            _13729 = _10397;
                            _13730 = _10398;
                            _13731 = _10399;
                            _13732 = (((_10403 * _10388) * _10382) + _1277);
                            _13733 = (((_10403 * _10389) * _10383) + _1278);
                            _13734 = (((_10403 * _10390) * _10384) + _1279);
                          } else {
                            _13729 = _10397;
                            _13730 = _10398;
                            _13731 = _10399;
                            _13732 = _1277;
                            _13733 = _1278;
                            _13734 = _1279;
                          }
                        } else {
                          _13729 = _1274;
                          _13730 = _1275;
                          _13731 = _1276;
                          _13732 = _1277;
                          _13733 = _1278;
                          _13734 = _1279;
                        }
                      } else {
                        if (_1324 == 9) {
                          _10418 = asfloat(srvLightInfoProperties.Load4(_1293)).x;
                          _10419 = asfloat(srvLightInfoProperties.Load4(_1293)).y;
                          _10420 = asfloat(srvLightInfoProperties.Load4(_1293)).w;
                          _10423 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).x;
                          _10424 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).y;
                          _10425 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).w;
                          _10428 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).x;
                          _10429 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).y;
                          _10430 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).w;
                          _10433 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 48u)))).x;
                          _10434 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 48u)))).y;
                          _10435 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 48u)))).w;
                          _10438 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 64u)))).x;
                          _10439 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 64u)))).y;
                          _10440 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 64u)))).z;
                          _10443 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 76u)))).x;
                          _10444 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 76u)))).y;
                          _10445 = asfloat(srvLightInfoProperties.Load3(((int)(_1293 + 76u)))).z;
                          _10448 = asint(srvLightInfoProperties.Load(((int)(_1293 + 88u))));
                          _10451 = asint(srvLightInfoProperties.Load(((int)(_1293 + 92u))));
                          _10454 = asint(srvLightInfoProperties.Load(((int)(_1293 + 100u))));
                          _10457 = asint(srvLightInfoProperties.Load(((int)(_1293 + 104u))));
                          _10460 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).x;
                          _10461 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).y;
                          _10462 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).z;
                          _10463 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 108u)))).w;
                          _10466 = asint(srvLightInfoProperties.Load(((int)(_1293 + 124u))));
                          _10469 = asint(srvLightInfoProperties.Load(((int)(_1293 + 128u))));
                          _10472 = asint(srvLightInfoProperties.Load(((int)(_1293 + 132u))));
                          _10475 = asint(srvLightInfoProperties.Load(((int)(_1293 + 136u))));
                          _10478 = asint(srvLightInfoProperties.Load(((int)(_1293 + 140u))));
                          _10481 = asint(srvLightInfoProperties.Load(((int)(_1293 + 144u))));
                          _10484 = asint(srvLightInfoProperties.Load(((int)(_1293 + 148u))));
                          _10487 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 152u)))).x;
                          _10488 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 152u)))).y;
                          _10489 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 152u)))).z;
                          _10490 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 152u)))).w;
                          _10493 = asint(srvLightInfoProperties.Load(((int)(_1293 + 168u))));
                          _10496 = asint(srvLightInfoProperties.Load(((int)(_1293 + 172u))));
                          _10499 = asint(srvLightInfoProperties.Load(((int)(_1293 + 176u))));
                          _10502 = asint(srvLightInfoProperties.Load(((int)(_1293 + 180u))));
                          _10504 = f16tof32(((uint)((uint)(_10448) >> 16)));
                          _10505 = f16tof32(_10448);
                          _10507 = f16tof32(((uint)((uint)(_10451) >> 16)));
                          _10511 = ((float)((uint)((uint)(((uint)(_10451) >> 8) & 255)))) * 0.003921499941498041f;
                          _10514 = ((float)((uint)((uint)(_10451 & 255)))) * 0.003921499941498041f;
                          _10515 = f16tof32(_10454);
                          _10517 = f16tof32(((uint)((uint)(_10457) >> 16)));
                          _10521 = f16tof32(_10466);
                          _10525 = _10472 & 65535;
                          _10531 = ((_1289 & 3584) != 0);
                          _10548 = f16tof32(((uint)((uint)(_10502) >> 16)));
                          _10549 = 1.0f / _10548;
                          _10550 = _10548 + -1.0f;
                          _10551 = f16tof32(_10502);
                          _10556 = (_159 >= 0.003921568859368563f);
                          _10558 = (_159 < 0.007843137718737125f);
                          _10559 = _10558 && (_10556 && ((cbSharedPerViewData.nLightingShadowFeatures & 1) != 0));
                          _10560 = _10438 - _313;
                          _10561 = _10439 - _314;
                          _10562 = _10440 + _312;
                          _10563 = dot(float3(_10560, _10561, _10562), float3(_10560, _10561, _10562));
                          _10564 = rsqrt(_10563);
                          _10565 = _10564 * _10563;
                          _10566 = _10564 * _10560;
                          _10567 = _10564 * _10561;
                          _10568 = _10564 * _10562;
                          _10571 = max(0.0f, (_10565 - abs(_10521)));
                          _10572 = _10571 * f16tof32(((uint)((uint)(_10466) >> 16)));
                          _10573 = _10572 * _10572;
                          _10576 = saturate(1.0f - (_10573 * _10573));
                          _10587 = mad(_315, _10430, mad(_314, _10425, (_10420 * _313))) + _10435;
                          _10591 = saturate(1.0f - dot(float3(_147, _148, _149), float3(_10566, _10567, _10568))) * f16tof32(_10493);
                          _10598 = ((_10587 * _147) * _10591) + _313;
                          _10599 = ((_10587 * _148) * _10591) + _314;
                          _10600 = ((_10587 * _149) * _10591) - _312;
                          _10612 = mad(_10600, _10430, mad(_10599, _10425, (_10598 * _10420))) + _10435;
                          _10613 = 1.0f / _10612;
                          _10614 = _10613 * (mad(_10600, _10428, mad(_10599, _10423, (_10598 * _10418))) + _10433);
                          _10615 = _10613 * (mad(_10600, _10429, mad(_10599, _10424, (_10598 * _10419))) + _10434);
                          _10618 = (_10614 * _10460) + _10461;
                          _10619 = (_10615 * _10460) + _10461;
                          _10622 = _10618 - saturate(_10618);
                          _10623 = _10619 - saturate(_10619);
                          _10630 = saturate((sqrt((_10622 * _10622) + (_10623 * _10623)) * _10462) + _10463);
                          _10632 = 1.0f - (_10630 * _10630);
                          _10638 = (_10632 * _10632) * (((float)((bool)(uint)((_10612 - f16tof32(((uint)((uint)(_10469) >> 16)))) > 0.0f))) * ((_10576 * _10576) / (select((_10521 < 0.0f), (_10573 * 16.0f), (_10571 * _10571)) + 1.0f)));
                          if (!((!(_10638 > 0.0f)) || (!_10531))) {
                            _10648 = 1.0f - saturate(f16tof32(_10469) * _10612);
                            _10649 = saturate(_10614);
                            _10650 = saturate(_10615);
                            bool __branch_chain_10642;
                            [branch]
                            if ((_1289 & 1024) == 0) {
                              _10914 = 1.0f;
                              _10915 = 0.0f;
                              _10916 = _10648;
                              __branch_chain_10642 = true;
                            } else {
                              _10655 = ((_10649 * _10550) + 0.5f) * _10549;
                              _10657 = ((_10650 * _10550) + 0.5f) * _10549;
                              _10658 = _10648 + f16tof32(((uint)((uint)(_10493) >> 16)));
                              Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_10472) >> 16))];
                              _10661 = select(_10559, f16tof32(((uint)((uint)(_10499) >> 16))), f16tof32(((uint)((uint)(_10496) >> 16))));
                              _10662 = saturate(_10658);
                              _10666 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                              _10675 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_10666 * 32.665000915527344f) + _296), ((_10666 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _10676 = sin(_10675);
                              _10677 = cos(_10675);
                              _10678 = cbSharedPerViewData.nFrameCounter & 3;
                              _10683 = sqrt((float((int)(_10678)) * 0.25f) + 0.125f) * _10661;
                              _10692 = (_global_0[min((uint)(((int)(0u + (_10678 * 2)))), 127u)]) * _10683;
                              _10693 = (_global_0[min((uint)(((int)(1u + (_10678 * 2)))), 127u)]) * _10683;
                              _10695 = -0.0f - _10676;
                              _10700 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_10692, _10693), float2(_10677, _10676)) + _10655), (dot(float2(_10692, _10693), float2(_10695, _10677)) + _10657)));
                              _10705 = _10700.x - _10662;
                              _10707 = select((_10705 < 0.0f), 0.0f, 1.0f);
                              _10709 = _10700.y - _10662;
                              _10711 = select((_10709 < 0.0f), 0.0f, 1.0f);
                              _10715 = _10700.z - _10662;
                              _10717 = select((_10715 < 0.0f), 0.0f, 1.0f);
                              _10721 = _10700.w - _10662;
                              _10723 = select((_10721 < 0.0f), 0.0f, 1.0f);
                              _10730 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                              _10735 = sqrt((float((int)(_10730)) * 0.25f) + 0.125f) * _10661;
                              _10744 = (_global_0[min((uint)(((int)(0u + (_10730 * 2)))), 127u)]) * _10735;
                              _10745 = (_global_0[min((uint)(((int)(1u + (_10730 * 2)))), 127u)]) * _10735;
                              _10751 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_10744, _10745), float2(_10677, _10676)) + _10655), (dot(float2(_10744, _10745), float2(_10695, _10677)) + _10657)));
                              _10756 = _10751.x - _10662;
                              _10758 = select((_10756 < 0.0f), 0.0f, 1.0f);
                              _10762 = _10751.y - _10662;
                              _10764 = select((_10762 < 0.0f), 0.0f, 1.0f);
                              _10768 = _10751.z - _10662;
                              _10770 = select((_10768 < 0.0f), 0.0f, 1.0f);
                              _10774 = _10751.w - _10662;
                              _10776 = select((_10774 < 0.0f), 0.0f, 1.0f);
                              _10783 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                              _10788 = sqrt((float((int)(_10783)) * 0.25f) + 0.125f) * _10661;
                              _10797 = (_global_0[min((uint)(((int)(0u + (_10783 * 2)))), 127u)]) * _10788;
                              _10798 = (_global_0[min((uint)(((int)(1u + (_10783 * 2)))), 127u)]) * _10788;
                              _10804 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_10797, _10798), float2(_10677, _10676)) + _10655), (dot(float2(_10797, _10798), float2(_10695, _10677)) + _10657)));
                              _10809 = _10804.x - _10662;
                              _10811 = select((_10809 < 0.0f), 0.0f, 1.0f);
                              _10815 = _10804.y - _10662;
                              _10817 = select((_10815 < 0.0f), 0.0f, 1.0f);
                              _10821 = _10804.z - _10662;
                              _10823 = select((_10821 < 0.0f), 0.0f, 1.0f);
                              _10827 = _10804.w - _10662;
                              _10829 = select((_10827 < 0.0f), 0.0f, 1.0f);
                              _10836 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                              _10841 = sqrt((float((int)(_10836)) * 0.25f) + 0.125f) * _10661;
                              _10850 = (_global_0[min((uint)(((int)(0u + (_10836 * 2)))), 127u)]) * _10841;
                              _10851 = (_global_0[min((uint)(((int)(1u + (_10836 * 2)))), 127u)]) * _10841;
                              _10857 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_10850, _10851), float2(_10677, _10676)) + _10655), (dot(float2(_10850, _10851), float2(_10695, _10677)) + _10657)));
                              _10862 = _10857.x - _10662;
                              _10864 = select((_10862 < 0.0f), 0.0f, 1.0f);
                              _10868 = _10857.y - _10662;
                              _10870 = select((_10868 < 0.0f), 0.0f, 1.0f);
                              _10874 = _10857.z - _10662;
                              _10876 = select((_10874 < 0.0f), 0.0f, 1.0f);
                              _10880 = _10857.w - _10662;
                              _10882 = select((_10880 < 0.0f), 0.0f, 1.0f);
                              _10883 = ((((((((((((((_10707 + _10711) + _10717) + _10723) + _10758) + _10764) + _10770) + _10776) + _10811) + _10817) + _10823) + _10829) + _10864) + _10870) + _10876) + _10882;
                              _10894 = (saturate(_10883 * 0.0625f) * 2.0f) + -1.0f;
                              _10900 = float((int)(((int)(uint)((int)(_10894 > 0.0f))) - ((int)(uint)((int)(_10894 < 0.0f)))));
                              _10902 = 1.0f - (_10900 * _10894);
                              _10904 = (_10902 * _10902) * _10902;
                              _10911 = 0.5f - ((_10900 * 0.5f) * ((1.0f - _10904) - ((_10902 - _10904) * saturate(((1.0f / _10662) * (1.0f / _10883)) * ((((((((((((((((_10707 * _10705) + (_10711 * _10709)) + (_10717 * _10715)) + (_10723 * _10721)) + (_10758 * _10756)) + (_10764 * _10762)) + (_10770 * _10768)) + (_10776 * _10774)) + (_10811 * _10809)) + (_10817 * _10815)) + (_10823 * _10821)) + (_10829 * _10827)) + (_10864 * _10862)) + (_10870 * _10868)) + (_10876 * _10874)) + (_10882 * _10880))))));
                              [branch]
                              if (_10551 < 1.0f) {
                                _10914 = _10911;
                                _10915 = _10551;
                                _10916 = _10658;
                                __branch_chain_10642 = true;
                              } else {
                                _11385 = _10551;
                                _11386 = _10911;
                                __branch_chain_10642 = false;
                              }
                            }
                            if (__branch_chain_10642) {
                              _10919 = (_10649 * _10487) + _10489;
                              _10920 = (_10650 * _10488) + _10490;
                              if (!((_1289 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                _10927 = select(_10559, f16tof32(_10499), f16tof32(_10496));
                                _10930 = saturate(_10916);
                                _10934 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _10943 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_10934 * 32.665000915527344f) + _296), ((_10934 * 11.8149995803833f) + _297)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _10944 = sin(_10943);
                                _10945 = cos(_10943);
                                _10950 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_10919, _10920), 0.0f))).x) > _10930), 1.0f, 0.0f);
                                _10951 = cbSharedPerViewData.nFrameCounter & 3;
                                _10956 = sqrt((float((int)(_10951)) * 0.25f) + 0.125f) * _10927;
                                _10965 = (_global_0[min((uint)(((int)(0u + (_10951 * 2)))), 127u)]) * _10956;
                                _10966 = (_global_0[min((uint)(((int)(1u + (_10951 * 2)))), 127u)]) * _10956;
                                _10968 = -0.0f - _10944;
                                _10970 = dot(float2(_10965, _10966), float2(_10945, _10944)) + _10919;
                                _10971 = dot(float2(_10965, _10966), float2(_10968, _10945)) + _10920;
                                _10973 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_10970, _10971));
                                _10977 = _10970 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _10978 = _10971 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _10981 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _10489);
                                _10982 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _10490);
                                _10987 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_10487 + _10489)) + 0.5f);
                                _10988 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_10488 + _10490)) + 0.5f);
                                _10991 = floor(_10977 + -0.5f);
                                _10992 = floor(_10978 + 0.5f);
                                _10994 = floor(_10977 + 0.5f);
                                _10996 = floor(_10978 + -0.5f);
                                _10997 = (_10991 < _10981);
                                _10998 = (_10992 < _10982);
                                if ((_10997 || _10998) | ((_10991 >= _10987) || (_10992 >= _10988))) {
                                  _11007 = _10950;
                                } else {
                                  _11007 = _10973.x;
                                }
                                _11008 = (_10994 < _10981);
                                if ((_11008 || _10998) | ((_10994 >= _10987) || (_10992 >= _10988))) {
                                  _11016 = _10950;
                                } else {
                                  _11016 = _10973.y;
                                }
                                _11017 = (_10996 < _10982);
                                if ((_11008 || _11017) | ((_10994 >= _10987) || (_10996 >= _10988))) {
                                  _11025 = _10950;
                                } else {
                                  _11025 = _10973.z;
                                }
                                if ((_10997 || _11017) | ((_10991 >= _10987) || (_10996 >= _10988))) {
                                  _11033 = _10950;
                                } else {
                                  _11033 = _10973.w;
                                }
                                _11034 = _11007 - _10930;
                                _11036 = select((_11034 < 0.0f), 0.0f, 1.0f);
                                _11038 = _11016 - _10930;
                                _11040 = select((_11038 < 0.0f), 0.0f, 1.0f);
                                _11044 = _11025 - _10930;
                                _11046 = select((_11044 < 0.0f), 0.0f, 1.0f);
                                _11050 = _11033 - _10930;
                                _11052 = select((_11050 < 0.0f), 0.0f, 1.0f);
                                _11059 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _11064 = sqrt((float((int)(_11059)) * 0.25f) + 0.125f) * _10927;
                                _11073 = (_global_0[min((uint)(((int)(0u + (_11059 * 2)))), 127u)]) * _11064;
                                _11074 = (_global_0[min((uint)(((int)(1u + (_11059 * 2)))), 127u)]) * _11064;
                                _11077 = dot(float2(_11073, _11074), float2(_10945, _10944)) + _10919;
                                _11078 = dot(float2(_11073, _11074), float2(_10968, _10945)) + _10920;
                                _11080 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_11077, _11078));
                                _11084 = _11077 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _11085 = _11078 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _11088 = floor(_11084 + -0.5f);
                                _11089 = floor(_11085 + 0.5f);
                                _11091 = floor(_11084 + 0.5f);
                                _11093 = floor(_11085 + -0.5f);
                                _11094 = (_11088 < _10981);
                                _11095 = (_11089 < _10982);
                                if ((_11094 || _11095) | ((_11088 >= _10987) || (_11089 >= _10988))) {
                                  _11104 = _10950;
                                } else {
                                  _11104 = _11080.x;
                                }
                                _11105 = (_11091 < _10981);
                                if ((_11105 || _11095) | ((_11091 >= _10987) || (_11089 >= _10988))) {
                                  _11113 = _10950;
                                } else {
                                  _11113 = _11080.y;
                                }
                                _11114 = (_11093 < _10982);
                                if ((_11105 || _11114) | ((_11091 >= _10987) || (_11093 >= _10988))) {
                                  _11122 = _10950;
                                } else {
                                  _11122 = _11080.z;
                                }
                                if ((_11094 || _11114) | ((_11088 >= _10987) || (_11093 >= _10988))) {
                                  _11130 = _10950;
                                } else {
                                  _11130 = _11080.w;
                                }
                                _11131 = _11104 - _10930;
                                _11133 = select((_11131 < 0.0f), 0.0f, 1.0f);
                                _11137 = _11113 - _10930;
                                _11139 = select((_11137 < 0.0f), 0.0f, 1.0f);
                                _11143 = _11122 - _10930;
                                _11145 = select((_11143 < 0.0f), 0.0f, 1.0f);
                                _11149 = _11130 - _10930;
                                _11151 = select((_11149 < 0.0f), 0.0f, 1.0f);
                                _11158 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _11163 = sqrt((float((int)(_11158)) * 0.25f) + 0.125f) * _10927;
                                _11172 = (_global_0[min((uint)(((int)(0u + (_11158 * 2)))), 127u)]) * _11163;
                                _11173 = (_global_0[min((uint)(((int)(1u + (_11158 * 2)))), 127u)]) * _11163;
                                _11176 = dot(float2(_11172, _11173), float2(_10945, _10944)) + _10919;
                                _11177 = dot(float2(_11172, _11173), float2(_10968, _10945)) + _10920;
                                _11179 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_11176, _11177));
                                _11183 = _11176 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _11184 = _11177 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _11187 = floor(_11183 + -0.5f);
                                _11188 = floor(_11184 + 0.5f);
                                _11190 = floor(_11183 + 0.5f);
                                _11192 = floor(_11184 + -0.5f);
                                _11193 = (_11187 < _10981);
                                _11194 = (_11188 < _10982);
                                if ((_11193 || _11194) | ((_11187 >= _10987) || (_11188 >= _10988))) {
                                  _11203 = _10950;
                                } else {
                                  _11203 = _11179.x;
                                }
                                _11204 = (_11190 < _10981);
                                if ((_11204 || _11194) | ((_11190 >= _10987) || (_11188 >= _10988))) {
                                  _11212 = _10950;
                                } else {
                                  _11212 = _11179.y;
                                }
                                _11213 = (_11192 < _10982);
                                if ((_11204 || _11213) | ((_11190 >= _10987) || (_11192 >= _10988))) {
                                  _11221 = _10950;
                                } else {
                                  _11221 = _11179.z;
                                }
                                if ((_11193 || _11213) | ((_11187 >= _10987) || (_11192 >= _10988))) {
                                  _11229 = _10950;
                                } else {
                                  _11229 = _11179.w;
                                }
                                _11230 = _11203 - _10930;
                                _11232 = select((_11230 < 0.0f), 0.0f, 1.0f);
                                _11236 = _11212 - _10930;
                                _11238 = select((_11236 < 0.0f), 0.0f, 1.0f);
                                _11242 = _11221 - _10930;
                                _11244 = select((_11242 < 0.0f), 0.0f, 1.0f);
                                _11248 = _11229 - _10930;
                                _11250 = select((_11248 < 0.0f), 0.0f, 1.0f);
                                _11257 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _11262 = sqrt((float((int)(_11257)) * 0.25f) + 0.125f) * _10927;
                                _11271 = (_global_0[min((uint)(((int)(0u + (_11257 * 2)))), 127u)]) * _11262;
                                _11272 = (_global_0[min((uint)(((int)(1u + (_11257 * 2)))), 127u)]) * _11262;
                                _11275 = dot(float2(_11271, _11272), float2(_10945, _10944)) + _10919;
                                _11276 = dot(float2(_11271, _11272), float2(_10968, _10945)) + _10920;
                                _11278 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_11275, _11276));
                                _11282 = _11275 * cbSharedPerViewData.vShadowAtlasSize.x;
                                _11283 = _11276 * cbSharedPerViewData.vShadowAtlasSize.y;
                                _11286 = floor(_11282 + -0.5f);
                                _11287 = floor(_11283 + 0.5f);
                                _11289 = floor(_11282 + 0.5f);
                                _11291 = floor(_11283 + -0.5f);
                                _11292 = (_11286 < _10981);
                                _11293 = (_11287 < _10982);
                                if ((_11292 || _11293) | ((_11286 >= _10987) || (_11287 >= _10988))) {
                                  _11302 = _10950;
                                } else {
                                  _11302 = _11278.x;
                                }
                                _11303 = (_11289 < _10981);
                                if ((_11303 || _11293) | ((_11289 >= _10987) || (_11287 >= _10988))) {
                                  _11311 = _10950;
                                } else {
                                  _11311 = _11278.y;
                                }
                                _11312 = (_11291 < _10982);
                                if ((_11303 || _11312) | ((_11289 >= _10987) || (_11291 >= _10988))) {
                                  _11320 = _10950;
                                } else {
                                  _11320 = _11278.z;
                                }
                                if ((_11292 || _11312) | ((_11286 >= _10987) || (_11291 >= _10988))) {
                                  _11328 = _10950;
                                } else {
                                  _11328 = _11278.w;
                                }
                                _11329 = _11302 - _10930;
                                _11331 = select((_11329 < 0.0f), 0.0f, 1.0f);
                                _11335 = _11311 - _10930;
                                _11337 = select((_11335 < 0.0f), 0.0f, 1.0f);
                                _11341 = _11320 - _10930;
                                _11343 = select((_11341 < 0.0f), 0.0f, 1.0f);
                                _11347 = _11328 - _10930;
                                _11349 = select((_11347 < 0.0f), 0.0f, 1.0f);
                                _11350 = ((((((((((((((_11040 + _11036) + _11046) + _11052) + _11133) + _11139) + _11145) + _11151) + _11232) + _11238) + _11244) + _11250) + _11331) + _11337) + _11343) + _11349;
                                _11361 = (saturate(_11350 * 0.0625f) * 2.0f) + -1.0f;
                                _11367 = float((int)(((int)(uint)((int)(_11361 > 0.0f))) - ((int)(uint)((int)(_11361 < 0.0f)))));
                                _11369 = 1.0f - (_11367 * _11361);
                                _11371 = (_11369 * _11369) * _11369;
                                _11380 = (0.5f - ((_11367 * 0.5f) * ((1.0f - _11371) - ((_11369 - _11371) * saturate(((1.0f / _10930) * (1.0f / _11350)) * ((((((((((((((((_11040 * _11038) + (_11036 * _11034)) + (_11046 * _11044)) + (_11052 * _11050)) + (_11133 * _11131)) + (_11139 * _11137)) + (_11145 * _11143)) + (_11151 * _11149)) + (_11232 * _11230)) + (_11238 * _11236)) + (_11244 * _11242)) + (_11250 * _11248)) + (_11331 * _11329)) + (_11337 * _11335)) + (_11343 * _11341)) + (_11349 * _11347)))))));
                              } else {
                                _11380 = 1.0f;
                              }
                              _11385 = _10915;
                              _11386 = (lerp(_11380, _10914, _10915));
                            }
                            [branch]
                            if (!((_1289 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_10475) >> 16))];
                              _11392 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_10614, _10615), 0.0f);
                              if (_11392.x > 0.0f) {
                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_10475 & 65535))];
                                _11399 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_10614, _10615), 0.0f);
                                _11413 = mad(saturate(((log2(_10565) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                _11414 = max(9.999999747378752e-06f, _11392.x);
                                _11415 = _11399.x / _11414;
                                _11416 = _11399.y / _11414;
                                _11418 = _11399.w / _11414;
                                _11423 = ((0.375f - _11416) * 4.999999873689376e-06f) + _11416;
                                _11426 = -0.0f - _11415;
                                _11427 = mad(_11426, _11423, (_11399.z / _11414));
                                _11429 = 1.0f / mad(_11426, _11415, _11423);
                                _11430 = _11429 * _11427;
                                _11435 = _11413 - _11415;
                                _11440 = (((_11413 * _11413) - _11423) - (_11430 * _11435)) / mad((-0.0f - _11427), _11430, mad((-0.0f - _11423), _11423, (((0.375f - _11418) * 4.999999873689376e-06f) + _11418)));
                                _11442 = (_11429 * _11435) - (_11440 * _11430);
                                _11445 = 1.0f / _11440;
                                _11446 = _11442 * _11445;
                                _11451 = sqrt(((_11446 * _11446) * 0.25f) - ((1.0f - dot(float2(_11442, _11440), float2(_11415, _11423))) * _11445));
                                _11453 = (_11446 * -0.5f) - _11451;
                                _11455 = _11451 - (_11446 * 0.5f);
                                _11457 = select((_11453 < _11413), 1.0f, 0.0f);
                                _11462 = (_11457 + -0.05000000074505806f) / (_11453 - _11413);
                                _11468 = (((select((_11455 < _11413), 1.0f, 0.0f) - _11457) / (_11455 - _11453)) - _11462) / (_11455 - _11413);
                                _11470 = _11462 - (_11468 * _11453);
                                _11483 = (exp2((_11392.x * -1.4426950216293335f) * saturate((dot(float2(_11415, _11423), float2((_11470 - (_11468 * _11413)), _11468)) + 0.05000000074505806f) - (_11470 * _11413))) * _11386);
                              } else {
                                _11483 = _11386;
                              }
                            } else {
                              _11483 = _11386;
                            }
                            _11488 = _11385;
                            _11489 = _11483;
                            _11490 = (lerp(_11483, 1.0f, _11385));
                          } else {
                            _11488 = 0.0f;
                            _11489 = 1.0f;
                            _11490 = 1.0f;
                          }
                          [branch]
                          if (!(_10525 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _10525)))];
                            _11503 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_10614 * f16tof32(((uint)((uint)(_10481) >> 16)))) + f16tof32(((uint)((uint)(_10484) >> 16)))), ((_10615 * f16tof32(_10481)) + f16tof32(_10484))), 0.0f);
                            _11511 = (_11503.x * _10504);
                            _11512 = (_11503.y * _10505);
                            _11513 = (_11503.z * _10507);
                          } else {
                            _11511 = _10504;
                            _11512 = _10505;
                            _11513 = _10507;
                          }
                          _11514 = _11489 * _10638;
                          [branch]
                          if (!(_11514 == 0.0f)) {
                            bool __branch_chain_11517;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _11533 = 0;
                              __branch_chain_11517 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _11533 = 1;
                                __branch_chain_11517 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _11533 = 2;
                                  __branch_chain_11517 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1286) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _11533 = 3;
                                    __branch_chain_11517 = true;
                                  } else {
                                    _11558 = _11514;
                                    __branch_chain_11517 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_11517) {
                              while(true) {
                                _11536 = srvDeferredShadingEvaluateAdaptationPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                                if (_11533 == 0) {
                                  _11550 = _11536.x;
                                } else {
                                  if (_11533 == 1) {
                                    _11550 = _11536.y;
                                  } else {
                                    if (_11533 == 2) {
                                      _11550 = _11536.z;
                                    } else {
                                      _11550 = _11536.w;
                                    }
                                  }
                                }
                                _11558 = ((((_11488 * _11488) * ((_11550 * _11550) + -1.0f)) + 1.0f) * _10638);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_11558 > 0.0f) {
                                if (_10531) {
                                  [branch]
                                  if (!((_10478 & 1) == 0)) {
                                    _11574 = max(max(_11511, _11512), _11513);
                                    if (_11574 > 0.0f) {
                                      _11584 = saturate(_11511 / _11574);
                                      _11585 = saturate(_11512 / _11574);
                                      _11586 = saturate(_11513 / _11574);
                                    } else {
                                      _11584 = _11511;
                                      _11585 = _11512;
                                      _11586 = _11513;
                                    }
                                    _11587 = (_11585 < _11586);
                                    _11588 = select(_11587, _11586, _11585);
                                    _11589 = select(_11587, _11585, _11586);
                                    _11590 = select(_11587, -1.0f, 0.0f);
                                    _11591 = (_11584 < _11588);
                                    _11593 = select(_11591, _11588, _11584);
                                    _11594 = select(_11591, _11584, _11588);
                                    _11598 = _11593 - select((_11594 < _11589), _11594, _11589);
                                    _11604 = abs(select(_11591, (-0.3333333432674408f - _11590), _11590) + ((_11594 - _11589) / ((_11598 * 6.0f) + 9.999999682655225e-21f)));
                                    if (_11604 < 0.6666666865348816f) {
                                      _11617 = ((saturate(((float)((uint)((uint)(((uint)(_10478) >> 9) & 255)))) * 0.003921499941498041f) * (select((_11604 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _11604)) + _11604);
                                    } else {
                                      _11617 = _11604;
                                    }
                                    _11618 = saturate((_11598 / (_11593 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_10478) >> 1) & 255)))) * 0.003921499941498041f));
                                    _11619 = saturate(_11593);
                                    if (!(_11618 <= 0.0f)) {
                                      _11622 = saturate(_11617);
                                      _11626 = select(((_11622 * 360.0f) >= 360.0f), 0.0f, (_11622 * 6.0f));
                                      _11627 = int(_11626);
                                      _11629 = _11626 - float((int)(_11627));
                                      _11631 = _11619 * (1.0f - _11618);
                                      _11634 = (1.0f - (_11629 * _11618)) * _11619;
                                      _11638 = (1.0f - ((1.0f - _11629) * _11618)) * _11619;
                                      switch (_11627) {
                                        case 0: {
                                          _11646 = _11619;
                                          _11647 = _11638;
                                          _11648 = _11631;
                                          break;
                                        }
                                        case 1: {
                                          _11646 = _11634;
                                          _11647 = _11619;
                                          _11648 = _11631;
                                          break;
                                        }
                                        case 2: {
                                          _11646 = _11631;
                                          _11647 = _11619;
                                          _11648 = _11638;
                                          break;
                                        }
                                        case 3: {
                                          _11646 = _11631;
                                          _11647 = _11634;
                                          _11648 = _11619;
                                          break;
                                        }
                                        case 4: {
                                          _11646 = _11638;
                                          _11647 = _11631;
                                          _11648 = _11619;
                                          break;
                                        }
                                        case 5: {
                                          _11646 = _11619;
                                          _11647 = _11631;
                                          _11648 = _11634;
                                          break;
                                        }
                                        default: {
                                          _11646 = 0.0f;
                                          _11647 = 0.0f;
                                          _11648 = 0.0f;
                                          break;
                                        }
                                      }
                                    } else {
                                      _11646 = _11619;
                                      _11647 = _11619;
                                      _11648 = _11619;
                                    }
                                    _11649 = _11646 * _11574;
                                    _11650 = _11647 * _11574;
                                    _11651 = _11648 * _11574;
                                    _11653 = saturate(_11489 * 1.0101009607315063f);
                                    _11664 = ((_11653 * (_11511 - _11649)) + _11649);
                                    _11665 = ((_11653 * (_11512 - _11650)) + _11650);
                                    _11666 = (lerp(_11651, _11513, _11653));
                                    _11667 = _11488;
                                  } else {
                                    _11664 = _11511;
                                    _11665 = _11512;
                                    _11666 = _11513;
                                    _11667 = _11488;
                                  }
                                } else {
                                  _11664 = _11511;
                                  _11665 = _11512;
                                  _11666 = _11513;
                                  _11667 = 0.0f;
                                }
                                _11668 = select(_162, (_11490 * _10638), _11558);
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _11675 = srvLightMappingData[_1286];
                                  if (!(_11675 == -1)) {
                                    _11680 = srvLightIndexData[_11675].nLayerIndex;
                                    _11682 = srvLightIndexData[_11675].vAtlasOrigin.x;
                                    _11683 = srvLightIndexData[_11675].vAtlasOrigin.y;
                                    _11685 = srvLightIndexData[_11675].vScreenOrigin.x;
                                    _11686 = srvLightIndexData[_11675].vScreenOrigin.y;
                                    _11695 = ((int)(_11680 * 5)) & 31;
                                    _11698 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_11682 + _65) - _11685)), ((int)((_11683 + _66) - _11686)), 0)))).x) & ((int)(31 << _11695)))) >> _11695;
                                    _11703 = ((float)((uint)((uint)((uint)(_11698) >> 1)))) * 0.06666667014360428f;
                                    _11709 = (_11703 * _11668);
                                    _11710 = (select(_162, ((float)((bool)(uint)((_11698 & 1) != 0))), _11703) * _11668);
                                  } else {
                                    _11709 = _11668;
                                    _11710 = _11668;
                                  }
                                } else {
                                  _11709 = _11668;
                                  _11710 = _11668;
                                }
                                _11714 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _11717 = select(_11714, (_11709 * _1019), _11709);
                                _11719 = _10566 * _10565;
                                _11720 = _10567 * _10565;
                                _11721 = _10568 * _10565;
                                _11722 = _10515 * _10443;
                                _11723 = _10515 * _10444;
                                _11724 = _10515 * _10445;
                                _11725 = _11719 + _11722;
                                _11726 = _11720 + _11723;
                                _11727 = _11721 + _11724;
                                _11728 = _11719 - _11722;
                                _11729 = _11720 - _11723;
                                _11730 = _11721 - _11724;
                                _11731 = (_10515 > 0.0f);
                                _11732 = dot(float3(_11725, _11726, _11727), float3(_11725, _11726, _11727));
                                _11733 = rsqrt(_11732);
                                [branch]
                                if (_11731) {
                                  _11736 = rsqrt(dot(float3(_11728, _11729, _11730), float3(_11728, _11729, _11730)));
                                  _11737 = _11736 * _11733;
                                  _11739 = dot(float3(_11725, _11726, _11727), float3(_11728, _11729, _11730)) * _11737;
                                  _11758 = (_11737 / ((_11737 + 0.5f) + (_11739 * 0.5f)));
                                  _11759 = (((dot(float3(_147, _148, _149), float3(_11728, _11729, _11730)) * _11736) + (dot(float3(_147, _148, _149), float3(_11725, _11726, _11727)) * _11733)) * 0.5f);
                                  _11760 = _11739;
                                } else {
                                  _11758 = (1.0f / (_11732 + 1.0f));
                                  _11759 = dot(float3(_147, _148, _149), float3((_11733 * _11725), (_11733 * _11726), (_11733 * _11727)));
                                  _11760 = 1.0f;
                                }
                                if (_10517 > 0.0f) {
                                  _11766 = sqrt(saturate((_10517 * _10517) * _11758));
                                  if (_11759 < _11766) {
                                    _11771 = max(_11759, (-0.0f - _11766)) + _11766;
                                    _11776 = ((_11771 * _11771) / (_11766 * 4.0f));
                                  } else {
                                    _11776 = _11759;
                                  }
                                } else {
                                  _11776 = _11759;
                                }
                                if (_11731) {
                                  _11778 = -0.0f - _322;
                                  _11779 = -0.0f - _323;
                                  _11780 = -0.0f - _321;
                                  _11782 = dot(float3(_11778, _11779, _11780), float3(_147, _148, _149)) * 2.0f;
                                  _11786 = _11778 - (_11782 * _147);
                                  _11787 = _11779 - (_11782 * _148);
                                  _11788 = _11780 - (_11782 * _149);
                                  _11789 = _11728 - _11725;
                                  _11790 = _11729 - _11726;
                                  _11791 = _11730 - _11727;
                                  _11792 = dot(float3(_11786, _11787, _11788), float3(_11789, _11790, _11791));
                                  _11798 = sqrt(((_11789 * _11789) + (_11790 * _11790)) + (_11791 * _11791));
                                  _11807 = saturate(((dot(float3(_11786, _11787, _11788), float3(_11725, _11726, _11727)) * _11792) - dot(float3(_11725, _11726, _11727), float3(_11789, _11790, _11791))) / ((_11798 * _11798) - (_11792 * _11792)));
                                  _11811 = (_11807 * _11789) + _11725;
                                  _11812 = (_11807 * _11790) + _11726;
                                  _11813 = (_11807 * _11791) + _11727;
                                  _11814 = dot(float3(_11811, _11812, _11813), float3(_11786, _11787, _11788));
                                  _11818 = (_11814 * _11786) - _11811;
                                  _11819 = (_11814 * _11787) - _11812;
                                  _11820 = (_11814 * _11788) - _11813;
                                  _11828 = saturate(0.009999999776482582f / sqrt(((_11818 * _11818) + (_11819 * _11819)) + (_11820 * _11820)));
                                  _11836 = ((_11828 * _11818) + _11811);
                                  _11837 = ((_11828 * _11819) + _11812);
                                  _11838 = ((_11828 * _11820) + _11813);
                                } else {
                                  _11836 = _11725;
                                  _11837 = _11726;
                                  _11838 = _11727;
                                }
                                _11840 = rsqrt(dot(float3(_11836, _11837, _11838), float3(_11836, _11837, _11838)));
                                _11841 = _11840 * _11836;
                                _11842 = _11840 * _11837;
                                _11843 = _11840 * _11838;
                                _11844 = _217 * _217;
                                _11845 = 1.0f - _11844;
                                _11848 = saturate((_10517 * _11845) * _11840);
                                _11850 = saturate(_11840 * f16tof32(_10457));
                                _11852 = rsqrt(dot(float3(_11719, _11720, _11721), float3(_11719, _11720, _11721)));
                                _11853 = _11852 * _11719;
                                _11854 = _11852 * _11720;
                                _11855 = _11852 * _11721;
                                _11856 = _10556 && _10558;
                                if (_11856) {
                                  _11859 = saturate(dot(float3(_147, _148, _149), float3(_11841, _11842, _11843)));
                                  _11866 = (_11859 * (_147 - _289)) + _289;
                                  _11867 = (_11859 * (_148 - _290)) + _290;
                                  _11868 = (_11859 * (_149 - _291)) + _291;
                                  _11870 = rsqrt(dot(float3(_11866, _11867, _11868), float3(_11866, _11867, _11868)));
                                  _11875 = (_11866 * _11870);
                                  _11876 = (_11867 * _11870);
                                  _11877 = (_11868 * _11870);
                                } else {
                                  _11875 = _147;
                                  _11876 = _148;
                                  _11877 = _149;
                                }
                                _11878 = dot(float3(_11875, _11876, _11877), float3(_11841, _11842, _11843));
                                _11879 = dot(float3(_11875, _11876, _11877), float3(_322, _323, _321));
                                _11880 = dot(float3(_322, _323, _321), float3(_11841, _11842, _11843));
                                _11883 = rsqrt((_11880 * 2.0f) + 2.0f);
                                _11886 = saturate(_11883 * (_11879 + _11878));
                                _11889 = saturate((_11883 * _11880) + _11883);
                                _11890 = (_11848 > 0.0f);
                                if (_11890) {
                                  _11894 = sqrt(1.0f - (_11848 * _11848));
                                  _11896 = (_11878 * 2.0f) * _11879;
                                  _11897 = _11896 - _11880;
                                  if (!(_11897 >= _11894)) {
                                    _11905 = rsqrt(1.0f - (_11897 * _11897)) * _11848;
                                    _11908 = _11905 * (_11879 - (_11897 * _11878));
                                    _11909 = _11879 * _11879;
                                    _11914 = _11905 * (((_11909 * 2.0f) + -1.0f) - (_11897 * _11880));
                                    _11923 = sqrt(saturate((((1.0f - (_11878 * _11878)) - _11909) - (_11880 * _11880)) + (_11896 * _11880)));
                                    _11924 = _11923 * _11905;
                                    _11927 = ((_11879 * 2.0f) * _11905) * _11923;
                                    _11929 = (_11894 * _11878) + _11879;
                                    _11930 = _11929 + _11908;
                                    _11931 = _11894 * _11880;
                                    _11933 = (_11931 + 1.0f) + _11914;
                                    _11934 = _11924 * _11933;
                                    _11935 = _11930 * _11933;
                                    _11936 = _11927 * _11930;
                                    _11941 = (((_11930 * 0.25f) * _11927) - (_11934 * 0.5f)) * _11935;
                                    _11955 = (((_11936 - (_11934 * 2.0f)) * _11936) + (_11934 * _11934)) + ((((-0.5f - ((_11933 + _11931) * 0.5f)) * _11935) + ((_11933 * _11933) * _11929)) * _11930);
                                    _11960 = (_11941 * 2.0f) / ((_11955 * _11955) + (_11941 * _11941));
                                    _11961 = _11955 * _11960;
                                    _11963 = 1.0f - (_11941 * _11960);
                                    _11969 = ((_11961 * _11927) + _11931) + (_11963 * _11914);
                                    _11972 = rsqrt((_11969 * 2.0f) + 2.0f);
                                    _11981 = saturate((_11969 * _11972) + _11972);
                                    _11982 = saturate(((_11929 + (_11961 * _11924)) + (_11963 * _11908)) * _11972);
                                  } else {
                                    _11981 = abs(_11879);
                                    _11982 = 1.0f;
                                  }
                                } else {
                                  _11981 = _11889;
                                  _11982 = _11886;
                                }
                                _11983 = saturate(_11879);
                                _11984 = saturate(_11776);
                                _11985 = dot(float3(_11875, _11876, _11877), float3(_11853, _11854, _11855));
                                _11986 = saturate(_11985);
                                _11987 = _11844 * _11844;
                                _11988 = (_11850 > 0.0f);
                                if (_11988) {
                                  _11997 = saturate(((_11850 * _11850) / ((_11981 * 3.5999999046325684f) + 0.4000000059604645f)) + _11987);
                                } else {
                                  _11997 = _11987;
                                }
                                if (_11890) {
                                  _12006 = (((_11848 * 0.25f) * ((sqrt(_11997) * 3.0f) + _11848)) / (_11981 + 0.0010000000474974513f)) + _11997;
                                  _12009 = _12006;
                                  _12010 = (_11997 / _12006);
                                } else {
                                  _12009 = _11997;
                                  _12010 = 1.0f;
                                }
                                _12011 = (_11760 < 1.0f);
                                if (_12011) {
                                  _12017 = sqrt((1.000100016593933f - _11760) / max(9.999999974752427e-07f, (_11760 + 1.0f)));
                                  _12030 = (sqrt(_12009 / ((((_12017 * 0.25f) * ((sqrt(_12009) * 3.0f) + _12017)) / (_11981 + 0.0010000000474974513f)) + _12009)) * _12010);
                                } else {
                                  _12030 = _12010;
                                }
                                _12034 = (((_11997 * _11982) - _11982) * _11982) + 1.0f;
                                _12037 = (_11997 / (_12034 * _12034)) * _12030;
                                _12038 = 1.0f - _201;
                                _12039 = 1.0f - _202;
                                _12040 = 1.0f - _203;
                                _12041 = saturate(_11981);
                                _12042 = 1.0f - _12041;
                                _12043 = log2(_12042);
                                _12045 = exp2(_12043 * 5.0f);
                                _12049 = (_12045 * _12038) + _201;
                                _12050 = (_12045 * _12039) + _202;
                                _12051 = (_12045 * _12040) + _203;
                                _12052 = abs(_11879);
                                _12054 = saturate(_12052 + 9.999999747378752e-06f);
                                _12055 = sqrt(_11997);
                                _12056 = 1.0f - _12055;
                                _12064 = 0.5f / ((((_12056 * _12054) + _12055) * _11984) + (((_12056 * _11984) + _12055) * _12054));
                                if (_162) {
                                  _12074 = ((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                  _12075 = ((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                  _12076 = ((_115 + -0.5f) * 0.5f) + 0.5f;
                                  _12093 = ((dot(float3((-0.0f - _11875), (-0.0f - _11876), (-0.0f - _11877)), float3(_11853, _11854, _11855)) + dot(float3((-0.0f - _322), (-0.0f - _323), (-0.0f - _321)), float3(_11853, _11854, _11855))) * 0.5f) * exp2(log2(1.0f - _11983) * (11.0f - (((float)((uint)((uint)((uint)(_259) >> 2)))) * 0.1666666716337204f)));
                                  _12100 = dot(float3(_113, _114, _115), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                  _12103 = saturate((_12100 + -0.009999999776482582f) * -100.0f);
                                  _12108 = ((_12103 * _12103) * 3.0f) * (3.0f - (_12103 * 2.0f));
                                  _12115 = 10.0f - (exp2(log2(saturate(_12100 * 5.0f)) * 3.0f) * 9.0f);
                                  _12116 = saturate(_11986 + _12074) * _11986;
                                  _12117 = saturate(_11986 + _12075) * _11986;
                                  _12118 = saturate(_11986 + _12076) * _11986;
                                  _12137 = (max(((_12108 + _12074) * _12093), 0.0f) * _12115) + sqrt(_12116 * _12116);
                                  _12138 = (max(((_12108 + _12075) * _12093), 0.0f) * _12115) + sqrt(_12117 * _12117);
                                  _12139 = (max(((_12108 + _12076) * _12093), 0.0f) * _12115) + sqrt(_12118 * _12118);
                                  _12140 = _11841 + _322;
                                  _12141 = _11842 + _323;
                                  _12142 = _11843 + _321;
                                  _12144 = rsqrt(dot(float3(_12140, _12141, _12142), float3(_12140, _12141, _12142)));
                                  if (!(select((_258 != 0), 1.0f, 0.0f) < 1.0f)) {
                                    _12158 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                                    _12159 = _12158 * _147;
                                    _12160 = _12158 * _148;
                                    _12161 = _12158 * _149;
                                    _12164 = (abs(_12159) < abs(_12160));
                                    _12165 = select(_12164, 1.0f, 0.0f);
                                    _12166 = select(_12164, 0.0f, 1.0f);
                                    _12167 = _12166 * _12161;
                                    _12169 = -0.0f - (_12161 * _12165);
                                    _12172 = (_12165 * _12160) - (_12166 * _12159);
                                    _12174 = rsqrt(dot(float3(_12167, _12169, _12172), float3(_12167, _12169, _12172)));
                                    _12175 = _12167 * _12174;
                                    _12176 = _12174 * _12169;
                                    _12177 = _12172 * _12174;
                                    _12180 = (_12176 * _12161) - (_12177 * _12160);
                                    _12183 = (_12177 * _12159) - (_12175 * _12161);
                                    _12186 = (_12175 * _12160) - (_12176 * _12159);
                                    _12188 = rsqrt(dot(float3(_12180, _12183, _12186), float3(_12180, _12183, _12186)));
                                    _12200 = saturate(abs(_257 + -2.5f) + -0.5f) + -0.5f;
                                    _12201 = saturate(1.5f - abs(_257 + -1.5f)) + -0.5f;
                                    _12203 = rsqrt(dot(float2(_12200, _12201), float2(_12200, _12201)));
                                    _12204 = _12203 * _12200;
                                    _12205 = _12203 * _12201;
                                    _12212 = ((_12180 * _12188) * _12204) + (_12205 * _12175);
                                    _12213 = ((_12183 * _12188) * _12204) + (_12205 * _12176);
                                    _12214 = ((_12186 * _12188) * _12204) + (_12205 * _12177);
                                    _12217 = min(max(dot(float3(_12212, _12213, _12214), float3(_11841, _11842, _11843)), -1.0f), 1.0f);
                                    _12220 = min(max(dot(float3(_12212, _12213, _12214), float3(_322, _323, _321)), -1.0f), 1.0f);
                                    _12221 = abs(_12220);
                                    _12226 = (1.5707963705062866f - (_12221 * 0.1565829962491989f)) * sqrt(1.0f - _12221);
                                    _12230 = abs(_12217);
                                    _12235 = (1.5707963705062866f - (_12230 * 0.1565829962491989f)) * sqrt(1.0f - _12230);
                                    _12242 = cos(abs(select((_12217 >= 0.0f), _12235, (3.1415927410125732f - _12235)) - select((_12220 >= 0.0f), _12226, (3.1415927410125732f - _12226))) * 0.5f);
                                    _12246 = _11841 - (_12217 * _12212);
                                    _12247 = _11842 - (_12217 * _12213);
                                    _12248 = _11843 - (_12217 * _12214);
                                    _12252 = _322 - (_12220 * _12212);
                                    _12253 = _323 - (_12220 * _12213);
                                    _12254 = _321 - (_12220 * _12214);
                                    _12261 = rsqrt((dot(float3(_12252, _12253, _12254), float3(_12252, _12253, _12254)) * dot(float3(_12246, _12247, _12248), float3(_12246, _12247, _12248))) + 9.999999747378752e-05f) * dot(float3(_12246, _12247, _12248), float3(_12252, _12253, _12254));
                                    _12265 = sqrt(saturate((_12261 * 0.5f) + 0.5f));
                                    _12269 = _11844 * 0.5f;
                                    _12270 = _11844 * 2.0f;
                                    _12274 = exp2((1.0f - abs(_11667)) * -72.13475036621094f);
                                    if (!((_259 & 1) == 0)) {
                                      _12281 = select(((select(((_259 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_11667 == -1.0f))), 0.0f, _12274);
                                    } else {
                                      _12281 = _12274;
                                    }
                                    _12285 = saturate((dot(float3(_147, _148, _149), float3(_11841, _11842, _11843)) + 0.5f) * 0.6666666865348816f);
                                    _12295 = (_12220 + _12217) + ((((_12265 * 0.9975510239601135f) * sqrt(1.0f - (_12220 * _12220))) - (_12220 * 0.06994284689426422f)) * 0.13988569378852844f);
                                    _12297 = (_11844 * 1.4142135381698608f) * _12265;
                                    _12310 = 1.0f - sqrt(saturate((_11880 * 0.5f) + 0.5f));
                                    _12311 = _12310 * _12310;
                                    _12317 = saturate(-0.0f - _11880);
                                    _12320 = (1.0f - saturate(_12317)) * _12285;
                                    _12329 = ((((_12265 * 0.5f) * (exp2((((_12295 * _12295) * -0.5f) / (_12297 * _12297)) * 1.4426950216293335f) / (_12297 * 2.5066282749176025f))) * min(_205, 0.5f)) * (((_12311 * _12311) * (_12310 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_12320, 1.0f, _12281));
                                    _12331 = (_12217 + -0.03500000014901161f) + _12220;
                                    _12340 = 1.0f / ((1.190000057220459f / _12242) + (_12242 * 0.36000001430511475f));
                                    _12345 = ((_12340 * (0.6000000238418579f - (_12261 * 0.800000011920929f))) + 1.0f) * _12265;
                                    _12351 = 1.0f - (sqrt(saturate(1.0f - (_12345 * _12345))) * _12242);
                                    _12352 = _12351 * _12351;
                                    _12356 = 0.9534794092178345f - ((_12352 * _12352) * (_12351 * 0.9534794092178345f));
                                    _12357 = _12345 * _12340;
                                    _12362 = (sqrt(1.0f - (_12357 * _12357)) * 0.5f) / _12242;
                                    _12381 = 1.0f - saturate((_12317 + -0.44999998807907104f) * 2.222222328186035f);
                                    _12384 = ((1.0f - _12285) * _12281) + _12285;
                                    _12387 = ((_12356 * _12356) * (exp2((((_12331 * _12331) * -0.5f) / (_12269 * _12269)) * 1.4426950216293335f) / (_11844 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_12261 * 5.2658371925354f));
                                    _12401 = (_12217 + -0.14000000059604645f) + _12220;
                                    _12411 = 1.0f - (_12242 * 0.5f);
                                    _12412 = _12411 * _12411;
                                    _12416 = (_12412 * _12412) * (0.9534794092178345f - (_12242 * 0.47673970460891724f));
                                    _12418 = 0.9534794092178345f - _12416;
                                    _12420 = (_12418 * _12418) * (_12416 + 0.04652056470513344f);
                                    _12423 = exp2((_12261 * 24.525815963745117f) + -24.208423614501953f);
                                    _12436 = ((exp2((((_12401 * _12401) * -0.5f) / (_12270 * _12270)) * 1.4426950216293335f) / (_11844 * 5.013256549835205f)) * (lerp(_12420, 1.0f, _170))) * (((exp2((saturate(dot(float3((_12144 * _12140), (_12144 * _12141), (_12144 * _12142)), float3(_147, _148, _149))) * 17.312339782714844f) + -14.109557151794434f) - _12423) * _170) + _12423);
                                    _13216 = (((((exp2(log2(max(_113, 0.0f)) * _12362) * _12384) * _12387) * _12381) + _12329) + (_12436 * _113));
                                    _13217 = (((((exp2(log2(max(_114, 0.0f)) * _12362) * _12384) * _12387) * _12381) + _12329) + (_12436 * _114));
                                    _13218 = (((((exp2(log2(max(_115, 0.0f)) * _12362) * _12384) * _12387) * _12381) + _12329) + (_12436 * _115));
                                    _13219 = _12137;
                                    _13220 = _12138;
                                    _13221 = _12139;
                                  } else {
                                    _13216 = 0.0f;
                                    _13217 = 0.0f;
                                    _13218 = 0.0f;
                                    _13219 = _12137;
                                    _13220 = _12138;
                                    _13221 = _12139;
                                  }
                                } else {
                                  if (_11856) {
                                    _12454 = ((float)((uint)((uint)(_261 & 15)))) * 0.06666667014360428f;
                                    _12455 = _217 * 0.0317460335791111f;
                                    _12458 = min(1.0f, max((_12455 * ((float)((uint)((uint)((uint)(_260) >> 2))))), 0.019999999552965164f));
                                    _12461 = min(1.0f, max((_12455 * ((float)((uint)((uint)((((int)(_260 << 4)) & 48) | ((uint)(_261) >> 4)))))), 0.019999999552965164f));
                                    _12464 = ((_12461 - _12458) * _12454) + _12458;
                                    _12465 = _12464 * _12464;
                                    _12469 = saturate(abs(_11983) + 9.999999747378752e-06f);
                                    _12470 = sqrt(_12465 * _12465);
                                    _12471 = 1.0f - _12470;
                                    _12480 = _12458 * _12458;
                                    _12481 = _12480 * _12480;
                                    if (_11988) {
                                      _12490 = saturate(((_11850 * _11850) / ((_11981 * 3.5999999046325684f) + 0.4000000059604645f)) + _12481);
                                    } else {
                                      _12490 = _12481;
                                    }
                                    if (_11890) {
                                      _12499 = (((_11848 * 0.25f) * ((sqrt(_12490) * 3.0f) + _11848)) / (_11981 + 0.0010000000474974513f)) + _12490;
                                      _12502 = _12499;
                                      _12503 = (_12490 / _12499);
                                    } else {
                                      _12502 = _12490;
                                      _12503 = 1.0f;
                                    }
                                    if (_12011) {
                                      _12509 = sqrt((1.000100016593933f - _11760) / max(9.999999974752427e-07f, (_11760 + 1.0f)));
                                      _12522 = (sqrt(_12502 / ((((_12509 * 0.25f) * ((sqrt(_12502) * 3.0f) + _12509)) / (_11981 + 0.0010000000474974513f)) + _12502)) * _12503);
                                    } else {
                                      _12522 = _12503;
                                    }
                                    _12523 = _12461 * _12461;
                                    _12524 = _12523 * _12523;
                                    if (_11988) {
                                      _12533 = saturate(((_11850 * _11850) / ((_11981 * 3.5999999046325684f) + 0.4000000059604645f)) + _12524);
                                    } else {
                                      _12533 = _12524;
                                    }
                                    if (_11890) {
                                      _12542 = (((_11848 * 0.25f) * ((sqrt(_12533) * 3.0f) + _11848)) / (_11981 + 0.0010000000474974513f)) + _12533;
                                      _12545 = _12542;
                                      _12546 = (_12533 / _12542);
                                    } else {
                                      _12545 = _12533;
                                      _12546 = 1.0f;
                                    }
                                    if (_12011) {
                                      _12552 = sqrt((1.000100016593933f - _11760) / max(9.999999974752427e-07f, (_11760 + 1.0f)));
                                      _12565 = (sqrt(_12545 / ((((_12552 * 0.25f) * ((sqrt(_12545) * 3.0f) + _12552)) / (_11981 + 0.0010000000474974513f)) + _12545)) * _12546);
                                    } else {
                                      _12565 = _12546;
                                    }
                                    _12569 = (((_12490 * _11982) - _11982) * _11982) + 1.0f;
                                    _12572 = (_12490 / (_12569 * _12569)) * _12522;
                                    _12576 = (((_12533 * _11982) - _11982) * _11982) + 1.0f;
                                    _12583 = saturate(_11982);
                                    _12587 = saturate((_11985 + _10514) / (_10514 + 1.0f));
                                    _12592 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_262)))) + 1u))]);
                                    _12599 = ((float)((uint)((uint)((uint)((uint)(_12592.x)) >> 24)))) * 0.25f;
                                    _12602 = ((float)((uint)((uint)(_12592.x & 255)))) * 0.003921568859368563f;
                                    _12606 = ((float)((uint)((uint)(((uint)((uint)(_12592.x)) >> 8) & 255)))) * 0.003921568859368563f;
                                    _12610 = ((float)((uint)((uint)(((uint)((uint)(_12592.x)) >> 16) & 255)))) * 0.003921568859368563f;
                                    _12619 = ((float)((uint)((uint)((uint)((uint)(_12592.y)) >> 24)))) * 0.25f;
                                    _12622 = ((float)((uint)((uint)(_12592.y & 255)))) * 0.003921568859368563f;
                                    _12626 = ((float)((uint)((uint)(((uint)((uint)(_12592.y)) >> 8) & 255)))) * 0.003921568859368563f;
                                    _12630 = ((float)((uint)((uint)(((uint)((uint)(_12592.y)) >> 16) & 255)))) * 0.003921568859368563f;
                                    _12638 = (float)((uint)((uint)(_12592.w & 31)));
                                    _12644 = (float)((uint)((uint)(((uint)((uint)(_12592.w)) >> 10) & 31)));
                                    _12654 = (float)((uint)((uint)(((uint)((uint)(_12592.w)) >> 25) & 31)));
                                    _12657 = ((float)((uint)((uint)(_12592.z & 255)))) * 0.003921568859368563f;
                                    _12661 = ((float)((uint)((uint)(((uint)((uint)(_12592.z)) >> 8) & 255)))) * 0.003921568859368563f;
                                    _12665 = ((float)((uint)((uint)(((uint)((uint)(_12592.z)) >> 16) & 255)))) * 0.003921568859368563f;
                                    _12672 = (((float)((uint)((uint)((uint)((uint)(_12592.z)) >> 24)))) * 0.003921568859368563f) * select(((_12592.w & 1073741824) != 0), -1.0f, 1.0f);
                                    _12686 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_12592.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _12041)));
                                    _12687 = ((2.0f - (_12638 * 0.06451612710952759f)) > 0.0f);
                                    if (_12687) {
                                      _12698 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _12583))) * (10.0f - (_12638 * 0.32258063554763794f))) * _12686);
                                    } else {
                                      _12698 = _12686;
                                    }
                                    _12709 = exp2(log2(max(9.999999747378752e-06f, _12583)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_12592.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                                    _12710 = ((2.0f - (_12644 * 0.06451612710952759f)) > 0.0f);
                                    if (_12710) {
                                      _12720 = (exp2(log2(max(9.999999747378752e-06f, _12042)) * (10.0f - (_12644 * 0.32258063554763794f))) * _12709);
                                    } else {
                                      _12720 = _12709;
                                    }
                                    if (_12687) {
                                      _12734 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _12583))) * (10.0f - (_12638 * 0.32258063554763794f))) * _12686);
                                    } else {
                                      _12734 = _12686;
                                    }
                                    if (_12710) {
                                      _12747 = (exp2(log2(max(9.999999747378752e-06f, _12042)) * (10.0f - (_12644 * 0.32258063554763794f))) * _12709);
                                    } else {
                                      _12747 = _12709;
                                    }
                                    if (_12687) {
                                      _12761 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _12583))) * (10.0f - (_12638 * 0.32258063554763794f))) * _12686);
                                    } else {
                                      _12761 = _12686;
                                    }
                                    if (_12710) {
                                      _12774 = (exp2(log2(max(9.999999747378752e-06f, _12042)) * (10.0f - (_12644 * 0.32258063554763794f))) * _12709);
                                    } else {
                                      _12774 = _12709;
                                    }
                                    _12786 = (1.0f - exp2(log2(1.0f - _12583) * 3.0f)) * (1.0f - exp2(_12043 * 3.0f));
                                    _12790 = saturate(_12587 / (_12786 * (((float)((uint)((uint)(((uint)((uint)(_12592.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                                    _12795 = ((_12790 * _12790) * (3.0f - (_12790 * 2.0f))) + -1.0f;
                                    _12797 = ((((_12657 * _12657) * _12672) * _12786) * _12795) + 1.0f;
                                    _12800 = ((((_12661 * _12661) * _12672) * _12786) * _12795) + 1.0f;
                                    _12803 = ((((_12665 * _12665) * _12672) * _12786) * _12795) + 1.0f;
                                    _12805 = saturate(_12654 * 0.06451612710952759f);
                                    _12812 = exp2(log2(1.0f - _11981) * (10.0f - (_12654 * 0.32258063554763794f)));
                                    _12831 = ((((((_12533 / (_12576 * _12576)) * _12565) - _12572) * _12454) + _12572) * (0.5f / ((((_12471 * _12469) + _12470) * _11984) + (((_12471 * _11984) + _12470) * _12469)))) * _11984;
                                    _13216 = ((_12831 * _12797) * (((_12805 * _12038) * _12812) + _201));
                                    _13217 = ((_12831 * _12800) * (((_12805 * _12039) * _12812) + _202));
                                    _13218 = ((_12831 * _12803) * (((_12805 * _12040) * _12812) + _203));
                                    _13219 = (((((_12698 * (((_12602 * _12602) * _12599) + -1.0f)) + 1.0f) * _12587) * ((_12720 * (((_12622 * _12622) * _12619) + -1.0f)) + 1.0f)) * _12797);
                                    _13220 = (((((_12734 * (((_12606 * _12606) * _12599) + -1.0f)) + 1.0f) * _12587) * ((_12747 * (((_12626 * _12626) * _12619) + -1.0f)) + 1.0f)) * _12800);
                                    _13221 = (((((_12761 * (((_12610 * _12610) * _12599) + -1.0f)) + 1.0f) * _12587) * ((_12774 * (((_12630 * _12630) * _12619) + -1.0f)) + 1.0f)) * _12803);
                                  } else {
                                    if (_191) {
                                      if (_206 < 0.007874015718698502f) {
                                        _12845 = _11982 * _11982;
                                        _12847 = max((1.0f - _12845), 9.999999747378752e-05f);
                                        _12992 = (((((((exp2(((-0.0f - (_12845 / _12847)) / _11997) * 1.4426950216293335f) * 4.0f) / (_12847 * _12847)) + 1.0f) * (1.0f / ((_11997 * 4.0f) + 1.0f))) - _12037) * _207) + _12037);
                                        _12993 = (((saturate(0.25f / ((_11986 + _11983) - (_11986 * _11983))) - _12064) * _207) + _12064);
                                      } else {
                                        _12871 = rsqrt(dot(float3(_147, _148, _149), float3(_147, _148, _149)));
                                        _12872 = _12871 * _147;
                                        _12873 = _12871 * _148;
                                        _12874 = _12871 * _149;
                                        _12877 = (abs(_12872) < abs(_12873));
                                        _12878 = select(_12877, 1.0f, 0.0f);
                                        _12879 = select(_12877, 0.0f, 1.0f);
                                        _12880 = _12879 * _12874;
                                        _12882 = -0.0f - (_12874 * _12878);
                                        _12885 = (_12878 * _12873) - (_12879 * _12872);
                                        _12887 = rsqrt(dot(float3(_12880, _12882, _12885), float3(_12880, _12882, _12885)));
                                        _12888 = _12880 * _12887;
                                        _12889 = _12887 * _12882;
                                        _12890 = _12885 * _12887;
                                        _12893 = (_12889 * _12874) - (_12890 * _12873);
                                        _12896 = (_12890 * _12872) - (_12888 * _12874);
                                        _12899 = (_12888 * _12873) - (_12889 * _12872);
                                        _12901 = rsqrt(dot(float3(_12893, _12896, _12899), float3(_12893, _12896, _12899)));
                                        _12905 = _207 * 4.0f;
                                        _12914 = saturate(abs(_12905 + -2.5f) + -0.5f) + -0.5f;
                                        _12915 = saturate(1.5f - abs(_12905 + -1.5f)) + -0.5f;
                                        _12917 = rsqrt(dot(float2(_12914, _12915), float2(_12914, _12915)));
                                        _12918 = _12917 * _12914;
                                        _12919 = _12917 * _12915;
                                        _12926 = ((_12893 * _12901) * _12918) + (_12919 * _12888);
                                        _12927 = ((_12896 * _12901) * _12918) + (_12919 * _12889);
                                        _12928 = ((_12899 * _12901) * _12918) + (_12919 * _12890);
                                        _12931 = (_12927 * _149) - (_12928 * _148);
                                        _12934 = (_12928 * _147) - (_12926 * _149);
                                        _12937 = (_12926 * _148) - (_12927 * _147);
                                        _12941 = rsqrt((dot(float3(_322, _323, _321), float3(_11853, _11854, _11855)) * 2.0f) + 2.0f);
                                        _12945 = dot(float3(_12926, _12927, _12928), float3(_11853, _11854, _11855));
                                        _12946 = dot(float3(_12926, _12927, _12928), float3(_322, _323, _321));
                                        _12949 = dot(float3(_12931, _12934, _12937), float3(_11853, _11854, _11855));
                                        _12950 = dot(float3(_12931, _12934, _12937), float3(_322, _323, _321));
                                        _12956 = min(max((_11844 * (_206 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                        _12960 = min(max((_11844 * (1.0f - _206)), 0.0010000000474974513f), 1.0f);
                                        _12961 = _12960 * _12956;
                                        _12962 = ((_12946 + _12945) * _12941) * _12960;
                                        _12963 = ((_12950 + _12949) * _12941) * _12956;
                                        _12964 = _12961 * saturate(_12941 * (_11879 + _11985));
                                        _12965 = dot(float3(_12962, _12963, _12964), float3(_12962, _12963, _12964));
                                        _12970 = _12956 * _12946;
                                        _12971 = _12960 * _12950;
                                        _12979 = _12956 * _12945;
                                        _12980 = _12960 * _12949;
                                        _12992 = (((_12961 * _12961) * _12961) / (_12965 * _12965));
                                        _12993 = saturate(0.5f / ((sqrt(((_12979 * _12979) + (_11986 * _11986)) + (_12980 * _12980)) * _12054) + (sqrt(((_12971 * _12971) + (_12970 * _12970)) + (_12054 * _12054)) * _11986)));
                                      }
                                      _12995 = (_12992 * _11986) * _12993;
                                      _13013 = saturate((_11985 + 0.5f) * 0.6666666865348816f);
                                      _13216 = (_12995 * _12049);
                                      _13217 = (_12995 * _12050);
                                      _13218 = (_12995 * _12051);
                                      _13219 = ((_13013 * (1.0f - _12049)) * saturate((((_113 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _11986));
                                      _13220 = ((_13013 * (1.0f - _12050)) * saturate((((_114 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _11986));
                                      _13221 = ((_13013 * (1.0f - _12051)) * saturate((((_115 + -0.5f) * 0.5f) + 0.5f) + _11986));
                                    } else {
                                      if (_212) {
                                        _13028 = _264 * _264;
                                        _13029 = _13028 * _13028;
                                        _13035 = saturate(select((_11845 > 0.0f), ((1.0f - _13028) / _11845), 0.0f) * _11848);
                                        _13036 = (_13035 > 0.0f);
                                        if (_13036) {
                                          _13040 = sqrt(1.0f - (_13035 * _13035));
                                          _13042 = (_11878 * 2.0f) * _11879;
                                          _13043 = _13042 - _11880;
                                          if (!(_13043 >= _13040)) {
                                            _13049 = rsqrt(1.0f - (_13043 * _13043)) * _13035;
                                            _13052 = _13049 * (_11879 - (_13043 * _11878));
                                            _13053 = _11879 * _11879;
                                            _13058 = _13049 * (((_13053 * 2.0f) + -1.0f) - (_13043 * _11880));
                                            _13067 = sqrt(saturate((((1.0f - (_11878 * _11878)) - _13053) - (_11880 * _11880)) + (_13042 * _11880)));
                                            _13068 = _13067 * _13049;
                                            _13071 = ((_11879 * 2.0f) * _13049) * _13067;
                                            _13073 = (_13040 * _11878) + _11879;
                                            _13074 = _13073 + _13052;
                                            _13075 = _13040 * _11880;
                                            _13077 = (_13075 + 1.0f) + _13058;
                                            _13078 = _13068 * _13077;
                                            _13079 = _13074 * _13077;
                                            _13080 = _13071 * _13074;
                                            _13085 = (((_13074 * 0.25f) * _13071) - (_13078 * 0.5f)) * _13079;
                                            _13099 = (((_13080 - (_13078 * 2.0f)) * _13080) + (_13078 * _13078)) + ((((-0.5f - ((_13077 + _13075) * 0.5f)) * _13079) + ((_13077 * _13077) * _13073)) * _13074);
                                            _13104 = (_13085 * 2.0f) / ((_13099 * _13099) + (_13085 * _13085));
                                            _13105 = _13099 * _13104;
                                            _13107 = 1.0f - (_13085 * _13104);
                                            _13113 = ((_13105 * _13071) + _13075) + (_13107 * _13058);
                                            _13116 = rsqrt((_13113 * 2.0f) + 2.0f);
                                            _13125 = saturate((_13113 * _13116) + _13116);
                                            _13126 = saturate(((_13073 + (_13105 * _13068)) + (_13107 * _13052)) * _13116);
                                          } else {
                                            _13125 = _12052;
                                            _13126 = 1.0f;
                                          }
                                        } else {
                                          _13125 = _11889;
                                          _13126 = _11886;
                                        }
                                        if (_11988) {
                                          _13135 = saturate(((_11850 * _11850) / ((_13125 * 3.5999999046325684f) + 0.4000000059604645f)) + _13029);
                                        } else {
                                          _13135 = _13029;
                                        }
                                        if (_13036) {
                                          _13144 = (((_13035 * 0.25f) * ((sqrt(_13135) * 3.0f) + _13035)) / (_13125 + 0.0010000000474974513f)) + _13135;
                                          _13147 = _13144;
                                          _13148 = (_13135 / _13144);
                                        } else {
                                          _13147 = _13135;
                                          _13148 = 1.0f;
                                        }
                                        if (_12011) {
                                          _13154 = sqrt((1.000100016593933f - _11760) / max(9.999999974752427e-07f, (_11760 + 1.0f)));
                                          _13167 = (sqrt(_13147 / ((((_13154 * 0.25f) * ((sqrt(_13147) * 3.0f) + _13154)) / (_13125 + 0.0010000000474974513f)) + _13147)) * _13148);
                                        } else {
                                          _13167 = _13148;
                                        }
                                        _13171 = (((_13135 * _13126) - _13126) * _13126) + 1.0f;
                                        _13181 = sqrt(_13135);
                                        _13182 = 1.0f - _13181;
                                        _13197 = ((((exp2(log2(1.0f - saturate(_13125)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _263) * (((_13167 * _11984) * (_13135 / (_13171 * _13171))) * (0.5f / ((((_13182 * _12054) + _13181) * _11984) + (((_13182 * _11984) + _13181) * _12054)))));
                                        _13198 = false;
                                      } else {
                                        _13197 = 0.0f;
                                        _13198 = true;
                                      }
                                      _13202 = saturate((_11985 + _10514) / (_10514 + 1.0f));
                                      _13204 = (_12037 * _11984) * _12064;
                                      _13208 = _13197 + (_13204 * _12049);
                                      _13209 = _13197 + (_13204 * _12050);
                                      _13210 = _13197 + (_13204 * _12051);
                                      [branch]
                                      if (_13198) {
                                        _13216 = (_13208 * _874);
                                        _13217 = (_13209 * _875);
                                        _13218 = (_13210 * _876);
                                        _13219 = _13202;
                                        _13220 = _13202;
                                        _13221 = _13202;
                                      } else {
                                        _13216 = _13208;
                                        _13217 = _13209;
                                        _13218 = _13210;
                                        _13219 = _13202;
                                        _13220 = _13202;
                                        _13221 = _13202;
                                      }
                                    }
                                  }
                                }
                                _13222 = _11664 * _1341;
                                _13223 = _11665 * _1341;
                                _13224 = _11666 * _1341;
                                _13231 = ((_11717 * _13222) * _13219) + _1274;
                                _13232 = ((_11717 * _13223) * _13220) + _1275;
                                _13233 = ((_11717 * _13224) * _13221) + _1276;
                                if (_10511 > 0.0f) {
                                  _13237 = (_10511 * _1034) * select(_11714, (_11710 * _1019), _11710);
                                  _13729 = _13231;
                                  _13730 = _13232;
                                  _13731 = _13233;
                                  _13732 = (((_13237 * _13222) * _13216) + _1277);
                                  _13733 = (((_13237 * _13223) * _13217) + _1278);
                                  _13734 = (((_13237 * _13224) * _13218) + _1279);
                                } else {
                                  _13729 = _13231;
                                  _13730 = _13232;
                                  _13731 = _13233;
                                  _13732 = _1277;
                                  _13733 = _1278;
                                  _13734 = _1279;
                                }
                              } else {
                                _13729 = _1274;
                                _13730 = _1275;
                                _13731 = _1276;
                                _13732 = _1277;
                                _13733 = _1278;
                                _13734 = _1279;
                              }
                              break;
                            }
                          } else {
                            _13729 = _1274;
                            _13730 = _1275;
                            _13731 = _1276;
                            _13732 = _1277;
                            _13733 = _1278;
                            _13734 = _1279;
                          }
                        } else {
                          if (_1324 == 10) {
                            _13252 = asfloat(srvLightInfoProperties.Load4(_1293)).x;
                            _13253 = asfloat(srvLightInfoProperties.Load4(_1293)).y;
                            _13254 = asfloat(srvLightInfoProperties.Load4(_1293)).z;
                            _13255 = asfloat(srvLightInfoProperties.Load4(_1293)).w;
                            _13258 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).x;
                            _13259 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).y;
                            _13260 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).z;
                            _13261 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 16u)))).w;
                            _13264 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).x;
                            _13265 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).y;
                            _13266 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).z;
                            _13267 = asfloat(srvLightInfoProperties.Load4(((int)(_1293 + 32u)))).w;
                            _13270 = asfloat(srvLightInfoProperties.Load2(((int)(_1293 + 72u)))).x;
                            _13271 = asfloat(srvLightInfoProperties.Load2(((int)(_1293 + 72u)))).y;
                            _13274 = asint(srvLightInfoProperties.Load(((int)(_1293 + 80u))));
                            _13277 = asint(srvLightInfoProperties.Load(((int)(_1293 + 84u))));
                            _13280 = asint(srvLightInfoProperties.Load(((int)(_1293 + 88u))));
                            _13283 = asint(srvLightInfoProperties.Load(((int)(_1293 + 96u))));
                            _13286 = f16tof32(_13274);
                            _13288 = f16tof32(((uint)((uint)(_13277) >> 16)));
                            _13289 = f16tof32(_13277);
                            _13291 = f16tof32(((uint)((uint)(_13280) >> 16)));
                            _13295 = ((float)((uint)((uint)(((uint)(_13280) >> 8) & 255)))) * 0.003921499941498041f;
                            _13297 = (float)((uint)((uint)(_13283 & 65535)));
                            _13301 = mad(_13254, _315, mad(_13253, _314, (_13252 * _313))) + _13255;
                            _13305 = mad(_13260, _315, mad(_13259, _314, (_13258 * _313))) + _13261;
                            _13309 = mad(_13266, _315, mad(_13265, _314, (_13264 * _313))) + _13267;
                            _13312 = mad(_13254, _149, mad(_13253, _148, (_13252 * _147)));
                            _13315 = mad(_13260, _149, mad(_13259, _148, (_13258 * _147)));
                            _13318 = mad(_13266, _149, mad(_13265, _148, (_13264 * _147)));
                            _13330 = -0.0f - mad(_13266, _321, mad(_13265, _323, (_13264 * _322)));
                            _13331 = _13270 * 0.5f;
                            _13332 = _13271 * 0.5f;
                            _13333 = -0.0f - _13331;
                            _13334 = -0.0f - _13332;
                            _13335 = _13333 - _13301;
                            _13336 = _13334 - _13305;
                            _13337 = -0.0f - _13309;
                            _13338 = _13331 - _13301;
                            _13339 = _13332 - _13305;
                            _13340 = dot(float3(_13301, _13305, _13309), float3(_13312, _13315, _13318));
                            _13342 = dot(float3(_13333, _13334, 0.0f), float3(_13312, _13315, _13318)) - _13340;
                            _13344 = dot(float3(_13331, _13334, 0.0f), float3(_13312, _13315, _13318)) - _13340;
                            _13346 = dot(float3(_13331, _13332, 0.0f), float3(_13312, _13315, _13318)) - _13340;
                            _13348 = dot(float3(_13333, _13332, 0.0f), float3(_13312, _13315, _13318)) - _13340;
                            _13349 = min(_13342, _13344);
                            [branch]
                            if (!(!(_13349 >= 0.0f))) {
                              _13355 = rsqrt(dot(float3(_13338, _13336, _13337), float3(_13338, _13336, _13337)) * dot(float3(_13335, _13336, _13337), float3(_13335, _13336, _13337)));
                              _13357 = dot(float3(_13335, _13336, _13337), float3(_13338, _13336, _13337)) * _13355;
                              _13364 = rsqrt(max(((((_13357 * 0.09300000220537186f) + 0.5f) * _13357) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13355;
                              _13371 = (_13364 * (_13270 * _13337));
                              _13372 = (_13364 * (_13336 * (_13333 - _13331)));
                            } else {
                              _13371 = 0.0f;
                              _13372 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_13344, _13346) >= 0.0f))) {
                              _13379 = rsqrt(dot(float3(_13338, _13339, _13337), float3(_13338, _13339, _13337)) * dot(float3(_13338, _13336, _13337), float3(_13338, _13336, _13337)));
                              _13381 = dot(float3(_13338, _13336, _13337), float3(_13338, _13339, _13337)) * _13379;
                              _13388 = rsqrt(max(((((_13381 * 0.09300000220537186f) + 0.5f) * _13381) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13379;
                              _13396 = (_13388 * ((_13334 - _13332) * _13337));
                              _13397 = ((_13388 * (_13271 * _13338)) + _13372);
                            } else {
                              _13396 = 0.0f;
                              _13397 = _13372;
                            }
                            _13398 = min(_13346, _13348);
                            [branch]
                            if (!(!(_13398 >= 0.0f))) {
                              _13404 = rsqrt(dot(float3(_13335, _13339, _13337), float3(_13335, _13339, _13337)) * dot(float3(_13338, _13339, _13337), float3(_13338, _13339, _13337)));
                              _13406 = dot(float3(_13338, _13339, _13337), float3(_13335, _13339, _13337)) * _13404;
                              _13413 = rsqrt(max(((((_13406 * 0.09300000220537186f) + 0.5f) * _13406) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13404;
                              _13422 = ((_13413 * ((_13333 - _13331) * _13337)) + _13371);
                              _13423 = ((_13413 * (_13270 * _13339)) + _13397);
                            } else {
                              _13422 = _13371;
                              _13423 = _13397;
                            }
                            [branch]
                            if (!(!(min(_13348, _13342) >= 0.0f))) {
                              _13430 = rsqrt(dot(float3(_13335, _13336, _13337), float3(_13335, _13336, _13337)) * dot(float3(_13335, _13339, _13337), float3(_13335, _13339, _13337)));
                              _13432 = dot(float3(_13335, _13339, _13337), float3(_13335, _13336, _13337)) * _13430;
                              _13439 = rsqrt(max(((((_13432 * 0.09300000220537186f) + 0.5f) * _13432) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13430;
                              _13448 = ((_13439 * (_13271 * _13337)) + _13396);
                              _13449 = ((_13439 * (_13335 * (_13334 - _13332))) + _13423);
                            } else {
                              _13448 = _13396;
                              _13449 = _13423;
                            }
                            if (min(_13349, _13398) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_13342, _13344), max(_13346, _13348)) >= 0.0f))) {
                                _13458 = -0.0f - _13312;
                                _13459 = _13340 / _13315;
                                _13460 = _13333 / _13315;
                                _13461 = _13331 / _13315;
                                _13463 = (_13334 - _13459) / _13458;
                                _13465 = (_13332 - _13459) / _13458;
                                _13466 = min(_13460, _13461);
                                _13467 = max(_13460, _13461);
                                _13468 = min(_13463, _13465);
                                _13469 = max(_13463, _13465);
                                _13470 = max(_13466, _13468);
                                _13471 = min(_13467, _13469);
                                _13472 = _13470 * _13315;
                                _13474 = _13471 * _13315;
                                _13476 = _13472 - _13301;
                                _13477 = _13459 - _13305;
                                _13478 = _13477 + (_13470 * _13458);
                                _13479 = _13474 - _13301;
                                _13480 = _13477 + (_13471 * _13458);
                                _13481 = dot(float3(_13476, _13478, _13337), float3(_13476, _13478, _13337));
                                _13482 = dot(float3(_13479, _13480, _13337), float3(_13479, _13480, _13337));
                                _13484 = rsqrt(_13482 * _13481);
                                _13486 = dot(float3(_13476, _13478, _13337), float3(_13479, _13480, _13337)) * _13484;
                                _13493 = rsqrt(max(((((_13486 * 0.09300000220537186f) + 0.5f) * _13486) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13484;
                                _13506 = (_13466 > _13468);
                                _13508 = select(_13506, _13315, _13312);
                                _13514 = float((int)(((int)(uint)((int)(_13508 > 0.0f))) - ((int)(uint)((int)(_13508 < 0.0f)))));
                                _13518 = ((1.0f - (((float)((bool)_13506)) * 2.0f)) * _13331) * _13514;
                                _13520 = _13518 - _13301;
                                _13521 = (_13514 * _13332) - _13305;
                                _13522 = (_13467 < _13469);
                                _13524 = select(_13522, _13315, _13312);
                                _13530 = float((int)(((int)(uint)((int)(_13524 > 0.0f))) - ((int)(uint)((int)(_13524 < 0.0f)))));
                                _13531 = _13530 * _13331;
                                _13536 = _13531 - _13301;
                                _13537 = ((((((float)((bool)_13522)) * 2.0f) + -1.0f) * _13332) * _13530) - _13305;
                                _13540 = rsqrt(_13481 * dot(float3(_13520, _13521, _13337), float3(_13520, _13521, _13337)));
                                _13542 = dot(float3(_13520, _13521, _13337), float3(_13476, _13478, _13337)) * _13540;
                                _13549 = rsqrt(max(((((_13542 * 0.09300000220537186f) + 0.5f) * _13542) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13540;
                                _13562 = rsqrt(dot(float3(_13536, _13537, _13337), float3(_13536, _13537, _13337)) * _13482);
                                _13564 = dot(float3(_13479, _13480, _13337), float3(_13536, _13537, _13337)) * _13562;
                                _13571 = rsqrt(max(((((_13564 * 0.09300000220537186f) + 0.5f) * _13564) + 0.40700000524520874f), 9.999999682655225e-21f)) * _13562;
                                _13592 = ((((_13493 * (((_13470 - _13471) * _13458) * _13337)) + _13448) + (_13549 * ((_13521 - _13478) * _13337))) + (_13571 * ((_13480 - _13537) * _13337)));
                                _13593 = ((((_13493 * ((_13315 * (_13471 - _13470)) * _13337)) + _13422) + (_13549 * ((_13472 - _13518) * _13337))) + (_13571 * ((_13531 - _13474) * _13337)));
                                _13594 = ((((_13493 * ((_13480 * _13476) - (_13479 * _13478))) + _13449) + (_13549 * ((_13520 * _13478) - (_13521 * _13476)))) + (_13571 * ((_13537 * _13479) - (_13536 * _13480))));
                              } else {
                                _13592 = _13448;
                                _13593 = _13422;
                                _13594 = _13449;
                              }
                            } else {
                              _13592 = _13448;
                              _13593 = _13422;
                              _13594 = _13449;
                            }
                            _13600 = sqrt(((_13593 * _13593) + (_13592 * _13592)) + (_13594 * _13594));
                            _13601 = _13600 * 0.15915493667125702f;
                            [branch]
                            if (!(_13601 == 0.0f)) {
                              _13610 = saturate((_13601 - _13286) / (1.0f - _13286)) * ((float)((bool)(uint)(_13309 <= 0.0f)));
                              [branch]
                              if (!(_13610 == 0.0f)) {
                                if (_13600 > 0.0f) {
                                  _13618 = (dot(float3(_13312, _13315, _13318), float3(_13592, _13593, _13594)) / _13600);
                                } else {
                                  _13618 = 0.0f;
                                }
                                _13619 = 1.0f - _217;
                                _13620 = _13619 * _13619;
                                _13626 = exp2(log2(1.0f - saturate(dot(float3(_147, _148, _149), float3(_322, _323, _321)))) * 5.0f);
                                _13631 = min(_217, 0.800000011920929f);
                                _13640 = exp2(((((((_13631 * 3.322999954223633f) + -3.7669999599456787f) * _13631) + -0.3479999899864197f) * _13631) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _13648 = _13337 / (_13330 - ((_13318 * 2.0f) * dot(float3((-0.0f - mad(_13254, _321, mad(_13253, _323, (_13252 * _322)))), (-0.0f - mad(_13260, _321, mad(_13259, _323, (_13258 * _322)))), _13330), float3(_13312, _13315, _13318))));
                                _13651 = (_13648 * 2.0f) * rsqrt(select(_162, 9.999999747378752e-05f, (((9.999999747378752e-05f - _13640) * saturate((_217 + -0.5f) * 2.500000238418579f)) + _13640)));
                                _13659 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _13297), ((log2((_13651 * _13651) * f16tof32(((uint)((uint)(_13274) >> 16)))) * 0.5f) + 5.5f));
                                _13661 = (float)((bool)(uint)(_13648 > 0.0f));
                                _13662 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _13297), 10.0f);
                                _13671 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_13610 * _1019), _13610);
                                if (_13295 > 0.0f) {
                                  _13692 = _13295 * _1034;
                                  _13693 = _13671 * _1341;
                                  _13713 = ((((((_13692 * _13288) * _13661) * _13659.x) * _13693) * select(_162, _201, (((max(_13620, _201) - _201) * _13626) + _201))) + _1277);
                                  _13714 = ((((((_13692 * _13289) * _13661) * _13659.y) * _13693) * select(_162, _202, (((max(_13620, _202) - _202) * _13626) + _202))) + _1278);
                                  _13715 = ((((((_13291 * _13692) * _13661) * _13659.z) * _13693) * select(_162, _203, (((max(_13620, _203) - _203) * _13626) + _203))) + _1279);
                                } else {
                                  _13713 = _1277;
                                  _13714 = _1278;
                                  _13715 = _1279;
                                }
                                _13721 = ((_1341 * 5.4256415367126465f) * _13618) * _13671;
                                _13729 = (((_13662.x * _13288) * _13721) + _1274);
                                _13730 = (((_13662.y * _13289) * _13721) + _1275);
                                _13731 = (((_13662.z * _13291) * _13721) + _1276);
                                _13732 = _13713;
                                _13733 = _13714;
                                _13734 = _13715;
                              } else {
                                _13729 = _1274;
                                _13730 = _1275;
                                _13731 = _1276;
                                _13732 = _1277;
                                _13733 = _1278;
                                _13734 = _1279;
                              }
                            } else {
                              _13729 = _1274;
                              _13730 = _1275;
                              _13731 = _1276;
                              _13732 = _1277;
                              _13733 = _1278;
                              _13734 = _1279;
                            }
                          } else {
                            _13729 = _1274;
                            _13730 = _1275;
                            _13731 = _1276;
                            _13732 = _1277;
                            _13733 = _1278;
                            _13734 = _1279;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _13729 = _1274;
              _13730 = _1275;
              _13731 = _1276;
              _13732 = _1277;
              _13733 = _1278;
              _13734 = _1279;
            }
          } else {
            _13729 = _1274;
            _13730 = _1275;
            _13731 = _1276;
            _13732 = _1277;
            _13733 = _1278;
            _13734 = _1279;
          }
          _13735 = _1280 + 1;
          if (!(_13735 == (_349 & 255))) {
            _1274 = _13729;
            _1275 = _13730;
            _1276 = _13731;
            _1277 = _13732;
            _1278 = _13733;
            _1279 = _13734;
            _1280 = _13735;
            continue;
          }
          _13739 = _13729;
          _13740 = _13730;
          _13741 = _13731;
          _13742 = _13732;
          _13743 = _13733;
          _13744 = _13734;
          break;
        }
      } else {
        _13739 = _1153;
        _13740 = _1154;
        _13741 = _1155;
        _13742 = _1037;
        _13743 = _1040;
        _13744 = _1043;
      }
      _13746 = rsqrt(dot(float3(_305, _306, -1.0f), float3(_305, _306, -1.0f)));
      _13753 = 1.0f - _217;
      _13764 = (1.0f - _223) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_147, _148, _149), float3((-0.0f - (_305 * _13746)), (-0.0f - (_306 * _13746)), _13746))))) * 5.0f) * (max((_13753 * _13753), _223) - _223));
      _14095 = (((_292 * _113) * select(_191, _13739, (_13764 * _13739))) + _13742);
      _14096 = (((_292 * _114) * select(_191, _13740, (_13764 * _13740))) + _13743);
      _14097 = (((_292 * _115) * select(_191, _13741, (_13764 * _13741))) + _13744);
    } else {
      _13787 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * ((float)((uint)_65))) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
      _13788 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * ((float)((uint)_66))) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
      _13803 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _13788, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _13787)));
      _13806 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _13788, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _13787)));
      _13809 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _13788, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _13787)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _13913 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _13914 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _13915 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _13830 = srvDeferredShadingEvaluateAdaptationPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_13803, _13806, _13809), 0.0f);
        _13834 = _13830.x * 32.0f;
        _13835 = _13830.y * 32.0f;
        _13836 = _13830.z * 32.0f;
        _13838 = rsqrt(dot(float3(_13803, _13806, _13809), float3(_13803, _13806, _13809)));
        _13839 = _13838 * _13803;
        _13840 = _13838 * _13806;
        _13841 = _13838 * _13809;
        _13842 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _13843 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _13844 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _13845 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _13846 = dot(float3(_13839, _13840, _13841), float3(_13843, _13844, _13845));
        _13851 = (_13846 * _13846) - (dot(float3(_13843, _13844, _13845), float3(_13843, _13844, _13845)) - (_13842 * _13842));
        if ((_13846 > -0.0f) && (_13851 > 0.0f)) {
          _13856 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _13869 = 74.80000305175781f / ((dot(float3(_13839, _13840, _13841), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _13842) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _13877 = srvDeferredShadingEvaluateAdaptationPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_13839, _13841), float2(_13856, cbDeferredShading.vSunDirWS.x)) * _13869) + 0.5f), ((dot(float3(_13839, _13840, _13841), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _13856)), (cbDeferredShading.vSunDirWS.y * _13856))) * _13869) + 0.5f)), 0.0f);
          _13879 = _13851 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_13879 > 0.0f) {
            _13886 = saturate(_13879 * 5.0f);
            _13913 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _13877.x) * _13886) + _13834);
            _13914 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _13877.y) * _13886) + _13835);
            _13915 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _13877.z) * _13886) + _13836);
          } else {
            _13913 = _13834;
            _13914 = _13835;
            _13915 = _13836;
          }
        } else {
          _13913 = _13834;
          _13914 = _13835;
          _13915 = _13836;
        }
      }
      _13919 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _13928 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _68.x) - cbSharedPerViewData.vViewRemap.y);
      _13929 = _13928 * _13787;
      _13930 = _13928 * _13788;
      _13931 = -0.0f - _13928;
      _13934 = rsqrt(dot(float3(_13929, _13930, _13931), float3(_13929, _13930, _13931)));
      _13935 = _13934 * _13929;
      _13936 = _13934 * _13930;
      _13937 = _13934 * _13931;
      _13949 = sqrt(((_13930 * _13930) + (_13928 * _13928)) + (_13929 * _13929)) - cbSharedPerViewData.fVolumetricLightingEndDistance;
      _13952 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _13937, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _13936, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _13935)));
      _13953 = _13952 * _13949;
      _13955 = (_13952 * cbSharedPerViewData.fVolumetricLightingEndDistance) + (cbSharedPerViewData.mViewToWorld[2][0].w);
      _13957 = _13955 + _13953;
      if (!(((cbSharedPerViewData.nLightingFeatureFlags & 512) == 0) && (_13957 < 0.0f))) {
        _13964 = max(_13955, cbSharedPerViewData.fGlobalHeightFogFalloffHeight);
        _13966 = max(_13957, cbSharedPerViewData.fGlobalHeightFogFalloffHeight) - _13964;
        _13968 = saturate(_13966 / _13953);
        _13974 = (cbSharedPerViewData.fGlobalHeightFogFalloffScale * _13964) - cbSharedPerViewData.fGlobalHeightFogFalloffHeightScaled;
        _13975 = cbSharedPerViewData.fGlobalHeightFogFalloffScale * _13966;
        _13977 = exp2(-0.0f - _13974);
        if (!(abs(_13975) < 0.009999999776482582f)) {
          _13988 = (((_13977 - exp2(-0.0f - (_13974 + _13975))) * 1.4426950216293335f) / _13975);
        } else {
          _13988 = _13977;
        }
        _13994 = cbSharedPerViewData.vGlobalHeightFogAlbedoAndExtinction.w * ((1.0f - _13968) + (_13988 * _13968));
        _14002 = _13994;
        _14003 = (cbSharedPerViewData.vGlobalHeightFogAlbedoAndExtinction.x * _13994);
        _14004 = (cbSharedPerViewData.vGlobalHeightFogAlbedoAndExtinction.y * _13994);
        _14005 = (cbSharedPerViewData.vGlobalHeightFogAlbedoAndExtinction.z * _13994);
      } else {
        _14002 = 0.0f;
        _14003 = 0.0f;
        _14004 = 0.0f;
        _14005 = 0.0f;
      }
      _14009 = saturate(exp2((_13949 * -1.4426950216293335f) * _14002));
      _14020 = dot(float3(_13935, _13936, _13937), float3(cbSharedPerViewData.vSunDirectionVS.x, cbSharedPerViewData.vSunDirectionVS.y, cbSharedPerViewData.vSunDirectionVS.z));
      _14021 = cbSharedPerViewData.vAtmosphericScatteringParameters2.x * cbSharedPerViewData.vAtmosphericScatteringParameters2.x;
      _14025 = (_14021 + 1.0000100135803223f) - ((cbSharedPerViewData.vAtmosphericScatteringParameters2.x * 2.0f) * _14020);
      _14035 = (((1.0f - _14021) * 0.11936620622873306f) * ((_14020 * _14020) + 1.0f)) / ((sqrt(_14025) * (_14021 + 2.0f)) * _14025);
      _14038 = ((0.07957746833562851f - _14035) * cbSharedPerViewData.vAtmosphericScatteringParameters2.w) + _14035;
      _14043 = select((_14002 < 9.99999993922529e-09f), _13949, ((1.0f / _14002) * (1.0f - _14009)));
      _14044 = _14043 * cbSharedPerViewData.fSunScatteringIntensity;
      _14051 = _14043 * 0.07957746833562851f;
      if (!(cbSharedPerViewData.nOutsideBoxReflectionFallbackId == -1)) {
        _14062 = srvBoxReflectionSH[cbSharedPerViewData.nOutsideBoxReflectionFallbackId].x;
        _14063 = srvBoxReflectionSH[cbSharedPerViewData.nOutsideBoxReflectionFallbackId].y;
        _14064 = srvBoxReflectionSH[cbSharedPerViewData.nOutsideBoxReflectionFallbackId].z;
        _14073 = (cbSharedPerViewData.vOutsideBoxReflectionFallbackModifier.x * _14062);
        _14074 = (cbSharedPerViewData.vOutsideBoxReflectionFallbackModifier.y * _14063);
        _14075 = (cbSharedPerViewData.vOutsideBoxReflectionFallbackModifier.z * _14064);
      } else {
        _14073 = 0.0f;
        _14074 = 0.0f;
        _14075 = 0.0f;
      }
      _14095 = (((((_14073 + cbSharedPerViewData.vVolumetricLightingHeightFogEmissive.x) * _14051) + ((_14038 * cbSharedPerViewData.vAttenuatedSunColor.x) * _14044)) * _14003) + (_14009 * select(_13919, 0.0f, _13913)));
      _14096 = (((((_14074 + cbSharedPerViewData.vVolumetricLightingHeightFogEmissive.y) * _14051) + ((_14038 * cbSharedPerViewData.vAttenuatedSunColor.y) * _14044)) * _14004) + (_14009 * select(_13919, 0.0f, _13914)));
      _14097 = (((((_14075 + cbSharedPerViewData.vVolumetricLightingHeightFogEmissive.z) * _14051) + ((_14038 * cbSharedPerViewData.vAttenuatedSunColor.z) * _14044)) * _14005) + (_14009 * select(_13919, 0.0f, _13915)));
    }
    _14104 = max(dot(float3((cbSharedPerViewData.vHDRScale.y * _14095), (cbSharedPerViewData.vHDRScale.y * _14096), (cbSharedPerViewData.vHDRScale.y * _14097)), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), 0.0f);
    uavDeferredShadingEvaluateAdaptationPass_Luminance[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3(_14104, _14104, _14104);
  }
}