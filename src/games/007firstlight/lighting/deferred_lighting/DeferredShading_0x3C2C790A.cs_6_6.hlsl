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

Texture2DArray<uint> srvGIProbeIrradianceOct : register(t33);

Texture2DArray<float> srvGIProbeDepthOct : register(t114);

Texture3D<float4> srvGIProbeBakeOffsets : register(t115);

Texture3D<uint> srvGIProbeClipMapFlags : register(t34);

Texture3D<float4> srvGIProbeClipMapRoomIDs : register(t32);

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

Texture2D<float> srvDeferredShadingPass_SSGIOcclusion : register(t5);

Texture2D<float> srvDeferredShadingPass_HalfResDepth : register(t6);

RWTexture2D<float3> uavDeferredShadingPass_Specular : register(u0);

RWTexture2D<float3> uavDeferredShadingPass_Diffuse : register(u1);

cbuffer cbBindless : register(b0, space2) {
  SMaterialBindlessOffset cbBindless : packoffset(c000.x);
};

cbuffer _cbSharedPerViewData : register(b2) {
  float4 _cbSharedPerViewData_raw[187] : packoffset(c0);
  uint4 _cbSharedPerViewData_raw_uint[187] : packoffset(c0);
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
  uint _69;
  int _75;
  uint _80;
  uint _81;
  uint _88;
  int _91;
  int _106;
  int _364;
  float _365;
  float _366;
  float _367;
  float _368;
  float _369;
  float _370;
  float _371;
  float _372;
  float _373;
  float _374;
  float _375;
  float _376;
  float _377;
  float _378;
  float _493;
  float _494;
  float _495;
  float _582;
  float _583;
  float _584;
  float _602;
  float _603;
  float _604;
  float _636;
  float _637;
  float _638;
  float _639;
  float _640;
  float _641;
  float _642;
  float _656;
  float _657;
  float _658;
  float _659;
  float _660;
  float _661;
  float _662;
  float _663;
  float _664;
  float _665;
  float _666;
  float _667;
  float _668;
  float _669;
  float _674;
  float _675;
  float _676;
  float _677;
  float _678;
  float _679;
  float _680;
  float _681;
  float _682;
  float _683;
  float _684;
  float _685;
  float _686;
  float _687;
  float _736;
  float _737;
  float _738;
  float _758;
  float _759;
  float _760;
  float _771;
  float _772;
  float _773;
  float _774;
  float _775;
  float _776;
  float _779;
  float _780;
  float _781;
  float _782;
  float _783;
  float _784;
  float _785;
  float _799;
  float _800;
  float _801;
  float _802;
  float _803;
  float _804;
  float _833;
  float _834;
  float _835;
  float _855;
  float _856;
  float _857;
  float _868;
  float _869;
  float _870;
  float _871;
  float _872;
  float _873;
  float _892;
  float _893;
  float _894;
  float _895;
  float _896;
  float _897;
  float _976;
  float _977;
  float _978;
  float _979;
  int _980;
  float _1056;
  float _1057;
  float _1058;
  float _1093;
  float _1094;
  float _1095;
  float _1096;
  int _1097;
  int _1098;
  float _1226;
  float _1227;
  int _1305;
  int _1306;
  int _1307;
  int _1308;
  int _1309;
  int _1310;
  int _1311;
  int _1312;
  float _1368;
  float _1395;
  float _1417;
  float _1418;
  int _1496;
  int _1497;
  int _1498;
  int _1499;
  int _1500;
  int _1501;
  int _1502;
  int _1503;
  float _1669;
  float _1670;
  float _1671;
  float _1713;
  float _1721;
  float _1722;
  float _1723;
  float _1733;
  float _1734;
  float _1735;
  float _1736;
  int _1737;
  float _1763;
  float _1764;
  float _1765;
  float _1773;
  float _1774;
  float _1775;
  float _1782;
  float _1783;
  float _1784;
  float _1785;
  float _1789;
  float _1790;
  float _1791;
  float _1792;
  float _1794;
  float _1795;
  float _1796;
  float _1797;
  float _1805;
  float _1806;
  float _1807;
  float _1824;
  float _1825;
  float _1826;
  float _1827;
  float _1828;
  float _1829;
  int _1859;
  float _1860;
  float _1978;
  float _1983;
  float _1998;
  float _2014;
  float _2067;
  float _2068;
  float _2069;
  float _2122;
  float _2123;
  float _2124;
  float _2234;
  float _2239;
  float _2240;
  float _2241;
  float _2242;
  float _2243;
  float _2244;
  int _2245;
  float _2865;
  float _2866;
  float _2867;
  float _2957;
  float _2966;
  float _2975;
  float _2983;
  float _3054;
  float _3063;
  float _3072;
  float _3080;
  float _3153;
  float _3162;
  float _3171;
  float _3179;
  float _3252;
  float _3261;
  float _3270;
  float _3278;
  float _3330;
  float _3335;
  float _3432;
  float _3453;
  float _3454;
  float _3455;
  int _3474;
  float _3491;
  float _3495;
  float _3534;
  float _3566;
  float _3676;
  float _3677;
  float _3689;
  float _3701;
  float _3831;
  float _3832;
  float _3841;
  float _3853;
  float _3919;
  float _4010;
  float _4011;
  float _4012;
  float _4041;
  float _4151;
  float _4152;
  float _4164;
  float _4176;
  float _4306;
  float _4307;
  float _4316;
  float _4328;
  float _4391;
  float _4392;
  float _4393;
  float _4424;
  float _4453;
  float _4454;
  float _4455;
  float _4471;
  float _4472;
  float _4473;
  float _4486;
  float _4487;
  float _4488;
  float _4651;
  float _4652;
  float _4653;
  float _4654;
  float _4655;
  float _4656;
  float _4748;
  float _4749;
  float _4750;
  float _4751;
  float _4752;
  float _4855;
  float _4864;
  float _4873;
  float _4881;
  float _4952;
  float _4961;
  float _4970;
  float _4978;
  float _5051;
  float _5060;
  float _5069;
  float _5077;
  float _5150;
  float _5159;
  float _5168;
  float _5176;
  int _5511;
  float _5512;
  float _5513;
  float _5542;
  float _5543;
  float _5544;
  float _5545;
  float _5546;
  float _5648;
  float _5657;
  float _5666;
  float _5674;
  float _5745;
  float _5754;
  float _5763;
  float _5771;
  float _5844;
  float _5853;
  float _5862;
  float _5870;
  float _5943;
  float _5952;
  float _5961;
  float _5969;
  bool _6303;
  float _6304;
  float _6305;
  float _6320;
  float _6321;
  float _6322;
  float _6380;
  float _6381;
  float _6406;
  float _6407;
  float _6502;
  float _6505;
  float _6506;
  float _6526;
  float _6527;
  float _6528;
  int _6546;
  float _6563;
  float _6567;
  float _6594;
  float _6595;
  float _6596;
  float _6627;
  float _6656;
  float _6657;
  float _6658;
  float _6674;
  float _6675;
  float _6676;
  float _6712;
  float _6760;
  float _6761;
  float _6762;
  float _6778;
  float _6838;
  float _6839;
  float _6840;
  float _6961;
  float _6962;
  float _6975;
  float _6987;
  float _6988;
  float _7008;
  float _7139;
  float _7140;
  float _7149;
  float _7161;
  float _7162;
  float _7181;
  float _7362;
  float _7965;
  float _7966;
  float _7967;
  float _8057;
  float _8066;
  float _8075;
  float _8083;
  float _8154;
  float _8163;
  float _8172;
  float _8180;
  float _8253;
  float _8262;
  float _8271;
  float _8279;
  float _8352;
  float _8361;
  float _8370;
  float _8378;
  float _8430;
  float _8435;
  float _8436;
  float _8533;
  float _8534;
  float _8555;
  float _8556;
  float _8557;
  int _8576;
  float _8593;
  float _8601;
  float _8627;
  float _8628;
  float _8629;
  float _8660;
  float _8689;
  float _8690;
  float _8691;
  float _8707;
  float _8708;
  float _8709;
  float _8745;
  float _8793;
  float _8794;
  float _8795;
  float _8811;
  float _8871;
  float _8872;
  float _8873;
  float _8994;
  float _8995;
  float _9008;
  float _9020;
  float _9021;
  float _9041;
  float _9172;
  float _9173;
  float _9182;
  float _9194;
  float _9195;
  float _9214;
  float _9405;
  float _9406;
  float _9430;
  float _9431;
  float _9456;
  float _9457;
  float _9482;
  float _9483;
  float _9626;
  float _9627;
  float _9628;
  float _9652;
  float _9743;
  float _9744;
  float _9745;
  float _9759;
  float _9760;
  float _9761;
  float _9762;
  float _9763;
  float _9764;
  float _9769;
  float _9770;
  float _9771;
  float _9772;
  float _9773;
  float _9774;
  float _9829;
  float _9830;
  float _9831;
  float _9832;
  float _9931;
  float _9932;
  float _9947;
  int _9987;
  float _9988;
  float _9989;
  float _9990;
  int _10093;
  float _10094;
  float _10095;
  float _10096;
  float _10097;
  float _10098;
  float _10099;
  float _10100;
  float _10101;
  float _10102;
  float _10103;
  float _10104;
  float _10105;
  float _10106;
  float _10107;
  float _10222;
  float _10223;
  float _10224;
  float _10311;
  float _10312;
  float _10313;
  float _10331;
  float _10332;
  float _10333;
  float _10365;
  float _10366;
  float _10367;
  float _10368;
  float _10369;
  float _10370;
  float _10371;
  float _10385;
  float _10386;
  float _10387;
  float _10388;
  float _10389;
  float _10390;
  float _10391;
  float _10392;
  float _10393;
  float _10394;
  float _10395;
  float _10396;
  float _10397;
  float _10398;
  float _10403;
  float _10404;
  float _10405;
  float _10406;
  float _10407;
  float _10408;
  float _10409;
  float _10410;
  float _10411;
  float _10412;
  float _10413;
  float _10414;
  float _10415;
  float _10416;
  float _10465;
  float _10466;
  float _10467;
  float _10487;
  float _10488;
  float _10489;
  float _10500;
  float _10501;
  float _10502;
  float _10503;
  float _10504;
  float _10505;
  float _10508;
  float _10509;
  float _10510;
  float _10511;
  float _10512;
  float _10513;
  float _10514;
  float _10528;
  float _10529;
  float _10530;
  float _10531;
  float _10532;
  float _10533;
  float _10562;
  float _10563;
  float _10564;
  float _10584;
  float _10585;
  float _10586;
  float _10597;
  float _10598;
  float _10599;
  float _10600;
  float _10601;
  float _10602;
  float _10621;
  float _10622;
  float _10623;
  float _10624;
  float _10625;
  float _10626;
  float _10705;
  float _10706;
  float _10707;
  float _10708;
  int _10709;
  float _10785;
  float _10786;
  float _10787;
  float _10822;
  float _10823;
  float _10824;
  float _10825;
  int _10826;
  int _10827;
  float _10955;
  float _10956;
  int _11034;
  int _11035;
  int _11036;
  int _11037;
  int _11038;
  int _11039;
  int _11040;
  int _11041;
  float _11097;
  float _11124;
  float _11146;
  float _11147;
  int _11225;
  int _11226;
  int _11227;
  int _11228;
  int _11229;
  int _11230;
  int _11231;
  int _11232;
  float _11398;
  float _11399;
  float _11400;
  float _11442;
  float _11450;
  float _11451;
  float _11452;
  float _11462;
  float _11463;
  float _11464;
  float _11465;
  int _11466;
  float _11492;
  float _11493;
  float _11494;
  float _11502;
  float _11503;
  float _11504;
  float _11511;
  float _11512;
  float _11513;
  float _11514;
  float _11518;
  float _11519;
  float _11520;
  float _11521;
  float _11523;
  float _11524;
  float _11525;
  float _11526;
  float _11534;
  float _11535;
  float _11536;
  float _11553;
  float _11554;
  float _11555;
  int _11570;
  float _11571;
  float _11689;
  float _11694;
  float _11710;
  float _11767;
  float _11880;
  int _11883;
  float _11884;
  float _11885;
  float _11886;
  float _12497;
  float _12498;
  float _12499;
  float _12589;
  float _12598;
  float _12607;
  float _12615;
  float _12686;
  float _12695;
  float _12704;
  float _12712;
  float _12785;
  float _12794;
  float _12803;
  float _12811;
  float _12884;
  float _12893;
  float _12902;
  float _12910;
  float _12962;
  float _12967;
  float _13064;
  float _13085;
  float _13086;
  float _13087;
  int _13106;
  float _13123;
  float _13127;
  float _13166;
  float _13196;
  float _13306;
  float _13307;
  float _13319;
  float _13331;
  float _13450;
  float _13451;
  float _13460;
  float _13472;
  float _13521;
  float _13609;
  float _13610;
  float _13611;
  float _13640;
  float _13750;
  float _13751;
  float _13763;
  float _13775;
  float _13894;
  float _13895;
  float _13904;
  float _13916;
  float _13971;
  float _13972;
  float _13973;
  float _14004;
  float _14033;
  float _14034;
  float _14035;
  float _14051;
  float _14052;
  float _14053;
  float _14066;
  float _14067;
  float _14068;
  float _14220;
  float _14221;
  float _14222;
  float _14223;
  float _14224;
  float _14225;
  float _14317;
  float _14318;
  float _14319;
  float _14320;
  float _14321;
  float _14424;
  float _14433;
  float _14442;
  float _14450;
  float _14521;
  float _14530;
  float _14539;
  float _14547;
  float _14620;
  float _14629;
  float _14638;
  float _14646;
  float _14719;
  float _14728;
  float _14737;
  float _14745;
  float _15080;
  float _15081;
  int _15082;
  float _15111;
  float _15112;
  float _15113;
  float _15114;
  float _15115;
  float _15217;
  float _15226;
  float _15235;
  float _15243;
  float _15314;
  float _15323;
  float _15332;
  float _15340;
  float _15413;
  float _15422;
  float _15431;
  float _15439;
  float _15512;
  float _15521;
  float _15530;
  float _15538;
  float _15872;
  float _15873;
  bool _15874;
  float _15889;
  float _15890;
  float _15891;
  float _15949;
  float _15950;
  float _15975;
  float _15976;
  float _16071;
  float _16074;
  float _16075;
  float _16095;
  float _16096;
  float _16097;
  int _16115;
  float _16132;
  float _16136;
  float _16163;
  float _16164;
  float _16165;
  float _16196;
  float _16225;
  float _16226;
  float _16227;
  float _16243;
  float _16244;
  float _16245;
  float _16281;
  float _16327;
  float _16328;
  float _16329;
  float _16345;
  float _16405;
  float _16406;
  float _16407;
  float _16523;
  float _16524;
  float _16536;
  float _16548;
  float _16549;
  float _16569;
  float _16689;
  float _16690;
  float _16699;
  float _16711;
  float _16712;
  float _16731;
  float _16892;
  float _17443;
  float _17444;
  float _17445;
  float _17535;
  float _17544;
  float _17553;
  float _17561;
  float _17632;
  float _17641;
  float _17650;
  float _17658;
  float _17731;
  float _17740;
  float _17749;
  float _17757;
  float _17830;
  float _17839;
  float _17848;
  float _17856;
  float _17908;
  float _17913;
  float _17914;
  float _18011;
  float _18012;
  float _18033;
  float _18034;
  float _18035;
  int _18054;
  float _18071;
  float _18079;
  float _18105;
  float _18106;
  float _18107;
  float _18138;
  float _18167;
  float _18168;
  float _18169;
  float _18185;
  float _18186;
  float _18187;
  float _18223;
  float _18269;
  float _18270;
  float _18271;
  float _18287;
  float _18347;
  float _18348;
  float _18349;
  float _18465;
  float _18466;
  float _18478;
  float _18490;
  float _18491;
  float _18511;
  float _18631;
  float _18632;
  float _18641;
  float _18653;
  float _18654;
  float _18673;
  float _18847;
  float _18848;
  float _18872;
  float _18873;
  float _18898;
  float _18899;
  float _18924;
  float _18925;
  float _19068;
  float _19069;
  float _19070;
  float _19167;
  float _19168;
  float _19169;
  float _19174;
  float _19175;
  float _19176;
  float _19317;
  float _19318;
  float _19319;
  float _19328;
  float _19329;
  float _19330;
  float _19331;
  float _19332;
  float _19333;
  float _19334;
  float _19335;
  float _19336;
  int _102;
  uint _108;
  int _115;
  int _120;
  int _123;
  int _125;
  int _127;
  int _129;
  float4 _134;
  float _142;
  float _143;
  float _151;
  float _152;
  float4 _155;
  float4 _159;
  float4 _165;
  float4 _169;
  float _176;
  float _177;
  float _178;
  float _181;
  float _183;
  float _188;
  float _189;
  float _193;
  float _195;
  float _196;
  float _201;
  float _202;
  float _204;
  float _205;
  float _206;
  float _207;
  float _208;
  float _209;
  float _210;
  bool _217;
  float _219;
  float _220;
  float _227;
  float _228;
  float _229;
  float _231;
  float _233;
  float _234;
  float _237;
  float _243;
  float _244;
  float _245;
  float _246;
  bool _248;
  float _249;
  float _253;
  float _254;
  float _256;
  float _257;
  float _258;
  int _266;
  int _267;
  int _268;
  int _269;
  float _273;
  float _275;
  float _276;
  float _286;
  float _291;
  float _295;
  float _296;
  float _299;
  float _309;
  float _310;
  float _311;
  float _315;
  float _330;
  float _333;
  float _336;
  float _339;
  float _342;
  float _345;
  int _381;
  int _382;
  float _385;
  float _386;
  float _387;
  float _388;
  float _391;
  float _392;
  float _393;
  float _394;
  float _397;
  float _398;
  float _399;
  float _400;
  float _403;
  float _404;
  float _405;
  float _406;
  float _409;
  float _410;
  float _411;
  float _412;
  float _415;
  float _416;
  float _417;
  float _418;
  int _421;
  float _424;
  float _425;
  float _426;
  float _429;
  float _430;
  float _431;
  int _434;
  int _437;
  int _440;
  float _469;
  float _472;
  float _475;
  float _476;
  float4 _482;
  float4 _488;
  float _497;
  float _501;
  float _504;
  float _507;
  float _548;
  float _553;
  float _555;
  float _557;
  float _564;
  float _565;
  float4 _571;
  float4 _577;
  float _585;
  float4 _591;
  float4 _597;
  float _614;
  float _615;
  float _616;
  float _617;
  float _618;
  float _619;
  float _620;
  float _621;
  float _622;
  uint _670;
  bool _693;
  int _703;
  float _705;
  float _706;
  float _713;
  float _718;
  float _719;
  bool _720;
  float4 _725;
  float4 _731;
  float _742;
  float4 _747;
  float4 _753;
  float _791;
  int _811;
  float _812;
  float _815;
  float _816;
  bool _817;
  float4 _822;
  float4 _828;
  float _839;
  float4 _844;
  float4 _850;
  float _878;
  float _924;
  float _928;
  float _932;
  float _935;
  float _938;
  float _941;
  int4 _946;
  int4 _961;
  float4 _990;
  float4 _995;
  float4 _1000;
  float _1027;
  float _1048;
  float _1069;
  int _1073;
  float4 _1074;
  float _1078;
  float _1079;
  float _1080;
  int _1099;
  int _1101;
  int _1103;
  uint _1107;
  uint _1108;
  uint _1109;
  int _1117;
  int _1118;
  uint _1121;
  uint _1127;
  float _1138;
  float4 _1144;
  float _1161;
  float _1175;
  float4 _1177;
  float _1187;
  float _1188;
  float _1189;
  float _1194;
  float _1195;
  float _1197;
  float _1198;
  float _1199;
  float _1201;
  float _1202;
  float _1203;
  float _1204;
  float _1209;
  float _1210;
  float _1211;
  float _1232;
  float _1233;
  int _1234;
  bool _1235;
  float _1242;
  float _1243;
  float _1244;
  float _1245;
  int _1250;
  int _1251;
  uint _1252;
  uint _1253;
  bool _1260;
  bool _1265;
  uint _1266;
  uint _1268;
  bool _1278;
  uint _1279;
  bool _1290;
  uint _1292;
  float _1320;
  float _1328;
  float _1336;
  float _1344;
  float _1356;
  float _1360;
  float _1370;
  float _1371;
  float _1372;
  float _1373;
  float _1382;
  float _1385;
  float _1392;
  float _1400;
  float _1401;
  float _1402;
  float _1423;
  float _1424;
  int _1425;
  bool _1426;
  float _1433;
  float _1434;
  float _1435;
  float _1436;
  int _1441;
  int _1442;
  uint _1443;
  uint _1444;
  bool _1451;
  bool _1456;
  uint _1457;
  uint _1459;
  bool _1469;
  uint _1470;
  bool _1481;
  uint _1483;
  uint _1511;
  float _1521;
  float _1522;
  float _1523;
  float _1527;
  float _1529;
  float _1531;
  float _1533;
  uint _1540;
  float _1550;
  float _1551;
  float _1552;
  float _1556;
  float _1558;
  float _1560;
  float _1562;
  uint _1569;
  float _1579;
  float _1580;
  float _1581;
  float _1585;
  float _1587;
  float _1589;
  float _1591;
  uint _1598;
  float _1608;
  float _1609;
  float _1610;
  float _1614;
  float _1616;
  float _1618;
  float _1620;
  float _1639;
  float _1640;
  float _1647;
  float _1648;
  float _1649;
  float _1674;
  float _1675;
  float _1676;
  float _1687;
  float _1695;
  float _1699;
  float _1700;
  float _1701;
  float _1703;
  int _1738;
  float _1749;
  float _1750;
  float _1751;
  bool _1754;
  float _1779;
  int _1786;
  float _1831;
  float4 _1834;
  float _1837;
  float _1838;
  float _1842;
  float _1855;
  bool _1856;
  uint _1861;
  int _1864;
  int _1865;
  int _1869;
  int _1873;
  float _1885;
  float _1890;
  float _1891;
  float _1892;
  float _1893;
  float _1896;
  float _1897;
  float _1898;
  float _1899;
  float _1902;
  float _1903;
  float _1904;
  float _1905;
  int _1908;
  int _1911;
  int _1914;
  int _1917;
  float _1932;
  float _1936;
  float _1940;
  float _1965;
  float _1966;
  float _1967;
  float _1970;
  uint _1979;
  float _2001;
  float _2004;
  float _2007;
  int _2017;
  int _2020;
  int _2021;
  int _2022;
  int _2028;
  int _2029;
  int _2030;
  int _2036;
  int _2037;
  int _2038;
  float _2044;
  float _2048;
  float _2052;
  float _2059;
  int _2072;
  int _2075;
  int _2076;
  int _2077;
  int _2083;
  int _2084;
  int _2085;
  int _2091;
  int _2092;
  int _2093;
  float _2099;
  float _2103;
  float _2107;
  float _2114;
  float _2147;
  float _2151;
  float _2155;
  float _2174;
  float _2178;
  float _2182;
  float _2195;
  float _2196;
  float _2197;
  uint _2235;
  bool _2236;
  int _2247;
  int _2251;
  int _2252;
  int _2253;
  int _2254;
  int _2265;
  int _2269;
  float _2281;
  int _2284;
  float _2301;
  float _2306;
  float _2307;
  float _2308;
  float _2309;
  float _2312;
  float _2313;
  float _2314;
  float _2315;
  float _2318;
  float _2319;
  float _2320;
  float _2321;
  int _2324;
  int _2327;
  int _2330;
  int _2333;
  int _2336;
  float _2338;
  float _2339;
  float _2341;
  float _2345;
  float _2358;
  float _2362;
  float _2366;
  float _2391;
  float _2392;
  float _2393;
  float _2396;
  float _2397;
  float _2404;
  float _2425;
  float _2426;
  float _2427;
  float _2428;
  float _2431;
  float _2432;
  float _2433;
  float _2434;
  float _2437;
  float _2438;
  float _2439;
  float _2440;
  float _2443;
  float _2444;
  float _2445;
  float _2448;
  int _2451;
  int _2454;
  int _2457;
  int _2460;
  int _2463;
  float _2466;
  float _2467;
  float _2468;
  float _2469;
  int _2472;
  int _2475;
  int _2478;
  int _2481;
  int _2484;
  int _2487;
  int _2490;
  int _2493;
  float _2495;
  float _2496;
  float _2498;
  float _2502;
  float _2505;
  float _2507;
  int _2510;
  float _2520;
  float _2521;
  float _2523;
  float _2524;
  float _2525;
  float _2526;
  float _2545;
  float _2549;
  float _2550;
  float _2551;
  float _2555;
  float _2559;
  float _2563;
  float _2564;
  float _2587;
  float _2588;
  float _2589;
  float _2592;
  float _2593;
  float _2600;
  float _2601;
  float _2602;
  float _2607;
  float _2609;
  float _2610;
  float _2613;
  float _2617;
  float _2626;
  float _2627;
  float _2628;
  int _2629;
  float _2634;
  float _2643;
  float _2644;
  float _2646;
  float4 _2651;
  float _2656;
  float _2658;
  float _2660;
  float _2662;
  float _2666;
  float _2668;
  float _2672;
  float _2674;
  int _2681;
  float _2686;
  float _2695;
  float _2696;
  float4 _2702;
  float _2707;
  float _2709;
  float _2713;
  float _2715;
  float _2719;
  float _2721;
  float _2725;
  float _2727;
  int _2734;
  float _2739;
  float _2748;
  float _2749;
  float4 _2755;
  float _2760;
  float _2762;
  float _2766;
  float _2768;
  float _2772;
  float _2774;
  float _2778;
  float _2780;
  int _2787;
  float _2792;
  float _2801;
  float _2802;
  float4 _2808;
  float _2813;
  float _2815;
  float _2819;
  float _2821;
  float _2825;
  float _2827;
  float _2831;
  float _2833;
  float _2834;
  float _2845;
  float _2851;
  float _2853;
  float _2855;
  float _2862;
  float _2870;
  float _2871;
  float _2880;
  float _2884;
  float _2893;
  float _2894;
  float _2895;
  float _2900;
  int _2901;
  float _2906;
  float _2915;
  float _2916;
  float _2918;
  float _2920;
  float _2921;
  float4 _2923;
  float _2927;
  float _2928;
  float _2931;
  float _2932;
  float _2937;
  float _2938;
  float _2941;
  float _2942;
  float _2944;
  float _2946;
  bool _2947;
  bool _2948;
  bool _2958;
  bool _2967;
  float _2984;
  float _2986;
  float _2988;
  float _2990;
  float _2994;
  float _2996;
  float _3000;
  float _3002;
  int _3009;
  float _3014;
  float _3023;
  float _3024;
  float _3027;
  float _3028;
  float4 _3030;
  float _3034;
  float _3035;
  float _3038;
  float _3039;
  float _3041;
  float _3043;
  bool _3044;
  bool _3045;
  bool _3055;
  bool _3064;
  float _3081;
  float _3083;
  float _3087;
  float _3089;
  float _3093;
  float _3095;
  float _3099;
  float _3101;
  int _3108;
  float _3113;
  float _3122;
  float _3123;
  float _3126;
  float _3127;
  float4 _3129;
  float _3133;
  float _3134;
  float _3137;
  float _3138;
  float _3140;
  float _3142;
  bool _3143;
  bool _3144;
  bool _3154;
  bool _3163;
  float _3180;
  float _3182;
  float _3186;
  float _3188;
  float _3192;
  float _3194;
  float _3198;
  float _3200;
  int _3207;
  float _3212;
  float _3221;
  float _3222;
  float _3225;
  float _3226;
  float4 _3228;
  float _3232;
  float _3233;
  float _3236;
  float _3237;
  float _3239;
  float _3241;
  bool _3242;
  bool _3243;
  bool _3253;
  bool _3262;
  float _3279;
  float _3281;
  float _3285;
  float _3287;
  float _3291;
  float _3293;
  float _3297;
  float _3299;
  float _3300;
  float _3311;
  float _3317;
  float _3319;
  float _3321;
  float _3341;
  float4 _3348;
  float _3362;
  float _3363;
  float _3364;
  float _3365;
  float _3367;
  float _3372;
  float _3375;
  float _3376;
  float _3378;
  float _3379;
  float _3384;
  float _3389;
  float _3391;
  float _3394;
  float _3395;
  float _3400;
  float _3402;
  float _3404;
  float _3406;
  float _3411;
  float _3417;
  float _3419;
  float3 _3445;
  float _3456;
  float4 _3477;
  int _3505;
  int _3510;
  int _3512;
  int _3513;
  int _3515;
  int _3516;
  int _3525;
  bool _3538;
  float _3541;
  float _3543;
  float _3544;
  float _3545;
  float _3546;
  float _3547;
  float _3548;
  float _3556;
  float _3561;
  float _3567;
  float _3568;
  float _3571;
  float _3573;
  float _3574;
  float _3575;
  float _3578;
  float _3581;
  float _3584;
  bool _3585;
  float _3589;
  float _3591;
  float _3592;
  float _3600;
  float _3603;
  float _3604;
  float _3609;
  float _3618;
  float _3619;
  float _3622;
  float _3624;
  float _3625;
  float _3626;
  float _3628;
  float _3629;
  float _3630;
  float _3631;
  float _3636;
  float _3650;
  float _3655;
  float _3656;
  float _3658;
  float _3664;
  float _3667;
  float _3678;
  float _3679;
  bool _3680;
  float _3690;
  float _3705;
  float _3715;
  float _3722;
  float _3724;
  float _3725;
  float _3734;
  float _3735;
  float _3741;
  bool _3742;
  float _3746;
  float _3748;
  float _3749;
  float _3755;
  float _3758;
  float _3759;
  float _3764;
  float _3773;
  float _3774;
  float _3777;
  float _3779;
  float _3780;
  float _3781;
  float _3783;
  float _3784;
  float _3785;
  float _3786;
  float _3791;
  float _3805;
  float _3810;
  float _3811;
  float _3813;
  float _3819;
  float _3822;
  float _3842;
  float _3857;
  float _3858;
  float _3862;
  float _3865;
  float _3866;
  float _3867;
  float _3868;
  float _3875;
  float _3876;
  float _3877;
  float _3901;
  float _3908;
  float _3922;
  float _3923;
  float _3924;
  float _3925;
  float _3928;
  float _3929;
  float _3930;
  float _3931;
  float _3934;
  float _3935;
  float _3936;
  int _3939;
  int _3942;
  int _3945;
  int _3948;
  int _3951;
  int _3954;
  float _3957;
  float _3961;
  float _3963;
  int _3965;
  float2 _3985;
  float3 _4002;
  float _4015;
  float _4018;
  float _4019;
  float _4020;
  float _4021;
  float _4022;
  float _4023;
  float _4031;
  float _4036;
  float _4042;
  float _4043;
  float _4046;
  float _4048;
  float _4049;
  float _4050;
  float _4053;
  float _4056;
  float _4059;
  bool _4060;
  float _4064;
  float _4066;
  float _4067;
  float _4075;
  float _4078;
  float _4079;
  float _4084;
  float _4093;
  float _4094;
  float _4097;
  float _4099;
  float _4100;
  float _4101;
  float _4103;
  float _4104;
  float _4105;
  float _4106;
  float _4111;
  float _4125;
  float _4130;
  float _4131;
  float _4133;
  float _4139;
  float _4142;
  float _4153;
  float _4154;
  bool _4155;
  float _4165;
  float _4180;
  float _4190;
  float _4197;
  float _4199;
  float _4200;
  float _4209;
  float _4210;
  float _4216;
  bool _4217;
  float _4221;
  float _4223;
  float _4224;
  float _4230;
  float _4233;
  float _4234;
  float _4239;
  float _4248;
  float _4249;
  float _4252;
  float _4254;
  float _4255;
  float _4256;
  float _4258;
  float _4259;
  float _4260;
  float _4261;
  float _4266;
  float _4280;
  float _4285;
  float _4286;
  float _4288;
  float _4294;
  float _4297;
  float _4317;
  float _4332;
  float _4342;
  float _4355;
  float _4359;
  float _4362;
  float _4381;
  bool _4394;
  float _4395;
  float _4396;
  float _4397;
  bool _4398;
  float _4400;
  float _4401;
  float _4405;
  float _4411;
  float _4425;
  float _4426;
  float _4429;
  float _4433;
  int _4434;
  float _4436;
  float _4438;
  float _4441;
  float _4445;
  float _4456;
  float _4457;
  float _4458;
  float _4460;
  float _4474;
  float _4475;
  float _4476;
  float _4492;
  float _4493;
  float _4494;
  float _4497;
  float _4512;
  float _4513;
  float _4514;
  float _4517;
  float _4518;
  float _4519;
  float _4522;
  float _4523;
  float _4524;
  float _4527;
  float _4528;
  float _4529;
  float _4532;
  float _4533;
  float _4534;
  int _4537;
  int _4540;
  int _4543;
  int _4546;
  int _4549;
  int _4552;
  int _4555;
  int _4558;
  int _4561;
  int _4564;
  int _4567;
  float _4570;
  float _4571;
  float _4572;
  float _4573;
  int _4576;
  int _4579;
  int _4582;
  int _4585;
  float _4587;
  float _4588;
  float _4590;
  float _4594;
  float _4597;
  float _4598;
  float _4600;
  float _4604;
  float _4606;
  float _4607;
  float _4609;
  int _4612;
  bool _4616;
  float _4624;
  float _4625;
  float _4627;
  float _4630;
  float _4631;
  float _4633;
  float _4634;
  float _4636;
  float _4637;
  float _4641;
  float _4647;
  float _4648;
  float _4649;
  float _4660;
  float _4661;
  float _4662;
  float _4663;
  float _4664;
  float _4665;
  float _4666;
  float _4667;
  float _4668;
  float _4671;
  float _4672;
  float _4673;
  float _4676;
  float _4683;
  float _4696;
  float _4700;
  float _4704;
  float _4705;
  float _4706;
  float _4709;
  float _4712;
  bool _4714;
  float _4720;
  float _4721;
  float _4722;
  float _4727;
  float _4728;
  float _4729;
  bool _4733;
  bool _4739;
  bool _4743;
  float _4753;
  float _4757;
  float _4766;
  float _4767;
  float _4774;
  float _4775;
  float _4778;
  float _4782;
  float _4791;
  float _4792;
  float _4793;
  float _4798;
  int _4799;
  float _4804;
  float _4813;
  float _4814;
  float _4816;
  float _4818;
  float _4819;
  float4 _4821;
  float _4825;
  float _4826;
  float _4829;
  float _4830;
  float _4835;
  float _4836;
  float _4839;
  float _4840;
  float _4842;
  float _4844;
  bool _4845;
  bool _4846;
  bool _4856;
  bool _4865;
  float _4882;
  float _4884;
  float _4886;
  float _4888;
  float _4892;
  float _4894;
  float _4898;
  float _4900;
  int _4907;
  float _4912;
  float _4921;
  float _4922;
  float _4925;
  float _4926;
  float4 _4928;
  float _4932;
  float _4933;
  float _4936;
  float _4937;
  float _4939;
  float _4941;
  bool _4942;
  bool _4943;
  bool _4953;
  bool _4962;
  float _4979;
  float _4981;
  float _4985;
  float _4987;
  float _4991;
  float _4993;
  float _4997;
  float _4999;
  int _5006;
  float _5011;
  float _5020;
  float _5021;
  float _5024;
  float _5025;
  float4 _5027;
  float _5031;
  float _5032;
  float _5035;
  float _5036;
  float _5038;
  float _5040;
  bool _5041;
  bool _5042;
  bool _5052;
  bool _5061;
  float _5078;
  float _5080;
  float _5084;
  float _5086;
  float _5090;
  float _5092;
  float _5096;
  float _5098;
  int _5105;
  float _5110;
  float _5119;
  float _5120;
  float _5123;
  float _5124;
  float4 _5126;
  float _5130;
  float _5131;
  float _5134;
  float _5135;
  float _5137;
  float _5139;
  bool _5140;
  bool _5141;
  bool _5151;
  bool _5160;
  float _5177;
  float _5179;
  float _5183;
  float _5185;
  float _5189;
  float _5191;
  float _5195;
  float _5197;
  float _5198;
  float _5209;
  float _5215;
  float _5217;
  float _5219;
  float _5228;
  float _5231;
  float _5232;
  float _5246;
  float _5247;
  float _5248;
  float _5252;
  float _5261;
  float _5262;
  float _5263;
  int _5264;
  float _5269;
  float _5278;
  float _5279;
  float _5281;
  float4 _5286;
  float _5291;
  float _5293;
  float _5295;
  float _5297;
  float _5301;
  float _5303;
  float _5307;
  float _5309;
  int _5316;
  float _5321;
  float _5330;
  float _5331;
  float4 _5337;
  float _5342;
  float _5344;
  float _5348;
  float _5350;
  float _5354;
  float _5356;
  float _5360;
  float _5362;
  int _5369;
  float _5374;
  float _5383;
  float _5384;
  float4 _5390;
  float _5395;
  float _5397;
  float _5401;
  float _5403;
  float _5407;
  float _5409;
  float _5413;
  float _5415;
  int _5422;
  float _5427;
  float _5436;
  float _5437;
  float4 _5443;
  float _5448;
  float _5450;
  float _5454;
  float _5456;
  float _5460;
  float _5462;
  float _5466;
  float _5468;
  float _5469;
  float _5480;
  float _5486;
  float _5488;
  float _5490;
  float _5498;
  float _5505;
  float _5507;
  float _5521;
  float _5522;
  float _5523;
  bool _5527;
  bool _5533;
  bool _5537;
  float _5547;
  float _5552;
  float _5561;
  float _5562;
  float _5567;
  float _5568;
  float _5571;
  float _5575;
  float _5584;
  float _5585;
  float _5586;
  float _5591;
  int _5592;
  float _5597;
  float _5606;
  float _5607;
  float _5609;
  float _5611;
  float _5612;
  float4 _5614;
  float _5618;
  float _5619;
  float _5622;
  float _5623;
  float _5628;
  float _5629;
  float _5632;
  float _5633;
  float _5635;
  float _5637;
  bool _5638;
  bool _5639;
  bool _5649;
  bool _5658;
  float _5675;
  float _5677;
  float _5679;
  float _5681;
  float _5685;
  float _5687;
  float _5691;
  float _5693;
  int _5700;
  float _5705;
  float _5714;
  float _5715;
  float _5718;
  float _5719;
  float4 _5721;
  float _5725;
  float _5726;
  float _5729;
  float _5730;
  float _5732;
  float _5734;
  bool _5735;
  bool _5736;
  bool _5746;
  bool _5755;
  float _5772;
  float _5774;
  float _5778;
  float _5780;
  float _5784;
  float _5786;
  float _5790;
  float _5792;
  int _5799;
  float _5804;
  float _5813;
  float _5814;
  float _5817;
  float _5818;
  float4 _5820;
  float _5824;
  float _5825;
  float _5828;
  float _5829;
  float _5831;
  float _5833;
  bool _5834;
  bool _5835;
  bool _5845;
  bool _5854;
  float _5871;
  float _5873;
  float _5877;
  float _5879;
  float _5883;
  float _5885;
  float _5889;
  float _5891;
  int _5898;
  float _5903;
  float _5912;
  float _5913;
  float _5916;
  float _5917;
  float4 _5919;
  float _5923;
  float _5924;
  float _5927;
  float _5928;
  float _5930;
  float _5932;
  bool _5933;
  bool _5934;
  bool _5944;
  bool _5953;
  float _5970;
  float _5972;
  float _5976;
  float _5978;
  float _5982;
  float _5984;
  float _5988;
  float _5990;
  float _5991;
  float _6002;
  float _6008;
  float _6010;
  float _6012;
  float _6021;
  float _6024;
  float _6025;
  float _6038;
  float _6039;
  float _6040;
  float _6044;
  float _6053;
  float _6054;
  float _6055;
  int _6056;
  float _6061;
  float _6070;
  float _6071;
  float _6073;
  float4 _6078;
  float _6083;
  float _6085;
  float _6087;
  float _6089;
  float _6093;
  float _6095;
  float _6099;
  float _6101;
  int _6108;
  float _6113;
  float _6122;
  float _6123;
  float4 _6129;
  float _6134;
  float _6136;
  float _6140;
  float _6142;
  float _6146;
  float _6148;
  float _6152;
  float _6154;
  int _6161;
  float _6166;
  float _6175;
  float _6176;
  float4 _6182;
  float _6187;
  float _6189;
  float _6193;
  float _6195;
  float _6199;
  float _6201;
  float _6205;
  float _6207;
  int _6214;
  float _6219;
  float _6228;
  float _6229;
  float4 _6235;
  float _6240;
  float _6242;
  float _6246;
  float _6248;
  float _6252;
  float _6254;
  float _6258;
  float _6260;
  float _6261;
  float _6272;
  float _6278;
  float _6280;
  float _6282;
  float _6290;
  float _6297;
  float _6299;
  float _6325;
  float _6327;
  float _6328;
  float _6329;
  float _6344;
  float _6347;
  float _6350;
  float _6352;
  float _6353;
  float _6354;
  float _6355;
  float _6363;
  float _6364;
  float _6365;
  bool _6367;
  float _6387;
  float4 _6412;
  float _6432;
  float _6433;
  float _6434;
  float _6435;
  float _6437;
  float _6442;
  float _6445;
  float _6446;
  float _6448;
  float _6449;
  float _6454;
  float _6459;
  float _6461;
  float _6464;
  float _6465;
  float _6470;
  float _6472;
  float _6474;
  float _6476;
  float _6481;
  float _6487;
  float _6489;
  float3 _6518;
  float4 _6549;
  float _6584;
  bool _6597;
  float _6598;
  float _6599;
  float _6600;
  bool _6601;
  float _6603;
  float _6604;
  float _6608;
  float _6614;
  float _6628;
  float _6629;
  float _6632;
  float _6636;
  int _6637;
  float _6639;
  float _6641;
  float _6644;
  float _6648;
  float _6659;
  float _6660;
  float _6661;
  float _6663;
  int _6683;
  int _6688;
  int _6690;
  int _6691;
  int _6693;
  int _6694;
  int _6703;
  bool _6716;
  float _6719;
  float _6721;
  float _6722;
  float _6723;
  float _6724;
  float _6725;
  float _6726;
  float _6727;
  float _6728;
  float _6729;
  float _6730;
  float _6731;
  float _6732;
  bool _6733;
  float _6734;
  float _6735;
  float _6738;
  float _6739;
  float _6741;
  float _6768;
  float _6773;
  float _6780;
  float _6781;
  float _6782;
  float _6784;
  float _6788;
  float _6789;
  float _6790;
  float _6791;
  float _6792;
  float _6793;
  float _6794;
  float _6800;
  float _6809;
  float _6813;
  float _6814;
  float _6815;
  float _6816;
  float _6820;
  float _6821;
  float _6822;
  float _6830;
  float _6842;
  float _6843;
  float _6844;
  float _6845;
  float _6846;
  float _6847;
  float _6850;
  float _6852;
  float _6854;
  float _6858;
  float _6859;
  float _6860;
  float _6863;
  float _6866;
  float _6869;
  bool _6870;
  float _6874;
  float _6876;
  float _6877;
  float _6885;
  float _6888;
  float _6889;
  float _6894;
  float _6903;
  float _6904;
  float _6907;
  float _6909;
  float _6910;
  float _6911;
  float _6913;
  float _6914;
  float _6915;
  float _6916;
  float _6921;
  float _6935;
  float _6940;
  float _6941;
  float _6943;
  float _6949;
  float _6952;
  float _6963;
  float _6965;
  bool _6966;
  float _6984;
  bool _6989;
  float _6995;
  float _7012;
  float _7022;
  float _7029;
  float _7031;
  float _7032;
  float _7033;
  float _7042;
  float _7043;
  float _7049;
  bool _7050;
  float _7054;
  float _7056;
  float _7057;
  float _7063;
  float _7066;
  float _7067;
  float _7072;
  float _7081;
  float _7082;
  float _7085;
  float _7087;
  float _7088;
  float _7089;
  float _7091;
  float _7092;
  float _7093;
  float _7094;
  float _7099;
  float _7113;
  float _7118;
  float _7119;
  float _7121;
  float _7127;
  float _7130;
  float _7158;
  float _7168;
  float _7185;
  float _7186;
  float _7187;
  float _7191;
  float _7194;
  float _7195;
  float _7196;
  float _7197;
  float _7204;
  float _7205;
  float _7206;
  float _7231;
  float _7238;
  float _7253;
  float _7254;
  float _7255;
  float _7258;
  float _7259;
  float _7260;
  float _7263;
  int _7266;
  int _7269;
  int _7272;
  float _7281;
  float _7284;
  float _7287;
  float _7294;
  float _7299;
  float _7301;
  float _7303;
  float _7304;
  float _7305;
  float _7307;
  float _7308;
  float _7309;
  float _7312;
  float _7313;
  float _7314;
  float _7317;
  float _7324;
  int _7333;
  int _7338;
  int _7340;
  int _7341;
  int _7343;
  int _7344;
  int _7353;
  bool _7366;
  float _7368;
  float _7369;
  float _7370;
  float _7371;
  float _7374;
  float _7377;
  float _7381;
  float _7382;
  float _7383;
  float _7387;
  float _7394;
  float _7397;
  float _7398;
  float _7399;
  float _7408;
  float _7409;
  float _7413;
  float _7414;
  float _7415;
  float _7419;
  float _7421;
  float _7422;
  float _7423;
  float _7424;
  float _7431;
  float _7432;
  float _7433;
  float _7455;
  float _7470;
  float _7485;
  float _7486;
  float _7487;
  float _7490;
  float _7491;
  float _7492;
  float _7495;
  float _7496;
  float _7497;
  float _7500;
  float _7501;
  float _7502;
  float _7505;
  float _7506;
  float _7507;
  float _7510;
  float _7511;
  float _7512;
  int _7515;
  int _7518;
  int _7521;
  int _7524;
  float _7527;
  float _7528;
  float _7529;
  float _7530;
  int _7533;
  int _7536;
  int _7539;
  int _7542;
  int _7545;
  int _7548;
  int _7551;
  float _7554;
  float _7555;
  float _7556;
  float _7557;
  int _7560;
  int _7563;
  int _7566;
  float _7568;
  float _7569;
  float _7571;
  float _7575;
  float _7578;
  float _7579;
  float _7581;
  float _7585;
  int _7589;
  float _7605;
  float _7606;
  float _7608;
  float _7609;
  float _7610;
  float _7611;
  float _7612;
  float _7613;
  float _7614;
  float _7615;
  float _7616;
  float _7617;
  float _7618;
  float _7619;
  float _7620;
  float _7623;
  float _7624;
  float _7625;
  float _7628;
  float _7639;
  float _7643;
  float _7650;
  float _7651;
  float _7652;
  float _7664;
  float _7665;
  float _7666;
  float _7667;
  float _7670;
  float _7671;
  float _7674;
  float _7675;
  float _7682;
  float _7684;
  float _7690;
  bool _7692;
  float _7700;
  float _7701;
  float _7702;
  float _7707;
  float _7709;
  float _7710;
  float _7713;
  float _7717;
  float _7726;
  float _7727;
  float _7728;
  int _7729;
  float _7734;
  float _7743;
  float _7744;
  float _7746;
  float4 _7751;
  float _7756;
  float _7758;
  float _7760;
  float _7762;
  float _7766;
  float _7768;
  float _7772;
  float _7774;
  int _7781;
  float _7786;
  float _7795;
  float _7796;
  float4 _7802;
  float _7807;
  float _7809;
  float _7813;
  float _7815;
  float _7819;
  float _7821;
  float _7825;
  float _7827;
  int _7834;
  float _7839;
  float _7848;
  float _7849;
  float4 _7855;
  float _7860;
  float _7862;
  float _7866;
  float _7868;
  float _7872;
  float _7874;
  float _7878;
  float _7880;
  int _7887;
  float _7892;
  float _7901;
  float _7902;
  float4 _7908;
  float _7913;
  float _7915;
  float _7919;
  float _7921;
  float _7925;
  float _7927;
  float _7931;
  float _7933;
  float _7934;
  float _7945;
  float _7951;
  float _7953;
  float _7955;
  float _7962;
  float _7970;
  float _7971;
  float _7980;
  float _7984;
  float _7993;
  float _7994;
  float _7995;
  float _8000;
  int _8001;
  float _8006;
  float _8015;
  float _8016;
  float _8018;
  float _8020;
  float _8021;
  float4 _8023;
  float _8027;
  float _8028;
  float _8031;
  float _8032;
  float _8037;
  float _8038;
  float _8041;
  float _8042;
  float _8044;
  float _8046;
  bool _8047;
  bool _8048;
  bool _8058;
  bool _8067;
  float _8084;
  float _8086;
  float _8088;
  float _8090;
  float _8094;
  float _8096;
  float _8100;
  float _8102;
  int _8109;
  float _8114;
  float _8123;
  float _8124;
  float _8127;
  float _8128;
  float4 _8130;
  float _8134;
  float _8135;
  float _8138;
  float _8139;
  float _8141;
  float _8143;
  bool _8144;
  bool _8145;
  bool _8155;
  bool _8164;
  float _8181;
  float _8183;
  float _8187;
  float _8189;
  float _8193;
  float _8195;
  float _8199;
  float _8201;
  int _8208;
  float _8213;
  float _8222;
  float _8223;
  float _8226;
  float _8227;
  float4 _8229;
  float _8233;
  float _8234;
  float _8237;
  float _8238;
  float _8240;
  float _8242;
  bool _8243;
  bool _8244;
  bool _8254;
  bool _8263;
  float _8280;
  float _8282;
  float _8286;
  float _8288;
  float _8292;
  float _8294;
  float _8298;
  float _8300;
  int _8307;
  float _8312;
  float _8321;
  float _8322;
  float _8325;
  float _8326;
  float4 _8328;
  float _8332;
  float _8333;
  float _8336;
  float _8337;
  float _8339;
  float _8341;
  bool _8342;
  bool _8343;
  bool _8353;
  bool _8362;
  float _8379;
  float _8381;
  float _8385;
  float _8387;
  float _8391;
  float _8393;
  float _8397;
  float _8399;
  float _8400;
  float _8411;
  float _8417;
  float _8419;
  float _8421;
  float _8442;
  float4 _8449;
  float _8463;
  float _8464;
  float _8465;
  float _8466;
  float _8468;
  float _8473;
  float _8476;
  float _8477;
  float _8479;
  float _8480;
  float _8485;
  float _8490;
  float _8492;
  float _8495;
  float _8496;
  float _8501;
  float _8503;
  float _8505;
  float _8507;
  float _8512;
  float _8518;
  float _8520;
  float3 _8547;
  float _8558;
  float4 _8579;
  float _8617;
  bool _8630;
  float _8631;
  float _8632;
  float _8633;
  bool _8634;
  float _8636;
  float _8637;
  float _8641;
  float _8647;
  float _8661;
  float _8662;
  float _8665;
  float _8669;
  int _8670;
  float _8672;
  float _8674;
  float _8677;
  float _8681;
  float _8692;
  float _8693;
  float _8694;
  float _8696;
  int _8716;
  int _8721;
  int _8723;
  int _8724;
  int _8726;
  int _8727;
  int _8736;
  bool _8749;
  float _8752;
  float _8754;
  float _8755;
  float _8756;
  float _8757;
  float _8758;
  float _8759;
  float _8760;
  float _8761;
  float _8762;
  float _8763;
  float _8764;
  float _8765;
  bool _8766;
  float _8767;
  float _8768;
  float _8771;
  float _8772;
  float _8774;
  float _8801;
  float _8806;
  float _8813;
  float _8814;
  float _8815;
  float _8817;
  float _8821;
  float _8822;
  float _8823;
  float _8824;
  float _8825;
  float _8826;
  float _8827;
  float _8833;
  float _8842;
  float _8846;
  float _8847;
  float _8848;
  float _8849;
  float _8853;
  float _8854;
  float _8855;
  float _8863;
  float _8875;
  float _8876;
  float _8877;
  float _8878;
  float _8879;
  float _8880;
  float _8883;
  float _8885;
  float _8887;
  float _8891;
  float _8892;
  float _8893;
  float _8896;
  float _8899;
  float _8902;
  bool _8903;
  float _8907;
  float _8909;
  float _8910;
  float _8918;
  float _8921;
  float _8922;
  float _8927;
  float _8936;
  float _8937;
  float _8940;
  float _8942;
  float _8943;
  float _8944;
  float _8946;
  float _8947;
  float _8948;
  float _8949;
  float _8954;
  float _8968;
  float _8973;
  float _8974;
  float _8976;
  float _8982;
  float _8985;
  float _8996;
  float _8998;
  bool _8999;
  float _9017;
  bool _9022;
  float _9028;
  float _9045;
  float _9055;
  float _9062;
  float _9064;
  float _9065;
  float _9066;
  float _9075;
  float _9076;
  float _9082;
  bool _9083;
  float _9087;
  float _9089;
  float _9090;
  float _9096;
  float _9099;
  float _9100;
  float _9105;
  float _9114;
  float _9115;
  float _9118;
  float _9120;
  float _9121;
  float _9122;
  float _9124;
  float _9125;
  float _9126;
  float _9127;
  float _9132;
  float _9146;
  float _9151;
  float _9152;
  float _9154;
  float _9160;
  float _9163;
  float _9191;
  float _9201;
  float _9218;
  float _9219;
  float _9220;
  float _9224;
  float _9227;
  float _9228;
  float _9229;
  float _9230;
  float _9237;
  float _9238;
  float _9239;
  float _9264;
  float _9271;
  float _9286;
  float _9287;
  float _9288;
  float _9289;
  float _9292;
  float _9293;
  float _9294;
  float _9295;
  float _9298;
  float _9299;
  float _9300;
  float _9301;
  float _9304;
  float _9305;
  int _9308;
  int _9311;
  int _9314;
  int _9317;
  float _9320;
  float _9322;
  float _9323;
  float _9325;
  float _9329;
  float _9331;
  float _9335;
  float _9339;
  float _9343;
  float _9346;
  float _9349;
  float _9352;
  float _9364;
  float _9365;
  float _9366;
  float _9367;
  float _9368;
  float _9369;
  float _9370;
  float _9371;
  float _9372;
  float _9373;
  float _9374;
  float _9376;
  float _9378;
  float _9380;
  float _9382;
  float _9383;
  float _9389;
  float _9391;
  float _9398;
  float _9413;
  float _9415;
  float _9422;
  float _9432;
  float _9438;
  float _9440;
  float _9447;
  float _9464;
  float _9466;
  float _9473;
  float _9492;
  float _9493;
  float _9494;
  float _9495;
  float _9497;
  float _9499;
  float _9500;
  float _9501;
  float _9502;
  float _9503;
  float _9504;
  float _9505;
  float _9506;
  float _9508;
  float _9510;
  float _9511;
  float _9512;
  float _9513;
  float _9514;
  float _9515;
  float _9516;
  float _9518;
  float _9520;
  float _9527;
  bool _9540;
  float _9542;
  float _9548;
  float _9552;
  float _9554;
  float _9555;
  bool _9556;
  float _9558;
  float _9564;
  float _9565;
  float _9570;
  float _9571;
  float _9574;
  float _9576;
  float _9583;
  float _9596;
  float _9598;
  float _9605;
  float _9634;
  float _9635;
  float _9644;
  float _9653;
  float _9654;
  float _9660;
  float _9665;
  float _9674;
  float _9681;
  float _9684;
  float4 _9692;
  float _9694;
  float4 _9695;
  float _9704;
  float _9722;
  float _9723;
  float _9751;
  uint _9765;
  float _9776;
  float _9782;
  float _9783;
  float _9794;
  int _9801;
  uint _9805;
  float _9811;
  float4 _9820;
  float _9841;
  float _9842;
  float _9857;
  float _9858;
  float _9861;
  float _9862;
  float _9865;
  float _9866;
  float4 _9868;
  float4 _9874;
  float _9896;
  float _9914;
  float _9916;
  bool _9917;
  float _9919;
  float _9921;
  bool _9922;
  bool _9935;
  bool _9951;
  int _9952;
  float2 _9956;
  float _9961;
  float _9962;
  float _9966;
  float _9968;
  float _9969;
  float _9974;
  float _9975;
  float _9977;
  float _9978;
  float _9979;
  float _9980;
  float _9982;
  int _9998;
  int _9999;
  int _10000;
  int _10001;
  float _10005;
  float _10007;
  float _10008;
  float _10015;
  float _10020;
  float _10024;
  float _10025;
  float _10028;
  float _10038;
  float _10039;
  float _10040;
  float _10044;
  float _10059;
  float _10062;
  float _10065;
  float _10068;
  float _10071;
  float _10074;
  int _10110;
  int _10111;
  float _10114;
  float _10115;
  float _10116;
  float _10117;
  float _10120;
  float _10121;
  float _10122;
  float _10123;
  float _10126;
  float _10127;
  float _10128;
  float _10129;
  float _10132;
  float _10133;
  float _10134;
  float _10135;
  float _10138;
  float _10139;
  float _10140;
  float _10141;
  float _10144;
  float _10145;
  float _10146;
  float _10147;
  int _10150;
  float _10153;
  float _10154;
  float _10155;
  float _10158;
  float _10159;
  float _10160;
  int _10163;
  int _10166;
  int _10169;
  float _10198;
  float _10201;
  float _10204;
  float _10205;
  float4 _10211;
  float4 _10217;
  float _10226;
  float _10230;
  float _10233;
  float _10236;
  float _10277;
  float _10282;
  float _10284;
  float _10286;
  float _10293;
  float _10294;
  float4 _10300;
  float4 _10306;
  float _10314;
  float4 _10320;
  float4 _10326;
  float _10343;
  float _10344;
  float _10345;
  float _10346;
  float _10347;
  float _10348;
  float _10349;
  float _10350;
  float _10351;
  uint _10399;
  bool _10422;
  int _10432;
  float _10434;
  float _10435;
  float _10442;
  float _10447;
  float _10448;
  bool _10449;
  float4 _10454;
  float4 _10460;
  float _10471;
  float4 _10476;
  float4 _10482;
  float _10520;
  int _10540;
  float _10541;
  float _10544;
  float _10545;
  bool _10546;
  float4 _10551;
  float4 _10557;
  float _10568;
  float4 _10573;
  float4 _10579;
  float _10607;
  float _10653;
  float _10657;
  float _10661;
  float _10664;
  float _10667;
  float _10670;
  int4 _10675;
  int4 _10690;
  float4 _10719;
  float4 _10724;
  float4 _10729;
  float _10756;
  float _10777;
  float _10798;
  int _10802;
  float4 _10803;
  float _10807;
  float _10808;
  float _10809;
  int _10828;
  int _10830;
  int _10832;
  uint _10836;
  uint _10837;
  uint _10838;
  int _10846;
  int _10847;
  uint _10850;
  uint _10856;
  float _10867;
  float4 _10873;
  float _10890;
  float _10904;
  float4 _10906;
  float _10916;
  float _10917;
  float _10918;
  float _10923;
  float _10924;
  float _10926;
  float _10927;
  float _10928;
  float _10930;
  float _10931;
  float _10932;
  float _10933;
  float _10938;
  float _10939;
  float _10940;
  float _10961;
  float _10962;
  int _10963;
  bool _10964;
  float _10971;
  float _10972;
  float _10973;
  float _10974;
  int _10979;
  int _10980;
  uint _10981;
  uint _10982;
  bool _10989;
  bool _10994;
  uint _10995;
  uint _10997;
  bool _11007;
  uint _11008;
  bool _11019;
  uint _11021;
  float _11049;
  float _11057;
  float _11065;
  float _11073;
  float _11085;
  float _11089;
  float _11099;
  float _11100;
  float _11101;
  float _11102;
  float _11111;
  float _11114;
  float _11121;
  float _11129;
  float _11130;
  float _11131;
  float _11152;
  float _11153;
  int _11154;
  bool _11155;
  float _11162;
  float _11163;
  float _11164;
  float _11165;
  int _11170;
  int _11171;
  uint _11172;
  uint _11173;
  bool _11180;
  bool _11185;
  uint _11186;
  uint _11188;
  bool _11198;
  uint _11199;
  bool _11210;
  uint _11212;
  uint _11240;
  float _11250;
  float _11251;
  float _11252;
  float _11256;
  float _11258;
  float _11260;
  float _11262;
  uint _11269;
  float _11279;
  float _11280;
  float _11281;
  float _11285;
  float _11287;
  float _11289;
  float _11291;
  uint _11298;
  float _11308;
  float _11309;
  float _11310;
  float _11314;
  float _11316;
  float _11318;
  float _11320;
  uint _11327;
  float _11337;
  float _11338;
  float _11339;
  float _11343;
  float _11345;
  float _11347;
  float _11349;
  float _11368;
  float _11369;
  float _11376;
  float _11377;
  float _11378;
  float _11403;
  float _11404;
  float _11405;
  float _11416;
  float _11424;
  float _11428;
  float _11429;
  float _11430;
  float _11432;
  int _11467;
  float _11478;
  float _11479;
  float _11480;
  bool _11483;
  float _11508;
  int _11515;
  float _11567;
  uint _11572;
  int _11575;
  int _11576;
  int _11580;
  int _11584;
  float _11596;
  float _11601;
  float _11602;
  float _11603;
  float _11604;
  float _11607;
  float _11608;
  float _11609;
  float _11610;
  float _11613;
  float _11614;
  float _11615;
  float _11616;
  int _11619;
  int _11622;
  int _11625;
  int _11628;
  float _11643;
  float _11647;
  float _11651;
  float _11676;
  float _11677;
  float _11678;
  float _11681;
  uint _11690;
  bool _11698;
  float _11713;
  float _11715;
  float _11716;
  float _11717;
  float _11718;
  float _11723;
  float _11724;
  float _11725;
  float _11726;
  float _11728;
  float _11737;
  float _11738;
  float _11743;
  float _11749;
  float _11757;
  float _11768;
  float _11769;
  float _11770;
  float _11793;
  float _11797;
  float _11801;
  float _11820;
  float _11824;
  float _11828;
  float _11841;
  float _11842;
  float _11843;
  int _11888;
  int _11892;
  int _11893;
  int _11894;
  int _11895;
  int _11906;
  int _11910;
  float _11922;
  int _11925;
  float _11942;
  float _11947;
  float _11948;
  float _11949;
  float _11950;
  float _11953;
  float _11954;
  float _11955;
  float _11956;
  float _11959;
  float _11960;
  float _11961;
  float _11962;
  int _11965;
  int _11968;
  int _11971;
  int _11974;
  int _11977;
  float _11986;
  float _11999;
  float _12003;
  float _12007;
  float _12032;
  float _12033;
  float _12034;
  float _12037;
  float _12038;
  float _12045;
  float _12060;
  float _12061;
  float _12062;
  float _12063;
  float _12066;
  float _12067;
  float _12068;
  float _12069;
  float _12072;
  float _12073;
  float _12074;
  float _12075;
  float _12078;
  float _12079;
  float _12080;
  float _12083;
  int _12086;
  int _12089;
  int _12092;
  int _12095;
  int _12098;
  float _12101;
  float _12102;
  float _12103;
  float _12104;
  int _12107;
  int _12110;
  int _12113;
  int _12116;
  int _12119;
  int _12122;
  int _12125;
  int _12128;
  float _12130;
  float _12131;
  float _12133;
  float _12137;
  float _12139;
  int _12142;
  float _12152;
  float _12153;
  float _12155;
  float _12156;
  float _12157;
  float _12158;
  float _12177;
  float _12181;
  float _12182;
  float _12183;
  float _12187;
  float _12191;
  float _12195;
  float _12196;
  float _12219;
  float _12220;
  float _12221;
  float _12224;
  float _12225;
  float _12232;
  float _12233;
  float _12234;
  float _12239;
  float _12241;
  float _12242;
  float _12245;
  float _12249;
  float _12258;
  float _12259;
  float _12260;
  int _12261;
  float _12266;
  float _12275;
  float _12276;
  float _12278;
  float4 _12283;
  float _12288;
  float _12290;
  float _12292;
  float _12294;
  float _12298;
  float _12300;
  float _12304;
  float _12306;
  int _12313;
  float _12318;
  float _12327;
  float _12328;
  float4 _12334;
  float _12339;
  float _12341;
  float _12345;
  float _12347;
  float _12351;
  float _12353;
  float _12357;
  float _12359;
  int _12366;
  float _12371;
  float _12380;
  float _12381;
  float4 _12387;
  float _12392;
  float _12394;
  float _12398;
  float _12400;
  float _12404;
  float _12406;
  float _12410;
  float _12412;
  int _12419;
  float _12424;
  float _12433;
  float _12434;
  float4 _12440;
  float _12445;
  float _12447;
  float _12451;
  float _12453;
  float _12457;
  float _12459;
  float _12463;
  float _12465;
  float _12466;
  float _12477;
  float _12483;
  float _12485;
  float _12487;
  float _12494;
  float _12502;
  float _12503;
  float _12512;
  float _12516;
  float _12525;
  float _12526;
  float _12527;
  float _12532;
  int _12533;
  float _12538;
  float _12547;
  float _12548;
  float _12550;
  float _12552;
  float _12553;
  float4 _12555;
  float _12559;
  float _12560;
  float _12563;
  float _12564;
  float _12569;
  float _12570;
  float _12573;
  float _12574;
  float _12576;
  float _12578;
  bool _12579;
  bool _12580;
  bool _12590;
  bool _12599;
  float _12616;
  float _12618;
  float _12620;
  float _12622;
  float _12626;
  float _12628;
  float _12632;
  float _12634;
  int _12641;
  float _12646;
  float _12655;
  float _12656;
  float _12659;
  float _12660;
  float4 _12662;
  float _12666;
  float _12667;
  float _12670;
  float _12671;
  float _12673;
  float _12675;
  bool _12676;
  bool _12677;
  bool _12687;
  bool _12696;
  float _12713;
  float _12715;
  float _12719;
  float _12721;
  float _12725;
  float _12727;
  float _12731;
  float _12733;
  int _12740;
  float _12745;
  float _12754;
  float _12755;
  float _12758;
  float _12759;
  float4 _12761;
  float _12765;
  float _12766;
  float _12769;
  float _12770;
  float _12772;
  float _12774;
  bool _12775;
  bool _12776;
  bool _12786;
  bool _12795;
  float _12812;
  float _12814;
  float _12818;
  float _12820;
  float _12824;
  float _12826;
  float _12830;
  float _12832;
  int _12839;
  float _12844;
  float _12853;
  float _12854;
  float _12857;
  float _12858;
  float4 _12860;
  float _12864;
  float _12865;
  float _12868;
  float _12869;
  float _12871;
  float _12873;
  bool _12874;
  bool _12875;
  bool _12885;
  bool _12894;
  float _12911;
  float _12913;
  float _12917;
  float _12919;
  float _12923;
  float _12925;
  float _12929;
  float _12931;
  float _12932;
  float _12943;
  float _12949;
  float _12951;
  float _12953;
  float _12973;
  float4 _12980;
  float _12994;
  float _12995;
  float _12996;
  float _12997;
  float _12999;
  float _13004;
  float _13007;
  float _13008;
  float _13010;
  float _13011;
  float _13016;
  float _13021;
  float _13023;
  float _13026;
  float _13027;
  float _13032;
  float _13034;
  float _13036;
  float _13038;
  float _13043;
  float _13049;
  float _13051;
  float3 _13077;
  float _13088;
  float4 _13109;
  int _13137;
  int _13142;
  int _13144;
  int _13145;
  int _13147;
  int _13148;
  int _13157;
  float _13173;
  float _13174;
  float _13175;
  float _13176;
  float _13177;
  float _13178;
  float _13186;
  float _13191;
  float _13197;
  float _13198;
  float _13201;
  float _13203;
  float _13204;
  float _13205;
  float _13208;
  float _13211;
  float _13214;
  bool _13215;
  float _13219;
  float _13221;
  float _13222;
  float _13230;
  float _13233;
  float _13234;
  float _13239;
  float _13248;
  float _13249;
  float _13252;
  float _13254;
  float _13255;
  float _13256;
  float _13258;
  float _13259;
  float _13260;
  float _13261;
  float _13266;
  float _13280;
  float _13285;
  float _13286;
  float _13288;
  float _13294;
  float _13297;
  float _13308;
  float _13309;
  bool _13310;
  float _13320;
  float _13335;
  float _13345;
  float _13347;
  float _13348;
  float _13360;
  bool _13361;
  float _13365;
  float _13367;
  float _13368;
  float _13374;
  float _13377;
  float _13378;
  float _13383;
  float _13392;
  float _13393;
  float _13396;
  float _13398;
  float _13399;
  float _13400;
  float _13402;
  float _13403;
  float _13404;
  float _13405;
  float _13410;
  float _13424;
  float _13429;
  float _13430;
  float _13432;
  float _13438;
  float _13441;
  float _13461;
  float _13476;
  float _13477;
  float _13508;
  float _13510;
  float _13524;
  float _13525;
  float _13526;
  float _13527;
  float _13530;
  float _13531;
  float _13532;
  float _13533;
  float _13536;
  float _13537;
  float _13538;
  int _13541;
  int _13544;
  int _13547;
  int _13550;
  int _13553;
  int _13556;
  float _13559;
  float _13562;
  int _13564;
  float2 _13584;
  float3 _13601;
  float _13614;
  float _13617;
  float _13618;
  float _13619;
  float _13620;
  float _13621;
  float _13622;
  float _13630;
  float _13635;
  float _13641;
  float _13642;
  float _13645;
  float _13647;
  float _13648;
  float _13649;
  float _13652;
  float _13655;
  float _13658;
  bool _13659;
  float _13663;
  float _13665;
  float _13666;
  float _13674;
  float _13677;
  float _13678;
  float _13683;
  float _13692;
  float _13693;
  float _13696;
  float _13698;
  float _13699;
  float _13700;
  float _13702;
  float _13703;
  float _13704;
  float _13705;
  float _13710;
  float _13724;
  float _13729;
  float _13730;
  float _13732;
  float _13738;
  float _13741;
  float _13752;
  float _13753;
  bool _13754;
  float _13764;
  float _13779;
  float _13789;
  float _13791;
  float _13792;
  float _13804;
  bool _13805;
  float _13809;
  float _13811;
  float _13812;
  float _13818;
  float _13821;
  float _13822;
  float _13827;
  float _13836;
  float _13837;
  float _13840;
  float _13842;
  float _13843;
  float _13844;
  float _13846;
  float _13847;
  float _13848;
  float _13849;
  float _13854;
  float _13868;
  float _13873;
  float _13874;
  float _13876;
  float _13882;
  float _13885;
  float _13905;
  float _13920;
  float _13930;
  float _13961;
  bool _13974;
  float _13975;
  float _13976;
  float _13977;
  bool _13978;
  float _13980;
  float _13981;
  float _13985;
  float _13991;
  float _14005;
  float _14006;
  float _14009;
  float _14013;
  int _14014;
  float _14016;
  float _14018;
  float _14021;
  float _14025;
  float _14036;
  float _14037;
  float _14038;
  float _14040;
  float _14054;
  float _14055;
  float _14056;
  float _14072;
  float _14084;
  float _14085;
  float _14086;
  float _14089;
  float _14090;
  float _14091;
  float _14094;
  float _14095;
  float _14096;
  float _14099;
  float _14100;
  float _14101;
  float _14104;
  float _14105;
  float _14106;
  int _14109;
  int _14112;
  int _14115;
  int _14118;
  int _14121;
  int _14124;
  int _14127;
  int _14130;
  int _14133;
  int _14136;
  int _14139;
  float _14142;
  float _14143;
  float _14144;
  float _14145;
  int _14148;
  int _14151;
  int _14154;
  int _14157;
  float _14159;
  float _14160;
  float _14162;
  float _14166;
  float _14167;
  float _14169;
  float _14173;
  float _14175;
  float _14176;
  float _14178;
  int _14181;
  bool _14185;
  float _14193;
  float _14194;
  float _14196;
  float _14199;
  float _14200;
  float _14202;
  float _14203;
  float _14205;
  float _14206;
  float _14210;
  float _14216;
  float _14217;
  float _14218;
  float _14229;
  float _14230;
  float _14231;
  float _14232;
  float _14233;
  float _14234;
  float _14235;
  float _14236;
  float _14237;
  float _14240;
  float _14241;
  float _14242;
  float _14245;
  float _14252;
  float _14265;
  float _14269;
  float _14273;
  float _14274;
  float _14275;
  float _14278;
  float _14281;
  bool _14283;
  float _14289;
  float _14290;
  float _14291;
  float _14296;
  float _14297;
  float _14298;
  bool _14302;
  bool _14308;
  bool _14312;
  float _14322;
  float _14326;
  float _14335;
  float _14336;
  float _14343;
  float _14344;
  float _14347;
  float _14351;
  float _14360;
  float _14361;
  float _14362;
  float _14367;
  int _14368;
  float _14373;
  float _14382;
  float _14383;
  float _14385;
  float _14387;
  float _14388;
  float4 _14390;
  float _14394;
  float _14395;
  float _14398;
  float _14399;
  float _14404;
  float _14405;
  float _14408;
  float _14409;
  float _14411;
  float _14413;
  bool _14414;
  bool _14415;
  bool _14425;
  bool _14434;
  float _14451;
  float _14453;
  float _14455;
  float _14457;
  float _14461;
  float _14463;
  float _14467;
  float _14469;
  int _14476;
  float _14481;
  float _14490;
  float _14491;
  float _14494;
  float _14495;
  float4 _14497;
  float _14501;
  float _14502;
  float _14505;
  float _14506;
  float _14508;
  float _14510;
  bool _14511;
  bool _14512;
  bool _14522;
  bool _14531;
  float _14548;
  float _14550;
  float _14554;
  float _14556;
  float _14560;
  float _14562;
  float _14566;
  float _14568;
  int _14575;
  float _14580;
  float _14589;
  float _14590;
  float _14593;
  float _14594;
  float4 _14596;
  float _14600;
  float _14601;
  float _14604;
  float _14605;
  float _14607;
  float _14609;
  bool _14610;
  bool _14611;
  bool _14621;
  bool _14630;
  float _14647;
  float _14649;
  float _14653;
  float _14655;
  float _14659;
  float _14661;
  float _14665;
  float _14667;
  int _14674;
  float _14679;
  float _14688;
  float _14689;
  float _14692;
  float _14693;
  float4 _14695;
  float _14699;
  float _14700;
  float _14703;
  float _14704;
  float _14706;
  float _14708;
  bool _14709;
  bool _14710;
  bool _14720;
  bool _14729;
  float _14746;
  float _14748;
  float _14752;
  float _14754;
  float _14758;
  float _14760;
  float _14764;
  float _14766;
  float _14767;
  float _14778;
  float _14784;
  float _14786;
  float _14788;
  float _14797;
  float _14800;
  float _14801;
  float _14815;
  float _14816;
  float _14817;
  float _14821;
  float _14830;
  float _14831;
  float _14832;
  int _14833;
  float _14838;
  float _14847;
  float _14848;
  float _14850;
  float4 _14855;
  float _14860;
  float _14862;
  float _14864;
  float _14866;
  float _14870;
  float _14872;
  float _14876;
  float _14878;
  int _14885;
  float _14890;
  float _14899;
  float _14900;
  float4 _14906;
  float _14911;
  float _14913;
  float _14917;
  float _14919;
  float _14923;
  float _14925;
  float _14929;
  float _14931;
  int _14938;
  float _14943;
  float _14952;
  float _14953;
  float4 _14959;
  float _14964;
  float _14966;
  float _14970;
  float _14972;
  float _14976;
  float _14978;
  float _14982;
  float _14984;
  int _14991;
  float _14996;
  float _15005;
  float _15006;
  float4 _15012;
  float _15017;
  float _15019;
  float _15023;
  float _15025;
  float _15029;
  float _15031;
  float _15035;
  float _15037;
  float _15038;
  float _15049;
  float _15055;
  float _15057;
  float _15059;
  float _15067;
  float _15074;
  float _15076;
  float _15090;
  float _15091;
  float _15092;
  bool _15096;
  bool _15102;
  bool _15106;
  float _15116;
  float _15121;
  float _15130;
  float _15131;
  float _15136;
  float _15137;
  float _15140;
  float _15144;
  float _15153;
  float _15154;
  float _15155;
  float _15160;
  int _15161;
  float _15166;
  float _15175;
  float _15176;
  float _15178;
  float _15180;
  float _15181;
  float4 _15183;
  float _15187;
  float _15188;
  float _15191;
  float _15192;
  float _15197;
  float _15198;
  float _15201;
  float _15202;
  float _15204;
  float _15206;
  bool _15207;
  bool _15208;
  bool _15218;
  bool _15227;
  float _15244;
  float _15246;
  float _15248;
  float _15250;
  float _15254;
  float _15256;
  float _15260;
  float _15262;
  int _15269;
  float _15274;
  float _15283;
  float _15284;
  float _15287;
  float _15288;
  float4 _15290;
  float _15294;
  float _15295;
  float _15298;
  float _15299;
  float _15301;
  float _15303;
  bool _15304;
  bool _15305;
  bool _15315;
  bool _15324;
  float _15341;
  float _15343;
  float _15347;
  float _15349;
  float _15353;
  float _15355;
  float _15359;
  float _15361;
  int _15368;
  float _15373;
  float _15382;
  float _15383;
  float _15386;
  float _15387;
  float4 _15389;
  float _15393;
  float _15394;
  float _15397;
  float _15398;
  float _15400;
  float _15402;
  bool _15403;
  bool _15404;
  bool _15414;
  bool _15423;
  float _15440;
  float _15442;
  float _15446;
  float _15448;
  float _15452;
  float _15454;
  float _15458;
  float _15460;
  int _15467;
  float _15472;
  float _15481;
  float _15482;
  float _15485;
  float _15486;
  float4 _15488;
  float _15492;
  float _15493;
  float _15496;
  float _15497;
  float _15499;
  float _15501;
  bool _15502;
  bool _15503;
  bool _15513;
  bool _15522;
  float _15539;
  float _15541;
  float _15545;
  float _15547;
  float _15551;
  float _15553;
  float _15557;
  float _15559;
  float _15560;
  float _15571;
  float _15577;
  float _15579;
  float _15581;
  float _15590;
  float _15593;
  float _15594;
  float _15607;
  float _15608;
  float _15609;
  float _15613;
  float _15622;
  float _15623;
  float _15624;
  int _15625;
  float _15630;
  float _15639;
  float _15640;
  float _15642;
  float4 _15647;
  float _15652;
  float _15654;
  float _15656;
  float _15658;
  float _15662;
  float _15664;
  float _15668;
  float _15670;
  int _15677;
  float _15682;
  float _15691;
  float _15692;
  float4 _15698;
  float _15703;
  float _15705;
  float _15709;
  float _15711;
  float _15715;
  float _15717;
  float _15721;
  float _15723;
  int _15730;
  float _15735;
  float _15744;
  float _15745;
  float4 _15751;
  float _15756;
  float _15758;
  float _15762;
  float _15764;
  float _15768;
  float _15770;
  float _15774;
  float _15776;
  int _15783;
  float _15788;
  float _15797;
  float _15798;
  float4 _15804;
  float _15809;
  float _15811;
  float _15815;
  float _15817;
  float _15821;
  float _15823;
  float _15827;
  float _15829;
  float _15830;
  float _15841;
  float _15847;
  float _15849;
  float _15851;
  float _15859;
  float _15866;
  float _15868;
  float _15894;
  float _15896;
  float _15897;
  float _15898;
  float _15913;
  float _15916;
  float _15919;
  float _15921;
  float _15922;
  float _15923;
  float _15924;
  float _15932;
  float _15933;
  float _15934;
  bool _15936;
  float _15956;
  float4 _15981;
  float _16001;
  float _16002;
  float _16003;
  float _16004;
  float _16006;
  float _16011;
  float _16014;
  float _16015;
  float _16017;
  float _16018;
  float _16023;
  float _16028;
  float _16030;
  float _16033;
  float _16034;
  float _16039;
  float _16041;
  float _16043;
  float _16045;
  float _16050;
  float _16056;
  float _16058;
  float3 _16087;
  float4 _16118;
  float _16153;
  bool _16166;
  float _16167;
  float _16168;
  float _16169;
  bool _16170;
  float _16172;
  float _16173;
  float _16177;
  float _16183;
  float _16197;
  float _16198;
  float _16201;
  float _16205;
  int _16206;
  float _16208;
  float _16210;
  float _16213;
  float _16217;
  float _16228;
  float _16229;
  float _16230;
  float _16232;
  int _16252;
  int _16257;
  int _16259;
  int _16260;
  int _16262;
  int _16263;
  int _16272;
  float _16288;
  float _16289;
  float _16290;
  float _16291;
  float _16292;
  float _16293;
  float _16294;
  float _16295;
  float _16296;
  float _16297;
  float _16298;
  float _16299;
  bool _16300;
  float _16301;
  float _16302;
  float _16305;
  float _16306;
  float _16308;
  float _16335;
  float _16340;
  float _16347;
  float _16348;
  float _16349;
  float _16351;
  float _16355;
  float _16356;
  float _16357;
  float _16358;
  float _16359;
  float _16360;
  float _16361;
  float _16367;
  float _16376;
  float _16380;
  float _16381;
  float _16382;
  float _16383;
  float _16387;
  float _16388;
  float _16389;
  float _16397;
  float _16409;
  float _16410;
  float _16411;
  float _16412;
  float _16413;
  float _16414;
  float _16417;
  float _16419;
  float _16420;
  float _16421;
  float _16422;
  float _16425;
  float _16428;
  float _16431;
  bool _16432;
  float _16436;
  float _16438;
  float _16439;
  float _16447;
  float _16450;
  float _16451;
  float _16456;
  float _16465;
  float _16466;
  float _16469;
  float _16471;
  float _16472;
  float _16473;
  float _16475;
  float _16476;
  float _16477;
  float _16478;
  float _16483;
  float _16497;
  float _16502;
  float _16503;
  float _16505;
  float _16511;
  float _16514;
  float _16525;
  float _16526;
  bool _16527;
  float _16545;
  bool _16550;
  float _16556;
  float _16573;
  float _16583;
  float _16585;
  float _16586;
  float _16587;
  float _16599;
  bool _16600;
  float _16604;
  float _16606;
  float _16607;
  float _16613;
  float _16616;
  float _16617;
  float _16622;
  float _16631;
  float _16632;
  float _16635;
  float _16637;
  float _16638;
  float _16639;
  float _16641;
  float _16642;
  float _16643;
  float _16644;
  float _16649;
  float _16663;
  float _16668;
  float _16669;
  float _16671;
  float _16677;
  float _16680;
  float _16708;
  float _16718;
  float _16735;
  float _16736;
  float _16737;
  float _16769;
  float _16771;
  float _16786;
  float _16787;
  float _16788;
  float _16791;
  float _16792;
  float _16793;
  float _16796;
  int _16799;
  int _16802;
  int _16805;
  float _16814;
  float _16817;
  float _16824;
  float _16829;
  float _16831;
  float _16833;
  float _16834;
  float _16835;
  float _16837;
  float _16838;
  float _16839;
  float _16842;
  float _16843;
  float _16844;
  float _16847;
  float _16854;
  int _16863;
  int _16868;
  int _16870;
  int _16871;
  int _16873;
  int _16874;
  int _16883;
  float _16893;
  float _16894;
  float _16895;
  float _16898;
  float _16901;
  float _16902;
  float _16903;
  float _16904;
  float _16908;
  float _16911;
  float _16912;
  float _16913;
  float _16944;
  float _16947;
  float _16951;
  float _16966;
  float _16967;
  float _16968;
  float _16971;
  float _16972;
  float _16973;
  float _16976;
  float _16977;
  float _16978;
  float _16981;
  float _16982;
  float _16983;
  float _16986;
  float _16987;
  float _16988;
  float _16991;
  float _16992;
  float _16993;
  int _16996;
  int _16999;
  int _17002;
  int _17005;
  float _17008;
  float _17009;
  float _17010;
  float _17011;
  int _17014;
  int _17017;
  int _17020;
  int _17023;
  int _17026;
  int _17029;
  int _17032;
  float _17035;
  float _17036;
  float _17037;
  float _17038;
  int _17041;
  int _17044;
  int _17047;
  float _17049;
  float _17050;
  float _17052;
  float _17056;
  float _17057;
  float _17059;
  float _17063;
  int _17067;
  float _17083;
  float _17084;
  float _17086;
  float _17087;
  float _17088;
  float _17089;
  float _17090;
  float _17091;
  float _17092;
  float _17093;
  float _17094;
  float _17095;
  float _17096;
  float _17097;
  float _17098;
  float _17101;
  float _17102;
  float _17103;
  float _17106;
  float _17117;
  float _17121;
  float _17128;
  float _17129;
  float _17130;
  float _17142;
  float _17143;
  float _17144;
  float _17145;
  float _17148;
  float _17149;
  float _17152;
  float _17153;
  float _17160;
  float _17162;
  float _17168;
  bool _17170;
  float _17178;
  float _17179;
  float _17180;
  float _17185;
  float _17187;
  float _17188;
  float _17191;
  float _17195;
  float _17204;
  float _17205;
  float _17206;
  int _17207;
  float _17212;
  float _17221;
  float _17222;
  float _17224;
  float4 _17229;
  float _17234;
  float _17236;
  float _17238;
  float _17240;
  float _17244;
  float _17246;
  float _17250;
  float _17252;
  int _17259;
  float _17264;
  float _17273;
  float _17274;
  float4 _17280;
  float _17285;
  float _17287;
  float _17291;
  float _17293;
  float _17297;
  float _17299;
  float _17303;
  float _17305;
  int _17312;
  float _17317;
  float _17326;
  float _17327;
  float4 _17333;
  float _17338;
  float _17340;
  float _17344;
  float _17346;
  float _17350;
  float _17352;
  float _17356;
  float _17358;
  int _17365;
  float _17370;
  float _17379;
  float _17380;
  float4 _17386;
  float _17391;
  float _17393;
  float _17397;
  float _17399;
  float _17403;
  float _17405;
  float _17409;
  float _17411;
  float _17412;
  float _17423;
  float _17429;
  float _17431;
  float _17433;
  float _17440;
  float _17448;
  float _17449;
  float _17458;
  float _17462;
  float _17471;
  float _17472;
  float _17473;
  float _17478;
  int _17479;
  float _17484;
  float _17493;
  float _17494;
  float _17496;
  float _17498;
  float _17499;
  float4 _17501;
  float _17505;
  float _17506;
  float _17509;
  float _17510;
  float _17515;
  float _17516;
  float _17519;
  float _17520;
  float _17522;
  float _17524;
  bool _17525;
  bool _17526;
  bool _17536;
  bool _17545;
  float _17562;
  float _17564;
  float _17566;
  float _17568;
  float _17572;
  float _17574;
  float _17578;
  float _17580;
  int _17587;
  float _17592;
  float _17601;
  float _17602;
  float _17605;
  float _17606;
  float4 _17608;
  float _17612;
  float _17613;
  float _17616;
  float _17617;
  float _17619;
  float _17621;
  bool _17622;
  bool _17623;
  bool _17633;
  bool _17642;
  float _17659;
  float _17661;
  float _17665;
  float _17667;
  float _17671;
  float _17673;
  float _17677;
  float _17679;
  int _17686;
  float _17691;
  float _17700;
  float _17701;
  float _17704;
  float _17705;
  float4 _17707;
  float _17711;
  float _17712;
  float _17715;
  float _17716;
  float _17718;
  float _17720;
  bool _17721;
  bool _17722;
  bool _17732;
  bool _17741;
  float _17758;
  float _17760;
  float _17764;
  float _17766;
  float _17770;
  float _17772;
  float _17776;
  float _17778;
  int _17785;
  float _17790;
  float _17799;
  float _17800;
  float _17803;
  float _17804;
  float4 _17806;
  float _17810;
  float _17811;
  float _17814;
  float _17815;
  float _17817;
  float _17819;
  bool _17820;
  bool _17821;
  bool _17831;
  bool _17840;
  float _17857;
  float _17859;
  float _17863;
  float _17865;
  float _17869;
  float _17871;
  float _17875;
  float _17877;
  float _17878;
  float _17889;
  float _17895;
  float _17897;
  float _17899;
  float _17920;
  float4 _17927;
  float _17941;
  float _17942;
  float _17943;
  float _17944;
  float _17946;
  float _17951;
  float _17954;
  float _17955;
  float _17957;
  float _17958;
  float _17963;
  float _17968;
  float _17970;
  float _17973;
  float _17974;
  float _17979;
  float _17981;
  float _17983;
  float _17985;
  float _17990;
  float _17996;
  float _17998;
  float3 _18025;
  float _18036;
  float4 _18057;
  float _18095;
  bool _18108;
  float _18109;
  float _18110;
  float _18111;
  bool _18112;
  float _18114;
  float _18115;
  float _18119;
  float _18125;
  float _18139;
  float _18140;
  float _18143;
  float _18147;
  int _18148;
  float _18150;
  float _18152;
  float _18155;
  float _18159;
  float _18170;
  float _18171;
  float _18172;
  float _18174;
  int _18194;
  int _18199;
  int _18201;
  int _18202;
  int _18204;
  int _18205;
  int _18214;
  float _18230;
  float _18231;
  float _18232;
  float _18233;
  float _18234;
  float _18235;
  float _18236;
  float _18237;
  float _18238;
  float _18239;
  float _18240;
  float _18241;
  bool _18242;
  float _18243;
  float _18244;
  float _18247;
  float _18248;
  float _18250;
  float _18277;
  float _18282;
  float _18289;
  float _18290;
  float _18291;
  float _18293;
  float _18297;
  float _18298;
  float _18299;
  float _18300;
  float _18301;
  float _18302;
  float _18303;
  float _18309;
  float _18318;
  float _18322;
  float _18323;
  float _18324;
  float _18325;
  float _18329;
  float _18330;
  float _18331;
  float _18339;
  float _18351;
  float _18352;
  float _18353;
  float _18354;
  float _18355;
  float _18356;
  float _18359;
  float _18361;
  float _18362;
  float _18363;
  float _18364;
  float _18367;
  float _18370;
  float _18373;
  bool _18374;
  float _18378;
  float _18380;
  float _18381;
  float _18389;
  float _18392;
  float _18393;
  float _18398;
  float _18407;
  float _18408;
  float _18411;
  float _18413;
  float _18414;
  float _18415;
  float _18417;
  float _18418;
  float _18419;
  float _18420;
  float _18425;
  float _18439;
  float _18444;
  float _18445;
  float _18447;
  float _18453;
  float _18456;
  float _18467;
  float _18468;
  bool _18469;
  float _18487;
  bool _18492;
  float _18498;
  float _18515;
  float _18525;
  float _18527;
  float _18528;
  float _18529;
  float _18541;
  bool _18542;
  float _18546;
  float _18548;
  float _18549;
  float _18555;
  float _18558;
  float _18559;
  float _18564;
  float _18573;
  float _18574;
  float _18577;
  float _18579;
  float _18580;
  float _18581;
  float _18583;
  float _18584;
  float _18585;
  float _18586;
  float _18591;
  float _18605;
  float _18610;
  float _18611;
  float _18613;
  float _18619;
  float _18622;
  float _18650;
  float _18660;
  float _18677;
  float _18678;
  float _18679;
  float _18711;
  float _18713;
  float _18728;
  float _18729;
  float _18730;
  float _18731;
  float _18734;
  float _18735;
  float _18736;
  float _18737;
  float _18740;
  float _18741;
  float _18742;
  float _18743;
  float _18746;
  float _18747;
  int _18750;
  int _18753;
  int _18756;
  int _18759;
  float _18762;
  float _18771;
  float _18777;
  float _18781;
  float _18785;
  float _18788;
  float _18791;
  float _18794;
  float _18806;
  float _18807;
  float _18808;
  float _18809;
  float _18810;
  float _18811;
  float _18812;
  float _18813;
  float _18814;
  float _18815;
  float _18816;
  float _18818;
  float _18820;
  float _18822;
  float _18824;
  float _18825;
  float _18831;
  float _18833;
  float _18840;
  float _18855;
  float _18857;
  float _18864;
  float _18874;
  float _18880;
  float _18882;
  float _18889;
  float _18906;
  float _18908;
  float _18915;
  float _18934;
  float _18935;
  float _18936;
  float _18937;
  float _18939;
  float _18941;
  float _18942;
  float _18943;
  float _18944;
  float _18945;
  float _18946;
  float _18947;
  float _18948;
  float _18950;
  float _18952;
  float _18953;
  float _18954;
  float _18955;
  float _18956;
  float _18957;
  float _18958;
  float _18960;
  float _18962;
  float _18969;
  bool _18982;
  float _18984;
  float _18990;
  float _18994;
  float _18996;
  float _18997;
  bool _18998;
  float _19000;
  float _19006;
  float _19007;
  float _19012;
  float _19013;
  float _19016;
  float _19018;
  float _19025;
  float _19038;
  float _19040;
  float _19047;
  float _19077;
  float _19086;
  float _19089;
  float _19094;
  float _19103;
  float _19110;
  float _19113;
  float4 _19121;
  float _19123;
  float _19145;
  float _19146;
  float _19147;
  uint _19170;
  float _19182;
  float _19207;
  float _19210;
  float _19213;
  float4 _19234;
  float _19238;
  float _19239;
  float _19240;
  float _19242;
  float _19243;
  float _19244;
  float _19245;
  float _19246;
  float _19247;
  float _19248;
  float _19249;
  float _19250;
  float _19255;
  float _19260;
  float _19273;
  float4 _19281;
  float _19283;
  float _19290;
  bool _19323;
  int __loop_jump_target = -1;
  int _46[4];
  int _47[4];
  float _48[4];
  float _49[4];
  float _50[4];
  float _51[4];
  int _52[4];
  int _53[4];
  float _54[4];
  float _55[4];
  float _56[4];
  float _57[4];
  _69 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _75 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _80 = ((uint)(((int)(_75 << 3)) & 524280)) + SV_GroupThreadID.x;
  _81 = ((uint)(((uint)(_75) >> 16) << 3)) + SV_GroupThreadID.y;
  _88 = ((int)((((uint)(_81) >> 4) * asint(_cbSharedPerViewData_raw_uint[57u].x)) + ((uint)((uint)(_80) >> 4)))) << 6;
  _91 = srvDeferredClusters[_88];
  if (_69 == 0) {
    _global_2 = (_91 & 255);
    _global_0 = (((uint)(_91) >> 16) & 255);
    _global_1 = (((uint)(_91) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _102 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_102 == 0)) {
    _106 = 0;
    while(true) {
      _108 = (_106 << 6) + _69;
      if ((uint)_108 < (uint)_global_2) {
        _115 = srvDeferredClusters[((int)(((uint)(_88 | 1)) + _108))];
        _global_3[min((uint)(_108), 63u)] = _115;
        _120 = _115 & 4095;
        _123 = srvLightInfoBase[_120].nFlags;
        _125 = srvLightInfoBase[_120].nRoomMask;
        _127 = srvLightInfoBase[_120].nBufferOffset;
        _global_4[min((uint)(_108), 63u)] = _123;
        _global_5[min((uint)(_108), 63u)] = _125;
        _global_6[min((uint)(_108), 63u)] = _127;
      }
      _129 = _106 + 1;
      if (!(_129 == _102)) {
        _106 = _129;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _134 = srvGlobalGBuffer0.Load(int3(_80, _81, 0));
  [branch]
  if (_134.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_80, _81)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_80, _81)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _142 = (float)((uint)_80);
    _143 = (float)((uint)_81);
    _151 = ((_cbSharedPerViewData_raw[41u].x) * _142) + (_cbSharedPerViewData_raw[41u].z);
    _152 = ((_cbSharedPerViewData_raw[41u].y) * _143) + (_cbSharedPerViewData_raw[41u].w);
    [branch]
    if (_134.x > 0.0f) {
      _155 = srvGlobalGBuffer1.Load(int3(_80, _81, 0));
      _159 = srvGlobalGBuffer2.Load(int3(_80, _81, 0));
      _165 = srvGlobalGBuffer3.Load(int3(_80, _81, 0));
      _169 = srvGlobalGBuffer4.Load(int3(_80, _81, 0));
      _176 = saturate(_159.x);
      _177 = saturate(_159.y);
      _178 = saturate(_159.z);
      _181 = saturate(_165.z);
      _183 = saturate(_169.y);
      _188 = (saturate(_155.x) * 2.0f) + -1.0f;
      _189 = (saturate(_155.y) * 2.0f) + -1.0f;
      _193 = (1.0f - abs(_188)) - abs(_189);
      _195 = saturate(-0.0f - _193);
      _196 = -0.0f - _195;
      _201 = select((_188 >= 0.0f), _196, _195) + _188;
      _202 = select((_189 >= 0.0f), _196, _195) + _189;
      _204 = rsqrt(dot(float3(_201, _202, _193), float3(_201, _202, _193)));
      _205 = _201 * _204;
      _206 = -0.0f - _205;
      _207 = _202 * _204;
      _208 = -0.0f - _207;
      _209 = _204 * _193;
      _210 = -0.0f - _209;
      _217 = (((int)(uint(saturate(_169.w) * 255.0f)) & 64) != 0);
      _219 = saturate(_165.x);
      _220 = saturate(_165.y) * 0.07999999821186066f;
      _227 = (_219 * (_176 - _220)) + _220;
      _228 = (_219 * (_177 - _220)) + _220;
      _229 = (_219 * (_178 - _220)) + _220;
      _231 = min(1.0f, max(saturate(_169.x), 0.019999999552965164f));
      _233 = min(1.0f, max(saturate(_169.z), 0.019999999552965164f));
      _234 = _183 * _183;
      _237 = (_219 * (1.0f - _220)) + _220;
      _243 = 1.0f / (((_cbSharedPerViewData_raw[36u].z) * _134.x) - (_cbSharedPerViewData_raw[36u].y));
      _244 = _243 * _151;
      _245 = _243 * _152;
      _246 = -0.0f - _243;
      _248 = (((int)(uint((saturate(_159.w) * 255.0f) + 0.5f)) & 192) == 128);
      _249 = 1.0f - _219;
      _253 = -0.0f - _151;
      _254 = -0.0f - _152;
      _256 = rsqrt(dot(float3(_253, _254, 1.0f), float3(_253, _254, 1.0f)));
      _257 = _256 * _253;
      _258 = _256 * _254;
      _266 = srvLightDeferredRoomTiles[((int)(((int)(uint(_cbSharedPerViewData_raw[43u].z)) * _81) + _80))];
      _267 = _266 & 255;
      _268 = (uint)(_266) >> 8;
      _269 = _268 & 255;
      _273 = ((float)((uint)((uint)(((uint)(_266) >> 16) & 255)))) * 0.003921568859368563f;
      _275 = (float)((uint)((uint)((uint)(_266) >> 24)));
      _276 = _275 * 0.003921568859368563f;
      [branch]
      if (!(_248 || ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 1) == 0))) {
        _286 = _233 * 4.0f;
        _291 = dot(float3((-0.0f - _257), (-0.0f - _258), (-0.0f - _256)), float3(_205, _207, _209)) * 2.0f;
        _295 = _233 * _233;
        _296 = 1.0f - _295;
        _299 = (sqrt(_296) + _295) * _296;
        _309 = (_299 * ((_206 - _257) - (_291 * _205))) + _205;
        _310 = (_299 * ((_208 - _258) - (_291 * _207))) + _207;
        _311 = (_299 * ((_210 - _256) - (_291 * _209))) + _209;
        _315 = saturate(1.0f - ((_233 + -0.30000001192092896f) * 3.3333332538604736f));
        _330 = mad((_cbSharedPerViewData_raw[12u].z), _311, mad((_cbSharedPerViewData_raw[12u].y), _310, (_309 * (_cbSharedPerViewData_raw[12u].x))));
        _333 = mad((_cbSharedPerViewData_raw[13u].z), _311, mad((_cbSharedPerViewData_raw[13u].y), _310, ((_cbSharedPerViewData_raw[13u].x) * _309)));
        _336 = mad((_cbSharedPerViewData_raw[14u].z), _311, mad((_cbSharedPerViewData_raw[14u].y), _310, ((_cbSharedPerViewData_raw[14u].x) * _309)));
        _339 = mad((_cbSharedPerViewData_raw[12u].z), _209, mad((_cbSharedPerViewData_raw[12u].y), _207, ((_cbSharedPerViewData_raw[12u].x) * _205)));
        _342 = mad((_cbSharedPerViewData_raw[13u].z), _209, mad((_cbSharedPerViewData_raw[13u].y), _207, ((_cbSharedPerViewData_raw[13u].x) * _205)));
        _345 = mad((_cbSharedPerViewData_raw[14u].z), _209, mad((_cbSharedPerViewData_raw[14u].y), _207, ((_cbSharedPerViewData_raw[14u].x) * _205)));
        if (!(_global_0 == 0)) {
          _364 = 0;
          _365 = 0.0f;
          _366 = 0.0f;
          _367 = 0.0f;
          _368 = 0.0f;
          _369 = 0.0f;
          _370 = 0.0f;
          _371 = 0.0f;
          _372 = 0.0f;
          _373 = 0.0f;
          _374 = 0.0f;
          _375 = 0.0f;
          _376 = 0.0f;
          _377 = 0.0f;
          _378 = 0.0f;
          while(true) {
            _656 = _365;
            _657 = _366;
            _658 = _367;
            _659 = _368;
            _660 = _369;
            _661 = _370;
            _662 = _371;
            _663 = _372;
            _664 = _373;
            _665 = _374;
            _666 = _375;
            _667 = _376;
            _668 = _377;
            _669 = _378;
            _381 = _global_5[min((uint)(_364), 63u)];
            _382 = _global_6[min((uint)(_364), 63u)];
            _385 = asfloat(srvLightInfoProperties.Load4(_382)).x;
            _386 = asfloat(srvLightInfoProperties.Load4(_382)).y;
            _387 = asfloat(srvLightInfoProperties.Load4(_382)).z;
            _388 = asfloat(srvLightInfoProperties.Load4(_382)).w;
            _391 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 16u)))).x;
            _392 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 16u)))).y;
            _393 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 16u)))).z;
            _394 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 16u)))).w;
            _397 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 32u)))).x;
            _398 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 32u)))).y;
            _399 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 32u)))).z;
            _400 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 32u)))).w;
            _403 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 48u)))).x;
            _404 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 48u)))).y;
            _405 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 48u)))).z;
            _406 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 48u)))).w;
            _409 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 64u)))).x;
            _410 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 64u)))).y;
            _411 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 64u)))).z;
            _412 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 64u)))).w;
            _415 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 80u)))).x;
            _416 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 80u)))).y;
            _417 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 80u)))).z;
            _418 = asfloat(srvLightInfoProperties.Load4(((int)(_382 + 80u)))).w;
            _421 = asint(srvLightInfoProperties.Load(((int)(_382 + 96u))));
            _424 = asfloat(srvLightInfoProperties.Load3(((int)(_382 + 100u)))).x;
            _425 = asfloat(srvLightInfoProperties.Load3(((int)(_382 + 100u)))).y;
            _426 = asfloat(srvLightInfoProperties.Load3(((int)(_382 + 100u)))).z;
            _429 = asfloat(srvLightInfoProperties.Load3(((int)(_382 + 112u)))).x;
            _430 = asfloat(srvLightInfoProperties.Load3(((int)(_382 + 112u)))).y;
            _431 = asfloat(srvLightInfoProperties.Load3(((int)(_382 + 112u)))).z;
            _434 = asint(srvLightInfoProperties.Load(((int)(_382 + 124u))));
            _437 = asint(srvLightInfoProperties.Load(((int)(_382 + 128u))));
            _440 = _421 & 65535;
            _469 = ((saturate(1.0f - abs(mad(_387, _246, mad(_386, _245, (_385 * _244))) + _388)) * f16tof32(((uint)((uint)(_421) >> 16)))) * saturate(1.0f - abs(mad(_393, _246, mad(_392, _245, (_391 * _244))) + _394))) * saturate(1.0f - abs(mad(_399, _246, mad(_398, _245, (_397 * _244))) + _400));
            [branch]
            if (_469 > 0.0f) {
              _472 = _469 * _469;
              [branch]
              if (_315 < 1.0f) {
                _475 = (float)((uint)_440);
                _476 = -0.0f - _330;
                [branch]
                if (!(_475 >= 341.0f)) {
                  _488 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_476, _333, _336, _475), _286);
                  _493 = _488.x;
                  _494 = _488.y;
                  _495 = _488.z;
                } else {
                  _482 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_476, _333, _336, (_475 + -341.0f)), _286);
                  _493 = _482.x;
                  _494 = _482.y;
                  _495 = _482.z;
                }
              } else {
                _493 = 0.0f;
                _494 = 0.0f;
                _495 = 0.0f;
              }
              _497 = (float)((uint)_440);
              [branch]
              if (_315 > 0.0f) {
                _501 = mad(_405, _311, mad(_404, _310, (_403 * _309)));
                _504 = mad(_411, _311, mad(_410, _310, (_409 * _309)));
                _507 = mad(_417, _311, mad(_416, _310, (_415 * _309)));
                _548 = min(((((float((int)(((int)(uint)((int)(_501 > 0.0f))) - ((int)(uint)((int)(_501 < 0.0f))))) * _424) - _406) - mad(_405, _246, mad(_404, _245, (_403 * _244)))) / _501), min(((((float((int)(((int)(uint)((int)(_504 > 0.0f))) - ((int)(uint)((int)(_504 < 0.0f))))) * _425) - _412) - mad(_411, _246, mad(_410, _245, (_409 * _244)))) / _504), ((((float((int)(((int)(uint)((int)(_507 > 0.0f))) - ((int)(uint)((int)(_507 < 0.0f))))) * _426) - _418) - mad(_417, _246, mad(_416, _245, (_415 * _244)))) / _507)));
                _553 = ((mad((_cbSharedPerViewData_raw[12u].z), _246, mad((_cbSharedPerViewData_raw[12u].y), _245, ((_cbSharedPerViewData_raw[12u].x) * _244))) + (_cbSharedPerViewData_raw[12u].w)) - _429) + (_548 * _330);
                _555 = ((mad((_cbSharedPerViewData_raw[13u].z), _246, mad((_cbSharedPerViewData_raw[13u].y), _245, ((_cbSharedPerViewData_raw[13u].x) * _244))) + (_cbSharedPerViewData_raw[13u].w)) - _430) + (_548 * _333);
                _557 = ((mad((_cbSharedPerViewData_raw[14u].z), _246, mad((_cbSharedPerViewData_raw[14u].y), _245, ((_cbSharedPerViewData_raw[14u].x) * _244))) + (_cbSharedPerViewData_raw[14u].w)) - _431) + (_548 * _336);
                _564 = (max(log2((_548 * _548) / dot(float3(_553, _555, _557), float3(_553, _555, _557))), -1.0f) * 0.3333333432674408f) + _286;
                _565 = -0.0f - _553;
                [branch]
                if (!(_497 >= 341.0f)) {
                  _577 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_565, _555, _557, _497), _564);
                  _582 = _577.x;
                  _583 = _577.y;
                  _584 = _577.z;
                } else {
                  _571 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_565, _555, _557, (_497 + -341.0f)), _564);
                  _582 = _571.x;
                  _583 = _571.y;
                  _584 = _571.z;
                }
              } else {
                _582 = 0.0f;
                _583 = 0.0f;
                _584 = 0.0f;
              }
              _585 = -0.0f - _339;
              [branch]
              if (!(_497 >= 341.0f)) {
                _597 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_585, _342, _345, _497), 0.0f);
                _602 = _597.x;
                _603 = _597.y;
                _604 = _597.z;
              } else {
                _591 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_585, _342, _345, (_497 + -341.0f)), 0.0f);
                _602 = _591.x;
                _603 = _591.y;
                _604 = _591.z;
              }
              _614 = _472 * f16tof32(((uint)((uint)(_434) >> 16)));
              _615 = _614 * _602;
              _616 = _472 * f16tof32(_434);
              _617 = _616 * _603;
              _618 = _472 * f16tof32(((uint)((uint)(_437) >> 16)));
              _619 = _618 * _604;
              _620 = _614 * (lerp(_493, _582, _315));
              _621 = _616 * (lerp(_494, _583, _315));
              _622 = _618 * (lerp(_495, _584, _315));
              [branch]
              if (!((_381 & ((int)(1 << (_266 & 31)))) == 0)) {
                _636 = (_615 + _365);
                _637 = (_617 + _366);
                _638 = (_619 + _367);
                _639 = (_620 + _368);
                _640 = (_621 + _369);
                _641 = (_622 + _370);
                _642 = (_472 + _371);
              } else {
                _636 = _365;
                _637 = _366;
                _638 = _367;
                _639 = _368;
                _640 = _369;
                _641 = _370;
                _642 = _371;
              }
              [branch]
              if (!((_381 & ((int)(1 << (_268 & 31)))) == 0)) {
                _656 = _636;
                _657 = _637;
                _658 = _638;
                _659 = _639;
                _660 = _640;
                _661 = _641;
                _662 = _642;
                _663 = (_615 + _372);
                _664 = (_617 + _373);
                _665 = (_619 + _374);
                _666 = (_620 + _375);
                _667 = (_621 + _376);
                _668 = (_622 + _377);
                _669 = (_472 + _378);
              } else {
                _656 = _636;
                _657 = _637;
                _658 = _638;
                _659 = _639;
                _660 = _640;
                _661 = _641;
                _662 = _642;
                _663 = _372;
                _664 = _373;
                _665 = _374;
                _666 = _375;
                _667 = _376;
                _668 = _377;
                _669 = _378;
              }
            } else {
              _656 = _365;
              _657 = _366;
              _658 = _367;
              _659 = _368;
              _660 = _369;
              _661 = _370;
              _662 = _371;
              _663 = _372;
              _664 = _373;
              _665 = _374;
              _666 = _375;
              _667 = _376;
              _668 = _377;
              _669 = _378;
            }
            _670 = _364 + 1u;
            if (!(_670 == _global_0)) {
              _364 = _670;
              _365 = _656;
              _366 = _657;
              _367 = _658;
              _368 = _659;
              _369 = _660;
              _370 = _661;
              _371 = _662;
              _372 = _663;
              _373 = _664;
              _374 = _665;
              _375 = _666;
              _376 = _667;
              _377 = _668;
              _378 = _669;
              continue;
            }
            _674 = _656;
            _675 = _657;
            _676 = _658;
            _677 = _659;
            _678 = _660;
            _679 = _661;
            _680 = _662;
            _681 = _663;
            _682 = _664;
            _683 = _665;
            _684 = _666;
            _685 = _667;
            _686 = _668;
            _687 = _669;
            break;
          }
        } else {
          _674 = 0.0f;
          _675 = 0.0f;
          _676 = 0.0f;
          _677 = 0.0f;
          _678 = 0.0f;
          _679 = 0.0f;
          _680 = 0.0f;
          _681 = 0.0f;
          _682 = 0.0f;
          _683 = 0.0f;
          _684 = 0.0f;
          _685 = 0.0f;
          _686 = 0.0f;
          _687 = 0.0f;
        }
        _693 = ((asint(_cbSharedPerViewData_raw_uint[80u].y) & ((int)(1 << (_266 & 31)))) != 0);
        if ((_273 > 0.0f) || ((_276 > 0.0f) || _693)) {
          _703 = srvFallbackInfo[((_267 << 2) | 3)].x;
          _705 = select(_693, 9.999999747378752e-05f, (_275 * 3.921568847431445e-09f));
          _706 = _680 * 0.20000000298023224f;
          _713 = saturate((_705 - _706) / (((_680 * 0.4000000059604645f) + 9.99999993922529e-09f) - _706)) * _705;
          [branch]
          if (_713 > 0.0f) {
            [branch]
            if ((int)_703 > (int)-1) {
              _718 = float((int)(_703));
              _719 = -0.0f - _330;
              _720 = !(_718 >= 341.0f);
              [branch]
              if (_720) {
                _731 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_719, _333, _336, _718), _286);
                _736 = _731.x;
                _737 = _731.y;
                _738 = _731.z;
              } else {
                _725 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_719, _333, _336, (_718 + -341.0f)), _286);
                _736 = _725.x;
                _737 = _725.y;
                _738 = _725.z;
              }
              _742 = -0.0f - _339;
              [branch]
              if (_720) {
                _753 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_742, _342, _345, _718), 0.0f);
                _758 = _753.x;
                _759 = _753.y;
                _760 = _753.z;
              } else {
                _747 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_742, _342, _345, (_718 + -341.0f)), 0.0f);
                _758 = _747.x;
                _759 = _747.y;
                _760 = _747.z;
              }
              _771 = ((_736 * _713) + _677);
              _772 = ((_737 * _713) + _678);
              _773 = ((_738 * _713) + _679);
              _774 = ((_758 * _713) + _674);
              _775 = ((_759 * _713) + _675);
              _776 = ((_760 * _713) + _676);
            } else {
              _771 = _677;
              _772 = _678;
              _773 = _679;
              _774 = _674;
              _775 = _675;
              _776 = _676;
            }
            _779 = (_713 + _680);
            _780 = _771;
            _781 = _772;
            _782 = _773;
            _783 = _774;
            _784 = _775;
            _785 = _776;
          } else {
            _779 = _680;
            _780 = _677;
            _781 = _678;
            _782 = _679;
            _783 = _674;
            _784 = _675;
            _785 = _676;
          }
          if (_779 > 0.0f) {
            _791 = ((_cbSharedPerViewData_raw[61u].x) * _273) / _779;
            _799 = (_791 * _783);
            _800 = (_791 * _784);
            _801 = (_791 * _785);
            _802 = (_791 * _780);
            _803 = (_791 * _781);
            _804 = (_791 * _782);
          } else {
            _799 = 0.0f;
            _800 = 0.0f;
            _801 = 0.0f;
            _802 = 0.0f;
            _803 = 0.0f;
            _804 = 0.0f;
          }
        } else {
          _799 = 0.0f;
          _800 = 0.0f;
          _801 = 0.0f;
          _802 = 0.0f;
          _803 = 0.0f;
          _804 = 0.0f;
        }
        [branch]
        if (!(_276 == 0.0f)) {
          _811 = srvFallbackInfo[((_269 << 2) | 3)].x;
          _812 = _275 * 3.921568847431445e-09f;
          [branch]
          if ((int)_811 > (int)-1) {
            _815 = float((int)(_811));
            _816 = -0.0f - _330;
            _817 = !(_815 >= 341.0f);
            [branch]
            if (_817) {
              _828 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_816, _333, _336, _815), _286);
              _833 = _828.x;
              _834 = _828.y;
              _835 = _828.z;
            } else {
              _822 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_816, _333, _336, (_815 + -341.0f)), _286);
              _833 = _822.x;
              _834 = _822.y;
              _835 = _822.z;
            }
            _839 = -0.0f - _339;
            [branch]
            if (_817) {
              _850 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_839, _342, _345, _815), 0.0f);
              _855 = _850.x;
              _856 = _850.y;
              _857 = _850.z;
            } else {
              _844 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_839, _342, _345, (_815 + -341.0f)), 0.0f);
              _855 = _844.x;
              _856 = _844.y;
              _857 = _844.z;
            }
            _868 = ((_833 * _812) + _684);
            _869 = ((_834 * _812) + _685);
            _870 = ((_835 * _812) + _686);
            _871 = ((_855 * _812) + _681);
            _872 = ((_856 * _812) + _682);
            _873 = ((_857 * _812) + _683);
          } else {
            _868 = _684;
            _869 = _685;
            _870 = _686;
            _871 = _681;
            _872 = _682;
            _873 = _683;
          }
          _878 = ((_cbSharedPerViewData_raw[61u].x) * _276) / (_687 + _812);
          _892 = ((_878 * _871) + _799);
          _893 = ((_878 * _872) + _800);
          _894 = ((_878 * _873) + _801);
          _895 = ((_878 * _868) + _802);
          _896 = ((_878 * _869) + _803);
          _897 = ((_878 * _870) + _804);
        } else {
          _892 = _799;
          _893 = _800;
          _894 = _801;
          _895 = _802;
          _896 = _803;
          _897 = _804;
        }
      } else {
        _892 = 0.0f;
        _893 = 0.0f;
        _894 = 0.0f;
        _895 = 0.0f;
        _896 = 0.0f;
        _897 = 0.0f;
      }
      [branch]
      if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 16384) == 0)) {
        if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2) == 0)) {
          _924 = mad((_cbSharedPerViewData_raw[12u].z), _246, mad((_cbSharedPerViewData_raw[12u].y), _245, ((_cbSharedPerViewData_raw[12u].x) * _244))) + (_cbSharedPerViewData_raw[12u].w);
          _928 = mad((_cbSharedPerViewData_raw[13u].z), _246, mad((_cbSharedPerViewData_raw[13u].y), _245, ((_cbSharedPerViewData_raw[13u].x) * _244))) + (_cbSharedPerViewData_raw[13u].w);
          _932 = mad((_cbSharedPerViewData_raw[14u].z), _246, mad((_cbSharedPerViewData_raw[14u].y), _245, ((_cbSharedPerViewData_raw[14u].x) * _244))) + (_cbSharedPerViewData_raw[14u].w);
          _935 = mad((_cbSharedPerViewData_raw[12u].z), _209, mad((_cbSharedPerViewData_raw[12u].y), _207, ((_cbSharedPerViewData_raw[12u].x) * _205)));
          _938 = mad((_cbSharedPerViewData_raw[13u].z), _209, mad((_cbSharedPerViewData_raw[13u].y), _207, ((_cbSharedPerViewData_raw[13u].x) * _205)));
          _941 = mad((_cbSharedPerViewData_raw[14u].z), _209, mad((_cbSharedPerViewData_raw[14u].y), _207, ((_cbSharedPerViewData_raw[14u].x) * _205)));
          _946 = asint(_cbSharedPerViewData_raw_uint[((uint)(((uint)((int)min((uint)(((uint)(_267) >> 2)), (uint)(7)))) + 110u))]);
          _53[0] = _946.x;
          _53[1] = _946.y;
          _53[2] = _946.z;
          _53[3] = _946.w;
          _961 = asint(_cbSharedPerViewData_raw_uint[((uint)(((uint)((int)min((uint)(((uint)(_269) >> 2)), (uint)(7)))) + 110u))]);
          _52[0] = _961.x;
          _52[1] = _961.y;
          _52[2] = _961.z;
          _52[3] = _961.w;
          if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 8) == 0)) {
            _976 = 0.0f;
            _977 = 0.0f;
            _978 = 0.0f;
            _979 = 1.0f;
            _980 = 0;
            while(true) {
              _1782 = _976;
              _1783 = _977;
              _1784 = _978;
              _1785 = _979;
              if (((asint(_cbSharedPerViewData_raw_uint[141u].x) & 65536) == 0) || (_980 == asint(_cbSharedPerViewData_raw_uint[141u].y))) {
                _990 = _cbSharedPerViewData_raw[((int)(_980 + 120))];
                _995 = _cbSharedPerViewData_raw[((int)(_980 + 124))];
                _1000 = _cbSharedPerViewData_raw[((int)(_980 + 128))];
                _1027 = min(min(saturate(_1000.x * (_924 - _990.x)), min(saturate(_1000.y * (_928 - _990.y)), saturate(_1000.z * (_932 - _990.z)))), min(saturate((_995.x - _924) * _1000.x), min(saturate((_995.y - _928) * _1000.y), saturate((_995.z - _932) * _1000.z)))) * _979;
                [branch]
                if (_1027 > 0.0f) {
                  if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1) == 0)) {
                    _55[0] = (_cbSharedPerViewData_raw[119u].x);
                    _55[1] = (_cbSharedPerViewData_raw[119u].y);
                    _55[2] = (_cbSharedPerViewData_raw[119u].z);
                    _55[3] = (_cbSharedPerViewData_raw[119u].w);
                    _1048 = _55[min((uint)(_980), 3u)];
                    _1056 = ((((_cbSharedPerViewData_raw[140u].y) * _935) * _1048) + _924);
                    _1057 = ((((_cbSharedPerViewData_raw[140u].y) * _938) * _1048) + _928);
                    _1058 = ((((_cbSharedPerViewData_raw[140u].y) * _941) * _1048) + _932);
                  } else {
                    _1056 = _924;
                    _1057 = _928;
                    _1058 = _932;
                  }
                  _54[0] = (_cbSharedPerViewData_raw[134u].x);
                  _54[1] = (_cbSharedPerViewData_raw[134u].y);
                  _54[2] = (_cbSharedPerViewData_raw[134u].z);
                  _54[3] = (_cbSharedPerViewData_raw[134u].w);
                  _1069 = _54[min((uint)(_980), 3u)];
                  _1073 = _980 + 136;
                  _1074 = _cbSharedPerViewData_raw[_1073];
                  _1078 = _1074.x + (_1069 * _1056);
                  _1079 = _1074.y + (_1069 * _1057);
                  _1080 = _1074.z + (_1069 * _1058);
                  _1093 = 0.0f;
                  _1094 = 0.0f;
                  _1095 = 0.0f;
                  _1096 = 0.0f;
                  _1097 = 0;
                  _1098 = 0;
                  while(true) {
                    _1737 = _1097;
                    _1099 = _1098 & 1;
                    _1101 = ((uint)(_1098) >> 1) & 1;
                    _1103 = ((uint)(_1098) >> 2) & 1;
                    _1107 = _1099 + uint(floor(_1078));
                    _1108 = _1101 + uint(floor(_1079));
                    _1109 = _1103 + uint(floor(_1080));
                    _1117 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[118u].x)) + (uint)(-1))) & _1107;
                    _1118 = _1108 & ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[118u].y)) + (uint)(-1)));
                    _1121 = ((uint)(_1109 & ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[118u].z)) + (uint)(-1))))) + (asint(_cbSharedPerViewData_raw_uint[118u].z) * _980);
                    _1127 = uint(((((float4)(srvGIProbeClipMapRoomIDs.Load(int4(_1117, _1118, _1121, 0)))).x) * 65535.0f) + 0.5f);
                    _1138 = select((((((uint)(srvGIProbeClipMapFlags.Load(int4(_1117, _1118, _1121, 0)))).x) & 1) != 0), 1.0f, 0.0f) * select((_1127 == (_53[min((uint)((_266 & 3)), 3u)])), _273, select((_1127 == (_52[min((uint)((_268 & 3)), 3u)])), _276, 0.0f));
                    if (!(_1138 == 0.0f)) {
                      _1144 = _cbSharedPerViewData_raw[_1073];
                      _56[0] = (_cbSharedPerViewData_raw[135u].x);
                      _56[1] = (_cbSharedPerViewData_raw[135u].y);
                      _56[2] = (_cbSharedPerViewData_raw[135u].z);
                      _56[3] = (_cbSharedPerViewData_raw[135u].w);
                      _1161 = _56[min((uint)(_980), 3u)];
                      _57[0] = (_cbSharedPerViewData_raw[119u].x);
                      _57[1] = (_cbSharedPerViewData_raw[119u].y);
                      _57[2] = (_cbSharedPerViewData_raw[119u].z);
                      _57[3] = (_cbSharedPerViewData_raw[119u].w);
                      _1175 = _57[min((uint)(_980), 3u)];
                      _1177 = srvGIProbeBakeOffsets.Load(int4(_1117, _1118, _1121, 0));
                      _1187 = ((_1177.x + -0.5f) * _1175) + ((((float)((uint)_1107)) - _1144.x) * _1161);
                      _1188 = ((_1177.y + -0.5f) * _1175) + ((((float)((uint)_1108)) - _1144.y) * _1161);
                      _1189 = ((_1177.z + -0.5f) * _1175) + ((((float)((uint)_1109)) - _1144.z) * _1161);
                      _1194 = (float)((uint)_1117);
                      _1195 = (float)((uint)_1118);
                      if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1) == 0) {
                        _1395 = 1.0f;
                        _1400 = (abs(_938) + abs(_935)) + abs(_941);
                        _1401 = _935 / _1400;
                        _1402 = _938 / _1400;
                        if (!((_941 / _1400) >= 0.0f)) {
                          _1417 = ((1.0f - abs(_1402)) * select((_1401 >= 0.0f), 1.0f, -1.0f));
                          _1418 = ((1.0f - abs(_1401)) * select((_1402 >= 0.0f), 1.0f, -1.0f));
                        } else {
                          _1417 = _1401;
                          _1418 = _1402;
                        }
                        _1423 = saturate((_1417 * 0.5f) + 0.5f);
                        _1424 = saturate((_1418 * 0.5f) + 0.5f);
                        _1425 = asint(_cbSharedPerViewData_raw_uint[141u].x) & 2;
                        _1426 = (_1425 != 0);
                        _1433 = _1194 * 8.0f;
                        _1434 = _1195 * 8.0f;
                        _1435 = select(_1426, _1423, ((_1423 * 0.75f) + 0.125f)) * 8.0f;
                        _1436 = select(_1426, _1424, ((_1424 * 0.75f) + 0.125f)) * 8.0f;
                        _1441 = int(floor(_1435 + 0.5f));
                        _1442 = int(floor(_1436 + 0.5f));
                        _1443 = _1441 + (uint)(-1);
                        _1444 = _1442 + (uint)(-1);
                        if (!(_1425 == 0)) {
                          _1451 = ((((int)(uint)((int)((uint)_1443 > (uint)7))) | ((uint)(_1443) >> 31)) == 0);
                          _1456 = ((((int)(uint)((int)((uint)_1444 > (uint)7))) | ((uint)(_1444) >> 31)) == 0);
                          _1457 = 8u - _1441;
                          _1459 = 8u - _1442;
                          _1469 = ((((int)(uint)((int)((uint)_1441 > (uint)7))) | ((uint)(_1441) >> 31)) == 0);
                          _1470 = 7u - _1441;
                          _1481 = ((((int)(uint)((int)((uint)_1442 > (uint)7))) | ((uint)(_1442) >> 31)) == 0);
                          _1483 = 7u - _1442;
                          _1496 = min((int)(max((int)(select(_1481, _1441, _1470)), (int)(0))), (int)(7));
                          _1497 = min((int)(max((int)(select(_1481, _1443, _1457)), (int)(0))), (int)(7));
                          _1498 = min((int)(max((int)(select(_1456, _1441, _1470)), (int)(0))), (int)(7));
                          _1499 = min((int)(max((int)(select(_1456, _1443, _1457)), (int)(0))), (int)(7));
                          _1500 = min((int)(max((int)(select(_1469, _1442, _1483)), (int)(0))), (int)(7));
                          _1501 = min((int)(max((int)(select(_1451, _1442, _1483)), (int)(0))), (int)(7));
                          _1502 = min((int)(max((int)(select(_1469, _1444, _1459)), (int)(0))), (int)(7));
                          _1503 = min((int)(max((int)(select(_1451, _1444, _1459)), (int)(0))), (int)(7));
                        } else {
                          _1496 = _1441;
                          _1497 = _1443;
                          _1498 = _1441;
                          _1499 = _1443;
                          _1500 = _1442;
                          _1501 = _1442;
                          _1502 = _1444;
                          _1503 = _1444;
                        }
                        _1511 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1499)) + _1433), int(float((int)(_1503)) + _1434), _1121, 0));
                        _1521 = ((float)((uint)((uint)(_1511.x & 511)))) * 0.001956947147846222f;
                        _1522 = ((float)((uint)((uint)(((uint)((uint)(_1511.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _1523 = ((float)((uint)((uint)(((uint)((uint)(_1511.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _1527 = exp2(float((int)(((uint)((uint)(_1511.x)) >> 27) + -15)));
                        _1529 = (_1521 * _1521) * _1527;
                        _1531 = (_1522 * _1522) * _1527;
                        _1533 = (_1523 * _1523) * _1527;
                        _1540 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1498)) + _1433), int(float((int)(_1502)) + _1434), _1121, 0));
                        _1550 = ((float)((uint)((uint)(_1540.x & 511)))) * 0.001956947147846222f;
                        _1551 = ((float)((uint)((uint)(((uint)((uint)(_1540.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _1552 = ((float)((uint)((uint)(((uint)((uint)(_1540.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _1556 = exp2(float((int)(((uint)((uint)(_1540.x)) >> 27) + -15)));
                        _1558 = (_1550 * _1550) * _1556;
                        _1560 = (_1551 * _1551) * _1556;
                        _1562 = (_1552 * _1552) * _1556;
                        _1569 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1497)) + _1433), int(float((int)(_1501)) + _1434), _1121, 0));
                        _1579 = ((float)((uint)((uint)(_1569.x & 511)))) * 0.001956947147846222f;
                        _1580 = ((float)((uint)((uint)(((uint)((uint)(_1569.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _1581 = ((float)((uint)((uint)(((uint)((uint)(_1569.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _1585 = exp2(float((int)(((uint)((uint)(_1569.x)) >> 27) + -15)));
                        _1587 = (_1579 * _1579) * _1585;
                        _1589 = (_1580 * _1580) * _1585;
                        _1591 = (_1581 * _1581) * _1585;
                        _1598 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1496)) + _1433), int(float((int)(_1500)) + _1434), _1121, 0));
                        _1608 = ((float)((uint)((uint)(_1598.x & 511)))) * 0.001956947147846222f;
                        _1609 = ((float)((uint)((uint)(((uint)((uint)(_1598.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _1610 = ((float)((uint)((uint)(((uint)((uint)(_1598.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _1614 = exp2(float((int)(((uint)((uint)(_1598.x)) >> 27) + -15)));
                        _1616 = (_1608 * _1608) * _1614;
                        _1618 = (_1609 * _1609) * _1614;
                        _1620 = (_1610 * _1610) * _1614;
                        if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 256) == 0) {
                          _1639 = frac(_1435 + -0.5f);
                          _1640 = frac(_1436 + -0.5f);
                          _1647 = (_1639 * (_1558 - _1529)) + _1529;
                          _1648 = (_1639 * (_1560 - _1531)) + _1531;
                          _1649 = (_1639 * (_1562 - _1533)) + _1533;
                          _1669 = (((((_1639 * (_1616 - _1587)) + _1587) - _1647) * _1640) + _1647);
                          _1670 = (((((_1639 * (_1618 - _1589)) + _1589) - _1648) * _1640) + _1648);
                          _1671 = (((((_1639 * (_1620 - _1591)) + _1591) - _1649) * _1640) + _1649);
                        } else {
                          _1669 = ((((_1558 + _1529) + _1587) + _1616) * 0.25f);
                          _1670 = ((((_1560 + _1531) + _1589) + _1618) * 0.25f);
                          _1671 = ((((_1562 + _1533) + _1591) + _1620) * 0.25f);
                        }
                        _1674 = (_cbSharedPerViewData_raw[61u].x) * _1669;
                        _1675 = (_cbSharedPerViewData_raw[61u].x) * _1670;
                        _1676 = (_cbSharedPerViewData_raw[61u].x) * _1671;
                        _1687 = (((1.0f - frac(_1079)) - ((float)((uint)_1101))) * ((1.0f - frac(_1078)) - ((float)((uint)_1099)))) * ((1.0f - frac(_1080)) - ((float)((uint)_1103)));
                        _1695 = (_1395 * _1138) * select(((mad(_1103, _1103, mad(_1101, _1101, _1099)) & 1) != 0), (-0.0f - _1687), _1687);
                        if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 512) == 0)) {
                          _1699 = _1187 - _1056;
                          _1700 = _1188 - _1057;
                          _1701 = _1189 - _1058;
                          _1703 = rsqrt(dot(float3(_1699, _1700, _1701), float3(_1699, _1700, _1701)));
                          _1713 = (saturate((dot(float3((_1703 * _1699), (_1703 * _1700), (_1703 * _1701)), float3(_935, _938, _941)) * 0.5f) + 0.5f) * _1695);
                        } else {
                          _1713 = _1695;
                        }
                        if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0)) {
                          _1721 = sqrt(_1674);
                          _1722 = sqrt(_1675);
                          _1723 = sqrt(_1676);
                        } else {
                          _1721 = _1674;
                          _1722 = _1675;
                          _1723 = _1676;
                        }
                        _1733 = ((_1721 * _1713) + _1093);
                        _1734 = ((_1722 * _1713) + _1094);
                        _1735 = ((_1723 * _1713) + _1095);
                        _1736 = (_1713 + _1096);
                        _1737 = ((int)(_1097 + 1u));
                      } else {
                        _1197 = _1056 - _1187;
                        _1198 = _1057 - _1188;
                        _1199 = _1058 - _1189;
                        _1201 = rsqrt(dot(float3(_1197, _1198, _1199), float3(_1197, _1198, _1199)));
                        _1202 = _1201 * _1197;
                        _1203 = _1201 * _1198;
                        _1204 = _1201 * _1199;
                        _1209 = (abs(_1203) + abs(_1202)) + abs(_1204);
                        _1210 = _1202 / _1209;
                        _1211 = _1203 / _1209;
                        if (!((_1204 / _1209) >= 0.0f)) {
                          _1226 = ((1.0f - abs(_1211)) * select((_1210 >= 0.0f), 1.0f, -1.0f));
                          _1227 = ((1.0f - abs(_1210)) * select((_1211 >= 0.0f), 1.0f, -1.0f));
                        } else {
                          _1226 = _1210;
                          _1227 = _1211;
                        }
                        _1232 = saturate((_1226 * 0.5f) + 0.5f);
                        _1233 = saturate((_1227 * 0.5f) + 0.5f);
                        _1234 = asint(_cbSharedPerViewData_raw_uint[141u].x) & 2;
                        _1235 = (_1234 != 0);
                        _1242 = _1194 * 8.0f;
                        _1243 = _1195 * 8.0f;
                        _1244 = select(_1235, _1232, ((_1232 * 0.75f) + 0.125f)) * 8.0f;
                        _1245 = select(_1235, _1233, ((_1233 * 0.75f) + 0.125f)) * 8.0f;
                        _1250 = int(floor(_1244 + 0.5f));
                        _1251 = int(floor(_1245 + 0.5f));
                        _1252 = _1250 + (uint)(-1);
                        _1253 = _1251 + (uint)(-1);
                        if (!(_1234 == 0)) {
                          _1260 = ((((int)(uint)((int)((uint)_1252 > (uint)7))) | ((uint)(_1252) >> 31)) == 0);
                          _1265 = ((((int)(uint)((int)((uint)_1253 > (uint)7))) | ((uint)(_1253) >> 31)) == 0);
                          _1266 = 8u - _1250;
                          _1268 = 8u - _1251;
                          _1278 = ((((int)(uint)((int)((uint)_1250 > (uint)7))) | ((uint)(_1250) >> 31)) == 0);
                          _1279 = 7u - _1250;
                          _1290 = ((((int)(uint)((int)((uint)_1251 > (uint)7))) | ((uint)(_1251) >> 31)) == 0);
                          _1292 = 7u - _1251;
                          _1305 = min((int)(max((int)(select(_1290, _1250, _1279)), (int)(0))), (int)(7));
                          _1306 = min((int)(max((int)(select(_1290, _1252, _1266)), (int)(0))), (int)(7));
                          _1307 = min((int)(max((int)(select(_1265, _1250, _1279)), (int)(0))), (int)(7));
                          _1308 = min((int)(max((int)(select(_1265, _1252, _1266)), (int)(0))), (int)(7));
                          _1309 = min((int)(max((int)(select(_1278, _1251, _1292)), (int)(0))), (int)(7));
                          _1310 = min((int)(max((int)(select(_1260, _1251, _1292)), (int)(0))), (int)(7));
                          _1311 = min((int)(max((int)(select(_1278, _1253, _1268)), (int)(0))), (int)(7));
                          _1312 = min((int)(max((int)(select(_1260, _1253, _1268)), (int)(0))), (int)(7));
                        } else {
                          _1305 = _1250;
                          _1306 = _1252;
                          _1307 = _1250;
                          _1308 = _1252;
                          _1309 = _1251;
                          _1310 = _1251;
                          _1311 = _1253;
                          _1312 = _1253;
                        }
                        _1320 = srvGIProbeDepthOct.Load(int4(int(float((int)(_1308)) + _1242), int(float((int)(_1312)) + _1243), _1121, 0));
                        _1328 = srvGIProbeDepthOct.Load(int4(int(float((int)(_1307)) + _1242), int(float((int)(_1311)) + _1243), _1121, 0));
                        _1336 = srvGIProbeDepthOct.Load(int4(int(float((int)(_1306)) + _1242), int(float((int)(_1310)) + _1243), _1121, 0));
                        _1344 = srvGIProbeDepthOct.Load(int4(int(float((int)(_1305)) + _1242), int(float((int)(_1309)) + _1243), _1121, 0));
                        if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 256) == 0) {
                          _1356 = frac(_1244 + -0.5f);
                          _1360 = (_1356 * (_1328.x - _1320.x)) + _1320.x;
                          _1368 = (((((_1356 * (_1344.x - _1336.x)) + _1336.x) - _1360) * frac(_1245 + -0.5f)) + _1360);
                        } else {
                          _1368 = ((((_1328.x + _1320.x) + _1336.x) + _1344.x) * 0.25f);
                        }
                        _1370 = (_1175 * 1.7319999933242798f) * _1368;
                        _1371 = _1187 - _1056;
                        _1372 = _1188 - _1057;
                        _1373 = _1189 - _1058;
                        _1382 = (_cbSharedPerViewData_raw[140u].z) * _1175;
                        _1385 = sqrt(((_1371 * _1371) + (_1372 * _1372)) + (_1373 * _1373)) - ((_cbSharedPerViewData_raw[140u].x) * _1175);
                        if (!(_1370 < (_1385 - _1382))) {
                          _1392 = 1.0f - saturate((_1385 - _1370) / _1382);
                          if (!(_1392 == 0.0f)) {
                            _1395 = _1392;
                            _1400 = (abs(_938) + abs(_935)) + abs(_941);
                            _1401 = _935 / _1400;
                            _1402 = _938 / _1400;
                            if (!((_941 / _1400) >= 0.0f)) {
                              _1417 = ((1.0f - abs(_1402)) * select((_1401 >= 0.0f), 1.0f, -1.0f));
                              _1418 = ((1.0f - abs(_1401)) * select((_1402 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _1417 = _1401;
                              _1418 = _1402;
                            }
                            _1423 = saturate((_1417 * 0.5f) + 0.5f);
                            _1424 = saturate((_1418 * 0.5f) + 0.5f);
                            _1425 = asint(_cbSharedPerViewData_raw_uint[141u].x) & 2;
                            _1426 = (_1425 != 0);
                            _1433 = _1194 * 8.0f;
                            _1434 = _1195 * 8.0f;
                            _1435 = select(_1426, _1423, ((_1423 * 0.75f) + 0.125f)) * 8.0f;
                            _1436 = select(_1426, _1424, ((_1424 * 0.75f) + 0.125f)) * 8.0f;
                            _1441 = int(floor(_1435 + 0.5f));
                            _1442 = int(floor(_1436 + 0.5f));
                            _1443 = _1441 + (uint)(-1);
                            _1444 = _1442 + (uint)(-1);
                            if (!(_1425 == 0)) {
                              _1451 = ((((int)(uint)((int)((uint)_1443 > (uint)7))) | ((uint)(_1443) >> 31)) == 0);
                              _1456 = ((((int)(uint)((int)((uint)_1444 > (uint)7))) | ((uint)(_1444) >> 31)) == 0);
                              _1457 = 8u - _1441;
                              _1459 = 8u - _1442;
                              _1469 = ((((int)(uint)((int)((uint)_1441 > (uint)7))) | ((uint)(_1441) >> 31)) == 0);
                              _1470 = 7u - _1441;
                              _1481 = ((((int)(uint)((int)((uint)_1442 > (uint)7))) | ((uint)(_1442) >> 31)) == 0);
                              _1483 = 7u - _1442;
                              _1496 = min((int)(max((int)(select(_1481, _1441, _1470)), (int)(0))), (int)(7));
                              _1497 = min((int)(max((int)(select(_1481, _1443, _1457)), (int)(0))), (int)(7));
                              _1498 = min((int)(max((int)(select(_1456, _1441, _1470)), (int)(0))), (int)(7));
                              _1499 = min((int)(max((int)(select(_1456, _1443, _1457)), (int)(0))), (int)(7));
                              _1500 = min((int)(max((int)(select(_1469, _1442, _1483)), (int)(0))), (int)(7));
                              _1501 = min((int)(max((int)(select(_1451, _1442, _1483)), (int)(0))), (int)(7));
                              _1502 = min((int)(max((int)(select(_1469, _1444, _1459)), (int)(0))), (int)(7));
                              _1503 = min((int)(max((int)(select(_1451, _1444, _1459)), (int)(0))), (int)(7));
                            } else {
                              _1496 = _1441;
                              _1497 = _1443;
                              _1498 = _1441;
                              _1499 = _1443;
                              _1500 = _1442;
                              _1501 = _1442;
                              _1502 = _1444;
                              _1503 = _1444;
                            }
                            _1511 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1499)) + _1433), int(float((int)(_1503)) + _1434), _1121, 0));
                            _1521 = ((float)((uint)((uint)(_1511.x & 511)))) * 0.001956947147846222f;
                            _1522 = ((float)((uint)((uint)(((uint)((uint)(_1511.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _1523 = ((float)((uint)((uint)(((uint)((uint)(_1511.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _1527 = exp2(float((int)(((uint)((uint)(_1511.x)) >> 27) + -15)));
                            _1529 = (_1521 * _1521) * _1527;
                            _1531 = (_1522 * _1522) * _1527;
                            _1533 = (_1523 * _1523) * _1527;
                            _1540 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1498)) + _1433), int(float((int)(_1502)) + _1434), _1121, 0));
                            _1550 = ((float)((uint)((uint)(_1540.x & 511)))) * 0.001956947147846222f;
                            _1551 = ((float)((uint)((uint)(((uint)((uint)(_1540.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _1552 = ((float)((uint)((uint)(((uint)((uint)(_1540.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _1556 = exp2(float((int)(((uint)((uint)(_1540.x)) >> 27) + -15)));
                            _1558 = (_1550 * _1550) * _1556;
                            _1560 = (_1551 * _1551) * _1556;
                            _1562 = (_1552 * _1552) * _1556;
                            _1569 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1497)) + _1433), int(float((int)(_1501)) + _1434), _1121, 0));
                            _1579 = ((float)((uint)((uint)(_1569.x & 511)))) * 0.001956947147846222f;
                            _1580 = ((float)((uint)((uint)(((uint)((uint)(_1569.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _1581 = ((float)((uint)((uint)(((uint)((uint)(_1569.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _1585 = exp2(float((int)(((uint)((uint)(_1569.x)) >> 27) + -15)));
                            _1587 = (_1579 * _1579) * _1585;
                            _1589 = (_1580 * _1580) * _1585;
                            _1591 = (_1581 * _1581) * _1585;
                            _1598 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_1496)) + _1433), int(float((int)(_1500)) + _1434), _1121, 0));
                            _1608 = ((float)((uint)((uint)(_1598.x & 511)))) * 0.001956947147846222f;
                            _1609 = ((float)((uint)((uint)(((uint)((uint)(_1598.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _1610 = ((float)((uint)((uint)(((uint)((uint)(_1598.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _1614 = exp2(float((int)(((uint)((uint)(_1598.x)) >> 27) + -15)));
                            _1616 = (_1608 * _1608) * _1614;
                            _1618 = (_1609 * _1609) * _1614;
                            _1620 = (_1610 * _1610) * _1614;
                            if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 256) == 0) {
                              _1639 = frac(_1435 + -0.5f);
                              _1640 = frac(_1436 + -0.5f);
                              _1647 = (_1639 * (_1558 - _1529)) + _1529;
                              _1648 = (_1639 * (_1560 - _1531)) + _1531;
                              _1649 = (_1639 * (_1562 - _1533)) + _1533;
                              _1669 = (((((_1639 * (_1616 - _1587)) + _1587) - _1647) * _1640) + _1647);
                              _1670 = (((((_1639 * (_1618 - _1589)) + _1589) - _1648) * _1640) + _1648);
                              _1671 = (((((_1639 * (_1620 - _1591)) + _1591) - _1649) * _1640) + _1649);
                            } else {
                              _1669 = ((((_1558 + _1529) + _1587) + _1616) * 0.25f);
                              _1670 = ((((_1560 + _1531) + _1589) + _1618) * 0.25f);
                              _1671 = ((((_1562 + _1533) + _1591) + _1620) * 0.25f);
                            }
                            _1674 = (_cbSharedPerViewData_raw[61u].x) * _1669;
                            _1675 = (_cbSharedPerViewData_raw[61u].x) * _1670;
                            _1676 = (_cbSharedPerViewData_raw[61u].x) * _1671;
                            _1687 = (((1.0f - frac(_1079)) - ((float)((uint)_1101))) * ((1.0f - frac(_1078)) - ((float)((uint)_1099)))) * ((1.0f - frac(_1080)) - ((float)((uint)_1103)));
                            _1695 = (_1395 * _1138) * select(((mad(_1103, _1103, mad(_1101, _1101, _1099)) & 1) != 0), (-0.0f - _1687), _1687);
                            if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 512) == 0)) {
                              _1699 = _1187 - _1056;
                              _1700 = _1188 - _1057;
                              _1701 = _1189 - _1058;
                              _1703 = rsqrt(dot(float3(_1699, _1700, _1701), float3(_1699, _1700, _1701)));
                              _1713 = (saturate((dot(float3((_1703 * _1699), (_1703 * _1700), (_1703 * _1701)), float3(_935, _938, _941)) * 0.5f) + 0.5f) * _1695);
                            } else {
                              _1713 = _1695;
                            }
                            if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0)) {
                              _1721 = sqrt(_1674);
                              _1722 = sqrt(_1675);
                              _1723 = sqrt(_1676);
                            } else {
                              _1721 = _1674;
                              _1722 = _1675;
                              _1723 = _1676;
                            }
                            _1733 = ((_1721 * _1713) + _1093);
                            _1734 = ((_1722 * _1713) + _1094);
                            _1735 = ((_1723 * _1713) + _1095);
                            _1736 = (_1713 + _1096);
                            _1737 = ((int)(_1097 + 1u));
                          } else {
                            _1733 = _1093;
                            _1734 = _1094;
                            _1735 = _1095;
                            _1736 = _1096;
                            _1737 = _1097;
                          }
                        } else {
                          _1733 = _1093;
                          _1734 = _1094;
                          _1735 = _1095;
                          _1736 = _1096;
                          _1737 = _1097;
                        }
                      }
                    } else {
                      _1733 = _1093;
                      _1734 = _1094;
                      _1735 = _1095;
                      _1736 = _1096;
                      _1737 = _1097;
                    }
                    _1738 = _1098 + 1;
                    if (!(_1738 == 8)) {
                      _1093 = _1733;
                      _1094 = _1734;
                      _1095 = _1735;
                      _1096 = _1736;
                      _1097 = _1737;
                      _1098 = _1738;
                      continue;
                    }
                    while(true) {
                      if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 131072) == 0)) {
                        if (!(_1737 == 0)) {
                          if (!(_1737 == 1)) {
                            if (!(_1737 == 2)) {
                              if (!(_1737 == 3)) {
                                _1749 = _1733 / _1736;
                                _1750 = _1734 / _1736;
                                _1751 = _1735 / _1736;
                                _1754 = (_1736 > 0.0f);
                                if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0) {
                                  if (!_1754) {
                                    _1763 = 0.0f;
                                    _1764 = 0.0f;
                                    _1765 = 0.0f;
                                  } else {
                                    _1763 = _1749;
                                    _1764 = _1750;
                                    _1765 = _1751;
                                  }
                                } else {
                                  if (_1754) {
                                    _1763 = (_1749 * _1749);
                                    _1764 = (_1750 * _1750);
                                    _1765 = (_1751 * _1751);
                                  } else {
                                    _1763 = 0.0f;
                                    _1764 = 0.0f;
                                    _1765 = 0.0f;
                                  }
                                }
                              } else {
                                _1763 = 0.0f;
                                _1764 = 1.0f;
                                _1765 = 1.0f;
                              }
                            } else {
                              _1763 = 0.0f;
                              _1764 = 0.0f;
                              _1765 = 1.0f;
                            }
                          } else {
                            _1763 = 1.0f;
                            _1764 = 0.0f;
                            _1765 = 1.0f;
                          }
                        } else {
                          _1763 = 1.0f;
                          _1764 = 0.0f;
                          _1765 = 0.0f;
                        }
                      } else {
                        _1749 = _1733 / _1736;
                        _1750 = _1734 / _1736;
                        _1751 = _1735 / _1736;
                        _1754 = (_1736 > 0.0f);
                        if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0) {
                          if (!_1754) {
                            _1763 = 0.0f;
                            _1764 = 0.0f;
                            _1765 = 0.0f;
                          } else {
                            _1763 = _1749;
                            _1764 = _1750;
                            _1765 = _1751;
                          }
                        } else {
                          if (_1754) {
                            _1763 = (_1749 * _1749);
                            _1764 = (_1750 * _1750);
                            _1765 = (_1751 * _1751);
                          } else {
                            _1763 = 0.0f;
                            _1764 = 0.0f;
                            _1765 = 0.0f;
                          }
                        }
                      }
                      _1773 = ((_1763 * _1027) + _976);
                      _1774 = ((_1764 * _1027) + _977);
                      _1775 = ((_1765 * _1027) + _978);
                      break;
                    }
                    break;
                  }
                } else {
                  _1773 = _976;
                  _1774 = _977;
                  _1775 = _978;
                }
                if (!(_979 < 1.0f)) {
                  _1779 = saturate(_979 - _1027);
                  [branch]
                  if (!(_1779 == 0.0f)) {
                    _1782 = _1773;
                    _1783 = _1774;
                    _1784 = _1775;
                    _1785 = _1779;
                    _1786 = _980 + 1;
                    if ((uint)_1786 < (uint)3) {
                      _976 = _1782;
                      _977 = _1783;
                      _978 = _1784;
                      _979 = _1785;
                      _980 = _1786;
                      continue;
                    } else {
                      _1789 = _1782;
                      _1790 = _1783;
                      _1791 = _1784;
                      _1792 = _1785;
                    }
                  } else {
                    _1789 = _1773;
                    _1790 = _1774;
                    _1791 = _1775;
                    _1792 = _1779;
                  }
                } else {
                  _1789 = _1773;
                  _1790 = _1774;
                  _1791 = _1775;
                  _1792 = 0.0f;
                }
              } else {
                _1782 = _976;
                _1783 = _977;
                _1784 = _978;
                _1785 = _979;
                _1786 = _980 + 1;
                if ((uint)_1786 < (uint)3) {
                  _976 = _1782;
                  _977 = _1783;
                  _978 = _1784;
                  _979 = _1785;
                  _980 = _1786;
                  continue;
                } else {
                  _1789 = _1782;
                  _1790 = _1783;
                  _1791 = _1784;
                  _1792 = _1785;
                }
              }
              _1794 = _1789;
              _1795 = _1790;
              _1796 = _1791;
              _1797 = _1792;
              break;
            }
          } else {
            _1794 = 0.0f;
            _1795 = 0.0f;
            _1796 = 0.0f;
            _1797 = 1.0f;
          }
          _1805 = ((_1797 * _892) + _1794);
          _1806 = ((_1797 * _893) + _1795);
          _1807 = ((_1797 * _894) + _1796);
        } else {
          _1805 = _892;
          _1806 = _893;
          _1807 = _894;
        }
        [branch]
        if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 16) == 0)) {
          _1824 = _1805;
          _1825 = _1806;
          _1826 = _1807;
          _1827 = (min((_1805 / max(9.999999747378752e-05f, _892)), 1.0f) * _895);
          _1828 = (min((_1806 / max(9.999999747378752e-05f, _893)), 1.0f) * _896);
          _1829 = (min((_1807 / max(9.999999747378752e-05f, _894)), 1.0f) * _897);
        } else {
          _1824 = _1805;
          _1825 = _1806;
          _1826 = _1807;
          _1827 = _895;
          _1828 = _896;
          _1829 = _897;
        }
      } else {
        _1824 = _892;
        _1825 = _893;
        _1826 = _894;
        _1827 = _895;
        _1828 = _896;
        _1829 = _897;
      }
      _1831 = saturate(dot(float3(_257, _258, _256), float3(_205, _207, _209)));
      _1834 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1831, _233), 0.0f);
      _1837 = _1834.x + _1834.y;
      _1838 = 1.0f - _1837;
      _1842 = max(9.999999747378752e-06f, _1837);
      _1855 = min(_234, 1.0f);
      _1856 = (_global_1 == 0);
      if (!_1856) {
        _1859 = 0;
        _1860 = _1855;
        while(true) {
          _1978 = _1860;
          _1861 = _1859 + (uint)(_global_0);
          _1864 = _global_5[min((uint)(_1861), 63u)];
          _1865 = _global_6[min((uint)(_1861), 63u)];
          _1869 = (int)((int)(_1864 << (((int)(31u - _266)) & 31))) >> 31;
          _1873 = (int)((int)(_1864 << ((31 - _268) & 31))) >> 31;
          _1885 = saturate((asfloat((_1869 & asint(_273))) + asfloat((_1873 & asint(_276)))) + asfloat(((_1873 & 1065353216) & _1869)));
          [branch]
          if (!(_1885 == 0.0f)) {
            _1890 = asfloat(srvLightInfoProperties.Load4(_1865)).x;
            _1891 = asfloat(srvLightInfoProperties.Load4(_1865)).y;
            _1892 = asfloat(srvLightInfoProperties.Load4(_1865)).z;
            _1893 = asfloat(srvLightInfoProperties.Load4(_1865)).w;
            _1896 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 16u)))).x;
            _1897 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 16u)))).y;
            _1898 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 16u)))).z;
            _1899 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 16u)))).w;
            _1902 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 32u)))).x;
            _1903 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 32u)))).y;
            _1904 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 32u)))).z;
            _1905 = asfloat(srvLightInfoProperties.Load4(((int)(_1865 + 32u)))).w;
            _1908 = asint(srvLightInfoProperties.Load(((int)(_1865 + 48u))));
            _1911 = asint(srvLightInfoProperties.Load(((int)(_1865 + 52u))));
            _1914 = asint(srvLightInfoProperties.Load(((int)(_1865 + 56u))));
            _1917 = asint(srvLightInfoProperties.Load(((int)(_1865 + 60u))));
            _1932 = mad(_1892, _246, mad(_1891, _245, (_1890 * _244))) + _1893;
            _1936 = mad(_1898, _246, mad(_1897, _245, (_1896 * _244))) + _1899;
            _1940 = mad(_1904, _246, mad(_1903, _245, (_1902 * _244))) + _1905;
            _1965 = saturate(1.0f - ((_1932 + 1.0f) * f16tof32(_1911))) + saturate(1.0f - ((1.0f - _1932) * f16tof32(((uint)((uint)(_1911) >> 16)))));
            _1966 = saturate(1.0f - ((_1936 + 1.0f) * f16tof32(_1914))) + saturate(1.0f - ((1.0f - _1936) * f16tof32(((uint)((uint)(_1914) >> 16)))));
            _1967 = saturate(1.0f - ((_1940 + 1.0f) * f16tof32(_1917))) + saturate(1.0f - ((1.0f - _1940) * f16tof32(((uint)((uint)(_1917) >> 16)))));
            _1970 = saturate(1.0f - dot(float3(_1965, _1966, _1967), float3(_1965, _1966, _1967)));
            _1978 = (saturate(1.0f - ((_1970 * _1970) * (f16tof32(((uint)((uint)(_1908) >> 16))) * _1885))) * _1860);
          } else {
            _1978 = _1860;
          }
          _1979 = _1859 + 1u;
          if (!(_1979 == _global_1)) {
            _1859 = _1979;
            _1860 = _1978;
            continue;
          }
          _1983 = _1978;
          break;
        }
      } else {
        _1983 = _1855;
      }
      if ((_cbSharedPerViewData_raw[59u].x) > 0.0f) {
        _1998 = saturate((_1983 + -1.0f) + exp2((_233 * _233) * log2(max((_1983 + _1831), 0.0f))));
      } else {
        _1998 = _1983;
      }
      _2001 = (((((_1838 * _227) / _1842) + 1.0f) * _1827) * ((_1834.x * _227) + _1834.y)) * _1998;
      _2004 = ((((_1834.x * _228) + _1834.y) * _1828) * (((_1838 * _228) / _1842) + 1.0f)) * _1998;
      _2007 = ((((_1834.x * _229) + _1834.y) * _1829) * (((_1838 * _229) / _1842) + 1.0f)) * _1998;
      [branch]
      if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 8192) == 0)) {
        _2014 = _1983;
      } else {
        _2014 = 1.0f;
      }
      if (_273 > 0.0f) {
        _2017 = _267 * 3;
        _2020 = srvRoomInfo[_2017].x;
        _2021 = srvRoomInfo[_2017].y;
        _2022 = srvRoomInfo[_2017].z;
        _2028 = srvRoomInfo[(_2017 + 1)].x;
        _2029 = srvRoomInfo[(_2017 + 1)].y;
        _2030 = srvRoomInfo[(_2017 + 1)].z;
        _2036 = srvRoomInfo[(_2017 + 2)].x;
        _2037 = srvRoomInfo[(_2017 + 2)].y;
        _2038 = srvRoomInfo[(_2017 + 2)].z;
        _2044 = saturate(dot(float3(_205, _207, _209), float3(asfloat(_2020), asfloat(_2021), asfloat(_2022))) + 0.5f);
        _2048 = (_2044 * _2044) * (3.0f - (_2044 * 2.0f));
        _2052 = 1.0f - _2048;
        _2059 = _2014 * _273;
        _2067 = ((_2059 * ((_2052 * asfloat(_2036)) + (_2048 * asfloat(_2028)))) + _1824);
        _2068 = ((_2059 * ((_2052 * asfloat(_2037)) + (_2048 * asfloat(_2029)))) + _1825);
        _2069 = ((_2059 * ((_2052 * asfloat(_2038)) + (_2048 * asfloat(_2030)))) + _1826);
      } else {
        _2067 = _1824;
        _2068 = _1825;
        _2069 = _1826;
      }
      if (_276 > 0.0f) {
        _2072 = _269 * 3;
        _2075 = srvRoomInfo[_2072].x;
        _2076 = srvRoomInfo[_2072].y;
        _2077 = srvRoomInfo[_2072].z;
        _2083 = srvRoomInfo[(_2072 + 1)].x;
        _2084 = srvRoomInfo[(_2072 + 1)].y;
        _2085 = srvRoomInfo[(_2072 + 1)].z;
        _2091 = srvRoomInfo[(_2072 + 2)].x;
        _2092 = srvRoomInfo[(_2072 + 2)].y;
        _2093 = srvRoomInfo[(_2072 + 2)].z;
        _2099 = saturate(dot(float3(_205, _207, _209), float3(asfloat(_2075), asfloat(_2076), asfloat(_2077))) + 0.5f);
        _2103 = (_2099 * _2099) * (3.0f - (_2099 * 2.0f));
        _2107 = 1.0f - _2103;
        _2114 = _2014 * _276;
        _2122 = ((_2114 * ((_2107 * asfloat(_2091)) + (_2103 * asfloat(_2083)))) + _2067);
        _2123 = ((_2114 * ((_2107 * asfloat(_2092)) + (_2103 * asfloat(_2084)))) + _2068);
        _2124 = ((_2114 * ((_2107 * asfloat(_2093)) + (_2103 * asfloat(_2085)))) + _2069);
      } else {
        _2122 = _2067;
        _2123 = _2068;
        _2124 = _2069;
      }
      if (!(asint(_cbSharedPerViewData_raw_uint[184u].w) == 0)) {
        _2147 = mad((_cbSharedPerViewData_raw[12u].z), _246, mad((_cbSharedPerViewData_raw[12u].y), _245, ((_cbSharedPerViewData_raw[12u].x) * _244))) + (_cbSharedPerViewData_raw[12u].w);
        _2151 = mad((_cbSharedPerViewData_raw[13u].z), _246, mad((_cbSharedPerViewData_raw[13u].y), _245, ((_cbSharedPerViewData_raw[13u].x) * _244))) + (_cbSharedPerViewData_raw[13u].w);
        _2155 = mad((_cbSharedPerViewData_raw[14u].z), _246, mad((_cbSharedPerViewData_raw[14u].y), _245, ((_cbSharedPerViewData_raw[14u].x) * _244))) + (_cbSharedPerViewData_raw[14u].w);
        _2174 = mad((_cbSharedPerViewData_raw[181u].z), _2155, mad((_cbSharedPerViewData_raw[181u].y), _2151, ((_cbSharedPerViewData_raw[181u].x) * _2147))) + (_cbSharedPerViewData_raw[181u].w);
        _2178 = mad((_cbSharedPerViewData_raw[182u].z), _2155, mad((_cbSharedPerViewData_raw[182u].y), _2151, ((_cbSharedPerViewData_raw[182u].x) * _2147))) + (_cbSharedPerViewData_raw[182u].w);
        _2182 = mad((_cbSharedPerViewData_raw[183u].z), _2155, mad((_cbSharedPerViewData_raw[183u].y), _2151, ((_cbSharedPerViewData_raw[183u].x) * _2147))) + (_cbSharedPerViewData_raw[183u].w);
        _2195 = max((_cbSharedPerViewData_raw[184u].x), 9.999999747378752e-06f);
        _2196 = max((_cbSharedPerViewData_raw[184u].y), 9.999999747378752e-06f);
        _2197 = max((_cbSharedPerViewData_raw[184u].z), 9.999999747378752e-06f);
        _2234 = min(min(saturate((_2174 + 1.0f) / max(((_cbSharedPerViewData_raw[185u].x) / _2195), 9.999999747378752e-06f)), saturate((1.0f - _2174) / max(((_cbSharedPerViewData_raw[186u].x) / _2195), 9.999999747378752e-06f))), min(min(saturate((_2178 + 1.0f) / max(((_cbSharedPerViewData_raw[185u].y) / _2196), 9.999999747378752e-06f)), saturate((1.0f - _2178) / max(((_cbSharedPerViewData_raw[186u].y) / _2196), 9.999999747378752e-06f))), min(saturate((_2182 + 1.0f) / max(((_cbSharedPerViewData_raw[185u].z) / _2197), 9.999999747378752e-06f)), saturate((1.0f - _2182) / max(((_cbSharedPerViewData_raw[186u].z) / _2197), 9.999999747378752e-06f)))));
      } else {
        _2234 = 0.0f;
      }
      _2235 = (uint)(_global_1) + (uint)(_global_0);
      _2236 = ((uint)_2235 < (uint)_global_2);
      if (_2236) {
        _2239 = _2122;
        _2240 = _2123;
        _2241 = _2124;
        _2242 = _2001;
        _2243 = _2004;
        _2244 = _2007;
        _2245 = _2235;
        while(true) {
          _9759 = _2239;
          _9760 = _2240;
          _9761 = _2241;
          _9762 = _2242;
          _9763 = _2243;
          _9764 = _2244;
          _2247 = _global_3[min((uint)(_2245), 63u)];
          _2251 = _global_4[min((uint)(_2245), 63u)];
          _2252 = _global_5[min((uint)(_2245), 63u)];
          _2253 = _global_6[min((uint)(_2245), 63u)];
          _2254 = _2247 & 4095;
          [branch]
          if (((_2251 & 16777216) == 0) && (_217 || ((_2251 & 8388608) == 0))) {
            _2265 = (int)((int)(_2252 << (((int)(31u - _266)) & 31))) >> 31;
            _2269 = (int)((int)(_2252 << ((31 - _268) & 31))) >> 31;
            _2281 = saturate((asfloat((_2265 & asint(_273))) + asfloat((_2269 & asint(_276)))) + asfloat(((_2269 & 1065353216) & _2265)));
            [branch]
            if (!(_2281 == 0.0f)) {
              _2284 = (uint)(_2247) >> 12;
              if (_2284 == 6) {
                if (!(asint(_cbSharedPerViewData_raw_uint[185u].w) == 0)) {
                  _3919 = (_2281 * select(((_2251 & 67108864) != 0), 1.0f, (1.0f - _2234)));
                } else {
                  _3919 = _2281;
                }
                _3922 = asfloat(srvLightInfoProperties.Load4(_2253)).x;
                _3923 = asfloat(srvLightInfoProperties.Load4(_2253)).y;
                _3924 = asfloat(srvLightInfoProperties.Load4(_2253)).z;
                _3925 = asfloat(srvLightInfoProperties.Load4(_2253)).w;
                _3928 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).x;
                _3929 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).y;
                _3930 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).z;
                _3931 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).w;
                _3934 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).x;
                _3935 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).y;
                _3936 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).z;
                _3939 = asint(srvLightInfoProperties.Load(((int)(_2253 + 68u))));
                _3942 = asint(srvLightInfoProperties.Load(((int)(_2253 + 72u))));
                _3945 = asint(srvLightInfoProperties.Load(((int)(_2253 + 76u))));
                _3948 = asint(srvLightInfoProperties.Load(((int)(_2253 + 84u))));
                _3951 = asint(srvLightInfoProperties.Load(((int)(_2253 + 88u))));
                _3954 = asint(srvLightInfoProperties.Load(((int)(_2253 + 92u))));
                _3957 = (float)((uint)((uint)(((uint)(_3939) >> 8) & 255)));
                _3961 = ((float)((uint)((uint)(_3939 & 255)))) * 0.003921499941498041f;
                _3963 = f16tof32(((uint)((uint)(_3942) >> 16)));
                _3965 = (uint)(_3945) >> 16;
                _3985 = srvDeferredShadingPass_DeferredShadows.Load(int3(_80, _81, 0));
                [branch]
                if (!(_3985.x == 0.0f)) {
                  [branch]
                  if (!(_3965 == 0)) {
                    Texture2D<float3> _HeapResource_37 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3965)))];
                    _4002 = _HeapResource_37.SampleLevel(samplerLinearWrapNode, float2((((mad(_3924, _246, mad(_3923, _245, (_3922 * _244))) + _3925) * f16tof32(((uint)((uint)(_3951) >> 16)))) + f16tof32(((uint)((uint)(_3954) >> 16)))), (((mad(_3930, _246, mad(_3929, _245, (_3928 * _244))) + _3931) * f16tof32(_3951)) + f16tof32(_3954))), 0.0f);
                    _4010 = (_4002.x * (_cbSharedPerViewData_raw[70u].x));
                    _4011 = (_4002.y * (_cbSharedPerViewData_raw[70u].y));
                    _4012 = (_4002.z * (_cbSharedPerViewData_raw[70u].z));
                  } else {
                    _4010 = (_cbSharedPerViewData_raw[70u].x);
                    _4011 = (_cbSharedPerViewData_raw[70u].y);
                    _4012 = (_cbSharedPerViewData_raw[70u].z);
                  }
                  _4015 = min(_3985.x, _3985.y) * _3919;
                  [branch]
                  if (_4015 > 0.0f) {
                    _4018 = dot(float3(_3934, _3935, _3936), float3(_3934, _3935, _3936));
                    _4019 = rsqrt(_4018);
                    _4020 = _4019 * _3934;
                    _4021 = _4019 * _3935;
                    _4022 = _4019 * _3936;
                    _4023 = dot(float3(_205, _207, _209), float3(_4020, _4021, _4022));
                    if (_3963 > 0.0f) {
                      _4031 = sqrt(saturate((_3963 * _3963) * (1.0f / (_4018 + 1.0f))));
                      if (_4023 < _4031) {
                        _4036 = max(_4023, (-0.0f - _4031)) + _4031;
                        _4041 = ((_4036 * _4036) / (_4031 * 4.0f));
                      } else {
                        _4041 = _4023;
                      }
                    } else {
                      _4041 = _4023;
                    }
                    _4042 = _233 * _233;
                    _4043 = 1.0f - _4042;
                    _4046 = saturate((_3963 * _4043) * _4019);
                    _4048 = saturate(_4019 * f16tof32(_3942));
                    _4049 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                    _4050 = dot(float3(_257, _258, _256), float3(_4020, _4021, _4022));
                    _4053 = rsqrt((_4050 * 2.0f) + 2.0f);
                    _4056 = saturate(_4053 * (_4049 + _4023));
                    _4059 = saturate((_4053 * _4050) + _4053);
                    _4060 = (_4046 > 0.0f);
                    if (_4060) {
                      _4064 = sqrt(1.0f - (_4046 * _4046));
                      _4066 = (_4023 * 2.0f) * _4049;
                      _4067 = _4066 - _4050;
                      if (!(_4067 >= _4064)) {
                        _4075 = rsqrt(1.0f - (_4067 * _4067)) * _4046;
                        _4078 = _4075 * (_4049 - (_4067 * _4023));
                        _4079 = _4049 * _4049;
                        _4084 = _4075 * (((_4079 * 2.0f) + -1.0f) - (_4067 * _4050));
                        _4093 = sqrt(saturate((((1.0f - (_4023 * _4023)) - _4079) - (_4050 * _4050)) + (_4066 * _4050)));
                        _4094 = _4093 * _4075;
                        _4097 = ((_4049 * 2.0f) * _4075) * _4093;
                        _4099 = (_4064 * _4023) + _4049;
                        _4100 = _4099 + _4078;
                        _4101 = _4064 * _4050;
                        _4103 = (_4101 + 1.0f) + _4084;
                        _4104 = _4094 * _4103;
                        _4105 = _4100 * _4103;
                        _4106 = _4097 * _4100;
                        _4111 = (((_4100 * 0.25f) * _4097) - (_4104 * 0.5f)) * _4105;
                        _4125 = (((_4106 - (_4104 * 2.0f)) * _4106) + (_4104 * _4104)) + ((((-0.5f - ((_4103 + _4101) * 0.5f)) * _4105) + ((_4103 * _4103) * _4099)) * _4100);
                        _4130 = (_4111 * 2.0f) / ((_4125 * _4125) + (_4111 * _4111));
                        _4131 = _4125 * _4130;
                        _4133 = 1.0f - (_4111 * _4130);
                        _4139 = ((_4131 * _4097) + _4101) + (_4133 * _4084);
                        _4142 = rsqrt((_4139 * 2.0f) + 2.0f);
                        _4151 = saturate((_4139 * _4142) + _4142);
                        _4152 = saturate(((_4099 + (_4131 * _4094)) + (_4133 * _4078)) * _4142);
                      } else {
                        _4151 = abs(_4049);
                        _4152 = 1.0f;
                      }
                    } else {
                      _4151 = _4059;
                      _4152 = _4056;
                    }
                    _4153 = saturate(_4041);
                    _4154 = _4042 * _4042;
                    _4155 = (_4048 > 0.0f);
                    if (_4155) {
                      _4164 = saturate(((_4048 * _4048) / ((_4151 * 3.5999999046325684f) + 0.4000000059604645f)) + _4154);
                    } else {
                      _4164 = _4154;
                    }
                    _4165 = sqrt(_4164);
                    if (_4060) {
                      _4176 = (_4164 / ((((_4046 * 0.25f) * ((_4165 * 3.0f) + _4046)) / (_4151 + 0.0010000000474974513f)) + _4164));
                    } else {
                      _4176 = 1.0f;
                    }
                    _4180 = (((_4164 * _4152) - _4152) * _4152) + 1.0f;
                    _4190 = exp2(log2(1.0f - saturate(_4151)) * 5.0f);
                    _4197 = abs(_4049);
                    _4199 = saturate(_4197 + 9.999999747378752e-06f);
                    _4200 = 1.0f - _4165;
                    _4209 = _231 * _231;
                    _4210 = _4209 * _4209;
                    _4216 = saturate(select((_4043 > 0.0f), ((1.0f - _4209) / _4043), 0.0f) * _4046);
                    _4217 = (_4216 > 0.0f);
                    if (_4217) {
                      _4221 = sqrt(1.0f - (_4216 * _4216));
                      _4223 = (_4023 * 2.0f) * _4049;
                      _4224 = _4223 - _4050;
                      if (!(_4224 >= _4221)) {
                        _4230 = rsqrt(1.0f - (_4224 * _4224)) * _4216;
                        _4233 = _4230 * (_4049 - (_4224 * _4023));
                        _4234 = _4049 * _4049;
                        _4239 = _4230 * (((_4234 * 2.0f) + -1.0f) - (_4224 * _4050));
                        _4248 = sqrt(saturate((((1.0f - (_4023 * _4023)) - _4234) - (_4050 * _4050)) + (_4223 * _4050)));
                        _4249 = _4248 * _4230;
                        _4252 = ((_4049 * 2.0f) * _4230) * _4248;
                        _4254 = (_4221 * _4023) + _4049;
                        _4255 = _4254 + _4233;
                        _4256 = _4221 * _4050;
                        _4258 = (_4256 + 1.0f) + _4239;
                        _4259 = _4249 * _4258;
                        _4260 = _4255 * _4258;
                        _4261 = _4252 * _4255;
                        _4266 = (((_4255 * 0.25f) * _4252) - (_4259 * 0.5f)) * _4260;
                        _4280 = (((_4261 - (_4259 * 2.0f)) * _4261) + (_4259 * _4259)) + ((((-0.5f - ((_4258 + _4256) * 0.5f)) * _4260) + ((_4258 * _4258) * _4254)) * _4255);
                        _4285 = (_4266 * 2.0f) / ((_4280 * _4280) + (_4266 * _4266));
                        _4286 = _4280 * _4285;
                        _4288 = 1.0f - (_4266 * _4285);
                        _4294 = ((_4286 * _4252) + _4256) + (_4288 * _4239);
                        _4297 = rsqrt((_4294 * 2.0f) + 2.0f);
                        _4306 = saturate((_4294 * _4297) + _4297);
                        _4307 = saturate(((_4254 + (_4286 * _4249)) + (_4288 * _4233)) * _4297);
                      } else {
                        _4306 = _4197;
                        _4307 = 1.0f;
                      }
                    } else {
                      _4306 = _4059;
                      _4307 = _4056;
                    }
                    if (_4155) {
                      _4316 = saturate(((_4048 * _4048) / ((_4306 * 3.5999999046325684f) + 0.4000000059604645f)) + _4210);
                    } else {
                      _4316 = _4210;
                    }
                    _4317 = sqrt(_4316);
                    if (_4217) {
                      _4328 = (_4316 / ((((_4216 * 0.25f) * ((_4317 * 3.0f) + _4216)) / (_4306 + 0.0010000000474974513f)) + _4316));
                    } else {
                      _4328 = 1.0f;
                    }
                    _4332 = (((_4316 * _4307) - _4307) * _4307) + 1.0f;
                    _4342 = 1.0f - _4317;
                    _4355 = (((exp2(log2(1.0f - saturate(_4306)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_4328 * _4153) * (_4316 / (_4332 * _4332))) * (0.5f / ((((_4342 * _4199) + _4317) * _4153) + (((_4342 * _4153) + _4317) * _4199))));
                    _4359 = saturate((_4023 + _3961) / (_3961 + 1.0f));
                    _4362 = ((_4176 * _4153) * (_4164 / (_4180 * _4180))) * (0.5f / ((((_4200 * _4199) + _4165) * _4153) + (((_4200 * _4153) + _4165) * _4199)));
                    [branch]
                    if (!((_3948 & 1) == 0)) {
                      _4381 = max(max(_4010, _4011), _4012);
                      if (_4381 > 0.0f) {
                        _4391 = saturate(_4010 / _4381);
                        _4392 = saturate(_4011 / _4381);
                        _4393 = saturate(_4012 / _4381);
                      } else {
                        _4391 = _4010;
                        _4392 = _4011;
                        _4393 = _4012;
                      }
                      _4394 = (_4392 < _4393);
                      _4395 = select(_4394, _4393, _4392);
                      _4396 = select(_4394, _4392, _4393);
                      _4397 = select(_4394, -1.0f, 0.0f);
                      _4398 = (_4391 < _4395);
                      _4400 = select(_4398, _4395, _4391);
                      _4401 = select(_4398, _4391, _4395);
                      _4405 = _4400 - select((_4401 < _4396), _4401, _4396);
                      _4411 = abs(select(_4398, (-0.3333333432674408f - _4397), _4397) + ((_4401 - _4396) / ((_4405 * 6.0f) + 9.999999682655225e-21f)));
                      if (_4411 < 0.6666666865348816f) {
                        _4424 = ((saturate(((float)((uint)((uint)(((uint)(_3948) >> 9) & 255)))) * 0.003921499941498041f) * (select((_4411 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _4411)) + _4411);
                      } else {
                        _4424 = _4411;
                      }
                      _4425 = saturate((_4405 / (_4400 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3948) >> 1) & 255)))) * 0.003921499941498041f));
                      _4426 = saturate(_4400);
                      if (!(_4425 <= 0.0f)) {
                        _4429 = saturate(_4424);
                        _4433 = select(((_4429 * 360.0f) >= 360.0f), 0.0f, (_4429 * 6.0f));
                        _4434 = int(_4433);
                        _4436 = _4433 - float((int)(_4434));
                        _4438 = _4426 * (1.0f - _4425);
                        _4441 = (1.0f - (_4436 * _4425)) * _4426;
                        _4445 = (1.0f - ((1.0f - _4436) * _4425)) * _4426;
                        switch (_4434) {
                          case 0: {
                            _4453 = _4426;
                            _4454 = _4445;
                            _4455 = _4438;
                            break;
                          }
                          case 1: {
                            _4453 = _4441;
                            _4454 = _4426;
                            _4455 = _4438;
                            break;
                          }
                          case 2: {
                            _4453 = _4438;
                            _4454 = _4426;
                            _4455 = _4445;
                            break;
                          }
                          case 3: {
                            _4453 = _4438;
                            _4454 = _4441;
                            _4455 = _4426;
                            break;
                          }
                          case 4: {
                            _4453 = _4445;
                            _4454 = _4438;
                            _4455 = _4426;
                            break;
                          }
                          case 5: {
                            _4453 = _4426;
                            _4454 = _4438;
                            _4455 = _4441;
                            break;
                          }
                          default: {
                            _4453 = 0.0f;
                            _4454 = 0.0f;
                            _4455 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _4453 = _4426;
                        _4454 = _4426;
                        _4455 = _4426;
                      }
                      _4456 = _4453 * _4381;
                      _4457 = _4454 * _4381;
                      _4458 = _4455 * _4381;
                      _4460 = saturate(_4015 * 1.0101009607315063f);
                      _4471 = ((_4460 * (_4010 - _4456)) + _4456);
                      _4472 = ((_4460 * (_4011 - _4457)) + _4457);
                      _4473 = (lerp(_4458, _4012, _4460));
                    } else {
                      _4471 = _4010;
                      _4472 = _4011;
                      _4473 = _4012;
                    }
                    _4474 = _4471 * _4015;
                    _4475 = _4472 * _4015;
                    _4476 = _4473 * _4015;
                    if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 1024) == 0)) {
                      _4486 = (_4474 * _1983);
                      _4487 = (_4475 * _1983);
                      _4488 = (_4476 * _1983);
                    } else {
                      _4486 = _4474;
                      _4487 = _4475;
                      _4488 = _4476;
                    }
                    _4492 = (_4486 * _4359) + _2239;
                    _4493 = (_4487 * _4359) + _2240;
                    _4494 = (_4488 * _4359) + _2241;
                    if ((_3957 * 0.003921499941498041f) > 0.0f) {
                      _4497 = (_1998 * 0.003921499941498041f) * _3957;
                      _9759 = _4492;
                      _9760 = _4493;
                      _9761 = _4494;
                      _9762 = ((((_4355 + (_4362 * ((_4190 * (1.0f - _227)) + _227))) * _4497) * _4486) + _2242);
                      _9763 = ((((_4355 + (_4362 * ((_4190 * (1.0f - _228)) + _228))) * _4497) * _4487) + _2243);
                      _9764 = ((((_4355 + (_4362 * ((_4190 * (1.0f - _229)) + _229))) * _4497) * _4488) + _2244);
                    } else {
                      _9759 = _4492;
                      _9760 = _4493;
                      _9761 = _4494;
                      _9762 = _2242;
                      _9763 = _2243;
                      _9764 = _2244;
                    }
                  } else {
                    _9759 = _2239;
                    _9760 = _2240;
                    _9761 = _2241;
                    _9762 = _2242;
                    _9763 = _2243;
                    _9764 = _2244;
                  }
                } else {
                  _9759 = _2239;
                  _9760 = _2240;
                  _9761 = _2241;
                  _9762 = _2242;
                  _9763 = _2243;
                  _9764 = _2244;
                }
              } else {
                _2301 = _2281 * select(((_2251 & 67108864) != 0), 1.0f, (1.0f - _2234));
                [branch]
                if (_2284 == 4) {
                  _2306 = asfloat(srvLightInfoProperties.Load4(_2253)).x;
                  _2307 = asfloat(srvLightInfoProperties.Load4(_2253)).y;
                  _2308 = asfloat(srvLightInfoProperties.Load4(_2253)).z;
                  _2309 = asfloat(srvLightInfoProperties.Load4(_2253)).w;
                  _2312 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).x;
                  _2313 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).y;
                  _2314 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).z;
                  _2315 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).w;
                  _2318 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).x;
                  _2319 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).y;
                  _2320 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).z;
                  _2321 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).w;
                  _2324 = asint(srvLightInfoProperties.Load(((int)(_2253 + 48u))));
                  _2327 = asint(srvLightInfoProperties.Load(((int)(_2253 + 52u))));
                  _2330 = asint(srvLightInfoProperties.Load(((int)(_2253 + 64u))));
                  _2333 = asint(srvLightInfoProperties.Load(((int)(_2253 + 68u))));
                  _2336 = asint(srvLightInfoProperties.Load(((int)(_2253 + 72u))));
                  _2338 = f16tof32(((uint)((uint)(_2324) >> 16)));
                  _2339 = f16tof32(_2324);
                  _2341 = f16tof32(((uint)((uint)(_2327) >> 16)));
                  _2345 = ((float)((uint)((uint)(((uint)(_2327) >> 8) & 255)))) * 0.003921499941498041f;
                  _2358 = mad(_2308, _246, mad(_2307, _245, (_2306 * _244))) + _2309;
                  _2362 = mad(_2314, _246, mad(_2313, _245, (_2312 * _244))) + _2315;
                  _2366 = mad(_2320, _246, mad(_2319, _245, (_2318 * _244))) + _2321;
                  _2391 = saturate(1.0f - ((_2358 + 1.0f) * f16tof32(_2330))) + saturate(1.0f - ((1.0f - _2358) * f16tof32(((uint)((uint)(_2330) >> 16)))));
                  _2392 = saturate(1.0f - ((_2362 + 1.0f) * f16tof32(_2333))) + saturate(1.0f - ((1.0f - _2362) * f16tof32(((uint)((uint)(_2333) >> 16)))));
                  _2393 = saturate(1.0f - ((_2366 + 1.0f) * f16tof32(_2336))) + saturate(1.0f - ((1.0f - _2366) * f16tof32(((uint)((uint)(_2336) >> 16)))));
                  _2396 = saturate(1.0f - dot(float3(_2391, _2392, _2393), float3(_2391, _2392, _2393)));
                  _2397 = _2396 * _2396;
                  _2404 = select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_2397 * _1983), _2397) * _2301;
                  _9759 = ((_2404 * _2338) + _2239);
                  _9760 = ((_2404 * _2339) + _2240);
                  _9761 = ((_2404 * _2341) + _2241);
                  _9762 = (((_2345 * _2338) * _2404) + _2242);
                  _9763 = (((_2345 * _2339) * _2404) + _2243);
                  _9764 = (((_2341 * _2345) * _2404) + _2244);
                } else {
                  if (_2284 == 5) {
                    _2425 = asfloat(srvLightInfoProperties.Load4(_2253)).x;
                    _2426 = asfloat(srvLightInfoProperties.Load4(_2253)).y;
                    _2427 = asfloat(srvLightInfoProperties.Load4(_2253)).z;
                    _2428 = asfloat(srvLightInfoProperties.Load4(_2253)).w;
                    _2431 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).x;
                    _2432 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).y;
                    _2433 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).z;
                    _2434 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).w;
                    _2437 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).x;
                    _2438 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).y;
                    _2439 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).z;
                    _2440 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).w;
                    _2443 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).x;
                    _2444 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).y;
                    _2445 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).z;
                    _2448 = asfloat(srvLightInfoProperties.Load(((int)(_2253 + 60u))));
                    _2451 = asint(srvLightInfoProperties.Load(((int)(_2253 + 64u))));
                    _2454 = asint(srvLightInfoProperties.Load(((int)(_2253 + 68u))));
                    _2457 = asint(srvLightInfoProperties.Load(((int)(_2253 + 80u))));
                    _2460 = asint(srvLightInfoProperties.Load(((int)(_2253 + 84u))));
                    _2463 = asint(srvLightInfoProperties.Load(((int)(_2253 + 88u))));
                    _2466 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 92u)))).x;
                    _2467 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 92u)))).y;
                    _2468 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 92u)))).z;
                    _2469 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 92u)))).w;
                    _2472 = asint(srvLightInfoProperties.Load(((int)(_2253 + 108u))));
                    _2475 = asint(srvLightInfoProperties.Load(((int)(_2253 + 112u))));
                    _2478 = asint(srvLightInfoProperties.Load(((int)(_2253 + 120u))));
                    _2481 = asint(srvLightInfoProperties.Load(((int)(_2253 + 124u))));
                    _2484 = asint(srvLightInfoProperties.Load(((int)(_2253 + 128u))));
                    _2487 = asint(srvLightInfoProperties.Load(((int)(_2253 + 132u))));
                    _2490 = asint(srvLightInfoProperties.Load(((int)(_2253 + 136u))));
                    _2493 = asint(srvLightInfoProperties.Load(((int)(_2253 + 140u))));
                    _2495 = f16tof32(((uint)((uint)(_2451) >> 16)));
                    _2496 = f16tof32(_2451);
                    _2498 = f16tof32(((uint)((uint)(_2454) >> 16)));
                    _2502 = ((float)((uint)((uint)(((uint)(_2454) >> 8) & 255)))) * 0.003921499941498041f;
                    _2505 = ((float)((uint)((uint)(_2454 & 255)))) * 0.003921499941498041f;
                    _2507 = f16tof32(((uint)((uint)(_2457) >> 16)));
                    _2510 = _2460 & 65535;
                    _2520 = f16tof32(((uint)((uint)(_2475) >> 16)));
                    _2521 = f16tof32(_2475);
                    _2523 = f16tof32(((uint)((uint)(_2478) >> 16)));
                    _2524 = 1.0f / _2523;
                    _2525 = _2523 + -1.0f;
                    _2526 = f16tof32(_2478);
                    _2545 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_2443, _2444, _2445))) * f16tof32(_2472);
                    _2549 = (_2545 * _205) + _244;
                    _2550 = (_2545 * _207) + _245;
                    _2551 = (_2545 * _209) - _243;
                    _2555 = mad(_2427, _2551, mad(_2426, _2550, (_2549 * _2425))) + _2428;
                    _2559 = mad(_2433, _2551, mad(_2432, _2550, (_2549 * _2431))) + _2434;
                    _2563 = mad(_2439, _2551, mad(_2438, _2550, (_2549 * _2437))) + _2440;
                    _2564 = saturate(_2563);
                    _2587 = saturate(1.0f - (_2555 * f16tof32(_2487))) + saturate(1.0f - ((1.0f - _2555) * f16tof32(((uint)((uint)(_2487) >> 16)))));
                    _2588 = saturate(1.0f - (_2559 * f16tof32(_2490))) + saturate(1.0f - ((1.0f - _2559) * f16tof32(((uint)((uint)(_2490) >> 16)))));
                    _2589 = saturate(1.0f - (_2563 * f16tof32(_2493))) + saturate(1.0f - ((1.0f - _2563) * f16tof32(((uint)((uint)(_2493) >> 16)))));
                    _2592 = saturate(1.0f - dot(float3(_2587, _2588, _2589), float3(_2587, _2588, _2589)));
                    _2593 = _2592 * _2592;
                    if (!(((_2251 & 3584) == 0) || (!(_2593 > 0.0f)))) {
                      _2600 = 1.0f - _2564;
                      _2601 = saturate(_2555);
                      _2602 = saturate(_2559);
                      bool __branch_chain_2597;
                      [branch]
                      if ((_2251 & 1024) == 0) {
                        _2865 = 1.0f;
                        _2866 = 0.0f;
                        _2867 = _2600;
                        __branch_chain_2597 = true;
                      } else {
                        _2607 = ((_2601 * _2525) + 0.5f) * _2524;
                        _2609 = ((_2602 * _2525) + 0.5f) * _2524;
                        _2610 = _2600 + f16tof32(((uint)((uint)(_2472) >> 16)));
                        Texture2D<float4> _HeapResource_32 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_2460) >> 16))];
                        _2613 = saturate(_2610);
                        _2617 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                        _2626 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 0u) : (frac(frac(dot(float2(((_2617 * 32.665000915527344f) + _142), ((_2617 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _2627 = sin(_2626);
                        _2628 = cos(_2626);
                        _2629 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                        _2634 = sqrt((float((int)(_2629)) * 0.25f) + 0.125f) * _2520;
                        _2643 = (_global_7[min((uint)(((int)(0u + (_2629 * 2)))), 127u)]) * _2634;
                        _2644 = (_global_7[min((uint)(((int)(1u + (_2629 * 2)))), 127u)]) * _2634;
                        _2646 = -0.0f - _2627;
                        _2651 = _HeapResource_32.GatherRed(samplerPointClampNode, float2((dot(float2(_2643, _2644), float2(_2628, _2627)) + _2607), (dot(float2(_2643, _2644), float2(_2646, _2628)) + _2609)));
                        _2656 = _2651.x - _2613;
                        _2658 = select((_2656 < 0.0f), 0.0f, 1.0f);
                        _2660 = _2651.y - _2613;
                        _2662 = select((_2660 < 0.0f), 0.0f, 1.0f);
                        _2666 = _2651.z - _2613;
                        _2668 = select((_2666 < 0.0f), 0.0f, 1.0f);
                        _2672 = _2651.w - _2613;
                        _2674 = select((_2672 < 0.0f), 0.0f, 1.0f);
                        _2681 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                        _2686 = sqrt((float((int)(_2681)) * 0.25f) + 0.125f) * _2520;
                        _2695 = (_global_7[min((uint)(((int)(0u + (_2681 * 2)))), 127u)]) * _2686;
                        _2696 = (_global_7[min((uint)(((int)(1u + (_2681 * 2)))), 127u)]) * _2686;
                        _2702 = _HeapResource_32.GatherRed(samplerPointClampNode, float2((dot(float2(_2695, _2696), float2(_2628, _2627)) + _2607), (dot(float2(_2695, _2696), float2(_2646, _2628)) + _2609)));
                        _2707 = _2702.x - _2613;
                        _2709 = select((_2707 < 0.0f), 0.0f, 1.0f);
                        _2713 = _2702.y - _2613;
                        _2715 = select((_2713 < 0.0f), 0.0f, 1.0f);
                        _2719 = _2702.z - _2613;
                        _2721 = select((_2719 < 0.0f), 0.0f, 1.0f);
                        _2725 = _2702.w - _2613;
                        _2727 = select((_2725 < 0.0f), 0.0f, 1.0f);
                        _2734 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                        _2739 = sqrt((float((int)(_2734)) * 0.25f) + 0.125f) * _2520;
                        _2748 = (_global_7[min((uint)(((int)(0u + (_2734 * 2)))), 127u)]) * _2739;
                        _2749 = (_global_7[min((uint)(((int)(1u + (_2734 * 2)))), 127u)]) * _2739;
                        _2755 = _HeapResource_32.GatherRed(samplerPointClampNode, float2((dot(float2(_2748, _2749), float2(_2628, _2627)) + _2607), (dot(float2(_2748, _2749), float2(_2646, _2628)) + _2609)));
                        _2760 = _2755.x - _2613;
                        _2762 = select((_2760 < 0.0f), 0.0f, 1.0f);
                        _2766 = _2755.y - _2613;
                        _2768 = select((_2766 < 0.0f), 0.0f, 1.0f);
                        _2772 = _2755.z - _2613;
                        _2774 = select((_2772 < 0.0f), 0.0f, 1.0f);
                        _2778 = _2755.w - _2613;
                        _2780 = select((_2778 < 0.0f), 0.0f, 1.0f);
                        _2787 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                        _2792 = sqrt((float((int)(_2787)) * 0.25f) + 0.125f) * _2520;
                        _2801 = (_global_7[min((uint)(((int)(0u + (_2787 * 2)))), 127u)]) * _2792;
                        _2802 = (_global_7[min((uint)(((int)(1u + (_2787 * 2)))), 127u)]) * _2792;
                        _2808 = _HeapResource_32.GatherRed(samplerPointClampNode, float2((dot(float2(_2801, _2802), float2(_2628, _2627)) + _2607), (dot(float2(_2801, _2802), float2(_2646, _2628)) + _2609)));
                        _2813 = _2808.x - _2613;
                        _2815 = select((_2813 < 0.0f), 0.0f, 1.0f);
                        _2819 = _2808.y - _2613;
                        _2821 = select((_2819 < 0.0f), 0.0f, 1.0f);
                        _2825 = _2808.z - _2613;
                        _2827 = select((_2825 < 0.0f), 0.0f, 1.0f);
                        _2831 = _2808.w - _2613;
                        _2833 = select((_2831 < 0.0f), 0.0f, 1.0f);
                        _2834 = ((((((((((((((_2658 + _2662) + _2668) + _2674) + _2709) + _2715) + _2721) + _2727) + _2762) + _2768) + _2774) + _2780) + _2815) + _2821) + _2827) + _2833;
                        _2845 = (saturate(_2834 * 0.0625f) * 2.0f) + -1.0f;
                        _2851 = float((int)(((int)(uint)((int)(_2845 > 0.0f))) - ((int)(uint)((int)(_2845 < 0.0f)))));
                        _2853 = 1.0f - (_2851 * _2845);
                        _2855 = (_2853 * _2853) * _2853;
                        _2862 = 0.5f - ((_2851 * 0.5f) * ((1.0f - _2855) - ((_2853 - _2855) * saturate(((1.0f / _2613) * (1.0f / _2834)) * ((((((((((((((((_2658 * _2656) + (_2662 * _2660)) + (_2668 * _2666)) + (_2674 * _2672)) + (_2709 * _2707)) + (_2715 * _2713)) + (_2721 * _2719)) + (_2727 * _2725)) + (_2762 * _2760)) + (_2768 * _2766)) + (_2774 * _2772)) + (_2780 * _2778)) + (_2815 * _2813)) + (_2821 * _2819)) + (_2827 * _2825)) + (_2833 * _2831))))));
                        [branch]
                        if (_2526 < 1.0f) {
                          _2865 = _2862;
                          _2866 = _2526;
                          _2867 = _2610;
                          __branch_chain_2597 = true;
                        } else {
                          _3335 = _2862;
                          __branch_chain_2597 = false;
                        }
                      }
                      if (__branch_chain_2597) {
                        _2870 = (_2601 * _2466) + _2468;
                        _2871 = (_2602 * _2467) + _2469;
                        if (!((_2251 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_33 = ResourceDescriptorHeap[5];
                          _2880 = saturate(_2867);
                          _2884 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                          _2893 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 1u) : (frac(frac(dot(float2(((_2884 * 32.665000915527344f) + _142), ((_2884 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2894 = sin(_2893);
                          _2895 = cos(_2893);
                          _2900 = select(((((float4)(_HeapResource_33.SampleLevel(samplerPointBorderWhiteNode, float2(_2870, _2871), 0.0f))).x) > _2880), 1.0f, 0.0f);
                          _2901 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                          _2906 = sqrt((float((int)(_2901)) * 0.25f) + 0.125f) * _2521;
                          _2915 = (_global_7[min((uint)(((int)(0u + (_2901 * 2)))), 127u)]) * _2906;
                          _2916 = (_global_7[min((uint)(((int)(1u + (_2901 * 2)))), 127u)]) * _2906;
                          _2918 = -0.0f - _2894;
                          _2920 = dot(float2(_2915, _2916), float2(_2895, _2894)) + _2870;
                          _2921 = dot(float2(_2915, _2916), float2(_2918, _2895)) + _2871;
                          _2923 = _HeapResource_33.GatherRed(samplerPointClampNode, float2(_2920, _2921));
                          _2927 = _2920 * (_cbSharedPerViewData_raw[82u].x);
                          _2928 = _2921 * (_cbSharedPerViewData_raw[82u].y);
                          _2931 = floor((_cbSharedPerViewData_raw[82u].x) * _2468);
                          _2932 = floor((_cbSharedPerViewData_raw[82u].y) * _2469);
                          _2937 = floor(((_cbSharedPerViewData_raw[82u].x) * (_2466 + _2468)) + 0.5f);
                          _2938 = floor(((_cbSharedPerViewData_raw[82u].y) * (_2467 + _2469)) + 0.5f);
                          _2941 = floor(_2927 + -0.5f);
                          _2942 = floor(_2928 + 0.5f);
                          _2944 = floor(_2927 + 0.5f);
                          _2946 = floor(_2928 + -0.5f);
                          _2947 = (_2941 < _2931);
                          _2948 = (_2942 < _2932);
                          if ((_2947 || _2948) | ((_2941 >= _2937) || (_2942 >= _2938))) {
                            _2957 = _2900;
                          } else {
                            _2957 = _2923.x;
                          }
                          _2958 = (_2944 < _2931);
                          if ((_2958 || _2948) | ((_2944 >= _2937) || (_2942 >= _2938))) {
                            _2966 = _2900;
                          } else {
                            _2966 = _2923.y;
                          }
                          _2967 = (_2946 < _2932);
                          if ((_2958 || _2967) | ((_2944 >= _2937) || (_2946 >= _2938))) {
                            _2975 = _2900;
                          } else {
                            _2975 = _2923.z;
                          }
                          if ((_2947 || _2967) | ((_2941 >= _2937) || (_2946 >= _2938))) {
                            _2983 = _2900;
                          } else {
                            _2983 = _2923.w;
                          }
                          _2984 = _2957 - _2880;
                          _2986 = select((_2984 < 0.0f), 0.0f, 1.0f);
                          _2988 = _2966 - _2880;
                          _2990 = select((_2988 < 0.0f), 0.0f, 1.0f);
                          _2994 = _2975 - _2880;
                          _2996 = select((_2994 < 0.0f), 0.0f, 1.0f);
                          _3000 = _2983 - _2880;
                          _3002 = select((_3000 < 0.0f), 0.0f, 1.0f);
                          _3009 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                          _3014 = sqrt((float((int)(_3009)) * 0.25f) + 0.125f) * _2521;
                          _3023 = (_global_7[min((uint)(((int)(0u + (_3009 * 2)))), 127u)]) * _3014;
                          _3024 = (_global_7[min((uint)(((int)(1u + (_3009 * 2)))), 127u)]) * _3014;
                          _3027 = dot(float2(_3023, _3024), float2(_2895, _2894)) + _2870;
                          _3028 = dot(float2(_3023, _3024), float2(_2918, _2895)) + _2871;
                          _3030 = _HeapResource_33.GatherRed(samplerPointClampNode, float2(_3027, _3028));
                          _3034 = _3027 * (_cbSharedPerViewData_raw[82u].x);
                          _3035 = _3028 * (_cbSharedPerViewData_raw[82u].y);
                          _3038 = floor(_3034 + -0.5f);
                          _3039 = floor(_3035 + 0.5f);
                          _3041 = floor(_3034 + 0.5f);
                          _3043 = floor(_3035 + -0.5f);
                          _3044 = (_3038 < _2931);
                          _3045 = (_3039 < _2932);
                          if ((_3044 || _3045) | ((_3038 >= _2937) || (_3039 >= _2938))) {
                            _3054 = _2900;
                          } else {
                            _3054 = _3030.x;
                          }
                          _3055 = (_3041 < _2931);
                          if ((_3055 || _3045) | ((_3041 >= _2937) || (_3039 >= _2938))) {
                            _3063 = _2900;
                          } else {
                            _3063 = _3030.y;
                          }
                          _3064 = (_3043 < _2932);
                          if ((_3055 || _3064) | ((_3041 >= _2937) || (_3043 >= _2938))) {
                            _3072 = _2900;
                          } else {
                            _3072 = _3030.z;
                          }
                          if ((_3044 || _3064) | ((_3038 >= _2937) || (_3043 >= _2938))) {
                            _3080 = _2900;
                          } else {
                            _3080 = _3030.w;
                          }
                          _3081 = _3054 - _2880;
                          _3083 = select((_3081 < 0.0f), 0.0f, 1.0f);
                          _3087 = _3063 - _2880;
                          _3089 = select((_3087 < 0.0f), 0.0f, 1.0f);
                          _3093 = _3072 - _2880;
                          _3095 = select((_3093 < 0.0f), 0.0f, 1.0f);
                          _3099 = _3080 - _2880;
                          _3101 = select((_3099 < 0.0f), 0.0f, 1.0f);
                          _3108 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                          _3113 = sqrt((float((int)(_3108)) * 0.25f) + 0.125f) * _2521;
                          _3122 = (_global_7[min((uint)(((int)(0u + (_3108 * 2)))), 127u)]) * _3113;
                          _3123 = (_global_7[min((uint)(((int)(1u + (_3108 * 2)))), 127u)]) * _3113;
                          _3126 = dot(float2(_3122, _3123), float2(_2895, _2894)) + _2870;
                          _3127 = dot(float2(_3122, _3123), float2(_2918, _2895)) + _2871;
                          _3129 = _HeapResource_33.GatherRed(samplerPointClampNode, float2(_3126, _3127));
                          _3133 = _3126 * (_cbSharedPerViewData_raw[82u].x);
                          _3134 = _3127 * (_cbSharedPerViewData_raw[82u].y);
                          _3137 = floor(_3133 + -0.5f);
                          _3138 = floor(_3134 + 0.5f);
                          _3140 = floor(_3133 + 0.5f);
                          _3142 = floor(_3134 + -0.5f);
                          _3143 = (_3137 < _2931);
                          _3144 = (_3138 < _2932);
                          if ((_3143 || _3144) | ((_3137 >= _2937) || (_3138 >= _2938))) {
                            _3153 = _2900;
                          } else {
                            _3153 = _3129.x;
                          }
                          _3154 = (_3140 < _2931);
                          if ((_3154 || _3144) | ((_3140 >= _2937) || (_3138 >= _2938))) {
                            _3162 = _2900;
                          } else {
                            _3162 = _3129.y;
                          }
                          _3163 = (_3142 < _2932);
                          if ((_3154 || _3163) | ((_3140 >= _2937) || (_3142 >= _2938))) {
                            _3171 = _2900;
                          } else {
                            _3171 = _3129.z;
                          }
                          if ((_3143 || _3163) | ((_3137 >= _2937) || (_3142 >= _2938))) {
                            _3179 = _2900;
                          } else {
                            _3179 = _3129.w;
                          }
                          _3180 = _3153 - _2880;
                          _3182 = select((_3180 < 0.0f), 0.0f, 1.0f);
                          _3186 = _3162 - _2880;
                          _3188 = select((_3186 < 0.0f), 0.0f, 1.0f);
                          _3192 = _3171 - _2880;
                          _3194 = select((_3192 < 0.0f), 0.0f, 1.0f);
                          _3198 = _3179 - _2880;
                          _3200 = select((_3198 < 0.0f), 0.0f, 1.0f);
                          _3207 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                          _3212 = sqrt((float((int)(_3207)) * 0.25f) + 0.125f) * _2521;
                          _3221 = (_global_7[min((uint)(((int)(0u + (_3207 * 2)))), 127u)]) * _3212;
                          _3222 = (_global_7[min((uint)(((int)(1u + (_3207 * 2)))), 127u)]) * _3212;
                          _3225 = dot(float2(_3221, _3222), float2(_2895, _2894)) + _2870;
                          _3226 = dot(float2(_3221, _3222), float2(_2918, _2895)) + _2871;
                          _3228 = _HeapResource_33.GatherRed(samplerPointClampNode, float2(_3225, _3226));
                          _3232 = _3225 * (_cbSharedPerViewData_raw[82u].x);
                          _3233 = _3226 * (_cbSharedPerViewData_raw[82u].y);
                          _3236 = floor(_3232 + -0.5f);
                          _3237 = floor(_3233 + 0.5f);
                          _3239 = floor(_3232 + 0.5f);
                          _3241 = floor(_3233 + -0.5f);
                          _3242 = (_3236 < _2931);
                          _3243 = (_3237 < _2932);
                          if ((_3242 || _3243) | ((_3236 >= _2937) || (_3237 >= _2938))) {
                            _3252 = _2900;
                          } else {
                            _3252 = _3228.x;
                          }
                          _3253 = (_3239 < _2931);
                          if ((_3253 || _3243) | ((_3239 >= _2937) || (_3237 >= _2938))) {
                            _3261 = _2900;
                          } else {
                            _3261 = _3228.y;
                          }
                          _3262 = (_3241 < _2932);
                          if ((_3253 || _3262) | ((_3239 >= _2937) || (_3241 >= _2938))) {
                            _3270 = _2900;
                          } else {
                            _3270 = _3228.z;
                          }
                          if ((_3242 || _3262) | ((_3236 >= _2937) || (_3241 >= _2938))) {
                            _3278 = _2900;
                          } else {
                            _3278 = _3228.w;
                          }
                          _3279 = _3252 - _2880;
                          _3281 = select((_3279 < 0.0f), 0.0f, 1.0f);
                          _3285 = _3261 - _2880;
                          _3287 = select((_3285 < 0.0f), 0.0f, 1.0f);
                          _3291 = _3270 - _2880;
                          _3293 = select((_3291 < 0.0f), 0.0f, 1.0f);
                          _3297 = _3278 - _2880;
                          _3299 = select((_3297 < 0.0f), 0.0f, 1.0f);
                          _3300 = ((((((((((((((_2990 + _2986) + _2996) + _3002) + _3083) + _3089) + _3095) + _3101) + _3182) + _3188) + _3194) + _3200) + _3281) + _3287) + _3293) + _3299;
                          _3311 = (saturate(_3300 * 0.0625f) * 2.0f) + -1.0f;
                          _3317 = float((int)(((int)(uint)((int)(_3311 > 0.0f))) - ((int)(uint)((int)(_3311 < 0.0f)))));
                          _3319 = 1.0f - (_3317 * _3311);
                          _3321 = (_3319 * _3319) * _3319;
                          _3330 = (0.5f - ((_3317 * 0.5f) * ((1.0f - _3321) - ((_3319 - _3321) * saturate(((1.0f / _2880) * (1.0f / _3300)) * ((((((((((((((((_2990 * _2988) + (_2986 * _2984)) + (_2996 * _2994)) + (_3002 * _3000)) + (_3083 * _3081)) + (_3089 * _3087)) + (_3095 * _3093)) + (_3101 * _3099)) + (_3182 * _3180)) + (_3188 * _3186)) + (_3194 * _3192)) + (_3200 * _3198)) + (_3281 * _3279)) + (_3287 * _3285)) + (_3293 * _3291)) + (_3299 * _3297)))))));
                        } else {
                          _3330 = 1.0f;
                        }
                        _3335 = (lerp(_3330, _2865, _2866));
                      }
                      [branch]
                      if (!((_2251 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_34 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_2463) >> 16))];
                        _3341 = _HeapResource_34.SampleLevel(samplerLinearClampNode, float2(_2555, _2559), 0.0f);
                        if (_3341.x > 0.0f) {
                          Texture2D<float4> _HeapResource_35 = ResourceDescriptorHeap[NonUniformResourceIndex((_2463 & 65535))];
                          _3348 = _HeapResource_35.SampleLevel(samplerLinearClampNode, float2(_2555, _2559), 0.0f);
                          _3362 = mad(saturate(((log2(_2564 * _2448) * 0.6931471824645996f) - (_cbSharedPerViewData_raw[147u].w)) * (_cbSharedPerViewData_raw[148u].x)), 2.0f, -1.0f);
                          _3363 = max(9.999999747378752e-06f, _3341.x);
                          _3364 = _3348.x / _3363;
                          _3365 = _3348.y / _3363;
                          _3367 = _3348.w / _3363;
                          _3372 = ((0.375f - _3365) * 4.999999873689376e-06f) + _3365;
                          _3375 = -0.0f - _3364;
                          _3376 = mad(_3375, _3372, (_3348.z / _3363));
                          _3378 = 1.0f / mad(_3375, _3364, _3372);
                          _3379 = _3378 * _3376;
                          _3384 = _3362 - _3364;
                          _3389 = (((_3362 * _3362) - _3372) - (_3379 * _3384)) / mad((-0.0f - _3376), _3379, mad((-0.0f - _3372), _3372, (((0.375f - _3367) * 4.999999873689376e-06f) + _3367)));
                          _3391 = (_3378 * _3384) - (_3389 * _3379);
                          _3394 = 1.0f / _3389;
                          _3395 = _3391 * _3394;
                          _3400 = sqrt(((_3395 * _3395) * 0.25f) - ((1.0f - dot(float2(_3391, _3389), float2(_3364, _3372))) * _3394));
                          _3402 = (_3395 * -0.5f) - _3400;
                          _3404 = _3400 - (_3395 * 0.5f);
                          _3406 = select((_3402 < _3362), 1.0f, 0.0f);
                          _3411 = (_3406 + -0.05000000074505806f) / (_3402 - _3362);
                          _3417 = (((select((_3404 < _3362), 1.0f, 0.0f) - _3406) / (_3404 - _3402)) - _3411) / (_3404 - _3362);
                          _3419 = _3411 - (_3417 * _3402);
                          _3432 = (exp2((_3341.x * -1.4426950216293335f) * saturate((dot(float2(_3364, _3372), float2((_3419 - (_3417 * _3362)), _3417)) + 0.05000000074505806f) - (_3419 * _3362))) * _3335);
                        } else {
                          _3432 = _3335;
                        }
                      } else {
                        _3432 = _3335;
                      }
                    } else {
                      _3432 = 1.0f;
                    }
                    [branch]
                    if (!(_2510 == 0)) {
                      Texture2D<float3> _HeapResource_36 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _2510)))];
                      _3445 = _HeapResource_36.SampleLevel(samplerLinearWrapNode, float2(((_2555 * f16tof32(((uint)((uint)(_2481) >> 16)))) + f16tof32(((uint)((uint)(_2484) >> 16)))), ((_2559 * f16tof32(_2481)) + f16tof32(_2484))), 0.0f);
                      _3453 = (_3445.x * _2495);
                      _3454 = (_3445.y * _2496);
                      _3455 = (_3445.z * _2498);
                    } else {
                      _3453 = _2495;
                      _3454 = _2496;
                      _3455 = _2498;
                    }
                    _3456 = _3432 * _2593;
                    [branch]
                    if (!(_3456 == 0.0f)) {
                      bool __branch_chain_3458;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _3474 = 0;
                        __branch_chain_3458 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _3474 = 1;
                          __branch_chain_3458 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _3474 = 2;
                            __branch_chain_3458 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _3474 = 3;
                              __branch_chain_3458 = true;
                            } else {
                              _3495 = _3456;
                              __branch_chain_3458 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_3458) {
                        while(true) {
                          _3477 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_80, _81, 0));
                          if (_3474 == 0) {
                            _3491 = _3477.x;
                          } else {
                            if (_3474 == 1) {
                              _3491 = _3477.y;
                            } else {
                              if (_3474 == 2) {
                                _3491 = _3477.z;
                              } else {
                                _3491 = _3477.w;
                              }
                            }
                          }
                          _3495 = ((_3491 * _3491) * _2593);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_3495 == 0.0f)) {
                          [branch]
                          if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                            _3505 = srvLightMappingData[_2254];
                            if (!(_3505 == -1)) {
                              _3510 = srvLightIndexData[_3505].nLayerIndex;
                              _3512 = srvLightIndexData[_3505].vAtlasOrigin.x;
                              _3513 = srvLightIndexData[_3505].vAtlasOrigin.y;
                              _3515 = srvLightIndexData[_3505].vScreenOrigin.x;
                              _3516 = srvLightIndexData[_3505].vScreenOrigin.y;
                              _3525 = ((int)(_3510 * 5)) & 31;
                              _3534 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_3512 + _80) - _3515)), ((int)((_3513 + _81) - _3516)), 0)))).x) & ((int)(31 << _3525)))) >> _3525)) >> 1)))) * 0.06666667014360428f) * _3495);
                            } else {
                              _3534 = _3495;
                            }
                          } else {
                            _3534 = _3495;
                          }
                          _3538 = ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0);
                          _3541 = select(_3538, (_3534 * _1983), _3534);
                          _3543 = dot(float3(_2443, _2444, _2445), float3(_2443, _2444, _2445));
                          _3544 = rsqrt(_3543);
                          _3545 = _3544 * _2443;
                          _3546 = _3544 * _2444;
                          _3547 = _3544 * _2445;
                          _3548 = dot(float3(_205, _207, _209), float3(_3545, _3546, _3547));
                          if (_2507 > 0.0f) {
                            _3556 = sqrt(saturate((_2507 * _2507) * (1.0f / (_3543 + 1.0f))));
                            if (_3548 < _3556) {
                              _3561 = max(_3548, (-0.0f - _3556)) + _3556;
                              _3566 = ((_3561 * _3561) / (_3556 * 4.0f));
                            } else {
                              _3566 = _3548;
                            }
                          } else {
                            _3566 = _3548;
                          }
                          _3567 = _233 * _233;
                          _3568 = 1.0f - _3567;
                          _3571 = saturate((_2507 * _3568) * _3544);
                          _3573 = saturate(_3544 * f16tof32(_2457));
                          _3574 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                          _3575 = dot(float3(_257, _258, _256), float3(_3545, _3546, _3547));
                          _3578 = rsqrt((_3575 * 2.0f) + 2.0f);
                          _3581 = saturate(_3578 * (_3574 + _3548));
                          _3584 = saturate((_3578 * _3575) + _3578);
                          _3585 = (_3571 > 0.0f);
                          if (_3585) {
                            _3589 = sqrt(1.0f - (_3571 * _3571));
                            _3591 = (_3548 * 2.0f) * _3574;
                            _3592 = _3591 - _3575;
                            if (!(_3592 >= _3589)) {
                              _3600 = rsqrt(1.0f - (_3592 * _3592)) * _3571;
                              _3603 = _3600 * (_3574 - (_3592 * _3548));
                              _3604 = _3574 * _3574;
                              _3609 = _3600 * (((_3604 * 2.0f) + -1.0f) - (_3592 * _3575));
                              _3618 = sqrt(saturate((((1.0f - (_3548 * _3548)) - _3604) - (_3575 * _3575)) + (_3591 * _3575)));
                              _3619 = _3618 * _3600;
                              _3622 = ((_3574 * 2.0f) * _3600) * _3618;
                              _3624 = (_3589 * _3548) + _3574;
                              _3625 = _3624 + _3603;
                              _3626 = _3589 * _3575;
                              _3628 = (_3626 + 1.0f) + _3609;
                              _3629 = _3619 * _3628;
                              _3630 = _3625 * _3628;
                              _3631 = _3622 * _3625;
                              _3636 = (((_3625 * 0.25f) * _3622) - (_3629 * 0.5f)) * _3630;
                              _3650 = (((_3631 - (_3629 * 2.0f)) * _3631) + (_3629 * _3629)) + ((((-0.5f - ((_3628 + _3626) * 0.5f)) * _3630) + ((_3628 * _3628) * _3624)) * _3625);
                              _3655 = (_3636 * 2.0f) / ((_3650 * _3650) + (_3636 * _3636));
                              _3656 = _3650 * _3655;
                              _3658 = 1.0f - (_3636 * _3655);
                              _3664 = ((_3656 * _3622) + _3626) + (_3658 * _3609);
                              _3667 = rsqrt((_3664 * 2.0f) + 2.0f);
                              _3676 = saturate((_3664 * _3667) + _3667);
                              _3677 = saturate(((_3624 + (_3656 * _3619)) + (_3658 * _3603)) * _3667);
                            } else {
                              _3676 = abs(_3574);
                              _3677 = 1.0f;
                            }
                          } else {
                            _3676 = _3584;
                            _3677 = _3581;
                          }
                          _3678 = saturate(_3566);
                          _3679 = _3567 * _3567;
                          _3680 = (_3573 > 0.0f);
                          if (_3680) {
                            _3689 = saturate(((_3573 * _3573) / ((_3676 * 3.5999999046325684f) + 0.4000000059604645f)) + _3679);
                          } else {
                            _3689 = _3679;
                          }
                          _3690 = sqrt(_3689);
                          if (_3585) {
                            _3701 = (_3689 / ((((_3571 * 0.25f) * ((_3690 * 3.0f) + _3571)) / (_3676 + 0.0010000000474974513f)) + _3689));
                          } else {
                            _3701 = 1.0f;
                          }
                          _3705 = (((_3689 * _3677) - _3677) * _3677) + 1.0f;
                          _3715 = exp2(log2(1.0f - saturate(_3676)) * 5.0f);
                          _3722 = abs(_3574);
                          _3724 = saturate(_3722 + 9.999999747378752e-06f);
                          _3725 = 1.0f - _3690;
                          _3734 = _231 * _231;
                          _3735 = _3734 * _3734;
                          _3741 = saturate(select((_3568 > 0.0f), ((1.0f - _3734) / _3568), 0.0f) * _3571);
                          _3742 = (_3741 > 0.0f);
                          if (_3742) {
                            _3746 = sqrt(1.0f - (_3741 * _3741));
                            _3748 = (_3548 * 2.0f) * _3574;
                            _3749 = _3748 - _3575;
                            if (!(_3749 >= _3746)) {
                              _3755 = rsqrt(1.0f - (_3749 * _3749)) * _3741;
                              _3758 = _3755 * (_3574 - (_3749 * _3548));
                              _3759 = _3574 * _3574;
                              _3764 = _3755 * (((_3759 * 2.0f) + -1.0f) - (_3749 * _3575));
                              _3773 = sqrt(saturate((((1.0f - (_3548 * _3548)) - _3759) - (_3575 * _3575)) + (_3748 * _3575)));
                              _3774 = _3773 * _3755;
                              _3777 = ((_3574 * 2.0f) * _3755) * _3773;
                              _3779 = (_3746 * _3548) + _3574;
                              _3780 = _3779 + _3758;
                              _3781 = _3746 * _3575;
                              _3783 = (_3781 + 1.0f) + _3764;
                              _3784 = _3774 * _3783;
                              _3785 = _3780 * _3783;
                              _3786 = _3777 * _3780;
                              _3791 = (((_3780 * 0.25f) * _3777) - (_3784 * 0.5f)) * _3785;
                              _3805 = (((_3786 - (_3784 * 2.0f)) * _3786) + (_3784 * _3784)) + ((((-0.5f - ((_3783 + _3781) * 0.5f)) * _3785) + ((_3783 * _3783) * _3779)) * _3780);
                              _3810 = (_3791 * 2.0f) / ((_3805 * _3805) + (_3791 * _3791));
                              _3811 = _3805 * _3810;
                              _3813 = 1.0f - (_3791 * _3810);
                              _3819 = ((_3811 * _3777) + _3781) + (_3813 * _3764);
                              _3822 = rsqrt((_3819 * 2.0f) + 2.0f);
                              _3831 = saturate((_3819 * _3822) + _3822);
                              _3832 = saturate(((_3779 + (_3811 * _3774)) + (_3813 * _3758)) * _3822);
                            } else {
                              _3831 = _3722;
                              _3832 = 1.0f;
                            }
                          } else {
                            _3831 = _3584;
                            _3832 = _3581;
                          }
                          if (_3680) {
                            _3841 = saturate(((_3573 * _3573) / ((_3831 * 3.5999999046325684f) + 0.4000000059604645f)) + _3735);
                          } else {
                            _3841 = _3735;
                          }
                          _3842 = sqrt(_3841);
                          if (_3742) {
                            _3853 = (_3841 / ((((_3741 * 0.25f) * ((_3842 * 3.0f) + _3741)) / (_3831 + 0.0010000000474974513f)) + _3841));
                          } else {
                            _3853 = 1.0f;
                          }
                          _3857 = (((_3841 * _3832) - _3832) * _3832) + 1.0f;
                          _3858 = 1.0f - _3842;
                          _3862 = saturate((_3548 + _2505) / (_2505 + 1.0f));
                          _3865 = ((_3701 * _3678) * (_3689 / (_3705 * _3705))) * (0.5f / ((((_3725 * _3724) + _3690) * _3678) + (((_3725 * _3678) + _3690) * _3724)));
                          _3866 = _3453 * _2301;
                          _3867 = _3454 * _2301;
                          _3868 = _3455 * _2301;
                          _3875 = ((_3541 * _3866) * _3862) + _2239;
                          _3876 = ((_3541 * _3867) * _3862) + _2240;
                          _3877 = ((_3541 * _3868) * _3862) + _2241;
                          if (_2502 > 0.0f) {
                            _3901 = (((exp2(log2(1.0f - saturate(_3831)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_3853 * _3678) * (_3841 / (_3857 * _3857))) * (0.5f / ((((_3858 * _3724) + _3842) * _3678) + (((_3858 * _3678) + _3842) * _3724))));
                            _3908 = (_2502 * _1998) * select(_3538, (_3534 * _1983), _3534);
                            _9759 = _3875;
                            _9760 = _3876;
                            _9761 = _3877;
                            _9762 = (((_3908 * _3866) * (_3901 + (_3865 * ((_3715 * (1.0f - _227)) + _227)))) + _2242);
                            _9763 = (((_3908 * _3867) * (_3901 + (_3865 * ((_3715 * (1.0f - _228)) + _228)))) + _2243);
                            _9764 = (((_3908 * _3868) * (_3901 + (_3865 * ((_3715 * (1.0f - _229)) + _229)))) + _2244);
                          } else {
                            _9759 = _3875;
                            _9760 = _3876;
                            _9761 = _3877;
                            _9762 = _2242;
                            _9763 = _2243;
                            _9764 = _2244;
                          }
                        } else {
                          _9759 = _2239;
                          _9760 = _2240;
                          _9761 = _2241;
                          _9762 = _2242;
                          _9763 = _2243;
                          _9764 = _2244;
                        }
                        break;
                      }
                    } else {
                      _9759 = _2239;
                      _9760 = _2240;
                      _9761 = _2241;
                      _9762 = _2242;
                      _9763 = _2243;
                      _9764 = _2244;
                    }
                  } else {
                    if (_2284 == 7) {
                      _4512 = asfloat(srvLightInfoProperties.Load3(_2253)).x;
                      _4513 = asfloat(srvLightInfoProperties.Load3(_2253)).y;
                      _4514 = asfloat(srvLightInfoProperties.Load3(_2253)).z;
                      _4517 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 12u)))).x;
                      _4518 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 12u)))).y;
                      _4519 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 12u)))).z;
                      _4522 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 24u)))).x;
                      _4523 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 24u)))).y;
                      _4524 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 24u)))).z;
                      _4527 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 36u)))).x;
                      _4528 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 36u)))).y;
                      _4529 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 36u)))).z;
                      _4532 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).x;
                      _4533 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).y;
                      _4534 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 48u)))).z;
                      _4537 = asint(srvLightInfoProperties.Load(((int)(_2253 + 60u))));
                      _4540 = asint(srvLightInfoProperties.Load(((int)(_2253 + 64u))));
                      _4543 = asint(srvLightInfoProperties.Load(((int)(_2253 + 72u))));
                      _4546 = asint(srvLightInfoProperties.Load(((int)(_2253 + 76u))));
                      _4549 = asint(srvLightInfoProperties.Load(((int)(_2253 + 80u))));
                      _4552 = asint(srvLightInfoProperties.Load(((int)(_2253 + 84u))));
                      _4555 = asint(srvLightInfoProperties.Load(((int)(_2253 + 88u))));
                      _4558 = asint(srvLightInfoProperties.Load(((int)(_2253 + 92u))));
                      _4561 = asint(srvLightInfoProperties.Load(((int)(_2253 + 96u))));
                      _4564 = asint(srvLightInfoProperties.Load(((int)(_2253 + 100u))));
                      _4567 = asint(srvLightInfoProperties.Load(((int)(_2253 + 104u))));
                      _4570 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).x;
                      _4571 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).y;
                      _4572 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).z;
                      _4573 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).w;
                      _4576 = asint(srvLightInfoProperties.Load(((int)(_2253 + 124u))));
                      _4579 = asint(srvLightInfoProperties.Load(((int)(_2253 + 128u))));
                      _4582 = asint(srvLightInfoProperties.Load(((int)(_2253 + 136u))));
                      _4585 = asint(srvLightInfoProperties.Load(((int)(_2253 + 140u))));
                      _4587 = f16tof32(((uint)((uint)(_4537) >> 16)));
                      _4588 = f16tof32(_4537);
                      _4590 = f16tof32(((uint)((uint)(_4540) >> 16)));
                      _4594 = ((float)((uint)((uint)(((uint)(_4540) >> 8) & 255)))) * 0.003921499941498041f;
                      _4597 = ((float)((uint)((uint)(_4540 & 255)))) * 0.003921499941498041f;
                      _4598 = f16tof32(_4543);
                      _4600 = f16tof32(((uint)((uint)(_4546) >> 16)));
                      _4604 = f16tof32(_4549);
                      _4606 = f16tof32(((uint)((uint)(_4552) >> 16)));
                      _4607 = f16tof32(_4552);
                      _4609 = f16tof32(((uint)((uint)(_4555) >> 16)));
                      _4612 = _4558 & 65535;
                      _4616 = ((_2251 & 4194304) != 0);
                      _4624 = f16tof32(((uint)((uint)(_4567) >> 16)));
                      _4625 = f16tof32(_4567);
                      _4627 = f16tof32(((uint)((uint)(_4576) >> 16)));
                      _4630 = f16tof32(((uint)((uint)(_4579) >> 16)));
                      _4631 = f16tof32(_4579);
                      _4633 = f16tof32(((uint)((uint)(_4582) >> 16)));
                      _4634 = _4633 + -1.0f;
                      if (_4616) {
                        _4636 = 0.5f / _4633;
                        _4637 = 0.3333333432674408f / _4633;
                        _4641 = (_4633 * 0.5f) + 0.5f;
                        _4651 = (_4636 * _4634);
                        _4652 = (_4637 * _4634);
                        _4653 = (_4636 * _4641);
                        _4654 = (_4637 * _4641);
                        _4655 = (_4633 * 2.0f);
                        _4656 = (_4633 * 3.0f);
                      } else {
                        _4647 = 1.0f / _4633;
                        _4648 = _4647 * _4634;
                        _4649 = _4647 * 0.5f;
                        _4651 = _4648;
                        _4652 = _4648;
                        _4653 = _4649;
                        _4654 = _4649;
                        _4655 = _4633;
                        _4656 = _4633;
                      }
                      _4660 = _4527 - _244;
                      _4661 = _4528 - _245;
                      _4662 = _4529 + _243;
                      _4663 = dot(float3(_4660, _4661, _4662), float3(_4660, _4661, _4662));
                      _4664 = rsqrt(_4663);
                      _4665 = _4664 * _4663;
                      _4666 = _4664 * _4660;
                      _4667 = _4664 * _4661;
                      _4668 = _4664 * _4662;
                      _4671 = max(0.0f, (_4665 - abs(_4604)));
                      _4672 = _4671 * f16tof32(((uint)((uint)(_4549) >> 16)));
                      _4673 = _4672 * _4672;
                      _4676 = saturate(1.0f - (_4673 * _4673));
                      _4683 = (_4676 * _4676) / (select((_4604 < 0.0f), (_4673 * 16.0f), (_4671 * _4671)) + 1.0f);
                      _4696 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_4666, _4667, _4668))) * f16tof32(_4576);
                      _4700 = abs(_4662);
                      _4704 = _4660 - ((_4696 * _205) * _4700);
                      _4705 = _4661 - ((_4696 * _207) * _4700);
                      _4706 = _4662 - ((_4696 * _209) * _4700);
                      _4709 = mad(_4706, _4523, mad(_4705, _4518, (_4704 * _4513)));
                      _4712 = mad(_4706, _4524, mad(_4705, _4519, (_4704 * _4514)));
                      _4714 = ((_2251 & 3584) != 0);
                      if (_4714 && (_4683 > 0.0f)) {
                        _4720 = mad(_4706, _4522, mad(_4705, _4517, (_4704 * _4512)));
                        _4721 = -0.0f - _4712;
                        _4722 = -0.0f - _4709;
                        [branch]
                        if (!((_2251 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_38 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_4558) >> 16))];
                          [branch]
                          if (_4616) {
                            _4727 = abs(_4720);
                            _4728 = abs(_4721);
                            _4729 = abs(_4722);
                            if (_4727 > max(_4728, _4729)) {
                              _4733 = (_4720 > 0.0f);
                              _4748 = select(_4733, 0.0f, 1.0f);
                              _4749 = 0.0f;
                              _4750 = select(_4733, _4709, _4722);
                              _4751 = _4712;
                              _4752 = _4727;
                            } else {
                              if (_4728 > _4729) {
                                _4739 = (_4712 < -0.0f);
                                _4748 = select(_4739, 0.0f, 1.0f);
                                _4749 = 1.0f;
                                _4750 = _4720;
                                _4751 = select(_4739, _4722, _4709);
                                _4752 = _4728;
                              } else {
                                _4743 = (_4709 < -0.0f);
                                _4748 = select(_4743, 0.0f, 1.0f);
                                _4749 = 2.0f;
                                _4750 = select(_4743, _4720, (-0.0f - _4720));
                                _4751 = _4712;
                                _4752 = _4729;
                              }
                            }
                            _4753 = _4752 * 2.0f;
                            _4757 = -0.0f - _4625;
                            _4766 = ((min(max((_4750 / _4753), _4757), _4625) + _4748) * _4651) + _4653;
                            _4767 = ((min(max((_4751 / _4753), _4757), _4625) + _4749) * _4652) + _4654;
                            _4774 = ((_4748 + -0.5f) * _4651) + _4653;
                            _4775 = ((_4749 + -0.5f) * _4652) + _4654;
                            _4778 = saturate((_4627 + 1.0f) - (_4752 * _4609));
                            _4782 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                            _4791 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 2u) : (frac(frac(dot(float2(((_4782 * 32.665000915527344f) + _142), ((_4782 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _4792 = sin(_4791);
                            _4793 = cos(_4791);
                            _4798 = select(((((float4)(_HeapResource_38.SampleLevel(samplerPointBorderWhiteNode, float2(_4766, _4767), 0.0f))).x) > _4778), 1.0f, 0.0f);
                            _4799 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                            _4804 = sqrt((float((int)(_4799)) * 0.25f) + 0.125f) * _4630;
                            _4813 = (_global_7[min((uint)(((int)(0u + (_4799 * 2)))), 127u)]) * _4804;
                            _4814 = (_global_7[min((uint)(((int)(1u + (_4799 * 2)))), 127u)]) * _4804;
                            _4816 = -0.0f - _4792;
                            _4818 = dot(float2(_4813, _4814), float2(_4793, _4792)) + _4766;
                            _4819 = dot(float2(_4813, _4814), float2(_4816, _4793)) + _4767;
                            _4821 = _HeapResource_38.GatherRed(samplerPointClampNode, float2(_4818, _4819));
                            _4825 = _4818 * _4655;
                            _4826 = _4819 * _4656;
                            _4829 = floor(_4774 * _4655);
                            _4830 = floor(_4775 * _4656);
                            _4835 = floor(((_4774 + _4651) * _4655) + 0.5f);
                            _4836 = floor(((_4775 + _4652) * _4656) + 0.5f);
                            _4839 = floor(_4825 + -0.5f);
                            _4840 = floor(_4826 + 0.5f);
                            _4842 = floor(_4825 + 0.5f);
                            _4844 = floor(_4826 + -0.5f);
                            _4845 = (_4839 < _4829);
                            _4846 = (_4840 < _4830);
                            if ((_4845 || _4846) | ((_4839 >= _4835) || (_4840 >= _4836))) {
                              _4855 = _4798;
                            } else {
                              _4855 = _4821.x;
                            }
                            _4856 = (_4842 < _4829);
                            if ((_4856 || _4846) | ((_4842 >= _4835) || (_4840 >= _4836))) {
                              _4864 = _4798;
                            } else {
                              _4864 = _4821.y;
                            }
                            _4865 = (_4844 < _4830);
                            if ((_4856 || _4865) | ((_4842 >= _4835) || (_4844 >= _4836))) {
                              _4873 = _4798;
                            } else {
                              _4873 = _4821.z;
                            }
                            if ((_4845 || _4865) | ((_4839 >= _4835) || (_4844 >= _4836))) {
                              _4881 = _4798;
                            } else {
                              _4881 = _4821.w;
                            }
                            _4882 = _4855 - _4778;
                            _4884 = select((_4882 < 0.0f), 0.0f, 1.0f);
                            _4886 = _4864 - _4778;
                            _4888 = select((_4886 < 0.0f), 0.0f, 1.0f);
                            _4892 = _4873 - _4778;
                            _4894 = select((_4892 < 0.0f), 0.0f, 1.0f);
                            _4898 = _4881 - _4778;
                            _4900 = select((_4898 < 0.0f), 0.0f, 1.0f);
                            _4907 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                            _4912 = sqrt((float((int)(_4907)) * 0.25f) + 0.125f) * _4630;
                            _4921 = (_global_7[min((uint)(((int)(0u + (_4907 * 2)))), 127u)]) * _4912;
                            _4922 = (_global_7[min((uint)(((int)(1u + (_4907 * 2)))), 127u)]) * _4912;
                            _4925 = dot(float2(_4921, _4922), float2(_4793, _4792)) + _4766;
                            _4926 = dot(float2(_4921, _4922), float2(_4816, _4793)) + _4767;
                            _4928 = _HeapResource_38.GatherRed(samplerPointClampNode, float2(_4925, _4926));
                            _4932 = _4925 * _4655;
                            _4933 = _4926 * _4656;
                            _4936 = floor(_4932 + -0.5f);
                            _4937 = floor(_4933 + 0.5f);
                            _4939 = floor(_4932 + 0.5f);
                            _4941 = floor(_4933 + -0.5f);
                            _4942 = (_4936 < _4829);
                            _4943 = (_4937 < _4830);
                            if ((_4942 || _4943) | ((_4936 >= _4835) || (_4937 >= _4836))) {
                              _4952 = _4798;
                            } else {
                              _4952 = _4928.x;
                            }
                            _4953 = (_4939 < _4829);
                            if ((_4953 || _4943) | ((_4939 >= _4835) || (_4937 >= _4836))) {
                              _4961 = _4798;
                            } else {
                              _4961 = _4928.y;
                            }
                            _4962 = (_4941 < _4830);
                            if ((_4953 || _4962) | ((_4939 >= _4835) || (_4941 >= _4836))) {
                              _4970 = _4798;
                            } else {
                              _4970 = _4928.z;
                            }
                            if ((_4942 || _4962) | ((_4936 >= _4835) || (_4941 >= _4836))) {
                              _4978 = _4798;
                            } else {
                              _4978 = _4928.w;
                            }
                            _4979 = _4952 - _4778;
                            _4981 = select((_4979 < 0.0f), 0.0f, 1.0f);
                            _4985 = _4961 - _4778;
                            _4987 = select((_4985 < 0.0f), 0.0f, 1.0f);
                            _4991 = _4970 - _4778;
                            _4993 = select((_4991 < 0.0f), 0.0f, 1.0f);
                            _4997 = _4978 - _4778;
                            _4999 = select((_4997 < 0.0f), 0.0f, 1.0f);
                            _5006 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                            _5011 = sqrt((float((int)(_5006)) * 0.25f) + 0.125f) * _4630;
                            _5020 = (_global_7[min((uint)(((int)(0u + (_5006 * 2)))), 127u)]) * _5011;
                            _5021 = (_global_7[min((uint)(((int)(1u + (_5006 * 2)))), 127u)]) * _5011;
                            _5024 = dot(float2(_5020, _5021), float2(_4793, _4792)) + _4766;
                            _5025 = dot(float2(_5020, _5021), float2(_4816, _4793)) + _4767;
                            _5027 = _HeapResource_38.GatherRed(samplerPointClampNode, float2(_5024, _5025));
                            _5031 = _5024 * _4655;
                            _5032 = _5025 * _4656;
                            _5035 = floor(_5031 + -0.5f);
                            _5036 = floor(_5032 + 0.5f);
                            _5038 = floor(_5031 + 0.5f);
                            _5040 = floor(_5032 + -0.5f);
                            _5041 = (_5035 < _4829);
                            _5042 = (_5036 < _4830);
                            if ((_5041 || _5042) | ((_5035 >= _4835) || (_5036 >= _4836))) {
                              _5051 = _4798;
                            } else {
                              _5051 = _5027.x;
                            }
                            _5052 = (_5038 < _4829);
                            if ((_5052 || _5042) | ((_5038 >= _4835) || (_5036 >= _4836))) {
                              _5060 = _4798;
                            } else {
                              _5060 = _5027.y;
                            }
                            _5061 = (_5040 < _4830);
                            if ((_5052 || _5061) | ((_5038 >= _4835) || (_5040 >= _4836))) {
                              _5069 = _4798;
                            } else {
                              _5069 = _5027.z;
                            }
                            if ((_5041 || _5061) | ((_5035 >= _4835) || (_5040 >= _4836))) {
                              _5077 = _4798;
                            } else {
                              _5077 = _5027.w;
                            }
                            _5078 = _5051 - _4778;
                            _5080 = select((_5078 < 0.0f), 0.0f, 1.0f);
                            _5084 = _5060 - _4778;
                            _5086 = select((_5084 < 0.0f), 0.0f, 1.0f);
                            _5090 = _5069 - _4778;
                            _5092 = select((_5090 < 0.0f), 0.0f, 1.0f);
                            _5096 = _5077 - _4778;
                            _5098 = select((_5096 < 0.0f), 0.0f, 1.0f);
                            _5105 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                            _5110 = sqrt((float((int)(_5105)) * 0.25f) + 0.125f) * _4630;
                            _5119 = (_global_7[min((uint)(((int)(0u + (_5105 * 2)))), 127u)]) * _5110;
                            _5120 = (_global_7[min((uint)(((int)(1u + (_5105 * 2)))), 127u)]) * _5110;
                            _5123 = dot(float2(_5119, _5120), float2(_4793, _4792)) + _4766;
                            _5124 = dot(float2(_5119, _5120), float2(_4816, _4793)) + _4767;
                            _5126 = _HeapResource_38.GatherRed(samplerPointClampNode, float2(_5123, _5124));
                            _5130 = _5123 * _4655;
                            _5131 = _5124 * _4656;
                            _5134 = floor(_5130 + -0.5f);
                            _5135 = floor(_5131 + 0.5f);
                            _5137 = floor(_5130 + 0.5f);
                            _5139 = floor(_5131 + -0.5f);
                            _5140 = (_5134 < _4829);
                            _5141 = (_5135 < _4830);
                            if ((_5140 || _5141) | ((_5134 >= _4835) || (_5135 >= _4836))) {
                              _5150 = _4798;
                            } else {
                              _5150 = _5126.x;
                            }
                            _5151 = (_5137 < _4829);
                            if ((_5151 || _5141) | ((_5137 >= _4835) || (_5135 >= _4836))) {
                              _5159 = _4798;
                            } else {
                              _5159 = _5126.y;
                            }
                            _5160 = (_5139 < _4830);
                            if ((_5151 || _5160) | ((_5137 >= _4835) || (_5139 >= _4836))) {
                              _5168 = _4798;
                            } else {
                              _5168 = _5126.z;
                            }
                            if ((_5140 || _5160) | ((_5134 >= _4835) || (_5139 >= _4836))) {
                              _5176 = _4798;
                            } else {
                              _5176 = _5126.w;
                            }
                            _5177 = _5150 - _4778;
                            _5179 = select((_5177 < 0.0f), 0.0f, 1.0f);
                            _5183 = _5159 - _4778;
                            _5185 = select((_5183 < 0.0f), 0.0f, 1.0f);
                            _5189 = _5168 - _4778;
                            _5191 = select((_5189 < 0.0f), 0.0f, 1.0f);
                            _5195 = _5176 - _4778;
                            _5197 = select((_5195 < 0.0f), 0.0f, 1.0f);
                            _5198 = ((((((((((((((_4888 + _4884) + _4894) + _4900) + _4981) + _4987) + _4993) + _4999) + _5080) + _5086) + _5092) + _5098) + _5179) + _5185) + _5191) + _5197;
                            _5209 = (saturate(_5198 * 0.0625f) * 2.0f) + -1.0f;
                            _5215 = float((int)(((int)(uint)((int)(_5209 > 0.0f))) - ((int)(uint)((int)(_5209 < 0.0f)))));
                            _5217 = 1.0f - (_5215 * _5209);
                            _5219 = (_5217 * _5217) * _5217;
                            _5511 = 1;
                            _5512 = (0.5f - ((_5215 * 0.5f) * ((1.0f - _5219) - ((_5217 - _5219) * saturate(((1.0f / _4778) * (1.0f / _5198)) * ((((((((((((((((_4888 * _4886) + (_4884 * _4882)) + (_4894 * _4892)) + (_4900 * _4898)) + (_4981 * _4979)) + (_4987 * _4985)) + (_4993 * _4991)) + (_4999 * _4997)) + (_5080 * _5078)) + (_5086 * _5084)) + (_5092 * _5090)) + (_5098 * _5096)) + (_5179 * _5177)) + (_5185 * _5183)) + (_5191 * _5189)) + (_5197 * _5195)))))));
                            _5513 = 1.0f;
                          } else {
                            _5228 = f16tof32(_4585) / _4722;
                            _5231 = mad((_5228 * _4720), 0.5f, 0.5f);
                            _5232 = mad((_5228 * _4721), 0.5f, 0.5f);
                            if (_4709 > -0.0f) {
                              if ((saturate(_5231) == _5231) && (saturate(_5232) == _5232)) {
                                _5246 = (_5231 * _4651) + _4653;
                                _5247 = (_5232 * _4652) + _4654;
                                _5248 = saturate((_4627 + 1.0f) - (_4709 * _4609));
                                _5252 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                                _5261 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 3u) : (frac(frac(dot(float2(((_5252 * 32.665000915527344f) + _142), ((_5252 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _5262 = sin(_5261);
                                _5263 = cos(_5261);
                                _5264 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                                _5269 = sqrt((float((int)(_5264)) * 0.25f) + 0.125f) * _4630;
                                _5278 = (_global_7[min((uint)(((int)(0u + (_5264 * 2)))), 127u)]) * _5269;
                                _5279 = (_global_7[min((uint)(((int)(1u + (_5264 * 2)))), 127u)]) * _5269;
                                _5281 = -0.0f - _5262;
                                _5286 = _HeapResource_38.GatherRed(samplerPointClampNode, float2((dot(float2(_5278, _5279), float2(_5263, _5262)) + _5246), (dot(float2(_5278, _5279), float2(_5281, _5263)) + _5247)));
                                _5291 = _5286.x - _5248;
                                _5293 = select((_5291 < 0.0f), 0.0f, 1.0f);
                                _5295 = _5286.y - _5248;
                                _5297 = select((_5295 < 0.0f), 0.0f, 1.0f);
                                _5301 = _5286.z - _5248;
                                _5303 = select((_5301 < 0.0f), 0.0f, 1.0f);
                                _5307 = _5286.w - _5248;
                                _5309 = select((_5307 < 0.0f), 0.0f, 1.0f);
                                _5316 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                                _5321 = sqrt((float((int)(_5316)) * 0.25f) + 0.125f) * _4630;
                                _5330 = (_global_7[min((uint)(((int)(0u + (_5316 * 2)))), 127u)]) * _5321;
                                _5331 = (_global_7[min((uint)(((int)(1u + (_5316 * 2)))), 127u)]) * _5321;
                                _5337 = _HeapResource_38.GatherRed(samplerPointClampNode, float2((dot(float2(_5330, _5331), float2(_5263, _5262)) + _5246), (dot(float2(_5330, _5331), float2(_5281, _5263)) + _5247)));
                                _5342 = _5337.x - _5248;
                                _5344 = select((_5342 < 0.0f), 0.0f, 1.0f);
                                _5348 = _5337.y - _5248;
                                _5350 = select((_5348 < 0.0f), 0.0f, 1.0f);
                                _5354 = _5337.z - _5248;
                                _5356 = select((_5354 < 0.0f), 0.0f, 1.0f);
                                _5360 = _5337.w - _5248;
                                _5362 = select((_5360 < 0.0f), 0.0f, 1.0f);
                                _5369 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                                _5374 = sqrt((float((int)(_5369)) * 0.25f) + 0.125f) * _4630;
                                _5383 = (_global_7[min((uint)(((int)(0u + (_5369 * 2)))), 127u)]) * _5374;
                                _5384 = (_global_7[min((uint)(((int)(1u + (_5369 * 2)))), 127u)]) * _5374;
                                _5390 = _HeapResource_38.GatherRed(samplerPointClampNode, float2((dot(float2(_5383, _5384), float2(_5263, _5262)) + _5246), (dot(float2(_5383, _5384), float2(_5281, _5263)) + _5247)));
                                _5395 = _5390.x - _5248;
                                _5397 = select((_5395 < 0.0f), 0.0f, 1.0f);
                                _5401 = _5390.y - _5248;
                                _5403 = select((_5401 < 0.0f), 0.0f, 1.0f);
                                _5407 = _5390.z - _5248;
                                _5409 = select((_5407 < 0.0f), 0.0f, 1.0f);
                                _5413 = _5390.w - _5248;
                                _5415 = select((_5413 < 0.0f), 0.0f, 1.0f);
                                _5422 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                                _5427 = sqrt((float((int)(_5422)) * 0.25f) + 0.125f) * _4630;
                                _5436 = (_global_7[min((uint)(((int)(0u + (_5422 * 2)))), 127u)]) * _5427;
                                _5437 = (_global_7[min((uint)(((int)(1u + (_5422 * 2)))), 127u)]) * _5427;
                                _5443 = _HeapResource_38.GatherRed(samplerPointClampNode, float2((dot(float2(_5436, _5437), float2(_5263, _5262)) + _5246), (dot(float2(_5436, _5437), float2(_5281, _5263)) + _5247)));
                                _5448 = _5443.x - _5248;
                                _5450 = select((_5448 < 0.0f), 0.0f, 1.0f);
                                _5454 = _5443.y - _5248;
                                _5456 = select((_5454 < 0.0f), 0.0f, 1.0f);
                                _5460 = _5443.z - _5248;
                                _5462 = select((_5460 < 0.0f), 0.0f, 1.0f);
                                _5466 = _5443.w - _5248;
                                _5468 = select((_5466 < 0.0f), 0.0f, 1.0f);
                                _5469 = ((((((((((((((_5293 + _5297) + _5303) + _5309) + _5344) + _5350) + _5356) + _5362) + _5397) + _5403) + _5409) + _5415) + _5450) + _5456) + _5462) + _5468;
                                _5480 = (saturate(_5469 * 0.0625f) * 2.0f) + -1.0f;
                                _5486 = float((int)(((int)(uint)((int)(_5480 > 0.0f))) - ((int)(uint)((int)(_5480 < 0.0f)))));
                                _5488 = 1.0f - (_5486 * _5480);
                                _5490 = (_5488 * _5488) * _5488;
                                _5498 = -0.0f - _4720;
                                _5505 = saturate((saturate(rsqrt(dot(float3(_5498, _4712, _4709), float3(_5498, _4712, _4709))) * _4709) * _4607) + _4606);
                                _5507 = 1.0f - (_5505 * _5505);
                                _5511 = 1;
                                _5512 = (0.5f - ((_5486 * 0.5f) * ((1.0f - _5490) - ((_5488 - _5490) * saturate(((1.0f / _5248) * (1.0f / _5469)) * ((((((((((((((((_5293 * _5291) + (_5297 * _5295)) + (_5303 * _5301)) + (_5309 * _5307)) + (_5344 * _5342)) + (_5350 * _5348)) + (_5356 * _5354)) + (_5362 * _5360)) + (_5397 * _5395)) + (_5403 * _5401)) + (_5409 * _5407)) + (_5415 * _5413)) + (_5450 * _5448)) + (_5456 * _5454)) + (_5462 * _5460)) + (_5468 * _5466)))))));
                                _5513 = (1.0f - (_5507 * _5507));
                              } else {
                                _5511 = 0;
                                _5512 = 1.0f;
                                _5513 = 1.0f;
                              }
                            } else {
                              _5511 = 0;
                              _5512 = 1.0f;
                              _5513 = 1.0f;
                            }
                          }
                        } else {
                          _5511 = 0;
                          _5512 = 1.0f;
                          _5513 = 1.0f;
                        }
                        [branch]
                        if (!((_2251 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_39 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_2251 & 2097152) == 0)) {
                            _5521 = abs(_4720);
                            _5522 = abs(_4721);
                            _5523 = abs(_4722);
                            if (_5521 > max(_5522, _5523)) {
                              _5527 = (_4720 > 0.0f);
                              _5542 = select(_5527, 0.0f, 1.0f);
                              _5543 = 0.0f;
                              _5544 = select(_5527, _4709, _4722);
                              _5545 = _4712;
                              _5546 = _5521;
                            } else {
                              if (_5522 > _5523) {
                                _5533 = (_4712 < -0.0f);
                                _5542 = select(_5533, 0.0f, 1.0f);
                                _5543 = 1.0f;
                                _5544 = _4720;
                                _5545 = select(_5533, _4722, _4709);
                                _5546 = _5522;
                              } else {
                                _5537 = (_4709 < -0.0f);
                                _5542 = select(_5537, 0.0f, 1.0f);
                                _5543 = 2.0f;
                                _5544 = select(_5537, _4720, (-0.0f - _4720));
                                _5545 = _4712;
                                _5546 = _5523;
                              }
                            }
                            _5547 = _5546 * 2.0f;
                            _5552 = -0.0f - _4624;
                            _5561 = ((min(max((_5544 / _5547), _5552), _4624) + _5542) * _4570) + _4572;
                            _5562 = ((min(max((_5545 / _5547), _5552), _4624) + _5543) * _4571) + _4573;
                            _5567 = ((_5542 + -0.5f) * _4570) + _4572;
                            _5568 = ((_5543 + -0.5f) * _4571) + _4573;
                            _5571 = saturate(1.0f - (_5546 * _4609));
                            _5575 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                            _5584 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 4u) : (frac(frac(dot(float2(((_5575 * 32.665000915527344f) + _142), ((_5575 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _5585 = sin(_5584);
                            _5586 = cos(_5584);
                            _5591 = select(((((float4)(_HeapResource_39.SampleLevel(samplerPointBorderWhiteNode, float2(_5561, _5562), 0.0f))).x) > _5571), 1.0f, 0.0f);
                            _5592 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                            _5597 = sqrt((float((int)(_5592)) * 0.25f) + 0.125f) * _4631;
                            _5606 = (_global_7[min((uint)(((int)(0u + (_5592 * 2)))), 127u)]) * _5597;
                            _5607 = (_global_7[min((uint)(((int)(1u + (_5592 * 2)))), 127u)]) * _5597;
                            _5609 = -0.0f - _5585;
                            _5611 = dot(float2(_5606, _5607), float2(_5586, _5585)) + _5561;
                            _5612 = dot(float2(_5606, _5607), float2(_5609, _5586)) + _5562;
                            _5614 = _HeapResource_39.GatherRed(samplerPointClampNode, float2(_5611, _5612));
                            _5618 = _5611 * (_cbSharedPerViewData_raw[82u].x);
                            _5619 = _5612 * (_cbSharedPerViewData_raw[82u].y);
                            _5622 = floor(_5567 * (_cbSharedPerViewData_raw[82u].x));
                            _5623 = floor(_5568 * (_cbSharedPerViewData_raw[82u].y));
                            _5628 = floor(((_5567 + _4570) * (_cbSharedPerViewData_raw[82u].x)) + 0.5f);
                            _5629 = floor(((_5568 + _4571) * (_cbSharedPerViewData_raw[82u].y)) + 0.5f);
                            _5632 = floor(_5618 + -0.5f);
                            _5633 = floor(_5619 + 0.5f);
                            _5635 = floor(_5618 + 0.5f);
                            _5637 = floor(_5619 + -0.5f);
                            _5638 = (_5632 < _5622);
                            _5639 = (_5633 < _5623);
                            if ((_5638 || _5639) | ((_5632 >= _5628) || (_5633 >= _5629))) {
                              _5648 = _5591;
                            } else {
                              _5648 = _5614.x;
                            }
                            _5649 = (_5635 < _5622);
                            if ((_5649 || _5639) | ((_5635 >= _5628) || (_5633 >= _5629))) {
                              _5657 = _5591;
                            } else {
                              _5657 = _5614.y;
                            }
                            _5658 = (_5637 < _5623);
                            if ((_5649 || _5658) | ((_5635 >= _5628) || (_5637 >= _5629))) {
                              _5666 = _5591;
                            } else {
                              _5666 = _5614.z;
                            }
                            if ((_5638 || _5658) | ((_5632 >= _5628) || (_5637 >= _5629))) {
                              _5674 = _5591;
                            } else {
                              _5674 = _5614.w;
                            }
                            _5675 = _5648 - _5571;
                            _5677 = select((_5675 < 0.0f), 0.0f, 1.0f);
                            _5679 = _5657 - _5571;
                            _5681 = select((_5679 < 0.0f), 0.0f, 1.0f);
                            _5685 = _5666 - _5571;
                            _5687 = select((_5685 < 0.0f), 0.0f, 1.0f);
                            _5691 = _5674 - _5571;
                            _5693 = select((_5691 < 0.0f), 0.0f, 1.0f);
                            _5700 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                            _5705 = sqrt((float((int)(_5700)) * 0.25f) + 0.125f) * _4631;
                            _5714 = (_global_7[min((uint)(((int)(0u + (_5700 * 2)))), 127u)]) * _5705;
                            _5715 = (_global_7[min((uint)(((int)(1u + (_5700 * 2)))), 127u)]) * _5705;
                            _5718 = dot(float2(_5714, _5715), float2(_5586, _5585)) + _5561;
                            _5719 = dot(float2(_5714, _5715), float2(_5609, _5586)) + _5562;
                            _5721 = _HeapResource_39.GatherRed(samplerPointClampNode, float2(_5718, _5719));
                            _5725 = _5718 * (_cbSharedPerViewData_raw[82u].x);
                            _5726 = _5719 * (_cbSharedPerViewData_raw[82u].y);
                            _5729 = floor(_5725 + -0.5f);
                            _5730 = floor(_5726 + 0.5f);
                            _5732 = floor(_5725 + 0.5f);
                            _5734 = floor(_5726 + -0.5f);
                            _5735 = (_5729 < _5622);
                            _5736 = (_5730 < _5623);
                            if ((_5735 || _5736) | ((_5729 >= _5628) || (_5730 >= _5629))) {
                              _5745 = _5591;
                            } else {
                              _5745 = _5721.x;
                            }
                            _5746 = (_5732 < _5622);
                            if ((_5746 || _5736) | ((_5732 >= _5628) || (_5730 >= _5629))) {
                              _5754 = _5591;
                            } else {
                              _5754 = _5721.y;
                            }
                            _5755 = (_5734 < _5623);
                            if ((_5746 || _5755) | ((_5732 >= _5628) || (_5734 >= _5629))) {
                              _5763 = _5591;
                            } else {
                              _5763 = _5721.z;
                            }
                            if ((_5735 || _5755) | ((_5729 >= _5628) || (_5734 >= _5629))) {
                              _5771 = _5591;
                            } else {
                              _5771 = _5721.w;
                            }
                            _5772 = _5745 - _5571;
                            _5774 = select((_5772 < 0.0f), 0.0f, 1.0f);
                            _5778 = _5754 - _5571;
                            _5780 = select((_5778 < 0.0f), 0.0f, 1.0f);
                            _5784 = _5763 - _5571;
                            _5786 = select((_5784 < 0.0f), 0.0f, 1.0f);
                            _5790 = _5771 - _5571;
                            _5792 = select((_5790 < 0.0f), 0.0f, 1.0f);
                            _5799 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                            _5804 = sqrt((float((int)(_5799)) * 0.25f) + 0.125f) * _4631;
                            _5813 = (_global_7[min((uint)(((int)(0u + (_5799 * 2)))), 127u)]) * _5804;
                            _5814 = (_global_7[min((uint)(((int)(1u + (_5799 * 2)))), 127u)]) * _5804;
                            _5817 = dot(float2(_5813, _5814), float2(_5586, _5585)) + _5561;
                            _5818 = dot(float2(_5813, _5814), float2(_5609, _5586)) + _5562;
                            _5820 = _HeapResource_39.GatherRed(samplerPointClampNode, float2(_5817, _5818));
                            _5824 = _5817 * (_cbSharedPerViewData_raw[82u].x);
                            _5825 = _5818 * (_cbSharedPerViewData_raw[82u].y);
                            _5828 = floor(_5824 + -0.5f);
                            _5829 = floor(_5825 + 0.5f);
                            _5831 = floor(_5824 + 0.5f);
                            _5833 = floor(_5825 + -0.5f);
                            _5834 = (_5828 < _5622);
                            _5835 = (_5829 < _5623);
                            if ((_5834 || _5835) | ((_5828 >= _5628) || (_5829 >= _5629))) {
                              _5844 = _5591;
                            } else {
                              _5844 = _5820.x;
                            }
                            _5845 = (_5831 < _5622);
                            if ((_5845 || _5835) | ((_5831 >= _5628) || (_5829 >= _5629))) {
                              _5853 = _5591;
                            } else {
                              _5853 = _5820.y;
                            }
                            _5854 = (_5833 < _5623);
                            if ((_5845 || _5854) | ((_5831 >= _5628) || (_5833 >= _5629))) {
                              _5862 = _5591;
                            } else {
                              _5862 = _5820.z;
                            }
                            if ((_5834 || _5854) | ((_5828 >= _5628) || (_5833 >= _5629))) {
                              _5870 = _5591;
                            } else {
                              _5870 = _5820.w;
                            }
                            _5871 = _5844 - _5571;
                            _5873 = select((_5871 < 0.0f), 0.0f, 1.0f);
                            _5877 = _5853 - _5571;
                            _5879 = select((_5877 < 0.0f), 0.0f, 1.0f);
                            _5883 = _5862 - _5571;
                            _5885 = select((_5883 < 0.0f), 0.0f, 1.0f);
                            _5889 = _5870 - _5571;
                            _5891 = select((_5889 < 0.0f), 0.0f, 1.0f);
                            _5898 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                            _5903 = sqrt((float((int)(_5898)) * 0.25f) + 0.125f) * _4631;
                            _5912 = (_global_7[min((uint)(((int)(0u + (_5898 * 2)))), 127u)]) * _5903;
                            _5913 = (_global_7[min((uint)(((int)(1u + (_5898 * 2)))), 127u)]) * _5903;
                            _5916 = dot(float2(_5912, _5913), float2(_5586, _5585)) + _5561;
                            _5917 = dot(float2(_5912, _5913), float2(_5609, _5586)) + _5562;
                            _5919 = _HeapResource_39.GatherRed(samplerPointClampNode, float2(_5916, _5917));
                            _5923 = _5916 * (_cbSharedPerViewData_raw[82u].x);
                            _5924 = _5917 * (_cbSharedPerViewData_raw[82u].y);
                            _5927 = floor(_5923 + -0.5f);
                            _5928 = floor(_5924 + 0.5f);
                            _5930 = floor(_5923 + 0.5f);
                            _5932 = floor(_5924 + -0.5f);
                            _5933 = (_5927 < _5622);
                            _5934 = (_5928 < _5623);
                            if ((_5933 || _5934) | ((_5927 >= _5628) || (_5928 >= _5629))) {
                              _5943 = _5591;
                            } else {
                              _5943 = _5919.x;
                            }
                            _5944 = (_5930 < _5622);
                            if ((_5944 || _5934) | ((_5930 >= _5628) || (_5928 >= _5629))) {
                              _5952 = _5591;
                            } else {
                              _5952 = _5919.y;
                            }
                            _5953 = (_5932 < _5623);
                            if ((_5944 || _5953) | ((_5930 >= _5628) || (_5932 >= _5629))) {
                              _5961 = _5591;
                            } else {
                              _5961 = _5919.z;
                            }
                            if ((_5933 || _5953) | ((_5927 >= _5628) || (_5932 >= _5629))) {
                              _5969 = _5591;
                            } else {
                              _5969 = _5919.w;
                            }
                            _5970 = _5943 - _5571;
                            _5972 = select((_5970 < 0.0f), 0.0f, 1.0f);
                            _5976 = _5952 - _5571;
                            _5978 = select((_5976 < 0.0f), 0.0f, 1.0f);
                            _5982 = _5961 - _5571;
                            _5984 = select((_5982 < 0.0f), 0.0f, 1.0f);
                            _5988 = _5969 - _5571;
                            _5990 = select((_5988 < 0.0f), 0.0f, 1.0f);
                            _5991 = ((((((((((((((_5681 + _5677) + _5687) + _5693) + _5774) + _5780) + _5786) + _5792) + _5873) + _5879) + _5885) + _5891) + _5972) + _5978) + _5984) + _5990;
                            _6002 = (saturate(_5991 * 0.0625f) * 2.0f) + -1.0f;
                            _6008 = float((int)(((int)(uint)((int)(_6002 > 0.0f))) - ((int)(uint)((int)(_6002 < 0.0f)))));
                            _6010 = 1.0f - (_6008 * _6002);
                            _6012 = (_6010 * _6010) * _6010;
                            _6303 = false;
                            _6304 = (0.5f - ((_6008 * 0.5f) * ((1.0f - _6012) - ((_6010 - _6012) * saturate(((1.0f / _5571) * (1.0f / _5991)) * ((((((((((((((((_5681 * _5679) + (_5677 * _5675)) + (_5687 * _5685)) + (_5693 * _5691)) + (_5774 * _5772)) + (_5780 * _5778)) + (_5786 * _5784)) + (_5792 * _5790)) + (_5873 * _5871)) + (_5879 * _5877)) + (_5885 * _5883)) + (_5891 * _5889)) + (_5972 * _5970)) + (_5978 * _5976)) + (_5984 * _5982)) + (_5990 * _5988)))))));
                            _6305 = 1.0f;
                          } else {
                            _6021 = f16tof32(((uint)((uint)(_4585) >> 16))) / _4722;
                            _6024 = mad((_6021 * _4720), 0.5f, 0.5f);
                            _6025 = mad((_6021 * _4721), 0.5f, 0.5f);
                            if (_4709 > -0.0f) {
                              if ((saturate(_6024) == _6024) && (saturate(_6025) == _6025)) {
                                _6038 = (_6024 * _4570) + _4572;
                                _6039 = (_6025 * _4571) + _4573;
                                _6040 = saturate(1.0f - (_4709 * _4609));
                                _6044 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                                _6053 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 5u) : (frac(frac(dot(float2(((_6044 * 32.665000915527344f) + _142), ((_6044 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _6054 = sin(_6053);
                                _6055 = cos(_6053);
                                _6056 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                                _6061 = sqrt((float((int)(_6056)) * 0.25f) + 0.125f) * _4631;
                                _6070 = (_global_7[min((uint)(((int)(0u + (_6056 * 2)))), 127u)]) * _6061;
                                _6071 = (_global_7[min((uint)(((int)(1u + (_6056 * 2)))), 127u)]) * _6061;
                                _6073 = -0.0f - _6054;
                                _6078 = _HeapResource_39.GatherRed(samplerPointClampNode, float2((dot(float2(_6070, _6071), float2(_6055, _6054)) + _6038), (dot(float2(_6070, _6071), float2(_6073, _6055)) + _6039)));
                                _6083 = _6078.x - _6040;
                                _6085 = select((_6083 < 0.0f), 0.0f, 1.0f);
                                _6087 = _6078.y - _6040;
                                _6089 = select((_6087 < 0.0f), 0.0f, 1.0f);
                                _6093 = _6078.z - _6040;
                                _6095 = select((_6093 < 0.0f), 0.0f, 1.0f);
                                _6099 = _6078.w - _6040;
                                _6101 = select((_6099 < 0.0f), 0.0f, 1.0f);
                                _6108 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                                _6113 = sqrt((float((int)(_6108)) * 0.25f) + 0.125f) * _4631;
                                _6122 = (_global_7[min((uint)(((int)(0u + (_6108 * 2)))), 127u)]) * _6113;
                                _6123 = (_global_7[min((uint)(((int)(1u + (_6108 * 2)))), 127u)]) * _6113;
                                _6129 = _HeapResource_39.GatherRed(samplerPointClampNode, float2((dot(float2(_6122, _6123), float2(_6055, _6054)) + _6038), (dot(float2(_6122, _6123), float2(_6073, _6055)) + _6039)));
                                _6134 = _6129.x - _6040;
                                _6136 = select((_6134 < 0.0f), 0.0f, 1.0f);
                                _6140 = _6129.y - _6040;
                                _6142 = select((_6140 < 0.0f), 0.0f, 1.0f);
                                _6146 = _6129.z - _6040;
                                _6148 = select((_6146 < 0.0f), 0.0f, 1.0f);
                                _6152 = _6129.w - _6040;
                                _6154 = select((_6152 < 0.0f), 0.0f, 1.0f);
                                _6161 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                                _6166 = sqrt((float((int)(_6161)) * 0.25f) + 0.125f) * _4631;
                                _6175 = (_global_7[min((uint)(((int)(0u + (_6161 * 2)))), 127u)]) * _6166;
                                _6176 = (_global_7[min((uint)(((int)(1u + (_6161 * 2)))), 127u)]) * _6166;
                                _6182 = _HeapResource_39.GatherRed(samplerPointClampNode, float2((dot(float2(_6175, _6176), float2(_6055, _6054)) + _6038), (dot(float2(_6175, _6176), float2(_6073, _6055)) + _6039)));
                                _6187 = _6182.x - _6040;
                                _6189 = select((_6187 < 0.0f), 0.0f, 1.0f);
                                _6193 = _6182.y - _6040;
                                _6195 = select((_6193 < 0.0f), 0.0f, 1.0f);
                                _6199 = _6182.z - _6040;
                                _6201 = select((_6199 < 0.0f), 0.0f, 1.0f);
                                _6205 = _6182.w - _6040;
                                _6207 = select((_6205 < 0.0f), 0.0f, 1.0f);
                                _6214 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                                _6219 = sqrt((float((int)(_6214)) * 0.25f) + 0.125f) * _4631;
                                _6228 = (_global_7[min((uint)(((int)(0u + (_6214 * 2)))), 127u)]) * _6219;
                                _6229 = (_global_7[min((uint)(((int)(1u + (_6214 * 2)))), 127u)]) * _6219;
                                _6235 = _HeapResource_39.GatherRed(samplerPointClampNode, float2((dot(float2(_6228, _6229), float2(_6055, _6054)) + _6038), (dot(float2(_6228, _6229), float2(_6073, _6055)) + _6039)));
                                _6240 = _6235.x - _6040;
                                _6242 = select((_6240 < 0.0f), 0.0f, 1.0f);
                                _6246 = _6235.y - _6040;
                                _6248 = select((_6246 < 0.0f), 0.0f, 1.0f);
                                _6252 = _6235.z - _6040;
                                _6254 = select((_6252 < 0.0f), 0.0f, 1.0f);
                                _6258 = _6235.w - _6040;
                                _6260 = select((_6258 < 0.0f), 0.0f, 1.0f);
                                _6261 = ((((((((((((((_6085 + _6089) + _6095) + _6101) + _6136) + _6142) + _6148) + _6154) + _6189) + _6195) + _6201) + _6207) + _6242) + _6248) + _6254) + _6260;
                                _6272 = (saturate(_6261 * 0.0625f) * 2.0f) + -1.0f;
                                _6278 = float((int)(((int)(uint)((int)(_6272 > 0.0f))) - ((int)(uint)((int)(_6272 < 0.0f)))));
                                _6280 = 1.0f - (_6278 * _6272);
                                _6282 = (_6280 * _6280) * _6280;
                                _6290 = -0.0f - _4720;
                                _6297 = saturate((saturate(rsqrt(dot(float3(_6290, _4712, _4709), float3(_6290, _4712, _4709))) * _4709) * _4607) + _4606);
                                _6299 = 1.0f - (_6297 * _6297);
                                _6303 = false;
                                _6304 = (0.5f - ((_6278 * 0.5f) * ((1.0f - _6282) - ((_6280 - _6282) * saturate(((1.0f / _6040) * (1.0f / _6261)) * ((((((((((((((((_6085 * _6083) + (_6089 * _6087)) + (_6095 * _6093)) + (_6101 * _6099)) + (_6136 * _6134)) + (_6142 * _6140)) + (_6148 * _6146)) + (_6154 * _6152)) + (_6189 * _6187)) + (_6195 * _6193)) + (_6201 * _6199)) + (_6207 * _6205)) + (_6242 * _6240)) + (_6248 * _6246)) + (_6254 * _6252)) + (_6260 * _6258)))))));
                                _6305 = (1.0f - (_6299 * _6299));
                              } else {
                                _6303 = true;
                                _6304 = 1.0f;
                                _6305 = 1.0f;
                              }
                            } else {
                              _6303 = true;
                              _6304 = 1.0f;
                              _6305 = 1.0f;
                            }
                          }
                        } else {
                          _6303 = true;
                          _6304 = 1.0f;
                          _6305 = 1.0f;
                        }
                        if (_5511 == 0) {
                          if (!_6303) {
                            _6320 = 0.0f;
                            _6321 = _5512;
                            _6322 = ((_6305 * (_6304 + -1.0f)) + 1.0f);
                          } else {
                            _6320 = 0.0f;
                            _6321 = _5512;
                            _6322 = _6304;
                          }
                        } else {
                          if (_6303) {
                            _6320 = 1.0f;
                            _6321 = ((_5513 * (_5512 + -1.0f)) + 1.0f);
                            _6322 = _6304;
                          } else {
                            _6320 = (_5513 * f16tof32(_4555));
                            _6321 = _5512;
                            _6322 = _6304;
                          }
                        }
                        _6325 = ((_6321 - _6322) * _6320) + _6322;
                        [branch]
                        if (!((_2251 & 2048) == 0)) {
                          _6327 = _244 - _4527;
                          _6328 = _245 - _4528;
                          _6329 = _246 - _4529;
                          _6344 = mad((_cbSharedPerViewData_raw[12u].z), _6329, mad((_cbSharedPerViewData_raw[12u].y), _6328, ((_cbSharedPerViewData_raw[12u].x) * _6327)));
                          _6347 = mad((_cbSharedPerViewData_raw[13u].z), _6329, mad((_cbSharedPerViewData_raw[13u].y), _6328, ((_cbSharedPerViewData_raw[13u].x) * _6327)));
                          _6350 = mad((_cbSharedPerViewData_raw[14u].z), _6329, mad((_cbSharedPerViewData_raw[14u].y), _6328, ((_cbSharedPerViewData_raw[14u].x) * _6327)));
                          _6352 = rsqrt(dot(float3(_6344, _6347, _6350), float3(_6344, _6347, _6350)));
                          _6353 = _6352 * _6344;
                          _6354 = _6352 * _6347;
                          _6355 = _6352 * _6350;
                          Texture2D<float> _HeapResource_40 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_4561) >> 16))];
                          _6363 = (abs(_6354) + abs(_6353)) + abs(_6355);
                          _6364 = _6353 / _6363;
                          _6365 = _6354 / _6363;
                          _6367 = !((_6355 / _6363) >= 0.0f);
                          if (_6367) {
                            _6380 = ((1.0f - abs(_6365)) * select((_6364 >= 0.0f), 1.0f, -1.0f));
                            _6381 = ((1.0f - abs(_6364)) * select((_6365 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _6380 = _6364;
                            _6381 = _6365;
                          }
                          _6387 = _HeapResource_40.SampleLevel(samplerLinearClampNode, float2(((_6380 * 0.5f) + 0.5f), ((_6381 * 0.5f) + 0.5f)), 0.0f);
                          if (_6387.x > 0.0f) {
                            Texture2D<float4> _HeapResource_41 = ResourceDescriptorHeap[NonUniformResourceIndex((_4561 & 65535))];
                            if (_6367) {
                              _6406 = ((1.0f - abs(_6365)) * select((_6364 >= 0.0f), 1.0f, -1.0f));
                              _6407 = ((1.0f - abs(_6364)) * select((_6365 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _6406 = _6364;
                              _6407 = _6365;
                            }
                            _6412 = _HeapResource_41.SampleLevel(samplerLinearClampNode, float2(((_6406 * 0.5f) + 0.5f), ((_6407 * 0.5f) + 0.5f)), 0.0f);
                            _6432 = mad(saturate(((log2(sqrt(((_6327 * _6327) + (_6328 * _6328)) + (_6329 * _6329))) * 0.6931471824645996f) - (_cbSharedPerViewData_raw[147u].w)) * (_cbSharedPerViewData_raw[148u].x)), 2.0f, -1.0f);
                            _6433 = max(9.999999747378752e-06f, _6387.x);
                            _6434 = _6412.x / _6433;
                            _6435 = _6412.y / _6433;
                            _6437 = _6412.w / _6433;
                            _6442 = ((0.375f - _6435) * 4.999999873689376e-06f) + _6435;
                            _6445 = -0.0f - _6434;
                            _6446 = mad(_6445, _6442, (_6412.z / _6433));
                            _6448 = 1.0f / mad(_6445, _6434, _6442);
                            _6449 = _6448 * _6446;
                            _6454 = _6432 - _6434;
                            _6459 = (((_6432 * _6432) - _6442) - (_6449 * _6454)) / mad((-0.0f - _6446), _6449, mad((-0.0f - _6442), _6442, (((0.375f - _6437) * 4.999999873689376e-06f) + _6437)));
                            _6461 = (_6448 * _6454) - (_6459 * _6449);
                            _6464 = 1.0f / _6459;
                            _6465 = _6461 * _6464;
                            _6470 = sqrt(((_6465 * _6465) * 0.25f) - ((1.0f - dot(float2(_6461, _6459), float2(_6434, _6442))) * _6464));
                            _6472 = (_6465 * -0.5f) - _6470;
                            _6474 = _6470 - (_6465 * 0.5f);
                            _6476 = select((_6472 < _6432), 1.0f, 0.0f);
                            _6481 = (_6476 + -0.05000000074505806f) / (_6472 - _6432);
                            _6487 = (((select((_6474 < _6432), 1.0f, 0.0f) - _6476) / (_6474 - _6472)) - _6481) / (_6474 - _6432);
                            _6489 = _6481 - (_6487 * _6472);
                            _6502 = (exp2((_6387.x * -1.4426950216293335f) * saturate((dot(float2(_6434, _6442), float2((_6489 - (_6487 * _6432)), _6487)) + 0.05000000074505806f) - (_6489 * _6432))) * _6325);
                          } else {
                            _6502 = _6325;
                          }
                        } else {
                          _6502 = _6325;
                        }
                        _6505 = (_6502 * _4683);
                        _6506 = _6502;
                      } else {
                        _6505 = _4683;
                        _6506 = 1.0f;
                      }
                      [branch]
                      if (!(_4612 == 0)) {
                        TextureCube<float3> _HeapResource_42 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _4612)))];
                        _6518 = _HeapResource_42.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_4662, _4522, mad(_4661, _4517, (_4660 * _4512)))), (-0.0f - mad(_4662, _4523, mad(_4661, _4518, (_4660 * _4513)))), (-0.0f - mad(_4662, _4524, mad(_4661, _4519, (_4660 * _4514))))), 0.0f);
                        _6526 = (_6518.x * _4587);
                        _6527 = (_6518.y * _4588);
                        _6528 = (_6518.z * _4590);
                      } else {
                        _6526 = _4587;
                        _6527 = _4588;
                        _6528 = _4590;
                      }
                      [branch]
                      if (!(_6505 == 0.0f)) {
                        bool __branch_chain_6530;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _6546 = 0;
                          __branch_chain_6530 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _6546 = 1;
                            __branch_chain_6530 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _6546 = 2;
                              __branch_chain_6530 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _6546 = 3;
                                __branch_chain_6530 = true;
                              } else {
                                _6567 = _6505;
                                __branch_chain_6530 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_6530) {
                          while(true) {
                            _6549 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_80, _81, 0));
                            if (_6546 == 0) {
                              _6563 = _6549.x;
                            } else {
                              if (_6546 == 1) {
                                _6563 = _6549.y;
                              } else {
                                if (_6546 == 2) {
                                  _6563 = _6549.z;
                                } else {
                                  _6563 = _6549.w;
                                }
                              }
                            }
                            _6567 = ((_6563 * _6563) * _4683);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_6567 == 0.0f)) {
                            [branch]
                            if (!(((_4564 & 1) == 0) || (!_4714))) {
                              _6584 = max(max(_6526, _6527), _6528);
                              if (_6584 > 0.0f) {
                                _6594 = saturate(_6526 / _6584);
                                _6595 = saturate(_6527 / _6584);
                                _6596 = saturate(_6528 / _6584);
                              } else {
                                _6594 = _6526;
                                _6595 = _6527;
                                _6596 = _6528;
                              }
                              _6597 = (_6595 < _6596);
                              _6598 = select(_6597, _6596, _6595);
                              _6599 = select(_6597, _6595, _6596);
                              _6600 = select(_6597, -1.0f, 0.0f);
                              _6601 = (_6594 < _6598);
                              _6603 = select(_6601, _6598, _6594);
                              _6604 = select(_6601, _6594, _6598);
                              _6608 = _6603 - select((_6604 < _6599), _6604, _6599);
                              _6614 = abs(select(_6601, (-0.3333333432674408f - _6600), _6600) + ((_6604 - _6599) / ((_6608 * 6.0f) + 9.999999682655225e-21f)));
                              if (_6614 < 0.6666666865348816f) {
                                _6627 = ((saturate(((float)((uint)((uint)(((uint)(_4564) >> 9) & 255)))) * 0.003921499941498041f) * (select((_6614 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _6614)) + _6614);
                              } else {
                                _6627 = _6614;
                              }
                              _6628 = saturate((_6608 / (_6603 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_4564) >> 1) & 255)))) * 0.003921499941498041f));
                              _6629 = saturate(_6603);
                              if (!(_6628 <= 0.0f)) {
                                _6632 = saturate(_6627);
                                _6636 = select(((_6632 * 360.0f) >= 360.0f), 0.0f, (_6632 * 6.0f));
                                _6637 = int(_6636);
                                _6639 = _6636 - float((int)(_6637));
                                _6641 = _6629 * (1.0f - _6628);
                                _6644 = (1.0f - (_6639 * _6628)) * _6629;
                                _6648 = (1.0f - ((1.0f - _6639) * _6628)) * _6629;
                                switch (_6637) {
                                  case 0: {
                                    _6656 = _6629;
                                    _6657 = _6648;
                                    _6658 = _6641;
                                    break;
                                  }
                                  case 1: {
                                    _6656 = _6644;
                                    _6657 = _6629;
                                    _6658 = _6641;
                                    break;
                                  }
                                  case 2: {
                                    _6656 = _6641;
                                    _6657 = _6629;
                                    _6658 = _6648;
                                    break;
                                  }
                                  case 3: {
                                    _6656 = _6641;
                                    _6657 = _6644;
                                    _6658 = _6629;
                                    break;
                                  }
                                  case 4: {
                                    _6656 = _6648;
                                    _6657 = _6641;
                                    _6658 = _6629;
                                    break;
                                  }
                                  case 5: {
                                    _6656 = _6629;
                                    _6657 = _6641;
                                    _6658 = _6644;
                                    break;
                                  }
                                  default: {
                                    _6656 = 0.0f;
                                    _6657 = 0.0f;
                                    _6658 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _6656 = _6629;
                                _6657 = _6629;
                                _6658 = _6629;
                              }
                              _6659 = _6656 * _6584;
                              _6660 = _6657 * _6584;
                              _6661 = _6658 * _6584;
                              _6663 = saturate(_6506 * 1.0101009607315063f);
                              _6674 = ((_6663 * (_6526 - _6659)) + _6659);
                              _6675 = ((_6663 * (_6527 - _6660)) + _6660);
                              _6676 = (lerp(_6661, _6528, _6663));
                            } else {
                              _6674 = _6526;
                              _6675 = _6527;
                              _6676 = _6528;
                            }
                            [branch]
                            if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                              _6683 = srvLightMappingData[_2254];
                              if (!(_6683 == -1)) {
                                _6688 = srvLightIndexData[_6683].nLayerIndex;
                                _6690 = srvLightIndexData[_6683].vAtlasOrigin.x;
                                _6691 = srvLightIndexData[_6683].vAtlasOrigin.y;
                                _6693 = srvLightIndexData[_6683].vScreenOrigin.x;
                                _6694 = srvLightIndexData[_6683].vScreenOrigin.y;
                                _6703 = ((int)(_6688 * 5)) & 31;
                                _6712 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6690 + _80) - _6693)), ((int)((_6691 + _81) - _6694)), 0)))).x) & ((int)(31 << _6703)))) >> _6703)) >> 1)))) * 0.06666667014360428f) * _6567);
                              } else {
                                _6712 = _6567;
                              }
                            } else {
                              _6712 = _6567;
                            }
                            _6716 = ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0);
                            _6719 = select(_6716, (_6712 * _1983), _6712);
                            _6721 = _4666 * _4665;
                            _6722 = _4667 * _4665;
                            _6723 = _4668 * _4665;
                            _6724 = _4598 * _4532;
                            _6725 = _4598 * _4533;
                            _6726 = _4598 * _4534;
                            _6727 = _6721 + _6724;
                            _6728 = _6722 + _6725;
                            _6729 = _6723 + _6726;
                            _6730 = _6721 - _6724;
                            _6731 = _6722 - _6725;
                            _6732 = _6723 - _6726;
                            _6733 = (_4598 > 0.0f);
                            _6734 = dot(float3(_6727, _6728, _6729), float3(_6727, _6728, _6729));
                            _6735 = rsqrt(_6734);
                            [branch]
                            if (_6733) {
                              _6738 = rsqrt(dot(float3(_6730, _6731, _6732), float3(_6730, _6731, _6732)));
                              _6739 = _6738 * _6735;
                              _6741 = dot(float3(_6727, _6728, _6729), float3(_6730, _6731, _6732)) * _6739;
                              _6760 = (_6739 / ((_6739 + 0.5f) + (_6741 * 0.5f)));
                              _6761 = (((dot(float3(_205, _207, _209), float3(_6730, _6731, _6732)) * _6738) + (dot(float3(_205, _207, _209), float3(_6727, _6728, _6729)) * _6735)) * 0.5f);
                              _6762 = _6741;
                            } else {
                              _6760 = (1.0f / (_6734 + 1.0f));
                              _6761 = dot(float3(_205, _207, _209), float3((_6735 * _6727), (_6735 * _6728), (_6735 * _6729)));
                              _6762 = 1.0f;
                            }
                            if (_4600 > 0.0f) {
                              _6768 = sqrt(saturate((_4600 * _4600) * _6760));
                              if (_6761 < _6768) {
                                _6773 = max(_6761, (-0.0f - _6768)) + _6768;
                                _6778 = ((_6773 * _6773) / (_6768 * 4.0f));
                              } else {
                                _6778 = _6761;
                              }
                            } else {
                              _6778 = _6761;
                            }
                            if (_6733) {
                              _6780 = -0.0f - _257;
                              _6781 = -0.0f - _258;
                              _6782 = -0.0f - _256;
                              _6784 = dot(float3(_6780, _6781, _6782), float3(_205, _207, _209)) * 2.0f;
                              _6788 = _6780 - (_6784 * _205);
                              _6789 = _6781 - (_6784 * _207);
                              _6790 = _6782 - (_6784 * _209);
                              _6791 = _6730 - _6727;
                              _6792 = _6731 - _6728;
                              _6793 = _6732 - _6729;
                              _6794 = dot(float3(_6788, _6789, _6790), float3(_6791, _6792, _6793));
                              _6800 = sqrt(((_6791 * _6791) + (_6792 * _6792)) + (_6793 * _6793));
                              _6809 = saturate(((dot(float3(_6788, _6789, _6790), float3(_6727, _6728, _6729)) * _6794) - dot(float3(_6727, _6728, _6729), float3(_6791, _6792, _6793))) / ((_6800 * _6800) - (_6794 * _6794)));
                              _6813 = (_6809 * _6791) + _6727;
                              _6814 = (_6809 * _6792) + _6728;
                              _6815 = (_6809 * _6793) + _6729;
                              _6816 = dot(float3(_6813, _6814, _6815), float3(_6788, _6789, _6790));
                              _6820 = (_6816 * _6788) - _6813;
                              _6821 = (_6816 * _6789) - _6814;
                              _6822 = (_6816 * _6790) - _6815;
                              _6830 = saturate(0.009999999776482582f / sqrt(((_6820 * _6820) + (_6821 * _6821)) + (_6822 * _6822)));
                              _6838 = ((_6830 * _6820) + _6813);
                              _6839 = ((_6830 * _6821) + _6814);
                              _6840 = ((_6830 * _6822) + _6815);
                            } else {
                              _6838 = _6727;
                              _6839 = _6728;
                              _6840 = _6729;
                            }
                            _6842 = rsqrt(dot(float3(_6838, _6839, _6840), float3(_6838, _6839, _6840)));
                            _6843 = _6842 * _6838;
                            _6844 = _6842 * _6839;
                            _6845 = _6842 * _6840;
                            _6846 = _233 * _233;
                            _6847 = 1.0f - _6846;
                            _6850 = saturate((_4600 * _6847) * _6842);
                            _6852 = saturate(_6842 * f16tof32(_4546));
                            _6854 = rsqrt(dot(float3(_6721, _6722, _6723), float3(_6721, _6722, _6723)));
                            _6858 = dot(float3(_205, _207, _209), float3(_6843, _6844, _6845));
                            _6859 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                            _6860 = dot(float3(_257, _258, _256), float3(_6843, _6844, _6845));
                            _6863 = rsqrt((_6860 * 2.0f) + 2.0f);
                            _6866 = saturate(_6863 * (_6859 + _6858));
                            _6869 = saturate((_6863 * _6860) + _6863);
                            _6870 = (_6850 > 0.0f);
                            if (_6870) {
                              _6874 = sqrt(1.0f - (_6850 * _6850));
                              _6876 = (_6858 * 2.0f) * _6859;
                              _6877 = _6876 - _6860;
                              if (!(_6877 >= _6874)) {
                                _6885 = rsqrt(1.0f - (_6877 * _6877)) * _6850;
                                _6888 = _6885 * (_6859 - (_6877 * _6858));
                                _6889 = _6859 * _6859;
                                _6894 = _6885 * (((_6889 * 2.0f) + -1.0f) - (_6877 * _6860));
                                _6903 = sqrt(saturate((((1.0f - (_6858 * _6858)) - _6889) - (_6860 * _6860)) + (_6876 * _6860)));
                                _6904 = _6903 * _6885;
                                _6907 = ((_6859 * 2.0f) * _6885) * _6903;
                                _6909 = (_6874 * _6858) + _6859;
                                _6910 = _6909 + _6888;
                                _6911 = _6874 * _6860;
                                _6913 = (_6911 + 1.0f) + _6894;
                                _6914 = _6904 * _6913;
                                _6915 = _6910 * _6913;
                                _6916 = _6907 * _6910;
                                _6921 = (((_6910 * 0.25f) * _6907) - (_6914 * 0.5f)) * _6915;
                                _6935 = (((_6916 - (_6914 * 2.0f)) * _6916) + (_6914 * _6914)) + ((((-0.5f - ((_6913 + _6911) * 0.5f)) * _6915) + ((_6913 * _6913) * _6909)) * _6910);
                                _6940 = (_6921 * 2.0f) / ((_6935 * _6935) + (_6921 * _6921));
                                _6941 = _6935 * _6940;
                                _6943 = 1.0f - (_6921 * _6940);
                                _6949 = ((_6941 * _6907) + _6911) + (_6943 * _6894);
                                _6952 = rsqrt((_6949 * 2.0f) + 2.0f);
                                _6961 = saturate((_6949 * _6952) + _6952);
                                _6962 = saturate(((_6909 + (_6941 * _6904)) + (_6943 * _6888)) * _6952);
                              } else {
                                _6961 = abs(_6859);
                                _6962 = 1.0f;
                              }
                            } else {
                              _6961 = _6869;
                              _6962 = _6866;
                            }
                            _6963 = saturate(_6778);
                            _6965 = _6846 * _6846;
                            _6966 = (_6852 > 0.0f);
                            if (_6966) {
                              _6975 = saturate(((_6852 * _6852) / ((_6961 * 3.5999999046325684f) + 0.4000000059604645f)) + _6965);
                            } else {
                              _6975 = _6965;
                            }
                            if (_6870) {
                              _6984 = (((_6850 * 0.25f) * ((sqrt(_6975) * 3.0f) + _6850)) / (_6961 + 0.0010000000474974513f)) + _6975;
                              _6987 = _6984;
                              _6988 = (_6975 / _6984);
                            } else {
                              _6987 = _6975;
                              _6988 = 1.0f;
                            }
                            _6989 = (_6762 < 1.0f);
                            if (_6989) {
                              _6995 = sqrt((1.000100016593933f - _6762) / max(9.999999974752427e-07f, (_6762 + 1.0f)));
                              _7008 = (sqrt(_6987 / ((((_6995 * 0.25f) * ((sqrt(_6987) * 3.0f) + _6995)) / (_6961 + 0.0010000000474974513f)) + _6987)) * _6988);
                            } else {
                              _7008 = _6988;
                            }
                            _7012 = (((_6975 * _6962) - _6962) * _6962) + 1.0f;
                            _7022 = exp2(log2(1.0f - saturate(_6961)) * 5.0f);
                            _7029 = abs(_6859);
                            _7031 = saturate(_7029 + 9.999999747378752e-06f);
                            _7032 = sqrt(_6975);
                            _7033 = 1.0f - _7032;
                            _7042 = _231 * _231;
                            _7043 = _7042 * _7042;
                            _7049 = saturate(select((_6847 > 0.0f), ((1.0f - _7042) / _6847), 0.0f) * _6850);
                            _7050 = (_7049 > 0.0f);
                            if (_7050) {
                              _7054 = sqrt(1.0f - (_7049 * _7049));
                              _7056 = (_6858 * 2.0f) * _6859;
                              _7057 = _7056 - _6860;
                              if (!(_7057 >= _7054)) {
                                _7063 = rsqrt(1.0f - (_7057 * _7057)) * _7049;
                                _7066 = _7063 * (_6859 - (_7057 * _6858));
                                _7067 = _6859 * _6859;
                                _7072 = _7063 * (((_7067 * 2.0f) + -1.0f) - (_7057 * _6860));
                                _7081 = sqrt(saturate((((1.0f - (_6858 * _6858)) - _7067) - (_6860 * _6860)) + (_7056 * _6860)));
                                _7082 = _7081 * _7063;
                                _7085 = ((_6859 * 2.0f) * _7063) * _7081;
                                _7087 = (_7054 * _6858) + _6859;
                                _7088 = _7087 + _7066;
                                _7089 = _7054 * _6860;
                                _7091 = (_7089 + 1.0f) + _7072;
                                _7092 = _7082 * _7091;
                                _7093 = _7088 * _7091;
                                _7094 = _7085 * _7088;
                                _7099 = (((_7088 * 0.25f) * _7085) - (_7092 * 0.5f)) * _7093;
                                _7113 = (((_7094 - (_7092 * 2.0f)) * _7094) + (_7092 * _7092)) + ((((-0.5f - ((_7091 + _7089) * 0.5f)) * _7093) + ((_7091 * _7091) * _7087)) * _7088);
                                _7118 = (_7099 * 2.0f) / ((_7113 * _7113) + (_7099 * _7099));
                                _7119 = _7113 * _7118;
                                _7121 = 1.0f - (_7099 * _7118);
                                _7127 = ((_7119 * _7085) + _7089) + (_7121 * _7072);
                                _7130 = rsqrt((_7127 * 2.0f) + 2.0f);
                                _7139 = saturate((_7127 * _7130) + _7130);
                                _7140 = saturate(((_7087 + (_7119 * _7082)) + (_7121 * _7066)) * _7130);
                              } else {
                                _7139 = _7029;
                                _7140 = 1.0f;
                              }
                            } else {
                              _7139 = _6869;
                              _7140 = _6866;
                            }
                            if (_6966) {
                              _7149 = saturate(((_6852 * _6852) / ((_7139 * 3.5999999046325684f) + 0.4000000059604645f)) + _7043);
                            } else {
                              _7149 = _7043;
                            }
                            if (_7050) {
                              _7158 = (((_7049 * 0.25f) * ((sqrt(_7149) * 3.0f) + _7049)) / (_7139 + 0.0010000000474974513f)) + _7149;
                              _7161 = _7158;
                              _7162 = (_7149 / _7158);
                            } else {
                              _7161 = _7149;
                              _7162 = 1.0f;
                            }
                            if (_6989) {
                              _7168 = sqrt((1.000100016593933f - _6762) / max(9.999999974752427e-07f, (_6762 + 1.0f)));
                              _7181 = (sqrt(_7161 / ((((_7168 * 0.25f) * ((sqrt(_7161) * 3.0f) + _7168)) / (_7139 + 0.0010000000474974513f)) + _7161)) * _7162);
                            } else {
                              _7181 = _7162;
                            }
                            _7185 = (((_7149 * _7140) - _7140) * _7140) + 1.0f;
                            _7186 = sqrt(_7149);
                            _7187 = 1.0f - _7186;
                            _7191 = saturate((dot(float3(_205, _207, _209), float3((_6854 * _6721), (_6854 * _6722), (_6854 * _6723))) + _4597) / (_4597 + 1.0f));
                            _7194 = ((_7008 * _6963) * (_6975 / (_7012 * _7012))) * (0.5f / ((((_7033 * _7031) + _7032) * _6963) + (((_7033 * _6963) + _7032) * _7031)));
                            _7195 = _6674 * _2301;
                            _7196 = _6675 * _2301;
                            _7197 = _6676 * _2301;
                            _7204 = ((_6719 * _7195) * _7191) + _2239;
                            _7205 = ((_6719 * _7196) * _7191) + _2240;
                            _7206 = ((_6719 * _7197) * _7191) + _2241;
                            if (_4594 > 0.0f) {
                              _7231 = (((exp2(log2(1.0f - saturate(_7139)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_7181 * _6963) * (_7149 / (_7185 * _7185))) * (0.5f / ((((_7187 * _7031) + _7186) * _6963) + (((_7187 * _6963) + _7186) * _7031))));
                              _7238 = (_4594 * _1998) * select(_6716, (_6712 * _1983), _6712);
                              _9759 = _7204;
                              _9760 = _7205;
                              _9761 = _7206;
                              _9762 = (((_7238 * _7195) * (_7231 + (_7194 * ((_7022 * (1.0f - _227)) + _227)))) + _2242);
                              _9763 = (((_7238 * _7196) * (_7231 + (_7194 * ((_7022 * (1.0f - _228)) + _228)))) + _2243);
                              _9764 = (((_7238 * _7197) * (_7231 + (_7194 * ((_7022 * (1.0f - _229)) + _229)))) + _2244);
                            } else {
                              _9759 = _7204;
                              _9760 = _7205;
                              _9761 = _7206;
                              _9762 = _2242;
                              _9763 = _2243;
                              _9764 = _2244;
                            }
                          } else {
                            _9759 = _2239;
                            _9760 = _2240;
                            _9761 = _2241;
                            _9762 = _2242;
                            _9763 = _2243;
                            _9764 = _2244;
                          }
                          break;
                        }
                      } else {
                        _9759 = _2239;
                        _9760 = _2240;
                        _9761 = _2241;
                        _9762 = _2242;
                        _9763 = _2243;
                        _9764 = _2244;
                      }
                    } else {
                      if (_2284 == 8) {
                        _7253 = asfloat(srvLightInfoProperties.Load3(_2253)).x;
                        _7254 = asfloat(srvLightInfoProperties.Load3(_2253)).y;
                        _7255 = asfloat(srvLightInfoProperties.Load3(_2253)).z;
                        _7258 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 12u)))).x;
                        _7259 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 12u)))).y;
                        _7260 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 12u)))).z;
                        _7263 = asfloat(srvLightInfoProperties.Load(((int)(_2253 + 24u))));
                        _7266 = asint(srvLightInfoProperties.Load(((int)(_2253 + 28u))));
                        _7269 = asint(srvLightInfoProperties.Load(((int)(_2253 + 32u))));
                        _7272 = asint(srvLightInfoProperties.Load(((int)(_2253 + 44u))));
                        _7281 = ((float)((uint)((uint)(((uint)(_7269) >> 8) & 255)))) * 0.003921499941498041f;
                        _7284 = ((float)((uint)((uint)(_7269 & 255)))) * 0.003921499941498041f;
                        _7287 = f16tof32(_7272);
                        _7294 = min(max(dot(float3((_244 - _7253), (_245 - _7254), (_246 - _7255)), float3(_7258, _7259, _7260)), (-0.0f - _7263)), _7263);
                        _7299 = (_7253 - _244) + (_7294 * _7258);
                        _7301 = (_7254 - _245) + (_7294 * _7259);
                        _7303 = (_7255 + _243) + (_7294 * _7260);
                        _7304 = dot(float3(_7299, _7301, _7303), float3(_7299, _7301, _7303));
                        _7305 = rsqrt(_7304);
                        _7307 = _7299 * _7305;
                        _7308 = _7301 * _7305;
                        _7309 = _7303 * _7305;
                        _7312 = max(0.0f, ((_7305 * _7304) - abs(_7287)));
                        _7313 = _7312 * f16tof32(((uint)((uint)(_7272) >> 16)));
                        _7314 = _7313 * _7313;
                        _7317 = saturate(1.0f - (_7314 * _7314));
                        _7324 = (_7317 * _7317) / (select((_7287 < 0.0f), (_7314 * 16.0f), (_7312 * _7312)) + 1.0f);
                        [branch]
                        if (!(_7324 == 0.0f)) {
                          [branch]
                          if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                            _7333 = srvLightMappingData[_2254];
                            if (!(_7333 == -1)) {
                              _7338 = srvLightIndexData[_7333].nLayerIndex;
                              _7340 = srvLightIndexData[_7333].vAtlasOrigin.x;
                              _7341 = srvLightIndexData[_7333].vAtlasOrigin.y;
                              _7343 = srvLightIndexData[_7333].vScreenOrigin.x;
                              _7344 = srvLightIndexData[_7333].vScreenOrigin.y;
                              _7353 = ((int)(_7338 * 5)) & 31;
                              _7362 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7340 + _80) - _7343)), ((int)((_7341 + _81) - _7344)), 0)))).x) & ((int)(31 << _7353)))) >> _7353)) >> 1)))) * 0.06666667014360428f) * _7324);
                            } else {
                              _7362 = _7324;
                            }
                          } else {
                            _7362 = _7324;
                          }
                          _7366 = ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0);
                          _7368 = select(_7366, (_7362 * _1983), _7362);
                          _7369 = dot(float3(_205, _207, _209), float3(_7307, _7308, _7309));
                          _7370 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                          _7371 = dot(float3(_257, _258, _256), float3(_7307, _7308, _7309));
                          _7374 = rsqrt((_7371 * 2.0f) + 2.0f);
                          _7377 = saturate(_7374 * (_7370 + _7369));
                          _7381 = saturate(_7369);
                          _7382 = _233 * _233;
                          _7383 = _7382 * _7382;
                          _7387 = (((_7377 * _7383) - _7377) * _7377) + 1.0f;
                          _7394 = exp2(log2(1.0f - saturate(saturate((_7374 * _7371) + _7374))) * 5.0f);
                          _7397 = saturate(abs(_7370) + 9.999999747378752e-06f);
                          _7398 = sqrt(_7383);
                          _7399 = 1.0f - _7398;
                          _7408 = _231 * _231;
                          _7409 = _7408 * _7408;
                          _7413 = (((_7377 * _7409) - _7377) * _7377) + 1.0f;
                          _7414 = sqrt(_7409);
                          _7415 = 1.0f - _7414;
                          _7419 = saturate((_7369 + _7284) / (_7284 + 1.0f));
                          _7421 = ((_7383 / (_7387 * _7387)) * _7381) * (0.5f / ((((_7399 * _7397) + _7398) * _7381) + (((_7399 * _7381) + _7398) * _7397)));
                          _7422 = f16tof32(((uint)((uint)(_7266) >> 16))) * _2301;
                          _7423 = f16tof32(_7266) * _2301;
                          _7424 = f16tof32(((uint)((uint)(_7269) >> 16))) * _2301;
                          _7431 = ((_7368 * _7422) * _7419) + _2239;
                          _7432 = ((_7368 * _7423) * _7419) + _2240;
                          _7433 = ((_7368 * _7424) * _7419) + _2241;
                          if (_7281 > 0.0f) {
                            _7455 = (((_7394 * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_7409 / (_7413 * _7413)) * _7381) * (0.5f / ((((_7415 * _7397) + _7414) * _7381) + (((_7415 * _7381) + _7414) * _7397))));
                            _7470 = (_7281 * _1998) * select(_7366, (_7362 * _1983), _7362);
                            _9759 = _7431;
                            _9760 = _7432;
                            _9761 = _7433;
                            _9762 = (((_7470 * _7422) * (_7455 + (_7421 * ((_7394 * (1.0f - _227)) + _227)))) + _2242);
                            _9763 = (((_7470 * _7423) * (_7455 + (_7421 * ((_7394 * (1.0f - _228)) + _228)))) + _2243);
                            _9764 = (((_7470 * _7424) * (_7455 + (_7421 * ((_7394 * (1.0f - _229)) + _229)))) + _2244);
                          } else {
                            _9759 = _7431;
                            _9760 = _7432;
                            _9761 = _7433;
                            _9762 = _2242;
                            _9763 = _2243;
                            _9764 = _2244;
                          }
                        } else {
                          _9759 = _2239;
                          _9760 = _2240;
                          _9761 = _2241;
                          _9762 = _2242;
                          _9763 = _2243;
                          _9764 = _2244;
                        }
                      } else {
                        if (_2284 == 9) {
                          _7485 = asfloat(srvLightInfoProperties.Load4(_2253)).x;
                          _7486 = asfloat(srvLightInfoProperties.Load4(_2253)).y;
                          _7487 = asfloat(srvLightInfoProperties.Load4(_2253)).w;
                          _7490 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).x;
                          _7491 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).y;
                          _7492 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).w;
                          _7495 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).x;
                          _7496 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).y;
                          _7497 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).w;
                          _7500 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 48u)))).x;
                          _7501 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 48u)))).y;
                          _7502 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 48u)))).w;
                          _7505 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 64u)))).x;
                          _7506 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 64u)))).y;
                          _7507 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 64u)))).z;
                          _7510 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 76u)))).x;
                          _7511 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 76u)))).y;
                          _7512 = asfloat(srvLightInfoProperties.Load3(((int)(_2253 + 76u)))).z;
                          _7515 = asint(srvLightInfoProperties.Load(((int)(_2253 + 88u))));
                          _7518 = asint(srvLightInfoProperties.Load(((int)(_2253 + 92u))));
                          _7521 = asint(srvLightInfoProperties.Load(((int)(_2253 + 100u))));
                          _7524 = asint(srvLightInfoProperties.Load(((int)(_2253 + 104u))));
                          _7527 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).x;
                          _7528 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).y;
                          _7529 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).z;
                          _7530 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 108u)))).w;
                          _7533 = asint(srvLightInfoProperties.Load(((int)(_2253 + 124u))));
                          _7536 = asint(srvLightInfoProperties.Load(((int)(_2253 + 128u))));
                          _7539 = asint(srvLightInfoProperties.Load(((int)(_2253 + 132u))));
                          _7542 = asint(srvLightInfoProperties.Load(((int)(_2253 + 136u))));
                          _7545 = asint(srvLightInfoProperties.Load(((int)(_2253 + 140u))));
                          _7548 = asint(srvLightInfoProperties.Load(((int)(_2253 + 144u))));
                          _7551 = asint(srvLightInfoProperties.Load(((int)(_2253 + 148u))));
                          _7554 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 152u)))).x;
                          _7555 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 152u)))).y;
                          _7556 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 152u)))).z;
                          _7557 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 152u)))).w;
                          _7560 = asint(srvLightInfoProperties.Load(((int)(_2253 + 168u))));
                          _7563 = asint(srvLightInfoProperties.Load(((int)(_2253 + 172u))));
                          _7566 = asint(srvLightInfoProperties.Load(((int)(_2253 + 180u))));
                          _7568 = f16tof32(((uint)((uint)(_7515) >> 16)));
                          _7569 = f16tof32(_7515);
                          _7571 = f16tof32(((uint)((uint)(_7518) >> 16)));
                          _7575 = ((float)((uint)((uint)(((uint)(_7518) >> 8) & 255)))) * 0.003921499941498041f;
                          _7578 = ((float)((uint)((uint)(_7518 & 255)))) * 0.003921499941498041f;
                          _7579 = f16tof32(_7521);
                          _7581 = f16tof32(((uint)((uint)(_7524) >> 16)));
                          _7585 = f16tof32(_7533);
                          _7589 = _7539 & 65535;
                          _7605 = f16tof32(((uint)((uint)(_7563) >> 16)));
                          _7606 = f16tof32(_7563);
                          _7608 = f16tof32(((uint)((uint)(_7566) >> 16)));
                          _7609 = 1.0f / _7608;
                          _7610 = _7608 + -1.0f;
                          _7611 = f16tof32(_7566);
                          _7612 = _7505 - _244;
                          _7613 = _7506 - _245;
                          _7614 = _7507 + _243;
                          _7615 = dot(float3(_7612, _7613, _7614), float3(_7612, _7613, _7614));
                          _7616 = rsqrt(_7615);
                          _7617 = _7616 * _7615;
                          _7618 = _7616 * _7612;
                          _7619 = _7616 * _7613;
                          _7620 = _7616 * _7614;
                          _7623 = max(0.0f, (_7617 - abs(_7585)));
                          _7624 = _7623 * f16tof32(((uint)((uint)(_7533) >> 16)));
                          _7625 = _7624 * _7624;
                          _7628 = saturate(1.0f - (_7625 * _7625));
                          _7639 = mad(_246, _7497, mad(_245, _7492, (_7487 * _244))) + _7502;
                          _7643 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_7618, _7619, _7620))) * f16tof32(_7560);
                          _7650 = ((_7639 * _205) * _7643) + _244;
                          _7651 = ((_7639 * _207) * _7643) + _245;
                          _7652 = ((_7639 * _209) * _7643) - _243;
                          _7664 = mad(_7652, _7497, mad(_7651, _7492, (_7650 * _7487))) + _7502;
                          _7665 = 1.0f / _7664;
                          _7666 = _7665 * (mad(_7652, _7495, mad(_7651, _7490, (_7650 * _7485))) + _7500);
                          _7667 = _7665 * (mad(_7652, _7496, mad(_7651, _7491, (_7650 * _7486))) + _7501);
                          _7670 = (_7666 * _7527) + _7528;
                          _7671 = (_7667 * _7527) + _7528;
                          _7674 = _7670 - saturate(_7670);
                          _7675 = _7671 - saturate(_7671);
                          _7682 = saturate((sqrt((_7674 * _7674) + (_7675 * _7675)) * _7529) + _7530);
                          _7684 = 1.0f - (_7682 * _7682);
                          _7690 = (_7684 * _7684) * (((float)((bool)(uint)((_7664 - f16tof32(((uint)((uint)(_7536) >> 16)))) > 0.0f))) * ((_7628 * _7628) / (select((_7585 < 0.0f), (_7625 * 16.0f), (_7623 * _7623)) + 1.0f)));
                          _7692 = ((_2251 & 3584) == 0);
                          if (!((!(_7690 > 0.0f)) || _7692)) {
                            _7700 = 1.0f - saturate(f16tof32(_7536) * _7664);
                            _7701 = saturate(_7666);
                            _7702 = saturate(_7667);
                            bool __branch_chain_7694;
                            [branch]
                            if ((_2251 & 1024) == 0) {
                              _7965 = 1.0f;
                              _7966 = 0.0f;
                              _7967 = _7700;
                              __branch_chain_7694 = true;
                            } else {
                              _7707 = ((_7701 * _7610) + 0.5f) * _7609;
                              _7709 = ((_7702 * _7610) + 0.5f) * _7609;
                              _7710 = _7700 + f16tof32(((uint)((uint)(_7560) >> 16)));
                              Texture2D<float4> _HeapResource_43 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7539) >> 16))];
                              _7713 = saturate(_7710);
                              _7717 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                              _7726 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 6u) : (frac(frac(dot(float2(((_7717 * 32.665000915527344f) + _142), ((_7717 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _7727 = sin(_7726);
                              _7728 = cos(_7726);
                              _7729 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                              _7734 = sqrt((float((int)(_7729)) * 0.25f) + 0.125f) * _7605;
                              _7743 = (_global_7[min((uint)(((int)(0u + (_7729 * 2)))), 127u)]) * _7734;
                              _7744 = (_global_7[min((uint)(((int)(1u + (_7729 * 2)))), 127u)]) * _7734;
                              _7746 = -0.0f - _7727;
                              _7751 = _HeapResource_43.GatherRed(samplerPointClampNode, float2((dot(float2(_7743, _7744), float2(_7728, _7727)) + _7707), (dot(float2(_7743, _7744), float2(_7746, _7728)) + _7709)));
                              _7756 = _7751.x - _7713;
                              _7758 = select((_7756 < 0.0f), 0.0f, 1.0f);
                              _7760 = _7751.y - _7713;
                              _7762 = select((_7760 < 0.0f), 0.0f, 1.0f);
                              _7766 = _7751.z - _7713;
                              _7768 = select((_7766 < 0.0f), 0.0f, 1.0f);
                              _7772 = _7751.w - _7713;
                              _7774 = select((_7772 < 0.0f), 0.0f, 1.0f);
                              _7781 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                              _7786 = sqrt((float((int)(_7781)) * 0.25f) + 0.125f) * _7605;
                              _7795 = (_global_7[min((uint)(((int)(0u + (_7781 * 2)))), 127u)]) * _7786;
                              _7796 = (_global_7[min((uint)(((int)(1u + (_7781 * 2)))), 127u)]) * _7786;
                              _7802 = _HeapResource_43.GatherRed(samplerPointClampNode, float2((dot(float2(_7795, _7796), float2(_7728, _7727)) + _7707), (dot(float2(_7795, _7796), float2(_7746, _7728)) + _7709)));
                              _7807 = _7802.x - _7713;
                              _7809 = select((_7807 < 0.0f), 0.0f, 1.0f);
                              _7813 = _7802.y - _7713;
                              _7815 = select((_7813 < 0.0f), 0.0f, 1.0f);
                              _7819 = _7802.z - _7713;
                              _7821 = select((_7819 < 0.0f), 0.0f, 1.0f);
                              _7825 = _7802.w - _7713;
                              _7827 = select((_7825 < 0.0f), 0.0f, 1.0f);
                              _7834 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                              _7839 = sqrt((float((int)(_7834)) * 0.25f) + 0.125f) * _7605;
                              _7848 = (_global_7[min((uint)(((int)(0u + (_7834 * 2)))), 127u)]) * _7839;
                              _7849 = (_global_7[min((uint)(((int)(1u + (_7834 * 2)))), 127u)]) * _7839;
                              _7855 = _HeapResource_43.GatherRed(samplerPointClampNode, float2((dot(float2(_7848, _7849), float2(_7728, _7727)) + _7707), (dot(float2(_7848, _7849), float2(_7746, _7728)) + _7709)));
                              _7860 = _7855.x - _7713;
                              _7862 = select((_7860 < 0.0f), 0.0f, 1.0f);
                              _7866 = _7855.y - _7713;
                              _7868 = select((_7866 < 0.0f), 0.0f, 1.0f);
                              _7872 = _7855.z - _7713;
                              _7874 = select((_7872 < 0.0f), 0.0f, 1.0f);
                              _7878 = _7855.w - _7713;
                              _7880 = select((_7878 < 0.0f), 0.0f, 1.0f);
                              _7887 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                              _7892 = sqrt((float((int)(_7887)) * 0.25f) + 0.125f) * _7605;
                              _7901 = (_global_7[min((uint)(((int)(0u + (_7887 * 2)))), 127u)]) * _7892;
                              _7902 = (_global_7[min((uint)(((int)(1u + (_7887 * 2)))), 127u)]) * _7892;
                              _7908 = _HeapResource_43.GatherRed(samplerPointClampNode, float2((dot(float2(_7901, _7902), float2(_7728, _7727)) + _7707), (dot(float2(_7901, _7902), float2(_7746, _7728)) + _7709)));
                              _7913 = _7908.x - _7713;
                              _7915 = select((_7913 < 0.0f), 0.0f, 1.0f);
                              _7919 = _7908.y - _7713;
                              _7921 = select((_7919 < 0.0f), 0.0f, 1.0f);
                              _7925 = _7908.z - _7713;
                              _7927 = select((_7925 < 0.0f), 0.0f, 1.0f);
                              _7931 = _7908.w - _7713;
                              _7933 = select((_7931 < 0.0f), 0.0f, 1.0f);
                              _7934 = ((((((((((((((_7758 + _7762) + _7768) + _7774) + _7809) + _7815) + _7821) + _7827) + _7862) + _7868) + _7874) + _7880) + _7915) + _7921) + _7927) + _7933;
                              _7945 = (saturate(_7934 * 0.0625f) * 2.0f) + -1.0f;
                              _7951 = float((int)(((int)(uint)((int)(_7945 > 0.0f))) - ((int)(uint)((int)(_7945 < 0.0f)))));
                              _7953 = 1.0f - (_7951 * _7945);
                              _7955 = (_7953 * _7953) * _7953;
                              _7962 = 0.5f - ((_7951 * 0.5f) * ((1.0f - _7955) - ((_7953 - _7955) * saturate(((1.0f / _7713) * (1.0f / _7934)) * ((((((((((((((((_7758 * _7756) + (_7762 * _7760)) + (_7768 * _7766)) + (_7774 * _7772)) + (_7809 * _7807)) + (_7815 * _7813)) + (_7821 * _7819)) + (_7827 * _7825)) + (_7862 * _7860)) + (_7868 * _7866)) + (_7874 * _7872)) + (_7880 * _7878)) + (_7915 * _7913)) + (_7921 * _7919)) + (_7927 * _7925)) + (_7933 * _7931))))));
                              [branch]
                              if (_7611 < 1.0f) {
                                _7965 = _7962;
                                _7966 = _7611;
                                _7967 = _7710;
                                __branch_chain_7694 = true;
                              } else {
                                _8435 = _7611;
                                _8436 = _7962;
                                __branch_chain_7694 = false;
                              }
                            }
                            if (__branch_chain_7694) {
                              _7970 = (_7701 * _7554) + _7556;
                              _7971 = (_7702 * _7555) + _7557;
                              if (!((_2251 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_44 = ResourceDescriptorHeap[5];
                                _7980 = saturate(_7967);
                                _7984 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                                _7993 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 7u) : (frac(frac(dot(float2(((_7984 * 32.665000915527344f) + _142), ((_7984 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7994 = sin(_7993);
                                _7995 = cos(_7993);
                                _8000 = select(((((float4)(_HeapResource_44.SampleLevel(samplerPointBorderWhiteNode, float2(_7970, _7971), 0.0f))).x) > _7980), 1.0f, 0.0f);
                                _8001 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                                _8006 = sqrt((float((int)(_8001)) * 0.25f) + 0.125f) * _7606;
                                _8015 = (_global_7[min((uint)(((int)(0u + (_8001 * 2)))), 127u)]) * _8006;
                                _8016 = (_global_7[min((uint)(((int)(1u + (_8001 * 2)))), 127u)]) * _8006;
                                _8018 = -0.0f - _7994;
                                _8020 = dot(float2(_8015, _8016), float2(_7995, _7994)) + _7970;
                                _8021 = dot(float2(_8015, _8016), float2(_8018, _7995)) + _7971;
                                _8023 = _HeapResource_44.GatherRed(samplerPointClampNode, float2(_8020, _8021));
                                _8027 = _8020 * (_cbSharedPerViewData_raw[82u].x);
                                _8028 = _8021 * (_cbSharedPerViewData_raw[82u].y);
                                _8031 = floor((_cbSharedPerViewData_raw[82u].x) * _7556);
                                _8032 = floor((_cbSharedPerViewData_raw[82u].y) * _7557);
                                _8037 = floor(((_cbSharedPerViewData_raw[82u].x) * (_7554 + _7556)) + 0.5f);
                                _8038 = floor(((_cbSharedPerViewData_raw[82u].y) * (_7555 + _7557)) + 0.5f);
                                _8041 = floor(_8027 + -0.5f);
                                _8042 = floor(_8028 + 0.5f);
                                _8044 = floor(_8027 + 0.5f);
                                _8046 = floor(_8028 + -0.5f);
                                _8047 = (_8041 < _8031);
                                _8048 = (_8042 < _8032);
                                if ((_8047 || _8048) | ((_8041 >= _8037) || (_8042 >= _8038))) {
                                  _8057 = _8000;
                                } else {
                                  _8057 = _8023.x;
                                }
                                _8058 = (_8044 < _8031);
                                if ((_8058 || _8048) | ((_8044 >= _8037) || (_8042 >= _8038))) {
                                  _8066 = _8000;
                                } else {
                                  _8066 = _8023.y;
                                }
                                _8067 = (_8046 < _8032);
                                if ((_8058 || _8067) | ((_8044 >= _8037) || (_8046 >= _8038))) {
                                  _8075 = _8000;
                                } else {
                                  _8075 = _8023.z;
                                }
                                if ((_8047 || _8067) | ((_8041 >= _8037) || (_8046 >= _8038))) {
                                  _8083 = _8000;
                                } else {
                                  _8083 = _8023.w;
                                }
                                _8084 = _8057 - _7980;
                                _8086 = select((_8084 < 0.0f), 0.0f, 1.0f);
                                _8088 = _8066 - _7980;
                                _8090 = select((_8088 < 0.0f), 0.0f, 1.0f);
                                _8094 = _8075 - _7980;
                                _8096 = select((_8094 < 0.0f), 0.0f, 1.0f);
                                _8100 = _8083 - _7980;
                                _8102 = select((_8100 < 0.0f), 0.0f, 1.0f);
                                _8109 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                                _8114 = sqrt((float((int)(_8109)) * 0.25f) + 0.125f) * _7606;
                                _8123 = (_global_7[min((uint)(((int)(0u + (_8109 * 2)))), 127u)]) * _8114;
                                _8124 = (_global_7[min((uint)(((int)(1u + (_8109 * 2)))), 127u)]) * _8114;
                                _8127 = dot(float2(_8123, _8124), float2(_7995, _7994)) + _7970;
                                _8128 = dot(float2(_8123, _8124), float2(_8018, _7995)) + _7971;
                                _8130 = _HeapResource_44.GatherRed(samplerPointClampNode, float2(_8127, _8128));
                                _8134 = _8127 * (_cbSharedPerViewData_raw[82u].x);
                                _8135 = _8128 * (_cbSharedPerViewData_raw[82u].y);
                                _8138 = floor(_8134 + -0.5f);
                                _8139 = floor(_8135 + 0.5f);
                                _8141 = floor(_8134 + 0.5f);
                                _8143 = floor(_8135 + -0.5f);
                                _8144 = (_8138 < _8031);
                                _8145 = (_8139 < _8032);
                                if ((_8144 || _8145) | ((_8138 >= _8037) || (_8139 >= _8038))) {
                                  _8154 = _8000;
                                } else {
                                  _8154 = _8130.x;
                                }
                                _8155 = (_8141 < _8031);
                                if ((_8155 || _8145) | ((_8141 >= _8037) || (_8139 >= _8038))) {
                                  _8163 = _8000;
                                } else {
                                  _8163 = _8130.y;
                                }
                                _8164 = (_8143 < _8032);
                                if ((_8155 || _8164) | ((_8141 >= _8037) || (_8143 >= _8038))) {
                                  _8172 = _8000;
                                } else {
                                  _8172 = _8130.z;
                                }
                                if ((_8144 || _8164) | ((_8138 >= _8037) || (_8143 >= _8038))) {
                                  _8180 = _8000;
                                } else {
                                  _8180 = _8130.w;
                                }
                                _8181 = _8154 - _7980;
                                _8183 = select((_8181 < 0.0f), 0.0f, 1.0f);
                                _8187 = _8163 - _7980;
                                _8189 = select((_8187 < 0.0f), 0.0f, 1.0f);
                                _8193 = _8172 - _7980;
                                _8195 = select((_8193 < 0.0f), 0.0f, 1.0f);
                                _8199 = _8180 - _7980;
                                _8201 = select((_8199 < 0.0f), 0.0f, 1.0f);
                                _8208 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                                _8213 = sqrt((float((int)(_8208)) * 0.25f) + 0.125f) * _7606;
                                _8222 = (_global_7[min((uint)(((int)(0u + (_8208 * 2)))), 127u)]) * _8213;
                                _8223 = (_global_7[min((uint)(((int)(1u + (_8208 * 2)))), 127u)]) * _8213;
                                _8226 = dot(float2(_8222, _8223), float2(_7995, _7994)) + _7970;
                                _8227 = dot(float2(_8222, _8223), float2(_8018, _7995)) + _7971;
                                _8229 = _HeapResource_44.GatherRed(samplerPointClampNode, float2(_8226, _8227));
                                _8233 = _8226 * (_cbSharedPerViewData_raw[82u].x);
                                _8234 = _8227 * (_cbSharedPerViewData_raw[82u].y);
                                _8237 = floor(_8233 + -0.5f);
                                _8238 = floor(_8234 + 0.5f);
                                _8240 = floor(_8233 + 0.5f);
                                _8242 = floor(_8234 + -0.5f);
                                _8243 = (_8237 < _8031);
                                _8244 = (_8238 < _8032);
                                if ((_8243 || _8244) | ((_8237 >= _8037) || (_8238 >= _8038))) {
                                  _8253 = _8000;
                                } else {
                                  _8253 = _8229.x;
                                }
                                _8254 = (_8240 < _8031);
                                if ((_8254 || _8244) | ((_8240 >= _8037) || (_8238 >= _8038))) {
                                  _8262 = _8000;
                                } else {
                                  _8262 = _8229.y;
                                }
                                _8263 = (_8242 < _8032);
                                if ((_8254 || _8263) | ((_8240 >= _8037) || (_8242 >= _8038))) {
                                  _8271 = _8000;
                                } else {
                                  _8271 = _8229.z;
                                }
                                if ((_8243 || _8263) | ((_8237 >= _8037) || (_8242 >= _8038))) {
                                  _8279 = _8000;
                                } else {
                                  _8279 = _8229.w;
                                }
                                _8280 = _8253 - _7980;
                                _8282 = select((_8280 < 0.0f), 0.0f, 1.0f);
                                _8286 = _8262 - _7980;
                                _8288 = select((_8286 < 0.0f), 0.0f, 1.0f);
                                _8292 = _8271 - _7980;
                                _8294 = select((_8292 < 0.0f), 0.0f, 1.0f);
                                _8298 = _8279 - _7980;
                                _8300 = select((_8298 < 0.0f), 0.0f, 1.0f);
                                _8307 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                                _8312 = sqrt((float((int)(_8307)) * 0.25f) + 0.125f) * _7606;
                                _8321 = (_global_7[min((uint)(((int)(0u + (_8307 * 2)))), 127u)]) * _8312;
                                _8322 = (_global_7[min((uint)(((int)(1u + (_8307 * 2)))), 127u)]) * _8312;
                                _8325 = dot(float2(_8321, _8322), float2(_7995, _7994)) + _7970;
                                _8326 = dot(float2(_8321, _8322), float2(_8018, _7995)) + _7971;
                                _8328 = _HeapResource_44.GatherRed(samplerPointClampNode, float2(_8325, _8326));
                                _8332 = _8325 * (_cbSharedPerViewData_raw[82u].x);
                                _8333 = _8326 * (_cbSharedPerViewData_raw[82u].y);
                                _8336 = floor(_8332 + -0.5f);
                                _8337 = floor(_8333 + 0.5f);
                                _8339 = floor(_8332 + 0.5f);
                                _8341 = floor(_8333 + -0.5f);
                                _8342 = (_8336 < _8031);
                                _8343 = (_8337 < _8032);
                                if ((_8342 || _8343) | ((_8336 >= _8037) || (_8337 >= _8038))) {
                                  _8352 = _8000;
                                } else {
                                  _8352 = _8328.x;
                                }
                                _8353 = (_8339 < _8031);
                                if ((_8353 || _8343) | ((_8339 >= _8037) || (_8337 >= _8038))) {
                                  _8361 = _8000;
                                } else {
                                  _8361 = _8328.y;
                                }
                                _8362 = (_8341 < _8032);
                                if ((_8353 || _8362) | ((_8339 >= _8037) || (_8341 >= _8038))) {
                                  _8370 = _8000;
                                } else {
                                  _8370 = _8328.z;
                                }
                                if ((_8342 || _8362) | ((_8336 >= _8037) || (_8341 >= _8038))) {
                                  _8378 = _8000;
                                } else {
                                  _8378 = _8328.w;
                                }
                                _8379 = _8352 - _7980;
                                _8381 = select((_8379 < 0.0f), 0.0f, 1.0f);
                                _8385 = _8361 - _7980;
                                _8387 = select((_8385 < 0.0f), 0.0f, 1.0f);
                                _8391 = _8370 - _7980;
                                _8393 = select((_8391 < 0.0f), 0.0f, 1.0f);
                                _8397 = _8378 - _7980;
                                _8399 = select((_8397 < 0.0f), 0.0f, 1.0f);
                                _8400 = ((((((((((((((_8090 + _8086) + _8096) + _8102) + _8183) + _8189) + _8195) + _8201) + _8282) + _8288) + _8294) + _8300) + _8381) + _8387) + _8393) + _8399;
                                _8411 = (saturate(_8400 * 0.0625f) * 2.0f) + -1.0f;
                                _8417 = float((int)(((int)(uint)((int)(_8411 > 0.0f))) - ((int)(uint)((int)(_8411 < 0.0f)))));
                                _8419 = 1.0f - (_8417 * _8411);
                                _8421 = (_8419 * _8419) * _8419;
                                _8430 = (0.5f - ((_8417 * 0.5f) * ((1.0f - _8421) - ((_8419 - _8421) * saturate(((1.0f / _7980) * (1.0f / _8400)) * ((((((((((((((((_8090 * _8088) + (_8086 * _8084)) + (_8096 * _8094)) + (_8102 * _8100)) + (_8183 * _8181)) + (_8189 * _8187)) + (_8195 * _8193)) + (_8201 * _8199)) + (_8282 * _8280)) + (_8288 * _8286)) + (_8294 * _8292)) + (_8300 * _8298)) + (_8381 * _8379)) + (_8387 * _8385)) + (_8393 * _8391)) + (_8399 * _8397)))))));
                              } else {
                                _8430 = 1.0f;
                              }
                              _8435 = _7966;
                              _8436 = (lerp(_8430, _7965, _7966));
                            }
                            [branch]
                            if (!((_2251 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_45 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7542) >> 16))];
                              _8442 = _HeapResource_45.SampleLevel(samplerLinearClampNode, float2(_7666, _7667), 0.0f);
                              if (_8442.x > 0.0f) {
                                Texture2D<float4> _HeapResource_46 = ResourceDescriptorHeap[NonUniformResourceIndex((_7542 & 65535))];
                                _8449 = _HeapResource_46.SampleLevel(samplerLinearClampNode, float2(_7666, _7667), 0.0f);
                                _8463 = mad(saturate(((log2(_7617) * 0.6931471824645996f) - (_cbSharedPerViewData_raw[147u].w)) * (_cbSharedPerViewData_raw[148u].x)), 2.0f, -1.0f);
                                _8464 = max(9.999999747378752e-06f, _8442.x);
                                _8465 = _8449.x / _8464;
                                _8466 = _8449.y / _8464;
                                _8468 = _8449.w / _8464;
                                _8473 = ((0.375f - _8466) * 4.999999873689376e-06f) + _8466;
                                _8476 = -0.0f - _8465;
                                _8477 = mad(_8476, _8473, (_8449.z / _8464));
                                _8479 = 1.0f / mad(_8476, _8465, _8473);
                                _8480 = _8479 * _8477;
                                _8485 = _8463 - _8465;
                                _8490 = (((_8463 * _8463) - _8473) - (_8480 * _8485)) / mad((-0.0f - _8477), _8480, mad((-0.0f - _8473), _8473, (((0.375f - _8468) * 4.999999873689376e-06f) + _8468)));
                                _8492 = (_8479 * _8485) - (_8490 * _8480);
                                _8495 = 1.0f / _8490;
                                _8496 = _8492 * _8495;
                                _8501 = sqrt(((_8496 * _8496) * 0.25f) - ((1.0f - dot(float2(_8492, _8490), float2(_8465, _8473))) * _8495));
                                _8503 = (_8496 * -0.5f) - _8501;
                                _8505 = _8501 - (_8496 * 0.5f);
                                _8507 = select((_8503 < _8463), 1.0f, 0.0f);
                                _8512 = (_8507 + -0.05000000074505806f) / (_8503 - _8463);
                                _8518 = (((select((_8505 < _8463), 1.0f, 0.0f) - _8507) / (_8505 - _8503)) - _8512) / (_8505 - _8463);
                                _8520 = _8512 - (_8518 * _8503);
                                _8533 = _8435;
                                _8534 = (exp2((_8442.x * -1.4426950216293335f) * saturate((dot(float2(_8465, _8473), float2((_8520 - (_8518 * _8463)), _8518)) + 0.05000000074505806f) - (_8520 * _8463))) * _8436);
                              } else {
                                _8533 = _8435;
                                _8534 = _8436;
                              }
                            } else {
                              _8533 = _8435;
                              _8534 = _8436;
                            }
                          } else {
                            _8533 = 0.0f;
                            _8534 = 1.0f;
                          }
                          [branch]
                          if (!(_7589 == 0)) {
                            Texture2D<float3> _HeapResource_47 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _7589)))];
                            _8547 = _HeapResource_47.SampleLevel(samplerLinearWrapNode, float2(((_7666 * f16tof32(((uint)((uint)(_7548) >> 16)))) + f16tof32(((uint)((uint)(_7551) >> 16)))), ((_7667 * f16tof32(_7548)) + f16tof32(_7551))), 0.0f);
                            _8555 = (_8547.x * _7568);
                            _8556 = (_8547.y * _7569);
                            _8557 = (_8547.z * _7571);
                          } else {
                            _8555 = _7568;
                            _8556 = _7569;
                            _8557 = _7571;
                          }
                          _8558 = _8534 * _7690;
                          [branch]
                          if (!(_8558 == 0.0f)) {
                            bool __branch_chain_8560;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _8576 = 0;
                              __branch_chain_8560 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _8576 = 1;
                                __branch_chain_8560 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _8576 = 2;
                                  __branch_chain_8560 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _2254) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _8576 = 3;
                                    __branch_chain_8560 = true;
                                  } else {
                                    _8601 = _8558;
                                    __branch_chain_8560 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_8560) {
                              while(true) {
                                _8579 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_80, _81, 0));
                                if (_8576 == 0) {
                                  _8593 = _8579.x;
                                } else {
                                  if (_8576 == 1) {
                                    _8593 = _8579.y;
                                  } else {
                                    if (_8576 == 2) {
                                      _8593 = _8579.z;
                                    } else {
                                      _8593 = _8579.w;
                                    }
                                  }
                                }
                                _8601 = ((((_8533 * _8533) * ((_8593 * _8593) + -1.0f)) + 1.0f) * _7690);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_8601 > 0.0f) {
                                if (!(((_7545 & 1) == 0) || _7692)) {
                                  _8617 = max(max(_8555, _8556), _8557);
                                  if (_8617 > 0.0f) {
                                    _8627 = saturate(_8555 / _8617);
                                    _8628 = saturate(_8556 / _8617);
                                    _8629 = saturate(_8557 / _8617);
                                  } else {
                                    _8627 = _8555;
                                    _8628 = _8556;
                                    _8629 = _8557;
                                  }
                                  _8630 = (_8628 < _8629);
                                  _8631 = select(_8630, _8629, _8628);
                                  _8632 = select(_8630, _8628, _8629);
                                  _8633 = select(_8630, -1.0f, 0.0f);
                                  _8634 = (_8627 < _8631);
                                  _8636 = select(_8634, _8631, _8627);
                                  _8637 = select(_8634, _8627, _8631);
                                  _8641 = _8636 - select((_8637 < _8632), _8637, _8632);
                                  _8647 = abs(select(_8634, (-0.3333333432674408f - _8633), _8633) + ((_8637 - _8632) / ((_8641 * 6.0f) + 9.999999682655225e-21f)));
                                  if (_8647 < 0.6666666865348816f) {
                                    _8660 = ((saturate(((float)((uint)((uint)(((uint)(_7545) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8647 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8647)) + _8647);
                                  } else {
                                    _8660 = _8647;
                                  }
                                  _8661 = saturate((_8641 / (_8636 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7545) >> 1) & 255)))) * 0.003921499941498041f));
                                  _8662 = saturate(_8636);
                                  if (!(_8661 <= 0.0f)) {
                                    _8665 = saturate(_8660);
                                    _8669 = select(((_8665 * 360.0f) >= 360.0f), 0.0f, (_8665 * 6.0f));
                                    _8670 = int(_8669);
                                    _8672 = _8669 - float((int)(_8670));
                                    _8674 = _8662 * (1.0f - _8661);
                                    _8677 = (1.0f - (_8672 * _8661)) * _8662;
                                    _8681 = (1.0f - ((1.0f - _8672) * _8661)) * _8662;
                                    switch (_8670) {
                                      case 0: {
                                        _8689 = _8662;
                                        _8690 = _8681;
                                        _8691 = _8674;
                                        break;
                                      }
                                      case 1: {
                                        _8689 = _8677;
                                        _8690 = _8662;
                                        _8691 = _8674;
                                        break;
                                      }
                                      case 2: {
                                        _8689 = _8674;
                                        _8690 = _8662;
                                        _8691 = _8681;
                                        break;
                                      }
                                      case 3: {
                                        _8689 = _8674;
                                        _8690 = _8677;
                                        _8691 = _8662;
                                        break;
                                      }
                                      case 4: {
                                        _8689 = _8681;
                                        _8690 = _8674;
                                        _8691 = _8662;
                                        break;
                                      }
                                      case 5: {
                                        _8689 = _8662;
                                        _8690 = _8674;
                                        _8691 = _8677;
                                        break;
                                      }
                                      default: {
                                        _8689 = 0.0f;
                                        _8690 = 0.0f;
                                        _8691 = 0.0f;
                                        break;
                                      }
                                    }
                                  } else {
                                    _8689 = _8662;
                                    _8690 = _8662;
                                    _8691 = _8662;
                                  }
                                  _8692 = _8689 * _8617;
                                  _8693 = _8690 * _8617;
                                  _8694 = _8691 * _8617;
                                  _8696 = saturate(_8534 * 1.0101009607315063f);
                                  _8707 = ((_8696 * (_8555 - _8692)) + _8692);
                                  _8708 = ((_8696 * (_8556 - _8693)) + _8693);
                                  _8709 = (lerp(_8694, _8557, _8696));
                                } else {
                                  _8707 = _8555;
                                  _8708 = _8556;
                                  _8709 = _8557;
                                }
                                [branch]
                                if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                                  _8716 = srvLightMappingData[_2254];
                                  if (!(_8716 == -1)) {
                                    _8721 = srvLightIndexData[_8716].nLayerIndex;
                                    _8723 = srvLightIndexData[_8716].vAtlasOrigin.x;
                                    _8724 = srvLightIndexData[_8716].vAtlasOrigin.y;
                                    _8726 = srvLightIndexData[_8716].vScreenOrigin.x;
                                    _8727 = srvLightIndexData[_8716].vScreenOrigin.y;
                                    _8736 = ((int)(_8721 * 5)) & 31;
                                    _8745 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8723 + _80) - _8726)), ((int)((_8724 + _81) - _8727)), 0)))).x) & ((int)(31 << _8736)))) >> _8736)) >> 1)))) * 0.06666667014360428f) * _8601);
                                  } else {
                                    _8745 = _8601;
                                  }
                                } else {
                                  _8745 = _8601;
                                }
                                _8749 = ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0);
                                _8752 = select(_8749, (_8745 * _1983), _8745);
                                _8754 = _7618 * _7617;
                                _8755 = _7619 * _7617;
                                _8756 = _7620 * _7617;
                                _8757 = _7579 * _7510;
                                _8758 = _7579 * _7511;
                                _8759 = _7579 * _7512;
                                _8760 = _8754 + _8757;
                                _8761 = _8755 + _8758;
                                _8762 = _8756 + _8759;
                                _8763 = _8754 - _8757;
                                _8764 = _8755 - _8758;
                                _8765 = _8756 - _8759;
                                _8766 = (_7579 > 0.0f);
                                _8767 = dot(float3(_8760, _8761, _8762), float3(_8760, _8761, _8762));
                                _8768 = rsqrt(_8767);
                                [branch]
                                if (_8766) {
                                  _8771 = rsqrt(dot(float3(_8763, _8764, _8765), float3(_8763, _8764, _8765)));
                                  _8772 = _8771 * _8768;
                                  _8774 = dot(float3(_8760, _8761, _8762), float3(_8763, _8764, _8765)) * _8772;
                                  _8793 = (_8772 / ((_8772 + 0.5f) + (_8774 * 0.5f)));
                                  _8794 = (((dot(float3(_205, _207, _209), float3(_8763, _8764, _8765)) * _8771) + (dot(float3(_205, _207, _209), float3(_8760, _8761, _8762)) * _8768)) * 0.5f);
                                  _8795 = _8774;
                                } else {
                                  _8793 = (1.0f / (_8767 + 1.0f));
                                  _8794 = dot(float3(_205, _207, _209), float3((_8768 * _8760), (_8768 * _8761), (_8768 * _8762)));
                                  _8795 = 1.0f;
                                }
                                if (_7581 > 0.0f) {
                                  _8801 = sqrt(saturate((_7581 * _7581) * _8793));
                                  if (_8794 < _8801) {
                                    _8806 = max(_8794, (-0.0f - _8801)) + _8801;
                                    _8811 = ((_8806 * _8806) / (_8801 * 4.0f));
                                  } else {
                                    _8811 = _8794;
                                  }
                                } else {
                                  _8811 = _8794;
                                }
                                if (_8766) {
                                  _8813 = -0.0f - _257;
                                  _8814 = -0.0f - _258;
                                  _8815 = -0.0f - _256;
                                  _8817 = dot(float3(_8813, _8814, _8815), float3(_205, _207, _209)) * 2.0f;
                                  _8821 = _8813 - (_8817 * _205);
                                  _8822 = _8814 - (_8817 * _207);
                                  _8823 = _8815 - (_8817 * _209);
                                  _8824 = _8763 - _8760;
                                  _8825 = _8764 - _8761;
                                  _8826 = _8765 - _8762;
                                  _8827 = dot(float3(_8821, _8822, _8823), float3(_8824, _8825, _8826));
                                  _8833 = sqrt(((_8824 * _8824) + (_8825 * _8825)) + (_8826 * _8826));
                                  _8842 = saturate(((dot(float3(_8821, _8822, _8823), float3(_8760, _8761, _8762)) * _8827) - dot(float3(_8760, _8761, _8762), float3(_8824, _8825, _8826))) / ((_8833 * _8833) - (_8827 * _8827)));
                                  _8846 = (_8842 * _8824) + _8760;
                                  _8847 = (_8842 * _8825) + _8761;
                                  _8848 = (_8842 * _8826) + _8762;
                                  _8849 = dot(float3(_8846, _8847, _8848), float3(_8821, _8822, _8823));
                                  _8853 = (_8849 * _8821) - _8846;
                                  _8854 = (_8849 * _8822) - _8847;
                                  _8855 = (_8849 * _8823) - _8848;
                                  _8863 = saturate(0.009999999776482582f / sqrt(((_8853 * _8853) + (_8854 * _8854)) + (_8855 * _8855)));
                                  _8871 = ((_8863 * _8853) + _8846);
                                  _8872 = ((_8863 * _8854) + _8847);
                                  _8873 = ((_8863 * _8855) + _8848);
                                } else {
                                  _8871 = _8760;
                                  _8872 = _8761;
                                  _8873 = _8762;
                                }
                                _8875 = rsqrt(dot(float3(_8871, _8872, _8873), float3(_8871, _8872, _8873)));
                                _8876 = _8875 * _8871;
                                _8877 = _8875 * _8872;
                                _8878 = _8875 * _8873;
                                _8879 = _233 * _233;
                                _8880 = 1.0f - _8879;
                                _8883 = saturate((_7581 * _8880) * _8875);
                                _8885 = saturate(_8875 * f16tof32(_7524));
                                _8887 = rsqrt(dot(float3(_8754, _8755, _8756), float3(_8754, _8755, _8756)));
                                _8891 = dot(float3(_205, _207, _209), float3(_8876, _8877, _8878));
                                _8892 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                                _8893 = dot(float3(_257, _258, _256), float3(_8876, _8877, _8878));
                                _8896 = rsqrt((_8893 * 2.0f) + 2.0f);
                                _8899 = saturate(_8896 * (_8892 + _8891));
                                _8902 = saturate((_8896 * _8893) + _8896);
                                _8903 = (_8883 > 0.0f);
                                if (_8903) {
                                  _8907 = sqrt(1.0f - (_8883 * _8883));
                                  _8909 = (_8891 * 2.0f) * _8892;
                                  _8910 = _8909 - _8893;
                                  if (!(_8910 >= _8907)) {
                                    _8918 = rsqrt(1.0f - (_8910 * _8910)) * _8883;
                                    _8921 = _8918 * (_8892 - (_8910 * _8891));
                                    _8922 = _8892 * _8892;
                                    _8927 = _8918 * (((_8922 * 2.0f) + -1.0f) - (_8910 * _8893));
                                    _8936 = sqrt(saturate((((1.0f - (_8891 * _8891)) - _8922) - (_8893 * _8893)) + (_8909 * _8893)));
                                    _8937 = _8936 * _8918;
                                    _8940 = ((_8892 * 2.0f) * _8918) * _8936;
                                    _8942 = (_8907 * _8891) + _8892;
                                    _8943 = _8942 + _8921;
                                    _8944 = _8907 * _8893;
                                    _8946 = (_8944 + 1.0f) + _8927;
                                    _8947 = _8937 * _8946;
                                    _8948 = _8943 * _8946;
                                    _8949 = _8940 * _8943;
                                    _8954 = (((_8943 * 0.25f) * _8940) - (_8947 * 0.5f)) * _8948;
                                    _8968 = (((_8949 - (_8947 * 2.0f)) * _8949) + (_8947 * _8947)) + ((((-0.5f - ((_8946 + _8944) * 0.5f)) * _8948) + ((_8946 * _8946) * _8942)) * _8943);
                                    _8973 = (_8954 * 2.0f) / ((_8968 * _8968) + (_8954 * _8954));
                                    _8974 = _8968 * _8973;
                                    _8976 = 1.0f - (_8954 * _8973);
                                    _8982 = ((_8974 * _8940) + _8944) + (_8976 * _8927);
                                    _8985 = rsqrt((_8982 * 2.0f) + 2.0f);
                                    _8994 = saturate((_8982 * _8985) + _8985);
                                    _8995 = saturate(((_8942 + (_8974 * _8937)) + (_8976 * _8921)) * _8985);
                                  } else {
                                    _8994 = abs(_8892);
                                    _8995 = 1.0f;
                                  }
                                } else {
                                  _8994 = _8902;
                                  _8995 = _8899;
                                }
                                _8996 = saturate(_8811);
                                _8998 = _8879 * _8879;
                                _8999 = (_8885 > 0.0f);
                                if (_8999) {
                                  _9008 = saturate(((_8885 * _8885) / ((_8994 * 3.5999999046325684f) + 0.4000000059604645f)) + _8998);
                                } else {
                                  _9008 = _8998;
                                }
                                if (_8903) {
                                  _9017 = (((_8883 * 0.25f) * ((sqrt(_9008) * 3.0f) + _8883)) / (_8994 + 0.0010000000474974513f)) + _9008;
                                  _9020 = _9017;
                                  _9021 = (_9008 / _9017);
                                } else {
                                  _9020 = _9008;
                                  _9021 = 1.0f;
                                }
                                _9022 = (_8795 < 1.0f);
                                if (_9022) {
                                  _9028 = sqrt((1.000100016593933f - _8795) / max(9.999999974752427e-07f, (_8795 + 1.0f)));
                                  _9041 = (sqrt(_9020 / ((((_9028 * 0.25f) * ((sqrt(_9020) * 3.0f) + _9028)) / (_8994 + 0.0010000000474974513f)) + _9020)) * _9021);
                                } else {
                                  _9041 = _9021;
                                }
                                _9045 = (((_9008 * _8995) - _8995) * _8995) + 1.0f;
                                _9055 = exp2(log2(1.0f - saturate(_8994)) * 5.0f);
                                _9062 = abs(_8892);
                                _9064 = saturate(_9062 + 9.999999747378752e-06f);
                                _9065 = sqrt(_9008);
                                _9066 = 1.0f - _9065;
                                _9075 = _231 * _231;
                                _9076 = _9075 * _9075;
                                _9082 = saturate(select((_8880 > 0.0f), ((1.0f - _9075) / _8880), 0.0f) * _8883);
                                _9083 = (_9082 > 0.0f);
                                if (_9083) {
                                  _9087 = sqrt(1.0f - (_9082 * _9082));
                                  _9089 = (_8891 * 2.0f) * _8892;
                                  _9090 = _9089 - _8893;
                                  if (!(_9090 >= _9087)) {
                                    _9096 = rsqrt(1.0f - (_9090 * _9090)) * _9082;
                                    _9099 = _9096 * (_8892 - (_9090 * _8891));
                                    _9100 = _8892 * _8892;
                                    _9105 = _9096 * (((_9100 * 2.0f) + -1.0f) - (_9090 * _8893));
                                    _9114 = sqrt(saturate((((1.0f - (_8891 * _8891)) - _9100) - (_8893 * _8893)) + (_9089 * _8893)));
                                    _9115 = _9114 * _9096;
                                    _9118 = ((_8892 * 2.0f) * _9096) * _9114;
                                    _9120 = (_9087 * _8891) + _8892;
                                    _9121 = _9120 + _9099;
                                    _9122 = _9087 * _8893;
                                    _9124 = (_9122 + 1.0f) + _9105;
                                    _9125 = _9115 * _9124;
                                    _9126 = _9121 * _9124;
                                    _9127 = _9118 * _9121;
                                    _9132 = (((_9121 * 0.25f) * _9118) - (_9125 * 0.5f)) * _9126;
                                    _9146 = (((_9127 - (_9125 * 2.0f)) * _9127) + (_9125 * _9125)) + ((((-0.5f - ((_9124 + _9122) * 0.5f)) * _9126) + ((_9124 * _9124) * _9120)) * _9121);
                                    _9151 = (_9132 * 2.0f) / ((_9146 * _9146) + (_9132 * _9132));
                                    _9152 = _9146 * _9151;
                                    _9154 = 1.0f - (_9132 * _9151);
                                    _9160 = ((_9152 * _9118) + _9122) + (_9154 * _9105);
                                    _9163 = rsqrt((_9160 * 2.0f) + 2.0f);
                                    _9172 = saturate((_9160 * _9163) + _9163);
                                    _9173 = saturate(((_9120 + (_9152 * _9115)) + (_9154 * _9099)) * _9163);
                                  } else {
                                    _9172 = _9062;
                                    _9173 = 1.0f;
                                  }
                                } else {
                                  _9172 = _8902;
                                  _9173 = _8899;
                                }
                                if (_8999) {
                                  _9182 = saturate(((_8885 * _8885) / ((_9172 * 3.5999999046325684f) + 0.4000000059604645f)) + _9076);
                                } else {
                                  _9182 = _9076;
                                }
                                if (_9083) {
                                  _9191 = (((_9082 * 0.25f) * ((sqrt(_9182) * 3.0f) + _9082)) / (_9172 + 0.0010000000474974513f)) + _9182;
                                  _9194 = _9191;
                                  _9195 = (_9182 / _9191);
                                } else {
                                  _9194 = _9182;
                                  _9195 = 1.0f;
                                }
                                if (_9022) {
                                  _9201 = sqrt((1.000100016593933f - _8795) / max(9.999999974752427e-07f, (_8795 + 1.0f)));
                                  _9214 = (sqrt(_9194 / ((((_9201 * 0.25f) * ((sqrt(_9194) * 3.0f) + _9201)) / (_9172 + 0.0010000000474974513f)) + _9194)) * _9195);
                                } else {
                                  _9214 = _9195;
                                }
                                _9218 = (((_9182 * _9173) - _9173) * _9173) + 1.0f;
                                _9219 = sqrt(_9182);
                                _9220 = 1.0f - _9219;
                                _9224 = saturate((dot(float3(_205, _207, _209), float3((_8887 * _8754), (_8887 * _8755), (_8887 * _8756))) + _7578) / (_7578 + 1.0f));
                                _9227 = ((_9041 * _8996) * (_9008 / (_9045 * _9045))) * (0.5f / ((((_9066 * _9064) + _9065) * _8996) + (((_9066 * _8996) + _9065) * _9064)));
                                _9228 = _8707 * _2301;
                                _9229 = _8708 * _2301;
                                _9230 = _8709 * _2301;
                                _9237 = ((_8752 * _9228) * _9224) + _2239;
                                _9238 = ((_8752 * _9229) * _9224) + _2240;
                                _9239 = ((_8752 * _9230) * _9224) + _2241;
                                if (_7575 > 0.0f) {
                                  _9264 = (((exp2(log2(1.0f - saturate(_9172)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_9214 * _8996) * (_9182 / (_9218 * _9218))) * (0.5f / ((((_9220 * _9064) + _9219) * _8996) + (((_9220 * _8996) + _9219) * _9064))));
                                  _9271 = (_7575 * _1998) * select(_8749, (_8745 * _1983), _8745);
                                  _9759 = _9237;
                                  _9760 = _9238;
                                  _9761 = _9239;
                                  _9762 = (((_9271 * _9228) * (_9264 + (_9227 * ((_9055 * (1.0f - _227)) + _227)))) + _2242);
                                  _9763 = (((_9271 * _9229) * (_9264 + (_9227 * ((_9055 * (1.0f - _228)) + _228)))) + _2243);
                                  _9764 = (((_9271 * _9230) * (_9264 + (_9227 * ((_9055 * (1.0f - _229)) + _229)))) + _2244);
                                } else {
                                  _9759 = _9237;
                                  _9760 = _9238;
                                  _9761 = _9239;
                                  _9762 = _2242;
                                  _9763 = _2243;
                                  _9764 = _2244;
                                }
                              } else {
                                _9759 = _2239;
                                _9760 = _2240;
                                _9761 = _2241;
                                _9762 = _2242;
                                _9763 = _2243;
                                _9764 = _2244;
                              }
                              break;
                            }
                          } else {
                            _9759 = _2239;
                            _9760 = _2240;
                            _9761 = _2241;
                            _9762 = _2242;
                            _9763 = _2243;
                            _9764 = _2244;
                          }
                        } else {
                          if (_2284 == 10) {
                            _9286 = asfloat(srvLightInfoProperties.Load4(_2253)).x;
                            _9287 = asfloat(srvLightInfoProperties.Load4(_2253)).y;
                            _9288 = asfloat(srvLightInfoProperties.Load4(_2253)).z;
                            _9289 = asfloat(srvLightInfoProperties.Load4(_2253)).w;
                            _9292 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).x;
                            _9293 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).y;
                            _9294 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).z;
                            _9295 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 16u)))).w;
                            _9298 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).x;
                            _9299 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).y;
                            _9300 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).z;
                            _9301 = asfloat(srvLightInfoProperties.Load4(((int)(_2253 + 32u)))).w;
                            _9304 = asfloat(srvLightInfoProperties.Load2(((int)(_2253 + 72u)))).x;
                            _9305 = asfloat(srvLightInfoProperties.Load2(((int)(_2253 + 72u)))).y;
                            _9308 = asint(srvLightInfoProperties.Load(((int)(_2253 + 80u))));
                            _9311 = asint(srvLightInfoProperties.Load(((int)(_2253 + 84u))));
                            _9314 = asint(srvLightInfoProperties.Load(((int)(_2253 + 88u))));
                            _9317 = asint(srvLightInfoProperties.Load(((int)(_2253 + 96u))));
                            _9320 = f16tof32(_9308);
                            _9322 = f16tof32(((uint)((uint)(_9311) >> 16)));
                            _9323 = f16tof32(_9311);
                            _9325 = f16tof32(((uint)((uint)(_9314) >> 16)));
                            _9329 = ((float)((uint)((uint)(((uint)(_9314) >> 8) & 255)))) * 0.003921499941498041f;
                            _9331 = (float)((uint)((uint)(_9317 & 65535)));
                            _9335 = mad(_9288, _246, mad(_9287, _245, (_9286 * _244))) + _9289;
                            _9339 = mad(_9294, _246, mad(_9293, _245, (_9292 * _244))) + _9295;
                            _9343 = mad(_9300, _246, mad(_9299, _245, (_9298 * _244))) + _9301;
                            _9346 = mad(_9288, _209, mad(_9287, _207, (_9286 * _205)));
                            _9349 = mad(_9294, _209, mad(_9293, _207, (_9292 * _205)));
                            _9352 = mad(_9300, _209, mad(_9299, _207, (_9298 * _205)));
                            _9364 = -0.0f - mad(_9300, _256, mad(_9299, _258, (_9298 * _257)));
                            _9365 = _9304 * 0.5f;
                            _9366 = _9305 * 0.5f;
                            _9367 = -0.0f - _9365;
                            _9368 = -0.0f - _9366;
                            _9369 = _9367 - _9335;
                            _9370 = _9368 - _9339;
                            _9371 = -0.0f - _9343;
                            _9372 = _9365 - _9335;
                            _9373 = _9366 - _9339;
                            _9374 = dot(float3(_9335, _9339, _9343), float3(_9346, _9349, _9352));
                            _9376 = dot(float3(_9367, _9368, 0.0f), float3(_9346, _9349, _9352)) - _9374;
                            _9378 = dot(float3(_9365, _9368, 0.0f), float3(_9346, _9349, _9352)) - _9374;
                            _9380 = dot(float3(_9365, _9366, 0.0f), float3(_9346, _9349, _9352)) - _9374;
                            _9382 = dot(float3(_9367, _9366, 0.0f), float3(_9346, _9349, _9352)) - _9374;
                            _9383 = min(_9376, _9378);
                            [branch]
                            if (!(!(_9383 >= 0.0f))) {
                              _9389 = rsqrt(dot(float3(_9372, _9370, _9371), float3(_9372, _9370, _9371)) * dot(float3(_9369, _9370, _9371), float3(_9369, _9370, _9371)));
                              _9391 = dot(float3(_9369, _9370, _9371), float3(_9372, _9370, _9371)) * _9389;
                              _9398 = rsqrt(max(((((_9391 * 0.09300000220537186f) + 0.5f) * _9391) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9389;
                              _9405 = (_9398 * (_9304 * _9371));
                              _9406 = (_9398 * (_9370 * (_9367 - _9365)));
                            } else {
                              _9405 = 0.0f;
                              _9406 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_9378, _9380) >= 0.0f))) {
                              _9413 = rsqrt(dot(float3(_9372, _9373, _9371), float3(_9372, _9373, _9371)) * dot(float3(_9372, _9370, _9371), float3(_9372, _9370, _9371)));
                              _9415 = dot(float3(_9372, _9370, _9371), float3(_9372, _9373, _9371)) * _9413;
                              _9422 = rsqrt(max(((((_9415 * 0.09300000220537186f) + 0.5f) * _9415) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9413;
                              _9430 = (_9422 * ((_9368 - _9366) * _9371));
                              _9431 = ((_9422 * (_9305 * _9372)) + _9406);
                            } else {
                              _9430 = 0.0f;
                              _9431 = _9406;
                            }
                            _9432 = min(_9380, _9382);
                            [branch]
                            if (!(!(_9432 >= 0.0f))) {
                              _9438 = rsqrt(dot(float3(_9369, _9373, _9371), float3(_9369, _9373, _9371)) * dot(float3(_9372, _9373, _9371), float3(_9372, _9373, _9371)));
                              _9440 = dot(float3(_9372, _9373, _9371), float3(_9369, _9373, _9371)) * _9438;
                              _9447 = rsqrt(max(((((_9440 * 0.09300000220537186f) + 0.5f) * _9440) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9438;
                              _9456 = ((_9447 * ((_9367 - _9365) * _9371)) + _9405);
                              _9457 = ((_9447 * (_9304 * _9373)) + _9431);
                            } else {
                              _9456 = _9405;
                              _9457 = _9431;
                            }
                            [branch]
                            if (!(!(min(_9382, _9376) >= 0.0f))) {
                              _9464 = rsqrt(dot(float3(_9369, _9370, _9371), float3(_9369, _9370, _9371)) * dot(float3(_9369, _9373, _9371), float3(_9369, _9373, _9371)));
                              _9466 = dot(float3(_9369, _9373, _9371), float3(_9369, _9370, _9371)) * _9464;
                              _9473 = rsqrt(max(((((_9466 * 0.09300000220537186f) + 0.5f) * _9466) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9464;
                              _9482 = ((_9473 * (_9305 * _9371)) + _9430);
                              _9483 = ((_9473 * (_9369 * (_9368 - _9366))) + _9457);
                            } else {
                              _9482 = _9430;
                              _9483 = _9457;
                            }
                            if (min(_9383, _9432) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_9376, _9378), max(_9380, _9382)) >= 0.0f))) {
                                _9492 = -0.0f - _9346;
                                _9493 = _9374 / _9349;
                                _9494 = _9367 / _9349;
                                _9495 = _9365 / _9349;
                                _9497 = (_9368 - _9493) / _9492;
                                _9499 = (_9366 - _9493) / _9492;
                                _9500 = min(_9494, _9495);
                                _9501 = max(_9494, _9495);
                                _9502 = min(_9497, _9499);
                                _9503 = max(_9497, _9499);
                                _9504 = max(_9500, _9502);
                                _9505 = min(_9501, _9503);
                                _9506 = _9504 * _9349;
                                _9508 = _9505 * _9349;
                                _9510 = _9506 - _9335;
                                _9511 = _9493 - _9339;
                                _9512 = _9511 + (_9504 * _9492);
                                _9513 = _9508 - _9335;
                                _9514 = _9511 + (_9505 * _9492);
                                _9515 = dot(float3(_9510, _9512, _9371), float3(_9510, _9512, _9371));
                                _9516 = dot(float3(_9513, _9514, _9371), float3(_9513, _9514, _9371));
                                _9518 = rsqrt(_9516 * _9515);
                                _9520 = dot(float3(_9510, _9512, _9371), float3(_9513, _9514, _9371)) * _9518;
                                _9527 = rsqrt(max(((((_9520 * 0.09300000220537186f) + 0.5f) * _9520) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9518;
                                _9540 = (_9500 > _9502);
                                _9542 = select(_9540, _9349, _9346);
                                _9548 = float((int)(((int)(uint)((int)(_9542 > 0.0f))) - ((int)(uint)((int)(_9542 < 0.0f)))));
                                _9552 = ((1.0f - (((float)((bool)_9540)) * 2.0f)) * _9365) * _9548;
                                _9554 = _9552 - _9335;
                                _9555 = (_9548 * _9366) - _9339;
                                _9556 = (_9501 < _9503);
                                _9558 = select(_9556, _9349, _9346);
                                _9564 = float((int)(((int)(uint)((int)(_9558 > 0.0f))) - ((int)(uint)((int)(_9558 < 0.0f)))));
                                _9565 = _9564 * _9365;
                                _9570 = _9565 - _9335;
                                _9571 = ((((((float)((bool)_9556)) * 2.0f) + -1.0f) * _9366) * _9564) - _9339;
                                _9574 = rsqrt(_9515 * dot(float3(_9554, _9555, _9371), float3(_9554, _9555, _9371)));
                                _9576 = dot(float3(_9554, _9555, _9371), float3(_9510, _9512, _9371)) * _9574;
                                _9583 = rsqrt(max(((((_9576 * 0.09300000220537186f) + 0.5f) * _9576) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9574;
                                _9596 = rsqrt(dot(float3(_9570, _9571, _9371), float3(_9570, _9571, _9371)) * _9516);
                                _9598 = dot(float3(_9513, _9514, _9371), float3(_9570, _9571, _9371)) * _9596;
                                _9605 = rsqrt(max(((((_9598 * 0.09300000220537186f) + 0.5f) * _9598) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9596;
                                _9626 = ((((_9527 * (((_9504 - _9505) * _9492) * _9371)) + _9482) + (_9583 * ((_9555 - _9512) * _9371))) + (_9605 * ((_9514 - _9571) * _9371)));
                                _9627 = ((((_9527 * ((_9349 * (_9505 - _9504)) * _9371)) + _9456) + (_9583 * ((_9506 - _9552) * _9371))) + (_9605 * ((_9565 - _9508) * _9371)));
                                _9628 = ((((_9527 * ((_9514 * _9510) - (_9513 * _9512))) + _9483) + (_9583 * ((_9554 * _9512) - (_9555 * _9510)))) + (_9605 * ((_9571 * _9513) - (_9570 * _9514))));
                              } else {
                                _9626 = _9482;
                                _9627 = _9456;
                                _9628 = _9483;
                              }
                            } else {
                              _9626 = _9482;
                              _9627 = _9456;
                              _9628 = _9483;
                            }
                            _9634 = sqrt(((_9627 * _9627) + (_9626 * _9626)) + (_9628 * _9628));
                            _9635 = _9634 * 0.15915493667125702f;
                            [branch]
                            if (!(_9635 == 0.0f)) {
                              _9644 = saturate((_9635 - _9320) / (1.0f - _9320)) * ((float)((bool)(uint)(_9343 <= 0.0f)));
                              [branch]
                              if (!(_9644 == 0.0f)) {
                                if (_9634 > 0.0f) {
                                  _9652 = (dot(float3(_9346, _9349, _9352), float3(_9626, _9627, _9628)) / _9634);
                                } else {
                                  _9652 = 0.0f;
                                }
                                _9653 = 1.0f - _233;
                                _9654 = _9653 * _9653;
                                _9660 = exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_257, _258, _256)))) * 5.0f);
                                _9665 = min(_233, 0.800000011920929f);
                                _9674 = exp2(((((((_9665 * 3.322999954223633f) + -3.7669999599456787f) * _9665) + -0.3479999899864197f) * _9665) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _9681 = _9371 / (_9364 - ((_9352 * 2.0f) * dot(float3((-0.0f - mad(_9288, _256, mad(_9287, _258, (_9286 * _257)))), (-0.0f - mad(_9294, _256, mad(_9293, _258, (_9292 * _257)))), _9364), float3(_9346, _9349, _9352))));
                                _9684 = (_9681 * 2.0f) * rsqrt(((9.999999747378752e-05f - _9674) * saturate((_233 + -0.5f) * 2.500000238418579f)) + _9674);
                                _9692 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _9331), ((log2((_9684 * _9684) * f16tof32(((uint)((uint)(_9308) >> 16)))) * 0.5f) + 5.5f));
                                _9694 = (float)((bool)(uint)(_9681 > 0.0f));
                                _9695 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _9331), 10.0f);
                                _9704 = select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_9644 * _1983), _9644);
                                if (_9329 > 0.0f) {
                                  _9722 = _9329 * _1998;
                                  _9723 = _9704 * _2301;
                                  _9743 = ((((((_9722 * _9322) * _9694) * _9692.x) * _9723) * (((max(_9654, _227) - _227) * _9660) + _227)) + _2242);
                                  _9744 = ((((((_9722 * _9323) * _9694) * _9692.y) * _9723) * (((max(_9654, _228) - _228) * _9660) + _228)) + _2243);
                                  _9745 = ((((((_9325 * _9722) * _9694) * _9692.z) * _9723) * (((max(_9654, _229) - _229) * _9660) + _229)) + _2244);
                                } else {
                                  _9743 = _2242;
                                  _9744 = _2243;
                                  _9745 = _2244;
                                }
                                _9751 = ((_2301 * 5.4256415367126465f) * _9652) * _9704;
                                _9759 = (((_9695.x * _9322) * _9751) + _2239);
                                _9760 = (((_9695.y * _9323) * _9751) + _2240);
                                _9761 = (((_9695.z * _9325) * _9751) + _2241);
                                _9762 = _9743;
                                _9763 = _9744;
                                _9764 = _9745;
                              } else {
                                _9759 = _2239;
                                _9760 = _2240;
                                _9761 = _2241;
                                _9762 = _2242;
                                _9763 = _2243;
                                _9764 = _2244;
                              }
                            } else {
                              _9759 = _2239;
                              _9760 = _2240;
                              _9761 = _2241;
                              _9762 = _2242;
                              _9763 = _2243;
                              _9764 = _2244;
                            }
                          } else {
                            _9759 = _2239;
                            _9760 = _2240;
                            _9761 = _2241;
                            _9762 = _2242;
                            _9763 = _2243;
                            _9764 = _2244;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _9759 = _2239;
              _9760 = _2240;
              _9761 = _2241;
              _9762 = _2242;
              _9763 = _2243;
              _9764 = _2244;
            }
          } else {
            _9759 = _2239;
            _9760 = _2240;
            _9761 = _2241;
            _9762 = _2242;
            _9763 = _2243;
            _9764 = _2244;
          }
          _9765 = _2245 + 1u;
          if (!(_9765 == _global_2)) {
            _2239 = _9759;
            _2240 = _9760;
            _2241 = _9761;
            _2242 = _9762;
            _2243 = _9763;
            _2244 = _9764;
            _2245 = _9765;
            continue;
          }
          _9769 = _9759;
          _9770 = _9760;
          _9771 = _9761;
          _9772 = _9762;
          _9773 = _9763;
          _9774 = _9764;
          break;
        }
      } else {
        _9769 = _2122;
        _9770 = _2123;
        _9771 = _2124;
        _9772 = _2001;
        _9773 = _2004;
        _9774 = _2007;
      }
      _9776 = rsqrt(dot(float3(_151, _152, -1.0f), float3(_151, _152, -1.0f)));
      _9782 = saturate(dot(float3(_205, _207, _209), float3((-0.0f - (_151 * _9776)), (-0.0f - (_152 * _9776)), _9776)));
      _9783 = 1.0f - _233;
      _9794 = (1.0f - _237) - (exp2(log2(1.0f - saturate(_9782)) * 5.0f) * (max((_9783 * _9783), _237) - _237));
      _9801 = (int)(uint)((int)(asint(_cbSharedPerViewData_raw_uint[93u].x) != 0));
      _9805 = srvReflectionsWeight.Load(int3(((uint)(_80) >> _9801), ((uint)(_81) >> _9801), 0));
      _9811 = ((float)((uint)((uint)(_9805.x & 254)))) * 0.003921568859368563f;
      if ((_9805.x & 1) == 0) {
        _9820 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2(((_cbSharedPerViewData_raw[43u].x) * _142), ((_cbSharedPerViewData_raw[43u].y) * _143)), 0.0f);
        _9829 = (1.0f - _9811);
        _9830 = (_9820.x * _9811);
        _9831 = (_9820.y * _9811);
        _9832 = (_9820.z * _9811);
      } else {
        _9829 = 1.0f;
        _9830 = 0.0f;
        _9831 = 0.0f;
        _9832 = 0.0f;
      }
      _9841 = (_cbSharedPerViewData_raw[43u].x) * (_142 + 0.5f);
      _9842 = (_cbSharedPerViewData_raw[43u].y) * (_143 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _9857 = (floor((_9841 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _9858 = (floor((_9842 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _9861 = max(_9857, cbDeferredShading.vScreenPixelSize.z);
        _9862 = max(_9858, cbDeferredShading.vScreenPixelSize.w);
        _9865 = min((_9857 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _9866 = min((_9858 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _9868 = srvGlobalGBuffer0.Load(int3(_80, _81, 0));
        _9874 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_9861 + cbDeferredShading.vScreenPixelSize.z), (_9862 + cbDeferredShading.vScreenPixelSize.w)));
        _9896 = 1.0f / (((_cbSharedPerViewData_raw[36u].z) * _9868.x) - (_cbSharedPerViewData_raw[36u].y));
        if ((((abs((1.0f / (((_cbSharedPerViewData_raw[36u].z) * _9874.x) - (_cbSharedPerViewData_raw[36u].y))) - _9896) > 0.029999999329447746f) || (abs((1.0f / (((_cbSharedPerViewData_raw[36u].z) * _9874.y) - (_cbSharedPerViewData_raw[36u].y))) - _9896) > 0.029999999329447746f)) || (abs((1.0f / (((_cbSharedPerViewData_raw[36u].z) * _9874.z) - (_cbSharedPerViewData_raw[36u].y))) - _9896) > 0.029999999329447746f)) || (abs((1.0f / (((_cbSharedPerViewData_raw[36u].z) * _9874.w) - (_cbSharedPerViewData_raw[36u].y))) - _9896) > 0.029999999329447746f)) {
          _9914 = abs(_9868.x - _9874.w);
          _9916 = abs(_9868.x - _9874.z);
          _9917 = (_9916 < _9914);
          _9919 = select(_9917, _9916, _9914);
          _9921 = abs(_9868.x - _9874.x);
          _9922 = (_9921 < _9919);
          if (abs(_9868.x - _9874.y) < select(_9922, _9921, _9919)) {
            _9931 = _9865;
            _9932 = _9866;
          } else {
            _9931 = select(_9922, _9861, select(_9917, _9865, _9861));
            _9932 = select(_9922, _9866, _9862);
          }
        } else {
          _9931 = _9841;
          _9932 = _9842;
        }
      } else {
        _9931 = _9841;
        _9932 = _9842;
      }
      _9935 = (asint(_cbSharedPerViewData_raw_uint[145u].w) == 0);
      if (!_9935) {
        if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 3072) == 0)) {
          _9947 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_9931, _9932), 0.0f)).x);
        } else {
          _9947 = 1.0f;
        }
      } else {
        _9947 = 1.0f;
      }
      if (!_9935) {
        _9951 = (asint(_cbSharedPerViewData_raw_uint[146u].x) != 0);
        _9952 = (int)(uint)(_9951);
        if (_9951) {
          _9956 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_9931, _9932), 0.0f);
          _9961 = (_9956.x * 2.0f) + -1.0f;
          _9962 = (_9956.y * 2.0f) + -1.0f;
          _9966 = (1.0f - abs(_9961)) - abs(_9962);
          _9968 = saturate(-0.0f - _9966);
          _9969 = -0.0f - _9968;
          _9974 = select((_9961 >= 0.0f), _9969, _9968) + _9961;
          _9975 = select((_9962 >= 0.0f), _9969, _9968) + _9962;
          _9977 = rsqrt(dot(float3(_9974, _9975, _9966), float3(_9974, _9975, _9966)));
          _9978 = _9974 * _9977;
          _9979 = _9975 * _9977;
          _9980 = _9977 * _9966;
          _9982 = rsqrt(dot(float3(_9978, _9979, _9980), float3(_9978, _9979, _9980)));
          _9987 = _9952;
          _9988 = (_9978 * _9982);
          _9989 = (_9979 * _9982);
          _9990 = (_9982 * _9980);
        } else {
          _9987 = _9952;
          _9988 = 0.0f;
          _9989 = 0.0f;
          _9990 = 0.0f;
        }
      } else {
        _9987 = 0;
        _9988 = 0.0f;
        _9989 = 0.0f;
        _9990 = 0.0f;
      }
      _9998 = srvLightDeferredRoomTiles[((int)(((int)(uint(_cbSharedPerViewData_raw[43u].z)) * _81) + _80))];
      _9999 = _9998 & 255;
      _10000 = (uint)(_9998) >> 8;
      _10001 = _10000 & 255;
      _10005 = ((float)((uint)((uint)(((uint)(_9998) >> 16) & 255)))) * 0.003921568859368563f;
      _10007 = (float)((uint)((uint)((uint)(_9998) >> 24)));
      _10008 = _10007 * 0.003921568859368563f;
      [branch]
      if (!(_248 || ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 1) == 0))) {
        _10015 = _231 * 4.0f;
        _10020 = dot(float3((-0.0f - _257), (-0.0f - _258), (-0.0f - _256)), float3(_205, _207, _209)) * 2.0f;
        _10024 = _231 * _231;
        _10025 = 1.0f - _10024;
        _10028 = (sqrt(_10025) + _10024) * _10025;
        _10038 = (_10028 * ((_206 - _257) - (_10020 * _205))) + _205;
        _10039 = (_10028 * ((_208 - _258) - (_10020 * _207))) + _207;
        _10040 = (_10028 * ((_210 - _256) - (_10020 * _209))) + _209;
        _10044 = saturate(1.0f - ((_231 + -0.30000001192092896f) * 3.3333332538604736f));
        _10059 = mad((_cbSharedPerViewData_raw[12u].z), _10040, mad((_cbSharedPerViewData_raw[12u].y), _10039, (_10038 * (_cbSharedPerViewData_raw[12u].x))));
        _10062 = mad((_cbSharedPerViewData_raw[13u].z), _10040, mad((_cbSharedPerViewData_raw[13u].y), _10039, ((_cbSharedPerViewData_raw[13u].x) * _10038)));
        _10065 = mad((_cbSharedPerViewData_raw[14u].z), _10040, mad((_cbSharedPerViewData_raw[14u].y), _10039, ((_cbSharedPerViewData_raw[14u].x) * _10038)));
        _10068 = mad((_cbSharedPerViewData_raw[12u].z), _209, mad((_cbSharedPerViewData_raw[12u].y), _207, ((_cbSharedPerViewData_raw[12u].x) * _205)));
        _10071 = mad((_cbSharedPerViewData_raw[13u].z), _209, mad((_cbSharedPerViewData_raw[13u].y), _207, ((_cbSharedPerViewData_raw[13u].x) * _205)));
        _10074 = mad((_cbSharedPerViewData_raw[14u].z), _209, mad((_cbSharedPerViewData_raw[14u].y), _207, ((_cbSharedPerViewData_raw[14u].x) * _205)));
        if (!(_global_0 == 0)) {
          _10093 = 0;
          _10094 = 0.0f;
          _10095 = 0.0f;
          _10096 = 0.0f;
          _10097 = 0.0f;
          _10098 = 0.0f;
          _10099 = 0.0f;
          _10100 = 0.0f;
          _10101 = 0.0f;
          _10102 = 0.0f;
          _10103 = 0.0f;
          _10104 = 0.0f;
          _10105 = 0.0f;
          _10106 = 0.0f;
          _10107 = 0.0f;
          while(true) {
            _10385 = _10094;
            _10386 = _10095;
            _10387 = _10096;
            _10388 = _10097;
            _10389 = _10098;
            _10390 = _10099;
            _10391 = _10100;
            _10392 = _10101;
            _10393 = _10102;
            _10394 = _10103;
            _10395 = _10104;
            _10396 = _10105;
            _10397 = _10106;
            _10398 = _10107;
            _10110 = _global_5[min((uint)(_10093), 63u)];
            _10111 = _global_6[min((uint)(_10093), 63u)];
            _10114 = asfloat(srvLightInfoProperties.Load4(_10111)).x;
            _10115 = asfloat(srvLightInfoProperties.Load4(_10111)).y;
            _10116 = asfloat(srvLightInfoProperties.Load4(_10111)).z;
            _10117 = asfloat(srvLightInfoProperties.Load4(_10111)).w;
            _10120 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 16u)))).x;
            _10121 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 16u)))).y;
            _10122 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 16u)))).z;
            _10123 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 16u)))).w;
            _10126 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 32u)))).x;
            _10127 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 32u)))).y;
            _10128 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 32u)))).z;
            _10129 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 32u)))).w;
            _10132 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 48u)))).x;
            _10133 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 48u)))).y;
            _10134 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 48u)))).z;
            _10135 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 48u)))).w;
            _10138 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 64u)))).x;
            _10139 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 64u)))).y;
            _10140 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 64u)))).z;
            _10141 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 64u)))).w;
            _10144 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 80u)))).x;
            _10145 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 80u)))).y;
            _10146 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 80u)))).z;
            _10147 = asfloat(srvLightInfoProperties.Load4(((int)(_10111 + 80u)))).w;
            _10150 = asint(srvLightInfoProperties.Load(((int)(_10111 + 96u))));
            _10153 = asfloat(srvLightInfoProperties.Load3(((int)(_10111 + 100u)))).x;
            _10154 = asfloat(srvLightInfoProperties.Load3(((int)(_10111 + 100u)))).y;
            _10155 = asfloat(srvLightInfoProperties.Load3(((int)(_10111 + 100u)))).z;
            _10158 = asfloat(srvLightInfoProperties.Load3(((int)(_10111 + 112u)))).x;
            _10159 = asfloat(srvLightInfoProperties.Load3(((int)(_10111 + 112u)))).y;
            _10160 = asfloat(srvLightInfoProperties.Load3(((int)(_10111 + 112u)))).z;
            _10163 = asint(srvLightInfoProperties.Load(((int)(_10111 + 124u))));
            _10166 = asint(srvLightInfoProperties.Load(((int)(_10111 + 128u))));
            _10169 = _10150 & 65535;
            _10198 = ((saturate(1.0f - abs(mad(_10116, _246, mad(_10115, _245, (_10114 * _244))) + _10117)) * f16tof32(((uint)((uint)(_10150) >> 16)))) * saturate(1.0f - abs(mad(_10122, _246, mad(_10121, _245, (_10120 * _244))) + _10123))) * saturate(1.0f - abs(mad(_10128, _246, mad(_10127, _245, (_10126 * _244))) + _10129));
            [branch]
            if (_10198 > 0.0f) {
              _10201 = _10198 * _10198;
              [branch]
              if (_10044 < 1.0f) {
                _10204 = (float)((uint)_10169);
                _10205 = -0.0f - _10059;
                [branch]
                if (!(_10204 >= 341.0f)) {
                  _10217 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_10205, _10062, _10065, _10204), _10015);
                  _10222 = _10217.x;
                  _10223 = _10217.y;
                  _10224 = _10217.z;
                } else {
                  _10211 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_10205, _10062, _10065, (_10204 + -341.0f)), _10015);
                  _10222 = _10211.x;
                  _10223 = _10211.y;
                  _10224 = _10211.z;
                }
              } else {
                _10222 = 0.0f;
                _10223 = 0.0f;
                _10224 = 0.0f;
              }
              _10226 = (float)((uint)_10169);
              [branch]
              if (_10044 > 0.0f) {
                _10230 = mad(_10134, _10040, mad(_10133, _10039, (_10132 * _10038)));
                _10233 = mad(_10140, _10040, mad(_10139, _10039, (_10138 * _10038)));
                _10236 = mad(_10146, _10040, mad(_10145, _10039, (_10144 * _10038)));
                _10277 = min(((((float((int)(((int)(uint)((int)(_10230 > 0.0f))) - ((int)(uint)((int)(_10230 < 0.0f))))) * _10153) - _10135) - mad(_10134, _246, mad(_10133, _245, (_10132 * _244)))) / _10230), min(((((float((int)(((int)(uint)((int)(_10233 > 0.0f))) - ((int)(uint)((int)(_10233 < 0.0f))))) * _10154) - _10141) - mad(_10140, _246, mad(_10139, _245, (_10138 * _244)))) / _10233), ((((float((int)(((int)(uint)((int)(_10236 > 0.0f))) - ((int)(uint)((int)(_10236 < 0.0f))))) * _10155) - _10147) - mad(_10146, _246, mad(_10145, _245, (_10144 * _244)))) / _10236)));
                _10282 = ((mad((_cbSharedPerViewData_raw[12u].z), _246, mad((_cbSharedPerViewData_raw[12u].y), _245, ((_cbSharedPerViewData_raw[12u].x) * _244))) + (_cbSharedPerViewData_raw[12u].w)) - _10158) + (_10277 * _10059);
                _10284 = ((mad((_cbSharedPerViewData_raw[13u].z), _246, mad((_cbSharedPerViewData_raw[13u].y), _245, ((_cbSharedPerViewData_raw[13u].x) * _244))) + (_cbSharedPerViewData_raw[13u].w)) - _10159) + (_10277 * _10062);
                _10286 = ((mad((_cbSharedPerViewData_raw[14u].z), _246, mad((_cbSharedPerViewData_raw[14u].y), _245, ((_cbSharedPerViewData_raw[14u].x) * _244))) + (_cbSharedPerViewData_raw[14u].w)) - _10160) + (_10277 * _10065);
                _10293 = (max(log2((_10277 * _10277) / dot(float3(_10282, _10284, _10286), float3(_10282, _10284, _10286))), -1.0f) * 0.3333333432674408f) + _10015;
                _10294 = -0.0f - _10282;
                [branch]
                if (!(_10226 >= 341.0f)) {
                  _10306 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_10294, _10284, _10286, _10226), _10293);
                  _10311 = _10306.x;
                  _10312 = _10306.y;
                  _10313 = _10306.z;
                } else {
                  _10300 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_10294, _10284, _10286, (_10226 + -341.0f)), _10293);
                  _10311 = _10300.x;
                  _10312 = _10300.y;
                  _10313 = _10300.z;
                }
              } else {
                _10311 = 0.0f;
                _10312 = 0.0f;
                _10313 = 0.0f;
              }
              _10314 = -0.0f - _10068;
              [branch]
              if (!(_10226 >= 341.0f)) {
                _10326 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_10314, _10071, _10074, _10226), 0.0f);
                _10331 = _10326.x;
                _10332 = _10326.y;
                _10333 = _10326.z;
              } else {
                _10320 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_10314, _10071, _10074, (_10226 + -341.0f)), 0.0f);
                _10331 = _10320.x;
                _10332 = _10320.y;
                _10333 = _10320.z;
              }
              _10343 = _10201 * f16tof32(((uint)((uint)(_10163) >> 16)));
              _10344 = _10343 * _10331;
              _10345 = _10201 * f16tof32(_10163);
              _10346 = _10345 * _10332;
              _10347 = _10201 * f16tof32(((uint)((uint)(_10166) >> 16)));
              _10348 = _10347 * _10333;
              _10349 = _10343 * (lerp(_10222, _10311, _10044));
              _10350 = _10345 * (lerp(_10223, _10312, _10044));
              _10351 = _10347 * (lerp(_10224, _10313, _10044));
              [branch]
              if (!((_10110 & ((int)(1 << (_9998 & 31)))) == 0)) {
                _10365 = (_10344 + _10094);
                _10366 = (_10346 + _10095);
                _10367 = (_10348 + _10096);
                _10368 = (_10349 + _10097);
                _10369 = (_10350 + _10098);
                _10370 = (_10351 + _10099);
                _10371 = (_10201 + _10100);
              } else {
                _10365 = _10094;
                _10366 = _10095;
                _10367 = _10096;
                _10368 = _10097;
                _10369 = _10098;
                _10370 = _10099;
                _10371 = _10100;
              }
              [branch]
              if (!((_10110 & ((int)(1 << (_10000 & 31)))) == 0)) {
                _10385 = _10365;
                _10386 = _10366;
                _10387 = _10367;
                _10388 = _10368;
                _10389 = _10369;
                _10390 = _10370;
                _10391 = _10371;
                _10392 = (_10344 + _10101);
                _10393 = (_10346 + _10102);
                _10394 = (_10348 + _10103);
                _10395 = (_10349 + _10104);
                _10396 = (_10350 + _10105);
                _10397 = (_10351 + _10106);
                _10398 = (_10201 + _10107);
              } else {
                _10385 = _10365;
                _10386 = _10366;
                _10387 = _10367;
                _10388 = _10368;
                _10389 = _10369;
                _10390 = _10370;
                _10391 = _10371;
                _10392 = _10101;
                _10393 = _10102;
                _10394 = _10103;
                _10395 = _10104;
                _10396 = _10105;
                _10397 = _10106;
                _10398 = _10107;
              }
            } else {
              _10385 = _10094;
              _10386 = _10095;
              _10387 = _10096;
              _10388 = _10097;
              _10389 = _10098;
              _10390 = _10099;
              _10391 = _10100;
              _10392 = _10101;
              _10393 = _10102;
              _10394 = _10103;
              _10395 = _10104;
              _10396 = _10105;
              _10397 = _10106;
              _10398 = _10107;
            }
            _10399 = _10093 + 1u;
            if (!(_10399 == _global_0)) {
              _10093 = _10399;
              _10094 = _10385;
              _10095 = _10386;
              _10096 = _10387;
              _10097 = _10388;
              _10098 = _10389;
              _10099 = _10390;
              _10100 = _10391;
              _10101 = _10392;
              _10102 = _10393;
              _10103 = _10394;
              _10104 = _10395;
              _10105 = _10396;
              _10106 = _10397;
              _10107 = _10398;
              continue;
            }
            _10403 = _10385;
            _10404 = _10386;
            _10405 = _10387;
            _10406 = _10388;
            _10407 = _10389;
            _10408 = _10390;
            _10409 = _10391;
            _10410 = _10392;
            _10411 = _10393;
            _10412 = _10394;
            _10413 = _10395;
            _10414 = _10396;
            _10415 = _10397;
            _10416 = _10398;
            break;
          }
        } else {
          _10403 = 0.0f;
          _10404 = 0.0f;
          _10405 = 0.0f;
          _10406 = 0.0f;
          _10407 = 0.0f;
          _10408 = 0.0f;
          _10409 = 0.0f;
          _10410 = 0.0f;
          _10411 = 0.0f;
          _10412 = 0.0f;
          _10413 = 0.0f;
          _10414 = 0.0f;
          _10415 = 0.0f;
          _10416 = 0.0f;
        }
        _10422 = ((asint(_cbSharedPerViewData_raw_uint[80u].y) & ((int)(1 << (_9998 & 31)))) != 0);
        if ((_10005 > 0.0f) || ((_10008 > 0.0f) || _10422)) {
          _10432 = srvFallbackInfo[((_9999 << 2) | 3)].x;
          _10434 = select(_10422, 9.999999747378752e-05f, (_10007 * 3.921568847431445e-09f));
          _10435 = _10409 * 0.20000000298023224f;
          _10442 = saturate((_10434 - _10435) / (((_10409 * 0.4000000059604645f) + 9.99999993922529e-09f) - _10435)) * _10434;
          [branch]
          if (_10442 > 0.0f) {
            [branch]
            if ((int)_10432 > (int)-1) {
              _10447 = float((int)(_10432));
              _10448 = -0.0f - _10059;
              _10449 = !(_10447 >= 341.0f);
              [branch]
              if (_10449) {
                _10460 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_10448, _10062, _10065, _10447), _10015);
                _10465 = _10460.x;
                _10466 = _10460.y;
                _10467 = _10460.z;
              } else {
                _10454 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_10448, _10062, _10065, (_10447 + -341.0f)), _10015);
                _10465 = _10454.x;
                _10466 = _10454.y;
                _10467 = _10454.z;
              }
              _10471 = -0.0f - _10068;
              [branch]
              if (_10449) {
                _10482 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_10471, _10071, _10074, _10447), 0.0f);
                _10487 = _10482.x;
                _10488 = _10482.y;
                _10489 = _10482.z;
              } else {
                _10476 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_10471, _10071, _10074, (_10447 + -341.0f)), 0.0f);
                _10487 = _10476.x;
                _10488 = _10476.y;
                _10489 = _10476.z;
              }
              _10500 = ((_10465 * _10442) + _10406);
              _10501 = ((_10466 * _10442) + _10407);
              _10502 = ((_10467 * _10442) + _10408);
              _10503 = ((_10487 * _10442) + _10403);
              _10504 = ((_10488 * _10442) + _10404);
              _10505 = ((_10489 * _10442) + _10405);
            } else {
              _10500 = _10406;
              _10501 = _10407;
              _10502 = _10408;
              _10503 = _10403;
              _10504 = _10404;
              _10505 = _10405;
            }
            _10508 = (_10442 + _10409);
            _10509 = _10500;
            _10510 = _10501;
            _10511 = _10502;
            _10512 = _10503;
            _10513 = _10504;
            _10514 = _10505;
          } else {
            _10508 = _10409;
            _10509 = _10406;
            _10510 = _10407;
            _10511 = _10408;
            _10512 = _10403;
            _10513 = _10404;
            _10514 = _10405;
          }
          if (_10508 > 0.0f) {
            _10520 = ((_cbSharedPerViewData_raw[61u].x) * _10005) / _10508;
            _10528 = (_10520 * _10512);
            _10529 = (_10520 * _10513);
            _10530 = (_10520 * _10514);
            _10531 = (_10520 * _10509);
            _10532 = (_10520 * _10510);
            _10533 = (_10520 * _10511);
          } else {
            _10528 = 0.0f;
            _10529 = 0.0f;
            _10530 = 0.0f;
            _10531 = 0.0f;
            _10532 = 0.0f;
            _10533 = 0.0f;
          }
        } else {
          _10528 = 0.0f;
          _10529 = 0.0f;
          _10530 = 0.0f;
          _10531 = 0.0f;
          _10532 = 0.0f;
          _10533 = 0.0f;
        }
        [branch]
        if (!(_10008 == 0.0f)) {
          _10540 = srvFallbackInfo[((_10001 << 2) | 3)].x;
          _10541 = _10007 * 3.921568847431445e-09f;
          [branch]
          if ((int)_10540 > (int)-1) {
            _10544 = float((int)(_10540));
            _10545 = -0.0f - _10059;
            _10546 = !(_10544 >= 341.0f);
            [branch]
            if (_10546) {
              _10557 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_10545, _10062, _10065, _10544), _10015);
              _10562 = _10557.x;
              _10563 = _10557.y;
              _10564 = _10557.z;
            } else {
              _10551 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_10545, _10062, _10065, (_10544 + -341.0f)), _10015);
              _10562 = _10551.x;
              _10563 = _10551.y;
              _10564 = _10551.z;
            }
            _10568 = -0.0f - _10068;
            [branch]
            if (_10546) {
              _10579 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_10568, _10071, _10074, _10544), 0.0f);
              _10584 = _10579.x;
              _10585 = _10579.y;
              _10586 = _10579.z;
            } else {
              _10573 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_10568, _10071, _10074, (_10544 + -341.0f)), 0.0f);
              _10584 = _10573.x;
              _10585 = _10573.y;
              _10586 = _10573.z;
            }
            _10597 = ((_10562 * _10541) + _10413);
            _10598 = ((_10563 * _10541) + _10414);
            _10599 = ((_10564 * _10541) + _10415);
            _10600 = ((_10584 * _10541) + _10410);
            _10601 = ((_10585 * _10541) + _10411);
            _10602 = ((_10586 * _10541) + _10412);
          } else {
            _10597 = _10413;
            _10598 = _10414;
            _10599 = _10415;
            _10600 = _10410;
            _10601 = _10411;
            _10602 = _10412;
          }
          _10607 = ((_cbSharedPerViewData_raw[61u].x) * _10008) / (_10416 + _10541);
          _10621 = ((_10607 * _10600) + _10528);
          _10622 = ((_10607 * _10601) + _10529);
          _10623 = ((_10607 * _10602) + _10530);
          _10624 = ((_10607 * _10597) + _10531);
          _10625 = ((_10607 * _10598) + _10532);
          _10626 = ((_10607 * _10599) + _10533);
        } else {
          _10621 = _10528;
          _10622 = _10529;
          _10623 = _10530;
          _10624 = _10531;
          _10625 = _10532;
          _10626 = _10533;
        }
      } else {
        _10621 = 0.0f;
        _10622 = 0.0f;
        _10623 = 0.0f;
        _10624 = 0.0f;
        _10625 = 0.0f;
        _10626 = 0.0f;
      }
      [branch]
      if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 16384) == 0)) {
        if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2) == 0)) {
          _10653 = mad((_cbSharedPerViewData_raw[12u].z), _246, mad((_cbSharedPerViewData_raw[12u].y), _245, ((_cbSharedPerViewData_raw[12u].x) * _244))) + (_cbSharedPerViewData_raw[12u].w);
          _10657 = mad((_cbSharedPerViewData_raw[13u].z), _246, mad((_cbSharedPerViewData_raw[13u].y), _245, ((_cbSharedPerViewData_raw[13u].x) * _244))) + (_cbSharedPerViewData_raw[13u].w);
          _10661 = mad((_cbSharedPerViewData_raw[14u].z), _246, mad((_cbSharedPerViewData_raw[14u].y), _245, ((_cbSharedPerViewData_raw[14u].x) * _244))) + (_cbSharedPerViewData_raw[14u].w);
          _10664 = mad((_cbSharedPerViewData_raw[12u].z), _209, mad((_cbSharedPerViewData_raw[12u].y), _207, ((_cbSharedPerViewData_raw[12u].x) * _205)));
          _10667 = mad((_cbSharedPerViewData_raw[13u].z), _209, mad((_cbSharedPerViewData_raw[13u].y), _207, ((_cbSharedPerViewData_raw[13u].x) * _205)));
          _10670 = mad((_cbSharedPerViewData_raw[14u].z), _209, mad((_cbSharedPerViewData_raw[14u].y), _207, ((_cbSharedPerViewData_raw[14u].x) * _205)));
          _10675 = asint(_cbSharedPerViewData_raw_uint[((uint)(((uint)((int)min((uint)(((uint)(_9999) >> 2)), (uint)(7)))) + 110u))]);
          _47[0] = _10675.x;
          _47[1] = _10675.y;
          _47[2] = _10675.z;
          _47[3] = _10675.w;
          _10690 = asint(_cbSharedPerViewData_raw_uint[((uint)(((uint)((int)min((uint)(((uint)(_10001) >> 2)), (uint)(7)))) + 110u))]);
          _46[0] = _10690.x;
          _46[1] = _10690.y;
          _46[2] = _10690.z;
          _46[3] = _10690.w;
          if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 8) == 0)) {
            _10705 = 0.0f;
            _10706 = 0.0f;
            _10707 = 0.0f;
            _10708 = 1.0f;
            _10709 = 0;
            while(true) {
              _11511 = _10705;
              _11512 = _10706;
              _11513 = _10707;
              _11514 = _10708;
              if (((asint(_cbSharedPerViewData_raw_uint[141u].x) & 65536) == 0) || (_10709 == asint(_cbSharedPerViewData_raw_uint[141u].y))) {
                _10719 = _cbSharedPerViewData_raw[((int)(_10709 + 120))];
                _10724 = _cbSharedPerViewData_raw[((int)(_10709 + 124))];
                _10729 = _cbSharedPerViewData_raw[((int)(_10709 + 128))];
                _10756 = min(min(saturate(_10729.x * (_10653 - _10719.x)), min(saturate(_10729.y * (_10657 - _10719.y)), saturate(_10729.z * (_10661 - _10719.z)))), min(saturate((_10724.x - _10653) * _10729.x), min(saturate((_10724.y - _10657) * _10729.y), saturate((_10724.z - _10661) * _10729.z)))) * _10708;
                [branch]
                if (_10756 > 0.0f) {
                  if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1) == 0)) {
                    _49[0] = (_cbSharedPerViewData_raw[119u].x);
                    _49[1] = (_cbSharedPerViewData_raw[119u].y);
                    _49[2] = (_cbSharedPerViewData_raw[119u].z);
                    _49[3] = (_cbSharedPerViewData_raw[119u].w);
                    _10777 = _49[min((uint)(_10709), 3u)];
                    _10785 = ((((_cbSharedPerViewData_raw[140u].y) * _10664) * _10777) + _10653);
                    _10786 = ((((_cbSharedPerViewData_raw[140u].y) * _10667) * _10777) + _10657);
                    _10787 = ((((_cbSharedPerViewData_raw[140u].y) * _10670) * _10777) + _10661);
                  } else {
                    _10785 = _10653;
                    _10786 = _10657;
                    _10787 = _10661;
                  }
                  _48[0] = (_cbSharedPerViewData_raw[134u].x);
                  _48[1] = (_cbSharedPerViewData_raw[134u].y);
                  _48[2] = (_cbSharedPerViewData_raw[134u].z);
                  _48[3] = (_cbSharedPerViewData_raw[134u].w);
                  _10798 = _48[min((uint)(_10709), 3u)];
                  _10802 = _10709 + 136;
                  _10803 = _cbSharedPerViewData_raw[_10802];
                  _10807 = _10803.x + (_10798 * _10785);
                  _10808 = _10803.y + (_10798 * _10786);
                  _10809 = _10803.z + (_10798 * _10787);
                  _10822 = 0.0f;
                  _10823 = 0.0f;
                  _10824 = 0.0f;
                  _10825 = 0.0f;
                  _10826 = 0;
                  _10827 = 0;
                  while(true) {
                    _11466 = _10826;
                    _10828 = _10827 & 1;
                    _10830 = ((uint)(_10827) >> 1) & 1;
                    _10832 = ((uint)(_10827) >> 2) & 1;
                    _10836 = _10828 + uint(floor(_10807));
                    _10837 = _10830 + uint(floor(_10808));
                    _10838 = _10832 + uint(floor(_10809));
                    _10846 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[118u].x)) + (uint)(-1))) & _10836;
                    _10847 = _10837 & ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[118u].y)) + (uint)(-1)));
                    _10850 = ((uint)(_10838 & ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[118u].z)) + (uint)(-1))))) + (asint(_cbSharedPerViewData_raw_uint[118u].z) * _10709);
                    _10856 = uint(((((float4)(srvGIProbeClipMapRoomIDs.Load(int4(_10846, _10847, _10850, 0)))).x) * 65535.0f) + 0.5f);
                    _10867 = select((((((uint)(srvGIProbeClipMapFlags.Load(int4(_10846, _10847, _10850, 0)))).x) & 1) != 0), 1.0f, 0.0f) * select((_10856 == (_47[min((uint)((_9998 & 3)), 3u)])), _10005, select((_10856 == (_46[min((uint)((_10000 & 3)), 3u)])), _10008, 0.0f));
                    if (!(_10867 == 0.0f)) {
                      _10873 = _cbSharedPerViewData_raw[_10802];
                      _50[0] = (_cbSharedPerViewData_raw[135u].x);
                      _50[1] = (_cbSharedPerViewData_raw[135u].y);
                      _50[2] = (_cbSharedPerViewData_raw[135u].z);
                      _50[3] = (_cbSharedPerViewData_raw[135u].w);
                      _10890 = _50[min((uint)(_10709), 3u)];
                      _51[0] = (_cbSharedPerViewData_raw[119u].x);
                      _51[1] = (_cbSharedPerViewData_raw[119u].y);
                      _51[2] = (_cbSharedPerViewData_raw[119u].z);
                      _51[3] = (_cbSharedPerViewData_raw[119u].w);
                      _10904 = _51[min((uint)(_10709), 3u)];
                      _10906 = srvGIProbeBakeOffsets.Load(int4(_10846, _10847, _10850, 0));
                      _10916 = ((_10906.x + -0.5f) * _10904) + ((((float)((uint)_10836)) - _10873.x) * _10890);
                      _10917 = ((_10906.y + -0.5f) * _10904) + ((((float)((uint)_10837)) - _10873.y) * _10890);
                      _10918 = ((_10906.z + -0.5f) * _10904) + ((((float)((uint)_10838)) - _10873.z) * _10890);
                      _10923 = (float)((uint)_10846);
                      _10924 = (float)((uint)_10847);
                      if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1) == 0) {
                        _11124 = 1.0f;
                        _11129 = (abs(_10667) + abs(_10664)) + abs(_10670);
                        _11130 = _10664 / _11129;
                        _11131 = _10667 / _11129;
                        if (!((_10670 / _11129) >= 0.0f)) {
                          _11146 = ((1.0f - abs(_11131)) * select((_11130 >= 0.0f), 1.0f, -1.0f));
                          _11147 = ((1.0f - abs(_11130)) * select((_11131 >= 0.0f), 1.0f, -1.0f));
                        } else {
                          _11146 = _11130;
                          _11147 = _11131;
                        }
                        _11152 = saturate((_11146 * 0.5f) + 0.5f);
                        _11153 = saturate((_11147 * 0.5f) + 0.5f);
                        _11154 = asint(_cbSharedPerViewData_raw_uint[141u].x) & 2;
                        _11155 = (_11154 != 0);
                        _11162 = _10923 * 8.0f;
                        _11163 = _10924 * 8.0f;
                        _11164 = select(_11155, _11152, ((_11152 * 0.75f) + 0.125f)) * 8.0f;
                        _11165 = select(_11155, _11153, ((_11153 * 0.75f) + 0.125f)) * 8.0f;
                        _11170 = int(floor(_11164 + 0.5f));
                        _11171 = int(floor(_11165 + 0.5f));
                        _11172 = _11170 + (uint)(-1);
                        _11173 = _11171 + (uint)(-1);
                        if (!(_11154 == 0)) {
                          _11180 = ((((int)(uint)((int)((uint)_11172 > (uint)7))) | ((uint)(_11172) >> 31)) == 0);
                          _11185 = ((((int)(uint)((int)((uint)_11173 > (uint)7))) | ((uint)(_11173) >> 31)) == 0);
                          _11186 = 8u - _11170;
                          _11188 = 8u - _11171;
                          _11198 = ((((int)(uint)((int)((uint)_11170 > (uint)7))) | ((uint)(_11170) >> 31)) == 0);
                          _11199 = 7u - _11170;
                          _11210 = ((((int)(uint)((int)((uint)_11171 > (uint)7))) | ((uint)(_11171) >> 31)) == 0);
                          _11212 = 7u - _11171;
                          _11225 = min((int)(max((int)(select(_11210, _11170, _11199)), (int)(0))), (int)(7));
                          _11226 = min((int)(max((int)(select(_11210, _11172, _11186)), (int)(0))), (int)(7));
                          _11227 = min((int)(max((int)(select(_11185, _11170, _11199)), (int)(0))), (int)(7));
                          _11228 = min((int)(max((int)(select(_11185, _11172, _11186)), (int)(0))), (int)(7));
                          _11229 = min((int)(max((int)(select(_11198, _11171, _11212)), (int)(0))), (int)(7));
                          _11230 = min((int)(max((int)(select(_11180, _11171, _11212)), (int)(0))), (int)(7));
                          _11231 = min((int)(max((int)(select(_11198, _11173, _11188)), (int)(0))), (int)(7));
                          _11232 = min((int)(max((int)(select(_11180, _11173, _11188)), (int)(0))), (int)(7));
                        } else {
                          _11225 = _11170;
                          _11226 = _11172;
                          _11227 = _11170;
                          _11228 = _11172;
                          _11229 = _11171;
                          _11230 = _11171;
                          _11231 = _11173;
                          _11232 = _11173;
                        }
                        _11240 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11228)) + _11162), int(float((int)(_11232)) + _11163), _10850, 0));
                        _11250 = ((float)((uint)((uint)(_11240.x & 511)))) * 0.001956947147846222f;
                        _11251 = ((float)((uint)((uint)(((uint)((uint)(_11240.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _11252 = ((float)((uint)((uint)(((uint)((uint)(_11240.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _11256 = exp2(float((int)(((uint)((uint)(_11240.x)) >> 27) + -15)));
                        _11258 = (_11250 * _11250) * _11256;
                        _11260 = (_11251 * _11251) * _11256;
                        _11262 = (_11252 * _11252) * _11256;
                        _11269 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11227)) + _11162), int(float((int)(_11231)) + _11163), _10850, 0));
                        _11279 = ((float)((uint)((uint)(_11269.x & 511)))) * 0.001956947147846222f;
                        _11280 = ((float)((uint)((uint)(((uint)((uint)(_11269.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _11281 = ((float)((uint)((uint)(((uint)((uint)(_11269.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _11285 = exp2(float((int)(((uint)((uint)(_11269.x)) >> 27) + -15)));
                        _11287 = (_11279 * _11279) * _11285;
                        _11289 = (_11280 * _11280) * _11285;
                        _11291 = (_11281 * _11281) * _11285;
                        _11298 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11226)) + _11162), int(float((int)(_11230)) + _11163), _10850, 0));
                        _11308 = ((float)((uint)((uint)(_11298.x & 511)))) * 0.001956947147846222f;
                        _11309 = ((float)((uint)((uint)(((uint)((uint)(_11298.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _11310 = ((float)((uint)((uint)(((uint)((uint)(_11298.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _11314 = exp2(float((int)(((uint)((uint)(_11298.x)) >> 27) + -15)));
                        _11316 = (_11308 * _11308) * _11314;
                        _11318 = (_11309 * _11309) * _11314;
                        _11320 = (_11310 * _11310) * _11314;
                        _11327 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11225)) + _11162), int(float((int)(_11229)) + _11163), _10850, 0));
                        _11337 = ((float)((uint)((uint)(_11327.x & 511)))) * 0.001956947147846222f;
                        _11338 = ((float)((uint)((uint)(((uint)((uint)(_11327.x)) >> 9) & 511)))) * 0.001956947147846222f;
                        _11339 = ((float)((uint)((uint)(((uint)((uint)(_11327.x)) >> 18) & 511)))) * 0.001956947147846222f;
                        _11343 = exp2(float((int)(((uint)((uint)(_11327.x)) >> 27) + -15)));
                        _11345 = (_11337 * _11337) * _11343;
                        _11347 = (_11338 * _11338) * _11343;
                        _11349 = (_11339 * _11339) * _11343;
                        if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 256) == 0) {
                          _11368 = frac(_11164 + -0.5f);
                          _11369 = frac(_11165 + -0.5f);
                          _11376 = (_11368 * (_11287 - _11258)) + _11258;
                          _11377 = (_11368 * (_11289 - _11260)) + _11260;
                          _11378 = (_11368 * (_11291 - _11262)) + _11262;
                          _11398 = (((((_11368 * (_11345 - _11316)) + _11316) - _11376) * _11369) + _11376);
                          _11399 = (((((_11368 * (_11347 - _11318)) + _11318) - _11377) * _11369) + _11377);
                          _11400 = (((((_11368 * (_11349 - _11320)) + _11320) - _11378) * _11369) + _11378);
                        } else {
                          _11398 = ((((_11287 + _11258) + _11316) + _11345) * 0.25f);
                          _11399 = ((((_11289 + _11260) + _11318) + _11347) * 0.25f);
                          _11400 = ((((_11291 + _11262) + _11320) + _11349) * 0.25f);
                        }
                        _11403 = (_cbSharedPerViewData_raw[61u].x) * _11398;
                        _11404 = (_cbSharedPerViewData_raw[61u].x) * _11399;
                        _11405 = (_cbSharedPerViewData_raw[61u].x) * _11400;
                        _11416 = (((1.0f - frac(_10808)) - ((float)((uint)_10830))) * ((1.0f - frac(_10807)) - ((float)((uint)_10828)))) * ((1.0f - frac(_10809)) - ((float)((uint)_10832)));
                        _11424 = (_11124 * _10867) * select(((mad(_10832, _10832, mad(_10830, _10830, _10828)) & 1) != 0), (-0.0f - _11416), _11416);
                        if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 512) == 0)) {
                          _11428 = _10916 - _10785;
                          _11429 = _10917 - _10786;
                          _11430 = _10918 - _10787;
                          _11432 = rsqrt(dot(float3(_11428, _11429, _11430), float3(_11428, _11429, _11430)));
                          _11442 = (saturate((dot(float3((_11432 * _11428), (_11432 * _11429), (_11432 * _11430)), float3(_10664, _10667, _10670)) * 0.5f) + 0.5f) * _11424);
                        } else {
                          _11442 = _11424;
                        }
                        if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0)) {
                          _11450 = sqrt(_11403);
                          _11451 = sqrt(_11404);
                          _11452 = sqrt(_11405);
                        } else {
                          _11450 = _11403;
                          _11451 = _11404;
                          _11452 = _11405;
                        }
                        _11462 = ((_11450 * _11442) + _10822);
                        _11463 = ((_11451 * _11442) + _10823);
                        _11464 = ((_11452 * _11442) + _10824);
                        _11465 = (_11442 + _10825);
                        _11466 = ((int)(_10826 + 1u));
                      } else {
                        _10926 = _10785 - _10916;
                        _10927 = _10786 - _10917;
                        _10928 = _10787 - _10918;
                        _10930 = rsqrt(dot(float3(_10926, _10927, _10928), float3(_10926, _10927, _10928)));
                        _10931 = _10930 * _10926;
                        _10932 = _10930 * _10927;
                        _10933 = _10930 * _10928;
                        _10938 = (abs(_10932) + abs(_10931)) + abs(_10933);
                        _10939 = _10931 / _10938;
                        _10940 = _10932 / _10938;
                        if (!((_10933 / _10938) >= 0.0f)) {
                          _10955 = ((1.0f - abs(_10940)) * select((_10939 >= 0.0f), 1.0f, -1.0f));
                          _10956 = ((1.0f - abs(_10939)) * select((_10940 >= 0.0f), 1.0f, -1.0f));
                        } else {
                          _10955 = _10939;
                          _10956 = _10940;
                        }
                        _10961 = saturate((_10955 * 0.5f) + 0.5f);
                        _10962 = saturate((_10956 * 0.5f) + 0.5f);
                        _10963 = asint(_cbSharedPerViewData_raw_uint[141u].x) & 2;
                        _10964 = (_10963 != 0);
                        _10971 = _10923 * 8.0f;
                        _10972 = _10924 * 8.0f;
                        _10973 = select(_10964, _10961, ((_10961 * 0.75f) + 0.125f)) * 8.0f;
                        _10974 = select(_10964, _10962, ((_10962 * 0.75f) + 0.125f)) * 8.0f;
                        _10979 = int(floor(_10973 + 0.5f));
                        _10980 = int(floor(_10974 + 0.5f));
                        _10981 = _10979 + (uint)(-1);
                        _10982 = _10980 + (uint)(-1);
                        if (!(_10963 == 0)) {
                          _10989 = ((((int)(uint)((int)((uint)_10981 > (uint)7))) | ((uint)(_10981) >> 31)) == 0);
                          _10994 = ((((int)(uint)((int)((uint)_10982 > (uint)7))) | ((uint)(_10982) >> 31)) == 0);
                          _10995 = 8u - _10979;
                          _10997 = 8u - _10980;
                          _11007 = ((((int)(uint)((int)((uint)_10979 > (uint)7))) | ((uint)(_10979) >> 31)) == 0);
                          _11008 = 7u - _10979;
                          _11019 = ((((int)(uint)((int)((uint)_10980 > (uint)7))) | ((uint)(_10980) >> 31)) == 0);
                          _11021 = 7u - _10980;
                          _11034 = min((int)(max((int)(select(_11019, _10979, _11008)), (int)(0))), (int)(7));
                          _11035 = min((int)(max((int)(select(_11019, _10981, _10995)), (int)(0))), (int)(7));
                          _11036 = min((int)(max((int)(select(_10994, _10979, _11008)), (int)(0))), (int)(7));
                          _11037 = min((int)(max((int)(select(_10994, _10981, _10995)), (int)(0))), (int)(7));
                          _11038 = min((int)(max((int)(select(_11007, _10980, _11021)), (int)(0))), (int)(7));
                          _11039 = min((int)(max((int)(select(_10989, _10980, _11021)), (int)(0))), (int)(7));
                          _11040 = min((int)(max((int)(select(_11007, _10982, _10997)), (int)(0))), (int)(7));
                          _11041 = min((int)(max((int)(select(_10989, _10982, _10997)), (int)(0))), (int)(7));
                        } else {
                          _11034 = _10979;
                          _11035 = _10981;
                          _11036 = _10979;
                          _11037 = _10981;
                          _11038 = _10980;
                          _11039 = _10980;
                          _11040 = _10982;
                          _11041 = _10982;
                        }
                        _11049 = srvGIProbeDepthOct.Load(int4(int(float((int)(_11037)) + _10971), int(float((int)(_11041)) + _10972), _10850, 0));
                        _11057 = srvGIProbeDepthOct.Load(int4(int(float((int)(_11036)) + _10971), int(float((int)(_11040)) + _10972), _10850, 0));
                        _11065 = srvGIProbeDepthOct.Load(int4(int(float((int)(_11035)) + _10971), int(float((int)(_11039)) + _10972), _10850, 0));
                        _11073 = srvGIProbeDepthOct.Load(int4(int(float((int)(_11034)) + _10971), int(float((int)(_11038)) + _10972), _10850, 0));
                        if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 256) == 0) {
                          _11085 = frac(_10973 + -0.5f);
                          _11089 = (_11085 * (_11057.x - _11049.x)) + _11049.x;
                          _11097 = (((((_11085 * (_11073.x - _11065.x)) + _11065.x) - _11089) * frac(_10974 + -0.5f)) + _11089);
                        } else {
                          _11097 = ((((_11057.x + _11049.x) + _11065.x) + _11073.x) * 0.25f);
                        }
                        _11099 = (_10904 * 1.7319999933242798f) * _11097;
                        _11100 = _10916 - _10785;
                        _11101 = _10917 - _10786;
                        _11102 = _10918 - _10787;
                        _11111 = (_cbSharedPerViewData_raw[140u].z) * _10904;
                        _11114 = sqrt(((_11100 * _11100) + (_11101 * _11101)) + (_11102 * _11102)) - ((_cbSharedPerViewData_raw[140u].x) * _10904);
                        if (!(_11099 < (_11114 - _11111))) {
                          _11121 = 1.0f - saturate((_11114 - _11099) / _11111);
                          if (!(_11121 == 0.0f)) {
                            _11124 = _11121;
                            _11129 = (abs(_10667) + abs(_10664)) + abs(_10670);
                            _11130 = _10664 / _11129;
                            _11131 = _10667 / _11129;
                            if (!((_10670 / _11129) >= 0.0f)) {
                              _11146 = ((1.0f - abs(_11131)) * select((_11130 >= 0.0f), 1.0f, -1.0f));
                              _11147 = ((1.0f - abs(_11130)) * select((_11131 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _11146 = _11130;
                              _11147 = _11131;
                            }
                            _11152 = saturate((_11146 * 0.5f) + 0.5f);
                            _11153 = saturate((_11147 * 0.5f) + 0.5f);
                            _11154 = asint(_cbSharedPerViewData_raw_uint[141u].x) & 2;
                            _11155 = (_11154 != 0);
                            _11162 = _10923 * 8.0f;
                            _11163 = _10924 * 8.0f;
                            _11164 = select(_11155, _11152, ((_11152 * 0.75f) + 0.125f)) * 8.0f;
                            _11165 = select(_11155, _11153, ((_11153 * 0.75f) + 0.125f)) * 8.0f;
                            _11170 = int(floor(_11164 + 0.5f));
                            _11171 = int(floor(_11165 + 0.5f));
                            _11172 = _11170 + (uint)(-1);
                            _11173 = _11171 + (uint)(-1);
                            if (!(_11154 == 0)) {
                              _11180 = ((((int)(uint)((int)((uint)_11172 > (uint)7))) | ((uint)(_11172) >> 31)) == 0);
                              _11185 = ((((int)(uint)((int)((uint)_11173 > (uint)7))) | ((uint)(_11173) >> 31)) == 0);
                              _11186 = 8u - _11170;
                              _11188 = 8u - _11171;
                              _11198 = ((((int)(uint)((int)((uint)_11170 > (uint)7))) | ((uint)(_11170) >> 31)) == 0);
                              _11199 = 7u - _11170;
                              _11210 = ((((int)(uint)((int)((uint)_11171 > (uint)7))) | ((uint)(_11171) >> 31)) == 0);
                              _11212 = 7u - _11171;
                              _11225 = min((int)(max((int)(select(_11210, _11170, _11199)), (int)(0))), (int)(7));
                              _11226 = min((int)(max((int)(select(_11210, _11172, _11186)), (int)(0))), (int)(7));
                              _11227 = min((int)(max((int)(select(_11185, _11170, _11199)), (int)(0))), (int)(7));
                              _11228 = min((int)(max((int)(select(_11185, _11172, _11186)), (int)(0))), (int)(7));
                              _11229 = min((int)(max((int)(select(_11198, _11171, _11212)), (int)(0))), (int)(7));
                              _11230 = min((int)(max((int)(select(_11180, _11171, _11212)), (int)(0))), (int)(7));
                              _11231 = min((int)(max((int)(select(_11198, _11173, _11188)), (int)(0))), (int)(7));
                              _11232 = min((int)(max((int)(select(_11180, _11173, _11188)), (int)(0))), (int)(7));
                            } else {
                              _11225 = _11170;
                              _11226 = _11172;
                              _11227 = _11170;
                              _11228 = _11172;
                              _11229 = _11171;
                              _11230 = _11171;
                              _11231 = _11173;
                              _11232 = _11173;
                            }
                            _11240 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11228)) + _11162), int(float((int)(_11232)) + _11163), _10850, 0));
                            _11250 = ((float)((uint)((uint)(_11240.x & 511)))) * 0.001956947147846222f;
                            _11251 = ((float)((uint)((uint)(((uint)((uint)(_11240.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _11252 = ((float)((uint)((uint)(((uint)((uint)(_11240.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _11256 = exp2(float((int)(((uint)((uint)(_11240.x)) >> 27) + -15)));
                            _11258 = (_11250 * _11250) * _11256;
                            _11260 = (_11251 * _11251) * _11256;
                            _11262 = (_11252 * _11252) * _11256;
                            _11269 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11227)) + _11162), int(float((int)(_11231)) + _11163), _10850, 0));
                            _11279 = ((float)((uint)((uint)(_11269.x & 511)))) * 0.001956947147846222f;
                            _11280 = ((float)((uint)((uint)(((uint)((uint)(_11269.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _11281 = ((float)((uint)((uint)(((uint)((uint)(_11269.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _11285 = exp2(float((int)(((uint)((uint)(_11269.x)) >> 27) + -15)));
                            _11287 = (_11279 * _11279) * _11285;
                            _11289 = (_11280 * _11280) * _11285;
                            _11291 = (_11281 * _11281) * _11285;
                            _11298 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11226)) + _11162), int(float((int)(_11230)) + _11163), _10850, 0));
                            _11308 = ((float)((uint)((uint)(_11298.x & 511)))) * 0.001956947147846222f;
                            _11309 = ((float)((uint)((uint)(((uint)((uint)(_11298.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _11310 = ((float)((uint)((uint)(((uint)((uint)(_11298.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _11314 = exp2(float((int)(((uint)((uint)(_11298.x)) >> 27) + -15)));
                            _11316 = (_11308 * _11308) * _11314;
                            _11318 = (_11309 * _11309) * _11314;
                            _11320 = (_11310 * _11310) * _11314;
                            _11327 = srvGIProbeIrradianceOct.Load(int4(int(float((int)(_11225)) + _11162), int(float((int)(_11229)) + _11163), _10850, 0));
                            _11337 = ((float)((uint)((uint)(_11327.x & 511)))) * 0.001956947147846222f;
                            _11338 = ((float)((uint)((uint)(((uint)((uint)(_11327.x)) >> 9) & 511)))) * 0.001956947147846222f;
                            _11339 = ((float)((uint)((uint)(((uint)((uint)(_11327.x)) >> 18) & 511)))) * 0.001956947147846222f;
                            _11343 = exp2(float((int)(((uint)((uint)(_11327.x)) >> 27) + -15)));
                            _11345 = (_11337 * _11337) * _11343;
                            _11347 = (_11338 * _11338) * _11343;
                            _11349 = (_11339 * _11339) * _11343;
                            if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 256) == 0) {
                              _11368 = frac(_11164 + -0.5f);
                              _11369 = frac(_11165 + -0.5f);
                              _11376 = (_11368 * (_11287 - _11258)) + _11258;
                              _11377 = (_11368 * (_11289 - _11260)) + _11260;
                              _11378 = (_11368 * (_11291 - _11262)) + _11262;
                              _11398 = (((((_11368 * (_11345 - _11316)) + _11316) - _11376) * _11369) + _11376);
                              _11399 = (((((_11368 * (_11347 - _11318)) + _11318) - _11377) * _11369) + _11377);
                              _11400 = (((((_11368 * (_11349 - _11320)) + _11320) - _11378) * _11369) + _11378);
                            } else {
                              _11398 = ((((_11287 + _11258) + _11316) + _11345) * 0.25f);
                              _11399 = ((((_11289 + _11260) + _11318) + _11347) * 0.25f);
                              _11400 = ((((_11291 + _11262) + _11320) + _11349) * 0.25f);
                            }
                            _11403 = (_cbSharedPerViewData_raw[61u].x) * _11398;
                            _11404 = (_cbSharedPerViewData_raw[61u].x) * _11399;
                            _11405 = (_cbSharedPerViewData_raw[61u].x) * _11400;
                            _11416 = (((1.0f - frac(_10808)) - ((float)((uint)_10830))) * ((1.0f - frac(_10807)) - ((float)((uint)_10828)))) * ((1.0f - frac(_10809)) - ((float)((uint)_10832)));
                            _11424 = (_11124 * _10867) * select(((mad(_10832, _10832, mad(_10830, _10830, _10828)) & 1) != 0), (-0.0f - _11416), _11416);
                            if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 512) == 0)) {
                              _11428 = _10916 - _10785;
                              _11429 = _10917 - _10786;
                              _11430 = _10918 - _10787;
                              _11432 = rsqrt(dot(float3(_11428, _11429, _11430), float3(_11428, _11429, _11430)));
                              _11442 = (saturate((dot(float3((_11432 * _11428), (_11432 * _11429), (_11432 * _11430)), float3(_10664, _10667, _10670)) * 0.5f) + 0.5f) * _11424);
                            } else {
                              _11442 = _11424;
                            }
                            if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0)) {
                              _11450 = sqrt(_11403);
                              _11451 = sqrt(_11404);
                              _11452 = sqrt(_11405);
                            } else {
                              _11450 = _11403;
                              _11451 = _11404;
                              _11452 = _11405;
                            }
                            _11462 = ((_11450 * _11442) + _10822);
                            _11463 = ((_11451 * _11442) + _10823);
                            _11464 = ((_11452 * _11442) + _10824);
                            _11465 = (_11442 + _10825);
                            _11466 = ((int)(_10826 + 1u));
                          } else {
                            _11462 = _10822;
                            _11463 = _10823;
                            _11464 = _10824;
                            _11465 = _10825;
                            _11466 = _10826;
                          }
                        } else {
                          _11462 = _10822;
                          _11463 = _10823;
                          _11464 = _10824;
                          _11465 = _10825;
                          _11466 = _10826;
                        }
                      }
                    } else {
                      _11462 = _10822;
                      _11463 = _10823;
                      _11464 = _10824;
                      _11465 = _10825;
                      _11466 = _10826;
                    }
                    _11467 = _10827 + 1;
                    if (!(_11467 == 8)) {
                      _10822 = _11462;
                      _10823 = _11463;
                      _10824 = _11464;
                      _10825 = _11465;
                      _10826 = _11466;
                      _10827 = _11467;
                      continue;
                    }
                    while(true) {
                      if (!((asint(_cbSharedPerViewData_raw_uint[141u].x) & 131072) == 0)) {
                        if (!(_11466 == 0)) {
                          if (!(_11466 == 1)) {
                            if (!(_11466 == 2)) {
                              if (!(_11466 == 3)) {
                                _11478 = _11462 / _11465;
                                _11479 = _11463 / _11465;
                                _11480 = _11464 / _11465;
                                _11483 = (_11465 > 0.0f);
                                if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0) {
                                  if (!_11483) {
                                    _11492 = 0.0f;
                                    _11493 = 0.0f;
                                    _11494 = 0.0f;
                                  } else {
                                    _11492 = _11478;
                                    _11493 = _11479;
                                    _11494 = _11480;
                                  }
                                } else {
                                  if (_11483) {
                                    _11492 = (_11478 * _11478);
                                    _11493 = (_11479 * _11479);
                                    _11494 = (_11480 * _11480);
                                  } else {
                                    _11492 = 0.0f;
                                    _11493 = 0.0f;
                                    _11494 = 0.0f;
                                  }
                                }
                              } else {
                                _11492 = 0.0f;
                                _11493 = 1.0f;
                                _11494 = 1.0f;
                              }
                            } else {
                              _11492 = 0.0f;
                              _11493 = 0.0f;
                              _11494 = 1.0f;
                            }
                          } else {
                            _11492 = 1.0f;
                            _11493 = 0.0f;
                            _11494 = 1.0f;
                          }
                        } else {
                          _11492 = 1.0f;
                          _11493 = 0.0f;
                          _11494 = 0.0f;
                        }
                      } else {
                        _11478 = _11462 / _11465;
                        _11479 = _11463 / _11465;
                        _11480 = _11464 / _11465;
                        _11483 = (_11465 > 0.0f);
                        if ((asint(_cbSharedPerViewData_raw_uint[141u].x) & 1024) == 0) {
                          if (!_11483) {
                            _11492 = 0.0f;
                            _11493 = 0.0f;
                            _11494 = 0.0f;
                          } else {
                            _11492 = _11478;
                            _11493 = _11479;
                            _11494 = _11480;
                          }
                        } else {
                          if (_11483) {
                            _11492 = (_11478 * _11478);
                            _11493 = (_11479 * _11479);
                            _11494 = (_11480 * _11480);
                          } else {
                            _11492 = 0.0f;
                            _11493 = 0.0f;
                            _11494 = 0.0f;
                          }
                        }
                      }
                      _11502 = ((_11492 * _10756) + _10705);
                      _11503 = ((_11493 * _10756) + _10706);
                      _11504 = ((_11494 * _10756) + _10707);
                      break;
                    }
                    break;
                  }
                } else {
                  _11502 = _10705;
                  _11503 = _10706;
                  _11504 = _10707;
                }
                if (!(_10708 < 1.0f)) {
                  _11508 = saturate(_10708 - _10756);
                  [branch]
                  if (!(_11508 == 0.0f)) {
                    _11511 = _11502;
                    _11512 = _11503;
                    _11513 = _11504;
                    _11514 = _11508;
                    _11515 = _10709 + 1;
                    if ((uint)_11515 < (uint)3) {
                      _10705 = _11511;
                      _10706 = _11512;
                      _10707 = _11513;
                      _10708 = _11514;
                      _10709 = _11515;
                      continue;
                    } else {
                      _11518 = _11511;
                      _11519 = _11512;
                      _11520 = _11513;
                      _11521 = _11514;
                    }
                  } else {
                    _11518 = _11502;
                    _11519 = _11503;
                    _11520 = _11504;
                    _11521 = _11508;
                  }
                } else {
                  _11518 = _11502;
                  _11519 = _11503;
                  _11520 = _11504;
                  _11521 = 0.0f;
                }
              } else {
                _11511 = _10705;
                _11512 = _10706;
                _11513 = _10707;
                _11514 = _10708;
                _11515 = _10709 + 1;
                if ((uint)_11515 < (uint)3) {
                  _10705 = _11511;
                  _10706 = _11512;
                  _10707 = _11513;
                  _10708 = _11514;
                  _10709 = _11515;
                  continue;
                } else {
                  _11518 = _11511;
                  _11519 = _11512;
                  _11520 = _11513;
                  _11521 = _11514;
                }
              }
              _11523 = _11518;
              _11524 = _11519;
              _11525 = _11520;
              _11526 = _11521;
              break;
            }
          } else {
            _11523 = 0.0f;
            _11524 = 0.0f;
            _11525 = 0.0f;
            _11526 = 1.0f;
          }
          _11534 = ((_11526 * _10621) + _11523);
          _11535 = ((_11526 * _10622) + _11524);
          _11536 = ((_11526 * _10623) + _11525);
        } else {
          _11534 = _10621;
          _11535 = _10622;
          _11536 = _10623;
        }
        [branch]
        if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 16) == 0)) {
          _11553 = (min((_11534 / max(9.999999747378752e-05f, _10621)), 1.0f) * _10624);
          _11554 = (min((_11535 / max(9.999999747378752e-05f, _10622)), 1.0f) * _10625);
          _11555 = (min((_11536 / max(9.999999747378752e-05f, _10623)), 1.0f) * _10626);
        } else {
          _11553 = _10624;
          _11554 = _10625;
          _11555 = _10626;
        }
      } else {
        _11553 = _10624;
        _11554 = _10625;
        _11555 = _10626;
      }
      _11567 = min(_234, _9947);
      if (!_1856) {
        _11570 = 0;
        _11571 = _11567;
        while(true) {
          _11689 = _11571;
          _11572 = _11570 + (uint)(_global_0);
          _11575 = _global_5[min((uint)(_11572), 63u)];
          _11576 = _global_6[min((uint)(_11572), 63u)];
          _11580 = (int)((int)(_11575 << (((int)(31u - _9998)) & 31))) >> 31;
          _11584 = (int)((int)(_11575 << ((31 - _10000) & 31))) >> 31;
          _11596 = saturate((asfloat((_11580 & asint(_10005))) + asfloat((_11584 & asint(_10008)))) + asfloat(((_11584 & 1065353216) & _11580)));
          [branch]
          if (!(_11596 == 0.0f)) {
            _11601 = asfloat(srvLightInfoProperties.Load4(_11576)).x;
            _11602 = asfloat(srvLightInfoProperties.Load4(_11576)).y;
            _11603 = asfloat(srvLightInfoProperties.Load4(_11576)).z;
            _11604 = asfloat(srvLightInfoProperties.Load4(_11576)).w;
            _11607 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 16u)))).x;
            _11608 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 16u)))).y;
            _11609 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 16u)))).z;
            _11610 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 16u)))).w;
            _11613 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 32u)))).x;
            _11614 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 32u)))).y;
            _11615 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 32u)))).z;
            _11616 = asfloat(srvLightInfoProperties.Load4(((int)(_11576 + 32u)))).w;
            _11619 = asint(srvLightInfoProperties.Load(((int)(_11576 + 48u))));
            _11622 = asint(srvLightInfoProperties.Load(((int)(_11576 + 52u))));
            _11625 = asint(srvLightInfoProperties.Load(((int)(_11576 + 56u))));
            _11628 = asint(srvLightInfoProperties.Load(((int)(_11576 + 60u))));
            _11643 = mad(_11603, _246, mad(_11602, _245, (_11601 * _244))) + _11604;
            _11647 = mad(_11609, _246, mad(_11608, _245, (_11607 * _244))) + _11610;
            _11651 = mad(_11615, _246, mad(_11614, _245, (_11613 * _244))) + _11616;
            _11676 = saturate(1.0f - ((_11643 + 1.0f) * f16tof32(_11622))) + saturate(1.0f - ((1.0f - _11643) * f16tof32(((uint)((uint)(_11622) >> 16)))));
            _11677 = saturate(1.0f - ((_11647 + 1.0f) * f16tof32(_11625))) + saturate(1.0f - ((1.0f - _11647) * f16tof32(((uint)((uint)(_11625) >> 16)))));
            _11678 = saturate(1.0f - ((_11651 + 1.0f) * f16tof32(_11628))) + saturate(1.0f - ((1.0f - _11651) * f16tof32(((uint)((uint)(_11628) >> 16)))));
            _11681 = saturate(1.0f - dot(float3(_11676, _11677, _11678), float3(_11676, _11677, _11678)));
            _11689 = (saturate(1.0f - ((_11681 * _11681) * (f16tof32(((uint)((uint)(_11619) >> 16))) * _11596))) * _11571);
          } else {
            _11689 = _11571;
          }
          _11690 = _11570 + 1u;
          if (!(_11690 == _global_1)) {
            _11570 = _11690;
            _11571 = _11689;
            continue;
          }
          _11694 = _11689;
          break;
        }
      } else {
        _11694 = _11567;
      }
      _11698 = ((_cbSharedPerViewData_raw[59u].x) > 0.0f);
      if (_11698) {
        _11710 = saturate((_11694 + -1.0f) + exp2((_231 * _231) * log2(max((_11694 + _1831), 0.0f))));
      } else {
        _11710 = _11694;
      }
      if (!(_9987 == 0)) {
        _11713 = rsqrt(dot(float3(_9988, _9989, _9990), float3(_9988, _9989, _9990)));
        _11715 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
        _11716 = _11715 * _205;
        _11717 = _11715 * _207;
        _11718 = _11715 * _209;
        if (_11698) {
          _11723 = max(_231, 0.10000000149011612f);
          _11724 = -0.0f - _257;
          _11725 = -0.0f - _258;
          _11726 = -0.0f - _256;
          _11728 = dot(float3(_11724, _11725, _11726), float3(_11716, _11717, _11718)) * 2.0f;
          _11737 = min(max(dot(float3((_11713 * _9988), (_11713 * _9989), (_11713 * _9990)), float3((_11724 - (_11728 * _11716)), (_11725 - (_11728 * _11717)), (_11726 - (_11728 * _11718)))), -1.0f), 1.0f);
          _11738 = abs(_11737);
          _11743 = (1.5707963705062866f - (_11738 * 0.1565829962491989f)) * sqrt(1.0f - _11738);
          _11749 = abs((_11723 - _11694) * 3.1415927410125732f);
          _11757 = saturate(1.0f - saturate((select((_11737 >= 0.0f), _11743, (3.1415927410125732f - _11743)) - _11749) / (((_11723 + _11694) * 3.1415927410125732f) - _11749)));
          _11767 = (((_11757 * _11757) * saturate((_11694 * 15.707963943481445f) + -0.5f)) * (3.0f - (_11757 * 2.0f)));
        } else {
          _11767 = _11694;
        }
      } else {
        _11767 = _11710;
      }
      _11768 = _11767 * (((_cbSharedPerViewData_raw[61u].x) * _9830) + (_11553 * _9829));
      _11769 = _11767 * (((_cbSharedPerViewData_raw[61u].x) * _9831) + (_11554 * _9829));
      _11770 = _11767 * (((_cbSharedPerViewData_raw[61u].x) * _9832) + (_11555 * _9829));
      if (!(asint(_cbSharedPerViewData_raw_uint[184u].w) == 0)) {
        _11793 = mad((_cbSharedPerViewData_raw[12u].z), _246, mad((_cbSharedPerViewData_raw[12u].y), _245, ((_cbSharedPerViewData_raw[12u].x) * _244))) + (_cbSharedPerViewData_raw[12u].w);
        _11797 = mad((_cbSharedPerViewData_raw[13u].z), _246, mad((_cbSharedPerViewData_raw[13u].y), _245, ((_cbSharedPerViewData_raw[13u].x) * _244))) + (_cbSharedPerViewData_raw[13u].w);
        _11801 = mad((_cbSharedPerViewData_raw[14u].z), _246, mad((_cbSharedPerViewData_raw[14u].y), _245, ((_cbSharedPerViewData_raw[14u].x) * _244))) + (_cbSharedPerViewData_raw[14u].w);
        _11820 = mad((_cbSharedPerViewData_raw[181u].z), _11801, mad((_cbSharedPerViewData_raw[181u].y), _11797, ((_cbSharedPerViewData_raw[181u].x) * _11793))) + (_cbSharedPerViewData_raw[181u].w);
        _11824 = mad((_cbSharedPerViewData_raw[182u].z), _11801, mad((_cbSharedPerViewData_raw[182u].y), _11797, ((_cbSharedPerViewData_raw[182u].x) * _11793))) + (_cbSharedPerViewData_raw[182u].w);
        _11828 = mad((_cbSharedPerViewData_raw[183u].z), _11801, mad((_cbSharedPerViewData_raw[183u].y), _11797, ((_cbSharedPerViewData_raw[183u].x) * _11793))) + (_cbSharedPerViewData_raw[183u].w);
        _11841 = max((_cbSharedPerViewData_raw[184u].x), 9.999999747378752e-06f);
        _11842 = max((_cbSharedPerViewData_raw[184u].y), 9.999999747378752e-06f);
        _11843 = max((_cbSharedPerViewData_raw[184u].z), 9.999999747378752e-06f);
        _11880 = min(min(saturate((_11820 + 1.0f) / max(((_cbSharedPerViewData_raw[185u].x) / _11841), 9.999999747378752e-06f)), saturate((1.0f - _11820) / max(((_cbSharedPerViewData_raw[186u].x) / _11841), 9.999999747378752e-06f))), min(min(saturate((_11824 + 1.0f) / max(((_cbSharedPerViewData_raw[185u].y) / _11842), 9.999999747378752e-06f)), saturate((1.0f - _11824) / max(((_cbSharedPerViewData_raw[186u].y) / _11842), 9.999999747378752e-06f))), min(saturate((_11828 + 1.0f) / max(((_cbSharedPerViewData_raw[185u].z) / _11843), 9.999999747378752e-06f)), saturate((1.0f - _11828) / max(((_cbSharedPerViewData_raw[186u].z) / _11843), 9.999999747378752e-06f)))));
      } else {
        _11880 = 0.0f;
      }
      if (_2236) {
        _11883 = _2235;
        _11884 = _11768;
        _11885 = _11769;
        _11886 = _11770;
        while(true) {
          _19167 = _11884;
          _19168 = _11885;
          _19169 = _11886;
          _11888 = _global_3[min((uint)(_11883), 63u)];
          _11892 = _global_4[min((uint)(_11883), 63u)];
          _11893 = _global_5[min((uint)(_11883), 63u)];
          _11894 = _global_6[min((uint)(_11883), 63u)];
          _11895 = _11888 & 4095;
          [branch]
          if (((_11892 & 16777216) == 0) && (_217 || ((_11892 & 8388608) == 0))) {
            _11906 = (int)((int)(_11893 << (((int)(31u - _9998)) & 31))) >> 31;
            _11910 = (int)((int)(_11893 << ((31 - _10000) & 31))) >> 31;
            _11922 = saturate((asfloat((_11906 & asint(_10005))) + asfloat((_11910 & asint(_10008)))) + asfloat(((_11910 & 1065353216) & _11906)));
            [branch]
            if (!(_11922 == 0.0f)) {
              _11925 = (uint)(_11888) >> 12;
              if (_11925 == 6) {
                if (!(asint(_cbSharedPerViewData_raw_uint[185u].w) == 0)) {
                  _13521 = (_11922 * select(((_11892 & 67108864) != 0), 1.0f, (1.0f - _11880)));
                } else {
                  _13521 = _11922;
                }
                _13524 = asfloat(srvLightInfoProperties.Load4(_11894)).x;
                _13525 = asfloat(srvLightInfoProperties.Load4(_11894)).y;
                _13526 = asfloat(srvLightInfoProperties.Load4(_11894)).z;
                _13527 = asfloat(srvLightInfoProperties.Load4(_11894)).w;
                _13530 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).x;
                _13531 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).y;
                _13532 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).z;
                _13533 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).w;
                _13536 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).x;
                _13537 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).y;
                _13538 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).z;
                _13541 = asint(srvLightInfoProperties.Load(((int)(_11894 + 68u))));
                _13544 = asint(srvLightInfoProperties.Load(((int)(_11894 + 72u))));
                _13547 = asint(srvLightInfoProperties.Load(((int)(_11894 + 76u))));
                _13550 = asint(srvLightInfoProperties.Load(((int)(_11894 + 84u))));
                _13553 = asint(srvLightInfoProperties.Load(((int)(_11894 + 88u))));
                _13556 = asint(srvLightInfoProperties.Load(((int)(_11894 + 92u))));
                _13559 = (float)((uint)((uint)(((uint)(_13541) >> 8) & 255)));
                _13562 = f16tof32(((uint)((uint)(_13544) >> 16)));
                _13564 = (uint)(_13547) >> 16;
                _13584 = srvDeferredShadingPass_DeferredShadows.Load(int3(_80, _81, 0));
                [branch]
                if (!(_13584.x == 0.0f)) {
                  [branch]
                  if (!(_13564 == 0)) {
                    Texture2D<float3> _HeapResource_53 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _13564)))];
                    _13601 = _HeapResource_53.SampleLevel(samplerLinearWrapNode, float2((((mad(_13526, _246, mad(_13525, _245, (_13524 * _244))) + _13527) * f16tof32(((uint)((uint)(_13553) >> 16)))) + f16tof32(((uint)((uint)(_13556) >> 16)))), (((mad(_13532, _246, mad(_13531, _245, (_13530 * _244))) + _13533) * f16tof32(_13553)) + f16tof32(_13556))), 0.0f);
                    _13609 = (_13601.x * (_cbSharedPerViewData_raw[70u].x));
                    _13610 = (_13601.y * (_cbSharedPerViewData_raw[70u].y));
                    _13611 = (_13601.z * (_cbSharedPerViewData_raw[70u].z));
                  } else {
                    _13609 = (_cbSharedPerViewData_raw[70u].x);
                    _13610 = (_cbSharedPerViewData_raw[70u].y);
                    _13611 = (_cbSharedPerViewData_raw[70u].z);
                  }
                  _13614 = min(_13584.x, _13584.y) * _13521;
                  [branch]
                  if (_13614 > 0.0f) {
                    _13617 = dot(float3(_13536, _13537, _13538), float3(_13536, _13537, _13538));
                    _13618 = rsqrt(_13617);
                    _13619 = _13618 * _13536;
                    _13620 = _13618 * _13537;
                    _13621 = _13618 * _13538;
                    _13622 = dot(float3(_205, _207, _209), float3(_13619, _13620, _13621));
                    if (_13562 > 0.0f) {
                      _13630 = sqrt(saturate((_13562 * _13562) * (1.0f / (_13617 + 1.0f))));
                      if (_13622 < _13630) {
                        _13635 = max(_13622, (-0.0f - _13630)) + _13630;
                        _13640 = ((_13635 * _13635) / (_13630 * 4.0f));
                      } else {
                        _13640 = _13622;
                      }
                    } else {
                      _13640 = _13622;
                    }
                    _13641 = _231 * _231;
                    _13642 = 1.0f - _13641;
                    _13645 = saturate((_13562 * _13642) * _13618);
                    _13647 = saturate(_13618 * f16tof32(_13544));
                    _13648 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                    _13649 = dot(float3(_257, _258, _256), float3(_13619, _13620, _13621));
                    _13652 = rsqrt((_13649 * 2.0f) + 2.0f);
                    _13655 = saturate(_13652 * (_13648 + _13622));
                    _13658 = saturate((_13652 * _13649) + _13652);
                    _13659 = (_13645 > 0.0f);
                    if (_13659) {
                      _13663 = sqrt(1.0f - (_13645 * _13645));
                      _13665 = (_13622 * 2.0f) * _13648;
                      _13666 = _13665 - _13649;
                      if (!(_13666 >= _13663)) {
                        _13674 = rsqrt(1.0f - (_13666 * _13666)) * _13645;
                        _13677 = _13674 * (_13648 - (_13666 * _13622));
                        _13678 = _13648 * _13648;
                        _13683 = _13674 * (((_13678 * 2.0f) + -1.0f) - (_13666 * _13649));
                        _13692 = sqrt(saturate((((1.0f - (_13622 * _13622)) - _13678) - (_13649 * _13649)) + (_13665 * _13649)));
                        _13693 = _13692 * _13674;
                        _13696 = ((_13648 * 2.0f) * _13674) * _13692;
                        _13698 = (_13663 * _13622) + _13648;
                        _13699 = _13698 + _13677;
                        _13700 = _13663 * _13649;
                        _13702 = (_13700 + 1.0f) + _13683;
                        _13703 = _13693 * _13702;
                        _13704 = _13699 * _13702;
                        _13705 = _13696 * _13699;
                        _13710 = (((_13699 * 0.25f) * _13696) - (_13703 * 0.5f)) * _13704;
                        _13724 = (((_13705 - (_13703 * 2.0f)) * _13705) + (_13703 * _13703)) + ((((-0.5f - ((_13702 + _13700) * 0.5f)) * _13704) + ((_13702 * _13702) * _13698)) * _13699);
                        _13729 = (_13710 * 2.0f) / ((_13724 * _13724) + (_13710 * _13710));
                        _13730 = _13724 * _13729;
                        _13732 = 1.0f - (_13710 * _13729);
                        _13738 = ((_13730 * _13696) + _13700) + (_13732 * _13683);
                        _13741 = rsqrt((_13738 * 2.0f) + 2.0f);
                        _13750 = saturate((_13738 * _13741) + _13741);
                        _13751 = saturate(((_13698 + (_13730 * _13693)) + (_13732 * _13677)) * _13741);
                      } else {
                        _13750 = abs(_13648);
                        _13751 = 1.0f;
                      }
                    } else {
                      _13750 = _13658;
                      _13751 = _13655;
                    }
                    _13752 = saturate(_13640);
                    _13753 = _13641 * _13641;
                    _13754 = (_13647 > 0.0f);
                    if (_13754) {
                      _13763 = saturate(((_13647 * _13647) / ((_13750 * 3.5999999046325684f) + 0.4000000059604645f)) + _13753);
                    } else {
                      _13763 = _13753;
                    }
                    _13764 = sqrt(_13763);
                    if (_13659) {
                      _13775 = (_13763 / ((((_13645 * 0.25f) * ((_13764 * 3.0f) + _13645)) / (_13750 + 0.0010000000474974513f)) + _13763));
                    } else {
                      _13775 = 1.0f;
                    }
                    _13779 = (((_13763 * _13751) - _13751) * _13751) + 1.0f;
                    _13789 = abs(_13648);
                    _13791 = saturate(_13789 + 9.999999747378752e-06f);
                    _13792 = 1.0f - _13764;
                    _13804 = saturate(select((_13642 > 0.0f), 1.0f, 0.0f) * _13645);
                    _13805 = (_13804 > 0.0f);
                    if (_13805) {
                      _13809 = sqrt(1.0f - (_13804 * _13804));
                      _13811 = (_13622 * 2.0f) * _13648;
                      _13812 = _13811 - _13649;
                      if (!(_13812 >= _13809)) {
                        _13818 = rsqrt(1.0f - (_13812 * _13812)) * _13804;
                        _13821 = _13818 * (_13648 - (_13812 * _13622));
                        _13822 = _13648 * _13648;
                        _13827 = _13818 * (((_13822 * 2.0f) + -1.0f) - (_13812 * _13649));
                        _13836 = sqrt(saturate((((1.0f - (_13622 * _13622)) - _13822) - (_13649 * _13649)) + (_13811 * _13649)));
                        _13837 = _13836 * _13818;
                        _13840 = ((_13648 * 2.0f) * _13818) * _13836;
                        _13842 = (_13809 * _13622) + _13648;
                        _13843 = _13842 + _13821;
                        _13844 = _13809 * _13649;
                        _13846 = (_13844 + 1.0f) + _13827;
                        _13847 = _13837 * _13846;
                        _13848 = _13843 * _13846;
                        _13849 = _13840 * _13843;
                        _13854 = (((_13843 * 0.25f) * _13840) - (_13847 * 0.5f)) * _13848;
                        _13868 = (((_13849 - (_13847 * 2.0f)) * _13849) + (_13847 * _13847)) + ((((-0.5f - ((_13846 + _13844) * 0.5f)) * _13848) + ((_13846 * _13846) * _13842)) * _13843);
                        _13873 = (_13854 * 2.0f) / ((_13868 * _13868) + (_13854 * _13854));
                        _13874 = _13868 * _13873;
                        _13876 = 1.0f - (_13854 * _13873);
                        _13882 = ((_13874 * _13840) + _13844) + (_13876 * _13827);
                        _13885 = rsqrt((_13882 * 2.0f) + 2.0f);
                        _13894 = saturate(((_13842 + (_13874 * _13837)) + (_13876 * _13821)) * _13885);
                        _13895 = saturate((_13882 * _13885) + _13885);
                      } else {
                        _13894 = 1.0f;
                        _13895 = _13789;
                      }
                    } else {
                      _13894 = _13655;
                      _13895 = _13658;
                    }
                    if (_13754) {
                      _13904 = saturate(((_13647 * _13647) / ((_13895 * 3.5999999046325684f) + 0.4000000059604645f)) + _13753);
                    } else {
                      _13904 = _13753;
                    }
                    _13905 = sqrt(_13904);
                    if (_13805) {
                      _13916 = (_13904 / ((((_13804 * 0.25f) * ((_13905 * 3.0f) + _13804)) / (_13895 + 0.0010000000474974513f)) + _13904));
                    } else {
                      _13916 = 1.0f;
                    }
                    _13920 = (((_13904 * _13894) - _13894) * _13894) + 1.0f;
                    _13930 = 1.0f - _13905;
                    [branch]
                    if (!((_13550 & 1) == 0)) {
                      _13961 = max(max(_13609, _13610), _13611);
                      if (_13961 > 0.0f) {
                        _13971 = saturate(_13609 / _13961);
                        _13972 = saturate(_13610 / _13961);
                        _13973 = saturate(_13611 / _13961);
                      } else {
                        _13971 = _13609;
                        _13972 = _13610;
                        _13973 = _13611;
                      }
                      _13974 = (_13972 < _13973);
                      _13975 = select(_13974, _13973, _13972);
                      _13976 = select(_13974, _13972, _13973);
                      _13977 = select(_13974, -1.0f, 0.0f);
                      _13978 = (_13971 < _13975);
                      _13980 = select(_13978, _13975, _13971);
                      _13981 = select(_13978, _13971, _13975);
                      _13985 = _13980 - select((_13981 < _13976), _13981, _13976);
                      _13991 = abs(select(_13978, (-0.3333333432674408f - _13977), _13977) + ((_13981 - _13976) / ((_13985 * 6.0f) + 9.999999682655225e-21f)));
                      if (_13991 < 0.6666666865348816f) {
                        _14004 = ((saturate(((float)((uint)((uint)(((uint)(_13550) >> 9) & 255)))) * 0.003921499941498041f) * (select((_13991 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _13991)) + _13991);
                      } else {
                        _14004 = _13991;
                      }
                      _14005 = saturate((_13985 / (_13980 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_13550) >> 1) & 255)))) * 0.003921499941498041f));
                      _14006 = saturate(_13980);
                      if (!(_14005 <= 0.0f)) {
                        _14009 = saturate(_14004);
                        _14013 = select(((_14009 * 360.0f) >= 360.0f), 0.0f, (_14009 * 6.0f));
                        _14014 = int(_14013);
                        _14016 = _14013 - float((int)(_14014));
                        _14018 = _14006 * (1.0f - _14005);
                        _14021 = (1.0f - (_14016 * _14005)) * _14006;
                        _14025 = (1.0f - ((1.0f - _14016) * _14005)) * _14006;
                        switch (_14014) {
                          case 0: {
                            _14033 = _14006;
                            _14034 = _14025;
                            _14035 = _14018;
                            break;
                          }
                          case 1: {
                            _14033 = _14021;
                            _14034 = _14006;
                            _14035 = _14018;
                            break;
                          }
                          case 2: {
                            _14033 = _14018;
                            _14034 = _14006;
                            _14035 = _14025;
                            break;
                          }
                          case 3: {
                            _14033 = _14018;
                            _14034 = _14021;
                            _14035 = _14006;
                            break;
                          }
                          case 4: {
                            _14033 = _14025;
                            _14034 = _14018;
                            _14035 = _14006;
                            break;
                          }
                          case 5: {
                            _14033 = _14006;
                            _14034 = _14018;
                            _14035 = _14021;
                            break;
                          }
                          default: {
                            _14033 = 0.0f;
                            _14034 = 0.0f;
                            _14035 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _14033 = _14006;
                        _14034 = _14006;
                        _14035 = _14006;
                      }
                      _14036 = _14033 * _13961;
                      _14037 = _14034 * _13961;
                      _14038 = _14035 * _13961;
                      _14040 = saturate(_13614 * 1.0101009607315063f);
                      _14051 = ((_14040 * (_13609 - _14036)) + _14036);
                      _14052 = ((_14040 * (_13610 - _14037)) + _14037);
                      _14053 = (lerp(_14038, _13611, _14040));
                    } else {
                      _14051 = _13609;
                      _14052 = _13610;
                      _14053 = _13611;
                    }
                    _14054 = _14051 * _13614;
                    _14055 = _14052 * _13614;
                    _14056 = _14053 * _13614;
                    if (!((asint(_cbSharedPerViewData_raw_uint[102u].w) & 1024) == 0)) {
                      _14066 = (_14054 * _11694);
                      _14067 = (_14055 * _11694);
                      _14068 = (_14056 * _11694);
                    } else {
                      _14066 = _14054;
                      _14067 = _14055;
                      _14068 = _14056;
                    }
                    if ((_13559 * 0.003921499941498041f) > 0.0f) {
                      _14072 = (((((exp2(log2(1.0f - saturate(_13895)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_13916 * _13752) * (_13904 / (_13920 * _13920))) * (0.5f / ((((_13930 * _13791) + _13905) * _13752) + (((_13930 * _13752) + _13905) * _13791))))) + ((((_13775 * _13752) * (_13763 / (_13779 * _13779))) * (0.5f / ((((_13792 * _13791) + _13764) * _13752) + (((_13792 * _13752) + _13764) * _13791)))) * ((exp2(log2(1.0f - saturate(_13750)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f))) * ((_11767 * 0.003921499941498041f) * _13559);
                      _19167 = ((_14072 * _14066) + _11884);
                      _19168 = ((_14072 * _14067) + _11885);
                      _19169 = ((_14072 * _14068) + _11886);
                    } else {
                      _19167 = _11884;
                      _19168 = _11885;
                      _19169 = _11886;
                    }
                  } else {
                    _19167 = _11884;
                    _19168 = _11885;
                    _19169 = _11886;
                  }
                } else {
                  _19167 = _11884;
                  _19168 = _11885;
                  _19169 = _11886;
                }
              } else {
                _11942 = _11922 * select(((_11892 & 67108864) != 0), 1.0f, (1.0f - _11880));
                [branch]
                if (_11925 == 4) {
                  _11947 = asfloat(srvLightInfoProperties.Load4(_11894)).x;
                  _11948 = asfloat(srvLightInfoProperties.Load4(_11894)).y;
                  _11949 = asfloat(srvLightInfoProperties.Load4(_11894)).z;
                  _11950 = asfloat(srvLightInfoProperties.Load4(_11894)).w;
                  _11953 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).x;
                  _11954 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).y;
                  _11955 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).z;
                  _11956 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).w;
                  _11959 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).x;
                  _11960 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).y;
                  _11961 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).z;
                  _11962 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).w;
                  _11965 = asint(srvLightInfoProperties.Load(((int)(_11894 + 48u))));
                  _11968 = asint(srvLightInfoProperties.Load(((int)(_11894 + 52u))));
                  _11971 = asint(srvLightInfoProperties.Load(((int)(_11894 + 64u))));
                  _11974 = asint(srvLightInfoProperties.Load(((int)(_11894 + 68u))));
                  _11977 = asint(srvLightInfoProperties.Load(((int)(_11894 + 72u))));
                  _11986 = ((float)((uint)((uint)(((uint)(_11968) >> 8) & 255)))) * 0.003921499941498041f;
                  _11999 = mad(_11949, _246, mad(_11948, _245, (_11947 * _244))) + _11950;
                  _12003 = mad(_11955, _246, mad(_11954, _245, (_11953 * _244))) + _11956;
                  _12007 = mad(_11961, _246, mad(_11960, _245, (_11959 * _244))) + _11962;
                  _12032 = saturate(1.0f - ((_11999 + 1.0f) * f16tof32(_11971))) + saturate(1.0f - ((1.0f - _11999) * f16tof32(((uint)((uint)(_11971) >> 16)))));
                  _12033 = saturate(1.0f - ((_12003 + 1.0f) * f16tof32(_11974))) + saturate(1.0f - ((1.0f - _12003) * f16tof32(((uint)((uint)(_11974) >> 16)))));
                  _12034 = saturate(1.0f - ((_12007 + 1.0f) * f16tof32(_11977))) + saturate(1.0f - ((1.0f - _12007) * f16tof32(((uint)((uint)(_11977) >> 16)))));
                  _12037 = saturate(1.0f - dot(float3(_12032, _12033, _12034), float3(_12032, _12033, _12034)));
                  _12038 = _12037 * _12037;
                  _12045 = select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_12038 * _11694), _12038) * _11942;
                  _19167 = (((_11986 * f16tof32(((uint)((uint)(_11965) >> 16)))) * _12045) + _11884);
                  _19168 = (((_11986 * f16tof32(_11965)) * _12045) + _11885);
                  _19169 = (((f16tof32(((uint)((uint)(_11968) >> 16))) * _11986) * _12045) + _11886);
                } else {
                  if (_11925 == 5) {
                    _12060 = asfloat(srvLightInfoProperties.Load4(_11894)).x;
                    _12061 = asfloat(srvLightInfoProperties.Load4(_11894)).y;
                    _12062 = asfloat(srvLightInfoProperties.Load4(_11894)).z;
                    _12063 = asfloat(srvLightInfoProperties.Load4(_11894)).w;
                    _12066 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).x;
                    _12067 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).y;
                    _12068 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).z;
                    _12069 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).w;
                    _12072 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).x;
                    _12073 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).y;
                    _12074 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).z;
                    _12075 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).w;
                    _12078 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).x;
                    _12079 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).y;
                    _12080 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).z;
                    _12083 = asfloat(srvLightInfoProperties.Load(((int)(_11894 + 60u))));
                    _12086 = asint(srvLightInfoProperties.Load(((int)(_11894 + 64u))));
                    _12089 = asint(srvLightInfoProperties.Load(((int)(_11894 + 68u))));
                    _12092 = asint(srvLightInfoProperties.Load(((int)(_11894 + 80u))));
                    _12095 = asint(srvLightInfoProperties.Load(((int)(_11894 + 84u))));
                    _12098 = asint(srvLightInfoProperties.Load(((int)(_11894 + 88u))));
                    _12101 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 92u)))).x;
                    _12102 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 92u)))).y;
                    _12103 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 92u)))).z;
                    _12104 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 92u)))).w;
                    _12107 = asint(srvLightInfoProperties.Load(((int)(_11894 + 108u))));
                    _12110 = asint(srvLightInfoProperties.Load(((int)(_11894 + 112u))));
                    _12113 = asint(srvLightInfoProperties.Load(((int)(_11894 + 120u))));
                    _12116 = asint(srvLightInfoProperties.Load(((int)(_11894 + 124u))));
                    _12119 = asint(srvLightInfoProperties.Load(((int)(_11894 + 128u))));
                    _12122 = asint(srvLightInfoProperties.Load(((int)(_11894 + 132u))));
                    _12125 = asint(srvLightInfoProperties.Load(((int)(_11894 + 136u))));
                    _12128 = asint(srvLightInfoProperties.Load(((int)(_11894 + 140u))));
                    _12130 = f16tof32(((uint)((uint)(_12086) >> 16)));
                    _12131 = f16tof32(_12086);
                    _12133 = f16tof32(((uint)((uint)(_12089) >> 16)));
                    _12137 = ((float)((uint)((uint)(((uint)(_12089) >> 8) & 255)))) * 0.003921499941498041f;
                    _12139 = f16tof32(((uint)((uint)(_12092) >> 16)));
                    _12142 = _12095 & 65535;
                    _12152 = f16tof32(((uint)((uint)(_12110) >> 16)));
                    _12153 = f16tof32(_12110);
                    _12155 = f16tof32(((uint)((uint)(_12113) >> 16)));
                    _12156 = 1.0f / _12155;
                    _12157 = _12155 + -1.0f;
                    _12158 = f16tof32(_12113);
                    _12177 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_12078, _12079, _12080))) * f16tof32(_12107);
                    _12181 = (_12177 * _205) + _244;
                    _12182 = (_12177 * _207) + _245;
                    _12183 = (_12177 * _209) - _243;
                    _12187 = mad(_12062, _12183, mad(_12061, _12182, (_12181 * _12060))) + _12063;
                    _12191 = mad(_12068, _12183, mad(_12067, _12182, (_12181 * _12066))) + _12069;
                    _12195 = mad(_12074, _12183, mad(_12073, _12182, (_12181 * _12072))) + _12075;
                    _12196 = saturate(_12195);
                    _12219 = saturate(1.0f - (_12187 * f16tof32(_12122))) + saturate(1.0f - ((1.0f - _12187) * f16tof32(((uint)((uint)(_12122) >> 16)))));
                    _12220 = saturate(1.0f - (_12191 * f16tof32(_12125))) + saturate(1.0f - ((1.0f - _12191) * f16tof32(((uint)((uint)(_12125) >> 16)))));
                    _12221 = saturate(1.0f - (_12195 * f16tof32(_12128))) + saturate(1.0f - ((1.0f - _12195) * f16tof32(((uint)((uint)(_12128) >> 16)))));
                    _12224 = saturate(1.0f - dot(float3(_12219, _12220, _12221), float3(_12219, _12220, _12221)));
                    _12225 = _12224 * _12224;
                    if (!(((_11892 & 3584) == 0) || (!(_12225 > 0.0f)))) {
                      _12232 = 1.0f - _12196;
                      _12233 = saturate(_12187);
                      _12234 = saturate(_12191);
                      bool __branch_chain_12229;
                      [branch]
                      if ((_11892 & 1024) == 0) {
                        _12497 = 1.0f;
                        _12498 = 0.0f;
                        _12499 = _12232;
                        __branch_chain_12229 = true;
                      } else {
                        _12239 = ((_12233 * _12157) + 0.5f) * _12156;
                        _12241 = ((_12234 * _12157) + 0.5f) * _12156;
                        _12242 = _12232 + f16tof32(((uint)((uint)(_12107) >> 16)));
                        Texture2D<float4> _HeapResource_48 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_12095) >> 16))];
                        _12245 = saturate(_12242);
                        _12249 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                        _12258 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 8u) : (frac(frac(dot(float2(((_12249 * 32.665000915527344f) + _142), ((_12249 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                        _12259 = sin(_12258);
                        _12260 = cos(_12258);
                        _12261 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                        _12266 = sqrt((float((int)(_12261)) * 0.25f) + 0.125f) * _12152;
                        _12275 = (_global_7[min((uint)(((int)(0u + (_12261 * 2)))), 127u)]) * _12266;
                        _12276 = (_global_7[min((uint)(((int)(1u + (_12261 * 2)))), 127u)]) * _12266;
                        _12278 = -0.0f - _12259;
                        _12283 = _HeapResource_48.GatherRed(samplerPointClampNode, float2((dot(float2(_12275, _12276), float2(_12260, _12259)) + _12239), (dot(float2(_12275, _12276), float2(_12278, _12260)) + _12241)));
                        _12288 = _12283.x - _12245;
                        _12290 = select((_12288 < 0.0f), 0.0f, 1.0f);
                        _12292 = _12283.y - _12245;
                        _12294 = select((_12292 < 0.0f), 0.0f, 1.0f);
                        _12298 = _12283.z - _12245;
                        _12300 = select((_12298 < 0.0f), 0.0f, 1.0f);
                        _12304 = _12283.w - _12245;
                        _12306 = select((_12304 < 0.0f), 0.0f, 1.0f);
                        _12313 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                        _12318 = sqrt((float((int)(_12313)) * 0.25f) + 0.125f) * _12152;
                        _12327 = (_global_7[min((uint)(((int)(0u + (_12313 * 2)))), 127u)]) * _12318;
                        _12328 = (_global_7[min((uint)(((int)(1u + (_12313 * 2)))), 127u)]) * _12318;
                        _12334 = _HeapResource_48.GatherRed(samplerPointClampNode, float2((dot(float2(_12327, _12328), float2(_12260, _12259)) + _12239), (dot(float2(_12327, _12328), float2(_12278, _12260)) + _12241)));
                        _12339 = _12334.x - _12245;
                        _12341 = select((_12339 < 0.0f), 0.0f, 1.0f);
                        _12345 = _12334.y - _12245;
                        _12347 = select((_12345 < 0.0f), 0.0f, 1.0f);
                        _12351 = _12334.z - _12245;
                        _12353 = select((_12351 < 0.0f), 0.0f, 1.0f);
                        _12357 = _12334.w - _12245;
                        _12359 = select((_12357 < 0.0f), 0.0f, 1.0f);
                        _12366 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                        _12371 = sqrt((float((int)(_12366)) * 0.25f) + 0.125f) * _12152;
                        _12380 = (_global_7[min((uint)(((int)(0u + (_12366 * 2)))), 127u)]) * _12371;
                        _12381 = (_global_7[min((uint)(((int)(1u + (_12366 * 2)))), 127u)]) * _12371;
                        _12387 = _HeapResource_48.GatherRed(samplerPointClampNode, float2((dot(float2(_12380, _12381), float2(_12260, _12259)) + _12239), (dot(float2(_12380, _12381), float2(_12278, _12260)) + _12241)));
                        _12392 = _12387.x - _12245;
                        _12394 = select((_12392 < 0.0f), 0.0f, 1.0f);
                        _12398 = _12387.y - _12245;
                        _12400 = select((_12398 < 0.0f), 0.0f, 1.0f);
                        _12404 = _12387.z - _12245;
                        _12406 = select((_12404 < 0.0f), 0.0f, 1.0f);
                        _12410 = _12387.w - _12245;
                        _12412 = select((_12410 < 0.0f), 0.0f, 1.0f);
                        _12419 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                        _12424 = sqrt((float((int)(_12419)) * 0.25f) + 0.125f) * _12152;
                        _12433 = (_global_7[min((uint)(((int)(0u + (_12419 * 2)))), 127u)]) * _12424;
                        _12434 = (_global_7[min((uint)(((int)(1u + (_12419 * 2)))), 127u)]) * _12424;
                        _12440 = _HeapResource_48.GatherRed(samplerPointClampNode, float2((dot(float2(_12433, _12434), float2(_12260, _12259)) + _12239), (dot(float2(_12433, _12434), float2(_12278, _12260)) + _12241)));
                        _12445 = _12440.x - _12245;
                        _12447 = select((_12445 < 0.0f), 0.0f, 1.0f);
                        _12451 = _12440.y - _12245;
                        _12453 = select((_12451 < 0.0f), 0.0f, 1.0f);
                        _12457 = _12440.z - _12245;
                        _12459 = select((_12457 < 0.0f), 0.0f, 1.0f);
                        _12463 = _12440.w - _12245;
                        _12465 = select((_12463 < 0.0f), 0.0f, 1.0f);
                        _12466 = ((((((((((((((_12290 + _12294) + _12300) + _12306) + _12341) + _12347) + _12353) + _12359) + _12394) + _12400) + _12406) + _12412) + _12447) + _12453) + _12459) + _12465;
                        _12477 = (saturate(_12466 * 0.0625f) * 2.0f) + -1.0f;
                        _12483 = float((int)(((int)(uint)((int)(_12477 > 0.0f))) - ((int)(uint)((int)(_12477 < 0.0f)))));
                        _12485 = 1.0f - (_12483 * _12477);
                        _12487 = (_12485 * _12485) * _12485;
                        _12494 = 0.5f - ((_12483 * 0.5f) * ((1.0f - _12487) - ((_12485 - _12487) * saturate(((1.0f / _12245) * (1.0f / _12466)) * ((((((((((((((((_12290 * _12288) + (_12294 * _12292)) + (_12300 * _12298)) + (_12306 * _12304)) + (_12341 * _12339)) + (_12347 * _12345)) + (_12353 * _12351)) + (_12359 * _12357)) + (_12394 * _12392)) + (_12400 * _12398)) + (_12406 * _12404)) + (_12412 * _12410)) + (_12447 * _12445)) + (_12453 * _12451)) + (_12459 * _12457)) + (_12465 * _12463))))));
                        [branch]
                        if (_12158 < 1.0f) {
                          _12497 = _12494;
                          _12498 = _12158;
                          _12499 = _12242;
                          __branch_chain_12229 = true;
                        } else {
                          _12967 = _12494;
                          __branch_chain_12229 = false;
                        }
                      }
                      if (__branch_chain_12229) {
                        _12502 = (_12233 * _12101) + _12103;
                        _12503 = (_12234 * _12102) + _12104;
                        if (!((_11892 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_49 = ResourceDescriptorHeap[5];
                          _12512 = saturate(_12499);
                          _12516 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                          _12525 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 9u) : (frac(frac(dot(float2(((_12516 * 32.665000915527344f) + _142), ((_12516 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _12526 = sin(_12525);
                          _12527 = cos(_12525);
                          _12532 = select(((((float4)(_HeapResource_49.SampleLevel(samplerPointBorderWhiteNode, float2(_12502, _12503), 0.0f))).x) > _12512), 1.0f, 0.0f);
                          _12533 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                          _12538 = sqrt((float((int)(_12533)) * 0.25f) + 0.125f) * _12153;
                          _12547 = (_global_7[min((uint)(((int)(0u + (_12533 * 2)))), 127u)]) * _12538;
                          _12548 = (_global_7[min((uint)(((int)(1u + (_12533 * 2)))), 127u)]) * _12538;
                          _12550 = -0.0f - _12526;
                          _12552 = dot(float2(_12547, _12548), float2(_12527, _12526)) + _12502;
                          _12553 = dot(float2(_12547, _12548), float2(_12550, _12527)) + _12503;
                          _12555 = _HeapResource_49.GatherRed(samplerPointClampNode, float2(_12552, _12553));
                          _12559 = _12552 * (_cbSharedPerViewData_raw[82u].x);
                          _12560 = _12553 * (_cbSharedPerViewData_raw[82u].y);
                          _12563 = floor((_cbSharedPerViewData_raw[82u].x) * _12103);
                          _12564 = floor((_cbSharedPerViewData_raw[82u].y) * _12104);
                          _12569 = floor(((_cbSharedPerViewData_raw[82u].x) * (_12101 + _12103)) + 0.5f);
                          _12570 = floor(((_cbSharedPerViewData_raw[82u].y) * (_12102 + _12104)) + 0.5f);
                          _12573 = floor(_12559 + -0.5f);
                          _12574 = floor(_12560 + 0.5f);
                          _12576 = floor(_12559 + 0.5f);
                          _12578 = floor(_12560 + -0.5f);
                          _12579 = (_12573 < _12563);
                          _12580 = (_12574 < _12564);
                          if ((_12579 || _12580) | ((_12573 >= _12569) || (_12574 >= _12570))) {
                            _12589 = _12532;
                          } else {
                            _12589 = _12555.x;
                          }
                          _12590 = (_12576 < _12563);
                          if ((_12590 || _12580) | ((_12576 >= _12569) || (_12574 >= _12570))) {
                            _12598 = _12532;
                          } else {
                            _12598 = _12555.y;
                          }
                          _12599 = (_12578 < _12564);
                          if ((_12590 || _12599) | ((_12576 >= _12569) || (_12578 >= _12570))) {
                            _12607 = _12532;
                          } else {
                            _12607 = _12555.z;
                          }
                          if ((_12579 || _12599) | ((_12573 >= _12569) || (_12578 >= _12570))) {
                            _12615 = _12532;
                          } else {
                            _12615 = _12555.w;
                          }
                          _12616 = _12589 - _12512;
                          _12618 = select((_12616 < 0.0f), 0.0f, 1.0f);
                          _12620 = _12598 - _12512;
                          _12622 = select((_12620 < 0.0f), 0.0f, 1.0f);
                          _12626 = _12607 - _12512;
                          _12628 = select((_12626 < 0.0f), 0.0f, 1.0f);
                          _12632 = _12615 - _12512;
                          _12634 = select((_12632 < 0.0f), 0.0f, 1.0f);
                          _12641 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                          _12646 = sqrt((float((int)(_12641)) * 0.25f) + 0.125f) * _12153;
                          _12655 = (_global_7[min((uint)(((int)(0u + (_12641 * 2)))), 127u)]) * _12646;
                          _12656 = (_global_7[min((uint)(((int)(1u + (_12641 * 2)))), 127u)]) * _12646;
                          _12659 = dot(float2(_12655, _12656), float2(_12527, _12526)) + _12502;
                          _12660 = dot(float2(_12655, _12656), float2(_12550, _12527)) + _12503;
                          _12662 = _HeapResource_49.GatherRed(samplerPointClampNode, float2(_12659, _12660));
                          _12666 = _12659 * (_cbSharedPerViewData_raw[82u].x);
                          _12667 = _12660 * (_cbSharedPerViewData_raw[82u].y);
                          _12670 = floor(_12666 + -0.5f);
                          _12671 = floor(_12667 + 0.5f);
                          _12673 = floor(_12666 + 0.5f);
                          _12675 = floor(_12667 + -0.5f);
                          _12676 = (_12670 < _12563);
                          _12677 = (_12671 < _12564);
                          if ((_12676 || _12677) | ((_12670 >= _12569) || (_12671 >= _12570))) {
                            _12686 = _12532;
                          } else {
                            _12686 = _12662.x;
                          }
                          _12687 = (_12673 < _12563);
                          if ((_12687 || _12677) | ((_12673 >= _12569) || (_12671 >= _12570))) {
                            _12695 = _12532;
                          } else {
                            _12695 = _12662.y;
                          }
                          _12696 = (_12675 < _12564);
                          if ((_12687 || _12696) | ((_12673 >= _12569) || (_12675 >= _12570))) {
                            _12704 = _12532;
                          } else {
                            _12704 = _12662.z;
                          }
                          if ((_12676 || _12696) | ((_12670 >= _12569) || (_12675 >= _12570))) {
                            _12712 = _12532;
                          } else {
                            _12712 = _12662.w;
                          }
                          _12713 = _12686 - _12512;
                          _12715 = select((_12713 < 0.0f), 0.0f, 1.0f);
                          _12719 = _12695 - _12512;
                          _12721 = select((_12719 < 0.0f), 0.0f, 1.0f);
                          _12725 = _12704 - _12512;
                          _12727 = select((_12725 < 0.0f), 0.0f, 1.0f);
                          _12731 = _12712 - _12512;
                          _12733 = select((_12731 < 0.0f), 0.0f, 1.0f);
                          _12740 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                          _12745 = sqrt((float((int)(_12740)) * 0.25f) + 0.125f) * _12153;
                          _12754 = (_global_7[min((uint)(((int)(0u + (_12740 * 2)))), 127u)]) * _12745;
                          _12755 = (_global_7[min((uint)(((int)(1u + (_12740 * 2)))), 127u)]) * _12745;
                          _12758 = dot(float2(_12754, _12755), float2(_12527, _12526)) + _12502;
                          _12759 = dot(float2(_12754, _12755), float2(_12550, _12527)) + _12503;
                          _12761 = _HeapResource_49.GatherRed(samplerPointClampNode, float2(_12758, _12759));
                          _12765 = _12758 * (_cbSharedPerViewData_raw[82u].x);
                          _12766 = _12759 * (_cbSharedPerViewData_raw[82u].y);
                          _12769 = floor(_12765 + -0.5f);
                          _12770 = floor(_12766 + 0.5f);
                          _12772 = floor(_12765 + 0.5f);
                          _12774 = floor(_12766 + -0.5f);
                          _12775 = (_12769 < _12563);
                          _12776 = (_12770 < _12564);
                          if ((_12775 || _12776) | ((_12769 >= _12569) || (_12770 >= _12570))) {
                            _12785 = _12532;
                          } else {
                            _12785 = _12761.x;
                          }
                          _12786 = (_12772 < _12563);
                          if ((_12786 || _12776) | ((_12772 >= _12569) || (_12770 >= _12570))) {
                            _12794 = _12532;
                          } else {
                            _12794 = _12761.y;
                          }
                          _12795 = (_12774 < _12564);
                          if ((_12786 || _12795) | ((_12772 >= _12569) || (_12774 >= _12570))) {
                            _12803 = _12532;
                          } else {
                            _12803 = _12761.z;
                          }
                          if ((_12775 || _12795) | ((_12769 >= _12569) || (_12774 >= _12570))) {
                            _12811 = _12532;
                          } else {
                            _12811 = _12761.w;
                          }
                          _12812 = _12785 - _12512;
                          _12814 = select((_12812 < 0.0f), 0.0f, 1.0f);
                          _12818 = _12794 - _12512;
                          _12820 = select((_12818 < 0.0f), 0.0f, 1.0f);
                          _12824 = _12803 - _12512;
                          _12826 = select((_12824 < 0.0f), 0.0f, 1.0f);
                          _12830 = _12811 - _12512;
                          _12832 = select((_12830 < 0.0f), 0.0f, 1.0f);
                          _12839 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                          _12844 = sqrt((float((int)(_12839)) * 0.25f) + 0.125f) * _12153;
                          _12853 = (_global_7[min((uint)(((int)(0u + (_12839 * 2)))), 127u)]) * _12844;
                          _12854 = (_global_7[min((uint)(((int)(1u + (_12839 * 2)))), 127u)]) * _12844;
                          _12857 = dot(float2(_12853, _12854), float2(_12527, _12526)) + _12502;
                          _12858 = dot(float2(_12853, _12854), float2(_12550, _12527)) + _12503;
                          _12860 = _HeapResource_49.GatherRed(samplerPointClampNode, float2(_12857, _12858));
                          _12864 = _12857 * (_cbSharedPerViewData_raw[82u].x);
                          _12865 = _12858 * (_cbSharedPerViewData_raw[82u].y);
                          _12868 = floor(_12864 + -0.5f);
                          _12869 = floor(_12865 + 0.5f);
                          _12871 = floor(_12864 + 0.5f);
                          _12873 = floor(_12865 + -0.5f);
                          _12874 = (_12868 < _12563);
                          _12875 = (_12869 < _12564);
                          if ((_12874 || _12875) | ((_12868 >= _12569) || (_12869 >= _12570))) {
                            _12884 = _12532;
                          } else {
                            _12884 = _12860.x;
                          }
                          _12885 = (_12871 < _12563);
                          if ((_12885 || _12875) | ((_12871 >= _12569) || (_12869 >= _12570))) {
                            _12893 = _12532;
                          } else {
                            _12893 = _12860.y;
                          }
                          _12894 = (_12873 < _12564);
                          if ((_12885 || _12894) | ((_12871 >= _12569) || (_12873 >= _12570))) {
                            _12902 = _12532;
                          } else {
                            _12902 = _12860.z;
                          }
                          if ((_12874 || _12894) | ((_12868 >= _12569) || (_12873 >= _12570))) {
                            _12910 = _12532;
                          } else {
                            _12910 = _12860.w;
                          }
                          _12911 = _12884 - _12512;
                          _12913 = select((_12911 < 0.0f), 0.0f, 1.0f);
                          _12917 = _12893 - _12512;
                          _12919 = select((_12917 < 0.0f), 0.0f, 1.0f);
                          _12923 = _12902 - _12512;
                          _12925 = select((_12923 < 0.0f), 0.0f, 1.0f);
                          _12929 = _12910 - _12512;
                          _12931 = select((_12929 < 0.0f), 0.0f, 1.0f);
                          _12932 = ((((((((((((((_12622 + _12618) + _12628) + _12634) + _12715) + _12721) + _12727) + _12733) + _12814) + _12820) + _12826) + _12832) + _12913) + _12919) + _12925) + _12931;
                          _12943 = (saturate(_12932 * 0.0625f) * 2.0f) + -1.0f;
                          _12949 = float((int)(((int)(uint)((int)(_12943 > 0.0f))) - ((int)(uint)((int)(_12943 < 0.0f)))));
                          _12951 = 1.0f - (_12949 * _12943);
                          _12953 = (_12951 * _12951) * _12951;
                          _12962 = (0.5f - ((_12949 * 0.5f) * ((1.0f - _12953) - ((_12951 - _12953) * saturate(((1.0f / _12512) * (1.0f / _12932)) * ((((((((((((((((_12622 * _12620) + (_12618 * _12616)) + (_12628 * _12626)) + (_12634 * _12632)) + (_12715 * _12713)) + (_12721 * _12719)) + (_12727 * _12725)) + (_12733 * _12731)) + (_12814 * _12812)) + (_12820 * _12818)) + (_12826 * _12824)) + (_12832 * _12830)) + (_12913 * _12911)) + (_12919 * _12917)) + (_12925 * _12923)) + (_12931 * _12929)))))));
                        } else {
                          _12962 = 1.0f;
                        }
                        _12967 = (lerp(_12962, _12497, _12498));
                      }
                      [branch]
                      if (!((_11892 & 2048) == 0)) {
                        Texture2D<float> _HeapResource_50 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_12098) >> 16))];
                        _12973 = _HeapResource_50.SampleLevel(samplerLinearClampNode, float2(_12187, _12191), 0.0f);
                        if (_12973.x > 0.0f) {
                          Texture2D<float4> _HeapResource_51 = ResourceDescriptorHeap[NonUniformResourceIndex((_12098 & 65535))];
                          _12980 = _HeapResource_51.SampleLevel(samplerLinearClampNode, float2(_12187, _12191), 0.0f);
                          _12994 = mad(saturate(((log2(_12196 * _12083) * 0.6931471824645996f) - (_cbSharedPerViewData_raw[147u].w)) * (_cbSharedPerViewData_raw[148u].x)), 2.0f, -1.0f);
                          _12995 = max(9.999999747378752e-06f, _12973.x);
                          _12996 = _12980.x / _12995;
                          _12997 = _12980.y / _12995;
                          _12999 = _12980.w / _12995;
                          _13004 = ((0.375f - _12997) * 4.999999873689376e-06f) + _12997;
                          _13007 = -0.0f - _12996;
                          _13008 = mad(_13007, _13004, (_12980.z / _12995));
                          _13010 = 1.0f / mad(_13007, _12996, _13004);
                          _13011 = _13010 * _13008;
                          _13016 = _12994 - _12996;
                          _13021 = (((_12994 * _12994) - _13004) - (_13011 * _13016)) / mad((-0.0f - _13008), _13011, mad((-0.0f - _13004), _13004, (((0.375f - _12999) * 4.999999873689376e-06f) + _12999)));
                          _13023 = (_13010 * _13016) - (_13021 * _13011);
                          _13026 = 1.0f / _13021;
                          _13027 = _13023 * _13026;
                          _13032 = sqrt(((_13027 * _13027) * 0.25f) - ((1.0f - dot(float2(_13023, _13021), float2(_12996, _13004))) * _13026));
                          _13034 = (_13027 * -0.5f) - _13032;
                          _13036 = _13032 - (_13027 * 0.5f);
                          _13038 = select((_13034 < _12994), 1.0f, 0.0f);
                          _13043 = (_13038 + -0.05000000074505806f) / (_13034 - _12994);
                          _13049 = (((select((_13036 < _12994), 1.0f, 0.0f) - _13038) / (_13036 - _13034)) - _13043) / (_13036 - _12994);
                          _13051 = _13043 - (_13049 * _13034);
                          _13064 = (exp2((_12973.x * -1.4426950216293335f) * saturate((dot(float2(_12996, _13004), float2((_13051 - (_13049 * _12994)), _13049)) + 0.05000000074505806f) - (_13051 * _12994))) * _12967);
                        } else {
                          _13064 = _12967;
                        }
                      } else {
                        _13064 = _12967;
                      }
                    } else {
                      _13064 = 1.0f;
                    }
                    [branch]
                    if (!(_12142 == 0)) {
                      Texture2D<float3> _HeapResource_52 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _12142)))];
                      _13077 = _HeapResource_52.SampleLevel(samplerLinearWrapNode, float2(((_12187 * f16tof32(((uint)((uint)(_12116) >> 16)))) + f16tof32(((uint)((uint)(_12119) >> 16)))), ((_12191 * f16tof32(_12116)) + f16tof32(_12119))), 0.0f);
                      _13085 = (_13077.x * _12130);
                      _13086 = (_13077.y * _12131);
                      _13087 = (_13077.z * _12133);
                    } else {
                      _13085 = _12130;
                      _13086 = _12131;
                      _13087 = _12133;
                    }
                    _13088 = _13064 * _12225;
                    [branch]
                    if (!(_13088 == 0.0f)) {
                      bool __branch_chain_13090;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _13106 = 0;
                        __branch_chain_13090 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _13106 = 1;
                          __branch_chain_13090 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _13106 = 2;
                            __branch_chain_13090 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _13106 = 3;
                              __branch_chain_13090 = true;
                            } else {
                              _13127 = _13088;
                              __branch_chain_13090 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_13090) {
                        while(true) {
                          _13109 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_80, _81, 0));
                          if (_13106 == 0) {
                            _13123 = _13109.x;
                          } else {
                            if (_13106 == 1) {
                              _13123 = _13109.y;
                            } else {
                              if (_13106 == 2) {
                                _13123 = _13109.z;
                              } else {
                                _13123 = _13109.w;
                              }
                            }
                          }
                          _13127 = ((_13123 * _13123) * _12225);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_13127 == 0.0f)) {
                          [branch]
                          if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                            _13137 = srvLightMappingData[_11895];
                            if (!(_13137 == -1)) {
                              _13142 = srvLightIndexData[_13137].nLayerIndex;
                              _13144 = srvLightIndexData[_13137].vAtlasOrigin.x;
                              _13145 = srvLightIndexData[_13137].vAtlasOrigin.y;
                              _13147 = srvLightIndexData[_13137].vScreenOrigin.x;
                              _13148 = srvLightIndexData[_13137].vScreenOrigin.y;
                              _13157 = ((int)(_13142 * 5)) & 31;
                              _13166 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_13144 + _80) - _13147)), ((int)((_13145 + _81) - _13148)), 0)))).x) & ((int)(31 << _13157)))) >> _13157)) >> 1)))) * 0.06666667014360428f) * _13127);
                            } else {
                              _13166 = _13127;
                            }
                          } else {
                            _13166 = _13127;
                          }
                          _13173 = dot(float3(_12078, _12079, _12080), float3(_12078, _12079, _12080));
                          _13174 = rsqrt(_13173);
                          _13175 = _13174 * _12078;
                          _13176 = _13174 * _12079;
                          _13177 = _13174 * _12080;
                          _13178 = dot(float3(_205, _207, _209), float3(_13175, _13176, _13177));
                          if (_12139 > 0.0f) {
                            _13186 = sqrt(saturate((_12139 * _12139) * (1.0f / (_13173 + 1.0f))));
                            if (_13178 < _13186) {
                              _13191 = max(_13178, (-0.0f - _13186)) + _13186;
                              _13196 = ((_13191 * _13191) / (_13186 * 4.0f));
                            } else {
                              _13196 = _13178;
                            }
                          } else {
                            _13196 = _13178;
                          }
                          _13197 = _231 * _231;
                          _13198 = 1.0f - _13197;
                          _13201 = saturate((_12139 * _13198) * _13174);
                          _13203 = saturate(_13174 * f16tof32(_12092));
                          _13204 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                          _13205 = dot(float3(_257, _258, _256), float3(_13175, _13176, _13177));
                          _13208 = rsqrt((_13205 * 2.0f) + 2.0f);
                          _13211 = saturate(_13208 * (_13204 + _13178));
                          _13214 = saturate((_13208 * _13205) + _13208);
                          _13215 = (_13201 > 0.0f);
                          if (_13215) {
                            _13219 = sqrt(1.0f - (_13201 * _13201));
                            _13221 = (_13178 * 2.0f) * _13204;
                            _13222 = _13221 - _13205;
                            if (!(_13222 >= _13219)) {
                              _13230 = rsqrt(1.0f - (_13222 * _13222)) * _13201;
                              _13233 = _13230 * (_13204 - (_13222 * _13178));
                              _13234 = _13204 * _13204;
                              _13239 = _13230 * (((_13234 * 2.0f) + -1.0f) - (_13222 * _13205));
                              _13248 = sqrt(saturate((((1.0f - (_13178 * _13178)) - _13234) - (_13205 * _13205)) + (_13221 * _13205)));
                              _13249 = _13248 * _13230;
                              _13252 = ((_13204 * 2.0f) * _13230) * _13248;
                              _13254 = (_13219 * _13178) + _13204;
                              _13255 = _13254 + _13233;
                              _13256 = _13219 * _13205;
                              _13258 = (_13256 + 1.0f) + _13239;
                              _13259 = _13249 * _13258;
                              _13260 = _13255 * _13258;
                              _13261 = _13252 * _13255;
                              _13266 = (((_13255 * 0.25f) * _13252) - (_13259 * 0.5f)) * _13260;
                              _13280 = (((_13261 - (_13259 * 2.0f)) * _13261) + (_13259 * _13259)) + ((((-0.5f - ((_13258 + _13256) * 0.5f)) * _13260) + ((_13258 * _13258) * _13254)) * _13255);
                              _13285 = (_13266 * 2.0f) / ((_13280 * _13280) + (_13266 * _13266));
                              _13286 = _13280 * _13285;
                              _13288 = 1.0f - (_13266 * _13285);
                              _13294 = ((_13286 * _13252) + _13256) + (_13288 * _13239);
                              _13297 = rsqrt((_13294 * 2.0f) + 2.0f);
                              _13306 = saturate((_13294 * _13297) + _13297);
                              _13307 = saturate(((_13254 + (_13286 * _13249)) + (_13288 * _13233)) * _13297);
                            } else {
                              _13306 = abs(_13204);
                              _13307 = 1.0f;
                            }
                          } else {
                            _13306 = _13214;
                            _13307 = _13211;
                          }
                          _13308 = saturate(_13196);
                          _13309 = _13197 * _13197;
                          _13310 = (_13203 > 0.0f);
                          if (_13310) {
                            _13319 = saturate(((_13203 * _13203) / ((_13306 * 3.5999999046325684f) + 0.4000000059604645f)) + _13309);
                          } else {
                            _13319 = _13309;
                          }
                          _13320 = sqrt(_13319);
                          if (_13215) {
                            _13331 = (_13319 / ((((_13201 * 0.25f) * ((_13320 * 3.0f) + _13201)) / (_13306 + 0.0010000000474974513f)) + _13319));
                          } else {
                            _13331 = 1.0f;
                          }
                          _13335 = (((_13319 * _13307) - _13307) * _13307) + 1.0f;
                          _13345 = abs(_13204);
                          _13347 = saturate(_13345 + 9.999999747378752e-06f);
                          _13348 = 1.0f - _13320;
                          _13360 = saturate(select((_13198 > 0.0f), 1.0f, 0.0f) * _13201);
                          _13361 = (_13360 > 0.0f);
                          if (_13361) {
                            _13365 = sqrt(1.0f - (_13360 * _13360));
                            _13367 = (_13178 * 2.0f) * _13204;
                            _13368 = _13367 - _13205;
                            if (!(_13368 >= _13365)) {
                              _13374 = rsqrt(1.0f - (_13368 * _13368)) * _13360;
                              _13377 = _13374 * (_13204 - (_13368 * _13178));
                              _13378 = _13204 * _13204;
                              _13383 = _13374 * (((_13378 * 2.0f) + -1.0f) - (_13368 * _13205));
                              _13392 = sqrt(saturate((((1.0f - (_13178 * _13178)) - _13378) - (_13205 * _13205)) + (_13367 * _13205)));
                              _13393 = _13392 * _13374;
                              _13396 = ((_13204 * 2.0f) * _13374) * _13392;
                              _13398 = (_13365 * _13178) + _13204;
                              _13399 = _13398 + _13377;
                              _13400 = _13365 * _13205;
                              _13402 = (_13400 + 1.0f) + _13383;
                              _13403 = _13393 * _13402;
                              _13404 = _13399 * _13402;
                              _13405 = _13396 * _13399;
                              _13410 = (((_13399 * 0.25f) * _13396) - (_13403 * 0.5f)) * _13404;
                              _13424 = (((_13405 - (_13403 * 2.0f)) * _13405) + (_13403 * _13403)) + ((((-0.5f - ((_13402 + _13400) * 0.5f)) * _13404) + ((_13402 * _13402) * _13398)) * _13399);
                              _13429 = (_13410 * 2.0f) / ((_13424 * _13424) + (_13410 * _13410));
                              _13430 = _13424 * _13429;
                              _13432 = 1.0f - (_13410 * _13429);
                              _13438 = ((_13430 * _13396) + _13400) + (_13432 * _13383);
                              _13441 = rsqrt((_13438 * 2.0f) + 2.0f);
                              _13450 = saturate((_13438 * _13441) + _13441);
                              _13451 = saturate(((_13398 + (_13430 * _13393)) + (_13432 * _13377)) * _13441);
                            } else {
                              _13450 = _13345;
                              _13451 = 1.0f;
                            }
                          } else {
                            _13450 = _13214;
                            _13451 = _13211;
                          }
                          if (_13310) {
                            _13460 = saturate(((_13203 * _13203) / ((_13450 * 3.5999999046325684f) + 0.4000000059604645f)) + _13309);
                          } else {
                            _13460 = _13309;
                          }
                          _13461 = sqrt(_13460);
                          if (_13361) {
                            _13472 = (_13460 / ((((_13360 * 0.25f) * ((_13461 * 3.0f) + _13360)) / (_13450 + 0.0010000000474974513f)) + _13460));
                          } else {
                            _13472 = 1.0f;
                          }
                          _13476 = (((_13460 * _13451) - _13451) * _13451) + 1.0f;
                          _13477 = 1.0f - _13461;
                          if (_12137 > 0.0f) {
                            _13508 = ((((exp2(log2(1.0f - saturate(_13450)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_13472 * _13308) * (_13460 / (_13476 * _13476))) * (0.5f / ((((_13477 * _13347) + _13461) * _13308) + (((_13477 * _13308) + _13461) * _13347))))) + ((((_13331 * _13308) * (_13319 / (_13335 * _13335))) * (0.5f / ((((_13348 * _13347) + _13320) * _13308) + (((_13348 * _13308) + _13320) * _13347)))) * ((exp2(log2(1.0f - saturate(_13306)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f));
                            _13510 = (_12137 * _11767) * select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_13166 * _11694), _13166);
                            _19167 = (((_13510 * (_13085 * _11942)) * _13508) + _11884);
                            _19168 = (((_13510 * (_13086 * _11942)) * _13508) + _11885);
                            _19169 = (((_13510 * (_13087 * _11942)) * _13508) + _11886);
                          } else {
                            _19167 = _11884;
                            _19168 = _11885;
                            _19169 = _11886;
                          }
                        } else {
                          _19167 = _11884;
                          _19168 = _11885;
                          _19169 = _11886;
                        }
                        break;
                      }
                    } else {
                      _19167 = _11884;
                      _19168 = _11885;
                      _19169 = _11886;
                    }
                  } else {
                    if (_11925 == 7) {
                      _14084 = asfloat(srvLightInfoProperties.Load3(_11894)).x;
                      _14085 = asfloat(srvLightInfoProperties.Load3(_11894)).y;
                      _14086 = asfloat(srvLightInfoProperties.Load3(_11894)).z;
                      _14089 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 12u)))).x;
                      _14090 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 12u)))).y;
                      _14091 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 12u)))).z;
                      _14094 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 24u)))).x;
                      _14095 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 24u)))).y;
                      _14096 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 24u)))).z;
                      _14099 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 36u)))).x;
                      _14100 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 36u)))).y;
                      _14101 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 36u)))).z;
                      _14104 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).x;
                      _14105 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).y;
                      _14106 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 48u)))).z;
                      _14109 = asint(srvLightInfoProperties.Load(((int)(_11894 + 60u))));
                      _14112 = asint(srvLightInfoProperties.Load(((int)(_11894 + 64u))));
                      _14115 = asint(srvLightInfoProperties.Load(((int)(_11894 + 72u))));
                      _14118 = asint(srvLightInfoProperties.Load(((int)(_11894 + 76u))));
                      _14121 = asint(srvLightInfoProperties.Load(((int)(_11894 + 80u))));
                      _14124 = asint(srvLightInfoProperties.Load(((int)(_11894 + 84u))));
                      _14127 = asint(srvLightInfoProperties.Load(((int)(_11894 + 88u))));
                      _14130 = asint(srvLightInfoProperties.Load(((int)(_11894 + 92u))));
                      _14133 = asint(srvLightInfoProperties.Load(((int)(_11894 + 96u))));
                      _14136 = asint(srvLightInfoProperties.Load(((int)(_11894 + 100u))));
                      _14139 = asint(srvLightInfoProperties.Load(((int)(_11894 + 104u))));
                      _14142 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).x;
                      _14143 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).y;
                      _14144 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).z;
                      _14145 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).w;
                      _14148 = asint(srvLightInfoProperties.Load(((int)(_11894 + 124u))));
                      _14151 = asint(srvLightInfoProperties.Load(((int)(_11894 + 128u))));
                      _14154 = asint(srvLightInfoProperties.Load(((int)(_11894 + 136u))));
                      _14157 = asint(srvLightInfoProperties.Load(((int)(_11894 + 140u))));
                      _14159 = f16tof32(((uint)((uint)(_14109) >> 16)));
                      _14160 = f16tof32(_14109);
                      _14162 = f16tof32(((uint)((uint)(_14112) >> 16)));
                      _14166 = ((float)((uint)((uint)(((uint)(_14112) >> 8) & 255)))) * 0.003921499941498041f;
                      _14167 = f16tof32(_14115);
                      _14169 = f16tof32(((uint)((uint)(_14118) >> 16)));
                      _14173 = f16tof32(_14121);
                      _14175 = f16tof32(((uint)((uint)(_14124) >> 16)));
                      _14176 = f16tof32(_14124);
                      _14178 = f16tof32(((uint)((uint)(_14127) >> 16)));
                      _14181 = _14130 & 65535;
                      _14185 = ((_11892 & 4194304) != 0);
                      _14193 = f16tof32(((uint)((uint)(_14139) >> 16)));
                      _14194 = f16tof32(_14139);
                      _14196 = f16tof32(((uint)((uint)(_14148) >> 16)));
                      _14199 = f16tof32(((uint)((uint)(_14151) >> 16)));
                      _14200 = f16tof32(_14151);
                      _14202 = f16tof32(((uint)((uint)(_14154) >> 16)));
                      _14203 = _14202 + -1.0f;
                      if (_14185) {
                        _14205 = 0.5f / _14202;
                        _14206 = 0.3333333432674408f / _14202;
                        _14210 = (_14202 * 0.5f) + 0.5f;
                        _14220 = (_14205 * _14203);
                        _14221 = (_14206 * _14203);
                        _14222 = (_14205 * _14210);
                        _14223 = (_14206 * _14210);
                        _14224 = (_14202 * 2.0f);
                        _14225 = (_14202 * 3.0f);
                      } else {
                        _14216 = 1.0f / _14202;
                        _14217 = _14216 * _14203;
                        _14218 = _14216 * 0.5f;
                        _14220 = _14217;
                        _14221 = _14217;
                        _14222 = _14218;
                        _14223 = _14218;
                        _14224 = _14202;
                        _14225 = _14202;
                      }
                      _14229 = _14099 - _244;
                      _14230 = _14100 - _245;
                      _14231 = _14101 + _243;
                      _14232 = dot(float3(_14229, _14230, _14231), float3(_14229, _14230, _14231));
                      _14233 = rsqrt(_14232);
                      _14234 = _14233 * _14232;
                      _14235 = _14233 * _14229;
                      _14236 = _14233 * _14230;
                      _14237 = _14233 * _14231;
                      _14240 = max(0.0f, (_14234 - abs(_14173)));
                      _14241 = _14240 * f16tof32(((uint)((uint)(_14121) >> 16)));
                      _14242 = _14241 * _14241;
                      _14245 = saturate(1.0f - (_14242 * _14242));
                      _14252 = (_14245 * _14245) / (select((_14173 < 0.0f), (_14242 * 16.0f), (_14240 * _14240)) + 1.0f);
                      _14265 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_14235, _14236, _14237))) * f16tof32(_14148);
                      _14269 = abs(_14231);
                      _14273 = _14229 - ((_14265 * _205) * _14269);
                      _14274 = _14230 - ((_14265 * _207) * _14269);
                      _14275 = _14231 - ((_14265 * _209) * _14269);
                      _14278 = mad(_14275, _14095, mad(_14274, _14090, (_14273 * _14085)));
                      _14281 = mad(_14275, _14096, mad(_14274, _14091, (_14273 * _14086)));
                      _14283 = ((_11892 & 3584) != 0);
                      if (_14283 && (_14252 > 0.0f)) {
                        _14289 = mad(_14275, _14094, mad(_14274, _14089, (_14273 * _14084)));
                        _14290 = -0.0f - _14281;
                        _14291 = -0.0f - _14278;
                        [branch]
                        if (!((_11892 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_54 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_14130) >> 16))];
                          [branch]
                          if (_14185) {
                            _14296 = abs(_14289);
                            _14297 = abs(_14290);
                            _14298 = abs(_14291);
                            if (_14296 > max(_14297, _14298)) {
                              _14302 = (_14289 > 0.0f);
                              _14317 = select(_14302, 0.0f, 1.0f);
                              _14318 = 0.0f;
                              _14319 = select(_14302, _14278, _14291);
                              _14320 = _14281;
                              _14321 = _14296;
                            } else {
                              if (_14297 > _14298) {
                                _14308 = (_14281 < -0.0f);
                                _14317 = select(_14308, 0.0f, 1.0f);
                                _14318 = 1.0f;
                                _14319 = _14289;
                                _14320 = select(_14308, _14291, _14278);
                                _14321 = _14297;
                              } else {
                                _14312 = (_14278 < -0.0f);
                                _14317 = select(_14312, 0.0f, 1.0f);
                                _14318 = 2.0f;
                                _14319 = select(_14312, _14289, (-0.0f - _14289));
                                _14320 = _14281;
                                _14321 = _14298;
                              }
                            }
                            _14322 = _14321 * 2.0f;
                            _14326 = -0.0f - _14194;
                            _14335 = ((min(max((_14319 / _14322), _14326), _14194) + _14317) * _14220) + _14222;
                            _14336 = ((min(max((_14320 / _14322), _14326), _14194) + _14318) * _14221) + _14223;
                            _14343 = ((_14317 + -0.5f) * _14220) + _14222;
                            _14344 = ((_14318 + -0.5f) * _14221) + _14223;
                            _14347 = saturate((_14196 + 1.0f) - (_14321 * _14178));
                            _14351 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                            _14360 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 10u) : (frac(frac(dot(float2(((_14351 * 32.665000915527344f) + _142), ((_14351 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _14361 = sin(_14360);
                            _14362 = cos(_14360);
                            _14367 = select(((((float4)(_HeapResource_54.SampleLevel(samplerPointBorderWhiteNode, float2(_14335, _14336), 0.0f))).x) > _14347), 1.0f, 0.0f);
                            _14368 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                            _14373 = sqrt((float((int)(_14368)) * 0.25f) + 0.125f) * _14199;
                            _14382 = (_global_7[min((uint)(((int)(0u + (_14368 * 2)))), 127u)]) * _14373;
                            _14383 = (_global_7[min((uint)(((int)(1u + (_14368 * 2)))), 127u)]) * _14373;
                            _14385 = -0.0f - _14361;
                            _14387 = dot(float2(_14382, _14383), float2(_14362, _14361)) + _14335;
                            _14388 = dot(float2(_14382, _14383), float2(_14385, _14362)) + _14336;
                            _14390 = _HeapResource_54.GatherRed(samplerPointClampNode, float2(_14387, _14388));
                            _14394 = _14387 * _14224;
                            _14395 = _14388 * _14225;
                            _14398 = floor(_14343 * _14224);
                            _14399 = floor(_14344 * _14225);
                            _14404 = floor(((_14343 + _14220) * _14224) + 0.5f);
                            _14405 = floor(((_14344 + _14221) * _14225) + 0.5f);
                            _14408 = floor(_14394 + -0.5f);
                            _14409 = floor(_14395 + 0.5f);
                            _14411 = floor(_14394 + 0.5f);
                            _14413 = floor(_14395 + -0.5f);
                            _14414 = (_14408 < _14398);
                            _14415 = (_14409 < _14399);
                            if ((_14414 || _14415) | ((_14408 >= _14404) || (_14409 >= _14405))) {
                              _14424 = _14367;
                            } else {
                              _14424 = _14390.x;
                            }
                            _14425 = (_14411 < _14398);
                            if ((_14425 || _14415) | ((_14411 >= _14404) || (_14409 >= _14405))) {
                              _14433 = _14367;
                            } else {
                              _14433 = _14390.y;
                            }
                            _14434 = (_14413 < _14399);
                            if ((_14425 || _14434) | ((_14411 >= _14404) || (_14413 >= _14405))) {
                              _14442 = _14367;
                            } else {
                              _14442 = _14390.z;
                            }
                            if ((_14414 || _14434) | ((_14408 >= _14404) || (_14413 >= _14405))) {
                              _14450 = _14367;
                            } else {
                              _14450 = _14390.w;
                            }
                            _14451 = _14424 - _14347;
                            _14453 = select((_14451 < 0.0f), 0.0f, 1.0f);
                            _14455 = _14433 - _14347;
                            _14457 = select((_14455 < 0.0f), 0.0f, 1.0f);
                            _14461 = _14442 - _14347;
                            _14463 = select((_14461 < 0.0f), 0.0f, 1.0f);
                            _14467 = _14450 - _14347;
                            _14469 = select((_14467 < 0.0f), 0.0f, 1.0f);
                            _14476 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                            _14481 = sqrt((float((int)(_14476)) * 0.25f) + 0.125f) * _14199;
                            _14490 = (_global_7[min((uint)(((int)(0u + (_14476 * 2)))), 127u)]) * _14481;
                            _14491 = (_global_7[min((uint)(((int)(1u + (_14476 * 2)))), 127u)]) * _14481;
                            _14494 = dot(float2(_14490, _14491), float2(_14362, _14361)) + _14335;
                            _14495 = dot(float2(_14490, _14491), float2(_14385, _14362)) + _14336;
                            _14497 = _HeapResource_54.GatherRed(samplerPointClampNode, float2(_14494, _14495));
                            _14501 = _14494 * _14224;
                            _14502 = _14495 * _14225;
                            _14505 = floor(_14501 + -0.5f);
                            _14506 = floor(_14502 + 0.5f);
                            _14508 = floor(_14501 + 0.5f);
                            _14510 = floor(_14502 + -0.5f);
                            _14511 = (_14505 < _14398);
                            _14512 = (_14506 < _14399);
                            if ((_14511 || _14512) | ((_14505 >= _14404) || (_14506 >= _14405))) {
                              _14521 = _14367;
                            } else {
                              _14521 = _14497.x;
                            }
                            _14522 = (_14508 < _14398);
                            if ((_14522 || _14512) | ((_14508 >= _14404) || (_14506 >= _14405))) {
                              _14530 = _14367;
                            } else {
                              _14530 = _14497.y;
                            }
                            _14531 = (_14510 < _14399);
                            if ((_14522 || _14531) | ((_14508 >= _14404) || (_14510 >= _14405))) {
                              _14539 = _14367;
                            } else {
                              _14539 = _14497.z;
                            }
                            if ((_14511 || _14531) | ((_14505 >= _14404) || (_14510 >= _14405))) {
                              _14547 = _14367;
                            } else {
                              _14547 = _14497.w;
                            }
                            _14548 = _14521 - _14347;
                            _14550 = select((_14548 < 0.0f), 0.0f, 1.0f);
                            _14554 = _14530 - _14347;
                            _14556 = select((_14554 < 0.0f), 0.0f, 1.0f);
                            _14560 = _14539 - _14347;
                            _14562 = select((_14560 < 0.0f), 0.0f, 1.0f);
                            _14566 = _14547 - _14347;
                            _14568 = select((_14566 < 0.0f), 0.0f, 1.0f);
                            _14575 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                            _14580 = sqrt((float((int)(_14575)) * 0.25f) + 0.125f) * _14199;
                            _14589 = (_global_7[min((uint)(((int)(0u + (_14575 * 2)))), 127u)]) * _14580;
                            _14590 = (_global_7[min((uint)(((int)(1u + (_14575 * 2)))), 127u)]) * _14580;
                            _14593 = dot(float2(_14589, _14590), float2(_14362, _14361)) + _14335;
                            _14594 = dot(float2(_14589, _14590), float2(_14385, _14362)) + _14336;
                            _14596 = _HeapResource_54.GatherRed(samplerPointClampNode, float2(_14593, _14594));
                            _14600 = _14593 * _14224;
                            _14601 = _14594 * _14225;
                            _14604 = floor(_14600 + -0.5f);
                            _14605 = floor(_14601 + 0.5f);
                            _14607 = floor(_14600 + 0.5f);
                            _14609 = floor(_14601 + -0.5f);
                            _14610 = (_14604 < _14398);
                            _14611 = (_14605 < _14399);
                            if ((_14610 || _14611) | ((_14604 >= _14404) || (_14605 >= _14405))) {
                              _14620 = _14367;
                            } else {
                              _14620 = _14596.x;
                            }
                            _14621 = (_14607 < _14398);
                            if ((_14621 || _14611) | ((_14607 >= _14404) || (_14605 >= _14405))) {
                              _14629 = _14367;
                            } else {
                              _14629 = _14596.y;
                            }
                            _14630 = (_14609 < _14399);
                            if ((_14621 || _14630) | ((_14607 >= _14404) || (_14609 >= _14405))) {
                              _14638 = _14367;
                            } else {
                              _14638 = _14596.z;
                            }
                            if ((_14610 || _14630) | ((_14604 >= _14404) || (_14609 >= _14405))) {
                              _14646 = _14367;
                            } else {
                              _14646 = _14596.w;
                            }
                            _14647 = _14620 - _14347;
                            _14649 = select((_14647 < 0.0f), 0.0f, 1.0f);
                            _14653 = _14629 - _14347;
                            _14655 = select((_14653 < 0.0f), 0.0f, 1.0f);
                            _14659 = _14638 - _14347;
                            _14661 = select((_14659 < 0.0f), 0.0f, 1.0f);
                            _14665 = _14646 - _14347;
                            _14667 = select((_14665 < 0.0f), 0.0f, 1.0f);
                            _14674 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                            _14679 = sqrt((float((int)(_14674)) * 0.25f) + 0.125f) * _14199;
                            _14688 = (_global_7[min((uint)(((int)(0u + (_14674 * 2)))), 127u)]) * _14679;
                            _14689 = (_global_7[min((uint)(((int)(1u + (_14674 * 2)))), 127u)]) * _14679;
                            _14692 = dot(float2(_14688, _14689), float2(_14362, _14361)) + _14335;
                            _14693 = dot(float2(_14688, _14689), float2(_14385, _14362)) + _14336;
                            _14695 = _HeapResource_54.GatherRed(samplerPointClampNode, float2(_14692, _14693));
                            _14699 = _14692 * _14224;
                            _14700 = _14693 * _14225;
                            _14703 = floor(_14699 + -0.5f);
                            _14704 = floor(_14700 + 0.5f);
                            _14706 = floor(_14699 + 0.5f);
                            _14708 = floor(_14700 + -0.5f);
                            _14709 = (_14703 < _14398);
                            _14710 = (_14704 < _14399);
                            if ((_14709 || _14710) | ((_14703 >= _14404) || (_14704 >= _14405))) {
                              _14719 = _14367;
                            } else {
                              _14719 = _14695.x;
                            }
                            _14720 = (_14706 < _14398);
                            if ((_14720 || _14710) | ((_14706 >= _14404) || (_14704 >= _14405))) {
                              _14728 = _14367;
                            } else {
                              _14728 = _14695.y;
                            }
                            _14729 = (_14708 < _14399);
                            if ((_14720 || _14729) | ((_14706 >= _14404) || (_14708 >= _14405))) {
                              _14737 = _14367;
                            } else {
                              _14737 = _14695.z;
                            }
                            if ((_14709 || _14729) | ((_14703 >= _14404) || (_14708 >= _14405))) {
                              _14745 = _14367;
                            } else {
                              _14745 = _14695.w;
                            }
                            _14746 = _14719 - _14347;
                            _14748 = select((_14746 < 0.0f), 0.0f, 1.0f);
                            _14752 = _14728 - _14347;
                            _14754 = select((_14752 < 0.0f), 0.0f, 1.0f);
                            _14758 = _14737 - _14347;
                            _14760 = select((_14758 < 0.0f), 0.0f, 1.0f);
                            _14764 = _14745 - _14347;
                            _14766 = select((_14764 < 0.0f), 0.0f, 1.0f);
                            _14767 = ((((((((((((((_14457 + _14453) + _14463) + _14469) + _14550) + _14556) + _14562) + _14568) + _14649) + _14655) + _14661) + _14667) + _14748) + _14754) + _14760) + _14766;
                            _14778 = (saturate(_14767 * 0.0625f) * 2.0f) + -1.0f;
                            _14784 = float((int)(((int)(uint)((int)(_14778 > 0.0f))) - ((int)(uint)((int)(_14778 < 0.0f)))));
                            _14786 = 1.0f - (_14784 * _14778);
                            _14788 = (_14786 * _14786) * _14786;
                            _15080 = (0.5f - ((_14784 * 0.5f) * ((1.0f - _14788) - ((_14786 - _14788) * saturate(((1.0f / _14347) * (1.0f / _14767)) * ((((((((((((((((_14457 * _14455) + (_14453 * _14451)) + (_14463 * _14461)) + (_14469 * _14467)) + (_14550 * _14548)) + (_14556 * _14554)) + (_14562 * _14560)) + (_14568 * _14566)) + (_14649 * _14647)) + (_14655 * _14653)) + (_14661 * _14659)) + (_14667 * _14665)) + (_14748 * _14746)) + (_14754 * _14752)) + (_14760 * _14758)) + (_14766 * _14764)))))));
                            _15081 = 1.0f;
                            _15082 = 1;
                          } else {
                            _14797 = f16tof32(_14157) / _14291;
                            _14800 = mad((_14797 * _14289), 0.5f, 0.5f);
                            _14801 = mad((_14797 * _14290), 0.5f, 0.5f);
                            if (_14278 > -0.0f) {
                              if ((saturate(_14800) == _14800) && (saturate(_14801) == _14801)) {
                                _14815 = (_14800 * _14220) + _14222;
                                _14816 = (_14801 * _14221) + _14223;
                                _14817 = saturate((_14196 + 1.0f) - (_14278 * _14178));
                                _14821 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                                _14830 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 11u) : (frac(frac(dot(float2(((_14821 * 32.665000915527344f) + _142), ((_14821 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _14831 = sin(_14830);
                                _14832 = cos(_14830);
                                _14833 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                                _14838 = sqrt((float((int)(_14833)) * 0.25f) + 0.125f) * _14199;
                                _14847 = (_global_7[min((uint)(((int)(0u + (_14833 * 2)))), 127u)]) * _14838;
                                _14848 = (_global_7[min((uint)(((int)(1u + (_14833 * 2)))), 127u)]) * _14838;
                                _14850 = -0.0f - _14831;
                                _14855 = _HeapResource_54.GatherRed(samplerPointClampNode, float2((dot(float2(_14847, _14848), float2(_14832, _14831)) + _14815), (dot(float2(_14847, _14848), float2(_14850, _14832)) + _14816)));
                                _14860 = _14855.x - _14817;
                                _14862 = select((_14860 < 0.0f), 0.0f, 1.0f);
                                _14864 = _14855.y - _14817;
                                _14866 = select((_14864 < 0.0f), 0.0f, 1.0f);
                                _14870 = _14855.z - _14817;
                                _14872 = select((_14870 < 0.0f), 0.0f, 1.0f);
                                _14876 = _14855.w - _14817;
                                _14878 = select((_14876 < 0.0f), 0.0f, 1.0f);
                                _14885 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                                _14890 = sqrt((float((int)(_14885)) * 0.25f) + 0.125f) * _14199;
                                _14899 = (_global_7[min((uint)(((int)(0u + (_14885 * 2)))), 127u)]) * _14890;
                                _14900 = (_global_7[min((uint)(((int)(1u + (_14885 * 2)))), 127u)]) * _14890;
                                _14906 = _HeapResource_54.GatherRed(samplerPointClampNode, float2((dot(float2(_14899, _14900), float2(_14832, _14831)) + _14815), (dot(float2(_14899, _14900), float2(_14850, _14832)) + _14816)));
                                _14911 = _14906.x - _14817;
                                _14913 = select((_14911 < 0.0f), 0.0f, 1.0f);
                                _14917 = _14906.y - _14817;
                                _14919 = select((_14917 < 0.0f), 0.0f, 1.0f);
                                _14923 = _14906.z - _14817;
                                _14925 = select((_14923 < 0.0f), 0.0f, 1.0f);
                                _14929 = _14906.w - _14817;
                                _14931 = select((_14929 < 0.0f), 0.0f, 1.0f);
                                _14938 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                                _14943 = sqrt((float((int)(_14938)) * 0.25f) + 0.125f) * _14199;
                                _14952 = (_global_7[min((uint)(((int)(0u + (_14938 * 2)))), 127u)]) * _14943;
                                _14953 = (_global_7[min((uint)(((int)(1u + (_14938 * 2)))), 127u)]) * _14943;
                                _14959 = _HeapResource_54.GatherRed(samplerPointClampNode, float2((dot(float2(_14952, _14953), float2(_14832, _14831)) + _14815), (dot(float2(_14952, _14953), float2(_14850, _14832)) + _14816)));
                                _14964 = _14959.x - _14817;
                                _14966 = select((_14964 < 0.0f), 0.0f, 1.0f);
                                _14970 = _14959.y - _14817;
                                _14972 = select((_14970 < 0.0f), 0.0f, 1.0f);
                                _14976 = _14959.z - _14817;
                                _14978 = select((_14976 < 0.0f), 0.0f, 1.0f);
                                _14982 = _14959.w - _14817;
                                _14984 = select((_14982 < 0.0f), 0.0f, 1.0f);
                                _14991 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                                _14996 = sqrt((float((int)(_14991)) * 0.25f) + 0.125f) * _14199;
                                _15005 = (_global_7[min((uint)(((int)(0u + (_14991 * 2)))), 127u)]) * _14996;
                                _15006 = (_global_7[min((uint)(((int)(1u + (_14991 * 2)))), 127u)]) * _14996;
                                _15012 = _HeapResource_54.GatherRed(samplerPointClampNode, float2((dot(float2(_15005, _15006), float2(_14832, _14831)) + _14815), (dot(float2(_15005, _15006), float2(_14850, _14832)) + _14816)));
                                _15017 = _15012.x - _14817;
                                _15019 = select((_15017 < 0.0f), 0.0f, 1.0f);
                                _15023 = _15012.y - _14817;
                                _15025 = select((_15023 < 0.0f), 0.0f, 1.0f);
                                _15029 = _15012.z - _14817;
                                _15031 = select((_15029 < 0.0f), 0.0f, 1.0f);
                                _15035 = _15012.w - _14817;
                                _15037 = select((_15035 < 0.0f), 0.0f, 1.0f);
                                _15038 = ((((((((((((((_14862 + _14866) + _14872) + _14878) + _14913) + _14919) + _14925) + _14931) + _14966) + _14972) + _14978) + _14984) + _15019) + _15025) + _15031) + _15037;
                                _15049 = (saturate(_15038 * 0.0625f) * 2.0f) + -1.0f;
                                _15055 = float((int)(((int)(uint)((int)(_15049 > 0.0f))) - ((int)(uint)((int)(_15049 < 0.0f)))));
                                _15057 = 1.0f - (_15055 * _15049);
                                _15059 = (_15057 * _15057) * _15057;
                                _15067 = -0.0f - _14289;
                                _15074 = saturate((saturate(rsqrt(dot(float3(_15067, _14281, _14278), float3(_15067, _14281, _14278))) * _14278) * _14176) + _14175);
                                _15076 = 1.0f - (_15074 * _15074);
                                _15080 = (0.5f - ((_15055 * 0.5f) * ((1.0f - _15059) - ((_15057 - _15059) * saturate(((1.0f / _14817) * (1.0f / _15038)) * ((((((((((((((((_14862 * _14860) + (_14866 * _14864)) + (_14872 * _14870)) + (_14878 * _14876)) + (_14913 * _14911)) + (_14919 * _14917)) + (_14925 * _14923)) + (_14931 * _14929)) + (_14966 * _14964)) + (_14972 * _14970)) + (_14978 * _14976)) + (_14984 * _14982)) + (_15019 * _15017)) + (_15025 * _15023)) + (_15031 * _15029)) + (_15037 * _15035)))))));
                                _15081 = (1.0f - (_15076 * _15076));
                                _15082 = 1;
                              } else {
                                _15080 = 1.0f;
                                _15081 = 1.0f;
                                _15082 = 0;
                              }
                            } else {
                              _15080 = 1.0f;
                              _15081 = 1.0f;
                              _15082 = 0;
                            }
                          }
                        } else {
                          _15080 = 1.0f;
                          _15081 = 1.0f;
                          _15082 = 0;
                        }
                        [branch]
                        if (!((_11892 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_55 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_11892 & 2097152) == 0)) {
                            _15090 = abs(_14289);
                            _15091 = abs(_14290);
                            _15092 = abs(_14291);
                            if (_15090 > max(_15091, _15092)) {
                              _15096 = (_14289 > 0.0f);
                              _15111 = select(_15096, 0.0f, 1.0f);
                              _15112 = 0.0f;
                              _15113 = select(_15096, _14278, _14291);
                              _15114 = _14281;
                              _15115 = _15090;
                            } else {
                              if (_15091 > _15092) {
                                _15102 = (_14281 < -0.0f);
                                _15111 = select(_15102, 0.0f, 1.0f);
                                _15112 = 1.0f;
                                _15113 = _14289;
                                _15114 = select(_15102, _14291, _14278);
                                _15115 = _15091;
                              } else {
                                _15106 = (_14278 < -0.0f);
                                _15111 = select(_15106, 0.0f, 1.0f);
                                _15112 = 2.0f;
                                _15113 = select(_15106, _14289, (-0.0f - _14289));
                                _15114 = _14281;
                                _15115 = _15092;
                              }
                            }
                            _15116 = _15115 * 2.0f;
                            _15121 = -0.0f - _14193;
                            _15130 = ((min(max((_15113 / _15116), _15121), _14193) + _15111) * _14142) + _14144;
                            _15131 = ((min(max((_15114 / _15116), _15121), _14193) + _15112) * _14143) + _14145;
                            _15136 = ((_15111 + -0.5f) * _14142) + _14144;
                            _15137 = ((_15112 + -0.5f) * _14143) + _14145;
                            _15140 = saturate(1.0f - (_15115 * _14178));
                            _15144 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                            _15153 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 12u) : (frac(frac(dot(float2(((_15144 * 32.665000915527344f) + _142), ((_15144 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _15154 = sin(_15153);
                            _15155 = cos(_15153);
                            _15160 = select(((((float4)(_HeapResource_55.SampleLevel(samplerPointBorderWhiteNode, float2(_15130, _15131), 0.0f))).x) > _15140), 1.0f, 0.0f);
                            _15161 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                            _15166 = sqrt((float((int)(_15161)) * 0.25f) + 0.125f) * _14200;
                            _15175 = (_global_7[min((uint)(((int)(0u + (_15161 * 2)))), 127u)]) * _15166;
                            _15176 = (_global_7[min((uint)(((int)(1u + (_15161 * 2)))), 127u)]) * _15166;
                            _15178 = -0.0f - _15154;
                            _15180 = dot(float2(_15175, _15176), float2(_15155, _15154)) + _15130;
                            _15181 = dot(float2(_15175, _15176), float2(_15178, _15155)) + _15131;
                            _15183 = _HeapResource_55.GatherRed(samplerPointClampNode, float2(_15180, _15181));
                            _15187 = _15180 * (_cbSharedPerViewData_raw[82u].x);
                            _15188 = _15181 * (_cbSharedPerViewData_raw[82u].y);
                            _15191 = floor(_15136 * (_cbSharedPerViewData_raw[82u].x));
                            _15192 = floor(_15137 * (_cbSharedPerViewData_raw[82u].y));
                            _15197 = floor(((_15136 + _14142) * (_cbSharedPerViewData_raw[82u].x)) + 0.5f);
                            _15198 = floor(((_15137 + _14143) * (_cbSharedPerViewData_raw[82u].y)) + 0.5f);
                            _15201 = floor(_15187 + -0.5f);
                            _15202 = floor(_15188 + 0.5f);
                            _15204 = floor(_15187 + 0.5f);
                            _15206 = floor(_15188 + -0.5f);
                            _15207 = (_15201 < _15191);
                            _15208 = (_15202 < _15192);
                            if ((_15207 || _15208) | ((_15201 >= _15197) || (_15202 >= _15198))) {
                              _15217 = _15160;
                            } else {
                              _15217 = _15183.x;
                            }
                            _15218 = (_15204 < _15191);
                            if ((_15218 || _15208) | ((_15204 >= _15197) || (_15202 >= _15198))) {
                              _15226 = _15160;
                            } else {
                              _15226 = _15183.y;
                            }
                            _15227 = (_15206 < _15192);
                            if ((_15218 || _15227) | ((_15204 >= _15197) || (_15206 >= _15198))) {
                              _15235 = _15160;
                            } else {
                              _15235 = _15183.z;
                            }
                            if ((_15207 || _15227) | ((_15201 >= _15197) || (_15206 >= _15198))) {
                              _15243 = _15160;
                            } else {
                              _15243 = _15183.w;
                            }
                            _15244 = _15217 - _15140;
                            _15246 = select((_15244 < 0.0f), 0.0f, 1.0f);
                            _15248 = _15226 - _15140;
                            _15250 = select((_15248 < 0.0f), 0.0f, 1.0f);
                            _15254 = _15235 - _15140;
                            _15256 = select((_15254 < 0.0f), 0.0f, 1.0f);
                            _15260 = _15243 - _15140;
                            _15262 = select((_15260 < 0.0f), 0.0f, 1.0f);
                            _15269 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                            _15274 = sqrt((float((int)(_15269)) * 0.25f) + 0.125f) * _14200;
                            _15283 = (_global_7[min((uint)(((int)(0u + (_15269 * 2)))), 127u)]) * _15274;
                            _15284 = (_global_7[min((uint)(((int)(1u + (_15269 * 2)))), 127u)]) * _15274;
                            _15287 = dot(float2(_15283, _15284), float2(_15155, _15154)) + _15130;
                            _15288 = dot(float2(_15283, _15284), float2(_15178, _15155)) + _15131;
                            _15290 = _HeapResource_55.GatherRed(samplerPointClampNode, float2(_15287, _15288));
                            _15294 = _15287 * (_cbSharedPerViewData_raw[82u].x);
                            _15295 = _15288 * (_cbSharedPerViewData_raw[82u].y);
                            _15298 = floor(_15294 + -0.5f);
                            _15299 = floor(_15295 + 0.5f);
                            _15301 = floor(_15294 + 0.5f);
                            _15303 = floor(_15295 + -0.5f);
                            _15304 = (_15298 < _15191);
                            _15305 = (_15299 < _15192);
                            if ((_15304 || _15305) | ((_15298 >= _15197) || (_15299 >= _15198))) {
                              _15314 = _15160;
                            } else {
                              _15314 = _15290.x;
                            }
                            _15315 = (_15301 < _15191);
                            if ((_15315 || _15305) | ((_15301 >= _15197) || (_15299 >= _15198))) {
                              _15323 = _15160;
                            } else {
                              _15323 = _15290.y;
                            }
                            _15324 = (_15303 < _15192);
                            if ((_15315 || _15324) | ((_15301 >= _15197) || (_15303 >= _15198))) {
                              _15332 = _15160;
                            } else {
                              _15332 = _15290.z;
                            }
                            if ((_15304 || _15324) | ((_15298 >= _15197) || (_15303 >= _15198))) {
                              _15340 = _15160;
                            } else {
                              _15340 = _15290.w;
                            }
                            _15341 = _15314 - _15140;
                            _15343 = select((_15341 < 0.0f), 0.0f, 1.0f);
                            _15347 = _15323 - _15140;
                            _15349 = select((_15347 < 0.0f), 0.0f, 1.0f);
                            _15353 = _15332 - _15140;
                            _15355 = select((_15353 < 0.0f), 0.0f, 1.0f);
                            _15359 = _15340 - _15140;
                            _15361 = select((_15359 < 0.0f), 0.0f, 1.0f);
                            _15368 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                            _15373 = sqrt((float((int)(_15368)) * 0.25f) + 0.125f) * _14200;
                            _15382 = (_global_7[min((uint)(((int)(0u + (_15368 * 2)))), 127u)]) * _15373;
                            _15383 = (_global_7[min((uint)(((int)(1u + (_15368 * 2)))), 127u)]) * _15373;
                            _15386 = dot(float2(_15382, _15383), float2(_15155, _15154)) + _15130;
                            _15387 = dot(float2(_15382, _15383), float2(_15178, _15155)) + _15131;
                            _15389 = _HeapResource_55.GatherRed(samplerPointClampNode, float2(_15386, _15387));
                            _15393 = _15386 * (_cbSharedPerViewData_raw[82u].x);
                            _15394 = _15387 * (_cbSharedPerViewData_raw[82u].y);
                            _15397 = floor(_15393 + -0.5f);
                            _15398 = floor(_15394 + 0.5f);
                            _15400 = floor(_15393 + 0.5f);
                            _15402 = floor(_15394 + -0.5f);
                            _15403 = (_15397 < _15191);
                            _15404 = (_15398 < _15192);
                            if ((_15403 || _15404) | ((_15397 >= _15197) || (_15398 >= _15198))) {
                              _15413 = _15160;
                            } else {
                              _15413 = _15389.x;
                            }
                            _15414 = (_15400 < _15191);
                            if ((_15414 || _15404) | ((_15400 >= _15197) || (_15398 >= _15198))) {
                              _15422 = _15160;
                            } else {
                              _15422 = _15389.y;
                            }
                            _15423 = (_15402 < _15192);
                            if ((_15414 || _15423) | ((_15400 >= _15197) || (_15402 >= _15198))) {
                              _15431 = _15160;
                            } else {
                              _15431 = _15389.z;
                            }
                            if ((_15403 || _15423) | ((_15397 >= _15197) || (_15402 >= _15198))) {
                              _15439 = _15160;
                            } else {
                              _15439 = _15389.w;
                            }
                            _15440 = _15413 - _15140;
                            _15442 = select((_15440 < 0.0f), 0.0f, 1.0f);
                            _15446 = _15422 - _15140;
                            _15448 = select((_15446 < 0.0f), 0.0f, 1.0f);
                            _15452 = _15431 - _15140;
                            _15454 = select((_15452 < 0.0f), 0.0f, 1.0f);
                            _15458 = _15439 - _15140;
                            _15460 = select((_15458 < 0.0f), 0.0f, 1.0f);
                            _15467 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                            _15472 = sqrt((float((int)(_15467)) * 0.25f) + 0.125f) * _14200;
                            _15481 = (_global_7[min((uint)(((int)(0u + (_15467 * 2)))), 127u)]) * _15472;
                            _15482 = (_global_7[min((uint)(((int)(1u + (_15467 * 2)))), 127u)]) * _15472;
                            _15485 = dot(float2(_15481, _15482), float2(_15155, _15154)) + _15130;
                            _15486 = dot(float2(_15481, _15482), float2(_15178, _15155)) + _15131;
                            _15488 = _HeapResource_55.GatherRed(samplerPointClampNode, float2(_15485, _15486));
                            _15492 = _15485 * (_cbSharedPerViewData_raw[82u].x);
                            _15493 = _15486 * (_cbSharedPerViewData_raw[82u].y);
                            _15496 = floor(_15492 + -0.5f);
                            _15497 = floor(_15493 + 0.5f);
                            _15499 = floor(_15492 + 0.5f);
                            _15501 = floor(_15493 + -0.5f);
                            _15502 = (_15496 < _15191);
                            _15503 = (_15497 < _15192);
                            if ((_15502 || _15503) | ((_15496 >= _15197) || (_15497 >= _15198))) {
                              _15512 = _15160;
                            } else {
                              _15512 = _15488.x;
                            }
                            _15513 = (_15499 < _15191);
                            if ((_15513 || _15503) | ((_15499 >= _15197) || (_15497 >= _15198))) {
                              _15521 = _15160;
                            } else {
                              _15521 = _15488.y;
                            }
                            _15522 = (_15501 < _15192);
                            if ((_15513 || _15522) | ((_15499 >= _15197) || (_15501 >= _15198))) {
                              _15530 = _15160;
                            } else {
                              _15530 = _15488.z;
                            }
                            if ((_15502 || _15522) | ((_15496 >= _15197) || (_15501 >= _15198))) {
                              _15538 = _15160;
                            } else {
                              _15538 = _15488.w;
                            }
                            _15539 = _15512 - _15140;
                            _15541 = select((_15539 < 0.0f), 0.0f, 1.0f);
                            _15545 = _15521 - _15140;
                            _15547 = select((_15545 < 0.0f), 0.0f, 1.0f);
                            _15551 = _15530 - _15140;
                            _15553 = select((_15551 < 0.0f), 0.0f, 1.0f);
                            _15557 = _15538 - _15140;
                            _15559 = select((_15557 < 0.0f), 0.0f, 1.0f);
                            _15560 = ((((((((((((((_15250 + _15246) + _15256) + _15262) + _15343) + _15349) + _15355) + _15361) + _15442) + _15448) + _15454) + _15460) + _15541) + _15547) + _15553) + _15559;
                            _15571 = (saturate(_15560 * 0.0625f) * 2.0f) + -1.0f;
                            _15577 = float((int)(((int)(uint)((int)(_15571 > 0.0f))) - ((int)(uint)((int)(_15571 < 0.0f)))));
                            _15579 = 1.0f - (_15577 * _15571);
                            _15581 = (_15579 * _15579) * _15579;
                            _15872 = (0.5f - ((_15577 * 0.5f) * ((1.0f - _15581) - ((_15579 - _15581) * saturate(((1.0f / _15140) * (1.0f / _15560)) * ((((((((((((((((_15250 * _15248) + (_15246 * _15244)) + (_15256 * _15254)) + (_15262 * _15260)) + (_15343 * _15341)) + (_15349 * _15347)) + (_15355 * _15353)) + (_15361 * _15359)) + (_15442 * _15440)) + (_15448 * _15446)) + (_15454 * _15452)) + (_15460 * _15458)) + (_15541 * _15539)) + (_15547 * _15545)) + (_15553 * _15551)) + (_15559 * _15557)))))));
                            _15873 = 1.0f;
                            _15874 = false;
                          } else {
                            _15590 = f16tof32(((uint)((uint)(_14157) >> 16))) / _14291;
                            _15593 = mad((_15590 * _14289), 0.5f, 0.5f);
                            _15594 = mad((_15590 * _14290), 0.5f, 0.5f);
                            if (_14278 > -0.0f) {
                              if ((saturate(_15593) == _15593) && (saturate(_15594) == _15594)) {
                                _15607 = (_15593 * _14142) + _14144;
                                _15608 = (_15594 * _14143) + _14145;
                                _15609 = saturate(1.0f - (_14278 * _14178));
                                _15613 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                                _15622 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 13u) : (frac(frac(dot(float2(((_15613 * 32.665000915527344f) + _142), ((_15613 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _15623 = sin(_15622);
                                _15624 = cos(_15622);
                                _15625 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                                _15630 = sqrt((float((int)(_15625)) * 0.25f) + 0.125f) * _14200;
                                _15639 = (_global_7[min((uint)(((int)(0u + (_15625 * 2)))), 127u)]) * _15630;
                                _15640 = (_global_7[min((uint)(((int)(1u + (_15625 * 2)))), 127u)]) * _15630;
                                _15642 = -0.0f - _15623;
                                _15647 = _HeapResource_55.GatherRed(samplerPointClampNode, float2((dot(float2(_15639, _15640), float2(_15624, _15623)) + _15607), (dot(float2(_15639, _15640), float2(_15642, _15624)) + _15608)));
                                _15652 = _15647.x - _15609;
                                _15654 = select((_15652 < 0.0f), 0.0f, 1.0f);
                                _15656 = _15647.y - _15609;
                                _15658 = select((_15656 < 0.0f), 0.0f, 1.0f);
                                _15662 = _15647.z - _15609;
                                _15664 = select((_15662 < 0.0f), 0.0f, 1.0f);
                                _15668 = _15647.w - _15609;
                                _15670 = select((_15668 < 0.0f), 0.0f, 1.0f);
                                _15677 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                                _15682 = sqrt((float((int)(_15677)) * 0.25f) + 0.125f) * _14200;
                                _15691 = (_global_7[min((uint)(((int)(0u + (_15677 * 2)))), 127u)]) * _15682;
                                _15692 = (_global_7[min((uint)(((int)(1u + (_15677 * 2)))), 127u)]) * _15682;
                                _15698 = _HeapResource_55.GatherRed(samplerPointClampNode, float2((dot(float2(_15691, _15692), float2(_15624, _15623)) + _15607), (dot(float2(_15691, _15692), float2(_15642, _15624)) + _15608)));
                                _15703 = _15698.x - _15609;
                                _15705 = select((_15703 < 0.0f), 0.0f, 1.0f);
                                _15709 = _15698.y - _15609;
                                _15711 = select((_15709 < 0.0f), 0.0f, 1.0f);
                                _15715 = _15698.z - _15609;
                                _15717 = select((_15715 < 0.0f), 0.0f, 1.0f);
                                _15721 = _15698.w - _15609;
                                _15723 = select((_15721 < 0.0f), 0.0f, 1.0f);
                                _15730 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                                _15735 = sqrt((float((int)(_15730)) * 0.25f) + 0.125f) * _14200;
                                _15744 = (_global_7[min((uint)(((int)(0u + (_15730 * 2)))), 127u)]) * _15735;
                                _15745 = (_global_7[min((uint)(((int)(1u + (_15730 * 2)))), 127u)]) * _15735;
                                _15751 = _HeapResource_55.GatherRed(samplerPointClampNode, float2((dot(float2(_15744, _15745), float2(_15624, _15623)) + _15607), (dot(float2(_15744, _15745), float2(_15642, _15624)) + _15608)));
                                _15756 = _15751.x - _15609;
                                _15758 = select((_15756 < 0.0f), 0.0f, 1.0f);
                                _15762 = _15751.y - _15609;
                                _15764 = select((_15762 < 0.0f), 0.0f, 1.0f);
                                _15768 = _15751.z - _15609;
                                _15770 = select((_15768 < 0.0f), 0.0f, 1.0f);
                                _15774 = _15751.w - _15609;
                                _15776 = select((_15774 < 0.0f), 0.0f, 1.0f);
                                _15783 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                                _15788 = sqrt((float((int)(_15783)) * 0.25f) + 0.125f) * _14200;
                                _15797 = (_global_7[min((uint)(((int)(0u + (_15783 * 2)))), 127u)]) * _15788;
                                _15798 = (_global_7[min((uint)(((int)(1u + (_15783 * 2)))), 127u)]) * _15788;
                                _15804 = _HeapResource_55.GatherRed(samplerPointClampNode, float2((dot(float2(_15797, _15798), float2(_15624, _15623)) + _15607), (dot(float2(_15797, _15798), float2(_15642, _15624)) + _15608)));
                                _15809 = _15804.x - _15609;
                                _15811 = select((_15809 < 0.0f), 0.0f, 1.0f);
                                _15815 = _15804.y - _15609;
                                _15817 = select((_15815 < 0.0f), 0.0f, 1.0f);
                                _15821 = _15804.z - _15609;
                                _15823 = select((_15821 < 0.0f), 0.0f, 1.0f);
                                _15827 = _15804.w - _15609;
                                _15829 = select((_15827 < 0.0f), 0.0f, 1.0f);
                                _15830 = ((((((((((((((_15654 + _15658) + _15664) + _15670) + _15705) + _15711) + _15717) + _15723) + _15758) + _15764) + _15770) + _15776) + _15811) + _15817) + _15823) + _15829;
                                _15841 = (saturate(_15830 * 0.0625f) * 2.0f) + -1.0f;
                                _15847 = float((int)(((int)(uint)((int)(_15841 > 0.0f))) - ((int)(uint)((int)(_15841 < 0.0f)))));
                                _15849 = 1.0f - (_15847 * _15841);
                                _15851 = (_15849 * _15849) * _15849;
                                _15859 = -0.0f - _14289;
                                _15866 = saturate((saturate(rsqrt(dot(float3(_15859, _14281, _14278), float3(_15859, _14281, _14278))) * _14278) * _14176) + _14175);
                                _15868 = 1.0f - (_15866 * _15866);
                                _15872 = (0.5f - ((_15847 * 0.5f) * ((1.0f - _15851) - ((_15849 - _15851) * saturate(((1.0f / _15609) * (1.0f / _15830)) * ((((((((((((((((_15654 * _15652) + (_15658 * _15656)) + (_15664 * _15662)) + (_15670 * _15668)) + (_15705 * _15703)) + (_15711 * _15709)) + (_15717 * _15715)) + (_15723 * _15721)) + (_15758 * _15756)) + (_15764 * _15762)) + (_15770 * _15768)) + (_15776 * _15774)) + (_15811 * _15809)) + (_15817 * _15815)) + (_15823 * _15821)) + (_15829 * _15827)))))));
                                _15873 = (1.0f - (_15868 * _15868));
                                _15874 = false;
                              } else {
                                _15872 = 1.0f;
                                _15873 = 1.0f;
                                _15874 = true;
                              }
                            } else {
                              _15872 = 1.0f;
                              _15873 = 1.0f;
                              _15874 = true;
                            }
                          }
                        } else {
                          _15872 = 1.0f;
                          _15873 = 1.0f;
                          _15874 = true;
                        }
                        if (_15082 == 0) {
                          if (!_15874) {
                            _15889 = _15080;
                            _15890 = ((_15873 * (_15872 + -1.0f)) + 1.0f);
                            _15891 = 0.0f;
                          } else {
                            _15889 = _15080;
                            _15890 = _15872;
                            _15891 = 0.0f;
                          }
                        } else {
                          if (_15874) {
                            _15889 = ((_15081 * (_15080 + -1.0f)) + 1.0f);
                            _15890 = _15872;
                            _15891 = 1.0f;
                          } else {
                            _15889 = _15080;
                            _15890 = _15872;
                            _15891 = (_15081 * f16tof32(_14127));
                          }
                        }
                        _15894 = (_15891 * (_15889 - _15890)) + _15890;
                        [branch]
                        if (!((_11892 & 2048) == 0)) {
                          _15896 = _244 - _14099;
                          _15897 = _245 - _14100;
                          _15898 = _246 - _14101;
                          _15913 = mad((_cbSharedPerViewData_raw[12u].z), _15898, mad((_cbSharedPerViewData_raw[12u].y), _15897, ((_cbSharedPerViewData_raw[12u].x) * _15896)));
                          _15916 = mad((_cbSharedPerViewData_raw[13u].z), _15898, mad((_cbSharedPerViewData_raw[13u].y), _15897, ((_cbSharedPerViewData_raw[13u].x) * _15896)));
                          _15919 = mad((_cbSharedPerViewData_raw[14u].z), _15898, mad((_cbSharedPerViewData_raw[14u].y), _15897, ((_cbSharedPerViewData_raw[14u].x) * _15896)));
                          _15921 = rsqrt(dot(float3(_15913, _15916, _15919), float3(_15913, _15916, _15919)));
                          _15922 = _15921 * _15913;
                          _15923 = _15921 * _15916;
                          _15924 = _15921 * _15919;
                          Texture2D<float> _HeapResource_56 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_14133) >> 16))];
                          _15932 = (abs(_15923) + abs(_15922)) + abs(_15924);
                          _15933 = _15922 / _15932;
                          _15934 = _15923 / _15932;
                          _15936 = !((_15924 / _15932) >= 0.0f);
                          if (_15936) {
                            _15949 = ((1.0f - abs(_15934)) * select((_15933 >= 0.0f), 1.0f, -1.0f));
                            _15950 = ((1.0f - abs(_15933)) * select((_15934 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _15949 = _15933;
                            _15950 = _15934;
                          }
                          _15956 = _HeapResource_56.SampleLevel(samplerLinearClampNode, float2(((_15949 * 0.5f) + 0.5f), ((_15950 * 0.5f) + 0.5f)), 0.0f);
                          if (_15956.x > 0.0f) {
                            Texture2D<float4> _HeapResource_57 = ResourceDescriptorHeap[NonUniformResourceIndex((_14133 & 65535))];
                            if (_15936) {
                              _15975 = ((1.0f - abs(_15934)) * select((_15933 >= 0.0f), 1.0f, -1.0f));
                              _15976 = ((1.0f - abs(_15933)) * select((_15934 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _15975 = _15933;
                              _15976 = _15934;
                            }
                            _15981 = _HeapResource_57.SampleLevel(samplerLinearClampNode, float2(((_15975 * 0.5f) + 0.5f), ((_15976 * 0.5f) + 0.5f)), 0.0f);
                            _16001 = mad(saturate(((log2(sqrt(((_15896 * _15896) + (_15897 * _15897)) + (_15898 * _15898))) * 0.6931471824645996f) - (_cbSharedPerViewData_raw[147u].w)) * (_cbSharedPerViewData_raw[148u].x)), 2.0f, -1.0f);
                            _16002 = max(9.999999747378752e-06f, _15956.x);
                            _16003 = _15981.x / _16002;
                            _16004 = _15981.y / _16002;
                            _16006 = _15981.w / _16002;
                            _16011 = ((0.375f - _16004) * 4.999999873689376e-06f) + _16004;
                            _16014 = -0.0f - _16003;
                            _16015 = mad(_16014, _16011, (_15981.z / _16002));
                            _16017 = 1.0f / mad(_16014, _16003, _16011);
                            _16018 = _16017 * _16015;
                            _16023 = _16001 - _16003;
                            _16028 = (((_16001 * _16001) - _16011) - (_16018 * _16023)) / mad((-0.0f - _16015), _16018, mad((-0.0f - _16011), _16011, (((0.375f - _16006) * 4.999999873689376e-06f) + _16006)));
                            _16030 = (_16017 * _16023) - (_16028 * _16018);
                            _16033 = 1.0f / _16028;
                            _16034 = _16030 * _16033;
                            _16039 = sqrt(((_16034 * _16034) * 0.25f) - ((1.0f - dot(float2(_16030, _16028), float2(_16003, _16011))) * _16033));
                            _16041 = (_16034 * -0.5f) - _16039;
                            _16043 = _16039 - (_16034 * 0.5f);
                            _16045 = select((_16041 < _16001), 1.0f, 0.0f);
                            _16050 = (_16045 + -0.05000000074505806f) / (_16041 - _16001);
                            _16056 = (((select((_16043 < _16001), 1.0f, 0.0f) - _16045) / (_16043 - _16041)) - _16050) / (_16043 - _16001);
                            _16058 = _16050 - (_16056 * _16041);
                            _16071 = (exp2((_15956.x * -1.4426950216293335f) * saturate((dot(float2(_16003, _16011), float2((_16058 - (_16056 * _16001)), _16056)) + 0.05000000074505806f) - (_16058 * _16001))) * _15894);
                          } else {
                            _16071 = _15894;
                          }
                        } else {
                          _16071 = _15894;
                        }
                        _16074 = (_16071 * _14252);
                        _16075 = _16071;
                      } else {
                        _16074 = _14252;
                        _16075 = 1.0f;
                      }
                      [branch]
                      if (!(_14181 == 0)) {
                        TextureCube<float3> _HeapResource_58 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _14181)))];
                        _16087 = _HeapResource_58.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_14231, _14094, mad(_14230, _14089, (_14229 * _14084)))), (-0.0f - mad(_14231, _14095, mad(_14230, _14090, (_14229 * _14085)))), (-0.0f - mad(_14231, _14096, mad(_14230, _14091, (_14229 * _14086))))), 0.0f);
                        _16095 = (_16087.x * _14159);
                        _16096 = (_16087.y * _14160);
                        _16097 = (_16087.z * _14162);
                      } else {
                        _16095 = _14159;
                        _16096 = _14160;
                        _16097 = _14162;
                      }
                      [branch]
                      if (!(_16074 == 0.0f)) {
                        bool __branch_chain_16099;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _16115 = 0;
                          __branch_chain_16099 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _16115 = 1;
                            __branch_chain_16099 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _16115 = 2;
                              __branch_chain_16099 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _16115 = 3;
                                __branch_chain_16099 = true;
                              } else {
                                _16136 = _16074;
                                __branch_chain_16099 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_16099) {
                          while(true) {
                            _16118 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_80, _81, 0));
                            if (_16115 == 0) {
                              _16132 = _16118.x;
                            } else {
                              if (_16115 == 1) {
                                _16132 = _16118.y;
                              } else {
                                if (_16115 == 2) {
                                  _16132 = _16118.z;
                                } else {
                                  _16132 = _16118.w;
                                }
                              }
                            }
                            _16136 = ((_16132 * _16132) * _14252);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_16136 == 0.0f)) {
                            [branch]
                            if (!(((_14136 & 1) == 0) || (!_14283))) {
                              _16153 = max(max(_16095, _16096), _16097);
                              if (_16153 > 0.0f) {
                                _16163 = saturate(_16095 / _16153);
                                _16164 = saturate(_16096 / _16153);
                                _16165 = saturate(_16097 / _16153);
                              } else {
                                _16163 = _16095;
                                _16164 = _16096;
                                _16165 = _16097;
                              }
                              _16166 = (_16164 < _16165);
                              _16167 = select(_16166, _16165, _16164);
                              _16168 = select(_16166, _16164, _16165);
                              _16169 = select(_16166, -1.0f, 0.0f);
                              _16170 = (_16163 < _16167);
                              _16172 = select(_16170, _16167, _16163);
                              _16173 = select(_16170, _16163, _16167);
                              _16177 = _16172 - select((_16173 < _16168), _16173, _16168);
                              _16183 = abs(select(_16170, (-0.3333333432674408f - _16169), _16169) + ((_16173 - _16168) / ((_16177 * 6.0f) + 9.999999682655225e-21f)));
                              if (_16183 < 0.6666666865348816f) {
                                _16196 = ((saturate(((float)((uint)((uint)(((uint)(_14136) >> 9) & 255)))) * 0.003921499941498041f) * (select((_16183 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _16183)) + _16183);
                              } else {
                                _16196 = _16183;
                              }
                              _16197 = saturate((_16177 / (_16172 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_14136) >> 1) & 255)))) * 0.003921499941498041f));
                              _16198 = saturate(_16172);
                              if (!(_16197 <= 0.0f)) {
                                _16201 = saturate(_16196);
                                _16205 = select(((_16201 * 360.0f) >= 360.0f), 0.0f, (_16201 * 6.0f));
                                _16206 = int(_16205);
                                _16208 = _16205 - float((int)(_16206));
                                _16210 = _16198 * (1.0f - _16197);
                                _16213 = (1.0f - (_16208 * _16197)) * _16198;
                                _16217 = (1.0f - ((1.0f - _16208) * _16197)) * _16198;
                                switch (_16206) {
                                  case 0: {
                                    _16225 = _16198;
                                    _16226 = _16217;
                                    _16227 = _16210;
                                    break;
                                  }
                                  case 1: {
                                    _16225 = _16213;
                                    _16226 = _16198;
                                    _16227 = _16210;
                                    break;
                                  }
                                  case 2: {
                                    _16225 = _16210;
                                    _16226 = _16198;
                                    _16227 = _16217;
                                    break;
                                  }
                                  case 3: {
                                    _16225 = _16210;
                                    _16226 = _16213;
                                    _16227 = _16198;
                                    break;
                                  }
                                  case 4: {
                                    _16225 = _16217;
                                    _16226 = _16210;
                                    _16227 = _16198;
                                    break;
                                  }
                                  case 5: {
                                    _16225 = _16198;
                                    _16226 = _16210;
                                    _16227 = _16213;
                                    break;
                                  }
                                  default: {
                                    _16225 = 0.0f;
                                    _16226 = 0.0f;
                                    _16227 = 0.0f;
                                    break;
                                  }
                                }
                              } else {
                                _16225 = _16198;
                                _16226 = _16198;
                                _16227 = _16198;
                              }
                              _16228 = _16225 * _16153;
                              _16229 = _16226 * _16153;
                              _16230 = _16227 * _16153;
                              _16232 = saturate(_16075 * 1.0101009607315063f);
                              _16243 = ((_16232 * (_16095 - _16228)) + _16228);
                              _16244 = ((_16232 * (_16096 - _16229)) + _16229);
                              _16245 = (lerp(_16230, _16097, _16232));
                            } else {
                              _16243 = _16095;
                              _16244 = _16096;
                              _16245 = _16097;
                            }
                            [branch]
                            if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                              _16252 = srvLightMappingData[_11895];
                              if (!(_16252 == -1)) {
                                _16257 = srvLightIndexData[_16252].nLayerIndex;
                                _16259 = srvLightIndexData[_16252].vAtlasOrigin.x;
                                _16260 = srvLightIndexData[_16252].vAtlasOrigin.y;
                                _16262 = srvLightIndexData[_16252].vScreenOrigin.x;
                                _16263 = srvLightIndexData[_16252].vScreenOrigin.y;
                                _16272 = ((int)(_16257 * 5)) & 31;
                                _16281 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_16259 + _80) - _16262)), ((int)((_16260 + _81) - _16263)), 0)))).x) & ((int)(31 << _16272)))) >> _16272)) >> 1)))) * 0.06666667014360428f) * _16136);
                              } else {
                                _16281 = _16136;
                              }
                            } else {
                              _16281 = _16136;
                            }
                            _16288 = _14235 * _14234;
                            _16289 = _14236 * _14234;
                            _16290 = _14237 * _14234;
                            _16291 = _14167 * _14104;
                            _16292 = _14167 * _14105;
                            _16293 = _14167 * _14106;
                            _16294 = _16288 + _16291;
                            _16295 = _16289 + _16292;
                            _16296 = _16290 + _16293;
                            _16297 = _16288 - _16291;
                            _16298 = _16289 - _16292;
                            _16299 = _16290 - _16293;
                            _16300 = (_14167 > 0.0f);
                            _16301 = dot(float3(_16294, _16295, _16296), float3(_16294, _16295, _16296));
                            _16302 = rsqrt(_16301);
                            [branch]
                            if (_16300) {
                              _16305 = rsqrt(dot(float3(_16297, _16298, _16299), float3(_16297, _16298, _16299)));
                              _16306 = _16305 * _16302;
                              _16308 = dot(float3(_16294, _16295, _16296), float3(_16297, _16298, _16299)) * _16306;
                              _16327 = (_16306 / ((_16306 + 0.5f) + (_16308 * 0.5f)));
                              _16328 = (((dot(float3(_205, _207, _209), float3(_16297, _16298, _16299)) * _16305) + (dot(float3(_205, _207, _209), float3(_16294, _16295, _16296)) * _16302)) * 0.5f);
                              _16329 = _16308;
                            } else {
                              _16327 = (1.0f / (_16301 + 1.0f));
                              _16328 = dot(float3(_205, _207, _209), float3((_16302 * _16294), (_16302 * _16295), (_16302 * _16296)));
                              _16329 = 1.0f;
                            }
                            if (_14169 > 0.0f) {
                              _16335 = sqrt(saturate((_14169 * _14169) * _16327));
                              if (_16328 < _16335) {
                                _16340 = max(_16328, (-0.0f - _16335)) + _16335;
                                _16345 = ((_16340 * _16340) / (_16335 * 4.0f));
                              } else {
                                _16345 = _16328;
                              }
                            } else {
                              _16345 = _16328;
                            }
                            if (_16300) {
                              _16347 = -0.0f - _257;
                              _16348 = -0.0f - _258;
                              _16349 = -0.0f - _256;
                              _16351 = dot(float3(_16347, _16348, _16349), float3(_205, _207, _209)) * 2.0f;
                              _16355 = _16347 - (_16351 * _205);
                              _16356 = _16348 - (_16351 * _207);
                              _16357 = _16349 - (_16351 * _209);
                              _16358 = _16297 - _16294;
                              _16359 = _16298 - _16295;
                              _16360 = _16299 - _16296;
                              _16361 = dot(float3(_16355, _16356, _16357), float3(_16358, _16359, _16360));
                              _16367 = sqrt(((_16358 * _16358) + (_16359 * _16359)) + (_16360 * _16360));
                              _16376 = saturate(((dot(float3(_16355, _16356, _16357), float3(_16294, _16295, _16296)) * _16361) - dot(float3(_16294, _16295, _16296), float3(_16358, _16359, _16360))) / ((_16367 * _16367) - (_16361 * _16361)));
                              _16380 = (_16376 * _16358) + _16294;
                              _16381 = (_16376 * _16359) + _16295;
                              _16382 = (_16376 * _16360) + _16296;
                              _16383 = dot(float3(_16380, _16381, _16382), float3(_16355, _16356, _16357));
                              _16387 = (_16383 * _16355) - _16380;
                              _16388 = (_16383 * _16356) - _16381;
                              _16389 = (_16383 * _16357) - _16382;
                              _16397 = saturate(0.009999999776482582f / sqrt(((_16387 * _16387) + (_16388 * _16388)) + (_16389 * _16389)));
                              _16405 = ((_16397 * _16387) + _16380);
                              _16406 = ((_16397 * _16388) + _16381);
                              _16407 = ((_16397 * _16389) + _16382);
                            } else {
                              _16405 = _16294;
                              _16406 = _16295;
                              _16407 = _16296;
                            }
                            _16409 = rsqrt(dot(float3(_16405, _16406, _16407), float3(_16405, _16406, _16407)));
                            _16410 = _16409 * _16405;
                            _16411 = _16409 * _16406;
                            _16412 = _16409 * _16407;
                            _16413 = _231 * _231;
                            _16414 = 1.0f - _16413;
                            _16417 = saturate((_14169 * _16414) * _16409);
                            _16419 = saturate(_16409 * f16tof32(_14118));
                            _16420 = dot(float3(_205, _207, _209), float3(_16410, _16411, _16412));
                            _16421 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                            _16422 = dot(float3(_257, _258, _256), float3(_16410, _16411, _16412));
                            _16425 = rsqrt((_16422 * 2.0f) + 2.0f);
                            _16428 = saturate(_16425 * (_16421 + _16420));
                            _16431 = saturate((_16425 * _16422) + _16425);
                            _16432 = (_16417 > 0.0f);
                            if (_16432) {
                              _16436 = sqrt(1.0f - (_16417 * _16417));
                              _16438 = (_16420 * 2.0f) * _16421;
                              _16439 = _16438 - _16422;
                              if (!(_16439 >= _16436)) {
                                _16447 = rsqrt(1.0f - (_16439 * _16439)) * _16417;
                                _16450 = _16447 * (_16421 - (_16439 * _16420));
                                _16451 = _16421 * _16421;
                                _16456 = _16447 * (((_16451 * 2.0f) + -1.0f) - (_16439 * _16422));
                                _16465 = sqrt(saturate((((1.0f - (_16420 * _16420)) - _16451) - (_16422 * _16422)) + (_16438 * _16422)));
                                _16466 = _16465 * _16447;
                                _16469 = ((_16421 * 2.0f) * _16447) * _16465;
                                _16471 = (_16436 * _16420) + _16421;
                                _16472 = _16471 + _16450;
                                _16473 = _16436 * _16422;
                                _16475 = (_16473 + 1.0f) + _16456;
                                _16476 = _16466 * _16475;
                                _16477 = _16472 * _16475;
                                _16478 = _16469 * _16472;
                                _16483 = (((_16472 * 0.25f) * _16469) - (_16476 * 0.5f)) * _16477;
                                _16497 = (((_16478 - (_16476 * 2.0f)) * _16478) + (_16476 * _16476)) + ((((-0.5f - ((_16475 + _16473) * 0.5f)) * _16477) + ((_16475 * _16475) * _16471)) * _16472);
                                _16502 = (_16483 * 2.0f) / ((_16497 * _16497) + (_16483 * _16483));
                                _16503 = _16497 * _16502;
                                _16505 = 1.0f - (_16483 * _16502);
                                _16511 = ((_16503 * _16469) + _16473) + (_16505 * _16456);
                                _16514 = rsqrt((_16511 * 2.0f) + 2.0f);
                                _16523 = saturate((_16511 * _16514) + _16514);
                                _16524 = saturate(((_16471 + (_16503 * _16466)) + (_16505 * _16450)) * _16514);
                              } else {
                                _16523 = abs(_16421);
                                _16524 = 1.0f;
                              }
                            } else {
                              _16523 = _16431;
                              _16524 = _16428;
                            }
                            _16525 = saturate(_16345);
                            _16526 = _16413 * _16413;
                            _16527 = (_16419 > 0.0f);
                            if (_16527) {
                              _16536 = saturate(((_16419 * _16419) / ((_16523 * 3.5999999046325684f) + 0.4000000059604645f)) + _16526);
                            } else {
                              _16536 = _16526;
                            }
                            if (_16432) {
                              _16545 = (((_16417 * 0.25f) * ((sqrt(_16536) * 3.0f) + _16417)) / (_16523 + 0.0010000000474974513f)) + _16536;
                              _16548 = _16545;
                              _16549 = (_16536 / _16545);
                            } else {
                              _16548 = _16536;
                              _16549 = 1.0f;
                            }
                            _16550 = (_16329 < 1.0f);
                            if (_16550) {
                              _16556 = sqrt((1.000100016593933f - _16329) / max(9.999999974752427e-07f, (_16329 + 1.0f)));
                              _16569 = (sqrt(_16548 / ((((_16556 * 0.25f) * ((sqrt(_16548) * 3.0f) + _16556)) / (_16523 + 0.0010000000474974513f)) + _16548)) * _16549);
                            } else {
                              _16569 = _16549;
                            }
                            _16573 = (((_16536 * _16524) - _16524) * _16524) + 1.0f;
                            _16583 = abs(_16421);
                            _16585 = saturate(_16583 + 9.999999747378752e-06f);
                            _16586 = sqrt(_16536);
                            _16587 = 1.0f - _16586;
                            _16599 = saturate(select((_16414 > 0.0f), 1.0f, 0.0f) * _16417);
                            _16600 = (_16599 > 0.0f);
                            if (_16600) {
                              _16604 = sqrt(1.0f - (_16599 * _16599));
                              _16606 = (_16420 * 2.0f) * _16421;
                              _16607 = _16606 - _16422;
                              if (!(_16607 >= _16604)) {
                                _16613 = rsqrt(1.0f - (_16607 * _16607)) * _16599;
                                _16616 = _16613 * (_16421 - (_16607 * _16420));
                                _16617 = _16421 * _16421;
                                _16622 = _16613 * (((_16617 * 2.0f) + -1.0f) - (_16607 * _16422));
                                _16631 = sqrt(saturate((((1.0f - (_16420 * _16420)) - _16617) - (_16422 * _16422)) + (_16606 * _16422)));
                                _16632 = _16631 * _16613;
                                _16635 = ((_16421 * 2.0f) * _16613) * _16631;
                                _16637 = (_16604 * _16420) + _16421;
                                _16638 = _16637 + _16616;
                                _16639 = _16604 * _16422;
                                _16641 = (_16639 + 1.0f) + _16622;
                                _16642 = _16632 * _16641;
                                _16643 = _16638 * _16641;
                                _16644 = _16635 * _16638;
                                _16649 = (((_16638 * 0.25f) * _16635) - (_16642 * 0.5f)) * _16643;
                                _16663 = (((_16644 - (_16642 * 2.0f)) * _16644) + (_16642 * _16642)) + ((((-0.5f - ((_16641 + _16639) * 0.5f)) * _16643) + ((_16641 * _16641) * _16637)) * _16638);
                                _16668 = (_16649 * 2.0f) / ((_16663 * _16663) + (_16649 * _16649));
                                _16669 = _16663 * _16668;
                                _16671 = 1.0f - (_16649 * _16668);
                                _16677 = ((_16669 * _16635) + _16639) + (_16671 * _16622);
                                _16680 = rsqrt((_16677 * 2.0f) + 2.0f);
                                _16689 = saturate((_16677 * _16680) + _16680);
                                _16690 = saturate(((_16637 + (_16669 * _16632)) + (_16671 * _16616)) * _16680);
                              } else {
                                _16689 = _16583;
                                _16690 = 1.0f;
                              }
                            } else {
                              _16689 = _16431;
                              _16690 = _16428;
                            }
                            if (_16527) {
                              _16699 = saturate(((_16419 * _16419) / ((_16689 * 3.5999999046325684f) + 0.4000000059604645f)) + _16526);
                            } else {
                              _16699 = _16526;
                            }
                            if (_16600) {
                              _16708 = (((_16599 * 0.25f) * ((sqrt(_16699) * 3.0f) + _16599)) / (_16689 + 0.0010000000474974513f)) + _16699;
                              _16711 = _16708;
                              _16712 = (_16699 / _16708);
                            } else {
                              _16711 = _16699;
                              _16712 = 1.0f;
                            }
                            if (_16550) {
                              _16718 = sqrt((1.000100016593933f - _16329) / max(9.999999974752427e-07f, (_16329 + 1.0f)));
                              _16731 = (sqrt(_16711 / ((((_16718 * 0.25f) * ((sqrt(_16711) * 3.0f) + _16718)) / (_16689 + 0.0010000000474974513f)) + _16711)) * _16712);
                            } else {
                              _16731 = _16712;
                            }
                            _16735 = (((_16699 * _16690) - _16690) * _16690) + 1.0f;
                            _16736 = sqrt(_16699);
                            _16737 = 1.0f - _16736;
                            if (_14166 > 0.0f) {
                              _16769 = ((((exp2(log2(1.0f - saturate(_16689)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_16731 * _16525) * (_16699 / (_16735 * _16735))) * (0.5f / ((((_16737 * _16585) + _16736) * _16525) + (((_16737 * _16525) + _16736) * _16585))))) + ((((_16569 * _16525) * (_16536 / (_16573 * _16573))) * (0.5f / ((((_16587 * _16585) + _16586) * _16525) + (((_16587 * _16525) + _16586) * _16585)))) * ((exp2(log2(1.0f - saturate(_16523)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f));
                              _16771 = (_14166 * _11767) * select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_16281 * _11694), _16281);
                              _19167 = (((_16771 * (_16243 * _11942)) * _16769) + _11884);
                              _19168 = (((_16771 * (_16244 * _11942)) * _16769) + _11885);
                              _19169 = (((_16771 * (_16245 * _11942)) * _16769) + _11886);
                            } else {
                              _19167 = _11884;
                              _19168 = _11885;
                              _19169 = _11886;
                            }
                          } else {
                            _19167 = _11884;
                            _19168 = _11885;
                            _19169 = _11886;
                          }
                          break;
                        }
                      } else {
                        _19167 = _11884;
                        _19168 = _11885;
                        _19169 = _11886;
                      }
                    } else {
                      if (_11925 == 8) {
                        _16786 = asfloat(srvLightInfoProperties.Load3(_11894)).x;
                        _16787 = asfloat(srvLightInfoProperties.Load3(_11894)).y;
                        _16788 = asfloat(srvLightInfoProperties.Load3(_11894)).z;
                        _16791 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 12u)))).x;
                        _16792 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 12u)))).y;
                        _16793 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 12u)))).z;
                        _16796 = asfloat(srvLightInfoProperties.Load(((int)(_11894 + 24u))));
                        _16799 = asint(srvLightInfoProperties.Load(((int)(_11894 + 28u))));
                        _16802 = asint(srvLightInfoProperties.Load(((int)(_11894 + 32u))));
                        _16805 = asint(srvLightInfoProperties.Load(((int)(_11894 + 44u))));
                        _16814 = ((float)((uint)((uint)(((uint)(_16802) >> 8) & 255)))) * 0.003921499941498041f;
                        _16817 = f16tof32(_16805);
                        _16824 = min(max(dot(float3((_244 - _16786), (_245 - _16787), (_246 - _16788)), float3(_16791, _16792, _16793)), (-0.0f - _16796)), _16796);
                        _16829 = (_16786 - _244) + (_16824 * _16791);
                        _16831 = (_16787 - _245) + (_16824 * _16792);
                        _16833 = (_16788 + _243) + (_16824 * _16793);
                        _16834 = dot(float3(_16829, _16831, _16833), float3(_16829, _16831, _16833));
                        _16835 = rsqrt(_16834);
                        _16837 = _16829 * _16835;
                        _16838 = _16831 * _16835;
                        _16839 = _16833 * _16835;
                        _16842 = max(0.0f, ((_16835 * _16834) - abs(_16817)));
                        _16843 = _16842 * f16tof32(((uint)((uint)(_16805) >> 16)));
                        _16844 = _16843 * _16843;
                        _16847 = saturate(1.0f - (_16844 * _16844));
                        _16854 = (_16847 * _16847) / (select((_16817 < 0.0f), (_16844 * 16.0f), (_16842 * _16842)) + 1.0f);
                        [branch]
                        if (!(_16854 == 0.0f)) {
                          [branch]
                          if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                            _16863 = srvLightMappingData[_11895];
                            if (!(_16863 == -1)) {
                              _16868 = srvLightIndexData[_16863].nLayerIndex;
                              _16870 = srvLightIndexData[_16863].vAtlasOrigin.x;
                              _16871 = srvLightIndexData[_16863].vAtlasOrigin.y;
                              _16873 = srvLightIndexData[_16863].vScreenOrigin.x;
                              _16874 = srvLightIndexData[_16863].vScreenOrigin.y;
                              _16883 = ((int)(_16868 * 5)) & 31;
                              _16892 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_16870 + _80) - _16873)), ((int)((_16871 + _81) - _16874)), 0)))).x) & ((int)(31 << _16883)))) >> _16883)) >> 1)))) * 0.06666667014360428f) * _16854);
                            } else {
                              _16892 = _16854;
                            }
                          } else {
                            _16892 = _16854;
                          }
                          _16893 = dot(float3(_205, _207, _209), float3(_16837, _16838, _16839));
                          _16894 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                          _16895 = dot(float3(_257, _258, _256), float3(_16837, _16838, _16839));
                          _16898 = rsqrt((_16895 * 2.0f) + 2.0f);
                          _16901 = saturate(_16898 * (_16894 + _16893));
                          _16902 = saturate(_16893);
                          _16903 = _231 * _231;
                          _16904 = _16903 * _16903;
                          _16908 = (((_16901 * _16904) - _16901) * _16901) + 1.0f;
                          _16911 = saturate(abs(_16894) + 9.999999747378752e-06f);
                          _16912 = sqrt(_16904);
                          _16913 = 1.0f - _16912;
                          if (_16814 > 0.0f) {
                            _16944 = (exp2(log2(1.0f - saturate(saturate((_16898 * _16895) + _16898))) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                            _16947 = (((_16904 / (_16908 * _16908)) * _16902) * (0.5f / ((((_16913 * _16911) + _16912) * _16902) + (((_16913 * _16902) + _16912) * _16911)))) * ((_16944 * _181) + _16944);
                            _16951 = (_16814 * _11767) * select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_16892 * _11694), _16892);
                            _19167 = (((_16951 * (f16tof32(((uint)((uint)(_16799) >> 16))) * _11942)) * _16947) + _11884);
                            _19168 = (((_16951 * (f16tof32(_16799) * _11942)) * _16947) + _11885);
                            _19169 = (((_16951 * (f16tof32(((uint)((uint)(_16802) >> 16))) * _11942)) * _16947) + _11886);
                          } else {
                            _19167 = _11884;
                            _19168 = _11885;
                            _19169 = _11886;
                          }
                        } else {
                          _19167 = _11884;
                          _19168 = _11885;
                          _19169 = _11886;
                        }
                      } else {
                        if (_11925 == 9) {
                          _16966 = asfloat(srvLightInfoProperties.Load4(_11894)).x;
                          _16967 = asfloat(srvLightInfoProperties.Load4(_11894)).y;
                          _16968 = asfloat(srvLightInfoProperties.Load4(_11894)).w;
                          _16971 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).x;
                          _16972 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).y;
                          _16973 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).w;
                          _16976 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).x;
                          _16977 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).y;
                          _16978 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).w;
                          _16981 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 48u)))).x;
                          _16982 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 48u)))).y;
                          _16983 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 48u)))).w;
                          _16986 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 64u)))).x;
                          _16987 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 64u)))).y;
                          _16988 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 64u)))).z;
                          _16991 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 76u)))).x;
                          _16992 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 76u)))).y;
                          _16993 = asfloat(srvLightInfoProperties.Load3(((int)(_11894 + 76u)))).z;
                          _16996 = asint(srvLightInfoProperties.Load(((int)(_11894 + 88u))));
                          _16999 = asint(srvLightInfoProperties.Load(((int)(_11894 + 92u))));
                          _17002 = asint(srvLightInfoProperties.Load(((int)(_11894 + 100u))));
                          _17005 = asint(srvLightInfoProperties.Load(((int)(_11894 + 104u))));
                          _17008 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).x;
                          _17009 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).y;
                          _17010 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).z;
                          _17011 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 108u)))).w;
                          _17014 = asint(srvLightInfoProperties.Load(((int)(_11894 + 124u))));
                          _17017 = asint(srvLightInfoProperties.Load(((int)(_11894 + 128u))));
                          _17020 = asint(srvLightInfoProperties.Load(((int)(_11894 + 132u))));
                          _17023 = asint(srvLightInfoProperties.Load(((int)(_11894 + 136u))));
                          _17026 = asint(srvLightInfoProperties.Load(((int)(_11894 + 140u))));
                          _17029 = asint(srvLightInfoProperties.Load(((int)(_11894 + 144u))));
                          _17032 = asint(srvLightInfoProperties.Load(((int)(_11894 + 148u))));
                          _17035 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 152u)))).x;
                          _17036 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 152u)))).y;
                          _17037 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 152u)))).z;
                          _17038 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 152u)))).w;
                          _17041 = asint(srvLightInfoProperties.Load(((int)(_11894 + 168u))));
                          _17044 = asint(srvLightInfoProperties.Load(((int)(_11894 + 172u))));
                          _17047 = asint(srvLightInfoProperties.Load(((int)(_11894 + 180u))));
                          _17049 = f16tof32(((uint)((uint)(_16996) >> 16)));
                          _17050 = f16tof32(_16996);
                          _17052 = f16tof32(((uint)((uint)(_16999) >> 16)));
                          _17056 = ((float)((uint)((uint)(((uint)(_16999) >> 8) & 255)))) * 0.003921499941498041f;
                          _17057 = f16tof32(_17002);
                          _17059 = f16tof32(((uint)((uint)(_17005) >> 16)));
                          _17063 = f16tof32(_17014);
                          _17067 = _17020 & 65535;
                          _17083 = f16tof32(((uint)((uint)(_17044) >> 16)));
                          _17084 = f16tof32(_17044);
                          _17086 = f16tof32(((uint)((uint)(_17047) >> 16)));
                          _17087 = 1.0f / _17086;
                          _17088 = _17086 + -1.0f;
                          _17089 = f16tof32(_17047);
                          _17090 = _16986 - _244;
                          _17091 = _16987 - _245;
                          _17092 = _16988 + _243;
                          _17093 = dot(float3(_17090, _17091, _17092), float3(_17090, _17091, _17092));
                          _17094 = rsqrt(_17093);
                          _17095 = _17094 * _17093;
                          _17096 = _17094 * _17090;
                          _17097 = _17094 * _17091;
                          _17098 = _17094 * _17092;
                          _17101 = max(0.0f, (_17095 - abs(_17063)));
                          _17102 = _17101 * f16tof32(((uint)((uint)(_17014) >> 16)));
                          _17103 = _17102 * _17102;
                          _17106 = saturate(1.0f - (_17103 * _17103));
                          _17117 = mad(_246, _16978, mad(_245, _16973, (_16968 * _244))) + _16983;
                          _17121 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_17096, _17097, _17098))) * f16tof32(_17041);
                          _17128 = ((_17117 * _205) * _17121) + _244;
                          _17129 = ((_17117 * _207) * _17121) + _245;
                          _17130 = ((_17117 * _209) * _17121) - _243;
                          _17142 = mad(_17130, _16978, mad(_17129, _16973, (_17128 * _16968))) + _16983;
                          _17143 = 1.0f / _17142;
                          _17144 = _17143 * (mad(_17130, _16976, mad(_17129, _16971, (_17128 * _16966))) + _16981);
                          _17145 = _17143 * (mad(_17130, _16977, mad(_17129, _16972, (_17128 * _16967))) + _16982);
                          _17148 = (_17144 * _17008) + _17009;
                          _17149 = (_17145 * _17008) + _17009;
                          _17152 = _17148 - saturate(_17148);
                          _17153 = _17149 - saturate(_17149);
                          _17160 = saturate((sqrt((_17152 * _17152) + (_17153 * _17153)) * _17010) + _17011);
                          _17162 = 1.0f - (_17160 * _17160);
                          _17168 = (_17162 * _17162) * (((float)((bool)(uint)((_17142 - f16tof32(((uint)((uint)(_17017) >> 16)))) > 0.0f))) * ((_17106 * _17106) / (select((_17063 < 0.0f), (_17103 * 16.0f), (_17101 * _17101)) + 1.0f)));
                          _17170 = ((_11892 & 3584) == 0);
                          if (!((!(_17168 > 0.0f)) || _17170)) {
                            _17178 = 1.0f - saturate(f16tof32(_17017) * _17142);
                            _17179 = saturate(_17144);
                            _17180 = saturate(_17145);
                            bool __branch_chain_17172;
                            [branch]
                            if ((_11892 & 1024) == 0) {
                              _17443 = 1.0f;
                              _17444 = 0.0f;
                              _17445 = _17178;
                              __branch_chain_17172 = true;
                            } else {
                              _17185 = ((_17179 * _17088) + 0.5f) * _17087;
                              _17187 = ((_17180 * _17088) + 0.5f) * _17087;
                              _17188 = _17178 + f16tof32(((uint)((uint)(_17041) >> 16)));
                              Texture2D<float4> _HeapResource_59 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_17020) >> 16))];
                              _17191 = saturate(_17188);
                              _17195 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                              _17204 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 14u) : (frac(frac(dot(float2(((_17195 * 32.665000915527344f) + _142), ((_17195 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                              _17205 = sin(_17204);
                              _17206 = cos(_17204);
                              _17207 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                              _17212 = sqrt((float((int)(_17207)) * 0.25f) + 0.125f) * _17083;
                              _17221 = (_global_7[min((uint)(((int)(0u + (_17207 * 2)))), 127u)]) * _17212;
                              _17222 = (_global_7[min((uint)(((int)(1u + (_17207 * 2)))), 127u)]) * _17212;
                              _17224 = -0.0f - _17205;
                              _17229 = _HeapResource_59.GatherRed(samplerPointClampNode, float2((dot(float2(_17221, _17222), float2(_17206, _17205)) + _17185), (dot(float2(_17221, _17222), float2(_17224, _17206)) + _17187)));
                              _17234 = _17229.x - _17191;
                              _17236 = select((_17234 < 0.0f), 0.0f, 1.0f);
                              _17238 = _17229.y - _17191;
                              _17240 = select((_17238 < 0.0f), 0.0f, 1.0f);
                              _17244 = _17229.z - _17191;
                              _17246 = select((_17244 < 0.0f), 0.0f, 1.0f);
                              _17250 = _17229.w - _17191;
                              _17252 = select((_17250 < 0.0f), 0.0f, 1.0f);
                              _17259 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                              _17264 = sqrt((float((int)(_17259)) * 0.25f) + 0.125f) * _17083;
                              _17273 = (_global_7[min((uint)(((int)(0u + (_17259 * 2)))), 127u)]) * _17264;
                              _17274 = (_global_7[min((uint)(((int)(1u + (_17259 * 2)))), 127u)]) * _17264;
                              _17280 = _HeapResource_59.GatherRed(samplerPointClampNode, float2((dot(float2(_17273, _17274), float2(_17206, _17205)) + _17185), (dot(float2(_17273, _17274), float2(_17224, _17206)) + _17187)));
                              _17285 = _17280.x - _17191;
                              _17287 = select((_17285 < 0.0f), 0.0f, 1.0f);
                              _17291 = _17280.y - _17191;
                              _17293 = select((_17291 < 0.0f), 0.0f, 1.0f);
                              _17297 = _17280.z - _17191;
                              _17299 = select((_17297 < 0.0f), 0.0f, 1.0f);
                              _17303 = _17280.w - _17191;
                              _17305 = select((_17303 < 0.0f), 0.0f, 1.0f);
                              _17312 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                              _17317 = sqrt((float((int)(_17312)) * 0.25f) + 0.125f) * _17083;
                              _17326 = (_global_7[min((uint)(((int)(0u + (_17312 * 2)))), 127u)]) * _17317;
                              _17327 = (_global_7[min((uint)(((int)(1u + (_17312 * 2)))), 127u)]) * _17317;
                              _17333 = _HeapResource_59.GatherRed(samplerPointClampNode, float2((dot(float2(_17326, _17327), float2(_17206, _17205)) + _17185), (dot(float2(_17326, _17327), float2(_17224, _17206)) + _17187)));
                              _17338 = _17333.x - _17191;
                              _17340 = select((_17338 < 0.0f), 0.0f, 1.0f);
                              _17344 = _17333.y - _17191;
                              _17346 = select((_17344 < 0.0f), 0.0f, 1.0f);
                              _17350 = _17333.z - _17191;
                              _17352 = select((_17350 < 0.0f), 0.0f, 1.0f);
                              _17356 = _17333.w - _17191;
                              _17358 = select((_17356 < 0.0f), 0.0f, 1.0f);
                              _17365 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                              _17370 = sqrt((float((int)(_17365)) * 0.25f) + 0.125f) * _17083;
                              _17379 = (_global_7[min((uint)(((int)(0u + (_17365 * 2)))), 127u)]) * _17370;
                              _17380 = (_global_7[min((uint)(((int)(1u + (_17365 * 2)))), 127u)]) * _17370;
                              _17386 = _HeapResource_59.GatherRed(samplerPointClampNode, float2((dot(float2(_17379, _17380), float2(_17206, _17205)) + _17185), (dot(float2(_17379, _17380), float2(_17224, _17206)) + _17187)));
                              _17391 = _17386.x - _17191;
                              _17393 = select((_17391 < 0.0f), 0.0f, 1.0f);
                              _17397 = _17386.y - _17191;
                              _17399 = select((_17397 < 0.0f), 0.0f, 1.0f);
                              _17403 = _17386.z - _17191;
                              _17405 = select((_17403 < 0.0f), 0.0f, 1.0f);
                              _17409 = _17386.w - _17191;
                              _17411 = select((_17409 < 0.0f), 0.0f, 1.0f);
                              _17412 = ((((((((((((((_17236 + _17240) + _17246) + _17252) + _17287) + _17293) + _17299) + _17305) + _17340) + _17346) + _17352) + _17358) + _17393) + _17399) + _17405) + _17411;
                              _17423 = (saturate(_17412 * 0.0625f) * 2.0f) + -1.0f;
                              _17429 = float((int)(((int)(uint)((int)(_17423 > 0.0f))) - ((int)(uint)((int)(_17423 < 0.0f)))));
                              _17431 = 1.0f - (_17429 * _17423);
                              _17433 = (_17431 * _17431) * _17431;
                              _17440 = 0.5f - ((_17429 * 0.5f) * ((1.0f - _17433) - ((_17431 - _17433) * saturate(((1.0f / _17191) * (1.0f / _17412)) * ((((((((((((((((_17236 * _17234) + (_17240 * _17238)) + (_17246 * _17244)) + (_17252 * _17250)) + (_17287 * _17285)) + (_17293 * _17291)) + (_17299 * _17297)) + (_17305 * _17303)) + (_17340 * _17338)) + (_17346 * _17344)) + (_17352 * _17350)) + (_17358 * _17356)) + (_17393 * _17391)) + (_17399 * _17397)) + (_17405 * _17403)) + (_17411 * _17409))))));
                              [branch]
                              if (_17089 < 1.0f) {
                                _17443 = _17440;
                                _17444 = _17089;
                                _17445 = _17188;
                                __branch_chain_17172 = true;
                              } else {
                                _17913 = _17089;
                                _17914 = _17440;
                                __branch_chain_17172 = false;
                              }
                            }
                            if (__branch_chain_17172) {
                              _17448 = (_17179 * _17035) + _17037;
                              _17449 = (_17180 * _17036) + _17038;
                              if (!((_11892 & 512) == 0)) {
                                Texture2D<float4> _HeapResource_60 = ResourceDescriptorHeap[5];
                                _17458 = saturate(_17445);
                                _17462 = (float)((uint)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x) & 15)));
                                _17471 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_80, _81), _cbSharedPerViewData_raw_uint[45u].x, 15u) : (frac(frac(dot(float2(((_17462 * 32.665000915527344f) + _142), ((_17462 * 11.8149995803833f) + _143)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _17472 = sin(_17471);
                                _17473 = cos(_17471);
                                _17478 = select(((((float4)(_HeapResource_60.SampleLevel(samplerPointBorderWhiteNode, float2(_17448, _17449), 0.0f))).x) > _17458), 1.0f, 0.0f);
                                _17479 = asint(_cbSharedPerViewData_raw_uint[45u].x) & 3;
                                _17484 = sqrt((float((int)(_17479)) * 0.25f) + 0.125f) * _17084;
                                _17493 = (_global_7[min((uint)(((int)(0u + (_17479 * 2)))), 127u)]) * _17484;
                                _17494 = (_global_7[min((uint)(((int)(1u + (_17479 * 2)))), 127u)]) * _17484;
                                _17496 = -0.0f - _17472;
                                _17498 = dot(float2(_17493, _17494), float2(_17473, _17472)) + _17448;
                                _17499 = dot(float2(_17493, _17494), float2(_17496, _17473)) + _17449;
                                _17501 = _HeapResource_60.GatherRed(samplerPointClampNode, float2(_17498, _17499));
                                _17505 = _17498 * (_cbSharedPerViewData_raw[82u].x);
                                _17506 = _17499 * (_cbSharedPerViewData_raw[82u].y);
                                _17509 = floor((_cbSharedPerViewData_raw[82u].x) * _17037);
                                _17510 = floor((_cbSharedPerViewData_raw[82u].y) * _17038);
                                _17515 = floor(((_cbSharedPerViewData_raw[82u].x) * (_17035 + _17037)) + 0.5f);
                                _17516 = floor(((_cbSharedPerViewData_raw[82u].y) * (_17036 + _17038)) + 0.5f);
                                _17519 = floor(_17505 + -0.5f);
                                _17520 = floor(_17506 + 0.5f);
                                _17522 = floor(_17505 + 0.5f);
                                _17524 = floor(_17506 + -0.5f);
                                _17525 = (_17519 < _17509);
                                _17526 = (_17520 < _17510);
                                if ((_17525 || _17526) | ((_17519 >= _17515) || (_17520 >= _17516))) {
                                  _17535 = _17478;
                                } else {
                                  _17535 = _17501.x;
                                }
                                _17536 = (_17522 < _17509);
                                if ((_17536 || _17526) | ((_17522 >= _17515) || (_17520 >= _17516))) {
                                  _17544 = _17478;
                                } else {
                                  _17544 = _17501.y;
                                }
                                _17545 = (_17524 < _17510);
                                if ((_17536 || _17545) | ((_17522 >= _17515) || (_17524 >= _17516))) {
                                  _17553 = _17478;
                                } else {
                                  _17553 = _17501.z;
                                }
                                if ((_17525 || _17545) | ((_17519 >= _17515) || (_17524 >= _17516))) {
                                  _17561 = _17478;
                                } else {
                                  _17561 = _17501.w;
                                }
                                _17562 = _17535 - _17458;
                                _17564 = select((_17562 < 0.0f), 0.0f, 1.0f);
                                _17566 = _17544 - _17458;
                                _17568 = select((_17566 < 0.0f), 0.0f, 1.0f);
                                _17572 = _17553 - _17458;
                                _17574 = select((_17572 < 0.0f), 0.0f, 1.0f);
                                _17578 = _17561 - _17458;
                                _17580 = select((_17578 < 0.0f), 0.0f, 1.0f);
                                _17587 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 1u)) & 3;
                                _17592 = sqrt((float((int)(_17587)) * 0.25f) + 0.125f) * _17084;
                                _17601 = (_global_7[min((uint)(((int)(0u + (_17587 * 2)))), 127u)]) * _17592;
                                _17602 = (_global_7[min((uint)(((int)(1u + (_17587 * 2)))), 127u)]) * _17592;
                                _17605 = dot(float2(_17601, _17602), float2(_17473, _17472)) + _17448;
                                _17606 = dot(float2(_17601, _17602), float2(_17496, _17473)) + _17449;
                                _17608 = _HeapResource_60.GatherRed(samplerPointClampNode, float2(_17605, _17606));
                                _17612 = _17605 * (_cbSharedPerViewData_raw[82u].x);
                                _17613 = _17606 * (_cbSharedPerViewData_raw[82u].y);
                                _17616 = floor(_17612 + -0.5f);
                                _17617 = floor(_17613 + 0.5f);
                                _17619 = floor(_17612 + 0.5f);
                                _17621 = floor(_17613 + -0.5f);
                                _17622 = (_17616 < _17509);
                                _17623 = (_17617 < _17510);
                                if ((_17622 || _17623) | ((_17616 >= _17515) || (_17617 >= _17516))) {
                                  _17632 = _17478;
                                } else {
                                  _17632 = _17608.x;
                                }
                                _17633 = (_17619 < _17509);
                                if ((_17633 || _17623) | ((_17619 >= _17515) || (_17617 >= _17516))) {
                                  _17641 = _17478;
                                } else {
                                  _17641 = _17608.y;
                                }
                                _17642 = (_17621 < _17510);
                                if ((_17633 || _17642) | ((_17619 >= _17515) || (_17621 >= _17516))) {
                                  _17650 = _17478;
                                } else {
                                  _17650 = _17608.z;
                                }
                                if ((_17622 || _17642) | ((_17616 >= _17515) || (_17621 >= _17516))) {
                                  _17658 = _17478;
                                } else {
                                  _17658 = _17608.w;
                                }
                                _17659 = _17632 - _17458;
                                _17661 = select((_17659 < 0.0f), 0.0f, 1.0f);
                                _17665 = _17641 - _17458;
                                _17667 = select((_17665 < 0.0f), 0.0f, 1.0f);
                                _17671 = _17650 - _17458;
                                _17673 = select((_17671 < 0.0f), 0.0f, 1.0f);
                                _17677 = _17658 - _17458;
                                _17679 = select((_17677 < 0.0f), 0.0f, 1.0f);
                                _17686 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 2u)) & 3;
                                _17691 = sqrt((float((int)(_17686)) * 0.25f) + 0.125f) * _17084;
                                _17700 = (_global_7[min((uint)(((int)(0u + (_17686 * 2)))), 127u)]) * _17691;
                                _17701 = (_global_7[min((uint)(((int)(1u + (_17686 * 2)))), 127u)]) * _17691;
                                _17704 = dot(float2(_17700, _17701), float2(_17473, _17472)) + _17448;
                                _17705 = dot(float2(_17700, _17701), float2(_17496, _17473)) + _17449;
                                _17707 = _HeapResource_60.GatherRed(samplerPointClampNode, float2(_17704, _17705));
                                _17711 = _17704 * (_cbSharedPerViewData_raw[82u].x);
                                _17712 = _17705 * (_cbSharedPerViewData_raw[82u].y);
                                _17715 = floor(_17711 + -0.5f);
                                _17716 = floor(_17712 + 0.5f);
                                _17718 = floor(_17711 + 0.5f);
                                _17720 = floor(_17712 + -0.5f);
                                _17721 = (_17715 < _17509);
                                _17722 = (_17716 < _17510);
                                if ((_17721 || _17722) | ((_17715 >= _17515) || (_17716 >= _17516))) {
                                  _17731 = _17478;
                                } else {
                                  _17731 = _17707.x;
                                }
                                _17732 = (_17718 < _17509);
                                if ((_17732 || _17722) | ((_17718 >= _17515) || (_17716 >= _17516))) {
                                  _17740 = _17478;
                                } else {
                                  _17740 = _17707.y;
                                }
                                _17741 = (_17720 < _17510);
                                if ((_17732 || _17741) | ((_17718 >= _17515) || (_17720 >= _17516))) {
                                  _17749 = _17478;
                                } else {
                                  _17749 = _17707.z;
                                }
                                if ((_17721 || _17741) | ((_17715 >= _17515) || (_17720 >= _17516))) {
                                  _17757 = _17478;
                                } else {
                                  _17757 = _17707.w;
                                }
                                _17758 = _17731 - _17458;
                                _17760 = select((_17758 < 0.0f), 0.0f, 1.0f);
                                _17764 = _17740 - _17458;
                                _17766 = select((_17764 < 0.0f), 0.0f, 1.0f);
                                _17770 = _17749 - _17458;
                                _17772 = select((_17770 < 0.0f), 0.0f, 1.0f);
                                _17776 = _17757 - _17458;
                                _17778 = select((_17776 < 0.0f), 0.0f, 1.0f);
                                _17785 = ((int)((uint)(asint(_cbSharedPerViewData_raw_uint[45u].x)) + 3u)) & 3;
                                _17790 = sqrt((float((int)(_17785)) * 0.25f) + 0.125f) * _17084;
                                _17799 = (_global_7[min((uint)(((int)(0u + (_17785 * 2)))), 127u)]) * _17790;
                                _17800 = (_global_7[min((uint)(((int)(1u + (_17785 * 2)))), 127u)]) * _17790;
                                _17803 = dot(float2(_17799, _17800), float2(_17473, _17472)) + _17448;
                                _17804 = dot(float2(_17799, _17800), float2(_17496, _17473)) + _17449;
                                _17806 = _HeapResource_60.GatherRed(samplerPointClampNode, float2(_17803, _17804));
                                _17810 = _17803 * (_cbSharedPerViewData_raw[82u].x);
                                _17811 = _17804 * (_cbSharedPerViewData_raw[82u].y);
                                _17814 = floor(_17810 + -0.5f);
                                _17815 = floor(_17811 + 0.5f);
                                _17817 = floor(_17810 + 0.5f);
                                _17819 = floor(_17811 + -0.5f);
                                _17820 = (_17814 < _17509);
                                _17821 = (_17815 < _17510);
                                if ((_17820 || _17821) | ((_17814 >= _17515) || (_17815 >= _17516))) {
                                  _17830 = _17478;
                                } else {
                                  _17830 = _17806.x;
                                }
                                _17831 = (_17817 < _17509);
                                if ((_17831 || _17821) | ((_17817 >= _17515) || (_17815 >= _17516))) {
                                  _17839 = _17478;
                                } else {
                                  _17839 = _17806.y;
                                }
                                _17840 = (_17819 < _17510);
                                if ((_17831 || _17840) | ((_17817 >= _17515) || (_17819 >= _17516))) {
                                  _17848 = _17478;
                                } else {
                                  _17848 = _17806.z;
                                }
                                if ((_17820 || _17840) | ((_17814 >= _17515) || (_17819 >= _17516))) {
                                  _17856 = _17478;
                                } else {
                                  _17856 = _17806.w;
                                }
                                _17857 = _17830 - _17458;
                                _17859 = select((_17857 < 0.0f), 0.0f, 1.0f);
                                _17863 = _17839 - _17458;
                                _17865 = select((_17863 < 0.0f), 0.0f, 1.0f);
                                _17869 = _17848 - _17458;
                                _17871 = select((_17869 < 0.0f), 0.0f, 1.0f);
                                _17875 = _17856 - _17458;
                                _17877 = select((_17875 < 0.0f), 0.0f, 1.0f);
                                _17878 = ((((((((((((((_17568 + _17564) + _17574) + _17580) + _17661) + _17667) + _17673) + _17679) + _17760) + _17766) + _17772) + _17778) + _17859) + _17865) + _17871) + _17877;
                                _17889 = (saturate(_17878 * 0.0625f) * 2.0f) + -1.0f;
                                _17895 = float((int)(((int)(uint)((int)(_17889 > 0.0f))) - ((int)(uint)((int)(_17889 < 0.0f)))));
                                _17897 = 1.0f - (_17895 * _17889);
                                _17899 = (_17897 * _17897) * _17897;
                                _17908 = (0.5f - ((_17895 * 0.5f) * ((1.0f - _17899) - ((_17897 - _17899) * saturate(((1.0f / _17458) * (1.0f / _17878)) * ((((((((((((((((_17568 * _17566) + (_17564 * _17562)) + (_17574 * _17572)) + (_17580 * _17578)) + (_17661 * _17659)) + (_17667 * _17665)) + (_17673 * _17671)) + (_17679 * _17677)) + (_17760 * _17758)) + (_17766 * _17764)) + (_17772 * _17770)) + (_17778 * _17776)) + (_17859 * _17857)) + (_17865 * _17863)) + (_17871 * _17869)) + (_17877 * _17875)))))));
                              } else {
                                _17908 = 1.0f;
                              }
                              _17913 = _17444;
                              _17914 = (lerp(_17908, _17443, _17444));
                            }
                            [branch]
                            if (!((_11892 & 2048) == 0)) {
                              Texture2D<float> _HeapResource_61 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_17023) >> 16))];
                              _17920 = _HeapResource_61.SampleLevel(samplerLinearClampNode, float2(_17144, _17145), 0.0f);
                              if (_17920.x > 0.0f) {
                                Texture2D<float4> _HeapResource_62 = ResourceDescriptorHeap[NonUniformResourceIndex((_17023 & 65535))];
                                _17927 = _HeapResource_62.SampleLevel(samplerLinearClampNode, float2(_17144, _17145), 0.0f);
                                _17941 = mad(saturate(((log2(_17095) * 0.6931471824645996f) - (_cbSharedPerViewData_raw[147u].w)) * (_cbSharedPerViewData_raw[148u].x)), 2.0f, -1.0f);
                                _17942 = max(9.999999747378752e-06f, _17920.x);
                                _17943 = _17927.x / _17942;
                                _17944 = _17927.y / _17942;
                                _17946 = _17927.w / _17942;
                                _17951 = ((0.375f - _17944) * 4.999999873689376e-06f) + _17944;
                                _17954 = -0.0f - _17943;
                                _17955 = mad(_17954, _17951, (_17927.z / _17942));
                                _17957 = 1.0f / mad(_17954, _17943, _17951);
                                _17958 = _17957 * _17955;
                                _17963 = _17941 - _17943;
                                _17968 = (((_17941 * _17941) - _17951) - (_17958 * _17963)) / mad((-0.0f - _17955), _17958, mad((-0.0f - _17951), _17951, (((0.375f - _17946) * 4.999999873689376e-06f) + _17946)));
                                _17970 = (_17957 * _17963) - (_17968 * _17958);
                                _17973 = 1.0f / _17968;
                                _17974 = _17970 * _17973;
                                _17979 = sqrt(((_17974 * _17974) * 0.25f) - ((1.0f - dot(float2(_17970, _17968), float2(_17943, _17951))) * _17973));
                                _17981 = (_17974 * -0.5f) - _17979;
                                _17983 = _17979 - (_17974 * 0.5f);
                                _17985 = select((_17981 < _17941), 1.0f, 0.0f);
                                _17990 = (_17985 + -0.05000000074505806f) / (_17981 - _17941);
                                _17996 = (((select((_17983 < _17941), 1.0f, 0.0f) - _17985) / (_17983 - _17981)) - _17990) / (_17983 - _17941);
                                _17998 = _17990 - (_17996 * _17981);
                                _18011 = _17913;
                                _18012 = (exp2((_17920.x * -1.4426950216293335f) * saturate((dot(float2(_17943, _17951), float2((_17998 - (_17996 * _17941)), _17996)) + 0.05000000074505806f) - (_17998 * _17941))) * _17914);
                              } else {
                                _18011 = _17913;
                                _18012 = _17914;
                              }
                            } else {
                              _18011 = _17913;
                              _18012 = _17914;
                            }
                          } else {
                            _18011 = 0.0f;
                            _18012 = 1.0f;
                          }
                          [branch]
                          if (!(_17067 == 0)) {
                            Texture2D<float3> _HeapResource_63 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _17067)))];
                            _18025 = _HeapResource_63.SampleLevel(samplerLinearWrapNode, float2(((_17144 * f16tof32(((uint)((uint)(_17029) >> 16)))) + f16tof32(((uint)((uint)(_17032) >> 16)))), ((_17145 * f16tof32(_17029)) + f16tof32(_17032))), 0.0f);
                            _18033 = (_18025.x * _17049);
                            _18034 = (_18025.y * _17050);
                            _18035 = (_18025.z * _17052);
                          } else {
                            _18033 = _17049;
                            _18034 = _17050;
                            _18035 = _17052;
                          }
                          _18036 = _18012 * _17168;
                          [branch]
                          if (!(_18036 == 0.0f)) {
                            bool __branch_chain_18038;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _18054 = 0;
                              __branch_chain_18038 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _18054 = 1;
                                __branch_chain_18038 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _18054 = 2;
                                  __branch_chain_18038 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _11895) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _18054 = 3;
                                    __branch_chain_18038 = true;
                                  } else {
                                    _18079 = _18036;
                                    __branch_chain_18038 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_18038) {
                              while(true) {
                                _18057 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_80, _81, 0));
                                if (_18054 == 0) {
                                  _18071 = _18057.x;
                                } else {
                                  if (_18054 == 1) {
                                    _18071 = _18057.y;
                                  } else {
                                    if (_18054 == 2) {
                                      _18071 = _18057.z;
                                    } else {
                                      _18071 = _18057.w;
                                    }
                                  }
                                }
                                _18079 = ((((_18011 * _18011) * ((_18071 * _18071) + -1.0f)) + 1.0f) * _17168);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_18079 > 0.0f) {
                                if (!(((_17026 & 1) == 0) || _17170)) {
                                  _18095 = max(max(_18033, _18034), _18035);
                                  if (_18095 > 0.0f) {
                                    _18105 = saturate(_18033 / _18095);
                                    _18106 = saturate(_18034 / _18095);
                                    _18107 = saturate(_18035 / _18095);
                                  } else {
                                    _18105 = _18033;
                                    _18106 = _18034;
                                    _18107 = _18035;
                                  }
                                  _18108 = (_18106 < _18107);
                                  _18109 = select(_18108, _18107, _18106);
                                  _18110 = select(_18108, _18106, _18107);
                                  _18111 = select(_18108, -1.0f, 0.0f);
                                  _18112 = (_18105 < _18109);
                                  _18114 = select(_18112, _18109, _18105);
                                  _18115 = select(_18112, _18105, _18109);
                                  _18119 = _18114 - select((_18115 < _18110), _18115, _18110);
                                  _18125 = abs(select(_18112, (-0.3333333432674408f - _18111), _18111) + ((_18115 - _18110) / ((_18119 * 6.0f) + 9.999999682655225e-21f)));
                                  if (_18125 < 0.6666666865348816f) {
                                    _18138 = ((saturate(((float)((uint)((uint)(((uint)(_17026) >> 9) & 255)))) * 0.003921499941498041f) * (select((_18125 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _18125)) + _18125);
                                  } else {
                                    _18138 = _18125;
                                  }
                                  _18139 = saturate((_18119 / (_18114 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_17026) >> 1) & 255)))) * 0.003921499941498041f));
                                  _18140 = saturate(_18114);
                                  if (!(_18139 <= 0.0f)) {
                                    _18143 = saturate(_18138);
                                    _18147 = select(((_18143 * 360.0f) >= 360.0f), 0.0f, (_18143 * 6.0f));
                                    _18148 = int(_18147);
                                    _18150 = _18147 - float((int)(_18148));
                                    _18152 = _18140 * (1.0f - _18139);
                                    _18155 = (1.0f - (_18150 * _18139)) * _18140;
                                    _18159 = (1.0f - ((1.0f - _18150) * _18139)) * _18140;
                                    switch (_18148) {
                                      case 0: {
                                        _18167 = _18140;
                                        _18168 = _18159;
                                        _18169 = _18152;
                                        break;
                                      }
                                      case 1: {
                                        _18167 = _18155;
                                        _18168 = _18140;
                                        _18169 = _18152;
                                        break;
                                      }
                                      case 2: {
                                        _18167 = _18152;
                                        _18168 = _18140;
                                        _18169 = _18159;
                                        break;
                                      }
                                      case 3: {
                                        _18167 = _18152;
                                        _18168 = _18155;
                                        _18169 = _18140;
                                        break;
                                      }
                                      case 4: {
                                        _18167 = _18159;
                                        _18168 = _18152;
                                        _18169 = _18140;
                                        break;
                                      }
                                      case 5: {
                                        _18167 = _18140;
                                        _18168 = _18152;
                                        _18169 = _18155;
                                        break;
                                      }
                                      default: {
                                        _18167 = 0.0f;
                                        _18168 = 0.0f;
                                        _18169 = 0.0f;
                                        break;
                                      }
                                    }
                                  } else {
                                    _18167 = _18140;
                                    _18168 = _18140;
                                    _18169 = _18140;
                                  }
                                  _18170 = _18167 * _18095;
                                  _18171 = _18168 * _18095;
                                  _18172 = _18169 * _18095;
                                  _18174 = saturate(_18012 * 1.0101009607315063f);
                                  _18185 = ((_18174 * (_18033 - _18170)) + _18170);
                                  _18186 = ((_18174 * (_18034 - _18171)) + _18171);
                                  _18187 = (lerp(_18172, _18035, _18174));
                                } else {
                                  _18185 = _18033;
                                  _18186 = _18034;
                                  _18187 = _18035;
                                }
                                [branch]
                                if (!(asint(_cbSharedPerViewData_raw_uint[109u].x) == 0)) {
                                  _18194 = srvLightMappingData[_11895];
                                  if (!(_18194 == -1)) {
                                    _18199 = srvLightIndexData[_18194].nLayerIndex;
                                    _18201 = srvLightIndexData[_18194].vAtlasOrigin.x;
                                    _18202 = srvLightIndexData[_18194].vAtlasOrigin.y;
                                    _18204 = srvLightIndexData[_18194].vScreenOrigin.x;
                                    _18205 = srvLightIndexData[_18194].vScreenOrigin.y;
                                    _18214 = ((int)(_18199 * 5)) & 31;
                                    _18223 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_18201 + _80) - _18204)), ((int)((_18202 + _81) - _18205)), 0)))).x) & ((int)(31 << _18214)))) >> _18214)) >> 1)))) * 0.06666667014360428f) * _18079);
                                  } else {
                                    _18223 = _18079;
                                  }
                                } else {
                                  _18223 = _18079;
                                }
                                _18230 = _17096 * _17095;
                                _18231 = _17097 * _17095;
                                _18232 = _17098 * _17095;
                                _18233 = _17057 * _16991;
                                _18234 = _17057 * _16992;
                                _18235 = _17057 * _16993;
                                _18236 = _18230 + _18233;
                                _18237 = _18231 + _18234;
                                _18238 = _18232 + _18235;
                                _18239 = _18230 - _18233;
                                _18240 = _18231 - _18234;
                                _18241 = _18232 - _18235;
                                _18242 = (_17057 > 0.0f);
                                _18243 = dot(float3(_18236, _18237, _18238), float3(_18236, _18237, _18238));
                                _18244 = rsqrt(_18243);
                                [branch]
                                if (_18242) {
                                  _18247 = rsqrt(dot(float3(_18239, _18240, _18241), float3(_18239, _18240, _18241)));
                                  _18248 = _18247 * _18244;
                                  _18250 = dot(float3(_18236, _18237, _18238), float3(_18239, _18240, _18241)) * _18248;
                                  _18269 = (_18248 / ((_18248 + 0.5f) + (_18250 * 0.5f)));
                                  _18270 = (((dot(float3(_205, _207, _209), float3(_18239, _18240, _18241)) * _18247) + (dot(float3(_205, _207, _209), float3(_18236, _18237, _18238)) * _18244)) * 0.5f);
                                  _18271 = _18250;
                                } else {
                                  _18269 = (1.0f / (_18243 + 1.0f));
                                  _18270 = dot(float3(_205, _207, _209), float3((_18244 * _18236), (_18244 * _18237), (_18244 * _18238)));
                                  _18271 = 1.0f;
                                }
                                if (_17059 > 0.0f) {
                                  _18277 = sqrt(saturate((_17059 * _17059) * _18269));
                                  if (_18270 < _18277) {
                                    _18282 = max(_18270, (-0.0f - _18277)) + _18277;
                                    _18287 = ((_18282 * _18282) / (_18277 * 4.0f));
                                  } else {
                                    _18287 = _18270;
                                  }
                                } else {
                                  _18287 = _18270;
                                }
                                if (_18242) {
                                  _18289 = -0.0f - _257;
                                  _18290 = -0.0f - _258;
                                  _18291 = -0.0f - _256;
                                  _18293 = dot(float3(_18289, _18290, _18291), float3(_205, _207, _209)) * 2.0f;
                                  _18297 = _18289 - (_18293 * _205);
                                  _18298 = _18290 - (_18293 * _207);
                                  _18299 = _18291 - (_18293 * _209);
                                  _18300 = _18239 - _18236;
                                  _18301 = _18240 - _18237;
                                  _18302 = _18241 - _18238;
                                  _18303 = dot(float3(_18297, _18298, _18299), float3(_18300, _18301, _18302));
                                  _18309 = sqrt(((_18300 * _18300) + (_18301 * _18301)) + (_18302 * _18302));
                                  _18318 = saturate(((dot(float3(_18297, _18298, _18299), float3(_18236, _18237, _18238)) * _18303) - dot(float3(_18236, _18237, _18238), float3(_18300, _18301, _18302))) / ((_18309 * _18309) - (_18303 * _18303)));
                                  _18322 = (_18318 * _18300) + _18236;
                                  _18323 = (_18318 * _18301) + _18237;
                                  _18324 = (_18318 * _18302) + _18238;
                                  _18325 = dot(float3(_18322, _18323, _18324), float3(_18297, _18298, _18299));
                                  _18329 = (_18325 * _18297) - _18322;
                                  _18330 = (_18325 * _18298) - _18323;
                                  _18331 = (_18325 * _18299) - _18324;
                                  _18339 = saturate(0.009999999776482582f / sqrt(((_18329 * _18329) + (_18330 * _18330)) + (_18331 * _18331)));
                                  _18347 = ((_18339 * _18329) + _18322);
                                  _18348 = ((_18339 * _18330) + _18323);
                                  _18349 = ((_18339 * _18331) + _18324);
                                } else {
                                  _18347 = _18236;
                                  _18348 = _18237;
                                  _18349 = _18238;
                                }
                                _18351 = rsqrt(dot(float3(_18347, _18348, _18349), float3(_18347, _18348, _18349)));
                                _18352 = _18351 * _18347;
                                _18353 = _18351 * _18348;
                                _18354 = _18351 * _18349;
                                _18355 = _231 * _231;
                                _18356 = 1.0f - _18355;
                                _18359 = saturate((_17059 * _18356) * _18351);
                                _18361 = saturate(_18351 * f16tof32(_17005));
                                _18362 = dot(float3(_205, _207, _209), float3(_18352, _18353, _18354));
                                _18363 = dot(float3(_205, _207, _209), float3(_257, _258, _256));
                                _18364 = dot(float3(_257, _258, _256), float3(_18352, _18353, _18354));
                                _18367 = rsqrt((_18364 * 2.0f) + 2.0f);
                                _18370 = saturate(_18367 * (_18363 + _18362));
                                _18373 = saturate((_18367 * _18364) + _18367);
                                _18374 = (_18359 > 0.0f);
                                if (_18374) {
                                  _18378 = sqrt(1.0f - (_18359 * _18359));
                                  _18380 = (_18362 * 2.0f) * _18363;
                                  _18381 = _18380 - _18364;
                                  if (!(_18381 >= _18378)) {
                                    _18389 = rsqrt(1.0f - (_18381 * _18381)) * _18359;
                                    _18392 = _18389 * (_18363 - (_18381 * _18362));
                                    _18393 = _18363 * _18363;
                                    _18398 = _18389 * (((_18393 * 2.0f) + -1.0f) - (_18381 * _18364));
                                    _18407 = sqrt(saturate((((1.0f - (_18362 * _18362)) - _18393) - (_18364 * _18364)) + (_18380 * _18364)));
                                    _18408 = _18407 * _18389;
                                    _18411 = ((_18363 * 2.0f) * _18389) * _18407;
                                    _18413 = (_18378 * _18362) + _18363;
                                    _18414 = _18413 + _18392;
                                    _18415 = _18378 * _18364;
                                    _18417 = (_18415 + 1.0f) + _18398;
                                    _18418 = _18408 * _18417;
                                    _18419 = _18414 * _18417;
                                    _18420 = _18411 * _18414;
                                    _18425 = (((_18414 * 0.25f) * _18411) - (_18418 * 0.5f)) * _18419;
                                    _18439 = (((_18420 - (_18418 * 2.0f)) * _18420) + (_18418 * _18418)) + ((((-0.5f - ((_18417 + _18415) * 0.5f)) * _18419) + ((_18417 * _18417) * _18413)) * _18414);
                                    _18444 = (_18425 * 2.0f) / ((_18439 * _18439) + (_18425 * _18425));
                                    _18445 = _18439 * _18444;
                                    _18447 = 1.0f - (_18425 * _18444);
                                    _18453 = ((_18445 * _18411) + _18415) + (_18447 * _18398);
                                    _18456 = rsqrt((_18453 * 2.0f) + 2.0f);
                                    _18465 = saturate((_18453 * _18456) + _18456);
                                    _18466 = saturate(((_18413 + (_18445 * _18408)) + (_18447 * _18392)) * _18456);
                                  } else {
                                    _18465 = abs(_18363);
                                    _18466 = 1.0f;
                                  }
                                } else {
                                  _18465 = _18373;
                                  _18466 = _18370;
                                }
                                _18467 = saturate(_18287);
                                _18468 = _18355 * _18355;
                                _18469 = (_18361 > 0.0f);
                                if (_18469) {
                                  _18478 = saturate(((_18361 * _18361) / ((_18465 * 3.5999999046325684f) + 0.4000000059604645f)) + _18468);
                                } else {
                                  _18478 = _18468;
                                }
                                if (_18374) {
                                  _18487 = (((_18359 * 0.25f) * ((sqrt(_18478) * 3.0f) + _18359)) / (_18465 + 0.0010000000474974513f)) + _18478;
                                  _18490 = _18487;
                                  _18491 = (_18478 / _18487);
                                } else {
                                  _18490 = _18478;
                                  _18491 = 1.0f;
                                }
                                _18492 = (_18271 < 1.0f);
                                if (_18492) {
                                  _18498 = sqrt((1.000100016593933f - _18271) / max(9.999999974752427e-07f, (_18271 + 1.0f)));
                                  _18511 = (sqrt(_18490 / ((((_18498 * 0.25f) * ((sqrt(_18490) * 3.0f) + _18498)) / (_18465 + 0.0010000000474974513f)) + _18490)) * _18491);
                                } else {
                                  _18511 = _18491;
                                }
                                _18515 = (((_18478 * _18466) - _18466) * _18466) + 1.0f;
                                _18525 = abs(_18363);
                                _18527 = saturate(_18525 + 9.999999747378752e-06f);
                                _18528 = sqrt(_18478);
                                _18529 = 1.0f - _18528;
                                _18541 = saturate(select((_18356 > 0.0f), 1.0f, 0.0f) * _18359);
                                _18542 = (_18541 > 0.0f);
                                if (_18542) {
                                  _18546 = sqrt(1.0f - (_18541 * _18541));
                                  _18548 = (_18362 * 2.0f) * _18363;
                                  _18549 = _18548 - _18364;
                                  if (!(_18549 >= _18546)) {
                                    _18555 = rsqrt(1.0f - (_18549 * _18549)) * _18541;
                                    _18558 = _18555 * (_18363 - (_18549 * _18362));
                                    _18559 = _18363 * _18363;
                                    _18564 = _18555 * (((_18559 * 2.0f) + -1.0f) - (_18549 * _18364));
                                    _18573 = sqrt(saturate((((1.0f - (_18362 * _18362)) - _18559) - (_18364 * _18364)) + (_18548 * _18364)));
                                    _18574 = _18573 * _18555;
                                    _18577 = ((_18363 * 2.0f) * _18555) * _18573;
                                    _18579 = (_18546 * _18362) + _18363;
                                    _18580 = _18579 + _18558;
                                    _18581 = _18546 * _18364;
                                    _18583 = (_18581 + 1.0f) + _18564;
                                    _18584 = _18574 * _18583;
                                    _18585 = _18580 * _18583;
                                    _18586 = _18577 * _18580;
                                    _18591 = (((_18580 * 0.25f) * _18577) - (_18584 * 0.5f)) * _18585;
                                    _18605 = (((_18586 - (_18584 * 2.0f)) * _18586) + (_18584 * _18584)) + ((((-0.5f - ((_18583 + _18581) * 0.5f)) * _18585) + ((_18583 * _18583) * _18579)) * _18580);
                                    _18610 = (_18591 * 2.0f) / ((_18605 * _18605) + (_18591 * _18591));
                                    _18611 = _18605 * _18610;
                                    _18613 = 1.0f - (_18591 * _18610);
                                    _18619 = ((_18611 * _18577) + _18581) + (_18613 * _18564);
                                    _18622 = rsqrt((_18619 * 2.0f) + 2.0f);
                                    _18631 = saturate((_18619 * _18622) + _18622);
                                    _18632 = saturate(((_18579 + (_18611 * _18574)) + (_18613 * _18558)) * _18622);
                                  } else {
                                    _18631 = _18525;
                                    _18632 = 1.0f;
                                  }
                                } else {
                                  _18631 = _18373;
                                  _18632 = _18370;
                                }
                                if (_18469) {
                                  _18641 = saturate(((_18361 * _18361) / ((_18631 * 3.5999999046325684f) + 0.4000000059604645f)) + _18468);
                                } else {
                                  _18641 = _18468;
                                }
                                if (_18542) {
                                  _18650 = (((_18541 * 0.25f) * ((sqrt(_18641) * 3.0f) + _18541)) / (_18631 + 0.0010000000474974513f)) + _18641;
                                  _18653 = _18650;
                                  _18654 = (_18641 / _18650);
                                } else {
                                  _18653 = _18641;
                                  _18654 = 1.0f;
                                }
                                if (_18492) {
                                  _18660 = sqrt((1.000100016593933f - _18271) / max(9.999999974752427e-07f, (_18271 + 1.0f)));
                                  _18673 = (sqrt(_18653 / ((((_18660 * 0.25f) * ((sqrt(_18653) * 3.0f) + _18660)) / (_18631 + 0.0010000000474974513f)) + _18653)) * _18654);
                                } else {
                                  _18673 = _18654;
                                }
                                _18677 = (((_18641 * _18632) - _18632) * _18632) + 1.0f;
                                _18678 = sqrt(_18641);
                                _18679 = 1.0f - _18678;
                                if (_17056 > 0.0f) {
                                  _18711 = ((((exp2(log2(1.0f - saturate(_18631)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _181) * (((_18673 * _18467) * (_18641 / (_18677 * _18677))) * (0.5f / ((((_18679 * _18527) + _18678) * _18467) + (((_18679 * _18467) + _18678) * _18527))))) + ((((_18511 * _18467) * (_18478 / (_18515 * _18515))) * (0.5f / ((((_18529 * _18527) + _18528) * _18467) + (((_18529 * _18467) + _18528) * _18527)))) * ((exp2(log2(1.0f - saturate(_18465)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f));
                                  _18713 = (_17056 * _11767) * select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_18223 * _11694), _18223);
                                  _19167 = (((_18713 * (_18185 * _11942)) * _18711) + _11884);
                                  _19168 = (((_18713 * (_18186 * _11942)) * _18711) + _11885);
                                  _19169 = (((_18713 * (_18187 * _11942)) * _18711) + _11886);
                                } else {
                                  _19167 = _11884;
                                  _19168 = _11885;
                                  _19169 = _11886;
                                }
                              } else {
                                _19167 = _11884;
                                _19168 = _11885;
                                _19169 = _11886;
                              }
                              break;
                            }
                          } else {
                            _19167 = _11884;
                            _19168 = _11885;
                            _19169 = _11886;
                          }
                        } else {
                          if (_11925 == 10) {
                            _18728 = asfloat(srvLightInfoProperties.Load4(_11894)).x;
                            _18729 = asfloat(srvLightInfoProperties.Load4(_11894)).y;
                            _18730 = asfloat(srvLightInfoProperties.Load4(_11894)).z;
                            _18731 = asfloat(srvLightInfoProperties.Load4(_11894)).w;
                            _18734 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).x;
                            _18735 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).y;
                            _18736 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).z;
                            _18737 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 16u)))).w;
                            _18740 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).x;
                            _18741 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).y;
                            _18742 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).z;
                            _18743 = asfloat(srvLightInfoProperties.Load4(((int)(_11894 + 32u)))).w;
                            _18746 = asfloat(srvLightInfoProperties.Load2(((int)(_11894 + 72u)))).x;
                            _18747 = asfloat(srvLightInfoProperties.Load2(((int)(_11894 + 72u)))).y;
                            _18750 = asint(srvLightInfoProperties.Load(((int)(_11894 + 80u))));
                            _18753 = asint(srvLightInfoProperties.Load(((int)(_11894 + 84u))));
                            _18756 = asint(srvLightInfoProperties.Load(((int)(_11894 + 88u))));
                            _18759 = asint(srvLightInfoProperties.Load(((int)(_11894 + 96u))));
                            _18762 = f16tof32(_18750);
                            _18771 = ((float)((uint)((uint)(((uint)(_18756) >> 8) & 255)))) * 0.003921499941498041f;
                            _18777 = mad(_18730, _246, mad(_18729, _245, (_18728 * _244))) + _18731;
                            _18781 = mad(_18736, _246, mad(_18735, _245, (_18734 * _244))) + _18737;
                            _18785 = mad(_18742, _246, mad(_18741, _245, (_18740 * _244))) + _18743;
                            _18788 = mad(_18730, _209, mad(_18729, _207, (_18728 * _205)));
                            _18791 = mad(_18736, _209, mad(_18735, _207, (_18734 * _205)));
                            _18794 = mad(_18742, _209, mad(_18741, _207, (_18740 * _205)));
                            _18806 = -0.0f - mad(_18742, _256, mad(_18741, _258, (_18740 * _257)));
                            _18807 = _18746 * 0.5f;
                            _18808 = _18747 * 0.5f;
                            _18809 = -0.0f - _18807;
                            _18810 = -0.0f - _18808;
                            _18811 = _18809 - _18777;
                            _18812 = _18810 - _18781;
                            _18813 = -0.0f - _18785;
                            _18814 = _18807 - _18777;
                            _18815 = _18808 - _18781;
                            _18816 = dot(float3(_18777, _18781, _18785), float3(_18788, _18791, _18794));
                            _18818 = dot(float3(_18809, _18810, 0.0f), float3(_18788, _18791, _18794)) - _18816;
                            _18820 = dot(float3(_18807, _18810, 0.0f), float3(_18788, _18791, _18794)) - _18816;
                            _18822 = dot(float3(_18807, _18808, 0.0f), float3(_18788, _18791, _18794)) - _18816;
                            _18824 = dot(float3(_18809, _18808, 0.0f), float3(_18788, _18791, _18794)) - _18816;
                            _18825 = min(_18818, _18820);
                            [branch]
                            if (!(!(_18825 >= 0.0f))) {
                              _18831 = rsqrt(dot(float3(_18814, _18812, _18813), float3(_18814, _18812, _18813)) * dot(float3(_18811, _18812, _18813), float3(_18811, _18812, _18813)));
                              _18833 = dot(float3(_18811, _18812, _18813), float3(_18814, _18812, _18813)) * _18831;
                              _18840 = rsqrt(max(((((_18833 * 0.09300000220537186f) + 0.5f) * _18833) + 0.40700000524520874f), 9.999999682655225e-21f)) * _18831;
                              _18847 = (_18840 * (_18746 * _18813));
                              _18848 = (_18840 * (_18812 * (_18809 - _18807)));
                            } else {
                              _18847 = 0.0f;
                              _18848 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_18820, _18822) >= 0.0f))) {
                              _18855 = rsqrt(dot(float3(_18814, _18815, _18813), float3(_18814, _18815, _18813)) * dot(float3(_18814, _18812, _18813), float3(_18814, _18812, _18813)));
                              _18857 = dot(float3(_18814, _18812, _18813), float3(_18814, _18815, _18813)) * _18855;
                              _18864 = rsqrt(max(((((_18857 * 0.09300000220537186f) + 0.5f) * _18857) + 0.40700000524520874f), 9.999999682655225e-21f)) * _18855;
                              _18872 = (_18864 * ((_18810 - _18808) * _18813));
                              _18873 = ((_18864 * (_18747 * _18814)) + _18848);
                            } else {
                              _18872 = 0.0f;
                              _18873 = _18848;
                            }
                            _18874 = min(_18822, _18824);
                            [branch]
                            if (!(!(_18874 >= 0.0f))) {
                              _18880 = rsqrt(dot(float3(_18811, _18815, _18813), float3(_18811, _18815, _18813)) * dot(float3(_18814, _18815, _18813), float3(_18814, _18815, _18813)));
                              _18882 = dot(float3(_18814, _18815, _18813), float3(_18811, _18815, _18813)) * _18880;
                              _18889 = rsqrt(max(((((_18882 * 0.09300000220537186f) + 0.5f) * _18882) + 0.40700000524520874f), 9.999999682655225e-21f)) * _18880;
                              _18898 = ((_18889 * ((_18809 - _18807) * _18813)) + _18847);
                              _18899 = ((_18889 * (_18746 * _18815)) + _18873);
                            } else {
                              _18898 = _18847;
                              _18899 = _18873;
                            }
                            [branch]
                            if (!(!(min(_18824, _18818) >= 0.0f))) {
                              _18906 = rsqrt(dot(float3(_18811, _18812, _18813), float3(_18811, _18812, _18813)) * dot(float3(_18811, _18815, _18813), float3(_18811, _18815, _18813)));
                              _18908 = dot(float3(_18811, _18815, _18813), float3(_18811, _18812, _18813)) * _18906;
                              _18915 = rsqrt(max(((((_18908 * 0.09300000220537186f) + 0.5f) * _18908) + 0.40700000524520874f), 9.999999682655225e-21f)) * _18906;
                              _18924 = ((_18915 * (_18747 * _18813)) + _18872);
                              _18925 = ((_18915 * (_18811 * (_18810 - _18808))) + _18899);
                            } else {
                              _18924 = _18872;
                              _18925 = _18899;
                            }
                            if (min(_18825, _18874) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_18818, _18820), max(_18822, _18824)) >= 0.0f))) {
                                _18934 = -0.0f - _18788;
                                _18935 = _18816 / _18791;
                                _18936 = _18809 / _18791;
                                _18937 = _18807 / _18791;
                                _18939 = (_18810 - _18935) / _18934;
                                _18941 = (_18808 - _18935) / _18934;
                                _18942 = min(_18936, _18937);
                                _18943 = max(_18936, _18937);
                                _18944 = min(_18939, _18941);
                                _18945 = max(_18939, _18941);
                                _18946 = max(_18942, _18944);
                                _18947 = min(_18943, _18945);
                                _18948 = _18946 * _18791;
                                _18950 = _18947 * _18791;
                                _18952 = _18948 - _18777;
                                _18953 = _18935 - _18781;
                                _18954 = _18953 + (_18946 * _18934);
                                _18955 = _18950 - _18777;
                                _18956 = _18953 + (_18947 * _18934);
                                _18957 = dot(float3(_18952, _18954, _18813), float3(_18952, _18954, _18813));
                                _18958 = dot(float3(_18955, _18956, _18813), float3(_18955, _18956, _18813));
                                _18960 = rsqrt(_18958 * _18957);
                                _18962 = dot(float3(_18952, _18954, _18813), float3(_18955, _18956, _18813)) * _18960;
                                _18969 = rsqrt(max(((((_18962 * 0.09300000220537186f) + 0.5f) * _18962) + 0.40700000524520874f), 9.999999682655225e-21f)) * _18960;
                                _18982 = (_18942 > _18944);
                                _18984 = select(_18982, _18791, _18788);
                                _18990 = float((int)(((int)(uint)((int)(_18984 > 0.0f))) - ((int)(uint)((int)(_18984 < 0.0f)))));
                                _18994 = ((1.0f - (((float)((bool)_18982)) * 2.0f)) * _18807) * _18990;
                                _18996 = _18994 - _18777;
                                _18997 = (_18990 * _18808) - _18781;
                                _18998 = (_18943 < _18945);
                                _19000 = select(_18998, _18791, _18788);
                                _19006 = float((int)(((int)(uint)((int)(_19000 > 0.0f))) - ((int)(uint)((int)(_19000 < 0.0f)))));
                                _19007 = _19006 * _18807;
                                _19012 = _19007 - _18777;
                                _19013 = ((((((float)((bool)_18998)) * 2.0f) + -1.0f) * _18808) * _19006) - _18781;
                                _19016 = rsqrt(_18957 * dot(float3(_18996, _18997, _18813), float3(_18996, _18997, _18813)));
                                _19018 = dot(float3(_18996, _18997, _18813), float3(_18952, _18954, _18813)) * _19016;
                                _19025 = rsqrt(max(((((_19018 * 0.09300000220537186f) + 0.5f) * _19018) + 0.40700000524520874f), 9.999999682655225e-21f)) * _19016;
                                _19038 = rsqrt(dot(float3(_19012, _19013, _18813), float3(_19012, _19013, _18813)) * _18958);
                                _19040 = dot(float3(_18955, _18956, _18813), float3(_19012, _19013, _18813)) * _19038;
                                _19047 = rsqrt(max(((((_19040 * 0.09300000220537186f) + 0.5f) * _19040) + 0.40700000524520874f), 9.999999682655225e-21f)) * _19038;
                                _19068 = ((((_18969 * (((_18946 - _18947) * _18934) * _18813)) + _18924) + (_19025 * ((_18997 - _18954) * _18813))) + (_19047 * ((_18956 - _19013) * _18813)));
                                _19069 = ((((_18969 * ((_18791 * (_18947 - _18946)) * _18813)) + _18898) + (_19025 * ((_18948 - _18994) * _18813))) + (_19047 * ((_19007 - _18950) * _18813)));
                                _19070 = ((((_18969 * ((_18956 * _18952) - (_18955 * _18954))) + _18925) + (_19025 * ((_18996 * _18954) - (_18997 * _18952)))) + (_19047 * ((_19013 * _18955) - (_19012 * _18956))));
                              } else {
                                _19068 = _18924;
                                _19069 = _18898;
                                _19070 = _18925;
                              }
                            } else {
                              _19068 = _18924;
                              _19069 = _18898;
                              _19070 = _18925;
                            }
                            _19077 = sqrt(((_19069 * _19069) + (_19068 * _19068)) + (_19070 * _19070)) * 0.15915493667125702f;
                            [branch]
                            if (!(_19077 == 0.0f)) {
                              _19086 = saturate((_19077 - _18762) / (1.0f - _18762)) * ((float)((bool)(uint)(_18785 <= 0.0f)));
                              [branch]
                              if (!(_19086 == 0.0f)) {
                                _19089 = 1.0f - _231;
                                _19094 = min(_231, 0.800000011920929f);
                                _19103 = exp2(((((((_19094 * 3.322999954223633f) + -3.7669999599456787f) * _19094) + -0.3479999899864197f) * _19094) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _19110 = _18813 / (_18806 - ((_18794 * 2.0f) * dot(float3((-0.0f - mad(_18730, _256, mad(_18729, _258, (_18728 * _257)))), (-0.0f - mad(_18736, _256, mad(_18735, _258, (_18734 * _257)))), _18806), float3(_18788, _18791, _18794))));
                                _19113 = (_19110 * 2.0f) * rsqrt(((9.999999747378752e-05f - _19103) * saturate((_231 + -0.5f) * 2.500000238418579f)) + _19103);
                                _19121 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, ((float)((uint)((uint)(_18759 & 65535))))), ((log2((_19113 * _19113) * f16tof32(((uint)((uint)(_18750) >> 16)))) * 0.5f) + 5.5f));
                                _19123 = (float)((bool)(uint)(_19110 > 0.0f));
                                if (_18771 > 0.0f) {
                                  _19145 = ((max((_19089 * _19089), 0.03999999910593033f) + -0.03999999910593033f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_257, _258, _256)))) * 5.0f)) + 0.03999999910593033f;
                                  _19146 = _18771 * _11767;
                                  _19147 = select(((asint(_cbSharedPerViewData_raw_uint[102u].w) & 2048) != 0), (_19086 * _11694), _19086) * _11942;
                                  _19167 = ((((((_19146 * f16tof32(((uint)((uint)(_18753) >> 16)))) * _19123) * _19121.x) * _19147) * _19145) + _11884);
                                  _19168 = ((((((_19146 * f16tof32(_18753)) * _19123) * _19121.y) * _19147) * _19145) + _11885);
                                  _19169 = ((((((f16tof32(((uint)((uint)(_18756) >> 16))) * _19146) * _19123) * _19121.z) * _19147) * _19145) + _11886);
                                } else {
                                  _19167 = _11884;
                                  _19168 = _11885;
                                  _19169 = _11886;
                                }
                              } else {
                                _19167 = _11884;
                                _19168 = _11885;
                                _19169 = _11886;
                              }
                            } else {
                              _19167 = _11884;
                              _19168 = _11885;
                              _19169 = _11886;
                            }
                          } else {
                            _19167 = _11884;
                            _19168 = _11885;
                            _19169 = _11886;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _19167 = _11884;
              _19168 = _11885;
              _19169 = _11886;
            }
          } else {
            _19167 = _11884;
            _19168 = _11885;
            _19169 = _11886;
          }
          _19170 = _11883 + 1u;
          if (!(_19170 == _global_2)) {
            _11883 = _19170;
            _11884 = _19167;
            _11885 = _19168;
            _11886 = _19169;
            continue;
          }
          _19174 = _19167;
          _19175 = _19168;
          _19176 = _19169;
          break;
        }
      } else {
        _19174 = _11768;
        _19175 = _11769;
        _19176 = _11770;
      }
      _19182 = (exp2(log2(1.0f - _9782) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
      _19328 = (_9794 * _9769);
      _19329 = (_9794 * _9770);
      _19330 = (_9794 * _9771);
      _19331 = (((_19174 * _181) * _19182) + _9772);
      _19332 = (((_19175 * _181) * _19182) + _9773);
      _19333 = (((_19176 * _181) * _19182) + _9774);
      _19334 = (_249 * _176);
      _19335 = (_249 * _177);
      _19336 = (_249 * _178);
    } else {
      _19207 = mad((_cbSharedPerViewData_raw[12u].z), -1.0f, mad((_cbSharedPerViewData_raw[12u].y), _152, ((_cbSharedPerViewData_raw[12u].x) * _151)));
      _19210 = mad((_cbSharedPerViewData_raw[13u].z), -1.0f, mad((_cbSharedPerViewData_raw[13u].y), _152, ((_cbSharedPerViewData_raw[13u].x) * _151)));
      _19213 = mad((_cbSharedPerViewData_raw[14u].z), -1.0f, mad((_cbSharedPerViewData_raw[14u].y), _152, ((_cbSharedPerViewData_raw[14u].x) * _151)));
      [branch]
      if (asint(_cbSharedPerViewData_raw_uint[80u].x) == 0) {
        _19317 = ((_cbSharedPerViewData_raw[61u].x) * (_cbSharedPerViewData_raw[81u].x));
        _19318 = ((_cbSharedPerViewData_raw[61u].x) * (_cbSharedPerViewData_raw[81u].y));
        _19319 = ((_cbSharedPerViewData_raw[61u].x) * (_cbSharedPerViewData_raw[81u].z));
      } else {
        _19234 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_19207, _19210, _19213), 0.0f);
        _19238 = _19234.x * 32.0f;
        _19239 = _19234.y * 32.0f;
        _19240 = _19234.z * 32.0f;
        _19242 = rsqrt(dot(float3(_19207, _19210, _19213), float3(_19207, _19210, _19213)));
        _19243 = _19242 * _19207;
        _19244 = _19242 * _19210;
        _19245 = _19242 * _19213;
        _19246 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _19247 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _19248 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _19249 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _19250 = dot(float3(_19243, _19244, _19245), float3(_19247, _19248, _19249));
        _19255 = (_19250 * _19250) - (dot(float3(_19247, _19248, _19249), float3(_19247, _19248, _19249)) - (_19246 * _19246));
        if ((_19250 > -0.0f) && (_19255 > 0.0f)) {
          _19260 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _19273 = 74.80000305175781f / ((dot(float3(_19243, _19244, _19245), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _19246) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _19281 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_19243, _19245), float2(_19260, cbDeferredShading.vSunDirWS.x)) * _19273) + 0.5f), ((dot(float3(_19243, _19244, _19245), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _19260)), (cbDeferredShading.vSunDirWS.y * _19260))) * _19273) + 0.5f)), 0.0f);
          _19283 = _19255 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_19283 > 0.0f) {
            _19290 = saturate(_19283 * 5.0f);
            _19317 = ((((((_cbSharedPerViewData_raw[70u].x) * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _19281.x) * _19290) + _19238);
            _19318 = ((((((_cbSharedPerViewData_raw[70u].y) * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _19281.y) * _19290) + _19239);
            _19319 = ((((((_cbSharedPerViewData_raw[70u].z) * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _19281.z) * _19290) + _19240);
          } else {
            _19317 = _19238;
            _19318 = _19239;
            _19319 = _19240;
          }
        } else {
          _19317 = _19238;
          _19318 = _19239;
          _19319 = _19240;
        }
      }
      _19323 = ((asint(_cbSharedPerViewData_raw_uint[102u].w) & 256) != 0);
      _19328 = 0.0f;
      _19329 = 0.0f;
      _19330 = 0.0f;
      _19331 = select(_19323, 0.0f, _19317);
      _19332 = select(_19323, 0.0f, _19318);
      _19333 = select(_19323, 0.0f, _19319);
      _19334 = 0.0f;
      _19335 = 0.0f;
      _19336 = 0.0f;
    }
    uavDeferredShadingPass_Specular[int2(_80, _81)] = float3(max(min(((_cbSharedPerViewData_raw[61u].y) * ((_19334 * _19328) + _19331)), 7936.0f), 5.960464477539063e-08f), max(min(((_cbSharedPerViewData_raw[61u].y) * ((_19335 * _19329) + _19332)), 7936.0f), 5.960464477539063e-08f), max(min((((_19336 * _19330) + _19333) * (_cbSharedPerViewData_raw[61u].y)), 7936.0f), 5.960464477539063e-08f));
    uavDeferredShadingPass_Diffuse[int2(_80, _81)] = float3(0.0f, 0.0f, 0.0f);
  }
}