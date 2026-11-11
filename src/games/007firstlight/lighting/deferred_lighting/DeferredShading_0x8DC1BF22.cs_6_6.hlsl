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
  uint _52;
  int _58;
  uint _63;
  uint _64;
  uint _71;
  int _74;
  int _89;
  float _267;
  float _268;
  float _269;
  float _270;
  float _360;
  float _361;
  float _399;
  int _437;
  float _438;
  float _439;
  float _440;
  int _555;
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
  float _569;
  float _684;
  float _685;
  float _686;
  float _773;
  float _774;
  float _775;
  float _793;
  float _794;
  float _795;
  float _827;
  float _828;
  float _829;
  float _830;
  float _831;
  float _832;
  float _833;
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
  float _860;
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
  float _878;
  float _927;
  float _928;
  float _929;
  float _949;
  float _950;
  float _951;
  float _962;
  float _963;
  float _964;
  float _965;
  float _966;
  float _967;
  float _970;
  float _971;
  float _972;
  float _973;
  float _974;
  float _975;
  float _976;
  float _990;
  float _991;
  float _992;
  float _993;
  float _994;
  float _995;
  float _1024;
  float _1025;
  float _1026;
  float _1046;
  float _1047;
  float _1048;
  float _1059;
  float _1060;
  float _1061;
  float _1062;
  float _1063;
  float _1064;
  float _1083;
  float _1084;
  float _1085;
  float _1086;
  float _1087;
  float _1088;
  float _1107;
  float _1108;
  float _1109;
  int _1150;
  float _1151;
  float _1269;
  float _1274;
  float _1290;
  float _1347;
  float _1357;
  float _1410;
  float _1411;
  float _1412;
  float _1465;
  float _1466;
  float _1467;
  float _1577;
  float _1582;
  float _1583;
  float _1584;
  float _1585;
  float _1586;
  float _1587;
  int _1588;
  float _2206;
  float _2207;
  float _2208;
  float _2298;
  float _2307;
  float _2316;
  float _2324;
  float _2395;
  float _2404;
  float _2413;
  float _2421;
  float _2494;
  float _2503;
  float _2512;
  float _2520;
  float _2593;
  float _2602;
  float _2611;
  float _2619;
  float _2671;
  float _2676;
  float _2773;
  float _2794;
  float _2795;
  float _2796;
  int _2815;
  float _2832;
  float _2836;
  float _2875;
  float _2907;
  float _3016;
  float _3017;
  float _3030;
  float _3042;
  float _3221;
  float _3222;
  float _3280;
  float _3368;
  float _3369;
  float _3370;
  float _3399;
  float _3508;
  float _3509;
  float _3522;
  float _3534;
  float _3713;
  float _3714;
  float _3766;
  float _3767;
  float _3768;
  float _3799;
  float _3828;
  float _3829;
  float _3830;
  float _3846;
  float _3847;
  float _3848;
  float _3861;
  float _3862;
  float _3863;
  float _4026;
  float _4027;
  float _4028;
  float _4029;
  float _4030;
  float _4031;
  float _4123;
  float _4124;
  float _4125;
  float _4126;
  float _4127;
  float _4230;
  float _4239;
  float _4248;
  float _4256;
  float _4327;
  float _4336;
  float _4345;
  float _4353;
  float _4426;
  float _4435;
  float _4444;
  float _4452;
  float _4525;
  float _4534;
  float _4543;
  float _4551;
  float _4886;
  float _4887;
  int _4888;
  float _4917;
  float _4918;
  float _4919;
  float _4920;
  float _4921;
  float _5023;
  float _5032;
  float _5041;
  float _5049;
  float _5120;
  float _5129;
  float _5138;
  float _5146;
  float _5219;
  float _5228;
  float _5237;
  float _5245;
  float _5318;
  float _5327;
  float _5336;
  float _5344;
  float _5678;
  float _5679;
  bool _5680;
  float _5695;
  float _5696;
  float _5697;
  float _5755;
  float _5756;
  float _5781;
  float _5782;
  float _5877;
  float _5880;
  float _5881;
  float _5901;
  float _5902;
  float _5903;
  int _5921;
  float _5938;
  float _5942;
  float _5969;
  float _5970;
  float _5971;
  float _6002;
  float _6031;
  float _6032;
  float _6033;
  float _6049;
  float _6050;
  float _6051;
  float _6087;
  float _6135;
  float _6136;
  float _6137;
  float _6153;
  float _6213;
  float _6214;
  float _6215;
  float _6335;
  float _6336;
  float _6350;
  float _6362;
  float _6363;
  float _6383;
  float _6570;
  float _6571;
  float _6740;
  float _6941;
  float _6942;
  float _7482;
  float _7483;
  float _7484;
  float _7574;
  float _7583;
  float _7592;
  float _7600;
  float _7671;
  float _7680;
  float _7689;
  float _7697;
  float _7770;
  float _7779;
  float _7788;
  float _7796;
  float _7869;
  float _7878;
  float _7887;
  float _7895;
  float _7947;
  float _7952;
  float _7953;
  float _8050;
  float _8051;
  float _8072;
  float _8073;
  float _8074;
  int _8093;
  float _8110;
  float _8118;
  float _8144;
  float _8145;
  float _8146;
  float _8177;
  float _8206;
  float _8207;
  float _8208;
  float _8224;
  float _8225;
  float _8226;
  float _8262;
  float _8310;
  float _8311;
  float _8312;
  float _8328;
  float _8388;
  float _8389;
  float _8390;
  float _8510;
  float _8511;
  float _8525;
  float _8537;
  float _8538;
  float _8558;
  float _8745;
  float _8746;
  float _8928;
  float _8929;
  float _8953;
  float _8954;
  float _8979;
  float _8980;
  float _9005;
  float _9006;
  float _9149;
  float _9150;
  float _9151;
  float _9175;
  float _9246;
  float _9247;
  float _9248;
  float _9262;
  float _9263;
  float _9264;
  float _9265;
  float _9266;
  float _9267;
  float _9395;
  float _9396;
  float _9397;
  float _9407;
  float _9408;
  float _9409;
  float _9410;
  float _9411;
  float _9412;
  float _9413;
  float _9414;
  float _9415;
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
  float _196;
  float _197;
  float _198;
  float _199;
  bool _210;
  float _212;
  float _213;
  float _214;
  float _217;
  float _219;
  float _230;
  float _231;
  float _232;
  float _233;
  int _239;
  uint _243;
  float _249;
  float4 _258;
  float _279;
  float _280;
  float _295;
  float _296;
  float _299;
  float _300;
  float _303;
  float _304;
  float4 _309;
  float _343;
  float _345;
  bool _346;
  float _348;
  float _350;
  bool _351;
  float4 _364;
  float _368;
  float _380;
  float _381;
  float _382;
  float _383;
  float _384;
  float _385;
  bool _388;
  bool _402;
  int _403;
  float2 _406;
  float _411;
  float _412;
  float _416;
  float _418;
  float _419;
  float _424;
  float _425;
  float _427;
  float _428;
  float _429;
  float _430;
  float _432;
  float _441;
  float _442;
  float _444;
  float _445;
  float _446;
  int _454;
  int _455;
  int _456;
  int _457;
  float _461;
  float _463;
  float _464;
  float _474;
  float _479;
  float _483;
  float _484;
  float _487;
  float _500;
  float _501;
  float _502;
  float _506;
  float _521;
  float _524;
  float _527;
  float _530;
  float _533;
  float _536;
  int _572;
  int _573;
  float _576;
  float _577;
  float _578;
  float _579;
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
  int _612;
  float _615;
  float _616;
  float _617;
  float _620;
  float _621;
  float _622;
  int _625;
  int _628;
  int _631;
  float _660;
  float _663;
  float _666;
  float _667;
  float4 _673;
  float4 _679;
  float _688;
  float _692;
  float _695;
  float _698;
  float _739;
  float _744;
  float _746;
  float _748;
  float _755;
  float _756;
  float4 _762;
  float4 _768;
  float _776;
  float4 _782;
  float4 _788;
  float _805;
  float _806;
  float _807;
  float _808;
  float _809;
  float _810;
  float _811;
  float _812;
  float _813;
  uint _861;
  bool _884;
  int _894;
  float _896;
  float _897;
  float _904;
  float _909;
  float _910;
  bool _911;
  float4 _916;
  float4 _922;
  float _933;
  float4 _938;
  float4 _944;
  float _982;
  int _1002;
  float _1003;
  float _1006;
  float _1007;
  bool _1008;
  float4 _1013;
  float4 _1019;
  float _1030;
  float4 _1035;
  float4 _1041;
  float _1069;
  float _1123;
  float _1124;
  float _1131;
  float _1132;
  float _1136;
  float _1140;
  float _1141;
  float _1142;
  float _1146;
  uint _1152;
  int _1155;
  int _1156;
  int _1160;
  int _1164;
  float _1176;
  float _1181;
  float _1182;
  float _1183;
  float _1184;
  float _1187;
  float _1188;
  float _1189;
  float _1190;
  float _1193;
  float _1194;
  float _1195;
  float _1196;
  int _1199;
  int _1202;
  int _1205;
  int _1208;
  float _1223;
  float _1227;
  float _1231;
  float _1256;
  float _1257;
  float _1258;
  float _1261;
  uint _1270;
  bool _1278;
  float _1293;
  float _1295;
  float _1296;
  float _1297;
  float _1298;
  float _1303;
  float _1304;
  float _1305;
  float _1306;
  float _1308;
  float _1317;
  float _1318;
  float _1323;
  float _1329;
  float _1337;
  float _1348;
  float _1349;
  float _1350;
  int _1360;
  int _1363;
  int _1364;
  int _1365;
  int _1371;
  int _1372;
  int _1373;
  int _1379;
  int _1380;
  int _1381;
  float _1387;
  float _1391;
  float _1395;
  float _1402;
  int _1415;
  int _1418;
  int _1419;
  int _1420;
  int _1426;
  int _1427;
  int _1428;
  int _1434;
  int _1435;
  int _1436;
  float _1442;
  float _1446;
  float _1450;
  float _1457;
  float _1490;
  float _1494;
  float _1498;
  float _1517;
  float _1521;
  float _1525;
  float _1538;
  float _1539;
  float _1540;
  uint _1578;
  int _1590;
  int _1594;
  int _1595;
  int _1596;
  int _1597;
  int _1609;
  int _1613;
  float _1625;
  int _1628;
  float _1645;
  float _1650;
  float _1651;
  float _1652;
  float _1653;
  float _1656;
  float _1657;
  float _1658;
  float _1659;
  float _1662;
  float _1663;
  float _1664;
  float _1665;
  int _1668;
  int _1671;
  int _1674;
  int _1677;
  int _1680;
  float _1682;
  float _1683;
  float _1685;
  float _1689;
  float _1702;
  float _1706;
  float _1710;
  float _1735;
  float _1736;
  float _1737;
  float _1740;
  float _1741;
  float _1748;
  float _1769;
  float _1770;
  float _1771;
  float _1772;
  float _1775;
  float _1776;
  float _1777;
  float _1778;
  float _1781;
  float _1782;
  float _1783;
  float _1784;
  float _1787;
  float _1788;
  float _1789;
  float _1792;
  int _1795;
  int _1798;
  int _1801;
  int _1804;
  int _1807;
  float _1810;
  float _1811;
  float _1812;
  float _1813;
  int _1816;
  int _1819;
  int _1822;
  int _1825;
  int _1828;
  int _1831;
  int _1834;
  int _1837;
  float _1839;
  float _1840;
  float _1842;
  float _1846;
  float _1848;
  int _1851;
  float _1861;
  float _1862;
  float _1864;
  float _1865;
  float _1866;
  float _1867;
  float _1886;
  float _1890;
  float _1891;
  float _1892;
  float _1896;
  float _1900;
  float _1904;
  float _1905;
  float _1928;
  float _1929;
  float _1930;
  float _1933;
  float _1934;
  float _1941;
  float _1942;
  float _1943;
  float _1948;
  float _1950;
  float _1951;
  float _1954;
  float _1958;
  float _1967;
  float _1968;
  float _1969;
  int _1970;
  float _1975;
  float _1984;
  float _1985;
  float _1987;
  float4 _1992;
  float _1997;
  float _1999;
  float _2001;
  float _2003;
  float _2007;
  float _2009;
  float _2013;
  float _2015;
  int _2022;
  float _2027;
  float _2036;
  float _2037;
  float4 _2043;
  float _2048;
  float _2050;
  float _2054;
  float _2056;
  float _2060;
  float _2062;
  float _2066;
  float _2068;
  int _2075;
  float _2080;
  float _2089;
  float _2090;
  float4 _2096;
  float _2101;
  float _2103;
  float _2107;
  float _2109;
  float _2113;
  float _2115;
  float _2119;
  float _2121;
  int _2128;
  float _2133;
  float _2142;
  float _2143;
  float4 _2149;
  float _2154;
  float _2156;
  float _2160;
  float _2162;
  float _2166;
  float _2168;
  float _2172;
  float _2174;
  float _2175;
  float _2186;
  float _2192;
  float _2194;
  float _2196;
  float _2203;
  float _2211;
  float _2212;
  float _2221;
  float _2225;
  float _2234;
  float _2235;
  float _2236;
  float _2241;
  int _2242;
  float _2247;
  float _2256;
  float _2257;
  float _2259;
  float _2261;
  float _2262;
  float4 _2264;
  float _2268;
  float _2269;
  float _2272;
  float _2273;
  float _2278;
  float _2279;
  float _2282;
  float _2283;
  float _2285;
  float _2287;
  bool _2288;
  bool _2289;
  bool _2299;
  bool _2308;
  float _2325;
  float _2327;
  float _2329;
  float _2331;
  float _2335;
  float _2337;
  float _2341;
  float _2343;
  int _2350;
  float _2355;
  float _2364;
  float _2365;
  float _2368;
  float _2369;
  float4 _2371;
  float _2375;
  float _2376;
  float _2379;
  float _2380;
  float _2382;
  float _2384;
  bool _2385;
  bool _2386;
  bool _2396;
  bool _2405;
  float _2422;
  float _2424;
  float _2428;
  float _2430;
  float _2434;
  float _2436;
  float _2440;
  float _2442;
  int _2449;
  float _2454;
  float _2463;
  float _2464;
  float _2467;
  float _2468;
  float4 _2470;
  float _2474;
  float _2475;
  float _2478;
  float _2479;
  float _2481;
  float _2483;
  bool _2484;
  bool _2485;
  bool _2495;
  bool _2504;
  float _2521;
  float _2523;
  float _2527;
  float _2529;
  float _2533;
  float _2535;
  float _2539;
  float _2541;
  int _2548;
  float _2553;
  float _2562;
  float _2563;
  float _2566;
  float _2567;
  float4 _2569;
  float _2573;
  float _2574;
  float _2577;
  float _2578;
  float _2580;
  float _2582;
  bool _2583;
  bool _2584;
  bool _2594;
  bool _2603;
  float _2620;
  float _2622;
  float _2626;
  float _2628;
  float _2632;
  float _2634;
  float _2638;
  float _2640;
  float _2641;
  float _2652;
  float _2658;
  float _2660;
  float _2662;
  float _2682;
  float4 _2689;
  float _2703;
  float _2704;
  float _2705;
  float _2706;
  float _2708;
  float _2713;
  float _2716;
  float _2717;
  float _2719;
  float _2720;
  float _2725;
  float _2730;
  float _2732;
  float _2735;
  float _2736;
  float _2741;
  float _2743;
  float _2745;
  float _2747;
  float _2752;
  float _2758;
  float _2760;
  float3 _2786;
  float _2797;
  float4 _2818;
  int _2846;
  int _2851;
  int _2853;
  int _2854;
  int _2856;
  int _2857;
  int _2866;
  bool _2879;
  float _2882;
  float _2884;
  float _2885;
  float _2886;
  float _2887;
  float _2888;
  float _2889;
  float _2897;
  float _2902;
  float _2908;
  float _2912;
  float _2914;
  float _2915;
  float _2918;
  float _2921;
  bool _2925;
  float _2929;
  float _2931;
  float _2932;
  float _2940;
  float _2943;
  float _2944;
  float _2949;
  float _2958;
  float _2959;
  float _2962;
  float _2964;
  float _2965;
  float _2966;
  float _2968;
  float _2969;
  float _2970;
  float _2971;
  float _2976;
  float _2990;
  float _2995;
  float _2996;
  float _2998;
  float _3004;
  float _3007;
  float _3018;
  float _3019;
  float _3020;
  float _3031;
  float _3046;
  float _3049;
  float _3057;
  float _3061;
  float _3062;
  float _3063;
  float _3066;
  float _3067;
  float _3075;
  float _3081;
  float _3083;
  float _3107;
  float _3108;
  float _3109;
  float _3110;
  bool _3113;
  float _3114;
  float _3115;
  float _3116;
  float _3118;
  float _3121;
  float _3123;
  float _3124;
  float _3125;
  float _3126;
  float _3129;
  float _3132;
  float _3135;
  float _3137;
  float _3141;
  float _3150;
  float _3151;
  float _3153;
  float _3154;
  float _3155;
  float _3162;
  float _3163;
  float _3164;
  float _3167;
  float _3170;
  float _3173;
  float _3174;
  float _3175;
  float _3178;
  float _3179;
  float _3185;
  float _3189;
  float _3190;
  float _3191;
  float _3192;
  float _3193;
  float _3194;
  float _3199;
  float _3200;
  float _3208;
  float _3209;
  float _3224;
  float _3239;
  float _3246;
  float _3247;
  float _3248;
  float _3261;
  float _3262;
  float _3263;
  float _3266;
  float _3283;
  float _3284;
  float _3285;
  float _3286;
  float _3289;
  float _3290;
  float _3291;
  float _3292;
  float _3295;
  float _3296;
  float _3297;
  int _3300;
  int _3303;
  int _3306;
  int _3309;
  int _3312;
  int _3315;
  float _3318;
  float _3321;
  int _3323;
  float2 _3343;
  float3 _3360;
  float _3373;
  float _3376;
  float _3377;
  float _3378;
  float _3379;
  float _3380;
  float _3381;
  float _3389;
  float _3394;
  float _3400;
  float _3404;
  float _3406;
  float _3407;
  float _3410;
  float _3413;
  bool _3417;
  float _3421;
  float _3423;
  float _3424;
  float _3432;
  float _3435;
  float _3436;
  float _3441;
  float _3450;
  float _3451;
  float _3454;
  float _3456;
  float _3457;
  float _3458;
  float _3460;
  float _3461;
  float _3462;
  float _3463;
  float _3468;
  float _3482;
  float _3487;
  float _3488;
  float _3490;
  float _3496;
  float _3499;
  float _3510;
  float _3511;
  float _3512;
  float _3523;
  float _3538;
  float _3541;
  float _3549;
  float _3553;
  float _3554;
  float _3555;
  float _3558;
  float _3559;
  float _3567;
  float _3573;
  float _3575;
  float _3599;
  float _3600;
  float _3601;
  float _3602;
  bool _3605;
  float _3606;
  float _3607;
  float _3608;
  float _3610;
  float _3613;
  float _3615;
  float _3616;
  float _3617;
  float _3618;
  float _3621;
  float _3624;
  float _3627;
  float _3629;
  float _3633;
  float _3642;
  float _3643;
  float _3645;
  float _3646;
  float _3647;
  float _3654;
  float _3655;
  float _3656;
  float _3659;
  float _3662;
  float _3665;
  float _3666;
  float _3667;
  float _3670;
  float _3671;
  float _3677;
  float _3681;
  float _3682;
  float _3683;
  float _3684;
  float _3685;
  float _3686;
  float _3691;
  float _3692;
  float _3700;
  float _3701;
  float _3716;
  float _3731;
  float _3756;
  bool _3769;
  float _3770;
  float _3771;
  float _3772;
  bool _3773;
  float _3775;
  float _3776;
  float _3780;
  float _3786;
  float _3800;
  float _3801;
  float _3804;
  float _3808;
  int _3809;
  float _3811;
  float _3813;
  float _3816;
  float _3820;
  float _3831;
  float _3832;
  float _3833;
  float _3835;
  float _3849;
  float _3850;
  float _3851;
  float _3867;
  float _3868;
  float _3869;
  float _3872;
  float _3890;
  float _3891;
  float _3892;
  float _3895;
  float _3896;
  float _3897;
  float _3900;
  float _3901;
  float _3902;
  float _3905;
  float _3906;
  float _3907;
  float _3910;
  float _3911;
  float _3912;
  int _3915;
  int _3918;
  int _3921;
  int _3924;
  int _3927;
  int _3930;
  int _3933;
  int _3936;
  int _3939;
  int _3942;
  int _3945;
  float _3948;
  float _3949;
  float _3950;
  float _3951;
  int _3954;
  int _3957;
  int _3960;
  int _3963;
  float _3965;
  float _3966;
  float _3968;
  float _3972;
  float _3973;
  float _3975;
  float _3979;
  float _3981;
  float _3982;
  float _3984;
  int _3987;
  bool _3991;
  float _3999;
  float _4000;
  float _4002;
  float _4005;
  float _4006;
  float _4008;
  float _4009;
  float _4011;
  float _4012;
  float _4016;
  float _4022;
  float _4023;
  float _4024;
  float _4035;
  float _4036;
  float _4037;
  float _4038;
  float _4039;
  float _4040;
  float _4041;
  float _4042;
  float _4043;
  float _4046;
  float _4047;
  float _4048;
  float _4051;
  float _4058;
  float _4071;
  float _4075;
  float _4079;
  float _4080;
  float _4081;
  float _4084;
  float _4087;
  bool _4089;
  float _4095;
  float _4096;
  float _4097;
  float _4102;
  float _4103;
  float _4104;
  bool _4108;
  bool _4114;
  bool _4118;
  float _4128;
  float _4132;
  float _4141;
  float _4142;
  float _4149;
  float _4150;
  float _4153;
  float _4157;
  float _4166;
  float _4167;
  float _4168;
  float _4173;
  int _4174;
  float _4179;
  float _4188;
  float _4189;
  float _4191;
  float _4193;
  float _4194;
  float4 _4196;
  float _4200;
  float _4201;
  float _4204;
  float _4205;
  float _4210;
  float _4211;
  float _4214;
  float _4215;
  float _4217;
  float _4219;
  bool _4220;
  bool _4221;
  bool _4231;
  bool _4240;
  float _4257;
  float _4259;
  float _4261;
  float _4263;
  float _4267;
  float _4269;
  float _4273;
  float _4275;
  int _4282;
  float _4287;
  float _4296;
  float _4297;
  float _4300;
  float _4301;
  float4 _4303;
  float _4307;
  float _4308;
  float _4311;
  float _4312;
  float _4314;
  float _4316;
  bool _4317;
  bool _4318;
  bool _4328;
  bool _4337;
  float _4354;
  float _4356;
  float _4360;
  float _4362;
  float _4366;
  float _4368;
  float _4372;
  float _4374;
  int _4381;
  float _4386;
  float _4395;
  float _4396;
  float _4399;
  float _4400;
  float4 _4402;
  float _4406;
  float _4407;
  float _4410;
  float _4411;
  float _4413;
  float _4415;
  bool _4416;
  bool _4417;
  bool _4427;
  bool _4436;
  float _4453;
  float _4455;
  float _4459;
  float _4461;
  float _4465;
  float _4467;
  float _4471;
  float _4473;
  int _4480;
  float _4485;
  float _4494;
  float _4495;
  float _4498;
  float _4499;
  float4 _4501;
  float _4505;
  float _4506;
  float _4509;
  float _4510;
  float _4512;
  float _4514;
  bool _4515;
  bool _4516;
  bool _4526;
  bool _4535;
  float _4552;
  float _4554;
  float _4558;
  float _4560;
  float _4564;
  float _4566;
  float _4570;
  float _4572;
  float _4573;
  float _4584;
  float _4590;
  float _4592;
  float _4594;
  float _4603;
  float _4606;
  float _4607;
  float _4621;
  float _4622;
  float _4623;
  float _4627;
  float _4636;
  float _4637;
  float _4638;
  int _4639;
  float _4644;
  float _4653;
  float _4654;
  float _4656;
  float4 _4661;
  float _4666;
  float _4668;
  float _4670;
  float _4672;
  float _4676;
  float _4678;
  float _4682;
  float _4684;
  int _4691;
  float _4696;
  float _4705;
  float _4706;
  float4 _4712;
  float _4717;
  float _4719;
  float _4723;
  float _4725;
  float _4729;
  float _4731;
  float _4735;
  float _4737;
  int _4744;
  float _4749;
  float _4758;
  float _4759;
  float4 _4765;
  float _4770;
  float _4772;
  float _4776;
  float _4778;
  float _4782;
  float _4784;
  float _4788;
  float _4790;
  int _4797;
  float _4802;
  float _4811;
  float _4812;
  float4 _4818;
  float _4823;
  float _4825;
  float _4829;
  float _4831;
  float _4835;
  float _4837;
  float _4841;
  float _4843;
  float _4844;
  float _4855;
  float _4861;
  float _4863;
  float _4865;
  float _4873;
  float _4880;
  float _4882;
  float _4896;
  float _4897;
  float _4898;
  bool _4902;
  bool _4908;
  bool _4912;
  float _4922;
  float _4927;
  float _4936;
  float _4937;
  float _4942;
  float _4943;
  float _4946;
  float _4950;
  float _4959;
  float _4960;
  float _4961;
  float _4966;
  int _4967;
  float _4972;
  float _4981;
  float _4982;
  float _4984;
  float _4986;
  float _4987;
  float4 _4989;
  float _4993;
  float _4994;
  float _4997;
  float _4998;
  float _5003;
  float _5004;
  float _5007;
  float _5008;
  float _5010;
  float _5012;
  bool _5013;
  bool _5014;
  bool _5024;
  bool _5033;
  float _5050;
  float _5052;
  float _5054;
  float _5056;
  float _5060;
  float _5062;
  float _5066;
  float _5068;
  int _5075;
  float _5080;
  float _5089;
  float _5090;
  float _5093;
  float _5094;
  float4 _5096;
  float _5100;
  float _5101;
  float _5104;
  float _5105;
  float _5107;
  float _5109;
  bool _5110;
  bool _5111;
  bool _5121;
  bool _5130;
  float _5147;
  float _5149;
  float _5153;
  float _5155;
  float _5159;
  float _5161;
  float _5165;
  float _5167;
  int _5174;
  float _5179;
  float _5188;
  float _5189;
  float _5192;
  float _5193;
  float4 _5195;
  float _5199;
  float _5200;
  float _5203;
  float _5204;
  float _5206;
  float _5208;
  bool _5209;
  bool _5210;
  bool _5220;
  bool _5229;
  float _5246;
  float _5248;
  float _5252;
  float _5254;
  float _5258;
  float _5260;
  float _5264;
  float _5266;
  int _5273;
  float _5278;
  float _5287;
  float _5288;
  float _5291;
  float _5292;
  float4 _5294;
  float _5298;
  float _5299;
  float _5302;
  float _5303;
  float _5305;
  float _5307;
  bool _5308;
  bool _5309;
  bool _5319;
  bool _5328;
  float _5345;
  float _5347;
  float _5351;
  float _5353;
  float _5357;
  float _5359;
  float _5363;
  float _5365;
  float _5366;
  float _5377;
  float _5383;
  float _5385;
  float _5387;
  float _5396;
  float _5399;
  float _5400;
  float _5413;
  float _5414;
  float _5415;
  float _5419;
  float _5428;
  float _5429;
  float _5430;
  int _5431;
  float _5436;
  float _5445;
  float _5446;
  float _5448;
  float4 _5453;
  float _5458;
  float _5460;
  float _5462;
  float _5464;
  float _5468;
  float _5470;
  float _5474;
  float _5476;
  int _5483;
  float _5488;
  float _5497;
  float _5498;
  float4 _5504;
  float _5509;
  float _5511;
  float _5515;
  float _5517;
  float _5521;
  float _5523;
  float _5527;
  float _5529;
  int _5536;
  float _5541;
  float _5550;
  float _5551;
  float4 _5557;
  float _5562;
  float _5564;
  float _5568;
  float _5570;
  float _5574;
  float _5576;
  float _5580;
  float _5582;
  int _5589;
  float _5594;
  float _5603;
  float _5604;
  float4 _5610;
  float _5615;
  float _5617;
  float _5621;
  float _5623;
  float _5627;
  float _5629;
  float _5633;
  float _5635;
  float _5636;
  float _5647;
  float _5653;
  float _5655;
  float _5657;
  float _5665;
  float _5672;
  float _5674;
  float _5700;
  float _5702;
  float _5703;
  float _5704;
  float _5719;
  float _5722;
  float _5725;
  float _5727;
  float _5728;
  float _5729;
  float _5730;
  float _5738;
  float _5739;
  float _5740;
  bool _5742;
  float _5762;
  float4 _5787;
  float _5807;
  float _5808;
  float _5809;
  float _5810;
  float _5812;
  float _5817;
  float _5820;
  float _5821;
  float _5823;
  float _5824;
  float _5829;
  float _5834;
  float _5836;
  float _5839;
  float _5840;
  float _5845;
  float _5847;
  float _5849;
  float _5851;
  float _5856;
  float _5862;
  float _5864;
  float3 _5893;
  float4 _5924;
  float _5959;
  bool _5972;
  float _5973;
  float _5974;
  float _5975;
  bool _5976;
  float _5978;
  float _5979;
  float _5983;
  float _5989;
  float _6003;
  float _6004;
  float _6007;
  float _6011;
  int _6012;
  float _6014;
  float _6016;
  float _6019;
  float _6023;
  float _6034;
  float _6035;
  float _6036;
  float _6038;
  int _6058;
  int _6063;
  int _6065;
  int _6066;
  int _6068;
  int _6069;
  int _6078;
  bool _6091;
  float _6094;
  float _6096;
  float _6097;
  float _6098;
  float _6099;
  float _6100;
  float _6101;
  float _6102;
  float _6103;
  float _6104;
  float _6105;
  float _6106;
  float _6107;
  bool _6108;
  float _6109;
  float _6110;
  float _6113;
  float _6114;
  float _6116;
  float _6143;
  float _6148;
  float _6155;
  float _6156;
  float _6157;
  float _6159;
  float _6163;
  float _6164;
  float _6165;
  float _6166;
  float _6167;
  float _6168;
  float _6169;
  float _6175;
  float _6184;
  float _6188;
  float _6189;
  float _6190;
  float _6191;
  float _6195;
  float _6196;
  float _6197;
  float _6205;
  float _6217;
  float _6218;
  float _6219;
  float _6220;
  float _6221;
  float _6225;
  float _6227;
  float _6229;
  float _6230;
  float _6231;
  float _6232;
  float _6233;
  float _6234;
  float _6237;
  bool _6244;
  float _6248;
  float _6250;
  float _6251;
  float _6259;
  float _6262;
  float _6263;
  float _6268;
  float _6277;
  float _6278;
  float _6281;
  float _6283;
  float _6284;
  float _6285;
  float _6287;
  float _6288;
  float _6289;
  float _6290;
  float _6295;
  float _6309;
  float _6314;
  float _6315;
  float _6317;
  float _6323;
  float _6326;
  float _6337;
  float _6338;
  float _6339;
  float _6340;
  float _6359;
  float _6370;
  float _6387;
  float _6390;
  float _6398;
  float _6402;
  float _6403;
  float _6404;
  float _6407;
  float _6408;
  float _6409;
  float _6417;
  float _6423;
  float _6425;
  float _6449;
  float _6450;
  float _6451;
  float _6452;
  bool _6455;
  float _6456;
  float _6457;
  float _6458;
  float _6460;
  float _6463;
  float _6465;
  float _6466;
  float _6467;
  float _6468;
  float _6471;
  float _6474;
  float _6477;
  float _6479;
  float _6483;
  float _6492;
  float _6493;
  float _6495;
  float _6496;
  float _6497;
  float _6504;
  float _6505;
  float _6506;
  float _6509;
  float _6512;
  float _6515;
  float _6519;
  float _6523;
  float _6524;
  float _6527;
  float _6528;
  float _6534;
  float _6538;
  float _6539;
  float _6540;
  float _6541;
  float _6542;
  float _6543;
  float _6548;
  float _6549;
  float _6557;
  float _6558;
  float _6573;
  float _6588;
  float _6595;
  float _6596;
  float _6597;
  float _6610;
  float _6611;
  float _6612;
  float _6616;
  float _6634;
  float _6635;
  float _6636;
  float _6639;
  float _6640;
  float _6641;
  float _6644;
  int _6647;
  int _6650;
  int _6653;
  float _6662;
  float _6665;
  float _6672;
  float _6677;
  float _6679;
  float _6681;
  float _6682;
  float _6683;
  float _6685;
  float _6686;
  float _6687;
  float _6690;
  float _6691;
  float _6692;
  float _6695;
  float _6702;
  int _6711;
  int _6716;
  int _6718;
  int _6719;
  int _6721;
  int _6722;
  int _6731;
  bool _6744;
  float _6747;
  float _6749;
  float _6750;
  float _6753;
  float _6756;
  float _6760;
  float _6761;
  float _6762;
  float _6766;
  float _6768;
  float _6776;
  float _6780;
  float _6781;
  float _6782;
  float _6785;
  float _6786;
  float _6787;
  float _6795;
  float _6801;
  float _6803;
  float _6827;
  float _6828;
  float _6829;
  float _6830;
  bool _6833;
  float _6834;
  float _6835;
  float _6836;
  float _6838;
  float _6841;
  float _6843;
  float _6844;
  float _6845;
  float _6846;
  float _6849;
  float _6852;
  float _6855;
  float _6857;
  float _6861;
  float _6870;
  float _6871;
  float _6873;
  float _6874;
  float _6875;
  float _6882;
  float _6883;
  float _6884;
  float _6887;
  float _6890;
  float _6893;
  float _6894;
  float _6895;
  float _6898;
  float _6899;
  float _6905;
  float _6909;
  float _6910;
  float _6911;
  float _6912;
  float _6913;
  float _6914;
  float _6919;
  float _6920;
  float _6928;
  float _6929;
  float _6944;
  float _6959;
  float _6966;
  float _6967;
  float _6968;
  float _6981;
  float _6982;
  float _6983;
  float _6987;
  float _7005;
  float _7006;
  float _7007;
  float _7010;
  float _7011;
  float _7012;
  float _7015;
  float _7016;
  float _7017;
  float _7020;
  float _7021;
  float _7022;
  float _7025;
  float _7026;
  float _7027;
  float _7030;
  float _7031;
  float _7032;
  int _7035;
  int _7038;
  int _7041;
  int _7044;
  float _7047;
  float _7048;
  float _7049;
  float _7050;
  int _7053;
  int _7056;
  int _7059;
  int _7062;
  int _7065;
  int _7068;
  int _7071;
  float _7074;
  float _7075;
  float _7076;
  float _7077;
  int _7080;
  int _7083;
  int _7086;
  float _7088;
  float _7089;
  float _7091;
  float _7095;
  float _7096;
  float _7098;
  float _7102;
  int _7106;
  float _7122;
  float _7123;
  float _7125;
  float _7126;
  float _7127;
  float _7128;
  float _7129;
  float _7130;
  float _7131;
  float _7132;
  float _7133;
  float _7134;
  float _7135;
  float _7136;
  float _7137;
  float _7140;
  float _7141;
  float _7142;
  float _7145;
  float _7156;
  float _7160;
  float _7167;
  float _7168;
  float _7169;
  float _7181;
  float _7182;
  float _7183;
  float _7184;
  float _7187;
  float _7188;
  float _7191;
  float _7192;
  float _7199;
  float _7201;
  float _7207;
  bool _7209;
  float _7217;
  float _7218;
  float _7219;
  float _7224;
  float _7226;
  float _7227;
  float _7230;
  float _7234;
  float _7243;
  float _7244;
  float _7245;
  int _7246;
  float _7251;
  float _7260;
  float _7261;
  float _7263;
  float4 _7268;
  float _7273;
  float _7275;
  float _7277;
  float _7279;
  float _7283;
  float _7285;
  float _7289;
  float _7291;
  int _7298;
  float _7303;
  float _7312;
  float _7313;
  float4 _7319;
  float _7324;
  float _7326;
  float _7330;
  float _7332;
  float _7336;
  float _7338;
  float _7342;
  float _7344;
  int _7351;
  float _7356;
  float _7365;
  float _7366;
  float4 _7372;
  float _7377;
  float _7379;
  float _7383;
  float _7385;
  float _7389;
  float _7391;
  float _7395;
  float _7397;
  int _7404;
  float _7409;
  float _7418;
  float _7419;
  float4 _7425;
  float _7430;
  float _7432;
  float _7436;
  float _7438;
  float _7442;
  float _7444;
  float _7448;
  float _7450;
  float _7451;
  float _7462;
  float _7468;
  float _7470;
  float _7472;
  float _7479;
  float _7487;
  float _7488;
  float _7497;
  float _7501;
  float _7510;
  float _7511;
  float _7512;
  float _7517;
  int _7518;
  float _7523;
  float _7532;
  float _7533;
  float _7535;
  float _7537;
  float _7538;
  float4 _7540;
  float _7544;
  float _7545;
  float _7548;
  float _7549;
  float _7554;
  float _7555;
  float _7558;
  float _7559;
  float _7561;
  float _7563;
  bool _7564;
  bool _7565;
  bool _7575;
  bool _7584;
  float _7601;
  float _7603;
  float _7605;
  float _7607;
  float _7611;
  float _7613;
  float _7617;
  float _7619;
  int _7626;
  float _7631;
  float _7640;
  float _7641;
  float _7644;
  float _7645;
  float4 _7647;
  float _7651;
  float _7652;
  float _7655;
  float _7656;
  float _7658;
  float _7660;
  bool _7661;
  bool _7662;
  bool _7672;
  bool _7681;
  float _7698;
  float _7700;
  float _7704;
  float _7706;
  float _7710;
  float _7712;
  float _7716;
  float _7718;
  int _7725;
  float _7730;
  float _7739;
  float _7740;
  float _7743;
  float _7744;
  float4 _7746;
  float _7750;
  float _7751;
  float _7754;
  float _7755;
  float _7757;
  float _7759;
  bool _7760;
  bool _7761;
  bool _7771;
  bool _7780;
  float _7797;
  float _7799;
  float _7803;
  float _7805;
  float _7809;
  float _7811;
  float _7815;
  float _7817;
  int _7824;
  float _7829;
  float _7838;
  float _7839;
  float _7842;
  float _7843;
  float4 _7845;
  float _7849;
  float _7850;
  float _7853;
  float _7854;
  float _7856;
  float _7858;
  bool _7859;
  bool _7860;
  bool _7870;
  bool _7879;
  float _7896;
  float _7898;
  float _7902;
  float _7904;
  float _7908;
  float _7910;
  float _7914;
  float _7916;
  float _7917;
  float _7928;
  float _7934;
  float _7936;
  float _7938;
  float _7959;
  float4 _7966;
  float _7980;
  float _7981;
  float _7982;
  float _7983;
  float _7985;
  float _7990;
  float _7993;
  float _7994;
  float _7996;
  float _7997;
  float _8002;
  float _8007;
  float _8009;
  float _8012;
  float _8013;
  float _8018;
  float _8020;
  float _8022;
  float _8024;
  float _8029;
  float _8035;
  float _8037;
  float3 _8064;
  float _8075;
  float4 _8096;
  float _8134;
  bool _8147;
  float _8148;
  float _8149;
  float _8150;
  bool _8151;
  float _8153;
  float _8154;
  float _8158;
  float _8164;
  float _8178;
  float _8179;
  float _8182;
  float _8186;
  int _8187;
  float _8189;
  float _8191;
  float _8194;
  float _8198;
  float _8209;
  float _8210;
  float _8211;
  float _8213;
  int _8233;
  int _8238;
  int _8240;
  int _8241;
  int _8243;
  int _8244;
  int _8253;
  bool _8266;
  float _8269;
  float _8271;
  float _8272;
  float _8273;
  float _8274;
  float _8275;
  float _8276;
  float _8277;
  float _8278;
  float _8279;
  float _8280;
  float _8281;
  float _8282;
  bool _8283;
  float _8284;
  float _8285;
  float _8288;
  float _8289;
  float _8291;
  float _8318;
  float _8323;
  float _8330;
  float _8331;
  float _8332;
  float _8334;
  float _8338;
  float _8339;
  float _8340;
  float _8341;
  float _8342;
  float _8343;
  float _8344;
  float _8350;
  float _8359;
  float _8363;
  float _8364;
  float _8365;
  float _8366;
  float _8370;
  float _8371;
  float _8372;
  float _8380;
  float _8392;
  float _8393;
  float _8394;
  float _8395;
  float _8396;
  float _8400;
  float _8402;
  float _8404;
  float _8405;
  float _8406;
  float _8407;
  float _8408;
  float _8409;
  float _8412;
  bool _8419;
  float _8423;
  float _8425;
  float _8426;
  float _8434;
  float _8437;
  float _8438;
  float _8443;
  float _8452;
  float _8453;
  float _8456;
  float _8458;
  float _8459;
  float _8460;
  float _8462;
  float _8463;
  float _8464;
  float _8465;
  float _8470;
  float _8484;
  float _8489;
  float _8490;
  float _8492;
  float _8498;
  float _8501;
  float _8512;
  float _8513;
  float _8514;
  float _8515;
  float _8534;
  float _8545;
  float _8562;
  float _8565;
  float _8573;
  float _8577;
  float _8578;
  float _8579;
  float _8582;
  float _8583;
  float _8584;
  float _8592;
  float _8598;
  float _8600;
  float _8624;
  float _8625;
  float _8626;
  float _8627;
  bool _8630;
  float _8631;
  float _8632;
  float _8633;
  float _8635;
  float _8638;
  float _8640;
  float _8641;
  float _8642;
  float _8643;
  float _8646;
  float _8649;
  float _8652;
  float _8654;
  float _8658;
  float _8667;
  float _8668;
  float _8670;
  float _8671;
  float _8672;
  float _8679;
  float _8680;
  float _8681;
  float _8684;
  float _8687;
  float _8690;
  float _8694;
  float _8698;
  float _8699;
  float _8702;
  float _8703;
  float _8709;
  float _8713;
  float _8714;
  float _8715;
  float _8716;
  float _8717;
  float _8718;
  float _8723;
  float _8724;
  float _8732;
  float _8733;
  float _8748;
  float _8763;
  float _8770;
  float _8771;
  float _8772;
  float _8785;
  float _8786;
  float _8787;
  float _8791;
  float _8809;
  float _8810;
  float _8811;
  float _8812;
  float _8815;
  float _8816;
  float _8817;
  float _8818;
  float _8821;
  float _8822;
  float _8823;
  float _8824;
  float _8827;
  float _8828;
  int _8831;
  int _8834;
  int _8837;
  int _8840;
  float _8843;
  float _8845;
  float _8846;
  float _8848;
  float _8852;
  float _8854;
  float _8858;
  float _8862;
  float _8866;
  float _8869;
  float _8872;
  float _8875;
  float _8887;
  float _8888;
  float _8889;
  float _8890;
  float _8891;
  float _8892;
  float _8893;
  float _8894;
  float _8895;
  float _8896;
  float _8897;
  float _8899;
  float _8901;
  float _8903;
  float _8905;
  float _8906;
  float _8912;
  float _8914;
  float _8921;
  float _8936;
  float _8938;
  float _8945;
  float _8955;
  float _8961;
  float _8963;
  float _8970;
  float _8987;
  float _8989;
  float _8996;
  float _9015;
  float _9016;
  float _9017;
  float _9018;
  float _9020;
  float _9022;
  float _9023;
  float _9024;
  float _9025;
  float _9026;
  float _9027;
  float _9028;
  float _9029;
  float _9031;
  float _9033;
  float _9034;
  float _9035;
  float _9036;
  float _9037;
  float _9038;
  float _9039;
  float _9041;
  float _9043;
  float _9050;
  bool _9063;
  float _9065;
  float _9071;
  float _9075;
  float _9077;
  float _9078;
  bool _9079;
  float _9081;
  float _9087;
  float _9088;
  float _9093;
  float _9094;
  float _9097;
  float _9099;
  float _9106;
  float _9119;
  float _9121;
  float _9128;
  float _9157;
  float _9158;
  float _9167;
  float _9180;
  float _9189;
  float _9196;
  float _9199;
  float4 _9207;
  float _9209;
  float4 _9210;
  float _9219;
  float _9225;
  float _9226;
  float _9254;
  uint _9268;
  float _9285;
  float _9288;
  float _9291;
  float4 _9312;
  float _9316;
  float _9317;
  float _9318;
  float _9320;
  float _9321;
  float _9322;
  float _9323;
  float _9324;
  float _9325;
  float _9326;
  float _9327;
  float _9328;
  float _9333;
  float _9338;
  float _9351;
  float4 _9359;
  float _9361;
  float _9368;
  bool _9401;
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
    bool _loop_break_0 = false;
    while (true) {
      _91 = (_89 << 6) + _52;
      do {
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
        do {
          if (!(_112 == _85)) {
            _89 = _112;
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
    do {
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
        _196 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
        _197 = _196 * _192;
        _198 = _196 * _193;
        _199 = _196 * _194;
        _210 = ((int)(uint((_171 * 1.9921875f) + 0.003921568859368563f)) != 0);
        _212 = _165 * _165;
        _213 = _166 * _166;
        _214 = _167 * _167;
        _217 = (_171 - (((float)((bool)_210)) * 0.501960813999176f)) * 2.007874011993408f;
        _219 = min(1.0f, max(saturate(_154.x), 0.019999999552965164f));
        _230 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _117.x) - cbSharedPerViewData.vViewRemap.y);
        _231 = _230 * _134;
        _232 = _230 * _135;
        _233 = -0.0f - _230;
        _239 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
        _243 = srvReflectionsWeight.Load(int3(((uint)(_63) >> _239), ((uint)(_64) >> _239), 0));
        _249 = ((float)((uint)((uint)(_243.x & 254)))) * 0.003921568859368563f;
        do {
          _267 = 1.0f;
          _268 = 0.0f;
          _269 = 0.0f;
          _270 = 0.0f;
          if ((_243.x & 1) == 0) {
            _258 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _125), (cbSharedPerViewData.vViewportSize.y * _126)), 0.0f);
            _267 = (1.0f - _249);
            _268 = (_258.x * _249);
            _269 = (_258.y * _249);
            _270 = (_258.z * _249);
          }
          _279 = cbSharedPerViewData.vViewportSize.x * (_125 + 0.5f);
          _280 = cbSharedPerViewData.vViewportSize.y * (_126 + 0.5f);
          do {
            _360 = _279;
            _361 = _280;
            if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
              _295 = (floor((_279 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
              _296 = (floor((_280 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
              _299 = max(_295, cbDeferredShading.vScreenPixelSize.z);
              _300 = max(_296, cbDeferredShading.vScreenPixelSize.w);
              _303 = min((_295 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
              _304 = min((_296 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
              _309 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_299 + cbDeferredShading.vScreenPixelSize.z), (_300 + cbDeferredShading.vScreenPixelSize.w)));
              if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _309.x) - cbSharedPerViewData.vViewRemap.y)) - _230) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _309.y) - cbSharedPerViewData.vViewRemap.y)) - _230) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _309.z) - cbSharedPerViewData.vViewRemap.y)) - _230) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _309.w) - cbSharedPerViewData.vViewRemap.y)) - _230) > 0.029999999329447746f)) {
                _343 = abs(_117.x - _309.w);
                _345 = abs(_117.x - _309.z);
                _346 = (_345 < _343);
                _348 = select(_346, _345, _343);
                _350 = abs(_117.x - _309.x);
                _351 = (_350 < _348);
                if (abs(_117.x - _309.y) < select(_351, _350, _348)) {
                  _360 = _303;
                  _361 = _304;
                } else {
                  _360 = select(_351, _299, select(_346, _303, _299));
                  _361 = select(_351, _304, _300);
                }
              } else {
                _360 = _279;
                _361 = _280;
              }
            }
            _364 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_360, _361), 0.0f);
            _368 = _364.x - _364.z;
            _380 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_364.y + _368)), 0.0f);
            _381 = -0.0f - _380;
            _382 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_364.x + _364.z)), 0.0f);
            _383 = -0.0f - _382;
            _384 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_368 - _364.y)), 0.0f);
            _385 = -0.0f - _384;
            _388 = (cbSharedPerViewData.nSSGIEnabled == 0);
            do {
              _399 = 1.0f;
              if (!(_388)) {
                if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
                  _399 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_360, _361), 0.0f)).x);
                } else {
                  _399 = 1.0f;
                }
              }
              do {
                _437 = 0;
                _438 = 0.0f;
                _439 = 0.0f;
                _440 = 0.0f;
                if (!(_388)) {
                  _402 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
                  _403 = (int)(uint)(_402);
                  if (_402) {
                    _406 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_360, _361), 0.0f);
                    _411 = (_406.x * 2.0f) + -1.0f;
                    _412 = (_406.y * 2.0f) + -1.0f;
                    _416 = (1.0f - abs(_411)) - abs(_412);
                    _418 = saturate(-0.0f - _416);
                    _419 = -0.0f - _418;
                    _424 = select((_411 >= 0.0f), _419, _418) + _411;
                    _425 = select((_412 >= 0.0f), _419, _418) + _412;
                    _427 = rsqrt(dot(float3(_424, _425, _416), float3(_424, _425, _416)));
                    _428 = _424 * _427;
                    _429 = _425 * _427;
                    _430 = _427 * _416;
                    _432 = rsqrt(dot(float3(_428, _429, _430), float3(_428, _429, _430)));
                    _437 = _403;
                    _438 = (_428 * _432);
                    _439 = (_429 * _432);
                    _440 = (_432 * _430);
                  } else {
                    _437 = _403;
                    _438 = 0.0f;
                    _439 = 0.0f;
                    _440 = 0.0f;
                  }
                }
                _441 = -0.0f - _134;
                _442 = -0.0f - _135;
                _444 = rsqrt(dot(float3(_441, _442, 1.0f), float3(_441, _442, 1.0f)));
                _445 = _444 * _441;
                _446 = _444 * _442;
                _454 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _64) + _63))];
                _455 = _454 & 255;
                _456 = (uint)(_454) >> 8;
                _457 = _456 & 255;
                _461 = ((float)((uint)((uint)(((uint)(_454) >> 16) & 255)))) * 0.003921568859368563f;
                _463 = (float)((uint)((uint)((uint)(_454) >> 24)));
                _464 = _463 * 0.003921568859368563f;
                do {
                  _1083 = 0.0f;
                  _1084 = 0.0f;
                  _1085 = 0.0f;
                  _1086 = 0.0f;
                  _1087 = 0.0f;
                  _1088 = 0.0f;
                  [branch]
                  if (!((((int)(uint((saturate(_142.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
                    _474 = _219 * 4.0f;
                    _479 = dot(float3((-0.0f - _445), (-0.0f - _446), (-0.0f - _444)), float3(_197, _198, _199)) * 2.0f;
                    _483 = _219 * _219;
                    _484 = 1.0f - _483;
                    _487 = (sqrt(_484) + _483) * _484;
                    _500 = (_487 * (((-0.0f - _197) - _445) - (_479 * _197))) + _197;
                    _501 = (_487 * (((-0.0f - _198) - _446) - (_479 * _198))) + _198;
                    _502 = (_487 * (((-0.0f - _199) - _444) - (_479 * _199))) + _199;
                    _506 = saturate(1.0f - ((_219 + -0.30000001192092896f) * 3.3333332538604736f));
                    _521 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _502, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _501, (_500 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
                    _524 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _502, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _501, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _500)));
                    _527 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _502, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _501, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _500)));
                    _530 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _199, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _198, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _197)));
                    _533 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _199, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _198, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _197)));
                    _536 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _199, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _198, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _197)));
                    do {
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
                      _878 = 0.0f;
                      if (!(_global_0 == 0)) {
                        _555 = 0;
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
                        _569 = 0.0f;
                        bool _loop_break_1 = false;
                        while (true) {
                          _572 = _global_5[min((uint)(_555), 63u)];
                          _573 = _global_6[min((uint)(_555), 63u)];
                          _576 = asfloat(srvLightInfoProperties.Load4(_573)).x;
                          _577 = asfloat(srvLightInfoProperties.Load4(_573)).y;
                          _578 = asfloat(srvLightInfoProperties.Load4(_573)).z;
                          _579 = asfloat(srvLightInfoProperties.Load4(_573)).w;
                          _582 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 16u)))).x;
                          _583 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 16u)))).y;
                          _584 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 16u)))).z;
                          _585 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 16u)))).w;
                          _588 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 32u)))).x;
                          _589 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 32u)))).y;
                          _590 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 32u)))).z;
                          _591 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 32u)))).w;
                          _594 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 48u)))).x;
                          _595 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 48u)))).y;
                          _596 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 48u)))).z;
                          _597 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 48u)))).w;
                          _600 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 64u)))).x;
                          _601 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 64u)))).y;
                          _602 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 64u)))).z;
                          _603 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 64u)))).w;
                          _606 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 80u)))).x;
                          _607 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 80u)))).y;
                          _608 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 80u)))).z;
                          _609 = asfloat(srvLightInfoProperties.Load4(((int)(_573 + 80u)))).w;
                          _612 = asint(srvLightInfoProperties.Load(((int)(_573 + 96u))));
                          _615 = asfloat(srvLightInfoProperties.Load3(((int)(_573 + 100u)))).x;
                          _616 = asfloat(srvLightInfoProperties.Load3(((int)(_573 + 100u)))).y;
                          _617 = asfloat(srvLightInfoProperties.Load3(((int)(_573 + 100u)))).z;
                          _620 = asfloat(srvLightInfoProperties.Load3(((int)(_573 + 112u)))).x;
                          _621 = asfloat(srvLightInfoProperties.Load3(((int)(_573 + 112u)))).y;
                          _622 = asfloat(srvLightInfoProperties.Load3(((int)(_573 + 112u)))).z;
                          _625 = asint(srvLightInfoProperties.Load(((int)(_573 + 124u))));
                          _628 = asint(srvLightInfoProperties.Load(((int)(_573 + 128u))));
                          _631 = _612 & 65535;
                          _660 = ((saturate(1.0f - abs(mad(_578, _233, mad(_577, _232, (_576 * _231))) + _579)) * f16tof32(((uint)((uint)(_612) >> 16)))) * saturate(1.0f - abs(mad(_584, _233, mad(_583, _232, (_582 * _231))) + _585))) * saturate(1.0f - abs(mad(_590, _233, mad(_589, _232, (_588 * _231))) + _591));
                          do {
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
                            _860 = _569;
                            [branch]
                            if (_660 > 0.0f) {
                              _663 = _660 * _660;
                              do {
                                _684 = 0.0f;
                                _685 = 0.0f;
                                _686 = 0.0f;
                                [branch]
                                if (_506 < 1.0f) {
                                  _666 = (float)((uint)_631);
                                  _667 = -0.0f - _521;
                                  [branch]
                                  if (!(!(_666 >= 341.0f))) {
                                    _673 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_667, _524, _527, (_666 + -341.0f)), _474);
                                    _684 = _673.x;
                                    _685 = _673.y;
                                    _686 = _673.z;
                                  } else {
                                    _679 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_667, _524, _527, _666), _474);
                                    _684 = _679.x;
                                    _685 = _679.y;
                                    _686 = _679.z;
                                  }
                                }
                                _688 = (float)((uint)_631);
                                do {
                                  _773 = 0.0f;
                                  _774 = 0.0f;
                                  _775 = 0.0f;
                                  [branch]
                                  if (_506 > 0.0f) {
                                    _692 = mad(_596, _502, mad(_595, _501, (_594 * _500)));
                                    _695 = mad(_602, _502, mad(_601, _501, (_600 * _500)));
                                    _698 = mad(_608, _502, mad(_607, _501, (_606 * _500)));
                                    _739 = min(((((float((int)(((int)(uint)((int)(_692 > 0.0f))) - ((int)(uint)((int)(_692 < 0.0f))))) * _615) - _597) - mad(_596, _233, mad(_595, _232, (_594 * _231)))) / _692), min(((((float((int)(((int)(uint)((int)(_695 > 0.0f))) - ((int)(uint)((int)(_695 < 0.0f))))) * _616) - _603) - mad(_602, _233, mad(_601, _232, (_600 * _231)))) / _695), ((((float((int)(((int)(uint)((int)(_698 > 0.0f))) - ((int)(uint)((int)(_698 < 0.0f))))) * _617) - _609) - mad(_608, _233, mad(_607, _232, (_606 * _231)))) / _698)));
                                    _744 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _233, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _232, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _231))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _620) + (_739 * _521);
                                    _746 = ((mad((cbSharedPerViewData.mViewToWorld[0][1].z), _233, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _232, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _231))) + (cbSharedPerViewData.mViewToWorld[0][1].w)) - _621) + (_739 * _524);
                                    _748 = ((mad((cbSharedPerViewData.mViewToWorld[0][2].z), _233, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _232, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _231))) + (cbSharedPerViewData.mViewToWorld[0][2].w)) - _622) + (_739 * _527);
                                    _755 = (max(log2((_739 * _739) / dot(float3(_744, _746, _748), float3(_744, _746, _748))), -1.0f) * 0.3333333432674408f) + _474;
                                    _756 = -0.0f - _744;
                                    [branch]
                                    if (!(!(_688 >= 341.0f))) {
                                      _762 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_756, _746, _748, (_688 + -341.0f)), _755);
                                      _773 = _762.x;
                                      _774 = _762.y;
                                      _775 = _762.z;
                                    } else {
                                      _768 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_756, _746, _748, _688), _755);
                                      _773 = _768.x;
                                      _774 = _768.y;
                                      _775 = _768.z;
                                    }
                                  }
                                  _776 = -0.0f - _530;
                                  do {
                                    [branch]
                                    if (!(!(_688 >= 341.0f))) {
                                      _782 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_776, _533, _536, (_688 + -341.0f)), 0.0f);
                                      _793 = _782.x;
                                      _794 = _782.y;
                                      _795 = _782.z;
                                    } else {
                                      _788 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_776, _533, _536, _688), 0.0f);
                                      _793 = _788.x;
                                      _794 = _788.y;
                                      _795 = _788.z;
                                    }
                                    _805 = _663 * f16tof32(((uint)((uint)(_625) >> 16)));
                                    _806 = _805 * _793;
                                    _807 = _663 * f16tof32(_625);
                                    _808 = _807 * _794;
                                    _809 = _663 * f16tof32(((uint)((uint)(_628) >> 16)));
                                    _810 = _809 * _795;
                                    _811 = _805 * (lerp(_684, _773, _506));
                                    _812 = _807 * (lerp(_685, _774, _506));
                                    _813 = _809 * (lerp(_686, _775, _506));
                                    do {
                                      _827 = _556;
                                      _828 = _557;
                                      _829 = _558;
                                      _830 = _559;
                                      _831 = _560;
                                      _832 = _561;
                                      _833 = _562;
                                      [branch]
                                      if (!((_572 & ((int)(1 << (_454 & 31)))) == 0)) {
                                        _827 = (_806 + _556);
                                        _828 = (_808 + _557);
                                        _829 = (_810 + _558);
                                        _830 = (_811 + _559);
                                        _831 = (_812 + _560);
                                        _832 = (_813 + _561);
                                        _833 = (_663 + _562);
                                      }
                                      [branch]
                                      if (!((_572 & ((int)(1 << (_456 & 31)))) == 0)) {
                                        _847 = _827;
                                        _848 = _828;
                                        _849 = _829;
                                        _850 = _830;
                                        _851 = _831;
                                        _852 = _832;
                                        _853 = _833;
                                        _854 = (_806 + _563);
                                        _855 = (_808 + _564);
                                        _856 = (_810 + _565);
                                        _857 = (_811 + _566);
                                        _858 = (_812 + _567);
                                        _859 = (_813 + _568);
                                        _860 = (_663 + _569);
                                      } else {
                                        _847 = _827;
                                        _848 = _828;
                                        _849 = _829;
                                        _850 = _830;
                                        _851 = _831;
                                        _852 = _832;
                                        _853 = _833;
                                        _854 = _563;
                                        _855 = _564;
                                        _856 = _565;
                                        _857 = _566;
                                        _858 = _567;
                                        _859 = _568;
                                        _860 = _569;
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
                            _861 = _555 + 1u;
                            do {
                              if (!(_861 == _global_0)) {
                                _555 = _861;
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
                                _569 = _860;
                                _loop_break_1 = true;
                                break;
                              }
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
                              _878 = _860;
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
                      _884 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_454 & 31)))) != 0);
                      do {
                        _990 = 0.0f;
                        _991 = 0.0f;
                        _992 = 0.0f;
                        _993 = 0.0f;
                        _994 = 0.0f;
                        _995 = 0.0f;
                        if ((_461 > 0.0f) || ((_464 > 0.0f) || _884)) {
                          _894 = srvFallbackInfo[((_455 << 2) | 3)].x;
                          _896 = select(_884, 9.999999747378752e-05f, (_463 * 3.921568847431445e-09f));
                          _897 = _871 * 0.20000000298023224f;
                          _904 = saturate((_896 - _897) / (((_871 * 0.4000000059604645f) + 9.99999993922529e-09f) - _897)) * _896;
                          do {
                            _970 = _871;
                            _971 = _868;
                            _972 = _869;
                            _973 = _870;
                            _974 = _865;
                            _975 = _866;
                            _976 = _867;
                            [branch]
                            if (_904 > 0.0f) {
                              do {
                                _962 = _868;
                                _963 = _869;
                                _964 = _870;
                                _965 = _865;
                                _966 = _866;
                                _967 = _867;
                                [branch]
                                if ((int)_894 > (int)-1) {
                                  _909 = float((int)(_894));
                                  _910 = -0.0f - _521;
                                  _911 = !(_909 >= 341.0f);
                                  do {
                                    [branch]
                                    if (!(_911)) {
                                      _916 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_910, _524, _527, (_909 + -341.0f)), _474);
                                      _927 = _916.x;
                                      _928 = _916.y;
                                      _929 = _916.z;
                                    } else {
                                      _922 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_910, _524, _527, _909), _474);
                                      _927 = _922.x;
                                      _928 = _922.y;
                                      _929 = _922.z;
                                    }
                                    _933 = -0.0f - _530;
                                    do {
                                      [branch]
                                      if (!(_911)) {
                                        _938 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_933, _533, _536, (_909 + -341.0f)), 0.0f);
                                        _949 = _938.x;
                                        _950 = _938.y;
                                        _951 = _938.z;
                                      } else {
                                        _944 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_933, _533, _536, _909), 0.0f);
                                        _949 = _944.x;
                                        _950 = _944.y;
                                        _951 = _944.z;
                                      }
                                      _962 = ((_927 * _904) + _868);
                                      _963 = ((_928 * _904) + _869);
                                      _964 = ((_929 * _904) + _870);
                                      _965 = ((_949 * _904) + _865);
                                      _966 = ((_950 * _904) + _866);
                                      _967 = ((_951 * _904) + _867);
                                    } while (false);
                                  } while (false);
                                }
                                _970 = (_904 + _871);
                                _971 = _962;
                                _972 = _963;
                                _973 = _964;
                                _974 = _965;
                                _975 = _966;
                                _976 = _967;
                              } while (false);
                            }
                            if (_970 > 0.0f) {
                              _982 = (cbSharedPerViewData.vHDRScale.x * _461) / _970;
                              _990 = (_982 * _974);
                              _991 = (_982 * _975);
                              _992 = (_982 * _976);
                              _993 = (_982 * _971);
                              _994 = (_982 * _972);
                              _995 = (_982 * _973);
                            } else {
                              _990 = 0.0f;
                              _991 = 0.0f;
                              _992 = 0.0f;
                              _993 = 0.0f;
                              _994 = 0.0f;
                              _995 = 0.0f;
                            }
                          } while (false);
                        }
                        [branch]
                        if (!(_464 == 0.0f)) {
                          _1002 = srvFallbackInfo[((_457 << 2) | 3)].x;
                          _1003 = _463 * 3.921568847431445e-09f;
                          do {
                            _1059 = _875;
                            _1060 = _876;
                            _1061 = _877;
                            _1062 = _872;
                            _1063 = _873;
                            _1064 = _874;
                            [branch]
                            if ((int)_1002 > (int)-1) {
                              _1006 = float((int)(_1002));
                              _1007 = -0.0f - _521;
                              _1008 = !(_1006 >= 341.0f);
                              do {
                                [branch]
                                if (!(_1008)) {
                                  _1013 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1007, _524, _527, (_1006 + -341.0f)), _474);
                                  _1024 = _1013.x;
                                  _1025 = _1013.y;
                                  _1026 = _1013.z;
                                } else {
                                  _1019 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1007, _524, _527, _1006), _474);
                                  _1024 = _1019.x;
                                  _1025 = _1019.y;
                                  _1026 = _1019.z;
                                }
                                _1030 = -0.0f - _530;
                                do {
                                  [branch]
                                  if (!(_1008)) {
                                    _1035 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1030, _533, _536, (_1006 + -341.0f)), 0.0f);
                                    _1046 = _1035.x;
                                    _1047 = _1035.y;
                                    _1048 = _1035.z;
                                  } else {
                                    _1041 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1030, _533, _536, _1006), 0.0f);
                                    _1046 = _1041.x;
                                    _1047 = _1041.y;
                                    _1048 = _1041.z;
                                  }
                                  _1059 = ((_1024 * _1003) + _875);
                                  _1060 = ((_1025 * _1003) + _876);
                                  _1061 = ((_1026 * _1003) + _877);
                                  _1062 = ((_1046 * _1003) + _872);
                                  _1063 = ((_1047 * _1003) + _873);
                                  _1064 = ((_1048 * _1003) + _874);
                                } while (false);
                              } while (false);
                            }
                            _1069 = (cbSharedPerViewData.vHDRScale.x * _464) / (_878 + _1003);
                            _1083 = ((_1069 * _1062) + _990);
                            _1084 = ((_1069 * _1063) + _991);
                            _1085 = ((_1069 * _1064) + _992);
                            _1086 = ((_1069 * _1059) + _993);
                            _1087 = ((_1069 * _1060) + _994);
                            _1088 = ((_1069 * _1061) + _995);
                          } while (false);
                        } else {
                          _1083 = _990;
                          _1084 = _991;
                          _1085 = _992;
                          _1086 = _993;
                          _1087 = _994;
                          _1088 = _995;
                        }
                      } while (false);
                    } while (false);
                  }
                  do {
                    _1107 = _1086;
                    _1108 = _1087;
                    _1109 = _1088;
                    [branch]
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
                      _1107 = (min((_381 / max(9.999999747378752e-05f, _1083)), 1.0f) * _1086);
                      _1108 = (min((_383 / max(9.999999747378752e-05f, _1084)), 1.0f) * _1087);
                      _1109 = (min((_385 / max(9.999999747378752e-05f, _1085)), 1.0f) * _1088);
                    }
                    _1123 = 1.0f - _219;
                    _1124 = _1123 * _1123;
                    _1131 = dot(float3(_197, _198, _199), float3(_445, _446, _444));
                    _1132 = saturate(_1131);
                    _1136 = exp2(log2(1.0f - _1132) * 5.0f);
                    _1140 = (_1136 * (max(_1124, _212) - _212)) + _212;
                    _1141 = (_1136 * (max(_1124, _213) - _213)) + _213;
                    _1142 = (_1136 * (max(_1124, _214) - _214)) + _214;
                    _1146 = min(select((cbSharedPerViewData.nPathTracingIsEnabled != 0), 1.0f, (_170 * _170)), _399);
                    do {
                      _1274 = _1146;
                      if (!(_global_1 == 0)) {
                        _1150 = 0;
                        _1151 = _1146;
                        bool _loop_break_2 = false;
                        while (true) {
                          _1152 = _1150 + (uint)(_global_0);
                          _1155 = _global_5[min((uint)(_1152), 63u)];
                          _1156 = _global_6[min((uint)(_1152), 63u)];
                          _1160 = (int)((int)(_1155 << (((int)(31u - _454)) & 31))) >> 31;
                          _1164 = (int)((int)(_1155 << ((31 - _456) & 31))) >> 31;
                          _1176 = saturate((asfloat((_1160 & asint(_461))) + asfloat((_1164 & asint(_464)))) + asfloat(((_1164 & 1065353216) & _1160)));
                          do {
                            _1269 = _1151;
                            [branch]
                            if (!(_1176 == 0.0f)) {
                              _1181 = asfloat(srvLightInfoProperties.Load4(_1156)).x;
                              _1182 = asfloat(srvLightInfoProperties.Load4(_1156)).y;
                              _1183 = asfloat(srvLightInfoProperties.Load4(_1156)).z;
                              _1184 = asfloat(srvLightInfoProperties.Load4(_1156)).w;
                              _1187 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 16u)))).x;
                              _1188 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 16u)))).y;
                              _1189 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 16u)))).z;
                              _1190 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 16u)))).w;
                              _1193 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 32u)))).x;
                              _1194 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 32u)))).y;
                              _1195 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 32u)))).z;
                              _1196 = asfloat(srvLightInfoProperties.Load4(((int)(_1156 + 32u)))).w;
                              _1199 = asint(srvLightInfoProperties.Load(((int)(_1156 + 48u))));
                              _1202 = asint(srvLightInfoProperties.Load(((int)(_1156 + 52u))));
                              _1205 = asint(srvLightInfoProperties.Load(((int)(_1156 + 56u))));
                              _1208 = asint(srvLightInfoProperties.Load(((int)(_1156 + 60u))));
                              _1223 = mad(_1183, _233, mad(_1182, _232, (_1181 * _231))) + _1184;
                              _1227 = mad(_1189, _233, mad(_1188, _232, (_1187 * _231))) + _1190;
                              _1231 = mad(_1195, _233, mad(_1194, _232, (_1193 * _231))) + _1196;
                              _1256 = saturate(1.0f - ((_1223 + 1.0f) * f16tof32(_1202))) + saturate(1.0f - ((1.0f - _1223) * f16tof32(((uint)((uint)(_1202) >> 16)))));
                              _1257 = saturate(1.0f - ((_1227 + 1.0f) * f16tof32(_1205))) + saturate(1.0f - ((1.0f - _1227) * f16tof32(((uint)((uint)(_1205) >> 16)))));
                              _1258 = saturate(1.0f - ((_1231 + 1.0f) * f16tof32(_1208))) + saturate(1.0f - ((1.0f - _1231) * f16tof32(((uint)((uint)(_1208) >> 16)))));
                              _1261 = saturate(1.0f - dot(float3(_1256, _1257, _1258), float3(_1256, _1257, _1258)));
                              _1269 = (saturate(1.0f - ((_1261 * _1261) * (f16tof32(((uint)((uint)(_1199) >> 16))) * _1176))) * _1151);
                            }
                            _1270 = _1150 + 1u;
                            do {
                              if (!(_1270 == _global_1)) {
                                _1150 = _1270;
                                _1151 = _1269;
                                _loop_break_2 = true;
                                break;
                              }
                              _1274 = _1269;
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
                      _1278 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
                      do {
                        _1290 = _1274;
                        if (_1278) {
                          _1290 = saturate((_1274 + -1.0f) + exp2((_219 * _219) * log2(max((_1274 + saturate(dot(float3(_445, _446, _444), float3(_197, _198, _199)))), 0.0f))));
                        }
                        do {
                          _1347 = _1290;
                          if (!(_437 == 0)) {
                            _1293 = rsqrt(dot(float3(_438, _439, _440), float3(_438, _439, _440)));
                            _1295 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                            _1296 = _1295 * _197;
                            _1297 = _1295 * _198;
                            _1298 = _1295 * _199;
                            if (_1278) {
                              _1303 = max(_219, 0.10000000149011612f);
                              _1304 = -0.0f - _445;
                              _1305 = -0.0f - _446;
                              _1306 = -0.0f - _444;
                              _1308 = dot(float3(_1304, _1305, _1306), float3(_1296, _1297, _1298)) * 2.0f;
                              _1317 = min(max(dot(float3((_1293 * _438), (_1293 * _439), (_1293 * _440)), float3((_1304 - (_1308 * _1296)), (_1305 - (_1308 * _1297)), (_1306 - (_1308 * _1298)))), -1.0f), 1.0f);
                              _1318 = abs(_1317);
                              _1323 = (1.5707963705062866f - (_1318 * 0.1565829962491989f)) * sqrt(1.0f - _1318);
                              _1329 = abs((_1303 - _1274) * 3.1415927410125732f);
                              _1337 = saturate(1.0f - saturate((select((_1317 >= 0.0f), _1323, (3.1415927410125732f - _1323)) - _1329) / (((_1303 + _1274) * 3.1415927410125732f) - _1329)));
                              _1347 = (((_1337 * _1337) * saturate((_1274 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1337 * 2.0f)));
                            } else {
                              _1347 = _1274;
                            }
                          }
                          _1348 = (_1140 * ((cbSharedPerViewData.vHDRScale.x * _268) + (_1107 * _267))) * _1347;
                          _1349 = (_1141 * ((cbSharedPerViewData.vHDRScale.x * _269) + (_1108 * _267))) * _1347;
                          _1350 = (_1142 * ((cbSharedPerViewData.vHDRScale.x * _270) + (_1109 * _267))) * _1347;
                          do {
                            _1357 = 1.0f;
                            [branch]
                            if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
                              _1357 = _1274;
                            }
                            do {
                              _1410 = _381;
                              _1411 = _383;
                              _1412 = _385;
                              if (_461 > 0.0f) {
                                _1360 = _455 * 3;
                                _1363 = srvRoomInfo[_1360].x;
                                _1364 = srvRoomInfo[_1360].y;
                                _1365 = srvRoomInfo[_1360].z;
                                _1371 = srvRoomInfo[(_1360 + 1)].x;
                                _1372 = srvRoomInfo[(_1360 + 1)].y;
                                _1373 = srvRoomInfo[(_1360 + 1)].z;
                                _1379 = srvRoomInfo[(_1360 + 2)].x;
                                _1380 = srvRoomInfo[(_1360 + 2)].y;
                                _1381 = srvRoomInfo[(_1360 + 2)].z;
                                _1387 = saturate(dot(float3(_197, _198, _199), float3(asfloat(_1363), asfloat(_1364), asfloat(_1365))) + 0.5f);
                                _1391 = (_1387 * _1387) * (3.0f - (_1387 * 2.0f));
                                _1395 = 1.0f - _1391;
                                _1402 = _1357 * _461;
                                _1410 = ((_1402 * ((_1395 * asfloat(_1379)) + (_1391 * asfloat(_1371)))) - _380);
                                _1411 = ((_1402 * ((_1395 * asfloat(_1380)) + (_1391 * asfloat(_1372)))) - _382);
                                _1412 = ((_1402 * ((_1395 * asfloat(_1381)) + (_1391 * asfloat(_1373)))) - _384);
                              }
                              do {
                                _1465 = _1410;
                                _1466 = _1411;
                                _1467 = _1412;
                                if (_464 > 0.0f) {
                                  _1415 = _457 * 3;
                                  _1418 = srvRoomInfo[_1415].x;
                                  _1419 = srvRoomInfo[_1415].y;
                                  _1420 = srvRoomInfo[_1415].z;
                                  _1426 = srvRoomInfo[(_1415 + 1)].x;
                                  _1427 = srvRoomInfo[(_1415 + 1)].y;
                                  _1428 = srvRoomInfo[(_1415 + 1)].z;
                                  _1434 = srvRoomInfo[(_1415 + 2)].x;
                                  _1435 = srvRoomInfo[(_1415 + 2)].y;
                                  _1436 = srvRoomInfo[(_1415 + 2)].z;
                                  _1442 = saturate(dot(float3(_197, _198, _199), float3(asfloat(_1418), asfloat(_1419), asfloat(_1420))) + 0.5f);
                                  _1446 = (_1442 * _1442) * (3.0f - (_1442 * 2.0f));
                                  _1450 = 1.0f - _1446;
                                  _1457 = _1357 * _464;
                                  _1465 = ((_1457 * ((_1450 * asfloat(_1434)) + (_1446 * asfloat(_1426)))) + _1410);
                                  _1466 = ((_1457 * ((_1450 * asfloat(_1435)) + (_1446 * asfloat(_1427)))) + _1411);
                                  _1467 = ((_1457 * ((_1450 * asfloat(_1436)) + (_1446 * asfloat(_1428)))) + _1412);
                                }
                                do {
                                  _1577 = 0.0f;
                                  if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
                                    _1490 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _233, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _232, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _231))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
                                    _1494 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _233, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _232, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _231))) + (cbSharedPerViewData.mViewToWorld[0][1].w);
                                    _1498 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _233, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _232, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _231))) + (cbSharedPerViewData.mViewToWorld[0][2].w);
                                    _1517 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1498, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1494, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1490))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
                                    _1521 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1498, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1494, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1490))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
                                    _1525 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1498, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1494, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1490))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
                                    _1538 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
                                    _1539 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
                                    _1540 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
                                    _1577 = min(min(saturate((_1517 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1538), 9.999999747378752e-06f)), saturate((1.0f - _1517) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1538), 9.999999747378752e-06f))), min(min(saturate((_1521 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1539), 9.999999747378752e-06f)), saturate((1.0f - _1521) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1539), 9.999999747378752e-06f))), min(saturate((_1525 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1540), 9.999999747378752e-06f)), saturate((1.0f - _1525) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1540), 9.999999747378752e-06f)))));
                                  }
                                  _1578 = (uint)(_global_1) + (uint)(_global_0);
                                  if ((uint)_1578 < (uint)_global_2) {
                                    _1582 = _1465;
                                    _1583 = _1466;
                                    _1584 = _1467;
                                    _1585 = _1348;
                                    _1586 = _1349;
                                    _1587 = _1350;
                                    _1588 = _1578;
                                    bool _loop_break_3 = false;
                                    while (true) {
                                      _1590 = _global_3[min((uint)(_1588), 63u)];
                                      _1594 = _global_4[min((uint)(_1588), 63u)];
                                      _1595 = _global_5[min((uint)(_1588), 63u)];
                                      _1596 = _global_6[min((uint)(_1588), 63u)];
                                      _1597 = _1590 & 4095;
                                      do {
                                        _9262 = _1582;
                                        _9263 = _1583;
                                        _9264 = _1584;
                                        _9265 = _1585;
                                        _9266 = _1586;
                                        _9267 = _1587;
                                        [branch]
                                        if (((((int)(uint(saturate(_154.w) * 255.0f)) & 64) != 0) || ((_1594 & 8388608) == 0)) && (_210 || ((_1594 & 16777216) == 0))) {
                                          _1609 = (int)((int)(_1595 << (((int)(31u - _454)) & 31))) >> 31;
                                          _1613 = (int)((int)(_1595 << ((31 - _456) & 31))) >> 31;
                                          _1625 = saturate((asfloat((_1609 & asint(_461))) + asfloat((_1613 & asint(_464)))) + asfloat(((_1613 & 1065353216) & _1609)));
                                          [branch]
                                          if (!(_1625 == 0.0f)) {
                                            _1628 = (uint)(_1590) >> 12;
                                            if (_1628 == 6) {
                                              do {
                                                _3280 = _1625;
                                                if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                                                  _3280 = (_1625 * select(((_1594 & 67108864) != 0), 1.0f, (1.0f - _1577)));
                                                }
                                                _3283 = asfloat(srvLightInfoProperties.Load4(_1596)).x;
                                                _3284 = asfloat(srvLightInfoProperties.Load4(_1596)).y;
                                                _3285 = asfloat(srvLightInfoProperties.Load4(_1596)).z;
                                                _3286 = asfloat(srvLightInfoProperties.Load4(_1596)).w;
                                                _3289 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).x;
                                                _3290 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).y;
                                                _3291 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).z;
                                                _3292 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).w;
                                                _3295 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).x;
                                                _3296 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).y;
                                                _3297 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).z;
                                                _3300 = asint(srvLightInfoProperties.Load(((int)(_1596 + 68u))));
                                                _3303 = asint(srvLightInfoProperties.Load(((int)(_1596 + 72u))));
                                                _3306 = asint(srvLightInfoProperties.Load(((int)(_1596 + 76u))));
                                                _3309 = asint(srvLightInfoProperties.Load(((int)(_1596 + 84u))));
                                                _3312 = asint(srvLightInfoProperties.Load(((int)(_1596 + 88u))));
                                                _3315 = asint(srvLightInfoProperties.Load(((int)(_1596 + 92u))));
                                                _3318 = (float)((uint)((uint)(((uint)(_3300) >> 8) & 255)));
                                                _3321 = f16tof32(((uint)((uint)(_3303) >> 16)));
                                                _3323 = (uint)(_3306) >> 16;
                                                _3343 = srvDeferredShadingPass_DeferredShadows.Load(int3(_63, _64, 0));
                                                [branch]
                                                if (!(_3343.x == 0.0f)) {
                                                  do {
                                                    _3368 = cbSharedPerViewData.vAttenuatedSunColor.x;
                                                    _3369 = cbSharedPerViewData.vAttenuatedSunColor.y;
                                                    _3370 = cbSharedPerViewData.vAttenuatedSunColor.z;
                                                    [branch]
                                                    if (!(_3323 == 0)) {
                                                      Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3323)))];
                                                      _3360 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3285, _233, mad(_3284, _232, (_3283 * _231))) + _3286) * f16tof32(((uint)((uint)(_3312) >> 16)))) + f16tof32(((uint)((uint)(_3315) >> 16)))), (((mad(_3291, _233, mad(_3290, _232, (_3289 * _231))) + _3292) * f16tof32(_3312)) + f16tof32(_3315))), 0.0f);
                                                      _3368 = (_3360.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                                                      _3369 = (_3360.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                                                      _3370 = (_3360.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                                                    }
                                                    _3373 = min(_3343.x, _3343.y) * _3280;
                                                    [branch]
                                                    if (_3373 > 0.0f) {
                                                      _3376 = dot(float3(_3295, _3296, _3297), float3(_3295, _3296, _3297));
                                                      _3377 = rsqrt(_3376);
                                                      _3378 = _3377 * _3295;
                                                      _3379 = _3377 * _3296;
                                                      _3380 = _3377 * _3297;
                                                      _3381 = dot(float3(_197, _198, _199), float3(_3378, _3379, _3380));
                                                      do {
                                                        _3399 = _3381;
                                                        if (_3321 > 0.0f) {
                                                          _3389 = sqrt(saturate((_3321 * _3321) * (1.0f / (_3376 + 1.0f))));
                                                          if (_3381 < _3389) {
                                                            _3394 = max(_3381, (-0.0f - _3389)) + _3389;
                                                            _3399 = ((_3394 * _3394) / (_3389 * 4.0f));
                                                          } else {
                                                            _3399 = _3381;
                                                          }
                                                        }
                                                        _3400 = _219 * _219;
                                                        _3404 = saturate((_3321 * (1.0f - _3400)) * _3377);
                                                        _3406 = saturate(_3377 * f16tof32(_3303));
                                                        _3407 = dot(float3(_445, _446, _444), float3(_3378, _3379, _3380));
                                                        _3410 = rsqrt((_3407 * 2.0f) + 2.0f);
                                                        _3413 = saturate(_3410 * (_1131 + _3381));
                                                        _3417 = (_3404 > 0.0f);
                                                        do {
                                                          _3508 = saturate((_3410 * _3407) + _3410);
                                                          _3509 = _3413;
                                                          if (_3417) {
                                                            _3421 = sqrt(1.0f - (_3404 * _3404));
                                                            _3423 = (_3381 * 2.0f) * _1131;
                                                            _3424 = _3423 - _3407;
                                                            if (!(!(_3424 >= _3421))) {
                                                              _3508 = abs(_1131);
                                                              _3509 = 1.0f;
                                                            } else {
                                                              _3432 = rsqrt(1.0f - (_3424 * _3424)) * _3404;
                                                              _3435 = _3432 * (_1131 - (_3424 * _3381));
                                                              _3436 = _1131 * _1131;
                                                              _3441 = _3432 * (((_3436 * 2.0f) + -1.0f) - (_3424 * _3407));
                                                              _3450 = sqrt(saturate((((1.0f - (_3381 * _3381)) - _3436) - (_3407 * _3407)) + (_3423 * _3407)));
                                                              _3451 = _3450 * _3432;
                                                              _3454 = ((_1131 * 2.0f) * _3432) * _3450;
                                                              _3456 = (_3421 * _3381) + _1131;
                                                              _3457 = _3456 + _3435;
                                                              _3458 = _3421 * _3407;
                                                              _3460 = (_3458 + 1.0f) + _3441;
                                                              _3461 = _3451 * _3460;
                                                              _3462 = _3457 * _3460;
                                                              _3463 = _3454 * _3457;
                                                              _3468 = (((_3457 * 0.25f) * _3454) - (_3461 * 0.5f)) * _3462;
                                                              _3482 = (((_3463 - (_3461 * 2.0f)) * _3463) + (_3461 * _3461)) + ((((-0.5f - ((_3460 + _3458) * 0.5f)) * _3462) + ((_3460 * _3460) * _3456)) * _3457);
                                                              _3487 = (_3468 * 2.0f) / ((_3482 * _3482) + (_3468 * _3468));
                                                              _3488 = _3482 * _3487;
                                                              _3490 = 1.0f - (_3468 * _3487);
                                                              _3496 = ((_3488 * _3454) + _3458) + (_3490 * _3441);
                                                              _3499 = rsqrt((_3496 * 2.0f) + 2.0f);
                                                              _3508 = saturate((_3496 * _3499) + _3499);
                                                              _3509 = saturate(((_3456 + (_3488 * _3451)) + (_3490 * _3435)) * _3499);
                                                            }
                                                          }
                                                          _3510 = saturate(_3399);
                                                          _3511 = saturate(_3381);
                                                          _3512 = _3400 * _3400;
                                                          do {
                                                            _3522 = _3512;
                                                            if (_3406 > 0.0f) {
                                                              _3522 = saturate(((_3406 * _3406) / ((_3508 * 3.5999999046325684f) + 0.4000000059604645f)) + _3512);
                                                            }
                                                            _3523 = sqrt(_3522);
                                                            do {
                                                              _3534 = 1.0f;
                                                              if (_3417) {
                                                                _3534 = (_3522 / ((((_3404 * 0.25f) * ((_3523 * 3.0f) + _3404)) / (_3508 + 0.0010000000474974513f)) + _3522));
                                                              }
                                                              _3538 = (((_3522 * _3509) - _3509) * _3509) + 1.0f;
                                                              _3541 = (_3522 / (_3538 * _3538)) * _3534;
                                                              _3549 = exp2(log2(1.0f - saturate(_3508)) * 5.0f);
                                                              _3553 = (_3549 * (1.0f - _212)) + _212;
                                                              _3554 = (_3549 * (1.0f - _213)) + _213;
                                                              _3555 = (_3549 * (1.0f - _214)) + _214;
                                                              _3558 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                              _3559 = 1.0f - _3523;
                                                              _3567 = 0.5f / ((((_3559 * _3558) + _3523) * _3510) + (((_3559 * _3510) + _3523) * _3558));
                                                              do {
                                                                if (_217 < 0.007874015718698502f) {
                                                                  _3573 = _3509 * _3509;
                                                                  _3575 = max((1.0f - _3573), 9.999999747378752e-05f);
                                                                  _3713 = (((((((exp2(((-0.0f - (_3573 / _3575)) / _3522) * 1.4426950216293335f) * 4.0f) / (_3575 * _3575)) + 1.0f) * (1.0f / ((_3522 * 4.0f) + 1.0f))) - _3541) * _168) + _3541);
                                                                  _3714 = (((saturate(0.25f / ((_3511 + _1132) - (_3511 * _1132))) - _3567) * _168) + _3567);
                                                                } else {
                                                                  _3599 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                  _3600 = _3599 * _197;
                                                                  _3601 = _3599 * _198;
                                                                  _3602 = _3599 * _199;
                                                                  _3605 = (abs(_3600) < abs(_3601));
                                                                  _3606 = select(_3605, 1.0f, 0.0f);
                                                                  _3607 = select(_3605, 0.0f, 1.0f);
                                                                  _3608 = _3607 * _3602;
                                                                  _3610 = -0.0f - (_3602 * _3606);
                                                                  _3613 = (_3606 * _3601) - (_3607 * _3600);
                                                                  _3615 = rsqrt(dot(float3(_3608, _3610, _3613), float3(_3608, _3610, _3613)));
                                                                  _3616 = _3608 * _3615;
                                                                  _3617 = _3615 * _3610;
                                                                  _3618 = _3613 * _3615;
                                                                  _3621 = (_3617 * _3602) - (_3618 * _3601);
                                                                  _3624 = (_3618 * _3600) - (_3616 * _3602);
                                                                  _3627 = (_3616 * _3601) - (_3617 * _3600);
                                                                  _3629 = rsqrt(dot(float3(_3621, _3624, _3627), float3(_3621, _3624, _3627)));
                                                                  _3633 = _168 * 4.0f;
                                                                  _3642 = saturate(abs(_3633 + -2.5f) + -0.5f) + -0.5f;
                                                                  _3643 = saturate(1.5f - abs(_3633 + -1.5f)) + -0.5f;
                                                                  _3645 = rsqrt(dot(float2(_3642, _3643), float2(_3642, _3643)));
                                                                  _3646 = _3645 * _3642;
                                                                  _3647 = _3645 * _3643;
                                                                  _3654 = ((_3621 * _3629) * _3646) + (_3647 * _3616);
                                                                  _3655 = ((_3624 * _3629) * _3646) + (_3647 * _3617);
                                                                  _3656 = ((_3627 * _3629) * _3646) + (_3647 * _3618);
                                                                  _3659 = (_3655 * _199) - (_3656 * _198);
                                                                  _3662 = (_3656 * _197) - (_3654 * _199);
                                                                  _3665 = (_3654 * _198) - (_3655 * _197);
                                                                  _3666 = dot(float3(_3654, _3655, _3656), float3(_3378, _3379, _3380));
                                                                  _3667 = dot(float3(_3654, _3655, _3656), float3(_445, _446, _444));
                                                                  _3670 = dot(float3(_3659, _3662, _3665), float3(_3378, _3379, _3380));
                                                                  _3671 = dot(float3(_3659, _3662, _3665), float3(_445, _446, _444));
                                                                  _3677 = min(max((_3400 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                  _3681 = min(max((_3400 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                  _3682 = _3681 * _3677;
                                                                  _3683 = ((_3667 + _3666) * _3410) * _3681;
                                                                  _3684 = ((_3671 + _3670) * _3410) * _3677;
                                                                  _3685 = _3682 * _3413;
                                                                  _3686 = dot(float3(_3683, _3684, _3685), float3(_3683, _3684, _3685));
                                                                  _3691 = _3677 * _3667;
                                                                  _3692 = _3681 * _3671;
                                                                  _3700 = _3677 * _3666;
                                                                  _3701 = _3681 * _3670;
                                                                  _3713 = (((_3682 * _3682) * _3682) / (_3686 * _3686));
                                                                  _3714 = saturate(0.5f / ((sqrt(((_3700 * _3700) + (_3511 * _3511)) + (_3701 * _3701)) * _3558) + (sqrt(((_3692 * _3692) + (_3691 * _3691)) + (_3558 * _3558)) * _3511)));
                                                                }
                                                                _3716 = (_3713 * _3511) * _3714;
                                                                _3731 = saturate((_3381 + 0.5f) * 0.6666666865348816f);
                                                                do {
                                                                  _3846 = _3368;
                                                                  _3847 = _3369;
                                                                  _3848 = _3370;
                                                                  [branch]
                                                                  if (!((_3309 & 1) == 0)) {
                                                                    _3756 = max(max(_3368, _3369), _3370);
                                                                    do {
                                                                      _3766 = _3368;
                                                                      _3767 = _3369;
                                                                      _3768 = _3370;
                                                                      if (_3756 > 0.0f) {
                                                                        _3766 = saturate(_3368 / _3756);
                                                                        _3767 = saturate(_3369 / _3756);
                                                                        _3768 = saturate(_3370 / _3756);
                                                                      }
                                                                      _3769 = (_3767 < _3768);
                                                                      _3770 = select(_3769, _3768, _3767);
                                                                      _3771 = select(_3769, _3767, _3768);
                                                                      _3772 = select(_3769, -1.0f, 0.0f);
                                                                      _3773 = (_3766 < _3770);
                                                                      _3775 = select(_3773, _3770, _3766);
                                                                      _3776 = select(_3773, _3766, _3770);
                                                                      _3780 = _3775 - select((_3776 < _3771), _3776, _3771);
                                                                      _3786 = abs(select(_3773, (-0.3333333432674408f - _3772), _3772) + ((_3776 - _3771) / ((_3780 * 6.0f) + 9.999999682655225e-21f)));
                                                                      do {
                                                                        _3799 = _3786;
                                                                        if (_3786 < 0.6666666865348816f) {
                                                                          _3799 = ((saturate(((float)((uint)((uint)(((uint)(_3309) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3786 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3786)) + _3786);
                                                                        }
                                                                        _3800 = saturate((_3780 / (_3775 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3309) >> 1) & 255)))) * 0.003921499941498041f));
                                                                        _3801 = saturate(_3775);
                                                                        do {
                                                                          _3828 = _3801;
                                                                          _3829 = _3801;
                                                                          _3830 = _3801;
                                                                          if (!(_3800 <= 0.0f)) {
                                                                            _3804 = saturate(_3799);
                                                                            _3808 = select(((_3804 * 360.0f) >= 360.0f), 0.0f, (_3804 * 6.0f));
                                                                            _3809 = int(_3808);
                                                                            _3811 = _3808 - float((int)(_3809));
                                                                            _3813 = _3801 * (1.0f - _3800);
                                                                            _3816 = (1.0f - (_3811 * _3800)) * _3801;
                                                                            _3820 = (1.0f - ((1.0f - _3811) * _3800)) * _3801;
                                                                            switch (_3809) {
                                                                              case 0: {
                                                                                _3828 = _3801;
                                                                                _3829 = _3820;
                                                                                _3830 = _3813;
                                                                                break;
                                                                              }
                                                                              case 1: {
                                                                                _3828 = _3816;
                                                                                _3829 = _3801;
                                                                                _3830 = _3813;
                                                                                break;
                                                                              }
                                                                              case 2: {
                                                                                _3828 = _3813;
                                                                                _3829 = _3801;
                                                                                _3830 = _3820;
                                                                                break;
                                                                              }
                                                                              case 3: {
                                                                                _3828 = _3813;
                                                                                _3829 = _3816;
                                                                                _3830 = _3801;
                                                                                break;
                                                                              }
                                                                              case 4: {
                                                                                _3828 = _3820;
                                                                                _3829 = _3813;
                                                                                _3830 = _3801;
                                                                                break;
                                                                              }
                                                                              case 5: {
                                                                                _3828 = _3801;
                                                                                _3829 = _3813;
                                                                                _3830 = _3816;
                                                                                break;
                                                                              }
                                                                              default: {
                                                                                _3828 = 0.0f;
                                                                                _3829 = 0.0f;
                                                                                _3830 = 0.0f;
                                                                                break;
                                                                              }
                                                                            }
                                                                          }
                                                                          _3831 = _3828 * _3756;
                                                                          _3832 = _3829 * _3756;
                                                                          _3833 = _3830 * _3756;
                                                                          _3835 = saturate(_3373 * 1.0101009607315063f);
                                                                          _3846 = ((_3835 * (_3368 - _3831)) + _3831);
                                                                          _3847 = ((_3835 * (_3369 - _3832)) + _3832);
                                                                          _3848 = (lerp(_3833, _3370, _3835));
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  _3849 = _3846 * _3373;
                                                                  _3850 = _3847 * _3373;
                                                                  _3851 = _3848 * _3373;
                                                                  do {
                                                                    _3861 = _3849;
                                                                    _3862 = _3850;
                                                                    _3863 = _3851;
                                                                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                                                                      _3861 = (_3849 * _1274);
                                                                      _3862 = (_3850 * _1274);
                                                                      _3863 = (_3851 * _1274);
                                                                    }
                                                                    _3867 = (((_3731 * (1.0f - _3553)) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _3511)) * _3861) + _1582;
                                                                    _3868 = (((_3731 * (1.0f - _3554)) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _3511)) * _3862) + _1583;
                                                                    _3869 = (((_3731 * (1.0f - _3555)) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _3511)) * _3863) + _1584;
                                                                    if ((_3318 * 0.003921499941498041f) > 0.0f) {
                                                                      _3872 = (_1347 * 0.003921499941498041f) * _3318;
                                                                      _9262 = _3867;
                                                                      _9263 = _3868;
                                                                      _9264 = _3869;
                                                                      _9265 = ((((_3553 * _3872) * _3716) * _3861) + _1585);
                                                                      _9266 = ((((_3554 * _3872) * _3716) * _3862) + _1586);
                                                                      _9267 = ((((_3555 * _3872) * _3716) * _3863) + _1587);
                                                                    } else {
                                                                      _9262 = _3867;
                                                                      _9263 = _3868;
                                                                      _9264 = _3869;
                                                                      _9265 = _1585;
                                                                      _9266 = _1586;
                                                                      _9267 = _1587;
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
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } else {
                                                      _9262 = _1582;
                                                      _9263 = _1583;
                                                      _9264 = _1584;
                                                      _9265 = _1585;
                                                      _9266 = _1586;
                                                      _9267 = _1587;
                                                    }
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                } else {
                                                  _9262 = _1582;
                                                  _9263 = _1583;
                                                  _9264 = _1584;
                                                  _9265 = _1585;
                                                  _9266 = _1586;
                                                  _9267 = _1587;
                                                }
                                              } while (false);
                                              if (_loop_break_3) break;
                                            } else {
                                              _1645 = _1625 * select(((_1594 & 67108864) != 0), 1.0f, (1.0f - _1577));
                                              [branch]
                                              if (_1628 == 4) {
                                                _1650 = asfloat(srvLightInfoProperties.Load4(_1596)).x;
                                                _1651 = asfloat(srvLightInfoProperties.Load4(_1596)).y;
                                                _1652 = asfloat(srvLightInfoProperties.Load4(_1596)).z;
                                                _1653 = asfloat(srvLightInfoProperties.Load4(_1596)).w;
                                                _1656 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).x;
                                                _1657 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).y;
                                                _1658 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).z;
                                                _1659 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).w;
                                                _1662 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).x;
                                                _1663 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).y;
                                                _1664 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).z;
                                                _1665 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).w;
                                                _1668 = asint(srvLightInfoProperties.Load(((int)(_1596 + 48u))));
                                                _1671 = asint(srvLightInfoProperties.Load(((int)(_1596 + 52u))));
                                                _1674 = asint(srvLightInfoProperties.Load(((int)(_1596 + 64u))));
                                                _1677 = asint(srvLightInfoProperties.Load(((int)(_1596 + 68u))));
                                                _1680 = asint(srvLightInfoProperties.Load(((int)(_1596 + 72u))));
                                                _1682 = f16tof32(((uint)((uint)(_1668) >> 16)));
                                                _1683 = f16tof32(_1668);
                                                _1685 = f16tof32(((uint)((uint)(_1671) >> 16)));
                                                _1689 = ((float)((uint)((uint)(((uint)(_1671) >> 8) & 255)))) * 0.003921499941498041f;
                                                _1702 = mad(_1652, _233, mad(_1651, _232, (_1650 * _231))) + _1653;
                                                _1706 = mad(_1658, _233, mad(_1657, _232, (_1656 * _231))) + _1659;
                                                _1710 = mad(_1664, _233, mad(_1663, _232, (_1662 * _231))) + _1665;
                                                _1735 = saturate(1.0f - ((_1702 + 1.0f) * f16tof32(_1674))) + saturate(1.0f - ((1.0f - _1702) * f16tof32(((uint)((uint)(_1674) >> 16)))));
                                                _1736 = saturate(1.0f - ((_1706 + 1.0f) * f16tof32(_1677))) + saturate(1.0f - ((1.0f - _1706) * f16tof32(((uint)((uint)(_1677) >> 16)))));
                                                _1737 = saturate(1.0f - ((_1710 + 1.0f) * f16tof32(_1680))) + saturate(1.0f - ((1.0f - _1710) * f16tof32(((uint)((uint)(_1680) >> 16)))));
                                                _1740 = saturate(1.0f - dot(float3(_1735, _1736, _1737), float3(_1735, _1736, _1737)));
                                                _1741 = _1740 * _1740;
                                                _1748 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1741 * _1274), _1741) * _1645;
                                                _9262 = ((_1748 * _1682) + _1582);
                                                _9263 = ((_1748 * _1683) + _1583);
                                                _9264 = ((_1748 * _1685) + _1584);
                                                _9265 = (((_1689 * _1682) * _1748) + _1585);
                                                _9266 = (((_1689 * _1683) * _1748) + _1586);
                                                _9267 = (((_1685 * _1689) * _1748) + _1587);
                                              } else {
                                                if (_1628 == 5) {
                                                  _1769 = asfloat(srvLightInfoProperties.Load4(_1596)).x;
                                                  _1770 = asfloat(srvLightInfoProperties.Load4(_1596)).y;
                                                  _1771 = asfloat(srvLightInfoProperties.Load4(_1596)).z;
                                                  _1772 = asfloat(srvLightInfoProperties.Load4(_1596)).w;
                                                  _1775 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).x;
                                                  _1776 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).y;
                                                  _1777 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).z;
                                                  _1778 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).w;
                                                  _1781 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).x;
                                                  _1782 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).y;
                                                  _1783 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).z;
                                                  _1784 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).w;
                                                  _1787 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).x;
                                                  _1788 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).y;
                                                  _1789 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).z;
                                                  _1792 = asfloat(srvLightInfoProperties.Load(((int)(_1596 + 60u))));
                                                  _1795 = asint(srvLightInfoProperties.Load(((int)(_1596 + 64u))));
                                                  _1798 = asint(srvLightInfoProperties.Load(((int)(_1596 + 68u))));
                                                  _1801 = asint(srvLightInfoProperties.Load(((int)(_1596 + 80u))));
                                                  _1804 = asint(srvLightInfoProperties.Load(((int)(_1596 + 84u))));
                                                  _1807 = asint(srvLightInfoProperties.Load(((int)(_1596 + 88u))));
                                                  _1810 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 92u)))).x;
                                                  _1811 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 92u)))).y;
                                                  _1812 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 92u)))).z;
                                                  _1813 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 92u)))).w;
                                                  _1816 = asint(srvLightInfoProperties.Load(((int)(_1596 + 108u))));
                                                  _1819 = asint(srvLightInfoProperties.Load(((int)(_1596 + 112u))));
                                                  _1822 = asint(srvLightInfoProperties.Load(((int)(_1596 + 120u))));
                                                  _1825 = asint(srvLightInfoProperties.Load(((int)(_1596 + 124u))));
                                                  _1828 = asint(srvLightInfoProperties.Load(((int)(_1596 + 128u))));
                                                  _1831 = asint(srvLightInfoProperties.Load(((int)(_1596 + 132u))));
                                                  _1834 = asint(srvLightInfoProperties.Load(((int)(_1596 + 136u))));
                                                  _1837 = asint(srvLightInfoProperties.Load(((int)(_1596 + 140u))));
                                                  _1839 = f16tof32(((uint)((uint)(_1795) >> 16)));
                                                  _1840 = f16tof32(_1795);
                                                  _1842 = f16tof32(((uint)((uint)(_1798) >> 16)));
                                                  _1846 = ((float)((uint)((uint)(((uint)(_1798) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _1848 = f16tof32(((uint)((uint)(_1801) >> 16)));
                                                  _1851 = _1804 & 65535;
                                                  _1861 = f16tof32(((uint)((uint)(_1819) >> 16)));
                                                  _1862 = f16tof32(_1819);
                                                  _1864 = f16tof32(((uint)((uint)(_1822) >> 16)));
                                                  _1865 = 1.0f / _1864;
                                                  _1866 = _1864 + -1.0f;
                                                  _1867 = f16tof32(_1822);
                                                  _1886 = saturate(1.0f - dot(float3(_197, _198, _199), float3(_1787, _1788, _1789))) * f16tof32(_1816);
                                                  _1890 = (_1886 * _197) + _231;
                                                  _1891 = (_1886 * _198) + _232;
                                                  _1892 = (_1886 * _199) - _230;
                                                  _1896 = mad(_1771, _1892, mad(_1770, _1891, (_1890 * _1769))) + _1772;
                                                  _1900 = mad(_1777, _1892, mad(_1776, _1891, (_1890 * _1775))) + _1778;
                                                  _1904 = mad(_1783, _1892, mad(_1782, _1891, (_1890 * _1781))) + _1784;
                                                  _1905 = saturate(_1904);
                                                  _1928 = saturate(1.0f - (_1896 * f16tof32(_1831))) + saturate(1.0f - ((1.0f - _1896) * f16tof32(((uint)((uint)(_1831) >> 16)))));
                                                  _1929 = saturate(1.0f - (_1900 * f16tof32(_1834))) + saturate(1.0f - ((1.0f - _1900) * f16tof32(((uint)((uint)(_1834) >> 16)))));
                                                  _1930 = saturate(1.0f - (_1904 * f16tof32(_1837))) + saturate(1.0f - ((1.0f - _1904) * f16tof32(((uint)((uint)(_1837) >> 16)))));
                                                  _1933 = saturate(1.0f - dot(float3(_1928, _1929, _1930), float3(_1928, _1929, _1930)));
                                                  _1934 = _1933 * _1933;
                                                  do {
                                                    _2773 = 1.0f;
                                                    if (!(((_1594 & 3584) == 0) || (!(_1934 > 0.0f)))) {
                                                      _1941 = 1.0f - _1905;
                                                      _1942 = saturate(_1896);
                                                      _1943 = saturate(_1900);
                                                      do {
                                                        _2206 = 1.0f;
                                                        _2207 = 0.0f;
                                                        _2208 = _1941;
                                                        [branch]
                                                        if (!((_1594 & 1024) == 0)) {
                                                          _1948 = ((_1942 * _1866) + 0.5f) * _1865;
                                                          _1950 = ((_1943 * _1866) + 0.5f) * _1865;
                                                          _1951 = _1941 + f16tof32(((uint)((uint)(_1816) >> 16)));
                                                          Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1804) >> 16))];
                                                          _1954 = saturate(_1951);
                                                          _1958 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                          #if FIRSTLIGHT_ISFAST_ENABLED
                                                          if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                            _1967 = RenoDX_ISFASTShadowAngle(
                                                                uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 0u);
                                                          } else {
                                                            _1967 = frac(frac(dot(float2(((_1958 * 32.665000915527344f) + _125), ((_1958 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                          }
                                                          #else
                                                          _1967 = frac(frac(dot(float2(((_1958 * 32.665000915527344f) + _125), ((_1958 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                          #endif
                                                          _1968 = sin(_1967);
                                                          _1969 = cos(_1967);
                                                          _1970 = cbSharedPerViewData.nFrameCounter & 3;
                                                          _1975 = sqrt((float((int)(_1970)) * 0.25f) + 0.125f) * _1861;
                                                          _1984 = (_global_7[min((uint)(((int)(0u + (_1970 * 2)))), 127u)]) * _1975;
                                                          _1985 = (_global_7[min((uint)(((int)(1u + (_1970 * 2)))), 127u)]) * _1975;
                                                          _1987 = -0.0f - _1968;
                                                          _1992 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1984, _1985), float2(_1969, _1968)) + _1948), (dot(float2(_1984, _1985), float2(_1987, _1969)) + _1950)));
                                                          _1997 = _1992.x - _1954;
                                                          _1999 = select((_1997 < 0.0f), 0.0f, 1.0f);
                                                          _2001 = _1992.y - _1954;
                                                          _2003 = select((_2001 < 0.0f), 0.0f, 1.0f);
                                                          _2007 = _1992.z - _1954;
                                                          _2009 = select((_2007 < 0.0f), 0.0f, 1.0f);
                                                          _2013 = _1992.w - _1954;
                                                          _2015 = select((_2013 < 0.0f), 0.0f, 1.0f);
                                                          _2022 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                          _2027 = sqrt((float((int)(_2022)) * 0.25f) + 0.125f) * _1861;
                                                          _2036 = (_global_7[min((uint)(((int)(0u + (_2022 * 2)))), 127u)]) * _2027;
                                                          _2037 = (_global_7[min((uint)(((int)(1u + (_2022 * 2)))), 127u)]) * _2027;
                                                          _2043 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2036, _2037), float2(_1969, _1968)) + _1948), (dot(float2(_2036, _2037), float2(_1987, _1969)) + _1950)));
                                                          _2048 = _2043.x - _1954;
                                                          _2050 = select((_2048 < 0.0f), 0.0f, 1.0f);
                                                          _2054 = _2043.y - _1954;
                                                          _2056 = select((_2054 < 0.0f), 0.0f, 1.0f);
                                                          _2060 = _2043.z - _1954;
                                                          _2062 = select((_2060 < 0.0f), 0.0f, 1.0f);
                                                          _2066 = _2043.w - _1954;
                                                          _2068 = select((_2066 < 0.0f), 0.0f, 1.0f);
                                                          _2075 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                          _2080 = sqrt((float((int)(_2075)) * 0.25f) + 0.125f) * _1861;
                                                          _2089 = (_global_7[min((uint)(((int)(0u + (_2075 * 2)))), 127u)]) * _2080;
                                                          _2090 = (_global_7[min((uint)(((int)(1u + (_2075 * 2)))), 127u)]) * _2080;
                                                          _2096 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2089, _2090), float2(_1969, _1968)) + _1948), (dot(float2(_2089, _2090), float2(_1987, _1969)) + _1950)));
                                                          _2101 = _2096.x - _1954;
                                                          _2103 = select((_2101 < 0.0f), 0.0f, 1.0f);
                                                          _2107 = _2096.y - _1954;
                                                          _2109 = select((_2107 < 0.0f), 0.0f, 1.0f);
                                                          _2113 = _2096.z - _1954;
                                                          _2115 = select((_2113 < 0.0f), 0.0f, 1.0f);
                                                          _2119 = _2096.w - _1954;
                                                          _2121 = select((_2119 < 0.0f), 0.0f, 1.0f);
                                                          _2128 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                          _2133 = sqrt((float((int)(_2128)) * 0.25f) + 0.125f) * _1861;
                                                          _2142 = (_global_7[min((uint)(((int)(0u + (_2128 * 2)))), 127u)]) * _2133;
                                                          _2143 = (_global_7[min((uint)(((int)(1u + (_2128 * 2)))), 127u)]) * _2133;
                                                          _2149 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2142, _2143), float2(_1969, _1968)) + _1948), (dot(float2(_2142, _2143), float2(_1987, _1969)) + _1950)));
                                                          _2154 = _2149.x - _1954;
                                                          _2156 = select((_2154 < 0.0f), 0.0f, 1.0f);
                                                          _2160 = _2149.y - _1954;
                                                          _2162 = select((_2160 < 0.0f), 0.0f, 1.0f);
                                                          _2166 = _2149.z - _1954;
                                                          _2168 = select((_2166 < 0.0f), 0.0f, 1.0f);
                                                          _2172 = _2149.w - _1954;
                                                          _2174 = select((_2172 < 0.0f), 0.0f, 1.0f);
                                                          _2175 = ((((((((((((((_1999 + _2003) + _2009) + _2015) + _2050) + _2056) + _2062) + _2068) + _2103) + _2109) + _2115) + _2121) + _2156) + _2162) + _2168) + _2174;
                                                          _2186 = (saturate(_2175 * 0.0625f) * 2.0f) + -1.0f;
                                                          _2192 = float((int)(((int)(uint)((int)(_2186 > 0.0f))) - ((int)(uint)((int)(_2186 < 0.0f)))));
                                                          _2194 = 1.0f - (_2192 * _2186);
                                                          _2196 = (_2194 * _2194) * _2194;
                                                          _2203 = 0.5f - ((_2192 * 0.5f) * ((1.0f - _2196) - ((_2194 - _2196) * saturate(((1.0f / _1954) * (1.0f / _2175)) * ((((((((((((((((_1999 * _1997) + (_2003 * _2001)) + (_2009 * _2007)) + (_2015 * _2013)) + (_2050 * _2048)) + (_2056 * _2054)) + (_2062 * _2060)) + (_2068 * _2066)) + (_2103 * _2101)) + (_2109 * _2107)) + (_2115 * _2113)) + (_2121 * _2119)) + (_2156 * _2154)) + (_2162 * _2160)) + (_2168 * _2166)) + (_2174 * _2172))))));
                                                          [branch]
                                                          if (!(_1867 < 1.0f)) {
                                                            _2676 = _2203;
                                                            do {
                                                              _2773 = _2676;
                                                              [branch]
                                                              if (!((_1594 & 2048) == 0)) {
                                                                Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1807) >> 16))];
                                                                _2682 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1896, _1900), 0.0f);
                                                                if (_2682.x > 0.0f) {
                                                                  Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1807 & 65535))];
                                                                  _2689 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1896, _1900), 0.0f);
                                                                  _2703 = mad(saturate(((log2(_1905 * _1792) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                  _2704 = max(9.999999747378752e-06f, _2682.x);
                                                                  _2705 = _2689.x / _2704;
                                                                  _2706 = _2689.y / _2704;
                                                                  _2708 = _2689.w / _2704;
                                                                  _2713 = ((0.375f - _2706) * 4.999999873689376e-06f) + _2706;
                                                                  _2716 = -0.0f - _2705;
                                                                  _2717 = mad(_2716, _2713, (_2689.z / _2704));
                                                                  _2719 = 1.0f / mad(_2716, _2705, _2713);
                                                                  _2720 = _2719 * _2717;
                                                                  _2725 = _2703 - _2705;
                                                                  _2730 = (((_2703 * _2703) - _2713) - (_2720 * _2725)) / mad((-0.0f - _2717), _2720, mad((-0.0f - _2713), _2713, (((0.375f - _2708) * 4.999999873689376e-06f) + _2708)));
                                                                  _2732 = (_2719 * _2725) - (_2730 * _2720);
                                                                  _2735 = 1.0f / _2730;
                                                                  _2736 = _2732 * _2735;
                                                                  _2741 = sqrt(((_2736 * _2736) * 0.25f) - ((1.0f - dot(float2(_2732, _2730), float2(_2705, _2713))) * _2735));
                                                                  _2743 = (_2736 * -0.5f) - _2741;
                                                                  _2745 = _2741 - (_2736 * 0.5f);
                                                                  _2747 = select((_2743 < _2703), 1.0f, 0.0f);
                                                                  _2752 = (_2747 + -0.05000000074505806f) / (_2743 - _2703);
                                                                  _2758 = (((select((_2745 < _2703), 1.0f, 0.0f) - _2747) / (_2745 - _2743)) - _2752) / (_2745 - _2703);
                                                                  _2760 = _2752 - (_2758 * _2743);
                                                                  _2773 = (exp2((_2682.x * -1.4426950216293335f) * saturate((dot(float2(_2705, _2713), float2((_2760 - (_2758 * _2703)), _2758)) + 0.05000000074505806f) - (_2760 * _2703))) * _2676);
                                                                } else {
                                                                  _2773 = _2676;
                                                                }
                                                              }
                                                              break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                            // Native completed depth-gather shadow bypasses the fallback path.
                                                            break;
                                                          } else {
                                                            _2206 = _2203;
                                                            _2207 = _1867;
                                                            _2208 = _1951;
                                                          }
                                                        }
                                                        _2211 = (_1942 * _1810) + _1812;
                                                        _2212 = (_1943 * _1811) + _1813;
                                                        do {
                                                          _2671 = 1.0f;
                                                          if (!((_1594 & 512) == 0)) {
                                                            Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                                                            _2221 = saturate(_2208);
                                                            _2225 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                            #if FIRSTLIGHT_ISFAST_ENABLED
                                                            if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                              _2234 = RenoDX_ISFASTShadowAngle(
                                                                  uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 1u);
                                                            } else {
                                                              _2234 = frac(frac(dot(float2(((_2225 * 32.665000915527344f) + _125), ((_2225 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            }
                                                            #else
                                                            _2234 = frac(frac(dot(float2(((_2225 * 32.665000915527344f) + _125), ((_2225 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            #endif
                                                            _2235 = sin(_2234);
                                                            _2236 = cos(_2234);
                                                            _2241 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2211, _2212), 0.0f))).x) > _2221), 1.0f, 0.0f);
                                                            _2242 = cbSharedPerViewData.nFrameCounter & 3;
                                                            _2247 = sqrt((float((int)(_2242)) * 0.25f) + 0.125f) * _1862;
                                                            _2256 = (_global_7[min((uint)(((int)(0u + (_2242 * 2)))), 127u)]) * _2247;
                                                            _2257 = (_global_7[min((uint)(((int)(1u + (_2242 * 2)))), 127u)]) * _2247;
                                                            _2259 = -0.0f - _2235;
                                                            _2261 = dot(float2(_2256, _2257), float2(_2236, _2235)) + _2211;
                                                            _2262 = dot(float2(_2256, _2257), float2(_2259, _2236)) + _2212;
                                                            _2264 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2261, _2262));
                                                            _2268 = _2261 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                            _2269 = _2262 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                            _2272 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1812);
                                                            _2273 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1813);
                                                            _2278 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1810 + _1812)) + 0.5f);
                                                            _2279 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1811 + _1813)) + 0.5f);
                                                            _2282 = floor(_2268 + -0.5f);
                                                            _2283 = floor(_2269 + 0.5f);
                                                            _2285 = floor(_2268 + 0.5f);
                                                            _2287 = floor(_2269 + -0.5f);
                                                            _2288 = (_2282 < _2272);
                                                            _2289 = (_2283 < _2273);
                                                            do {
                                                              if (!(_2288 || _2289)) {
                                                                if ((_2282 >= _2278) || (_2283 >= _2279)) {
                                                                  _2298 = _2241;
                                                                } else {
                                                                  _2298 = _2264.x;
                                                                }
                                                              } else {
                                                                _2298 = _2241;
                                                              }
                                                              _2299 = (_2285 < _2272);
                                                              do {
                                                                if (!(_2299 || _2289)) {
                                                                  if ((_2285 >= _2278) || (_2283 >= _2279)) {
                                                                    _2307 = _2241;
                                                                  } else {
                                                                    _2307 = _2264.y;
                                                                  }
                                                                } else {
                                                                  _2307 = _2241;
                                                                }
                                                                _2308 = (_2287 < _2273);
                                                                do {
                                                                  if (!(_2299 || _2308)) {
                                                                    if ((_2285 >= _2278) || (_2287 >= _2279)) {
                                                                      _2316 = _2241;
                                                                    } else {
                                                                      _2316 = _2264.z;
                                                                    }
                                                                  } else {
                                                                    _2316 = _2241;
                                                                  }
                                                                  do {
                                                                    if (!(_2288 || _2308)) {
                                                                      if ((_2282 >= _2278) || (_2287 >= _2279)) {
                                                                        _2324 = _2241;
                                                                      } else {
                                                                        _2324 = _2264.w;
                                                                      }
                                                                    } else {
                                                                      _2324 = _2241;
                                                                    }
                                                                    _2325 = _2298 - _2221;
                                                                    _2327 = select((_2325 < 0.0f), 0.0f, 1.0f);
                                                                    _2329 = _2307 - _2221;
                                                                    _2331 = select((_2329 < 0.0f), 0.0f, 1.0f);
                                                                    _2335 = _2316 - _2221;
                                                                    _2337 = select((_2335 < 0.0f), 0.0f, 1.0f);
                                                                    _2341 = _2324 - _2221;
                                                                    _2343 = select((_2341 < 0.0f), 0.0f, 1.0f);
                                                                    _2350 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                    _2355 = sqrt((float((int)(_2350)) * 0.25f) + 0.125f) * _1862;
                                                                    _2364 = (_global_7[min((uint)(((int)(0u + (_2350 * 2)))), 127u)]) * _2355;
                                                                    _2365 = (_global_7[min((uint)(((int)(1u + (_2350 * 2)))), 127u)]) * _2355;
                                                                    _2368 = dot(float2(_2364, _2365), float2(_2236, _2235)) + _2211;
                                                                    _2369 = dot(float2(_2364, _2365), float2(_2259, _2236)) + _2212;
                                                                    _2371 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2368, _2369));
                                                                    _2375 = _2368 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                    _2376 = _2369 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                    _2379 = floor(_2375 + -0.5f);
                                                                    _2380 = floor(_2376 + 0.5f);
                                                                    _2382 = floor(_2375 + 0.5f);
                                                                    _2384 = floor(_2376 + -0.5f);
                                                                    _2385 = (_2379 < _2272);
                                                                    _2386 = (_2380 < _2273);
                                                                    do {
                                                                      if (!(_2385 || _2386)) {
                                                                        if ((_2379 >= _2278) || (_2380 >= _2279)) {
                                                                          _2395 = _2241;
                                                                        } else {
                                                                          _2395 = _2371.x;
                                                                        }
                                                                      } else {
                                                                        _2395 = _2241;
                                                                      }
                                                                      _2396 = (_2382 < _2272);
                                                                      do {
                                                                        if (!(_2396 || _2386)) {
                                                                          if ((_2382 >= _2278) || (_2380 >= _2279)) {
                                                                            _2404 = _2241;
                                                                          } else {
                                                                            _2404 = _2371.y;
                                                                          }
                                                                        } else {
                                                                          _2404 = _2241;
                                                                        }
                                                                        _2405 = (_2384 < _2273);
                                                                        do {
                                                                          if (!(_2396 || _2405)) {
                                                                            if ((_2382 >= _2278) || (_2384 >= _2279)) {
                                                                              _2413 = _2241;
                                                                            } else {
                                                                              _2413 = _2371.z;
                                                                            }
                                                                          } else {
                                                                            _2413 = _2241;
                                                                          }
                                                                          do {
                                                                            if (!(_2385 || _2405)) {
                                                                              if ((_2379 >= _2278) || (_2384 >= _2279)) {
                                                                                _2421 = _2241;
                                                                              } else {
                                                                                _2421 = _2371.w;
                                                                              }
                                                                            } else {
                                                                              _2421 = _2241;
                                                                            }
                                                                            _2422 = _2395 - _2221;
                                                                            _2424 = select((_2422 < 0.0f), 0.0f, 1.0f);
                                                                            _2428 = _2404 - _2221;
                                                                            _2430 = select((_2428 < 0.0f), 0.0f, 1.0f);
                                                                            _2434 = _2413 - _2221;
                                                                            _2436 = select((_2434 < 0.0f), 0.0f, 1.0f);
                                                                            _2440 = _2421 - _2221;
                                                                            _2442 = select((_2440 < 0.0f), 0.0f, 1.0f);
                                                                            _2449 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                            _2454 = sqrt((float((int)(_2449)) * 0.25f) + 0.125f) * _1862;
                                                                            _2463 = (_global_7[min((uint)(((int)(0u + (_2449 * 2)))), 127u)]) * _2454;
                                                                            _2464 = (_global_7[min((uint)(((int)(1u + (_2449 * 2)))), 127u)]) * _2454;
                                                                            _2467 = dot(float2(_2463, _2464), float2(_2236, _2235)) + _2211;
                                                                            _2468 = dot(float2(_2463, _2464), float2(_2259, _2236)) + _2212;
                                                                            _2470 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2467, _2468));
                                                                            _2474 = _2467 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                            _2475 = _2468 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                            _2478 = floor(_2474 + -0.5f);
                                                                            _2479 = floor(_2475 + 0.5f);
                                                                            _2481 = floor(_2474 + 0.5f);
                                                                            _2483 = floor(_2475 + -0.5f);
                                                                            _2484 = (_2478 < _2272);
                                                                            _2485 = (_2479 < _2273);
                                                                            do {
                                                                              if (!(_2484 || _2485)) {
                                                                                if ((_2478 >= _2278) || (_2479 >= _2279)) {
                                                                                  _2494 = _2241;
                                                                                } else {
                                                                                  _2494 = _2470.x;
                                                                                }
                                                                              } else {
                                                                                _2494 = _2241;
                                                                              }
                                                                              _2495 = (_2481 < _2272);
                                                                              do {
                                                                                if (!(_2495 || _2485)) {
                                                                                  if ((_2481 >= _2278) || (_2479 >= _2279)) {
                                                                                    _2503 = _2241;
                                                                                  } else {
                                                                                    _2503 = _2470.y;
                                                                                  }
                                                                                } else {
                                                                                  _2503 = _2241;
                                                                                }
                                                                                _2504 = (_2483 < _2273);
                                                                                do {
                                                                                  if (!(_2495 || _2504)) {
                                                                                    if ((_2481 >= _2278) || (_2483 >= _2279)) {
                                                                                      _2512 = _2241;
                                                                                    } else {
                                                                                      _2512 = _2470.z;
                                                                                    }
                                                                                  } else {
                                                                                    _2512 = _2241;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_2484 || _2504)) {
                                                                                      if ((_2478 >= _2278) || (_2483 >= _2279)) {
                                                                                        _2520 = _2241;
                                                                                      } else {
                                                                                        _2520 = _2470.w;
                                                                                      }
                                                                                    } else {
                                                                                      _2520 = _2241;
                                                                                    }
                                                                                    _2521 = _2494 - _2221;
                                                                                    _2523 = select((_2521 < 0.0f), 0.0f, 1.0f);
                                                                                    _2527 = _2503 - _2221;
                                                                                    _2529 = select((_2527 < 0.0f), 0.0f, 1.0f);
                                                                                    _2533 = _2512 - _2221;
                                                                                    _2535 = select((_2533 < 0.0f), 0.0f, 1.0f);
                                                                                    _2539 = _2520 - _2221;
                                                                                    _2541 = select((_2539 < 0.0f), 0.0f, 1.0f);
                                                                                    _2548 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                    _2553 = sqrt((float((int)(_2548)) * 0.25f) + 0.125f) * _1862;
                                                                                    _2562 = (_global_7[min((uint)(((int)(0u + (_2548 * 2)))), 127u)]) * _2553;
                                                                                    _2563 = (_global_7[min((uint)(((int)(1u + (_2548 * 2)))), 127u)]) * _2553;
                                                                                    _2566 = dot(float2(_2562, _2563), float2(_2236, _2235)) + _2211;
                                                                                    _2567 = dot(float2(_2562, _2563), float2(_2259, _2236)) + _2212;
                                                                                    _2569 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2566, _2567));
                                                                                    _2573 = _2566 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                    _2574 = _2567 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                    _2577 = floor(_2573 + -0.5f);
                                                                                    _2578 = floor(_2574 + 0.5f);
                                                                                    _2580 = floor(_2573 + 0.5f);
                                                                                    _2582 = floor(_2574 + -0.5f);
                                                                                    _2583 = (_2577 < _2272);
                                                                                    _2584 = (_2578 < _2273);
                                                                                    do {
                                                                                      if (!(_2583 || _2584)) {
                                                                                        if ((_2577 >= _2278) || (_2578 >= _2279)) {
                                                                                          _2593 = _2241;
                                                                                        } else {
                                                                                          _2593 = _2569.x;
                                                                                        }
                                                                                      } else {
                                                                                        _2593 = _2241;
                                                                                      }
                                                                                      _2594 = (_2580 < _2272);
                                                                                      do {
                                                                                        if (!(_2594 || _2584)) {
                                                                                          if ((_2580 >= _2278) || (_2578 >= _2279)) {
                                                                                            _2602 = _2241;
                                                                                          } else {
                                                                                            _2602 = _2569.y;
                                                                                          }
                                                                                        } else {
                                                                                          _2602 = _2241;
                                                                                        }
                                                                                        _2603 = (_2582 < _2273);
                                                                                        do {
                                                                                          if (!(_2594 || _2603)) {
                                                                                            if ((_2580 >= _2278) || (_2582 >= _2279)) {
                                                                                              _2611 = _2241;
                                                                                            } else {
                                                                                              _2611 = _2569.z;
                                                                                            }
                                                                                          } else {
                                                                                            _2611 = _2241;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_2583 || _2603)) {
                                                                                              if ((_2577 >= _2278) || (_2582 >= _2279)) {
                                                                                                _2619 = _2241;
                                                                                              } else {
                                                                                                _2619 = _2569.w;
                                                                                              }
                                                                                            } else {
                                                                                              _2619 = _2241;
                                                                                            }
                                                                                            _2620 = _2593 - _2221;
                                                                                            _2622 = select((_2620 < 0.0f), 0.0f, 1.0f);
                                                                                            _2626 = _2602 - _2221;
                                                                                            _2628 = select((_2626 < 0.0f), 0.0f, 1.0f);
                                                                                            _2632 = _2611 - _2221;
                                                                                            _2634 = select((_2632 < 0.0f), 0.0f, 1.0f);
                                                                                            _2638 = _2619 - _2221;
                                                                                            _2640 = select((_2638 < 0.0f), 0.0f, 1.0f);
                                                                                            _2641 = ((((((((((((((_2331 + _2327) + _2337) + _2343) + _2424) + _2430) + _2436) + _2442) + _2523) + _2529) + _2535) + _2541) + _2622) + _2628) + _2634) + _2640;
                                                                                            _2652 = (saturate(_2641 * 0.0625f) * 2.0f) + -1.0f;
                                                                                            _2658 = float((int)(((int)(uint)((int)(_2652 > 0.0f))) - ((int)(uint)((int)(_2652 < 0.0f)))));
                                                                                            _2660 = 1.0f - (_2658 * _2652);
                                                                                            _2662 = (_2660 * _2660) * _2660;
                                                                                            _2671 = (0.5f - ((_2658 * 0.5f) * ((1.0f - _2662) - ((_2660 - _2662) * saturate(((1.0f / _2221) * (1.0f / _2641)) * ((((((((((((((((_2331 * _2329) + (_2327 * _2325)) + (_2337 * _2335)) + (_2343 * _2341)) + (_2424 * _2422)) + (_2430 * _2428)) + (_2436 * _2434)) + (_2442 * _2440)) + (_2523 * _2521)) + (_2529 * _2527)) + (_2535 * _2533)) + (_2541 * _2539)) + (_2622 * _2620)) + (_2628 * _2626)) + (_2634 * _2632)) + (_2640 * _2638)))))));
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
                                                          _2676 = (lerp(_2671, _2206, _2207));
                                                          [branch]
                                                          if (!((_1594 & 2048) == 0)) {
                                                            Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1807) >> 16))];
                                                            _2682 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1896, _1900), 0.0f);
                                                            if (_2682.x > 0.0f) {
                                                              Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1807 & 65535))];
                                                              _2689 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1896, _1900), 0.0f);
                                                              _2703 = mad(saturate(((log2(_1905 * _1792) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                              _2704 = max(9.999999747378752e-06f, _2682.x);
                                                              _2705 = _2689.x / _2704;
                                                              _2706 = _2689.y / _2704;
                                                              _2708 = _2689.w / _2704;
                                                              _2713 = ((0.375f - _2706) * 4.999999873689376e-06f) + _2706;
                                                              _2716 = -0.0f - _2705;
                                                              _2717 = mad(_2716, _2713, (_2689.z / _2704));
                                                              _2719 = 1.0f / mad(_2716, _2705, _2713);
                                                              _2720 = _2719 * _2717;
                                                              _2725 = _2703 - _2705;
                                                              _2730 = (((_2703 * _2703) - _2713) - (_2720 * _2725)) / mad((-0.0f - _2717), _2720, mad((-0.0f - _2713), _2713, (((0.375f - _2708) * 4.999999873689376e-06f) + _2708)));
                                                              _2732 = (_2719 * _2725) - (_2730 * _2720);
                                                              _2735 = 1.0f / _2730;
                                                              _2736 = _2732 * _2735;
                                                              _2741 = sqrt(((_2736 * _2736) * 0.25f) - ((1.0f - dot(float2(_2732, _2730), float2(_2705, _2713))) * _2735));
                                                              _2743 = (_2736 * -0.5f) - _2741;
                                                              _2745 = _2741 - (_2736 * 0.5f);
                                                              _2747 = select((_2743 < _2703), 1.0f, 0.0f);
                                                              _2752 = (_2747 + -0.05000000074505806f) / (_2743 - _2703);
                                                              _2758 = (((select((_2745 < _2703), 1.0f, 0.0f) - _2747) / (_2745 - _2743)) - _2752) / (_2745 - _2703);
                                                              _2760 = _2752 - (_2758 * _2743);
                                                              _2773 = (exp2((_2682.x * -1.4426950216293335f) * saturate((dot(float2(_2705, _2713), float2((_2760 - (_2758 * _2703)), _2758)) + 0.05000000074505806f) - (_2760 * _2703))) * _2676);
                                                            } else {
                                                              _2773 = _2676;
                                                            }
                                                          } else {
                                                            _2773 = _2676;
                                                          }
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    }
                                                    do {
                                                      _2794 = _1839;
                                                      _2795 = _1840;
                                                      _2796 = _1842;
                                                      [branch]
                                                      if (!(_1851 == 0)) {
                                                        Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1851)))];
                                                        _2786 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1896 * f16tof32(((uint)((uint)(_1825) >> 16)))) + f16tof32(((uint)((uint)(_1828) >> 16)))), ((_1900 * f16tof32(_1825)) + f16tof32(_1828))), 0.0f);
                                                        _2794 = (_2786.x * _1839);
                                                        _2795 = (_2786.y * _1840);
                                                        _2796 = (_2786.z * _1842);
                                                      }
                                                      _2797 = _2773 * _1934;
                                                      [branch]
                                                      if (!(_2797 == 0.0f)) {
                                                        do {
                                                          _2815 = GetDeferredSoftShadowChannel(_1597);
                                                          if (_2815 < 0) {
                                                                _2836 = _2797;
                                                                do {
                                                                  _9262 = _1582;
                                                                  _9263 = _1583;
                                                                  _9264 = _1584;
                                                                  _9265 = _1585;
                                                                  _9266 = _1586;
                                                                  _9267 = _1587;
                                                                  [branch]
                                                                  if (!(_2836 == 0.0f)) {
                                                                    do {
                                                                      _2875 = _2836;
                                                                      [branch]
                                                                      if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                        _2846 = srvLightMappingData[_1597];
                                                                        if (!(_2846 == -1)) {
                                                                          _2851 = srvLightIndexData[_2846].nLayerIndex;
                                                                          _2853 = srvLightIndexData[_2846].vAtlasOrigin.x;
                                                                          _2854 = srvLightIndexData[_2846].vAtlasOrigin.y;
                                                                          _2856 = srvLightIndexData[_2846].vScreenOrigin.x;
                                                                          _2857 = srvLightIndexData[_2846].vScreenOrigin.y;
                                                                          _2866 = ((int)(_2851 * 5)) & 31;
                                                                          _2875 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2853 + _63) - _2856)), ((int)((_2854 + _64) - _2857)), 0)))).x) & ((int)(31 << _2866)))) >> _2866)) >> 1)))) * 0.06666667014360428f) * _2836);
                                                                        } else {
                                                                          _2875 = _2836;
                                                                        }
                                                                      }
                                                                      _2879 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                      _2882 = select(_2879, (_2875 * _1274), _2875);
                                                                      _2884 = dot(float3(_1787, _1788, _1789), float3(_1787, _1788, _1789));
                                                                      _2885 = rsqrt(_2884);
                                                                      _2886 = _2885 * _1787;
                                                                      _2887 = _2885 * _1788;
                                                                      _2888 = _2885 * _1789;
                                                                      _2889 = dot(float3(_197, _198, _199), float3(_2886, _2887, _2888));
                                                                      do {
                                                                        _2907 = _2889;
                                                                        if (_1848 > 0.0f) {
                                                                          _2897 = sqrt(saturate((_1848 * _1848) * (1.0f / (_2884 + 1.0f))));
                                                                          if (_2889 < _2897) {
                                                                            _2902 = max(_2889, (-0.0f - _2897)) + _2897;
                                                                            _2907 = ((_2902 * _2902) / (_2897 * 4.0f));
                                                                          } else {
                                                                            _2907 = _2889;
                                                                          }
                                                                        }
                                                                        _2908 = _219 * _219;
                                                                        _2912 = saturate((_1848 * (1.0f - _2908)) * _2885);
                                                                        _2914 = saturate(_2885 * f16tof32(_1801));
                                                                        _2915 = dot(float3(_445, _446, _444), float3(_2886, _2887, _2888));
                                                                        _2918 = rsqrt((_2915 * 2.0f) + 2.0f);
                                                                        _2921 = saturate(_2918 * (_1131 + _2889));
                                                                        _2925 = (_2912 > 0.0f);
                                                                        do {
                                                                          _3016 = saturate((_2918 * _2915) + _2918);
                                                                          _3017 = _2921;
                                                                          if (_2925) {
                                                                            _2929 = sqrt(1.0f - (_2912 * _2912));
                                                                            _2931 = (_2889 * 2.0f) * _1131;
                                                                            _2932 = _2931 - _2915;
                                                                            if (!(!(_2932 >= _2929))) {
                                                                              _3016 = abs(_1131);
                                                                              _3017 = 1.0f;
                                                                            } else {
                                                                              _2940 = rsqrt(1.0f - (_2932 * _2932)) * _2912;
                                                                              _2943 = _2940 * (_1131 - (_2932 * _2889));
                                                                              _2944 = _1131 * _1131;
                                                                              _2949 = _2940 * (((_2944 * 2.0f) + -1.0f) - (_2932 * _2915));
                                                                              _2958 = sqrt(saturate((((1.0f - (_2889 * _2889)) - _2944) - (_2915 * _2915)) + (_2931 * _2915)));
                                                                              _2959 = _2958 * _2940;
                                                                              _2962 = ((_1131 * 2.0f) * _2940) * _2958;
                                                                              _2964 = (_2929 * _2889) + _1131;
                                                                              _2965 = _2964 + _2943;
                                                                              _2966 = _2929 * _2915;
                                                                              _2968 = (_2966 + 1.0f) + _2949;
                                                                              _2969 = _2959 * _2968;
                                                                              _2970 = _2965 * _2968;
                                                                              _2971 = _2962 * _2965;
                                                                              _2976 = (((_2965 * 0.25f) * _2962) - (_2969 * 0.5f)) * _2970;
                                                                              _2990 = (((_2971 - (_2969 * 2.0f)) * _2971) + (_2969 * _2969)) + ((((-0.5f - ((_2968 + _2966) * 0.5f)) * _2970) + ((_2968 * _2968) * _2964)) * _2965);
                                                                              _2995 = (_2976 * 2.0f) / ((_2990 * _2990) + (_2976 * _2976));
                                                                              _2996 = _2990 * _2995;
                                                                              _2998 = 1.0f - (_2976 * _2995);
                                                                              _3004 = ((_2996 * _2962) + _2966) + (_2998 * _2949);
                                                                              _3007 = rsqrt((_3004 * 2.0f) + 2.0f);
                                                                              _3016 = saturate((_3004 * _3007) + _3007);
                                                                              _3017 = saturate(((_2964 + (_2996 * _2959)) + (_2998 * _2943)) * _3007);
                                                                            }
                                                                          }
                                                                          _3018 = saturate(_2907);
                                                                          _3019 = saturate(_2889);
                                                                          _3020 = _2908 * _2908;
                                                                          do {
                                                                            _3030 = _3020;
                                                                            if (_2914 > 0.0f) {
                                                                              _3030 = saturate(((_2914 * _2914) / ((_3016 * 3.5999999046325684f) + 0.4000000059604645f)) + _3020);
                                                                            }
                                                                            _3031 = sqrt(_3030);
                                                                            do {
                                                                              _3042 = 1.0f;
                                                                              if (_2925) {
                                                                                _3042 = (_3030 / ((((_2912 * 0.25f) * ((_3031 * 3.0f) + _2912)) / (_3016 + 0.0010000000474974513f)) + _3030));
                                                                              }
                                                                              _3046 = (((_3030 * _3017) - _3017) * _3017) + 1.0f;
                                                                              _3049 = (_3030 / (_3046 * _3046)) * _3042;
                                                                              _3057 = exp2(log2(1.0f - saturate(_3016)) * 5.0f);
                                                                              _3061 = (_3057 * (1.0f - _212)) + _212;
                                                                              _3062 = (_3057 * (1.0f - _213)) + _213;
                                                                              _3063 = (_3057 * (1.0f - _214)) + _214;
                                                                              _3066 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                                              _3067 = 1.0f - _3031;
                                                                              _3075 = 0.5f / ((((_3067 * _3066) + _3031) * _3018) + (((_3067 * _3018) + _3031) * _3066));
                                                                              do {
                                                                                if (_217 < 0.007874015718698502f) {
                                                                                  _3081 = _3017 * _3017;
                                                                                  _3083 = max((1.0f - _3081), 9.999999747378752e-05f);
                                                                                  _3221 = (((((((exp2(((-0.0f - (_3081 / _3083)) / _3030) * 1.4426950216293335f) * 4.0f) / (_3083 * _3083)) + 1.0f) * (1.0f / ((_3030 * 4.0f) + 1.0f))) - _3049) * _168) + _3049);
                                                                                  _3222 = (((saturate(0.25f / ((_3019 + _1132) - (_3019 * _1132))) - _3075) * _168) + _3075);
                                                                                } else {
                                                                                  _3107 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                                  _3108 = _3107 * _197;
                                                                                  _3109 = _3107 * _198;
                                                                                  _3110 = _3107 * _199;
                                                                                  _3113 = (abs(_3108) < abs(_3109));
                                                                                  _3114 = select(_3113, 1.0f, 0.0f);
                                                                                  _3115 = select(_3113, 0.0f, 1.0f);
                                                                                  _3116 = _3115 * _3110;
                                                                                  _3118 = -0.0f - (_3110 * _3114);
                                                                                  _3121 = (_3114 * _3109) - (_3115 * _3108);
                                                                                  _3123 = rsqrt(dot(float3(_3116, _3118, _3121), float3(_3116, _3118, _3121)));
                                                                                  _3124 = _3116 * _3123;
                                                                                  _3125 = _3123 * _3118;
                                                                                  _3126 = _3121 * _3123;
                                                                                  _3129 = (_3125 * _3110) - (_3126 * _3109);
                                                                                  _3132 = (_3126 * _3108) - (_3124 * _3110);
                                                                                  _3135 = (_3124 * _3109) - (_3125 * _3108);
                                                                                  _3137 = rsqrt(dot(float3(_3129, _3132, _3135), float3(_3129, _3132, _3135)));
                                                                                  _3141 = _168 * 4.0f;
                                                                                  _3150 = saturate(abs(_3141 + -2.5f) + -0.5f) + -0.5f;
                                                                                  _3151 = saturate(1.5f - abs(_3141 + -1.5f)) + -0.5f;
                                                                                  _3153 = rsqrt(dot(float2(_3150, _3151), float2(_3150, _3151)));
                                                                                  _3154 = _3153 * _3150;
                                                                                  _3155 = _3153 * _3151;
                                                                                  _3162 = ((_3129 * _3137) * _3154) + (_3155 * _3124);
                                                                                  _3163 = ((_3132 * _3137) * _3154) + (_3155 * _3125);
                                                                                  _3164 = ((_3135 * _3137) * _3154) + (_3155 * _3126);
                                                                                  _3167 = (_3163 * _199) - (_3164 * _198);
                                                                                  _3170 = (_3164 * _197) - (_3162 * _199);
                                                                                  _3173 = (_3162 * _198) - (_3163 * _197);
                                                                                  _3174 = dot(float3(_3162, _3163, _3164), float3(_2886, _2887, _2888));
                                                                                  _3175 = dot(float3(_3162, _3163, _3164), float3(_445, _446, _444));
                                                                                  _3178 = dot(float3(_3167, _3170, _3173), float3(_2886, _2887, _2888));
                                                                                  _3179 = dot(float3(_3167, _3170, _3173), float3(_445, _446, _444));
                                                                                  _3185 = min(max((_2908 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                                  _3189 = min(max((_2908 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                                  _3190 = _3189 * _3185;
                                                                                  _3191 = ((_3175 + _3174) * _2918) * _3189;
                                                                                  _3192 = ((_3179 + _3178) * _2918) * _3185;
                                                                                  _3193 = _3190 * _2921;
                                                                                  _3194 = dot(float3(_3191, _3192, _3193), float3(_3191, _3192, _3193));
                                                                                  _3199 = _3185 * _3175;
                                                                                  _3200 = _3189 * _3179;
                                                                                  _3208 = _3185 * _3174;
                                                                                  _3209 = _3189 * _3178;
                                                                                  _3221 = (((_3190 * _3190) * _3190) / (_3194 * _3194));
                                                                                  _3222 = saturate(0.5f / ((sqrt(((_3208 * _3208) + (_3019 * _3019)) + (_3209 * _3209)) * _3066) + (sqrt(((_3200 * _3200) + (_3199 * _3199)) + (_3066 * _3066)) * _3019)));
                                                                                }
                                                                                _3224 = (_3221 * _3019) * _3222;
                                                                                _3239 = saturate((_2889 + 0.5f) * 0.6666666865348816f);
                                                                                _3246 = _2794 * _1645;
                                                                                _3247 = _2795 * _1645;
                                                                                _3248 = _2796 * _1645;
                                                                                _3261 = ((((_2882 * _3246) * (1.0f - _3061)) * _3239) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _3019)) + _1582;
                                                                                _3262 = ((((_2882 * _3247) * (1.0f - _3062)) * _3239) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _3019)) + _1583;
                                                                                _3263 = ((((_2882 * _3248) * (1.0f - _3063)) * _3239) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _3019)) + _1584;
                                                                                if (_1846 > 0.0f) {
                                                                                  _3266 = (_1846 * _1347) * select(_2879, (_2875 * _1274), _2875);
                                                                                  _9262 = _3261;
                                                                                  _9263 = _3262;
                                                                                  _9264 = _3263;
                                                                                  _9265 = ((((_3266 * _3246) * _3061) * _3224) + _1585);
                                                                                  _9266 = ((((_3266 * _3247) * _3062) * _3224) + _1586);
                                                                                  _9267 = ((((_3266 * _3248) * _3063) * _3224) + _1587);
                                                                                } else {
                                                                                  _9262 = _3261;
                                                                                  _9263 = _3262;
                                                                                  _9264 = _3263;
                                                                                  _9265 = _1585;
                                                                                  _9266 = _1586;
                                                                                  _9267 = _1587;
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
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                            // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                            break;
                                                          }
                                                          _2818 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                                          do {
                                                            if (_2815 == 0) {
                                                              _2832 = _2818.x;
                                                            } else {
                                                              if (_2815 == 1) {
                                                                _2832 = _2818.y;
                                                              } else {
                                                                if (_2815 == 2) {
                                                                  _2832 = _2818.z;
                                                                } else {
                                                                  _2832 = _2818.w;
                                                                }
                                                              }
                                                            }
                                                            _2836 = ((_2832 * _2832) * _1934);
                                                            [branch]
                                                            if (!(_2836 == 0.0f)) {
                                                              do {
                                                                _2875 = _2836;
                                                                [branch]
                                                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                  _2846 = srvLightMappingData[_1597];
                                                                  if (!(_2846 == -1)) {
                                                                    _2851 = srvLightIndexData[_2846].nLayerIndex;
                                                                    _2853 = srvLightIndexData[_2846].vAtlasOrigin.x;
                                                                    _2854 = srvLightIndexData[_2846].vAtlasOrigin.y;
                                                                    _2856 = srvLightIndexData[_2846].vScreenOrigin.x;
                                                                    _2857 = srvLightIndexData[_2846].vScreenOrigin.y;
                                                                    _2866 = ((int)(_2851 * 5)) & 31;
                                                                    _2875 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2853 + _63) - _2856)), ((int)((_2854 + _64) - _2857)), 0)))).x) & ((int)(31 << _2866)))) >> _2866)) >> 1)))) * 0.06666667014360428f) * _2836);
                                                                  } else {
                                                                    _2875 = _2836;
                                                                  }
                                                                }
                                                                _2879 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                _2882 = select(_2879, (_2875 * _1274), _2875);
                                                                _2884 = dot(float3(_1787, _1788, _1789), float3(_1787, _1788, _1789));
                                                                _2885 = rsqrt(_2884);
                                                                _2886 = _2885 * _1787;
                                                                _2887 = _2885 * _1788;
                                                                _2888 = _2885 * _1789;
                                                                _2889 = dot(float3(_197, _198, _199), float3(_2886, _2887, _2888));
                                                                do {
                                                                  _2907 = _2889;
                                                                  if (_1848 > 0.0f) {
                                                                    _2897 = sqrt(saturate((_1848 * _1848) * (1.0f / (_2884 + 1.0f))));
                                                                    if (_2889 < _2897) {
                                                                      _2902 = max(_2889, (-0.0f - _2897)) + _2897;
                                                                      _2907 = ((_2902 * _2902) / (_2897 * 4.0f));
                                                                    } else {
                                                                      _2907 = _2889;
                                                                    }
                                                                  }
                                                                  _2908 = _219 * _219;
                                                                  _2912 = saturate((_1848 * (1.0f - _2908)) * _2885);
                                                                  _2914 = saturate(_2885 * f16tof32(_1801));
                                                                  _2915 = dot(float3(_445, _446, _444), float3(_2886, _2887, _2888));
                                                                  _2918 = rsqrt((_2915 * 2.0f) + 2.0f);
                                                                  _2921 = saturate(_2918 * (_1131 + _2889));
                                                                  _2925 = (_2912 > 0.0f);
                                                                  do {
                                                                    _3016 = saturate((_2918 * _2915) + _2918);
                                                                    _3017 = _2921;
                                                                    if (_2925) {
                                                                      _2929 = sqrt(1.0f - (_2912 * _2912));
                                                                      _2931 = (_2889 * 2.0f) * _1131;
                                                                      _2932 = _2931 - _2915;
                                                                      if (!(!(_2932 >= _2929))) {
                                                                        _3016 = abs(_1131);
                                                                        _3017 = 1.0f;
                                                                      } else {
                                                                        _2940 = rsqrt(1.0f - (_2932 * _2932)) * _2912;
                                                                        _2943 = _2940 * (_1131 - (_2932 * _2889));
                                                                        _2944 = _1131 * _1131;
                                                                        _2949 = _2940 * (((_2944 * 2.0f) + -1.0f) - (_2932 * _2915));
                                                                        _2958 = sqrt(saturate((((1.0f - (_2889 * _2889)) - _2944) - (_2915 * _2915)) + (_2931 * _2915)));
                                                                        _2959 = _2958 * _2940;
                                                                        _2962 = ((_1131 * 2.0f) * _2940) * _2958;
                                                                        _2964 = (_2929 * _2889) + _1131;
                                                                        _2965 = _2964 + _2943;
                                                                        _2966 = _2929 * _2915;
                                                                        _2968 = (_2966 + 1.0f) + _2949;
                                                                        _2969 = _2959 * _2968;
                                                                        _2970 = _2965 * _2968;
                                                                        _2971 = _2962 * _2965;
                                                                        _2976 = (((_2965 * 0.25f) * _2962) - (_2969 * 0.5f)) * _2970;
                                                                        _2990 = (((_2971 - (_2969 * 2.0f)) * _2971) + (_2969 * _2969)) + ((((-0.5f - ((_2968 + _2966) * 0.5f)) * _2970) + ((_2968 * _2968) * _2964)) * _2965);
                                                                        _2995 = (_2976 * 2.0f) / ((_2990 * _2990) + (_2976 * _2976));
                                                                        _2996 = _2990 * _2995;
                                                                        _2998 = 1.0f - (_2976 * _2995);
                                                                        _3004 = ((_2996 * _2962) + _2966) + (_2998 * _2949);
                                                                        _3007 = rsqrt((_3004 * 2.0f) + 2.0f);
                                                                        _3016 = saturate((_3004 * _3007) + _3007);
                                                                        _3017 = saturate(((_2964 + (_2996 * _2959)) + (_2998 * _2943)) * _3007);
                                                                      }
                                                                    }
                                                                    _3018 = saturate(_2907);
                                                                    _3019 = saturate(_2889);
                                                                    _3020 = _2908 * _2908;
                                                                    do {
                                                                      _3030 = _3020;
                                                                      if (_2914 > 0.0f) {
                                                                        _3030 = saturate(((_2914 * _2914) / ((_3016 * 3.5999999046325684f) + 0.4000000059604645f)) + _3020);
                                                                      }
                                                                      _3031 = sqrt(_3030);
                                                                      do {
                                                                        _3042 = 1.0f;
                                                                        if (_2925) {
                                                                          _3042 = (_3030 / ((((_2912 * 0.25f) * ((_3031 * 3.0f) + _2912)) / (_3016 + 0.0010000000474974513f)) + _3030));
                                                                        }
                                                                        _3046 = (((_3030 * _3017) - _3017) * _3017) + 1.0f;
                                                                        _3049 = (_3030 / (_3046 * _3046)) * _3042;
                                                                        _3057 = exp2(log2(1.0f - saturate(_3016)) * 5.0f);
                                                                        _3061 = (_3057 * (1.0f - _212)) + _212;
                                                                        _3062 = (_3057 * (1.0f - _213)) + _213;
                                                                        _3063 = (_3057 * (1.0f - _214)) + _214;
                                                                        _3066 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                                        _3067 = 1.0f - _3031;
                                                                        _3075 = 0.5f / ((((_3067 * _3066) + _3031) * _3018) + (((_3067 * _3018) + _3031) * _3066));
                                                                        do {
                                                                          if (_217 < 0.007874015718698502f) {
                                                                            _3081 = _3017 * _3017;
                                                                            _3083 = max((1.0f - _3081), 9.999999747378752e-05f);
                                                                            _3221 = (((((((exp2(((-0.0f - (_3081 / _3083)) / _3030) * 1.4426950216293335f) * 4.0f) / (_3083 * _3083)) + 1.0f) * (1.0f / ((_3030 * 4.0f) + 1.0f))) - _3049) * _168) + _3049);
                                                                            _3222 = (((saturate(0.25f / ((_3019 + _1132) - (_3019 * _1132))) - _3075) * _168) + _3075);
                                                                          } else {
                                                                            _3107 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                            _3108 = _3107 * _197;
                                                                            _3109 = _3107 * _198;
                                                                            _3110 = _3107 * _199;
                                                                            _3113 = (abs(_3108) < abs(_3109));
                                                                            _3114 = select(_3113, 1.0f, 0.0f);
                                                                            _3115 = select(_3113, 0.0f, 1.0f);
                                                                            _3116 = _3115 * _3110;
                                                                            _3118 = -0.0f - (_3110 * _3114);
                                                                            _3121 = (_3114 * _3109) - (_3115 * _3108);
                                                                            _3123 = rsqrt(dot(float3(_3116, _3118, _3121), float3(_3116, _3118, _3121)));
                                                                            _3124 = _3116 * _3123;
                                                                            _3125 = _3123 * _3118;
                                                                            _3126 = _3121 * _3123;
                                                                            _3129 = (_3125 * _3110) - (_3126 * _3109);
                                                                            _3132 = (_3126 * _3108) - (_3124 * _3110);
                                                                            _3135 = (_3124 * _3109) - (_3125 * _3108);
                                                                            _3137 = rsqrt(dot(float3(_3129, _3132, _3135), float3(_3129, _3132, _3135)));
                                                                            _3141 = _168 * 4.0f;
                                                                            _3150 = saturate(abs(_3141 + -2.5f) + -0.5f) + -0.5f;
                                                                            _3151 = saturate(1.5f - abs(_3141 + -1.5f)) + -0.5f;
                                                                            _3153 = rsqrt(dot(float2(_3150, _3151), float2(_3150, _3151)));
                                                                            _3154 = _3153 * _3150;
                                                                            _3155 = _3153 * _3151;
                                                                            _3162 = ((_3129 * _3137) * _3154) + (_3155 * _3124);
                                                                            _3163 = ((_3132 * _3137) * _3154) + (_3155 * _3125);
                                                                            _3164 = ((_3135 * _3137) * _3154) + (_3155 * _3126);
                                                                            _3167 = (_3163 * _199) - (_3164 * _198);
                                                                            _3170 = (_3164 * _197) - (_3162 * _199);
                                                                            _3173 = (_3162 * _198) - (_3163 * _197);
                                                                            _3174 = dot(float3(_3162, _3163, _3164), float3(_2886, _2887, _2888));
                                                                            _3175 = dot(float3(_3162, _3163, _3164), float3(_445, _446, _444));
                                                                            _3178 = dot(float3(_3167, _3170, _3173), float3(_2886, _2887, _2888));
                                                                            _3179 = dot(float3(_3167, _3170, _3173), float3(_445, _446, _444));
                                                                            _3185 = min(max((_2908 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                            _3189 = min(max((_2908 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                            _3190 = _3189 * _3185;
                                                                            _3191 = ((_3175 + _3174) * _2918) * _3189;
                                                                            _3192 = ((_3179 + _3178) * _2918) * _3185;
                                                                            _3193 = _3190 * _2921;
                                                                            _3194 = dot(float3(_3191, _3192, _3193), float3(_3191, _3192, _3193));
                                                                            _3199 = _3185 * _3175;
                                                                            _3200 = _3189 * _3179;
                                                                            _3208 = _3185 * _3174;
                                                                            _3209 = _3189 * _3178;
                                                                            _3221 = (((_3190 * _3190) * _3190) / (_3194 * _3194));
                                                                            _3222 = saturate(0.5f / ((sqrt(((_3208 * _3208) + (_3019 * _3019)) + (_3209 * _3209)) * _3066) + (sqrt(((_3200 * _3200) + (_3199 * _3199)) + (_3066 * _3066)) * _3019)));
                                                                          }
                                                                          _3224 = (_3221 * _3019) * _3222;
                                                                          _3239 = saturate((_2889 + 0.5f) * 0.6666666865348816f);
                                                                          _3246 = _2794 * _1645;
                                                                          _3247 = _2795 * _1645;
                                                                          _3248 = _2796 * _1645;
                                                                          _3261 = ((((_2882 * _3246) * (1.0f - _3061)) * _3239) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _3019)) + _1582;
                                                                          _3262 = ((((_2882 * _3247) * (1.0f - _3062)) * _3239) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _3019)) + _1583;
                                                                          _3263 = ((((_2882 * _3248) * (1.0f - _3063)) * _3239) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _3019)) + _1584;
                                                                          if (_1846 > 0.0f) {
                                                                            _3266 = (_1846 * _1347) * select(_2879, (_2875 * _1274), _2875);
                                                                            _9262 = _3261;
                                                                            _9263 = _3262;
                                                                            _9264 = _3263;
                                                                            _9265 = ((((_3266 * _3246) * _3061) * _3224) + _1585);
                                                                            _9266 = ((((_3266 * _3247) * _3062) * _3224) + _1586);
                                                                            _9267 = ((((_3266 * _3248) * _3063) * _3224) + _1587);
                                                                          } else {
                                                                            _9262 = _3261;
                                                                            _9263 = _3262;
                                                                            _9264 = _3263;
                                                                            _9265 = _1585;
                                                                            _9266 = _1586;
                                                                            _9267 = _1587;
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
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } else {
                                                              _9262 = _1582;
                                                              _9263 = _1583;
                                                              _9264 = _1584;
                                                              _9265 = _1585;
                                                              _9266 = _1586;
                                                              _9267 = _1587;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        _9262 = _1582;
                                                        _9263 = _1583;
                                                        _9264 = _1584;
                                                        _9265 = _1585;
                                                        _9266 = _1586;
                                                        _9267 = _1587;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                } else {
                                                  if (_1628 == 7) {
                                                    _3890 = asfloat(srvLightInfoProperties.Load3(_1596)).x;
                                                    _3891 = asfloat(srvLightInfoProperties.Load3(_1596)).y;
                                                    _3892 = asfloat(srvLightInfoProperties.Load3(_1596)).z;
                                                    _3895 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 12u)))).x;
                                                    _3896 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 12u)))).y;
                                                    _3897 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 12u)))).z;
                                                    _3900 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 24u)))).x;
                                                    _3901 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 24u)))).y;
                                                    _3902 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 24u)))).z;
                                                    _3905 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 36u)))).x;
                                                    _3906 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 36u)))).y;
                                                    _3907 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 36u)))).z;
                                                    _3910 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).x;
                                                    _3911 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).y;
                                                    _3912 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 48u)))).z;
                                                    _3915 = asint(srvLightInfoProperties.Load(((int)(_1596 + 60u))));
                                                    _3918 = asint(srvLightInfoProperties.Load(((int)(_1596 + 64u))));
                                                    _3921 = asint(srvLightInfoProperties.Load(((int)(_1596 + 72u))));
                                                    _3924 = asint(srvLightInfoProperties.Load(((int)(_1596 + 76u))));
                                                    _3927 = asint(srvLightInfoProperties.Load(((int)(_1596 + 80u))));
                                                    _3930 = asint(srvLightInfoProperties.Load(((int)(_1596 + 84u))));
                                                    _3933 = asint(srvLightInfoProperties.Load(((int)(_1596 + 88u))));
                                                    _3936 = asint(srvLightInfoProperties.Load(((int)(_1596 + 92u))));
                                                    _3939 = asint(srvLightInfoProperties.Load(((int)(_1596 + 96u))));
                                                    _3942 = asint(srvLightInfoProperties.Load(((int)(_1596 + 100u))));
                                                    _3945 = asint(srvLightInfoProperties.Load(((int)(_1596 + 104u))));
                                                    _3948 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).x;
                                                    _3949 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).y;
                                                    _3950 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).z;
                                                    _3951 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).w;
                                                    _3954 = asint(srvLightInfoProperties.Load(((int)(_1596 + 124u))));
                                                    _3957 = asint(srvLightInfoProperties.Load(((int)(_1596 + 128u))));
                                                    _3960 = asint(srvLightInfoProperties.Load(((int)(_1596 + 136u))));
                                                    _3963 = asint(srvLightInfoProperties.Load(((int)(_1596 + 140u))));
                                                    _3965 = f16tof32(((uint)((uint)(_3915) >> 16)));
                                                    _3966 = f16tof32(_3915);
                                                    _3968 = f16tof32(((uint)((uint)(_3918) >> 16)));
                                                    _3972 = ((float)((uint)((uint)(((uint)(_3918) >> 8) & 255)))) * 0.003921499941498041f;
                                                    _3973 = f16tof32(_3921);
                                                    _3975 = f16tof32(((uint)((uint)(_3924) >> 16)));
                                                    _3979 = f16tof32(_3927);
                                                    _3981 = f16tof32(((uint)((uint)(_3930) >> 16)));
                                                    _3982 = f16tof32(_3930);
                                                    _3984 = f16tof32(((uint)((uint)(_3933) >> 16)));
                                                    _3987 = _3936 & 65535;
                                                    _3991 = ((_1594 & 4194304) != 0);
                                                    _3999 = f16tof32(((uint)((uint)(_3945) >> 16)));
                                                    _4000 = f16tof32(_3945);
                                                    _4002 = f16tof32(((uint)((uint)(_3954) >> 16)));
                                                    _4005 = f16tof32(((uint)((uint)(_3957) >> 16)));
                                                    _4006 = f16tof32(_3957);
                                                    _4008 = f16tof32(((uint)((uint)(_3960) >> 16)));
                                                    _4009 = _4008 + -1.0f;
                                                    do {
                                                      if (_3991) {
                                                        _4011 = 0.5f / _4008;
                                                        _4012 = 0.3333333432674408f / _4008;
                                                        _4016 = (_4008 * 0.5f) + 0.5f;
                                                        _4026 = (_4011 * _4009);
                                                        _4027 = (_4012 * _4009);
                                                        _4028 = (_4011 * _4016);
                                                        _4029 = (_4012 * _4016);
                                                        _4030 = (_4008 * 2.0f);
                                                        _4031 = (_4008 * 3.0f);
                                                      } else {
                                                        _4022 = 1.0f / _4008;
                                                        _4023 = _4022 * _4009;
                                                        _4024 = _4022 * 0.5f;
                                                        _4026 = _4023;
                                                        _4027 = _4023;
                                                        _4028 = _4024;
                                                        _4029 = _4024;
                                                        _4030 = _4008;
                                                        _4031 = _4008;
                                                      }
                                                      _4035 = _3905 - _231;
                                                      _4036 = _3906 - _232;
                                                      _4037 = _3907 + _230;
                                                      _4038 = dot(float3(_4035, _4036, _4037), float3(_4035, _4036, _4037));
                                                      _4039 = rsqrt(_4038);
                                                      _4040 = _4039 * _4038;
                                                      _4041 = _4039 * _4035;
                                                      _4042 = _4039 * _4036;
                                                      _4043 = _4039 * _4037;
                                                      _4046 = max(0.0f, (_4040 - abs(_3979)));
                                                      _4047 = _4046 * f16tof32(((uint)((uint)(_3927) >> 16)));
                                                      _4048 = _4047 * _4047;
                                                      _4051 = saturate(1.0f - (_4048 * _4048));
                                                      _4058 = (_4051 * _4051) / (select((_3979 < 0.0f), (_4048 * 16.0f), (_4046 * _4046)) + 1.0f);
                                                      _4071 = saturate(1.0f - dot(float3(_197, _198, _199), float3(_4041, _4042, _4043))) * f16tof32(_3954);
                                                      _4075 = abs(_4037);
                                                      _4079 = _4035 - ((_4071 * _197) * _4075);
                                                      _4080 = _4036 - ((_4071 * _198) * _4075);
                                                      _4081 = _4037 - ((_4071 * _199) * _4075);
                                                      _4084 = mad(_4081, _3901, mad(_4080, _3896, (_4079 * _3891)));
                                                      _4087 = mad(_4081, _3902, mad(_4080, _3897, (_4079 * _3892)));
                                                      _4089 = ((_1594 & 3584) != 0);
                                                      do {
                                                        _5880 = _4058;
                                                        _5881 = 1.0f;
                                                        if (_4089 && (_4058 > 0.0f)) {
                                                          _4095 = mad(_4081, _3900, mad(_4080, _3895, (_4079 * _3890)));
                                                          _4096 = -0.0f - _4087;
                                                          _4097 = -0.0f - _4084;
                                                          do {
                                                            _4886 = 1.0f;
                                                            _4887 = 1.0f;
                                                            _4888 = 0;
                                                            [branch]
                                                            if (!((_1594 & 1024) == 0)) {
                                                              Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3936) >> 16))];
                                                              [branch]
                                                              if (_3991) {
                                                                _4102 = abs(_4095);
                                                                _4103 = abs(_4096);
                                                                _4104 = abs(_4097);
                                                                do {
                                                                  if (_4102 > max(_4103, _4104)) {
                                                                    _4108 = (_4095 > 0.0f);
                                                                    _4123 = select(_4108, 0.0f, 1.0f);
                                                                    _4124 = 0.0f;
                                                                    _4125 = select(_4108, _4084, _4097);
                                                                    _4126 = _4087;
                                                                    _4127 = _4102;
                                                                  } else {
                                                                    if (_4103 > _4104) {
                                                                      _4114 = (_4087 < -0.0f);
                                                                      _4123 = select(_4114, 0.0f, 1.0f);
                                                                      _4124 = 1.0f;
                                                                      _4125 = _4095;
                                                                      _4126 = select(_4114, _4097, _4084);
                                                                      _4127 = _4103;
                                                                    } else {
                                                                      _4118 = (_4084 < -0.0f);
                                                                      _4123 = select(_4118, 0.0f, 1.0f);
                                                                      _4124 = 2.0f;
                                                                      _4125 = select(_4118, _4095, (-0.0f - _4095));
                                                                      _4126 = _4087;
                                                                      _4127 = _4104;
                                                                    }
                                                                  }
                                                                  _4128 = _4127 * 2.0f;
                                                                  _4132 = -0.0f - _4000;
                                                                  _4141 = ((min(max((_4125 / _4128), _4132), _4000) + _4123) * _4026) + _4028;
                                                                  _4142 = ((min(max((_4126 / _4128), _4132), _4000) + _4124) * _4027) + _4029;
                                                                  _4149 = ((_4123 + -0.5f) * _4026) + _4028;
                                                                  _4150 = ((_4124 + -0.5f) * _4027) + _4029;
                                                                  _4153 = saturate((_4002 + 1.0f) - (_4127 * _3984));
                                                                  _4157 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _4166 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 2u);
                                                                  } else {
                                                                    _4166 = frac(frac(dot(float2(((_4157 * 32.665000915527344f) + _125), ((_4157 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _4166 = frac(frac(dot(float2(((_4157 * 32.665000915527344f) + _125), ((_4157 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _4167 = sin(_4166);
                                                                  _4168 = cos(_4166);
                                                                  _4173 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_4141, _4142), 0.0f))).x) > _4153), 1.0f, 0.0f);
                                                                  _4174 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _4179 = sqrt((float((int)(_4174)) * 0.25f) + 0.125f) * _4005;
                                                                  _4188 = (_global_7[min((uint)(((int)(0u + (_4174 * 2)))), 127u)]) * _4179;
                                                                  _4189 = (_global_7[min((uint)(((int)(1u + (_4174 * 2)))), 127u)]) * _4179;
                                                                  _4191 = -0.0f - _4167;
                                                                  _4193 = dot(float2(_4188, _4189), float2(_4168, _4167)) + _4141;
                                                                  _4194 = dot(float2(_4188, _4189), float2(_4191, _4168)) + _4142;
                                                                  _4196 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4193, _4194));
                                                                  _4200 = _4193 * _4030;
                                                                  _4201 = _4194 * _4031;
                                                                  _4204 = floor(_4149 * _4030);
                                                                  _4205 = floor(_4150 * _4031);
                                                                  _4210 = floor(((_4149 + _4026) * _4030) + 0.5f);
                                                                  _4211 = floor(((_4150 + _4027) * _4031) + 0.5f);
                                                                  _4214 = floor(_4200 + -0.5f);
                                                                  _4215 = floor(_4201 + 0.5f);
                                                                  _4217 = floor(_4200 + 0.5f);
                                                                  _4219 = floor(_4201 + -0.5f);
                                                                  _4220 = (_4214 < _4204);
                                                                  _4221 = (_4215 < _4205);
                                                                  do {
                                                                    if (!(_4220 || _4221)) {
                                                                      if ((_4214 >= _4210) || (_4215 >= _4211)) {
                                                                        _4230 = _4173;
                                                                      } else {
                                                                        _4230 = _4196.x;
                                                                      }
                                                                    } else {
                                                                      _4230 = _4173;
                                                                    }
                                                                    _4231 = (_4217 < _4204);
                                                                    do {
                                                                      if (!(_4231 || _4221)) {
                                                                        if ((_4217 >= _4210) || (_4215 >= _4211)) {
                                                                          _4239 = _4173;
                                                                        } else {
                                                                          _4239 = _4196.y;
                                                                        }
                                                                      } else {
                                                                        _4239 = _4173;
                                                                      }
                                                                      _4240 = (_4219 < _4205);
                                                                      do {
                                                                        if (!(_4231 || _4240)) {
                                                                          if ((_4217 >= _4210) || (_4219 >= _4211)) {
                                                                            _4248 = _4173;
                                                                          } else {
                                                                            _4248 = _4196.z;
                                                                          }
                                                                        } else {
                                                                          _4248 = _4173;
                                                                        }
                                                                        do {
                                                                          if (!(_4220 || _4240)) {
                                                                            if ((_4214 >= _4210) || (_4219 >= _4211)) {
                                                                              _4256 = _4173;
                                                                            } else {
                                                                              _4256 = _4196.w;
                                                                            }
                                                                          } else {
                                                                            _4256 = _4173;
                                                                          }
                                                                          _4257 = _4230 - _4153;
                                                                          _4259 = select((_4257 < 0.0f), 0.0f, 1.0f);
                                                                          _4261 = _4239 - _4153;
                                                                          _4263 = select((_4261 < 0.0f), 0.0f, 1.0f);
                                                                          _4267 = _4248 - _4153;
                                                                          _4269 = select((_4267 < 0.0f), 0.0f, 1.0f);
                                                                          _4273 = _4256 - _4153;
                                                                          _4275 = select((_4273 < 0.0f), 0.0f, 1.0f);
                                                                          _4282 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                          _4287 = sqrt((float((int)(_4282)) * 0.25f) + 0.125f) * _4005;
                                                                          _4296 = (_global_7[min((uint)(((int)(0u + (_4282 * 2)))), 127u)]) * _4287;
                                                                          _4297 = (_global_7[min((uint)(((int)(1u + (_4282 * 2)))), 127u)]) * _4287;
                                                                          _4300 = dot(float2(_4296, _4297), float2(_4168, _4167)) + _4141;
                                                                          _4301 = dot(float2(_4296, _4297), float2(_4191, _4168)) + _4142;
                                                                          _4303 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4300, _4301));
                                                                          _4307 = _4300 * _4030;
                                                                          _4308 = _4301 * _4031;
                                                                          _4311 = floor(_4307 + -0.5f);
                                                                          _4312 = floor(_4308 + 0.5f);
                                                                          _4314 = floor(_4307 + 0.5f);
                                                                          _4316 = floor(_4308 + -0.5f);
                                                                          _4317 = (_4311 < _4204);
                                                                          _4318 = (_4312 < _4205);
                                                                          do {
                                                                            if (!(_4317 || _4318)) {
                                                                              if ((_4311 >= _4210) || (_4312 >= _4211)) {
                                                                                _4327 = _4173;
                                                                              } else {
                                                                                _4327 = _4303.x;
                                                                              }
                                                                            } else {
                                                                              _4327 = _4173;
                                                                            }
                                                                            _4328 = (_4314 < _4204);
                                                                            do {
                                                                              if (!(_4328 || _4318)) {
                                                                                if ((_4314 >= _4210) || (_4312 >= _4211)) {
                                                                                  _4336 = _4173;
                                                                                } else {
                                                                                  _4336 = _4303.y;
                                                                                }
                                                                              } else {
                                                                                _4336 = _4173;
                                                                              }
                                                                              _4337 = (_4316 < _4205);
                                                                              do {
                                                                                if (!(_4328 || _4337)) {
                                                                                  if ((_4314 >= _4210) || (_4316 >= _4211)) {
                                                                                    _4345 = _4173;
                                                                                  } else {
                                                                                    _4345 = _4303.z;
                                                                                  }
                                                                                } else {
                                                                                  _4345 = _4173;
                                                                                }
                                                                                do {
                                                                                  if (!(_4317 || _4337)) {
                                                                                    if ((_4311 >= _4210) || (_4316 >= _4211)) {
                                                                                      _4353 = _4173;
                                                                                    } else {
                                                                                      _4353 = _4303.w;
                                                                                    }
                                                                                  } else {
                                                                                    _4353 = _4173;
                                                                                  }
                                                                                  _4354 = _4327 - _4153;
                                                                                  _4356 = select((_4354 < 0.0f), 0.0f, 1.0f);
                                                                                  _4360 = _4336 - _4153;
                                                                                  _4362 = select((_4360 < 0.0f), 0.0f, 1.0f);
                                                                                  _4366 = _4345 - _4153;
                                                                                  _4368 = select((_4366 < 0.0f), 0.0f, 1.0f);
                                                                                  _4372 = _4353 - _4153;
                                                                                  _4374 = select((_4372 < 0.0f), 0.0f, 1.0f);
                                                                                  _4381 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                  _4386 = sqrt((float((int)(_4381)) * 0.25f) + 0.125f) * _4005;
                                                                                  _4395 = (_global_7[min((uint)(((int)(0u + (_4381 * 2)))), 127u)]) * _4386;
                                                                                  _4396 = (_global_7[min((uint)(((int)(1u + (_4381 * 2)))), 127u)]) * _4386;
                                                                                  _4399 = dot(float2(_4395, _4396), float2(_4168, _4167)) + _4141;
                                                                                  _4400 = dot(float2(_4395, _4396), float2(_4191, _4168)) + _4142;
                                                                                  _4402 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4399, _4400));
                                                                                  _4406 = _4399 * _4030;
                                                                                  _4407 = _4400 * _4031;
                                                                                  _4410 = floor(_4406 + -0.5f);
                                                                                  _4411 = floor(_4407 + 0.5f);
                                                                                  _4413 = floor(_4406 + 0.5f);
                                                                                  _4415 = floor(_4407 + -0.5f);
                                                                                  _4416 = (_4410 < _4204);
                                                                                  _4417 = (_4411 < _4205);
                                                                                  do {
                                                                                    if (!(_4416 || _4417)) {
                                                                                      if ((_4410 >= _4210) || (_4411 >= _4211)) {
                                                                                        _4426 = _4173;
                                                                                      } else {
                                                                                        _4426 = _4402.x;
                                                                                      }
                                                                                    } else {
                                                                                      _4426 = _4173;
                                                                                    }
                                                                                    _4427 = (_4413 < _4204);
                                                                                    do {
                                                                                      if (!(_4427 || _4417)) {
                                                                                        if ((_4413 >= _4210) || (_4411 >= _4211)) {
                                                                                          _4435 = _4173;
                                                                                        } else {
                                                                                          _4435 = _4402.y;
                                                                                        }
                                                                                      } else {
                                                                                        _4435 = _4173;
                                                                                      }
                                                                                      _4436 = (_4415 < _4205);
                                                                                      do {
                                                                                        if (!(_4427 || _4436)) {
                                                                                          if ((_4413 >= _4210) || (_4415 >= _4211)) {
                                                                                            _4444 = _4173;
                                                                                          } else {
                                                                                            _4444 = _4402.z;
                                                                                          }
                                                                                        } else {
                                                                                          _4444 = _4173;
                                                                                        }
                                                                                        do {
                                                                                          if (!(_4416 || _4436)) {
                                                                                            if ((_4410 >= _4210) || (_4415 >= _4211)) {
                                                                                              _4452 = _4173;
                                                                                            } else {
                                                                                              _4452 = _4402.w;
                                                                                            }
                                                                                          } else {
                                                                                            _4452 = _4173;
                                                                                          }
                                                                                          _4453 = _4426 - _4153;
                                                                                          _4455 = select((_4453 < 0.0f), 0.0f, 1.0f);
                                                                                          _4459 = _4435 - _4153;
                                                                                          _4461 = select((_4459 < 0.0f), 0.0f, 1.0f);
                                                                                          _4465 = _4444 - _4153;
                                                                                          _4467 = select((_4465 < 0.0f), 0.0f, 1.0f);
                                                                                          _4471 = _4452 - _4153;
                                                                                          _4473 = select((_4471 < 0.0f), 0.0f, 1.0f);
                                                                                          _4480 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                          _4485 = sqrt((float((int)(_4480)) * 0.25f) + 0.125f) * _4005;
                                                                                          _4494 = (_global_7[min((uint)(((int)(0u + (_4480 * 2)))), 127u)]) * _4485;
                                                                                          _4495 = (_global_7[min((uint)(((int)(1u + (_4480 * 2)))), 127u)]) * _4485;
                                                                                          _4498 = dot(float2(_4494, _4495), float2(_4168, _4167)) + _4141;
                                                                                          _4499 = dot(float2(_4494, _4495), float2(_4191, _4168)) + _4142;
                                                                                          _4501 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4498, _4499));
                                                                                          _4505 = _4498 * _4030;
                                                                                          _4506 = _4499 * _4031;
                                                                                          _4509 = floor(_4505 + -0.5f);
                                                                                          _4510 = floor(_4506 + 0.5f);
                                                                                          _4512 = floor(_4505 + 0.5f);
                                                                                          _4514 = floor(_4506 + -0.5f);
                                                                                          _4515 = (_4509 < _4204);
                                                                                          _4516 = (_4510 < _4205);
                                                                                          do {
                                                                                            if (!(_4515 || _4516)) {
                                                                                              if ((_4509 >= _4210) || (_4510 >= _4211)) {
                                                                                                _4525 = _4173;
                                                                                              } else {
                                                                                                _4525 = _4501.x;
                                                                                              }
                                                                                            } else {
                                                                                              _4525 = _4173;
                                                                                            }
                                                                                            _4526 = (_4512 < _4204);
                                                                                            do {
                                                                                              if (!(_4526 || _4516)) {
                                                                                                if ((_4512 >= _4210) || (_4510 >= _4211)) {
                                                                                                  _4534 = _4173;
                                                                                                } else {
                                                                                                  _4534 = _4501.y;
                                                                                                }
                                                                                              } else {
                                                                                                _4534 = _4173;
                                                                                              }
                                                                                              _4535 = (_4514 < _4205);
                                                                                              do {
                                                                                                if (!(_4526 || _4535)) {
                                                                                                  if ((_4512 >= _4210) || (_4514 >= _4211)) {
                                                                                                    _4543 = _4173;
                                                                                                  } else {
                                                                                                    _4543 = _4501.z;
                                                                                                  }
                                                                                                } else {
                                                                                                  _4543 = _4173;
                                                                                                }
                                                                                                do {
                                                                                                  if (!(_4515 || _4535)) {
                                                                                                    if ((_4509 >= _4210) || (_4514 >= _4211)) {
                                                                                                      _4551 = _4173;
                                                                                                    } else {
                                                                                                      _4551 = _4501.w;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _4551 = _4173;
                                                                                                  }
                                                                                                  _4552 = _4525 - _4153;
                                                                                                  _4554 = select((_4552 < 0.0f), 0.0f, 1.0f);
                                                                                                  _4558 = _4534 - _4153;
                                                                                                  _4560 = select((_4558 < 0.0f), 0.0f, 1.0f);
                                                                                                  _4564 = _4543 - _4153;
                                                                                                  _4566 = select((_4564 < 0.0f), 0.0f, 1.0f);
                                                                                                  _4570 = _4551 - _4153;
                                                                                                  _4572 = select((_4570 < 0.0f), 0.0f, 1.0f);
                                                                                                  _4573 = ((((((((((((((_4263 + _4259) + _4269) + _4275) + _4356) + _4362) + _4368) + _4374) + _4455) + _4461) + _4467) + _4473) + _4554) + _4560) + _4566) + _4572;
                                                                                                  _4584 = (saturate(_4573 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                  _4590 = float((int)(((int)(uint)((int)(_4584 > 0.0f))) - ((int)(uint)((int)(_4584 < 0.0f)))));
                                                                                                  _4592 = 1.0f - (_4590 * _4584);
                                                                                                  _4594 = (_4592 * _4592) * _4592;
                                                                                                  _4886 = (0.5f - ((_4590 * 0.5f) * ((1.0f - _4594) - ((_4592 - _4594) * saturate(((1.0f / _4153) * (1.0f / _4573)) * ((((((((((((((((_4263 * _4261) + (_4259 * _4257)) + (_4269 * _4267)) + (_4275 * _4273)) + (_4356 * _4354)) + (_4362 * _4360)) + (_4368 * _4366)) + (_4374 * _4372)) + (_4455 * _4453)) + (_4461 * _4459)) + (_4467 * _4465)) + (_4473 * _4471)) + (_4554 * _4552)) + (_4560 * _4558)) + (_4566 * _4564)) + (_4572 * _4570)))))));
                                                                                                  _4887 = 1.0f;
                                                                                                  _4888 = 1;
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
                                                                _4603 = f16tof32(_3963) / _4097;
                                                                _4606 = mad((_4603 * _4095), 0.5f, 0.5f);
                                                                _4607 = mad((_4603 * _4096), 0.5f, 0.5f);
                                                                if (_4084 > -0.0f) {
                                                                  if ((saturate(_4606) == _4606) && (saturate(_4607) == _4607)) {
                                                                    _4621 = (_4606 * _4026) + _4028;
                                                                    _4622 = (_4607 * _4027) + _4029;
                                                                    _4623 = saturate((_4002 + 1.0f) - (_4084 * _3984));
                                                                    _4627 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _4636 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 3u);
                                                                    } else {
                                                                      _4636 = frac(frac(dot(float2(((_4627 * 32.665000915527344f) + _125), ((_4627 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _4636 = frac(frac(dot(float2(((_4627 * 32.665000915527344f) + _125), ((_4627 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _4637 = sin(_4636);
                                                                    _4638 = cos(_4636);
                                                                    _4639 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _4644 = sqrt((float((int)(_4639)) * 0.25f) + 0.125f) * _4005;
                                                                    _4653 = (_global_7[min((uint)(((int)(0u + (_4639 * 2)))), 127u)]) * _4644;
                                                                    _4654 = (_global_7[min((uint)(((int)(1u + (_4639 * 2)))), 127u)]) * _4644;
                                                                    _4656 = -0.0f - _4637;
                                                                    _4661 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4653, _4654), float2(_4638, _4637)) + _4621), (dot(float2(_4653, _4654), float2(_4656, _4638)) + _4622)));
                                                                    _4666 = _4661.x - _4623;
                                                                    _4668 = select((_4666 < 0.0f), 0.0f, 1.0f);
                                                                    _4670 = _4661.y - _4623;
                                                                    _4672 = select((_4670 < 0.0f), 0.0f, 1.0f);
                                                                    _4676 = _4661.z - _4623;
                                                                    _4678 = select((_4676 < 0.0f), 0.0f, 1.0f);
                                                                    _4682 = _4661.w - _4623;
                                                                    _4684 = select((_4682 < 0.0f), 0.0f, 1.0f);
                                                                    _4691 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                    _4696 = sqrt((float((int)(_4691)) * 0.25f) + 0.125f) * _4005;
                                                                    _4705 = (_global_7[min((uint)(((int)(0u + (_4691 * 2)))), 127u)]) * _4696;
                                                                    _4706 = (_global_7[min((uint)(((int)(1u + (_4691 * 2)))), 127u)]) * _4696;
                                                                    _4712 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4705, _4706), float2(_4638, _4637)) + _4621), (dot(float2(_4705, _4706), float2(_4656, _4638)) + _4622)));
                                                                    _4717 = _4712.x - _4623;
                                                                    _4719 = select((_4717 < 0.0f), 0.0f, 1.0f);
                                                                    _4723 = _4712.y - _4623;
                                                                    _4725 = select((_4723 < 0.0f), 0.0f, 1.0f);
                                                                    _4729 = _4712.z - _4623;
                                                                    _4731 = select((_4729 < 0.0f), 0.0f, 1.0f);
                                                                    _4735 = _4712.w - _4623;
                                                                    _4737 = select((_4735 < 0.0f), 0.0f, 1.0f);
                                                                    _4744 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                    _4749 = sqrt((float((int)(_4744)) * 0.25f) + 0.125f) * _4005;
                                                                    _4758 = (_global_7[min((uint)(((int)(0u + (_4744 * 2)))), 127u)]) * _4749;
                                                                    _4759 = (_global_7[min((uint)(((int)(1u + (_4744 * 2)))), 127u)]) * _4749;
                                                                    _4765 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4758, _4759), float2(_4638, _4637)) + _4621), (dot(float2(_4758, _4759), float2(_4656, _4638)) + _4622)));
                                                                    _4770 = _4765.x - _4623;
                                                                    _4772 = select((_4770 < 0.0f), 0.0f, 1.0f);
                                                                    _4776 = _4765.y - _4623;
                                                                    _4778 = select((_4776 < 0.0f), 0.0f, 1.0f);
                                                                    _4782 = _4765.z - _4623;
                                                                    _4784 = select((_4782 < 0.0f), 0.0f, 1.0f);
                                                                    _4788 = _4765.w - _4623;
                                                                    _4790 = select((_4788 < 0.0f), 0.0f, 1.0f);
                                                                    _4797 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                    _4802 = sqrt((float((int)(_4797)) * 0.25f) + 0.125f) * _4005;
                                                                    _4811 = (_global_7[min((uint)(((int)(0u + (_4797 * 2)))), 127u)]) * _4802;
                                                                    _4812 = (_global_7[min((uint)(((int)(1u + (_4797 * 2)))), 127u)]) * _4802;
                                                                    _4818 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4811, _4812), float2(_4638, _4637)) + _4621), (dot(float2(_4811, _4812), float2(_4656, _4638)) + _4622)));
                                                                    _4823 = _4818.x - _4623;
                                                                    _4825 = select((_4823 < 0.0f), 0.0f, 1.0f);
                                                                    _4829 = _4818.y - _4623;
                                                                    _4831 = select((_4829 < 0.0f), 0.0f, 1.0f);
                                                                    _4835 = _4818.z - _4623;
                                                                    _4837 = select((_4835 < 0.0f), 0.0f, 1.0f);
                                                                    _4841 = _4818.w - _4623;
                                                                    _4843 = select((_4841 < 0.0f), 0.0f, 1.0f);
                                                                    _4844 = ((((((((((((((_4668 + _4672) + _4678) + _4684) + _4719) + _4725) + _4731) + _4737) + _4772) + _4778) + _4784) + _4790) + _4825) + _4831) + _4837) + _4843;
                                                                    _4855 = (saturate(_4844 * 0.0625f) * 2.0f) + -1.0f;
                                                                    _4861 = float((int)(((int)(uint)((int)(_4855 > 0.0f))) - ((int)(uint)((int)(_4855 < 0.0f)))));
                                                                    _4863 = 1.0f - (_4861 * _4855);
                                                                    _4865 = (_4863 * _4863) * _4863;
                                                                    _4873 = -0.0f - _4095;
                                                                    _4880 = saturate((saturate(rsqrt(dot(float3(_4873, _4087, _4084), float3(_4873, _4087, _4084))) * _4084) * _3982) + _3981);
                                                                    _4882 = 1.0f - (_4880 * _4880);
                                                                    _4886 = (0.5f - ((_4861 * 0.5f) * ((1.0f - _4865) - ((_4863 - _4865) * saturate(((1.0f / _4623) * (1.0f / _4844)) * ((((((((((((((((_4668 * _4666) + (_4672 * _4670)) + (_4678 * _4676)) + (_4684 * _4682)) + (_4719 * _4717)) + (_4725 * _4723)) + (_4731 * _4729)) + (_4737 * _4735)) + (_4772 * _4770)) + (_4778 * _4776)) + (_4784 * _4782)) + (_4790 * _4788)) + (_4825 * _4823)) + (_4831 * _4829)) + (_4837 * _4835)) + (_4843 * _4841)))))));
                                                                    _4887 = (1.0f - (_4882 * _4882));
                                                                    _4888 = 1;
                                                                  } else {
                                                                    _4886 = 1.0f;
                                                                    _4887 = 1.0f;
                                                                    _4888 = 0;
                                                                  }
                                                                } else {
                                                                  _4886 = 1.0f;
                                                                  _4887 = 1.0f;
                                                                  _4888 = 0;
                                                                }
                                                              }
                                                            }
                                                            do {
                                                              _5678 = 1.0f;
                                                              _5679 = 1.0f;
                                                              _5680 = true;
                                                              [branch]
                                                              if (!((_1594 & 512) == 0)) {
                                                                Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                                                                [branch]
                                                                if (!((_1594 & 2097152) == 0)) {
                                                                  _4896 = abs(_4095);
                                                                  _4897 = abs(_4096);
                                                                  _4898 = abs(_4097);
                                                                  do {
                                                                    if (_4896 > max(_4897, _4898)) {
                                                                      _4902 = (_4095 > 0.0f);
                                                                      _4917 = select(_4902, 0.0f, 1.0f);
                                                                      _4918 = 0.0f;
                                                                      _4919 = select(_4902, _4084, _4097);
                                                                      _4920 = _4087;
                                                                      _4921 = _4896;
                                                                    } else {
                                                                      if (_4897 > _4898) {
                                                                        _4908 = (_4087 < -0.0f);
                                                                        _4917 = select(_4908, 0.0f, 1.0f);
                                                                        _4918 = 1.0f;
                                                                        _4919 = _4095;
                                                                        _4920 = select(_4908, _4097, _4084);
                                                                        _4921 = _4897;
                                                                      } else {
                                                                        _4912 = (_4084 < -0.0f);
                                                                        _4917 = select(_4912, 0.0f, 1.0f);
                                                                        _4918 = 2.0f;
                                                                        _4919 = select(_4912, _4095, (-0.0f - _4095));
                                                                        _4920 = _4087;
                                                                        _4921 = _4898;
                                                                      }
                                                                    }
                                                                    _4922 = _4921 * 2.0f;
                                                                    _4927 = -0.0f - _3999;
                                                                    _4936 = ((min(max((_4919 / _4922), _4927), _3999) + _4917) * _3948) + _3950;
                                                                    _4937 = ((min(max((_4920 / _4922), _4927), _3999) + _4918) * _3949) + _3951;
                                                                    _4942 = ((_4917 + -0.5f) * _3948) + _3950;
                                                                    _4943 = ((_4918 + -0.5f) * _3949) + _3951;
                                                                    _4946 = saturate(1.0f - (_4921 * _3984));
                                                                    _4950 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _4959 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 4u);
                                                                    } else {
                                                                      _4959 = frac(frac(dot(float2(((_4950 * 32.665000915527344f) + _125), ((_4950 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _4959 = frac(frac(dot(float2(((_4950 * 32.665000915527344f) + _125), ((_4950 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _4960 = sin(_4959);
                                                                    _4961 = cos(_4959);
                                                                    _4966 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4936, _4937), 0.0f))).x) > _4946), 1.0f, 0.0f);
                                                                    _4967 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _4972 = sqrt((float((int)(_4967)) * 0.25f) + 0.125f) * _4006;
                                                                    _4981 = (_global_7[min((uint)(((int)(0u + (_4967 * 2)))), 127u)]) * _4972;
                                                                    _4982 = (_global_7[min((uint)(((int)(1u + (_4967 * 2)))), 127u)]) * _4972;
                                                                    _4984 = -0.0f - _4960;
                                                                    _4986 = dot(float2(_4981, _4982), float2(_4961, _4960)) + _4936;
                                                                    _4987 = dot(float2(_4981, _4982), float2(_4984, _4961)) + _4937;
                                                                    _4989 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4986, _4987));
                                                                    _4993 = _4986 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                    _4994 = _4987 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                    _4997 = floor(_4942 * cbSharedPerViewData.vShadowAtlasSize.x);
                                                                    _4998 = floor(_4943 * cbSharedPerViewData.vShadowAtlasSize.y);
                                                                    _5003 = floor(((_4942 + _3948) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                                                                    _5004 = floor(((_4943 + _3949) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                                                                    _5007 = floor(_4993 + -0.5f);
                                                                    _5008 = floor(_4994 + 0.5f);
                                                                    _5010 = floor(_4993 + 0.5f);
                                                                    _5012 = floor(_4994 + -0.5f);
                                                                    _5013 = (_5007 < _4997);
                                                                    _5014 = (_5008 < _4998);
                                                                    do {
                                                                      if (!(_5013 || _5014)) {
                                                                        if ((_5007 >= _5003) || (_5008 >= _5004)) {
                                                                          _5023 = _4966;
                                                                        } else {
                                                                          _5023 = _4989.x;
                                                                        }
                                                                      } else {
                                                                        _5023 = _4966;
                                                                      }
                                                                      _5024 = (_5010 < _4997);
                                                                      do {
                                                                        if (!(_5024 || _5014)) {
                                                                          if ((_5010 >= _5003) || (_5008 >= _5004)) {
                                                                            _5032 = _4966;
                                                                          } else {
                                                                            _5032 = _4989.y;
                                                                          }
                                                                        } else {
                                                                          _5032 = _4966;
                                                                        }
                                                                        _5033 = (_5012 < _4998);
                                                                        do {
                                                                          if (!(_5024 || _5033)) {
                                                                            if ((_5010 >= _5003) || (_5012 >= _5004)) {
                                                                              _5041 = _4966;
                                                                            } else {
                                                                              _5041 = _4989.z;
                                                                            }
                                                                          } else {
                                                                            _5041 = _4966;
                                                                          }
                                                                          do {
                                                                            if (!(_5013 || _5033)) {
                                                                              if ((_5007 >= _5003) || (_5012 >= _5004)) {
                                                                                _5049 = _4966;
                                                                              } else {
                                                                                _5049 = _4989.w;
                                                                              }
                                                                            } else {
                                                                              _5049 = _4966;
                                                                            }
                                                                            _5050 = _5023 - _4946;
                                                                            _5052 = select((_5050 < 0.0f), 0.0f, 1.0f);
                                                                            _5054 = _5032 - _4946;
                                                                            _5056 = select((_5054 < 0.0f), 0.0f, 1.0f);
                                                                            _5060 = _5041 - _4946;
                                                                            _5062 = select((_5060 < 0.0f), 0.0f, 1.0f);
                                                                            _5066 = _5049 - _4946;
                                                                            _5068 = select((_5066 < 0.0f), 0.0f, 1.0f);
                                                                            _5075 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _5080 = sqrt((float((int)(_5075)) * 0.25f) + 0.125f) * _4006;
                                                                            _5089 = (_global_7[min((uint)(((int)(0u + (_5075 * 2)))), 127u)]) * _5080;
                                                                            _5090 = (_global_7[min((uint)(((int)(1u + (_5075 * 2)))), 127u)]) * _5080;
                                                                            _5093 = dot(float2(_5089, _5090), float2(_4961, _4960)) + _4936;
                                                                            _5094 = dot(float2(_5089, _5090), float2(_4984, _4961)) + _4937;
                                                                            _5096 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5093, _5094));
                                                                            _5100 = _5093 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                            _5101 = _5094 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                            _5104 = floor(_5100 + -0.5f);
                                                                            _5105 = floor(_5101 + 0.5f);
                                                                            _5107 = floor(_5100 + 0.5f);
                                                                            _5109 = floor(_5101 + -0.5f);
                                                                            _5110 = (_5104 < _4997);
                                                                            _5111 = (_5105 < _4998);
                                                                            do {
                                                                              if (!(_5110 || _5111)) {
                                                                                if ((_5104 >= _5003) || (_5105 >= _5004)) {
                                                                                  _5120 = _4966;
                                                                                } else {
                                                                                  _5120 = _5096.x;
                                                                                }
                                                                              } else {
                                                                                _5120 = _4966;
                                                                              }
                                                                              _5121 = (_5107 < _4997);
                                                                              do {
                                                                                if (!(_5121 || _5111)) {
                                                                                  if ((_5107 >= _5003) || (_5105 >= _5004)) {
                                                                                    _5129 = _4966;
                                                                                  } else {
                                                                                    _5129 = _5096.y;
                                                                                  }
                                                                                } else {
                                                                                  _5129 = _4966;
                                                                                }
                                                                                _5130 = (_5109 < _4998);
                                                                                do {
                                                                                  if (!(_5121 || _5130)) {
                                                                                    if ((_5107 >= _5003) || (_5109 >= _5004)) {
                                                                                      _5138 = _4966;
                                                                                    } else {
                                                                                      _5138 = _5096.z;
                                                                                    }
                                                                                  } else {
                                                                                    _5138 = _4966;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_5110 || _5130)) {
                                                                                      if ((_5104 >= _5003) || (_5109 >= _5004)) {
                                                                                        _5146 = _4966;
                                                                                      } else {
                                                                                        _5146 = _5096.w;
                                                                                      }
                                                                                    } else {
                                                                                      _5146 = _4966;
                                                                                    }
                                                                                    _5147 = _5120 - _4946;
                                                                                    _5149 = select((_5147 < 0.0f), 0.0f, 1.0f);
                                                                                    _5153 = _5129 - _4946;
                                                                                    _5155 = select((_5153 < 0.0f), 0.0f, 1.0f);
                                                                                    _5159 = _5138 - _4946;
                                                                                    _5161 = select((_5159 < 0.0f), 0.0f, 1.0f);
                                                                                    _5165 = _5146 - _4946;
                                                                                    _5167 = select((_5165 < 0.0f), 0.0f, 1.0f);
                                                                                    _5174 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _5179 = sqrt((float((int)(_5174)) * 0.25f) + 0.125f) * _4006;
                                                                                    _5188 = (_global_7[min((uint)(((int)(0u + (_5174 * 2)))), 127u)]) * _5179;
                                                                                    _5189 = (_global_7[min((uint)(((int)(1u + (_5174 * 2)))), 127u)]) * _5179;
                                                                                    _5192 = dot(float2(_5188, _5189), float2(_4961, _4960)) + _4936;
                                                                                    _5193 = dot(float2(_5188, _5189), float2(_4984, _4961)) + _4937;
                                                                                    _5195 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5192, _5193));
                                                                                    _5199 = _5192 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                    _5200 = _5193 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                    _5203 = floor(_5199 + -0.5f);
                                                                                    _5204 = floor(_5200 + 0.5f);
                                                                                    _5206 = floor(_5199 + 0.5f);
                                                                                    _5208 = floor(_5200 + -0.5f);
                                                                                    _5209 = (_5203 < _4997);
                                                                                    _5210 = (_5204 < _4998);
                                                                                    do {
                                                                                      if (!(_5209 || _5210)) {
                                                                                        if ((_5203 >= _5003) || (_5204 >= _5004)) {
                                                                                          _5219 = _4966;
                                                                                        } else {
                                                                                          _5219 = _5195.x;
                                                                                        }
                                                                                      } else {
                                                                                        _5219 = _4966;
                                                                                      }
                                                                                      _5220 = (_5206 < _4997);
                                                                                      do {
                                                                                        if (!(_5220 || _5210)) {
                                                                                          if ((_5206 >= _5003) || (_5204 >= _5004)) {
                                                                                            _5228 = _4966;
                                                                                          } else {
                                                                                            _5228 = _5195.y;
                                                                                          }
                                                                                        } else {
                                                                                          _5228 = _4966;
                                                                                        }
                                                                                        _5229 = (_5208 < _4998);
                                                                                        do {
                                                                                          if (!(_5220 || _5229)) {
                                                                                            if ((_5206 >= _5003) || (_5208 >= _5004)) {
                                                                                              _5237 = _4966;
                                                                                            } else {
                                                                                              _5237 = _5195.z;
                                                                                            }
                                                                                          } else {
                                                                                            _5237 = _4966;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_5209 || _5229)) {
                                                                                              if ((_5203 >= _5003) || (_5208 >= _5004)) {
                                                                                                _5245 = _4966;
                                                                                              } else {
                                                                                                _5245 = _5195.w;
                                                                                              }
                                                                                            } else {
                                                                                              _5245 = _4966;
                                                                                            }
                                                                                            _5246 = _5219 - _4946;
                                                                                            _5248 = select((_5246 < 0.0f), 0.0f, 1.0f);
                                                                                            _5252 = _5228 - _4946;
                                                                                            _5254 = select((_5252 < 0.0f), 0.0f, 1.0f);
                                                                                            _5258 = _5237 - _4946;
                                                                                            _5260 = select((_5258 < 0.0f), 0.0f, 1.0f);
                                                                                            _5264 = _5245 - _4946;
                                                                                            _5266 = select((_5264 < 0.0f), 0.0f, 1.0f);
                                                                                            _5273 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _5278 = sqrt((float((int)(_5273)) * 0.25f) + 0.125f) * _4006;
                                                                                            _5287 = (_global_7[min((uint)(((int)(0u + (_5273 * 2)))), 127u)]) * _5278;
                                                                                            _5288 = (_global_7[min((uint)(((int)(1u + (_5273 * 2)))), 127u)]) * _5278;
                                                                                            _5291 = dot(float2(_5287, _5288), float2(_4961, _4960)) + _4936;
                                                                                            _5292 = dot(float2(_5287, _5288), float2(_4984, _4961)) + _4937;
                                                                                            _5294 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5291, _5292));
                                                                                            _5298 = _5291 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                            _5299 = _5292 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                            _5302 = floor(_5298 + -0.5f);
                                                                                            _5303 = floor(_5299 + 0.5f);
                                                                                            _5305 = floor(_5298 + 0.5f);
                                                                                            _5307 = floor(_5299 + -0.5f);
                                                                                            _5308 = (_5302 < _4997);
                                                                                            _5309 = (_5303 < _4998);
                                                                                            do {
                                                                                              if (!(_5308 || _5309)) {
                                                                                                if ((_5302 >= _5003) || (_5303 >= _5004)) {
                                                                                                  _5318 = _4966;
                                                                                                } else {
                                                                                                  _5318 = _5294.x;
                                                                                                }
                                                                                              } else {
                                                                                                _5318 = _4966;
                                                                                              }
                                                                                              _5319 = (_5305 < _4997);
                                                                                              do {
                                                                                                if (!(_5319 || _5309)) {
                                                                                                  if ((_5305 >= _5003) || (_5303 >= _5004)) {
                                                                                                    _5327 = _4966;
                                                                                                  } else {
                                                                                                    _5327 = _5294.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _5327 = _4966;
                                                                                                }
                                                                                                _5328 = (_5307 < _4998);
                                                                                                do {
                                                                                                  if (!(_5319 || _5328)) {
                                                                                                    if ((_5305 >= _5003) || (_5307 >= _5004)) {
                                                                                                      _5336 = _4966;
                                                                                                    } else {
                                                                                                      _5336 = _5294.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _5336 = _4966;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_5308 || _5328)) {
                                                                                                      if ((_5302 >= _5003) || (_5307 >= _5004)) {
                                                                                                        _5344 = _4966;
                                                                                                      } else {
                                                                                                        _5344 = _5294.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _5344 = _4966;
                                                                                                    }
                                                                                                    _5345 = _5318 - _4946;
                                                                                                    _5347 = select((_5345 < 0.0f), 0.0f, 1.0f);
                                                                                                    _5351 = _5327 - _4946;
                                                                                                    _5353 = select((_5351 < 0.0f), 0.0f, 1.0f);
                                                                                                    _5357 = _5336 - _4946;
                                                                                                    _5359 = select((_5357 < 0.0f), 0.0f, 1.0f);
                                                                                                    _5363 = _5344 - _4946;
                                                                                                    _5365 = select((_5363 < 0.0f), 0.0f, 1.0f);
                                                                                                    _5366 = ((((((((((((((_5056 + _5052) + _5062) + _5068) + _5149) + _5155) + _5161) + _5167) + _5248) + _5254) + _5260) + _5266) + _5347) + _5353) + _5359) + _5365;
                                                                                                    _5377 = (saturate(_5366 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _5383 = float((int)(((int)(uint)((int)(_5377 > 0.0f))) - ((int)(uint)((int)(_5377 < 0.0f)))));
                                                                                                    _5385 = 1.0f - (_5383 * _5377);
                                                                                                    _5387 = (_5385 * _5385) * _5385;
                                                                                                    _5678 = (0.5f - ((_5383 * 0.5f) * ((1.0f - _5387) - ((_5385 - _5387) * saturate(((1.0f / _4946) * (1.0f / _5366)) * ((((((((((((((((_5056 * _5054) + (_5052 * _5050)) + (_5062 * _5060)) + (_5068 * _5066)) + (_5149 * _5147)) + (_5155 * _5153)) + (_5161 * _5159)) + (_5167 * _5165)) + (_5248 * _5246)) + (_5254 * _5252)) + (_5260 * _5258)) + (_5266 * _5264)) + (_5347 * _5345)) + (_5353 * _5351)) + (_5359 * _5357)) + (_5365 * _5363)))))));
                                                                                                    _5679 = 1.0f;
                                                                                                    _5680 = false;
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
                                                                  _5396 = f16tof32(((uint)((uint)(_3963) >> 16))) / _4097;
                                                                  _5399 = mad((_5396 * _4095), 0.5f, 0.5f);
                                                                  _5400 = mad((_5396 * _4096), 0.5f, 0.5f);
                                                                  if (_4084 > -0.0f) {
                                                                    if ((saturate(_5399) == _5399) && (saturate(_5400) == _5400)) {
                                                                      _5413 = (_5399 * _3948) + _3950;
                                                                      _5414 = (_5400 * _3949) + _3951;
                                                                      _5415 = saturate(1.0f - (_4084 * _3984));
                                                                      _5419 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _5428 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 5u);
                                                                      } else {
                                                                        _5428 = frac(frac(dot(float2(((_5419 * 32.665000915527344f) + _125), ((_5419 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _5428 = frac(frac(dot(float2(((_5419 * 32.665000915527344f) + _125), ((_5419 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _5429 = sin(_5428);
                                                                      _5430 = cos(_5428);
                                                                      _5431 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _5436 = sqrt((float((int)(_5431)) * 0.25f) + 0.125f) * _4006;
                                                                      _5445 = (_global_7[min((uint)(((int)(0u + (_5431 * 2)))), 127u)]) * _5436;
                                                                      _5446 = (_global_7[min((uint)(((int)(1u + (_5431 * 2)))), 127u)]) * _5436;
                                                                      _5448 = -0.0f - _5429;
                                                                      _5453 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5445, _5446), float2(_5430, _5429)) + _5413), (dot(float2(_5445, _5446), float2(_5448, _5430)) + _5414)));
                                                                      _5458 = _5453.x - _5415;
                                                                      _5460 = select((_5458 < 0.0f), 0.0f, 1.0f);
                                                                      _5462 = _5453.y - _5415;
                                                                      _5464 = select((_5462 < 0.0f), 0.0f, 1.0f);
                                                                      _5468 = _5453.z - _5415;
                                                                      _5470 = select((_5468 < 0.0f), 0.0f, 1.0f);
                                                                      _5474 = _5453.w - _5415;
                                                                      _5476 = select((_5474 < 0.0f), 0.0f, 1.0f);
                                                                      _5483 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _5488 = sqrt((float((int)(_5483)) * 0.25f) + 0.125f) * _4006;
                                                                      _5497 = (_global_7[min((uint)(((int)(0u + (_5483 * 2)))), 127u)]) * _5488;
                                                                      _5498 = (_global_7[min((uint)(((int)(1u + (_5483 * 2)))), 127u)]) * _5488;
                                                                      _5504 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5497, _5498), float2(_5430, _5429)) + _5413), (dot(float2(_5497, _5498), float2(_5448, _5430)) + _5414)));
                                                                      _5509 = _5504.x - _5415;
                                                                      _5511 = select((_5509 < 0.0f), 0.0f, 1.0f);
                                                                      _5515 = _5504.y - _5415;
                                                                      _5517 = select((_5515 < 0.0f), 0.0f, 1.0f);
                                                                      _5521 = _5504.z - _5415;
                                                                      _5523 = select((_5521 < 0.0f), 0.0f, 1.0f);
                                                                      _5527 = _5504.w - _5415;
                                                                      _5529 = select((_5527 < 0.0f), 0.0f, 1.0f);
                                                                      _5536 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                      _5541 = sqrt((float((int)(_5536)) * 0.25f) + 0.125f) * _4006;
                                                                      _5550 = (_global_7[min((uint)(((int)(0u + (_5536 * 2)))), 127u)]) * _5541;
                                                                      _5551 = (_global_7[min((uint)(((int)(1u + (_5536 * 2)))), 127u)]) * _5541;
                                                                      _5557 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5550, _5551), float2(_5430, _5429)) + _5413), (dot(float2(_5550, _5551), float2(_5448, _5430)) + _5414)));
                                                                      _5562 = _5557.x - _5415;
                                                                      _5564 = select((_5562 < 0.0f), 0.0f, 1.0f);
                                                                      _5568 = _5557.y - _5415;
                                                                      _5570 = select((_5568 < 0.0f), 0.0f, 1.0f);
                                                                      _5574 = _5557.z - _5415;
                                                                      _5576 = select((_5574 < 0.0f), 0.0f, 1.0f);
                                                                      _5580 = _5557.w - _5415;
                                                                      _5582 = select((_5580 < 0.0f), 0.0f, 1.0f);
                                                                      _5589 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                      _5594 = sqrt((float((int)(_5589)) * 0.25f) + 0.125f) * _4006;
                                                                      _5603 = (_global_7[min((uint)(((int)(0u + (_5589 * 2)))), 127u)]) * _5594;
                                                                      _5604 = (_global_7[min((uint)(((int)(1u + (_5589 * 2)))), 127u)]) * _5594;
                                                                      _5610 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5603, _5604), float2(_5430, _5429)) + _5413), (dot(float2(_5603, _5604), float2(_5448, _5430)) + _5414)));
                                                                      _5615 = _5610.x - _5415;
                                                                      _5617 = select((_5615 < 0.0f), 0.0f, 1.0f);
                                                                      _5621 = _5610.y - _5415;
                                                                      _5623 = select((_5621 < 0.0f), 0.0f, 1.0f);
                                                                      _5627 = _5610.z - _5415;
                                                                      _5629 = select((_5627 < 0.0f), 0.0f, 1.0f);
                                                                      _5633 = _5610.w - _5415;
                                                                      _5635 = select((_5633 < 0.0f), 0.0f, 1.0f);
                                                                      _5636 = ((((((((((((((_5460 + _5464) + _5470) + _5476) + _5511) + _5517) + _5523) + _5529) + _5564) + _5570) + _5576) + _5582) + _5617) + _5623) + _5629) + _5635;
                                                                      _5647 = (saturate(_5636 * 0.0625f) * 2.0f) + -1.0f;
                                                                      _5653 = float((int)(((int)(uint)((int)(_5647 > 0.0f))) - ((int)(uint)((int)(_5647 < 0.0f)))));
                                                                      _5655 = 1.0f - (_5653 * _5647);
                                                                      _5657 = (_5655 * _5655) * _5655;
                                                                      _5665 = -0.0f - _4095;
                                                                      _5672 = saturate((saturate(rsqrt(dot(float3(_5665, _4087, _4084), float3(_5665, _4087, _4084))) * _4084) * _3982) + _3981);
                                                                      _5674 = 1.0f - (_5672 * _5672);
                                                                      _5678 = (0.5f - ((_5653 * 0.5f) * ((1.0f - _5657) - ((_5655 - _5657) * saturate(((1.0f / _5415) * (1.0f / _5636)) * ((((((((((((((((_5460 * _5458) + (_5464 * _5462)) + (_5470 * _5468)) + (_5476 * _5474)) + (_5511 * _5509)) + (_5517 * _5515)) + (_5523 * _5521)) + (_5529 * _5527)) + (_5564 * _5562)) + (_5570 * _5568)) + (_5576 * _5574)) + (_5582 * _5580)) + (_5617 * _5615)) + (_5623 * _5621)) + (_5629 * _5627)) + (_5635 * _5633)))))));
                                                                      _5679 = (1.0f - (_5674 * _5674));
                                                                      _5680 = false;
                                                                    } else {
                                                                      _5678 = 1.0f;
                                                                      _5679 = 1.0f;
                                                                      _5680 = true;
                                                                    }
                                                                  } else {
                                                                    _5678 = 1.0f;
                                                                    _5679 = 1.0f;
                                                                    _5680 = true;
                                                                  }
                                                                }
                                                              }
                                                              do {
                                                                if (_4888 == 0) {
                                                                  if (!(_5680)) {
                                                                    _5695 = _4886;
                                                                    _5696 = ((_5679 * (_5678 + -1.0f)) + 1.0f);
                                                                    _5697 = 0.0f;
                                                                  } else {
                                                                    _5695 = _4886;
                                                                    _5696 = _5678;
                                                                    _5697 = 0.0f;
                                                                  }
                                                                } else {
                                                                  if (_5680) {
                                                                    _5695 = ((_4887 * (_4886 + -1.0f)) + 1.0f);
                                                                    _5696 = _5678;
                                                                    _5697 = 1.0f;
                                                                  } else {
                                                                    _5695 = _4886;
                                                                    _5696 = _5678;
                                                                    _5697 = (_4887 * f16tof32(_3933));
                                                                  }
                                                                }
                                                                _5700 = (_5697 * (_5695 - _5696)) + _5696;
                                                                do {
                                                                  _5877 = _5700;
                                                                  [branch]
                                                                  if (!((_1594 & 2048) == 0)) {
                                                                    _5702 = _231 - _3905;
                                                                    _5703 = _232 - _3906;
                                                                    _5704 = _233 - _3907;
                                                                    _5719 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5704, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5703, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5702)));
                                                                    _5722 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _5704, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _5703, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _5702)));
                                                                    _5725 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _5704, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _5703, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _5702)));
                                                                    _5727 = rsqrt(dot(float3(_5719, _5722, _5725), float3(_5719, _5722, _5725)));
                                                                    _5728 = _5727 * _5719;
                                                                    _5729 = _5727 * _5722;
                                                                    _5730 = _5727 * _5725;
                                                                    Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3939) >> 16))];
                                                                    _5738 = (abs(_5729) + abs(_5728)) + abs(_5730);
                                                                    _5739 = _5728 / _5738;
                                                                    _5740 = _5729 / _5738;
                                                                    _5742 = !((_5730 / _5738) >= 0.0f);
                                                                    do {
                                                                      _5755 = _5739;
                                                                      _5756 = _5740;
                                                                      if (_5742) {
                                                                        _5755 = ((1.0f - abs(_5740)) * select((_5739 >= 0.0f), 1.0f, -1.0f));
                                                                        _5756 = ((1.0f - abs(_5739)) * select((_5740 >= 0.0f), 1.0f, -1.0f));
                                                                      }
                                                                      _5762 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5755 * 0.5f) + 0.5f), ((_5756 * 0.5f) + 0.5f)), 0.0f);
                                                                      if (_5762.x > 0.0f) {
                                                                        Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3939 & 65535))];
                                                                        do {
                                                                          _5781 = _5739;
                                                                          _5782 = _5740;
                                                                          if (_5742) {
                                                                            _5781 = ((1.0f - abs(_5740)) * select((_5739 >= 0.0f), 1.0f, -1.0f));
                                                                            _5782 = ((1.0f - abs(_5739)) * select((_5740 >= 0.0f), 1.0f, -1.0f));
                                                                          }
                                                                          _5787 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5781 * 0.5f) + 0.5f), ((_5782 * 0.5f) + 0.5f)), 0.0f);
                                                                          _5807 = mad(saturate(((log2(sqrt(((_5702 * _5702) + (_5703 * _5703)) + (_5704 * _5704))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                          _5808 = max(9.999999747378752e-06f, _5762.x);
                                                                          _5809 = _5787.x / _5808;
                                                                          _5810 = _5787.y / _5808;
                                                                          _5812 = _5787.w / _5808;
                                                                          _5817 = ((0.375f - _5810) * 4.999999873689376e-06f) + _5810;
                                                                          _5820 = -0.0f - _5809;
                                                                          _5821 = mad(_5820, _5817, (_5787.z / _5808));
                                                                          _5823 = 1.0f / mad(_5820, _5809, _5817);
                                                                          _5824 = _5823 * _5821;
                                                                          _5829 = _5807 - _5809;
                                                                          _5834 = (((_5807 * _5807) - _5817) - (_5824 * _5829)) / mad((-0.0f - _5821), _5824, mad((-0.0f - _5817), _5817, (((0.375f - _5812) * 4.999999873689376e-06f) + _5812)));
                                                                          _5836 = (_5823 * _5829) - (_5834 * _5824);
                                                                          _5839 = 1.0f / _5834;
                                                                          _5840 = _5836 * _5839;
                                                                          _5845 = sqrt(((_5840 * _5840) * 0.25f) - ((1.0f - dot(float2(_5836, _5834), float2(_5809, _5817))) * _5839));
                                                                          _5847 = (_5840 * -0.5f) - _5845;
                                                                          _5849 = _5845 - (_5840 * 0.5f);
                                                                          _5851 = select((_5847 < _5807), 1.0f, 0.0f);
                                                                          _5856 = (_5851 + -0.05000000074505806f) / (_5847 - _5807);
                                                                          _5862 = (((select((_5849 < _5807), 1.0f, 0.0f) - _5851) / (_5849 - _5847)) - _5856) / (_5849 - _5807);
                                                                          _5864 = _5856 - (_5862 * _5847);
                                                                          _5877 = (exp2((_5762.x * -1.4426950216293335f) * saturate((dot(float2(_5809, _5817), float2((_5864 - (_5862 * _5807)), _5862)) + 0.05000000074505806f) - (_5864 * _5807))) * _5700);
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } else {
                                                                        _5877 = _5700;
                                                                      }
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  _5880 = (_5877 * _4058);
                                                                  _5881 = _5877;
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
                                                          _5901 = _3965;
                                                          _5902 = _3966;
                                                          _5903 = _3968;
                                                          [branch]
                                                          if (!(_3987 == 0)) {
                                                            TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3987)))];
                                                            _5893 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_4037, _3900, mad(_4036, _3895, (_4035 * _3890)))), (-0.0f - mad(_4037, _3901, mad(_4036, _3896, (_4035 * _3891)))), (-0.0f - mad(_4037, _3902, mad(_4036, _3897, (_4035 * _3892))))), 0.0f);
                                                            _5901 = (_5893.x * _3965);
                                                            _5902 = (_5893.y * _3966);
                                                            _5903 = (_5893.z * _3968);
                                                          }
                                                          [branch]
                                                          if (!(_5880 == 0.0f)) {
                                                            do {
                                                              _5921 = GetDeferredSoftShadowChannel(_1597);
                                                              if (_5921 < 0) {
                                                                    _5942 = _5880;
                                                                    do {
                                                                      _9262 = _1582;
                                                                      _9263 = _1583;
                                                                      _9264 = _1584;
                                                                      _9265 = _1585;
                                                                      _9266 = _1586;
                                                                      _9267 = _1587;
                                                                      [branch]
                                                                      if (!(_5942 == 0.0f)) {
                                                                        do {
                                                                          _6049 = _5901;
                                                                          _6050 = _5902;
                                                                          _6051 = _5903;
                                                                          [branch]
                                                                          if (!(((_3942 & 1) == 0) || (!_4089))) {
                                                                            _5959 = max(max(_5901, _5902), _5903);
                                                                            do {
                                                                              _5969 = _5901;
                                                                              _5970 = _5902;
                                                                              _5971 = _5903;
                                                                              if (_5959 > 0.0f) {
                                                                                _5969 = saturate(_5901 / _5959);
                                                                                _5970 = saturate(_5902 / _5959);
                                                                                _5971 = saturate(_5903 / _5959);
                                                                              }
                                                                              _5972 = (_5970 < _5971);
                                                                              _5973 = select(_5972, _5971, _5970);
                                                                              _5974 = select(_5972, _5970, _5971);
                                                                              _5975 = select(_5972, -1.0f, 0.0f);
                                                                              _5976 = (_5969 < _5973);
                                                                              _5978 = select(_5976, _5973, _5969);
                                                                              _5979 = select(_5976, _5969, _5973);
                                                                              _5983 = _5978 - select((_5979 < _5974), _5979, _5974);
                                                                              _5989 = abs(select(_5976, (-0.3333333432674408f - _5975), _5975) + ((_5979 - _5974) / ((_5983 * 6.0f) + 9.999999682655225e-21f)));
                                                                              do {
                                                                                _6002 = _5989;
                                                                                if (_5989 < 0.6666666865348816f) {
                                                                                  _6002 = ((saturate(((float)((uint)((uint)(((uint)(_3942) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5989 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5989)) + _5989);
                                                                                }
                                                                                _6003 = saturate((_5983 / (_5978 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3942) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                _6004 = saturate(_5978);
                                                                                do {
                                                                                  _6031 = _6004;
                                                                                  _6032 = _6004;
                                                                                  _6033 = _6004;
                                                                                  if (!(_6003 <= 0.0f)) {
                                                                                    _6007 = saturate(_6002);
                                                                                    _6011 = select(((_6007 * 360.0f) >= 360.0f), 0.0f, (_6007 * 6.0f));
                                                                                    _6012 = int(_6011);
                                                                                    _6014 = _6011 - float((int)(_6012));
                                                                                    _6016 = _6004 * (1.0f - _6003);
                                                                                    _6019 = (1.0f - (_6014 * _6003)) * _6004;
                                                                                    _6023 = (1.0f - ((1.0f - _6014) * _6003)) * _6004;
                                                                                    switch (_6012) {
                                                                                      case 0: {
                                                                                        _6031 = _6004;
                                                                                        _6032 = _6023;
                                                                                        _6033 = _6016;
                                                                                        break;
                                                                                      }
                                                                                      case 1: {
                                                                                        _6031 = _6019;
                                                                                        _6032 = _6004;
                                                                                        _6033 = _6016;
                                                                                        break;
                                                                                      }
                                                                                      case 2: {
                                                                                        _6031 = _6016;
                                                                                        _6032 = _6004;
                                                                                        _6033 = _6023;
                                                                                        break;
                                                                                      }
                                                                                      case 3: {
                                                                                        _6031 = _6016;
                                                                                        _6032 = _6019;
                                                                                        _6033 = _6004;
                                                                                        break;
                                                                                      }
                                                                                      case 4: {
                                                                                        _6031 = _6023;
                                                                                        _6032 = _6016;
                                                                                        _6033 = _6004;
                                                                                        break;
                                                                                      }
                                                                                      case 5: {
                                                                                        _6031 = _6004;
                                                                                        _6032 = _6016;
                                                                                        _6033 = _6019;
                                                                                        break;
                                                                                      }
                                                                                      default: {
                                                                                        _6031 = 0.0f;
                                                                                        _6032 = 0.0f;
                                                                                        _6033 = 0.0f;
                                                                                        break;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  _6034 = _6031 * _5959;
                                                                                  _6035 = _6032 * _5959;
                                                                                  _6036 = _6033 * _5959;
                                                                                  _6038 = saturate(_5881 * 1.0101009607315063f);
                                                                                  _6049 = ((_6038 * (_5901 - _6034)) + _6034);
                                                                                  _6050 = ((_6038 * (_5902 - _6035)) + _6035);
                                                                                  _6051 = (lerp(_6036, _5903, _6038));
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          }
                                                                          do {
                                                                            _6087 = _5942;
                                                                            [branch]
                                                                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                              _6058 = srvLightMappingData[_1597];
                                                                              if (!(_6058 == -1)) {
                                                                                _6063 = srvLightIndexData[_6058].nLayerIndex;
                                                                                _6065 = srvLightIndexData[_6058].vAtlasOrigin.x;
                                                                                _6066 = srvLightIndexData[_6058].vAtlasOrigin.y;
                                                                                _6068 = srvLightIndexData[_6058].vScreenOrigin.x;
                                                                                _6069 = srvLightIndexData[_6058].vScreenOrigin.y;
                                                                                _6078 = ((int)(_6063 * 5)) & 31;
                                                                                _6087 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6065 + _63) - _6068)), ((int)((_6066 + _64) - _6069)), 0)))).x) & ((int)(31 << _6078)))) >> _6078)) >> 1)))) * 0.06666667014360428f) * _5942);
                                                                              } else {
                                                                                _6087 = _5942;
                                                                              }
                                                                            }
                                                                            _6091 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                            _6094 = select(_6091, (_6087 * _1274), _6087);
                                                                            _6096 = _4041 * _4040;
                                                                            _6097 = _4042 * _4040;
                                                                            _6098 = _4043 * _4040;
                                                                            _6099 = _3973 * _3910;
                                                                            _6100 = _3973 * _3911;
                                                                            _6101 = _3973 * _3912;
                                                                            _6102 = _6096 + _6099;
                                                                            _6103 = _6097 + _6100;
                                                                            _6104 = _6098 + _6101;
                                                                            _6105 = _6096 - _6099;
                                                                            _6106 = _6097 - _6100;
                                                                            _6107 = _6098 - _6101;
                                                                            _6108 = (_3973 > 0.0f);
                                                                            _6109 = dot(float3(_6102, _6103, _6104), float3(_6102, _6103, _6104));
                                                                            _6110 = rsqrt(_6109);
                                                                            do {
                                                                              [branch]
                                                                              if (_6108) {
                                                                                _6113 = rsqrt(dot(float3(_6105, _6106, _6107), float3(_6105, _6106, _6107)));
                                                                                _6114 = _6113 * _6110;
                                                                                _6116 = dot(float3(_6102, _6103, _6104), float3(_6105, _6106, _6107)) * _6114;
                                                                                _6135 = (_6114 / ((_6114 + 0.5f) + (_6116 * 0.5f)));
                                                                                _6136 = (((dot(float3(_197, _198, _199), float3(_6105, _6106, _6107)) * _6113) + (dot(float3(_197, _198, _199), float3(_6102, _6103, _6104)) * _6110)) * 0.5f);
                                                                                _6137 = _6116;
                                                                              } else {
                                                                                _6135 = (1.0f / (_6109 + 1.0f));
                                                                                _6136 = dot(float3(_197, _198, _199), float3((_6110 * _6102), (_6110 * _6103), (_6110 * _6104)));
                                                                                _6137 = 1.0f;
                                                                              }
                                                                              do {
                                                                                _6153 = _6136;
                                                                                if (_3975 > 0.0f) {
                                                                                  _6143 = sqrt(saturate((_3975 * _3975) * _6135));
                                                                                  if (_6136 < _6143) {
                                                                                    _6148 = max(_6136, (-0.0f - _6143)) + _6143;
                                                                                    _6153 = ((_6148 * _6148) / (_6143 * 4.0f));
                                                                                  } else {
                                                                                    _6153 = _6136;
                                                                                  }
                                                                                }
                                                                                do {
                                                                                  _6213 = _6102;
                                                                                  _6214 = _6103;
                                                                                  _6215 = _6104;
                                                                                  if (_6108) {
                                                                                    _6155 = -0.0f - _445;
                                                                                    _6156 = -0.0f - _446;
                                                                                    _6157 = -0.0f - _444;
                                                                                    _6159 = dot(float3(_6155, _6156, _6157), float3(_197, _198, _199)) * 2.0f;
                                                                                    _6163 = _6155 - (_6159 * _197);
                                                                                    _6164 = _6156 - (_6159 * _198);
                                                                                    _6165 = _6157 - (_6159 * _199);
                                                                                    _6166 = _6105 - _6102;
                                                                                    _6167 = _6106 - _6103;
                                                                                    _6168 = _6107 - _6104;
                                                                                    _6169 = dot(float3(_6163, _6164, _6165), float3(_6166, _6167, _6168));
                                                                                    _6175 = sqrt(((_6166 * _6166) + (_6167 * _6167)) + (_6168 * _6168));
                                                                                    _6184 = saturate(((dot(float3(_6163, _6164, _6165), float3(_6102, _6103, _6104)) * _6169) - dot(float3(_6102, _6103, _6104), float3(_6166, _6167, _6168))) / ((_6175 * _6175) - (_6169 * _6169)));
                                                                                    _6188 = (_6184 * _6166) + _6102;
                                                                                    _6189 = (_6184 * _6167) + _6103;
                                                                                    _6190 = (_6184 * _6168) + _6104;
                                                                                    _6191 = dot(float3(_6188, _6189, _6190), float3(_6163, _6164, _6165));
                                                                                    _6195 = (_6191 * _6163) - _6188;
                                                                                    _6196 = (_6191 * _6164) - _6189;
                                                                                    _6197 = (_6191 * _6165) - _6190;
                                                                                    _6205 = saturate(0.009999999776482582f / sqrt(((_6195 * _6195) + (_6196 * _6196)) + (_6197 * _6197)));
                                                                                    _6213 = ((_6205 * _6195) + _6188);
                                                                                    _6214 = ((_6205 * _6196) + _6189);
                                                                                    _6215 = ((_6205 * _6197) + _6190);
                                                                                  }
                                                                                  _6217 = rsqrt(dot(float3(_6213, _6214, _6215), float3(_6213, _6214, _6215)));
                                                                                  _6218 = _6217 * _6213;
                                                                                  _6219 = _6217 * _6214;
                                                                                  _6220 = _6217 * _6215;
                                                                                  _6221 = _219 * _219;
                                                                                  _6225 = saturate((_3975 * (1.0f - _6221)) * _6217);
                                                                                  _6227 = saturate(_6217 * f16tof32(_3924));
                                                                                  _6229 = rsqrt(dot(float3(_6096, _6097, _6098), float3(_6096, _6097, _6098)));
                                                                                  _6230 = _6229 * _6096;
                                                                                  _6231 = _6229 * _6097;
                                                                                  _6232 = _6229 * _6098;
                                                                                  _6233 = dot(float3(_197, _198, _199), float3(_6218, _6219, _6220));
                                                                                  _6234 = dot(float3(_445, _446, _444), float3(_6218, _6219, _6220));
                                                                                  _6237 = rsqrt((_6234 * 2.0f) + 2.0f);
                                                                                  _6244 = (_6225 > 0.0f);
                                                                                  do {
                                                                                    _6335 = saturate((_6237 * _6234) + _6237);
                                                                                    _6336 = saturate(_6237 * (_1131 + _6233));
                                                                                    if (_6244) {
                                                                                      _6248 = sqrt(1.0f - (_6225 * _6225));
                                                                                      _6250 = (_6233 * 2.0f) * _1131;
                                                                                      _6251 = _6250 - _6234;
                                                                                      if (!(!(_6251 >= _6248))) {
                                                                                        _6335 = abs(_1131);
                                                                                        _6336 = 1.0f;
                                                                                      } else {
                                                                                        _6259 = rsqrt(1.0f - (_6251 * _6251)) * _6225;
                                                                                        _6262 = _6259 * (_1131 - (_6251 * _6233));
                                                                                        _6263 = _1131 * _1131;
                                                                                        _6268 = _6259 * (((_6263 * 2.0f) + -1.0f) - (_6251 * _6234));
                                                                                        _6277 = sqrt(saturate((((1.0f - (_6233 * _6233)) - _6263) - (_6234 * _6234)) + (_6250 * _6234)));
                                                                                        _6278 = _6277 * _6259;
                                                                                        _6281 = ((_1131 * 2.0f) * _6259) * _6277;
                                                                                        _6283 = (_6248 * _6233) + _1131;
                                                                                        _6284 = _6283 + _6262;
                                                                                        _6285 = _6248 * _6234;
                                                                                        _6287 = (_6285 + 1.0f) + _6268;
                                                                                        _6288 = _6278 * _6287;
                                                                                        _6289 = _6284 * _6287;
                                                                                        _6290 = _6281 * _6284;
                                                                                        _6295 = (((_6284 * 0.25f) * _6281) - (_6288 * 0.5f)) * _6289;
                                                                                        _6309 = (((_6290 - (_6288 * 2.0f)) * _6290) + (_6288 * _6288)) + ((((-0.5f - ((_6287 + _6285) * 0.5f)) * _6289) + ((_6287 * _6287) * _6283)) * _6284);
                                                                                        _6314 = (_6295 * 2.0f) / ((_6309 * _6309) + (_6295 * _6295));
                                                                                        _6315 = _6309 * _6314;
                                                                                        _6317 = 1.0f - (_6295 * _6314);
                                                                                        _6323 = ((_6315 * _6281) + _6285) + (_6317 * _6268);
                                                                                        _6326 = rsqrt((_6323 * 2.0f) + 2.0f);
                                                                                        _6335 = saturate((_6323 * _6326) + _6326);
                                                                                        _6336 = saturate(((_6283 + (_6315 * _6278)) + (_6317 * _6262)) * _6326);
                                                                                      }
                                                                                    }
                                                                                    _6337 = saturate(_6153);
                                                                                    _6338 = dot(float3(_197, _198, _199), float3(_6230, _6231, _6232));
                                                                                    _6339 = saturate(_6338);
                                                                                    _6340 = _6221 * _6221;
                                                                                    do {
                                                                                      _6350 = _6340;
                                                                                      if (_6227 > 0.0f) {
                                                                                        _6350 = saturate(((_6227 * _6227) / ((_6335 * 3.5999999046325684f) + 0.4000000059604645f)) + _6340);
                                                                                      }
                                                                                      do {
                                                                                        _6362 = _6350;
                                                                                        _6363 = 1.0f;
                                                                                        if (_6244) {
                                                                                          _6359 = (((_6225 * 0.25f) * ((sqrt(_6350) * 3.0f) + _6225)) / (_6335 + 0.0010000000474974513f)) + _6350;
                                                                                          _6362 = _6359;
                                                                                          _6363 = (_6350 / _6359);
                                                                                        }
                                                                                        do {
                                                                                          _6383 = _6363;
                                                                                          if (_6137 < 1.0f) {
                                                                                            _6370 = sqrt((1.000100016593933f - _6137) / max(9.999999974752427e-07f, (_6137 + 1.0f)));
                                                                                            _6383 = (sqrt(_6362 / ((((_6370 * 0.25f) * ((sqrt(_6362) * 3.0f) + _6370)) / (_6335 + 0.0010000000474974513f)) + _6362)) * _6363);
                                                                                          }
                                                                                          _6387 = (((_6350 * _6336) - _6336) * _6336) + 1.0f;
                                                                                          _6390 = (_6350 / (_6387 * _6387)) * _6383;
                                                                                          _6398 = exp2(log2(1.0f - saturate(_6335)) * 5.0f);
                                                                                          _6402 = (_6398 * (1.0f - _212)) + _212;
                                                                                          _6403 = (_6398 * (1.0f - _213)) + _213;
                                                                                          _6404 = (_6398 * (1.0f - _214)) + _214;
                                                                                          _6407 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                                                          _6408 = sqrt(_6350);
                                                                                          _6409 = 1.0f - _6408;
                                                                                          _6417 = 0.5f / ((((_6409 * _6407) + _6408) * _6337) + (((_6409 * _6337) + _6408) * _6407));
                                                                                          do {
                                                                                            if (_217 < 0.007874015718698502f) {
                                                                                              _6423 = _6336 * _6336;
                                                                                              _6425 = max((1.0f - _6423), 9.999999747378752e-05f);
                                                                                              _6570 = (((((((exp2(((-0.0f - (_6423 / _6425)) / _6350) * 1.4426950216293335f) * 4.0f) / (_6425 * _6425)) + 1.0f) * (1.0f / ((_6350 * 4.0f) + 1.0f))) - _6390) * _168) + _6390);
                                                                                              _6571 = (((saturate(0.25f / ((_6339 + _1132) - (_6339 * _1132))) - _6417) * _168) + _6417);
                                                                                            } else {
                                                                                              _6449 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                                              _6450 = _6449 * _197;
                                                                                              _6451 = _6449 * _198;
                                                                                              _6452 = _6449 * _199;
                                                                                              _6455 = (abs(_6450) < abs(_6451));
                                                                                              _6456 = select(_6455, 1.0f, 0.0f);
                                                                                              _6457 = select(_6455, 0.0f, 1.0f);
                                                                                              _6458 = _6457 * _6452;
                                                                                              _6460 = -0.0f - (_6452 * _6456);
                                                                                              _6463 = (_6456 * _6451) - (_6457 * _6450);
                                                                                              _6465 = rsqrt(dot(float3(_6458, _6460, _6463), float3(_6458, _6460, _6463)));
                                                                                              _6466 = _6458 * _6465;
                                                                                              _6467 = _6465 * _6460;
                                                                                              _6468 = _6463 * _6465;
                                                                                              _6471 = (_6467 * _6452) - (_6468 * _6451);
                                                                                              _6474 = (_6468 * _6450) - (_6466 * _6452);
                                                                                              _6477 = (_6466 * _6451) - (_6467 * _6450);
                                                                                              _6479 = rsqrt(dot(float3(_6471, _6474, _6477), float3(_6471, _6474, _6477)));
                                                                                              _6483 = _168 * 4.0f;
                                                                                              _6492 = saturate(abs(_6483 + -2.5f) + -0.5f) + -0.5f;
                                                                                              _6493 = saturate(1.5f - abs(_6483 + -1.5f)) + -0.5f;
                                                                                              _6495 = rsqrt(dot(float2(_6492, _6493), float2(_6492, _6493)));
                                                                                              _6496 = _6495 * _6492;
                                                                                              _6497 = _6495 * _6493;
                                                                                              _6504 = ((_6471 * _6479) * _6496) + (_6497 * _6466);
                                                                                              _6505 = ((_6474 * _6479) * _6496) + (_6497 * _6467);
                                                                                              _6506 = ((_6477 * _6479) * _6496) + (_6497 * _6468);
                                                                                              _6509 = (_6505 * _199) - (_6506 * _198);
                                                                                              _6512 = (_6506 * _197) - (_6504 * _199);
                                                                                              _6515 = (_6504 * _198) - (_6505 * _197);
                                                                                              _6519 = rsqrt((dot(float3(_445, _446, _444), float3(_6230, _6231, _6232)) * 2.0f) + 2.0f);
                                                                                              _6523 = dot(float3(_6504, _6505, _6506), float3(_6230, _6231, _6232));
                                                                                              _6524 = dot(float3(_6504, _6505, _6506), float3(_445, _446, _444));
                                                                                              _6527 = dot(float3(_6509, _6512, _6515), float3(_6230, _6231, _6232));
                                                                                              _6528 = dot(float3(_6509, _6512, _6515), float3(_445, _446, _444));
                                                                                              _6534 = min(max((_6221 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                                              _6538 = min(max((_6221 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                                              _6539 = _6538 * _6534;
                                                                                              _6540 = ((_6524 + _6523) * _6519) * _6538;
                                                                                              _6541 = ((_6528 + _6527) * _6519) * _6534;
                                                                                              _6542 = _6539 * saturate(_6519 * (_1131 + _6338));
                                                                                              _6543 = dot(float3(_6540, _6541, _6542), float3(_6540, _6541, _6542));
                                                                                              _6548 = _6534 * _6524;
                                                                                              _6549 = _6538 * _6528;
                                                                                              _6557 = _6534 * _6523;
                                                                                              _6558 = _6538 * _6527;
                                                                                              _6570 = (((_6539 * _6539) * _6539) / (_6543 * _6543));
                                                                                              _6571 = saturate(0.5f / ((sqrt(((_6557 * _6557) + (_6339 * _6339)) + (_6558 * _6558)) * _6407) + (sqrt(((_6549 * _6549) + (_6548 * _6548)) + (_6407 * _6407)) * _6339)));
                                                                                            }
                                                                                            _6573 = (_6570 * _6339) * _6571;
                                                                                            _6588 = saturate((_6338 + 0.5f) * 0.6666666865348816f);
                                                                                            _6595 = _6049 * _1645;
                                                                                            _6596 = _6050 * _1645;
                                                                                            _6597 = _6051 * _1645;
                                                                                            _6610 = ((((_6094 * _6595) * (1.0f - _6402)) * _6588) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _6339)) + _1582;
                                                                                            _6611 = ((((_6094 * _6596) * (1.0f - _6403)) * _6588) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _6339)) + _1583;
                                                                                            _6612 = ((((_6094 * _6597) * (1.0f - _6404)) * _6588) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _6339)) + _1584;
                                                                                            if (_3972 > 0.0f) {
                                                                                              _6616 = (_3972 * _1347) * select(_6091, (_6087 * _1274), _6087);
                                                                                              _9262 = _6610;
                                                                                              _9263 = _6611;
                                                                                              _9264 = _6612;
                                                                                              _9265 = ((((_6616 * _6595) * _6402) * _6573) + _1585);
                                                                                              _9266 = ((((_6616 * _6596) * _6403) * _6573) + _1586);
                                                                                              _9267 = ((((_6616 * _6597) * _6404) * _6573) + _1587);
                                                                                            } else {
                                                                                              _9262 = _6610;
                                                                                              _9263 = _6611;
                                                                                              _9264 = _6612;
                                                                                              _9265 = _1585;
                                                                                              _9266 = _1586;
                                                                                              _9267 = _1587;
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
                                                                      break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                                break;
                                                              }
                                                              _5924 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                                              do {
                                                                if (_5921 == 0) {
                                                                  _5938 = _5924.x;
                                                                } else {
                                                                  if (_5921 == 1) {
                                                                    _5938 = _5924.y;
                                                                  } else {
                                                                    if (_5921 == 2) {
                                                                      _5938 = _5924.z;
                                                                    } else {
                                                                      _5938 = _5924.w;
                                                                    }
                                                                  }
                                                                }
                                                                _5942 = ((_5938 * _5938) * _4058);
                                                                [branch]
                                                                if (!(_5942 == 0.0f)) {
                                                                  do {
                                                                    _6049 = _5901;
                                                                    _6050 = _5902;
                                                                    _6051 = _5903;
                                                                    [branch]
                                                                    if (!(((_3942 & 1) == 0) || (!_4089))) {
                                                                      _5959 = max(max(_5901, _5902), _5903);
                                                                      do {
                                                                        _5969 = _5901;
                                                                        _5970 = _5902;
                                                                        _5971 = _5903;
                                                                        if (_5959 > 0.0f) {
                                                                          _5969 = saturate(_5901 / _5959);
                                                                          _5970 = saturate(_5902 / _5959);
                                                                          _5971 = saturate(_5903 / _5959);
                                                                        }
                                                                        _5972 = (_5970 < _5971);
                                                                        _5973 = select(_5972, _5971, _5970);
                                                                        _5974 = select(_5972, _5970, _5971);
                                                                        _5975 = select(_5972, -1.0f, 0.0f);
                                                                        _5976 = (_5969 < _5973);
                                                                        _5978 = select(_5976, _5973, _5969);
                                                                        _5979 = select(_5976, _5969, _5973);
                                                                        _5983 = _5978 - select((_5979 < _5974), _5979, _5974);
                                                                        _5989 = abs(select(_5976, (-0.3333333432674408f - _5975), _5975) + ((_5979 - _5974) / ((_5983 * 6.0f) + 9.999999682655225e-21f)));
                                                                        do {
                                                                          _6002 = _5989;
                                                                          if (_5989 < 0.6666666865348816f) {
                                                                            _6002 = ((saturate(((float)((uint)((uint)(((uint)(_3942) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5989 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5989)) + _5989);
                                                                          }
                                                                          _6003 = saturate((_5983 / (_5978 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3942) >> 1) & 255)))) * 0.003921499941498041f));
                                                                          _6004 = saturate(_5978);
                                                                          do {
                                                                            _6031 = _6004;
                                                                            _6032 = _6004;
                                                                            _6033 = _6004;
                                                                            if (!(_6003 <= 0.0f)) {
                                                                              _6007 = saturate(_6002);
                                                                              _6011 = select(((_6007 * 360.0f) >= 360.0f), 0.0f, (_6007 * 6.0f));
                                                                              _6012 = int(_6011);
                                                                              _6014 = _6011 - float((int)(_6012));
                                                                              _6016 = _6004 * (1.0f - _6003);
                                                                              _6019 = (1.0f - (_6014 * _6003)) * _6004;
                                                                              _6023 = (1.0f - ((1.0f - _6014) * _6003)) * _6004;
                                                                              switch (_6012) {
                                                                                case 0: {
                                                                                  _6031 = _6004;
                                                                                  _6032 = _6023;
                                                                                  _6033 = _6016;
                                                                                  break;
                                                                                }
                                                                                case 1: {
                                                                                  _6031 = _6019;
                                                                                  _6032 = _6004;
                                                                                  _6033 = _6016;
                                                                                  break;
                                                                                }
                                                                                case 2: {
                                                                                  _6031 = _6016;
                                                                                  _6032 = _6004;
                                                                                  _6033 = _6023;
                                                                                  break;
                                                                                }
                                                                                case 3: {
                                                                                  _6031 = _6016;
                                                                                  _6032 = _6019;
                                                                                  _6033 = _6004;
                                                                                  break;
                                                                                }
                                                                                case 4: {
                                                                                  _6031 = _6023;
                                                                                  _6032 = _6016;
                                                                                  _6033 = _6004;
                                                                                  break;
                                                                                }
                                                                                case 5: {
                                                                                  _6031 = _6004;
                                                                                  _6032 = _6016;
                                                                                  _6033 = _6019;
                                                                                  break;
                                                                                }
                                                                                default: {
                                                                                  _6031 = 0.0f;
                                                                                  _6032 = 0.0f;
                                                                                  _6033 = 0.0f;
                                                                                  break;
                                                                                }
                                                                              }
                                                                            }
                                                                            _6034 = _6031 * _5959;
                                                                            _6035 = _6032 * _5959;
                                                                            _6036 = _6033 * _5959;
                                                                            _6038 = saturate(_5881 * 1.0101009607315063f);
                                                                            _6049 = ((_6038 * (_5901 - _6034)) + _6034);
                                                                            _6050 = ((_6038 * (_5902 - _6035)) + _6035);
                                                                            _6051 = (lerp(_6036, _5903, _6038));
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    }
                                                                    do {
                                                                      _6087 = _5942;
                                                                      [branch]
                                                                      if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                        _6058 = srvLightMappingData[_1597];
                                                                        if (!(_6058 == -1)) {
                                                                          _6063 = srvLightIndexData[_6058].nLayerIndex;
                                                                          _6065 = srvLightIndexData[_6058].vAtlasOrigin.x;
                                                                          _6066 = srvLightIndexData[_6058].vAtlasOrigin.y;
                                                                          _6068 = srvLightIndexData[_6058].vScreenOrigin.x;
                                                                          _6069 = srvLightIndexData[_6058].vScreenOrigin.y;
                                                                          _6078 = ((int)(_6063 * 5)) & 31;
                                                                          _6087 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6065 + _63) - _6068)), ((int)((_6066 + _64) - _6069)), 0)))).x) & ((int)(31 << _6078)))) >> _6078)) >> 1)))) * 0.06666667014360428f) * _5942);
                                                                        } else {
                                                                          _6087 = _5942;
                                                                        }
                                                                      }
                                                                      _6091 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                      _6094 = select(_6091, (_6087 * _1274), _6087);
                                                                      _6096 = _4041 * _4040;
                                                                      _6097 = _4042 * _4040;
                                                                      _6098 = _4043 * _4040;
                                                                      _6099 = _3973 * _3910;
                                                                      _6100 = _3973 * _3911;
                                                                      _6101 = _3973 * _3912;
                                                                      _6102 = _6096 + _6099;
                                                                      _6103 = _6097 + _6100;
                                                                      _6104 = _6098 + _6101;
                                                                      _6105 = _6096 - _6099;
                                                                      _6106 = _6097 - _6100;
                                                                      _6107 = _6098 - _6101;
                                                                      _6108 = (_3973 > 0.0f);
                                                                      _6109 = dot(float3(_6102, _6103, _6104), float3(_6102, _6103, _6104));
                                                                      _6110 = rsqrt(_6109);
                                                                      do {
                                                                        [branch]
                                                                        if (_6108) {
                                                                          _6113 = rsqrt(dot(float3(_6105, _6106, _6107), float3(_6105, _6106, _6107)));
                                                                          _6114 = _6113 * _6110;
                                                                          _6116 = dot(float3(_6102, _6103, _6104), float3(_6105, _6106, _6107)) * _6114;
                                                                          _6135 = (_6114 / ((_6114 + 0.5f) + (_6116 * 0.5f)));
                                                                          _6136 = (((dot(float3(_197, _198, _199), float3(_6105, _6106, _6107)) * _6113) + (dot(float3(_197, _198, _199), float3(_6102, _6103, _6104)) * _6110)) * 0.5f);
                                                                          _6137 = _6116;
                                                                        } else {
                                                                          _6135 = (1.0f / (_6109 + 1.0f));
                                                                          _6136 = dot(float3(_197, _198, _199), float3((_6110 * _6102), (_6110 * _6103), (_6110 * _6104)));
                                                                          _6137 = 1.0f;
                                                                        }
                                                                        do {
                                                                          _6153 = _6136;
                                                                          if (_3975 > 0.0f) {
                                                                            _6143 = sqrt(saturate((_3975 * _3975) * _6135));
                                                                            if (_6136 < _6143) {
                                                                              _6148 = max(_6136, (-0.0f - _6143)) + _6143;
                                                                              _6153 = ((_6148 * _6148) / (_6143 * 4.0f));
                                                                            } else {
                                                                              _6153 = _6136;
                                                                            }
                                                                          }
                                                                          do {
                                                                            _6213 = _6102;
                                                                            _6214 = _6103;
                                                                            _6215 = _6104;
                                                                            if (_6108) {
                                                                              _6155 = -0.0f - _445;
                                                                              _6156 = -0.0f - _446;
                                                                              _6157 = -0.0f - _444;
                                                                              _6159 = dot(float3(_6155, _6156, _6157), float3(_197, _198, _199)) * 2.0f;
                                                                              _6163 = _6155 - (_6159 * _197);
                                                                              _6164 = _6156 - (_6159 * _198);
                                                                              _6165 = _6157 - (_6159 * _199);
                                                                              _6166 = _6105 - _6102;
                                                                              _6167 = _6106 - _6103;
                                                                              _6168 = _6107 - _6104;
                                                                              _6169 = dot(float3(_6163, _6164, _6165), float3(_6166, _6167, _6168));
                                                                              _6175 = sqrt(((_6166 * _6166) + (_6167 * _6167)) + (_6168 * _6168));
                                                                              _6184 = saturate(((dot(float3(_6163, _6164, _6165), float3(_6102, _6103, _6104)) * _6169) - dot(float3(_6102, _6103, _6104), float3(_6166, _6167, _6168))) / ((_6175 * _6175) - (_6169 * _6169)));
                                                                              _6188 = (_6184 * _6166) + _6102;
                                                                              _6189 = (_6184 * _6167) + _6103;
                                                                              _6190 = (_6184 * _6168) + _6104;
                                                                              _6191 = dot(float3(_6188, _6189, _6190), float3(_6163, _6164, _6165));
                                                                              _6195 = (_6191 * _6163) - _6188;
                                                                              _6196 = (_6191 * _6164) - _6189;
                                                                              _6197 = (_6191 * _6165) - _6190;
                                                                              _6205 = saturate(0.009999999776482582f / sqrt(((_6195 * _6195) + (_6196 * _6196)) + (_6197 * _6197)));
                                                                              _6213 = ((_6205 * _6195) + _6188);
                                                                              _6214 = ((_6205 * _6196) + _6189);
                                                                              _6215 = ((_6205 * _6197) + _6190);
                                                                            }
                                                                            _6217 = rsqrt(dot(float3(_6213, _6214, _6215), float3(_6213, _6214, _6215)));
                                                                            _6218 = _6217 * _6213;
                                                                            _6219 = _6217 * _6214;
                                                                            _6220 = _6217 * _6215;
                                                                            _6221 = _219 * _219;
                                                                            _6225 = saturate((_3975 * (1.0f - _6221)) * _6217);
                                                                            _6227 = saturate(_6217 * f16tof32(_3924));
                                                                            _6229 = rsqrt(dot(float3(_6096, _6097, _6098), float3(_6096, _6097, _6098)));
                                                                            _6230 = _6229 * _6096;
                                                                            _6231 = _6229 * _6097;
                                                                            _6232 = _6229 * _6098;
                                                                            _6233 = dot(float3(_197, _198, _199), float3(_6218, _6219, _6220));
                                                                            _6234 = dot(float3(_445, _446, _444), float3(_6218, _6219, _6220));
                                                                            _6237 = rsqrt((_6234 * 2.0f) + 2.0f);
                                                                            _6244 = (_6225 > 0.0f);
                                                                            do {
                                                                              _6335 = saturate((_6237 * _6234) + _6237);
                                                                              _6336 = saturate(_6237 * (_1131 + _6233));
                                                                              if (_6244) {
                                                                                _6248 = sqrt(1.0f - (_6225 * _6225));
                                                                                _6250 = (_6233 * 2.0f) * _1131;
                                                                                _6251 = _6250 - _6234;
                                                                                if (!(!(_6251 >= _6248))) {
                                                                                  _6335 = abs(_1131);
                                                                                  _6336 = 1.0f;
                                                                                } else {
                                                                                  _6259 = rsqrt(1.0f - (_6251 * _6251)) * _6225;
                                                                                  _6262 = _6259 * (_1131 - (_6251 * _6233));
                                                                                  _6263 = _1131 * _1131;
                                                                                  _6268 = _6259 * (((_6263 * 2.0f) + -1.0f) - (_6251 * _6234));
                                                                                  _6277 = sqrt(saturate((((1.0f - (_6233 * _6233)) - _6263) - (_6234 * _6234)) + (_6250 * _6234)));
                                                                                  _6278 = _6277 * _6259;
                                                                                  _6281 = ((_1131 * 2.0f) * _6259) * _6277;
                                                                                  _6283 = (_6248 * _6233) + _1131;
                                                                                  _6284 = _6283 + _6262;
                                                                                  _6285 = _6248 * _6234;
                                                                                  _6287 = (_6285 + 1.0f) + _6268;
                                                                                  _6288 = _6278 * _6287;
                                                                                  _6289 = _6284 * _6287;
                                                                                  _6290 = _6281 * _6284;
                                                                                  _6295 = (((_6284 * 0.25f) * _6281) - (_6288 * 0.5f)) * _6289;
                                                                                  _6309 = (((_6290 - (_6288 * 2.0f)) * _6290) + (_6288 * _6288)) + ((((-0.5f - ((_6287 + _6285) * 0.5f)) * _6289) + ((_6287 * _6287) * _6283)) * _6284);
                                                                                  _6314 = (_6295 * 2.0f) / ((_6309 * _6309) + (_6295 * _6295));
                                                                                  _6315 = _6309 * _6314;
                                                                                  _6317 = 1.0f - (_6295 * _6314);
                                                                                  _6323 = ((_6315 * _6281) + _6285) + (_6317 * _6268);
                                                                                  _6326 = rsqrt((_6323 * 2.0f) + 2.0f);
                                                                                  _6335 = saturate((_6323 * _6326) + _6326);
                                                                                  _6336 = saturate(((_6283 + (_6315 * _6278)) + (_6317 * _6262)) * _6326);
                                                                                }
                                                                              }
                                                                              _6337 = saturate(_6153);
                                                                              _6338 = dot(float3(_197, _198, _199), float3(_6230, _6231, _6232));
                                                                              _6339 = saturate(_6338);
                                                                              _6340 = _6221 * _6221;
                                                                              do {
                                                                                _6350 = _6340;
                                                                                if (_6227 > 0.0f) {
                                                                                  _6350 = saturate(((_6227 * _6227) / ((_6335 * 3.5999999046325684f) + 0.4000000059604645f)) + _6340);
                                                                                }
                                                                                do {
                                                                                  _6362 = _6350;
                                                                                  _6363 = 1.0f;
                                                                                  if (_6244) {
                                                                                    _6359 = (((_6225 * 0.25f) * ((sqrt(_6350) * 3.0f) + _6225)) / (_6335 + 0.0010000000474974513f)) + _6350;
                                                                                    _6362 = _6359;
                                                                                    _6363 = (_6350 / _6359);
                                                                                  }
                                                                                  do {
                                                                                    _6383 = _6363;
                                                                                    if (_6137 < 1.0f) {
                                                                                      _6370 = sqrt((1.000100016593933f - _6137) / max(9.999999974752427e-07f, (_6137 + 1.0f)));
                                                                                      _6383 = (sqrt(_6362 / ((((_6370 * 0.25f) * ((sqrt(_6362) * 3.0f) + _6370)) / (_6335 + 0.0010000000474974513f)) + _6362)) * _6363);
                                                                                    }
                                                                                    _6387 = (((_6350 * _6336) - _6336) * _6336) + 1.0f;
                                                                                    _6390 = (_6350 / (_6387 * _6387)) * _6383;
                                                                                    _6398 = exp2(log2(1.0f - saturate(_6335)) * 5.0f);
                                                                                    _6402 = (_6398 * (1.0f - _212)) + _212;
                                                                                    _6403 = (_6398 * (1.0f - _213)) + _213;
                                                                                    _6404 = (_6398 * (1.0f - _214)) + _214;
                                                                                    _6407 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                                                    _6408 = sqrt(_6350);
                                                                                    _6409 = 1.0f - _6408;
                                                                                    _6417 = 0.5f / ((((_6409 * _6407) + _6408) * _6337) + (((_6409 * _6337) + _6408) * _6407));
                                                                                    do {
                                                                                      if (_217 < 0.007874015718698502f) {
                                                                                        _6423 = _6336 * _6336;
                                                                                        _6425 = max((1.0f - _6423), 9.999999747378752e-05f);
                                                                                        _6570 = (((((((exp2(((-0.0f - (_6423 / _6425)) / _6350) * 1.4426950216293335f) * 4.0f) / (_6425 * _6425)) + 1.0f) * (1.0f / ((_6350 * 4.0f) + 1.0f))) - _6390) * _168) + _6390);
                                                                                        _6571 = (((saturate(0.25f / ((_6339 + _1132) - (_6339 * _1132))) - _6417) * _168) + _6417);
                                                                                      } else {
                                                                                        _6449 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                                        _6450 = _6449 * _197;
                                                                                        _6451 = _6449 * _198;
                                                                                        _6452 = _6449 * _199;
                                                                                        _6455 = (abs(_6450) < abs(_6451));
                                                                                        _6456 = select(_6455, 1.0f, 0.0f);
                                                                                        _6457 = select(_6455, 0.0f, 1.0f);
                                                                                        _6458 = _6457 * _6452;
                                                                                        _6460 = -0.0f - (_6452 * _6456);
                                                                                        _6463 = (_6456 * _6451) - (_6457 * _6450);
                                                                                        _6465 = rsqrt(dot(float3(_6458, _6460, _6463), float3(_6458, _6460, _6463)));
                                                                                        _6466 = _6458 * _6465;
                                                                                        _6467 = _6465 * _6460;
                                                                                        _6468 = _6463 * _6465;
                                                                                        _6471 = (_6467 * _6452) - (_6468 * _6451);
                                                                                        _6474 = (_6468 * _6450) - (_6466 * _6452);
                                                                                        _6477 = (_6466 * _6451) - (_6467 * _6450);
                                                                                        _6479 = rsqrt(dot(float3(_6471, _6474, _6477), float3(_6471, _6474, _6477)));
                                                                                        _6483 = _168 * 4.0f;
                                                                                        _6492 = saturate(abs(_6483 + -2.5f) + -0.5f) + -0.5f;
                                                                                        _6493 = saturate(1.5f - abs(_6483 + -1.5f)) + -0.5f;
                                                                                        _6495 = rsqrt(dot(float2(_6492, _6493), float2(_6492, _6493)));
                                                                                        _6496 = _6495 * _6492;
                                                                                        _6497 = _6495 * _6493;
                                                                                        _6504 = ((_6471 * _6479) * _6496) + (_6497 * _6466);
                                                                                        _6505 = ((_6474 * _6479) * _6496) + (_6497 * _6467);
                                                                                        _6506 = ((_6477 * _6479) * _6496) + (_6497 * _6468);
                                                                                        _6509 = (_6505 * _199) - (_6506 * _198);
                                                                                        _6512 = (_6506 * _197) - (_6504 * _199);
                                                                                        _6515 = (_6504 * _198) - (_6505 * _197);
                                                                                        _6519 = rsqrt((dot(float3(_445, _446, _444), float3(_6230, _6231, _6232)) * 2.0f) + 2.0f);
                                                                                        _6523 = dot(float3(_6504, _6505, _6506), float3(_6230, _6231, _6232));
                                                                                        _6524 = dot(float3(_6504, _6505, _6506), float3(_445, _446, _444));
                                                                                        _6527 = dot(float3(_6509, _6512, _6515), float3(_6230, _6231, _6232));
                                                                                        _6528 = dot(float3(_6509, _6512, _6515), float3(_445, _446, _444));
                                                                                        _6534 = min(max((_6221 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                                        _6538 = min(max((_6221 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                                        _6539 = _6538 * _6534;
                                                                                        _6540 = ((_6524 + _6523) * _6519) * _6538;
                                                                                        _6541 = ((_6528 + _6527) * _6519) * _6534;
                                                                                        _6542 = _6539 * saturate(_6519 * (_1131 + _6338));
                                                                                        _6543 = dot(float3(_6540, _6541, _6542), float3(_6540, _6541, _6542));
                                                                                        _6548 = _6534 * _6524;
                                                                                        _6549 = _6538 * _6528;
                                                                                        _6557 = _6534 * _6523;
                                                                                        _6558 = _6538 * _6527;
                                                                                        _6570 = (((_6539 * _6539) * _6539) / (_6543 * _6543));
                                                                                        _6571 = saturate(0.5f / ((sqrt(((_6557 * _6557) + (_6339 * _6339)) + (_6558 * _6558)) * _6407) + (sqrt(((_6549 * _6549) + (_6548 * _6548)) + (_6407 * _6407)) * _6339)));
                                                                                      }
                                                                                      _6573 = (_6570 * _6339) * _6571;
                                                                                      _6588 = saturate((_6338 + 0.5f) * 0.6666666865348816f);
                                                                                      _6595 = _6049 * _1645;
                                                                                      _6596 = _6050 * _1645;
                                                                                      _6597 = _6051 * _1645;
                                                                                      _6610 = ((((_6094 * _6595) * (1.0f - _6402)) * _6588) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _6339)) + _1582;
                                                                                      _6611 = ((((_6094 * _6596) * (1.0f - _6403)) * _6588) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _6339)) + _1583;
                                                                                      _6612 = ((((_6094 * _6597) * (1.0f - _6404)) * _6588) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _6339)) + _1584;
                                                                                      if (_3972 > 0.0f) {
                                                                                        _6616 = (_3972 * _1347) * select(_6091, (_6087 * _1274), _6087);
                                                                                        _9262 = _6610;
                                                                                        _9263 = _6611;
                                                                                        _9264 = _6612;
                                                                                        _9265 = ((((_6616 * _6595) * _6402) * _6573) + _1585);
                                                                                        _9266 = ((((_6616 * _6596) * _6403) * _6573) + _1586);
                                                                                        _9267 = ((((_6616 * _6597) * _6404) * _6573) + _1587);
                                                                                      } else {
                                                                                        _9262 = _6610;
                                                                                        _9263 = _6611;
                                                                                        _9264 = _6612;
                                                                                        _9265 = _1585;
                                                                                        _9266 = _1586;
                                                                                        _9267 = _1587;
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
                                                                  _9262 = _1582;
                                                                  _9263 = _1583;
                                                                  _9264 = _1584;
                                                                  _9265 = _1585;
                                                                  _9266 = _1586;
                                                                  _9267 = _1587;
                                                                }
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } else {
                                                            _9262 = _1582;
                                                            _9263 = _1583;
                                                            _9264 = _1584;
                                                            _9265 = _1585;
                                                            _9266 = _1586;
                                                            _9267 = _1587;
                                                          }
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    if (_1628 == 8) {
                                                      _6634 = asfloat(srvLightInfoProperties.Load3(_1596)).x;
                                                      _6635 = asfloat(srvLightInfoProperties.Load3(_1596)).y;
                                                      _6636 = asfloat(srvLightInfoProperties.Load3(_1596)).z;
                                                      _6639 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 12u)))).x;
                                                      _6640 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 12u)))).y;
                                                      _6641 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 12u)))).z;
                                                      _6644 = asfloat(srvLightInfoProperties.Load(((int)(_1596 + 24u))));
                                                      _6647 = asint(srvLightInfoProperties.Load(((int)(_1596 + 28u))));
                                                      _6650 = asint(srvLightInfoProperties.Load(((int)(_1596 + 32u))));
                                                      _6653 = asint(srvLightInfoProperties.Load(((int)(_1596 + 44u))));
                                                      _6662 = ((float)((uint)((uint)(((uint)(_6650) >> 8) & 255)))) * 0.003921499941498041f;
                                                      _6665 = f16tof32(_6653);
                                                      _6672 = min(max(dot(float3((_231 - _6634), (_232 - _6635), (_233 - _6636)), float3(_6639, _6640, _6641)), (-0.0f - _6644)), _6644);
                                                      _6677 = (_6634 - _231) + (_6672 * _6639);
                                                      _6679 = (_6635 - _232) + (_6672 * _6640);
                                                      _6681 = (_6636 + _230) + (_6672 * _6641);
                                                      _6682 = dot(float3(_6677, _6679, _6681), float3(_6677, _6679, _6681));
                                                      _6683 = rsqrt(_6682);
                                                      _6685 = _6677 * _6683;
                                                      _6686 = _6679 * _6683;
                                                      _6687 = _6681 * _6683;
                                                      _6690 = max(0.0f, ((_6683 * _6682) - abs(_6665)));
                                                      _6691 = _6690 * f16tof32(((uint)((uint)(_6653) >> 16)));
                                                      _6692 = _6691 * _6691;
                                                      _6695 = saturate(1.0f - (_6692 * _6692));
                                                      _6702 = (_6695 * _6695) / (select((_6665 < 0.0f), (_6692 * 16.0f), (_6690 * _6690)) + 1.0f);
                                                      [branch]
                                                      if (!(_6702 == 0.0f)) {
                                                        do {
                                                          _6740 = _6702;
                                                          [branch]
                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                            _6711 = srvLightMappingData[_1597];
                                                            if (!(_6711 == -1)) {
                                                              _6716 = srvLightIndexData[_6711].nLayerIndex;
                                                              _6718 = srvLightIndexData[_6711].vAtlasOrigin.x;
                                                              _6719 = srvLightIndexData[_6711].vAtlasOrigin.y;
                                                              _6721 = srvLightIndexData[_6711].vScreenOrigin.x;
                                                              _6722 = srvLightIndexData[_6711].vScreenOrigin.y;
                                                              _6731 = ((int)(_6716 * 5)) & 31;
                                                              _6740 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6718 + _63) - _6721)), ((int)((_6719 + _64) - _6722)), 0)))).x) & ((int)(31 << _6731)))) >> _6731)) >> 1)))) * 0.06666667014360428f) * _6702);
                                                            } else {
                                                              _6740 = _6702;
                                                            }
                                                          }
                                                          _6744 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                          _6747 = select(_6744, (_6740 * _1274), _6740);
                                                          _6749 = dot(float3(_197, _198, _199), float3(_6685, _6686, _6687));
                                                          _6750 = dot(float3(_445, _446, _444), float3(_6685, _6686, _6687));
                                                          _6753 = rsqrt((_6750 * 2.0f) + 2.0f);
                                                          _6756 = saturate(_6753 * (_1131 + _6749));
                                                          _6760 = saturate(_6749);
                                                          _6761 = _219 * _219;
                                                          _6762 = _6761 * _6761;
                                                          _6766 = (((_6756 * _6762) - _6756) * _6756) + 1.0f;
                                                          _6768 = _6762 / (_6766 * _6766);
                                                          _6776 = exp2(log2(1.0f - saturate(saturate((_6753 * _6750) + _6753))) * 5.0f);
                                                          _6780 = (_6776 * (1.0f - _212)) + _212;
                                                          _6781 = (_6776 * (1.0f - _213)) + _213;
                                                          _6782 = (_6776 * (1.0f - _214)) + _214;
                                                          _6785 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                          _6786 = sqrt(_6762);
                                                          _6787 = 1.0f - _6786;
                                                          _6795 = 0.5f / ((((_6787 * _6785) + _6786) * _6760) + (((_6787 * _6760) + _6786) * _6785));
                                                          do {
                                                            if (_217 < 0.007874015718698502f) {
                                                              _6801 = _6756 * _6756;
                                                              _6803 = max((1.0f - _6801), 9.999999747378752e-05f);
                                                              _6941 = (((((((exp2(((-0.0f - (_6801 / _6803)) / _6762) * 1.4426950216293335f) * 4.0f) / (_6803 * _6803)) + 1.0f) * (1.0f / ((_6762 * 4.0f) + 1.0f))) - _6768) * _168) + _6768);
                                                              _6942 = (((saturate(0.25f / ((_6760 + _1132) - (_6760 * _1132))) - _6795) * _168) + _6795);
                                                            } else {
                                                              _6827 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                              _6828 = _6827 * _197;
                                                              _6829 = _6827 * _198;
                                                              _6830 = _6827 * _199;
                                                              _6833 = (abs(_6828) < abs(_6829));
                                                              _6834 = select(_6833, 1.0f, 0.0f);
                                                              _6835 = select(_6833, 0.0f, 1.0f);
                                                              _6836 = _6835 * _6830;
                                                              _6838 = -0.0f - (_6830 * _6834);
                                                              _6841 = (_6834 * _6829) - (_6835 * _6828);
                                                              _6843 = rsqrt(dot(float3(_6836, _6838, _6841), float3(_6836, _6838, _6841)));
                                                              _6844 = _6836 * _6843;
                                                              _6845 = _6843 * _6838;
                                                              _6846 = _6841 * _6843;
                                                              _6849 = (_6845 * _6830) - (_6846 * _6829);
                                                              _6852 = (_6846 * _6828) - (_6844 * _6830);
                                                              _6855 = (_6844 * _6829) - (_6845 * _6828);
                                                              _6857 = rsqrt(dot(float3(_6849, _6852, _6855), float3(_6849, _6852, _6855)));
                                                              _6861 = _168 * 4.0f;
                                                              _6870 = saturate(abs(_6861 + -2.5f) + -0.5f) + -0.5f;
                                                              _6871 = saturate(1.5f - abs(_6861 + -1.5f)) + -0.5f;
                                                              _6873 = rsqrt(dot(float2(_6870, _6871), float2(_6870, _6871)));
                                                              _6874 = _6873 * _6870;
                                                              _6875 = _6873 * _6871;
                                                              _6882 = ((_6849 * _6857) * _6874) + (_6875 * _6844);
                                                              _6883 = ((_6852 * _6857) * _6874) + (_6875 * _6845);
                                                              _6884 = ((_6855 * _6857) * _6874) + (_6875 * _6846);
                                                              _6887 = (_6883 * _199) - (_6884 * _198);
                                                              _6890 = (_6884 * _197) - (_6882 * _199);
                                                              _6893 = (_6882 * _198) - (_6883 * _197);
                                                              _6894 = dot(float3(_6882, _6883, _6884), float3(_6685, _6686, _6687));
                                                              _6895 = dot(float3(_6882, _6883, _6884), float3(_445, _446, _444));
                                                              _6898 = dot(float3(_6887, _6890, _6893), float3(_6685, _6686, _6687));
                                                              _6899 = dot(float3(_6887, _6890, _6893), float3(_445, _446, _444));
                                                              _6905 = min(max((_6761 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                              _6909 = min(max((_6761 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                              _6910 = _6909 * _6905;
                                                              _6911 = ((_6895 + _6894) * _6753) * _6909;
                                                              _6912 = ((_6899 + _6898) * _6753) * _6905;
                                                              _6913 = _6910 * _6756;
                                                              _6914 = dot(float3(_6911, _6912, _6913), float3(_6911, _6912, _6913));
                                                              _6919 = _6905 * _6895;
                                                              _6920 = _6909 * _6899;
                                                              _6928 = _6905 * _6894;
                                                              _6929 = _6909 * _6898;
                                                              _6941 = (((_6910 * _6910) * _6910) / (_6914 * _6914));
                                                              _6942 = saturate(0.5f / ((sqrt(((_6928 * _6928) + (_6760 * _6760)) + (_6929 * _6929)) * _6785) + (sqrt(((_6920 * _6920) + (_6919 * _6919)) + (_6785 * _6785)) * _6760)));
                                                            }
                                                            _6944 = (_6941 * _6760) * _6942;
                                                            _6959 = saturate((_6749 + 0.5f) * 0.6666666865348816f);
                                                            _6966 = f16tof32(((uint)((uint)(_6647) >> 16))) * _1645;
                                                            _6967 = f16tof32(_6647) * _1645;
                                                            _6968 = f16tof32(((uint)((uint)(_6650) >> 16))) * _1645;
                                                            _6981 = ((((_6747 * _6966) * (1.0f - _6780)) * _6959) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _6760)) + _1582;
                                                            _6982 = ((((_6747 * _6967) * (1.0f - _6781)) * _6959) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _6760)) + _1583;
                                                            _6983 = ((((_6747 * _6968) * (1.0f - _6782)) * _6959) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _6760)) + _1584;
                                                            if (_6662 > 0.0f) {
                                                              _6987 = (_6662 * _1347) * select(_6744, (_6740 * _1274), _6740);
                                                              _9262 = _6981;
                                                              _9263 = _6982;
                                                              _9264 = _6983;
                                                              _9265 = ((((_6987 * _6966) * _6780) * _6944) + _1585);
                                                              _9266 = ((((_6987 * _6967) * _6781) * _6944) + _1586);
                                                              _9267 = ((((_6987 * _6968) * _6782) * _6944) + _1587);
                                                            } else {
                                                              _9262 = _6981;
                                                              _9263 = _6982;
                                                              _9264 = _6983;
                                                              _9265 = _1585;
                                                              _9266 = _1586;
                                                              _9267 = _1587;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        _9262 = _1582;
                                                        _9263 = _1583;
                                                        _9264 = _1584;
                                                        _9265 = _1585;
                                                        _9266 = _1586;
                                                        _9267 = _1587;
                                                      }
                                                    } else {
                                                      if (_1628 == 9) {
                                                        _7005 = asfloat(srvLightInfoProperties.Load4(_1596)).x;
                                                        _7006 = asfloat(srvLightInfoProperties.Load4(_1596)).y;
                                                        _7007 = asfloat(srvLightInfoProperties.Load4(_1596)).w;
                                                        _7010 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).x;
                                                        _7011 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).y;
                                                        _7012 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).w;
                                                        _7015 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).x;
                                                        _7016 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).y;
                                                        _7017 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).w;
                                                        _7020 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 48u)))).x;
                                                        _7021 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 48u)))).y;
                                                        _7022 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 48u)))).w;
                                                        _7025 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 64u)))).x;
                                                        _7026 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 64u)))).y;
                                                        _7027 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 64u)))).z;
                                                        _7030 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 76u)))).x;
                                                        _7031 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 76u)))).y;
                                                        _7032 = asfloat(srvLightInfoProperties.Load3(((int)(_1596 + 76u)))).z;
                                                        _7035 = asint(srvLightInfoProperties.Load(((int)(_1596 + 88u))));
                                                        _7038 = asint(srvLightInfoProperties.Load(((int)(_1596 + 92u))));
                                                        _7041 = asint(srvLightInfoProperties.Load(((int)(_1596 + 100u))));
                                                        _7044 = asint(srvLightInfoProperties.Load(((int)(_1596 + 104u))));
                                                        _7047 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).x;
                                                        _7048 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).y;
                                                        _7049 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).z;
                                                        _7050 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 108u)))).w;
                                                        _7053 = asint(srvLightInfoProperties.Load(((int)(_1596 + 124u))));
                                                        _7056 = asint(srvLightInfoProperties.Load(((int)(_1596 + 128u))));
                                                        _7059 = asint(srvLightInfoProperties.Load(((int)(_1596 + 132u))));
                                                        _7062 = asint(srvLightInfoProperties.Load(((int)(_1596 + 136u))));
                                                        _7065 = asint(srvLightInfoProperties.Load(((int)(_1596 + 140u))));
                                                        _7068 = asint(srvLightInfoProperties.Load(((int)(_1596 + 144u))));
                                                        _7071 = asint(srvLightInfoProperties.Load(((int)(_1596 + 148u))));
                                                        _7074 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 152u)))).x;
                                                        _7075 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 152u)))).y;
                                                        _7076 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 152u)))).z;
                                                        _7077 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 152u)))).w;
                                                        _7080 = asint(srvLightInfoProperties.Load(((int)(_1596 + 168u))));
                                                        _7083 = asint(srvLightInfoProperties.Load(((int)(_1596 + 172u))));
                                                        _7086 = asint(srvLightInfoProperties.Load(((int)(_1596 + 180u))));
                                                        _7088 = f16tof32(((uint)((uint)(_7035) >> 16)));
                                                        _7089 = f16tof32(_7035);
                                                        _7091 = f16tof32(((uint)((uint)(_7038) >> 16)));
                                                        _7095 = ((float)((uint)((uint)(((uint)(_7038) >> 8) & 255)))) * 0.003921499941498041f;
                                                        _7096 = f16tof32(_7041);
                                                        _7098 = f16tof32(((uint)((uint)(_7044) >> 16)));
                                                        _7102 = f16tof32(_7053);
                                                        _7106 = _7059 & 65535;
                                                        _7122 = f16tof32(((uint)((uint)(_7083) >> 16)));
                                                        _7123 = f16tof32(_7083);
                                                        _7125 = f16tof32(((uint)((uint)(_7086) >> 16)));
                                                        _7126 = 1.0f / _7125;
                                                        _7127 = _7125 + -1.0f;
                                                        _7128 = f16tof32(_7086);
                                                        _7129 = _7025 - _231;
                                                        _7130 = _7026 - _232;
                                                        _7131 = _7027 + _230;
                                                        _7132 = dot(float3(_7129, _7130, _7131), float3(_7129, _7130, _7131));
                                                        _7133 = rsqrt(_7132);
                                                        _7134 = _7133 * _7132;
                                                        _7135 = _7133 * _7129;
                                                        _7136 = _7133 * _7130;
                                                        _7137 = _7133 * _7131;
                                                        _7140 = max(0.0f, (_7134 - abs(_7102)));
                                                        _7141 = _7140 * f16tof32(((uint)((uint)(_7053) >> 16)));
                                                        _7142 = _7141 * _7141;
                                                        _7145 = saturate(1.0f - (_7142 * _7142));
                                                        _7156 = mad(_233, _7017, mad(_232, _7012, (_7007 * _231))) + _7022;
                                                        _7160 = saturate(1.0f - dot(float3(_197, _198, _199), float3(_7135, _7136, _7137))) * f16tof32(_7080);
                                                        _7167 = ((_7156 * _197) * _7160) + _231;
                                                        _7168 = ((_7156 * _198) * _7160) + _232;
                                                        _7169 = ((_7156 * _199) * _7160) - _230;
                                                        _7181 = mad(_7169, _7017, mad(_7168, _7012, (_7167 * _7007))) + _7022;
                                                        _7182 = 1.0f / _7181;
                                                        _7183 = _7182 * (mad(_7169, _7015, mad(_7168, _7010, (_7167 * _7005))) + _7020);
                                                        _7184 = _7182 * (mad(_7169, _7016, mad(_7168, _7011, (_7167 * _7006))) + _7021);
                                                        _7187 = (_7183 * _7047) + _7048;
                                                        _7188 = (_7184 * _7047) + _7048;
                                                        _7191 = _7187 - saturate(_7187);
                                                        _7192 = _7188 - saturate(_7188);
                                                        _7199 = saturate((sqrt((_7191 * _7191) + (_7192 * _7192)) * _7049) + _7050);
                                                        _7201 = 1.0f - (_7199 * _7199);
                                                        _7207 = (_7201 * _7201) * (((float)((bool)(uint)((_7181 - f16tof32(((uint)((uint)(_7056) >> 16)))) > 0.0f))) * ((_7145 * _7145) / (select((_7102 < 0.0f), (_7142 * 16.0f), (_7140 * _7140)) + 1.0f)));
                                                        _7209 = ((_1594 & 3584) == 0);
                                                        do {
                                                          _8050 = 0.0f;
                                                          _8051 = 1.0f;
                                                          if (!((!(_7207 > 0.0f)) || _7209)) {
                                                            _7217 = 1.0f - saturate(f16tof32(_7056) * _7181);
                                                            _7218 = saturate(_7183);
                                                            _7219 = saturate(_7184);
                                                            do {
                                                              _7482 = 1.0f;
                                                              _7483 = 0.0f;
                                                              _7484 = _7217;
                                                              [branch]
                                                              if (!((_1594 & 1024) == 0)) {
                                                                _7224 = ((_7218 * _7127) + 0.5f) * _7126;
                                                                _7226 = ((_7219 * _7127) + 0.5f) * _7126;
                                                                _7227 = _7217 + f16tof32(((uint)((uint)(_7080) >> 16)));
                                                                Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7059) >> 16))];
                                                                _7230 = saturate(_7227);
                                                                _7234 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                #if FIRSTLIGHT_ISFAST_ENABLED
                                                                if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                  _7243 = RenoDX_ISFASTShadowAngle(
                                                                      uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 6u);
                                                                } else {
                                                                  _7243 = frac(frac(dot(float2(((_7234 * 32.665000915527344f) + _125), ((_7234 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                }
                                                                #else
                                                                _7243 = frac(frac(dot(float2(((_7234 * 32.665000915527344f) + _125), ((_7234 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                #endif
                                                                _7244 = sin(_7243);
                                                                _7245 = cos(_7243);
                                                                _7246 = cbSharedPerViewData.nFrameCounter & 3;
                                                                _7251 = sqrt((float((int)(_7246)) * 0.25f) + 0.125f) * _7122;
                                                                _7260 = (_global_7[min((uint)(((int)(0u + (_7246 * 2)))), 127u)]) * _7251;
                                                                _7261 = (_global_7[min((uint)(((int)(1u + (_7246 * 2)))), 127u)]) * _7251;
                                                                _7263 = -0.0f - _7244;
                                                                _7268 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7260, _7261), float2(_7245, _7244)) + _7224), (dot(float2(_7260, _7261), float2(_7263, _7245)) + _7226)));
                                                                _7273 = _7268.x - _7230;
                                                                _7275 = select((_7273 < 0.0f), 0.0f, 1.0f);
                                                                _7277 = _7268.y - _7230;
                                                                _7279 = select((_7277 < 0.0f), 0.0f, 1.0f);
                                                                _7283 = _7268.z - _7230;
                                                                _7285 = select((_7283 < 0.0f), 0.0f, 1.0f);
                                                                _7289 = _7268.w - _7230;
                                                                _7291 = select((_7289 < 0.0f), 0.0f, 1.0f);
                                                                _7298 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                _7303 = sqrt((float((int)(_7298)) * 0.25f) + 0.125f) * _7122;
                                                                _7312 = (_global_7[min((uint)(((int)(0u + (_7298 * 2)))), 127u)]) * _7303;
                                                                _7313 = (_global_7[min((uint)(((int)(1u + (_7298 * 2)))), 127u)]) * _7303;
                                                                _7319 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7312, _7313), float2(_7245, _7244)) + _7224), (dot(float2(_7312, _7313), float2(_7263, _7245)) + _7226)));
                                                                _7324 = _7319.x - _7230;
                                                                _7326 = select((_7324 < 0.0f), 0.0f, 1.0f);
                                                                _7330 = _7319.y - _7230;
                                                                _7332 = select((_7330 < 0.0f), 0.0f, 1.0f);
                                                                _7336 = _7319.z - _7230;
                                                                _7338 = select((_7336 < 0.0f), 0.0f, 1.0f);
                                                                _7342 = _7319.w - _7230;
                                                                _7344 = select((_7342 < 0.0f), 0.0f, 1.0f);
                                                                _7351 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                _7356 = sqrt((float((int)(_7351)) * 0.25f) + 0.125f) * _7122;
                                                                _7365 = (_global_7[min((uint)(((int)(0u + (_7351 * 2)))), 127u)]) * _7356;
                                                                _7366 = (_global_7[min((uint)(((int)(1u + (_7351 * 2)))), 127u)]) * _7356;
                                                                _7372 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7365, _7366), float2(_7245, _7244)) + _7224), (dot(float2(_7365, _7366), float2(_7263, _7245)) + _7226)));
                                                                _7377 = _7372.x - _7230;
                                                                _7379 = select((_7377 < 0.0f), 0.0f, 1.0f);
                                                                _7383 = _7372.y - _7230;
                                                                _7385 = select((_7383 < 0.0f), 0.0f, 1.0f);
                                                                _7389 = _7372.z - _7230;
                                                                _7391 = select((_7389 < 0.0f), 0.0f, 1.0f);
                                                                _7395 = _7372.w - _7230;
                                                                _7397 = select((_7395 < 0.0f), 0.0f, 1.0f);
                                                                _7404 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                _7409 = sqrt((float((int)(_7404)) * 0.25f) + 0.125f) * _7122;
                                                                _7418 = (_global_7[min((uint)(((int)(0u + (_7404 * 2)))), 127u)]) * _7409;
                                                                _7419 = (_global_7[min((uint)(((int)(1u + (_7404 * 2)))), 127u)]) * _7409;
                                                                _7425 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7418, _7419), float2(_7245, _7244)) + _7224), (dot(float2(_7418, _7419), float2(_7263, _7245)) + _7226)));
                                                                _7430 = _7425.x - _7230;
                                                                _7432 = select((_7430 < 0.0f), 0.0f, 1.0f);
                                                                _7436 = _7425.y - _7230;
                                                                _7438 = select((_7436 < 0.0f), 0.0f, 1.0f);
                                                                _7442 = _7425.z - _7230;
                                                                _7444 = select((_7442 < 0.0f), 0.0f, 1.0f);
                                                                _7448 = _7425.w - _7230;
                                                                _7450 = select((_7448 < 0.0f), 0.0f, 1.0f);
                                                                _7451 = ((((((((((((((_7275 + _7279) + _7285) + _7291) + _7326) + _7332) + _7338) + _7344) + _7379) + _7385) + _7391) + _7397) + _7432) + _7438) + _7444) + _7450;
                                                                _7462 = (saturate(_7451 * 0.0625f) * 2.0f) + -1.0f;
                                                                _7468 = float((int)(((int)(uint)((int)(_7462 > 0.0f))) - ((int)(uint)((int)(_7462 < 0.0f)))));
                                                                _7470 = 1.0f - (_7468 * _7462);
                                                                _7472 = (_7470 * _7470) * _7470;
                                                                _7479 = 0.5f - ((_7468 * 0.5f) * ((1.0f - _7472) - ((_7470 - _7472) * saturate(((1.0f / _7230) * (1.0f / _7451)) * ((((((((((((((((_7275 * _7273) + (_7279 * _7277)) + (_7285 * _7283)) + (_7291 * _7289)) + (_7326 * _7324)) + (_7332 * _7330)) + (_7338 * _7336)) + (_7344 * _7342)) + (_7379 * _7377)) + (_7385 * _7383)) + (_7391 * _7389)) + (_7397 * _7395)) + (_7432 * _7430)) + (_7438 * _7436)) + (_7444 * _7442)) + (_7450 * _7448))))));
                                                                [branch]
                                                                if (!(_7128 < 1.0f)) {
                                                                  _7952 = _7128;
                                                                  _7953 = _7479;
                                                                  do {
                                                                    _8050 = _7952;
                                                                    _8051 = _7953;
                                                                    [branch]
                                                                    if (!((_1594 & 2048) == 0)) {
                                                                      Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7062) >> 16))];
                                                                      _7959 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_7183, _7184), 0.0f);
                                                                      if (_7959.x > 0.0f) {
                                                                        Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_7062 & 65535))];
                                                                        _7966 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_7183, _7184), 0.0f);
                                                                        _7980 = mad(saturate(((log2(_7134) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                        _7981 = max(9.999999747378752e-06f, _7959.x);
                                                                        _7982 = _7966.x / _7981;
                                                                        _7983 = _7966.y / _7981;
                                                                        _7985 = _7966.w / _7981;
                                                                        _7990 = ((0.375f - _7983) * 4.999999873689376e-06f) + _7983;
                                                                        _7993 = -0.0f - _7982;
                                                                        _7994 = mad(_7993, _7990, (_7966.z / _7981));
                                                                        _7996 = 1.0f / mad(_7993, _7982, _7990);
                                                                        _7997 = _7996 * _7994;
                                                                        _8002 = _7980 - _7982;
                                                                        _8007 = (((_7980 * _7980) - _7990) - (_7997 * _8002)) / mad((-0.0f - _7994), _7997, mad((-0.0f - _7990), _7990, (((0.375f - _7985) * 4.999999873689376e-06f) + _7985)));
                                                                        _8009 = (_7996 * _8002) - (_8007 * _7997);
                                                                        _8012 = 1.0f / _8007;
                                                                        _8013 = _8009 * _8012;
                                                                        _8018 = sqrt(((_8013 * _8013) * 0.25f) - ((1.0f - dot(float2(_8009, _8007), float2(_7982, _7990))) * _8012));
                                                                        _8020 = (_8013 * -0.5f) - _8018;
                                                                        _8022 = _8018 - (_8013 * 0.5f);
                                                                        _8024 = select((_8020 < _7980), 1.0f, 0.0f);
                                                                        _8029 = (_8024 + -0.05000000074505806f) / (_8020 - _7980);
                                                                        _8035 = (((select((_8022 < _7980), 1.0f, 0.0f) - _8024) / (_8022 - _8020)) - _8029) / (_8022 - _7980);
                                                                        _8037 = _8029 - (_8035 * _8020);
                                                                        _8050 = _7952;
                                                                        _8051 = (exp2((_7959.x * -1.4426950216293335f) * saturate((dot(float2(_7982, _7990), float2((_8037 - (_8035 * _7980)), _8035)) + 0.05000000074505806f) - (_8037 * _7980))) * _7953);
                                                                      } else {
                                                                        _8050 = _7952;
                                                                        _8051 = _7953;
                                                                      }
                                                                    }
                                                                    break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                  // Native completed depth-gather shadow bypasses the fallback path.
                                                                  break;
                                                                } else {
                                                                  _7482 = _7479;
                                                                  _7483 = _7128;
                                                                  _7484 = _7227;
                                                                }
                                                              }
                                                              _7487 = (_7218 * _7074) + _7076;
                                                              _7488 = (_7219 * _7075) + _7077;
                                                              do {
                                                                _7947 = 1.0f;
                                                                if (!((_1594 & 512) == 0)) {
                                                                  Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                                                  _7497 = saturate(_7484);
                                                                  _7501 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _7510 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 7u);
                                                                  } else {
                                                                    _7510 = frac(frac(dot(float2(((_7501 * 32.665000915527344f) + _125), ((_7501 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _7510 = frac(frac(dot(float2(((_7501 * 32.665000915527344f) + _125), ((_7501 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _7511 = sin(_7510);
                                                                  _7512 = cos(_7510);
                                                                  _7517 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_7487, _7488), 0.0f))).x) > _7497), 1.0f, 0.0f);
                                                                  _7518 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _7523 = sqrt((float((int)(_7518)) * 0.25f) + 0.125f) * _7123;
                                                                  _7532 = (_global_7[min((uint)(((int)(0u + (_7518 * 2)))), 127u)]) * _7523;
                                                                  _7533 = (_global_7[min((uint)(((int)(1u + (_7518 * 2)))), 127u)]) * _7523;
                                                                  _7535 = -0.0f - _7511;
                                                                  _7537 = dot(float2(_7532, _7533), float2(_7512, _7511)) + _7487;
                                                                  _7538 = dot(float2(_7532, _7533), float2(_7535, _7512)) + _7488;
                                                                  _7540 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7537, _7538));
                                                                  _7544 = _7537 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                  _7545 = _7538 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                  _7548 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _7076);
                                                                  _7549 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _7077);
                                                                  _7554 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_7074 + _7076)) + 0.5f);
                                                                  _7555 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_7075 + _7077)) + 0.5f);
                                                                  _7558 = floor(_7544 + -0.5f);
                                                                  _7559 = floor(_7545 + 0.5f);
                                                                  _7561 = floor(_7544 + 0.5f);
                                                                  _7563 = floor(_7545 + -0.5f);
                                                                  _7564 = (_7558 < _7548);
                                                                  _7565 = (_7559 < _7549);
                                                                  do {
                                                                    if (!(_7564 || _7565)) {
                                                                      if ((_7558 >= _7554) || (_7559 >= _7555)) {
                                                                        _7574 = _7517;
                                                                      } else {
                                                                        _7574 = _7540.x;
                                                                      }
                                                                    } else {
                                                                      _7574 = _7517;
                                                                    }
                                                                    _7575 = (_7561 < _7548);
                                                                    do {
                                                                      if (!(_7575 || _7565)) {
                                                                        if ((_7561 >= _7554) || (_7559 >= _7555)) {
                                                                          _7583 = _7517;
                                                                        } else {
                                                                          _7583 = _7540.y;
                                                                        }
                                                                      } else {
                                                                        _7583 = _7517;
                                                                      }
                                                                      _7584 = (_7563 < _7549);
                                                                      do {
                                                                        if (!(_7575 || _7584)) {
                                                                          if ((_7561 >= _7554) || (_7563 >= _7555)) {
                                                                            _7592 = _7517;
                                                                          } else {
                                                                            _7592 = _7540.z;
                                                                          }
                                                                        } else {
                                                                          _7592 = _7517;
                                                                        }
                                                                        do {
                                                                          if (!(_7564 || _7584)) {
                                                                            if ((_7558 >= _7554) || (_7563 >= _7555)) {
                                                                              _7600 = _7517;
                                                                            } else {
                                                                              _7600 = _7540.w;
                                                                            }
                                                                          } else {
                                                                            _7600 = _7517;
                                                                          }
                                                                          _7601 = _7574 - _7497;
                                                                          _7603 = select((_7601 < 0.0f), 0.0f, 1.0f);
                                                                          _7605 = _7583 - _7497;
                                                                          _7607 = select((_7605 < 0.0f), 0.0f, 1.0f);
                                                                          _7611 = _7592 - _7497;
                                                                          _7613 = select((_7611 < 0.0f), 0.0f, 1.0f);
                                                                          _7617 = _7600 - _7497;
                                                                          _7619 = select((_7617 < 0.0f), 0.0f, 1.0f);
                                                                          _7626 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                          _7631 = sqrt((float((int)(_7626)) * 0.25f) + 0.125f) * _7123;
                                                                          _7640 = (_global_7[min((uint)(((int)(0u + (_7626 * 2)))), 127u)]) * _7631;
                                                                          _7641 = (_global_7[min((uint)(((int)(1u + (_7626 * 2)))), 127u)]) * _7631;
                                                                          _7644 = dot(float2(_7640, _7641), float2(_7512, _7511)) + _7487;
                                                                          _7645 = dot(float2(_7640, _7641), float2(_7535, _7512)) + _7488;
                                                                          _7647 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7644, _7645));
                                                                          _7651 = _7644 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                          _7652 = _7645 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                          _7655 = floor(_7651 + -0.5f);
                                                                          _7656 = floor(_7652 + 0.5f);
                                                                          _7658 = floor(_7651 + 0.5f);
                                                                          _7660 = floor(_7652 + -0.5f);
                                                                          _7661 = (_7655 < _7548);
                                                                          _7662 = (_7656 < _7549);
                                                                          do {
                                                                            if (!(_7661 || _7662)) {
                                                                              if ((_7655 >= _7554) || (_7656 >= _7555)) {
                                                                                _7671 = _7517;
                                                                              } else {
                                                                                _7671 = _7647.x;
                                                                              }
                                                                            } else {
                                                                              _7671 = _7517;
                                                                            }
                                                                            _7672 = (_7658 < _7548);
                                                                            do {
                                                                              if (!(_7672 || _7662)) {
                                                                                if ((_7658 >= _7554) || (_7656 >= _7555)) {
                                                                                  _7680 = _7517;
                                                                                } else {
                                                                                  _7680 = _7647.y;
                                                                                }
                                                                              } else {
                                                                                _7680 = _7517;
                                                                              }
                                                                              _7681 = (_7660 < _7549);
                                                                              do {
                                                                                if (!(_7672 || _7681)) {
                                                                                  if ((_7658 >= _7554) || (_7660 >= _7555)) {
                                                                                    _7689 = _7517;
                                                                                  } else {
                                                                                    _7689 = _7647.z;
                                                                                  }
                                                                                } else {
                                                                                  _7689 = _7517;
                                                                                }
                                                                                do {
                                                                                  if (!(_7661 || _7681)) {
                                                                                    if ((_7655 >= _7554) || (_7660 >= _7555)) {
                                                                                      _7697 = _7517;
                                                                                    } else {
                                                                                      _7697 = _7647.w;
                                                                                    }
                                                                                  } else {
                                                                                    _7697 = _7517;
                                                                                  }
                                                                                  _7698 = _7671 - _7497;
                                                                                  _7700 = select((_7698 < 0.0f), 0.0f, 1.0f);
                                                                                  _7704 = _7680 - _7497;
                                                                                  _7706 = select((_7704 < 0.0f), 0.0f, 1.0f);
                                                                                  _7710 = _7689 - _7497;
                                                                                  _7712 = select((_7710 < 0.0f), 0.0f, 1.0f);
                                                                                  _7716 = _7697 - _7497;
                                                                                  _7718 = select((_7716 < 0.0f), 0.0f, 1.0f);
                                                                                  _7725 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                  _7730 = sqrt((float((int)(_7725)) * 0.25f) + 0.125f) * _7123;
                                                                                  _7739 = (_global_7[min((uint)(((int)(0u + (_7725 * 2)))), 127u)]) * _7730;
                                                                                  _7740 = (_global_7[min((uint)(((int)(1u + (_7725 * 2)))), 127u)]) * _7730;
                                                                                  _7743 = dot(float2(_7739, _7740), float2(_7512, _7511)) + _7487;
                                                                                  _7744 = dot(float2(_7739, _7740), float2(_7535, _7512)) + _7488;
                                                                                  _7746 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7743, _7744));
                                                                                  _7750 = _7743 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                  _7751 = _7744 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                  _7754 = floor(_7750 + -0.5f);
                                                                                  _7755 = floor(_7751 + 0.5f);
                                                                                  _7757 = floor(_7750 + 0.5f);
                                                                                  _7759 = floor(_7751 + -0.5f);
                                                                                  _7760 = (_7754 < _7548);
                                                                                  _7761 = (_7755 < _7549);
                                                                                  do {
                                                                                    if (!(_7760 || _7761)) {
                                                                                      if ((_7754 >= _7554) || (_7755 >= _7555)) {
                                                                                        _7770 = _7517;
                                                                                      } else {
                                                                                        _7770 = _7746.x;
                                                                                      }
                                                                                    } else {
                                                                                      _7770 = _7517;
                                                                                    }
                                                                                    _7771 = (_7757 < _7548);
                                                                                    do {
                                                                                      if (!(_7771 || _7761)) {
                                                                                        if ((_7757 >= _7554) || (_7755 >= _7555)) {
                                                                                          _7779 = _7517;
                                                                                        } else {
                                                                                          _7779 = _7746.y;
                                                                                        }
                                                                                      } else {
                                                                                        _7779 = _7517;
                                                                                      }
                                                                                      _7780 = (_7759 < _7549);
                                                                                      do {
                                                                                        if (!(_7771 || _7780)) {
                                                                                          if ((_7757 >= _7554) || (_7759 >= _7555)) {
                                                                                            _7788 = _7517;
                                                                                          } else {
                                                                                            _7788 = _7746.z;
                                                                                          }
                                                                                        } else {
                                                                                          _7788 = _7517;
                                                                                        }
                                                                                        do {
                                                                                          if (!(_7760 || _7780)) {
                                                                                            if ((_7754 >= _7554) || (_7759 >= _7555)) {
                                                                                              _7796 = _7517;
                                                                                            } else {
                                                                                              _7796 = _7746.w;
                                                                                            }
                                                                                          } else {
                                                                                            _7796 = _7517;
                                                                                          }
                                                                                          _7797 = _7770 - _7497;
                                                                                          _7799 = select((_7797 < 0.0f), 0.0f, 1.0f);
                                                                                          _7803 = _7779 - _7497;
                                                                                          _7805 = select((_7803 < 0.0f), 0.0f, 1.0f);
                                                                                          _7809 = _7788 - _7497;
                                                                                          _7811 = select((_7809 < 0.0f), 0.0f, 1.0f);
                                                                                          _7815 = _7796 - _7497;
                                                                                          _7817 = select((_7815 < 0.0f), 0.0f, 1.0f);
                                                                                          _7824 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                          _7829 = sqrt((float((int)(_7824)) * 0.25f) + 0.125f) * _7123;
                                                                                          _7838 = (_global_7[min((uint)(((int)(0u + (_7824 * 2)))), 127u)]) * _7829;
                                                                                          _7839 = (_global_7[min((uint)(((int)(1u + (_7824 * 2)))), 127u)]) * _7829;
                                                                                          _7842 = dot(float2(_7838, _7839), float2(_7512, _7511)) + _7487;
                                                                                          _7843 = dot(float2(_7838, _7839), float2(_7535, _7512)) + _7488;
                                                                                          _7845 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7842, _7843));
                                                                                          _7849 = _7842 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                          _7850 = _7843 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                          _7853 = floor(_7849 + -0.5f);
                                                                                          _7854 = floor(_7850 + 0.5f);
                                                                                          _7856 = floor(_7849 + 0.5f);
                                                                                          _7858 = floor(_7850 + -0.5f);
                                                                                          _7859 = (_7853 < _7548);
                                                                                          _7860 = (_7854 < _7549);
                                                                                          do {
                                                                                            if (!(_7859 || _7860)) {
                                                                                              if ((_7853 >= _7554) || (_7854 >= _7555)) {
                                                                                                _7869 = _7517;
                                                                                              } else {
                                                                                                _7869 = _7845.x;
                                                                                              }
                                                                                            } else {
                                                                                              _7869 = _7517;
                                                                                            }
                                                                                            _7870 = (_7856 < _7548);
                                                                                            do {
                                                                                              if (!(_7870 || _7860)) {
                                                                                                if ((_7856 >= _7554) || (_7854 >= _7555)) {
                                                                                                  _7878 = _7517;
                                                                                                } else {
                                                                                                  _7878 = _7845.y;
                                                                                                }
                                                                                              } else {
                                                                                                _7878 = _7517;
                                                                                              }
                                                                                              _7879 = (_7858 < _7549);
                                                                                              do {
                                                                                                if (!(_7870 || _7879)) {
                                                                                                  if ((_7856 >= _7554) || (_7858 >= _7555)) {
                                                                                                    _7887 = _7517;
                                                                                                  } else {
                                                                                                    _7887 = _7845.z;
                                                                                                  }
                                                                                                } else {
                                                                                                  _7887 = _7517;
                                                                                                }
                                                                                                do {
                                                                                                  if (!(_7859 || _7879)) {
                                                                                                    if ((_7853 >= _7554) || (_7858 >= _7555)) {
                                                                                                      _7895 = _7517;
                                                                                                    } else {
                                                                                                      _7895 = _7845.w;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _7895 = _7517;
                                                                                                  }
                                                                                                  _7896 = _7869 - _7497;
                                                                                                  _7898 = select((_7896 < 0.0f), 0.0f, 1.0f);
                                                                                                  _7902 = _7878 - _7497;
                                                                                                  _7904 = select((_7902 < 0.0f), 0.0f, 1.0f);
                                                                                                  _7908 = _7887 - _7497;
                                                                                                  _7910 = select((_7908 < 0.0f), 0.0f, 1.0f);
                                                                                                  _7914 = _7895 - _7497;
                                                                                                  _7916 = select((_7914 < 0.0f), 0.0f, 1.0f);
                                                                                                  _7917 = ((((((((((((((_7607 + _7603) + _7613) + _7619) + _7700) + _7706) + _7712) + _7718) + _7799) + _7805) + _7811) + _7817) + _7898) + _7904) + _7910) + _7916;
                                                                                                  _7928 = (saturate(_7917 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                  _7934 = float((int)(((int)(uint)((int)(_7928 > 0.0f))) - ((int)(uint)((int)(_7928 < 0.0f)))));
                                                                                                  _7936 = 1.0f - (_7934 * _7928);
                                                                                                  _7938 = (_7936 * _7936) * _7936;
                                                                                                  _7947 = (0.5f - ((_7934 * 0.5f) * ((1.0f - _7938) - ((_7936 - _7938) * saturate(((1.0f / _7497) * (1.0f / _7917)) * ((((((((((((((((_7607 * _7605) + (_7603 * _7601)) + (_7613 * _7611)) + (_7619 * _7617)) + (_7700 * _7698)) + (_7706 * _7704)) + (_7712 * _7710)) + (_7718 * _7716)) + (_7799 * _7797)) + (_7805 * _7803)) + (_7811 * _7809)) + (_7817 * _7815)) + (_7898 * _7896)) + (_7904 * _7902)) + (_7910 * _7908)) + (_7916 * _7914)))))));
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
                                                                _7952 = _7483;
                                                                _7953 = (lerp(_7947, _7482, _7483));
                                                                [branch]
                                                                if (!((_1594 & 2048) == 0)) {
                                                                  Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_7062) >> 16))];
                                                                  _7959 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_7183, _7184), 0.0f);
                                                                  if (_7959.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_7062 & 65535))];
                                                                    _7966 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_7183, _7184), 0.0f);
                                                                    _7980 = mad(saturate(((log2(_7134) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                    _7981 = max(9.999999747378752e-06f, _7959.x);
                                                                    _7982 = _7966.x / _7981;
                                                                    _7983 = _7966.y / _7981;
                                                                    _7985 = _7966.w / _7981;
                                                                    _7990 = ((0.375f - _7983) * 4.999999873689376e-06f) + _7983;
                                                                    _7993 = -0.0f - _7982;
                                                                    _7994 = mad(_7993, _7990, (_7966.z / _7981));
                                                                    _7996 = 1.0f / mad(_7993, _7982, _7990);
                                                                    _7997 = _7996 * _7994;
                                                                    _8002 = _7980 - _7982;
                                                                    _8007 = (((_7980 * _7980) - _7990) - (_7997 * _8002)) / mad((-0.0f - _7994), _7997, mad((-0.0f - _7990), _7990, (((0.375f - _7985) * 4.999999873689376e-06f) + _7985)));
                                                                    _8009 = (_7996 * _8002) - (_8007 * _7997);
                                                                    _8012 = 1.0f / _8007;
                                                                    _8013 = _8009 * _8012;
                                                                    _8018 = sqrt(((_8013 * _8013) * 0.25f) - ((1.0f - dot(float2(_8009, _8007), float2(_7982, _7990))) * _8012));
                                                                    _8020 = (_8013 * -0.5f) - _8018;
                                                                    _8022 = _8018 - (_8013 * 0.5f);
                                                                    _8024 = select((_8020 < _7980), 1.0f, 0.0f);
                                                                    _8029 = (_8024 + -0.05000000074505806f) / (_8020 - _7980);
                                                                    _8035 = (((select((_8022 < _7980), 1.0f, 0.0f) - _8024) / (_8022 - _8020)) - _8029) / (_8022 - _7980);
                                                                    _8037 = _8029 - (_8035 * _8020);
                                                                    _8050 = _7952;
                                                                    _8051 = (exp2((_7959.x * -1.4426950216293335f) * saturate((dot(float2(_7982, _7990), float2((_8037 - (_8035 * _7980)), _8035)) + 0.05000000074505806f) - (_8037 * _7980))) * _7953);
                                                                  } else {
                                                                    _8050 = _7952;
                                                                    _8051 = _7953;
                                                                  }
                                                                } else {
                                                                  _8050 = _7952;
                                                                  _8051 = _7953;
                                                                }
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          }
                                                          do {
                                                            _8072 = _7088;
                                                            _8073 = _7089;
                                                            _8074 = _7091;
                                                            [branch]
                                                            if (!(_7106 == 0)) {
                                                              Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _7106)))];
                                                              _8064 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_7183 * f16tof32(((uint)((uint)(_7068) >> 16)))) + f16tof32(((uint)((uint)(_7071) >> 16)))), ((_7184 * f16tof32(_7068)) + f16tof32(_7071))), 0.0f);
                                                              _8072 = (_8064.x * _7088);
                                                              _8073 = (_8064.y * _7089);
                                                              _8074 = (_8064.z * _7091);
                                                            }
                                                            _8075 = _8051 * _7207;
                                                            [branch]
                                                            if (!(_8075 == 0.0f)) {
                                                              do {
                                                                _8093 = GetDeferredSoftShadowChannel(_1597);
                                                                if (_8093 < 0) {
                                                                      _8118 = _8075;
                                                                      do {
                                                                        _9262 = _1582;
                                                                        _9263 = _1583;
                                                                        _9264 = _1584;
                                                                        _9265 = _1585;
                                                                        _9266 = _1586;
                                                                        _9267 = _1587;
                                                                        [branch]
                                                                        if (_8118 > 0.0f) {
                                                                          do {
                                                                            _8224 = _8072;
                                                                            _8225 = _8073;
                                                                            _8226 = _8074;
                                                                            if (!(((_7065 & 1) == 0) || _7209)) {
                                                                              _8134 = max(max(_8072, _8073), _8074);
                                                                              do {
                                                                                _8144 = _8072;
                                                                                _8145 = _8073;
                                                                                _8146 = _8074;
                                                                                if (_8134 > 0.0f) {
                                                                                  _8144 = saturate(_8072 / _8134);
                                                                                  _8145 = saturate(_8073 / _8134);
                                                                                  _8146 = saturate(_8074 / _8134);
                                                                                }
                                                                                _8147 = (_8145 < _8146);
                                                                                _8148 = select(_8147, _8146, _8145);
                                                                                _8149 = select(_8147, _8145, _8146);
                                                                                _8150 = select(_8147, -1.0f, 0.0f);
                                                                                _8151 = (_8144 < _8148);
                                                                                _8153 = select(_8151, _8148, _8144);
                                                                                _8154 = select(_8151, _8144, _8148);
                                                                                _8158 = _8153 - select((_8154 < _8149), _8154, _8149);
                                                                                _8164 = abs(select(_8151, (-0.3333333432674408f - _8150), _8150) + ((_8154 - _8149) / ((_8158 * 6.0f) + 9.999999682655225e-21f)));
                                                                                do {
                                                                                  _8177 = _8164;
                                                                                  if (_8164 < 0.6666666865348816f) {
                                                                                    _8177 = ((saturate(((float)((uint)((uint)(((uint)(_7065) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8164 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8164)) + _8164);
                                                                                  }
                                                                                  _8178 = saturate((_8158 / (_8153 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7065) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                  _8179 = saturate(_8153);
                                                                                  do {
                                                                                    _8206 = _8179;
                                                                                    _8207 = _8179;
                                                                                    _8208 = _8179;
                                                                                    if (!(_8178 <= 0.0f)) {
                                                                                      _8182 = saturate(_8177);
                                                                                      _8186 = select(((_8182 * 360.0f) >= 360.0f), 0.0f, (_8182 * 6.0f));
                                                                                      _8187 = int(_8186);
                                                                                      _8189 = _8186 - float((int)(_8187));
                                                                                      _8191 = _8179 * (1.0f - _8178);
                                                                                      _8194 = (1.0f - (_8189 * _8178)) * _8179;
                                                                                      _8198 = (1.0f - ((1.0f - _8189) * _8178)) * _8179;
                                                                                      switch (_8187) {
                                                                                        case 0: {
                                                                                          _8206 = _8179;
                                                                                          _8207 = _8198;
                                                                                          _8208 = _8191;
                                                                                          break;
                                                                                        }
                                                                                        case 1: {
                                                                                          _8206 = _8194;
                                                                                          _8207 = _8179;
                                                                                          _8208 = _8191;
                                                                                          break;
                                                                                        }
                                                                                        case 2: {
                                                                                          _8206 = _8191;
                                                                                          _8207 = _8179;
                                                                                          _8208 = _8198;
                                                                                          break;
                                                                                        }
                                                                                        case 3: {
                                                                                          _8206 = _8191;
                                                                                          _8207 = _8194;
                                                                                          _8208 = _8179;
                                                                                          break;
                                                                                        }
                                                                                        case 4: {
                                                                                          _8206 = _8198;
                                                                                          _8207 = _8191;
                                                                                          _8208 = _8179;
                                                                                          break;
                                                                                        }
                                                                                        case 5: {
                                                                                          _8206 = _8179;
                                                                                          _8207 = _8191;
                                                                                          _8208 = _8194;
                                                                                          break;
                                                                                        }
                                                                                        default: {
                                                                                          _8206 = 0.0f;
                                                                                          _8207 = 0.0f;
                                                                                          _8208 = 0.0f;
                                                                                          break;
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                    _8209 = _8206 * _8134;
                                                                                    _8210 = _8207 * _8134;
                                                                                    _8211 = _8208 * _8134;
                                                                                    _8213 = saturate(_8051 * 1.0101009607315063f);
                                                                                    _8224 = ((_8213 * (_8072 - _8209)) + _8209);
                                                                                    _8225 = ((_8213 * (_8073 - _8210)) + _8210);
                                                                                    _8226 = (lerp(_8211, _8074, _8213));
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            }
                                                                            do {
                                                                              _8262 = _8118;
                                                                              [branch]
                                                                              if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                _8233 = srvLightMappingData[_1597];
                                                                                if (!(_8233 == -1)) {
                                                                                  _8238 = srvLightIndexData[_8233].nLayerIndex;
                                                                                  _8240 = srvLightIndexData[_8233].vAtlasOrigin.x;
                                                                                  _8241 = srvLightIndexData[_8233].vAtlasOrigin.y;
                                                                                  _8243 = srvLightIndexData[_8233].vScreenOrigin.x;
                                                                                  _8244 = srvLightIndexData[_8233].vScreenOrigin.y;
                                                                                  _8253 = ((int)(_8238 * 5)) & 31;
                                                                                  _8262 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8240 + _63) - _8243)), ((int)((_8241 + _64) - _8244)), 0)))).x) & ((int)(31 << _8253)))) >> _8253)) >> 1)))) * 0.06666667014360428f) * _8118);
                                                                                } else {
                                                                                  _8262 = _8118;
                                                                                }
                                                                              }
                                                                              _8266 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                              _8269 = select(_8266, (_8262 * _1274), _8262);
                                                                              _8271 = _7135 * _7134;
                                                                              _8272 = _7136 * _7134;
                                                                              _8273 = _7137 * _7134;
                                                                              _8274 = _7096 * _7030;
                                                                              _8275 = _7096 * _7031;
                                                                              _8276 = _7096 * _7032;
                                                                              _8277 = _8271 + _8274;
                                                                              _8278 = _8272 + _8275;
                                                                              _8279 = _8273 + _8276;
                                                                              _8280 = _8271 - _8274;
                                                                              _8281 = _8272 - _8275;
                                                                              _8282 = _8273 - _8276;
                                                                              _8283 = (_7096 > 0.0f);
                                                                              _8284 = dot(float3(_8277, _8278, _8279), float3(_8277, _8278, _8279));
                                                                              _8285 = rsqrt(_8284);
                                                                              do {
                                                                                [branch]
                                                                                if (_8283) {
                                                                                  _8288 = rsqrt(dot(float3(_8280, _8281, _8282), float3(_8280, _8281, _8282)));
                                                                                  _8289 = _8288 * _8285;
                                                                                  _8291 = dot(float3(_8277, _8278, _8279), float3(_8280, _8281, _8282)) * _8289;
                                                                                  _8310 = (_8289 / ((_8289 + 0.5f) + (_8291 * 0.5f)));
                                                                                  _8311 = (((dot(float3(_197, _198, _199), float3(_8280, _8281, _8282)) * _8288) + (dot(float3(_197, _198, _199), float3(_8277, _8278, _8279)) * _8285)) * 0.5f);
                                                                                  _8312 = _8291;
                                                                                } else {
                                                                                  _8310 = (1.0f / (_8284 + 1.0f));
                                                                                  _8311 = dot(float3(_197, _198, _199), float3((_8285 * _8277), (_8285 * _8278), (_8285 * _8279)));
                                                                                  _8312 = 1.0f;
                                                                                }
                                                                                do {
                                                                                  _8328 = _8311;
                                                                                  if (_7098 > 0.0f) {
                                                                                    _8318 = sqrt(saturate((_7098 * _7098) * _8310));
                                                                                    if (_8311 < _8318) {
                                                                                      _8323 = max(_8311, (-0.0f - _8318)) + _8318;
                                                                                      _8328 = ((_8323 * _8323) / (_8318 * 4.0f));
                                                                                    } else {
                                                                                      _8328 = _8311;
                                                                                    }
                                                                                  }
                                                                                  do {
                                                                                    _8388 = _8277;
                                                                                    _8389 = _8278;
                                                                                    _8390 = _8279;
                                                                                    if (_8283) {
                                                                                      _8330 = -0.0f - _445;
                                                                                      _8331 = -0.0f - _446;
                                                                                      _8332 = -0.0f - _444;
                                                                                      _8334 = dot(float3(_8330, _8331, _8332), float3(_197, _198, _199)) * 2.0f;
                                                                                      _8338 = _8330 - (_8334 * _197);
                                                                                      _8339 = _8331 - (_8334 * _198);
                                                                                      _8340 = _8332 - (_8334 * _199);
                                                                                      _8341 = _8280 - _8277;
                                                                                      _8342 = _8281 - _8278;
                                                                                      _8343 = _8282 - _8279;
                                                                                      _8344 = dot(float3(_8338, _8339, _8340), float3(_8341, _8342, _8343));
                                                                                      _8350 = sqrt(((_8341 * _8341) + (_8342 * _8342)) + (_8343 * _8343));
                                                                                      _8359 = saturate(((dot(float3(_8338, _8339, _8340), float3(_8277, _8278, _8279)) * _8344) - dot(float3(_8277, _8278, _8279), float3(_8341, _8342, _8343))) / ((_8350 * _8350) - (_8344 * _8344)));
                                                                                      _8363 = (_8359 * _8341) + _8277;
                                                                                      _8364 = (_8359 * _8342) + _8278;
                                                                                      _8365 = (_8359 * _8343) + _8279;
                                                                                      _8366 = dot(float3(_8363, _8364, _8365), float3(_8338, _8339, _8340));
                                                                                      _8370 = (_8366 * _8338) - _8363;
                                                                                      _8371 = (_8366 * _8339) - _8364;
                                                                                      _8372 = (_8366 * _8340) - _8365;
                                                                                      _8380 = saturate(0.009999999776482582f / sqrt(((_8370 * _8370) + (_8371 * _8371)) + (_8372 * _8372)));
                                                                                      _8388 = ((_8380 * _8370) + _8363);
                                                                                      _8389 = ((_8380 * _8371) + _8364);
                                                                                      _8390 = ((_8380 * _8372) + _8365);
                                                                                    }
                                                                                    _8392 = rsqrt(dot(float3(_8388, _8389, _8390), float3(_8388, _8389, _8390)));
                                                                                    _8393 = _8392 * _8388;
                                                                                    _8394 = _8392 * _8389;
                                                                                    _8395 = _8392 * _8390;
                                                                                    _8396 = _219 * _219;
                                                                                    _8400 = saturate((_7098 * (1.0f - _8396)) * _8392);
                                                                                    _8402 = saturate(_8392 * f16tof32(_7044));
                                                                                    _8404 = rsqrt(dot(float3(_8271, _8272, _8273), float3(_8271, _8272, _8273)));
                                                                                    _8405 = _8404 * _8271;
                                                                                    _8406 = _8404 * _8272;
                                                                                    _8407 = _8404 * _8273;
                                                                                    _8408 = dot(float3(_197, _198, _199), float3(_8393, _8394, _8395));
                                                                                    _8409 = dot(float3(_445, _446, _444), float3(_8393, _8394, _8395));
                                                                                    _8412 = rsqrt((_8409 * 2.0f) + 2.0f);
                                                                                    _8419 = (_8400 > 0.0f);
                                                                                    do {
                                                                                      _8510 = saturate((_8412 * _8409) + _8412);
                                                                                      _8511 = saturate(_8412 * (_1131 + _8408));
                                                                                      if (_8419) {
                                                                                        _8423 = sqrt(1.0f - (_8400 * _8400));
                                                                                        _8425 = (_8408 * 2.0f) * _1131;
                                                                                        _8426 = _8425 - _8409;
                                                                                        if (!(!(_8426 >= _8423))) {
                                                                                          _8510 = abs(_1131);
                                                                                          _8511 = 1.0f;
                                                                                        } else {
                                                                                          _8434 = rsqrt(1.0f - (_8426 * _8426)) * _8400;
                                                                                          _8437 = _8434 * (_1131 - (_8426 * _8408));
                                                                                          _8438 = _1131 * _1131;
                                                                                          _8443 = _8434 * (((_8438 * 2.0f) + -1.0f) - (_8426 * _8409));
                                                                                          _8452 = sqrt(saturate((((1.0f - (_8408 * _8408)) - _8438) - (_8409 * _8409)) + (_8425 * _8409)));
                                                                                          _8453 = _8452 * _8434;
                                                                                          _8456 = ((_1131 * 2.0f) * _8434) * _8452;
                                                                                          _8458 = (_8423 * _8408) + _1131;
                                                                                          _8459 = _8458 + _8437;
                                                                                          _8460 = _8423 * _8409;
                                                                                          _8462 = (_8460 + 1.0f) + _8443;
                                                                                          _8463 = _8453 * _8462;
                                                                                          _8464 = _8459 * _8462;
                                                                                          _8465 = _8456 * _8459;
                                                                                          _8470 = (((_8459 * 0.25f) * _8456) - (_8463 * 0.5f)) * _8464;
                                                                                          _8484 = (((_8465 - (_8463 * 2.0f)) * _8465) + (_8463 * _8463)) + ((((-0.5f - ((_8462 + _8460) * 0.5f)) * _8464) + ((_8462 * _8462) * _8458)) * _8459);
                                                                                          _8489 = (_8470 * 2.0f) / ((_8484 * _8484) + (_8470 * _8470));
                                                                                          _8490 = _8484 * _8489;
                                                                                          _8492 = 1.0f - (_8470 * _8489);
                                                                                          _8498 = ((_8490 * _8456) + _8460) + (_8492 * _8443);
                                                                                          _8501 = rsqrt((_8498 * 2.0f) + 2.0f);
                                                                                          _8510 = saturate((_8498 * _8501) + _8501);
                                                                                          _8511 = saturate(((_8458 + (_8490 * _8453)) + (_8492 * _8437)) * _8501);
                                                                                        }
                                                                                      }
                                                                                      _8512 = saturate(_8328);
                                                                                      _8513 = dot(float3(_197, _198, _199), float3(_8405, _8406, _8407));
                                                                                      _8514 = saturate(_8513);
                                                                                      _8515 = _8396 * _8396;
                                                                                      do {
                                                                                        _8525 = _8515;
                                                                                        if (_8402 > 0.0f) {
                                                                                          _8525 = saturate(((_8402 * _8402) / ((_8510 * 3.5999999046325684f) + 0.4000000059604645f)) + _8515);
                                                                                        }
                                                                                        do {
                                                                                          _8537 = _8525;
                                                                                          _8538 = 1.0f;
                                                                                          if (_8419) {
                                                                                            _8534 = (((_8400 * 0.25f) * ((sqrt(_8525) * 3.0f) + _8400)) / (_8510 + 0.0010000000474974513f)) + _8525;
                                                                                            _8537 = _8534;
                                                                                            _8538 = (_8525 / _8534);
                                                                                          }
                                                                                          do {
                                                                                            _8558 = _8538;
                                                                                            if (_8312 < 1.0f) {
                                                                                              _8545 = sqrt((1.000100016593933f - _8312) / max(9.999999974752427e-07f, (_8312 + 1.0f)));
                                                                                              _8558 = (sqrt(_8537 / ((((_8545 * 0.25f) * ((sqrt(_8537) * 3.0f) + _8545)) / (_8510 + 0.0010000000474974513f)) + _8537)) * _8538);
                                                                                            }
                                                                                            _8562 = (((_8525 * _8511) - _8511) * _8511) + 1.0f;
                                                                                            _8565 = (_8525 / (_8562 * _8562)) * _8558;
                                                                                            _8573 = exp2(log2(1.0f - saturate(_8510)) * 5.0f);
                                                                                            _8577 = (_8573 * (1.0f - _212)) + _212;
                                                                                            _8578 = (_8573 * (1.0f - _213)) + _213;
                                                                                            _8579 = (_8573 * (1.0f - _214)) + _214;
                                                                                            _8582 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                                                            _8583 = sqrt(_8525);
                                                                                            _8584 = 1.0f - _8583;
                                                                                            _8592 = 0.5f / ((((_8584 * _8582) + _8583) * _8512) + (((_8584 * _8512) + _8583) * _8582));
                                                                                            do {
                                                                                              if (_217 < 0.007874015718698502f) {
                                                                                                _8598 = _8511 * _8511;
                                                                                                _8600 = max((1.0f - _8598), 9.999999747378752e-05f);
                                                                                                _8745 = (((((((exp2(((-0.0f - (_8598 / _8600)) / _8525) * 1.4426950216293335f) * 4.0f) / (_8600 * _8600)) + 1.0f) * (1.0f / ((_8525 * 4.0f) + 1.0f))) - _8565) * _168) + _8565);
                                                                                                _8746 = (((saturate(0.25f / ((_8514 + _1132) - (_8514 * _1132))) - _8592) * _168) + _8592);
                                                                                              } else {
                                                                                                _8624 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                                                _8625 = _8624 * _197;
                                                                                                _8626 = _8624 * _198;
                                                                                                _8627 = _8624 * _199;
                                                                                                _8630 = (abs(_8625) < abs(_8626));
                                                                                                _8631 = select(_8630, 1.0f, 0.0f);
                                                                                                _8632 = select(_8630, 0.0f, 1.0f);
                                                                                                _8633 = _8632 * _8627;
                                                                                                _8635 = -0.0f - (_8627 * _8631);
                                                                                                _8638 = (_8631 * _8626) - (_8632 * _8625);
                                                                                                _8640 = rsqrt(dot(float3(_8633, _8635, _8638), float3(_8633, _8635, _8638)));
                                                                                                _8641 = _8633 * _8640;
                                                                                                _8642 = _8640 * _8635;
                                                                                                _8643 = _8638 * _8640;
                                                                                                _8646 = (_8642 * _8627) - (_8643 * _8626);
                                                                                                _8649 = (_8643 * _8625) - (_8641 * _8627);
                                                                                                _8652 = (_8641 * _8626) - (_8642 * _8625);
                                                                                                _8654 = rsqrt(dot(float3(_8646, _8649, _8652), float3(_8646, _8649, _8652)));
                                                                                                _8658 = _168 * 4.0f;
                                                                                                _8667 = saturate(abs(_8658 + -2.5f) + -0.5f) + -0.5f;
                                                                                                _8668 = saturate(1.5f - abs(_8658 + -1.5f)) + -0.5f;
                                                                                                _8670 = rsqrt(dot(float2(_8667, _8668), float2(_8667, _8668)));
                                                                                                _8671 = _8670 * _8667;
                                                                                                _8672 = _8670 * _8668;
                                                                                                _8679 = ((_8646 * _8654) * _8671) + (_8672 * _8641);
                                                                                                _8680 = ((_8649 * _8654) * _8671) + (_8672 * _8642);
                                                                                                _8681 = ((_8652 * _8654) * _8671) + (_8672 * _8643);
                                                                                                _8684 = (_8680 * _199) - (_8681 * _198);
                                                                                                _8687 = (_8681 * _197) - (_8679 * _199);
                                                                                                _8690 = (_8679 * _198) - (_8680 * _197);
                                                                                                _8694 = rsqrt((dot(float3(_445, _446, _444), float3(_8405, _8406, _8407)) * 2.0f) + 2.0f);
                                                                                                _8698 = dot(float3(_8679, _8680, _8681), float3(_8405, _8406, _8407));
                                                                                                _8699 = dot(float3(_8679, _8680, _8681), float3(_445, _446, _444));
                                                                                                _8702 = dot(float3(_8684, _8687, _8690), float3(_8405, _8406, _8407));
                                                                                                _8703 = dot(float3(_8684, _8687, _8690), float3(_445, _446, _444));
                                                                                                _8709 = min(max((_8396 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                                                _8713 = min(max((_8396 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                                                _8714 = _8713 * _8709;
                                                                                                _8715 = ((_8699 + _8698) * _8694) * _8713;
                                                                                                _8716 = ((_8703 + _8702) * _8694) * _8709;
                                                                                                _8717 = _8714 * saturate(_8694 * (_1131 + _8513));
                                                                                                _8718 = dot(float3(_8715, _8716, _8717), float3(_8715, _8716, _8717));
                                                                                                _8723 = _8709 * _8699;
                                                                                                _8724 = _8713 * _8703;
                                                                                                _8732 = _8709 * _8698;
                                                                                                _8733 = _8713 * _8702;
                                                                                                _8745 = (((_8714 * _8714) * _8714) / (_8718 * _8718));
                                                                                                _8746 = saturate(0.5f / ((sqrt(((_8732 * _8732) + (_8514 * _8514)) + (_8733 * _8733)) * _8582) + (sqrt(((_8724 * _8724) + (_8723 * _8723)) + (_8582 * _8582)) * _8514)));
                                                                                              }
                                                                                              _8748 = (_8745 * _8514) * _8746;
                                                                                              _8763 = saturate((_8513 + 0.5f) * 0.6666666865348816f);
                                                                                              _8770 = _8224 * _1645;
                                                                                              _8771 = _8225 * _1645;
                                                                                              _8772 = _8226 * _1645;
                                                                                              _8785 = ((((_8269 * _8770) * (1.0f - _8577)) * _8763) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _8514)) + _1582;
                                                                                              _8786 = ((((_8269 * _8771) * (1.0f - _8578)) * _8763) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _8514)) + _1583;
                                                                                              _8787 = ((((_8269 * _8772) * (1.0f - _8579)) * _8763) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _8514)) + _1584;
                                                                                              if (_7095 > 0.0f) {
                                                                                                _8791 = (_7095 * _1347) * select(_8266, (_8262 * _1274), _8262);
                                                                                                _9262 = _8785;
                                                                                                _9263 = _8786;
                                                                                                _9264 = _8787;
                                                                                                _9265 = ((((_8791 * _8770) * _8577) * _8748) + _1585);
                                                                                                _9266 = ((((_8791 * _8771) * _8578) * _8748) + _1586);
                                                                                                _9267 = ((((_8791 * _8772) * _8579) * _8748) + _1587);
                                                                                              } else {
                                                                                                _9262 = _8785;
                                                                                                _9263 = _8786;
                                                                                                _9264 = _8787;
                                                                                                _9265 = _1585;
                                                                                                _9266 = _1586;
                                                                                                _9267 = _1587;
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
                                                                        break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                  // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                                  break;
                                                                }
                                                                _8096 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                                                do {
                                                                  if (_8093 == 0) {
                                                                    _8110 = _8096.x;
                                                                  } else {
                                                                    if (_8093 == 1) {
                                                                      _8110 = _8096.y;
                                                                    } else {
                                                                      if (_8093 == 2) {
                                                                        _8110 = _8096.z;
                                                                      } else {
                                                                        _8110 = _8096.w;
                                                                      }
                                                                    }
                                                                  }
                                                                  _8118 = ((((_8050 * _8050) * ((_8110 * _8110) + -1.0f)) + 1.0f) * _7207);
                                                                  [branch]
                                                                  if (_8118 > 0.0f) {
                                                                    do {
                                                                      _8224 = _8072;
                                                                      _8225 = _8073;
                                                                      _8226 = _8074;
                                                                      if (!(((_7065 & 1) == 0) || _7209)) {
                                                                        _8134 = max(max(_8072, _8073), _8074);
                                                                        do {
                                                                          _8144 = _8072;
                                                                          _8145 = _8073;
                                                                          _8146 = _8074;
                                                                          if (_8134 > 0.0f) {
                                                                            _8144 = saturate(_8072 / _8134);
                                                                            _8145 = saturate(_8073 / _8134);
                                                                            _8146 = saturate(_8074 / _8134);
                                                                          }
                                                                          _8147 = (_8145 < _8146);
                                                                          _8148 = select(_8147, _8146, _8145);
                                                                          _8149 = select(_8147, _8145, _8146);
                                                                          _8150 = select(_8147, -1.0f, 0.0f);
                                                                          _8151 = (_8144 < _8148);
                                                                          _8153 = select(_8151, _8148, _8144);
                                                                          _8154 = select(_8151, _8144, _8148);
                                                                          _8158 = _8153 - select((_8154 < _8149), _8154, _8149);
                                                                          _8164 = abs(select(_8151, (-0.3333333432674408f - _8150), _8150) + ((_8154 - _8149) / ((_8158 * 6.0f) + 9.999999682655225e-21f)));
                                                                          do {
                                                                            _8177 = _8164;
                                                                            if (_8164 < 0.6666666865348816f) {
                                                                              _8177 = ((saturate(((float)((uint)((uint)(((uint)(_7065) >> 9) & 255)))) * 0.003921499941498041f) * (select((_8164 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _8164)) + _8164);
                                                                            }
                                                                            _8178 = saturate((_8158 / (_8153 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_7065) >> 1) & 255)))) * 0.003921499941498041f));
                                                                            _8179 = saturate(_8153);
                                                                            do {
                                                                              _8206 = _8179;
                                                                              _8207 = _8179;
                                                                              _8208 = _8179;
                                                                              if (!(_8178 <= 0.0f)) {
                                                                                _8182 = saturate(_8177);
                                                                                _8186 = select(((_8182 * 360.0f) >= 360.0f), 0.0f, (_8182 * 6.0f));
                                                                                _8187 = int(_8186);
                                                                                _8189 = _8186 - float((int)(_8187));
                                                                                _8191 = _8179 * (1.0f - _8178);
                                                                                _8194 = (1.0f - (_8189 * _8178)) * _8179;
                                                                                _8198 = (1.0f - ((1.0f - _8189) * _8178)) * _8179;
                                                                                switch (_8187) {
                                                                                  case 0: {
                                                                                    _8206 = _8179;
                                                                                    _8207 = _8198;
                                                                                    _8208 = _8191;
                                                                                    break;
                                                                                  }
                                                                                  case 1: {
                                                                                    _8206 = _8194;
                                                                                    _8207 = _8179;
                                                                                    _8208 = _8191;
                                                                                    break;
                                                                                  }
                                                                                  case 2: {
                                                                                    _8206 = _8191;
                                                                                    _8207 = _8179;
                                                                                    _8208 = _8198;
                                                                                    break;
                                                                                  }
                                                                                  case 3: {
                                                                                    _8206 = _8191;
                                                                                    _8207 = _8194;
                                                                                    _8208 = _8179;
                                                                                    break;
                                                                                  }
                                                                                  case 4: {
                                                                                    _8206 = _8198;
                                                                                    _8207 = _8191;
                                                                                    _8208 = _8179;
                                                                                    break;
                                                                                  }
                                                                                  case 5: {
                                                                                    _8206 = _8179;
                                                                                    _8207 = _8191;
                                                                                    _8208 = _8194;
                                                                                    break;
                                                                                  }
                                                                                  default: {
                                                                                    _8206 = 0.0f;
                                                                                    _8207 = 0.0f;
                                                                                    _8208 = 0.0f;
                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }
                                                                              _8209 = _8206 * _8134;
                                                                              _8210 = _8207 * _8134;
                                                                              _8211 = _8208 * _8134;
                                                                              _8213 = saturate(_8051 * 1.0101009607315063f);
                                                                              _8224 = ((_8213 * (_8072 - _8209)) + _8209);
                                                                              _8225 = ((_8213 * (_8073 - _8210)) + _8210);
                                                                              _8226 = (lerp(_8211, _8074, _8213));
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      do {
                                                                        _8262 = _8118;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _8233 = srvLightMappingData[_1597];
                                                                          if (!(_8233 == -1)) {
                                                                            _8238 = srvLightIndexData[_8233].nLayerIndex;
                                                                            _8240 = srvLightIndexData[_8233].vAtlasOrigin.x;
                                                                            _8241 = srvLightIndexData[_8233].vAtlasOrigin.y;
                                                                            _8243 = srvLightIndexData[_8233].vScreenOrigin.x;
                                                                            _8244 = srvLightIndexData[_8233].vScreenOrigin.y;
                                                                            _8253 = ((int)(_8238 * 5)) & 31;
                                                                            _8262 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_8240 + _63) - _8243)), ((int)((_8241 + _64) - _8244)), 0)))).x) & ((int)(31 << _8253)))) >> _8253)) >> 1)))) * 0.06666667014360428f) * _8118);
                                                                          } else {
                                                                            _8262 = _8118;
                                                                          }
                                                                        }
                                                                        _8266 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _8269 = select(_8266, (_8262 * _1274), _8262);
                                                                        _8271 = _7135 * _7134;
                                                                        _8272 = _7136 * _7134;
                                                                        _8273 = _7137 * _7134;
                                                                        _8274 = _7096 * _7030;
                                                                        _8275 = _7096 * _7031;
                                                                        _8276 = _7096 * _7032;
                                                                        _8277 = _8271 + _8274;
                                                                        _8278 = _8272 + _8275;
                                                                        _8279 = _8273 + _8276;
                                                                        _8280 = _8271 - _8274;
                                                                        _8281 = _8272 - _8275;
                                                                        _8282 = _8273 - _8276;
                                                                        _8283 = (_7096 > 0.0f);
                                                                        _8284 = dot(float3(_8277, _8278, _8279), float3(_8277, _8278, _8279));
                                                                        _8285 = rsqrt(_8284);
                                                                        do {
                                                                          [branch]
                                                                          if (_8283) {
                                                                            _8288 = rsqrt(dot(float3(_8280, _8281, _8282), float3(_8280, _8281, _8282)));
                                                                            _8289 = _8288 * _8285;
                                                                            _8291 = dot(float3(_8277, _8278, _8279), float3(_8280, _8281, _8282)) * _8289;
                                                                            _8310 = (_8289 / ((_8289 + 0.5f) + (_8291 * 0.5f)));
                                                                            _8311 = (((dot(float3(_197, _198, _199), float3(_8280, _8281, _8282)) * _8288) + (dot(float3(_197, _198, _199), float3(_8277, _8278, _8279)) * _8285)) * 0.5f);
                                                                            _8312 = _8291;
                                                                          } else {
                                                                            _8310 = (1.0f / (_8284 + 1.0f));
                                                                            _8311 = dot(float3(_197, _198, _199), float3((_8285 * _8277), (_8285 * _8278), (_8285 * _8279)));
                                                                            _8312 = 1.0f;
                                                                          }
                                                                          do {
                                                                            _8328 = _8311;
                                                                            if (_7098 > 0.0f) {
                                                                              _8318 = sqrt(saturate((_7098 * _7098) * _8310));
                                                                              if (_8311 < _8318) {
                                                                                _8323 = max(_8311, (-0.0f - _8318)) + _8318;
                                                                                _8328 = ((_8323 * _8323) / (_8318 * 4.0f));
                                                                              } else {
                                                                                _8328 = _8311;
                                                                              }
                                                                            }
                                                                            do {
                                                                              _8388 = _8277;
                                                                              _8389 = _8278;
                                                                              _8390 = _8279;
                                                                              if (_8283) {
                                                                                _8330 = -0.0f - _445;
                                                                                _8331 = -0.0f - _446;
                                                                                _8332 = -0.0f - _444;
                                                                                _8334 = dot(float3(_8330, _8331, _8332), float3(_197, _198, _199)) * 2.0f;
                                                                                _8338 = _8330 - (_8334 * _197);
                                                                                _8339 = _8331 - (_8334 * _198);
                                                                                _8340 = _8332 - (_8334 * _199);
                                                                                _8341 = _8280 - _8277;
                                                                                _8342 = _8281 - _8278;
                                                                                _8343 = _8282 - _8279;
                                                                                _8344 = dot(float3(_8338, _8339, _8340), float3(_8341, _8342, _8343));
                                                                                _8350 = sqrt(((_8341 * _8341) + (_8342 * _8342)) + (_8343 * _8343));
                                                                                _8359 = saturate(((dot(float3(_8338, _8339, _8340), float3(_8277, _8278, _8279)) * _8344) - dot(float3(_8277, _8278, _8279), float3(_8341, _8342, _8343))) / ((_8350 * _8350) - (_8344 * _8344)));
                                                                                _8363 = (_8359 * _8341) + _8277;
                                                                                _8364 = (_8359 * _8342) + _8278;
                                                                                _8365 = (_8359 * _8343) + _8279;
                                                                                _8366 = dot(float3(_8363, _8364, _8365), float3(_8338, _8339, _8340));
                                                                                _8370 = (_8366 * _8338) - _8363;
                                                                                _8371 = (_8366 * _8339) - _8364;
                                                                                _8372 = (_8366 * _8340) - _8365;
                                                                                _8380 = saturate(0.009999999776482582f / sqrt(((_8370 * _8370) + (_8371 * _8371)) + (_8372 * _8372)));
                                                                                _8388 = ((_8380 * _8370) + _8363);
                                                                                _8389 = ((_8380 * _8371) + _8364);
                                                                                _8390 = ((_8380 * _8372) + _8365);
                                                                              }
                                                                              _8392 = rsqrt(dot(float3(_8388, _8389, _8390), float3(_8388, _8389, _8390)));
                                                                              _8393 = _8392 * _8388;
                                                                              _8394 = _8392 * _8389;
                                                                              _8395 = _8392 * _8390;
                                                                              _8396 = _219 * _219;
                                                                              _8400 = saturate((_7098 * (1.0f - _8396)) * _8392);
                                                                              _8402 = saturate(_8392 * f16tof32(_7044));
                                                                              _8404 = rsqrt(dot(float3(_8271, _8272, _8273), float3(_8271, _8272, _8273)));
                                                                              _8405 = _8404 * _8271;
                                                                              _8406 = _8404 * _8272;
                                                                              _8407 = _8404 * _8273;
                                                                              _8408 = dot(float3(_197, _198, _199), float3(_8393, _8394, _8395));
                                                                              _8409 = dot(float3(_445, _446, _444), float3(_8393, _8394, _8395));
                                                                              _8412 = rsqrt((_8409 * 2.0f) + 2.0f);
                                                                              _8419 = (_8400 > 0.0f);
                                                                              do {
                                                                                _8510 = saturate((_8412 * _8409) + _8412);
                                                                                _8511 = saturate(_8412 * (_1131 + _8408));
                                                                                if (_8419) {
                                                                                  _8423 = sqrt(1.0f - (_8400 * _8400));
                                                                                  _8425 = (_8408 * 2.0f) * _1131;
                                                                                  _8426 = _8425 - _8409;
                                                                                  if (!(!(_8426 >= _8423))) {
                                                                                    _8510 = abs(_1131);
                                                                                    _8511 = 1.0f;
                                                                                  } else {
                                                                                    _8434 = rsqrt(1.0f - (_8426 * _8426)) * _8400;
                                                                                    _8437 = _8434 * (_1131 - (_8426 * _8408));
                                                                                    _8438 = _1131 * _1131;
                                                                                    _8443 = _8434 * (((_8438 * 2.0f) + -1.0f) - (_8426 * _8409));
                                                                                    _8452 = sqrt(saturate((((1.0f - (_8408 * _8408)) - _8438) - (_8409 * _8409)) + (_8425 * _8409)));
                                                                                    _8453 = _8452 * _8434;
                                                                                    _8456 = ((_1131 * 2.0f) * _8434) * _8452;
                                                                                    _8458 = (_8423 * _8408) + _1131;
                                                                                    _8459 = _8458 + _8437;
                                                                                    _8460 = _8423 * _8409;
                                                                                    _8462 = (_8460 + 1.0f) + _8443;
                                                                                    _8463 = _8453 * _8462;
                                                                                    _8464 = _8459 * _8462;
                                                                                    _8465 = _8456 * _8459;
                                                                                    _8470 = (((_8459 * 0.25f) * _8456) - (_8463 * 0.5f)) * _8464;
                                                                                    _8484 = (((_8465 - (_8463 * 2.0f)) * _8465) + (_8463 * _8463)) + ((((-0.5f - ((_8462 + _8460) * 0.5f)) * _8464) + ((_8462 * _8462) * _8458)) * _8459);
                                                                                    _8489 = (_8470 * 2.0f) / ((_8484 * _8484) + (_8470 * _8470));
                                                                                    _8490 = _8484 * _8489;
                                                                                    _8492 = 1.0f - (_8470 * _8489);
                                                                                    _8498 = ((_8490 * _8456) + _8460) + (_8492 * _8443);
                                                                                    _8501 = rsqrt((_8498 * 2.0f) + 2.0f);
                                                                                    _8510 = saturate((_8498 * _8501) + _8501);
                                                                                    _8511 = saturate(((_8458 + (_8490 * _8453)) + (_8492 * _8437)) * _8501);
                                                                                  }
                                                                                }
                                                                                _8512 = saturate(_8328);
                                                                                _8513 = dot(float3(_197, _198, _199), float3(_8405, _8406, _8407));
                                                                                _8514 = saturate(_8513);
                                                                                _8515 = _8396 * _8396;
                                                                                do {
                                                                                  _8525 = _8515;
                                                                                  if (_8402 > 0.0f) {
                                                                                    _8525 = saturate(((_8402 * _8402) / ((_8510 * 3.5999999046325684f) + 0.4000000059604645f)) + _8515);
                                                                                  }
                                                                                  do {
                                                                                    _8537 = _8525;
                                                                                    _8538 = 1.0f;
                                                                                    if (_8419) {
                                                                                      _8534 = (((_8400 * 0.25f) * ((sqrt(_8525) * 3.0f) + _8400)) / (_8510 + 0.0010000000474974513f)) + _8525;
                                                                                      _8537 = _8534;
                                                                                      _8538 = (_8525 / _8534);
                                                                                    }
                                                                                    do {
                                                                                      _8558 = _8538;
                                                                                      if (_8312 < 1.0f) {
                                                                                        _8545 = sqrt((1.000100016593933f - _8312) / max(9.999999974752427e-07f, (_8312 + 1.0f)));
                                                                                        _8558 = (sqrt(_8537 / ((((_8545 * 0.25f) * ((sqrt(_8537) * 3.0f) + _8545)) / (_8510 + 0.0010000000474974513f)) + _8537)) * _8538);
                                                                                      }
                                                                                      _8562 = (((_8525 * _8511) - _8511) * _8511) + 1.0f;
                                                                                      _8565 = (_8525 / (_8562 * _8562)) * _8558;
                                                                                      _8573 = exp2(log2(1.0f - saturate(_8510)) * 5.0f);
                                                                                      _8577 = (_8573 * (1.0f - _212)) + _212;
                                                                                      _8578 = (_8573 * (1.0f - _213)) + _213;
                                                                                      _8579 = (_8573 * (1.0f - _214)) + _214;
                                                                                      _8582 = saturate(abs(_1131) + 9.999999747378752e-06f);
                                                                                      _8583 = sqrt(_8525);
                                                                                      _8584 = 1.0f - _8583;
                                                                                      _8592 = 0.5f / ((((_8584 * _8582) + _8583) * _8512) + (((_8584 * _8512) + _8583) * _8582));
                                                                                      do {
                                                                                        if (_217 < 0.007874015718698502f) {
                                                                                          _8598 = _8511 * _8511;
                                                                                          _8600 = max((1.0f - _8598), 9.999999747378752e-05f);
                                                                                          _8745 = (((((((exp2(((-0.0f - (_8598 / _8600)) / _8525) * 1.4426950216293335f) * 4.0f) / (_8600 * _8600)) + 1.0f) * (1.0f / ((_8525 * 4.0f) + 1.0f))) - _8565) * _168) + _8565);
                                                                                          _8746 = (((saturate(0.25f / ((_8514 + _1132) - (_8514 * _1132))) - _8592) * _168) + _8592);
                                                                                        } else {
                                                                                          _8624 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
                                                                                          _8625 = _8624 * _197;
                                                                                          _8626 = _8624 * _198;
                                                                                          _8627 = _8624 * _199;
                                                                                          _8630 = (abs(_8625) < abs(_8626));
                                                                                          _8631 = select(_8630, 1.0f, 0.0f);
                                                                                          _8632 = select(_8630, 0.0f, 1.0f);
                                                                                          _8633 = _8632 * _8627;
                                                                                          _8635 = -0.0f - (_8627 * _8631);
                                                                                          _8638 = (_8631 * _8626) - (_8632 * _8625);
                                                                                          _8640 = rsqrt(dot(float3(_8633, _8635, _8638), float3(_8633, _8635, _8638)));
                                                                                          _8641 = _8633 * _8640;
                                                                                          _8642 = _8640 * _8635;
                                                                                          _8643 = _8638 * _8640;
                                                                                          _8646 = (_8642 * _8627) - (_8643 * _8626);
                                                                                          _8649 = (_8643 * _8625) - (_8641 * _8627);
                                                                                          _8652 = (_8641 * _8626) - (_8642 * _8625);
                                                                                          _8654 = rsqrt(dot(float3(_8646, _8649, _8652), float3(_8646, _8649, _8652)));
                                                                                          _8658 = _168 * 4.0f;
                                                                                          _8667 = saturate(abs(_8658 + -2.5f) + -0.5f) + -0.5f;
                                                                                          _8668 = saturate(1.5f - abs(_8658 + -1.5f)) + -0.5f;
                                                                                          _8670 = rsqrt(dot(float2(_8667, _8668), float2(_8667, _8668)));
                                                                                          _8671 = _8670 * _8667;
                                                                                          _8672 = _8670 * _8668;
                                                                                          _8679 = ((_8646 * _8654) * _8671) + (_8672 * _8641);
                                                                                          _8680 = ((_8649 * _8654) * _8671) + (_8672 * _8642);
                                                                                          _8681 = ((_8652 * _8654) * _8671) + (_8672 * _8643);
                                                                                          _8684 = (_8680 * _199) - (_8681 * _198);
                                                                                          _8687 = (_8681 * _197) - (_8679 * _199);
                                                                                          _8690 = (_8679 * _198) - (_8680 * _197);
                                                                                          _8694 = rsqrt((dot(float3(_445, _446, _444), float3(_8405, _8406, _8407)) * 2.0f) + 2.0f);
                                                                                          _8698 = dot(float3(_8679, _8680, _8681), float3(_8405, _8406, _8407));
                                                                                          _8699 = dot(float3(_8679, _8680, _8681), float3(_445, _446, _444));
                                                                                          _8702 = dot(float3(_8684, _8687, _8690), float3(_8405, _8406, _8407));
                                                                                          _8703 = dot(float3(_8684, _8687, _8690), float3(_445, _446, _444));
                                                                                          _8709 = min(max((_8396 * (_217 + 1.0f)), 0.0010000000474974513f), 1.0f);
                                                                                          _8713 = min(max((_8396 * (1.0f - _217)), 0.0010000000474974513f), 1.0f);
                                                                                          _8714 = _8713 * _8709;
                                                                                          _8715 = ((_8699 + _8698) * _8694) * _8713;
                                                                                          _8716 = ((_8703 + _8702) * _8694) * _8709;
                                                                                          _8717 = _8714 * saturate(_8694 * (_1131 + _8513));
                                                                                          _8718 = dot(float3(_8715, _8716, _8717), float3(_8715, _8716, _8717));
                                                                                          _8723 = _8709 * _8699;
                                                                                          _8724 = _8713 * _8703;
                                                                                          _8732 = _8709 * _8698;
                                                                                          _8733 = _8713 * _8702;
                                                                                          _8745 = (((_8714 * _8714) * _8714) / (_8718 * _8718));
                                                                                          _8746 = saturate(0.5f / ((sqrt(((_8732 * _8732) + (_8514 * _8514)) + (_8733 * _8733)) * _8582) + (sqrt(((_8724 * _8724) + (_8723 * _8723)) + (_8582 * _8582)) * _8514)));
                                                                                        }
                                                                                        _8748 = (_8745 * _8514) * _8746;
                                                                                        _8763 = saturate((_8513 + 0.5f) * 0.6666666865348816f);
                                                                                        _8770 = _8224 * _1645;
                                                                                        _8771 = _8225 * _1645;
                                                                                        _8772 = _8226 * _1645;
                                                                                        _8785 = ((((_8269 * _8770) * (1.0f - _8577)) * _8763) * saturate((((_161 + -0.9919999837875366f) * 0.5f) + 0.9919999837875366f) + _8514)) + _1582;
                                                                                        _8786 = ((((_8269 * _8771) * (1.0f - _8578)) * _8763) * saturate((((_162 + -0.8080000281333923f) * 0.5f) + 0.8080000281333923f) + _8514)) + _1583;
                                                                                        _8787 = ((((_8269 * _8772) * (1.0f - _8579)) * _8763) * saturate((((_163 + -0.5f) * 0.5f) + 0.5f) + _8514)) + _1584;
                                                                                        if (_7095 > 0.0f) {
                                                                                          _8791 = (_7095 * _1347) * select(_8266, (_8262 * _1274), _8262);
                                                                                          _9262 = _8785;
                                                                                          _9263 = _8786;
                                                                                          _9264 = _8787;
                                                                                          _9265 = ((((_8791 * _8770) * _8577) * _8748) + _1585);
                                                                                          _9266 = ((((_8791 * _8771) * _8578) * _8748) + _1586);
                                                                                          _9267 = ((((_8791 * _8772) * _8579) * _8748) + _1587);
                                                                                        } else {
                                                                                          _9262 = _8785;
                                                                                          _9263 = _8786;
                                                                                          _9264 = _8787;
                                                                                          _9265 = _1585;
                                                                                          _9266 = _1586;
                                                                                          _9267 = _1587;
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
                                                                    _9262 = _1582;
                                                                    _9263 = _1583;
                                                                    _9264 = _1584;
                                                                    _9265 = _1585;
                                                                    _9266 = _1586;
                                                                    _9267 = _1587;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } else {
                                                              _9262 = _1582;
                                                              _9263 = _1583;
                                                              _9264 = _1584;
                                                              _9265 = _1585;
                                                              _9266 = _1586;
                                                              _9267 = _1587;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        if (_1628 == 10) {
                                                          _8809 = asfloat(srvLightInfoProperties.Load4(_1596)).x;
                                                          _8810 = asfloat(srvLightInfoProperties.Load4(_1596)).y;
                                                          _8811 = asfloat(srvLightInfoProperties.Load4(_1596)).z;
                                                          _8812 = asfloat(srvLightInfoProperties.Load4(_1596)).w;
                                                          _8815 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).x;
                                                          _8816 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).y;
                                                          _8817 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).z;
                                                          _8818 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 16u)))).w;
                                                          _8821 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).x;
                                                          _8822 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).y;
                                                          _8823 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).z;
                                                          _8824 = asfloat(srvLightInfoProperties.Load4(((int)(_1596 + 32u)))).w;
                                                          _8827 = asfloat(srvLightInfoProperties.Load2(((int)(_1596 + 72u)))).x;
                                                          _8828 = asfloat(srvLightInfoProperties.Load2(((int)(_1596 + 72u)))).y;
                                                          _8831 = asint(srvLightInfoProperties.Load(((int)(_1596 + 80u))));
                                                          _8834 = asint(srvLightInfoProperties.Load(((int)(_1596 + 84u))));
                                                          _8837 = asint(srvLightInfoProperties.Load(((int)(_1596 + 88u))));
                                                          _8840 = asint(srvLightInfoProperties.Load(((int)(_1596 + 96u))));
                                                          _8843 = f16tof32(_8831);
                                                          _8845 = f16tof32(((uint)((uint)(_8834) >> 16)));
                                                          _8846 = f16tof32(_8834);
                                                          _8848 = f16tof32(((uint)((uint)(_8837) >> 16)));
                                                          _8852 = ((float)((uint)((uint)(((uint)(_8837) >> 8) & 255)))) * 0.003921499941498041f;
                                                          _8854 = (float)((uint)((uint)(_8840 & 65535)));
                                                          _8858 = mad(_8811, _233, mad(_8810, _232, (_8809 * _231))) + _8812;
                                                          _8862 = mad(_8817, _233, mad(_8816, _232, (_8815 * _231))) + _8818;
                                                          _8866 = mad(_8823, _233, mad(_8822, _232, (_8821 * _231))) + _8824;
                                                          _8869 = mad(_8811, _199, mad(_8810, _198, (_8809 * _197)));
                                                          _8872 = mad(_8817, _199, mad(_8816, _198, (_8815 * _197)));
                                                          _8875 = mad(_8823, _199, mad(_8822, _198, (_8821 * _197)));
                                                          _8887 = -0.0f - mad(_8823, _444, mad(_8822, _446, (_8821 * _445)));
                                                          _8888 = _8827 * 0.5f;
                                                          _8889 = _8828 * 0.5f;
                                                          _8890 = -0.0f - _8888;
                                                          _8891 = -0.0f - _8889;
                                                          _8892 = _8890 - _8858;
                                                          _8893 = _8891 - _8862;
                                                          _8894 = -0.0f - _8866;
                                                          _8895 = _8888 - _8858;
                                                          _8896 = _8889 - _8862;
                                                          _8897 = dot(float3(_8858, _8862, _8866), float3(_8869, _8872, _8875));
                                                          _8899 = dot(float3(_8890, _8891, 0.0f), float3(_8869, _8872, _8875)) - _8897;
                                                          _8901 = dot(float3(_8888, _8891, 0.0f), float3(_8869, _8872, _8875)) - _8897;
                                                          _8903 = dot(float3(_8888, _8889, 0.0f), float3(_8869, _8872, _8875)) - _8897;
                                                          _8905 = dot(float3(_8890, _8889, 0.0f), float3(_8869, _8872, _8875)) - _8897;
                                                          _8906 = min(_8899, _8901);
                                                          do {
                                                            _8928 = 0.0f;
                                                            _8929 = 0.0f;
                                                            [branch]
                                                            if (!(!(_8906 >= 0.0f))) {
                                                              _8912 = rsqrt(dot(float3(_8895, _8893, _8894), float3(_8895, _8893, _8894)) * dot(float3(_8892, _8893, _8894), float3(_8892, _8893, _8894)));
                                                              _8914 = dot(float3(_8892, _8893, _8894), float3(_8895, _8893, _8894)) * _8912;
                                                              _8921 = rsqrt(max(((((_8914 * 0.09300000220537186f) + 0.5f) * _8914) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8912;
                                                              _8928 = (_8921 * (_8827 * _8894));
                                                              _8929 = (_8921 * (_8893 * (_8890 - _8888)));
                                                            }
                                                            do {
                                                              _8953 = 0.0f;
                                                              _8954 = _8929;
                                                              [branch]
                                                              if (!(!(min(_8901, _8903) >= 0.0f))) {
                                                                _8936 = rsqrt(dot(float3(_8895, _8896, _8894), float3(_8895, _8896, _8894)) * dot(float3(_8895, _8893, _8894), float3(_8895, _8893, _8894)));
                                                                _8938 = dot(float3(_8895, _8893, _8894), float3(_8895, _8896, _8894)) * _8936;
                                                                _8945 = rsqrt(max(((((_8938 * 0.09300000220537186f) + 0.5f) * _8938) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8936;
                                                                _8953 = (_8945 * ((_8891 - _8889) * _8894));
                                                                _8954 = ((_8945 * (_8828 * _8895)) + _8929);
                                                              }
                                                              _8955 = min(_8903, _8905);
                                                              do {
                                                                _8979 = _8928;
                                                                _8980 = _8954;
                                                                [branch]
                                                                if (!(!(_8955 >= 0.0f))) {
                                                                  _8961 = rsqrt(dot(float3(_8892, _8896, _8894), float3(_8892, _8896, _8894)) * dot(float3(_8895, _8896, _8894), float3(_8895, _8896, _8894)));
                                                                  _8963 = dot(float3(_8895, _8896, _8894), float3(_8892, _8896, _8894)) * _8961;
                                                                  _8970 = rsqrt(max(((((_8963 * 0.09300000220537186f) + 0.5f) * _8963) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8961;
                                                                  _8979 = ((_8970 * ((_8890 - _8888) * _8894)) + _8928);
                                                                  _8980 = ((_8970 * (_8827 * _8896)) + _8954);
                                                                }
                                                                do {
                                                                  _9005 = _8953;
                                                                  _9006 = _8980;
                                                                  [branch]
                                                                  if (!(!(min(_8905, _8899) >= 0.0f))) {
                                                                    _8987 = rsqrt(dot(float3(_8892, _8893, _8894), float3(_8892, _8893, _8894)) * dot(float3(_8892, _8896, _8894), float3(_8892, _8896, _8894)));
                                                                    _8989 = dot(float3(_8892, _8896, _8894), float3(_8892, _8893, _8894)) * _8987;
                                                                    _8996 = rsqrt(max(((((_8989 * 0.09300000220537186f) + 0.5f) * _8989) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8987;
                                                                    _9005 = ((_8996 * (_8828 * _8894)) + _8953);
                                                                    _9006 = ((_8996 * (_8892 * (_8891 - _8889))) + _8980);
                                                                  }
                                                                  do {
                                                                    _9149 = _9005;
                                                                    _9150 = _8979;
                                                                    _9151 = _9006;
                                                                    if (min(_8906, _8955) < 0.0f) {
                                                                      [branch]
                                                                      if (!(!(max(max(_8899, _8901), max(_8903, _8905)) >= 0.0f))) {
                                                                        _9015 = -0.0f - _8869;
                                                                        _9016 = _8897 / _8872;
                                                                        _9017 = _8890 / _8872;
                                                                        _9018 = _8888 / _8872;
                                                                        _9020 = (_8891 - _9016) / _9015;
                                                                        _9022 = (_8889 - _9016) / _9015;
                                                                        _9023 = min(_9017, _9018);
                                                                        _9024 = max(_9017, _9018);
                                                                        _9025 = min(_9020, _9022);
                                                                        _9026 = max(_9020, _9022);
                                                                        _9027 = max(_9023, _9025);
                                                                        _9028 = min(_9024, _9026);
                                                                        _9029 = _9027 * _8872;
                                                                        _9031 = _9028 * _8872;
                                                                        _9033 = _9029 - _8858;
                                                                        _9034 = _9016 - _8862;
                                                                        _9035 = _9034 + (_9027 * _9015);
                                                                        _9036 = _9031 - _8858;
                                                                        _9037 = _9034 + (_9028 * _9015);
                                                                        _9038 = dot(float3(_9033, _9035, _8894), float3(_9033, _9035, _8894));
                                                                        _9039 = dot(float3(_9036, _9037, _8894), float3(_9036, _9037, _8894));
                                                                        _9041 = rsqrt(_9039 * _9038);
                                                                        _9043 = dot(float3(_9033, _9035, _8894), float3(_9036, _9037, _8894)) * _9041;
                                                                        _9050 = rsqrt(max(((((_9043 * 0.09300000220537186f) + 0.5f) * _9043) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9041;
                                                                        _9063 = (_9023 > _9025);
                                                                        _9065 = select(_9063, _8872, _8869);
                                                                        _9071 = float((int)(((int)(uint)((int)(_9065 > 0.0f))) - ((int)(uint)((int)(_9065 < 0.0f)))));
                                                                        _9075 = ((1.0f - (((float)((bool)_9063)) * 2.0f)) * _8888) * _9071;
                                                                        _9077 = _9075 - _8858;
                                                                        _9078 = (_9071 * _8889) - _8862;
                                                                        _9079 = (_9024 < _9026);
                                                                        _9081 = select(_9079, _8872, _8869);
                                                                        _9087 = float((int)(((int)(uint)((int)(_9081 > 0.0f))) - ((int)(uint)((int)(_9081 < 0.0f)))));
                                                                        _9088 = _9087 * _8888;
                                                                        _9093 = _9088 - _8858;
                                                                        _9094 = ((((((float)((bool)_9079)) * 2.0f) + -1.0f) * _8889) * _9087) - _8862;
                                                                        _9097 = rsqrt(_9038 * dot(float3(_9077, _9078, _8894), float3(_9077, _9078, _8894)));
                                                                        _9099 = dot(float3(_9077, _9078, _8894), float3(_9033, _9035, _8894)) * _9097;
                                                                        _9106 = rsqrt(max(((((_9099 * 0.09300000220537186f) + 0.5f) * _9099) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9097;
                                                                        _9119 = rsqrt(dot(float3(_9093, _9094, _8894), float3(_9093, _9094, _8894)) * _9039);
                                                                        _9121 = dot(float3(_9036, _9037, _8894), float3(_9093, _9094, _8894)) * _9119;
                                                                        _9128 = rsqrt(max(((((_9121 * 0.09300000220537186f) + 0.5f) * _9121) + 0.40700000524520874f), 9.999999682655225e-21f)) * _9119;
                                                                        _9149 = ((((_9050 * (((_9027 - _9028) * _9015) * _8894)) + _9005) + (_9106 * ((_9078 - _9035) * _8894))) + (_9128 * ((_9037 - _9094) * _8894)));
                                                                        _9150 = ((((_9050 * ((_8872 * (_9028 - _9027)) * _8894)) + _8979) + (_9106 * ((_9029 - _9075) * _8894))) + (_9128 * ((_9088 - _9031) * _8894)));
                                                                        _9151 = ((((_9050 * ((_9037 * _9033) - (_9036 * _9035))) + _9006) + (_9106 * ((_9077 * _9035) - (_9078 * _9033)))) + (_9128 * ((_9094 * _9036) - (_9093 * _9037))));
                                                                      } else {
                                                                        _9149 = _9005;
                                                                        _9150 = _8979;
                                                                        _9151 = _9006;
                                                                      }
                                                                    }
                                                                    _9157 = sqrt(((_9150 * _9150) + (_9149 * _9149)) + (_9151 * _9151));
                                                                    _9158 = _9157 * 0.15915493667125702f;
                                                                    [branch]
                                                                    if (!(_9158 == 0.0f)) {
                                                                      _9167 = saturate((_9158 - _8843) / (1.0f - _8843)) * ((float)((bool)(uint)(_8866 <= 0.0f)));
                                                                      [branch]
                                                                      if (!(_9167 == 0.0f)) {
                                                                        do {
                                                                          _9175 = 0.0f;
                                                                          if (_9157 > 0.0f) {
                                                                            _9175 = (dot(float3(_8869, _8872, _8875), float3(_9149, _9150, _9151)) / _9157);
                                                                          }
                                                                          _9180 = min(_219, 0.800000011920929f);
                                                                          _9189 = exp2(((((((_9180 * 3.322999954223633f) + -3.7669999599456787f) * _9180) + -0.3479999899864197f) * _9180) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                                                          _9196 = _8894 / (_8887 - ((_8875 * 2.0f) * dot(float3((-0.0f - mad(_8811, _444, mad(_8810, _446, (_8809 * _445)))), (-0.0f - mad(_8817, _444, mad(_8816, _446, (_8815 * _445)))), _8887), float3(_8869, _8872, _8875))));
                                                                          _9199 = (_9196 * 2.0f) * rsqrt(((9.999999747378752e-05f - _9189) * saturate((_219 + -0.5f) * 2.500000238418579f)) + _9189);
                                                                          _9207 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8854), ((log2((_9199 * _9199) * f16tof32(((uint)((uint)(_8831) >> 16)))) * 0.5f) + 5.5f));
                                                                          _9209 = (float)((bool)(uint)(_9196 > 0.0f));
                                                                          _9210 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8854), 10.0f);
                                                                          _9219 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_9167 * _1274), _9167);
                                                                          do {
                                                                            _9246 = _1585;
                                                                            _9247 = _1586;
                                                                            _9248 = _1587;
                                                                            if (_8852 > 0.0f) {
                                                                              _9225 = _8852 * _1347;
                                                                              _9226 = _9219 * _1645;
                                                                              _9246 = ((((((_9225 * _8845) * _9209) * _9207.x) * _9226) * _1140) + _1585);
                                                                              _9247 = ((((((_9225 * _8846) * _9209) * _9207.y) * _9226) * _1141) + _1586);
                                                                              _9248 = ((((((_8848 * _9225) * _9209) * _9207.z) * _9226) * _1142) + _1587);
                                                                            }
                                                                            _9254 = ((_1645 * 5.4256415367126465f) * _9175) * _9219;
                                                                            _9262 = (((_9210.x * _8845) * _9254) + _1582);
                                                                            _9263 = (((_9210.y * _8846) * _9254) + _1583);
                                                                            _9264 = (((_9210.z * _8848) * _9254) + _1584);
                                                                            _9265 = _9246;
                                                                            _9266 = _9247;
                                                                            _9267 = _9248;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } else {
                                                                        _9262 = _1582;
                                                                        _9263 = _1583;
                                                                        _9264 = _1584;
                                                                        _9265 = _1585;
                                                                        _9266 = _1586;
                                                                        _9267 = _1587;
                                                                      }
                                                                    } else {
                                                                      _9262 = _1582;
                                                                      _9263 = _1583;
                                                                      _9264 = _1584;
                                                                      _9265 = _1585;
                                                                      _9266 = _1586;
                                                                      _9267 = _1587;
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
                                                          _9262 = _1582;
                                                          _9263 = _1583;
                                                          _9264 = _1584;
                                                          _9265 = _1585;
                                                          _9266 = _1586;
                                                          _9267 = _1587;
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          } else {
                                            _9262 = _1582;
                                            _9263 = _1583;
                                            _9264 = _1584;
                                            _9265 = _1585;
                                            _9266 = _1586;
                                            _9267 = _1587;
                                          }
                                        }
                                        _9268 = _1588 + 1u;
                                        do {
                                          if (!(_9268 == _global_2)) {
                                            _1582 = _9262;
                                            _1583 = _9263;
                                            _1584 = _9264;
                                            _1585 = _9265;
                                            _1586 = _9266;
                                            _1587 = _9267;
                                            _1588 = _9268;
                                            _loop_break_3 = true;
                                            break;
                                          }
                                          _9407 = _9262;
                                          _9408 = _9263;
                                          _9409 = _9264;
                                          _9410 = _9265;
                                          _9411 = _9266;
                                          _9412 = _9267;
                                          _9413 = _161;
                                          _9414 = _162;
                                          _9415 = _163;
                                        } while (false);
                                        if (_loop_break_3) break;
                                      } while (false);
                                      if (_loop_break_3) {
                                        _loop_break_3 = false;
                                        continue;
                                      }
                                      break;
                                    }
                                  } else {
                                    _9407 = _1465;
                                    _9408 = _1466;
                                    _9409 = _1467;
                                    _9410 = _1348;
                                    _9411 = _1349;
                                    _9412 = _1350;
                                    _9413 = _161;
                                    _9414 = _162;
                                    _9415 = _163;
                                  }
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
        _9285 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _135, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _134)));
        _9288 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _135, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _134)));
        _9291 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _135, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _134)));
        do {
          [branch]
          if (!(cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0)) {
            _9312 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_9285, _9288, _9291), 0.0f);
            _9316 = _9312.x * 32.0f;
            _9317 = _9312.y * 32.0f;
            _9318 = _9312.z * 32.0f;
            _9320 = rsqrt(dot(float3(_9285, _9288, _9291), float3(_9285, _9288, _9291)));
            _9321 = _9320 * _9285;
            _9322 = _9320 * _9288;
            _9323 = _9320 * _9291;
            _9324 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
            _9325 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
            _9326 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
            _9327 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
            _9328 = dot(float3(_9321, _9322, _9323), float3(_9325, _9326, _9327));
            _9333 = (_9328 * _9328) - (dot(float3(_9325, _9326, _9327), float3(_9325, _9326, _9327)) - (_9324 * _9324));
            if ((_9328 > -0.0f) && (_9333 > 0.0f)) {
              _9338 = -0.0f - cbDeferredShading.vSunDirWS.z;
              _9351 = 74.80000305175781f / ((dot(float3(_9321, _9322, _9323), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _9324) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
              _9359 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_9321, _9323), float2(_9338, cbDeferredShading.vSunDirWS.x)) * _9351) + 0.5f), ((dot(float3(_9321, _9322, _9323), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _9338)), (cbDeferredShading.vSunDirWS.y * _9338))) * _9351) + 0.5f)), 0.0f);
              _9361 = _9333 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
              if (_9361 > 0.0f) {
                _9368 = saturate(_9361 * 5.0f);
                _9395 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _9359.x) * _9368) + _9316);
                _9396 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _9359.y) * _9368) + _9317);
                _9397 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _9359.z) * _9368) + _9318);
              } else {
                _9395 = _9316;
                _9396 = _9317;
                _9397 = _9318;
              }
            } else {
              _9395 = _9316;
              _9396 = _9317;
              _9397 = _9318;
            }
          } else {
            _9395 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
            _9396 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
            _9397 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
          }
          _9401 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
          _9407 = 0.0f;
          _9408 = 0.0f;
          _9409 = 0.0f;
          _9410 = select(_9401, 0.0f, _9395);
          _9411 = select(_9401, 0.0f, _9396);
          _9412 = select(_9401, 0.0f, _9397);
          _9413 = 0.0f;
          _9414 = 0.0f;
          _9415 = 0.0f;
        } while (false);
      }
      uavDeferredShadingPass_Specular[int2(_63, _64)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_9413 * _9407) + _9410)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_9414 * _9408) + _9411)), 7936.0f), 5.960464477539063e-08f), max(min((((_9415 * _9409) + _9412) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_63, _64)] = float3(0.0f, 0.0f, 0.0f);
    } while (false);
  }
}
