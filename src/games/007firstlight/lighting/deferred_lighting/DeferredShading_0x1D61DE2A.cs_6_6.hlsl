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

StructuredBuffer<uint> srvLightFeaturePermutationTiles : register(t45);

StructuredBuffer<uint> srvDeferredClusters : register(t46);

StructuredBuffer<uint4> srvFallbackInfo : register(t29);

StructuredBuffer<uint4> srvRoomInfo : register(t84);

Texture2DArray<float4> srvBillboardArray : register(t16);

Texture2D<float4> srvPreintegratedGGXLUT : register(t110);

Texture2D<float4> srvReflectionsColor : register(t80);

Texture2D<uint> srvReflectionsWeight : register(t81);

Texture2D<float4> srvBlurredGbufNormal : register(t95);

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

cbuffer _cbSkinFeatures : register(b5) {
  float4 _cbSkinFeatures_raw[129] : packoffset(c0);
  uint4 _cbSkinFeatures_raw_uint[129] : packoffset(c0);
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
  uint _59;
  int _65;
  uint _70;
  uint _71;
  uint _78;
  int _81;
  int _96;
  float _219;
  float _220;
  float _251;
  float _252;
  float _253;
  float _254;
  float _255;
  float _256;
  float _257;
  float _258;
  float _268;
  int _269;
  float _270;
  float _308;
  int _309;
  int _310;
  int _311;
  int _312;
  int _313;
  float _314;
  float _315;
  float _316;
  bool _325;
  int _332;
  float _333;
  float _334;
  float _335;
  float _418;
  float _419;
  float _420;
  float _421;
  float _511;
  float _512;
  float _550;
  int _589;
  float _590;
  float _591;
  float _592;
  float _683;
  float _684;
  float _685;
  float _686;
  float _687;
  float _688;
  int _755;
  float _756;
  float _757;
  float _758;
  float _759;
  float _760;
  float _761;
  float _762;
  float _763;
  float _764;
  float _765;
  float _766;
  float _767;
  float _768;
  float _769;
  float _884;
  float _885;
  float _886;
  float _973;
  float _974;
  float _975;
  float _993;
  float _994;
  float _995;
  float _1027;
  float _1028;
  float _1029;
  float _1030;
  float _1031;
  float _1032;
  float _1033;
  float _1047;
  float _1048;
  float _1049;
  float _1050;
  float _1051;
  float _1052;
  float _1053;
  float _1054;
  float _1055;
  float _1056;
  float _1057;
  float _1058;
  float _1059;
  float _1060;
  float _1065;
  float _1066;
  float _1067;
  float _1068;
  float _1069;
  float _1070;
  float _1071;
  float _1072;
  float _1073;
  float _1074;
  float _1075;
  float _1076;
  float _1077;
  float _1078;
  float _1127;
  float _1128;
  float _1129;
  float _1149;
  float _1150;
  float _1151;
  float _1162;
  float _1163;
  float _1164;
  float _1165;
  float _1166;
  float _1167;
  float _1170;
  float _1171;
  float _1172;
  float _1173;
  float _1174;
  float _1175;
  float _1176;
  float _1190;
  float _1191;
  float _1192;
  float _1193;
  float _1194;
  float _1195;
  float _1224;
  float _1225;
  float _1226;
  float _1246;
  float _1247;
  float _1248;
  float _1259;
  float _1260;
  float _1261;
  float _1262;
  float _1263;
  float _1264;
  float _1283;
  float _1284;
  float _1285;
  float _1286;
  float _1287;
  float _1288;
  float _1307;
  float _1308;
  float _1309;
  int _1356;
  float _1357;
  float _1475;
  float _1480;
  float _1504;
  float _1505;
  float _1506;
  float _1526;
  float _1572;
  float _1573;
  float _1574;
  float _1575;
  float _1633;
  float _1643;
  float _1696;
  float _1697;
  float _1698;
  float _1751;
  float _1752;
  float _1753;
  float _1864;
  float _1869;
  float _1870;
  float _1871;
  float _1872;
  float _1873;
  float _1874;
  int _1875;
  float _2559;
  float _2560;
  float _2561;
  float _2562;
  float _2653;
  float _2662;
  float _2671;
  float _2679;
  float _2750;
  float _2759;
  float _2768;
  float _2776;
  float _2849;
  float _2858;
  float _2867;
  float _2875;
  float _2948;
  float _2957;
  float _2966;
  float _2974;
  float _3026;
  float _3031;
  float _3032;
  float _3033;
  float _3130;
  float _3135;
  float _3136;
  float _3137;
  float _3138;
  float _3159;
  float _3160;
  float _3161;
  int _3181;
  float _3198;
  float _3202;
  float _3219;
  float _3220;
  float _3221;
  float _3222;
  float _3264;
  float _3265;
  float _3297;
  float _3322;
  float _3323;
  float _3324;
  float _3428;
  float _3429;
  float _3443;
  float _3455;
  float _3704;
  float _3912;
  float _3924;
  float _3935;
  float _3947;
  float _4080;
  float _4102;
  float _4116;
  float _4129;
  float _4143;
  float _4156;
  float _4367;
  float _4368;
  float _4500;
  float _4501;
  float _4510;
  float _4522;
  float _4551;
  bool _4552;
  float _4570;
  float _4571;
  float _4572;
  float _4573;
  float _4574;
  float _4575;
  float _4601;
  float _4602;
  float _4603;
  float _4636;
  int _4721;
  float _4772;
  float _4773;
  float _4774;
  float _4775;
  float _4776;
  float _4777;
  int _4778;
  bool _4805;
  bool _4807;
  float _4830;
  float _4831;
  float _4832;
  float _4878;
  float _4879;
  float _4880;
  float _4909;
  float _4934;
  float _4935;
  float _4936;
  float _5040;
  float _5041;
  float _5055;
  float _5067;
  float _5516;
  float _5528;
  float _5539;
  float _5551;
  float _5684;
  float _5706;
  float _5720;
  float _5733;
  float _5747;
  float _5760;
  float _5971;
  float _5972;
  float _6104;
  float _6105;
  float _6114;
  float _6126;
  float _6155;
  bool _6156;
  float _6174;
  float _6175;
  float _6176;
  float _6177;
  float _6178;
  float _6179;
  float _6202;
  float _6203;
  float _6204;
  float _6235;
  float _6264;
  float _6265;
  float _6266;
  float _6282;
  float _6283;
  float _6284;
  float _6297;
  float _6298;
  float _6299;
  float _6319;
  float _6482;
  float _6483;
  float _6484;
  float _6485;
  float _6486;
  float _6487;
  float _6488;
  float _6489;
  float _6587;
  float _6588;
  float _6589;
  float _6590;
  float _6591;
  float _6695;
  float _6704;
  float _6713;
  float _6721;
  float _6792;
  float _6801;
  float _6810;
  float _6818;
  float _6891;
  float _6900;
  float _6909;
  float _6917;
  float _6990;
  float _6999;
  float _7008;
  float _7016;
  float _7406;
  float _7407;
  float _7408;
  int _7409;
  float _7410;
  float _7439;
  float _7440;
  float _7441;
  float _7442;
  float _7443;
  float _7546;
  float _7555;
  float _7564;
  float _7572;
  float _7643;
  float _7652;
  float _7661;
  float _7669;
  float _7742;
  float _7751;
  float _7760;
  float _7768;
  float _7841;
  float _7850;
  float _7859;
  float _7867;
  float _8202;
  float _8203;
  bool _8204;
  float _8222;
  float _8223;
  float _8224;
  float _8225;
  float _8284;
  float _8285;
  float _8310;
  float _8311;
  float _8406;
  float _8412;
  float _8413;
  float _8414;
  float _8415;
  float _8416;
  float _8417;
  float _8437;
  float _8438;
  float _8439;
  int _8458;
  float _8475;
  float _8479;
  float _8495;
  float _8496;
  float _8497;
  float _8520;
  float _8521;
  float _8522;
  float _8553;
  float _8582;
  float _8583;
  float _8584;
  float _8600;
  float _8601;
  float _8602;
  float _8603;
  float _8604;
  float _8605;
  float _8606;
  float _8648;
  float _8649;
  float _8698;
  float _8699;
  float _8700;
  float _8716;
  float _8776;
  float _8777;
  float _8778;
  float _8814;
  float _8815;
  float _8816;
  float _8920;
  float _8921;
  float _8936;
  float _8948;
  float _8949;
  float _8969;
  float _9219;
  float _9428;
  float _9440;
  float _9441;
  float _9460;
  float _9471;
  float _9483;
  float _9484;
  float _9503;
  float _9636;
  float _9658;
  float _9672;
  float _9685;
  float _9699;
  float _9712;
  float _9930;
  float _9931;
  float _10063;
  float _10064;
  float _10073;
  float _10085;
  float _10086;
  float _10105;
  float _10135;
  bool _10136;
  float _10154;
  float _10155;
  float _10156;
  float _10157;
  float _10158;
  float _10159;
  float _10186;
  float _10187;
  float _10188;
  float _10339;
  float _10340;
  float _10367;
  float _10368;
  float _10369;
  float _10953;
  float _10975;
  float _10989;
  float _11002;
  float _11016;
  float _11029;
  float _11240;
  float _11241;
  float _11301;
  bool _11302;
  float _11320;
  float _11321;
  float _11322;
  float _11323;
  float _11324;
  float _11325;
  float _11899;
  float _11900;
  float _11901;
  float _11902;
  float _11993;
  float _12002;
  float _12011;
  float _12019;
  float _12090;
  float _12099;
  float _12108;
  float _12116;
  float _12189;
  float _12198;
  float _12207;
  float _12215;
  float _12288;
  float _12297;
  float _12306;
  float _12314;
  float _12366;
  float _12371;
  float _12372;
  float _12373;
  float _12470;
  float _12475;
  float _12476;
  float _12477;
  float _12478;
  float _12499;
  float _12500;
  float _12501;
  int _12521;
  float _12538;
  float _12546;
  float _12562;
  float _12563;
  float _12564;
  float _12587;
  float _12588;
  float _12589;
  float _12620;
  float _12649;
  float _12650;
  float _12651;
  float _12667;
  float _12668;
  float _12669;
  float _12670;
  float _12671;
  float _12672;
  float _12673;
  float _12715;
  float _12716;
  float _12764;
  float _12765;
  float _12766;
  float _12782;
  float _12842;
  float _12843;
  float _12844;
  float _12880;
  float _12881;
  float _12882;
  float _12986;
  float _12987;
  float _13002;
  float _13014;
  float _13015;
  float _13035;
  float _13285;
  float _13494;
  float _13506;
  float _13507;
  float _13526;
  float _13537;
  float _13549;
  float _13550;
  float _13569;
  float _13702;
  float _13724;
  float _13738;
  float _13751;
  float _13765;
  float _13778;
  float _13996;
  float _13997;
  float _14129;
  float _14130;
  float _14139;
  float _14151;
  float _14152;
  float _14171;
  float _14201;
  bool _14202;
  float _14220;
  float _14221;
  float _14222;
  float _14223;
  float _14224;
  float _14225;
  float _14252;
  float _14253;
  float _14254;
  float _14410;
  float _14411;
  float _14435;
  float _14436;
  float _14461;
  float _14462;
  float _14487;
  float _14488;
  float _14631;
  float _14632;
  float _14633;
  float _14657;
  float _14752;
  float _14753;
  float _14754;
  float _14768;
  float _14769;
  float _14770;
  float _14771;
  float _14772;
  float _14773;
  float _14778;
  float _14779;
  float _14780;
  float _14781;
  float _14782;
  float _14783;
  float _14944;
  float _14945;
  float _14946;
  float _14955;
  float _14956;
  float _14957;
  float _14976;
  float _14977;
  float _14978;
  float _14979;
  float _14980;
  float _14981;
  float _14982;
  float _14983;
  float _14984;
  int _92;
  uint _98;
  int _105;
  int _110;
  int _113;
  int _115;
  int _117;
  int _119;
  float4 _124;
  float4 _134;
  float4 _138;
  float4 _144;
  float4 _150;
  float4 _156;
  float _162;
  float _163;
  float _164;
  float _166;
  float _167;
  float _168;
  float _169;
  float _171;
  float _172;
  float _179;
  float _180;
  float _184;
  float _186;
  float _187;
  float _192;
  float _193;
  float _195;
  float _196;
  float _197;
  float _198;
  int _202;
  uint _204;
  float _209;
  bool _212;
  bool _221;
  float _222;
  float _223;
  float _224;
  bool _237;
  bool _241;
  float _260;
  bool _263;
  float _271;
  float _274;
  uint _278;
  float _281;
  bool _317;
  bool _318;
  bool _319;
  bool _326;
  float4 _337;
  float _342;
  float _343;
  float _347;
  float _349;
  float _350;
  float _355;
  float _356;
  float _358;
  float _359;
  float _360;
  float _361;
  float _362;
  float _363;
  float _371;
  float _372;
  float _378;
  float _379;
  float _380;
  float _381;
  bool _383;
  int _384;
  int _390;
  uint _394;
  float _400;
  float4 _409;
  float _430;
  float _431;
  float _446;
  float _447;
  float _450;
  float _451;
  float _454;
  float _455;
  float4 _460;
  float _494;
  float _496;
  bool _497;
  float _499;
  float _501;
  bool _502;
  float4 _515;
  float _519;
  float _531;
  float _532;
  float _533;
  float _534;
  float _535;
  float _536;
  bool _539;
  bool _554;
  int _555;
  float2 _558;
  float _563;
  float _564;
  float _568;
  float _570;
  float _571;
  float _576;
  float _577;
  float _579;
  float _580;
  float _581;
  float _582;
  float _584;
  float _593;
  float _597;
  float _598;
  float _600;
  float _601;
  float _602;
  int _610;
  int _611;
  int _612;
  int _613;
  float _617;
  float _619;
  float _620;
  float _630;
  float _631;
  float _632;
  float _633;
  float _635;
  float _636;
  float _637;
  float _638;
  float _639;
  float _640;
  float _641;
  float _644;
  float _653;
  float _660;
  float _661;
  float _662;
  float _664;
  float _674;
  float _675;
  float _676;
  float _678;
  float _689;
  float _690;
  float _693;
  float _700;
  float _701;
  float _702;
  float _706;
  float _721;
  float _724;
  float _727;
  float _730;
  float _733;
  float _736;
  int _772;
  int _773;
  float _776;
  float _777;
  float _778;
  float _779;
  float _782;
  float _783;
  float _784;
  float _785;
  float _788;
  float _789;
  float _790;
  float _791;
  float _794;
  float _795;
  float _796;
  float _797;
  float _800;
  float _801;
  float _802;
  float _803;
  float _806;
  float _807;
  float _808;
  float _809;
  int _812;
  float _815;
  float _816;
  float _817;
  float _820;
  float _821;
  float _822;
  int _825;
  int _828;
  int _831;
  float _860;
  float _863;
  float _866;
  float _867;
  float4 _873;
  float4 _879;
  float _888;
  float _892;
  float _895;
  float _898;
  float _939;
  float _944;
  float _946;
  float _948;
  float _955;
  float _956;
  float4 _962;
  float4 _968;
  float _976;
  float4 _982;
  float4 _988;
  float _1005;
  float _1006;
  float _1007;
  float _1008;
  float _1009;
  float _1010;
  float _1011;
  float _1012;
  float _1013;
  uint _1061;
  bool _1084;
  int _1094;
  float _1096;
  float _1097;
  float _1104;
  float _1109;
  float _1110;
  bool _1111;
  float4 _1116;
  float4 _1122;
  float _1133;
  float4 _1138;
  float4 _1144;
  float _1182;
  int _1202;
  float _1203;
  float _1206;
  float _1207;
  bool _1208;
  float4 _1213;
  float4 _1219;
  float _1230;
  float4 _1235;
  float4 _1241;
  float _1269;
  float _1322;
  float4 _1325;
  float _1328;
  float _1329;
  float _1333;
  float _1337;
  float _1338;
  float _1339;
  float _1347;
  float _1349;
  float _1351;
  float _1352;
  uint _1358;
  int _1361;
  int _1362;
  int _1366;
  int _1370;
  float _1382;
  float _1387;
  float _1388;
  float _1389;
  float _1390;
  float _1393;
  float _1394;
  float _1395;
  float _1396;
  float _1399;
  float _1400;
  float _1401;
  float _1402;
  int _1405;
  int _1408;
  int _1411;
  int _1414;
  float _1429;
  float _1433;
  float _1437;
  float _1462;
  float _1463;
  float _1464;
  float _1467;
  uint _1476;
  float _1481;
  float _1498;
  float _1507;
  float _1508;
  float _1509;
  float _1510;
  bool _1514;
  float _1530;
  float _1564;
  float _1565;
  float _1566;
  float _1567;
  float _1579;
  float _1581;
  float _1582;
  float _1583;
  float _1584;
  float _1589;
  float _1590;
  float _1591;
  float _1592;
  float _1594;
  float _1603;
  float _1604;
  float _1609;
  float _1615;
  float _1623;
  float _1634;
  float _1635;
  float _1636;
  int _1646;
  int _1649;
  int _1650;
  int _1651;
  int _1657;
  int _1658;
  int _1659;
  int _1665;
  int _1666;
  int _1667;
  float _1673;
  float _1677;
  float _1681;
  float _1688;
  int _1701;
  int _1704;
  int _1705;
  int _1706;
  int _1712;
  int _1713;
  int _1714;
  int _1720;
  int _1721;
  int _1722;
  float _1728;
  float _1732;
  float _1736;
  float _1743;
  float _1777;
  float _1781;
  float _1785;
  float _1804;
  float _1808;
  float _1812;
  float _1825;
  float _1826;
  float _1827;
  uint _1865;
  int _1877;
  int _1881;
  int _1882;
  int _1883;
  int _1884;
  int _1896;
  int _1900;
  float _1912;
  int _1915;
  float _1932;
  float _1937;
  float _1938;
  float _1939;
  float _1940;
  float _1943;
  float _1944;
  float _1945;
  float _1946;
  float _1949;
  float _1950;
  float _1951;
  float _1952;
  int _1955;
  int _1958;
  int _1961;
  int _1964;
  int _1967;
  float _1969;
  float _1970;
  float _1972;
  float _1976;
  float _1989;
  float _1993;
  float _1997;
  float _2022;
  float _2023;
  float _2024;
  float _2027;
  float _2028;
  float _2035;
  float _2056;
  float _2057;
  float _2058;
  float _2059;
  float _2062;
  float _2063;
  float _2064;
  float _2065;
  float _2068;
  float _2069;
  float _2070;
  float _2071;
  float _2074;
  float _2075;
  float _2076;
  float _2079;
  int _2082;
  int _2085;
  int _2088;
  int _2091;
  int _2094;
  float _2097;
  float _2098;
  float _2099;
  float _2100;
  int _2103;
  int _2106;
  int _2109;
  int _2112;
  int _2115;
  int _2118;
  int _2121;
  int _2124;
  int _2127;
  float _2129;
  float _2130;
  float _2132;
  float _2136;
  float _2139;
  float _2141;
  int _2144;
  bool _2152;
  float _2163;
  float _2164;
  float _2165;
  float _2166;
  bool _2187;
  float _2188;
  float _2191;
  float _2195;
  float _2196;
  float _2197;
  float _2201;
  float _2205;
  float _2209;
  float _2210;
  float _2233;
  float _2234;
  float _2235;
  float _2238;
  float _2239;
  float _2243;
  float _2244;
  float _2245;
  float _2250;
  float _2252;
  float _2253;
  float _2256;
  float _2257;
  float _2261;
  float _2270;
  float _2271;
  float _2272;
  int _2273;
  float _2278;
  float _2287;
  float _2288;
  float _2290;
  float4 _2295;
  float _2300;
  float _2302;
  float _2304;
  float _2306;
  float _2310;
  float _2312;
  float _2316;
  float _2318;
  int _2325;
  float _2330;
  float _2339;
  float _2340;
  float4 _2346;
  float _2351;
  float _2353;
  float _2357;
  float _2359;
  float _2363;
  float _2365;
  float _2369;
  float _2371;
  int _2378;
  float _2383;
  float _2392;
  float _2393;
  float4 _2399;
  float _2404;
  float _2406;
  float _2410;
  float _2412;
  float _2416;
  float _2418;
  float _2422;
  float _2424;
  int _2431;
  float _2436;
  float _2445;
  float _2446;
  float4 _2452;
  float _2457;
  float _2459;
  float _2463;
  float _2465;
  float _2469;
  float _2471;
  float _2475;
  float _2477;
  float _2478;
  float _2489;
  float _2495;
  float _2497;
  float _2499;
  float _2506;
  float _2511;
  float _2512;
  float _2513;
  float _2514;
  float4 _2516;
  float _2524;
  float _2525;
  float4 _2526;
  float _2531;
  float _2536;
  float4 _2537;
  float _2542;
  float4 _2547;
  float _2556;
  float _2565;
  float _2566;
  float _2573;
  float _2576;
  float _2580;
  float _2589;
  float _2590;
  float _2591;
  float _2596;
  int _2597;
  float _2602;
  float _2611;
  float _2612;
  float _2614;
  float _2616;
  float _2617;
  float4 _2619;
  float _2623;
  float _2624;
  float _2627;
  float _2628;
  float _2633;
  float _2634;
  float _2637;
  float _2638;
  float _2640;
  float _2642;
  bool _2643;
  bool _2644;
  bool _2654;
  bool _2663;
  float _2680;
  float _2682;
  float _2684;
  float _2686;
  float _2690;
  float _2692;
  float _2696;
  float _2698;
  int _2705;
  float _2710;
  float _2719;
  float _2720;
  float _2723;
  float _2724;
  float4 _2726;
  float _2730;
  float _2731;
  float _2734;
  float _2735;
  float _2737;
  float _2739;
  bool _2740;
  bool _2741;
  bool _2751;
  bool _2760;
  float _2777;
  float _2779;
  float _2783;
  float _2785;
  float _2789;
  float _2791;
  float _2795;
  float _2797;
  int _2804;
  float _2809;
  float _2818;
  float _2819;
  float _2822;
  float _2823;
  float4 _2825;
  float _2829;
  float _2830;
  float _2833;
  float _2834;
  float _2836;
  float _2838;
  bool _2839;
  bool _2840;
  bool _2850;
  bool _2859;
  float _2876;
  float _2878;
  float _2882;
  float _2884;
  float _2888;
  float _2890;
  float _2894;
  float _2896;
  int _2903;
  float _2908;
  float _2917;
  float _2918;
  float _2921;
  float _2922;
  float4 _2924;
  float _2928;
  float _2929;
  float _2932;
  float _2933;
  float _2935;
  float _2937;
  bool _2938;
  bool _2939;
  bool _2949;
  bool _2958;
  float _2975;
  float _2977;
  float _2981;
  float _2983;
  float _2987;
  float _2989;
  float _2993;
  float _2995;
  float _2996;
  float _3007;
  float _3013;
  float _3015;
  float _3017;
  float _3039;
  float4 _3046;
  float _3060;
  float _3061;
  float _3062;
  float _3063;
  float _3065;
  float _3070;
  float _3073;
  float _3074;
  float _3076;
  float _3077;
  float _3082;
  float _3087;
  float _3089;
  float _3092;
  float _3093;
  float _3098;
  float _3100;
  float _3102;
  float _3104;
  float _3109;
  float _3115;
  float _3117;
  float3 _3151;
  float _3162;
  float4 _3184;
  float _3214;
  float _3223;
  int _3230;
  int _3235;
  int _3237;
  int _3238;
  int _3240;
  int _3241;
  int _3250;
  int _3253;
  float _3258;
  bool _3269;
  float _3272;
  float _3274;
  float _3275;
  float _3276;
  float _3277;
  float _3278;
  float _3279;
  float _3287;
  float _3292;
  float _3298;
  float _3299;
  float _3302;
  float _3304;
  float _3306;
  float _3313;
  float _3314;
  float _3315;
  float _3317;
  float _3325;
  float _3326;
  float _3327;
  float _3330;
  float _3333;
  float _3336;
  bool _3337;
  float _3341;
  float _3343;
  float _3344;
  float _3352;
  float _3355;
  float _3356;
  float _3361;
  float _3370;
  float _3371;
  float _3374;
  float _3376;
  float _3377;
  float _3378;
  float _3380;
  float _3381;
  float _3382;
  float _3383;
  float _3388;
  float _3402;
  float _3407;
  float _3408;
  float _3410;
  float _3416;
  float _3419;
  float _3430;
  float _3431;
  float _3432;
  float _3433;
  bool _3434;
  float _3444;
  float _3459;
  float _3462;
  float _3463;
  float _3464;
  float _3465;
  float _3466;
  float _3467;
  float _3468;
  float _3470;
  float _3474;
  float _3475;
  float _3476;
  float _3477;
  float _3479;
  float _3480;
  float _3488;
  float _3498;
  float _3499;
  float _3500;
  float _3517;
  float _3526;
  float _3531;
  float _3538;
  float _3539;
  float _3540;
  float _3541;
  float _3560;
  float _3561;
  float _3562;
  float _3563;
  float _3564;
  float _3565;
  float _3567;
  float _3581;
  float _3582;
  float _3583;
  float _3584;
  bool _3587;
  float _3588;
  float _3589;
  float _3590;
  float _3592;
  float _3595;
  float _3597;
  float _3598;
  float _3599;
  float _3600;
  float _3603;
  float _3606;
  float _3609;
  float _3611;
  float _3623;
  float _3624;
  float _3626;
  float _3627;
  float _3628;
  float _3635;
  float _3636;
  float _3637;
  float _3640;
  float _3643;
  float _3644;
  float _3649;
  float _3653;
  float _3658;
  float _3665;
  float _3669;
  float _3670;
  float _3671;
  float _3675;
  float _3676;
  float _3677;
  float _3684;
  float _3688;
  float _3692;
  float _3693;
  float _3697;
  float _3707;
  float _3717;
  float _3719;
  float _3732;
  float _3733;
  float _3739;
  float _3742;
  float _3751;
  float _3753;
  float _3762;
  float _3767;
  float _3773;
  float _3774;
  float _3778;
  float _3779;
  float _3784;
  float _3803;
  float _3806;
  float _3809;
  float _3823;
  float _3833;
  float _3834;
  float _3838;
  float _3840;
  float _3842;
  float _3845;
  float _3858;
  float _3876;
  float _3877;
  float _3880;
  float _3883;
  float _3886;
  float _3887;
  float _3891;
  float _3892;
  float _3893;
  float _3902;
  float _3903;
  float _3925;
  float _3926;
  float _3951;
  float _3954;
  float _3958;
  float _3965;
  float _3969;
  int4 _3974;
  float _3981;
  float _3984;
  float _3988;
  float _3992;
  float _4001;
  float _4004;
  float _4008;
  float _4012;
  float _4020;
  float _4026;
  float _4036;
  float _4039;
  float _4043;
  float _4047;
  float _4054;
  float _4068;
  bool _4069;
  float _4091;
  bool _4092;
  float _4168;
  float _4172;
  float _4177;
  float _4179;
  float _4182;
  float _4185;
  float _4187;
  float _4194;
  float _4213;
  float _4227;
  float _4229;
  float _4253;
  float _4254;
  float _4255;
  float _4256;
  bool _4259;
  float _4260;
  float _4261;
  float _4262;
  float _4264;
  float _4267;
  float _4269;
  float _4270;
  float _4271;
  float _4272;
  float _4275;
  float _4278;
  float _4281;
  float _4283;
  float _4287;
  float _4296;
  float _4297;
  float _4299;
  float _4300;
  float _4301;
  float _4308;
  float _4309;
  float _4310;
  float _4313;
  float _4316;
  float _4319;
  float _4320;
  float _4321;
  float _4324;
  float _4325;
  float _4331;
  float _4335;
  float _4336;
  float _4337;
  float _4338;
  float _4339;
  float _4340;
  float _4345;
  float _4346;
  float _4354;
  float _4355;
  float _4370;
  float _4388;
  float _4403;
  float _4404;
  float _4410;
  bool _4411;
  float _4415;
  float _4417;
  float _4418;
  float _4424;
  float _4427;
  float _4428;
  float _4433;
  float _4442;
  float _4443;
  float _4446;
  float _4448;
  float _4449;
  float _4450;
  float _4452;
  float _4453;
  float _4454;
  float _4455;
  float _4460;
  float _4474;
  float _4479;
  float _4480;
  float _4482;
  float _4488;
  float _4491;
  float _4511;
  float _4526;
  float _4536;
  float _4556;
  float _4558;
  float _4562;
  float _4563;
  float _4564;
  float _4576;
  float _4577;
  float _4578;
  float _4585;
  float _4586;
  float _4587;
  float _4590;
  float _4607;
  float _4608;
  float _4609;
  float _4616;
  float _4619;
  float _4624;
  float _4625;
  float _4639;
  float _4640;
  float _4641;
  float _4642;
  float _4645;
  float _4646;
  float _4647;
  float _4648;
  float _4651;
  float _4652;
  float _4653;
  float _4654;
  float _4657;
  float _4658;
  float _4659;
  int _4662;
  int _4665;
  int _4668;
  int _4671;
  int _4674;
  int _4677;
  float _4681;
  float _4684;
  float _4686;
  int _4688;
  float _4702;
  float _4706;
  float2 _4712;
  int _4717;
  int _4724;
  int _4736;
  float _4739;
  float _4740;
  float _4741;
  float _4744;
  float _4745;
  float _4746;
  float _4749;
  float _4750;
  float _4751;
  float _4752;
  float _4753;
  float _4754;
  int _4757;
  float _4759;
  float _4760;
  float _4761;
  float _4762;
  float _4763;
  float _4764;
  int _4767;
  uint _4802;
  float3 _4822;
  float _4843;
  float _4861;
  float _4864;
  float _4870;
  float _4883;
  float _4886;
  float _4887;
  float _4888;
  float _4889;
  float _4890;
  float _4891;
  float _4899;
  float _4904;
  float _4910;
  float _4911;
  float _4914;
  float _4916;
  float _4918;
  float _4925;
  float _4926;
  float _4927;
  float _4929;
  float _4937;
  float _4938;
  float _4939;
  float _4942;
  float _4945;
  float _4948;
  bool _4949;
  float _4953;
  float _4955;
  float _4956;
  float _4964;
  float _4967;
  float _4968;
  float _4973;
  float _4982;
  float _4983;
  float _4986;
  float _4988;
  float _4989;
  float _4990;
  float _4992;
  float _4993;
  float _4994;
  float _4995;
  float _5000;
  float _5014;
  float _5019;
  float _5020;
  float _5022;
  float _5028;
  float _5031;
  float _5042;
  float _5043;
  float _5044;
  float _5045;
  bool _5046;
  float _5056;
  float _5071;
  float _5074;
  float _5075;
  float _5076;
  float _5077;
  float _5078;
  float _5079;
  float _5080;
  float _5082;
  float _5086;
  float _5087;
  float _5088;
  float _5089;
  float _5091;
  float _5092;
  float _5100;
  float _5110;
  float _5111;
  float _5112;
  float _5129;
  float _5138;
  float _5143;
  float _5150;
  float _5151;
  float _5152;
  float _5153;
  float _5172;
  float _5173;
  float _5174;
  float _5175;
  float _5176;
  float _5177;
  float _5179;
  float _5193;
  float _5194;
  float _5195;
  float _5196;
  bool _5199;
  float _5200;
  float _5201;
  float _5202;
  float _5204;
  float _5207;
  float _5209;
  float _5210;
  float _5211;
  float _5212;
  float _5215;
  float _5218;
  float _5221;
  float _5223;
  float _5235;
  float _5236;
  float _5238;
  float _5239;
  float _5240;
  float _5247;
  float _5248;
  float _5249;
  float _5252;
  float _5255;
  float _5256;
  float _5261;
  float _5265;
  float _5270;
  float _5277;
  float _5281;
  float _5282;
  float _5283;
  float _5287;
  float _5288;
  float _5289;
  float _5296;
  float _5300;
  float _5304;
  float _5305;
  float _5308;
  float _5311;
  float _5321;
  float _5323;
  float _5336;
  float _5337;
  float _5343;
  float _5346;
  float _5355;
  float _5357;
  float _5366;
  float _5371;
  float _5377;
  float _5378;
  float _5382;
  float _5383;
  float _5388;
  float _5407;
  float _5410;
  float _5413;
  float _5427;
  float _5437;
  float _5438;
  float _5442;
  float _5444;
  float _5446;
  float _5449;
  float _5462;
  float _5480;
  float _5481;
  float _5484;
  float _5487;
  float _5490;
  float _5491;
  float _5495;
  float _5496;
  float _5497;
  float _5506;
  float _5507;
  float _5529;
  float _5530;
  float _5555;
  float _5558;
  float _5562;
  float _5569;
  float _5573;
  int4 _5578;
  float _5585;
  float _5588;
  float _5592;
  float _5596;
  float _5605;
  float _5608;
  float _5612;
  float _5616;
  float _5624;
  float _5630;
  float _5640;
  float _5643;
  float _5647;
  float _5651;
  float _5658;
  float _5672;
  bool _5673;
  float _5695;
  bool _5696;
  float _5772;
  float _5776;
  float _5781;
  float _5783;
  float _5786;
  float _5789;
  float _5791;
  float _5798;
  float _5817;
  float _5831;
  float _5833;
  float _5857;
  float _5858;
  float _5859;
  float _5860;
  bool _5863;
  float _5864;
  float _5865;
  float _5866;
  float _5868;
  float _5871;
  float _5873;
  float _5874;
  float _5875;
  float _5876;
  float _5879;
  float _5882;
  float _5885;
  float _5887;
  float _5891;
  float _5900;
  float _5901;
  float _5903;
  float _5904;
  float _5905;
  float _5912;
  float _5913;
  float _5914;
  float _5917;
  float _5920;
  float _5923;
  float _5924;
  float _5925;
  float _5928;
  float _5929;
  float _5935;
  float _5939;
  float _5940;
  float _5941;
  float _5942;
  float _5943;
  float _5944;
  float _5949;
  float _5950;
  float _5958;
  float _5959;
  float _5974;
  float _5992;
  float _6007;
  float _6008;
  float _6014;
  bool _6015;
  float _6019;
  float _6021;
  float _6022;
  float _6028;
  float _6031;
  float _6032;
  float _6037;
  float _6046;
  float _6047;
  float _6050;
  float _6052;
  float _6053;
  float _6054;
  float _6056;
  float _6057;
  float _6058;
  float _6059;
  float _6064;
  float _6078;
  float _6083;
  float _6084;
  float _6086;
  float _6092;
  float _6095;
  float _6115;
  float _6130;
  float _6140;
  float _6160;
  float _6162;
  float _6166;
  float _6167;
  float _6168;
  float _6192;
  bool _6205;
  float _6206;
  float _6207;
  float _6208;
  bool _6209;
  float _6211;
  float _6212;
  float _6216;
  float _6222;
  float _6236;
  float _6237;
  float _6240;
  float _6244;
  int _6245;
  float _6247;
  float _6249;
  float _6252;
  float _6256;
  float _6267;
  float _6268;
  float _6269;
  float _6271;
  float _6285;
  float _6286;
  float _6287;
  float _6303;
  float _6304;
  float _6305;
  float _6322;
  float _6337;
  float _6338;
  float _6339;
  float _6342;
  float _6343;
  float _6344;
  float _6347;
  float _6348;
  float _6349;
  float _6352;
  float _6353;
  float _6354;
  float _6357;
  float _6358;
  float _6359;
  int _6362;
  int _6365;
  int _6368;
  int _6371;
  int _6374;
  int _6377;
  int _6380;
  int _6383;
  int _6386;
  int _6389;
  int _6392;
  float _6395;
  float _6396;
  float _6397;
  float _6398;
  int _6401;
  int _6404;
  int _6407;
  int _6410;
  int _6413;
  float _6415;
  float _6416;
  float _6418;
  float _6422;
  float _6425;
  float _6426;
  float _6428;
  float _6432;
  float _6434;
  float _6435;
  float _6437;
  float _6438;
  int _6440;
  bool _6444;
  float _6452;
  float _6453;
  float _6455;
  float _6458;
  float _6459;
  float _6461;
  float _6462;
  float _6464;
  float _6465;
  float _6467;
  float _6468;
  float _6472;
  float _6478;
  float _6479;
  float _6480;
  bool _6498;
  float _6499;
  float _6500;
  float _6501;
  float _6502;
  float _6503;
  float _6504;
  float _6505;
  float _6506;
  float _6507;
  float _6510;
  float _6511;
  float _6512;
  float _6515;
  float _6522;
  float _6532;
  float _6535;
  float _6539;
  float _6543;
  float _6544;
  float _6545;
  float _6548;
  float _6551;
  bool _6553;
  float _6559;
  float _6560;
  float _6561;
  float _6566;
  float _6567;
  float _6568;
  bool _6572;
  bool _6578;
  bool _6582;
  float _6592;
  float _6597;
  float _6606;
  float _6607;
  float _6608;
  float _6609;
  float _6614;
  float _6615;
  float _6618;
  float _6622;
  float _6631;
  float _6632;
  float _6633;
  float _6638;
  int _6639;
  float _6644;
  float _6653;
  float _6654;
  float _6656;
  float _6658;
  float _6659;
  float4 _6661;
  float _6665;
  float _6666;
  float _6669;
  float _6670;
  float _6675;
  float _6676;
  float _6679;
  float _6680;
  float _6682;
  float _6684;
  bool _6685;
  bool _6686;
  bool _6696;
  bool _6705;
  float _6722;
  float _6724;
  float _6726;
  float _6728;
  float _6732;
  float _6734;
  float _6738;
  float _6740;
  int _6747;
  float _6752;
  float _6761;
  float _6762;
  float _6765;
  float _6766;
  float4 _6768;
  float _6772;
  float _6773;
  float _6776;
  float _6777;
  float _6779;
  float _6781;
  bool _6782;
  bool _6783;
  bool _6793;
  bool _6802;
  float _6819;
  float _6821;
  float _6825;
  float _6827;
  float _6831;
  float _6833;
  float _6837;
  float _6839;
  int _6846;
  float _6851;
  float _6860;
  float _6861;
  float _6864;
  float _6865;
  float4 _6867;
  float _6871;
  float _6872;
  float _6875;
  float _6876;
  float _6878;
  float _6880;
  bool _6881;
  bool _6882;
  bool _6892;
  bool _6901;
  float _6918;
  float _6920;
  float _6924;
  float _6926;
  float _6930;
  float _6932;
  float _6936;
  float _6938;
  int _6945;
  float _6950;
  float _6959;
  float _6960;
  float _6963;
  float _6964;
  float4 _6966;
  float _6970;
  float _6971;
  float _6974;
  float _6975;
  float _6977;
  float _6979;
  bool _6980;
  bool _6981;
  bool _6991;
  bool _7000;
  float _7017;
  float _7019;
  float _7023;
  float _7025;
  float _7029;
  float _7031;
  float _7035;
  float _7037;
  float _7038;
  float _7049;
  float _7055;
  float _7057;
  float _7059;
  float _7071;
  float _7074;
  float _7075;
  float _7078;
  float _7089;
  float _7090;
  float _7091;
  float _7092;
  float _7096;
  float _7105;
  float _7106;
  float _7107;
  int _7108;
  float _7113;
  float _7122;
  float _7123;
  float _7125;
  float4 _7130;
  float _7135;
  float _7137;
  float _7139;
  float _7141;
  float _7145;
  float _7147;
  float _7151;
  float _7153;
  int _7160;
  float _7165;
  float _7174;
  float _7175;
  float4 _7181;
  float _7186;
  float _7188;
  float _7192;
  float _7194;
  float _7198;
  float _7200;
  float _7204;
  float _7206;
  int _7213;
  float _7218;
  float _7227;
  float _7228;
  float4 _7234;
  float _7239;
  float _7241;
  float _7245;
  float _7247;
  float _7251;
  float _7253;
  float _7257;
  float _7259;
  int _7266;
  float _7271;
  float _7280;
  float _7281;
  float4 _7287;
  float _7292;
  float _7294;
  float _7298;
  float _7300;
  float _7304;
  float _7306;
  float _7310;
  float _7312;
  float _7313;
  float _7324;
  float _7330;
  float _7332;
  float _7334;
  float _7342;
  float _7349;
  float _7351;
  float _7358;
  float _7359;
  float _7360;
  float _7361;
  float4 _7363;
  float _7372;
  float4 _7373;
  float _7378;
  float _7384;
  float4 _7385;
  float _7390;
  float4 _7395;
  float _7418;
  float _7419;
  float _7420;
  bool _7424;
  bool _7430;
  bool _7434;
  float _7444;
  float _7449;
  float _7458;
  float _7459;
  float _7460;
  float _7465;
  float _7466;
  float _7469;
  float _7473;
  float _7482;
  float _7483;
  float _7484;
  float _7489;
  int _7490;
  float _7495;
  float _7504;
  float _7505;
  float _7507;
  float _7509;
  float _7510;
  float4 _7512;
  float _7516;
  float _7517;
  float _7520;
  float _7521;
  float _7526;
  float _7527;
  float _7530;
  float _7531;
  float _7533;
  float _7535;
  bool _7536;
  bool _7537;
  bool _7547;
  bool _7556;
  float _7573;
  float _7575;
  float _7577;
  float _7579;
  float _7583;
  float _7585;
  float _7589;
  float _7591;
  int _7598;
  float _7603;
  float _7612;
  float _7613;
  float _7616;
  float _7617;
  float4 _7619;
  float _7623;
  float _7624;
  float _7627;
  float _7628;
  float _7630;
  float _7632;
  bool _7633;
  bool _7634;
  bool _7644;
  bool _7653;
  float _7670;
  float _7672;
  float _7676;
  float _7678;
  float _7682;
  float _7684;
  float _7688;
  float _7690;
  int _7697;
  float _7702;
  float _7711;
  float _7712;
  float _7715;
  float _7716;
  float4 _7718;
  float _7722;
  float _7723;
  float _7726;
  float _7727;
  float _7729;
  float _7731;
  bool _7732;
  bool _7733;
  bool _7743;
  bool _7752;
  float _7769;
  float _7771;
  float _7775;
  float _7777;
  float _7781;
  float _7783;
  float _7787;
  float _7789;
  int _7796;
  float _7801;
  float _7810;
  float _7811;
  float _7814;
  float _7815;
  float4 _7817;
  float _7821;
  float _7822;
  float _7825;
  float _7826;
  float _7828;
  float _7830;
  bool _7831;
  bool _7832;
  bool _7842;
  bool _7851;
  float _7868;
  float _7870;
  float _7874;
  float _7876;
  float _7880;
  float _7882;
  float _7886;
  float _7888;
  float _7889;
  float _7900;
  float _7906;
  float _7908;
  float _7910;
  float _7919;
  float _7922;
  float _7923;
  float _7936;
  float _7937;
  float _7938;
  float _7939;
  float _7943;
  float _7952;
  float _7953;
  float _7954;
  int _7955;
  float _7960;
  float _7969;
  float _7970;
  float _7972;
  float4 _7977;
  float _7982;
  float _7984;
  float _7986;
  float _7988;
  float _7992;
  float _7994;
  float _7998;
  float _8000;
  int _8007;
  float _8012;
  float _8021;
  float _8022;
  float4 _8028;
  float _8033;
  float _8035;
  float _8039;
  float _8041;
  float _8045;
  float _8047;
  float _8051;
  float _8053;
  int _8060;
  float _8065;
  float _8074;
  float _8075;
  float4 _8081;
  float _8086;
  float _8088;
  float _8092;
  float _8094;
  float _8098;
  float _8100;
  float _8104;
  float _8106;
  int _8113;
  float _8118;
  float _8127;
  float _8128;
  float4 _8134;
  float _8139;
  float _8141;
  float _8145;
  float _8147;
  float _8151;
  float _8153;
  float _8157;
  float _8159;
  float _8160;
  float _8171;
  float _8177;
  float _8179;
  float _8181;
  float _8189;
  float _8196;
  float _8198;
  float _8228;
  float _8231;
  float _8232;
  float _8233;
  float _8248;
  float _8251;
  float _8254;
  float _8256;
  float _8257;
  float _8258;
  float _8259;
  float _8267;
  float _8268;
  float _8269;
  bool _8271;
  float _8291;
  float4 _8316;
  float _8336;
  float _8337;
  float _8338;
  float _8339;
  float _8341;
  float _8346;
  float _8349;
  float _8350;
  float _8352;
  float _8353;
  float _8358;
  float _8363;
  float _8365;
  float _8368;
  float _8369;
  float _8374;
  float _8376;
  float _8378;
  float _8380;
  float _8385;
  float _8391;
  float _8393;
  float3 _8429;
  float4 _8461;
  float _8490;
  float _8510;
  bool _8523;
  float _8524;
  float _8525;
  float _8526;
  bool _8527;
  float _8529;
  float _8530;
  float _8534;
  float _8540;
  float _8554;
  float _8555;
  float _8558;
  float _8562;
  int _8563;
  float _8565;
  float _8567;
  float _8570;
  float _8574;
  float _8585;
  float _8586;
  float _8587;
  float _8589;
  float _8607;
  int _8614;
  int _8619;
  int _8621;
  int _8622;
  int _8624;
  int _8625;
  int _8634;
  int _8637;
  float _8642;
  bool _8653;
  float _8656;
  float _8658;
  float _8659;
  float _8660;
  float _8661;
  float _8662;
  float _8663;
  float _8664;
  float _8665;
  float _8666;
  float _8667;
  float _8668;
  float _8669;
  float _8670;
  bool _8671;
  float _8672;
  float _8673;
  float _8676;
  float _8677;
  float _8679;
  float _8706;
  float _8711;
  float _8718;
  float _8719;
  float _8720;
  float _8722;
  float _8726;
  float _8727;
  float _8728;
  float _8729;
  float _8730;
  float _8731;
  float _8732;
  float _8738;
  float _8747;
  float _8751;
  float _8752;
  float _8753;
  float _8754;
  float _8758;
  float _8759;
  float _8760;
  float _8768;
  float _8780;
  float _8781;
  float _8782;
  float _8783;
  float _8784;
  float _8785;
  float _8788;
  float _8790;
  float _8792;
  float _8793;
  float _8794;
  float _8795;
  float _8798;
  float _8805;
  float _8806;
  float _8807;
  float _8809;
  float _8817;
  float _8818;
  float _8819;
  float _8822;
  float _8825;
  float _8828;
  bool _8829;
  float _8833;
  float _8835;
  float _8836;
  float _8844;
  float _8847;
  float _8848;
  float _8853;
  float _8862;
  float _8863;
  float _8866;
  float _8868;
  float _8869;
  float _8870;
  float _8872;
  float _8873;
  float _8874;
  float _8875;
  float _8880;
  float _8894;
  float _8899;
  float _8900;
  float _8902;
  float _8908;
  float _8911;
  float _8922;
  float _8923;
  float _8924;
  float _8925;
  float _8926;
  bool _8927;
  float _8945;
  bool _8950;
  float _8956;
  float _8973;
  float _8976;
  float _8977;
  float _8978;
  float _8979;
  float _8980;
  float _8981;
  float _8982;
  float _8984;
  float _8988;
  float _8989;
  float _8990;
  float _8991;
  float _8993;
  float _8994;
  float _8995;
  float _9003;
  float _9013;
  float _9014;
  float _9015;
  float _9032;
  float _9041;
  float _9046;
  float _9053;
  float _9054;
  float _9055;
  float _9056;
  float _9075;
  float _9076;
  float _9077;
  float _9078;
  float _9079;
  float _9080;
  float _9082;
  float _9096;
  float _9097;
  float _9098;
  float _9099;
  bool _9102;
  float _9103;
  float _9104;
  float _9105;
  float _9107;
  float _9110;
  float _9112;
  float _9113;
  float _9114;
  float _9115;
  float _9118;
  float _9121;
  float _9124;
  float _9126;
  float _9138;
  float _9139;
  float _9141;
  float _9142;
  float _9143;
  float _9150;
  float _9151;
  float _9152;
  float _9155;
  float _9158;
  float _9159;
  float _9164;
  float _9168;
  float _9173;
  float _9180;
  float _9184;
  float _9185;
  float _9186;
  float _9190;
  float _9191;
  float _9192;
  float _9199;
  float _9203;
  float _9207;
  float _9208;
  float _9212;
  float _9223;
  float _9233;
  float _9235;
  float _9248;
  float _9249;
  float _9255;
  float _9258;
  float _9267;
  float _9269;
  float _9278;
  float _9283;
  float _9289;
  float _9290;
  float _9294;
  float _9295;
  float _9300;
  float _9319;
  float _9322;
  float _9325;
  float _9339;
  float _9349;
  float _9350;
  float _9354;
  float _9356;
  float _9358;
  float _9361;
  float _9374;
  float _9392;
  float _9393;
  float _9396;
  float _9399;
  float _9402;
  float _9403;
  float _9407;
  float _9408;
  float _9409;
  float _9418;
  float _9419;
  float _9437;
  float _9447;
  float _9461;
  float _9462;
  float _9480;
  float _9490;
  float _9507;
  float _9510;
  float _9514;
  float _9521;
  float _9525;
  int4 _9530;
  float _9537;
  float _9540;
  float _9544;
  float _9548;
  float _9557;
  float _9560;
  float _9564;
  float _9568;
  float _9576;
  float _9582;
  float _9592;
  float _9595;
  float _9599;
  float _9603;
  float _9610;
  float _9624;
  bool _9625;
  float _9647;
  bool _9648;
  float _9724;
  float _9728;
  float _9733;
  float _9735;
  float _9738;
  float _9741;
  float _9743;
  float _9750;
  float _9769;
  float _9783;
  float _9785;
  float _9809;
  float _9810;
  float _9811;
  float _9812;
  bool _9815;
  float _9816;
  float _9817;
  float _9818;
  float _9820;
  float _9823;
  float _9825;
  float _9826;
  float _9827;
  float _9828;
  float _9831;
  float _9834;
  float _9837;
  float _9839;
  float _9843;
  float _9852;
  float _9853;
  float _9855;
  float _9856;
  float _9857;
  float _9864;
  float _9865;
  float _9866;
  float _9869;
  float _9872;
  float _9875;
  float _9879;
  float _9883;
  float _9884;
  float _9887;
  float _9888;
  float _9894;
  float _9898;
  float _9899;
  float _9900;
  float _9901;
  float _9902;
  float _9903;
  float _9908;
  float _9909;
  float _9917;
  float _9918;
  float _9933;
  float _9951;
  float _9966;
  float _9967;
  float _9973;
  bool _9974;
  float _9978;
  float _9980;
  float _9981;
  float _9987;
  float _9990;
  float _9991;
  float _9996;
  float _10005;
  float _10006;
  float _10009;
  float _10011;
  float _10012;
  float _10013;
  float _10015;
  float _10016;
  float _10017;
  float _10018;
  float _10023;
  float _10037;
  float _10042;
  float _10043;
  float _10045;
  float _10051;
  float _10054;
  float _10082;
  float _10092;
  float _10109;
  float _10119;
  float _10120;
  float _10140;
  float _10142;
  float _10146;
  float _10147;
  float _10148;
  float _10160;
  float _10161;
  float _10162;
  float _10169;
  float _10170;
  float _10171;
  float _10175;
  float _10192;
  float _10193;
  float _10194;
  float _10201;
  float _10204;
  float _10209;
  float _10210;
  float _10225;
  float _10226;
  float _10227;
  float _10230;
  float _10231;
  float _10232;
  float _10235;
  int _10238;
  int _10241;
  int _10244;
  float _10253;
  float _10256;
  float _10259;
  float _10266;
  float _10271;
  float _10273;
  float _10275;
  float _10276;
  float _10277;
  float _10279;
  float _10280;
  float _10281;
  float _10284;
  float _10285;
  float _10286;
  float _10289;
  float _10296;
  int _10305;
  int _10310;
  int _10312;
  int _10313;
  int _10315;
  int _10316;
  int _10325;
  int _10328;
  float _10333;
  bool _10344;
  float _10347;
  float _10349;
  float _10350;
  float _10358;
  float _10359;
  float _10360;
  float _10362;
  float _10370;
  float _10371;
  float _10372;
  float _10375;
  float _10378;
  float _10381;
  float _10382;
  float _10383;
  float _10384;
  float _10385;
  float _10389;
  float _10391;
  float _10392;
  float _10393;
  float _10394;
  float _10395;
  float _10396;
  float _10397;
  float _10399;
  float _10403;
  float _10404;
  float _10405;
  float _10408;
  float _10409;
  float _10410;
  float _10418;
  float _10428;
  float _10429;
  float _10430;
  float _10447;
  float _10456;
  float _10461;
  float _10468;
  float _10469;
  float _10470;
  float _10471;
  float _10490;
  float _10491;
  float _10492;
  float _10493;
  float _10494;
  float _10495;
  float _10497;
  float _10508;
  float _10509;
  float _10510;
  float _10511;
  bool _10514;
  float _10515;
  float _10516;
  float _10517;
  float _10519;
  float _10522;
  float _10524;
  float _10525;
  float _10526;
  float _10527;
  float _10530;
  float _10533;
  float _10536;
  float _10538;
  float _10550;
  float _10551;
  float _10553;
  float _10554;
  float _10555;
  float _10562;
  float _10563;
  float _10564;
  float _10567;
  float _10570;
  float _10571;
  float _10576;
  float _10580;
  float _10585;
  float _10592;
  float _10596;
  float _10597;
  float _10598;
  float _10602;
  float _10603;
  float _10604;
  float _10611;
  float _10615;
  float _10619;
  float _10620;
  float _10621;
  float _10624;
  float _10634;
  float _10636;
  float _10649;
  float _10650;
  float _10656;
  float _10659;
  float _10668;
  float _10670;
  float _10679;
  float _10684;
  float _10690;
  float _10691;
  float _10695;
  float _10696;
  float _10701;
  float _10720;
  float _10723;
  float _10726;
  float _10740;
  float _10750;
  float _10751;
  float _10755;
  float _10757;
  float _10759;
  float _10762;
  float _10775;
  float _10793;
  float _10794;
  float _10797;
  float _10800;
  float _10803;
  float _10804;
  float _10808;
  float _10809;
  float _10810;
  float _10819;
  float _10820;
  float _10821;
  float _10822;
  float _10826;
  float _10828;
  float _10832;
  float _10838;
  float _10842;
  int4 _10847;
  float _10854;
  float _10857;
  float _10861;
  float _10865;
  float _10874;
  float _10877;
  float _10881;
  float _10885;
  float _10893;
  float _10899;
  float _10909;
  float _10912;
  float _10916;
  float _10920;
  float _10927;
  float _10941;
  bool _10942;
  float _10964;
  bool _10965;
  float _11041;
  float _11045;
  float _11050;
  float _11052;
  float _11055;
  float _11058;
  float _11060;
  float _11067;
  float _11086;
  float _11100;
  float _11102;
  float _11126;
  float _11127;
  float _11128;
  float _11129;
  bool _11132;
  float _11133;
  float _11134;
  float _11135;
  float _11137;
  float _11140;
  float _11142;
  float _11143;
  float _11144;
  float _11145;
  float _11148;
  float _11151;
  float _11154;
  float _11156;
  float _11160;
  float _11169;
  float _11170;
  float _11172;
  float _11173;
  float _11174;
  float _11181;
  float _11182;
  float _11183;
  float _11186;
  float _11189;
  float _11192;
  float _11193;
  float _11194;
  float _11197;
  float _11198;
  float _11204;
  float _11208;
  float _11209;
  float _11210;
  float _11211;
  float _11212;
  float _11213;
  float _11218;
  float _11219;
  float _11227;
  float _11228;
  float _11243;
  float _11261;
  float _11276;
  float _11277;
  float _11281;
  float _11286;
  float _11287;
  float _11306;
  float _11308;
  float _11312;
  float _11313;
  float _11314;
  float _11326;
  float _11327;
  float _11328;
  float _11335;
  float _11336;
  float _11337;
  float _11341;
  float _11356;
  float _11357;
  float _11358;
  float _11361;
  float _11362;
  float _11363;
  float _11366;
  float _11367;
  float _11368;
  float _11371;
  float _11372;
  float _11373;
  float _11376;
  float _11377;
  float _11378;
  float _11381;
  float _11382;
  float _11383;
  int _11386;
  int _11389;
  int _11392;
  int _11395;
  float _11398;
  float _11399;
  float _11400;
  float _11401;
  int _11404;
  int _11407;
  int _11410;
  int _11413;
  int _11416;
  int _11419;
  int _11422;
  float _11425;
  float _11426;
  float _11427;
  float _11428;
  int _11431;
  int _11434;
  int _11437;
  int _11440;
  float _11442;
  float _11443;
  float _11445;
  float _11449;
  float _11452;
  float _11453;
  float _11455;
  float _11459;
  int _11464;
  bool _11472;
  float _11489;
  float _11490;
  float _11491;
  float _11492;
  bool _11498;
  float _11499;
  float _11500;
  float _11501;
  float _11502;
  float _11503;
  float _11504;
  float _11505;
  float _11506;
  float _11507;
  float _11510;
  float _11511;
  float _11512;
  float _11515;
  float _11526;
  float _11527;
  float _11530;
  float _11537;
  float _11538;
  float _11539;
  float _11551;
  float _11552;
  float _11553;
  float _11554;
  float _11557;
  float _11558;
  float _11561;
  float _11562;
  float _11569;
  float _11571;
  float _11577;
  float _11583;
  float _11584;
  float _11585;
  float _11590;
  float _11592;
  float _11593;
  float _11596;
  float _11597;
  float _11601;
  float _11610;
  float _11611;
  float _11612;
  int _11613;
  float _11618;
  float _11627;
  float _11628;
  float _11630;
  float4 _11635;
  float _11640;
  float _11642;
  float _11644;
  float _11646;
  float _11650;
  float _11652;
  float _11656;
  float _11658;
  int _11665;
  float _11670;
  float _11679;
  float _11680;
  float4 _11686;
  float _11691;
  float _11693;
  float _11697;
  float _11699;
  float _11703;
  float _11705;
  float _11709;
  float _11711;
  int _11718;
  float _11723;
  float _11732;
  float _11733;
  float4 _11739;
  float _11744;
  float _11746;
  float _11750;
  float _11752;
  float _11756;
  float _11758;
  float _11762;
  float _11764;
  int _11771;
  float _11776;
  float _11785;
  float _11786;
  float4 _11792;
  float _11797;
  float _11799;
  float _11803;
  float _11805;
  float _11809;
  float _11811;
  float _11815;
  float _11817;
  float _11818;
  float _11829;
  float _11835;
  float _11837;
  float _11839;
  float _11846;
  float _11851;
  float _11852;
  float _11853;
  float _11854;
  float4 _11856;
  float _11864;
  float _11865;
  float4 _11866;
  float _11871;
  float _11876;
  float4 _11877;
  float _11882;
  float4 _11887;
  float _11896;
  float _11905;
  float _11906;
  float _11913;
  float _11916;
  float _11920;
  float _11929;
  float _11930;
  float _11931;
  float _11936;
  int _11937;
  float _11942;
  float _11951;
  float _11952;
  float _11954;
  float _11956;
  float _11957;
  float4 _11959;
  float _11963;
  float _11964;
  float _11967;
  float _11968;
  float _11973;
  float _11974;
  float _11977;
  float _11978;
  float _11980;
  float _11982;
  bool _11983;
  bool _11984;
  bool _11994;
  bool _12003;
  float _12020;
  float _12022;
  float _12024;
  float _12026;
  float _12030;
  float _12032;
  float _12036;
  float _12038;
  int _12045;
  float _12050;
  float _12059;
  float _12060;
  float _12063;
  float _12064;
  float4 _12066;
  float _12070;
  float _12071;
  float _12074;
  float _12075;
  float _12077;
  float _12079;
  bool _12080;
  bool _12081;
  bool _12091;
  bool _12100;
  float _12117;
  float _12119;
  float _12123;
  float _12125;
  float _12129;
  float _12131;
  float _12135;
  float _12137;
  int _12144;
  float _12149;
  float _12158;
  float _12159;
  float _12162;
  float _12163;
  float4 _12165;
  float _12169;
  float _12170;
  float _12173;
  float _12174;
  float _12176;
  float _12178;
  bool _12179;
  bool _12180;
  bool _12190;
  bool _12199;
  float _12216;
  float _12218;
  float _12222;
  float _12224;
  float _12228;
  float _12230;
  float _12234;
  float _12236;
  int _12243;
  float _12248;
  float _12257;
  float _12258;
  float _12261;
  float _12262;
  float4 _12264;
  float _12268;
  float _12269;
  float _12272;
  float _12273;
  float _12275;
  float _12277;
  bool _12278;
  bool _12279;
  bool _12289;
  bool _12298;
  float _12315;
  float _12317;
  float _12321;
  float _12323;
  float _12327;
  float _12329;
  float _12333;
  float _12335;
  float _12336;
  float _12347;
  float _12353;
  float _12355;
  float _12357;
  float _12379;
  float4 _12386;
  float _12400;
  float _12401;
  float _12402;
  float _12403;
  float _12405;
  float _12410;
  float _12413;
  float _12414;
  float _12416;
  float _12417;
  float _12422;
  float _12427;
  float _12429;
  float _12432;
  float _12433;
  float _12438;
  float _12440;
  float _12442;
  float _12444;
  float _12449;
  float _12455;
  float _12457;
  float3 _12491;
  float _12502;
  float4 _12524;
  float _12557;
  float _12577;
  bool _12590;
  float _12591;
  float _12592;
  float _12593;
  bool _12594;
  float _12596;
  float _12597;
  float _12601;
  float _12607;
  float _12621;
  float _12622;
  float _12625;
  float _12629;
  int _12630;
  float _12632;
  float _12634;
  float _12637;
  float _12641;
  float _12652;
  float _12653;
  float _12654;
  float _12656;
  float _12674;
  int _12681;
  int _12686;
  int _12688;
  int _12689;
  int _12691;
  int _12692;
  int _12701;
  int _12704;
  float _12709;
  bool _12720;
  float _12723;
  float _12725;
  float _12726;
  float _12727;
  float _12728;
  float _12729;
  float _12730;
  float _12731;
  float _12732;
  float _12733;
  float _12734;
  float _12735;
  float _12736;
  bool _12737;
  float _12738;
  float _12739;
  float _12742;
  float _12743;
  float _12745;
  float _12772;
  float _12777;
  float _12784;
  float _12785;
  float _12786;
  float _12788;
  float _12792;
  float _12793;
  float _12794;
  float _12795;
  float _12796;
  float _12797;
  float _12798;
  float _12804;
  float _12813;
  float _12817;
  float _12818;
  float _12819;
  float _12820;
  float _12824;
  float _12825;
  float _12826;
  float _12834;
  float _12846;
  float _12847;
  float _12848;
  float _12849;
  float _12850;
  float _12851;
  float _12854;
  float _12856;
  float _12858;
  float _12859;
  float _12860;
  float _12861;
  float _12864;
  float _12871;
  float _12872;
  float _12873;
  float _12875;
  float _12883;
  float _12884;
  float _12885;
  float _12888;
  float _12891;
  float _12894;
  bool _12895;
  float _12899;
  float _12901;
  float _12902;
  float _12910;
  float _12913;
  float _12914;
  float _12919;
  float _12928;
  float _12929;
  float _12932;
  float _12934;
  float _12935;
  float _12936;
  float _12938;
  float _12939;
  float _12940;
  float _12941;
  float _12946;
  float _12960;
  float _12965;
  float _12966;
  float _12968;
  float _12974;
  float _12977;
  float _12988;
  float _12989;
  float _12990;
  float _12991;
  float _12992;
  bool _12993;
  float _13011;
  bool _13016;
  float _13022;
  float _13039;
  float _13042;
  float _13043;
  float _13044;
  float _13045;
  float _13046;
  float _13047;
  float _13048;
  float _13050;
  float _13054;
  float _13055;
  float _13056;
  float _13057;
  float _13059;
  float _13060;
  float _13061;
  float _13069;
  float _13079;
  float _13080;
  float _13081;
  float _13098;
  float _13107;
  float _13112;
  float _13119;
  float _13120;
  float _13121;
  float _13122;
  float _13141;
  float _13142;
  float _13143;
  float _13144;
  float _13145;
  float _13146;
  float _13148;
  float _13162;
  float _13163;
  float _13164;
  float _13165;
  bool _13168;
  float _13169;
  float _13170;
  float _13171;
  float _13173;
  float _13176;
  float _13178;
  float _13179;
  float _13180;
  float _13181;
  float _13184;
  float _13187;
  float _13190;
  float _13192;
  float _13204;
  float _13205;
  float _13207;
  float _13208;
  float _13209;
  float _13216;
  float _13217;
  float _13218;
  float _13221;
  float _13224;
  float _13225;
  float _13230;
  float _13234;
  float _13239;
  float _13246;
  float _13250;
  float _13251;
  float _13252;
  float _13256;
  float _13257;
  float _13258;
  float _13265;
  float _13269;
  float _13273;
  float _13274;
  float _13278;
  float _13289;
  float _13299;
  float _13301;
  float _13314;
  float _13315;
  float _13321;
  float _13324;
  float _13333;
  float _13335;
  float _13344;
  float _13349;
  float _13355;
  float _13356;
  float _13360;
  float _13361;
  float _13366;
  float _13385;
  float _13388;
  float _13391;
  float _13405;
  float _13415;
  float _13416;
  float _13420;
  float _13422;
  float _13424;
  float _13427;
  float _13440;
  float _13458;
  float _13459;
  float _13462;
  float _13465;
  float _13468;
  float _13469;
  float _13473;
  float _13474;
  float _13475;
  float _13484;
  float _13485;
  float _13503;
  float _13513;
  float _13527;
  float _13528;
  float _13546;
  float _13556;
  float _13573;
  float _13576;
  float _13580;
  float _13587;
  float _13591;
  int4 _13596;
  float _13603;
  float _13606;
  float _13610;
  float _13614;
  float _13623;
  float _13626;
  float _13630;
  float _13634;
  float _13642;
  float _13648;
  float _13658;
  float _13661;
  float _13665;
  float _13669;
  float _13676;
  float _13690;
  bool _13691;
  float _13713;
  bool _13714;
  float _13790;
  float _13794;
  float _13799;
  float _13801;
  float _13804;
  float _13807;
  float _13809;
  float _13816;
  float _13835;
  float _13849;
  float _13851;
  float _13875;
  float _13876;
  float _13877;
  float _13878;
  bool _13881;
  float _13882;
  float _13883;
  float _13884;
  float _13886;
  float _13889;
  float _13891;
  float _13892;
  float _13893;
  float _13894;
  float _13897;
  float _13900;
  float _13903;
  float _13905;
  float _13909;
  float _13918;
  float _13919;
  float _13921;
  float _13922;
  float _13923;
  float _13930;
  float _13931;
  float _13932;
  float _13935;
  float _13938;
  float _13941;
  float _13945;
  float _13949;
  float _13950;
  float _13953;
  float _13954;
  float _13960;
  float _13964;
  float _13965;
  float _13966;
  float _13967;
  float _13968;
  float _13969;
  float _13974;
  float _13975;
  float _13983;
  float _13984;
  float _13999;
  float _14017;
  float _14032;
  float _14033;
  float _14039;
  bool _14040;
  float _14044;
  float _14046;
  float _14047;
  float _14053;
  float _14056;
  float _14057;
  float _14062;
  float _14071;
  float _14072;
  float _14075;
  float _14077;
  float _14078;
  float _14079;
  float _14081;
  float _14082;
  float _14083;
  float _14084;
  float _14089;
  float _14103;
  float _14108;
  float _14109;
  float _14111;
  float _14117;
  float _14120;
  float _14148;
  float _14158;
  float _14175;
  float _14185;
  float _14186;
  float _14206;
  float _14208;
  float _14212;
  float _14213;
  float _14214;
  float _14226;
  float _14227;
  float _14228;
  float _14235;
  float _14236;
  float _14237;
  float _14241;
  float _14258;
  float _14259;
  float _14260;
  float _14267;
  float _14270;
  float _14275;
  float _14276;
  float _14291;
  float _14292;
  float _14293;
  float _14294;
  float _14297;
  float _14298;
  float _14299;
  float _14300;
  float _14303;
  float _14304;
  float _14305;
  float _14306;
  float _14309;
  float _14310;
  int _14313;
  int _14316;
  int _14319;
  int _14322;
  float _14325;
  float _14327;
  float _14328;
  float _14330;
  float _14334;
  float _14336;
  float _14340;
  float _14344;
  float _14348;
  float _14351;
  float _14354;
  float _14357;
  float _14369;
  float _14370;
  float _14371;
  float _14372;
  float _14373;
  float _14374;
  float _14375;
  float _14376;
  float _14377;
  float _14378;
  float _14379;
  float _14381;
  float _14383;
  float _14385;
  float _14387;
  float _14388;
  float _14394;
  float _14396;
  float _14403;
  float _14418;
  float _14420;
  float _14427;
  float _14437;
  float _14443;
  float _14445;
  float _14452;
  float _14469;
  float _14471;
  float _14478;
  float _14497;
  float _14498;
  float _14499;
  float _14500;
  float _14502;
  float _14504;
  float _14505;
  float _14506;
  float _14507;
  float _14508;
  float _14509;
  float _14510;
  float _14511;
  float _14513;
  float _14515;
  float _14516;
  float _14517;
  float _14518;
  float _14519;
  float _14520;
  float _14521;
  float _14523;
  float _14525;
  float _14532;
  bool _14545;
  float _14547;
  float _14553;
  float _14557;
  float _14559;
  float _14560;
  bool _14561;
  float _14563;
  float _14569;
  float _14570;
  float _14575;
  float _14576;
  float _14579;
  float _14581;
  float _14588;
  float _14601;
  float _14603;
  float _14610;
  float _14639;
  float _14640;
  float _14649;
  float _14658;
  float _14659;
  float _14665;
  float _14670;
  float _14679;
  float _14687;
  float _14690;
  float4 _14698;
  float _14700;
  float4 _14701;
  float _14710;
  float _14731;
  float _14732;
  float _14760;
  uint _14774;
  float _14786;
  float _14793;
  float _14804;
  float _14818;
  float _14819;
  float _14834;
  float _14837;
  float _14840;
  float4 _14861;
  float _14865;
  float _14866;
  float _14867;
  float _14869;
  float _14870;
  float _14871;
  float _14872;
  float _14873;
  float _14874;
  float _14875;
  float _14876;
  float _14877;
  float _14882;
  float _14887;
  float _14900;
  float4 _14908;
  float _14910;
  float _14917;
  bool _14950;
  int __loop_jump_target = -1;
  _59 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _65 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _70 = ((uint)(((int)(_65 << 3)) & 524280)) + SV_GroupThreadID.x;
  _71 = ((uint)(((uint)(_65) >> 16) << 3)) + SV_GroupThreadID.y;
  _78 = ((int)((((uint)(_71) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_70) >> 4)))) << 6;
  _81 = srvDeferredClusters[_78];
  if (_59 == 0) {
    _global_2 = (_81 & 255);
    _global_0 = (((uint)(_81) >> 16) & 255);
    _global_1 = (((uint)(_81) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _92 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_92 == 0)) {
    _96 = 0;
    while(true) {
      _98 = (_96 << 6) + _59;
      if ((uint)_98 < (uint)_global_2) {
        _105 = srvDeferredClusters[((int)(((uint)(_78 | 1)) + _98))];
        _global_3[min((uint)(_98), 63u)] = _105;
        _110 = _105 & 4095;
        _113 = srvLightInfoBase[_110].nFlags;
        _115 = srvLightInfoBase[_110].nRoomMask;
        _117 = srvLightInfoBase[_110].nBufferOffset;
        _global_4[min((uint)(_98), 63u)] = _113;
        _global_5[min((uint)(_98), 63u)] = _115;
        _global_6[min((uint)(_98), 63u)] = _117;
      }
      _119 = _96 + 1;
      if (!(_119 == _92)) {
        _96 = _119;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _124 = srvGlobalGBuffer0.Load(int3(_70, _71, 0));
  [branch]
  if (_124.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_70, _71)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_70, _71)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    [branch]
    if (_124.x > 0.0f) {
      _134 = srvGlobalGBuffer1.Load(int3(_70, _71, 0));
      _138 = srvGlobalGBuffer2.Load(int3(_70, _71, 0));
      _144 = srvGlobalGBuffer3.Load(int3(_70, _71, 0));
      _150 = srvGlobalGBuffer4.Load(int3(_70, _71, 0));
      _156 = srvGlobalGBuffer5.Load(int3(_70, _71, 0));
      _162 = saturate(_138.x);
      _163 = saturate(_138.y);
      _164 = saturate(_138.z);
      _166 = saturate(_144.x);
      _167 = saturate(_144.y);
      _168 = saturate(_144.z);
      _169 = saturate(_144.w);
      _171 = saturate(_150.y);
      _172 = saturate(_150.z);
      _179 = (saturate(_134.x) * 2.0f) + -1.0f;
      _180 = (saturate(_134.y) * 2.0f) + -1.0f;
      _184 = (1.0f - abs(_179)) - abs(_180);
      _186 = saturate(-0.0f - _184);
      _187 = -0.0f - _186;
      _192 = select((_179 >= 0.0f), _187, _186) + _179;
      _193 = select((_180 >= 0.0f), _187, _186) + _180;
      _195 = rsqrt(dot(float3(_192, _193, _184), float3(_192, _193, _184)));
      _196 = _192 * _195;
      _197 = _193 * _195;
      _198 = _195 * _184;
      _202 = (uint)(uint((saturate(_138.w) * 255.0f) + 0.5f)) >> 6;
      _204 = uint(saturate(_150.w) * 255.0f);
      _209 = ((float)((uint)((uint)(_204 & 7)))) * 0.003921568859368563f;
      _212 = (_209 >= 0.007843137718737125f) && (_209 < 0.0117647061124444f);
      if (!_212) {
        _219 = select(((_209 >= 0.003921568859368563f) && (_209 < 0.007843137718737125f)), 0.0f, _166);
        _220 = 0.0f;
      } else {
        _219 = 0.0f;
        _220 = _166;
      }
      _221 = (_209 >= 0.0235294122248888f);
      _222 = select(_221, 0.0f, _219);
      _223 = select(_221, 0.5f, _167);
      _224 = _223 * 0.07999999821186066f;
      _237 = ((int)(uint((_172 * 1.9921875f) + 0.003921568859368563f)) != 0);
      _241 = (_209 >= 0.01568627543747425f) && (_209 < 0.019607843831181526f);
      if (_241) {
        _251 = (_166 * _166);
        _252 = (_167 * _167);
        _253 = (_168 * _168);
        _254 = 0.0f;
        _255 = 0.5f;
        _256 = ((_172 - (((float)((bool)_237)) * 0.501960813999176f)) * 2.007874011993408f);
        _257 = _169;
        _258 = 0.0f;
      } else {
        _251 = ((_222 * (_162 - _224)) + _224);
        _252 = ((_222 * (_163 - _224)) + _224);
        _253 = ((_222 * (_164 - _224)) + _224);
        _254 = _222;
        _255 = _223;
        _256 = 0.0f;
        _257 = 0.0f;
        _258 = _169;
      }
      _260 = min(1.0f, max(saturate(_150.x), 0.019999999552965164f));
      _263 = (_209 >= 0.019607843831181526f) && (_209 < 0.0235294122248888f);
      if (_263) {
        _268 = min(1.0f, max(_172, 0.019999999552965164f));
        _269 = 0;
        _270 = _260;
      } else {
        _268 = _260;
        _269 = ((int)(uint)(_237));
        _270 = 0.0f;
      }
      _271 = _171 * _171;
      _274 = (_254 * (1.0f - _224)) + _224;
      if (_212) {
        _278 = uint((saturate(_156.y) * 255.0f) + 0.5f);
        _281 = ((float)((uint)((uint)((uint)(_278) >> 1)))) * 0.007874015718698502f;
        _308 = (saturate(_156.x) * 4.0f);
        _309 = (_278 & 1);
        _310 = (int)(uint((saturate(_156.z) * 255.0f) + 0.5f));
        _311 = 0;
        _312 = 0;
        _313 = 0;
        _314 = 0.0f;
        _315 = 0.0f;
        _316 = ((_281 * _281) * _271);
      } else {
        if ((_209 >= 0.003921568859368563f) && (_209 < 0.007843137718737125f)) {
          _308 = 0.0f;
          _309 = 0;
          _310 = 0;
          _311 = (int)(uint((_166 * 255.0f) + 0.5f));
          _312 = (int)(uint((_168 * 255.0f) + 0.5f));
          _313 = ((int)(uint((_172 * 255.0f) + 0.5f)) & 127);
          _314 = 0.0f;
          _315 = 0.0f;
          _316 = _271;
        } else {
          _308 = 0.0f;
          _309 = 0;
          _310 = 0;
          _311 = 0;
          _312 = 0;
          _313 = 0;
          _314 = select(_263, _168, 0.0f);
          _315 = select(_263, _270, 0.0f);
          _316 = _271;
        }
      }
      _317 = (_209 >= 0.003921568859368563f);
      _318 = (_209 < 0.007843137718737125f);
      _319 = _317 && _318;
      if (!_319) {
        if (!(!(_209 >= 0.0117647061124444f))) {
          _325 = (_209 < 0.01568627543747425f);
        } else {
          _325 = false;
        }
      } else {
        _325 = true;
      }
      _326 = !(_209 >= 0.0235294122248888f);
      if (!_326) {
        _332 = 0;
        _333 = (_166 * _166);
        _334 = (_167 * _167);
        _335 = (_168 * _168);
      } else {
        _332 = _269;
        _333 = 0.0f;
        _334 = 0.0f;
        _335 = 0.0f;
      }
      _337 = srvBlurredGbufNormal.Load(int3(_70, _71, 0));
      _342 = (_337.x * 2.0f) + -1.0f;
      _343 = (_337.y * 2.0f) + -1.0f;
      _347 = (1.0f - abs(_342)) - abs(_343);
      _349 = saturate(-0.0f - _347);
      _350 = -0.0f - _349;
      _355 = select((_342 >= 0.0f), _350, _349) + _342;
      _356 = select((_343 >= 0.0f), _350, _349) + _343;
      _358 = rsqrt(dot(float3(_355, _356, _347), float3(_355, _356, _347)));
      _359 = _355 * _358;
      _360 = _356 * _358;
      _361 = _358 * _347;
      _362 = (float)((uint)_70);
      _363 = (float)((uint)_71);
      _371 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _362) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
      _372 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _363) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
      _378 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _124.x) - cbSharedPerViewData.vViewRemap.y);
      _379 = _378 * _371;
      _380 = _378 * _372;
      _381 = -0.0f - _378;
      _383 = ((_202 & 1) != 0);
      _384 = _202 & 3;
      _390 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
      _394 = srvReflectionsWeight.Load(int3(((uint)(_70) >> _390), ((uint)(_71) >> _390), 0));
      _400 = ((float)((uint)((uint)(_394.x & 254)))) * 0.003921568859368563f;
      if ((_394.x & 1) == 0) {
        _409 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _362), (cbSharedPerViewData.vViewportSize.y * _363)), 0.0f);
        _418 = (1.0f - _400);
        _419 = (_409.x * _400);
        _420 = (_409.y * _400);
        _421 = (_409.z * _400);
      } else {
        _418 = 1.0f;
        _419 = 0.0f;
        _420 = 0.0f;
        _421 = 0.0f;
      }
      _430 = cbSharedPerViewData.vViewportSize.x * (_362 + 0.5f);
      _431 = cbSharedPerViewData.vViewportSize.y * (_363 + 0.5f);
      if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
        _446 = (floor((_430 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
        _447 = (floor((_431 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
        _450 = max(_446, cbDeferredShading.vScreenPixelSize.z);
        _451 = max(_447, cbDeferredShading.vScreenPixelSize.w);
        _454 = min((_446 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
        _455 = min((_447 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
        _460 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_450 + cbDeferredShading.vScreenPixelSize.z), (_451 + cbDeferredShading.vScreenPixelSize.w)));
        if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _460.x) - cbSharedPerViewData.vViewRemap.y)) - _378) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _460.y) - cbSharedPerViewData.vViewRemap.y)) - _378) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _460.z) - cbSharedPerViewData.vViewRemap.y)) - _378) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _460.w) - cbSharedPerViewData.vViewRemap.y)) - _378) > 0.029999999329447746f)) {
          _494 = abs(_124.x - _460.w);
          _496 = abs(_124.x - _460.z);
          _497 = (_496 < _494);
          _499 = select(_497, _496, _494);
          _501 = abs(_124.x - _460.x);
          _502 = (_501 < _499);
          if (abs(_124.x - _460.y) < select(_502, _501, _499)) {
            _511 = _454;
            _512 = _455;
          } else {
            _511 = select(_502, _450, select(_497, _454, _450));
            _512 = select(_502, _455, _451);
          }
        } else {
          _511 = _430;
          _512 = _431;
        }
      } else {
        _511 = _430;
        _512 = _431;
      }
      _515 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_511, _512), 0.0f);
      _519 = _515.x - _515.z;
      _531 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_515.y + _519)), 0.0f);
      _532 = -0.0f - _531;
      _533 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_515.x + _515.z)), 0.0f);
      _534 = -0.0f - _533;
      _535 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_519 - _515.y)), 0.0f);
      _536 = -0.0f - _535;
      _539 = (cbSharedPerViewData.nSSGIEnabled == 0);
      if (!_539) {
        if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
          _550 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_511, _512), 0.0f)).x);
        } else {
          _550 = 1.0f;
        }
      } else {
        _550 = 1.0f;
      }
      if (!_539) {
        _554 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
        _555 = (int)(uint)(_554);
        if (_554) {
          _558 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_511, _512), 0.0f);
          _563 = (_558.x * 2.0f) + -1.0f;
          _564 = (_558.y * 2.0f) + -1.0f;
          _568 = (1.0f - abs(_563)) - abs(_564);
          _570 = saturate(-0.0f - _568);
          _571 = -0.0f - _570;
          _576 = select((_563 >= 0.0f), _571, _570) + _563;
          _577 = select((_564 >= 0.0f), _571, _570) + _564;
          _579 = rsqrt(dot(float3(_576, _577, _568), float3(_576, _577, _568)));
          _580 = _576 * _579;
          _581 = _577 * _579;
          _582 = _579 * _568;
          _584 = rsqrt(dot(float3(_580, _581, _582), float3(_580, _581, _582)));
          _589 = _555;
          _590 = (_580 * _584);
          _591 = (_581 * _584);
          _592 = (_584 * _582);
        } else {
          _589 = _555;
          _590 = 0.0f;
          _591 = 0.0f;
          _592 = 0.0f;
        }
      } else {
        _589 = 0;
        _590 = 0.0f;
        _591 = 0.0f;
        _592 = 0.0f;
      }
      _593 = 1.0f - _254;
      _597 = -0.0f - _371;
      _598 = -0.0f - _372;
      _600 = rsqrt(dot(float3(_597, _598, 1.0f), float3(_597, _598, 1.0f)));
      _601 = _600 * _597;
      _602 = _600 * _598;
      _610 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _71) + _70))];
      _611 = _610 & 255;
      _612 = (uint)(_610) >> 8;
      _613 = _612 & 255;
      _617 = ((float)((uint)((uint)(((uint)(_610) >> 16) & 255)))) * 0.003921568859368563f;
      _619 = (float)((uint)((uint)((uint)(_610) >> 24)));
      _620 = _619 * 0.003921568859368563f;
      [branch]
      if (!((_384 == 2) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
        _630 = _268 * 4.0f;
        _631 = -0.0f - _601;
        _632 = -0.0f - _602;
        _633 = -0.0f - _600;
        _635 = dot(float3(_631, _632, _633), float3(_196, _197, _198)) * 2.0f;
        _636 = _635 * _196;
        _637 = _635 * _197;
        _638 = _635 * _198;
        _639 = _631 - _636;
        _640 = _632 - _637;
        _641 = _633 - _638;
        if (_319) {
          _644 = dot(float3(_631, _632, _633), float3(_359, _360, _361)) * 2.0f;
          _653 = exp2(log2(1.0f - saturate(dot(float3(_601, _602, _600), float3(_196, _197, _198)))) * 5.0f);
          _660 = (_653 * (_636 - (_644 * _359))) + _639;
          _661 = (_653 * (_637 - (_644 * _360))) + _640;
          _662 = (_653 * (_638 - (_644 * _361))) + _641;
          _664 = rsqrt(dot(float3(_660, _661, _662), float3(_660, _661, _662)));
          _674 = (_653 * (_359 - _196)) + _196;
          _675 = (_653 * (_360 - _197)) + _197;
          _676 = (_653 * (_361 - _198)) + _198;
          _678 = rsqrt(dot(float3(_674, _675, _676), float3(_674, _675, _676)));
          _683 = (_660 * _664);
          _684 = (_661 * _664);
          _685 = (_662 * _664);
          _686 = (_678 * _674);
          _687 = (_678 * _675);
          _688 = (_678 * _676);
        } else {
          _683 = _639;
          _684 = _640;
          _685 = _641;
          _686 = _196;
          _687 = _197;
          _688 = _198;
        }
        _689 = _268 * _268;
        _690 = 1.0f - _689;
        _693 = (sqrt(_690) + _689) * _690;
        _700 = (_693 * (_683 - _686)) + _686;
        _701 = (_693 * (_684 - _687)) + _687;
        _702 = (_693 * (_685 - _688)) + _688;
        _706 = saturate(1.0f - ((_268 + -0.30000001192092896f) * 3.3333332538604736f));
        _721 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _702, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _701, (_700 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
        _724 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _702, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _701, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _700)));
        _727 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _702, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _701, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _700)));
        _730 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _198, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _197, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _196)));
        _733 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _198, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _197, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _196)));
        _736 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _198, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _197, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _196)));
        if (!(_global_0 == 0)) {
          _755 = 0;
          _756 = 0.0f;
          _757 = 0.0f;
          _758 = 0.0f;
          _759 = 0.0f;
          _760 = 0.0f;
          _761 = 0.0f;
          _762 = 0.0f;
          _763 = 0.0f;
          _764 = 0.0f;
          _765 = 0.0f;
          _766 = 0.0f;
          _767 = 0.0f;
          _768 = 0.0f;
          _769 = 0.0f;
          while(true) {
            _1047 = _756;
            _1048 = _757;
            _1049 = _758;
            _1050 = _759;
            _1051 = _760;
            _1052 = _761;
            _1053 = _762;
            _1054 = _763;
            _1055 = _764;
            _1056 = _765;
            _1057 = _766;
            _1058 = _767;
            _1059 = _768;
            _1060 = _769;
            _772 = _global_5[min((uint)(_755), 63u)];
            _773 = _global_6[min((uint)(_755), 63u)];
            _776 = asfloat(srvLightInfoProperties.Load4(_773)).x;
            _777 = asfloat(srvLightInfoProperties.Load4(_773)).y;
            _778 = asfloat(srvLightInfoProperties.Load4(_773)).z;
            _779 = asfloat(srvLightInfoProperties.Load4(_773)).w;
            _782 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 16u)))).x;
            _783 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 16u)))).y;
            _784 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 16u)))).z;
            _785 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 16u)))).w;
            _788 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 32u)))).x;
            _789 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 32u)))).y;
            _790 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 32u)))).z;
            _791 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 32u)))).w;
            _794 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 48u)))).x;
            _795 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 48u)))).y;
            _796 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 48u)))).z;
            _797 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 48u)))).w;
            _800 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 64u)))).x;
            _801 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 64u)))).y;
            _802 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 64u)))).z;
            _803 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 64u)))).w;
            _806 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 80u)))).x;
            _807 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 80u)))).y;
            _808 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 80u)))).z;
            _809 = asfloat(srvLightInfoProperties.Load4(((int)(_773 + 80u)))).w;
            _812 = asint(srvLightInfoProperties.Load(((int)(_773 + 96u))));
            _815 = asfloat(srvLightInfoProperties.Load3(((int)(_773 + 100u)))).x;
            _816 = asfloat(srvLightInfoProperties.Load3(((int)(_773 + 100u)))).y;
            _817 = asfloat(srvLightInfoProperties.Load3(((int)(_773 + 100u)))).z;
            _820 = asfloat(srvLightInfoProperties.Load3(((int)(_773 + 112u)))).x;
            _821 = asfloat(srvLightInfoProperties.Load3(((int)(_773 + 112u)))).y;
            _822 = asfloat(srvLightInfoProperties.Load3(((int)(_773 + 112u)))).z;
            _825 = asint(srvLightInfoProperties.Load(((int)(_773 + 124u))));
            _828 = asint(srvLightInfoProperties.Load(((int)(_773 + 128u))));
            _831 = _812 & 65535;
            _860 = ((saturate(1.0f - abs(mad(_778, _381, mad(_777, _380, (_776 * _379))) + _779)) * f16tof32(((uint)((uint)(_812) >> 16)))) * saturate(1.0f - abs(mad(_784, _381, mad(_783, _380, (_782 * _379))) + _785))) * saturate(1.0f - abs(mad(_790, _381, mad(_789, _380, (_788 * _379))) + _791));
            [branch]
            if (_860 > 0.0f) {
              _863 = _860 * _860;
              [branch]
              if (_706 < 1.0f) {
                _866 = (float)((uint)_831);
                _867 = -0.0f - _721;
                [branch]
                if (!(_866 >= 341.0f)) {
                  _879 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_867, _724, _727, _866), _630);
                  _884 = _879.x;
                  _885 = _879.y;
                  _886 = _879.z;
                } else {
                  _873 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_867, _724, _727, (_866 + -341.0f)), _630);
                  _884 = _873.x;
                  _885 = _873.y;
                  _886 = _873.z;
                }
              } else {
                _884 = 0.0f;
                _885 = 0.0f;
                _886 = 0.0f;
              }
              _888 = (float)((uint)_831);
              [branch]
              if (_706 > 0.0f) {
                _892 = mad(_796, _702, mad(_795, _701, (_794 * _700)));
                _895 = mad(_802, _702, mad(_801, _701, (_800 * _700)));
                _898 = mad(_808, _702, mad(_807, _701, (_806 * _700)));
                _939 = min(((((float((int)(((int)(uint)((int)(_892 > 0.0f))) - ((int)(uint)((int)(_892 < 0.0f))))) * _815) - _797) - mad(_796, _381, mad(_795, _380, (_794 * _379)))) / _892), min(((((float((int)(((int)(uint)((int)(_895 > 0.0f))) - ((int)(uint)((int)(_895 < 0.0f))))) * _816) - _803) - mad(_802, _381, mad(_801, _380, (_800 * _379)))) / _895), ((((float((int)(((int)(uint)((int)(_898 > 0.0f))) - ((int)(uint)((int)(_898 < 0.0f))))) * _817) - _809) - mad(_808, _381, mad(_807, _380, (_806 * _379)))) / _898)));
                _944 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _381, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _380, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _379))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _820) + (_939 * _721);
                _946 = ((mad((cbSharedPerViewData.mViewToWorld[1][0].z), _381, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _380, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _379))) + (cbSharedPerViewData.mViewToWorld[1][0].w)) - _821) + (_939 * _724);
                _948 = ((mad((cbSharedPerViewData.mViewToWorld[2][0].z), _381, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _380, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _379))) + (cbSharedPerViewData.mViewToWorld[2][0].w)) - _822) + (_939 * _727);
                _955 = (max(log2((_939 * _939) / dot(float3(_944, _946, _948), float3(_944, _946, _948))), -1.0f) * 0.3333333432674408f) + _630;
                _956 = -0.0f - _944;
                [branch]
                if (!(_888 >= 341.0f)) {
                  _968 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_956, _946, _948, _888), _955);
                  _973 = _968.x;
                  _974 = _968.y;
                  _975 = _968.z;
                } else {
                  _962 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_956, _946, _948, (_888 + -341.0f)), _955);
                  _973 = _962.x;
                  _974 = _962.y;
                  _975 = _962.z;
                }
              } else {
                _973 = 0.0f;
                _974 = 0.0f;
                _975 = 0.0f;
              }
              _976 = -0.0f - _730;
              [branch]
              if (!(_888 >= 341.0f)) {
                _988 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_976, _733, _736, _888), 0.0f);
                _993 = _988.x;
                _994 = _988.y;
                _995 = _988.z;
              } else {
                _982 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_976, _733, _736, (_888 + -341.0f)), 0.0f);
                _993 = _982.x;
                _994 = _982.y;
                _995 = _982.z;
              }
              _1005 = _863 * f16tof32(((uint)((uint)(_825) >> 16)));
              _1006 = _1005 * _993;
              _1007 = _863 * f16tof32(_825);
              _1008 = _1007 * _994;
              _1009 = _863 * f16tof32(((uint)((uint)(_828) >> 16)));
              _1010 = _1009 * _995;
              _1011 = _1005 * (lerp(_884, _973, _706));
              _1012 = _1007 * (lerp(_885, _974, _706));
              _1013 = _1009 * (lerp(_886, _975, _706));
              [branch]
              if (!((_772 & ((int)(1 << (_610 & 31)))) == 0)) {
                _1027 = (_1006 + _756);
                _1028 = (_1008 + _757);
                _1029 = (_1010 + _758);
                _1030 = (_1011 + _759);
                _1031 = (_1012 + _760);
                _1032 = (_1013 + _761);
                _1033 = (_863 + _762);
              } else {
                _1027 = _756;
                _1028 = _757;
                _1029 = _758;
                _1030 = _759;
                _1031 = _760;
                _1032 = _761;
                _1033 = _762;
              }
              [branch]
              if (!((_772 & ((int)(1 << (_612 & 31)))) == 0)) {
                _1047 = _1027;
                _1048 = _1028;
                _1049 = _1029;
                _1050 = _1030;
                _1051 = _1031;
                _1052 = _1032;
                _1053 = _1033;
                _1054 = (_1006 + _763);
                _1055 = (_1008 + _764);
                _1056 = (_1010 + _765);
                _1057 = (_1011 + _766);
                _1058 = (_1012 + _767);
                _1059 = (_1013 + _768);
                _1060 = (_863 + _769);
              } else {
                _1047 = _1027;
                _1048 = _1028;
                _1049 = _1029;
                _1050 = _1030;
                _1051 = _1031;
                _1052 = _1032;
                _1053 = _1033;
                _1054 = _763;
                _1055 = _764;
                _1056 = _765;
                _1057 = _766;
                _1058 = _767;
                _1059 = _768;
                _1060 = _769;
              }
            } else {
              _1047 = _756;
              _1048 = _757;
              _1049 = _758;
              _1050 = _759;
              _1051 = _760;
              _1052 = _761;
              _1053 = _762;
              _1054 = _763;
              _1055 = _764;
              _1056 = _765;
              _1057 = _766;
              _1058 = _767;
              _1059 = _768;
              _1060 = _769;
            }
            _1061 = _755 + 1u;
            if (!(_1061 == _global_0)) {
              _755 = _1061;
              _756 = _1047;
              _757 = _1048;
              _758 = _1049;
              _759 = _1050;
              _760 = _1051;
              _761 = _1052;
              _762 = _1053;
              _763 = _1054;
              _764 = _1055;
              _765 = _1056;
              _766 = _1057;
              _767 = _1058;
              _768 = _1059;
              _769 = _1060;
              continue;
            }
            _1065 = _1047;
            _1066 = _1048;
            _1067 = _1049;
            _1068 = _1050;
            _1069 = _1051;
            _1070 = _1052;
            _1071 = _1053;
            _1072 = _1054;
            _1073 = _1055;
            _1074 = _1056;
            _1075 = _1057;
            _1076 = _1058;
            _1077 = _1059;
            _1078 = _1060;
            break;
          }
        } else {
          _1065 = 0.0f;
          _1066 = 0.0f;
          _1067 = 0.0f;
          _1068 = 0.0f;
          _1069 = 0.0f;
          _1070 = 0.0f;
          _1071 = 0.0f;
          _1072 = 0.0f;
          _1073 = 0.0f;
          _1074 = 0.0f;
          _1075 = 0.0f;
          _1076 = 0.0f;
          _1077 = 0.0f;
          _1078 = 0.0f;
        }
        _1084 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_610 & 31)))) != 0);
        if ((_617 > 0.0f) || ((_620 > 0.0f) || _1084)) {
          _1094 = srvFallbackInfo[((_611 << 2) | 3)].x;
          _1096 = select(_1084, 9.999999747378752e-05f, (_619 * 3.921568847431445e-09f));
          _1097 = _1071 * 0.20000000298023224f;
          _1104 = saturate((_1096 - _1097) / (((_1071 * 0.4000000059604645f) + 9.99999993922529e-09f) - _1097)) * _1096;
          [branch]
          if (_1104 > 0.0f) {
            [branch]
            if ((int)_1094 > (int)-1) {
              _1109 = float((int)(_1094));
              _1110 = -0.0f - _721;
              _1111 = !(_1109 >= 341.0f);
              [branch]
              if (_1111) {
                _1122 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1110, _724, _727, _1109), _630);
                _1127 = _1122.x;
                _1128 = _1122.y;
                _1129 = _1122.z;
              } else {
                _1116 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1110, _724, _727, (_1109 + -341.0f)), _630);
                _1127 = _1116.x;
                _1128 = _1116.y;
                _1129 = _1116.z;
              }
              _1133 = -0.0f - _730;
              [branch]
              if (_1111) {
                _1144 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1133, _733, _736, _1109), 0.0f);
                _1149 = _1144.x;
                _1150 = _1144.y;
                _1151 = _1144.z;
              } else {
                _1138 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1133, _733, _736, (_1109 + -341.0f)), 0.0f);
                _1149 = _1138.x;
                _1150 = _1138.y;
                _1151 = _1138.z;
              }
              _1162 = ((_1127 * _1104) + _1068);
              _1163 = ((_1128 * _1104) + _1069);
              _1164 = ((_1129 * _1104) + _1070);
              _1165 = ((_1149 * _1104) + _1065);
              _1166 = ((_1150 * _1104) + _1066);
              _1167 = ((_1151 * _1104) + _1067);
            } else {
              _1162 = _1068;
              _1163 = _1069;
              _1164 = _1070;
              _1165 = _1065;
              _1166 = _1066;
              _1167 = _1067;
            }
            _1170 = (_1104 + _1071);
            _1171 = _1162;
            _1172 = _1163;
            _1173 = _1164;
            _1174 = _1165;
            _1175 = _1166;
            _1176 = _1167;
          } else {
            _1170 = _1071;
            _1171 = _1068;
            _1172 = _1069;
            _1173 = _1070;
            _1174 = _1065;
            _1175 = _1066;
            _1176 = _1067;
          }
          if (_1170 > 0.0f) {
            _1182 = (cbSharedPerViewData.vHDRScale.x * _617) / _1170;
            _1190 = (_1182 * _1174);
            _1191 = (_1182 * _1175);
            _1192 = (_1182 * _1176);
            _1193 = (_1182 * _1171);
            _1194 = (_1182 * _1172);
            _1195 = (_1182 * _1173);
          } else {
            _1190 = 0.0f;
            _1191 = 0.0f;
            _1192 = 0.0f;
            _1193 = 0.0f;
            _1194 = 0.0f;
            _1195 = 0.0f;
          }
        } else {
          _1190 = 0.0f;
          _1191 = 0.0f;
          _1192 = 0.0f;
          _1193 = 0.0f;
          _1194 = 0.0f;
          _1195 = 0.0f;
        }
        [branch]
        if (!(_620 == 0.0f)) {
          _1202 = srvFallbackInfo[((_613 << 2) | 3)].x;
          _1203 = _619 * 3.921568847431445e-09f;
          [branch]
          if ((int)_1202 > (int)-1) {
            _1206 = float((int)(_1202));
            _1207 = -0.0f - _721;
            _1208 = !(_1206 >= 341.0f);
            [branch]
            if (_1208) {
              _1219 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1207, _724, _727, _1206), _630);
              _1224 = _1219.x;
              _1225 = _1219.y;
              _1226 = _1219.z;
            } else {
              _1213 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1207, _724, _727, (_1206 + -341.0f)), _630);
              _1224 = _1213.x;
              _1225 = _1213.y;
              _1226 = _1213.z;
            }
            _1230 = -0.0f - _730;
            [branch]
            if (_1208) {
              _1241 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1230, _733, _736, _1206), 0.0f);
              _1246 = _1241.x;
              _1247 = _1241.y;
              _1248 = _1241.z;
            } else {
              _1235 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1230, _733, _736, (_1206 + -341.0f)), 0.0f);
              _1246 = _1235.x;
              _1247 = _1235.y;
              _1248 = _1235.z;
            }
            _1259 = ((_1224 * _1203) + _1075);
            _1260 = ((_1225 * _1203) + _1076);
            _1261 = ((_1226 * _1203) + _1077);
            _1262 = ((_1246 * _1203) + _1072);
            _1263 = ((_1247 * _1203) + _1073);
            _1264 = ((_1248 * _1203) + _1074);
          } else {
            _1259 = _1075;
            _1260 = _1076;
            _1261 = _1077;
            _1262 = _1072;
            _1263 = _1073;
            _1264 = _1074;
          }
          _1269 = (cbSharedPerViewData.vHDRScale.x * _620) / (_1078 + _1203);
          _1283 = ((_1269 * _1262) + _1190);
          _1284 = ((_1269 * _1263) + _1191);
          _1285 = ((_1269 * _1264) + _1192);
          _1286 = ((_1269 * _1259) + _1193);
          _1287 = ((_1269 * _1260) + _1194);
          _1288 = ((_1269 * _1261) + _1195);
        } else {
          _1283 = _1190;
          _1284 = _1191;
          _1285 = _1192;
          _1286 = _1193;
          _1287 = _1194;
          _1288 = _1195;
        }
      } else {
        _1283 = 0.0f;
        _1284 = 0.0f;
        _1285 = 0.0f;
        _1286 = 0.0f;
        _1287 = 0.0f;
        _1288 = 0.0f;
      }
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
        _1307 = (min((_532 / max(9.999999747378752e-05f, _1283)), 1.0f) * _1286);
        _1308 = (min((_534 / max(9.999999747378752e-05f, _1284)), 1.0f) * _1287);
        _1309 = (min((_536 / max(9.999999747378752e-05f, _1285)), 1.0f) * _1288);
      } else {
        _1307 = _1286;
        _1308 = _1287;
        _1309 = _1288;
      }
      _1322 = saturate(dot(float3(_601, _602, _600), float3(_196, _197, _198)));
      _1325 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1322, _268), 0.0f);
      _1328 = _1325.x + _1325.y;
      _1329 = 1.0f - _1328;
      _1333 = max(9.999999747378752e-06f, _1328);
      _1337 = ((_1329 * _251) / _1333) + 1.0f;
      _1338 = ((_1329 * _252) / _1333) + 1.0f;
      _1339 = ((_1329 * _253) / _1333) + 1.0f;
      _1347 = (_1337 * ((cbSharedPerViewData.vHDRScale.x * _419) + (_1307 * _418))) * ((_1325.x * _251) + _1325.y);
      _1349 = (((_1325.x * _252) + _1325.y) * ((cbSharedPerViewData.vHDRScale.x * _420) + (_1308 * _418))) * _1338;
      _1351 = (((_1325.x * _253) + _1325.y) * ((cbSharedPerViewData.vHDRScale.x * _421) + (_1309 * _418))) * _1339;
      _1352 = min(_316, _550);
      if (!(_global_1 == 0)) {
        _1356 = 0;
        _1357 = _1352;
        while(true) {
          _1475 = _1357;
          _1358 = _1356 + (uint)(_global_0);
          _1361 = _global_5[min((uint)(_1358), 63u)];
          _1362 = _global_6[min((uint)(_1358), 63u)];
          _1366 = (int)((int)(_1361 << (((int)(31u - _610)) & 31))) >> 31;
          _1370 = (int)((int)(_1361 << ((31 - _612) & 31))) >> 31;
          _1382 = saturate((asfloat((_1366 & asint(_617))) + asfloat((_1370 & asint(_620)))) + asfloat(((_1370 & 1065353216) & _1366)));
          [branch]
          if (!(_1382 == 0.0f)) {
            _1387 = asfloat(srvLightInfoProperties.Load4(_1362)).x;
            _1388 = asfloat(srvLightInfoProperties.Load4(_1362)).y;
            _1389 = asfloat(srvLightInfoProperties.Load4(_1362)).z;
            _1390 = asfloat(srvLightInfoProperties.Load4(_1362)).w;
            _1393 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 16u)))).x;
            _1394 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 16u)))).y;
            _1395 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 16u)))).z;
            _1396 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 16u)))).w;
            _1399 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 32u)))).x;
            _1400 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 32u)))).y;
            _1401 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 32u)))).z;
            _1402 = asfloat(srvLightInfoProperties.Load4(((int)(_1362 + 32u)))).w;
            _1405 = asint(srvLightInfoProperties.Load(((int)(_1362 + 48u))));
            _1408 = asint(srvLightInfoProperties.Load(((int)(_1362 + 52u))));
            _1411 = asint(srvLightInfoProperties.Load(((int)(_1362 + 56u))));
            _1414 = asint(srvLightInfoProperties.Load(((int)(_1362 + 60u))));
            _1429 = mad(_1389, _381, mad(_1388, _380, (_1387 * _379))) + _1390;
            _1433 = mad(_1395, _381, mad(_1394, _380, (_1393 * _379))) + _1396;
            _1437 = mad(_1401, _381, mad(_1400, _380, (_1399 * _379))) + _1402;
            _1462 = saturate(1.0f - ((_1429 + 1.0f) * f16tof32(_1408))) + saturate(1.0f - ((1.0f - _1429) * f16tof32(((uint)((uint)(_1408) >> 16)))));
            _1463 = saturate(1.0f - ((_1433 + 1.0f) * f16tof32(_1411))) + saturate(1.0f - ((1.0f - _1433) * f16tof32(((uint)((uint)(_1411) >> 16)))));
            _1464 = saturate(1.0f - ((_1437 + 1.0f) * f16tof32(_1414))) + saturate(1.0f - ((1.0f - _1437) * f16tof32(((uint)((uint)(_1414) >> 16)))));
            _1467 = saturate(1.0f - dot(float3(_1462, _1463, _1464), float3(_1462, _1463, _1464)));
            _1475 = (saturate(1.0f - ((_1467 * _1467) * (f16tof32(((uint)((uint)(_1405) >> 16))) * _1382))) * _1357);
          } else {
            _1475 = _1357;
          }
          _1476 = _1356 + 1u;
          if (!(_1476 == _global_1)) {
            _1356 = _1476;
            _1357 = _1475;
            continue;
          }
          _1480 = _1475;
          break;
        }
      } else {
        _1480 = _1352;
      }
      _1481 = dot(float3(_162, _163, _164), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      if ((_319) | ((_209 >= 0.0117647061124444f) && (_209 < 0.01568627543747425f))) {
        _1498 = max(saturate(1.0f - _258), 0.10000000149011612f);
        _1504 = (exp2((_1498 * _1498) * -1.4426950216293335f) * 0.07800000160932541f);
        _1505 = 0.0f;
        _1506 = 0.0f;
      } else {
        _1504 = saturate((_162 * 2.0f) - _1481);
        _1505 = saturate((_163 * 2.0f) - _1481);
        _1506 = saturate((_164 * 2.0f) - _1481);
      }
      _1507 = _1480 * _258;
      _1508 = _1504 * _1507;
      _1509 = _1505 * _1507;
      _1510 = _1506 * _1507;
      _1514 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
      if (_1514) {
        _1526 = saturate((_1480 + -1.0f) + exp2((_268 * _268) * log2(max((_1480 + _1322), 0.0f))));
      } else {
        _1526 = _1480;
      }
      if (_212) {
        _1530 = max(9.999999747378752e-06f, max(_164, max(_162, _163)));
        _1572 = ((((saturate(_162 / _1530) + -1.0f) * 0.5f) + 1.0f) * _1347);
        _1573 = ((((saturate(_163 / _1530) + -1.0f) * 0.5f) + 1.0f) * _1349);
        _1574 = ((((saturate(_164 / _1530) + -1.0f) * 0.5f) + 1.0f) * _1351);
        _1575 = _1526;
      } else {
        if (_319) {
          if (cbSharedPerViewData.vSpecularOcclusionSettings.y > 0.0f) {
            _1564 = saturate(_1480);
            _1565 = _1564 * _1564;
            _1566 = _1565 * _1565;
            _1567 = _1566 * _1566;
            _1572 = _1347;
            _1573 = _1349;
            _1574 = _1351;
            _1575 = (((1.0f - _1567) * saturate((_1322 * _1322) + -0.30000001192092896f)) + _1567);
          } else {
            _1572 = _1347;
            _1573 = _1349;
            _1574 = _1351;
            _1575 = _1526;
          }
        } else {
          if (((_209 >= 0.0117647061124444f) && (_209 < 0.01568627543747425f)) && (cbSharedPerViewData.vSpecularOcclusionSettings.y > 0.0f)) {
            _1564 = saturate(_1480);
            _1565 = _1564 * _1564;
            _1566 = _1565 * _1565;
            _1567 = _1566 * _1566;
            _1572 = _1347;
            _1573 = _1349;
            _1574 = _1351;
            _1575 = (((1.0f - _1567) * saturate((_1322 * _1322) + -0.30000001192092896f)) + _1567);
          } else {
            _1572 = _1347;
            _1573 = _1349;
            _1574 = _1351;
            _1575 = _1526;
          }
        }
      }
      if (_326 && (_589 != 0)) {
        _1579 = rsqrt(dot(float3(_590, _591, _592), float3(_590, _591, _592)));
        _1581 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
        _1582 = _1581 * _196;
        _1583 = _1581 * _197;
        _1584 = _1581 * _198;
        if (_1514) {
          _1589 = max(_268, 0.10000000149011612f);
          _1590 = -0.0f - _601;
          _1591 = -0.0f - _602;
          _1592 = -0.0f - _600;
          _1594 = dot(float3(_1590, _1591, _1592), float3(_1582, _1583, _1584)) * 2.0f;
          _1603 = min(max(dot(float3((_1579 * _590), (_1579 * _591), (_1579 * _592)), float3((_1590 - (_1594 * _1582)), (_1591 - (_1594 * _1583)), (_1592 - (_1594 * _1584)))), -1.0f), 1.0f);
          _1604 = abs(_1603);
          _1609 = (1.5707963705062866f - (_1604 * 0.1565829962491989f)) * sqrt(1.0f - _1604);
          _1615 = abs((_1589 - _1480) * 3.1415927410125732f);
          _1623 = saturate(1.0f - saturate((select((_1603 >= 0.0f), _1609, (3.1415927410125732f - _1609)) - _1615) / (((_1589 + _1480) * 3.1415927410125732f) - _1615)));
          _1633 = (((_1623 * _1623) * saturate((_1480 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1623 * 2.0f)));
        } else {
          _1633 = _1480;
        }
      } else {
        _1633 = _1575;
      }
      _1634 = _1633 * _1572;
      _1635 = _1633 * _1573;
      _1636 = _1633 * _1574;
      [branch]
      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
        _1643 = _1480;
      } else {
        _1643 = 1.0f;
      }
      if (_617 > 0.0f) {
        _1646 = _611 * 3;
        _1649 = srvRoomInfo[_1646].x;
        _1650 = srvRoomInfo[_1646].y;
        _1651 = srvRoomInfo[_1646].z;
        _1657 = srvRoomInfo[(_1646 + 1)].x;
        _1658 = srvRoomInfo[(_1646 + 1)].y;
        _1659 = srvRoomInfo[(_1646 + 1)].z;
        _1665 = srvRoomInfo[(_1646 + 2)].x;
        _1666 = srvRoomInfo[(_1646 + 2)].y;
        _1667 = srvRoomInfo[(_1646 + 2)].z;
        _1673 = saturate(dot(float3(_196, _197, _198), float3(asfloat(_1649), asfloat(_1650), asfloat(_1651))) + 0.5f);
        _1677 = (_1673 * _1673) * (3.0f - (_1673 * 2.0f));
        _1681 = 1.0f - _1677;
        _1688 = _1643 * _617;
        _1696 = ((_1688 * ((_1681 * asfloat(_1665)) + (_1677 * asfloat(_1657)))) - _531);
        _1697 = ((_1688 * ((_1681 * asfloat(_1666)) + (_1677 * asfloat(_1658)))) - _533);
        _1698 = ((_1688 * ((_1681 * asfloat(_1667)) + (_1677 * asfloat(_1659)))) - _535);
      } else {
        _1696 = _532;
        _1697 = _534;
        _1698 = _536;
      }
      if (_620 > 0.0f) {
        _1701 = _613 * 3;
        _1704 = srvRoomInfo[_1701].x;
        _1705 = srvRoomInfo[_1701].y;
        _1706 = srvRoomInfo[_1701].z;
        _1712 = srvRoomInfo[(_1701 + 1)].x;
        _1713 = srvRoomInfo[(_1701 + 1)].y;
        _1714 = srvRoomInfo[(_1701 + 1)].z;
        _1720 = srvRoomInfo[(_1701 + 2)].x;
        _1721 = srvRoomInfo[(_1701 + 2)].y;
        _1722 = srvRoomInfo[(_1701 + 2)].z;
        _1728 = saturate(dot(float3(_196, _197, _198), float3(asfloat(_1704), asfloat(_1705), asfloat(_1706))) + 0.5f);
        _1732 = (_1728 * _1728) * (3.0f - (_1728 * 2.0f));
        _1736 = 1.0f - _1732;
        _1743 = _1643 * _620;
        _1751 = ((_1743 * ((_1736 * asfloat(_1720)) + (_1732 * asfloat(_1712)))) + _1696);
        _1752 = ((_1743 * ((_1736 * asfloat(_1721)) + (_1732 * asfloat(_1713)))) + _1697);
        _1753 = ((_1743 * ((_1736 * asfloat(_1722)) + (_1732 * asfloat(_1714)))) + _1698);
      } else {
        _1751 = _1696;
        _1752 = _1697;
        _1753 = _1698;
      }
      if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
        _1777 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _381, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _380, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _379))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
        _1781 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _381, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _380, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _379))) + (cbSharedPerViewData.mViewToWorld[1][0].w);
        _1785 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _381, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _380, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _379))) + (cbSharedPerViewData.mViewToWorld[2][0].w);
        _1804 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1785, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1781, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1777))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
        _1808 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1785, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1781, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1777))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
        _1812 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1785, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1781, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1777))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
        _1825 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
        _1826 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
        _1827 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
        _1864 = min(min(saturate((_1804 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1825), 9.999999747378752e-06f)), saturate((1.0f - _1804) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1825), 9.999999747378752e-06f))), min(min(saturate((_1808 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1826), 9.999999747378752e-06f)), saturate((1.0f - _1808) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1826), 9.999999747378752e-06f))), min(saturate((_1812 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1827), 9.999999747378752e-06f)), saturate((1.0f - _1812) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1827), 9.999999747378752e-06f)))));
      } else {
        _1864 = 0.0f;
      }
      _1865 = (uint)(_global_1) + (uint)(_global_0);
      if ((uint)_1865 < (uint)_global_2) {
        _1869 = _1751;
        _1870 = _1752;
        _1871 = _1753;
        _1872 = _1634;
        _1873 = _1635;
        _1874 = _1636;
        _1875 = _1865;
        while(true) {
          _14768 = _1869;
          _14769 = _1870;
          _14770 = _1871;
          _14771 = _1872;
          _14772 = _1873;
          _14773 = _1874;
          _1877 = _global_3[min((uint)(_1875), 63u)];
          _1881 = _global_4[min((uint)(_1875), 63u)];
          _1882 = _global_5[min((uint)(_1875), 63u)];
          _1883 = _global_6[min((uint)(_1875), 63u)];
          _1884 = _1877 & 4095;
          [branch]
          if ((((_204 & 64) != 0) || ((_1881 & 8388608) == 0)) && ((_332 != 0) || ((_1881 & 16777216) == 0))) {
            _1896 = (int)((int)(_1882 << (((int)(31u - _610)) & 31))) >> 31;
            _1900 = (int)((int)(_1882 << ((31 - _612) & 31))) >> 31;
            _1912 = saturate((asfloat((_1896 & asint(_617))) + asfloat((_1900 & asint(_620)))) + asfloat(((_1900 & 1065353216) & _1896)));
            [branch]
            if (!(_1912 == 0.0f)) {
              _1915 = (uint)(_1877) >> 12;
              if (_1915 == 6) {
                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                  _4636 = (_1912 * select(((_1881 & 67108864) != 0), 1.0f, (1.0f - _1864)));
                } else {
                  _4636 = _1912;
                }
                _4639 = asfloat(srvLightInfoProperties.Load4(_1883)).x;
                _4640 = asfloat(srvLightInfoProperties.Load4(_1883)).y;
                _4641 = asfloat(srvLightInfoProperties.Load4(_1883)).z;
                _4642 = asfloat(srvLightInfoProperties.Load4(_1883)).w;
                _4645 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).x;
                _4646 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).y;
                _4647 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).z;
                _4648 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).w;
                _4651 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).x;
                _4652 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).y;
                _4653 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).z;
                _4654 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).w;
                _4657 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).x;
                _4658 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).y;
                _4659 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).z;
                _4662 = asint(srvLightInfoProperties.Load(((int)(_1883 + 68u))));
                _4665 = asint(srvLightInfoProperties.Load(((int)(_1883 + 72u))));
                _4668 = asint(srvLightInfoProperties.Load(((int)(_1883 + 76u))));
                _4671 = asint(srvLightInfoProperties.Load(((int)(_1883 + 84u))));
                _4674 = asint(srvLightInfoProperties.Load(((int)(_1883 + 88u))));
                _4677 = asint(srvLightInfoProperties.Load(((int)(_1883 + 92u))));
                _4681 = ((float)((uint)((uint)(((uint)(_4662) >> 8) & 255)))) * 0.003921499941498041f;
                _4684 = ((float)((uint)((uint)(_4662 & 255)))) * 0.003921499941498041f;
                _4686 = f16tof32(((uint)((uint)(_4665) >> 16)));
                _4688 = (uint)(_4668) >> 16;
                _4702 = mad(_4641, _381, mad(_4640, _380, (_4639 * _379))) + _4642;
                _4706 = mad(_4647, _381, mad(_4646, _380, (_4645 * _379))) + _4648;
                _4712 = srvDeferredShadingPass_DeferredShadows.Load(int3(_70, _71, 0));
                _4717 = min((int)(cbSharedPerViewData.nNumCSMCascades), (int)(3));
                if (!(_4717 == 0)) {
                  _4721 = 0;
                  while(true) {
                    _4724 = srvLightInfoBase[_1884].nBufferOffset;
                    _4736 = asint(srvLightInfoProperties.Load(((int)(_4724 + 160u))));
                    _4739 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 164u)))).x;
                    _4740 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 164u)))).y;
                    _4741 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 164u)))).z;
                    _4744 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 176u)))).x;
                    _4745 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 176u)))).y;
                    _4746 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 176u)))).z;
                    [branch]
                    if (_4721 == 0) {
                      _4749 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 112u)))).z;
                      _4750 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 112u)))).y;
                      _4751 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 112u)))).x;
                      _4752 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 100u)))).z;
                      _4753 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 100u)))).y;
                      _4754 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 100u)))).x;
                      _4757 = asint(srvLightInfoProperties.Load(((int)(_4724 + 96u))));
                      _4772 = _4754;
                      _4773 = _4753;
                      _4774 = _4752;
                      _4775 = _4751;
                      _4776 = _4750;
                      _4777 = _4749;
                      _4778 = _4757;
                      if (!((uint)_4778 < (uint)65536)) {
                        if (!((((0.5f - abs(((_4772 * _4702) + -0.5f) + _4775)) >= 0.0f) && ((0.5f - abs(((_4773 * _4706) + -0.5f) + _4776)) >= 0.0f)) && ((0.5f - abs(((_4774 * (mad(_4653, _381, mad(_4652, _380, (_4651 * _379))) + _4654)) + -0.5f) + _4777)) >= 0.0f))) {
                          _4802 = _4721 + 1u;
                          if ((uint)_4802 < (uint)_4717) {
                            _4721 = _4802;
                            continue;
                          } else {
                            _4805 = true;
                          }
                        } else {
                          _4805 = false;
                        }
                      } else {
                        _4805 = true;
                      }
                    } else {
                      _4759 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 144u)))).z;
                      _4760 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 144u)))).y;
                      _4761 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 144u)))).x;
                      _4762 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 132u)))).z;
                      _4763 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 132u)))).y;
                      _4764 = asfloat(srvLightInfoProperties.Load3(((int)(_4724 + 132u)))).x;
                      _4767 = asint(srvLightInfoProperties.Load(((int)(_4724 + 128u))));
                      bool __branch_chain_4758;
                      if (_4721 == 1) {
                        _4772 = _4764;
                        _4773 = _4763;
                        _4774 = _4762;
                        _4775 = _4761;
                        _4776 = _4760;
                        _4777 = _4759;
                        _4778 = _4767;
                        __branch_chain_4758 = true;
                      } else {
                        if (_4721 == 2) {
                          _4772 = _4739;
                          _4773 = _4740;
                          _4774 = _4741;
                          _4775 = _4744;
                          _4776 = _4745;
                          _4777 = _4746;
                          _4778 = _4736;
                          __branch_chain_4758 = true;
                        } else {
                          _4805 = true;
                          __branch_chain_4758 = false;
                        }
                      }
                      if (__branch_chain_4758) {
                        if (!((uint)_4778 < (uint)65536)) {
                          if (!((((0.5f - abs(((_4772 * _4702) + -0.5f) + _4775)) >= 0.0f) && ((0.5f - abs(((_4773 * _4706) + -0.5f) + _4776)) >= 0.0f)) && ((0.5f - abs(((_4774 * (mad(_4653, _381, mad(_4652, _380, (_4651 * _379))) + _4654)) + -0.5f) + _4777)) >= 0.0f))) {
                            _4802 = _4721 + 1u;
                            if ((uint)_4802 < (uint)_4717) {
                              _4721 = _4802;
                              continue;
                            } else {
                              _4805 = true;
                            }
                          } else {
                            _4805 = false;
                          }
                        } else {
                          _4805 = true;
                        }
                      }
                    }
                    _4807 = _4805;
                    break;
                  }
                } else {
                  _4807 = true;
                }
                [branch]
                if (!(_4712.x == 0.0f)) {
                  [branch]
                  if (!(_4688 == 0)) {
                    Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _4688)))];
                    _4822 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2(((_4702 * f16tof32(((uint)((uint)(_4674) >> 16)))) + f16tof32(((uint)((uint)(_4677) >> 16)))), ((_4706 * f16tof32(_4674)) + f16tof32(_4677))), 0.0f);
                    _4830 = (_4822.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                    _4831 = (_4822.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                    _4832 = (_4822.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                  } else {
                    _4830 = cbSharedPerViewData.vAttenuatedSunColor.x;
                    _4831 = cbSharedPerViewData.vAttenuatedSunColor.y;
                    _4832 = cbSharedPerViewData.vAttenuatedSunColor.z;
                  }
                  if (((_384 == 3) || (!_383)) && (!(_221 || _4807))) {
                    _4843 = (_4712.x * _4636) * saturate(0.30000001192092896f - dot(float3(_4657, _4658, _4659), float3(_196, _197, _198)));
                    _4878 = (((_4830 * _1508) * _4843) + _1872);
                    _4879 = (((_4831 * _1509) * _4843) + _1873);
                    _4880 = (((_4832 * _1510) * _4843) + _1874);
                  } else {
                    if (!_326) {
                      _4861 = saturate(-0.0f - dot(float3(_601, _602, _600), float3(_4657, _4658, _4659)));
                      _4864 = 1.0f - ((_4861 * _4861) * 0.6399999856948853f);
                      _4870 = ((0.36000001430511475f / (_4864 * _4864)) * _4636) * saturate(0.30000001192092896f - dot(float3(_196, _197, _198), float3(_4657, _4658, _4659)));
                      _4878 = (((_333 * _258) * _4870) + _1872);
                      _4879 = (((_334 * _258) * _4870) + _1873);
                      _4880 = (((_335 * _258) * _4870) + _1874);
                    } else {
                      _4878 = _1872;
                      _4879 = _1873;
                      _4880 = _1874;
                    }
                  }
                  _4883 = min(_4712.x, _4712.y) * _4636;
                  [branch]
                  if (_4883 > 0.0f) {
                    _4886 = dot(float3(_4657, _4658, _4659), float3(_4657, _4658, _4659));
                    _4887 = rsqrt(_4886);
                    _4888 = _4887 * _4657;
                    _4889 = _4887 * _4658;
                    _4890 = _4887 * _4659;
                    _4891 = dot(float3(_196, _197, _198), float3(_4888, _4889, _4890));
                    if (_4686 > 0.0f) {
                      _4899 = sqrt(saturate((_4686 * _4686) * (1.0f / (_4886 + 1.0f))));
                      if (_4891 < _4899) {
                        _4904 = max(_4891, (-0.0f - _4899)) + _4899;
                        _4909 = ((_4904 * _4904) / (_4899 * 4.0f));
                      } else {
                        _4909 = _4891;
                      }
                    } else {
                      _4909 = _4891;
                    }
                    _4910 = _268 * _268;
                    _4911 = 1.0f - _4910;
                    _4914 = saturate((_4686 * _4911) * _4887);
                    _4916 = saturate(_4887 * f16tof32(_4665));
                    if (_319) {
                      _4918 = saturate(_4891);
                      _4925 = (_4918 * (_196 - _359)) + _359;
                      _4926 = (_4918 * (_197 - _360)) + _360;
                      _4927 = (_4918 * (_198 - _361)) + _361;
                      _4929 = rsqrt(dot(float3(_4925, _4926, _4927), float3(_4925, _4926, _4927)));
                      _4934 = (_4925 * _4929);
                      _4935 = (_4926 * _4929);
                      _4936 = (_4927 * _4929);
                    } else {
                      _4934 = _196;
                      _4935 = _197;
                      _4936 = _198;
                    }
                    _4937 = dot(float3(_4934, _4935, _4936), float3(_4888, _4889, _4890));
                    _4938 = dot(float3(_4934, _4935, _4936), float3(_601, _602, _600));
                    _4939 = dot(float3(_601, _602, _600), float3(_4888, _4889, _4890));
                    _4942 = rsqrt((_4939 * 2.0f) + 2.0f);
                    _4945 = saturate(_4942 * (_4938 + _4937));
                    _4948 = saturate((_4942 * _4939) + _4942);
                    _4949 = (_4914 > 0.0f);
                    if (_4949) {
                      _4953 = sqrt(1.0f - (_4914 * _4914));
                      _4955 = (_4937 * 2.0f) * _4938;
                      _4956 = _4955 - _4939;
                      if (!(_4956 >= _4953)) {
                        _4964 = rsqrt(1.0f - (_4956 * _4956)) * _4914;
                        _4967 = _4964 * (_4938 - (_4956 * _4937));
                        _4968 = _4938 * _4938;
                        _4973 = _4964 * (((_4968 * 2.0f) + -1.0f) - (_4956 * _4939));
                        _4982 = sqrt(saturate((((1.0f - (_4937 * _4937)) - _4968) - (_4939 * _4939)) + (_4955 * _4939)));
                        _4983 = _4982 * _4964;
                        _4986 = ((_4938 * 2.0f) * _4964) * _4982;
                        _4988 = (_4953 * _4937) + _4938;
                        _4989 = _4988 + _4967;
                        _4990 = _4953 * _4939;
                        _4992 = (_4990 + 1.0f) + _4973;
                        _4993 = _4983 * _4992;
                        _4994 = _4989 * _4992;
                        _4995 = _4986 * _4989;
                        _5000 = (((_4989 * 0.25f) * _4986) - (_4993 * 0.5f)) * _4994;
                        _5014 = (((_4995 - (_4993 * 2.0f)) * _4995) + (_4993 * _4993)) + ((((-0.5f - ((_4992 + _4990) * 0.5f)) * _4994) + ((_4992 * _4992) * _4988)) * _4989);
                        _5019 = (_5000 * 2.0f) / ((_5014 * _5014) + (_5000 * _5000));
                        _5020 = _5014 * _5019;
                        _5022 = 1.0f - (_5000 * _5019);
                        _5028 = ((_5020 * _4986) + _4990) + (_5022 * _4973);
                        _5031 = rsqrt((_5028 * 2.0f) + 2.0f);
                        _5040 = saturate((_5028 * _5031) + _5031);
                        _5041 = saturate(((_4988 + (_5020 * _4983)) + (_5022 * _4967)) * _5031);
                      } else {
                        _5040 = abs(_4938);
                        _5041 = 1.0f;
                      }
                    } else {
                      _5040 = _4948;
                      _5041 = _4945;
                    }
                    _5042 = saturate(_4938);
                    _5043 = saturate(_4909);
                    _5044 = saturate(_4937);
                    _5045 = _4910 * _4910;
                    _5046 = (_4916 > 0.0f);
                    if (_5046) {
                      _5055 = saturate(((_4916 * _4916) / ((_5040 * 3.5999999046325684f) + 0.4000000059604645f)) + _5045);
                    } else {
                      _5055 = _5045;
                    }
                    _5056 = sqrt(_5055);
                    if (_4949) {
                      _5067 = (_5055 / ((((_4914 * 0.25f) * ((_5056 * 3.0f) + _4914)) / (_5040 + 0.0010000000474974513f)) + _5055));
                    } else {
                      _5067 = 1.0f;
                    }
                    _5071 = (((_5055 * _5041) - _5041) * _5041) + 1.0f;
                    _5074 = (_5055 / (_5071 * _5071)) * _5067;
                    _5075 = 1.0f - _251;
                    _5076 = 1.0f - _252;
                    _5077 = 1.0f - _253;
                    _5078 = saturate(_5040);
                    _5079 = 1.0f - _5078;
                    _5080 = log2(_5079);
                    _5082 = exp2(_5080 * 5.0f);
                    _5086 = (_5082 * _5075) + _251;
                    _5087 = (_5082 * _5076) + _252;
                    _5088 = (_5082 * _5077) + _253;
                    _5089 = abs(_4938);
                    _5091 = saturate(_5089 + 9.999999747378752e-06f);
                    _5092 = 1.0f - _5056;
                    _5100 = 0.5f / ((((_5092 * _5091) + _5056) * _5043) + (((_5092 * _5043) + _5056) * _5091));
                    if (_212) {
                      _5110 = ((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                      _5111 = ((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                      _5112 = ((_164 + -0.5f) * 0.5f) + 0.5f;
                      _5129 = ((dot(float3((-0.0f - _4934), (-0.0f - _4935), (-0.0f - _4936)), float3(_4888, _4889, _4890)) + dot(float3((-0.0f - _601), (-0.0f - _602), (-0.0f - _600)), float3(_4888, _4889, _4890))) * 0.5f) * exp2(log2(1.0f - _5042) * (11.0f - (((float)((uint)((uint)((uint)(_310) >> 2)))) * 0.1666666716337204f)));
                      _5138 = saturate((_1481 + -0.009999999776482582f) * -100.0f);
                      _5143 = ((_5138 * _5138) * 3.0f) * (3.0f - (_5138 * 2.0f));
                      _5150 = 10.0f - (exp2(log2(saturate(_1481 * 5.0f)) * 3.0f) * 9.0f);
                      _5151 = saturate(_5044 + _5110) * _5044;
                      _5152 = saturate(_5044 + _5111) * _5044;
                      _5153 = saturate(_5044 + _5112) * _5044;
                      _5172 = (max(((_5143 + _5110) * _5129), 0.0f) * _5150) + sqrt(_5151 * _5151);
                      _5173 = (max(((_5143 + _5111) * _5129), 0.0f) * _5150) + sqrt(_5152 * _5152);
                      _5174 = (max(((_5143 + _5112) * _5129), 0.0f) * _5150) + sqrt(_5153 * _5153);
                      _5175 = _4888 + _601;
                      _5176 = _4889 + _602;
                      _5177 = _4890 + _600;
                      _5179 = rsqrt(dot(float3(_5175, _5176, _5177), float3(_5175, _5176, _5177)));
                      if (!(select((_309 != 0), 1.0f, 0.0f) < 1.0f)) {
                        _5193 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                        _5194 = _5193 * _196;
                        _5195 = _5193 * _197;
                        _5196 = _5193 * _198;
                        _5199 = (abs(_5194) < abs(_5195));
                        _5200 = select(_5199, 1.0f, 0.0f);
                        _5201 = select(_5199, 0.0f, 1.0f);
                        _5202 = _5201 * _5196;
                        _5204 = -0.0f - (_5196 * _5200);
                        _5207 = (_5200 * _5195) - (_5201 * _5194);
                        _5209 = rsqrt(dot(float3(_5202, _5204, _5207), float3(_5202, _5204, _5207)));
                        _5210 = _5202 * _5209;
                        _5211 = _5209 * _5204;
                        _5212 = _5207 * _5209;
                        _5215 = (_5211 * _5196) - (_5212 * _5195);
                        _5218 = (_5212 * _5194) - (_5210 * _5196);
                        _5221 = (_5210 * _5195) - (_5211 * _5194);
                        _5223 = rsqrt(dot(float3(_5215, _5218, _5221), float3(_5215, _5218, _5221)));
                        _5235 = saturate(abs(_308 + -2.5f) + -0.5f) + -0.5f;
                        _5236 = saturate(1.5f - abs(_308 + -1.5f)) + -0.5f;
                        _5238 = rsqrt(dot(float2(_5235, _5236), float2(_5235, _5236)));
                        _5239 = _5238 * _5235;
                        _5240 = _5238 * _5236;
                        _5247 = ((_5215 * _5223) * _5239) + (_5240 * _5210);
                        _5248 = ((_5218 * _5223) * _5239) + (_5240 * _5211);
                        _5249 = ((_5221 * _5223) * _5239) + (_5240 * _5212);
                        _5252 = min(max(dot(float3(_5247, _5248, _5249), float3(_4888, _4889, _4890)), -1.0f), 1.0f);
                        _5255 = min(max(dot(float3(_5247, _5248, _5249), float3(_601, _602, _600)), -1.0f), 1.0f);
                        _5256 = abs(_5255);
                        _5261 = (1.5707963705062866f - (_5256 * 0.1565829962491989f)) * sqrt(1.0f - _5256);
                        _5265 = abs(_5252);
                        _5270 = (1.5707963705062866f - (_5265 * 0.1565829962491989f)) * sqrt(1.0f - _5265);
                        _5277 = cos(abs(select((_5252 >= 0.0f), _5270, (3.1415927410125732f - _5270)) - select((_5255 >= 0.0f), _5261, (3.1415927410125732f - _5261))) * 0.5f);
                        _5281 = _4888 - (_5252 * _5247);
                        _5282 = _4889 - (_5252 * _5248);
                        _5283 = _4890 - (_5252 * _5249);
                        _5287 = _601 - (_5255 * _5247);
                        _5288 = _602 - (_5255 * _5248);
                        _5289 = _600 - (_5255 * _5249);
                        _5296 = rsqrt((dot(float3(_5287, _5288, _5289), float3(_5287, _5288, _5289)) * dot(float3(_5281, _5282, _5283), float3(_5281, _5282, _5283))) + 9.999999747378752e-05f) * dot(float3(_5281, _5282, _5283), float3(_5287, _5288, _5289));
                        _5300 = sqrt(saturate((_5296 * 0.5f) + 0.5f));
                        _5304 = _4910 * 0.5f;
                        _5305 = _4910 * 2.0f;
                        _5308 = select((((_310 & 1) != 0) && (select(((_310 & 2) != 0), 1.0f, 0.0f) == 0.0f)), 0.0f, 1.0f);
                        _5311 = saturate((_4891 + 0.5f) * 0.6666666865348816f);
                        _5321 = (_5255 + _5252) + ((((_5300 * 0.9975510239601135f) * sqrt(1.0f - (_5255 * _5255))) - (_5255 * 0.06994284689426422f)) * 0.13988569378852844f);
                        _5323 = (_4910 * 1.4142135381698608f) * _5300;
                        _5336 = 1.0f - sqrt(saturate((_4939 * 0.5f) + 0.5f));
                        _5337 = _5336 * _5336;
                        _5343 = saturate(-0.0f - _4939);
                        _5346 = (1.0f - saturate(_5343)) * _5311;
                        _5355 = ((((_5300 * 0.5f) * (exp2((((_5321 * _5321) * -0.5f) / (_5323 * _5323)) * 1.4426950216293335f) / (_5323 * 2.5066282749176025f))) * min(_255, 0.5f)) * (((_5337 * _5337) * (_5336 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_5346, 1.0f, _5308));
                        _5357 = (_5252 + -0.03500000014901161f) + _5255;
                        _5366 = 1.0f / ((1.190000057220459f / _5277) + (_5277 * 0.36000001430511475f));
                        _5371 = ((_5366 * (0.6000000238418579f - (_5296 * 0.800000011920929f))) + 1.0f) * _5300;
                        _5377 = 1.0f - (sqrt(saturate(1.0f - (_5371 * _5371))) * _5277);
                        _5378 = _5377 * _5377;
                        _5382 = 0.9534794092178345f - ((_5378 * _5378) * (_5377 * 0.9534794092178345f));
                        _5383 = _5371 * _5366;
                        _5388 = (sqrt(1.0f - (_5383 * _5383)) * 0.5f) / _5277;
                        _5407 = 1.0f - saturate((_5343 + -0.44999998807907104f) * 2.222222328186035f);
                        _5410 = ((1.0f - _5311) * _5308) + _5311;
                        _5413 = ((_5382 * _5382) * (exp2((((_5357 * _5357) * -0.5f) / (_5304 * _5304)) * 1.4426950216293335f) / (_4910 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_5296 * 5.2658371925354f));
                        _5427 = (_5252 + -0.14000000059604645f) + _5255;
                        _5437 = 1.0f - (_5277 * 0.5f);
                        _5438 = _5437 * _5437;
                        _5442 = (_5438 * _5438) * (0.9534794092178345f - (_5277 * 0.47673970460891724f));
                        _5444 = 0.9534794092178345f - _5442;
                        _5446 = (_5444 * _5444) * (_5442 + 0.04652056470513344f);
                        _5449 = exp2((_5296 * 24.525815963745117f) + -24.208423614501953f);
                        _5462 = ((exp2((((_5427 * _5427) * -0.5f) / (_5305 * _5305)) * 1.4426950216293335f) / (_4910 * 5.013256549835205f)) * (lerp(_5446, 1.0f, _220))) * (((exp2((saturate(dot(float3((_5179 * _5175), (_5179 * _5176), (_5179 * _5177)), float3(_196, _197, _198))) * 17.312339782714844f) + -14.109557151794434f) - _5449) * _220) + _5449);
                        _6174 = (((((exp2(log2(max(_162, 0.0f)) * _5388) * _5410) * _5413) * _5407) + _5355) + (_5462 * _162));
                        _6175 = (((((exp2(log2(max(_163, 0.0f)) * _5388) * _5410) * _5413) * _5407) + _5355) + (_5462 * _163));
                        _6176 = (((((exp2(log2(max(_164, 0.0f)) * _5388) * _5410) * _5413) * _5407) + _5355) + (_5462 * _164));
                        _6177 = _5172;
                        _6178 = _5173;
                        _6179 = _5174;
                      } else {
                        _6174 = 0.0f;
                        _6175 = 0.0f;
                        _6176 = 0.0f;
                        _6177 = _5172;
                        _6178 = _5173;
                        _6179 = _5174;
                      }
                    } else {
                      if (_319) {
                        _5480 = ((float)((uint)((uint)(_312 & 15)))) * 0.06666667014360428f;
                        _5481 = _268 * 0.0317460335791111f;
                        _5484 = min(1.0f, max((_5481 * ((float)((uint)((uint)((uint)(_311) >> 2))))), 0.019999999552965164f));
                        _5487 = min(1.0f, max((_5481 * ((float)((uint)((uint)((((int)(_311 << 4)) & 48) | ((uint)(_312) >> 4)))))), 0.019999999552965164f));
                        _5490 = ((_5487 - _5484) * _5480) + _5484;
                        _5491 = _5490 * _5490;
                        _5495 = saturate(abs(_5042) + 9.999999747378752e-06f);
                        _5496 = sqrt(_5491 * _5491);
                        _5497 = 1.0f - _5496;
                        _5506 = _5484 * _5484;
                        _5507 = _5506 * _5506;
                        if (_5046) {
                          _5516 = saturate(((_4916 * _4916) / ((_5040 * 3.5999999046325684f) + 0.4000000059604645f)) + _5507);
                        } else {
                          _5516 = _5507;
                        }
                        if (_4949) {
                          _5528 = (_5516 / ((((_4914 * 0.25f) * ((sqrt(_5516) * 3.0f) + _4914)) / (_5040 + 0.0010000000474974513f)) + _5516));
                        } else {
                          _5528 = 1.0f;
                        }
                        _5529 = _5487 * _5487;
                        _5530 = _5529 * _5529;
                        if (_5046) {
                          _5539 = saturate(((_4916 * _4916) / ((_5040 * 3.5999999046325684f) + 0.4000000059604645f)) + _5530);
                        } else {
                          _5539 = _5530;
                        }
                        if (_4949) {
                          _5551 = (_5539 / ((((_4914 * 0.25f) * ((sqrt(_5539) * 3.0f) + _4914)) / (_5040 + 0.0010000000474974513f)) + _5539));
                        } else {
                          _5551 = 1.0f;
                        }
                        _5555 = (((_5516 * _5041) - _5041) * _5041) + 1.0f;
                        _5558 = (_5516 / (_5555 * _5555)) * _5528;
                        _5562 = (((_5539 * _5041) - _5041) * _5041) + 1.0f;
                        _5569 = saturate(_5041);
                        _5573 = saturate((_4937 + _4684) / (_4684 + 1.0f));
                        _5578 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_313)))) + 1u))]);
                        _5585 = ((float)((uint)((uint)((uint)((uint)(_5578.x)) >> 24)))) * 0.25f;
                        _5588 = ((float)((uint)((uint)(_5578.x & 255)))) * 0.003921568859368563f;
                        _5592 = ((float)((uint)((uint)(((uint)((uint)(_5578.x)) >> 8) & 255)))) * 0.003921568859368563f;
                        _5596 = ((float)((uint)((uint)(((uint)((uint)(_5578.x)) >> 16) & 255)))) * 0.003921568859368563f;
                        _5605 = ((float)((uint)((uint)((uint)((uint)(_5578.y)) >> 24)))) * 0.25f;
                        _5608 = ((float)((uint)((uint)(_5578.y & 255)))) * 0.003921568859368563f;
                        _5612 = ((float)((uint)((uint)(((uint)((uint)(_5578.y)) >> 8) & 255)))) * 0.003921568859368563f;
                        _5616 = ((float)((uint)((uint)(((uint)((uint)(_5578.y)) >> 16) & 255)))) * 0.003921568859368563f;
                        _5624 = (float)((uint)((uint)(_5578.w & 31)));
                        _5630 = (float)((uint)((uint)(((uint)((uint)(_5578.w)) >> 10) & 31)));
                        _5640 = (float)((uint)((uint)(((uint)((uint)(_5578.w)) >> 25) & 31)));
                        _5643 = ((float)((uint)((uint)(_5578.z & 255)))) * 0.003921568859368563f;
                        _5647 = ((float)((uint)((uint)(((uint)((uint)(_5578.z)) >> 8) & 255)))) * 0.003921568859368563f;
                        _5651 = ((float)((uint)((uint)(((uint)((uint)(_5578.z)) >> 16) & 255)))) * 0.003921568859368563f;
                        _5658 = (((float)((uint)((uint)((uint)((uint)(_5578.z)) >> 24)))) * 0.003921568859368563f) * select(((_5578.w & 1073741824) != 0), -1.0f, 1.0f);
                        _5672 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_5578.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _5078)));
                        _5673 = ((2.0f - (_5624 * 0.06451612710952759f)) > 0.0f);
                        if (_5673) {
                          _5684 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _5569))) * (10.0f - (_5624 * 0.32258063554763794f))) * _5672);
                        } else {
                          _5684 = _5672;
                        }
                        _5695 = exp2(log2(max(9.999999747378752e-06f, _5569)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_5578.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                        _5696 = ((2.0f - (_5630 * 0.06451612710952759f)) > 0.0f);
                        if (_5696) {
                          _5706 = (exp2(log2(max(9.999999747378752e-06f, _5079)) * (10.0f - (_5630 * 0.32258063554763794f))) * _5695);
                        } else {
                          _5706 = _5695;
                        }
                        if (_5673) {
                          _5720 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _5569))) * (10.0f - (_5624 * 0.32258063554763794f))) * _5672);
                        } else {
                          _5720 = _5672;
                        }
                        if (_5696) {
                          _5733 = (exp2(log2(max(9.999999747378752e-06f, _5079)) * (10.0f - (_5630 * 0.32258063554763794f))) * _5695);
                        } else {
                          _5733 = _5695;
                        }
                        if (_5673) {
                          _5747 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _5569))) * (10.0f - (_5624 * 0.32258063554763794f))) * _5672);
                        } else {
                          _5747 = _5672;
                        }
                        if (_5696) {
                          _5760 = (exp2(log2(max(9.999999747378752e-06f, _5079)) * (10.0f - (_5630 * 0.32258063554763794f))) * _5695);
                        } else {
                          _5760 = _5695;
                        }
                        _5772 = (1.0f - exp2(log2(1.0f - _5569) * 3.0f)) * (1.0f - exp2(_5080 * 3.0f));
                        _5776 = saturate(_5573 / (_5772 * (((float)((uint)((uint)(((uint)((uint)(_5578.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                        _5781 = ((_5776 * _5776) * (3.0f - (_5776 * 2.0f))) + -1.0f;
                        _5783 = ((((_5643 * _5643) * _5658) * _5772) * _5781) + 1.0f;
                        _5786 = ((((_5647 * _5647) * _5658) * _5772) * _5781) + 1.0f;
                        _5789 = ((((_5651 * _5651) * _5658) * _5772) * _5781) + 1.0f;
                        _5791 = saturate(_5640 * 0.06451612710952759f);
                        _5798 = exp2(log2(1.0f - _5040) * (10.0f - (_5640 * 0.32258063554763794f)));
                        _5817 = ((((((_5539 / (_5562 * _5562)) * _5551) - _5558) * _5480) + _5558) * (0.5f / ((((_5497 * _5495) + _5496) * _5043) + (((_5497 * _5043) + _5496) * _5495)))) * _5043;
                        _6174 = ((_5817 * _5783) * (((_5791 * _5075) * _5798) + _251));
                        _6175 = ((_5817 * _5786) * (((_5791 * _5076) * _5798) + _252));
                        _6176 = ((_5817 * _5789) * (((_5791 * _5077) * _5798) + _253));
                        _6177 = (((((_5684 * (((_5588 * _5588) * _5585) + -1.0f)) + 1.0f) * _5573) * ((_5706 * (((_5608 * _5608) * _5605) + -1.0f)) + 1.0f)) * _5783);
                        _6178 = (((((_5720 * (((_5592 * _5592) * _5585) + -1.0f)) + 1.0f) * _5573) * ((_5733 * (((_5612 * _5612) * _5605) + -1.0f)) + 1.0f)) * _5786);
                        _6179 = (((((_5747 * (((_5596 * _5596) * _5585) + -1.0f)) + 1.0f) * _5573) * ((_5760 * (((_5616 * _5616) * _5605) + -1.0f)) + 1.0f)) * _5789);
                      } else {
                        if (_241) {
                          if (_256 < 0.007874015718698502f) {
                            _5831 = _5041 * _5041;
                            _5833 = max((1.0f - _5831), 9.999999747378752e-05f);
                            _5971 = (((((((exp2(((-0.0f - (_5831 / _5833)) / _5055) * 1.4426950216293335f) * 4.0f) / (_5833 * _5833)) + 1.0f) * (1.0f / ((_5055 * 4.0f) + 1.0f))) - _5074) * _257) + _5074);
                            _5972 = (((saturate(0.25f / ((_5044 + _5042) - (_5044 * _5042))) - _5100) * _257) + _5100);
                          } else {
                            _5857 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                            _5858 = _5857 * _196;
                            _5859 = _5857 * _197;
                            _5860 = _5857 * _198;
                            _5863 = (abs(_5858) < abs(_5859));
                            _5864 = select(_5863, 1.0f, 0.0f);
                            _5865 = select(_5863, 0.0f, 1.0f);
                            _5866 = _5865 * _5860;
                            _5868 = -0.0f - (_5860 * _5864);
                            _5871 = (_5864 * _5859) - (_5865 * _5858);
                            _5873 = rsqrt(dot(float3(_5866, _5868, _5871), float3(_5866, _5868, _5871)));
                            _5874 = _5866 * _5873;
                            _5875 = _5873 * _5868;
                            _5876 = _5871 * _5873;
                            _5879 = (_5875 * _5860) - (_5876 * _5859);
                            _5882 = (_5876 * _5858) - (_5874 * _5860);
                            _5885 = (_5874 * _5859) - (_5875 * _5858);
                            _5887 = rsqrt(dot(float3(_5879, _5882, _5885), float3(_5879, _5882, _5885)));
                            _5891 = _257 * 4.0f;
                            _5900 = saturate(abs(_5891 + -2.5f) + -0.5f) + -0.5f;
                            _5901 = saturate(1.5f - abs(_5891 + -1.5f)) + -0.5f;
                            _5903 = rsqrt(dot(float2(_5900, _5901), float2(_5900, _5901)));
                            _5904 = _5903 * _5900;
                            _5905 = _5903 * _5901;
                            _5912 = ((_5879 * _5887) * _5904) + (_5905 * _5874);
                            _5913 = ((_5882 * _5887) * _5904) + (_5905 * _5875);
                            _5914 = ((_5885 * _5887) * _5904) + (_5905 * _5876);
                            _5917 = (_5913 * _198) - (_5914 * _197);
                            _5920 = (_5914 * _196) - (_5912 * _198);
                            _5923 = (_5912 * _197) - (_5913 * _196);
                            _5924 = dot(float3(_5912, _5913, _5914), float3(_4888, _4889, _4890));
                            _5925 = dot(float3(_5912, _5913, _5914), float3(_601, _602, _600));
                            _5928 = dot(float3(_5917, _5920, _5923), float3(_4888, _4889, _4890));
                            _5929 = dot(float3(_5917, _5920, _5923), float3(_601, _602, _600));
                            _5935 = min(max((_4910 * (_256 + 1.0f)), 0.0010000000474974513f), 1.0f);
                            _5939 = min(max((_4910 * (1.0f - _256)), 0.0010000000474974513f), 1.0f);
                            _5940 = _5939 * _5935;
                            _5941 = ((_5925 + _5924) * _4942) * _5939;
                            _5942 = ((_5929 + _5928) * _4942) * _5935;
                            _5943 = _5940 * _4945;
                            _5944 = dot(float3(_5941, _5942, _5943), float3(_5941, _5942, _5943));
                            _5949 = _5935 * _5925;
                            _5950 = _5939 * _5929;
                            _5958 = _5935 * _5924;
                            _5959 = _5939 * _5928;
                            _5971 = (((_5940 * _5940) * _5940) / (_5944 * _5944));
                            _5972 = saturate(0.5f / ((sqrt(((_5958 * _5958) + (_5044 * _5044)) + (_5959 * _5959)) * _5091) + (sqrt(((_5950 * _5950) + (_5949 * _5949)) + (_5091 * _5091)) * _5044)));
                          }
                          _5974 = (_5971 * _5044) * _5972;
                          _5992 = saturate((_4937 + 0.5f) * 0.6666666865348816f);
                          _6174 = (_5974 * _5086);
                          _6175 = (_5974 * _5087);
                          _6176 = (_5974 * _5088);
                          _6177 = ((_5992 * (1.0f - _5086)) * saturate((((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _5044));
                          _6178 = ((_5992 * (1.0f - _5087)) * saturate((((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _5044));
                          _6179 = ((_5992 * (1.0f - _5088)) * saturate((((_164 + -0.5f) * 0.5f) + 0.5f) + _5044));
                        } else {
                          if (_263) {
                            _6007 = _315 * _315;
                            _6008 = _6007 * _6007;
                            _6014 = saturate(select((_4911 > 0.0f), ((1.0f - _6007) / _4911), 0.0f) * _4914);
                            _6015 = (_6014 > 0.0f);
                            if (_6015) {
                              _6019 = sqrt(1.0f - (_6014 * _6014));
                              _6021 = (_4937 * 2.0f) * _4938;
                              _6022 = _6021 - _4939;
                              if (!(_6022 >= _6019)) {
                                _6028 = rsqrt(1.0f - (_6022 * _6022)) * _6014;
                                _6031 = _6028 * (_4938 - (_6022 * _4937));
                                _6032 = _4938 * _4938;
                                _6037 = _6028 * (((_6032 * 2.0f) + -1.0f) - (_6022 * _4939));
                                _6046 = sqrt(saturate((((1.0f - (_4937 * _4937)) - _6032) - (_4939 * _4939)) + (_6021 * _4939)));
                                _6047 = _6046 * _6028;
                                _6050 = ((_4938 * 2.0f) * _6028) * _6046;
                                _6052 = (_6019 * _4937) + _4938;
                                _6053 = _6052 + _6031;
                                _6054 = _6019 * _4939;
                                _6056 = (_6054 + 1.0f) + _6037;
                                _6057 = _6047 * _6056;
                                _6058 = _6053 * _6056;
                                _6059 = _6050 * _6053;
                                _6064 = (((_6053 * 0.25f) * _6050) - (_6057 * 0.5f)) * _6058;
                                _6078 = (((_6059 - (_6057 * 2.0f)) * _6059) + (_6057 * _6057)) + ((((-0.5f - ((_6056 + _6054) * 0.5f)) * _6058) + ((_6056 * _6056) * _6052)) * _6053);
                                _6083 = (_6064 * 2.0f) / ((_6078 * _6078) + (_6064 * _6064));
                                _6084 = _6078 * _6083;
                                _6086 = 1.0f - (_6064 * _6083);
                                _6092 = ((_6084 * _6050) + _6054) + (_6086 * _6037);
                                _6095 = rsqrt((_6092 * 2.0f) + 2.0f);
                                _6104 = saturate(((_6052 + (_6084 * _6047)) + (_6086 * _6031)) * _6095);
                                _6105 = saturate((_6092 * _6095) + _6095);
                              } else {
                                _6104 = 1.0f;
                                _6105 = _5089;
                              }
                            } else {
                              _6104 = _4945;
                              _6105 = _4948;
                            }
                            if (_5046) {
                              _6114 = saturate(((_4916 * _4916) / ((_6105 * 3.5999999046325684f) + 0.4000000059604645f)) + _6008);
                            } else {
                              _6114 = _6008;
                            }
                            _6115 = sqrt(_6114);
                            if (_6015) {
                              _6126 = (_6114 / ((((_6014 * 0.25f) * ((_6115 * 3.0f) + _6014)) / (_6105 + 0.0010000000474974513f)) + _6114));
                            } else {
                              _6126 = 1.0f;
                            }
                            _6130 = (((_6114 * _6104) - _6104) * _6104) + 1.0f;
                            _6140 = 1.0f - _6115;
                            _6155 = ((((exp2(log2(1.0f - saturate(_6105)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _314) * (((_6126 * _5043) * (_6114 / (_6130 * _6130))) * (0.5f / ((((_6140 * _5091) + _6115) * _5043) + (((_6140 * _5043) + _6115) * _5091)))));
                            _6156 = false;
                          } else {
                            _6155 = 0.0f;
                            _6156 = true;
                          }
                          _6160 = saturate((_4937 + _4684) / (_4684 + 1.0f));
                          _6162 = (_5074 * _5043) * _5100;
                          _6166 = _6155 + (_6162 * _5086);
                          _6167 = _6155 + (_6162 * _5087);
                          _6168 = _6155 + (_6162 * _5088);
                          [branch]
                          if (_6156) {
                            _6174 = (_6166 * _1337);
                            _6175 = (_6167 * _1338);
                            _6176 = (_6168 * _1339);
                            _6177 = _6160;
                            _6178 = _6160;
                            _6179 = _6160;
                          } else {
                            _6174 = _6166;
                            _6175 = _6167;
                            _6176 = _6168;
                            _6177 = _6160;
                            _6178 = _6160;
                            _6179 = _6160;
                          }
                        }
                      }
                    }
                    [branch]
                    if (!((_4671 & 1) == 0)) {
                      _6192 = max(max(_4830, _4831), _4832);
                      if (_6192 > 0.0f) {
                        _6202 = saturate(_4830 / _6192);
                        _6203 = saturate(_4831 / _6192);
                        _6204 = saturate(_4832 / _6192);
                      } else {
                        _6202 = _4830;
                        _6203 = _4831;
                        _6204 = _4832;
                      }
                      _6205 = (_6203 < _6204);
                      _6206 = select(_6205, _6204, _6203);
                      _6207 = select(_6205, _6203, _6204);
                      _6208 = select(_6205, -1.0f, 0.0f);
                      _6209 = (_6202 < _6206);
                      _6211 = select(_6209, _6206, _6202);
                      _6212 = select(_6209, _6202, _6206);
                      _6216 = _6211 - select((_6212 < _6207), _6212, _6207);
                      _6222 = abs(select(_6209, (-0.3333333432674408f - _6208), _6208) + ((_6212 - _6207) / ((_6216 * 6.0f) + 9.999999682655225e-21f)));
                      if (_6222 < 0.6666666865348816f) {
                        _6235 = ((saturate(((float)((uint)((uint)(((uint)(_4671) >> 9) & 255)))) * 0.003921499941498041f) * (select((_6222 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _6222)) + _6222);
                      } else {
                        _6235 = _6222;
                      }
                      _6236 = saturate((_6216 / (_6211 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_4671) >> 1) & 255)))) * 0.003921499941498041f));
                      _6237 = saturate(_6211);
                      if (!(_6236 <= 0.0f)) {
                        _6240 = saturate(_6235);
                        _6244 = select(((_6240 * 360.0f) >= 360.0f), 0.0f, (_6240 * 6.0f));
                        _6245 = int(_6244);
                        _6247 = _6244 - float((int)(_6245));
                        _6249 = _6237 * (1.0f - _6236);
                        _6252 = (1.0f - (_6247 * _6236)) * _6237;
                        _6256 = (1.0f - ((1.0f - _6247) * _6236)) * _6237;
                        switch (_6245) {
                          case 0: {
                            _6264 = _6237;
                            _6265 = _6256;
                            _6266 = _6249;
                            break;
                          }
                          case 1: {
                            _6264 = _6252;
                            _6265 = _6237;
                            _6266 = _6249;
                            break;
                          }
                          case 2: {
                            _6264 = _6249;
                            _6265 = _6237;
                            _6266 = _6256;
                            break;
                          }
                          case 3: {
                            _6264 = _6249;
                            _6265 = _6252;
                            _6266 = _6237;
                            break;
                          }
                          case 4: {
                            _6264 = _6256;
                            _6265 = _6249;
                            _6266 = _6237;
                            break;
                          }
                          case 5: {
                            _6264 = _6237;
                            _6265 = _6249;
                            _6266 = _6252;
                            break;
                          }
                          default: {
                            _6264 = 0.0f;
                            _6265 = 0.0f;
                            _6266 = 0.0f;
                            break;
                          }
                        }
                      } else {
                        _6264 = _6237;
                        _6265 = _6237;
                        _6266 = _6237;
                      }
                      _6267 = _6264 * _6192;
                      _6268 = _6265 * _6192;
                      _6269 = _6266 * _6192;
                      _6271 = saturate(_4883 * 1.0101009607315063f);
                      _6282 = ((_6271 * (_4830 - _6267)) + _6267);
                      _6283 = ((_6271 * (_4831 - _6268)) + _6268);
                      _6284 = (lerp(_6269, _4832, _6271));
                    } else {
                      _6282 = _4830;
                      _6283 = _4831;
                      _6284 = _4832;
                    }
                    _6285 = _6282 * _4883;
                    _6286 = _6283 * _4883;
                    _6287 = _6284 * _4883;
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                      _6297 = (_6285 * _1480);
                      _6298 = (_6286 * _1480);
                      _6299 = (_6287 * _1480);
                    } else {
                      _6297 = _6285;
                      _6298 = _6286;
                      _6299 = _6287;
                    }
                    _6303 = (_6297 * _6177) + _1869;
                    _6304 = (_6298 * _6178) + _1870;
                    _6305 = (_6299 * _6179) + _1871;
                    if (_212) {
                      _6319 = ((float)((bool)(uint)(((srvContactShadowsCSMMask.SampleLevel(samplerPointClampNode, float2((cbSharedPerViewData.vViewportSize.x * _362), (cbSharedPerViewData.vViewportSize.y * _363)), 0.0f)).x) == 1.0f)));
                    } else {
                      _6319 = 1.0f;
                    }
                    if (_4681 > 0.0f) {
                      _6322 = (_4681 * _1633) * _6319;
                      _14768 = _6303;
                      _14769 = _6304;
                      _14770 = _6305;
                      _14771 = (((_6297 * _6174) * _6322) + _4878);
                      _14772 = (((_6298 * _6175) * _6322) + _4879);
                      _14773 = (((_6299 * _6176) * _6322) + _4880);
                    } else {
                      _14768 = _6303;
                      _14769 = _6304;
                      _14770 = _6305;
                      _14771 = _4878;
                      _14772 = _4879;
                      _14773 = _4880;
                    }
                  } else {
                    _14768 = _1869;
                    _14769 = _1870;
                    _14770 = _1871;
                    _14771 = _4878;
                    _14772 = _4879;
                    _14773 = _4880;
                  }
                } else {
                  _14768 = _1869;
                  _14769 = _1870;
                  _14770 = _1871;
                  _14771 = _1872;
                  _14772 = _1873;
                  _14773 = _1874;
                }
              } else {
                _1932 = _1912 * select(((_1881 & 67108864) != 0), 1.0f, (1.0f - _1864));
                [branch]
                if (_1915 == 4) {
                  _1937 = asfloat(srvLightInfoProperties.Load4(_1883)).x;
                  _1938 = asfloat(srvLightInfoProperties.Load4(_1883)).y;
                  _1939 = asfloat(srvLightInfoProperties.Load4(_1883)).z;
                  _1940 = asfloat(srvLightInfoProperties.Load4(_1883)).w;
                  _1943 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).x;
                  _1944 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).y;
                  _1945 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).z;
                  _1946 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).w;
                  _1949 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).x;
                  _1950 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).y;
                  _1951 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).z;
                  _1952 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).w;
                  _1955 = asint(srvLightInfoProperties.Load(((int)(_1883 + 48u))));
                  _1958 = asint(srvLightInfoProperties.Load(((int)(_1883 + 52u))));
                  _1961 = asint(srvLightInfoProperties.Load(((int)(_1883 + 64u))));
                  _1964 = asint(srvLightInfoProperties.Load(((int)(_1883 + 68u))));
                  _1967 = asint(srvLightInfoProperties.Load(((int)(_1883 + 72u))));
                  _1969 = f16tof32(((uint)((uint)(_1955) >> 16)));
                  _1970 = f16tof32(_1955);
                  _1972 = f16tof32(((uint)((uint)(_1958) >> 16)));
                  _1976 = ((float)((uint)((uint)(((uint)(_1958) >> 8) & 255)))) * 0.003921499941498041f;
                  _1989 = mad(_1939, _381, mad(_1938, _380, (_1937 * _379))) + _1940;
                  _1993 = mad(_1945, _381, mad(_1944, _380, (_1943 * _379))) + _1946;
                  _1997 = mad(_1951, _381, mad(_1950, _380, (_1949 * _379))) + _1952;
                  _2022 = saturate(1.0f - ((_1989 + 1.0f) * f16tof32(_1961))) + saturate(1.0f - ((1.0f - _1989) * f16tof32(((uint)((uint)(_1961) >> 16)))));
                  _2023 = saturate(1.0f - ((_1993 + 1.0f) * f16tof32(_1964))) + saturate(1.0f - ((1.0f - _1993) * f16tof32(((uint)((uint)(_1964) >> 16)))));
                  _2024 = saturate(1.0f - ((_1997 + 1.0f) * f16tof32(_1967))) + saturate(1.0f - ((1.0f - _1997) * f16tof32(((uint)((uint)(_1967) >> 16)))));
                  _2027 = saturate(1.0f - dot(float3(_2022, _2023, _2024), float3(_2022, _2023, _2024)));
                  _2028 = _2027 * _2027;
                  _2035 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_2028 * _1480), _2028) * _1932;
                  _14768 = ((_2035 * _1969) + _1869);
                  _14769 = ((_2035 * _1970) + _1870);
                  _14770 = ((_2035 * _1972) + _1871);
                  _14771 = (((_1976 * _1969) * _2035) + _1872);
                  _14772 = (((_1976 * _1970) * _2035) + _1873);
                  _14773 = (((_1972 * _1976) * _2035) + _1874);
                } else {
                  if (_1915 == 5) {
                    _2056 = asfloat(srvLightInfoProperties.Load4(_1883)).x;
                    _2057 = asfloat(srvLightInfoProperties.Load4(_1883)).y;
                    _2058 = asfloat(srvLightInfoProperties.Load4(_1883)).z;
                    _2059 = asfloat(srvLightInfoProperties.Load4(_1883)).w;
                    _2062 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).x;
                    _2063 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).y;
                    _2064 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).z;
                    _2065 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).w;
                    _2068 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).x;
                    _2069 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).y;
                    _2070 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).z;
                    _2071 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).w;
                    _2074 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).x;
                    _2075 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).y;
                    _2076 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).z;
                    _2079 = asfloat(srvLightInfoProperties.Load(((int)(_1883 + 60u))));
                    _2082 = asint(srvLightInfoProperties.Load(((int)(_1883 + 64u))));
                    _2085 = asint(srvLightInfoProperties.Load(((int)(_1883 + 68u))));
                    _2088 = asint(srvLightInfoProperties.Load(((int)(_1883 + 80u))));
                    _2091 = asint(srvLightInfoProperties.Load(((int)(_1883 + 84u))));
                    _2094 = asint(srvLightInfoProperties.Load(((int)(_1883 + 88u))));
                    _2097 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 92u)))).x;
                    _2098 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 92u)))).y;
                    _2099 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 92u)))).z;
                    _2100 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 92u)))).w;
                    _2103 = asint(srvLightInfoProperties.Load(((int)(_1883 + 108u))));
                    _2106 = asint(srvLightInfoProperties.Load(((int)(_1883 + 112u))));
                    _2109 = asint(srvLightInfoProperties.Load(((int)(_1883 + 116u))));
                    _2112 = asint(srvLightInfoProperties.Load(((int)(_1883 + 120u))));
                    _2115 = asint(srvLightInfoProperties.Load(((int)(_1883 + 124u))));
                    _2118 = asint(srvLightInfoProperties.Load(((int)(_1883 + 128u))));
                    _2121 = asint(srvLightInfoProperties.Load(((int)(_1883 + 132u))));
                    _2124 = asint(srvLightInfoProperties.Load(((int)(_1883 + 136u))));
                    _2127 = asint(srvLightInfoProperties.Load(((int)(_1883 + 140u))));
                    _2129 = f16tof32(((uint)((uint)(_2082) >> 16)));
                    _2130 = f16tof32(_2082);
                    _2132 = f16tof32(((uint)((uint)(_2085) >> 16)));
                    _2136 = ((float)((uint)((uint)(((uint)(_2085) >> 8) & 255)))) * 0.003921499941498041f;
                    _2139 = ((float)((uint)((uint)(_2085 & 255)))) * 0.003921499941498041f;
                    _2141 = f16tof32(((uint)((uint)(_2088) >> 16)));
                    _2144 = _2091 & 65535;
                    _2152 = ((_1881 & 3584) != 0);
                    _2163 = f16tof32(((uint)((uint)(_2112) >> 16)));
                    _2164 = 1.0f / _2163;
                    _2165 = _2163 + -1.0f;
                    _2166 = f16tof32(_2112);
                    _2187 = _318 && (_317 && ((cbSharedPerViewData.nLightingShadowFeatures & 1) != 0));
                    _2188 = dot(float3(_196, _197, _198), float3(_2074, _2075, _2076));
                    _2191 = saturate(1.0f - _2188) * f16tof32(_2103);
                    _2195 = (_2191 * _196) + _379;
                    _2196 = (_2191 * _197) + _380;
                    _2197 = (_2191 * _198) - _378;
                    _2201 = mad(_2058, _2197, mad(_2057, _2196, (_2195 * _2056))) + _2059;
                    _2205 = mad(_2064, _2197, mad(_2063, _2196, (_2195 * _2062))) + _2065;
                    _2209 = mad(_2070, _2197, mad(_2069, _2196, (_2195 * _2068))) + _2071;
                    _2210 = saturate(_2209);
                    _2233 = saturate(1.0f - (_2201 * f16tof32(_2121))) + saturate(1.0f - ((1.0f - _2201) * f16tof32(((uint)((uint)(_2121) >> 16)))));
                    _2234 = saturate(1.0f - (_2205 * f16tof32(_2124))) + saturate(1.0f - ((1.0f - _2205) * f16tof32(((uint)((uint)(_2124) >> 16)))));
                    _2235 = saturate(1.0f - (_2209 * f16tof32(_2127))) + saturate(1.0f - ((1.0f - _2209) * f16tof32(((uint)((uint)(_2127) >> 16)))));
                    _2238 = saturate(1.0f - dot(float3(_2233, _2234, _2235), float3(_2233, _2234, _2235)));
                    _2239 = _2238 * _2238;
                    if (_2239 > 0.0f) {
                      [branch]
                      if (_2152) {
                        _2243 = 1.0f - _2210;
                        _2244 = saturate(_2201);
                        _2245 = saturate(_2205);
                        bool __branch_chain_2242;
                        [branch]
                        if ((_1881 & 1024) == 0) {
                          _2559 = 1.0f;
                          _2560 = 1.0f;
                          _2561 = 0.0f;
                          _2562 = _2243;
                          __branch_chain_2242 = true;
                        } else {
                          _2250 = ((_2244 * _2165) + 0.5f) * _2164;
                          _2252 = ((_2245 * _2165) + 0.5f) * _2164;
                          _2253 = _2243 + f16tof32(((uint)((uint)(_2103) >> 16)));
                          Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_2091) >> 16))];
                          _2256 = select(_2187, f16tof32(((uint)((uint)(_2109) >> 16))), f16tof32(((uint)((uint)(_2106) >> 16))));
                          _2257 = saturate(_2253);
                          _2261 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                          _2270 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 0u) : (frac(frac(dot(float2(((_2261 * 32.665000915527344f) + _362), ((_2261 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                          _2271 = sin(_2270);
                          _2272 = cos(_2270);
                          _2273 = cbSharedPerViewData.nFrameCounter & 3;
                          _2278 = sqrt((float((int)(_2273)) * 0.25f) + 0.125f) * _2256;
                          _2287 = (_global_7[min((uint)(((int)(0u + (_2273 * 2)))), 127u)]) * _2278;
                          _2288 = (_global_7[min((uint)(((int)(1u + (_2273 * 2)))), 127u)]) * _2278;
                          _2290 = -0.0f - _2271;
                          _2295 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2287, _2288), float2(_2272, _2271)) + _2250), (dot(float2(_2287, _2288), float2(_2290, _2272)) + _2252)));
                          _2300 = _2295.x - _2257;
                          _2302 = select((_2300 < 0.0f), 0.0f, 1.0f);
                          _2304 = _2295.y - _2257;
                          _2306 = select((_2304 < 0.0f), 0.0f, 1.0f);
                          _2310 = _2295.z - _2257;
                          _2312 = select((_2310 < 0.0f), 0.0f, 1.0f);
                          _2316 = _2295.w - _2257;
                          _2318 = select((_2316 < 0.0f), 0.0f, 1.0f);
                          _2325 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                          _2330 = sqrt((float((int)(_2325)) * 0.25f) + 0.125f) * _2256;
                          _2339 = (_global_7[min((uint)(((int)(0u + (_2325 * 2)))), 127u)]) * _2330;
                          _2340 = (_global_7[min((uint)(((int)(1u + (_2325 * 2)))), 127u)]) * _2330;
                          _2346 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2339, _2340), float2(_2272, _2271)) + _2250), (dot(float2(_2339, _2340), float2(_2290, _2272)) + _2252)));
                          _2351 = _2346.x - _2257;
                          _2353 = select((_2351 < 0.0f), 0.0f, 1.0f);
                          _2357 = _2346.y - _2257;
                          _2359 = select((_2357 < 0.0f), 0.0f, 1.0f);
                          _2363 = _2346.z - _2257;
                          _2365 = select((_2363 < 0.0f), 0.0f, 1.0f);
                          _2369 = _2346.w - _2257;
                          _2371 = select((_2369 < 0.0f), 0.0f, 1.0f);
                          _2378 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                          _2383 = sqrt((float((int)(_2378)) * 0.25f) + 0.125f) * _2256;
                          _2392 = (_global_7[min((uint)(((int)(0u + (_2378 * 2)))), 127u)]) * _2383;
                          _2393 = (_global_7[min((uint)(((int)(1u + (_2378 * 2)))), 127u)]) * _2383;
                          _2399 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2392, _2393), float2(_2272, _2271)) + _2250), (dot(float2(_2392, _2393), float2(_2290, _2272)) + _2252)));
                          _2404 = _2399.x - _2257;
                          _2406 = select((_2404 < 0.0f), 0.0f, 1.0f);
                          _2410 = _2399.y - _2257;
                          _2412 = select((_2410 < 0.0f), 0.0f, 1.0f);
                          _2416 = _2399.z - _2257;
                          _2418 = select((_2416 < 0.0f), 0.0f, 1.0f);
                          _2422 = _2399.w - _2257;
                          _2424 = select((_2422 < 0.0f), 0.0f, 1.0f);
                          _2431 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                          _2436 = sqrt((float((int)(_2431)) * 0.25f) + 0.125f) * _2256;
                          _2445 = (_global_7[min((uint)(((int)(0u + (_2431 * 2)))), 127u)]) * _2436;
                          _2446 = (_global_7[min((uint)(((int)(1u + (_2431 * 2)))), 127u)]) * _2436;
                          _2452 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2445, _2446), float2(_2272, _2271)) + _2250), (dot(float2(_2445, _2446), float2(_2290, _2272)) + _2252)));
                          _2457 = _2452.x - _2257;
                          _2459 = select((_2457 < 0.0f), 0.0f, 1.0f);
                          _2463 = _2452.y - _2257;
                          _2465 = select((_2463 < 0.0f), 0.0f, 1.0f);
                          _2469 = _2452.z - _2257;
                          _2471 = select((_2469 < 0.0f), 0.0f, 1.0f);
                          _2475 = _2452.w - _2257;
                          _2477 = select((_2475 < 0.0f), 0.0f, 1.0f);
                          _2478 = ((((((((((((((_2302 + _2306) + _2312) + _2318) + _2353) + _2359) + _2365) + _2371) + _2406) + _2412) + _2418) + _2424) + _2459) + _2465) + _2471) + _2477;
                          _2489 = (saturate(_2478 * 0.0625f) * 2.0f) + -1.0f;
                          _2495 = float((int)(((int)(uint)((int)(_2489 > 0.0f))) - ((int)(uint)((int)(_2489 < 0.0f)))));
                          _2497 = 1.0f - (_2495 * _2489);
                          _2499 = (_2497 * _2497) * _2497;
                          _2506 = 0.5f - ((_2495 * 0.5f) * ((1.0f - _2499) - ((_2497 - _2499) * saturate(((1.0f / _2257) * (1.0f / _2478)) * ((((((((((((((((_2302 * _2300) + (_2306 * _2304)) + (_2312 * _2310)) + (_2318 * _2316)) + (_2353 * _2351)) + (_2359 * _2357)) + (_2365 * _2363)) + (_2371 * _2369)) + (_2406 * _2404)) + (_2412 * _2410)) + (_2418 * _2416)) + (_2424 * _2422)) + (_2459 * _2457)) + (_2465 * _2463)) + (_2471 * _2469)) + (_2477 * _2475))))));
                          _2511 = frac((_2250 * _2163) + 0.5f);
                          _2512 = frac((_2252 * _2163) + 0.5f);
                          _2513 = _2250 + _2164;
                          _2514 = _2252 + _2164;
                          _2516 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2513, _2514), _2253);
                          _2524 = _2164 * 2.0f;
                          _2525 = _2513 - _2524;
                          _2526 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2525, _2514), _2253);
                          _2531 = 1.0f - _2511;
                          _2536 = _2514 - _2524;
                          _2537 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2525, _2536), _2253);
                          _2542 = 1.0f - _2512;
                          _2547 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2513, _2536), _2253);
                          _2556 = (((mad(mad(_2526.x, _2531, _2526.y), _2512, mad(_2526.w, _2531, _2526.z)) + mad(mad(_2516.y, _2511, _2516.x), _2512, mad(_2516.z, _2511, _2516.w))) + mad(mad(_2537.w, _2531, _2537.z), _2542, mad(_2537.x, _2531, _2537.y))) + mad(mad(_2547.z, _2511, _2547.w), _2542, mad(_2547.y, _2511, _2547.x))) * 0.1111111119389534f;
                          [branch]
                          if (_2166 < 1.0f) {
                            _2559 = _2506;
                            _2560 = _2556;
                            _2561 = _2166;
                            _2562 = _2253;
                            __branch_chain_2242 = true;
                          } else {
                            _3031 = _2556;
                            _3032 = _2166;
                            _3033 = _2506;
                            __branch_chain_2242 = false;
                          }
                        }
                        if (__branch_chain_2242) {
                          _2565 = (_2244 * _2097) + _2099;
                          _2566 = (_2245 * _2098) + _2100;
                          if (!((_1881 & 512) == 0)) {
                            Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                            _2573 = select(_2187, f16tof32(_2109), f16tof32(_2106));
                            _2576 = saturate(_2562);
                            _2580 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _2589 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 1u) : (frac(frac(dot(float2(((_2580 * 32.665000915527344f) + _362), ((_2580 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _2590 = sin(_2589);
                            _2591 = cos(_2589);
                            _2596 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2565, _2566), 0.0f))).x) > _2576), 1.0f, 0.0f);
                            _2597 = cbSharedPerViewData.nFrameCounter & 3;
                            _2602 = sqrt((float((int)(_2597)) * 0.25f) + 0.125f) * _2573;
                            _2611 = (_global_7[min((uint)(((int)(0u + (_2597 * 2)))), 127u)]) * _2602;
                            _2612 = (_global_7[min((uint)(((int)(1u + (_2597 * 2)))), 127u)]) * _2602;
                            _2614 = -0.0f - _2590;
                            _2616 = dot(float2(_2611, _2612), float2(_2591, _2590)) + _2565;
                            _2617 = dot(float2(_2611, _2612), float2(_2614, _2591)) + _2566;
                            _2619 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2616, _2617));
                            _2623 = _2616 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _2624 = _2617 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _2627 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _2099);
                            _2628 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _2100);
                            _2633 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_2097 + _2099)) + 0.5f);
                            _2634 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_2098 + _2100)) + 0.5f);
                            _2637 = floor(_2623 + -0.5f);
                            _2638 = floor(_2624 + 0.5f);
                            _2640 = floor(_2623 + 0.5f);
                            _2642 = floor(_2624 + -0.5f);
                            _2643 = (_2637 < _2627);
                            _2644 = (_2638 < _2628);
                            if ((_2643 || _2644) | ((_2637 >= _2633) || (_2638 >= _2634))) {
                              _2653 = _2596;
                            } else {
                              _2653 = _2619.x;
                            }
                            _2654 = (_2640 < _2627);
                            if ((_2654 || _2644) | ((_2640 >= _2633) || (_2638 >= _2634))) {
                              _2662 = _2596;
                            } else {
                              _2662 = _2619.y;
                            }
                            _2663 = (_2642 < _2628);
                            if ((_2654 || _2663) | ((_2640 >= _2633) || (_2642 >= _2634))) {
                              _2671 = _2596;
                            } else {
                              _2671 = _2619.z;
                            }
                            if ((_2643 || _2663) | ((_2637 >= _2633) || (_2642 >= _2634))) {
                              _2679 = _2596;
                            } else {
                              _2679 = _2619.w;
                            }
                            _2680 = _2653 - _2576;
                            _2682 = select((_2680 < 0.0f), 0.0f, 1.0f);
                            _2684 = _2662 - _2576;
                            _2686 = select((_2684 < 0.0f), 0.0f, 1.0f);
                            _2690 = _2671 - _2576;
                            _2692 = select((_2690 < 0.0f), 0.0f, 1.0f);
                            _2696 = _2679 - _2576;
                            _2698 = select((_2696 < 0.0f), 0.0f, 1.0f);
                            _2705 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _2710 = sqrt((float((int)(_2705)) * 0.25f) + 0.125f) * _2573;
                            _2719 = (_global_7[min((uint)(((int)(0u + (_2705 * 2)))), 127u)]) * _2710;
                            _2720 = (_global_7[min((uint)(((int)(1u + (_2705 * 2)))), 127u)]) * _2710;
                            _2723 = dot(float2(_2719, _2720), float2(_2591, _2590)) + _2565;
                            _2724 = dot(float2(_2719, _2720), float2(_2614, _2591)) + _2566;
                            _2726 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2723, _2724));
                            _2730 = _2723 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _2731 = _2724 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _2734 = floor(_2730 + -0.5f);
                            _2735 = floor(_2731 + 0.5f);
                            _2737 = floor(_2730 + 0.5f);
                            _2739 = floor(_2731 + -0.5f);
                            _2740 = (_2734 < _2627);
                            _2741 = (_2735 < _2628);
                            if ((_2740 || _2741) | ((_2734 >= _2633) || (_2735 >= _2634))) {
                              _2750 = _2596;
                            } else {
                              _2750 = _2726.x;
                            }
                            _2751 = (_2737 < _2627);
                            if ((_2751 || _2741) | ((_2737 >= _2633) || (_2735 >= _2634))) {
                              _2759 = _2596;
                            } else {
                              _2759 = _2726.y;
                            }
                            _2760 = (_2739 < _2628);
                            if ((_2751 || _2760) | ((_2737 >= _2633) || (_2739 >= _2634))) {
                              _2768 = _2596;
                            } else {
                              _2768 = _2726.z;
                            }
                            if ((_2740 || _2760) | ((_2734 >= _2633) || (_2739 >= _2634))) {
                              _2776 = _2596;
                            } else {
                              _2776 = _2726.w;
                            }
                            _2777 = _2750 - _2576;
                            _2779 = select((_2777 < 0.0f), 0.0f, 1.0f);
                            _2783 = _2759 - _2576;
                            _2785 = select((_2783 < 0.0f), 0.0f, 1.0f);
                            _2789 = _2768 - _2576;
                            _2791 = select((_2789 < 0.0f), 0.0f, 1.0f);
                            _2795 = _2776 - _2576;
                            _2797 = select((_2795 < 0.0f), 0.0f, 1.0f);
                            _2804 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _2809 = sqrt((float((int)(_2804)) * 0.25f) + 0.125f) * _2573;
                            _2818 = (_global_7[min((uint)(((int)(0u + (_2804 * 2)))), 127u)]) * _2809;
                            _2819 = (_global_7[min((uint)(((int)(1u + (_2804 * 2)))), 127u)]) * _2809;
                            _2822 = dot(float2(_2818, _2819), float2(_2591, _2590)) + _2565;
                            _2823 = dot(float2(_2818, _2819), float2(_2614, _2591)) + _2566;
                            _2825 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2822, _2823));
                            _2829 = _2822 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _2830 = _2823 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _2833 = floor(_2829 + -0.5f);
                            _2834 = floor(_2830 + 0.5f);
                            _2836 = floor(_2829 + 0.5f);
                            _2838 = floor(_2830 + -0.5f);
                            _2839 = (_2833 < _2627);
                            _2840 = (_2834 < _2628);
                            if ((_2839 || _2840) | ((_2833 >= _2633) || (_2834 >= _2634))) {
                              _2849 = _2596;
                            } else {
                              _2849 = _2825.x;
                            }
                            _2850 = (_2836 < _2627);
                            if ((_2850 || _2840) | ((_2836 >= _2633) || (_2834 >= _2634))) {
                              _2858 = _2596;
                            } else {
                              _2858 = _2825.y;
                            }
                            _2859 = (_2838 < _2628);
                            if ((_2850 || _2859) | ((_2836 >= _2633) || (_2838 >= _2634))) {
                              _2867 = _2596;
                            } else {
                              _2867 = _2825.z;
                            }
                            if ((_2839 || _2859) | ((_2833 >= _2633) || (_2838 >= _2634))) {
                              _2875 = _2596;
                            } else {
                              _2875 = _2825.w;
                            }
                            _2876 = _2849 - _2576;
                            _2878 = select((_2876 < 0.0f), 0.0f, 1.0f);
                            _2882 = _2858 - _2576;
                            _2884 = select((_2882 < 0.0f), 0.0f, 1.0f);
                            _2888 = _2867 - _2576;
                            _2890 = select((_2888 < 0.0f), 0.0f, 1.0f);
                            _2894 = _2875 - _2576;
                            _2896 = select((_2894 < 0.0f), 0.0f, 1.0f);
                            _2903 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _2908 = sqrt((float((int)(_2903)) * 0.25f) + 0.125f) * _2573;
                            _2917 = (_global_7[min((uint)(((int)(0u + (_2903 * 2)))), 127u)]) * _2908;
                            _2918 = (_global_7[min((uint)(((int)(1u + (_2903 * 2)))), 127u)]) * _2908;
                            _2921 = dot(float2(_2917, _2918), float2(_2591, _2590)) + _2565;
                            _2922 = dot(float2(_2917, _2918), float2(_2614, _2591)) + _2566;
                            _2924 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2921, _2922));
                            _2928 = _2921 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _2929 = _2922 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _2932 = floor(_2928 + -0.5f);
                            _2933 = floor(_2929 + 0.5f);
                            _2935 = floor(_2928 + 0.5f);
                            _2937 = floor(_2929 + -0.5f);
                            _2938 = (_2932 < _2627);
                            _2939 = (_2933 < _2628);
                            if ((_2938 || _2939) | ((_2932 >= _2633) || (_2933 >= _2634))) {
                              _2948 = _2596;
                            } else {
                              _2948 = _2924.x;
                            }
                            _2949 = (_2935 < _2627);
                            if ((_2949 || _2939) | ((_2935 >= _2633) || (_2933 >= _2634))) {
                              _2957 = _2596;
                            } else {
                              _2957 = _2924.y;
                            }
                            _2958 = (_2937 < _2628);
                            if ((_2949 || _2958) | ((_2935 >= _2633) || (_2937 >= _2634))) {
                              _2966 = _2596;
                            } else {
                              _2966 = _2924.z;
                            }
                            if ((_2938 || _2958) | ((_2932 >= _2633) || (_2937 >= _2634))) {
                              _2974 = _2596;
                            } else {
                              _2974 = _2924.w;
                            }
                            _2975 = _2948 - _2576;
                            _2977 = select((_2975 < 0.0f), 0.0f, 1.0f);
                            _2981 = _2957 - _2576;
                            _2983 = select((_2981 < 0.0f), 0.0f, 1.0f);
                            _2987 = _2966 - _2576;
                            _2989 = select((_2987 < 0.0f), 0.0f, 1.0f);
                            _2993 = _2974 - _2576;
                            _2995 = select((_2993 < 0.0f), 0.0f, 1.0f);
                            _2996 = ((((((((((((((_2686 + _2682) + _2692) + _2698) + _2779) + _2785) + _2791) + _2797) + _2878) + _2884) + _2890) + _2896) + _2977) + _2983) + _2989) + _2995;
                            _3007 = (saturate(_2996 * 0.0625f) * 2.0f) + -1.0f;
                            _3013 = float((int)(((int)(uint)((int)(_3007 > 0.0f))) - ((int)(uint)((int)(_3007 < 0.0f)))));
                            _3015 = 1.0f - (_3013 * _3007);
                            _3017 = (_3015 * _3015) * _3015;
                            _3026 = (0.5f - ((_3013 * 0.5f) * ((1.0f - _3017) - ((_3015 - _3017) * saturate(((1.0f / _2576) * (1.0f / _2996)) * ((((((((((((((((_2686 * _2684) + (_2682 * _2680)) + (_2692 * _2690)) + (_2698 * _2696)) + (_2779 * _2777)) + (_2785 * _2783)) + (_2791 * _2789)) + (_2797 * _2795)) + (_2878 * _2876)) + (_2884 * _2882)) + (_2890 * _2888)) + (_2896 * _2894)) + (_2977 * _2975)) + (_2983 * _2981)) + (_2989 * _2987)) + (_2995 * _2993)))))));
                          } else {
                            _3026 = 1.0f;
                          }
                          _3031 = _2560;
                          _3032 = _2561;
                          _3033 = (lerp(_3026, _2559, _2561));
                        }
                        [branch]
                        if (!((_1881 & 2048) == 0)) {
                          Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_2094) >> 16))];
                          _3039 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_2201, _2205), 0.0f);
                          if (_3039.x > 0.0f) {
                            Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_2094 & 65535))];
                            _3046 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_2201, _2205), 0.0f);
                            _3060 = mad(saturate(((log2(_2210 * _2079) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _3061 = max(9.999999747378752e-06f, _3039.x);
                            _3062 = _3046.x / _3061;
                            _3063 = _3046.y / _3061;
                            _3065 = _3046.w / _3061;
                            _3070 = ((0.375f - _3063) * 4.999999873689376e-06f) + _3063;
                            _3073 = -0.0f - _3062;
                            _3074 = mad(_3073, _3070, (_3046.z / _3061));
                            _3076 = 1.0f / mad(_3073, _3062, _3070);
                            _3077 = _3076 * _3074;
                            _3082 = _3060 - _3062;
                            _3087 = (((_3060 * _3060) - _3070) - (_3077 * _3082)) / mad((-0.0f - _3074), _3077, mad((-0.0f - _3070), _3070, (((0.375f - _3065) * 4.999999873689376e-06f) + _3065)));
                            _3089 = (_3076 * _3082) - (_3087 * _3077);
                            _3092 = 1.0f / _3087;
                            _3093 = _3089 * _3092;
                            _3098 = sqrt(((_3093 * _3093) * 0.25f) - ((1.0f - dot(float2(_3089, _3087), float2(_3062, _3070))) * _3092));
                            _3100 = (_3093 * -0.5f) - _3098;
                            _3102 = _3098 - (_3093 * 0.5f);
                            _3104 = select((_3100 < _3060), 1.0f, 0.0f);
                            _3109 = (_3104 + -0.05000000074505806f) / (_3100 - _3060);
                            _3115 = (((select((_3102 < _3060), 1.0f, 0.0f) - _3104) / (_3102 - _3100)) - _3109) / (_3102 - _3060);
                            _3117 = _3109 - (_3115 * _3100);
                            _3130 = (exp2((_3039.x * -1.4426950216293335f) * saturate((dot(float2(_3062, _3070), float2((_3117 - (_3115 * _3060)), _3115)) + 0.05000000074505806f) - (_3117 * _3060))) * _3033);
                          } else {
                            _3130 = _3033;
                          }
                        } else {
                          _3130 = _3033;
                        }
                        _3135 = _3032;
                        _3136 = _3130;
                        _3137 = _3031;
                        _3138 = (lerp(_3130, _3031, _3032));
                      } else {
                        _3135 = 0.0f;
                        _3136 = 1.0f;
                        _3137 = 0.0f;
                        _3138 = 1.0f;
                      }
                    } else {
                      _3135 = 0.0f;
                      _3136 = 1.0f;
                      _3137 = 0.0f;
                      _3138 = 1.0f;
                    }
                    [branch]
                    if (!(_2144 == 0)) {
                      Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _2144)))];
                      _3151 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_2201 * f16tof32(((uint)((uint)(_2115) >> 16)))) + f16tof32(((uint)((uint)(_2118) >> 16)))), ((_2205 * f16tof32(_2115)) + f16tof32(_2118))), 0.0f);
                      _3159 = (_3151.x * _2129);
                      _3160 = (_3151.y * _2130);
                      _3161 = (_3151.z * _2132);
                    } else {
                      _3159 = _2129;
                      _3160 = _2130;
                      _3161 = _2132;
                    }
                    _3162 = _3136 * _2239;
                    [branch]
                    if (!(_3162 == 0.0f)) {
                      bool __branch_chain_3165;
                      if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                        _3181 = 0;
                        __branch_chain_3165 = true;
                      } else {
                        if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                          _3181 = 1;
                          __branch_chain_3165 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                            _3181 = 2;
                            __branch_chain_3165 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                              _3181 = 3;
                              __branch_chain_3165 = true;
                            } else {
                              _3202 = _3162;
                              __branch_chain_3165 = false;
                            }
                          }
                        }
                      }
                      if (__branch_chain_3165) {
                        while(true) {
                          _3184 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_70, _71, 0));
                          if (_3181 == 0) {
                            _3198 = _3184.x;
                          } else {
                            if (_3181 == 1) {
                              _3198 = _3184.y;
                            } else {
                              if (_3181 == 2) {
                                _3198 = _3184.z;
                              } else {
                                _3198 = _3184.w;
                              }
                            }
                          }
                          _3202 = ((_3198 * _3198) * _2239);
                          break;
                        }
                      }
                      while(true) {
                        [branch]
                        if (!(_3202 == 0.0f)) {
                          [branch]
                          if (_2152) {
                            if (!(_383 || _221)) {
                              _3214 = ((_3135 * _2239) * _3137) * saturate(0.30000001192092896f - dot(float3(_2074, _2075, _2076), float3(_196, _197, _198)));
                              _3219 = (_3214 * _1508);
                              _3220 = (_3214 * _1509);
                              _3221 = (_3214 * _1510);
                              _3222 = _3135;
                            } else {
                              _3219 = 0.0f;
                              _3220 = 0.0f;
                              _3221 = 0.0f;
                              _3222 = _3135;
                            }
                          } else {
                            _3219 = 0.0f;
                            _3220 = 0.0f;
                            _3221 = 0.0f;
                            _3222 = 0.0f;
                          }
                          _3223 = select(_212, (_3138 * _2239), _3202);
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _3230 = srvLightMappingData[_1884];
                            if (!(_3230 == -1)) {
                              _3235 = srvLightIndexData[_3230].nLayerIndex;
                              _3237 = srvLightIndexData[_3230].vAtlasOrigin.x;
                              _3238 = srvLightIndexData[_3230].vAtlasOrigin.y;
                              _3240 = srvLightIndexData[_3230].vScreenOrigin.x;
                              _3241 = srvLightIndexData[_3230].vScreenOrigin.y;
                              _3250 = ((int)(_3235 * 5)) & 31;
                              _3253 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_3237 + _70) - _3240)), ((int)((_3238 + _71) - _3241)), 0)))).x) & ((int)(31 << _3250)))) >> _3250;
                              _3258 = ((float)((uint)((uint)((uint)(_3253) >> 1)))) * 0.06666667014360428f;
                              _3264 = (_3258 * _3223);
                              _3265 = (select(_212, ((float)((bool)(uint)((_3253 & 1) != 0))), _3258) * _3223);
                            } else {
                              _3264 = _3223;
                              _3265 = _3223;
                            }
                          } else {
                            _3264 = _3223;
                            _3265 = _3223;
                          }
                          _3269 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _3272 = select(_3269, (_3264 * _1480), _3264);
                          _3274 = dot(float3(_2074, _2075, _2076), float3(_2074, _2075, _2076));
                          _3275 = rsqrt(_3274);
                          _3276 = _3275 * _2074;
                          _3277 = _3275 * _2075;
                          _3278 = _3275 * _2076;
                          _3279 = dot(float3(_196, _197, _198), float3(_3276, _3277, _3278));
                          if (_2141 > 0.0f) {
                            _3287 = sqrt(saturate((_2141 * _2141) * (1.0f / (_3274 + 1.0f))));
                            if (_3279 < _3287) {
                              _3292 = max(_3279, (-0.0f - _3287)) + _3287;
                              _3297 = ((_3292 * _3292) / (_3287 * 4.0f));
                            } else {
                              _3297 = _3279;
                            }
                          } else {
                            _3297 = _3279;
                          }
                          _3298 = _268 * _268;
                          _3299 = 1.0f - _3298;
                          _3302 = saturate((_2141 * _3299) * _3275);
                          _3304 = saturate(_3275 * f16tof32(_2088));
                          if (_319) {
                            _3306 = saturate(_3279);
                            _3313 = (_3306 * (_196 - _359)) + _359;
                            _3314 = (_3306 * (_197 - _360)) + _360;
                            _3315 = (_3306 * (_198 - _361)) + _361;
                            _3317 = rsqrt(dot(float3(_3313, _3314, _3315), float3(_3313, _3314, _3315)));
                            _3322 = (_3313 * _3317);
                            _3323 = (_3314 * _3317);
                            _3324 = (_3315 * _3317);
                          } else {
                            _3322 = _196;
                            _3323 = _197;
                            _3324 = _198;
                          }
                          _3325 = dot(float3(_3322, _3323, _3324), float3(_3276, _3277, _3278));
                          _3326 = dot(float3(_3322, _3323, _3324), float3(_601, _602, _600));
                          _3327 = dot(float3(_601, _602, _600), float3(_3276, _3277, _3278));
                          _3330 = rsqrt((_3327 * 2.0f) + 2.0f);
                          _3333 = saturate(_3330 * (_3326 + _3325));
                          _3336 = saturate((_3330 * _3327) + _3330);
                          _3337 = (_3302 > 0.0f);
                          if (_3337) {
                            _3341 = sqrt(1.0f - (_3302 * _3302));
                            _3343 = (_3325 * 2.0f) * _3326;
                            _3344 = _3343 - _3327;
                            if (!(_3344 >= _3341)) {
                              _3352 = rsqrt(1.0f - (_3344 * _3344)) * _3302;
                              _3355 = _3352 * (_3326 - (_3344 * _3325));
                              _3356 = _3326 * _3326;
                              _3361 = _3352 * (((_3356 * 2.0f) + -1.0f) - (_3344 * _3327));
                              _3370 = sqrt(saturate((((1.0f - (_3325 * _3325)) - _3356) - (_3327 * _3327)) + (_3343 * _3327)));
                              _3371 = _3370 * _3352;
                              _3374 = ((_3326 * 2.0f) * _3352) * _3370;
                              _3376 = (_3341 * _3325) + _3326;
                              _3377 = _3376 + _3355;
                              _3378 = _3341 * _3327;
                              _3380 = (_3378 + 1.0f) + _3361;
                              _3381 = _3371 * _3380;
                              _3382 = _3377 * _3380;
                              _3383 = _3374 * _3377;
                              _3388 = (((_3377 * 0.25f) * _3374) - (_3381 * 0.5f)) * _3382;
                              _3402 = (((_3383 - (_3381 * 2.0f)) * _3383) + (_3381 * _3381)) + ((((-0.5f - ((_3380 + _3378) * 0.5f)) * _3382) + ((_3380 * _3380) * _3376)) * _3377);
                              _3407 = (_3388 * 2.0f) / ((_3402 * _3402) + (_3388 * _3388));
                              _3408 = _3402 * _3407;
                              _3410 = 1.0f - (_3388 * _3407);
                              _3416 = ((_3408 * _3374) + _3378) + (_3410 * _3361);
                              _3419 = rsqrt((_3416 * 2.0f) + 2.0f);
                              _3428 = saturate((_3416 * _3419) + _3419);
                              _3429 = saturate(((_3376 + (_3408 * _3371)) + (_3410 * _3355)) * _3419);
                            } else {
                              _3428 = abs(_3326);
                              _3429 = 1.0f;
                            }
                          } else {
                            _3428 = _3336;
                            _3429 = _3333;
                          }
                          _3430 = saturate(_3326);
                          _3431 = saturate(_3297);
                          _3432 = saturate(_3325);
                          _3433 = _3298 * _3298;
                          _3434 = (_3304 > 0.0f);
                          if (_3434) {
                            _3443 = saturate(((_3304 * _3304) / ((_3428 * 3.5999999046325684f) + 0.4000000059604645f)) + _3433);
                          } else {
                            _3443 = _3433;
                          }
                          _3444 = sqrt(_3443);
                          if (_3337) {
                            _3455 = (_3443 / ((((_3302 * 0.25f) * ((_3444 * 3.0f) + _3302)) / (_3428 + 0.0010000000474974513f)) + _3443));
                          } else {
                            _3455 = 1.0f;
                          }
                          _3459 = (((_3443 * _3429) - _3429) * _3429) + 1.0f;
                          _3462 = (_3443 / (_3459 * _3459)) * _3455;
                          _3463 = 1.0f - _251;
                          _3464 = 1.0f - _252;
                          _3465 = 1.0f - _253;
                          _3466 = saturate(_3428);
                          _3467 = 1.0f - _3466;
                          _3468 = log2(_3467);
                          _3470 = exp2(_3468 * 5.0f);
                          _3474 = (_3470 * _3463) + _251;
                          _3475 = (_3470 * _3464) + _252;
                          _3476 = (_3470 * _3465) + _253;
                          _3477 = abs(_3326);
                          _3479 = saturate(_3477 + 9.999999747378752e-06f);
                          _3480 = 1.0f - _3444;
                          _3488 = 0.5f / ((((_3480 * _3479) + _3444) * _3431) + (((_3480 * _3431) + _3444) * _3479));
                          if (_212) {
                            _3498 = ((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                            _3499 = ((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                            _3500 = ((_164 + -0.5f) * 0.5f) + 0.5f;
                            _3517 = ((dot(float3((-0.0f - _3322), (-0.0f - _3323), (-0.0f - _3324)), float3(_3276, _3277, _3278)) + dot(float3((-0.0f - _601), (-0.0f - _602), (-0.0f - _600)), float3(_3276, _3277, _3278))) * 0.5f) * exp2(log2(1.0f - _3430) * (11.0f - (((float)((uint)((uint)((uint)(_310) >> 2)))) * 0.1666666716337204f)));
                            _3526 = saturate((_1481 + -0.009999999776482582f) * -100.0f);
                            _3531 = ((_3526 * _3526) * 3.0f) * (3.0f - (_3526 * 2.0f));
                            _3538 = 10.0f - (exp2(log2(saturate(_1481 * 5.0f)) * 3.0f) * 9.0f);
                            _3539 = saturate(_3432 + _3498) * _3432;
                            _3540 = saturate(_3432 + _3499) * _3432;
                            _3541 = saturate(_3432 + _3500) * _3432;
                            _3560 = (max(((_3531 + _3498) * _3517), 0.0f) * _3538) + sqrt(_3539 * _3539);
                            _3561 = (max(((_3531 + _3499) * _3517), 0.0f) * _3538) + sqrt(_3540 * _3540);
                            _3562 = (max(((_3531 + _3500) * _3517), 0.0f) * _3538) + sqrt(_3541 * _3541);
                            _3563 = _3276 + _601;
                            _3564 = _3277 + _602;
                            _3565 = _3278 + _600;
                            _3567 = rsqrt(dot(float3(_3563, _3564, _3565), float3(_3563, _3564, _3565)));
                            if (!(select((_309 != 0), 1.0f, 0.0f) < 1.0f)) {
                              _3581 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                              _3582 = _3581 * _196;
                              _3583 = _3581 * _197;
                              _3584 = _3581 * _198;
                              _3587 = (abs(_3582) < abs(_3583));
                              _3588 = select(_3587, 1.0f, 0.0f);
                              _3589 = select(_3587, 0.0f, 1.0f);
                              _3590 = _3589 * _3584;
                              _3592 = -0.0f - (_3584 * _3588);
                              _3595 = (_3588 * _3583) - (_3589 * _3582);
                              _3597 = rsqrt(dot(float3(_3590, _3592, _3595), float3(_3590, _3592, _3595)));
                              _3598 = _3590 * _3597;
                              _3599 = _3597 * _3592;
                              _3600 = _3595 * _3597;
                              _3603 = (_3599 * _3584) - (_3600 * _3583);
                              _3606 = (_3600 * _3582) - (_3598 * _3584);
                              _3609 = (_3598 * _3583) - (_3599 * _3582);
                              _3611 = rsqrt(dot(float3(_3603, _3606, _3609), float3(_3603, _3606, _3609)));
                              _3623 = saturate(abs(_308 + -2.5f) + -0.5f) + -0.5f;
                              _3624 = saturate(1.5f - abs(_308 + -1.5f)) + -0.5f;
                              _3626 = rsqrt(dot(float2(_3623, _3624), float2(_3623, _3624)));
                              _3627 = _3626 * _3623;
                              _3628 = _3626 * _3624;
                              _3635 = ((_3603 * _3611) * _3627) + (_3628 * _3598);
                              _3636 = ((_3606 * _3611) * _3627) + (_3628 * _3599);
                              _3637 = ((_3609 * _3611) * _3627) + (_3628 * _3600);
                              _3640 = min(max(dot(float3(_3635, _3636, _3637), float3(_3276, _3277, _3278)), -1.0f), 1.0f);
                              _3643 = min(max(dot(float3(_3635, _3636, _3637), float3(_601, _602, _600)), -1.0f), 1.0f);
                              _3644 = abs(_3643);
                              _3649 = (1.5707963705062866f - (_3644 * 0.1565829962491989f)) * sqrt(1.0f - _3644);
                              _3653 = abs(_3640);
                              _3658 = (1.5707963705062866f - (_3653 * 0.1565829962491989f)) * sqrt(1.0f - _3653);
                              _3665 = cos(abs(select((_3640 >= 0.0f), _3658, (3.1415927410125732f - _3658)) - select((_3643 >= 0.0f), _3649, (3.1415927410125732f - _3649))) * 0.5f);
                              _3669 = _3276 - (_3640 * _3635);
                              _3670 = _3277 - (_3640 * _3636);
                              _3671 = _3278 - (_3640 * _3637);
                              _3675 = _601 - (_3643 * _3635);
                              _3676 = _602 - (_3643 * _3636);
                              _3677 = _600 - (_3643 * _3637);
                              _3684 = rsqrt((dot(float3(_3675, _3676, _3677), float3(_3675, _3676, _3677)) * dot(float3(_3669, _3670, _3671), float3(_3669, _3670, _3671))) + 9.999999747378752e-05f) * dot(float3(_3669, _3670, _3671), float3(_3675, _3676, _3677));
                              _3688 = sqrt(saturate((_3684 * 0.5f) + 0.5f));
                              _3692 = _3298 * 0.5f;
                              _3693 = _3298 * 2.0f;
                              _3697 = exp2((1.0f - abs(_3222)) * -72.13475036621094f);
                              if (!((_310 & 1) == 0)) {
                                _3704 = select(((select(((_310 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_3222 == -1.0f))), 0.0f, _3697);
                              } else {
                                _3704 = _3697;
                              }
                              _3707 = saturate((_3279 + 0.5f) * 0.6666666865348816f);
                              _3717 = (_3643 + _3640) + ((((_3688 * 0.9975510239601135f) * sqrt(1.0f - (_3643 * _3643))) - (_3643 * 0.06994284689426422f)) * 0.13988569378852844f);
                              _3719 = (_3298 * 1.4142135381698608f) * _3688;
                              _3732 = 1.0f - sqrt(saturate((_3327 * 0.5f) + 0.5f));
                              _3733 = _3732 * _3732;
                              _3739 = saturate(-0.0f - _3327);
                              _3742 = (1.0f - saturate(_3739)) * _3707;
                              _3751 = ((((_3688 * 0.5f) * (exp2((((_3717 * _3717) * -0.5f) / (_3719 * _3719)) * 1.4426950216293335f) / (_3719 * 2.5066282749176025f))) * min(_255, 0.5f)) * (((_3733 * _3733) * (_3732 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3742, 1.0f, _3704));
                              _3753 = (_3640 + -0.03500000014901161f) + _3643;
                              _3762 = 1.0f / ((1.190000057220459f / _3665) + (_3665 * 0.36000001430511475f));
                              _3767 = ((_3762 * (0.6000000238418579f - (_3684 * 0.800000011920929f))) + 1.0f) * _3688;
                              _3773 = 1.0f - (sqrt(saturate(1.0f - (_3767 * _3767))) * _3665);
                              _3774 = _3773 * _3773;
                              _3778 = 0.9534794092178345f - ((_3774 * _3774) * (_3773 * 0.9534794092178345f));
                              _3779 = _3767 * _3762;
                              _3784 = (sqrt(1.0f - (_3779 * _3779)) * 0.5f) / _3665;
                              _3803 = 1.0f - saturate((_3739 + -0.44999998807907104f) * 2.222222328186035f);
                              _3806 = ((1.0f - _3707) * _3704) + _3707;
                              _3809 = ((_3778 * _3778) * (exp2((((_3753 * _3753) * -0.5f) / (_3692 * _3692)) * 1.4426950216293335f) / (_3298 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3684 * 5.2658371925354f));
                              _3823 = (_3640 + -0.14000000059604645f) + _3643;
                              _3833 = 1.0f - (_3665 * 0.5f);
                              _3834 = _3833 * _3833;
                              _3838 = (_3834 * _3834) * (0.9534794092178345f - (_3665 * 0.47673970460891724f));
                              _3840 = 0.9534794092178345f - _3838;
                              _3842 = (_3840 * _3840) * (_3838 + 0.04652056470513344f);
                              _3845 = exp2((_3684 * 24.525815963745117f) + -24.208423614501953f);
                              _3858 = ((exp2((((_3823 * _3823) * -0.5f) / (_3693 * _3693)) * 1.4426950216293335f) / (_3298 * 5.013256549835205f)) * (lerp(_3842, 1.0f, _220))) * (((exp2((saturate(dot(float3((_3567 * _3563), (_3567 * _3564), (_3567 * _3565)), float3(_196, _197, _198))) * 17.312339782714844f) + -14.109557151794434f) - _3845) * _220) + _3845);
                              _4570 = (((((exp2(log2(max(_162, 0.0f)) * _3784) * _3806) * _3809) * _3803) + _3751) + (_3858 * _162));
                              _4571 = (((((exp2(log2(max(_163, 0.0f)) * _3784) * _3806) * _3809) * _3803) + _3751) + (_3858 * _163));
                              _4572 = (((((exp2(log2(max(_164, 0.0f)) * _3784) * _3806) * _3809) * _3803) + _3751) + (_3858 * _164));
                              _4573 = _3560;
                              _4574 = _3561;
                              _4575 = _3562;
                            } else {
                              _4570 = 0.0f;
                              _4571 = 0.0f;
                              _4572 = 0.0f;
                              _4573 = _3560;
                              _4574 = _3561;
                              _4575 = _3562;
                            }
                          } else {
                            if (_319) {
                              _3876 = ((float)((uint)((uint)(_312 & 15)))) * 0.06666667014360428f;
                              _3877 = _268 * 0.0317460335791111f;
                              _3880 = min(1.0f, max((_3877 * ((float)((uint)((uint)((uint)(_311) >> 2))))), 0.019999999552965164f));
                              _3883 = min(1.0f, max((_3877 * ((float)((uint)((uint)((((int)(_311 << 4)) & 48) | ((uint)(_312) >> 4)))))), 0.019999999552965164f));
                              _3886 = ((_3883 - _3880) * _3876) + _3880;
                              _3887 = _3886 * _3886;
                              _3891 = saturate(abs(_3430) + 9.999999747378752e-06f);
                              _3892 = sqrt(_3887 * _3887);
                              _3893 = 1.0f - _3892;
                              _3902 = _3880 * _3880;
                              _3903 = _3902 * _3902;
                              if (_3434) {
                                _3912 = saturate(((_3304 * _3304) / ((_3428 * 3.5999999046325684f) + 0.4000000059604645f)) + _3903);
                              } else {
                                _3912 = _3903;
                              }
                              if (_3337) {
                                _3924 = (_3912 / ((((_3302 * 0.25f) * ((sqrt(_3912) * 3.0f) + _3302)) / (_3428 + 0.0010000000474974513f)) + _3912));
                              } else {
                                _3924 = 1.0f;
                              }
                              _3925 = _3883 * _3883;
                              _3926 = _3925 * _3925;
                              if (_3434) {
                                _3935 = saturate(((_3304 * _3304) / ((_3428 * 3.5999999046325684f) + 0.4000000059604645f)) + _3926);
                              } else {
                                _3935 = _3926;
                              }
                              if (_3337) {
                                _3947 = (_3935 / ((((_3302 * 0.25f) * ((sqrt(_3935) * 3.0f) + _3302)) / (_3428 + 0.0010000000474974513f)) + _3935));
                              } else {
                                _3947 = 1.0f;
                              }
                              _3951 = (((_3912 * _3429) - _3429) * _3429) + 1.0f;
                              _3954 = (_3912 / (_3951 * _3951)) * _3924;
                              _3958 = (((_3935 * _3429) - _3429) * _3429) + 1.0f;
                              _3965 = saturate(_3429);
                              _3969 = saturate((_3325 + _2139) / (_2139 + 1.0f));
                              _3974 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_313)))) + 1u))]);
                              _3981 = ((float)((uint)((uint)((uint)((uint)(_3974.x)) >> 24)))) * 0.25f;
                              _3984 = ((float)((uint)((uint)(_3974.x & 255)))) * 0.003921568859368563f;
                              _3988 = ((float)((uint)((uint)(((uint)((uint)(_3974.x)) >> 8) & 255)))) * 0.003921568859368563f;
                              _3992 = ((float)((uint)((uint)(((uint)((uint)(_3974.x)) >> 16) & 255)))) * 0.003921568859368563f;
                              _4001 = ((float)((uint)((uint)((uint)((uint)(_3974.y)) >> 24)))) * 0.25f;
                              _4004 = ((float)((uint)((uint)(_3974.y & 255)))) * 0.003921568859368563f;
                              _4008 = ((float)((uint)((uint)(((uint)((uint)(_3974.y)) >> 8) & 255)))) * 0.003921568859368563f;
                              _4012 = ((float)((uint)((uint)(((uint)((uint)(_3974.y)) >> 16) & 255)))) * 0.003921568859368563f;
                              _4020 = (float)((uint)((uint)(_3974.w & 31)));
                              _4026 = (float)((uint)((uint)(((uint)((uint)(_3974.w)) >> 10) & 31)));
                              _4036 = (float)((uint)((uint)(((uint)((uint)(_3974.w)) >> 25) & 31)));
                              _4039 = ((float)((uint)((uint)(_3974.z & 255)))) * 0.003921568859368563f;
                              _4043 = ((float)((uint)((uint)(((uint)((uint)(_3974.z)) >> 8) & 255)))) * 0.003921568859368563f;
                              _4047 = ((float)((uint)((uint)(((uint)((uint)(_3974.z)) >> 16) & 255)))) * 0.003921568859368563f;
                              _4054 = (((float)((uint)((uint)((uint)((uint)(_3974.z)) >> 24)))) * 0.003921568859368563f) * select(((_3974.w & 1073741824) != 0), -1.0f, 1.0f);
                              _4068 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_3974.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _3466)));
                              _4069 = ((2.0f - (_4020 * 0.06451612710952759f)) > 0.0f);
                              if (_4069) {
                                _4080 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _3965))) * (10.0f - (_4020 * 0.32258063554763794f))) * _4068);
                              } else {
                                _4080 = _4068;
                              }
                              _4091 = exp2(log2(max(9.999999747378752e-06f, _3965)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_3974.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                              _4092 = ((2.0f - (_4026 * 0.06451612710952759f)) > 0.0f);
                              if (_4092) {
                                _4102 = (exp2(log2(max(9.999999747378752e-06f, _3467)) * (10.0f - (_4026 * 0.32258063554763794f))) * _4091);
                              } else {
                                _4102 = _4091;
                              }
                              if (_4069) {
                                _4116 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _3965))) * (10.0f - (_4020 * 0.32258063554763794f))) * _4068);
                              } else {
                                _4116 = _4068;
                              }
                              if (_4092) {
                                _4129 = (exp2(log2(max(9.999999747378752e-06f, _3467)) * (10.0f - (_4026 * 0.32258063554763794f))) * _4091);
                              } else {
                                _4129 = _4091;
                              }
                              if (_4069) {
                                _4143 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _3965))) * (10.0f - (_4020 * 0.32258063554763794f))) * _4068);
                              } else {
                                _4143 = _4068;
                              }
                              if (_4092) {
                                _4156 = (exp2(log2(max(9.999999747378752e-06f, _3467)) * (10.0f - (_4026 * 0.32258063554763794f))) * _4091);
                              } else {
                                _4156 = _4091;
                              }
                              _4168 = (1.0f - exp2(log2(1.0f - _3965) * 3.0f)) * (1.0f - exp2(_3468 * 3.0f));
                              _4172 = saturate(_3969 / (_4168 * (((float)((uint)((uint)(((uint)((uint)(_3974.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                              _4177 = ((_4172 * _4172) * (3.0f - (_4172 * 2.0f))) + -1.0f;
                              _4179 = ((((_4039 * _4039) * _4054) * _4168) * _4177) + 1.0f;
                              _4182 = ((((_4043 * _4043) * _4054) * _4168) * _4177) + 1.0f;
                              _4185 = ((((_4047 * _4047) * _4054) * _4168) * _4177) + 1.0f;
                              _4187 = saturate(_4036 * 0.06451612710952759f);
                              _4194 = exp2(log2(1.0f - _3428) * (10.0f - (_4036 * 0.32258063554763794f)));
                              _4213 = ((((((_3935 / (_3958 * _3958)) * _3947) - _3954) * _3876) + _3954) * (0.5f / ((((_3893 * _3891) + _3892) * _3431) + (((_3893 * _3431) + _3892) * _3891)))) * _3431;
                              _4570 = ((_4213 * _4179) * (((_4187 * _3463) * _4194) + _251));
                              _4571 = ((_4213 * _4182) * (((_4187 * _3464) * _4194) + _252));
                              _4572 = ((_4213 * _4185) * (((_4187 * _3465) * _4194) + _253));
                              _4573 = (((((_4080 * (((_3984 * _3984) * _3981) + -1.0f)) + 1.0f) * _3969) * ((_4102 * (((_4004 * _4004) * _4001) + -1.0f)) + 1.0f)) * _4179);
                              _4574 = (((((_4116 * (((_3988 * _3988) * _3981) + -1.0f)) + 1.0f) * _3969) * ((_4129 * (((_4008 * _4008) * _4001) + -1.0f)) + 1.0f)) * _4182);
                              _4575 = (((((_4143 * (((_3992 * _3992) * _3981) + -1.0f)) + 1.0f) * _3969) * ((_4156 * (((_4012 * _4012) * _4001) + -1.0f)) + 1.0f)) * _4185);
                            } else {
                              if (_241) {
                                if (_256 < 0.007874015718698502f) {
                                  _4227 = _3429 * _3429;
                                  _4229 = max((1.0f - _4227), 9.999999747378752e-05f);
                                  _4367 = (((((((exp2(((-0.0f - (_4227 / _4229)) / _3443) * 1.4426950216293335f) * 4.0f) / (_4229 * _4229)) + 1.0f) * (1.0f / ((_3443 * 4.0f) + 1.0f))) - _3462) * _257) + _3462);
                                  _4368 = (((saturate(0.25f / ((_3432 + _3430) - (_3432 * _3430))) - _3488) * _257) + _3488);
                                } else {
                                  _4253 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                                  _4254 = _4253 * _196;
                                  _4255 = _4253 * _197;
                                  _4256 = _4253 * _198;
                                  _4259 = (abs(_4254) < abs(_4255));
                                  _4260 = select(_4259, 1.0f, 0.0f);
                                  _4261 = select(_4259, 0.0f, 1.0f);
                                  _4262 = _4261 * _4256;
                                  _4264 = -0.0f - (_4256 * _4260);
                                  _4267 = (_4260 * _4255) - (_4261 * _4254);
                                  _4269 = rsqrt(dot(float3(_4262, _4264, _4267), float3(_4262, _4264, _4267)));
                                  _4270 = _4262 * _4269;
                                  _4271 = _4269 * _4264;
                                  _4272 = _4267 * _4269;
                                  _4275 = (_4271 * _4256) - (_4272 * _4255);
                                  _4278 = (_4272 * _4254) - (_4270 * _4256);
                                  _4281 = (_4270 * _4255) - (_4271 * _4254);
                                  _4283 = rsqrt(dot(float3(_4275, _4278, _4281), float3(_4275, _4278, _4281)));
                                  _4287 = _257 * 4.0f;
                                  _4296 = saturate(abs(_4287 + -2.5f) + -0.5f) + -0.5f;
                                  _4297 = saturate(1.5f - abs(_4287 + -1.5f)) + -0.5f;
                                  _4299 = rsqrt(dot(float2(_4296, _4297), float2(_4296, _4297)));
                                  _4300 = _4299 * _4296;
                                  _4301 = _4299 * _4297;
                                  _4308 = ((_4275 * _4283) * _4300) + (_4301 * _4270);
                                  _4309 = ((_4278 * _4283) * _4300) + (_4301 * _4271);
                                  _4310 = ((_4281 * _4283) * _4300) + (_4301 * _4272);
                                  _4313 = (_4309 * _198) - (_4310 * _197);
                                  _4316 = (_4310 * _196) - (_4308 * _198);
                                  _4319 = (_4308 * _197) - (_4309 * _196);
                                  _4320 = dot(float3(_4308, _4309, _4310), float3(_3276, _3277, _3278));
                                  _4321 = dot(float3(_4308, _4309, _4310), float3(_601, _602, _600));
                                  _4324 = dot(float3(_4313, _4316, _4319), float3(_3276, _3277, _3278));
                                  _4325 = dot(float3(_4313, _4316, _4319), float3(_601, _602, _600));
                                  _4331 = min(max((_3298 * (_256 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                  _4335 = min(max((_3298 * (1.0f - _256)), 0.0010000000474974513f), 1.0f);
                                  _4336 = _4335 * _4331;
                                  _4337 = ((_4321 + _4320) * _3330) * _4335;
                                  _4338 = ((_4325 + _4324) * _3330) * _4331;
                                  _4339 = _4336 * _3333;
                                  _4340 = dot(float3(_4337, _4338, _4339), float3(_4337, _4338, _4339));
                                  _4345 = _4331 * _4321;
                                  _4346 = _4335 * _4325;
                                  _4354 = _4331 * _4320;
                                  _4355 = _4335 * _4324;
                                  _4367 = (((_4336 * _4336) * _4336) / (_4340 * _4340));
                                  _4368 = saturate(0.5f / ((sqrt(((_4354 * _4354) + (_3432 * _3432)) + (_4355 * _4355)) * _3479) + (sqrt(((_4346 * _4346) + (_4345 * _4345)) + (_3479 * _3479)) * _3432)));
                                }
                                _4370 = (_4367 * _3432) * _4368;
                                _4388 = saturate((_3325 + 0.5f) * 0.6666666865348816f);
                                _4570 = (_4370 * _3474);
                                _4571 = (_4370 * _3475);
                                _4572 = (_4370 * _3476);
                                _4573 = ((_4388 * (1.0f - _3474)) * saturate((((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _3432));
                                _4574 = ((_4388 * (1.0f - _3475)) * saturate((((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _3432));
                                _4575 = ((_4388 * (1.0f - _3476)) * saturate((((_164 + -0.5f) * 0.5f) + 0.5f) + _3432));
                              } else {
                                if (_263) {
                                  _4403 = _315 * _315;
                                  _4404 = _4403 * _4403;
                                  _4410 = saturate(select((_3299 > 0.0f), ((1.0f - _4403) / _3299), 0.0f) * _3302);
                                  _4411 = (_4410 > 0.0f);
                                  if (_4411) {
                                    _4415 = sqrt(1.0f - (_4410 * _4410));
                                    _4417 = (_3325 * 2.0f) * _3326;
                                    _4418 = _4417 - _3327;
                                    if (!(_4418 >= _4415)) {
                                      _4424 = rsqrt(1.0f - (_4418 * _4418)) * _4410;
                                      _4427 = _4424 * (_3326 - (_4418 * _3325));
                                      _4428 = _3326 * _3326;
                                      _4433 = _4424 * (((_4428 * 2.0f) + -1.0f) - (_4418 * _3327));
                                      _4442 = sqrt(saturate((((1.0f - (_3325 * _3325)) - _4428) - (_3327 * _3327)) + (_4417 * _3327)));
                                      _4443 = _4442 * _4424;
                                      _4446 = ((_3326 * 2.0f) * _4424) * _4442;
                                      _4448 = (_4415 * _3325) + _3326;
                                      _4449 = _4448 + _4427;
                                      _4450 = _4415 * _3327;
                                      _4452 = (_4450 + 1.0f) + _4433;
                                      _4453 = _4443 * _4452;
                                      _4454 = _4449 * _4452;
                                      _4455 = _4446 * _4449;
                                      _4460 = (((_4449 * 0.25f) * _4446) - (_4453 * 0.5f)) * _4454;
                                      _4474 = (((_4455 - (_4453 * 2.0f)) * _4455) + (_4453 * _4453)) + ((((-0.5f - ((_4452 + _4450) * 0.5f)) * _4454) + ((_4452 * _4452) * _4448)) * _4449);
                                      _4479 = (_4460 * 2.0f) / ((_4474 * _4474) + (_4460 * _4460));
                                      _4480 = _4474 * _4479;
                                      _4482 = 1.0f - (_4460 * _4479);
                                      _4488 = ((_4480 * _4446) + _4450) + (_4482 * _4433);
                                      _4491 = rsqrt((_4488 * 2.0f) + 2.0f);
                                      _4500 = saturate((_4488 * _4491) + _4491);
                                      _4501 = saturate(((_4448 + (_4480 * _4443)) + (_4482 * _4427)) * _4491);
                                    } else {
                                      _4500 = _3477;
                                      _4501 = 1.0f;
                                    }
                                  } else {
                                    _4500 = _3336;
                                    _4501 = _3333;
                                  }
                                  if (_3434) {
                                    _4510 = saturate(((_3304 * _3304) / ((_4500 * 3.5999999046325684f) + 0.4000000059604645f)) + _4404);
                                  } else {
                                    _4510 = _4404;
                                  }
                                  _4511 = sqrt(_4510);
                                  if (_4411) {
                                    _4522 = (_4510 / ((((_4410 * 0.25f) * ((_4511 * 3.0f) + _4410)) / (_4500 + 0.0010000000474974513f)) + _4510));
                                  } else {
                                    _4522 = 1.0f;
                                  }
                                  _4526 = (((_4510 * _4501) - _4501) * _4501) + 1.0f;
                                  _4536 = 1.0f - _4511;
                                  _4551 = ((((exp2(log2(1.0f - saturate(_4500)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _314) * (((_4522 * _3431) * (_4510 / (_4526 * _4526))) * (0.5f / ((((_4536 * _3479) + _4511) * _3431) + (((_4536 * _3431) + _4511) * _3479)))));
                                  _4552 = false;
                                } else {
                                  _4551 = 0.0f;
                                  _4552 = true;
                                }
                                _4556 = saturate((_3325 + _2139) / (_2139 + 1.0f));
                                _4558 = (_3462 * _3431) * _3488;
                                _4562 = _4551 + (_4558 * _3474);
                                _4563 = _4551 + (_4558 * _3475);
                                _4564 = _4551 + (_4558 * _3476);
                                [branch]
                                if (_4552) {
                                  _4570 = (_4562 * _1337);
                                  _4571 = (_4563 * _1338);
                                  _4572 = (_4564 * _1339);
                                  _4573 = _4556;
                                  _4574 = _4556;
                                  _4575 = _4556;
                                } else {
                                  _4570 = _4562;
                                  _4571 = _4563;
                                  _4572 = _4564;
                                  _4573 = _4556;
                                  _4574 = _4556;
                                  _4575 = _4556;
                                }
                              }
                            }
                          }
                          _4576 = _3159 * _1932;
                          _4577 = _3160 * _1932;
                          _4578 = _3161 * _1932;
                          _4585 = ((_3272 * _4576) * _4573) + _1869;
                          _4586 = ((_3272 * _4577) * _4574) + _1870;
                          _4587 = ((_3272 * _4578) * _4575) + _1871;
                          if (_2136 > 0.0f) {
                            _4590 = (_2136 * _1633) * select(_3269, (_3265 * _1480), _3265);
                            _4601 = (((_4590 * _4576) * _4570) + _1872);
                            _4602 = (((_4590 * _4577) * _4571) + _1873);
                            _4603 = (((_4590 * _4578) * _4572) + _1874);
                          } else {
                            _4601 = _1872;
                            _4602 = _1873;
                            _4603 = _1874;
                          }
                          _4607 = _4601 + (_3219 * _4576);
                          _4608 = _4602 + (_3220 * _4577);
                          _4609 = _4603 + (_3221 * _4578);
                          if (!_326) {
                            _4616 = saturate(-0.0f - dot(float3(_601, _602, _600), float3(_2074, _2075, _2076)));
                            _4619 = 1.0f - ((_4616 * _4616) * 0.6399999856948853f);
                            _4624 = saturate(0.30000001192092896f - _2188) * (0.36000001430511475f / (_4619 * _4619));
                            _4625 = _2239 * _1932;
                            _14768 = _4585;
                            _14769 = _4586;
                            _14770 = _4587;
                            _14771 = ((((_333 * _258) * _4625) * _4624) + _4607);
                            _14772 = ((((_334 * _258) * _4625) * _4624) + _4608);
                            _14773 = ((((_335 * _258) * _4625) * _4624) + _4609);
                          } else {
                            _14768 = _4585;
                            _14769 = _4586;
                            _14770 = _4587;
                            _14771 = _4607;
                            _14772 = _4608;
                            _14773 = _4609;
                          }
                        } else {
                          _14768 = _1869;
                          _14769 = _1870;
                          _14770 = _1871;
                          _14771 = _1872;
                          _14772 = _1873;
                          _14773 = _1874;
                        }
                        break;
                      }
                    } else {
                      _14768 = _1869;
                      _14769 = _1870;
                      _14770 = _1871;
                      _14771 = _1872;
                      _14772 = _1873;
                      _14773 = _1874;
                    }
                  } else {
                    if (_1915 == 7) {
                      _6337 = asfloat(srvLightInfoProperties.Load3(_1883)).x;
                      _6338 = asfloat(srvLightInfoProperties.Load3(_1883)).y;
                      _6339 = asfloat(srvLightInfoProperties.Load3(_1883)).z;
                      _6342 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 12u)))).x;
                      _6343 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 12u)))).y;
                      _6344 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 12u)))).z;
                      _6347 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 24u)))).x;
                      _6348 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 24u)))).y;
                      _6349 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 24u)))).z;
                      _6352 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 36u)))).x;
                      _6353 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 36u)))).y;
                      _6354 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 36u)))).z;
                      _6357 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).x;
                      _6358 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).y;
                      _6359 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 48u)))).z;
                      _6362 = asint(srvLightInfoProperties.Load(((int)(_1883 + 60u))));
                      _6365 = asint(srvLightInfoProperties.Load(((int)(_1883 + 64u))));
                      _6368 = asint(srvLightInfoProperties.Load(((int)(_1883 + 72u))));
                      _6371 = asint(srvLightInfoProperties.Load(((int)(_1883 + 76u))));
                      _6374 = asint(srvLightInfoProperties.Load(((int)(_1883 + 80u))));
                      _6377 = asint(srvLightInfoProperties.Load(((int)(_1883 + 84u))));
                      _6380 = asint(srvLightInfoProperties.Load(((int)(_1883 + 88u))));
                      _6383 = asint(srvLightInfoProperties.Load(((int)(_1883 + 92u))));
                      _6386 = asint(srvLightInfoProperties.Load(((int)(_1883 + 96u))));
                      _6389 = asint(srvLightInfoProperties.Load(((int)(_1883 + 100u))));
                      _6392 = asint(srvLightInfoProperties.Load(((int)(_1883 + 104u))));
                      _6395 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).x;
                      _6396 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).y;
                      _6397 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).z;
                      _6398 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).w;
                      _6401 = asint(srvLightInfoProperties.Load(((int)(_1883 + 124u))));
                      _6404 = asint(srvLightInfoProperties.Load(((int)(_1883 + 128u))));
                      _6407 = asint(srvLightInfoProperties.Load(((int)(_1883 + 132u))));
                      _6410 = asint(srvLightInfoProperties.Load(((int)(_1883 + 136u))));
                      _6413 = asint(srvLightInfoProperties.Load(((int)(_1883 + 140u))));
                      _6415 = f16tof32(((uint)((uint)(_6362) >> 16)));
                      _6416 = f16tof32(_6362);
                      _6418 = f16tof32(((uint)((uint)(_6365) >> 16)));
                      _6422 = ((float)((uint)((uint)(((uint)(_6365) >> 8) & 255)))) * 0.003921499941498041f;
                      _6425 = ((float)((uint)((uint)(_6365 & 255)))) * 0.003921499941498041f;
                      _6426 = f16tof32(_6368);
                      _6428 = f16tof32(((uint)((uint)(_6371) >> 16)));
                      _6432 = f16tof32(_6374);
                      _6434 = f16tof32(((uint)((uint)(_6377) >> 16)));
                      _6435 = f16tof32(_6377);
                      _6437 = f16tof32(((uint)((uint)(_6380) >> 16)));
                      _6438 = f16tof32(_6380);
                      _6440 = _6383 & 65535;
                      _6444 = ((_1881 & 4194304) != 0);
                      _6452 = f16tof32(((uint)((uint)(_6392) >> 16)));
                      _6453 = f16tof32(_6392);
                      _6455 = f16tof32(((uint)((uint)(_6401) >> 16)));
                      _6458 = f16tof32(((uint)((uint)(_6404) >> 16)));
                      _6459 = f16tof32(_6404);
                      _6461 = f16tof32(((uint)((uint)(_6407) >> 16)));
                      _6462 = f16tof32(_6407);
                      _6464 = f16tof32(((uint)((uint)(_6410) >> 16)));
                      _6465 = _6464 + -1.0f;
                      if (_6444) {
                        _6467 = 0.5f / _6464;
                        _6468 = 0.3333333432674408f / _6464;
                        _6472 = (_6464 * 0.5f) + 0.5f;
                        _6482 = (_6467 * _6465);
                        _6483 = (_6468 * _6465);
                        _6484 = (_6467 * _6472);
                        _6485 = (_6468 * _6472);
                        _6486 = (_6464 * 2.0f);
                        _6487 = (_6464 * 3.0f);
                        _6488 = _6467;
                        _6489 = _6468;
                      } else {
                        _6478 = 1.0f / _6464;
                        _6479 = _6478 * _6465;
                        _6480 = _6478 * 0.5f;
                        _6482 = _6479;
                        _6483 = _6479;
                        _6484 = _6480;
                        _6485 = _6480;
                        _6486 = _6464;
                        _6487 = _6464;
                        _6488 = _6478;
                        _6489 = _6478;
                      }
                      _6498 = _318 && (_317 && ((cbSharedPerViewData.nLightingShadowFeatures & 1) != 0));
                      _6499 = _6352 - _379;
                      _6500 = _6353 - _380;
                      _6501 = _6354 + _378;
                      _6502 = dot(float3(_6499, _6500, _6501), float3(_6499, _6500, _6501));
                      _6503 = rsqrt(_6502);
                      _6504 = _6503 * _6502;
                      _6505 = _6503 * _6499;
                      _6506 = _6503 * _6500;
                      _6507 = _6503 * _6501;
                      _6510 = max(0.0f, (_6504 - abs(_6432)));
                      _6511 = _6510 * f16tof32(((uint)((uint)(_6374) >> 16)));
                      _6512 = _6511 * _6511;
                      _6515 = saturate(1.0f - (_6512 * _6512));
                      _6522 = (_6515 * _6515) / (select((_6432 < 0.0f), (_6512 * 16.0f), (_6510 * _6510)) + 1.0f);
                      _6532 = dot(float3(_196, _197, _198), float3(_6505, _6506, _6507));
                      _6535 = saturate(1.0f - _6532) * f16tof32(_6401);
                      _6539 = abs(_6501);
                      _6543 = _6499 - ((_6535 * _196) * _6539);
                      _6544 = _6500 - ((_6535 * _197) * _6539);
                      _6545 = _6501 - ((_6535 * _198) * _6539);
                      _6548 = mad(_6545, _6348, mad(_6544, _6343, (_6543 * _6338)));
                      _6551 = mad(_6545, _6349, mad(_6544, _6344, (_6543 * _6339)));
                      _6553 = ((_1881 & 3584) != 0);
                      if (_6553 && (_6522 > 0.0f)) {
                        _6559 = mad(_6545, _6347, mad(_6544, _6342, (_6543 * _6337)));
                        _6560 = -0.0f - _6551;
                        _6561 = -0.0f - _6548;
                        [branch]
                        if (!((_1881 & 1024) == 0)) {
                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6383) >> 16))];
                          [branch]
                          if (_6444) {
                            _6566 = abs(_6559);
                            _6567 = abs(_6560);
                            _6568 = abs(_6561);
                            if (_6566 > max(_6567, _6568)) {
                              _6572 = (_6559 > 0.0f);
                              _6587 = select(_6572, 0.0f, 1.0f);
                              _6588 = 0.0f;
                              _6589 = select(_6572, _6548, _6561);
                              _6590 = _6551;
                              _6591 = _6566;
                            } else {
                              if (_6567 > _6568) {
                                _6578 = (_6551 < -0.0f);
                                _6587 = select(_6578, 0.0f, 1.0f);
                                _6588 = 1.0f;
                                _6589 = _6559;
                                _6590 = select(_6578, _6561, _6548);
                                _6591 = _6567;
                              } else {
                                _6582 = (_6548 < -0.0f);
                                _6587 = select(_6582, 0.0f, 1.0f);
                                _6588 = 2.0f;
                                _6589 = select(_6582, _6559, (-0.0f - _6559));
                                _6590 = _6551;
                                _6591 = _6568;
                              }
                            }
                            _6592 = _6591 * 2.0f;
                            _6597 = -0.0f - _6453;
                            _6606 = ((min(max((_6589 / _6592), _6597), _6453) + _6587) * _6482) + _6484;
                            _6607 = ((min(max((_6590 / _6592), _6597), _6453) + _6588) * _6483) + _6485;
                            _6608 = (1.0f - (_6591 * _6437)) + _6455;
                            _6609 = select(_6498, _6461, _6458);
                            _6614 = ((_6587 + -0.5f) * _6482) + _6484;
                            _6615 = ((_6588 + -0.5f) * _6483) + _6485;
                            _6618 = saturate(_6608);
                            _6622 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _6631 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 2u) : (frac(frac(dot(float2(((_6622 * 32.665000915527344f) + _362), ((_6622 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _6632 = sin(_6631);
                            _6633 = cos(_6631);
                            _6638 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_6606, _6607), 0.0f))).x) > _6618), 1.0f, 0.0f);
                            _6639 = cbSharedPerViewData.nFrameCounter & 3;
                            _6644 = sqrt((float((int)(_6639)) * 0.25f) + 0.125f) * _6609;
                            _6653 = (_global_7[min((uint)(((int)(0u + (_6639 * 2)))), 127u)]) * _6644;
                            _6654 = (_global_7[min((uint)(((int)(1u + (_6639 * 2)))), 127u)]) * _6644;
                            _6656 = -0.0f - _6632;
                            _6658 = dot(float2(_6653, _6654), float2(_6633, _6632)) + _6606;
                            _6659 = dot(float2(_6653, _6654), float2(_6656, _6633)) + _6607;
                            _6661 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_6658, _6659));
                            _6665 = _6658 * _6486;
                            _6666 = _6659 * _6487;
                            _6669 = floor(_6614 * _6486);
                            _6670 = floor(_6615 * _6487);
                            _6675 = floor(((_6614 + _6482) * _6486) + 0.5f);
                            _6676 = floor(((_6615 + _6483) * _6487) + 0.5f);
                            _6679 = floor(_6665 + -0.5f);
                            _6680 = floor(_6666 + 0.5f);
                            _6682 = floor(_6665 + 0.5f);
                            _6684 = floor(_6666 + -0.5f);
                            _6685 = (_6679 < _6669);
                            _6686 = (_6680 < _6670);
                            if ((_6685 || _6686) | ((_6679 >= _6675) || (_6680 >= _6676))) {
                              _6695 = _6638;
                            } else {
                              _6695 = _6661.x;
                            }
                            _6696 = (_6682 < _6669);
                            if ((_6696 || _6686) | ((_6682 >= _6675) || (_6680 >= _6676))) {
                              _6704 = _6638;
                            } else {
                              _6704 = _6661.y;
                            }
                            _6705 = (_6684 < _6670);
                            if ((_6696 || _6705) | ((_6682 >= _6675) || (_6684 >= _6676))) {
                              _6713 = _6638;
                            } else {
                              _6713 = _6661.z;
                            }
                            if ((_6685 || _6705) | ((_6679 >= _6675) || (_6684 >= _6676))) {
                              _6721 = _6638;
                            } else {
                              _6721 = _6661.w;
                            }
                            _6722 = _6695 - _6618;
                            _6724 = select((_6722 < 0.0f), 0.0f, 1.0f);
                            _6726 = _6704 - _6618;
                            _6728 = select((_6726 < 0.0f), 0.0f, 1.0f);
                            _6732 = _6713 - _6618;
                            _6734 = select((_6732 < 0.0f), 0.0f, 1.0f);
                            _6738 = _6721 - _6618;
                            _6740 = select((_6738 < 0.0f), 0.0f, 1.0f);
                            _6747 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _6752 = sqrt((float((int)(_6747)) * 0.25f) + 0.125f) * _6609;
                            _6761 = (_global_7[min((uint)(((int)(0u + (_6747 * 2)))), 127u)]) * _6752;
                            _6762 = (_global_7[min((uint)(((int)(1u + (_6747 * 2)))), 127u)]) * _6752;
                            _6765 = dot(float2(_6761, _6762), float2(_6633, _6632)) + _6606;
                            _6766 = dot(float2(_6761, _6762), float2(_6656, _6633)) + _6607;
                            _6768 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_6765, _6766));
                            _6772 = _6765 * _6486;
                            _6773 = _6766 * _6487;
                            _6776 = floor(_6772 + -0.5f);
                            _6777 = floor(_6773 + 0.5f);
                            _6779 = floor(_6772 + 0.5f);
                            _6781 = floor(_6773 + -0.5f);
                            _6782 = (_6776 < _6669);
                            _6783 = (_6777 < _6670);
                            if ((_6782 || _6783) | ((_6776 >= _6675) || (_6777 >= _6676))) {
                              _6792 = _6638;
                            } else {
                              _6792 = _6768.x;
                            }
                            _6793 = (_6779 < _6669);
                            if ((_6793 || _6783) | ((_6779 >= _6675) || (_6777 >= _6676))) {
                              _6801 = _6638;
                            } else {
                              _6801 = _6768.y;
                            }
                            _6802 = (_6781 < _6670);
                            if ((_6793 || _6802) | ((_6779 >= _6675) || (_6781 >= _6676))) {
                              _6810 = _6638;
                            } else {
                              _6810 = _6768.z;
                            }
                            if ((_6782 || _6802) | ((_6776 >= _6675) || (_6781 >= _6676))) {
                              _6818 = _6638;
                            } else {
                              _6818 = _6768.w;
                            }
                            _6819 = _6792 - _6618;
                            _6821 = select((_6819 < 0.0f), 0.0f, 1.0f);
                            _6825 = _6801 - _6618;
                            _6827 = select((_6825 < 0.0f), 0.0f, 1.0f);
                            _6831 = _6810 - _6618;
                            _6833 = select((_6831 < 0.0f), 0.0f, 1.0f);
                            _6837 = _6818 - _6618;
                            _6839 = select((_6837 < 0.0f), 0.0f, 1.0f);
                            _6846 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _6851 = sqrt((float((int)(_6846)) * 0.25f) + 0.125f) * _6609;
                            _6860 = (_global_7[min((uint)(((int)(0u + (_6846 * 2)))), 127u)]) * _6851;
                            _6861 = (_global_7[min((uint)(((int)(1u + (_6846 * 2)))), 127u)]) * _6851;
                            _6864 = dot(float2(_6860, _6861), float2(_6633, _6632)) + _6606;
                            _6865 = dot(float2(_6860, _6861), float2(_6656, _6633)) + _6607;
                            _6867 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_6864, _6865));
                            _6871 = _6864 * _6486;
                            _6872 = _6865 * _6487;
                            _6875 = floor(_6871 + -0.5f);
                            _6876 = floor(_6872 + 0.5f);
                            _6878 = floor(_6871 + 0.5f);
                            _6880 = floor(_6872 + -0.5f);
                            _6881 = (_6875 < _6669);
                            _6882 = (_6876 < _6670);
                            if ((_6881 || _6882) | ((_6875 >= _6675) || (_6876 >= _6676))) {
                              _6891 = _6638;
                            } else {
                              _6891 = _6867.x;
                            }
                            _6892 = (_6878 < _6669);
                            if ((_6892 || _6882) | ((_6878 >= _6675) || (_6876 >= _6676))) {
                              _6900 = _6638;
                            } else {
                              _6900 = _6867.y;
                            }
                            _6901 = (_6880 < _6670);
                            if ((_6892 || _6901) | ((_6878 >= _6675) || (_6880 >= _6676))) {
                              _6909 = _6638;
                            } else {
                              _6909 = _6867.z;
                            }
                            if ((_6881 || _6901) | ((_6875 >= _6675) || (_6880 >= _6676))) {
                              _6917 = _6638;
                            } else {
                              _6917 = _6867.w;
                            }
                            _6918 = _6891 - _6618;
                            _6920 = select((_6918 < 0.0f), 0.0f, 1.0f);
                            _6924 = _6900 - _6618;
                            _6926 = select((_6924 < 0.0f), 0.0f, 1.0f);
                            _6930 = _6909 - _6618;
                            _6932 = select((_6930 < 0.0f), 0.0f, 1.0f);
                            _6936 = _6917 - _6618;
                            _6938 = select((_6936 < 0.0f), 0.0f, 1.0f);
                            _6945 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _6950 = sqrt((float((int)(_6945)) * 0.25f) + 0.125f) * _6609;
                            _6959 = (_global_7[min((uint)(((int)(0u + (_6945 * 2)))), 127u)]) * _6950;
                            _6960 = (_global_7[min((uint)(((int)(1u + (_6945 * 2)))), 127u)]) * _6950;
                            _6963 = dot(float2(_6959, _6960), float2(_6633, _6632)) + _6606;
                            _6964 = dot(float2(_6959, _6960), float2(_6656, _6633)) + _6607;
                            _6966 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_6963, _6964));
                            _6970 = _6963 * _6486;
                            _6971 = _6964 * _6487;
                            _6974 = floor(_6970 + -0.5f);
                            _6975 = floor(_6971 + 0.5f);
                            _6977 = floor(_6970 + 0.5f);
                            _6979 = floor(_6971 + -0.5f);
                            _6980 = (_6974 < _6669);
                            _6981 = (_6975 < _6670);
                            if ((_6980 || _6981) | ((_6974 >= _6675) || (_6975 >= _6676))) {
                              _6990 = _6638;
                            } else {
                              _6990 = _6966.x;
                            }
                            _6991 = (_6977 < _6669);
                            if ((_6991 || _6981) | ((_6977 >= _6675) || (_6975 >= _6676))) {
                              _6999 = _6638;
                            } else {
                              _6999 = _6966.y;
                            }
                            _7000 = (_6979 < _6670);
                            if ((_6991 || _7000) | ((_6977 >= _6675) || (_6979 >= _6676))) {
                              _7008 = _6638;
                            } else {
                              _7008 = _6966.z;
                            }
                            if ((_6980 || _7000) | ((_6974 >= _6675) || (_6979 >= _6676))) {
                              _7016 = _6638;
                            } else {
                              _7016 = _6966.w;
                            }
                            _7017 = _6990 - _6618;
                            _7019 = select((_7017 < 0.0f), 0.0f, 1.0f);
                            _7023 = _6999 - _6618;
                            _7025 = select((_7023 < 0.0f), 0.0f, 1.0f);
                            _7029 = _7008 - _6618;
                            _7031 = select((_7029 < 0.0f), 0.0f, 1.0f);
                            _7035 = _7016 - _6618;
                            _7037 = select((_7035 < 0.0f), 0.0f, 1.0f);
                            _7038 = ((((((((((((((_6728 + _6724) + _6734) + _6740) + _6821) + _6827) + _6833) + _6839) + _6920) + _6926) + _6932) + _6938) + _7019) + _7025) + _7031) + _7037;
                            _7049 = (saturate(_7038 * 0.0625f) * 2.0f) + -1.0f;
                            _7055 = float((int)(((int)(uint)((int)(_7049 > 0.0f))) - ((int)(uint)((int)(_7049 < 0.0f)))));
                            _7057 = 1.0f - (_7055 * _7049);
                            _7059 = (_7057 * _7057) * _7057;
                            _7406 = (0.5f - ((_7055 * 0.5f) * ((1.0f - _7059) - ((_7057 - _7059) * saturate(((1.0f / _6618) * (1.0f / _7038)) * ((((((((((((((((_6728 * _6726) + (_6724 * _6722)) + (_6734 * _6732)) + (_6740 * _6738)) + (_6821 * _6819)) + (_6827 * _6825)) + (_6833 * _6831)) + (_6839 * _6837)) + (_6920 * _6918)) + (_6926 * _6924)) + (_6932 * _6930)) + (_6938 * _6936)) + (_7019 * _7017)) + (_7025 * _7023)) + (_7031 * _7029)) + (_7037 * _7035)))))));
                            _7407 = (((float4)(_HeapResource_22.SampleCmpLevelZero(samplerLinearPCFBorderBlackNode, float2(_6606, _6607), _6608))).x);
                            _7408 = 1.0f;
                            _7409 = 1;
                            _7410 = _6438;
                          } else {
                            _7071 = f16tof32(_6413) / _6561;
                            _7074 = mad((_7071 * _6559), 0.5f, 0.5f);
                            _7075 = mad((_7071 * _6560), 0.5f, 0.5f);
                            _7078 = (1.0f - (_6548 * _6437)) + _6455;
                            if (_6548 > -0.0f) {
                              if ((saturate(_7074) == _7074) && (saturate(_7075) == _7075)) {
                                _7089 = (_7074 * _6482) + _6484;
                                _7090 = (_7075 * _6483) + _6485;
                                _7091 = select(_6498, _6461, _6458);
                                _7092 = saturate(_7078);
                                _7096 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _7105 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 3u) : (frac(frac(dot(float2(((_7096 * 32.665000915527344f) + _362), ((_7096 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7106 = sin(_7105);
                                _7107 = cos(_7105);
                                _7108 = cbSharedPerViewData.nFrameCounter & 3;
                                _7113 = sqrt((float((int)(_7108)) * 0.25f) + 0.125f) * _7091;
                                _7122 = (_global_7[min((uint)(((int)(0u + (_7108 * 2)))), 127u)]) * _7113;
                                _7123 = (_global_7[min((uint)(((int)(1u + (_7108 * 2)))), 127u)]) * _7113;
                                _7125 = -0.0f - _7106;
                                _7130 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_7122, _7123), float2(_7107, _7106)) + _7089), (dot(float2(_7122, _7123), float2(_7125, _7107)) + _7090)));
                                _7135 = _7130.x - _7092;
                                _7137 = select((_7135 < 0.0f), 0.0f, 1.0f);
                                _7139 = _7130.y - _7092;
                                _7141 = select((_7139 < 0.0f), 0.0f, 1.0f);
                                _7145 = _7130.z - _7092;
                                _7147 = select((_7145 < 0.0f), 0.0f, 1.0f);
                                _7151 = _7130.w - _7092;
                                _7153 = select((_7151 < 0.0f), 0.0f, 1.0f);
                                _7160 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _7165 = sqrt((float((int)(_7160)) * 0.25f) + 0.125f) * _7091;
                                _7174 = (_global_7[min((uint)(((int)(0u + (_7160 * 2)))), 127u)]) * _7165;
                                _7175 = (_global_7[min((uint)(((int)(1u + (_7160 * 2)))), 127u)]) * _7165;
                                _7181 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_7174, _7175), float2(_7107, _7106)) + _7089), (dot(float2(_7174, _7175), float2(_7125, _7107)) + _7090)));
                                _7186 = _7181.x - _7092;
                                _7188 = select((_7186 < 0.0f), 0.0f, 1.0f);
                                _7192 = _7181.y - _7092;
                                _7194 = select((_7192 < 0.0f), 0.0f, 1.0f);
                                _7198 = _7181.z - _7092;
                                _7200 = select((_7198 < 0.0f), 0.0f, 1.0f);
                                _7204 = _7181.w - _7092;
                                _7206 = select((_7204 < 0.0f), 0.0f, 1.0f);
                                _7213 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _7218 = sqrt((float((int)(_7213)) * 0.25f) + 0.125f) * _7091;
                                _7227 = (_global_7[min((uint)(((int)(0u + (_7213 * 2)))), 127u)]) * _7218;
                                _7228 = (_global_7[min((uint)(((int)(1u + (_7213 * 2)))), 127u)]) * _7218;
                                _7234 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_7227, _7228), float2(_7107, _7106)) + _7089), (dot(float2(_7227, _7228), float2(_7125, _7107)) + _7090)));
                                _7239 = _7234.x - _7092;
                                _7241 = select((_7239 < 0.0f), 0.0f, 1.0f);
                                _7245 = _7234.y - _7092;
                                _7247 = select((_7245 < 0.0f), 0.0f, 1.0f);
                                _7251 = _7234.z - _7092;
                                _7253 = select((_7251 < 0.0f), 0.0f, 1.0f);
                                _7257 = _7234.w - _7092;
                                _7259 = select((_7257 < 0.0f), 0.0f, 1.0f);
                                _7266 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _7271 = sqrt((float((int)(_7266)) * 0.25f) + 0.125f) * _7091;
                                _7280 = (_global_7[min((uint)(((int)(0u + (_7266 * 2)))), 127u)]) * _7271;
                                _7281 = (_global_7[min((uint)(((int)(1u + (_7266 * 2)))), 127u)]) * _7271;
                                _7287 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_7280, _7281), float2(_7107, _7106)) + _7089), (dot(float2(_7280, _7281), float2(_7125, _7107)) + _7090)));
                                _7292 = _7287.x - _7092;
                                _7294 = select((_7292 < 0.0f), 0.0f, 1.0f);
                                _7298 = _7287.y - _7092;
                                _7300 = select((_7298 < 0.0f), 0.0f, 1.0f);
                                _7304 = _7287.z - _7092;
                                _7306 = select((_7304 < 0.0f), 0.0f, 1.0f);
                                _7310 = _7287.w - _7092;
                                _7312 = select((_7310 < 0.0f), 0.0f, 1.0f);
                                _7313 = ((((((((((((((_7137 + _7141) + _7147) + _7153) + _7188) + _7194) + _7200) + _7206) + _7241) + _7247) + _7253) + _7259) + _7294) + _7300) + _7306) + _7312;
                                _7324 = (saturate(_7313 * 0.0625f) * 2.0f) + -1.0f;
                                _7330 = float((int)(((int)(uint)((int)(_7324 > 0.0f))) - ((int)(uint)((int)(_7324 < 0.0f)))));
                                _7332 = 1.0f - (_7330 * _7324);
                                _7334 = (_7332 * _7332) * _7332;
                                _7342 = -0.0f - _6559;
                                _7349 = saturate((saturate(rsqrt(dot(float3(_7342, _6551, _6548), float3(_7342, _6551, _6548))) * _6548) * _6435) + _6434);
                                _7351 = 1.0f - (_7349 * _7349);
                                _7358 = frac((_7089 * _6486) + 0.5f);
                                _7359 = frac((_7090 * _6487) + 0.5f);
                                _7360 = _7089 + _6488;
                                _7361 = _7090 + _6489;
                                _7363 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7360, _7361), _7078);
                                _7372 = _7360 - (_6488 * 2.0f);
                                _7373 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7372, _7361), _7078);
                                _7378 = 1.0f - _7358;
                                _7384 = _7361 - (_6489 * 2.0f);
                                _7385 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7372, _7384), _7078);
                                _7390 = 1.0f - _7359;
                                _7395 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7360, _7384), _7078);
                                _7406 = (0.5f - ((_7330 * 0.5f) * ((1.0f - _7334) - ((_7332 - _7334) * saturate(((1.0f / _7092) * (1.0f / _7313)) * ((((((((((((((((_7137 * _7135) + (_7141 * _7139)) + (_7147 * _7145)) + (_7153 * _7151)) + (_7188 * _7186)) + (_7194 * _7192)) + (_7200 * _7198)) + (_7206 * _7204)) + (_7241 * _7239)) + (_7247 * _7245)) + (_7253 * _7251)) + (_7259 * _7257)) + (_7294 * _7292)) + (_7300 * _7298)) + (_7306 * _7304)) + (_7312 * _7310)))))));
                                _7407 = ((((mad(mad(_7373.x, _7378, _7373.y), _7359, mad(_7373.w, _7378, _7373.z)) + mad(mad(_7363.y, _7358, _7363.x), _7359, mad(_7363.z, _7358, _7363.w))) + mad(mad(_7385.w, _7378, _7385.z), _7390, mad(_7385.x, _7378, _7385.y))) + mad(mad(_7395.z, _7358, _7395.w), _7390, mad(_7395.y, _7358, _7395.x))) * 0.1111111119389534f);
                                _7408 = (1.0f - (_7351 * _7351));
                                _7409 = 1;
                                _7410 = _6438;
                              } else {
                                _7406 = 1.0f;
                                _7407 = 0.0f;
                                _7408 = 1.0f;
                                _7409 = 0;
                                _7410 = _6438;
                              }
                            } else {
                              _7406 = 1.0f;
                              _7407 = 0.0f;
                              _7408 = 1.0f;
                              _7409 = 0;
                              _7410 = _6438;
                            }
                          }
                        } else {
                          _7406 = 1.0f;
                          _7407 = 1.0f;
                          _7408 = 1.0f;
                          _7409 = 0;
                          _7410 = 0.0f;
                        }
                        [branch]
                        if (!((_1881 & 512) == 0)) {
                          Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                          [branch]
                          if (!((_1881 & 2097152) == 0)) {
                            _7418 = abs(_6559);
                            _7419 = abs(_6560);
                            _7420 = abs(_6561);
                            if (_7418 > max(_7419, _7420)) {
                              _7424 = (_6559 > 0.0f);
                              _7439 = select(_7424, 0.0f, 1.0f);
                              _7440 = 0.0f;
                              _7441 = select(_7424, _6548, _6561);
                              _7442 = _6551;
                              _7443 = _7418;
                            } else {
                              if (_7419 > _7420) {
                                _7430 = (_6551 < -0.0f);
                                _7439 = select(_7430, 0.0f, 1.0f);
                                _7440 = 1.0f;
                                _7441 = _6559;
                                _7442 = select(_7430, _6561, _6548);
                                _7443 = _7419;
                              } else {
                                _7434 = (_6548 < -0.0f);
                                _7439 = select(_7434, 0.0f, 1.0f);
                                _7440 = 2.0f;
                                _7441 = select(_7434, _6559, (-0.0f - _6559));
                                _7442 = _6551;
                                _7443 = _7420;
                              }
                            }
                            _7444 = _7443 * 2.0f;
                            _7449 = -0.0f - _6452;
                            _7458 = ((min(max((_7441 / _7444), _7449), _6452) + _7439) * _6395) + _6397;
                            _7459 = ((min(max((_7442 / _7444), _7449), _6452) + _7440) * _6396) + _6398;
                            _7460 = select(_6498, _6462, _6459);
                            _7465 = ((_7439 + -0.5f) * _6395) + _6397;
                            _7466 = ((_7440 + -0.5f) * _6396) + _6398;
                            _7469 = saturate(1.0f - (_7443 * _6437));
                            _7473 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                            _7482 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 4u) : (frac(frac(dot(float2(((_7473 * 32.665000915527344f) + _362), ((_7473 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                            _7483 = sin(_7482);
                            _7484 = cos(_7482);
                            _7489 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_7458, _7459), 0.0f))).x) > _7469), 1.0f, 0.0f);
                            _7490 = cbSharedPerViewData.nFrameCounter & 3;
                            _7495 = sqrt((float((int)(_7490)) * 0.25f) + 0.125f) * _7460;
                            _7504 = (_global_7[min((uint)(((int)(0u + (_7490 * 2)))), 127u)]) * _7495;
                            _7505 = (_global_7[min((uint)(((int)(1u + (_7490 * 2)))), 127u)]) * _7495;
                            _7507 = -0.0f - _7483;
                            _7509 = dot(float2(_7504, _7505), float2(_7484, _7483)) + _7458;
                            _7510 = dot(float2(_7504, _7505), float2(_7507, _7484)) + _7459;
                            _7512 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_7509, _7510));
                            _7516 = _7509 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _7517 = _7510 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _7520 = floor(_7465 * cbSharedPerViewData.vShadowAtlasSize.x);
                            _7521 = floor(_7466 * cbSharedPerViewData.vShadowAtlasSize.y);
                            _7526 = floor(((_7465 + _6395) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                            _7527 = floor(((_7466 + _6396) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                            _7530 = floor(_7516 + -0.5f);
                            _7531 = floor(_7517 + 0.5f);
                            _7533 = floor(_7516 + 0.5f);
                            _7535 = floor(_7517 + -0.5f);
                            _7536 = (_7530 < _7520);
                            _7537 = (_7531 < _7521);
                            if ((_7536 || _7537) | ((_7530 >= _7526) || (_7531 >= _7527))) {
                              _7546 = _7489;
                            } else {
                              _7546 = _7512.x;
                            }
                            _7547 = (_7533 < _7520);
                            if ((_7547 || _7537) | ((_7533 >= _7526) || (_7531 >= _7527))) {
                              _7555 = _7489;
                            } else {
                              _7555 = _7512.y;
                            }
                            _7556 = (_7535 < _7521);
                            if ((_7547 || _7556) | ((_7533 >= _7526) || (_7535 >= _7527))) {
                              _7564 = _7489;
                            } else {
                              _7564 = _7512.z;
                            }
                            if ((_7536 || _7556) | ((_7530 >= _7526) || (_7535 >= _7527))) {
                              _7572 = _7489;
                            } else {
                              _7572 = _7512.w;
                            }
                            _7573 = _7546 - _7469;
                            _7575 = select((_7573 < 0.0f), 0.0f, 1.0f);
                            _7577 = _7555 - _7469;
                            _7579 = select((_7577 < 0.0f), 0.0f, 1.0f);
                            _7583 = _7564 - _7469;
                            _7585 = select((_7583 < 0.0f), 0.0f, 1.0f);
                            _7589 = _7572 - _7469;
                            _7591 = select((_7589 < 0.0f), 0.0f, 1.0f);
                            _7598 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                            _7603 = sqrt((float((int)(_7598)) * 0.25f) + 0.125f) * _7460;
                            _7612 = (_global_7[min((uint)(((int)(0u + (_7598 * 2)))), 127u)]) * _7603;
                            _7613 = (_global_7[min((uint)(((int)(1u + (_7598 * 2)))), 127u)]) * _7603;
                            _7616 = dot(float2(_7612, _7613), float2(_7484, _7483)) + _7458;
                            _7617 = dot(float2(_7612, _7613), float2(_7507, _7484)) + _7459;
                            _7619 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_7616, _7617));
                            _7623 = _7616 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _7624 = _7617 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _7627 = floor(_7623 + -0.5f);
                            _7628 = floor(_7624 + 0.5f);
                            _7630 = floor(_7623 + 0.5f);
                            _7632 = floor(_7624 + -0.5f);
                            _7633 = (_7627 < _7520);
                            _7634 = (_7628 < _7521);
                            if ((_7633 || _7634) | ((_7627 >= _7526) || (_7628 >= _7527))) {
                              _7643 = _7489;
                            } else {
                              _7643 = _7619.x;
                            }
                            _7644 = (_7630 < _7520);
                            if ((_7644 || _7634) | ((_7630 >= _7526) || (_7628 >= _7527))) {
                              _7652 = _7489;
                            } else {
                              _7652 = _7619.y;
                            }
                            _7653 = (_7632 < _7521);
                            if ((_7644 || _7653) | ((_7630 >= _7526) || (_7632 >= _7527))) {
                              _7661 = _7489;
                            } else {
                              _7661 = _7619.z;
                            }
                            if ((_7633 || _7653) | ((_7627 >= _7526) || (_7632 >= _7527))) {
                              _7669 = _7489;
                            } else {
                              _7669 = _7619.w;
                            }
                            _7670 = _7643 - _7469;
                            _7672 = select((_7670 < 0.0f), 0.0f, 1.0f);
                            _7676 = _7652 - _7469;
                            _7678 = select((_7676 < 0.0f), 0.0f, 1.0f);
                            _7682 = _7661 - _7469;
                            _7684 = select((_7682 < 0.0f), 0.0f, 1.0f);
                            _7688 = _7669 - _7469;
                            _7690 = select((_7688 < 0.0f), 0.0f, 1.0f);
                            _7697 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                            _7702 = sqrt((float((int)(_7697)) * 0.25f) + 0.125f) * _7460;
                            _7711 = (_global_7[min((uint)(((int)(0u + (_7697 * 2)))), 127u)]) * _7702;
                            _7712 = (_global_7[min((uint)(((int)(1u + (_7697 * 2)))), 127u)]) * _7702;
                            _7715 = dot(float2(_7711, _7712), float2(_7484, _7483)) + _7458;
                            _7716 = dot(float2(_7711, _7712), float2(_7507, _7484)) + _7459;
                            _7718 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_7715, _7716));
                            _7722 = _7715 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _7723 = _7716 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _7726 = floor(_7722 + -0.5f);
                            _7727 = floor(_7723 + 0.5f);
                            _7729 = floor(_7722 + 0.5f);
                            _7731 = floor(_7723 + -0.5f);
                            _7732 = (_7726 < _7520);
                            _7733 = (_7727 < _7521);
                            if ((_7732 || _7733) | ((_7726 >= _7526) || (_7727 >= _7527))) {
                              _7742 = _7489;
                            } else {
                              _7742 = _7718.x;
                            }
                            _7743 = (_7729 < _7520);
                            if ((_7743 || _7733) | ((_7729 >= _7526) || (_7727 >= _7527))) {
                              _7751 = _7489;
                            } else {
                              _7751 = _7718.y;
                            }
                            _7752 = (_7731 < _7521);
                            if ((_7743 || _7752) | ((_7729 >= _7526) || (_7731 >= _7527))) {
                              _7760 = _7489;
                            } else {
                              _7760 = _7718.z;
                            }
                            if ((_7732 || _7752) | ((_7726 >= _7526) || (_7731 >= _7527))) {
                              _7768 = _7489;
                            } else {
                              _7768 = _7718.w;
                            }
                            _7769 = _7742 - _7469;
                            _7771 = select((_7769 < 0.0f), 0.0f, 1.0f);
                            _7775 = _7751 - _7469;
                            _7777 = select((_7775 < 0.0f), 0.0f, 1.0f);
                            _7781 = _7760 - _7469;
                            _7783 = select((_7781 < 0.0f), 0.0f, 1.0f);
                            _7787 = _7768 - _7469;
                            _7789 = select((_7787 < 0.0f), 0.0f, 1.0f);
                            _7796 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                            _7801 = sqrt((float((int)(_7796)) * 0.25f) + 0.125f) * _7460;
                            _7810 = (_global_7[min((uint)(((int)(0u + (_7796 * 2)))), 127u)]) * _7801;
                            _7811 = (_global_7[min((uint)(((int)(1u + (_7796 * 2)))), 127u)]) * _7801;
                            _7814 = dot(float2(_7810, _7811), float2(_7484, _7483)) + _7458;
                            _7815 = dot(float2(_7810, _7811), float2(_7507, _7484)) + _7459;
                            _7817 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_7814, _7815));
                            _7821 = _7814 * cbSharedPerViewData.vShadowAtlasSize.x;
                            _7822 = _7815 * cbSharedPerViewData.vShadowAtlasSize.y;
                            _7825 = floor(_7821 + -0.5f);
                            _7826 = floor(_7822 + 0.5f);
                            _7828 = floor(_7821 + 0.5f);
                            _7830 = floor(_7822 + -0.5f);
                            _7831 = (_7825 < _7520);
                            _7832 = (_7826 < _7521);
                            if ((_7831 || _7832) | ((_7825 >= _7526) || (_7826 >= _7527))) {
                              _7841 = _7489;
                            } else {
                              _7841 = _7817.x;
                            }
                            _7842 = (_7828 < _7520);
                            if ((_7842 || _7832) | ((_7828 >= _7526) || (_7826 >= _7527))) {
                              _7850 = _7489;
                            } else {
                              _7850 = _7817.y;
                            }
                            _7851 = (_7830 < _7521);
                            if ((_7842 || _7851) | ((_7828 >= _7526) || (_7830 >= _7527))) {
                              _7859 = _7489;
                            } else {
                              _7859 = _7817.z;
                            }
                            if ((_7831 || _7851) | ((_7825 >= _7526) || (_7830 >= _7527))) {
                              _7867 = _7489;
                            } else {
                              _7867 = _7817.w;
                            }
                            _7868 = _7841 - _7469;
                            _7870 = select((_7868 < 0.0f), 0.0f, 1.0f);
                            _7874 = _7850 - _7469;
                            _7876 = select((_7874 < 0.0f), 0.0f, 1.0f);
                            _7880 = _7859 - _7469;
                            _7882 = select((_7880 < 0.0f), 0.0f, 1.0f);
                            _7886 = _7867 - _7469;
                            _7888 = select((_7886 < 0.0f), 0.0f, 1.0f);
                            _7889 = ((((((((((((((_7579 + _7575) + _7585) + _7591) + _7672) + _7678) + _7684) + _7690) + _7771) + _7777) + _7783) + _7789) + _7870) + _7876) + _7882) + _7888;
                            _7900 = (saturate(_7889 * 0.0625f) * 2.0f) + -1.0f;
                            _7906 = float((int)(((int)(uint)((int)(_7900 > 0.0f))) - ((int)(uint)((int)(_7900 < 0.0f)))));
                            _7908 = 1.0f - (_7906 * _7900);
                            _7910 = (_7908 * _7908) * _7908;
                            _8202 = (0.5f - ((_7906 * 0.5f) * ((1.0f - _7910) - ((_7908 - _7910) * saturate(((1.0f / _7469) * (1.0f / _7889)) * ((((((((((((((((_7579 * _7577) + (_7575 * _7573)) + (_7585 * _7583)) + (_7591 * _7589)) + (_7672 * _7670)) + (_7678 * _7676)) + (_7684 * _7682)) + (_7690 * _7688)) + (_7771 * _7769)) + (_7777 * _7775)) + (_7783 * _7781)) + (_7789 * _7787)) + (_7870 * _7868)) + (_7876 * _7874)) + (_7882 * _7880)) + (_7888 * _7886)))))));
                            _8203 = 1.0f;
                            _8204 = false;
                          } else {
                            _7919 = f16tof32(((uint)((uint)(_6413) >> 16))) / _6561;
                            _7922 = mad((_7919 * _6559), 0.5f, 0.5f);
                            _7923 = mad((_7919 * _6560), 0.5f, 0.5f);
                            if (_6548 > -0.0f) {
                              if ((saturate(_7922) == _7922) && (saturate(_7923) == _7923)) {
                                _7936 = (_7922 * _6395) + _6397;
                                _7937 = (_7923 * _6396) + _6398;
                                _7938 = select(_6498, _6462, _6459);
                                _7939 = saturate(1.0f - (_6548 * _6437));
                                _7943 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _7952 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 5u) : (frac(frac(dot(float2(((_7943 * 32.665000915527344f) + _362), ((_7943 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _7953 = sin(_7952);
                                _7954 = cos(_7952);
                                _7955 = cbSharedPerViewData.nFrameCounter & 3;
                                _7960 = sqrt((float((int)(_7955)) * 0.25f) + 0.125f) * _7938;
                                _7969 = (_global_7[min((uint)(((int)(0u + (_7955 * 2)))), 127u)]) * _7960;
                                _7970 = (_global_7[min((uint)(((int)(1u + (_7955 * 2)))), 127u)]) * _7960;
                                _7972 = -0.0f - _7953;
                                _7977 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_7969, _7970), float2(_7954, _7953)) + _7936), (dot(float2(_7969, _7970), float2(_7972, _7954)) + _7937)));
                                _7982 = _7977.x - _7939;
                                _7984 = select((_7982 < 0.0f), 0.0f, 1.0f);
                                _7986 = _7977.y - _7939;
                                _7988 = select((_7986 < 0.0f), 0.0f, 1.0f);
                                _7992 = _7977.z - _7939;
                                _7994 = select((_7992 < 0.0f), 0.0f, 1.0f);
                                _7998 = _7977.w - _7939;
                                _8000 = select((_7998 < 0.0f), 0.0f, 1.0f);
                                _8007 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _8012 = sqrt((float((int)(_8007)) * 0.25f) + 0.125f) * _7938;
                                _8021 = (_global_7[min((uint)(((int)(0u + (_8007 * 2)))), 127u)]) * _8012;
                                _8022 = (_global_7[min((uint)(((int)(1u + (_8007 * 2)))), 127u)]) * _8012;
                                _8028 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_8021, _8022), float2(_7954, _7953)) + _7936), (dot(float2(_8021, _8022), float2(_7972, _7954)) + _7937)));
                                _8033 = _8028.x - _7939;
                                _8035 = select((_8033 < 0.0f), 0.0f, 1.0f);
                                _8039 = _8028.y - _7939;
                                _8041 = select((_8039 < 0.0f), 0.0f, 1.0f);
                                _8045 = _8028.z - _7939;
                                _8047 = select((_8045 < 0.0f), 0.0f, 1.0f);
                                _8051 = _8028.w - _7939;
                                _8053 = select((_8051 < 0.0f), 0.0f, 1.0f);
                                _8060 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _8065 = sqrt((float((int)(_8060)) * 0.25f) + 0.125f) * _7938;
                                _8074 = (_global_7[min((uint)(((int)(0u + (_8060 * 2)))), 127u)]) * _8065;
                                _8075 = (_global_7[min((uint)(((int)(1u + (_8060 * 2)))), 127u)]) * _8065;
                                _8081 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_8074, _8075), float2(_7954, _7953)) + _7936), (dot(float2(_8074, _8075), float2(_7972, _7954)) + _7937)));
                                _8086 = _8081.x - _7939;
                                _8088 = select((_8086 < 0.0f), 0.0f, 1.0f);
                                _8092 = _8081.y - _7939;
                                _8094 = select((_8092 < 0.0f), 0.0f, 1.0f);
                                _8098 = _8081.z - _7939;
                                _8100 = select((_8098 < 0.0f), 0.0f, 1.0f);
                                _8104 = _8081.w - _7939;
                                _8106 = select((_8104 < 0.0f), 0.0f, 1.0f);
                                _8113 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _8118 = sqrt((float((int)(_8113)) * 0.25f) + 0.125f) * _7938;
                                _8127 = (_global_7[min((uint)(((int)(0u + (_8113 * 2)))), 127u)]) * _8118;
                                _8128 = (_global_7[min((uint)(((int)(1u + (_8113 * 2)))), 127u)]) * _8118;
                                _8134 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_8127, _8128), float2(_7954, _7953)) + _7936), (dot(float2(_8127, _8128), float2(_7972, _7954)) + _7937)));
                                _8139 = _8134.x - _7939;
                                _8141 = select((_8139 < 0.0f), 0.0f, 1.0f);
                                _8145 = _8134.y - _7939;
                                _8147 = select((_8145 < 0.0f), 0.0f, 1.0f);
                                _8151 = _8134.z - _7939;
                                _8153 = select((_8151 < 0.0f), 0.0f, 1.0f);
                                _8157 = _8134.w - _7939;
                                _8159 = select((_8157 < 0.0f), 0.0f, 1.0f);
                                _8160 = ((((((((((((((_7984 + _7988) + _7994) + _8000) + _8035) + _8041) + _8047) + _8053) + _8088) + _8094) + _8100) + _8106) + _8141) + _8147) + _8153) + _8159;
                                _8171 = (saturate(_8160 * 0.0625f) * 2.0f) + -1.0f;
                                _8177 = float((int)(((int)(uint)((int)(_8171 > 0.0f))) - ((int)(uint)((int)(_8171 < 0.0f)))));
                                _8179 = 1.0f - (_8177 * _8171);
                                _8181 = (_8179 * _8179) * _8179;
                                _8189 = -0.0f - _6559;
                                _8196 = saturate((saturate(rsqrt(dot(float3(_8189, _6551, _6548), float3(_8189, _6551, _6548))) * _6548) * _6435) + _6434);
                                _8198 = 1.0f - (_8196 * _8196);
                                _8202 = (0.5f - ((_8177 * 0.5f) * ((1.0f - _8181) - ((_8179 - _8181) * saturate(((1.0f / _7939) * (1.0f / _8160)) * ((((((((((((((((_7984 * _7982) + (_7988 * _7986)) + (_7994 * _7992)) + (_8000 * _7998)) + (_8035 * _8033)) + (_8041 * _8039)) + (_8047 * _8045)) + (_8053 * _8051)) + (_8088 * _8086)) + (_8094 * _8092)) + (_8100 * _8098)) + (_8106 * _8104)) + (_8141 * _8139)) + (_8147 * _8145)) + (_8153 * _8151)) + (_8159 * _8157)))))));
                                _8203 = (1.0f - (_8198 * _8198));
                                _8204 = false;
                              } else {
                                _8202 = 1.0f;
                                _8203 = 1.0f;
                                _8204 = true;
                              }
                            } else {
                              _8202 = 1.0f;
                              _8203 = 1.0f;
                              _8204 = true;
                            }
                          }
                        } else {
                          _8202 = 1.0f;
                          _8203 = 1.0f;
                          _8204 = true;
                        }
                        if (_7409 == 0) {
                          if (!_8204) {
                            _8222 = _7406;
                            _8223 = ((_8203 * (_8202 + -1.0f)) + 1.0f);
                            _8224 = 0.0f;
                            _8225 = _7407;
                          } else {
                            _8222 = _7406;
                            _8223 = _8202;
                            _8224 = 0.0f;
                            _8225 = _7407;
                          }
                        } else {
                          if (_8204) {
                            _8222 = ((_7408 * (_7406 + -1.0f)) + 1.0f);
                            _8223 = _8202;
                            _8224 = 1.0f;
                            _8225 = ((_7408 * (_7407 + -1.0f)) + 1.0f);
                          } else {
                            _8222 = _7406;
                            _8223 = _8202;
                            _8224 = (_7408 * _6438);
                            _8225 = _7407;
                          }
                        }
                        _8228 = (_8224 * (_8222 - _8223)) + _8223;
                        [branch]
                        if (!((_1881 & 2048) == 0)) {
                          _8231 = _379 - _6352;
                          _8232 = _380 - _6353;
                          _8233 = _381 - _6354;
                          _8248 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _8233, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _8232, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _8231)));
                          _8251 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), _8233, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _8232, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _8231)));
                          _8254 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), _8233, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _8232, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _8231)));
                          _8256 = rsqrt(dot(float3(_8248, _8251, _8254), float3(_8248, _8251, _8254)));
                          _8257 = _8256 * _8248;
                          _8258 = _8256 * _8251;
                          _8259 = _8256 * _8254;
                          Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6386) >> 16))];
                          _8267 = (abs(_8258) + abs(_8257)) + abs(_8259);
                          _8268 = _8257 / _8267;
                          _8269 = _8258 / _8267;
                          _8271 = !((_8259 / _8267) >= 0.0f);
                          if (_8271) {
                            _8284 = ((1.0f - abs(_8269)) * select((_8268 >= 0.0f), 1.0f, -1.0f));
                            _8285 = ((1.0f - abs(_8268)) * select((_8269 >= 0.0f), 1.0f, -1.0f));
                          } else {
                            _8284 = _8268;
                            _8285 = _8269;
                          }
                          _8291 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_8284 * 0.5f) + 0.5f), ((_8285 * 0.5f) + 0.5f)), 0.0f);
                          if (_8291.x > 0.0f) {
                            Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_6386 & 65535))];
                            if (_8271) {
                              _8310 = ((1.0f - abs(_8269)) * select((_8268 >= 0.0f), 1.0f, -1.0f));
                              _8311 = ((1.0f - abs(_8268)) * select((_8269 >= 0.0f), 1.0f, -1.0f));
                            } else {
                              _8310 = _8268;
                              _8311 = _8269;
                            }
                            _8316 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_8310 * 0.5f) + 0.5f), ((_8311 * 0.5f) + 0.5f)), 0.0f);
                            _8336 = mad(saturate(((log2(sqrt(((_8231 * _8231) + (_8232 * _8232)) + (_8233 * _8233))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                            _8337 = max(9.999999747378752e-06f, _8291.x);
                            _8338 = _8316.x / _8337;
                            _8339 = _8316.y / _8337;
                            _8341 = _8316.w / _8337;
                            _8346 = ((0.375f - _8339) * 4.999999873689376e-06f) + _8339;
                            _8349 = -0.0f - _8338;
                            _8350 = mad(_8349, _8346, (_8316.z / _8337));
                            _8352 = 1.0f / mad(_8349, _8338, _8346);
                            _8353 = _8352 * _8350;
                            _8358 = _8336 - _8338;
                            _8363 = (((_8336 * _8336) - _8346) - (_8353 * _8358)) / mad((-0.0f - _8350), _8353, mad((-0.0f - _8346), _8346, (((0.375f - _8341) * 4.999999873689376e-06f) + _8341)));
                            _8365 = (_8352 * _8358) - (_8363 * _8353);
                            _8368 = 1.0f / _8363;
                            _8369 = _8365 * _8368;
                            _8374 = sqrt(((_8369 * _8369) * 0.25f) - ((1.0f - dot(float2(_8365, _8363), float2(_8338, _8346))) * _8368));
                            _8376 = (_8369 * -0.5f) - _8374;
                            _8378 = _8374 - (_8369 * 0.5f);
                            _8380 = select((_8376 < _8336), 1.0f, 0.0f);
                            _8385 = (_8380 + -0.05000000074505806f) / (_8376 - _8336);
                            _8391 = (((select((_8378 < _8336), 1.0f, 0.0f) - _8380) / (_8378 - _8376)) - _8385) / (_8378 - _8336);
                            _8393 = _8385 - (_8391 * _8376);
                            _8406 = (exp2((_8291.x * -1.4426950216293335f) * saturate((dot(float2(_8338, _8346), float2((_8393 - (_8391 * _8336)), _8391)) + 0.05000000074505806f) - (_8393 * _8336))) * _8228);
                          } else {
                            _8406 = _8228;
                          }
                        } else {
                          _8406 = _8228;
                        }
                        _8412 = (_8406 * _6522);
                        _8413 = (lerp(_8406, _8225, _8224));
                        _8414 = _8224;
                        _8415 = _7410;
                        _8416 = (_7408 * _7407);
                        _8417 = _8406;
                      } else {
                        _8412 = _6522;
                        _8413 = 1.0f;
                        _8414 = 0.0f;
                        _8415 = 0.0f;
                        _8416 = 0.0f;
                        _8417 = 1.0f;
                      }
                      [branch]
                      if (!(_6440 == 0)) {
                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6440)))];
                        _8429 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_6501, _6347, mad(_6500, _6342, (_6499 * _6337)))), (-0.0f - mad(_6501, _6348, mad(_6500, _6343, (_6499 * _6338)))), (-0.0f - mad(_6501, _6349, mad(_6500, _6344, (_6499 * _6339))))), 0.0f);
                        _8437 = (_8429.x * _6415);
                        _8438 = (_8429.y * _6416);
                        _8439 = (_8429.z * _6418);
                      } else {
                        _8437 = _6415;
                        _8438 = _6416;
                        _8439 = _6418;
                      }
                      [branch]
                      if (!(_8412 == 0.0f)) {
                        bool __branch_chain_8442;
                        if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                          _8458 = 0;
                          __branch_chain_8442 = true;
                        } else {
                          if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                            _8458 = 1;
                            __branch_chain_8442 = true;
                          } else {
                            if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                              _8458 = 2;
                              __branch_chain_8442 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                _8458 = 3;
                                __branch_chain_8442 = true;
                              } else {
                                _8479 = _8412;
                                __branch_chain_8442 = false;
                              }
                            }
                          }
                        }
                        if (__branch_chain_8442) {
                          while(true) {
                            _8461 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_70, _71, 0));
                            if (_8458 == 0) {
                              _8475 = _8461.x;
                            } else {
                              if (_8458 == 1) {
                                _8475 = _8461.y;
                              } else {
                                if (_8458 == 2) {
                                  _8475 = _8461.z;
                                } else {
                                  _8475 = _8461.w;
                                }
                              }
                            }
                            _8479 = ((_8475 * _8475) * _6522);
                            break;
                          }
                        }
                        while(true) {
                          [branch]
                          if (!(_8479 == 0.0f)) {
                            [branch]
                            if (_6553) {
                              if (!(_383 || _221)) {
                                _8490 = ((_8415 * _6522) * _8416) * saturate(0.30000001192092896f - dot(float3(_6505, _6506, _6507), float3(_196, _197, _198)));
                                _8495 = (_8490 * _1508);
                                _8496 = (_8490 * _1509);
                                _8497 = (_8490 * _1510);
                              } else {
                                _8495 = 0.0f;
                                _8496 = 0.0f;
                                _8497 = 0.0f;
                              }
                              [branch]
                              if (!((_6389 & 1) == 0)) {
                                _8510 = max(max(_8437, _8438), _8439);
                                if (_8510 > 0.0f) {
                                  _8520 = saturate(_8437 / _8510);
                                  _8521 = saturate(_8438 / _8510);
                                  _8522 = saturate(_8439 / _8510);
                                } else {
                                  _8520 = _8437;
                                  _8521 = _8438;
                                  _8522 = _8439;
                                }
                                _8523 = (_8521 < _8522);
                                _8524 = select(_8523, _8522, _8521);
                                _8525 = select(_8523, _8521, _8522);
                                _8526 = select(_8523, -1.0f, 0.0f);
                                _8527 = (_8520 < _8524);
                                _8529 = select(_8527, _8524, _8520);
                                _8530 = select(_8527, _8520, _8524);
                                _8534 = _8529 - select((_8530 < _8525), _8530, _8525);
                                _8540 = abs(select(_8527, (-0.3333333432674408f - _8526), _8526) + ((_8530 - _8525) / ((_8534 * 6.0f) + 9.999999682655225e-21f)));
                                if (_8540 < 0.6666666865348816f) {
                                  _8553 = ((saturate(((float)((uint)((uint)(((uint)(_6389) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8540 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8540)) + _8540);
                                } else {
                                  _8553 = _8540;
                                }
                                _8554 = saturate((_8534 / (_8529 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6389) >> 1) & 255)))) * 0.003921499941498041f));
                                _8555 = saturate(_8529);
                                if (!(_8554 <= 0.0f)) {
                                  _8558 = saturate(_8553);
                                  _8562 = select(((_8558 * 360.0f) >= 360.0f), 0.0f, (_8558 * 6.0f));
                                  _8563 = int(_8562);
                                  _8565 = _8562 - float((int)(_8563));
                                  _8567 = _8555 * (1.0f - _8554);
                                  _8570 = (1.0f - (_8565 * _8554)) * _8555;
                                  _8574 = (1.0f - ((1.0f - _8565) * _8554)) * _8555;
                                  switch (_8563) {
                                    case 0: {
                                      _8582 = _8555;
                                      _8583 = _8574;
                                      _8584 = _8567;
                                      break;
                                    }
                                    case 1: {
                                      _8582 = _8570;
                                      _8583 = _8555;
                                      _8584 = _8567;
                                      break;
                                    }
                                    case 2: {
                                      _8582 = _8567;
                                      _8583 = _8555;
                                      _8584 = _8574;
                                      break;
                                    }
                                    case 3: {
                                      _8582 = _8567;
                                      _8583 = _8570;
                                      _8584 = _8555;
                                      break;
                                    }
                                    case 4: {
                                      _8582 = _8574;
                                      _8583 = _8567;
                                      _8584 = _8555;
                                      break;
                                    }
                                    case 5: {
                                      _8582 = _8555;
                                      _8583 = _8567;
                                      _8584 = _8570;
                                      break;
                                    }
                                    default: {
                                      _8582 = 0.0f;
                                      _8583 = 0.0f;
                                      _8584 = 0.0f;
                                      break;
                                    }
                                  }
                                } else {
                                  _8582 = _8555;
                                  _8583 = _8555;
                                  _8584 = _8555;
                                }
                                _8585 = _8582 * _8510;
                                _8586 = _8583 * _8510;
                                _8587 = _8584 * _8510;
                                _8589 = saturate(_8417 * 1.0101009607315063f);
                                _8600 = ((_8589 * (_8437 - _8585)) + _8585);
                                _8601 = ((_8589 * (_8438 - _8586)) + _8586);
                                _8602 = (lerp(_8587, _8439, _8589));
                                _8603 = _8495;
                                _8604 = _8496;
                                _8605 = _8497;
                                _8606 = _8415;
                              } else {
                                _8600 = _8437;
                                _8601 = _8438;
                                _8602 = _8439;
                                _8603 = _8495;
                                _8604 = _8496;
                                _8605 = _8497;
                                _8606 = _8415;
                              }
                            } else {
                              _8600 = _8437;
                              _8601 = _8438;
                              _8602 = _8439;
                              _8603 = 0.0f;
                              _8604 = 0.0f;
                              _8605 = 0.0f;
                              _8606 = 0.0f;
                            }
                            _8607 = select(_212, (_8413 * _6522), _8479);
                            [branch]
                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                              _8614 = srvLightMappingData[_1884];
                              if (!(_8614 == -1)) {
                                _8619 = srvLightIndexData[_8614].nLayerIndex;
                                _8621 = srvLightIndexData[_8614].vAtlasOrigin.x;
                                _8622 = srvLightIndexData[_8614].vAtlasOrigin.y;
                                _8624 = srvLightIndexData[_8614].vScreenOrigin.x;
                                _8625 = srvLightIndexData[_8614].vScreenOrigin.y;
                                _8634 = ((int)(_8619 * 5)) & 31;
                                _8637 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8621 + _70) - _8624)), ((int)((_8622 + _71) - _8625)), 0)))).x) & ((int)(31 << _8634)))) >> _8634;
                                _8642 = ((float)((uint)((uint)((uint)(_8637) >> 1)))) * 0.06666667014360428f;
                                _8648 = (_8642 * _8607);
                                _8649 = (select(_212, ((float)((bool)(uint)((_8637 & 1) != 0))), _8642) * _8607);
                              } else {
                                _8648 = _8607;
                                _8649 = _8607;
                              }
                            } else {
                              _8648 = _8607;
                              _8649 = _8607;
                            }
                            _8653 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                            _8656 = select(_8653, (_8648 * _1480), _8648);
                            _8658 = select(_212, _8414, _8606);
                            _8659 = _6505 * _6504;
                            _8660 = _6506 * _6504;
                            _8661 = _6507 * _6504;
                            _8662 = _6426 * _6357;
                            _8663 = _6426 * _6358;
                            _8664 = _6426 * _6359;
                            _8665 = _8659 + _8662;
                            _8666 = _8660 + _8663;
                            _8667 = _8661 + _8664;
                            _8668 = _8659 - _8662;
                            _8669 = _8660 - _8663;
                            _8670 = _8661 - _8664;
                            _8671 = (_6426 > 0.0f);
                            _8672 = dot(float3(_8665, _8666, _8667), float3(_8665, _8666, _8667));
                            _8673 = rsqrt(_8672);
                            [branch]
                            if (_8671) {
                              _8676 = rsqrt(dot(float3(_8668, _8669, _8670), float3(_8668, _8669, _8670)));
                              _8677 = _8676 * _8673;
                              _8679 = dot(float3(_8665, _8666, _8667), float3(_8668, _8669, _8670)) * _8677;
                              _8698 = (_8677 / ((_8677 + 0.5f) + (_8679 * 0.5f)));
                              _8699 = (((dot(float3(_196, _197, _198), float3(_8668, _8669, _8670)) * _8676) + (dot(float3(_196, _197, _198), float3(_8665, _8666, _8667)) * _8673)) * 0.5f);
                              _8700 = _8679;
                            } else {
                              _8698 = (1.0f / (_8672 + 1.0f));
                              _8699 = dot(float3(_196, _197, _198), float3((_8673 * _8665), (_8673 * _8666), (_8673 * _8667)));
                              _8700 = 1.0f;
                            }
                            if (_6428 > 0.0f) {
                              _8706 = sqrt(saturate((_6428 * _6428) * _8698));
                              if (_8699 < _8706) {
                                _8711 = max(_8699, (-0.0f - _8706)) + _8706;
                                _8716 = ((_8711 * _8711) / (_8706 * 4.0f));
                              } else {
                                _8716 = _8699;
                              }
                            } else {
                              _8716 = _8699;
                            }
                            if (_8671) {
                              _8718 = -0.0f - _601;
                              _8719 = -0.0f - _602;
                              _8720 = -0.0f - _600;
                              _8722 = dot(float3(_8718, _8719, _8720), float3(_196, _197, _198)) * 2.0f;
                              _8726 = _8718 - (_8722 * _196);
                              _8727 = _8719 - (_8722 * _197);
                              _8728 = _8720 - (_8722 * _198);
                              _8729 = _8668 - _8665;
                              _8730 = _8669 - _8666;
                              _8731 = _8670 - _8667;
                              _8732 = dot(float3(_8726, _8727, _8728), float3(_8729, _8730, _8731));
                              _8738 = sqrt(((_8729 * _8729) + (_8730 * _8730)) + (_8731 * _8731));
                              _8747 = saturate(((dot(float3(_8726, _8727, _8728), float3(_8665, _8666, _8667)) * _8732) - dot(float3(_8665, _8666, _8667), float3(_8729, _8730, _8731))) / ((_8738 * _8738) - (_8732 * _8732)));
                              _8751 = (_8747 * _8729) + _8665;
                              _8752 = (_8747 * _8730) + _8666;
                              _8753 = (_8747 * _8731) + _8667;
                              _8754 = dot(float3(_8751, _8752, _8753), float3(_8726, _8727, _8728));
                              _8758 = (_8754 * _8726) - _8751;
                              _8759 = (_8754 * _8727) - _8752;
                              _8760 = (_8754 * _8728) - _8753;
                              _8768 = saturate(0.009999999776482582f / sqrt(((_8758 * _8758) + (_8759 * _8759)) + (_8760 * _8760)));
                              _8776 = ((_8768 * _8758) + _8751);
                              _8777 = ((_8768 * _8759) + _8752);
                              _8778 = ((_8768 * _8760) + _8753);
                            } else {
                              _8776 = _8665;
                              _8777 = _8666;
                              _8778 = _8667;
                            }
                            _8780 = rsqrt(dot(float3(_8776, _8777, _8778), float3(_8776, _8777, _8778)));
                            _8781 = _8780 * _8776;
                            _8782 = _8780 * _8777;
                            _8783 = _8780 * _8778;
                            _8784 = _268 * _268;
                            _8785 = 1.0f - _8784;
                            _8788 = saturate((_6428 * _8785) * _8780);
                            _8790 = saturate(_8780 * f16tof32(_6371));
                            _8792 = rsqrt(dot(float3(_8659, _8660, _8661), float3(_8659, _8660, _8661)));
                            _8793 = _8792 * _8659;
                            _8794 = _8792 * _8660;
                            _8795 = _8792 * _8661;
                            if (_319) {
                              _8798 = saturate(dot(float3(_196, _197, _198), float3(_8781, _8782, _8783)));
                              _8805 = (_8798 * (_196 - _359)) + _359;
                              _8806 = (_8798 * (_197 - _360)) + _360;
                              _8807 = (_8798 * (_198 - _361)) + _361;
                              _8809 = rsqrt(dot(float3(_8805, _8806, _8807), float3(_8805, _8806, _8807)));
                              _8814 = (_8805 * _8809);
                              _8815 = (_8806 * _8809);
                              _8816 = (_8807 * _8809);
                            } else {
                              _8814 = _196;
                              _8815 = _197;
                              _8816 = _198;
                            }
                            _8817 = dot(float3(_8814, _8815, _8816), float3(_8781, _8782, _8783));
                            _8818 = dot(float3(_8814, _8815, _8816), float3(_601, _602, _600));
                            _8819 = dot(float3(_601, _602, _600), float3(_8781, _8782, _8783));
                            _8822 = rsqrt((_8819 * 2.0f) + 2.0f);
                            _8825 = saturate(_8822 * (_8818 + _8817));
                            _8828 = saturate((_8822 * _8819) + _8822);
                            _8829 = (_8788 > 0.0f);
                            if (_8829) {
                              _8833 = sqrt(1.0f - (_8788 * _8788));
                              _8835 = (_8817 * 2.0f) * _8818;
                              _8836 = _8835 - _8819;
                              if (!(_8836 >= _8833)) {
                                _8844 = rsqrt(1.0f - (_8836 * _8836)) * _8788;
                                _8847 = _8844 * (_8818 - (_8836 * _8817));
                                _8848 = _8818 * _8818;
                                _8853 = _8844 * (((_8848 * 2.0f) + -1.0f) - (_8836 * _8819));
                                _8862 = sqrt(saturate((((1.0f - (_8817 * _8817)) - _8848) - (_8819 * _8819)) + (_8835 * _8819)));
                                _8863 = _8862 * _8844;
                                _8866 = ((_8818 * 2.0f) * _8844) * _8862;
                                _8868 = (_8833 * _8817) + _8818;
                                _8869 = _8868 + _8847;
                                _8870 = _8833 * _8819;
                                _8872 = (_8870 + 1.0f) + _8853;
                                _8873 = _8863 * _8872;
                                _8874 = _8869 * _8872;
                                _8875 = _8866 * _8869;
                                _8880 = (((_8869 * 0.25f) * _8866) - (_8873 * 0.5f)) * _8874;
                                _8894 = (((_8875 - (_8873 * 2.0f)) * _8875) + (_8873 * _8873)) + ((((-0.5f - ((_8872 + _8870) * 0.5f)) * _8874) + ((_8872 * _8872) * _8868)) * _8869);
                                _8899 = (_8880 * 2.0f) / ((_8894 * _8894) + (_8880 * _8880));
                                _8900 = _8894 * _8899;
                                _8902 = 1.0f - (_8880 * _8899);
                                _8908 = ((_8900 * _8866) + _8870) + (_8902 * _8853);
                                _8911 = rsqrt((_8908 * 2.0f) + 2.0f);
                                _8920 = saturate((_8908 * _8911) + _8911);
                                _8921 = saturate(((_8868 + (_8900 * _8863)) + (_8902 * _8847)) * _8911);
                              } else {
                                _8920 = abs(_8818);
                                _8921 = 1.0f;
                              }
                            } else {
                              _8920 = _8828;
                              _8921 = _8825;
                            }
                            _8922 = saturate(_8818);
                            _8923 = saturate(_8716);
                            _8924 = dot(float3(_8814, _8815, _8816), float3(_8793, _8794, _8795));
                            _8925 = saturate(_8924);
                            _8926 = _8784 * _8784;
                            _8927 = (_8790 > 0.0f);
                            if (_8927) {
                              _8936 = saturate(((_8790 * _8790) / ((_8920 * 3.5999999046325684f) + 0.4000000059604645f)) + _8926);
                            } else {
                              _8936 = _8926;
                            }
                            if (_8829) {
                              _8945 = (((_8788 * 0.25f) * ((sqrt(_8936) * 3.0f) + _8788)) / (_8920 + 0.0010000000474974513f)) + _8936;
                              _8948 = _8945;
                              _8949 = (_8936 / _8945);
                            } else {
                              _8948 = _8936;
                              _8949 = 1.0f;
                            }
                            _8950 = (_8700 < 1.0f);
                            if (_8950) {
                              _8956 = sqrt((1.000100016593933f - _8700) / max(9.999999974752427e-07f, (_8700 + 1.0f)));
                              _8969 = (sqrt(_8948 / ((((_8956 * 0.25f) * ((sqrt(_8948) * 3.0f) + _8956)) / (_8920 + 0.0010000000474974513f)) + _8948)) * _8949);
                            } else {
                              _8969 = _8949;
                            }
                            _8973 = (((_8936 * _8921) - _8921) * _8921) + 1.0f;
                            _8976 = (_8936 / (_8973 * _8973)) * _8969;
                            _8977 = 1.0f - _251;
                            _8978 = 1.0f - _252;
                            _8979 = 1.0f - _253;
                            _8980 = saturate(_8920);
                            _8981 = 1.0f - _8980;
                            _8982 = log2(_8981);
                            _8984 = exp2(_8982 * 5.0f);
                            _8988 = (_8984 * _8977) + _251;
                            _8989 = (_8984 * _8978) + _252;
                            _8990 = (_8984 * _8979) + _253;
                            _8991 = abs(_8818);
                            _8993 = saturate(_8991 + 9.999999747378752e-06f);
                            _8994 = sqrt(_8936);
                            _8995 = 1.0f - _8994;
                            _9003 = 0.5f / ((((_8995 * _8993) + _8994) * _8923) + (((_8995 * _8923) + _8994) * _8993));
                            if (_212) {
                              _9013 = ((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                              _9014 = ((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                              _9015 = ((_164 + -0.5f) * 0.5f) + 0.5f;
                              _9032 = ((dot(float3((-0.0f - _8814), (-0.0f - _8815), (-0.0f - _8816)), float3(_8793, _8794, _8795)) + dot(float3((-0.0f - _601), (-0.0f - _602), (-0.0f - _600)), float3(_8793, _8794, _8795))) * 0.5f) * exp2(log2(1.0f - _8922) * (11.0f - (((float)((uint)((uint)((uint)(_310) >> 2)))) * 0.1666666716337204f)));
                              _9041 = saturate((_1481 + -0.009999999776482582f) * -100.0f);
                              _9046 = ((_9041 * _9041) * 3.0f) * (3.0f - (_9041 * 2.0f));
                              _9053 = 10.0f - (exp2(log2(saturate(_1481 * 5.0f)) * 3.0f) * 9.0f);
                              _9054 = saturate(_8925 + _9013) * _8925;
                              _9055 = saturate(_8925 + _9014) * _8925;
                              _9056 = saturate(_8925 + _9015) * _8925;
                              _9075 = (max(((_9046 + _9013) * _9032), 0.0f) * _9053) + sqrt(_9054 * _9054);
                              _9076 = (max(((_9046 + _9014) * _9032), 0.0f) * _9053) + sqrt(_9055 * _9055);
                              _9077 = (max(((_9046 + _9015) * _9032), 0.0f) * _9053) + sqrt(_9056 * _9056);
                              _9078 = _8781 + _601;
                              _9079 = _8782 + _602;
                              _9080 = _8783 + _600;
                              _9082 = rsqrt(dot(float3(_9078, _9079, _9080), float3(_9078, _9079, _9080)));
                              if (!(select((_309 != 0), 1.0f, 0.0f) < 1.0f)) {
                                _9096 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                                _9097 = _9096 * _196;
                                _9098 = _9096 * _197;
                                _9099 = _9096 * _198;
                                _9102 = (abs(_9097) < abs(_9098));
                                _9103 = select(_9102, 1.0f, 0.0f);
                                _9104 = select(_9102, 0.0f, 1.0f);
                                _9105 = _9104 * _9099;
                                _9107 = -0.0f - (_9099 * _9103);
                                _9110 = (_9103 * _9098) - (_9104 * _9097);
                                _9112 = rsqrt(dot(float3(_9105, _9107, _9110), float3(_9105, _9107, _9110)));
                                _9113 = _9105 * _9112;
                                _9114 = _9112 * _9107;
                                _9115 = _9110 * _9112;
                                _9118 = (_9114 * _9099) - (_9115 * _9098);
                                _9121 = (_9115 * _9097) - (_9113 * _9099);
                                _9124 = (_9113 * _9098) - (_9114 * _9097);
                                _9126 = rsqrt(dot(float3(_9118, _9121, _9124), float3(_9118, _9121, _9124)));
                                _9138 = saturate(abs(_308 + -2.5f) + -0.5f) + -0.5f;
                                _9139 = saturate(1.5f - abs(_308 + -1.5f)) + -0.5f;
                                _9141 = rsqrt(dot(float2(_9138, _9139), float2(_9138, _9139)));
                                _9142 = _9141 * _9138;
                                _9143 = _9141 * _9139;
                                _9150 = ((_9118 * _9126) * _9142) + (_9143 * _9113);
                                _9151 = ((_9121 * _9126) * _9142) + (_9143 * _9114);
                                _9152 = ((_9124 * _9126) * _9142) + (_9143 * _9115);
                                _9155 = min(max(dot(float3(_9150, _9151, _9152), float3(_8781, _8782, _8783)), -1.0f), 1.0f);
                                _9158 = min(max(dot(float3(_9150, _9151, _9152), float3(_601, _602, _600)), -1.0f), 1.0f);
                                _9159 = abs(_9158);
                                _9164 = (1.5707963705062866f - (_9159 * 0.1565829962491989f)) * sqrt(1.0f - _9159);
                                _9168 = abs(_9155);
                                _9173 = (1.5707963705062866f - (_9168 * 0.1565829962491989f)) * sqrt(1.0f - _9168);
                                _9180 = cos(abs(select((_9155 >= 0.0f), _9173, (3.1415927410125732f - _9173)) - select((_9158 >= 0.0f), _9164, (3.1415927410125732f - _9164))) * 0.5f);
                                _9184 = _8781 - (_9155 * _9150);
                                _9185 = _8782 - (_9155 * _9151);
                                _9186 = _8783 - (_9155 * _9152);
                                _9190 = _601 - (_9158 * _9150);
                                _9191 = _602 - (_9158 * _9151);
                                _9192 = _600 - (_9158 * _9152);
                                _9199 = rsqrt((dot(float3(_9190, _9191, _9192), float3(_9190, _9191, _9192)) * dot(float3(_9184, _9185, _9186), float3(_9184, _9185, _9186))) + 9.999999747378752e-05f) * dot(float3(_9184, _9185, _9186), float3(_9190, _9191, _9192));
                                _9203 = sqrt(saturate((_9199 * 0.5f) + 0.5f));
                                _9207 = _8784 * 0.5f;
                                _9208 = _8784 * 2.0f;
                                _9212 = exp2((1.0f - abs(_8658)) * -72.13475036621094f);
                                if (!((_310 & 1) == 0)) {
                                  _9219 = select(((select(((_310 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_8658 == -1.0f))), 0.0f, _9212);
                                } else {
                                  _9219 = _9212;
                                }
                                _9223 = saturate((dot(float3(_196, _197, _198), float3(_8781, _8782, _8783)) + 0.5f) * 0.6666666865348816f);
                                _9233 = (_9158 + _9155) + ((((_9203 * 0.9975510239601135f) * sqrt(1.0f - (_9158 * _9158))) - (_9158 * 0.06994284689426422f)) * 0.13988569378852844f);
                                _9235 = (_8784 * 1.4142135381698608f) * _9203;
                                _9248 = 1.0f - sqrt(saturate((_8819 * 0.5f) + 0.5f));
                                _9249 = _9248 * _9248;
                                _9255 = saturate(-0.0f - _8819);
                                _9258 = (1.0f - saturate(_9255)) * _9223;
                                _9267 = ((((_9203 * 0.5f) * (exp2((((_9233 * _9233) * -0.5f) / (_9235 * _9235)) * 1.4426950216293335f) / (_9235 * 2.5066282749176025f))) * min(_255, 0.5f)) * (((_9249 * _9249) * (_9248 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_9258, 1.0f, _9219));
                                _9269 = (_9155 + -0.03500000014901161f) + _9158;
                                _9278 = 1.0f / ((1.190000057220459f / _9180) + (_9180 * 0.36000001430511475f));
                                _9283 = ((_9278 * (0.6000000238418579f - (_9199 * 0.800000011920929f))) + 1.0f) * _9203;
                                _9289 = 1.0f - (sqrt(saturate(1.0f - (_9283 * _9283))) * _9180);
                                _9290 = _9289 * _9289;
                                _9294 = 0.9534794092178345f - ((_9290 * _9290) * (_9289 * 0.9534794092178345f));
                                _9295 = _9283 * _9278;
                                _9300 = (sqrt(1.0f - (_9295 * _9295)) * 0.5f) / _9180;
                                _9319 = 1.0f - saturate((_9255 + -0.44999998807907104f) * 2.222222328186035f);
                                _9322 = ((1.0f - _9223) * _9219) + _9223;
                                _9325 = ((_9294 * _9294) * (exp2((((_9269 * _9269) * -0.5f) / (_9207 * _9207)) * 1.4426950216293335f) / (_8784 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_9199 * 5.2658371925354f));
                                _9339 = (_9155 + -0.14000000059604645f) + _9158;
                                _9349 = 1.0f - (_9180 * 0.5f);
                                _9350 = _9349 * _9349;
                                _9354 = (_9350 * _9350) * (0.9534794092178345f - (_9180 * 0.47673970460891724f));
                                _9356 = 0.9534794092178345f - _9354;
                                _9358 = (_9356 * _9356) * (_9354 + 0.04652056470513344f);
                                _9361 = exp2((_9199 * 24.525815963745117f) + -24.208423614501953f);
                                _9374 = ((exp2((((_9339 * _9339) * -0.5f) / (_9208 * _9208)) * 1.4426950216293335f) / (_8784 * 5.013256549835205f)) * (lerp(_9358, 1.0f, _220))) * (((exp2((saturate(dot(float3((_9082 * _9078), (_9082 * _9079), (_9082 * _9080)), float3(_196, _197, _198))) * 17.312339782714844f) + -14.109557151794434f) - _9361) * _220) + _9361);
                                _10154 = (((((exp2(log2(max(_162, 0.0f)) * _9300) * _9322) * _9325) * _9319) + _9267) + (_9374 * _162));
                                _10155 = (((((exp2(log2(max(_163, 0.0f)) * _9300) * _9322) * _9325) * _9319) + _9267) + (_9374 * _163));
                                _10156 = (((((exp2(log2(max(_164, 0.0f)) * _9300) * _9322) * _9325) * _9319) + _9267) + (_9374 * _164));
                                _10157 = _9075;
                                _10158 = _9076;
                                _10159 = _9077;
                              } else {
                                _10154 = 0.0f;
                                _10155 = 0.0f;
                                _10156 = 0.0f;
                                _10157 = _9075;
                                _10158 = _9076;
                                _10159 = _9077;
                              }
                            } else {
                              if (_319) {
                                _9392 = ((float)((uint)((uint)(_312 & 15)))) * 0.06666667014360428f;
                                _9393 = _268 * 0.0317460335791111f;
                                _9396 = min(1.0f, max((_9393 * ((float)((uint)((uint)((uint)(_311) >> 2))))), 0.019999999552965164f));
                                _9399 = min(1.0f, max((_9393 * ((float)((uint)((uint)((((int)(_311 << 4)) & 48) | ((uint)(_312) >> 4)))))), 0.019999999552965164f));
                                _9402 = ((_9399 - _9396) * _9392) + _9396;
                                _9403 = _9402 * _9402;
                                _9407 = saturate(abs(_8922) + 9.999999747378752e-06f);
                                _9408 = sqrt(_9403 * _9403);
                                _9409 = 1.0f - _9408;
                                _9418 = _9396 * _9396;
                                _9419 = _9418 * _9418;
                                if (_8927) {
                                  _9428 = saturate(((_8790 * _8790) / ((_8920 * 3.5999999046325684f) + 0.4000000059604645f)) + _9419);
                                } else {
                                  _9428 = _9419;
                                }
                                if (_8829) {
                                  _9437 = (((_8788 * 0.25f) * ((sqrt(_9428) * 3.0f) + _8788)) / (_8920 + 0.0010000000474974513f)) + _9428;
                                  _9440 = _9437;
                                  _9441 = (_9428 / _9437);
                                } else {
                                  _9440 = _9428;
                                  _9441 = 1.0f;
                                }
                                if (_8950) {
                                  _9447 = sqrt((1.000100016593933f - _8700) / max(9.999999974752427e-07f, (_8700 + 1.0f)));
                                  _9460 = (sqrt(_9440 / ((((_9447 * 0.25f) * ((sqrt(_9440) * 3.0f) + _9447)) / (_8920 + 0.0010000000474974513f)) + _9440)) * _9441);
                                } else {
                                  _9460 = _9441;
                                }
                                _9461 = _9399 * _9399;
                                _9462 = _9461 * _9461;
                                if (_8927) {
                                  _9471 = saturate(((_8790 * _8790) / ((_8920 * 3.5999999046325684f) + 0.4000000059604645f)) + _9462);
                                } else {
                                  _9471 = _9462;
                                }
                                if (_8829) {
                                  _9480 = (((_8788 * 0.25f) * ((sqrt(_9471) * 3.0f) + _8788)) / (_8920 + 0.0010000000474974513f)) + _9471;
                                  _9483 = _9480;
                                  _9484 = (_9471 / _9480);
                                } else {
                                  _9483 = _9471;
                                  _9484 = 1.0f;
                                }
                                if (_8950) {
                                  _9490 = sqrt((1.000100016593933f - _8700) / max(9.999999974752427e-07f, (_8700 + 1.0f)));
                                  _9503 = (sqrt(_9483 / ((((_9490 * 0.25f) * ((sqrt(_9483) * 3.0f) + _9490)) / (_8920 + 0.0010000000474974513f)) + _9483)) * _9484);
                                } else {
                                  _9503 = _9484;
                                }
                                _9507 = (((_9428 * _8921) - _8921) * _8921) + 1.0f;
                                _9510 = (_9428 / (_9507 * _9507)) * _9460;
                                _9514 = (((_9471 * _8921) - _8921) * _8921) + 1.0f;
                                _9521 = saturate(_8921);
                                _9525 = saturate((_8924 + _6425) / (_6425 + 1.0f));
                                _9530 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_313)))) + 1u))]);
                                _9537 = ((float)((uint)((uint)((uint)((uint)(_9530.x)) >> 24)))) * 0.25f;
                                _9540 = ((float)((uint)((uint)(_9530.x & 255)))) * 0.003921568859368563f;
                                _9544 = ((float)((uint)((uint)(((uint)((uint)(_9530.x)) >> 8) & 255)))) * 0.003921568859368563f;
                                _9548 = ((float)((uint)((uint)(((uint)((uint)(_9530.x)) >> 16) & 255)))) * 0.003921568859368563f;
                                _9557 = ((float)((uint)((uint)((uint)((uint)(_9530.y)) >> 24)))) * 0.25f;
                                _9560 = ((float)((uint)((uint)(_9530.y & 255)))) * 0.003921568859368563f;
                                _9564 = ((float)((uint)((uint)(((uint)((uint)(_9530.y)) >> 8) & 255)))) * 0.003921568859368563f;
                                _9568 = ((float)((uint)((uint)(((uint)((uint)(_9530.y)) >> 16) & 255)))) * 0.003921568859368563f;
                                _9576 = (float)((uint)((uint)(_9530.w & 31)));
                                _9582 = (float)((uint)((uint)(((uint)((uint)(_9530.w)) >> 10) & 31)));
                                _9592 = (float)((uint)((uint)(((uint)((uint)(_9530.w)) >> 25) & 31)));
                                _9595 = ((float)((uint)((uint)(_9530.z & 255)))) * 0.003921568859368563f;
                                _9599 = ((float)((uint)((uint)(((uint)((uint)(_9530.z)) >> 8) & 255)))) * 0.003921568859368563f;
                                _9603 = ((float)((uint)((uint)(((uint)((uint)(_9530.z)) >> 16) & 255)))) * 0.003921568859368563f;
                                _9610 = (((float)((uint)((uint)((uint)((uint)(_9530.z)) >> 24)))) * 0.003921568859368563f) * select(((_9530.w & 1073741824) != 0), -1.0f, 1.0f);
                                _9624 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_9530.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _8980)));
                                _9625 = ((2.0f - (_9576 * 0.06451612710952759f)) > 0.0f);
                                if (_9625) {
                                  _9636 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _9521))) * (10.0f - (_9576 * 0.32258063554763794f))) * _9624);
                                } else {
                                  _9636 = _9624;
                                }
                                _9647 = exp2(log2(max(9.999999747378752e-06f, _9521)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_9530.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                                _9648 = ((2.0f - (_9582 * 0.06451612710952759f)) > 0.0f);
                                if (_9648) {
                                  _9658 = (exp2(log2(max(9.999999747378752e-06f, _8981)) * (10.0f - (_9582 * 0.32258063554763794f))) * _9647);
                                } else {
                                  _9658 = _9647;
                                }
                                if (_9625) {
                                  _9672 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _9521))) * (10.0f - (_9576 * 0.32258063554763794f))) * _9624);
                                } else {
                                  _9672 = _9624;
                                }
                                if (_9648) {
                                  _9685 = (exp2(log2(max(9.999999747378752e-06f, _8981)) * (10.0f - (_9582 * 0.32258063554763794f))) * _9647);
                                } else {
                                  _9685 = _9647;
                                }
                                if (_9625) {
                                  _9699 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _9521))) * (10.0f - (_9576 * 0.32258063554763794f))) * _9624);
                                } else {
                                  _9699 = _9624;
                                }
                                if (_9648) {
                                  _9712 = (exp2(log2(max(9.999999747378752e-06f, _8981)) * (10.0f - (_9582 * 0.32258063554763794f))) * _9647);
                                } else {
                                  _9712 = _9647;
                                }
                                _9724 = (1.0f - exp2(log2(1.0f - _9521) * 3.0f)) * (1.0f - exp2(_8982 * 3.0f));
                                _9728 = saturate(_9525 / (_9724 * (((float)((uint)((uint)(((uint)((uint)(_9530.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                                _9733 = ((_9728 * _9728) * (3.0f - (_9728 * 2.0f))) + -1.0f;
                                _9735 = ((((_9595 * _9595) * _9610) * _9724) * _9733) + 1.0f;
                                _9738 = ((((_9599 * _9599) * _9610) * _9724) * _9733) + 1.0f;
                                _9741 = ((((_9603 * _9603) * _9610) * _9724) * _9733) + 1.0f;
                                _9743 = saturate(_9592 * 0.06451612710952759f);
                                _9750 = exp2(log2(1.0f - _8920) * (10.0f - (_9592 * 0.32258063554763794f)));
                                _9769 = ((((((_9471 / (_9514 * _9514)) * _9503) - _9510) * _9392) + _9510) * (0.5f / ((((_9409 * _9407) + _9408) * _8923) + (((_9409 * _8923) + _9408) * _9407)))) * _8923;
                                _10154 = ((_9769 * _9735) * (((_9743 * _8977) * _9750) + _251));
                                _10155 = ((_9769 * _9738) * (((_9743 * _8978) * _9750) + _252));
                                _10156 = ((_9769 * _9741) * (((_9743 * _8979) * _9750) + _253));
                                _10157 = (((((_9636 * (((_9540 * _9540) * _9537) + -1.0f)) + 1.0f) * _9525) * ((_9658 * (((_9560 * _9560) * _9557) + -1.0f)) + 1.0f)) * _9735);
                                _10158 = (((((_9672 * (((_9544 * _9544) * _9537) + -1.0f)) + 1.0f) * _9525) * ((_9685 * (((_9564 * _9564) * _9557) + -1.0f)) + 1.0f)) * _9738);
                                _10159 = (((((_9699 * (((_9548 * _9548) * _9537) + -1.0f)) + 1.0f) * _9525) * ((_9712 * (((_9568 * _9568) * _9557) + -1.0f)) + 1.0f)) * _9741);
                              } else {
                                if (_241) {
                                  if (_256 < 0.007874015718698502f) {
                                    _9783 = _8921 * _8921;
                                    _9785 = max((1.0f - _9783), 9.999999747378752e-05f);
                                    _9930 = (((((((exp2(((-0.0f - (_9783 / _9785)) / _8936) * 1.4426950216293335f) * 4.0f) / (_9785 * _9785)) + 1.0f) * (1.0f / ((_8936 * 4.0f) + 1.0f))) - _8976) * _257) + _8976);
                                    _9931 = (((saturate(0.25f / ((_8925 + _8922) - (_8925 * _8922))) - _9003) * _257) + _9003);
                                  } else {
                                    _9809 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                                    _9810 = _9809 * _196;
                                    _9811 = _9809 * _197;
                                    _9812 = _9809 * _198;
                                    _9815 = (abs(_9810) < abs(_9811));
                                    _9816 = select(_9815, 1.0f, 0.0f);
                                    _9817 = select(_9815, 0.0f, 1.0f);
                                    _9818 = _9817 * _9812;
                                    _9820 = -0.0f - (_9812 * _9816);
                                    _9823 = (_9816 * _9811) - (_9817 * _9810);
                                    _9825 = rsqrt(dot(float3(_9818, _9820, _9823), float3(_9818, _9820, _9823)));
                                    _9826 = _9818 * _9825;
                                    _9827 = _9825 * _9820;
                                    _9828 = _9823 * _9825;
                                    _9831 = (_9827 * _9812) - (_9828 * _9811);
                                    _9834 = (_9828 * _9810) - (_9826 * _9812);
                                    _9837 = (_9826 * _9811) - (_9827 * _9810);
                                    _9839 = rsqrt(dot(float3(_9831, _9834, _9837), float3(_9831, _9834, _9837)));
                                    _9843 = _257 * 4.0f;
                                    _9852 = saturate(abs(_9843 + -2.5f) + -0.5f) + -0.5f;
                                    _9853 = saturate(1.5f - abs(_9843 + -1.5f)) + -0.5f;
                                    _9855 = rsqrt(dot(float2(_9852, _9853), float2(_9852, _9853)));
                                    _9856 = _9855 * _9852;
                                    _9857 = _9855 * _9853;
                                    _9864 = ((_9831 * _9839) * _9856) + (_9857 * _9826);
                                    _9865 = ((_9834 * _9839) * _9856) + (_9857 * _9827);
                                    _9866 = ((_9837 * _9839) * _9856) + (_9857 * _9828);
                                    _9869 = (_9865 * _198) - (_9866 * _197);
                                    _9872 = (_9866 * _196) - (_9864 * _198);
                                    _9875 = (_9864 * _197) - (_9865 * _196);
                                    _9879 = rsqrt((dot(float3(_601, _602, _600), float3(_8793, _8794, _8795)) * 2.0f) + 2.0f);
                                    _9883 = dot(float3(_9864, _9865, _9866), float3(_8793, _8794, _8795));
                                    _9884 = dot(float3(_9864, _9865, _9866), float3(_601, _602, _600));
                                    _9887 = dot(float3(_9869, _9872, _9875), float3(_8793, _8794, _8795));
                                    _9888 = dot(float3(_9869, _9872, _9875), float3(_601, _602, _600));
                                    _9894 = min(max((_8784 * (_256 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                    _9898 = min(max((_8784 * (1.0f - _256)), 0.0010000000474974513f), 1.0f);
                                    _9899 = _9898 * _9894;
                                    _9900 = ((_9884 + _9883) * _9879) * _9898;
                                    _9901 = ((_9888 + _9887) * _9879) * _9894;
                                    _9902 = _9899 * saturate(_9879 * (_8818 + _8924));
                                    _9903 = dot(float3(_9900, _9901, _9902), float3(_9900, _9901, _9902));
                                    _9908 = _9894 * _9884;
                                    _9909 = _9898 * _9888;
                                    _9917 = _9894 * _9883;
                                    _9918 = _9898 * _9887;
                                    _9930 = (((_9899 * _9899) * _9899) / (_9903 * _9903));
                                    _9931 = saturate(0.5f / ((sqrt(((_9917 * _9917) + (_8925 * _8925)) + (_9918 * _9918)) * _8993) + (sqrt(((_9909 * _9909) + (_9908 * _9908)) + (_8993 * _8993)) * _8925)));
                                  }
                                  _9933 = (_9930 * _8925) * _9931;
                                  _9951 = saturate((_8924 + 0.5f) * 0.6666666865348816f);
                                  _10154 = (_9933 * _8988);
                                  _10155 = (_9933 * _8989);
                                  _10156 = (_9933 * _8990);
                                  _10157 = ((_9951 * (1.0f - _8988)) * saturate((((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _8925));
                                  _10158 = ((_9951 * (1.0f - _8989)) * saturate((((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _8925));
                                  _10159 = ((_9951 * (1.0f - _8990)) * saturate((((_164 + -0.5f) * 0.5f) + 0.5f) + _8925));
                                } else {
                                  if (_263) {
                                    _9966 = _315 * _315;
                                    _9967 = _9966 * _9966;
                                    _9973 = saturate(select((_8785 > 0.0f), ((1.0f - _9966) / _8785), 0.0f) * _8788);
                                    _9974 = (_9973 > 0.0f);
                                    if (_9974) {
                                      _9978 = sqrt(1.0f - (_9973 * _9973));
                                      _9980 = (_8817 * 2.0f) * _8818;
                                      _9981 = _9980 - _8819;
                                      if (!(_9981 >= _9978)) {
                                        _9987 = rsqrt(1.0f - (_9981 * _9981)) * _9973;
                                        _9990 = _9987 * (_8818 - (_9981 * _8817));
                                        _9991 = _8818 * _8818;
                                        _9996 = _9987 * (((_9991 * 2.0f) + -1.0f) - (_9981 * _8819));
                                        _10005 = sqrt(saturate((((1.0f - (_8817 * _8817)) - _9991) - (_8819 * _8819)) + (_9980 * _8819)));
                                        _10006 = _10005 * _9987;
                                        _10009 = ((_8818 * 2.0f) * _9987) * _10005;
                                        _10011 = (_9978 * _8817) + _8818;
                                        _10012 = _10011 + _9990;
                                        _10013 = _9978 * _8819;
                                        _10015 = (_10013 + 1.0f) + _9996;
                                        _10016 = _10006 * _10015;
                                        _10017 = _10012 * _10015;
                                        _10018 = _10009 * _10012;
                                        _10023 = (((_10012 * 0.25f) * _10009) - (_10016 * 0.5f)) * _10017;
                                        _10037 = (((_10018 - (_10016 * 2.0f)) * _10018) + (_10016 * _10016)) + ((((-0.5f - ((_10015 + _10013) * 0.5f)) * _10017) + ((_10015 * _10015) * _10011)) * _10012);
                                        _10042 = (_10023 * 2.0f) / ((_10037 * _10037) + (_10023 * _10023));
                                        _10043 = _10037 * _10042;
                                        _10045 = 1.0f - (_10023 * _10042);
                                        _10051 = ((_10043 * _10009) + _10013) + (_10045 * _9996);
                                        _10054 = rsqrt((_10051 * 2.0f) + 2.0f);
                                        _10063 = saturate((_10051 * _10054) + _10054);
                                        _10064 = saturate(((_10011 + (_10043 * _10006)) + (_10045 * _9990)) * _10054);
                                      } else {
                                        _10063 = _8991;
                                        _10064 = 1.0f;
                                      }
                                    } else {
                                      _10063 = _8828;
                                      _10064 = _8825;
                                    }
                                    if (_8927) {
                                      _10073 = saturate(((_8790 * _8790) / ((_10063 * 3.5999999046325684f) + 0.4000000059604645f)) + _9967);
                                    } else {
                                      _10073 = _9967;
                                    }
                                    if (_9974) {
                                      _10082 = (((_9973 * 0.25f) * ((sqrt(_10073) * 3.0f) + _9973)) / (_10063 + 0.0010000000474974513f)) + _10073;
                                      _10085 = _10082;
                                      _10086 = (_10073 / _10082);
                                    } else {
                                      _10085 = _10073;
                                      _10086 = 1.0f;
                                    }
                                    if (_8950) {
                                      _10092 = sqrt((1.000100016593933f - _8700) / max(9.999999974752427e-07f, (_8700 + 1.0f)));
                                      _10105 = (sqrt(_10085 / ((((_10092 * 0.25f) * ((sqrt(_10085) * 3.0f) + _10092)) / (_10063 + 0.0010000000474974513f)) + _10085)) * _10086);
                                    } else {
                                      _10105 = _10086;
                                    }
                                    _10109 = (((_10073 * _10064) - _10064) * _10064) + 1.0f;
                                    _10119 = sqrt(_10073);
                                    _10120 = 1.0f - _10119;
                                    _10135 = ((((exp2(log2(1.0f - saturate(_10063)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _314) * (((_10105 * _8923) * (_10073 / (_10109 * _10109))) * (0.5f / ((((_10120 * _8993) + _10119) * _8923) + (((_10120 * _8923) + _10119) * _8993)))));
                                    _10136 = false;
                                  } else {
                                    _10135 = 0.0f;
                                    _10136 = true;
                                  }
                                  _10140 = saturate((_8924 + _6425) / (_6425 + 1.0f));
                                  _10142 = (_8976 * _8923) * _9003;
                                  _10146 = _10135 + (_10142 * _8988);
                                  _10147 = _10135 + (_10142 * _8989);
                                  _10148 = _10135 + (_10142 * _8990);
                                  [branch]
                                  if (_10136) {
                                    _10154 = (_10146 * _1337);
                                    _10155 = (_10147 * _1338);
                                    _10156 = (_10148 * _1339);
                                    _10157 = _10140;
                                    _10158 = _10140;
                                    _10159 = _10140;
                                  } else {
                                    _10154 = _10146;
                                    _10155 = _10147;
                                    _10156 = _10148;
                                    _10157 = _10140;
                                    _10158 = _10140;
                                    _10159 = _10140;
                                  }
                                }
                              }
                            }
                            _10160 = _8600 * _1932;
                            _10161 = _8601 * _1932;
                            _10162 = _8602 * _1932;
                            _10169 = ((_8656 * _10160) * _10157) + _1869;
                            _10170 = ((_8656 * _10161) * _10158) + _1870;
                            _10171 = ((_8656 * _10162) * _10159) + _1871;
                            if (_6422 > 0.0f) {
                              _10175 = (_6422 * _1633) * select(_8653, (_8649 * _1480), _8649);
                              _10186 = (((_10175 * _10160) * _10154) + _1872);
                              _10187 = (((_10175 * _10161) * _10155) + _1873);
                              _10188 = (((_10175 * _10162) * _10156) + _1874);
                            } else {
                              _10186 = _1872;
                              _10187 = _1873;
                              _10188 = _1874;
                            }
                            _10192 = _10186 + (_8603 * _10160);
                            _10193 = _10187 + (_8604 * _10161);
                            _10194 = _10188 + (_8605 * _10162);
                            if (!_326) {
                              _10201 = saturate(-0.0f - dot(float3(_601, _602, _600), float3(_6505, _6506, _6507)));
                              _10204 = 1.0f - ((_10201 * _10201) * 0.6399999856948853f);
                              _10209 = saturate(0.30000001192092896f - _6532) * (0.36000001430511475f / (_10204 * _10204));
                              _10210 = _6522 * _1932;
                              _14768 = _10169;
                              _14769 = _10170;
                              _14770 = _10171;
                              _14771 = ((((_333 * _258) * _10210) * _10209) + _10192);
                              _14772 = ((((_334 * _258) * _10210) * _10209) + _10193);
                              _14773 = ((((_335 * _258) * _10210) * _10209) + _10194);
                            } else {
                              _14768 = _10169;
                              _14769 = _10170;
                              _14770 = _10171;
                              _14771 = _10192;
                              _14772 = _10193;
                              _14773 = _10194;
                            }
                          } else {
                            _14768 = _1869;
                            _14769 = _1870;
                            _14770 = _1871;
                            _14771 = _1872;
                            _14772 = _1873;
                            _14773 = _1874;
                          }
                          break;
                        }
                      } else {
                        _14768 = _1869;
                        _14769 = _1870;
                        _14770 = _1871;
                        _14771 = _1872;
                        _14772 = _1873;
                        _14773 = _1874;
                      }
                    } else {
                      if (_1915 == 8) {
                        _10225 = asfloat(srvLightInfoProperties.Load3(_1883)).x;
                        _10226 = asfloat(srvLightInfoProperties.Load3(_1883)).y;
                        _10227 = asfloat(srvLightInfoProperties.Load3(_1883)).z;
                        _10230 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 12u)))).x;
                        _10231 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 12u)))).y;
                        _10232 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 12u)))).z;
                        _10235 = asfloat(srvLightInfoProperties.Load(((int)(_1883 + 24u))));
                        _10238 = asint(srvLightInfoProperties.Load(((int)(_1883 + 28u))));
                        _10241 = asint(srvLightInfoProperties.Load(((int)(_1883 + 32u))));
                        _10244 = asint(srvLightInfoProperties.Load(((int)(_1883 + 44u))));
                        _10253 = ((float)((uint)((uint)(((uint)(_10241) >> 8) & 255)))) * 0.003921499941498041f;
                        _10256 = ((float)((uint)((uint)(_10241 & 255)))) * 0.003921499941498041f;
                        _10259 = f16tof32(_10244);
                        _10266 = min(max(dot(float3((_379 - _10225), (_380 - _10226), (_381 - _10227)), float3(_10230, _10231, _10232)), (-0.0f - _10235)), _10235);
                        _10271 = (_10225 - _379) + (_10266 * _10230);
                        _10273 = (_10226 - _380) + (_10266 * _10231);
                        _10275 = (_10227 + _378) + (_10266 * _10232);
                        _10276 = dot(float3(_10271, _10273, _10275), float3(_10271, _10273, _10275));
                        _10277 = rsqrt(_10276);
                        _10279 = _10271 * _10277;
                        _10280 = _10273 * _10277;
                        _10281 = _10275 * _10277;
                        _10284 = max(0.0f, ((_10277 * _10276) - abs(_10259)));
                        _10285 = _10284 * f16tof32(((uint)((uint)(_10244) >> 16)));
                        _10286 = _10285 * _10285;
                        _10289 = saturate(1.0f - (_10286 * _10286));
                        _10296 = (_10289 * _10289) / (select((_10259 < 0.0f), (_10286 * 16.0f), (_10284 * _10284)) + 1.0f);
                        [branch]
                        if (!(_10296 == 0.0f)) {
                          [branch]
                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                            _10305 = srvLightMappingData[_1884];
                            if (!(_10305 == -1)) {
                              _10310 = srvLightIndexData[_10305].nLayerIndex;
                              _10312 = srvLightIndexData[_10305].vAtlasOrigin.x;
                              _10313 = srvLightIndexData[_10305].vAtlasOrigin.y;
                              _10315 = srvLightIndexData[_10305].vScreenOrigin.x;
                              _10316 = srvLightIndexData[_10305].vScreenOrigin.y;
                              _10325 = ((int)(_10310 * 5)) & 31;
                              _10328 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_10312 + _70) - _10315)), ((int)((_10313 + _71) - _10316)), 0)))).x) & ((int)(31 << _10325)))) >> _10325;
                              _10333 = ((float)((uint)((uint)((uint)(_10328) >> 1)))) * 0.06666667014360428f;
                              _10339 = (_10333 * _10296);
                              _10340 = (select(_212, ((float)((bool)(uint)((_10328 & 1) != 0))), _10333) * _10296);
                            } else {
                              _10339 = _10296;
                              _10340 = _10296;
                            }
                          } else {
                            _10339 = _10296;
                            _10340 = _10296;
                          }
                          _10344 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                          _10347 = select(_10344, (_10339 * _1480), _10339);
                          _10349 = dot(float3(_196, _197, _198), float3(_10279, _10280, _10281));
                          _10350 = saturate(_10349);
                          if (_319) {
                            _10358 = (_10350 * (_196 - _359)) + _359;
                            _10359 = (_10350 * (_197 - _360)) + _360;
                            _10360 = (_10350 * (_198 - _361)) + _361;
                            _10362 = rsqrt(dot(float3(_10358, _10359, _10360), float3(_10358, _10359, _10360)));
                            _10367 = (_10358 * _10362);
                            _10368 = (_10359 * _10362);
                            _10369 = (_10360 * _10362);
                          } else {
                            _10367 = _196;
                            _10368 = _197;
                            _10369 = _198;
                          }
                          _10370 = dot(float3(_10367, _10368, _10369), float3(_10279, _10280, _10281));
                          _10371 = dot(float3(_10367, _10368, _10369), float3(_601, _602, _600));
                          _10372 = dot(float3(_601, _602, _600), float3(_10279, _10280, _10281));
                          _10375 = rsqrt((_10372 * 2.0f) + 2.0f);
                          _10378 = saturate(_10375 * (_10371 + _10370));
                          _10381 = saturate((_10375 * _10372) + _10375);
                          _10382 = saturate(_10371);
                          _10383 = saturate(_10370);
                          _10384 = _268 * _268;
                          _10385 = _10384 * _10384;
                          _10389 = (((_10378 * _10385) - _10378) * _10378) + 1.0f;
                          _10391 = _10385 / (_10389 * _10389);
                          _10392 = 1.0f - _251;
                          _10393 = 1.0f - _252;
                          _10394 = 1.0f - _253;
                          _10395 = saturate(_10381);
                          _10396 = 1.0f - _10395;
                          _10397 = log2(_10396);
                          _10399 = exp2(_10397 * 5.0f);
                          _10403 = (_10399 * _10392) + _251;
                          _10404 = (_10399 * _10393) + _252;
                          _10405 = (_10399 * _10394) + _253;
                          _10408 = saturate(abs(_10371) + 9.999999747378752e-06f);
                          _10409 = sqrt(_10385);
                          _10410 = 1.0f - _10409;
                          _10418 = 0.5f / ((((_10410 * _10408) + _10409) * _10350) + (((_10410 * _10350) + _10409) * _10408));
                          if (_212) {
                            _10428 = ((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                            _10429 = ((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                            _10430 = ((_164 + -0.5f) * 0.5f) + 0.5f;
                            _10447 = ((dot(float3((-0.0f - _10367), (-0.0f - _10368), (-0.0f - _10369)), float3(_10279, _10280, _10281)) + dot(float3((-0.0f - _601), (-0.0f - _602), (-0.0f - _600)), float3(_10279, _10280, _10281))) * 0.5f) * exp2(log2(1.0f - _10382) * (11.0f - (((float)((uint)((uint)((uint)(_310) >> 2)))) * 0.1666666716337204f)));
                            _10456 = saturate((_1481 + -0.009999999776482582f) * -100.0f);
                            _10461 = ((_10456 * _10456) * 3.0f) * (3.0f - (_10456 * 2.0f));
                            _10468 = 10.0f - (exp2(log2(saturate(_1481 * 5.0f)) * 3.0f) * 9.0f);
                            _10469 = saturate(_10383 + _10428) * _10383;
                            _10470 = saturate(_10383 + _10429) * _10383;
                            _10471 = saturate(_10383 + _10430) * _10383;
                            _10490 = (max(((_10461 + _10428) * _10447), 0.0f) * _10468) + sqrt(_10469 * _10469);
                            _10491 = (max(((_10461 + _10429) * _10447), 0.0f) * _10468) + sqrt(_10470 * _10470);
                            _10492 = (max(((_10461 + _10430) * _10447), 0.0f) * _10468) + sqrt(_10471 * _10471);
                            _10493 = _10279 + _601;
                            _10494 = _10280 + _602;
                            _10495 = _10281 + _600;
                            _10497 = rsqrt(dot(float3(_10493, _10494, _10495), float3(_10493, _10494, _10495)));
                            if (!(select((_309 != 0), 1.0f, 0.0f) < 1.0f)) {
                              _10508 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                              _10509 = _10508 * _196;
                              _10510 = _10508 * _197;
                              _10511 = _10508 * _198;
                              _10514 = (abs(_10509) < abs(_10510));
                              _10515 = select(_10514, 1.0f, 0.0f);
                              _10516 = select(_10514, 0.0f, 1.0f);
                              _10517 = _10516 * _10511;
                              _10519 = -0.0f - (_10511 * _10515);
                              _10522 = (_10515 * _10510) - (_10516 * _10509);
                              _10524 = rsqrt(dot(float3(_10517, _10519, _10522), float3(_10517, _10519, _10522)));
                              _10525 = _10517 * _10524;
                              _10526 = _10524 * _10519;
                              _10527 = _10522 * _10524;
                              _10530 = (_10526 * _10511) - (_10527 * _10510);
                              _10533 = (_10527 * _10509) - (_10525 * _10511);
                              _10536 = (_10525 * _10510) - (_10526 * _10509);
                              _10538 = rsqrt(dot(float3(_10530, _10533, _10536), float3(_10530, _10533, _10536)));
                              _10550 = saturate(abs(_308 + -2.5f) + -0.5f) + -0.5f;
                              _10551 = saturate(1.5f - abs(_308 + -1.5f)) + -0.5f;
                              _10553 = rsqrt(dot(float2(_10550, _10551), float2(_10550, _10551)));
                              _10554 = _10553 * _10550;
                              _10555 = _10553 * _10551;
                              _10562 = ((_10530 * _10538) * _10554) + (_10555 * _10525);
                              _10563 = ((_10533 * _10538) * _10554) + (_10555 * _10526);
                              _10564 = ((_10536 * _10538) * _10554) + (_10555 * _10527);
                              _10567 = min(max(dot(float3(_10562, _10563, _10564), float3(_10279, _10280, _10281)), -1.0f), 1.0f);
                              _10570 = min(max(dot(float3(_10562, _10563, _10564), float3(_601, _602, _600)), -1.0f), 1.0f);
                              _10571 = abs(_10570);
                              _10576 = (1.5707963705062866f - (_10571 * 0.1565829962491989f)) * sqrt(1.0f - _10571);
                              _10580 = abs(_10567);
                              _10585 = (1.5707963705062866f - (_10580 * 0.1565829962491989f)) * sqrt(1.0f - _10580);
                              _10592 = cos(abs(select((_10567 >= 0.0f), _10585, (3.1415927410125732f - _10585)) - select((_10570 >= 0.0f), _10576, (3.1415927410125732f - _10576))) * 0.5f);
                              _10596 = _10279 - (_10567 * _10562);
                              _10597 = _10280 - (_10567 * _10563);
                              _10598 = _10281 - (_10567 * _10564);
                              _10602 = _601 - (_10570 * _10562);
                              _10603 = _602 - (_10570 * _10563);
                              _10604 = _600 - (_10570 * _10564);
                              _10611 = rsqrt((dot(float3(_10602, _10603, _10604), float3(_10602, _10603, _10604)) * dot(float3(_10596, _10597, _10598), float3(_10596, _10597, _10598))) + 9.999999747378752e-05f) * dot(float3(_10596, _10597, _10598), float3(_10602, _10603, _10604));
                              _10615 = sqrt(saturate((_10611 * 0.5f) + 0.5f));
                              _10619 = _10384 * 0.5f;
                              _10620 = _10384 * 2.0f;
                              _10621 = select(((_310 & 1) != 0), 0.0f, 1.9287520390554007e-22f);
                              _10624 = saturate((_10349 + 0.5f) * 0.6666666865348816f);
                              _10634 = (_10570 + _10567) + ((((_10615 * 0.9975510239601135f) * sqrt(1.0f - (_10570 * _10570))) - (_10570 * 0.06994284689426422f)) * 0.13988569378852844f);
                              _10636 = (_10384 * 1.4142135381698608f) * _10615;
                              _10649 = 1.0f - sqrt(saturate((_10372 * 0.5f) + 0.5f));
                              _10650 = _10649 * _10649;
                              _10656 = saturate(-0.0f - _10372);
                              _10659 = (1.0f - saturate(_10656)) * _10624;
                              _10668 = ((((_10615 * 0.5f) * (exp2((((_10634 * _10634) * -0.5f) / (_10636 * _10636)) * 1.4426950216293335f) / (_10636 * 2.5066282749176025f))) * min(_255, 0.5f)) * (((_10650 * _10650) * (_10649 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_10659, 1.0f, _10621));
                              _10670 = (_10567 + -0.03500000014901161f) + _10570;
                              _10679 = 1.0f / ((1.190000057220459f / _10592) + (_10592 * 0.36000001430511475f));
                              _10684 = ((_10679 * (0.6000000238418579f - (_10611 * 0.800000011920929f))) + 1.0f) * _10615;
                              _10690 = 1.0f - (sqrt(saturate(1.0f - (_10684 * _10684))) * _10592);
                              _10691 = _10690 * _10690;
                              _10695 = 0.9534794092178345f - ((_10691 * _10691) * (_10690 * 0.9534794092178345f));
                              _10696 = _10684 * _10679;
                              _10701 = (sqrt(1.0f - (_10696 * _10696)) * 0.5f) / _10592;
                              _10720 = 1.0f - saturate((_10656 + -0.44999998807907104f) * 2.222222328186035f);
                              _10723 = ((1.0f - _10624) * _10621) + _10624;
                              _10726 = ((_10695 * _10695) * (exp2((((_10670 * _10670) * -0.5f) / (_10619 * _10619)) * 1.4426950216293335f) / (_10384 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_10611 * 5.2658371925354f));
                              _10740 = (_10567 + -0.14000000059604645f) + _10570;
                              _10750 = 1.0f - (_10592 * 0.5f);
                              _10751 = _10750 * _10750;
                              _10755 = (_10751 * _10751) * (0.9534794092178345f - (_10592 * 0.47673970460891724f));
                              _10757 = 0.9534794092178345f - _10755;
                              _10759 = (_10757 * _10757) * (_10755 + 0.04652056470513344f);
                              _10762 = exp2((_10611 * 24.525815963745117f) + -24.208423614501953f);
                              _10775 = ((exp2((((_10740 * _10740) * -0.5f) / (_10620 * _10620)) * 1.4426950216293335f) / (_10384 * 5.013256549835205f)) * (lerp(_10759, 1.0f, _220))) * (((exp2((saturate(dot(float3((_10497 * _10493), (_10497 * _10494), (_10497 * _10495)), float3(_196, _197, _198))) * 17.312339782714844f) + -14.109557151794434f) - _10762) * _220) + _10762);
                              _11320 = (((((exp2(log2(max(_162, 0.0f)) * _10701) * _10723) * _10726) * _10720) + _10668) + (_10775 * _162));
                              _11321 = (((((exp2(log2(max(_163, 0.0f)) * _10701) * _10723) * _10726) * _10720) + _10668) + (_10775 * _163));
                              _11322 = (((((exp2(log2(max(_164, 0.0f)) * _10701) * _10723) * _10726) * _10720) + _10668) + (_10775 * _164));
                              _11323 = _10490;
                              _11324 = _10491;
                              _11325 = _10492;
                            } else {
                              _11320 = 0.0f;
                              _11321 = 0.0f;
                              _11322 = 0.0f;
                              _11323 = _10490;
                              _11324 = _10491;
                              _11325 = _10492;
                            }
                          } else {
                            if (_319) {
                              _10793 = ((float)((uint)((uint)(_312 & 15)))) * 0.06666667014360428f;
                              _10794 = _268 * 0.0317460335791111f;
                              _10797 = min(1.0f, max((_10794 * ((float)((uint)((uint)((uint)(_311) >> 2))))), 0.019999999552965164f));
                              _10800 = min(1.0f, max((_10794 * ((float)((uint)((uint)((((int)(_311 << 4)) & 48) | ((uint)(_312) >> 4)))))), 0.019999999552965164f));
                              _10803 = ((_10800 - _10797) * _10793) + _10797;
                              _10804 = _10803 * _10803;
                              _10808 = saturate(abs(_10382) + 9.999999747378752e-06f);
                              _10809 = sqrt(_10804 * _10804);
                              _10810 = 1.0f - _10809;
                              _10819 = _10797 * _10797;
                              _10820 = _10819 * _10819;
                              _10821 = _10800 * _10800;
                              _10822 = _10821 * _10821;
                              _10826 = (((_10820 * _10378) - _10378) * _10378) + 1.0f;
                              _10828 = _10820 / (_10826 * _10826);
                              _10832 = (((_10822 * _10378) - _10378) * _10378) + 1.0f;
                              _10838 = saturate(_10378);
                              _10842 = saturate((_10370 + _10256) / (_10256 + 1.0f));
                              _10847 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_313)))) + 1u))]);
                              _10854 = ((float)((uint)((uint)((uint)((uint)(_10847.x)) >> 24)))) * 0.25f;
                              _10857 = ((float)((uint)((uint)(_10847.x & 255)))) * 0.003921568859368563f;
                              _10861 = ((float)((uint)((uint)(((uint)((uint)(_10847.x)) >> 8) & 255)))) * 0.003921568859368563f;
                              _10865 = ((float)((uint)((uint)(((uint)((uint)(_10847.x)) >> 16) & 255)))) * 0.003921568859368563f;
                              _10874 = ((float)((uint)((uint)((uint)((uint)(_10847.y)) >> 24)))) * 0.25f;
                              _10877 = ((float)((uint)((uint)(_10847.y & 255)))) * 0.003921568859368563f;
                              _10881 = ((float)((uint)((uint)(((uint)((uint)(_10847.y)) >> 8) & 255)))) * 0.003921568859368563f;
                              _10885 = ((float)((uint)((uint)(((uint)((uint)(_10847.y)) >> 16) & 255)))) * 0.003921568859368563f;
                              _10893 = (float)((uint)((uint)(_10847.w & 31)));
                              _10899 = (float)((uint)((uint)(((uint)((uint)(_10847.w)) >> 10) & 31)));
                              _10909 = (float)((uint)((uint)(((uint)((uint)(_10847.w)) >> 25) & 31)));
                              _10912 = ((float)((uint)((uint)(_10847.z & 255)))) * 0.003921568859368563f;
                              _10916 = ((float)((uint)((uint)(((uint)((uint)(_10847.z)) >> 8) & 255)))) * 0.003921568859368563f;
                              _10920 = ((float)((uint)((uint)(((uint)((uint)(_10847.z)) >> 16) & 255)))) * 0.003921568859368563f;
                              _10927 = (((float)((uint)((uint)((uint)((uint)(_10847.z)) >> 24)))) * 0.003921568859368563f) * select(((_10847.w & 1073741824) != 0), -1.0f, 1.0f);
                              _10941 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_10847.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _10395)));
                              _10942 = ((2.0f - (_10893 * 0.06451612710952759f)) > 0.0f);
                              if (_10942) {
                                _10953 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _10838))) * (10.0f - (_10893 * 0.32258063554763794f))) * _10941);
                              } else {
                                _10953 = _10941;
                              }
                              _10964 = exp2(log2(max(9.999999747378752e-06f, _10838)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_10847.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                              _10965 = ((2.0f - (_10899 * 0.06451612710952759f)) > 0.0f);
                              if (_10965) {
                                _10975 = (exp2(log2(max(9.999999747378752e-06f, _10396)) * (10.0f - (_10899 * 0.32258063554763794f))) * _10964);
                              } else {
                                _10975 = _10964;
                              }
                              if (_10942) {
                                _10989 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _10838))) * (10.0f - (_10893 * 0.32258063554763794f))) * _10941);
                              } else {
                                _10989 = _10941;
                              }
                              if (_10965) {
                                _11002 = (exp2(log2(max(9.999999747378752e-06f, _10396)) * (10.0f - (_10899 * 0.32258063554763794f))) * _10964);
                              } else {
                                _11002 = _10964;
                              }
                              if (_10942) {
                                _11016 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _10838))) * (10.0f - (_10893 * 0.32258063554763794f))) * _10941);
                              } else {
                                _11016 = _10941;
                              }
                              if (_10965) {
                                _11029 = (exp2(log2(max(9.999999747378752e-06f, _10396)) * (10.0f - (_10899 * 0.32258063554763794f))) * _10964);
                              } else {
                                _11029 = _10964;
                              }
                              _11041 = (1.0f - exp2(log2(1.0f - _10838) * 3.0f)) * (1.0f - exp2(_10397 * 3.0f));
                              _11045 = saturate(_10842 / (_11041 * (((float)((uint)((uint)(((uint)((uint)(_10847.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                              _11050 = ((_11045 * _11045) * (3.0f - (_11045 * 2.0f))) + -1.0f;
                              _11052 = ((((_10912 * _10912) * _10927) * _11041) * _11050) + 1.0f;
                              _11055 = ((((_10916 * _10916) * _10927) * _11041) * _11050) + 1.0f;
                              _11058 = ((((_10920 * _10920) * _10927) * _11041) * _11050) + 1.0f;
                              _11060 = saturate(_10909 * 0.06451612710952759f);
                              _11067 = exp2(log2(1.0f - _10381) * (10.0f - (_10909 * 0.32258063554763794f)));
                              _11086 = (((((_10822 / (_10832 * _10832)) - _10828) * _10793) + _10828) * (0.5f / ((((_10810 * _10808) + _10809) * _10350) + (((_10810 * _10350) + _10809) * _10808)))) * _10350;
                              _11320 = ((_11086 * _11052) * (((_11060 * _10392) * _11067) + _251));
                              _11321 = ((_11086 * _11055) * (((_11060 * _10393) * _11067) + _252));
                              _11322 = ((_11086 * _11058) * (((_11060 * _10394) * _11067) + _253));
                              _11323 = (((((_10953 * (((_10857 * _10857) * _10854) + -1.0f)) + 1.0f) * _10842) * ((_10975 * (((_10877 * _10877) * _10874) + -1.0f)) + 1.0f)) * _11052);
                              _11324 = (((((_10989 * (((_10861 * _10861) * _10854) + -1.0f)) + 1.0f) * _10842) * ((_11002 * (((_10881 * _10881) * _10874) + -1.0f)) + 1.0f)) * _11055);
                              _11325 = (((((_11016 * (((_10865 * _10865) * _10854) + -1.0f)) + 1.0f) * _10842) * ((_11029 * (((_10885 * _10885) * _10874) + -1.0f)) + 1.0f)) * _11058);
                            } else {
                              if (_241) {
                                if (_256 < 0.007874015718698502f) {
                                  _11100 = _10378 * _10378;
                                  _11102 = max((1.0f - _11100), 9.999999747378752e-05f);
                                  _11240 = (((((((exp2(((-0.0f - (_11100 / _11102)) / _10385) * 1.4426950216293335f) * 4.0f) / (_11102 * _11102)) + 1.0f) * (1.0f / ((_10385 * 4.0f) + 1.0f))) - _10391) * _257) + _10391);
                                  _11241 = (((saturate(0.25f / ((_10383 + _10382) - (_10383 * _10382))) - _10418) * _257) + _10418);
                                } else {
                                  _11126 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                                  _11127 = _11126 * _196;
                                  _11128 = _11126 * _197;
                                  _11129 = _11126 * _198;
                                  _11132 = (abs(_11127) < abs(_11128));
                                  _11133 = select(_11132, 1.0f, 0.0f);
                                  _11134 = select(_11132, 0.0f, 1.0f);
                                  _11135 = _11134 * _11129;
                                  _11137 = -0.0f - (_11129 * _11133);
                                  _11140 = (_11133 * _11128) - (_11134 * _11127);
                                  _11142 = rsqrt(dot(float3(_11135, _11137, _11140), float3(_11135, _11137, _11140)));
                                  _11143 = _11135 * _11142;
                                  _11144 = _11142 * _11137;
                                  _11145 = _11140 * _11142;
                                  _11148 = (_11144 * _11129) - (_11145 * _11128);
                                  _11151 = (_11145 * _11127) - (_11143 * _11129);
                                  _11154 = (_11143 * _11128) - (_11144 * _11127);
                                  _11156 = rsqrt(dot(float3(_11148, _11151, _11154), float3(_11148, _11151, _11154)));
                                  _11160 = _257 * 4.0f;
                                  _11169 = saturate(abs(_11160 + -2.5f) + -0.5f) + -0.5f;
                                  _11170 = saturate(1.5f - abs(_11160 + -1.5f)) + -0.5f;
                                  _11172 = rsqrt(dot(float2(_11169, _11170), float2(_11169, _11170)));
                                  _11173 = _11172 * _11169;
                                  _11174 = _11172 * _11170;
                                  _11181 = ((_11148 * _11156) * _11173) + (_11174 * _11143);
                                  _11182 = ((_11151 * _11156) * _11173) + (_11174 * _11144);
                                  _11183 = ((_11154 * _11156) * _11173) + (_11174 * _11145);
                                  _11186 = (_11182 * _198) - (_11183 * _197);
                                  _11189 = (_11183 * _196) - (_11181 * _198);
                                  _11192 = (_11181 * _197) - (_11182 * _196);
                                  _11193 = dot(float3(_11181, _11182, _11183), float3(_10279, _10280, _10281));
                                  _11194 = dot(float3(_11181, _11182, _11183), float3(_601, _602, _600));
                                  _11197 = dot(float3(_11186, _11189, _11192), float3(_10279, _10280, _10281));
                                  _11198 = dot(float3(_11186, _11189, _11192), float3(_601, _602, _600));
                                  _11204 = min(max((_10384 * (_256 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                  _11208 = min(max((_10384 * (1.0f - _256)), 0.0010000000474974513f), 1.0f);
                                  _11209 = _11208 * _11204;
                                  _11210 = ((_11194 + _11193) * _10375) * _11208;
                                  _11211 = ((_11198 + _11197) * _10375) * _11204;
                                  _11212 = _11209 * _10378;
                                  _11213 = dot(float3(_11210, _11211, _11212), float3(_11210, _11211, _11212));
                                  _11218 = _11204 * _11194;
                                  _11219 = _11208 * _11198;
                                  _11227 = _11204 * _11193;
                                  _11228 = _11208 * _11197;
                                  _11240 = (((_11209 * _11209) * _11209) / (_11213 * _11213));
                                  _11241 = saturate(0.5f / ((sqrt(((_11227 * _11227) + (_10383 * _10383)) + (_11228 * _11228)) * _10408) + (sqrt(((_11219 * _11219) + (_11218 * _11218)) + (_10408 * _10408)) * _10383)));
                                }
                                _11243 = (_11240 * _10383) * _11241;
                                _11261 = saturate((_10370 + 0.5f) * 0.6666666865348816f);
                                _11320 = (_11243 * _10403);
                                _11321 = (_11243 * _10404);
                                _11322 = (_11243 * _10405);
                                _11323 = ((_11261 * (1.0f - _10403)) * saturate((((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _10383));
                                _11324 = ((_11261 * (1.0f - _10404)) * saturate((((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _10383));
                                _11325 = ((_11261 * (1.0f - _10405)) * saturate((((_164 + -0.5f) * 0.5f) + 0.5f) + _10383));
                              } else {
                                if (_263) {
                                  _11276 = _315 * _315;
                                  _11277 = _11276 * _11276;
                                  _11281 = (((_10378 * _11277) - _10378) * _10378) + 1.0f;
                                  _11286 = sqrt(_11277);
                                  _11287 = 1.0f - _11286;
                                  _11301 = ((((_10399 * 0.9599999785423279f) + 0.03999999910593033f) * _314) * (((_11277 / (_11281 * _11281)) * _10350) * (0.5f / ((((_11287 * _10408) + _11286) * _10350) + (((_11287 * _10350) + _11286) * _10408)))));
                                  _11302 = false;
                                } else {
                                  _11301 = 0.0f;
                                  _11302 = true;
                                }
                                _11306 = saturate((_10370 + _10256) / (_10256 + 1.0f));
                                _11308 = (_10391 * _10350) * _10418;
                                _11312 = _11301 + (_11308 * _10403);
                                _11313 = _11301 + (_11308 * _10404);
                                _11314 = _11301 + (_11308 * _10405);
                                [branch]
                                if (_11302) {
                                  _11320 = (_11312 * _1337);
                                  _11321 = (_11313 * _1338);
                                  _11322 = (_11314 * _1339);
                                  _11323 = _11306;
                                  _11324 = _11306;
                                  _11325 = _11306;
                                } else {
                                  _11320 = _11312;
                                  _11321 = _11313;
                                  _11322 = _11314;
                                  _11323 = _11306;
                                  _11324 = _11306;
                                  _11325 = _11306;
                                }
                              }
                            }
                          }
                          _11326 = f16tof32(((uint)((uint)(_10238) >> 16))) * _1932;
                          _11327 = f16tof32(_10238) * _1932;
                          _11328 = f16tof32(((uint)((uint)(_10241) >> 16))) * _1932;
                          _11335 = ((_10347 * _11326) * _11323) + _1869;
                          _11336 = ((_10347 * _11327) * _11324) + _1870;
                          _11337 = ((_10347 * _11328) * _11325) + _1871;
                          if (_10253 > 0.0f) {
                            _11341 = (_10253 * _1633) * select(_10344, (_10340 * _1480), _10340);
                            _14768 = _11335;
                            _14769 = _11336;
                            _14770 = _11337;
                            _14771 = (((_11341 * _11326) * _11320) + _1872);
                            _14772 = (((_11341 * _11327) * _11321) + _1873);
                            _14773 = (((_11341 * _11328) * _11322) + _1874);
                          } else {
                            _14768 = _11335;
                            _14769 = _11336;
                            _14770 = _11337;
                            _14771 = _1872;
                            _14772 = _1873;
                            _14773 = _1874;
                          }
                        } else {
                          _14768 = _1869;
                          _14769 = _1870;
                          _14770 = _1871;
                          _14771 = _1872;
                          _14772 = _1873;
                          _14773 = _1874;
                        }
                      } else {
                        if (_1915 == 9) {
                          _11356 = asfloat(srvLightInfoProperties.Load4(_1883)).x;
                          _11357 = asfloat(srvLightInfoProperties.Load4(_1883)).y;
                          _11358 = asfloat(srvLightInfoProperties.Load4(_1883)).w;
                          _11361 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).x;
                          _11362 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).y;
                          _11363 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).w;
                          _11366 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).x;
                          _11367 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).y;
                          _11368 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).w;
                          _11371 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 48u)))).x;
                          _11372 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 48u)))).y;
                          _11373 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 48u)))).w;
                          _11376 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 64u)))).x;
                          _11377 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 64u)))).y;
                          _11378 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 64u)))).z;
                          _11381 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 76u)))).x;
                          _11382 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 76u)))).y;
                          _11383 = asfloat(srvLightInfoProperties.Load3(((int)(_1883 + 76u)))).z;
                          _11386 = asint(srvLightInfoProperties.Load(((int)(_1883 + 88u))));
                          _11389 = asint(srvLightInfoProperties.Load(((int)(_1883 + 92u))));
                          _11392 = asint(srvLightInfoProperties.Load(((int)(_1883 + 100u))));
                          _11395 = asint(srvLightInfoProperties.Load(((int)(_1883 + 104u))));
                          _11398 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).x;
                          _11399 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).y;
                          _11400 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).z;
                          _11401 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 108u)))).w;
                          _11404 = asint(srvLightInfoProperties.Load(((int)(_1883 + 124u))));
                          _11407 = asint(srvLightInfoProperties.Load(((int)(_1883 + 128u))));
                          _11410 = asint(srvLightInfoProperties.Load(((int)(_1883 + 132u))));
                          _11413 = asint(srvLightInfoProperties.Load(((int)(_1883 + 136u))));
                          _11416 = asint(srvLightInfoProperties.Load(((int)(_1883 + 140u))));
                          _11419 = asint(srvLightInfoProperties.Load(((int)(_1883 + 144u))));
                          _11422 = asint(srvLightInfoProperties.Load(((int)(_1883 + 148u))));
                          _11425 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 152u)))).x;
                          _11426 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 152u)))).y;
                          _11427 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 152u)))).z;
                          _11428 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 152u)))).w;
                          _11431 = asint(srvLightInfoProperties.Load(((int)(_1883 + 168u))));
                          _11434 = asint(srvLightInfoProperties.Load(((int)(_1883 + 172u))));
                          _11437 = asint(srvLightInfoProperties.Load(((int)(_1883 + 176u))));
                          _11440 = asint(srvLightInfoProperties.Load(((int)(_1883 + 180u))));
                          _11442 = f16tof32(((uint)((uint)(_11386) >> 16)));
                          _11443 = f16tof32(_11386);
                          _11445 = f16tof32(((uint)((uint)(_11389) >> 16)));
                          _11449 = ((float)((uint)((uint)(((uint)(_11389) >> 8) & 255)))) * 0.003921499941498041f;
                          _11452 = ((float)((uint)((uint)(_11389 & 255)))) * 0.003921499941498041f;
                          _11453 = f16tof32(_11392);
                          _11455 = f16tof32(((uint)((uint)(_11395) >> 16)));
                          _11459 = f16tof32(_11404);
                          _11464 = _11410 & 65535;
                          _11472 = ((_1881 & 3584) != 0);
                          _11489 = f16tof32(((uint)((uint)(_11440) >> 16)));
                          _11490 = 1.0f / _11489;
                          _11491 = _11489 + -1.0f;
                          _11492 = f16tof32(_11440);
                          _11498 = _318 && (_317 && ((cbSharedPerViewData.nLightingShadowFeatures & 1) != 0));
                          _11499 = _11376 - _379;
                          _11500 = _11377 - _380;
                          _11501 = _11378 + _378;
                          _11502 = dot(float3(_11499, _11500, _11501), float3(_11499, _11500, _11501));
                          _11503 = rsqrt(_11502);
                          _11504 = _11503 * _11502;
                          _11505 = _11503 * _11499;
                          _11506 = _11503 * _11500;
                          _11507 = _11503 * _11501;
                          _11510 = max(0.0f, (_11504 - abs(_11459)));
                          _11511 = _11510 * f16tof32(((uint)((uint)(_11404) >> 16)));
                          _11512 = _11511 * _11511;
                          _11515 = saturate(1.0f - (_11512 * _11512));
                          _11526 = mad(_381, _11368, mad(_380, _11363, (_11358 * _379))) + _11373;
                          _11527 = dot(float3(_196, _197, _198), float3(_11505, _11506, _11507));
                          _11530 = saturate(1.0f - _11527) * f16tof32(_11431);
                          _11537 = ((_11526 * _196) * _11530) + _379;
                          _11538 = ((_11526 * _197) * _11530) + _380;
                          _11539 = ((_11526 * _198) * _11530) - _378;
                          _11551 = mad(_11539, _11368, mad(_11538, _11363, (_11537 * _11358))) + _11373;
                          _11552 = 1.0f / _11551;
                          _11553 = _11552 * (mad(_11539, _11366, mad(_11538, _11361, (_11537 * _11356))) + _11371);
                          _11554 = _11552 * (mad(_11539, _11367, mad(_11538, _11362, (_11537 * _11357))) + _11372);
                          _11557 = (_11553 * _11398) + _11399;
                          _11558 = (_11554 * _11398) + _11399;
                          _11561 = _11557 - saturate(_11557);
                          _11562 = _11558 - saturate(_11558);
                          _11569 = saturate((sqrt((_11561 * _11561) + (_11562 * _11562)) * _11400) + _11401);
                          _11571 = 1.0f - (_11569 * _11569);
                          _11577 = (_11571 * _11571) * (((float)((bool)(uint)((_11551 - f16tof32(((uint)((uint)(_11407) >> 16)))) > 0.0f))) * ((_11515 * _11515) / (select((_11459 < 0.0f), (_11512 * 16.0f), (_11510 * _11510)) + 1.0f)));
                          if (_11577 > 0.0f) {
                            [branch]
                            if (_11472) {
                              _11583 = 1.0f - saturate(_11551 * f16tof32(_11407));
                              _11584 = saturate(_11553);
                              _11585 = saturate(_11554);
                              bool __branch_chain_11580;
                              [branch]
                              if ((_1881 & 1024) == 0) {
                                _11899 = 1.0f;
                                _11900 = 1.0f;
                                _11901 = 0.0f;
                                _11902 = _11583;
                                __branch_chain_11580 = true;
                              } else {
                                _11590 = ((_11584 * _11491) + 0.5f) * _11490;
                                _11592 = ((_11585 * _11491) + 0.5f) * _11490;
                                _11593 = _11583 + f16tof32(((uint)((uint)(_11431) >> 16)));
                                Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_11410) >> 16))];
                                _11596 = select(_11498, f16tof32(((uint)((uint)(_11437) >> 16))), f16tof32(((uint)((uint)(_11434) >> 16))));
                                _11597 = saturate(_11593);
                                _11601 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                _11610 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 6u) : (frac(frac(dot(float2(((_11601 * 32.665000915527344f) + _362), ((_11601 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                _11611 = sin(_11610);
                                _11612 = cos(_11610);
                                _11613 = cbSharedPerViewData.nFrameCounter & 3;
                                _11618 = sqrt((float((int)(_11613)) * 0.25f) + 0.125f) * _11596;
                                _11627 = (_global_7[min((uint)(((int)(0u + (_11613 * 2)))), 127u)]) * _11618;
                                _11628 = (_global_7[min((uint)(((int)(1u + (_11613 * 2)))), 127u)]) * _11618;
                                _11630 = -0.0f - _11611;
                                _11635 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_11627, _11628), float2(_11612, _11611)) + _11590), (dot(float2(_11627, _11628), float2(_11630, _11612)) + _11592)));
                                _11640 = _11635.x - _11597;
                                _11642 = select((_11640 < 0.0f), 0.0f, 1.0f);
                                _11644 = _11635.y - _11597;
                                _11646 = select((_11644 < 0.0f), 0.0f, 1.0f);
                                _11650 = _11635.z - _11597;
                                _11652 = select((_11650 < 0.0f), 0.0f, 1.0f);
                                _11656 = _11635.w - _11597;
                                _11658 = select((_11656 < 0.0f), 0.0f, 1.0f);
                                _11665 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                _11670 = sqrt((float((int)(_11665)) * 0.25f) + 0.125f) * _11596;
                                _11679 = (_global_7[min((uint)(((int)(0u + (_11665 * 2)))), 127u)]) * _11670;
                                _11680 = (_global_7[min((uint)(((int)(1u + (_11665 * 2)))), 127u)]) * _11670;
                                _11686 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_11679, _11680), float2(_11612, _11611)) + _11590), (dot(float2(_11679, _11680), float2(_11630, _11612)) + _11592)));
                                _11691 = _11686.x - _11597;
                                _11693 = select((_11691 < 0.0f), 0.0f, 1.0f);
                                _11697 = _11686.y - _11597;
                                _11699 = select((_11697 < 0.0f), 0.0f, 1.0f);
                                _11703 = _11686.z - _11597;
                                _11705 = select((_11703 < 0.0f), 0.0f, 1.0f);
                                _11709 = _11686.w - _11597;
                                _11711 = select((_11709 < 0.0f), 0.0f, 1.0f);
                                _11718 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                _11723 = sqrt((float((int)(_11718)) * 0.25f) + 0.125f) * _11596;
                                _11732 = (_global_7[min((uint)(((int)(0u + (_11718 * 2)))), 127u)]) * _11723;
                                _11733 = (_global_7[min((uint)(((int)(1u + (_11718 * 2)))), 127u)]) * _11723;
                                _11739 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_11732, _11733), float2(_11612, _11611)) + _11590), (dot(float2(_11732, _11733), float2(_11630, _11612)) + _11592)));
                                _11744 = _11739.x - _11597;
                                _11746 = select((_11744 < 0.0f), 0.0f, 1.0f);
                                _11750 = _11739.y - _11597;
                                _11752 = select((_11750 < 0.0f), 0.0f, 1.0f);
                                _11756 = _11739.z - _11597;
                                _11758 = select((_11756 < 0.0f), 0.0f, 1.0f);
                                _11762 = _11739.w - _11597;
                                _11764 = select((_11762 < 0.0f), 0.0f, 1.0f);
                                _11771 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                _11776 = sqrt((float((int)(_11771)) * 0.25f) + 0.125f) * _11596;
                                _11785 = (_global_7[min((uint)(((int)(0u + (_11771 * 2)))), 127u)]) * _11776;
                                _11786 = (_global_7[min((uint)(((int)(1u + (_11771 * 2)))), 127u)]) * _11776;
                                _11792 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_11785, _11786), float2(_11612, _11611)) + _11590), (dot(float2(_11785, _11786), float2(_11630, _11612)) + _11592)));
                                _11797 = _11792.x - _11597;
                                _11799 = select((_11797 < 0.0f), 0.0f, 1.0f);
                                _11803 = _11792.y - _11597;
                                _11805 = select((_11803 < 0.0f), 0.0f, 1.0f);
                                _11809 = _11792.z - _11597;
                                _11811 = select((_11809 < 0.0f), 0.0f, 1.0f);
                                _11815 = _11792.w - _11597;
                                _11817 = select((_11815 < 0.0f), 0.0f, 1.0f);
                                _11818 = ((((((((((((((_11642 + _11646) + _11652) + _11658) + _11693) + _11699) + _11705) + _11711) + _11746) + _11752) + _11758) + _11764) + _11799) + _11805) + _11811) + _11817;
                                _11829 = (saturate(_11818 * 0.0625f) * 2.0f) + -1.0f;
                                _11835 = float((int)(((int)(uint)((int)(_11829 > 0.0f))) - ((int)(uint)((int)(_11829 < 0.0f)))));
                                _11837 = 1.0f - (_11835 * _11829);
                                _11839 = (_11837 * _11837) * _11837;
                                _11846 = 0.5f - ((_11835 * 0.5f) * ((1.0f - _11839) - ((_11837 - _11839) * saturate(((1.0f / _11597) * (1.0f / _11818)) * ((((((((((((((((_11642 * _11640) + (_11646 * _11644)) + (_11652 * _11650)) + (_11658 * _11656)) + (_11693 * _11691)) + (_11699 * _11697)) + (_11705 * _11703)) + (_11711 * _11709)) + (_11746 * _11744)) + (_11752 * _11750)) + (_11758 * _11756)) + (_11764 * _11762)) + (_11799 * _11797)) + (_11805 * _11803)) + (_11811 * _11809)) + (_11817 * _11815))))));
                                _11851 = frac((_11590 * _11489) + 0.5f);
                                _11852 = frac((_11592 * _11489) + 0.5f);
                                _11853 = _11590 + _11490;
                                _11854 = _11592 + _11490;
                                _11856 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_11853, _11854), _11593);
                                _11864 = _11490 * 2.0f;
                                _11865 = _11853 - _11864;
                                _11866 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_11865, _11854), _11593);
                                _11871 = 1.0f - _11851;
                                _11876 = _11854 - _11864;
                                _11877 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_11865, _11876), _11593);
                                _11882 = 1.0f - _11852;
                                _11887 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_11853, _11876), _11593);
                                _11896 = (((mad(mad(_11866.x, _11871, _11866.y), _11852, mad(_11866.w, _11871, _11866.z)) + mad(mad(_11856.y, _11851, _11856.x), _11852, mad(_11856.z, _11851, _11856.w))) + mad(mad(_11877.w, _11871, _11877.z), _11882, mad(_11877.x, _11871, _11877.y))) + mad(mad(_11887.z, _11851, _11887.w), _11882, mad(_11887.y, _11851, _11887.x))) * 0.1111111119389534f;
                                [branch]
                                if (_11492 < 1.0f) {
                                  _11899 = _11846;
                                  _11900 = _11896;
                                  _11901 = _11492;
                                  _11902 = _11593;
                                  __branch_chain_11580 = true;
                                } else {
                                  _12371 = _11896;
                                  _12372 = _11492;
                                  _12373 = _11846;
                                  __branch_chain_11580 = false;
                                }
                              }
                              if (__branch_chain_11580) {
                                _11905 = (_11584 * _11425) + _11427;
                                _11906 = (_11585 * _11426) + _11428;
                                if (!((_1881 & 512) == 0)) {
                                  Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                  _11913 = select(_11498, f16tof32(_11437), f16tof32(_11434));
                                  _11916 = saturate(_11902);
                                  _11920 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                  _11929 = (CUSTOM_ISFAST_SHADOWS > 0.5f) ? RenoDX_ISFASTShadowAngle(uint2(_70, _71), cbSharedPerViewData.nFrameCounter, 7u) : (frac(frac(dot(float2(((_11920 * 32.665000915527344f) + _362), ((_11920 * 11.8149995803833f) + _363)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f);
                                  _11930 = sin(_11929);
                                  _11931 = cos(_11929);
                                  _11936 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_11905, _11906), 0.0f))).x) > _11916), 1.0f, 0.0f);
                                  _11937 = cbSharedPerViewData.nFrameCounter & 3;
                                  _11942 = sqrt((float((int)(_11937)) * 0.25f) + 0.125f) * _11913;
                                  _11951 = (_global_7[min((uint)(((int)(0u + (_11937 * 2)))), 127u)]) * _11942;
                                  _11952 = (_global_7[min((uint)(((int)(1u + (_11937 * 2)))), 127u)]) * _11942;
                                  _11954 = -0.0f - _11930;
                                  _11956 = dot(float2(_11951, _11952), float2(_11931, _11930)) + _11905;
                                  _11957 = dot(float2(_11951, _11952), float2(_11954, _11931)) + _11906;
                                  _11959 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_11956, _11957));
                                  _11963 = _11956 * cbSharedPerViewData.vShadowAtlasSize.x;
                                  _11964 = _11957 * cbSharedPerViewData.vShadowAtlasSize.y;
                                  _11967 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _11427);
                                  _11968 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _11428);
                                  _11973 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_11425 + _11427)) + 0.5f);
                                  _11974 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_11426 + _11428)) + 0.5f);
                                  _11977 = floor(_11963 + -0.5f);
                                  _11978 = floor(_11964 + 0.5f);
                                  _11980 = floor(_11963 + 0.5f);
                                  _11982 = floor(_11964 + -0.5f);
                                  _11983 = (_11977 < _11967);
                                  _11984 = (_11978 < _11968);
                                  if ((_11983 || _11984) | ((_11977 >= _11973) || (_11978 >= _11974))) {
                                    _11993 = _11936;
                                  } else {
                                    _11993 = _11959.x;
                                  }
                                  _11994 = (_11980 < _11967);
                                  if ((_11994 || _11984) | ((_11980 >= _11973) || (_11978 >= _11974))) {
                                    _12002 = _11936;
                                  } else {
                                    _12002 = _11959.y;
                                  }
                                  _12003 = (_11982 < _11968);
                                  if ((_11994 || _12003) | ((_11980 >= _11973) || (_11982 >= _11974))) {
                                    _12011 = _11936;
                                  } else {
                                    _12011 = _11959.z;
                                  }
                                  if ((_11983 || _12003) | ((_11977 >= _11973) || (_11982 >= _11974))) {
                                    _12019 = _11936;
                                  } else {
                                    _12019 = _11959.w;
                                  }
                                  _12020 = _11993 - _11916;
                                  _12022 = select((_12020 < 0.0f), 0.0f, 1.0f);
                                  _12024 = _12002 - _11916;
                                  _12026 = select((_12024 < 0.0f), 0.0f, 1.0f);
                                  _12030 = _12011 - _11916;
                                  _12032 = select((_12030 < 0.0f), 0.0f, 1.0f);
                                  _12036 = _12019 - _11916;
                                  _12038 = select((_12036 < 0.0f), 0.0f, 1.0f);
                                  _12045 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                  _12050 = sqrt((float((int)(_12045)) * 0.25f) + 0.125f) * _11913;
                                  _12059 = (_global_7[min((uint)(((int)(0u + (_12045 * 2)))), 127u)]) * _12050;
                                  _12060 = (_global_7[min((uint)(((int)(1u + (_12045 * 2)))), 127u)]) * _12050;
                                  _12063 = dot(float2(_12059, _12060), float2(_11931, _11930)) + _11905;
                                  _12064 = dot(float2(_12059, _12060), float2(_11954, _11931)) + _11906;
                                  _12066 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_12063, _12064));
                                  _12070 = _12063 * cbSharedPerViewData.vShadowAtlasSize.x;
                                  _12071 = _12064 * cbSharedPerViewData.vShadowAtlasSize.y;
                                  _12074 = floor(_12070 + -0.5f);
                                  _12075 = floor(_12071 + 0.5f);
                                  _12077 = floor(_12070 + 0.5f);
                                  _12079 = floor(_12071 + -0.5f);
                                  _12080 = (_12074 < _11967);
                                  _12081 = (_12075 < _11968);
                                  if ((_12080 || _12081) | ((_12074 >= _11973) || (_12075 >= _11974))) {
                                    _12090 = _11936;
                                  } else {
                                    _12090 = _12066.x;
                                  }
                                  _12091 = (_12077 < _11967);
                                  if ((_12091 || _12081) | ((_12077 >= _11973) || (_12075 >= _11974))) {
                                    _12099 = _11936;
                                  } else {
                                    _12099 = _12066.y;
                                  }
                                  _12100 = (_12079 < _11968);
                                  if ((_12091 || _12100) | ((_12077 >= _11973) || (_12079 >= _11974))) {
                                    _12108 = _11936;
                                  } else {
                                    _12108 = _12066.z;
                                  }
                                  if ((_12080 || _12100) | ((_12074 >= _11973) || (_12079 >= _11974))) {
                                    _12116 = _11936;
                                  } else {
                                    _12116 = _12066.w;
                                  }
                                  _12117 = _12090 - _11916;
                                  _12119 = select((_12117 < 0.0f), 0.0f, 1.0f);
                                  _12123 = _12099 - _11916;
                                  _12125 = select((_12123 < 0.0f), 0.0f, 1.0f);
                                  _12129 = _12108 - _11916;
                                  _12131 = select((_12129 < 0.0f), 0.0f, 1.0f);
                                  _12135 = _12116 - _11916;
                                  _12137 = select((_12135 < 0.0f), 0.0f, 1.0f);
                                  _12144 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                  _12149 = sqrt((float((int)(_12144)) * 0.25f) + 0.125f) * _11913;
                                  _12158 = (_global_7[min((uint)(((int)(0u + (_12144 * 2)))), 127u)]) * _12149;
                                  _12159 = (_global_7[min((uint)(((int)(1u + (_12144 * 2)))), 127u)]) * _12149;
                                  _12162 = dot(float2(_12158, _12159), float2(_11931, _11930)) + _11905;
                                  _12163 = dot(float2(_12158, _12159), float2(_11954, _11931)) + _11906;
                                  _12165 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_12162, _12163));
                                  _12169 = _12162 * cbSharedPerViewData.vShadowAtlasSize.x;
                                  _12170 = _12163 * cbSharedPerViewData.vShadowAtlasSize.y;
                                  _12173 = floor(_12169 + -0.5f);
                                  _12174 = floor(_12170 + 0.5f);
                                  _12176 = floor(_12169 + 0.5f);
                                  _12178 = floor(_12170 + -0.5f);
                                  _12179 = (_12173 < _11967);
                                  _12180 = (_12174 < _11968);
                                  if ((_12179 || _12180) | ((_12173 >= _11973) || (_12174 >= _11974))) {
                                    _12189 = _11936;
                                  } else {
                                    _12189 = _12165.x;
                                  }
                                  _12190 = (_12176 < _11967);
                                  if ((_12190 || _12180) | ((_12176 >= _11973) || (_12174 >= _11974))) {
                                    _12198 = _11936;
                                  } else {
                                    _12198 = _12165.y;
                                  }
                                  _12199 = (_12178 < _11968);
                                  if ((_12190 || _12199) | ((_12176 >= _11973) || (_12178 >= _11974))) {
                                    _12207 = _11936;
                                  } else {
                                    _12207 = _12165.z;
                                  }
                                  if ((_12179 || _12199) | ((_12173 >= _11973) || (_12178 >= _11974))) {
                                    _12215 = _11936;
                                  } else {
                                    _12215 = _12165.w;
                                  }
                                  _12216 = _12189 - _11916;
                                  _12218 = select((_12216 < 0.0f), 0.0f, 1.0f);
                                  _12222 = _12198 - _11916;
                                  _12224 = select((_12222 < 0.0f), 0.0f, 1.0f);
                                  _12228 = _12207 - _11916;
                                  _12230 = select((_12228 < 0.0f), 0.0f, 1.0f);
                                  _12234 = _12215 - _11916;
                                  _12236 = select((_12234 < 0.0f), 0.0f, 1.0f);
                                  _12243 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                  _12248 = sqrt((float((int)(_12243)) * 0.25f) + 0.125f) * _11913;
                                  _12257 = (_global_7[min((uint)(((int)(0u + (_12243 * 2)))), 127u)]) * _12248;
                                  _12258 = (_global_7[min((uint)(((int)(1u + (_12243 * 2)))), 127u)]) * _12248;
                                  _12261 = dot(float2(_12257, _12258), float2(_11931, _11930)) + _11905;
                                  _12262 = dot(float2(_12257, _12258), float2(_11954, _11931)) + _11906;
                                  _12264 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_12261, _12262));
                                  _12268 = _12261 * cbSharedPerViewData.vShadowAtlasSize.x;
                                  _12269 = _12262 * cbSharedPerViewData.vShadowAtlasSize.y;
                                  _12272 = floor(_12268 + -0.5f);
                                  _12273 = floor(_12269 + 0.5f);
                                  _12275 = floor(_12268 + 0.5f);
                                  _12277 = floor(_12269 + -0.5f);
                                  _12278 = (_12272 < _11967);
                                  _12279 = (_12273 < _11968);
                                  if ((_12278 || _12279) | ((_12272 >= _11973) || (_12273 >= _11974))) {
                                    _12288 = _11936;
                                  } else {
                                    _12288 = _12264.x;
                                  }
                                  _12289 = (_12275 < _11967);
                                  if ((_12289 || _12279) | ((_12275 >= _11973) || (_12273 >= _11974))) {
                                    _12297 = _11936;
                                  } else {
                                    _12297 = _12264.y;
                                  }
                                  _12298 = (_12277 < _11968);
                                  if ((_12289 || _12298) | ((_12275 >= _11973) || (_12277 >= _11974))) {
                                    _12306 = _11936;
                                  } else {
                                    _12306 = _12264.z;
                                  }
                                  if ((_12278 || _12298) | ((_12272 >= _11973) || (_12277 >= _11974))) {
                                    _12314 = _11936;
                                  } else {
                                    _12314 = _12264.w;
                                  }
                                  _12315 = _12288 - _11916;
                                  _12317 = select((_12315 < 0.0f), 0.0f, 1.0f);
                                  _12321 = _12297 - _11916;
                                  _12323 = select((_12321 < 0.0f), 0.0f, 1.0f);
                                  _12327 = _12306 - _11916;
                                  _12329 = select((_12327 < 0.0f), 0.0f, 1.0f);
                                  _12333 = _12314 - _11916;
                                  _12335 = select((_12333 < 0.0f), 0.0f, 1.0f);
                                  _12336 = ((((((((((((((_12026 + _12022) + _12032) + _12038) + _12119) + _12125) + _12131) + _12137) + _12218) + _12224) + _12230) + _12236) + _12317) + _12323) + _12329) + _12335;
                                  _12347 = (saturate(_12336 * 0.0625f) * 2.0f) + -1.0f;
                                  _12353 = float((int)(((int)(uint)((int)(_12347 > 0.0f))) - ((int)(uint)((int)(_12347 < 0.0f)))));
                                  _12355 = 1.0f - (_12353 * _12347);
                                  _12357 = (_12355 * _12355) * _12355;
                                  _12366 = (0.5f - ((_12353 * 0.5f) * ((1.0f - _12357) - ((_12355 - _12357) * saturate(((1.0f / _11916) * (1.0f / _12336)) * ((((((((((((((((_12026 * _12024) + (_12022 * _12020)) + (_12032 * _12030)) + (_12038 * _12036)) + (_12119 * _12117)) + (_12125 * _12123)) + (_12131 * _12129)) + (_12137 * _12135)) + (_12218 * _12216)) + (_12224 * _12222)) + (_12230 * _12228)) + (_12236 * _12234)) + (_12317 * _12315)) + (_12323 * _12321)) + (_12329 * _12327)) + (_12335 * _12333)))))));
                                } else {
                                  _12366 = 1.0f;
                                }
                                _12371 = _11900;
                                _12372 = _11901;
                                _12373 = (lerp(_12366, _11899, _11901));
                              }
                              [branch]
                              if (!((_1881 & 2048) == 0)) {
                                Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_11413) >> 16))];
                                _12379 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_11553, _11554), 0.0f);
                                if (_12379.x > 0.0f) {
                                  Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_11413 & 65535))];
                                  _12386 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_11553, _11554), 0.0f);
                                  _12400 = mad(saturate(((log2(_11504) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                  _12401 = max(9.999999747378752e-06f, _12379.x);
                                  _12402 = _12386.x / _12401;
                                  _12403 = _12386.y / _12401;
                                  _12405 = _12386.w / _12401;
                                  _12410 = ((0.375f - _12403) * 4.999999873689376e-06f) + _12403;
                                  _12413 = -0.0f - _12402;
                                  _12414 = mad(_12413, _12410, (_12386.z / _12401));
                                  _12416 = 1.0f / mad(_12413, _12402, _12410);
                                  _12417 = _12416 * _12414;
                                  _12422 = _12400 - _12402;
                                  _12427 = (((_12400 * _12400) - _12410) - (_12417 * _12422)) / mad((-0.0f - _12414), _12417, mad((-0.0f - _12410), _12410, (((0.375f - _12405) * 4.999999873689376e-06f) + _12405)));
                                  _12429 = (_12416 * _12422) - (_12427 * _12417);
                                  _12432 = 1.0f / _12427;
                                  _12433 = _12429 * _12432;
                                  _12438 = sqrt(((_12433 * _12433) * 0.25f) - ((1.0f - dot(float2(_12429, _12427), float2(_12402, _12410))) * _12432));
                                  _12440 = (_12433 * -0.5f) - _12438;
                                  _12442 = _12438 - (_12433 * 0.5f);
                                  _12444 = select((_12440 < _12400), 1.0f, 0.0f);
                                  _12449 = (_12444 + -0.05000000074505806f) / (_12440 - _12400);
                                  _12455 = (((select((_12442 < _12400), 1.0f, 0.0f) - _12444) / (_12442 - _12440)) - _12449) / (_12442 - _12400);
                                  _12457 = _12449 - (_12455 * _12440);
                                  _12470 = (exp2((_12379.x * -1.4426950216293335f) * saturate((dot(float2(_12402, _12410), float2((_12457 - (_12455 * _12400)), _12455)) + 0.05000000074505806f) - (_12457 * _12400))) * _12373);
                                } else {
                                  _12470 = _12373;
                                }
                              } else {
                                _12470 = _12373;
                              }
                              _12475 = _12372;
                              _12476 = _12470;
                              _12477 = _12371;
                              _12478 = (lerp(_12470, _12371, _12372));
                            } else {
                              _12475 = 0.0f;
                              _12476 = 1.0f;
                              _12477 = 0.0f;
                              _12478 = 1.0f;
                            }
                          } else {
                            _12475 = 0.0f;
                            _12476 = 1.0f;
                            _12477 = 0.0f;
                            _12478 = 1.0f;
                          }
                          [branch]
                          if (!(_11464 == 0)) {
                            Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _11464)))];
                            _12491 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_11553 * f16tof32(((uint)((uint)(_11419) >> 16)))) + f16tof32(((uint)((uint)(_11422) >> 16)))), ((_11554 * f16tof32(_11419)) + f16tof32(_11422))), 0.0f);
                            _12499 = (_12491.x * _11442);
                            _12500 = (_12491.y * _11443);
                            _12501 = (_12491.z * _11445);
                          } else {
                            _12499 = _11442;
                            _12500 = _11443;
                            _12501 = _11445;
                          }
                          _12502 = _12476 * _11577;
                          [branch]
                          if (!(_12502 == 0.0f)) {
                            bool __branch_chain_12505;
                            if (((cbDeferredShading.viSSLightIndices.x & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.x & -4096) != 16773120)) {
                              _12521 = 0;
                              __branch_chain_12505 = true;
                            } else {
                              if (((cbDeferredShading.viSSLightIndices.y & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.y & -4096) != 16773120)) {
                                _12521 = 1;
                                __branch_chain_12505 = true;
                              } else {
                                if (((cbDeferredShading.viSSLightIndices.z & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.z & -4096) != 16773120)) {
                                  _12521 = 2;
                                  __branch_chain_12505 = true;
                                } else {
                                  if (((cbDeferredShading.viSSLightIndices.w & 4095) == _1884) && ((cbDeferredShading.viSSLightIndices.w & -4096) != 16773120)) {
                                    _12521 = 3;
                                    __branch_chain_12505 = true;
                                  } else {
                                    _12546 = _12502;
                                    __branch_chain_12505 = false;
                                  }
                                }
                              }
                            }
                            if (__branch_chain_12505) {
                              while(true) {
                                _12524 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_70, _71, 0));
                                if (_12521 == 0) {
                                  _12538 = _12524.x;
                                } else {
                                  if (_12521 == 1) {
                                    _12538 = _12524.y;
                                  } else {
                                    if (_12521 == 2) {
                                      _12538 = _12524.z;
                                    } else {
                                      _12538 = _12524.w;
                                    }
                                  }
                                }
                                _12546 = ((((_12475 * _12475) * ((_12538 * _12538) + -1.0f)) + 1.0f) * _11577);
                                break;
                              }
                            }
                            while(true) {
                              [branch]
                              if (_12546 > 0.0f) {
                                if (_11472) {
                                  if (!(_383 || _221)) {
                                    _12557 = ((_12475 * _11577) * _12477) * saturate(0.30000001192092896f - dot(float3(_11505, _11506, _11507), float3(_196, _197, _198)));
                                    _12562 = (_12557 * _1508);
                                    _12563 = (_12557 * _1509);
                                    _12564 = (_12557 * _1510);
                                  } else {
                                    _12562 = 0.0f;
                                    _12563 = 0.0f;
                                    _12564 = 0.0f;
                                  }
                                  [branch]
                                  if (!((_11416 & 1) == 0)) {
                                    _12577 = max(max(_12499, _12500), _12501);
                                    if (_12577 > 0.0f) {
                                      _12587 = saturate(_12499 / _12577);
                                      _12588 = saturate(_12500 / _12577);
                                      _12589 = saturate(_12501 / _12577);
                                    } else {
                                      _12587 = _12499;
                                      _12588 = _12500;
                                      _12589 = _12501;
                                    }
                                    _12590 = (_12588 < _12589);
                                    _12591 = select(_12590, _12589, _12588);
                                    _12592 = select(_12590, _12588, _12589);
                                    _12593 = select(_12590, -1.0f, 0.0f);
                                    _12594 = (_12587 < _12591);
                                    _12596 = select(_12594, _12591, _12587);
                                    _12597 = select(_12594, _12587, _12591);
                                    _12601 = _12596 - select((_12597 < _12592), _12597, _12592);
                                    _12607 = abs(select(_12594, (-0.3333333432674408f - _12593), _12593) + ((_12597 - _12592) / ((_12601 * 6.0f) + 9.999999682655225e-21f)));
                                    if (_12607 < 0.6666666865348816f) {
                                      _12620 = ((saturate(((float)((uint)((uint)(((uint)(_11416) >> 9) & 255)))) * 0.003921499941498041f) * (select((_12607 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _12607)) + _12607);
                                    } else {
                                      _12620 = _12607;
                                    }
                                    _12621 = saturate((_12601 / (_12596 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_11416) >> 1) & 255)))) * 0.003921499941498041f));
                                    _12622 = saturate(_12596);
                                    if (!(_12621 <= 0.0f)) {
                                      _12625 = saturate(_12620);
                                      _12629 = select(((_12625 * 360.0f) >= 360.0f), 0.0f, (_12625 * 6.0f));
                                      _12630 = int(_12629);
                                      _12632 = _12629 - float((int)(_12630));
                                      _12634 = _12622 * (1.0f - _12621);
                                      _12637 = (1.0f - (_12632 * _12621)) * _12622;
                                      _12641 = (1.0f - ((1.0f - _12632) * _12621)) * _12622;
                                      switch (_12630) {
                                        case 0: {
                                          _12649 = _12622;
                                          _12650 = _12641;
                                          _12651 = _12634;
                                          break;
                                        }
                                        case 1: {
                                          _12649 = _12637;
                                          _12650 = _12622;
                                          _12651 = _12634;
                                          break;
                                        }
                                        case 2: {
                                          _12649 = _12634;
                                          _12650 = _12622;
                                          _12651 = _12641;
                                          break;
                                        }
                                        case 3: {
                                          _12649 = _12634;
                                          _12650 = _12637;
                                          _12651 = _12622;
                                          break;
                                        }
                                        case 4: {
                                          _12649 = _12641;
                                          _12650 = _12634;
                                          _12651 = _12622;
                                          break;
                                        }
                                        case 5: {
                                          _12649 = _12622;
                                          _12650 = _12634;
                                          _12651 = _12637;
                                          break;
                                        }
                                        default: {
                                          _12649 = 0.0f;
                                          _12650 = 0.0f;
                                          _12651 = 0.0f;
                                          break;
                                        }
                                      }
                                    } else {
                                      _12649 = _12622;
                                      _12650 = _12622;
                                      _12651 = _12622;
                                    }
                                    _12652 = _12649 * _12577;
                                    _12653 = _12650 * _12577;
                                    _12654 = _12651 * _12577;
                                    _12656 = saturate(_12476 * 1.0101009607315063f);
                                    _12667 = ((_12656 * (_12499 - _12652)) + _12652);
                                    _12668 = ((_12656 * (_12500 - _12653)) + _12653);
                                    _12669 = (lerp(_12654, _12501, _12656));
                                    _12670 = _12562;
                                    _12671 = _12563;
                                    _12672 = _12564;
                                    _12673 = _12475;
                                  } else {
                                    _12667 = _12499;
                                    _12668 = _12500;
                                    _12669 = _12501;
                                    _12670 = _12562;
                                    _12671 = _12563;
                                    _12672 = _12564;
                                    _12673 = _12475;
                                  }
                                } else {
                                  _12667 = _12499;
                                  _12668 = _12500;
                                  _12669 = _12501;
                                  _12670 = 0.0f;
                                  _12671 = 0.0f;
                                  _12672 = 0.0f;
                                  _12673 = 0.0f;
                                }
                                _12674 = select(_212, (_12478 * _11577), _12546);
                                [branch]
                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                  _12681 = srvLightMappingData[_1884];
                                  if (!(_12681 == -1)) {
                                    _12686 = srvLightIndexData[_12681].nLayerIndex;
                                    _12688 = srvLightIndexData[_12681].vAtlasOrigin.x;
                                    _12689 = srvLightIndexData[_12681].vAtlasOrigin.y;
                                    _12691 = srvLightIndexData[_12681].vScreenOrigin.x;
                                    _12692 = srvLightIndexData[_12681].vScreenOrigin.y;
                                    _12701 = ((int)(_12686 * 5)) & 31;
                                    _12704 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_12688 + _70) - _12691)), ((int)((_12689 + _71) - _12692)), 0)))).x) & ((int)(31 << _12701)))) >> _12701;
                                    _12709 = ((float)((uint)((uint)((uint)(_12704) >> 1)))) * 0.06666667014360428f;
                                    _12715 = (_12709 * _12674);
                                    _12716 = (select(_212, ((float)((bool)(uint)((_12704 & 1) != 0))), _12709) * _12674);
                                  } else {
                                    _12715 = _12674;
                                    _12716 = _12674;
                                  }
                                } else {
                                  _12715 = _12674;
                                  _12716 = _12674;
                                }
                                _12720 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                _12723 = select(_12720, (_12715 * _1480), _12715);
                                _12725 = _11505 * _11504;
                                _12726 = _11506 * _11504;
                                _12727 = _11507 * _11504;
                                _12728 = _11453 * _11381;
                                _12729 = _11453 * _11382;
                                _12730 = _11453 * _11383;
                                _12731 = _12725 + _12728;
                                _12732 = _12726 + _12729;
                                _12733 = _12727 + _12730;
                                _12734 = _12725 - _12728;
                                _12735 = _12726 - _12729;
                                _12736 = _12727 - _12730;
                                _12737 = (_11453 > 0.0f);
                                _12738 = dot(float3(_12731, _12732, _12733), float3(_12731, _12732, _12733));
                                _12739 = rsqrt(_12738);
                                [branch]
                                if (_12737) {
                                  _12742 = rsqrt(dot(float3(_12734, _12735, _12736), float3(_12734, _12735, _12736)));
                                  _12743 = _12742 * _12739;
                                  _12745 = dot(float3(_12731, _12732, _12733), float3(_12734, _12735, _12736)) * _12743;
                                  _12764 = (_12743 / ((_12743 + 0.5f) + (_12745 * 0.5f)));
                                  _12765 = (((dot(float3(_196, _197, _198), float3(_12734, _12735, _12736)) * _12742) + (dot(float3(_196, _197, _198), float3(_12731, _12732, _12733)) * _12739)) * 0.5f);
                                  _12766 = _12745;
                                } else {
                                  _12764 = (1.0f / (_12738 + 1.0f));
                                  _12765 = dot(float3(_196, _197, _198), float3((_12739 * _12731), (_12739 * _12732), (_12739 * _12733)));
                                  _12766 = 1.0f;
                                }
                                if (_11455 > 0.0f) {
                                  _12772 = sqrt(saturate((_11455 * _11455) * _12764));
                                  if (_12765 < _12772) {
                                    _12777 = max(_12765, (-0.0f - _12772)) + _12772;
                                    _12782 = ((_12777 * _12777) / (_12772 * 4.0f));
                                  } else {
                                    _12782 = _12765;
                                  }
                                } else {
                                  _12782 = _12765;
                                }
                                if (_12737) {
                                  _12784 = -0.0f - _601;
                                  _12785 = -0.0f - _602;
                                  _12786 = -0.0f - _600;
                                  _12788 = dot(float3(_12784, _12785, _12786), float3(_196, _197, _198)) * 2.0f;
                                  _12792 = _12784 - (_12788 * _196);
                                  _12793 = _12785 - (_12788 * _197);
                                  _12794 = _12786 - (_12788 * _198);
                                  _12795 = _12734 - _12731;
                                  _12796 = _12735 - _12732;
                                  _12797 = _12736 - _12733;
                                  _12798 = dot(float3(_12792, _12793, _12794), float3(_12795, _12796, _12797));
                                  _12804 = sqrt(((_12795 * _12795) + (_12796 * _12796)) + (_12797 * _12797));
                                  _12813 = saturate(((dot(float3(_12792, _12793, _12794), float3(_12731, _12732, _12733)) * _12798) - dot(float3(_12731, _12732, _12733), float3(_12795, _12796, _12797))) / ((_12804 * _12804) - (_12798 * _12798)));
                                  _12817 = (_12813 * _12795) + _12731;
                                  _12818 = (_12813 * _12796) + _12732;
                                  _12819 = (_12813 * _12797) + _12733;
                                  _12820 = dot(float3(_12817, _12818, _12819), float3(_12792, _12793, _12794));
                                  _12824 = (_12820 * _12792) - _12817;
                                  _12825 = (_12820 * _12793) - _12818;
                                  _12826 = (_12820 * _12794) - _12819;
                                  _12834 = saturate(0.009999999776482582f / sqrt(((_12824 * _12824) + (_12825 * _12825)) + (_12826 * _12826)));
                                  _12842 = ((_12834 * _12824) + _12817);
                                  _12843 = ((_12834 * _12825) + _12818);
                                  _12844 = ((_12834 * _12826) + _12819);
                                } else {
                                  _12842 = _12731;
                                  _12843 = _12732;
                                  _12844 = _12733;
                                }
                                _12846 = rsqrt(dot(float3(_12842, _12843, _12844), float3(_12842, _12843, _12844)));
                                _12847 = _12846 * _12842;
                                _12848 = _12846 * _12843;
                                _12849 = _12846 * _12844;
                                _12850 = _268 * _268;
                                _12851 = 1.0f - _12850;
                                _12854 = saturate((_11455 * _12851) * _12846);
                                _12856 = saturate(_12846 * f16tof32(_11395));
                                _12858 = rsqrt(dot(float3(_12725, _12726, _12727), float3(_12725, _12726, _12727)));
                                _12859 = _12858 * _12725;
                                _12860 = _12858 * _12726;
                                _12861 = _12858 * _12727;
                                if (_319) {
                                  _12864 = saturate(dot(float3(_196, _197, _198), float3(_12847, _12848, _12849)));
                                  _12871 = (_12864 * (_196 - _359)) + _359;
                                  _12872 = (_12864 * (_197 - _360)) + _360;
                                  _12873 = (_12864 * (_198 - _361)) + _361;
                                  _12875 = rsqrt(dot(float3(_12871, _12872, _12873), float3(_12871, _12872, _12873)));
                                  _12880 = (_12871 * _12875);
                                  _12881 = (_12872 * _12875);
                                  _12882 = (_12873 * _12875);
                                } else {
                                  _12880 = _196;
                                  _12881 = _197;
                                  _12882 = _198;
                                }
                                _12883 = dot(float3(_12880, _12881, _12882), float3(_12847, _12848, _12849));
                                _12884 = dot(float3(_12880, _12881, _12882), float3(_601, _602, _600));
                                _12885 = dot(float3(_601, _602, _600), float3(_12847, _12848, _12849));
                                _12888 = rsqrt((_12885 * 2.0f) + 2.0f);
                                _12891 = saturate(_12888 * (_12884 + _12883));
                                _12894 = saturate((_12888 * _12885) + _12888);
                                _12895 = (_12854 > 0.0f);
                                if (_12895) {
                                  _12899 = sqrt(1.0f - (_12854 * _12854));
                                  _12901 = (_12883 * 2.0f) * _12884;
                                  _12902 = _12901 - _12885;
                                  if (!(_12902 >= _12899)) {
                                    _12910 = rsqrt(1.0f - (_12902 * _12902)) * _12854;
                                    _12913 = _12910 * (_12884 - (_12902 * _12883));
                                    _12914 = _12884 * _12884;
                                    _12919 = _12910 * (((_12914 * 2.0f) + -1.0f) - (_12902 * _12885));
                                    _12928 = sqrt(saturate((((1.0f - (_12883 * _12883)) - _12914) - (_12885 * _12885)) + (_12901 * _12885)));
                                    _12929 = _12928 * _12910;
                                    _12932 = ((_12884 * 2.0f) * _12910) * _12928;
                                    _12934 = (_12899 * _12883) + _12884;
                                    _12935 = _12934 + _12913;
                                    _12936 = _12899 * _12885;
                                    _12938 = (_12936 + 1.0f) + _12919;
                                    _12939 = _12929 * _12938;
                                    _12940 = _12935 * _12938;
                                    _12941 = _12932 * _12935;
                                    _12946 = (((_12935 * 0.25f) * _12932) - (_12939 * 0.5f)) * _12940;
                                    _12960 = (((_12941 - (_12939 * 2.0f)) * _12941) + (_12939 * _12939)) + ((((-0.5f - ((_12938 + _12936) * 0.5f)) * _12940) + ((_12938 * _12938) * _12934)) * _12935);
                                    _12965 = (_12946 * 2.0f) / ((_12960 * _12960) + (_12946 * _12946));
                                    _12966 = _12960 * _12965;
                                    _12968 = 1.0f - (_12946 * _12965);
                                    _12974 = ((_12966 * _12932) + _12936) + (_12968 * _12919);
                                    _12977 = rsqrt((_12974 * 2.0f) + 2.0f);
                                    _12986 = saturate((_12974 * _12977) + _12977);
                                    _12987 = saturate(((_12934 + (_12966 * _12929)) + (_12968 * _12913)) * _12977);
                                  } else {
                                    _12986 = abs(_12884);
                                    _12987 = 1.0f;
                                  }
                                } else {
                                  _12986 = _12894;
                                  _12987 = _12891;
                                }
                                _12988 = saturate(_12884);
                                _12989 = saturate(_12782);
                                _12990 = dot(float3(_12880, _12881, _12882), float3(_12859, _12860, _12861));
                                _12991 = saturate(_12990);
                                _12992 = _12850 * _12850;
                                _12993 = (_12856 > 0.0f);
                                if (_12993) {
                                  _13002 = saturate(((_12856 * _12856) / ((_12986 * 3.5999999046325684f) + 0.4000000059604645f)) + _12992);
                                } else {
                                  _13002 = _12992;
                                }
                                if (_12895) {
                                  _13011 = (((_12854 * 0.25f) * ((sqrt(_13002) * 3.0f) + _12854)) / (_12986 + 0.0010000000474974513f)) + _13002;
                                  _13014 = _13011;
                                  _13015 = (_13002 / _13011);
                                } else {
                                  _13014 = _13002;
                                  _13015 = 1.0f;
                                }
                                _13016 = (_12766 < 1.0f);
                                if (_13016) {
                                  _13022 = sqrt((1.000100016593933f - _12766) / max(9.999999974752427e-07f, (_12766 + 1.0f)));
                                  _13035 = (sqrt(_13014 / ((((_13022 * 0.25f) * ((sqrt(_13014) * 3.0f) + _13022)) / (_12986 + 0.0010000000474974513f)) + _13014)) * _13015);
                                } else {
                                  _13035 = _13015;
                                }
                                _13039 = (((_13002 * _12987) - _12987) * _12987) + 1.0f;
                                _13042 = (_13002 / (_13039 * _13039)) * _13035;
                                _13043 = 1.0f - _251;
                                _13044 = 1.0f - _252;
                                _13045 = 1.0f - _253;
                                _13046 = saturate(_12986);
                                _13047 = 1.0f - _13046;
                                _13048 = log2(_13047);
                                _13050 = exp2(_13048 * 5.0f);
                                _13054 = (_13050 * _13043) + _251;
                                _13055 = (_13050 * _13044) + _252;
                                _13056 = (_13050 * _13045) + _253;
                                _13057 = abs(_12884);
                                _13059 = saturate(_13057 + 9.999999747378752e-06f);
                                _13060 = sqrt(_13002);
                                _13061 = 1.0f - _13060;
                                _13069 = 0.5f / ((((_13061 * _13059) + _13060) * _12989) + (((_13061 * _12989) + _13060) * _13059));
                                if (_212) {
                                  _13079 = ((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                  _13080 = ((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                  _13081 = ((_164 + -0.5f) * 0.5f) + 0.5f;
                                  _13098 = ((dot(float3((-0.0f - _12880), (-0.0f - _12881), (-0.0f - _12882)), float3(_12859, _12860, _12861)) + dot(float3((-0.0f - _601), (-0.0f - _602), (-0.0f - _600)), float3(_12859, _12860, _12861))) * 0.5f) * exp2(log2(1.0f - _12988) * (11.0f - (((float)((uint)((uint)((uint)(_310) >> 2)))) * 0.1666666716337204f)));
                                  _13107 = saturate((_1481 + -0.009999999776482582f) * -100.0f);
                                  _13112 = ((_13107 * _13107) * 3.0f) * (3.0f - (_13107 * 2.0f));
                                  _13119 = 10.0f - (exp2(log2(saturate(_1481 * 5.0f)) * 3.0f) * 9.0f);
                                  _13120 = saturate(_12991 + _13079) * _12991;
                                  _13121 = saturate(_12991 + _13080) * _12991;
                                  _13122 = saturate(_12991 + _13081) * _12991;
                                  _13141 = (max(((_13112 + _13079) * _13098), 0.0f) * _13119) + sqrt(_13120 * _13120);
                                  _13142 = (max(((_13112 + _13080) * _13098), 0.0f) * _13119) + sqrt(_13121 * _13121);
                                  _13143 = (max(((_13112 + _13081) * _13098), 0.0f) * _13119) + sqrt(_13122 * _13122);
                                  _13144 = _12847 + _601;
                                  _13145 = _12848 + _602;
                                  _13146 = _12849 + _600;
                                  _13148 = rsqrt(dot(float3(_13144, _13145, _13146), float3(_13144, _13145, _13146)));
                                  if (!(select((_309 != 0), 1.0f, 0.0f) < 1.0f)) {
                                    _13162 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                                    _13163 = _13162 * _196;
                                    _13164 = _13162 * _197;
                                    _13165 = _13162 * _198;
                                    _13168 = (abs(_13163) < abs(_13164));
                                    _13169 = select(_13168, 1.0f, 0.0f);
                                    _13170 = select(_13168, 0.0f, 1.0f);
                                    _13171 = _13170 * _13165;
                                    _13173 = -0.0f - (_13165 * _13169);
                                    _13176 = (_13169 * _13164) - (_13170 * _13163);
                                    _13178 = rsqrt(dot(float3(_13171, _13173, _13176), float3(_13171, _13173, _13176)));
                                    _13179 = _13171 * _13178;
                                    _13180 = _13178 * _13173;
                                    _13181 = _13176 * _13178;
                                    _13184 = (_13180 * _13165) - (_13181 * _13164);
                                    _13187 = (_13181 * _13163) - (_13179 * _13165);
                                    _13190 = (_13179 * _13164) - (_13180 * _13163);
                                    _13192 = rsqrt(dot(float3(_13184, _13187, _13190), float3(_13184, _13187, _13190)));
                                    _13204 = saturate(abs(_308 + -2.5f) + -0.5f) + -0.5f;
                                    _13205 = saturate(1.5f - abs(_308 + -1.5f)) + -0.5f;
                                    _13207 = rsqrt(dot(float2(_13204, _13205), float2(_13204, _13205)));
                                    _13208 = _13207 * _13204;
                                    _13209 = _13207 * _13205;
                                    _13216 = ((_13184 * _13192) * _13208) + (_13209 * _13179);
                                    _13217 = ((_13187 * _13192) * _13208) + (_13209 * _13180);
                                    _13218 = ((_13190 * _13192) * _13208) + (_13209 * _13181);
                                    _13221 = min(max(dot(float3(_13216, _13217, _13218), float3(_12847, _12848, _12849)), -1.0f), 1.0f);
                                    _13224 = min(max(dot(float3(_13216, _13217, _13218), float3(_601, _602, _600)), -1.0f), 1.0f);
                                    _13225 = abs(_13224);
                                    _13230 = (1.5707963705062866f - (_13225 * 0.1565829962491989f)) * sqrt(1.0f - _13225);
                                    _13234 = abs(_13221);
                                    _13239 = (1.5707963705062866f - (_13234 * 0.1565829962491989f)) * sqrt(1.0f - _13234);
                                    _13246 = cos(abs(select((_13221 >= 0.0f), _13239, (3.1415927410125732f - _13239)) - select((_13224 >= 0.0f), _13230, (3.1415927410125732f - _13230))) * 0.5f);
                                    _13250 = _12847 - (_13221 * _13216);
                                    _13251 = _12848 - (_13221 * _13217);
                                    _13252 = _12849 - (_13221 * _13218);
                                    _13256 = _601 - (_13224 * _13216);
                                    _13257 = _602 - (_13224 * _13217);
                                    _13258 = _600 - (_13224 * _13218);
                                    _13265 = rsqrt((dot(float3(_13256, _13257, _13258), float3(_13256, _13257, _13258)) * dot(float3(_13250, _13251, _13252), float3(_13250, _13251, _13252))) + 9.999999747378752e-05f) * dot(float3(_13250, _13251, _13252), float3(_13256, _13257, _13258));
                                    _13269 = sqrt(saturate((_13265 * 0.5f) + 0.5f));
                                    _13273 = _12850 * 0.5f;
                                    _13274 = _12850 * 2.0f;
                                    _13278 = exp2((1.0f - abs(_12673)) * -72.13475036621094f);
                                    if (!((_310 & 1) == 0)) {
                                      _13285 = select(((select(((_310 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_12673 == -1.0f))), 0.0f, _13278);
                                    } else {
                                      _13285 = _13278;
                                    }
                                    _13289 = saturate((dot(float3(_196, _197, _198), float3(_12847, _12848, _12849)) + 0.5f) * 0.6666666865348816f);
                                    _13299 = (_13224 + _13221) + ((((_13269 * 0.9975510239601135f) * sqrt(1.0f - (_13224 * _13224))) - (_13224 * 0.06994284689426422f)) * 0.13988569378852844f);
                                    _13301 = (_12850 * 1.4142135381698608f) * _13269;
                                    _13314 = 1.0f - sqrt(saturate((_12885 * 0.5f) + 0.5f));
                                    _13315 = _13314 * _13314;
                                    _13321 = saturate(-0.0f - _12885);
                                    _13324 = (1.0f - saturate(_13321)) * _13289;
                                    _13333 = ((((_13269 * 0.5f) * (exp2((((_13299 * _13299) * -0.5f) / (_13301 * _13301)) * 1.4426950216293335f) / (_13301 * 2.5066282749176025f))) * min(_255, 0.5f)) * (((_13315 * _13315) * (_13314 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_13324, 1.0f, _13285));
                                    _13335 = (_13221 + -0.03500000014901161f) + _13224;
                                    _13344 = 1.0f / ((1.190000057220459f / _13246) + (_13246 * 0.36000001430511475f));
                                    _13349 = ((_13344 * (0.6000000238418579f - (_13265 * 0.800000011920929f))) + 1.0f) * _13269;
                                    _13355 = 1.0f - (sqrt(saturate(1.0f - (_13349 * _13349))) * _13246);
                                    _13356 = _13355 * _13355;
                                    _13360 = 0.9534794092178345f - ((_13356 * _13356) * (_13355 * 0.9534794092178345f));
                                    _13361 = _13349 * _13344;
                                    _13366 = (sqrt(1.0f - (_13361 * _13361)) * 0.5f) / _13246;
                                    _13385 = 1.0f - saturate((_13321 + -0.44999998807907104f) * 2.222222328186035f);
                                    _13388 = ((1.0f - _13289) * _13285) + _13289;
                                    _13391 = ((_13360 * _13360) * (exp2((((_13335 * _13335) * -0.5f) / (_13273 * _13273)) * 1.4426950216293335f) / (_12850 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_13265 * 5.2658371925354f));
                                    _13405 = (_13221 + -0.14000000059604645f) + _13224;
                                    _13415 = 1.0f - (_13246 * 0.5f);
                                    _13416 = _13415 * _13415;
                                    _13420 = (_13416 * _13416) * (0.9534794092178345f - (_13246 * 0.47673970460891724f));
                                    _13422 = 0.9534794092178345f - _13420;
                                    _13424 = (_13422 * _13422) * (_13420 + 0.04652056470513344f);
                                    _13427 = exp2((_13265 * 24.525815963745117f) + -24.208423614501953f);
                                    _13440 = ((exp2((((_13405 * _13405) * -0.5f) / (_13274 * _13274)) * 1.4426950216293335f) / (_12850 * 5.013256549835205f)) * (lerp(_13424, 1.0f, _220))) * (((exp2((saturate(dot(float3((_13148 * _13144), (_13148 * _13145), (_13148 * _13146)), float3(_196, _197, _198))) * 17.312339782714844f) + -14.109557151794434f) - _13427) * _220) + _13427);
                                    _14220 = (((((exp2(log2(max(_162, 0.0f)) * _13366) * _13388) * _13391) * _13385) + _13333) + (_13440 * _162));
                                    _14221 = (((((exp2(log2(max(_163, 0.0f)) * _13366) * _13388) * _13391) * _13385) + _13333) + (_13440 * _163));
                                    _14222 = (((((exp2(log2(max(_164, 0.0f)) * _13366) * _13388) * _13391) * _13385) + _13333) + (_13440 * _164));
                                    _14223 = _13141;
                                    _14224 = _13142;
                                    _14225 = _13143;
                                  } else {
                                    _14220 = 0.0f;
                                    _14221 = 0.0f;
                                    _14222 = 0.0f;
                                    _14223 = _13141;
                                    _14224 = _13142;
                                    _14225 = _13143;
                                  }
                                } else {
                                  if (_319) {
                                    _13458 = ((float)((uint)((uint)(_312 & 15)))) * 0.06666667014360428f;
                                    _13459 = _268 * 0.0317460335791111f;
                                    _13462 = min(1.0f, max((_13459 * ((float)((uint)((uint)((uint)(_311) >> 2))))), 0.019999999552965164f));
                                    _13465 = min(1.0f, max((_13459 * ((float)((uint)((uint)((((int)(_311 << 4)) & 48) | ((uint)(_312) >> 4)))))), 0.019999999552965164f));
                                    _13468 = ((_13465 - _13462) * _13458) + _13462;
                                    _13469 = _13468 * _13468;
                                    _13473 = saturate(abs(_12988) + 9.999999747378752e-06f);
                                    _13474 = sqrt(_13469 * _13469);
                                    _13475 = 1.0f - _13474;
                                    _13484 = _13462 * _13462;
                                    _13485 = _13484 * _13484;
                                    if (_12993) {
                                      _13494 = saturate(((_12856 * _12856) / ((_12986 * 3.5999999046325684f) + 0.4000000059604645f)) + _13485);
                                    } else {
                                      _13494 = _13485;
                                    }
                                    if (_12895) {
                                      _13503 = (((_12854 * 0.25f) * ((sqrt(_13494) * 3.0f) + _12854)) / (_12986 + 0.0010000000474974513f)) + _13494;
                                      _13506 = _13503;
                                      _13507 = (_13494 / _13503);
                                    } else {
                                      _13506 = _13494;
                                      _13507 = 1.0f;
                                    }
                                    if (_13016) {
                                      _13513 = sqrt((1.000100016593933f - _12766) / max(9.999999974752427e-07f, (_12766 + 1.0f)));
                                      _13526 = (sqrt(_13506 / ((((_13513 * 0.25f) * ((sqrt(_13506) * 3.0f) + _13513)) / (_12986 + 0.0010000000474974513f)) + _13506)) * _13507);
                                    } else {
                                      _13526 = _13507;
                                    }
                                    _13527 = _13465 * _13465;
                                    _13528 = _13527 * _13527;
                                    if (_12993) {
                                      _13537 = saturate(((_12856 * _12856) / ((_12986 * 3.5999999046325684f) + 0.4000000059604645f)) + _13528);
                                    } else {
                                      _13537 = _13528;
                                    }
                                    if (_12895) {
                                      _13546 = (((_12854 * 0.25f) * ((sqrt(_13537) * 3.0f) + _12854)) / (_12986 + 0.0010000000474974513f)) + _13537;
                                      _13549 = _13546;
                                      _13550 = (_13537 / _13546);
                                    } else {
                                      _13549 = _13537;
                                      _13550 = 1.0f;
                                    }
                                    if (_13016) {
                                      _13556 = sqrt((1.000100016593933f - _12766) / max(9.999999974752427e-07f, (_12766 + 1.0f)));
                                      _13569 = (sqrt(_13549 / ((((_13556 * 0.25f) * ((sqrt(_13549) * 3.0f) + _13556)) / (_12986 + 0.0010000000474974513f)) + _13549)) * _13550);
                                    } else {
                                      _13569 = _13550;
                                    }
                                    _13573 = (((_13494 * _12987) - _12987) * _12987) + 1.0f;
                                    _13576 = (_13494 / (_13573 * _13573)) * _13526;
                                    _13580 = (((_13537 * _12987) - _12987) * _12987) + 1.0f;
                                    _13587 = saturate(_12987);
                                    _13591 = saturate((_12990 + _11452) / (_11452 + 1.0f));
                                    _13596 = asint(_cbSkinFeatures_raw_uint[((uint)(((uint)((int)min((uint)(asint(_cbSkinFeatures_raw_uint[0u].x)), (uint)(_313)))) + 1u))]);
                                    _13603 = ((float)((uint)((uint)((uint)((uint)(_13596.x)) >> 24)))) * 0.25f;
                                    _13606 = ((float)((uint)((uint)(_13596.x & 255)))) * 0.003921568859368563f;
                                    _13610 = ((float)((uint)((uint)(((uint)((uint)(_13596.x)) >> 8) & 255)))) * 0.003921568859368563f;
                                    _13614 = ((float)((uint)((uint)(((uint)((uint)(_13596.x)) >> 16) & 255)))) * 0.003921568859368563f;
                                    _13623 = ((float)((uint)((uint)((uint)((uint)(_13596.y)) >> 24)))) * 0.25f;
                                    _13626 = ((float)((uint)((uint)(_13596.y & 255)))) * 0.003921568859368563f;
                                    _13630 = ((float)((uint)((uint)(((uint)((uint)(_13596.y)) >> 8) & 255)))) * 0.003921568859368563f;
                                    _13634 = ((float)((uint)((uint)(((uint)((uint)(_13596.y)) >> 16) & 255)))) * 0.003921568859368563f;
                                    _13642 = (float)((uint)((uint)(_13596.w & 31)));
                                    _13648 = (float)((uint)((uint)(((uint)((uint)(_13596.w)) >> 10) & 31)));
                                    _13658 = (float)((uint)((uint)(((uint)((uint)(_13596.w)) >> 25) & 31)));
                                    _13661 = ((float)((uint)((uint)(_13596.z & 255)))) * 0.003921568859368563f;
                                    _13665 = ((float)((uint)((uint)(((uint)((uint)(_13596.z)) >> 8) & 255)))) * 0.003921568859368563f;
                                    _13669 = ((float)((uint)((uint)(((uint)((uint)(_13596.z)) >> 16) & 255)))) * 0.003921568859368563f;
                                    _13676 = (((float)((uint)((uint)((uint)((uint)(_13596.z)) >> 24)))) * 0.003921568859368563f) * select(((_13596.w & 1073741824) != 0), -1.0f, 1.0f);
                                    _13690 = exp2((10.0f - (((float)((uint)((uint)(((uint)((uint)(_13596.w)) >> 5) & 31)))) * 0.32258063554763794f)) * log2(max(9.999999747378752e-06f, _13046)));
                                    _13691 = ((2.0f - (_13642 * 0.06451612710952759f)) > 0.0f);
                                    if (_13691) {
                                      _13702 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _13587))) * (10.0f - (_13642 * 0.32258063554763794f))) * _13690);
                                    } else {
                                      _13702 = _13690;
                                    }
                                    _13713 = exp2(log2(max(9.999999747378752e-06f, _13587)) * (10.0f - (((float)((uint)((uint)(((uint)((uint)(_13596.w)) >> 15) & 31)))) * 0.32258063554763794f)));
                                    _13714 = ((2.0f - (_13648 * 0.06451612710952759f)) > 0.0f);
                                    if (_13714) {
                                      _13724 = (exp2(log2(max(9.999999747378752e-06f, _13047)) * (10.0f - (_13648 * 0.32258063554763794f))) * _13713);
                                    } else {
                                      _13724 = _13713;
                                    }
                                    if (_13691) {
                                      _13738 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _13587))) * (10.0f - (_13642 * 0.32258063554763794f))) * _13690);
                                    } else {
                                      _13738 = _13690;
                                    }
                                    if (_13714) {
                                      _13751 = (exp2(log2(max(9.999999747378752e-06f, _13047)) * (10.0f - (_13648 * 0.32258063554763794f))) * _13713);
                                    } else {
                                      _13751 = _13713;
                                    }
                                    if (_13691) {
                                      _13765 = (exp2(log2(max(9.999999747378752e-06f, (1.0f - _13587))) * (10.0f - (_13642 * 0.32258063554763794f))) * _13690);
                                    } else {
                                      _13765 = _13690;
                                    }
                                    if (_13714) {
                                      _13778 = (exp2(log2(max(9.999999747378752e-06f, _13047)) * (10.0f - (_13648 * 0.32258063554763794f))) * _13713);
                                    } else {
                                      _13778 = _13713;
                                    }
                                    _13790 = (1.0f - exp2(log2(1.0f - _13587) * 3.0f)) * (1.0f - exp2(_13048 * 3.0f));
                                    _13794 = saturate(_13591 / (_13790 * (((float)((uint)((uint)(((uint)((uint)(_13596.w)) >> 20) & 31)))) * 0.032258063554763794f)));
                                    _13799 = ((_13794 * _13794) * (3.0f - (_13794 * 2.0f))) + -1.0f;
                                    _13801 = ((((_13661 * _13661) * _13676) * _13790) * _13799) + 1.0f;
                                    _13804 = ((((_13665 * _13665) * _13676) * _13790) * _13799) + 1.0f;
                                    _13807 = ((((_13669 * _13669) * _13676) * _13790) * _13799) + 1.0f;
                                    _13809 = saturate(_13658 * 0.06451612710952759f);
                                    _13816 = exp2(log2(1.0f - _12986) * (10.0f - (_13658 * 0.32258063554763794f)));
                                    _13835 = ((((((_13537 / (_13580 * _13580)) * _13569) - _13576) * _13458) + _13576) * (0.5f / ((((_13475 * _13473) + _13474) * _12989) + (((_13475 * _12989) + _13474) * _13473)))) * _12989;
                                    _14220 = ((_13835 * _13801) * (((_13809 * _13043) * _13816) + _251));
                                    _14221 = ((_13835 * _13804) * (((_13809 * _13044) * _13816) + _252));
                                    _14222 = ((_13835 * _13807) * (((_13809 * _13045) * _13816) + _253));
                                    _14223 = (((((_13702 * (((_13606 * _13606) * _13603) + -1.0f)) + 1.0f) * _13591) * ((_13724 * (((_13626 * _13626) * _13623) + -1.0f)) + 1.0f)) * _13801);
                                    _14224 = (((((_13738 * (((_13610 * _13610) * _13603) + -1.0f)) + 1.0f) * _13591) * ((_13751 * (((_13630 * _13630) * _13623) + -1.0f)) + 1.0f)) * _13804);
                                    _14225 = (((((_13765 * (((_13614 * _13614) * _13603) + -1.0f)) + 1.0f) * _13591) * ((_13778 * (((_13634 * _13634) * _13623) + -1.0f)) + 1.0f)) * _13807);
                                  } else {
                                    if (_241) {
                                      if (_256 < 0.007874015718698502f) {
                                        _13849 = _12987 * _12987;
                                        _13851 = max((1.0f - _13849), 9.999999747378752e-05f);
                                        _13996 = (((((((exp2(((-0.0f - (_13849 / _13851)) / _13002) * 1.4426950216293335f) * 4.0f) / (_13851 * _13851)) + 1.0f) * (1.0f / ((_13002 * 4.0f) + 1.0f))) - _13042) * _257) + _13042);
                                        _13997 = (((saturate(0.25f / ((_12991 + _12988) - (_12991 * _12988))) - _13069) * _257) + _13069);
                                      } else {
                                        _13875 = rsqrt(dot(float3(_196, _197, _198), float3(_196, _197, _198)));
                                        _13876 = _13875 * _196;
                                        _13877 = _13875 * _197;
                                        _13878 = _13875 * _198;
                                        _13881 = (abs(_13876) < abs(_13877));
                                        _13882 = select(_13881, 1.0f, 0.0f);
                                        _13883 = select(_13881, 0.0f, 1.0f);
                                        _13884 = _13883 * _13878;
                                        _13886 = -0.0f - (_13878 * _13882);
                                        _13889 = (_13882 * _13877) - (_13883 * _13876);
                                        _13891 = rsqrt(dot(float3(_13884, _13886, _13889), float3(_13884, _13886, _13889)));
                                        _13892 = _13884 * _13891;
                                        _13893 = _13891 * _13886;
                                        _13894 = _13889 * _13891;
                                        _13897 = (_13893 * _13878) - (_13894 * _13877);
                                        _13900 = (_13894 * _13876) - (_13892 * _13878);
                                        _13903 = (_13892 * _13877) - (_13893 * _13876);
                                        _13905 = rsqrt(dot(float3(_13897, _13900, _13903), float3(_13897, _13900, _13903)));
                                        _13909 = _257 * 4.0f;
                                        _13918 = saturate(abs(_13909 + -2.5f) + -0.5f) + -0.5f;
                                        _13919 = saturate(1.5f - abs(_13909 + -1.5f)) + -0.5f;
                                        _13921 = rsqrt(dot(float2(_13918, _13919), float2(_13918, _13919)));
                                        _13922 = _13921 * _13918;
                                        _13923 = _13921 * _13919;
                                        _13930 = ((_13897 * _13905) * _13922) + (_13923 * _13892);
                                        _13931 = ((_13900 * _13905) * _13922) + (_13923 * _13893);
                                        _13932 = ((_13903 * _13905) * _13922) + (_13923 * _13894);
                                        _13935 = (_13931 * _198) - (_13932 * _197);
                                        _13938 = (_13932 * _196) - (_13930 * _198);
                                        _13941 = (_13930 * _197) - (_13931 * _196);
                                        _13945 = rsqrt((dot(float3(_601, _602, _600), float3(_12859, _12860, _12861)) * 2.0f) + 2.0f);
                                        _13949 = dot(float3(_13930, _13931, _13932), float3(_12859, _12860, _12861));
                                        _13950 = dot(float3(_13930, _13931, _13932), float3(_601, _602, _600));
                                        _13953 = dot(float3(_13935, _13938, _13941), float3(_12859, _12860, _12861));
                                        _13954 = dot(float3(_13935, _13938, _13941), float3(_601, _602, _600));
                                        _13960 = min(max((_12850 * (_256 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                        _13964 = min(max((_12850 * (1.0f - _256)), 0.0010000000474974513f), 1.0f);
                                        _13965 = _13964 * _13960;
                                        _13966 = ((_13950 + _13949) * _13945) * _13964;
                                        _13967 = ((_13954 + _13953) * _13945) * _13960;
                                        _13968 = _13965 * saturate(_13945 * (_12884 + _12990));
                                        _13969 = dot(float3(_13966, _13967, _13968), float3(_13966, _13967, _13968));
                                        _13974 = _13960 * _13950;
                                        _13975 = _13964 * _13954;
                                        _13983 = _13960 * _13949;
                                        _13984 = _13964 * _13953;
                                        _13996 = (((_13965 * _13965) * _13965) / (_13969 * _13969));
                                        _13997 = saturate(0.5f / ((sqrt(((_13983 * _13983) + (_12991 * _12991)) + (_13984 * _13984)) * _13059) + (sqrt(((_13975 * _13975) + (_13974 * _13974)) + (_13059 * _13059)) * _12991)));
                                      }
                                      _13999 = (_13996 * _12991) * _13997;
                                      _14017 = saturate((_12990 + 0.5f) * 0.6666666865348816f);
                                      _14220 = (_13999 * _13054);
                                      _14221 = (_13999 * _13055);
                                      _14222 = (_13999 * _13056);
                                      _14223 = ((_14017 * (1.0f - _13054)) * saturate((((_162 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _12991));
                                      _14224 = ((_14017 * (1.0f - _13055)) * saturate((((_163 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _12991));
                                      _14225 = ((_14017 * (1.0f - _13056)) * saturate((((_164 + -0.5f) * 0.5f) + 0.5f) + _12991));
                                    } else {
                                      if (_263) {
                                        _14032 = _315 * _315;
                                        _14033 = _14032 * _14032;
                                        _14039 = saturate(select((_12851 > 0.0f), ((1.0f - _14032) / _12851), 0.0f) * _12854);
                                        _14040 = (_14039 > 0.0f);
                                        if (_14040) {
                                          _14044 = sqrt(1.0f - (_14039 * _14039));
                                          _14046 = (_12883 * 2.0f) * _12884;
                                          _14047 = _14046 - _12885;
                                          if (!(_14047 >= _14044)) {
                                            _14053 = rsqrt(1.0f - (_14047 * _14047)) * _14039;
                                            _14056 = _14053 * (_12884 - (_14047 * _12883));
                                            _14057 = _12884 * _12884;
                                            _14062 = _14053 * (((_14057 * 2.0f) + -1.0f) - (_14047 * _12885));
                                            _14071 = sqrt(saturate((((1.0f - (_12883 * _12883)) - _14057) - (_12885 * _12885)) + (_14046 * _12885)));
                                            _14072 = _14071 * _14053;
                                            _14075 = ((_12884 * 2.0f) * _14053) * _14071;
                                            _14077 = (_14044 * _12883) + _12884;
                                            _14078 = _14077 + _14056;
                                            _14079 = _14044 * _12885;
                                            _14081 = (_14079 + 1.0f) + _14062;
                                            _14082 = _14072 * _14081;
                                            _14083 = _14078 * _14081;
                                            _14084 = _14075 * _14078;
                                            _14089 = (((_14078 * 0.25f) * _14075) - (_14082 * 0.5f)) * _14083;
                                            _14103 = (((_14084 - (_14082 * 2.0f)) * _14084) + (_14082 * _14082)) + ((((-0.5f - ((_14081 + _14079) * 0.5f)) * _14083) + ((_14081 * _14081) * _14077)) * _14078);
                                            _14108 = (_14089 * 2.0f) / ((_14103 * _14103) + (_14089 * _14089));
                                            _14109 = _14103 * _14108;
                                            _14111 = 1.0f - (_14089 * _14108);
                                            _14117 = ((_14109 * _14075) + _14079) + (_14111 * _14062);
                                            _14120 = rsqrt((_14117 * 2.0f) + 2.0f);
                                            _14129 = saturate((_14117 * _14120) + _14120);
                                            _14130 = saturate(((_14077 + (_14109 * _14072)) + (_14111 * _14056)) * _14120);
                                          } else {
                                            _14129 = _13057;
                                            _14130 = 1.0f;
                                          }
                                        } else {
                                          _14129 = _12894;
                                          _14130 = _12891;
                                        }
                                        if (_12993) {
                                          _14139 = saturate(((_12856 * _12856) / ((_14129 * 3.5999999046325684f) + 0.4000000059604645f)) + _14033);
                                        } else {
                                          _14139 = _14033;
                                        }
                                        if (_14040) {
                                          _14148 = (((_14039 * 0.25f) * ((sqrt(_14139) * 3.0f) + _14039)) / (_14129 + 0.0010000000474974513f)) + _14139;
                                          _14151 = _14148;
                                          _14152 = (_14139 / _14148);
                                        } else {
                                          _14151 = _14139;
                                          _14152 = 1.0f;
                                        }
                                        if (_13016) {
                                          _14158 = sqrt((1.000100016593933f - _12766) / max(9.999999974752427e-07f, (_12766 + 1.0f)));
                                          _14171 = (sqrt(_14151 / ((((_14158 * 0.25f) * ((sqrt(_14151) * 3.0f) + _14158)) / (_14129 + 0.0010000000474974513f)) + _14151)) * _14152);
                                        } else {
                                          _14171 = _14152;
                                        }
                                        _14175 = (((_14139 * _14130) - _14130) * _14130) + 1.0f;
                                        _14185 = sqrt(_14139);
                                        _14186 = 1.0f - _14185;
                                        _14201 = ((((exp2(log2(1.0f - saturate(_14129)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f) * _314) * (((_14171 * _12989) * (_14139 / (_14175 * _14175))) * (0.5f / ((((_14186 * _13059) + _14185) * _12989) + (((_14186 * _12989) + _14185) * _13059)))));
                                        _14202 = false;
                                      } else {
                                        _14201 = 0.0f;
                                        _14202 = true;
                                      }
                                      _14206 = saturate((_12990 + _11452) / (_11452 + 1.0f));
                                      _14208 = (_13042 * _12989) * _13069;
                                      _14212 = _14201 + (_14208 * _13054);
                                      _14213 = _14201 + (_14208 * _13055);
                                      _14214 = _14201 + (_14208 * _13056);
                                      [branch]
                                      if (_14202) {
                                        _14220 = (_14212 * _1337);
                                        _14221 = (_14213 * _1338);
                                        _14222 = (_14214 * _1339);
                                        _14223 = _14206;
                                        _14224 = _14206;
                                        _14225 = _14206;
                                      } else {
                                        _14220 = _14212;
                                        _14221 = _14213;
                                        _14222 = _14214;
                                        _14223 = _14206;
                                        _14224 = _14206;
                                        _14225 = _14206;
                                      }
                                    }
                                  }
                                }
                                _14226 = _12667 * _1932;
                                _14227 = _12668 * _1932;
                                _14228 = _12669 * _1932;
                                _14235 = ((_12723 * _14226) * _14223) + _1869;
                                _14236 = ((_12723 * _14227) * _14224) + _1870;
                                _14237 = ((_12723 * _14228) * _14225) + _1871;
                                if (_11449 > 0.0f) {
                                  _14241 = (_11449 * _1633) * select(_12720, (_12716 * _1480), _12716);
                                  _14252 = (((_14241 * _14226) * _14220) + _1872);
                                  _14253 = (((_14241 * _14227) * _14221) + _1873);
                                  _14254 = (((_14241 * _14228) * _14222) + _1874);
                                } else {
                                  _14252 = _1872;
                                  _14253 = _1873;
                                  _14254 = _1874;
                                }
                                _14258 = _14252 + (_12670 * _14226);
                                _14259 = _14253 + (_12671 * _14227);
                                _14260 = _14254 + (_12672 * _14228);
                                if (!_326) {
                                  _14267 = saturate(-0.0f - dot(float3(_601, _602, _600), float3(_11505, _11506, _11507)));
                                  _14270 = 1.0f - ((_14267 * _14267) * 0.6399999856948853f);
                                  _14275 = saturate(0.30000001192092896f - _11527) * (0.36000001430511475f / (_14270 * _14270));
                                  _14276 = _11577 * _1932;
                                  _14768 = _14235;
                                  _14769 = _14236;
                                  _14770 = _14237;
                                  _14771 = ((((_333 * _258) * _14276) * _14275) + _14258);
                                  _14772 = ((((_334 * _258) * _14276) * _14275) + _14259);
                                  _14773 = ((((_335 * _258) * _14276) * _14275) + _14260);
                                } else {
                                  _14768 = _14235;
                                  _14769 = _14236;
                                  _14770 = _14237;
                                  _14771 = _14258;
                                  _14772 = _14259;
                                  _14773 = _14260;
                                }
                              } else {
                                _14768 = _1869;
                                _14769 = _1870;
                                _14770 = _1871;
                                _14771 = _1872;
                                _14772 = _1873;
                                _14773 = _1874;
                              }
                              break;
                            }
                          } else {
                            _14768 = _1869;
                            _14769 = _1870;
                            _14770 = _1871;
                            _14771 = _1872;
                            _14772 = _1873;
                            _14773 = _1874;
                          }
                        } else {
                          if (_1915 == 10) {
                            _14291 = asfloat(srvLightInfoProperties.Load4(_1883)).x;
                            _14292 = asfloat(srvLightInfoProperties.Load4(_1883)).y;
                            _14293 = asfloat(srvLightInfoProperties.Load4(_1883)).z;
                            _14294 = asfloat(srvLightInfoProperties.Load4(_1883)).w;
                            _14297 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).x;
                            _14298 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).y;
                            _14299 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).z;
                            _14300 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 16u)))).w;
                            _14303 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).x;
                            _14304 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).y;
                            _14305 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).z;
                            _14306 = asfloat(srvLightInfoProperties.Load4(((int)(_1883 + 32u)))).w;
                            _14309 = asfloat(srvLightInfoProperties.Load2(((int)(_1883 + 72u)))).x;
                            _14310 = asfloat(srvLightInfoProperties.Load2(((int)(_1883 + 72u)))).y;
                            _14313 = asint(srvLightInfoProperties.Load(((int)(_1883 + 80u))));
                            _14316 = asint(srvLightInfoProperties.Load(((int)(_1883 + 84u))));
                            _14319 = asint(srvLightInfoProperties.Load(((int)(_1883 + 88u))));
                            _14322 = asint(srvLightInfoProperties.Load(((int)(_1883 + 96u))));
                            _14325 = f16tof32(_14313);
                            _14327 = f16tof32(((uint)((uint)(_14316) >> 16)));
                            _14328 = f16tof32(_14316);
                            _14330 = f16tof32(((uint)((uint)(_14319) >> 16)));
                            _14334 = ((float)((uint)((uint)(((uint)(_14319) >> 8) & 255)))) * 0.003921499941498041f;
                            _14336 = (float)((uint)((uint)(_14322 & 65535)));
                            _14340 = mad(_14293, _381, mad(_14292, _380, (_14291 * _379))) + _14294;
                            _14344 = mad(_14299, _381, mad(_14298, _380, (_14297 * _379))) + _14300;
                            _14348 = mad(_14305, _381, mad(_14304, _380, (_14303 * _379))) + _14306;
                            _14351 = mad(_14293, _198, mad(_14292, _197, (_14291 * _196)));
                            _14354 = mad(_14299, _198, mad(_14298, _197, (_14297 * _196)));
                            _14357 = mad(_14305, _198, mad(_14304, _197, (_14303 * _196)));
                            _14369 = -0.0f - mad(_14305, _600, mad(_14304, _602, (_14303 * _601)));
                            _14370 = _14309 * 0.5f;
                            _14371 = _14310 * 0.5f;
                            _14372 = -0.0f - _14370;
                            _14373 = -0.0f - _14371;
                            _14374 = _14372 - _14340;
                            _14375 = _14373 - _14344;
                            _14376 = -0.0f - _14348;
                            _14377 = _14370 - _14340;
                            _14378 = _14371 - _14344;
                            _14379 = dot(float3(_14340, _14344, _14348), float3(_14351, _14354, _14357));
                            _14381 = dot(float3(_14372, _14373, 0.0f), float3(_14351, _14354, _14357)) - _14379;
                            _14383 = dot(float3(_14370, _14373, 0.0f), float3(_14351, _14354, _14357)) - _14379;
                            _14385 = dot(float3(_14370, _14371, 0.0f), float3(_14351, _14354, _14357)) - _14379;
                            _14387 = dot(float3(_14372, _14371, 0.0f), float3(_14351, _14354, _14357)) - _14379;
                            _14388 = min(_14381, _14383);
                            [branch]
                            if (!(!(_14388 >= 0.0f))) {
                              _14394 = rsqrt(dot(float3(_14377, _14375, _14376), float3(_14377, _14375, _14376)) * dot(float3(_14374, _14375, _14376), float3(_14374, _14375, _14376)));
                              _14396 = dot(float3(_14374, _14375, _14376), float3(_14377, _14375, _14376)) * _14394;
                              _14403 = rsqrt(max(((((_14396 * 0.09300000220537186f) + 0.5f) * _14396) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14394;
                              _14410 = (_14403 * (_14309 * _14376));
                              _14411 = (_14403 * (_14375 * (_14372 - _14370)));
                            } else {
                              _14410 = 0.0f;
                              _14411 = 0.0f;
                            }
                            [branch]
                            if (!(!(min(_14383, _14385) >= 0.0f))) {
                              _14418 = rsqrt(dot(float3(_14377, _14378, _14376), float3(_14377, _14378, _14376)) * dot(float3(_14377, _14375, _14376), float3(_14377, _14375, _14376)));
                              _14420 = dot(float3(_14377, _14375, _14376), float3(_14377, _14378, _14376)) * _14418;
                              _14427 = rsqrt(max(((((_14420 * 0.09300000220537186f) + 0.5f) * _14420) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14418;
                              _14435 = (_14427 * ((_14373 - _14371) * _14376));
                              _14436 = ((_14427 * (_14310 * _14377)) + _14411);
                            } else {
                              _14435 = 0.0f;
                              _14436 = _14411;
                            }
                            _14437 = min(_14385, _14387);
                            [branch]
                            if (!(!(_14437 >= 0.0f))) {
                              _14443 = rsqrt(dot(float3(_14374, _14378, _14376), float3(_14374, _14378, _14376)) * dot(float3(_14377, _14378, _14376), float3(_14377, _14378, _14376)));
                              _14445 = dot(float3(_14377, _14378, _14376), float3(_14374, _14378, _14376)) * _14443;
                              _14452 = rsqrt(max(((((_14445 * 0.09300000220537186f) + 0.5f) * _14445) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14443;
                              _14461 = ((_14452 * ((_14372 - _14370) * _14376)) + _14410);
                              _14462 = ((_14452 * (_14309 * _14378)) + _14436);
                            } else {
                              _14461 = _14410;
                              _14462 = _14436;
                            }
                            [branch]
                            if (!(!(min(_14387, _14381) >= 0.0f))) {
                              _14469 = rsqrt(dot(float3(_14374, _14375, _14376), float3(_14374, _14375, _14376)) * dot(float3(_14374, _14378, _14376), float3(_14374, _14378, _14376)));
                              _14471 = dot(float3(_14374, _14378, _14376), float3(_14374, _14375, _14376)) * _14469;
                              _14478 = rsqrt(max(((((_14471 * 0.09300000220537186f) + 0.5f) * _14471) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14469;
                              _14487 = ((_14478 * (_14310 * _14376)) + _14435);
                              _14488 = ((_14478 * (_14374 * (_14373 - _14371))) + _14462);
                            } else {
                              _14487 = _14435;
                              _14488 = _14462;
                            }
                            if (min(_14388, _14437) < 0.0f) {
                              [branch]
                              if (!(!(max(max(_14381, _14383), max(_14385, _14387)) >= 0.0f))) {
                                _14497 = -0.0f - _14351;
                                _14498 = _14379 / _14354;
                                _14499 = _14372 / _14354;
                                _14500 = _14370 / _14354;
                                _14502 = (_14373 - _14498) / _14497;
                                _14504 = (_14371 - _14498) / _14497;
                                _14505 = min(_14499, _14500);
                                _14506 = max(_14499, _14500);
                                _14507 = min(_14502, _14504);
                                _14508 = max(_14502, _14504);
                                _14509 = max(_14505, _14507);
                                _14510 = min(_14506, _14508);
                                _14511 = _14509 * _14354;
                                _14513 = _14510 * _14354;
                                _14515 = _14511 - _14340;
                                _14516 = _14498 - _14344;
                                _14517 = _14516 + (_14509 * _14497);
                                _14518 = _14513 - _14340;
                                _14519 = _14516 + (_14510 * _14497);
                                _14520 = dot(float3(_14515, _14517, _14376), float3(_14515, _14517, _14376));
                                _14521 = dot(float3(_14518, _14519, _14376), float3(_14518, _14519, _14376));
                                _14523 = rsqrt(_14521 * _14520);
                                _14525 = dot(float3(_14515, _14517, _14376), float3(_14518, _14519, _14376)) * _14523;
                                _14532 = rsqrt(max(((((_14525 * 0.09300000220537186f) + 0.5f) * _14525) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14523;
                                _14545 = (_14505 > _14507);
                                _14547 = select(_14545, _14354, _14351);
                                _14553 = float((int)(((int)(uint)((int)(_14547 > 0.0f))) - ((int)(uint)((int)(_14547 < 0.0f)))));
                                _14557 = ((1.0f - (((float)((bool)_14545)) * 2.0f)) * _14370) * _14553;
                                _14559 = _14557 - _14340;
                                _14560 = (_14553 * _14371) - _14344;
                                _14561 = (_14506 < _14508);
                                _14563 = select(_14561, _14354, _14351);
                                _14569 = float((int)(((int)(uint)((int)(_14563 > 0.0f))) - ((int)(uint)((int)(_14563 < 0.0f)))));
                                _14570 = _14569 * _14370;
                                _14575 = _14570 - _14340;
                                _14576 = ((((((float)((bool)_14561)) * 2.0f) + -1.0f) * _14371) * _14569) - _14344;
                                _14579 = rsqrt(_14520 * dot(float3(_14559, _14560, _14376), float3(_14559, _14560, _14376)));
                                _14581 = dot(float3(_14559, _14560, _14376), float3(_14515, _14517, _14376)) * _14579;
                                _14588 = rsqrt(max(((((_14581 * 0.09300000220537186f) + 0.5f) * _14581) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14579;
                                _14601 = rsqrt(dot(float3(_14575, _14576, _14376), float3(_14575, _14576, _14376)) * _14521);
                                _14603 = dot(float3(_14518, _14519, _14376), float3(_14575, _14576, _14376)) * _14601;
                                _14610 = rsqrt(max(((((_14603 * 0.09300000220537186f) + 0.5f) * _14603) + 0.40700000524520874f), 9.999999682655225e-21f)) * _14601;
                                _14631 = ((((_14532 * (((_14509 - _14510) * _14497) * _14376)) + _14487) + (_14588 * ((_14560 - _14517) * _14376))) + (_14610 * ((_14519 - _14576) * _14376)));
                                _14632 = ((((_14532 * ((_14354 * (_14510 - _14509)) * _14376)) + _14461) + (_14588 * ((_14511 - _14557) * _14376))) + (_14610 * ((_14570 - _14513) * _14376)));
                                _14633 = ((((_14532 * ((_14519 * _14515) - (_14518 * _14517))) + _14488) + (_14588 * ((_14559 * _14517) - (_14560 * _14515)))) + (_14610 * ((_14576 * _14518) - (_14575 * _14519))));
                              } else {
                                _14631 = _14487;
                                _14632 = _14461;
                                _14633 = _14488;
                              }
                            } else {
                              _14631 = _14487;
                              _14632 = _14461;
                              _14633 = _14488;
                            }
                            _14639 = sqrt(((_14632 * _14632) + (_14631 * _14631)) + (_14633 * _14633));
                            _14640 = _14639 * 0.15915493667125702f;
                            [branch]
                            if (!(_14640 == 0.0f)) {
                              _14649 = saturate((_14640 - _14325) / (1.0f - _14325)) * ((float)((bool)(uint)(_14348 <= 0.0f)));
                              [branch]
                              if (!(_14649 == 0.0f)) {
                                if (_14639 > 0.0f) {
                                  _14657 = (dot(float3(_14351, _14354, _14357), float3(_14631, _14632, _14633)) / _14639);
                                } else {
                                  _14657 = 0.0f;
                                }
                                _14658 = 1.0f - _268;
                                _14659 = _14658 * _14658;
                                _14665 = exp2(log2(1.0f - saturate(dot(float3(_196, _197, _198), float3(_601, _602, _600)))) * 5.0f);
                                _14670 = min(_268, 0.800000011920929f);
                                _14679 = exp2(((((((_14670 * 3.322999954223633f) + -3.7669999599456787f) * _14670) + -0.3479999899864197f) * _14670) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                _14687 = _14376 / (_14369 - ((_14357 * 2.0f) * dot(float3((-0.0f - mad(_14293, _600, mad(_14292, _602, (_14291 * _601)))), (-0.0f - mad(_14299, _600, mad(_14298, _602, (_14297 * _601)))), _14369), float3(_14351, _14354, _14357))));
                                _14690 = (_14687 * 2.0f) * rsqrt(select(_212, 9.999999747378752e-05f, (((9.999999747378752e-05f - _14679) * saturate((_268 + -0.5f) * 2.500000238418579f)) + _14679)));
                                _14698 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _14336), ((log2((_14690 * _14690) * f16tof32(((uint)((uint)(_14313) >> 16)))) * 0.5f) + 5.5f));
                                _14700 = (float)((bool)(uint)(_14687 > 0.0f));
                                _14701 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _14336), 10.0f);
                                _14710 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_14649 * _1480), _14649);
                                if (_14334 > 0.0f) {
                                  _14731 = _14334 * _1633;
                                  _14732 = _14710 * _1932;
                                  _14752 = ((((((_14731 * _14327) * _14700) * _14698.x) * _14732) * select(_212, _251, (((max(_14659, _251) - _251) * _14665) + _251))) + _1872);
                                  _14753 = ((((((_14731 * _14328) * _14700) * _14698.y) * _14732) * select(_212, _252, (((max(_14659, _252) - _252) * _14665) + _252))) + _1873);
                                  _14754 = ((((((_14330 * _14731) * _14700) * _14698.z) * _14732) * select(_212, _253, (((max(_14659, _253) - _253) * _14665) + _253))) + _1874);
                                } else {
                                  _14752 = _1872;
                                  _14753 = _1873;
                                  _14754 = _1874;
                                }
                                _14760 = ((_1932 * 5.4256415367126465f) * _14657) * _14710;
                                _14768 = (((_14701.x * _14327) * _14760) + _1869);
                                _14769 = (((_14701.y * _14328) * _14760) + _1870);
                                _14770 = (((_14701.z * _14330) * _14760) + _1871);
                                _14771 = _14752;
                                _14772 = _14753;
                                _14773 = _14754;
                              } else {
                                _14768 = _1869;
                                _14769 = _1870;
                                _14770 = _1871;
                                _14771 = _1872;
                                _14772 = _1873;
                                _14773 = _1874;
                              }
                            } else {
                              _14768 = _1869;
                              _14769 = _1870;
                              _14770 = _1871;
                              _14771 = _1872;
                              _14772 = _1873;
                              _14773 = _1874;
                            }
                          } else {
                            _14768 = _1869;
                            _14769 = _1870;
                            _14770 = _1871;
                            _14771 = _1872;
                            _14772 = _1873;
                            _14773 = _1874;
                          }
                        }
                      }
                    }
                  }
                }
              }
            } else {
              _14768 = _1869;
              _14769 = _1870;
              _14770 = _1871;
              _14771 = _1872;
              _14772 = _1873;
              _14773 = _1874;
            }
          } else {
            _14768 = _1869;
            _14769 = _1870;
            _14770 = _1871;
            _14771 = _1872;
            _14772 = _1873;
            _14773 = _1874;
          }
          _14774 = _1875 + 1u;
          if (!(_14774 == _global_2)) {
            _1869 = _14768;
            _1870 = _14769;
            _1871 = _14770;
            _1872 = _14771;
            _1873 = _14772;
            _1874 = _14773;
            _1875 = _14774;
            continue;
          }
          _14778 = _14768;
          _14779 = _14769;
          _14780 = _14770;
          _14781 = _14771;
          _14782 = _14772;
          _14783 = _14773;
          break;
        }
      } else {
        _14778 = _1751;
        _14779 = _1752;
        _14780 = _1753;
        _14781 = _1634;
        _14782 = _1635;
        _14783 = _1636;
      }
      if (!_241) {
        _14786 = rsqrt(dot(float3(_371, _372, -1.0f), float3(_371, _372, -1.0f)));
        _14793 = 1.0f - _268;
        _14804 = (1.0f - _274) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_196, _197, _198), float3((-0.0f - (_371 * _14786)), (-0.0f - (_372 * _14786)), _14786))))) * 5.0f) * (max((_14793 * _14793), _274) - _274));
        _14955 = (_14804 * _14778);
        _14956 = (_14804 * _14779);
        _14957 = (_14804 * _14780);
      } else {
        _14955 = _14778;
        _14956 = _14779;
        _14957 = _14780;
      }
      [branch]
      if (_325) {
        uavDeferredShadingPass_Specular[int2(_70, _71)] = float3(min((cbSharedPerViewData.vHDRScale.y * _14781), 7936.0f), min((cbSharedPerViewData.vHDRScale.y * _14782), 7936.0f), min((cbSharedPerViewData.vHDRScale.y * _14783), 7936.0f));
        uavDeferredShadingPass_Diffuse[int2(_70, _71)] = float3(min((cbSharedPerViewData.vHDRScale.y * _14955), 7936.0f), min((cbSharedPerViewData.vHDRScale.y * _14956), 7936.0f), min((cbSharedPerViewData.vHDRScale.y * _14957), 7936.0f));
      } else {
        _14976 = (_593 * _162);
        _14977 = (_593 * _163);
        _14978 = (_593 * _164);
        _14979 = _14781;
        _14980 = _14782;
        _14981 = _14783;
        _14982 = _14955;
        _14983 = _14956;
        _14984 = _14957;
        uavDeferredShadingPass_Specular[int2(_70, _71)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_14982 * _14976) + _14979)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_14983 * _14977) + _14980)), 7936.0f), 5.960464477539063e-08f), max(min((((_14984 * _14978) + _14981) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
        uavDeferredShadingPass_Diffuse[int2(_70, _71)] = float3(0.0f, 0.0f, 0.0f);
      }
    } else {
      _14818 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * ((float)((uint)_70))) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
      _14819 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * ((float)((uint)_71))) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
      _14834 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _14819, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _14818)));
      _14837 = mad((cbSharedPerViewData.mViewToWorld[1][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[1][0].y), _14819, ((cbSharedPerViewData.mViewToWorld[1][0].x) * _14818)));
      _14840 = mad((cbSharedPerViewData.mViewToWorld[2][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[2][0].y), _14819, ((cbSharedPerViewData.mViewToWorld[2][0].x) * _14818)));
      [branch]
      if (cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0) {
        _14944 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
        _14945 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
        _14946 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
      } else {
        _14861 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_14834, _14837, _14840), 0.0f);
        _14865 = _14861.x * 32.0f;
        _14866 = _14861.y * 32.0f;
        _14867 = _14861.z * 32.0f;
        _14869 = rsqrt(dot(float3(_14834, _14837, _14840), float3(_14834, _14837, _14840)));
        _14870 = _14869 * _14834;
        _14871 = _14869 * _14837;
        _14872 = _14869 * _14840;
        _14873 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
        _14874 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
        _14875 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
        _14876 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
        _14877 = dot(float3(_14870, _14871, _14872), float3(_14874, _14875, _14876));
        _14882 = (_14877 * _14877) - (dot(float3(_14874, _14875, _14876), float3(_14874, _14875, _14876)) - (_14873 * _14873));
        if ((_14877 > -0.0f) && (_14882 > 0.0f)) {
          _14887 = -0.0f - cbDeferredShading.vSunDirWS.z;
          _14900 = 74.80000305175781f / ((dot(float3(_14870, _14871, _14872), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _14873) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
          _14908 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_14870, _14872), float2(_14887, cbDeferredShading.vSunDirWS.x)) * _14900) + 0.5f), ((dot(float3(_14870, _14871, _14872), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _14887)), (cbDeferredShading.vSunDirWS.y * _14887))) * _14900) + 0.5f)), 0.0f);
          _14910 = _14882 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
          if (_14910 > 0.0f) {
            _14917 = saturate(_14910 * 5.0f);
            _14944 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _14908.x) * _14917) + _14865);
            _14945 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _14908.y) * _14917) + _14866);
            _14946 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _14908.z) * _14917) + _14867);
          } else {
            _14944 = _14865;
            _14945 = _14866;
            _14946 = _14867;
          }
        } else {
          _14944 = _14865;
          _14945 = _14866;
          _14946 = _14867;
        }
      }
      _14950 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
      _14976 = 0.0f;
      _14977 = 0.0f;
      _14978 = 0.0f;
      _14979 = select(_14950, 0.0f, _14944);
      _14980 = select(_14950, 0.0f, _14945);
      _14981 = select(_14950, 0.0f, _14946);
      _14982 = 0.0f;
      _14983 = 0.0f;
      _14984 = 0.0f;
      uavDeferredShadingPass_Specular[int2(_70, _71)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_14982 * _14976) + _14979)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_14983 * _14977) + _14980)), 7936.0f), 5.960464477539063e-08f), max(min((((_14984 * _14978) + _14981) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_70, _71)] = float3(0.0f, 0.0f, 0.0f);
    }
  }
}