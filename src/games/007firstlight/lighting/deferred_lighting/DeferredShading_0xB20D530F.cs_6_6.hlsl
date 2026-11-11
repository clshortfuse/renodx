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
  uint _54;
  int _60;
  uint _65;
  uint _66;
  uint _73;
  int _76;
  int _91;
  float _277;
  float _278;
  float _279;
  float _280;
  float _370;
  float _371;
  float _409;
  int _447;
  float _448;
  float _449;
  float _450;
  int _569;
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
  float _581;
  float _582;
  float _583;
  float _698;
  float _699;
  float _700;
  float _787;
  float _788;
  float _789;
  float _807;
  float _808;
  float _809;
  float _841;
  float _842;
  float _843;
  float _844;
  float _845;
  float _846;
  float _847;
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
  float _872;
  float _873;
  float _874;
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
  float _890;
  float _891;
  float _892;
  float _941;
  float _942;
  float _943;
  float _963;
  float _964;
  float _965;
  float _976;
  float _977;
  float _978;
  float _979;
  float _980;
  float _981;
  float _984;
  float _985;
  float _986;
  float _987;
  float _988;
  float _989;
  float _990;
  float _1004;
  float _1005;
  float _1006;
  float _1007;
  float _1008;
  float _1009;
  float _1038;
  float _1039;
  float _1040;
  float _1060;
  float _1061;
  float _1062;
  float _1073;
  float _1074;
  float _1075;
  float _1076;
  float _1077;
  float _1078;
  float _1097;
  float _1098;
  float _1099;
  float _1100;
  float _1101;
  float _1102;
  float _1121;
  float _1122;
  float _1123;
  int _1164;
  float _1165;
  float _1283;
  float _1288;
  float _1318;
  float _1375;
  float _1391;
  float _1444;
  float _1445;
  float _1446;
  float _1499;
  float _1500;
  float _1501;
  float _1611;
  float _1616;
  float _1617;
  float _1618;
  float _1619;
  float _1620;
  float _1621;
  int _1622;
  float _2293;
  float _2294;
  float _2295;
  float _2296;
  float _2386;
  float _2395;
  float _2404;
  float _2412;
  float _2483;
  float _2492;
  float _2501;
  float _2509;
  float _2582;
  float _2591;
  float _2600;
  float _2608;
  float _2681;
  float _2690;
  float _2699;
  float _2707;
  float _2759;
  float _2764;
  float _2765;
  float _2766;
  float _2863;
  float _2864;
  float _2865;
  float _2886;
  float _2887;
  float _2888;
  int _2907;
  float _2924;
  float _2928;
  float _2944;
  float _2945;
  float _2946;
  float _2982;
  float _3014;
  float _3124;
  float _3125;
  float _3137;
  float _3149;
  float _3220;
  float _3221;
  float _3222;
  float _3230;
  int _3315;
  float _3366;
  float _3367;
  float _3368;
  float _3369;
  float _3370;
  float _3371;
  int _3372;
  bool _3399;
  bool _3401;
  float _3424;
  float _3425;
  float _3426;
  float _3446;
  float _3447;
  float _3448;
  float _3477;
  float _3587;
  float _3588;
  float _3600;
  float _3612;
  float _3674;
  float _3675;
  float _3676;
  float _3707;
  float _3736;
  float _3737;
  float _3738;
  float _3754;
  float _3755;
  float _3756;
  float _3769;
  float _3770;
  float _3771;
  float _3940;
  float _3941;
  float _3942;
  float _3943;
  float _3944;
  float _3945;
  float _3946;
  float _3947;
  float _4039;
  float _4040;
  float _4041;
  float _4042;
  float _4043;
  float _4146;
  float _4155;
  float _4164;
  float _4172;
  float _4243;
  float _4252;
  float _4261;
  float _4269;
  float _4342;
  float _4351;
  float _4360;
  float _4368;
  float _4441;
  float _4450;
  float _4459;
  float _4467;
  float _4856;
  float _4857;
  float _4858;
  int _4859;
  float _4860;
  float _4889;
  float _4890;
  float _4891;
  float _4892;
  float _4893;
  float _4995;
  float _5004;
  float _5013;
  float _5021;
  float _5092;
  float _5101;
  float _5110;
  float _5118;
  float _5191;
  float _5200;
  float _5209;
  float _5217;
  float _5290;
  float _5299;
  float _5308;
  float _5316;
  float _5650;
  float _5651;
  bool _5652;
  float _5667;
  float _5668;
  float _5669;
  float _5728;
  float _5729;
  float _5754;
  float _5755;
  float _5850;
  float _5853;
  float _5854;
  float _5855;
  float _5856;
  float _5876;
  float _5877;
  float _5878;
  int _5896;
  float _5913;
  float _5917;
  float _5932;
  float _5933;
  float _5934;
  float _5957;
  float _5958;
  float _5959;
  float _5990;
  float _6019;
  float _6020;
  float _6021;
  float _6037;
  float _6038;
  float _6039;
  float _6040;
  float _6041;
  float _6042;
  float _6078;
  float _6126;
  float _6127;
  float _6128;
  float _6144;
  float _6204;
  float _6205;
  float _6206;
  float _6327;
  float _6328;
  float _6341;
  float _6353;
  float _6354;
  float _6374;
  float _6447;
  float _6448;
  float _6449;
  float _6570;
  float _7200;
  float _7201;
  float _7202;
  float _7203;
  float _7293;
  float _7302;
  float _7311;
  float _7319;
  float _7390;
  float _7399;
  float _7408;
  float _7416;
  float _7489;
  float _7498;
  float _7507;
  float _7515;
  float _7588;
  float _7597;
  float _7606;
  float _7614;
  float _7666;
  float _7671;
  float _7672;
  float _7673;
  float _7770;
  float _7771;
  float _7772;
  float _7793;
  float _7794;
  float _7795;
  int _7814;
  float _7831;
  float _7839;
  float _7854;
  float _7855;
  float _7856;
  float _7879;
  float _7880;
  float _7881;
  float _7912;
  float _7941;
  float _7942;
  float _7943;
  float _7959;
  float _7960;
  float _7961;
  float _7962;
  float _7963;
  float _7964;
  float _8000;
  float _8048;
  float _8049;
  float _8050;
  float _8066;
  float _8126;
  float _8127;
  float _8128;
  float _8249;
  float _8250;
  float _8263;
  float _8275;
  float _8276;
  float _8296;
  float _8369;
  float _8370;
  float _8371;
  float _8502;
  float _8503;
  float _8527;
  float _8528;
  float _8553;
  float _8554;
  float _8579;
  float _8580;
  float _8723;
  float _8724;
  float _8725;
  float _8749;
  float _8840;
  float _8841;
  float _8842;
  float _8856;
  float _8857;
  float _8858;
  float _8859;
  float _8860;
  float _8861;
  float _8866;
  float _8867;
  float _8868;
  float _8869;
  float _8870;
  float _8871;
  float _9020;
  float _9021;
  float _9022;
  float _9031;
  float _9032;
  float _9033;
  float _9034;
  float _9035;
  float _9036;
  float _9037;
  float _9038;
  float _9039;
  int _87;
  uint _93;
  int _100;
  int _105;
  int _108;
  int _110;
  int _112;
  int _114;
  float4 _119;
  float _127;
  float _128;
  float _136;
  float _137;
  float4 _140;
  float4 _144;
  float4 _150;
  float4 _154;
  float _161;
  float _162;
  float _163;
  float _168;
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
  float _194;
  float _195;
  float _196;
  float _197;
  int _201;
  float _207;
  float _208;
  float _215;
  float _216;
  float _217;
  float _223;
  float _231;
  float _237;
  float _238;
  float _239;
  float _240;
  bool _242;
  int _243;
  int _249;
  uint _253;
  float _259;
  float4 _268;
  float _289;
  float _290;
  float _305;
  float _306;
  float _309;
  float _310;
  float _313;
  float _314;
  float4 _319;
  float _353;
  float _355;
  bool _356;
  float _358;
  float _360;
  bool _361;
  float4 _374;
  float _378;
  float _390;
  float _391;
  float _392;
  float _393;
  float _394;
  float _395;
  bool _398;
  bool _412;
  int _413;
  float2 _416;
  float _421;
  float _422;
  float _426;
  float _428;
  float _429;
  float _434;
  float _435;
  float _437;
  float _438;
  float _439;
  float _440;
  float _442;
  float _451;
  float _455;
  float _456;
  float _458;
  float _459;
  float _460;
  int _468;
  int _469;
  int _470;
  int _471;
  float _475;
  float _477;
  float _478;
  float _488;
  float _493;
  float _497;
  float _498;
  float _501;
  float _514;
  float _515;
  float _516;
  float _520;
  float _535;
  float _538;
  float _541;
  float _544;
  float _547;
  float _550;
  int _586;
  int _587;
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
  float _614;
  float _615;
  float _616;
  float _617;
  float _620;
  float _621;
  float _622;
  float _623;
  int _626;
  float _629;
  float _630;
  float _631;
  float _634;
  float _635;
  float _636;
  int _639;
  int _642;
  int _645;
  float _674;
  float _677;
  float _680;
  float _681;
  float4 _687;
  float4 _693;
  float _702;
  float _706;
  float _709;
  float _712;
  float _753;
  float _758;
  float _760;
  float _762;
  float _769;
  float _770;
  float4 _776;
  float4 _782;
  float _790;
  float4 _796;
  float4 _802;
  float _819;
  float _820;
  float _821;
  float _822;
  float _823;
  float _824;
  float _825;
  float _826;
  float _827;
  uint _875;
  bool _898;
  int _908;
  float _910;
  float _911;
  float _918;
  float _923;
  float _924;
  bool _925;
  float4 _930;
  float4 _936;
  float _947;
  float4 _952;
  float4 _958;
  float _996;
  int _1016;
  float _1017;
  float _1020;
  float _1021;
  bool _1022;
  float4 _1027;
  float4 _1033;
  float _1044;
  float4 _1049;
  float4 _1055;
  float _1083;
  float _1136;
  float4 _1139;
  float _1142;
  float _1143;
  float _1147;
  float _1151;
  float _1152;
  float _1153;
  float _1160;
  uint _1166;
  int _1169;
  int _1170;
  int _1174;
  int _1178;
  float _1190;
  float _1195;
  float _1196;
  float _1197;
  float _1198;
  float _1201;
  float _1202;
  float _1203;
  float _1204;
  float _1207;
  float _1208;
  float _1209;
  float _1210;
  int _1213;
  int _1216;
  int _1219;
  int _1222;
  float _1237;
  float _1241;
  float _1245;
  float _1270;
  float _1271;
  float _1272;
  float _1275;
  uint _1284;
  float _1292;
  float _1299;
  float _1300;
  float _1301;
  float _1302;
  bool _1306;
  float _1321;
  float _1323;
  float _1324;
  float _1325;
  float _1326;
  float _1331;
  float _1332;
  float _1333;
  float _1334;
  float _1336;
  float _1345;
  float _1346;
  float _1351;
  float _1357;
  float _1365;
  float _1378;
  float _1381;
  float _1384;
  int _1394;
  int _1397;
  int _1398;
  int _1399;
  int _1405;
  int _1406;
  int _1407;
  int _1413;
  int _1414;
  int _1415;
  float _1421;
  float _1425;
  float _1429;
  float _1436;
  int _1449;
  int _1452;
  int _1453;
  int _1454;
  int _1460;
  int _1461;
  int _1462;
  int _1468;
  int _1469;
  int _1470;
  float _1476;
  float _1480;
  float _1484;
  float _1491;
  float _1524;
  float _1528;
  float _1532;
  float _1551;
  float _1555;
  float _1559;
  float _1572;
  float _1573;
  float _1574;
  uint _1612;
  int _1624;
  int _1628;
  int _1629;
  int _1630;
  int _1631;
  int _1643;
  int _1647;
  float _1659;
  int _1662;
  float _1679;
  float _1684;
  float _1685;
  float _1686;
  float _1687;
  float _1690;
  float _1691;
  float _1692;
  float _1693;
  float _1696;
  float _1697;
  float _1698;
  float _1699;
  int _1702;
  int _1705;
  int _1708;
  int _1711;
  int _1714;
  float _1716;
  float _1717;
  float _1719;
  float _1723;
  float _1736;
  float _1740;
  float _1744;
  float _1769;
  float _1770;
  float _1771;
  float _1774;
  float _1775;
  float _1782;
  float _1803;
  float _1804;
  float _1805;
  float _1806;
  float _1809;
  float _1810;
  float _1811;
  float _1812;
  float _1815;
  float _1816;
  float _1817;
  float _1818;
  float _1821;
  float _1822;
  float _1823;
  float _1826;
  int _1829;
  int _1832;
  int _1835;
  int _1838;
  int _1841;
  float _1844;
  float _1845;
  float _1846;
  float _1847;
  int _1850;
  int _1853;
  int _1856;
  int _1859;
  int _1862;
  int _1865;
  int _1868;
  int _1871;
  float _1873;
  float _1874;
  float _1876;
  float _1880;
  float _1883;
  float _1885;
  int _1888;
  float _1898;
  float _1899;
  float _1901;
  float _1902;
  float _1903;
  float _1904;
  float _1923;
  float _1927;
  float _1928;
  float _1929;
  float _1933;
  float _1937;
  float _1941;
  float _1942;
  float _1965;
  float _1966;
  float _1967;
  float _1970;
  float _1971;
  bool _1973;
  float _1978;
  float _1979;
  float _1980;
  float _1985;
  float _1987;
  float _1988;
  float _1991;
  float _1995;
  float _2004;
  float _2005;
  float _2006;
  int _2007;
  float _2012;
  float _2021;
  float _2022;
  float _2024;
  float4 _2029;
  float _2034;
  float _2036;
  float _2038;
  float _2040;
  float _2044;
  float _2046;
  float _2050;
  float _2052;
  int _2059;
  float _2064;
  float _2073;
  float _2074;
  float4 _2080;
  float _2085;
  float _2087;
  float _2091;
  float _2093;
  float _2097;
  float _2099;
  float _2103;
  float _2105;
  int _2112;
  float _2117;
  float _2126;
  float _2127;
  float4 _2133;
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
  float4 _2186;
  float _2191;
  float _2193;
  float _2197;
  float _2199;
  float _2203;
  float _2205;
  float _2209;
  float _2211;
  float _2212;
  float _2223;
  float _2229;
  float _2231;
  float _2233;
  float _2240;
  float _2245;
  float _2246;
  float _2247;
  float _2248;
  float4 _2250;
  float _2258;
  float _2259;
  float4 _2260;
  float _2265;
  float _2270;
  float4 _2271;
  float _2276;
  float4 _2281;
  float _2290;
  float _2299;
  float _2300;
  float _2309;
  float _2313;
  float _2322;
  float _2323;
  float _2324;
  float _2329;
  int _2330;
  float _2335;
  float _2344;
  float _2345;
  float _2347;
  float _2349;
  float _2350;
  float4 _2352;
  float _2356;
  float _2357;
  float _2360;
  float _2361;
  float _2366;
  float _2367;
  float _2370;
  float _2371;
  float _2373;
  float _2375;
  bool _2376;
  bool _2377;
  bool _2387;
  bool _2396;
  float _2413;
  float _2415;
  float _2417;
  float _2419;
  float _2423;
  float _2425;
  float _2429;
  float _2431;
  int _2438;
  float _2443;
  float _2452;
  float _2453;
  float _2456;
  float _2457;
  float4 _2459;
  float _2463;
  float _2464;
  float _2467;
  float _2468;
  float _2470;
  float _2472;
  bool _2473;
  bool _2474;
  bool _2484;
  bool _2493;
  float _2510;
  float _2512;
  float _2516;
  float _2518;
  float _2522;
  float _2524;
  float _2528;
  float _2530;
  int _2537;
  float _2542;
  float _2551;
  float _2552;
  float _2555;
  float _2556;
  float4 _2558;
  float _2562;
  float _2563;
  float _2566;
  float _2567;
  float _2569;
  float _2571;
  bool _2572;
  bool _2573;
  bool _2583;
  bool _2592;
  float _2609;
  float _2611;
  float _2615;
  float _2617;
  float _2621;
  float _2623;
  float _2627;
  float _2629;
  int _2636;
  float _2641;
  float _2650;
  float _2651;
  float _2654;
  float _2655;
  float4 _2657;
  float _2661;
  float _2662;
  float _2665;
  float _2666;
  float _2668;
  float _2670;
  bool _2671;
  bool _2672;
  bool _2682;
  bool _2691;
  float _2708;
  float _2710;
  float _2714;
  float _2716;
  float _2720;
  float _2722;
  float _2726;
  float _2728;
  float _2729;
  float _2740;
  float _2746;
  float _2748;
  float _2750;
  float _2772;
  float4 _2779;
  float _2793;
  float _2794;
  float _2795;
  float _2796;
  float _2798;
  float _2803;
  float _2806;
  float _2807;
  float _2809;
  float _2810;
  float _2815;
  float _2820;
  float _2822;
  float _2825;
  float _2826;
  float _2831;
  float _2833;
  float _2835;
  float _2837;
  float _2842;
  float _2848;
  float _2850;
  float3 _2878;
  float _2889;
  float4 _2910;
  float _2939;
  int _2953;
  int _2958;
  int _2960;
  int _2961;
  int _2963;
  int _2964;
  int _2973;
  bool _2986;
  float _2989;
  float _2991;
  float _2992;
  float _2993;
  float _2994;
  float _2995;
  float _2996;
  float _3004;
  float _3009;
  float _3015;
  float _3019;
  float _3021;
  float _3022;
  float _3023;
  float _3026;
  bool _3033;
  float _3037;
  float _3039;
  float _3040;
  float _3048;
  float _3051;
  float _3052;
  float _3057;
  float _3066;
  float _3067;
  float _3070;
  float _3072;
  float _3073;
  float _3074;
  float _3076;
  float _3077;
  float _3078;
  float _3079;
  float _3084;
  float _3098;
  float _3103;
  float _3104;
  float _3106;
  float _3112;
  float _3115;
  float _3126;
  float _3127;
  float _3138;
  float _3153;
  float _3160;
  float _3163;
  float _3164;
  float _3176;
  float _3179;
  float _3180;
  float _3181;
  float _3182;
  float _3203;
  float _3233;
  float _3234;
  float _3235;
  float _3236;
  float _3239;
  float _3240;
  float _3241;
  float _3242;
  float _3245;
  float _3246;
  float _3247;
  float _3248;
  float _3251;
  float _3252;
  float _3253;
  int _3256;
  int _3259;
  int _3262;
  int _3265;
  int _3268;
  int _3271;
  float _3274;
  float _3278;
  float _3280;
  int _3282;
  float _3296;
  float _3300;
  float2 _3306;
  int _3311;
  int _3318;
  int _3330;
  float _3333;
  float _3334;
  float _3335;
  float _3338;
  float _3339;
  float _3340;
  float _3343;
  float _3344;
  float _3345;
  float _3346;
  float _3347;
  float _3348;
  int _3351;
  float _3353;
  float _3354;
  float _3355;
  float _3356;
  float _3357;
  float _3358;
  int _3361;
  uint _3396;
  float3 _3416;
  float _3435;
  float _3451;
  float _3454;
  float _3455;
  float _3456;
  float _3457;
  float _3458;
  float _3459;
  float _3467;
  float _3472;
  float _3478;
  float _3482;
  float _3484;
  float _3485;
  float _3486;
  float _3489;
  bool _3496;
  float _3500;
  float _3502;
  float _3503;
  float _3511;
  float _3514;
  float _3515;
  float _3520;
  float _3529;
  float _3530;
  float _3533;
  float _3535;
  float _3536;
  float _3537;
  float _3539;
  float _3540;
  float _3541;
  float _3542;
  float _3547;
  float _3561;
  float _3566;
  float _3567;
  float _3569;
  float _3575;
  float _3578;
  float _3589;
  float _3590;
  float _3601;
  float _3616;
  float _3626;
  float _3635;
  float _3636;
  float _3648;
  float _3651;
  float _3664;
  bool _3677;
  float _3678;
  float _3679;
  float _3680;
  bool _3681;
  float _3683;
  float _3684;
  float _3688;
  float _3694;
  float _3708;
  float _3709;
  float _3712;
  float _3716;
  int _3717;
  float _3719;
  float _3721;
  float _3724;
  float _3728;
  float _3739;
  float _3740;
  float _3741;
  float _3743;
  float _3757;
  float _3758;
  float _3759;
  float _3775;
  float _3776;
  float _3777;
  float _3780;
  float _3801;
  float _3802;
  float _3803;
  float _3806;
  float _3807;
  float _3808;
  float _3811;
  float _3812;
  float _3813;
  float _3816;
  float _3817;
  float _3818;
  float _3821;
  float _3822;
  float _3823;
  int _3826;
  int _3829;
  int _3832;
  int _3835;
  int _3838;
  int _3841;
  int _3844;
  int _3847;
  int _3850;
  int _3853;
  int _3856;
  float _3859;
  float _3860;
  float _3861;
  float _3862;
  int _3865;
  int _3868;
  int _3871;
  int _3874;
  float _3876;
  float _3877;
  float _3879;
  float _3883;
  float _3886;
  float _3887;
  float _3889;
  float _3893;
  float _3895;
  float _3896;
  float _3898;
  float _3899;
  int _3901;
  bool _3905;
  float _3913;
  float _3914;
  float _3916;
  float _3919;
  float _3920;
  float _3922;
  float _3923;
  float _3925;
  float _3926;
  float _3930;
  float _3936;
  float _3937;
  float _3938;
  float _3951;
  float _3952;
  float _3953;
  float _3954;
  float _3955;
  float _3956;
  float _3957;
  float _3958;
  float _3959;
  float _3962;
  float _3963;
  float _3964;
  float _3967;
  float _3974;
  float _3987;
  float _3991;
  float _3995;
  float _3996;
  float _3997;
  float _4000;
  float _4003;
  bool _4005;
  float _4011;
  float _4012;
  float _4013;
  float _4018;
  float _4019;
  float _4020;
  bool _4024;
  bool _4030;
  bool _4034;
  float _4044;
  float _4049;
  float _4058;
  float _4059;
  float _4060;
  float _4065;
  float _4066;
  float _4069;
  float _4073;
  float _4082;
  float _4083;
  float _4084;
  float _4089;
  int _4090;
  float _4095;
  float _4104;
  float _4105;
  float _4107;
  float _4109;
  float _4110;
  float4 _4112;
  float _4116;
  float _4117;
  float _4120;
  float _4121;
  float _4126;
  float _4127;
  float _4130;
  float _4131;
  float _4133;
  float _4135;
  bool _4136;
  bool _4137;
  bool _4147;
  bool _4156;
  float _4173;
  float _4175;
  float _4177;
  float _4179;
  float _4183;
  float _4185;
  float _4189;
  float _4191;
  int _4198;
  float _4203;
  float _4212;
  float _4213;
  float _4216;
  float _4217;
  float4 _4219;
  float _4223;
  float _4224;
  float _4227;
  float _4228;
  float _4230;
  float _4232;
  bool _4233;
  bool _4234;
  bool _4244;
  bool _4253;
  float _4270;
  float _4272;
  float _4276;
  float _4278;
  float _4282;
  float _4284;
  float _4288;
  float _4290;
  int _4297;
  float _4302;
  float _4311;
  float _4312;
  float _4315;
  float _4316;
  float4 _4318;
  float _4322;
  float _4323;
  float _4326;
  float _4327;
  float _4329;
  float _4331;
  bool _4332;
  bool _4333;
  bool _4343;
  bool _4352;
  float _4369;
  float _4371;
  float _4375;
  float _4377;
  float _4381;
  float _4383;
  float _4387;
  float _4389;
  int _4396;
  float _4401;
  float _4410;
  float _4411;
  float _4414;
  float _4415;
  float4 _4417;
  float _4421;
  float _4422;
  float _4425;
  float _4426;
  float _4428;
  float _4430;
  bool _4431;
  bool _4432;
  bool _4442;
  bool _4451;
  float _4468;
  float _4470;
  float _4474;
  float _4476;
  float _4480;
  float _4482;
  float _4486;
  float _4488;
  float _4489;
  float _4500;
  float _4506;
  float _4508;
  float _4510;
  float _4522;
  float _4525;
  float _4526;
  float _4529;
  float _4540;
  float _4541;
  float _4542;
  float _4546;
  float _4555;
  float _4556;
  float _4557;
  int _4558;
  float _4563;
  float _4572;
  float _4573;
  float _4575;
  float4 _4580;
  float _4585;
  float _4587;
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
  float4 _4631;
  float _4636;
  float _4638;
  float _4642;
  float _4644;
  float _4648;
  float _4650;
  float _4654;
  float _4656;
  int _4663;
  float _4668;
  float _4677;
  float _4678;
  float4 _4684;
  float _4689;
  float _4691;
  float _4695;
  float _4697;
  float _4701;
  float _4703;
  float _4707;
  float _4709;
  int _4716;
  float _4721;
  float _4730;
  float _4731;
  float4 _4737;
  float _4742;
  float _4744;
  float _4748;
  float _4750;
  float _4754;
  float _4756;
  float _4760;
  float _4762;
  float _4763;
  float _4774;
  float _4780;
  float _4782;
  float _4784;
  float _4792;
  float _4799;
  float _4801;
  float _4808;
  float _4809;
  float _4810;
  float _4811;
  float4 _4813;
  float _4822;
  float4 _4823;
  float _4828;
  float _4834;
  float4 _4835;
  float _4840;
  float4 _4845;
  float _4868;
  float _4869;
  float _4870;
  bool _4874;
  bool _4880;
  bool _4884;
  float _4894;
  float _4899;
  float _4908;
  float _4909;
  float _4914;
  float _4915;
  float _4918;
  float _4922;
  float _4931;
  float _4932;
  float _4933;
  float _4938;
  int _4939;
  float _4944;
  float _4953;
  float _4954;
  float _4956;
  float _4958;
  float _4959;
  float4 _4961;
  float _4965;
  float _4966;
  float _4969;
  float _4970;
  float _4975;
  float _4976;
  float _4979;
  float _4980;
  float _4982;
  float _4984;
  bool _4985;
  bool _4986;
  bool _4996;
  bool _5005;
  float _5022;
  float _5024;
  float _5026;
  float _5028;
  float _5032;
  float _5034;
  float _5038;
  float _5040;
  int _5047;
  float _5052;
  float _5061;
  float _5062;
  float _5065;
  float _5066;
  float4 _5068;
  float _5072;
  float _5073;
  float _5076;
  float _5077;
  float _5079;
  float _5081;
  bool _5082;
  bool _5083;
  bool _5093;
  bool _5102;
  float _5119;
  float _5121;
  float _5125;
  float _5127;
  float _5131;
  float _5133;
  float _5137;
  float _5139;
  int _5146;
  float _5151;
  float _5160;
  float _5161;
  float _5164;
  float _5165;
  float4 _5167;
  float _5171;
  float _5172;
  float _5175;
  float _5176;
  float _5178;
  float _5180;
  bool _5181;
  bool _5182;
  bool _5192;
  bool _5201;
  float _5218;
  float _5220;
  float _5224;
  float _5226;
  float _5230;
  float _5232;
  float _5236;
  float _5238;
  int _5245;
  float _5250;
  float _5259;
  float _5260;
  float _5263;
  float _5264;
  float4 _5266;
  float _5270;
  float _5271;
  float _5274;
  float _5275;
  float _5277;
  float _5279;
  bool _5280;
  bool _5281;
  bool _5291;
  bool _5300;
  float _5317;
  float _5319;
  float _5323;
  float _5325;
  float _5329;
  float _5331;
  float _5335;
  float _5337;
  float _5338;
  float _5349;
  float _5355;
  float _5357;
  float _5359;
  float _5368;
  float _5371;
  float _5372;
  float _5385;
  float _5386;
  float _5387;
  float _5391;
  float _5400;
  float _5401;
  float _5402;
  int _5403;
  float _5408;
  float _5417;
  float _5418;
  float _5420;
  float4 _5425;
  float _5430;
  float _5432;
  float _5434;
  float _5436;
  float _5440;
  float _5442;
  float _5446;
  float _5448;
  int _5455;
  float _5460;
  float _5469;
  float _5470;
  float4 _5476;
  float _5481;
  float _5483;
  float _5487;
  float _5489;
  float _5493;
  float _5495;
  float _5499;
  float _5501;
  int _5508;
  float _5513;
  float _5522;
  float _5523;
  float4 _5529;
  float _5534;
  float _5536;
  float _5540;
  float _5542;
  float _5546;
  float _5548;
  float _5552;
  float _5554;
  int _5561;
  float _5566;
  float _5575;
  float _5576;
  float4 _5582;
  float _5587;
  float _5589;
  float _5593;
  float _5595;
  float _5599;
  float _5601;
  float _5605;
  float _5607;
  float _5608;
  float _5619;
  float _5625;
  float _5627;
  float _5629;
  float _5637;
  float _5644;
  float _5646;
  float _5672;
  float _5675;
  float _5676;
  float _5677;
  float _5692;
  float _5695;
  float _5698;
  float _5700;
  float _5701;
  float _5702;
  float _5703;
  float _5711;
  float _5712;
  float _5713;
  bool _5715;
  float _5735;
  float4 _5760;
  float _5780;
  float _5781;
  float _5782;
  float _5783;
  float _5785;
  float _5790;
  float _5793;
  float _5794;
  float _5796;
  float _5797;
  float _5802;
  float _5807;
  float _5809;
  float _5812;
  float _5813;
  float _5818;
  float _5820;
  float _5822;
  float _5824;
  float _5829;
  float _5835;
  float _5837;
  float3 _5868;
  float4 _5899;
  float _5927;
  float _5947;
  bool _5960;
  float _5961;
  float _5962;
  float _5963;
  bool _5964;
  float _5966;
  float _5967;
  float _5971;
  float _5977;
  float _5991;
  float _5992;
  float _5995;
  float _5999;
  int _6000;
  float _6002;
  float _6004;
  float _6007;
  float _6011;
  float _6022;
  float _6023;
  float _6024;
  float _6026;
  int _6049;
  int _6054;
  int _6056;
  int _6057;
  int _6059;
  int _6060;
  int _6069;
  bool _6082;
  float _6085;
  float _6087;
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
  bool _6099;
  float _6100;
  float _6101;
  float _6104;
  float _6105;
  float _6107;
  float _6134;
  float _6139;
  float _6146;
  float _6147;
  float _6148;
  float _6150;
  float _6154;
  float _6155;
  float _6156;
  float _6157;
  float _6158;
  float _6159;
  float _6160;
  float _6166;
  float _6175;
  float _6179;
  float _6180;
  float _6181;
  float _6182;
  float _6186;
  float _6187;
  float _6188;
  float _6196;
  float _6208;
  float _6209;
  float _6210;
  float _6211;
  float _6212;
  float _6216;
  float _6218;
  float _6220;
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
  float _6331;
  float _6350;
  float _6361;
  float _6378;
  float _6385;
  float _6388;
  float _6389;
  float _6390;
  float _6402;
  float _6405;
  float _6406;
  float _6407;
  float _6408;
  float _6430;
  float _6461;
  float _6462;
  float _6463;
  float _6466;
  float _6467;
  float _6468;
  float _6471;
  int _6474;
  int _6477;
  int _6480;
  float _6489;
  float _6492;
  float _6495;
  float _6502;
  float _6507;
  float _6509;
  float _6511;
  float _6512;
  float _6513;
  float _6515;
  float _6516;
  float _6517;
  float _6520;
  float _6521;
  float _6522;
  float _6525;
  float _6532;
  int _6541;
  int _6546;
  int _6548;
  int _6549;
  int _6551;
  int _6552;
  int _6561;
  bool _6574;
  float _6576;
  float _6577;
  float _6578;
  float _6579;
  float _6582;
  float _6585;
  float _6589;
  float _6590;
  float _6591;
  float _6595;
  float _6602;
  float _6605;
  float _6606;
  float _6607;
  float _6619;
  float _6621;
  float _6622;
  float _6623;
  float _6624;
  float _6631;
  float _6632;
  float _6633;
  float _6648;
  float _6669;
  float _6670;
  float _6671;
  float _6674;
  float _6675;
  float _6676;
  float _6679;
  float _6680;
  float _6681;
  float _6684;
  float _6685;
  float _6686;
  float _6689;
  float _6690;
  float _6691;
  float _6694;
  float _6695;
  float _6696;
  int _6699;
  int _6702;
  int _6705;
  int _6708;
  float _6711;
  float _6712;
  float _6713;
  float _6714;
  int _6717;
  int _6720;
  int _6723;
  int _6726;
  int _6729;
  int _6732;
  int _6735;
  float _6738;
  float _6739;
  float _6740;
  float _6741;
  int _6744;
  int _6747;
  int _6750;
  float _6752;
  float _6753;
  float _6755;
  float _6759;
  float _6762;
  float _6763;
  float _6765;
  float _6769;
  int _6773;
  bool _6779;
  float _6790;
  float _6791;
  float _6793;
  float _6794;
  float _6795;
  float _6796;
  float _6797;
  float _6798;
  float _6799;
  float _6800;
  float _6801;
  float _6802;
  float _6803;
  float _6804;
  float _6805;
  float _6808;
  float _6809;
  float _6810;
  float _6813;
  float _6824;
  float _6828;
  float _6835;
  float _6836;
  float _6837;
  float _6849;
  float _6850;
  float _6851;
  float _6852;
  float _6855;
  float _6856;
  float _6859;
  float _6860;
  float _6867;
  float _6869;
  float _6875;
  float _6885;
  float _6886;
  float _6887;
  float _6892;
  float _6894;
  float _6895;
  float _6898;
  float _6902;
  float _6911;
  float _6912;
  float _6913;
  int _6914;
  float _6919;
  float _6928;
  float _6929;
  float _6931;
  float4 _6936;
  float _6941;
  float _6943;
  float _6945;
  float _6947;
  float _6951;
  float _6953;
  float _6957;
  float _6959;
  int _6966;
  float _6971;
  float _6980;
  float _6981;
  float4 _6987;
  float _6992;
  float _6994;
  float _6998;
  float _7000;
  float _7004;
  float _7006;
  float _7010;
  float _7012;
  int _7019;
  float _7024;
  float _7033;
  float _7034;
  float4 _7040;
  float _7045;
  float _7047;
  float _7051;
  float _7053;
  float _7057;
  float _7059;
  float _7063;
  float _7065;
  int _7072;
  float _7077;
  float _7086;
  float _7087;
  float4 _7093;
  float _7098;
  float _7100;
  float _7104;
  float _7106;
  float _7110;
  float _7112;
  float _7116;
  float _7118;
  float _7119;
  float _7130;
  float _7136;
  float _7138;
  float _7140;
  float _7147;
  float _7152;
  float _7153;
  float _7154;
  float _7155;
  float4 _7157;
  float _7165;
  float _7166;
  float4 _7167;
  float _7172;
  float _7177;
  float4 _7178;
  float _7183;
  float4 _7188;
  float _7197;
  float _7206;
  float _7207;
  float _7216;
  float _7220;
  float _7229;
  float _7230;
  float _7231;
  float _7236;
  int _7237;
  float _7242;
  float _7251;
  float _7252;
  float _7254;
  float _7256;
  float _7257;
  float4 _7259;
  float _7263;
  float _7264;
  float _7267;
  float _7268;
  float _7273;
  float _7274;
  float _7277;
  float _7278;
  float _7280;
  float _7282;
  bool _7283;
  bool _7284;
  bool _7294;
  bool _7303;
  float _7320;
  float _7322;
  float _7324;
  float _7326;
  float _7330;
  float _7332;
  float _7336;
  float _7338;
  int _7345;
  float _7350;
  float _7359;
  float _7360;
  float _7363;
  float _7364;
  float4 _7366;
  float _7370;
  float _7371;
  float _7374;
  float _7375;
  float _7377;
  float _7379;
  bool _7380;
  bool _7381;
  bool _7391;
  bool _7400;
  float _7417;
  float _7419;
  float _7423;
  float _7425;
  float _7429;
  float _7431;
  float _7435;
  float _7437;
  int _7444;
  float _7449;
  float _7458;
  float _7459;
  float _7462;
  float _7463;
  float4 _7465;
  float _7469;
  float _7470;
  float _7473;
  float _7474;
  float _7476;
  float _7478;
  bool _7479;
  bool _7480;
  bool _7490;
  bool _7499;
  float _7516;
  float _7518;
  float _7522;
  float _7524;
  float _7528;
  float _7530;
  float _7534;
  float _7536;
  int _7543;
  float _7548;
  float _7557;
  float _7558;
  float _7561;
  float _7562;
  float4 _7564;
  float _7568;
  float _7569;
  float _7572;
  float _7573;
  float _7575;
  float _7577;
  bool _7578;
  bool _7579;
  bool _7589;
  bool _7598;
  float _7615;
  float _7617;
  float _7621;
  float _7623;
  float _7627;
  float _7629;
  float _7633;
  float _7635;
  float _7636;
  float _7647;
  float _7653;
  float _7655;
  float _7657;
  float _7679;
  float4 _7686;
  float _7700;
  float _7701;
  float _7702;
  float _7703;
  float _7705;
  float _7710;
  float _7713;
  float _7714;
  float _7716;
  float _7717;
  float _7722;
  float _7727;
  float _7729;
  float _7732;
  float _7733;
  float _7738;
  float _7740;
  float _7742;
  float _7744;
  float _7749;
  float _7755;
  float _7757;
  float3 _7785;
  float _7796;
  float4 _7817;
  float _7849;
  float _7869;
  bool _7882;
  float _7883;
  float _7884;
  float _7885;
  bool _7886;
  float _7888;
  float _7889;
  float _7893;
  float _7899;
  float _7913;
  float _7914;
  float _7917;
  float _7921;
  int _7922;
  float _7924;
  float _7926;
  float _7929;
  float _7933;
  float _7944;
  float _7945;
  float _7946;
  float _7948;
  int _7971;
  int _7976;
  int _7978;
  int _7979;
  int _7981;
  int _7982;
  int _7991;
  bool _8004;
  float _8007;
  float _8009;
  float _8010;
  float _8011;
  float _8012;
  float _8013;
  float _8014;
  float _8015;
  float _8016;
  float _8017;
  float _8018;
  float _8019;
  float _8020;
  bool _8021;
  float _8022;
  float _8023;
  float _8026;
  float _8027;
  float _8029;
  float _8056;
  float _8061;
  float _8068;
  float _8069;
  float _8070;
  float _8072;
  float _8076;
  float _8077;
  float _8078;
  float _8079;
  float _8080;
  float _8081;
  float _8082;
  float _8088;
  float _8097;
  float _8101;
  float _8102;
  float _8103;
  float _8104;
  float _8108;
  float _8109;
  float _8110;
  float _8118;
  float _8130;
  float _8131;
  float _8132;
  float _8133;
  float _8134;
  float _8138;
  float _8140;
  float _8142;
  float _8146;
  float _8147;
  float _8148;
  float _8151;
  bool _8158;
  float _8162;
  float _8164;
  float _8165;
  float _8173;
  float _8176;
  float _8177;
  float _8182;
  float _8191;
  float _8192;
  float _8195;
  float _8197;
  float _8198;
  float _8199;
  float _8201;
  float _8202;
  float _8203;
  float _8204;
  float _8209;
  float _8223;
  float _8228;
  float _8229;
  float _8231;
  float _8237;
  float _8240;
  float _8251;
  float _8253;
  float _8272;
  float _8283;
  float _8300;
  float _8307;
  float _8310;
  float _8311;
  float _8312;
  float _8324;
  float _8327;
  float _8328;
  float _8329;
  float _8330;
  float _8352;
  float _8383;
  float _8384;
  float _8385;
  float _8386;
  float _8389;
  float _8390;
  float _8391;
  float _8392;
  float _8395;
  float _8396;
  float _8397;
  float _8398;
  float _8401;
  float _8402;
  int _8405;
  int _8408;
  int _8411;
  int _8414;
  float _8417;
  float _8419;
  float _8420;
  float _8422;
  float _8426;
  float _8428;
  float _8432;
  float _8436;
  float _8440;
  float _8443;
  float _8446;
  float _8449;
  float _8461;
  float _8462;
  float _8463;
  float _8464;
  float _8465;
  float _8466;
  float _8467;
  float _8468;
  float _8469;
  float _8470;
  float _8471;
  float _8473;
  float _8475;
  float _8477;
  float _8479;
  float _8480;
  float _8486;
  float _8488;
  float _8495;
  float _8510;
  float _8512;
  float _8519;
  float _8529;
  float _8535;
  float _8537;
  float _8544;
  float _8561;
  float _8563;
  float _8570;
  float _8589;
  float _8590;
  float _8591;
  float _8592;
  float _8594;
  float _8596;
  float _8597;
  float _8598;
  float _8599;
  float _8600;
  float _8601;
  float _8602;
  float _8603;
  float _8605;
  float _8607;
  float _8608;
  float _8609;
  float _8610;
  float _8611;
  float _8612;
  float _8613;
  float _8615;
  float _8617;
  float _8624;
  bool _8637;
  float _8639;
  float _8645;
  float _8649;
  float _8651;
  float _8652;
  bool _8653;
  float _8655;
  float _8661;
  float _8662;
  float _8667;
  float _8668;
  float _8671;
  float _8673;
  float _8680;
  float _8693;
  float _8695;
  float _8702;
  float _8731;
  float _8732;
  float _8741;
  float _8750;
  float _8751;
  float _8757;
  float _8762;
  float _8771;
  float _8778;
  float _8781;
  float4 _8789;
  float _8791;
  float4 _8792;
  float _8801;
  float _8819;
  float _8820;
  float _8848;
  uint _8862;
  float _8873;
  float _8880;
  float _8891;
  float _8910;
  float _8913;
  float _8916;
  float4 _8937;
  float _8941;
  float _8942;
  float _8943;
  float _8945;
  float _8946;
  float _8947;
  float _8948;
  float _8949;
  float _8950;
  float _8951;
  float _8952;
  float _8953;
  float _8958;
  float _8963;
  float _8976;
  float4 _8984;
  float _8986;
  float _8993;
  bool _9026;
  _54 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _60 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _65 = ((uint)(((int)(_60 << 3)) & 524280)) + SV_GroupThreadID.x;
  _66 = ((uint)(((uint)(_60) >> 16) << 3)) + SV_GroupThreadID.y;
  _73 = ((int)((((uint)(_66) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_65) >> 4)))) << 6;
  _76 = srvDeferredClusters[_73];
  if (_54 == 0) {
    _global_2 = (_76 & 255);
    _global_0 = (((uint)(_76) >> 16) & 255);
    _global_1 = (((uint)(_76) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _87 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_87 == 0)) {
    _91 = 0;
    bool _loop_break_0 = false;
    while (true) {
      _93 = (_91 << 6) + _54;
      do {
        if ((uint)_93 < (uint)_global_2) {
          _100 = srvDeferredClusters[((int)(((uint)(_73 | 1)) + _93))];
          _global_3[min((uint)(_93), 63u)] = _100;
          _105 = _100 & 4095;
          _108 = srvLightInfoBase[_105].nFlags;
          _110 = srvLightInfoBase[_105].nRoomMask;
          _112 = srvLightInfoBase[_105].nBufferOffset;
          _global_4[min((uint)(_93), 63u)] = _108;
          _global_5[min((uint)(_93), 63u)] = _110;
          _global_6[min((uint)(_93), 63u)] = _112;
        }
        _114 = _91 + 1;
        do {
          if (!(_114 == _87)) {
            _91 = _114;
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
  _119 = srvGlobalGBuffer0.Load(int3(_65, _66, 0));
  [branch]
  if (_119.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_65, _66)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_65, _66)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _127 = (float)((uint)_65);
    _128 = (float)((uint)_66);
    _136 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _127) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
    _137 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _128) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
    do {
      [branch]
      if (_119.x > 0.0f) {
        _140 = srvGlobalGBuffer1.Load(int3(_65, _66, 0));
        _144 = srvGlobalGBuffer2.Load(int3(_65, _66, 0));
        _150 = srvGlobalGBuffer3.Load(int3(_65, _66, 0));
        _154 = srvGlobalGBuffer4.Load(int3(_65, _66, 0));
        _161 = saturate(_144.x);
        _162 = saturate(_144.y);
        _163 = saturate(_144.z);
        _168 = saturate(_154.y);
        _173 = (saturate(_140.x) * 2.0f) + -1.0f;
        _174 = (saturate(_140.y) * 2.0f) + -1.0f;
        _178 = (1.0f - abs(_173)) - abs(_174);
        _180 = saturate(-0.0f - _178);
        _181 = -0.0f - _180;
        _186 = select((_173 >= 0.0f), _181, _180) + _173;
        _187 = select((_174 >= 0.0f), _181, _180) + _174;
        _189 = rsqrt(dot(float3(_186, _187, _178), float3(_186, _187, _178)));
        _190 = _186 * _189;
        _191 = _187 * _189;
        _192 = _189 * _178;
        _194 = rsqrt(dot(float3(_190, _191, _192), float3(_190, _191, _192)));
        _195 = _194 * _190;
        _196 = _194 * _191;
        _197 = _194 * _192;
        _201 = (uint)(uint((saturate(_144.w) * 255.0f) + 0.5f)) >> 6;
        _207 = saturate(_150.x);
        _208 = saturate(_150.y) * 0.07999999821186066f;
        _215 = (_207 * (_161 - _208)) + _208;
        _216 = (_207 * (_162 - _208)) + _208;
        _217 = (_207 * (_163 - _208)) + _208;
        _223 = min(1.0f, max(saturate(_154.x), 0.019999999552965164f));
        _231 = (_207 * (1.0f - _208)) + _208;
        _237 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _119.x) - cbSharedPerViewData.vViewRemap.y);
        _238 = _237 * _136;
        _239 = _237 * _137;
        _240 = -0.0f - _237;
        _242 = ((_201 & 1) != 0);
        _243 = _201 & 3;
        _249 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
        _253 = srvReflectionsWeight.Load(int3(((uint)(_65) >> _249), ((uint)(_66) >> _249), 0));
        _259 = ((float)((uint)((uint)(_253.x & 254)))) * 0.003921568859368563f;
        do {
          _277 = 1.0f;
          _278 = 0.0f;
          _279 = 0.0f;
          _280 = 0.0f;
          if ((_253.x & 1) == 0) {
            _268 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _127), (cbSharedPerViewData.vViewportSize.y * _128)), 0.0f);
            _277 = (1.0f - _259);
            _278 = (_268.x * _259);
            _279 = (_268.y * _259);
            _280 = (_268.z * _259);
          }
          _289 = cbSharedPerViewData.vViewportSize.x * (_127 + 0.5f);
          _290 = cbSharedPerViewData.vViewportSize.y * (_128 + 0.5f);
          do {
            _370 = _289;
            _371 = _290;
            if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
              _305 = (floor((_289 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
              _306 = (floor((_290 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
              _309 = max(_305, cbDeferredShading.vScreenPixelSize.z);
              _310 = max(_306, cbDeferredShading.vScreenPixelSize.w);
              _313 = min((_305 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
              _314 = min((_306 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
              _319 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_309 + cbDeferredShading.vScreenPixelSize.z), (_310 + cbDeferredShading.vScreenPixelSize.w)));
              if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _319.x) - cbSharedPerViewData.vViewRemap.y)) - _237) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _319.y) - cbSharedPerViewData.vViewRemap.y)) - _237) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _319.z) - cbSharedPerViewData.vViewRemap.y)) - _237) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _319.w) - cbSharedPerViewData.vViewRemap.y)) - _237) > 0.029999999329447746f)) {
                _353 = abs(_119.x - _319.w);
                _355 = abs(_119.x - _319.z);
                _356 = (_355 < _353);
                _358 = select(_356, _355, _353);
                _360 = abs(_119.x - _319.x);
                _361 = (_360 < _358);
                if (abs(_119.x - _319.y) < select(_361, _360, _358)) {
                  _370 = _313;
                  _371 = _314;
                } else {
                  _370 = select(_361, _309, select(_356, _313, _309));
                  _371 = select(_361, _314, _310);
                }
              } else {
                _370 = _289;
                _371 = _290;
              }
            }
            _374 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_370, _371), 0.0f);
            _378 = _374.x - _374.z;
            _390 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_374.y + _378)), 0.0f);
            _391 = -0.0f - _390;
            _392 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_374.x + _374.z)), 0.0f);
            _393 = -0.0f - _392;
            _394 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_378 - _374.y)), 0.0f);
            _395 = -0.0f - _394;
            _398 = (cbSharedPerViewData.nSSGIEnabled == 0);
            do {
              _409 = 1.0f;
              if (!(_398)) {
                if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
                  _409 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_370, _371), 0.0f)).x);
                } else {
                  _409 = 1.0f;
                }
              }
              do {
                _447 = 0;
                _448 = 0.0f;
                _449 = 0.0f;
                _450 = 0.0f;
                if (!(_398)) {
                  _412 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
                  _413 = (int)(uint)(_412);
                  if (_412) {
                    _416 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_370, _371), 0.0f);
                    _421 = (_416.x * 2.0f) + -1.0f;
                    _422 = (_416.y * 2.0f) + -1.0f;
                    _426 = (1.0f - abs(_421)) - abs(_422);
                    _428 = saturate(-0.0f - _426);
                    _429 = -0.0f - _428;
                    _434 = select((_421 >= 0.0f), _429, _428) + _421;
                    _435 = select((_422 >= 0.0f), _429, _428) + _422;
                    _437 = rsqrt(dot(float3(_434, _435, _426), float3(_434, _435, _426)));
                    _438 = _434 * _437;
                    _439 = _435 * _437;
                    _440 = _437 * _426;
                    _442 = rsqrt(dot(float3(_438, _439, _440), float3(_438, _439, _440)));
                    _447 = _413;
                    _448 = (_438 * _442);
                    _449 = (_439 * _442);
                    _450 = (_442 * _440);
                  } else {
                    _447 = _413;
                    _448 = 0.0f;
                    _449 = 0.0f;
                    _450 = 0.0f;
                  }
                }
                _451 = 1.0f - _207;
                _455 = -0.0f - _136;
                _456 = -0.0f - _137;
                _458 = rsqrt(dot(float3(_455, _456, 1.0f), float3(_455, _456, 1.0f)));
                _459 = _458 * _455;
                _460 = _458 * _456;
                _468 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _66) + _65))];
                _469 = _468 & 255;
                _470 = (uint)(_468) >> 8;
                _471 = _470 & 255;
                _475 = ((float)((uint)((uint)(((uint)(_468) >> 16) & 255)))) * 0.003921568859368563f;
                _477 = (float)((uint)((uint)((uint)(_468) >> 24)));
                _478 = _477 * 0.003921568859368563f;
                do {
                  _1097 = 0.0f;
                  _1098 = 0.0f;
                  _1099 = 0.0f;
                  _1100 = 0.0f;
                  _1101 = 0.0f;
                  _1102 = 0.0f;
                  [branch]
                  if (!((_243 == 2) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
                    _488 = _223 * 4.0f;
                    _493 = dot(float3((-0.0f - _459), (-0.0f - _460), (-0.0f - _458)), float3(_195, _196, _197)) * 2.0f;
                    _497 = _223 * _223;
                    _498 = 1.0f - _497;
                    _501 = (sqrt(_498) + _497) * _498;
                    _514 = (_501 * (((-0.0f - _195) - _459) - (_493 * _195))) + _195;
                    _515 = (_501 * (((-0.0f - _196) - _460) - (_493 * _196))) + _196;
                    _516 = (_501 * (((-0.0f - _197) - _458) - (_493 * _197))) + _197;
                    _520 = saturate(1.0f - ((_223 + -0.30000001192092896f) * 3.3333332538604736f));
                    _535 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _516, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _515, (_514 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
                    _538 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _516, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _515, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _514)));
                    _541 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _516, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _515, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _514)));
                    _544 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _197, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _196, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _195)));
                    _547 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _197, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _196, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _195)));
                    _550 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _197, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _196, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _195)));
                    do {
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
                      _890 = 0.0f;
                      _891 = 0.0f;
                      _892 = 0.0f;
                      if (!(_global_0 == 0)) {
                        _569 = 0;
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
                        _581 = 0.0f;
                        _582 = 0.0f;
                        _583 = 0.0f;
                        bool _loop_break_1 = false;
                        while (true) {
                          _586 = _global_5[min((uint)(_569), 63u)];
                          _587 = _global_6[min((uint)(_569), 63u)];
                          _590 = asfloat(srvLightInfoProperties.Load4(_587)).x;
                          _591 = asfloat(srvLightInfoProperties.Load4(_587)).y;
                          _592 = asfloat(srvLightInfoProperties.Load4(_587)).z;
                          _593 = asfloat(srvLightInfoProperties.Load4(_587)).w;
                          _596 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 16u)))).x;
                          _597 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 16u)))).y;
                          _598 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 16u)))).z;
                          _599 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 16u)))).w;
                          _602 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 32u)))).x;
                          _603 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 32u)))).y;
                          _604 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 32u)))).z;
                          _605 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 32u)))).w;
                          _608 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 48u)))).x;
                          _609 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 48u)))).y;
                          _610 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 48u)))).z;
                          _611 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 48u)))).w;
                          _614 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 64u)))).x;
                          _615 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 64u)))).y;
                          _616 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 64u)))).z;
                          _617 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 64u)))).w;
                          _620 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 80u)))).x;
                          _621 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 80u)))).y;
                          _622 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 80u)))).z;
                          _623 = asfloat(srvLightInfoProperties.Load4(((int)(_587 + 80u)))).w;
                          _626 = asint(srvLightInfoProperties.Load(((int)(_587 + 96u))));
                          _629 = asfloat(srvLightInfoProperties.Load3(((int)(_587 + 100u)))).x;
                          _630 = asfloat(srvLightInfoProperties.Load3(((int)(_587 + 100u)))).y;
                          _631 = asfloat(srvLightInfoProperties.Load3(((int)(_587 + 100u)))).z;
                          _634 = asfloat(srvLightInfoProperties.Load3(((int)(_587 + 112u)))).x;
                          _635 = asfloat(srvLightInfoProperties.Load3(((int)(_587 + 112u)))).y;
                          _636 = asfloat(srvLightInfoProperties.Load3(((int)(_587 + 112u)))).z;
                          _639 = asint(srvLightInfoProperties.Load(((int)(_587 + 124u))));
                          _642 = asint(srvLightInfoProperties.Load(((int)(_587 + 128u))));
                          _645 = _626 & 65535;
                          _674 = ((saturate(1.0f - abs(mad(_592, _240, mad(_591, _239, (_590 * _238))) + _593)) * f16tof32(((uint)((uint)(_626) >> 16)))) * saturate(1.0f - abs(mad(_598, _240, mad(_597, _239, (_596 * _238))) + _599))) * saturate(1.0f - abs(mad(_604, _240, mad(_603, _239, (_602 * _238))) + _605));
                          do {
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
                            _872 = _581;
                            _873 = _582;
                            _874 = _583;
                            [branch]
                            if (_674 > 0.0f) {
                              _677 = _674 * _674;
                              do {
                                _698 = 0.0f;
                                _699 = 0.0f;
                                _700 = 0.0f;
                                [branch]
                                if (_520 < 1.0f) {
                                  _680 = (float)((uint)_645);
                                  _681 = -0.0f - _535;
                                  [branch]
                                  if (!(!(_680 >= 341.0f))) {
                                    _687 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_681, _538, _541, (_680 + -341.0f)), _488);
                                    _698 = _687.x;
                                    _699 = _687.y;
                                    _700 = _687.z;
                                  } else {
                                    _693 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_681, _538, _541, _680), _488);
                                    _698 = _693.x;
                                    _699 = _693.y;
                                    _700 = _693.z;
                                  }
                                }
                                _702 = (float)((uint)_645);
                                do {
                                  _787 = 0.0f;
                                  _788 = 0.0f;
                                  _789 = 0.0f;
                                  [branch]
                                  if (_520 > 0.0f) {
                                    _706 = mad(_610, _516, mad(_609, _515, (_608 * _514)));
                                    _709 = mad(_616, _516, mad(_615, _515, (_614 * _514)));
                                    _712 = mad(_622, _516, mad(_621, _515, (_620 * _514)));
                                    _753 = min(((((float((int)(((int)(uint)((int)(_706 > 0.0f))) - ((int)(uint)((int)(_706 < 0.0f))))) * _629) - _611) - mad(_610, _240, mad(_609, _239, (_608 * _238)))) / _706), min(((((float((int)(((int)(uint)((int)(_709 > 0.0f))) - ((int)(uint)((int)(_709 < 0.0f))))) * _630) - _617) - mad(_616, _240, mad(_615, _239, (_614 * _238)))) / _709), ((((float((int)(((int)(uint)((int)(_712 > 0.0f))) - ((int)(uint)((int)(_712 < 0.0f))))) * _631) - _623) - mad(_622, _240, mad(_621, _239, (_620 * _238)))) / _712)));
                                    _758 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _240, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _239, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _238))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _634) + (_753 * _535);
                                    _760 = ((mad((cbSharedPerViewData.mViewToWorld[0][1].z), _240, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _239, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _238))) + (cbSharedPerViewData.mViewToWorld[0][1].w)) - _635) + (_753 * _538);
                                    _762 = ((mad((cbSharedPerViewData.mViewToWorld[0][2].z), _240, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _239, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _238))) + (cbSharedPerViewData.mViewToWorld[0][2].w)) - _636) + (_753 * _541);
                                    _769 = (max(log2((_753 * _753) / dot(float3(_758, _760, _762), float3(_758, _760, _762))), -1.0f) * 0.3333333432674408f) + _488;
                                    _770 = -0.0f - _758;
                                    [branch]
                                    if (!(!(_702 >= 341.0f))) {
                                      _776 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_770, _760, _762, (_702 + -341.0f)), _769);
                                      _787 = _776.x;
                                      _788 = _776.y;
                                      _789 = _776.z;
                                    } else {
                                      _782 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_770, _760, _762, _702), _769);
                                      _787 = _782.x;
                                      _788 = _782.y;
                                      _789 = _782.z;
                                    }
                                  }
                                  _790 = -0.0f - _544;
                                  do {
                                    [branch]
                                    if (!(!(_702 >= 341.0f))) {
                                      _796 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_790, _547, _550, (_702 + -341.0f)), 0.0f);
                                      _807 = _796.x;
                                      _808 = _796.y;
                                      _809 = _796.z;
                                    } else {
                                      _802 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_790, _547, _550, _702), 0.0f);
                                      _807 = _802.x;
                                      _808 = _802.y;
                                      _809 = _802.z;
                                    }
                                    _819 = _677 * f16tof32(((uint)((uint)(_639) >> 16)));
                                    _820 = _819 * _807;
                                    _821 = _677 * f16tof32(_639);
                                    _822 = _821 * _808;
                                    _823 = _677 * f16tof32(((uint)((uint)(_642) >> 16)));
                                    _824 = _823 * _809;
                                    _825 = _819 * (lerp(_698, _787, _520));
                                    _826 = _821 * (lerp(_699, _788, _520));
                                    _827 = _823 * (lerp(_700, _789, _520));
                                    do {
                                      _841 = _570;
                                      _842 = _571;
                                      _843 = _572;
                                      _844 = _573;
                                      _845 = _574;
                                      _846 = _575;
                                      _847 = _576;
                                      [branch]
                                      if (!((_586 & ((int)(1 << (_468 & 31)))) == 0)) {
                                        _841 = (_820 + _570);
                                        _842 = (_822 + _571);
                                        _843 = (_824 + _572);
                                        _844 = (_825 + _573);
                                        _845 = (_826 + _574);
                                        _846 = (_827 + _575);
                                        _847 = (_677 + _576);
                                      }
                                      [branch]
                                      if (!((_586 & ((int)(1 << (_470 & 31)))) == 0)) {
                                        _861 = _841;
                                        _862 = _842;
                                        _863 = _843;
                                        _864 = _844;
                                        _865 = _845;
                                        _866 = _846;
                                        _867 = _847;
                                        _868 = (_820 + _577);
                                        _869 = (_822 + _578);
                                        _870 = (_824 + _579);
                                        _871 = (_825 + _580);
                                        _872 = (_826 + _581);
                                        _873 = (_827 + _582);
                                        _874 = (_677 + _583);
                                      } else {
                                        _861 = _841;
                                        _862 = _842;
                                        _863 = _843;
                                        _864 = _844;
                                        _865 = _845;
                                        _866 = _846;
                                        _867 = _847;
                                        _868 = _577;
                                        _869 = _578;
                                        _870 = _579;
                                        _871 = _580;
                                        _872 = _581;
                                        _873 = _582;
                                        _874 = _583;
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
                            _875 = _569 + 1u;
                            do {
                              if (!(_875 == _global_0)) {
                                _569 = _875;
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
                                _581 = _872;
                                _582 = _873;
                                _583 = _874;
                                _loop_break_1 = true;
                                break;
                              }
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
                              _890 = _872;
                              _891 = _873;
                              _892 = _874;
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
                      _898 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_468 & 31)))) != 0);
                      do {
                        _1004 = 0.0f;
                        _1005 = 0.0f;
                        _1006 = 0.0f;
                        _1007 = 0.0f;
                        _1008 = 0.0f;
                        _1009 = 0.0f;
                        if ((_475 > 0.0f) || ((_478 > 0.0f) || _898)) {
                          _908 = srvFallbackInfo[((_469 << 2) | 3)].x;
                          _910 = select(_898, 9.999999747378752e-05f, (_477 * 3.921568847431445e-09f));
                          _911 = _885 * 0.20000000298023224f;
                          _918 = saturate((_910 - _911) / (((_885 * 0.4000000059604645f) + 9.99999993922529e-09f) - _911)) * _910;
                          do {
                            _984 = _885;
                            _985 = _882;
                            _986 = _883;
                            _987 = _884;
                            _988 = _879;
                            _989 = _880;
                            _990 = _881;
                            [branch]
                            if (_918 > 0.0f) {
                              do {
                                _976 = _882;
                                _977 = _883;
                                _978 = _884;
                                _979 = _879;
                                _980 = _880;
                                _981 = _881;
                                [branch]
                                if ((int)_908 > (int)-1) {
                                  _923 = float((int)(_908));
                                  _924 = -0.0f - _535;
                                  _925 = !(_923 >= 341.0f);
                                  do {
                                    [branch]
                                    if (!(_925)) {
                                      _930 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_924, _538, _541, (_923 + -341.0f)), _488);
                                      _941 = _930.x;
                                      _942 = _930.y;
                                      _943 = _930.z;
                                    } else {
                                      _936 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_924, _538, _541, _923), _488);
                                      _941 = _936.x;
                                      _942 = _936.y;
                                      _943 = _936.z;
                                    }
                                    _947 = -0.0f - _544;
                                    do {
                                      [branch]
                                      if (!(_925)) {
                                        _952 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_947, _547, _550, (_923 + -341.0f)), 0.0f);
                                        _963 = _952.x;
                                        _964 = _952.y;
                                        _965 = _952.z;
                                      } else {
                                        _958 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_947, _547, _550, _923), 0.0f);
                                        _963 = _958.x;
                                        _964 = _958.y;
                                        _965 = _958.z;
                                      }
                                      _976 = ((_941 * _918) + _882);
                                      _977 = ((_942 * _918) + _883);
                                      _978 = ((_943 * _918) + _884);
                                      _979 = ((_963 * _918) + _879);
                                      _980 = ((_964 * _918) + _880);
                                      _981 = ((_965 * _918) + _881);
                                    } while (false);
                                  } while (false);
                                }
                                _984 = (_918 + _885);
                                _985 = _976;
                                _986 = _977;
                                _987 = _978;
                                _988 = _979;
                                _989 = _980;
                                _990 = _981;
                              } while (false);
                            }
                            if (_984 > 0.0f) {
                              _996 = (cbSharedPerViewData.vHDRScale.x * _475) / _984;
                              _1004 = (_996 * _988);
                              _1005 = (_996 * _989);
                              _1006 = (_996 * _990);
                              _1007 = (_996 * _985);
                              _1008 = (_996 * _986);
                              _1009 = (_996 * _987);
                            } else {
                              _1004 = 0.0f;
                              _1005 = 0.0f;
                              _1006 = 0.0f;
                              _1007 = 0.0f;
                              _1008 = 0.0f;
                              _1009 = 0.0f;
                            }
                          } while (false);
                        }
                        [branch]
                        if (!(_478 == 0.0f)) {
                          _1016 = srvFallbackInfo[((_471 << 2) | 3)].x;
                          _1017 = _477 * 3.921568847431445e-09f;
                          do {
                            _1073 = _889;
                            _1074 = _890;
                            _1075 = _891;
                            _1076 = _886;
                            _1077 = _887;
                            _1078 = _888;
                            [branch]
                            if ((int)_1016 > (int)-1) {
                              _1020 = float((int)(_1016));
                              _1021 = -0.0f - _535;
                              _1022 = !(_1020 >= 341.0f);
                              do {
                                [branch]
                                if (!(_1022)) {
                                  _1027 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1021, _538, _541, (_1020 + -341.0f)), _488);
                                  _1038 = _1027.x;
                                  _1039 = _1027.y;
                                  _1040 = _1027.z;
                                } else {
                                  _1033 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1021, _538, _541, _1020), _488);
                                  _1038 = _1033.x;
                                  _1039 = _1033.y;
                                  _1040 = _1033.z;
                                }
                                _1044 = -0.0f - _544;
                                do {
                                  [branch]
                                  if (!(_1022)) {
                                    _1049 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1044, _547, _550, (_1020 + -341.0f)), 0.0f);
                                    _1060 = _1049.x;
                                    _1061 = _1049.y;
                                    _1062 = _1049.z;
                                  } else {
                                    _1055 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1044, _547, _550, _1020), 0.0f);
                                    _1060 = _1055.x;
                                    _1061 = _1055.y;
                                    _1062 = _1055.z;
                                  }
                                  _1073 = ((_1038 * _1017) + _889);
                                  _1074 = ((_1039 * _1017) + _890);
                                  _1075 = ((_1040 * _1017) + _891);
                                  _1076 = ((_1060 * _1017) + _886);
                                  _1077 = ((_1061 * _1017) + _887);
                                  _1078 = ((_1062 * _1017) + _888);
                                } while (false);
                              } while (false);
                            }
                            _1083 = (cbSharedPerViewData.vHDRScale.x * _478) / (_892 + _1017);
                            _1097 = ((_1083 * _1076) + _1004);
                            _1098 = ((_1083 * _1077) + _1005);
                            _1099 = ((_1083 * _1078) + _1006);
                            _1100 = ((_1083 * _1073) + _1007);
                            _1101 = ((_1083 * _1074) + _1008);
                            _1102 = ((_1083 * _1075) + _1009);
                          } while (false);
                        } else {
                          _1097 = _1004;
                          _1098 = _1005;
                          _1099 = _1006;
                          _1100 = _1007;
                          _1101 = _1008;
                          _1102 = _1009;
                        }
                      } while (false);
                    } while (false);
                  }
                  do {
                    _1121 = _1100;
                    _1122 = _1101;
                    _1123 = _1102;
                    [branch]
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
                      _1121 = (min((_391 / max(9.999999747378752e-05f, _1097)), 1.0f) * _1100);
                      _1122 = (min((_393 / max(9.999999747378752e-05f, _1098)), 1.0f) * _1101);
                      _1123 = (min((_395 / max(9.999999747378752e-05f, _1099)), 1.0f) * _1102);
                    }
                    _1136 = saturate(dot(float3(_459, _460, _458), float3(_195, _196, _197)));
                    _1139 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1136, _223), 0.0f);
                    _1142 = _1139.x + _1139.y;
                    _1143 = 1.0f - _1142;
                    _1147 = max(9.999999747378752e-06f, _1142);
                    _1151 = ((_1143 * _215) / _1147) + 1.0f;
                    _1152 = ((_1143 * _216) / _1147) + 1.0f;
                    _1153 = ((_1143 * _217) / _1147) + 1.0f;
                    _1160 = min(select((cbSharedPerViewData.nPathTracingIsEnabled == 0), (_168 * _168), 1.0f), _409);
                    do {
                      _1288 = _1160;
                      if (!(_global_1 == 0)) {
                        _1164 = 0;
                        _1165 = _1160;
                        bool _loop_break_2 = false;
                        while (true) {
                          _1166 = _1164 + (uint)(_global_0);
                          _1169 = _global_5[min((uint)(_1166), 63u)];
                          _1170 = _global_6[min((uint)(_1166), 63u)];
                          _1174 = (int)((int)(_1169 << (((int)(31u - _468)) & 31))) >> 31;
                          _1178 = (int)((int)(_1169 << ((31 - _470) & 31))) >> 31;
                          _1190 = saturate((asfloat((_1174 & asint(_475))) + asfloat((_1178 & asint(_478)))) + asfloat(((_1178 & 1065353216) & _1174)));
                          do {
                            _1283 = _1165;
                            [branch]
                            if (!(_1190 == 0.0f)) {
                              _1195 = asfloat(srvLightInfoProperties.Load4(_1170)).x;
                              _1196 = asfloat(srvLightInfoProperties.Load4(_1170)).y;
                              _1197 = asfloat(srvLightInfoProperties.Load4(_1170)).z;
                              _1198 = asfloat(srvLightInfoProperties.Load4(_1170)).w;
                              _1201 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 16u)))).x;
                              _1202 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 16u)))).y;
                              _1203 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 16u)))).z;
                              _1204 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 16u)))).w;
                              _1207 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 32u)))).x;
                              _1208 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 32u)))).y;
                              _1209 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 32u)))).z;
                              _1210 = asfloat(srvLightInfoProperties.Load4(((int)(_1170 + 32u)))).w;
                              _1213 = asint(srvLightInfoProperties.Load(((int)(_1170 + 48u))));
                              _1216 = asint(srvLightInfoProperties.Load(((int)(_1170 + 52u))));
                              _1219 = asint(srvLightInfoProperties.Load(((int)(_1170 + 56u))));
                              _1222 = asint(srvLightInfoProperties.Load(((int)(_1170 + 60u))));
                              _1237 = mad(_1197, _240, mad(_1196, _239, (_1195 * _238))) + _1198;
                              _1241 = mad(_1203, _240, mad(_1202, _239, (_1201 * _238))) + _1204;
                              _1245 = mad(_1209, _240, mad(_1208, _239, (_1207 * _238))) + _1210;
                              _1270 = saturate(1.0f - ((_1237 + 1.0f) * f16tof32(_1216))) + saturate(1.0f - ((1.0f - _1237) * f16tof32(((uint)((uint)(_1216) >> 16)))));
                              _1271 = saturate(1.0f - ((_1241 + 1.0f) * f16tof32(_1219))) + saturate(1.0f - ((1.0f - _1241) * f16tof32(((uint)((uint)(_1219) >> 16)))));
                              _1272 = saturate(1.0f - ((_1245 + 1.0f) * f16tof32(_1222))) + saturate(1.0f - ((1.0f - _1245) * f16tof32(((uint)((uint)(_1222) >> 16)))));
                              _1275 = saturate(1.0f - dot(float3(_1270, _1271, _1272), float3(_1270, _1271, _1272)));
                              _1283 = (saturate(1.0f - ((_1275 * _1275) * (f16tof32(((uint)((uint)(_1213) >> 16))) * _1190))) * _1165);
                            }
                            _1284 = _1164 + 1u;
                            do {
                              if (!(_1284 == _global_1)) {
                                _1164 = _1284;
                                _1165 = _1283;
                                _loop_break_2 = true;
                                break;
                              }
                              _1288 = _1283;
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
                      _1292 = dot(float3(_161, _162, _163), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                      _1299 = _1288 * saturate(_150.w);
                      _1300 = saturate((_161 * 2.0f) - _1292) * _1299;
                      _1301 = saturate((_162 * 2.0f) - _1292) * _1299;
                      _1302 = saturate((_163 * 2.0f) - _1292) * _1299;
                      _1306 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
                      do {
                        _1318 = _1288;
                        if (_1306) {
                          _1318 = saturate((_1288 + -1.0f) + exp2((_223 * _223) * log2(max((_1288 + _1136), 0.0f))));
                        }
                        do {
                          _1375 = _1318;
                          if (!(_447 == 0)) {
                            _1321 = rsqrt(dot(float3(_448, _449, _450), float3(_448, _449, _450)));
                            _1323 = rsqrt(dot(float3(_195, _196, _197), float3(_195, _196, _197)));
                            _1324 = _1323 * _195;
                            _1325 = _1323 * _196;
                            _1326 = _1323 * _197;
                            if (_1306) {
                              _1331 = max(_223, 0.10000000149011612f);
                              _1332 = -0.0f - _459;
                              _1333 = -0.0f - _460;
                              _1334 = -0.0f - _458;
                              _1336 = dot(float3(_1332, _1333, _1334), float3(_1324, _1325, _1326)) * 2.0f;
                              _1345 = min(max(dot(float3((_1321 * _448), (_1321 * _449), (_1321 * _450)), float3((_1332 - (_1336 * _1324)), (_1333 - (_1336 * _1325)), (_1334 - (_1336 * _1326)))), -1.0f), 1.0f);
                              _1346 = abs(_1345);
                              _1351 = (1.5707963705062866f - (_1346 * 0.1565829962491989f)) * sqrt(1.0f - _1346);
                              _1357 = abs((_1331 - _1288) * 3.1415927410125732f);
                              _1365 = saturate(1.0f - saturate((select((_1345 >= 0.0f), _1351, (3.1415927410125732f - _1351)) - _1357) / (((_1331 + _1288) * 3.1415927410125732f) - _1357)));
                              _1375 = (((_1365 * _1365) * saturate((_1288 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1365 * 2.0f)));
                            } else {
                              _1375 = _1288;
                            }
                          }
                          _1378 = ((_1151 * ((cbSharedPerViewData.vHDRScale.x * _278) + (_1121 * _277))) * ((_1139.x * _215) + _1139.y)) * _1375;
                          _1381 = ((((_1139.x * _216) + _1139.y) * ((cbSharedPerViewData.vHDRScale.x * _279) + (_1122 * _277))) * _1152) * _1375;
                          _1384 = ((((_1139.x * _217) + _1139.y) * ((cbSharedPerViewData.vHDRScale.x * _280) + (_1123 * _277))) * _1153) * _1375;
                          do {
                            _1391 = 1.0f;
                            [branch]
                            if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
                              _1391 = _1288;
                            }
                            do {
                              _1444 = _391;
                              _1445 = _393;
                              _1446 = _395;
                              if (_475 > 0.0f) {
                                _1394 = _469 * 3;
                                _1397 = srvRoomInfo[_1394].x;
                                _1398 = srvRoomInfo[_1394].y;
                                _1399 = srvRoomInfo[_1394].z;
                                _1405 = srvRoomInfo[(_1394 + 1)].x;
                                _1406 = srvRoomInfo[(_1394 + 1)].y;
                                _1407 = srvRoomInfo[(_1394 + 1)].z;
                                _1413 = srvRoomInfo[(_1394 + 2)].x;
                                _1414 = srvRoomInfo[(_1394 + 2)].y;
                                _1415 = srvRoomInfo[(_1394 + 2)].z;
                                _1421 = saturate(dot(float3(_195, _196, _197), float3(asfloat(_1397), asfloat(_1398), asfloat(_1399))) + 0.5f);
                                _1425 = (_1421 * _1421) * (3.0f - (_1421 * 2.0f));
                                _1429 = 1.0f - _1425;
                                _1436 = _1391 * _475;
                                _1444 = ((_1436 * ((_1429 * asfloat(_1413)) + (_1425 * asfloat(_1405)))) - _390);
                                _1445 = ((_1436 * ((_1429 * asfloat(_1414)) + (_1425 * asfloat(_1406)))) - _392);
                                _1446 = ((_1436 * ((_1429 * asfloat(_1415)) + (_1425 * asfloat(_1407)))) - _394);
                              }
                              do {
                                _1499 = _1444;
                                _1500 = _1445;
                                _1501 = _1446;
                                if (_478 > 0.0f) {
                                  _1449 = _471 * 3;
                                  _1452 = srvRoomInfo[_1449].x;
                                  _1453 = srvRoomInfo[_1449].y;
                                  _1454 = srvRoomInfo[_1449].z;
                                  _1460 = srvRoomInfo[(_1449 + 1)].x;
                                  _1461 = srvRoomInfo[(_1449 + 1)].y;
                                  _1462 = srvRoomInfo[(_1449 + 1)].z;
                                  _1468 = srvRoomInfo[(_1449 + 2)].x;
                                  _1469 = srvRoomInfo[(_1449 + 2)].y;
                                  _1470 = srvRoomInfo[(_1449 + 2)].z;
                                  _1476 = saturate(dot(float3(_195, _196, _197), float3(asfloat(_1452), asfloat(_1453), asfloat(_1454))) + 0.5f);
                                  _1480 = (_1476 * _1476) * (3.0f - (_1476 * 2.0f));
                                  _1484 = 1.0f - _1480;
                                  _1491 = _1391 * _478;
                                  _1499 = ((_1491 * ((_1484 * asfloat(_1468)) + (_1480 * asfloat(_1460)))) + _1444);
                                  _1500 = ((_1491 * ((_1484 * asfloat(_1469)) + (_1480 * asfloat(_1461)))) + _1445);
                                  _1501 = ((_1491 * ((_1484 * asfloat(_1470)) + (_1480 * asfloat(_1462)))) + _1446);
                                }
                                do {
                                  _1611 = 0.0f;
                                  if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
                                    _1524 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _240, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _239, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _238))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
                                    _1528 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _240, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _239, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _238))) + (cbSharedPerViewData.mViewToWorld[0][1].w);
                                    _1532 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _240, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _239, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _238))) + (cbSharedPerViewData.mViewToWorld[0][2].w);
                                    _1551 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1532, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1528, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1524))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
                                    _1555 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1532, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1528, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1524))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
                                    _1559 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1532, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1528, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1524))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
                                    _1572 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
                                    _1573 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
                                    _1574 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
                                    _1611 = min(min(saturate((_1551 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1572), 9.999999747378752e-06f)), saturate((1.0f - _1551) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1572), 9.999999747378752e-06f))), min(min(saturate((_1555 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1573), 9.999999747378752e-06f)), saturate((1.0f - _1555) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1573), 9.999999747378752e-06f))), min(saturate((_1559 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1574), 9.999999747378752e-06f)), saturate((1.0f - _1559) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1574), 9.999999747378752e-06f)))));
                                  }
                                  _1612 = (uint)(_global_1) + (uint)(_global_0);
                                  do {
                                    _8866 = _1499;
                                    _8867 = _1500;
                                    _8868 = _1501;
                                    _8869 = _1378;
                                    _8870 = _1381;
                                    _8871 = _1384;
                                    if ((uint)_1612 < (uint)_global_2) {
                                      _1616 = _1499;
                                      _1617 = _1500;
                                      _1618 = _1501;
                                      _1619 = _1378;
                                      _1620 = _1381;
                                      _1621 = _1384;
                                      _1622 = _1612;
                                      bool _loop_break_3 = false;
                                      while (true) {
                                        _1624 = _global_3[min((uint)(_1622), 63u)];
                                        _1628 = _global_4[min((uint)(_1622), 63u)];
                                        _1629 = _global_5[min((uint)(_1622), 63u)];
                                        _1630 = _global_6[min((uint)(_1622), 63u)];
                                        _1631 = _1624 & 4095;
                                        do {
                                          _8856 = _1616;
                                          _8857 = _1617;
                                          _8858 = _1618;
                                          _8859 = _1619;
                                          _8860 = _1620;
                                          _8861 = _1621;
                                          [branch]
                                          if (((((int)(uint(saturate(_154.w) * 255.0f)) & 64) != 0) || ((_1628 & 8388608) == 0)) && (((int)(uint((saturate(_154.z) * 1.9921875f) + 0.003921568859368563f)) != 0) || ((_1628 & 16777216) == 0))) {
                                            _1643 = (int)((int)(_1629 << (((int)(31u - _468)) & 31))) >> 31;
                                            _1647 = (int)((int)(_1629 << ((31 - _470) & 31))) >> 31;
                                            _1659 = saturate((asfloat((_1643 & asint(_475))) + asfloat((_1647 & asint(_478)))) + asfloat(((_1647 & 1065353216) & _1643)));
                                            [branch]
                                            if (!(_1659 == 0.0f)) {
                                              _1662 = (uint)(_1624) >> 12;
                                              if (_1662 == 6) {
                                                do {
                                                  _3230 = _1659;
                                                  if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                                                    _3230 = (_1659 * select(((_1628 & 67108864) != 0), 1.0f, (1.0f - _1611)));
                                                  }
                                                  _3233 = asfloat(srvLightInfoProperties.Load4(_1630)).x;
                                                  _3234 = asfloat(srvLightInfoProperties.Load4(_1630)).y;
                                                  _3235 = asfloat(srvLightInfoProperties.Load4(_1630)).z;
                                                  _3236 = asfloat(srvLightInfoProperties.Load4(_1630)).w;
                                                  _3239 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).x;
                                                  _3240 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).y;
                                                  _3241 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).z;
                                                  _3242 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).w;
                                                  _3245 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).x;
                                                  _3246 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).y;
                                                  _3247 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).z;
                                                  _3248 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).w;
                                                  _3251 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).x;
                                                  _3252 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).y;
                                                  _3253 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).z;
                                                  _3256 = asint(srvLightInfoProperties.Load(((int)(_1630 + 68u))));
                                                  _3259 = asint(srvLightInfoProperties.Load(((int)(_1630 + 72u))));
                                                  _3262 = asint(srvLightInfoProperties.Load(((int)(_1630 + 76u))));
                                                  _3265 = asint(srvLightInfoProperties.Load(((int)(_1630 + 84u))));
                                                  _3268 = asint(srvLightInfoProperties.Load(((int)(_1630 + 88u))));
                                                  _3271 = asint(srvLightInfoProperties.Load(((int)(_1630 + 92u))));
                                                  _3274 = (float)((uint)((uint)(((uint)(_3256) >> 8) & 255)));
                                                  _3278 = ((float)((uint)((uint)(_3256 & 255)))) * 0.003921499941498041f;
                                                  _3280 = f16tof32(((uint)((uint)(_3259) >> 16)));
                                                  _3282 = (uint)(_3262) >> 16;
                                                  _3296 = mad(_3235, _240, mad(_3234, _239, (_3233 * _238))) + _3236;
                                                  _3300 = mad(_3241, _240, mad(_3240, _239, (_3239 * _238))) + _3242;
                                                  _3306 = srvDeferredShadingPass_DeferredShadows.Load(int3(_65, _66, 0));
                                                  _3311 = min((int)(cbSharedPerViewData.nNumCSMCascades), (int)(3));
                                                  do {
                                                    _3401 = false;
                                                    if (!(_3311 == 0)) {
                                                      _3315 = 0;
                                                      bool _loop_break_4 = false;
                                                      bool _loop_exit_4 = false;
                                                      while (true) {
                                                        _3318 = srvLightInfoBase[_1631].nBufferOffset;
                                                        _3330 = asint(srvLightInfoProperties.Load(((int)(_3318 + 160u))));
                                                        _3333 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 164u)))).x;
                                                        _3334 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 164u)))).y;
                                                        _3335 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 164u)))).z;
                                                        _3338 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 176u)))).x;
                                                        _3339 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 176u)))).y;
                                                        _3340 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 176u)))).z;
                                                        do {
                                                          [branch]
                                                          if (_3315 == 0) {
                                                            _3343 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 112u)))).z;
                                                            _3344 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 112u)))).y;
                                                            _3345 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 112u)))).x;
                                                            _3346 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 100u)))).z;
                                                            _3347 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 100u)))).y;
                                                            _3348 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 100u)))).x;
                                                            _3351 = asint(srvLightInfoProperties.Load(((int)(_3318 + 96u))));
                                                            _3366 = _3348;
                                                            _3367 = _3347;
                                                            _3368 = _3346;
                                                            _3369 = _3345;
                                                            _3370 = _3344;
                                                            _3371 = _3343;
                                                            _3372 = _3351;
                                                          } else {
                                                            _3353 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 144u)))).z;
                                                            _3354 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 144u)))).y;
                                                            _3355 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 144u)))).x;
                                                            _3356 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 132u)))).z;
                                                            _3357 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 132u)))).y;
                                                            _3358 = asfloat(srvLightInfoProperties.Load3(((int)(_3318 + 132u)))).x;
                                                            _3361 = asint(srvLightInfoProperties.Load(((int)(_3318 + 128u))));
                                                            if (!(_3315 == 1)) {
                                                              if (!(_3315 == 2)) {
                                                                _3399 = false;
                                                                _3401 = _3399;
                                                                break;
                                                              } else {
                                                                _3366 = _3333;
                                                                _3367 = _3334;
                                                                _3368 = _3335;
                                                                _3369 = _3338;
                                                                _3370 = _3339;
                                                                _3371 = _3340;
                                                                _3372 = _3330;
                                                              }
                                                            } else {
                                                              _3366 = _3358;
                                                              _3367 = _3357;
                                                              _3368 = _3356;
                                                              _3369 = _3355;
                                                              _3370 = _3354;
                                                              _3371 = _3353;
                                                              _3372 = _3361;
                                                            }
                                                          }
                                                          do {
                                                            _3399 = false;
                                                            if (!((uint)_3372 < (uint)65536)) {
                                                              if (!((((0.5f - abs(((_3366 * _3296) + -0.5f) + _3369)) >= 0.0f) && ((0.5f - abs(((_3367 * _3300) + -0.5f) + _3370)) >= 0.0f)) && ((0.5f - abs(((_3368 * (mad(_3247, _240, mad(_3246, _239, (_3245 * _238))) + _3248)) + -0.5f) + _3371)) >= 0.0f))) {
                                                                _3396 = _3315 + 1u;
                                                                if ((uint)_3396 < (uint)_3311) {
                                                                  _3315 = _3396;
                                                                  _loop_break_4 = true;
                                                                  break;
                                                                } else {
                                                                  _3399 = false;
                                                                }
                                                              } else {
                                                                _3399 = true;
                                                              }
                                                            }
                                                            _3401 = _3399;
                                                          } while (false);
                                                          if ((_loop_break_4 || _loop_exit_4) && !_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_4 && !_loop_break_3) {
                                                          _loop_break_4 = false;
                                                          continue;
                                                        }
                                                        break;
                                                      }
                                                      if (_loop_break_3) break;
                                                    }
                                                    [branch]
                                                    if (!(_3306.x == 0.0f)) {
                                                      do {
                                                        _3424 = cbSharedPerViewData.vAttenuatedSunColor.x;
                                                        _3425 = cbSharedPerViewData.vAttenuatedSunColor.y;
                                                        _3426 = cbSharedPerViewData.vAttenuatedSunColor.z;
                                                        [branch]
                                                        if (!(_3282 == 0)) {
                                                          Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3282)))];
                                                          _3416 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2(((_3296 * f16tof32(((uint)((uint)(_3268) >> 16)))) + f16tof32(((uint)((uint)(_3271) >> 16)))), ((_3300 * f16tof32(_3268)) + f16tof32(_3271))), 0.0f);
                                                          _3424 = (_3416.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                                                          _3425 = (_3416.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                                                          _3426 = (_3416.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                                                        }
                                                        do {
                                                          _3446 = _1619;
                                                          _3447 = _1620;
                                                          _3448 = _1621;
                                                          if (((_243 == 3) || (!_242)) && _3401) {
                                                            _3435 = (_3306.x * _3230) * saturate(0.30000001192092896f - dot(float3(_3251, _3252, _3253), float3(_195, _196, _197)));
                                                            _3446 = (((_3424 * _1300) * _3435) + _1619);
                                                            _3447 = (((_3425 * _1301) * _3435) + _1620);
                                                            _3448 = (((_3426 * _1302) * _3435) + _1621);
                                                          }
                                                          _3451 = min(_3306.x, _3306.y) * _3230;
                                                          [branch]
                                                          if (_3451 > 0.0f) {
                                                            _3454 = dot(float3(_3251, _3252, _3253), float3(_3251, _3252, _3253));
                                                            _3455 = rsqrt(_3454);
                                                            _3456 = _3455 * _3251;
                                                            _3457 = _3455 * _3252;
                                                            _3458 = _3455 * _3253;
                                                            _3459 = dot(float3(_195, _196, _197), float3(_3456, _3457, _3458));
                                                            do {
                                                              _3477 = _3459;
                                                              if (_3280 > 0.0f) {
                                                                _3467 = sqrt(saturate((_3280 * _3280) * (1.0f / (_3454 + 1.0f))));
                                                                if (_3459 < _3467) {
                                                                  _3472 = max(_3459, (-0.0f - _3467)) + _3467;
                                                                  _3477 = ((_3472 * _3472) / (_3467 * 4.0f));
                                                                } else {
                                                                  _3477 = _3459;
                                                                }
                                                              }
                                                              _3478 = _223 * _223;
                                                              _3482 = saturate((_3280 * (1.0f - _3478)) * _3455);
                                                              _3484 = saturate(_3455 * f16tof32(_3259));
                                                              _3485 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                              _3486 = dot(float3(_459, _460, _458), float3(_3456, _3457, _3458));
                                                              _3489 = rsqrt((_3486 * 2.0f) + 2.0f);
                                                              _3496 = (_3482 > 0.0f);
                                                              do {
                                                                _3587 = saturate((_3489 * _3486) + _3489);
                                                                _3588 = saturate(_3489 * (_3485 + _3459));
                                                                if (_3496) {
                                                                  _3500 = sqrt(1.0f - (_3482 * _3482));
                                                                  _3502 = (_3459 * 2.0f) * _3485;
                                                                  _3503 = _3502 - _3486;
                                                                  if (!(!(_3503 >= _3500))) {
                                                                    _3587 = abs(_3485);
                                                                    _3588 = 1.0f;
                                                                  } else {
                                                                    _3511 = rsqrt(1.0f - (_3503 * _3503)) * _3482;
                                                                    _3514 = _3511 * (_3485 - (_3503 * _3459));
                                                                    _3515 = _3485 * _3485;
                                                                    _3520 = _3511 * (((_3515 * 2.0f) + -1.0f) - (_3503 * _3486));
                                                                    _3529 = sqrt(saturate((((1.0f - (_3459 * _3459)) - _3515) - (_3486 * _3486)) + (_3502 * _3486)));
                                                                    _3530 = _3529 * _3511;
                                                                    _3533 = ((_3485 * 2.0f) * _3511) * _3529;
                                                                    _3535 = (_3500 * _3459) + _3485;
                                                                    _3536 = _3535 + _3514;
                                                                    _3537 = _3500 * _3486;
                                                                    _3539 = (_3537 + 1.0f) + _3520;
                                                                    _3540 = _3530 * _3539;
                                                                    _3541 = _3536 * _3539;
                                                                    _3542 = _3533 * _3536;
                                                                    _3547 = (((_3536 * 0.25f) * _3533) - (_3540 * 0.5f)) * _3541;
                                                                    _3561 = (((_3542 - (_3540 * 2.0f)) * _3542) + (_3540 * _3540)) + ((((-0.5f - ((_3539 + _3537) * 0.5f)) * _3541) + ((_3539 * _3539) * _3535)) * _3536);
                                                                    _3566 = (_3547 * 2.0f) / ((_3561 * _3561) + (_3547 * _3547));
                                                                    _3567 = _3561 * _3566;
                                                                    _3569 = 1.0f - (_3547 * _3566);
                                                                    _3575 = ((_3567 * _3533) + _3537) + (_3569 * _3520);
                                                                    _3578 = rsqrt((_3575 * 2.0f) + 2.0f);
                                                                    _3587 = saturate((_3575 * _3578) + _3578);
                                                                    _3588 = saturate(((_3535 + (_3567 * _3530)) + (_3569 * _3514)) * _3578);
                                                                  }
                                                                }
                                                                _3589 = saturate(_3477);
                                                                _3590 = _3478 * _3478;
                                                                do {
                                                                  _3600 = _3590;
                                                                  if (_3484 > 0.0f) {
                                                                    _3600 = saturate(((_3484 * _3484) / ((_3587 * 3.5999999046325684f) + 0.4000000059604645f)) + _3590);
                                                                  }
                                                                  _3601 = sqrt(_3600);
                                                                  do {
                                                                    _3612 = 1.0f;
                                                                    if (_3496) {
                                                                      _3612 = (_3600 / ((((_3482 * 0.25f) * ((_3601 * 3.0f) + _3482)) / (_3587 + 0.0010000000474974513f)) + _3600));
                                                                    }
                                                                    _3616 = (((_3600 * _3588) - _3588) * _3588) + 1.0f;
                                                                    _3626 = exp2(log2(1.0f - saturate(_3587)) * 5.0f);
                                                                    _3635 = saturate(abs(_3485) + 9.999999747378752e-06f);
                                                                    _3636 = 1.0f - _3601;
                                                                    _3648 = saturate((_3459 + _3278) / (_3278 + 1.0f));
                                                                    _3651 = ((_3612 * _3589) * (_3600 / (_3616 * _3616))) * (0.5f / ((((_3636 * _3635) + _3601) * _3589) + (((_3636 * _3589) + _3601) * _3635)));
                                                                    do {
                                                                      _3754 = _3424;
                                                                      _3755 = _3425;
                                                                      _3756 = _3426;
                                                                      [branch]
                                                                      if (!((_3265 & 1) == 0)) {
                                                                        _3664 = max(max(_3424, _3425), _3426);
                                                                        do {
                                                                          _3674 = _3424;
                                                                          _3675 = _3425;
                                                                          _3676 = _3426;
                                                                          if (_3664 > 0.0f) {
                                                                            _3674 = saturate(_3424 / _3664);
                                                                            _3675 = saturate(_3425 / _3664);
                                                                            _3676 = saturate(_3426 / _3664);
                                                                          }
                                                                          _3677 = (_3675 < _3676);
                                                                          _3678 = select(_3677, _3676, _3675);
                                                                          _3679 = select(_3677, _3675, _3676);
                                                                          _3680 = select(_3677, -1.0f, 0.0f);
                                                                          _3681 = (_3674 < _3678);
                                                                          _3683 = select(_3681, _3678, _3674);
                                                                          _3684 = select(_3681, _3674, _3678);
                                                                          _3688 = _3683 - select((_3684 < _3679), _3684, _3679);
                                                                          _3694 = abs(select(_3681, (-0.3333333432674408f - _3680), _3680) + ((_3684 - _3679) / ((_3688 * 6.0f) + 9.999999682655225e-21f)));
                                                                          do {
                                                                            _3707 = _3694;
                                                                            if (_3694 < 0.6666666865348816f) {
                                                                              _3707 = ((saturate(((float)((uint)((uint)(((uint)(_3265) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3694 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3694)) + _3694);
                                                                            }
                                                                            _3708 = saturate((_3688 / (_3683 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3265) >> 1) & 255)))) * 0.003921499941498041f));
                                                                            _3709 = saturate(_3683);
                                                                            do {
                                                                              _3736 = _3709;
                                                                              _3737 = _3709;
                                                                              _3738 = _3709;
                                                                              if (!(_3708 <= 0.0f)) {
                                                                                _3712 = saturate(_3707);
                                                                                _3716 = select(((_3712 * 360.0f) >= 360.0f), 0.0f, (_3712 * 6.0f));
                                                                                _3717 = int(_3716);
                                                                                _3719 = _3716 - float((int)(_3717));
                                                                                _3721 = _3709 * (1.0f - _3708);
                                                                                _3724 = (1.0f - (_3719 * _3708)) * _3709;
                                                                                _3728 = (1.0f - ((1.0f - _3719) * _3708)) * _3709;
                                                                                switch (_3717) {
                                                                                  case 0: {
                                                                                    _3736 = _3709;
                                                                                    _3737 = _3728;
                                                                                    _3738 = _3721;
                                                                                    break;
                                                                                  }
                                                                                  case 1: {
                                                                                    _3736 = _3724;
                                                                                    _3737 = _3709;
                                                                                    _3738 = _3721;
                                                                                    break;
                                                                                  }
                                                                                  case 2: {
                                                                                    _3736 = _3721;
                                                                                    _3737 = _3709;
                                                                                    _3738 = _3728;
                                                                                    break;
                                                                                  }
                                                                                  case 3: {
                                                                                    _3736 = _3721;
                                                                                    _3737 = _3724;
                                                                                    _3738 = _3709;
                                                                                    break;
                                                                                  }
                                                                                  case 4: {
                                                                                    _3736 = _3728;
                                                                                    _3737 = _3721;
                                                                                    _3738 = _3709;
                                                                                    break;
                                                                                  }
                                                                                  case 5: {
                                                                                    _3736 = _3709;
                                                                                    _3737 = _3721;
                                                                                    _3738 = _3724;
                                                                                    break;
                                                                                  }
                                                                                  default: {
                                                                                    _3736 = 0.0f;
                                                                                    _3737 = 0.0f;
                                                                                    _3738 = 0.0f;
                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }
                                                                              _3739 = _3736 * _3664;
                                                                              _3740 = _3737 * _3664;
                                                                              _3741 = _3738 * _3664;
                                                                              _3743 = saturate(_3451 * 1.0101009607315063f);
                                                                              _3754 = ((_3743 * (_3424 - _3739)) + _3739);
                                                                              _3755 = ((_3743 * (_3425 - _3740)) + _3740);
                                                                              _3756 = (lerp(_3741, _3426, _3743));
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      _3757 = _3754 * _3451;
                                                                      _3758 = _3755 * _3451;
                                                                      _3759 = _3756 * _3451;
                                                                      do {
                                                                        _3769 = _3757;
                                                                        _3770 = _3758;
                                                                        _3771 = _3759;
                                                                        if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                                                                          _3769 = (_3757 * _1288);
                                                                          _3770 = (_3758 * _1288);
                                                                          _3771 = (_3759 * _1288);
                                                                        }
                                                                        _3775 = (_3769 * _3648) + _1616;
                                                                        _3776 = (_3770 * _3648) + _1617;
                                                                        _3777 = (_3771 * _3648) + _1618;
                                                                        if ((_3274 * 0.003921499941498041f) > 0.0f) {
                                                                          _3780 = (_1375 * 0.003921499941498041f) * _3274;
                                                                          _8856 = _3775;
                                                                          _8857 = _3776;
                                                                          _8858 = _3777;
                                                                          _8859 = (((((_3780 * _1151) * ((_3626 * (1.0f - _215)) + _215)) * _3651) * _3769) + _3446);
                                                                          _8860 = (((((_3780 * _1152) * ((_3626 * (1.0f - _216)) + _216)) * _3651) * _3770) + _3447);
                                                                          _8861 = (((((_3780 * _1153) * ((_3626 * (1.0f - _217)) + _217)) * _3651) * _3771) + _3448);
                                                                        } else {
                                                                          _8856 = _3775;
                                                                          _8857 = _3776;
                                                                          _8858 = _3777;
                                                                          _8859 = _3446;
                                                                          _8860 = _3447;
                                                                          _8861 = _3448;
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
                                                            _8856 = _1616;
                                                            _8857 = _1617;
                                                            _8858 = _1618;
                                                            _8859 = _3446;
                                                            _8860 = _3447;
                                                            _8861 = _3448;
                                                          }
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } else {
                                                      _8856 = _1616;
                                                      _8857 = _1617;
                                                      _8858 = _1618;
                                                      _8859 = _1619;
                                                      _8860 = _1620;
                                                      _8861 = _1621;
                                                    }
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } else {
                                                _1679 = _1659 * select(((_1628 & 67108864) != 0), 1.0f, (1.0f - _1611));
                                                [branch]
                                                if (_1662 == 4) {
                                                  _1684 = asfloat(srvLightInfoProperties.Load4(_1630)).x;
                                                  _1685 = asfloat(srvLightInfoProperties.Load4(_1630)).y;
                                                  _1686 = asfloat(srvLightInfoProperties.Load4(_1630)).z;
                                                  _1687 = asfloat(srvLightInfoProperties.Load4(_1630)).w;
                                                  _1690 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).x;
                                                  _1691 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).y;
                                                  _1692 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).z;
                                                  _1693 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).w;
                                                  _1696 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).x;
                                                  _1697 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).y;
                                                  _1698 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).z;
                                                  _1699 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).w;
                                                  _1702 = asint(srvLightInfoProperties.Load(((int)(_1630 + 48u))));
                                                  _1705 = asint(srvLightInfoProperties.Load(((int)(_1630 + 52u))));
                                                  _1708 = asint(srvLightInfoProperties.Load(((int)(_1630 + 64u))));
                                                  _1711 = asint(srvLightInfoProperties.Load(((int)(_1630 + 68u))));
                                                  _1714 = asint(srvLightInfoProperties.Load(((int)(_1630 + 72u))));
                                                  _1716 = f16tof32(((uint)((uint)(_1702) >> 16)));
                                                  _1717 = f16tof32(_1702);
                                                  _1719 = f16tof32(((uint)((uint)(_1705) >> 16)));
                                                  _1723 = ((float)((uint)((uint)(((uint)(_1705) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _1736 = mad(_1686, _240, mad(_1685, _239, (_1684 * _238))) + _1687;
                                                  _1740 = mad(_1692, _240, mad(_1691, _239, (_1690 * _238))) + _1693;
                                                  _1744 = mad(_1698, _240, mad(_1697, _239, (_1696 * _238))) + _1699;
                                                  _1769 = saturate(1.0f - ((_1736 + 1.0f) * f16tof32(_1708))) + saturate(1.0f - ((1.0f - _1736) * f16tof32(((uint)((uint)(_1708) >> 16)))));
                                                  _1770 = saturate(1.0f - ((_1740 + 1.0f) * f16tof32(_1711))) + saturate(1.0f - ((1.0f - _1740) * f16tof32(((uint)((uint)(_1711) >> 16)))));
                                                  _1771 = saturate(1.0f - ((_1744 + 1.0f) * f16tof32(_1714))) + saturate(1.0f - ((1.0f - _1744) * f16tof32(((uint)((uint)(_1714) >> 16)))));
                                                  _1774 = saturate(1.0f - dot(float3(_1769, _1770, _1771), float3(_1769, _1770, _1771)));
                                                  _1775 = _1774 * _1774;
                                                  _1782 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1775 * _1288), _1775) * _1679;
                                                  _8856 = ((_1782 * _1716) + _1616);
                                                  _8857 = ((_1782 * _1717) + _1617);
                                                  _8858 = ((_1782 * _1719) + _1618);
                                                  _8859 = (((_1723 * _1716) * _1782) + _1619);
                                                  _8860 = (((_1723 * _1717) * _1782) + _1620);
                                                  _8861 = (((_1719 * _1723) * _1782) + _1621);
                                                } else {
                                                  if (_1662 == 5) {
                                                    _1803 = asfloat(srvLightInfoProperties.Load4(_1630)).x;
                                                    _1804 = asfloat(srvLightInfoProperties.Load4(_1630)).y;
                                                    _1805 = asfloat(srvLightInfoProperties.Load4(_1630)).z;
                                                    _1806 = asfloat(srvLightInfoProperties.Load4(_1630)).w;
                                                    _1809 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).x;
                                                    _1810 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).y;
                                                    _1811 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).z;
                                                    _1812 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).w;
                                                    _1815 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).x;
                                                    _1816 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).y;
                                                    _1817 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).z;
                                                    _1818 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).w;
                                                    _1821 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).x;
                                                    _1822 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).y;
                                                    _1823 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).z;
                                                    _1826 = asfloat(srvLightInfoProperties.Load(((int)(_1630 + 60u))));
                                                    _1829 = asint(srvLightInfoProperties.Load(((int)(_1630 + 64u))));
                                                    _1832 = asint(srvLightInfoProperties.Load(((int)(_1630 + 68u))));
                                                    _1835 = asint(srvLightInfoProperties.Load(((int)(_1630 + 80u))));
                                                    _1838 = asint(srvLightInfoProperties.Load(((int)(_1630 + 84u))));
                                                    _1841 = asint(srvLightInfoProperties.Load(((int)(_1630 + 88u))));
                                                    _1844 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 92u)))).x;
                                                    _1845 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 92u)))).y;
                                                    _1846 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 92u)))).z;
                                                    _1847 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 92u)))).w;
                                                    _1850 = asint(srvLightInfoProperties.Load(((int)(_1630 + 108u))));
                                                    _1853 = asint(srvLightInfoProperties.Load(((int)(_1630 + 112u))));
                                                    _1856 = asint(srvLightInfoProperties.Load(((int)(_1630 + 120u))));
                                                    _1859 = asint(srvLightInfoProperties.Load(((int)(_1630 + 124u))));
                                                    _1862 = asint(srvLightInfoProperties.Load(((int)(_1630 + 128u))));
                                                    _1865 = asint(srvLightInfoProperties.Load(((int)(_1630 + 132u))));
                                                    _1868 = asint(srvLightInfoProperties.Load(((int)(_1630 + 136u))));
                                                    _1871 = asint(srvLightInfoProperties.Load(((int)(_1630 + 140u))));
                                                    _1873 = f16tof32(((uint)((uint)(_1829) >> 16)));
                                                    _1874 = f16tof32(_1829);
                                                    _1876 = f16tof32(((uint)((uint)(_1832) >> 16)));
                                                    _1880 = ((float)((uint)((uint)(((uint)(_1832) >> 8) & 255)))) * 0.003921499941498041f;
                                                    _1883 = ((float)((uint)((uint)(_1832 & 255)))) * 0.003921499941498041f;
                                                    _1885 = f16tof32(((uint)((uint)(_1835) >> 16)));
                                                    _1888 = _1838 & 65535;
                                                    _1898 = f16tof32(((uint)((uint)(_1853) >> 16)));
                                                    _1899 = f16tof32(_1853);
                                                    _1901 = f16tof32(((uint)((uint)(_1856) >> 16)));
                                                    _1902 = 1.0f / _1901;
                                                    _1903 = _1901 + -1.0f;
                                                    _1904 = f16tof32(_1856);
                                                    _1923 = saturate(1.0f - dot(float3(_195, _196, _197), float3(_1821, _1822, _1823))) * f16tof32(_1850);
                                                    _1927 = (_1923 * _195) + _238;
                                                    _1928 = (_1923 * _196) + _239;
                                                    _1929 = (_1923 * _197) - _237;
                                                    _1933 = mad(_1805, _1929, mad(_1804, _1928, (_1927 * _1803))) + _1806;
                                                    _1937 = mad(_1811, _1929, mad(_1810, _1928, (_1927 * _1809))) + _1812;
                                                    _1941 = mad(_1817, _1929, mad(_1816, _1928, (_1927 * _1815))) + _1818;
                                                    _1942 = saturate(_1941);
                                                    _1965 = saturate(1.0f - (_1933 * f16tof32(_1865))) + saturate(1.0f - ((1.0f - _1933) * f16tof32(((uint)((uint)(_1865) >> 16)))));
                                                    _1966 = saturate(1.0f - (_1937 * f16tof32(_1868))) + saturate(1.0f - ((1.0f - _1937) * f16tof32(((uint)((uint)(_1868) >> 16)))));
                                                    _1967 = saturate(1.0f - (_1941 * f16tof32(_1871))) + saturate(1.0f - ((1.0f - _1941) * f16tof32(((uint)((uint)(_1871) >> 16)))));
                                                    _1970 = saturate(1.0f - dot(float3(_1965, _1966, _1967), float3(_1965, _1966, _1967)));
                                                    _1971 = _1970 * _1970;
                                                    _1973 = ((_1628 & 3584) == 0);
                                                    do {
                                                      _2863 = 0.0f;
                                                      _2864 = 1.0f;
                                                      _2865 = 0.0f;
                                                      if (!((!(_1971 > 0.0f)) || _1973)) {
                                                        _1978 = 1.0f - _1942;
                                                        _1979 = saturate(_1933);
                                                        _1980 = saturate(_1937);
                                                        do {
                                                          _2293 = 1.0f;
                                                          _2294 = 1.0f;
                                                          _2295 = 0.0f;
                                                          _2296 = _1978;
                                                          [branch]
                                                          if (!((_1628 & 1024) == 0)) {
                                                            _1985 = ((_1979 * _1903) + 0.5f) * _1902;
                                                            _1987 = ((_1980 * _1903) + 0.5f) * _1902;
                                                            _1988 = _1978 + f16tof32(((uint)((uint)(_1850) >> 16)));
                                                            Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1838) >> 16))];
                                                            _1991 = saturate(_1988);
                                                            _1995 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                            #if FIRSTLIGHT_ISFAST_ENABLED
                                                            if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                              _2004 = RenoDX_ISFASTShadowAngle(
                                                                  uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 0u);
                                                            } else {
                                                              _2004 = frac(frac(dot(float2(((_1995 * 32.665000915527344f) + _127), ((_1995 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            }
                                                            #else
                                                            _2004 = frac(frac(dot(float2(((_1995 * 32.665000915527344f) + _127), ((_1995 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            #endif
                                                            _2005 = sin(_2004);
                                                            _2006 = cos(_2004);
                                                            _2007 = cbSharedPerViewData.nFrameCounter & 3;
                                                            _2012 = sqrt((float((int)(_2007)) * 0.25f) + 0.125f) * _1898;
                                                            _2021 = (_global_7[min((uint)(((int)(0u + (_2007 * 2)))), 127u)]) * _2012;
                                                            _2022 = (_global_7[min((uint)(((int)(1u + (_2007 * 2)))), 127u)]) * _2012;
                                                            _2024 = -0.0f - _2005;
                                                            _2029 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2021, _2022), float2(_2006, _2005)) + _1985), (dot(float2(_2021, _2022), float2(_2024, _2006)) + _1987)));
                                                            _2034 = _2029.x - _1991;
                                                            _2036 = select((_2034 < 0.0f), 0.0f, 1.0f);
                                                            _2038 = _2029.y - _1991;
                                                            _2040 = select((_2038 < 0.0f), 0.0f, 1.0f);
                                                            _2044 = _2029.z - _1991;
                                                            _2046 = select((_2044 < 0.0f), 0.0f, 1.0f);
                                                            _2050 = _2029.w - _1991;
                                                            _2052 = select((_2050 < 0.0f), 0.0f, 1.0f);
                                                            _2059 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                            _2064 = sqrt((float((int)(_2059)) * 0.25f) + 0.125f) * _1898;
                                                            _2073 = (_global_7[min((uint)(((int)(0u + (_2059 * 2)))), 127u)]) * _2064;
                                                            _2074 = (_global_7[min((uint)(((int)(1u + (_2059 * 2)))), 127u)]) * _2064;
                                                            _2080 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2073, _2074), float2(_2006, _2005)) + _1985), (dot(float2(_2073, _2074), float2(_2024, _2006)) + _1987)));
                                                            _2085 = _2080.x - _1991;
                                                            _2087 = select((_2085 < 0.0f), 0.0f, 1.0f);
                                                            _2091 = _2080.y - _1991;
                                                            _2093 = select((_2091 < 0.0f), 0.0f, 1.0f);
                                                            _2097 = _2080.z - _1991;
                                                            _2099 = select((_2097 < 0.0f), 0.0f, 1.0f);
                                                            _2103 = _2080.w - _1991;
                                                            _2105 = select((_2103 < 0.0f), 0.0f, 1.0f);
                                                            _2112 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                            _2117 = sqrt((float((int)(_2112)) * 0.25f) + 0.125f) * _1898;
                                                            _2126 = (_global_7[min((uint)(((int)(0u + (_2112 * 2)))), 127u)]) * _2117;
                                                            _2127 = (_global_7[min((uint)(((int)(1u + (_2112 * 2)))), 127u)]) * _2117;
                                                            _2133 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2126, _2127), float2(_2006, _2005)) + _1985), (dot(float2(_2126, _2127), float2(_2024, _2006)) + _1987)));
                                                            _2138 = _2133.x - _1991;
                                                            _2140 = select((_2138 < 0.0f), 0.0f, 1.0f);
                                                            _2144 = _2133.y - _1991;
                                                            _2146 = select((_2144 < 0.0f), 0.0f, 1.0f);
                                                            _2150 = _2133.z - _1991;
                                                            _2152 = select((_2150 < 0.0f), 0.0f, 1.0f);
                                                            _2156 = _2133.w - _1991;
                                                            _2158 = select((_2156 < 0.0f), 0.0f, 1.0f);
                                                            _2165 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                            _2170 = sqrt((float((int)(_2165)) * 0.25f) + 0.125f) * _1898;
                                                            _2179 = (_global_7[min((uint)(((int)(0u + (_2165 * 2)))), 127u)]) * _2170;
                                                            _2180 = (_global_7[min((uint)(((int)(1u + (_2165 * 2)))), 127u)]) * _2170;
                                                            _2186 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2179, _2180), float2(_2006, _2005)) + _1985), (dot(float2(_2179, _2180), float2(_2024, _2006)) + _1987)));
                                                            _2191 = _2186.x - _1991;
                                                            _2193 = select((_2191 < 0.0f), 0.0f, 1.0f);
                                                            _2197 = _2186.y - _1991;
                                                            _2199 = select((_2197 < 0.0f), 0.0f, 1.0f);
                                                            _2203 = _2186.z - _1991;
                                                            _2205 = select((_2203 < 0.0f), 0.0f, 1.0f);
                                                            _2209 = _2186.w - _1991;
                                                            _2211 = select((_2209 < 0.0f), 0.0f, 1.0f);
                                                            _2212 = ((((((((((((((_2036 + _2040) + _2046) + _2052) + _2087) + _2093) + _2099) + _2105) + _2140) + _2146) + _2152) + _2158) + _2193) + _2199) + _2205) + _2211;
                                                            _2223 = (saturate(_2212 * 0.0625f) * 2.0f) + -1.0f;
                                                            _2229 = float((int)(((int)(uint)((int)(_2223 > 0.0f))) - ((int)(uint)((int)(_2223 < 0.0f)))));
                                                            _2231 = 1.0f - (_2229 * _2223);
                                                            _2233 = (_2231 * _2231) * _2231;
                                                            _2240 = 0.5f - ((_2229 * 0.5f) * ((1.0f - _2233) - ((_2231 - _2233) * saturate(((1.0f / _1991) * (1.0f / _2212)) * ((((((((((((((((_2036 * _2034) + (_2040 * _2038)) + (_2046 * _2044)) + (_2052 * _2050)) + (_2087 * _2085)) + (_2093 * _2091)) + (_2099 * _2097)) + (_2105 * _2103)) + (_2140 * _2138)) + (_2146 * _2144)) + (_2152 * _2150)) + (_2158 * _2156)) + (_2193 * _2191)) + (_2199 * _2197)) + (_2205 * _2203)) + (_2211 * _2209))))));
                                                            _2245 = frac((_1985 * _1901) + 0.5f);
                                                            _2246 = frac((_1987 * _1901) + 0.5f);
                                                            _2247 = _1985 + _1902;
                                                            _2248 = _1987 + _1902;
                                                            _2250 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2247, _2248), _1988);
                                                            _2258 = _1902 * 2.0f;
                                                            _2259 = _2247 - _2258;
                                                            _2260 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2259, _2248), _1988);
                                                            _2265 = 1.0f - _2245;
                                                            _2270 = _2248 - _2258;
                                                            _2271 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2259, _2270), _1988);
                                                            _2276 = 1.0f - _2246;
                                                            _2281 = _HeapResource_16.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_2247, _2270), _1988);
                                                            _2290 = (((mad(mad(_2260.x, _2265, _2260.y), _2246, mad(_2260.w, _2265, _2260.z)) + mad(mad(_2250.y, _2245, _2250.x), _2246, mad(_2250.z, _2245, _2250.w))) + mad(mad(_2271.w, _2265, _2271.z), _2276, mad(_2271.x, _2265, _2271.y))) + mad(mad(_2281.z, _2245, _2281.w), _2276, mad(_2281.y, _2245, _2281.x))) * 0.1111111119389534f;
                                                            [branch]
                                                            if (!(_1904 < 1.0f)) {
                                                              _2764 = _2290;
                                                              _2765 = _1904;
                                                              _2766 = _2240;
                                                              do {
                                                                _2863 = _2765;
                                                                _2864 = _2766;
                                                                _2865 = _2764;
                                                                [branch]
                                                                if (!((_1628 & 2048) == 0)) {
                                                                  Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1841) >> 16))];
                                                                  _2772 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1933, _1937), 0.0f);
                                                                  if (_2772.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1841 & 65535))];
                                                                    _2779 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1933, _1937), 0.0f);
                                                                    _2793 = mad(saturate(((log2(_1942 * _1826) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                    _2794 = max(9.999999747378752e-06f, _2772.x);
                                                                    _2795 = _2779.x / _2794;
                                                                    _2796 = _2779.y / _2794;
                                                                    _2798 = _2779.w / _2794;
                                                                    _2803 = ((0.375f - _2796) * 4.999999873689376e-06f) + _2796;
                                                                    _2806 = -0.0f - _2795;
                                                                    _2807 = mad(_2806, _2803, (_2779.z / _2794));
                                                                    _2809 = 1.0f / mad(_2806, _2795, _2803);
                                                                    _2810 = _2809 * _2807;
                                                                    _2815 = _2793 - _2795;
                                                                    _2820 = (((_2793 * _2793) - _2803) - (_2810 * _2815)) / mad((-0.0f - _2807), _2810, mad((-0.0f - _2803), _2803, (((0.375f - _2798) * 4.999999873689376e-06f) + _2798)));
                                                                    _2822 = (_2809 * _2815) - (_2820 * _2810);
                                                                    _2825 = 1.0f / _2820;
                                                                    _2826 = _2822 * _2825;
                                                                    _2831 = sqrt(((_2826 * _2826) * 0.25f) - ((1.0f - dot(float2(_2822, _2820), float2(_2795, _2803))) * _2825));
                                                                    _2833 = (_2826 * -0.5f) - _2831;
                                                                    _2835 = _2831 - (_2826 * 0.5f);
                                                                    _2837 = select((_2833 < _2793), 1.0f, 0.0f);
                                                                    _2842 = (_2837 + -0.05000000074505806f) / (_2833 - _2793);
                                                                    _2848 = (((select((_2835 < _2793), 1.0f, 0.0f) - _2837) / (_2835 - _2833)) - _2842) / (_2835 - _2793);
                                                                    _2850 = _2842 - (_2848 * _2833);
                                                                    _2863 = _2765;
                                                                    _2864 = (exp2((_2772.x * -1.4426950216293335f) * saturate((dot(float2(_2795, _2803), float2((_2850 - (_2848 * _2793)), _2848)) + 0.05000000074505806f) - (_2850 * _2793))) * _2766);
                                                                    _2865 = _2764;
                                                                  } else {
                                                                    _2863 = _2765;
                                                                    _2864 = _2766;
                                                                    _2865 = _2764;
                                                                  }
                                                                }
                                                                break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                              // Native PCF completion bypasses the fallback-shadow path.
                                                              break;
                                                            } else {
                                                              _2293 = _2240;
                                                              _2294 = _2290;
                                                              _2295 = _1904;
                                                              _2296 = _1988;
                                                            }
                                                          }
                                                          _2299 = (_1979 * _1844) + _1846;
                                                          _2300 = (_1980 * _1845) + _1847;
                                                          do {
                                                            _2759 = 1.0f;
                                                            if (!((_1628 & 512) == 0)) {
                                                              Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                                                              _2309 = saturate(_2296);
                                                              _2313 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _2322 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 1u);
                                                              } else {
                                                                _2322 = frac(frac(dot(float2(((_2313 * 32.665000915527344f) + _127), ((_2313 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _2322 = frac(frac(dot(float2(((_2313 * 32.665000915527344f) + _127), ((_2313 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _2323 = sin(_2322);
                                                              _2324 = cos(_2322);
                                                              _2329 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2299, _2300), 0.0f))).x) > _2309), 1.0f, 0.0f);
                                                              _2330 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _2335 = sqrt((float((int)(_2330)) * 0.25f) + 0.125f) * _1899;
                                                              _2344 = (_global_7[min((uint)(((int)(0u + (_2330 * 2)))), 127u)]) * _2335;
                                                              _2345 = (_global_7[min((uint)(((int)(1u + (_2330 * 2)))), 127u)]) * _2335;
                                                              _2347 = -0.0f - _2323;
                                                              _2349 = dot(float2(_2344, _2345), float2(_2324, _2323)) + _2299;
                                                              _2350 = dot(float2(_2344, _2345), float2(_2347, _2324)) + _2300;
                                                              _2352 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2349, _2350));
                                                              _2356 = _2349 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                              _2357 = _2350 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                              _2360 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1846);
                                                              _2361 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1847);
                                                              _2366 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1844 + _1846)) + 0.5f);
                                                              _2367 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1845 + _1847)) + 0.5f);
                                                              _2370 = floor(_2356 + -0.5f);
                                                              _2371 = floor(_2357 + 0.5f);
                                                              _2373 = floor(_2356 + 0.5f);
                                                              _2375 = floor(_2357 + -0.5f);
                                                              _2376 = (_2370 < _2360);
                                                              _2377 = (_2371 < _2361);
                                                              do {
                                                                if (!(_2376 || _2377)) {
                                                                  if ((_2370 >= _2366) || (_2371 >= _2367)) {
                                                                    _2386 = _2329;
                                                                  } else {
                                                                    _2386 = _2352.x;
                                                                  }
                                                                } else {
                                                                  _2386 = _2329;
                                                                }
                                                                _2387 = (_2373 < _2360);
                                                                do {
                                                                  if (!(_2387 || _2377)) {
                                                                    if ((_2373 >= _2366) || (_2371 >= _2367)) {
                                                                      _2395 = _2329;
                                                                    } else {
                                                                      _2395 = _2352.y;
                                                                    }
                                                                  } else {
                                                                    _2395 = _2329;
                                                                  }
                                                                  _2396 = (_2375 < _2361);
                                                                  do {
                                                                    if (!(_2387 || _2396)) {
                                                                      if ((_2373 >= _2366) || (_2375 >= _2367)) {
                                                                        _2404 = _2329;
                                                                      } else {
                                                                        _2404 = _2352.z;
                                                                      }
                                                                    } else {
                                                                      _2404 = _2329;
                                                                    }
                                                                    do {
                                                                      if (!(_2376 || _2396)) {
                                                                        if ((_2370 >= _2366) || (_2375 >= _2367)) {
                                                                          _2412 = _2329;
                                                                        } else {
                                                                          _2412 = _2352.w;
                                                                        }
                                                                      } else {
                                                                        _2412 = _2329;
                                                                      }
                                                                      _2413 = _2386 - _2309;
                                                                      _2415 = select((_2413 < 0.0f), 0.0f, 1.0f);
                                                                      _2417 = _2395 - _2309;
                                                                      _2419 = select((_2417 < 0.0f), 0.0f, 1.0f);
                                                                      _2423 = _2404 - _2309;
                                                                      _2425 = select((_2423 < 0.0f), 0.0f, 1.0f);
                                                                      _2429 = _2412 - _2309;
                                                                      _2431 = select((_2429 < 0.0f), 0.0f, 1.0f);
                                                                      _2438 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _2443 = sqrt((float((int)(_2438)) * 0.25f) + 0.125f) * _1899;
                                                                      _2452 = (_global_7[min((uint)(((int)(0u + (_2438 * 2)))), 127u)]) * _2443;
                                                                      _2453 = (_global_7[min((uint)(((int)(1u + (_2438 * 2)))), 127u)]) * _2443;
                                                                      _2456 = dot(float2(_2452, _2453), float2(_2324, _2323)) + _2299;
                                                                      _2457 = dot(float2(_2452, _2453), float2(_2347, _2324)) + _2300;
                                                                      _2459 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2456, _2457));
                                                                      _2463 = _2456 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _2464 = _2457 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _2467 = floor(_2463 + -0.5f);
                                                                      _2468 = floor(_2464 + 0.5f);
                                                                      _2470 = floor(_2463 + 0.5f);
                                                                      _2472 = floor(_2464 + -0.5f);
                                                                      _2473 = (_2467 < _2360);
                                                                      _2474 = (_2468 < _2361);
                                                                      do {
                                                                        if (!(_2473 || _2474)) {
                                                                          if ((_2467 >= _2366) || (_2468 >= _2367)) {
                                                                            _2483 = _2329;
                                                                          } else {
                                                                            _2483 = _2459.x;
                                                                          }
                                                                        } else {
                                                                          _2483 = _2329;
                                                                        }
                                                                        _2484 = (_2470 < _2360);
                                                                        do {
                                                                          if (!(_2484 || _2474)) {
                                                                            if ((_2470 >= _2366) || (_2468 >= _2367)) {
                                                                              _2492 = _2329;
                                                                            } else {
                                                                              _2492 = _2459.y;
                                                                            }
                                                                          } else {
                                                                            _2492 = _2329;
                                                                          }
                                                                          _2493 = (_2472 < _2361);
                                                                          do {
                                                                            if (!(_2484 || _2493)) {
                                                                              if ((_2470 >= _2366) || (_2472 >= _2367)) {
                                                                                _2501 = _2329;
                                                                              } else {
                                                                                _2501 = _2459.z;
                                                                              }
                                                                            } else {
                                                                              _2501 = _2329;
                                                                            }
                                                                            do {
                                                                              if (!(_2473 || _2493)) {
                                                                                if ((_2467 >= _2366) || (_2472 >= _2367)) {
                                                                                  _2509 = _2329;
                                                                                } else {
                                                                                  _2509 = _2459.w;
                                                                                }
                                                                              } else {
                                                                                _2509 = _2329;
                                                                              }
                                                                              _2510 = _2483 - _2309;
                                                                              _2512 = select((_2510 < 0.0f), 0.0f, 1.0f);
                                                                              _2516 = _2492 - _2309;
                                                                              _2518 = select((_2516 < 0.0f), 0.0f, 1.0f);
                                                                              _2522 = _2501 - _2309;
                                                                              _2524 = select((_2522 < 0.0f), 0.0f, 1.0f);
                                                                              _2528 = _2509 - _2309;
                                                                              _2530 = select((_2528 < 0.0f), 0.0f, 1.0f);
                                                                              _2537 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _2542 = sqrt((float((int)(_2537)) * 0.25f) + 0.125f) * _1899;
                                                                              _2551 = (_global_7[min((uint)(((int)(0u + (_2537 * 2)))), 127u)]) * _2542;
                                                                              _2552 = (_global_7[min((uint)(((int)(1u + (_2537 * 2)))), 127u)]) * _2542;
                                                                              _2555 = dot(float2(_2551, _2552), float2(_2324, _2323)) + _2299;
                                                                              _2556 = dot(float2(_2551, _2552), float2(_2347, _2324)) + _2300;
                                                                              _2558 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2555, _2556));
                                                                              _2562 = _2555 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _2563 = _2556 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _2566 = floor(_2562 + -0.5f);
                                                                              _2567 = floor(_2563 + 0.5f);
                                                                              _2569 = floor(_2562 + 0.5f);
                                                                              _2571 = floor(_2563 + -0.5f);
                                                                              _2572 = (_2566 < _2360);
                                                                              _2573 = (_2567 < _2361);
                                                                              do {
                                                                                if (!(_2572 || _2573)) {
                                                                                  if ((_2566 >= _2366) || (_2567 >= _2367)) {
                                                                                    _2582 = _2329;
                                                                                  } else {
                                                                                    _2582 = _2558.x;
                                                                                  }
                                                                                } else {
                                                                                  _2582 = _2329;
                                                                                }
                                                                                _2583 = (_2569 < _2360);
                                                                                do {
                                                                                  if (!(_2583 || _2573)) {
                                                                                    if ((_2569 >= _2366) || (_2567 >= _2367)) {
                                                                                      _2591 = _2329;
                                                                                    } else {
                                                                                      _2591 = _2558.y;
                                                                                    }
                                                                                  } else {
                                                                                    _2591 = _2329;
                                                                                  }
                                                                                  _2592 = (_2571 < _2361);
                                                                                  do {
                                                                                    if (!(_2583 || _2592)) {
                                                                                      if ((_2569 >= _2366) || (_2571 >= _2367)) {
                                                                                        _2600 = _2329;
                                                                                      } else {
                                                                                        _2600 = _2558.z;
                                                                                      }
                                                                                    } else {
                                                                                      _2600 = _2329;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_2572 || _2592)) {
                                                                                        if ((_2566 >= _2366) || (_2571 >= _2367)) {
                                                                                          _2608 = _2329;
                                                                                        } else {
                                                                                          _2608 = _2558.w;
                                                                                        }
                                                                                      } else {
                                                                                        _2608 = _2329;
                                                                                      }
                                                                                      _2609 = _2582 - _2309;
                                                                                      _2611 = select((_2609 < 0.0f), 0.0f, 1.0f);
                                                                                      _2615 = _2591 - _2309;
                                                                                      _2617 = select((_2615 < 0.0f), 0.0f, 1.0f);
                                                                                      _2621 = _2600 - _2309;
                                                                                      _2623 = select((_2621 < 0.0f), 0.0f, 1.0f);
                                                                                      _2627 = _2608 - _2309;
                                                                                      _2629 = select((_2627 < 0.0f), 0.0f, 1.0f);
                                                                                      _2636 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _2641 = sqrt((float((int)(_2636)) * 0.25f) + 0.125f) * _1899;
                                                                                      _2650 = (_global_7[min((uint)(((int)(0u + (_2636 * 2)))), 127u)]) * _2641;
                                                                                      _2651 = (_global_7[min((uint)(((int)(1u + (_2636 * 2)))), 127u)]) * _2641;
                                                                                      _2654 = dot(float2(_2650, _2651), float2(_2324, _2323)) + _2299;
                                                                                      _2655 = dot(float2(_2650, _2651), float2(_2347, _2324)) + _2300;
                                                                                      _2657 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2654, _2655));
                                                                                      _2661 = _2654 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _2662 = _2655 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _2665 = floor(_2661 + -0.5f);
                                                                                      _2666 = floor(_2662 + 0.5f);
                                                                                      _2668 = floor(_2661 + 0.5f);
                                                                                      _2670 = floor(_2662 + -0.5f);
                                                                                      _2671 = (_2665 < _2360);
                                                                                      _2672 = (_2666 < _2361);
                                                                                      do {
                                                                                        if (!(_2671 || _2672)) {
                                                                                          if ((_2665 >= _2366) || (_2666 >= _2367)) {
                                                                                            _2681 = _2329;
                                                                                          } else {
                                                                                            _2681 = _2657.x;
                                                                                          }
                                                                                        } else {
                                                                                          _2681 = _2329;
                                                                                        }
                                                                                        _2682 = (_2668 < _2360);
                                                                                        do {
                                                                                          if (!(_2682 || _2672)) {
                                                                                            if ((_2668 >= _2366) || (_2666 >= _2367)) {
                                                                                              _2690 = _2329;
                                                                                            } else {
                                                                                              _2690 = _2657.y;
                                                                                            }
                                                                                          } else {
                                                                                            _2690 = _2329;
                                                                                          }
                                                                                          _2691 = (_2670 < _2361);
                                                                                          do {
                                                                                            if (!(_2682 || _2691)) {
                                                                                              if ((_2668 >= _2366) || (_2670 >= _2367)) {
                                                                                                _2699 = _2329;
                                                                                              } else {
                                                                                                _2699 = _2657.z;
                                                                                              }
                                                                                            } else {
                                                                                              _2699 = _2329;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_2671 || _2691)) {
                                                                                                if ((_2665 >= _2366) || (_2670 >= _2367)) {
                                                                                                  _2707 = _2329;
                                                                                                } else {
                                                                                                  _2707 = _2657.w;
                                                                                                }
                                                                                              } else {
                                                                                                _2707 = _2329;
                                                                                              }
                                                                                              _2708 = _2681 - _2309;
                                                                                              _2710 = select((_2708 < 0.0f), 0.0f, 1.0f);
                                                                                              _2714 = _2690 - _2309;
                                                                                              _2716 = select((_2714 < 0.0f), 0.0f, 1.0f);
                                                                                              _2720 = _2699 - _2309;
                                                                                              _2722 = select((_2720 < 0.0f), 0.0f, 1.0f);
                                                                                              _2726 = _2707 - _2309;
                                                                                              _2728 = select((_2726 < 0.0f), 0.0f, 1.0f);
                                                                                              _2729 = ((((((((((((((_2419 + _2415) + _2425) + _2431) + _2512) + _2518) + _2524) + _2530) + _2611) + _2617) + _2623) + _2629) + _2710) + _2716) + _2722) + _2728;
                                                                                              _2740 = (saturate(_2729 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _2746 = float((int)(((int)(uint)((int)(_2740 > 0.0f))) - ((int)(uint)((int)(_2740 < 0.0f)))));
                                                                                              _2748 = 1.0f - (_2746 * _2740);
                                                                                              _2750 = (_2748 * _2748) * _2748;
                                                                                              _2759 = (0.5f - ((_2746 * 0.5f) * ((1.0f - _2750) - ((_2748 - _2750) * saturate(((1.0f / _2309) * (1.0f / _2729)) * ((((((((((((((((_2419 * _2417) + (_2415 * _2413)) + (_2425 * _2423)) + (_2431 * _2429)) + (_2512 * _2510)) + (_2518 * _2516)) + (_2524 * _2522)) + (_2530 * _2528)) + (_2611 * _2609)) + (_2617 * _2615)) + (_2623 * _2621)) + (_2629 * _2627)) + (_2710 * _2708)) + (_2716 * _2714)) + (_2722 * _2720)) + (_2728 * _2726)))))));
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
                                                            _2764 = _2294;
                                                            _2765 = _2295;
                                                            _2766 = (lerp(_2759, _2293, _2295));
                                                            [branch]
                                                            if (!((_1628 & 2048) == 0)) {
                                                              Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1841) >> 16))];
                                                              _2772 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1933, _1937), 0.0f);
                                                              if (_2772.x > 0.0f) {
                                                                Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1841 & 65535))];
                                                                _2779 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1933, _1937), 0.0f);
                                                                _2793 = mad(saturate(((log2(_1942 * _1826) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                _2794 = max(9.999999747378752e-06f, _2772.x);
                                                                _2795 = _2779.x / _2794;
                                                                _2796 = _2779.y / _2794;
                                                                _2798 = _2779.w / _2794;
                                                                _2803 = ((0.375f - _2796) * 4.999999873689376e-06f) + _2796;
                                                                _2806 = -0.0f - _2795;
                                                                _2807 = mad(_2806, _2803, (_2779.z / _2794));
                                                                _2809 = 1.0f / mad(_2806, _2795, _2803);
                                                                _2810 = _2809 * _2807;
                                                                _2815 = _2793 - _2795;
                                                                _2820 = (((_2793 * _2793) - _2803) - (_2810 * _2815)) / mad((-0.0f - _2807), _2810, mad((-0.0f - _2803), _2803, (((0.375f - _2798) * 4.999999873689376e-06f) + _2798)));
                                                                _2822 = (_2809 * _2815) - (_2820 * _2810);
                                                                _2825 = 1.0f / _2820;
                                                                _2826 = _2822 * _2825;
                                                                _2831 = sqrt(((_2826 * _2826) * 0.25f) - ((1.0f - dot(float2(_2822, _2820), float2(_2795, _2803))) * _2825));
                                                                _2833 = (_2826 * -0.5f) - _2831;
                                                                _2835 = _2831 - (_2826 * 0.5f);
                                                                _2837 = select((_2833 < _2793), 1.0f, 0.0f);
                                                                _2842 = (_2837 + -0.05000000074505806f) / (_2833 - _2793);
                                                                _2848 = (((select((_2835 < _2793), 1.0f, 0.0f) - _2837) / (_2835 - _2833)) - _2842) / (_2835 - _2793);
                                                                _2850 = _2842 - (_2848 * _2833);
                                                                _2863 = _2765;
                                                                _2864 = (exp2((_2772.x * -1.4426950216293335f) * saturate((dot(float2(_2795, _2803), float2((_2850 - (_2848 * _2793)), _2848)) + 0.05000000074505806f) - (_2850 * _2793))) * _2766);
                                                                _2865 = _2764;
                                                              } else {
                                                                _2863 = _2765;
                                                                _2864 = _2766;
                                                                _2865 = _2764;
                                                              }
                                                            } else {
                                                              _2863 = _2765;
                                                              _2864 = _2766;
                                                              _2865 = _2764;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      }
                                                      do {
                                                        _2886 = _1873;
                                                        _2887 = _1874;
                                                        _2888 = _1876;
                                                        [branch]
                                                        if (!(_1888 == 0)) {
                                                          Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1888)))];
                                                          _2878 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1933 * f16tof32(((uint)((uint)(_1859) >> 16)))) + f16tof32(((uint)((uint)(_1862) >> 16)))), ((_1937 * f16tof32(_1859)) + f16tof32(_1862))), 0.0f);
                                                          _2886 = (_2878.x * _1873);
                                                          _2887 = (_2878.y * _1874);
                                                          _2888 = (_2878.z * _1876);
                                                        }
                                                        _2889 = _2864 * _1971;
                                                        [branch]
                                                        if (!(_2889 == 0.0f)) {
                                                          do {
                                                            _2907 = GetDeferredSoftShadowChannel(_1631);
                                                            if (_2907 < 0) {
                                                                  _2928 = _2889;
                                                                  do {
                                                                    _8856 = _1616;
                                                                    _8857 = _1617;
                                                                    _8858 = _1618;
                                                                    _8859 = _1619;
                                                                    _8860 = _1620;
                                                                    _8861 = _1621;
                                                                    [branch]
                                                                    if (!(_2928 == 0.0f)) {
                                                                      do {
                                                                        _2944 = 0.0f;
                                                                        _2945 = 0.0f;
                                                                        _2946 = 0.0f;
                                                                        [branch]
                                                                        if (!(_242 || _1973)) {
                                                                          _2939 = ((_2863 * _1971) * _2865) * saturate(0.30000001192092896f - dot(float3(_1821, _1822, _1823), float3(_195, _196, _197)));
                                                                          _2944 = (_2939 * _1300);
                                                                          _2945 = (_2939 * _1301);
                                                                          _2946 = (_2939 * _1302);
                                                                        }
                                                                        do {
                                                                          _2982 = _2928;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _2953 = srvLightMappingData[_1631];
                                                                            if (!(_2953 == -1)) {
                                                                              _2958 = srvLightIndexData[_2953].nLayerIndex;
                                                                              _2960 = srvLightIndexData[_2953].vAtlasOrigin.x;
                                                                              _2961 = srvLightIndexData[_2953].vAtlasOrigin.y;
                                                                              _2963 = srvLightIndexData[_2953].vScreenOrigin.x;
                                                                              _2964 = srvLightIndexData[_2953].vScreenOrigin.y;
                                                                              _2973 = ((int)(_2958 * 5)) & 31;
                                                                              _2982 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2960 + _65) - _2963)), ((int)((_2961 + _66) - _2964)), 0)))).x) & ((int)(31 << _2973)))) >> _2973)) >> 1)))) * 0.06666667014360428f) * _2928);
                                                                            } else {
                                                                              _2982 = _2928;
                                                                            }
                                                                          }
                                                                          _2986 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _2989 = select(_2986, (_2982 * _1288), _2982);
                                                                          _2991 = dot(float3(_1821, _1822, _1823), float3(_1821, _1822, _1823));
                                                                          _2992 = rsqrt(_2991);
                                                                          _2993 = _2992 * _1821;
                                                                          _2994 = _2992 * _1822;
                                                                          _2995 = _2992 * _1823;
                                                                          _2996 = dot(float3(_195, _196, _197), float3(_2993, _2994, _2995));
                                                                          do {
                                                                            _3014 = _2996;
                                                                            if (_1885 > 0.0f) {
                                                                              _3004 = sqrt(saturate((_1885 * _1885) * (1.0f / (_2991 + 1.0f))));
                                                                              if (_2996 < _3004) {
                                                                                _3009 = max(_2996, (-0.0f - _3004)) + _3004;
                                                                                _3014 = ((_3009 * _3009) / (_3004 * 4.0f));
                                                                              } else {
                                                                                _3014 = _2996;
                                                                              }
                                                                            }
                                                                            _3015 = _223 * _223;
                                                                            _3019 = saturate((_1885 * (1.0f - _3015)) * _2992);
                                                                            _3021 = saturate(_2992 * f16tof32(_1835));
                                                                            _3022 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                                            _3023 = dot(float3(_459, _460, _458), float3(_2993, _2994, _2995));
                                                                            _3026 = rsqrt((_3023 * 2.0f) + 2.0f);
                                                                            _3033 = (_3019 > 0.0f);
                                                                            do {
                                                                              _3124 = saturate((_3026 * _3023) + _3026);
                                                                              _3125 = saturate(_3026 * (_3022 + _2996));
                                                                              if (_3033) {
                                                                                _3037 = sqrt(1.0f - (_3019 * _3019));
                                                                                _3039 = (_2996 * 2.0f) * _3022;
                                                                                _3040 = _3039 - _3023;
                                                                                if (!(!(_3040 >= _3037))) {
                                                                                  _3124 = abs(_3022);
                                                                                  _3125 = 1.0f;
                                                                                } else {
                                                                                  _3048 = rsqrt(1.0f - (_3040 * _3040)) * _3019;
                                                                                  _3051 = _3048 * (_3022 - (_3040 * _2996));
                                                                                  _3052 = _3022 * _3022;
                                                                                  _3057 = _3048 * (((_3052 * 2.0f) + -1.0f) - (_3040 * _3023));
                                                                                  _3066 = sqrt(saturate((((1.0f - (_2996 * _2996)) - _3052) - (_3023 * _3023)) + (_3039 * _3023)));
                                                                                  _3067 = _3066 * _3048;
                                                                                  _3070 = ((_3022 * 2.0f) * _3048) * _3066;
                                                                                  _3072 = (_3037 * _2996) + _3022;
                                                                                  _3073 = _3072 + _3051;
                                                                                  _3074 = _3037 * _3023;
                                                                                  _3076 = (_3074 + 1.0f) + _3057;
                                                                                  _3077 = _3067 * _3076;
                                                                                  _3078 = _3073 * _3076;
                                                                                  _3079 = _3070 * _3073;
                                                                                  _3084 = (((_3073 * 0.25f) * _3070) - (_3077 * 0.5f)) * _3078;
                                                                                  _3098 = (((_3079 - (_3077 * 2.0f)) * _3079) + (_3077 * _3077)) + ((((-0.5f - ((_3076 + _3074) * 0.5f)) * _3078) + ((_3076 * _3076) * _3072)) * _3073);
                                                                                  _3103 = (_3084 * 2.0f) / ((_3098 * _3098) + (_3084 * _3084));
                                                                                  _3104 = _3098 * _3103;
                                                                                  _3106 = 1.0f - (_3084 * _3103);
                                                                                  _3112 = ((_3104 * _3070) + _3074) + (_3106 * _3057);
                                                                                  _3115 = rsqrt((_3112 * 2.0f) + 2.0f);
                                                                                  _3124 = saturate((_3112 * _3115) + _3115);
                                                                                  _3125 = saturate(((_3072 + (_3104 * _3067)) + (_3106 * _3051)) * _3115);
                                                                                }
                                                                              }
                                                                              _3126 = saturate(_3014);
                                                                              _3127 = _3015 * _3015;
                                                                              do {
                                                                                _3137 = _3127;
                                                                                if (_3021 > 0.0f) {
                                                                                  _3137 = saturate(((_3021 * _3021) / ((_3124 * 3.5999999046325684f) + 0.4000000059604645f)) + _3127);
                                                                                }
                                                                                _3138 = sqrt(_3137);
                                                                                do {
                                                                                  _3149 = 1.0f;
                                                                                  if (_3033) {
                                                                                    _3149 = (_3137 / ((((_3019 * 0.25f) * ((_3138 * 3.0f) + _3019)) / (_3124 + 0.0010000000474974513f)) + _3137));
                                                                                  }
                                                                                  _3153 = (((_3137 * _3125) - _3125) * _3125) + 1.0f;
                                                                                  _3160 = exp2(log2(1.0f - saturate(_3124)) * 5.0f);
                                                                                  _3163 = saturate(abs(_3022) + 9.999999747378752e-06f);
                                                                                  _3164 = 1.0f - _3138;
                                                                                  _3176 = saturate((_2996 + _1883) / (_1883 + 1.0f));
                                                                                  _3179 = ((_3149 * _3126) * (_3137 / (_3153 * _3153))) * (0.5f / ((((_3164 * _3163) + _3138) * _3126) + (((_3164 * _3126) + _3138) * _3163)));
                                                                                  _3180 = _2886 * _1679;
                                                                                  _3181 = _2887 * _1679;
                                                                                  _3182 = _2888 * _1679;
                                                                                  do {
                                                                                    _3220 = _1619;
                                                                                    _3221 = _1620;
                                                                                    _3222 = _1621;
                                                                                    if (_1880 > 0.0f) {
                                                                                      _3203 = (_1880 * _1375) * select(_2986, (_2982 * _1288), _2982);
                                                                                      _3220 = (((((_3180 * _1151) * _3203) * ((_3160 * (1.0f - _215)) + _215)) * _3179) + _1619);
                                                                                      _3221 = (((((_3181 * _1152) * _3203) * ((_3160 * (1.0f - _216)) + _216)) * _3179) + _1620);
                                                                                      _3222 = (((((_3182 * _1153) * _3203) * ((_3160 * (1.0f - _217)) + _217)) * _3179) + _1621);
                                                                                    }
                                                                                    _8856 = (((_2989 * _3180) * _3176) + _1616);
                                                                                    _8857 = (((_2989 * _3181) * _3176) + _1617);
                                                                                    _8858 = (((_2989 * _3182) * _3176) + _1618);
                                                                                    _8859 = (_3220 + (_2944 * _3180));
                                                                                    _8860 = (_3221 + (_2945 * _3181));
                                                                                    _8861 = (_3222 + (_2946 * _3182));
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
                                                            _2910 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                                                            do {
                                                              if (_2907 == 0) {
                                                                _2924 = _2910.x;
                                                              } else {
                                                                if (_2907 == 1) {
                                                                  _2924 = _2910.y;
                                                                } else {
                                                                  if (_2907 == 2) {
                                                                    _2924 = _2910.z;
                                                                  } else {
                                                                    _2924 = _2910.w;
                                                                  }
                                                                }
                                                              }
                                                              _2928 = ((_2924 * _2924) * _1971);
                                                              [branch]
                                                              if (!(_2928 == 0.0f)) {
                                                                do {
                                                                  _2944 = 0.0f;
                                                                  _2945 = 0.0f;
                                                                  _2946 = 0.0f;
                                                                  [branch]
                                                                  if (!(_242 || _1973)) {
                                                                    _2939 = ((_2863 * _1971) * _2865) * saturate(0.30000001192092896f - dot(float3(_1821, _1822, _1823), float3(_195, _196, _197)));
                                                                    _2944 = (_2939 * _1300);
                                                                    _2945 = (_2939 * _1301);
                                                                    _2946 = (_2939 * _1302);
                                                                  }
                                                                  do {
                                                                    _2982 = _2928;
                                                                    [branch]
                                                                    if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                      _2953 = srvLightMappingData[_1631];
                                                                      if (!(_2953 == -1)) {
                                                                        _2958 = srvLightIndexData[_2953].nLayerIndex;
                                                                        _2960 = srvLightIndexData[_2953].vAtlasOrigin.x;
                                                                        _2961 = srvLightIndexData[_2953].vAtlasOrigin.y;
                                                                        _2963 = srvLightIndexData[_2953].vScreenOrigin.x;
                                                                        _2964 = srvLightIndexData[_2953].vScreenOrigin.y;
                                                                        _2973 = ((int)(_2958 * 5)) & 31;
                                                                        _2982 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2960 + _65) - _2963)), ((int)((_2961 + _66) - _2964)), 0)))).x) & ((int)(31 << _2973)))) >> _2973)) >> 1)))) * 0.06666667014360428f) * _2928);
                                                                      } else {
                                                                        _2982 = _2928;
                                                                      }
                                                                    }
                                                                    _2986 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                    _2989 = select(_2986, (_2982 * _1288), _2982);
                                                                    _2991 = dot(float3(_1821, _1822, _1823), float3(_1821, _1822, _1823));
                                                                    _2992 = rsqrt(_2991);
                                                                    _2993 = _2992 * _1821;
                                                                    _2994 = _2992 * _1822;
                                                                    _2995 = _2992 * _1823;
                                                                    _2996 = dot(float3(_195, _196, _197), float3(_2993, _2994, _2995));
                                                                    do {
                                                                      _3014 = _2996;
                                                                      if (_1885 > 0.0f) {
                                                                        _3004 = sqrt(saturate((_1885 * _1885) * (1.0f / (_2991 + 1.0f))));
                                                                        if (_2996 < _3004) {
                                                                          _3009 = max(_2996, (-0.0f - _3004)) + _3004;
                                                                          _3014 = ((_3009 * _3009) / (_3004 * 4.0f));
                                                                        } else {
                                                                          _3014 = _2996;
                                                                        }
                                                                      }
                                                                      _3015 = _223 * _223;
                                                                      _3019 = saturate((_1885 * (1.0f - _3015)) * _2992);
                                                                      _3021 = saturate(_2992 * f16tof32(_1835));
                                                                      _3022 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                                      _3023 = dot(float3(_459, _460, _458), float3(_2993, _2994, _2995));
                                                                      _3026 = rsqrt((_3023 * 2.0f) + 2.0f);
                                                                      _3033 = (_3019 > 0.0f);
                                                                      do {
                                                                        _3124 = saturate((_3026 * _3023) + _3026);
                                                                        _3125 = saturate(_3026 * (_3022 + _2996));
                                                                        if (_3033) {
                                                                          _3037 = sqrt(1.0f - (_3019 * _3019));
                                                                          _3039 = (_2996 * 2.0f) * _3022;
                                                                          _3040 = _3039 - _3023;
                                                                          if (!(!(_3040 >= _3037))) {
                                                                            _3124 = abs(_3022);
                                                                            _3125 = 1.0f;
                                                                          } else {
                                                                            _3048 = rsqrt(1.0f - (_3040 * _3040)) * _3019;
                                                                            _3051 = _3048 * (_3022 - (_3040 * _2996));
                                                                            _3052 = _3022 * _3022;
                                                                            _3057 = _3048 * (((_3052 * 2.0f) + -1.0f) - (_3040 * _3023));
                                                                            _3066 = sqrt(saturate((((1.0f - (_2996 * _2996)) - _3052) - (_3023 * _3023)) + (_3039 * _3023)));
                                                                            _3067 = _3066 * _3048;
                                                                            _3070 = ((_3022 * 2.0f) * _3048) * _3066;
                                                                            _3072 = (_3037 * _2996) + _3022;
                                                                            _3073 = _3072 + _3051;
                                                                            _3074 = _3037 * _3023;
                                                                            _3076 = (_3074 + 1.0f) + _3057;
                                                                            _3077 = _3067 * _3076;
                                                                            _3078 = _3073 * _3076;
                                                                            _3079 = _3070 * _3073;
                                                                            _3084 = (((_3073 * 0.25f) * _3070) - (_3077 * 0.5f)) * _3078;
                                                                            _3098 = (((_3079 - (_3077 * 2.0f)) * _3079) + (_3077 * _3077)) + ((((-0.5f - ((_3076 + _3074) * 0.5f)) * _3078) + ((_3076 * _3076) * _3072)) * _3073);
                                                                            _3103 = (_3084 * 2.0f) / ((_3098 * _3098) + (_3084 * _3084));
                                                                            _3104 = _3098 * _3103;
                                                                            _3106 = 1.0f - (_3084 * _3103);
                                                                            _3112 = ((_3104 * _3070) + _3074) + (_3106 * _3057);
                                                                            _3115 = rsqrt((_3112 * 2.0f) + 2.0f);
                                                                            _3124 = saturate((_3112 * _3115) + _3115);
                                                                            _3125 = saturate(((_3072 + (_3104 * _3067)) + (_3106 * _3051)) * _3115);
                                                                          }
                                                                        }
                                                                        _3126 = saturate(_3014);
                                                                        _3127 = _3015 * _3015;
                                                                        do {
                                                                          _3137 = _3127;
                                                                          if (_3021 > 0.0f) {
                                                                            _3137 = saturate(((_3021 * _3021) / ((_3124 * 3.5999999046325684f) + 0.4000000059604645f)) + _3127);
                                                                          }
                                                                          _3138 = sqrt(_3137);
                                                                          do {
                                                                            _3149 = 1.0f;
                                                                            if (_3033) {
                                                                              _3149 = (_3137 / ((((_3019 * 0.25f) * ((_3138 * 3.0f) + _3019)) / (_3124 + 0.0010000000474974513f)) + _3137));
                                                                            }
                                                                            _3153 = (((_3137 * _3125) - _3125) * _3125) + 1.0f;
                                                                            _3160 = exp2(log2(1.0f - saturate(_3124)) * 5.0f);
                                                                            _3163 = saturate(abs(_3022) + 9.999999747378752e-06f);
                                                                            _3164 = 1.0f - _3138;
                                                                            _3176 = saturate((_2996 + _1883) / (_1883 + 1.0f));
                                                                            _3179 = ((_3149 * _3126) * (_3137 / (_3153 * _3153))) * (0.5f / ((((_3164 * _3163) + _3138) * _3126) + (((_3164 * _3126) + _3138) * _3163)));
                                                                            _3180 = _2886 * _1679;
                                                                            _3181 = _2887 * _1679;
                                                                            _3182 = _2888 * _1679;
                                                                            do {
                                                                              _3220 = _1619;
                                                                              _3221 = _1620;
                                                                              _3222 = _1621;
                                                                              if (_1880 > 0.0f) {
                                                                                _3203 = (_1880 * _1375) * select(_2986, (_2982 * _1288), _2982);
                                                                                _3220 = (((((_3180 * _1151) * _3203) * ((_3160 * (1.0f - _215)) + _215)) * _3179) + _1619);
                                                                                _3221 = (((((_3181 * _1152) * _3203) * ((_3160 * (1.0f - _216)) + _216)) * _3179) + _1620);
                                                                                _3222 = (((((_3182 * _1153) * _3203) * ((_3160 * (1.0f - _217)) + _217)) * _3179) + _1621);
                                                                              }
                                                                              _8856 = (((_2989 * _3180) * _3176) + _1616);
                                                                              _8857 = (((_2989 * _3181) * _3176) + _1617);
                                                                              _8858 = (((_2989 * _3182) * _3176) + _1618);
                                                                              _8859 = (_3220 + (_2944 * _3180));
                                                                              _8860 = (_3221 + (_2945 * _3181));
                                                                              _8861 = (_3222 + (_2946 * _3182));
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
                                                                _8856 = _1616;
                                                                _8857 = _1617;
                                                                _8858 = _1618;
                                                                _8859 = _1619;
                                                                _8860 = _1620;
                                                                _8861 = _1621;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _8856 = _1616;
                                                          _8857 = _1617;
                                                          _8858 = _1618;
                                                          _8859 = _1619;
                                                          _8860 = _1620;
                                                          _8861 = _1621;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    if (_1662 == 7) {
                                                      _3801 = asfloat(srvLightInfoProperties.Load3(_1630)).x;
                                                      _3802 = asfloat(srvLightInfoProperties.Load3(_1630)).y;
                                                      _3803 = asfloat(srvLightInfoProperties.Load3(_1630)).z;
                                                      _3806 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 12u)))).x;
                                                      _3807 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 12u)))).y;
                                                      _3808 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 12u)))).z;
                                                      _3811 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 24u)))).x;
                                                      _3812 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 24u)))).y;
                                                      _3813 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 24u)))).z;
                                                      _3816 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 36u)))).x;
                                                      _3817 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 36u)))).y;
                                                      _3818 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 36u)))).z;
                                                      _3821 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).x;
                                                      _3822 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).y;
                                                      _3823 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 48u)))).z;
                                                      _3826 = asint(srvLightInfoProperties.Load(((int)(_1630 + 60u))));
                                                      _3829 = asint(srvLightInfoProperties.Load(((int)(_1630 + 64u))));
                                                      _3832 = asint(srvLightInfoProperties.Load(((int)(_1630 + 72u))));
                                                      _3835 = asint(srvLightInfoProperties.Load(((int)(_1630 + 76u))));
                                                      _3838 = asint(srvLightInfoProperties.Load(((int)(_1630 + 80u))));
                                                      _3841 = asint(srvLightInfoProperties.Load(((int)(_1630 + 84u))));
                                                      _3844 = asint(srvLightInfoProperties.Load(((int)(_1630 + 88u))));
                                                      _3847 = asint(srvLightInfoProperties.Load(((int)(_1630 + 92u))));
                                                      _3850 = asint(srvLightInfoProperties.Load(((int)(_1630 + 96u))));
                                                      _3853 = asint(srvLightInfoProperties.Load(((int)(_1630 + 100u))));
                                                      _3856 = asint(srvLightInfoProperties.Load(((int)(_1630 + 104u))));
                                                      _3859 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).x;
                                                      _3860 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).y;
                                                      _3861 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).z;
                                                      _3862 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).w;
                                                      _3865 = asint(srvLightInfoProperties.Load(((int)(_1630 + 124u))));
                                                      _3868 = asint(srvLightInfoProperties.Load(((int)(_1630 + 128u))));
                                                      _3871 = asint(srvLightInfoProperties.Load(((int)(_1630 + 136u))));
                                                      _3874 = asint(srvLightInfoProperties.Load(((int)(_1630 + 140u))));
                                                      _3876 = f16tof32(((uint)((uint)(_3826) >> 16)));
                                                      _3877 = f16tof32(_3826);
                                                      _3879 = f16tof32(((uint)((uint)(_3829) >> 16)));
                                                      _3883 = ((float)((uint)((uint)(((uint)(_3829) >> 8) & 255)))) * 0.003921499941498041f;
                                                      _3886 = ((float)((uint)((uint)(_3829 & 255)))) * 0.003921499941498041f;
                                                      _3887 = f16tof32(_3832);
                                                      _3889 = f16tof32(((uint)((uint)(_3835) >> 16)));
                                                      _3893 = f16tof32(_3838);
                                                      _3895 = f16tof32(((uint)((uint)(_3841) >> 16)));
                                                      _3896 = f16tof32(_3841);
                                                      _3898 = f16tof32(((uint)((uint)(_3844) >> 16)));
                                                      _3899 = f16tof32(_3844);
                                                      _3901 = _3847 & 65535;
                                                      _3905 = ((_1628 & 4194304) != 0);
                                                      _3913 = f16tof32(((uint)((uint)(_3856) >> 16)));
                                                      _3914 = f16tof32(_3856);
                                                      _3916 = f16tof32(((uint)((uint)(_3865) >> 16)));
                                                      _3919 = f16tof32(((uint)((uint)(_3868) >> 16)));
                                                      _3920 = f16tof32(_3868);
                                                      _3922 = f16tof32(((uint)((uint)(_3871) >> 16)));
                                                      _3923 = _3922 + -1.0f;
                                                      do {
                                                        if (_3905) {
                                                          _3925 = 0.5f / _3922;
                                                          _3926 = 0.3333333432674408f / _3922;
                                                          _3930 = (_3922 * 0.5f) + 0.5f;
                                                          _3940 = (_3925 * _3923);
                                                          _3941 = (_3926 * _3923);
                                                          _3942 = (_3925 * _3930);
                                                          _3943 = (_3926 * _3930);
                                                          _3944 = (_3922 * 2.0f);
                                                          _3945 = (_3922 * 3.0f);
                                                          _3946 = _3925;
                                                          _3947 = _3926;
                                                        } else {
                                                          _3936 = 1.0f / _3922;
                                                          _3937 = _3936 * _3923;
                                                          _3938 = _3936 * 0.5f;
                                                          _3940 = _3937;
                                                          _3941 = _3937;
                                                          _3942 = _3938;
                                                          _3943 = _3938;
                                                          _3944 = _3922;
                                                          _3945 = _3922;
                                                          _3946 = _3936;
                                                          _3947 = _3936;
                                                        }
                                                        _3951 = _3816 - _238;
                                                        _3952 = _3817 - _239;
                                                        _3953 = _3818 + _237;
                                                        _3954 = dot(float3(_3951, _3952, _3953), float3(_3951, _3952, _3953));
                                                        _3955 = rsqrt(_3954);
                                                        _3956 = _3955 * _3954;
                                                        _3957 = _3955 * _3951;
                                                        _3958 = _3955 * _3952;
                                                        _3959 = _3955 * _3953;
                                                        _3962 = max(0.0f, (_3956 - abs(_3893)));
                                                        _3963 = _3962 * f16tof32(((uint)((uint)(_3838) >> 16)));
                                                        _3964 = _3963 * _3963;
                                                        _3967 = saturate(1.0f - (_3964 * _3964));
                                                        _3974 = (_3967 * _3967) / (select((_3893 < 0.0f), (_3964 * 16.0f), (_3962 * _3962)) + 1.0f);
                                                        _3987 = saturate(1.0f - dot(float3(_195, _196, _197), float3(_3957, _3958, _3959))) * f16tof32(_3865);
                                                        _3991 = abs(_3953);
                                                        _3995 = _3951 - ((_3987 * _195) * _3991);
                                                        _3996 = _3952 - ((_3987 * _196) * _3991);
                                                        _3997 = _3953 - ((_3987 * _197) * _3991);
                                                        _4000 = mad(_3997, _3812, mad(_3996, _3807, (_3995 * _3802)));
                                                        _4003 = mad(_3997, _3813, mad(_3996, _3808, (_3995 * _3803)));
                                                        _4005 = ((_1628 & 3584) != 0);
                                                        do {
                                                          _5853 = _3974;
                                                          _5854 = 0.0f;
                                                          _5855 = 0.0f;
                                                          _5856 = 1.0f;
                                                          if (_4005 && (_3974 > 0.0f)) {
                                                            _4011 = mad(_3997, _3811, mad(_3996, _3806, (_3995 * _3801)));
                                                            _4012 = -0.0f - _4003;
                                                            _4013 = -0.0f - _4000;
                                                            do {
                                                              _4856 = 1.0f;
                                                              _4857 = 1.0f;
                                                              _4858 = 1.0f;
                                                              _4859 = 0;
                                                              _4860 = 0.0f;
                                                              [branch]
                                                              if (!((_1628 & 1024) == 0)) {
                                                                Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3847) >> 16))];
                                                                [branch]
                                                                if (_3905) {
                                                                  _4018 = abs(_4011);
                                                                  _4019 = abs(_4012);
                                                                  _4020 = abs(_4013);
                                                                  do {
                                                                    if (_4018 > max(_4019, _4020)) {
                                                                      _4024 = (_4011 > 0.0f);
                                                                      _4039 = select(_4024, 0.0f, 1.0f);
                                                                      _4040 = 0.0f;
                                                                      _4041 = select(_4024, _4000, _4013);
                                                                      _4042 = _4003;
                                                                      _4043 = _4018;
                                                                    } else {
                                                                      if (_4019 > _4020) {
                                                                        _4030 = (_4003 < -0.0f);
                                                                        _4039 = select(_4030, 0.0f, 1.0f);
                                                                        _4040 = 1.0f;
                                                                        _4041 = _4011;
                                                                        _4042 = select(_4030, _4013, _4000);
                                                                        _4043 = _4019;
                                                                      } else {
                                                                        _4034 = (_4000 < -0.0f);
                                                                        _4039 = select(_4034, 0.0f, 1.0f);
                                                                        _4040 = 2.0f;
                                                                        _4041 = select(_4034, _4011, (-0.0f - _4011));
                                                                        _4042 = _4003;
                                                                        _4043 = _4020;
                                                                      }
                                                                    }
                                                                    _4044 = _4043 * 2.0f;
                                                                    _4049 = -0.0f - _3914;
                                                                    _4058 = ((min(max((_4041 / _4044), _4049), _3914) + _4039) * _3940) + _3942;
                                                                    _4059 = ((min(max((_4042 / _4044), _4049), _3914) + _4040) * _3941) + _3943;
                                                                    _4060 = (1.0f - (_4043 * _3898)) + _3916;
                                                                    _4065 = ((_4039 + -0.5f) * _3940) + _3942;
                                                                    _4066 = ((_4040 + -0.5f) * _3941) + _3943;
                                                                    _4069 = saturate(_4060);
                                                                    _4073 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _4082 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 2u);
                                                                    } else {
                                                                      _4082 = frac(frac(dot(float2(((_4073 * 32.665000915527344f) + _127), ((_4073 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _4082 = frac(frac(dot(float2(((_4073 * 32.665000915527344f) + _127), ((_4073 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _4083 = sin(_4082);
                                                                    _4084 = cos(_4082);
                                                                    _4089 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_4058, _4059), 0.0f))).x) > _4069), 1.0f, 0.0f);
                                                                    _4090 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _4095 = sqrt((float((int)(_4090)) * 0.25f) + 0.125f) * _3919;
                                                                    _4104 = (_global_7[min((uint)(((int)(0u + (_4090 * 2)))), 127u)]) * _4095;
                                                                    _4105 = (_global_7[min((uint)(((int)(1u + (_4090 * 2)))), 127u)]) * _4095;
                                                                    _4107 = -0.0f - _4083;
                                                                    _4109 = dot(float2(_4104, _4105), float2(_4084, _4083)) + _4058;
                                                                    _4110 = dot(float2(_4104, _4105), float2(_4107, _4084)) + _4059;
                                                                    _4112 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4109, _4110));
                                                                    _4116 = _4109 * _3944;
                                                                    _4117 = _4110 * _3945;
                                                                    _4120 = floor(_4065 * _3944);
                                                                    _4121 = floor(_4066 * _3945);
                                                                    _4126 = floor(((_4065 + _3940) * _3944) + 0.5f);
                                                                    _4127 = floor(((_4066 + _3941) * _3945) + 0.5f);
                                                                    _4130 = floor(_4116 + -0.5f);
                                                                    _4131 = floor(_4117 + 0.5f);
                                                                    _4133 = floor(_4116 + 0.5f);
                                                                    _4135 = floor(_4117 + -0.5f);
                                                                    _4136 = (_4130 < _4120);
                                                                    _4137 = (_4131 < _4121);
                                                                    do {
                                                                      if (!(_4136 || _4137)) {
                                                                        if ((_4130 >= _4126) || (_4131 >= _4127)) {
                                                                          _4146 = _4089;
                                                                        } else {
                                                                          _4146 = _4112.x;
                                                                        }
                                                                      } else {
                                                                        _4146 = _4089;
                                                                      }
                                                                      _4147 = (_4133 < _4120);
                                                                      do {
                                                                        if (!(_4147 || _4137)) {
                                                                          if ((_4133 >= _4126) || (_4131 >= _4127)) {
                                                                            _4155 = _4089;
                                                                          } else {
                                                                            _4155 = _4112.y;
                                                                          }
                                                                        } else {
                                                                          _4155 = _4089;
                                                                        }
                                                                        _4156 = (_4135 < _4121);
                                                                        do {
                                                                          if (!(_4147 || _4156)) {
                                                                            if ((_4133 >= _4126) || (_4135 >= _4127)) {
                                                                              _4164 = _4089;
                                                                            } else {
                                                                              _4164 = _4112.z;
                                                                            }
                                                                          } else {
                                                                            _4164 = _4089;
                                                                          }
                                                                          do {
                                                                            if (!(_4136 || _4156)) {
                                                                              if ((_4130 >= _4126) || (_4135 >= _4127)) {
                                                                                _4172 = _4089;
                                                                              } else {
                                                                                _4172 = _4112.w;
                                                                              }
                                                                            } else {
                                                                              _4172 = _4089;
                                                                            }
                                                                            _4173 = _4146 - _4069;
                                                                            _4175 = select((_4173 < 0.0f), 0.0f, 1.0f);
                                                                            _4177 = _4155 - _4069;
                                                                            _4179 = select((_4177 < 0.0f), 0.0f, 1.0f);
                                                                            _4183 = _4164 - _4069;
                                                                            _4185 = select((_4183 < 0.0f), 0.0f, 1.0f);
                                                                            _4189 = _4172 - _4069;
                                                                            _4191 = select((_4189 < 0.0f), 0.0f, 1.0f);
                                                                            _4198 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _4203 = sqrt((float((int)(_4198)) * 0.25f) + 0.125f) * _3919;
                                                                            _4212 = (_global_7[min((uint)(((int)(0u + (_4198 * 2)))), 127u)]) * _4203;
                                                                            _4213 = (_global_7[min((uint)(((int)(1u + (_4198 * 2)))), 127u)]) * _4203;
                                                                            _4216 = dot(float2(_4212, _4213), float2(_4084, _4083)) + _4058;
                                                                            _4217 = dot(float2(_4212, _4213), float2(_4107, _4084)) + _4059;
                                                                            _4219 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4216, _4217));
                                                                            _4223 = _4216 * _3944;
                                                                            _4224 = _4217 * _3945;
                                                                            _4227 = floor(_4223 + -0.5f);
                                                                            _4228 = floor(_4224 + 0.5f);
                                                                            _4230 = floor(_4223 + 0.5f);
                                                                            _4232 = floor(_4224 + -0.5f);
                                                                            _4233 = (_4227 < _4120);
                                                                            _4234 = (_4228 < _4121);
                                                                            do {
                                                                              if (!(_4233 || _4234)) {
                                                                                if ((_4227 >= _4126) || (_4228 >= _4127)) {
                                                                                  _4243 = _4089;
                                                                                } else {
                                                                                  _4243 = _4219.x;
                                                                                }
                                                                              } else {
                                                                                _4243 = _4089;
                                                                              }
                                                                              _4244 = (_4230 < _4120);
                                                                              do {
                                                                                if (!(_4244 || _4234)) {
                                                                                  if ((_4230 >= _4126) || (_4228 >= _4127)) {
                                                                                    _4252 = _4089;
                                                                                  } else {
                                                                                    _4252 = _4219.y;
                                                                                  }
                                                                                } else {
                                                                                  _4252 = _4089;
                                                                                }
                                                                                _4253 = (_4232 < _4121);
                                                                                do {
                                                                                  if (!(_4244 || _4253)) {
                                                                                    if ((_4230 >= _4126) || (_4232 >= _4127)) {
                                                                                      _4261 = _4089;
                                                                                    } else {
                                                                                      _4261 = _4219.z;
                                                                                    }
                                                                                  } else {
                                                                                    _4261 = _4089;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_4233 || _4253)) {
                                                                                      if ((_4227 >= _4126) || (_4232 >= _4127)) {
                                                                                        _4269 = _4089;
                                                                                      } else {
                                                                                        _4269 = _4219.w;
                                                                                      }
                                                                                    } else {
                                                                                      _4269 = _4089;
                                                                                    }
                                                                                    _4270 = _4243 - _4069;
                                                                                    _4272 = select((_4270 < 0.0f), 0.0f, 1.0f);
                                                                                    _4276 = _4252 - _4069;
                                                                                    _4278 = select((_4276 < 0.0f), 0.0f, 1.0f);
                                                                                    _4282 = _4261 - _4069;
                                                                                    _4284 = select((_4282 < 0.0f), 0.0f, 1.0f);
                                                                                    _4288 = _4269 - _4069;
                                                                                    _4290 = select((_4288 < 0.0f), 0.0f, 1.0f);
                                                                                    _4297 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _4302 = sqrt((float((int)(_4297)) * 0.25f) + 0.125f) * _3919;
                                                                                    _4311 = (_global_7[min((uint)(((int)(0u + (_4297 * 2)))), 127u)]) * _4302;
                                                                                    _4312 = (_global_7[min((uint)(((int)(1u + (_4297 * 2)))), 127u)]) * _4302;
                                                                                    _4315 = dot(float2(_4311, _4312), float2(_4084, _4083)) + _4058;
                                                                                    _4316 = dot(float2(_4311, _4312), float2(_4107, _4084)) + _4059;
                                                                                    _4318 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4315, _4316));
                                                                                    _4322 = _4315 * _3944;
                                                                                    _4323 = _4316 * _3945;
                                                                                    _4326 = floor(_4322 + -0.5f);
                                                                                    _4327 = floor(_4323 + 0.5f);
                                                                                    _4329 = floor(_4322 + 0.5f);
                                                                                    _4331 = floor(_4323 + -0.5f);
                                                                                    _4332 = (_4326 < _4120);
                                                                                    _4333 = (_4327 < _4121);
                                                                                    do {
                                                                                      if (!(_4332 || _4333)) {
                                                                                        if ((_4326 >= _4126) || (_4327 >= _4127)) {
                                                                                          _4342 = _4089;
                                                                                        } else {
                                                                                          _4342 = _4318.x;
                                                                                        }
                                                                                      } else {
                                                                                        _4342 = _4089;
                                                                                      }
                                                                                      _4343 = (_4329 < _4120);
                                                                                      do {
                                                                                        if (!(_4343 || _4333)) {
                                                                                          if ((_4329 >= _4126) || (_4327 >= _4127)) {
                                                                                            _4351 = _4089;
                                                                                          } else {
                                                                                            _4351 = _4318.y;
                                                                                          }
                                                                                        } else {
                                                                                          _4351 = _4089;
                                                                                        }
                                                                                        _4352 = (_4331 < _4121);
                                                                                        do {
                                                                                          if (!(_4343 || _4352)) {
                                                                                            if ((_4329 >= _4126) || (_4331 >= _4127)) {
                                                                                              _4360 = _4089;
                                                                                            } else {
                                                                                              _4360 = _4318.z;
                                                                                            }
                                                                                          } else {
                                                                                            _4360 = _4089;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_4332 || _4352)) {
                                                                                              if ((_4326 >= _4126) || (_4331 >= _4127)) {
                                                                                                _4368 = _4089;
                                                                                              } else {
                                                                                                _4368 = _4318.w;
                                                                                              }
                                                                                            } else {
                                                                                              _4368 = _4089;
                                                                                            }
                                                                                            _4369 = _4342 - _4069;
                                                                                            _4371 = select((_4369 < 0.0f), 0.0f, 1.0f);
                                                                                            _4375 = _4351 - _4069;
                                                                                            _4377 = select((_4375 < 0.0f), 0.0f, 1.0f);
                                                                                            _4381 = _4360 - _4069;
                                                                                            _4383 = select((_4381 < 0.0f), 0.0f, 1.0f);
                                                                                            _4387 = _4368 - _4069;
                                                                                            _4389 = select((_4387 < 0.0f), 0.0f, 1.0f);
                                                                                            _4396 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _4401 = sqrt((float((int)(_4396)) * 0.25f) + 0.125f) * _3919;
                                                                                            _4410 = (_global_7[min((uint)(((int)(0u + (_4396 * 2)))), 127u)]) * _4401;
                                                                                            _4411 = (_global_7[min((uint)(((int)(1u + (_4396 * 2)))), 127u)]) * _4401;
                                                                                            _4414 = dot(float2(_4410, _4411), float2(_4084, _4083)) + _4058;
                                                                                            _4415 = dot(float2(_4410, _4411), float2(_4107, _4084)) + _4059;
                                                                                            _4417 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4414, _4415));
                                                                                            _4421 = _4414 * _3944;
                                                                                            _4422 = _4415 * _3945;
                                                                                            _4425 = floor(_4421 + -0.5f);
                                                                                            _4426 = floor(_4422 + 0.5f);
                                                                                            _4428 = floor(_4421 + 0.5f);
                                                                                            _4430 = floor(_4422 + -0.5f);
                                                                                            _4431 = (_4425 < _4120);
                                                                                            _4432 = (_4426 < _4121);
                                                                                            do {
                                                                                              if (!(_4431 || _4432)) {
                                                                                                if ((_4425 >= _4126) || (_4426 >= _4127)) {
                                                                                                  _4441 = _4089;
                                                                                                } else {
                                                                                                  _4441 = _4417.x;
                                                                                                }
                                                                                              } else {
                                                                                                _4441 = _4089;
                                                                                              }
                                                                                              _4442 = (_4428 < _4120);
                                                                                              do {
                                                                                                if (!(_4442 || _4432)) {
                                                                                                  if ((_4428 >= _4126) || (_4426 >= _4127)) {
                                                                                                    _4450 = _4089;
                                                                                                  } else {
                                                                                                    _4450 = _4417.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _4450 = _4089;
                                                                                                }
                                                                                                _4451 = (_4430 < _4121);
                                                                                                do {
                                                                                                  if (!(_4442 || _4451)) {
                                                                                                    if ((_4428 >= _4126) || (_4430 >= _4127)) {
                                                                                                      _4459 = _4089;
                                                                                                    } else {
                                                                                                      _4459 = _4417.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _4459 = _4089;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_4431 || _4451)) {
                                                                                                      if ((_4425 >= _4126) || (_4430 >= _4127)) {
                                                                                                        _4467 = _4089;
                                                                                                      } else {
                                                                                                        _4467 = _4417.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _4467 = _4089;
                                                                                                    }
                                                                                                    _4468 = _4441 - _4069;
                                                                                                    _4470 = select((_4468 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4474 = _4450 - _4069;
                                                                                                    _4476 = select((_4474 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4480 = _4459 - _4069;
                                                                                                    _4482 = select((_4480 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4486 = _4467 - _4069;
                                                                                                    _4488 = select((_4486 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4489 = ((((((((((((((_4179 + _4175) + _4185) + _4191) + _4272) + _4278) + _4284) + _4290) + _4371) + _4377) + _4383) + _4389) + _4470) + _4476) + _4482) + _4488;
                                                                                                    _4500 = (saturate(_4489 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _4506 = float((int)(((int)(uint)((int)(_4500 > 0.0f))) - ((int)(uint)((int)(_4500 < 0.0f)))));
                                                                                                    _4508 = 1.0f - (_4506 * _4500);
                                                                                                    _4510 = (_4508 * _4508) * _4508;
                                                                                                    _4856 = (0.5f - ((_4506 * 0.5f) * ((1.0f - _4510) - ((_4508 - _4510) * saturate(((1.0f / _4069) * (1.0f / _4489)) * ((((((((((((((((_4179 * _4177) + (_4175 * _4173)) + (_4185 * _4183)) + (_4191 * _4189)) + (_4272 * _4270)) + (_4278 * _4276)) + (_4284 * _4282)) + (_4290 * _4288)) + (_4371 * _4369)) + (_4377 * _4375)) + (_4383 * _4381)) + (_4389 * _4387)) + (_4470 * _4468)) + (_4476 * _4474)) + (_4482 * _4480)) + (_4488 * _4486)))))));
                                                                                                    _4857 = (((float4)(_HeapResource_22.SampleCmpLevelZero(samplerLinearPCFBorderBlackNode, float2(_4058, _4059), _4060))).x);
                                                                                                    _4858 = 1.0f;
                                                                                                    _4859 = 1;
                                                                                                    _4860 = _3899;
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
                                                                  _4522 = f16tof32(_3874) / _4013;
                                                                  _4525 = mad((_4522 * _4011), 0.5f, 0.5f);
                                                                  _4526 = mad((_4522 * _4012), 0.5f, 0.5f);
                                                                  _4529 = (1.0f - (_4000 * _3898)) + _3916;
                                                                  if (_4000 > -0.0f) {
                                                                    if ((saturate(_4525) == _4525) && (saturate(_4526) == _4526)) {
                                                                      _4540 = (_4525 * _3940) + _3942;
                                                                      _4541 = (_4526 * _3941) + _3943;
                                                                      _4542 = saturate(_4529);
                                                                      _4546 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _4555 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 3u);
                                                                      } else {
                                                                        _4555 = frac(frac(dot(float2(((_4546 * 32.665000915527344f) + _127), ((_4546 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _4555 = frac(frac(dot(float2(((_4546 * 32.665000915527344f) + _127), ((_4546 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _4556 = sin(_4555);
                                                                      _4557 = cos(_4555);
                                                                      _4558 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _4563 = sqrt((float((int)(_4558)) * 0.25f) + 0.125f) * _3919;
                                                                      _4572 = (_global_7[min((uint)(((int)(0u + (_4558 * 2)))), 127u)]) * _4563;
                                                                      _4573 = (_global_7[min((uint)(((int)(1u + (_4558 * 2)))), 127u)]) * _4563;
                                                                      _4575 = -0.0f - _4556;
                                                                      _4580 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4572, _4573), float2(_4557, _4556)) + _4540), (dot(float2(_4572, _4573), float2(_4575, _4557)) + _4541)));
                                                                      _4585 = _4580.x - _4542;
                                                                      _4587 = select((_4585 < 0.0f), 0.0f, 1.0f);
                                                                      _4589 = _4580.y - _4542;
                                                                      _4591 = select((_4589 < 0.0f), 0.0f, 1.0f);
                                                                      _4595 = _4580.z - _4542;
                                                                      _4597 = select((_4595 < 0.0f), 0.0f, 1.0f);
                                                                      _4601 = _4580.w - _4542;
                                                                      _4603 = select((_4601 < 0.0f), 0.0f, 1.0f);
                                                                      _4610 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _4615 = sqrt((float((int)(_4610)) * 0.25f) + 0.125f) * _3919;
                                                                      _4624 = (_global_7[min((uint)(((int)(0u + (_4610 * 2)))), 127u)]) * _4615;
                                                                      _4625 = (_global_7[min((uint)(((int)(1u + (_4610 * 2)))), 127u)]) * _4615;
                                                                      _4631 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4624, _4625), float2(_4557, _4556)) + _4540), (dot(float2(_4624, _4625), float2(_4575, _4557)) + _4541)));
                                                                      _4636 = _4631.x - _4542;
                                                                      _4638 = select((_4636 < 0.0f), 0.0f, 1.0f);
                                                                      _4642 = _4631.y - _4542;
                                                                      _4644 = select((_4642 < 0.0f), 0.0f, 1.0f);
                                                                      _4648 = _4631.z - _4542;
                                                                      _4650 = select((_4648 < 0.0f), 0.0f, 1.0f);
                                                                      _4654 = _4631.w - _4542;
                                                                      _4656 = select((_4654 < 0.0f), 0.0f, 1.0f);
                                                                      _4663 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                      _4668 = sqrt((float((int)(_4663)) * 0.25f) + 0.125f) * _3919;
                                                                      _4677 = (_global_7[min((uint)(((int)(0u + (_4663 * 2)))), 127u)]) * _4668;
                                                                      _4678 = (_global_7[min((uint)(((int)(1u + (_4663 * 2)))), 127u)]) * _4668;
                                                                      _4684 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4677, _4678), float2(_4557, _4556)) + _4540), (dot(float2(_4677, _4678), float2(_4575, _4557)) + _4541)));
                                                                      _4689 = _4684.x - _4542;
                                                                      _4691 = select((_4689 < 0.0f), 0.0f, 1.0f);
                                                                      _4695 = _4684.y - _4542;
                                                                      _4697 = select((_4695 < 0.0f), 0.0f, 1.0f);
                                                                      _4701 = _4684.z - _4542;
                                                                      _4703 = select((_4701 < 0.0f), 0.0f, 1.0f);
                                                                      _4707 = _4684.w - _4542;
                                                                      _4709 = select((_4707 < 0.0f), 0.0f, 1.0f);
                                                                      _4716 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                      _4721 = sqrt((float((int)(_4716)) * 0.25f) + 0.125f) * _3919;
                                                                      _4730 = (_global_7[min((uint)(((int)(0u + (_4716 * 2)))), 127u)]) * _4721;
                                                                      _4731 = (_global_7[min((uint)(((int)(1u + (_4716 * 2)))), 127u)]) * _4721;
                                                                      _4737 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4730, _4731), float2(_4557, _4556)) + _4540), (dot(float2(_4730, _4731), float2(_4575, _4557)) + _4541)));
                                                                      _4742 = _4737.x - _4542;
                                                                      _4744 = select((_4742 < 0.0f), 0.0f, 1.0f);
                                                                      _4748 = _4737.y - _4542;
                                                                      _4750 = select((_4748 < 0.0f), 0.0f, 1.0f);
                                                                      _4754 = _4737.z - _4542;
                                                                      _4756 = select((_4754 < 0.0f), 0.0f, 1.0f);
                                                                      _4760 = _4737.w - _4542;
                                                                      _4762 = select((_4760 < 0.0f), 0.0f, 1.0f);
                                                                      _4763 = ((((((((((((((_4587 + _4591) + _4597) + _4603) + _4638) + _4644) + _4650) + _4656) + _4691) + _4697) + _4703) + _4709) + _4744) + _4750) + _4756) + _4762;
                                                                      _4774 = (saturate(_4763 * 0.0625f) * 2.0f) + -1.0f;
                                                                      _4780 = float((int)(((int)(uint)((int)(_4774 > 0.0f))) - ((int)(uint)((int)(_4774 < 0.0f)))));
                                                                      _4782 = 1.0f - (_4780 * _4774);
                                                                      _4784 = (_4782 * _4782) * _4782;
                                                                      _4792 = -0.0f - _4011;
                                                                      _4799 = saturate((saturate(rsqrt(dot(float3(_4792, _4003, _4000), float3(_4792, _4003, _4000))) * _4000) * _3896) + _3895);
                                                                      _4801 = 1.0f - (_4799 * _4799);
                                                                      _4808 = frac((_4540 * _3944) + 0.5f);
                                                                      _4809 = frac((_4541 * _3945) + 0.5f);
                                                                      _4810 = _4540 + _3946;
                                                                      _4811 = _4541 + _3947;
                                                                      _4813 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4810, _4811), _4529);
                                                                      _4822 = _4810 - (_3946 * 2.0f);
                                                                      _4823 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4822, _4811), _4529);
                                                                      _4828 = 1.0f - _4808;
                                                                      _4834 = _4811 - (_3947 * 2.0f);
                                                                      _4835 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4822, _4834), _4529);
                                                                      _4840 = 1.0f - _4809;
                                                                      _4845 = _HeapResource_22.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_4810, _4834), _4529);
                                                                      _4856 = (0.5f - ((_4780 * 0.5f) * ((1.0f - _4784) - ((_4782 - _4784) * saturate(((1.0f / _4542) * (1.0f / _4763)) * ((((((((((((((((_4587 * _4585) + (_4591 * _4589)) + (_4597 * _4595)) + (_4603 * _4601)) + (_4638 * _4636)) + (_4644 * _4642)) + (_4650 * _4648)) + (_4656 * _4654)) + (_4691 * _4689)) + (_4697 * _4695)) + (_4703 * _4701)) + (_4709 * _4707)) + (_4744 * _4742)) + (_4750 * _4748)) + (_4756 * _4754)) + (_4762 * _4760)))))));
                                                                      _4857 = ((((mad(mad(_4823.x, _4828, _4823.y), _4809, mad(_4823.w, _4828, _4823.z)) + mad(mad(_4813.y, _4808, _4813.x), _4809, mad(_4813.z, _4808, _4813.w))) + mad(mad(_4835.w, _4828, _4835.z), _4840, mad(_4835.x, _4828, _4835.y))) + mad(mad(_4845.z, _4808, _4845.w), _4840, mad(_4845.y, _4808, _4845.x))) * 0.1111111119389534f);
                                                                      _4858 = (1.0f - (_4801 * _4801));
                                                                      _4859 = 1;
                                                                      _4860 = _3899;
                                                                    } else {
                                                                      _4856 = 1.0f;
                                                                      _4857 = 0.0f;
                                                                      _4858 = 1.0f;
                                                                      _4859 = 0;
                                                                      _4860 = _3899;
                                                                    }
                                                                  } else {
                                                                    _4856 = 1.0f;
                                                                    _4857 = 0.0f;
                                                                    _4858 = 1.0f;
                                                                    _4859 = 0;
                                                                    _4860 = _3899;
                                                                  }
                                                                }
                                                              }
                                                              do {
                                                                _5650 = 1.0f;
                                                                _5651 = 1.0f;
                                                                _5652 = true;
                                                                [branch]
                                                                if (!((_1628 & 512) == 0)) {
                                                                  Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                                                                  [branch]
                                                                  if (!((_1628 & 2097152) == 0)) {
                                                                    _4868 = abs(_4011);
                                                                    _4869 = abs(_4012);
                                                                    _4870 = abs(_4013);
                                                                    do {
                                                                      if (_4868 > max(_4869, _4870)) {
                                                                        _4874 = (_4011 > 0.0f);
                                                                        _4889 = select(_4874, 0.0f, 1.0f);
                                                                        _4890 = 0.0f;
                                                                        _4891 = select(_4874, _4000, _4013);
                                                                        _4892 = _4003;
                                                                        _4893 = _4868;
                                                                      } else {
                                                                        if (_4869 > _4870) {
                                                                          _4880 = (_4003 < -0.0f);
                                                                          _4889 = select(_4880, 0.0f, 1.0f);
                                                                          _4890 = 1.0f;
                                                                          _4891 = _4011;
                                                                          _4892 = select(_4880, _4013, _4000);
                                                                          _4893 = _4869;
                                                                        } else {
                                                                          _4884 = (_4000 < -0.0f);
                                                                          _4889 = select(_4884, 0.0f, 1.0f);
                                                                          _4890 = 2.0f;
                                                                          _4891 = select(_4884, _4011, (-0.0f - _4011));
                                                                          _4892 = _4003;
                                                                          _4893 = _4870;
                                                                        }
                                                                      }
                                                                      _4894 = _4893 * 2.0f;
                                                                      _4899 = -0.0f - _3913;
                                                                      _4908 = ((min(max((_4891 / _4894), _4899), _3913) + _4889) * _3859) + _3861;
                                                                      _4909 = ((min(max((_4892 / _4894), _4899), _3913) + _4890) * _3860) + _3862;
                                                                      _4914 = ((_4889 + -0.5f) * _3859) + _3861;
                                                                      _4915 = ((_4890 + -0.5f) * _3860) + _3862;
                                                                      _4918 = saturate(1.0f - (_4893 * _3898));
                                                                      _4922 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _4931 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 4u);
                                                                      } else {
                                                                        _4931 = frac(frac(dot(float2(((_4922 * 32.665000915527344f) + _127), ((_4922 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _4931 = frac(frac(dot(float2(((_4922 * 32.665000915527344f) + _127), ((_4922 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _4932 = sin(_4931);
                                                                      _4933 = cos(_4931);
                                                                      _4938 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4908, _4909), 0.0f))).x) > _4918), 1.0f, 0.0f);
                                                                      _4939 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _4944 = sqrt((float((int)(_4939)) * 0.25f) + 0.125f) * _3920;
                                                                      _4953 = (_global_7[min((uint)(((int)(0u + (_4939 * 2)))), 127u)]) * _4944;
                                                                      _4954 = (_global_7[min((uint)(((int)(1u + (_4939 * 2)))), 127u)]) * _4944;
                                                                      _4956 = -0.0f - _4932;
                                                                      _4958 = dot(float2(_4953, _4954), float2(_4933, _4932)) + _4908;
                                                                      _4959 = dot(float2(_4953, _4954), float2(_4956, _4933)) + _4909;
                                                                      _4961 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4958, _4959));
                                                                      _4965 = _4958 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _4966 = _4959 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _4969 = floor(_4914 * cbSharedPerViewData.vShadowAtlasSize.x);
                                                                      _4970 = floor(_4915 * cbSharedPerViewData.vShadowAtlasSize.y);
                                                                      _4975 = floor(((_4914 + _3859) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                                                                      _4976 = floor(((_4915 + _3860) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                                                                      _4979 = floor(_4965 + -0.5f);
                                                                      _4980 = floor(_4966 + 0.5f);
                                                                      _4982 = floor(_4965 + 0.5f);
                                                                      _4984 = floor(_4966 + -0.5f);
                                                                      _4985 = (_4979 < _4969);
                                                                      _4986 = (_4980 < _4970);
                                                                      do {
                                                                        if (!(_4985 || _4986)) {
                                                                          if ((_4979 >= _4975) || (_4980 >= _4976)) {
                                                                            _4995 = _4938;
                                                                          } else {
                                                                            _4995 = _4961.x;
                                                                          }
                                                                        } else {
                                                                          _4995 = _4938;
                                                                        }
                                                                        _4996 = (_4982 < _4969);
                                                                        do {
                                                                          if (!(_4996 || _4986)) {
                                                                            if ((_4982 >= _4975) || (_4980 >= _4976)) {
                                                                              _5004 = _4938;
                                                                            } else {
                                                                              _5004 = _4961.y;
                                                                            }
                                                                          } else {
                                                                            _5004 = _4938;
                                                                          }
                                                                          _5005 = (_4984 < _4970);
                                                                          do {
                                                                            if (!(_4996 || _5005)) {
                                                                              if ((_4982 >= _4975) || (_4984 >= _4976)) {
                                                                                _5013 = _4938;
                                                                              } else {
                                                                                _5013 = _4961.z;
                                                                              }
                                                                            } else {
                                                                              _5013 = _4938;
                                                                            }
                                                                            do {
                                                                              if (!(_4985 || _5005)) {
                                                                                if ((_4979 >= _4975) || (_4984 >= _4976)) {
                                                                                  _5021 = _4938;
                                                                                } else {
                                                                                  _5021 = _4961.w;
                                                                                }
                                                                              } else {
                                                                                _5021 = _4938;
                                                                              }
                                                                              _5022 = _4995 - _4918;
                                                                              _5024 = select((_5022 < 0.0f), 0.0f, 1.0f);
                                                                              _5026 = _5004 - _4918;
                                                                              _5028 = select((_5026 < 0.0f), 0.0f, 1.0f);
                                                                              _5032 = _5013 - _4918;
                                                                              _5034 = select((_5032 < 0.0f), 0.0f, 1.0f);
                                                                              _5038 = _5021 - _4918;
                                                                              _5040 = select((_5038 < 0.0f), 0.0f, 1.0f);
                                                                              _5047 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                              _5052 = sqrt((float((int)(_5047)) * 0.25f) + 0.125f) * _3920;
                                                                              _5061 = (_global_7[min((uint)(((int)(0u + (_5047 * 2)))), 127u)]) * _5052;
                                                                              _5062 = (_global_7[min((uint)(((int)(1u + (_5047 * 2)))), 127u)]) * _5052;
                                                                              _5065 = dot(float2(_5061, _5062), float2(_4933, _4932)) + _4908;
                                                                              _5066 = dot(float2(_5061, _5062), float2(_4956, _4933)) + _4909;
                                                                              _5068 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5065, _5066));
                                                                              _5072 = _5065 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _5073 = _5066 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _5076 = floor(_5072 + -0.5f);
                                                                              _5077 = floor(_5073 + 0.5f);
                                                                              _5079 = floor(_5072 + 0.5f);
                                                                              _5081 = floor(_5073 + -0.5f);
                                                                              _5082 = (_5076 < _4969);
                                                                              _5083 = (_5077 < _4970);
                                                                              do {
                                                                                if (!(_5082 || _5083)) {
                                                                                  if ((_5076 >= _4975) || (_5077 >= _4976)) {
                                                                                    _5092 = _4938;
                                                                                  } else {
                                                                                    _5092 = _5068.x;
                                                                                  }
                                                                                } else {
                                                                                  _5092 = _4938;
                                                                                }
                                                                                _5093 = (_5079 < _4969);
                                                                                do {
                                                                                  if (!(_5093 || _5083)) {
                                                                                    if ((_5079 >= _4975) || (_5077 >= _4976)) {
                                                                                      _5101 = _4938;
                                                                                    } else {
                                                                                      _5101 = _5068.y;
                                                                                    }
                                                                                  } else {
                                                                                    _5101 = _4938;
                                                                                  }
                                                                                  _5102 = (_5081 < _4970);
                                                                                  do {
                                                                                    if (!(_5093 || _5102)) {
                                                                                      if ((_5079 >= _4975) || (_5081 >= _4976)) {
                                                                                        _5110 = _4938;
                                                                                      } else {
                                                                                        _5110 = _5068.z;
                                                                                      }
                                                                                    } else {
                                                                                      _5110 = _4938;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_5082 || _5102)) {
                                                                                        if ((_5076 >= _4975) || (_5081 >= _4976)) {
                                                                                          _5118 = _4938;
                                                                                        } else {
                                                                                          _5118 = _5068.w;
                                                                                        }
                                                                                      } else {
                                                                                        _5118 = _4938;
                                                                                      }
                                                                                      _5119 = _5092 - _4918;
                                                                                      _5121 = select((_5119 < 0.0f), 0.0f, 1.0f);
                                                                                      _5125 = _5101 - _4918;
                                                                                      _5127 = select((_5125 < 0.0f), 0.0f, 1.0f);
                                                                                      _5131 = _5110 - _4918;
                                                                                      _5133 = select((_5131 < 0.0f), 0.0f, 1.0f);
                                                                                      _5137 = _5118 - _4918;
                                                                                      _5139 = select((_5137 < 0.0f), 0.0f, 1.0f);
                                                                                      _5146 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                      _5151 = sqrt((float((int)(_5146)) * 0.25f) + 0.125f) * _3920;
                                                                                      _5160 = (_global_7[min((uint)(((int)(0u + (_5146 * 2)))), 127u)]) * _5151;
                                                                                      _5161 = (_global_7[min((uint)(((int)(1u + (_5146 * 2)))), 127u)]) * _5151;
                                                                                      _5164 = dot(float2(_5160, _5161), float2(_4933, _4932)) + _4908;
                                                                                      _5165 = dot(float2(_5160, _5161), float2(_4956, _4933)) + _4909;
                                                                                      _5167 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5164, _5165));
                                                                                      _5171 = _5164 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _5172 = _5165 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _5175 = floor(_5171 + -0.5f);
                                                                                      _5176 = floor(_5172 + 0.5f);
                                                                                      _5178 = floor(_5171 + 0.5f);
                                                                                      _5180 = floor(_5172 + -0.5f);
                                                                                      _5181 = (_5175 < _4969);
                                                                                      _5182 = (_5176 < _4970);
                                                                                      do {
                                                                                        if (!(_5181 || _5182)) {
                                                                                          if ((_5175 >= _4975) || (_5176 >= _4976)) {
                                                                                            _5191 = _4938;
                                                                                          } else {
                                                                                            _5191 = _5167.x;
                                                                                          }
                                                                                        } else {
                                                                                          _5191 = _4938;
                                                                                        }
                                                                                        _5192 = (_5178 < _4969);
                                                                                        do {
                                                                                          if (!(_5192 || _5182)) {
                                                                                            if ((_5178 >= _4975) || (_5176 >= _4976)) {
                                                                                              _5200 = _4938;
                                                                                            } else {
                                                                                              _5200 = _5167.y;
                                                                                            }
                                                                                          } else {
                                                                                            _5200 = _4938;
                                                                                          }
                                                                                          _5201 = (_5180 < _4970);
                                                                                          do {
                                                                                            if (!(_5192 || _5201)) {
                                                                                              if ((_5178 >= _4975) || (_5180 >= _4976)) {
                                                                                                _5209 = _4938;
                                                                                              } else {
                                                                                                _5209 = _5167.z;
                                                                                              }
                                                                                            } else {
                                                                                              _5209 = _4938;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_5181 || _5201)) {
                                                                                                if ((_5175 >= _4975) || (_5180 >= _4976)) {
                                                                                                  _5217 = _4938;
                                                                                                } else {
                                                                                                  _5217 = _5167.w;
                                                                                                }
                                                                                              } else {
                                                                                                _5217 = _4938;
                                                                                              }
                                                                                              _5218 = _5191 - _4918;
                                                                                              _5220 = select((_5218 < 0.0f), 0.0f, 1.0f);
                                                                                              _5224 = _5200 - _4918;
                                                                                              _5226 = select((_5224 < 0.0f), 0.0f, 1.0f);
                                                                                              _5230 = _5209 - _4918;
                                                                                              _5232 = select((_5230 < 0.0f), 0.0f, 1.0f);
                                                                                              _5236 = _5217 - _4918;
                                                                                              _5238 = select((_5236 < 0.0f), 0.0f, 1.0f);
                                                                                              _5245 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                              _5250 = sqrt((float((int)(_5245)) * 0.25f) + 0.125f) * _3920;
                                                                                              _5259 = (_global_7[min((uint)(((int)(0u + (_5245 * 2)))), 127u)]) * _5250;
                                                                                              _5260 = (_global_7[min((uint)(((int)(1u + (_5245 * 2)))), 127u)]) * _5250;
                                                                                              _5263 = dot(float2(_5259, _5260), float2(_4933, _4932)) + _4908;
                                                                                              _5264 = dot(float2(_5259, _5260), float2(_4956, _4933)) + _4909;
                                                                                              _5266 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_5263, _5264));
                                                                                              _5270 = _5263 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                              _5271 = _5264 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                              _5274 = floor(_5270 + -0.5f);
                                                                                              _5275 = floor(_5271 + 0.5f);
                                                                                              _5277 = floor(_5270 + 0.5f);
                                                                                              _5279 = floor(_5271 + -0.5f);
                                                                                              _5280 = (_5274 < _4969);
                                                                                              _5281 = (_5275 < _4970);
                                                                                              do {
                                                                                                if (!(_5280 || _5281)) {
                                                                                                  if ((_5274 >= _4975) || (_5275 >= _4976)) {
                                                                                                    _5290 = _4938;
                                                                                                  } else {
                                                                                                    _5290 = _5266.x;
                                                                                                  }
                                                                                                } else {
                                                                                                  _5290 = _4938;
                                                                                                }
                                                                                                _5291 = (_5277 < _4969);
                                                                                                do {
                                                                                                  if (!(_5291 || _5281)) {
                                                                                                    if ((_5277 >= _4975) || (_5275 >= _4976)) {
                                                                                                      _5299 = _4938;
                                                                                                    } else {
                                                                                                      _5299 = _5266.y;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _5299 = _4938;
                                                                                                  }
                                                                                                  _5300 = (_5279 < _4970);
                                                                                                  do {
                                                                                                    if (!(_5291 || _5300)) {
                                                                                                      if ((_5277 >= _4975) || (_5279 >= _4976)) {
                                                                                                        _5308 = _4938;
                                                                                                      } else {
                                                                                                        _5308 = _5266.z;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _5308 = _4938;
                                                                                                    }
                                                                                                    do {
                                                                                                      if (!(_5280 || _5300)) {
                                                                                                        if ((_5274 >= _4975) || (_5279 >= _4976)) {
                                                                                                          _5316 = _4938;
                                                                                                        } else {
                                                                                                          _5316 = _5266.w;
                                                                                                        }
                                                                                                      } else {
                                                                                                        _5316 = _4938;
                                                                                                      }
                                                                                                      _5317 = _5290 - _4918;
                                                                                                      _5319 = select((_5317 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5323 = _5299 - _4918;
                                                                                                      _5325 = select((_5323 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5329 = _5308 - _4918;
                                                                                                      _5331 = select((_5329 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5335 = _5316 - _4918;
                                                                                                      _5337 = select((_5335 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5338 = ((((((((((((((_5028 + _5024) + _5034) + _5040) + _5121) + _5127) + _5133) + _5139) + _5220) + _5226) + _5232) + _5238) + _5319) + _5325) + _5331) + _5337;
                                                                                                      _5349 = (saturate(_5338 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                      _5355 = float((int)(((int)(uint)((int)(_5349 > 0.0f))) - ((int)(uint)((int)(_5349 < 0.0f)))));
                                                                                                      _5357 = 1.0f - (_5355 * _5349);
                                                                                                      _5359 = (_5357 * _5357) * _5357;
                                                                                                      _5650 = (0.5f - ((_5355 * 0.5f) * ((1.0f - _5359) - ((_5357 - _5359) * saturate(((1.0f / _4918) * (1.0f / _5338)) * ((((((((((((((((_5028 * _5026) + (_5024 * _5022)) + (_5034 * _5032)) + (_5040 * _5038)) + (_5121 * _5119)) + (_5127 * _5125)) + (_5133 * _5131)) + (_5139 * _5137)) + (_5220 * _5218)) + (_5226 * _5224)) + (_5232 * _5230)) + (_5238 * _5236)) + (_5319 * _5317)) + (_5325 * _5323)) + (_5331 * _5329)) + (_5337 * _5335)))))));
                                                                                                      _5651 = 1.0f;
                                                                                                      _5652 = false;
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
                                                                    _5368 = f16tof32(((uint)((uint)(_3874) >> 16))) / _4013;
                                                                    _5371 = mad((_5368 * _4011), 0.5f, 0.5f);
                                                                    _5372 = mad((_5368 * _4012), 0.5f, 0.5f);
                                                                    if (_4000 > -0.0f) {
                                                                      if ((saturate(_5371) == _5371) && (saturate(_5372) == _5372)) {
                                                                        _5385 = (_5371 * _3859) + _3861;
                                                                        _5386 = (_5372 * _3860) + _3862;
                                                                        _5387 = saturate(1.0f - (_4000 * _3898));
                                                                        _5391 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                        #if FIRSTLIGHT_ISFAST_ENABLED
                                                                        if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                          _5400 = RenoDX_ISFASTShadowAngle(
                                                                              uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 5u);
                                                                        } else {
                                                                          _5400 = frac(frac(dot(float2(((_5391 * 32.665000915527344f) + _127), ((_5391 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                        }
                                                                        #else
                                                                        _5400 = frac(frac(dot(float2(((_5391 * 32.665000915527344f) + _127), ((_5391 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                        #endif
                                                                        _5401 = sin(_5400);
                                                                        _5402 = cos(_5400);
                                                                        _5403 = cbSharedPerViewData.nFrameCounter & 3;
                                                                        _5408 = sqrt((float((int)(_5403)) * 0.25f) + 0.125f) * _3920;
                                                                        _5417 = (_global_7[min((uint)(((int)(0u + (_5403 * 2)))), 127u)]) * _5408;
                                                                        _5418 = (_global_7[min((uint)(((int)(1u + (_5403 * 2)))), 127u)]) * _5408;
                                                                        _5420 = -0.0f - _5401;
                                                                        _5425 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5417, _5418), float2(_5402, _5401)) + _5385), (dot(float2(_5417, _5418), float2(_5420, _5402)) + _5386)));
                                                                        _5430 = _5425.x - _5387;
                                                                        _5432 = select((_5430 < 0.0f), 0.0f, 1.0f);
                                                                        _5434 = _5425.y - _5387;
                                                                        _5436 = select((_5434 < 0.0f), 0.0f, 1.0f);
                                                                        _5440 = _5425.z - _5387;
                                                                        _5442 = select((_5440 < 0.0f), 0.0f, 1.0f);
                                                                        _5446 = _5425.w - _5387;
                                                                        _5448 = select((_5446 < 0.0f), 0.0f, 1.0f);
                                                                        _5455 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                        _5460 = sqrt((float((int)(_5455)) * 0.25f) + 0.125f) * _3920;
                                                                        _5469 = (_global_7[min((uint)(((int)(0u + (_5455 * 2)))), 127u)]) * _5460;
                                                                        _5470 = (_global_7[min((uint)(((int)(1u + (_5455 * 2)))), 127u)]) * _5460;
                                                                        _5476 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5469, _5470), float2(_5402, _5401)) + _5385), (dot(float2(_5469, _5470), float2(_5420, _5402)) + _5386)));
                                                                        _5481 = _5476.x - _5387;
                                                                        _5483 = select((_5481 < 0.0f), 0.0f, 1.0f);
                                                                        _5487 = _5476.y - _5387;
                                                                        _5489 = select((_5487 < 0.0f), 0.0f, 1.0f);
                                                                        _5493 = _5476.z - _5387;
                                                                        _5495 = select((_5493 < 0.0f), 0.0f, 1.0f);
                                                                        _5499 = _5476.w - _5387;
                                                                        _5501 = select((_5499 < 0.0f), 0.0f, 1.0f);
                                                                        _5508 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                        _5513 = sqrt((float((int)(_5508)) * 0.25f) + 0.125f) * _3920;
                                                                        _5522 = (_global_7[min((uint)(((int)(0u + (_5508 * 2)))), 127u)]) * _5513;
                                                                        _5523 = (_global_7[min((uint)(((int)(1u + (_5508 * 2)))), 127u)]) * _5513;
                                                                        _5529 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5522, _5523), float2(_5402, _5401)) + _5385), (dot(float2(_5522, _5523), float2(_5420, _5402)) + _5386)));
                                                                        _5534 = _5529.x - _5387;
                                                                        _5536 = select((_5534 < 0.0f), 0.0f, 1.0f);
                                                                        _5540 = _5529.y - _5387;
                                                                        _5542 = select((_5540 < 0.0f), 0.0f, 1.0f);
                                                                        _5546 = _5529.z - _5387;
                                                                        _5548 = select((_5546 < 0.0f), 0.0f, 1.0f);
                                                                        _5552 = _5529.w - _5387;
                                                                        _5554 = select((_5552 < 0.0f), 0.0f, 1.0f);
                                                                        _5561 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                        _5566 = sqrt((float((int)(_5561)) * 0.25f) + 0.125f) * _3920;
                                                                        _5575 = (_global_7[min((uint)(((int)(0u + (_5561 * 2)))), 127u)]) * _5566;
                                                                        _5576 = (_global_7[min((uint)(((int)(1u + (_5561 * 2)))), 127u)]) * _5566;
                                                                        _5582 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5575, _5576), float2(_5402, _5401)) + _5385), (dot(float2(_5575, _5576), float2(_5420, _5402)) + _5386)));
                                                                        _5587 = _5582.x - _5387;
                                                                        _5589 = select((_5587 < 0.0f), 0.0f, 1.0f);
                                                                        _5593 = _5582.y - _5387;
                                                                        _5595 = select((_5593 < 0.0f), 0.0f, 1.0f);
                                                                        _5599 = _5582.z - _5387;
                                                                        _5601 = select((_5599 < 0.0f), 0.0f, 1.0f);
                                                                        _5605 = _5582.w - _5387;
                                                                        _5607 = select((_5605 < 0.0f), 0.0f, 1.0f);
                                                                        _5608 = ((((((((((((((_5432 + _5436) + _5442) + _5448) + _5483) + _5489) + _5495) + _5501) + _5536) + _5542) + _5548) + _5554) + _5589) + _5595) + _5601) + _5607;
                                                                        _5619 = (saturate(_5608 * 0.0625f) * 2.0f) + -1.0f;
                                                                        _5625 = float((int)(((int)(uint)((int)(_5619 > 0.0f))) - ((int)(uint)((int)(_5619 < 0.0f)))));
                                                                        _5627 = 1.0f - (_5625 * _5619);
                                                                        _5629 = (_5627 * _5627) * _5627;
                                                                        _5637 = -0.0f - _4011;
                                                                        _5644 = saturate((saturate(rsqrt(dot(float3(_5637, _4003, _4000), float3(_5637, _4003, _4000))) * _4000) * _3896) + _3895);
                                                                        _5646 = 1.0f - (_5644 * _5644);
                                                                        _5650 = (0.5f - ((_5625 * 0.5f) * ((1.0f - _5629) - ((_5627 - _5629) * saturate(((1.0f / _5387) * (1.0f / _5608)) * ((((((((((((((((_5432 * _5430) + (_5436 * _5434)) + (_5442 * _5440)) + (_5448 * _5446)) + (_5483 * _5481)) + (_5489 * _5487)) + (_5495 * _5493)) + (_5501 * _5499)) + (_5536 * _5534)) + (_5542 * _5540)) + (_5548 * _5546)) + (_5554 * _5552)) + (_5589 * _5587)) + (_5595 * _5593)) + (_5601 * _5599)) + (_5607 * _5605)))))));
                                                                        _5651 = (1.0f - (_5646 * _5646));
                                                                        _5652 = false;
                                                                      } else {
                                                                        _5650 = 1.0f;
                                                                        _5651 = 1.0f;
                                                                        _5652 = true;
                                                                      }
                                                                    } else {
                                                                      _5650 = 1.0f;
                                                                      _5651 = 1.0f;
                                                                      _5652 = true;
                                                                    }
                                                                  }
                                                                }
                                                                do {
                                                                  if (_4859 == 0) {
                                                                    if (!(_5652)) {
                                                                      _5667 = _4856;
                                                                      _5668 = ((_5651 * (_5650 + -1.0f)) + 1.0f);
                                                                      _5669 = 0.0f;
                                                                    } else {
                                                                      _5667 = _4856;
                                                                      _5668 = _5650;
                                                                      _5669 = 0.0f;
                                                                    }
                                                                  } else {
                                                                    if (_5652) {
                                                                      _5667 = ((_4858 * (_4856 + -1.0f)) + 1.0f);
                                                                      _5668 = _5650;
                                                                      _5669 = 1.0f;
                                                                    } else {
                                                                      _5667 = _4856;
                                                                      _5668 = _5650;
                                                                      _5669 = (_4858 * _3899);
                                                                    }
                                                                  }
                                                                  _5672 = (_5669 * (_5667 - _5668)) + _5668;
                                                                  do {
                                                                    _5850 = _5672;
                                                                    [branch]
                                                                    if (!((_1628 & 2048) == 0)) {
                                                                      _5675 = _238 - _3816;
                                                                      _5676 = _239 - _3817;
                                                                      _5677 = _240 - _3818;
                                                                      _5692 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5677, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5676, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5675)));
                                                                      _5695 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _5677, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _5676, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _5675)));
                                                                      _5698 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _5677, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _5676, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _5675)));
                                                                      _5700 = rsqrt(dot(float3(_5692, _5695, _5698), float3(_5692, _5695, _5698)));
                                                                      _5701 = _5700 * _5692;
                                                                      _5702 = _5700 * _5695;
                                                                      _5703 = _5700 * _5698;
                                                                      Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3850) >> 16))];
                                                                      _5711 = (abs(_5702) + abs(_5701)) + abs(_5703);
                                                                      _5712 = _5701 / _5711;
                                                                      _5713 = _5702 / _5711;
                                                                      _5715 = !((_5703 / _5711) >= 0.0f);
                                                                      do {
                                                                        _5728 = _5712;
                                                                        _5729 = _5713;
                                                                        if (_5715) {
                                                                          _5728 = ((1.0f - abs(_5713)) * select((_5712 >= 0.0f), 1.0f, -1.0f));
                                                                          _5729 = ((1.0f - abs(_5712)) * select((_5713 >= 0.0f), 1.0f, -1.0f));
                                                                        }
                                                                        _5735 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5728 * 0.5f) + 0.5f), ((_5729 * 0.5f) + 0.5f)), 0.0f);
                                                                        if (_5735.x > 0.0f) {
                                                                          Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3850 & 65535))];
                                                                          do {
                                                                            _5754 = _5712;
                                                                            _5755 = _5713;
                                                                            if (_5715) {
                                                                              _5754 = ((1.0f - abs(_5713)) * select((_5712 >= 0.0f), 1.0f, -1.0f));
                                                                              _5755 = ((1.0f - abs(_5712)) * select((_5713 >= 0.0f), 1.0f, -1.0f));
                                                                            }
                                                                            _5760 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5754 * 0.5f) + 0.5f), ((_5755 * 0.5f) + 0.5f)), 0.0f);
                                                                            _5780 = mad(saturate(((log2(sqrt(((_5675 * _5675) + (_5676 * _5676)) + (_5677 * _5677))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                            _5781 = max(9.999999747378752e-06f, _5735.x);
                                                                            _5782 = _5760.x / _5781;
                                                                            _5783 = _5760.y / _5781;
                                                                            _5785 = _5760.w / _5781;
                                                                            _5790 = ((0.375f - _5783) * 4.999999873689376e-06f) + _5783;
                                                                            _5793 = -0.0f - _5782;
                                                                            _5794 = mad(_5793, _5790, (_5760.z / _5781));
                                                                            _5796 = 1.0f / mad(_5793, _5782, _5790);
                                                                            _5797 = _5796 * _5794;
                                                                            _5802 = _5780 - _5782;
                                                                            _5807 = (((_5780 * _5780) - _5790) - (_5797 * _5802)) / mad((-0.0f - _5794), _5797, mad((-0.0f - _5790), _5790, (((0.375f - _5785) * 4.999999873689376e-06f) + _5785)));
                                                                            _5809 = (_5796 * _5802) - (_5807 * _5797);
                                                                            _5812 = 1.0f / _5807;
                                                                            _5813 = _5809 * _5812;
                                                                            _5818 = sqrt(((_5813 * _5813) * 0.25f) - ((1.0f - dot(float2(_5809, _5807), float2(_5782, _5790))) * _5812));
                                                                            _5820 = (_5813 * -0.5f) - _5818;
                                                                            _5822 = _5818 - (_5813 * 0.5f);
                                                                            _5824 = select((_5820 < _5780), 1.0f, 0.0f);
                                                                            _5829 = (_5824 + -0.05000000074505806f) / (_5820 - _5780);
                                                                            _5835 = (((select((_5822 < _5780), 1.0f, 0.0f) - _5824) / (_5822 - _5820)) - _5829) / (_5822 - _5780);
                                                                            _5837 = _5829 - (_5835 * _5820);
                                                                            _5850 = (exp2((_5735.x * -1.4426950216293335f) * saturate((dot(float2(_5782, _5790), float2((_5837 - (_5835 * _5780)), _5835)) + 0.05000000074505806f) - (_5837 * _5780))) * _5672);
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } else {
                                                                          _5850 = _5672;
                                                                        }
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    }
                                                                    _5853 = (_5850 * _3974);
                                                                    _5854 = _4860;
                                                                    _5855 = (_4858 * _4857);
                                                                    _5856 = _5850;
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
                                                            _5876 = _3876;
                                                            _5877 = _3877;
                                                            _5878 = _3879;
                                                            [branch]
                                                            if (!(_3901 == 0)) {
                                                              TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3901)))];
                                                              _5868 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3953, _3811, mad(_3952, _3806, (_3951 * _3801)))), (-0.0f - mad(_3953, _3812, mad(_3952, _3807, (_3951 * _3802)))), (-0.0f - mad(_3953, _3813, mad(_3952, _3808, (_3951 * _3803))))), 0.0f);
                                                              _5876 = (_5868.x * _3876);
                                                              _5877 = (_5868.y * _3877);
                                                              _5878 = (_5868.z * _3879);
                                                            }
                                                            [branch]
                                                            if (!(_5853 == 0.0f)) {
                                                              do {
                                                                _5896 = GetDeferredSoftShadowChannel(_1631);
                                                                if (_5896 < 0) {
                                                                      _5917 = _5853;
                                                                      do {
                                                                        _8856 = _1616;
                                                                        _8857 = _1617;
                                                                        _8858 = _1618;
                                                                        _8859 = _1619;
                                                                        _8860 = _1620;
                                                                        _8861 = _1621;
                                                                        [branch]
                                                                        if (!(_5917 == 0.0f)) {
                                                                          do {
                                                                            _6037 = _5876;
                                                                            _6038 = _5877;
                                                                            _6039 = _5878;
                                                                            _6040 = 0.0f;
                                                                            _6041 = 0.0f;
                                                                            _6042 = 0.0f;
                                                                            [branch]
                                                                            if (_4005) {
                                                                              do {
                                                                                _5932 = 0.0f;
                                                                                _5933 = 0.0f;
                                                                                _5934 = 0.0f;
                                                                                if (!(_242)) {
                                                                                  _5927 = ((_5854 * _3974) * _5855) * saturate(0.30000001192092896f - dot(float3(_3957, _3958, _3959), float3(_195, _196, _197)));
                                                                                  _5932 = (_5927 * _1300);
                                                                                  _5933 = (_5927 * _1301);
                                                                                  _5934 = (_5927 * _1302);
                                                                                }
                                                                                [branch]
                                                                                if (!((_3853 & 1) == 0)) {
                                                                                  _5947 = max(max(_5876, _5877), _5878);
                                                                                  do {
                                                                                    _5957 = _5876;
                                                                                    _5958 = _5877;
                                                                                    _5959 = _5878;
                                                                                    if (_5947 > 0.0f) {
                                                                                      _5957 = saturate(_5876 / _5947);
                                                                                      _5958 = saturate(_5877 / _5947);
                                                                                      _5959 = saturate(_5878 / _5947);
                                                                                    }
                                                                                    _5960 = (_5958 < _5959);
                                                                                    _5961 = select(_5960, _5959, _5958);
                                                                                    _5962 = select(_5960, _5958, _5959);
                                                                                    _5963 = select(_5960, -1.0f, 0.0f);
                                                                                    _5964 = (_5957 < _5961);
                                                                                    _5966 = select(_5964, _5961, _5957);
                                                                                    _5967 = select(_5964, _5957, _5961);
                                                                                    _5971 = _5966 - select((_5967 < _5962), _5967, _5962);
                                                                                    _5977 = abs(select(_5964, (-0.3333333432674408f - _5963), _5963) + ((_5967 - _5962) / ((_5971 * 6.0f) + 9.999999682655225e-21f)));
                                                                                    do {
                                                                                      _5990 = _5977;
                                                                                      if (_5977 < 0.6666666865348816f) {
                                                                                        _5990 = ((saturate(((float)((uint)((uint)(((uint)(_3853) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5977 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5977)) + _5977);
                                                                                      }
                                                                                      _5991 = saturate((_5971 / (_5966 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3853) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                      _5992 = saturate(_5966);
                                                                                      do {
                                                                                        _6019 = _5992;
                                                                                        _6020 = _5992;
                                                                                        _6021 = _5992;
                                                                                        if (!(_5991 <= 0.0f)) {
                                                                                          _5995 = saturate(_5990);
                                                                                          _5999 = select(((_5995 * 360.0f) >= 360.0f), 0.0f, (_5995 * 6.0f));
                                                                                          _6000 = int(_5999);
                                                                                          _6002 = _5999 - float((int)(_6000));
                                                                                          _6004 = _5992 * (1.0f - _5991);
                                                                                          _6007 = (1.0f - (_6002 * _5991)) * _5992;
                                                                                          _6011 = (1.0f - ((1.0f - _6002) * _5991)) * _5992;
                                                                                          switch (_6000) {
                                                                                            case 0: {
                                                                                              _6019 = _5992;
                                                                                              _6020 = _6011;
                                                                                              _6021 = _6004;
                                                                                              break;
                                                                                            }
                                                                                            case 1: {
                                                                                              _6019 = _6007;
                                                                                              _6020 = _5992;
                                                                                              _6021 = _6004;
                                                                                              break;
                                                                                            }
                                                                                            case 2: {
                                                                                              _6019 = _6004;
                                                                                              _6020 = _5992;
                                                                                              _6021 = _6011;
                                                                                              break;
                                                                                            }
                                                                                            case 3: {
                                                                                              _6019 = _6004;
                                                                                              _6020 = _6007;
                                                                                              _6021 = _5992;
                                                                                              break;
                                                                                            }
                                                                                            case 4: {
                                                                                              _6019 = _6011;
                                                                                              _6020 = _6004;
                                                                                              _6021 = _5992;
                                                                                              break;
                                                                                            }
                                                                                            case 5: {
                                                                                              _6019 = _5992;
                                                                                              _6020 = _6004;
                                                                                              _6021 = _6007;
                                                                                              break;
                                                                                            }
                                                                                            default: {
                                                                                              _6019 = 0.0f;
                                                                                              _6020 = 0.0f;
                                                                                              _6021 = 0.0f;
                                                                                              break;
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                        _6022 = _6019 * _5947;
                                                                                        _6023 = _6020 * _5947;
                                                                                        _6024 = _6021 * _5947;
                                                                                        _6026 = saturate(_5856 * 1.0101009607315063f);
                                                                                        _6037 = ((_6026 * (_5876 - _6022)) + _6022);
                                                                                        _6038 = ((_6026 * (_5877 - _6023)) + _6023);
                                                                                        _6039 = (lerp(_6024, _5878, _6026));
                                                                                        _6040 = _5932;
                                                                                        _6041 = _5933;
                                                                                        _6042 = _5934;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } else {
                                                                                  _6037 = _5876;
                                                                                  _6038 = _5877;
                                                                                  _6039 = _5878;
                                                                                  _6040 = _5932;
                                                                                  _6041 = _5933;
                                                                                  _6042 = _5934;
                                                                                }
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            }
                                                                            do {
                                                                              _6078 = _5917;
                                                                              [branch]
                                                                              if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                _6049 = srvLightMappingData[_1631];
                                                                                if (!(_6049 == -1)) {
                                                                                  _6054 = srvLightIndexData[_6049].nLayerIndex;
                                                                                  _6056 = srvLightIndexData[_6049].vAtlasOrigin.x;
                                                                                  _6057 = srvLightIndexData[_6049].vAtlasOrigin.y;
                                                                                  _6059 = srvLightIndexData[_6049].vScreenOrigin.x;
                                                                                  _6060 = srvLightIndexData[_6049].vScreenOrigin.y;
                                                                                  _6069 = ((int)(_6054 * 5)) & 31;
                                                                                  _6078 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6056 + _65) - _6059)), ((int)((_6057 + _66) - _6060)), 0)))).x) & ((int)(31 << _6069)))) >> _6069)) >> 1)))) * 0.06666667014360428f) * _5917);
                                                                                } else {
                                                                                  _6078 = _5917;
                                                                                }
                                                                              }
                                                                              _6082 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                              _6085 = select(_6082, (_6078 * _1288), _6078);
                                                                              _6087 = _3957 * _3956;
                                                                              _6088 = _3958 * _3956;
                                                                              _6089 = _3959 * _3956;
                                                                              _6090 = _3887 * _3821;
                                                                              _6091 = _3887 * _3822;
                                                                              _6092 = _3887 * _3823;
                                                                              _6093 = _6087 + _6090;
                                                                              _6094 = _6088 + _6091;
                                                                              _6095 = _6089 + _6092;
                                                                              _6096 = _6087 - _6090;
                                                                              _6097 = _6088 - _6091;
                                                                              _6098 = _6089 - _6092;
                                                                              _6099 = (_3887 > 0.0f);
                                                                              _6100 = dot(float3(_6093, _6094, _6095), float3(_6093, _6094, _6095));
                                                                              _6101 = rsqrt(_6100);
                                                                              do {
                                                                                [branch]
                                                                                if (_6099) {
                                                                                  _6104 = rsqrt(dot(float3(_6096, _6097, _6098), float3(_6096, _6097, _6098)));
                                                                                  _6105 = _6104 * _6101;
                                                                                  _6107 = dot(float3(_6093, _6094, _6095), float3(_6096, _6097, _6098)) * _6105;
                                                                                  _6126 = (_6105 / ((_6105 + 0.5f) + (_6107 * 0.5f)));
                                                                                  _6127 = (((dot(float3(_195, _196, _197), float3(_6096, _6097, _6098)) * _6104) + (dot(float3(_195, _196, _197), float3(_6093, _6094, _6095)) * _6101)) * 0.5f);
                                                                                  _6128 = _6107;
                                                                                } else {
                                                                                  _6126 = (1.0f / (_6100 + 1.0f));
                                                                                  _6127 = dot(float3(_195, _196, _197), float3((_6101 * _6093), (_6101 * _6094), (_6101 * _6095)));
                                                                                  _6128 = 1.0f;
                                                                                }
                                                                                do {
                                                                                  _6144 = _6127;
                                                                                  if (_3889 > 0.0f) {
                                                                                    _6134 = sqrt(saturate((_3889 * _3889) * _6126));
                                                                                    if (_6127 < _6134) {
                                                                                      _6139 = max(_6127, (-0.0f - _6134)) + _6134;
                                                                                      _6144 = ((_6139 * _6139) / (_6134 * 4.0f));
                                                                                    } else {
                                                                                      _6144 = _6127;
                                                                                    }
                                                                                  }
                                                                                  do {
                                                                                    _6204 = _6093;
                                                                                    _6205 = _6094;
                                                                                    _6206 = _6095;
                                                                                    if (_6099) {
                                                                                      _6146 = -0.0f - _459;
                                                                                      _6147 = -0.0f - _460;
                                                                                      _6148 = -0.0f - _458;
                                                                                      _6150 = dot(float3(_6146, _6147, _6148), float3(_195, _196, _197)) * 2.0f;
                                                                                      _6154 = _6146 - (_6150 * _195);
                                                                                      _6155 = _6147 - (_6150 * _196);
                                                                                      _6156 = _6148 - (_6150 * _197);
                                                                                      _6157 = _6096 - _6093;
                                                                                      _6158 = _6097 - _6094;
                                                                                      _6159 = _6098 - _6095;
                                                                                      _6160 = dot(float3(_6154, _6155, _6156), float3(_6157, _6158, _6159));
                                                                                      _6166 = sqrt(((_6157 * _6157) + (_6158 * _6158)) + (_6159 * _6159));
                                                                                      _6175 = saturate(((dot(float3(_6154, _6155, _6156), float3(_6093, _6094, _6095)) * _6160) - dot(float3(_6093, _6094, _6095), float3(_6157, _6158, _6159))) / ((_6166 * _6166) - (_6160 * _6160)));
                                                                                      _6179 = (_6175 * _6157) + _6093;
                                                                                      _6180 = (_6175 * _6158) + _6094;
                                                                                      _6181 = (_6175 * _6159) + _6095;
                                                                                      _6182 = dot(float3(_6179, _6180, _6181), float3(_6154, _6155, _6156));
                                                                                      _6186 = (_6182 * _6154) - _6179;
                                                                                      _6187 = (_6182 * _6155) - _6180;
                                                                                      _6188 = (_6182 * _6156) - _6181;
                                                                                      _6196 = saturate(0.009999999776482582f / sqrt(((_6186 * _6186) + (_6187 * _6187)) + (_6188 * _6188)));
                                                                                      _6204 = ((_6196 * _6186) + _6179);
                                                                                      _6205 = ((_6196 * _6187) + _6180);
                                                                                      _6206 = ((_6196 * _6188) + _6181);
                                                                                    }
                                                                                    _6208 = rsqrt(dot(float3(_6204, _6205, _6206), float3(_6204, _6205, _6206)));
                                                                                    _6209 = _6208 * _6204;
                                                                                    _6210 = _6208 * _6205;
                                                                                    _6211 = _6208 * _6206;
                                                                                    _6212 = _223 * _223;
                                                                                    _6216 = saturate((_3889 * (1.0f - _6212)) * _6208);
                                                                                    _6218 = saturate(_6208 * f16tof32(_3835));
                                                                                    _6220 = rsqrt(dot(float3(_6087, _6088, _6089), float3(_6087, _6088, _6089)));
                                                                                    _6224 = dot(float3(_195, _196, _197), float3(_6209, _6210, _6211));
                                                                                    _6225 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                                                    _6226 = dot(float3(_459, _460, _458), float3(_6209, _6210, _6211));
                                                                                    _6229 = rsqrt((_6226 * 2.0f) + 2.0f);
                                                                                    _6236 = (_6216 > 0.0f);
                                                                                    do {
                                                                                      _6327 = saturate((_6229 * _6226) + _6229);
                                                                                      _6328 = saturate(_6229 * (_6225 + _6224));
                                                                                      if (_6236) {
                                                                                        _6240 = sqrt(1.0f - (_6216 * _6216));
                                                                                        _6242 = (_6224 * 2.0f) * _6225;
                                                                                        _6243 = _6242 - _6226;
                                                                                        if (!(!(_6243 >= _6240))) {
                                                                                          _6327 = abs(_6225);
                                                                                          _6328 = 1.0f;
                                                                                        } else {
                                                                                          _6251 = rsqrt(1.0f - (_6243 * _6243)) * _6216;
                                                                                          _6254 = _6251 * (_6225 - (_6243 * _6224));
                                                                                          _6255 = _6225 * _6225;
                                                                                          _6260 = _6251 * (((_6255 * 2.0f) + -1.0f) - (_6243 * _6226));
                                                                                          _6269 = sqrt(saturate((((1.0f - (_6224 * _6224)) - _6255) - (_6226 * _6226)) + (_6242 * _6226)));
                                                                                          _6270 = _6269 * _6251;
                                                                                          _6273 = ((_6225 * 2.0f) * _6251) * _6269;
                                                                                          _6275 = (_6240 * _6224) + _6225;
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
                                                                                        }
                                                                                      }
                                                                                      _6329 = saturate(_6144);
                                                                                      _6331 = _6212 * _6212;
                                                                                      do {
                                                                                        _6341 = _6331;
                                                                                        if (_6218 > 0.0f) {
                                                                                          _6341 = saturate(((_6218 * _6218) / ((_6327 * 3.5999999046325684f) + 0.4000000059604645f)) + _6331);
                                                                                        }
                                                                                        do {
                                                                                          _6353 = _6341;
                                                                                          _6354 = 1.0f;
                                                                                          if (_6236) {
                                                                                            _6350 = (((_6216 * 0.25f) * ((sqrt(_6341) * 3.0f) + _6216)) / (_6327 + 0.0010000000474974513f)) + _6341;
                                                                                            _6353 = _6350;
                                                                                            _6354 = (_6341 / _6350);
                                                                                          }
                                                                                          do {
                                                                                            _6374 = _6354;
                                                                                            if (_6128 < 1.0f) {
                                                                                              _6361 = sqrt((1.000100016593933f - _6128) / max(9.999999974752427e-07f, (_6128 + 1.0f)));
                                                                                              _6374 = (sqrt(_6353 / ((((_6361 * 0.25f) * ((sqrt(_6353) * 3.0f) + _6361)) / (_6327 + 0.0010000000474974513f)) + _6353)) * _6354);
                                                                                            }
                                                                                            _6378 = (((_6341 * _6328) - _6328) * _6328) + 1.0f;
                                                                                            _6385 = exp2(log2(1.0f - saturate(_6327)) * 5.0f);
                                                                                            _6388 = saturate(abs(_6225) + 9.999999747378752e-06f);
                                                                                            _6389 = sqrt(_6341);
                                                                                            _6390 = 1.0f - _6389;
                                                                                            _6402 = saturate((dot(float3(_195, _196, _197), float3((_6220 * _6087), (_6220 * _6088), (_6220 * _6089))) + _3886) / (_3886 + 1.0f));
                                                                                            _6405 = ((_6374 * _6329) * (_6341 / (_6378 * _6378))) * (0.5f / ((((_6390 * _6388) + _6389) * _6329) + (((_6390 * _6329) + _6389) * _6388)));
                                                                                            _6406 = _6037 * _1679;
                                                                                            _6407 = _6038 * _1679;
                                                                                            _6408 = _6039 * _1679;
                                                                                            do {
                                                                                              _6447 = _1619;
                                                                                              _6448 = _1620;
                                                                                              _6449 = _1621;
                                                                                              if (_3883 > 0.0f) {
                                                                                                _6430 = (_3883 * _1375) * select(_6082, (_6078 * _1288), _6078);
                                                                                                _6447 = (((((_6406 * _1151) * _6430) * ((_6385 * (1.0f - _215)) + _215)) * _6405) + _1619);
                                                                                                _6448 = (((((_6407 * _1152) * _6430) * ((_6385 * (1.0f - _216)) + _216)) * _6405) + _1620);
                                                                                                _6449 = (((((_6408 * _1153) * _6430) * ((_6385 * (1.0f - _217)) + _217)) * _6405) + _1621);
                                                                                              }
                                                                                              _8856 = (((_6085 * _6406) * _6402) + _1616);
                                                                                              _8857 = (((_6085 * _6407) * _6402) + _1617);
                                                                                              _8858 = (((_6085 * _6408) * _6402) + _1618);
                                                                                              _8859 = (_6447 + (_6040 * _6406));
                                                                                              _8860 = (_6448 + (_6041 * _6407));
                                                                                              _8861 = (_6449 + (_6042 * _6408));
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
                                                                _5899 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                                                                do {
                                                                  if (_5896 == 0) {
                                                                    _5913 = _5899.x;
                                                                  } else {
                                                                    if (_5896 == 1) {
                                                                      _5913 = _5899.y;
                                                                    } else {
                                                                      if (_5896 == 2) {
                                                                        _5913 = _5899.z;
                                                                      } else {
                                                                        _5913 = _5899.w;
                                                                      }
                                                                    }
                                                                  }
                                                                  _5917 = ((_5913 * _5913) * _3974);
                                                                  [branch]
                                                                  if (!(_5917 == 0.0f)) {
                                                                    do {
                                                                      _6037 = _5876;
                                                                      _6038 = _5877;
                                                                      _6039 = _5878;
                                                                      _6040 = 0.0f;
                                                                      _6041 = 0.0f;
                                                                      _6042 = 0.0f;
                                                                      [branch]
                                                                      if (_4005) {
                                                                        do {
                                                                          _5932 = 0.0f;
                                                                          _5933 = 0.0f;
                                                                          _5934 = 0.0f;
                                                                          if (!(_242)) {
                                                                            _5927 = ((_5854 * _3974) * _5855) * saturate(0.30000001192092896f - dot(float3(_3957, _3958, _3959), float3(_195, _196, _197)));
                                                                            _5932 = (_5927 * _1300);
                                                                            _5933 = (_5927 * _1301);
                                                                            _5934 = (_5927 * _1302);
                                                                          }
                                                                          [branch]
                                                                          if (!((_3853 & 1) == 0)) {
                                                                            _5947 = max(max(_5876, _5877), _5878);
                                                                            do {
                                                                              _5957 = _5876;
                                                                              _5958 = _5877;
                                                                              _5959 = _5878;
                                                                              if (_5947 > 0.0f) {
                                                                                _5957 = saturate(_5876 / _5947);
                                                                                _5958 = saturate(_5877 / _5947);
                                                                                _5959 = saturate(_5878 / _5947);
                                                                              }
                                                                              _5960 = (_5958 < _5959);
                                                                              _5961 = select(_5960, _5959, _5958);
                                                                              _5962 = select(_5960, _5958, _5959);
                                                                              _5963 = select(_5960, -1.0f, 0.0f);
                                                                              _5964 = (_5957 < _5961);
                                                                              _5966 = select(_5964, _5961, _5957);
                                                                              _5967 = select(_5964, _5957, _5961);
                                                                              _5971 = _5966 - select((_5967 < _5962), _5967, _5962);
                                                                              _5977 = abs(select(_5964, (-0.3333333432674408f - _5963), _5963) + ((_5967 - _5962) / ((_5971 * 6.0f) + 9.999999682655225e-21f)));
                                                                              do {
                                                                                _5990 = _5977;
                                                                                if (_5977 < 0.6666666865348816f) {
                                                                                  _5990 = ((saturate(((float)((uint)((uint)(((uint)(_3853) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5977 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5977)) + _5977);
                                                                                }
                                                                                _5991 = saturate((_5971 / (_5966 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3853) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                _5992 = saturate(_5966);
                                                                                do {
                                                                                  _6019 = _5992;
                                                                                  _6020 = _5992;
                                                                                  _6021 = _5992;
                                                                                  if (!(_5991 <= 0.0f)) {
                                                                                    _5995 = saturate(_5990);
                                                                                    _5999 = select(((_5995 * 360.0f) >= 360.0f), 0.0f, (_5995 * 6.0f));
                                                                                    _6000 = int(_5999);
                                                                                    _6002 = _5999 - float((int)(_6000));
                                                                                    _6004 = _5992 * (1.0f - _5991);
                                                                                    _6007 = (1.0f - (_6002 * _5991)) * _5992;
                                                                                    _6011 = (1.0f - ((1.0f - _6002) * _5991)) * _5992;
                                                                                    switch (_6000) {
                                                                                      case 0: {
                                                                                        _6019 = _5992;
                                                                                        _6020 = _6011;
                                                                                        _6021 = _6004;
                                                                                        break;
                                                                                      }
                                                                                      case 1: {
                                                                                        _6019 = _6007;
                                                                                        _6020 = _5992;
                                                                                        _6021 = _6004;
                                                                                        break;
                                                                                      }
                                                                                      case 2: {
                                                                                        _6019 = _6004;
                                                                                        _6020 = _5992;
                                                                                        _6021 = _6011;
                                                                                        break;
                                                                                      }
                                                                                      case 3: {
                                                                                        _6019 = _6004;
                                                                                        _6020 = _6007;
                                                                                        _6021 = _5992;
                                                                                        break;
                                                                                      }
                                                                                      case 4: {
                                                                                        _6019 = _6011;
                                                                                        _6020 = _6004;
                                                                                        _6021 = _5992;
                                                                                        break;
                                                                                      }
                                                                                      case 5: {
                                                                                        _6019 = _5992;
                                                                                        _6020 = _6004;
                                                                                        _6021 = _6007;
                                                                                        break;
                                                                                      }
                                                                                      default: {
                                                                                        _6019 = 0.0f;
                                                                                        _6020 = 0.0f;
                                                                                        _6021 = 0.0f;
                                                                                        break;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  _6022 = _6019 * _5947;
                                                                                  _6023 = _6020 * _5947;
                                                                                  _6024 = _6021 * _5947;
                                                                                  _6026 = saturate(_5856 * 1.0101009607315063f);
                                                                                  _6037 = ((_6026 * (_5876 - _6022)) + _6022);
                                                                                  _6038 = ((_6026 * (_5877 - _6023)) + _6023);
                                                                                  _6039 = (lerp(_6024, _5878, _6026));
                                                                                  _6040 = _5932;
                                                                                  _6041 = _5933;
                                                                                  _6042 = _5934;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } else {
                                                                            _6037 = _5876;
                                                                            _6038 = _5877;
                                                                            _6039 = _5878;
                                                                            _6040 = _5932;
                                                                            _6041 = _5933;
                                                                            _6042 = _5934;
                                                                          }
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      do {
                                                                        _6078 = _5917;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _6049 = srvLightMappingData[_1631];
                                                                          if (!(_6049 == -1)) {
                                                                            _6054 = srvLightIndexData[_6049].nLayerIndex;
                                                                            _6056 = srvLightIndexData[_6049].vAtlasOrigin.x;
                                                                            _6057 = srvLightIndexData[_6049].vAtlasOrigin.y;
                                                                            _6059 = srvLightIndexData[_6049].vScreenOrigin.x;
                                                                            _6060 = srvLightIndexData[_6049].vScreenOrigin.y;
                                                                            _6069 = ((int)(_6054 * 5)) & 31;
                                                                            _6078 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6056 + _65) - _6059)), ((int)((_6057 + _66) - _6060)), 0)))).x) & ((int)(31 << _6069)))) >> _6069)) >> 1)))) * 0.06666667014360428f) * _5917);
                                                                          } else {
                                                                            _6078 = _5917;
                                                                          }
                                                                        }
                                                                        _6082 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _6085 = select(_6082, (_6078 * _1288), _6078);
                                                                        _6087 = _3957 * _3956;
                                                                        _6088 = _3958 * _3956;
                                                                        _6089 = _3959 * _3956;
                                                                        _6090 = _3887 * _3821;
                                                                        _6091 = _3887 * _3822;
                                                                        _6092 = _3887 * _3823;
                                                                        _6093 = _6087 + _6090;
                                                                        _6094 = _6088 + _6091;
                                                                        _6095 = _6089 + _6092;
                                                                        _6096 = _6087 - _6090;
                                                                        _6097 = _6088 - _6091;
                                                                        _6098 = _6089 - _6092;
                                                                        _6099 = (_3887 > 0.0f);
                                                                        _6100 = dot(float3(_6093, _6094, _6095), float3(_6093, _6094, _6095));
                                                                        _6101 = rsqrt(_6100);
                                                                        do {
                                                                          [branch]
                                                                          if (_6099) {
                                                                            _6104 = rsqrt(dot(float3(_6096, _6097, _6098), float3(_6096, _6097, _6098)));
                                                                            _6105 = _6104 * _6101;
                                                                            _6107 = dot(float3(_6093, _6094, _6095), float3(_6096, _6097, _6098)) * _6105;
                                                                            _6126 = (_6105 / ((_6105 + 0.5f) + (_6107 * 0.5f)));
                                                                            _6127 = (((dot(float3(_195, _196, _197), float3(_6096, _6097, _6098)) * _6104) + (dot(float3(_195, _196, _197), float3(_6093, _6094, _6095)) * _6101)) * 0.5f);
                                                                            _6128 = _6107;
                                                                          } else {
                                                                            _6126 = (1.0f / (_6100 + 1.0f));
                                                                            _6127 = dot(float3(_195, _196, _197), float3((_6101 * _6093), (_6101 * _6094), (_6101 * _6095)));
                                                                            _6128 = 1.0f;
                                                                          }
                                                                          do {
                                                                            _6144 = _6127;
                                                                            if (_3889 > 0.0f) {
                                                                              _6134 = sqrt(saturate((_3889 * _3889) * _6126));
                                                                              if (_6127 < _6134) {
                                                                                _6139 = max(_6127, (-0.0f - _6134)) + _6134;
                                                                                _6144 = ((_6139 * _6139) / (_6134 * 4.0f));
                                                                              } else {
                                                                                _6144 = _6127;
                                                                              }
                                                                            }
                                                                            do {
                                                                              _6204 = _6093;
                                                                              _6205 = _6094;
                                                                              _6206 = _6095;
                                                                              if (_6099) {
                                                                                _6146 = -0.0f - _459;
                                                                                _6147 = -0.0f - _460;
                                                                                _6148 = -0.0f - _458;
                                                                                _6150 = dot(float3(_6146, _6147, _6148), float3(_195, _196, _197)) * 2.0f;
                                                                                _6154 = _6146 - (_6150 * _195);
                                                                                _6155 = _6147 - (_6150 * _196);
                                                                                _6156 = _6148 - (_6150 * _197);
                                                                                _6157 = _6096 - _6093;
                                                                                _6158 = _6097 - _6094;
                                                                                _6159 = _6098 - _6095;
                                                                                _6160 = dot(float3(_6154, _6155, _6156), float3(_6157, _6158, _6159));
                                                                                _6166 = sqrt(((_6157 * _6157) + (_6158 * _6158)) + (_6159 * _6159));
                                                                                _6175 = saturate(((dot(float3(_6154, _6155, _6156), float3(_6093, _6094, _6095)) * _6160) - dot(float3(_6093, _6094, _6095), float3(_6157, _6158, _6159))) / ((_6166 * _6166) - (_6160 * _6160)));
                                                                                _6179 = (_6175 * _6157) + _6093;
                                                                                _6180 = (_6175 * _6158) + _6094;
                                                                                _6181 = (_6175 * _6159) + _6095;
                                                                                _6182 = dot(float3(_6179, _6180, _6181), float3(_6154, _6155, _6156));
                                                                                _6186 = (_6182 * _6154) - _6179;
                                                                                _6187 = (_6182 * _6155) - _6180;
                                                                                _6188 = (_6182 * _6156) - _6181;
                                                                                _6196 = saturate(0.009999999776482582f / sqrt(((_6186 * _6186) + (_6187 * _6187)) + (_6188 * _6188)));
                                                                                _6204 = ((_6196 * _6186) + _6179);
                                                                                _6205 = ((_6196 * _6187) + _6180);
                                                                                _6206 = ((_6196 * _6188) + _6181);
                                                                              }
                                                                              _6208 = rsqrt(dot(float3(_6204, _6205, _6206), float3(_6204, _6205, _6206)));
                                                                              _6209 = _6208 * _6204;
                                                                              _6210 = _6208 * _6205;
                                                                              _6211 = _6208 * _6206;
                                                                              _6212 = _223 * _223;
                                                                              _6216 = saturate((_3889 * (1.0f - _6212)) * _6208);
                                                                              _6218 = saturate(_6208 * f16tof32(_3835));
                                                                              _6220 = rsqrt(dot(float3(_6087, _6088, _6089), float3(_6087, _6088, _6089)));
                                                                              _6224 = dot(float3(_195, _196, _197), float3(_6209, _6210, _6211));
                                                                              _6225 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                                              _6226 = dot(float3(_459, _460, _458), float3(_6209, _6210, _6211));
                                                                              _6229 = rsqrt((_6226 * 2.0f) + 2.0f);
                                                                              _6236 = (_6216 > 0.0f);
                                                                              do {
                                                                                _6327 = saturate((_6229 * _6226) + _6229);
                                                                                _6328 = saturate(_6229 * (_6225 + _6224));
                                                                                if (_6236) {
                                                                                  _6240 = sqrt(1.0f - (_6216 * _6216));
                                                                                  _6242 = (_6224 * 2.0f) * _6225;
                                                                                  _6243 = _6242 - _6226;
                                                                                  if (!(!(_6243 >= _6240))) {
                                                                                    _6327 = abs(_6225);
                                                                                    _6328 = 1.0f;
                                                                                  } else {
                                                                                    _6251 = rsqrt(1.0f - (_6243 * _6243)) * _6216;
                                                                                    _6254 = _6251 * (_6225 - (_6243 * _6224));
                                                                                    _6255 = _6225 * _6225;
                                                                                    _6260 = _6251 * (((_6255 * 2.0f) + -1.0f) - (_6243 * _6226));
                                                                                    _6269 = sqrt(saturate((((1.0f - (_6224 * _6224)) - _6255) - (_6226 * _6226)) + (_6242 * _6226)));
                                                                                    _6270 = _6269 * _6251;
                                                                                    _6273 = ((_6225 * 2.0f) * _6251) * _6269;
                                                                                    _6275 = (_6240 * _6224) + _6225;
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
                                                                                  }
                                                                                }
                                                                                _6329 = saturate(_6144);
                                                                                _6331 = _6212 * _6212;
                                                                                do {
                                                                                  _6341 = _6331;
                                                                                  if (_6218 > 0.0f) {
                                                                                    _6341 = saturate(((_6218 * _6218) / ((_6327 * 3.5999999046325684f) + 0.4000000059604645f)) + _6331);
                                                                                  }
                                                                                  do {
                                                                                    _6353 = _6341;
                                                                                    _6354 = 1.0f;
                                                                                    if (_6236) {
                                                                                      _6350 = (((_6216 * 0.25f) * ((sqrt(_6341) * 3.0f) + _6216)) / (_6327 + 0.0010000000474974513f)) + _6341;
                                                                                      _6353 = _6350;
                                                                                      _6354 = (_6341 / _6350);
                                                                                    }
                                                                                    do {
                                                                                      _6374 = _6354;
                                                                                      if (_6128 < 1.0f) {
                                                                                        _6361 = sqrt((1.000100016593933f - _6128) / max(9.999999974752427e-07f, (_6128 + 1.0f)));
                                                                                        _6374 = (sqrt(_6353 / ((((_6361 * 0.25f) * ((sqrt(_6353) * 3.0f) + _6361)) / (_6327 + 0.0010000000474974513f)) + _6353)) * _6354);
                                                                                      }
                                                                                      _6378 = (((_6341 * _6328) - _6328) * _6328) + 1.0f;
                                                                                      _6385 = exp2(log2(1.0f - saturate(_6327)) * 5.0f);
                                                                                      _6388 = saturate(abs(_6225) + 9.999999747378752e-06f);
                                                                                      _6389 = sqrt(_6341);
                                                                                      _6390 = 1.0f - _6389;
                                                                                      _6402 = saturate((dot(float3(_195, _196, _197), float3((_6220 * _6087), (_6220 * _6088), (_6220 * _6089))) + _3886) / (_3886 + 1.0f));
                                                                                      _6405 = ((_6374 * _6329) * (_6341 / (_6378 * _6378))) * (0.5f / ((((_6390 * _6388) + _6389) * _6329) + (((_6390 * _6329) + _6389) * _6388)));
                                                                                      _6406 = _6037 * _1679;
                                                                                      _6407 = _6038 * _1679;
                                                                                      _6408 = _6039 * _1679;
                                                                                      do {
                                                                                        _6447 = _1619;
                                                                                        _6448 = _1620;
                                                                                        _6449 = _1621;
                                                                                        if (_3883 > 0.0f) {
                                                                                          _6430 = (_3883 * _1375) * select(_6082, (_6078 * _1288), _6078);
                                                                                          _6447 = (((((_6406 * _1151) * _6430) * ((_6385 * (1.0f - _215)) + _215)) * _6405) + _1619);
                                                                                          _6448 = (((((_6407 * _1152) * _6430) * ((_6385 * (1.0f - _216)) + _216)) * _6405) + _1620);
                                                                                          _6449 = (((((_6408 * _1153) * _6430) * ((_6385 * (1.0f - _217)) + _217)) * _6405) + _1621);
                                                                                        }
                                                                                        _8856 = (((_6085 * _6406) * _6402) + _1616);
                                                                                        _8857 = (((_6085 * _6407) * _6402) + _1617);
                                                                                        _8858 = (((_6085 * _6408) * _6402) + _1618);
                                                                                        _8859 = (_6447 + (_6040 * _6406));
                                                                                        _8860 = (_6448 + (_6041 * _6407));
                                                                                        _8861 = (_6449 + (_6042 * _6408));
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
                                                                    _8856 = _1616;
                                                                    _8857 = _1617;
                                                                    _8858 = _1618;
                                                                    _8859 = _1619;
                                                                    _8860 = _1620;
                                                                    _8861 = _1621;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } else {
                                                              _8856 = _1616;
                                                              _8857 = _1617;
                                                              _8858 = _1618;
                                                              _8859 = _1619;
                                                              _8860 = _1620;
                                                              _8861 = _1621;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } else {
                                                      if (_1662 == 8) {
                                                        _6461 = asfloat(srvLightInfoProperties.Load3(_1630)).x;
                                                        _6462 = asfloat(srvLightInfoProperties.Load3(_1630)).y;
                                                        _6463 = asfloat(srvLightInfoProperties.Load3(_1630)).z;
                                                        _6466 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 12u)))).x;
                                                        _6467 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 12u)))).y;
                                                        _6468 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 12u)))).z;
                                                        _6471 = asfloat(srvLightInfoProperties.Load(((int)(_1630 + 24u))));
                                                        _6474 = asint(srvLightInfoProperties.Load(((int)(_1630 + 28u))));
                                                        _6477 = asint(srvLightInfoProperties.Load(((int)(_1630 + 32u))));
                                                        _6480 = asint(srvLightInfoProperties.Load(((int)(_1630 + 44u))));
                                                        _6489 = ((float)((uint)((uint)(((uint)(_6477) >> 8) & 255)))) * 0.003921499941498041f;
                                                        _6492 = ((float)((uint)((uint)(_6477 & 255)))) * 0.003921499941498041f;
                                                        _6495 = f16tof32(_6480);
                                                        _6502 = min(max(dot(float3((_238 - _6461), (_239 - _6462), (_240 - _6463)), float3(_6466, _6467, _6468)), (-0.0f - _6471)), _6471);
                                                        _6507 = (_6461 - _238) + (_6502 * _6466);
                                                        _6509 = (_6462 - _239) + (_6502 * _6467);
                                                        _6511 = (_6463 + _237) + (_6502 * _6468);
                                                        _6512 = dot(float3(_6507, _6509, _6511), float3(_6507, _6509, _6511));
                                                        _6513 = rsqrt(_6512);
                                                        _6515 = _6507 * _6513;
                                                        _6516 = _6509 * _6513;
                                                        _6517 = _6511 * _6513;
                                                        _6520 = max(0.0f, ((_6513 * _6512) - abs(_6495)));
                                                        _6521 = _6520 * f16tof32(((uint)((uint)(_6480) >> 16)));
                                                        _6522 = _6521 * _6521;
                                                        _6525 = saturate(1.0f - (_6522 * _6522));
                                                        _6532 = (_6525 * _6525) / (select((_6495 < 0.0f), (_6522 * 16.0f), (_6520 * _6520)) + 1.0f);
                                                        [branch]
                                                        if (!(_6532 == 0.0f)) {
                                                          do {
                                                            _6570 = _6532;
                                                            [branch]
                                                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                              _6541 = srvLightMappingData[_1631];
                                                              if (!(_6541 == -1)) {
                                                                _6546 = srvLightIndexData[_6541].nLayerIndex;
                                                                _6548 = srvLightIndexData[_6541].vAtlasOrigin.x;
                                                                _6549 = srvLightIndexData[_6541].vAtlasOrigin.y;
                                                                _6551 = srvLightIndexData[_6541].vScreenOrigin.x;
                                                                _6552 = srvLightIndexData[_6541].vScreenOrigin.y;
                                                                _6561 = ((int)(_6546 * 5)) & 31;
                                                                _6570 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6548 + _65) - _6551)), ((int)((_6549 + _66) - _6552)), 0)))).x) & ((int)(31 << _6561)))) >> _6561)) >> 1)))) * 0.06666667014360428f) * _6532);
                                                              } else {
                                                                _6570 = _6532;
                                                              }
                                                            }
                                                            _6574 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                            _6576 = select(_6574, (_6570 * _1288), _6570);
                                                            _6577 = dot(float3(_195, _196, _197), float3(_6515, _6516, _6517));
                                                            _6578 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                            _6579 = dot(float3(_459, _460, _458), float3(_6515, _6516, _6517));
                                                            _6582 = rsqrt((_6579 * 2.0f) + 2.0f);
                                                            _6585 = saturate(_6582 * (_6578 + _6577));
                                                            _6589 = saturate(_6577);
                                                            _6590 = _223 * _223;
                                                            _6591 = _6590 * _6590;
                                                            _6595 = (((_6585 * _6591) - _6585) * _6585) + 1.0f;
                                                            _6602 = exp2(log2(1.0f - saturate(saturate((_6582 * _6579) + _6582))) * 5.0f);
                                                            _6605 = saturate(abs(_6578) + 9.999999747378752e-06f);
                                                            _6606 = sqrt(_6591);
                                                            _6607 = 1.0f - _6606;
                                                            _6619 = saturate((_6577 + _6492) / (_6492 + 1.0f));
                                                            _6621 = ((_6591 / (_6595 * _6595)) * _6589) * (0.5f / ((((_6607 * _6605) + _6606) * _6589) + (((_6607 * _6589) + _6606) * _6605)));
                                                            _6622 = f16tof32(((uint)((uint)(_6474) >> 16))) * _1679;
                                                            _6623 = f16tof32(_6474) * _1679;
                                                            _6624 = f16tof32(((uint)((uint)(_6477) >> 16))) * _1679;
                                                            _6631 = ((_6576 * _6622) * _6619) + _1616;
                                                            _6632 = ((_6576 * _6623) * _6619) + _1617;
                                                            _6633 = ((_6576 * _6624) * _6619) + _1618;
                                                            if (_6489 > 0.0f) {
                                                              _6648 = (_6489 * _1375) * select(_6574, (_6570 * _1288), _6570);
                                                              _8856 = _6631;
                                                              _8857 = _6632;
                                                              _8858 = _6633;
                                                              _8859 = (((((_6622 * _1151) * _6648) * ((_6602 * (1.0f - _215)) + _215)) * _6621) + _1619);
                                                              _8860 = (((((_6623 * _1152) * _6648) * ((_6602 * (1.0f - _216)) + _216)) * _6621) + _1620);
                                                              _8861 = (((((_6624 * _1153) * _6648) * ((_6602 * (1.0f - _217)) + _217)) * _6621) + _1621);
                                                            } else {
                                                              _8856 = _6631;
                                                              _8857 = _6632;
                                                              _8858 = _6633;
                                                              _8859 = _1619;
                                                              _8860 = _1620;
                                                              _8861 = _1621;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _8856 = _1616;
                                                          _8857 = _1617;
                                                          _8858 = _1618;
                                                          _8859 = _1619;
                                                          _8860 = _1620;
                                                          _8861 = _1621;
                                                        }
                                                      } else {
                                                        if (_1662 == 9) {
                                                          _6669 = asfloat(srvLightInfoProperties.Load4(_1630)).x;
                                                          _6670 = asfloat(srvLightInfoProperties.Load4(_1630)).y;
                                                          _6671 = asfloat(srvLightInfoProperties.Load4(_1630)).w;
                                                          _6674 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).x;
                                                          _6675 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).y;
                                                          _6676 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).w;
                                                          _6679 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).x;
                                                          _6680 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).y;
                                                          _6681 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).w;
                                                          _6684 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 48u)))).x;
                                                          _6685 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 48u)))).y;
                                                          _6686 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 48u)))).w;
                                                          _6689 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 64u)))).x;
                                                          _6690 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 64u)))).y;
                                                          _6691 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 64u)))).z;
                                                          _6694 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 76u)))).x;
                                                          _6695 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 76u)))).y;
                                                          _6696 = asfloat(srvLightInfoProperties.Load3(((int)(_1630 + 76u)))).z;
                                                          _6699 = asint(srvLightInfoProperties.Load(((int)(_1630 + 88u))));
                                                          _6702 = asint(srvLightInfoProperties.Load(((int)(_1630 + 92u))));
                                                          _6705 = asint(srvLightInfoProperties.Load(((int)(_1630 + 100u))));
                                                          _6708 = asint(srvLightInfoProperties.Load(((int)(_1630 + 104u))));
                                                          _6711 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).x;
                                                          _6712 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).y;
                                                          _6713 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).z;
                                                          _6714 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 108u)))).w;
                                                          _6717 = asint(srvLightInfoProperties.Load(((int)(_1630 + 124u))));
                                                          _6720 = asint(srvLightInfoProperties.Load(((int)(_1630 + 128u))));
                                                          _6723 = asint(srvLightInfoProperties.Load(((int)(_1630 + 132u))));
                                                          _6726 = asint(srvLightInfoProperties.Load(((int)(_1630 + 136u))));
                                                          _6729 = asint(srvLightInfoProperties.Load(((int)(_1630 + 140u))));
                                                          _6732 = asint(srvLightInfoProperties.Load(((int)(_1630 + 144u))));
                                                          _6735 = asint(srvLightInfoProperties.Load(((int)(_1630 + 148u))));
                                                          _6738 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 152u)))).x;
                                                          _6739 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 152u)))).y;
                                                          _6740 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 152u)))).z;
                                                          _6741 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 152u)))).w;
                                                          _6744 = asint(srvLightInfoProperties.Load(((int)(_1630 + 168u))));
                                                          _6747 = asint(srvLightInfoProperties.Load(((int)(_1630 + 172u))));
                                                          _6750 = asint(srvLightInfoProperties.Load(((int)(_1630 + 180u))));
                                                          _6752 = f16tof32(((uint)((uint)(_6699) >> 16)));
                                                          _6753 = f16tof32(_6699);
                                                          _6755 = f16tof32(((uint)((uint)(_6702) >> 16)));
                                                          _6759 = ((float)((uint)((uint)(((uint)(_6702) >> 8) & 255)))) * 0.003921499941498041f;
                                                          _6762 = ((float)((uint)((uint)(_6702 & 255)))) * 0.003921499941498041f;
                                                          _6763 = f16tof32(_6705);
                                                          _6765 = f16tof32(((uint)((uint)(_6708) >> 16)));
                                                          _6769 = f16tof32(_6717);
                                                          _6773 = _6723 & 65535;
                                                          _6779 = ((_1628 & 3584) != 0);
                                                          _6790 = f16tof32(((uint)((uint)(_6747) >> 16)));
                                                          _6791 = f16tof32(_6747);
                                                          _6793 = f16tof32(((uint)((uint)(_6750) >> 16)));
                                                          _6794 = 1.0f / _6793;
                                                          _6795 = _6793 + -1.0f;
                                                          _6796 = f16tof32(_6750);
                                                          _6797 = _6689 - _238;
                                                          _6798 = _6690 - _239;
                                                          _6799 = _6691 + _237;
                                                          _6800 = dot(float3(_6797, _6798, _6799), float3(_6797, _6798, _6799));
                                                          _6801 = rsqrt(_6800);
                                                          _6802 = _6801 * _6800;
                                                          _6803 = _6801 * _6797;
                                                          _6804 = _6801 * _6798;
                                                          _6805 = _6801 * _6799;
                                                          _6808 = max(0.0f, (_6802 - abs(_6769)));
                                                          _6809 = _6808 * f16tof32(((uint)((uint)(_6717) >> 16)));
                                                          _6810 = _6809 * _6809;
                                                          _6813 = saturate(1.0f - (_6810 * _6810));
                                                          _6824 = mad(_240, _6681, mad(_239, _6676, (_6671 * _238))) + _6686;
                                                          _6828 = saturate(1.0f - dot(float3(_195, _196, _197), float3(_6803, _6804, _6805))) * f16tof32(_6744);
                                                          _6835 = ((_6824 * _195) * _6828) + _238;
                                                          _6836 = ((_6824 * _196) * _6828) + _239;
                                                          _6837 = ((_6824 * _197) * _6828) - _237;
                                                          _6849 = mad(_6837, _6681, mad(_6836, _6676, (_6835 * _6671))) + _6686;
                                                          _6850 = 1.0f / _6849;
                                                          _6851 = _6850 * (mad(_6837, _6679, mad(_6836, _6674, (_6835 * _6669))) + _6684);
                                                          _6852 = _6850 * (mad(_6837, _6680, mad(_6836, _6675, (_6835 * _6670))) + _6685);
                                                          _6855 = (_6851 * _6711) + _6712;
                                                          _6856 = (_6852 * _6711) + _6712;
                                                          _6859 = _6855 - saturate(_6855);
                                                          _6860 = _6856 - saturate(_6856);
                                                          _6867 = saturate((sqrt((_6859 * _6859) + (_6860 * _6860)) * _6713) + _6714);
                                                          _6869 = 1.0f - (_6867 * _6867);
                                                          _6875 = (_6869 * _6869) * (((float)((bool)(uint)((_6849 - f16tof32(((uint)((uint)(_6720) >> 16)))) > 0.0f))) * ((_6813 * _6813) / (select((_6769 < 0.0f), (_6810 * 16.0f), (_6808 * _6808)) + 1.0f)));
                                                          do {
                                                            _7770 = 0.0f;
                                                            _7771 = 1.0f;
                                                            _7772 = 0.0f;
                                                            if (!((!(_6875 > 0.0f)) || (!_6779))) {
                                                              _6885 = 1.0f - saturate(f16tof32(_6720) * _6849);
                                                              _6886 = saturate(_6851);
                                                              _6887 = saturate(_6852);
                                                              do {
                                                                _7200 = 1.0f;
                                                                _7201 = 1.0f;
                                                                _7202 = 0.0f;
                                                                _7203 = _6885;
                                                                [branch]
                                                                if (!((_1628 & 1024) == 0)) {
                                                                  _6892 = ((_6886 * _6795) + 0.5f) * _6794;
                                                                  _6894 = ((_6887 * _6795) + 0.5f) * _6794;
                                                                  _6895 = _6885 + f16tof32(((uint)((uint)(_6744) >> 16)));
                                                                  Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6723) >> 16))];
                                                                  _6898 = saturate(_6895);
                                                                  _6902 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _6911 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 6u);
                                                                  } else {
                                                                    _6911 = frac(frac(dot(float2(((_6902 * 32.665000915527344f) + _127), ((_6902 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _6911 = frac(frac(dot(float2(((_6902 * 32.665000915527344f) + _127), ((_6902 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _6912 = sin(_6911);
                                                                  _6913 = cos(_6911);
                                                                  _6914 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _6919 = sqrt((float((int)(_6914)) * 0.25f) + 0.125f) * _6790;
                                                                  _6928 = (_global_7[min((uint)(((int)(0u + (_6914 * 2)))), 127u)]) * _6919;
                                                                  _6929 = (_global_7[min((uint)(((int)(1u + (_6914 * 2)))), 127u)]) * _6919;
                                                                  _6931 = -0.0f - _6912;
                                                                  _6936 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6928, _6929), float2(_6913, _6912)) + _6892), (dot(float2(_6928, _6929), float2(_6931, _6913)) + _6894)));
                                                                  _6941 = _6936.x - _6898;
                                                                  _6943 = select((_6941 < 0.0f), 0.0f, 1.0f);
                                                                  _6945 = _6936.y - _6898;
                                                                  _6947 = select((_6945 < 0.0f), 0.0f, 1.0f);
                                                                  _6951 = _6936.z - _6898;
                                                                  _6953 = select((_6951 < 0.0f), 0.0f, 1.0f);
                                                                  _6957 = _6936.w - _6898;
                                                                  _6959 = select((_6957 < 0.0f), 0.0f, 1.0f);
                                                                  _6966 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                  _6971 = sqrt((float((int)(_6966)) * 0.25f) + 0.125f) * _6790;
                                                                  _6980 = (_global_7[min((uint)(((int)(0u + (_6966 * 2)))), 127u)]) * _6971;
                                                                  _6981 = (_global_7[min((uint)(((int)(1u + (_6966 * 2)))), 127u)]) * _6971;
                                                                  _6987 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6980, _6981), float2(_6913, _6912)) + _6892), (dot(float2(_6980, _6981), float2(_6931, _6913)) + _6894)));
                                                                  _6992 = _6987.x - _6898;
                                                                  _6994 = select((_6992 < 0.0f), 0.0f, 1.0f);
                                                                  _6998 = _6987.y - _6898;
                                                                  _7000 = select((_6998 < 0.0f), 0.0f, 1.0f);
                                                                  _7004 = _6987.z - _6898;
                                                                  _7006 = select((_7004 < 0.0f), 0.0f, 1.0f);
                                                                  _7010 = _6987.w - _6898;
                                                                  _7012 = select((_7010 < 0.0f), 0.0f, 1.0f);
                                                                  _7019 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                  _7024 = sqrt((float((int)(_7019)) * 0.25f) + 0.125f) * _6790;
                                                                  _7033 = (_global_7[min((uint)(((int)(0u + (_7019 * 2)))), 127u)]) * _7024;
                                                                  _7034 = (_global_7[min((uint)(((int)(1u + (_7019 * 2)))), 127u)]) * _7024;
                                                                  _7040 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7033, _7034), float2(_6913, _6912)) + _6892), (dot(float2(_7033, _7034), float2(_6931, _6913)) + _6894)));
                                                                  _7045 = _7040.x - _6898;
                                                                  _7047 = select((_7045 < 0.0f), 0.0f, 1.0f);
                                                                  _7051 = _7040.y - _6898;
                                                                  _7053 = select((_7051 < 0.0f), 0.0f, 1.0f);
                                                                  _7057 = _7040.z - _6898;
                                                                  _7059 = select((_7057 < 0.0f), 0.0f, 1.0f);
                                                                  _7063 = _7040.w - _6898;
                                                                  _7065 = select((_7063 < 0.0f), 0.0f, 1.0f);
                                                                  _7072 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                  _7077 = sqrt((float((int)(_7072)) * 0.25f) + 0.125f) * _6790;
                                                                  _7086 = (_global_7[min((uint)(((int)(0u + (_7072 * 2)))), 127u)]) * _7077;
                                                                  _7087 = (_global_7[min((uint)(((int)(1u + (_7072 * 2)))), 127u)]) * _7077;
                                                                  _7093 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_7086, _7087), float2(_6913, _6912)) + _6892), (dot(float2(_7086, _7087), float2(_6931, _6913)) + _6894)));
                                                                  _7098 = _7093.x - _6898;
                                                                  _7100 = select((_7098 < 0.0f), 0.0f, 1.0f);
                                                                  _7104 = _7093.y - _6898;
                                                                  _7106 = select((_7104 < 0.0f), 0.0f, 1.0f);
                                                                  _7110 = _7093.z - _6898;
                                                                  _7112 = select((_7110 < 0.0f), 0.0f, 1.0f);
                                                                  _7116 = _7093.w - _6898;
                                                                  _7118 = select((_7116 < 0.0f), 0.0f, 1.0f);
                                                                  _7119 = ((((((((((((((_6943 + _6947) + _6953) + _6959) + _6994) + _7000) + _7006) + _7012) + _7047) + _7053) + _7059) + _7065) + _7100) + _7106) + _7112) + _7118;
                                                                  _7130 = (saturate(_7119 * 0.0625f) * 2.0f) + -1.0f;
                                                                  _7136 = float((int)(((int)(uint)((int)(_7130 > 0.0f))) - ((int)(uint)((int)(_7130 < 0.0f)))));
                                                                  _7138 = 1.0f - (_7136 * _7130);
                                                                  _7140 = (_7138 * _7138) * _7138;
                                                                  _7147 = 0.5f - ((_7136 * 0.5f) * ((1.0f - _7140) - ((_7138 - _7140) * saturate(((1.0f / _6898) * (1.0f / _7119)) * ((((((((((((((((_6943 * _6941) + (_6947 * _6945)) + (_6953 * _6951)) + (_6959 * _6957)) + (_6994 * _6992)) + (_7000 * _6998)) + (_7006 * _7004)) + (_7012 * _7010)) + (_7047 * _7045)) + (_7053 * _7051)) + (_7059 * _7057)) + (_7065 * _7063)) + (_7100 * _7098)) + (_7106 * _7104)) + (_7112 * _7110)) + (_7118 * _7116))))));
                                                                  _7152 = frac((_6892 * _6793) + 0.5f);
                                                                  _7153 = frac((_6894 * _6793) + 0.5f);
                                                                  _7154 = _6892 + _6794;
                                                                  _7155 = _6894 + _6794;
                                                                  _7157 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7154, _7155), _6895);
                                                                  _7165 = _6794 * 2.0f;
                                                                  _7166 = _7154 - _7165;
                                                                  _7167 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7166, _7155), _6895);
                                                                  _7172 = 1.0f - _7152;
                                                                  _7177 = _7155 - _7165;
                                                                  _7178 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7166, _7177), _6895);
                                                                  _7183 = 1.0f - _7153;
                                                                  _7188 = _HeapResource_27.GatherCmp(samplerLinearPCFBorderBlackNode, float2(_7154, _7177), _6895);
                                                                  _7197 = (((mad(mad(_7167.x, _7172, _7167.y), _7153, mad(_7167.w, _7172, _7167.z)) + mad(mad(_7157.y, _7152, _7157.x), _7153, mad(_7157.z, _7152, _7157.w))) + mad(mad(_7178.w, _7172, _7178.z), _7183, mad(_7178.x, _7172, _7178.y))) + mad(mad(_7188.z, _7152, _7188.w), _7183, mad(_7188.y, _7152, _7188.x))) * 0.1111111119389534f;
                                                                  [branch]
                                                                  if (!(_6796 < 1.0f)) {
                                                                    _7671 = _7197;
                                                                    _7672 = _6796;
                                                                    _7673 = _7147;
                                                                    do {
                                                                      _7770 = _7672;
                                                                      _7771 = _7673;
                                                                      _7772 = _7671;
                                                                      [branch]
                                                                      if (!((_1628 & 2048) == 0)) {
                                                                        Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6726) >> 16))];
                                                                        _7679 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6851, _6852), 0.0f);
                                                                        if (_7679.x > 0.0f) {
                                                                          Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6726 & 65535))];
                                                                          _7686 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6851, _6852), 0.0f);
                                                                          _7700 = mad(saturate(((log2(_6802) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                          _7701 = max(9.999999747378752e-06f, _7679.x);
                                                                          _7702 = _7686.x / _7701;
                                                                          _7703 = _7686.y / _7701;
                                                                          _7705 = _7686.w / _7701;
                                                                          _7710 = ((0.375f - _7703) * 4.999999873689376e-06f) + _7703;
                                                                          _7713 = -0.0f - _7702;
                                                                          _7714 = mad(_7713, _7710, (_7686.z / _7701));
                                                                          _7716 = 1.0f / mad(_7713, _7702, _7710);
                                                                          _7717 = _7716 * _7714;
                                                                          _7722 = _7700 - _7702;
                                                                          _7727 = (((_7700 * _7700) - _7710) - (_7717 * _7722)) / mad((-0.0f - _7714), _7717, mad((-0.0f - _7710), _7710, (((0.375f - _7705) * 4.999999873689376e-06f) + _7705)));
                                                                          _7729 = (_7716 * _7722) - (_7727 * _7717);
                                                                          _7732 = 1.0f / _7727;
                                                                          _7733 = _7729 * _7732;
                                                                          _7738 = sqrt(((_7733 * _7733) * 0.25f) - ((1.0f - dot(float2(_7729, _7727), float2(_7702, _7710))) * _7732));
                                                                          _7740 = (_7733 * -0.5f) - _7738;
                                                                          _7742 = _7738 - (_7733 * 0.5f);
                                                                          _7744 = select((_7740 < _7700), 1.0f, 0.0f);
                                                                          _7749 = (_7744 + -0.05000000074505806f) / (_7740 - _7700);
                                                                          _7755 = (((select((_7742 < _7700), 1.0f, 0.0f) - _7744) / (_7742 - _7740)) - _7749) / (_7742 - _7700);
                                                                          _7757 = _7749 - (_7755 * _7740);
                                                                          _7770 = _7672;
                                                                          _7771 = (exp2((_7679.x * -1.4426950216293335f) * saturate((dot(float2(_7702, _7710), float2((_7757 - (_7755 * _7700)), _7755)) + 0.05000000074505806f) - (_7757 * _7700))) * _7673);
                                                                          _7772 = _7671;
                                                                        } else {
                                                                          _7770 = _7672;
                                                                          _7771 = _7673;
                                                                          _7772 = _7671;
                                                                        }
                                                                      }
                                                                      break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                    // Native PCF completion bypasses the fallback-shadow path.
                                                                    break;
                                                                  } else {
                                                                    _7200 = _7147;
                                                                    _7201 = _7197;
                                                                    _7202 = _6796;
                                                                    _7203 = _6895;
                                                                  }
                                                                }
                                                                _7206 = (_6886 * _6738) + _6740;
                                                                _7207 = (_6887 * _6739) + _6741;
                                                                do {
                                                                  _7666 = 1.0f;
                                                                  if (!((_1628 & 512) == 0)) {
                                                                    Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                                                    _7216 = saturate(_7203);
                                                                    _7220 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _7229 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_65, _66), cbSharedPerViewData.nFrameCounter, 7u);
                                                                    } else {
                                                                      _7229 = frac(frac(dot(float2(((_7220 * 32.665000915527344f) + _127), ((_7220 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _7229 = frac(frac(dot(float2(((_7220 * 32.665000915527344f) + _127), ((_7220 * 11.8149995803833f) + _128)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _7230 = sin(_7229);
                                                                    _7231 = cos(_7229);
                                                                    _7236 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_7206, _7207), 0.0f))).x) > _7216), 1.0f, 0.0f);
                                                                    _7237 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _7242 = sqrt((float((int)(_7237)) * 0.25f) + 0.125f) * _6791;
                                                                    _7251 = (_global_7[min((uint)(((int)(0u + (_7237 * 2)))), 127u)]) * _7242;
                                                                    _7252 = (_global_7[min((uint)(((int)(1u + (_7237 * 2)))), 127u)]) * _7242;
                                                                    _7254 = -0.0f - _7230;
                                                                    _7256 = dot(float2(_7251, _7252), float2(_7231, _7230)) + _7206;
                                                                    _7257 = dot(float2(_7251, _7252), float2(_7254, _7231)) + _7207;
                                                                    _7259 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7256, _7257));
                                                                    _7263 = _7256 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                    _7264 = _7257 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                    _7267 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6740);
                                                                    _7268 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6741);
                                                                    _7273 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6738 + _6740)) + 0.5f);
                                                                    _7274 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6739 + _6741)) + 0.5f);
                                                                    _7277 = floor(_7263 + -0.5f);
                                                                    _7278 = floor(_7264 + 0.5f);
                                                                    _7280 = floor(_7263 + 0.5f);
                                                                    _7282 = floor(_7264 + -0.5f);
                                                                    _7283 = (_7277 < _7267);
                                                                    _7284 = (_7278 < _7268);
                                                                    do {
                                                                      if (!(_7283 || _7284)) {
                                                                        if ((_7277 >= _7273) || (_7278 >= _7274)) {
                                                                          _7293 = _7236;
                                                                        } else {
                                                                          _7293 = _7259.x;
                                                                        }
                                                                      } else {
                                                                        _7293 = _7236;
                                                                      }
                                                                      _7294 = (_7280 < _7267);
                                                                      do {
                                                                        if (!(_7294 || _7284)) {
                                                                          if ((_7280 >= _7273) || (_7278 >= _7274)) {
                                                                            _7302 = _7236;
                                                                          } else {
                                                                            _7302 = _7259.y;
                                                                          }
                                                                        } else {
                                                                          _7302 = _7236;
                                                                        }
                                                                        _7303 = (_7282 < _7268);
                                                                        do {
                                                                          if (!(_7294 || _7303)) {
                                                                            if ((_7280 >= _7273) || (_7282 >= _7274)) {
                                                                              _7311 = _7236;
                                                                            } else {
                                                                              _7311 = _7259.z;
                                                                            }
                                                                          } else {
                                                                            _7311 = _7236;
                                                                          }
                                                                          do {
                                                                            if (!(_7283 || _7303)) {
                                                                              if ((_7277 >= _7273) || (_7282 >= _7274)) {
                                                                                _7319 = _7236;
                                                                              } else {
                                                                                _7319 = _7259.w;
                                                                              }
                                                                            } else {
                                                                              _7319 = _7236;
                                                                            }
                                                                            _7320 = _7293 - _7216;
                                                                            _7322 = select((_7320 < 0.0f), 0.0f, 1.0f);
                                                                            _7324 = _7302 - _7216;
                                                                            _7326 = select((_7324 < 0.0f), 0.0f, 1.0f);
                                                                            _7330 = _7311 - _7216;
                                                                            _7332 = select((_7330 < 0.0f), 0.0f, 1.0f);
                                                                            _7336 = _7319 - _7216;
                                                                            _7338 = select((_7336 < 0.0f), 0.0f, 1.0f);
                                                                            _7345 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _7350 = sqrt((float((int)(_7345)) * 0.25f) + 0.125f) * _6791;
                                                                            _7359 = (_global_7[min((uint)(((int)(0u + (_7345 * 2)))), 127u)]) * _7350;
                                                                            _7360 = (_global_7[min((uint)(((int)(1u + (_7345 * 2)))), 127u)]) * _7350;
                                                                            _7363 = dot(float2(_7359, _7360), float2(_7231, _7230)) + _7206;
                                                                            _7364 = dot(float2(_7359, _7360), float2(_7254, _7231)) + _7207;
                                                                            _7366 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7363, _7364));
                                                                            _7370 = _7363 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                            _7371 = _7364 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                            _7374 = floor(_7370 + -0.5f);
                                                                            _7375 = floor(_7371 + 0.5f);
                                                                            _7377 = floor(_7370 + 0.5f);
                                                                            _7379 = floor(_7371 + -0.5f);
                                                                            _7380 = (_7374 < _7267);
                                                                            _7381 = (_7375 < _7268);
                                                                            do {
                                                                              if (!(_7380 || _7381)) {
                                                                                if ((_7374 >= _7273) || (_7375 >= _7274)) {
                                                                                  _7390 = _7236;
                                                                                } else {
                                                                                  _7390 = _7366.x;
                                                                                }
                                                                              } else {
                                                                                _7390 = _7236;
                                                                              }
                                                                              _7391 = (_7377 < _7267);
                                                                              do {
                                                                                if (!(_7391 || _7381)) {
                                                                                  if ((_7377 >= _7273) || (_7375 >= _7274)) {
                                                                                    _7399 = _7236;
                                                                                  } else {
                                                                                    _7399 = _7366.y;
                                                                                  }
                                                                                } else {
                                                                                  _7399 = _7236;
                                                                                }
                                                                                _7400 = (_7379 < _7268);
                                                                                do {
                                                                                  if (!(_7391 || _7400)) {
                                                                                    if ((_7377 >= _7273) || (_7379 >= _7274)) {
                                                                                      _7408 = _7236;
                                                                                    } else {
                                                                                      _7408 = _7366.z;
                                                                                    }
                                                                                  } else {
                                                                                    _7408 = _7236;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_7380 || _7400)) {
                                                                                      if ((_7374 >= _7273) || (_7379 >= _7274)) {
                                                                                        _7416 = _7236;
                                                                                      } else {
                                                                                        _7416 = _7366.w;
                                                                                      }
                                                                                    } else {
                                                                                      _7416 = _7236;
                                                                                    }
                                                                                    _7417 = _7390 - _7216;
                                                                                    _7419 = select((_7417 < 0.0f), 0.0f, 1.0f);
                                                                                    _7423 = _7399 - _7216;
                                                                                    _7425 = select((_7423 < 0.0f), 0.0f, 1.0f);
                                                                                    _7429 = _7408 - _7216;
                                                                                    _7431 = select((_7429 < 0.0f), 0.0f, 1.0f);
                                                                                    _7435 = _7416 - _7216;
                                                                                    _7437 = select((_7435 < 0.0f), 0.0f, 1.0f);
                                                                                    _7444 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _7449 = sqrt((float((int)(_7444)) * 0.25f) + 0.125f) * _6791;
                                                                                    _7458 = (_global_7[min((uint)(((int)(0u + (_7444 * 2)))), 127u)]) * _7449;
                                                                                    _7459 = (_global_7[min((uint)(((int)(1u + (_7444 * 2)))), 127u)]) * _7449;
                                                                                    _7462 = dot(float2(_7458, _7459), float2(_7231, _7230)) + _7206;
                                                                                    _7463 = dot(float2(_7458, _7459), float2(_7254, _7231)) + _7207;
                                                                                    _7465 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7462, _7463));
                                                                                    _7469 = _7462 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                    _7470 = _7463 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                    _7473 = floor(_7469 + -0.5f);
                                                                                    _7474 = floor(_7470 + 0.5f);
                                                                                    _7476 = floor(_7469 + 0.5f);
                                                                                    _7478 = floor(_7470 + -0.5f);
                                                                                    _7479 = (_7473 < _7267);
                                                                                    _7480 = (_7474 < _7268);
                                                                                    do {
                                                                                      if (!(_7479 || _7480)) {
                                                                                        if ((_7473 >= _7273) || (_7474 >= _7274)) {
                                                                                          _7489 = _7236;
                                                                                        } else {
                                                                                          _7489 = _7465.x;
                                                                                        }
                                                                                      } else {
                                                                                        _7489 = _7236;
                                                                                      }
                                                                                      _7490 = (_7476 < _7267);
                                                                                      do {
                                                                                        if (!(_7490 || _7480)) {
                                                                                          if ((_7476 >= _7273) || (_7474 >= _7274)) {
                                                                                            _7498 = _7236;
                                                                                          } else {
                                                                                            _7498 = _7465.y;
                                                                                          }
                                                                                        } else {
                                                                                          _7498 = _7236;
                                                                                        }
                                                                                        _7499 = (_7478 < _7268);
                                                                                        do {
                                                                                          if (!(_7490 || _7499)) {
                                                                                            if ((_7476 >= _7273) || (_7478 >= _7274)) {
                                                                                              _7507 = _7236;
                                                                                            } else {
                                                                                              _7507 = _7465.z;
                                                                                            }
                                                                                          } else {
                                                                                            _7507 = _7236;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_7479 || _7499)) {
                                                                                              if ((_7473 >= _7273) || (_7478 >= _7274)) {
                                                                                                _7515 = _7236;
                                                                                              } else {
                                                                                                _7515 = _7465.w;
                                                                                              }
                                                                                            } else {
                                                                                              _7515 = _7236;
                                                                                            }
                                                                                            _7516 = _7489 - _7216;
                                                                                            _7518 = select((_7516 < 0.0f), 0.0f, 1.0f);
                                                                                            _7522 = _7498 - _7216;
                                                                                            _7524 = select((_7522 < 0.0f), 0.0f, 1.0f);
                                                                                            _7528 = _7507 - _7216;
                                                                                            _7530 = select((_7528 < 0.0f), 0.0f, 1.0f);
                                                                                            _7534 = _7515 - _7216;
                                                                                            _7536 = select((_7534 < 0.0f), 0.0f, 1.0f);
                                                                                            _7543 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _7548 = sqrt((float((int)(_7543)) * 0.25f) + 0.125f) * _6791;
                                                                                            _7557 = (_global_7[min((uint)(((int)(0u + (_7543 * 2)))), 127u)]) * _7548;
                                                                                            _7558 = (_global_7[min((uint)(((int)(1u + (_7543 * 2)))), 127u)]) * _7548;
                                                                                            _7561 = dot(float2(_7557, _7558), float2(_7231, _7230)) + _7206;
                                                                                            _7562 = dot(float2(_7557, _7558), float2(_7254, _7231)) + _7207;
                                                                                            _7564 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7561, _7562));
                                                                                            _7568 = _7561 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                            _7569 = _7562 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                            _7572 = floor(_7568 + -0.5f);
                                                                                            _7573 = floor(_7569 + 0.5f);
                                                                                            _7575 = floor(_7568 + 0.5f);
                                                                                            _7577 = floor(_7569 + -0.5f);
                                                                                            _7578 = (_7572 < _7267);
                                                                                            _7579 = (_7573 < _7268);
                                                                                            do {
                                                                                              if (!(_7578 || _7579)) {
                                                                                                if ((_7572 >= _7273) || (_7573 >= _7274)) {
                                                                                                  _7588 = _7236;
                                                                                                } else {
                                                                                                  _7588 = _7564.x;
                                                                                                }
                                                                                              } else {
                                                                                                _7588 = _7236;
                                                                                              }
                                                                                              _7589 = (_7575 < _7267);
                                                                                              do {
                                                                                                if (!(_7589 || _7579)) {
                                                                                                  if ((_7575 >= _7273) || (_7573 >= _7274)) {
                                                                                                    _7597 = _7236;
                                                                                                  } else {
                                                                                                    _7597 = _7564.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _7597 = _7236;
                                                                                                }
                                                                                                _7598 = (_7577 < _7268);
                                                                                                do {
                                                                                                  if (!(_7589 || _7598)) {
                                                                                                    if ((_7575 >= _7273) || (_7577 >= _7274)) {
                                                                                                      _7606 = _7236;
                                                                                                    } else {
                                                                                                      _7606 = _7564.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _7606 = _7236;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_7578 || _7598)) {
                                                                                                      if ((_7572 >= _7273) || (_7577 >= _7274)) {
                                                                                                        _7614 = _7236;
                                                                                                      } else {
                                                                                                        _7614 = _7564.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _7614 = _7236;
                                                                                                    }
                                                                                                    _7615 = _7588 - _7216;
                                                                                                    _7617 = select((_7615 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7621 = _7597 - _7216;
                                                                                                    _7623 = select((_7621 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7627 = _7606 - _7216;
                                                                                                    _7629 = select((_7627 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7633 = _7614 - _7216;
                                                                                                    _7635 = select((_7633 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7636 = ((((((((((((((_7326 + _7322) + _7332) + _7338) + _7419) + _7425) + _7431) + _7437) + _7518) + _7524) + _7530) + _7536) + _7617) + _7623) + _7629) + _7635;
                                                                                                    _7647 = (saturate(_7636 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _7653 = float((int)(((int)(uint)((int)(_7647 > 0.0f))) - ((int)(uint)((int)(_7647 < 0.0f)))));
                                                                                                    _7655 = 1.0f - (_7653 * _7647);
                                                                                                    _7657 = (_7655 * _7655) * _7655;
                                                                                                    _7666 = (0.5f - ((_7653 * 0.5f) * ((1.0f - _7657) - ((_7655 - _7657) * saturate(((1.0f / _7216) * (1.0f / _7636)) * ((((((((((((((((_7326 * _7324) + (_7322 * _7320)) + (_7332 * _7330)) + (_7338 * _7336)) + (_7419 * _7417)) + (_7425 * _7423)) + (_7431 * _7429)) + (_7437 * _7435)) + (_7518 * _7516)) + (_7524 * _7522)) + (_7530 * _7528)) + (_7536 * _7534)) + (_7617 * _7615)) + (_7623 * _7621)) + (_7629 * _7627)) + (_7635 * _7633)))))));
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
                                                                  _7671 = _7201;
                                                                  _7672 = _7202;
                                                                  _7673 = (lerp(_7666, _7200, _7202));
                                                                  [branch]
                                                                  if (!((_1628 & 2048) == 0)) {
                                                                    Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6726) >> 16))];
                                                                    _7679 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6851, _6852), 0.0f);
                                                                    if (_7679.x > 0.0f) {
                                                                      Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6726 & 65535))];
                                                                      _7686 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6851, _6852), 0.0f);
                                                                      _7700 = mad(saturate(((log2(_6802) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                      _7701 = max(9.999999747378752e-06f, _7679.x);
                                                                      _7702 = _7686.x / _7701;
                                                                      _7703 = _7686.y / _7701;
                                                                      _7705 = _7686.w / _7701;
                                                                      _7710 = ((0.375f - _7703) * 4.999999873689376e-06f) + _7703;
                                                                      _7713 = -0.0f - _7702;
                                                                      _7714 = mad(_7713, _7710, (_7686.z / _7701));
                                                                      _7716 = 1.0f / mad(_7713, _7702, _7710);
                                                                      _7717 = _7716 * _7714;
                                                                      _7722 = _7700 - _7702;
                                                                      _7727 = (((_7700 * _7700) - _7710) - (_7717 * _7722)) / mad((-0.0f - _7714), _7717, mad((-0.0f - _7710), _7710, (((0.375f - _7705) * 4.999999873689376e-06f) + _7705)));
                                                                      _7729 = (_7716 * _7722) - (_7727 * _7717);
                                                                      _7732 = 1.0f / _7727;
                                                                      _7733 = _7729 * _7732;
                                                                      _7738 = sqrt(((_7733 * _7733) * 0.25f) - ((1.0f - dot(float2(_7729, _7727), float2(_7702, _7710))) * _7732));
                                                                      _7740 = (_7733 * -0.5f) - _7738;
                                                                      _7742 = _7738 - (_7733 * 0.5f);
                                                                      _7744 = select((_7740 < _7700), 1.0f, 0.0f);
                                                                      _7749 = (_7744 + -0.05000000074505806f) / (_7740 - _7700);
                                                                      _7755 = (((select((_7742 < _7700), 1.0f, 0.0f) - _7744) / (_7742 - _7740)) - _7749) / (_7742 - _7700);
                                                                      _7757 = _7749 - (_7755 * _7740);
                                                                      _7770 = _7672;
                                                                      _7771 = (exp2((_7679.x * -1.4426950216293335f) * saturate((dot(float2(_7702, _7710), float2((_7757 - (_7755 * _7700)), _7755)) + 0.05000000074505806f) - (_7757 * _7700))) * _7673);
                                                                      _7772 = _7671;
                                                                    } else {
                                                                      _7770 = _7672;
                                                                      _7771 = _7673;
                                                                      _7772 = _7671;
                                                                    }
                                                                  } else {
                                                                    _7770 = _7672;
                                                                    _7771 = _7673;
                                                                    _7772 = _7671;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            do {
                                                              _7793 = _6752;
                                                              _7794 = _6753;
                                                              _7795 = _6755;
                                                              [branch]
                                                              if (!(_6773 == 0)) {
                                                                Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6773)))];
                                                                _7785 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6851 * f16tof32(((uint)((uint)(_6732) >> 16)))) + f16tof32(((uint)((uint)(_6735) >> 16)))), ((_6852 * f16tof32(_6732)) + f16tof32(_6735))), 0.0f);
                                                                _7793 = (_7785.x * _6752);
                                                                _7794 = (_7785.y * _6753);
                                                                _7795 = (_7785.z * _6755);
                                                              }
                                                              _7796 = _7771 * _6875;
                                                              [branch]
                                                              if (!(_7796 == 0.0f)) {
                                                                do {
                                                                  _7814 = GetDeferredSoftShadowChannel(_1631);
                                                                  if (_7814 < 0) {
                                                                        _7839 = _7796;
                                                                        do {
                                                                          _8856 = _1616;
                                                                          _8857 = _1617;
                                                                          _8858 = _1618;
                                                                          _8859 = _1619;
                                                                          _8860 = _1620;
                                                                          _8861 = _1621;
                                                                          [branch]
                                                                          if (_7839 > 0.0f) {
                                                                            do {
                                                                              _7959 = _7793;
                                                                              _7960 = _7794;
                                                                              _7961 = _7795;
                                                                              _7962 = 0.0f;
                                                                              _7963 = 0.0f;
                                                                              _7964 = 0.0f;
                                                                              if (_6779) {
                                                                                do {
                                                                                  _7854 = 0.0f;
                                                                                  _7855 = 0.0f;
                                                                                  _7856 = 0.0f;
                                                                                  if (!(_242)) {
                                                                                    _7849 = ((_7770 * _6875) * _7772) * saturate(0.30000001192092896f - dot(float3(_6803, _6804, _6805), float3(_195, _196, _197)));
                                                                                    _7854 = (_7849 * _1300);
                                                                                    _7855 = (_7849 * _1301);
                                                                                    _7856 = (_7849 * _1302);
                                                                                  }
                                                                                  [branch]
                                                                                  if (!((_6729 & 1) == 0)) {
                                                                                    _7869 = max(max(_7793, _7794), _7795);
                                                                                    do {
                                                                                      _7879 = _7793;
                                                                                      _7880 = _7794;
                                                                                      _7881 = _7795;
                                                                                      if (_7869 > 0.0f) {
                                                                                        _7879 = saturate(_7793 / _7869);
                                                                                        _7880 = saturate(_7794 / _7869);
                                                                                        _7881 = saturate(_7795 / _7869);
                                                                                      }
                                                                                      _7882 = (_7880 < _7881);
                                                                                      _7883 = select(_7882, _7881, _7880);
                                                                                      _7884 = select(_7882, _7880, _7881);
                                                                                      _7885 = select(_7882, -1.0f, 0.0f);
                                                                                      _7886 = (_7879 < _7883);
                                                                                      _7888 = select(_7886, _7883, _7879);
                                                                                      _7889 = select(_7886, _7879, _7883);
                                                                                      _7893 = _7888 - select((_7889 < _7884), _7889, _7884);
                                                                                      _7899 = abs(select(_7886, (-0.3333333432674408f - _7885), _7885) + ((_7889 - _7884) / ((_7893 * 6.0f) + 9.999999682655225e-21f)));
                                                                                      do {
                                                                                        _7912 = _7899;
                                                                                        if (_7899 < 0.6666666865348816f) {
                                                                                          _7912 = ((saturate(((float)((uint)((uint)(((uint)(_6729) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7899 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7899)) + _7899);
                                                                                        }
                                                                                        _7913 = saturate((_7893 / (_7888 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6729) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                        _7914 = saturate(_7888);
                                                                                        do {
                                                                                          _7941 = _7914;
                                                                                          _7942 = _7914;
                                                                                          _7943 = _7914;
                                                                                          if (!(_7913 <= 0.0f)) {
                                                                                            _7917 = saturate(_7912);
                                                                                            _7921 = select(((_7917 * 360.0f) >= 360.0f), 0.0f, (_7917 * 6.0f));
                                                                                            _7922 = int(_7921);
                                                                                            _7924 = _7921 - float((int)(_7922));
                                                                                            _7926 = _7914 * (1.0f - _7913);
                                                                                            _7929 = (1.0f - (_7924 * _7913)) * _7914;
                                                                                            _7933 = (1.0f - ((1.0f - _7924) * _7913)) * _7914;
                                                                                            switch (_7922) {
                                                                                              case 0: {
                                                                                                _7941 = _7914;
                                                                                                _7942 = _7933;
                                                                                                _7943 = _7926;
                                                                                                break;
                                                                                              }
                                                                                              case 1: {
                                                                                                _7941 = _7929;
                                                                                                _7942 = _7914;
                                                                                                _7943 = _7926;
                                                                                                break;
                                                                                              }
                                                                                              case 2: {
                                                                                                _7941 = _7926;
                                                                                                _7942 = _7914;
                                                                                                _7943 = _7933;
                                                                                                break;
                                                                                              }
                                                                                              case 3: {
                                                                                                _7941 = _7926;
                                                                                                _7942 = _7929;
                                                                                                _7943 = _7914;
                                                                                                break;
                                                                                              }
                                                                                              case 4: {
                                                                                                _7941 = _7933;
                                                                                                _7942 = _7926;
                                                                                                _7943 = _7914;
                                                                                                break;
                                                                                              }
                                                                                              case 5: {
                                                                                                _7941 = _7914;
                                                                                                _7942 = _7926;
                                                                                                _7943 = _7929;
                                                                                                break;
                                                                                              }
                                                                                              default: {
                                                                                                _7941 = 0.0f;
                                                                                                _7942 = 0.0f;
                                                                                                _7943 = 0.0f;
                                                                                                break;
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                          _7944 = _7941 * _7869;
                                                                                          _7945 = _7942 * _7869;
                                                                                          _7946 = _7943 * _7869;
                                                                                          _7948 = saturate(_7771 * 1.0101009607315063f);
                                                                                          _7959 = ((_7948 * (_7793 - _7944)) + _7944);
                                                                                          _7960 = ((_7948 * (_7794 - _7945)) + _7945);
                                                                                          _7961 = (lerp(_7946, _7795, _7948));
                                                                                          _7962 = _7854;
                                                                                          _7963 = _7855;
                                                                                          _7964 = _7856;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } else {
                                                                                    _7959 = _7793;
                                                                                    _7960 = _7794;
                                                                                    _7961 = _7795;
                                                                                    _7962 = _7854;
                                                                                    _7963 = _7855;
                                                                                    _7964 = _7856;
                                                                                  }
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              }
                                                                              do {
                                                                                _8000 = _7839;
                                                                                [branch]
                                                                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                  _7971 = srvLightMappingData[_1631];
                                                                                  if (!(_7971 == -1)) {
                                                                                    _7976 = srvLightIndexData[_7971].nLayerIndex;
                                                                                    _7978 = srvLightIndexData[_7971].vAtlasOrigin.x;
                                                                                    _7979 = srvLightIndexData[_7971].vAtlasOrigin.y;
                                                                                    _7981 = srvLightIndexData[_7971].vScreenOrigin.x;
                                                                                    _7982 = srvLightIndexData[_7971].vScreenOrigin.y;
                                                                                    _7991 = ((int)(_7976 * 5)) & 31;
                                                                                    _8000 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7978 + _65) - _7981)), ((int)((_7979 + _66) - _7982)), 0)))).x) & ((int)(31 << _7991)))) >> _7991)) >> 1)))) * 0.06666667014360428f) * _7839);
                                                                                  } else {
                                                                                    _8000 = _7839;
                                                                                  }
                                                                                }
                                                                                _8004 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                                _8007 = select(_8004, (_8000 * _1288), _8000);
                                                                                _8009 = _6803 * _6802;
                                                                                _8010 = _6804 * _6802;
                                                                                _8011 = _6805 * _6802;
                                                                                _8012 = _6763 * _6694;
                                                                                _8013 = _6763 * _6695;
                                                                                _8014 = _6763 * _6696;
                                                                                _8015 = _8009 + _8012;
                                                                                _8016 = _8010 + _8013;
                                                                                _8017 = _8011 + _8014;
                                                                                _8018 = _8009 - _8012;
                                                                                _8019 = _8010 - _8013;
                                                                                _8020 = _8011 - _8014;
                                                                                _8021 = (_6763 > 0.0f);
                                                                                _8022 = dot(float3(_8015, _8016, _8017), float3(_8015, _8016, _8017));
                                                                                _8023 = rsqrt(_8022);
                                                                                do {
                                                                                  [branch]
                                                                                  if (_8021) {
                                                                                    _8026 = rsqrt(dot(float3(_8018, _8019, _8020), float3(_8018, _8019, _8020)));
                                                                                    _8027 = _8026 * _8023;
                                                                                    _8029 = dot(float3(_8015, _8016, _8017), float3(_8018, _8019, _8020)) * _8027;
                                                                                    _8048 = (_8027 / ((_8027 + 0.5f) + (_8029 * 0.5f)));
                                                                                    _8049 = (((dot(float3(_195, _196, _197), float3(_8018, _8019, _8020)) * _8026) + (dot(float3(_195, _196, _197), float3(_8015, _8016, _8017)) * _8023)) * 0.5f);
                                                                                    _8050 = _8029;
                                                                                  } else {
                                                                                    _8048 = (1.0f / (_8022 + 1.0f));
                                                                                    _8049 = dot(float3(_195, _196, _197), float3((_8023 * _8015), (_8023 * _8016), (_8023 * _8017)));
                                                                                    _8050 = 1.0f;
                                                                                  }
                                                                                  do {
                                                                                    _8066 = _8049;
                                                                                    if (_6765 > 0.0f) {
                                                                                      _8056 = sqrt(saturate((_6765 * _6765) * _8048));
                                                                                      if (_8049 < _8056) {
                                                                                        _8061 = max(_8049, (-0.0f - _8056)) + _8056;
                                                                                        _8066 = ((_8061 * _8061) / (_8056 * 4.0f));
                                                                                      } else {
                                                                                        _8066 = _8049;
                                                                                      }
                                                                                    }
                                                                                    do {
                                                                                      _8126 = _8015;
                                                                                      _8127 = _8016;
                                                                                      _8128 = _8017;
                                                                                      if (_8021) {
                                                                                        _8068 = -0.0f - _459;
                                                                                        _8069 = -0.0f - _460;
                                                                                        _8070 = -0.0f - _458;
                                                                                        _8072 = dot(float3(_8068, _8069, _8070), float3(_195, _196, _197)) * 2.0f;
                                                                                        _8076 = _8068 - (_8072 * _195);
                                                                                        _8077 = _8069 - (_8072 * _196);
                                                                                        _8078 = _8070 - (_8072 * _197);
                                                                                        _8079 = _8018 - _8015;
                                                                                        _8080 = _8019 - _8016;
                                                                                        _8081 = _8020 - _8017;
                                                                                        _8082 = dot(float3(_8076, _8077, _8078), float3(_8079, _8080, _8081));
                                                                                        _8088 = sqrt(((_8079 * _8079) + (_8080 * _8080)) + (_8081 * _8081));
                                                                                        _8097 = saturate(((dot(float3(_8076, _8077, _8078), float3(_8015, _8016, _8017)) * _8082) - dot(float3(_8015, _8016, _8017), float3(_8079, _8080, _8081))) / ((_8088 * _8088) - (_8082 * _8082)));
                                                                                        _8101 = (_8097 * _8079) + _8015;
                                                                                        _8102 = (_8097 * _8080) + _8016;
                                                                                        _8103 = (_8097 * _8081) + _8017;
                                                                                        _8104 = dot(float3(_8101, _8102, _8103), float3(_8076, _8077, _8078));
                                                                                        _8108 = (_8104 * _8076) - _8101;
                                                                                        _8109 = (_8104 * _8077) - _8102;
                                                                                        _8110 = (_8104 * _8078) - _8103;
                                                                                        _8118 = saturate(0.009999999776482582f / sqrt(((_8108 * _8108) + (_8109 * _8109)) + (_8110 * _8110)));
                                                                                        _8126 = ((_8118 * _8108) + _8101);
                                                                                        _8127 = ((_8118 * _8109) + _8102);
                                                                                        _8128 = ((_8118 * _8110) + _8103);
                                                                                      }
                                                                                      _8130 = rsqrt(dot(float3(_8126, _8127, _8128), float3(_8126, _8127, _8128)));
                                                                                      _8131 = _8130 * _8126;
                                                                                      _8132 = _8130 * _8127;
                                                                                      _8133 = _8130 * _8128;
                                                                                      _8134 = _223 * _223;
                                                                                      _8138 = saturate((_6765 * (1.0f - _8134)) * _8130);
                                                                                      _8140 = saturate(_8130 * f16tof32(_6708));
                                                                                      _8142 = rsqrt(dot(float3(_8009, _8010, _8011), float3(_8009, _8010, _8011)));
                                                                                      _8146 = dot(float3(_195, _196, _197), float3(_8131, _8132, _8133));
                                                                                      _8147 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                                                      _8148 = dot(float3(_459, _460, _458), float3(_8131, _8132, _8133));
                                                                                      _8151 = rsqrt((_8148 * 2.0f) + 2.0f);
                                                                                      _8158 = (_8138 > 0.0f);
                                                                                      do {
                                                                                        _8249 = saturate((_8151 * _8148) + _8151);
                                                                                        _8250 = saturate(_8151 * (_8147 + _8146));
                                                                                        if (_8158) {
                                                                                          _8162 = sqrt(1.0f - (_8138 * _8138));
                                                                                          _8164 = (_8146 * 2.0f) * _8147;
                                                                                          _8165 = _8164 - _8148;
                                                                                          if (!(!(_8165 >= _8162))) {
                                                                                            _8249 = abs(_8147);
                                                                                            _8250 = 1.0f;
                                                                                          } else {
                                                                                            _8173 = rsqrt(1.0f - (_8165 * _8165)) * _8138;
                                                                                            _8176 = _8173 * (_8147 - (_8165 * _8146));
                                                                                            _8177 = _8147 * _8147;
                                                                                            _8182 = _8173 * (((_8177 * 2.0f) + -1.0f) - (_8165 * _8148));
                                                                                            _8191 = sqrt(saturate((((1.0f - (_8146 * _8146)) - _8177) - (_8148 * _8148)) + (_8164 * _8148)));
                                                                                            _8192 = _8191 * _8173;
                                                                                            _8195 = ((_8147 * 2.0f) * _8173) * _8191;
                                                                                            _8197 = (_8162 * _8146) + _8147;
                                                                                            _8198 = _8197 + _8176;
                                                                                            _8199 = _8162 * _8148;
                                                                                            _8201 = (_8199 + 1.0f) + _8182;
                                                                                            _8202 = _8192 * _8201;
                                                                                            _8203 = _8198 * _8201;
                                                                                            _8204 = _8195 * _8198;
                                                                                            _8209 = (((_8198 * 0.25f) * _8195) - (_8202 * 0.5f)) * _8203;
                                                                                            _8223 = (((_8204 - (_8202 * 2.0f)) * _8204) + (_8202 * _8202)) + ((((-0.5f - ((_8201 + _8199) * 0.5f)) * _8203) + ((_8201 * _8201) * _8197)) * _8198);
                                                                                            _8228 = (_8209 * 2.0f) / ((_8223 * _8223) + (_8209 * _8209));
                                                                                            _8229 = _8223 * _8228;
                                                                                            _8231 = 1.0f - (_8209 * _8228);
                                                                                            _8237 = ((_8229 * _8195) + _8199) + (_8231 * _8182);
                                                                                            _8240 = rsqrt((_8237 * 2.0f) + 2.0f);
                                                                                            _8249 = saturate((_8237 * _8240) + _8240);
                                                                                            _8250 = saturate(((_8197 + (_8229 * _8192)) + (_8231 * _8176)) * _8240);
                                                                                          }
                                                                                        }
                                                                                        _8251 = saturate(_8066);
                                                                                        _8253 = _8134 * _8134;
                                                                                        do {
                                                                                          _8263 = _8253;
                                                                                          if (_8140 > 0.0f) {
                                                                                            _8263 = saturate(((_8140 * _8140) / ((_8249 * 3.5999999046325684f) + 0.4000000059604645f)) + _8253);
                                                                                          }
                                                                                          do {
                                                                                            _8275 = _8263;
                                                                                            _8276 = 1.0f;
                                                                                            if (_8158) {
                                                                                              _8272 = (((_8138 * 0.25f) * ((sqrt(_8263) * 3.0f) + _8138)) / (_8249 + 0.0010000000474974513f)) + _8263;
                                                                                              _8275 = _8272;
                                                                                              _8276 = (_8263 / _8272);
                                                                                            }
                                                                                            do {
                                                                                              _8296 = _8276;
                                                                                              if (_8050 < 1.0f) {
                                                                                                _8283 = sqrt((1.000100016593933f - _8050) / max(9.999999974752427e-07f, (_8050 + 1.0f)));
                                                                                                _8296 = (sqrt(_8275 / ((((_8283 * 0.25f) * ((sqrt(_8275) * 3.0f) + _8283)) / (_8249 + 0.0010000000474974513f)) + _8275)) * _8276);
                                                                                              }
                                                                                              _8300 = (((_8263 * _8250) - _8250) * _8250) + 1.0f;
                                                                                              _8307 = exp2(log2(1.0f - saturate(_8249)) * 5.0f);
                                                                                              _8310 = saturate(abs(_8147) + 9.999999747378752e-06f);
                                                                                              _8311 = sqrt(_8263);
                                                                                              _8312 = 1.0f - _8311;
                                                                                              _8324 = saturate((dot(float3(_195, _196, _197), float3((_8142 * _8009), (_8142 * _8010), (_8142 * _8011))) + _6762) / (_6762 + 1.0f));
                                                                                              _8327 = ((_8296 * _8251) * (_8263 / (_8300 * _8300))) * (0.5f / ((((_8312 * _8310) + _8311) * _8251) + (((_8312 * _8251) + _8311) * _8310)));
                                                                                              _8328 = _7959 * _1679;
                                                                                              _8329 = _7960 * _1679;
                                                                                              _8330 = _7961 * _1679;
                                                                                              do {
                                                                                                _8369 = _1619;
                                                                                                _8370 = _1620;
                                                                                                _8371 = _1621;
                                                                                                if (_6759 > 0.0f) {
                                                                                                  _8352 = (_6759 * _1375) * select(_8004, (_8000 * _1288), _8000);
                                                                                                  _8369 = (((((_8328 * _1151) * _8352) * ((_8307 * (1.0f - _215)) + _215)) * _8327) + _1619);
                                                                                                  _8370 = (((((_8329 * _1152) * _8352) * ((_8307 * (1.0f - _216)) + _216)) * _8327) + _1620);
                                                                                                  _8371 = (((((_8330 * _1153) * _8352) * ((_8307 * (1.0f - _217)) + _217)) * _8327) + _1621);
                                                                                                }
                                                                                                _8856 = (((_8007 * _8328) * _8324) + _1616);
                                                                                                _8857 = (((_8007 * _8329) * _8324) + _1617);
                                                                                                _8858 = (((_8007 * _8330) * _8324) + _1618);
                                                                                                _8859 = (_8369 + (_7962 * _8328));
                                                                                                _8860 = (_8370 + (_7963 * _8329));
                                                                                                _8861 = (_8371 + (_7964 * _8330));
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
                                                                  _7817 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_65, _66, 0));
                                                                  do {
                                                                    if (_7814 == 0) {
                                                                      _7831 = _7817.x;
                                                                    } else {
                                                                      if (_7814 == 1) {
                                                                        _7831 = _7817.y;
                                                                      } else {
                                                                        if (_7814 == 2) {
                                                                          _7831 = _7817.z;
                                                                        } else {
                                                                          _7831 = _7817.w;
                                                                        }
                                                                      }
                                                                    }
                                                                    _7839 = ((((_7770 * _7770) * ((_7831 * _7831) + -1.0f)) + 1.0f) * _6875);
                                                                    [branch]
                                                                    if (_7839 > 0.0f) {
                                                                      do {
                                                                        _7959 = _7793;
                                                                        _7960 = _7794;
                                                                        _7961 = _7795;
                                                                        _7962 = 0.0f;
                                                                        _7963 = 0.0f;
                                                                        _7964 = 0.0f;
                                                                        if (_6779) {
                                                                          do {
                                                                            _7854 = 0.0f;
                                                                            _7855 = 0.0f;
                                                                            _7856 = 0.0f;
                                                                            if (!(_242)) {
                                                                              _7849 = ((_7770 * _6875) * _7772) * saturate(0.30000001192092896f - dot(float3(_6803, _6804, _6805), float3(_195, _196, _197)));
                                                                              _7854 = (_7849 * _1300);
                                                                              _7855 = (_7849 * _1301);
                                                                              _7856 = (_7849 * _1302);
                                                                            }
                                                                            [branch]
                                                                            if (!((_6729 & 1) == 0)) {
                                                                              _7869 = max(max(_7793, _7794), _7795);
                                                                              do {
                                                                                _7879 = _7793;
                                                                                _7880 = _7794;
                                                                                _7881 = _7795;
                                                                                if (_7869 > 0.0f) {
                                                                                  _7879 = saturate(_7793 / _7869);
                                                                                  _7880 = saturate(_7794 / _7869);
                                                                                  _7881 = saturate(_7795 / _7869);
                                                                                }
                                                                                _7882 = (_7880 < _7881);
                                                                                _7883 = select(_7882, _7881, _7880);
                                                                                _7884 = select(_7882, _7880, _7881);
                                                                                _7885 = select(_7882, -1.0f, 0.0f);
                                                                                _7886 = (_7879 < _7883);
                                                                                _7888 = select(_7886, _7883, _7879);
                                                                                _7889 = select(_7886, _7879, _7883);
                                                                                _7893 = _7888 - select((_7889 < _7884), _7889, _7884);
                                                                                _7899 = abs(select(_7886, (-0.3333333432674408f - _7885), _7885) + ((_7889 - _7884) / ((_7893 * 6.0f) + 9.999999682655225e-21f)));
                                                                                do {
                                                                                  _7912 = _7899;
                                                                                  if (_7899 < 0.6666666865348816f) {
                                                                                    _7912 = ((saturate(((float)((uint)((uint)(((uint)(_6729) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7899 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7899)) + _7899);
                                                                                  }
                                                                                  _7913 = saturate((_7893 / (_7888 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6729) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                  _7914 = saturate(_7888);
                                                                                  do {
                                                                                    _7941 = _7914;
                                                                                    _7942 = _7914;
                                                                                    _7943 = _7914;
                                                                                    if (!(_7913 <= 0.0f)) {
                                                                                      _7917 = saturate(_7912);
                                                                                      _7921 = select(((_7917 * 360.0f) >= 360.0f), 0.0f, (_7917 * 6.0f));
                                                                                      _7922 = int(_7921);
                                                                                      _7924 = _7921 - float((int)(_7922));
                                                                                      _7926 = _7914 * (1.0f - _7913);
                                                                                      _7929 = (1.0f - (_7924 * _7913)) * _7914;
                                                                                      _7933 = (1.0f - ((1.0f - _7924) * _7913)) * _7914;
                                                                                      switch (_7922) {
                                                                                        case 0: {
                                                                                          _7941 = _7914;
                                                                                          _7942 = _7933;
                                                                                          _7943 = _7926;
                                                                                          break;
                                                                                        }
                                                                                        case 1: {
                                                                                          _7941 = _7929;
                                                                                          _7942 = _7914;
                                                                                          _7943 = _7926;
                                                                                          break;
                                                                                        }
                                                                                        case 2: {
                                                                                          _7941 = _7926;
                                                                                          _7942 = _7914;
                                                                                          _7943 = _7933;
                                                                                          break;
                                                                                        }
                                                                                        case 3: {
                                                                                          _7941 = _7926;
                                                                                          _7942 = _7929;
                                                                                          _7943 = _7914;
                                                                                          break;
                                                                                        }
                                                                                        case 4: {
                                                                                          _7941 = _7933;
                                                                                          _7942 = _7926;
                                                                                          _7943 = _7914;
                                                                                          break;
                                                                                        }
                                                                                        case 5: {
                                                                                          _7941 = _7914;
                                                                                          _7942 = _7926;
                                                                                          _7943 = _7929;
                                                                                          break;
                                                                                        }
                                                                                        default: {
                                                                                          _7941 = 0.0f;
                                                                                          _7942 = 0.0f;
                                                                                          _7943 = 0.0f;
                                                                                          break;
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                    _7944 = _7941 * _7869;
                                                                                    _7945 = _7942 * _7869;
                                                                                    _7946 = _7943 * _7869;
                                                                                    _7948 = saturate(_7771 * 1.0101009607315063f);
                                                                                    _7959 = ((_7948 * (_7793 - _7944)) + _7944);
                                                                                    _7960 = ((_7948 * (_7794 - _7945)) + _7945);
                                                                                    _7961 = (lerp(_7946, _7795, _7948));
                                                                                    _7962 = _7854;
                                                                                    _7963 = _7855;
                                                                                    _7964 = _7856;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } else {
                                                                              _7959 = _7793;
                                                                              _7960 = _7794;
                                                                              _7961 = _7795;
                                                                              _7962 = _7854;
                                                                              _7963 = _7855;
                                                                              _7964 = _7856;
                                                                            }
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        }
                                                                        do {
                                                                          _8000 = _7839;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _7971 = srvLightMappingData[_1631];
                                                                            if (!(_7971 == -1)) {
                                                                              _7976 = srvLightIndexData[_7971].nLayerIndex;
                                                                              _7978 = srvLightIndexData[_7971].vAtlasOrigin.x;
                                                                              _7979 = srvLightIndexData[_7971].vAtlasOrigin.y;
                                                                              _7981 = srvLightIndexData[_7971].vScreenOrigin.x;
                                                                              _7982 = srvLightIndexData[_7971].vScreenOrigin.y;
                                                                              _7991 = ((int)(_7976 * 5)) & 31;
                                                                              _8000 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7978 + _65) - _7981)), ((int)((_7979 + _66) - _7982)), 0)))).x) & ((int)(31 << _7991)))) >> _7991)) >> 1)))) * 0.06666667014360428f) * _7839);
                                                                            } else {
                                                                              _8000 = _7839;
                                                                            }
                                                                          }
                                                                          _8004 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _8007 = select(_8004, (_8000 * _1288), _8000);
                                                                          _8009 = _6803 * _6802;
                                                                          _8010 = _6804 * _6802;
                                                                          _8011 = _6805 * _6802;
                                                                          _8012 = _6763 * _6694;
                                                                          _8013 = _6763 * _6695;
                                                                          _8014 = _6763 * _6696;
                                                                          _8015 = _8009 + _8012;
                                                                          _8016 = _8010 + _8013;
                                                                          _8017 = _8011 + _8014;
                                                                          _8018 = _8009 - _8012;
                                                                          _8019 = _8010 - _8013;
                                                                          _8020 = _8011 - _8014;
                                                                          _8021 = (_6763 > 0.0f);
                                                                          _8022 = dot(float3(_8015, _8016, _8017), float3(_8015, _8016, _8017));
                                                                          _8023 = rsqrt(_8022);
                                                                          do {
                                                                            [branch]
                                                                            if (_8021) {
                                                                              _8026 = rsqrt(dot(float3(_8018, _8019, _8020), float3(_8018, _8019, _8020)));
                                                                              _8027 = _8026 * _8023;
                                                                              _8029 = dot(float3(_8015, _8016, _8017), float3(_8018, _8019, _8020)) * _8027;
                                                                              _8048 = (_8027 / ((_8027 + 0.5f) + (_8029 * 0.5f)));
                                                                              _8049 = (((dot(float3(_195, _196, _197), float3(_8018, _8019, _8020)) * _8026) + (dot(float3(_195, _196, _197), float3(_8015, _8016, _8017)) * _8023)) * 0.5f);
                                                                              _8050 = _8029;
                                                                            } else {
                                                                              _8048 = (1.0f / (_8022 + 1.0f));
                                                                              _8049 = dot(float3(_195, _196, _197), float3((_8023 * _8015), (_8023 * _8016), (_8023 * _8017)));
                                                                              _8050 = 1.0f;
                                                                            }
                                                                            do {
                                                                              _8066 = _8049;
                                                                              if (_6765 > 0.0f) {
                                                                                _8056 = sqrt(saturate((_6765 * _6765) * _8048));
                                                                                if (_8049 < _8056) {
                                                                                  _8061 = max(_8049, (-0.0f - _8056)) + _8056;
                                                                                  _8066 = ((_8061 * _8061) / (_8056 * 4.0f));
                                                                                } else {
                                                                                  _8066 = _8049;
                                                                                }
                                                                              }
                                                                              do {
                                                                                _8126 = _8015;
                                                                                _8127 = _8016;
                                                                                _8128 = _8017;
                                                                                if (_8021) {
                                                                                  _8068 = -0.0f - _459;
                                                                                  _8069 = -0.0f - _460;
                                                                                  _8070 = -0.0f - _458;
                                                                                  _8072 = dot(float3(_8068, _8069, _8070), float3(_195, _196, _197)) * 2.0f;
                                                                                  _8076 = _8068 - (_8072 * _195);
                                                                                  _8077 = _8069 - (_8072 * _196);
                                                                                  _8078 = _8070 - (_8072 * _197);
                                                                                  _8079 = _8018 - _8015;
                                                                                  _8080 = _8019 - _8016;
                                                                                  _8081 = _8020 - _8017;
                                                                                  _8082 = dot(float3(_8076, _8077, _8078), float3(_8079, _8080, _8081));
                                                                                  _8088 = sqrt(((_8079 * _8079) + (_8080 * _8080)) + (_8081 * _8081));
                                                                                  _8097 = saturate(((dot(float3(_8076, _8077, _8078), float3(_8015, _8016, _8017)) * _8082) - dot(float3(_8015, _8016, _8017), float3(_8079, _8080, _8081))) / ((_8088 * _8088) - (_8082 * _8082)));
                                                                                  _8101 = (_8097 * _8079) + _8015;
                                                                                  _8102 = (_8097 * _8080) + _8016;
                                                                                  _8103 = (_8097 * _8081) + _8017;
                                                                                  _8104 = dot(float3(_8101, _8102, _8103), float3(_8076, _8077, _8078));
                                                                                  _8108 = (_8104 * _8076) - _8101;
                                                                                  _8109 = (_8104 * _8077) - _8102;
                                                                                  _8110 = (_8104 * _8078) - _8103;
                                                                                  _8118 = saturate(0.009999999776482582f / sqrt(((_8108 * _8108) + (_8109 * _8109)) + (_8110 * _8110)));
                                                                                  _8126 = ((_8118 * _8108) + _8101);
                                                                                  _8127 = ((_8118 * _8109) + _8102);
                                                                                  _8128 = ((_8118 * _8110) + _8103);
                                                                                }
                                                                                _8130 = rsqrt(dot(float3(_8126, _8127, _8128), float3(_8126, _8127, _8128)));
                                                                                _8131 = _8130 * _8126;
                                                                                _8132 = _8130 * _8127;
                                                                                _8133 = _8130 * _8128;
                                                                                _8134 = _223 * _223;
                                                                                _8138 = saturate((_6765 * (1.0f - _8134)) * _8130);
                                                                                _8140 = saturate(_8130 * f16tof32(_6708));
                                                                                _8142 = rsqrt(dot(float3(_8009, _8010, _8011), float3(_8009, _8010, _8011)));
                                                                                _8146 = dot(float3(_195, _196, _197), float3(_8131, _8132, _8133));
                                                                                _8147 = dot(float3(_195, _196, _197), float3(_459, _460, _458));
                                                                                _8148 = dot(float3(_459, _460, _458), float3(_8131, _8132, _8133));
                                                                                _8151 = rsqrt((_8148 * 2.0f) + 2.0f);
                                                                                _8158 = (_8138 > 0.0f);
                                                                                do {
                                                                                  _8249 = saturate((_8151 * _8148) + _8151);
                                                                                  _8250 = saturate(_8151 * (_8147 + _8146));
                                                                                  if (_8158) {
                                                                                    _8162 = sqrt(1.0f - (_8138 * _8138));
                                                                                    _8164 = (_8146 * 2.0f) * _8147;
                                                                                    _8165 = _8164 - _8148;
                                                                                    if (!(!(_8165 >= _8162))) {
                                                                                      _8249 = abs(_8147);
                                                                                      _8250 = 1.0f;
                                                                                    } else {
                                                                                      _8173 = rsqrt(1.0f - (_8165 * _8165)) * _8138;
                                                                                      _8176 = _8173 * (_8147 - (_8165 * _8146));
                                                                                      _8177 = _8147 * _8147;
                                                                                      _8182 = _8173 * (((_8177 * 2.0f) + -1.0f) - (_8165 * _8148));
                                                                                      _8191 = sqrt(saturate((((1.0f - (_8146 * _8146)) - _8177) - (_8148 * _8148)) + (_8164 * _8148)));
                                                                                      _8192 = _8191 * _8173;
                                                                                      _8195 = ((_8147 * 2.0f) * _8173) * _8191;
                                                                                      _8197 = (_8162 * _8146) + _8147;
                                                                                      _8198 = _8197 + _8176;
                                                                                      _8199 = _8162 * _8148;
                                                                                      _8201 = (_8199 + 1.0f) + _8182;
                                                                                      _8202 = _8192 * _8201;
                                                                                      _8203 = _8198 * _8201;
                                                                                      _8204 = _8195 * _8198;
                                                                                      _8209 = (((_8198 * 0.25f) * _8195) - (_8202 * 0.5f)) * _8203;
                                                                                      _8223 = (((_8204 - (_8202 * 2.0f)) * _8204) + (_8202 * _8202)) + ((((-0.5f - ((_8201 + _8199) * 0.5f)) * _8203) + ((_8201 * _8201) * _8197)) * _8198);
                                                                                      _8228 = (_8209 * 2.0f) / ((_8223 * _8223) + (_8209 * _8209));
                                                                                      _8229 = _8223 * _8228;
                                                                                      _8231 = 1.0f - (_8209 * _8228);
                                                                                      _8237 = ((_8229 * _8195) + _8199) + (_8231 * _8182);
                                                                                      _8240 = rsqrt((_8237 * 2.0f) + 2.0f);
                                                                                      _8249 = saturate((_8237 * _8240) + _8240);
                                                                                      _8250 = saturate(((_8197 + (_8229 * _8192)) + (_8231 * _8176)) * _8240);
                                                                                    }
                                                                                  }
                                                                                  _8251 = saturate(_8066);
                                                                                  _8253 = _8134 * _8134;
                                                                                  do {
                                                                                    _8263 = _8253;
                                                                                    if (_8140 > 0.0f) {
                                                                                      _8263 = saturate(((_8140 * _8140) / ((_8249 * 3.5999999046325684f) + 0.4000000059604645f)) + _8253);
                                                                                    }
                                                                                    do {
                                                                                      _8275 = _8263;
                                                                                      _8276 = 1.0f;
                                                                                      if (_8158) {
                                                                                        _8272 = (((_8138 * 0.25f) * ((sqrt(_8263) * 3.0f) + _8138)) / (_8249 + 0.0010000000474974513f)) + _8263;
                                                                                        _8275 = _8272;
                                                                                        _8276 = (_8263 / _8272);
                                                                                      }
                                                                                      do {
                                                                                        _8296 = _8276;
                                                                                        if (_8050 < 1.0f) {
                                                                                          _8283 = sqrt((1.000100016593933f - _8050) / max(9.999999974752427e-07f, (_8050 + 1.0f)));
                                                                                          _8296 = (sqrt(_8275 / ((((_8283 * 0.25f) * ((sqrt(_8275) * 3.0f) + _8283)) / (_8249 + 0.0010000000474974513f)) + _8275)) * _8276);
                                                                                        }
                                                                                        _8300 = (((_8263 * _8250) - _8250) * _8250) + 1.0f;
                                                                                        _8307 = exp2(log2(1.0f - saturate(_8249)) * 5.0f);
                                                                                        _8310 = saturate(abs(_8147) + 9.999999747378752e-06f);
                                                                                        _8311 = sqrt(_8263);
                                                                                        _8312 = 1.0f - _8311;
                                                                                        _8324 = saturate((dot(float3(_195, _196, _197), float3((_8142 * _8009), (_8142 * _8010), (_8142 * _8011))) + _6762) / (_6762 + 1.0f));
                                                                                        _8327 = ((_8296 * _8251) * (_8263 / (_8300 * _8300))) * (0.5f / ((((_8312 * _8310) + _8311) * _8251) + (((_8312 * _8251) + _8311) * _8310)));
                                                                                        _8328 = _7959 * _1679;
                                                                                        _8329 = _7960 * _1679;
                                                                                        _8330 = _7961 * _1679;
                                                                                        do {
                                                                                          _8369 = _1619;
                                                                                          _8370 = _1620;
                                                                                          _8371 = _1621;
                                                                                          if (_6759 > 0.0f) {
                                                                                            _8352 = (_6759 * _1375) * select(_8004, (_8000 * _1288), _8000);
                                                                                            _8369 = (((((_8328 * _1151) * _8352) * ((_8307 * (1.0f - _215)) + _215)) * _8327) + _1619);
                                                                                            _8370 = (((((_8329 * _1152) * _8352) * ((_8307 * (1.0f - _216)) + _216)) * _8327) + _1620);
                                                                                            _8371 = (((((_8330 * _1153) * _8352) * ((_8307 * (1.0f - _217)) + _217)) * _8327) + _1621);
                                                                                          }
                                                                                          _8856 = (((_8007 * _8328) * _8324) + _1616);
                                                                                          _8857 = (((_8007 * _8329) * _8324) + _1617);
                                                                                          _8858 = (((_8007 * _8330) * _8324) + _1618);
                                                                                          _8859 = (_8369 + (_7962 * _8328));
                                                                                          _8860 = (_8370 + (_7963 * _8329));
                                                                                          _8861 = (_8371 + (_7964 * _8330));
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
                                                                      _8856 = _1616;
                                                                      _8857 = _1617;
                                                                      _8858 = _1618;
                                                                      _8859 = _1619;
                                                                      _8860 = _1620;
                                                                      _8861 = _1621;
                                                                    }
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } else {
                                                                _8856 = _1616;
                                                                _8857 = _1617;
                                                                _8858 = _1618;
                                                                _8859 = _1619;
                                                                _8860 = _1620;
                                                                _8861 = _1621;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          if (_1662 == 10) {
                                                            _8383 = asfloat(srvLightInfoProperties.Load4(_1630)).x;
                                                            _8384 = asfloat(srvLightInfoProperties.Load4(_1630)).y;
                                                            _8385 = asfloat(srvLightInfoProperties.Load4(_1630)).z;
                                                            _8386 = asfloat(srvLightInfoProperties.Load4(_1630)).w;
                                                            _8389 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).x;
                                                            _8390 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).y;
                                                            _8391 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).z;
                                                            _8392 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 16u)))).w;
                                                            _8395 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).x;
                                                            _8396 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).y;
                                                            _8397 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).z;
                                                            _8398 = asfloat(srvLightInfoProperties.Load4(((int)(_1630 + 32u)))).w;
                                                            _8401 = asfloat(srvLightInfoProperties.Load2(((int)(_1630 + 72u)))).x;
                                                            _8402 = asfloat(srvLightInfoProperties.Load2(((int)(_1630 + 72u)))).y;
                                                            _8405 = asint(srvLightInfoProperties.Load(((int)(_1630 + 80u))));
                                                            _8408 = asint(srvLightInfoProperties.Load(((int)(_1630 + 84u))));
                                                            _8411 = asint(srvLightInfoProperties.Load(((int)(_1630 + 88u))));
                                                            _8414 = asint(srvLightInfoProperties.Load(((int)(_1630 + 96u))));
                                                            _8417 = f16tof32(_8405);
                                                            _8419 = f16tof32(((uint)((uint)(_8408) >> 16)));
                                                            _8420 = f16tof32(_8408);
                                                            _8422 = f16tof32(((uint)((uint)(_8411) >> 16)));
                                                            _8426 = ((float)((uint)((uint)(((uint)(_8411) >> 8) & 255)))) * 0.003921499941498041f;
                                                            _8428 = (float)((uint)((uint)(_8414 & 65535)));
                                                            _8432 = mad(_8385, _240, mad(_8384, _239, (_8383 * _238))) + _8386;
                                                            _8436 = mad(_8391, _240, mad(_8390, _239, (_8389 * _238))) + _8392;
                                                            _8440 = mad(_8397, _240, mad(_8396, _239, (_8395 * _238))) + _8398;
                                                            _8443 = mad(_8385, _197, mad(_8384, _196, (_8383 * _195)));
                                                            _8446 = mad(_8391, _197, mad(_8390, _196, (_8389 * _195)));
                                                            _8449 = mad(_8397, _197, mad(_8396, _196, (_8395 * _195)));
                                                            _8461 = -0.0f - mad(_8397, _458, mad(_8396, _460, (_8395 * _459)));
                                                            _8462 = _8401 * 0.5f;
                                                            _8463 = _8402 * 0.5f;
                                                            _8464 = -0.0f - _8462;
                                                            _8465 = -0.0f - _8463;
                                                            _8466 = _8464 - _8432;
                                                            _8467 = _8465 - _8436;
                                                            _8468 = -0.0f - _8440;
                                                            _8469 = _8462 - _8432;
                                                            _8470 = _8463 - _8436;
                                                            _8471 = dot(float3(_8432, _8436, _8440), float3(_8443, _8446, _8449));
                                                            _8473 = dot(float3(_8464, _8465, 0.0f), float3(_8443, _8446, _8449)) - _8471;
                                                            _8475 = dot(float3(_8462, _8465, 0.0f), float3(_8443, _8446, _8449)) - _8471;
                                                            _8477 = dot(float3(_8462, _8463, 0.0f), float3(_8443, _8446, _8449)) - _8471;
                                                            _8479 = dot(float3(_8464, _8463, 0.0f), float3(_8443, _8446, _8449)) - _8471;
                                                            _8480 = min(_8473, _8475);
                                                            do {
                                                              _8502 = 0.0f;
                                                              _8503 = 0.0f;
                                                              [branch]
                                                              if (!(!(_8480 >= 0.0f))) {
                                                                _8486 = rsqrt(dot(float3(_8469, _8467, _8468), float3(_8469, _8467, _8468)) * dot(float3(_8466, _8467, _8468), float3(_8466, _8467, _8468)));
                                                                _8488 = dot(float3(_8466, _8467, _8468), float3(_8469, _8467, _8468)) * _8486;
                                                                _8495 = rsqrt(max(((((_8488 * 0.09300000220537186f) + 0.5f) * _8488) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8486;
                                                                _8502 = (_8495 * (_8401 * _8468));
                                                                _8503 = (_8495 * (_8467 * (_8464 - _8462)));
                                                              }
                                                              do {
                                                                _8527 = 0.0f;
                                                                _8528 = _8503;
                                                                [branch]
                                                                if (!(!(min(_8475, _8477) >= 0.0f))) {
                                                                  _8510 = rsqrt(dot(float3(_8469, _8470, _8468), float3(_8469, _8470, _8468)) * dot(float3(_8469, _8467, _8468), float3(_8469, _8467, _8468)));
                                                                  _8512 = dot(float3(_8469, _8467, _8468), float3(_8469, _8470, _8468)) * _8510;
                                                                  _8519 = rsqrt(max(((((_8512 * 0.09300000220537186f) + 0.5f) * _8512) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8510;
                                                                  _8527 = (_8519 * ((_8465 - _8463) * _8468));
                                                                  _8528 = ((_8519 * (_8402 * _8469)) + _8503);
                                                                }
                                                                _8529 = min(_8477, _8479);
                                                                do {
                                                                  _8553 = _8502;
                                                                  _8554 = _8528;
                                                                  [branch]
                                                                  if (!(!(_8529 >= 0.0f))) {
                                                                    _8535 = rsqrt(dot(float3(_8466, _8470, _8468), float3(_8466, _8470, _8468)) * dot(float3(_8469, _8470, _8468), float3(_8469, _8470, _8468)));
                                                                    _8537 = dot(float3(_8469, _8470, _8468), float3(_8466, _8470, _8468)) * _8535;
                                                                    _8544 = rsqrt(max(((((_8537 * 0.09300000220537186f) + 0.5f) * _8537) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8535;
                                                                    _8553 = ((_8544 * ((_8464 - _8462) * _8468)) + _8502);
                                                                    _8554 = ((_8544 * (_8401 * _8470)) + _8528);
                                                                  }
                                                                  do {
                                                                    _8579 = _8527;
                                                                    _8580 = _8554;
                                                                    [branch]
                                                                    if (!(!(min(_8479, _8473) >= 0.0f))) {
                                                                      _8561 = rsqrt(dot(float3(_8466, _8467, _8468), float3(_8466, _8467, _8468)) * dot(float3(_8466, _8470, _8468), float3(_8466, _8470, _8468)));
                                                                      _8563 = dot(float3(_8466, _8470, _8468), float3(_8466, _8467, _8468)) * _8561;
                                                                      _8570 = rsqrt(max(((((_8563 * 0.09300000220537186f) + 0.5f) * _8563) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8561;
                                                                      _8579 = ((_8570 * (_8402 * _8468)) + _8527);
                                                                      _8580 = ((_8570 * (_8466 * (_8465 - _8463))) + _8554);
                                                                    }
                                                                    do {
                                                                      _8723 = _8579;
                                                                      _8724 = _8553;
                                                                      _8725 = _8580;
                                                                      if (min(_8480, _8529) < 0.0f) {
                                                                        [branch]
                                                                        if (!(!(max(max(_8473, _8475), max(_8477, _8479)) >= 0.0f))) {
                                                                          _8589 = -0.0f - _8443;
                                                                          _8590 = _8471 / _8446;
                                                                          _8591 = _8464 / _8446;
                                                                          _8592 = _8462 / _8446;
                                                                          _8594 = (_8465 - _8590) / _8589;
                                                                          _8596 = (_8463 - _8590) / _8589;
                                                                          _8597 = min(_8591, _8592);
                                                                          _8598 = max(_8591, _8592);
                                                                          _8599 = min(_8594, _8596);
                                                                          _8600 = max(_8594, _8596);
                                                                          _8601 = max(_8597, _8599);
                                                                          _8602 = min(_8598, _8600);
                                                                          _8603 = _8601 * _8446;
                                                                          _8605 = _8602 * _8446;
                                                                          _8607 = _8603 - _8432;
                                                                          _8608 = _8590 - _8436;
                                                                          _8609 = _8608 + (_8601 * _8589);
                                                                          _8610 = _8605 - _8432;
                                                                          _8611 = _8608 + (_8602 * _8589);
                                                                          _8612 = dot(float3(_8607, _8609, _8468), float3(_8607, _8609, _8468));
                                                                          _8613 = dot(float3(_8610, _8611, _8468), float3(_8610, _8611, _8468));
                                                                          _8615 = rsqrt(_8613 * _8612);
                                                                          _8617 = dot(float3(_8607, _8609, _8468), float3(_8610, _8611, _8468)) * _8615;
                                                                          _8624 = rsqrt(max(((((_8617 * 0.09300000220537186f) + 0.5f) * _8617) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8615;
                                                                          _8637 = (_8597 > _8599);
                                                                          _8639 = select(_8637, _8446, _8443);
                                                                          _8645 = float((int)(((int)(uint)((int)(_8639 > 0.0f))) - ((int)(uint)((int)(_8639 < 0.0f)))));
                                                                          _8649 = ((1.0f - (((float)((bool)_8637)) * 2.0f)) * _8462) * _8645;
                                                                          _8651 = _8649 - _8432;
                                                                          _8652 = (_8645 * _8463) - _8436;
                                                                          _8653 = (_8598 < _8600);
                                                                          _8655 = select(_8653, _8446, _8443);
                                                                          _8661 = float((int)(((int)(uint)((int)(_8655 > 0.0f))) - ((int)(uint)((int)(_8655 < 0.0f)))));
                                                                          _8662 = _8661 * _8462;
                                                                          _8667 = _8662 - _8432;
                                                                          _8668 = ((((((float)((bool)_8653)) * 2.0f) + -1.0f) * _8463) * _8661) - _8436;
                                                                          _8671 = rsqrt(_8612 * dot(float3(_8651, _8652, _8468), float3(_8651, _8652, _8468)));
                                                                          _8673 = dot(float3(_8651, _8652, _8468), float3(_8607, _8609, _8468)) * _8671;
                                                                          _8680 = rsqrt(max(((((_8673 * 0.09300000220537186f) + 0.5f) * _8673) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8671;
                                                                          _8693 = rsqrt(dot(float3(_8667, _8668, _8468), float3(_8667, _8668, _8468)) * _8613);
                                                                          _8695 = dot(float3(_8610, _8611, _8468), float3(_8667, _8668, _8468)) * _8693;
                                                                          _8702 = rsqrt(max(((((_8695 * 0.09300000220537186f) + 0.5f) * _8695) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8693;
                                                                          _8723 = ((((_8624 * (((_8601 - _8602) * _8589) * _8468)) + _8579) + (_8680 * ((_8652 - _8609) * _8468))) + (_8702 * ((_8611 - _8668) * _8468)));
                                                                          _8724 = ((((_8624 * ((_8446 * (_8602 - _8601)) * _8468)) + _8553) + (_8680 * ((_8603 - _8649) * _8468))) + (_8702 * ((_8662 - _8605) * _8468)));
                                                                          _8725 = ((((_8624 * ((_8611 * _8607) - (_8610 * _8609))) + _8580) + (_8680 * ((_8651 * _8609) - (_8652 * _8607)))) + (_8702 * ((_8668 * _8610) - (_8667 * _8611))));
                                                                        } else {
                                                                          _8723 = _8579;
                                                                          _8724 = _8553;
                                                                          _8725 = _8580;
                                                                        }
                                                                      }
                                                                      _8731 = sqrt(((_8724 * _8724) + (_8723 * _8723)) + (_8725 * _8725));
                                                                      _8732 = _8731 * 0.15915493667125702f;
                                                                      [branch]
                                                                      if (!(_8732 == 0.0f)) {
                                                                        _8741 = saturate((_8732 - _8417) / (1.0f - _8417)) * ((float)((bool)(uint)(_8440 <= 0.0f)));
                                                                        [branch]
                                                                        if (!(_8741 == 0.0f)) {
                                                                          do {
                                                                            _8749 = 0.0f;
                                                                            if (_8731 > 0.0f) {
                                                                              _8749 = (dot(float3(_8443, _8446, _8449), float3(_8723, _8724, _8725)) / _8731);
                                                                            }
                                                                            _8750 = 1.0f - _223;
                                                                            _8751 = _8750 * _8750;
                                                                            _8757 = exp2(log2(1.0f - saturate(dot(float3(_195, _196, _197), float3(_459, _460, _458)))) * 5.0f);
                                                                            _8762 = min(_223, 0.800000011920929f);
                                                                            _8771 = exp2(((((((_8762 * 3.322999954223633f) + -3.7669999599456787f) * _8762) + -0.3479999899864197f) * _8762) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                                                            _8778 = _8468 / (_8461 - ((_8449 * 2.0f) * dot(float3((-0.0f - mad(_8385, _458, mad(_8384, _460, (_8383 * _459)))), (-0.0f - mad(_8391, _458, mad(_8390, _460, (_8389 * _459)))), _8461), float3(_8443, _8446, _8449))));
                                                                            _8781 = (_8778 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8771) * saturate((_223 + -0.5f) * 2.500000238418579f)) + _8771);
                                                                            _8789 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8428), ((log2((_8781 * _8781) * f16tof32(((uint)((uint)(_8405) >> 16)))) * 0.5f) + 5.5f));
                                                                            _8791 = (float)((bool)(uint)(_8778 > 0.0f));
                                                                            _8792 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8428), 10.0f);
                                                                            _8801 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8741 * _1288), _8741);
                                                                            do {
                                                                              _8840 = _1619;
                                                                              _8841 = _1620;
                                                                              _8842 = _1621;
                                                                              if (_8426 > 0.0f) {
                                                                                _8819 = _8426 * _1375;
                                                                                _8820 = _8801 * _1679;
                                                                                _8840 = ((((((_8819 * _8419) * _8791) * _8789.x) * _8820) * (((max(_8751, _215) - _215) * _8757) + _215)) + _1619);
                                                                                _8841 = ((((((_8819 * _8420) * _8791) * _8789.y) * _8820) * (((max(_8751, _216) - _216) * _8757) + _216)) + _1620);
                                                                                _8842 = ((((((_8422 * _8819) * _8791) * _8789.z) * _8820) * (((max(_8751, _217) - _217) * _8757) + _217)) + _1621);
                                                                              }
                                                                              _8848 = ((_1679 * 5.4256415367126465f) * _8749) * _8801;
                                                                              _8856 = (((_8792.x * _8419) * _8848) + _1616);
                                                                              _8857 = (((_8792.y * _8420) * _8848) + _1617);
                                                                              _8858 = (((_8792.z * _8422) * _8848) + _1618);
                                                                              _8859 = _8840;
                                                                              _8860 = _8841;
                                                                              _8861 = _8842;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } else {
                                                                          _8856 = _1616;
                                                                          _8857 = _1617;
                                                                          _8858 = _1618;
                                                                          _8859 = _1619;
                                                                          _8860 = _1620;
                                                                          _8861 = _1621;
                                                                        }
                                                                      } else {
                                                                        _8856 = _1616;
                                                                        _8857 = _1617;
                                                                        _8858 = _1618;
                                                                        _8859 = _1619;
                                                                        _8860 = _1620;
                                                                        _8861 = _1621;
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
                                                            _8856 = _1616;
                                                            _8857 = _1617;
                                                            _8858 = _1618;
                                                            _8859 = _1619;
                                                            _8860 = _1620;
                                                            _8861 = _1621;
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            } else {
                                              _8856 = _1616;
                                              _8857 = _1617;
                                              _8858 = _1618;
                                              _8859 = _1619;
                                              _8860 = _1620;
                                              _8861 = _1621;
                                            }
                                          }
                                          _8862 = _1622 + 1u;
                                          do {
                                            if (!(_8862 == _global_2)) {
                                              _1616 = _8856;
                                              _1617 = _8857;
                                              _1618 = _8858;
                                              _1619 = _8859;
                                              _1620 = _8860;
                                              _1621 = _8861;
                                              _1622 = _8862;
                                              _loop_break_3 = true;
                                              break;
                                            }
                                            _8866 = _8856;
                                            _8867 = _8857;
                                            _8868 = _8858;
                                            _8869 = _8859;
                                            _8870 = _8860;
                                            _8871 = _8861;
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
                                    _8873 = rsqrt(dot(float3(_136, _137, -1.0f), float3(_136, _137, -1.0f)));
                                    _8880 = 1.0f - _223;
                                    _8891 = (1.0f - _231) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_195, _196, _197), float3((-0.0f - (_136 * _8873)), (-0.0f - (_137 * _8873)), _8873))))) * 5.0f) * (max((_8880 * _8880), _231) - _231));
                                    _9031 = (_8891 * _8866);
                                    _9032 = (_8891 * _8867);
                                    _9033 = (_8891 * _8868);
                                    _9034 = _8869;
                                    _9035 = _8870;
                                    _9036 = _8871;
                                    _9037 = (_451 * _161);
                                    _9038 = (_451 * _162);
                                    _9039 = (_451 * _163);
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
        _8910 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _137, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _136)));
        _8913 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _137, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _136)));
        _8916 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _137, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _136)));
        do {
          [branch]
          if (!(cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0)) {
            _8937 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8910, _8913, _8916), 0.0f);
            _8941 = _8937.x * 32.0f;
            _8942 = _8937.y * 32.0f;
            _8943 = _8937.z * 32.0f;
            _8945 = rsqrt(dot(float3(_8910, _8913, _8916), float3(_8910, _8913, _8916)));
            _8946 = _8945 * _8910;
            _8947 = _8945 * _8913;
            _8948 = _8945 * _8916;
            _8949 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
            _8950 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
            _8951 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
            _8952 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
            _8953 = dot(float3(_8946, _8947, _8948), float3(_8950, _8951, _8952));
            _8958 = (_8953 * _8953) - (dot(float3(_8950, _8951, _8952), float3(_8950, _8951, _8952)) - (_8949 * _8949));
            if ((_8953 > -0.0f) && (_8958 > 0.0f)) {
              _8963 = -0.0f - cbDeferredShading.vSunDirWS.z;
              _8976 = 74.80000305175781f / ((dot(float3(_8946, _8947, _8948), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8949) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
              _8984 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8946, _8948), float2(_8963, cbDeferredShading.vSunDirWS.x)) * _8976) + 0.5f), ((dot(float3(_8946, _8947, _8948), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8963)), (cbDeferredShading.vSunDirWS.y * _8963))) * _8976) + 0.5f)), 0.0f);
              _8986 = _8958 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
              if (_8986 > 0.0f) {
                _8993 = saturate(_8986 * 5.0f);
                _9020 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8984.x) * _8993) + _8941);
                _9021 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8984.y) * _8993) + _8942);
                _9022 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8984.z) * _8993) + _8943);
              } else {
                _9020 = _8941;
                _9021 = _8942;
                _9022 = _8943;
              }
            } else {
              _9020 = _8941;
              _9021 = _8942;
              _9022 = _8943;
            }
          } else {
            _9020 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
            _9021 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
            _9022 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
          }
          _9026 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
          _9031 = 0.0f;
          _9032 = 0.0f;
          _9033 = 0.0f;
          _9034 = select(_9026, 0.0f, _9020);
          _9035 = select(_9026, 0.0f, _9021);
          _9036 = select(_9026, 0.0f, _9022);
          _9037 = 0.0f;
          _9038 = 0.0f;
          _9039 = 0.0f;
        } while (false);
      }
      uavDeferredShadingPass_Specular[int2(_65, _66)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_9037 * _9031) + _9034)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_9038 * _9032) + _9035)), 7936.0f), 5.960464477539063e-08f), max(min((((_9039 * _9033) + _9036) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_65, _66)] = float3(0.0f, 0.0f, 0.0f);
    } while (false);
  }
}
