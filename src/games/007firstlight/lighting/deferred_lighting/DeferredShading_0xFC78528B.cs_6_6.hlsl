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
  uint _51;
  int _57;
  uint _62;
  uint _63;
  uint _70;
  int _73;
  int _88;
  float _243;
  float _244;
  float _245;
  float _246;
  float _336;
  float _337;
  float _375;
  int _490;
  float _491;
  float _492;
  float _493;
  float _494;
  float _495;
  float _496;
  float _497;
  float _498;
  float _499;
  float _500;
  float _501;
  float _502;
  float _503;
  float _504;
  float _619;
  float _620;
  float _621;
  float _708;
  float _709;
  float _710;
  float _728;
  float _729;
  float _730;
  float _762;
  float _763;
  float _764;
  float _765;
  float _766;
  float _767;
  float _768;
  float _782;
  float _783;
  float _784;
  float _785;
  float _786;
  float _787;
  float _788;
  float _789;
  float _790;
  float _791;
  float _792;
  float _793;
  float _794;
  float _795;
  float _800;
  float _801;
  float _802;
  float _803;
  float _804;
  float _805;
  float _806;
  float _807;
  float _808;
  float _809;
  float _810;
  float _811;
  float _812;
  float _813;
  float _862;
  float _863;
  float _864;
  float _884;
  float _885;
  float _886;
  float _897;
  float _898;
  float _899;
  float _900;
  float _901;
  float _902;
  float _905;
  float _906;
  float _907;
  float _908;
  float _909;
  float _910;
  float _911;
  float _925;
  float _926;
  float _927;
  float _928;
  float _929;
  float _930;
  float _959;
  float _960;
  float _961;
  float _981;
  float _982;
  float _983;
  float _994;
  float _995;
  float _996;
  float _997;
  float _998;
  float _999;
  float _1018;
  float _1019;
  float _1020;
  float _1021;
  float _1022;
  float _1023;
  float _1042;
  float _1043;
  float _1044;
  int _1075;
  float _1076;
  float _1194;
  float _1199;
  float _1212;
  float _1265;
  float _1266;
  float _1267;
  float _1320;
  float _1321;
  float _1322;
  float _1432;
  float _1437;
  float _1438;
  float _1439;
  float _1440;
  float _1441;
  float _1442;
  int _1443;
  float _2063;
  float _2064;
  float _2065;
  float _2155;
  float _2164;
  float _2173;
  float _2181;
  float _2252;
  float _2261;
  float _2270;
  float _2278;
  float _2351;
  float _2360;
  float _2369;
  float _2377;
  float _2450;
  float _2459;
  float _2468;
  float _2476;
  float _2528;
  float _2533;
  float _2630;
  float _2651;
  float _2652;
  float _2653;
  int _2672;
  float _2689;
  float _2693;
  float _2732;
  float _2764;
  float _2874;
  float _2875;
  float _2887;
  float _2899;
  float _2962;
  float _3053;
  float _3054;
  float _3055;
  float _3084;
  float _3194;
  float _3195;
  float _3207;
  float _3219;
  float _3274;
  float _3275;
  float _3276;
  float _3307;
  float _3336;
  float _3337;
  float _3338;
  float _3354;
  float _3355;
  float _3356;
  float _3369;
  float _3370;
  float _3371;
  float _3532;
  float _3533;
  float _3534;
  float _3535;
  float _3536;
  float _3537;
  float _3629;
  float _3630;
  float _3631;
  float _3632;
  float _3633;
  float _3736;
  float _3745;
  float _3754;
  float _3762;
  float _3833;
  float _3842;
  float _3851;
  float _3859;
  float _3932;
  float _3941;
  float _3950;
  float _3958;
  float _4031;
  float _4040;
  float _4049;
  float _4057;
  float _4392;
  float _4393;
  int _4394;
  float _4423;
  float _4424;
  float _4425;
  float _4426;
  float _4427;
  float _4529;
  float _4538;
  float _4547;
  float _4555;
  float _4626;
  float _4635;
  float _4644;
  float _4652;
  float _4725;
  float _4734;
  float _4743;
  float _4751;
  float _4824;
  float _4833;
  float _4842;
  float _4850;
  float _5184;
  float _5185;
  bool _5186;
  float _5201;
  float _5202;
  float _5203;
  float _5261;
  float _5262;
  float _5287;
  float _5288;
  float _5383;
  float _5386;
  float _5387;
  float _5407;
  float _5408;
  float _5409;
  int _5427;
  float _5444;
  float _5448;
  float _5475;
  float _5476;
  float _5477;
  float _5508;
  float _5537;
  float _5538;
  float _5539;
  float _5555;
  float _5556;
  float _5557;
  float _5593;
  float _5641;
  float _5642;
  float _5643;
  float _5659;
  float _5719;
  float _5720;
  float _5721;
  float _5842;
  float _5843;
  float _5856;
  float _5868;
  float _5869;
  float _5889;
  float _6067;
  float _6638;
  float _6639;
  float _6640;
  float _6730;
  float _6739;
  float _6748;
  float _6756;
  float _6827;
  float _6836;
  float _6845;
  float _6853;
  float _6926;
  float _6935;
  float _6944;
  float _6952;
  float _7025;
  float _7034;
  float _7043;
  float _7051;
  float _7103;
  float _7108;
  float _7109;
  float _7206;
  float _7207;
  float _7228;
  float _7229;
  float _7230;
  int _7249;
  float _7266;
  float _7274;
  float _7300;
  float _7301;
  float _7302;
  float _7333;
  float _7362;
  float _7363;
  float _7364;
  float _7380;
  float _7381;
  float _7382;
  float _7418;
  float _7466;
  float _7467;
  float _7468;
  float _7484;
  float _7544;
  float _7545;
  float _7546;
  float _7667;
  float _7668;
  float _7681;
  float _7693;
  float _7694;
  float _7714;
  float _7902;
  float _7903;
  float _7927;
  float _7928;
  float _7953;
  float _7954;
  float _7979;
  float _7980;
  float _8123;
  float _8124;
  float _8125;
  float _8149;
  float _8231;
  float _8232;
  float _8233;
  float _8247;
  float _8248;
  float _8249;
  float _8250;
  float _8251;
  float _8252;
  float _8257;
  float _8258;
  float _8259;
  float _8260;
  float _8261;
  float _8262;
  float _8410;
  float _8411;
  float _8412;
  float _8421;
  float _8422;
  float _8423;
  float _8424;
  float _8425;
  float _8426;
  float _8427;
  float _8428;
  float _8429;
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
  float _183;
  float _184;
  float _185;
  float _186;
  float _195;
  float _206;
  float _207;
  float _208;
  float _209;
  int _215;
  uint _219;
  float _225;
  float4 _234;
  float _255;
  float _256;
  float _271;
  float _272;
  float _275;
  float _276;
  float _279;
  float _280;
  float4 _285;
  float _319;
  float _321;
  bool _322;
  float _324;
  float _326;
  bool _327;
  float4 _340;
  float _344;
  float _356;
  float _357;
  float _358;
  float _359;
  float _360;
  float _361;
  float _376;
  float _377;
  float _379;
  float _380;
  float _381;
  int _389;
  int _390;
  int _391;
  int _392;
  float _396;
  float _398;
  float _399;
  float _409;
  float _414;
  float _418;
  float _419;
  float _422;
  float _435;
  float _436;
  float _437;
  float _441;
  float _456;
  float _459;
  float _462;
  float _465;
  float _468;
  float _471;
  int _507;
  int _508;
  float _511;
  float _512;
  float _513;
  float _514;
  float _517;
  float _518;
  float _519;
  float _520;
  float _523;
  float _524;
  float _525;
  float _526;
  float _529;
  float _530;
  float _531;
  float _532;
  float _535;
  float _536;
  float _537;
  float _538;
  float _541;
  float _542;
  float _543;
  float _544;
  int _547;
  float _550;
  float _551;
  float _552;
  float _555;
  float _556;
  float _557;
  int _560;
  int _563;
  int _566;
  float _595;
  float _598;
  float _601;
  float _602;
  float4 _608;
  float4 _614;
  float _623;
  float _627;
  float _630;
  float _633;
  float _674;
  float _679;
  float _681;
  float _683;
  float _690;
  float _691;
  float4 _697;
  float4 _703;
  float _711;
  float4 _717;
  float4 _723;
  float _740;
  float _741;
  float _742;
  float _743;
  float _744;
  float _745;
  float _746;
  float _747;
  float _748;
  uint _796;
  bool _819;
  int _829;
  float _831;
  float _832;
  float _839;
  float _844;
  float _845;
  bool _846;
  float4 _851;
  float4 _857;
  float _868;
  float4 _873;
  float4 _879;
  float _917;
  int _937;
  float _938;
  float _941;
  float _942;
  bool _943;
  float4 _948;
  float4 _954;
  float _965;
  float4 _970;
  float4 _976;
  float _1004;
  float4 _1060;
  float _1063;
  float _1068;
  float _1070;
  float _1071;
  uint _1077;
  int _1080;
  int _1081;
  int _1085;
  int _1089;
  float _1101;
  float _1106;
  float _1107;
  float _1108;
  float _1109;
  float _1112;
  float _1113;
  float _1114;
  float _1115;
  float _1118;
  float _1119;
  float _1120;
  float _1121;
  int _1124;
  int _1127;
  int _1130;
  int _1133;
  float _1148;
  float _1152;
  float _1156;
  float _1181;
  float _1182;
  float _1183;
  float _1186;
  uint _1195;
  float _1201;
  float _1203;
  float _1205;
  int _1215;
  int _1218;
  int _1219;
  int _1220;
  int _1226;
  int _1227;
  int _1228;
  int _1234;
  int _1235;
  int _1236;
  float _1242;
  float _1246;
  float _1250;
  float _1257;
  int _1270;
  int _1273;
  int _1274;
  int _1275;
  int _1281;
  int _1282;
  int _1283;
  int _1289;
  int _1290;
  int _1291;
  float _1297;
  float _1301;
  float _1305;
  float _1312;
  float _1345;
  float _1349;
  float _1353;
  float _1372;
  float _1376;
  float _1380;
  float _1393;
  float _1394;
  float _1395;
  uint _1433;
  int _1445;
  int _1449;
  int _1450;
  int _1451;
  int _1452;
  int _1463;
  int _1467;
  float _1479;
  int _1482;
  float _1499;
  float _1504;
  float _1505;
  float _1506;
  float _1507;
  float _1510;
  float _1511;
  float _1512;
  float _1513;
  float _1516;
  float _1517;
  float _1518;
  float _1519;
  int _1522;
  int _1525;
  int _1528;
  int _1531;
  int _1534;
  float _1536;
  float _1537;
  float _1539;
  float _1543;
  float _1556;
  float _1560;
  float _1564;
  float _1589;
  float _1590;
  float _1591;
  float _1594;
  float _1595;
  float _1602;
  float _1623;
  float _1624;
  float _1625;
  float _1626;
  float _1629;
  float _1630;
  float _1631;
  float _1632;
  float _1635;
  float _1636;
  float _1637;
  float _1638;
  float _1641;
  float _1642;
  float _1643;
  float _1646;
  int _1649;
  int _1652;
  int _1655;
  int _1658;
  int _1661;
  float _1664;
  float _1665;
  float _1666;
  float _1667;
  int _1670;
  int _1673;
  int _1676;
  int _1679;
  int _1682;
  int _1685;
  int _1688;
  int _1691;
  float _1693;
  float _1694;
  float _1696;
  float _1700;
  float _1703;
  float _1705;
  int _1708;
  float _1718;
  float _1719;
  float _1721;
  float _1722;
  float _1723;
  float _1724;
  float _1743;
  float _1747;
  float _1748;
  float _1749;
  float _1753;
  float _1757;
  float _1761;
  float _1762;
  float _1785;
  float _1786;
  float _1787;
  float _1790;
  float _1791;
  float _1798;
  float _1799;
  float _1800;
  float _1805;
  float _1807;
  float _1808;
  float _1811;
  float _1815;
  float _1824;
  float _1825;
  float _1826;
  int _1827;
  float _1832;
  float _1841;
  float _1842;
  float _1844;
  float4 _1849;
  float _1854;
  float _1856;
  float _1858;
  float _1860;
  float _1864;
  float _1866;
  float _1870;
  float _1872;
  int _1879;
  float _1884;
  float _1893;
  float _1894;
  float4 _1900;
  float _1905;
  float _1907;
  float _1911;
  float _1913;
  float _1917;
  float _1919;
  float _1923;
  float _1925;
  int _1932;
  float _1937;
  float _1946;
  float _1947;
  float4 _1953;
  float _1958;
  float _1960;
  float _1964;
  float _1966;
  float _1970;
  float _1972;
  float _1976;
  float _1978;
  int _1985;
  float _1990;
  float _1999;
  float _2000;
  float4 _2006;
  float _2011;
  float _2013;
  float _2017;
  float _2019;
  float _2023;
  float _2025;
  float _2029;
  float _2031;
  float _2032;
  float _2043;
  float _2049;
  float _2051;
  float _2053;
  float _2060;
  float _2068;
  float _2069;
  float _2078;
  float _2082;
  float _2091;
  float _2092;
  float _2093;
  float _2098;
  int _2099;
  float _2104;
  float _2113;
  float _2114;
  float _2116;
  float _2118;
  float _2119;
  float4 _2121;
  float _2125;
  float _2126;
  float _2129;
  float _2130;
  float _2135;
  float _2136;
  float _2139;
  float _2140;
  float _2142;
  float _2144;
  bool _2145;
  bool _2146;
  bool _2156;
  bool _2165;
  float _2182;
  float _2184;
  float _2186;
  float _2188;
  float _2192;
  float _2194;
  float _2198;
  float _2200;
  int _2207;
  float _2212;
  float _2221;
  float _2222;
  float _2225;
  float _2226;
  float4 _2228;
  float _2232;
  float _2233;
  float _2236;
  float _2237;
  float _2239;
  float _2241;
  bool _2242;
  bool _2243;
  bool _2253;
  bool _2262;
  float _2279;
  float _2281;
  float _2285;
  float _2287;
  float _2291;
  float _2293;
  float _2297;
  float _2299;
  int _2306;
  float _2311;
  float _2320;
  float _2321;
  float _2324;
  float _2325;
  float4 _2327;
  float _2331;
  float _2332;
  float _2335;
  float _2336;
  float _2338;
  float _2340;
  bool _2341;
  bool _2342;
  bool _2352;
  bool _2361;
  float _2378;
  float _2380;
  float _2384;
  float _2386;
  float _2390;
  float _2392;
  float _2396;
  float _2398;
  int _2405;
  float _2410;
  float _2419;
  float _2420;
  float _2423;
  float _2424;
  float4 _2426;
  float _2430;
  float _2431;
  float _2434;
  float _2435;
  float _2437;
  float _2439;
  bool _2440;
  bool _2441;
  bool _2451;
  bool _2460;
  float _2477;
  float _2479;
  float _2483;
  float _2485;
  float _2489;
  float _2491;
  float _2495;
  float _2497;
  float _2498;
  float _2509;
  float _2515;
  float _2517;
  float _2519;
  float _2539;
  float4 _2546;
  float _2560;
  float _2561;
  float _2562;
  float _2563;
  float _2565;
  float _2570;
  float _2573;
  float _2574;
  float _2576;
  float _2577;
  float _2582;
  float _2587;
  float _2589;
  float _2592;
  float _2593;
  float _2598;
  float _2600;
  float _2602;
  float _2604;
  float _2609;
  float _2615;
  float _2617;
  float3 _2643;
  float _2654;
  float4 _2675;
  int _2703;
  int _2708;
  int _2710;
  int _2711;
  int _2713;
  int _2714;
  int _2723;
  bool _2736;
  float _2739;
  float _2741;
  float _2742;
  float _2743;
  float _2744;
  float _2745;
  float _2746;
  float _2754;
  float _2759;
  float _2765;
  float _2769;
  float _2771;
  float _2772;
  float _2773;
  float _2776;
  bool _2783;
  float _2787;
  float _2789;
  float _2790;
  float _2798;
  float _2801;
  float _2802;
  float _2807;
  float _2816;
  float _2817;
  float _2820;
  float _2822;
  float _2823;
  float _2824;
  float _2826;
  float _2827;
  float _2828;
  float _2829;
  float _2834;
  float _2848;
  float _2853;
  float _2854;
  float _2856;
  float _2862;
  float _2865;
  float _2876;
  float _2877;
  float _2888;
  float _2903;
  float _2908;
  float _2909;
  float _2921;
  float _2924;
  float _2925;
  float _2926;
  float _2927;
  float _2934;
  float _2935;
  float _2936;
  float _2944;
  float _2945;
  float _2965;
  float _2966;
  float _2967;
  float _2968;
  float _2971;
  float _2972;
  float _2973;
  float _2974;
  float _2977;
  float _2978;
  float _2979;
  int _2982;
  int _2985;
  int _2988;
  int _2991;
  int _2994;
  int _2997;
  float _3001;
  float _3004;
  float _3006;
  int _3008;
  float2 _3028;
  float3 _3045;
  float _3058;
  float _3061;
  float _3062;
  float _3063;
  float _3064;
  float _3065;
  float _3066;
  float _3074;
  float _3079;
  float _3085;
  float _3089;
  float _3091;
  float _3092;
  float _3093;
  float _3096;
  bool _3103;
  float _3107;
  float _3109;
  float _3110;
  float _3118;
  float _3121;
  float _3122;
  float _3127;
  float _3136;
  float _3137;
  float _3140;
  float _3142;
  float _3143;
  float _3144;
  float _3146;
  float _3147;
  float _3148;
  float _3149;
  float _3154;
  float _3168;
  float _3173;
  float _3174;
  float _3176;
  float _3182;
  float _3185;
  float _3196;
  float _3197;
  float _3208;
  float _3223;
  float _3235;
  float _3236;
  float _3248;
  float _3264;
  bool _3277;
  float _3278;
  float _3279;
  float _3280;
  bool _3281;
  float _3283;
  float _3284;
  float _3288;
  float _3294;
  float _3308;
  float _3309;
  float _3312;
  float _3316;
  int _3317;
  float _3319;
  float _3321;
  float _3324;
  float _3328;
  float _3339;
  float _3340;
  float _3341;
  float _3343;
  float _3357;
  float _3358;
  float _3359;
  float _3375;
  float _3376;
  float _3377;
  float _3381;
  float _3393;
  float _3394;
  float _3395;
  float _3398;
  float _3399;
  float _3400;
  float _3403;
  float _3404;
  float _3405;
  float _3408;
  float _3409;
  float _3410;
  float _3413;
  float _3414;
  float _3415;
  int _3418;
  int _3421;
  int _3424;
  int _3427;
  int _3430;
  int _3433;
  int _3436;
  int _3439;
  int _3442;
  int _3445;
  int _3448;
  float _3451;
  float _3452;
  float _3453;
  float _3454;
  int _3457;
  int _3460;
  int _3463;
  int _3466;
  float _3468;
  float _3469;
  float _3471;
  float _3475;
  float _3478;
  float _3479;
  float _3481;
  float _3485;
  float _3487;
  float _3488;
  float _3490;
  int _3493;
  bool _3497;
  float _3505;
  float _3506;
  float _3508;
  float _3511;
  float _3512;
  float _3514;
  float _3515;
  float _3517;
  float _3518;
  float _3522;
  float _3528;
  float _3529;
  float _3530;
  float _3541;
  float _3542;
  float _3543;
  float _3544;
  float _3545;
  float _3546;
  float _3547;
  float _3548;
  float _3549;
  float _3552;
  float _3553;
  float _3554;
  float _3557;
  float _3564;
  float _3577;
  float _3581;
  float _3585;
  float _3586;
  float _3587;
  float _3590;
  float _3593;
  bool _3595;
  float _3601;
  float _3602;
  float _3603;
  float _3608;
  float _3609;
  float _3610;
  bool _3614;
  bool _3620;
  bool _3624;
  float _3634;
  float _3638;
  float _3647;
  float _3648;
  float _3655;
  float _3656;
  float _3659;
  float _3663;
  float _3672;
  float _3673;
  float _3674;
  float _3679;
  int _3680;
  float _3685;
  float _3694;
  float _3695;
  float _3697;
  float _3699;
  float _3700;
  float4 _3702;
  float _3706;
  float _3707;
  float _3710;
  float _3711;
  float _3716;
  float _3717;
  float _3720;
  float _3721;
  float _3723;
  float _3725;
  bool _3726;
  bool _3727;
  bool _3737;
  bool _3746;
  float _3763;
  float _3765;
  float _3767;
  float _3769;
  float _3773;
  float _3775;
  float _3779;
  float _3781;
  int _3788;
  float _3793;
  float _3802;
  float _3803;
  float _3806;
  float _3807;
  float4 _3809;
  float _3813;
  float _3814;
  float _3817;
  float _3818;
  float _3820;
  float _3822;
  bool _3823;
  bool _3824;
  bool _3834;
  bool _3843;
  float _3860;
  float _3862;
  float _3866;
  float _3868;
  float _3872;
  float _3874;
  float _3878;
  float _3880;
  int _3887;
  float _3892;
  float _3901;
  float _3902;
  float _3905;
  float _3906;
  float4 _3908;
  float _3912;
  float _3913;
  float _3916;
  float _3917;
  float _3919;
  float _3921;
  bool _3922;
  bool _3923;
  bool _3933;
  bool _3942;
  float _3959;
  float _3961;
  float _3965;
  float _3967;
  float _3971;
  float _3973;
  float _3977;
  float _3979;
  int _3986;
  float _3991;
  float _4000;
  float _4001;
  float _4004;
  float _4005;
  float4 _4007;
  float _4011;
  float _4012;
  float _4015;
  float _4016;
  float _4018;
  float _4020;
  bool _4021;
  bool _4022;
  bool _4032;
  bool _4041;
  float _4058;
  float _4060;
  float _4064;
  float _4066;
  float _4070;
  float _4072;
  float _4076;
  float _4078;
  float _4079;
  float _4090;
  float _4096;
  float _4098;
  float _4100;
  float _4109;
  float _4112;
  float _4113;
  float _4127;
  float _4128;
  float _4129;
  float _4133;
  float _4142;
  float _4143;
  float _4144;
  int _4145;
  float _4150;
  float _4159;
  float _4160;
  float _4162;
  float4 _4167;
  float _4172;
  float _4174;
  float _4176;
  float _4178;
  float _4182;
  float _4184;
  float _4188;
  float _4190;
  int _4197;
  float _4202;
  float _4211;
  float _4212;
  float4 _4218;
  float _4223;
  float _4225;
  float _4229;
  float _4231;
  float _4235;
  float _4237;
  float _4241;
  float _4243;
  int _4250;
  float _4255;
  float _4264;
  float _4265;
  float4 _4271;
  float _4276;
  float _4278;
  float _4282;
  float _4284;
  float _4288;
  float _4290;
  float _4294;
  float _4296;
  int _4303;
  float _4308;
  float _4317;
  float _4318;
  float4 _4324;
  float _4329;
  float _4331;
  float _4335;
  float _4337;
  float _4341;
  float _4343;
  float _4347;
  float _4349;
  float _4350;
  float _4361;
  float _4367;
  float _4369;
  float _4371;
  float _4379;
  float _4386;
  float _4388;
  float _4402;
  float _4403;
  float _4404;
  bool _4408;
  bool _4414;
  bool _4418;
  float _4428;
  float _4433;
  float _4442;
  float _4443;
  float _4448;
  float _4449;
  float _4452;
  float _4456;
  float _4465;
  float _4466;
  float _4467;
  float _4472;
  int _4473;
  float _4478;
  float _4487;
  float _4488;
  float _4490;
  float _4492;
  float _4493;
  float4 _4495;
  float _4499;
  float _4500;
  float _4503;
  float _4504;
  float _4509;
  float _4510;
  float _4513;
  float _4514;
  float _4516;
  float _4518;
  bool _4519;
  bool _4520;
  bool _4530;
  bool _4539;
  float _4556;
  float _4558;
  float _4560;
  float _4562;
  float _4566;
  float _4568;
  float _4572;
  float _4574;
  int _4581;
  float _4586;
  float _4595;
  float _4596;
  float _4599;
  float _4600;
  float4 _4602;
  float _4606;
  float _4607;
  float _4610;
  float _4611;
  float _4613;
  float _4615;
  bool _4616;
  bool _4617;
  bool _4627;
  bool _4636;
  float _4653;
  float _4655;
  float _4659;
  float _4661;
  float _4665;
  float _4667;
  float _4671;
  float _4673;
  int _4680;
  float _4685;
  float _4694;
  float _4695;
  float _4698;
  float _4699;
  float4 _4701;
  float _4705;
  float _4706;
  float _4709;
  float _4710;
  float _4712;
  float _4714;
  bool _4715;
  bool _4716;
  bool _4726;
  bool _4735;
  float _4752;
  float _4754;
  float _4758;
  float _4760;
  float _4764;
  float _4766;
  float _4770;
  float _4772;
  int _4779;
  float _4784;
  float _4793;
  float _4794;
  float _4797;
  float _4798;
  float4 _4800;
  float _4804;
  float _4805;
  float _4808;
  float _4809;
  float _4811;
  float _4813;
  bool _4814;
  bool _4815;
  bool _4825;
  bool _4834;
  float _4851;
  float _4853;
  float _4857;
  float _4859;
  float _4863;
  float _4865;
  float _4869;
  float _4871;
  float _4872;
  float _4883;
  float _4889;
  float _4891;
  float _4893;
  float _4902;
  float _4905;
  float _4906;
  float _4919;
  float _4920;
  float _4921;
  float _4925;
  float _4934;
  float _4935;
  float _4936;
  int _4937;
  float _4942;
  float _4951;
  float _4952;
  float _4954;
  float4 _4959;
  float _4964;
  float _4966;
  float _4968;
  float _4970;
  float _4974;
  float _4976;
  float _4980;
  float _4982;
  int _4989;
  float _4994;
  float _5003;
  float _5004;
  float4 _5010;
  float _5015;
  float _5017;
  float _5021;
  float _5023;
  float _5027;
  float _5029;
  float _5033;
  float _5035;
  int _5042;
  float _5047;
  float _5056;
  float _5057;
  float4 _5063;
  float _5068;
  float _5070;
  float _5074;
  float _5076;
  float _5080;
  float _5082;
  float _5086;
  float _5088;
  int _5095;
  float _5100;
  float _5109;
  float _5110;
  float4 _5116;
  float _5121;
  float _5123;
  float _5127;
  float _5129;
  float _5133;
  float _5135;
  float _5139;
  float _5141;
  float _5142;
  float _5153;
  float _5159;
  float _5161;
  float _5163;
  float _5171;
  float _5178;
  float _5180;
  float _5206;
  float _5208;
  float _5209;
  float _5210;
  float _5225;
  float _5228;
  float _5231;
  float _5233;
  float _5234;
  float _5235;
  float _5236;
  float _5244;
  float _5245;
  float _5246;
  bool _5248;
  float _5268;
  float4 _5293;
  float _5313;
  float _5314;
  float _5315;
  float _5316;
  float _5318;
  float _5323;
  float _5326;
  float _5327;
  float _5329;
  float _5330;
  float _5335;
  float _5340;
  float _5342;
  float _5345;
  float _5346;
  float _5351;
  float _5353;
  float _5355;
  float _5357;
  float _5362;
  float _5368;
  float _5370;
  float3 _5399;
  float4 _5430;
  float _5465;
  bool _5478;
  float _5479;
  float _5480;
  float _5481;
  bool _5482;
  float _5484;
  float _5485;
  float _5489;
  float _5495;
  float _5509;
  float _5510;
  float _5513;
  float _5517;
  int _5518;
  float _5520;
  float _5522;
  float _5525;
  float _5529;
  float _5540;
  float _5541;
  float _5542;
  float _5544;
  int _5564;
  int _5569;
  int _5571;
  int _5572;
  int _5574;
  int _5575;
  int _5584;
  bool _5597;
  float _5600;
  float _5602;
  float _5603;
  float _5604;
  float _5605;
  float _5606;
  float _5607;
  float _5608;
  float _5609;
  float _5610;
  float _5611;
  float _5612;
  float _5613;
  bool _5614;
  float _5615;
  float _5616;
  float _5619;
  float _5620;
  float _5622;
  float _5649;
  float _5654;
  float _5661;
  float _5662;
  float _5663;
  float _5665;
  float _5669;
  float _5670;
  float _5671;
  float _5672;
  float _5673;
  float _5674;
  float _5675;
  float _5681;
  float _5690;
  float _5694;
  float _5695;
  float _5696;
  float _5697;
  float _5701;
  float _5702;
  float _5703;
  float _5711;
  float _5723;
  float _5724;
  float _5725;
  float _5726;
  float _5727;
  float _5731;
  float _5733;
  float _5735;
  float _5739;
  float _5740;
  float _5741;
  float _5744;
  bool _5751;
  float _5755;
  float _5757;
  float _5758;
  float _5766;
  float _5769;
  float _5770;
  float _5775;
  float _5784;
  float _5785;
  float _5788;
  float _5790;
  float _5791;
  float _5792;
  float _5794;
  float _5795;
  float _5796;
  float _5797;
  float _5802;
  float _5816;
  float _5821;
  float _5822;
  float _5824;
  float _5830;
  float _5833;
  float _5844;
  float _5846;
  float _5865;
  float _5876;
  float _5893;
  float _5898;
  float _5899;
  float _5900;
  float _5912;
  float _5915;
  float _5916;
  float _5917;
  float _5918;
  float _5925;
  float _5926;
  float _5927;
  float _5936;
  float _5937;
  float _5958;
  float _5959;
  float _5960;
  float _5963;
  float _5964;
  float _5965;
  float _5968;
  int _5971;
  int _5974;
  int _5977;
  float _5986;
  float _5989;
  float _5992;
  float _5999;
  float _6004;
  float _6006;
  float _6008;
  float _6009;
  float _6010;
  float _6012;
  float _6013;
  float _6014;
  float _6017;
  float _6018;
  float _6019;
  float _6022;
  float _6029;
  int _6038;
  int _6043;
  int _6045;
  int _6046;
  int _6048;
  int _6049;
  int _6058;
  bool _6071;
  float _6073;
  float _6074;
  float _6075;
  float _6076;
  float _6079;
  float _6082;
  float _6083;
  float _6084;
  float _6085;
  float _6089;
  float _6094;
  float _6095;
  float _6096;
  float _6108;
  float _6110;
  float _6111;
  float _6112;
  float _6113;
  float _6120;
  float _6121;
  float _6122;
  float _6134;
  float _6137;
  float _6158;
  float _6159;
  float _6160;
  float _6163;
  float _6164;
  float _6165;
  float _6168;
  float _6169;
  float _6170;
  float _6173;
  float _6174;
  float _6175;
  float _6178;
  float _6179;
  float _6180;
  float _6183;
  float _6184;
  float _6185;
  int _6188;
  int _6191;
  int _6194;
  int _6197;
  float _6200;
  float _6201;
  float _6202;
  float _6203;
  int _6206;
  int _6209;
  int _6212;
  int _6215;
  int _6218;
  int _6221;
  int _6224;
  float _6227;
  float _6228;
  float _6229;
  float _6230;
  int _6233;
  int _6236;
  int _6239;
  float _6241;
  float _6242;
  float _6244;
  float _6248;
  float _6251;
  float _6252;
  float _6254;
  float _6258;
  int _6262;
  float _6278;
  float _6279;
  float _6281;
  float _6282;
  float _6283;
  float _6284;
  float _6285;
  float _6286;
  float _6287;
  float _6288;
  float _6289;
  float _6290;
  float _6291;
  float _6292;
  float _6293;
  float _6296;
  float _6297;
  float _6298;
  float _6301;
  float _6312;
  float _6316;
  float _6323;
  float _6324;
  float _6325;
  float _6337;
  float _6338;
  float _6339;
  float _6340;
  float _6343;
  float _6344;
  float _6347;
  float _6348;
  float _6355;
  float _6357;
  float _6363;
  bool _6365;
  float _6373;
  float _6374;
  float _6375;
  float _6380;
  float _6382;
  float _6383;
  float _6386;
  float _6390;
  float _6399;
  float _6400;
  float _6401;
  int _6402;
  float _6407;
  float _6416;
  float _6417;
  float _6419;
  float4 _6424;
  float _6429;
  float _6431;
  float _6433;
  float _6435;
  float _6439;
  float _6441;
  float _6445;
  float _6447;
  int _6454;
  float _6459;
  float _6468;
  float _6469;
  float4 _6475;
  float _6480;
  float _6482;
  float _6486;
  float _6488;
  float _6492;
  float _6494;
  float _6498;
  float _6500;
  int _6507;
  float _6512;
  float _6521;
  float _6522;
  float4 _6528;
  float _6533;
  float _6535;
  float _6539;
  float _6541;
  float _6545;
  float _6547;
  float _6551;
  float _6553;
  int _6560;
  float _6565;
  float _6574;
  float _6575;
  float4 _6581;
  float _6586;
  float _6588;
  float _6592;
  float _6594;
  float _6598;
  float _6600;
  float _6604;
  float _6606;
  float _6607;
  float _6618;
  float _6624;
  float _6626;
  float _6628;
  float _6635;
  float _6643;
  float _6644;
  float _6653;
  float _6657;
  float _6666;
  float _6667;
  float _6668;
  float _6673;
  int _6674;
  float _6679;
  float _6688;
  float _6689;
  float _6691;
  float _6693;
  float _6694;
  float4 _6696;
  float _6700;
  float _6701;
  float _6704;
  float _6705;
  float _6710;
  float _6711;
  float _6714;
  float _6715;
  float _6717;
  float _6719;
  bool _6720;
  bool _6721;
  bool _6731;
  bool _6740;
  float _6757;
  float _6759;
  float _6761;
  float _6763;
  float _6767;
  float _6769;
  float _6773;
  float _6775;
  int _6782;
  float _6787;
  float _6796;
  float _6797;
  float _6800;
  float _6801;
  float4 _6803;
  float _6807;
  float _6808;
  float _6811;
  float _6812;
  float _6814;
  float _6816;
  bool _6817;
  bool _6818;
  bool _6828;
  bool _6837;
  float _6854;
  float _6856;
  float _6860;
  float _6862;
  float _6866;
  float _6868;
  float _6872;
  float _6874;
  int _6881;
  float _6886;
  float _6895;
  float _6896;
  float _6899;
  float _6900;
  float4 _6902;
  float _6906;
  float _6907;
  float _6910;
  float _6911;
  float _6913;
  float _6915;
  bool _6916;
  bool _6917;
  bool _6927;
  bool _6936;
  float _6953;
  float _6955;
  float _6959;
  float _6961;
  float _6965;
  float _6967;
  float _6971;
  float _6973;
  int _6980;
  float _6985;
  float _6994;
  float _6995;
  float _6998;
  float _6999;
  float4 _7001;
  float _7005;
  float _7006;
  float _7009;
  float _7010;
  float _7012;
  float _7014;
  bool _7015;
  bool _7016;
  bool _7026;
  bool _7035;
  float _7052;
  float _7054;
  float _7058;
  float _7060;
  float _7064;
  float _7066;
  float _7070;
  float _7072;
  float _7073;
  float _7084;
  float _7090;
  float _7092;
  float _7094;
  float _7115;
  float4 _7122;
  float _7136;
  float _7137;
  float _7138;
  float _7139;
  float _7141;
  float _7146;
  float _7149;
  float _7150;
  float _7152;
  float _7153;
  float _7158;
  float _7163;
  float _7165;
  float _7168;
  float _7169;
  float _7174;
  float _7176;
  float _7178;
  float _7180;
  float _7185;
  float _7191;
  float _7193;
  float3 _7220;
  float _7231;
  float4 _7252;
  float _7290;
  bool _7303;
  float _7304;
  float _7305;
  float _7306;
  bool _7307;
  float _7309;
  float _7310;
  float _7314;
  float _7320;
  float _7334;
  float _7335;
  float _7338;
  float _7342;
  int _7343;
  float _7345;
  float _7347;
  float _7350;
  float _7354;
  float _7365;
  float _7366;
  float _7367;
  float _7369;
  int _7389;
  int _7394;
  int _7396;
  int _7397;
  int _7399;
  int _7400;
  int _7409;
  bool _7422;
  float _7425;
  float _7427;
  float _7428;
  float _7429;
  float _7430;
  float _7431;
  float _7432;
  float _7433;
  float _7434;
  float _7435;
  float _7436;
  float _7437;
  float _7438;
  bool _7439;
  float _7440;
  float _7441;
  float _7444;
  float _7445;
  float _7447;
  float _7474;
  float _7479;
  float _7486;
  float _7487;
  float _7488;
  float _7490;
  float _7494;
  float _7495;
  float _7496;
  float _7497;
  float _7498;
  float _7499;
  float _7500;
  float _7506;
  float _7515;
  float _7519;
  float _7520;
  float _7521;
  float _7522;
  float _7526;
  float _7527;
  float _7528;
  float _7536;
  float _7548;
  float _7549;
  float _7550;
  float _7551;
  float _7552;
  float _7556;
  float _7558;
  float _7560;
  float _7564;
  float _7565;
  float _7566;
  float _7569;
  bool _7576;
  float _7580;
  float _7582;
  float _7583;
  float _7591;
  float _7594;
  float _7595;
  float _7600;
  float _7609;
  float _7610;
  float _7613;
  float _7615;
  float _7616;
  float _7617;
  float _7619;
  float _7620;
  float _7621;
  float _7622;
  float _7627;
  float _7641;
  float _7646;
  float _7647;
  float _7649;
  float _7655;
  float _7658;
  float _7669;
  float _7671;
  float _7690;
  float _7701;
  float _7718;
  float _7723;
  float _7724;
  float _7725;
  float _7737;
  float _7740;
  float _7741;
  float _7742;
  float _7743;
  float _7750;
  float _7751;
  float _7752;
  float _7761;
  float _7762;
  float _7783;
  float _7784;
  float _7785;
  float _7786;
  float _7789;
  float _7790;
  float _7791;
  float _7792;
  float _7795;
  float _7796;
  float _7797;
  float _7798;
  float _7801;
  float _7802;
  int _7805;
  int _7808;
  int _7811;
  int _7814;
  float _7817;
  float _7819;
  float _7820;
  float _7822;
  float _7826;
  float _7828;
  float _7832;
  float _7836;
  float _7840;
  float _7843;
  float _7846;
  float _7849;
  float _7861;
  float _7862;
  float _7863;
  float _7864;
  float _7865;
  float _7866;
  float _7867;
  float _7868;
  float _7869;
  float _7870;
  float _7871;
  float _7873;
  float _7875;
  float _7877;
  float _7879;
  float _7880;
  float _7886;
  float _7888;
  float _7895;
  float _7910;
  float _7912;
  float _7919;
  float _7929;
  float _7935;
  float _7937;
  float _7944;
  float _7961;
  float _7963;
  float _7970;
  float _7989;
  float _7990;
  float _7991;
  float _7992;
  float _7994;
  float _7996;
  float _7997;
  float _7998;
  float _7999;
  float _8000;
  float _8001;
  float _8002;
  float _8003;
  float _8005;
  float _8007;
  float _8008;
  float _8009;
  float _8010;
  float _8011;
  float _8012;
  float _8013;
  float _8015;
  float _8017;
  float _8024;
  bool _8037;
  float _8039;
  float _8045;
  float _8049;
  float _8051;
  float _8052;
  bool _8053;
  float _8055;
  float _8061;
  float _8062;
  float _8067;
  float _8068;
  float _8071;
  float _8073;
  float _8080;
  float _8093;
  float _8095;
  float _8102;
  float _8131;
  float _8132;
  float _8141;
  float _8150;
  float _8155;
  float _8164;
  float _8171;
  float _8174;
  float4 _8182;
  float _8184;
  float4 _8185;
  float _8194;
  float _8210;
  float _8211;
  float _8239;
  uint _8253;
  float _8264;
  float _8271;
  float _8281;
  float _8300;
  float _8303;
  float _8306;
  float4 _8327;
  float _8331;
  float _8332;
  float _8333;
  float _8335;
  float _8336;
  float _8337;
  float _8338;
  float _8339;
  float _8340;
  float _8341;
  float _8342;
  float _8343;
  float _8348;
  float _8353;
  float _8366;
  float4 _8374;
  float _8376;
  float _8383;
  bool _8416;
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
    bool _loop_break_0 = false;
    while (true) {
      _90 = (_88 << 6) + _51;
      do {
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
        do {
          if (!(_111 == _84)) {
            _88 = _111;
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
    do {
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
        _183 = rsqrt(dot(float3(_179, _180, _181), float3(_179, _180, _181)));
        _184 = _183 * _179;
        _185 = _183 * _180;
        _186 = _183 * _181;
        _195 = min(1.0f, max(saturate(_147.x), 0.019999999552965164f));
        _206 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _116.x) - cbSharedPerViewData.vViewRemap.y);
        _207 = _206 * _133;
        _208 = _206 * _134;
        _209 = -0.0f - _206;
        _215 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
        _219 = srvReflectionsWeight.Load(int3(((uint)(_62) >> _215), ((uint)(_63) >> _215), 0));
        _225 = ((float)((uint)((uint)(_219.x & 254)))) * 0.003921568859368563f;
        do {
          _243 = 1.0f;
          _244 = 0.0f;
          _245 = 0.0f;
          _246 = 0.0f;
          if ((_219.x & 1) == 0) {
            _234 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _124), (cbSharedPerViewData.vViewportSize.y * _125)), 0.0f);
            _243 = (1.0f - _225);
            _244 = (_234.x * _225);
            _245 = (_234.y * _225);
            _246 = (_234.z * _225);
          }
          _255 = cbSharedPerViewData.vViewportSize.x * (_124 + 0.5f);
          _256 = cbSharedPerViewData.vViewportSize.y * (_125 + 0.5f);
          do {
            _336 = _255;
            _337 = _256;
            if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
              _271 = (floor((_255 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
              _272 = (floor((_256 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
              _275 = max(_271, cbDeferredShading.vScreenPixelSize.z);
              _276 = max(_272, cbDeferredShading.vScreenPixelSize.w);
              _279 = min((_271 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
              _280 = min((_272 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
              _285 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_275 + cbDeferredShading.vScreenPixelSize.z), (_276 + cbDeferredShading.vScreenPixelSize.w)));
              if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _285.x) - cbSharedPerViewData.vViewRemap.y)) - _206) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _285.y) - cbSharedPerViewData.vViewRemap.y)) - _206) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _285.z) - cbSharedPerViewData.vViewRemap.y)) - _206) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _285.w) - cbSharedPerViewData.vViewRemap.y)) - _206) > 0.029999999329447746f)) {
                _319 = abs(_116.x - _285.w);
                _321 = abs(_116.x - _285.z);
                _322 = (_321 < _319);
                _324 = select(_322, _321, _319);
                _326 = abs(_116.x - _285.x);
                _327 = (_326 < _324);
                if (abs(_116.x - _285.y) < select(_327, _326, _324)) {
                  _336 = _279;
                  _337 = _280;
                } else {
                  _336 = select(_327, _275, select(_322, _279, _275));
                  _337 = select(_327, _280, _276);
                }
              } else {
                _336 = _255;
                _337 = _256;
              }
            }
            _340 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_336, _337), 0.0f);
            _344 = _340.x - _340.z;
            _356 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_340.y + _344)), 0.0f);
            _357 = -0.0f - _356;
            _358 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_340.x + _340.z)), 0.0f);
            _359 = -0.0f - _358;
            _360 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_344 - _340.y)), 0.0f);
            _361 = -0.0f - _360;
            do {
              _375 = 1.0f;
              if (!(cbSharedPerViewData.nSSGIEnabled == 0)) {
                if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
                  _375 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_336, _337), 0.0f)).x);
                } else {
                  _375 = 1.0f;
                }
              }
              _376 = -0.0f - _133;
              _377 = -0.0f - _134;
              _379 = rsqrt(dot(float3(_376, _377, 1.0f), float3(_376, _377, 1.0f)));
              _380 = _379 * _376;
              _381 = _379 * _377;
              _389 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _63) + _62))];
              _390 = _389 & 255;
              _391 = (uint)(_389) >> 8;
              _392 = _391 & 255;
              _396 = ((float)((uint)((uint)(((uint)(_389) >> 16) & 255)))) * 0.003921568859368563f;
              _398 = (float)((uint)((uint)((uint)(_389) >> 24)));
              _399 = _398 * 0.003921568859368563f;
              do {
                _1018 = 0.0f;
                _1019 = 0.0f;
                _1020 = 0.0f;
                _1021 = 0.0f;
                _1022 = 0.0f;
                _1023 = 0.0f;
                [branch]
                if (!((((int)(uint((saturate(_141.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
                  _409 = _195 * 4.0f;
                  _414 = dot(float3((-0.0f - _380), (-0.0f - _381), (-0.0f - _379)), float3(_184, _185, _186)) * 2.0f;
                  _418 = _195 * _195;
                  _419 = 1.0f - _418;
                  _422 = (sqrt(_419) + _418) * _419;
                  _435 = (_422 * (((-0.0f - _184) - _380) - (_414 * _184))) + _184;
                  _436 = (_422 * (((-0.0f - _185) - _381) - (_414 * _185))) + _185;
                  _437 = (_422 * (((-0.0f - _186) - _379) - (_414 * _186))) + _186;
                  _441 = saturate(1.0f - ((_195 + -0.30000001192092896f) * 3.3333332538604736f));
                  _456 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _437, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _436, (_435 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
                  _459 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _437, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _436, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _435)));
                  _462 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _437, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _436, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _435)));
                  _465 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _186, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _185, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _184)));
                  _468 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _186, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _185, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _184)));
                  _471 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _186, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _185, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _184)));
                  do {
                    _800 = 0.0f;
                    _801 = 0.0f;
                    _802 = 0.0f;
                    _803 = 0.0f;
                    _804 = 0.0f;
                    _805 = 0.0f;
                    _806 = 0.0f;
                    _807 = 0.0f;
                    _808 = 0.0f;
                    _809 = 0.0f;
                    _810 = 0.0f;
                    _811 = 0.0f;
                    _812 = 0.0f;
                    _813 = 0.0f;
                    if (!(_global_0 == 0)) {
                      _490 = 0;
                      _491 = 0.0f;
                      _492 = 0.0f;
                      _493 = 0.0f;
                      _494 = 0.0f;
                      _495 = 0.0f;
                      _496 = 0.0f;
                      _497 = 0.0f;
                      _498 = 0.0f;
                      _499 = 0.0f;
                      _500 = 0.0f;
                      _501 = 0.0f;
                      _502 = 0.0f;
                      _503 = 0.0f;
                      _504 = 0.0f;
                      bool _loop_break_1 = false;
                      while (true) {
                        _507 = _global_5[min((uint)(_490), 63u)];
                        _508 = _global_6[min((uint)(_490), 63u)];
                        _511 = asfloat(srvLightInfoProperties.Load4(_508)).x;
                        _512 = asfloat(srvLightInfoProperties.Load4(_508)).y;
                        _513 = asfloat(srvLightInfoProperties.Load4(_508)).z;
                        _514 = asfloat(srvLightInfoProperties.Load4(_508)).w;
                        _517 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 16u)))).x;
                        _518 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 16u)))).y;
                        _519 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 16u)))).z;
                        _520 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 16u)))).w;
                        _523 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 32u)))).x;
                        _524 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 32u)))).y;
                        _525 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 32u)))).z;
                        _526 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 32u)))).w;
                        _529 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 48u)))).x;
                        _530 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 48u)))).y;
                        _531 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 48u)))).z;
                        _532 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 48u)))).w;
                        _535 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 64u)))).x;
                        _536 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 64u)))).y;
                        _537 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 64u)))).z;
                        _538 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 64u)))).w;
                        _541 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 80u)))).x;
                        _542 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 80u)))).y;
                        _543 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 80u)))).z;
                        _544 = asfloat(srvLightInfoProperties.Load4(((int)(_508 + 80u)))).w;
                        _547 = asint(srvLightInfoProperties.Load(((int)(_508 + 96u))));
                        _550 = asfloat(srvLightInfoProperties.Load3(((int)(_508 + 100u)))).x;
                        _551 = asfloat(srvLightInfoProperties.Load3(((int)(_508 + 100u)))).y;
                        _552 = asfloat(srvLightInfoProperties.Load3(((int)(_508 + 100u)))).z;
                        _555 = asfloat(srvLightInfoProperties.Load3(((int)(_508 + 112u)))).x;
                        _556 = asfloat(srvLightInfoProperties.Load3(((int)(_508 + 112u)))).y;
                        _557 = asfloat(srvLightInfoProperties.Load3(((int)(_508 + 112u)))).z;
                        _560 = asint(srvLightInfoProperties.Load(((int)(_508 + 124u))));
                        _563 = asint(srvLightInfoProperties.Load(((int)(_508 + 128u))));
                        _566 = _547 & 65535;
                        _595 = ((saturate(1.0f - abs(mad(_513, _209, mad(_512, _208, (_511 * _207))) + _514)) * f16tof32(((uint)((uint)(_547) >> 16)))) * saturate(1.0f - abs(mad(_519, _209, mad(_518, _208, (_517 * _207))) + _520))) * saturate(1.0f - abs(mad(_525, _209, mad(_524, _208, (_523 * _207))) + _526));
                        do {
                          _782 = _491;
                          _783 = _492;
                          _784 = _493;
                          _785 = _494;
                          _786 = _495;
                          _787 = _496;
                          _788 = _497;
                          _789 = _498;
                          _790 = _499;
                          _791 = _500;
                          _792 = _501;
                          _793 = _502;
                          _794 = _503;
                          _795 = _504;
                          [branch]
                          if (_595 > 0.0f) {
                            _598 = _595 * _595;
                            do {
                              _619 = 0.0f;
                              _620 = 0.0f;
                              _621 = 0.0f;
                              [branch]
                              if (_441 < 1.0f) {
                                _601 = (float)((uint)_566);
                                _602 = -0.0f - _456;
                                [branch]
                                if (!(!(_601 >= 341.0f))) {
                                  _608 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_602, _459, _462, (_601 + -341.0f)), _409);
                                  _619 = _608.x;
                                  _620 = _608.y;
                                  _621 = _608.z;
                                } else {
                                  _614 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_602, _459, _462, _601), _409);
                                  _619 = _614.x;
                                  _620 = _614.y;
                                  _621 = _614.z;
                                }
                              }
                              _623 = (float)((uint)_566);
                              do {
                                _708 = 0.0f;
                                _709 = 0.0f;
                                _710 = 0.0f;
                                [branch]
                                if (_441 > 0.0f) {
                                  _627 = mad(_531, _437, mad(_530, _436, (_529 * _435)));
                                  _630 = mad(_537, _437, mad(_536, _436, (_535 * _435)));
                                  _633 = mad(_543, _437, mad(_542, _436, (_541 * _435)));
                                  _674 = min(((((float((int)(((int)(uint)((int)(_627 > 0.0f))) - ((int)(uint)((int)(_627 < 0.0f))))) * _550) - _532) - mad(_531, _209, mad(_530, _208, (_529 * _207)))) / _627), min(((((float((int)(((int)(uint)((int)(_630 > 0.0f))) - ((int)(uint)((int)(_630 < 0.0f))))) * _551) - _538) - mad(_537, _209, mad(_536, _208, (_535 * _207)))) / _630), ((((float((int)(((int)(uint)((int)(_633 > 0.0f))) - ((int)(uint)((int)(_633 < 0.0f))))) * _552) - _544) - mad(_543, _209, mad(_542, _208, (_541 * _207)))) / _633)));
                                  _679 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _208, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _207))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _555) + (_674 * _456);
                                  _681 = ((mad((cbSharedPerViewData.mViewToWorld[0][1].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _208, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _207))) + (cbSharedPerViewData.mViewToWorld[0][1].w)) - _556) + (_674 * _459);
                                  _683 = ((mad((cbSharedPerViewData.mViewToWorld[0][2].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _208, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _207))) + (cbSharedPerViewData.mViewToWorld[0][2].w)) - _557) + (_674 * _462);
                                  _690 = (max(log2((_674 * _674) / dot(float3(_679, _681, _683), float3(_679, _681, _683))), -1.0f) * 0.3333333432674408f) + _409;
                                  _691 = -0.0f - _679;
                                  [branch]
                                  if (!(!(_623 >= 341.0f))) {
                                    _697 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_691, _681, _683, (_623 + -341.0f)), _690);
                                    _708 = _697.x;
                                    _709 = _697.y;
                                    _710 = _697.z;
                                  } else {
                                    _703 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_691, _681, _683, _623), _690);
                                    _708 = _703.x;
                                    _709 = _703.y;
                                    _710 = _703.z;
                                  }
                                }
                                _711 = -0.0f - _465;
                                do {
                                  [branch]
                                  if (!(!(_623 >= 341.0f))) {
                                    _717 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_711, _468, _471, (_623 + -341.0f)), 0.0f);
                                    _728 = _717.x;
                                    _729 = _717.y;
                                    _730 = _717.z;
                                  } else {
                                    _723 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_711, _468, _471, _623), 0.0f);
                                    _728 = _723.x;
                                    _729 = _723.y;
                                    _730 = _723.z;
                                  }
                                  _740 = _598 * f16tof32(((uint)((uint)(_560) >> 16)));
                                  _741 = _740 * _728;
                                  _742 = _598 * f16tof32(_560);
                                  _743 = _742 * _729;
                                  _744 = _598 * f16tof32(((uint)((uint)(_563) >> 16)));
                                  _745 = _744 * _730;
                                  _746 = _740 * (lerp(_619, _708, _441));
                                  _747 = _742 * (lerp(_620, _709, _441));
                                  _748 = _744 * (lerp(_621, _710, _441));
                                  do {
                                    _762 = _491;
                                    _763 = _492;
                                    _764 = _493;
                                    _765 = _494;
                                    _766 = _495;
                                    _767 = _496;
                                    _768 = _497;
                                    [branch]
                                    if (!((_507 & ((int)(1 << (_389 & 31)))) == 0)) {
                                      _762 = (_741 + _491);
                                      _763 = (_743 + _492);
                                      _764 = (_745 + _493);
                                      _765 = (_746 + _494);
                                      _766 = (_747 + _495);
                                      _767 = (_748 + _496);
                                      _768 = (_598 + _497);
                                    }
                                    [branch]
                                    if (!((_507 & ((int)(1 << (_391 & 31)))) == 0)) {
                                      _782 = _762;
                                      _783 = _763;
                                      _784 = _764;
                                      _785 = _765;
                                      _786 = _766;
                                      _787 = _767;
                                      _788 = _768;
                                      _789 = (_741 + _498);
                                      _790 = (_743 + _499);
                                      _791 = (_745 + _500);
                                      _792 = (_746 + _501);
                                      _793 = (_747 + _502);
                                      _794 = (_748 + _503);
                                      _795 = (_598 + _504);
                                    } else {
                                      _782 = _762;
                                      _783 = _763;
                                      _784 = _764;
                                      _785 = _765;
                                      _786 = _766;
                                      _787 = _767;
                                      _788 = _768;
                                      _789 = _498;
                                      _790 = _499;
                                      _791 = _500;
                                      _792 = _501;
                                      _793 = _502;
                                      _794 = _503;
                                      _795 = _504;
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
                          _796 = _490 + 1u;
                          do {
                            if (!(_796 == _global_0)) {
                              _490 = _796;
                              _491 = _782;
                              _492 = _783;
                              _493 = _784;
                              _494 = _785;
                              _495 = _786;
                              _496 = _787;
                              _497 = _788;
                              _498 = _789;
                              _499 = _790;
                              _500 = _791;
                              _501 = _792;
                              _502 = _793;
                              _503 = _794;
                              _504 = _795;
                              _loop_break_1 = true;
                              break;
                            }
                            _800 = _782;
                            _801 = _783;
                            _802 = _784;
                            _803 = _785;
                            _804 = _786;
                            _805 = _787;
                            _806 = _788;
                            _807 = _789;
                            _808 = _790;
                            _809 = _791;
                            _810 = _792;
                            _811 = _793;
                            _812 = _794;
                            _813 = _795;
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
                    _819 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_389 & 31)))) != 0);
                    do {
                      _925 = 0.0f;
                      _926 = 0.0f;
                      _927 = 0.0f;
                      _928 = 0.0f;
                      _929 = 0.0f;
                      _930 = 0.0f;
                      if ((_396 > 0.0f) || ((_399 > 0.0f) || _819)) {
                        _829 = srvFallbackInfo[((_390 << 2) | 3)].x;
                        _831 = select(_819, 9.999999747378752e-05f, (_398 * 3.921568847431445e-09f));
                        _832 = _806 * 0.20000000298023224f;
                        _839 = saturate((_831 - _832) / (((_806 * 0.4000000059604645f) + 9.99999993922529e-09f) - _832)) * _831;
                        do {
                          _905 = _806;
                          _906 = _803;
                          _907 = _804;
                          _908 = _805;
                          _909 = _800;
                          _910 = _801;
                          _911 = _802;
                          [branch]
                          if (_839 > 0.0f) {
                            do {
                              _897 = _803;
                              _898 = _804;
                              _899 = _805;
                              _900 = _800;
                              _901 = _801;
                              _902 = _802;
                              [branch]
                              if ((int)_829 > (int)-1) {
                                _844 = float((int)(_829));
                                _845 = -0.0f - _456;
                                _846 = !(_844 >= 341.0f);
                                do {
                                  [branch]
                                  if (!(_846)) {
                                    _851 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_845, _459, _462, (_844 + -341.0f)), _409);
                                    _862 = _851.x;
                                    _863 = _851.y;
                                    _864 = _851.z;
                                  } else {
                                    _857 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_845, _459, _462, _844), _409);
                                    _862 = _857.x;
                                    _863 = _857.y;
                                    _864 = _857.z;
                                  }
                                  _868 = -0.0f - _465;
                                  do {
                                    [branch]
                                    if (!(_846)) {
                                      _873 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_868, _468, _471, (_844 + -341.0f)), 0.0f);
                                      _884 = _873.x;
                                      _885 = _873.y;
                                      _886 = _873.z;
                                    } else {
                                      _879 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_868, _468, _471, _844), 0.0f);
                                      _884 = _879.x;
                                      _885 = _879.y;
                                      _886 = _879.z;
                                    }
                                    _897 = ((_862 * _839) + _803);
                                    _898 = ((_863 * _839) + _804);
                                    _899 = ((_864 * _839) + _805);
                                    _900 = ((_884 * _839) + _800);
                                    _901 = ((_885 * _839) + _801);
                                    _902 = ((_886 * _839) + _802);
                                  } while (false);
                                } while (false);
                              }
                              _905 = (_839 + _806);
                              _906 = _897;
                              _907 = _898;
                              _908 = _899;
                              _909 = _900;
                              _910 = _901;
                              _911 = _902;
                            } while (false);
                          }
                          if (_905 > 0.0f) {
                            _917 = (cbSharedPerViewData.vHDRScale.x * _396) / _905;
                            _925 = (_917 * _909);
                            _926 = (_917 * _910);
                            _927 = (_917 * _911);
                            _928 = (_917 * _906);
                            _929 = (_917 * _907);
                            _930 = (_917 * _908);
                          } else {
                            _925 = 0.0f;
                            _926 = 0.0f;
                            _927 = 0.0f;
                            _928 = 0.0f;
                            _929 = 0.0f;
                            _930 = 0.0f;
                          }
                        } while (false);
                      }
                      [branch]
                      if (!(_399 == 0.0f)) {
                        _937 = srvFallbackInfo[((_392 << 2) | 3)].x;
                        _938 = _398 * 3.921568847431445e-09f;
                        do {
                          _994 = _810;
                          _995 = _811;
                          _996 = _812;
                          _997 = _807;
                          _998 = _808;
                          _999 = _809;
                          [branch]
                          if ((int)_937 > (int)-1) {
                            _941 = float((int)(_937));
                            _942 = -0.0f - _456;
                            _943 = !(_941 >= 341.0f);
                            do {
                              [branch]
                              if (!(_943)) {
                                _948 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_942, _459, _462, (_941 + -341.0f)), _409);
                                _959 = _948.x;
                                _960 = _948.y;
                                _961 = _948.z;
                              } else {
                                _954 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_942, _459, _462, _941), _409);
                                _959 = _954.x;
                                _960 = _954.y;
                                _961 = _954.z;
                              }
                              _965 = -0.0f - _465;
                              do {
                                [branch]
                                if (!(_943)) {
                                  _970 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_965, _468, _471, (_941 + -341.0f)), 0.0f);
                                  _981 = _970.x;
                                  _982 = _970.y;
                                  _983 = _970.z;
                                } else {
                                  _976 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_965, _468, _471, _941), 0.0f);
                                  _981 = _976.x;
                                  _982 = _976.y;
                                  _983 = _976.z;
                                }
                                _994 = ((_959 * _938) + _810);
                                _995 = ((_960 * _938) + _811);
                                _996 = ((_961 * _938) + _812);
                                _997 = ((_981 * _938) + _807);
                                _998 = ((_982 * _938) + _808);
                                _999 = ((_983 * _938) + _809);
                              } while (false);
                            } while (false);
                          }
                          _1004 = (cbSharedPerViewData.vHDRScale.x * _399) / (_813 + _938);
                          _1018 = ((_1004 * _997) + _925);
                          _1019 = ((_1004 * _998) + _926);
                          _1020 = ((_1004 * _999) + _927);
                          _1021 = ((_1004 * _994) + _928);
                          _1022 = ((_1004 * _995) + _929);
                          _1023 = ((_1004 * _996) + _930);
                        } while (false);
                      } else {
                        _1018 = _925;
                        _1019 = _926;
                        _1020 = _927;
                        _1021 = _928;
                        _1022 = _929;
                        _1023 = _930;
                      }
                    } while (false);
                  } while (false);
                }
                do {
                  _1042 = _1021;
                  _1043 = _1022;
                  _1044 = _1023;
                  [branch]
                  if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
                    _1042 = (min((_357 / max(9.999999747378752e-05f, _1018)), 1.0f) * _1021);
                    _1043 = (min((_359 / max(9.999999747378752e-05f, _1019)), 1.0f) * _1022);
                    _1044 = (min((_361 / max(9.999999747378752e-05f, _1020)), 1.0f) * _1023);
                  }
                  _1060 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(saturate(dot(float3(_380, _381, _379), float3(_184, _185, _186))), _195), 0.0f);
                  _1063 = _1060.x + _1060.y;
                  _1068 = (((1.0f - _1063) * 0.03999999910593033f) / max(9.999999747378752e-06f, _1063)) + 1.0f;
                  _1070 = (_1060.x * 0.03999999910593033f) + _1060.y;
                  _1071 = min(select((cbSharedPerViewData.nPathTracingIsEnabled != 0), 1.0f, (_158 * _158)), _375);
                  do {
                    _1199 = _1071;
                    if (!(_global_1 == 0)) {
                      _1075 = 0;
                      _1076 = _1071;
                      bool _loop_break_2 = false;
                      while (true) {
                        _1077 = _1075 + (uint)(_global_0);
                        _1080 = _global_5[min((uint)(_1077), 63u)];
                        _1081 = _global_6[min((uint)(_1077), 63u)];
                        _1085 = (int)((int)(_1080 << (((int)(31u - _389)) & 31))) >> 31;
                        _1089 = (int)((int)(_1080 << ((31 - _391) & 31))) >> 31;
                        _1101 = saturate((asfloat((_1085 & asint(_396))) + asfloat((_1089 & asint(_399)))) + asfloat(((_1089 & 1065353216) & _1085)));
                        do {
                          _1194 = _1076;
                          [branch]
                          if (!(_1101 == 0.0f)) {
                            _1106 = asfloat(srvLightInfoProperties.Load4(_1081)).x;
                            _1107 = asfloat(srvLightInfoProperties.Load4(_1081)).y;
                            _1108 = asfloat(srvLightInfoProperties.Load4(_1081)).z;
                            _1109 = asfloat(srvLightInfoProperties.Load4(_1081)).w;
                            _1112 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 16u)))).x;
                            _1113 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 16u)))).y;
                            _1114 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 16u)))).z;
                            _1115 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 16u)))).w;
                            _1118 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 32u)))).x;
                            _1119 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 32u)))).y;
                            _1120 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 32u)))).z;
                            _1121 = asfloat(srvLightInfoProperties.Load4(((int)(_1081 + 32u)))).w;
                            _1124 = asint(srvLightInfoProperties.Load(((int)(_1081 + 48u))));
                            _1127 = asint(srvLightInfoProperties.Load(((int)(_1081 + 52u))));
                            _1130 = asint(srvLightInfoProperties.Load(((int)(_1081 + 56u))));
                            _1133 = asint(srvLightInfoProperties.Load(((int)(_1081 + 60u))));
                            _1148 = mad(_1108, _209, mad(_1107, _208, (_1106 * _207))) + _1109;
                            _1152 = mad(_1114, _209, mad(_1113, _208, (_1112 * _207))) + _1115;
                            _1156 = mad(_1120, _209, mad(_1119, _208, (_1118 * _207))) + _1121;
                            _1181 = saturate(1.0f - ((_1148 + 1.0f) * f16tof32(_1127))) + saturate(1.0f - ((1.0f - _1148) * f16tof32(((uint)((uint)(_1127) >> 16)))));
                            _1182 = saturate(1.0f - ((_1152 + 1.0f) * f16tof32(_1130))) + saturate(1.0f - ((1.0f - _1152) * f16tof32(((uint)((uint)(_1130) >> 16)))));
                            _1183 = saturate(1.0f - ((_1156 + 1.0f) * f16tof32(_1133))) + saturate(1.0f - ((1.0f - _1156) * f16tof32(((uint)((uint)(_1133) >> 16)))));
                            _1186 = saturate(1.0f - dot(float3(_1181, _1182, _1183), float3(_1181, _1182, _1183)));
                            _1194 = (saturate(1.0f - ((_1186 * _1186) * (f16tof32(((uint)((uint)(_1124) >> 16))) * _1101))) * _1076);
                          }
                          _1195 = _1075 + 1u;
                          do {
                            if (!(_1195 == _global_1)) {
                              _1075 = _1195;
                              _1076 = _1194;
                              _loop_break_2 = true;
                              break;
                            }
                            _1199 = _1194;
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
                    _1201 = (_1068 * ((cbSharedPerViewData.vHDRScale.x * _244) + (_1042 * _243))) * _1070;
                    _1203 = (_1070 * ((cbSharedPerViewData.vHDRScale.x * _245) + (_1043 * _243))) * _1068;
                    _1205 = (_1070 * ((cbSharedPerViewData.vHDRScale.x * _246) + (_1044 * _243))) * _1068;
                    do {
                      _1212 = 1.0f;
                      [branch]
                      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
                        _1212 = _1199;
                      }
                      do {
                        _1265 = _357;
                        _1266 = _359;
                        _1267 = _361;
                        if (_396 > 0.0f) {
                          _1215 = _390 * 3;
                          _1218 = srvRoomInfo[_1215].x;
                          _1219 = srvRoomInfo[_1215].y;
                          _1220 = srvRoomInfo[_1215].z;
                          _1226 = srvRoomInfo[(_1215 + 1)].x;
                          _1227 = srvRoomInfo[(_1215 + 1)].y;
                          _1228 = srvRoomInfo[(_1215 + 1)].z;
                          _1234 = srvRoomInfo[(_1215 + 2)].x;
                          _1235 = srvRoomInfo[(_1215 + 2)].y;
                          _1236 = srvRoomInfo[(_1215 + 2)].z;
                          _1242 = saturate(dot(float3(_184, _185, _186), float3(asfloat(_1218), asfloat(_1219), asfloat(_1220))) + 0.5f);
                          _1246 = (_1242 * _1242) * (3.0f - (_1242 * 2.0f));
                          _1250 = 1.0f - _1246;
                          _1257 = _1212 * _396;
                          _1265 = ((_1257 * ((_1250 * asfloat(_1234)) + (_1246 * asfloat(_1226)))) - _356);
                          _1266 = ((_1257 * ((_1250 * asfloat(_1235)) + (_1246 * asfloat(_1227)))) - _358);
                          _1267 = ((_1257 * ((_1250 * asfloat(_1236)) + (_1246 * asfloat(_1228)))) - _360);
                        }
                        do {
                          _1320 = _1265;
                          _1321 = _1266;
                          _1322 = _1267;
                          if (_399 > 0.0f) {
                            _1270 = _392 * 3;
                            _1273 = srvRoomInfo[_1270].x;
                            _1274 = srvRoomInfo[_1270].y;
                            _1275 = srvRoomInfo[_1270].z;
                            _1281 = srvRoomInfo[(_1270 + 1)].x;
                            _1282 = srvRoomInfo[(_1270 + 1)].y;
                            _1283 = srvRoomInfo[(_1270 + 1)].z;
                            _1289 = srvRoomInfo[(_1270 + 2)].x;
                            _1290 = srvRoomInfo[(_1270 + 2)].y;
                            _1291 = srvRoomInfo[(_1270 + 2)].z;
                            _1297 = saturate(dot(float3(_184, _185, _186), float3(asfloat(_1273), asfloat(_1274), asfloat(_1275))) + 0.5f);
                            _1301 = (_1297 * _1297) * (3.0f - (_1297 * 2.0f));
                            _1305 = 1.0f - _1301;
                            _1312 = _1212 * _399;
                            _1320 = ((_1312 * ((_1305 * asfloat(_1289)) + (_1301 * asfloat(_1281)))) + _1265);
                            _1321 = ((_1312 * ((_1305 * asfloat(_1290)) + (_1301 * asfloat(_1282)))) + _1266);
                            _1322 = ((_1312 * ((_1305 * asfloat(_1291)) + (_1301 * asfloat(_1283)))) + _1267);
                          }
                          do {
                            _1432 = 0.0f;
                            if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
                              _1345 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _208, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _207))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
                              _1349 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _208, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _207))) + (cbSharedPerViewData.mViewToWorld[0][1].w);
                              _1353 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _209, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _208, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _207))) + (cbSharedPerViewData.mViewToWorld[0][2].w);
                              _1372 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1353, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1349, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1345))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
                              _1376 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1353, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1349, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1345))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
                              _1380 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1353, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1349, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1345))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
                              _1393 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
                              _1394 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
                              _1395 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
                              _1432 = min(min(saturate((_1372 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1393), 9.999999747378752e-06f)), saturate((1.0f - _1372) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1393), 9.999999747378752e-06f))), min(min(saturate((_1376 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1394), 9.999999747378752e-06f)), saturate((1.0f - _1376) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1394), 9.999999747378752e-06f))), min(saturate((_1380 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1395), 9.999999747378752e-06f)), saturate((1.0f - _1380) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1395), 9.999999747378752e-06f)))));
                            }
                            _1433 = (uint)(_global_1) + (uint)(_global_0);
                            do {
                              _8257 = _1320;
                              _8258 = _1321;
                              _8259 = _1322;
                              _8260 = _1201;
                              _8261 = _1203;
                              _8262 = _1205;
                              if ((uint)_1433 < (uint)_global_2) {
                                _1437 = _1320;
                                _1438 = _1321;
                                _1439 = _1322;
                                _1440 = _1201;
                                _1441 = _1203;
                                _1442 = _1205;
                                _1443 = _1433;
                                bool _loop_break_3 = false;
                                while (true) {
                                  _1445 = _global_3[min((uint)(_1443), 63u)];
                                  _1449 = _global_4[min((uint)(_1443), 63u)];
                                  _1450 = _global_5[min((uint)(_1443), 63u)];
                                  _1451 = _global_6[min((uint)(_1443), 63u)];
                                  _1452 = _1445 & 4095;
                                  do {
                                    _8247 = _1437;
                                    _8248 = _1438;
                                    _8249 = _1439;
                                    _8250 = _1440;
                                    _8251 = _1441;
                                    _8252 = _1442;
                                    [branch]
                                    if (((_1449 & 16777216) == 0) && ((((int)(uint(saturate(_147.w) * 255.0f)) & 64) != 0) || ((_1449 & 8388608) == 0))) {
                                      _1463 = (int)((int)(_1450 << (((int)(31u - _389)) & 31))) >> 31;
                                      _1467 = (int)((int)(_1450 << ((31 - _391) & 31))) >> 31;
                                      _1479 = saturate((asfloat((_1463 & asint(_396))) + asfloat((_1467 & asint(_399)))) + asfloat(((_1467 & 1065353216) & _1463)));
                                      [branch]
                                      if (!(_1479 == 0.0f)) {
                                        _1482 = (uint)(_1445) >> 12;
                                        if (_1482 == 6) {
                                          do {
                                            _2962 = _1479;
                                            if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                                              _2962 = (_1479 * select(((_1449 & 67108864) != 0), 1.0f, (1.0f - _1432)));
                                            }
                                            _2965 = asfloat(srvLightInfoProperties.Load4(_1451)).x;
                                            _2966 = asfloat(srvLightInfoProperties.Load4(_1451)).y;
                                            _2967 = asfloat(srvLightInfoProperties.Load4(_1451)).z;
                                            _2968 = asfloat(srvLightInfoProperties.Load4(_1451)).w;
                                            _2971 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).x;
                                            _2972 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).y;
                                            _2973 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).z;
                                            _2974 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).w;
                                            _2977 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).x;
                                            _2978 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).y;
                                            _2979 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).z;
                                            _2982 = asint(srvLightInfoProperties.Load(((int)(_1451 + 68u))));
                                            _2985 = asint(srvLightInfoProperties.Load(((int)(_1451 + 72u))));
                                            _2988 = asint(srvLightInfoProperties.Load(((int)(_1451 + 76u))));
                                            _2991 = asint(srvLightInfoProperties.Load(((int)(_1451 + 84u))));
                                            _2994 = asint(srvLightInfoProperties.Load(((int)(_1451 + 88u))));
                                            _2997 = asint(srvLightInfoProperties.Load(((int)(_1451 + 92u))));
                                            _3001 = ((float)((uint)((uint)(((uint)(_2982) >> 8) & 255)))) * 0.003921499941498041f;
                                            _3004 = ((float)((uint)((uint)(_2982 & 255)))) * 0.003921499941498041f;
                                            _3006 = f16tof32(((uint)((uint)(_2985) >> 16)));
                                            _3008 = (uint)(_2988) >> 16;
                                            _3028 = srvDeferredShadingPass_DeferredShadows.Load(int3(_62, _63, 0));
                                            [branch]
                                            if (!(_3028.x == 0.0f)) {
                                              do {
                                                _3053 = cbSharedPerViewData.vAttenuatedSunColor.x;
                                                _3054 = cbSharedPerViewData.vAttenuatedSunColor.y;
                                                _3055 = cbSharedPerViewData.vAttenuatedSunColor.z;
                                                [branch]
                                                if (!(_3008 == 0)) {
                                                  Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3008)))];
                                                  _3045 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_2967, _209, mad(_2966, _208, (_2965 * _207))) + _2968) * f16tof32(((uint)((uint)(_2994) >> 16)))) + f16tof32(((uint)((uint)(_2997) >> 16)))), (((mad(_2973, _209, mad(_2972, _208, (_2971 * _207))) + _2974) * f16tof32(_2994)) + f16tof32(_2997))), 0.0f);
                                                  _3053 = (_3045.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                                                  _3054 = (_3045.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                                                  _3055 = (_3045.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                                                }
                                                _3058 = min(_3028.x, _3028.y) * _2962;
                                                [branch]
                                                if (_3058 > 0.0f) {
                                                  _3061 = dot(float3(_2977, _2978, _2979), float3(_2977, _2978, _2979));
                                                  _3062 = rsqrt(_3061);
                                                  _3063 = _3062 * _2977;
                                                  _3064 = _3062 * _2978;
                                                  _3065 = _3062 * _2979;
                                                  _3066 = dot(float3(_184, _185, _186), float3(_3063, _3064, _3065));
                                                  do {
                                                    _3084 = _3066;
                                                    if (_3006 > 0.0f) {
                                                      _3074 = sqrt(saturate((_3006 * _3006) * (1.0f / (_3061 + 1.0f))));
                                                      if (_3066 < _3074) {
                                                        _3079 = max(_3066, (-0.0f - _3074)) + _3074;
                                                        _3084 = ((_3079 * _3079) / (_3074 * 4.0f));
                                                      } else {
                                                        _3084 = _3066;
                                                      }
                                                    }
                                                    _3085 = _195 * _195;
                                                    _3089 = saturate((_3006 * (1.0f - _3085)) * _3062);
                                                    _3091 = saturate(_3062 * f16tof32(_2985));
                                                    _3092 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                    _3093 = dot(float3(_380, _381, _379), float3(_3063, _3064, _3065));
                                                    _3096 = rsqrt((_3093 * 2.0f) + 2.0f);
                                                    _3103 = (_3089 > 0.0f);
                                                    do {
                                                      _3194 = saturate((_3096 * _3093) + _3096);
                                                      _3195 = saturate(_3096 * (_3092 + _3066));
                                                      if (_3103) {
                                                        _3107 = sqrt(1.0f - (_3089 * _3089));
                                                        _3109 = (_3066 * 2.0f) * _3092;
                                                        _3110 = _3109 - _3093;
                                                        if (!(!(_3110 >= _3107))) {
                                                          _3194 = abs(_3092);
                                                          _3195 = 1.0f;
                                                        } else {
                                                          _3118 = rsqrt(1.0f - (_3110 * _3110)) * _3089;
                                                          _3121 = _3118 * (_3092 - (_3110 * _3066));
                                                          _3122 = _3092 * _3092;
                                                          _3127 = _3118 * (((_3122 * 2.0f) + -1.0f) - (_3110 * _3093));
                                                          _3136 = sqrt(saturate((((1.0f - (_3066 * _3066)) - _3122) - (_3093 * _3093)) + (_3109 * _3093)));
                                                          _3137 = _3136 * _3118;
                                                          _3140 = ((_3092 * 2.0f) * _3118) * _3136;
                                                          _3142 = (_3107 * _3066) + _3092;
                                                          _3143 = _3142 + _3121;
                                                          _3144 = _3107 * _3093;
                                                          _3146 = (_3144 + 1.0f) + _3127;
                                                          _3147 = _3137 * _3146;
                                                          _3148 = _3143 * _3146;
                                                          _3149 = _3140 * _3143;
                                                          _3154 = (((_3143 * 0.25f) * _3140) - (_3147 * 0.5f)) * _3148;
                                                          _3168 = (((_3149 - (_3147 * 2.0f)) * _3149) + (_3147 * _3147)) + ((((-0.5f - ((_3146 + _3144) * 0.5f)) * _3148) + ((_3146 * _3146) * _3142)) * _3143);
                                                          _3173 = (_3154 * 2.0f) / ((_3168 * _3168) + (_3154 * _3154));
                                                          _3174 = _3168 * _3173;
                                                          _3176 = 1.0f - (_3154 * _3173);
                                                          _3182 = ((_3174 * _3140) + _3144) + (_3176 * _3127);
                                                          _3185 = rsqrt((_3182 * 2.0f) + 2.0f);
                                                          _3194 = saturate((_3182 * _3185) + _3185);
                                                          _3195 = saturate(((_3142 + (_3174 * _3137)) + (_3176 * _3121)) * _3185);
                                                        }
                                                      }
                                                      _3196 = saturate(_3084);
                                                      _3197 = _3085 * _3085;
                                                      do {
                                                        _3207 = _3197;
                                                        if (_3091 > 0.0f) {
                                                          _3207 = saturate(((_3091 * _3091) / ((_3194 * 3.5999999046325684f) + 0.4000000059604645f)) + _3197);
                                                        }
                                                        _3208 = sqrt(_3207);
                                                        do {
                                                          _3219 = 1.0f;
                                                          if (_3103) {
                                                            _3219 = (_3207 / ((((_3089 * 0.25f) * ((_3208 * 3.0f) + _3089)) / (_3194 + 0.0010000000474974513f)) + _3207));
                                                          }
                                                          _3223 = (((_3207 * _3195) - _3195) * _3195) + 1.0f;
                                                          _3235 = saturate(abs(_3092) + 9.999999747378752e-06f);
                                                          _3236 = 1.0f - _3208;
                                                          _3248 = saturate((_3066 + _3004) / (_3004 + 1.0f));
                                                          do {
                                                            _3354 = _3053;
                                                            _3355 = _3054;
                                                            _3356 = _3055;
                                                            [branch]
                                                            if (!((_2991 & 1) == 0)) {
                                                              _3264 = max(max(_3053, _3054), _3055);
                                                              do {
                                                                _3274 = _3053;
                                                                _3275 = _3054;
                                                                _3276 = _3055;
                                                                if (_3264 > 0.0f) {
                                                                  _3274 = saturate(_3053 / _3264);
                                                                  _3275 = saturate(_3054 / _3264);
                                                                  _3276 = saturate(_3055 / _3264);
                                                                }
                                                                _3277 = (_3275 < _3276);
                                                                _3278 = select(_3277, _3276, _3275);
                                                                _3279 = select(_3277, _3275, _3276);
                                                                _3280 = select(_3277, -1.0f, 0.0f);
                                                                _3281 = (_3274 < _3278);
                                                                _3283 = select(_3281, _3278, _3274);
                                                                _3284 = select(_3281, _3274, _3278);
                                                                _3288 = _3283 - select((_3284 < _3279), _3284, _3279);
                                                                _3294 = abs(select(_3281, (-0.3333333432674408f - _3280), _3280) + ((_3284 - _3279) / ((_3288 * 6.0f) + 9.999999682655225e-21f)));
                                                                do {
                                                                  _3307 = _3294;
                                                                  if (_3294 < 0.6666666865348816f) {
                                                                    _3307 = ((saturate(((float)((uint)((uint)(((uint)(_2991) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3294 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3294)) + _3294);
                                                                  }
                                                                  _3308 = saturate((_3288 / (_3283 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_2991) >> 1) & 255)))) * 0.003921499941498041f));
                                                                  _3309 = saturate(_3283);
                                                                  do {
                                                                    _3336 = _3309;
                                                                    _3337 = _3309;
                                                                    _3338 = _3309;
                                                                    if (!(_3308 <= 0.0f)) {
                                                                      _3312 = saturate(_3307);
                                                                      _3316 = select(((_3312 * 360.0f) >= 360.0f), 0.0f, (_3312 * 6.0f));
                                                                      _3317 = int(_3316);
                                                                      _3319 = _3316 - float((int)(_3317));
                                                                      _3321 = _3309 * (1.0f - _3308);
                                                                      _3324 = (1.0f - (_3319 * _3308)) * _3309;
                                                                      _3328 = (1.0f - ((1.0f - _3319) * _3308)) * _3309;
                                                                      switch (_3317) {
                                                                        case 0: {
                                                                          _3336 = _3309;
                                                                          _3337 = _3328;
                                                                          _3338 = _3321;
                                                                          break;
                                                                        }
                                                                        case 1: {
                                                                          _3336 = _3324;
                                                                          _3337 = _3309;
                                                                          _3338 = _3321;
                                                                          break;
                                                                        }
                                                                        case 2: {
                                                                          _3336 = _3321;
                                                                          _3337 = _3309;
                                                                          _3338 = _3328;
                                                                          break;
                                                                        }
                                                                        case 3: {
                                                                          _3336 = _3321;
                                                                          _3337 = _3324;
                                                                          _3338 = _3309;
                                                                          break;
                                                                        }
                                                                        case 4: {
                                                                          _3336 = _3328;
                                                                          _3337 = _3321;
                                                                          _3338 = _3309;
                                                                          break;
                                                                        }
                                                                        case 5: {
                                                                          _3336 = _3309;
                                                                          _3337 = _3321;
                                                                          _3338 = _3324;
                                                                          break;
                                                                        }
                                                                        default: {
                                                                          _3336 = 0.0f;
                                                                          _3337 = 0.0f;
                                                                          _3338 = 0.0f;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }
                                                                    _3339 = _3336 * _3264;
                                                                    _3340 = _3337 * _3264;
                                                                    _3341 = _3338 * _3264;
                                                                    _3343 = saturate(_3058 * 1.0101009607315063f);
                                                                    _3354 = ((_3343 * (_3053 - _3339)) + _3339);
                                                                    _3355 = ((_3343 * (_3054 - _3340)) + _3340);
                                                                    _3356 = (lerp(_3341, _3055, _3343));
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            _3357 = _3354 * _3058;
                                                            _3358 = _3355 * _3058;
                                                            _3359 = _3356 * _3058;
                                                            do {
                                                              _3369 = _3357;
                                                              _3370 = _3358;
                                                              _3371 = _3359;
                                                              if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                                                                _3369 = (_3357 * _1199);
                                                                _3370 = (_3358 * _1199);
                                                                _3371 = (_3359 * _1199);
                                                              }
                                                              _3375 = (_3369 * _3248) + _1437;
                                                              _3376 = (_3370 * _3248) + _1438;
                                                              _3377 = (_3371 * _3248) + _1439;
                                                              if (_3001 > 0.0f) {
                                                                _3381 = ((_3001 * _1068) * ((exp2(log2(1.0f - saturate(_3194)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f)) * (((_3219 * _3196) * (_3207 / (_3223 * _3223))) * (0.5f / ((((_3236 * _3235) + _3208) * _3196) + (((_3236 * _3196) + _3208) * _3235))));
                                                                _8247 = _3375;
                                                                _8248 = _3376;
                                                                _8249 = _3377;
                                                                _8250 = ((_3381 * _3369) + _1440);
                                                                _8251 = ((_3381 * _3370) + _1441);
                                                                _8252 = ((_3381 * _3371) + _1442);
                                                              } else {
                                                                _8247 = _3375;
                                                                _8248 = _3376;
                                                                _8249 = _3377;
                                                                _8250 = _1440;
                                                                _8251 = _1441;
                                                                _8252 = _1442;
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
                                                  _8247 = _1437;
                                                  _8248 = _1438;
                                                  _8249 = _1439;
                                                  _8250 = _1440;
                                                  _8251 = _1441;
                                                  _8252 = _1442;
                                                }
                                              } while (false);
                                              if (_loop_break_3) break;
                                            } else {
                                              _8247 = _1437;
                                              _8248 = _1438;
                                              _8249 = _1439;
                                              _8250 = _1440;
                                              _8251 = _1441;
                                              _8252 = _1442;
                                            }
                                          } while (false);
                                          if (_loop_break_3) break;
                                        } else {
                                          _1499 = _1479 * select(((_1449 & 67108864) != 0), 1.0f, (1.0f - _1432));
                                          [branch]
                                          if (_1482 == 4) {
                                            _1504 = asfloat(srvLightInfoProperties.Load4(_1451)).x;
                                            _1505 = asfloat(srvLightInfoProperties.Load4(_1451)).y;
                                            _1506 = asfloat(srvLightInfoProperties.Load4(_1451)).z;
                                            _1507 = asfloat(srvLightInfoProperties.Load4(_1451)).w;
                                            _1510 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).x;
                                            _1511 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).y;
                                            _1512 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).z;
                                            _1513 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).w;
                                            _1516 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).x;
                                            _1517 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).y;
                                            _1518 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).z;
                                            _1519 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).w;
                                            _1522 = asint(srvLightInfoProperties.Load(((int)(_1451 + 48u))));
                                            _1525 = asint(srvLightInfoProperties.Load(((int)(_1451 + 52u))));
                                            _1528 = asint(srvLightInfoProperties.Load(((int)(_1451 + 64u))));
                                            _1531 = asint(srvLightInfoProperties.Load(((int)(_1451 + 68u))));
                                            _1534 = asint(srvLightInfoProperties.Load(((int)(_1451 + 72u))));
                                            _1536 = f16tof32(((uint)((uint)(_1522) >> 16)));
                                            _1537 = f16tof32(_1522);
                                            _1539 = f16tof32(((uint)((uint)(_1525) >> 16)));
                                            _1543 = ((float)((uint)((uint)(((uint)(_1525) >> 8) & 255)))) * 0.003921499941498041f;
                                            _1556 = mad(_1506, _209, mad(_1505, _208, (_1504 * _207))) + _1507;
                                            _1560 = mad(_1512, _209, mad(_1511, _208, (_1510 * _207))) + _1513;
                                            _1564 = mad(_1518, _209, mad(_1517, _208, (_1516 * _207))) + _1519;
                                            _1589 = saturate(1.0f - ((_1556 + 1.0f) * f16tof32(_1528))) + saturate(1.0f - ((1.0f - _1556) * f16tof32(((uint)((uint)(_1528) >> 16)))));
                                            _1590 = saturate(1.0f - ((_1560 + 1.0f) * f16tof32(_1531))) + saturate(1.0f - ((1.0f - _1560) * f16tof32(((uint)((uint)(_1531) >> 16)))));
                                            _1591 = saturate(1.0f - ((_1564 + 1.0f) * f16tof32(_1534))) + saturate(1.0f - ((1.0f - _1564) * f16tof32(((uint)((uint)(_1534) >> 16)))));
                                            _1594 = saturate(1.0f - dot(float3(_1589, _1590, _1591), float3(_1589, _1590, _1591)));
                                            _1595 = _1594 * _1594;
                                            _1602 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1595 * _1199), _1595) * _1499;
                                            _8247 = ((_1602 * _1536) + _1437);
                                            _8248 = ((_1602 * _1537) + _1438);
                                            _8249 = ((_1602 * _1539) + _1439);
                                            _8250 = (((_1543 * _1536) * _1602) + _1440);
                                            _8251 = (((_1543 * _1537) * _1602) + _1441);
                                            _8252 = (((_1539 * _1543) * _1602) + _1442);
                                          } else {
                                            if (_1482 == 5) {
                                              _1623 = asfloat(srvLightInfoProperties.Load4(_1451)).x;
                                              _1624 = asfloat(srvLightInfoProperties.Load4(_1451)).y;
                                              _1625 = asfloat(srvLightInfoProperties.Load4(_1451)).z;
                                              _1626 = asfloat(srvLightInfoProperties.Load4(_1451)).w;
                                              _1629 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).x;
                                              _1630 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).y;
                                              _1631 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).z;
                                              _1632 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).w;
                                              _1635 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).x;
                                              _1636 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).y;
                                              _1637 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).z;
                                              _1638 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).w;
                                              _1641 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).x;
                                              _1642 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).y;
                                              _1643 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).z;
                                              _1646 = asfloat(srvLightInfoProperties.Load(((int)(_1451 + 60u))));
                                              _1649 = asint(srvLightInfoProperties.Load(((int)(_1451 + 64u))));
                                              _1652 = asint(srvLightInfoProperties.Load(((int)(_1451 + 68u))));
                                              _1655 = asint(srvLightInfoProperties.Load(((int)(_1451 + 80u))));
                                              _1658 = asint(srvLightInfoProperties.Load(((int)(_1451 + 84u))));
                                              _1661 = asint(srvLightInfoProperties.Load(((int)(_1451 + 88u))));
                                              _1664 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 92u)))).x;
                                              _1665 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 92u)))).y;
                                              _1666 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 92u)))).z;
                                              _1667 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 92u)))).w;
                                              _1670 = asint(srvLightInfoProperties.Load(((int)(_1451 + 108u))));
                                              _1673 = asint(srvLightInfoProperties.Load(((int)(_1451 + 112u))));
                                              _1676 = asint(srvLightInfoProperties.Load(((int)(_1451 + 120u))));
                                              _1679 = asint(srvLightInfoProperties.Load(((int)(_1451 + 124u))));
                                              _1682 = asint(srvLightInfoProperties.Load(((int)(_1451 + 128u))));
                                              _1685 = asint(srvLightInfoProperties.Load(((int)(_1451 + 132u))));
                                              _1688 = asint(srvLightInfoProperties.Load(((int)(_1451 + 136u))));
                                              _1691 = asint(srvLightInfoProperties.Load(((int)(_1451 + 140u))));
                                              _1693 = f16tof32(((uint)((uint)(_1649) >> 16)));
                                              _1694 = f16tof32(_1649);
                                              _1696 = f16tof32(((uint)((uint)(_1652) >> 16)));
                                              _1700 = ((float)((uint)((uint)(((uint)(_1652) >> 8) & 255)))) * 0.003921499941498041f;
                                              _1703 = ((float)((uint)((uint)(_1652 & 255)))) * 0.003921499941498041f;
                                              _1705 = f16tof32(((uint)((uint)(_1655) >> 16)));
                                              _1708 = _1658 & 65535;
                                              _1718 = f16tof32(((uint)((uint)(_1673) >> 16)));
                                              _1719 = f16tof32(_1673);
                                              _1721 = f16tof32(((uint)((uint)(_1676) >> 16)));
                                              _1722 = 1.0f / _1721;
                                              _1723 = _1721 + -1.0f;
                                              _1724 = f16tof32(_1676);
                                              _1743 = saturate(1.0f - dot(float3(_184, _185, _186), float3(_1641, _1642, _1643))) * f16tof32(_1670);
                                              _1747 = (_1743 * _184) + _207;
                                              _1748 = (_1743 * _185) + _208;
                                              _1749 = (_1743 * _186) - _206;
                                              _1753 = mad(_1625, _1749, mad(_1624, _1748, (_1747 * _1623))) + _1626;
                                              _1757 = mad(_1631, _1749, mad(_1630, _1748, (_1747 * _1629))) + _1632;
                                              _1761 = mad(_1637, _1749, mad(_1636, _1748, (_1747 * _1635))) + _1638;
                                              _1762 = saturate(_1761);
                                              _1785 = saturate(1.0f - (_1753 * f16tof32(_1685))) + saturate(1.0f - ((1.0f - _1753) * f16tof32(((uint)((uint)(_1685) >> 16)))));
                                              _1786 = saturate(1.0f - (_1757 * f16tof32(_1688))) + saturate(1.0f - ((1.0f - _1757) * f16tof32(((uint)((uint)(_1688) >> 16)))));
                                              _1787 = saturate(1.0f - (_1761 * f16tof32(_1691))) + saturate(1.0f - ((1.0f - _1761) * f16tof32(((uint)((uint)(_1691) >> 16)))));
                                              _1790 = saturate(1.0f - dot(float3(_1785, _1786, _1787), float3(_1785, _1786, _1787)));
                                              _1791 = _1790 * _1790;
                                              do {
                                                _2630 = 1.0f;
                                                if (!(((_1449 & 3584) == 0) || (!(_1791 > 0.0f)))) {
                                                  _1798 = 1.0f - _1762;
                                                  _1799 = saturate(_1753);
                                                  _1800 = saturate(_1757);
                                                  do {
                                                    _2063 = 1.0f;
                                                    _2064 = 0.0f;
                                                    _2065 = _1798;
                                                    [branch]
                                                    if (!((_1449 & 1024) == 0)) {
                                                      _1805 = ((_1799 * _1723) + 0.5f) * _1722;
                                                      _1807 = ((_1800 * _1723) + 0.5f) * _1722;
                                                      _1808 = _1798 + f16tof32(((uint)((uint)(_1670) >> 16)));
                                                      Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1658) >> 16))];
                                                      _1811 = saturate(_1808);
                                                      _1815 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                        _1824 = RenoDX_ISFASTShadowAngle(
                                                            uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 0u);
                                                      } else {
                                                        _1824 = frac(frac(dot(float2(((_1815 * 32.665000915527344f) + _124), ((_1815 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                      }
                                                      #else
                                                      _1824 = frac(frac(dot(float2(((_1815 * 32.665000915527344f) + _124), ((_1815 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                      #endif
                                                      _1825 = sin(_1824);
                                                      _1826 = cos(_1824);
                                                      _1827 = cbSharedPerViewData.nFrameCounter & 3;
                                                      _1832 = sqrt((float((int)(_1827)) * 0.25f) + 0.125f) * _1718;
                                                      _1841 = (_global_7[min((uint)(((int)(0u + (_1827 * 2)))), 127u)]) * _1832;
                                                      _1842 = (_global_7[min((uint)(((int)(1u + (_1827 * 2)))), 127u)]) * _1832;
                                                      _1844 = -0.0f - _1825;
                                                      _1849 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1841, _1842), float2(_1826, _1825)) + _1805), (dot(float2(_1841, _1842), float2(_1844, _1826)) + _1807)));
                                                      _1854 = _1849.x - _1811;
                                                      _1856 = select((_1854 < 0.0f), 0.0f, 1.0f);
                                                      _1858 = _1849.y - _1811;
                                                      _1860 = select((_1858 < 0.0f), 0.0f, 1.0f);
                                                      _1864 = _1849.z - _1811;
                                                      _1866 = select((_1864 < 0.0f), 0.0f, 1.0f);
                                                      _1870 = _1849.w - _1811;
                                                      _1872 = select((_1870 < 0.0f), 0.0f, 1.0f);
                                                      _1879 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                      _1884 = sqrt((float((int)(_1879)) * 0.25f) + 0.125f) * _1718;
                                                      _1893 = (_global_7[min((uint)(((int)(0u + (_1879 * 2)))), 127u)]) * _1884;
                                                      _1894 = (_global_7[min((uint)(((int)(1u + (_1879 * 2)))), 127u)]) * _1884;
                                                      _1900 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1893, _1894), float2(_1826, _1825)) + _1805), (dot(float2(_1893, _1894), float2(_1844, _1826)) + _1807)));
                                                      _1905 = _1900.x - _1811;
                                                      _1907 = select((_1905 < 0.0f), 0.0f, 1.0f);
                                                      _1911 = _1900.y - _1811;
                                                      _1913 = select((_1911 < 0.0f), 0.0f, 1.0f);
                                                      _1917 = _1900.z - _1811;
                                                      _1919 = select((_1917 < 0.0f), 0.0f, 1.0f);
                                                      _1923 = _1900.w - _1811;
                                                      _1925 = select((_1923 < 0.0f), 0.0f, 1.0f);
                                                      _1932 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                      _1937 = sqrt((float((int)(_1932)) * 0.25f) + 0.125f) * _1718;
                                                      _1946 = (_global_7[min((uint)(((int)(0u + (_1932 * 2)))), 127u)]) * _1937;
                                                      _1947 = (_global_7[min((uint)(((int)(1u + (_1932 * 2)))), 127u)]) * _1937;
                                                      _1953 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1946, _1947), float2(_1826, _1825)) + _1805), (dot(float2(_1946, _1947), float2(_1844, _1826)) + _1807)));
                                                      _1958 = _1953.x - _1811;
                                                      _1960 = select((_1958 < 0.0f), 0.0f, 1.0f);
                                                      _1964 = _1953.y - _1811;
                                                      _1966 = select((_1964 < 0.0f), 0.0f, 1.0f);
                                                      _1970 = _1953.z - _1811;
                                                      _1972 = select((_1970 < 0.0f), 0.0f, 1.0f);
                                                      _1976 = _1953.w - _1811;
                                                      _1978 = select((_1976 < 0.0f), 0.0f, 1.0f);
                                                      _1985 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                      _1990 = sqrt((float((int)(_1985)) * 0.25f) + 0.125f) * _1718;
                                                      _1999 = (_global_7[min((uint)(((int)(0u + (_1985 * 2)))), 127u)]) * _1990;
                                                      _2000 = (_global_7[min((uint)(((int)(1u + (_1985 * 2)))), 127u)]) * _1990;
                                                      _2006 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1999, _2000), float2(_1826, _1825)) + _1805), (dot(float2(_1999, _2000), float2(_1844, _1826)) + _1807)));
                                                      _2011 = _2006.x - _1811;
                                                      _2013 = select((_2011 < 0.0f), 0.0f, 1.0f);
                                                      _2017 = _2006.y - _1811;
                                                      _2019 = select((_2017 < 0.0f), 0.0f, 1.0f);
                                                      _2023 = _2006.z - _1811;
                                                      _2025 = select((_2023 < 0.0f), 0.0f, 1.0f);
                                                      _2029 = _2006.w - _1811;
                                                      _2031 = select((_2029 < 0.0f), 0.0f, 1.0f);
                                                      _2032 = ((((((((((((((_1856 + _1860) + _1866) + _1872) + _1907) + _1913) + _1919) + _1925) + _1960) + _1966) + _1972) + _1978) + _2013) + _2019) + _2025) + _2031;
                                                      _2043 = (saturate(_2032 * 0.0625f) * 2.0f) + -1.0f;
                                                      _2049 = float((int)(((int)(uint)((int)(_2043 > 0.0f))) - ((int)(uint)((int)(_2043 < 0.0f)))));
                                                      _2051 = 1.0f - (_2049 * _2043);
                                                      _2053 = (_2051 * _2051) * _2051;
                                                      _2060 = 0.5f - ((_2049 * 0.5f) * ((1.0f - _2053) - ((_2051 - _2053) * saturate(((1.0f / _1811) * (1.0f / _2032)) * ((((((((((((((((_1856 * _1854) + (_1860 * _1858)) + (_1866 * _1864)) + (_1872 * _1870)) + (_1907 * _1905)) + (_1913 * _1911)) + (_1919 * _1917)) + (_1925 * _1923)) + (_1960 * _1958)) + (_1966 * _1964)) + (_1972 * _1970)) + (_1978 * _1976)) + (_2013 * _2011)) + (_2019 * _2017)) + (_2025 * _2023)) + (_2031 * _2029))))));
                                                      [branch]
                                                      if (!(_1724 < 1.0f)) {
                                                        _2533 = _2060;
                                                        do {
                                                          _2630 = _2533;
                                                          [branch]
                                                          if (!((_1449 & 2048) == 0)) {
                                                            Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1661) >> 16))];
                                                            _2539 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1753, _1757), 0.0f);
                                                            if (_2539.x > 0.0f) {
                                                              Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1661 & 65535))];
                                                              _2546 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1753, _1757), 0.0f);
                                                              _2560 = mad(saturate(((log2(_1762 * _1646) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                              _2561 = max(9.999999747378752e-06f, _2539.x);
                                                              _2562 = _2546.x / _2561;
                                                              _2563 = _2546.y / _2561;
                                                              _2565 = _2546.w / _2561;
                                                              _2570 = ((0.375f - _2563) * 4.999999873689376e-06f) + _2563;
                                                              _2573 = -0.0f - _2562;
                                                              _2574 = mad(_2573, _2570, (_2546.z / _2561));
                                                              _2576 = 1.0f / mad(_2573, _2562, _2570);
                                                              _2577 = _2576 * _2574;
                                                              _2582 = _2560 - _2562;
                                                              _2587 = (((_2560 * _2560) - _2570) - (_2577 * _2582)) / mad((-0.0f - _2574), _2577, mad((-0.0f - _2570), _2570, (((0.375f - _2565) * 4.999999873689376e-06f) + _2565)));
                                                              _2589 = (_2576 * _2582) - (_2587 * _2577);
                                                              _2592 = 1.0f / _2587;
                                                              _2593 = _2589 * _2592;
                                                              _2598 = sqrt(((_2593 * _2593) * 0.25f) - ((1.0f - dot(float2(_2589, _2587), float2(_2562, _2570))) * _2592));
                                                              _2600 = (_2593 * -0.5f) - _2598;
                                                              _2602 = _2598 - (_2593 * 0.5f);
                                                              _2604 = select((_2600 < _2560), 1.0f, 0.0f);
                                                              _2609 = (_2604 + -0.05000000074505806f) / (_2600 - _2560);
                                                              _2615 = (((select((_2602 < _2560), 1.0f, 0.0f) - _2604) / (_2602 - _2600)) - _2609) / (_2602 - _2560);
                                                              _2617 = _2609 - (_2615 * _2600);
                                                              _2630 = (exp2((_2539.x * -1.4426950216293335f) * saturate((dot(float2(_2562, _2570), float2((_2617 - (_2615 * _2560)), _2615)) + 0.05000000074505806f) - (_2617 * _2560))) * _2533);
                                                            } else {
                                                              _2630 = _2533;
                                                            }
                                                          }
                                                          break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                        // Native completed depth-gather shadow bypasses the fallback path.
                                                        break;
                                                      } else {
                                                        _2063 = _2060;
                                                        _2064 = _1724;
                                                        _2065 = _1808;
                                                      }
                                                    }
                                                    _2068 = (_1799 * _1664) + _1666;
                                                    _2069 = (_1800 * _1665) + _1667;
                                                    do {
                                                      _2528 = 1.0f;
                                                      if (!((_1449 & 512) == 0)) {
                                                        Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                                                        _2078 = saturate(_2065);
                                                        _2082 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                        #if FIRSTLIGHT_ISFAST_ENABLED
                                                        if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                          _2091 = RenoDX_ISFASTShadowAngle(
                                                              uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 1u);
                                                        } else {
                                                          _2091 = frac(frac(dot(float2(((_2082 * 32.665000915527344f) + _124), ((_2082 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                        }
                                                        #else
                                                        _2091 = frac(frac(dot(float2(((_2082 * 32.665000915527344f) + _124), ((_2082 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                        #endif
                                                        _2092 = sin(_2091);
                                                        _2093 = cos(_2091);
                                                        _2098 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2068, _2069), 0.0f))).x) > _2078), 1.0f, 0.0f);
                                                        _2099 = cbSharedPerViewData.nFrameCounter & 3;
                                                        _2104 = sqrt((float((int)(_2099)) * 0.25f) + 0.125f) * _1719;
                                                        _2113 = (_global_7[min((uint)(((int)(0u + (_2099 * 2)))), 127u)]) * _2104;
                                                        _2114 = (_global_7[min((uint)(((int)(1u + (_2099 * 2)))), 127u)]) * _2104;
                                                        _2116 = -0.0f - _2092;
                                                        _2118 = dot(float2(_2113, _2114), float2(_2093, _2092)) + _2068;
                                                        _2119 = dot(float2(_2113, _2114), float2(_2116, _2093)) + _2069;
                                                        _2121 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2118, _2119));
                                                        _2125 = _2118 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                        _2126 = _2119 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                        _2129 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1666);
                                                        _2130 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1667);
                                                        _2135 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1664 + _1666)) + 0.5f);
                                                        _2136 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1665 + _1667)) + 0.5f);
                                                        _2139 = floor(_2125 + -0.5f);
                                                        _2140 = floor(_2126 + 0.5f);
                                                        _2142 = floor(_2125 + 0.5f);
                                                        _2144 = floor(_2126 + -0.5f);
                                                        _2145 = (_2139 < _2129);
                                                        _2146 = (_2140 < _2130);
                                                        do {
                                                          if (!(_2145 || _2146)) {
                                                            if ((_2139 >= _2135) || (_2140 >= _2136)) {
                                                              _2155 = _2098;
                                                            } else {
                                                              _2155 = _2121.x;
                                                            }
                                                          } else {
                                                            _2155 = _2098;
                                                          }
                                                          _2156 = (_2142 < _2129);
                                                          do {
                                                            if (!(_2156 || _2146)) {
                                                              if ((_2142 >= _2135) || (_2140 >= _2136)) {
                                                                _2164 = _2098;
                                                              } else {
                                                                _2164 = _2121.y;
                                                              }
                                                            } else {
                                                              _2164 = _2098;
                                                            }
                                                            _2165 = (_2144 < _2130);
                                                            do {
                                                              if (!(_2156 || _2165)) {
                                                                if ((_2142 >= _2135) || (_2144 >= _2136)) {
                                                                  _2173 = _2098;
                                                                } else {
                                                                  _2173 = _2121.z;
                                                                }
                                                              } else {
                                                                _2173 = _2098;
                                                              }
                                                              do {
                                                                if (!(_2145 || _2165)) {
                                                                  if ((_2139 >= _2135) || (_2144 >= _2136)) {
                                                                    _2181 = _2098;
                                                                  } else {
                                                                    _2181 = _2121.w;
                                                                  }
                                                                } else {
                                                                  _2181 = _2098;
                                                                }
                                                                _2182 = _2155 - _2078;
                                                                _2184 = select((_2182 < 0.0f), 0.0f, 1.0f);
                                                                _2186 = _2164 - _2078;
                                                                _2188 = select((_2186 < 0.0f), 0.0f, 1.0f);
                                                                _2192 = _2173 - _2078;
                                                                _2194 = select((_2192 < 0.0f), 0.0f, 1.0f);
                                                                _2198 = _2181 - _2078;
                                                                _2200 = select((_2198 < 0.0f), 0.0f, 1.0f);
                                                                _2207 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                _2212 = sqrt((float((int)(_2207)) * 0.25f) + 0.125f) * _1719;
                                                                _2221 = (_global_7[min((uint)(((int)(0u + (_2207 * 2)))), 127u)]) * _2212;
                                                                _2222 = (_global_7[min((uint)(((int)(1u + (_2207 * 2)))), 127u)]) * _2212;
                                                                _2225 = dot(float2(_2221, _2222), float2(_2093, _2092)) + _2068;
                                                                _2226 = dot(float2(_2221, _2222), float2(_2116, _2093)) + _2069;
                                                                _2228 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2225, _2226));
                                                                _2232 = _2225 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                _2233 = _2226 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                _2236 = floor(_2232 + -0.5f);
                                                                _2237 = floor(_2233 + 0.5f);
                                                                _2239 = floor(_2232 + 0.5f);
                                                                _2241 = floor(_2233 + -0.5f);
                                                                _2242 = (_2236 < _2129);
                                                                _2243 = (_2237 < _2130);
                                                                do {
                                                                  if (!(_2242 || _2243)) {
                                                                    if ((_2236 >= _2135) || (_2237 >= _2136)) {
                                                                      _2252 = _2098;
                                                                    } else {
                                                                      _2252 = _2228.x;
                                                                    }
                                                                  } else {
                                                                    _2252 = _2098;
                                                                  }
                                                                  _2253 = (_2239 < _2129);
                                                                  do {
                                                                    if (!(_2253 || _2243)) {
                                                                      if ((_2239 >= _2135) || (_2237 >= _2136)) {
                                                                        _2261 = _2098;
                                                                      } else {
                                                                        _2261 = _2228.y;
                                                                      }
                                                                    } else {
                                                                      _2261 = _2098;
                                                                    }
                                                                    _2262 = (_2241 < _2130);
                                                                    do {
                                                                      if (!(_2253 || _2262)) {
                                                                        if ((_2239 >= _2135) || (_2241 >= _2136)) {
                                                                          _2270 = _2098;
                                                                        } else {
                                                                          _2270 = _2228.z;
                                                                        }
                                                                      } else {
                                                                        _2270 = _2098;
                                                                      }
                                                                      do {
                                                                        if (!(_2242 || _2262)) {
                                                                          if ((_2236 >= _2135) || (_2241 >= _2136)) {
                                                                            _2278 = _2098;
                                                                          } else {
                                                                            _2278 = _2228.w;
                                                                          }
                                                                        } else {
                                                                          _2278 = _2098;
                                                                        }
                                                                        _2279 = _2252 - _2078;
                                                                        _2281 = select((_2279 < 0.0f), 0.0f, 1.0f);
                                                                        _2285 = _2261 - _2078;
                                                                        _2287 = select((_2285 < 0.0f), 0.0f, 1.0f);
                                                                        _2291 = _2270 - _2078;
                                                                        _2293 = select((_2291 < 0.0f), 0.0f, 1.0f);
                                                                        _2297 = _2278 - _2078;
                                                                        _2299 = select((_2297 < 0.0f), 0.0f, 1.0f);
                                                                        _2306 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                        _2311 = sqrt((float((int)(_2306)) * 0.25f) + 0.125f) * _1719;
                                                                        _2320 = (_global_7[min((uint)(((int)(0u + (_2306 * 2)))), 127u)]) * _2311;
                                                                        _2321 = (_global_7[min((uint)(((int)(1u + (_2306 * 2)))), 127u)]) * _2311;
                                                                        _2324 = dot(float2(_2320, _2321), float2(_2093, _2092)) + _2068;
                                                                        _2325 = dot(float2(_2320, _2321), float2(_2116, _2093)) + _2069;
                                                                        _2327 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2324, _2325));
                                                                        _2331 = _2324 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                        _2332 = _2325 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                        _2335 = floor(_2331 + -0.5f);
                                                                        _2336 = floor(_2332 + 0.5f);
                                                                        _2338 = floor(_2331 + 0.5f);
                                                                        _2340 = floor(_2332 + -0.5f);
                                                                        _2341 = (_2335 < _2129);
                                                                        _2342 = (_2336 < _2130);
                                                                        do {
                                                                          if (!(_2341 || _2342)) {
                                                                            if ((_2335 >= _2135) || (_2336 >= _2136)) {
                                                                              _2351 = _2098;
                                                                            } else {
                                                                              _2351 = _2327.x;
                                                                            }
                                                                          } else {
                                                                            _2351 = _2098;
                                                                          }
                                                                          _2352 = (_2338 < _2129);
                                                                          do {
                                                                            if (!(_2352 || _2342)) {
                                                                              if ((_2338 >= _2135) || (_2336 >= _2136)) {
                                                                                _2360 = _2098;
                                                                              } else {
                                                                                _2360 = _2327.y;
                                                                              }
                                                                            } else {
                                                                              _2360 = _2098;
                                                                            }
                                                                            _2361 = (_2340 < _2130);
                                                                            do {
                                                                              if (!(_2352 || _2361)) {
                                                                                if ((_2338 >= _2135) || (_2340 >= _2136)) {
                                                                                  _2369 = _2098;
                                                                                } else {
                                                                                  _2369 = _2327.z;
                                                                                }
                                                                              } else {
                                                                                _2369 = _2098;
                                                                              }
                                                                              do {
                                                                                if (!(_2341 || _2361)) {
                                                                                  if ((_2335 >= _2135) || (_2340 >= _2136)) {
                                                                                    _2377 = _2098;
                                                                                  } else {
                                                                                    _2377 = _2327.w;
                                                                                  }
                                                                                } else {
                                                                                  _2377 = _2098;
                                                                                }
                                                                                _2378 = _2351 - _2078;
                                                                                _2380 = select((_2378 < 0.0f), 0.0f, 1.0f);
                                                                                _2384 = _2360 - _2078;
                                                                                _2386 = select((_2384 < 0.0f), 0.0f, 1.0f);
                                                                                _2390 = _2369 - _2078;
                                                                                _2392 = select((_2390 < 0.0f), 0.0f, 1.0f);
                                                                                _2396 = _2377 - _2078;
                                                                                _2398 = select((_2396 < 0.0f), 0.0f, 1.0f);
                                                                                _2405 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                _2410 = sqrt((float((int)(_2405)) * 0.25f) + 0.125f) * _1719;
                                                                                _2419 = (_global_7[min((uint)(((int)(0u + (_2405 * 2)))), 127u)]) * _2410;
                                                                                _2420 = (_global_7[min((uint)(((int)(1u + (_2405 * 2)))), 127u)]) * _2410;
                                                                                _2423 = dot(float2(_2419, _2420), float2(_2093, _2092)) + _2068;
                                                                                _2424 = dot(float2(_2419, _2420), float2(_2116, _2093)) + _2069;
                                                                                _2426 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2423, _2424));
                                                                                _2430 = _2423 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                _2431 = _2424 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                _2434 = floor(_2430 + -0.5f);
                                                                                _2435 = floor(_2431 + 0.5f);
                                                                                _2437 = floor(_2430 + 0.5f);
                                                                                _2439 = floor(_2431 + -0.5f);
                                                                                _2440 = (_2434 < _2129);
                                                                                _2441 = (_2435 < _2130);
                                                                                do {
                                                                                  if (!(_2440 || _2441)) {
                                                                                    if ((_2434 >= _2135) || (_2435 >= _2136)) {
                                                                                      _2450 = _2098;
                                                                                    } else {
                                                                                      _2450 = _2426.x;
                                                                                    }
                                                                                  } else {
                                                                                    _2450 = _2098;
                                                                                  }
                                                                                  _2451 = (_2437 < _2129);
                                                                                  do {
                                                                                    if (!(_2451 || _2441)) {
                                                                                      if ((_2437 >= _2135) || (_2435 >= _2136)) {
                                                                                        _2459 = _2098;
                                                                                      } else {
                                                                                        _2459 = _2426.y;
                                                                                      }
                                                                                    } else {
                                                                                      _2459 = _2098;
                                                                                    }
                                                                                    _2460 = (_2439 < _2130);
                                                                                    do {
                                                                                      if (!(_2451 || _2460)) {
                                                                                        if ((_2437 >= _2135) || (_2439 >= _2136)) {
                                                                                          _2468 = _2098;
                                                                                        } else {
                                                                                          _2468 = _2426.z;
                                                                                        }
                                                                                      } else {
                                                                                        _2468 = _2098;
                                                                                      }
                                                                                      do {
                                                                                        if (!(_2440 || _2460)) {
                                                                                          if ((_2434 >= _2135) || (_2439 >= _2136)) {
                                                                                            _2476 = _2098;
                                                                                          } else {
                                                                                            _2476 = _2426.w;
                                                                                          }
                                                                                        } else {
                                                                                          _2476 = _2098;
                                                                                        }
                                                                                        _2477 = _2450 - _2078;
                                                                                        _2479 = select((_2477 < 0.0f), 0.0f, 1.0f);
                                                                                        _2483 = _2459 - _2078;
                                                                                        _2485 = select((_2483 < 0.0f), 0.0f, 1.0f);
                                                                                        _2489 = _2468 - _2078;
                                                                                        _2491 = select((_2489 < 0.0f), 0.0f, 1.0f);
                                                                                        _2495 = _2476 - _2078;
                                                                                        _2497 = select((_2495 < 0.0f), 0.0f, 1.0f);
                                                                                        _2498 = ((((((((((((((_2188 + _2184) + _2194) + _2200) + _2281) + _2287) + _2293) + _2299) + _2380) + _2386) + _2392) + _2398) + _2479) + _2485) + _2491) + _2497;
                                                                                        _2509 = (saturate(_2498 * 0.0625f) * 2.0f) + -1.0f;
                                                                                        _2515 = float((int)(((int)(uint)((int)(_2509 > 0.0f))) - ((int)(uint)((int)(_2509 < 0.0f)))));
                                                                                        _2517 = 1.0f - (_2515 * _2509);
                                                                                        _2519 = (_2517 * _2517) * _2517;
                                                                                        _2528 = (0.5f - ((_2515 * 0.5f) * ((1.0f - _2519) - ((_2517 - _2519) * saturate(((1.0f / _2078) * (1.0f / _2498)) * ((((((((((((((((_2188 * _2186) + (_2184 * _2182)) + (_2194 * _2192)) + (_2200 * _2198)) + (_2281 * _2279)) + (_2287 * _2285)) + (_2293 * _2291)) + (_2299 * _2297)) + (_2380 * _2378)) + (_2386 * _2384)) + (_2392 * _2390)) + (_2398 * _2396)) + (_2479 * _2477)) + (_2485 * _2483)) + (_2491 * _2489)) + (_2497 * _2495)))))));
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
                                                      _2533 = (lerp(_2528, _2063, _2064));
                                                      [branch]
                                                      if (!((_1449 & 2048) == 0)) {
                                                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1661) >> 16))];
                                                        _2539 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1753, _1757), 0.0f);
                                                        if (_2539.x > 0.0f) {
                                                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1661 & 65535))];
                                                          _2546 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1753, _1757), 0.0f);
                                                          _2560 = mad(saturate(((log2(_1762 * _1646) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                          _2561 = max(9.999999747378752e-06f, _2539.x);
                                                          _2562 = _2546.x / _2561;
                                                          _2563 = _2546.y / _2561;
                                                          _2565 = _2546.w / _2561;
                                                          _2570 = ((0.375f - _2563) * 4.999999873689376e-06f) + _2563;
                                                          _2573 = -0.0f - _2562;
                                                          _2574 = mad(_2573, _2570, (_2546.z / _2561));
                                                          _2576 = 1.0f / mad(_2573, _2562, _2570);
                                                          _2577 = _2576 * _2574;
                                                          _2582 = _2560 - _2562;
                                                          _2587 = (((_2560 * _2560) - _2570) - (_2577 * _2582)) / mad((-0.0f - _2574), _2577, mad((-0.0f - _2570), _2570, (((0.375f - _2565) * 4.999999873689376e-06f) + _2565)));
                                                          _2589 = (_2576 * _2582) - (_2587 * _2577);
                                                          _2592 = 1.0f / _2587;
                                                          _2593 = _2589 * _2592;
                                                          _2598 = sqrt(((_2593 * _2593) * 0.25f) - ((1.0f - dot(float2(_2589, _2587), float2(_2562, _2570))) * _2592));
                                                          _2600 = (_2593 * -0.5f) - _2598;
                                                          _2602 = _2598 - (_2593 * 0.5f);
                                                          _2604 = select((_2600 < _2560), 1.0f, 0.0f);
                                                          _2609 = (_2604 + -0.05000000074505806f) / (_2600 - _2560);
                                                          _2615 = (((select((_2602 < _2560), 1.0f, 0.0f) - _2604) / (_2602 - _2600)) - _2609) / (_2602 - _2560);
                                                          _2617 = _2609 - (_2615 * _2600);
                                                          _2630 = (exp2((_2539.x * -1.4426950216293335f) * saturate((dot(float2(_2562, _2570), float2((_2617 - (_2615 * _2560)), _2615)) + 0.05000000074505806f) - (_2617 * _2560))) * _2533);
                                                        } else {
                                                          _2630 = _2533;
                                                        }
                                                      } else {
                                                        _2630 = _2533;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                }
                                                do {
                                                  _2651 = _1693;
                                                  _2652 = _1694;
                                                  _2653 = _1696;
                                                  [branch]
                                                  if (!(_1708 == 0)) {
                                                    Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1708)))];
                                                    _2643 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1753 * f16tof32(((uint)((uint)(_1679) >> 16)))) + f16tof32(((uint)((uint)(_1682) >> 16)))), ((_1757 * f16tof32(_1679)) + f16tof32(_1682))), 0.0f);
                                                    _2651 = (_2643.x * _1693);
                                                    _2652 = (_2643.y * _1694);
                                                    _2653 = (_2643.z * _1696);
                                                  }
                                                  _2654 = _2630 * _1791;
                                                  [branch]
                                                  if (!(_2654 == 0.0f)) {
                                                    do {
                                                      _2672 = GetDeferredSoftShadowChannel(_1452);
                                                      if (_2672 < 0) {
                                                            _2693 = _2654;
                                                            do {
                                                              _8247 = _1437;
                                                              _8248 = _1438;
                                                              _8249 = _1439;
                                                              _8250 = _1440;
                                                              _8251 = _1441;
                                                              _8252 = _1442;
                                                              [branch]
                                                              if (!(_2693 == 0.0f)) {
                                                                do {
                                                                  _2732 = _2693;
                                                                  [branch]
                                                                  if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                    _2703 = srvLightMappingData[_1452];
                                                                    if (!(_2703 == -1)) {
                                                                      _2708 = srvLightIndexData[_2703].nLayerIndex;
                                                                      _2710 = srvLightIndexData[_2703].vAtlasOrigin.x;
                                                                      _2711 = srvLightIndexData[_2703].vAtlasOrigin.y;
                                                                      _2713 = srvLightIndexData[_2703].vScreenOrigin.x;
                                                                      _2714 = srvLightIndexData[_2703].vScreenOrigin.y;
                                                                      _2723 = ((int)(_2708 * 5)) & 31;
                                                                      _2732 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2710 + _62) - _2713)), ((int)((_2711 + _63) - _2714)), 0)))).x) & ((int)(31 << _2723)))) >> _2723)) >> 1)))) * 0.06666667014360428f) * _2693);
                                                                    } else {
                                                                      _2732 = _2693;
                                                                    }
                                                                  }
                                                                  _2736 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                  _2739 = select(_2736, (_2732 * _1199), _2732);
                                                                  _2741 = dot(float3(_1641, _1642, _1643), float3(_1641, _1642, _1643));
                                                                  _2742 = rsqrt(_2741);
                                                                  _2743 = _2742 * _1641;
                                                                  _2744 = _2742 * _1642;
                                                                  _2745 = _2742 * _1643;
                                                                  _2746 = dot(float3(_184, _185, _186), float3(_2743, _2744, _2745));
                                                                  do {
                                                                    _2764 = _2746;
                                                                    if (_1705 > 0.0f) {
                                                                      _2754 = sqrt(saturate((_1705 * _1705) * (1.0f / (_2741 + 1.0f))));
                                                                      if (_2746 < _2754) {
                                                                        _2759 = max(_2746, (-0.0f - _2754)) + _2754;
                                                                        _2764 = ((_2759 * _2759) / (_2754 * 4.0f));
                                                                      } else {
                                                                        _2764 = _2746;
                                                                      }
                                                                    }
                                                                    _2765 = _195 * _195;
                                                                    _2769 = saturate((_1705 * (1.0f - _2765)) * _2742);
                                                                    _2771 = saturate(_2742 * f16tof32(_1655));
                                                                    _2772 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                                    _2773 = dot(float3(_380, _381, _379), float3(_2743, _2744, _2745));
                                                                    _2776 = rsqrt((_2773 * 2.0f) + 2.0f);
                                                                    _2783 = (_2769 > 0.0f);
                                                                    do {
                                                                      _2874 = saturate((_2776 * _2773) + _2776);
                                                                      _2875 = saturate(_2776 * (_2772 + _2746));
                                                                      if (_2783) {
                                                                        _2787 = sqrt(1.0f - (_2769 * _2769));
                                                                        _2789 = (_2746 * 2.0f) * _2772;
                                                                        _2790 = _2789 - _2773;
                                                                        if (!(!(_2790 >= _2787))) {
                                                                          _2874 = abs(_2772);
                                                                          _2875 = 1.0f;
                                                                        } else {
                                                                          _2798 = rsqrt(1.0f - (_2790 * _2790)) * _2769;
                                                                          _2801 = _2798 * (_2772 - (_2790 * _2746));
                                                                          _2802 = _2772 * _2772;
                                                                          _2807 = _2798 * (((_2802 * 2.0f) + -1.0f) - (_2790 * _2773));
                                                                          _2816 = sqrt(saturate((((1.0f - (_2746 * _2746)) - _2802) - (_2773 * _2773)) + (_2789 * _2773)));
                                                                          _2817 = _2816 * _2798;
                                                                          _2820 = ((_2772 * 2.0f) * _2798) * _2816;
                                                                          _2822 = (_2787 * _2746) + _2772;
                                                                          _2823 = _2822 + _2801;
                                                                          _2824 = _2787 * _2773;
                                                                          _2826 = (_2824 + 1.0f) + _2807;
                                                                          _2827 = _2817 * _2826;
                                                                          _2828 = _2823 * _2826;
                                                                          _2829 = _2820 * _2823;
                                                                          _2834 = (((_2823 * 0.25f) * _2820) - (_2827 * 0.5f)) * _2828;
                                                                          _2848 = (((_2829 - (_2827 * 2.0f)) * _2829) + (_2827 * _2827)) + ((((-0.5f - ((_2826 + _2824) * 0.5f)) * _2828) + ((_2826 * _2826) * _2822)) * _2823);
                                                                          _2853 = (_2834 * 2.0f) / ((_2848 * _2848) + (_2834 * _2834));
                                                                          _2854 = _2848 * _2853;
                                                                          _2856 = 1.0f - (_2834 * _2853);
                                                                          _2862 = ((_2854 * _2820) + _2824) + (_2856 * _2807);
                                                                          _2865 = rsqrt((_2862 * 2.0f) + 2.0f);
                                                                          _2874 = saturate((_2862 * _2865) + _2865);
                                                                          _2875 = saturate(((_2822 + (_2854 * _2817)) + (_2856 * _2801)) * _2865);
                                                                        }
                                                                      }
                                                                      _2876 = saturate(_2764);
                                                                      _2877 = _2765 * _2765;
                                                                      do {
                                                                        _2887 = _2877;
                                                                        if (_2771 > 0.0f) {
                                                                          _2887 = saturate(((_2771 * _2771) / ((_2874 * 3.5999999046325684f) + 0.4000000059604645f)) + _2877);
                                                                        }
                                                                        _2888 = sqrt(_2887);
                                                                        do {
                                                                          _2899 = 1.0f;
                                                                          if (_2783) {
                                                                            _2899 = (_2887 / ((((_2769 * 0.25f) * ((_2888 * 3.0f) + _2769)) / (_2874 + 0.0010000000474974513f)) + _2887));
                                                                          }
                                                                          _2903 = (((_2887 * _2875) - _2875) * _2875) + 1.0f;
                                                                          _2908 = saturate(abs(_2772) + 9.999999747378752e-06f);
                                                                          _2909 = 1.0f - _2888;
                                                                          _2921 = saturate((_2746 + _1703) / (_1703 + 1.0f));
                                                                          _2924 = ((_2899 * _2876) * (_2887 / (_2903 * _2903))) * (0.5f / ((((_2909 * _2908) + _2888) * _2876) + (((_2909 * _2876) + _2888) * _2908)));
                                                                          _2925 = _2651 * _1499;
                                                                          _2926 = _2652 * _1499;
                                                                          _2927 = _2653 * _1499;
                                                                          _2934 = ((_2739 * _2925) * _2921) + _1437;
                                                                          _2935 = ((_2739 * _2926) * _2921) + _1438;
                                                                          _2936 = ((_2739 * _2927) * _2921) + _1439;
                                                                          if (_1700 > 0.0f) {
                                                                            _2944 = (exp2(log2(1.0f - saturate(_2874)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                            _2945 = select(_2736, (_2732 * _1199), _2732) * _1700;
                                                                            _8247 = _2934;
                                                                            _8248 = _2935;
                                                                            _8249 = _2936;
                                                                            _8250 = (((((_2925 * _1068) * _2945) * _2944) * _2924) + _1440);
                                                                            _8251 = (((((_2926 * _1068) * _2945) * _2944) * _2924) + _1441);
                                                                            _8252 = (((((_2927 * _1068) * _2945) * _2944) * _2924) + _1442);
                                                                          } else {
                                                                            _8247 = _2934;
                                                                            _8248 = _2935;
                                                                            _8249 = _2936;
                                                                            _8250 = _1440;
                                                                            _8251 = _1441;
                                                                            _8252 = _1442;
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
                                                              }
                                                              break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                        // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                        break;
                                                      }
                                                      _2675 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_62, _63, 0));
                                                      do {
                                                        if (_2672 == 0) {
                                                          _2689 = _2675.x;
                                                        } else {
                                                          if (_2672 == 1) {
                                                            _2689 = _2675.y;
                                                          } else {
                                                            if (_2672 == 2) {
                                                              _2689 = _2675.z;
                                                            } else {
                                                              _2689 = _2675.w;
                                                            }
                                                          }
                                                        }
                                                        _2693 = ((_2689 * _2689) * _1791);
                                                        [branch]
                                                        if (!(_2693 == 0.0f)) {
                                                          do {
                                                            _2732 = _2693;
                                                            [branch]
                                                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                              _2703 = srvLightMappingData[_1452];
                                                              if (!(_2703 == -1)) {
                                                                _2708 = srvLightIndexData[_2703].nLayerIndex;
                                                                _2710 = srvLightIndexData[_2703].vAtlasOrigin.x;
                                                                _2711 = srvLightIndexData[_2703].vAtlasOrigin.y;
                                                                _2713 = srvLightIndexData[_2703].vScreenOrigin.x;
                                                                _2714 = srvLightIndexData[_2703].vScreenOrigin.y;
                                                                _2723 = ((int)(_2708 * 5)) & 31;
                                                                _2732 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2710 + _62) - _2713)), ((int)((_2711 + _63) - _2714)), 0)))).x) & ((int)(31 << _2723)))) >> _2723)) >> 1)))) * 0.06666667014360428f) * _2693);
                                                              } else {
                                                                _2732 = _2693;
                                                              }
                                                            }
                                                            _2736 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                            _2739 = select(_2736, (_2732 * _1199), _2732);
                                                            _2741 = dot(float3(_1641, _1642, _1643), float3(_1641, _1642, _1643));
                                                            _2742 = rsqrt(_2741);
                                                            _2743 = _2742 * _1641;
                                                            _2744 = _2742 * _1642;
                                                            _2745 = _2742 * _1643;
                                                            _2746 = dot(float3(_184, _185, _186), float3(_2743, _2744, _2745));
                                                            do {
                                                              _2764 = _2746;
                                                              if (_1705 > 0.0f) {
                                                                _2754 = sqrt(saturate((_1705 * _1705) * (1.0f / (_2741 + 1.0f))));
                                                                if (_2746 < _2754) {
                                                                  _2759 = max(_2746, (-0.0f - _2754)) + _2754;
                                                                  _2764 = ((_2759 * _2759) / (_2754 * 4.0f));
                                                                } else {
                                                                  _2764 = _2746;
                                                                }
                                                              }
                                                              _2765 = _195 * _195;
                                                              _2769 = saturate((_1705 * (1.0f - _2765)) * _2742);
                                                              _2771 = saturate(_2742 * f16tof32(_1655));
                                                              _2772 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                              _2773 = dot(float3(_380, _381, _379), float3(_2743, _2744, _2745));
                                                              _2776 = rsqrt((_2773 * 2.0f) + 2.0f);
                                                              _2783 = (_2769 > 0.0f);
                                                              do {
                                                                _2874 = saturate((_2776 * _2773) + _2776);
                                                                _2875 = saturate(_2776 * (_2772 + _2746));
                                                                if (_2783) {
                                                                  _2787 = sqrt(1.0f - (_2769 * _2769));
                                                                  _2789 = (_2746 * 2.0f) * _2772;
                                                                  _2790 = _2789 - _2773;
                                                                  if (!(!(_2790 >= _2787))) {
                                                                    _2874 = abs(_2772);
                                                                    _2875 = 1.0f;
                                                                  } else {
                                                                    _2798 = rsqrt(1.0f - (_2790 * _2790)) * _2769;
                                                                    _2801 = _2798 * (_2772 - (_2790 * _2746));
                                                                    _2802 = _2772 * _2772;
                                                                    _2807 = _2798 * (((_2802 * 2.0f) + -1.0f) - (_2790 * _2773));
                                                                    _2816 = sqrt(saturate((((1.0f - (_2746 * _2746)) - _2802) - (_2773 * _2773)) + (_2789 * _2773)));
                                                                    _2817 = _2816 * _2798;
                                                                    _2820 = ((_2772 * 2.0f) * _2798) * _2816;
                                                                    _2822 = (_2787 * _2746) + _2772;
                                                                    _2823 = _2822 + _2801;
                                                                    _2824 = _2787 * _2773;
                                                                    _2826 = (_2824 + 1.0f) + _2807;
                                                                    _2827 = _2817 * _2826;
                                                                    _2828 = _2823 * _2826;
                                                                    _2829 = _2820 * _2823;
                                                                    _2834 = (((_2823 * 0.25f) * _2820) - (_2827 * 0.5f)) * _2828;
                                                                    _2848 = (((_2829 - (_2827 * 2.0f)) * _2829) + (_2827 * _2827)) + ((((-0.5f - ((_2826 + _2824) * 0.5f)) * _2828) + ((_2826 * _2826) * _2822)) * _2823);
                                                                    _2853 = (_2834 * 2.0f) / ((_2848 * _2848) + (_2834 * _2834));
                                                                    _2854 = _2848 * _2853;
                                                                    _2856 = 1.0f - (_2834 * _2853);
                                                                    _2862 = ((_2854 * _2820) + _2824) + (_2856 * _2807);
                                                                    _2865 = rsqrt((_2862 * 2.0f) + 2.0f);
                                                                    _2874 = saturate((_2862 * _2865) + _2865);
                                                                    _2875 = saturate(((_2822 + (_2854 * _2817)) + (_2856 * _2801)) * _2865);
                                                                  }
                                                                }
                                                                _2876 = saturate(_2764);
                                                                _2877 = _2765 * _2765;
                                                                do {
                                                                  _2887 = _2877;
                                                                  if (_2771 > 0.0f) {
                                                                    _2887 = saturate(((_2771 * _2771) / ((_2874 * 3.5999999046325684f) + 0.4000000059604645f)) + _2877);
                                                                  }
                                                                  _2888 = sqrt(_2887);
                                                                  do {
                                                                    _2899 = 1.0f;
                                                                    if (_2783) {
                                                                      _2899 = (_2887 / ((((_2769 * 0.25f) * ((_2888 * 3.0f) + _2769)) / (_2874 + 0.0010000000474974513f)) + _2887));
                                                                    }
                                                                    _2903 = (((_2887 * _2875) - _2875) * _2875) + 1.0f;
                                                                    _2908 = saturate(abs(_2772) + 9.999999747378752e-06f);
                                                                    _2909 = 1.0f - _2888;
                                                                    _2921 = saturate((_2746 + _1703) / (_1703 + 1.0f));
                                                                    _2924 = ((_2899 * _2876) * (_2887 / (_2903 * _2903))) * (0.5f / ((((_2909 * _2908) + _2888) * _2876) + (((_2909 * _2876) + _2888) * _2908)));
                                                                    _2925 = _2651 * _1499;
                                                                    _2926 = _2652 * _1499;
                                                                    _2927 = _2653 * _1499;
                                                                    _2934 = ((_2739 * _2925) * _2921) + _1437;
                                                                    _2935 = ((_2739 * _2926) * _2921) + _1438;
                                                                    _2936 = ((_2739 * _2927) * _2921) + _1439;
                                                                    if (_1700 > 0.0f) {
                                                                      _2944 = (exp2(log2(1.0f - saturate(_2874)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                      _2945 = select(_2736, (_2732 * _1199), _2732) * _1700;
                                                                      _8247 = _2934;
                                                                      _8248 = _2935;
                                                                      _8249 = _2936;
                                                                      _8250 = (((((_2925 * _1068) * _2945) * _2944) * _2924) + _1440);
                                                                      _8251 = (((((_2926 * _1068) * _2945) * _2944) * _2924) + _1441);
                                                                      _8252 = (((((_2927 * _1068) * _2945) * _2944) * _2924) + _1442);
                                                                    } else {
                                                                      _8247 = _2934;
                                                                      _8248 = _2935;
                                                                      _8249 = _2936;
                                                                      _8250 = _1440;
                                                                      _8251 = _1441;
                                                                      _8252 = _1442;
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
                                                          _8247 = _1437;
                                                          _8248 = _1438;
                                                          _8249 = _1439;
                                                          _8250 = _1440;
                                                          _8251 = _1441;
                                                          _8252 = _1442;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    _8247 = _1437;
                                                    _8248 = _1438;
                                                    _8249 = _1439;
                                                    _8250 = _1440;
                                                    _8251 = _1441;
                                                    _8252 = _1442;
                                                  }
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } while (false);
                                              if (_loop_break_3) break;
                                            } else {
                                              if (_1482 == 7) {
                                                _3393 = asfloat(srvLightInfoProperties.Load3(_1451)).x;
                                                _3394 = asfloat(srvLightInfoProperties.Load3(_1451)).y;
                                                _3395 = asfloat(srvLightInfoProperties.Load3(_1451)).z;
                                                _3398 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 12u)))).x;
                                                _3399 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 12u)))).y;
                                                _3400 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 12u)))).z;
                                                _3403 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 24u)))).x;
                                                _3404 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 24u)))).y;
                                                _3405 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 24u)))).z;
                                                _3408 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 36u)))).x;
                                                _3409 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 36u)))).y;
                                                _3410 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 36u)))).z;
                                                _3413 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).x;
                                                _3414 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).y;
                                                _3415 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 48u)))).z;
                                                _3418 = asint(srvLightInfoProperties.Load(((int)(_1451 + 60u))));
                                                _3421 = asint(srvLightInfoProperties.Load(((int)(_1451 + 64u))));
                                                _3424 = asint(srvLightInfoProperties.Load(((int)(_1451 + 72u))));
                                                _3427 = asint(srvLightInfoProperties.Load(((int)(_1451 + 76u))));
                                                _3430 = asint(srvLightInfoProperties.Load(((int)(_1451 + 80u))));
                                                _3433 = asint(srvLightInfoProperties.Load(((int)(_1451 + 84u))));
                                                _3436 = asint(srvLightInfoProperties.Load(((int)(_1451 + 88u))));
                                                _3439 = asint(srvLightInfoProperties.Load(((int)(_1451 + 92u))));
                                                _3442 = asint(srvLightInfoProperties.Load(((int)(_1451 + 96u))));
                                                _3445 = asint(srvLightInfoProperties.Load(((int)(_1451 + 100u))));
                                                _3448 = asint(srvLightInfoProperties.Load(((int)(_1451 + 104u))));
                                                _3451 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).x;
                                                _3452 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).y;
                                                _3453 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).z;
                                                _3454 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).w;
                                                _3457 = asint(srvLightInfoProperties.Load(((int)(_1451 + 124u))));
                                                _3460 = asint(srvLightInfoProperties.Load(((int)(_1451 + 128u))));
                                                _3463 = asint(srvLightInfoProperties.Load(((int)(_1451 + 136u))));
                                                _3466 = asint(srvLightInfoProperties.Load(((int)(_1451 + 140u))));
                                                _3468 = f16tof32(((uint)((uint)(_3418) >> 16)));
                                                _3469 = f16tof32(_3418);
                                                _3471 = f16tof32(((uint)((uint)(_3421) >> 16)));
                                                _3475 = ((float)((uint)((uint)(((uint)(_3421) >> 8) & 255)))) * 0.003921499941498041f;
                                                _3478 = ((float)((uint)((uint)(_3421 & 255)))) * 0.003921499941498041f;
                                                _3479 = f16tof32(_3424);
                                                _3481 = f16tof32(((uint)((uint)(_3427) >> 16)));
                                                _3485 = f16tof32(_3430);
                                                _3487 = f16tof32(((uint)((uint)(_3433) >> 16)));
                                                _3488 = f16tof32(_3433);
                                                _3490 = f16tof32(((uint)((uint)(_3436) >> 16)));
                                                _3493 = _3439 & 65535;
                                                _3497 = ((_1449 & 4194304) != 0);
                                                _3505 = f16tof32(((uint)((uint)(_3448) >> 16)));
                                                _3506 = f16tof32(_3448);
                                                _3508 = f16tof32(((uint)((uint)(_3457) >> 16)));
                                                _3511 = f16tof32(((uint)((uint)(_3460) >> 16)));
                                                _3512 = f16tof32(_3460);
                                                _3514 = f16tof32(((uint)((uint)(_3463) >> 16)));
                                                _3515 = _3514 + -1.0f;
                                                do {
                                                  if (_3497) {
                                                    _3517 = 0.5f / _3514;
                                                    _3518 = 0.3333333432674408f / _3514;
                                                    _3522 = (_3514 * 0.5f) + 0.5f;
                                                    _3532 = (_3517 * _3515);
                                                    _3533 = (_3518 * _3515);
                                                    _3534 = (_3517 * _3522);
                                                    _3535 = (_3518 * _3522);
                                                    _3536 = (_3514 * 2.0f);
                                                    _3537 = (_3514 * 3.0f);
                                                  } else {
                                                    _3528 = 1.0f / _3514;
                                                    _3529 = _3528 * _3515;
                                                    _3530 = _3528 * 0.5f;
                                                    _3532 = _3529;
                                                    _3533 = _3529;
                                                    _3534 = _3530;
                                                    _3535 = _3530;
                                                    _3536 = _3514;
                                                    _3537 = _3514;
                                                  }
                                                  _3541 = _3408 - _207;
                                                  _3542 = _3409 - _208;
                                                  _3543 = _3410 + _206;
                                                  _3544 = dot(float3(_3541, _3542, _3543), float3(_3541, _3542, _3543));
                                                  _3545 = rsqrt(_3544);
                                                  _3546 = _3545 * _3544;
                                                  _3547 = _3545 * _3541;
                                                  _3548 = _3545 * _3542;
                                                  _3549 = _3545 * _3543;
                                                  _3552 = max(0.0f, (_3546 - abs(_3485)));
                                                  _3553 = _3552 * f16tof32(((uint)((uint)(_3430) >> 16)));
                                                  _3554 = _3553 * _3553;
                                                  _3557 = saturate(1.0f - (_3554 * _3554));
                                                  _3564 = (_3557 * _3557) / (select((_3485 < 0.0f), (_3554 * 16.0f), (_3552 * _3552)) + 1.0f);
                                                  _3577 = saturate(1.0f - dot(float3(_184, _185, _186), float3(_3547, _3548, _3549))) * f16tof32(_3457);
                                                  _3581 = abs(_3543);
                                                  _3585 = _3541 - ((_3577 * _184) * _3581);
                                                  _3586 = _3542 - ((_3577 * _185) * _3581);
                                                  _3587 = _3543 - ((_3577 * _186) * _3581);
                                                  _3590 = mad(_3587, _3404, mad(_3586, _3399, (_3585 * _3394)));
                                                  _3593 = mad(_3587, _3405, mad(_3586, _3400, (_3585 * _3395)));
                                                  _3595 = ((_1449 & 3584) != 0);
                                                  do {
                                                    _5386 = _3564;
                                                    _5387 = 1.0f;
                                                    if (_3595 && (_3564 > 0.0f)) {
                                                      _3601 = mad(_3587, _3403, mad(_3586, _3398, (_3585 * _3393)));
                                                      _3602 = -0.0f - _3593;
                                                      _3603 = -0.0f - _3590;
                                                      do {
                                                        _4392 = 1.0f;
                                                        _4393 = 1.0f;
                                                        _4394 = 0;
                                                        [branch]
                                                        if (!((_1449 & 1024) == 0)) {
                                                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3439) >> 16))];
                                                          [branch]
                                                          if (_3497) {
                                                            _3608 = abs(_3601);
                                                            _3609 = abs(_3602);
                                                            _3610 = abs(_3603);
                                                            do {
                                                              if (_3608 > max(_3609, _3610)) {
                                                                _3614 = (_3601 > 0.0f);
                                                                _3629 = select(_3614, 0.0f, 1.0f);
                                                                _3630 = 0.0f;
                                                                _3631 = select(_3614, _3590, _3603);
                                                                _3632 = _3593;
                                                                _3633 = _3608;
                                                              } else {
                                                                if (_3609 > _3610) {
                                                                  _3620 = (_3593 < -0.0f);
                                                                  _3629 = select(_3620, 0.0f, 1.0f);
                                                                  _3630 = 1.0f;
                                                                  _3631 = _3601;
                                                                  _3632 = select(_3620, _3603, _3590);
                                                                  _3633 = _3609;
                                                                } else {
                                                                  _3624 = (_3590 < -0.0f);
                                                                  _3629 = select(_3624, 0.0f, 1.0f);
                                                                  _3630 = 2.0f;
                                                                  _3631 = select(_3624, _3601, (-0.0f - _3601));
                                                                  _3632 = _3593;
                                                                  _3633 = _3610;
                                                                }
                                                              }
                                                              _3634 = _3633 * 2.0f;
                                                              _3638 = -0.0f - _3506;
                                                              _3647 = ((min(max((_3631 / _3634), _3638), _3506) + _3629) * _3532) + _3534;
                                                              _3648 = ((min(max((_3632 / _3634), _3638), _3506) + _3630) * _3533) + _3535;
                                                              _3655 = ((_3629 + -0.5f) * _3532) + _3534;
                                                              _3656 = ((_3630 + -0.5f) * _3533) + _3535;
                                                              _3659 = saturate((_3508 + 1.0f) - (_3633 * _3490));
                                                              _3663 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _3672 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 2u);
                                                              } else {
                                                                _3672 = frac(frac(dot(float2(((_3663 * 32.665000915527344f) + _124), ((_3663 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _3672 = frac(frac(dot(float2(((_3663 * 32.665000915527344f) + _124), ((_3663 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _3673 = sin(_3672);
                                                              _3674 = cos(_3672);
                                                              _3679 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_3647, _3648), 0.0f))).x) > _3659), 1.0f, 0.0f);
                                                              _3680 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _3685 = sqrt((float((int)(_3680)) * 0.25f) + 0.125f) * _3511;
                                                              _3694 = (_global_7[min((uint)(((int)(0u + (_3680 * 2)))), 127u)]) * _3685;
                                                              _3695 = (_global_7[min((uint)(((int)(1u + (_3680 * 2)))), 127u)]) * _3685;
                                                              _3697 = -0.0f - _3673;
                                                              _3699 = dot(float2(_3694, _3695), float2(_3674, _3673)) + _3647;
                                                              _3700 = dot(float2(_3694, _3695), float2(_3697, _3674)) + _3648;
                                                              _3702 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3699, _3700));
                                                              _3706 = _3699 * _3536;
                                                              _3707 = _3700 * _3537;
                                                              _3710 = floor(_3655 * _3536);
                                                              _3711 = floor(_3656 * _3537);
                                                              _3716 = floor(((_3655 + _3532) * _3536) + 0.5f);
                                                              _3717 = floor(((_3656 + _3533) * _3537) + 0.5f);
                                                              _3720 = floor(_3706 + -0.5f);
                                                              _3721 = floor(_3707 + 0.5f);
                                                              _3723 = floor(_3706 + 0.5f);
                                                              _3725 = floor(_3707 + -0.5f);
                                                              _3726 = (_3720 < _3710);
                                                              _3727 = (_3721 < _3711);
                                                              do {
                                                                if (!(_3726 || _3727)) {
                                                                  if ((_3720 >= _3716) || (_3721 >= _3717)) {
                                                                    _3736 = _3679;
                                                                  } else {
                                                                    _3736 = _3702.x;
                                                                  }
                                                                } else {
                                                                  _3736 = _3679;
                                                                }
                                                                _3737 = (_3723 < _3710);
                                                                do {
                                                                  if (!(_3737 || _3727)) {
                                                                    if ((_3723 >= _3716) || (_3721 >= _3717)) {
                                                                      _3745 = _3679;
                                                                    } else {
                                                                      _3745 = _3702.y;
                                                                    }
                                                                  } else {
                                                                    _3745 = _3679;
                                                                  }
                                                                  _3746 = (_3725 < _3711);
                                                                  do {
                                                                    if (!(_3737 || _3746)) {
                                                                      if ((_3723 >= _3716) || (_3725 >= _3717)) {
                                                                        _3754 = _3679;
                                                                      } else {
                                                                        _3754 = _3702.z;
                                                                      }
                                                                    } else {
                                                                      _3754 = _3679;
                                                                    }
                                                                    do {
                                                                      if (!(_3726 || _3746)) {
                                                                        if ((_3720 >= _3716) || (_3725 >= _3717)) {
                                                                          _3762 = _3679;
                                                                        } else {
                                                                          _3762 = _3702.w;
                                                                        }
                                                                      } else {
                                                                        _3762 = _3679;
                                                                      }
                                                                      _3763 = _3736 - _3659;
                                                                      _3765 = select((_3763 < 0.0f), 0.0f, 1.0f);
                                                                      _3767 = _3745 - _3659;
                                                                      _3769 = select((_3767 < 0.0f), 0.0f, 1.0f);
                                                                      _3773 = _3754 - _3659;
                                                                      _3775 = select((_3773 < 0.0f), 0.0f, 1.0f);
                                                                      _3779 = _3762 - _3659;
                                                                      _3781 = select((_3779 < 0.0f), 0.0f, 1.0f);
                                                                      _3788 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _3793 = sqrt((float((int)(_3788)) * 0.25f) + 0.125f) * _3511;
                                                                      _3802 = (_global_7[min((uint)(((int)(0u + (_3788 * 2)))), 127u)]) * _3793;
                                                                      _3803 = (_global_7[min((uint)(((int)(1u + (_3788 * 2)))), 127u)]) * _3793;
                                                                      _3806 = dot(float2(_3802, _3803), float2(_3674, _3673)) + _3647;
                                                                      _3807 = dot(float2(_3802, _3803), float2(_3697, _3674)) + _3648;
                                                                      _3809 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3806, _3807));
                                                                      _3813 = _3806 * _3536;
                                                                      _3814 = _3807 * _3537;
                                                                      _3817 = floor(_3813 + -0.5f);
                                                                      _3818 = floor(_3814 + 0.5f);
                                                                      _3820 = floor(_3813 + 0.5f);
                                                                      _3822 = floor(_3814 + -0.5f);
                                                                      _3823 = (_3817 < _3710);
                                                                      _3824 = (_3818 < _3711);
                                                                      do {
                                                                        if (!(_3823 || _3824)) {
                                                                          if ((_3817 >= _3716) || (_3818 >= _3717)) {
                                                                            _3833 = _3679;
                                                                          } else {
                                                                            _3833 = _3809.x;
                                                                          }
                                                                        } else {
                                                                          _3833 = _3679;
                                                                        }
                                                                        _3834 = (_3820 < _3710);
                                                                        do {
                                                                          if (!(_3834 || _3824)) {
                                                                            if ((_3820 >= _3716) || (_3818 >= _3717)) {
                                                                              _3842 = _3679;
                                                                            } else {
                                                                              _3842 = _3809.y;
                                                                            }
                                                                          } else {
                                                                            _3842 = _3679;
                                                                          }
                                                                          _3843 = (_3822 < _3711);
                                                                          do {
                                                                            if (!(_3834 || _3843)) {
                                                                              if ((_3820 >= _3716) || (_3822 >= _3717)) {
                                                                                _3851 = _3679;
                                                                              } else {
                                                                                _3851 = _3809.z;
                                                                              }
                                                                            } else {
                                                                              _3851 = _3679;
                                                                            }
                                                                            do {
                                                                              if (!(_3823 || _3843)) {
                                                                                if ((_3817 >= _3716) || (_3822 >= _3717)) {
                                                                                  _3859 = _3679;
                                                                                } else {
                                                                                  _3859 = _3809.w;
                                                                                }
                                                                              } else {
                                                                                _3859 = _3679;
                                                                              }
                                                                              _3860 = _3833 - _3659;
                                                                              _3862 = select((_3860 < 0.0f), 0.0f, 1.0f);
                                                                              _3866 = _3842 - _3659;
                                                                              _3868 = select((_3866 < 0.0f), 0.0f, 1.0f);
                                                                              _3872 = _3851 - _3659;
                                                                              _3874 = select((_3872 < 0.0f), 0.0f, 1.0f);
                                                                              _3878 = _3859 - _3659;
                                                                              _3880 = select((_3878 < 0.0f), 0.0f, 1.0f);
                                                                              _3887 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _3892 = sqrt((float((int)(_3887)) * 0.25f) + 0.125f) * _3511;
                                                                              _3901 = (_global_7[min((uint)(((int)(0u + (_3887 * 2)))), 127u)]) * _3892;
                                                                              _3902 = (_global_7[min((uint)(((int)(1u + (_3887 * 2)))), 127u)]) * _3892;
                                                                              _3905 = dot(float2(_3901, _3902), float2(_3674, _3673)) + _3647;
                                                                              _3906 = dot(float2(_3901, _3902), float2(_3697, _3674)) + _3648;
                                                                              _3908 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3905, _3906));
                                                                              _3912 = _3905 * _3536;
                                                                              _3913 = _3906 * _3537;
                                                                              _3916 = floor(_3912 + -0.5f);
                                                                              _3917 = floor(_3913 + 0.5f);
                                                                              _3919 = floor(_3912 + 0.5f);
                                                                              _3921 = floor(_3913 + -0.5f);
                                                                              _3922 = (_3916 < _3710);
                                                                              _3923 = (_3917 < _3711);
                                                                              do {
                                                                                if (!(_3922 || _3923)) {
                                                                                  if ((_3916 >= _3716) || (_3917 >= _3717)) {
                                                                                    _3932 = _3679;
                                                                                  } else {
                                                                                    _3932 = _3908.x;
                                                                                  }
                                                                                } else {
                                                                                  _3932 = _3679;
                                                                                }
                                                                                _3933 = (_3919 < _3710);
                                                                                do {
                                                                                  if (!(_3933 || _3923)) {
                                                                                    if ((_3919 >= _3716) || (_3917 >= _3717)) {
                                                                                      _3941 = _3679;
                                                                                    } else {
                                                                                      _3941 = _3908.y;
                                                                                    }
                                                                                  } else {
                                                                                    _3941 = _3679;
                                                                                  }
                                                                                  _3942 = (_3921 < _3711);
                                                                                  do {
                                                                                    if (!(_3933 || _3942)) {
                                                                                      if ((_3919 >= _3716) || (_3921 >= _3717)) {
                                                                                        _3950 = _3679;
                                                                                      } else {
                                                                                        _3950 = _3908.z;
                                                                                      }
                                                                                    } else {
                                                                                      _3950 = _3679;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_3922 || _3942)) {
                                                                                        if ((_3916 >= _3716) || (_3921 >= _3717)) {
                                                                                          _3958 = _3679;
                                                                                        } else {
                                                                                          _3958 = _3908.w;
                                                                                        }
                                                                                      } else {
                                                                                        _3958 = _3679;
                                                                                      }
                                                                                      _3959 = _3932 - _3659;
                                                                                      _3961 = select((_3959 < 0.0f), 0.0f, 1.0f);
                                                                                      _3965 = _3941 - _3659;
                                                                                      _3967 = select((_3965 < 0.0f), 0.0f, 1.0f);
                                                                                      _3971 = _3950 - _3659;
                                                                                      _3973 = select((_3971 < 0.0f), 0.0f, 1.0f);
                                                                                      _3977 = _3958 - _3659;
                                                                                      _3979 = select((_3977 < 0.0f), 0.0f, 1.0f);
                                                                                      _3986 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _3991 = sqrt((float((int)(_3986)) * 0.25f) + 0.125f) * _3511;
                                                                                      _4000 = (_global_7[min((uint)(((int)(0u + (_3986 * 2)))), 127u)]) * _3991;
                                                                                      _4001 = (_global_7[min((uint)(((int)(1u + (_3986 * 2)))), 127u)]) * _3991;
                                                                                      _4004 = dot(float2(_4000, _4001), float2(_3674, _3673)) + _3647;
                                                                                      _4005 = dot(float2(_4000, _4001), float2(_3697, _3674)) + _3648;
                                                                                      _4007 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4004, _4005));
                                                                                      _4011 = _4004 * _3536;
                                                                                      _4012 = _4005 * _3537;
                                                                                      _4015 = floor(_4011 + -0.5f);
                                                                                      _4016 = floor(_4012 + 0.5f);
                                                                                      _4018 = floor(_4011 + 0.5f);
                                                                                      _4020 = floor(_4012 + -0.5f);
                                                                                      _4021 = (_4015 < _3710);
                                                                                      _4022 = (_4016 < _3711);
                                                                                      do {
                                                                                        if (!(_4021 || _4022)) {
                                                                                          if ((_4015 >= _3716) || (_4016 >= _3717)) {
                                                                                            _4031 = _3679;
                                                                                          } else {
                                                                                            _4031 = _4007.x;
                                                                                          }
                                                                                        } else {
                                                                                          _4031 = _3679;
                                                                                        }
                                                                                        _4032 = (_4018 < _3710);
                                                                                        do {
                                                                                          if (!(_4032 || _4022)) {
                                                                                            if ((_4018 >= _3716) || (_4016 >= _3717)) {
                                                                                              _4040 = _3679;
                                                                                            } else {
                                                                                              _4040 = _4007.y;
                                                                                            }
                                                                                          } else {
                                                                                            _4040 = _3679;
                                                                                          }
                                                                                          _4041 = (_4020 < _3711);
                                                                                          do {
                                                                                            if (!(_4032 || _4041)) {
                                                                                              if ((_4018 >= _3716) || (_4020 >= _3717)) {
                                                                                                _4049 = _3679;
                                                                                              } else {
                                                                                                _4049 = _4007.z;
                                                                                              }
                                                                                            } else {
                                                                                              _4049 = _3679;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_4021 || _4041)) {
                                                                                                if ((_4015 >= _3716) || (_4020 >= _3717)) {
                                                                                                  _4057 = _3679;
                                                                                                } else {
                                                                                                  _4057 = _4007.w;
                                                                                                }
                                                                                              } else {
                                                                                                _4057 = _3679;
                                                                                              }
                                                                                              _4058 = _4031 - _3659;
                                                                                              _4060 = select((_4058 < 0.0f), 0.0f, 1.0f);
                                                                                              _4064 = _4040 - _3659;
                                                                                              _4066 = select((_4064 < 0.0f), 0.0f, 1.0f);
                                                                                              _4070 = _4049 - _3659;
                                                                                              _4072 = select((_4070 < 0.0f), 0.0f, 1.0f);
                                                                                              _4076 = _4057 - _3659;
                                                                                              _4078 = select((_4076 < 0.0f), 0.0f, 1.0f);
                                                                                              _4079 = ((((((((((((((_3769 + _3765) + _3775) + _3781) + _3862) + _3868) + _3874) + _3880) + _3961) + _3967) + _3973) + _3979) + _4060) + _4066) + _4072) + _4078;
                                                                                              _4090 = (saturate(_4079 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _4096 = float((int)(((int)(uint)((int)(_4090 > 0.0f))) - ((int)(uint)((int)(_4090 < 0.0f)))));
                                                                                              _4098 = 1.0f - (_4096 * _4090);
                                                                                              _4100 = (_4098 * _4098) * _4098;
                                                                                              _4392 = (0.5f - ((_4096 * 0.5f) * ((1.0f - _4100) - ((_4098 - _4100) * saturate(((1.0f / _3659) * (1.0f / _4079)) * ((((((((((((((((_3769 * _3767) + (_3765 * _3763)) + (_3775 * _3773)) + (_3781 * _3779)) + (_3862 * _3860)) + (_3868 * _3866)) + (_3874 * _3872)) + (_3880 * _3878)) + (_3961 * _3959)) + (_3967 * _3965)) + (_3973 * _3971)) + (_3979 * _3977)) + (_4060 * _4058)) + (_4066 * _4064)) + (_4072 * _4070)) + (_4078 * _4076)))))));
                                                                                              _4393 = 1.0f;
                                                                                              _4394 = 1;
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
                                                            _4109 = f16tof32(_3466) / _3603;
                                                            _4112 = mad((_4109 * _3601), 0.5f, 0.5f);
                                                            _4113 = mad((_4109 * _3602), 0.5f, 0.5f);
                                                            if (_3590 > -0.0f) {
                                                              if ((saturate(_4112) == _4112) && (saturate(_4113) == _4113)) {
                                                                _4127 = (_4112 * _3532) + _3534;
                                                                _4128 = (_4113 * _3533) + _3535;
                                                                _4129 = saturate((_3508 + 1.0f) - (_3590 * _3490));
                                                                _4133 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                #if FIRSTLIGHT_ISFAST_ENABLED
                                                                if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                  _4142 = RenoDX_ISFASTShadowAngle(
                                                                      uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 3u);
                                                                } else {
                                                                  _4142 = frac(frac(dot(float2(((_4133 * 32.665000915527344f) + _124), ((_4133 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                }
                                                                #else
                                                                _4142 = frac(frac(dot(float2(((_4133 * 32.665000915527344f) + _124), ((_4133 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                #endif
                                                                _4143 = sin(_4142);
                                                                _4144 = cos(_4142);
                                                                _4145 = cbSharedPerViewData.nFrameCounter & 3;
                                                                _4150 = sqrt((float((int)(_4145)) * 0.25f) + 0.125f) * _3511;
                                                                _4159 = (_global_7[min((uint)(((int)(0u + (_4145 * 2)))), 127u)]) * _4150;
                                                                _4160 = (_global_7[min((uint)(((int)(1u + (_4145 * 2)))), 127u)]) * _4150;
                                                                _4162 = -0.0f - _4143;
                                                                _4167 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4159, _4160), float2(_4144, _4143)) + _4127), (dot(float2(_4159, _4160), float2(_4162, _4144)) + _4128)));
                                                                _4172 = _4167.x - _4129;
                                                                _4174 = select((_4172 < 0.0f), 0.0f, 1.0f);
                                                                _4176 = _4167.y - _4129;
                                                                _4178 = select((_4176 < 0.0f), 0.0f, 1.0f);
                                                                _4182 = _4167.z - _4129;
                                                                _4184 = select((_4182 < 0.0f), 0.0f, 1.0f);
                                                                _4188 = _4167.w - _4129;
                                                                _4190 = select((_4188 < 0.0f), 0.0f, 1.0f);
                                                                _4197 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                _4202 = sqrt((float((int)(_4197)) * 0.25f) + 0.125f) * _3511;
                                                                _4211 = (_global_7[min((uint)(((int)(0u + (_4197 * 2)))), 127u)]) * _4202;
                                                                _4212 = (_global_7[min((uint)(((int)(1u + (_4197 * 2)))), 127u)]) * _4202;
                                                                _4218 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4211, _4212), float2(_4144, _4143)) + _4127), (dot(float2(_4211, _4212), float2(_4162, _4144)) + _4128)));
                                                                _4223 = _4218.x - _4129;
                                                                _4225 = select((_4223 < 0.0f), 0.0f, 1.0f);
                                                                _4229 = _4218.y - _4129;
                                                                _4231 = select((_4229 < 0.0f), 0.0f, 1.0f);
                                                                _4235 = _4218.z - _4129;
                                                                _4237 = select((_4235 < 0.0f), 0.0f, 1.0f);
                                                                _4241 = _4218.w - _4129;
                                                                _4243 = select((_4241 < 0.0f), 0.0f, 1.0f);
                                                                _4250 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                _4255 = sqrt((float((int)(_4250)) * 0.25f) + 0.125f) * _3511;
                                                                _4264 = (_global_7[min((uint)(((int)(0u + (_4250 * 2)))), 127u)]) * _4255;
                                                                _4265 = (_global_7[min((uint)(((int)(1u + (_4250 * 2)))), 127u)]) * _4255;
                                                                _4271 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4264, _4265), float2(_4144, _4143)) + _4127), (dot(float2(_4264, _4265), float2(_4162, _4144)) + _4128)));
                                                                _4276 = _4271.x - _4129;
                                                                _4278 = select((_4276 < 0.0f), 0.0f, 1.0f);
                                                                _4282 = _4271.y - _4129;
                                                                _4284 = select((_4282 < 0.0f), 0.0f, 1.0f);
                                                                _4288 = _4271.z - _4129;
                                                                _4290 = select((_4288 < 0.0f), 0.0f, 1.0f);
                                                                _4294 = _4271.w - _4129;
                                                                _4296 = select((_4294 < 0.0f), 0.0f, 1.0f);
                                                                _4303 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                _4308 = sqrt((float((int)(_4303)) * 0.25f) + 0.125f) * _3511;
                                                                _4317 = (_global_7[min((uint)(((int)(0u + (_4303 * 2)))), 127u)]) * _4308;
                                                                _4318 = (_global_7[min((uint)(((int)(1u + (_4303 * 2)))), 127u)]) * _4308;
                                                                _4324 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4317, _4318), float2(_4144, _4143)) + _4127), (dot(float2(_4317, _4318), float2(_4162, _4144)) + _4128)));
                                                                _4329 = _4324.x - _4129;
                                                                _4331 = select((_4329 < 0.0f), 0.0f, 1.0f);
                                                                _4335 = _4324.y - _4129;
                                                                _4337 = select((_4335 < 0.0f), 0.0f, 1.0f);
                                                                _4341 = _4324.z - _4129;
                                                                _4343 = select((_4341 < 0.0f), 0.0f, 1.0f);
                                                                _4347 = _4324.w - _4129;
                                                                _4349 = select((_4347 < 0.0f), 0.0f, 1.0f);
                                                                _4350 = ((((((((((((((_4174 + _4178) + _4184) + _4190) + _4225) + _4231) + _4237) + _4243) + _4278) + _4284) + _4290) + _4296) + _4331) + _4337) + _4343) + _4349;
                                                                _4361 = (saturate(_4350 * 0.0625f) * 2.0f) + -1.0f;
                                                                _4367 = float((int)(((int)(uint)((int)(_4361 > 0.0f))) - ((int)(uint)((int)(_4361 < 0.0f)))));
                                                                _4369 = 1.0f - (_4367 * _4361);
                                                                _4371 = (_4369 * _4369) * _4369;
                                                                _4379 = -0.0f - _3601;
                                                                _4386 = saturate((saturate(rsqrt(dot(float3(_4379, _3593, _3590), float3(_4379, _3593, _3590))) * _3590) * _3488) + _3487);
                                                                _4388 = 1.0f - (_4386 * _4386);
                                                                _4392 = (0.5f - ((_4367 * 0.5f) * ((1.0f - _4371) - ((_4369 - _4371) * saturate(((1.0f / _4129) * (1.0f / _4350)) * ((((((((((((((((_4174 * _4172) + (_4178 * _4176)) + (_4184 * _4182)) + (_4190 * _4188)) + (_4225 * _4223)) + (_4231 * _4229)) + (_4237 * _4235)) + (_4243 * _4241)) + (_4278 * _4276)) + (_4284 * _4282)) + (_4290 * _4288)) + (_4296 * _4294)) + (_4331 * _4329)) + (_4337 * _4335)) + (_4343 * _4341)) + (_4349 * _4347)))))));
                                                                _4393 = (1.0f - (_4388 * _4388));
                                                                _4394 = 1;
                                                              } else {
                                                                _4392 = 1.0f;
                                                                _4393 = 1.0f;
                                                                _4394 = 0;
                                                              }
                                                            } else {
                                                              _4392 = 1.0f;
                                                              _4393 = 1.0f;
                                                              _4394 = 0;
                                                            }
                                                          }
                                                        }
                                                        do {
                                                          _5184 = 1.0f;
                                                          _5185 = 1.0f;
                                                          _5186 = true;
                                                          [branch]
                                                          if (!((_1449 & 512) == 0)) {
                                                            Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                                                            [branch]
                                                            if (!((_1449 & 2097152) == 0)) {
                                                              _4402 = abs(_3601);
                                                              _4403 = abs(_3602);
                                                              _4404 = abs(_3603);
                                                              do {
                                                                if (_4402 > max(_4403, _4404)) {
                                                                  _4408 = (_3601 > 0.0f);
                                                                  _4423 = select(_4408, 0.0f, 1.0f);
                                                                  _4424 = 0.0f;
                                                                  _4425 = select(_4408, _3590, _3603);
                                                                  _4426 = _3593;
                                                                  _4427 = _4402;
                                                                } else {
                                                                  if (_4403 > _4404) {
                                                                    _4414 = (_3593 < -0.0f);
                                                                    _4423 = select(_4414, 0.0f, 1.0f);
                                                                    _4424 = 1.0f;
                                                                    _4425 = _3601;
                                                                    _4426 = select(_4414, _3603, _3590);
                                                                    _4427 = _4403;
                                                                  } else {
                                                                    _4418 = (_3590 < -0.0f);
                                                                    _4423 = select(_4418, 0.0f, 1.0f);
                                                                    _4424 = 2.0f;
                                                                    _4425 = select(_4418, _3601, (-0.0f - _3601));
                                                                    _4426 = _3593;
                                                                    _4427 = _4404;
                                                                  }
                                                                }
                                                                _4428 = _4427 * 2.0f;
                                                                _4433 = -0.0f - _3505;
                                                                _4442 = ((min(max((_4425 / _4428), _4433), _3505) + _4423) * _3451) + _3453;
                                                                _4443 = ((min(max((_4426 / _4428), _4433), _3505) + _4424) * _3452) + _3454;
                                                                _4448 = ((_4423 + -0.5f) * _3451) + _3453;
                                                                _4449 = ((_4424 + -0.5f) * _3452) + _3454;
                                                                _4452 = saturate(1.0f - (_4427 * _3490));
                                                                _4456 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                #if FIRSTLIGHT_ISFAST_ENABLED
                                                                if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                  _4465 = RenoDX_ISFASTShadowAngle(
                                                                      uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 4u);
                                                                } else {
                                                                  _4465 = frac(frac(dot(float2(((_4456 * 32.665000915527344f) + _124), ((_4456 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                }
                                                                #else
                                                                _4465 = frac(frac(dot(float2(((_4456 * 32.665000915527344f) + _124), ((_4456 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                #endif
                                                                _4466 = sin(_4465);
                                                                _4467 = cos(_4465);
                                                                _4472 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4442, _4443), 0.0f))).x) > _4452), 1.0f, 0.0f);
                                                                _4473 = cbSharedPerViewData.nFrameCounter & 3;
                                                                _4478 = sqrt((float((int)(_4473)) * 0.25f) + 0.125f) * _3512;
                                                                _4487 = (_global_7[min((uint)(((int)(0u + (_4473 * 2)))), 127u)]) * _4478;
                                                                _4488 = (_global_7[min((uint)(((int)(1u + (_4473 * 2)))), 127u)]) * _4478;
                                                                _4490 = -0.0f - _4466;
                                                                _4492 = dot(float2(_4487, _4488), float2(_4467, _4466)) + _4442;
                                                                _4493 = dot(float2(_4487, _4488), float2(_4490, _4467)) + _4443;
                                                                _4495 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4492, _4493));
                                                                _4499 = _4492 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                _4500 = _4493 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                _4503 = floor(_4448 * cbSharedPerViewData.vShadowAtlasSize.x);
                                                                _4504 = floor(_4449 * cbSharedPerViewData.vShadowAtlasSize.y);
                                                                _4509 = floor(((_4448 + _3451) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                                                                _4510 = floor(((_4449 + _3452) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                                                                _4513 = floor(_4499 + -0.5f);
                                                                _4514 = floor(_4500 + 0.5f);
                                                                _4516 = floor(_4499 + 0.5f);
                                                                _4518 = floor(_4500 + -0.5f);
                                                                _4519 = (_4513 < _4503);
                                                                _4520 = (_4514 < _4504);
                                                                do {
                                                                  if (!(_4519 || _4520)) {
                                                                    if ((_4513 >= _4509) || (_4514 >= _4510)) {
                                                                      _4529 = _4472;
                                                                    } else {
                                                                      _4529 = _4495.x;
                                                                    }
                                                                  } else {
                                                                    _4529 = _4472;
                                                                  }
                                                                  _4530 = (_4516 < _4503);
                                                                  do {
                                                                    if (!(_4530 || _4520)) {
                                                                      if ((_4516 >= _4509) || (_4514 >= _4510)) {
                                                                        _4538 = _4472;
                                                                      } else {
                                                                        _4538 = _4495.y;
                                                                      }
                                                                    } else {
                                                                      _4538 = _4472;
                                                                    }
                                                                    _4539 = (_4518 < _4504);
                                                                    do {
                                                                      if (!(_4530 || _4539)) {
                                                                        if ((_4516 >= _4509) || (_4518 >= _4510)) {
                                                                          _4547 = _4472;
                                                                        } else {
                                                                          _4547 = _4495.z;
                                                                        }
                                                                      } else {
                                                                        _4547 = _4472;
                                                                      }
                                                                      do {
                                                                        if (!(_4519 || _4539)) {
                                                                          if ((_4513 >= _4509) || (_4518 >= _4510)) {
                                                                            _4555 = _4472;
                                                                          } else {
                                                                            _4555 = _4495.w;
                                                                          }
                                                                        } else {
                                                                          _4555 = _4472;
                                                                        }
                                                                        _4556 = _4529 - _4452;
                                                                        _4558 = select((_4556 < 0.0f), 0.0f, 1.0f);
                                                                        _4560 = _4538 - _4452;
                                                                        _4562 = select((_4560 < 0.0f), 0.0f, 1.0f);
                                                                        _4566 = _4547 - _4452;
                                                                        _4568 = select((_4566 < 0.0f), 0.0f, 1.0f);
                                                                        _4572 = _4555 - _4452;
                                                                        _4574 = select((_4572 < 0.0f), 0.0f, 1.0f);
                                                                        _4581 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                        _4586 = sqrt((float((int)(_4581)) * 0.25f) + 0.125f) * _3512;
                                                                        _4595 = (_global_7[min((uint)(((int)(0u + (_4581 * 2)))), 127u)]) * _4586;
                                                                        _4596 = (_global_7[min((uint)(((int)(1u + (_4581 * 2)))), 127u)]) * _4586;
                                                                        _4599 = dot(float2(_4595, _4596), float2(_4467, _4466)) + _4442;
                                                                        _4600 = dot(float2(_4595, _4596), float2(_4490, _4467)) + _4443;
                                                                        _4602 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4599, _4600));
                                                                        _4606 = _4599 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                        _4607 = _4600 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                        _4610 = floor(_4606 + -0.5f);
                                                                        _4611 = floor(_4607 + 0.5f);
                                                                        _4613 = floor(_4606 + 0.5f);
                                                                        _4615 = floor(_4607 + -0.5f);
                                                                        _4616 = (_4610 < _4503);
                                                                        _4617 = (_4611 < _4504);
                                                                        do {
                                                                          if (!(_4616 || _4617)) {
                                                                            if ((_4610 >= _4509) || (_4611 >= _4510)) {
                                                                              _4626 = _4472;
                                                                            } else {
                                                                              _4626 = _4602.x;
                                                                            }
                                                                          } else {
                                                                            _4626 = _4472;
                                                                          }
                                                                          _4627 = (_4613 < _4503);
                                                                          do {
                                                                            if (!(_4627 || _4617)) {
                                                                              if ((_4613 >= _4509) || (_4611 >= _4510)) {
                                                                                _4635 = _4472;
                                                                              } else {
                                                                                _4635 = _4602.y;
                                                                              }
                                                                            } else {
                                                                              _4635 = _4472;
                                                                            }
                                                                            _4636 = (_4615 < _4504);
                                                                            do {
                                                                              if (!(_4627 || _4636)) {
                                                                                if ((_4613 >= _4509) || (_4615 >= _4510)) {
                                                                                  _4644 = _4472;
                                                                                } else {
                                                                                  _4644 = _4602.z;
                                                                                }
                                                                              } else {
                                                                                _4644 = _4472;
                                                                              }
                                                                              do {
                                                                                if (!(_4616 || _4636)) {
                                                                                  if ((_4610 >= _4509) || (_4615 >= _4510)) {
                                                                                    _4652 = _4472;
                                                                                  } else {
                                                                                    _4652 = _4602.w;
                                                                                  }
                                                                                } else {
                                                                                  _4652 = _4472;
                                                                                }
                                                                                _4653 = _4626 - _4452;
                                                                                _4655 = select((_4653 < 0.0f), 0.0f, 1.0f);
                                                                                _4659 = _4635 - _4452;
                                                                                _4661 = select((_4659 < 0.0f), 0.0f, 1.0f);
                                                                                _4665 = _4644 - _4452;
                                                                                _4667 = select((_4665 < 0.0f), 0.0f, 1.0f);
                                                                                _4671 = _4652 - _4452;
                                                                                _4673 = select((_4671 < 0.0f), 0.0f, 1.0f);
                                                                                _4680 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                _4685 = sqrt((float((int)(_4680)) * 0.25f) + 0.125f) * _3512;
                                                                                _4694 = (_global_7[min((uint)(((int)(0u + (_4680 * 2)))), 127u)]) * _4685;
                                                                                _4695 = (_global_7[min((uint)(((int)(1u + (_4680 * 2)))), 127u)]) * _4685;
                                                                                _4698 = dot(float2(_4694, _4695), float2(_4467, _4466)) + _4442;
                                                                                _4699 = dot(float2(_4694, _4695), float2(_4490, _4467)) + _4443;
                                                                                _4701 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4698, _4699));
                                                                                _4705 = _4698 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                _4706 = _4699 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                _4709 = floor(_4705 + -0.5f);
                                                                                _4710 = floor(_4706 + 0.5f);
                                                                                _4712 = floor(_4705 + 0.5f);
                                                                                _4714 = floor(_4706 + -0.5f);
                                                                                _4715 = (_4709 < _4503);
                                                                                _4716 = (_4710 < _4504);
                                                                                do {
                                                                                  if (!(_4715 || _4716)) {
                                                                                    if ((_4709 >= _4509) || (_4710 >= _4510)) {
                                                                                      _4725 = _4472;
                                                                                    } else {
                                                                                      _4725 = _4701.x;
                                                                                    }
                                                                                  } else {
                                                                                    _4725 = _4472;
                                                                                  }
                                                                                  _4726 = (_4712 < _4503);
                                                                                  do {
                                                                                    if (!(_4726 || _4716)) {
                                                                                      if ((_4712 >= _4509) || (_4710 >= _4510)) {
                                                                                        _4734 = _4472;
                                                                                      } else {
                                                                                        _4734 = _4701.y;
                                                                                      }
                                                                                    } else {
                                                                                      _4734 = _4472;
                                                                                    }
                                                                                    _4735 = (_4714 < _4504);
                                                                                    do {
                                                                                      if (!(_4726 || _4735)) {
                                                                                        if ((_4712 >= _4509) || (_4714 >= _4510)) {
                                                                                          _4743 = _4472;
                                                                                        } else {
                                                                                          _4743 = _4701.z;
                                                                                        }
                                                                                      } else {
                                                                                        _4743 = _4472;
                                                                                      }
                                                                                      do {
                                                                                        if (!(_4715 || _4735)) {
                                                                                          if ((_4709 >= _4509) || (_4714 >= _4510)) {
                                                                                            _4751 = _4472;
                                                                                          } else {
                                                                                            _4751 = _4701.w;
                                                                                          }
                                                                                        } else {
                                                                                          _4751 = _4472;
                                                                                        }
                                                                                        _4752 = _4725 - _4452;
                                                                                        _4754 = select((_4752 < 0.0f), 0.0f, 1.0f);
                                                                                        _4758 = _4734 - _4452;
                                                                                        _4760 = select((_4758 < 0.0f), 0.0f, 1.0f);
                                                                                        _4764 = _4743 - _4452;
                                                                                        _4766 = select((_4764 < 0.0f), 0.0f, 1.0f);
                                                                                        _4770 = _4751 - _4452;
                                                                                        _4772 = select((_4770 < 0.0f), 0.0f, 1.0f);
                                                                                        _4779 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                        _4784 = sqrt((float((int)(_4779)) * 0.25f) + 0.125f) * _3512;
                                                                                        _4793 = (_global_7[min((uint)(((int)(0u + (_4779 * 2)))), 127u)]) * _4784;
                                                                                        _4794 = (_global_7[min((uint)(((int)(1u + (_4779 * 2)))), 127u)]) * _4784;
                                                                                        _4797 = dot(float2(_4793, _4794), float2(_4467, _4466)) + _4442;
                                                                                        _4798 = dot(float2(_4793, _4794), float2(_4490, _4467)) + _4443;
                                                                                        _4800 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4797, _4798));
                                                                                        _4804 = _4797 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                        _4805 = _4798 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                        _4808 = floor(_4804 + -0.5f);
                                                                                        _4809 = floor(_4805 + 0.5f);
                                                                                        _4811 = floor(_4804 + 0.5f);
                                                                                        _4813 = floor(_4805 + -0.5f);
                                                                                        _4814 = (_4808 < _4503);
                                                                                        _4815 = (_4809 < _4504);
                                                                                        do {
                                                                                          if (!(_4814 || _4815)) {
                                                                                            if ((_4808 >= _4509) || (_4809 >= _4510)) {
                                                                                              _4824 = _4472;
                                                                                            } else {
                                                                                              _4824 = _4800.x;
                                                                                            }
                                                                                          } else {
                                                                                            _4824 = _4472;
                                                                                          }
                                                                                          _4825 = (_4811 < _4503);
                                                                                          do {
                                                                                            if (!(_4825 || _4815)) {
                                                                                              if ((_4811 >= _4509) || (_4809 >= _4510)) {
                                                                                                _4833 = _4472;
                                                                                              } else {
                                                                                                _4833 = _4800.y;
                                                                                              }
                                                                                            } else {
                                                                                              _4833 = _4472;
                                                                                            }
                                                                                            _4834 = (_4813 < _4504);
                                                                                            do {
                                                                                              if (!(_4825 || _4834)) {
                                                                                                if ((_4811 >= _4509) || (_4813 >= _4510)) {
                                                                                                  _4842 = _4472;
                                                                                                } else {
                                                                                                  _4842 = _4800.z;
                                                                                                }
                                                                                              } else {
                                                                                                _4842 = _4472;
                                                                                              }
                                                                                              do {
                                                                                                if (!(_4814 || _4834)) {
                                                                                                  if ((_4808 >= _4509) || (_4813 >= _4510)) {
                                                                                                    _4850 = _4472;
                                                                                                  } else {
                                                                                                    _4850 = _4800.w;
                                                                                                  }
                                                                                                } else {
                                                                                                  _4850 = _4472;
                                                                                                }
                                                                                                _4851 = _4824 - _4452;
                                                                                                _4853 = select((_4851 < 0.0f), 0.0f, 1.0f);
                                                                                                _4857 = _4833 - _4452;
                                                                                                _4859 = select((_4857 < 0.0f), 0.0f, 1.0f);
                                                                                                _4863 = _4842 - _4452;
                                                                                                _4865 = select((_4863 < 0.0f), 0.0f, 1.0f);
                                                                                                _4869 = _4850 - _4452;
                                                                                                _4871 = select((_4869 < 0.0f), 0.0f, 1.0f);
                                                                                                _4872 = ((((((((((((((_4562 + _4558) + _4568) + _4574) + _4655) + _4661) + _4667) + _4673) + _4754) + _4760) + _4766) + _4772) + _4853) + _4859) + _4865) + _4871;
                                                                                                _4883 = (saturate(_4872 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                _4889 = float((int)(((int)(uint)((int)(_4883 > 0.0f))) - ((int)(uint)((int)(_4883 < 0.0f)))));
                                                                                                _4891 = 1.0f - (_4889 * _4883);
                                                                                                _4893 = (_4891 * _4891) * _4891;
                                                                                                _5184 = (0.5f - ((_4889 * 0.5f) * ((1.0f - _4893) - ((_4891 - _4893) * saturate(((1.0f / _4452) * (1.0f / _4872)) * ((((((((((((((((_4562 * _4560) + (_4558 * _4556)) + (_4568 * _4566)) + (_4574 * _4572)) + (_4655 * _4653)) + (_4661 * _4659)) + (_4667 * _4665)) + (_4673 * _4671)) + (_4754 * _4752)) + (_4760 * _4758)) + (_4766 * _4764)) + (_4772 * _4770)) + (_4853 * _4851)) + (_4859 * _4857)) + (_4865 * _4863)) + (_4871 * _4869)))))));
                                                                                                _5185 = 1.0f;
                                                                                                _5186 = false;
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
                                                              _4902 = f16tof32(((uint)((uint)(_3466) >> 16))) / _3603;
                                                              _4905 = mad((_4902 * _3601), 0.5f, 0.5f);
                                                              _4906 = mad((_4902 * _3602), 0.5f, 0.5f);
                                                              if (_3590 > -0.0f) {
                                                                if ((saturate(_4905) == _4905) && (saturate(_4906) == _4906)) {
                                                                  _4919 = (_4905 * _3451) + _3453;
                                                                  _4920 = (_4906 * _3452) + _3454;
                                                                  _4921 = saturate(1.0f - (_3590 * _3490));
                                                                  _4925 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _4934 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 5u);
                                                                  } else {
                                                                    _4934 = frac(frac(dot(float2(((_4925 * 32.665000915527344f) + _124), ((_4925 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _4934 = frac(frac(dot(float2(((_4925 * 32.665000915527344f) + _124), ((_4925 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _4935 = sin(_4934);
                                                                  _4936 = cos(_4934);
                                                                  _4937 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _4942 = sqrt((float((int)(_4937)) * 0.25f) + 0.125f) * _3512;
                                                                  _4951 = (_global_7[min((uint)(((int)(0u + (_4937 * 2)))), 127u)]) * _4942;
                                                                  _4952 = (_global_7[min((uint)(((int)(1u + (_4937 * 2)))), 127u)]) * _4942;
                                                                  _4954 = -0.0f - _4935;
                                                                  _4959 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_4951, _4952), float2(_4936, _4935)) + _4919), (dot(float2(_4951, _4952), float2(_4954, _4936)) + _4920)));
                                                                  _4964 = _4959.x - _4921;
                                                                  _4966 = select((_4964 < 0.0f), 0.0f, 1.0f);
                                                                  _4968 = _4959.y - _4921;
                                                                  _4970 = select((_4968 < 0.0f), 0.0f, 1.0f);
                                                                  _4974 = _4959.z - _4921;
                                                                  _4976 = select((_4974 < 0.0f), 0.0f, 1.0f);
                                                                  _4980 = _4959.w - _4921;
                                                                  _4982 = select((_4980 < 0.0f), 0.0f, 1.0f);
                                                                  _4989 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                  _4994 = sqrt((float((int)(_4989)) * 0.25f) + 0.125f) * _3512;
                                                                  _5003 = (_global_7[min((uint)(((int)(0u + (_4989 * 2)))), 127u)]) * _4994;
                                                                  _5004 = (_global_7[min((uint)(((int)(1u + (_4989 * 2)))), 127u)]) * _4994;
                                                                  _5010 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5003, _5004), float2(_4936, _4935)) + _4919), (dot(float2(_5003, _5004), float2(_4954, _4936)) + _4920)));
                                                                  _5015 = _5010.x - _4921;
                                                                  _5017 = select((_5015 < 0.0f), 0.0f, 1.0f);
                                                                  _5021 = _5010.y - _4921;
                                                                  _5023 = select((_5021 < 0.0f), 0.0f, 1.0f);
                                                                  _5027 = _5010.z - _4921;
                                                                  _5029 = select((_5027 < 0.0f), 0.0f, 1.0f);
                                                                  _5033 = _5010.w - _4921;
                                                                  _5035 = select((_5033 < 0.0f), 0.0f, 1.0f);
                                                                  _5042 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                  _5047 = sqrt((float((int)(_5042)) * 0.25f) + 0.125f) * _3512;
                                                                  _5056 = (_global_7[min((uint)(((int)(0u + (_5042 * 2)))), 127u)]) * _5047;
                                                                  _5057 = (_global_7[min((uint)(((int)(1u + (_5042 * 2)))), 127u)]) * _5047;
                                                                  _5063 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5056, _5057), float2(_4936, _4935)) + _4919), (dot(float2(_5056, _5057), float2(_4954, _4936)) + _4920)));
                                                                  _5068 = _5063.x - _4921;
                                                                  _5070 = select((_5068 < 0.0f), 0.0f, 1.0f);
                                                                  _5074 = _5063.y - _4921;
                                                                  _5076 = select((_5074 < 0.0f), 0.0f, 1.0f);
                                                                  _5080 = _5063.z - _4921;
                                                                  _5082 = select((_5080 < 0.0f), 0.0f, 1.0f);
                                                                  _5086 = _5063.w - _4921;
                                                                  _5088 = select((_5086 < 0.0f), 0.0f, 1.0f);
                                                                  _5095 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                  _5100 = sqrt((float((int)(_5095)) * 0.25f) + 0.125f) * _3512;
                                                                  _5109 = (_global_7[min((uint)(((int)(0u + (_5095 * 2)))), 127u)]) * _5100;
                                                                  _5110 = (_global_7[min((uint)(((int)(1u + (_5095 * 2)))), 127u)]) * _5100;
                                                                  _5116 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5109, _5110), float2(_4936, _4935)) + _4919), (dot(float2(_5109, _5110), float2(_4954, _4936)) + _4920)));
                                                                  _5121 = _5116.x - _4921;
                                                                  _5123 = select((_5121 < 0.0f), 0.0f, 1.0f);
                                                                  _5127 = _5116.y - _4921;
                                                                  _5129 = select((_5127 < 0.0f), 0.0f, 1.0f);
                                                                  _5133 = _5116.z - _4921;
                                                                  _5135 = select((_5133 < 0.0f), 0.0f, 1.0f);
                                                                  _5139 = _5116.w - _4921;
                                                                  _5141 = select((_5139 < 0.0f), 0.0f, 1.0f);
                                                                  _5142 = ((((((((((((((_4966 + _4970) + _4976) + _4982) + _5017) + _5023) + _5029) + _5035) + _5070) + _5076) + _5082) + _5088) + _5123) + _5129) + _5135) + _5141;
                                                                  _5153 = (saturate(_5142 * 0.0625f) * 2.0f) + -1.0f;
                                                                  _5159 = float((int)(((int)(uint)((int)(_5153 > 0.0f))) - ((int)(uint)((int)(_5153 < 0.0f)))));
                                                                  _5161 = 1.0f - (_5159 * _5153);
                                                                  _5163 = (_5161 * _5161) * _5161;
                                                                  _5171 = -0.0f - _3601;
                                                                  _5178 = saturate((saturate(rsqrt(dot(float3(_5171, _3593, _3590), float3(_5171, _3593, _3590))) * _3590) * _3488) + _3487);
                                                                  _5180 = 1.0f - (_5178 * _5178);
                                                                  _5184 = (0.5f - ((_5159 * 0.5f) * ((1.0f - _5163) - ((_5161 - _5163) * saturate(((1.0f / _4921) * (1.0f / _5142)) * ((((((((((((((((_4966 * _4964) + (_4970 * _4968)) + (_4976 * _4974)) + (_4982 * _4980)) + (_5017 * _5015)) + (_5023 * _5021)) + (_5029 * _5027)) + (_5035 * _5033)) + (_5070 * _5068)) + (_5076 * _5074)) + (_5082 * _5080)) + (_5088 * _5086)) + (_5123 * _5121)) + (_5129 * _5127)) + (_5135 * _5133)) + (_5141 * _5139)))))));
                                                                  _5185 = (1.0f - (_5180 * _5180));
                                                                  _5186 = false;
                                                                } else {
                                                                  _5184 = 1.0f;
                                                                  _5185 = 1.0f;
                                                                  _5186 = true;
                                                                }
                                                              } else {
                                                                _5184 = 1.0f;
                                                                _5185 = 1.0f;
                                                                _5186 = true;
                                                              }
                                                            }
                                                          }
                                                          do {
                                                            if (_4394 == 0) {
                                                              if (!(_5186)) {
                                                                _5201 = _4392;
                                                                _5202 = ((_5185 * (_5184 + -1.0f)) + 1.0f);
                                                                _5203 = 0.0f;
                                                              } else {
                                                                _5201 = _4392;
                                                                _5202 = _5184;
                                                                _5203 = 0.0f;
                                                              }
                                                            } else {
                                                              if (_5186) {
                                                                _5201 = ((_4393 * (_4392 + -1.0f)) + 1.0f);
                                                                _5202 = _5184;
                                                                _5203 = 1.0f;
                                                              } else {
                                                                _5201 = _4392;
                                                                _5202 = _5184;
                                                                _5203 = (_4393 * f16tof32(_3436));
                                                              }
                                                            }
                                                            _5206 = (_5203 * (_5201 - _5202)) + _5202;
                                                            do {
                                                              _5383 = _5206;
                                                              [branch]
                                                              if (!((_1449 & 2048) == 0)) {
                                                                _5208 = _207 - _3408;
                                                                _5209 = _208 - _3409;
                                                                _5210 = _209 - _3410;
                                                                _5225 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5210, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5209, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5208)));
                                                                _5228 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _5210, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _5209, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _5208)));
                                                                _5231 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _5210, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _5209, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _5208)));
                                                                _5233 = rsqrt(dot(float3(_5225, _5228, _5231), float3(_5225, _5228, _5231)));
                                                                _5234 = _5233 * _5225;
                                                                _5235 = _5233 * _5228;
                                                                _5236 = _5233 * _5231;
                                                                Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3442) >> 16))];
                                                                _5244 = (abs(_5235) + abs(_5234)) + abs(_5236);
                                                                _5245 = _5234 / _5244;
                                                                _5246 = _5235 / _5244;
                                                                _5248 = !((_5236 / _5244) >= 0.0f);
                                                                do {
                                                                  _5261 = _5245;
                                                                  _5262 = _5246;
                                                                  if (_5248) {
                                                                    _5261 = ((1.0f - abs(_5246)) * select((_5245 >= 0.0f), 1.0f, -1.0f));
                                                                    _5262 = ((1.0f - abs(_5245)) * select((_5246 >= 0.0f), 1.0f, -1.0f));
                                                                  }
                                                                  _5268 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5261 * 0.5f) + 0.5f), ((_5262 * 0.5f) + 0.5f)), 0.0f);
                                                                  if (_5268.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3442 & 65535))];
                                                                    do {
                                                                      _5287 = _5245;
                                                                      _5288 = _5246;
                                                                      if (_5248) {
                                                                        _5287 = ((1.0f - abs(_5246)) * select((_5245 >= 0.0f), 1.0f, -1.0f));
                                                                        _5288 = ((1.0f - abs(_5245)) * select((_5246 >= 0.0f), 1.0f, -1.0f));
                                                                      }
                                                                      _5293 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5287 * 0.5f) + 0.5f), ((_5288 * 0.5f) + 0.5f)), 0.0f);
                                                                      _5313 = mad(saturate(((log2(sqrt(((_5208 * _5208) + (_5209 * _5209)) + (_5210 * _5210))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                      _5314 = max(9.999999747378752e-06f, _5268.x);
                                                                      _5315 = _5293.x / _5314;
                                                                      _5316 = _5293.y / _5314;
                                                                      _5318 = _5293.w / _5314;
                                                                      _5323 = ((0.375f - _5316) * 4.999999873689376e-06f) + _5316;
                                                                      _5326 = -0.0f - _5315;
                                                                      _5327 = mad(_5326, _5323, (_5293.z / _5314));
                                                                      _5329 = 1.0f / mad(_5326, _5315, _5323);
                                                                      _5330 = _5329 * _5327;
                                                                      _5335 = _5313 - _5315;
                                                                      _5340 = (((_5313 * _5313) - _5323) - (_5330 * _5335)) / mad((-0.0f - _5327), _5330, mad((-0.0f - _5323), _5323, (((0.375f - _5318) * 4.999999873689376e-06f) + _5318)));
                                                                      _5342 = (_5329 * _5335) - (_5340 * _5330);
                                                                      _5345 = 1.0f / _5340;
                                                                      _5346 = _5342 * _5345;
                                                                      _5351 = sqrt(((_5346 * _5346) * 0.25f) - ((1.0f - dot(float2(_5342, _5340), float2(_5315, _5323))) * _5345));
                                                                      _5353 = (_5346 * -0.5f) - _5351;
                                                                      _5355 = _5351 - (_5346 * 0.5f);
                                                                      _5357 = select((_5353 < _5313), 1.0f, 0.0f);
                                                                      _5362 = (_5357 + -0.05000000074505806f) / (_5353 - _5313);
                                                                      _5368 = (((select((_5355 < _5313), 1.0f, 0.0f) - _5357) / (_5355 - _5353)) - _5362) / (_5355 - _5313);
                                                                      _5370 = _5362 - (_5368 * _5353);
                                                                      _5383 = (exp2((_5268.x * -1.4426950216293335f) * saturate((dot(float2(_5315, _5323), float2((_5370 - (_5368 * _5313)), _5368)) + 0.05000000074505806f) - (_5370 * _5313))) * _5206);
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _5383 = _5206;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              }
                                                              _5386 = (_5383 * _3564);
                                                              _5387 = _5383;
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
                                                      _5407 = _3468;
                                                      _5408 = _3469;
                                                      _5409 = _3471;
                                                      [branch]
                                                      if (!(_3493 == 0)) {
                                                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3493)))];
                                                        _5399 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3543, _3403, mad(_3542, _3398, (_3541 * _3393)))), (-0.0f - mad(_3543, _3404, mad(_3542, _3399, (_3541 * _3394)))), (-0.0f - mad(_3543, _3405, mad(_3542, _3400, (_3541 * _3395))))), 0.0f);
                                                        _5407 = (_5399.x * _3468);
                                                        _5408 = (_5399.y * _3469);
                                                        _5409 = (_5399.z * _3471);
                                                      }
                                                      [branch]
                                                      if (!(_5386 == 0.0f)) {
                                                        do {
                                                          _5427 = GetDeferredSoftShadowChannel(_1452);
                                                          if (_5427 < 0) {
                                                                _5448 = _5386;
                                                                do {
                                                                  _8247 = _1437;
                                                                  _8248 = _1438;
                                                                  _8249 = _1439;
                                                                  _8250 = _1440;
                                                                  _8251 = _1441;
                                                                  _8252 = _1442;
                                                                  [branch]
                                                                  if (!(_5448 == 0.0f)) {
                                                                    do {
                                                                      _5555 = _5407;
                                                                      _5556 = _5408;
                                                                      _5557 = _5409;
                                                                      [branch]
                                                                      if (!(((_3445 & 1) == 0) || (!_3595))) {
                                                                        _5465 = max(max(_5407, _5408), _5409);
                                                                        do {
                                                                          _5475 = _5407;
                                                                          _5476 = _5408;
                                                                          _5477 = _5409;
                                                                          if (_5465 > 0.0f) {
                                                                            _5475 = saturate(_5407 / _5465);
                                                                            _5476 = saturate(_5408 / _5465);
                                                                            _5477 = saturate(_5409 / _5465);
                                                                          }
                                                                          _5478 = (_5476 < _5477);
                                                                          _5479 = select(_5478, _5477, _5476);
                                                                          _5480 = select(_5478, _5476, _5477);
                                                                          _5481 = select(_5478, -1.0f, 0.0f);
                                                                          _5482 = (_5475 < _5479);
                                                                          _5484 = select(_5482, _5479, _5475);
                                                                          _5485 = select(_5482, _5475, _5479);
                                                                          _5489 = _5484 - select((_5485 < _5480), _5485, _5480);
                                                                          _5495 = abs(select(_5482, (-0.3333333432674408f - _5481), _5481) + ((_5485 - _5480) / ((_5489 * 6.0f) + 9.999999682655225e-21f)));
                                                                          do {
                                                                            _5508 = _5495;
                                                                            if (_5495 < 0.6666666865348816f) {
                                                                              _5508 = ((saturate(((float)((uint)((uint)(((uint)(_3445) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5495 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5495)) + _5495);
                                                                            }
                                                                            _5509 = saturate((_5489 / (_5484 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3445) >> 1) & 255)))) * 0.003921499941498041f));
                                                                            _5510 = saturate(_5484);
                                                                            do {
                                                                              _5537 = _5510;
                                                                              _5538 = _5510;
                                                                              _5539 = _5510;
                                                                              if (!(_5509 <= 0.0f)) {
                                                                                _5513 = saturate(_5508);
                                                                                _5517 = select(((_5513 * 360.0f) >= 360.0f), 0.0f, (_5513 * 6.0f));
                                                                                _5518 = int(_5517);
                                                                                _5520 = _5517 - float((int)(_5518));
                                                                                _5522 = _5510 * (1.0f - _5509);
                                                                                _5525 = (1.0f - (_5520 * _5509)) * _5510;
                                                                                _5529 = (1.0f - ((1.0f - _5520) * _5509)) * _5510;
                                                                                switch (_5518) {
                                                                                  case 0: {
                                                                                    _5537 = _5510;
                                                                                    _5538 = _5529;
                                                                                    _5539 = _5522;
                                                                                    break;
                                                                                  }
                                                                                  case 1: {
                                                                                    _5537 = _5525;
                                                                                    _5538 = _5510;
                                                                                    _5539 = _5522;
                                                                                    break;
                                                                                  }
                                                                                  case 2: {
                                                                                    _5537 = _5522;
                                                                                    _5538 = _5510;
                                                                                    _5539 = _5529;
                                                                                    break;
                                                                                  }
                                                                                  case 3: {
                                                                                    _5537 = _5522;
                                                                                    _5538 = _5525;
                                                                                    _5539 = _5510;
                                                                                    break;
                                                                                  }
                                                                                  case 4: {
                                                                                    _5537 = _5529;
                                                                                    _5538 = _5522;
                                                                                    _5539 = _5510;
                                                                                    break;
                                                                                  }
                                                                                  case 5: {
                                                                                    _5537 = _5510;
                                                                                    _5538 = _5522;
                                                                                    _5539 = _5525;
                                                                                    break;
                                                                                  }
                                                                                  default: {
                                                                                    _5537 = 0.0f;
                                                                                    _5538 = 0.0f;
                                                                                    _5539 = 0.0f;
                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }
                                                                              _5540 = _5537 * _5465;
                                                                              _5541 = _5538 * _5465;
                                                                              _5542 = _5539 * _5465;
                                                                              _5544 = saturate(_5387 * 1.0101009607315063f);
                                                                              _5555 = ((_5544 * (_5407 - _5540)) + _5540);
                                                                              _5556 = ((_5544 * (_5408 - _5541)) + _5541);
                                                                              _5557 = (lerp(_5542, _5409, _5544));
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      do {
                                                                        _5593 = _5448;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _5564 = srvLightMappingData[_1452];
                                                                          if (!(_5564 == -1)) {
                                                                            _5569 = srvLightIndexData[_5564].nLayerIndex;
                                                                            _5571 = srvLightIndexData[_5564].vAtlasOrigin.x;
                                                                            _5572 = srvLightIndexData[_5564].vAtlasOrigin.y;
                                                                            _5574 = srvLightIndexData[_5564].vScreenOrigin.x;
                                                                            _5575 = srvLightIndexData[_5564].vScreenOrigin.y;
                                                                            _5584 = ((int)(_5569 * 5)) & 31;
                                                                            _5593 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5571 + _62) - _5574)), ((int)((_5572 + _63) - _5575)), 0)))).x) & ((int)(31 << _5584)))) >> _5584)) >> 1)))) * 0.06666667014360428f) * _5448);
                                                                          } else {
                                                                            _5593 = _5448;
                                                                          }
                                                                        }
                                                                        _5597 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _5600 = select(_5597, (_5593 * _1199), _5593);
                                                                        _5602 = _3547 * _3546;
                                                                        _5603 = _3548 * _3546;
                                                                        _5604 = _3549 * _3546;
                                                                        _5605 = _3479 * _3413;
                                                                        _5606 = _3479 * _3414;
                                                                        _5607 = _3479 * _3415;
                                                                        _5608 = _5602 + _5605;
                                                                        _5609 = _5603 + _5606;
                                                                        _5610 = _5604 + _5607;
                                                                        _5611 = _5602 - _5605;
                                                                        _5612 = _5603 - _5606;
                                                                        _5613 = _5604 - _5607;
                                                                        _5614 = (_3479 > 0.0f);
                                                                        _5615 = dot(float3(_5608, _5609, _5610), float3(_5608, _5609, _5610));
                                                                        _5616 = rsqrt(_5615);
                                                                        do {
                                                                          [branch]
                                                                          if (_5614) {
                                                                            _5619 = rsqrt(dot(float3(_5611, _5612, _5613), float3(_5611, _5612, _5613)));
                                                                            _5620 = _5619 * _5616;
                                                                            _5622 = dot(float3(_5608, _5609, _5610), float3(_5611, _5612, _5613)) * _5620;
                                                                            _5641 = (_5620 / ((_5620 + 0.5f) + (_5622 * 0.5f)));
                                                                            _5642 = (((dot(float3(_184, _185, _186), float3(_5611, _5612, _5613)) * _5619) + (dot(float3(_184, _185, _186), float3(_5608, _5609, _5610)) * _5616)) * 0.5f);
                                                                            _5643 = _5622;
                                                                          } else {
                                                                            _5641 = (1.0f / (_5615 + 1.0f));
                                                                            _5642 = dot(float3(_184, _185, _186), float3((_5616 * _5608), (_5616 * _5609), (_5616 * _5610)));
                                                                            _5643 = 1.0f;
                                                                          }
                                                                          do {
                                                                            _5659 = _5642;
                                                                            if (_3481 > 0.0f) {
                                                                              _5649 = sqrt(saturate((_3481 * _3481) * _5641));
                                                                              if (_5642 < _5649) {
                                                                                _5654 = max(_5642, (-0.0f - _5649)) + _5649;
                                                                                _5659 = ((_5654 * _5654) / (_5649 * 4.0f));
                                                                              } else {
                                                                                _5659 = _5642;
                                                                              }
                                                                            }
                                                                            do {
                                                                              _5719 = _5608;
                                                                              _5720 = _5609;
                                                                              _5721 = _5610;
                                                                              if (_5614) {
                                                                                _5661 = -0.0f - _380;
                                                                                _5662 = -0.0f - _381;
                                                                                _5663 = -0.0f - _379;
                                                                                _5665 = dot(float3(_5661, _5662, _5663), float3(_184, _185, _186)) * 2.0f;
                                                                                _5669 = _5661 - (_5665 * _184);
                                                                                _5670 = _5662 - (_5665 * _185);
                                                                                _5671 = _5663 - (_5665 * _186);
                                                                                _5672 = _5611 - _5608;
                                                                                _5673 = _5612 - _5609;
                                                                                _5674 = _5613 - _5610;
                                                                                _5675 = dot(float3(_5669, _5670, _5671), float3(_5672, _5673, _5674));
                                                                                _5681 = sqrt(((_5672 * _5672) + (_5673 * _5673)) + (_5674 * _5674));
                                                                                _5690 = saturate(((dot(float3(_5669, _5670, _5671), float3(_5608, _5609, _5610)) * _5675) - dot(float3(_5608, _5609, _5610), float3(_5672, _5673, _5674))) / ((_5681 * _5681) - (_5675 * _5675)));
                                                                                _5694 = (_5690 * _5672) + _5608;
                                                                                _5695 = (_5690 * _5673) + _5609;
                                                                                _5696 = (_5690 * _5674) + _5610;
                                                                                _5697 = dot(float3(_5694, _5695, _5696), float3(_5669, _5670, _5671));
                                                                                _5701 = (_5697 * _5669) - _5694;
                                                                                _5702 = (_5697 * _5670) - _5695;
                                                                                _5703 = (_5697 * _5671) - _5696;
                                                                                _5711 = saturate(0.009999999776482582f / sqrt(((_5701 * _5701) + (_5702 * _5702)) + (_5703 * _5703)));
                                                                                _5719 = ((_5711 * _5701) + _5694);
                                                                                _5720 = ((_5711 * _5702) + _5695);
                                                                                _5721 = ((_5711 * _5703) + _5696);
                                                                              }
                                                                              _5723 = rsqrt(dot(float3(_5719, _5720, _5721), float3(_5719, _5720, _5721)));
                                                                              _5724 = _5723 * _5719;
                                                                              _5725 = _5723 * _5720;
                                                                              _5726 = _5723 * _5721;
                                                                              _5727 = _195 * _195;
                                                                              _5731 = saturate((_3481 * (1.0f - _5727)) * _5723);
                                                                              _5733 = saturate(_5723 * f16tof32(_3427));
                                                                              _5735 = rsqrt(dot(float3(_5602, _5603, _5604), float3(_5602, _5603, _5604)));
                                                                              _5739 = dot(float3(_184, _185, _186), float3(_5724, _5725, _5726));
                                                                              _5740 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                                              _5741 = dot(float3(_380, _381, _379), float3(_5724, _5725, _5726));
                                                                              _5744 = rsqrt((_5741 * 2.0f) + 2.0f);
                                                                              _5751 = (_5731 > 0.0f);
                                                                              do {
                                                                                _5842 = saturate((_5744 * _5741) + _5744);
                                                                                _5843 = saturate(_5744 * (_5740 + _5739));
                                                                                if (_5751) {
                                                                                  _5755 = sqrt(1.0f - (_5731 * _5731));
                                                                                  _5757 = (_5739 * 2.0f) * _5740;
                                                                                  _5758 = _5757 - _5741;
                                                                                  if (!(!(_5758 >= _5755))) {
                                                                                    _5842 = abs(_5740);
                                                                                    _5843 = 1.0f;
                                                                                  } else {
                                                                                    _5766 = rsqrt(1.0f - (_5758 * _5758)) * _5731;
                                                                                    _5769 = _5766 * (_5740 - (_5758 * _5739));
                                                                                    _5770 = _5740 * _5740;
                                                                                    _5775 = _5766 * (((_5770 * 2.0f) + -1.0f) - (_5758 * _5741));
                                                                                    _5784 = sqrt(saturate((((1.0f - (_5739 * _5739)) - _5770) - (_5741 * _5741)) + (_5757 * _5741)));
                                                                                    _5785 = _5784 * _5766;
                                                                                    _5788 = ((_5740 * 2.0f) * _5766) * _5784;
                                                                                    _5790 = (_5755 * _5739) + _5740;
                                                                                    _5791 = _5790 + _5769;
                                                                                    _5792 = _5755 * _5741;
                                                                                    _5794 = (_5792 + 1.0f) + _5775;
                                                                                    _5795 = _5785 * _5794;
                                                                                    _5796 = _5791 * _5794;
                                                                                    _5797 = _5788 * _5791;
                                                                                    _5802 = (((_5791 * 0.25f) * _5788) - (_5795 * 0.5f)) * _5796;
                                                                                    _5816 = (((_5797 - (_5795 * 2.0f)) * _5797) + (_5795 * _5795)) + ((((-0.5f - ((_5794 + _5792) * 0.5f)) * _5796) + ((_5794 * _5794) * _5790)) * _5791);
                                                                                    _5821 = (_5802 * 2.0f) / ((_5816 * _5816) + (_5802 * _5802));
                                                                                    _5822 = _5816 * _5821;
                                                                                    _5824 = 1.0f - (_5802 * _5821);
                                                                                    _5830 = ((_5822 * _5788) + _5792) + (_5824 * _5775);
                                                                                    _5833 = rsqrt((_5830 * 2.0f) + 2.0f);
                                                                                    _5842 = saturate((_5830 * _5833) + _5833);
                                                                                    _5843 = saturate(((_5790 + (_5822 * _5785)) + (_5824 * _5769)) * _5833);
                                                                                  }
                                                                                }
                                                                                _5844 = saturate(_5659);
                                                                                _5846 = _5727 * _5727;
                                                                                do {
                                                                                  _5856 = _5846;
                                                                                  if (_5733 > 0.0f) {
                                                                                    _5856 = saturate(((_5733 * _5733) / ((_5842 * 3.5999999046325684f) + 0.4000000059604645f)) + _5846);
                                                                                  }
                                                                                  do {
                                                                                    _5868 = _5856;
                                                                                    _5869 = 1.0f;
                                                                                    if (_5751) {
                                                                                      _5865 = (((_5731 * 0.25f) * ((sqrt(_5856) * 3.0f) + _5731)) / (_5842 + 0.0010000000474974513f)) + _5856;
                                                                                      _5868 = _5865;
                                                                                      _5869 = (_5856 / _5865);
                                                                                    }
                                                                                    do {
                                                                                      _5889 = _5869;
                                                                                      if (_5643 < 1.0f) {
                                                                                        _5876 = sqrt((1.000100016593933f - _5643) / max(9.999999974752427e-07f, (_5643 + 1.0f)));
                                                                                        _5889 = (sqrt(_5868 / ((((_5876 * 0.25f) * ((sqrt(_5868) * 3.0f) + _5876)) / (_5842 + 0.0010000000474974513f)) + _5868)) * _5869);
                                                                                      }
                                                                                      _5893 = (((_5856 * _5843) - _5843) * _5843) + 1.0f;
                                                                                      _5898 = saturate(abs(_5740) + 9.999999747378752e-06f);
                                                                                      _5899 = sqrt(_5856);
                                                                                      _5900 = 1.0f - _5899;
                                                                                      _5912 = saturate((dot(float3(_184, _185, _186), float3((_5735 * _5602), (_5735 * _5603), (_5735 * _5604))) + _3478) / (_3478 + 1.0f));
                                                                                      _5915 = ((_5889 * _5844) * (_5856 / (_5893 * _5893))) * (0.5f / ((((_5900 * _5898) + _5899) * _5844) + (((_5900 * _5844) + _5899) * _5898)));
                                                                                      _5916 = _5555 * _1499;
                                                                                      _5917 = _5556 * _1499;
                                                                                      _5918 = _5557 * _1499;
                                                                                      _5925 = ((_5600 * _5916) * _5912) + _1437;
                                                                                      _5926 = ((_5600 * _5917) * _5912) + _1438;
                                                                                      _5927 = ((_5600 * _5918) * _5912) + _1439;
                                                                                      if (_3475 > 0.0f) {
                                                                                        _5936 = (exp2(log2(1.0f - saturate(_5842)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                        _5937 = select(_5597, (_5593 * _1199), _5593) * _3475;
                                                                                        _8247 = _5925;
                                                                                        _8248 = _5926;
                                                                                        _8249 = _5927;
                                                                                        _8250 = (((((_5916 * _1068) * _5937) * _5936) * _5915) + _1440);
                                                                                        _8251 = (((((_5917 * _1068) * _5937) * _5936) * _5915) + _1441);
                                                                                        _8252 = (((((_5918 * _1068) * _5937) * _5936) * _5915) + _1442);
                                                                                      } else {
                                                                                        _8247 = _5925;
                                                                                        _8248 = _5926;
                                                                                        _8249 = _5927;
                                                                                        _8250 = _1440;
                                                                                        _8251 = _1441;
                                                                                        _8252 = _1442;
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
                                                                  }
                                                                  break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                            // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                            break;
                                                          }
                                                          _5430 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_62, _63, 0));
                                                          do {
                                                            if (_5427 == 0) {
                                                              _5444 = _5430.x;
                                                            } else {
                                                              if (_5427 == 1) {
                                                                _5444 = _5430.y;
                                                              } else {
                                                                if (_5427 == 2) {
                                                                  _5444 = _5430.z;
                                                                } else {
                                                                  _5444 = _5430.w;
                                                                }
                                                              }
                                                            }
                                                            _5448 = ((_5444 * _5444) * _3564);
                                                            [branch]
                                                            if (!(_5448 == 0.0f)) {
                                                              do {
                                                                _5555 = _5407;
                                                                _5556 = _5408;
                                                                _5557 = _5409;
                                                                [branch]
                                                                if (!(((_3445 & 1) == 0) || (!_3595))) {
                                                                  _5465 = max(max(_5407, _5408), _5409);
                                                                  do {
                                                                    _5475 = _5407;
                                                                    _5476 = _5408;
                                                                    _5477 = _5409;
                                                                    if (_5465 > 0.0f) {
                                                                      _5475 = saturate(_5407 / _5465);
                                                                      _5476 = saturate(_5408 / _5465);
                                                                      _5477 = saturate(_5409 / _5465);
                                                                    }
                                                                    _5478 = (_5476 < _5477);
                                                                    _5479 = select(_5478, _5477, _5476);
                                                                    _5480 = select(_5478, _5476, _5477);
                                                                    _5481 = select(_5478, -1.0f, 0.0f);
                                                                    _5482 = (_5475 < _5479);
                                                                    _5484 = select(_5482, _5479, _5475);
                                                                    _5485 = select(_5482, _5475, _5479);
                                                                    _5489 = _5484 - select((_5485 < _5480), _5485, _5480);
                                                                    _5495 = abs(select(_5482, (-0.3333333432674408f - _5481), _5481) + ((_5485 - _5480) / ((_5489 * 6.0f) + 9.999999682655225e-21f)));
                                                                    do {
                                                                      _5508 = _5495;
                                                                      if (_5495 < 0.6666666865348816f) {
                                                                        _5508 = ((saturate(((float)((uint)((uint)(((uint)(_3445) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5495 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5495)) + _5495);
                                                                      }
                                                                      _5509 = saturate((_5489 / (_5484 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3445) >> 1) & 255)))) * 0.003921499941498041f));
                                                                      _5510 = saturate(_5484);
                                                                      do {
                                                                        _5537 = _5510;
                                                                        _5538 = _5510;
                                                                        _5539 = _5510;
                                                                        if (!(_5509 <= 0.0f)) {
                                                                          _5513 = saturate(_5508);
                                                                          _5517 = select(((_5513 * 360.0f) >= 360.0f), 0.0f, (_5513 * 6.0f));
                                                                          _5518 = int(_5517);
                                                                          _5520 = _5517 - float((int)(_5518));
                                                                          _5522 = _5510 * (1.0f - _5509);
                                                                          _5525 = (1.0f - (_5520 * _5509)) * _5510;
                                                                          _5529 = (1.0f - ((1.0f - _5520) * _5509)) * _5510;
                                                                          switch (_5518) {
                                                                            case 0: {
                                                                              _5537 = _5510;
                                                                              _5538 = _5529;
                                                                              _5539 = _5522;
                                                                              break;
                                                                            }
                                                                            case 1: {
                                                                              _5537 = _5525;
                                                                              _5538 = _5510;
                                                                              _5539 = _5522;
                                                                              break;
                                                                            }
                                                                            case 2: {
                                                                              _5537 = _5522;
                                                                              _5538 = _5510;
                                                                              _5539 = _5529;
                                                                              break;
                                                                            }
                                                                            case 3: {
                                                                              _5537 = _5522;
                                                                              _5538 = _5525;
                                                                              _5539 = _5510;
                                                                              break;
                                                                            }
                                                                            case 4: {
                                                                              _5537 = _5529;
                                                                              _5538 = _5522;
                                                                              _5539 = _5510;
                                                                              break;
                                                                            }
                                                                            case 5: {
                                                                              _5537 = _5510;
                                                                              _5538 = _5522;
                                                                              _5539 = _5525;
                                                                              break;
                                                                            }
                                                                            default: {
                                                                              _5537 = 0.0f;
                                                                              _5538 = 0.0f;
                                                                              _5539 = 0.0f;
                                                                              break;
                                                                            }
                                                                          }
                                                                        }
                                                                        _5540 = _5537 * _5465;
                                                                        _5541 = _5538 * _5465;
                                                                        _5542 = _5539 * _5465;
                                                                        _5544 = saturate(_5387 * 1.0101009607315063f);
                                                                        _5555 = ((_5544 * (_5407 - _5540)) + _5540);
                                                                        _5556 = ((_5544 * (_5408 - _5541)) + _5541);
                                                                        _5557 = (lerp(_5542, _5409, _5544));
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                }
                                                                do {
                                                                  _5593 = _5448;
                                                                  [branch]
                                                                  if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                    _5564 = srvLightMappingData[_1452];
                                                                    if (!(_5564 == -1)) {
                                                                      _5569 = srvLightIndexData[_5564].nLayerIndex;
                                                                      _5571 = srvLightIndexData[_5564].vAtlasOrigin.x;
                                                                      _5572 = srvLightIndexData[_5564].vAtlasOrigin.y;
                                                                      _5574 = srvLightIndexData[_5564].vScreenOrigin.x;
                                                                      _5575 = srvLightIndexData[_5564].vScreenOrigin.y;
                                                                      _5584 = ((int)(_5569 * 5)) & 31;
                                                                      _5593 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5571 + _62) - _5574)), ((int)((_5572 + _63) - _5575)), 0)))).x) & ((int)(31 << _5584)))) >> _5584)) >> 1)))) * 0.06666667014360428f) * _5448);
                                                                    } else {
                                                                      _5593 = _5448;
                                                                    }
                                                                  }
                                                                  _5597 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                  _5600 = select(_5597, (_5593 * _1199), _5593);
                                                                  _5602 = _3547 * _3546;
                                                                  _5603 = _3548 * _3546;
                                                                  _5604 = _3549 * _3546;
                                                                  _5605 = _3479 * _3413;
                                                                  _5606 = _3479 * _3414;
                                                                  _5607 = _3479 * _3415;
                                                                  _5608 = _5602 + _5605;
                                                                  _5609 = _5603 + _5606;
                                                                  _5610 = _5604 + _5607;
                                                                  _5611 = _5602 - _5605;
                                                                  _5612 = _5603 - _5606;
                                                                  _5613 = _5604 - _5607;
                                                                  _5614 = (_3479 > 0.0f);
                                                                  _5615 = dot(float3(_5608, _5609, _5610), float3(_5608, _5609, _5610));
                                                                  _5616 = rsqrt(_5615);
                                                                  do {
                                                                    [branch]
                                                                    if (_5614) {
                                                                      _5619 = rsqrt(dot(float3(_5611, _5612, _5613), float3(_5611, _5612, _5613)));
                                                                      _5620 = _5619 * _5616;
                                                                      _5622 = dot(float3(_5608, _5609, _5610), float3(_5611, _5612, _5613)) * _5620;
                                                                      _5641 = (_5620 / ((_5620 + 0.5f) + (_5622 * 0.5f)));
                                                                      _5642 = (((dot(float3(_184, _185, _186), float3(_5611, _5612, _5613)) * _5619) + (dot(float3(_184, _185, _186), float3(_5608, _5609, _5610)) * _5616)) * 0.5f);
                                                                      _5643 = _5622;
                                                                    } else {
                                                                      _5641 = (1.0f / (_5615 + 1.0f));
                                                                      _5642 = dot(float3(_184, _185, _186), float3((_5616 * _5608), (_5616 * _5609), (_5616 * _5610)));
                                                                      _5643 = 1.0f;
                                                                    }
                                                                    do {
                                                                      _5659 = _5642;
                                                                      if (_3481 > 0.0f) {
                                                                        _5649 = sqrt(saturate((_3481 * _3481) * _5641));
                                                                        if (_5642 < _5649) {
                                                                          _5654 = max(_5642, (-0.0f - _5649)) + _5649;
                                                                          _5659 = ((_5654 * _5654) / (_5649 * 4.0f));
                                                                        } else {
                                                                          _5659 = _5642;
                                                                        }
                                                                      }
                                                                      do {
                                                                        _5719 = _5608;
                                                                        _5720 = _5609;
                                                                        _5721 = _5610;
                                                                        if (_5614) {
                                                                          _5661 = -0.0f - _380;
                                                                          _5662 = -0.0f - _381;
                                                                          _5663 = -0.0f - _379;
                                                                          _5665 = dot(float3(_5661, _5662, _5663), float3(_184, _185, _186)) * 2.0f;
                                                                          _5669 = _5661 - (_5665 * _184);
                                                                          _5670 = _5662 - (_5665 * _185);
                                                                          _5671 = _5663 - (_5665 * _186);
                                                                          _5672 = _5611 - _5608;
                                                                          _5673 = _5612 - _5609;
                                                                          _5674 = _5613 - _5610;
                                                                          _5675 = dot(float3(_5669, _5670, _5671), float3(_5672, _5673, _5674));
                                                                          _5681 = sqrt(((_5672 * _5672) + (_5673 * _5673)) + (_5674 * _5674));
                                                                          _5690 = saturate(((dot(float3(_5669, _5670, _5671), float3(_5608, _5609, _5610)) * _5675) - dot(float3(_5608, _5609, _5610), float3(_5672, _5673, _5674))) / ((_5681 * _5681) - (_5675 * _5675)));
                                                                          _5694 = (_5690 * _5672) + _5608;
                                                                          _5695 = (_5690 * _5673) + _5609;
                                                                          _5696 = (_5690 * _5674) + _5610;
                                                                          _5697 = dot(float3(_5694, _5695, _5696), float3(_5669, _5670, _5671));
                                                                          _5701 = (_5697 * _5669) - _5694;
                                                                          _5702 = (_5697 * _5670) - _5695;
                                                                          _5703 = (_5697 * _5671) - _5696;
                                                                          _5711 = saturate(0.009999999776482582f / sqrt(((_5701 * _5701) + (_5702 * _5702)) + (_5703 * _5703)));
                                                                          _5719 = ((_5711 * _5701) + _5694);
                                                                          _5720 = ((_5711 * _5702) + _5695);
                                                                          _5721 = ((_5711 * _5703) + _5696);
                                                                        }
                                                                        _5723 = rsqrt(dot(float3(_5719, _5720, _5721), float3(_5719, _5720, _5721)));
                                                                        _5724 = _5723 * _5719;
                                                                        _5725 = _5723 * _5720;
                                                                        _5726 = _5723 * _5721;
                                                                        _5727 = _195 * _195;
                                                                        _5731 = saturate((_3481 * (1.0f - _5727)) * _5723);
                                                                        _5733 = saturate(_5723 * f16tof32(_3427));
                                                                        _5735 = rsqrt(dot(float3(_5602, _5603, _5604), float3(_5602, _5603, _5604)));
                                                                        _5739 = dot(float3(_184, _185, _186), float3(_5724, _5725, _5726));
                                                                        _5740 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                                        _5741 = dot(float3(_380, _381, _379), float3(_5724, _5725, _5726));
                                                                        _5744 = rsqrt((_5741 * 2.0f) + 2.0f);
                                                                        _5751 = (_5731 > 0.0f);
                                                                        do {
                                                                          _5842 = saturate((_5744 * _5741) + _5744);
                                                                          _5843 = saturate(_5744 * (_5740 + _5739));
                                                                          if (_5751) {
                                                                            _5755 = sqrt(1.0f - (_5731 * _5731));
                                                                            _5757 = (_5739 * 2.0f) * _5740;
                                                                            _5758 = _5757 - _5741;
                                                                            if (!(!(_5758 >= _5755))) {
                                                                              _5842 = abs(_5740);
                                                                              _5843 = 1.0f;
                                                                            } else {
                                                                              _5766 = rsqrt(1.0f - (_5758 * _5758)) * _5731;
                                                                              _5769 = _5766 * (_5740 - (_5758 * _5739));
                                                                              _5770 = _5740 * _5740;
                                                                              _5775 = _5766 * (((_5770 * 2.0f) + -1.0f) - (_5758 * _5741));
                                                                              _5784 = sqrt(saturate((((1.0f - (_5739 * _5739)) - _5770) - (_5741 * _5741)) + (_5757 * _5741)));
                                                                              _5785 = _5784 * _5766;
                                                                              _5788 = ((_5740 * 2.0f) * _5766) * _5784;
                                                                              _5790 = (_5755 * _5739) + _5740;
                                                                              _5791 = _5790 + _5769;
                                                                              _5792 = _5755 * _5741;
                                                                              _5794 = (_5792 + 1.0f) + _5775;
                                                                              _5795 = _5785 * _5794;
                                                                              _5796 = _5791 * _5794;
                                                                              _5797 = _5788 * _5791;
                                                                              _5802 = (((_5791 * 0.25f) * _5788) - (_5795 * 0.5f)) * _5796;
                                                                              _5816 = (((_5797 - (_5795 * 2.0f)) * _5797) + (_5795 * _5795)) + ((((-0.5f - ((_5794 + _5792) * 0.5f)) * _5796) + ((_5794 * _5794) * _5790)) * _5791);
                                                                              _5821 = (_5802 * 2.0f) / ((_5816 * _5816) + (_5802 * _5802));
                                                                              _5822 = _5816 * _5821;
                                                                              _5824 = 1.0f - (_5802 * _5821);
                                                                              _5830 = ((_5822 * _5788) + _5792) + (_5824 * _5775);
                                                                              _5833 = rsqrt((_5830 * 2.0f) + 2.0f);
                                                                              _5842 = saturate((_5830 * _5833) + _5833);
                                                                              _5843 = saturate(((_5790 + (_5822 * _5785)) + (_5824 * _5769)) * _5833);
                                                                            }
                                                                          }
                                                                          _5844 = saturate(_5659);
                                                                          _5846 = _5727 * _5727;
                                                                          do {
                                                                            _5856 = _5846;
                                                                            if (_5733 > 0.0f) {
                                                                              _5856 = saturate(((_5733 * _5733) / ((_5842 * 3.5999999046325684f) + 0.4000000059604645f)) + _5846);
                                                                            }
                                                                            do {
                                                                              _5868 = _5856;
                                                                              _5869 = 1.0f;
                                                                              if (_5751) {
                                                                                _5865 = (((_5731 * 0.25f) * ((sqrt(_5856) * 3.0f) + _5731)) / (_5842 + 0.0010000000474974513f)) + _5856;
                                                                                _5868 = _5865;
                                                                                _5869 = (_5856 / _5865);
                                                                              }
                                                                              do {
                                                                                _5889 = _5869;
                                                                                if (_5643 < 1.0f) {
                                                                                  _5876 = sqrt((1.000100016593933f - _5643) / max(9.999999974752427e-07f, (_5643 + 1.0f)));
                                                                                  _5889 = (sqrt(_5868 / ((((_5876 * 0.25f) * ((sqrt(_5868) * 3.0f) + _5876)) / (_5842 + 0.0010000000474974513f)) + _5868)) * _5869);
                                                                                }
                                                                                _5893 = (((_5856 * _5843) - _5843) * _5843) + 1.0f;
                                                                                _5898 = saturate(abs(_5740) + 9.999999747378752e-06f);
                                                                                _5899 = sqrt(_5856);
                                                                                _5900 = 1.0f - _5899;
                                                                                _5912 = saturate((dot(float3(_184, _185, _186), float3((_5735 * _5602), (_5735 * _5603), (_5735 * _5604))) + _3478) / (_3478 + 1.0f));
                                                                                _5915 = ((_5889 * _5844) * (_5856 / (_5893 * _5893))) * (0.5f / ((((_5900 * _5898) + _5899) * _5844) + (((_5900 * _5844) + _5899) * _5898)));
                                                                                _5916 = _5555 * _1499;
                                                                                _5917 = _5556 * _1499;
                                                                                _5918 = _5557 * _1499;
                                                                                _5925 = ((_5600 * _5916) * _5912) + _1437;
                                                                                _5926 = ((_5600 * _5917) * _5912) + _1438;
                                                                                _5927 = ((_5600 * _5918) * _5912) + _1439;
                                                                                if (_3475 > 0.0f) {
                                                                                  _5936 = (exp2(log2(1.0f - saturate(_5842)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                  _5937 = select(_5597, (_5593 * _1199), _5593) * _3475;
                                                                                  _8247 = _5925;
                                                                                  _8248 = _5926;
                                                                                  _8249 = _5927;
                                                                                  _8250 = (((((_5916 * _1068) * _5937) * _5936) * _5915) + _1440);
                                                                                  _8251 = (((((_5917 * _1068) * _5937) * _5936) * _5915) + _1441);
                                                                                  _8252 = (((((_5918 * _1068) * _5937) * _5936) * _5915) + _1442);
                                                                                } else {
                                                                                  _8247 = _5925;
                                                                                  _8248 = _5926;
                                                                                  _8249 = _5927;
                                                                                  _8250 = _1440;
                                                                                  _8251 = _1441;
                                                                                  _8252 = _1442;
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
                                                            } else {
                                                              _8247 = _1437;
                                                              _8248 = _1438;
                                                              _8249 = _1439;
                                                              _8250 = _1440;
                                                              _8251 = _1441;
                                                              _8252 = _1442;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        _8247 = _1437;
                                                        _8248 = _1438;
                                                        _8249 = _1439;
                                                        _8250 = _1440;
                                                        _8251 = _1441;
                                                        _8252 = _1442;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } else {
                                                if (_1482 == 8) {
                                                  _5958 = asfloat(srvLightInfoProperties.Load3(_1451)).x;
                                                  _5959 = asfloat(srvLightInfoProperties.Load3(_1451)).y;
                                                  _5960 = asfloat(srvLightInfoProperties.Load3(_1451)).z;
                                                  _5963 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 12u)))).x;
                                                  _5964 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 12u)))).y;
                                                  _5965 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 12u)))).z;
                                                  _5968 = asfloat(srvLightInfoProperties.Load(((int)(_1451 + 24u))));
                                                  _5971 = asint(srvLightInfoProperties.Load(((int)(_1451 + 28u))));
                                                  _5974 = asint(srvLightInfoProperties.Load(((int)(_1451 + 32u))));
                                                  _5977 = asint(srvLightInfoProperties.Load(((int)(_1451 + 44u))));
                                                  _5986 = ((float)((uint)((uint)(((uint)(_5974) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _5989 = ((float)((uint)((uint)(_5974 & 255)))) * 0.003921499941498041f;
                                                  _5992 = f16tof32(_5977);
                                                  _5999 = min(max(dot(float3((_207 - _5958), (_208 - _5959), (_209 - _5960)), float3(_5963, _5964, _5965)), (-0.0f - _5968)), _5968);
                                                  _6004 = (_5958 - _207) + (_5999 * _5963);
                                                  _6006 = (_5959 - _208) + (_5999 * _5964);
                                                  _6008 = (_5960 + _206) + (_5999 * _5965);
                                                  _6009 = dot(float3(_6004, _6006, _6008), float3(_6004, _6006, _6008));
                                                  _6010 = rsqrt(_6009);
                                                  _6012 = _6004 * _6010;
                                                  _6013 = _6006 * _6010;
                                                  _6014 = _6008 * _6010;
                                                  _6017 = max(0.0f, ((_6010 * _6009) - abs(_5992)));
                                                  _6018 = _6017 * f16tof32(((uint)((uint)(_5977) >> 16)));
                                                  _6019 = _6018 * _6018;
                                                  _6022 = saturate(1.0f - (_6019 * _6019));
                                                  _6029 = (_6022 * _6022) / (select((_5992 < 0.0f), (_6019 * 16.0f), (_6017 * _6017)) + 1.0f);
                                                  [branch]
                                                  if (!(_6029 == 0.0f)) {
                                                    do {
                                                      _6067 = _6029;
                                                      [branch]
                                                      if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                        _6038 = srvLightMappingData[_1452];
                                                        if (!(_6038 == -1)) {
                                                          _6043 = srvLightIndexData[_6038].nLayerIndex;
                                                          _6045 = srvLightIndexData[_6038].vAtlasOrigin.x;
                                                          _6046 = srvLightIndexData[_6038].vAtlasOrigin.y;
                                                          _6048 = srvLightIndexData[_6038].vScreenOrigin.x;
                                                          _6049 = srvLightIndexData[_6038].vScreenOrigin.y;
                                                          _6058 = ((int)(_6043 * 5)) & 31;
                                                          _6067 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6045 + _62) - _6048)), ((int)((_6046 + _63) - _6049)), 0)))).x) & ((int)(31 << _6058)))) >> _6058)) >> 1)))) * 0.06666667014360428f) * _6029);
                                                        } else {
                                                          _6067 = _6029;
                                                        }
                                                      }
                                                      _6071 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                      _6073 = select(_6071, (_6067 * _1199), _6067);
                                                      _6074 = dot(float3(_184, _185, _186), float3(_6012, _6013, _6014));
                                                      _6075 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                      _6076 = dot(float3(_380, _381, _379), float3(_6012, _6013, _6014));
                                                      _6079 = rsqrt((_6076 * 2.0f) + 2.0f);
                                                      _6082 = saturate(_6079 * (_6075 + _6074));
                                                      _6083 = saturate(_6074);
                                                      _6084 = _195 * _195;
                                                      _6085 = _6084 * _6084;
                                                      _6089 = (((_6082 * _6085) - _6082) * _6082) + 1.0f;
                                                      _6094 = saturate(abs(_6075) + 9.999999747378752e-06f);
                                                      _6095 = sqrt(_6085);
                                                      _6096 = 1.0f - _6095;
                                                      _6108 = saturate((_6074 + _5989) / (_5989 + 1.0f));
                                                      _6110 = ((_6085 / (_6089 * _6089)) * _6083) * (0.5f / ((((_6096 * _6094) + _6095) * _6083) + (((_6096 * _6083) + _6095) * _6094)));
                                                      _6111 = f16tof32(((uint)((uint)(_5971) >> 16))) * _1499;
                                                      _6112 = f16tof32(_5971) * _1499;
                                                      _6113 = f16tof32(((uint)((uint)(_5974) >> 16))) * _1499;
                                                      _6120 = ((_6073 * _6111) * _6108) + _1437;
                                                      _6121 = ((_6073 * _6112) * _6108) + _1438;
                                                      _6122 = ((_6073 * _6113) * _6108) + _1439;
                                                      if (_5986 > 0.0f) {
                                                        _6134 = (exp2(log2(1.0f - saturate(saturate((_6079 * _6076) + _6079))) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                        _6137 = select(_6071, (_6067 * _1199), _6067) * _5986;
                                                        _8247 = _6120;
                                                        _8248 = _6121;
                                                        _8249 = _6122;
                                                        _8250 = (((((_6111 * _1068) * _6137) * _6134) * _6110) + _1440);
                                                        _8251 = (((((_6112 * _1068) * _6137) * _6134) * _6110) + _1441);
                                                        _8252 = (((((_6113 * _1068) * _6137) * _6134) * _6110) + _1442);
                                                      } else {
                                                        _8247 = _6120;
                                                        _8248 = _6121;
                                                        _8249 = _6122;
                                                        _8250 = _1440;
                                                        _8251 = _1441;
                                                        _8252 = _1442;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    _8247 = _1437;
                                                    _8248 = _1438;
                                                    _8249 = _1439;
                                                    _8250 = _1440;
                                                    _8251 = _1441;
                                                    _8252 = _1442;
                                                  }
                                                } else {
                                                  if (_1482 == 9) {
                                                    _6158 = asfloat(srvLightInfoProperties.Load4(_1451)).x;
                                                    _6159 = asfloat(srvLightInfoProperties.Load4(_1451)).y;
                                                    _6160 = asfloat(srvLightInfoProperties.Load4(_1451)).w;
                                                    _6163 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).x;
                                                    _6164 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).y;
                                                    _6165 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).w;
                                                    _6168 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).x;
                                                    _6169 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).y;
                                                    _6170 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).w;
                                                    _6173 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 48u)))).x;
                                                    _6174 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 48u)))).y;
                                                    _6175 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 48u)))).w;
                                                    _6178 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 64u)))).x;
                                                    _6179 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 64u)))).y;
                                                    _6180 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 64u)))).z;
                                                    _6183 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 76u)))).x;
                                                    _6184 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 76u)))).y;
                                                    _6185 = asfloat(srvLightInfoProperties.Load3(((int)(_1451 + 76u)))).z;
                                                    _6188 = asint(srvLightInfoProperties.Load(((int)(_1451 + 88u))));
                                                    _6191 = asint(srvLightInfoProperties.Load(((int)(_1451 + 92u))));
                                                    _6194 = asint(srvLightInfoProperties.Load(((int)(_1451 + 100u))));
                                                    _6197 = asint(srvLightInfoProperties.Load(((int)(_1451 + 104u))));
                                                    _6200 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).x;
                                                    _6201 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).y;
                                                    _6202 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).z;
                                                    _6203 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 108u)))).w;
                                                    _6206 = asint(srvLightInfoProperties.Load(((int)(_1451 + 124u))));
                                                    _6209 = asint(srvLightInfoProperties.Load(((int)(_1451 + 128u))));
                                                    _6212 = asint(srvLightInfoProperties.Load(((int)(_1451 + 132u))));
                                                    _6215 = asint(srvLightInfoProperties.Load(((int)(_1451 + 136u))));
                                                    _6218 = asint(srvLightInfoProperties.Load(((int)(_1451 + 140u))));
                                                    _6221 = asint(srvLightInfoProperties.Load(((int)(_1451 + 144u))));
                                                    _6224 = asint(srvLightInfoProperties.Load(((int)(_1451 + 148u))));
                                                    _6227 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 152u)))).x;
                                                    _6228 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 152u)))).y;
                                                    _6229 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 152u)))).z;
                                                    _6230 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 152u)))).w;
                                                    _6233 = asint(srvLightInfoProperties.Load(((int)(_1451 + 168u))));
                                                    _6236 = asint(srvLightInfoProperties.Load(((int)(_1451 + 172u))));
                                                    _6239 = asint(srvLightInfoProperties.Load(((int)(_1451 + 180u))));
                                                    _6241 = f16tof32(((uint)((uint)(_6188) >> 16)));
                                                    _6242 = f16tof32(_6188);
                                                    _6244 = f16tof32(((uint)((uint)(_6191) >> 16)));
                                                    _6248 = ((float)((uint)((uint)(((uint)(_6191) >> 8) & 255)))) * 0.003921499941498041f;
                                                    _6251 = ((float)((uint)((uint)(_6191 & 255)))) * 0.003921499941498041f;
                                                    _6252 = f16tof32(_6194);
                                                    _6254 = f16tof32(((uint)((uint)(_6197) >> 16)));
                                                    _6258 = f16tof32(_6206);
                                                    _6262 = _6212 & 65535;
                                                    _6278 = f16tof32(((uint)((uint)(_6236) >> 16)));
                                                    _6279 = f16tof32(_6236);
                                                    _6281 = f16tof32(((uint)((uint)(_6239) >> 16)));
                                                    _6282 = 1.0f / _6281;
                                                    _6283 = _6281 + -1.0f;
                                                    _6284 = f16tof32(_6239);
                                                    _6285 = _6178 - _207;
                                                    _6286 = _6179 - _208;
                                                    _6287 = _6180 + _206;
                                                    _6288 = dot(float3(_6285, _6286, _6287), float3(_6285, _6286, _6287));
                                                    _6289 = rsqrt(_6288);
                                                    _6290 = _6289 * _6288;
                                                    _6291 = _6289 * _6285;
                                                    _6292 = _6289 * _6286;
                                                    _6293 = _6289 * _6287;
                                                    _6296 = max(0.0f, (_6290 - abs(_6258)));
                                                    _6297 = _6296 * f16tof32(((uint)((uint)(_6206) >> 16)));
                                                    _6298 = _6297 * _6297;
                                                    _6301 = saturate(1.0f - (_6298 * _6298));
                                                    _6312 = mad(_209, _6170, mad(_208, _6165, (_6160 * _207))) + _6175;
                                                    _6316 = saturate(1.0f - dot(float3(_184, _185, _186), float3(_6291, _6292, _6293))) * f16tof32(_6233);
                                                    _6323 = ((_6312 * _184) * _6316) + _207;
                                                    _6324 = ((_6312 * _185) * _6316) + _208;
                                                    _6325 = ((_6312 * _186) * _6316) - _206;
                                                    _6337 = mad(_6325, _6170, mad(_6324, _6165, (_6323 * _6160))) + _6175;
                                                    _6338 = 1.0f / _6337;
                                                    _6339 = _6338 * (mad(_6325, _6168, mad(_6324, _6163, (_6323 * _6158))) + _6173);
                                                    _6340 = _6338 * (mad(_6325, _6169, mad(_6324, _6164, (_6323 * _6159))) + _6174);
                                                    _6343 = (_6339 * _6200) + _6201;
                                                    _6344 = (_6340 * _6200) + _6201;
                                                    _6347 = _6343 - saturate(_6343);
                                                    _6348 = _6344 - saturate(_6344);
                                                    _6355 = saturate((sqrt((_6347 * _6347) + (_6348 * _6348)) * _6202) + _6203);
                                                    _6357 = 1.0f - (_6355 * _6355);
                                                    _6363 = (_6357 * _6357) * (((float)((bool)(uint)((_6337 - f16tof32(((uint)((uint)(_6209) >> 16)))) > 0.0f))) * ((_6301 * _6301) / (select((_6258 < 0.0f), (_6298 * 16.0f), (_6296 * _6296)) + 1.0f)));
                                                    _6365 = ((_1449 & 3584) == 0);
                                                    do {
                                                      _7206 = 0.0f;
                                                      _7207 = 1.0f;
                                                      if (!((!(_6363 > 0.0f)) || _6365)) {
                                                        _6373 = 1.0f - saturate(f16tof32(_6209) * _6337);
                                                        _6374 = saturate(_6339);
                                                        _6375 = saturate(_6340);
                                                        do {
                                                          _6638 = 1.0f;
                                                          _6639 = 0.0f;
                                                          _6640 = _6373;
                                                          [branch]
                                                          if (!((_1449 & 1024) == 0)) {
                                                            _6380 = ((_6374 * _6283) + 0.5f) * _6282;
                                                            _6382 = ((_6375 * _6283) + 0.5f) * _6282;
                                                            _6383 = _6373 + f16tof32(((uint)((uint)(_6233) >> 16)));
                                                            Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6212) >> 16))];
                                                            _6386 = saturate(_6383);
                                                            _6390 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                            #if FIRSTLIGHT_ISFAST_ENABLED
                                                            if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                              _6399 = RenoDX_ISFASTShadowAngle(
                                                                  uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 6u);
                                                            } else {
                                                              _6399 = frac(frac(dot(float2(((_6390 * 32.665000915527344f) + _124), ((_6390 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            }
                                                            #else
                                                            _6399 = frac(frac(dot(float2(((_6390 * 32.665000915527344f) + _124), ((_6390 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            #endif
                                                            _6400 = sin(_6399);
                                                            _6401 = cos(_6399);
                                                            _6402 = cbSharedPerViewData.nFrameCounter & 3;
                                                            _6407 = sqrt((float((int)(_6402)) * 0.25f) + 0.125f) * _6278;
                                                            _6416 = (_global_7[min((uint)(((int)(0u + (_6402 * 2)))), 127u)]) * _6407;
                                                            _6417 = (_global_7[min((uint)(((int)(1u + (_6402 * 2)))), 127u)]) * _6407;
                                                            _6419 = -0.0f - _6400;
                                                            _6424 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6416, _6417), float2(_6401, _6400)) + _6380), (dot(float2(_6416, _6417), float2(_6419, _6401)) + _6382)));
                                                            _6429 = _6424.x - _6386;
                                                            _6431 = select((_6429 < 0.0f), 0.0f, 1.0f);
                                                            _6433 = _6424.y - _6386;
                                                            _6435 = select((_6433 < 0.0f), 0.0f, 1.0f);
                                                            _6439 = _6424.z - _6386;
                                                            _6441 = select((_6439 < 0.0f), 0.0f, 1.0f);
                                                            _6445 = _6424.w - _6386;
                                                            _6447 = select((_6445 < 0.0f), 0.0f, 1.0f);
                                                            _6454 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                            _6459 = sqrt((float((int)(_6454)) * 0.25f) + 0.125f) * _6278;
                                                            _6468 = (_global_7[min((uint)(((int)(0u + (_6454 * 2)))), 127u)]) * _6459;
                                                            _6469 = (_global_7[min((uint)(((int)(1u + (_6454 * 2)))), 127u)]) * _6459;
                                                            _6475 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6468, _6469), float2(_6401, _6400)) + _6380), (dot(float2(_6468, _6469), float2(_6419, _6401)) + _6382)));
                                                            _6480 = _6475.x - _6386;
                                                            _6482 = select((_6480 < 0.0f), 0.0f, 1.0f);
                                                            _6486 = _6475.y - _6386;
                                                            _6488 = select((_6486 < 0.0f), 0.0f, 1.0f);
                                                            _6492 = _6475.z - _6386;
                                                            _6494 = select((_6492 < 0.0f), 0.0f, 1.0f);
                                                            _6498 = _6475.w - _6386;
                                                            _6500 = select((_6498 < 0.0f), 0.0f, 1.0f);
                                                            _6507 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                            _6512 = sqrt((float((int)(_6507)) * 0.25f) + 0.125f) * _6278;
                                                            _6521 = (_global_7[min((uint)(((int)(0u + (_6507 * 2)))), 127u)]) * _6512;
                                                            _6522 = (_global_7[min((uint)(((int)(1u + (_6507 * 2)))), 127u)]) * _6512;
                                                            _6528 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6521, _6522), float2(_6401, _6400)) + _6380), (dot(float2(_6521, _6522), float2(_6419, _6401)) + _6382)));
                                                            _6533 = _6528.x - _6386;
                                                            _6535 = select((_6533 < 0.0f), 0.0f, 1.0f);
                                                            _6539 = _6528.y - _6386;
                                                            _6541 = select((_6539 < 0.0f), 0.0f, 1.0f);
                                                            _6545 = _6528.z - _6386;
                                                            _6547 = select((_6545 < 0.0f), 0.0f, 1.0f);
                                                            _6551 = _6528.w - _6386;
                                                            _6553 = select((_6551 < 0.0f), 0.0f, 1.0f);
                                                            _6560 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                            _6565 = sqrt((float((int)(_6560)) * 0.25f) + 0.125f) * _6278;
                                                            _6574 = (_global_7[min((uint)(((int)(0u + (_6560 * 2)))), 127u)]) * _6565;
                                                            _6575 = (_global_7[min((uint)(((int)(1u + (_6560 * 2)))), 127u)]) * _6565;
                                                            _6581 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6574, _6575), float2(_6401, _6400)) + _6380), (dot(float2(_6574, _6575), float2(_6419, _6401)) + _6382)));
                                                            _6586 = _6581.x - _6386;
                                                            _6588 = select((_6586 < 0.0f), 0.0f, 1.0f);
                                                            _6592 = _6581.y - _6386;
                                                            _6594 = select((_6592 < 0.0f), 0.0f, 1.0f);
                                                            _6598 = _6581.z - _6386;
                                                            _6600 = select((_6598 < 0.0f), 0.0f, 1.0f);
                                                            _6604 = _6581.w - _6386;
                                                            _6606 = select((_6604 < 0.0f), 0.0f, 1.0f);
                                                            _6607 = ((((((((((((((_6431 + _6435) + _6441) + _6447) + _6482) + _6488) + _6494) + _6500) + _6535) + _6541) + _6547) + _6553) + _6588) + _6594) + _6600) + _6606;
                                                            _6618 = (saturate(_6607 * 0.0625f) * 2.0f) + -1.0f;
                                                            _6624 = float((int)(((int)(uint)((int)(_6618 > 0.0f))) - ((int)(uint)((int)(_6618 < 0.0f)))));
                                                            _6626 = 1.0f - (_6624 * _6618);
                                                            _6628 = (_6626 * _6626) * _6626;
                                                            _6635 = 0.5f - ((_6624 * 0.5f) * ((1.0f - _6628) - ((_6626 - _6628) * saturate(((1.0f / _6386) * (1.0f / _6607)) * ((((((((((((((((_6431 * _6429) + (_6435 * _6433)) + (_6441 * _6439)) + (_6447 * _6445)) + (_6482 * _6480)) + (_6488 * _6486)) + (_6494 * _6492)) + (_6500 * _6498)) + (_6535 * _6533)) + (_6541 * _6539)) + (_6547 * _6545)) + (_6553 * _6551)) + (_6588 * _6586)) + (_6594 * _6592)) + (_6600 * _6598)) + (_6606 * _6604))))));
                                                            [branch]
                                                            if (!(_6284 < 1.0f)) {
                                                              _7108 = _6284;
                                                              _7109 = _6635;
                                                              do {
                                                                _7206 = _7108;
                                                                _7207 = _7109;
                                                                [branch]
                                                                if (!((_1449 & 2048) == 0)) {
                                                                  Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6215) >> 16))];
                                                                  _7115 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6339, _6340), 0.0f);
                                                                  if (_7115.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6215 & 65535))];
                                                                    _7122 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6339, _6340), 0.0f);
                                                                    _7136 = mad(saturate(((log2(_6290) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                    _7137 = max(9.999999747378752e-06f, _7115.x);
                                                                    _7138 = _7122.x / _7137;
                                                                    _7139 = _7122.y / _7137;
                                                                    _7141 = _7122.w / _7137;
                                                                    _7146 = ((0.375f - _7139) * 4.999999873689376e-06f) + _7139;
                                                                    _7149 = -0.0f - _7138;
                                                                    _7150 = mad(_7149, _7146, (_7122.z / _7137));
                                                                    _7152 = 1.0f / mad(_7149, _7138, _7146);
                                                                    _7153 = _7152 * _7150;
                                                                    _7158 = _7136 - _7138;
                                                                    _7163 = (((_7136 * _7136) - _7146) - (_7153 * _7158)) / mad((-0.0f - _7150), _7153, mad((-0.0f - _7146), _7146, (((0.375f - _7141) * 4.999999873689376e-06f) + _7141)));
                                                                    _7165 = (_7152 * _7158) - (_7163 * _7153);
                                                                    _7168 = 1.0f / _7163;
                                                                    _7169 = _7165 * _7168;
                                                                    _7174 = sqrt(((_7169 * _7169) * 0.25f) - ((1.0f - dot(float2(_7165, _7163), float2(_7138, _7146))) * _7168));
                                                                    _7176 = (_7169 * -0.5f) - _7174;
                                                                    _7178 = _7174 - (_7169 * 0.5f);
                                                                    _7180 = select((_7176 < _7136), 1.0f, 0.0f);
                                                                    _7185 = (_7180 + -0.05000000074505806f) / (_7176 - _7136);
                                                                    _7191 = (((select((_7178 < _7136), 1.0f, 0.0f) - _7180) / (_7178 - _7176)) - _7185) / (_7178 - _7136);
                                                                    _7193 = _7185 - (_7191 * _7176);
                                                                    _7206 = _7108;
                                                                    _7207 = (exp2((_7115.x * -1.4426950216293335f) * saturate((dot(float2(_7138, _7146), float2((_7193 - (_7191 * _7136)), _7191)) + 0.05000000074505806f) - (_7193 * _7136))) * _7109);
                                                                  } else {
                                                                    _7206 = _7108;
                                                                    _7207 = _7109;
                                                                  }
                                                                }
                                                                break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                              // Native completed depth-gather shadow bypasses the fallback path.
                                                              break;
                                                            } else {
                                                              _6638 = _6635;
                                                              _6639 = _6284;
                                                              _6640 = _6383;
                                                            }
                                                          }
                                                          _6643 = (_6374 * _6227) + _6229;
                                                          _6644 = (_6375 * _6228) + _6230;
                                                          do {
                                                            _7103 = 1.0f;
                                                            if (!((_1449 & 512) == 0)) {
                                                              Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                                              _6653 = saturate(_6640);
                                                              _6657 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _6666 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_62, _63), cbSharedPerViewData.nFrameCounter, 7u);
                                                              } else {
                                                                _6666 = frac(frac(dot(float2(((_6657 * 32.665000915527344f) + _124), ((_6657 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _6666 = frac(frac(dot(float2(((_6657 * 32.665000915527344f) + _124), ((_6657 * 11.8149995803833f) + _125)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _6667 = sin(_6666);
                                                              _6668 = cos(_6666);
                                                              _6673 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_6643, _6644), 0.0f))).x) > _6653), 1.0f, 0.0f);
                                                              _6674 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _6679 = sqrt((float((int)(_6674)) * 0.25f) + 0.125f) * _6279;
                                                              _6688 = (_global_7[min((uint)(((int)(0u + (_6674 * 2)))), 127u)]) * _6679;
                                                              _6689 = (_global_7[min((uint)(((int)(1u + (_6674 * 2)))), 127u)]) * _6679;
                                                              _6691 = -0.0f - _6667;
                                                              _6693 = dot(float2(_6688, _6689), float2(_6668, _6667)) + _6643;
                                                              _6694 = dot(float2(_6688, _6689), float2(_6691, _6668)) + _6644;
                                                              _6696 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6693, _6694));
                                                              _6700 = _6693 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                              _6701 = _6694 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                              _6704 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6229);
                                                              _6705 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6230);
                                                              _6710 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6227 + _6229)) + 0.5f);
                                                              _6711 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6228 + _6230)) + 0.5f);
                                                              _6714 = floor(_6700 + -0.5f);
                                                              _6715 = floor(_6701 + 0.5f);
                                                              _6717 = floor(_6700 + 0.5f);
                                                              _6719 = floor(_6701 + -0.5f);
                                                              _6720 = (_6714 < _6704);
                                                              _6721 = (_6715 < _6705);
                                                              do {
                                                                if (!(_6720 || _6721)) {
                                                                  if ((_6714 >= _6710) || (_6715 >= _6711)) {
                                                                    _6730 = _6673;
                                                                  } else {
                                                                    _6730 = _6696.x;
                                                                  }
                                                                } else {
                                                                  _6730 = _6673;
                                                                }
                                                                _6731 = (_6717 < _6704);
                                                                do {
                                                                  if (!(_6731 || _6721)) {
                                                                    if ((_6717 >= _6710) || (_6715 >= _6711)) {
                                                                      _6739 = _6673;
                                                                    } else {
                                                                      _6739 = _6696.y;
                                                                    }
                                                                  } else {
                                                                    _6739 = _6673;
                                                                  }
                                                                  _6740 = (_6719 < _6705);
                                                                  do {
                                                                    if (!(_6731 || _6740)) {
                                                                      if ((_6717 >= _6710) || (_6719 >= _6711)) {
                                                                        _6748 = _6673;
                                                                      } else {
                                                                        _6748 = _6696.z;
                                                                      }
                                                                    } else {
                                                                      _6748 = _6673;
                                                                    }
                                                                    do {
                                                                      if (!(_6720 || _6740)) {
                                                                        if ((_6714 >= _6710) || (_6719 >= _6711)) {
                                                                          _6756 = _6673;
                                                                        } else {
                                                                          _6756 = _6696.w;
                                                                        }
                                                                      } else {
                                                                        _6756 = _6673;
                                                                      }
                                                                      _6757 = _6730 - _6653;
                                                                      _6759 = select((_6757 < 0.0f), 0.0f, 1.0f);
                                                                      _6761 = _6739 - _6653;
                                                                      _6763 = select((_6761 < 0.0f), 0.0f, 1.0f);
                                                                      _6767 = _6748 - _6653;
                                                                      _6769 = select((_6767 < 0.0f), 0.0f, 1.0f);
                                                                      _6773 = _6756 - _6653;
                                                                      _6775 = select((_6773 < 0.0f), 0.0f, 1.0f);
                                                                      _6782 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _6787 = sqrt((float((int)(_6782)) * 0.25f) + 0.125f) * _6279;
                                                                      _6796 = (_global_7[min((uint)(((int)(0u + (_6782 * 2)))), 127u)]) * _6787;
                                                                      _6797 = (_global_7[min((uint)(((int)(1u + (_6782 * 2)))), 127u)]) * _6787;
                                                                      _6800 = dot(float2(_6796, _6797), float2(_6668, _6667)) + _6643;
                                                                      _6801 = dot(float2(_6796, _6797), float2(_6691, _6668)) + _6644;
                                                                      _6803 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6800, _6801));
                                                                      _6807 = _6800 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _6808 = _6801 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _6811 = floor(_6807 + -0.5f);
                                                                      _6812 = floor(_6808 + 0.5f);
                                                                      _6814 = floor(_6807 + 0.5f);
                                                                      _6816 = floor(_6808 + -0.5f);
                                                                      _6817 = (_6811 < _6704);
                                                                      _6818 = (_6812 < _6705);
                                                                      do {
                                                                        if (!(_6817 || _6818)) {
                                                                          if ((_6811 >= _6710) || (_6812 >= _6711)) {
                                                                            _6827 = _6673;
                                                                          } else {
                                                                            _6827 = _6803.x;
                                                                          }
                                                                        } else {
                                                                          _6827 = _6673;
                                                                        }
                                                                        _6828 = (_6814 < _6704);
                                                                        do {
                                                                          if (!(_6828 || _6818)) {
                                                                            if ((_6814 >= _6710) || (_6812 >= _6711)) {
                                                                              _6836 = _6673;
                                                                            } else {
                                                                              _6836 = _6803.y;
                                                                            }
                                                                          } else {
                                                                            _6836 = _6673;
                                                                          }
                                                                          _6837 = (_6816 < _6705);
                                                                          do {
                                                                            if (!(_6828 || _6837)) {
                                                                              if ((_6814 >= _6710) || (_6816 >= _6711)) {
                                                                                _6845 = _6673;
                                                                              } else {
                                                                                _6845 = _6803.z;
                                                                              }
                                                                            } else {
                                                                              _6845 = _6673;
                                                                            }
                                                                            do {
                                                                              if (!(_6817 || _6837)) {
                                                                                if ((_6811 >= _6710) || (_6816 >= _6711)) {
                                                                                  _6853 = _6673;
                                                                                } else {
                                                                                  _6853 = _6803.w;
                                                                                }
                                                                              } else {
                                                                                _6853 = _6673;
                                                                              }
                                                                              _6854 = _6827 - _6653;
                                                                              _6856 = select((_6854 < 0.0f), 0.0f, 1.0f);
                                                                              _6860 = _6836 - _6653;
                                                                              _6862 = select((_6860 < 0.0f), 0.0f, 1.0f);
                                                                              _6866 = _6845 - _6653;
                                                                              _6868 = select((_6866 < 0.0f), 0.0f, 1.0f);
                                                                              _6872 = _6853 - _6653;
                                                                              _6874 = select((_6872 < 0.0f), 0.0f, 1.0f);
                                                                              _6881 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _6886 = sqrt((float((int)(_6881)) * 0.25f) + 0.125f) * _6279;
                                                                              _6895 = (_global_7[min((uint)(((int)(0u + (_6881 * 2)))), 127u)]) * _6886;
                                                                              _6896 = (_global_7[min((uint)(((int)(1u + (_6881 * 2)))), 127u)]) * _6886;
                                                                              _6899 = dot(float2(_6895, _6896), float2(_6668, _6667)) + _6643;
                                                                              _6900 = dot(float2(_6895, _6896), float2(_6691, _6668)) + _6644;
                                                                              _6902 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6899, _6900));
                                                                              _6906 = _6899 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _6907 = _6900 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _6910 = floor(_6906 + -0.5f);
                                                                              _6911 = floor(_6907 + 0.5f);
                                                                              _6913 = floor(_6906 + 0.5f);
                                                                              _6915 = floor(_6907 + -0.5f);
                                                                              _6916 = (_6910 < _6704);
                                                                              _6917 = (_6911 < _6705);
                                                                              do {
                                                                                if (!(_6916 || _6917)) {
                                                                                  if ((_6910 >= _6710) || (_6911 >= _6711)) {
                                                                                    _6926 = _6673;
                                                                                  } else {
                                                                                    _6926 = _6902.x;
                                                                                  }
                                                                                } else {
                                                                                  _6926 = _6673;
                                                                                }
                                                                                _6927 = (_6913 < _6704);
                                                                                do {
                                                                                  if (!(_6927 || _6917)) {
                                                                                    if ((_6913 >= _6710) || (_6911 >= _6711)) {
                                                                                      _6935 = _6673;
                                                                                    } else {
                                                                                      _6935 = _6902.y;
                                                                                    }
                                                                                  } else {
                                                                                    _6935 = _6673;
                                                                                  }
                                                                                  _6936 = (_6915 < _6705);
                                                                                  do {
                                                                                    if (!(_6927 || _6936)) {
                                                                                      if ((_6913 >= _6710) || (_6915 >= _6711)) {
                                                                                        _6944 = _6673;
                                                                                      } else {
                                                                                        _6944 = _6902.z;
                                                                                      }
                                                                                    } else {
                                                                                      _6944 = _6673;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_6916 || _6936)) {
                                                                                        if ((_6910 >= _6710) || (_6915 >= _6711)) {
                                                                                          _6952 = _6673;
                                                                                        } else {
                                                                                          _6952 = _6902.w;
                                                                                        }
                                                                                      } else {
                                                                                        _6952 = _6673;
                                                                                      }
                                                                                      _6953 = _6926 - _6653;
                                                                                      _6955 = select((_6953 < 0.0f), 0.0f, 1.0f);
                                                                                      _6959 = _6935 - _6653;
                                                                                      _6961 = select((_6959 < 0.0f), 0.0f, 1.0f);
                                                                                      _6965 = _6944 - _6653;
                                                                                      _6967 = select((_6965 < 0.0f), 0.0f, 1.0f);
                                                                                      _6971 = _6952 - _6653;
                                                                                      _6973 = select((_6971 < 0.0f), 0.0f, 1.0f);
                                                                                      _6980 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _6985 = sqrt((float((int)(_6980)) * 0.25f) + 0.125f) * _6279;
                                                                                      _6994 = (_global_7[min((uint)(((int)(0u + (_6980 * 2)))), 127u)]) * _6985;
                                                                                      _6995 = (_global_7[min((uint)(((int)(1u + (_6980 * 2)))), 127u)]) * _6985;
                                                                                      _6998 = dot(float2(_6994, _6995), float2(_6668, _6667)) + _6643;
                                                                                      _6999 = dot(float2(_6994, _6995), float2(_6691, _6668)) + _6644;
                                                                                      _7001 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6998, _6999));
                                                                                      _7005 = _6998 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _7006 = _6999 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _7009 = floor(_7005 + -0.5f);
                                                                                      _7010 = floor(_7006 + 0.5f);
                                                                                      _7012 = floor(_7005 + 0.5f);
                                                                                      _7014 = floor(_7006 + -0.5f);
                                                                                      _7015 = (_7009 < _6704);
                                                                                      _7016 = (_7010 < _6705);
                                                                                      do {
                                                                                        if (!(_7015 || _7016)) {
                                                                                          if ((_7009 >= _6710) || (_7010 >= _6711)) {
                                                                                            _7025 = _6673;
                                                                                          } else {
                                                                                            _7025 = _7001.x;
                                                                                          }
                                                                                        } else {
                                                                                          _7025 = _6673;
                                                                                        }
                                                                                        _7026 = (_7012 < _6704);
                                                                                        do {
                                                                                          if (!(_7026 || _7016)) {
                                                                                            if ((_7012 >= _6710) || (_7010 >= _6711)) {
                                                                                              _7034 = _6673;
                                                                                            } else {
                                                                                              _7034 = _7001.y;
                                                                                            }
                                                                                          } else {
                                                                                            _7034 = _6673;
                                                                                          }
                                                                                          _7035 = (_7014 < _6705);
                                                                                          do {
                                                                                            if (!(_7026 || _7035)) {
                                                                                              if ((_7012 >= _6710) || (_7014 >= _6711)) {
                                                                                                _7043 = _6673;
                                                                                              } else {
                                                                                                _7043 = _7001.z;
                                                                                              }
                                                                                            } else {
                                                                                              _7043 = _6673;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_7015 || _7035)) {
                                                                                                if ((_7009 >= _6710) || (_7014 >= _6711)) {
                                                                                                  _7051 = _6673;
                                                                                                } else {
                                                                                                  _7051 = _7001.w;
                                                                                                }
                                                                                              } else {
                                                                                                _7051 = _6673;
                                                                                              }
                                                                                              _7052 = _7025 - _6653;
                                                                                              _7054 = select((_7052 < 0.0f), 0.0f, 1.0f);
                                                                                              _7058 = _7034 - _6653;
                                                                                              _7060 = select((_7058 < 0.0f), 0.0f, 1.0f);
                                                                                              _7064 = _7043 - _6653;
                                                                                              _7066 = select((_7064 < 0.0f), 0.0f, 1.0f);
                                                                                              _7070 = _7051 - _6653;
                                                                                              _7072 = select((_7070 < 0.0f), 0.0f, 1.0f);
                                                                                              _7073 = ((((((((((((((_6763 + _6759) + _6769) + _6775) + _6856) + _6862) + _6868) + _6874) + _6955) + _6961) + _6967) + _6973) + _7054) + _7060) + _7066) + _7072;
                                                                                              _7084 = (saturate(_7073 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _7090 = float((int)(((int)(uint)((int)(_7084 > 0.0f))) - ((int)(uint)((int)(_7084 < 0.0f)))));
                                                                                              _7092 = 1.0f - (_7090 * _7084);
                                                                                              _7094 = (_7092 * _7092) * _7092;
                                                                                              _7103 = (0.5f - ((_7090 * 0.5f) * ((1.0f - _7094) - ((_7092 - _7094) * saturate(((1.0f / _6653) * (1.0f / _7073)) * ((((((((((((((((_6763 * _6761) + (_6759 * _6757)) + (_6769 * _6767)) + (_6775 * _6773)) + (_6856 * _6854)) + (_6862 * _6860)) + (_6868 * _6866)) + (_6874 * _6872)) + (_6955 * _6953)) + (_6961 * _6959)) + (_6967 * _6965)) + (_6973 * _6971)) + (_7054 * _7052)) + (_7060 * _7058)) + (_7066 * _7064)) + (_7072 * _7070)))))));
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
                                                            _7108 = _6639;
                                                            _7109 = (lerp(_7103, _6638, _6639));
                                                            [branch]
                                                            if (!((_1449 & 2048) == 0)) {
                                                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6215) >> 16))];
                                                              _7115 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6339, _6340), 0.0f);
                                                              if (_7115.x > 0.0f) {
                                                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6215 & 65535))];
                                                                _7122 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6339, _6340), 0.0f);
                                                                _7136 = mad(saturate(((log2(_6290) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                _7137 = max(9.999999747378752e-06f, _7115.x);
                                                                _7138 = _7122.x / _7137;
                                                                _7139 = _7122.y / _7137;
                                                                _7141 = _7122.w / _7137;
                                                                _7146 = ((0.375f - _7139) * 4.999999873689376e-06f) + _7139;
                                                                _7149 = -0.0f - _7138;
                                                                _7150 = mad(_7149, _7146, (_7122.z / _7137));
                                                                _7152 = 1.0f / mad(_7149, _7138, _7146);
                                                                _7153 = _7152 * _7150;
                                                                _7158 = _7136 - _7138;
                                                                _7163 = (((_7136 * _7136) - _7146) - (_7153 * _7158)) / mad((-0.0f - _7150), _7153, mad((-0.0f - _7146), _7146, (((0.375f - _7141) * 4.999999873689376e-06f) + _7141)));
                                                                _7165 = (_7152 * _7158) - (_7163 * _7153);
                                                                _7168 = 1.0f / _7163;
                                                                _7169 = _7165 * _7168;
                                                                _7174 = sqrt(((_7169 * _7169) * 0.25f) - ((1.0f - dot(float2(_7165, _7163), float2(_7138, _7146))) * _7168));
                                                                _7176 = (_7169 * -0.5f) - _7174;
                                                                _7178 = _7174 - (_7169 * 0.5f);
                                                                _7180 = select((_7176 < _7136), 1.0f, 0.0f);
                                                                _7185 = (_7180 + -0.05000000074505806f) / (_7176 - _7136);
                                                                _7191 = (((select((_7178 < _7136), 1.0f, 0.0f) - _7180) / (_7178 - _7176)) - _7185) / (_7178 - _7136);
                                                                _7193 = _7185 - (_7191 * _7176);
                                                                _7206 = _7108;
                                                                _7207 = (exp2((_7115.x * -1.4426950216293335f) * saturate((dot(float2(_7138, _7146), float2((_7193 - (_7191 * _7136)), _7191)) + 0.05000000074505806f) - (_7193 * _7136))) * _7109);
                                                              } else {
                                                                _7206 = _7108;
                                                                _7207 = _7109;
                                                              }
                                                            } else {
                                                              _7206 = _7108;
                                                              _7207 = _7109;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      }
                                                      do {
                                                        _7228 = _6241;
                                                        _7229 = _6242;
                                                        _7230 = _6244;
                                                        [branch]
                                                        if (!(_6262 == 0)) {
                                                          Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6262)))];
                                                          _7220 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6339 * f16tof32(((uint)((uint)(_6221) >> 16)))) + f16tof32(((uint)((uint)(_6224) >> 16)))), ((_6340 * f16tof32(_6221)) + f16tof32(_6224))), 0.0f);
                                                          _7228 = (_7220.x * _6241);
                                                          _7229 = (_7220.y * _6242);
                                                          _7230 = (_7220.z * _6244);
                                                        }
                                                        _7231 = _7207 * _6363;
                                                        [branch]
                                                        if (!(_7231 == 0.0f)) {
                                                          do {
                                                            _7249 = GetDeferredSoftShadowChannel(_1452);
                                                            if (_7249 < 0) {
                                                                  _7274 = _7231;
                                                                  do {
                                                                    _8247 = _1437;
                                                                    _8248 = _1438;
                                                                    _8249 = _1439;
                                                                    _8250 = _1440;
                                                                    _8251 = _1441;
                                                                    _8252 = _1442;
                                                                    [branch]
                                                                    if (_7274 > 0.0f) {
                                                                      do {
                                                                        _7380 = _7228;
                                                                        _7381 = _7229;
                                                                        _7382 = _7230;
                                                                        if (!(((_6218 & 1) == 0) || _6365)) {
                                                                          _7290 = max(max(_7228, _7229), _7230);
                                                                          do {
                                                                            _7300 = _7228;
                                                                            _7301 = _7229;
                                                                            _7302 = _7230;
                                                                            if (_7290 > 0.0f) {
                                                                              _7300 = saturate(_7228 / _7290);
                                                                              _7301 = saturate(_7229 / _7290);
                                                                              _7302 = saturate(_7230 / _7290);
                                                                            }
                                                                            _7303 = (_7301 < _7302);
                                                                            _7304 = select(_7303, _7302, _7301);
                                                                            _7305 = select(_7303, _7301, _7302);
                                                                            _7306 = select(_7303, -1.0f, 0.0f);
                                                                            _7307 = (_7300 < _7304);
                                                                            _7309 = select(_7307, _7304, _7300);
                                                                            _7310 = select(_7307, _7300, _7304);
                                                                            _7314 = _7309 - select((_7310 < _7305), _7310, _7305);
                                                                            _7320 = abs(select(_7307, (-0.3333333432674408f - _7306), _7306) + ((_7310 - _7305) / ((_7314 * 6.0f) + 9.999999682655225e-21f)));
                                                                            do {
                                                                              _7333 = _7320;
                                                                              if (_7320 < 0.6666666865348816f) {
                                                                                _7333 = ((saturate(((float)((uint)((uint)(((uint)(_6218) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7320 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7320)) + _7320);
                                                                              }
                                                                              _7334 = saturate((_7314 / (_7309 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6218) >> 1) & 255)))) * 0.003921499941498041f));
                                                                              _7335 = saturate(_7309);
                                                                              do {
                                                                                _7362 = _7335;
                                                                                _7363 = _7335;
                                                                                _7364 = _7335;
                                                                                if (!(_7334 <= 0.0f)) {
                                                                                  _7338 = saturate(_7333);
                                                                                  _7342 = select(((_7338 * 360.0f) >= 360.0f), 0.0f, (_7338 * 6.0f));
                                                                                  _7343 = int(_7342);
                                                                                  _7345 = _7342 - float((int)(_7343));
                                                                                  _7347 = _7335 * (1.0f - _7334);
                                                                                  _7350 = (1.0f - (_7345 * _7334)) * _7335;
                                                                                  _7354 = (1.0f - ((1.0f - _7345) * _7334)) * _7335;
                                                                                  switch (_7343) {
                                                                                    case 0: {
                                                                                      _7362 = _7335;
                                                                                      _7363 = _7354;
                                                                                      _7364 = _7347;
                                                                                      break;
                                                                                    }
                                                                                    case 1: {
                                                                                      _7362 = _7350;
                                                                                      _7363 = _7335;
                                                                                      _7364 = _7347;
                                                                                      break;
                                                                                    }
                                                                                    case 2: {
                                                                                      _7362 = _7347;
                                                                                      _7363 = _7335;
                                                                                      _7364 = _7354;
                                                                                      break;
                                                                                    }
                                                                                    case 3: {
                                                                                      _7362 = _7347;
                                                                                      _7363 = _7350;
                                                                                      _7364 = _7335;
                                                                                      break;
                                                                                    }
                                                                                    case 4: {
                                                                                      _7362 = _7354;
                                                                                      _7363 = _7347;
                                                                                      _7364 = _7335;
                                                                                      break;
                                                                                    }
                                                                                    case 5: {
                                                                                      _7362 = _7335;
                                                                                      _7363 = _7347;
                                                                                      _7364 = _7350;
                                                                                      break;
                                                                                    }
                                                                                    default: {
                                                                                      _7362 = 0.0f;
                                                                                      _7363 = 0.0f;
                                                                                      _7364 = 0.0f;
                                                                                      break;
                                                                                    }
                                                                                  }
                                                                                }
                                                                                _7365 = _7362 * _7290;
                                                                                _7366 = _7363 * _7290;
                                                                                _7367 = _7364 * _7290;
                                                                                _7369 = saturate(_7207 * 1.0101009607315063f);
                                                                                _7380 = ((_7369 * (_7228 - _7365)) + _7365);
                                                                                _7381 = ((_7369 * (_7229 - _7366)) + _7366);
                                                                                _7382 = (lerp(_7367, _7230, _7369));
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        }
                                                                        do {
                                                                          _7418 = _7274;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _7389 = srvLightMappingData[_1452];
                                                                            if (!(_7389 == -1)) {
                                                                              _7394 = srvLightIndexData[_7389].nLayerIndex;
                                                                              _7396 = srvLightIndexData[_7389].vAtlasOrigin.x;
                                                                              _7397 = srvLightIndexData[_7389].vAtlasOrigin.y;
                                                                              _7399 = srvLightIndexData[_7389].vScreenOrigin.x;
                                                                              _7400 = srvLightIndexData[_7389].vScreenOrigin.y;
                                                                              _7409 = ((int)(_7394 * 5)) & 31;
                                                                              _7418 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7396 + _62) - _7399)), ((int)((_7397 + _63) - _7400)), 0)))).x) & ((int)(31 << _7409)))) >> _7409)) >> 1)))) * 0.06666667014360428f) * _7274);
                                                                            } else {
                                                                              _7418 = _7274;
                                                                            }
                                                                          }
                                                                          _7422 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _7425 = select(_7422, (_7418 * _1199), _7418);
                                                                          _7427 = _6291 * _6290;
                                                                          _7428 = _6292 * _6290;
                                                                          _7429 = _6293 * _6290;
                                                                          _7430 = _6252 * _6183;
                                                                          _7431 = _6252 * _6184;
                                                                          _7432 = _6252 * _6185;
                                                                          _7433 = _7427 + _7430;
                                                                          _7434 = _7428 + _7431;
                                                                          _7435 = _7429 + _7432;
                                                                          _7436 = _7427 - _7430;
                                                                          _7437 = _7428 - _7431;
                                                                          _7438 = _7429 - _7432;
                                                                          _7439 = (_6252 > 0.0f);
                                                                          _7440 = dot(float3(_7433, _7434, _7435), float3(_7433, _7434, _7435));
                                                                          _7441 = rsqrt(_7440);
                                                                          do {
                                                                            [branch]
                                                                            if (_7439) {
                                                                              _7444 = rsqrt(dot(float3(_7436, _7437, _7438), float3(_7436, _7437, _7438)));
                                                                              _7445 = _7444 * _7441;
                                                                              _7447 = dot(float3(_7433, _7434, _7435), float3(_7436, _7437, _7438)) * _7445;
                                                                              _7466 = (_7445 / ((_7445 + 0.5f) + (_7447 * 0.5f)));
                                                                              _7467 = (((dot(float3(_184, _185, _186), float3(_7436, _7437, _7438)) * _7444) + (dot(float3(_184, _185, _186), float3(_7433, _7434, _7435)) * _7441)) * 0.5f);
                                                                              _7468 = _7447;
                                                                            } else {
                                                                              _7466 = (1.0f / (_7440 + 1.0f));
                                                                              _7467 = dot(float3(_184, _185, _186), float3((_7441 * _7433), (_7441 * _7434), (_7441 * _7435)));
                                                                              _7468 = 1.0f;
                                                                            }
                                                                            do {
                                                                              _7484 = _7467;
                                                                              if (_6254 > 0.0f) {
                                                                                _7474 = sqrt(saturate((_6254 * _6254) * _7466));
                                                                                if (_7467 < _7474) {
                                                                                  _7479 = max(_7467, (-0.0f - _7474)) + _7474;
                                                                                  _7484 = ((_7479 * _7479) / (_7474 * 4.0f));
                                                                                } else {
                                                                                  _7484 = _7467;
                                                                                }
                                                                              }
                                                                              do {
                                                                                _7544 = _7433;
                                                                                _7545 = _7434;
                                                                                _7546 = _7435;
                                                                                if (_7439) {
                                                                                  _7486 = -0.0f - _380;
                                                                                  _7487 = -0.0f - _381;
                                                                                  _7488 = -0.0f - _379;
                                                                                  _7490 = dot(float3(_7486, _7487, _7488), float3(_184, _185, _186)) * 2.0f;
                                                                                  _7494 = _7486 - (_7490 * _184);
                                                                                  _7495 = _7487 - (_7490 * _185);
                                                                                  _7496 = _7488 - (_7490 * _186);
                                                                                  _7497 = _7436 - _7433;
                                                                                  _7498 = _7437 - _7434;
                                                                                  _7499 = _7438 - _7435;
                                                                                  _7500 = dot(float3(_7494, _7495, _7496), float3(_7497, _7498, _7499));
                                                                                  _7506 = sqrt(((_7497 * _7497) + (_7498 * _7498)) + (_7499 * _7499));
                                                                                  _7515 = saturate(((dot(float3(_7494, _7495, _7496), float3(_7433, _7434, _7435)) * _7500) - dot(float3(_7433, _7434, _7435), float3(_7497, _7498, _7499))) / ((_7506 * _7506) - (_7500 * _7500)));
                                                                                  _7519 = (_7515 * _7497) + _7433;
                                                                                  _7520 = (_7515 * _7498) + _7434;
                                                                                  _7521 = (_7515 * _7499) + _7435;
                                                                                  _7522 = dot(float3(_7519, _7520, _7521), float3(_7494, _7495, _7496));
                                                                                  _7526 = (_7522 * _7494) - _7519;
                                                                                  _7527 = (_7522 * _7495) - _7520;
                                                                                  _7528 = (_7522 * _7496) - _7521;
                                                                                  _7536 = saturate(0.009999999776482582f / sqrt(((_7526 * _7526) + (_7527 * _7527)) + (_7528 * _7528)));
                                                                                  _7544 = ((_7536 * _7526) + _7519);
                                                                                  _7545 = ((_7536 * _7527) + _7520);
                                                                                  _7546 = ((_7536 * _7528) + _7521);
                                                                                }
                                                                                _7548 = rsqrt(dot(float3(_7544, _7545, _7546), float3(_7544, _7545, _7546)));
                                                                                _7549 = _7548 * _7544;
                                                                                _7550 = _7548 * _7545;
                                                                                _7551 = _7548 * _7546;
                                                                                _7552 = _195 * _195;
                                                                                _7556 = saturate((_6254 * (1.0f - _7552)) * _7548);
                                                                                _7558 = saturate(_7548 * f16tof32(_6197));
                                                                                _7560 = rsqrt(dot(float3(_7427, _7428, _7429), float3(_7427, _7428, _7429)));
                                                                                _7564 = dot(float3(_184, _185, _186), float3(_7549, _7550, _7551));
                                                                                _7565 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                                                _7566 = dot(float3(_380, _381, _379), float3(_7549, _7550, _7551));
                                                                                _7569 = rsqrt((_7566 * 2.0f) + 2.0f);
                                                                                _7576 = (_7556 > 0.0f);
                                                                                do {
                                                                                  _7667 = saturate((_7569 * _7566) + _7569);
                                                                                  _7668 = saturate(_7569 * (_7565 + _7564));
                                                                                  if (_7576) {
                                                                                    _7580 = sqrt(1.0f - (_7556 * _7556));
                                                                                    _7582 = (_7564 * 2.0f) * _7565;
                                                                                    _7583 = _7582 - _7566;
                                                                                    if (!(!(_7583 >= _7580))) {
                                                                                      _7667 = abs(_7565);
                                                                                      _7668 = 1.0f;
                                                                                    } else {
                                                                                      _7591 = rsqrt(1.0f - (_7583 * _7583)) * _7556;
                                                                                      _7594 = _7591 * (_7565 - (_7583 * _7564));
                                                                                      _7595 = _7565 * _7565;
                                                                                      _7600 = _7591 * (((_7595 * 2.0f) + -1.0f) - (_7583 * _7566));
                                                                                      _7609 = sqrt(saturate((((1.0f - (_7564 * _7564)) - _7595) - (_7566 * _7566)) + (_7582 * _7566)));
                                                                                      _7610 = _7609 * _7591;
                                                                                      _7613 = ((_7565 * 2.0f) * _7591) * _7609;
                                                                                      _7615 = (_7580 * _7564) + _7565;
                                                                                      _7616 = _7615 + _7594;
                                                                                      _7617 = _7580 * _7566;
                                                                                      _7619 = (_7617 + 1.0f) + _7600;
                                                                                      _7620 = _7610 * _7619;
                                                                                      _7621 = _7616 * _7619;
                                                                                      _7622 = _7613 * _7616;
                                                                                      _7627 = (((_7616 * 0.25f) * _7613) - (_7620 * 0.5f)) * _7621;
                                                                                      _7641 = (((_7622 - (_7620 * 2.0f)) * _7622) + (_7620 * _7620)) + ((((-0.5f - ((_7619 + _7617) * 0.5f)) * _7621) + ((_7619 * _7619) * _7615)) * _7616);
                                                                                      _7646 = (_7627 * 2.0f) / ((_7641 * _7641) + (_7627 * _7627));
                                                                                      _7647 = _7641 * _7646;
                                                                                      _7649 = 1.0f - (_7627 * _7646);
                                                                                      _7655 = ((_7647 * _7613) + _7617) + (_7649 * _7600);
                                                                                      _7658 = rsqrt((_7655 * 2.0f) + 2.0f);
                                                                                      _7667 = saturate((_7655 * _7658) + _7658);
                                                                                      _7668 = saturate(((_7615 + (_7647 * _7610)) + (_7649 * _7594)) * _7658);
                                                                                    }
                                                                                  }
                                                                                  _7669 = saturate(_7484);
                                                                                  _7671 = _7552 * _7552;
                                                                                  do {
                                                                                    _7681 = _7671;
                                                                                    if (_7558 > 0.0f) {
                                                                                      _7681 = saturate(((_7558 * _7558) / ((_7667 * 3.5999999046325684f) + 0.4000000059604645f)) + _7671);
                                                                                    }
                                                                                    do {
                                                                                      _7693 = _7681;
                                                                                      _7694 = 1.0f;
                                                                                      if (_7576) {
                                                                                        _7690 = (((_7556 * 0.25f) * ((sqrt(_7681) * 3.0f) + _7556)) / (_7667 + 0.0010000000474974513f)) + _7681;
                                                                                        _7693 = _7690;
                                                                                        _7694 = (_7681 / _7690);
                                                                                      }
                                                                                      do {
                                                                                        _7714 = _7694;
                                                                                        if (_7468 < 1.0f) {
                                                                                          _7701 = sqrt((1.000100016593933f - _7468) / max(9.999999974752427e-07f, (_7468 + 1.0f)));
                                                                                          _7714 = (sqrt(_7693 / ((((_7701 * 0.25f) * ((sqrt(_7693) * 3.0f) + _7701)) / (_7667 + 0.0010000000474974513f)) + _7693)) * _7694);
                                                                                        }
                                                                                        _7718 = (((_7681 * _7668) - _7668) * _7668) + 1.0f;
                                                                                        _7723 = saturate(abs(_7565) + 9.999999747378752e-06f);
                                                                                        _7724 = sqrt(_7681);
                                                                                        _7725 = 1.0f - _7724;
                                                                                        _7737 = saturate((dot(float3(_184, _185, _186), float3((_7560 * _7427), (_7560 * _7428), (_7560 * _7429))) + _6251) / (_6251 + 1.0f));
                                                                                        _7740 = ((_7714 * _7669) * (_7681 / (_7718 * _7718))) * (0.5f / ((((_7725 * _7723) + _7724) * _7669) + (((_7725 * _7669) + _7724) * _7723)));
                                                                                        _7741 = _7380 * _1499;
                                                                                        _7742 = _7381 * _1499;
                                                                                        _7743 = _7382 * _1499;
                                                                                        _7750 = ((_7425 * _7741) * _7737) + _1437;
                                                                                        _7751 = ((_7425 * _7742) * _7737) + _1438;
                                                                                        _7752 = ((_7425 * _7743) * _7737) + _1439;
                                                                                        if (_6248 > 0.0f) {
                                                                                          _7761 = (exp2(log2(1.0f - saturate(_7667)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                          _7762 = select(_7422, (_7418 * _1199), _7418) * _6248;
                                                                                          _8247 = _7750;
                                                                                          _8248 = _7751;
                                                                                          _8249 = _7752;
                                                                                          _8250 = (((((_7741 * _1068) * _7762) * _7761) * _7740) + _1440);
                                                                                          _8251 = (((((_7742 * _1068) * _7762) * _7761) * _7740) + _1441);
                                                                                          _8252 = (((((_7743 * _1068) * _7762) * _7761) * _7740) + _1442);
                                                                                        } else {
                                                                                          _8247 = _7750;
                                                                                          _8248 = _7751;
                                                                                          _8249 = _7752;
                                                                                          _8250 = _1440;
                                                                                          _8251 = _1441;
                                                                                          _8252 = _1442;
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
                                                                    }
                                                                    break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                              // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                              break;
                                                            }
                                                            _7252 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_62, _63, 0));
                                                            do {
                                                              if (_7249 == 0) {
                                                                _7266 = _7252.x;
                                                              } else {
                                                                if (_7249 == 1) {
                                                                  _7266 = _7252.y;
                                                                } else {
                                                                  if (_7249 == 2) {
                                                                    _7266 = _7252.z;
                                                                  } else {
                                                                    _7266 = _7252.w;
                                                                  }
                                                                }
                                                              }
                                                              _7274 = ((((_7206 * _7206) * ((_7266 * _7266) + -1.0f)) + 1.0f) * _6363);
                                                              [branch]
                                                              if (_7274 > 0.0f) {
                                                                do {
                                                                  _7380 = _7228;
                                                                  _7381 = _7229;
                                                                  _7382 = _7230;
                                                                  if (!(((_6218 & 1) == 0) || _6365)) {
                                                                    _7290 = max(max(_7228, _7229), _7230);
                                                                    do {
                                                                      _7300 = _7228;
                                                                      _7301 = _7229;
                                                                      _7302 = _7230;
                                                                      if (_7290 > 0.0f) {
                                                                        _7300 = saturate(_7228 / _7290);
                                                                        _7301 = saturate(_7229 / _7290);
                                                                        _7302 = saturate(_7230 / _7290);
                                                                      }
                                                                      _7303 = (_7301 < _7302);
                                                                      _7304 = select(_7303, _7302, _7301);
                                                                      _7305 = select(_7303, _7301, _7302);
                                                                      _7306 = select(_7303, -1.0f, 0.0f);
                                                                      _7307 = (_7300 < _7304);
                                                                      _7309 = select(_7307, _7304, _7300);
                                                                      _7310 = select(_7307, _7300, _7304);
                                                                      _7314 = _7309 - select((_7310 < _7305), _7310, _7305);
                                                                      _7320 = abs(select(_7307, (-0.3333333432674408f - _7306), _7306) + ((_7310 - _7305) / ((_7314 * 6.0f) + 9.999999682655225e-21f)));
                                                                      do {
                                                                        _7333 = _7320;
                                                                        if (_7320 < 0.6666666865348816f) {
                                                                          _7333 = ((saturate(((float)((uint)((uint)(((uint)(_6218) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7320 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7320)) + _7320);
                                                                        }
                                                                        _7334 = saturate((_7314 / (_7309 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6218) >> 1) & 255)))) * 0.003921499941498041f));
                                                                        _7335 = saturate(_7309);
                                                                        do {
                                                                          _7362 = _7335;
                                                                          _7363 = _7335;
                                                                          _7364 = _7335;
                                                                          if (!(_7334 <= 0.0f)) {
                                                                            _7338 = saturate(_7333);
                                                                            _7342 = select(((_7338 * 360.0f) >= 360.0f), 0.0f, (_7338 * 6.0f));
                                                                            _7343 = int(_7342);
                                                                            _7345 = _7342 - float((int)(_7343));
                                                                            _7347 = _7335 * (1.0f - _7334);
                                                                            _7350 = (1.0f - (_7345 * _7334)) * _7335;
                                                                            _7354 = (1.0f - ((1.0f - _7345) * _7334)) * _7335;
                                                                            switch (_7343) {
                                                                              case 0: {
                                                                                _7362 = _7335;
                                                                                _7363 = _7354;
                                                                                _7364 = _7347;
                                                                                break;
                                                                              }
                                                                              case 1: {
                                                                                _7362 = _7350;
                                                                                _7363 = _7335;
                                                                                _7364 = _7347;
                                                                                break;
                                                                              }
                                                                              case 2: {
                                                                                _7362 = _7347;
                                                                                _7363 = _7335;
                                                                                _7364 = _7354;
                                                                                break;
                                                                              }
                                                                              case 3: {
                                                                                _7362 = _7347;
                                                                                _7363 = _7350;
                                                                                _7364 = _7335;
                                                                                break;
                                                                              }
                                                                              case 4: {
                                                                                _7362 = _7354;
                                                                                _7363 = _7347;
                                                                                _7364 = _7335;
                                                                                break;
                                                                              }
                                                                              case 5: {
                                                                                _7362 = _7335;
                                                                                _7363 = _7347;
                                                                                _7364 = _7350;
                                                                                break;
                                                                              }
                                                                              default: {
                                                                                _7362 = 0.0f;
                                                                                _7363 = 0.0f;
                                                                                _7364 = 0.0f;
                                                                                break;
                                                                              }
                                                                            }
                                                                          }
                                                                          _7365 = _7362 * _7290;
                                                                          _7366 = _7363 * _7290;
                                                                          _7367 = _7364 * _7290;
                                                                          _7369 = saturate(_7207 * 1.0101009607315063f);
                                                                          _7380 = ((_7369 * (_7228 - _7365)) + _7365);
                                                                          _7381 = ((_7369 * (_7229 - _7366)) + _7366);
                                                                          _7382 = (lerp(_7367, _7230, _7369));
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  do {
                                                                    _7418 = _7274;
                                                                    [branch]
                                                                    if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                      _7389 = srvLightMappingData[_1452];
                                                                      if (!(_7389 == -1)) {
                                                                        _7394 = srvLightIndexData[_7389].nLayerIndex;
                                                                        _7396 = srvLightIndexData[_7389].vAtlasOrigin.x;
                                                                        _7397 = srvLightIndexData[_7389].vAtlasOrigin.y;
                                                                        _7399 = srvLightIndexData[_7389].vScreenOrigin.x;
                                                                        _7400 = srvLightIndexData[_7389].vScreenOrigin.y;
                                                                        _7409 = ((int)(_7394 * 5)) & 31;
                                                                        _7418 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7396 + _62) - _7399)), ((int)((_7397 + _63) - _7400)), 0)))).x) & ((int)(31 << _7409)))) >> _7409)) >> 1)))) * 0.06666667014360428f) * _7274);
                                                                      } else {
                                                                        _7418 = _7274;
                                                                      }
                                                                    }
                                                                    _7422 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                    _7425 = select(_7422, (_7418 * _1199), _7418);
                                                                    _7427 = _6291 * _6290;
                                                                    _7428 = _6292 * _6290;
                                                                    _7429 = _6293 * _6290;
                                                                    _7430 = _6252 * _6183;
                                                                    _7431 = _6252 * _6184;
                                                                    _7432 = _6252 * _6185;
                                                                    _7433 = _7427 + _7430;
                                                                    _7434 = _7428 + _7431;
                                                                    _7435 = _7429 + _7432;
                                                                    _7436 = _7427 - _7430;
                                                                    _7437 = _7428 - _7431;
                                                                    _7438 = _7429 - _7432;
                                                                    _7439 = (_6252 > 0.0f);
                                                                    _7440 = dot(float3(_7433, _7434, _7435), float3(_7433, _7434, _7435));
                                                                    _7441 = rsqrt(_7440);
                                                                    do {
                                                                      [branch]
                                                                      if (_7439) {
                                                                        _7444 = rsqrt(dot(float3(_7436, _7437, _7438), float3(_7436, _7437, _7438)));
                                                                        _7445 = _7444 * _7441;
                                                                        _7447 = dot(float3(_7433, _7434, _7435), float3(_7436, _7437, _7438)) * _7445;
                                                                        _7466 = (_7445 / ((_7445 + 0.5f) + (_7447 * 0.5f)));
                                                                        _7467 = (((dot(float3(_184, _185, _186), float3(_7436, _7437, _7438)) * _7444) + (dot(float3(_184, _185, _186), float3(_7433, _7434, _7435)) * _7441)) * 0.5f);
                                                                        _7468 = _7447;
                                                                      } else {
                                                                        _7466 = (1.0f / (_7440 + 1.0f));
                                                                        _7467 = dot(float3(_184, _185, _186), float3((_7441 * _7433), (_7441 * _7434), (_7441 * _7435)));
                                                                        _7468 = 1.0f;
                                                                      }
                                                                      do {
                                                                        _7484 = _7467;
                                                                        if (_6254 > 0.0f) {
                                                                          _7474 = sqrt(saturate((_6254 * _6254) * _7466));
                                                                          if (_7467 < _7474) {
                                                                            _7479 = max(_7467, (-0.0f - _7474)) + _7474;
                                                                            _7484 = ((_7479 * _7479) / (_7474 * 4.0f));
                                                                          } else {
                                                                            _7484 = _7467;
                                                                          }
                                                                        }
                                                                        do {
                                                                          _7544 = _7433;
                                                                          _7545 = _7434;
                                                                          _7546 = _7435;
                                                                          if (_7439) {
                                                                            _7486 = -0.0f - _380;
                                                                            _7487 = -0.0f - _381;
                                                                            _7488 = -0.0f - _379;
                                                                            _7490 = dot(float3(_7486, _7487, _7488), float3(_184, _185, _186)) * 2.0f;
                                                                            _7494 = _7486 - (_7490 * _184);
                                                                            _7495 = _7487 - (_7490 * _185);
                                                                            _7496 = _7488 - (_7490 * _186);
                                                                            _7497 = _7436 - _7433;
                                                                            _7498 = _7437 - _7434;
                                                                            _7499 = _7438 - _7435;
                                                                            _7500 = dot(float3(_7494, _7495, _7496), float3(_7497, _7498, _7499));
                                                                            _7506 = sqrt(((_7497 * _7497) + (_7498 * _7498)) + (_7499 * _7499));
                                                                            _7515 = saturate(((dot(float3(_7494, _7495, _7496), float3(_7433, _7434, _7435)) * _7500) - dot(float3(_7433, _7434, _7435), float3(_7497, _7498, _7499))) / ((_7506 * _7506) - (_7500 * _7500)));
                                                                            _7519 = (_7515 * _7497) + _7433;
                                                                            _7520 = (_7515 * _7498) + _7434;
                                                                            _7521 = (_7515 * _7499) + _7435;
                                                                            _7522 = dot(float3(_7519, _7520, _7521), float3(_7494, _7495, _7496));
                                                                            _7526 = (_7522 * _7494) - _7519;
                                                                            _7527 = (_7522 * _7495) - _7520;
                                                                            _7528 = (_7522 * _7496) - _7521;
                                                                            _7536 = saturate(0.009999999776482582f / sqrt(((_7526 * _7526) + (_7527 * _7527)) + (_7528 * _7528)));
                                                                            _7544 = ((_7536 * _7526) + _7519);
                                                                            _7545 = ((_7536 * _7527) + _7520);
                                                                            _7546 = ((_7536 * _7528) + _7521);
                                                                          }
                                                                          _7548 = rsqrt(dot(float3(_7544, _7545, _7546), float3(_7544, _7545, _7546)));
                                                                          _7549 = _7548 * _7544;
                                                                          _7550 = _7548 * _7545;
                                                                          _7551 = _7548 * _7546;
                                                                          _7552 = _195 * _195;
                                                                          _7556 = saturate((_6254 * (1.0f - _7552)) * _7548);
                                                                          _7558 = saturate(_7548 * f16tof32(_6197));
                                                                          _7560 = rsqrt(dot(float3(_7427, _7428, _7429), float3(_7427, _7428, _7429)));
                                                                          _7564 = dot(float3(_184, _185, _186), float3(_7549, _7550, _7551));
                                                                          _7565 = dot(float3(_184, _185, _186), float3(_380, _381, _379));
                                                                          _7566 = dot(float3(_380, _381, _379), float3(_7549, _7550, _7551));
                                                                          _7569 = rsqrt((_7566 * 2.0f) + 2.0f);
                                                                          _7576 = (_7556 > 0.0f);
                                                                          do {
                                                                            _7667 = saturate((_7569 * _7566) + _7569);
                                                                            _7668 = saturate(_7569 * (_7565 + _7564));
                                                                            if (_7576) {
                                                                              _7580 = sqrt(1.0f - (_7556 * _7556));
                                                                              _7582 = (_7564 * 2.0f) * _7565;
                                                                              _7583 = _7582 - _7566;
                                                                              if (!(!(_7583 >= _7580))) {
                                                                                _7667 = abs(_7565);
                                                                                _7668 = 1.0f;
                                                                              } else {
                                                                                _7591 = rsqrt(1.0f - (_7583 * _7583)) * _7556;
                                                                                _7594 = _7591 * (_7565 - (_7583 * _7564));
                                                                                _7595 = _7565 * _7565;
                                                                                _7600 = _7591 * (((_7595 * 2.0f) + -1.0f) - (_7583 * _7566));
                                                                                _7609 = sqrt(saturate((((1.0f - (_7564 * _7564)) - _7595) - (_7566 * _7566)) + (_7582 * _7566)));
                                                                                _7610 = _7609 * _7591;
                                                                                _7613 = ((_7565 * 2.0f) * _7591) * _7609;
                                                                                _7615 = (_7580 * _7564) + _7565;
                                                                                _7616 = _7615 + _7594;
                                                                                _7617 = _7580 * _7566;
                                                                                _7619 = (_7617 + 1.0f) + _7600;
                                                                                _7620 = _7610 * _7619;
                                                                                _7621 = _7616 * _7619;
                                                                                _7622 = _7613 * _7616;
                                                                                _7627 = (((_7616 * 0.25f) * _7613) - (_7620 * 0.5f)) * _7621;
                                                                                _7641 = (((_7622 - (_7620 * 2.0f)) * _7622) + (_7620 * _7620)) + ((((-0.5f - ((_7619 + _7617) * 0.5f)) * _7621) + ((_7619 * _7619) * _7615)) * _7616);
                                                                                _7646 = (_7627 * 2.0f) / ((_7641 * _7641) + (_7627 * _7627));
                                                                                _7647 = _7641 * _7646;
                                                                                _7649 = 1.0f - (_7627 * _7646);
                                                                                _7655 = ((_7647 * _7613) + _7617) + (_7649 * _7600);
                                                                                _7658 = rsqrt((_7655 * 2.0f) + 2.0f);
                                                                                _7667 = saturate((_7655 * _7658) + _7658);
                                                                                _7668 = saturate(((_7615 + (_7647 * _7610)) + (_7649 * _7594)) * _7658);
                                                                              }
                                                                            }
                                                                            _7669 = saturate(_7484);
                                                                            _7671 = _7552 * _7552;
                                                                            do {
                                                                              _7681 = _7671;
                                                                              if (_7558 > 0.0f) {
                                                                                _7681 = saturate(((_7558 * _7558) / ((_7667 * 3.5999999046325684f) + 0.4000000059604645f)) + _7671);
                                                                              }
                                                                              do {
                                                                                _7693 = _7681;
                                                                                _7694 = 1.0f;
                                                                                if (_7576) {
                                                                                  _7690 = (((_7556 * 0.25f) * ((sqrt(_7681) * 3.0f) + _7556)) / (_7667 + 0.0010000000474974513f)) + _7681;
                                                                                  _7693 = _7690;
                                                                                  _7694 = (_7681 / _7690);
                                                                                }
                                                                                do {
                                                                                  _7714 = _7694;
                                                                                  if (_7468 < 1.0f) {
                                                                                    _7701 = sqrt((1.000100016593933f - _7468) / max(9.999999974752427e-07f, (_7468 + 1.0f)));
                                                                                    _7714 = (sqrt(_7693 / ((((_7701 * 0.25f) * ((sqrt(_7693) * 3.0f) + _7701)) / (_7667 + 0.0010000000474974513f)) + _7693)) * _7694);
                                                                                  }
                                                                                  _7718 = (((_7681 * _7668) - _7668) * _7668) + 1.0f;
                                                                                  _7723 = saturate(abs(_7565) + 9.999999747378752e-06f);
                                                                                  _7724 = sqrt(_7681);
                                                                                  _7725 = 1.0f - _7724;
                                                                                  _7737 = saturate((dot(float3(_184, _185, _186), float3((_7560 * _7427), (_7560 * _7428), (_7560 * _7429))) + _6251) / (_6251 + 1.0f));
                                                                                  _7740 = ((_7714 * _7669) * (_7681 / (_7718 * _7718))) * (0.5f / ((((_7725 * _7723) + _7724) * _7669) + (((_7725 * _7669) + _7724) * _7723)));
                                                                                  _7741 = _7380 * _1499;
                                                                                  _7742 = _7381 * _1499;
                                                                                  _7743 = _7382 * _1499;
                                                                                  _7750 = ((_7425 * _7741) * _7737) + _1437;
                                                                                  _7751 = ((_7425 * _7742) * _7737) + _1438;
                                                                                  _7752 = ((_7425 * _7743) * _7737) + _1439;
                                                                                  if (_6248 > 0.0f) {
                                                                                    _7761 = (exp2(log2(1.0f - saturate(_7667)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                    _7762 = select(_7422, (_7418 * _1199), _7418) * _6248;
                                                                                    _8247 = _7750;
                                                                                    _8248 = _7751;
                                                                                    _8249 = _7752;
                                                                                    _8250 = (((((_7741 * _1068) * _7762) * _7761) * _7740) + _1440);
                                                                                    _8251 = (((((_7742 * _1068) * _7762) * _7761) * _7740) + _1441);
                                                                                    _8252 = (((((_7743 * _1068) * _7762) * _7761) * _7740) + _1442);
                                                                                  } else {
                                                                                    _8247 = _7750;
                                                                                    _8248 = _7751;
                                                                                    _8249 = _7752;
                                                                                    _8250 = _1440;
                                                                                    _8251 = _1441;
                                                                                    _8252 = _1442;
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
                                                              } else {
                                                                _8247 = _1437;
                                                                _8248 = _1438;
                                                                _8249 = _1439;
                                                                _8250 = _1440;
                                                                _8251 = _1441;
                                                                _8252 = _1442;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _8247 = _1437;
                                                          _8248 = _1438;
                                                          _8249 = _1439;
                                                          _8250 = _1440;
                                                          _8251 = _1441;
                                                          _8252 = _1442;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    if (_1482 == 10) {
                                                      _7783 = asfloat(srvLightInfoProperties.Load4(_1451)).x;
                                                      _7784 = asfloat(srvLightInfoProperties.Load4(_1451)).y;
                                                      _7785 = asfloat(srvLightInfoProperties.Load4(_1451)).z;
                                                      _7786 = asfloat(srvLightInfoProperties.Load4(_1451)).w;
                                                      _7789 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).x;
                                                      _7790 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).y;
                                                      _7791 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).z;
                                                      _7792 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 16u)))).w;
                                                      _7795 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).x;
                                                      _7796 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).y;
                                                      _7797 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).z;
                                                      _7798 = asfloat(srvLightInfoProperties.Load4(((int)(_1451 + 32u)))).w;
                                                      _7801 = asfloat(srvLightInfoProperties.Load2(((int)(_1451 + 72u)))).x;
                                                      _7802 = asfloat(srvLightInfoProperties.Load2(((int)(_1451 + 72u)))).y;
                                                      _7805 = asint(srvLightInfoProperties.Load(((int)(_1451 + 80u))));
                                                      _7808 = asint(srvLightInfoProperties.Load(((int)(_1451 + 84u))));
                                                      _7811 = asint(srvLightInfoProperties.Load(((int)(_1451 + 88u))));
                                                      _7814 = asint(srvLightInfoProperties.Load(((int)(_1451 + 96u))));
                                                      _7817 = f16tof32(_7805);
                                                      _7819 = f16tof32(((uint)((uint)(_7808) >> 16)));
                                                      _7820 = f16tof32(_7808);
                                                      _7822 = f16tof32(((uint)((uint)(_7811) >> 16)));
                                                      _7826 = ((float)((uint)((uint)(((uint)(_7811) >> 8) & 255)))) * 0.003921499941498041f;
                                                      _7828 = (float)((uint)((uint)(_7814 & 65535)));
                                                      _7832 = mad(_7785, _209, mad(_7784, _208, (_7783 * _207))) + _7786;
                                                      _7836 = mad(_7791, _209, mad(_7790, _208, (_7789 * _207))) + _7792;
                                                      _7840 = mad(_7797, _209, mad(_7796, _208, (_7795 * _207))) + _7798;
                                                      _7843 = mad(_7785, _186, mad(_7784, _185, (_7783 * _184)));
                                                      _7846 = mad(_7791, _186, mad(_7790, _185, (_7789 * _184)));
                                                      _7849 = mad(_7797, _186, mad(_7796, _185, (_7795 * _184)));
                                                      _7861 = -0.0f - mad(_7797, _379, mad(_7796, _381, (_7795 * _380)));
                                                      _7862 = _7801 * 0.5f;
                                                      _7863 = _7802 * 0.5f;
                                                      _7864 = -0.0f - _7862;
                                                      _7865 = -0.0f - _7863;
                                                      _7866 = _7864 - _7832;
                                                      _7867 = _7865 - _7836;
                                                      _7868 = -0.0f - _7840;
                                                      _7869 = _7862 - _7832;
                                                      _7870 = _7863 - _7836;
                                                      _7871 = dot(float3(_7832, _7836, _7840), float3(_7843, _7846, _7849));
                                                      _7873 = dot(float3(_7864, _7865, 0.0f), float3(_7843, _7846, _7849)) - _7871;
                                                      _7875 = dot(float3(_7862, _7865, 0.0f), float3(_7843, _7846, _7849)) - _7871;
                                                      _7877 = dot(float3(_7862, _7863, 0.0f), float3(_7843, _7846, _7849)) - _7871;
                                                      _7879 = dot(float3(_7864, _7863, 0.0f), float3(_7843, _7846, _7849)) - _7871;
                                                      _7880 = min(_7873, _7875);
                                                      do {
                                                        _7902 = 0.0f;
                                                        _7903 = 0.0f;
                                                        [branch]
                                                        if (!(!(_7880 >= 0.0f))) {
                                                          _7886 = rsqrt(dot(float3(_7869, _7867, _7868), float3(_7869, _7867, _7868)) * dot(float3(_7866, _7867, _7868), float3(_7866, _7867, _7868)));
                                                          _7888 = dot(float3(_7866, _7867, _7868), float3(_7869, _7867, _7868)) * _7886;
                                                          _7895 = rsqrt(max(((((_7888 * 0.09300000220537186f) + 0.5f) * _7888) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7886;
                                                          _7902 = (_7895 * (_7801 * _7868));
                                                          _7903 = (_7895 * (_7867 * (_7864 - _7862)));
                                                        }
                                                        do {
                                                          _7927 = 0.0f;
                                                          _7928 = _7903;
                                                          [branch]
                                                          if (!(!(min(_7875, _7877) >= 0.0f))) {
                                                            _7910 = rsqrt(dot(float3(_7869, _7870, _7868), float3(_7869, _7870, _7868)) * dot(float3(_7869, _7867, _7868), float3(_7869, _7867, _7868)));
                                                            _7912 = dot(float3(_7869, _7867, _7868), float3(_7869, _7870, _7868)) * _7910;
                                                            _7919 = rsqrt(max(((((_7912 * 0.09300000220537186f) + 0.5f) * _7912) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7910;
                                                            _7927 = (_7919 * ((_7865 - _7863) * _7868));
                                                            _7928 = ((_7919 * (_7802 * _7869)) + _7903);
                                                          }
                                                          _7929 = min(_7877, _7879);
                                                          do {
                                                            _7953 = _7902;
                                                            _7954 = _7928;
                                                            [branch]
                                                            if (!(!(_7929 >= 0.0f))) {
                                                              _7935 = rsqrt(dot(float3(_7866, _7870, _7868), float3(_7866, _7870, _7868)) * dot(float3(_7869, _7870, _7868), float3(_7869, _7870, _7868)));
                                                              _7937 = dot(float3(_7869, _7870, _7868), float3(_7866, _7870, _7868)) * _7935;
                                                              _7944 = rsqrt(max(((((_7937 * 0.09300000220537186f) + 0.5f) * _7937) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7935;
                                                              _7953 = ((_7944 * ((_7864 - _7862) * _7868)) + _7902);
                                                              _7954 = ((_7944 * (_7801 * _7870)) + _7928);
                                                            }
                                                            do {
                                                              _7979 = _7927;
                                                              _7980 = _7954;
                                                              [branch]
                                                              if (!(!(min(_7879, _7873) >= 0.0f))) {
                                                                _7961 = rsqrt(dot(float3(_7866, _7867, _7868), float3(_7866, _7867, _7868)) * dot(float3(_7866, _7870, _7868), float3(_7866, _7870, _7868)));
                                                                _7963 = dot(float3(_7866, _7870, _7868), float3(_7866, _7867, _7868)) * _7961;
                                                                _7970 = rsqrt(max(((((_7963 * 0.09300000220537186f) + 0.5f) * _7963) + 0.40700000524520874f), 9.999999682655225e-21f)) * _7961;
                                                                _7979 = ((_7970 * (_7802 * _7868)) + _7927);
                                                                _7980 = ((_7970 * (_7866 * (_7865 - _7863))) + _7954);
                                                              }
                                                              do {
                                                                _8123 = _7979;
                                                                _8124 = _7953;
                                                                _8125 = _7980;
                                                                if (min(_7880, _7929) < 0.0f) {
                                                                  [branch]
                                                                  if (!(!(max(max(_7873, _7875), max(_7877, _7879)) >= 0.0f))) {
                                                                    _7989 = -0.0f - _7843;
                                                                    _7990 = _7871 / _7846;
                                                                    _7991 = _7864 / _7846;
                                                                    _7992 = _7862 / _7846;
                                                                    _7994 = (_7865 - _7990) / _7989;
                                                                    _7996 = (_7863 - _7990) / _7989;
                                                                    _7997 = min(_7991, _7992);
                                                                    _7998 = max(_7991, _7992);
                                                                    _7999 = min(_7994, _7996);
                                                                    _8000 = max(_7994, _7996);
                                                                    _8001 = max(_7997, _7999);
                                                                    _8002 = min(_7998, _8000);
                                                                    _8003 = _8001 * _7846;
                                                                    _8005 = _8002 * _7846;
                                                                    _8007 = _8003 - _7832;
                                                                    _8008 = _7990 - _7836;
                                                                    _8009 = _8008 + (_8001 * _7989);
                                                                    _8010 = _8005 - _7832;
                                                                    _8011 = _8008 + (_8002 * _7989);
                                                                    _8012 = dot(float3(_8007, _8009, _7868), float3(_8007, _8009, _7868));
                                                                    _8013 = dot(float3(_8010, _8011, _7868), float3(_8010, _8011, _7868));
                                                                    _8015 = rsqrt(_8013 * _8012);
                                                                    _8017 = dot(float3(_8007, _8009, _7868), float3(_8010, _8011, _7868)) * _8015;
                                                                    _8024 = rsqrt(max(((((_8017 * 0.09300000220537186f) + 0.5f) * _8017) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8015;
                                                                    _8037 = (_7997 > _7999);
                                                                    _8039 = select(_8037, _7846, _7843);
                                                                    _8045 = float((int)(((int)(uint)((int)(_8039 > 0.0f))) - ((int)(uint)((int)(_8039 < 0.0f)))));
                                                                    _8049 = ((1.0f - (((float)((bool)_8037)) * 2.0f)) * _7862) * _8045;
                                                                    _8051 = _8049 - _7832;
                                                                    _8052 = (_8045 * _7863) - _7836;
                                                                    _8053 = (_7998 < _8000);
                                                                    _8055 = select(_8053, _7846, _7843);
                                                                    _8061 = float((int)(((int)(uint)((int)(_8055 > 0.0f))) - ((int)(uint)((int)(_8055 < 0.0f)))));
                                                                    _8062 = _8061 * _7862;
                                                                    _8067 = _8062 - _7832;
                                                                    _8068 = ((((((float)((bool)_8053)) * 2.0f) + -1.0f) * _7863) * _8061) - _7836;
                                                                    _8071 = rsqrt(_8012 * dot(float3(_8051, _8052, _7868), float3(_8051, _8052, _7868)));
                                                                    _8073 = dot(float3(_8051, _8052, _7868), float3(_8007, _8009, _7868)) * _8071;
                                                                    _8080 = rsqrt(max(((((_8073 * 0.09300000220537186f) + 0.5f) * _8073) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8071;
                                                                    _8093 = rsqrt(dot(float3(_8067, _8068, _7868), float3(_8067, _8068, _7868)) * _8013);
                                                                    _8095 = dot(float3(_8010, _8011, _7868), float3(_8067, _8068, _7868)) * _8093;
                                                                    _8102 = rsqrt(max(((((_8095 * 0.09300000220537186f) + 0.5f) * _8095) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8093;
                                                                    _8123 = ((((_8024 * (((_8001 - _8002) * _7989) * _7868)) + _7979) + (_8080 * ((_8052 - _8009) * _7868))) + (_8102 * ((_8011 - _8068) * _7868)));
                                                                    _8124 = ((((_8024 * ((_7846 * (_8002 - _8001)) * _7868)) + _7953) + (_8080 * ((_8003 - _8049) * _7868))) + (_8102 * ((_8062 - _8005) * _7868)));
                                                                    _8125 = ((((_8024 * ((_8011 * _8007) - (_8010 * _8009))) + _7980) + (_8080 * ((_8051 * _8009) - (_8052 * _8007)))) + (_8102 * ((_8068 * _8010) - (_8067 * _8011))));
                                                                  } else {
                                                                    _8123 = _7979;
                                                                    _8124 = _7953;
                                                                    _8125 = _7980;
                                                                  }
                                                                }
                                                                _8131 = sqrt(((_8124 * _8124) + (_8123 * _8123)) + (_8125 * _8125));
                                                                _8132 = _8131 * 0.15915493667125702f;
                                                                [branch]
                                                                if (!(_8132 == 0.0f)) {
                                                                  _8141 = saturate((_8132 - _7817) / (1.0f - _7817)) * ((float)((bool)(uint)(_7840 <= 0.0f)));
                                                                  [branch]
                                                                  if (!(_8141 == 0.0f)) {
                                                                    do {
                                                                      _8149 = 0.0f;
                                                                      if (_8131 > 0.0f) {
                                                                        _8149 = (dot(float3(_7843, _7846, _7849), float3(_8123, _8124, _8125)) / _8131);
                                                                      }
                                                                      _8150 = 1.0f - _195;
                                                                      _8155 = min(_195, 0.800000011920929f);
                                                                      _8164 = exp2(((((((_8155 * 3.322999954223633f) + -3.7669999599456787f) * _8155) + -0.3479999899864197f) * _8155) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                                                      _8171 = _7868 / (_7861 - ((_7849 * 2.0f) * dot(float3((-0.0f - mad(_7785, _379, mad(_7784, _381, (_7783 * _380)))), (-0.0f - mad(_7791, _379, mad(_7790, _381, (_7789 * _380)))), _7861), float3(_7843, _7846, _7849))));
                                                                      _8174 = (_8171 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8164) * saturate((_195 + -0.5f) * 2.500000238418579f)) + _8164);
                                                                      _8182 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7828), ((log2((_8174 * _8174) * f16tof32(((uint)((uint)(_7805) >> 16)))) * 0.5f) + 5.5f));
                                                                      _8184 = (float)((bool)(uint)(_8171 > 0.0f));
                                                                      _8185 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7828), 10.0f);
                                                                      _8194 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8141 * _1199), _8141);
                                                                      do {
                                                                        _8231 = _1440;
                                                                        _8232 = _1441;
                                                                        _8233 = _1442;
                                                                        if (_7826 > 0.0f) {
                                                                          _8210 = ((max((_8150 * _8150), 0.03999999910593033f) + -0.03999999910593033f) * exp2(log2(1.0f - saturate(dot(float3(_184, _185, _186), float3(_380, _381, _379)))) * 5.0f)) + 0.03999999910593033f;
                                                                          _8211 = _8194 * _1499;
                                                                          _8231 = ((((((_7826 * _7819) * _8184) * _8182.x) * _8211) * _8210) + _1440);
                                                                          _8232 = ((((((_7820 * _7826) * _8184) * _8182.y) * _8211) * _8210) + _1441);
                                                                          _8233 = ((((((_7822 * _7826) * _8184) * _8182.z) * _8211) * _8210) + _1442);
                                                                        }
                                                                        _8239 = ((_1499 * 5.4256415367126465f) * _8149) * _8194;
                                                                        _8247 = (((_8185.x * _7819) * _8239) + _1437);
                                                                        _8248 = (((_8185.y * _7820) * _8239) + _1438);
                                                                        _8249 = (((_8185.z * _7822) * _8239) + _1439);
                                                                        _8250 = _8231;
                                                                        _8251 = _8232;
                                                                        _8252 = _8233;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _8247 = _1437;
                                                                    _8248 = _1438;
                                                                    _8249 = _1439;
                                                                    _8250 = _1440;
                                                                    _8251 = _1441;
                                                                    _8252 = _1442;
                                                                  }
                                                                } else {
                                                                  _8247 = _1437;
                                                                  _8248 = _1438;
                                                                  _8249 = _1439;
                                                                  _8250 = _1440;
                                                                  _8251 = _1441;
                                                                  _8252 = _1442;
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
                                                      _8247 = _1437;
                                                      _8248 = _1438;
                                                      _8249 = _1439;
                                                      _8250 = _1440;
                                                      _8251 = _1441;
                                                      _8252 = _1442;
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      } else {
                                        _8247 = _1437;
                                        _8248 = _1438;
                                        _8249 = _1439;
                                        _8250 = _1440;
                                        _8251 = _1441;
                                        _8252 = _1442;
                                      }
                                    }
                                    _8253 = _1443 + 1u;
                                    do {
                                      if (!(_8253 == _global_2)) {
                                        _1437 = _8247;
                                        _1438 = _8248;
                                        _1439 = _8249;
                                        _1440 = _8250;
                                        _1441 = _8251;
                                        _1442 = _8252;
                                        _1443 = _8253;
                                        _loop_break_3 = true;
                                        break;
                                      }
                                      _8257 = _8247;
                                      _8258 = _8248;
                                      _8259 = _8249;
                                      _8260 = _8250;
                                      _8261 = _8251;
                                      _8262 = _8252;
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
                              _8264 = rsqrt(dot(float3(_133, _134, -1.0f), float3(_133, _134, -1.0f)));
                              _8271 = 1.0f - _195;
                              _8281 = 0.9599999785423279f - (exp2(log2(1.0f - saturate(saturate(dot(float3(_184, _185, _186), float3((-0.0f - (_133 * _8264)), (-0.0f - (_134 * _8264)), _8264))))) * 5.0f) * (max((_8271 * _8271), 0.03999999910593033f) + -0.03999999910593033f));
                              _8421 = (_8281 * _8257);
                              _8422 = (_8281 * _8258);
                              _8423 = (_8281 * _8259);
                              _8424 = _8260;
                              _8425 = _8261;
                              _8426 = _8262;
                              _8427 = saturate(_141.x);
                              _8428 = saturate(_141.y);
                              _8429 = saturate(_141.z);
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
        _8300 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _134, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _133)));
        _8303 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _134, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _133)));
        _8306 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _134, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _133)));
        do {
          [branch]
          if (!(cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0)) {
            _8327 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8300, _8303, _8306), 0.0f);
            _8331 = _8327.x * 32.0f;
            _8332 = _8327.y * 32.0f;
            _8333 = _8327.z * 32.0f;
            _8335 = rsqrt(dot(float3(_8300, _8303, _8306), float3(_8300, _8303, _8306)));
            _8336 = _8335 * _8300;
            _8337 = _8335 * _8303;
            _8338 = _8335 * _8306;
            _8339 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
            _8340 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
            _8341 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
            _8342 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
            _8343 = dot(float3(_8336, _8337, _8338), float3(_8340, _8341, _8342));
            _8348 = (_8343 * _8343) - (dot(float3(_8340, _8341, _8342), float3(_8340, _8341, _8342)) - (_8339 * _8339));
            if ((_8343 > -0.0f) && (_8348 > 0.0f)) {
              _8353 = -0.0f - cbDeferredShading.vSunDirWS.z;
              _8366 = 74.80000305175781f / ((dot(float3(_8336, _8337, _8338), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8339) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
              _8374 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8336, _8338), float2(_8353, cbDeferredShading.vSunDirWS.x)) * _8366) + 0.5f), ((dot(float3(_8336, _8337, _8338), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8353)), (cbDeferredShading.vSunDirWS.y * _8353))) * _8366) + 0.5f)), 0.0f);
              _8376 = _8348 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
              if (_8376 > 0.0f) {
                _8383 = saturate(_8376 * 5.0f);
                _8410 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8374.x) * _8383) + _8331);
                _8411 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8374.y) * _8383) + _8332);
                _8412 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8374.z) * _8383) + _8333);
              } else {
                _8410 = _8331;
                _8411 = _8332;
                _8412 = _8333;
              }
            } else {
              _8410 = _8331;
              _8411 = _8332;
              _8412 = _8333;
            }
          } else {
            _8410 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
            _8411 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
            _8412 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
          }
          _8416 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
          _8421 = 0.0f;
          _8422 = 0.0f;
          _8423 = 0.0f;
          _8424 = select(_8416, 0.0f, _8410);
          _8425 = select(_8416, 0.0f, _8411);
          _8426 = select(_8416, 0.0f, _8412);
          _8427 = 0.0f;
          _8428 = 0.0f;
          _8429 = 0.0f;
        } while (false);
      }
      uavDeferredShadingPass_Specular[int2(_62, _63)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_8427 * _8421) + _8424)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_8428 * _8422) + _8425)), 7936.0f), 5.960464477539063e-08f), max(min((((_8429 * _8423) + _8426) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_62, _63)] = float3(0.0f, 0.0f, 0.0f);
    } while (false);
  }
}
