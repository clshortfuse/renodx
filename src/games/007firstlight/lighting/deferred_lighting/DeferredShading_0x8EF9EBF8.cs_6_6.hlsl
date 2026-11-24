#include "deferred_isfast.hlsli"

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
  uint _56;
  int _62;
  uint _67;
  uint _68;
  uint _75;
  int _78;
  int _93;
  float _280;
  float _281;
  float _282;
  float _283;
  float _373;
  float _374;
  float _412;
  int _450;
  float _451;
  float _452;
  float _453;
  int _566;
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
  float _577;
  float _578;
  float _579;
  float _580;
  float _695;
  float _696;
  float _697;
  float _784;
  float _785;
  float _786;
  float _804;
  float _805;
  float _806;
  float _838;
  float _839;
  float _840;
  float _841;
  float _842;
  float _843;
  float _844;
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
  float _871;
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
  float _886;
  float _887;
  float _888;
  float _889;
  float _938;
  float _939;
  float _940;
  float _960;
  float _961;
  float _962;
  float _973;
  float _974;
  float _975;
  float _976;
  float _977;
  float _978;
  float _981;
  float _982;
  float _983;
  float _984;
  float _985;
  float _986;
  float _987;
  float _1001;
  float _1002;
  float _1003;
  float _1004;
  float _1005;
  float _1006;
  float _1035;
  float _1036;
  float _1037;
  float _1057;
  float _1058;
  float _1059;
  float _1070;
  float _1071;
  float _1072;
  float _1073;
  float _1074;
  float _1075;
  float _1094;
  float _1095;
  float _1096;
  float _1097;
  float _1098;
  float _1099;
  float _1100;
  float _1119;
  float _1120;
  float _1121;
  int _1152;
  float _1153;
  float _1271;
  float _1276;
  float _1292;
  float _1367;
  float _1386;
  float _1439;
  float _1440;
  float _1441;
  float _1494;
  float _1495;
  float _1496;
  float _1606;
  float _1611;
  float _1612;
  float _1613;
  float _1614;
  float _1615;
  float _1616;
  int _1617;
  float _2280;
  float _2281;
  float _2282;
  float _2283;
  float _2373;
  float _2382;
  float _2391;
  float _2399;
  float _2470;
  float _2479;
  float _2488;
  float _2496;
  float _2569;
  float _2578;
  float _2587;
  float _2595;
  float _2668;
  float _2677;
  float _2686;
  float _2694;
  float _2746;
  float _2751;
  float _2752;
  float _2753;
  float _2850;
  float _2855;
  float _2856;
  float _2857;
  float _2878;
  float _2879;
  float _2880;
  int _2900;
  float _2917;
  float _2921;
  float _2927;
  float _2967;
  float _2968;
  float _3205;
  float _3367;
  float _3368;
  float _3369;
  float _3395;
  float _3477;
  float _3478;
  float _3479;
  float _3867;
  float _3868;
  float _3869;
  float _3892;
  float _3893;
  float _3894;
  float _3925;
  float _3954;
  float _3955;
  float _3956;
  float _3972;
  float _3973;
  float _3974;
  float _3987;
  float _3988;
  float _3989;
  float _4154;
  float _4155;
  float _4156;
  float _4157;
  float _4158;
  float _4159;
  float _4160;
  float _4161;
  float _4253;
  float _4254;
  float _4255;
  float _4256;
  float _4257;
  float _4360;
  float _4369;
  float _4378;
  float _4386;
  float _4457;
  float _4466;
  float _4475;
  float _4483;
  float _4556;
  float _4565;
  float _4574;
  float _4582;
  float _4655;
  float _4664;
  float _4673;
  float _4681;
  float _5070;
  float _5071;
  float _5072;
  int _5073;
  float _5102;
  float _5103;
  float _5104;
  float _5105;
  float _5106;
  float _5208;
  float _5217;
  float _5226;
  float _5234;
  float _5305;
  float _5314;
  float _5323;
  float _5331;
  float _5404;
  float _5413;
  float _5422;
  float _5430;
  float _5503;
  float _5512;
  float _5521;
  float _5529;
  float _5863;
  float _5864;
  bool _5865;
  float _5883;
  float _5884;
  float _5885;
  float _5886;
  float _5944;
  float _5945;
  float _5970;
  float _5971;
  float _6066;
  float _6072;
  float _6073;
  float _6074;
  float _6075;
  float _6095;
  float _6096;
  float _6097;
  int _6116;
  float _6133;
  float _6137;
  float _6164;
  float _6165;
  float _6166;
  float _6197;
  float _6226;
  float _6227;
  float _6228;
  float _6244;
  float _6245;
  float _6246;
  float _6286;
  float _6287;
  float _6368;
  float _6369;
  float _6370;
  float _6601;
  float _6764;
  float _6765;
  float _6766;
  float _6907;
  float _6908;
  float _7289;
  float _7290;
  float _7291;
  float _7844;
  float _7845;
  float _7846;
  float _7847;
  float _7937;
  float _7946;
  float _7955;
  float _7963;
  float _8034;
  float _8043;
  float _8052;
  float _8060;
  float _8133;
  float _8142;
  float _8151;
  float _8159;
  float _8232;
  float _8241;
  float _8250;
  float _8258;
  float _8310;
  float _8315;
  float _8316;
  float _8317;
  float _8414;
  float _8419;
  float _8420;
  float _8421;
  float _8442;
  float _8443;
  float _8444;
  int _8464;
  float _8481;
  float _8489;
  float _8515;
  float _8516;
  float _8517;
  float _8548;
  float _8577;
  float _8578;
  float _8579;
  float _8595;
  float _8596;
  float _8597;
  float _8598;
  float _8638;
  float _8639;
  float _8720;
  float _8721;
  float _8722;
  float _8953;
  float _9116;
  float _9117;
  float _9118;
  float _9268;
  float _9269;
  float _9293;
  float _9294;
  float _9319;
  float _9320;
  float _9345;
  float _9346;
  float _9489;
  float _9490;
  float _9491;
  float _9515;
  float _9568;
  float _9569;
  float _9570;
  float _9584;
  float _9585;
  float _9586;
  float _9587;
  float _9588;
  float _9589;
  float _9594;
  float _9595;
  float _9596;
  float _9597;
  float _9598;
  float _9599;
  float _9748;
  float _9749;
  float _9750;
  float _9759;
  float _9760;
  float _9761;
  float _9762;
  float _9763;
  float _9764;
  float _9765;
  float _9766;
  float _9767;
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
  float _175;
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
  float _204;
  float _205;
  float _206;
  float _207;
  float _208;
  float _209;
  float _210;
  float _218;
  float _224;
  uint _232;
  float _235;
  float _243;
  float _244;
  float _245;
  float _246;
  int _252;
  uint _256;
  float _262;
  float4 _271;
  float _292;
  float _293;
  float _308;
  float _309;
  float _312;
  float _313;
  float _316;
  float _317;
  float4 _322;
  float _356;
  float _358;
  bool _359;
  float _361;
  float _363;
  bool _364;
  float4 _377;
  float _381;
  float _393;
  float _394;
  float _395;
  float _396;
  float _397;
  float _398;
  bool _401;
  bool _415;
  int _416;
  float2 _419;
  float _424;
  float _425;
  float _429;
  float _431;
  float _432;
  float _437;
  float _438;
  float _440;
  float _441;
  float _442;
  float _443;
  float _445;
  float _454;
  float _455;
  float _457;
  float _458;
  float _459;
  int _467;
  int _468;
  int _469;
  int _470;
  float _474;
  float _476;
  float _477;
  float _487;
  float _488;
  float _493;
  float _497;
  float _498;
  float _501;
  float _511;
  float _512;
  float _513;
  float _517;
  float _532;
  float _535;
  float _538;
  float _541;
  float _544;
  float _547;
  int _583;
  int _584;
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
  float _611;
  float _612;
  float _613;
  float _614;
  float _617;
  float _618;
  float _619;
  float _620;
  int _623;
  float _626;
  float _627;
  float _628;
  float _631;
  float _632;
  float _633;
  int _636;
  int _639;
  int _642;
  float _671;
  float _674;
  float _677;
  float _678;
  float4 _684;
  float4 _690;
  float _699;
  float _703;
  float _706;
  float _709;
  float _750;
  float _755;
  float _757;
  float _759;
  float _766;
  float _767;
  float4 _773;
  float4 _779;
  float _787;
  float4 _793;
  float4 _799;
  float _816;
  float _817;
  float _818;
  float _819;
  float _820;
  float _821;
  float _822;
  float _823;
  float _824;
  uint _872;
  bool _895;
  int _905;
  float _907;
  float _908;
  float _915;
  float _920;
  float _921;
  bool _922;
  float4 _927;
  float4 _933;
  float _944;
  float4 _949;
  float4 _955;
  float _993;
  int _1013;
  float _1014;
  float _1017;
  float _1018;
  bool _1019;
  float4 _1024;
  float4 _1030;
  float _1041;
  float4 _1046;
  float4 _1052;
  float _1080;
  float _1134;
  float4 _1137;
  float _1140;
  float _1145;
  float _1147;
  float _1148;
  uint _1154;
  int _1157;
  int _1158;
  int _1162;
  int _1166;
  float _1178;
  float _1183;
  float _1184;
  float _1185;
  float _1186;
  float _1189;
  float _1190;
  float _1191;
  float _1192;
  float _1195;
  float _1196;
  float _1197;
  float _1198;
  int _1201;
  int _1204;
  int _1207;
  int _1210;
  float _1225;
  float _1229;
  float _1233;
  float _1258;
  float _1259;
  float _1260;
  float _1263;
  uint _1272;
  bool _1280;
  float _1295;
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
  float _1371;
  float _1375;
  float _1379;
  int _1389;
  int _1392;
  int _1393;
  int _1394;
  int _1400;
  int _1401;
  int _1402;
  int _1408;
  int _1409;
  int _1410;
  float _1416;
  float _1420;
  float _1424;
  float _1431;
  int _1444;
  int _1447;
  int _1448;
  int _1449;
  int _1455;
  int _1456;
  int _1457;
  int _1463;
  int _1464;
  int _1465;
  float _1471;
  float _1475;
  float _1479;
  float _1486;
  float _1519;
  float _1523;
  float _1527;
  float _1546;
  float _1550;
  float _1554;
  float _1567;
  float _1568;
  float _1569;
  uint _1607;
  int _1619;
  int _1623;
  int _1624;
  int _1625;
  int _1626;
  int _1638;
  int _1642;
  float _1654;
  int _1657;
  float _1674;
  float _1679;
  float _1680;
  float _1681;
  float _1682;
  float _1685;
  float _1686;
  float _1687;
  float _1688;
  float _1691;
  float _1692;
  float _1693;
  float _1694;
  int _1697;
  int _1700;
  int _1703;
  int _1706;
  int _1709;
  float _1711;
  float _1712;
  float _1714;
  float _1718;
  float _1731;
  float _1735;
  float _1739;
  float _1764;
  float _1765;
  float _1766;
  float _1769;
  float _1770;
  float _1777;
  float _1798;
  float _1799;
  float _1800;
  float _1801;
  float _1804;
  float _1805;
  float _1806;
  float _1807;
  float _1810;
  float _1811;
  float _1812;
  float _1813;
  float _1816;
  float _1817;
  float _1818;
  float _1821;
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
  int _1874;
  bool _1880;
  float _1885;
  float _1886;
  float _1888;
  float _1889;
  float _1890;
  float _1891;
  float _1910;
  float _1914;
  float _1915;
  float _1916;
  float _1920;
  float _1924;
  float _1928;
  float _1929;
  float _1952;
  float _1953;
  float _1954;
  float _1957;
  float _1958;
  float _1965;
  float _1966;
  float _1967;
  float _1972;
  float _1974;
  float _1975;
  float _1978;
  float _1982;
  float _1991;
  float _1992;
  float _1993;
  int _1994;
  float _1999;
  float _2008;
  float _2009;
  float _2011;
  float4 _2016;
  float _2021;
  float _2023;
  float _2025;
  float _2027;
  float _2031;
  float _2033;
  float _2037;
  float _2039;
  int _2046;
  float _2051;
  float _2060;
  float _2061;
  float4 _2067;
  float _2072;
  float _2074;
  float _2078;
  float _2080;
  float _2084;
  float _2086;
  float _2090;
  float _2092;
  int _2099;
  float _2104;
  float _2113;
  float _2114;
  float4 _2120;
  float _2125;
  float _2127;
  float _2131;
  float _2133;
  float _2137;
  float _2139;
  float _2143;
  float _2145;
  int _2152;
  float _2157;
  float _2166;
  float _2167;
  float4 _2173;
  float _2178;
  float _2180;
  float _2184;
  float _2186;
  float _2190;
  float _2192;
  float _2196;
  float _2198;
  float _2199;
  float _2210;
  float _2216;
  float _2218;
  float _2220;
  float _2227;
  float _2232;
  float _2233;
  float _2234;
  float _2235;
  float4 _2237;
  float _2245;
  float _2246;
  float4 _2247;
  float _2252;
  float _2257;
  float4 _2258;
  float _2263;
  float4 _2268;
  float _2277;
  float _2286;
  float _2287;
  float _2296;
  float _2300;
  float _2309;
  float _2310;
  float _2311;
  float _2316;
  int _2317;
  float _2322;
  float _2331;
  float _2332;
  float _2334;
  float _2336;
  float _2337;
  float4 _2339;
  float _2343;
  float _2344;
  float _2347;
  float _2348;
  float _2353;
  float _2354;
  float _2357;
  float _2358;
  float _2360;
  float _2362;
  bool _2363;
  bool _2364;
  bool _2374;
  bool _2383;
  float _2400;
  float _2402;
  float _2404;
  float _2406;
  float _2410;
  float _2412;
  float _2416;
  float _2418;
  int _2425;
  float _2430;
  float _2439;
  float _2440;
  float _2443;
  float _2444;
  float4 _2446;
  float _2450;
  float _2451;
  float _2454;
  float _2455;
  float _2457;
  float _2459;
  bool _2460;
  bool _2461;
  bool _2471;
  bool _2480;
  float _2497;
  float _2499;
  float _2503;
  float _2505;
  float _2509;
  float _2511;
  float _2515;
  float _2517;
  int _2524;
  float _2529;
  float _2538;
  float _2539;
  float _2542;
  float _2543;
  float4 _2545;
  float _2549;
  float _2550;
  float _2553;
  float _2554;
  float _2556;
  float _2558;
  bool _2559;
  bool _2560;
  bool _2570;
  bool _2579;
  float _2596;
  float _2598;
  float _2602;
  float _2604;
  float _2608;
  float _2610;
  float _2614;
  float _2616;
  int _2623;
  float _2628;
  float _2637;
  float _2638;
  float _2641;
  float _2642;
  float4 _2644;
  float _2648;
  float _2649;
  float _2652;
  float _2653;
  float _2655;
  float _2657;
  bool _2658;
  bool _2659;
  bool _2669;
  bool _2678;
  float _2695;
  float _2697;
  float _2701;
  float _2703;
  float _2707;
  float _2709;
  float _2713;
  float _2715;
  float _2716;
  float _2727;
  float _2733;
  float _2735;
  float _2737;
  float _2759;
  float4 _2766;
  float _2780;
  float _2781;
  float _2782;
  float _2783;
  float _2785;
  float _2790;
  float _2793;
  float _2794;
  float _2796;
  float _2797;
  float _2802;
  float _2807;
  float _2809;
  float _2812;
  float _2813;
  float _2818;
  float _2820;
  float _2822;
  float _2824;
  float _2829;
  float _2835;
  float _2837;
  float3 _2870;
  float _2881;
  float _2882;
  float4 _2903;
  int _2934;
  int _2939;
  int _2941;
  int _2942;
  int _2944;
  int _2945;
  int _2954;
  int _2957;
  bool _2972;
  float _2975;
  float _2978;
  float _2979;
  float _2980;
  float _2981;
  float _2982;
  float _2983;
  uint _2986;
  float _2995;
  float _2996;
  float _2997;
  float _3013;
  float _3020;
  float _3023;
  float _3028;
  float _3035;
  float _3036;
  float _3037;
  float _3038;
  float _3060;
  float _3061;
  float _3062;
  float _3064;
  float _3079;
  float _3080;
  float _3081;
  float _3082;
  bool _3085;
  float _3086;
  float _3087;
  float _3088;
  float _3090;
  float _3093;
  float _3095;
  float _3096;
  float _3097;
  float _3098;
  float _3101;
  float _3104;
  float _3107;
  float _3109;
  float _3113;
  float _3122;
  float _3123;
  float _3125;
  float _3126;
  float _3127;
  float _3134;
  float _3135;
  float _3136;
  float _3137;
  float _3140;
  float _3143;
  float _3144;
  float _3149;
  float _3153;
  float _3158;
  float _3165;
  float _3169;
  float _3170;
  float _3171;
  float _3175;
  float _3176;
  float _3177;
  float _3184;
  float _3188;
  float _3192;
  float _3193;
  float _3194;
  float _3198;
  float _3208;
  float _3218;
  float _3220;
  float _3233;
  float _3234;
  float _3240;
  float _3243;
  float _3252;
  float _3254;
  float _3263;
  float _3268;
  float _3274;
  float _3275;
  float _3279;
  float _3280;
  float _3285;
  float _3304;
  float _3307;
  float _3310;
  float _3324;
  float _3334;
  float _3335;
  float _3339;
  float _3341;
  float _3343;
  float _3346;
  float _3359;
  float _3370;
  float _3371;
  float _3372;
  float _3379;
  float _3380;
  float _3381;
  float _3384;
  float _3398;
  float _3399;
  float _3400;
  float _3401;
  float _3404;
  float _3405;
  float _3406;
  float _3407;
  float _3410;
  float _3411;
  float _3412;
  int _3415;
  int _3418;
  int _3421;
  int _3424;
  int _3427;
  float _3431;
  int _3432;
  float2 _3452;
  float3 _3469;
  float _3482;
  float _3486;
  float _3487;
  float _3488;
  float _3489;
  float _3490;
  float _3491;
  uint _3494;
  float _3503;
  float _3504;
  float _3505;
  float _3521;
  float _3528;
  float _3531;
  float _3536;
  float _3543;
  float _3544;
  float _3545;
  float _3546;
  float _3568;
  float _3569;
  float _3570;
  float _3572;
  float _3587;
  float _3588;
  float _3589;
  float _3590;
  bool _3593;
  float _3594;
  float _3595;
  float _3596;
  float _3598;
  float _3601;
  float _3603;
  float _3604;
  float _3605;
  float _3606;
  float _3609;
  float _3612;
  float _3615;
  float _3617;
  float _3621;
  float _3630;
  float _3631;
  float _3633;
  float _3634;
  float _3635;
  float _3642;
  float _3643;
  float _3644;
  float _3645;
  float _3648;
  float _3651;
  float _3652;
  float _3657;
  float _3661;
  float _3666;
  float _3673;
  float _3677;
  float _3678;
  float _3679;
  float _3683;
  float _3684;
  float _3685;
  float _3692;
  float _3696;
  float _3700;
  float _3701;
  float _3702;
  float _3705;
  float _3708;
  float _3718;
  float _3720;
  float _3733;
  float _3734;
  float _3740;
  float _3743;
  float _3752;
  float _3754;
  float _3763;
  float _3768;
  float _3774;
  float _3775;
  float _3779;
  float _3780;
  float _3785;
  float _3804;
  float _3807;
  float _3810;
  float _3824;
  float _3834;
  float _3835;
  float _3839;
  float _3841;
  float _3843;
  float _3846;
  float _3859;
  float _3882;
  bool _3895;
  float _3896;
  float _3897;
  float _3898;
  bool _3899;
  float _3901;
  float _3902;
  float _3906;
  float _3912;
  float _3926;
  float _3927;
  float _3930;
  float _3934;
  int _3935;
  float _3937;
  float _3939;
  float _3942;
  float _3946;
  float _3957;
  float _3958;
  float _3959;
  float _3961;
  float _3975;
  float _3976;
  float _3977;
  float _3993;
  float _3994;
  float _3995;
  float _4009;
  float _4024;
  float _4025;
  float _4026;
  float _4029;
  float _4030;
  float _4031;
  float _4034;
  float _4035;
  float _4036;
  float _4039;
  float _4040;
  float _4041;
  float _4044;
  float _4045;
  float _4046;
  int _4049;
  int _4052;
  int _4055;
  int _4058;
  int _4061;
  int _4064;
  int _4067;
  int _4070;
  int _4073;
  int _4076;
  float _4079;
  float _4080;
  float _4081;
  float _4082;
  int _4085;
  int _4088;
  int _4091;
  int _4094;
  float _4096;
  float _4097;
  float _4099;
  float _4103;
  float _4104;
  float _4107;
  float _4109;
  float _4110;
  float _4112;
  int _4115;
  bool _4119;
  float _4127;
  float _4128;
  float _4130;
  float _4133;
  float _4134;
  float _4136;
  float _4137;
  float _4139;
  float _4140;
  float _4144;
  float _4150;
  float _4151;
  float _4152;
  float _4165;
  float _4166;
  float _4167;
  float _4168;
  float _4169;
  float _4170;
  float _4171;
  float _4172;
  float _4173;
  float _4176;
  float _4177;
  float _4178;
  float _4181;
  float _4188;
  float _4201;
  float _4205;
  float _4209;
  float _4210;
  float _4211;
  float _4214;
  float _4217;
  bool _4219;
  float _4225;
  float _4226;
  float _4227;
  float _4232;
  float _4233;
  float _4234;
  bool _4238;
  bool _4244;
  bool _4248;
  float _4258;
  float _4263;
  float _4272;
  float _4273;
  float _4274;
  float _4279;
  float _4280;
  float _4283;
  float _4287;
  float _4296;
  float _4297;
  float _4298;
  float _4303;
  int _4304;
  float _4309;
  float _4318;
  float _4319;
  float _4321;
  float _4323;
  float _4324;
  float4 _4326;
  float _4330;
  float _4331;
  float _4334;
  float _4335;
  float _4340;
  float _4341;
  float _4344;
  float _4345;
  float _4347;
  float _4349;
  bool _4350;
  bool _4351;
  bool _4361;
  bool _4370;
  float _4387;
  float _4389;
  float _4391;
  float _4393;
  float _4397;
  float _4399;
  float _4403;
  float _4405;
  int _4412;
  float _4417;
  float _4426;
  float _4427;
  float _4430;
  float _4431;
  float4 _4433;
  float _4437;
  float _4438;
  float _4441;
  float _4442;
  float _4444;
  float _4446;
  bool _4447;
  bool _4448;
  bool _4458;
  bool _4467;
  float _4484;
  float _4486;
  float _4490;
  float _4492;
  float _4496;
  float _4498;
  float _4502;
  float _4504;
  int _4511;
  float _4516;
  float _4525;
  float _4526;
  float _4529;
  float _4530;
  float4 _4532;
  float _4536;
  float _4537;
  float _4540;
  float _4541;
  float _4543;
  float _4545;
  bool _4546;
  bool _4547;
  bool _4557;
  bool _4566;
  float _4583;
  float _4585;
  float _4589;
  float _4591;
  float _4595;
  float _4597;
  float _4601;
  float _4603;
  int _4610;
  float _4615;
  float _4624;
  float _4625;
  float _4628;
  float _4629;
  float4 _4631;
  float _4635;
  float _4636;
  float _4639;
  float _4640;
  float _4642;
  float _4644;
  bool _4645;
  bool _4646;
  bool _4656;
  bool _4665;
  float _4682;
  float _4684;
  float _4688;
  float _4690;
  float _4694;
  float _4696;
  float _4700;
  float _4702;
  float _4703;
  float _4714;
  float _4720;
  float _4722;
  float _4724;
  float _4736;
  float _4739;
  float _4740;
  float _4743;
  float _4754;
  float _4755;
  float _4756;
  float _4760;
  float _4769;
  float _4770;
  float _4771;
  int _4772;
  float _4777;
  float _4786;
  float _4787;
  float _4789;
  float4 _4794;
  float _4799;
  float _4801;
  float _4803;
  float _4805;
  float _4809;
  float _4811;
  float _4815;
  float _4817;
  int _4824;
  float _4829;
  float _4838;
  float _4839;
  float4 _4845;
  float _4850;
  float _4852;
  float _4856;
  float _4858;
  float _4862;
  float _4864;
  float _4868;
  float _4870;
  int _4877;
  float _4882;
  float _4891;
  float _4892;
  float4 _4898;
  float _4903;
  float _4905;
  float _4909;
  float _4911;
  float _4915;
  float _4917;
  float _4921;
  float _4923;
  int _4930;
  float _4935;
  float _4944;
  float _4945;
  float4 _4951;
  float _4956;
  float _4958;
  float _4962;
  float _4964;
  float _4968;
  float _4970;
  float _4974;
  float _4976;
  float _4977;
  float _4988;
  float _4994;
  float _4996;
  float _4998;
  float _5006;
  float _5013;
  float _5015;
  float _5022;
  float _5023;
  float _5024;
  float _5025;
  float4 _5027;
  float _5036;
  float4 _5037;
  float _5042;
  float _5048;
  float4 _5049;
  float _5054;
  float4 _5059;
  float _5081;
  float _5082;
  float _5083;
  bool _5087;
  bool _5093;
  bool _5097;
  float _5107;
  float _5112;
  float _5121;
  float _5122;
  float _5127;
  float _5128;
  float _5131;
  float _5135;
  float _5144;
  float _5145;
  float _5146;
  float _5151;
  int _5152;
  float _5157;
  float _5166;
  float _5167;
  float _5169;
  float _5171;
  float _5172;
  float4 _5174;
  float _5178;
  float _5179;
  float _5182;
  float _5183;
  float _5188;
  float _5189;
  float _5192;
  float _5193;
  float _5195;
  float _5197;
  bool _5198;
  bool _5199;
  bool _5209;
  bool _5218;
  float _5235;
  float _5237;
  float _5239;
  float _5241;
  float _5245;
  float _5247;
  float _5251;
  float _5253;
  int _5260;
  float _5265;
  float _5274;
  float _5275;
  float _5278;
  float _5279;
  float4 _5281;
  float _5285;
  float _5286;
  float _5289;
  float _5290;
  float _5292;
  float _5294;
  bool _5295;
  bool _5296;
  bool _5306;
  bool _5315;
  float _5332;
  float _5334;
  float _5338;
  float _5340;
  float _5344;
  float _5346;
  float _5350;
  float _5352;
  int _5359;
  float _5364;
  float _5373;
  float _5374;
  float _5377;
  float _5378;
  float4 _5380;
  float _5384;
  float _5385;
  float _5388;
  float _5389;
  float _5391;
  float _5393;
  bool _5394;
  bool _5395;
  bool _5405;
  bool _5414;
  float _5431;
  float _5433;
  float _5437;
  float _5439;
  float _5443;
  float _5445;
  float _5449;
  float _5451;
  int _5458;
  float _5463;
  float _5472;
  float _5473;
  float _5476;
  float _5477;
  float4 _5479;
  float _5483;
  float _5484;
  float _5487;
  float _5488;
  float _5490;
  float _5492;
  bool _5493;
  bool _5494;
  bool _5504;
  bool _5513;
  float _5530;
  float _5532;
  float _5536;
  float _5538;
  float _5542;
  float _5544;
  float _5548;
  float _5550;
  float _5551;
  float _5562;
  float _5568;
  float _5570;
  float _5572;
  float _5581;
  float _5584;
  float _5585;
  float _5598;
  float _5599;
  float _5600;
  float _5604;
  float _5613;
  float _5614;
  float _5615;
  int _5616;
  float _5621;
  float _5630;
  float _5631;
  float _5633;
  float4 _5638;
  float _5643;
  float _5645;
  float _5647;
  float _5649;
  float _5653;
  float _5655;
  float _5659;
  float _5661;
  int _5668;
  float _5673;
  float _5682;
  float _5683;
  float4 _5689;
  float _5694;
  float _5696;
  float _5700;
  float _5702;
  float _5706;
  float _5708;
  float _5712;
  float _5714;
  int _5721;
  float _5726;
  float _5735;
  float _5736;
  float4 _5742;
  float _5747;
  float _5749;
  float _5753;
  float _5755;
  float _5759;
  float _5761;
  float _5765;
  float _5767;
  int _5774;
  float _5779;
  float _5788;
  float _5789;
  float4 _5795;
  float _5800;
  float _5802;
  float _5806;
  float _5808;
  float _5812;
  float _5814;
  float _5818;
  float _5820;
  float _5821;
  float _5832;
  float _5838;
  float _5840;
  float _5842;
  float _5850;
  float _5857;
  float _5859;
  float _5889;
  float _5891;
  float _5892;
  float _5893;
  float _5908;
  float _5911;
  float _5914;
  float _5916;
  float _5917;
  float _5918;
  float _5919;
  float _5927;
  float _5928;
  float _5929;
  bool _5931;
  float _5951;
  float4 _5976;
  float _5996;
  float _5997;
  float _5998;
  float _5999;
  float _6001;
  float _6006;
  float _6009;
  float _6010;
  float _6012;
  float _6013;
  float _6018;
  float _6023;
  float _6025;
  float _6028;
  float _6029;
  float _6034;
  float _6036;
  float _6038;
  float _6040;
  float _6045;
  float _6051;
  float _6053;
  float3 _6087;
  float _6098;
  float4 _6119;
  float _6154;
  bool _6167;
  float _6168;
  float _6169;
  float _6170;
  bool _6171;
  float _6173;
  float _6174;
  float _6178;
  float _6184;
  float _6198;
  float _6199;
  float _6202;
  float _6206;
  int _6207;
  float _6209;
  float _6211;
  float _6214;
  float _6218;
  float _6229;
  float _6230;
  float _6231;
  float _6233;
  int _6253;
  int _6258;
  int _6260;
  int _6261;
  int _6263;
  int _6264;
  int _6273;
  int _6276;
  bool _6291;
  float _6294;
  float _6296;
  float _6297;
  float _6298;
  float _6299;
  float _6300;
  float _6301;
  float _6302;
  float _6303;
  float _6304;
  float _6306;
  float _6307;
  float _6308;
  float _6314;
  float _6318;
  float _6319;
  float _6320;
  float _6321;
  float _6322;
  float _6323;
  float _6324;
  float _6330;
  float _6339;
  float _6343;
  float _6344;
  float _6345;
  float _6346;
  float _6350;
  float _6351;
  float _6352;
  float _6360;
  float _6372;
  float _6373;
  float _6374;
  float _6375;
  float _6377;
  float _6378;
  float _6379;
  float _6380;
  float _6382;
  uint _6385;
  float _6394;
  float _6395;
  float _6396;
  float _6409;
  float _6416;
  float _6419;
  float _6424;
  float _6431;
  float _6432;
  float _6433;
  float _6434;
  float _6456;
  float _6457;
  float _6458;
  float _6460;
  float _6475;
  float _6476;
  float _6477;
  float _6478;
  bool _6481;
  float _6482;
  float _6483;
  float _6484;
  float _6486;
  float _6489;
  float _6491;
  float _6492;
  float _6493;
  float _6494;
  float _6497;
  float _6500;
  float _6503;
  float _6505;
  float _6509;
  float _6518;
  float _6519;
  float _6521;
  float _6522;
  float _6523;
  float _6530;
  float _6531;
  float _6532;
  float _6533;
  float _6536;
  float _6539;
  float _6540;
  float _6545;
  float _6549;
  float _6554;
  float _6561;
  float _6565;
  float _6566;
  float _6567;
  float _6571;
  float _6572;
  float _6573;
  float _6580;
  float _6584;
  float _6588;
  float _6589;
  float _6590;
  float _6594;
  float _6605;
  float _6615;
  float _6617;
  float _6630;
  float _6631;
  float _6637;
  float _6640;
  float _6649;
  float _6651;
  float _6660;
  float _6665;
  float _6671;
  float _6672;
  float _6676;
  float _6677;
  float _6682;
  float _6701;
  float _6704;
  float _6707;
  float _6721;
  float _6731;
  float _6732;
  float _6736;
  float _6738;
  float _6740;
  float _6743;
  float _6756;
  float _6767;
  float _6768;
  float _6769;
  float _6776;
  float _6777;
  float _6778;
  float _6782;
  float _6797;
  float _6798;
  float _6799;
  float _6802;
  float _6803;
  float _6804;
  float _6807;
  int _6810;
  int _6813;
  int _6816;
  float _6825;
  float _6828;
  float _6835;
  float _6840;
  float _6842;
  float _6844;
  float _6845;
  float _6846;
  float _6848;
  float _6849;
  float _6850;
  float _6853;
  float _6854;
  float _6855;
  float _6858;
  float _6865;
  int _6874;
  int _6879;
  int _6881;
  int _6882;
  int _6884;
  int _6885;
  int _6894;
  int _6897;
  bool _6912;
  float _6915;
  float _6917;
  float _6918;
  uint _6921;
  float _6930;
  float _6931;
  float _6932;
  float _6948;
  float _6955;
  float _6958;
  float _6963;
  float _6970;
  float _6971;
  float _6972;
  float _6973;
  float _6995;
  float _6996;
  float _6997;
  float _6999;
  float _7011;
  float _7012;
  float _7013;
  float _7014;
  bool _7017;
  float _7018;
  float _7019;
  float _7020;
  float _7022;
  float _7025;
  float _7027;
  float _7028;
  float _7029;
  float _7030;
  float _7033;
  float _7036;
  float _7039;
  float _7041;
  float _7045;
  float _7054;
  float _7055;
  float _7057;
  float _7058;
  float _7059;
  float _7066;
  float _7067;
  float _7068;
  float _7069;
  float _7072;
  float _7075;
  float _7076;
  float _7081;
  float _7085;
  float _7090;
  float _7097;
  float _7101;
  float _7102;
  float _7103;
  float _7107;
  float _7108;
  float _7109;
  float _7116;
  float _7120;
  float _7124;
  float _7125;
  float _7126;
  float _7127;
  float _7130;
  float _7140;
  float _7142;
  float _7155;
  float _7156;
  float _7162;
  float _7165;
  float _7174;
  float _7176;
  float _7185;
  float _7190;
  float _7196;
  float _7197;
  float _7201;
  float _7202;
  float _7207;
  float _7226;
  float _7229;
  float _7232;
  float _7246;
  float _7256;
  float _7257;
  float _7261;
  float _7263;
  float _7265;
  float _7268;
  float _7281;
  float _7292;
  float _7293;
  float _7294;
  float _7301;
  float _7302;
  float _7303;
  float _7307;
  float _7322;
  float _7323;
  float _7324;
  float _7327;
  float _7328;
  float _7329;
  float _7332;
  float _7333;
  float _7334;
  float _7337;
  float _7338;
  float _7339;
  float _7342;
  float _7343;
  float _7344;
  float _7347;
  float _7348;
  float _7349;
  int _7352;
  int _7355;
  int _7358;
  float _7361;
  float _7362;
  float _7363;
  float _7364;
  int _7367;
  int _7370;
  int _7373;
  int _7376;
  int _7379;
  int _7382;
  int _7385;
  float _7388;
  float _7389;
  float _7390;
  float _7391;
  int _7394;
  int _7397;
  int _7400;
  float _7402;
  float _7403;
  float _7405;
  float _7409;
  float _7410;
  float _7413;
  int _7417;
  bool _7423;
  float _7434;
  float _7435;
  float _7437;
  float _7438;
  float _7439;
  float _7440;
  float _7441;
  float _7442;
  float _7443;
  float _7444;
  float _7445;
  float _7446;
  float _7447;
  float _7448;
  float _7449;
  float _7452;
  float _7453;
  float _7454;
  float _7457;
  float _7468;
  float _7472;
  float _7479;
  float _7480;
  float _7481;
  float _7493;
  float _7494;
  float _7495;
  float _7496;
  float _7499;
  float _7500;
  float _7503;
  float _7504;
  float _7511;
  float _7513;
  float _7519;
  float _7529;
  float _7530;
  float _7531;
  float _7536;
  float _7538;
  float _7539;
  float _7542;
  float _7546;
  float _7555;
  float _7556;
  float _7557;
  int _7558;
  float _7563;
  float _7572;
  float _7573;
  float _7575;
  float4 _7580;
  float _7585;
  float _7587;
  float _7589;
  float _7591;
  float _7595;
  float _7597;
  float _7601;
  float _7603;
  int _7610;
  float _7615;
  float _7624;
  float _7625;
  float4 _7631;
  float _7636;
  float _7638;
  float _7642;
  float _7644;
  float _7648;
  float _7650;
  float _7654;
  float _7656;
  int _7663;
  float _7668;
  float _7677;
  float _7678;
  float4 _7684;
  float _7689;
  float _7691;
  float _7695;
  float _7697;
  float _7701;
  float _7703;
  float _7707;
  float _7709;
  int _7716;
  float _7721;
  float _7730;
  float _7731;
  float4 _7737;
  float _7742;
  float _7744;
  float _7748;
  float _7750;
  float _7754;
  float _7756;
  float _7760;
  float _7762;
  float _7763;
  float _7774;
  float _7780;
  float _7782;
  float _7784;
  float _7791;
  float _7796;
  float _7797;
  float _7798;
  float _7799;
  float4 _7801;
  float _7809;
  float _7810;
  float4 _7811;
  float _7816;
  float _7821;
  float4 _7822;
  float _7827;
  float4 _7832;
  float _7841;
  float _7850;
  float _7851;
  float _7860;
  float _7864;
  float _7873;
  float _7874;
  float _7875;
  float _7880;
  int _7881;
  float _7886;
  float _7895;
  float _7896;
  float _7898;
  float _7900;
  float _7901;
  float4 _7903;
  float _7907;
  float _7908;
  float _7911;
  float _7912;
  float _7917;
  float _7918;
  float _7921;
  float _7922;
  float _7924;
  float _7926;
  bool _7927;
  bool _7928;
  bool _7938;
  bool _7947;
  float _7964;
  float _7966;
  float _7968;
  float _7970;
  float _7974;
  float _7976;
  float _7980;
  float _7982;
  int _7989;
  float _7994;
  float _8003;
  float _8004;
  float _8007;
  float _8008;
  float4 _8010;
  float _8014;
  float _8015;
  float _8018;
  float _8019;
  float _8021;
  float _8023;
  bool _8024;
  bool _8025;
  bool _8035;
  bool _8044;
  float _8061;
  float _8063;
  float _8067;
  float _8069;
  float _8073;
  float _8075;
  float _8079;
  float _8081;
  int _8088;
  float _8093;
  float _8102;
  float _8103;
  float _8106;
  float _8107;
  float4 _8109;
  float _8113;
  float _8114;
  float _8117;
  float _8118;
  float _8120;
  float _8122;
  bool _8123;
  bool _8124;
  bool _8134;
  bool _8143;
  float _8160;
  float _8162;
  float _8166;
  float _8168;
  float _8172;
  float _8174;
  float _8178;
  float _8180;
  int _8187;
  float _8192;
  float _8201;
  float _8202;
  float _8205;
  float _8206;
  float4 _8208;
  float _8212;
  float _8213;
  float _8216;
  float _8217;
  float _8219;
  float _8221;
  bool _8222;
  bool _8223;
  bool _8233;
  bool _8242;
  float _8259;
  float _8261;
  float _8265;
  float _8267;
  float _8271;
  float _8273;
  float _8277;
  float _8279;
  float _8280;
  float _8291;
  float _8297;
  float _8299;
  float _8301;
  float _8323;
  float4 _8330;
  float _8344;
  float _8345;
  float _8346;
  float _8347;
  float _8349;
  float _8354;
  float _8357;
  float _8358;
  float _8360;
  float _8361;
  float _8366;
  float _8371;
  float _8373;
  float _8376;
  float _8377;
  float _8382;
  float _8384;
  float _8386;
  float _8388;
  float _8393;
  float _8399;
  float _8401;
  float3 _8434;
  float _8445;
  float _8446;
  float4 _8467;
  float _8505;
  bool _8518;
  float _8519;
  float _8520;
  float _8521;
  bool _8522;
  float _8524;
  float _8525;
  float _8529;
  float _8535;
  float _8549;
  float _8550;
  float _8553;
  float _8557;
  int _8558;
  float _8560;
  float _8562;
  float _8565;
  float _8569;
  float _8580;
  float _8581;
  float _8582;
  float _8584;
  int _8605;
  int _8610;
  int _8612;
  int _8613;
  int _8615;
  int _8616;
  int _8625;
  int _8628;
  bool _8643;
  float _8646;
  float _8648;
  float _8649;
  float _8650;
  float _8651;
  float _8652;
  float _8653;
  float _8654;
  float _8655;
  float _8656;
  float _8658;
  float _8659;
  float _8660;
  float _8666;
  float _8670;
  float _8671;
  float _8672;
  float _8673;
  float _8674;
  float _8675;
  float _8676;
  float _8682;
  float _8691;
  float _8695;
  float _8696;
  float _8697;
  float _8698;
  float _8702;
  float _8703;
  float _8704;
  float _8712;
  float _8724;
  float _8725;
  float _8726;
  float _8727;
  float _8729;
  float _8730;
  float _8731;
  float _8732;
  float _8734;
  uint _8737;
  float _8746;
  float _8747;
  float _8748;
  float _8761;
  float _8768;
  float _8771;
  float _8776;
  float _8783;
  float _8784;
  float _8785;
  float _8786;
  float _8808;
  float _8809;
  float _8810;
  float _8812;
  float _8827;
  float _8828;
  float _8829;
  float _8830;
  bool _8833;
  float _8834;
  float _8835;
  float _8836;
  float _8838;
  float _8841;
  float _8843;
  float _8844;
  float _8845;
  float _8846;
  float _8849;
  float _8852;
  float _8855;
  float _8857;
  float _8861;
  float _8870;
  float _8871;
  float _8873;
  float _8874;
  float _8875;
  float _8882;
  float _8883;
  float _8884;
  float _8885;
  float _8888;
  float _8891;
  float _8892;
  float _8897;
  float _8901;
  float _8906;
  float _8913;
  float _8917;
  float _8918;
  float _8919;
  float _8923;
  float _8924;
  float _8925;
  float _8932;
  float _8936;
  float _8940;
  float _8941;
  float _8942;
  float _8946;
  float _8957;
  float _8967;
  float _8969;
  float _8982;
  float _8983;
  float _8989;
  float _8992;
  float _9001;
  float _9003;
  float _9012;
  float _9017;
  float _9023;
  float _9024;
  float _9028;
  float _9029;
  float _9034;
  float _9053;
  float _9056;
  float _9059;
  float _9073;
  float _9083;
  float _9084;
  float _9088;
  float _9090;
  float _9092;
  float _9095;
  float _9108;
  float _9119;
  float _9120;
  float _9121;
  float _9128;
  float _9129;
  float _9130;
  float _9134;
  float _9149;
  float _9150;
  float _9151;
  float _9152;
  float _9155;
  float _9156;
  float _9157;
  float _9158;
  float _9161;
  float _9162;
  float _9163;
  float _9164;
  float _9167;
  float _9168;
  int _9171;
  int _9174;
  int _9177;
  int _9180;
  float _9183;
  float _9185;
  float _9186;
  float _9188;
  float _9192;
  float _9194;
  float _9198;
  float _9202;
  float _9206;
  float _9209;
  float _9212;
  float _9215;
  float _9227;
  float _9228;
  float _9229;
  float _9230;
  float _9231;
  float _9232;
  float _9233;
  float _9234;
  float _9235;
  float _9236;
  float _9237;
  float _9239;
  float _9241;
  float _9243;
  float _9245;
  float _9246;
  float _9252;
  float _9254;
  float _9261;
  float _9276;
  float _9278;
  float _9285;
  float _9295;
  float _9301;
  float _9303;
  float _9310;
  float _9327;
  float _9329;
  float _9336;
  float _9355;
  float _9356;
  float _9357;
  float _9358;
  float _9360;
  float _9362;
  float _9363;
  float _9364;
  float _9365;
  float _9366;
  float _9367;
  float _9368;
  float _9369;
  float _9371;
  float _9373;
  float _9374;
  float _9375;
  float _9376;
  float _9377;
  float _9378;
  float _9379;
  float _9381;
  float _9383;
  float _9390;
  bool _9403;
  float _9405;
  float _9411;
  float _9415;
  float _9417;
  float _9418;
  bool _9419;
  float _9421;
  float _9427;
  float _9428;
  float _9433;
  float _9434;
  float _9437;
  float _9439;
  float _9446;
  float _9459;
  float _9461;
  float _9468;
  float _9497;
  float _9498;
  float _9507;
  float _9520;
  float _9521;
  float4 _9529;
  float _9531;
  float4 _9532;
  float _9541;
  float _9547;
  float _9548;
  float _9576;
  uint _9590;
  float _9601;
  float _9608;
  float _9619;
  float _9638;
  float _9641;
  float _9644;
  float4 _9665;
  float _9669;
  float _9670;
  float _9671;
  float _9673;
  float _9674;
  float _9675;
  float _9676;
  float _9677;
  float _9678;
  float _9679;
  float _9680;
  float _9681;
  float _9686;
  float _9691;
  float _9704;
  float4 _9712;
  float _9714;
  float _9721;
  bool _9754;
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
    bool _loop_break_0 = false;
    while (true) {
      _95 = (_93 << 6) + _56;
      do {
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
        do {
          if (!(_116 == _89)) {
            _93 = _116;
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
    do {
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
        _175 = saturate(_156.y);
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
        _201 = _197 * _199;
        _202 = _199 * _188;
        _204 = rsqrt(dot(float3(_200, _201, _202), float3(_200, _201, _202)));
        _205 = _204 * _200;
        _206 = -0.0f - _205;
        _207 = _204 * _201;
        _208 = -0.0f - _207;
        _209 = _204 * _202;
        _210 = -0.0f - _209;
        _218 = _173 * 0.07999999821186066f;
        _224 = min(1.0f, max(saturate(_156.x), 0.019999999552965164f));
        _232 = uint((saturate(_162.y) * 255.0f) + 0.5f);
        _235 = ((float)((uint)((uint)((uint)(_232) >> 1)))) * 0.007874015718698502f;
        _243 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _121.x) - cbSharedPerViewData.vViewRemap.y);
        _244 = _243 * _138;
        _245 = _243 * _139;
        _246 = -0.0f - _243;
        _252 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
        _256 = srvReflectionsWeight.Load(int3(((uint)(_67) >> _252), ((uint)(_68) >> _252), 0));
        _262 = ((float)((uint)((uint)(_256.x & 254)))) * 0.003921568859368563f;
        do {
          _280 = 1.0f;
          _281 = 0.0f;
          _282 = 0.0f;
          _283 = 0.0f;
          if ((_256.x & 1) == 0) {
            _271 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _129), (cbSharedPerViewData.vViewportSize.y * _130)), 0.0f);
            _280 = (1.0f - _262);
            _281 = (_271.x * _262);
            _282 = (_271.y * _262);
            _283 = (_271.z * _262);
          }
          _292 = cbSharedPerViewData.vViewportSize.x * (_129 + 0.5f);
          _293 = cbSharedPerViewData.vViewportSize.y * (_130 + 0.5f);
          do {
            _373 = _292;
            _374 = _293;
            if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
              _308 = (floor((_292 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
              _309 = (floor((_293 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
              _312 = max(_308, cbDeferredShading.vScreenPixelSize.z);
              _313 = max(_309, cbDeferredShading.vScreenPixelSize.w);
              _316 = min((_308 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
              _317 = min((_309 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
              _322 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_312 + cbDeferredShading.vScreenPixelSize.z), (_313 + cbDeferredShading.vScreenPixelSize.w)));
              if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _322.x) - cbSharedPerViewData.vViewRemap.y)) - _243) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _322.y) - cbSharedPerViewData.vViewRemap.y)) - _243) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _322.z) - cbSharedPerViewData.vViewRemap.y)) - _243) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _322.w) - cbSharedPerViewData.vViewRemap.y)) - _243) > 0.029999999329447746f)) {
                _356 = abs(_121.x - _322.w);
                _358 = abs(_121.x - _322.z);
                _359 = (_358 < _356);
                _361 = select(_359, _358, _356);
                _363 = abs(_121.x - _322.x);
                _364 = (_363 < _361);
                if (abs(_121.x - _322.y) < select(_364, _363, _361)) {
                  _373 = _316;
                  _374 = _317;
                } else {
                  _373 = select(_364, _312, select(_359, _316, _312));
                  _374 = select(_364, _317, _313);
                }
              } else {
                _373 = _292;
                _374 = _293;
              }
            }
            _377 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_373, _374), 0.0f);
            _381 = _377.x - _377.z;
            _393 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_377.y + _381)), 0.0f);
            _394 = -0.0f - _393;
            _395 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_377.x + _377.z)), 0.0f);
            _396 = -0.0f - _395;
            _397 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_381 - _377.y)), 0.0f);
            _398 = -0.0f - _397;
            _401 = (cbSharedPerViewData.nSSGIEnabled == 0);
            do {
              _412 = 1.0f;
              if (!(_401)) {
                if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
                  _412 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_373, _374), 0.0f)).x);
                } else {
                  _412 = 1.0f;
                }
              }
              do {
                _450 = 0;
                _451 = 0.0f;
                _452 = 0.0f;
                _453 = 0.0f;
                if (!(_401)) {
                  _415 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
                  _416 = (int)(uint)(_415);
                  if (_415) {
                    _419 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_373, _374), 0.0f);
                    _424 = (_419.x * 2.0f) + -1.0f;
                    _425 = (_419.y * 2.0f) + -1.0f;
                    _429 = (1.0f - abs(_424)) - abs(_425);
                    _431 = saturate(-0.0f - _429);
                    _432 = -0.0f - _431;
                    _437 = select((_424 >= 0.0f), _432, _431) + _424;
                    _438 = select((_425 >= 0.0f), _432, _431) + _425;
                    _440 = rsqrt(dot(float3(_437, _438, _429), float3(_437, _438, _429)));
                    _441 = _437 * _440;
                    _442 = _438 * _440;
                    _443 = _440 * _429;
                    _445 = rsqrt(dot(float3(_441, _442, _443), float3(_441, _442, _443)));
                    _450 = _416;
                    _451 = (_441 * _445);
                    _452 = (_442 * _445);
                    _453 = (_445 * _443);
                  } else {
                    _450 = _416;
                    _451 = 0.0f;
                    _452 = 0.0f;
                    _453 = 0.0f;
                  }
                }
                _454 = -0.0f - _138;
                _455 = -0.0f - _139;
                _457 = rsqrt(dot(float3(_454, _455, 1.0f), float3(_454, _455, 1.0f)));
                _458 = _457 * _454;
                _459 = _457 * _455;
                _467 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _68) + _67))];
                _468 = _467 & 255;
                _469 = (uint)(_467) >> 8;
                _470 = _469 & 255;
                _474 = ((float)((uint)((uint)(((uint)(_467) >> 16) & 255)))) * 0.003921568859368563f;
                _476 = (float)((uint)((uint)((uint)(_467) >> 24)));
                _477 = _476 * 0.003921568859368563f;
                do {
                  _1094 = 0.0f;
                  _1095 = 0.0f;
                  _1096 = 0.0f;
                  _1097 = 0.0f;
                  _1098 = 0.0f;
                  _1099 = 0.0f;
                  _1100 = _224;
                  [branch]
                  if (!((((int)(uint((saturate(_146.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
                    _487 = _224 + 0.4000000059604645f;
                    _488 = _487 * 4.0f;
                    _493 = dot(float3((-0.0f - _458), (-0.0f - _459), (-0.0f - _457)), float3(_205, _207, _209)) * 2.0f;
                    _497 = _487 * _487;
                    _498 = 1.0f - _497;
                    _501 = (sqrt(_498) + _497) * _498;
                    _511 = (_501 * ((_206 - _458) - (_493 * _205))) + _205;
                    _512 = (_501 * ((_208 - _459) - (_493 * _207))) + _207;
                    _513 = (_501 * ((_210 - _457) - (_493 * _209))) + _209;
                    _517 = saturate(1.0f - ((_224 + 0.09999999403953552f) * 3.3333332538604736f));
                    _532 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _513, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _512, (_511 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
                    _535 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _513, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _512, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _511)));
                    _538 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _513, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _512, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _511)));
                    _541 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _207, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _205)));
                    _544 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _207, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _205)));
                    _547 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _207, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _205)));
                    do {
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
                      _886 = 0.0f;
                      _887 = 0.0f;
                      _888 = 0.0f;
                      _889 = 0.0f;
                      if (!(_global_0 == 0)) {
                        _566 = 0;
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
                        _577 = 0.0f;
                        _578 = 0.0f;
                        _579 = 0.0f;
                        _580 = 0.0f;
                        bool _loop_break_1 = false;
                        while (true) {
                          _583 = _global_5[min((uint)(_566), 63u)];
                          _584 = _global_6[min((uint)(_566), 63u)];
                          _587 = asfloat(srvLightInfoProperties.Load4(_584)).x;
                          _588 = asfloat(srvLightInfoProperties.Load4(_584)).y;
                          _589 = asfloat(srvLightInfoProperties.Load4(_584)).z;
                          _590 = asfloat(srvLightInfoProperties.Load4(_584)).w;
                          _593 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 16u)))).x;
                          _594 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 16u)))).y;
                          _595 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 16u)))).z;
                          _596 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 16u)))).w;
                          _599 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 32u)))).x;
                          _600 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 32u)))).y;
                          _601 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 32u)))).z;
                          _602 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 32u)))).w;
                          _605 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 48u)))).x;
                          _606 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 48u)))).y;
                          _607 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 48u)))).z;
                          _608 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 48u)))).w;
                          _611 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 64u)))).x;
                          _612 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 64u)))).y;
                          _613 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 64u)))).z;
                          _614 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 64u)))).w;
                          _617 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 80u)))).x;
                          _618 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 80u)))).y;
                          _619 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 80u)))).z;
                          _620 = asfloat(srvLightInfoProperties.Load4(((int)(_584 + 80u)))).w;
                          _623 = asint(srvLightInfoProperties.Load(((int)(_584 + 96u))));
                          _626 = asfloat(srvLightInfoProperties.Load3(((int)(_584 + 100u)))).x;
                          _627 = asfloat(srvLightInfoProperties.Load3(((int)(_584 + 100u)))).y;
                          _628 = asfloat(srvLightInfoProperties.Load3(((int)(_584 + 100u)))).z;
                          _631 = asfloat(srvLightInfoProperties.Load3(((int)(_584 + 112u)))).x;
                          _632 = asfloat(srvLightInfoProperties.Load3(((int)(_584 + 112u)))).y;
                          _633 = asfloat(srvLightInfoProperties.Load3(((int)(_584 + 112u)))).z;
                          _636 = asint(srvLightInfoProperties.Load(((int)(_584 + 124u))));
                          _639 = asint(srvLightInfoProperties.Load(((int)(_584 + 128u))));
                          _642 = _623 & 65535;
                          _671 = ((saturate(1.0f - abs(mad(_589, _246, mad(_588, _245, (_587 * _244))) + _590)) * f16tof32(((uint)((uint)(_623) >> 16)))) * saturate(1.0f - abs(mad(_595, _246, mad(_594, _245, (_593 * _244))) + _596))) * saturate(1.0f - abs(mad(_601, _246, mad(_600, _245, (_599 * _244))) + _602));
                          do {
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
                            _868 = _577;
                            _869 = _578;
                            _870 = _579;
                            _871 = _580;
                            [branch]
                            if (_671 > 0.0f) {
                              _674 = _671 * _671;
                              do {
                                _695 = 0.0f;
                                _696 = 0.0f;
                                _697 = 0.0f;
                                [branch]
                                if (_517 < 1.0f) {
                                  _677 = (float)((uint)_642);
                                  _678 = -0.0f - _532;
                                  [branch]
                                  if (!(!(_677 >= 341.0f))) {
                                    _684 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_678, _535, _538, (_677 + -341.0f)), _488);
                                    _695 = _684.x;
                                    _696 = _684.y;
                                    _697 = _684.z;
                                  } else {
                                    _690 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_678, _535, _538, _677), _488);
                                    _695 = _690.x;
                                    _696 = _690.y;
                                    _697 = _690.z;
                                  }
                                }
                                _699 = (float)((uint)_642);
                                do {
                                  _784 = 0.0f;
                                  _785 = 0.0f;
                                  _786 = 0.0f;
                                  [branch]
                                  if (_517 > 0.0f) {
                                    _703 = mad(_607, _513, mad(_606, _512, (_605 * _511)));
                                    _706 = mad(_613, _513, mad(_612, _512, (_611 * _511)));
                                    _709 = mad(_619, _513, mad(_618, _512, (_617 * _511)));
                                    _750 = min(((((float((int)(((int)(uint)((int)(_703 > 0.0f))) - ((int)(uint)((int)(_703 < 0.0f))))) * _626) - _608) - mad(_607, _246, mad(_606, _245, (_605 * _244)))) / _703), min(((((float((int)(((int)(uint)((int)(_706 > 0.0f))) - ((int)(uint)((int)(_706 < 0.0f))))) * _627) - _614) - mad(_613, _246, mad(_612, _245, (_611 * _244)))) / _706), ((((float((int)(((int)(uint)((int)(_709 > 0.0f))) - ((int)(uint)((int)(_709 < 0.0f))))) * _628) - _620) - mad(_619, _246, mad(_618, _245, (_617 * _244)))) / _709)));
                                    _755 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _246, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _245, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _244))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _631) + (_750 * _532);
                                    _757 = ((mad((cbSharedPerViewData.mViewToWorld[0][1].z), _246, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _245, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _244))) + (cbSharedPerViewData.mViewToWorld[0][1].w)) - _632) + (_750 * _535);
                                    _759 = ((mad((cbSharedPerViewData.mViewToWorld[0][2].z), _246, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _245, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _244))) + (cbSharedPerViewData.mViewToWorld[0][2].w)) - _633) + (_750 * _538);
                                    _766 = (max(log2((_750 * _750) / dot(float3(_755, _757, _759), float3(_755, _757, _759))), -1.0f) * 0.3333333432674408f) + _488;
                                    _767 = -0.0f - _755;
                                    [branch]
                                    if (!(!(_699 >= 341.0f))) {
                                      _773 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_767, _757, _759, (_699 + -341.0f)), _766);
                                      _784 = _773.x;
                                      _785 = _773.y;
                                      _786 = _773.z;
                                    } else {
                                      _779 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_767, _757, _759, _699), _766);
                                      _784 = _779.x;
                                      _785 = _779.y;
                                      _786 = _779.z;
                                    }
                                  }
                                  _787 = -0.0f - _541;
                                  do {
                                    [branch]
                                    if (!(!(_699 >= 341.0f))) {
                                      _793 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_787, _544, _547, (_699 + -341.0f)), 0.0f);
                                      _804 = _793.x;
                                      _805 = _793.y;
                                      _806 = _793.z;
                                    } else {
                                      _799 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_787, _544, _547, _699), 0.0f);
                                      _804 = _799.x;
                                      _805 = _799.y;
                                      _806 = _799.z;
                                    }
                                    _816 = _674 * f16tof32(((uint)((uint)(_636) >> 16)));
                                    _817 = _816 * _804;
                                    _818 = _674 * f16tof32(_636);
                                    _819 = _818 * _805;
                                    _820 = _674 * f16tof32(((uint)((uint)(_639) >> 16)));
                                    _821 = _820 * _806;
                                    _822 = _816 * (lerp(_695, _784, _517));
                                    _823 = _818 * (lerp(_696, _785, _517));
                                    _824 = _820 * (lerp(_697, _786, _517));
                                    do {
                                      _838 = _567;
                                      _839 = _568;
                                      _840 = _569;
                                      _841 = _570;
                                      _842 = _571;
                                      _843 = _572;
                                      _844 = _573;
                                      [branch]
                                      if (!((_583 & ((int)(1 << (_467 & 31)))) == 0)) {
                                        _838 = (_817 + _567);
                                        _839 = (_819 + _568);
                                        _840 = (_821 + _569);
                                        _841 = (_822 + _570);
                                        _842 = (_823 + _571);
                                        _843 = (_824 + _572);
                                        _844 = (_674 + _573);
                                      }
                                      [branch]
                                      if (!((_583 & ((int)(1 << (_469 & 31)))) == 0)) {
                                        _858 = _838;
                                        _859 = _839;
                                        _860 = _840;
                                        _861 = _841;
                                        _862 = _842;
                                        _863 = _843;
                                        _864 = _844;
                                        _865 = (_817 + _574);
                                        _866 = (_819 + _575);
                                        _867 = (_821 + _576);
                                        _868 = (_822 + _577);
                                        _869 = (_823 + _578);
                                        _870 = (_824 + _579);
                                        _871 = (_674 + _580);
                                      } else {
                                        _858 = _838;
                                        _859 = _839;
                                        _860 = _840;
                                        _861 = _841;
                                        _862 = _842;
                                        _863 = _843;
                                        _864 = _844;
                                        _865 = _574;
                                        _866 = _575;
                                        _867 = _576;
                                        _868 = _577;
                                        _869 = _578;
                                        _870 = _579;
                                        _871 = _580;
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
                            _872 = _566 + 1u;
                            do {
                              if (!(_872 == _global_0)) {
                                _566 = _872;
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
                                _577 = _868;
                                _578 = _869;
                                _579 = _870;
                                _580 = _871;
                                _loop_break_1 = true;
                                break;
                              }
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
                              _886 = _868;
                              _887 = _869;
                              _888 = _870;
                              _889 = _871;
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
                      _895 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_467 & 31)))) != 0);
                      do {
                        _1001 = 0.0f;
                        _1002 = 0.0f;
                        _1003 = 0.0f;
                        _1004 = 0.0f;
                        _1005 = 0.0f;
                        _1006 = 0.0f;
                        if ((_474 > 0.0f) || ((_477 > 0.0f) || _895)) {
                          _905 = srvFallbackInfo[((_468 << 2) | 3)].x;
                          _907 = select(_895, 9.999999747378752e-05f, (_476 * 3.921568847431445e-09f));
                          _908 = _882 * 0.20000000298023224f;
                          _915 = saturate((_907 - _908) / (((_882 * 0.4000000059604645f) + 9.99999993922529e-09f) - _908)) * _907;
                          do {
                            _981 = _882;
                            _982 = _879;
                            _983 = _880;
                            _984 = _881;
                            _985 = _876;
                            _986 = _877;
                            _987 = _878;
                            [branch]
                            if (_915 > 0.0f) {
                              do {
                                _973 = _879;
                                _974 = _880;
                                _975 = _881;
                                _976 = _876;
                                _977 = _877;
                                _978 = _878;
                                [branch]
                                if ((int)_905 > (int)-1) {
                                  _920 = float((int)(_905));
                                  _921 = -0.0f - _532;
                                  _922 = !(_920 >= 341.0f);
                                  do {
                                    [branch]
                                    if (!(_922)) {
                                      _927 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_921, _535, _538, (_920 + -341.0f)), _488);
                                      _938 = _927.x;
                                      _939 = _927.y;
                                      _940 = _927.z;
                                    } else {
                                      _933 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_921, _535, _538, _920), _488);
                                      _938 = _933.x;
                                      _939 = _933.y;
                                      _940 = _933.z;
                                    }
                                    _944 = -0.0f - _541;
                                    do {
                                      [branch]
                                      if (!(_922)) {
                                        _949 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_944, _544, _547, (_920 + -341.0f)), 0.0f);
                                        _960 = _949.x;
                                        _961 = _949.y;
                                        _962 = _949.z;
                                      } else {
                                        _955 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_944, _544, _547, _920), 0.0f);
                                        _960 = _955.x;
                                        _961 = _955.y;
                                        _962 = _955.z;
                                      }
                                      _973 = ((_938 * _915) + _879);
                                      _974 = ((_939 * _915) + _880);
                                      _975 = ((_940 * _915) + _881);
                                      _976 = ((_960 * _915) + _876);
                                      _977 = ((_961 * _915) + _877);
                                      _978 = ((_962 * _915) + _878);
                                    } while (false);
                                  } while (false);
                                }
                                _981 = (_915 + _882);
                                _982 = _973;
                                _983 = _974;
                                _984 = _975;
                                _985 = _976;
                                _986 = _977;
                                _987 = _978;
                              } while (false);
                            }
                            if (_981 > 0.0f) {
                              _993 = (cbSharedPerViewData.vHDRScale.x * _474) / _981;
                              _1001 = (_993 * _985);
                              _1002 = (_993 * _986);
                              _1003 = (_993 * _987);
                              _1004 = (_993 * _982);
                              _1005 = (_993 * _983);
                              _1006 = (_993 * _984);
                            } else {
                              _1001 = 0.0f;
                              _1002 = 0.0f;
                              _1003 = 0.0f;
                              _1004 = 0.0f;
                              _1005 = 0.0f;
                              _1006 = 0.0f;
                            }
                          } while (false);
                        }
                        [branch]
                        if (!(_477 == 0.0f)) {
                          _1013 = srvFallbackInfo[((_470 << 2) | 3)].x;
                          _1014 = _476 * 3.921568847431445e-09f;
                          do {
                            _1070 = _886;
                            _1071 = _887;
                            _1072 = _888;
                            _1073 = _883;
                            _1074 = _884;
                            _1075 = _885;
                            [branch]
                            if ((int)_1013 > (int)-1) {
                              _1017 = float((int)(_1013));
                              _1018 = -0.0f - _532;
                              _1019 = !(_1017 >= 341.0f);
                              do {
                                [branch]
                                if (!(_1019)) {
                                  _1024 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1018, _535, _538, (_1017 + -341.0f)), _488);
                                  _1035 = _1024.x;
                                  _1036 = _1024.y;
                                  _1037 = _1024.z;
                                } else {
                                  _1030 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1018, _535, _538, _1017), _488);
                                  _1035 = _1030.x;
                                  _1036 = _1030.y;
                                  _1037 = _1030.z;
                                }
                                _1041 = -0.0f - _541;
                                do {
                                  [branch]
                                  if (!(_1019)) {
                                    _1046 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1041, _544, _547, (_1017 + -341.0f)), 0.0f);
                                    _1057 = _1046.x;
                                    _1058 = _1046.y;
                                    _1059 = _1046.z;
                                  } else {
                                    _1052 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1041, _544, _547, _1017), 0.0f);
                                    _1057 = _1052.x;
                                    _1058 = _1052.y;
                                    _1059 = _1052.z;
                                  }
                                  _1070 = ((_1035 * _1014) + _886);
                                  _1071 = ((_1036 * _1014) + _887);
                                  _1072 = ((_1037 * _1014) + _888);
                                  _1073 = ((_1057 * _1014) + _883);
                                  _1074 = ((_1058 * _1014) + _884);
                                  _1075 = ((_1059 * _1014) + _885);
                                } while (false);
                              } while (false);
                            }
                            _1080 = (cbSharedPerViewData.vHDRScale.x * _477) / (_889 + _1014);
                            _1094 = ((_1080 * _1073) + _1001);
                            _1095 = ((_1080 * _1074) + _1002);
                            _1096 = ((_1080 * _1075) + _1003);
                            _1097 = ((_1080 * _1070) + _1004);
                            _1098 = ((_1080 * _1071) + _1005);
                            _1099 = ((_1080 * _1072) + _1006);
                            _1100 = _487;
                          } while (false);
                        } else {
                          _1094 = _1001;
                          _1095 = _1002;
                          _1096 = _1003;
                          _1097 = _1004;
                          _1098 = _1005;
                          _1099 = _1006;
                          _1100 = _487;
                        }
                      } while (false);
                    } while (false);
                  }
                  do {
                    _1119 = _1097;
                    _1120 = _1098;
                    _1121 = _1099;
                    [branch]
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
                      _1119 = (min((_394 / max(9.999999747378752e-05f, _1094)), 1.0f) * _1097);
                      _1120 = (min((_396 / max(9.999999747378752e-05f, _1095)), 1.0f) * _1098);
                      _1121 = (min((_398 / max(9.999999747378752e-05f, _1096)), 1.0f) * _1099);
                    }
                    _1134 = saturate(dot(float3(_458, _459, _457), float3(_205, _207, _209)));
                    _1137 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1134, _1100), 0.0f);
                    _1140 = _1137.x + _1137.y;
                    _1145 = (((1.0f - _1140) * _218) / max(9.999999747378752e-06f, _1140)) + 1.0f;
                    _1147 = (_1137.x * _218) + _1137.y;
                    _1148 = min(((_235 * _235) * select((cbSharedPerViewData.nPathTracingIsEnabled != 0), 1.0f, (_175 * _175))), _412);
                    do {
                      _1276 = _1148;
                      if (!(_global_1 == 0)) {
                        _1152 = 0;
                        _1153 = _1148;
                        bool _loop_break_2 = false;
                        while (true) {
                          _1154 = _1152 + (uint)(_global_0);
                          _1157 = _global_5[min((uint)(_1154), 63u)];
                          _1158 = _global_6[min((uint)(_1154), 63u)];
                          _1162 = (int)((int)(_1157 << (((int)(31u - _467)) & 31))) >> 31;
                          _1166 = (int)((int)(_1157 << ((31 - _469) & 31))) >> 31;
                          _1178 = saturate((asfloat((_1162 & asint(_474))) + asfloat((_1166 & asint(_477)))) + asfloat(((_1166 & 1065353216) & _1162)));
                          do {
                            _1271 = _1153;
                            [branch]
                            if (!(_1178 == 0.0f)) {
                              _1183 = asfloat(srvLightInfoProperties.Load4(_1158)).x;
                              _1184 = asfloat(srvLightInfoProperties.Load4(_1158)).y;
                              _1185 = asfloat(srvLightInfoProperties.Load4(_1158)).z;
                              _1186 = asfloat(srvLightInfoProperties.Load4(_1158)).w;
                              _1189 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 16u)))).x;
                              _1190 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 16u)))).y;
                              _1191 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 16u)))).z;
                              _1192 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 16u)))).w;
                              _1195 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 32u)))).x;
                              _1196 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 32u)))).y;
                              _1197 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 32u)))).z;
                              _1198 = asfloat(srvLightInfoProperties.Load4(((int)(_1158 + 32u)))).w;
                              _1201 = asint(srvLightInfoProperties.Load(((int)(_1158 + 48u))));
                              _1204 = asint(srvLightInfoProperties.Load(((int)(_1158 + 52u))));
                              _1207 = asint(srvLightInfoProperties.Load(((int)(_1158 + 56u))));
                              _1210 = asint(srvLightInfoProperties.Load(((int)(_1158 + 60u))));
                              _1225 = mad(_1185, _246, mad(_1184, _245, (_1183 * _244))) + _1186;
                              _1229 = mad(_1191, _246, mad(_1190, _245, (_1189 * _244))) + _1192;
                              _1233 = mad(_1197, _246, mad(_1196, _245, (_1195 * _244))) + _1198;
                              _1258 = saturate(1.0f - ((_1225 + 1.0f) * f16tof32(_1204))) + saturate(1.0f - ((1.0f - _1225) * f16tof32(((uint)((uint)(_1204) >> 16)))));
                              _1259 = saturate(1.0f - ((_1229 + 1.0f) * f16tof32(_1207))) + saturate(1.0f - ((1.0f - _1229) * f16tof32(((uint)((uint)(_1207) >> 16)))));
                              _1260 = saturate(1.0f - ((_1233 + 1.0f) * f16tof32(_1210))) + saturate(1.0f - ((1.0f - _1233) * f16tof32(((uint)((uint)(_1210) >> 16)))));
                              _1263 = saturate(1.0f - dot(float3(_1258, _1259, _1260), float3(_1258, _1259, _1260)));
                              _1271 = (saturate(1.0f - ((_1263 * _1263) * (f16tof32(((uint)((uint)(_1201) >> 16))) * _1178))) * _1153);
                            }
                            _1272 = _1152 + 1u;
                            do {
                              if (!(_1272 == _global_1)) {
                                _1152 = _1272;
                                _1153 = _1271;
                                _loop_break_2 = true;
                                break;
                              }
                              _1276 = _1271;
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
                      _1280 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
                      do {
                        _1292 = _1276;
                        if (_1280) {
                          _1292 = saturate((_1276 + -1.0f) + exp2((_1100 * _1100) * log2(max((_1276 + _1134), 0.0f))));
                        }
                        _1295 = max(9.999999747378752e-06f, max(_170, max(_168, _169)));
                        do {
                          _1367 = _1292;
                          if (!(_450 == 0)) {
                            _1313 = rsqrt(dot(float3(_451, _452, _453), float3(_451, _452, _453)));
                            _1315 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                            _1316 = _1315 * _205;
                            _1317 = _1315 * _207;
                            _1318 = _1315 * _209;
                            if (_1280) {
                              _1323 = max(_1100, 0.10000000149011612f);
                              _1324 = -0.0f - _458;
                              _1325 = -0.0f - _459;
                              _1326 = -0.0f - _457;
                              _1328 = dot(float3(_1324, _1325, _1326), float3(_1316, _1317, _1318)) * 2.0f;
                              _1337 = min(max(dot(float3((_1313 * _451), (_1313 * _452), (_1313 * _453)), float3((_1324 - (_1328 * _1316)), (_1325 - (_1328 * _1317)), (_1326 - (_1328 * _1318)))), -1.0f), 1.0f);
                              _1338 = abs(_1337);
                              _1343 = (1.5707963705062866f - (_1338 * 0.1565829962491989f)) * sqrt(1.0f - _1338);
                              _1349 = abs((_1323 - _1276) * 3.1415927410125732f);
                              _1357 = saturate(1.0f - saturate((select((_1337 >= 0.0f), _1343, (3.1415927410125732f - _1343)) - _1349) / (((_1323 + _1276) * 3.1415927410125732f) - _1349)));
                              _1367 = (((_1357 * _1357) * saturate((_1276 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1357 * 2.0f)));
                            } else {
                              _1367 = _1276;
                            }
                          }
                          _1371 = (((_1145 * ((cbSharedPerViewData.vHDRScale.x * _281) + (_1119 * _280))) * _1147) * (((saturate(_168 / _1295) + -1.0f) * 0.5f) + 1.0f)) * _1367;
                          _1375 = (((_1147 * ((cbSharedPerViewData.vHDRScale.x * _282) + (_1120 * _280))) * _1145) * (((saturate(_169 / _1295) + -1.0f) * 0.5f) + 1.0f)) * _1367;
                          _1379 = (((_1147 * ((cbSharedPerViewData.vHDRScale.x * _283) + (_1121 * _280))) * _1145) * (((saturate(_170 / _1295) + -1.0f) * 0.5f) + 1.0f)) * _1367;
                          do {
                            _1386 = 1.0f;
                            [branch]
                            if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
                              _1386 = _1276;
                            }
                            do {
                              _1439 = _394;
                              _1440 = _396;
                              _1441 = _398;
                              if (_474 > 0.0f) {
                                _1389 = _468 * 3;
                                _1392 = srvRoomInfo[_1389].x;
                                _1393 = srvRoomInfo[_1389].y;
                                _1394 = srvRoomInfo[_1389].z;
                                _1400 = srvRoomInfo[(_1389 + 1)].x;
                                _1401 = srvRoomInfo[(_1389 + 1)].y;
                                _1402 = srvRoomInfo[(_1389 + 1)].z;
                                _1408 = srvRoomInfo[(_1389 + 2)].x;
                                _1409 = srvRoomInfo[(_1389 + 2)].y;
                                _1410 = srvRoomInfo[(_1389 + 2)].z;
                                _1416 = saturate(dot(float3(_205, _207, _209), float3(asfloat(_1392), asfloat(_1393), asfloat(_1394))) + 0.5f);
                                _1420 = (_1416 * _1416) * (3.0f - (_1416 * 2.0f));
                                _1424 = 1.0f - _1420;
                                _1431 = _1386 * _474;
                                _1439 = ((_1431 * ((_1424 * asfloat(_1408)) + (_1420 * asfloat(_1400)))) - _393);
                                _1440 = ((_1431 * ((_1424 * asfloat(_1409)) + (_1420 * asfloat(_1401)))) - _395);
                                _1441 = ((_1431 * ((_1424 * asfloat(_1410)) + (_1420 * asfloat(_1402)))) - _397);
                              }
                              do {
                                _1494 = _1439;
                                _1495 = _1440;
                                _1496 = _1441;
                                if (_477 > 0.0f) {
                                  _1444 = _470 * 3;
                                  _1447 = srvRoomInfo[_1444].x;
                                  _1448 = srvRoomInfo[_1444].y;
                                  _1449 = srvRoomInfo[_1444].z;
                                  _1455 = srvRoomInfo[(_1444 + 1)].x;
                                  _1456 = srvRoomInfo[(_1444 + 1)].y;
                                  _1457 = srvRoomInfo[(_1444 + 1)].z;
                                  _1463 = srvRoomInfo[(_1444 + 2)].x;
                                  _1464 = srvRoomInfo[(_1444 + 2)].y;
                                  _1465 = srvRoomInfo[(_1444 + 2)].z;
                                  _1471 = saturate(dot(float3(_205, _207, _209), float3(asfloat(_1447), asfloat(_1448), asfloat(_1449))) + 0.5f);
                                  _1475 = (_1471 * _1471) * (3.0f - (_1471 * 2.0f));
                                  _1479 = 1.0f - _1475;
                                  _1486 = _1386 * _477;
                                  _1494 = ((_1486 * ((_1479 * asfloat(_1463)) + (_1475 * asfloat(_1455)))) + _1439);
                                  _1495 = ((_1486 * ((_1479 * asfloat(_1464)) + (_1475 * asfloat(_1456)))) + _1440);
                                  _1496 = ((_1486 * ((_1479 * asfloat(_1465)) + (_1475 * asfloat(_1457)))) + _1441);
                                }
                                do {
                                  _1606 = 0.0f;
                                  if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
                                    _1519 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _246, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _245, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _244))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
                                    _1523 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _246, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _245, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _244))) + (cbSharedPerViewData.mViewToWorld[0][1].w);
                                    _1527 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _246, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _245, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _244))) + (cbSharedPerViewData.mViewToWorld[0][2].w);
                                    _1546 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1527, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1523, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1519))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
                                    _1550 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1527, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1523, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1519))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
                                    _1554 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1527, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1523, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1519))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
                                    _1567 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
                                    _1568 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
                                    _1569 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
                                    _1606 = min(min(saturate((_1546 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1567), 9.999999747378752e-06f)), saturate((1.0f - _1546) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1567), 9.999999747378752e-06f))), min(min(saturate((_1550 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1568), 9.999999747378752e-06f)), saturate((1.0f - _1550) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1568), 9.999999747378752e-06f))), min(saturate((_1554 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1569), 9.999999747378752e-06f)), saturate((1.0f - _1554) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1569), 9.999999747378752e-06f)))));
                                  }
                                  _1607 = (uint)(_global_1) + (uint)(_global_0);
                                  do {
                                    _9594 = _1494;
                                    _9595 = _1495;
                                    _9596 = _1496;
                                    _9597 = _1371;
                                    _9598 = _1375;
                                    _9599 = _1379;
                                    if ((uint)_1607 < (uint)_global_2) {
                                      _1611 = _1494;
                                      _1612 = _1495;
                                      _1613 = _1496;
                                      _1614 = _1371;
                                      _1615 = _1375;
                                      _1616 = _1379;
                                      _1617 = _1607;
                                      bool _loop_break_3 = false;
                                      while (true) {
                                        _1619 = _global_3[min((uint)(_1617), 63u)];
                                        _1623 = _global_4[min((uint)(_1617), 63u)];
                                        _1624 = _global_5[min((uint)(_1617), 63u)];
                                        _1625 = _global_6[min((uint)(_1617), 63u)];
                                        _1626 = _1619 & 4095;
                                        do {
                                          _9584 = _1611;
                                          _9585 = _1612;
                                          _9586 = _1613;
                                          _9587 = _1614;
                                          _9588 = _1615;
                                          _9589 = _1616;
                                          [branch]
                                          if (((((int)(uint(saturate(_156.w) * 255.0f)) & 64) != 0) || ((_1623 & 8388608) == 0)) && (((int)(uint((saturate(_156.z) * 1.9921875f) + 0.003921568859368563f)) != 0) || ((_1623 & 16777216) == 0))) {
                                            _1638 = (int)((int)(_1624 << (((int)(31u - _467)) & 31))) >> 31;
                                            _1642 = (int)((int)(_1624 << ((31 - _469) & 31))) >> 31;
                                            _1654 = saturate((asfloat((_1638 & asint(_474))) + asfloat((_1642 & asint(_477)))) + asfloat(((_1642 & 1065353216) & _1638)));
                                            [branch]
                                            if (!(_1654 == 0.0f)) {
                                              _1657 = (uint)(_1619) >> 12;
                                              if (_1657 == 6) {
                                                do {
                                                  _3395 = _1654;
                                                  if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                                                    _3395 = (_1654 * select(((_1623 & 67108864) != 0), 1.0f, (1.0f - _1606)));
                                                  }
                                                  _3398 = asfloat(srvLightInfoProperties.Load4(_1625)).x;
                                                  _3399 = asfloat(srvLightInfoProperties.Load4(_1625)).y;
                                                  _3400 = asfloat(srvLightInfoProperties.Load4(_1625)).z;
                                                  _3401 = asfloat(srvLightInfoProperties.Load4(_1625)).w;
                                                  _3404 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).x;
                                                  _3405 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).y;
                                                  _3406 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).z;
                                                  _3407 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).w;
                                                  _3410 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).x;
                                                  _3411 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).y;
                                                  _3412 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).z;
                                                  _3415 = asint(srvLightInfoProperties.Load(((int)(_1625 + 68u))));
                                                  _3418 = asint(srvLightInfoProperties.Load(((int)(_1625 + 76u))));
                                                  _3421 = asint(srvLightInfoProperties.Load(((int)(_1625 + 84u))));
                                                  _3424 = asint(srvLightInfoProperties.Load(((int)(_1625 + 88u))));
                                                  _3427 = asint(srvLightInfoProperties.Load(((int)(_1625 + 92u))));
                                                  _3431 = ((float)((uint)((uint)(((uint)(_3415) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _3432 = (uint)(_3418) >> 16;
                                                  _3452 = srvDeferredShadingPass_DeferredShadows.Load(int3(_67, _68, 0));
                                                  [branch]
                                                  if (!(_3452.x == 0.0f)) {
                                                    do {
                                                      _3477 = cbSharedPerViewData.vAttenuatedSunColor.x;
                                                      _3478 = cbSharedPerViewData.vAttenuatedSunColor.y;
                                                      _3479 = cbSharedPerViewData.vAttenuatedSunColor.z;
                                                      [branch]
                                                      if (!(_3432 == 0)) {
                                                        Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3432)))];
                                                        _3469 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3400, _246, mad(_3399, _245, (_3398 * _244))) + _3401) * f16tof32(((uint)((uint)(_3424) >> 16)))) + f16tof32(((uint)((uint)(_3427) >> 16)))), (((mad(_3406, _246, mad(_3405, _245, (_3404 * _244))) + _3407) * f16tof32(_3424)) + f16tof32(_3427))), 0.0f);
                                                        _3477 = (_3469.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                                                        _3478 = (_3469.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                                                        _3479 = (_3469.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                                                      }
                                                      _3482 = min(_3452.x, _3452.y) * _3395;
                                                      [branch]
                                                      if (_3482 > 0.0f) {
                                                        _3486 = rsqrt(dot(float3(_3410, _3411, _3412), float3(_3410, _3411, _3412)));
                                                        _3487 = _3486 * _3410;
                                                        _3488 = _3486 * _3411;
                                                        _3489 = _3486 * _3412;
                                                        _3490 = dot(float3(_205, _207, _209), float3(_3487, _3488, _3489));
                                                        _3491 = saturate(_3490);
                                                        _3494 = uint((_180 * 255.0f) + 0.5f);
                                                        _3503 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                        _3504 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                        _3505 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                        _3521 = ((dot(float3(_206, _208, _210), float3(_3487, _3488, _3489)) + dot(float3((-0.0f - _458), (-0.0f - _459), (-0.0f - _457)), float3(_3487, _3488, _3489))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_3494) >> 2)))) * 0.1666666716337204f)));
                                                        _3528 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                        _3531 = saturate((_3528 + -0.009999999776482582f) * -100.0f);
                                                        _3536 = ((_3531 * _3531) * 3.0f) * (3.0f - (_3531 * 2.0f));
                                                        _3543 = 10.0f - (exp2(log2(saturate(_3528 * 5.0f)) * 3.0f) * 9.0f);
                                                        _3544 = saturate(_3491 + _3503) * _3491;
                                                        _3545 = saturate(_3491 + _3504) * _3491;
                                                        _3546 = saturate(_3491 + _3505) * _3491;
                                                        _3568 = _3487 + _458;
                                                        _3569 = _3488 + _459;
                                                        _3570 = _3489 + _457;
                                                        _3572 = rsqrt(dot(float3(_3568, _3569, _3570), float3(_3568, _3569, _3570)));
                                                        do {
                                                          _3867 = 0.0f;
                                                          _3868 = 0.0f;
                                                          _3869 = 0.0f;
                                                          if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                            _3587 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                            _3588 = _3587 * _205;
                                                            _3589 = _3587 * _207;
                                                            _3590 = _3587 * _209;
                                                            _3593 = (abs(_3588) < abs(_3589));
                                                            _3594 = select(_3593, 1.0f, 0.0f);
                                                            _3595 = select(_3593, 0.0f, 1.0f);
                                                            _3596 = _3595 * _3590;
                                                            _3598 = -0.0f - (_3590 * _3594);
                                                            _3601 = (_3594 * _3589) - (_3595 * _3588);
                                                            _3603 = rsqrt(dot(float3(_3596, _3598, _3601), float3(_3596, _3598, _3601)));
                                                            _3604 = _3596 * _3603;
                                                            _3605 = _3603 * _3598;
                                                            _3606 = _3601 * _3603;
                                                            _3609 = (_3605 * _3590) - (_3606 * _3589);
                                                            _3612 = (_3606 * _3588) - (_3604 * _3590);
                                                            _3615 = (_3604 * _3589) - (_3605 * _3588);
                                                            _3617 = rsqrt(dot(float3(_3609, _3612, _3615), float3(_3609, _3612, _3615)));
                                                            _3621 = _178 * 4.0f;
                                                            _3630 = saturate(abs(_3621 + -2.5f) + -0.5f) + -0.5f;
                                                            _3631 = saturate(1.5f - abs(_3621 + -1.5f)) + -0.5f;
                                                            _3633 = rsqrt(dot(float2(_3630, _3631), float2(_3630, _3631)));
                                                            _3634 = _3633 * _3630;
                                                            _3635 = _3633 * _3631;
                                                            _3642 = ((_3609 * _3617) * _3634) + (_3635 * _3604);
                                                            _3643 = ((_3612 * _3617) * _3634) + (_3635 * _3605);
                                                            _3644 = ((_3615 * _3617) * _3634) + (_3635 * _3606);
                                                            _3645 = dot(float3(_458, _459, _457), float3(_3487, _3488, _3489));
                                                            _3648 = min(max(dot(float3(_3642, _3643, _3644), float3(_3487, _3488, _3489)), -1.0f), 1.0f);
                                                            _3651 = min(max(dot(float3(_3642, _3643, _3644), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                            _3652 = abs(_3651);
                                                            _3657 = (1.5707963705062866f - (_3652 * 0.1565829962491989f)) * sqrt(1.0f - _3652);
                                                            _3661 = abs(_3648);
                                                            _3666 = (1.5707963705062866f - (_3661 * 0.1565829962491989f)) * sqrt(1.0f - _3661);
                                                            _3673 = cos(abs(select((_3648 >= 0.0f), _3666, (3.1415927410125732f - _3666)) - select((_3651 >= 0.0f), _3657, (3.1415927410125732f - _3657))) * 0.5f);
                                                            _3677 = _3487 - (_3648 * _3642);
                                                            _3678 = _3488 - (_3648 * _3643);
                                                            _3679 = _3489 - (_3648 * _3644);
                                                            _3683 = _458 - (_3651 * _3642);
                                                            _3684 = _459 - (_3651 * _3643);
                                                            _3685 = _457 - (_3651 * _3644);
                                                            _3692 = rsqrt((dot(float3(_3683, _3684, _3685), float3(_3683, _3684, _3685)) * dot(float3(_3677, _3678, _3679), float3(_3677, _3678, _3679))) + 9.999999747378752e-05f) * dot(float3(_3677, _3678, _3679), float3(_3683, _3684, _3685));
                                                            _3696 = sqrt(saturate((_3692 * 0.5f) + 0.5f));
                                                            _3700 = _224 * _224;
                                                            _3701 = _3700 * 0.5f;
                                                            _3702 = _3700 * 2.0f;
                                                            _3705 = select((((_3494 & 1) != 0) && (select(((_3494 & 2) != 0), 1.0f, 0.0f) == 0.0f)), 0.0f, 1.0f);
                                                            _3708 = saturate((_3490 + 0.5f) * 0.6666666865348816f);
                                                            _3718 = (_3651 + _3648) + ((((_3696 * 0.9975510239601135f) * sqrt(1.0f - (_3651 * _3651))) - (_3651 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                            _3720 = (_3700 * 1.4142135381698608f) * _3696;
                                                            _3733 = 1.0f - sqrt(saturate((_3645 * 0.5f) + 0.5f));
                                                            _3734 = _3733 * _3733;
                                                            _3740 = saturate(-0.0f - _3645);
                                                            _3743 = (1.0f - saturate(_3740)) * _3708;
                                                            _3752 = ((((_3696 * 0.5f) * (exp2((((_3718 * _3718) * -0.5f) / (_3720 * _3720)) * 1.4426950216293335f) / (_3720 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_3734 * _3734) * (_3733 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3743, 1.0f, _3705));
                                                            _3754 = (_3648 + -0.03500000014901161f) + _3651;
                                                            _3763 = 1.0f / ((1.190000057220459f / _3673) + (_3673 * 0.36000001430511475f));
                                                            _3768 = ((_3763 * (0.6000000238418579f - (_3692 * 0.800000011920929f))) + 1.0f) * _3696;
                                                            _3774 = 1.0f - (sqrt(saturate(1.0f - (_3768 * _3768))) * _3673);
                                                            _3775 = _3774 * _3774;
                                                            _3779 = 0.9534794092178345f - ((_3775 * _3775) * (_3774 * 0.9534794092178345f));
                                                            _3780 = _3768 * _3763;
                                                            _3785 = (sqrt(1.0f - (_3780 * _3780)) * 0.5f) / _3673;
                                                            _3804 = 1.0f - saturate((_3740 + -0.44999998807907104f) * 2.222222328186035f);
                                                            _3807 = ((1.0f - _3708) * _3705) + _3708;
                                                            _3810 = ((_3779 * _3779) * (exp2((((_3754 * _3754) * -0.5f) / (_3701 * _3701)) * 1.4426950216293335f) / (_3700 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3692 * 5.2658371925354f));
                                                            _3824 = (_3648 + -0.14000000059604645f) + _3651;
                                                            _3834 = 1.0f - (_3673 * 0.5f);
                                                            _3835 = _3834 * _3834;
                                                            _3839 = (_3835 * _3835) * (0.9534794092178345f - (_3673 * 0.47673970460891724f));
                                                            _3841 = 0.9534794092178345f - _3839;
                                                            _3843 = (_3841 * _3841) * (_3839 + 0.04652056470513344f);
                                                            _3846 = exp2((_3692 * 24.525815963745117f) + -24.208423614501953f);
                                                            _3859 = ((exp2((((_3824 * _3824) * -0.5f) / (_3702 * _3702)) * 1.4426950216293335f) / (_3700 * 5.013256549835205f)) * (lerp(_3843, 1.0f, _172))) * (((exp2((saturate(dot(float3((_3572 * _3568), (_3572 * _3569), (_3572 * _3570)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _3846) * _172) + _3846);
                                                            _3867 = (((((exp2(log2(max(_168, 0.0f)) * _3785) * _3807) * _3810) * _3804) + _3752) + (_3859 * _168));
                                                            _3868 = (((((exp2(log2(max(_169, 0.0f)) * _3785) * _3807) * _3810) * _3804) + _3752) + (_3859 * _169));
                                                            _3869 = (((((exp2(log2(max(_170, 0.0f)) * _3785) * _3807) * _3810) * _3804) + _3752) + (_3859 * _170));
                                                          }
                                                          do {
                                                            _3972 = _3477;
                                                            _3973 = _3478;
                                                            _3974 = _3479;
                                                            [branch]
                                                            if (!((_3421 & 1) == 0)) {
                                                              _3882 = max(max(_3477, _3478), _3479);
                                                              do {
                                                                _3892 = _3477;
                                                                _3893 = _3478;
                                                                _3894 = _3479;
                                                                if (_3882 > 0.0f) {
                                                                  _3892 = saturate(_3477 / _3882);
                                                                  _3893 = saturate(_3478 / _3882);
                                                                  _3894 = saturate(_3479 / _3882);
                                                                }
                                                                _3895 = (_3893 < _3894);
                                                                _3896 = select(_3895, _3894, _3893);
                                                                _3897 = select(_3895, _3893, _3894);
                                                                _3898 = select(_3895, -1.0f, 0.0f);
                                                                _3899 = (_3892 < _3896);
                                                                _3901 = select(_3899, _3896, _3892);
                                                                _3902 = select(_3899, _3892, _3896);
                                                                _3906 = _3901 - select((_3902 < _3897), _3902, _3897);
                                                                _3912 = abs(select(_3899, (-0.3333333432674408f - _3898), _3898) + ((_3902 - _3897) / ((_3906 * 6.0f) + 9.999999682655225e-21f)));
                                                                do {
                                                                  _3925 = _3912;
                                                                  if (_3912 < 0.6666666865348816f) {
                                                                    _3925 = ((saturate(((float)((uint)((uint)(((uint)(_3421) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3912 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3912)) + _3912);
                                                                  }
                                                                  _3926 = saturate((_3906 / (_3901 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3421) >> 1) & 255)))) * 0.003921499941498041f));
                                                                  _3927 = saturate(_3901);
                                                                  do {
                                                                    _3954 = _3927;
                                                                    _3955 = _3927;
                                                                    _3956 = _3927;
                                                                    if (!(_3926 <= 0.0f)) {
                                                                      _3930 = saturate(_3925);
                                                                      _3934 = select(((_3930 * 360.0f) >= 360.0f), 0.0f, (_3930 * 6.0f));
                                                                      _3935 = int(_3934);
                                                                      _3937 = _3934 - float((int)(_3935));
                                                                      _3939 = _3927 * (1.0f - _3926);
                                                                      _3942 = (1.0f - (_3937 * _3926)) * _3927;
                                                                      _3946 = (1.0f - ((1.0f - _3937) * _3926)) * _3927;
                                                                      switch (_3935) {
                                                                        case 0: {
                                                                          _3954 = _3927;
                                                                          _3955 = _3946;
                                                                          _3956 = _3939;
                                                                          break;
                                                                        }
                                                                        case 1: {
                                                                          _3954 = _3942;
                                                                          _3955 = _3927;
                                                                          _3956 = _3939;
                                                                          break;
                                                                        }
                                                                        case 2: {
                                                                          _3954 = _3939;
                                                                          _3955 = _3927;
                                                                          _3956 = _3946;
                                                                          break;
                                                                        }
                                                                        case 3: {
                                                                          _3954 = _3939;
                                                                          _3955 = _3942;
                                                                          _3956 = _3927;
                                                                          break;
                                                                        }
                                                                        case 4: {
                                                                          _3954 = _3946;
                                                                          _3955 = _3939;
                                                                          _3956 = _3927;
                                                                          break;
                                                                        }
                                                                        case 5: {
                                                                          _3954 = _3927;
                                                                          _3955 = _3939;
                                                                          _3956 = _3942;
                                                                          break;
                                                                        }
                                                                        default: {
                                                                          _3954 = 0.0f;
                                                                          _3955 = 0.0f;
                                                                          _3956 = 0.0f;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }
                                                                    _3957 = _3954 * _3882;
                                                                    _3958 = _3955 * _3882;
                                                                    _3959 = _3956 * _3882;
                                                                    _3961 = saturate(_3482 * 1.0101009607315063f);
                                                                    _3972 = ((_3961 * (_3477 - _3957)) + _3957);
                                                                    _3973 = ((_3961 * (_3478 - _3958)) + _3958);
                                                                    _3974 = (lerp(_3959, _3479, _3961));
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            _3975 = _3972 * _3482;
                                                            _3976 = _3973 * _3482;
                                                            _3977 = _3974 * _3482;
                                                            do {
                                                              _3987 = _3975;
                                                              _3988 = _3976;
                                                              _3989 = _3977;
                                                              if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                                                                _3987 = (_3975 * _1276);
                                                                _3988 = (_3976 * _1276);
                                                                _3989 = (_3977 * _1276);
                                                              }
                                                              _3993 = (_3987 * ((max(((_3536 + _3503) * _3521), 0.0f) * _3543) + sqrt(_3544 * _3544))) + _1611;
                                                              _3994 = (_3988 * ((max(((_3536 + _3504) * _3521), 0.0f) * _3543) + sqrt(_3545 * _3545))) + _1612;
                                                              _3995 = (_3989 * ((max(((_3536 + _3505) * _3521), 0.0f) * _3543) + sqrt(_3546 * _3546))) + _1613;
                                                              if (_3431 > 0.0f) {
                                                                _4009 = (_3431 * _1367) * ((float)((bool)(uint)(((srvContactShadowsCSMMask.SampleLevel(samplerPointClampNode, float2((cbSharedPerViewData.vViewportSize.x * _129), (cbSharedPerViewData.vViewportSize.y * _130)), 0.0f)).x) == 1.0f)));
                                                                _9584 = _3993;
                                                                _9585 = _3994;
                                                                _9586 = _3995;
                                                                _9587 = (((_3987 * _3867) * _4009) + _1614);
                                                                _9588 = (((_3988 * _3868) * _4009) + _1615);
                                                                _9589 = (((_3989 * _3869) * _4009) + _1616);
                                                              } else {
                                                                _9584 = _3993;
                                                                _9585 = _3994;
                                                                _9586 = _3995;
                                                                _9587 = _1614;
                                                                _9588 = _1615;
                                                                _9589 = _1616;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        _9584 = _1611;
                                                        _9585 = _1612;
                                                        _9586 = _1613;
                                                        _9587 = _1614;
                                                        _9588 = _1615;
                                                        _9589 = _1616;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    _9584 = _1611;
                                                    _9585 = _1612;
                                                    _9586 = _1613;
                                                    _9587 = _1614;
                                                    _9588 = _1615;
                                                    _9589 = _1616;
                                                  }
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } else {
                                                _1674 = _1654 * select(((_1623 & 67108864) != 0), 1.0f, (1.0f - _1606));
                                                [branch]
                                                if (_1657 == 4) {
                                                  _1679 = asfloat(srvLightInfoProperties.Load4(_1625)).x;
                                                  _1680 = asfloat(srvLightInfoProperties.Load4(_1625)).y;
                                                  _1681 = asfloat(srvLightInfoProperties.Load4(_1625)).z;
                                                  _1682 = asfloat(srvLightInfoProperties.Load4(_1625)).w;
                                                  _1685 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).x;
                                                  _1686 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).y;
                                                  _1687 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).z;
                                                  _1688 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).w;
                                                  _1691 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).x;
                                                  _1692 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).y;
                                                  _1693 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).z;
                                                  _1694 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).w;
                                                  _1697 = asint(srvLightInfoProperties.Load(((int)(_1625 + 48u))));
                                                  _1700 = asint(srvLightInfoProperties.Load(((int)(_1625 + 52u))));
                                                  _1703 = asint(srvLightInfoProperties.Load(((int)(_1625 + 64u))));
                                                  _1706 = asint(srvLightInfoProperties.Load(((int)(_1625 + 68u))));
                                                  _1709 = asint(srvLightInfoProperties.Load(((int)(_1625 + 72u))));
                                                  _1711 = f16tof32(((uint)((uint)(_1697) >> 16)));
                                                  _1712 = f16tof32(_1697);
                                                  _1714 = f16tof32(((uint)((uint)(_1700) >> 16)));
                                                  _1718 = ((float)((uint)((uint)(((uint)(_1700) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _1731 = mad(_1681, _246, mad(_1680, _245, (_1679 * _244))) + _1682;
                                                  _1735 = mad(_1687, _246, mad(_1686, _245, (_1685 * _244))) + _1688;
                                                  _1739 = mad(_1693, _246, mad(_1692, _245, (_1691 * _244))) + _1694;
                                                  _1764 = saturate(1.0f - ((_1731 + 1.0f) * f16tof32(_1703))) + saturate(1.0f - ((1.0f - _1731) * f16tof32(((uint)((uint)(_1703) >> 16)))));
                                                  _1765 = saturate(1.0f - ((_1735 + 1.0f) * f16tof32(_1706))) + saturate(1.0f - ((1.0f - _1735) * f16tof32(((uint)((uint)(_1706) >> 16)))));
                                                  _1766 = saturate(1.0f - ((_1739 + 1.0f) * f16tof32(_1709))) + saturate(1.0f - ((1.0f - _1739) * f16tof32(((uint)((uint)(_1709) >> 16)))));
                                                  _1769 = saturate(1.0f - dot(float3(_1764, _1765, _1766), float3(_1764, _1765, _1766)));
                                                  _1770 = _1769 * _1769;
                                                  _1777 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1770 * _1276), _1770) * _1674;
                                                  _9584 = ((_1777 * _1711) + _1611);
                                                  _9585 = ((_1777 * _1712) + _1612);
                                                  _9586 = ((_1777 * _1714) + _1613);
                                                  _9587 = (((_1718 * _1711) * _1777) + _1614);
                                                  _9588 = (((_1718 * _1712) * _1777) + _1615);
                                                  _9589 = (((_1714 * _1718) * _1777) + _1616);
                                                } else {
                                                  if (_1657 == 5) {
                                                    _1798 = asfloat(srvLightInfoProperties.Load4(_1625)).x;
                                                    _1799 = asfloat(srvLightInfoProperties.Load4(_1625)).y;
                                                    _1800 = asfloat(srvLightInfoProperties.Load4(_1625)).z;
                                                    _1801 = asfloat(srvLightInfoProperties.Load4(_1625)).w;
                                                    _1804 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).x;
                                                    _1805 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).y;
                                                    _1806 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).z;
                                                    _1807 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).w;
                                                    _1810 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).x;
                                                    _1811 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).y;
                                                    _1812 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).z;
                                                    _1813 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).w;
                                                    _1816 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).x;
                                                    _1817 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).y;
                                                    _1818 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).z;
                                                    _1821 = asfloat(srvLightInfoProperties.Load(((int)(_1625 + 60u))));
                                                    _1824 = asint(srvLightInfoProperties.Load(((int)(_1625 + 64u))));
                                                    _1827 = asint(srvLightInfoProperties.Load(((int)(_1625 + 68u))));
                                                    _1830 = asint(srvLightInfoProperties.Load(((int)(_1625 + 84u))));
                                                    _1833 = asint(srvLightInfoProperties.Load(((int)(_1625 + 88u))));
                                                    _1836 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 92u)))).x;
                                                    _1837 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 92u)))).y;
                                                    _1838 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 92u)))).z;
                                                    _1839 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 92u)))).w;
                                                    _1842 = asint(srvLightInfoProperties.Load(((int)(_1625 + 108u))));
                                                    _1845 = asint(srvLightInfoProperties.Load(((int)(_1625 + 112u))));
                                                    _1848 = asint(srvLightInfoProperties.Load(((int)(_1625 + 120u))));
                                                    _1851 = asint(srvLightInfoProperties.Load(((int)(_1625 + 124u))));
                                                    _1854 = asint(srvLightInfoProperties.Load(((int)(_1625 + 128u))));
                                                    _1857 = asint(srvLightInfoProperties.Load(((int)(_1625 + 132u))));
                                                    _1860 = asint(srvLightInfoProperties.Load(((int)(_1625 + 136u))));
                                                    _1863 = asint(srvLightInfoProperties.Load(((int)(_1625 + 140u))));
                                                    _1865 = f16tof32(((uint)((uint)(_1824) >> 16)));
                                                    _1866 = f16tof32(_1824);
                                                    _1868 = f16tof32(((uint)((uint)(_1827) >> 16)));
                                                    _1872 = ((float)((uint)((uint)(((uint)(_1827) >> 8) & 255)))) * 0.003921499941498041f;
                                                    _1874 = _1830 & 65535;
                                                    _1880 = ((_1623 & 3584) != 0);
                                                    _1885 = f16tof32(((uint)((uint)(_1845) >> 16)));
                                                    _1886 = f16tof32(_1845);
                                                    _1888 = f16tof32(((uint)((uint)(_1848) >> 16)));
                                                    _1889 = 1.0f / _1888;
                                                    _1890 = _1888 + -1.0f;
                                                    _1891 = f16tof32(_1848);
                                                    _1910 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_1816, _1817, _1818))) * f16tof32(_1842);
                                                    _1914 = (_1910 * _205) + _244;
                                                    _1915 = (_1910 * _207) + _245;
                                                    _1916 = (_1910 * _209) - _243;
                                                    _1920 = mad(_1800, _1916, mad(_1799, _1915, (_1914 * _1798))) + _1801;
                                                    _1924 = mad(_1806, _1916, mad(_1805, _1915, (_1914 * _1804))) + _1807;
                                                    _1928 = mad(_1812, _1916, mad(_1811, _1915, (_1914 * _1810))) + _1813;
                                                    _1929 = saturate(_1928);
                                                    _1952 = saturate(1.0f - (_1920 * f16tof32(_1857))) + saturate(1.0f - ((1.0f - _1920) * f16tof32(((uint)((uint)(_1857) >> 16)))));
                                                    _1953 = saturate(1.0f - (_1924 * f16tof32(_1860))) + saturate(1.0f - ((1.0f - _1924) * f16tof32(((uint)((uint)(_1860) >> 16)))));
                                                    _1954 = saturate(1.0f - (_1928 * f16tof32(_1863))) + saturate(1.0f - ((1.0f - _1928) * f16tof32(((uint)((uint)(_1863) >> 16)))));
                                                    _1957 = saturate(1.0f - dot(float3(_1952, _1953, _1954), float3(_1952, _1953, _1954)));
                                                    _1958 = _1957 * _1957;
                                                    do {
                                                      _2855 = 0.0f;
                                                      _2856 = 1.0f;
                                                      _2857 = 1.0f;
                                                      if (!((!(_1958 > 0.0f)) || (!_1880))) {
                                                        _1965 = 1.0f - _1929;
                                                        _1966 = saturate(_1920);
                                                        _1967 = saturate(_1924);
                                                        do {
                                                          _2280 = 1.0f;
                                                          _2281 = 1.0f;
                                                          _2282 = 0.0f;
                                                          _2283 = _1965;
                                                          [branch]
                                                          if (!((_1623 & 1024) == 0)) {
                                                            _1972 = ((_1966 * _1890) + 0.5f) * _1889;
                                                            _1974 = ((_1967 * _1890) + 0.5f) * _1889;
                                                            _1975 = _1965 + f16tof32(((uint)((uint)(_1842) >> 16)));
                                                            Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1830) >> 16))];
                                                            _1978 = saturate(_1975);
                                                            _1982 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                            #if FIRSTLIGHT_ISFAST_ENABLED
                                                            if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                              _1991 = RenoDX_ISFASTShadowAngle(
                                                                  uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 0u);
                                                            } else {
                                                              _1991 = frac(frac(dot(float2(((_1982 * 32.665000915527344f) + _129), ((_1982 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            }
                                                            #else
                                                            _1991 = frac(frac(dot(float2(((_1982 * 32.665000915527344f) + _129), ((_1982 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            #endif
                                                            _1992 = sin(_1991);
                                                            _1993 = cos(_1991);
                                                            _1994 = cbSharedPerViewData.nFrameCounter & 3;
                                                            _1999 = sqrt((float((int)(_1994)) * 0.25f) + 0.125f) * _1885;
                                                            _2008 = (_global_7[min((uint)(((int)(0u + (_1994 * 2)))), 127u)]) * _1999;
                                                            _2009 = (_global_7[min((uint)(((int)(1u + (_1994 * 2)))), 127u)]) * _1999;
                                                            _2011 = -0.0f - _1992;
                                                            _2016 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2008, _2009), float2(_1993, _1992)) + _1972), (dot(float2(_2008, _2009), float2(_2011, _1993)) + _1974)));
                                                            _2021 = _2016.x - _1978;
                                                            _2023 = select((_2021 < 0.0f), 0.0f, 1.0f);
                                                            _2025 = _2016.y - _1978;
                                                            _2027 = select((_2025 < 0.0f), 0.0f, 1.0f);
                                                            _2031 = _2016.z - _1978;
                                                            _2033 = select((_2031 < 0.0f), 0.0f, 1.0f);
                                                            _2037 = _2016.w - _1978;
                                                            _2039 = select((_2037 < 0.0f), 0.0f, 1.0f);
                                                            _2046 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                            _2051 = sqrt((float((int)(_2046)) * 0.25f) + 0.125f) * _1885;
                                                            _2060 = (_global_7[min((uint)(((int)(0u + (_2046 * 2)))), 127u)]) * _2051;
                                                            _2061 = (_global_7[min((uint)(((int)(1u + (_2046 * 2)))), 127u)]) * _2051;
                                                            _2067 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2060, _2061), float2(_1993, _1992)) + _1972), (dot(float2(_2060, _2061), float2(_2011, _1993)) + _1974)));
                                                            _2072 = _2067.x - _1978;
                                                            _2074 = select((_2072 < 0.0f), 0.0f, 1.0f);
                                                            _2078 = _2067.y - _1978;
                                                            _2080 = select((_2078 < 0.0f), 0.0f, 1.0f);
                                                            _2084 = _2067.z - _1978;
                                                            _2086 = select((_2084 < 0.0f), 0.0f, 1.0f);
                                                            _2090 = _2067.w - _1978;
                                                            _2092 = select((_2090 < 0.0f), 0.0f, 1.0f);
                                                            _2099 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                            _2104 = sqrt((float((int)(_2099)) * 0.25f) + 0.125f) * _1885;
                                                            _2113 = (_global_7[min((uint)(((int)(0u + (_2099 * 2)))), 127u)]) * _2104;
                                                            _2114 = (_global_7[min((uint)(((int)(1u + (_2099 * 2)))), 127u)]) * _2104;
                                                            _2120 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2113, _2114), float2(_1993, _1992)) + _1972), (dot(float2(_2113, _2114), float2(_2011, _1993)) + _1974)));
                                                            _2125 = _2120.x - _1978;
                                                            _2127 = select((_2125 < 0.0f), 0.0f, 1.0f);
                                                            _2131 = _2120.y - _1978;
                                                            _2133 = select((_2131 < 0.0f), 0.0f, 1.0f);
                                                            _2137 = _2120.z - _1978;
                                                            _2139 = select((_2137 < 0.0f), 0.0f, 1.0f);
                                                            _2143 = _2120.w - _1978;
                                                            _2145 = select((_2143 < 0.0f), 0.0f, 1.0f);
                                                            _2152 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                            _2157 = sqrt((float((int)(_2152)) * 0.25f) + 0.125f) * _1885;
                                                            _2166 = (_global_7[min((uint)(((int)(0u + (_2152 * 2)))), 127u)]) * _2157;
                                                            _2167 = (_global_7[min((uint)(((int)(1u + (_2152 * 2)))), 127u)]) * _2157;
                                                            _2173 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2166, _2167), float2(_1993, _1992)) + _1972), (dot(float2(_2166, _2167), float2(_2011, _1993)) + _1974)));
                                                            _2178 = _2173.x - _1978;
                                                            _2180 = select((_2178 < 0.0f), 0.0f, 1.0f);
                                                            _2184 = _2173.y - _1978;
                                                            _2186 = select((_2184 < 0.0f), 0.0f, 1.0f);
                                                            _2190 = _2173.z - _1978;
                                                            _2192 = select((_2190 < 0.0f), 0.0f, 1.0f);
                                                            _2196 = _2173.w - _1978;
                                                            _2198 = select((_2196 < 0.0f), 0.0f, 1.0f);
                                                            _2199 = ((((((((((((((_2023 + _2027) + _2033) + _2039) + _2074) + _2080) + _2086) + _2092) + _2127) + _2133) + _2139) + _2145) + _2180) + _2186) + _2192) + _2198;
                                                            _2210 = (saturate(_2199 * 0.0625f) * 2.0f) + -1.0f;
                                                            _2216 = float((int)(((int)(uint)((int)(_2210 > 0.0f))) - ((int)(uint)((int)(_2210 < 0.0f)))));
                                                            _2218 = 1.0f - (_2216 * _2210);
                                                            _2220 = (_2218 * _2218) * _2218;
                                                            _2227 = 0.5f - ((_2216 * 0.5f) * ((1.0f - _2220) - ((_2218 - _2220) * saturate(((1.0f / _1978) * (1.0f / _2199)) * ((((((((((((((((_2023 * _2021) + (_2027 * _2025)) + (_2033 * _2031)) + (_2039 * _2037)) + (_2074 * _2072)) + (_2080 * _2078)) + (_2086 * _2084)) + (_2092 * _2090)) + (_2127 * _2125)) + (_2133 * _2131)) + (_2139 * _2137)) + (_2145 * _2143)) + (_2180 * _2178)) + (_2186 * _2184)) + (_2192 * _2190)) + (_2198 * _2196))))));
                                                            _2232 = frac((_1972 * _1888) + 0.5f);
                                                            _2233 = frac((_1974 * _1888) + 0.5f);
                                                            _2234 = _1972 + _1889;
                                                            _2235 = _1974 + _1889;
                                                            _2237 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2234, _2235), _1975);
                                                            _2245 = _1889 * 2.0f;
                                                            _2246 = _2234 - _2245;
                                                            _2247 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2246, _2235), _1975);
                                                            _2252 = 1.0f - _2232;
                                                            _2257 = _2235 - _2245;
                                                            _2258 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2246, _2257), _1975);
                                                            _2263 = 1.0f - _2233;
                                                            _2268 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2234, _2257), _1975);
                                                            _2277 = (((mad(mad(_2247.x, _2252, _2247.y), _2233, mad(_2247.w, _2252, _2247.z)) + mad(mad(_2237.y, _2232, _2237.x), _2233, mad(_2237.z, _2232, _2237.w))) + mad(mad(_2258.w, _2252, _2258.z), _2263, mad(_2258.x, _2252, _2258.y))) + mad(mad(_2268.z, _2232, _2268.w), _2263, mad(_2268.y, _2232, _2268.x))) * 0.1111111119389534f;
                                                            [branch]
                                                            if (!(_1891 < 1.0f)) {
                                                              _2751 = _2277;
                                                              _2752 = _1891;
                                                              _2753 = _2227;
                                                              do {
                                                                _2850 = _2753;
                                                                [branch]
                                                                if (!((_1623 & 2048) == 0)) {
                                                                  Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1833) >> 16))];
                                                                  _2759 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1920, _1924), 0.0f);
                                                                  if (_2759.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1833 & 65535))];
                                                                    _2766 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1920, _1924), 0.0f);
                                                                    _2780 = mad(saturate(((log2(_1929 * _1821) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                    _2781 = max(9.999999747378752e-06f, _2759.x);
                                                                    _2782 = _2766.x / _2781;
                                                                    _2783 = _2766.y / _2781;
                                                                    _2785 = _2766.w / _2781;
                                                                    _2790 = ((0.375f - _2783) * 4.999999873689376e-06f) + _2783;
                                                                    _2793 = -0.0f - _2782;
                                                                    _2794 = mad(_2793, _2790, (_2766.z / _2781));
                                                                    _2796 = 1.0f / mad(_2793, _2782, _2790);
                                                                    _2797 = _2796 * _2794;
                                                                    _2802 = _2780 - _2782;
                                                                    _2807 = (((_2780 * _2780) - _2790) - (_2797 * _2802)) / mad((-0.0f - _2794), _2797, mad((-0.0f - _2790), _2790, (((0.375f - _2785) * 4.999999873689376e-06f) + _2785)));
                                                                    _2809 = (_2796 * _2802) - (_2807 * _2797);
                                                                    _2812 = 1.0f / _2807;
                                                                    _2813 = _2809 * _2812;
                                                                    _2818 = sqrt(((_2813 * _2813) * 0.25f) - ((1.0f - dot(float2(_2809, _2807), float2(_2782, _2790))) * _2812));
                                                                    _2820 = (_2813 * -0.5f) - _2818;
                                                                    _2822 = _2818 - (_2813 * 0.5f);
                                                                    _2824 = select((_2820 < _2780), 1.0f, 0.0f);
                                                                    _2829 = (_2824 + -0.05000000074505806f) / (_2820 - _2780);
                                                                    _2835 = (((select((_2822 < _2780), 1.0f, 0.0f) - _2824) / (_2822 - _2820)) - _2829) / (_2822 - _2780);
                                                                    _2837 = _2829 - (_2835 * _2820);
                                                                    _2850 = (exp2((_2759.x * -1.4426950216293335f) * saturate((dot(float2(_2782, _2790), float2((_2837 - (_2835 * _2780)), _2835)) + 0.05000000074505806f) - (_2837 * _2780))) * _2753);
                                                                  } else {
                                                                    _2850 = _2753;
                                                                  }
                                                                }
                                                                _2855 = _2752;
                                                                _2856 = _2850;
                                                                _2857 = (lerp(_2850, _2751, _2752));
                                                                break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                              // Native PCF completion bypasses the fallback-shadow path.
                                                              break;
                                                            } else {
                                                              _2280 = _2227;
                                                              _2281 = _2277;
                                                              _2282 = _1891;
                                                              _2283 = _1975;
                                                            }
                                                          }
                                                          _2286 = (_1966 * _1836) + _1838;
                                                          _2287 = (_1967 * _1837) + _1839;
                                                          do {
                                                            _2746 = 1.0f;
                                                            if (!((_1623 & 512) == 0)) {
                                                              Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                                                              _2296 = saturate(_2283);
                                                              _2300 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _2309 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 1u);
                                                              } else {
                                                                _2309 = frac(frac(dot(float2(((_2300 * 32.665000915527344f) + _129), ((_2300 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _2309 = frac(frac(dot(float2(((_2300 * 32.665000915527344f) + _129), ((_2300 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _2310 = sin(_2309);
                                                              _2311 = cos(_2309);
                                                              _2316 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2286, _2287), 0.0f))).x) > _2296), 1.0f, 0.0f);
                                                              _2317 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _2322 = sqrt((float((int)(_2317)) * 0.25f) + 0.125f) * _1886;
                                                              _2331 = (_global_7[min((uint)(((int)(0u + (_2317 * 2)))), 127u)]) * _2322;
                                                              _2332 = (_global_7[min((uint)(((int)(1u + (_2317 * 2)))), 127u)]) * _2322;
                                                              _2334 = -0.0f - _2310;
                                                              _2336 = dot(float2(_2331, _2332), float2(_2311, _2310)) + _2286;
                                                              _2337 = dot(float2(_2331, _2332), float2(_2334, _2311)) + _2287;
                                                              _2339 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2336, _2337));
                                                              _2343 = _2336 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                              _2344 = _2337 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                              _2347 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1838);
                                                              _2348 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1839);
                                                              _2353 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1836 + _1838)) + 0.5f);
                                                              _2354 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1837 + _1839)) + 0.5f);
                                                              _2357 = floor(_2343 + -0.5f);
                                                              _2358 = floor(_2344 + 0.5f);
                                                              _2360 = floor(_2343 + 0.5f);
                                                              _2362 = floor(_2344 + -0.5f);
                                                              _2363 = (_2357 < _2347);
                                                              _2364 = (_2358 < _2348);
                                                              do {
                                                                if (!(_2363 || _2364)) {
                                                                  if ((_2357 >= _2353) || (_2358 >= _2354)) {
                                                                    _2373 = _2316;
                                                                  } else {
                                                                    _2373 = _2339.x;
                                                                  }
                                                                } else {
                                                                  _2373 = _2316;
                                                                }
                                                                _2374 = (_2360 < _2347);
                                                                do {
                                                                  if (!(_2374 || _2364)) {
                                                                    if ((_2360 >= _2353) || (_2358 >= _2354)) {
                                                                      _2382 = _2316;
                                                                    } else {
                                                                      _2382 = _2339.y;
                                                                    }
                                                                  } else {
                                                                    _2382 = _2316;
                                                                  }
                                                                  _2383 = (_2362 < _2348);
                                                                  do {
                                                                    if (!(_2374 || _2383)) {
                                                                      if ((_2360 >= _2353) || (_2362 >= _2354)) {
                                                                        _2391 = _2316;
                                                                      } else {
                                                                        _2391 = _2339.z;
                                                                      }
                                                                    } else {
                                                                      _2391 = _2316;
                                                                    }
                                                                    do {
                                                                      if (!(_2363 || _2383)) {
                                                                        if ((_2357 >= _2353) || (_2362 >= _2354)) {
                                                                          _2399 = _2316;
                                                                        } else {
                                                                          _2399 = _2339.w;
                                                                        }
                                                                      } else {
                                                                        _2399 = _2316;
                                                                      }
                                                                      _2400 = _2373 - _2296;
                                                                      _2402 = select((_2400 < 0.0f), 0.0f, 1.0f);
                                                                      _2404 = _2382 - _2296;
                                                                      _2406 = select((_2404 < 0.0f), 0.0f, 1.0f);
                                                                      _2410 = _2391 - _2296;
                                                                      _2412 = select((_2410 < 0.0f), 0.0f, 1.0f);
                                                                      _2416 = _2399 - _2296;
                                                                      _2418 = select((_2416 < 0.0f), 0.0f, 1.0f);
                                                                      _2425 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _2430 = sqrt((float((int)(_2425)) * 0.25f) + 0.125f) * _1886;
                                                                      _2439 = (_global_7[min((uint)(((int)(0u + (_2425 * 2)))), 127u)]) * _2430;
                                                                      _2440 = (_global_7[min((uint)(((int)(1u + (_2425 * 2)))), 127u)]) * _2430;
                                                                      _2443 = dot(float2(_2439, _2440), float2(_2311, _2310)) + _2286;
                                                                      _2444 = dot(float2(_2439, _2440), float2(_2334, _2311)) + _2287;
                                                                      _2446 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2443, _2444));
                                                                      _2450 = _2443 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _2451 = _2444 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _2454 = floor(_2450 + -0.5f);
                                                                      _2455 = floor(_2451 + 0.5f);
                                                                      _2457 = floor(_2450 + 0.5f);
                                                                      _2459 = floor(_2451 + -0.5f);
                                                                      _2460 = (_2454 < _2347);
                                                                      _2461 = (_2455 < _2348);
                                                                      do {
                                                                        if (!(_2460 || _2461)) {
                                                                          if ((_2454 >= _2353) || (_2455 >= _2354)) {
                                                                            _2470 = _2316;
                                                                          } else {
                                                                            _2470 = _2446.x;
                                                                          }
                                                                        } else {
                                                                          _2470 = _2316;
                                                                        }
                                                                        _2471 = (_2457 < _2347);
                                                                        do {
                                                                          if (!(_2471 || _2461)) {
                                                                            if ((_2457 >= _2353) || (_2455 >= _2354)) {
                                                                              _2479 = _2316;
                                                                            } else {
                                                                              _2479 = _2446.y;
                                                                            }
                                                                          } else {
                                                                            _2479 = _2316;
                                                                          }
                                                                          _2480 = (_2459 < _2348);
                                                                          do {
                                                                            if (!(_2471 || _2480)) {
                                                                              if ((_2457 >= _2353) || (_2459 >= _2354)) {
                                                                                _2488 = _2316;
                                                                              } else {
                                                                                _2488 = _2446.z;
                                                                              }
                                                                            } else {
                                                                              _2488 = _2316;
                                                                            }
                                                                            do {
                                                                              if (!(_2460 || _2480)) {
                                                                                if ((_2454 >= _2353) || (_2459 >= _2354)) {
                                                                                  _2496 = _2316;
                                                                                } else {
                                                                                  _2496 = _2446.w;
                                                                                }
                                                                              } else {
                                                                                _2496 = _2316;
                                                                              }
                                                                              _2497 = _2470 - _2296;
                                                                              _2499 = select((_2497 < 0.0f), 0.0f, 1.0f);
                                                                              _2503 = _2479 - _2296;
                                                                              _2505 = select((_2503 < 0.0f), 0.0f, 1.0f);
                                                                              _2509 = _2488 - _2296;
                                                                              _2511 = select((_2509 < 0.0f), 0.0f, 1.0f);
                                                                              _2515 = _2496 - _2296;
                                                                              _2517 = select((_2515 < 0.0f), 0.0f, 1.0f);
                                                                              _2524 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _2529 = sqrt((float((int)(_2524)) * 0.25f) + 0.125f) * _1886;
                                                                              _2538 = (_global_7[min((uint)(((int)(0u + (_2524 * 2)))), 127u)]) * _2529;
                                                                              _2539 = (_global_7[min((uint)(((int)(1u + (_2524 * 2)))), 127u)]) * _2529;
                                                                              _2542 = dot(float2(_2538, _2539), float2(_2311, _2310)) + _2286;
                                                                              _2543 = dot(float2(_2538, _2539), float2(_2334, _2311)) + _2287;
                                                                              _2545 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2542, _2543));
                                                                              _2549 = _2542 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _2550 = _2543 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _2553 = floor(_2549 + -0.5f);
                                                                              _2554 = floor(_2550 + 0.5f);
                                                                              _2556 = floor(_2549 + 0.5f);
                                                                              _2558 = floor(_2550 + -0.5f);
                                                                              _2559 = (_2553 < _2347);
                                                                              _2560 = (_2554 < _2348);
                                                                              do {
                                                                                if (!(_2559 || _2560)) {
                                                                                  if ((_2553 >= _2353) || (_2554 >= _2354)) {
                                                                                    _2569 = _2316;
                                                                                  } else {
                                                                                    _2569 = _2545.x;
                                                                                  }
                                                                                } else {
                                                                                  _2569 = _2316;
                                                                                }
                                                                                _2570 = (_2556 < _2347);
                                                                                do {
                                                                                  if (!(_2570 || _2560)) {
                                                                                    if ((_2556 >= _2353) || (_2554 >= _2354)) {
                                                                                      _2578 = _2316;
                                                                                    } else {
                                                                                      _2578 = _2545.y;
                                                                                    }
                                                                                  } else {
                                                                                    _2578 = _2316;
                                                                                  }
                                                                                  _2579 = (_2558 < _2348);
                                                                                  do {
                                                                                    if (!(_2570 || _2579)) {
                                                                                      if ((_2556 >= _2353) || (_2558 >= _2354)) {
                                                                                        _2587 = _2316;
                                                                                      } else {
                                                                                        _2587 = _2545.z;
                                                                                      }
                                                                                    } else {
                                                                                      _2587 = _2316;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_2559 || _2579)) {
                                                                                        if ((_2553 >= _2353) || (_2558 >= _2354)) {
                                                                                          _2595 = _2316;
                                                                                        } else {
                                                                                          _2595 = _2545.w;
                                                                                        }
                                                                                      } else {
                                                                                        _2595 = _2316;
                                                                                      }
                                                                                      _2596 = _2569 - _2296;
                                                                                      _2598 = select((_2596 < 0.0f), 0.0f, 1.0f);
                                                                                      _2602 = _2578 - _2296;
                                                                                      _2604 = select((_2602 < 0.0f), 0.0f, 1.0f);
                                                                                      _2608 = _2587 - _2296;
                                                                                      _2610 = select((_2608 < 0.0f), 0.0f, 1.0f);
                                                                                      _2614 = _2595 - _2296;
                                                                                      _2616 = select((_2614 < 0.0f), 0.0f, 1.0f);
                                                                                      _2623 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _2628 = sqrt((float((int)(_2623)) * 0.25f) + 0.125f) * _1886;
                                                                                      _2637 = (_global_7[min((uint)(((int)(0u + (_2623 * 2)))), 127u)]) * _2628;
                                                                                      _2638 = (_global_7[min((uint)(((int)(1u + (_2623 * 2)))), 127u)]) * _2628;
                                                                                      _2641 = dot(float2(_2637, _2638), float2(_2311, _2310)) + _2286;
                                                                                      _2642 = dot(float2(_2637, _2638), float2(_2334, _2311)) + _2287;
                                                                                      _2644 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2641, _2642));
                                                                                      _2648 = _2641 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _2649 = _2642 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _2652 = floor(_2648 + -0.5f);
                                                                                      _2653 = floor(_2649 + 0.5f);
                                                                                      _2655 = floor(_2648 + 0.5f);
                                                                                      _2657 = floor(_2649 + -0.5f);
                                                                                      _2658 = (_2652 < _2347);
                                                                                      _2659 = (_2653 < _2348);
                                                                                      do {
                                                                                        if (!(_2658 || _2659)) {
                                                                                          if ((_2652 >= _2353) || (_2653 >= _2354)) {
                                                                                            _2668 = _2316;
                                                                                          } else {
                                                                                            _2668 = _2644.x;
                                                                                          }
                                                                                        } else {
                                                                                          _2668 = _2316;
                                                                                        }
                                                                                        _2669 = (_2655 < _2347);
                                                                                        do {
                                                                                          if (!(_2669 || _2659)) {
                                                                                            if ((_2655 >= _2353) || (_2653 >= _2354)) {
                                                                                              _2677 = _2316;
                                                                                            } else {
                                                                                              _2677 = _2644.y;
                                                                                            }
                                                                                          } else {
                                                                                            _2677 = _2316;
                                                                                          }
                                                                                          _2678 = (_2657 < _2348);
                                                                                          do {
                                                                                            if (!(_2669 || _2678)) {
                                                                                              if ((_2655 >= _2353) || (_2657 >= _2354)) {
                                                                                                _2686 = _2316;
                                                                                              } else {
                                                                                                _2686 = _2644.z;
                                                                                              }
                                                                                            } else {
                                                                                              _2686 = _2316;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_2658 || _2678)) {
                                                                                                if ((_2652 >= _2353) || (_2657 >= _2354)) {
                                                                                                  _2694 = _2316;
                                                                                                } else {
                                                                                                  _2694 = _2644.w;
                                                                                                }
                                                                                              } else {
                                                                                                _2694 = _2316;
                                                                                              }
                                                                                              _2695 = _2668 - _2296;
                                                                                              _2697 = select((_2695 < 0.0f), 0.0f, 1.0f);
                                                                                              _2701 = _2677 - _2296;
                                                                                              _2703 = select((_2701 < 0.0f), 0.0f, 1.0f);
                                                                                              _2707 = _2686 - _2296;
                                                                                              _2709 = select((_2707 < 0.0f), 0.0f, 1.0f);
                                                                                              _2713 = _2694 - _2296;
                                                                                              _2715 = select((_2713 < 0.0f), 0.0f, 1.0f);
                                                                                              _2716 = ((((((((((((((_2406 + _2402) + _2412) + _2418) + _2499) + _2505) + _2511) + _2517) + _2598) + _2604) + _2610) + _2616) + _2697) + _2703) + _2709) + _2715;
                                                                                              _2727 = (saturate(_2716 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _2733 = float((int)(((int)(uint)((int)(_2727 > 0.0f))) - ((int)(uint)((int)(_2727 < 0.0f)))));
                                                                                              _2735 = 1.0f - (_2733 * _2727);
                                                                                              _2737 = (_2735 * _2735) * _2735;
                                                                                              _2746 = (0.5f - ((_2733 * 0.5f) * ((1.0f - _2737) - ((_2735 - _2737) * saturate(((1.0f / _2296) * (1.0f / _2716)) * ((((((((((((((((_2406 * _2404) + (_2402 * _2400)) + (_2412 * _2410)) + (_2418 * _2416)) + (_2499 * _2497)) + (_2505 * _2503)) + (_2511 * _2509)) + (_2517 * _2515)) + (_2598 * _2596)) + (_2604 * _2602)) + (_2610 * _2608)) + (_2616 * _2614)) + (_2697 * _2695)) + (_2703 * _2701)) + (_2709 * _2707)) + (_2715 * _2713)))))));
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
                                                            _2751 = _2281;
                                                            _2752 = _2282;
                                                            _2753 = (lerp(_2746, _2280, _2282));
                                                            do {
                                                              _2850 = _2753;
                                                              [branch]
                                                              if (!((_1623 & 2048) == 0)) {
                                                                Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1833) >> 16))];
                                                                _2759 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1920, _1924), 0.0f);
                                                                if (_2759.x > 0.0f) {
                                                                  Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1833 & 65535))];
                                                                  _2766 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1920, _1924), 0.0f);
                                                                  _2780 = mad(saturate(((log2(_1929 * _1821) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                  _2781 = max(9.999999747378752e-06f, _2759.x);
                                                                  _2782 = _2766.x / _2781;
                                                                  _2783 = _2766.y / _2781;
                                                                  _2785 = _2766.w / _2781;
                                                                  _2790 = ((0.375f - _2783) * 4.999999873689376e-06f) + _2783;
                                                                  _2793 = -0.0f - _2782;
                                                                  _2794 = mad(_2793, _2790, (_2766.z / _2781));
                                                                  _2796 = 1.0f / mad(_2793, _2782, _2790);
                                                                  _2797 = _2796 * _2794;
                                                                  _2802 = _2780 - _2782;
                                                                  _2807 = (((_2780 * _2780) - _2790) - (_2797 * _2802)) / mad((-0.0f - _2794), _2797, mad((-0.0f - _2790), _2790, (((0.375f - _2785) * 4.999999873689376e-06f) + _2785)));
                                                                  _2809 = (_2796 * _2802) - (_2807 * _2797);
                                                                  _2812 = 1.0f / _2807;
                                                                  _2813 = _2809 * _2812;
                                                                  _2818 = sqrt(((_2813 * _2813) * 0.25f) - ((1.0f - dot(float2(_2809, _2807), float2(_2782, _2790))) * _2812));
                                                                  _2820 = (_2813 * -0.5f) - _2818;
                                                                  _2822 = _2818 - (_2813 * 0.5f);
                                                                  _2824 = select((_2820 < _2780), 1.0f, 0.0f);
                                                                  _2829 = (_2824 + -0.05000000074505806f) / (_2820 - _2780);
                                                                  _2835 = (((select((_2822 < _2780), 1.0f, 0.0f) - _2824) / (_2822 - _2820)) - _2829) / (_2822 - _2780);
                                                                  _2837 = _2829 - (_2835 * _2820);
                                                                  _2850 = (exp2((_2759.x * -1.4426950216293335f) * saturate((dot(float2(_2782, _2790), float2((_2837 - (_2835 * _2780)), _2835)) + 0.05000000074505806f) - (_2837 * _2780))) * _2753);
                                                                } else {
                                                                  _2850 = _2753;
                                                                }
                                                              }
                                                              _2855 = _2752;
                                                              _2856 = _2850;
                                                              _2857 = (lerp(_2850, _2751, _2752));
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      }
                                                      do {
                                                        _2878 = _1865;
                                                        _2879 = _1866;
                                                        _2880 = _1868;
                                                        [branch]
                                                        if (!(_1874 == 0)) {
                                                          Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1874)))];
                                                          _2870 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1920 * f16tof32(((uint)((uint)(_1851) >> 16)))) + f16tof32(((uint)((uint)(_1854) >> 16)))), ((_1924 * f16tof32(_1851)) + f16tof32(_1854))), 0.0f);
                                                          _2878 = (_2870.x * _1865);
                                                          _2879 = (_2870.y * _1866);
                                                          _2880 = (_2870.z * _1868);
                                                        }
                                                        _2881 = _2856 * _1958;
                                                        _2882 = _2857 * _1958;
                                                        [branch]
                                                        if (!(_2881 == 0.0f)) {
                                                          do {
                                                            _2900 = GetDeferredSoftShadowChannel(_1626);
                                                            if (_2900 < 0) {
                                                                  _2921 = _2881;
                                                                  do {
                                                                    _9584 = _1611;
                                                                    _9585 = _1612;
                                                                    _9586 = _1613;
                                                                    _9587 = _1614;
                                                                    _9588 = _1615;
                                                                    _9589 = _1616;
                                                                    [branch]
                                                                    if (!(_2921 == 0.0f)) {
                                                                      do {
                                                                        _2927 = 0.0f;
                                                                        [branch]
                                                                        if (_1880) {
                                                                          _2927 = _2855;
                                                                        }
                                                                        do {
                                                                          _2967 = _2882;
                                                                          _2968 = _2882;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _2934 = srvLightMappingData[_1626];
                                                                            if (!(_2934 == -1)) {
                                                                              _2939 = srvLightIndexData[_2934].nLayerIndex;
                                                                              _2941 = srvLightIndexData[_2934].vAtlasOrigin.x;
                                                                              _2942 = srvLightIndexData[_2934].vAtlasOrigin.y;
                                                                              _2944 = srvLightIndexData[_2934].vScreenOrigin.x;
                                                                              _2945 = srvLightIndexData[_2934].vScreenOrigin.y;
                                                                              _2954 = ((int)(_2939 * 5)) & 31;
                                                                              _2957 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2941 + _67) - _2944)), ((int)((_2942 + _68) - _2945)), 0)))).x) & ((int)(31 << _2954)))) >> _2954;
                                                                              _2967 = ((_2882 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_2957) >> 1)))));
                                                                              _2968 = (((float)((bool)(uint)((_2957 & 1) != 0))) * _2882);
                                                                            } else {
                                                                              _2967 = _2882;
                                                                              _2968 = _2882;
                                                                            }
                                                                          }
                                                                          _2972 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _2975 = select(_2972, (_2967 * _1276), _2967);
                                                                          _2978 = rsqrt(dot(float3(_1816, _1817, _1818), float3(_1816, _1817, _1818)));
                                                                          _2979 = _2978 * _1816;
                                                                          _2980 = _2978 * _1817;
                                                                          _2981 = _2978 * _1818;
                                                                          _2982 = dot(float3(_205, _207, _209), float3(_2979, _2980, _2981));
                                                                          _2983 = saturate(_2982);
                                                                          _2986 = uint((_180 * 255.0f) + 0.5f);
                                                                          _2995 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                                          _2996 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                                          _2997 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                                          _3013 = ((dot(float3(_206, _208, _210), float3(_2979, _2980, _2981)) + dot(float3((-0.0f - _458), (-0.0f - _459), (-0.0f - _457)), float3(_2979, _2980, _2981))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_2986) >> 2)))) * 0.1666666716337204f)));
                                                                          _3020 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                                          _3023 = saturate((_3020 + -0.009999999776482582f) * -100.0f);
                                                                          _3028 = ((_3023 * _3023) * 3.0f) * (3.0f - (_3023 * 2.0f));
                                                                          _3035 = 10.0f - (exp2(log2(saturate(_3020 * 5.0f)) * 3.0f) * 9.0f);
                                                                          _3036 = saturate(_2983 + _2995) * _2983;
                                                                          _3037 = saturate(_2983 + _2996) * _2983;
                                                                          _3038 = saturate(_2983 + _2997) * _2983;
                                                                          _3060 = _2979 + _458;
                                                                          _3061 = _2980 + _459;
                                                                          _3062 = _2981 + _457;
                                                                          _3064 = rsqrt(dot(float3(_3060, _3061, _3062), float3(_3060, _3061, _3062)));
                                                                          do {
                                                                            _3367 = 0.0f;
                                                                            _3368 = 0.0f;
                                                                            _3369 = 0.0f;
                                                                            if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                              _3079 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                              _3080 = _3079 * _205;
                                                                              _3081 = _3079 * _207;
                                                                              _3082 = _3079 * _209;
                                                                              _3085 = (abs(_3080) < abs(_3081));
                                                                              _3086 = select(_3085, 1.0f, 0.0f);
                                                                              _3087 = select(_3085, 0.0f, 1.0f);
                                                                              _3088 = _3087 * _3082;
                                                                              _3090 = -0.0f - (_3082 * _3086);
                                                                              _3093 = (_3086 * _3081) - (_3087 * _3080);
                                                                              _3095 = rsqrt(dot(float3(_3088, _3090, _3093), float3(_3088, _3090, _3093)));
                                                                              _3096 = _3088 * _3095;
                                                                              _3097 = _3095 * _3090;
                                                                              _3098 = _3093 * _3095;
                                                                              _3101 = (_3097 * _3082) - (_3098 * _3081);
                                                                              _3104 = (_3098 * _3080) - (_3096 * _3082);
                                                                              _3107 = (_3096 * _3081) - (_3097 * _3080);
                                                                              _3109 = rsqrt(dot(float3(_3101, _3104, _3107), float3(_3101, _3104, _3107)));
                                                                              _3113 = _178 * 4.0f;
                                                                              _3122 = saturate(abs(_3113 + -2.5f) + -0.5f) + -0.5f;
                                                                              _3123 = saturate(1.5f - abs(_3113 + -1.5f)) + -0.5f;
                                                                              _3125 = rsqrt(dot(float2(_3122, _3123), float2(_3122, _3123)));
                                                                              _3126 = _3125 * _3122;
                                                                              _3127 = _3125 * _3123;
                                                                              _3134 = ((_3101 * _3109) * _3126) + (_3127 * _3096);
                                                                              _3135 = ((_3104 * _3109) * _3126) + (_3127 * _3097);
                                                                              _3136 = ((_3107 * _3109) * _3126) + (_3127 * _3098);
                                                                              _3137 = dot(float3(_458, _459, _457), float3(_2979, _2980, _2981));
                                                                              _3140 = min(max(dot(float3(_3134, _3135, _3136), float3(_2979, _2980, _2981)), -1.0f), 1.0f);
                                                                              _3143 = min(max(dot(float3(_3134, _3135, _3136), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                              _3144 = abs(_3143);
                                                                              _3149 = (1.5707963705062866f - (_3144 * 0.1565829962491989f)) * sqrt(1.0f - _3144);
                                                                              _3153 = abs(_3140);
                                                                              _3158 = (1.5707963705062866f - (_3153 * 0.1565829962491989f)) * sqrt(1.0f - _3153);
                                                                              _3165 = cos(abs(select((_3140 >= 0.0f), _3158, (3.1415927410125732f - _3158)) - select((_3143 >= 0.0f), _3149, (3.1415927410125732f - _3149))) * 0.5f);
                                                                              _3169 = _2979 - (_3140 * _3134);
                                                                              _3170 = _2980 - (_3140 * _3135);
                                                                              _3171 = _2981 - (_3140 * _3136);
                                                                              _3175 = _458 - (_3143 * _3134);
                                                                              _3176 = _459 - (_3143 * _3135);
                                                                              _3177 = _457 - (_3143 * _3136);
                                                                              _3184 = rsqrt((dot(float3(_3175, _3176, _3177), float3(_3175, _3176, _3177)) * dot(float3(_3169, _3170, _3171), float3(_3169, _3170, _3171))) + 9.999999747378752e-05f) * dot(float3(_3169, _3170, _3171), float3(_3175, _3176, _3177));
                                                                              _3188 = sqrt(saturate((_3184 * 0.5f) + 0.5f));
                                                                              _3192 = _224 * _224;
                                                                              _3193 = _3192 * 0.5f;
                                                                              _3194 = _3192 * 2.0f;
                                                                              _3198 = exp2((1.0f - abs(_2927)) * -72.13475036621094f);
                                                                              do {
                                                                                _3205 = _3198;
                                                                                if (!((_2986 & 1) == 0)) {
                                                                                  _3205 = select(((select(((_2986 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_2927 == -1.0f))), 0.0f, _3198);
                                                                                }
                                                                                _3208 = saturate((_2982 + 0.5f) * 0.6666666865348816f);
                                                                                _3218 = (_3143 + _3140) + ((((_3188 * 0.9975510239601135f) * sqrt(1.0f - (_3143 * _3143))) - (_3143 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                                _3220 = (_3192 * 1.4142135381698608f) * _3188;
                                                                                _3233 = 1.0f - sqrt(saturate((_3137 * 0.5f) + 0.5f));
                                                                                _3234 = _3233 * _3233;
                                                                                _3240 = saturate(-0.0f - _3137);
                                                                                _3243 = (1.0f - saturate(_3240)) * _3208;
                                                                                _3252 = ((((_3188 * 0.5f) * (exp2((((_3218 * _3218) * -0.5f) / (_3220 * _3220)) * 1.4426950216293335f) / (_3220 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_3234 * _3234) * (_3233 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3243, 1.0f, _3205));
                                                                                _3254 = (_3140 + -0.03500000014901161f) + _3143;
                                                                                _3263 = 1.0f / ((1.190000057220459f / _3165) + (_3165 * 0.36000001430511475f));
                                                                                _3268 = ((_3263 * (0.6000000238418579f - (_3184 * 0.800000011920929f))) + 1.0f) * _3188;
                                                                                _3274 = 1.0f - (sqrt(saturate(1.0f - (_3268 * _3268))) * _3165);
                                                                                _3275 = _3274 * _3274;
                                                                                _3279 = 0.9534794092178345f - ((_3275 * _3275) * (_3274 * 0.9534794092178345f));
                                                                                _3280 = _3268 * _3263;
                                                                                _3285 = (sqrt(1.0f - (_3280 * _3280)) * 0.5f) / _3165;
                                                                                _3304 = 1.0f - saturate((_3240 + -0.44999998807907104f) * 2.222222328186035f);
                                                                                _3307 = ((1.0f - _3208) * _3205) + _3208;
                                                                                _3310 = ((_3279 * _3279) * (exp2((((_3254 * _3254) * -0.5f) / (_3193 * _3193)) * 1.4426950216293335f) / (_3192 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3184 * 5.2658371925354f));
                                                                                _3324 = (_3140 + -0.14000000059604645f) + _3143;
                                                                                _3334 = 1.0f - (_3165 * 0.5f);
                                                                                _3335 = _3334 * _3334;
                                                                                _3339 = (_3335 * _3335) * (0.9534794092178345f - (_3165 * 0.47673970460891724f));
                                                                                _3341 = 0.9534794092178345f - _3339;
                                                                                _3343 = (_3341 * _3341) * (_3339 + 0.04652056470513344f);
                                                                                _3346 = exp2((_3184 * 24.525815963745117f) + -24.208423614501953f);
                                                                                _3359 = ((exp2((((_3324 * _3324) * -0.5f) / (_3194 * _3194)) * 1.4426950216293335f) / (_3192 * 5.013256549835205f)) * (lerp(_3343, 1.0f, _172))) * (((exp2((saturate(dot(float3((_3064 * _3060), (_3064 * _3061), (_3064 * _3062)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _3346) * _172) + _3346);
                                                                                _3367 = (((((exp2(log2(max(_168, 0.0f)) * _3285) * _3307) * _3310) * _3304) + _3252) + (_3359 * _168));
                                                                                _3368 = (((((exp2(log2(max(_169, 0.0f)) * _3285) * _3307) * _3310) * _3304) + _3252) + (_3359 * _169));
                                                                                _3369 = (((((exp2(log2(max(_170, 0.0f)) * _3285) * _3307) * _3310) * _3304) + _3252) + (_3359 * _170));
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            }
                                                                            _3370 = _2878 * _1674;
                                                                            _3371 = _2879 * _1674;
                                                                            _3372 = _2880 * _1674;
                                                                            _3379 = ((_2975 * _3370) * ((max(((_3028 + _2995) * _3013), 0.0f) * _3035) + sqrt(_3036 * _3036))) + _1611;
                                                                            _3380 = ((_2975 * _3371) * ((max(((_3028 + _2996) * _3013), 0.0f) * _3035) + sqrt(_3037 * _3037))) + _1612;
                                                                            _3381 = ((_2975 * _3372) * ((max(((_3028 + _2997) * _3013), 0.0f) * _3035) + sqrt(_3038 * _3038))) + _1613;
                                                                            if (_1872 > 0.0f) {
                                                                              _3384 = (_1872 * _1367) * select(_2972, (_2968 * _1276), _2968);
                                                                              _9584 = _3379;
                                                                              _9585 = _3380;
                                                                              _9586 = _3381;
                                                                              _9587 = (((_3384 * _3370) * _3367) + _1614);
                                                                              _9588 = (((_3384 * _3371) * _3368) + _1615);
                                                                              _9589 = (((_3384 * _3372) * _3369) + _1616);
                                                                            } else {
                                                                              _9584 = _3379;
                                                                              _9585 = _3380;
                                                                              _9586 = _3381;
                                                                              _9587 = _1614;
                                                                              _9588 = _1615;
                                                                              _9589 = _1616;
                                                                            }
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
                                                            _2903 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_67, _68, 0));
                                                            do {
                                                              if (_2900 == 0) {
                                                                _2917 = _2903.x;
                                                              } else {
                                                                if (_2900 == 1) {
                                                                  _2917 = _2903.y;
                                                                } else {
                                                                  if (_2900 == 2) {
                                                                    _2917 = _2903.z;
                                                                  } else {
                                                                    _2917 = _2903.w;
                                                                  }
                                                                }
                                                              }
                                                              _2921 = ((_2917 * _2917) * _1958);
                                                              [branch]
                                                              if (!(_2921 == 0.0f)) {
                                                                do {
                                                                  _2927 = 0.0f;
                                                                  [branch]
                                                                  if (_1880) {
                                                                    _2927 = _2855;
                                                                  }
                                                                  do {
                                                                    _2967 = _2882;
                                                                    _2968 = _2882;
                                                                    [branch]
                                                                    if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                      _2934 = srvLightMappingData[_1626];
                                                                      if (!(_2934 == -1)) {
                                                                        _2939 = srvLightIndexData[_2934].nLayerIndex;
                                                                        _2941 = srvLightIndexData[_2934].vAtlasOrigin.x;
                                                                        _2942 = srvLightIndexData[_2934].vAtlasOrigin.y;
                                                                        _2944 = srvLightIndexData[_2934].vScreenOrigin.x;
                                                                        _2945 = srvLightIndexData[_2934].vScreenOrigin.y;
                                                                        _2954 = ((int)(_2939 * 5)) & 31;
                                                                        _2957 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2941 + _67) - _2944)), ((int)((_2942 + _68) - _2945)), 0)))).x) & ((int)(31 << _2954)))) >> _2954;
                                                                        _2967 = ((_2882 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_2957) >> 1)))));
                                                                        _2968 = (((float)((bool)(uint)((_2957 & 1) != 0))) * _2882);
                                                                      } else {
                                                                        _2967 = _2882;
                                                                        _2968 = _2882;
                                                                      }
                                                                    }
                                                                    _2972 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                    _2975 = select(_2972, (_2967 * _1276), _2967);
                                                                    _2978 = rsqrt(dot(float3(_1816, _1817, _1818), float3(_1816, _1817, _1818)));
                                                                    _2979 = _2978 * _1816;
                                                                    _2980 = _2978 * _1817;
                                                                    _2981 = _2978 * _1818;
                                                                    _2982 = dot(float3(_205, _207, _209), float3(_2979, _2980, _2981));
                                                                    _2983 = saturate(_2982);
                                                                    _2986 = uint((_180 * 255.0f) + 0.5f);
                                                                    _2995 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                                    _2996 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                                    _2997 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                                    _3013 = ((dot(float3(_206, _208, _210), float3(_2979, _2980, _2981)) + dot(float3((-0.0f - _458), (-0.0f - _459), (-0.0f - _457)), float3(_2979, _2980, _2981))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_2986) >> 2)))) * 0.1666666716337204f)));
                                                                    _3020 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                                    _3023 = saturate((_3020 + -0.009999999776482582f) * -100.0f);
                                                                    _3028 = ((_3023 * _3023) * 3.0f) * (3.0f - (_3023 * 2.0f));
                                                                    _3035 = 10.0f - (exp2(log2(saturate(_3020 * 5.0f)) * 3.0f) * 9.0f);
                                                                    _3036 = saturate(_2983 + _2995) * _2983;
                                                                    _3037 = saturate(_2983 + _2996) * _2983;
                                                                    _3038 = saturate(_2983 + _2997) * _2983;
                                                                    _3060 = _2979 + _458;
                                                                    _3061 = _2980 + _459;
                                                                    _3062 = _2981 + _457;
                                                                    _3064 = rsqrt(dot(float3(_3060, _3061, _3062), float3(_3060, _3061, _3062)));
                                                                    do {
                                                                      _3367 = 0.0f;
                                                                      _3368 = 0.0f;
                                                                      _3369 = 0.0f;
                                                                      if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                        _3079 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                        _3080 = _3079 * _205;
                                                                        _3081 = _3079 * _207;
                                                                        _3082 = _3079 * _209;
                                                                        _3085 = (abs(_3080) < abs(_3081));
                                                                        _3086 = select(_3085, 1.0f, 0.0f);
                                                                        _3087 = select(_3085, 0.0f, 1.0f);
                                                                        _3088 = _3087 * _3082;
                                                                        _3090 = -0.0f - (_3082 * _3086);
                                                                        _3093 = (_3086 * _3081) - (_3087 * _3080);
                                                                        _3095 = rsqrt(dot(float3(_3088, _3090, _3093), float3(_3088, _3090, _3093)));
                                                                        _3096 = _3088 * _3095;
                                                                        _3097 = _3095 * _3090;
                                                                        _3098 = _3093 * _3095;
                                                                        _3101 = (_3097 * _3082) - (_3098 * _3081);
                                                                        _3104 = (_3098 * _3080) - (_3096 * _3082);
                                                                        _3107 = (_3096 * _3081) - (_3097 * _3080);
                                                                        _3109 = rsqrt(dot(float3(_3101, _3104, _3107), float3(_3101, _3104, _3107)));
                                                                        _3113 = _178 * 4.0f;
                                                                        _3122 = saturate(abs(_3113 + -2.5f) + -0.5f) + -0.5f;
                                                                        _3123 = saturate(1.5f - abs(_3113 + -1.5f)) + -0.5f;
                                                                        _3125 = rsqrt(dot(float2(_3122, _3123), float2(_3122, _3123)));
                                                                        _3126 = _3125 * _3122;
                                                                        _3127 = _3125 * _3123;
                                                                        _3134 = ((_3101 * _3109) * _3126) + (_3127 * _3096);
                                                                        _3135 = ((_3104 * _3109) * _3126) + (_3127 * _3097);
                                                                        _3136 = ((_3107 * _3109) * _3126) + (_3127 * _3098);
                                                                        _3137 = dot(float3(_458, _459, _457), float3(_2979, _2980, _2981));
                                                                        _3140 = min(max(dot(float3(_3134, _3135, _3136), float3(_2979, _2980, _2981)), -1.0f), 1.0f);
                                                                        _3143 = min(max(dot(float3(_3134, _3135, _3136), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                        _3144 = abs(_3143);
                                                                        _3149 = (1.5707963705062866f - (_3144 * 0.1565829962491989f)) * sqrt(1.0f - _3144);
                                                                        _3153 = abs(_3140);
                                                                        _3158 = (1.5707963705062866f - (_3153 * 0.1565829962491989f)) * sqrt(1.0f - _3153);
                                                                        _3165 = cos(abs(select((_3140 >= 0.0f), _3158, (3.1415927410125732f - _3158)) - select((_3143 >= 0.0f), _3149, (3.1415927410125732f - _3149))) * 0.5f);
                                                                        _3169 = _2979 - (_3140 * _3134);
                                                                        _3170 = _2980 - (_3140 * _3135);
                                                                        _3171 = _2981 - (_3140 * _3136);
                                                                        _3175 = _458 - (_3143 * _3134);
                                                                        _3176 = _459 - (_3143 * _3135);
                                                                        _3177 = _457 - (_3143 * _3136);
                                                                        _3184 = rsqrt((dot(float3(_3175, _3176, _3177), float3(_3175, _3176, _3177)) * dot(float3(_3169, _3170, _3171), float3(_3169, _3170, _3171))) + 9.999999747378752e-05f) * dot(float3(_3169, _3170, _3171), float3(_3175, _3176, _3177));
                                                                        _3188 = sqrt(saturate((_3184 * 0.5f) + 0.5f));
                                                                        _3192 = _224 * _224;
                                                                        _3193 = _3192 * 0.5f;
                                                                        _3194 = _3192 * 2.0f;
                                                                        _3198 = exp2((1.0f - abs(_2927)) * -72.13475036621094f);
                                                                        do {
                                                                          _3205 = _3198;
                                                                          if (!((_2986 & 1) == 0)) {
                                                                            _3205 = select(((select(((_2986 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_2927 == -1.0f))), 0.0f, _3198);
                                                                          }
                                                                          _3208 = saturate((_2982 + 0.5f) * 0.6666666865348816f);
                                                                          _3218 = (_3143 + _3140) + ((((_3188 * 0.9975510239601135f) * sqrt(1.0f - (_3143 * _3143))) - (_3143 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                          _3220 = (_3192 * 1.4142135381698608f) * _3188;
                                                                          _3233 = 1.0f - sqrt(saturate((_3137 * 0.5f) + 0.5f));
                                                                          _3234 = _3233 * _3233;
                                                                          _3240 = saturate(-0.0f - _3137);
                                                                          _3243 = (1.0f - saturate(_3240)) * _3208;
                                                                          _3252 = ((((_3188 * 0.5f) * (exp2((((_3218 * _3218) * -0.5f) / (_3220 * _3220)) * 1.4426950216293335f) / (_3220 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_3234 * _3234) * (_3233 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_3243, 1.0f, _3205));
                                                                          _3254 = (_3140 + -0.03500000014901161f) + _3143;
                                                                          _3263 = 1.0f / ((1.190000057220459f / _3165) + (_3165 * 0.36000001430511475f));
                                                                          _3268 = ((_3263 * (0.6000000238418579f - (_3184 * 0.800000011920929f))) + 1.0f) * _3188;
                                                                          _3274 = 1.0f - (sqrt(saturate(1.0f - (_3268 * _3268))) * _3165);
                                                                          _3275 = _3274 * _3274;
                                                                          _3279 = 0.9534794092178345f - ((_3275 * _3275) * (_3274 * 0.9534794092178345f));
                                                                          _3280 = _3268 * _3263;
                                                                          _3285 = (sqrt(1.0f - (_3280 * _3280)) * 0.5f) / _3165;
                                                                          _3304 = 1.0f - saturate((_3240 + -0.44999998807907104f) * 2.222222328186035f);
                                                                          _3307 = ((1.0f - _3208) * _3205) + _3208;
                                                                          _3310 = ((_3279 * _3279) * (exp2((((_3254 * _3254) * -0.5f) / (_3193 * _3193)) * 1.4426950216293335f) / (_3192 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_3184 * 5.2658371925354f));
                                                                          _3324 = (_3140 + -0.14000000059604645f) + _3143;
                                                                          _3334 = 1.0f - (_3165 * 0.5f);
                                                                          _3335 = _3334 * _3334;
                                                                          _3339 = (_3335 * _3335) * (0.9534794092178345f - (_3165 * 0.47673970460891724f));
                                                                          _3341 = 0.9534794092178345f - _3339;
                                                                          _3343 = (_3341 * _3341) * (_3339 + 0.04652056470513344f);
                                                                          _3346 = exp2((_3184 * 24.525815963745117f) + -24.208423614501953f);
                                                                          _3359 = ((exp2((((_3324 * _3324) * -0.5f) / (_3194 * _3194)) * 1.4426950216293335f) / (_3192 * 5.013256549835205f)) * (lerp(_3343, 1.0f, _172))) * (((exp2((saturate(dot(float3((_3064 * _3060), (_3064 * _3061), (_3064 * _3062)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _3346) * _172) + _3346);
                                                                          _3367 = (((((exp2(log2(max(_168, 0.0f)) * _3285) * _3307) * _3310) * _3304) + _3252) + (_3359 * _168));
                                                                          _3368 = (((((exp2(log2(max(_169, 0.0f)) * _3285) * _3307) * _3310) * _3304) + _3252) + (_3359 * _169));
                                                                          _3369 = (((((exp2(log2(max(_170, 0.0f)) * _3285) * _3307) * _3310) * _3304) + _3252) + (_3359 * _170));
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      _3370 = _2878 * _1674;
                                                                      _3371 = _2879 * _1674;
                                                                      _3372 = _2880 * _1674;
                                                                      _3379 = ((_2975 * _3370) * ((max(((_3028 + _2995) * _3013), 0.0f) * _3035) + sqrt(_3036 * _3036))) + _1611;
                                                                      _3380 = ((_2975 * _3371) * ((max(((_3028 + _2996) * _3013), 0.0f) * _3035) + sqrt(_3037 * _3037))) + _1612;
                                                                      _3381 = ((_2975 * _3372) * ((max(((_3028 + _2997) * _3013), 0.0f) * _3035) + sqrt(_3038 * _3038))) + _1613;
                                                                      if (_1872 > 0.0f) {
                                                                        _3384 = (_1872 * _1367) * select(_2972, (_2968 * _1276), _2968);
                                                                        _9584 = _3379;
                                                                        _9585 = _3380;
                                                                        _9586 = _3381;
                                                                        _9587 = (((_3384 * _3370) * _3367) + _1614);
                                                                        _9588 = (((_3384 * _3371) * _3368) + _1615);
                                                                        _9589 = (((_3384 * _3372) * _3369) + _1616);
                                                                      } else {
                                                                        _9584 = _3379;
                                                                        _9585 = _3380;
                                                                        _9586 = _3381;
                                                                        _9587 = _1614;
                                                                        _9588 = _1615;
                                                                        _9589 = _1616;
                                                                      }
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } else {
                                                                _9584 = _1611;
                                                                _9585 = _1612;
                                                                _9586 = _1613;
                                                                _9587 = _1614;
                                                                _9588 = _1615;
                                                                _9589 = _1616;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _9584 = _1611;
                                                          _9585 = _1612;
                                                          _9586 = _1613;
                                                          _9587 = _1614;
                                                          _9588 = _1615;
                                                          _9589 = _1616;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    if (_1657 == 7) {
                                                      _4024 = asfloat(srvLightInfoProperties.Load3(_1625)).x;
                                                      _4025 = asfloat(srvLightInfoProperties.Load3(_1625)).y;
                                                      _4026 = asfloat(srvLightInfoProperties.Load3(_1625)).z;
                                                      _4029 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 12u)))).x;
                                                      _4030 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 12u)))).y;
                                                      _4031 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 12u)))).z;
                                                      _4034 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 24u)))).x;
                                                      _4035 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 24u)))).y;
                                                      _4036 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 24u)))).z;
                                                      _4039 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 36u)))).x;
                                                      _4040 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 36u)))).y;
                                                      _4041 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 36u)))).z;
                                                      _4044 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).x;
                                                      _4045 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).y;
                                                      _4046 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 48u)))).z;
                                                      _4049 = asint(srvLightInfoProperties.Load(((int)(_1625 + 60u))));
                                                      _4052 = asint(srvLightInfoProperties.Load(((int)(_1625 + 64u))));
                                                      _4055 = asint(srvLightInfoProperties.Load(((int)(_1625 + 72u))));
                                                      _4058 = asint(srvLightInfoProperties.Load(((int)(_1625 + 80u))));
                                                      _4061 = asint(srvLightInfoProperties.Load(((int)(_1625 + 84u))));
                                                      _4064 = asint(srvLightInfoProperties.Load(((int)(_1625 + 88u))));
                                                      _4067 = asint(srvLightInfoProperties.Load(((int)(_1625 + 92u))));
                                                      _4070 = asint(srvLightInfoProperties.Load(((int)(_1625 + 96u))));
                                                      _4073 = asint(srvLightInfoProperties.Load(((int)(_1625 + 100u))));
                                                      _4076 = asint(srvLightInfoProperties.Load(((int)(_1625 + 104u))));
                                                      _4079 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).x;
                                                      _4080 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).y;
                                                      _4081 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).z;
                                                      _4082 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).w;
                                                      _4085 = asint(srvLightInfoProperties.Load(((int)(_1625 + 124u))));
                                                      _4088 = asint(srvLightInfoProperties.Load(((int)(_1625 + 128u))));
                                                      _4091 = asint(srvLightInfoProperties.Load(((int)(_1625 + 136u))));
                                                      _4094 = asint(srvLightInfoProperties.Load(((int)(_1625 + 140u))));
                                                      _4096 = f16tof32(((uint)((uint)(_4049) >> 16)));
                                                      _4097 = f16tof32(_4049);
                                                      _4099 = f16tof32(((uint)((uint)(_4052) >> 16)));
                                                      _4103 = ((float)((uint)((uint)(((uint)(_4052) >> 8) & 255)))) * 0.003921499941498041f;
                                                      _4104 = f16tof32(_4055);
                                                      _4107 = f16tof32(_4058);
                                                      _4109 = f16tof32(((uint)((uint)(_4061) >> 16)));
                                                      _4110 = f16tof32(_4061);
                                                      _4112 = f16tof32(((uint)((uint)(_4064) >> 16)));
                                                      _4115 = _4067 & 65535;
                                                      _4119 = ((_1623 & 4194304) != 0);
                                                      _4127 = f16tof32(((uint)((uint)(_4076) >> 16)));
                                                      _4128 = f16tof32(_4076);
                                                      _4130 = f16tof32(((uint)((uint)(_4085) >> 16)));
                                                      _4133 = f16tof32(((uint)((uint)(_4088) >> 16)));
                                                      _4134 = f16tof32(_4088);
                                                      _4136 = f16tof32(((uint)((uint)(_4091) >> 16)));
                                                      _4137 = _4136 + -1.0f;
                                                      do {
                                                        if (_4119) {
                                                          _4139 = 0.5f / _4136;
                                                          _4140 = 0.3333333432674408f / _4136;
                                                          _4144 = (_4136 * 0.5f) + 0.5f;
                                                          _4154 = (_4139 * _4137);
                                                          _4155 = (_4140 * _4137);
                                                          _4156 = (_4139 * _4144);
                                                          _4157 = (_4140 * _4144);
                                                          _4158 = (_4136 * 2.0f);
                                                          _4159 = (_4136 * 3.0f);
                                                          _4160 = _4139;
                                                          _4161 = _4140;
                                                        } else {
                                                          _4150 = 1.0f / _4136;
                                                          _4151 = _4150 * _4137;
                                                          _4152 = _4150 * 0.5f;
                                                          _4154 = _4151;
                                                          _4155 = _4151;
                                                          _4156 = _4152;
                                                          _4157 = _4152;
                                                          _4158 = _4136;
                                                          _4159 = _4136;
                                                          _4160 = _4150;
                                                          _4161 = _4150;
                                                        }
                                                        _4165 = _4039 - _244;
                                                        _4166 = _4040 - _245;
                                                        _4167 = _4041 + _243;
                                                        _4168 = dot(float3(_4165, _4166, _4167), float3(_4165, _4166, _4167));
                                                        _4169 = rsqrt(_4168);
                                                        _4170 = _4169 * _4168;
                                                        _4171 = _4169 * _4165;
                                                        _4172 = _4169 * _4166;
                                                        _4173 = _4169 * _4167;
                                                        _4176 = max(0.0f, (_4170 - abs(_4107)));
                                                        _4177 = _4176 * f16tof32(((uint)((uint)(_4058) >> 16)));
                                                        _4178 = _4177 * _4177;
                                                        _4181 = saturate(1.0f - (_4178 * _4178));
                                                        _4188 = (_4181 * _4181) / (select((_4107 < 0.0f), (_4178 * 16.0f), (_4176 * _4176)) + 1.0f);
                                                        _4201 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_4171, _4172, _4173))) * f16tof32(_4085);
                                                        _4205 = abs(_4167);
                                                        _4209 = _4165 - ((_4201 * _205) * _4205);
                                                        _4210 = _4166 - ((_4201 * _207) * _4205);
                                                        _4211 = _4167 - ((_4201 * _209) * _4205);
                                                        _4214 = mad(_4211, _4035, mad(_4210, _4030, (_4209 * _4025)));
                                                        _4217 = mad(_4211, _4036, mad(_4210, _4031, (_4209 * _4026)));
                                                        _4219 = ((_1623 & 3584) != 0);
                                                        do {
                                                          _6072 = _4188;
                                                          _6073 = 1.0f;
                                                          _6074 = 0.0f;
                                                          _6075 = 1.0f;
                                                          if (_4219 && (_4188 > 0.0f)) {
                                                            _4225 = mad(_4211, _4034, mad(_4210, _4029, (_4209 * _4024)));
                                                            _4226 = -0.0f - _4217;
                                                            _4227 = -0.0f - _4214;
                                                            do {
                                                              _5070 = 1.0f;
                                                              _5071 = 1.0f;
                                                              _5072 = 1.0f;
                                                              _5073 = 0;
                                                              [branch]
                                                              if (!((_1623 & 1024) == 0)) {
                                                                Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_4067) >> 16))];
                                                                [branch]
                                                                if (_4119) {
                                                                  _4232 = abs(_4225);
                                                                  _4233 = abs(_4226);
                                                                  _4234 = abs(_4227);
                                                                  do {
                                                                    if (_4232 > max(_4233, _4234)) {
                                                                      _4238 = (_4225 > 0.0f);
                                                                      _4253 = select(_4238, 0.0f, 1.0f);
                                                                      _4254 = 0.0f;
                                                                      _4255 = select(_4238, _4214, _4227);
                                                                      _4256 = _4217;
                                                                      _4257 = _4232;
                                                                    } else {
                                                                      if (_4233 > _4234) {
                                                                        _4244 = (_4217 < -0.0f);
                                                                        _4253 = select(_4244, 0.0f, 1.0f);
                                                                        _4254 = 1.0f;
                                                                        _4255 = _4225;
                                                                        _4256 = select(_4244, _4227, _4214);
                                                                        _4257 = _4233;
                                                                      } else {
                                                                        _4248 = (_4214 < -0.0f);
                                                                        _4253 = select(_4248, 0.0f, 1.0f);
                                                                        _4254 = 2.0f;
                                                                        _4255 = select(_4248, _4225, (-0.0f - _4225));
                                                                        _4256 = _4217;
                                                                        _4257 = _4234;
                                                                      }
                                                                    }
                                                                    _4258 = _4257 * 2.0f;
                                                                    _4263 = -0.0f - _4128;
                                                                    _4272 = ((min(max((_4255 / _4258), _4263), _4128) + _4253) * _4154) + _4156;
                                                                    _4273 = ((min(max((_4256 / _4258), _4263), _4128) + _4254) * _4155) + _4157;
                                                                    _4274 = (1.0f - (_4257 * _4112)) + _4130;
                                                                    _4279 = ((_4253 + -0.5f) * _4154) + _4156;
                                                                    _4280 = ((_4254 + -0.5f) * _4155) + _4157;
                                                                    _4283 = saturate(_4274);
                                                                    _4287 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _4296 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 2u);
                                                                    } else {
                                                                      _4296 = frac(frac(dot(float2(((_4287 * 32.665000915527344f) + _129), ((_4287 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _4296 = frac(frac(dot(float2(((_4287 * 32.665000915527344f) + _129), ((_4287 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _4297 = sin(_4296);
                                                                    _4298 = cos(_4296);
                                                                    _4303 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_4272, _4273), 0.0f))).x) > _4283), 1.0f, 0.0f);
                                                                    _4304 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _4309 = sqrt((float((int)(_4304)) * 0.25f) + 0.125f) * _4133;
                                                                    _4318 = (_global_7[min((uint)(((int)(0u + (_4304 * 2)))), 127u)]) * _4309;
                                                                    _4319 = (_global_7[min((uint)(((int)(1u + (_4304 * 2)))), 127u)]) * _4309;
                                                                    _4321 = -0.0f - _4297;
                                                                    _4323 = dot(float2(_4318, _4319), float2(_4298, _4297)) + _4272;
                                                                    _4324 = dot(float2(_4318, _4319), float2(_4321, _4298)) + _4273;
                                                                    _4326 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4323, _4324));
                                                                    _4330 = _4323 * _4158;
                                                                    _4331 = _4324 * _4159;
                                                                    _4334 = floor(_4279 * _4158);
                                                                    _4335 = floor(_4280 * _4159);
                                                                    _4340 = floor(((_4279 + _4154) * _4158) + 0.5f);
                                                                    _4341 = floor(((_4280 + _4155) * _4159) + 0.5f);
                                                                    _4344 = floor(_4330 + -0.5f);
                                                                    _4345 = floor(_4331 + 0.5f);
                                                                    _4347 = floor(_4330 + 0.5f);
                                                                    _4349 = floor(_4331 + -0.5f);
                                                                    _4350 = (_4344 < _4334);
                                                                    _4351 = (_4345 < _4335);
                                                                    do {
                                                                      if (!(_4350 || _4351)) {
                                                                        if ((_4344 >= _4340) || (_4345 >= _4341)) {
                                                                          _4360 = _4303;
                                                                        } else {
                                                                          _4360 = _4326.x;
                                                                        }
                                                                      } else {
                                                                        _4360 = _4303;
                                                                      }
                                                                      _4361 = (_4347 < _4334);
                                                                      do {
                                                                        if (!(_4361 || _4351)) {
                                                                          if ((_4347 >= _4340) || (_4345 >= _4341)) {
                                                                            _4369 = _4303;
                                                                          } else {
                                                                            _4369 = _4326.y;
                                                                          }
                                                                        } else {
                                                                          _4369 = _4303;
                                                                        }
                                                                        _4370 = (_4349 < _4335);
                                                                        do {
                                                                          if (!(_4361 || _4370)) {
                                                                            if ((_4347 >= _4340) || (_4349 >= _4341)) {
                                                                              _4378 = _4303;
                                                                            } else {
                                                                              _4378 = _4326.z;
                                                                            }
                                                                          } else {
                                                                            _4378 = _4303;
                                                                          }
                                                                          do {
                                                                            if (!(_4350 || _4370)) {
                                                                              if ((_4344 >= _4340) || (_4349 >= _4341)) {
                                                                                _4386 = _4303;
                                                                              } else {
                                                                                _4386 = _4326.w;
                                                                              }
                                                                            } else {
                                                                              _4386 = _4303;
                                                                            }
                                                                            _4387 = _4360 - _4283;
                                                                            _4389 = select((_4387 < 0.0f), 0.0f, 1.0f);
                                                                            _4391 = _4369 - _4283;
                                                                            _4393 = select((_4391 < 0.0f), 0.0f, 1.0f);
                                                                            _4397 = _4378 - _4283;
                                                                            _4399 = select((_4397 < 0.0f), 0.0f, 1.0f);
                                                                            _4403 = _4386 - _4283;
                                                                            _4405 = select((_4403 < 0.0f), 0.0f, 1.0f);
                                                                            _4412 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _4417 = sqrt((float((int)(_4412)) * 0.25f) + 0.125f) * _4133;
                                                                            _4426 = (_global_7[min((uint)(((int)(0u + (_4412 * 2)))), 127u)]) * _4417;
                                                                            _4427 = (_global_7[min((uint)(((int)(1u + (_4412 * 2)))), 127u)]) * _4417;
                                                                            _4430 = dot(float2(_4426, _4427), float2(_4298, _4297)) + _4272;
                                                                            _4431 = dot(float2(_4426, _4427), float2(_4321, _4298)) + _4273;
                                                                            _4433 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4430, _4431));
                                                                            _4437 = _4430 * _4158;
                                                                            _4438 = _4431 * _4159;
                                                                            _4441 = floor(_4437 + -0.5f);
                                                                            _4442 = floor(_4438 + 0.5f);
                                                                            _4444 = floor(_4437 + 0.5f);
                                                                            _4446 = floor(_4438 + -0.5f);
                                                                            _4447 = (_4441 < _4334);
                                                                            _4448 = (_4442 < _4335);
                                                                            do {
                                                                              if (!(_4447 || _4448)) {
                                                                                if ((_4441 >= _4340) || (_4442 >= _4341)) {
                                                                                  _4457 = _4303;
                                                                                } else {
                                                                                  _4457 = _4433.x;
                                                                                }
                                                                              } else {
                                                                                _4457 = _4303;
                                                                              }
                                                                              _4458 = (_4444 < _4334);
                                                                              do {
                                                                                if (!(_4458 || _4448)) {
                                                                                  if ((_4444 >= _4340) || (_4442 >= _4341)) {
                                                                                    _4466 = _4303;
                                                                                  } else {
                                                                                    _4466 = _4433.y;
                                                                                  }
                                                                                } else {
                                                                                  _4466 = _4303;
                                                                                }
                                                                                _4467 = (_4446 < _4335);
                                                                                do {
                                                                                  if (!(_4458 || _4467)) {
                                                                                    if ((_4444 >= _4340) || (_4446 >= _4341)) {
                                                                                      _4475 = _4303;
                                                                                    } else {
                                                                                      _4475 = _4433.z;
                                                                                    }
                                                                                  } else {
                                                                                    _4475 = _4303;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_4447 || _4467)) {
                                                                                      if ((_4441 >= _4340) || (_4446 >= _4341)) {
                                                                                        _4483 = _4303;
                                                                                      } else {
                                                                                        _4483 = _4433.w;
                                                                                      }
                                                                                    } else {
                                                                                      _4483 = _4303;
                                                                                    }
                                                                                    _4484 = _4457 - _4283;
                                                                                    _4486 = select((_4484 < 0.0f), 0.0f, 1.0f);
                                                                                    _4490 = _4466 - _4283;
                                                                                    _4492 = select((_4490 < 0.0f), 0.0f, 1.0f);
                                                                                    _4496 = _4475 - _4283;
                                                                                    _4498 = select((_4496 < 0.0f), 0.0f, 1.0f);
                                                                                    _4502 = _4483 - _4283;
                                                                                    _4504 = select((_4502 < 0.0f), 0.0f, 1.0f);
                                                                                    _4511 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _4516 = sqrt((float((int)(_4511)) * 0.25f) + 0.125f) * _4133;
                                                                                    _4525 = (_global_7[min((uint)(((int)(0u + (_4511 * 2)))), 127u)]) * _4516;
                                                                                    _4526 = (_global_7[min((uint)(((int)(1u + (_4511 * 2)))), 127u)]) * _4516;
                                                                                    _4529 = dot(float2(_4525, _4526), float2(_4298, _4297)) + _4272;
                                                                                    _4530 = dot(float2(_4525, _4526), float2(_4321, _4298)) + _4273;
                                                                                    _4532 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4529, _4530));
                                                                                    _4536 = _4529 * _4158;
                                                                                    _4537 = _4530 * _4159;
                                                                                    _4540 = floor(_4536 + -0.5f);
                                                                                    _4541 = floor(_4537 + 0.5f);
                                                                                    _4543 = floor(_4536 + 0.5f);
                                                                                    _4545 = floor(_4537 + -0.5f);
                                                                                    _4546 = (_4540 < _4334);
                                                                                    _4547 = (_4541 < _4335);
                                                                                    do {
                                                                                      if (!(_4546 || _4547)) {
                                                                                        if ((_4540 >= _4340) || (_4541 >= _4341)) {
                                                                                          _4556 = _4303;
                                                                                        } else {
                                                                                          _4556 = _4532.x;
                                                                                        }
                                                                                      } else {
                                                                                        _4556 = _4303;
                                                                                      }
                                                                                      _4557 = (_4543 < _4334);
                                                                                      do {
                                                                                        if (!(_4557 || _4547)) {
                                                                                          if ((_4543 >= _4340) || (_4541 >= _4341)) {
                                                                                            _4565 = _4303;
                                                                                          } else {
                                                                                            _4565 = _4532.y;
                                                                                          }
                                                                                        } else {
                                                                                          _4565 = _4303;
                                                                                        }
                                                                                        _4566 = (_4545 < _4335);
                                                                                        do {
                                                                                          if (!(_4557 || _4566)) {
                                                                                            if ((_4543 >= _4340) || (_4545 >= _4341)) {
                                                                                              _4574 = _4303;
                                                                                            } else {
                                                                                              _4574 = _4532.z;
                                                                                            }
                                                                                          } else {
                                                                                            _4574 = _4303;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_4546 || _4566)) {
                                                                                              if ((_4540 >= _4340) || (_4545 >= _4341)) {
                                                                                                _4582 = _4303;
                                                                                              } else {
                                                                                                _4582 = _4532.w;
                                                                                              }
                                                                                            } else {
                                                                                              _4582 = _4303;
                                                                                            }
                                                                                            _4583 = _4556 - _4283;
                                                                                            _4585 = select((_4583 < 0.0f), 0.0f, 1.0f);
                                                                                            _4589 = _4565 - _4283;
                                                                                            _4591 = select((_4589 < 0.0f), 0.0f, 1.0f);
                                                                                            _4595 = _4574 - _4283;
                                                                                            _4597 = select((_4595 < 0.0f), 0.0f, 1.0f);
                                                                                            _4601 = _4582 - _4283;
                                                                                            _4603 = select((_4601 < 0.0f), 0.0f, 1.0f);
                                                                                            _4610 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _4615 = sqrt((float((int)(_4610)) * 0.25f) + 0.125f) * _4133;
                                                                                            _4624 = (_global_7[min((uint)(((int)(0u + (_4610 * 2)))), 127u)]) * _4615;
                                                                                            _4625 = (_global_7[min((uint)(((int)(1u + (_4610 * 2)))), 127u)]) * _4615;
                                                                                            _4628 = dot(float2(_4624, _4625), float2(_4298, _4297)) + _4272;
                                                                                            _4629 = dot(float2(_4624, _4625), float2(_4321, _4298)) + _4273;
                                                                                            _4631 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4628, _4629));
                                                                                            _4635 = _4628 * _4158;
                                                                                            _4636 = _4629 * _4159;
                                                                                            _4639 = floor(_4635 + -0.5f);
                                                                                            _4640 = floor(_4636 + 0.5f);
                                                                                            _4642 = floor(_4635 + 0.5f);
                                                                                            _4644 = floor(_4636 + -0.5f);
                                                                                            _4645 = (_4639 < _4334);
                                                                                            _4646 = (_4640 < _4335);
                                                                                            do {
                                                                                              if (!(_4645 || _4646)) {
                                                                                                if ((_4639 >= _4340) || (_4640 >= _4341)) {
                                                                                                  _4655 = _4303;
                                                                                                } else {
                                                                                                  _4655 = _4631.x;
                                                                                                }
                                                                                              } else {
                                                                                                _4655 = _4303;
                                                                                              }
                                                                                              _4656 = (_4642 < _4334);
                                                                                              do {
                                                                                                if (!(_4656 || _4646)) {
                                                                                                  if ((_4642 >= _4340) || (_4640 >= _4341)) {
                                                                                                    _4664 = _4303;
                                                                                                  } else {
                                                                                                    _4664 = _4631.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _4664 = _4303;
                                                                                                }
                                                                                                _4665 = (_4644 < _4335);
                                                                                                do {
                                                                                                  if (!(_4656 || _4665)) {
                                                                                                    if ((_4642 >= _4340) || (_4644 >= _4341)) {
                                                                                                      _4673 = _4303;
                                                                                                    } else {
                                                                                                      _4673 = _4631.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _4673 = _4303;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_4645 || _4665)) {
                                                                                                      if ((_4639 >= _4340) || (_4644 >= _4341)) {
                                                                                                        _4681 = _4303;
                                                                                                      } else {
                                                                                                        _4681 = _4631.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _4681 = _4303;
                                                                                                    }
                                                                                                    _4682 = _4655 - _4283;
                                                                                                    _4684 = select((_4682 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4688 = _4664 - _4283;
                                                                                                    _4690 = select((_4688 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4694 = _4673 - _4283;
                                                                                                    _4696 = select((_4694 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4700 = _4681 - _4283;
                                                                                                    _4702 = select((_4700 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4703 = ((((((((((((((_4393 + _4389) + _4399) + _4405) + _4486) + _4492) + _4498) + _4504) + _4585) + _4591) + _4597) + _4603) + _4684) + _4690) + _4696) + _4702;
                                                                                                    _4714 = (saturate(_4703 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _4720 = float((int)(((int)(uint)((int)(_4714 > 0.0f))) - ((int)(uint)((int)(_4714 < 0.0f)))));
                                                                                                    _4722 = 1.0f - (_4720 * _4714);
                                                                                                    _4724 = (_4722 * _4722) * _4722;
                                                                                                    _5070 = (0.5f - ((_4720 * 0.5f) * ((1.0f - _4724) - ((_4722 - _4724) * saturate(((1.0f / _4283) * (1.0f / _4703)) * ((((((((((((((((_4393 * _4391) + (_4389 * _4387)) + (_4399 * _4397)) + (_4405 * _4403)) + (_4486 * _4484)) + (_4492 * _4490)) + (_4498 * _4496)) + (_4504 * _4502)) + (_4585 * _4583)) + (_4591 * _4589)) + (_4597 * _4595)) + (_4603 * _4601)) + (_4684 * _4682)) + (_4690 * _4688)) + (_4696 * _4694)) + (_4702 * _4700)))))));
                                                                                                    _5071 = (((float4)(_HeapResource_22.SampleCmpLevelZero(samplerLinearPCFBorderBlackNode, float2(_4272, _4273), _4274))).x);
                                                                                                    _5072 = 1.0f;
                                                                                                    _5073 = 1;
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
                                                                  _4736 = f16tof32(_4094) / _4227;
                                                                  _4739 = mad((_4736 * _4225), 0.5f, 0.5f);
                                                                  _4740 = mad((_4736 * _4226), 0.5f, 0.5f);
                                                                  _4743 = (1.0f - (_4214 * _4112)) + _4130;
                                                                  if (_4214 > -0.0f) {
                                                                    if ((saturate(_4739) == _4739) && (saturate(_4740) == _4740)) {
                                                                      _4754 = (_4739 * _4154) + _4156;
                                                                      _4755 = (_4740 * _4155) + _4157;
                                                                      _4756 = saturate(_4743);
                                                                      _4760 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _4769 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 3u);
                                                                      } else {
                                                                        _4769 = frac(frac(dot(float2(((_4760 * 32.665000915527344f) + _129), ((_4760 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _4769 = frac(frac(dot(float2(((_4760 * 32.665000915527344f) + _129), ((_4760 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _4770 = sin(_4769);
                                                                      _4771 = cos(_4769);
                                                                      _4772 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _4777 = sqrt((float((int)(_4772)) * 0.25f) + 0.125f) * _4133;
                                                                      _4786 = (_global_7[min((uint)(((int)(0u + (_4772 * 2)))), 127u)]) * _4777;
                                                                      _4787 = (_global_7[min((uint)(((int)(1u + (_4772 * 2)))), 127u)]) * _4777;
                                                                      _4789 = -0.0f - _4770;
                                                                      _4794 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4786, _4787), float2(_4771, _4770)) + _4754), (dot(float2(_4786, _4787), float2(_4789, _4771)) + _4755)));
                                                                      _4799 = _4794.x - _4756;
                                                                      _4801 = select((_4799 < 0.0f), 0.0f, 1.0f);
                                                                      _4803 = _4794.y - _4756;
                                                                      _4805 = select((_4803 < 0.0f), 0.0f, 1.0f);
                                                                      _4809 = _4794.z - _4756;
                                                                      _4811 = select((_4809 < 0.0f), 0.0f, 1.0f);
                                                                      _4815 = _4794.w - _4756;
                                                                      _4817 = select((_4815 < 0.0f), 0.0f, 1.0f);
                                                                      _4824 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _4829 = sqrt((float((int)(_4824)) * 0.25f) + 0.125f) * _4133;
                                                                      _4838 = (_global_7[min((uint)(((int)(0u + (_4824 * 2)))), 127u)]) * _4829;
                                                                      _4839 = (_global_7[min((uint)(((int)(1u + (_4824 * 2)))), 127u)]) * _4829;
                                                                      _4845 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4838, _4839), float2(_4771, _4770)) + _4754), (dot(float2(_4838, _4839), float2(_4789, _4771)) + _4755)));
                                                                      _4850 = _4845.x - _4756;
                                                                      _4852 = select((_4850 < 0.0f), 0.0f, 1.0f);
                                                                      _4856 = _4845.y - _4756;
                                                                      _4858 = select((_4856 < 0.0f), 0.0f, 1.0f);
                                                                      _4862 = _4845.z - _4756;
                                                                      _4864 = select((_4862 < 0.0f), 0.0f, 1.0f);
                                                                      _4868 = _4845.w - _4756;
                                                                      _4870 = select((_4868 < 0.0f), 0.0f, 1.0f);
                                                                      _4877 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                      _4882 = sqrt((float((int)(_4877)) * 0.25f) + 0.125f) * _4133;
                                                                      _4891 = (_global_7[min((uint)(((int)(0u + (_4877 * 2)))), 127u)]) * _4882;
                                                                      _4892 = (_global_7[min((uint)(((int)(1u + (_4877 * 2)))), 127u)]) * _4882;
                                                                      _4898 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4891, _4892), float2(_4771, _4770)) + _4754), (dot(float2(_4891, _4892), float2(_4789, _4771)) + _4755)));
                                                                      _4903 = _4898.x - _4756;
                                                                      _4905 = select((_4903 < 0.0f), 0.0f, 1.0f);
                                                                      _4909 = _4898.y - _4756;
                                                                      _4911 = select((_4909 < 0.0f), 0.0f, 1.0f);
                                                                      _4915 = _4898.z - _4756;
                                                                      _4917 = select((_4915 < 0.0f), 0.0f, 1.0f);
                                                                      _4921 = _4898.w - _4756;
                                                                      _4923 = select((_4921 < 0.0f), 0.0f, 1.0f);
                                                                      _4930 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                      _4935 = sqrt((float((int)(_4930)) * 0.25f) + 0.125f) * _4133;
                                                                      _4944 = (_global_7[min((uint)(((int)(0u + (_4930 * 2)))), 127u)]) * _4935;
                                                                      _4945 = (_global_7[min((uint)(((int)(1u + (_4930 * 2)))), 127u)]) * _4935;
                                                                      _4951 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4944, _4945), float2(_4771, _4770)) + _4754), (dot(float2(_4944, _4945), float2(_4789, _4771)) + _4755)));
                                                                      _4956 = _4951.x - _4756;
                                                                      _4958 = select((_4956 < 0.0f), 0.0f, 1.0f);
                                                                      _4962 = _4951.y - _4756;
                                                                      _4964 = select((_4962 < 0.0f), 0.0f, 1.0f);
                                                                      _4968 = _4951.z - _4756;
                                                                      _4970 = select((_4968 < 0.0f), 0.0f, 1.0f);
                                                                      _4974 = _4951.w - _4756;
                                                                      _4976 = select((_4974 < 0.0f), 0.0f, 1.0f);
                                                                      _4977 = ((((((((((((((_4801 + _4805) + _4811) + _4817) + _4852) + _4858) + _4864) + _4870) + _4905) + _4911) + _4917) + _4923) + _4958) + _4964) + _4970) + _4976;
                                                                      _4988 = (saturate(_4977 * 0.0625f) * 2.0f) + -1.0f;
                                                                      _4994 = float((int)(((int)(uint)((int)(_4988 > 0.0f))) - ((int)(uint)((int)(_4988 < 0.0f)))));
                                                                      _4996 = 1.0f - (_4994 * _4988);
                                                                      _4998 = (_4996 * _4996) * _4996;
                                                                      _5006 = -0.0f - _4225;
                                                                      _5013 = saturate((saturate(rsqrt(dot(float3(_5006, _4217, _4214), float3(_5006, _4217, _4214))) * _4214) * _4110) + _4109);
                                                                      _5015 = 1.0f - (_5013 * _5013);
                                                                      _5022 = frac((_4754 * _4158) + 0.5f);
                                                                      _5023 = frac((_4755 * _4159) + 0.5f);
                                                                      _5024 = _4754 + _4160;
                                                                      _5025 = _4755 + _4161;
                                                                      _5027 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5024, _5025), _4743);
                                                                      _5036 = _5024 - (_4160 * 2.0f);
                                                                      _5037 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5036, _5025), _4743);
                                                                      _5042 = 1.0f - _5022;
                                                                      _5048 = _5025 - (_4161 * 2.0f);
                                                                      _5049 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5036, _5048), _4743);
                                                                      _5054 = 1.0f - _5023;
                                                                      _5059 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_5024, _5048), _4743);
                                                                      _5070 = (0.5f - ((_4994 * 0.5f) * ((1.0f - _4998) - ((_4996 - _4998) * saturate(((1.0f / _4756) * (1.0f / _4977)) * ((((((((((((((((_4801 * _4799) + (_4805 * _4803)) + (_4811 * _4809)) + (_4817 * _4815)) + (_4852 * _4850)) + (_4858 * _4856)) + (_4864 * _4862)) + (_4870 * _4868)) + (_4905 * _4903)) + (_4911 * _4909)) + (_4917 * _4915)) + (_4923 * _4921)) + (_4958 * _4956)) + (_4964 * _4962)) + (_4970 * _4968)) + (_4976 * _4974)))))));
                                                                      _5071 = ((((mad(mad(_5037.x, _5042, _5037.y), _5023, mad(_5037.w, _5042, _5037.z)) + mad(mad(_5027.y, _5022, _5027.x), _5023, mad(_5027.z, _5022, _5027.w))) + mad(mad(_5049.w, _5042, _5049.z), _5054, mad(_5049.x, _5042, _5049.y))) + mad(mad(_5059.z, _5022, _5059.w), _5054, mad(_5059.y, _5022, _5059.x))) * 0.1111111119389534f);
                                                                      _5072 = (1.0f - (_5015 * _5015));
                                                                      _5073 = 1;
                                                                    } else {
                                                                      _5070 = 1.0f;
                                                                      _5071 = 0.0f;
                                                                      _5072 = 1.0f;
                                                                      _5073 = 0;
                                                                    }
                                                                  } else {
                                                                    _5070 = 1.0f;
                                                                    _5071 = 0.0f;
                                                                    _5072 = 1.0f;
                                                                    _5073 = 0;
                                                                  }
                                                                }
                                                              }
                                                              do {
                                                                _5863 = 1.0f;
                                                                _5864 = 1.0f;
                                                                _5865 = true;
                                                                [branch]
                                                                if (!((_1623 & 512) == 0)) {
                                                                  Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                                                                  [branch]
                                                                  if (!((_1623 & 2097152) == 0)) {
                                                                    _5081 = abs(_4225);
                                                                    _5082 = abs(_4226);
                                                                    _5083 = abs(_4227);
                                                                    do {
                                                                      if (_5081 > max(_5082, _5083)) {
                                                                        _5087 = (_4225 > 0.0f);
                                                                        _5102 = select(_5087, 0.0f, 1.0f);
                                                                        _5103 = 0.0f;
                                                                        _5104 = select(_5087, _4214, _4227);
                                                                        _5105 = _4217;
                                                                        _5106 = _5081;
                                                                      } else {
                                                                        if (_5082 > _5083) {
                                                                          _5093 = (_4217 < -0.0f);
                                                                          _5102 = select(_5093, 0.0f, 1.0f);
                                                                          _5103 = 1.0f;
                                                                          _5104 = _4225;
                                                                          _5105 = select(_5093, _4227, _4214);
                                                                          _5106 = _5082;
                                                                        } else {
                                                                          _5097 = (_4214 < -0.0f);
                                                                          _5102 = select(_5097, 0.0f, 1.0f);
                                                                          _5103 = 2.0f;
                                                                          _5104 = select(_5097, _4225, (-0.0f - _4225));
                                                                          _5105 = _4217;
                                                                          _5106 = _5083;
                                                                        }
                                                                      }
                                                                      _5107 = _5106 * 2.0f;
                                                                      _5112 = -0.0f - _4127;
                                                                      _5121 = ((min(max((_5104 / _5107), _5112), _4127) + _5102) * _4079) + _4081;
                                                                      _5122 = ((min(max((_5105 / _5107), _5112), _4127) + _5103) * _4080) + _4082;
                                                                      _5127 = ((_5102 + -0.5f) * _4079) + _4081;
                                                                      _5128 = ((_5103 + -0.5f) * _4080) + _4082;
                                                                      _5131 = saturate(1.0f - (_5106 * _4112));
                                                                      _5135 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _5144 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 4u);
                                                                      } else {
                                                                        _5144 = frac(frac(dot(float2(((_5135 * 32.665000915527344f) + _129), ((_5135 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _5144 = frac(frac(dot(float2(((_5135 * 32.665000915527344f) + _129), ((_5135 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _5145 = sin(_5144);
                                                                      _5146 = cos(_5144);
                                                                      _5151 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_5121, _5122), 0.0f))).x) > _5131), 1.0f, 0.0f);
                                                                      _5152 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _5157 = sqrt((float((int)(_5152)) * 0.25f) + 0.125f) * _4134;
                                                                      _5166 = (_global_7[min((uint)(((int)(0u + (_5152 * 2)))), 127u)]) * _5157;
                                                                      _5167 = (_global_7[min((uint)(((int)(1u + (_5152 * 2)))), 127u)]) * _5157;
                                                                      _5169 = -0.0f - _5145;
                                                                      _5171 = dot(float2(_5166, _5167), float2(_5146, _5145)) + _5121;
                                                                      _5172 = dot(float2(_5166, _5167), float2(_5169, _5146)) + _5122;
                                                                      _5174 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5171, _5172));
                                                                      _5178 = _5171 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _5179 = _5172 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _5182 = floor(_5127 * cbSharedPerViewData.vShadowAtlasSize.x);
                                                                      _5183 = floor(_5128 * cbSharedPerViewData.vShadowAtlasSize.y);
                                                                      _5188 = floor(((_5127 + _4079) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                                                                      _5189 = floor(((_5128 + _4080) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                                                                      _5192 = floor(_5178 + -0.5f);
                                                                      _5193 = floor(_5179 + 0.5f);
                                                                      _5195 = floor(_5178 + 0.5f);
                                                                      _5197 = floor(_5179 + -0.5f);
                                                                      _5198 = (_5192 < _5182);
                                                                      _5199 = (_5193 < _5183);
                                                                      do {
                                                                        if (!(_5198 || _5199)) {
                                                                          if ((_5192 >= _5188) || (_5193 >= _5189)) {
                                                                            _5208 = _5151;
                                                                          } else {
                                                                            _5208 = _5174.x;
                                                                          }
                                                                        } else {
                                                                          _5208 = _5151;
                                                                        }
                                                                        _5209 = (_5195 < _5182);
                                                                        do {
                                                                          if (!(_5209 || _5199)) {
                                                                            if ((_5195 >= _5188) || (_5193 >= _5189)) {
                                                                              _5217 = _5151;
                                                                            } else {
                                                                              _5217 = _5174.y;
                                                                            }
                                                                          } else {
                                                                            _5217 = _5151;
                                                                          }
                                                                          _5218 = (_5197 < _5183);
                                                                          do {
                                                                            if (!(_5209 || _5218)) {
                                                                              if ((_5195 >= _5188) || (_5197 >= _5189)) {
                                                                                _5226 = _5151;
                                                                              } else {
                                                                                _5226 = _5174.z;
                                                                              }
                                                                            } else {
                                                                              _5226 = _5151;
                                                                            }
                                                                            do {
                                                                              if (!(_5198 || _5218)) {
                                                                                if ((_5192 >= _5188) || (_5197 >= _5189)) {
                                                                                  _5234 = _5151;
                                                                                } else {
                                                                                  _5234 = _5174.w;
                                                                                }
                                                                              } else {
                                                                                _5234 = _5151;
                                                                              }
                                                                              _5235 = _5208 - _5131;
                                                                              _5237 = select((_5235 < 0.0f), 0.0f, 1.0f);
                                                                              _5239 = _5217 - _5131;
                                                                              _5241 = select((_5239 < 0.0f), 0.0f, 1.0f);
                                                                              _5245 = _5226 - _5131;
                                                                              _5247 = select((_5245 < 0.0f), 0.0f, 1.0f);
                                                                              _5251 = _5234 - _5131;
                                                                              _5253 = select((_5251 < 0.0f), 0.0f, 1.0f);
                                                                              _5260 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                              _5265 = sqrt((float((int)(_5260)) * 0.25f) + 0.125f) * _4134;
                                                                              _5274 = (_global_7[min((uint)(((int)(0u + (_5260 * 2)))), 127u)]) * _5265;
                                                                              _5275 = (_global_7[min((uint)(((int)(1u + (_5260 * 2)))), 127u)]) * _5265;
                                                                              _5278 = dot(float2(_5274, _5275), float2(_5146, _5145)) + _5121;
                                                                              _5279 = dot(float2(_5274, _5275), float2(_5169, _5146)) + _5122;
                                                                              _5281 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5278, _5279));
                                                                              _5285 = _5278 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _5286 = _5279 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _5289 = floor(_5285 + -0.5f);
                                                                              _5290 = floor(_5286 + 0.5f);
                                                                              _5292 = floor(_5285 + 0.5f);
                                                                              _5294 = floor(_5286 + -0.5f);
                                                                              _5295 = (_5289 < _5182);
                                                                              _5296 = (_5290 < _5183);
                                                                              do {
                                                                                if (!(_5295 || _5296)) {
                                                                                  if ((_5289 >= _5188) || (_5290 >= _5189)) {
                                                                                    _5305 = _5151;
                                                                                  } else {
                                                                                    _5305 = _5281.x;
                                                                                  }
                                                                                } else {
                                                                                  _5305 = _5151;
                                                                                }
                                                                                _5306 = (_5292 < _5182);
                                                                                do {
                                                                                  if (!(_5306 || _5296)) {
                                                                                    if ((_5292 >= _5188) || (_5290 >= _5189)) {
                                                                                      _5314 = _5151;
                                                                                    } else {
                                                                                      _5314 = _5281.y;
                                                                                    }
                                                                                  } else {
                                                                                    _5314 = _5151;
                                                                                  }
                                                                                  _5315 = (_5294 < _5183);
                                                                                  do {
                                                                                    if (!(_5306 || _5315)) {
                                                                                      if ((_5292 >= _5188) || (_5294 >= _5189)) {
                                                                                        _5323 = _5151;
                                                                                      } else {
                                                                                        _5323 = _5281.z;
                                                                                      }
                                                                                    } else {
                                                                                      _5323 = _5151;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_5295 || _5315)) {
                                                                                        if ((_5289 >= _5188) || (_5294 >= _5189)) {
                                                                                          _5331 = _5151;
                                                                                        } else {
                                                                                          _5331 = _5281.w;
                                                                                        }
                                                                                      } else {
                                                                                        _5331 = _5151;
                                                                                      }
                                                                                      _5332 = _5305 - _5131;
                                                                                      _5334 = select((_5332 < 0.0f), 0.0f, 1.0f);
                                                                                      _5338 = _5314 - _5131;
                                                                                      _5340 = select((_5338 < 0.0f), 0.0f, 1.0f);
                                                                                      _5344 = _5323 - _5131;
                                                                                      _5346 = select((_5344 < 0.0f), 0.0f, 1.0f);
                                                                                      _5350 = _5331 - _5131;
                                                                                      _5352 = select((_5350 < 0.0f), 0.0f, 1.0f);
                                                                                      _5359 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                      _5364 = sqrt((float((int)(_5359)) * 0.25f) + 0.125f) * _4134;
                                                                                      _5373 = (_global_7[min((uint)(((int)(0u + (_5359 * 2)))), 127u)]) * _5364;
                                                                                      _5374 = (_global_7[min((uint)(((int)(1u + (_5359 * 2)))), 127u)]) * _5364;
                                                                                      _5377 = dot(float2(_5373, _5374), float2(_5146, _5145)) + _5121;
                                                                                      _5378 = dot(float2(_5373, _5374), float2(_5169, _5146)) + _5122;
                                                                                      _5380 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5377, _5378));
                                                                                      _5384 = _5377 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _5385 = _5378 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _5388 = floor(_5384 + -0.5f);
                                                                                      _5389 = floor(_5385 + 0.5f);
                                                                                      _5391 = floor(_5384 + 0.5f);
                                                                                      _5393 = floor(_5385 + -0.5f);
                                                                                      _5394 = (_5388 < _5182);
                                                                                      _5395 = (_5389 < _5183);
                                                                                      do {
                                                                                        if (!(_5394 || _5395)) {
                                                                                          if ((_5388 >= _5188) || (_5389 >= _5189)) {
                                                                                            _5404 = _5151;
                                                                                          } else {
                                                                                            _5404 = _5380.x;
                                                                                          }
                                                                                        } else {
                                                                                          _5404 = _5151;
                                                                                        }
                                                                                        _5405 = (_5391 < _5182);
                                                                                        do {
                                                                                          if (!(_5405 || _5395)) {
                                                                                            if ((_5391 >= _5188) || (_5389 >= _5189)) {
                                                                                              _5413 = _5151;
                                                                                            } else {
                                                                                              _5413 = _5380.y;
                                                                                            }
                                                                                          } else {
                                                                                            _5413 = _5151;
                                                                                          }
                                                                                          _5414 = (_5393 < _5183);
                                                                                          do {
                                                                                            if (!(_5405 || _5414)) {
                                                                                              if ((_5391 >= _5188) || (_5393 >= _5189)) {
                                                                                                _5422 = _5151;
                                                                                              } else {
                                                                                                _5422 = _5380.z;
                                                                                              }
                                                                                            } else {
                                                                                              _5422 = _5151;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_5394 || _5414)) {
                                                                                                if ((_5388 >= _5188) || (_5393 >= _5189)) {
                                                                                                  _5430 = _5151;
                                                                                                } else {
                                                                                                  _5430 = _5380.w;
                                                                                                }
                                                                                              } else {
                                                                                                _5430 = _5151;
                                                                                              }
                                                                                              _5431 = _5404 - _5131;
                                                                                              _5433 = select((_5431 < 0.0f), 0.0f, 1.0f);
                                                                                              _5437 = _5413 - _5131;
                                                                                              _5439 = select((_5437 < 0.0f), 0.0f, 1.0f);
                                                                                              _5443 = _5422 - _5131;
                                                                                              _5445 = select((_5443 < 0.0f), 0.0f, 1.0f);
                                                                                              _5449 = _5430 - _5131;
                                                                                              _5451 = select((_5449 < 0.0f), 0.0f, 1.0f);
                                                                                              _5458 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                              _5463 = sqrt((float((int)(_5458)) * 0.25f) + 0.125f) * _4134;
                                                                                              _5472 = (_global_7[min((uint)(((int)(0u + (_5458 * 2)))), 127u)]) * _5463;
                                                                                              _5473 = (_global_7[min((uint)(((int)(1u + (_5458 * 2)))), 127u)]) * _5463;
                                                                                              _5476 = dot(float2(_5472, _5473), float2(_5146, _5145)) + _5121;
                                                                                              _5477 = dot(float2(_5472, _5473), float2(_5169, _5146)) + _5122;
                                                                                              _5479 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5476, _5477));
                                                                                              _5483 = _5476 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                              _5484 = _5477 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                              _5487 = floor(_5483 + -0.5f);
                                                                                              _5488 = floor(_5484 + 0.5f);
                                                                                              _5490 = floor(_5483 + 0.5f);
                                                                                              _5492 = floor(_5484 + -0.5f);
                                                                                              _5493 = (_5487 < _5182);
                                                                                              _5494 = (_5488 < _5183);
                                                                                              do {
                                                                                                if (!(_5493 || _5494)) {
                                                                                                  if ((_5487 >= _5188) || (_5488 >= _5189)) {
                                                                                                    _5503 = _5151;
                                                                                                  } else {
                                                                                                    _5503 = _5479.x;
                                                                                                  }
                                                                                                } else {
                                                                                                  _5503 = _5151;
                                                                                                }
                                                                                                _5504 = (_5490 < _5182);
                                                                                                do {
                                                                                                  if (!(_5504 || _5494)) {
                                                                                                    if ((_5490 >= _5188) || (_5488 >= _5189)) {
                                                                                                      _5512 = _5151;
                                                                                                    } else {
                                                                                                      _5512 = _5479.y;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _5512 = _5151;
                                                                                                  }
                                                                                                  _5513 = (_5492 < _5183);
                                                                                                  do {
                                                                                                    if (!(_5504 || _5513)) {
                                                                                                      if ((_5490 >= _5188) || (_5492 >= _5189)) {
                                                                                                        _5521 = _5151;
                                                                                                      } else {
                                                                                                        _5521 = _5479.z;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _5521 = _5151;
                                                                                                    }
                                                                                                    do {
                                                                                                      if (!(_5493 || _5513)) {
                                                                                                        if ((_5487 >= _5188) || (_5492 >= _5189)) {
                                                                                                          _5529 = _5151;
                                                                                                        } else {
                                                                                                          _5529 = _5479.w;
                                                                                                        }
                                                                                                      } else {
                                                                                                        _5529 = _5151;
                                                                                                      }
                                                                                                      _5530 = _5503 - _5131;
                                                                                                      _5532 = select((_5530 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5536 = _5512 - _5131;
                                                                                                      _5538 = select((_5536 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5542 = _5521 - _5131;
                                                                                                      _5544 = select((_5542 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5548 = _5529 - _5131;
                                                                                                      _5550 = select((_5548 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5551 = ((((((((((((((_5241 + _5237) + _5247) + _5253) + _5334) + _5340) + _5346) + _5352) + _5433) + _5439) + _5445) + _5451) + _5532) + _5538) + _5544) + _5550;
                                                                                                      _5562 = (saturate(_5551 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                      _5568 = float((int)(((int)(uint)((int)(_5562 > 0.0f))) - ((int)(uint)((int)(_5562 < 0.0f)))));
                                                                                                      _5570 = 1.0f - (_5568 * _5562);
                                                                                                      _5572 = (_5570 * _5570) * _5570;
                                                                                                      _5863 = (0.5f - ((_5568 * 0.5f) * ((1.0f - _5572) - ((_5570 - _5572) * saturate(((1.0f / _5131) * (1.0f / _5551)) * ((((((((((((((((_5241 * _5239) + (_5237 * _5235)) + (_5247 * _5245)) + (_5253 * _5251)) + (_5334 * _5332)) + (_5340 * _5338)) + (_5346 * _5344)) + (_5352 * _5350)) + (_5433 * _5431)) + (_5439 * _5437)) + (_5445 * _5443)) + (_5451 * _5449)) + (_5532 * _5530)) + (_5538 * _5536)) + (_5544 * _5542)) + (_5550 * _5548)))))));
                                                                                                      _5864 = 1.0f;
                                                                                                      _5865 = false;
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
                                                                    _5581 = f16tof32(((uint)((uint)(_4094) >> 16))) / _4227;
                                                                    _5584 = mad((_5581 * _4225), 0.5f, 0.5f);
                                                                    _5585 = mad((_5581 * _4226), 0.5f, 0.5f);
                                                                    if (_4214 > -0.0f) {
                                                                      if ((saturate(_5584) == _5584) && (saturate(_5585) == _5585)) {
                                                                        _5598 = (_5584 * _4079) + _4081;
                                                                        _5599 = (_5585 * _4080) + _4082;
                                                                        _5600 = saturate(1.0f - (_4214 * _4112));
                                                                        _5604 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                        #if FIRSTLIGHT_ISFAST_ENABLED
                                                                        if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                          _5613 = RenoDX_ISFASTShadowAngle(
                                                                              uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 5u);
                                                                        } else {
                                                                          _5613 = frac(frac(dot(float2(((_5604 * 32.665000915527344f) + _129), ((_5604 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                        }
                                                                        #else
                                                                        _5613 = frac(frac(dot(float2(((_5604 * 32.665000915527344f) + _129), ((_5604 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                        #endif
                                                                        _5614 = sin(_5613);
                                                                        _5615 = cos(_5613);
                                                                        _5616 = cbSharedPerViewData.nFrameCounter & 3;
                                                                        _5621 = sqrt((float((int)(_5616)) * 0.25f) + 0.125f) * _4134;
                                                                        _5630 = (_global_7[min((uint)(((int)(0u + (_5616 * 2)))), 127u)]) * _5621;
                                                                        _5631 = (_global_7[min((uint)(((int)(1u + (_5616 * 2)))), 127u)]) * _5621;
                                                                        _5633 = -0.0f - _5614;
                                                                        _5638 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5630, _5631), float2(_5615, _5614)) + _5598), (dot(float2(_5630, _5631), float2(_5633, _5615)) + _5599)));
                                                                        _5643 = _5638.x - _5600;
                                                                        _5645 = select((_5643 < 0.0f), 0.0f, 1.0f);
                                                                        _5647 = _5638.y - _5600;
                                                                        _5649 = select((_5647 < 0.0f), 0.0f, 1.0f);
                                                                        _5653 = _5638.z - _5600;
                                                                        _5655 = select((_5653 < 0.0f), 0.0f, 1.0f);
                                                                        _5659 = _5638.w - _5600;
                                                                        _5661 = select((_5659 < 0.0f), 0.0f, 1.0f);
                                                                        _5668 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                        _5673 = sqrt((float((int)(_5668)) * 0.25f) + 0.125f) * _4134;
                                                                        _5682 = (_global_7[min((uint)(((int)(0u + (_5668 * 2)))), 127u)]) * _5673;
                                                                        _5683 = (_global_7[min((uint)(((int)(1u + (_5668 * 2)))), 127u)]) * _5673;
                                                                        _5689 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5682, _5683), float2(_5615, _5614)) + _5598), (dot(float2(_5682, _5683), float2(_5633, _5615)) + _5599)));
                                                                        _5694 = _5689.x - _5600;
                                                                        _5696 = select((_5694 < 0.0f), 0.0f, 1.0f);
                                                                        _5700 = _5689.y - _5600;
                                                                        _5702 = select((_5700 < 0.0f), 0.0f, 1.0f);
                                                                        _5706 = _5689.z - _5600;
                                                                        _5708 = select((_5706 < 0.0f), 0.0f, 1.0f);
                                                                        _5712 = _5689.w - _5600;
                                                                        _5714 = select((_5712 < 0.0f), 0.0f, 1.0f);
                                                                        _5721 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                        _5726 = sqrt((float((int)(_5721)) * 0.25f) + 0.125f) * _4134;
                                                                        _5735 = (_global_7[min((uint)(((int)(0u + (_5721 * 2)))), 127u)]) * _5726;
                                                                        _5736 = (_global_7[min((uint)(((int)(1u + (_5721 * 2)))), 127u)]) * _5726;
                                                                        _5742 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5735, _5736), float2(_5615, _5614)) + _5598), (dot(float2(_5735, _5736), float2(_5633, _5615)) + _5599)));
                                                                        _5747 = _5742.x - _5600;
                                                                        _5749 = select((_5747 < 0.0f), 0.0f, 1.0f);
                                                                        _5753 = _5742.y - _5600;
                                                                        _5755 = select((_5753 < 0.0f), 0.0f, 1.0f);
                                                                        _5759 = _5742.z - _5600;
                                                                        _5761 = select((_5759 < 0.0f), 0.0f, 1.0f);
                                                                        _5765 = _5742.w - _5600;
                                                                        _5767 = select((_5765 < 0.0f), 0.0f, 1.0f);
                                                                        _5774 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                        _5779 = sqrt((float((int)(_5774)) * 0.25f) + 0.125f) * _4134;
                                                                        _5788 = (_global_7[min((uint)(((int)(0u + (_5774 * 2)))), 127u)]) * _5779;
                                                                        _5789 = (_global_7[min((uint)(((int)(1u + (_5774 * 2)))), 127u)]) * _5779;
                                                                        _5795 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5788, _5789), float2(_5615, _5614)) + _5598), (dot(float2(_5788, _5789), float2(_5633, _5615)) + _5599)));
                                                                        _5800 = _5795.x - _5600;
                                                                        _5802 = select((_5800 < 0.0f), 0.0f, 1.0f);
                                                                        _5806 = _5795.y - _5600;
                                                                        _5808 = select((_5806 < 0.0f), 0.0f, 1.0f);
                                                                        _5812 = _5795.z - _5600;
                                                                        _5814 = select((_5812 < 0.0f), 0.0f, 1.0f);
                                                                        _5818 = _5795.w - _5600;
                                                                        _5820 = select((_5818 < 0.0f), 0.0f, 1.0f);
                                                                        _5821 = ((((((((((((((_5645 + _5649) + _5655) + _5661) + _5696) + _5702) + _5708) + _5714) + _5749) + _5755) + _5761) + _5767) + _5802) + _5808) + _5814) + _5820;
                                                                        _5832 = (saturate(_5821 * 0.0625f) * 2.0f) + -1.0f;
                                                                        _5838 = float((int)(((int)(uint)((int)(_5832 > 0.0f))) - ((int)(uint)((int)(_5832 < 0.0f)))));
                                                                        _5840 = 1.0f - (_5838 * _5832);
                                                                        _5842 = (_5840 * _5840) * _5840;
                                                                        _5850 = -0.0f - _4225;
                                                                        _5857 = saturate((saturate(rsqrt(dot(float3(_5850, _4217, _4214), float3(_5850, _4217, _4214))) * _4214) * _4110) + _4109);
                                                                        _5859 = 1.0f - (_5857 * _5857);
                                                                        _5863 = (0.5f - ((_5838 * 0.5f) * ((1.0f - _5842) - ((_5840 - _5842) * saturate(((1.0f / _5600) * (1.0f / _5821)) * ((((((((((((((((_5645 * _5643) + (_5649 * _5647)) + (_5655 * _5653)) + (_5661 * _5659)) + (_5696 * _5694)) + (_5702 * _5700)) + (_5708 * _5706)) + (_5714 * _5712)) + (_5749 * _5747)) + (_5755 * _5753)) + (_5761 * _5759)) + (_5767 * _5765)) + (_5802 * _5800)) + (_5808 * _5806)) + (_5814 * _5812)) + (_5820 * _5818)))))));
                                                                        _5864 = (1.0f - (_5859 * _5859));
                                                                        _5865 = false;
                                                                      } else {
                                                                        _5863 = 1.0f;
                                                                        _5864 = 1.0f;
                                                                        _5865 = true;
                                                                      }
                                                                    } else {
                                                                      _5863 = 1.0f;
                                                                      _5864 = 1.0f;
                                                                      _5865 = true;
                                                                    }
                                                                  }
                                                                }
                                                                do {
                                                                  if (_5073 == 0) {
                                                                    if (!(_5865)) {
                                                                      _5883 = _5070;
                                                                      _5884 = ((_5864 * (_5863 + -1.0f)) + 1.0f);
                                                                      _5885 = 0.0f;
                                                                      _5886 = _5071;
                                                                    } else {
                                                                      _5883 = _5070;
                                                                      _5884 = _5863;
                                                                      _5885 = 0.0f;
                                                                      _5886 = _5071;
                                                                    }
                                                                  } else {
                                                                    if (_5865) {
                                                                      _5883 = ((_5072 * (_5070 + -1.0f)) + 1.0f);
                                                                      _5884 = _5863;
                                                                      _5885 = 1.0f;
                                                                      _5886 = ((_5072 * (_5071 + -1.0f)) + 1.0f);
                                                                    } else {
                                                                      _5883 = _5070;
                                                                      _5884 = _5863;
                                                                      _5885 = (_5072 * f16tof32(_4064));
                                                                      _5886 = _5071;
                                                                    }
                                                                  }
                                                                  _5889 = (_5885 * (_5883 - _5884)) + _5884;
                                                                  do {
                                                                    _6066 = _5889;
                                                                    [branch]
                                                                    if (!((_1623 & 2048) == 0)) {
                                                                      _5891 = _244 - _4039;
                                                                      _5892 = _245 - _4040;
                                                                      _5893 = _246 - _4041;
                                                                      _5908 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5893, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5892, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5891)));
                                                                      _5911 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _5893, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _5892, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _5891)));
                                                                      _5914 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _5893, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _5892, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _5891)));
                                                                      _5916 = rsqrt(dot(float3(_5908, _5911, _5914), float3(_5908, _5911, _5914)));
                                                                      _5917 = _5916 * _5908;
                                                                      _5918 = _5916 * _5911;
                                                                      _5919 = _5916 * _5914;
                                                                      Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_4070) >> 16))];
                                                                      _5927 = (abs(_5918) + abs(_5917)) + abs(_5919);
                                                                      _5928 = _5917 / _5927;
                                                                      _5929 = _5918 / _5927;
                                                                      _5931 = !((_5919 / _5927) >= 0.0f);
                                                                      do {
                                                                        _5944 = _5928;
                                                                        _5945 = _5929;
                                                                        if (_5931) {
                                                                          _5944 = ((1.0f - abs(_5929)) * select((_5928 >= 0.0f), 1.0f, -1.0f));
                                                                          _5945 = ((1.0f - abs(_5928)) * select((_5929 >= 0.0f), 1.0f, -1.0f));
                                                                        }
                                                                        _5951 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5944 * 0.5f) + 0.5f), ((_5945 * 0.5f) + 0.5f)), 0.0f);
                                                                        if (_5951.x > 0.0f) {
                                                                          Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_4070 & 65535))];
                                                                          do {
                                                                            _5970 = _5928;
                                                                            _5971 = _5929;
                                                                            if (_5931) {
                                                                              _5970 = ((1.0f - abs(_5929)) * select((_5928 >= 0.0f), 1.0f, -1.0f));
                                                                              _5971 = ((1.0f - abs(_5928)) * select((_5929 >= 0.0f), 1.0f, -1.0f));
                                                                            }
                                                                            _5976 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5970 * 0.5f) + 0.5f), ((_5971 * 0.5f) + 0.5f)), 0.0f);
                                                                            _5996 = mad(saturate(((log2(sqrt(((_5891 * _5891) + (_5892 * _5892)) + (_5893 * _5893))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                            _5997 = max(9.999999747378752e-06f, _5951.x);
                                                                            _5998 = _5976.x / _5997;
                                                                            _5999 = _5976.y / _5997;
                                                                            _6001 = _5976.w / _5997;
                                                                            _6006 = ((0.375f - _5999) * 4.999999873689376e-06f) + _5999;
                                                                            _6009 = -0.0f - _5998;
                                                                            _6010 = mad(_6009, _6006, (_5976.z / _5997));
                                                                            _6012 = 1.0f / mad(_6009, _5998, _6006);
                                                                            _6013 = _6012 * _6010;
                                                                            _6018 = _5996 - _5998;
                                                                            _6023 = (((_5996 * _5996) - _6006) - (_6013 * _6018)) / mad((-0.0f - _6010), _6013, mad((-0.0f - _6006), _6006, (((0.375f - _6001) * 4.999999873689376e-06f) + _6001)));
                                                                            _6025 = (_6012 * _6018) - (_6023 * _6013);
                                                                            _6028 = 1.0f / _6023;
                                                                            _6029 = _6025 * _6028;
                                                                            _6034 = sqrt(((_6029 * _6029) * 0.25f) - ((1.0f - dot(float2(_6025, _6023), float2(_5998, _6006))) * _6028));
                                                                            _6036 = (_6029 * -0.5f) - _6034;
                                                                            _6038 = _6034 - (_6029 * 0.5f);
                                                                            _6040 = select((_6036 < _5996), 1.0f, 0.0f);
                                                                            _6045 = (_6040 + -0.05000000074505806f) / (_6036 - _5996);
                                                                            _6051 = (((select((_6038 < _5996), 1.0f, 0.0f) - _6040) / (_6038 - _6036)) - _6045) / (_6038 - _5996);
                                                                            _6053 = _6045 - (_6051 * _6036);
                                                                            _6066 = (exp2((_5951.x * -1.4426950216293335f) * saturate((dot(float2(_5998, _6006), float2((_6053 - (_6051 * _5996)), _6051)) + 0.05000000074505806f) - (_6053 * _5996))) * _5889);
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } else {
                                                                          _6066 = _5889;
                                                                        }
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    }
                                                                    _6072 = (_6066 * _4188);
                                                                    _6073 = (lerp(_6066, _5886, _5885));
                                                                    _6074 = _5885;
                                                                    _6075 = _6066;
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
                                                            _6095 = _4096;
                                                            _6096 = _4097;
                                                            _6097 = _4099;
                                                            [branch]
                                                            if (!(_4115 == 0)) {
                                                              TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _4115)))];
                                                              _6087 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_4167, _4034, mad(_4166, _4029, (_4165 * _4024)))), (-0.0f - mad(_4167, _4035, mad(_4166, _4030, (_4165 * _4025)))), (-0.0f - mad(_4167, _4036, mad(_4166, _4031, (_4165 * _4026))))), 0.0f);
                                                              _6095 = (_6087.x * _4096);
                                                              _6096 = (_6087.y * _4097);
                                                              _6097 = (_6087.z * _4099);
                                                            }
                                                            _6098 = _6073 * _4188;
                                                            [branch]
                                                            if (!(_6072 == 0.0f)) {
                                                              do {
                                                                _6116 = GetDeferredSoftShadowChannel(_1626);
                                                                if (_6116 < 0) {
                                                                      _6137 = _6072;
                                                                      do {
                                                                        _9584 = _1611;
                                                                        _9585 = _1612;
                                                                        _9586 = _1613;
                                                                        _9587 = _1614;
                                                                        _9588 = _1615;
                                                                        _9589 = _1616;
                                                                        [branch]
                                                                        if (!(_6137 == 0.0f)) {
                                                                          do {
                                                                            _6244 = _6095;
                                                                            _6245 = _6096;
                                                                            _6246 = _6097;
                                                                            [branch]
                                                                            if (!(((_4073 & 1) == 0) || (!_4219))) {
                                                                              _6154 = max(max(_6095, _6096), _6097);
                                                                              do {
                                                                                _6164 = _6095;
                                                                                _6165 = _6096;
                                                                                _6166 = _6097;
                                                                                if (_6154 > 0.0f) {
                                                                                  _6164 = saturate(_6095 / _6154);
                                                                                  _6165 = saturate(_6096 / _6154);
                                                                                  _6166 = saturate(_6097 / _6154);
                                                                                }
                                                                                _6167 = (_6165 < _6166);
                                                                                _6168 = select(_6167, _6166, _6165);
                                                                                _6169 = select(_6167, _6165, _6166);
                                                                                _6170 = select(_6167, -1.0f, 0.0f);
                                                                                _6171 = (_6164 < _6168);
                                                                                _6173 = select(_6171, _6168, _6164);
                                                                                _6174 = select(_6171, _6164, _6168);
                                                                                _6178 = _6173 - select((_6174 < _6169), _6174, _6169);
                                                                                _6184 = abs(select(_6171, (-0.3333333432674408f - _6170), _6170) + ((_6174 - _6169) / ((_6178 * 6.0f) + 9.999999682655225e-21f)));
                                                                                do {
                                                                                  _6197 = _6184;
                                                                                  if (_6184 < 0.6666666865348816f) {
                                                                                    _6197 = ((saturate(((float)((uint)((uint)(((uint)(_4073) >> 9) & 255)))) * 0.003921499941498041f) * (select((_6184 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _6184)) + _6184);
                                                                                  }
                                                                                  _6198 = saturate((_6178 / (_6173 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_4073) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                  _6199 = saturate(_6173);
                                                                                  do {
                                                                                    _6226 = _6199;
                                                                                    _6227 = _6199;
                                                                                    _6228 = _6199;
                                                                                    if (!(_6198 <= 0.0f)) {
                                                                                      _6202 = saturate(_6197);
                                                                                      _6206 = select(((_6202 * 360.0f) >= 360.0f), 0.0f, (_6202 * 6.0f));
                                                                                      _6207 = int(_6206);
                                                                                      _6209 = _6206 - float((int)(_6207));
                                                                                      _6211 = _6199 * (1.0f - _6198);
                                                                                      _6214 = (1.0f - (_6209 * _6198)) * _6199;
                                                                                      _6218 = (1.0f - ((1.0f - _6209) * _6198)) * _6199;
                                                                                      switch (_6207) {
                                                                                        case 0: {
                                                                                          _6226 = _6199;
                                                                                          _6227 = _6218;
                                                                                          _6228 = _6211;
                                                                                          break;
                                                                                        }
                                                                                        case 1: {
                                                                                          _6226 = _6214;
                                                                                          _6227 = _6199;
                                                                                          _6228 = _6211;
                                                                                          break;
                                                                                        }
                                                                                        case 2: {
                                                                                          _6226 = _6211;
                                                                                          _6227 = _6199;
                                                                                          _6228 = _6218;
                                                                                          break;
                                                                                        }
                                                                                        case 3: {
                                                                                          _6226 = _6211;
                                                                                          _6227 = _6214;
                                                                                          _6228 = _6199;
                                                                                          break;
                                                                                        }
                                                                                        case 4: {
                                                                                          _6226 = _6218;
                                                                                          _6227 = _6211;
                                                                                          _6228 = _6199;
                                                                                          break;
                                                                                        }
                                                                                        case 5: {
                                                                                          _6226 = _6199;
                                                                                          _6227 = _6211;
                                                                                          _6228 = _6214;
                                                                                          break;
                                                                                        }
                                                                                        default: {
                                                                                          _6226 = 0.0f;
                                                                                          _6227 = 0.0f;
                                                                                          _6228 = 0.0f;
                                                                                          break;
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                    _6229 = _6226 * _6154;
                                                                                    _6230 = _6227 * _6154;
                                                                                    _6231 = _6228 * _6154;
                                                                                    _6233 = saturate(_6075 * 1.0101009607315063f);
                                                                                    _6244 = ((_6233 * (_6095 - _6229)) + _6229);
                                                                                    _6245 = ((_6233 * (_6096 - _6230)) + _6230);
                                                                                    _6246 = (lerp(_6231, _6097, _6233));
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            }
                                                                            do {
                                                                              _6286 = _6098;
                                                                              _6287 = _6098;
                                                                              [branch]
                                                                              if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                _6253 = srvLightMappingData[_1626];
                                                                                if (!(_6253 == -1)) {
                                                                                  _6258 = srvLightIndexData[_6253].nLayerIndex;
                                                                                  _6260 = srvLightIndexData[_6253].vAtlasOrigin.x;
                                                                                  _6261 = srvLightIndexData[_6253].vAtlasOrigin.y;
                                                                                  _6263 = srvLightIndexData[_6253].vScreenOrigin.x;
                                                                                  _6264 = srvLightIndexData[_6253].vScreenOrigin.y;
                                                                                  _6273 = ((int)(_6258 * 5)) & 31;
                                                                                  _6276 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6260 + _67) - _6263)), ((int)((_6261 + _68) - _6264)), 0)))).x) & ((int)(31 << _6273)))) >> _6273;
                                                                                  _6286 = ((_6098 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_6276) >> 1)))));
                                                                                  _6287 = (((float)((bool)(uint)((_6276 & 1) != 0))) * _6098);
                                                                                } else {
                                                                                  _6286 = _6098;
                                                                                  _6287 = _6098;
                                                                                }
                                                                              }
                                                                              _6291 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                              _6294 = select(_6291, (_6286 * _1276), _6286);
                                                                              _6296 = _4171 * _4170;
                                                                              _6297 = _4172 * _4170;
                                                                              _6298 = _4173 * _4170;
                                                                              _6299 = _4104 * _4044;
                                                                              _6300 = _4104 * _4045;
                                                                              _6301 = _4104 * _4046;
                                                                              _6302 = _6296 + _6299;
                                                                              _6303 = _6297 + _6300;
                                                                              _6304 = _6298 + _6301;
                                                                              _6306 = -0.0f - _458;
                                                                              _6307 = -0.0f - _459;
                                                                              _6308 = -0.0f - _457;
                                                                              do {
                                                                                _6368 = _6302;
                                                                                _6369 = _6303;
                                                                                _6370 = _6304;
                                                                                if (_4104 > 0.0f) {
                                                                                  _6314 = dot(float3(_6306, _6307, _6308), float3(_205, _207, _209)) * 2.0f;
                                                                                  _6318 = _6306 - (_6314 * _205);
                                                                                  _6319 = _6307 - (_6314 * _207);
                                                                                  _6320 = _6308 - (_6314 * _209);
                                                                                  _6321 = (_6296 - _6299) - _6302;
                                                                                  _6322 = (_6297 - _6300) - _6303;
                                                                                  _6323 = (_6298 - _6301) - _6304;
                                                                                  _6324 = dot(float3(_6318, _6319, _6320), float3(_6321, _6322, _6323));
                                                                                  _6330 = sqrt(((_6321 * _6321) + (_6322 * _6322)) + (_6323 * _6323));
                                                                                  _6339 = saturate(((dot(float3(_6318, _6319, _6320), float3(_6302, _6303, _6304)) * _6324) - dot(float3(_6302, _6303, _6304), float3(_6321, _6322, _6323))) / ((_6330 * _6330) - (_6324 * _6324)));
                                                                                  _6343 = (_6339 * _6321) + _6302;
                                                                                  _6344 = (_6339 * _6322) + _6303;
                                                                                  _6345 = (_6339 * _6323) + _6304;
                                                                                  _6346 = dot(float3(_6343, _6344, _6345), float3(_6318, _6319, _6320));
                                                                                  _6350 = (_6346 * _6318) - _6343;
                                                                                  _6351 = (_6346 * _6319) - _6344;
                                                                                  _6352 = (_6346 * _6320) - _6345;
                                                                                  _6360 = saturate(0.009999999776482582f / sqrt(((_6350 * _6350) + (_6351 * _6351)) + (_6352 * _6352)));
                                                                                  _6368 = ((_6360 * _6350) + _6343);
                                                                                  _6369 = ((_6360 * _6351) + _6344);
                                                                                  _6370 = ((_6360 * _6352) + _6345);
                                                                                }
                                                                                _6372 = rsqrt(dot(float3(_6368, _6369, _6370), float3(_6368, _6369, _6370)));
                                                                                _6373 = _6372 * _6368;
                                                                                _6374 = _6372 * _6369;
                                                                                _6375 = _6372 * _6370;
                                                                                _6377 = rsqrt(dot(float3(_6296, _6297, _6298), float3(_6296, _6297, _6298)));
                                                                                _6378 = _6377 * _6296;
                                                                                _6379 = _6377 * _6297;
                                                                                _6380 = _6377 * _6298;
                                                                                _6382 = saturate(dot(float3(_205, _207, _209), float3(_6378, _6379, _6380)));
                                                                                _6385 = uint((_180 * 255.0f) + 0.5f);
                                                                                _6394 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                                                _6395 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                                                _6396 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                                                _6409 = ((dot(float3(_206, _208, _210), float3(_6378, _6379, _6380)) + dot(float3(_6306, _6307, _6308), float3(_6378, _6379, _6380))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_6385) >> 2)))) * 0.1666666716337204f)));
                                                                                _6416 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                                                _6419 = saturate((_6416 + -0.009999999776482582f) * -100.0f);
                                                                                _6424 = ((_6419 * _6419) * 3.0f) * (3.0f - (_6419 * 2.0f));
                                                                                _6431 = 10.0f - (exp2(log2(saturate(_6416 * 5.0f)) * 3.0f) * 9.0f);
                                                                                _6432 = saturate(_6382 + _6394) * _6382;
                                                                                _6433 = saturate(_6382 + _6395) * _6382;
                                                                                _6434 = saturate(_6382 + _6396) * _6382;
                                                                                _6456 = _6373 + _458;
                                                                                _6457 = _6374 + _459;
                                                                                _6458 = _6375 + _457;
                                                                                _6460 = rsqrt(dot(float3(_6456, _6457, _6458), float3(_6456, _6457, _6458)));
                                                                                do {
                                                                                  _6764 = 0.0f;
                                                                                  _6765 = 0.0f;
                                                                                  _6766 = 0.0f;
                                                                                  if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                                    _6475 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                                    _6476 = _6475 * _205;
                                                                                    _6477 = _6475 * _207;
                                                                                    _6478 = _6475 * _209;
                                                                                    _6481 = (abs(_6476) < abs(_6477));
                                                                                    _6482 = select(_6481, 1.0f, 0.0f);
                                                                                    _6483 = select(_6481, 0.0f, 1.0f);
                                                                                    _6484 = _6483 * _6478;
                                                                                    _6486 = -0.0f - (_6478 * _6482);
                                                                                    _6489 = (_6482 * _6477) - (_6483 * _6476);
                                                                                    _6491 = rsqrt(dot(float3(_6484, _6486, _6489), float3(_6484, _6486, _6489)));
                                                                                    _6492 = _6484 * _6491;
                                                                                    _6493 = _6491 * _6486;
                                                                                    _6494 = _6489 * _6491;
                                                                                    _6497 = (_6493 * _6478) - (_6494 * _6477);
                                                                                    _6500 = (_6494 * _6476) - (_6492 * _6478);
                                                                                    _6503 = (_6492 * _6477) - (_6493 * _6476);
                                                                                    _6505 = rsqrt(dot(float3(_6497, _6500, _6503), float3(_6497, _6500, _6503)));
                                                                                    _6509 = _178 * 4.0f;
                                                                                    _6518 = saturate(abs(_6509 + -2.5f) + -0.5f) + -0.5f;
                                                                                    _6519 = saturate(1.5f - abs(_6509 + -1.5f)) + -0.5f;
                                                                                    _6521 = rsqrt(dot(float2(_6518, _6519), float2(_6518, _6519)));
                                                                                    _6522 = _6521 * _6518;
                                                                                    _6523 = _6521 * _6519;
                                                                                    _6530 = ((_6497 * _6505) * _6522) + (_6523 * _6492);
                                                                                    _6531 = ((_6500 * _6505) * _6522) + (_6523 * _6493);
                                                                                    _6532 = ((_6503 * _6505) * _6522) + (_6523 * _6494);
                                                                                    _6533 = dot(float3(_458, _459, _457), float3(_6373, _6374, _6375));
                                                                                    _6536 = min(max(dot(float3(_6530, _6531, _6532), float3(_6373, _6374, _6375)), -1.0f), 1.0f);
                                                                                    _6539 = min(max(dot(float3(_6530, _6531, _6532), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                                    _6540 = abs(_6539);
                                                                                    _6545 = (1.5707963705062866f - (_6540 * 0.1565829962491989f)) * sqrt(1.0f - _6540);
                                                                                    _6549 = abs(_6536);
                                                                                    _6554 = (1.5707963705062866f - (_6549 * 0.1565829962491989f)) * sqrt(1.0f - _6549);
                                                                                    _6561 = cos(abs(select((_6536 >= 0.0f), _6554, (3.1415927410125732f - _6554)) - select((_6539 >= 0.0f), _6545, (3.1415927410125732f - _6545))) * 0.5f);
                                                                                    _6565 = _6373 - (_6536 * _6530);
                                                                                    _6566 = _6374 - (_6536 * _6531);
                                                                                    _6567 = _6375 - (_6536 * _6532);
                                                                                    _6571 = _458 - (_6539 * _6530);
                                                                                    _6572 = _459 - (_6539 * _6531);
                                                                                    _6573 = _457 - (_6539 * _6532);
                                                                                    _6580 = rsqrt((dot(float3(_6571, _6572, _6573), float3(_6571, _6572, _6573)) * dot(float3(_6565, _6566, _6567), float3(_6565, _6566, _6567))) + 9.999999747378752e-05f) * dot(float3(_6565, _6566, _6567), float3(_6571, _6572, _6573));
                                                                                    _6584 = sqrt(saturate((_6580 * 0.5f) + 0.5f));
                                                                                    _6588 = _224 * _224;
                                                                                    _6589 = _6588 * 0.5f;
                                                                                    _6590 = _6588 * 2.0f;
                                                                                    _6594 = exp2((1.0f - abs(_6074)) * -72.13475036621094f);
                                                                                    do {
                                                                                      _6601 = _6594;
                                                                                      if (!((_6385 & 1) == 0)) {
                                                                                        _6601 = select(((select(((_6385 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_6074 == -1.0f))), 0.0f, _6594);
                                                                                      }
                                                                                      _6605 = saturate((dot(float3(_205, _207, _209), float3(_6373, _6374, _6375)) + 0.5f) * 0.6666666865348816f);
                                                                                      _6615 = (_6539 + _6536) + ((((_6584 * 0.9975510239601135f) * sqrt(1.0f - (_6539 * _6539))) - (_6539 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                                      _6617 = (_6588 * 1.4142135381698608f) * _6584;
                                                                                      _6630 = 1.0f - sqrt(saturate((_6533 * 0.5f) + 0.5f));
                                                                                      _6631 = _6630 * _6630;
                                                                                      _6637 = saturate(-0.0f - _6533);
                                                                                      _6640 = (1.0f - saturate(_6637)) * _6605;
                                                                                      _6649 = ((((_6584 * 0.5f) * (exp2((((_6615 * _6615) * -0.5f) / (_6617 * _6617)) * 1.4426950216293335f) / (_6617 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_6631 * _6631) * (_6630 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_6640, 1.0f, _6601));
                                                                                      _6651 = (_6536 + -0.03500000014901161f) + _6539;
                                                                                      _6660 = 1.0f / ((1.190000057220459f / _6561) + (_6561 * 0.36000001430511475f));
                                                                                      _6665 = ((_6660 * (0.6000000238418579f - (_6580 * 0.800000011920929f))) + 1.0f) * _6584;
                                                                                      _6671 = 1.0f - (sqrt(saturate(1.0f - (_6665 * _6665))) * _6561);
                                                                                      _6672 = _6671 * _6671;
                                                                                      _6676 = 0.9534794092178345f - ((_6672 * _6672) * (_6671 * 0.9534794092178345f));
                                                                                      _6677 = _6665 * _6660;
                                                                                      _6682 = (sqrt(1.0f - (_6677 * _6677)) * 0.5f) / _6561;
                                                                                      _6701 = 1.0f - saturate((_6637 + -0.44999998807907104f) * 2.222222328186035f);
                                                                                      _6704 = ((1.0f - _6605) * _6601) + _6605;
                                                                                      _6707 = ((_6676 * _6676) * (exp2((((_6651 * _6651) * -0.5f) / (_6589 * _6589)) * 1.4426950216293335f) / (_6588 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_6580 * 5.2658371925354f));
                                                                                      _6721 = (_6536 + -0.14000000059604645f) + _6539;
                                                                                      _6731 = 1.0f - (_6561 * 0.5f);
                                                                                      _6732 = _6731 * _6731;
                                                                                      _6736 = (_6732 * _6732) * (0.9534794092178345f - (_6561 * 0.47673970460891724f));
                                                                                      _6738 = 0.9534794092178345f - _6736;
                                                                                      _6740 = (_6738 * _6738) * (_6736 + 0.04652056470513344f);
                                                                                      _6743 = exp2((_6580 * 24.525815963745117f) + -24.208423614501953f);
                                                                                      _6756 = ((exp2((((_6721 * _6721) * -0.5f) / (_6590 * _6590)) * 1.4426950216293335f) / (_6588 * 5.013256549835205f)) * (lerp(_6740, 1.0f, _172))) * (((exp2((saturate(dot(float3((_6460 * _6456), (_6460 * _6457), (_6460 * _6458)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _6743) * _172) + _6743);
                                                                                      _6764 = (((((exp2(log2(max(_168, 0.0f)) * _6682) * _6704) * _6707) * _6701) + _6649) + (_6756 * _168));
                                                                                      _6765 = (((((exp2(log2(max(_169, 0.0f)) * _6682) * _6704) * _6707) * _6701) + _6649) + (_6756 * _169));
                                                                                      _6766 = (((((exp2(log2(max(_170, 0.0f)) * _6682) * _6704) * _6707) * _6701) + _6649) + (_6756 * _170));
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  }
                                                                                  _6767 = _6244 * _1674;
                                                                                  _6768 = _6245 * _1674;
                                                                                  _6769 = _6246 * _1674;
                                                                                  _6776 = ((_6294 * _6767) * ((max(((_6424 + _6394) * _6409), 0.0f) * _6431) + sqrt(_6432 * _6432))) + _1611;
                                                                                  _6777 = ((_6294 * _6768) * ((max(((_6424 + _6395) * _6409), 0.0f) * _6431) + sqrt(_6433 * _6433))) + _1612;
                                                                                  _6778 = ((_6294 * _6769) * ((max(((_6424 + _6396) * _6409), 0.0f) * _6431) + sqrt(_6434 * _6434))) + _1613;
                                                                                  if (_4103 > 0.0f) {
                                                                                    _6782 = (_4103 * _1367) * select(_6291, (_6287 * _1276), _6287);
                                                                                    _9584 = _6776;
                                                                                    _9585 = _6777;
                                                                                    _9586 = _6778;
                                                                                    _9587 = (((_6782 * _6767) * _6764) + _1614);
                                                                                    _9588 = (((_6782 * _6768) * _6765) + _1615);
                                                                                    _9589 = (((_6782 * _6769) * _6766) + _1616);
                                                                                  } else {
                                                                                    _9584 = _6776;
                                                                                    _9585 = _6777;
                                                                                    _9586 = _6778;
                                                                                    _9587 = _1614;
                                                                                    _9588 = _1615;
                                                                                    _9589 = _1616;
                                                                                  }
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
                                                                _6119 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_67, _68, 0));
                                                                do {
                                                                  if (_6116 == 0) {
                                                                    _6133 = _6119.x;
                                                                  } else {
                                                                    if (_6116 == 1) {
                                                                      _6133 = _6119.y;
                                                                    } else {
                                                                      if (_6116 == 2) {
                                                                        _6133 = _6119.z;
                                                                      } else {
                                                                        _6133 = _6119.w;
                                                                      }
                                                                    }
                                                                  }
                                                                  _6137 = ((_6133 * _6133) * _4188);
                                                                  [branch]
                                                                  if (!(_6137 == 0.0f)) {
                                                                    do {
                                                                      _6244 = _6095;
                                                                      _6245 = _6096;
                                                                      _6246 = _6097;
                                                                      [branch]
                                                                      if (!(((_4073 & 1) == 0) || (!_4219))) {
                                                                        _6154 = max(max(_6095, _6096), _6097);
                                                                        do {
                                                                          _6164 = _6095;
                                                                          _6165 = _6096;
                                                                          _6166 = _6097;
                                                                          if (_6154 > 0.0f) {
                                                                            _6164 = saturate(_6095 / _6154);
                                                                            _6165 = saturate(_6096 / _6154);
                                                                            _6166 = saturate(_6097 / _6154);
                                                                          }
                                                                          _6167 = (_6165 < _6166);
                                                                          _6168 = select(_6167, _6166, _6165);
                                                                          _6169 = select(_6167, _6165, _6166);
                                                                          _6170 = select(_6167, -1.0f, 0.0f);
                                                                          _6171 = (_6164 < _6168);
                                                                          _6173 = select(_6171, _6168, _6164);
                                                                          _6174 = select(_6171, _6164, _6168);
                                                                          _6178 = _6173 - select((_6174 < _6169), _6174, _6169);
                                                                          _6184 = abs(select(_6171, (-0.3333333432674408f - _6170), _6170) + ((_6174 - _6169) / ((_6178 * 6.0f) + 9.999999682655225e-21f)));
                                                                          do {
                                                                            _6197 = _6184;
                                                                            if (_6184 < 0.6666666865348816f) {
                                                                              _6197 = ((saturate(((float)((uint)((uint)(((uint)(_4073) >> 9) & 255)))) * 0.003921499941498041f) * (select((_6184 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _6184)) + _6184);
                                                                            }
                                                                            _6198 = saturate((_6178 / (_6173 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_4073) >> 1) & 255)))) * 0.003921499941498041f));
                                                                            _6199 = saturate(_6173);
                                                                            do {
                                                                              _6226 = _6199;
                                                                              _6227 = _6199;
                                                                              _6228 = _6199;
                                                                              if (!(_6198 <= 0.0f)) {
                                                                                _6202 = saturate(_6197);
                                                                                _6206 = select(((_6202 * 360.0f) >= 360.0f), 0.0f, (_6202 * 6.0f));
                                                                                _6207 = int(_6206);
                                                                                _6209 = _6206 - float((int)(_6207));
                                                                                _6211 = _6199 * (1.0f - _6198);
                                                                                _6214 = (1.0f - (_6209 * _6198)) * _6199;
                                                                                _6218 = (1.0f - ((1.0f - _6209) * _6198)) * _6199;
                                                                                switch (_6207) {
                                                                                  case 0: {
                                                                                    _6226 = _6199;
                                                                                    _6227 = _6218;
                                                                                    _6228 = _6211;
                                                                                    break;
                                                                                  }
                                                                                  case 1: {
                                                                                    _6226 = _6214;
                                                                                    _6227 = _6199;
                                                                                    _6228 = _6211;
                                                                                    break;
                                                                                  }
                                                                                  case 2: {
                                                                                    _6226 = _6211;
                                                                                    _6227 = _6199;
                                                                                    _6228 = _6218;
                                                                                    break;
                                                                                  }
                                                                                  case 3: {
                                                                                    _6226 = _6211;
                                                                                    _6227 = _6214;
                                                                                    _6228 = _6199;
                                                                                    break;
                                                                                  }
                                                                                  case 4: {
                                                                                    _6226 = _6218;
                                                                                    _6227 = _6211;
                                                                                    _6228 = _6199;
                                                                                    break;
                                                                                  }
                                                                                  case 5: {
                                                                                    _6226 = _6199;
                                                                                    _6227 = _6211;
                                                                                    _6228 = _6214;
                                                                                    break;
                                                                                  }
                                                                                  default: {
                                                                                    _6226 = 0.0f;
                                                                                    _6227 = 0.0f;
                                                                                    _6228 = 0.0f;
                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }
                                                                              _6229 = _6226 * _6154;
                                                                              _6230 = _6227 * _6154;
                                                                              _6231 = _6228 * _6154;
                                                                              _6233 = saturate(_6075 * 1.0101009607315063f);
                                                                              _6244 = ((_6233 * (_6095 - _6229)) + _6229);
                                                                              _6245 = ((_6233 * (_6096 - _6230)) + _6230);
                                                                              _6246 = (lerp(_6231, _6097, _6233));
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      do {
                                                                        _6286 = _6098;
                                                                        _6287 = _6098;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _6253 = srvLightMappingData[_1626];
                                                                          if (!(_6253 == -1)) {
                                                                            _6258 = srvLightIndexData[_6253].nLayerIndex;
                                                                            _6260 = srvLightIndexData[_6253].vAtlasOrigin.x;
                                                                            _6261 = srvLightIndexData[_6253].vAtlasOrigin.y;
                                                                            _6263 = srvLightIndexData[_6253].vScreenOrigin.x;
                                                                            _6264 = srvLightIndexData[_6253].vScreenOrigin.y;
                                                                            _6273 = ((int)(_6258 * 5)) & 31;
                                                                            _6276 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6260 + _67) - _6263)), ((int)((_6261 + _68) - _6264)), 0)))).x) & ((int)(31 << _6273)))) >> _6273;
                                                                            _6286 = ((_6098 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_6276) >> 1)))));
                                                                            _6287 = (((float)((bool)(uint)((_6276 & 1) != 0))) * _6098);
                                                                          } else {
                                                                            _6286 = _6098;
                                                                            _6287 = _6098;
                                                                          }
                                                                        }
                                                                        _6291 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _6294 = select(_6291, (_6286 * _1276), _6286);
                                                                        _6296 = _4171 * _4170;
                                                                        _6297 = _4172 * _4170;
                                                                        _6298 = _4173 * _4170;
                                                                        _6299 = _4104 * _4044;
                                                                        _6300 = _4104 * _4045;
                                                                        _6301 = _4104 * _4046;
                                                                        _6302 = _6296 + _6299;
                                                                        _6303 = _6297 + _6300;
                                                                        _6304 = _6298 + _6301;
                                                                        _6306 = -0.0f - _458;
                                                                        _6307 = -0.0f - _459;
                                                                        _6308 = -0.0f - _457;
                                                                        do {
                                                                          _6368 = _6302;
                                                                          _6369 = _6303;
                                                                          _6370 = _6304;
                                                                          if (_4104 > 0.0f) {
                                                                            _6314 = dot(float3(_6306, _6307, _6308), float3(_205, _207, _209)) * 2.0f;
                                                                            _6318 = _6306 - (_6314 * _205);
                                                                            _6319 = _6307 - (_6314 * _207);
                                                                            _6320 = _6308 - (_6314 * _209);
                                                                            _6321 = (_6296 - _6299) - _6302;
                                                                            _6322 = (_6297 - _6300) - _6303;
                                                                            _6323 = (_6298 - _6301) - _6304;
                                                                            _6324 = dot(float3(_6318, _6319, _6320), float3(_6321, _6322, _6323));
                                                                            _6330 = sqrt(((_6321 * _6321) + (_6322 * _6322)) + (_6323 * _6323));
                                                                            _6339 = saturate(((dot(float3(_6318, _6319, _6320), float3(_6302, _6303, _6304)) * _6324) - dot(float3(_6302, _6303, _6304), float3(_6321, _6322, _6323))) / ((_6330 * _6330) - (_6324 * _6324)));
                                                                            _6343 = (_6339 * _6321) + _6302;
                                                                            _6344 = (_6339 * _6322) + _6303;
                                                                            _6345 = (_6339 * _6323) + _6304;
                                                                            _6346 = dot(float3(_6343, _6344, _6345), float3(_6318, _6319, _6320));
                                                                            _6350 = (_6346 * _6318) - _6343;
                                                                            _6351 = (_6346 * _6319) - _6344;
                                                                            _6352 = (_6346 * _6320) - _6345;
                                                                            _6360 = saturate(0.009999999776482582f / sqrt(((_6350 * _6350) + (_6351 * _6351)) + (_6352 * _6352)));
                                                                            _6368 = ((_6360 * _6350) + _6343);
                                                                            _6369 = ((_6360 * _6351) + _6344);
                                                                            _6370 = ((_6360 * _6352) + _6345);
                                                                          }
                                                                          _6372 = rsqrt(dot(float3(_6368, _6369, _6370), float3(_6368, _6369, _6370)));
                                                                          _6373 = _6372 * _6368;
                                                                          _6374 = _6372 * _6369;
                                                                          _6375 = _6372 * _6370;
                                                                          _6377 = rsqrt(dot(float3(_6296, _6297, _6298), float3(_6296, _6297, _6298)));
                                                                          _6378 = _6377 * _6296;
                                                                          _6379 = _6377 * _6297;
                                                                          _6380 = _6377 * _6298;
                                                                          _6382 = saturate(dot(float3(_205, _207, _209), float3(_6378, _6379, _6380)));
                                                                          _6385 = uint((_180 * 255.0f) + 0.5f);
                                                                          _6394 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                                          _6395 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                                          _6396 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                                          _6409 = ((dot(float3(_206, _208, _210), float3(_6378, _6379, _6380)) + dot(float3(_6306, _6307, _6308), float3(_6378, _6379, _6380))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_6385) >> 2)))) * 0.1666666716337204f)));
                                                                          _6416 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                                          _6419 = saturate((_6416 + -0.009999999776482582f) * -100.0f);
                                                                          _6424 = ((_6419 * _6419) * 3.0f) * (3.0f - (_6419 * 2.0f));
                                                                          _6431 = 10.0f - (exp2(log2(saturate(_6416 * 5.0f)) * 3.0f) * 9.0f);
                                                                          _6432 = saturate(_6382 + _6394) * _6382;
                                                                          _6433 = saturate(_6382 + _6395) * _6382;
                                                                          _6434 = saturate(_6382 + _6396) * _6382;
                                                                          _6456 = _6373 + _458;
                                                                          _6457 = _6374 + _459;
                                                                          _6458 = _6375 + _457;
                                                                          _6460 = rsqrt(dot(float3(_6456, _6457, _6458), float3(_6456, _6457, _6458)));
                                                                          do {
                                                                            _6764 = 0.0f;
                                                                            _6765 = 0.0f;
                                                                            _6766 = 0.0f;
                                                                            if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                              _6475 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                              _6476 = _6475 * _205;
                                                                              _6477 = _6475 * _207;
                                                                              _6478 = _6475 * _209;
                                                                              _6481 = (abs(_6476) < abs(_6477));
                                                                              _6482 = select(_6481, 1.0f, 0.0f);
                                                                              _6483 = select(_6481, 0.0f, 1.0f);
                                                                              _6484 = _6483 * _6478;
                                                                              _6486 = -0.0f - (_6478 * _6482);
                                                                              _6489 = (_6482 * _6477) - (_6483 * _6476);
                                                                              _6491 = rsqrt(dot(float3(_6484, _6486, _6489), float3(_6484, _6486, _6489)));
                                                                              _6492 = _6484 * _6491;
                                                                              _6493 = _6491 * _6486;
                                                                              _6494 = _6489 * _6491;
                                                                              _6497 = (_6493 * _6478) - (_6494 * _6477);
                                                                              _6500 = (_6494 * _6476) - (_6492 * _6478);
                                                                              _6503 = (_6492 * _6477) - (_6493 * _6476);
                                                                              _6505 = rsqrt(dot(float3(_6497, _6500, _6503), float3(_6497, _6500, _6503)));
                                                                              _6509 = _178 * 4.0f;
                                                                              _6518 = saturate(abs(_6509 + -2.5f) + -0.5f) + -0.5f;
                                                                              _6519 = saturate(1.5f - abs(_6509 + -1.5f)) + -0.5f;
                                                                              _6521 = rsqrt(dot(float2(_6518, _6519), float2(_6518, _6519)));
                                                                              _6522 = _6521 * _6518;
                                                                              _6523 = _6521 * _6519;
                                                                              _6530 = ((_6497 * _6505) * _6522) + (_6523 * _6492);
                                                                              _6531 = ((_6500 * _6505) * _6522) + (_6523 * _6493);
                                                                              _6532 = ((_6503 * _6505) * _6522) + (_6523 * _6494);
                                                                              _6533 = dot(float3(_458, _459, _457), float3(_6373, _6374, _6375));
                                                                              _6536 = min(max(dot(float3(_6530, _6531, _6532), float3(_6373, _6374, _6375)), -1.0f), 1.0f);
                                                                              _6539 = min(max(dot(float3(_6530, _6531, _6532), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                              _6540 = abs(_6539);
                                                                              _6545 = (1.5707963705062866f - (_6540 * 0.1565829962491989f)) * sqrt(1.0f - _6540);
                                                                              _6549 = abs(_6536);
                                                                              _6554 = (1.5707963705062866f - (_6549 * 0.1565829962491989f)) * sqrt(1.0f - _6549);
                                                                              _6561 = cos(abs(select((_6536 >= 0.0f), _6554, (3.1415927410125732f - _6554)) - select((_6539 >= 0.0f), _6545, (3.1415927410125732f - _6545))) * 0.5f);
                                                                              _6565 = _6373 - (_6536 * _6530);
                                                                              _6566 = _6374 - (_6536 * _6531);
                                                                              _6567 = _6375 - (_6536 * _6532);
                                                                              _6571 = _458 - (_6539 * _6530);
                                                                              _6572 = _459 - (_6539 * _6531);
                                                                              _6573 = _457 - (_6539 * _6532);
                                                                              _6580 = rsqrt((dot(float3(_6571, _6572, _6573), float3(_6571, _6572, _6573)) * dot(float3(_6565, _6566, _6567), float3(_6565, _6566, _6567))) + 9.999999747378752e-05f) * dot(float3(_6565, _6566, _6567), float3(_6571, _6572, _6573));
                                                                              _6584 = sqrt(saturate((_6580 * 0.5f) + 0.5f));
                                                                              _6588 = _224 * _224;
                                                                              _6589 = _6588 * 0.5f;
                                                                              _6590 = _6588 * 2.0f;
                                                                              _6594 = exp2((1.0f - abs(_6074)) * -72.13475036621094f);
                                                                              do {
                                                                                _6601 = _6594;
                                                                                if (!((_6385 & 1) == 0)) {
                                                                                  _6601 = select(((select(((_6385 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_6074 == -1.0f))), 0.0f, _6594);
                                                                                }
                                                                                _6605 = saturate((dot(float3(_205, _207, _209), float3(_6373, _6374, _6375)) + 0.5f) * 0.6666666865348816f);
                                                                                _6615 = (_6539 + _6536) + ((((_6584 * 0.9975510239601135f) * sqrt(1.0f - (_6539 * _6539))) - (_6539 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                                _6617 = (_6588 * 1.4142135381698608f) * _6584;
                                                                                _6630 = 1.0f - sqrt(saturate((_6533 * 0.5f) + 0.5f));
                                                                                _6631 = _6630 * _6630;
                                                                                _6637 = saturate(-0.0f - _6533);
                                                                                _6640 = (1.0f - saturate(_6637)) * _6605;
                                                                                _6649 = ((((_6584 * 0.5f) * (exp2((((_6615 * _6615) * -0.5f) / (_6617 * _6617)) * 1.4426950216293335f) / (_6617 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_6631 * _6631) * (_6630 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_6640, 1.0f, _6601));
                                                                                _6651 = (_6536 + -0.03500000014901161f) + _6539;
                                                                                _6660 = 1.0f / ((1.190000057220459f / _6561) + (_6561 * 0.36000001430511475f));
                                                                                _6665 = ((_6660 * (0.6000000238418579f - (_6580 * 0.800000011920929f))) + 1.0f) * _6584;
                                                                                _6671 = 1.0f - (sqrt(saturate(1.0f - (_6665 * _6665))) * _6561);
                                                                                _6672 = _6671 * _6671;
                                                                                _6676 = 0.9534794092178345f - ((_6672 * _6672) * (_6671 * 0.9534794092178345f));
                                                                                _6677 = _6665 * _6660;
                                                                                _6682 = (sqrt(1.0f - (_6677 * _6677)) * 0.5f) / _6561;
                                                                                _6701 = 1.0f - saturate((_6637 + -0.44999998807907104f) * 2.222222328186035f);
                                                                                _6704 = ((1.0f - _6605) * _6601) + _6605;
                                                                                _6707 = ((_6676 * _6676) * (exp2((((_6651 * _6651) * -0.5f) / (_6589 * _6589)) * 1.4426950216293335f) / (_6588 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_6580 * 5.2658371925354f));
                                                                                _6721 = (_6536 + -0.14000000059604645f) + _6539;
                                                                                _6731 = 1.0f - (_6561 * 0.5f);
                                                                                _6732 = _6731 * _6731;
                                                                                _6736 = (_6732 * _6732) * (0.9534794092178345f - (_6561 * 0.47673970460891724f));
                                                                                _6738 = 0.9534794092178345f - _6736;
                                                                                _6740 = (_6738 * _6738) * (_6736 + 0.04652056470513344f);
                                                                                _6743 = exp2((_6580 * 24.525815963745117f) + -24.208423614501953f);
                                                                                _6756 = ((exp2((((_6721 * _6721) * -0.5f) / (_6590 * _6590)) * 1.4426950216293335f) / (_6588 * 5.013256549835205f)) * (lerp(_6740, 1.0f, _172))) * (((exp2((saturate(dot(float3((_6460 * _6456), (_6460 * _6457), (_6460 * _6458)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _6743) * _172) + _6743);
                                                                                _6764 = (((((exp2(log2(max(_168, 0.0f)) * _6682) * _6704) * _6707) * _6701) + _6649) + (_6756 * _168));
                                                                                _6765 = (((((exp2(log2(max(_169, 0.0f)) * _6682) * _6704) * _6707) * _6701) + _6649) + (_6756 * _169));
                                                                                _6766 = (((((exp2(log2(max(_170, 0.0f)) * _6682) * _6704) * _6707) * _6701) + _6649) + (_6756 * _170));
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            }
                                                                            _6767 = _6244 * _1674;
                                                                            _6768 = _6245 * _1674;
                                                                            _6769 = _6246 * _1674;
                                                                            _6776 = ((_6294 * _6767) * ((max(((_6424 + _6394) * _6409), 0.0f) * _6431) + sqrt(_6432 * _6432))) + _1611;
                                                                            _6777 = ((_6294 * _6768) * ((max(((_6424 + _6395) * _6409), 0.0f) * _6431) + sqrt(_6433 * _6433))) + _1612;
                                                                            _6778 = ((_6294 * _6769) * ((max(((_6424 + _6396) * _6409), 0.0f) * _6431) + sqrt(_6434 * _6434))) + _1613;
                                                                            if (_4103 > 0.0f) {
                                                                              _6782 = (_4103 * _1367) * select(_6291, (_6287 * _1276), _6287);
                                                                              _9584 = _6776;
                                                                              _9585 = _6777;
                                                                              _9586 = _6778;
                                                                              _9587 = (((_6782 * _6767) * _6764) + _1614);
                                                                              _9588 = (((_6782 * _6768) * _6765) + _1615);
                                                                              _9589 = (((_6782 * _6769) * _6766) + _1616);
                                                                            } else {
                                                                              _9584 = _6776;
                                                                              _9585 = _6777;
                                                                              _9586 = _6778;
                                                                              _9587 = _1614;
                                                                              _9588 = _1615;
                                                                              _9589 = _1616;
                                                                            }
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _9584 = _1611;
                                                                    _9585 = _1612;
                                                                    _9586 = _1613;
                                                                    _9587 = _1614;
                                                                    _9588 = _1615;
                                                                    _9589 = _1616;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } else {
                                                              _9584 = _1611;
                                                              _9585 = _1612;
                                                              _9586 = _1613;
                                                              _9587 = _1614;
                                                              _9588 = _1615;
                                                              _9589 = _1616;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } else {
                                                      if (_1657 == 8) {
                                                        _6797 = asfloat(srvLightInfoProperties.Load3(_1625)).x;
                                                        _6798 = asfloat(srvLightInfoProperties.Load3(_1625)).y;
                                                        _6799 = asfloat(srvLightInfoProperties.Load3(_1625)).z;
                                                        _6802 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 12u)))).x;
                                                        _6803 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 12u)))).y;
                                                        _6804 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 12u)))).z;
                                                        _6807 = asfloat(srvLightInfoProperties.Load(((int)(_1625 + 24u))));
                                                        _6810 = asint(srvLightInfoProperties.Load(((int)(_1625 + 28u))));
                                                        _6813 = asint(srvLightInfoProperties.Load(((int)(_1625 + 32u))));
                                                        _6816 = asint(srvLightInfoProperties.Load(((int)(_1625 + 44u))));
                                                        _6825 = ((float)((uint)((uint)(((uint)(_6813) >> 8) & 255)))) * 0.003921499941498041f;
                                                        _6828 = f16tof32(_6816);
                                                        _6835 = min(max(dot(float3((_244 - _6797), (_245 - _6798), (_246 - _6799)), float3(_6802, _6803, _6804)), (-0.0f - _6807)), _6807);
                                                        _6840 = (_6797 - _244) + (_6835 * _6802);
                                                        _6842 = (_6798 - _245) + (_6835 * _6803);
                                                        _6844 = (_6799 + _243) + (_6835 * _6804);
                                                        _6845 = dot(float3(_6840, _6842, _6844), float3(_6840, _6842, _6844));
                                                        _6846 = rsqrt(_6845);
                                                        _6848 = _6840 * _6846;
                                                        _6849 = _6842 * _6846;
                                                        _6850 = _6844 * _6846;
                                                        _6853 = max(0.0f, ((_6846 * _6845) - abs(_6828)));
                                                        _6854 = _6853 * f16tof32(((uint)((uint)(_6816) >> 16)));
                                                        _6855 = _6854 * _6854;
                                                        _6858 = saturate(1.0f - (_6855 * _6855));
                                                        _6865 = (_6858 * _6858) / (select((_6828 < 0.0f), (_6855 * 16.0f), (_6853 * _6853)) + 1.0f);
                                                        [branch]
                                                        if (!(_6865 == 0.0f)) {
                                                          do {
                                                            _6907 = _6865;
                                                            _6908 = _6865;
                                                            [branch]
                                                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                              _6874 = srvLightMappingData[_1626];
                                                              if (!(_6874 == -1)) {
                                                                _6879 = srvLightIndexData[_6874].nLayerIndex;
                                                                _6881 = srvLightIndexData[_6874].vAtlasOrigin.x;
                                                                _6882 = srvLightIndexData[_6874].vAtlasOrigin.y;
                                                                _6884 = srvLightIndexData[_6874].vScreenOrigin.x;
                                                                _6885 = srvLightIndexData[_6874].vScreenOrigin.y;
                                                                _6894 = ((int)(_6879 * 5)) & 31;
                                                                _6897 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6881 + _67) - _6884)), ((int)((_6882 + _68) - _6885)), 0)))).x) & ((int)(31 << _6894)))) >> _6894;
                                                                _6907 = ((_6865 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_6897) >> 1)))));
                                                                _6908 = (((float)((bool)(uint)((_6897 & 1) != 0))) * _6865);
                                                              } else {
                                                                _6907 = _6865;
                                                                _6908 = _6865;
                                                              }
                                                            }
                                                            _6912 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                            _6915 = select(_6912, (_6907 * _1276), _6907);
                                                            _6917 = dot(float3(_205, _207, _209), float3(_6848, _6849, _6850));
                                                            _6918 = saturate(_6917);
                                                            _6921 = uint((_180 * 255.0f) + 0.5f);
                                                            _6930 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                            _6931 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                            _6932 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                            _6948 = ((dot(float3(_206, _208, _210), float3(_6848, _6849, _6850)) + dot(float3((-0.0f - _458), (-0.0f - _459), (-0.0f - _457)), float3(_6848, _6849, _6850))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_6921) >> 2)))) * 0.1666666716337204f)));
                                                            _6955 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                            _6958 = saturate((_6955 + -0.009999999776482582f) * -100.0f);
                                                            _6963 = ((_6958 * _6958) * 3.0f) * (3.0f - (_6958 * 2.0f));
                                                            _6970 = 10.0f - (exp2(log2(saturate(_6955 * 5.0f)) * 3.0f) * 9.0f);
                                                            _6971 = saturate(_6918 + _6930) * _6918;
                                                            _6972 = saturate(_6918 + _6931) * _6918;
                                                            _6973 = saturate(_6918 + _6932) * _6918;
                                                            _6995 = _6848 + _458;
                                                            _6996 = _6849 + _459;
                                                            _6997 = _6850 + _457;
                                                            _6999 = rsqrt(dot(float3(_6995, _6996, _6997), float3(_6995, _6996, _6997)));
                                                            do {
                                                              _7289 = 0.0f;
                                                              _7290 = 0.0f;
                                                              _7291 = 0.0f;
                                                              if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                _7011 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                _7012 = _7011 * _205;
                                                                _7013 = _7011 * _207;
                                                                _7014 = _7011 * _209;
                                                                _7017 = (abs(_7012) < abs(_7013));
                                                                _7018 = select(_7017, 1.0f, 0.0f);
                                                                _7019 = select(_7017, 0.0f, 1.0f);
                                                                _7020 = _7019 * _7014;
                                                                _7022 = -0.0f - (_7014 * _7018);
                                                                _7025 = (_7018 * _7013) - (_7019 * _7012);
                                                                _7027 = rsqrt(dot(float3(_7020, _7022, _7025), float3(_7020, _7022, _7025)));
                                                                _7028 = _7020 * _7027;
                                                                _7029 = _7027 * _7022;
                                                                _7030 = _7025 * _7027;
                                                                _7033 = (_7029 * _7014) - (_7030 * _7013);
                                                                _7036 = (_7030 * _7012) - (_7028 * _7014);
                                                                _7039 = (_7028 * _7013) - (_7029 * _7012);
                                                                _7041 = rsqrt(dot(float3(_7033, _7036, _7039), float3(_7033, _7036, _7039)));
                                                                _7045 = _178 * 4.0f;
                                                                _7054 = saturate(abs(_7045 + -2.5f) + -0.5f) + -0.5f;
                                                                _7055 = saturate(1.5f - abs(_7045 + -1.5f)) + -0.5f;
                                                                _7057 = rsqrt(dot(float2(_7054, _7055), float2(_7054, _7055)));
                                                                _7058 = _7057 * _7054;
                                                                _7059 = _7057 * _7055;
                                                                _7066 = ((_7033 * _7041) * _7058) + (_7059 * _7028);
                                                                _7067 = ((_7036 * _7041) * _7058) + (_7059 * _7029);
                                                                _7068 = ((_7039 * _7041) * _7058) + (_7059 * _7030);
                                                                _7069 = dot(float3(_458, _459, _457), float3(_6848, _6849, _6850));
                                                                _7072 = min(max(dot(float3(_7066, _7067, _7068), float3(_6848, _6849, _6850)), -1.0f), 1.0f);
                                                                _7075 = min(max(dot(float3(_7066, _7067, _7068), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                _7076 = abs(_7075);
                                                                _7081 = (1.5707963705062866f - (_7076 * 0.1565829962491989f)) * sqrt(1.0f - _7076);
                                                                _7085 = abs(_7072);
                                                                _7090 = (1.5707963705062866f - (_7085 * 0.1565829962491989f)) * sqrt(1.0f - _7085);
                                                                _7097 = cos(abs(select((_7072 >= 0.0f), _7090, (3.1415927410125732f - _7090)) - select((_7075 >= 0.0f), _7081, (3.1415927410125732f - _7081))) * 0.5f);
                                                                _7101 = _6848 - (_7072 * _7066);
                                                                _7102 = _6849 - (_7072 * _7067);
                                                                _7103 = _6850 - (_7072 * _7068);
                                                                _7107 = _458 - (_7075 * _7066);
                                                                _7108 = _459 - (_7075 * _7067);
                                                                _7109 = _457 - (_7075 * _7068);
                                                                _7116 = rsqrt((dot(float3(_7107, _7108, _7109), float3(_7107, _7108, _7109)) * dot(float3(_7101, _7102, _7103), float3(_7101, _7102, _7103))) + 9.999999747378752e-05f) * dot(float3(_7101, _7102, _7103), float3(_7107, _7108, _7109));
                                                                _7120 = sqrt(saturate((_7116 * 0.5f) + 0.5f));
                                                                _7124 = _224 * _224;
                                                                _7125 = _7124 * 0.5f;
                                                                _7126 = _7124 * 2.0f;
                                                                _7127 = select(((_6921 & 1) != 0), 0.0f, 1.9287520390554007e-22f);
                                                                _7130 = saturate((_6917 + 0.5f) * 0.6666666865348816f);
                                                                _7140 = (_7075 + _7072) + ((((_7120 * 0.9975510239601135f) * sqrt(1.0f - (_7075 * _7075))) - (_7075 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                _7142 = (_7124 * 1.4142135381698608f) * _7120;
                                                                _7155 = 1.0f - sqrt(saturate((_7069 * 0.5f) + 0.5f));
                                                                _7156 = _7155 * _7155;
                                                                _7162 = saturate(-0.0f - _7069);
                                                                _7165 = (1.0f - saturate(_7162)) * _7130;
                                                                _7174 = ((((_7120 * 0.5f) * (exp2((((_7140 * _7140) * -0.5f) / (_7142 * _7142)) * 1.4426950216293335f) / (_7142 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_7156 * _7156) * (_7155 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_7165, 1.0f, _7127));
                                                                _7176 = (_7072 + -0.03500000014901161f) + _7075;
                                                                _7185 = 1.0f / ((1.190000057220459f / _7097) + (_7097 * 0.36000001430511475f));
                                                                _7190 = ((_7185 * (0.6000000238418579f - (_7116 * 0.800000011920929f))) + 1.0f) * _7120;
                                                                _7196 = 1.0f - (sqrt(saturate(1.0f - (_7190 * _7190))) * _7097);
                                                                _7197 = _7196 * _7196;
                                                                _7201 = 0.9534794092178345f - ((_7197 * _7197) * (_7196 * 0.9534794092178345f));
                                                                _7202 = _7190 * _7185;
                                                                _7207 = (sqrt(1.0f - (_7202 * _7202)) * 0.5f) / _7097;
                                                                _7226 = 1.0f - saturate((_7162 + -0.44999998807907104f) * 2.222222328186035f);
                                                                _7229 = ((1.0f - _7130) * _7127) + _7130;
                                                                _7232 = ((_7201 * _7201) * (exp2((((_7176 * _7176) * -0.5f) / (_7125 * _7125)) * 1.4426950216293335f) / (_7124 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_7116 * 5.2658371925354f));
                                                                _7246 = (_7072 + -0.14000000059604645f) + _7075;
                                                                _7256 = 1.0f - (_7097 * 0.5f);
                                                                _7257 = _7256 * _7256;
                                                                _7261 = (_7257 * _7257) * (0.9534794092178345f - (_7097 * 0.47673970460891724f));
                                                                _7263 = 0.9534794092178345f - _7261;
                                                                _7265 = (_7263 * _7263) * (_7261 + 0.04652056470513344f);
                                                                _7268 = exp2((_7116 * 24.525815963745117f) + -24.208423614501953f);
                                                                _7281 = ((exp2((((_7246 * _7246) * -0.5f) / (_7126 * _7126)) * 1.4426950216293335f) / (_7124 * 5.013256549835205f)) * (lerp(_7265, 1.0f, _172))) * (((exp2((saturate(dot(float3((_6999 * _6995), (_6999 * _6996), (_6999 * _6997)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _7268) * _172) + _7268);
                                                                _7289 = (((((exp2(log2(max(_168, 0.0f)) * _7207) * _7229) * _7232) * _7226) + _7174) + (_7281 * _168));
                                                                _7290 = (((((exp2(log2(max(_169, 0.0f)) * _7207) * _7229) * _7232) * _7226) + _7174) + (_7281 * _169));
                                                                _7291 = (((((exp2(log2(max(_170, 0.0f)) * _7207) * _7229) * _7232) * _7226) + _7174) + (_7281 * _170));
                                                              }
                                                              _7292 = f16tof32(((uint)((uint)(_6810) >> 16))) * _1674;
                                                              _7293 = f16tof32(_6810) * _1674;
                                                              _7294 = f16tof32(((uint)((uint)(_6813) >> 16))) * _1674;
                                                              _7301 = ((_6915 * _7292) * ((max(((_6963 + _6930) * _6948), 0.0f) * _6970) + sqrt(_6971 * _6971))) + _1611;
                                                              _7302 = ((_6915 * _7293) * ((max(((_6963 + _6931) * _6948), 0.0f) * _6970) + sqrt(_6972 * _6972))) + _1612;
                                                              _7303 = ((_6915 * _7294) * ((max(((_6963 + _6932) * _6948), 0.0f) * _6970) + sqrt(_6973 * _6973))) + _1613;
                                                              if (_6825 > 0.0f) {
                                                                _7307 = (_6825 * _1367) * select(_6912, (_6908 * _1276), _6908);
                                                                _9584 = _7301;
                                                                _9585 = _7302;
                                                                _9586 = _7303;
                                                                _9587 = (((_7307 * _7292) * _7289) + _1614);
                                                                _9588 = (((_7307 * _7293) * _7290) + _1615);
                                                                _9589 = (((_7307 * _7294) * _7291) + _1616);
                                                              } else {
                                                                _9584 = _7301;
                                                                _9585 = _7302;
                                                                _9586 = _7303;
                                                                _9587 = _1614;
                                                                _9588 = _1615;
                                                                _9589 = _1616;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _9584 = _1611;
                                                          _9585 = _1612;
                                                          _9586 = _1613;
                                                          _9587 = _1614;
                                                          _9588 = _1615;
                                                          _9589 = _1616;
                                                        }
                                                      } else {
                                                        if (_1657 == 9) {
                                                          _7322 = asfloat(srvLightInfoProperties.Load4(_1625)).x;
                                                          _7323 = asfloat(srvLightInfoProperties.Load4(_1625)).y;
                                                          _7324 = asfloat(srvLightInfoProperties.Load4(_1625)).w;
                                                          _7327 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).x;
                                                          _7328 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).y;
                                                          _7329 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).w;
                                                          _7332 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).x;
                                                          _7333 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).y;
                                                          _7334 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).w;
                                                          _7337 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 48u)))).x;
                                                          _7338 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 48u)))).y;
                                                          _7339 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 48u)))).w;
                                                          _7342 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 64u)))).x;
                                                          _7343 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 64u)))).y;
                                                          _7344 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 64u)))).z;
                                                          _7347 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 76u)))).x;
                                                          _7348 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 76u)))).y;
                                                          _7349 = asfloat(srvLightInfoProperties.Load3(((int)(_1625 + 76u)))).z;
                                                          _7352 = asint(srvLightInfoProperties.Load(((int)(_1625 + 88u))));
                                                          _7355 = asint(srvLightInfoProperties.Load(((int)(_1625 + 92u))));
                                                          _7358 = asint(srvLightInfoProperties.Load(((int)(_1625 + 100u))));
                                                          _7361 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).x;
                                                          _7362 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).y;
                                                          _7363 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).z;
                                                          _7364 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 108u)))).w;
                                                          _7367 = asint(srvLightInfoProperties.Load(((int)(_1625 + 124u))));
                                                          _7370 = asint(srvLightInfoProperties.Load(((int)(_1625 + 128u))));
                                                          _7373 = asint(srvLightInfoProperties.Load(((int)(_1625 + 132u))));
                                                          _7376 = asint(srvLightInfoProperties.Load(((int)(_1625 + 136u))));
                                                          _7379 = asint(srvLightInfoProperties.Load(((int)(_1625 + 140u))));
                                                          _7382 = asint(srvLightInfoProperties.Load(((int)(_1625 + 144u))));
                                                          _7385 = asint(srvLightInfoProperties.Load(((int)(_1625 + 148u))));
                                                          _7388 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 152u)))).x;
                                                          _7389 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 152u)))).y;
                                                          _7390 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 152u)))).z;
                                                          _7391 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 152u)))).w;
                                                          _7394 = asint(srvLightInfoProperties.Load(((int)(_1625 + 168u))));
                                                          _7397 = asint(srvLightInfoProperties.Load(((int)(_1625 + 172u))));
                                                          _7400 = asint(srvLightInfoProperties.Load(((int)(_1625 + 180u))));
                                                          _7402 = f16tof32(((uint)((uint)(_7352) >> 16)));
                                                          _7403 = f16tof32(_7352);
                                                          _7405 = f16tof32(((uint)((uint)(_7355) >> 16)));
                                                          _7409 = ((float)((uint)((uint)(((uint)(_7355) >> 8) & 255)))) * 0.003921499941498041f;
                                                          _7410 = f16tof32(_7358);
                                                          _7413 = f16tof32(_7367);
                                                          _7417 = _7373 & 65535;
                                                          _7423 = ((_1623 & 3584) != 0);
                                                          _7434 = f16tof32(((uint)((uint)(_7397) >> 16)));
                                                          _7435 = f16tof32(_7397);
                                                          _7437 = f16tof32(((uint)((uint)(_7400) >> 16)));
                                                          _7438 = 1.0f / _7437;
                                                          _7439 = _7437 + -1.0f;
                                                          _7440 = f16tof32(_7400);
                                                          _7441 = _7342 - _244;
                                                          _7442 = _7343 - _245;
                                                          _7443 = _7344 + _243;
                                                          _7444 = dot(float3(_7441, _7442, _7443), float3(_7441, _7442, _7443));
                                                          _7445 = rsqrt(_7444);
                                                          _7446 = _7445 * _7444;
                                                          _7447 = _7445 * _7441;
                                                          _7448 = _7445 * _7442;
                                                          _7449 = _7445 * _7443;
                                                          _7452 = max(0.0f, (_7446 - abs(_7413)));
                                                          _7453 = _7452 * f16tof32(((uint)((uint)(_7367) >> 16)));
                                                          _7454 = _7453 * _7453;
                                                          _7457 = saturate(1.0f - (_7454 * _7454));
                                                          _7468 = mad(_246, _7334, mad(_245, _7329, (_7324 * _244))) + _7339;
                                                          _7472 = saturate(1.0f - dot(float3(_205, _207, _209), float3(_7447, _7448, _7449))) * f16tof32(_7394);
                                                          _7479 = ((_7468 * _205) * _7472) + _244;
                                                          _7480 = ((_7468 * _207) * _7472) + _245;
                                                          _7481 = ((_7468 * _209) * _7472) - _243;
                                                          _7493 = mad(_7481, _7334, mad(_7480, _7329, (_7479 * _7324))) + _7339;
                                                          _7494 = 1.0f / _7493;
                                                          _7495 = _7494 * (mad(_7481, _7332, mad(_7480, _7327, (_7479 * _7322))) + _7337);
                                                          _7496 = _7494 * (mad(_7481, _7333, mad(_7480, _7328, (_7479 * _7323))) + _7338);
                                                          _7499 = (_7495 * _7361) + _7362;
                                                          _7500 = (_7496 * _7361) + _7362;
                                                          _7503 = _7499 - saturate(_7499);
                                                          _7504 = _7500 - saturate(_7500);
                                                          _7511 = saturate((sqrt((_7503 * _7503) + (_7504 * _7504)) * _7363) + _7364);
                                                          _7513 = 1.0f - (_7511 * _7511);
                                                          _7519 = (_7513 * _7513) * (((float)((bool)(uint)((_7493 - f16tof32(((uint)((uint)(_7370) >> 16)))) > 0.0f))) * ((_7457 * _7457) / (select((_7413 < 0.0f), (_7454 * 16.0f), (_7452 * _7452)) + 1.0f)));
                                                          do {
                                                            _8419 = 0.0f;
                                                            _8420 = 1.0f;
                                                            _8421 = 1.0f;
                                                            if (!((!(_7519 > 0.0f)) || (!_7423))) {
                                                              _7529 = 1.0f - saturate(f16tof32(_7370) * _7493);
                                                              _7530 = saturate(_7495);
                                                              _7531 = saturate(_7496);
                                                              do {
                                                                _7844 = 1.0f;
                                                                _7845 = 1.0f;
                                                                _7846 = 0.0f;
                                                                _7847 = _7529;
                                                                [branch]
                                                                if (!((_1623 & 1024) == 0)) {
                                                                  _7536 = ((_7530 * _7439) + 0.5f) * _7438;
                                                                  _7538 = ((_7531 * _7439) + 0.5f) * _7438;
                                                                  _7539 = _7529 + f16tof32(((uint)((uint)(_7394) >> 16)));
                                                                  Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7373) >> 16))];
                                                                  _7542 = saturate(_7539);
                                                                  _7546 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _7555 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 6u);
                                                                  } else {
                                                                    _7555 = frac(frac(dot(float2(((_7546 * 32.665000915527344f) + _129), ((_7546 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _7555 = frac(frac(dot(float2(((_7546 * 32.665000915527344f) + _129), ((_7546 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _7556 = sin(_7555);
                                                                  _7557 = cos(_7555);
                                                                  _7558 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _7563 = sqrt((float((int)(_7558)) * 0.25f) + 0.125f) * _7434;
                                                                  _7572 = (_global_7[min((uint)(((int)(0u + (_7558 * 2)))), 127u)]) * _7563;
                                                                  _7573 = (_global_7[min((uint)(((int)(1u + (_7558 * 2)))), 127u)]) * _7563;
                                                                  _7575 = -0.0f - _7556;
                                                                  _7580 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7572, _7573), float2(_7557, _7556)) + _7536), (dot(float2(_7572, _7573), float2(_7575, _7557)) + _7538)));
                                                                  _7585 = _7580.x - _7542;
                                                                  _7587 = select((_7585 < 0.0f), 0.0f, 1.0f);
                                                                  _7589 = _7580.y - _7542;
                                                                  _7591 = select((_7589 < 0.0f), 0.0f, 1.0f);
                                                                  _7595 = _7580.z - _7542;
                                                                  _7597 = select((_7595 < 0.0f), 0.0f, 1.0f);
                                                                  _7601 = _7580.w - _7542;
                                                                  _7603 = select((_7601 < 0.0f), 0.0f, 1.0f);
                                                                  _7610 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                  _7615 = sqrt((float((int)(_7610)) * 0.25f) + 0.125f) * _7434;
                                                                  _7624 = (_global_7[min((uint)(((int)(0u + (_7610 * 2)))), 127u)]) * _7615;
                                                                  _7625 = (_global_7[min((uint)(((int)(1u + (_7610 * 2)))), 127u)]) * _7615;
                                                                  _7631 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7624, _7625), float2(_7557, _7556)) + _7536), (dot(float2(_7624, _7625), float2(_7575, _7557)) + _7538)));
                                                                  _7636 = _7631.x - _7542;
                                                                  _7638 = select((_7636 < 0.0f), 0.0f, 1.0f);
                                                                  _7642 = _7631.y - _7542;
                                                                  _7644 = select((_7642 < 0.0f), 0.0f, 1.0f);
                                                                  _7648 = _7631.z - _7542;
                                                                  _7650 = select((_7648 < 0.0f), 0.0f, 1.0f);
                                                                  _7654 = _7631.w - _7542;
                                                                  _7656 = select((_7654 < 0.0f), 0.0f, 1.0f);
                                                                  _7663 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                  _7668 = sqrt((float((int)(_7663)) * 0.25f) + 0.125f) * _7434;
                                                                  _7677 = (_global_7[min((uint)(((int)(0u + (_7663 * 2)))), 127u)]) * _7668;
                                                                  _7678 = (_global_7[min((uint)(((int)(1u + (_7663 * 2)))), 127u)]) * _7668;
                                                                  _7684 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7677, _7678), float2(_7557, _7556)) + _7536), (dot(float2(_7677, _7678), float2(_7575, _7557)) + _7538)));
                                                                  _7689 = _7684.x - _7542;
                                                                  _7691 = select((_7689 < 0.0f), 0.0f, 1.0f);
                                                                  _7695 = _7684.y - _7542;
                                                                  _7697 = select((_7695 < 0.0f), 0.0f, 1.0f);
                                                                  _7701 = _7684.z - _7542;
                                                                  _7703 = select((_7701 < 0.0f), 0.0f, 1.0f);
                                                                  _7707 = _7684.w - _7542;
                                                                  _7709 = select((_7707 < 0.0f), 0.0f, 1.0f);
                                                                  _7716 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                  _7721 = sqrt((float((int)(_7716)) * 0.25f) + 0.125f) * _7434;
                                                                  _7730 = (_global_7[min((uint)(((int)(0u + (_7716 * 2)))), 127u)]) * _7721;
                                                                  _7731 = (_global_7[min((uint)(((int)(1u + (_7716 * 2)))), 127u)]) * _7721;
                                                                  _7737 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7730, _7731), float2(_7557, _7556)) + _7536), (dot(float2(_7730, _7731), float2(_7575, _7557)) + _7538)));
                                                                  _7742 = _7737.x - _7542;
                                                                  _7744 = select((_7742 < 0.0f), 0.0f, 1.0f);
                                                                  _7748 = _7737.y - _7542;
                                                                  _7750 = select((_7748 < 0.0f), 0.0f, 1.0f);
                                                                  _7754 = _7737.z - _7542;
                                                                  _7756 = select((_7754 < 0.0f), 0.0f, 1.0f);
                                                                  _7760 = _7737.w - _7542;
                                                                  _7762 = select((_7760 < 0.0f), 0.0f, 1.0f);
                                                                  _7763 = ((((((((((((((_7587 + _7591) + _7597) + _7603) + _7638) + _7644) + _7650) + _7656) + _7691) + _7697) + _7703) + _7709) + _7744) + _7750) + _7756) + _7762;
                                                                  _7774 = (saturate(_7763 * 0.0625f) * 2.0f) + -1.0f;
                                                                  _7780 = float((int)(((int)(uint)((int)(_7774 > 0.0f))) - ((int)(uint)((int)(_7774 < 0.0f)))));
                                                                  _7782 = 1.0f - (_7780 * _7774);
                                                                  _7784 = (_7782 * _7782) * _7782;
                                                                  _7791 = 0.5f - ((_7780 * 0.5f) * ((1.0f - _7784) - ((_7782 - _7784) * saturate(((1.0f / _7542) * (1.0f / _7763)) * ((((((((((((((((_7587 * _7585) + (_7591 * _7589)) + (_7597 * _7595)) + (_7603 * _7601)) + (_7638 * _7636)) + (_7644 * _7642)) + (_7650 * _7648)) + (_7656 * _7654)) + (_7691 * _7689)) + (_7697 * _7695)) + (_7703 * _7701)) + (_7709 * _7707)) + (_7744 * _7742)) + (_7750 * _7748)) + (_7756 * _7754)) + (_7762 * _7760))))));
                                                                  _7796 = frac((_7536 * _7437) + 0.5f);
                                                                  _7797 = frac((_7538 * _7437) + 0.5f);
                                                                  _7798 = _7536 + _7438;
                                                                  _7799 = _7538 + _7438;
                                                                  _7801 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7798, _7799), _7539);
                                                                  _7809 = _7438 * 2.0f;
                                                                  _7810 = _7798 - _7809;
                                                                  _7811 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7810, _7799), _7539);
                                                                  _7816 = 1.0f - _7796;
                                                                  _7821 = _7799 - _7809;
                                                                  _7822 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7810, _7821), _7539);
                                                                  _7827 = 1.0f - _7797;
                                                                  _7832 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7798, _7821), _7539);
                                                                  _7841 = (((mad(mad(_7811.x, _7816, _7811.y), _7797, mad(_7811.w, _7816, _7811.z)) + mad(mad(_7801.y, _7796, _7801.x), _7797, mad(_7801.z, _7796, _7801.w))) + mad(mad(_7822.w, _7816, _7822.z), _7827, mad(_7822.x, _7816, _7822.y))) + mad(mad(_7832.z, _7796, _7832.w), _7827, mad(_7832.y, _7796, _7832.x))) * 0.1111111119389534f;
                                                                  [branch]
                                                                  if (!(_7440 < 1.0f)) {
                                                                    _8315 = _7841;
                                                                    _8316 = _7440;
                                                                    _8317 = _7791;
                                                                    do {
                                                                      _8414 = _8317;
                                                                      [branch]
                                                                      if (!((_1623 & 2048) == 0)) {
                                                                        Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7376) >> 16))];
                                                                        _8323 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_7495, _7496), 0.0f);
                                                                        if (_8323.x > 0.0f) {
                                                                          Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_7376 & 65535))];
                                                                          _8330 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_7495, _7496), 0.0f);
                                                                          _8344 = mad(saturate(((log2(_7446) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                          _8345 = max(9.999999747378752e-06f, _8323.x);
                                                                          _8346 = _8330.x / _8345;
                                                                          _8347 = _8330.y / _8345;
                                                                          _8349 = _8330.w / _8345;
                                                                          _8354 = ((0.375f - _8347) * 4.999999873689376e-06f) + _8347;
                                                                          _8357 = -0.0f - _8346;
                                                                          _8358 = mad(_8357, _8354, (_8330.z / _8345));
                                                                          _8360 = 1.0f / mad(_8357, _8346, _8354);
                                                                          _8361 = _8360 * _8358;
                                                                          _8366 = _8344 - _8346;
                                                                          _8371 = (((_8344 * _8344) - _8354) - (_8361 * _8366)) / mad((-0.0f - _8358), _8361, mad((-0.0f - _8354), _8354, (((0.375f - _8349) * 4.999999873689376e-06f) + _8349)));
                                                                          _8373 = (_8360 * _8366) - (_8371 * _8361);
                                                                          _8376 = 1.0f / _8371;
                                                                          _8377 = _8373 * _8376;
                                                                          _8382 = sqrt(((_8377 * _8377) * 0.25f) - ((1.0f - dot(float2(_8373, _8371), float2(_8346, _8354))) * _8376));
                                                                          _8384 = (_8377 * -0.5f) - _8382;
                                                                          _8386 = _8382 - (_8377 * 0.5f);
                                                                          _8388 = select((_8384 < _8344), 1.0f, 0.0f);
                                                                          _8393 = (_8388 + -0.05000000074505806f) / (_8384 - _8344);
                                                                          _8399 = (((select((_8386 < _8344), 1.0f, 0.0f) - _8388) / (_8386 - _8384)) - _8393) / (_8386 - _8344);
                                                                          _8401 = _8393 - (_8399 * _8384);
                                                                          _8414 = (exp2((_8323.x * -1.4426950216293335f) * saturate((dot(float2(_8346, _8354), float2((_8401 - (_8399 * _8344)), _8399)) + 0.05000000074505806f) - (_8401 * _8344))) * _8317);
                                                                        } else {
                                                                          _8414 = _8317;
                                                                        }
                                                                      }
                                                                      _8419 = _8316;
                                                                      _8420 = _8414;
                                                                      _8421 = (lerp(_8414, _8315, _8316));
                                                                      break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                    // Native PCF completion bypasses the fallback-shadow path.
                                                                    break;
                                                                  } else {
                                                                    _7844 = _7791;
                                                                    _7845 = _7841;
                                                                    _7846 = _7440;
                                                                    _7847 = _7539;
                                                                  }
                                                                }
                                                                _7850 = (_7530 * _7388) + _7390;
                                                                _7851 = (_7531 * _7389) + _7391;
                                                                do {
                                                                  _8310 = 1.0f;
                                                                  if (!((_1623 & 512) == 0)) {
                                                                    Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                                                    _7860 = saturate(_7847);
                                                                    _7864 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _7873 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_67, _68), cbSharedPerViewData.nFrameCounter, 7u);
                                                                    } else {
                                                                      _7873 = frac(frac(dot(float2(((_7864 * 32.665000915527344f) + _129), ((_7864 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _7873 = frac(frac(dot(float2(((_7864 * 32.665000915527344f) + _129), ((_7864 * 11.8149995803833f) + _130)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _7874 = sin(_7873);
                                                                    _7875 = cos(_7873);
                                                                    _7880 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_7850, _7851), 0.0f))).x) > _7860), 1.0f, 0.0f);
                                                                    _7881 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _7886 = sqrt((float((int)(_7881)) * 0.25f) + 0.125f) * _7435;
                                                                    _7895 = (_global_7[min((uint)(((int)(0u + (_7881 * 2)))), 127u)]) * _7886;
                                                                    _7896 = (_global_7[min((uint)(((int)(1u + (_7881 * 2)))), 127u)]) * _7886;
                                                                    _7898 = -0.0f - _7874;
                                                                    _7900 = dot(float2(_7895, _7896), float2(_7875, _7874)) + _7850;
                                                                    _7901 = dot(float2(_7895, _7896), float2(_7898, _7875)) + _7851;
                                                                    _7903 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7900, _7901));
                                                                    _7907 = _7900 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                    _7908 = _7901 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                    _7911 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _7390);
                                                                    _7912 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _7391);
                                                                    _7917 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_7388 + _7390)) + 0.5f);
                                                                    _7918 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_7389 + _7391)) + 0.5f);
                                                                    _7921 = floor(_7907 + -0.5f);
                                                                    _7922 = floor(_7908 + 0.5f);
                                                                    _7924 = floor(_7907 + 0.5f);
                                                                    _7926 = floor(_7908 + -0.5f);
                                                                    _7927 = (_7921 < _7911);
                                                                    _7928 = (_7922 < _7912);
                                                                    do {
                                                                      if (!(_7927 || _7928)) {
                                                                        if ((_7921 >= _7917) || (_7922 >= _7918)) {
                                                                          _7937 = _7880;
                                                                        } else {
                                                                          _7937 = _7903.x;
                                                                        }
                                                                      } else {
                                                                        _7937 = _7880;
                                                                      }
                                                                      _7938 = (_7924 < _7911);
                                                                      do {
                                                                        if (!(_7938 || _7928)) {
                                                                          if ((_7924 >= _7917) || (_7922 >= _7918)) {
                                                                            _7946 = _7880;
                                                                          } else {
                                                                            _7946 = _7903.y;
                                                                          }
                                                                        } else {
                                                                          _7946 = _7880;
                                                                        }
                                                                        _7947 = (_7926 < _7912);
                                                                        do {
                                                                          if (!(_7938 || _7947)) {
                                                                            if ((_7924 >= _7917) || (_7926 >= _7918)) {
                                                                              _7955 = _7880;
                                                                            } else {
                                                                              _7955 = _7903.z;
                                                                            }
                                                                          } else {
                                                                            _7955 = _7880;
                                                                          }
                                                                          do {
                                                                            if (!(_7927 || _7947)) {
                                                                              if ((_7921 >= _7917) || (_7926 >= _7918)) {
                                                                                _7963 = _7880;
                                                                              } else {
                                                                                _7963 = _7903.w;
                                                                              }
                                                                            } else {
                                                                              _7963 = _7880;
                                                                            }
                                                                            _7964 = _7937 - _7860;
                                                                            _7966 = select((_7964 < 0.0f), 0.0f, 1.0f);
                                                                            _7968 = _7946 - _7860;
                                                                            _7970 = select((_7968 < 0.0f), 0.0f, 1.0f);
                                                                            _7974 = _7955 - _7860;
                                                                            _7976 = select((_7974 < 0.0f), 0.0f, 1.0f);
                                                                            _7980 = _7963 - _7860;
                                                                            _7982 = select((_7980 < 0.0f), 0.0f, 1.0f);
                                                                            _7989 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _7994 = sqrt((float((int)(_7989)) * 0.25f) + 0.125f) * _7435;
                                                                            _8003 = (_global_7[min((uint)(((int)(0u + (_7989 * 2)))), 127u)]) * _7994;
                                                                            _8004 = (_global_7[min((uint)(((int)(1u + (_7989 * 2)))), 127u)]) * _7994;
                                                                            _8007 = dot(float2(_8003, _8004), float2(_7875, _7874)) + _7850;
                                                                            _8008 = dot(float2(_8003, _8004), float2(_7898, _7875)) + _7851;
                                                                            _8010 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_8007, _8008));
                                                                            _8014 = _8007 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                            _8015 = _8008 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                            _8018 = floor(_8014 + -0.5f);
                                                                            _8019 = floor(_8015 + 0.5f);
                                                                            _8021 = floor(_8014 + 0.5f);
                                                                            _8023 = floor(_8015 + -0.5f);
                                                                            _8024 = (_8018 < _7911);
                                                                            _8025 = (_8019 < _7912);
                                                                            do {
                                                                              if (!(_8024 || _8025)) {
                                                                                if ((_8018 >= _7917) || (_8019 >= _7918)) {
                                                                                  _8034 = _7880;
                                                                                } else {
                                                                                  _8034 = _8010.x;
                                                                                }
                                                                              } else {
                                                                                _8034 = _7880;
                                                                              }
                                                                              _8035 = (_8021 < _7911);
                                                                              do {
                                                                                if (!(_8035 || _8025)) {
                                                                                  if ((_8021 >= _7917) || (_8019 >= _7918)) {
                                                                                    _8043 = _7880;
                                                                                  } else {
                                                                                    _8043 = _8010.y;
                                                                                  }
                                                                                } else {
                                                                                  _8043 = _7880;
                                                                                }
                                                                                _8044 = (_8023 < _7912);
                                                                                do {
                                                                                  if (!(_8035 || _8044)) {
                                                                                    if ((_8021 >= _7917) || (_8023 >= _7918)) {
                                                                                      _8052 = _7880;
                                                                                    } else {
                                                                                      _8052 = _8010.z;
                                                                                    }
                                                                                  } else {
                                                                                    _8052 = _7880;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_8024 || _8044)) {
                                                                                      if ((_8018 >= _7917) || (_8023 >= _7918)) {
                                                                                        _8060 = _7880;
                                                                                      } else {
                                                                                        _8060 = _8010.w;
                                                                                      }
                                                                                    } else {
                                                                                      _8060 = _7880;
                                                                                    }
                                                                                    _8061 = _8034 - _7860;
                                                                                    _8063 = select((_8061 < 0.0f), 0.0f, 1.0f);
                                                                                    _8067 = _8043 - _7860;
                                                                                    _8069 = select((_8067 < 0.0f), 0.0f, 1.0f);
                                                                                    _8073 = _8052 - _7860;
                                                                                    _8075 = select((_8073 < 0.0f), 0.0f, 1.0f);
                                                                                    _8079 = _8060 - _7860;
                                                                                    _8081 = select((_8079 < 0.0f), 0.0f, 1.0f);
                                                                                    _8088 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _8093 = sqrt((float((int)(_8088)) * 0.25f) + 0.125f) * _7435;
                                                                                    _8102 = (_global_7[min((uint)(((int)(0u + (_8088 * 2)))), 127u)]) * _8093;
                                                                                    _8103 = (_global_7[min((uint)(((int)(1u + (_8088 * 2)))), 127u)]) * _8093;
                                                                                    _8106 = dot(float2(_8102, _8103), float2(_7875, _7874)) + _7850;
                                                                                    _8107 = dot(float2(_8102, _8103), float2(_7898, _7875)) + _7851;
                                                                                    _8109 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_8106, _8107));
                                                                                    _8113 = _8106 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                    _8114 = _8107 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                    _8117 = floor(_8113 + -0.5f);
                                                                                    _8118 = floor(_8114 + 0.5f);
                                                                                    _8120 = floor(_8113 + 0.5f);
                                                                                    _8122 = floor(_8114 + -0.5f);
                                                                                    _8123 = (_8117 < _7911);
                                                                                    _8124 = (_8118 < _7912);
                                                                                    do {
                                                                                      if (!(_8123 || _8124)) {
                                                                                        if ((_8117 >= _7917) || (_8118 >= _7918)) {
                                                                                          _8133 = _7880;
                                                                                        } else {
                                                                                          _8133 = _8109.x;
                                                                                        }
                                                                                      } else {
                                                                                        _8133 = _7880;
                                                                                      }
                                                                                      _8134 = (_8120 < _7911);
                                                                                      do {
                                                                                        if (!(_8134 || _8124)) {
                                                                                          if ((_8120 >= _7917) || (_8118 >= _7918)) {
                                                                                            _8142 = _7880;
                                                                                          } else {
                                                                                            _8142 = _8109.y;
                                                                                          }
                                                                                        } else {
                                                                                          _8142 = _7880;
                                                                                        }
                                                                                        _8143 = (_8122 < _7912);
                                                                                        do {
                                                                                          if (!(_8134 || _8143)) {
                                                                                            if ((_8120 >= _7917) || (_8122 >= _7918)) {
                                                                                              _8151 = _7880;
                                                                                            } else {
                                                                                              _8151 = _8109.z;
                                                                                            }
                                                                                          } else {
                                                                                            _8151 = _7880;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_8123 || _8143)) {
                                                                                              if ((_8117 >= _7917) || (_8122 >= _7918)) {
                                                                                                _8159 = _7880;
                                                                                              } else {
                                                                                                _8159 = _8109.w;
                                                                                              }
                                                                                            } else {
                                                                                              _8159 = _7880;
                                                                                            }
                                                                                            _8160 = _8133 - _7860;
                                                                                            _8162 = select((_8160 < 0.0f), 0.0f, 1.0f);
                                                                                            _8166 = _8142 - _7860;
                                                                                            _8168 = select((_8166 < 0.0f), 0.0f, 1.0f);
                                                                                            _8172 = _8151 - _7860;
                                                                                            _8174 = select((_8172 < 0.0f), 0.0f, 1.0f);
                                                                                            _8178 = _8159 - _7860;
                                                                                            _8180 = select((_8178 < 0.0f), 0.0f, 1.0f);
                                                                                            _8187 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _8192 = sqrt((float((int)(_8187)) * 0.25f) + 0.125f) * _7435;
                                                                                            _8201 = (_global_7[min((uint)(((int)(0u + (_8187 * 2)))), 127u)]) * _8192;
                                                                                            _8202 = (_global_7[min((uint)(((int)(1u + (_8187 * 2)))), 127u)]) * _8192;
                                                                                            _8205 = dot(float2(_8201, _8202), float2(_7875, _7874)) + _7850;
                                                                                            _8206 = dot(float2(_8201, _8202), float2(_7898, _7875)) + _7851;
                                                                                            _8208 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_8205, _8206));
                                                                                            _8212 = _8205 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                            _8213 = _8206 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                            _8216 = floor(_8212 + -0.5f);
                                                                                            _8217 = floor(_8213 + 0.5f);
                                                                                            _8219 = floor(_8212 + 0.5f);
                                                                                            _8221 = floor(_8213 + -0.5f);
                                                                                            _8222 = (_8216 < _7911);
                                                                                            _8223 = (_8217 < _7912);
                                                                                            do {
                                                                                              if (!(_8222 || _8223)) {
                                                                                                if ((_8216 >= _7917) || (_8217 >= _7918)) {
                                                                                                  _8232 = _7880;
                                                                                                } else {
                                                                                                  _8232 = _8208.x;
                                                                                                }
                                                                                              } else {
                                                                                                _8232 = _7880;
                                                                                              }
                                                                                              _8233 = (_8219 < _7911);
                                                                                              do {
                                                                                                if (!(_8233 || _8223)) {
                                                                                                  if ((_8219 >= _7917) || (_8217 >= _7918)) {
                                                                                                    _8241 = _7880;
                                                                                                  } else {
                                                                                                    _8241 = _8208.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _8241 = _7880;
                                                                                                }
                                                                                                _8242 = (_8221 < _7912);
                                                                                                do {
                                                                                                  if (!(_8233 || _8242)) {
                                                                                                    if ((_8219 >= _7917) || (_8221 >= _7918)) {
                                                                                                      _8250 = _7880;
                                                                                                    } else {
                                                                                                      _8250 = _8208.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _8250 = _7880;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_8222 || _8242)) {
                                                                                                      if ((_8216 >= _7917) || (_8221 >= _7918)) {
                                                                                                        _8258 = _7880;
                                                                                                      } else {
                                                                                                        _8258 = _8208.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _8258 = _7880;
                                                                                                    }
                                                                                                    _8259 = _8232 - _7860;
                                                                                                    _8261 = select((_8259 < 0.0f), 0.0f, 1.0f);
                                                                                                    _8265 = _8241 - _7860;
                                                                                                    _8267 = select((_8265 < 0.0f), 0.0f, 1.0f);
                                                                                                    _8271 = _8250 - _7860;
                                                                                                    _8273 = select((_8271 < 0.0f), 0.0f, 1.0f);
                                                                                                    _8277 = _8258 - _7860;
                                                                                                    _8279 = select((_8277 < 0.0f), 0.0f, 1.0f);
                                                                                                    _8280 = ((((((((((((((_7970 + _7966) + _7976) + _7982) + _8063) + _8069) + _8075) + _8081) + _8162) + _8168) + _8174) + _8180) + _8261) + _8267) + _8273) + _8279;
                                                                                                    _8291 = (saturate(_8280 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _8297 = float((int)(((int)(uint)((int)(_8291 > 0.0f))) - ((int)(uint)((int)(_8291 < 0.0f)))));
                                                                                                    _8299 = 1.0f - (_8297 * _8291);
                                                                                                    _8301 = (_8299 * _8299) * _8299;
                                                                                                    _8310 = (0.5f - ((_8297 * 0.5f) * ((1.0f - _8301) - ((_8299 - _8301) * saturate(((1.0f / _7860) * (1.0f / _8280)) * ((((((((((((((((_7970 * _7968) + (_7966 * _7964)) + (_7976 * _7974)) + (_7982 * _7980)) + (_8063 * _8061)) + (_8069 * _8067)) + (_8075 * _8073)) + (_8081 * _8079)) + (_8162 * _8160)) + (_8168 * _8166)) + (_8174 * _8172)) + (_8180 * _8178)) + (_8261 * _8259)) + (_8267 * _8265)) + (_8273 * _8271)) + (_8279 * _8277)))))));
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
                                                                  _8315 = _7845;
                                                                  _8316 = _7846;
                                                                  _8317 = (lerp(_8310, _7844, _7846));
                                                                  do {
                                                                    _8414 = _8317;
                                                                    [branch]
                                                                    if (!((_1623 & 2048) == 0)) {
                                                                      Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7376) >> 16))];
                                                                      _8323 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_7495, _7496), 0.0f);
                                                                      if (_8323.x > 0.0f) {
                                                                        Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_7376 & 65535))];
                                                                        _8330 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_7495, _7496), 0.0f);
                                                                        _8344 = mad(saturate(((log2(_7446) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                        _8345 = max(9.999999747378752e-06f, _8323.x);
                                                                        _8346 = _8330.x / _8345;
                                                                        _8347 = _8330.y / _8345;
                                                                        _8349 = _8330.w / _8345;
                                                                        _8354 = ((0.375f - _8347) * 4.999999873689376e-06f) + _8347;
                                                                        _8357 = -0.0f - _8346;
                                                                        _8358 = mad(_8357, _8354, (_8330.z / _8345));
                                                                        _8360 = 1.0f / mad(_8357, _8346, _8354);
                                                                        _8361 = _8360 * _8358;
                                                                        _8366 = _8344 - _8346;
                                                                        _8371 = (((_8344 * _8344) - _8354) - (_8361 * _8366)) / mad((-0.0f - _8358), _8361, mad((-0.0f - _8354), _8354, (((0.375f - _8349) * 4.999999873689376e-06f) + _8349)));
                                                                        _8373 = (_8360 * _8366) - (_8371 * _8361);
                                                                        _8376 = 1.0f / _8371;
                                                                        _8377 = _8373 * _8376;
                                                                        _8382 = sqrt(((_8377 * _8377) * 0.25f) - ((1.0f - dot(float2(_8373, _8371), float2(_8346, _8354))) * _8376));
                                                                        _8384 = (_8377 * -0.5f) - _8382;
                                                                        _8386 = _8382 - (_8377 * 0.5f);
                                                                        _8388 = select((_8384 < _8344), 1.0f, 0.0f);
                                                                        _8393 = (_8388 + -0.05000000074505806f) / (_8384 - _8344);
                                                                        _8399 = (((select((_8386 < _8344), 1.0f, 0.0f) - _8388) / (_8386 - _8384)) - _8393) / (_8386 - _8344);
                                                                        _8401 = _8393 - (_8399 * _8384);
                                                                        _8414 = (exp2((_8323.x * -1.4426950216293335f) * saturate((dot(float2(_8346, _8354), float2((_8401 - (_8399 * _8344)), _8399)) + 0.05000000074505806f) - (_8401 * _8344))) * _8317);
                                                                      } else {
                                                                        _8414 = _8317;
                                                                      }
                                                                    }
                                                                    _8419 = _8316;
                                                                    _8420 = _8414;
                                                                    _8421 = (lerp(_8414, _8315, _8316));
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            do {
                                                              _8442 = _7402;
                                                              _8443 = _7403;
                                                              _8444 = _7405;
                                                              [branch]
                                                              if (!(_7417 == 0)) {
                                                                Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _7417)))];
                                                                _8434 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_7495 * f16tof32(((uint)((uint)(_7382) >> 16)))) + f16tof32(((uint)((uint)(_7385) >> 16)))), ((_7496 * f16tof32(_7382)) + f16tof32(_7385))), 0.0f);
                                                                _8442 = (_8434.x * _7402);
                                                                _8443 = (_8434.y * _7403);
                                                                _8444 = (_8434.z * _7405);
                                                              }
                                                              _8445 = _8420 * _7519;
                                                              _8446 = _8421 * _7519;
                                                              [branch]
                                                              if (!(_8445 == 0.0f)) {
                                                                do {
                                                                  _8464 = GetDeferredSoftShadowChannel(_1626);
                                                                  if (_8464 < 0) {
                                                                        _8489 = _8445;
                                                                        do {
                                                                          _9584 = _1611;
                                                                          _9585 = _1612;
                                                                          _9586 = _1613;
                                                                          _9587 = _1614;
                                                                          _9588 = _1615;
                                                                          _9589 = _1616;
                                                                          [branch]
                                                                          if (_8489 > 0.0f) {
                                                                            do {
                                                                              _8595 = _8442;
                                                                              _8596 = _8443;
                                                                              _8597 = _8444;
                                                                              _8598 = 0.0f;
                                                                              if (_7423) {
                                                                                [branch]
                                                                                if (!((_7379 & 1) == 0)) {
                                                                                  _8505 = max(max(_8442, _8443), _8444);
                                                                                  do {
                                                                                    _8515 = _8442;
                                                                                    _8516 = _8443;
                                                                                    _8517 = _8444;
                                                                                    if (_8505 > 0.0f) {
                                                                                      _8515 = saturate(_8442 / _8505);
                                                                                      _8516 = saturate(_8443 / _8505);
                                                                                      _8517 = saturate(_8444 / _8505);
                                                                                    }
                                                                                    _8518 = (_8516 < _8517);
                                                                                    _8519 = select(_8518, _8517, _8516);
                                                                                    _8520 = select(_8518, _8516, _8517);
                                                                                    _8521 = select(_8518, -1.0f, 0.0f);
                                                                                    _8522 = (_8515 < _8519);
                                                                                    _8524 = select(_8522, _8519, _8515);
                                                                                    _8525 = select(_8522, _8515, _8519);
                                                                                    _8529 = _8524 - select((_8525 < _8520), _8525, _8520);
                                                                                    _8535 = abs(select(_8522, (-0.3333333432674408f - _8521), _8521) + ((_8525 - _8520) / ((_8529 * 6.0f) + 9.999999682655225e-21f)));
                                                                                    do {
                                                                                      _8548 = _8535;
                                                                                      if (_8535 < 0.6666666865348816f) {
                                                                                        _8548 = ((saturate(((float)((uint)((uint)(((uint)(_7379) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8535 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8535)) + _8535);
                                                                                      }
                                                                                      _8549 = saturate((_8529 / (_8524 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7379) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                      _8550 = saturate(_8524);
                                                                                      do {
                                                                                        _8577 = _8550;
                                                                                        _8578 = _8550;
                                                                                        _8579 = _8550;
                                                                                        if (!(_8549 <= 0.0f)) {
                                                                                          _8553 = saturate(_8548);
                                                                                          _8557 = select(((_8553 * 360.0f) >= 360.0f), 0.0f, (_8553 * 6.0f));
                                                                                          _8558 = int(_8557);
                                                                                          _8560 = _8557 - float((int)(_8558));
                                                                                          _8562 = _8550 * (1.0f - _8549);
                                                                                          _8565 = (1.0f - (_8560 * _8549)) * _8550;
                                                                                          _8569 = (1.0f - ((1.0f - _8560) * _8549)) * _8550;
                                                                                          switch (_8558) {
                                                                                            case 0: {
                                                                                              _8577 = _8550;
                                                                                              _8578 = _8569;
                                                                                              _8579 = _8562;
                                                                                              break;
                                                                                            }
                                                                                            case 1: {
                                                                                              _8577 = _8565;
                                                                                              _8578 = _8550;
                                                                                              _8579 = _8562;
                                                                                              break;
                                                                                            }
                                                                                            case 2: {
                                                                                              _8577 = _8562;
                                                                                              _8578 = _8550;
                                                                                              _8579 = _8569;
                                                                                              break;
                                                                                            }
                                                                                            case 3: {
                                                                                              _8577 = _8562;
                                                                                              _8578 = _8565;
                                                                                              _8579 = _8550;
                                                                                              break;
                                                                                            }
                                                                                            case 4: {
                                                                                              _8577 = _8569;
                                                                                              _8578 = _8562;
                                                                                              _8579 = _8550;
                                                                                              break;
                                                                                            }
                                                                                            case 5: {
                                                                                              _8577 = _8550;
                                                                                              _8578 = _8562;
                                                                                              _8579 = _8565;
                                                                                              break;
                                                                                            }
                                                                                            default: {
                                                                                              _8577 = 0.0f;
                                                                                              _8578 = 0.0f;
                                                                                              _8579 = 0.0f;
                                                                                              break;
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                        _8580 = _8577 * _8505;
                                                                                        _8581 = _8578 * _8505;
                                                                                        _8582 = _8579 * _8505;
                                                                                        _8584 = saturate(_8420 * 1.0101009607315063f);
                                                                                        _8595 = ((_8584 * (_8442 - _8580)) + _8580);
                                                                                        _8596 = ((_8584 * (_8443 - _8581)) + _8581);
                                                                                        _8597 = (lerp(_8582, _8444, _8584));
                                                                                        _8598 = _8419;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } else {
                                                                                  _8595 = _8442;
                                                                                  _8596 = _8443;
                                                                                  _8597 = _8444;
                                                                                  _8598 = _8419;
                                                                                }
                                                                              }
                                                                              do {
                                                                                _8638 = _8446;
                                                                                _8639 = _8446;
                                                                                [branch]
                                                                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                  _8605 = srvLightMappingData[_1626];
                                                                                  if (!(_8605 == -1)) {
                                                                                    _8610 = srvLightIndexData[_8605].nLayerIndex;
                                                                                    _8612 = srvLightIndexData[_8605].vAtlasOrigin.x;
                                                                                    _8613 = srvLightIndexData[_8605].vAtlasOrigin.y;
                                                                                    _8615 = srvLightIndexData[_8605].vScreenOrigin.x;
                                                                                    _8616 = srvLightIndexData[_8605].vScreenOrigin.y;
                                                                                    _8625 = ((int)(_8610 * 5)) & 31;
                                                                                    _8628 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8612 + _67) - _8615)), ((int)((_8613 + _68) - _8616)), 0)))).x) & ((int)(31 << _8625)))) >> _8625;
                                                                                    _8638 = ((_8446 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_8628) >> 1)))));
                                                                                    _8639 = (((float)((bool)(uint)((_8628 & 1) != 0))) * _8446);
                                                                                  } else {
                                                                                    _8638 = _8446;
                                                                                    _8639 = _8446;
                                                                                  }
                                                                                }
                                                                                _8643 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                                _8646 = select(_8643, (_8638 * _1276), _8638);
                                                                                _8648 = _7447 * _7446;
                                                                                _8649 = _7448 * _7446;
                                                                                _8650 = _7449 * _7446;
                                                                                _8651 = _7410 * _7347;
                                                                                _8652 = _7410 * _7348;
                                                                                _8653 = _7410 * _7349;
                                                                                _8654 = _8648 + _8651;
                                                                                _8655 = _8649 + _8652;
                                                                                _8656 = _8650 + _8653;
                                                                                _8658 = -0.0f - _458;
                                                                                _8659 = -0.0f - _459;
                                                                                _8660 = -0.0f - _457;
                                                                                do {
                                                                                  _8720 = _8654;
                                                                                  _8721 = _8655;
                                                                                  _8722 = _8656;
                                                                                  if (_7410 > 0.0f) {
                                                                                    _8666 = dot(float3(_8658, _8659, _8660), float3(_205, _207, _209)) * 2.0f;
                                                                                    _8670 = _8658 - (_8666 * _205);
                                                                                    _8671 = _8659 - (_8666 * _207);
                                                                                    _8672 = _8660 - (_8666 * _209);
                                                                                    _8673 = (_8648 - _8651) - _8654;
                                                                                    _8674 = (_8649 - _8652) - _8655;
                                                                                    _8675 = (_8650 - _8653) - _8656;
                                                                                    _8676 = dot(float3(_8670, _8671, _8672), float3(_8673, _8674, _8675));
                                                                                    _8682 = sqrt(((_8673 * _8673) + (_8674 * _8674)) + (_8675 * _8675));
                                                                                    _8691 = saturate(((dot(float3(_8670, _8671, _8672), float3(_8654, _8655, _8656)) * _8676) - dot(float3(_8654, _8655, _8656), float3(_8673, _8674, _8675))) / ((_8682 * _8682) - (_8676 * _8676)));
                                                                                    _8695 = (_8691 * _8673) + _8654;
                                                                                    _8696 = (_8691 * _8674) + _8655;
                                                                                    _8697 = (_8691 * _8675) + _8656;
                                                                                    _8698 = dot(float3(_8695, _8696, _8697), float3(_8670, _8671, _8672));
                                                                                    _8702 = (_8698 * _8670) - _8695;
                                                                                    _8703 = (_8698 * _8671) - _8696;
                                                                                    _8704 = (_8698 * _8672) - _8697;
                                                                                    _8712 = saturate(0.009999999776482582f / sqrt(((_8702 * _8702) + (_8703 * _8703)) + (_8704 * _8704)));
                                                                                    _8720 = ((_8712 * _8702) + _8695);
                                                                                    _8721 = ((_8712 * _8703) + _8696);
                                                                                    _8722 = ((_8712 * _8704) + _8697);
                                                                                  }
                                                                                  _8724 = rsqrt(dot(float3(_8720, _8721, _8722), float3(_8720, _8721, _8722)));
                                                                                  _8725 = _8724 * _8720;
                                                                                  _8726 = _8724 * _8721;
                                                                                  _8727 = _8724 * _8722;
                                                                                  _8729 = rsqrt(dot(float3(_8648, _8649, _8650), float3(_8648, _8649, _8650)));
                                                                                  _8730 = _8729 * _8648;
                                                                                  _8731 = _8729 * _8649;
                                                                                  _8732 = _8729 * _8650;
                                                                                  _8734 = saturate(dot(float3(_205, _207, _209), float3(_8730, _8731, _8732)));
                                                                                  _8737 = uint((_180 * 255.0f) + 0.5f);
                                                                                  _8746 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                                                  _8747 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                                                  _8748 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                                                  _8761 = ((dot(float3(_206, _208, _210), float3(_8730, _8731, _8732)) + dot(float3(_8658, _8659, _8660), float3(_8730, _8731, _8732))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_8737) >> 2)))) * 0.1666666716337204f)));
                                                                                  _8768 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                                                  _8771 = saturate((_8768 + -0.009999999776482582f) * -100.0f);
                                                                                  _8776 = ((_8771 * _8771) * 3.0f) * (3.0f - (_8771 * 2.0f));
                                                                                  _8783 = 10.0f - (exp2(log2(saturate(_8768 * 5.0f)) * 3.0f) * 9.0f);
                                                                                  _8784 = saturate(_8734 + _8746) * _8734;
                                                                                  _8785 = saturate(_8734 + _8747) * _8734;
                                                                                  _8786 = saturate(_8734 + _8748) * _8734;
                                                                                  _8808 = _8725 + _458;
                                                                                  _8809 = _8726 + _459;
                                                                                  _8810 = _8727 + _457;
                                                                                  _8812 = rsqrt(dot(float3(_8808, _8809, _8810), float3(_8808, _8809, _8810)));
                                                                                  do {
                                                                                    _9116 = 0.0f;
                                                                                    _9117 = 0.0f;
                                                                                    _9118 = 0.0f;
                                                                                    if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                                      _8827 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                                      _8828 = _8827 * _205;
                                                                                      _8829 = _8827 * _207;
                                                                                      _8830 = _8827 * _209;
                                                                                      _8833 = (abs(_8828) < abs(_8829));
                                                                                      _8834 = select(_8833, 1.0f, 0.0f);
                                                                                      _8835 = select(_8833, 0.0f, 1.0f);
                                                                                      _8836 = _8835 * _8830;
                                                                                      _8838 = -0.0f - (_8830 * _8834);
                                                                                      _8841 = (_8834 * _8829) - (_8835 * _8828);
                                                                                      _8843 = rsqrt(dot(float3(_8836, _8838, _8841), float3(_8836, _8838, _8841)));
                                                                                      _8844 = _8836 * _8843;
                                                                                      _8845 = _8843 * _8838;
                                                                                      _8846 = _8841 * _8843;
                                                                                      _8849 = (_8845 * _8830) - (_8846 * _8829);
                                                                                      _8852 = (_8846 * _8828) - (_8844 * _8830);
                                                                                      _8855 = (_8844 * _8829) - (_8845 * _8828);
                                                                                      _8857 = rsqrt(dot(float3(_8849, _8852, _8855), float3(_8849, _8852, _8855)));
                                                                                      _8861 = _178 * 4.0f;
                                                                                      _8870 = saturate(abs(_8861 + -2.5f) + -0.5f) + -0.5f;
                                                                                      _8871 = saturate(1.5f - abs(_8861 + -1.5f)) + -0.5f;
                                                                                      _8873 = rsqrt(dot(float2(_8870, _8871), float2(_8870, _8871)));
                                                                                      _8874 = _8873 * _8870;
                                                                                      _8875 = _8873 * _8871;
                                                                                      _8882 = ((_8849 * _8857) * _8874) + (_8875 * _8844);
                                                                                      _8883 = ((_8852 * _8857) * _8874) + (_8875 * _8845);
                                                                                      _8884 = ((_8855 * _8857) * _8874) + (_8875 * _8846);
                                                                                      _8885 = dot(float3(_458, _459, _457), float3(_8725, _8726, _8727));
                                                                                      _8888 = min(max(dot(float3(_8882, _8883, _8884), float3(_8725, _8726, _8727)), -1.0f), 1.0f);
                                                                                      _8891 = min(max(dot(float3(_8882, _8883, _8884), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                                      _8892 = abs(_8891);
                                                                                      _8897 = (1.5707963705062866f - (_8892 * 0.1565829962491989f)) * sqrt(1.0f - _8892);
                                                                                      _8901 = abs(_8888);
                                                                                      _8906 = (1.5707963705062866f - (_8901 * 0.1565829962491989f)) * sqrt(1.0f - _8901);
                                                                                      _8913 = cos(abs(select((_8888 >= 0.0f), _8906, (3.1415927410125732f - _8906)) - select((_8891 >= 0.0f), _8897, (3.1415927410125732f - _8897))) * 0.5f);
                                                                                      _8917 = _8725 - (_8888 * _8882);
                                                                                      _8918 = _8726 - (_8888 * _8883);
                                                                                      _8919 = _8727 - (_8888 * _8884);
                                                                                      _8923 = _458 - (_8891 * _8882);
                                                                                      _8924 = _459 - (_8891 * _8883);
                                                                                      _8925 = _457 - (_8891 * _8884);
                                                                                      _8932 = rsqrt((dot(float3(_8923, _8924, _8925), float3(_8923, _8924, _8925)) * dot(float3(_8917, _8918, _8919), float3(_8917, _8918, _8919))) + 9.999999747378752e-05f) * dot(float3(_8917, _8918, _8919), float3(_8923, _8924, _8925));
                                                                                      _8936 = sqrt(saturate((_8932 * 0.5f) + 0.5f));
                                                                                      _8940 = _224 * _224;
                                                                                      _8941 = _8940 * 0.5f;
                                                                                      _8942 = _8940 * 2.0f;
                                                                                      _8946 = exp2((1.0f - abs(_8598)) * -72.13475036621094f);
                                                                                      do {
                                                                                        _8953 = _8946;
                                                                                        if (!((_8737 & 1) == 0)) {
                                                                                          _8953 = select(((select(((_8737 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_8598 == -1.0f))), 0.0f, _8946);
                                                                                        }
                                                                                        _8957 = saturate((dot(float3(_205, _207, _209), float3(_8725, _8726, _8727)) + 0.5f) * 0.6666666865348816f);
                                                                                        _8967 = (_8891 + _8888) + ((((_8936 * 0.9975510239601135f) * sqrt(1.0f - (_8891 * _8891))) - (_8891 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                                        _8969 = (_8940 * 1.4142135381698608f) * _8936;
                                                                                        _8982 = 1.0f - sqrt(saturate((_8885 * 0.5f) + 0.5f));
                                                                                        _8983 = _8982 * _8982;
                                                                                        _8989 = saturate(-0.0f - _8885);
                                                                                        _8992 = (1.0f - saturate(_8989)) * _8957;
                                                                                        _9001 = ((((_8936 * 0.5f) * (exp2((((_8967 * _8967) * -0.5f) / (_8969 * _8969)) * 1.4426950216293335f) / (_8969 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_8983 * _8983) * (_8982 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_8992, 1.0f, _8953));
                                                                                        _9003 = (_8888 + -0.03500000014901161f) + _8891;
                                                                                        _9012 = 1.0f / ((1.190000057220459f / _8913) + (_8913 * 0.36000001430511475f));
                                                                                        _9017 = ((_9012 * (0.6000000238418579f - (_8932 * 0.800000011920929f))) + 1.0f) * _8936;
                                                                                        _9023 = 1.0f - (sqrt(saturate(1.0f - (_9017 * _9017))) * _8913);
                                                                                        _9024 = _9023 * _9023;
                                                                                        _9028 = 0.9534794092178345f - ((_9024 * _9024) * (_9023 * 0.9534794092178345f));
                                                                                        _9029 = _9017 * _9012;
                                                                                        _9034 = (sqrt(1.0f - (_9029 * _9029)) * 0.5f) / _8913;
                                                                                        _9053 = 1.0f - saturate((_8989 + -0.44999998807907104f) * 2.222222328186035f);
                                                                                        _9056 = ((1.0f - _8957) * _8953) + _8957;
                                                                                        _9059 = ((_9028 * _9028) * (exp2((((_9003 * _9003) * -0.5f) / (_8941 * _8941)) * 1.4426950216293335f) / (_8940 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_8932 * 5.2658371925354f));
                                                                                        _9073 = (_8888 + -0.14000000059604645f) + _8891;
                                                                                        _9083 = 1.0f - (_8913 * 0.5f);
                                                                                        _9084 = _9083 * _9083;
                                                                                        _9088 = (_9084 * _9084) * (0.9534794092178345f - (_8913 * 0.47673970460891724f));
                                                                                        _9090 = 0.9534794092178345f - _9088;
                                                                                        _9092 = (_9090 * _9090) * (_9088 + 0.04652056470513344f);
                                                                                        _9095 = exp2((_8932 * 24.525815963745117f) + -24.208423614501953f);
                                                                                        _9108 = ((exp2((((_9073 * _9073) * -0.5f) / (_8942 * _8942)) * 1.4426950216293335f) / (_8940 * 5.013256549835205f)) * (lerp(_9092, 1.0f, _172))) * (((exp2((saturate(dot(float3((_8812 * _8808), (_8812 * _8809), (_8812 * _8810)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _9095) * _172) + _9095);
                                                                                        _9116 = (((((exp2(log2(max(_168, 0.0f)) * _9034) * _9056) * _9059) * _9053) + _9001) + (_9108 * _168));
                                                                                        _9117 = (((((exp2(log2(max(_169, 0.0f)) * _9034) * _9056) * _9059) * _9053) + _9001) + (_9108 * _169));
                                                                                        _9118 = (((((exp2(log2(max(_170, 0.0f)) * _9034) * _9056) * _9059) * _9053) + _9001) + (_9108 * _170));
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    }
                                                                                    _9119 = _8595 * _1674;
                                                                                    _9120 = _8596 * _1674;
                                                                                    _9121 = _8597 * _1674;
                                                                                    _9128 = ((_8646 * _9119) * ((max(((_8776 + _8746) * _8761), 0.0f) * _8783) + sqrt(_8784 * _8784))) + _1611;
                                                                                    _9129 = ((_8646 * _9120) * ((max(((_8776 + _8747) * _8761), 0.0f) * _8783) + sqrt(_8785 * _8785))) + _1612;
                                                                                    _9130 = ((_8646 * _9121) * ((max(((_8776 + _8748) * _8761), 0.0f) * _8783) + sqrt(_8786 * _8786))) + _1613;
                                                                                    if (_7409 > 0.0f) {
                                                                                      _9134 = (_7409 * _1367) * select(_8643, (_8639 * _1276), _8639);
                                                                                      _9584 = _9128;
                                                                                      _9585 = _9129;
                                                                                      _9586 = _9130;
                                                                                      _9587 = (((_9134 * _9119) * _9116) + _1614);
                                                                                      _9588 = (((_9134 * _9120) * _9117) + _1615);
                                                                                      _9589 = (((_9134 * _9121) * _9118) + _1616);
                                                                                    } else {
                                                                                      _9584 = _9128;
                                                                                      _9585 = _9129;
                                                                                      _9586 = _9130;
                                                                                      _9587 = _1614;
                                                                                      _9588 = _1615;
                                                                                      _9589 = _1616;
                                                                                    }
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
                                                                  _8467 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_67, _68, 0));
                                                                  do {
                                                                    if (_8464 == 0) {
                                                                      _8481 = _8467.x;
                                                                    } else {
                                                                      if (_8464 == 1) {
                                                                        _8481 = _8467.y;
                                                                      } else {
                                                                        if (_8464 == 2) {
                                                                          _8481 = _8467.z;
                                                                        } else {
                                                                          _8481 = _8467.w;
                                                                        }
                                                                      }
                                                                    }
                                                                    _8489 = ((((_8419 * _8419) * ((_8481 * _8481) + -1.0f)) + 1.0f) * _7519);
                                                                    [branch]
                                                                    if (_8489 > 0.0f) {
                                                                      do {
                                                                        _8595 = _8442;
                                                                        _8596 = _8443;
                                                                        _8597 = _8444;
                                                                        _8598 = 0.0f;
                                                                        if (_7423) {
                                                                          [branch]
                                                                          if (!((_7379 & 1) == 0)) {
                                                                            _8505 = max(max(_8442, _8443), _8444);
                                                                            do {
                                                                              _8515 = _8442;
                                                                              _8516 = _8443;
                                                                              _8517 = _8444;
                                                                              if (_8505 > 0.0f) {
                                                                                _8515 = saturate(_8442 / _8505);
                                                                                _8516 = saturate(_8443 / _8505);
                                                                                _8517 = saturate(_8444 / _8505);
                                                                              }
                                                                              _8518 = (_8516 < _8517);
                                                                              _8519 = select(_8518, _8517, _8516);
                                                                              _8520 = select(_8518, _8516, _8517);
                                                                              _8521 = select(_8518, -1.0f, 0.0f);
                                                                              _8522 = (_8515 < _8519);
                                                                              _8524 = select(_8522, _8519, _8515);
                                                                              _8525 = select(_8522, _8515, _8519);
                                                                              _8529 = _8524 - select((_8525 < _8520), _8525, _8520);
                                                                              _8535 = abs(select(_8522, (-0.3333333432674408f - _8521), _8521) + ((_8525 - _8520) / ((_8529 * 6.0f) + 9.999999682655225e-21f)));
                                                                              do {
                                                                                _8548 = _8535;
                                                                                if (_8535 < 0.6666666865348816f) {
                                                                                  _8548 = ((saturate(((float)((uint)((uint)(((uint)(_7379) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8535 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8535)) + _8535);
                                                                                }
                                                                                _8549 = saturate((_8529 / (_8524 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7379) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                _8550 = saturate(_8524);
                                                                                do {
                                                                                  _8577 = _8550;
                                                                                  _8578 = _8550;
                                                                                  _8579 = _8550;
                                                                                  if (!(_8549 <= 0.0f)) {
                                                                                    _8553 = saturate(_8548);
                                                                                    _8557 = select(((_8553 * 360.0f) >= 360.0f), 0.0f, (_8553 * 6.0f));
                                                                                    _8558 = int(_8557);
                                                                                    _8560 = _8557 - float((int)(_8558));
                                                                                    _8562 = _8550 * (1.0f - _8549);
                                                                                    _8565 = (1.0f - (_8560 * _8549)) * _8550;
                                                                                    _8569 = (1.0f - ((1.0f - _8560) * _8549)) * _8550;
                                                                                    switch (_8558) {
                                                                                      case 0: {
                                                                                        _8577 = _8550;
                                                                                        _8578 = _8569;
                                                                                        _8579 = _8562;
                                                                                        break;
                                                                                      }
                                                                                      case 1: {
                                                                                        _8577 = _8565;
                                                                                        _8578 = _8550;
                                                                                        _8579 = _8562;
                                                                                        break;
                                                                                      }
                                                                                      case 2: {
                                                                                        _8577 = _8562;
                                                                                        _8578 = _8550;
                                                                                        _8579 = _8569;
                                                                                        break;
                                                                                      }
                                                                                      case 3: {
                                                                                        _8577 = _8562;
                                                                                        _8578 = _8565;
                                                                                        _8579 = _8550;
                                                                                        break;
                                                                                      }
                                                                                      case 4: {
                                                                                        _8577 = _8569;
                                                                                        _8578 = _8562;
                                                                                        _8579 = _8550;
                                                                                        break;
                                                                                      }
                                                                                      case 5: {
                                                                                        _8577 = _8550;
                                                                                        _8578 = _8562;
                                                                                        _8579 = _8565;
                                                                                        break;
                                                                                      }
                                                                                      default: {
                                                                                        _8577 = 0.0f;
                                                                                        _8578 = 0.0f;
                                                                                        _8579 = 0.0f;
                                                                                        break;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  _8580 = _8577 * _8505;
                                                                                  _8581 = _8578 * _8505;
                                                                                  _8582 = _8579 * _8505;
                                                                                  _8584 = saturate(_8420 * 1.0101009607315063f);
                                                                                  _8595 = ((_8584 * (_8442 - _8580)) + _8580);
                                                                                  _8596 = ((_8584 * (_8443 - _8581)) + _8581);
                                                                                  _8597 = (lerp(_8582, _8444, _8584));
                                                                                  _8598 = _8419;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } else {
                                                                            _8595 = _8442;
                                                                            _8596 = _8443;
                                                                            _8597 = _8444;
                                                                            _8598 = _8419;
                                                                          }
                                                                        }
                                                                        do {
                                                                          _8638 = _8446;
                                                                          _8639 = _8446;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _8605 = srvLightMappingData[_1626];
                                                                            if (!(_8605 == -1)) {
                                                                              _8610 = srvLightIndexData[_8605].nLayerIndex;
                                                                              _8612 = srvLightIndexData[_8605].vAtlasOrigin.x;
                                                                              _8613 = srvLightIndexData[_8605].vAtlasOrigin.y;
                                                                              _8615 = srvLightIndexData[_8605].vScreenOrigin.x;
                                                                              _8616 = srvLightIndexData[_8605].vScreenOrigin.y;
                                                                              _8625 = ((int)(_8610 * 5)) & 31;
                                                                              _8628 = (uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8612 + _67) - _8615)), ((int)((_8613 + _68) - _8616)), 0)))).x) & ((int)(31 << _8625)))) >> _8625;
                                                                              _8638 = ((_8446 * 0.06666667014360428f) * ((float)((uint)((uint)((uint)(_8628) >> 1)))));
                                                                              _8639 = (((float)((bool)(uint)((_8628 & 1) != 0))) * _8446);
                                                                            } else {
                                                                              _8638 = _8446;
                                                                              _8639 = _8446;
                                                                            }
                                                                          }
                                                                          _8643 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _8646 = select(_8643, (_8638 * _1276), _8638);
                                                                          _8648 = _7447 * _7446;
                                                                          _8649 = _7448 * _7446;
                                                                          _8650 = _7449 * _7446;
                                                                          _8651 = _7410 * _7347;
                                                                          _8652 = _7410 * _7348;
                                                                          _8653 = _7410 * _7349;
                                                                          _8654 = _8648 + _8651;
                                                                          _8655 = _8649 + _8652;
                                                                          _8656 = _8650 + _8653;
                                                                          _8658 = -0.0f - _458;
                                                                          _8659 = -0.0f - _459;
                                                                          _8660 = -0.0f - _457;
                                                                          do {
                                                                            _8720 = _8654;
                                                                            _8721 = _8655;
                                                                            _8722 = _8656;
                                                                            if (_7410 > 0.0f) {
                                                                              _8666 = dot(float3(_8658, _8659, _8660), float3(_205, _207, _209)) * 2.0f;
                                                                              _8670 = _8658 - (_8666 * _205);
                                                                              _8671 = _8659 - (_8666 * _207);
                                                                              _8672 = _8660 - (_8666 * _209);
                                                                              _8673 = (_8648 - _8651) - _8654;
                                                                              _8674 = (_8649 - _8652) - _8655;
                                                                              _8675 = (_8650 - _8653) - _8656;
                                                                              _8676 = dot(float3(_8670, _8671, _8672), float3(_8673, _8674, _8675));
                                                                              _8682 = sqrt(((_8673 * _8673) + (_8674 * _8674)) + (_8675 * _8675));
                                                                              _8691 = saturate(((dot(float3(_8670, _8671, _8672), float3(_8654, _8655, _8656)) * _8676) - dot(float3(_8654, _8655, _8656), float3(_8673, _8674, _8675))) / ((_8682 * _8682) - (_8676 * _8676)));
                                                                              _8695 = (_8691 * _8673) + _8654;
                                                                              _8696 = (_8691 * _8674) + _8655;
                                                                              _8697 = (_8691 * _8675) + _8656;
                                                                              _8698 = dot(float3(_8695, _8696, _8697), float3(_8670, _8671, _8672));
                                                                              _8702 = (_8698 * _8670) - _8695;
                                                                              _8703 = (_8698 * _8671) - _8696;
                                                                              _8704 = (_8698 * _8672) - _8697;
                                                                              _8712 = saturate(0.009999999776482582f / sqrt(((_8702 * _8702) + (_8703 * _8703)) + (_8704 * _8704)));
                                                                              _8720 = ((_8712 * _8702) + _8695);
                                                                              _8721 = ((_8712 * _8703) + _8696);
                                                                              _8722 = ((_8712 * _8704) + _8697);
                                                                            }
                                                                            _8724 = rsqrt(dot(float3(_8720, _8721, _8722), float3(_8720, _8721, _8722)));
                                                                            _8725 = _8724 * _8720;
                                                                            _8726 = _8724 * _8721;
                                                                            _8727 = _8724 * _8722;
                                                                            _8729 = rsqrt(dot(float3(_8648, _8649, _8650), float3(_8648, _8649, _8650)));
                                                                            _8730 = _8729 * _8648;
                                                                            _8731 = _8729 * _8649;
                                                                            _8732 = _8729 * _8650;
                                                                            _8734 = saturate(dot(float3(_205, _207, _209), float3(_8730, _8731, _8732)));
                                                                            _8737 = uint((_180 * 255.0f) + 0.5f);
                                                                            _8746 = ((_168 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f;
                                                                            _8747 = ((_169 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f;
                                                                            _8748 = ((_170 + -0.5f) * 0.5f) + 0.5f;
                                                                            _8761 = ((dot(float3(_206, _208, _210), float3(_8730, _8731, _8732)) + dot(float3(_8658, _8659, _8660), float3(_8730, _8731, _8732))) * 0.5f) * exp2(log2(1.0f - saturate(dot(float3(_205, _207, _209), float3(_458, _459, _457)))) * (11.0f - (((float)((uint)((uint)((uint)(_8737) >> 2)))) * 0.1666666716337204f)));
                                                                            _8768 = dot(float3(_168, _169, _170), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                                                                            _8771 = saturate((_8768 + -0.009999999776482582f) * -100.0f);
                                                                            _8776 = ((_8771 * _8771) * 3.0f) * (3.0f - (_8771 * 2.0f));
                                                                            _8783 = 10.0f - (exp2(log2(saturate(_8768 * 5.0f)) * 3.0f) * 9.0f);
                                                                            _8784 = saturate(_8734 + _8746) * _8734;
                                                                            _8785 = saturate(_8734 + _8747) * _8734;
                                                                            _8786 = saturate(_8734 + _8748) * _8734;
                                                                            _8808 = _8725 + _458;
                                                                            _8809 = _8726 + _459;
                                                                            _8810 = _8727 + _457;
                                                                            _8812 = rsqrt(dot(float3(_8808, _8809, _8810), float3(_8808, _8809, _8810)));
                                                                            do {
                                                                              _9116 = 0.0f;
                                                                              _9117 = 0.0f;
                                                                              _9118 = 0.0f;
                                                                              if (!(select(((_232 & 1) != 0), 1.0f, 0.0f) < 1.0f)) {
                                                                                _8827 = rsqrt(dot(float3(_205, _207, _209), float3(_205, _207, _209)));
                                                                                _8828 = _8827 * _205;
                                                                                _8829 = _8827 * _207;
                                                                                _8830 = _8827 * _209;
                                                                                _8833 = (abs(_8828) < abs(_8829));
                                                                                _8834 = select(_8833, 1.0f, 0.0f);
                                                                                _8835 = select(_8833, 0.0f, 1.0f);
                                                                                _8836 = _8835 * _8830;
                                                                                _8838 = -0.0f - (_8830 * _8834);
                                                                                _8841 = (_8834 * _8829) - (_8835 * _8828);
                                                                                _8843 = rsqrt(dot(float3(_8836, _8838, _8841), float3(_8836, _8838, _8841)));
                                                                                _8844 = _8836 * _8843;
                                                                                _8845 = _8843 * _8838;
                                                                                _8846 = _8841 * _8843;
                                                                                _8849 = (_8845 * _8830) - (_8846 * _8829);
                                                                                _8852 = (_8846 * _8828) - (_8844 * _8830);
                                                                                _8855 = (_8844 * _8829) - (_8845 * _8828);
                                                                                _8857 = rsqrt(dot(float3(_8849, _8852, _8855), float3(_8849, _8852, _8855)));
                                                                                _8861 = _178 * 4.0f;
                                                                                _8870 = saturate(abs(_8861 + -2.5f) + -0.5f) + -0.5f;
                                                                                _8871 = saturate(1.5f - abs(_8861 + -1.5f)) + -0.5f;
                                                                                _8873 = rsqrt(dot(float2(_8870, _8871), float2(_8870, _8871)));
                                                                                _8874 = _8873 * _8870;
                                                                                _8875 = _8873 * _8871;
                                                                                _8882 = ((_8849 * _8857) * _8874) + (_8875 * _8844);
                                                                                _8883 = ((_8852 * _8857) * _8874) + (_8875 * _8845);
                                                                                _8884 = ((_8855 * _8857) * _8874) + (_8875 * _8846);
                                                                                _8885 = dot(float3(_458, _459, _457), float3(_8725, _8726, _8727));
                                                                                _8888 = min(max(dot(float3(_8882, _8883, _8884), float3(_8725, _8726, _8727)), -1.0f), 1.0f);
                                                                                _8891 = min(max(dot(float3(_8882, _8883, _8884), float3(_458, _459, _457)), -1.0f), 1.0f);
                                                                                _8892 = abs(_8891);
                                                                                _8897 = (1.5707963705062866f - (_8892 * 0.1565829962491989f)) * sqrt(1.0f - _8892);
                                                                                _8901 = abs(_8888);
                                                                                _8906 = (1.5707963705062866f - (_8901 * 0.1565829962491989f)) * sqrt(1.0f - _8901);
                                                                                _8913 = cos(abs(select((_8888 >= 0.0f), _8906, (3.1415927410125732f - _8906)) - select((_8891 >= 0.0f), _8897, (3.1415927410125732f - _8897))) * 0.5f);
                                                                                _8917 = _8725 - (_8888 * _8882);
                                                                                _8918 = _8726 - (_8888 * _8883);
                                                                                _8919 = _8727 - (_8888 * _8884);
                                                                                _8923 = _458 - (_8891 * _8882);
                                                                                _8924 = _459 - (_8891 * _8883);
                                                                                _8925 = _457 - (_8891 * _8884);
                                                                                _8932 = rsqrt((dot(float3(_8923, _8924, _8925), float3(_8923, _8924, _8925)) * dot(float3(_8917, _8918, _8919), float3(_8917, _8918, _8919))) + 9.999999747378752e-05f) * dot(float3(_8917, _8918, _8919), float3(_8923, _8924, _8925));
                                                                                _8936 = sqrt(saturate((_8932 * 0.5f) + 0.5f));
                                                                                _8940 = _224 * _224;
                                                                                _8941 = _8940 * 0.5f;
                                                                                _8942 = _8940 * 2.0f;
                                                                                _8946 = exp2((1.0f - abs(_8598)) * -72.13475036621094f);
                                                                                do {
                                                                                  _8953 = _8946;
                                                                                  if (!((_8737 & 1) == 0)) {
                                                                                    _8953 = select(((select(((_8737 & 2) != 0), 1.0f, 0.0f) == 0.0f) || (!(_8598 == -1.0f))), 0.0f, _8946);
                                                                                  }
                                                                                  _8957 = saturate((dot(float3(_205, _207, _209), float3(_8725, _8726, _8727)) + 0.5f) * 0.6666666865348816f);
                                                                                  _8967 = (_8891 + _8888) + ((((_8936 * 0.9975510239601135f) * sqrt(1.0f - (_8891 * _8891))) - (_8891 * 0.06994284689426422f)) * 0.13988569378852844f);
                                                                                  _8969 = (_8940 * 1.4142135381698608f) * _8936;
                                                                                  _8982 = 1.0f - sqrt(saturate((_8885 * 0.5f) + 0.5f));
                                                                                  _8983 = _8982 * _8982;
                                                                                  _8989 = saturate(-0.0f - _8885);
                                                                                  _8992 = (1.0f - saturate(_8989)) * _8957;
                                                                                  _9001 = ((((_8936 * 0.5f) * (exp2((((_8967 * _8967) * -0.5f) / (_8969 * _8969)) * 1.4426950216293335f) / (_8969 * 2.5066282749176025f))) * min(_173, 0.5f)) * (((_8983 * _8983) * (_8982 * 0.9534794092178345f)) + 0.04652056470513344f)) * (lerp(_8992, 1.0f, _8953));
                                                                                  _9003 = (_8888 + -0.03500000014901161f) + _8891;
                                                                                  _9012 = 1.0f / ((1.190000057220459f / _8913) + (_8913 * 0.36000001430511475f));
                                                                                  _9017 = ((_9012 * (0.6000000238418579f - (_8932 * 0.800000011920929f))) + 1.0f) * _8936;
                                                                                  _9023 = 1.0f - (sqrt(saturate(1.0f - (_9017 * _9017))) * _8913);
                                                                                  _9024 = _9023 * _9023;
                                                                                  _9028 = 0.9534794092178345f - ((_9024 * _9024) * (_9023 * 0.9534794092178345f));
                                                                                  _9029 = _9017 * _9012;
                                                                                  _9034 = (sqrt(1.0f - (_9029 * _9029)) * 0.5f) / _8913;
                                                                                  _9053 = 1.0f - saturate((_8989 + -0.44999998807907104f) * 2.222222328186035f);
                                                                                  _9056 = ((1.0f - _8957) * _8953) + _8957;
                                                                                  _9059 = ((_9028 * _9028) * (exp2((((_9003 * _9003) * -0.5f) / (_8941 * _8941)) * 1.4426950216293335f) / (_8940 * 1.2533141374588013f))) * exp2(-5.741926193237305f - (_8932 * 5.2658371925354f));
                                                                                  _9073 = (_8888 + -0.14000000059604645f) + _8891;
                                                                                  _9083 = 1.0f - (_8913 * 0.5f);
                                                                                  _9084 = _9083 * _9083;
                                                                                  _9088 = (_9084 * _9084) * (0.9534794092178345f - (_8913 * 0.47673970460891724f));
                                                                                  _9090 = 0.9534794092178345f - _9088;
                                                                                  _9092 = (_9090 * _9090) * (_9088 + 0.04652056470513344f);
                                                                                  _9095 = exp2((_8932 * 24.525815963745117f) + -24.208423614501953f);
                                                                                  _9108 = ((exp2((((_9073 * _9073) * -0.5f) / (_8942 * _8942)) * 1.4426950216293335f) / (_8940 * 5.013256549835205f)) * (lerp(_9092, 1.0f, _172))) * (((exp2((saturate(dot(float3((_8812 * _8808), (_8812 * _8809), (_8812 * _8810)), float3(_205, _207, _209))) * 17.312339782714844f) + -14.109557151794434f) - _9095) * _172) + _9095);
                                                                                  _9116 = (((((exp2(log2(max(_168, 0.0f)) * _9034) * _9056) * _9059) * _9053) + _9001) + (_9108 * _168));
                                                                                  _9117 = (((((exp2(log2(max(_169, 0.0f)) * _9034) * _9056) * _9059) * _9053) + _9001) + (_9108 * _169));
                                                                                  _9118 = (((((exp2(log2(max(_170, 0.0f)) * _9034) * _9056) * _9059) * _9053) + _9001) + (_9108 * _170));
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              }
                                                                              _9119 = _8595 * _1674;
                                                                              _9120 = _8596 * _1674;
                                                                              _9121 = _8597 * _1674;
                                                                              _9128 = ((_8646 * _9119) * ((max(((_8776 + _8746) * _8761), 0.0f) * _8783) + sqrt(_8784 * _8784))) + _1611;
                                                                              _9129 = ((_8646 * _9120) * ((max(((_8776 + _8747) * _8761), 0.0f) * _8783) + sqrt(_8785 * _8785))) + _1612;
                                                                              _9130 = ((_8646 * _9121) * ((max(((_8776 + _8748) * _8761), 0.0f) * _8783) + sqrt(_8786 * _8786))) + _1613;
                                                                              if (_7409 > 0.0f) {
                                                                                _9134 = (_7409 * _1367) * select(_8643, (_8639 * _1276), _8639);
                                                                                _9584 = _9128;
                                                                                _9585 = _9129;
                                                                                _9586 = _9130;
                                                                                _9587 = (((_9134 * _9119) * _9116) + _1614);
                                                                                _9588 = (((_9134 * _9120) * _9117) + _1615);
                                                                                _9589 = (((_9134 * _9121) * _9118) + _1616);
                                                                              } else {
                                                                                _9584 = _9128;
                                                                                _9585 = _9129;
                                                                                _9586 = _9130;
                                                                                _9587 = _1614;
                                                                                _9588 = _1615;
                                                                                _9589 = _1616;
                                                                              }
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } else {
                                                                      _9584 = _1611;
                                                                      _9585 = _1612;
                                                                      _9586 = _1613;
                                                                      _9587 = _1614;
                                                                      _9588 = _1615;
                                                                      _9589 = _1616;
                                                                    }
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } else {
                                                                _9584 = _1611;
                                                                _9585 = _1612;
                                                                _9586 = _1613;
                                                                _9587 = _1614;
                                                                _9588 = _1615;
                                                                _9589 = _1616;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          if (_1657 == 10) {
                                                            _9149 = asfloat(srvLightInfoProperties.Load4(_1625)).x;
                                                            _9150 = asfloat(srvLightInfoProperties.Load4(_1625)).y;
                                                            _9151 = asfloat(srvLightInfoProperties.Load4(_1625)).z;
                                                            _9152 = asfloat(srvLightInfoProperties.Load4(_1625)).w;
                                                            _9155 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).x;
                                                            _9156 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).y;
                                                            _9157 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).z;
                                                            _9158 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 16u)))).w;
                                                            _9161 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).x;
                                                            _9162 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).y;
                                                            _9163 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).z;
                                                            _9164 = asfloat(srvLightInfoProperties.Load4(((int)(_1625 + 32u)))).w;
                                                            _9167 = asfloat(srvLightInfoProperties.Load2(((int)(_1625 + 72u)))).x;
                                                            _9168 = asfloat(srvLightInfoProperties.Load2(((int)(_1625 + 72u)))).y;
                                                            _9171 = asint(srvLightInfoProperties.Load(((int)(_1625 + 80u))));
                                                            _9174 = asint(srvLightInfoProperties.Load(((int)(_1625 + 84u))));
                                                            _9177 = asint(srvLightInfoProperties.Load(((int)(_1625 + 88u))));
                                                            _9180 = asint(srvLightInfoProperties.Load(((int)(_1625 + 96u))));
                                                            _9183 = f16tof32(_9171);
                                                            _9185 = f16tof32(((uint)((uint)(_9174) >> 16)));
                                                            _9186 = f16tof32(_9174);
                                                            _9188 = f16tof32(((uint)((uint)(_9177) >> 16)));
                                                            _9192 = ((float)((uint)((uint)(((uint)(_9177) >> 8) & 255)))) * 0.003921499941498041f;
                                                            _9194 = (float)((uint)((uint)(_9180 & 65535)));
                                                            _9198 = mad(_9151, _246, mad(_9150, _245, (_9149 * _244))) + _9152;
                                                            _9202 = mad(_9157, _246, mad(_9156, _245, (_9155 * _244))) + _9158;
                                                            _9206 = mad(_9163, _246, mad(_9162, _245, (_9161 * _244))) + _9164;
                                                            _9209 = mad(_9151, _209, mad(_9150, _207, (_9149 * _205)));
                                                            _9212 = mad(_9157, _209, mad(_9156, _207, (_9155 * _205)));
                                                            _9215 = mad(_9163, _209, mad(_9162, _207, (_9161 * _205)));
                                                            _9227 = -0.0f - mad(_9163, _457, mad(_9162, _459, (_9161 * _458)));
                                                            _9228 = _9167 * 0.5f;
                                                            _9229 = _9168 * 0.5f;
                                                            _9230 = -0.0f - _9228;
                                                            _9231 = -0.0f - _9229;
                                                            _9232 = _9230 - _9198;
                                                            _9233 = _9231 - _9202;
                                                            _9234 = -0.0f - _9206;
                                                            _9235 = _9228 - _9198;
                                                            _9236 = _9229 - _9202;
                                                            _9237 = dot(float3(_9198, _9202, _9206), float3(_9209, _9212, _9215));
                                                            _9239 = dot(float3(_9230, _9231, 0.0f), float3(_9209, _9212, _9215)) - _9237;
                                                            _9241 = dot(float3(_9228, _9231, 0.0f), float3(_9209, _9212, _9215)) - _9237;
                                                            _9243 = dot(float3(_9228, _9229, 0.0f), float3(_9209, _9212, _9215)) - _9237;
                                                            _9245 = dot(float3(_9230, _9229, 0.0f), float3(_9209, _9212, _9215)) - _9237;
                                                            _9246 = min(_9239, _9241);
                                                            do {
                                                              _9268 = 0.0f;
                                                              _9269 = 0.0f;
                                                              [branch]
                                                              if (!(!(_9246 >= 0.0f))) {
                                                                _9252 = rsqrt(dot(float3(_9235, _9233, _9234), float3(_9235, _9233, _9234)) * dot(float3(_9232, _9233, _9234), float3(_9232, _9233, _9234)));
                                                                _9254 = dot(float3(_9232, _9233, _9234), float3(_9235, _9233, _9234)) * _9252;
                                                                _9261 = rsqrt(max(((((_9254 * 0.09300000220537186f) + 0.5f) * _9254) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9252;
                                                                _9268 = (_9261 * (_9167 * _9234));
                                                                _9269 = (_9261 * (_9233 * (_9230 - _9228)));
                                                              }
                                                              do {
                                                                _9293 = 0.0f;
                                                                _9294 = _9269;
                                                                [branch]
                                                                if (!(!(min(_9241, _9243) >= 0.0f))) {
                                                                  _9276 = rsqrt(dot(float3(_9235, _9236, _9234), float3(_9235, _9236, _9234)) * dot(float3(_9235, _9233, _9234), float3(_9235, _9233, _9234)));
                                                                  _9278 = dot(float3(_9235, _9233, _9234), float3(_9235, _9236, _9234)) * _9276;
                                                                  _9285 = rsqrt(max(((((_9278 * 0.09300000220537186f) + 0.5f) * _9278) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9276;
                                                                  _9293 = (_9285 * ((_9231 - _9229) * _9234));
                                                                  _9294 = ((_9285 * (_9168 * _9235)) + _9269);
                                                                }
                                                                _9295 = min(_9243, _9245);
                                                                do {
                                                                  _9319 = _9268;
                                                                  _9320 = _9294;
                                                                  [branch]
                                                                  if (!(!(_9295 >= 0.0f))) {
                                                                    _9301 = rsqrt(dot(float3(_9232, _9236, _9234), float3(_9232, _9236, _9234)) * dot(float3(_9235, _9236, _9234), float3(_9235, _9236, _9234)));
                                                                    _9303 = dot(float3(_9235, _9236, _9234), float3(_9232, _9236, _9234)) * _9301;
                                                                    _9310 = rsqrt(max(((((_9303 * 0.09300000220537186f) + 0.5f) * _9303) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9301;
                                                                    _9319 = ((_9310 * ((_9230 - _9228) * _9234)) + _9268);
                                                                    _9320 = ((_9310 * (_9167 * _9236)) + _9294);
                                                                  }
                                                                  do {
                                                                    _9345 = _9293;
                                                                    _9346 = _9320;
                                                                    [branch]
                                                                    if (!(!(min(_9245, _9239) >= 0.0f))) {
                                                                      _9327 = rsqrt(dot(float3(_9232, _9233, _9234), float3(_9232, _9233, _9234)) * dot(float3(_9232, _9236, _9234), float3(_9232, _9236, _9234)));
                                                                      _9329 = dot(float3(_9232, _9236, _9234), float3(_9232, _9233, _9234)) * _9327;
                                                                      _9336 = rsqrt(max(((((_9329 * 0.09300000220537186f) + 0.5f) * _9329) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9327;
                                                                      _9345 = ((_9336 * (_9168 * _9234)) + _9293);
                                                                      _9346 = ((_9336 * (_9232 * (_9231 - _9229))) + _9320);
                                                                    }
                                                                    do {
                                                                      _9489 = _9345;
                                                                      _9490 = _9319;
                                                                      _9491 = _9346;
                                                                      if (min(_9246, _9295) < 0.0f) {
                                                                        [branch]
                                                                        if (!(!(max(max(_9239, _9241), max(_9243, _9245)) >= 0.0f))) {
                                                                          _9355 = -0.0f - _9209;
                                                                          _9356 = _9237 / _9212;
                                                                          _9357 = _9230 / _9212;
                                                                          _9358 = _9228 / _9212;
                                                                          _9360 = (_9231 - _9356) / _9355;
                                                                          _9362 = (_9229 - _9356) / _9355;
                                                                          _9363 = min(_9357, _9358);
                                                                          _9364 = max(_9357, _9358);
                                                                          _9365 = min(_9360, _9362);
                                                                          _9366 = max(_9360, _9362);
                                                                          _9367 = max(_9363, _9365);
                                                                          _9368 = min(_9364, _9366);
                                                                          _9369 = _9367 * _9212;
                                                                          _9371 = _9368 * _9212;
                                                                          _9373 = _9369 - _9198;
                                                                          _9374 = _9356 - _9202;
                                                                          _9375 = _9374 + (_9367 * _9355);
                                                                          _9376 = _9371 - _9198;
                                                                          _9377 = _9374 + (_9368 * _9355);
                                                                          _9378 = dot(float3(_9373, _9375, _9234), float3(_9373, _9375, _9234));
                                                                          _9379 = dot(float3(_9376, _9377, _9234), float3(_9376, _9377, _9234));
                                                                          _9381 = rsqrt(_9379 * _9378);
                                                                          _9383 = dot(float3(_9373, _9375, _9234), float3(_9376, _9377, _9234)) * _9381;
                                                                          _9390 = rsqrt(max(((((_9383 * 0.09300000220537186f) + 0.5f) * _9383) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9381;
                                                                          _9403 = (_9363 > _9365);
                                                                          _9405 = select(_9403, _9212, _9209);
                                                                          _9411 = float((int)(((int)(uint)((int)(_9405 > 0.0f))) - ((int)(uint)((int)(_9405 < 0.0f)))));
                                                                          _9415 = ((1.0f - (((float)((bool)_9403)) * 2.0f)) * _9228) * _9411;
                                                                          _9417 = _9415 - _9198;
                                                                          _9418 = (_9411 * _9229) - _9202;
                                                                          _9419 = (_9364 < _9366);
                                                                          _9421 = select(_9419, _9212, _9209);
                                                                          _9427 = float((int)(((int)(uint)((int)(_9421 > 0.0f))) - ((int)(uint)((int)(_9421 < 0.0f)))));
                                                                          _9428 = _9427 * _9228;
                                                                          _9433 = _9428 - _9198;
                                                                          _9434 = ((((((float)((bool)_9419)) * 2.0f) + -1.0f) * _9229) * _9427) - _9202;
                                                                          _9437 = rsqrt(_9378 * dot(float3(_9417, _9418, _9234), float3(_9417, _9418, _9234)));
                                                                          _9439 = dot(float3(_9417, _9418, _9234), float3(_9373, _9375, _9234)) * _9437;
                                                                          _9446 = rsqrt(max(((((_9439 * 0.09300000220537186f) + 0.5f) * _9439) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9437;
                                                                          _9459 = rsqrt(dot(float3(_9433, _9434, _9234), float3(_9433, _9434, _9234)) * _9379);
                                                                          _9461 = dot(float3(_9376, _9377, _9234), float3(_9433, _9434, _9234)) * _9459;
                                                                          _9468 = rsqrt(max(((((_9461 * 0.09300000220537186f) + 0.5f) * _9461) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9459;
                                                                          _9489 = ((((_9390 * (((_9367 - _9368) * _9355) * _9234)) + _9345) + (_9446 * ((_9418 - _9375) * _9234))) + (_9468 * ((_9377 - _9434) * _9234)));
                                                                          _9490 = ((((_9390 * ((_9212 * (_9368 - _9367)) * _9234)) + _9319) + (_9446 * ((_9369 - _9415) * _9234))) + (_9468 * ((_9428 - _9371) * _9234)));
                                                                          _9491 = ((((_9390 * ((_9377 * _9373) - (_9376 * _9375))) + _9346) + (_9446 * ((_9417 * _9375) - (_9418 * _9373)))) + (_9468 * ((_9434 * _9376) - (_9433 * _9377))));
                                                                        } else {
                                                                          _9489 = _9345;
                                                                          _9490 = _9319;
                                                                          _9491 = _9346;
                                                                        }
                                                                      }
                                                                      _9497 = sqrt(((_9490 * _9490) + (_9489 * _9489)) + (_9491 * _9491));
                                                                      _9498 = _9497 * 0.15915493667125702f;
                                                                      [branch]
                                                                      if (!(_9498 == 0.0f)) {
                                                                        _9507 = saturate((_9498 - _9183) / (1.0f - _9183)) * ((float)((bool)(uint)(_9206 <= 0.0f)));
                                                                        [branch]
                                                                        if (!(_9507 == 0.0f)) {
                                                                          do {
                                                                            _9515 = 0.0f;
                                                                            if (_9497 > 0.0f) {
                                                                              _9515 = (dot(float3(_9209, _9212, _9215), float3(_9489, _9490, _9491)) / _9497);
                                                                            }
                                                                            _9520 = _9234 / (_9227 - ((_9215 * 2.0f) * dot(float3((-0.0f - mad(_9151, _457, mad(_9150, _459, (_9149 * _458)))), (-0.0f - mad(_9157, _457, mad(_9156, _459, (_9155 * _458)))), _9227), float3(_9209, _9212, _9215))));
                                                                            _9521 = _9520 * 200.0f;
                                                                            _9529 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _9194), ((log2((_9521 * _9521) * f16tof32(((uint)((uint)(_9171) >> 16)))) * 0.5f) + 5.5f));
                                                                            _9531 = (float)((bool)(uint)(_9520 > 0.0f));
                                                                            _9532 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _9194), 10.0f);
                                                                            _9541 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_9507 * _1276), _9507);
                                                                            do {
                                                                              _9568 = _1614;
                                                                              _9569 = _1615;
                                                                              _9570 = _1616;
                                                                              if (_9192 > 0.0f) {
                                                                                _9547 = _9192 * _1367;
                                                                                _9548 = _9541 * _1674;
                                                                                _9568 = ((((((_9185 * _218) * _9547) * _9531) * _9529.x) * _9548) + _1614);
                                                                                _9569 = ((((((_9186 * _218) * _9547) * _9531) * _9529.y) * _9548) + _1615);
                                                                                _9570 = ((((((_9547 * _218) * _9188) * _9531) * _9529.z) * _9548) + _1616);
                                                                              }
                                                                              _9576 = ((_1674 * 5.4256415367126465f) * _9515) * _9541;
                                                                              _9584 = (((_9532.x * _9185) * _9576) + _1611);
                                                                              _9585 = (((_9532.y * _9186) * _9576) + _1612);
                                                                              _9586 = (((_9532.z * _9188) * _9576) + _1613);
                                                                              _9587 = _9568;
                                                                              _9588 = _9569;
                                                                              _9589 = _9570;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } else {
                                                                          _9584 = _1611;
                                                                          _9585 = _1612;
                                                                          _9586 = _1613;
                                                                          _9587 = _1614;
                                                                          _9588 = _1615;
                                                                          _9589 = _1616;
                                                                        }
                                                                      } else {
                                                                        _9584 = _1611;
                                                                        _9585 = _1612;
                                                                        _9586 = _1613;
                                                                        _9587 = _1614;
                                                                        _9588 = _1615;
                                                                        _9589 = _1616;
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
                                                            _9584 = _1611;
                                                            _9585 = _1612;
                                                            _9586 = _1613;
                                                            _9587 = _1614;
                                                            _9588 = _1615;
                                                            _9589 = _1616;
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            } else {
                                              _9584 = _1611;
                                              _9585 = _1612;
                                              _9586 = _1613;
                                              _9587 = _1614;
                                              _9588 = _1615;
                                              _9589 = _1616;
                                            }
                                          }
                                          _9590 = _1617 + 1u;
                                          do {
                                            if (!(_9590 == _global_2)) {
                                              _1611 = _9584;
                                              _1612 = _9585;
                                              _1613 = _9586;
                                              _1614 = _9587;
                                              _1615 = _9588;
                                              _1616 = _9589;
                                              _1617 = _9590;
                                              _loop_break_3 = true;
                                              break;
                                            }
                                            _9594 = _9584;
                                            _9595 = _9585;
                                            _9596 = _9586;
                                            _9597 = _9587;
                                            _9598 = _9588;
                                            _9599 = _9589;
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
                                    _9601 = rsqrt(dot(float3(_138, _139, -1.0f), float3(_138, _139, -1.0f)));
                                    _9608 = 1.0f - _224;
                                    _9619 = (1.0f - _218) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_205, _207, _209), float3((-0.0f - (_138 * _9601)), (-0.0f - (_139 * _9601)), _9601))))) * 5.0f) * (max((_9608 * _9608), _218) - _218));
                                    _9759 = (_9619 * _9594);
                                    _9760 = (_9619 * _9595);
                                    _9761 = (_9619 * _9596);
                                    _9762 = _9597;
                                    _9763 = _9598;
                                    _9764 = _9599;
                                    _9765 = _168;
                                    _9766 = _169;
                                    _9767 = _170;
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
        _9638 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _139, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _138)));
        _9641 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _139, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _138)));
        _9644 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _139, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _138)));
        do {
          [branch]
          if (!(cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0)) {
            _9665 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_9638, _9641, _9644), 0.0f);
            _9669 = _9665.x * 32.0f;
            _9670 = _9665.y * 32.0f;
            _9671 = _9665.z * 32.0f;
            _9673 = rsqrt(dot(float3(_9638, _9641, _9644), float3(_9638, _9641, _9644)));
            _9674 = _9673 * _9638;
            _9675 = _9673 * _9641;
            _9676 = _9673 * _9644;
            _9677 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
            _9678 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
            _9679 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
            _9680 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
            _9681 = dot(float3(_9674, _9675, _9676), float3(_9678, _9679, _9680));
            _9686 = (_9681 * _9681) - (dot(float3(_9678, _9679, _9680), float3(_9678, _9679, _9680)) - (_9677 * _9677));
            if ((_9681 > -0.0f) && (_9686 > 0.0f)) {
              _9691 = -0.0f - cbDeferredShading.vSunDirWS.z;
              _9704 = 74.80000305175781f / ((dot(float3(_9674, _9675, _9676), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _9677) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
              _9712 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_9674, _9676), float2(_9691, cbDeferredShading.vSunDirWS.x)) * _9704) + 0.5f), ((dot(float3(_9674, _9675, _9676), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _9691)), (cbDeferredShading.vSunDirWS.y * _9691))) * _9704) + 0.5f)), 0.0f);
              _9714 = _9686 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
              if (_9714 > 0.0f) {
                _9721 = saturate(_9714 * 5.0f);
                _9748 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _9712.x) * _9721) + _9669);
                _9749 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _9712.y) * _9721) + _9670);
                _9750 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _9712.z) * _9721) + _9671);
              } else {
                _9748 = _9669;
                _9749 = _9670;
                _9750 = _9671;
              }
            } else {
              _9748 = _9669;
              _9749 = _9670;
              _9750 = _9671;
            }
          } else {
            _9748 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
            _9749 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
            _9750 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
          }
          _9754 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
          _9759 = 0.0f;
          _9760 = 0.0f;
          _9761 = 0.0f;
          _9762 = select(_9754, 0.0f, _9748);
          _9763 = select(_9754, 0.0f, _9749);
          _9764 = select(_9754, 0.0f, _9750);
          _9765 = 0.0f;
          _9766 = 0.0f;
          _9767 = 0.0f;
        } while (false);
      }
      uavDeferredShadingPass_Specular[int2(_67, _68)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_9765 * _9759) + _9762)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_9766 * _9760) + _9763)), 7936.0f), 5.960464477539063e-08f), max(min((((_9767 * _9761) + _9764) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_67, _68)] = float3(0.0f, 0.0f, 0.0f);
    } while (false);
  }
}
