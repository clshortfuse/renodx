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
  float _257;
  float _258;
  float _259;
  float _260;
  float _350;
  float _351;
  float _389;
  int _504;
  float _505;
  float _506;
  float _507;
  float _508;
  float _509;
  float _510;
  float _511;
  float _512;
  float _513;
  float _514;
  float _515;
  float _516;
  float _517;
  float _518;
  float _633;
  float _634;
  float _635;
  float _722;
  float _723;
  float _724;
  float _742;
  float _743;
  float _744;
  float _776;
  float _777;
  float _778;
  float _779;
  float _780;
  float _781;
  float _782;
  float _796;
  float _797;
  float _798;
  float _799;
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
  float _814;
  float _815;
  float _816;
  float _817;
  float _818;
  float _819;
  float _820;
  float _821;
  float _822;
  float _823;
  float _824;
  float _825;
  float _826;
  float _827;
  float _876;
  float _877;
  float _878;
  float _898;
  float _899;
  float _900;
  float _911;
  float _912;
  float _913;
  float _914;
  float _915;
  float _916;
  float _919;
  float _920;
  float _921;
  float _922;
  float _923;
  float _924;
  float _925;
  float _939;
  float _940;
  float _941;
  float _942;
  float _943;
  float _944;
  float _973;
  float _974;
  float _975;
  float _995;
  float _996;
  float _997;
  float _1008;
  float _1009;
  float _1010;
  float _1011;
  float _1012;
  float _1013;
  float _1032;
  float _1033;
  float _1034;
  float _1035;
  float _1036;
  float _1037;
  float _1056;
  float _1057;
  float _1058;
  int _1089;
  float _1090;
  float _1208;
  float _1213;
  float _1226;
  float _1279;
  float _1280;
  float _1281;
  float _1334;
  float _1335;
  float _1336;
  float _1446;
  float _1451;
  float _1452;
  float _1453;
  float _1454;
  float _1455;
  float _1456;
  int _1457;
  float _2077;
  float _2078;
  float _2079;
  float _2169;
  float _2178;
  float _2187;
  float _2195;
  float _2266;
  float _2275;
  float _2284;
  float _2292;
  float _2365;
  float _2374;
  float _2383;
  float _2391;
  float _2464;
  float _2473;
  float _2482;
  float _2490;
  float _2542;
  float _2547;
  float _2644;
  float _2665;
  float _2666;
  float _2667;
  int _2686;
  float _2703;
  float _2707;
  float _2746;
  float _2778;
  float _2888;
  float _2889;
  float _2901;
  float _2913;
  float _2976;
  float _2977;
  float _2978;
  float _3004;
  float _3095;
  float _3096;
  float _3097;
  float _3148;
  float _3258;
  float _3259;
  float _3271;
  float _3283;
  float _3338;
  float _3339;
  float _3340;
  float _3371;
  float _3400;
  float _3401;
  float _3402;
  float _3418;
  float _3419;
  float _3420;
  float _3433;
  float _3434;
  float _3435;
  float _3596;
  float _3597;
  float _3598;
  float _3599;
  float _3600;
  float _3601;
  float _3693;
  float _3694;
  float _3695;
  float _3696;
  float _3697;
  float _3800;
  float _3809;
  float _3818;
  float _3826;
  float _3897;
  float _3906;
  float _3915;
  float _3923;
  float _3996;
  float _4005;
  float _4014;
  float _4022;
  float _4095;
  float _4104;
  float _4113;
  float _4121;
  float _4456;
  float _4457;
  int _4458;
  float _4487;
  float _4488;
  float _4489;
  float _4490;
  float _4491;
  float _4593;
  float _4602;
  float _4611;
  float _4619;
  float _4690;
  float _4699;
  float _4708;
  float _4716;
  float _4789;
  float _4798;
  float _4807;
  float _4815;
  float _4888;
  float _4897;
  float _4906;
  float _4914;
  float _5248;
  float _5249;
  bool _5250;
  float _5265;
  float _5266;
  float _5267;
  float _5325;
  float _5326;
  float _5351;
  float _5352;
  float _5447;
  float _5450;
  float _5451;
  float _5471;
  float _5472;
  float _5473;
  int _5491;
  float _5508;
  float _5512;
  float _5539;
  float _5540;
  float _5541;
  float _5572;
  float _5601;
  float _5602;
  float _5603;
  float _5619;
  float _5620;
  float _5621;
  float _5657;
  float _5705;
  float _5706;
  float _5707;
  float _5723;
  float _5783;
  float _5784;
  float _5785;
  float _5906;
  float _5907;
  float _5920;
  float _5932;
  float _5933;
  float _5953;
  float _6018;
  float _6019;
  float _6020;
  float _6159;
  float _6730;
  float _6731;
  float _6732;
  float _6822;
  float _6831;
  float _6840;
  float _6848;
  float _6919;
  float _6928;
  float _6937;
  float _6945;
  float _7018;
  float _7027;
  float _7036;
  float _7044;
  float _7117;
  float _7126;
  float _7135;
  float _7143;
  float _7195;
  float _7200;
  float _7201;
  float _7298;
  float _7299;
  float _7320;
  float _7321;
  float _7322;
  int _7341;
  float _7358;
  float _7366;
  float _7392;
  float _7393;
  float _7394;
  float _7425;
  float _7454;
  float _7455;
  float _7456;
  float _7472;
  float _7473;
  float _7474;
  float _7510;
  float _7558;
  float _7559;
  float _7560;
  float _7576;
  float _7636;
  float _7637;
  float _7638;
  float _7759;
  float _7760;
  float _7773;
  float _7785;
  float _7786;
  float _7806;
  float _7871;
  float _7872;
  float _7873;
  float _8022;
  float _8023;
  float _8047;
  float _8048;
  float _8073;
  float _8074;
  float _8099;
  float _8100;
  float _8243;
  float _8244;
  float _8245;
  float _8269;
  float _8351;
  float _8352;
  float _8353;
  float _8367;
  float _8368;
  float _8369;
  float _8370;
  float _8371;
  float _8372;
  float _8377;
  float _8378;
  float _8379;
  float _8380;
  float _8381;
  float _8382;
  float _8530;
  float _8531;
  float _8532;
  float _8541;
  float _8542;
  float _8543;
  float _8544;
  float _8545;
  float _8546;
  float _8547;
  float _8548;
  float _8549;
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
  float _194;
  float _195;
  float _196;
  float _197;
  float _206;
  float _212;
  float _213;
  float _214;
  float _220;
  float _221;
  float _222;
  float _223;
  int _229;
  uint _233;
  float _239;
  float4 _248;
  float _269;
  float _270;
  float _285;
  float _286;
  float _289;
  float _290;
  float _293;
  float _294;
  float4 _299;
  float _333;
  float _335;
  bool _336;
  float _338;
  float _340;
  bool _341;
  float4 _354;
  float _358;
  float _370;
  float _371;
  float _372;
  float _373;
  float _374;
  float _375;
  float _390;
  float _391;
  float _393;
  float _394;
  float _395;
  int _403;
  int _404;
  int _405;
  int _406;
  float _410;
  float _412;
  float _413;
  float _423;
  float _428;
  float _432;
  float _433;
  float _436;
  float _449;
  float _450;
  float _451;
  float _455;
  float _470;
  float _473;
  float _476;
  float _479;
  float _482;
  float _485;
  int _521;
  int _522;
  float _525;
  float _526;
  float _527;
  float _528;
  float _531;
  float _532;
  float _533;
  float _534;
  float _537;
  float _538;
  float _539;
  float _540;
  float _543;
  float _544;
  float _545;
  float _546;
  float _549;
  float _550;
  float _551;
  float _552;
  float _555;
  float _556;
  float _557;
  float _558;
  int _561;
  float _564;
  float _565;
  float _566;
  float _569;
  float _570;
  float _571;
  int _574;
  int _577;
  int _580;
  float _609;
  float _612;
  float _615;
  float _616;
  float4 _622;
  float4 _628;
  float _637;
  float _641;
  float _644;
  float _647;
  float _688;
  float _693;
  float _695;
  float _697;
  float _704;
  float _705;
  float4 _711;
  float4 _717;
  float _725;
  float4 _731;
  float4 _737;
  float _754;
  float _755;
  float _756;
  float _757;
  float _758;
  float _759;
  float _760;
  float _761;
  float _762;
  uint _810;
  bool _833;
  int _843;
  float _845;
  float _846;
  float _853;
  float _858;
  float _859;
  bool _860;
  float4 _865;
  float4 _871;
  float _882;
  float4 _887;
  float4 _893;
  float _931;
  int _951;
  float _952;
  float _955;
  float _956;
  bool _957;
  float4 _962;
  float4 _968;
  float _979;
  float4 _984;
  float4 _990;
  float _1018;
  float4 _1074;
  float _1077;
  float _1082;
  float _1084;
  float _1085;
  uint _1091;
  int _1094;
  int _1095;
  int _1099;
  int _1103;
  float _1115;
  float _1120;
  float _1121;
  float _1122;
  float _1123;
  float _1126;
  float _1127;
  float _1128;
  float _1129;
  float _1132;
  float _1133;
  float _1134;
  float _1135;
  int _1138;
  int _1141;
  int _1144;
  int _1147;
  float _1162;
  float _1166;
  float _1170;
  float _1195;
  float _1196;
  float _1197;
  float _1200;
  uint _1209;
  float _1215;
  float _1217;
  float _1219;
  int _1229;
  int _1232;
  int _1233;
  int _1234;
  int _1240;
  int _1241;
  int _1242;
  int _1248;
  int _1249;
  int _1250;
  float _1256;
  float _1260;
  float _1264;
  float _1271;
  int _1284;
  int _1287;
  int _1288;
  int _1289;
  int _1295;
  int _1296;
  int _1297;
  int _1303;
  int _1304;
  int _1305;
  float _1311;
  float _1315;
  float _1319;
  float _1326;
  float _1359;
  float _1363;
  float _1367;
  float _1386;
  float _1390;
  float _1394;
  float _1407;
  float _1408;
  float _1409;
  uint _1447;
  int _1459;
  int _1463;
  int _1464;
  int _1465;
  int _1466;
  int _1477;
  int _1481;
  float _1493;
  int _1496;
  float _1513;
  float _1518;
  float _1519;
  float _1520;
  float _1521;
  float _1524;
  float _1525;
  float _1526;
  float _1527;
  float _1530;
  float _1531;
  float _1532;
  float _1533;
  int _1536;
  int _1539;
  int _1542;
  int _1545;
  int _1548;
  float _1550;
  float _1551;
  float _1553;
  float _1557;
  float _1570;
  float _1574;
  float _1578;
  float _1603;
  float _1604;
  float _1605;
  float _1608;
  float _1609;
  float _1616;
  float _1637;
  float _1638;
  float _1639;
  float _1640;
  float _1643;
  float _1644;
  float _1645;
  float _1646;
  float _1649;
  float _1650;
  float _1651;
  float _1652;
  float _1655;
  float _1656;
  float _1657;
  float _1660;
  int _1663;
  int _1666;
  int _1669;
  int _1672;
  int _1675;
  float _1678;
  float _1679;
  float _1680;
  float _1681;
  int _1684;
  int _1687;
  int _1690;
  int _1693;
  int _1696;
  int _1699;
  int _1702;
  int _1705;
  float _1707;
  float _1708;
  float _1710;
  float _1714;
  float _1717;
  float _1719;
  int _1722;
  float _1732;
  float _1733;
  float _1735;
  float _1736;
  float _1737;
  float _1738;
  float _1754;
  float _1757;
  float _1761;
  float _1762;
  float _1763;
  float _1767;
  float _1771;
  float _1775;
  float _1776;
  float _1799;
  float _1800;
  float _1801;
  float _1804;
  float _1805;
  float _1812;
  float _1813;
  float _1814;
  float _1819;
  float _1821;
  float _1822;
  float _1825;
  float _1829;
  float _1838;
  float _1839;
  float _1840;
  int _1841;
  float _1846;
  float _1855;
  float _1856;
  float _1858;
  float4 _1863;
  float _1868;
  float _1870;
  float _1872;
  float _1874;
  float _1878;
  float _1880;
  float _1884;
  float _1886;
  int _1893;
  float _1898;
  float _1907;
  float _1908;
  float4 _1914;
  float _1919;
  float _1921;
  float _1925;
  float _1927;
  float _1931;
  float _1933;
  float _1937;
  float _1939;
  int _1946;
  float _1951;
  float _1960;
  float _1961;
  float4 _1967;
  float _1972;
  float _1974;
  float _1978;
  float _1980;
  float _1984;
  float _1986;
  float _1990;
  float _1992;
  int _1999;
  float _2004;
  float _2013;
  float _2014;
  float4 _2020;
  float _2025;
  float _2027;
  float _2031;
  float _2033;
  float _2037;
  float _2039;
  float _2043;
  float _2045;
  float _2046;
  float _2057;
  float _2063;
  float _2065;
  float _2067;
  float _2074;
  float _2082;
  float _2083;
  float _2092;
  float _2096;
  float _2105;
  float _2106;
  float _2107;
  float _2112;
  int _2113;
  float _2118;
  float _2127;
  float _2128;
  float _2130;
  float _2132;
  float _2133;
  float4 _2135;
  float _2139;
  float _2140;
  float _2143;
  float _2144;
  float _2149;
  float _2150;
  float _2153;
  float _2154;
  float _2156;
  float _2158;
  bool _2159;
  bool _2160;
  bool _2170;
  bool _2179;
  float _2196;
  float _2198;
  float _2200;
  float _2202;
  float _2206;
  float _2208;
  float _2212;
  float _2214;
  int _2221;
  float _2226;
  float _2235;
  float _2236;
  float _2239;
  float _2240;
  float4 _2242;
  float _2246;
  float _2247;
  float _2250;
  float _2251;
  float _2253;
  float _2255;
  bool _2256;
  bool _2257;
  bool _2267;
  bool _2276;
  float _2293;
  float _2295;
  float _2299;
  float _2301;
  float _2305;
  float _2307;
  float _2311;
  float _2313;
  int _2320;
  float _2325;
  float _2334;
  float _2335;
  float _2338;
  float _2339;
  float4 _2341;
  float _2345;
  float _2346;
  float _2349;
  float _2350;
  float _2352;
  float _2354;
  bool _2355;
  bool _2356;
  bool _2366;
  bool _2375;
  float _2392;
  float _2394;
  float _2398;
  float _2400;
  float _2404;
  float _2406;
  float _2410;
  float _2412;
  int _2419;
  float _2424;
  float _2433;
  float _2434;
  float _2437;
  float _2438;
  float4 _2440;
  float _2444;
  float _2445;
  float _2448;
  float _2449;
  float _2451;
  float _2453;
  bool _2454;
  bool _2455;
  bool _2465;
  bool _2474;
  float _2491;
  float _2493;
  float _2497;
  float _2499;
  float _2503;
  float _2505;
  float _2509;
  float _2511;
  float _2512;
  float _2523;
  float _2529;
  float _2531;
  float _2533;
  float _2553;
  float4 _2560;
  float _2574;
  float _2575;
  float _2576;
  float _2577;
  float _2579;
  float _2584;
  float _2587;
  float _2588;
  float _2590;
  float _2591;
  float _2596;
  float _2601;
  float _2603;
  float _2606;
  float _2607;
  float _2612;
  float _2614;
  float _2616;
  float _2618;
  float _2623;
  float _2629;
  float _2631;
  float3 _2657;
  float _2668;
  float4 _2689;
  int _2717;
  int _2722;
  int _2724;
  int _2725;
  int _2727;
  int _2728;
  int _2737;
  bool _2750;
  float _2753;
  float _2755;
  float _2756;
  float _2757;
  float _2758;
  float _2759;
  float _2760;
  float _2768;
  float _2773;
  float _2779;
  float _2783;
  float _2785;
  float _2786;
  float _2787;
  float _2790;
  bool _2797;
  float _2801;
  float _2803;
  float _2804;
  float _2812;
  float _2815;
  float _2816;
  float _2821;
  float _2830;
  float _2831;
  float _2834;
  float _2836;
  float _2837;
  float _2838;
  float _2840;
  float _2841;
  float _2842;
  float _2843;
  float _2848;
  float _2862;
  float _2867;
  float _2868;
  float _2870;
  float _2876;
  float _2879;
  float _2890;
  float _2891;
  float _2902;
  float _2917;
  float _2922;
  float _2923;
  float _2935;
  float _2938;
  float _2939;
  float _2940;
  float _2941;
  float _2958;
  float _2959;
  float _2984;
  float _2987;
  float _2992;
  float _2993;
  float _3007;
  float _3008;
  float _3009;
  float _3010;
  float _3013;
  float _3014;
  float _3015;
  float _3016;
  float _3019;
  float _3020;
  float _3021;
  int _3024;
  int _3027;
  int _3030;
  int _3033;
  int _3036;
  int _3039;
  float _3043;
  float _3046;
  float _3048;
  int _3050;
  float2 _3070;
  float3 _3087;
  float _3104;
  float _3107;
  float _3113;
  float _3117;
  float _3118;
  float _3119;
  float _3122;
  float _3125;
  float _3126;
  float _3127;
  float _3128;
  float _3129;
  float _3130;
  float _3138;
  float _3143;
  float _3149;
  float _3153;
  float _3155;
  float _3156;
  float _3157;
  float _3160;
  bool _3167;
  float _3171;
  float _3173;
  float _3174;
  float _3182;
  float _3185;
  float _3186;
  float _3191;
  float _3200;
  float _3201;
  float _3204;
  float _3206;
  float _3207;
  float _3208;
  float _3210;
  float _3211;
  float _3212;
  float _3213;
  float _3218;
  float _3232;
  float _3237;
  float _3238;
  float _3240;
  float _3246;
  float _3249;
  float _3260;
  float _3261;
  float _3272;
  float _3287;
  float _3299;
  float _3300;
  float _3312;
  float _3328;
  bool _3341;
  float _3342;
  float _3343;
  float _3344;
  bool _3345;
  float _3347;
  float _3348;
  float _3352;
  float _3358;
  float _3372;
  float _3373;
  float _3376;
  float _3380;
  int _3381;
  float _3383;
  float _3385;
  float _3388;
  float _3392;
  float _3403;
  float _3404;
  float _3405;
  float _3407;
  float _3421;
  float _3422;
  float _3423;
  float _3439;
  float _3440;
  float _3441;
  float _3445;
  float _3457;
  float _3458;
  float _3459;
  float _3462;
  float _3463;
  float _3464;
  float _3467;
  float _3468;
  float _3469;
  float _3472;
  float _3473;
  float _3474;
  float _3477;
  float _3478;
  float _3479;
  int _3482;
  int _3485;
  int _3488;
  int _3491;
  int _3494;
  int _3497;
  int _3500;
  int _3503;
  int _3506;
  int _3509;
  int _3512;
  float _3515;
  float _3516;
  float _3517;
  float _3518;
  int _3521;
  int _3524;
  int _3527;
  int _3530;
  float _3532;
  float _3533;
  float _3535;
  float _3539;
  float _3542;
  float _3543;
  float _3545;
  float _3549;
  float _3551;
  float _3552;
  float _3554;
  int _3557;
  bool _3561;
  float _3569;
  float _3570;
  float _3572;
  float _3575;
  float _3576;
  float _3578;
  float _3579;
  float _3581;
  float _3582;
  float _3586;
  float _3592;
  float _3593;
  float _3594;
  float _3605;
  float _3606;
  float _3607;
  float _3608;
  float _3609;
  float _3610;
  float _3611;
  float _3612;
  float _3613;
  float _3616;
  float _3617;
  float _3618;
  float _3621;
  float _3628;
  float _3638;
  float _3641;
  float _3645;
  float _3649;
  float _3650;
  float _3651;
  float _3654;
  float _3657;
  bool _3659;
  float _3665;
  float _3666;
  float _3667;
  float _3672;
  float _3673;
  float _3674;
  bool _3678;
  bool _3684;
  bool _3688;
  float _3698;
  float _3702;
  float _3711;
  float _3712;
  float _3719;
  float _3720;
  float _3723;
  float _3727;
  float _3736;
  float _3737;
  float _3738;
  float _3743;
  int _3744;
  float _3749;
  float _3758;
  float _3759;
  float _3761;
  float _3763;
  float _3764;
  float4 _3766;
  float _3770;
  float _3771;
  float _3774;
  float _3775;
  float _3780;
  float _3781;
  float _3784;
  float _3785;
  float _3787;
  float _3789;
  bool _3790;
  bool _3791;
  bool _3801;
  bool _3810;
  float _3827;
  float _3829;
  float _3831;
  float _3833;
  float _3837;
  float _3839;
  float _3843;
  float _3845;
  int _3852;
  float _3857;
  float _3866;
  float _3867;
  float _3870;
  float _3871;
  float4 _3873;
  float _3877;
  float _3878;
  float _3881;
  float _3882;
  float _3884;
  float _3886;
  bool _3887;
  bool _3888;
  bool _3898;
  bool _3907;
  float _3924;
  float _3926;
  float _3930;
  float _3932;
  float _3936;
  float _3938;
  float _3942;
  float _3944;
  int _3951;
  float _3956;
  float _3965;
  float _3966;
  float _3969;
  float _3970;
  float4 _3972;
  float _3976;
  float _3977;
  float _3980;
  float _3981;
  float _3983;
  float _3985;
  bool _3986;
  bool _3987;
  bool _3997;
  bool _4006;
  float _4023;
  float _4025;
  float _4029;
  float _4031;
  float _4035;
  float _4037;
  float _4041;
  float _4043;
  int _4050;
  float _4055;
  float _4064;
  float _4065;
  float _4068;
  float _4069;
  float4 _4071;
  float _4075;
  float _4076;
  float _4079;
  float _4080;
  float _4082;
  float _4084;
  bool _4085;
  bool _4086;
  bool _4096;
  bool _4105;
  float _4122;
  float _4124;
  float _4128;
  float _4130;
  float _4134;
  float _4136;
  float _4140;
  float _4142;
  float _4143;
  float _4154;
  float _4160;
  float _4162;
  float _4164;
  float _4173;
  float _4176;
  float _4177;
  float _4191;
  float _4192;
  float _4193;
  float _4197;
  float _4206;
  float _4207;
  float _4208;
  int _4209;
  float _4214;
  float _4223;
  float _4224;
  float _4226;
  float4 _4231;
  float _4236;
  float _4238;
  float _4240;
  float _4242;
  float _4246;
  float _4248;
  float _4252;
  float _4254;
  int _4261;
  float _4266;
  float _4275;
  float _4276;
  float4 _4282;
  float _4287;
  float _4289;
  float _4293;
  float _4295;
  float _4299;
  float _4301;
  float _4305;
  float _4307;
  int _4314;
  float _4319;
  float _4328;
  float _4329;
  float4 _4335;
  float _4340;
  float _4342;
  float _4346;
  float _4348;
  float _4352;
  float _4354;
  float _4358;
  float _4360;
  int _4367;
  float _4372;
  float _4381;
  float _4382;
  float4 _4388;
  float _4393;
  float _4395;
  float _4399;
  float _4401;
  float _4405;
  float _4407;
  float _4411;
  float _4413;
  float _4414;
  float _4425;
  float _4431;
  float _4433;
  float _4435;
  float _4443;
  float _4450;
  float _4452;
  float _4466;
  float _4467;
  float _4468;
  bool _4472;
  bool _4478;
  bool _4482;
  float _4492;
  float _4497;
  float _4506;
  float _4507;
  float _4512;
  float _4513;
  float _4516;
  float _4520;
  float _4529;
  float _4530;
  float _4531;
  float _4536;
  int _4537;
  float _4542;
  float _4551;
  float _4552;
  float _4554;
  float _4556;
  float _4557;
  float4 _4559;
  float _4563;
  float _4564;
  float _4567;
  float _4568;
  float _4573;
  float _4574;
  float _4577;
  float _4578;
  float _4580;
  float _4582;
  bool _4583;
  bool _4584;
  bool _4594;
  bool _4603;
  float _4620;
  float _4622;
  float _4624;
  float _4626;
  float _4630;
  float _4632;
  float _4636;
  float _4638;
  int _4645;
  float _4650;
  float _4659;
  float _4660;
  float _4663;
  float _4664;
  float4 _4666;
  float _4670;
  float _4671;
  float _4674;
  float _4675;
  float _4677;
  float _4679;
  bool _4680;
  bool _4681;
  bool _4691;
  bool _4700;
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
  float _4762;
  float _4763;
  float4 _4765;
  float _4769;
  float _4770;
  float _4773;
  float _4774;
  float _4776;
  float _4778;
  bool _4779;
  bool _4780;
  bool _4790;
  bool _4799;
  float _4816;
  float _4818;
  float _4822;
  float _4824;
  float _4828;
  float _4830;
  float _4834;
  float _4836;
  int _4843;
  float _4848;
  float _4857;
  float _4858;
  float _4861;
  float _4862;
  float4 _4864;
  float _4868;
  float _4869;
  float _4872;
  float _4873;
  float _4875;
  float _4877;
  bool _4878;
  bool _4879;
  bool _4889;
  bool _4898;
  float _4915;
  float _4917;
  float _4921;
  float _4923;
  float _4927;
  float _4929;
  float _4933;
  float _4935;
  float _4936;
  float _4947;
  float _4953;
  float _4955;
  float _4957;
  float _4966;
  float _4969;
  float _4970;
  float _4983;
  float _4984;
  float _4985;
  float _4989;
  float _4998;
  float _4999;
  float _5000;
  int _5001;
  float _5006;
  float _5015;
  float _5016;
  float _5018;
  float4 _5023;
  float _5028;
  float _5030;
  float _5032;
  float _5034;
  float _5038;
  float _5040;
  float _5044;
  float _5046;
  int _5053;
  float _5058;
  float _5067;
  float _5068;
  float4 _5074;
  float _5079;
  float _5081;
  float _5085;
  float _5087;
  float _5091;
  float _5093;
  float _5097;
  float _5099;
  int _5106;
  float _5111;
  float _5120;
  float _5121;
  float4 _5127;
  float _5132;
  float _5134;
  float _5138;
  float _5140;
  float _5144;
  float _5146;
  float _5150;
  float _5152;
  int _5159;
  float _5164;
  float _5173;
  float _5174;
  float4 _5180;
  float _5185;
  float _5187;
  float _5191;
  float _5193;
  float _5197;
  float _5199;
  float _5203;
  float _5205;
  float _5206;
  float _5217;
  float _5223;
  float _5225;
  float _5227;
  float _5235;
  float _5242;
  float _5244;
  float _5270;
  float _5272;
  float _5273;
  float _5274;
  float _5289;
  float _5292;
  float _5295;
  float _5297;
  float _5298;
  float _5299;
  float _5300;
  float _5308;
  float _5309;
  float _5310;
  bool _5312;
  float _5332;
  float4 _5357;
  float _5377;
  float _5378;
  float _5379;
  float _5380;
  float _5382;
  float _5387;
  float _5390;
  float _5391;
  float _5393;
  float _5394;
  float _5399;
  float _5404;
  float _5406;
  float _5409;
  float _5410;
  float _5415;
  float _5417;
  float _5419;
  float _5421;
  float _5426;
  float _5432;
  float _5434;
  float3 _5463;
  float4 _5494;
  float _5529;
  bool _5542;
  float _5543;
  float _5544;
  float _5545;
  bool _5546;
  float _5548;
  float _5549;
  float _5553;
  float _5559;
  float _5573;
  float _5574;
  float _5577;
  float _5581;
  int _5582;
  float _5584;
  float _5586;
  float _5589;
  float _5593;
  float _5604;
  float _5605;
  float _5606;
  float _5608;
  int _5628;
  int _5633;
  int _5635;
  int _5636;
  int _5638;
  int _5639;
  int _5648;
  bool _5661;
  float _5664;
  float _5666;
  float _5667;
  float _5668;
  float _5669;
  float _5670;
  float _5671;
  float _5672;
  float _5673;
  float _5674;
  float _5675;
  float _5676;
  float _5677;
  bool _5678;
  float _5679;
  float _5680;
  float _5683;
  float _5684;
  float _5686;
  float _5713;
  float _5718;
  float _5725;
  float _5726;
  float _5727;
  float _5729;
  float _5733;
  float _5734;
  float _5735;
  float _5736;
  float _5737;
  float _5738;
  float _5739;
  float _5745;
  float _5754;
  float _5758;
  float _5759;
  float _5760;
  float _5761;
  float _5765;
  float _5766;
  float _5767;
  float _5775;
  float _5787;
  float _5788;
  float _5789;
  float _5790;
  float _5791;
  float _5795;
  float _5797;
  float _5799;
  float _5803;
  float _5804;
  float _5805;
  float _5808;
  bool _5815;
  float _5819;
  float _5821;
  float _5822;
  float _5830;
  float _5833;
  float _5834;
  float _5839;
  float _5848;
  float _5849;
  float _5852;
  float _5854;
  float _5855;
  float _5856;
  float _5858;
  float _5859;
  float _5860;
  float _5861;
  float _5866;
  float _5880;
  float _5885;
  float _5886;
  float _5888;
  float _5894;
  float _5897;
  float _5908;
  float _5910;
  float _5929;
  float _5940;
  float _5957;
  float _5962;
  float _5963;
  float _5964;
  float _5976;
  float _5979;
  float _5980;
  float _5981;
  float _5982;
  float _6000;
  float _6001;
  float _6026;
  float _6029;
  float _6034;
  float _6035;
  float _6050;
  float _6051;
  float _6052;
  float _6055;
  float _6056;
  float _6057;
  float _6060;
  int _6063;
  int _6066;
  int _6069;
  float _6078;
  float _6081;
  float _6084;
  float _6091;
  float _6096;
  float _6098;
  float _6100;
  float _6101;
  float _6102;
  float _6104;
  float _6105;
  float _6106;
  float _6109;
  float _6110;
  float _6111;
  float _6114;
  float _6121;
  int _6130;
  int _6135;
  int _6137;
  int _6138;
  int _6140;
  int _6141;
  int _6150;
  bool _6163;
  float _6165;
  float _6166;
  float _6167;
  float _6168;
  float _6171;
  float _6174;
  float _6175;
  float _6176;
  float _6177;
  float _6181;
  float _6186;
  float _6187;
  float _6188;
  float _6200;
  float _6202;
  float _6203;
  float _6204;
  float _6205;
  float _6212;
  float _6213;
  float _6214;
  float _6226;
  float _6229;
  float _6250;
  float _6251;
  float _6252;
  float _6255;
  float _6256;
  float _6257;
  float _6260;
  float _6261;
  float _6262;
  float _6265;
  float _6266;
  float _6267;
  float _6270;
  float _6271;
  float _6272;
  float _6275;
  float _6276;
  float _6277;
  int _6280;
  int _6283;
  int _6286;
  int _6289;
  float _6292;
  float _6293;
  float _6294;
  float _6295;
  int _6298;
  int _6301;
  int _6304;
  int _6307;
  int _6310;
  int _6313;
  int _6316;
  float _6319;
  float _6320;
  float _6321;
  float _6322;
  int _6325;
  int _6328;
  int _6331;
  float _6333;
  float _6334;
  float _6336;
  float _6340;
  float _6343;
  float _6344;
  float _6346;
  float _6350;
  int _6354;
  float _6370;
  float _6371;
  float _6373;
  float _6374;
  float _6375;
  float _6376;
  float _6377;
  float _6378;
  float _6379;
  float _6380;
  float _6381;
  float _6382;
  float _6383;
  float _6384;
  float _6385;
  float _6388;
  float _6389;
  float _6390;
  float _6393;
  float _6404;
  float _6405;
  float _6408;
  float _6415;
  float _6416;
  float _6417;
  float _6429;
  float _6430;
  float _6431;
  float _6432;
  float _6435;
  float _6436;
  float _6439;
  float _6440;
  float _6447;
  float _6449;
  float _6455;
  bool _6457;
  float _6465;
  float _6466;
  float _6467;
  float _6472;
  float _6474;
  float _6475;
  float _6478;
  float _6482;
  float _6491;
  float _6492;
  float _6493;
  int _6494;
  float _6499;
  float _6508;
  float _6509;
  float _6511;
  float4 _6516;
  float _6521;
  float _6523;
  float _6525;
  float _6527;
  float _6531;
  float _6533;
  float _6537;
  float _6539;
  int _6546;
  float _6551;
  float _6560;
  float _6561;
  float4 _6567;
  float _6572;
  float _6574;
  float _6578;
  float _6580;
  float _6584;
  float _6586;
  float _6590;
  float _6592;
  int _6599;
  float _6604;
  float _6613;
  float _6614;
  float4 _6620;
  float _6625;
  float _6627;
  float _6631;
  float _6633;
  float _6637;
  float _6639;
  float _6643;
  float _6645;
  int _6652;
  float _6657;
  float _6666;
  float _6667;
  float4 _6673;
  float _6678;
  float _6680;
  float _6684;
  float _6686;
  float _6690;
  float _6692;
  float _6696;
  float _6698;
  float _6699;
  float _6710;
  float _6716;
  float _6718;
  float _6720;
  float _6727;
  float _6735;
  float _6736;
  float _6745;
  float _6749;
  float _6758;
  float _6759;
  float _6760;
  float _6765;
  int _6766;
  float _6771;
  float _6780;
  float _6781;
  float _6783;
  float _6785;
  float _6786;
  float4 _6788;
  float _6792;
  float _6793;
  float _6796;
  float _6797;
  float _6802;
  float _6803;
  float _6806;
  float _6807;
  float _6809;
  float _6811;
  bool _6812;
  bool _6813;
  bool _6823;
  bool _6832;
  float _6849;
  float _6851;
  float _6853;
  float _6855;
  float _6859;
  float _6861;
  float _6865;
  float _6867;
  int _6874;
  float _6879;
  float _6888;
  float _6889;
  float _6892;
  float _6893;
  float4 _6895;
  float _6899;
  float _6900;
  float _6903;
  float _6904;
  float _6906;
  float _6908;
  bool _6909;
  bool _6910;
  bool _6920;
  bool _6929;
  float _6946;
  float _6948;
  float _6952;
  float _6954;
  float _6958;
  float _6960;
  float _6964;
  float _6966;
  int _6973;
  float _6978;
  float _6987;
  float _6988;
  float _6991;
  float _6992;
  float4 _6994;
  float _6998;
  float _6999;
  float _7002;
  float _7003;
  float _7005;
  float _7007;
  bool _7008;
  bool _7009;
  bool _7019;
  bool _7028;
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
  float _7090;
  float _7091;
  float4 _7093;
  float _7097;
  float _7098;
  float _7101;
  float _7102;
  float _7104;
  float _7106;
  bool _7107;
  bool _7108;
  bool _7118;
  bool _7127;
  float _7144;
  float _7146;
  float _7150;
  float _7152;
  float _7156;
  float _7158;
  float _7162;
  float _7164;
  float _7165;
  float _7176;
  float _7182;
  float _7184;
  float _7186;
  float _7207;
  float4 _7214;
  float _7228;
  float _7229;
  float _7230;
  float _7231;
  float _7233;
  float _7238;
  float _7241;
  float _7242;
  float _7244;
  float _7245;
  float _7250;
  float _7255;
  float _7257;
  float _7260;
  float _7261;
  float _7266;
  float _7268;
  float _7270;
  float _7272;
  float _7277;
  float _7283;
  float _7285;
  float3 _7312;
  float _7323;
  float4 _7344;
  float _7382;
  bool _7395;
  float _7396;
  float _7397;
  float _7398;
  bool _7399;
  float _7401;
  float _7402;
  float _7406;
  float _7412;
  float _7426;
  float _7427;
  float _7430;
  float _7434;
  int _7435;
  float _7437;
  float _7439;
  float _7442;
  float _7446;
  float _7457;
  float _7458;
  float _7459;
  float _7461;
  int _7481;
  int _7486;
  int _7488;
  int _7489;
  int _7491;
  int _7492;
  int _7501;
  bool _7514;
  float _7517;
  float _7519;
  float _7520;
  float _7521;
  float _7522;
  float _7523;
  float _7524;
  float _7525;
  float _7526;
  float _7527;
  float _7528;
  float _7529;
  float _7530;
  bool _7531;
  float _7532;
  float _7533;
  float _7536;
  float _7537;
  float _7539;
  float _7566;
  float _7571;
  float _7578;
  float _7579;
  float _7580;
  float _7582;
  float _7586;
  float _7587;
  float _7588;
  float _7589;
  float _7590;
  float _7591;
  float _7592;
  float _7598;
  float _7607;
  float _7611;
  float _7612;
  float _7613;
  float _7614;
  float _7618;
  float _7619;
  float _7620;
  float _7628;
  float _7640;
  float _7641;
  float _7642;
  float _7643;
  float _7644;
  float _7648;
  float _7650;
  float _7652;
  float _7656;
  float _7657;
  float _7658;
  float _7661;
  bool _7668;
  float _7672;
  float _7674;
  float _7675;
  float _7683;
  float _7686;
  float _7687;
  float _7692;
  float _7701;
  float _7702;
  float _7705;
  float _7707;
  float _7708;
  float _7709;
  float _7711;
  float _7712;
  float _7713;
  float _7714;
  float _7719;
  float _7733;
  float _7738;
  float _7739;
  float _7741;
  float _7747;
  float _7750;
  float _7761;
  float _7763;
  float _7782;
  float _7793;
  float _7810;
  float _7815;
  float _7816;
  float _7817;
  float _7829;
  float _7832;
  float _7833;
  float _7834;
  float _7835;
  float _7853;
  float _7854;
  float _7879;
  float _7882;
  float _7887;
  float _7888;
  float _7903;
  float _7904;
  float _7905;
  float _7906;
  float _7909;
  float _7910;
  float _7911;
  float _7912;
  float _7915;
  float _7916;
  float _7917;
  float _7918;
  float _7921;
  float _7922;
  int _7925;
  int _7928;
  int _7931;
  int _7934;
  float _7937;
  float _7939;
  float _7940;
  float _7942;
  float _7946;
  float _7948;
  float _7952;
  float _7956;
  float _7960;
  float _7963;
  float _7966;
  float _7969;
  float _7981;
  float _7982;
  float _7983;
  float _7984;
  float _7985;
  float _7986;
  float _7987;
  float _7988;
  float _7989;
  float _7990;
  float _7991;
  float _7993;
  float _7995;
  float _7997;
  float _7999;
  float _8000;
  float _8006;
  float _8008;
  float _8015;
  float _8030;
  float _8032;
  float _8039;
  float _8049;
  float _8055;
  float _8057;
  float _8064;
  float _8081;
  float _8083;
  float _8090;
  float _8109;
  float _8110;
  float _8111;
  float _8112;
  float _8114;
  float _8116;
  float _8117;
  float _8118;
  float _8119;
  float _8120;
  float _8121;
  float _8122;
  float _8123;
  float _8125;
  float _8127;
  float _8128;
  float _8129;
  float _8130;
  float _8131;
  float _8132;
  float _8133;
  float _8135;
  float _8137;
  float _8144;
  bool _8157;
  float _8159;
  float _8165;
  float _8169;
  float _8171;
  float _8172;
  bool _8173;
  float _8175;
  float _8181;
  float _8182;
  float _8187;
  float _8188;
  float _8191;
  float _8193;
  float _8200;
  float _8213;
  float _8215;
  float _8222;
  float _8251;
  float _8252;
  float _8261;
  float _8270;
  float _8275;
  float _8284;
  float _8291;
  float _8294;
  float4 _8302;
  float _8304;
  float4 _8305;
  float _8314;
  float _8330;
  float _8331;
  float _8359;
  uint _8373;
  float _8384;
  float _8391;
  float _8401;
  float _8420;
  float _8423;
  float _8426;
  float4 _8447;
  float _8451;
  float _8452;
  float _8453;
  float _8455;
  float _8456;
  float _8457;
  float _8458;
  float _8459;
  float _8460;
  float _8461;
  float _8462;
  float _8463;
  float _8468;
  float _8473;
  float _8486;
  float4 _8494;
  float _8496;
  float _8503;
  bool _8536;
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
        _194 = rsqrt(dot(float3(_190, _191, _192), float3(_190, _191, _192)));
        _195 = _194 * _190;
        _196 = _194 * _191;
        _197 = _194 * _192;
        _206 = min(1.0f, max(saturate(_154.x), 0.019999999552965164f));
        _212 = _164 * _164;
        _213 = _165 * _165;
        _214 = _166 * _166;
        _220 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _117.x) - cbSharedPerViewData.vViewRemap.y);
        _221 = _220 * _134;
        _222 = _220 * _135;
        _223 = -0.0f - _220;
        _229 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
        _233 = srvReflectionsWeight.Load(int3(((uint)(_63) >> _229), ((uint)(_64) >> _229), 0));
        _239 = ((float)((uint)((uint)(_233.x & 254)))) * 0.003921568859368563f;
        do {
          _257 = 1.0f;
          _258 = 0.0f;
          _259 = 0.0f;
          _260 = 0.0f;
          if ((_233.x & 1) == 0) {
            _248 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _125), (cbSharedPerViewData.vViewportSize.y * _126)), 0.0f);
            _257 = (1.0f - _239);
            _258 = (_248.x * _239);
            _259 = (_248.y * _239);
            _260 = (_248.z * _239);
          }
          _269 = cbSharedPerViewData.vViewportSize.x * (_125 + 0.5f);
          _270 = cbSharedPerViewData.vViewportSize.y * (_126 + 0.5f);
          do {
            _350 = _269;
            _351 = _270;
            if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
              _285 = (floor((_269 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
              _286 = (floor((_270 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
              _289 = max(_285, cbDeferredShading.vScreenPixelSize.z);
              _290 = max(_286, cbDeferredShading.vScreenPixelSize.w);
              _293 = min((_285 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
              _294 = min((_286 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
              _299 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_289 + cbDeferredShading.vScreenPixelSize.z), (_290 + cbDeferredShading.vScreenPixelSize.w)));
              if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _299.x) - cbSharedPerViewData.vViewRemap.y)) - _220) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _299.y) - cbSharedPerViewData.vViewRemap.y)) - _220) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _299.z) - cbSharedPerViewData.vViewRemap.y)) - _220) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _299.w) - cbSharedPerViewData.vViewRemap.y)) - _220) > 0.029999999329447746f)) {
                _333 = abs(_117.x - _299.w);
                _335 = abs(_117.x - _299.z);
                _336 = (_335 < _333);
                _338 = select(_336, _335, _333);
                _340 = abs(_117.x - _299.x);
                _341 = (_340 < _338);
                if (abs(_117.x - _299.y) < select(_341, _340, _338)) {
                  _350 = _293;
                  _351 = _294;
                } else {
                  _350 = select(_341, _289, select(_336, _293, _289));
                  _351 = select(_341, _294, _290);
                }
              } else {
                _350 = _269;
                _351 = _270;
              }
            }
            _354 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_350, _351), 0.0f);
            _358 = _354.x - _354.z;
            _370 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_354.y + _358)), 0.0f);
            _371 = -0.0f - _370;
            _372 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_354.x + _354.z)), 0.0f);
            _373 = -0.0f - _372;
            _374 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_358 - _354.y)), 0.0f);
            _375 = -0.0f - _374;
            do {
              _389 = 1.0f;
              if (!(cbSharedPerViewData.nSSGIEnabled == 0)) {
                if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
                  _389 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_350, _351), 0.0f)).x);
                } else {
                  _389 = 1.0f;
                }
              }
              _390 = -0.0f - _134;
              _391 = -0.0f - _135;
              _393 = rsqrt(dot(float3(_390, _391, 1.0f), float3(_390, _391, 1.0f)));
              _394 = _393 * _390;
              _395 = _393 * _391;
              _403 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _64) + _63))];
              _404 = _403 & 255;
              _405 = (uint)(_403) >> 8;
              _406 = _405 & 255;
              _410 = ((float)((uint)((uint)(((uint)(_403) >> 16) & 255)))) * 0.003921568859368563f;
              _412 = (float)((uint)((uint)((uint)(_403) >> 24)));
              _413 = _412 * 0.003921568859368563f;
              do {
                _1032 = 0.0f;
                _1033 = 0.0f;
                _1034 = 0.0f;
                _1035 = 0.0f;
                _1036 = 0.0f;
                _1037 = 0.0f;
                [branch]
                if (!((((int)(uint((saturate(_142.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
                  _423 = _206 * 4.0f;
                  _428 = dot(float3((-0.0f - _394), (-0.0f - _395), (-0.0f - _393)), float3(_195, _196, _197)) * 2.0f;
                  _432 = _206 * _206;
                  _433 = 1.0f - _432;
                  _436 = (sqrt(_433) + _432) * _433;
                  _449 = (_436 * (((-0.0f - _195) - _394) - (_428 * _195))) + _195;
                  _450 = (_436 * (((-0.0f - _196) - _395) - (_428 * _196))) + _196;
                  _451 = (_436 * (((-0.0f - _197) - _393) - (_428 * _197))) + _197;
                  _455 = saturate(1.0f - ((_206 + -0.30000001192092896f) * 3.3333332538604736f));
                  _470 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _451, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _450, (_449 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
                  _473 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _451, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _450, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _449)));
                  _476 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _451, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _450, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _449)));
                  _479 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _197, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _196, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _195)));
                  _482 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _197, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _196, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _195)));
                  _485 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _197, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _196, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _195)));
                  do {
                    _814 = 0.0f;
                    _815 = 0.0f;
                    _816 = 0.0f;
                    _817 = 0.0f;
                    _818 = 0.0f;
                    _819 = 0.0f;
                    _820 = 0.0f;
                    _821 = 0.0f;
                    _822 = 0.0f;
                    _823 = 0.0f;
                    _824 = 0.0f;
                    _825 = 0.0f;
                    _826 = 0.0f;
                    _827 = 0.0f;
                    if (!(_global_0 == 0)) {
                      _504 = 0;
                      _505 = 0.0f;
                      _506 = 0.0f;
                      _507 = 0.0f;
                      _508 = 0.0f;
                      _509 = 0.0f;
                      _510 = 0.0f;
                      _511 = 0.0f;
                      _512 = 0.0f;
                      _513 = 0.0f;
                      _514 = 0.0f;
                      _515 = 0.0f;
                      _516 = 0.0f;
                      _517 = 0.0f;
                      _518 = 0.0f;
                      bool _loop_break_1 = false;
                      while (true) {
                        _521 = _global_5[min((uint)(_504), 63u)];
                        _522 = _global_6[min((uint)(_504), 63u)];
                        _525 = asfloat(srvLightInfoProperties.Load4(_522)).x;
                        _526 = asfloat(srvLightInfoProperties.Load4(_522)).y;
                        _527 = asfloat(srvLightInfoProperties.Load4(_522)).z;
                        _528 = asfloat(srvLightInfoProperties.Load4(_522)).w;
                        _531 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 16u)))).x;
                        _532 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 16u)))).y;
                        _533 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 16u)))).z;
                        _534 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 16u)))).w;
                        _537 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 32u)))).x;
                        _538 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 32u)))).y;
                        _539 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 32u)))).z;
                        _540 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 32u)))).w;
                        _543 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 48u)))).x;
                        _544 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 48u)))).y;
                        _545 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 48u)))).z;
                        _546 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 48u)))).w;
                        _549 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 64u)))).x;
                        _550 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 64u)))).y;
                        _551 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 64u)))).z;
                        _552 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 64u)))).w;
                        _555 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 80u)))).x;
                        _556 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 80u)))).y;
                        _557 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 80u)))).z;
                        _558 = asfloat(srvLightInfoProperties.Load4(((int)(_522 + 80u)))).w;
                        _561 = asint(srvLightInfoProperties.Load(((int)(_522 + 96u))));
                        _564 = asfloat(srvLightInfoProperties.Load3(((int)(_522 + 100u)))).x;
                        _565 = asfloat(srvLightInfoProperties.Load3(((int)(_522 + 100u)))).y;
                        _566 = asfloat(srvLightInfoProperties.Load3(((int)(_522 + 100u)))).z;
                        _569 = asfloat(srvLightInfoProperties.Load3(((int)(_522 + 112u)))).x;
                        _570 = asfloat(srvLightInfoProperties.Load3(((int)(_522 + 112u)))).y;
                        _571 = asfloat(srvLightInfoProperties.Load3(((int)(_522 + 112u)))).z;
                        _574 = asint(srvLightInfoProperties.Load(((int)(_522 + 124u))));
                        _577 = asint(srvLightInfoProperties.Load(((int)(_522 + 128u))));
                        _580 = _561 & 65535;
                        _609 = ((saturate(1.0f - abs(mad(_527, _223, mad(_526, _222, (_525 * _221))) + _528)) * f16tof32(((uint)((uint)(_561) >> 16)))) * saturate(1.0f - abs(mad(_533, _223, mad(_532, _222, (_531 * _221))) + _534))) * saturate(1.0f - abs(mad(_539, _223, mad(_538, _222, (_537 * _221))) + _540));
                        do {
                          _796 = _505;
                          _797 = _506;
                          _798 = _507;
                          _799 = _508;
                          _800 = _509;
                          _801 = _510;
                          _802 = _511;
                          _803 = _512;
                          _804 = _513;
                          _805 = _514;
                          _806 = _515;
                          _807 = _516;
                          _808 = _517;
                          _809 = _518;
                          [branch]
                          if (_609 > 0.0f) {
                            _612 = _609 * _609;
                            do {
                              _633 = 0.0f;
                              _634 = 0.0f;
                              _635 = 0.0f;
                              [branch]
                              if (_455 < 1.0f) {
                                _615 = (float)((uint)_580);
                                _616 = -0.0f - _470;
                                [branch]
                                if (!(!(_615 >= 341.0f))) {
                                  _622 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_616, _473, _476, (_615 + -341.0f)), _423);
                                  _633 = _622.x;
                                  _634 = _622.y;
                                  _635 = _622.z;
                                } else {
                                  _628 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_616, _473, _476, _615), _423);
                                  _633 = _628.x;
                                  _634 = _628.y;
                                  _635 = _628.z;
                                }
                              }
                              _637 = (float)((uint)_580);
                              do {
                                _722 = 0.0f;
                                _723 = 0.0f;
                                _724 = 0.0f;
                                [branch]
                                if (_455 > 0.0f) {
                                  _641 = mad(_545, _451, mad(_544, _450, (_543 * _449)));
                                  _644 = mad(_551, _451, mad(_550, _450, (_549 * _449)));
                                  _647 = mad(_557, _451, mad(_556, _450, (_555 * _449)));
                                  _688 = min(((((float((int)(((int)(uint)((int)(_641 > 0.0f))) - ((int)(uint)((int)(_641 < 0.0f))))) * _564) - _546) - mad(_545, _223, mad(_544, _222, (_543 * _221)))) / _641), min(((((float((int)(((int)(uint)((int)(_644 > 0.0f))) - ((int)(uint)((int)(_644 < 0.0f))))) * _565) - _552) - mad(_551, _223, mad(_550, _222, (_549 * _221)))) / _644), ((((float((int)(((int)(uint)((int)(_647 > 0.0f))) - ((int)(uint)((int)(_647 < 0.0f))))) * _566) - _558) - mad(_557, _223, mad(_556, _222, (_555 * _221)))) / _647)));
                                  _693 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _223, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _222, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _221))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _569) + (_688 * _470);
                                  _695 = ((mad((cbSharedPerViewData.mViewToWorld[0][1].z), _223, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _222, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _221))) + (cbSharedPerViewData.mViewToWorld[0][1].w)) - _570) + (_688 * _473);
                                  _697 = ((mad((cbSharedPerViewData.mViewToWorld[0][2].z), _223, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _222, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _221))) + (cbSharedPerViewData.mViewToWorld[0][2].w)) - _571) + (_688 * _476);
                                  _704 = (max(log2((_688 * _688) / dot(float3(_693, _695, _697), float3(_693, _695, _697))), -1.0f) * 0.3333333432674408f) + _423;
                                  _705 = -0.0f - _693;
                                  [branch]
                                  if (!(!(_637 >= 341.0f))) {
                                    _711 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_705, _695, _697, (_637 + -341.0f)), _704);
                                    _722 = _711.x;
                                    _723 = _711.y;
                                    _724 = _711.z;
                                  } else {
                                    _717 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_705, _695, _697, _637), _704);
                                    _722 = _717.x;
                                    _723 = _717.y;
                                    _724 = _717.z;
                                  }
                                }
                                _725 = -0.0f - _479;
                                do {
                                  [branch]
                                  if (!(!(_637 >= 341.0f))) {
                                    _731 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_725, _482, _485, (_637 + -341.0f)), 0.0f);
                                    _742 = _731.x;
                                    _743 = _731.y;
                                    _744 = _731.z;
                                  } else {
                                    _737 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_725, _482, _485, _637), 0.0f);
                                    _742 = _737.x;
                                    _743 = _737.y;
                                    _744 = _737.z;
                                  }
                                  _754 = _612 * f16tof32(((uint)((uint)(_574) >> 16)));
                                  _755 = _754 * _742;
                                  _756 = _612 * f16tof32(_574);
                                  _757 = _756 * _743;
                                  _758 = _612 * f16tof32(((uint)((uint)(_577) >> 16)));
                                  _759 = _758 * _744;
                                  _760 = _754 * (lerp(_633, _722, _455));
                                  _761 = _756 * (lerp(_634, _723, _455));
                                  _762 = _758 * (lerp(_635, _724, _455));
                                  do {
                                    _776 = _505;
                                    _777 = _506;
                                    _778 = _507;
                                    _779 = _508;
                                    _780 = _509;
                                    _781 = _510;
                                    _782 = _511;
                                    [branch]
                                    if (!((_521 & ((int)(1 << (_403 & 31)))) == 0)) {
                                      _776 = (_755 + _505);
                                      _777 = (_757 + _506);
                                      _778 = (_759 + _507);
                                      _779 = (_760 + _508);
                                      _780 = (_761 + _509);
                                      _781 = (_762 + _510);
                                      _782 = (_612 + _511);
                                    }
                                    [branch]
                                    if (!((_521 & ((int)(1 << (_405 & 31)))) == 0)) {
                                      _796 = _776;
                                      _797 = _777;
                                      _798 = _778;
                                      _799 = _779;
                                      _800 = _780;
                                      _801 = _781;
                                      _802 = _782;
                                      _803 = (_755 + _512);
                                      _804 = (_757 + _513);
                                      _805 = (_759 + _514);
                                      _806 = (_760 + _515);
                                      _807 = (_761 + _516);
                                      _808 = (_762 + _517);
                                      _809 = (_612 + _518);
                                    } else {
                                      _796 = _776;
                                      _797 = _777;
                                      _798 = _778;
                                      _799 = _779;
                                      _800 = _780;
                                      _801 = _781;
                                      _802 = _782;
                                      _803 = _512;
                                      _804 = _513;
                                      _805 = _514;
                                      _806 = _515;
                                      _807 = _516;
                                      _808 = _517;
                                      _809 = _518;
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
                          _810 = _504 + 1u;
                          do {
                            if (!(_810 == _global_0)) {
                              _504 = _810;
                              _505 = _796;
                              _506 = _797;
                              _507 = _798;
                              _508 = _799;
                              _509 = _800;
                              _510 = _801;
                              _511 = _802;
                              _512 = _803;
                              _513 = _804;
                              _514 = _805;
                              _515 = _806;
                              _516 = _807;
                              _517 = _808;
                              _518 = _809;
                              _loop_break_1 = true;
                              break;
                            }
                            _814 = _796;
                            _815 = _797;
                            _816 = _798;
                            _817 = _799;
                            _818 = _800;
                            _819 = _801;
                            _820 = _802;
                            _821 = _803;
                            _822 = _804;
                            _823 = _805;
                            _824 = _806;
                            _825 = _807;
                            _826 = _808;
                            _827 = _809;
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
                    _833 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_403 & 31)))) != 0);
                    do {
                      _939 = 0.0f;
                      _940 = 0.0f;
                      _941 = 0.0f;
                      _942 = 0.0f;
                      _943 = 0.0f;
                      _944 = 0.0f;
                      if ((_410 > 0.0f) || ((_413 > 0.0f) || _833)) {
                        _843 = srvFallbackInfo[((_404 << 2) | 3)].x;
                        _845 = select(_833, 9.999999747378752e-05f, (_412 * 3.921568847431445e-09f));
                        _846 = _820 * 0.20000000298023224f;
                        _853 = saturate((_845 - _846) / (((_820 * 0.4000000059604645f) + 9.99999993922529e-09f) - _846)) * _845;
                        do {
                          _919 = _820;
                          _920 = _817;
                          _921 = _818;
                          _922 = _819;
                          _923 = _814;
                          _924 = _815;
                          _925 = _816;
                          [branch]
                          if (_853 > 0.0f) {
                            do {
                              _911 = _817;
                              _912 = _818;
                              _913 = _819;
                              _914 = _814;
                              _915 = _815;
                              _916 = _816;
                              [branch]
                              if ((int)_843 > (int)-1) {
                                _858 = float((int)(_843));
                                _859 = -0.0f - _470;
                                _860 = !(_858 >= 341.0f);
                                do {
                                  [branch]
                                  if (!(_860)) {
                                    _865 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_859, _473, _476, (_858 + -341.0f)), _423);
                                    _876 = _865.x;
                                    _877 = _865.y;
                                    _878 = _865.z;
                                  } else {
                                    _871 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_859, _473, _476, _858), _423);
                                    _876 = _871.x;
                                    _877 = _871.y;
                                    _878 = _871.z;
                                  }
                                  _882 = -0.0f - _479;
                                  do {
                                    [branch]
                                    if (!(_860)) {
                                      _887 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_882, _482, _485, (_858 + -341.0f)), 0.0f);
                                      _898 = _887.x;
                                      _899 = _887.y;
                                      _900 = _887.z;
                                    } else {
                                      _893 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_882, _482, _485, _858), 0.0f);
                                      _898 = _893.x;
                                      _899 = _893.y;
                                      _900 = _893.z;
                                    }
                                    _911 = ((_876 * _853) + _817);
                                    _912 = ((_877 * _853) + _818);
                                    _913 = ((_878 * _853) + _819);
                                    _914 = ((_898 * _853) + _814);
                                    _915 = ((_899 * _853) + _815);
                                    _916 = ((_900 * _853) + _816);
                                  } while (false);
                                } while (false);
                              }
                              _919 = (_853 + _820);
                              _920 = _911;
                              _921 = _912;
                              _922 = _913;
                              _923 = _914;
                              _924 = _915;
                              _925 = _916;
                            } while (false);
                          }
                          if (_919 > 0.0f) {
                            _931 = (cbSharedPerViewData.vHDRScale.x * _410) / _919;
                            _939 = (_931 * _923);
                            _940 = (_931 * _924);
                            _941 = (_931 * _925);
                            _942 = (_931 * _920);
                            _943 = (_931 * _921);
                            _944 = (_931 * _922);
                          } else {
                            _939 = 0.0f;
                            _940 = 0.0f;
                            _941 = 0.0f;
                            _942 = 0.0f;
                            _943 = 0.0f;
                            _944 = 0.0f;
                          }
                        } while (false);
                      }
                      [branch]
                      if (!(_413 == 0.0f)) {
                        _951 = srvFallbackInfo[((_406 << 2) | 3)].x;
                        _952 = _412 * 3.921568847431445e-09f;
                        do {
                          _1008 = _824;
                          _1009 = _825;
                          _1010 = _826;
                          _1011 = _821;
                          _1012 = _822;
                          _1013 = _823;
                          [branch]
                          if ((int)_951 > (int)-1) {
                            _955 = float((int)(_951));
                            _956 = -0.0f - _470;
                            _957 = !(_955 >= 341.0f);
                            do {
                              [branch]
                              if (!(_957)) {
                                _962 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_956, _473, _476, (_955 + -341.0f)), _423);
                                _973 = _962.x;
                                _974 = _962.y;
                                _975 = _962.z;
                              } else {
                                _968 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_956, _473, _476, _955), _423);
                                _973 = _968.x;
                                _974 = _968.y;
                                _975 = _968.z;
                              }
                              _979 = -0.0f - _479;
                              do {
                                [branch]
                                if (!(_957)) {
                                  _984 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_979, _482, _485, (_955 + -341.0f)), 0.0f);
                                  _995 = _984.x;
                                  _996 = _984.y;
                                  _997 = _984.z;
                                } else {
                                  _990 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_979, _482, _485, _955), 0.0f);
                                  _995 = _990.x;
                                  _996 = _990.y;
                                  _997 = _990.z;
                                }
                                _1008 = ((_973 * _952) + _824);
                                _1009 = ((_974 * _952) + _825);
                                _1010 = ((_975 * _952) + _826);
                                _1011 = ((_995 * _952) + _821);
                                _1012 = ((_996 * _952) + _822);
                                _1013 = ((_997 * _952) + _823);
                              } while (false);
                            } while (false);
                          }
                          _1018 = (cbSharedPerViewData.vHDRScale.x * _413) / (_827 + _952);
                          _1032 = ((_1018 * _1011) + _939);
                          _1033 = ((_1018 * _1012) + _940);
                          _1034 = ((_1018 * _1013) + _941);
                          _1035 = ((_1018 * _1008) + _942);
                          _1036 = ((_1018 * _1009) + _943);
                          _1037 = ((_1018 * _1010) + _944);
                        } while (false);
                      } else {
                        _1032 = _939;
                        _1033 = _940;
                        _1034 = _941;
                        _1035 = _942;
                        _1036 = _943;
                        _1037 = _944;
                      }
                    } while (false);
                  } while (false);
                }
                do {
                  _1056 = _1035;
                  _1057 = _1036;
                  _1058 = _1037;
                  [branch]
                  if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
                    _1056 = (min((_371 / max(9.999999747378752e-05f, _1032)), 1.0f) * _1035);
                    _1057 = (min((_373 / max(9.999999747378752e-05f, _1033)), 1.0f) * _1036);
                    _1058 = (min((_375 / max(9.999999747378752e-05f, _1034)), 1.0f) * _1037);
                  }
                  _1074 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(saturate(dot(float3(_394, _395, _393), float3(_195, _196, _197))), _206), 0.0f);
                  _1077 = _1074.x + _1074.y;
                  _1082 = (((1.0f - _1077) * 0.03999999910593033f) / max(9.999999747378752e-06f, _1077)) + 1.0f;
                  _1084 = (_1074.x * 0.03999999910593033f) + _1074.y;
                  _1085 = min(select((cbSharedPerViewData.nPathTracingIsEnabled == 0), (_169 * _169), 1.0f), _389);
                  do {
                    _1213 = _1085;
                    if (!(_global_1 == 0)) {
                      _1089 = 0;
                      _1090 = _1085;
                      bool _loop_break_2 = false;
                      while (true) {
                        _1091 = _1089 + (uint)(_global_0);
                        _1094 = _global_5[min((uint)(_1091), 63u)];
                        _1095 = _global_6[min((uint)(_1091), 63u)];
                        _1099 = (int)((int)(_1094 << (((int)(31u - _403)) & 31))) >> 31;
                        _1103 = (int)((int)(_1094 << ((31 - _405) & 31))) >> 31;
                        _1115 = saturate((asfloat((_1099 & asint(_410))) + asfloat((_1103 & asint(_413)))) + asfloat(((_1103 & 1065353216) & _1099)));
                        do {
                          _1208 = _1090;
                          [branch]
                          if (!(_1115 == 0.0f)) {
                            _1120 = asfloat(srvLightInfoProperties.Load4(_1095)).x;
                            _1121 = asfloat(srvLightInfoProperties.Load4(_1095)).y;
                            _1122 = asfloat(srvLightInfoProperties.Load4(_1095)).z;
                            _1123 = asfloat(srvLightInfoProperties.Load4(_1095)).w;
                            _1126 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 16u)))).x;
                            _1127 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 16u)))).y;
                            _1128 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 16u)))).z;
                            _1129 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 16u)))).w;
                            _1132 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 32u)))).x;
                            _1133 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 32u)))).y;
                            _1134 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 32u)))).z;
                            _1135 = asfloat(srvLightInfoProperties.Load4(((int)(_1095 + 32u)))).w;
                            _1138 = asint(srvLightInfoProperties.Load(((int)(_1095 + 48u))));
                            _1141 = asint(srvLightInfoProperties.Load(((int)(_1095 + 52u))));
                            _1144 = asint(srvLightInfoProperties.Load(((int)(_1095 + 56u))));
                            _1147 = asint(srvLightInfoProperties.Load(((int)(_1095 + 60u))));
                            _1162 = mad(_1122, _223, mad(_1121, _222, (_1120 * _221))) + _1123;
                            _1166 = mad(_1128, _223, mad(_1127, _222, (_1126 * _221))) + _1129;
                            _1170 = mad(_1134, _223, mad(_1133, _222, (_1132 * _221))) + _1135;
                            _1195 = saturate(1.0f - ((_1162 + 1.0f) * f16tof32(_1141))) + saturate(1.0f - ((1.0f - _1162) * f16tof32(((uint)((uint)(_1141) >> 16)))));
                            _1196 = saturate(1.0f - ((_1166 + 1.0f) * f16tof32(_1144))) + saturate(1.0f - ((1.0f - _1166) * f16tof32(((uint)((uint)(_1144) >> 16)))));
                            _1197 = saturate(1.0f - ((_1170 + 1.0f) * f16tof32(_1147))) + saturate(1.0f - ((1.0f - _1170) * f16tof32(((uint)((uint)(_1147) >> 16)))));
                            _1200 = saturate(1.0f - dot(float3(_1195, _1196, _1197), float3(_1195, _1196, _1197)));
                            _1208 = (saturate(1.0f - ((_1200 * _1200) * (f16tof32(((uint)((uint)(_1138) >> 16))) * _1115))) * _1090);
                          }
                          _1209 = _1089 + 1u;
                          do {
                            if (!(_1209 == _global_1)) {
                              _1089 = _1209;
                              _1090 = _1208;
                              _loop_break_2 = true;
                              break;
                            }
                            _1213 = _1208;
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
                    _1215 = (_1082 * ((cbSharedPerViewData.vHDRScale.x * _258) + (_1056 * _257))) * _1084;
                    _1217 = (_1084 * ((cbSharedPerViewData.vHDRScale.x * _259) + (_1057 * _257))) * _1082;
                    _1219 = (_1084 * ((cbSharedPerViewData.vHDRScale.x * _260) + (_1058 * _257))) * _1082;
                    do {
                      _1226 = 1.0f;
                      [branch]
                      if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
                        _1226 = _1213;
                      }
                      do {
                        _1279 = _371;
                        _1280 = _373;
                        _1281 = _375;
                        if (_410 > 0.0f) {
                          _1229 = _404 * 3;
                          _1232 = srvRoomInfo[_1229].x;
                          _1233 = srvRoomInfo[_1229].y;
                          _1234 = srvRoomInfo[_1229].z;
                          _1240 = srvRoomInfo[(_1229 + 1)].x;
                          _1241 = srvRoomInfo[(_1229 + 1)].y;
                          _1242 = srvRoomInfo[(_1229 + 1)].z;
                          _1248 = srvRoomInfo[(_1229 + 2)].x;
                          _1249 = srvRoomInfo[(_1229 + 2)].y;
                          _1250 = srvRoomInfo[(_1229 + 2)].z;
                          _1256 = saturate(dot(float3(_195, _196, _197), float3(asfloat(_1232), asfloat(_1233), asfloat(_1234))) + 0.5f);
                          _1260 = (_1256 * _1256) * (3.0f - (_1256 * 2.0f));
                          _1264 = 1.0f - _1260;
                          _1271 = _1226 * _410;
                          _1279 = ((_1271 * ((_1264 * asfloat(_1248)) + (_1260 * asfloat(_1240)))) - _370);
                          _1280 = ((_1271 * ((_1264 * asfloat(_1249)) + (_1260 * asfloat(_1241)))) - _372);
                          _1281 = ((_1271 * ((_1264 * asfloat(_1250)) + (_1260 * asfloat(_1242)))) - _374);
                        }
                        do {
                          _1334 = _1279;
                          _1335 = _1280;
                          _1336 = _1281;
                          if (_413 > 0.0f) {
                            _1284 = _406 * 3;
                            _1287 = srvRoomInfo[_1284].x;
                            _1288 = srvRoomInfo[_1284].y;
                            _1289 = srvRoomInfo[_1284].z;
                            _1295 = srvRoomInfo[(_1284 + 1)].x;
                            _1296 = srvRoomInfo[(_1284 + 1)].y;
                            _1297 = srvRoomInfo[(_1284 + 1)].z;
                            _1303 = srvRoomInfo[(_1284 + 2)].x;
                            _1304 = srvRoomInfo[(_1284 + 2)].y;
                            _1305 = srvRoomInfo[(_1284 + 2)].z;
                            _1311 = saturate(dot(float3(_195, _196, _197), float3(asfloat(_1287), asfloat(_1288), asfloat(_1289))) + 0.5f);
                            _1315 = (_1311 * _1311) * (3.0f - (_1311 * 2.0f));
                            _1319 = 1.0f - _1315;
                            _1326 = _1226 * _413;
                            _1334 = ((_1326 * ((_1319 * asfloat(_1303)) + (_1315 * asfloat(_1295)))) + _1279);
                            _1335 = ((_1326 * ((_1319 * asfloat(_1304)) + (_1315 * asfloat(_1296)))) + _1280);
                            _1336 = ((_1326 * ((_1319 * asfloat(_1305)) + (_1315 * asfloat(_1297)))) + _1281);
                          }
                          do {
                            _1446 = 0.0f;
                            if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
                              _1359 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _223, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _222, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _221))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
                              _1363 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _223, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _222, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _221))) + (cbSharedPerViewData.mViewToWorld[0][1].w);
                              _1367 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _223, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _222, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _221))) + (cbSharedPerViewData.mViewToWorld[0][2].w);
                              _1386 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1367, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1363, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1359))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
                              _1390 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1367, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1363, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1359))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
                              _1394 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1367, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1363, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1359))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
                              _1407 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
                              _1408 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
                              _1409 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
                              _1446 = min(min(saturate((_1386 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1407), 9.999999747378752e-06f)), saturate((1.0f - _1386) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1407), 9.999999747378752e-06f))), min(min(saturate((_1390 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1408), 9.999999747378752e-06f)), saturate((1.0f - _1390) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1408), 9.999999747378752e-06f))), min(saturate((_1394 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1409), 9.999999747378752e-06f)), saturate((1.0f - _1394) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1409), 9.999999747378752e-06f)))));
                            }
                            _1447 = (uint)(_global_1) + (uint)(_global_0);
                            do {
                              _8377 = _1334;
                              _8378 = _1335;
                              _8379 = _1336;
                              _8380 = _1215;
                              _8381 = _1217;
                              _8382 = _1219;
                              if ((uint)_1447 < (uint)_global_2) {
                                _1451 = _1334;
                                _1452 = _1335;
                                _1453 = _1336;
                                _1454 = _1215;
                                _1455 = _1217;
                                _1456 = _1219;
                                _1457 = _1447;
                                bool _loop_break_3 = false;
                                while (true) {
                                  _1459 = _global_3[min((uint)(_1457), 63u)];
                                  _1463 = _global_4[min((uint)(_1457), 63u)];
                                  _1464 = _global_5[min((uint)(_1457), 63u)];
                                  _1465 = _global_6[min((uint)(_1457), 63u)];
                                  _1466 = _1459 & 4095;
                                  do {
                                    _8367 = _1451;
                                    _8368 = _1452;
                                    _8369 = _1453;
                                    _8370 = _1454;
                                    _8371 = _1455;
                                    _8372 = _1456;
                                    [branch]
                                    if (((_1463 & 16777216) == 0) && ((((int)(uint(saturate(_154.w) * 255.0f)) & 64) != 0) || ((_1463 & 8388608) == 0))) {
                                      _1477 = (int)((int)(_1464 << (((int)(31u - _403)) & 31))) >> 31;
                                      _1481 = (int)((int)(_1464 << ((31 - _405) & 31))) >> 31;
                                      _1493 = saturate((asfloat((_1477 & asint(_410))) + asfloat((_1481 & asint(_413)))) + asfloat(((_1481 & 1065353216) & _1477)));
                                      [branch]
                                      if (!(_1493 == 0.0f)) {
                                        _1496 = (uint)(_1459) >> 12;
                                        if (_1496 == 6) {
                                          do {
                                            _3004 = _1493;
                                            if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                                              _3004 = (_1493 * select(((_1463 & 67108864) != 0), 1.0f, (1.0f - _1446)));
                                            }
                                            _3007 = asfloat(srvLightInfoProperties.Load4(_1465)).x;
                                            _3008 = asfloat(srvLightInfoProperties.Load4(_1465)).y;
                                            _3009 = asfloat(srvLightInfoProperties.Load4(_1465)).z;
                                            _3010 = asfloat(srvLightInfoProperties.Load4(_1465)).w;
                                            _3013 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).x;
                                            _3014 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).y;
                                            _3015 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).z;
                                            _3016 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).w;
                                            _3019 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).x;
                                            _3020 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).y;
                                            _3021 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).z;
                                            _3024 = asint(srvLightInfoProperties.Load(((int)(_1465 + 68u))));
                                            _3027 = asint(srvLightInfoProperties.Load(((int)(_1465 + 72u))));
                                            _3030 = asint(srvLightInfoProperties.Load(((int)(_1465 + 76u))));
                                            _3033 = asint(srvLightInfoProperties.Load(((int)(_1465 + 84u))));
                                            _3036 = asint(srvLightInfoProperties.Load(((int)(_1465 + 88u))));
                                            _3039 = asint(srvLightInfoProperties.Load(((int)(_1465 + 92u))));
                                            _3043 = ((float)((uint)((uint)(((uint)(_3024) >> 8) & 255)))) * 0.003921499941498041f;
                                            _3046 = ((float)((uint)((uint)(_3024 & 255)))) * 0.003921499941498041f;
                                            _3048 = f16tof32(((uint)((uint)(_3027) >> 16)));
                                            _3050 = (uint)(_3030) >> 16;
                                            _3070 = srvDeferredShadingPass_DeferredShadows.Load(int3(_63, _64, 0));
                                            [branch]
                                            if (!(_3070.x == 0.0f)) {
                                              do {
                                                _3095 = cbSharedPerViewData.vAttenuatedSunColor.x;
                                                _3096 = cbSharedPerViewData.vAttenuatedSunColor.y;
                                                _3097 = cbSharedPerViewData.vAttenuatedSunColor.z;
                                                [branch]
                                                if (!(_3050 == 0)) {
                                                  Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3050)))];
                                                  _3087 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3009, _223, mad(_3008, _222, (_3007 * _221))) + _3010) * f16tof32(((uint)((uint)(_3036) >> 16)))) + f16tof32(((uint)((uint)(_3039) >> 16)))), (((mad(_3015, _223, mad(_3014, _222, (_3013 * _221))) + _3016) * f16tof32(_3036)) + f16tof32(_3039))), 0.0f);
                                                  _3095 = (_3087.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                                                  _3096 = (_3087.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                                                  _3097 = (_3087.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                                                }
                                                _3104 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_3019, _3020, _3021)));
                                                _3107 = 1.0f - ((_3104 * _3104) * 0.6399999856948853f);
                                                _3113 = ((0.36000001430511475f / (_3107 * _3107)) * _3004) * saturate(0.30000001192092896f - dot(float3(_195, _196, _197), float3(_3019, _3020, _3021)));
                                                _3117 = ((_167 * _212) * _3113) + _1454;
                                                _3118 = ((_167 * _213) * _3113) + _1455;
                                                _3119 = ((_214 * _167) * _3113) + _1456;
                                                _3122 = min(_3070.x, _3070.y) * _3004;
                                                [branch]
                                                if (_3122 > 0.0f) {
                                                  _3125 = dot(float3(_3019, _3020, _3021), float3(_3019, _3020, _3021));
                                                  _3126 = rsqrt(_3125);
                                                  _3127 = _3126 * _3019;
                                                  _3128 = _3126 * _3020;
                                                  _3129 = _3126 * _3021;
                                                  _3130 = dot(float3(_195, _196, _197), float3(_3127, _3128, _3129));
                                                  do {
                                                    _3148 = _3130;
                                                    if (_3048 > 0.0f) {
                                                      _3138 = sqrt(saturate((_3048 * _3048) * (1.0f / (_3125 + 1.0f))));
                                                      if (_3130 < _3138) {
                                                        _3143 = max(_3130, (-0.0f - _3138)) + _3138;
                                                        _3148 = ((_3143 * _3143) / (_3138 * 4.0f));
                                                      } else {
                                                        _3148 = _3130;
                                                      }
                                                    }
                                                    _3149 = _206 * _206;
                                                    _3153 = saturate((_3048 * (1.0f - _3149)) * _3126);
                                                    _3155 = saturate(_3126 * f16tof32(_3027));
                                                    _3156 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                    _3157 = dot(float3(_394, _395, _393), float3(_3127, _3128, _3129));
                                                    _3160 = rsqrt((_3157 * 2.0f) + 2.0f);
                                                    _3167 = (_3153 > 0.0f);
                                                    do {
                                                      _3258 = saturate((_3160 * _3157) + _3160);
                                                      _3259 = saturate(_3160 * (_3156 + _3130));
                                                      if (_3167) {
                                                        _3171 = sqrt(1.0f - (_3153 * _3153));
                                                        _3173 = (_3130 * 2.0f) * _3156;
                                                        _3174 = _3173 - _3157;
                                                        if (!(!(_3174 >= _3171))) {
                                                          _3258 = abs(_3156);
                                                          _3259 = 1.0f;
                                                        } else {
                                                          _3182 = rsqrt(1.0f - (_3174 * _3174)) * _3153;
                                                          _3185 = _3182 * (_3156 - (_3174 * _3130));
                                                          _3186 = _3156 * _3156;
                                                          _3191 = _3182 * (((_3186 * 2.0f) + -1.0f) - (_3174 * _3157));
                                                          _3200 = sqrt(saturate((((1.0f - (_3130 * _3130)) - _3186) - (_3157 * _3157)) + (_3173 * _3157)));
                                                          _3201 = _3200 * _3182;
                                                          _3204 = ((_3156 * 2.0f) * _3182) * _3200;
                                                          _3206 = (_3171 * _3130) + _3156;
                                                          _3207 = _3206 + _3185;
                                                          _3208 = _3171 * _3157;
                                                          _3210 = (_3208 + 1.0f) + _3191;
                                                          _3211 = _3201 * _3210;
                                                          _3212 = _3207 * _3210;
                                                          _3213 = _3204 * _3207;
                                                          _3218 = (((_3207 * 0.25f) * _3204) - (_3211 * 0.5f)) * _3212;
                                                          _3232 = (((_3213 - (_3211 * 2.0f)) * _3213) + (_3211 * _3211)) + ((((-0.5f - ((_3210 + _3208) * 0.5f)) * _3212) + ((_3210 * _3210) * _3206)) * _3207);
                                                          _3237 = (_3218 * 2.0f) / ((_3232 * _3232) + (_3218 * _3218));
                                                          _3238 = _3232 * _3237;
                                                          _3240 = 1.0f - (_3218 * _3237);
                                                          _3246 = ((_3238 * _3204) + _3208) + (_3240 * _3191);
                                                          _3249 = rsqrt((_3246 * 2.0f) + 2.0f);
                                                          _3258 = saturate((_3246 * _3249) + _3249);
                                                          _3259 = saturate(((_3206 + (_3238 * _3201)) + (_3240 * _3185)) * _3249);
                                                        }
                                                      }
                                                      _3260 = saturate(_3148);
                                                      _3261 = _3149 * _3149;
                                                      do {
                                                        _3271 = _3261;
                                                        if (_3155 > 0.0f) {
                                                          _3271 = saturate(((_3155 * _3155) / ((_3258 * 3.5999999046325684f) + 0.4000000059604645f)) + _3261);
                                                        }
                                                        _3272 = sqrt(_3271);
                                                        do {
                                                          _3283 = 1.0f;
                                                          if (_3167) {
                                                            _3283 = (_3271 / ((((_3153 * 0.25f) * ((_3272 * 3.0f) + _3153)) / (_3258 + 0.0010000000474974513f)) + _3271));
                                                          }
                                                          _3287 = (((_3271 * _3259) - _3259) * _3259) + 1.0f;
                                                          _3299 = saturate(abs(_3156) + 9.999999747378752e-06f);
                                                          _3300 = 1.0f - _3272;
                                                          _3312 = saturate((_3130 + _3046) / (_3046 + 1.0f));
                                                          do {
                                                            _3418 = _3095;
                                                            _3419 = _3096;
                                                            _3420 = _3097;
                                                            [branch]
                                                            if (!((_3033 & 1) == 0)) {
                                                              _3328 = max(max(_3095, _3096), _3097);
                                                              do {
                                                                _3338 = _3095;
                                                                _3339 = _3096;
                                                                _3340 = _3097;
                                                                if (_3328 > 0.0f) {
                                                                  _3338 = saturate(_3095 / _3328);
                                                                  _3339 = saturate(_3096 / _3328);
                                                                  _3340 = saturate(_3097 / _3328);
                                                                }
                                                                _3341 = (_3339 < _3340);
                                                                _3342 = select(_3341, _3340, _3339);
                                                                _3343 = select(_3341, _3339, _3340);
                                                                _3344 = select(_3341, -1.0f, 0.0f);
                                                                _3345 = (_3338 < _3342);
                                                                _3347 = select(_3345, _3342, _3338);
                                                                _3348 = select(_3345, _3338, _3342);
                                                                _3352 = _3347 - select((_3348 < _3343), _3348, _3343);
                                                                _3358 = abs(select(_3345, (-0.3333333432674408f - _3344), _3344) + ((_3348 - _3343) / ((_3352 * 6.0f) + 9.999999682655225e-21f)));
                                                                do {
                                                                  _3371 = _3358;
                                                                  if (_3358 < 0.6666666865348816f) {
                                                                    _3371 = ((saturate(((float)((uint)((uint)(((uint)(_3033) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3358 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3358)) + _3358);
                                                                  }
                                                                  _3372 = saturate((_3352 / (_3347 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3033) >> 1) & 255)))) * 0.003921499941498041f));
                                                                  _3373 = saturate(_3347);
                                                                  do {
                                                                    _3400 = _3373;
                                                                    _3401 = _3373;
                                                                    _3402 = _3373;
                                                                    if (!(_3372 <= 0.0f)) {
                                                                      _3376 = saturate(_3371);
                                                                      _3380 = select(((_3376 * 360.0f) >= 360.0f), 0.0f, (_3376 * 6.0f));
                                                                      _3381 = int(_3380);
                                                                      _3383 = _3380 - float((int)(_3381));
                                                                      _3385 = _3373 * (1.0f - _3372);
                                                                      _3388 = (1.0f - (_3383 * _3372)) * _3373;
                                                                      _3392 = (1.0f - ((1.0f - _3383) * _3372)) * _3373;
                                                                      switch (_3381) {
                                                                        case 0: {
                                                                          _3400 = _3373;
                                                                          _3401 = _3392;
                                                                          _3402 = _3385;
                                                                          break;
                                                                        }
                                                                        case 1: {
                                                                          _3400 = _3388;
                                                                          _3401 = _3373;
                                                                          _3402 = _3385;
                                                                          break;
                                                                        }
                                                                        case 2: {
                                                                          _3400 = _3385;
                                                                          _3401 = _3373;
                                                                          _3402 = _3392;
                                                                          break;
                                                                        }
                                                                        case 3: {
                                                                          _3400 = _3385;
                                                                          _3401 = _3388;
                                                                          _3402 = _3373;
                                                                          break;
                                                                        }
                                                                        case 4: {
                                                                          _3400 = _3392;
                                                                          _3401 = _3385;
                                                                          _3402 = _3373;
                                                                          break;
                                                                        }
                                                                        case 5: {
                                                                          _3400 = _3373;
                                                                          _3401 = _3385;
                                                                          _3402 = _3388;
                                                                          break;
                                                                        }
                                                                        default: {
                                                                          _3400 = 0.0f;
                                                                          _3401 = 0.0f;
                                                                          _3402 = 0.0f;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }
                                                                    _3403 = _3400 * _3328;
                                                                    _3404 = _3401 * _3328;
                                                                    _3405 = _3402 * _3328;
                                                                    _3407 = saturate(_3122 * 1.0101009607315063f);
                                                                    _3418 = ((_3407 * (_3095 - _3403)) + _3403);
                                                                    _3419 = ((_3407 * (_3096 - _3404)) + _3404);
                                                                    _3420 = (lerp(_3405, _3097, _3407));
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            _3421 = _3418 * _3122;
                                                            _3422 = _3419 * _3122;
                                                            _3423 = _3420 * _3122;
                                                            do {
                                                              _3433 = _3421;
                                                              _3434 = _3422;
                                                              _3435 = _3423;
                                                              if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                                                                _3433 = (_3421 * _1213);
                                                                _3434 = (_3422 * _1213);
                                                                _3435 = (_3423 * _1213);
                                                              }
                                                              _3439 = (_3433 * _3312) + _1451;
                                                              _3440 = (_3434 * _3312) + _1452;
                                                              _3441 = (_3435 * _3312) + _1453;
                                                              if (_3043 > 0.0f) {
                                                                _3445 = ((_3043 * _1082) * ((exp2(log2(1.0f - saturate(_3258)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f)) * (((_3283 * _3260) * (_3271 / (_3287 * _3287))) * (0.5f / ((((_3300 * _3299) + _3272) * _3260) + (((_3300 * _3260) + _3272) * _3299))));
                                                                _8367 = _3439;
                                                                _8368 = _3440;
                                                                _8369 = _3441;
                                                                _8370 = ((_3445 * _3433) + _3117);
                                                                _8371 = ((_3445 * _3434) + _3118);
                                                                _8372 = ((_3445 * _3435) + _3119);
                                                              } else {
                                                                _8367 = _3439;
                                                                _8368 = _3440;
                                                                _8369 = _3441;
                                                                _8370 = _3117;
                                                                _8371 = _3118;
                                                                _8372 = _3119;
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
                                                  _8367 = _1451;
                                                  _8368 = _1452;
                                                  _8369 = _1453;
                                                  _8370 = _3117;
                                                  _8371 = _3118;
                                                  _8372 = _3119;
                                                }
                                              } while (false);
                                              if (_loop_break_3) break;
                                            } else {
                                              _8367 = _1451;
                                              _8368 = _1452;
                                              _8369 = _1453;
                                              _8370 = _1454;
                                              _8371 = _1455;
                                              _8372 = _1456;
                                            }
                                          } while (false);
                                          if (_loop_break_3) break;
                                        } else {
                                          _1513 = _1493 * select(((_1463 & 67108864) != 0), 1.0f, (1.0f - _1446));
                                          [branch]
                                          if (_1496 == 4) {
                                            _1518 = asfloat(srvLightInfoProperties.Load4(_1465)).x;
                                            _1519 = asfloat(srvLightInfoProperties.Load4(_1465)).y;
                                            _1520 = asfloat(srvLightInfoProperties.Load4(_1465)).z;
                                            _1521 = asfloat(srvLightInfoProperties.Load4(_1465)).w;
                                            _1524 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).x;
                                            _1525 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).y;
                                            _1526 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).z;
                                            _1527 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).w;
                                            _1530 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).x;
                                            _1531 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).y;
                                            _1532 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).z;
                                            _1533 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).w;
                                            _1536 = asint(srvLightInfoProperties.Load(((int)(_1465 + 48u))));
                                            _1539 = asint(srvLightInfoProperties.Load(((int)(_1465 + 52u))));
                                            _1542 = asint(srvLightInfoProperties.Load(((int)(_1465 + 64u))));
                                            _1545 = asint(srvLightInfoProperties.Load(((int)(_1465 + 68u))));
                                            _1548 = asint(srvLightInfoProperties.Load(((int)(_1465 + 72u))));
                                            _1550 = f16tof32(((uint)((uint)(_1536) >> 16)));
                                            _1551 = f16tof32(_1536);
                                            _1553 = f16tof32(((uint)((uint)(_1539) >> 16)));
                                            _1557 = ((float)((uint)((uint)(((uint)(_1539) >> 8) & 255)))) * 0.003921499941498041f;
                                            _1570 = mad(_1520, _223, mad(_1519, _222, (_1518 * _221))) + _1521;
                                            _1574 = mad(_1526, _223, mad(_1525, _222, (_1524 * _221))) + _1527;
                                            _1578 = mad(_1532, _223, mad(_1531, _222, (_1530 * _221))) + _1533;
                                            _1603 = saturate(1.0f - ((_1570 + 1.0f) * f16tof32(_1542))) + saturate(1.0f - ((1.0f - _1570) * f16tof32(((uint)((uint)(_1542) >> 16)))));
                                            _1604 = saturate(1.0f - ((_1574 + 1.0f) * f16tof32(_1545))) + saturate(1.0f - ((1.0f - _1574) * f16tof32(((uint)((uint)(_1545) >> 16)))));
                                            _1605 = saturate(1.0f - ((_1578 + 1.0f) * f16tof32(_1548))) + saturate(1.0f - ((1.0f - _1578) * f16tof32(((uint)((uint)(_1548) >> 16)))));
                                            _1608 = saturate(1.0f - dot(float3(_1603, _1604, _1605), float3(_1603, _1604, _1605)));
                                            _1609 = _1608 * _1608;
                                            _1616 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1609 * _1213), _1609) * _1513;
                                            _8367 = ((_1616 * _1550) + _1451);
                                            _8368 = ((_1616 * _1551) + _1452);
                                            _8369 = ((_1616 * _1553) + _1453);
                                            _8370 = (((_1557 * _1550) * _1616) + _1454);
                                            _8371 = (((_1557 * _1551) * _1616) + _1455);
                                            _8372 = (((_1553 * _1557) * _1616) + _1456);
                                          } else {
                                            if (_1496 == 5) {
                                              _1637 = asfloat(srvLightInfoProperties.Load4(_1465)).x;
                                              _1638 = asfloat(srvLightInfoProperties.Load4(_1465)).y;
                                              _1639 = asfloat(srvLightInfoProperties.Load4(_1465)).z;
                                              _1640 = asfloat(srvLightInfoProperties.Load4(_1465)).w;
                                              _1643 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).x;
                                              _1644 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).y;
                                              _1645 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).z;
                                              _1646 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).w;
                                              _1649 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).x;
                                              _1650 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).y;
                                              _1651 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).z;
                                              _1652 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).w;
                                              _1655 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).x;
                                              _1656 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).y;
                                              _1657 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).z;
                                              _1660 = asfloat(srvLightInfoProperties.Load(((int)(_1465 + 60u))));
                                              _1663 = asint(srvLightInfoProperties.Load(((int)(_1465 + 64u))));
                                              _1666 = asint(srvLightInfoProperties.Load(((int)(_1465 + 68u))));
                                              _1669 = asint(srvLightInfoProperties.Load(((int)(_1465 + 80u))));
                                              _1672 = asint(srvLightInfoProperties.Load(((int)(_1465 + 84u))));
                                              _1675 = asint(srvLightInfoProperties.Load(((int)(_1465 + 88u))));
                                              _1678 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 92u)))).x;
                                              _1679 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 92u)))).y;
                                              _1680 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 92u)))).z;
                                              _1681 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 92u)))).w;
                                              _1684 = asint(srvLightInfoProperties.Load(((int)(_1465 + 108u))));
                                              _1687 = asint(srvLightInfoProperties.Load(((int)(_1465 + 112u))));
                                              _1690 = asint(srvLightInfoProperties.Load(((int)(_1465 + 120u))));
                                              _1693 = asint(srvLightInfoProperties.Load(((int)(_1465 + 124u))));
                                              _1696 = asint(srvLightInfoProperties.Load(((int)(_1465 + 128u))));
                                              _1699 = asint(srvLightInfoProperties.Load(((int)(_1465 + 132u))));
                                              _1702 = asint(srvLightInfoProperties.Load(((int)(_1465 + 136u))));
                                              _1705 = asint(srvLightInfoProperties.Load(((int)(_1465 + 140u))));
                                              _1707 = f16tof32(((uint)((uint)(_1663) >> 16)));
                                              _1708 = f16tof32(_1663);
                                              _1710 = f16tof32(((uint)((uint)(_1666) >> 16)));
                                              _1714 = ((float)((uint)((uint)(((uint)(_1666) >> 8) & 255)))) * 0.003921499941498041f;
                                              _1717 = ((float)((uint)((uint)(_1666 & 255)))) * 0.003921499941498041f;
                                              _1719 = f16tof32(((uint)((uint)(_1669) >> 16)));
                                              _1722 = _1672 & 65535;
                                              _1732 = f16tof32(((uint)((uint)(_1687) >> 16)));
                                              _1733 = f16tof32(_1687);
                                              _1735 = f16tof32(((uint)((uint)(_1690) >> 16)));
                                              _1736 = 1.0f / _1735;
                                              _1737 = _1735 + -1.0f;
                                              _1738 = f16tof32(_1690);
                                              _1754 = dot(float3(_195, _196, _197), float3(_1655, _1656, _1657));
                                              _1757 = saturate(1.0f - _1754) * f16tof32(_1684);
                                              _1761 = (_1757 * _195) + _221;
                                              _1762 = (_1757 * _196) + _222;
                                              _1763 = (_1757 * _197) - _220;
                                              _1767 = mad(_1639, _1763, mad(_1638, _1762, (_1761 * _1637))) + _1640;
                                              _1771 = mad(_1645, _1763, mad(_1644, _1762, (_1761 * _1643))) + _1646;
                                              _1775 = mad(_1651, _1763, mad(_1650, _1762, (_1761 * _1649))) + _1652;
                                              _1776 = saturate(_1775);
                                              _1799 = saturate(1.0f - (_1767 * f16tof32(_1699))) + saturate(1.0f - ((1.0f - _1767) * f16tof32(((uint)((uint)(_1699) >> 16)))));
                                              _1800 = saturate(1.0f - (_1771 * f16tof32(_1702))) + saturate(1.0f - ((1.0f - _1771) * f16tof32(((uint)((uint)(_1702) >> 16)))));
                                              _1801 = saturate(1.0f - (_1775 * f16tof32(_1705))) + saturate(1.0f - ((1.0f - _1775) * f16tof32(((uint)((uint)(_1705) >> 16)))));
                                              _1804 = saturate(1.0f - dot(float3(_1799, _1800, _1801), float3(_1799, _1800, _1801)));
                                              _1805 = _1804 * _1804;
                                              do {
                                                _2644 = 1.0f;
                                                if (!(((_1463 & 3584) == 0) || (!(_1805 > 0.0f)))) {
                                                  _1812 = 1.0f - _1776;
                                                  _1813 = saturate(_1767);
                                                  _1814 = saturate(_1771);
                                                  do {
                                                    _2077 = 1.0f;
                                                    _2078 = 0.0f;
                                                    _2079 = _1812;
                                                    [branch]
                                                    if (!((_1463 & 1024) == 0)) {
                                                      _1819 = ((_1813 * _1737) + 0.5f) * _1736;
                                                      _1821 = ((_1814 * _1737) + 0.5f) * _1736;
                                                      _1822 = _1812 + f16tof32(((uint)((uint)(_1684) >> 16)));
                                                      Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1672) >> 16))];
                                                      _1825 = saturate(_1822);
                                                      _1829 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                        _1838 = RenoDX_ISFASTShadowAngle(
                                                            uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 0u);
                                                      } else {
                                                        _1838 = frac(frac(dot(float2(((_1829 * 32.665000915527344f) + _125), ((_1829 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                      }
                                                      #else
                                                      _1838 = frac(frac(dot(float2(((_1829 * 32.665000915527344f) + _125), ((_1829 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                      #endif
                                                      _1839 = sin(_1838);
                                                      _1840 = cos(_1838);
                                                      _1841 = cbSharedPerViewData.nFrameCounter & 3;
                                                      _1846 = sqrt((float((int)(_1841)) * 0.25f) + 0.125f) * _1732;
                                                      _1855 = (_global_7[min((uint)(((int)(0u + (_1841 * 2)))), 127u)]) * _1846;
                                                      _1856 = (_global_7[min((uint)(((int)(1u + (_1841 * 2)))), 127u)]) * _1846;
                                                      _1858 = -0.0f - _1839;
                                                      _1863 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1855, _1856), float2(_1840, _1839)) + _1819), (dot(float2(_1855, _1856), float2(_1858, _1840)) + _1821)));
                                                      _1868 = _1863.x - _1825;
                                                      _1870 = select((_1868 < 0.0f), 0.0f, 1.0f);
                                                      _1872 = _1863.y - _1825;
                                                      _1874 = select((_1872 < 0.0f), 0.0f, 1.0f);
                                                      _1878 = _1863.z - _1825;
                                                      _1880 = select((_1878 < 0.0f), 0.0f, 1.0f);
                                                      _1884 = _1863.w - _1825;
                                                      _1886 = select((_1884 < 0.0f), 0.0f, 1.0f);
                                                      _1893 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                      _1898 = sqrt((float((int)(_1893)) * 0.25f) + 0.125f) * _1732;
                                                      _1907 = (_global_7[min((uint)(((int)(0u + (_1893 * 2)))), 127u)]) * _1898;
                                                      _1908 = (_global_7[min((uint)(((int)(1u + (_1893 * 2)))), 127u)]) * _1898;
                                                      _1914 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1907, _1908), float2(_1840, _1839)) + _1819), (dot(float2(_1907, _1908), float2(_1858, _1840)) + _1821)));
                                                      _1919 = _1914.x - _1825;
                                                      _1921 = select((_1919 < 0.0f), 0.0f, 1.0f);
                                                      _1925 = _1914.y - _1825;
                                                      _1927 = select((_1925 < 0.0f), 0.0f, 1.0f);
                                                      _1931 = _1914.z - _1825;
                                                      _1933 = select((_1931 < 0.0f), 0.0f, 1.0f);
                                                      _1937 = _1914.w - _1825;
                                                      _1939 = select((_1937 < 0.0f), 0.0f, 1.0f);
                                                      _1946 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                      _1951 = sqrt((float((int)(_1946)) * 0.25f) + 0.125f) * _1732;
                                                      _1960 = (_global_7[min((uint)(((int)(0u + (_1946 * 2)))), 127u)]) * _1951;
                                                      _1961 = (_global_7[min((uint)(((int)(1u + (_1946 * 2)))), 127u)]) * _1951;
                                                      _1967 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_1960, _1961), float2(_1840, _1839)) + _1819), (dot(float2(_1960, _1961), float2(_1858, _1840)) + _1821)));
                                                      _1972 = _1967.x - _1825;
                                                      _1974 = select((_1972 < 0.0f), 0.0f, 1.0f);
                                                      _1978 = _1967.y - _1825;
                                                      _1980 = select((_1978 < 0.0f), 0.0f, 1.0f);
                                                      _1984 = _1967.z - _1825;
                                                      _1986 = select((_1984 < 0.0f), 0.0f, 1.0f);
                                                      _1990 = _1967.w - _1825;
                                                      _1992 = select((_1990 < 0.0f), 0.0f, 1.0f);
                                                      _1999 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                      _2004 = sqrt((float((int)(_1999)) * 0.25f) + 0.125f) * _1732;
                                                      _2013 = (_global_7[min((uint)(((int)(0u + (_1999 * 2)))), 127u)]) * _2004;
                                                      _2014 = (_global_7[min((uint)(((int)(1u + (_1999 * 2)))), 127u)]) * _2004;
                                                      _2020 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2013, _2014), float2(_1840, _1839)) + _1819), (dot(float2(_2013, _2014), float2(_1858, _1840)) + _1821)));
                                                      _2025 = _2020.x - _1825;
                                                      _2027 = select((_2025 < 0.0f), 0.0f, 1.0f);
                                                      _2031 = _2020.y - _1825;
                                                      _2033 = select((_2031 < 0.0f), 0.0f, 1.0f);
                                                      _2037 = _2020.z - _1825;
                                                      _2039 = select((_2037 < 0.0f), 0.0f, 1.0f);
                                                      _2043 = _2020.w - _1825;
                                                      _2045 = select((_2043 < 0.0f), 0.0f, 1.0f);
                                                      _2046 = ((((((((((((((_1870 + _1874) + _1880) + _1886) + _1921) + _1927) + _1933) + _1939) + _1974) + _1980) + _1986) + _1992) + _2027) + _2033) + _2039) + _2045;
                                                      _2057 = (saturate(_2046 * 0.0625f) * 2.0f) + -1.0f;
                                                      _2063 = float((int)(((int)(uint)((int)(_2057 > 0.0f))) - ((int)(uint)((int)(_2057 < 0.0f)))));
                                                      _2065 = 1.0f - (_2063 * _2057);
                                                      _2067 = (_2065 * _2065) * _2065;
                                                      _2074 = 0.5f - ((_2063 * 0.5f) * ((1.0f - _2067) - ((_2065 - _2067) * saturate(((1.0f / _1825) * (1.0f / _2046)) * ((((((((((((((((_1870 * _1868) + (_1874 * _1872)) + (_1880 * _1878)) + (_1886 * _1884)) + (_1921 * _1919)) + (_1927 * _1925)) + (_1933 * _1931)) + (_1939 * _1937)) + (_1974 * _1972)) + (_1980 * _1978)) + (_1986 * _1984)) + (_1992 * _1990)) + (_2027 * _2025)) + (_2033 * _2031)) + (_2039 * _2037)) + (_2045 * _2043))))));
                                                      [branch]
                                                      if (!(_1738 < 1.0f)) {
                                                        _2547 = _2074;
                                                        do {
                                                          _2644 = _2547;
                                                          [branch]
                                                          if (!((_1463 & 2048) == 0)) {
                                                            Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1675) >> 16))];
                                                            _2553 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1767, _1771), 0.0f);
                                                            if (_2553.x > 0.0f) {
                                                              Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1675 & 65535))];
                                                              _2560 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1767, _1771), 0.0f);
                                                              _2574 = mad(saturate(((log2(_1776 * _1660) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                              _2575 = max(9.999999747378752e-06f, _2553.x);
                                                              _2576 = _2560.x / _2575;
                                                              _2577 = _2560.y / _2575;
                                                              _2579 = _2560.w / _2575;
                                                              _2584 = ((0.375f - _2577) * 4.999999873689376e-06f) + _2577;
                                                              _2587 = -0.0f - _2576;
                                                              _2588 = mad(_2587, _2584, (_2560.z / _2575));
                                                              _2590 = 1.0f / mad(_2587, _2576, _2584);
                                                              _2591 = _2590 * _2588;
                                                              _2596 = _2574 - _2576;
                                                              _2601 = (((_2574 * _2574) - _2584) - (_2591 * _2596)) / mad((-0.0f - _2588), _2591, mad((-0.0f - _2584), _2584, (((0.375f - _2579) * 4.999999873689376e-06f) + _2579)));
                                                              _2603 = (_2590 * _2596) - (_2601 * _2591);
                                                              _2606 = 1.0f / _2601;
                                                              _2607 = _2603 * _2606;
                                                              _2612 = sqrt(((_2607 * _2607) * 0.25f) - ((1.0f - dot(float2(_2603, _2601), float2(_2576, _2584))) * _2606));
                                                              _2614 = (_2607 * -0.5f) - _2612;
                                                              _2616 = _2612 - (_2607 * 0.5f);
                                                              _2618 = select((_2614 < _2574), 1.0f, 0.0f);
                                                              _2623 = (_2618 + -0.05000000074505806f) / (_2614 - _2574);
                                                              _2629 = (((select((_2616 < _2574), 1.0f, 0.0f) - _2618) / (_2616 - _2614)) - _2623) / (_2616 - _2574);
                                                              _2631 = _2623 - (_2629 * _2614);
                                                              _2644 = (exp2((_2553.x * -1.4426950216293335f) * saturate((dot(float2(_2576, _2584), float2((_2631 - (_2629 * _2574)), _2629)) + 0.05000000074505806f) - (_2631 * _2574))) * _2547);
                                                            } else {
                                                              _2644 = _2547;
                                                            }
                                                          }
                                                          break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                        // Native completed depth-gather shadow bypasses the fallback path.
                                                        break;
                                                      } else {
                                                        _2077 = _2074;
                                                        _2078 = _1738;
                                                        _2079 = _1822;
                                                      }
                                                    }
                                                    _2082 = (_1813 * _1678) + _1680;
                                                    _2083 = (_1814 * _1679) + _1681;
                                                    do {
                                                      _2542 = 1.0f;
                                                      if (!((_1463 & 512) == 0)) {
                                                        Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                                                        _2092 = saturate(_2079);
                                                        _2096 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                        #if FIRSTLIGHT_ISFAST_ENABLED
                                                        if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                          _2105 = RenoDX_ISFASTShadowAngle(
                                                              uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 1u);
                                                        } else {
                                                          _2105 = frac(frac(dot(float2(((_2096 * 32.665000915527344f) + _125), ((_2096 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                        }
                                                        #else
                                                        _2105 = frac(frac(dot(float2(((_2096 * 32.665000915527344f) + _125), ((_2096 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                        #endif
                                                        _2106 = sin(_2105);
                                                        _2107 = cos(_2105);
                                                        _2112 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2082, _2083), 0.0f))).x) > _2092), 1.0f, 0.0f);
                                                        _2113 = cbSharedPerViewData.nFrameCounter & 3;
                                                        _2118 = sqrt((float((int)(_2113)) * 0.25f) + 0.125f) * _1733;
                                                        _2127 = (_global_7[min((uint)(((int)(0u + (_2113 * 2)))), 127u)]) * _2118;
                                                        _2128 = (_global_7[min((uint)(((int)(1u + (_2113 * 2)))), 127u)]) * _2118;
                                                        _2130 = -0.0f - _2106;
                                                        _2132 = dot(float2(_2127, _2128), float2(_2107, _2106)) + _2082;
                                                        _2133 = dot(float2(_2127, _2128), float2(_2130, _2107)) + _2083;
                                                        _2135 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2132, _2133));
                                                        _2139 = _2132 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                        _2140 = _2133 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                        _2143 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1680);
                                                        _2144 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1681);
                                                        _2149 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1678 + _1680)) + 0.5f);
                                                        _2150 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1679 + _1681)) + 0.5f);
                                                        _2153 = floor(_2139 + -0.5f);
                                                        _2154 = floor(_2140 + 0.5f);
                                                        _2156 = floor(_2139 + 0.5f);
                                                        _2158 = floor(_2140 + -0.5f);
                                                        _2159 = (_2153 < _2143);
                                                        _2160 = (_2154 < _2144);
                                                        do {
                                                          if (!(_2159 || _2160)) {
                                                            if ((_2153 >= _2149) || (_2154 >= _2150)) {
                                                              _2169 = _2112;
                                                            } else {
                                                              _2169 = _2135.x;
                                                            }
                                                          } else {
                                                            _2169 = _2112;
                                                          }
                                                          _2170 = (_2156 < _2143);
                                                          do {
                                                            if (!(_2170 || _2160)) {
                                                              if ((_2156 >= _2149) || (_2154 >= _2150)) {
                                                                _2178 = _2112;
                                                              } else {
                                                                _2178 = _2135.y;
                                                              }
                                                            } else {
                                                              _2178 = _2112;
                                                            }
                                                            _2179 = (_2158 < _2144);
                                                            do {
                                                              if (!(_2170 || _2179)) {
                                                                if ((_2156 >= _2149) || (_2158 >= _2150)) {
                                                                  _2187 = _2112;
                                                                } else {
                                                                  _2187 = _2135.z;
                                                                }
                                                              } else {
                                                                _2187 = _2112;
                                                              }
                                                              do {
                                                                if (!(_2159 || _2179)) {
                                                                  if ((_2153 >= _2149) || (_2158 >= _2150)) {
                                                                    _2195 = _2112;
                                                                  } else {
                                                                    _2195 = _2135.w;
                                                                  }
                                                                } else {
                                                                  _2195 = _2112;
                                                                }
                                                                _2196 = _2169 - _2092;
                                                                _2198 = select((_2196 < 0.0f), 0.0f, 1.0f);
                                                                _2200 = _2178 - _2092;
                                                                _2202 = select((_2200 < 0.0f), 0.0f, 1.0f);
                                                                _2206 = _2187 - _2092;
                                                                _2208 = select((_2206 < 0.0f), 0.0f, 1.0f);
                                                                _2212 = _2195 - _2092;
                                                                _2214 = select((_2212 < 0.0f), 0.0f, 1.0f);
                                                                _2221 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                _2226 = sqrt((float((int)(_2221)) * 0.25f) + 0.125f) * _1733;
                                                                _2235 = (_global_7[min((uint)(((int)(0u + (_2221 * 2)))), 127u)]) * _2226;
                                                                _2236 = (_global_7[min((uint)(((int)(1u + (_2221 * 2)))), 127u)]) * _2226;
                                                                _2239 = dot(float2(_2235, _2236), float2(_2107, _2106)) + _2082;
                                                                _2240 = dot(float2(_2235, _2236), float2(_2130, _2107)) + _2083;
                                                                _2242 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2239, _2240));
                                                                _2246 = _2239 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                _2247 = _2240 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                _2250 = floor(_2246 + -0.5f);
                                                                _2251 = floor(_2247 + 0.5f);
                                                                _2253 = floor(_2246 + 0.5f);
                                                                _2255 = floor(_2247 + -0.5f);
                                                                _2256 = (_2250 < _2143);
                                                                _2257 = (_2251 < _2144);
                                                                do {
                                                                  if (!(_2256 || _2257)) {
                                                                    if ((_2250 >= _2149) || (_2251 >= _2150)) {
                                                                      _2266 = _2112;
                                                                    } else {
                                                                      _2266 = _2242.x;
                                                                    }
                                                                  } else {
                                                                    _2266 = _2112;
                                                                  }
                                                                  _2267 = (_2253 < _2143);
                                                                  do {
                                                                    if (!(_2267 || _2257)) {
                                                                      if ((_2253 >= _2149) || (_2251 >= _2150)) {
                                                                        _2275 = _2112;
                                                                      } else {
                                                                        _2275 = _2242.y;
                                                                      }
                                                                    } else {
                                                                      _2275 = _2112;
                                                                    }
                                                                    _2276 = (_2255 < _2144);
                                                                    do {
                                                                      if (!(_2267 || _2276)) {
                                                                        if ((_2253 >= _2149) || (_2255 >= _2150)) {
                                                                          _2284 = _2112;
                                                                        } else {
                                                                          _2284 = _2242.z;
                                                                        }
                                                                      } else {
                                                                        _2284 = _2112;
                                                                      }
                                                                      do {
                                                                        if (!(_2256 || _2276)) {
                                                                          if ((_2250 >= _2149) || (_2255 >= _2150)) {
                                                                            _2292 = _2112;
                                                                          } else {
                                                                            _2292 = _2242.w;
                                                                          }
                                                                        } else {
                                                                          _2292 = _2112;
                                                                        }
                                                                        _2293 = _2266 - _2092;
                                                                        _2295 = select((_2293 < 0.0f), 0.0f, 1.0f);
                                                                        _2299 = _2275 - _2092;
                                                                        _2301 = select((_2299 < 0.0f), 0.0f, 1.0f);
                                                                        _2305 = _2284 - _2092;
                                                                        _2307 = select((_2305 < 0.0f), 0.0f, 1.0f);
                                                                        _2311 = _2292 - _2092;
                                                                        _2313 = select((_2311 < 0.0f), 0.0f, 1.0f);
                                                                        _2320 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                        _2325 = sqrt((float((int)(_2320)) * 0.25f) + 0.125f) * _1733;
                                                                        _2334 = (_global_7[min((uint)(((int)(0u + (_2320 * 2)))), 127u)]) * _2325;
                                                                        _2335 = (_global_7[min((uint)(((int)(1u + (_2320 * 2)))), 127u)]) * _2325;
                                                                        _2338 = dot(float2(_2334, _2335), float2(_2107, _2106)) + _2082;
                                                                        _2339 = dot(float2(_2334, _2335), float2(_2130, _2107)) + _2083;
                                                                        _2341 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2338, _2339));
                                                                        _2345 = _2338 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                        _2346 = _2339 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                        _2349 = floor(_2345 + -0.5f);
                                                                        _2350 = floor(_2346 + 0.5f);
                                                                        _2352 = floor(_2345 + 0.5f);
                                                                        _2354 = floor(_2346 + -0.5f);
                                                                        _2355 = (_2349 < _2143);
                                                                        _2356 = (_2350 < _2144);
                                                                        do {
                                                                          if (!(_2355 || _2356)) {
                                                                            if ((_2349 >= _2149) || (_2350 >= _2150)) {
                                                                              _2365 = _2112;
                                                                            } else {
                                                                              _2365 = _2341.x;
                                                                            }
                                                                          } else {
                                                                            _2365 = _2112;
                                                                          }
                                                                          _2366 = (_2352 < _2143);
                                                                          do {
                                                                            if (!(_2366 || _2356)) {
                                                                              if ((_2352 >= _2149) || (_2350 >= _2150)) {
                                                                                _2374 = _2112;
                                                                              } else {
                                                                                _2374 = _2341.y;
                                                                              }
                                                                            } else {
                                                                              _2374 = _2112;
                                                                            }
                                                                            _2375 = (_2354 < _2144);
                                                                            do {
                                                                              if (!(_2366 || _2375)) {
                                                                                if ((_2352 >= _2149) || (_2354 >= _2150)) {
                                                                                  _2383 = _2112;
                                                                                } else {
                                                                                  _2383 = _2341.z;
                                                                                }
                                                                              } else {
                                                                                _2383 = _2112;
                                                                              }
                                                                              do {
                                                                                if (!(_2355 || _2375)) {
                                                                                  if ((_2349 >= _2149) || (_2354 >= _2150)) {
                                                                                    _2391 = _2112;
                                                                                  } else {
                                                                                    _2391 = _2341.w;
                                                                                  }
                                                                                } else {
                                                                                  _2391 = _2112;
                                                                                }
                                                                                _2392 = _2365 - _2092;
                                                                                _2394 = select((_2392 < 0.0f), 0.0f, 1.0f);
                                                                                _2398 = _2374 - _2092;
                                                                                _2400 = select((_2398 < 0.0f), 0.0f, 1.0f);
                                                                                _2404 = _2383 - _2092;
                                                                                _2406 = select((_2404 < 0.0f), 0.0f, 1.0f);
                                                                                _2410 = _2391 - _2092;
                                                                                _2412 = select((_2410 < 0.0f), 0.0f, 1.0f);
                                                                                _2419 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                _2424 = sqrt((float((int)(_2419)) * 0.25f) + 0.125f) * _1733;
                                                                                _2433 = (_global_7[min((uint)(((int)(0u + (_2419 * 2)))), 127u)]) * _2424;
                                                                                _2434 = (_global_7[min((uint)(((int)(1u + (_2419 * 2)))), 127u)]) * _2424;
                                                                                _2437 = dot(float2(_2433, _2434), float2(_2107, _2106)) + _2082;
                                                                                _2438 = dot(float2(_2433, _2434), float2(_2130, _2107)) + _2083;
                                                                                _2440 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2437, _2438));
                                                                                _2444 = _2437 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                _2445 = _2438 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                _2448 = floor(_2444 + -0.5f);
                                                                                _2449 = floor(_2445 + 0.5f);
                                                                                _2451 = floor(_2444 + 0.5f);
                                                                                _2453 = floor(_2445 + -0.5f);
                                                                                _2454 = (_2448 < _2143);
                                                                                _2455 = (_2449 < _2144);
                                                                                do {
                                                                                  if (!(_2454 || _2455)) {
                                                                                    if ((_2448 >= _2149) || (_2449 >= _2150)) {
                                                                                      _2464 = _2112;
                                                                                    } else {
                                                                                      _2464 = _2440.x;
                                                                                    }
                                                                                  } else {
                                                                                    _2464 = _2112;
                                                                                  }
                                                                                  _2465 = (_2451 < _2143);
                                                                                  do {
                                                                                    if (!(_2465 || _2455)) {
                                                                                      if ((_2451 >= _2149) || (_2449 >= _2150)) {
                                                                                        _2473 = _2112;
                                                                                      } else {
                                                                                        _2473 = _2440.y;
                                                                                      }
                                                                                    } else {
                                                                                      _2473 = _2112;
                                                                                    }
                                                                                    _2474 = (_2453 < _2144);
                                                                                    do {
                                                                                      if (!(_2465 || _2474)) {
                                                                                        if ((_2451 >= _2149) || (_2453 >= _2150)) {
                                                                                          _2482 = _2112;
                                                                                        } else {
                                                                                          _2482 = _2440.z;
                                                                                        }
                                                                                      } else {
                                                                                        _2482 = _2112;
                                                                                      }
                                                                                      do {
                                                                                        if (!(_2454 || _2474)) {
                                                                                          if ((_2448 >= _2149) || (_2453 >= _2150)) {
                                                                                            _2490 = _2112;
                                                                                          } else {
                                                                                            _2490 = _2440.w;
                                                                                          }
                                                                                        } else {
                                                                                          _2490 = _2112;
                                                                                        }
                                                                                        _2491 = _2464 - _2092;
                                                                                        _2493 = select((_2491 < 0.0f), 0.0f, 1.0f);
                                                                                        _2497 = _2473 - _2092;
                                                                                        _2499 = select((_2497 < 0.0f), 0.0f, 1.0f);
                                                                                        _2503 = _2482 - _2092;
                                                                                        _2505 = select((_2503 < 0.0f), 0.0f, 1.0f);
                                                                                        _2509 = _2490 - _2092;
                                                                                        _2511 = select((_2509 < 0.0f), 0.0f, 1.0f);
                                                                                        _2512 = ((((((((((((((_2202 + _2198) + _2208) + _2214) + _2295) + _2301) + _2307) + _2313) + _2394) + _2400) + _2406) + _2412) + _2493) + _2499) + _2505) + _2511;
                                                                                        _2523 = (saturate(_2512 * 0.0625f) * 2.0f) + -1.0f;
                                                                                        _2529 = float((int)(((int)(uint)((int)(_2523 > 0.0f))) - ((int)(uint)((int)(_2523 < 0.0f)))));
                                                                                        _2531 = 1.0f - (_2529 * _2523);
                                                                                        _2533 = (_2531 * _2531) * _2531;
                                                                                        _2542 = (0.5f - ((_2529 * 0.5f) * ((1.0f - _2533) - ((_2531 - _2533) * saturate(((1.0f / _2092) * (1.0f / _2512)) * ((((((((((((((((_2202 * _2200) + (_2198 * _2196)) + (_2208 * _2206)) + (_2214 * _2212)) + (_2295 * _2293)) + (_2301 * _2299)) + (_2307 * _2305)) + (_2313 * _2311)) + (_2394 * _2392)) + (_2400 * _2398)) + (_2406 * _2404)) + (_2412 * _2410)) + (_2493 * _2491)) + (_2499 * _2497)) + (_2505 * _2503)) + (_2511 * _2509)))))));
                                                                                      } while (false);
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
                                                      _2547 = (lerp(_2542, _2077, _2078));
                                                      [branch]
                                                      if (!((_1463 & 2048) == 0)) {
                                                        Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1675) >> 16))];
                                                        _2553 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1767, _1771), 0.0f);
                                                        if (_2553.x > 0.0f) {
                                                          Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1675 & 65535))];
                                                          _2560 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1767, _1771), 0.0f);
                                                          _2574 = mad(saturate(((log2(_1776 * _1660) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                          _2575 = max(9.999999747378752e-06f, _2553.x);
                                                          _2576 = _2560.x / _2575;
                                                          _2577 = _2560.y / _2575;
                                                          _2579 = _2560.w / _2575;
                                                          _2584 = ((0.375f - _2577) * 4.999999873689376e-06f) + _2577;
                                                          _2587 = -0.0f - _2576;
                                                          _2588 = mad(_2587, _2584, (_2560.z / _2575));
                                                          _2590 = 1.0f / mad(_2587, _2576, _2584);
                                                          _2591 = _2590 * _2588;
                                                          _2596 = _2574 - _2576;
                                                          _2601 = (((_2574 * _2574) - _2584) - (_2591 * _2596)) / mad((-0.0f - _2588), _2591, mad((-0.0f - _2584), _2584, (((0.375f - _2579) * 4.999999873689376e-06f) + _2579)));
                                                          _2603 = (_2590 * _2596) - (_2601 * _2591);
                                                          _2606 = 1.0f / _2601;
                                                          _2607 = _2603 * _2606;
                                                          _2612 = sqrt(((_2607 * _2607) * 0.25f) - ((1.0f - dot(float2(_2603, _2601), float2(_2576, _2584))) * _2606));
                                                          _2614 = (_2607 * -0.5f) - _2612;
                                                          _2616 = _2612 - (_2607 * 0.5f);
                                                          _2618 = select((_2614 < _2574), 1.0f, 0.0f);
                                                          _2623 = (_2618 + -0.05000000074505806f) / (_2614 - _2574);
                                                          _2629 = (((select((_2616 < _2574), 1.0f, 0.0f) - _2618) / (_2616 - _2614)) - _2623) / (_2616 - _2574);
                                                          _2631 = _2623 - (_2629 * _2614);
                                                          _2644 = (exp2((_2553.x * -1.4426950216293335f) * saturate((dot(float2(_2576, _2584), float2((_2631 - (_2629 * _2574)), _2629)) + 0.05000000074505806f) - (_2631 * _2574))) * _2547);
                                                        } else {
                                                          _2644 = _2547;
                                                        }
                                                      } else {
                                                        _2644 = _2547;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                }
                                                do {
                                                  _2665 = _1707;
                                                  _2666 = _1708;
                                                  _2667 = _1710;
                                                  [branch]
                                                  if (!(_1722 == 0)) {
                                                    Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1722)))];
                                                    _2657 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1767 * f16tof32(((uint)((uint)(_1693) >> 16)))) + f16tof32(((uint)((uint)(_1696) >> 16)))), ((_1771 * f16tof32(_1693)) + f16tof32(_1696))), 0.0f);
                                                    _2665 = (_2657.x * _1707);
                                                    _2666 = (_2657.y * _1708);
                                                    _2667 = (_2657.z * _1710);
                                                  }
                                                  _2668 = _2644 * _1805;
                                                  [branch]
                                                  if (!(_2668 == 0.0f)) {
                                                    do {
                                                      _2686 = GetDeferredSoftShadowChannel(_1466);
                                                      if (_2686 < 0) {
                                                            _2707 = _2668;
                                                            do {
                                                              _8367 = _1451;
                                                              _8368 = _1452;
                                                              _8369 = _1453;
                                                              _8370 = _1454;
                                                              _8371 = _1455;
                                                              _8372 = _1456;
                                                              [branch]
                                                              if (!(_2707 == 0.0f)) {
                                                                do {
                                                                  _2746 = _2707;
                                                                  [branch]
                                                                  if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                    _2717 = srvLightMappingData[_1466];
                                                                    if (!(_2717 == -1)) {
                                                                      _2722 = srvLightIndexData[_2717].nLayerIndex;
                                                                      _2724 = srvLightIndexData[_2717].vAtlasOrigin.x;
                                                                      _2725 = srvLightIndexData[_2717].vAtlasOrigin.y;
                                                                      _2727 = srvLightIndexData[_2717].vScreenOrigin.x;
                                                                      _2728 = srvLightIndexData[_2717].vScreenOrigin.y;
                                                                      _2737 = ((int)(_2722 * 5)) & 31;
                                                                      _2746 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2724 + _63) - _2727)), ((int)((_2725 + _64) - _2728)), 0)))).x) & ((int)(31 << _2737)))) >> _2737)) >> 1)))) * 0.06666667014360428f) * _2707);
                                                                    } else {
                                                                      _2746 = _2707;
                                                                    }
                                                                  }
                                                                  _2750 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                  _2753 = select(_2750, (_2746 * _1213), _2746);
                                                                  _2755 = dot(float3(_1655, _1656, _1657), float3(_1655, _1656, _1657));
                                                                  _2756 = rsqrt(_2755);
                                                                  _2757 = _2756 * _1655;
                                                                  _2758 = _2756 * _1656;
                                                                  _2759 = _2756 * _1657;
                                                                  _2760 = dot(float3(_195, _196, _197), float3(_2757, _2758, _2759));
                                                                  do {
                                                                    _2778 = _2760;
                                                                    if (_1719 > 0.0f) {
                                                                      _2768 = sqrt(saturate((_1719 * _1719) * (1.0f / (_2755 + 1.0f))));
                                                                      if (_2760 < _2768) {
                                                                        _2773 = max(_2760, (-0.0f - _2768)) + _2768;
                                                                        _2778 = ((_2773 * _2773) / (_2768 * 4.0f));
                                                                      } else {
                                                                        _2778 = _2760;
                                                                      }
                                                                    }
                                                                    _2779 = _206 * _206;
                                                                    _2783 = saturate((_1719 * (1.0f - _2779)) * _2756);
                                                                    _2785 = saturate(_2756 * f16tof32(_1669));
                                                                    _2786 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                                    _2787 = dot(float3(_394, _395, _393), float3(_2757, _2758, _2759));
                                                                    _2790 = rsqrt((_2787 * 2.0f) + 2.0f);
                                                                    _2797 = (_2783 > 0.0f);
                                                                    do {
                                                                      _2888 = saturate((_2790 * _2787) + _2790);
                                                                      _2889 = saturate(_2790 * (_2786 + _2760));
                                                                      if (_2797) {
                                                                        _2801 = sqrt(1.0f - (_2783 * _2783));
                                                                        _2803 = (_2760 * 2.0f) * _2786;
                                                                        _2804 = _2803 - _2787;
                                                                        if (!(!(_2804 >= _2801))) {
                                                                          _2888 = abs(_2786);
                                                                          _2889 = 1.0f;
                                                                        } else {
                                                                          _2812 = rsqrt(1.0f - (_2804 * _2804)) * _2783;
                                                                          _2815 = _2812 * (_2786 - (_2804 * _2760));
                                                                          _2816 = _2786 * _2786;
                                                                          _2821 = _2812 * (((_2816 * 2.0f) + -1.0f) - (_2804 * _2787));
                                                                          _2830 = sqrt(saturate((((1.0f - (_2760 * _2760)) - _2816) - (_2787 * _2787)) + (_2803 * _2787)));
                                                                          _2831 = _2830 * _2812;
                                                                          _2834 = ((_2786 * 2.0f) * _2812) * _2830;
                                                                          _2836 = (_2801 * _2760) + _2786;
                                                                          _2837 = _2836 + _2815;
                                                                          _2838 = _2801 * _2787;
                                                                          _2840 = (_2838 + 1.0f) + _2821;
                                                                          _2841 = _2831 * _2840;
                                                                          _2842 = _2837 * _2840;
                                                                          _2843 = _2834 * _2837;
                                                                          _2848 = (((_2837 * 0.25f) * _2834) - (_2841 * 0.5f)) * _2842;
                                                                          _2862 = (((_2843 - (_2841 * 2.0f)) * _2843) + (_2841 * _2841)) + ((((-0.5f - ((_2840 + _2838) * 0.5f)) * _2842) + ((_2840 * _2840) * _2836)) * _2837);
                                                                          _2867 = (_2848 * 2.0f) / ((_2862 * _2862) + (_2848 * _2848));
                                                                          _2868 = _2862 * _2867;
                                                                          _2870 = 1.0f - (_2848 * _2867);
                                                                          _2876 = ((_2868 * _2834) + _2838) + (_2870 * _2821);
                                                                          _2879 = rsqrt((_2876 * 2.0f) + 2.0f);
                                                                          _2888 = saturate((_2876 * _2879) + _2879);
                                                                          _2889 = saturate(((_2836 + (_2868 * _2831)) + (_2870 * _2815)) * _2879);
                                                                        }
                                                                      }
                                                                      _2890 = saturate(_2778);
                                                                      _2891 = _2779 * _2779;
                                                                      do {
                                                                        _2901 = _2891;
                                                                        if (_2785 > 0.0f) {
                                                                          _2901 = saturate(((_2785 * _2785) / ((_2888 * 3.5999999046325684f) + 0.4000000059604645f)) + _2891);
                                                                        }
                                                                        _2902 = sqrt(_2901);
                                                                        do {
                                                                          _2913 = 1.0f;
                                                                          if (_2797) {
                                                                            _2913 = (_2901 / ((((_2783 * 0.25f) * ((_2902 * 3.0f) + _2783)) / (_2888 + 0.0010000000474974513f)) + _2901));
                                                                          }
                                                                          _2917 = (((_2901 * _2889) - _2889) * _2889) + 1.0f;
                                                                          _2922 = saturate(abs(_2786) + 9.999999747378752e-06f);
                                                                          _2923 = 1.0f - _2902;
                                                                          _2935 = saturate((_2760 + _1717) / (_1717 + 1.0f));
                                                                          _2938 = ((_2913 * _2890) * (_2901 / (_2917 * _2917))) * (0.5f / ((((_2923 * _2922) + _2902) * _2890) + (((_2923 * _2890) + _2902) * _2922)));
                                                                          _2939 = _2665 * _1513;
                                                                          _2940 = _2666 * _1513;
                                                                          _2941 = _2667 * _1513;
                                                                          do {
                                                                            _2976 = _1454;
                                                                            _2977 = _1455;
                                                                            _2978 = _1456;
                                                                            if (_1714 > 0.0f) {
                                                                              _2958 = (exp2(log2(1.0f - saturate(_2888)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                              _2959 = select(_2750, (_2746 * _1213), _2746) * _1714;
                                                                              _2976 = (((((_2939 * _1082) * _2959) * _2958) * _2938) + _1454);
                                                                              _2977 = (((((_2940 * _1082) * _2959) * _2958) * _2938) + _1455);
                                                                              _2978 = (((((_2941 * _1082) * _2959) * _2958) * _2938) + _1456);
                                                                            }
                                                                            _2984 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_1655, _1656, _1657)));
                                                                            _2987 = 1.0f - ((_2984 * _2984) * 0.6399999856948853f);
                                                                            _2992 = saturate(0.30000001192092896f - _1754) * (0.36000001430511475f / (_2987 * _2987));
                                                                            _2993 = _1805 * _1513;
                                                                            _8367 = (((_2753 * _2939) * _2935) + _1451);
                                                                            _8368 = (((_2753 * _2940) * _2935) + _1452);
                                                                            _8369 = (((_2753 * _2941) * _2935) + _1453);
                                                                            _8370 = ((((_167 * _212) * _2993) * _2992) + _2976);
                                                                            _8371 = ((((_167 * _213) * _2993) * _2992) + _2977);
                                                                            _8372 = ((((_214 * _167) * _2993) * _2992) + _2978);
                                                                          } while (false);
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
                                                      _2689 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                                      do {
                                                        if (_2686 == 0) {
                                                          _2703 = _2689.x;
                                                        } else {
                                                          if (_2686 == 1) {
                                                            _2703 = _2689.y;
                                                          } else {
                                                            if (_2686 == 2) {
                                                              _2703 = _2689.z;
                                                            } else {
                                                              _2703 = _2689.w;
                                                            }
                                                          }
                                                        }
                                                        _2707 = ((_2703 * _2703) * _1805);
                                                        [branch]
                                                        if (!(_2707 == 0.0f)) {
                                                          do {
                                                            _2746 = _2707;
                                                            [branch]
                                                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                              _2717 = srvLightMappingData[_1466];
                                                              if (!(_2717 == -1)) {
                                                                _2722 = srvLightIndexData[_2717].nLayerIndex;
                                                                _2724 = srvLightIndexData[_2717].vAtlasOrigin.x;
                                                                _2725 = srvLightIndexData[_2717].vAtlasOrigin.y;
                                                                _2727 = srvLightIndexData[_2717].vScreenOrigin.x;
                                                                _2728 = srvLightIndexData[_2717].vScreenOrigin.y;
                                                                _2737 = ((int)(_2722 * 5)) & 31;
                                                                _2746 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2724 + _63) - _2727)), ((int)((_2725 + _64) - _2728)), 0)))).x) & ((int)(31 << _2737)))) >> _2737)) >> 1)))) * 0.06666667014360428f) * _2707);
                                                              } else {
                                                                _2746 = _2707;
                                                              }
                                                            }
                                                            _2750 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                            _2753 = select(_2750, (_2746 * _1213), _2746);
                                                            _2755 = dot(float3(_1655, _1656, _1657), float3(_1655, _1656, _1657));
                                                            _2756 = rsqrt(_2755);
                                                            _2757 = _2756 * _1655;
                                                            _2758 = _2756 * _1656;
                                                            _2759 = _2756 * _1657;
                                                            _2760 = dot(float3(_195, _196, _197), float3(_2757, _2758, _2759));
                                                            do {
                                                              _2778 = _2760;
                                                              if (_1719 > 0.0f) {
                                                                _2768 = sqrt(saturate((_1719 * _1719) * (1.0f / (_2755 + 1.0f))));
                                                                if (_2760 < _2768) {
                                                                  _2773 = max(_2760, (-0.0f - _2768)) + _2768;
                                                                  _2778 = ((_2773 * _2773) / (_2768 * 4.0f));
                                                                } else {
                                                                  _2778 = _2760;
                                                                }
                                                              }
                                                              _2779 = _206 * _206;
                                                              _2783 = saturate((_1719 * (1.0f - _2779)) * _2756);
                                                              _2785 = saturate(_2756 * f16tof32(_1669));
                                                              _2786 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                              _2787 = dot(float3(_394, _395, _393), float3(_2757, _2758, _2759));
                                                              _2790 = rsqrt((_2787 * 2.0f) + 2.0f);
                                                              _2797 = (_2783 > 0.0f);
                                                              do {
                                                                _2888 = saturate((_2790 * _2787) + _2790);
                                                                _2889 = saturate(_2790 * (_2786 + _2760));
                                                                if (_2797) {
                                                                  _2801 = sqrt(1.0f - (_2783 * _2783));
                                                                  _2803 = (_2760 * 2.0f) * _2786;
                                                                  _2804 = _2803 - _2787;
                                                                  if (!(!(_2804 >= _2801))) {
                                                                    _2888 = abs(_2786);
                                                                    _2889 = 1.0f;
                                                                  } else {
                                                                    _2812 = rsqrt(1.0f - (_2804 * _2804)) * _2783;
                                                                    _2815 = _2812 * (_2786 - (_2804 * _2760));
                                                                    _2816 = _2786 * _2786;
                                                                    _2821 = _2812 * (((_2816 * 2.0f) + -1.0f) - (_2804 * _2787));
                                                                    _2830 = sqrt(saturate((((1.0f - (_2760 * _2760)) - _2816) - (_2787 * _2787)) + (_2803 * _2787)));
                                                                    _2831 = _2830 * _2812;
                                                                    _2834 = ((_2786 * 2.0f) * _2812) * _2830;
                                                                    _2836 = (_2801 * _2760) + _2786;
                                                                    _2837 = _2836 + _2815;
                                                                    _2838 = _2801 * _2787;
                                                                    _2840 = (_2838 + 1.0f) + _2821;
                                                                    _2841 = _2831 * _2840;
                                                                    _2842 = _2837 * _2840;
                                                                    _2843 = _2834 * _2837;
                                                                    _2848 = (((_2837 * 0.25f) * _2834) - (_2841 * 0.5f)) * _2842;
                                                                    _2862 = (((_2843 - (_2841 * 2.0f)) * _2843) + (_2841 * _2841)) + ((((-0.5f - ((_2840 + _2838) * 0.5f)) * _2842) + ((_2840 * _2840) * _2836)) * _2837);
                                                                    _2867 = (_2848 * 2.0f) / ((_2862 * _2862) + (_2848 * _2848));
                                                                    _2868 = _2862 * _2867;
                                                                    _2870 = 1.0f - (_2848 * _2867);
                                                                    _2876 = ((_2868 * _2834) + _2838) + (_2870 * _2821);
                                                                    _2879 = rsqrt((_2876 * 2.0f) + 2.0f);
                                                                    _2888 = saturate((_2876 * _2879) + _2879);
                                                                    _2889 = saturate(((_2836 + (_2868 * _2831)) + (_2870 * _2815)) * _2879);
                                                                  }
                                                                }
                                                                _2890 = saturate(_2778);
                                                                _2891 = _2779 * _2779;
                                                                do {
                                                                  _2901 = _2891;
                                                                  if (_2785 > 0.0f) {
                                                                    _2901 = saturate(((_2785 * _2785) / ((_2888 * 3.5999999046325684f) + 0.4000000059604645f)) + _2891);
                                                                  }
                                                                  _2902 = sqrt(_2901);
                                                                  do {
                                                                    _2913 = 1.0f;
                                                                    if (_2797) {
                                                                      _2913 = (_2901 / ((((_2783 * 0.25f) * ((_2902 * 3.0f) + _2783)) / (_2888 + 0.0010000000474974513f)) + _2901));
                                                                    }
                                                                    _2917 = (((_2901 * _2889) - _2889) * _2889) + 1.0f;
                                                                    _2922 = saturate(abs(_2786) + 9.999999747378752e-06f);
                                                                    _2923 = 1.0f - _2902;
                                                                    _2935 = saturate((_2760 + _1717) / (_1717 + 1.0f));
                                                                    _2938 = ((_2913 * _2890) * (_2901 / (_2917 * _2917))) * (0.5f / ((((_2923 * _2922) + _2902) * _2890) + (((_2923 * _2890) + _2902) * _2922)));
                                                                    _2939 = _2665 * _1513;
                                                                    _2940 = _2666 * _1513;
                                                                    _2941 = _2667 * _1513;
                                                                    do {
                                                                      _2976 = _1454;
                                                                      _2977 = _1455;
                                                                      _2978 = _1456;
                                                                      if (_1714 > 0.0f) {
                                                                        _2958 = (exp2(log2(1.0f - saturate(_2888)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                        _2959 = select(_2750, (_2746 * _1213), _2746) * _1714;
                                                                        _2976 = (((((_2939 * _1082) * _2959) * _2958) * _2938) + _1454);
                                                                        _2977 = (((((_2940 * _1082) * _2959) * _2958) * _2938) + _1455);
                                                                        _2978 = (((((_2941 * _1082) * _2959) * _2958) * _2938) + _1456);
                                                                      }
                                                                      _2984 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_1655, _1656, _1657)));
                                                                      _2987 = 1.0f - ((_2984 * _2984) * 0.6399999856948853f);
                                                                      _2992 = saturate(0.30000001192092896f - _1754) * (0.36000001430511475f / (_2987 * _2987));
                                                                      _2993 = _1805 * _1513;
                                                                      _8367 = (((_2753 * _2939) * _2935) + _1451);
                                                                      _8368 = (((_2753 * _2940) * _2935) + _1452);
                                                                      _8369 = (((_2753 * _2941) * _2935) + _1453);
                                                                      _8370 = ((((_167 * _212) * _2993) * _2992) + _2976);
                                                                      _8371 = ((((_167 * _213) * _2993) * _2992) + _2977);
                                                                      _8372 = ((((_214 * _167) * _2993) * _2992) + _2978);
                                                                    } while (false);
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
                                                          _8367 = _1451;
                                                          _8368 = _1452;
                                                          _8369 = _1453;
                                                          _8370 = _1454;
                                                          _8371 = _1455;
                                                          _8372 = _1456;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    _8367 = _1451;
                                                    _8368 = _1452;
                                                    _8369 = _1453;
                                                    _8370 = _1454;
                                                    _8371 = _1455;
                                                    _8372 = _1456;
                                                  }
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } while (false);
                                              if (_loop_break_3) break;
                                            } else {
                                              if (_1496 == 7) {
                                                _3457 = asfloat(srvLightInfoProperties.Load3(_1465)).x;
                                                _3458 = asfloat(srvLightInfoProperties.Load3(_1465)).y;
                                                _3459 = asfloat(srvLightInfoProperties.Load3(_1465)).z;
                                                _3462 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 12u)))).x;
                                                _3463 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 12u)))).y;
                                                _3464 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 12u)))).z;
                                                _3467 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 24u)))).x;
                                                _3468 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 24u)))).y;
                                                _3469 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 24u)))).z;
                                                _3472 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 36u)))).x;
                                                _3473 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 36u)))).y;
                                                _3474 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 36u)))).z;
                                                _3477 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).x;
                                                _3478 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).y;
                                                _3479 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 48u)))).z;
                                                _3482 = asint(srvLightInfoProperties.Load(((int)(_1465 + 60u))));
                                                _3485 = asint(srvLightInfoProperties.Load(((int)(_1465 + 64u))));
                                                _3488 = asint(srvLightInfoProperties.Load(((int)(_1465 + 72u))));
                                                _3491 = asint(srvLightInfoProperties.Load(((int)(_1465 + 76u))));
                                                _3494 = asint(srvLightInfoProperties.Load(((int)(_1465 + 80u))));
                                                _3497 = asint(srvLightInfoProperties.Load(((int)(_1465 + 84u))));
                                                _3500 = asint(srvLightInfoProperties.Load(((int)(_1465 + 88u))));
                                                _3503 = asint(srvLightInfoProperties.Load(((int)(_1465 + 92u))));
                                                _3506 = asint(srvLightInfoProperties.Load(((int)(_1465 + 96u))));
                                                _3509 = asint(srvLightInfoProperties.Load(((int)(_1465 + 100u))));
                                                _3512 = asint(srvLightInfoProperties.Load(((int)(_1465 + 104u))));
                                                _3515 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).x;
                                                _3516 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).y;
                                                _3517 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).z;
                                                _3518 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).w;
                                                _3521 = asint(srvLightInfoProperties.Load(((int)(_1465 + 124u))));
                                                _3524 = asint(srvLightInfoProperties.Load(((int)(_1465 + 128u))));
                                                _3527 = asint(srvLightInfoProperties.Load(((int)(_1465 + 136u))));
                                                _3530 = asint(srvLightInfoProperties.Load(((int)(_1465 + 140u))));
                                                _3532 = f16tof32(((uint)((uint)(_3482) >> 16)));
                                                _3533 = f16tof32(_3482);
                                                _3535 = f16tof32(((uint)((uint)(_3485) >> 16)));
                                                _3539 = ((float)((uint)((uint)(((uint)(_3485) >> 8) & 255)))) * 0.003921499941498041f;
                                                _3542 = ((float)((uint)((uint)(_3485 & 255)))) * 0.003921499941498041f;
                                                _3543 = f16tof32(_3488);
                                                _3545 = f16tof32(((uint)((uint)(_3491) >> 16)));
                                                _3549 = f16tof32(_3494);
                                                _3551 = f16tof32(((uint)((uint)(_3497) >> 16)));
                                                _3552 = f16tof32(_3497);
                                                _3554 = f16tof32(((uint)((uint)(_3500) >> 16)));
                                                _3557 = _3503 & 65535;
                                                _3561 = ((_1463 & 4194304) != 0);
                                                _3569 = f16tof32(((uint)((uint)(_3512) >> 16)));
                                                _3570 = f16tof32(_3512);
                                                _3572 = f16tof32(((uint)((uint)(_3521) >> 16)));
                                                _3575 = f16tof32(((uint)((uint)(_3524) >> 16)));
                                                _3576 = f16tof32(_3524);
                                                _3578 = f16tof32(((uint)((uint)(_3527) >> 16)));
                                                _3579 = _3578 + -1.0f;
                                                do {
                                                  if (_3561) {
                                                    _3581 = 0.5f / _3578;
                                                    _3582 = 0.3333333432674408f / _3578;
                                                    _3586 = (_3578 * 0.5f) + 0.5f;
                                                    _3596 = (_3581 * _3579);
                                                    _3597 = (_3582 * _3579);
                                                    _3598 = (_3581 * _3586);
                                                    _3599 = (_3582 * _3586);
                                                    _3600 = (_3578 * 2.0f);
                                                    _3601 = (_3578 * 3.0f);
                                                  } else {
                                                    _3592 = 1.0f / _3578;
                                                    _3593 = _3592 * _3579;
                                                    _3594 = _3592 * 0.5f;
                                                    _3596 = _3593;
                                                    _3597 = _3593;
                                                    _3598 = _3594;
                                                    _3599 = _3594;
                                                    _3600 = _3578;
                                                    _3601 = _3578;
                                                  }
                                                  _3605 = _3472 - _221;
                                                  _3606 = _3473 - _222;
                                                  _3607 = _3474 + _220;
                                                  _3608 = dot(float3(_3605, _3606, _3607), float3(_3605, _3606, _3607));
                                                  _3609 = rsqrt(_3608);
                                                  _3610 = _3609 * _3608;
                                                  _3611 = _3609 * _3605;
                                                  _3612 = _3609 * _3606;
                                                  _3613 = _3609 * _3607;
                                                  _3616 = max(0.0f, (_3610 - abs(_3549)));
                                                  _3617 = _3616 * f16tof32(((uint)((uint)(_3494) >> 16)));
                                                  _3618 = _3617 * _3617;
                                                  _3621 = saturate(1.0f - (_3618 * _3618));
                                                  _3628 = (_3621 * _3621) / (select((_3549 < 0.0f), (_3618 * 16.0f), (_3616 * _3616)) + 1.0f);
                                                  _3638 = dot(float3(_195, _196, _197), float3(_3611, _3612, _3613));
                                                  _3641 = saturate(1.0f - _3638) * f16tof32(_3521);
                                                  _3645 = abs(_3607);
                                                  _3649 = _3605 - ((_3641 * _195) * _3645);
                                                  _3650 = _3606 - ((_3641 * _196) * _3645);
                                                  _3651 = _3607 - ((_3641 * _197) * _3645);
                                                  _3654 = mad(_3651, _3468, mad(_3650, _3463, (_3649 * _3458)));
                                                  _3657 = mad(_3651, _3469, mad(_3650, _3464, (_3649 * _3459)));
                                                  _3659 = ((_1463 & 3584) != 0);
                                                  do {
                                                    _5450 = _3628;
                                                    _5451 = 1.0f;
                                                    if (_3659 && (_3628 > 0.0f)) {
                                                      _3665 = mad(_3651, _3467, mad(_3650, _3462, (_3649 * _3457)));
                                                      _3666 = -0.0f - _3657;
                                                      _3667 = -0.0f - _3654;
                                                      do {
                                                        _4456 = 1.0f;
                                                        _4457 = 1.0f;
                                                        _4458 = 0;
                                                        [branch]
                                                        if (!((_1463 & 1024) == 0)) {
                                                          Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3503) >> 16))];
                                                          [branch]
                                                          if (_3561) {
                                                            _3672 = abs(_3665);
                                                            _3673 = abs(_3666);
                                                            _3674 = abs(_3667);
                                                            do {
                                                              if (_3672 > max(_3673, _3674)) {
                                                                _3678 = (_3665 > 0.0f);
                                                                _3693 = select(_3678, 0.0f, 1.0f);
                                                                _3694 = 0.0f;
                                                                _3695 = select(_3678, _3654, _3667);
                                                                _3696 = _3657;
                                                                _3697 = _3672;
                                                              } else {
                                                                if (_3673 > _3674) {
                                                                  _3684 = (_3657 < -0.0f);
                                                                  _3693 = select(_3684, 0.0f, 1.0f);
                                                                  _3694 = 1.0f;
                                                                  _3695 = _3665;
                                                                  _3696 = select(_3684, _3667, _3654);
                                                                  _3697 = _3673;
                                                                } else {
                                                                  _3688 = (_3654 < -0.0f);
                                                                  _3693 = select(_3688, 0.0f, 1.0f);
                                                                  _3694 = 2.0f;
                                                                  _3695 = select(_3688, _3665, (-0.0f - _3665));
                                                                  _3696 = _3657;
                                                                  _3697 = _3674;
                                                                }
                                                              }
                                                              _3698 = _3697 * 2.0f;
                                                              _3702 = -0.0f - _3570;
                                                              _3711 = ((min(max((_3695 / _3698), _3702), _3570) + _3693) * _3596) + _3598;
                                                              _3712 = ((min(max((_3696 / _3698), _3702), _3570) + _3694) * _3597) + _3599;
                                                              _3719 = ((_3693 + -0.5f) * _3596) + _3598;
                                                              _3720 = ((_3694 + -0.5f) * _3597) + _3599;
                                                              _3723 = saturate((_3572 + 1.0f) - (_3697 * _3554));
                                                              _3727 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _3736 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 2u);
                                                              } else {
                                                                _3736 = frac(frac(dot(float2(((_3727 * 32.665000915527344f) + _125), ((_3727 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _3736 = frac(frac(dot(float2(((_3727 * 32.665000915527344f) + _125), ((_3727 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _3737 = sin(_3736);
                                                              _3738 = cos(_3736);
                                                              _3743 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_3711, _3712), 0.0f))).x) > _3723), 1.0f, 0.0f);
                                                              _3744 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _3749 = sqrt((float((int)(_3744)) * 0.25f) + 0.125f) * _3575;
                                                              _3758 = (_global_7[min((uint)(((int)(0u + (_3744 * 2)))), 127u)]) * _3749;
                                                              _3759 = (_global_7[min((uint)(((int)(1u + (_3744 * 2)))), 127u)]) * _3749;
                                                              _3761 = -0.0f - _3737;
                                                              _3763 = dot(float2(_3758, _3759), float2(_3738, _3737)) + _3711;
                                                              _3764 = dot(float2(_3758, _3759), float2(_3761, _3738)) + _3712;
                                                              _3766 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3763, _3764));
                                                              _3770 = _3763 * _3600;
                                                              _3771 = _3764 * _3601;
                                                              _3774 = floor(_3719 * _3600);
                                                              _3775 = floor(_3720 * _3601);
                                                              _3780 = floor(((_3719 + _3596) * _3600) + 0.5f);
                                                              _3781 = floor(((_3720 + _3597) * _3601) + 0.5f);
                                                              _3784 = floor(_3770 + -0.5f);
                                                              _3785 = floor(_3771 + 0.5f);
                                                              _3787 = floor(_3770 + 0.5f);
                                                              _3789 = floor(_3771 + -0.5f);
                                                              _3790 = (_3784 < _3774);
                                                              _3791 = (_3785 < _3775);
                                                              do {
                                                                if (!(_3790 || _3791)) {
                                                                  if ((_3784 >= _3780) || (_3785 >= _3781)) {
                                                                    _3800 = _3743;
                                                                  } else {
                                                                    _3800 = _3766.x;
                                                                  }
                                                                } else {
                                                                  _3800 = _3743;
                                                                }
                                                                _3801 = (_3787 < _3774);
                                                                do {
                                                                  if (!(_3801 || _3791)) {
                                                                    if ((_3787 >= _3780) || (_3785 >= _3781)) {
                                                                      _3809 = _3743;
                                                                    } else {
                                                                      _3809 = _3766.y;
                                                                    }
                                                                  } else {
                                                                    _3809 = _3743;
                                                                  }
                                                                  _3810 = (_3789 < _3775);
                                                                  do {
                                                                    if (!(_3801 || _3810)) {
                                                                      if ((_3787 >= _3780) || (_3789 >= _3781)) {
                                                                        _3818 = _3743;
                                                                      } else {
                                                                        _3818 = _3766.z;
                                                                      }
                                                                    } else {
                                                                      _3818 = _3743;
                                                                    }
                                                                    do {
                                                                      if (!(_3790 || _3810)) {
                                                                        if ((_3784 >= _3780) || (_3789 >= _3781)) {
                                                                          _3826 = _3743;
                                                                        } else {
                                                                          _3826 = _3766.w;
                                                                        }
                                                                      } else {
                                                                        _3826 = _3743;
                                                                      }
                                                                      _3827 = _3800 - _3723;
                                                                      _3829 = select((_3827 < 0.0f), 0.0f, 1.0f);
                                                                      _3831 = _3809 - _3723;
                                                                      _3833 = select((_3831 < 0.0f), 0.0f, 1.0f);
                                                                      _3837 = _3818 - _3723;
                                                                      _3839 = select((_3837 < 0.0f), 0.0f, 1.0f);
                                                                      _3843 = _3826 - _3723;
                                                                      _3845 = select((_3843 < 0.0f), 0.0f, 1.0f);
                                                                      _3852 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _3857 = sqrt((float((int)(_3852)) * 0.25f) + 0.125f) * _3575;
                                                                      _3866 = (_global_7[min((uint)(((int)(0u + (_3852 * 2)))), 127u)]) * _3857;
                                                                      _3867 = (_global_7[min((uint)(((int)(1u + (_3852 * 2)))), 127u)]) * _3857;
                                                                      _3870 = dot(float2(_3866, _3867), float2(_3738, _3737)) + _3711;
                                                                      _3871 = dot(float2(_3866, _3867), float2(_3761, _3738)) + _3712;
                                                                      _3873 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3870, _3871));
                                                                      _3877 = _3870 * _3600;
                                                                      _3878 = _3871 * _3601;
                                                                      _3881 = floor(_3877 + -0.5f);
                                                                      _3882 = floor(_3878 + 0.5f);
                                                                      _3884 = floor(_3877 + 0.5f);
                                                                      _3886 = floor(_3878 + -0.5f);
                                                                      _3887 = (_3881 < _3774);
                                                                      _3888 = (_3882 < _3775);
                                                                      do {
                                                                        if (!(_3887 || _3888)) {
                                                                          if ((_3881 >= _3780) || (_3882 >= _3781)) {
                                                                            _3897 = _3743;
                                                                          } else {
                                                                            _3897 = _3873.x;
                                                                          }
                                                                        } else {
                                                                          _3897 = _3743;
                                                                        }
                                                                        _3898 = (_3884 < _3774);
                                                                        do {
                                                                          if (!(_3898 || _3888)) {
                                                                            if ((_3884 >= _3780) || (_3882 >= _3781)) {
                                                                              _3906 = _3743;
                                                                            } else {
                                                                              _3906 = _3873.y;
                                                                            }
                                                                          } else {
                                                                            _3906 = _3743;
                                                                          }
                                                                          _3907 = (_3886 < _3775);
                                                                          do {
                                                                            if (!(_3898 || _3907)) {
                                                                              if ((_3884 >= _3780) || (_3886 >= _3781)) {
                                                                                _3915 = _3743;
                                                                              } else {
                                                                                _3915 = _3873.z;
                                                                              }
                                                                            } else {
                                                                              _3915 = _3743;
                                                                            }
                                                                            do {
                                                                              if (!(_3887 || _3907)) {
                                                                                if ((_3881 >= _3780) || (_3886 >= _3781)) {
                                                                                  _3923 = _3743;
                                                                                } else {
                                                                                  _3923 = _3873.w;
                                                                                }
                                                                              } else {
                                                                                _3923 = _3743;
                                                                              }
                                                                              _3924 = _3897 - _3723;
                                                                              _3926 = select((_3924 < 0.0f), 0.0f, 1.0f);
                                                                              _3930 = _3906 - _3723;
                                                                              _3932 = select((_3930 < 0.0f), 0.0f, 1.0f);
                                                                              _3936 = _3915 - _3723;
                                                                              _3938 = select((_3936 < 0.0f), 0.0f, 1.0f);
                                                                              _3942 = _3923 - _3723;
                                                                              _3944 = select((_3942 < 0.0f), 0.0f, 1.0f);
                                                                              _3951 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _3956 = sqrt((float((int)(_3951)) * 0.25f) + 0.125f) * _3575;
                                                                              _3965 = (_global_7[min((uint)(((int)(0u + (_3951 * 2)))), 127u)]) * _3956;
                                                                              _3966 = (_global_7[min((uint)(((int)(1u + (_3951 * 2)))), 127u)]) * _3956;
                                                                              _3969 = dot(float2(_3965, _3966), float2(_3738, _3737)) + _3711;
                                                                              _3970 = dot(float2(_3965, _3966), float2(_3761, _3738)) + _3712;
                                                                              _3972 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3969, _3970));
                                                                              _3976 = _3969 * _3600;
                                                                              _3977 = _3970 * _3601;
                                                                              _3980 = floor(_3976 + -0.5f);
                                                                              _3981 = floor(_3977 + 0.5f);
                                                                              _3983 = floor(_3976 + 0.5f);
                                                                              _3985 = floor(_3977 + -0.5f);
                                                                              _3986 = (_3980 < _3774);
                                                                              _3987 = (_3981 < _3775);
                                                                              do {
                                                                                if (!(_3986 || _3987)) {
                                                                                  if ((_3980 >= _3780) || (_3981 >= _3781)) {
                                                                                    _3996 = _3743;
                                                                                  } else {
                                                                                    _3996 = _3972.x;
                                                                                  }
                                                                                } else {
                                                                                  _3996 = _3743;
                                                                                }
                                                                                _3997 = (_3983 < _3774);
                                                                                do {
                                                                                  if (!(_3997 || _3987)) {
                                                                                    if ((_3983 >= _3780) || (_3981 >= _3781)) {
                                                                                      _4005 = _3743;
                                                                                    } else {
                                                                                      _4005 = _3972.y;
                                                                                    }
                                                                                  } else {
                                                                                    _4005 = _3743;
                                                                                  }
                                                                                  _4006 = (_3985 < _3775);
                                                                                  do {
                                                                                    if (!(_3997 || _4006)) {
                                                                                      if ((_3983 >= _3780) || (_3985 >= _3781)) {
                                                                                        _4014 = _3743;
                                                                                      } else {
                                                                                        _4014 = _3972.z;
                                                                                      }
                                                                                    } else {
                                                                                      _4014 = _3743;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_3986 || _4006)) {
                                                                                        if ((_3980 >= _3780) || (_3985 >= _3781)) {
                                                                                          _4022 = _3743;
                                                                                        } else {
                                                                                          _4022 = _3972.w;
                                                                                        }
                                                                                      } else {
                                                                                        _4022 = _3743;
                                                                                      }
                                                                                      _4023 = _3996 - _3723;
                                                                                      _4025 = select((_4023 < 0.0f), 0.0f, 1.0f);
                                                                                      _4029 = _4005 - _3723;
                                                                                      _4031 = select((_4029 < 0.0f), 0.0f, 1.0f);
                                                                                      _4035 = _4014 - _3723;
                                                                                      _4037 = select((_4035 < 0.0f), 0.0f, 1.0f);
                                                                                      _4041 = _4022 - _3723;
                                                                                      _4043 = select((_4041 < 0.0f), 0.0f, 1.0f);
                                                                                      _4050 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _4055 = sqrt((float((int)(_4050)) * 0.25f) + 0.125f) * _3575;
                                                                                      _4064 = (_global_7[min((uint)(((int)(0u + (_4050 * 2)))), 127u)]) * _4055;
                                                                                      _4065 = (_global_7[min((uint)(((int)(1u + (_4050 * 2)))), 127u)]) * _4055;
                                                                                      _4068 = dot(float2(_4064, _4065), float2(_3738, _3737)) + _3711;
                                                                                      _4069 = dot(float2(_4064, _4065), float2(_3761, _3738)) + _3712;
                                                                                      _4071 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4068, _4069));
                                                                                      _4075 = _4068 * _3600;
                                                                                      _4076 = _4069 * _3601;
                                                                                      _4079 = floor(_4075 + -0.5f);
                                                                                      _4080 = floor(_4076 + 0.5f);
                                                                                      _4082 = floor(_4075 + 0.5f);
                                                                                      _4084 = floor(_4076 + -0.5f);
                                                                                      _4085 = (_4079 < _3774);
                                                                                      _4086 = (_4080 < _3775);
                                                                                      do {
                                                                                        if (!(_4085 || _4086)) {
                                                                                          if ((_4079 >= _3780) || (_4080 >= _3781)) {
                                                                                            _4095 = _3743;
                                                                                          } else {
                                                                                            _4095 = _4071.x;
                                                                                          }
                                                                                        } else {
                                                                                          _4095 = _3743;
                                                                                        }
                                                                                        _4096 = (_4082 < _3774);
                                                                                        do {
                                                                                          if (!(_4096 || _4086)) {
                                                                                            if ((_4082 >= _3780) || (_4080 >= _3781)) {
                                                                                              _4104 = _3743;
                                                                                            } else {
                                                                                              _4104 = _4071.y;
                                                                                            }
                                                                                          } else {
                                                                                            _4104 = _3743;
                                                                                          }
                                                                                          _4105 = (_4084 < _3775);
                                                                                          do {
                                                                                            if (!(_4096 || _4105)) {
                                                                                              if ((_4082 >= _3780) || (_4084 >= _3781)) {
                                                                                                _4113 = _3743;
                                                                                              } else {
                                                                                                _4113 = _4071.z;
                                                                                              }
                                                                                            } else {
                                                                                              _4113 = _3743;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_4085 || _4105)) {
                                                                                                if ((_4079 >= _3780) || (_4084 >= _3781)) {
                                                                                                  _4121 = _3743;
                                                                                                } else {
                                                                                                  _4121 = _4071.w;
                                                                                                }
                                                                                              } else {
                                                                                                _4121 = _3743;
                                                                                              }
                                                                                              _4122 = _4095 - _3723;
                                                                                              _4124 = select((_4122 < 0.0f), 0.0f, 1.0f);
                                                                                              _4128 = _4104 - _3723;
                                                                                              _4130 = select((_4128 < 0.0f), 0.0f, 1.0f);
                                                                                              _4134 = _4113 - _3723;
                                                                                              _4136 = select((_4134 < 0.0f), 0.0f, 1.0f);
                                                                                              _4140 = _4121 - _3723;
                                                                                              _4142 = select((_4140 < 0.0f), 0.0f, 1.0f);
                                                                                              _4143 = ((((((((((((((_3833 + _3829) + _3839) + _3845) + _3926) + _3932) + _3938) + _3944) + _4025) + _4031) + _4037) + _4043) + _4124) + _4130) + _4136) + _4142;
                                                                                              _4154 = (saturate(_4143 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _4160 = float((int)(((int)(uint)((int)(_4154 > 0.0f))) - ((int)(uint)((int)(_4154 < 0.0f)))));
                                                                                              _4162 = 1.0f - (_4160 * _4154);
                                                                                              _4164 = (_4162 * _4162) * _4162;
                                                                                              _4456 = (0.5f - ((_4160 * 0.5f) * ((1.0f - _4164) - ((_4162 - _4164) * saturate(((1.0f / _3723) * (1.0f / _4143)) * ((((((((((((((((_3833 * _3831) + (_3829 * _3827)) + (_3839 * _3837)) + (_3845 * _3843)) + (_3926 * _3924)) + (_3932 * _3930)) + (_3938 * _3936)) + (_3944 * _3942)) + (_4025 * _4023)) + (_4031 * _4029)) + (_4037 * _4035)) + (_4043 * _4041)) + (_4124 * _4122)) + (_4130 * _4128)) + (_4136 * _4134)) + (_4142 * _4140)))))));
                                                                                              _4457 = 1.0f;
                                                                                              _4458 = 1;
                                                                                            } while (false);
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
                                                            _4173 = f16tof32(_3530) / _3667;
                                                            _4176 = mad((_4173 * _3665), 0.5f, 0.5f);
                                                            _4177 = mad((_4173 * _3666), 0.5f, 0.5f);
                                                            if (_3654 > -0.0f) {
                                                              if ((saturate(_4176) == _4176) && (saturate(_4177) == _4177)) {
                                                                _4191 = (_4176 * _3596) + _3598;
                                                                _4192 = (_4177 * _3597) + _3599;
                                                                _4193 = saturate((_3572 + 1.0f) - (_3654 * _3554));
                                                                _4197 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                #if FIRSTLIGHT_ISFAST_ENABLED
                                                                if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                  _4206 = RenoDX_ISFASTShadowAngle(
                                                                      uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 3u);
                                                                } else {
                                                                  _4206 = frac(frac(dot(float2(((_4197 * 32.665000915527344f) + _125), ((_4197 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                }
                                                                #else
                                                                _4206 = frac(frac(dot(float2(((_4197 * 32.665000915527344f) + _125), ((_4197 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                #endif
                                                                _4207 = sin(_4206);
                                                                _4208 = cos(_4206);
                                                                _4209 = cbSharedPerViewData.nFrameCounter & 3;
                                                                _4214 = sqrt((float((int)(_4209)) * 0.25f) + 0.125f) * _3575;
                                                                _4223 = (_global_7[min((uint)(((int)(0u + (_4209 * 2)))), 127u)]) * _4214;
                                                                _4224 = (_global_7[min((uint)(((int)(1u + (_4209 * 2)))), 127u)]) * _4214;
                                                                _4226 = -0.0f - _4207;
                                                                _4231 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4223, _4224), float2(_4208, _4207)) + _4191), (dot(float2(_4223, _4224), float2(_4226, _4208)) + _4192)));
                                                                _4236 = _4231.x - _4193;
                                                                _4238 = select((_4236 < 0.0f), 0.0f, 1.0f);
                                                                _4240 = _4231.y - _4193;
                                                                _4242 = select((_4240 < 0.0f), 0.0f, 1.0f);
                                                                _4246 = _4231.z - _4193;
                                                                _4248 = select((_4246 < 0.0f), 0.0f, 1.0f);
                                                                _4252 = _4231.w - _4193;
                                                                _4254 = select((_4252 < 0.0f), 0.0f, 1.0f);
                                                                _4261 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                _4266 = sqrt((float((int)(_4261)) * 0.25f) + 0.125f) * _3575;
                                                                _4275 = (_global_7[min((uint)(((int)(0u + (_4261 * 2)))), 127u)]) * _4266;
                                                                _4276 = (_global_7[min((uint)(((int)(1u + (_4261 * 2)))), 127u)]) * _4266;
                                                                _4282 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4275, _4276), float2(_4208, _4207)) + _4191), (dot(float2(_4275, _4276), float2(_4226, _4208)) + _4192)));
                                                                _4287 = _4282.x - _4193;
                                                                _4289 = select((_4287 < 0.0f), 0.0f, 1.0f);
                                                                _4293 = _4282.y - _4193;
                                                                _4295 = select((_4293 < 0.0f), 0.0f, 1.0f);
                                                                _4299 = _4282.z - _4193;
                                                                _4301 = select((_4299 < 0.0f), 0.0f, 1.0f);
                                                                _4305 = _4282.w - _4193;
                                                                _4307 = select((_4305 < 0.0f), 0.0f, 1.0f);
                                                                _4314 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                _4319 = sqrt((float((int)(_4314)) * 0.25f) + 0.125f) * _3575;
                                                                _4328 = (_global_7[min((uint)(((int)(0u + (_4314 * 2)))), 127u)]) * _4319;
                                                                _4329 = (_global_7[min((uint)(((int)(1u + (_4314 * 2)))), 127u)]) * _4319;
                                                                _4335 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4328, _4329), float2(_4208, _4207)) + _4191), (dot(float2(_4328, _4329), float2(_4226, _4208)) + _4192)));
                                                                _4340 = _4335.x - _4193;
                                                                _4342 = select((_4340 < 0.0f), 0.0f, 1.0f);
                                                                _4346 = _4335.y - _4193;
                                                                _4348 = select((_4346 < 0.0f), 0.0f, 1.0f);
                                                                _4352 = _4335.z - _4193;
                                                                _4354 = select((_4352 < 0.0f), 0.0f, 1.0f);
                                                                _4358 = _4335.w - _4193;
                                                                _4360 = select((_4358 < 0.0f), 0.0f, 1.0f);
                                                                _4367 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                _4372 = sqrt((float((int)(_4367)) * 0.25f) + 0.125f) * _3575;
                                                                _4381 = (_global_7[min((uint)(((int)(0u + (_4367 * 2)))), 127u)]) * _4372;
                                                                _4382 = (_global_7[min((uint)(((int)(1u + (_4367 * 2)))), 127u)]) * _4372;
                                                                _4388 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4381, _4382), float2(_4208, _4207)) + _4191), (dot(float2(_4381, _4382), float2(_4226, _4208)) + _4192)));
                                                                _4393 = _4388.x - _4193;
                                                                _4395 = select((_4393 < 0.0f), 0.0f, 1.0f);
                                                                _4399 = _4388.y - _4193;
                                                                _4401 = select((_4399 < 0.0f), 0.0f, 1.0f);
                                                                _4405 = _4388.z - _4193;
                                                                _4407 = select((_4405 < 0.0f), 0.0f, 1.0f);
                                                                _4411 = _4388.w - _4193;
                                                                _4413 = select((_4411 < 0.0f), 0.0f, 1.0f);
                                                                _4414 = ((((((((((((((_4238 + _4242) + _4248) + _4254) + _4289) + _4295) + _4301) + _4307) + _4342) + _4348) + _4354) + _4360) + _4395) + _4401) + _4407) + _4413;
                                                                _4425 = (saturate(_4414 * 0.0625f) * 2.0f) + -1.0f;
                                                                _4431 = float((int)(((int)(uint)((int)(_4425 > 0.0f))) - ((int)(uint)((int)(_4425 < 0.0f)))));
                                                                _4433 = 1.0f - (_4431 * _4425);
                                                                _4435 = (_4433 * _4433) * _4433;
                                                                _4443 = -0.0f - _3665;
                                                                _4450 = saturate((saturate(rsqrt(dot(float3(_4443, _3657, _3654), float3(_4443, _3657, _3654))) * _3654) * _3552) + _3551);
                                                                _4452 = 1.0f - (_4450 * _4450);
                                                                _4456 = (0.5f - ((_4431 * 0.5f) * ((1.0f - _4435) - ((_4433 - _4435) * saturate(((1.0f / _4193) * (1.0f / _4414)) * ((((((((((((((((_4238 * _4236) + (_4242 * _4240)) + (_4248 * _4246)) + (_4254 * _4252)) + (_4289 * _4287)) + (_4295 * _4293)) + (_4301 * _4299)) + (_4307 * _4305)) + (_4342 * _4340)) + (_4348 * _4346)) + (_4354 * _4352)) + (_4360 * _4358)) + (_4395 * _4393)) + (_4401 * _4399)) + (_4407 * _4405)) + (_4413 * _4411)))))));
                                                                _4457 = (1.0f - (_4452 * _4452));
                                                                _4458 = 1;
                                                              } else {
                                                                _4456 = 1.0f;
                                                                _4457 = 1.0f;
                                                                _4458 = 0;
                                                              }
                                                            } else {
                                                              _4456 = 1.0f;
                                                              _4457 = 1.0f;
                                                              _4458 = 0;
                                                            }
                                                          }
                                                        }
                                                        do {
                                                          _5248 = 1.0f;
                                                          _5249 = 1.0f;
                                                          _5250 = true;
                                                          [branch]
                                                          if (!((_1463 & 512) == 0)) {
                                                            Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                                                            [branch]
                                                            if (!((_1463 & 2097152) == 0)) {
                                                              _4466 = abs(_3665);
                                                              _4467 = abs(_3666);
                                                              _4468 = abs(_3667);
                                                              do {
                                                                if (_4466 > max(_4467, _4468)) {
                                                                  _4472 = (_3665 > 0.0f);
                                                                  _4487 = select(_4472, 0.0f, 1.0f);
                                                                  _4488 = 0.0f;
                                                                  _4489 = select(_4472, _3654, _3667);
                                                                  _4490 = _3657;
                                                                  _4491 = _4466;
                                                                } else {
                                                                  if (_4467 > _4468) {
                                                                    _4478 = (_3657 < -0.0f);
                                                                    _4487 = select(_4478, 0.0f, 1.0f);
                                                                    _4488 = 1.0f;
                                                                    _4489 = _3665;
                                                                    _4490 = select(_4478, _3667, _3654);
                                                                    _4491 = _4467;
                                                                  } else {
                                                                    _4482 = (_3654 < -0.0f);
                                                                    _4487 = select(_4482, 0.0f, 1.0f);
                                                                    _4488 = 2.0f;
                                                                    _4489 = select(_4482, _3665, (-0.0f - _3665));
                                                                    _4490 = _3657;
                                                                    _4491 = _4468;
                                                                  }
                                                                }
                                                                _4492 = _4491 * 2.0f;
                                                                _4497 = -0.0f - _3569;
                                                                _4506 = ((min(max((_4489 / _4492), _4497), _3569) + _4487) * _3515) + _3517;
                                                                _4507 = ((min(max((_4490 / _4492), _4497), _3569) + _4488) * _3516) + _3518;
                                                                _4512 = ((_4487 + -0.5f) * _3515) + _3517;
                                                                _4513 = ((_4488 + -0.5f) * _3516) + _3518;
                                                                _4516 = saturate(1.0f - (_4491 * _3554));
                                                                _4520 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                #if FIRSTLIGHT_ISFAST_ENABLED
                                                                if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                  _4529 = RenoDX_ISFASTShadowAngle(
                                                                      uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 4u);
                                                                } else {
                                                                  _4529 = frac(frac(dot(float2(((_4520 * 32.665000915527344f) + _125), ((_4520 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                }
                                                                #else
                                                                _4529 = frac(frac(dot(float2(((_4520 * 32.665000915527344f) + _125), ((_4520 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                #endif
                                                                _4530 = sin(_4529);
                                                                _4531 = cos(_4529);
                                                                _4536 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4506, _4507), 0.0f))).x) > _4516), 1.0f, 0.0f);
                                                                _4537 = cbSharedPerViewData.nFrameCounter & 3;
                                                                _4542 = sqrt((float((int)(_4537)) * 0.25f) + 0.125f) * _3576;
                                                                _4551 = (_global_7[min((uint)(((int)(0u + (_4537 * 2)))), 127u)]) * _4542;
                                                                _4552 = (_global_7[min((uint)(((int)(1u + (_4537 * 2)))), 127u)]) * _4542;
                                                                _4554 = -0.0f - _4530;
                                                                _4556 = dot(float2(_4551, _4552), float2(_4531, _4530)) + _4506;
                                                                _4557 = dot(float2(_4551, _4552), float2(_4554, _4531)) + _4507;
                                                                _4559 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4556, _4557));
                                                                _4563 = _4556 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                _4564 = _4557 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                _4567 = floor(_4512 * cbSharedPerViewData.vShadowAtlasSize.x);
                                                                _4568 = floor(_4513 * cbSharedPerViewData.vShadowAtlasSize.y);
                                                                _4573 = floor(((_4512 + _3515) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                                                                _4574 = floor(((_4513 + _3516) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                                                                _4577 = floor(_4563 + -0.5f);
                                                                _4578 = floor(_4564 + 0.5f);
                                                                _4580 = floor(_4563 + 0.5f);
                                                                _4582 = floor(_4564 + -0.5f);
                                                                _4583 = (_4577 < _4567);
                                                                _4584 = (_4578 < _4568);
                                                                do {
                                                                  if (!(_4583 || _4584)) {
                                                                    if ((_4577 >= _4573) || (_4578 >= _4574)) {
                                                                      _4593 = _4536;
                                                                    } else {
                                                                      _4593 = _4559.x;
                                                                    }
                                                                  } else {
                                                                    _4593 = _4536;
                                                                  }
                                                                  _4594 = (_4580 < _4567);
                                                                  do {
                                                                    if (!(_4594 || _4584)) {
                                                                      if ((_4580 >= _4573) || (_4578 >= _4574)) {
                                                                        _4602 = _4536;
                                                                      } else {
                                                                        _4602 = _4559.y;
                                                                      }
                                                                    } else {
                                                                      _4602 = _4536;
                                                                    }
                                                                    _4603 = (_4582 < _4568);
                                                                    do {
                                                                      if (!(_4594 || _4603)) {
                                                                        if ((_4580 >= _4573) || (_4582 >= _4574)) {
                                                                          _4611 = _4536;
                                                                        } else {
                                                                          _4611 = _4559.z;
                                                                        }
                                                                      } else {
                                                                        _4611 = _4536;
                                                                      }
                                                                      do {
                                                                        if (!(_4583 || _4603)) {
                                                                          if ((_4577 >= _4573) || (_4582 >= _4574)) {
                                                                            _4619 = _4536;
                                                                          } else {
                                                                            _4619 = _4559.w;
                                                                          }
                                                                        } else {
                                                                          _4619 = _4536;
                                                                        }
                                                                        _4620 = _4593 - _4516;
                                                                        _4622 = select((_4620 < 0.0f), 0.0f, 1.0f);
                                                                        _4624 = _4602 - _4516;
                                                                        _4626 = select((_4624 < 0.0f), 0.0f, 1.0f);
                                                                        _4630 = _4611 - _4516;
                                                                        _4632 = select((_4630 < 0.0f), 0.0f, 1.0f);
                                                                        _4636 = _4619 - _4516;
                                                                        _4638 = select((_4636 < 0.0f), 0.0f, 1.0f);
                                                                        _4645 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                        _4650 = sqrt((float((int)(_4645)) * 0.25f) + 0.125f) * _3576;
                                                                        _4659 = (_global_7[min((uint)(((int)(0u + (_4645 * 2)))), 127u)]) * _4650;
                                                                        _4660 = (_global_7[min((uint)(((int)(1u + (_4645 * 2)))), 127u)]) * _4650;
                                                                        _4663 = dot(float2(_4659, _4660), float2(_4531, _4530)) + _4506;
                                                                        _4664 = dot(float2(_4659, _4660), float2(_4554, _4531)) + _4507;
                                                                        _4666 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4663, _4664));
                                                                        _4670 = _4663 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                        _4671 = _4664 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                        _4674 = floor(_4670 + -0.5f);
                                                                        _4675 = floor(_4671 + 0.5f);
                                                                        _4677 = floor(_4670 + 0.5f);
                                                                        _4679 = floor(_4671 + -0.5f);
                                                                        _4680 = (_4674 < _4567);
                                                                        _4681 = (_4675 < _4568);
                                                                        do {
                                                                          if (!(_4680 || _4681)) {
                                                                            if ((_4674 >= _4573) || (_4675 >= _4574)) {
                                                                              _4690 = _4536;
                                                                            } else {
                                                                              _4690 = _4666.x;
                                                                            }
                                                                          } else {
                                                                            _4690 = _4536;
                                                                          }
                                                                          _4691 = (_4677 < _4567);
                                                                          do {
                                                                            if (!(_4691 || _4681)) {
                                                                              if ((_4677 >= _4573) || (_4675 >= _4574)) {
                                                                                _4699 = _4536;
                                                                              } else {
                                                                                _4699 = _4666.y;
                                                                              }
                                                                            } else {
                                                                              _4699 = _4536;
                                                                            }
                                                                            _4700 = (_4679 < _4568);
                                                                            do {
                                                                              if (!(_4691 || _4700)) {
                                                                                if ((_4677 >= _4573) || (_4679 >= _4574)) {
                                                                                  _4708 = _4536;
                                                                                } else {
                                                                                  _4708 = _4666.z;
                                                                                }
                                                                              } else {
                                                                                _4708 = _4536;
                                                                              }
                                                                              do {
                                                                                if (!(_4680 || _4700)) {
                                                                                  if ((_4674 >= _4573) || (_4679 >= _4574)) {
                                                                                    _4716 = _4536;
                                                                                  } else {
                                                                                    _4716 = _4666.w;
                                                                                  }
                                                                                } else {
                                                                                  _4716 = _4536;
                                                                                }
                                                                                _4717 = _4690 - _4516;
                                                                                _4719 = select((_4717 < 0.0f), 0.0f, 1.0f);
                                                                                _4723 = _4699 - _4516;
                                                                                _4725 = select((_4723 < 0.0f), 0.0f, 1.0f);
                                                                                _4729 = _4708 - _4516;
                                                                                _4731 = select((_4729 < 0.0f), 0.0f, 1.0f);
                                                                                _4735 = _4716 - _4516;
                                                                                _4737 = select((_4735 < 0.0f), 0.0f, 1.0f);
                                                                                _4744 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                _4749 = sqrt((float((int)(_4744)) * 0.25f) + 0.125f) * _3576;
                                                                                _4758 = (_global_7[min((uint)(((int)(0u + (_4744 * 2)))), 127u)]) * _4749;
                                                                                _4759 = (_global_7[min((uint)(((int)(1u + (_4744 * 2)))), 127u)]) * _4749;
                                                                                _4762 = dot(float2(_4758, _4759), float2(_4531, _4530)) + _4506;
                                                                                _4763 = dot(float2(_4758, _4759), float2(_4554, _4531)) + _4507;
                                                                                _4765 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4762, _4763));
                                                                                _4769 = _4762 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                _4770 = _4763 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                _4773 = floor(_4769 + -0.5f);
                                                                                _4774 = floor(_4770 + 0.5f);
                                                                                _4776 = floor(_4769 + 0.5f);
                                                                                _4778 = floor(_4770 + -0.5f);
                                                                                _4779 = (_4773 < _4567);
                                                                                _4780 = (_4774 < _4568);
                                                                                do {
                                                                                  if (!(_4779 || _4780)) {
                                                                                    if ((_4773 >= _4573) || (_4774 >= _4574)) {
                                                                                      _4789 = _4536;
                                                                                    } else {
                                                                                      _4789 = _4765.x;
                                                                                    }
                                                                                  } else {
                                                                                    _4789 = _4536;
                                                                                  }
                                                                                  _4790 = (_4776 < _4567);
                                                                                  do {
                                                                                    if (!(_4790 || _4780)) {
                                                                                      if ((_4776 >= _4573) || (_4774 >= _4574)) {
                                                                                        _4798 = _4536;
                                                                                      } else {
                                                                                        _4798 = _4765.y;
                                                                                      }
                                                                                    } else {
                                                                                      _4798 = _4536;
                                                                                    }
                                                                                    _4799 = (_4778 < _4568);
                                                                                    do {
                                                                                      if (!(_4790 || _4799)) {
                                                                                        if ((_4776 >= _4573) || (_4778 >= _4574)) {
                                                                                          _4807 = _4536;
                                                                                        } else {
                                                                                          _4807 = _4765.z;
                                                                                        }
                                                                                      } else {
                                                                                        _4807 = _4536;
                                                                                      }
                                                                                      do {
                                                                                        if (!(_4779 || _4799)) {
                                                                                          if ((_4773 >= _4573) || (_4778 >= _4574)) {
                                                                                            _4815 = _4536;
                                                                                          } else {
                                                                                            _4815 = _4765.w;
                                                                                          }
                                                                                        } else {
                                                                                          _4815 = _4536;
                                                                                        }
                                                                                        _4816 = _4789 - _4516;
                                                                                        _4818 = select((_4816 < 0.0f), 0.0f, 1.0f);
                                                                                        _4822 = _4798 - _4516;
                                                                                        _4824 = select((_4822 < 0.0f), 0.0f, 1.0f);
                                                                                        _4828 = _4807 - _4516;
                                                                                        _4830 = select((_4828 < 0.0f), 0.0f, 1.0f);
                                                                                        _4834 = _4815 - _4516;
                                                                                        _4836 = select((_4834 < 0.0f), 0.0f, 1.0f);
                                                                                        _4843 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                        _4848 = sqrt((float((int)(_4843)) * 0.25f) + 0.125f) * _3576;
                                                                                        _4857 = (_global_7[min((uint)(((int)(0u + (_4843 * 2)))), 127u)]) * _4848;
                                                                                        _4858 = (_global_7[min((uint)(((int)(1u + (_4843 * 2)))), 127u)]) * _4848;
                                                                                        _4861 = dot(float2(_4857, _4858), float2(_4531, _4530)) + _4506;
                                                                                        _4862 = dot(float2(_4857, _4858), float2(_4554, _4531)) + _4507;
                                                                                        _4864 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4861, _4862));
                                                                                        _4868 = _4861 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                        _4869 = _4862 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                        _4872 = floor(_4868 + -0.5f);
                                                                                        _4873 = floor(_4869 + 0.5f);
                                                                                        _4875 = floor(_4868 + 0.5f);
                                                                                        _4877 = floor(_4869 + -0.5f);
                                                                                        _4878 = (_4872 < _4567);
                                                                                        _4879 = (_4873 < _4568);
                                                                                        do {
                                                                                          if (!(_4878 || _4879)) {
                                                                                            if ((_4872 >= _4573) || (_4873 >= _4574)) {
                                                                                              _4888 = _4536;
                                                                                            } else {
                                                                                              _4888 = _4864.x;
                                                                                            }
                                                                                          } else {
                                                                                            _4888 = _4536;
                                                                                          }
                                                                                          _4889 = (_4875 < _4567);
                                                                                          do {
                                                                                            if (!(_4889 || _4879)) {
                                                                                              if ((_4875 >= _4573) || (_4873 >= _4574)) {
                                                                                                _4897 = _4536;
                                                                                              } else {
                                                                                                _4897 = _4864.y;
                                                                                              }
                                                                                            } else {
                                                                                              _4897 = _4536;
                                                                                            }
                                                                                            _4898 = (_4877 < _4568);
                                                                                            do {
                                                                                              if (!(_4889 || _4898)) {
                                                                                                if ((_4875 >= _4573) || (_4877 >= _4574)) {
                                                                                                  _4906 = _4536;
                                                                                                } else {
                                                                                                  _4906 = _4864.z;
                                                                                                }
                                                                                              } else {
                                                                                                _4906 = _4536;
                                                                                              }
                                                                                              do {
                                                                                                if (!(_4878 || _4898)) {
                                                                                                  if ((_4872 >= _4573) || (_4877 >= _4574)) {
                                                                                                    _4914 = _4536;
                                                                                                  } else {
                                                                                                    _4914 = _4864.w;
                                                                                                  }
                                                                                                } else {
                                                                                                  _4914 = _4536;
                                                                                                }
                                                                                                _4915 = _4888 - _4516;
                                                                                                _4917 = select((_4915 < 0.0f), 0.0f, 1.0f);
                                                                                                _4921 = _4897 - _4516;
                                                                                                _4923 = select((_4921 < 0.0f), 0.0f, 1.0f);
                                                                                                _4927 = _4906 - _4516;
                                                                                                _4929 = select((_4927 < 0.0f), 0.0f, 1.0f);
                                                                                                _4933 = _4914 - _4516;
                                                                                                _4935 = select((_4933 < 0.0f), 0.0f, 1.0f);
                                                                                                _4936 = ((((((((((((((_4626 + _4622) + _4632) + _4638) + _4719) + _4725) + _4731) + _4737) + _4818) + _4824) + _4830) + _4836) + _4917) + _4923) + _4929) + _4935;
                                                                                                _4947 = (saturate(_4936 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                _4953 = float((int)(((int)(uint)((int)(_4947 > 0.0f))) - ((int)(uint)((int)(_4947 < 0.0f)))));
                                                                                                _4955 = 1.0f - (_4953 * _4947);
                                                                                                _4957 = (_4955 * _4955) * _4955;
                                                                                                _5248 = (0.5f - ((_4953 * 0.5f) * ((1.0f - _4957) - ((_4955 - _4957) * saturate(((1.0f / _4516) * (1.0f / _4936)) * ((((((((((((((((_4626 * _4624) + (_4622 * _4620)) + (_4632 * _4630)) + (_4638 * _4636)) + (_4719 * _4717)) + (_4725 * _4723)) + (_4731 * _4729)) + (_4737 * _4735)) + (_4818 * _4816)) + (_4824 * _4822)) + (_4830 * _4828)) + (_4836 * _4834)) + (_4917 * _4915)) + (_4923 * _4921)) + (_4929 * _4927)) + (_4935 * _4933)))))));
                                                                                                _5249 = 1.0f;
                                                                                                _5250 = false;
                                                                                              } while (false);
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
                                                              _4966 = f16tof32(((uint)((uint)(_3530) >> 16))) / _3667;
                                                              _4969 = mad((_4966 * _3665), 0.5f, 0.5f);
                                                              _4970 = mad((_4966 * _3666), 0.5f, 0.5f);
                                                              if (_3654 > -0.0f) {
                                                                if ((saturate(_4969) == _4969) && (saturate(_4970) == _4970)) {
                                                                  _4983 = (_4969 * _3515) + _3517;
                                                                  _4984 = (_4970 * _3516) + _3518;
                                                                  _4985 = saturate(1.0f - (_3654 * _3554));
                                                                  _4989 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _4998 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 5u);
                                                                  } else {
                                                                    _4998 = frac(frac(dot(float2(((_4989 * 32.665000915527344f) + _125), ((_4989 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _4998 = frac(frac(dot(float2(((_4989 * 32.665000915527344f) + _125), ((_4989 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _4999 = sin(_4998);
                                                                  _5000 = cos(_4998);
                                                                  _5001 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _5006 = sqrt((float((int)(_5001)) * 0.25f) + 0.125f) * _3576;
                                                                  _5015 = (_global_7[min((uint)(((int)(0u + (_5001 * 2)))), 127u)]) * _5006;
                                                                  _5016 = (_global_7[min((uint)(((int)(1u + (_5001 * 2)))), 127u)]) * _5006;
                                                                  _5018 = -0.0f - _4999;
                                                                  _5023 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5015, _5016), float2(_5000, _4999)) + _4983), (dot(float2(_5015, _5016), float2(_5018, _5000)) + _4984)));
                                                                  _5028 = _5023.x - _4985;
                                                                  _5030 = select((_5028 < 0.0f), 0.0f, 1.0f);
                                                                  _5032 = _5023.y - _4985;
                                                                  _5034 = select((_5032 < 0.0f), 0.0f, 1.0f);
                                                                  _5038 = _5023.z - _4985;
                                                                  _5040 = select((_5038 < 0.0f), 0.0f, 1.0f);
                                                                  _5044 = _5023.w - _4985;
                                                                  _5046 = select((_5044 < 0.0f), 0.0f, 1.0f);
                                                                  _5053 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                  _5058 = sqrt((float((int)(_5053)) * 0.25f) + 0.125f) * _3576;
                                                                  _5067 = (_global_7[min((uint)(((int)(0u + (_5053 * 2)))), 127u)]) * _5058;
                                                                  _5068 = (_global_7[min((uint)(((int)(1u + (_5053 * 2)))), 127u)]) * _5058;
                                                                  _5074 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5067, _5068), float2(_5000, _4999)) + _4983), (dot(float2(_5067, _5068), float2(_5018, _5000)) + _4984)));
                                                                  _5079 = _5074.x - _4985;
                                                                  _5081 = select((_5079 < 0.0f), 0.0f, 1.0f);
                                                                  _5085 = _5074.y - _4985;
                                                                  _5087 = select((_5085 < 0.0f), 0.0f, 1.0f);
                                                                  _5091 = _5074.z - _4985;
                                                                  _5093 = select((_5091 < 0.0f), 0.0f, 1.0f);
                                                                  _5097 = _5074.w - _4985;
                                                                  _5099 = select((_5097 < 0.0f), 0.0f, 1.0f);
                                                                  _5106 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                  _5111 = sqrt((float((int)(_5106)) * 0.25f) + 0.125f) * _3576;
                                                                  _5120 = (_global_7[min((uint)(((int)(0u + (_5106 * 2)))), 127u)]) * _5111;
                                                                  _5121 = (_global_7[min((uint)(((int)(1u + (_5106 * 2)))), 127u)]) * _5111;
                                                                  _5127 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5120, _5121), float2(_5000, _4999)) + _4983), (dot(float2(_5120, _5121), float2(_5018, _5000)) + _4984)));
                                                                  _5132 = _5127.x - _4985;
                                                                  _5134 = select((_5132 < 0.0f), 0.0f, 1.0f);
                                                                  _5138 = _5127.y - _4985;
                                                                  _5140 = select((_5138 < 0.0f), 0.0f, 1.0f);
                                                                  _5144 = _5127.z - _4985;
                                                                  _5146 = select((_5144 < 0.0f), 0.0f, 1.0f);
                                                                  _5150 = _5127.w - _4985;
                                                                  _5152 = select((_5150 < 0.0f), 0.0f, 1.0f);
                                                                  _5159 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                  _5164 = sqrt((float((int)(_5159)) * 0.25f) + 0.125f) * _3576;
                                                                  _5173 = (_global_7[min((uint)(((int)(0u + (_5159 * 2)))), 127u)]) * _5164;
                                                                  _5174 = (_global_7[min((uint)(((int)(1u + (_5159 * 2)))), 127u)]) * _5164;
                                                                  _5180 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5173, _5174), float2(_5000, _4999)) + _4983), (dot(float2(_5173, _5174), float2(_5018, _5000)) + _4984)));
                                                                  _5185 = _5180.x - _4985;
                                                                  _5187 = select((_5185 < 0.0f), 0.0f, 1.0f);
                                                                  _5191 = _5180.y - _4985;
                                                                  _5193 = select((_5191 < 0.0f), 0.0f, 1.0f);
                                                                  _5197 = _5180.z - _4985;
                                                                  _5199 = select((_5197 < 0.0f), 0.0f, 1.0f);
                                                                  _5203 = _5180.w - _4985;
                                                                  _5205 = select((_5203 < 0.0f), 0.0f, 1.0f);
                                                                  _5206 = ((((((((((((((_5030 + _5034) + _5040) + _5046) + _5081) + _5087) + _5093) + _5099) + _5134) + _5140) + _5146) + _5152) + _5187) + _5193) + _5199) + _5205;
                                                                  _5217 = (saturate(_5206 * 0.0625f) * 2.0f) + -1.0f;
                                                                  _5223 = float((int)(((int)(uint)((int)(_5217 > 0.0f))) - ((int)(uint)((int)(_5217 < 0.0f)))));
                                                                  _5225 = 1.0f - (_5223 * _5217);
                                                                  _5227 = (_5225 * _5225) * _5225;
                                                                  _5235 = -0.0f - _3665;
                                                                  _5242 = saturate((saturate(rsqrt(dot(float3(_5235, _3657, _3654), float3(_5235, _3657, _3654))) * _3654) * _3552) + _3551);
                                                                  _5244 = 1.0f - (_5242 * _5242);
                                                                  _5248 = (0.5f - ((_5223 * 0.5f) * ((1.0f - _5227) - ((_5225 - _5227) * saturate(((1.0f / _4985) * (1.0f / _5206)) * ((((((((((((((((_5030 * _5028) + (_5034 * _5032)) + (_5040 * _5038)) + (_5046 * _5044)) + (_5081 * _5079)) + (_5087 * _5085)) + (_5093 * _5091)) + (_5099 * _5097)) + (_5134 * _5132)) + (_5140 * _5138)) + (_5146 * _5144)) + (_5152 * _5150)) + (_5187 * _5185)) + (_5193 * _5191)) + (_5199 * _5197)) + (_5205 * _5203)))))));
                                                                  _5249 = (1.0f - (_5244 * _5244));
                                                                  _5250 = false;
                                                                } else {
                                                                  _5248 = 1.0f;
                                                                  _5249 = 1.0f;
                                                                  _5250 = true;
                                                                }
                                                              } else {
                                                                _5248 = 1.0f;
                                                                _5249 = 1.0f;
                                                                _5250 = true;
                                                              }
                                                            }
                                                          }
                                                          do {
                                                            if (_4458 == 0) {
                                                              if (!(_5250)) {
                                                                _5265 = _4456;
                                                                _5266 = ((_5249 * (_5248 + -1.0f)) + 1.0f);
                                                                _5267 = 0.0f;
                                                              } else {
                                                                _5265 = _4456;
                                                                _5266 = _5248;
                                                                _5267 = 0.0f;
                                                              }
                                                            } else {
                                                              if (_5250) {
                                                                _5265 = ((_4457 * (_4456 + -1.0f)) + 1.0f);
                                                                _5266 = _5248;
                                                                _5267 = 1.0f;
                                                              } else {
                                                                _5265 = _4456;
                                                                _5266 = _5248;
                                                                _5267 = (_4457 * f16tof32(_3500));
                                                              }
                                                            }
                                                            _5270 = (_5267 * (_5265 - _5266)) + _5266;
                                                            do {
                                                              _5447 = _5270;
                                                              [branch]
                                                              if (!((_1463 & 2048) == 0)) {
                                                                _5272 = _221 - _3472;
                                                                _5273 = _222 - _3473;
                                                                _5274 = _223 - _3474;
                                                                _5289 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5274, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5273, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5272)));
                                                                _5292 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _5274, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _5273, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _5272)));
                                                                _5295 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _5274, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _5273, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _5272)));
                                                                _5297 = rsqrt(dot(float3(_5289, _5292, _5295), float3(_5289, _5292, _5295)));
                                                                _5298 = _5297 * _5289;
                                                                _5299 = _5297 * _5292;
                                                                _5300 = _5297 * _5295;
                                                                Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3506) >> 16))];
                                                                _5308 = (abs(_5299) + abs(_5298)) + abs(_5300);
                                                                _5309 = _5298 / _5308;
                                                                _5310 = _5299 / _5308;
                                                                _5312 = !((_5300 / _5308) >= 0.0f);
                                                                do {
                                                                  _5325 = _5309;
                                                                  _5326 = _5310;
                                                                  if (_5312) {
                                                                    _5325 = ((1.0f - abs(_5310)) * select((_5309 >= 0.0f), 1.0f, -1.0f));
                                                                    _5326 = ((1.0f - abs(_5309)) * select((_5310 >= 0.0f), 1.0f, -1.0f));
                                                                  }
                                                                  _5332 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5325 * 0.5f) + 0.5f), ((_5326 * 0.5f) + 0.5f)), 0.0f);
                                                                  if (_5332.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3506 & 65535))];
                                                                    do {
                                                                      _5351 = _5309;
                                                                      _5352 = _5310;
                                                                      if (_5312) {
                                                                        _5351 = ((1.0f - abs(_5310)) * select((_5309 >= 0.0f), 1.0f, -1.0f));
                                                                        _5352 = ((1.0f - abs(_5309)) * select((_5310 >= 0.0f), 1.0f, -1.0f));
                                                                      }
                                                                      _5357 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5351 * 0.5f) + 0.5f), ((_5352 * 0.5f) + 0.5f)), 0.0f);
                                                                      _5377 = mad(saturate(((log2(sqrt(((_5272 * _5272) + (_5273 * _5273)) + (_5274 * _5274))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                      _5378 = max(9.999999747378752e-06f, _5332.x);
                                                                      _5379 = _5357.x / _5378;
                                                                      _5380 = _5357.y / _5378;
                                                                      _5382 = _5357.w / _5378;
                                                                      _5387 = ((0.375f - _5380) * 4.999999873689376e-06f) + _5380;
                                                                      _5390 = -0.0f - _5379;
                                                                      _5391 = mad(_5390, _5387, (_5357.z / _5378));
                                                                      _5393 = 1.0f / mad(_5390, _5379, _5387);
                                                                      _5394 = _5393 * _5391;
                                                                      _5399 = _5377 - _5379;
                                                                      _5404 = (((_5377 * _5377) - _5387) - (_5394 * _5399)) / mad((-0.0f - _5391), _5394, mad((-0.0f - _5387), _5387, (((0.375f - _5382) * 4.999999873689376e-06f) + _5382)));
                                                                      _5406 = (_5393 * _5399) - (_5404 * _5394);
                                                                      _5409 = 1.0f / _5404;
                                                                      _5410 = _5406 * _5409;
                                                                      _5415 = sqrt(((_5410 * _5410) * 0.25f) - ((1.0f - dot(float2(_5406, _5404), float2(_5379, _5387))) * _5409));
                                                                      _5417 = (_5410 * -0.5f) - _5415;
                                                                      _5419 = _5415 - (_5410 * 0.5f);
                                                                      _5421 = select((_5417 < _5377), 1.0f, 0.0f);
                                                                      _5426 = (_5421 + -0.05000000074505806f) / (_5417 - _5377);
                                                                      _5432 = (((select((_5419 < _5377), 1.0f, 0.0f) - _5421) / (_5419 - _5417)) - _5426) / (_5419 - _5377);
                                                                      _5434 = _5426 - (_5432 * _5417);
                                                                      _5447 = (exp2((_5332.x * -1.4426950216293335f) * saturate((dot(float2(_5379, _5387), float2((_5434 - (_5432 * _5377)), _5432)) + 0.05000000074505806f) - (_5434 * _5377))) * _5270);
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _5447 = _5270;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              }
                                                              _5450 = (_5447 * _3628);
                                                              _5451 = _5447;
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
                                                      _5471 = _3532;
                                                      _5472 = _3533;
                                                      _5473 = _3535;
                                                      [branch]
                                                      if (!(_3557 == 0)) {
                                                        TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3557)))];
                                                        _5463 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3607, _3467, mad(_3606, _3462, (_3605 * _3457)))), (-0.0f - mad(_3607, _3468, mad(_3606, _3463, (_3605 * _3458)))), (-0.0f - mad(_3607, _3469, mad(_3606, _3464, (_3605 * _3459))))), 0.0f);
                                                        _5471 = (_5463.x * _3532);
                                                        _5472 = (_5463.y * _3533);
                                                        _5473 = (_5463.z * _3535);
                                                      }
                                                      [branch]
                                                      if (!(_5450 == 0.0f)) {
                                                        do {
                                                          _5491 = GetDeferredSoftShadowChannel(_1466);
                                                          if (_5491 < 0) {
                                                                _5512 = _5450;
                                                                do {
                                                                  _8367 = _1451;
                                                                  _8368 = _1452;
                                                                  _8369 = _1453;
                                                                  _8370 = _1454;
                                                                  _8371 = _1455;
                                                                  _8372 = _1456;
                                                                  [branch]
                                                                  if (!(_5512 == 0.0f)) {
                                                                    do {
                                                                      _5619 = _5471;
                                                                      _5620 = _5472;
                                                                      _5621 = _5473;
                                                                      [branch]
                                                                      if (!(((_3509 & 1) == 0) || (!_3659))) {
                                                                        _5529 = max(max(_5471, _5472), _5473);
                                                                        do {
                                                                          _5539 = _5471;
                                                                          _5540 = _5472;
                                                                          _5541 = _5473;
                                                                          if (_5529 > 0.0f) {
                                                                            _5539 = saturate(_5471 / _5529);
                                                                            _5540 = saturate(_5472 / _5529);
                                                                            _5541 = saturate(_5473 / _5529);
                                                                          }
                                                                          _5542 = (_5540 < _5541);
                                                                          _5543 = select(_5542, _5541, _5540);
                                                                          _5544 = select(_5542, _5540, _5541);
                                                                          _5545 = select(_5542, -1.0f, 0.0f);
                                                                          _5546 = (_5539 < _5543);
                                                                          _5548 = select(_5546, _5543, _5539);
                                                                          _5549 = select(_5546, _5539, _5543);
                                                                          _5553 = _5548 - select((_5549 < _5544), _5549, _5544);
                                                                          _5559 = abs(select(_5546, (-0.3333333432674408f - _5545), _5545) + ((_5549 - _5544) / ((_5553 * 6.0f) + 9.999999682655225e-21f)));
                                                                          do {
                                                                            _5572 = _5559;
                                                                            if (_5559 < 0.6666666865348816f) {
                                                                              _5572 = ((saturate(((float)((uint)((uint)(((uint)(_3509) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5559 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5559)) + _5559);
                                                                            }
                                                                            _5573 = saturate((_5553 / (_5548 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3509) >> 1) & 255)))) * 0.003921499941498041f));
                                                                            _5574 = saturate(_5548);
                                                                            do {
                                                                              _5601 = _5574;
                                                                              _5602 = _5574;
                                                                              _5603 = _5574;
                                                                              if (!(_5573 <= 0.0f)) {
                                                                                _5577 = saturate(_5572);
                                                                                _5581 = select(((_5577 * 360.0f) >= 360.0f), 0.0f, (_5577 * 6.0f));
                                                                                _5582 = int(_5581);
                                                                                _5584 = _5581 - float((int)(_5582));
                                                                                _5586 = _5574 * (1.0f - _5573);
                                                                                _5589 = (1.0f - (_5584 * _5573)) * _5574;
                                                                                _5593 = (1.0f - ((1.0f - _5584) * _5573)) * _5574;
                                                                                switch (_5582) {
                                                                                  case 0: {
                                                                                    _5601 = _5574;
                                                                                    _5602 = _5593;
                                                                                    _5603 = _5586;
                                                                                    break;
                                                                                  }
                                                                                  case 1: {
                                                                                    _5601 = _5589;
                                                                                    _5602 = _5574;
                                                                                    _5603 = _5586;
                                                                                    break;
                                                                                  }
                                                                                  case 2: {
                                                                                    _5601 = _5586;
                                                                                    _5602 = _5574;
                                                                                    _5603 = _5593;
                                                                                    break;
                                                                                  }
                                                                                  case 3: {
                                                                                    _5601 = _5586;
                                                                                    _5602 = _5589;
                                                                                    _5603 = _5574;
                                                                                    break;
                                                                                  }
                                                                                  case 4: {
                                                                                    _5601 = _5593;
                                                                                    _5602 = _5586;
                                                                                    _5603 = _5574;
                                                                                    break;
                                                                                  }
                                                                                  case 5: {
                                                                                    _5601 = _5574;
                                                                                    _5602 = _5586;
                                                                                    _5603 = _5589;
                                                                                    break;
                                                                                  }
                                                                                  default: {
                                                                                    _5601 = 0.0f;
                                                                                    _5602 = 0.0f;
                                                                                    _5603 = 0.0f;
                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }
                                                                              _5604 = _5601 * _5529;
                                                                              _5605 = _5602 * _5529;
                                                                              _5606 = _5603 * _5529;
                                                                              _5608 = saturate(_5451 * 1.0101009607315063f);
                                                                              _5619 = ((_5608 * (_5471 - _5604)) + _5604);
                                                                              _5620 = ((_5608 * (_5472 - _5605)) + _5605);
                                                                              _5621 = (lerp(_5606, _5473, _5608));
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      do {
                                                                        _5657 = _5512;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _5628 = srvLightMappingData[_1466];
                                                                          if (!(_5628 == -1)) {
                                                                            _5633 = srvLightIndexData[_5628].nLayerIndex;
                                                                            _5635 = srvLightIndexData[_5628].vAtlasOrigin.x;
                                                                            _5636 = srvLightIndexData[_5628].vAtlasOrigin.y;
                                                                            _5638 = srvLightIndexData[_5628].vScreenOrigin.x;
                                                                            _5639 = srvLightIndexData[_5628].vScreenOrigin.y;
                                                                            _5648 = ((int)(_5633 * 5)) & 31;
                                                                            _5657 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5635 + _63) - _5638)), ((int)((_5636 + _64) - _5639)), 0)))).x) & ((int)(31 << _5648)))) >> _5648)) >> 1)))) * 0.06666667014360428f) * _5512);
                                                                          } else {
                                                                            _5657 = _5512;
                                                                          }
                                                                        }
                                                                        _5661 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _5664 = select(_5661, (_5657 * _1213), _5657);
                                                                        _5666 = _3611 * _3610;
                                                                        _5667 = _3612 * _3610;
                                                                        _5668 = _3613 * _3610;
                                                                        _5669 = _3543 * _3477;
                                                                        _5670 = _3543 * _3478;
                                                                        _5671 = _3543 * _3479;
                                                                        _5672 = _5666 + _5669;
                                                                        _5673 = _5667 + _5670;
                                                                        _5674 = _5668 + _5671;
                                                                        _5675 = _5666 - _5669;
                                                                        _5676 = _5667 - _5670;
                                                                        _5677 = _5668 - _5671;
                                                                        _5678 = (_3543 > 0.0f);
                                                                        _5679 = dot(float3(_5672, _5673, _5674), float3(_5672, _5673, _5674));
                                                                        _5680 = rsqrt(_5679);
                                                                        do {
                                                                          [branch]
                                                                          if (_5678) {
                                                                            _5683 = rsqrt(dot(float3(_5675, _5676, _5677), float3(_5675, _5676, _5677)));
                                                                            _5684 = _5683 * _5680;
                                                                            _5686 = dot(float3(_5672, _5673, _5674), float3(_5675, _5676, _5677)) * _5684;
                                                                            _5705 = (_5684 / ((_5684 + 0.5f) + (_5686 * 0.5f)));
                                                                            _5706 = (((dot(float3(_195, _196, _197), float3(_5675, _5676, _5677)) * _5683) + (dot(float3(_195, _196, _197), float3(_5672, _5673, _5674)) * _5680)) * 0.5f);
                                                                            _5707 = _5686;
                                                                          } else {
                                                                            _5705 = (1.0f / (_5679 + 1.0f));
                                                                            _5706 = dot(float3(_195, _196, _197), float3((_5680 * _5672), (_5680 * _5673), (_5680 * _5674)));
                                                                            _5707 = 1.0f;
                                                                          }
                                                                          do {
                                                                            _5723 = _5706;
                                                                            if (_3545 > 0.0f) {
                                                                              _5713 = sqrt(saturate((_3545 * _3545) * _5705));
                                                                              if (_5706 < _5713) {
                                                                                _5718 = max(_5706, (-0.0f - _5713)) + _5713;
                                                                                _5723 = ((_5718 * _5718) / (_5713 * 4.0f));
                                                                              } else {
                                                                                _5723 = _5706;
                                                                              }
                                                                            }
                                                                            do {
                                                                              _5783 = _5672;
                                                                              _5784 = _5673;
                                                                              _5785 = _5674;
                                                                              if (_5678) {
                                                                                _5725 = -0.0f - _394;
                                                                                _5726 = -0.0f - _395;
                                                                                _5727 = -0.0f - _393;
                                                                                _5729 = dot(float3(_5725, _5726, _5727), float3(_195, _196, _197)) * 2.0f;
                                                                                _5733 = _5725 - (_5729 * _195);
                                                                                _5734 = _5726 - (_5729 * _196);
                                                                                _5735 = _5727 - (_5729 * _197);
                                                                                _5736 = _5675 - _5672;
                                                                                _5737 = _5676 - _5673;
                                                                                _5738 = _5677 - _5674;
                                                                                _5739 = dot(float3(_5733, _5734, _5735), float3(_5736, _5737, _5738));
                                                                                _5745 = sqrt(((_5736 * _5736) + (_5737 * _5737)) + (_5738 * _5738));
                                                                                _5754 = saturate(((dot(float3(_5733, _5734, _5735), float3(_5672, _5673, _5674)) * _5739) - dot(float3(_5672, _5673, _5674), float3(_5736, _5737, _5738))) / ((_5745 * _5745) - (_5739 * _5739)));
                                                                                _5758 = (_5754 * _5736) + _5672;
                                                                                _5759 = (_5754 * _5737) + _5673;
                                                                                _5760 = (_5754 * _5738) + _5674;
                                                                                _5761 = dot(float3(_5758, _5759, _5760), float3(_5733, _5734, _5735));
                                                                                _5765 = (_5761 * _5733) - _5758;
                                                                                _5766 = (_5761 * _5734) - _5759;
                                                                                _5767 = (_5761 * _5735) - _5760;
                                                                                _5775 = saturate(0.009999999776482582f / sqrt(((_5765 * _5765) + (_5766 * _5766)) + (_5767 * _5767)));
                                                                                _5783 = ((_5775 * _5765) + _5758);
                                                                                _5784 = ((_5775 * _5766) + _5759);
                                                                                _5785 = ((_5775 * _5767) + _5760);
                                                                              }
                                                                              _5787 = rsqrt(dot(float3(_5783, _5784, _5785), float3(_5783, _5784, _5785)));
                                                                              _5788 = _5787 * _5783;
                                                                              _5789 = _5787 * _5784;
                                                                              _5790 = _5787 * _5785;
                                                                              _5791 = _206 * _206;
                                                                              _5795 = saturate((_3545 * (1.0f - _5791)) * _5787);
                                                                              _5797 = saturate(_5787 * f16tof32(_3491));
                                                                              _5799 = rsqrt(dot(float3(_5666, _5667, _5668), float3(_5666, _5667, _5668)));
                                                                              _5803 = dot(float3(_195, _196, _197), float3(_5788, _5789, _5790));
                                                                              _5804 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                                              _5805 = dot(float3(_394, _395, _393), float3(_5788, _5789, _5790));
                                                                              _5808 = rsqrt((_5805 * 2.0f) + 2.0f);
                                                                              _5815 = (_5795 > 0.0f);
                                                                              do {
                                                                                _5906 = saturate((_5808 * _5805) + _5808);
                                                                                _5907 = saturate(_5808 * (_5804 + _5803));
                                                                                if (_5815) {
                                                                                  _5819 = sqrt(1.0f - (_5795 * _5795));
                                                                                  _5821 = (_5803 * 2.0f) * _5804;
                                                                                  _5822 = _5821 - _5805;
                                                                                  if (!(!(_5822 >= _5819))) {
                                                                                    _5906 = abs(_5804);
                                                                                    _5907 = 1.0f;
                                                                                  } else {
                                                                                    _5830 = rsqrt(1.0f - (_5822 * _5822)) * _5795;
                                                                                    _5833 = _5830 * (_5804 - (_5822 * _5803));
                                                                                    _5834 = _5804 * _5804;
                                                                                    _5839 = _5830 * (((_5834 * 2.0f) + -1.0f) - (_5822 * _5805));
                                                                                    _5848 = sqrt(saturate((((1.0f - (_5803 * _5803)) - _5834) - (_5805 * _5805)) + (_5821 * _5805)));
                                                                                    _5849 = _5848 * _5830;
                                                                                    _5852 = ((_5804 * 2.0f) * _5830) * _5848;
                                                                                    _5854 = (_5819 * _5803) + _5804;
                                                                                    _5855 = _5854 + _5833;
                                                                                    _5856 = _5819 * _5805;
                                                                                    _5858 = (_5856 + 1.0f) + _5839;
                                                                                    _5859 = _5849 * _5858;
                                                                                    _5860 = _5855 * _5858;
                                                                                    _5861 = _5852 * _5855;
                                                                                    _5866 = (((_5855 * 0.25f) * _5852) - (_5859 * 0.5f)) * _5860;
                                                                                    _5880 = (((_5861 - (_5859 * 2.0f)) * _5861) + (_5859 * _5859)) + ((((-0.5f - ((_5858 + _5856) * 0.5f)) * _5860) + ((_5858 * _5858) * _5854)) * _5855);
                                                                                    _5885 = (_5866 * 2.0f) / ((_5880 * _5880) + (_5866 * _5866));
                                                                                    _5886 = _5880 * _5885;
                                                                                    _5888 = 1.0f - (_5866 * _5885);
                                                                                    _5894 = ((_5886 * _5852) + _5856) + (_5888 * _5839);
                                                                                    _5897 = rsqrt((_5894 * 2.0f) + 2.0f);
                                                                                    _5906 = saturate((_5894 * _5897) + _5897);
                                                                                    _5907 = saturate(((_5854 + (_5886 * _5849)) + (_5888 * _5833)) * _5897);
                                                                                  }
                                                                                }
                                                                                _5908 = saturate(_5723);
                                                                                _5910 = _5791 * _5791;
                                                                                do {
                                                                                  _5920 = _5910;
                                                                                  if (_5797 > 0.0f) {
                                                                                    _5920 = saturate(((_5797 * _5797) / ((_5906 * 3.5999999046325684f) + 0.4000000059604645f)) + _5910);
                                                                                  }
                                                                                  do {
                                                                                    _5932 = _5920;
                                                                                    _5933 = 1.0f;
                                                                                    if (_5815) {
                                                                                      _5929 = (((_5795 * 0.25f) * ((sqrt(_5920) * 3.0f) + _5795)) / (_5906 + 0.0010000000474974513f)) + _5920;
                                                                                      _5932 = _5929;
                                                                                      _5933 = (_5920 / _5929);
                                                                                    }
                                                                                    do {
                                                                                      _5953 = _5933;
                                                                                      if (_5707 < 1.0f) {
                                                                                        _5940 = sqrt((1.000100016593933f - _5707) / max(9.999999974752427e-07f, (_5707 + 1.0f)));
                                                                                        _5953 = (sqrt(_5932 / ((((_5940 * 0.25f) * ((sqrt(_5932) * 3.0f) + _5940)) / (_5906 + 0.0010000000474974513f)) + _5932)) * _5933);
                                                                                      }
                                                                                      _5957 = (((_5920 * _5907) - _5907) * _5907) + 1.0f;
                                                                                      _5962 = saturate(abs(_5804) + 9.999999747378752e-06f);
                                                                                      _5963 = sqrt(_5920);
                                                                                      _5964 = 1.0f - _5963;
                                                                                      _5976 = saturate((dot(float3(_195, _196, _197), float3((_5799 * _5666), (_5799 * _5667), (_5799 * _5668))) + _3542) / (_3542 + 1.0f));
                                                                                      _5979 = ((_5953 * _5908) * (_5920 / (_5957 * _5957))) * (0.5f / ((((_5964 * _5962) + _5963) * _5908) + (((_5964 * _5908) + _5963) * _5962)));
                                                                                      _5980 = _5619 * _1513;
                                                                                      _5981 = _5620 * _1513;
                                                                                      _5982 = _5621 * _1513;
                                                                                      do {
                                                                                        _6018 = _1454;
                                                                                        _6019 = _1455;
                                                                                        _6020 = _1456;
                                                                                        if (_3539 > 0.0f) {
                                                                                          _6000 = (exp2(log2(1.0f - saturate(_5906)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                          _6001 = select(_5661, (_5657 * _1213), _5657) * _3539;
                                                                                          _6018 = (((((_5980 * _1082) * _6001) * _6000) * _5979) + _1454);
                                                                                          _6019 = (((((_5981 * _1082) * _6001) * _6000) * _5979) + _1455);
                                                                                          _6020 = (((((_5982 * _1082) * _6001) * _6000) * _5979) + _1456);
                                                                                        }
                                                                                        _6026 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_3611, _3612, _3613)));
                                                                                        _6029 = 1.0f - ((_6026 * _6026) * 0.6399999856948853f);
                                                                                        _6034 = saturate(0.30000001192092896f - _3638) * (0.36000001430511475f / (_6029 * _6029));
                                                                                        _6035 = _3628 * _1513;
                                                                                        _8367 = (((_5664 * _5980) * _5976) + _1451);
                                                                                        _8368 = (((_5664 * _5981) * _5976) + _1452);
                                                                                        _8369 = (((_5664 * _5982) * _5976) + _1453);
                                                                                        _8370 = ((((_167 * _212) * _6035) * _6034) + _6018);
                                                                                        _8371 = ((((_167 * _213) * _6035) * _6034) + _6019);
                                                                                        _8372 = ((((_214 * _167) * _6035) * _6034) + _6020);
                                                                                      } while (false);
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
                                                          _5494 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                                          do {
                                                            if (_5491 == 0) {
                                                              _5508 = _5494.x;
                                                            } else {
                                                              if (_5491 == 1) {
                                                                _5508 = _5494.y;
                                                              } else {
                                                                if (_5491 == 2) {
                                                                  _5508 = _5494.z;
                                                                } else {
                                                                  _5508 = _5494.w;
                                                                }
                                                              }
                                                            }
                                                            _5512 = ((_5508 * _5508) * _3628);
                                                            [branch]
                                                            if (!(_5512 == 0.0f)) {
                                                              do {
                                                                _5619 = _5471;
                                                                _5620 = _5472;
                                                                _5621 = _5473;
                                                                [branch]
                                                                if (!(((_3509 & 1) == 0) || (!_3659))) {
                                                                  _5529 = max(max(_5471, _5472), _5473);
                                                                  do {
                                                                    _5539 = _5471;
                                                                    _5540 = _5472;
                                                                    _5541 = _5473;
                                                                    if (_5529 > 0.0f) {
                                                                      _5539 = saturate(_5471 / _5529);
                                                                      _5540 = saturate(_5472 / _5529);
                                                                      _5541 = saturate(_5473 / _5529);
                                                                    }
                                                                    _5542 = (_5540 < _5541);
                                                                    _5543 = select(_5542, _5541, _5540);
                                                                    _5544 = select(_5542, _5540, _5541);
                                                                    _5545 = select(_5542, -1.0f, 0.0f);
                                                                    _5546 = (_5539 < _5543);
                                                                    _5548 = select(_5546, _5543, _5539);
                                                                    _5549 = select(_5546, _5539, _5543);
                                                                    _5553 = _5548 - select((_5549 < _5544), _5549, _5544);
                                                                    _5559 = abs(select(_5546, (-0.3333333432674408f - _5545), _5545) + ((_5549 - _5544) / ((_5553 * 6.0f) + 9.999999682655225e-21f)));
                                                                    do {
                                                                      _5572 = _5559;
                                                                      if (_5559 < 0.6666666865348816f) {
                                                                        _5572 = ((saturate(((float)((uint)((uint)(((uint)(_3509) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5559 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5559)) + _5559);
                                                                      }
                                                                      _5573 = saturate((_5553 / (_5548 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3509) >> 1) & 255)))) * 0.003921499941498041f));
                                                                      _5574 = saturate(_5548);
                                                                      do {
                                                                        _5601 = _5574;
                                                                        _5602 = _5574;
                                                                        _5603 = _5574;
                                                                        if (!(_5573 <= 0.0f)) {
                                                                          _5577 = saturate(_5572);
                                                                          _5581 = select(((_5577 * 360.0f) >= 360.0f), 0.0f, (_5577 * 6.0f));
                                                                          _5582 = int(_5581);
                                                                          _5584 = _5581 - float((int)(_5582));
                                                                          _5586 = _5574 * (1.0f - _5573);
                                                                          _5589 = (1.0f - (_5584 * _5573)) * _5574;
                                                                          _5593 = (1.0f - ((1.0f - _5584) * _5573)) * _5574;
                                                                          switch (_5582) {
                                                                            case 0: {
                                                                              _5601 = _5574;
                                                                              _5602 = _5593;
                                                                              _5603 = _5586;
                                                                              break;
                                                                            }
                                                                            case 1: {
                                                                              _5601 = _5589;
                                                                              _5602 = _5574;
                                                                              _5603 = _5586;
                                                                              break;
                                                                            }
                                                                            case 2: {
                                                                              _5601 = _5586;
                                                                              _5602 = _5574;
                                                                              _5603 = _5593;
                                                                              break;
                                                                            }
                                                                            case 3: {
                                                                              _5601 = _5586;
                                                                              _5602 = _5589;
                                                                              _5603 = _5574;
                                                                              break;
                                                                            }
                                                                            case 4: {
                                                                              _5601 = _5593;
                                                                              _5602 = _5586;
                                                                              _5603 = _5574;
                                                                              break;
                                                                            }
                                                                            case 5: {
                                                                              _5601 = _5574;
                                                                              _5602 = _5586;
                                                                              _5603 = _5589;
                                                                              break;
                                                                            }
                                                                            default: {
                                                                              _5601 = 0.0f;
                                                                              _5602 = 0.0f;
                                                                              _5603 = 0.0f;
                                                                              break;
                                                                            }
                                                                          }
                                                                        }
                                                                        _5604 = _5601 * _5529;
                                                                        _5605 = _5602 * _5529;
                                                                        _5606 = _5603 * _5529;
                                                                        _5608 = saturate(_5451 * 1.0101009607315063f);
                                                                        _5619 = ((_5608 * (_5471 - _5604)) + _5604);
                                                                        _5620 = ((_5608 * (_5472 - _5605)) + _5605);
                                                                        _5621 = (lerp(_5606, _5473, _5608));
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                }
                                                                do {
                                                                  _5657 = _5512;
                                                                  [branch]
                                                                  if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                    _5628 = srvLightMappingData[_1466];
                                                                    if (!(_5628 == -1)) {
                                                                      _5633 = srvLightIndexData[_5628].nLayerIndex;
                                                                      _5635 = srvLightIndexData[_5628].vAtlasOrigin.x;
                                                                      _5636 = srvLightIndexData[_5628].vAtlasOrigin.y;
                                                                      _5638 = srvLightIndexData[_5628].vScreenOrigin.x;
                                                                      _5639 = srvLightIndexData[_5628].vScreenOrigin.y;
                                                                      _5648 = ((int)(_5633 * 5)) & 31;
                                                                      _5657 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5635 + _63) - _5638)), ((int)((_5636 + _64) - _5639)), 0)))).x) & ((int)(31 << _5648)))) >> _5648)) >> 1)))) * 0.06666667014360428f) * _5512);
                                                                    } else {
                                                                      _5657 = _5512;
                                                                    }
                                                                  }
                                                                  _5661 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                  _5664 = select(_5661, (_5657 * _1213), _5657);
                                                                  _5666 = _3611 * _3610;
                                                                  _5667 = _3612 * _3610;
                                                                  _5668 = _3613 * _3610;
                                                                  _5669 = _3543 * _3477;
                                                                  _5670 = _3543 * _3478;
                                                                  _5671 = _3543 * _3479;
                                                                  _5672 = _5666 + _5669;
                                                                  _5673 = _5667 + _5670;
                                                                  _5674 = _5668 + _5671;
                                                                  _5675 = _5666 - _5669;
                                                                  _5676 = _5667 - _5670;
                                                                  _5677 = _5668 - _5671;
                                                                  _5678 = (_3543 > 0.0f);
                                                                  _5679 = dot(float3(_5672, _5673, _5674), float3(_5672, _5673, _5674));
                                                                  _5680 = rsqrt(_5679);
                                                                  do {
                                                                    [branch]
                                                                    if (_5678) {
                                                                      _5683 = rsqrt(dot(float3(_5675, _5676, _5677), float3(_5675, _5676, _5677)));
                                                                      _5684 = _5683 * _5680;
                                                                      _5686 = dot(float3(_5672, _5673, _5674), float3(_5675, _5676, _5677)) * _5684;
                                                                      _5705 = (_5684 / ((_5684 + 0.5f) + (_5686 * 0.5f)));
                                                                      _5706 = (((dot(float3(_195, _196, _197), float3(_5675, _5676, _5677)) * _5683) + (dot(float3(_195, _196, _197), float3(_5672, _5673, _5674)) * _5680)) * 0.5f);
                                                                      _5707 = _5686;
                                                                    } else {
                                                                      _5705 = (1.0f / (_5679 + 1.0f));
                                                                      _5706 = dot(float3(_195, _196, _197), float3((_5680 * _5672), (_5680 * _5673), (_5680 * _5674)));
                                                                      _5707 = 1.0f;
                                                                    }
                                                                    do {
                                                                      _5723 = _5706;
                                                                      if (_3545 > 0.0f) {
                                                                        _5713 = sqrt(saturate((_3545 * _3545) * _5705));
                                                                        if (_5706 < _5713) {
                                                                          _5718 = max(_5706, (-0.0f - _5713)) + _5713;
                                                                          _5723 = ((_5718 * _5718) / (_5713 * 4.0f));
                                                                        } else {
                                                                          _5723 = _5706;
                                                                        }
                                                                      }
                                                                      do {
                                                                        _5783 = _5672;
                                                                        _5784 = _5673;
                                                                        _5785 = _5674;
                                                                        if (_5678) {
                                                                          _5725 = -0.0f - _394;
                                                                          _5726 = -0.0f - _395;
                                                                          _5727 = -0.0f - _393;
                                                                          _5729 = dot(float3(_5725, _5726, _5727), float3(_195, _196, _197)) * 2.0f;
                                                                          _5733 = _5725 - (_5729 * _195);
                                                                          _5734 = _5726 - (_5729 * _196);
                                                                          _5735 = _5727 - (_5729 * _197);
                                                                          _5736 = _5675 - _5672;
                                                                          _5737 = _5676 - _5673;
                                                                          _5738 = _5677 - _5674;
                                                                          _5739 = dot(float3(_5733, _5734, _5735), float3(_5736, _5737, _5738));
                                                                          _5745 = sqrt(((_5736 * _5736) + (_5737 * _5737)) + (_5738 * _5738));
                                                                          _5754 = saturate(((dot(float3(_5733, _5734, _5735), float3(_5672, _5673, _5674)) * _5739) - dot(float3(_5672, _5673, _5674), float3(_5736, _5737, _5738))) / ((_5745 * _5745) - (_5739 * _5739)));
                                                                          _5758 = (_5754 * _5736) + _5672;
                                                                          _5759 = (_5754 * _5737) + _5673;
                                                                          _5760 = (_5754 * _5738) + _5674;
                                                                          _5761 = dot(float3(_5758, _5759, _5760), float3(_5733, _5734, _5735));
                                                                          _5765 = (_5761 * _5733) - _5758;
                                                                          _5766 = (_5761 * _5734) - _5759;
                                                                          _5767 = (_5761 * _5735) - _5760;
                                                                          _5775 = saturate(0.009999999776482582f / sqrt(((_5765 * _5765) + (_5766 * _5766)) + (_5767 * _5767)));
                                                                          _5783 = ((_5775 * _5765) + _5758);
                                                                          _5784 = ((_5775 * _5766) + _5759);
                                                                          _5785 = ((_5775 * _5767) + _5760);
                                                                        }
                                                                        _5787 = rsqrt(dot(float3(_5783, _5784, _5785), float3(_5783, _5784, _5785)));
                                                                        _5788 = _5787 * _5783;
                                                                        _5789 = _5787 * _5784;
                                                                        _5790 = _5787 * _5785;
                                                                        _5791 = _206 * _206;
                                                                        _5795 = saturate((_3545 * (1.0f - _5791)) * _5787);
                                                                        _5797 = saturate(_5787 * f16tof32(_3491));
                                                                        _5799 = rsqrt(dot(float3(_5666, _5667, _5668), float3(_5666, _5667, _5668)));
                                                                        _5803 = dot(float3(_195, _196, _197), float3(_5788, _5789, _5790));
                                                                        _5804 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                                        _5805 = dot(float3(_394, _395, _393), float3(_5788, _5789, _5790));
                                                                        _5808 = rsqrt((_5805 * 2.0f) + 2.0f);
                                                                        _5815 = (_5795 > 0.0f);
                                                                        do {
                                                                          _5906 = saturate((_5808 * _5805) + _5808);
                                                                          _5907 = saturate(_5808 * (_5804 + _5803));
                                                                          if (_5815) {
                                                                            _5819 = sqrt(1.0f - (_5795 * _5795));
                                                                            _5821 = (_5803 * 2.0f) * _5804;
                                                                            _5822 = _5821 - _5805;
                                                                            if (!(!(_5822 >= _5819))) {
                                                                              _5906 = abs(_5804);
                                                                              _5907 = 1.0f;
                                                                            } else {
                                                                              _5830 = rsqrt(1.0f - (_5822 * _5822)) * _5795;
                                                                              _5833 = _5830 * (_5804 - (_5822 * _5803));
                                                                              _5834 = _5804 * _5804;
                                                                              _5839 = _5830 * (((_5834 * 2.0f) + -1.0f) - (_5822 * _5805));
                                                                              _5848 = sqrt(saturate((((1.0f - (_5803 * _5803)) - _5834) - (_5805 * _5805)) + (_5821 * _5805)));
                                                                              _5849 = _5848 * _5830;
                                                                              _5852 = ((_5804 * 2.0f) * _5830) * _5848;
                                                                              _5854 = (_5819 * _5803) + _5804;
                                                                              _5855 = _5854 + _5833;
                                                                              _5856 = _5819 * _5805;
                                                                              _5858 = (_5856 + 1.0f) + _5839;
                                                                              _5859 = _5849 * _5858;
                                                                              _5860 = _5855 * _5858;
                                                                              _5861 = _5852 * _5855;
                                                                              _5866 = (((_5855 * 0.25f) * _5852) - (_5859 * 0.5f)) * _5860;
                                                                              _5880 = (((_5861 - (_5859 * 2.0f)) * _5861) + (_5859 * _5859)) + ((((-0.5f - ((_5858 + _5856) * 0.5f)) * _5860) + ((_5858 * _5858) * _5854)) * _5855);
                                                                              _5885 = (_5866 * 2.0f) / ((_5880 * _5880) + (_5866 * _5866));
                                                                              _5886 = _5880 * _5885;
                                                                              _5888 = 1.0f - (_5866 * _5885);
                                                                              _5894 = ((_5886 * _5852) + _5856) + (_5888 * _5839);
                                                                              _5897 = rsqrt((_5894 * 2.0f) + 2.0f);
                                                                              _5906 = saturate((_5894 * _5897) + _5897);
                                                                              _5907 = saturate(((_5854 + (_5886 * _5849)) + (_5888 * _5833)) * _5897);
                                                                            }
                                                                          }
                                                                          _5908 = saturate(_5723);
                                                                          _5910 = _5791 * _5791;
                                                                          do {
                                                                            _5920 = _5910;
                                                                            if (_5797 > 0.0f) {
                                                                              _5920 = saturate(((_5797 * _5797) / ((_5906 * 3.5999999046325684f) + 0.4000000059604645f)) + _5910);
                                                                            }
                                                                            do {
                                                                              _5932 = _5920;
                                                                              _5933 = 1.0f;
                                                                              if (_5815) {
                                                                                _5929 = (((_5795 * 0.25f) * ((sqrt(_5920) * 3.0f) + _5795)) / (_5906 + 0.0010000000474974513f)) + _5920;
                                                                                _5932 = _5929;
                                                                                _5933 = (_5920 / _5929);
                                                                              }
                                                                              do {
                                                                                _5953 = _5933;
                                                                                if (_5707 < 1.0f) {
                                                                                  _5940 = sqrt((1.000100016593933f - _5707) / max(9.999999974752427e-07f, (_5707 + 1.0f)));
                                                                                  _5953 = (sqrt(_5932 / ((((_5940 * 0.25f) * ((sqrt(_5932) * 3.0f) + _5940)) / (_5906 + 0.0010000000474974513f)) + _5932)) * _5933);
                                                                                }
                                                                                _5957 = (((_5920 * _5907) - _5907) * _5907) + 1.0f;
                                                                                _5962 = saturate(abs(_5804) + 9.999999747378752e-06f);
                                                                                _5963 = sqrt(_5920);
                                                                                _5964 = 1.0f - _5963;
                                                                                _5976 = saturate((dot(float3(_195, _196, _197), float3((_5799 * _5666), (_5799 * _5667), (_5799 * _5668))) + _3542) / (_3542 + 1.0f));
                                                                                _5979 = ((_5953 * _5908) * (_5920 / (_5957 * _5957))) * (0.5f / ((((_5964 * _5962) + _5963) * _5908) + (((_5964 * _5908) + _5963) * _5962)));
                                                                                _5980 = _5619 * _1513;
                                                                                _5981 = _5620 * _1513;
                                                                                _5982 = _5621 * _1513;
                                                                                do {
                                                                                  _6018 = _1454;
                                                                                  _6019 = _1455;
                                                                                  _6020 = _1456;
                                                                                  if (_3539 > 0.0f) {
                                                                                    _6000 = (exp2(log2(1.0f - saturate(_5906)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                    _6001 = select(_5661, (_5657 * _1213), _5657) * _3539;
                                                                                    _6018 = (((((_5980 * _1082) * _6001) * _6000) * _5979) + _1454);
                                                                                    _6019 = (((((_5981 * _1082) * _6001) * _6000) * _5979) + _1455);
                                                                                    _6020 = (((((_5982 * _1082) * _6001) * _6000) * _5979) + _1456);
                                                                                  }
                                                                                  _6026 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_3611, _3612, _3613)));
                                                                                  _6029 = 1.0f - ((_6026 * _6026) * 0.6399999856948853f);
                                                                                  _6034 = saturate(0.30000001192092896f - _3638) * (0.36000001430511475f / (_6029 * _6029));
                                                                                  _6035 = _3628 * _1513;
                                                                                  _8367 = (((_5664 * _5980) * _5976) + _1451);
                                                                                  _8368 = (((_5664 * _5981) * _5976) + _1452);
                                                                                  _8369 = (((_5664 * _5982) * _5976) + _1453);
                                                                                  _8370 = ((((_167 * _212) * _6035) * _6034) + _6018);
                                                                                  _8371 = ((((_167 * _213) * _6035) * _6034) + _6019);
                                                                                  _8372 = ((((_214 * _167) * _6035) * _6034) + _6020);
                                                                                } while (false);
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
                                                              _8367 = _1451;
                                                              _8368 = _1452;
                                                              _8369 = _1453;
                                                              _8370 = _1454;
                                                              _8371 = _1455;
                                                              _8372 = _1456;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        _8367 = _1451;
                                                        _8368 = _1452;
                                                        _8369 = _1453;
                                                        _8370 = _1454;
                                                        _8371 = _1455;
                                                        _8372 = _1456;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } while (false);
                                                  if (_loop_break_3) break;
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } else {
                                                if (_1496 == 8) {
                                                  _6050 = asfloat(srvLightInfoProperties.Load3(_1465)).x;
                                                  _6051 = asfloat(srvLightInfoProperties.Load3(_1465)).y;
                                                  _6052 = asfloat(srvLightInfoProperties.Load3(_1465)).z;
                                                  _6055 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 12u)))).x;
                                                  _6056 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 12u)))).y;
                                                  _6057 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 12u)))).z;
                                                  _6060 = asfloat(srvLightInfoProperties.Load(((int)(_1465 + 24u))));
                                                  _6063 = asint(srvLightInfoProperties.Load(((int)(_1465 + 28u))));
                                                  _6066 = asint(srvLightInfoProperties.Load(((int)(_1465 + 32u))));
                                                  _6069 = asint(srvLightInfoProperties.Load(((int)(_1465 + 44u))));
                                                  _6078 = ((float)((uint)((uint)(((uint)(_6066) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _6081 = ((float)((uint)((uint)(_6066 & 255)))) * 0.003921499941498041f;
                                                  _6084 = f16tof32(_6069);
                                                  _6091 = min(max(dot(float3((_221 - _6050), (_222 - _6051), (_223 - _6052)), float3(_6055, _6056, _6057)), (-0.0f - _6060)), _6060);
                                                  _6096 = (_6050 - _221) + (_6091 * _6055);
                                                  _6098 = (_6051 - _222) + (_6091 * _6056);
                                                  _6100 = (_6052 + _220) + (_6091 * _6057);
                                                  _6101 = dot(float3(_6096, _6098, _6100), float3(_6096, _6098, _6100));
                                                  _6102 = rsqrt(_6101);
                                                  _6104 = _6096 * _6102;
                                                  _6105 = _6098 * _6102;
                                                  _6106 = _6100 * _6102;
                                                  _6109 = max(0.0f, ((_6102 * _6101) - abs(_6084)));
                                                  _6110 = _6109 * f16tof32(((uint)((uint)(_6069) >> 16)));
                                                  _6111 = _6110 * _6110;
                                                  _6114 = saturate(1.0f - (_6111 * _6111));
                                                  _6121 = (_6114 * _6114) / (select((_6084 < 0.0f), (_6111 * 16.0f), (_6109 * _6109)) + 1.0f);
                                                  [branch]
                                                  if (!(_6121 == 0.0f)) {
                                                    do {
                                                      _6159 = _6121;
                                                      [branch]
                                                      if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                        _6130 = srvLightMappingData[_1466];
                                                        if (!(_6130 == -1)) {
                                                          _6135 = srvLightIndexData[_6130].nLayerIndex;
                                                          _6137 = srvLightIndexData[_6130].vAtlasOrigin.x;
                                                          _6138 = srvLightIndexData[_6130].vAtlasOrigin.y;
                                                          _6140 = srvLightIndexData[_6130].vScreenOrigin.x;
                                                          _6141 = srvLightIndexData[_6130].vScreenOrigin.y;
                                                          _6150 = ((int)(_6135 * 5)) & 31;
                                                          _6159 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6137 + _63) - _6140)), ((int)((_6138 + _64) - _6141)), 0)))).x) & ((int)(31 << _6150)))) >> _6150)) >> 1)))) * 0.06666667014360428f) * _6121);
                                                        } else {
                                                          _6159 = _6121;
                                                        }
                                                      }
                                                      _6163 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                      _6165 = select(_6163, (_6159 * _1213), _6159);
                                                      _6166 = dot(float3(_195, _196, _197), float3(_6104, _6105, _6106));
                                                      _6167 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                      _6168 = dot(float3(_394, _395, _393), float3(_6104, _6105, _6106));
                                                      _6171 = rsqrt((_6168 * 2.0f) + 2.0f);
                                                      _6174 = saturate(_6171 * (_6167 + _6166));
                                                      _6175 = saturate(_6166);
                                                      _6176 = _206 * _206;
                                                      _6177 = _6176 * _6176;
                                                      _6181 = (((_6174 * _6177) - _6174) * _6174) + 1.0f;
                                                      _6186 = saturate(abs(_6167) + 9.999999747378752e-06f);
                                                      _6187 = sqrt(_6177);
                                                      _6188 = 1.0f - _6187;
                                                      _6200 = saturate((_6166 + _6081) / (_6081 + 1.0f));
                                                      _6202 = ((_6177 / (_6181 * _6181)) * _6175) * (0.5f / ((((_6188 * _6186) + _6187) * _6175) + (((_6188 * _6175) + _6187) * _6186)));
                                                      _6203 = f16tof32(((uint)((uint)(_6063) >> 16))) * _1513;
                                                      _6204 = f16tof32(_6063) * _1513;
                                                      _6205 = f16tof32(((uint)((uint)(_6066) >> 16))) * _1513;
                                                      _6212 = ((_6165 * _6203) * _6200) + _1451;
                                                      _6213 = ((_6165 * _6204) * _6200) + _1452;
                                                      _6214 = ((_6165 * _6205) * _6200) + _1453;
                                                      if (_6078 > 0.0f) {
                                                        _6226 = (exp2(log2(1.0f - saturate(saturate((_6171 * _6168) + _6171))) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                        _6229 = select(_6163, (_6159 * _1213), _6159) * _6078;
                                                        _8367 = _6212;
                                                        _8368 = _6213;
                                                        _8369 = _6214;
                                                        _8370 = (((((_6203 * _1082) * _6229) * _6226) * _6202) + _1454);
                                                        _8371 = (((((_6204 * _1082) * _6229) * _6226) * _6202) + _1455);
                                                        _8372 = (((((_6205 * _1082) * _6229) * _6226) * _6202) + _1456);
                                                      } else {
                                                        _8367 = _6212;
                                                        _8368 = _6213;
                                                        _8369 = _6214;
                                                        _8370 = _1454;
                                                        _8371 = _1455;
                                                        _8372 = _1456;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    _8367 = _1451;
                                                    _8368 = _1452;
                                                    _8369 = _1453;
                                                    _8370 = _1454;
                                                    _8371 = _1455;
                                                    _8372 = _1456;
                                                  }
                                                } else {
                                                  if (_1496 == 9) {
                                                    _6250 = asfloat(srvLightInfoProperties.Load4(_1465)).x;
                                                    _6251 = asfloat(srvLightInfoProperties.Load4(_1465)).y;
                                                    _6252 = asfloat(srvLightInfoProperties.Load4(_1465)).w;
                                                    _6255 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).x;
                                                    _6256 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).y;
                                                    _6257 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).w;
                                                    _6260 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).x;
                                                    _6261 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).y;
                                                    _6262 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).w;
                                                    _6265 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 48u)))).x;
                                                    _6266 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 48u)))).y;
                                                    _6267 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 48u)))).w;
                                                    _6270 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 64u)))).x;
                                                    _6271 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 64u)))).y;
                                                    _6272 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 64u)))).z;
                                                    _6275 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 76u)))).x;
                                                    _6276 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 76u)))).y;
                                                    _6277 = asfloat(srvLightInfoProperties.Load3(((int)(_1465 + 76u)))).z;
                                                    _6280 = asint(srvLightInfoProperties.Load(((int)(_1465 + 88u))));
                                                    _6283 = asint(srvLightInfoProperties.Load(((int)(_1465 + 92u))));
                                                    _6286 = asint(srvLightInfoProperties.Load(((int)(_1465 + 100u))));
                                                    _6289 = asint(srvLightInfoProperties.Load(((int)(_1465 + 104u))));
                                                    _6292 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).x;
                                                    _6293 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).y;
                                                    _6294 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).z;
                                                    _6295 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 108u)))).w;
                                                    _6298 = asint(srvLightInfoProperties.Load(((int)(_1465 + 124u))));
                                                    _6301 = asint(srvLightInfoProperties.Load(((int)(_1465 + 128u))));
                                                    _6304 = asint(srvLightInfoProperties.Load(((int)(_1465 + 132u))));
                                                    _6307 = asint(srvLightInfoProperties.Load(((int)(_1465 + 136u))));
                                                    _6310 = asint(srvLightInfoProperties.Load(((int)(_1465 + 140u))));
                                                    _6313 = asint(srvLightInfoProperties.Load(((int)(_1465 + 144u))));
                                                    _6316 = asint(srvLightInfoProperties.Load(((int)(_1465 + 148u))));
                                                    _6319 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 152u)))).x;
                                                    _6320 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 152u)))).y;
                                                    _6321 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 152u)))).z;
                                                    _6322 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 152u)))).w;
                                                    _6325 = asint(srvLightInfoProperties.Load(((int)(_1465 + 168u))));
                                                    _6328 = asint(srvLightInfoProperties.Load(((int)(_1465 + 172u))));
                                                    _6331 = asint(srvLightInfoProperties.Load(((int)(_1465 + 180u))));
                                                    _6333 = f16tof32(((uint)((uint)(_6280) >> 16)));
                                                    _6334 = f16tof32(_6280);
                                                    _6336 = f16tof32(((uint)((uint)(_6283) >> 16)));
                                                    _6340 = ((float)((uint)((uint)(((uint)(_6283) >> 8) & 255)))) * 0.003921499941498041f;
                                                    _6343 = ((float)((uint)((uint)(_6283 & 255)))) * 0.003921499941498041f;
                                                    _6344 = f16tof32(_6286);
                                                    _6346 = f16tof32(((uint)((uint)(_6289) >> 16)));
                                                    _6350 = f16tof32(_6298);
                                                    _6354 = _6304 & 65535;
                                                    _6370 = f16tof32(((uint)((uint)(_6328) >> 16)));
                                                    _6371 = f16tof32(_6328);
                                                    _6373 = f16tof32(((uint)((uint)(_6331) >> 16)));
                                                    _6374 = 1.0f / _6373;
                                                    _6375 = _6373 + -1.0f;
                                                    _6376 = f16tof32(_6331);
                                                    _6377 = _6270 - _221;
                                                    _6378 = _6271 - _222;
                                                    _6379 = _6272 + _220;
                                                    _6380 = dot(float3(_6377, _6378, _6379), float3(_6377, _6378, _6379));
                                                    _6381 = rsqrt(_6380);
                                                    _6382 = _6381 * _6380;
                                                    _6383 = _6381 * _6377;
                                                    _6384 = _6381 * _6378;
                                                    _6385 = _6381 * _6379;
                                                    _6388 = max(0.0f, (_6382 - abs(_6350)));
                                                    _6389 = _6388 * f16tof32(((uint)((uint)(_6298) >> 16)));
                                                    _6390 = _6389 * _6389;
                                                    _6393 = saturate(1.0f - (_6390 * _6390));
                                                    _6404 = mad(_223, _6262, mad(_222, _6257, (_6252 * _221))) + _6267;
                                                    _6405 = dot(float3(_195, _196, _197), float3(_6383, _6384, _6385));
                                                    _6408 = saturate(1.0f - _6405) * f16tof32(_6325);
                                                    _6415 = ((_6404 * _195) * _6408) + _221;
                                                    _6416 = ((_6404 * _196) * _6408) + _222;
                                                    _6417 = ((_6404 * _197) * _6408) - _220;
                                                    _6429 = mad(_6417, _6262, mad(_6416, _6257, (_6415 * _6252))) + _6267;
                                                    _6430 = 1.0f / _6429;
                                                    _6431 = _6430 * (mad(_6417, _6260, mad(_6416, _6255, (_6415 * _6250))) + _6265);
                                                    _6432 = _6430 * (mad(_6417, _6261, mad(_6416, _6256, (_6415 * _6251))) + _6266);
                                                    _6435 = (_6431 * _6292) + _6293;
                                                    _6436 = (_6432 * _6292) + _6293;
                                                    _6439 = _6435 - saturate(_6435);
                                                    _6440 = _6436 - saturate(_6436);
                                                    _6447 = saturate((sqrt((_6439 * _6439) + (_6440 * _6440)) * _6294) + _6295);
                                                    _6449 = 1.0f - (_6447 * _6447);
                                                    _6455 = (_6449 * _6449) * (((float)((bool)(uint)((_6429 - f16tof32(((uint)((uint)(_6301) >> 16)))) > 0.0f))) * ((_6393 * _6393) / (select((_6350 < 0.0f), (_6390 * 16.0f), (_6388 * _6388)) + 1.0f)));
                                                    _6457 = ((_1463 & 3584) == 0);
                                                    do {
                                                      _7298 = 0.0f;
                                                      _7299 = 1.0f;
                                                      if (!((!(_6455 > 0.0f)) || _6457)) {
                                                        _6465 = 1.0f - saturate(f16tof32(_6301) * _6429);
                                                        _6466 = saturate(_6431);
                                                        _6467 = saturate(_6432);
                                                        do {
                                                          _6730 = 1.0f;
                                                          _6731 = 0.0f;
                                                          _6732 = _6465;
                                                          [branch]
                                                          if (!((_1463 & 1024) == 0)) {
                                                            _6472 = ((_6466 * _6375) + 0.5f) * _6374;
                                                            _6474 = ((_6467 * _6375) + 0.5f) * _6374;
                                                            _6475 = _6465 + f16tof32(((uint)((uint)(_6325) >> 16)));
                                                            Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6304) >> 16))];
                                                            _6478 = saturate(_6475);
                                                            _6482 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                            #if FIRSTLIGHT_ISFAST_ENABLED
                                                            if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                              _6491 = RenoDX_ISFASTShadowAngle(
                                                                  uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 6u);
                                                            } else {
                                                              _6491 = frac(frac(dot(float2(((_6482 * 32.665000915527344f) + _125), ((_6482 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            }
                                                            #else
                                                            _6491 = frac(frac(dot(float2(((_6482 * 32.665000915527344f) + _125), ((_6482 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            #endif
                                                            _6492 = sin(_6491);
                                                            _6493 = cos(_6491);
                                                            _6494 = cbSharedPerViewData.nFrameCounter & 3;
                                                            _6499 = sqrt((float((int)(_6494)) * 0.25f) + 0.125f) * _6370;
                                                            _6508 = (_global_7[min((uint)(((int)(0u + (_6494 * 2)))), 127u)]) * _6499;
                                                            _6509 = (_global_7[min((uint)(((int)(1u + (_6494 * 2)))), 127u)]) * _6499;
                                                            _6511 = -0.0f - _6492;
                                                            _6516 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6508, _6509), float2(_6493, _6492)) + _6472), (dot(float2(_6508, _6509), float2(_6511, _6493)) + _6474)));
                                                            _6521 = _6516.x - _6478;
                                                            _6523 = select((_6521 < 0.0f), 0.0f, 1.0f);
                                                            _6525 = _6516.y - _6478;
                                                            _6527 = select((_6525 < 0.0f), 0.0f, 1.0f);
                                                            _6531 = _6516.z - _6478;
                                                            _6533 = select((_6531 < 0.0f), 0.0f, 1.0f);
                                                            _6537 = _6516.w - _6478;
                                                            _6539 = select((_6537 < 0.0f), 0.0f, 1.0f);
                                                            _6546 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                            _6551 = sqrt((float((int)(_6546)) * 0.25f) + 0.125f) * _6370;
                                                            _6560 = (_global_7[min((uint)(((int)(0u + (_6546 * 2)))), 127u)]) * _6551;
                                                            _6561 = (_global_7[min((uint)(((int)(1u + (_6546 * 2)))), 127u)]) * _6551;
                                                            _6567 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6560, _6561), float2(_6493, _6492)) + _6472), (dot(float2(_6560, _6561), float2(_6511, _6493)) + _6474)));
                                                            _6572 = _6567.x - _6478;
                                                            _6574 = select((_6572 < 0.0f), 0.0f, 1.0f);
                                                            _6578 = _6567.y - _6478;
                                                            _6580 = select((_6578 < 0.0f), 0.0f, 1.0f);
                                                            _6584 = _6567.z - _6478;
                                                            _6586 = select((_6584 < 0.0f), 0.0f, 1.0f);
                                                            _6590 = _6567.w - _6478;
                                                            _6592 = select((_6590 < 0.0f), 0.0f, 1.0f);
                                                            _6599 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                            _6604 = sqrt((float((int)(_6599)) * 0.25f) + 0.125f) * _6370;
                                                            _6613 = (_global_7[min((uint)(((int)(0u + (_6599 * 2)))), 127u)]) * _6604;
                                                            _6614 = (_global_7[min((uint)(((int)(1u + (_6599 * 2)))), 127u)]) * _6604;
                                                            _6620 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6613, _6614), float2(_6493, _6492)) + _6472), (dot(float2(_6613, _6614), float2(_6511, _6493)) + _6474)));
                                                            _6625 = _6620.x - _6478;
                                                            _6627 = select((_6625 < 0.0f), 0.0f, 1.0f);
                                                            _6631 = _6620.y - _6478;
                                                            _6633 = select((_6631 < 0.0f), 0.0f, 1.0f);
                                                            _6637 = _6620.z - _6478;
                                                            _6639 = select((_6637 < 0.0f), 0.0f, 1.0f);
                                                            _6643 = _6620.w - _6478;
                                                            _6645 = select((_6643 < 0.0f), 0.0f, 1.0f);
                                                            _6652 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                            _6657 = sqrt((float((int)(_6652)) * 0.25f) + 0.125f) * _6370;
                                                            _6666 = (_global_7[min((uint)(((int)(0u + (_6652 * 2)))), 127u)]) * _6657;
                                                            _6667 = (_global_7[min((uint)(((int)(1u + (_6652 * 2)))), 127u)]) * _6657;
                                                            _6673 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6666, _6667), float2(_6493, _6492)) + _6472), (dot(float2(_6666, _6667), float2(_6511, _6493)) + _6474)));
                                                            _6678 = _6673.x - _6478;
                                                            _6680 = select((_6678 < 0.0f), 0.0f, 1.0f);
                                                            _6684 = _6673.y - _6478;
                                                            _6686 = select((_6684 < 0.0f), 0.0f, 1.0f);
                                                            _6690 = _6673.z - _6478;
                                                            _6692 = select((_6690 < 0.0f), 0.0f, 1.0f);
                                                            _6696 = _6673.w - _6478;
                                                            _6698 = select((_6696 < 0.0f), 0.0f, 1.0f);
                                                            _6699 = ((((((((((((((_6523 + _6527) + _6533) + _6539) + _6574) + _6580) + _6586) + _6592) + _6627) + _6633) + _6639) + _6645) + _6680) + _6686) + _6692) + _6698;
                                                            _6710 = (saturate(_6699 * 0.0625f) * 2.0f) + -1.0f;
                                                            _6716 = float((int)(((int)(uint)((int)(_6710 > 0.0f))) - ((int)(uint)((int)(_6710 < 0.0f)))));
                                                            _6718 = 1.0f - (_6716 * _6710);
                                                            _6720 = (_6718 * _6718) * _6718;
                                                            _6727 = 0.5f - ((_6716 * 0.5f) * ((1.0f - _6720) - ((_6718 - _6720) * saturate(((1.0f / _6478) * (1.0f / _6699)) * ((((((((((((((((_6523 * _6521) + (_6527 * _6525)) + (_6533 * _6531)) + (_6539 * _6537)) + (_6574 * _6572)) + (_6580 * _6578)) + (_6586 * _6584)) + (_6592 * _6590)) + (_6627 * _6625)) + (_6633 * _6631)) + (_6639 * _6637)) + (_6645 * _6643)) + (_6680 * _6678)) + (_6686 * _6684)) + (_6692 * _6690)) + (_6698 * _6696))))));
                                                            [branch]
                                                            if (!(_6376 < 1.0f)) {
                                                              _7200 = _6376;
                                                              _7201 = _6727;
                                                              do {
                                                                _7298 = _7200;
                                                                _7299 = _7201;
                                                                [branch]
                                                                if (!((_1463 & 2048) == 0)) {
                                                                  Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6307) >> 16))];
                                                                  _7207 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6431, _6432), 0.0f);
                                                                  if (_7207.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6307 & 65535))];
                                                                    _7214 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6431, _6432), 0.0f);
                                                                    _7228 = mad(saturate(((log2(_6382) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                    _7229 = max(9.999999747378752e-06f, _7207.x);
                                                                    _7230 = _7214.x / _7229;
                                                                    _7231 = _7214.y / _7229;
                                                                    _7233 = _7214.w / _7229;
                                                                    _7238 = ((0.375f - _7231) * 4.999999873689376e-06f) + _7231;
                                                                    _7241 = -0.0f - _7230;
                                                                    _7242 = mad(_7241, _7238, (_7214.z / _7229));
                                                                    _7244 = 1.0f / mad(_7241, _7230, _7238);
                                                                    _7245 = _7244 * _7242;
                                                                    _7250 = _7228 - _7230;
                                                                    _7255 = (((_7228 * _7228) - _7238) - (_7245 * _7250)) / mad((-0.0f - _7242), _7245, mad((-0.0f - _7238), _7238, (((0.375f - _7233) * 4.999999873689376e-06f) + _7233)));
                                                                    _7257 = (_7244 * _7250) - (_7255 * _7245);
                                                                    _7260 = 1.0f / _7255;
                                                                    _7261 = _7257 * _7260;
                                                                    _7266 = sqrt(((_7261 * _7261) * 0.25f) - ((1.0f - dot(float2(_7257, _7255), float2(_7230, _7238))) * _7260));
                                                                    _7268 = (_7261 * -0.5f) - _7266;
                                                                    _7270 = _7266 - (_7261 * 0.5f);
                                                                    _7272 = select((_7268 < _7228), 1.0f, 0.0f);
                                                                    _7277 = (_7272 + -0.05000000074505806f) / (_7268 - _7228);
                                                                    _7283 = (((select((_7270 < _7228), 1.0f, 0.0f) - _7272) / (_7270 - _7268)) - _7277) / (_7270 - _7228);
                                                                    _7285 = _7277 - (_7283 * _7268);
                                                                    _7298 = _7200;
                                                                    _7299 = (exp2((_7207.x * -1.4426950216293335f) * saturate((dot(float2(_7230, _7238), float2((_7285 - (_7283 * _7228)), _7283)) + 0.05000000074505806f) - (_7285 * _7228))) * _7201);
                                                                  } else {
                                                                    _7298 = _7200;
                                                                    _7299 = _7201;
                                                                  }
                                                                }
                                                                break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                              // Native completed depth-gather shadow bypasses the fallback path.
                                                              break;
                                                            } else {
                                                              _6730 = _6727;
                                                              _6731 = _6376;
                                                              _6732 = _6475;
                                                            }
                                                          }
                                                          _6735 = (_6466 * _6319) + _6321;
                                                          _6736 = (_6467 * _6320) + _6322;
                                                          do {
                                                            _7195 = 1.0f;
                                                            if (!((_1463 & 512) == 0)) {
                                                              Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                                              _6745 = saturate(_6732);
                                                              _6749 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _6758 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_63, _64), cbSharedPerViewData.nFrameCounter, 7u);
                                                              } else {
                                                                _6758 = frac(frac(dot(float2(((_6749 * 32.665000915527344f) + _125), ((_6749 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _6758 = frac(frac(dot(float2(((_6749 * 32.665000915527344f) + _125), ((_6749 * 11.8149995803833f) + _126)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _6759 = sin(_6758);
                                                              _6760 = cos(_6758);
                                                              _6765 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_6735, _6736), 0.0f))).x) > _6745), 1.0f, 0.0f);
                                                              _6766 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _6771 = sqrt((float((int)(_6766)) * 0.25f) + 0.125f) * _6371;
                                                              _6780 = (_global_7[min((uint)(((int)(0u + (_6766 * 2)))), 127u)]) * _6771;
                                                              _6781 = (_global_7[min((uint)(((int)(1u + (_6766 * 2)))), 127u)]) * _6771;
                                                              _6783 = -0.0f - _6759;
                                                              _6785 = dot(float2(_6780, _6781), float2(_6760, _6759)) + _6735;
                                                              _6786 = dot(float2(_6780, _6781), float2(_6783, _6760)) + _6736;
                                                              _6788 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6785, _6786));
                                                              _6792 = _6785 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                              _6793 = _6786 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                              _6796 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6321);
                                                              _6797 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6322);
                                                              _6802 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6319 + _6321)) + 0.5f);
                                                              _6803 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6320 + _6322)) + 0.5f);
                                                              _6806 = floor(_6792 + -0.5f);
                                                              _6807 = floor(_6793 + 0.5f);
                                                              _6809 = floor(_6792 + 0.5f);
                                                              _6811 = floor(_6793 + -0.5f);
                                                              _6812 = (_6806 < _6796);
                                                              _6813 = (_6807 < _6797);
                                                              do {
                                                                if (!(_6812 || _6813)) {
                                                                  if ((_6806 >= _6802) || (_6807 >= _6803)) {
                                                                    _6822 = _6765;
                                                                  } else {
                                                                    _6822 = _6788.x;
                                                                  }
                                                                } else {
                                                                  _6822 = _6765;
                                                                }
                                                                _6823 = (_6809 < _6796);
                                                                do {
                                                                  if (!(_6823 || _6813)) {
                                                                    if ((_6809 >= _6802) || (_6807 >= _6803)) {
                                                                      _6831 = _6765;
                                                                    } else {
                                                                      _6831 = _6788.y;
                                                                    }
                                                                  } else {
                                                                    _6831 = _6765;
                                                                  }
                                                                  _6832 = (_6811 < _6797);
                                                                  do {
                                                                    if (!(_6823 || _6832)) {
                                                                      if ((_6809 >= _6802) || (_6811 >= _6803)) {
                                                                        _6840 = _6765;
                                                                      } else {
                                                                        _6840 = _6788.z;
                                                                      }
                                                                    } else {
                                                                      _6840 = _6765;
                                                                    }
                                                                    do {
                                                                      if (!(_6812 || _6832)) {
                                                                        if ((_6806 >= _6802) || (_6811 >= _6803)) {
                                                                          _6848 = _6765;
                                                                        } else {
                                                                          _6848 = _6788.w;
                                                                        }
                                                                      } else {
                                                                        _6848 = _6765;
                                                                      }
                                                                      _6849 = _6822 - _6745;
                                                                      _6851 = select((_6849 < 0.0f), 0.0f, 1.0f);
                                                                      _6853 = _6831 - _6745;
                                                                      _6855 = select((_6853 < 0.0f), 0.0f, 1.0f);
                                                                      _6859 = _6840 - _6745;
                                                                      _6861 = select((_6859 < 0.0f), 0.0f, 1.0f);
                                                                      _6865 = _6848 - _6745;
                                                                      _6867 = select((_6865 < 0.0f), 0.0f, 1.0f);
                                                                      _6874 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _6879 = sqrt((float((int)(_6874)) * 0.25f) + 0.125f) * _6371;
                                                                      _6888 = (_global_7[min((uint)(((int)(0u + (_6874 * 2)))), 127u)]) * _6879;
                                                                      _6889 = (_global_7[min((uint)(((int)(1u + (_6874 * 2)))), 127u)]) * _6879;
                                                                      _6892 = dot(float2(_6888, _6889), float2(_6760, _6759)) + _6735;
                                                                      _6893 = dot(float2(_6888, _6889), float2(_6783, _6760)) + _6736;
                                                                      _6895 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6892, _6893));
                                                                      _6899 = _6892 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _6900 = _6893 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _6903 = floor(_6899 + -0.5f);
                                                                      _6904 = floor(_6900 + 0.5f);
                                                                      _6906 = floor(_6899 + 0.5f);
                                                                      _6908 = floor(_6900 + -0.5f);
                                                                      _6909 = (_6903 < _6796);
                                                                      _6910 = (_6904 < _6797);
                                                                      do {
                                                                        if (!(_6909 || _6910)) {
                                                                          if ((_6903 >= _6802) || (_6904 >= _6803)) {
                                                                            _6919 = _6765;
                                                                          } else {
                                                                            _6919 = _6895.x;
                                                                          }
                                                                        } else {
                                                                          _6919 = _6765;
                                                                        }
                                                                        _6920 = (_6906 < _6796);
                                                                        do {
                                                                          if (!(_6920 || _6910)) {
                                                                            if ((_6906 >= _6802) || (_6904 >= _6803)) {
                                                                              _6928 = _6765;
                                                                            } else {
                                                                              _6928 = _6895.y;
                                                                            }
                                                                          } else {
                                                                            _6928 = _6765;
                                                                          }
                                                                          _6929 = (_6908 < _6797);
                                                                          do {
                                                                            if (!(_6920 || _6929)) {
                                                                              if ((_6906 >= _6802) || (_6908 >= _6803)) {
                                                                                _6937 = _6765;
                                                                              } else {
                                                                                _6937 = _6895.z;
                                                                              }
                                                                            } else {
                                                                              _6937 = _6765;
                                                                            }
                                                                            do {
                                                                              if (!(_6909 || _6929)) {
                                                                                if ((_6903 >= _6802) || (_6908 >= _6803)) {
                                                                                  _6945 = _6765;
                                                                                } else {
                                                                                  _6945 = _6895.w;
                                                                                }
                                                                              } else {
                                                                                _6945 = _6765;
                                                                              }
                                                                              _6946 = _6919 - _6745;
                                                                              _6948 = select((_6946 < 0.0f), 0.0f, 1.0f);
                                                                              _6952 = _6928 - _6745;
                                                                              _6954 = select((_6952 < 0.0f), 0.0f, 1.0f);
                                                                              _6958 = _6937 - _6745;
                                                                              _6960 = select((_6958 < 0.0f), 0.0f, 1.0f);
                                                                              _6964 = _6945 - _6745;
                                                                              _6966 = select((_6964 < 0.0f), 0.0f, 1.0f);
                                                                              _6973 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _6978 = sqrt((float((int)(_6973)) * 0.25f) + 0.125f) * _6371;
                                                                              _6987 = (_global_7[min((uint)(((int)(0u + (_6973 * 2)))), 127u)]) * _6978;
                                                                              _6988 = (_global_7[min((uint)(((int)(1u + (_6973 * 2)))), 127u)]) * _6978;
                                                                              _6991 = dot(float2(_6987, _6988), float2(_6760, _6759)) + _6735;
                                                                              _6992 = dot(float2(_6987, _6988), float2(_6783, _6760)) + _6736;
                                                                              _6994 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6991, _6992));
                                                                              _6998 = _6991 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _6999 = _6992 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _7002 = floor(_6998 + -0.5f);
                                                                              _7003 = floor(_6999 + 0.5f);
                                                                              _7005 = floor(_6998 + 0.5f);
                                                                              _7007 = floor(_6999 + -0.5f);
                                                                              _7008 = (_7002 < _6796);
                                                                              _7009 = (_7003 < _6797);
                                                                              do {
                                                                                if (!(_7008 || _7009)) {
                                                                                  if ((_7002 >= _6802) || (_7003 >= _6803)) {
                                                                                    _7018 = _6765;
                                                                                  } else {
                                                                                    _7018 = _6994.x;
                                                                                  }
                                                                                } else {
                                                                                  _7018 = _6765;
                                                                                }
                                                                                _7019 = (_7005 < _6796);
                                                                                do {
                                                                                  if (!(_7019 || _7009)) {
                                                                                    if ((_7005 >= _6802) || (_7003 >= _6803)) {
                                                                                      _7027 = _6765;
                                                                                    } else {
                                                                                      _7027 = _6994.y;
                                                                                    }
                                                                                  } else {
                                                                                    _7027 = _6765;
                                                                                  }
                                                                                  _7028 = (_7007 < _6797);
                                                                                  do {
                                                                                    if (!(_7019 || _7028)) {
                                                                                      if ((_7005 >= _6802) || (_7007 >= _6803)) {
                                                                                        _7036 = _6765;
                                                                                      } else {
                                                                                        _7036 = _6994.z;
                                                                                      }
                                                                                    } else {
                                                                                      _7036 = _6765;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_7008 || _7028)) {
                                                                                        if ((_7002 >= _6802) || (_7007 >= _6803)) {
                                                                                          _7044 = _6765;
                                                                                        } else {
                                                                                          _7044 = _6994.w;
                                                                                        }
                                                                                      } else {
                                                                                        _7044 = _6765;
                                                                                      }
                                                                                      _7045 = _7018 - _6745;
                                                                                      _7047 = select((_7045 < 0.0f), 0.0f, 1.0f);
                                                                                      _7051 = _7027 - _6745;
                                                                                      _7053 = select((_7051 < 0.0f), 0.0f, 1.0f);
                                                                                      _7057 = _7036 - _6745;
                                                                                      _7059 = select((_7057 < 0.0f), 0.0f, 1.0f);
                                                                                      _7063 = _7044 - _6745;
                                                                                      _7065 = select((_7063 < 0.0f), 0.0f, 1.0f);
                                                                                      _7072 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _7077 = sqrt((float((int)(_7072)) * 0.25f) + 0.125f) * _6371;
                                                                                      _7086 = (_global_7[min((uint)(((int)(0u + (_7072 * 2)))), 127u)]) * _7077;
                                                                                      _7087 = (_global_7[min((uint)(((int)(1u + (_7072 * 2)))), 127u)]) * _7077;
                                                                                      _7090 = dot(float2(_7086, _7087), float2(_6760, _6759)) + _6735;
                                                                                      _7091 = dot(float2(_7086, _7087), float2(_6783, _6760)) + _6736;
                                                                                      _7093 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7090, _7091));
                                                                                      _7097 = _7090 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _7098 = _7091 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _7101 = floor(_7097 + -0.5f);
                                                                                      _7102 = floor(_7098 + 0.5f);
                                                                                      _7104 = floor(_7097 + 0.5f);
                                                                                      _7106 = floor(_7098 + -0.5f);
                                                                                      _7107 = (_7101 < _6796);
                                                                                      _7108 = (_7102 < _6797);
                                                                                      do {
                                                                                        if (!(_7107 || _7108)) {
                                                                                          if ((_7101 >= _6802) || (_7102 >= _6803)) {
                                                                                            _7117 = _6765;
                                                                                          } else {
                                                                                            _7117 = _7093.x;
                                                                                          }
                                                                                        } else {
                                                                                          _7117 = _6765;
                                                                                        }
                                                                                        _7118 = (_7104 < _6796);
                                                                                        do {
                                                                                          if (!(_7118 || _7108)) {
                                                                                            if ((_7104 >= _6802) || (_7102 >= _6803)) {
                                                                                              _7126 = _6765;
                                                                                            } else {
                                                                                              _7126 = _7093.y;
                                                                                            }
                                                                                          } else {
                                                                                            _7126 = _6765;
                                                                                          }
                                                                                          _7127 = (_7106 < _6797);
                                                                                          do {
                                                                                            if (!(_7118 || _7127)) {
                                                                                              if ((_7104 >= _6802) || (_7106 >= _6803)) {
                                                                                                _7135 = _6765;
                                                                                              } else {
                                                                                                _7135 = _7093.z;
                                                                                              }
                                                                                            } else {
                                                                                              _7135 = _6765;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_7107 || _7127)) {
                                                                                                if ((_7101 >= _6802) || (_7106 >= _6803)) {
                                                                                                  _7143 = _6765;
                                                                                                } else {
                                                                                                  _7143 = _7093.w;
                                                                                                }
                                                                                              } else {
                                                                                                _7143 = _6765;
                                                                                              }
                                                                                              _7144 = _7117 - _6745;
                                                                                              _7146 = select((_7144 < 0.0f), 0.0f, 1.0f);
                                                                                              _7150 = _7126 - _6745;
                                                                                              _7152 = select((_7150 < 0.0f), 0.0f, 1.0f);
                                                                                              _7156 = _7135 - _6745;
                                                                                              _7158 = select((_7156 < 0.0f), 0.0f, 1.0f);
                                                                                              _7162 = _7143 - _6745;
                                                                                              _7164 = select((_7162 < 0.0f), 0.0f, 1.0f);
                                                                                              _7165 = ((((((((((((((_6855 + _6851) + _6861) + _6867) + _6948) + _6954) + _6960) + _6966) + _7047) + _7053) + _7059) + _7065) + _7146) + _7152) + _7158) + _7164;
                                                                                              _7176 = (saturate(_7165 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _7182 = float((int)(((int)(uint)((int)(_7176 > 0.0f))) - ((int)(uint)((int)(_7176 < 0.0f)))));
                                                                                              _7184 = 1.0f - (_7182 * _7176);
                                                                                              _7186 = (_7184 * _7184) * _7184;
                                                                                              _7195 = (0.5f - ((_7182 * 0.5f) * ((1.0f - _7186) - ((_7184 - _7186) * saturate(((1.0f / _6745) * (1.0f / _7165)) * ((((((((((((((((_6855 * _6853) + (_6851 * _6849)) + (_6861 * _6859)) + (_6867 * _6865)) + (_6948 * _6946)) + (_6954 * _6952)) + (_6960 * _6958)) + (_6966 * _6964)) + (_7047 * _7045)) + (_7053 * _7051)) + (_7059 * _7057)) + (_7065 * _7063)) + (_7146 * _7144)) + (_7152 * _7150)) + (_7158 * _7156)) + (_7164 * _7162)))))));
                                                                                            } while (false);
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
                                                            _7200 = _6731;
                                                            _7201 = (lerp(_7195, _6730, _6731));
                                                            [branch]
                                                            if (!((_1463 & 2048) == 0)) {
                                                              Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6307) >> 16))];
                                                              _7207 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6431, _6432), 0.0f);
                                                              if (_7207.x > 0.0f) {
                                                                Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6307 & 65535))];
                                                                _7214 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6431, _6432), 0.0f);
                                                                _7228 = mad(saturate(((log2(_6382) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                _7229 = max(9.999999747378752e-06f, _7207.x);
                                                                _7230 = _7214.x / _7229;
                                                                _7231 = _7214.y / _7229;
                                                                _7233 = _7214.w / _7229;
                                                                _7238 = ((0.375f - _7231) * 4.999999873689376e-06f) + _7231;
                                                                _7241 = -0.0f - _7230;
                                                                _7242 = mad(_7241, _7238, (_7214.z / _7229));
                                                                _7244 = 1.0f / mad(_7241, _7230, _7238);
                                                                _7245 = _7244 * _7242;
                                                                _7250 = _7228 - _7230;
                                                                _7255 = (((_7228 * _7228) - _7238) - (_7245 * _7250)) / mad((-0.0f - _7242), _7245, mad((-0.0f - _7238), _7238, (((0.375f - _7233) * 4.999999873689376e-06f) + _7233)));
                                                                _7257 = (_7244 * _7250) - (_7255 * _7245);
                                                                _7260 = 1.0f / _7255;
                                                                _7261 = _7257 * _7260;
                                                                _7266 = sqrt(((_7261 * _7261) * 0.25f) - ((1.0f - dot(float2(_7257, _7255), float2(_7230, _7238))) * _7260));
                                                                _7268 = (_7261 * -0.5f) - _7266;
                                                                _7270 = _7266 - (_7261 * 0.5f);
                                                                _7272 = select((_7268 < _7228), 1.0f, 0.0f);
                                                                _7277 = (_7272 + -0.05000000074505806f) / (_7268 - _7228);
                                                                _7283 = (((select((_7270 < _7228), 1.0f, 0.0f) - _7272) / (_7270 - _7268)) - _7277) / (_7270 - _7228);
                                                                _7285 = _7277 - (_7283 * _7268);
                                                                _7298 = _7200;
                                                                _7299 = (exp2((_7207.x * -1.4426950216293335f) * saturate((dot(float2(_7230, _7238), float2((_7285 - (_7283 * _7228)), _7283)) + 0.05000000074505806f) - (_7285 * _7228))) * _7201);
                                                              } else {
                                                                _7298 = _7200;
                                                                _7299 = _7201;
                                                              }
                                                            } else {
                                                              _7298 = _7200;
                                                              _7299 = _7201;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      }
                                                      do {
                                                        _7320 = _6333;
                                                        _7321 = _6334;
                                                        _7322 = _6336;
                                                        [branch]
                                                        if (!(_6354 == 0)) {
                                                          Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6354)))];
                                                          _7312 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6431 * f16tof32(((uint)((uint)(_6313) >> 16)))) + f16tof32(((uint)((uint)(_6316) >> 16)))), ((_6432 * f16tof32(_6313)) + f16tof32(_6316))), 0.0f);
                                                          _7320 = (_7312.x * _6333);
                                                          _7321 = (_7312.y * _6334);
                                                          _7322 = (_7312.z * _6336);
                                                        }
                                                        _7323 = _7299 * _6455;
                                                        [branch]
                                                        if (!(_7323 == 0.0f)) {
                                                          do {
                                                            _7341 = GetDeferredSoftShadowChannel(_1466);
                                                            if (_7341 < 0) {
                                                                  _7366 = _7323;
                                                                  do {
                                                                    _8367 = _1451;
                                                                    _8368 = _1452;
                                                                    _8369 = _1453;
                                                                    _8370 = _1454;
                                                                    _8371 = _1455;
                                                                    _8372 = _1456;
                                                                    [branch]
                                                                    if (_7366 > 0.0f) {
                                                                      do {
                                                                        _7472 = _7320;
                                                                        _7473 = _7321;
                                                                        _7474 = _7322;
                                                                        if (!(((_6310 & 1) == 0) || _6457)) {
                                                                          _7382 = max(max(_7320, _7321), _7322);
                                                                          do {
                                                                            _7392 = _7320;
                                                                            _7393 = _7321;
                                                                            _7394 = _7322;
                                                                            if (_7382 > 0.0f) {
                                                                              _7392 = saturate(_7320 / _7382);
                                                                              _7393 = saturate(_7321 / _7382);
                                                                              _7394 = saturate(_7322 / _7382);
                                                                            }
                                                                            _7395 = (_7393 < _7394);
                                                                            _7396 = select(_7395, _7394, _7393);
                                                                            _7397 = select(_7395, _7393, _7394);
                                                                            _7398 = select(_7395, -1.0f, 0.0f);
                                                                            _7399 = (_7392 < _7396);
                                                                            _7401 = select(_7399, _7396, _7392);
                                                                            _7402 = select(_7399, _7392, _7396);
                                                                            _7406 = _7401 - select((_7402 < _7397), _7402, _7397);
                                                                            _7412 = abs(select(_7399, (-0.3333333432674408f - _7398), _7398) + ((_7402 - _7397) / ((_7406 * 6.0f) + 9.999999682655225e-21f)));
                                                                            do {
                                                                              _7425 = _7412;
                                                                              if (_7412 < 0.6666666865348816f) {
                                                                                _7425 = ((saturate(((float)((uint)((uint)(((uint)(_6310) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7412 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7412)) + _7412);
                                                                              }
                                                                              _7426 = saturate((_7406 / (_7401 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6310) >> 1) & 255)))) * 0.003921499941498041f));
                                                                              _7427 = saturate(_7401);
                                                                              do {
                                                                                _7454 = _7427;
                                                                                _7455 = _7427;
                                                                                _7456 = _7427;
                                                                                if (!(_7426 <= 0.0f)) {
                                                                                  _7430 = saturate(_7425);
                                                                                  _7434 = select(((_7430 * 360.0f) >= 360.0f), 0.0f, (_7430 * 6.0f));
                                                                                  _7435 = int(_7434);
                                                                                  _7437 = _7434 - float((int)(_7435));
                                                                                  _7439 = _7427 * (1.0f - _7426);
                                                                                  _7442 = (1.0f - (_7437 * _7426)) * _7427;
                                                                                  _7446 = (1.0f - ((1.0f - _7437) * _7426)) * _7427;
                                                                                  switch (_7435) {
                                                                                    case 0: {
                                                                                      _7454 = _7427;
                                                                                      _7455 = _7446;
                                                                                      _7456 = _7439;
                                                                                      break;
                                                                                    }
                                                                                    case 1: {
                                                                                      _7454 = _7442;
                                                                                      _7455 = _7427;
                                                                                      _7456 = _7439;
                                                                                      break;
                                                                                    }
                                                                                    case 2: {
                                                                                      _7454 = _7439;
                                                                                      _7455 = _7427;
                                                                                      _7456 = _7446;
                                                                                      break;
                                                                                    }
                                                                                    case 3: {
                                                                                      _7454 = _7439;
                                                                                      _7455 = _7442;
                                                                                      _7456 = _7427;
                                                                                      break;
                                                                                    }
                                                                                    case 4: {
                                                                                      _7454 = _7446;
                                                                                      _7455 = _7439;
                                                                                      _7456 = _7427;
                                                                                      break;
                                                                                    }
                                                                                    case 5: {
                                                                                      _7454 = _7427;
                                                                                      _7455 = _7439;
                                                                                      _7456 = _7442;
                                                                                      break;
                                                                                    }
                                                                                    default: {
                                                                                      _7454 = 0.0f;
                                                                                      _7455 = 0.0f;
                                                                                      _7456 = 0.0f;
                                                                                      break;
                                                                                    }
                                                                                  }
                                                                                }
                                                                                _7457 = _7454 * _7382;
                                                                                _7458 = _7455 * _7382;
                                                                                _7459 = _7456 * _7382;
                                                                                _7461 = saturate(_7299 * 1.0101009607315063f);
                                                                                _7472 = ((_7461 * (_7320 - _7457)) + _7457);
                                                                                _7473 = ((_7461 * (_7321 - _7458)) + _7458);
                                                                                _7474 = (lerp(_7459, _7322, _7461));
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        }
                                                                        do {
                                                                          _7510 = _7366;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _7481 = srvLightMappingData[_1466];
                                                                            if (!(_7481 == -1)) {
                                                                              _7486 = srvLightIndexData[_7481].nLayerIndex;
                                                                              _7488 = srvLightIndexData[_7481].vAtlasOrigin.x;
                                                                              _7489 = srvLightIndexData[_7481].vAtlasOrigin.y;
                                                                              _7491 = srvLightIndexData[_7481].vScreenOrigin.x;
                                                                              _7492 = srvLightIndexData[_7481].vScreenOrigin.y;
                                                                              _7501 = ((int)(_7486 * 5)) & 31;
                                                                              _7510 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7488 + _63) - _7491)), ((int)((_7489 + _64) - _7492)), 0)))).x) & ((int)(31 << _7501)))) >> _7501)) >> 1)))) * 0.06666667014360428f) * _7366);
                                                                            } else {
                                                                              _7510 = _7366;
                                                                            }
                                                                          }
                                                                          _7514 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _7517 = select(_7514, (_7510 * _1213), _7510);
                                                                          _7519 = _6383 * _6382;
                                                                          _7520 = _6384 * _6382;
                                                                          _7521 = _6385 * _6382;
                                                                          _7522 = _6344 * _6275;
                                                                          _7523 = _6344 * _6276;
                                                                          _7524 = _6344 * _6277;
                                                                          _7525 = _7519 + _7522;
                                                                          _7526 = _7520 + _7523;
                                                                          _7527 = _7521 + _7524;
                                                                          _7528 = _7519 - _7522;
                                                                          _7529 = _7520 - _7523;
                                                                          _7530 = _7521 - _7524;
                                                                          _7531 = (_6344 > 0.0f);
                                                                          _7532 = dot(float3(_7525, _7526, _7527), float3(_7525, _7526, _7527));
                                                                          _7533 = rsqrt(_7532);
                                                                          do {
                                                                            [branch]
                                                                            if (_7531) {
                                                                              _7536 = rsqrt(dot(float3(_7528, _7529, _7530), float3(_7528, _7529, _7530)));
                                                                              _7537 = _7536 * _7533;
                                                                              _7539 = dot(float3(_7525, _7526, _7527), float3(_7528, _7529, _7530)) * _7537;
                                                                              _7558 = (_7537 / ((_7537 + 0.5f) + (_7539 * 0.5f)));
                                                                              _7559 = (((dot(float3(_195, _196, _197), float3(_7528, _7529, _7530)) * _7536) + (dot(float3(_195, _196, _197), float3(_7525, _7526, _7527)) * _7533)) * 0.5f);
                                                                              _7560 = _7539;
                                                                            } else {
                                                                              _7558 = (1.0f / (_7532 + 1.0f));
                                                                              _7559 = dot(float3(_195, _196, _197), float3((_7533 * _7525), (_7533 * _7526), (_7533 * _7527)));
                                                                              _7560 = 1.0f;
                                                                            }
                                                                            do {
                                                                              _7576 = _7559;
                                                                              if (_6346 > 0.0f) {
                                                                                _7566 = sqrt(saturate((_6346 * _6346) * _7558));
                                                                                if (_7559 < _7566) {
                                                                                  _7571 = max(_7559, (-0.0f - _7566)) + _7566;
                                                                                  _7576 = ((_7571 * _7571) / (_7566 * 4.0f));
                                                                                } else {
                                                                                  _7576 = _7559;
                                                                                }
                                                                              }
                                                                              do {
                                                                                _7636 = _7525;
                                                                                _7637 = _7526;
                                                                                _7638 = _7527;
                                                                                if (_7531) {
                                                                                  _7578 = -0.0f - _394;
                                                                                  _7579 = -0.0f - _395;
                                                                                  _7580 = -0.0f - _393;
                                                                                  _7582 = dot(float3(_7578, _7579, _7580), float3(_195, _196, _197)) * 2.0f;
                                                                                  _7586 = _7578 - (_7582 * _195);
                                                                                  _7587 = _7579 - (_7582 * _196);
                                                                                  _7588 = _7580 - (_7582 * _197);
                                                                                  _7589 = _7528 - _7525;
                                                                                  _7590 = _7529 - _7526;
                                                                                  _7591 = _7530 - _7527;
                                                                                  _7592 = dot(float3(_7586, _7587, _7588), float3(_7589, _7590, _7591));
                                                                                  _7598 = sqrt(((_7589 * _7589) + (_7590 * _7590)) + (_7591 * _7591));
                                                                                  _7607 = saturate(((dot(float3(_7586, _7587, _7588), float3(_7525, _7526, _7527)) * _7592) - dot(float3(_7525, _7526, _7527), float3(_7589, _7590, _7591))) / ((_7598 * _7598) - (_7592 * _7592)));
                                                                                  _7611 = (_7607 * _7589) + _7525;
                                                                                  _7612 = (_7607 * _7590) + _7526;
                                                                                  _7613 = (_7607 * _7591) + _7527;
                                                                                  _7614 = dot(float3(_7611, _7612, _7613), float3(_7586, _7587, _7588));
                                                                                  _7618 = (_7614 * _7586) - _7611;
                                                                                  _7619 = (_7614 * _7587) - _7612;
                                                                                  _7620 = (_7614 * _7588) - _7613;
                                                                                  _7628 = saturate(0.009999999776482582f / sqrt(((_7618 * _7618) + (_7619 * _7619)) + (_7620 * _7620)));
                                                                                  _7636 = ((_7628 * _7618) + _7611);
                                                                                  _7637 = ((_7628 * _7619) + _7612);
                                                                                  _7638 = ((_7628 * _7620) + _7613);
                                                                                }
                                                                                _7640 = rsqrt(dot(float3(_7636, _7637, _7638), float3(_7636, _7637, _7638)));
                                                                                _7641 = _7640 * _7636;
                                                                                _7642 = _7640 * _7637;
                                                                                _7643 = _7640 * _7638;
                                                                                _7644 = _206 * _206;
                                                                                _7648 = saturate((_6346 * (1.0f - _7644)) * _7640);
                                                                                _7650 = saturate(_7640 * f16tof32(_6289));
                                                                                _7652 = rsqrt(dot(float3(_7519, _7520, _7521), float3(_7519, _7520, _7521)));
                                                                                _7656 = dot(float3(_195, _196, _197), float3(_7641, _7642, _7643));
                                                                                _7657 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                                                _7658 = dot(float3(_394, _395, _393), float3(_7641, _7642, _7643));
                                                                                _7661 = rsqrt((_7658 * 2.0f) + 2.0f);
                                                                                _7668 = (_7648 > 0.0f);
                                                                                do {
                                                                                  _7759 = saturate((_7661 * _7658) + _7661);
                                                                                  _7760 = saturate(_7661 * (_7657 + _7656));
                                                                                  if (_7668) {
                                                                                    _7672 = sqrt(1.0f - (_7648 * _7648));
                                                                                    _7674 = (_7656 * 2.0f) * _7657;
                                                                                    _7675 = _7674 - _7658;
                                                                                    if (!(!(_7675 >= _7672))) {
                                                                                      _7759 = abs(_7657);
                                                                                      _7760 = 1.0f;
                                                                                    } else {
                                                                                      _7683 = rsqrt(1.0f - (_7675 * _7675)) * _7648;
                                                                                      _7686 = _7683 * (_7657 - (_7675 * _7656));
                                                                                      _7687 = _7657 * _7657;
                                                                                      _7692 = _7683 * (((_7687 * 2.0f) + -1.0f) - (_7675 * _7658));
                                                                                      _7701 = sqrt(saturate((((1.0f - (_7656 * _7656)) - _7687) - (_7658 * _7658)) + (_7674 * _7658)));
                                                                                      _7702 = _7701 * _7683;
                                                                                      _7705 = ((_7657 * 2.0f) * _7683) * _7701;
                                                                                      _7707 = (_7672 * _7656) + _7657;
                                                                                      _7708 = _7707 + _7686;
                                                                                      _7709 = _7672 * _7658;
                                                                                      _7711 = (_7709 + 1.0f) + _7692;
                                                                                      _7712 = _7702 * _7711;
                                                                                      _7713 = _7708 * _7711;
                                                                                      _7714 = _7705 * _7708;
                                                                                      _7719 = (((_7708 * 0.25f) * _7705) - (_7712 * 0.5f)) * _7713;
                                                                                      _7733 = (((_7714 - (_7712 * 2.0f)) * _7714) + (_7712 * _7712)) + ((((-0.5f - ((_7711 + _7709) * 0.5f)) * _7713) + ((_7711 * _7711) * _7707)) * _7708);
                                                                                      _7738 = (_7719 * 2.0f) / ((_7733 * _7733) + (_7719 * _7719));
                                                                                      _7739 = _7733 * _7738;
                                                                                      _7741 = 1.0f - (_7719 * _7738);
                                                                                      _7747 = ((_7739 * _7705) + _7709) + (_7741 * _7692);
                                                                                      _7750 = rsqrt((_7747 * 2.0f) + 2.0f);
                                                                                      _7759 = saturate((_7747 * _7750) + _7750);
                                                                                      _7760 = saturate(((_7707 + (_7739 * _7702)) + (_7741 * _7686)) * _7750);
                                                                                    }
                                                                                  }
                                                                                  _7761 = saturate(_7576);
                                                                                  _7763 = _7644 * _7644;
                                                                                  do {
                                                                                    _7773 = _7763;
                                                                                    if (_7650 > 0.0f) {
                                                                                      _7773 = saturate(((_7650 * _7650) / ((_7759 * 3.5999999046325684f) + 0.4000000059604645f)) + _7763);
                                                                                    }
                                                                                    do {
                                                                                      _7785 = _7773;
                                                                                      _7786 = 1.0f;
                                                                                      if (_7668) {
                                                                                        _7782 = (((_7648 * 0.25f) * ((sqrt(_7773) * 3.0f) + _7648)) / (_7759 + 0.0010000000474974513f)) + _7773;
                                                                                        _7785 = _7782;
                                                                                        _7786 = (_7773 / _7782);
                                                                                      }
                                                                                      do {
                                                                                        _7806 = _7786;
                                                                                        if (_7560 < 1.0f) {
                                                                                          _7793 = sqrt((1.000100016593933f - _7560) / max(9.999999974752427e-07f, (_7560 + 1.0f)));
                                                                                          _7806 = (sqrt(_7785 / ((((_7793 * 0.25f) * ((sqrt(_7785) * 3.0f) + _7793)) / (_7759 + 0.0010000000474974513f)) + _7785)) * _7786);
                                                                                        }
                                                                                        _7810 = (((_7773 * _7760) - _7760) * _7760) + 1.0f;
                                                                                        _7815 = saturate(abs(_7657) + 9.999999747378752e-06f);
                                                                                        _7816 = sqrt(_7773);
                                                                                        _7817 = 1.0f - _7816;
                                                                                        _7829 = saturate((dot(float3(_195, _196, _197), float3((_7652 * _7519), (_7652 * _7520), (_7652 * _7521))) + _6343) / (_6343 + 1.0f));
                                                                                        _7832 = ((_7806 * _7761) * (_7773 / (_7810 * _7810))) * (0.5f / ((((_7817 * _7815) + _7816) * _7761) + (((_7817 * _7761) + _7816) * _7815)));
                                                                                        _7833 = _7472 * _1513;
                                                                                        _7834 = _7473 * _1513;
                                                                                        _7835 = _7474 * _1513;
                                                                                        do {
                                                                                          _7871 = _1454;
                                                                                          _7872 = _1455;
                                                                                          _7873 = _1456;
                                                                                          if (_6340 > 0.0f) {
                                                                                            _7853 = (exp2(log2(1.0f - saturate(_7759)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                            _7854 = select(_7514, (_7510 * _1213), _7510) * _6340;
                                                                                            _7871 = (((((_7833 * _1082) * _7854) * _7853) * _7832) + _1454);
                                                                                            _7872 = (((((_7834 * _1082) * _7854) * _7853) * _7832) + _1455);
                                                                                            _7873 = (((((_7835 * _1082) * _7854) * _7853) * _7832) + _1456);
                                                                                          }
                                                                                          _7879 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_6383, _6384, _6385)));
                                                                                          _7882 = 1.0f - ((_7879 * _7879) * 0.6399999856948853f);
                                                                                          _7887 = saturate(0.30000001192092896f - _6405) * (0.36000001430511475f / (_7882 * _7882));
                                                                                          _7888 = _6455 * _1513;
                                                                                          _8367 = (((_7517 * _7833) * _7829) + _1451);
                                                                                          _8368 = (((_7517 * _7834) * _7829) + _1452);
                                                                                          _8369 = (((_7517 * _7835) * _7829) + _1453);
                                                                                          _8370 = ((((_167 * _212) * _7888) * _7887) + _7871);
                                                                                          _8371 = ((((_167 * _213) * _7888) * _7887) + _7872);
                                                                                          _8372 = ((((_214 * _167) * _7888) * _7887) + _7873);
                                                                                        } while (false);
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
                                                            _7344 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_63, _64, 0));
                                                            do {
                                                              if (_7341 == 0) {
                                                                _7358 = _7344.x;
                                                              } else {
                                                                if (_7341 == 1) {
                                                                  _7358 = _7344.y;
                                                                } else {
                                                                  if (_7341 == 2) {
                                                                    _7358 = _7344.z;
                                                                  } else {
                                                                    _7358 = _7344.w;
                                                                  }
                                                                }
                                                              }
                                                              _7366 = ((((_7298 * _7298) * ((_7358 * _7358) + -1.0f)) + 1.0f) * _6455);
                                                              [branch]
                                                              if (_7366 > 0.0f) {
                                                                do {
                                                                  _7472 = _7320;
                                                                  _7473 = _7321;
                                                                  _7474 = _7322;
                                                                  if (!(((_6310 & 1) == 0) || _6457)) {
                                                                    _7382 = max(max(_7320, _7321), _7322);
                                                                    do {
                                                                      _7392 = _7320;
                                                                      _7393 = _7321;
                                                                      _7394 = _7322;
                                                                      if (_7382 > 0.0f) {
                                                                        _7392 = saturate(_7320 / _7382);
                                                                        _7393 = saturate(_7321 / _7382);
                                                                        _7394 = saturate(_7322 / _7382);
                                                                      }
                                                                      _7395 = (_7393 < _7394);
                                                                      _7396 = select(_7395, _7394, _7393);
                                                                      _7397 = select(_7395, _7393, _7394);
                                                                      _7398 = select(_7395, -1.0f, 0.0f);
                                                                      _7399 = (_7392 < _7396);
                                                                      _7401 = select(_7399, _7396, _7392);
                                                                      _7402 = select(_7399, _7392, _7396);
                                                                      _7406 = _7401 - select((_7402 < _7397), _7402, _7397);
                                                                      _7412 = abs(select(_7399, (-0.3333333432674408f - _7398), _7398) + ((_7402 - _7397) / ((_7406 * 6.0f) + 9.999999682655225e-21f)));
                                                                      do {
                                                                        _7425 = _7412;
                                                                        if (_7412 < 0.6666666865348816f) {
                                                                          _7425 = ((saturate(((float)((uint)((uint)(((uint)(_6310) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7412 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7412)) + _7412);
                                                                        }
                                                                        _7426 = saturate((_7406 / (_7401 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6310) >> 1) & 255)))) * 0.003921499941498041f));
                                                                        _7427 = saturate(_7401);
                                                                        do {
                                                                          _7454 = _7427;
                                                                          _7455 = _7427;
                                                                          _7456 = _7427;
                                                                          if (!(_7426 <= 0.0f)) {
                                                                            _7430 = saturate(_7425);
                                                                            _7434 = select(((_7430 * 360.0f) >= 360.0f), 0.0f, (_7430 * 6.0f));
                                                                            _7435 = int(_7434);
                                                                            _7437 = _7434 - float((int)(_7435));
                                                                            _7439 = _7427 * (1.0f - _7426);
                                                                            _7442 = (1.0f - (_7437 * _7426)) * _7427;
                                                                            _7446 = (1.0f - ((1.0f - _7437) * _7426)) * _7427;
                                                                            switch (_7435) {
                                                                              case 0: {
                                                                                _7454 = _7427;
                                                                                _7455 = _7446;
                                                                                _7456 = _7439;
                                                                                break;
                                                                              }
                                                                              case 1: {
                                                                                _7454 = _7442;
                                                                                _7455 = _7427;
                                                                                _7456 = _7439;
                                                                                break;
                                                                              }
                                                                              case 2: {
                                                                                _7454 = _7439;
                                                                                _7455 = _7427;
                                                                                _7456 = _7446;
                                                                                break;
                                                                              }
                                                                              case 3: {
                                                                                _7454 = _7439;
                                                                                _7455 = _7442;
                                                                                _7456 = _7427;
                                                                                break;
                                                                              }
                                                                              case 4: {
                                                                                _7454 = _7446;
                                                                                _7455 = _7439;
                                                                                _7456 = _7427;
                                                                                break;
                                                                              }
                                                                              case 5: {
                                                                                _7454 = _7427;
                                                                                _7455 = _7439;
                                                                                _7456 = _7442;
                                                                                break;
                                                                              }
                                                                              default: {
                                                                                _7454 = 0.0f;
                                                                                _7455 = 0.0f;
                                                                                _7456 = 0.0f;
                                                                                break;
                                                                              }
                                                                            }
                                                                          }
                                                                          _7457 = _7454 * _7382;
                                                                          _7458 = _7455 * _7382;
                                                                          _7459 = _7456 * _7382;
                                                                          _7461 = saturate(_7299 * 1.0101009607315063f);
                                                                          _7472 = ((_7461 * (_7320 - _7457)) + _7457);
                                                                          _7473 = ((_7461 * (_7321 - _7458)) + _7458);
                                                                          _7474 = (lerp(_7459, _7322, _7461));
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  do {
                                                                    _7510 = _7366;
                                                                    [branch]
                                                                    if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                      _7481 = srvLightMappingData[_1466];
                                                                      if (!(_7481 == -1)) {
                                                                        _7486 = srvLightIndexData[_7481].nLayerIndex;
                                                                        _7488 = srvLightIndexData[_7481].vAtlasOrigin.x;
                                                                        _7489 = srvLightIndexData[_7481].vAtlasOrigin.y;
                                                                        _7491 = srvLightIndexData[_7481].vScreenOrigin.x;
                                                                        _7492 = srvLightIndexData[_7481].vScreenOrigin.y;
                                                                        _7501 = ((int)(_7486 * 5)) & 31;
                                                                        _7510 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7488 + _63) - _7491)), ((int)((_7489 + _64) - _7492)), 0)))).x) & ((int)(31 << _7501)))) >> _7501)) >> 1)))) * 0.06666667014360428f) * _7366);
                                                                      } else {
                                                                        _7510 = _7366;
                                                                      }
                                                                    }
                                                                    _7514 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                    _7517 = select(_7514, (_7510 * _1213), _7510);
                                                                    _7519 = _6383 * _6382;
                                                                    _7520 = _6384 * _6382;
                                                                    _7521 = _6385 * _6382;
                                                                    _7522 = _6344 * _6275;
                                                                    _7523 = _6344 * _6276;
                                                                    _7524 = _6344 * _6277;
                                                                    _7525 = _7519 + _7522;
                                                                    _7526 = _7520 + _7523;
                                                                    _7527 = _7521 + _7524;
                                                                    _7528 = _7519 - _7522;
                                                                    _7529 = _7520 - _7523;
                                                                    _7530 = _7521 - _7524;
                                                                    _7531 = (_6344 > 0.0f);
                                                                    _7532 = dot(float3(_7525, _7526, _7527), float3(_7525, _7526, _7527));
                                                                    _7533 = rsqrt(_7532);
                                                                    do {
                                                                      [branch]
                                                                      if (_7531) {
                                                                        _7536 = rsqrt(dot(float3(_7528, _7529, _7530), float3(_7528, _7529, _7530)));
                                                                        _7537 = _7536 * _7533;
                                                                        _7539 = dot(float3(_7525, _7526, _7527), float3(_7528, _7529, _7530)) * _7537;
                                                                        _7558 = (_7537 / ((_7537 + 0.5f) + (_7539 * 0.5f)));
                                                                        _7559 = (((dot(float3(_195, _196, _197), float3(_7528, _7529, _7530)) * _7536) + (dot(float3(_195, _196, _197), float3(_7525, _7526, _7527)) * _7533)) * 0.5f);
                                                                        _7560 = _7539;
                                                                      } else {
                                                                        _7558 = (1.0f / (_7532 + 1.0f));
                                                                        _7559 = dot(float3(_195, _196, _197), float3((_7533 * _7525), (_7533 * _7526), (_7533 * _7527)));
                                                                        _7560 = 1.0f;
                                                                      }
                                                                      do {
                                                                        _7576 = _7559;
                                                                        if (_6346 > 0.0f) {
                                                                          _7566 = sqrt(saturate((_6346 * _6346) * _7558));
                                                                          if (_7559 < _7566) {
                                                                            _7571 = max(_7559, (-0.0f - _7566)) + _7566;
                                                                            _7576 = ((_7571 * _7571) / (_7566 * 4.0f));
                                                                          } else {
                                                                            _7576 = _7559;
                                                                          }
                                                                        }
                                                                        do {
                                                                          _7636 = _7525;
                                                                          _7637 = _7526;
                                                                          _7638 = _7527;
                                                                          if (_7531) {
                                                                            _7578 = -0.0f - _394;
                                                                            _7579 = -0.0f - _395;
                                                                            _7580 = -0.0f - _393;
                                                                            _7582 = dot(float3(_7578, _7579, _7580), float3(_195, _196, _197)) * 2.0f;
                                                                            _7586 = _7578 - (_7582 * _195);
                                                                            _7587 = _7579 - (_7582 * _196);
                                                                            _7588 = _7580 - (_7582 * _197);
                                                                            _7589 = _7528 - _7525;
                                                                            _7590 = _7529 - _7526;
                                                                            _7591 = _7530 - _7527;
                                                                            _7592 = dot(float3(_7586, _7587, _7588), float3(_7589, _7590, _7591));
                                                                            _7598 = sqrt(((_7589 * _7589) + (_7590 * _7590)) + (_7591 * _7591));
                                                                            _7607 = saturate(((dot(float3(_7586, _7587, _7588), float3(_7525, _7526, _7527)) * _7592) - dot(float3(_7525, _7526, _7527), float3(_7589, _7590, _7591))) / ((_7598 * _7598) - (_7592 * _7592)));
                                                                            _7611 = (_7607 * _7589) + _7525;
                                                                            _7612 = (_7607 * _7590) + _7526;
                                                                            _7613 = (_7607 * _7591) + _7527;
                                                                            _7614 = dot(float3(_7611, _7612, _7613), float3(_7586, _7587, _7588));
                                                                            _7618 = (_7614 * _7586) - _7611;
                                                                            _7619 = (_7614 * _7587) - _7612;
                                                                            _7620 = (_7614 * _7588) - _7613;
                                                                            _7628 = saturate(0.009999999776482582f / sqrt(((_7618 * _7618) + (_7619 * _7619)) + (_7620 * _7620)));
                                                                            _7636 = ((_7628 * _7618) + _7611);
                                                                            _7637 = ((_7628 * _7619) + _7612);
                                                                            _7638 = ((_7628 * _7620) + _7613);
                                                                          }
                                                                          _7640 = rsqrt(dot(float3(_7636, _7637, _7638), float3(_7636, _7637, _7638)));
                                                                          _7641 = _7640 * _7636;
                                                                          _7642 = _7640 * _7637;
                                                                          _7643 = _7640 * _7638;
                                                                          _7644 = _206 * _206;
                                                                          _7648 = saturate((_6346 * (1.0f - _7644)) * _7640);
                                                                          _7650 = saturate(_7640 * f16tof32(_6289));
                                                                          _7652 = rsqrt(dot(float3(_7519, _7520, _7521), float3(_7519, _7520, _7521)));
                                                                          _7656 = dot(float3(_195, _196, _197), float3(_7641, _7642, _7643));
                                                                          _7657 = dot(float3(_195, _196, _197), float3(_394, _395, _393));
                                                                          _7658 = dot(float3(_394, _395, _393), float3(_7641, _7642, _7643));
                                                                          _7661 = rsqrt((_7658 * 2.0f) + 2.0f);
                                                                          _7668 = (_7648 > 0.0f);
                                                                          do {
                                                                            _7759 = saturate((_7661 * _7658) + _7661);
                                                                            _7760 = saturate(_7661 * (_7657 + _7656));
                                                                            if (_7668) {
                                                                              _7672 = sqrt(1.0f - (_7648 * _7648));
                                                                              _7674 = (_7656 * 2.0f) * _7657;
                                                                              _7675 = _7674 - _7658;
                                                                              if (!(!(_7675 >= _7672))) {
                                                                                _7759 = abs(_7657);
                                                                                _7760 = 1.0f;
                                                                              } else {
                                                                                _7683 = rsqrt(1.0f - (_7675 * _7675)) * _7648;
                                                                                _7686 = _7683 * (_7657 - (_7675 * _7656));
                                                                                _7687 = _7657 * _7657;
                                                                                _7692 = _7683 * (((_7687 * 2.0f) + -1.0f) - (_7675 * _7658));
                                                                                _7701 = sqrt(saturate((((1.0f - (_7656 * _7656)) - _7687) - (_7658 * _7658)) + (_7674 * _7658)));
                                                                                _7702 = _7701 * _7683;
                                                                                _7705 = ((_7657 * 2.0f) * _7683) * _7701;
                                                                                _7707 = (_7672 * _7656) + _7657;
                                                                                _7708 = _7707 + _7686;
                                                                                _7709 = _7672 * _7658;
                                                                                _7711 = (_7709 + 1.0f) + _7692;
                                                                                _7712 = _7702 * _7711;
                                                                                _7713 = _7708 * _7711;
                                                                                _7714 = _7705 * _7708;
                                                                                _7719 = (((_7708 * 0.25f) * _7705) - (_7712 * 0.5f)) * _7713;
                                                                                _7733 = (((_7714 - (_7712 * 2.0f)) * _7714) + (_7712 * _7712)) + ((((-0.5f - ((_7711 + _7709) * 0.5f)) * _7713) + ((_7711 * _7711) * _7707)) * _7708);
                                                                                _7738 = (_7719 * 2.0f) / ((_7733 * _7733) + (_7719 * _7719));
                                                                                _7739 = _7733 * _7738;
                                                                                _7741 = 1.0f - (_7719 * _7738);
                                                                                _7747 = ((_7739 * _7705) + _7709) + (_7741 * _7692);
                                                                                _7750 = rsqrt((_7747 * 2.0f) + 2.0f);
                                                                                _7759 = saturate((_7747 * _7750) + _7750);
                                                                                _7760 = saturate(((_7707 + (_7739 * _7702)) + (_7741 * _7686)) * _7750);
                                                                              }
                                                                            }
                                                                            _7761 = saturate(_7576);
                                                                            _7763 = _7644 * _7644;
                                                                            do {
                                                                              _7773 = _7763;
                                                                              if (_7650 > 0.0f) {
                                                                                _7773 = saturate(((_7650 * _7650) / ((_7759 * 3.5999999046325684f) + 0.4000000059604645f)) + _7763);
                                                                              }
                                                                              do {
                                                                                _7785 = _7773;
                                                                                _7786 = 1.0f;
                                                                                if (_7668) {
                                                                                  _7782 = (((_7648 * 0.25f) * ((sqrt(_7773) * 3.0f) + _7648)) / (_7759 + 0.0010000000474974513f)) + _7773;
                                                                                  _7785 = _7782;
                                                                                  _7786 = (_7773 / _7782);
                                                                                }
                                                                                do {
                                                                                  _7806 = _7786;
                                                                                  if (_7560 < 1.0f) {
                                                                                    _7793 = sqrt((1.000100016593933f - _7560) / max(9.999999974752427e-07f, (_7560 + 1.0f)));
                                                                                    _7806 = (sqrt(_7785 / ((((_7793 * 0.25f) * ((sqrt(_7785) * 3.0f) + _7793)) / (_7759 + 0.0010000000474974513f)) + _7785)) * _7786);
                                                                                  }
                                                                                  _7810 = (((_7773 * _7760) - _7760) * _7760) + 1.0f;
                                                                                  _7815 = saturate(abs(_7657) + 9.999999747378752e-06f);
                                                                                  _7816 = sqrt(_7773);
                                                                                  _7817 = 1.0f - _7816;
                                                                                  _7829 = saturate((dot(float3(_195, _196, _197), float3((_7652 * _7519), (_7652 * _7520), (_7652 * _7521))) + _6343) / (_6343 + 1.0f));
                                                                                  _7832 = ((_7806 * _7761) * (_7773 / (_7810 * _7810))) * (0.5f / ((((_7817 * _7815) + _7816) * _7761) + (((_7817 * _7761) + _7816) * _7815)));
                                                                                  _7833 = _7472 * _1513;
                                                                                  _7834 = _7473 * _1513;
                                                                                  _7835 = _7474 * _1513;
                                                                                  do {
                                                                                    _7871 = _1454;
                                                                                    _7872 = _1455;
                                                                                    _7873 = _1456;
                                                                                    if (_6340 > 0.0f) {
                                                                                      _7853 = (exp2(log2(1.0f - saturate(_7759)) * 5.0f) * 0.9599999785423279f) + 0.03999999910593033f;
                                                                                      _7854 = select(_7514, (_7510 * _1213), _7510) * _6340;
                                                                                      _7871 = (((((_7833 * _1082) * _7854) * _7853) * _7832) + _1454);
                                                                                      _7872 = (((((_7834 * _1082) * _7854) * _7853) * _7832) + _1455);
                                                                                      _7873 = (((((_7835 * _1082) * _7854) * _7853) * _7832) + _1456);
                                                                                    }
                                                                                    _7879 = saturate(-0.0f - dot(float3(_394, _395, _393), float3(_6383, _6384, _6385)));
                                                                                    _7882 = 1.0f - ((_7879 * _7879) * 0.6399999856948853f);
                                                                                    _7887 = saturate(0.30000001192092896f - _6405) * (0.36000001430511475f / (_7882 * _7882));
                                                                                    _7888 = _6455 * _1513;
                                                                                    _8367 = (((_7517 * _7833) * _7829) + _1451);
                                                                                    _8368 = (((_7517 * _7834) * _7829) + _1452);
                                                                                    _8369 = (((_7517 * _7835) * _7829) + _1453);
                                                                                    _8370 = ((((_167 * _212) * _7888) * _7887) + _7871);
                                                                                    _8371 = ((((_167 * _213) * _7888) * _7887) + _7872);
                                                                                    _8372 = ((((_214 * _167) * _7888) * _7887) + _7873);
                                                                                  } while (false);
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
                                                                _8367 = _1451;
                                                                _8368 = _1452;
                                                                _8369 = _1453;
                                                                _8370 = _1454;
                                                                _8371 = _1455;
                                                                _8372 = _1456;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _8367 = _1451;
                                                          _8368 = _1452;
                                                          _8369 = _1453;
                                                          _8370 = _1454;
                                                          _8371 = _1455;
                                                          _8372 = _1456;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    if (_1496 == 10) {
                                                      _7903 = asfloat(srvLightInfoProperties.Load4(_1465)).x;
                                                      _7904 = asfloat(srvLightInfoProperties.Load4(_1465)).y;
                                                      _7905 = asfloat(srvLightInfoProperties.Load4(_1465)).z;
                                                      _7906 = asfloat(srvLightInfoProperties.Load4(_1465)).w;
                                                      _7909 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).x;
                                                      _7910 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).y;
                                                      _7911 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).z;
                                                      _7912 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 16u)))).w;
                                                      _7915 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).x;
                                                      _7916 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).y;
                                                      _7917 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).z;
                                                      _7918 = asfloat(srvLightInfoProperties.Load4(((int)(_1465 + 32u)))).w;
                                                      _7921 = asfloat(srvLightInfoProperties.Load2(((int)(_1465 + 72u)))).x;
                                                      _7922 = asfloat(srvLightInfoProperties.Load2(((int)(_1465 + 72u)))).y;
                                                      _7925 = asint(srvLightInfoProperties.Load(((int)(_1465 + 80u))));
                                                      _7928 = asint(srvLightInfoProperties.Load(((int)(_1465 + 84u))));
                                                      _7931 = asint(srvLightInfoProperties.Load(((int)(_1465 + 88u))));
                                                      _7934 = asint(srvLightInfoProperties.Load(((int)(_1465 + 96u))));
                                                      _7937 = f16tof32(_7925);
                                                      _7939 = f16tof32(((uint)((uint)(_7928) >> 16)));
                                                      _7940 = f16tof32(_7928);
                                                      _7942 = f16tof32(((uint)((uint)(_7931) >> 16)));
                                                      _7946 = ((float)((uint)((uint)(((uint)(_7931) >> 8) & 255)))) * 0.003921499941498041f;
                                                      _7948 = (float)((uint)((uint)(_7934 & 65535)));
                                                      _7952 = mad(_7905, _223, mad(_7904, _222, (_7903 * _221))) + _7906;
                                                      _7956 = mad(_7911, _223, mad(_7910, _222, (_7909 * _221))) + _7912;
                                                      _7960 = mad(_7917, _223, mad(_7916, _222, (_7915 * _221))) + _7918;
                                                      _7963 = mad(_7905, _197, mad(_7904, _196, (_7903 * _195)));
                                                      _7966 = mad(_7911, _197, mad(_7910, _196, (_7909 * _195)));
                                                      _7969 = mad(_7917, _197, mad(_7916, _196, (_7915 * _195)));
                                                      _7981 = -0.0f - mad(_7917, _393, mad(_7916, _395, (_7915 * _394)));
                                                      _7982 = _7921 * 0.5f;
                                                      _7983 = _7922 * 0.5f;
                                                      _7984 = -0.0f - _7982;
                                                      _7985 = -0.0f - _7983;
                                                      _7986 = _7984 - _7952;
                                                      _7987 = _7985 - _7956;
                                                      _7988 = -0.0f - _7960;
                                                      _7989 = _7982 - _7952;
                                                      _7990 = _7983 - _7956;
                                                      _7991 = dot(float3(_7952, _7956, _7960), float3(_7963, _7966, _7969));
                                                      _7993 = dot(float3(_7984, _7985, 0.0f), float3(_7963, _7966, _7969)) - _7991;
                                                      _7995 = dot(float3(_7982, _7985, 0.0f), float3(_7963, _7966, _7969)) - _7991;
                                                      _7997 = dot(float3(_7982, _7983, 0.0f), float3(_7963, _7966, _7969)) - _7991;
                                                      _7999 = dot(float3(_7984, _7983, 0.0f), float3(_7963, _7966, _7969)) - _7991;
                                                      _8000 = min(_7993, _7995);
                                                      do {
                                                        _8022 = 0.0f;
                                                        _8023 = 0.0f;
                                                        [branch]
                                                        if (!(!(_8000 >= 0.0f))) {
                                                          _8006 = rsqrt(dot(float3(_7989, _7987, _7988), float3(_7989, _7987, _7988)) * dot(float3(_7986, _7987, _7988), float3(_7986, _7987, _7988)));
                                                          _8008 = dot(float3(_7986, _7987, _7988), float3(_7989, _7987, _7988)) * _8006;
                                                          _8015 = rsqrt(max(((((_8008 * 0.09300000220537186f) + 0.5f) * _8008) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8006;
                                                          _8022 = (_8015 * (_7921 * _7988));
                                                          _8023 = (_8015 * (_7987 * (_7984 - _7982)));
                                                        }
                                                        do {
                                                          _8047 = 0.0f;
                                                          _8048 = _8023;
                                                          [branch]
                                                          if (!(!(min(_7995, _7997) >= 0.0f))) {
                                                            _8030 = rsqrt(dot(float3(_7989, _7990, _7988), float3(_7989, _7990, _7988)) * dot(float3(_7989, _7987, _7988), float3(_7989, _7987, _7988)));
                                                            _8032 = dot(float3(_7989, _7987, _7988), float3(_7989, _7990, _7988)) * _8030;
                                                            _8039 = rsqrt(max(((((_8032 * 0.09300000220537186f) + 0.5f) * _8032) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8030;
                                                            _8047 = (_8039 * ((_7985 - _7983) * _7988));
                                                            _8048 = ((_8039 * (_7922 * _7989)) + _8023);
                                                          }
                                                          _8049 = min(_7997, _7999);
                                                          do {
                                                            _8073 = _8022;
                                                            _8074 = _8048;
                                                            [branch]
                                                            if (!(!(_8049 >= 0.0f))) {
                                                              _8055 = rsqrt(dot(float3(_7986, _7990, _7988), float3(_7986, _7990, _7988)) * dot(float3(_7989, _7990, _7988), float3(_7989, _7990, _7988)));
                                                              _8057 = dot(float3(_7989, _7990, _7988), float3(_7986, _7990, _7988)) * _8055;
                                                              _8064 = rsqrt(max(((((_8057 * 0.09300000220537186f) + 0.5f) * _8057) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8055;
                                                              _8073 = ((_8064 * ((_7984 - _7982) * _7988)) + _8022);
                                                              _8074 = ((_8064 * (_7921 * _7990)) + _8048);
                                                            }
                                                            do {
                                                              _8099 = _8047;
                                                              _8100 = _8074;
                                                              [branch]
                                                              if (!(!(min(_7999, _7993) >= 0.0f))) {
                                                                _8081 = rsqrt(dot(float3(_7986, _7987, _7988), float3(_7986, _7987, _7988)) * dot(float3(_7986, _7990, _7988), float3(_7986, _7990, _7988)));
                                                                _8083 = dot(float3(_7986, _7990, _7988), float3(_7986, _7987, _7988)) * _8081;
                                                                _8090 = rsqrt(max(((((_8083 * 0.09300000220537186f) + 0.5f) * _8083) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8081;
                                                                _8099 = ((_8090 * (_7922 * _7988)) + _8047);
                                                                _8100 = ((_8090 * (_7986 * (_7985 - _7983))) + _8074);
                                                              }
                                                              do {
                                                                _8243 = _8099;
                                                                _8244 = _8073;
                                                                _8245 = _8100;
                                                                if (min(_8000, _8049) < 0.0f) {
                                                                  [branch]
                                                                  if (!(!(max(max(_7993, _7995), max(_7997, _7999)) >= 0.0f))) {
                                                                    _8109 = -0.0f - _7963;
                                                                    _8110 = _7991 / _7966;
                                                                    _8111 = _7984 / _7966;
                                                                    _8112 = _7982 / _7966;
                                                                    _8114 = (_7985 - _8110) / _8109;
                                                                    _8116 = (_7983 - _8110) / _8109;
                                                                    _8117 = min(_8111, _8112);
                                                                    _8118 = max(_8111, _8112);
                                                                    _8119 = min(_8114, _8116);
                                                                    _8120 = max(_8114, _8116);
                                                                    _8121 = max(_8117, _8119);
                                                                    _8122 = min(_8118, _8120);
                                                                    _8123 = _8121 * _7966;
                                                                    _8125 = _8122 * _7966;
                                                                    _8127 = _8123 - _7952;
                                                                    _8128 = _8110 - _7956;
                                                                    _8129 = _8128 + (_8121 * _8109);
                                                                    _8130 = _8125 - _7952;
                                                                    _8131 = _8128 + (_8122 * _8109);
                                                                    _8132 = dot(float3(_8127, _8129, _7988), float3(_8127, _8129, _7988));
                                                                    _8133 = dot(float3(_8130, _8131, _7988), float3(_8130, _8131, _7988));
                                                                    _8135 = rsqrt(_8133 * _8132);
                                                                    _8137 = dot(float3(_8127, _8129, _7988), float3(_8130, _8131, _7988)) * _8135;
                                                                    _8144 = rsqrt(max(((((_8137 * 0.09300000220537186f) + 0.5f) * _8137) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8135;
                                                                    _8157 = (_8117 > _8119);
                                                                    _8159 = select(_8157, _7966, _7963);
                                                                    _8165 = float((int)(((int)(uint)((int)(_8159 > 0.0f))) - ((int)(uint)((int)(_8159 < 0.0f)))));
                                                                    _8169 = ((1.0f - (((float)((bool)_8157)) * 2.0f)) * _7982) * _8165;
                                                                    _8171 = _8169 - _7952;
                                                                    _8172 = (_8165 * _7983) - _7956;
                                                                    _8173 = (_8118 < _8120);
                                                                    _8175 = select(_8173, _7966, _7963);
                                                                    _8181 = float((int)(((int)(uint)((int)(_8175 > 0.0f))) - ((int)(uint)((int)(_8175 < 0.0f)))));
                                                                    _8182 = _8181 * _7982;
                                                                    _8187 = _8182 - _7952;
                                                                    _8188 = ((((((float)((bool)_8173)) * 2.0f) + -1.0f) * _7983) * _8181) - _7956;
                                                                    _8191 = rsqrt(_8132 * dot(float3(_8171, _8172, _7988), float3(_8171, _8172, _7988)));
                                                                    _8193 = dot(float3(_8171, _8172, _7988), float3(_8127, _8129, _7988)) * _8191;
                                                                    _8200 = rsqrt(max(((((_8193 * 0.09300000220537186f) + 0.5f) * _8193) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8191;
                                                                    _8213 = rsqrt(dot(float3(_8187, _8188, _7988), float3(_8187, _8188, _7988)) * _8133);
                                                                    _8215 = dot(float3(_8130, _8131, _7988), float3(_8187, _8188, _7988)) * _8213;
                                                                    _8222 = rsqrt(max(((((_8215 * 0.09300000220537186f) + 0.5f) * _8215) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8213;
                                                                    _8243 = ((((_8144 * (((_8121 - _8122) * _8109) * _7988)) + _8099) + (_8200 * ((_8172 - _8129) * _7988))) + (_8222 * ((_8131 - _8188) * _7988)));
                                                                    _8244 = ((((_8144 * ((_7966 * (_8122 - _8121)) * _7988)) + _8073) + (_8200 * ((_8123 - _8169) * _7988))) + (_8222 * ((_8182 - _8125) * _7988)));
                                                                    _8245 = ((((_8144 * ((_8131 * _8127) - (_8130 * _8129))) + _8100) + (_8200 * ((_8171 * _8129) - (_8172 * _8127)))) + (_8222 * ((_8188 * _8130) - (_8187 * _8131))));
                                                                  } else {
                                                                    _8243 = _8099;
                                                                    _8244 = _8073;
                                                                    _8245 = _8100;
                                                                  }
                                                                }
                                                                _8251 = sqrt(((_8244 * _8244) + (_8243 * _8243)) + (_8245 * _8245));
                                                                _8252 = _8251 * 0.15915493667125702f;
                                                                [branch]
                                                                if (!(_8252 == 0.0f)) {
                                                                  _8261 = saturate((_8252 - _7937) / (1.0f - _7937)) * ((float)((bool)(uint)(_7960 <= 0.0f)));
                                                                  [branch]
                                                                  if (!(_8261 == 0.0f)) {
                                                                    do {
                                                                      _8269 = 0.0f;
                                                                      if (_8251 > 0.0f) {
                                                                        _8269 = (dot(float3(_7963, _7966, _7969), float3(_8243, _8244, _8245)) / _8251);
                                                                      }
                                                                      _8270 = 1.0f - _206;
                                                                      _8275 = min(_206, 0.800000011920929f);
                                                                      _8284 = exp2(((((((_8275 * 3.322999954223633f) + -3.7669999599456787f) * _8275) + -0.3479999899864197f) * _8275) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                                                      _8291 = _7988 / (_7981 - ((_7969 * 2.0f) * dot(float3((-0.0f - mad(_7905, _393, mad(_7904, _395, (_7903 * _394)))), (-0.0f - mad(_7911, _393, mad(_7910, _395, (_7909 * _394)))), _7981), float3(_7963, _7966, _7969))));
                                                                      _8294 = (_8291 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8284) * saturate((_206 + -0.5f) * 2.500000238418579f)) + _8284);
                                                                      _8302 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7948), ((log2((_8294 * _8294) * f16tof32(((uint)((uint)(_7925) >> 16)))) * 0.5f) + 5.5f));
                                                                      _8304 = (float)((bool)(uint)(_8291 > 0.0f));
                                                                      _8305 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _7948), 10.0f);
                                                                      _8314 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8261 * _1213), _8261);
                                                                      do {
                                                                        _8351 = _1454;
                                                                        _8352 = _1455;
                                                                        _8353 = _1456;
                                                                        if (_7946 > 0.0f) {
                                                                          _8330 = ((max((_8270 * _8270), 0.03999999910593033f) + -0.03999999910593033f) * exp2(log2(1.0f - saturate(dot(float3(_195, _196, _197), float3(_394, _395, _393)))) * 5.0f)) + 0.03999999910593033f;
                                                                          _8331 = _8314 * _1513;
                                                                          _8351 = ((((((_7946 * _7939) * _8304) * _8302.x) * _8331) * _8330) + _1454);
                                                                          _8352 = ((((((_7940 * _7946) * _8304) * _8302.y) * _8331) * _8330) + _1455);
                                                                          _8353 = ((((((_7942 * _7946) * _8304) * _8302.z) * _8331) * _8330) + _1456);
                                                                        }
                                                                        _8359 = ((_1513 * 5.4256415367126465f) * _8269) * _8314;
                                                                        _8367 = (((_8305.x * _7939) * _8359) + _1451);
                                                                        _8368 = (((_8305.y * _7940) * _8359) + _1452);
                                                                        _8369 = (((_8305.z * _7942) * _8359) + _1453);
                                                                        _8370 = _8351;
                                                                        _8371 = _8352;
                                                                        _8372 = _8353;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _8367 = _1451;
                                                                    _8368 = _1452;
                                                                    _8369 = _1453;
                                                                    _8370 = _1454;
                                                                    _8371 = _1455;
                                                                    _8372 = _1456;
                                                                  }
                                                                } else {
                                                                  _8367 = _1451;
                                                                  _8368 = _1452;
                                                                  _8369 = _1453;
                                                                  _8370 = _1454;
                                                                  _8371 = _1455;
                                                                  _8372 = _1456;
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
                                                      _8367 = _1451;
                                                      _8368 = _1452;
                                                      _8369 = _1453;
                                                      _8370 = _1454;
                                                      _8371 = _1455;
                                                      _8372 = _1456;
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      } else {
                                        _8367 = _1451;
                                        _8368 = _1452;
                                        _8369 = _1453;
                                        _8370 = _1454;
                                        _8371 = _1455;
                                        _8372 = _1456;
                                      }
                                    }
                                    _8373 = _1457 + 1u;
                                    do {
                                      if (!(_8373 == _global_2)) {
                                        _1451 = _8367;
                                        _1452 = _8368;
                                        _1453 = _8369;
                                        _1454 = _8370;
                                        _1455 = _8371;
                                        _1456 = _8372;
                                        _1457 = _8373;
                                        _loop_break_3 = true;
                                        break;
                                      }
                                      _8377 = _8367;
                                      _8378 = _8368;
                                      _8379 = _8369;
                                      _8380 = _8370;
                                      _8381 = _8371;
                                      _8382 = _8372;
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
                              _8384 = rsqrt(dot(float3(_134, _135, -1.0f), float3(_134, _135, -1.0f)));
                              _8391 = 1.0f - _206;
                              _8401 = 0.9599999785423279f - (exp2(log2(1.0f - saturate(saturate(dot(float3(_195, _196, _197), float3((-0.0f - (_134 * _8384)), (-0.0f - (_135 * _8384)), _8384))))) * 5.0f) * (max((_8391 * _8391), 0.03999999910593033f) + -0.03999999910593033f));
                              _8541 = (_8401 * _8377);
                              _8542 = (_8401 * _8378);
                              _8543 = (_8401 * _8379);
                              _8544 = _8380;
                              _8545 = _8381;
                              _8546 = _8382;
                              _8547 = saturate(_142.x);
                              _8548 = saturate(_142.y);
                              _8549 = saturate(_142.z);
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
        _8420 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _135, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _134)));
        _8423 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _135, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _134)));
        _8426 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _135, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _134)));
        do {
          [branch]
          if (!(cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0)) {
            _8447 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8420, _8423, _8426), 0.0f);
            _8451 = _8447.x * 32.0f;
            _8452 = _8447.y * 32.0f;
            _8453 = _8447.z * 32.0f;
            _8455 = rsqrt(dot(float3(_8420, _8423, _8426), float3(_8420, _8423, _8426)));
            _8456 = _8455 * _8420;
            _8457 = _8455 * _8423;
            _8458 = _8455 * _8426;
            _8459 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
            _8460 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
            _8461 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
            _8462 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
            _8463 = dot(float3(_8456, _8457, _8458), float3(_8460, _8461, _8462));
            _8468 = (_8463 * _8463) - (dot(float3(_8460, _8461, _8462), float3(_8460, _8461, _8462)) - (_8459 * _8459));
            if ((_8463 > -0.0f) && (_8468 > 0.0f)) {
              _8473 = -0.0f - cbDeferredShading.vSunDirWS.z;
              _8486 = 74.80000305175781f / ((dot(float3(_8456, _8457, _8458), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8459) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
              _8494 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8456, _8458), float2(_8473, cbDeferredShading.vSunDirWS.x)) * _8486) + 0.5f), ((dot(float3(_8456, _8457, _8458), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8473)), (cbDeferredShading.vSunDirWS.y * _8473))) * _8486) + 0.5f)), 0.0f);
              _8496 = _8468 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
              if (_8496 > 0.0f) {
                _8503 = saturate(_8496 * 5.0f);
                _8530 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8494.x) * _8503) + _8451);
                _8531 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8494.y) * _8503) + _8452);
                _8532 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8494.z) * _8503) + _8453);
              } else {
                _8530 = _8451;
                _8531 = _8452;
                _8532 = _8453;
              }
            } else {
              _8530 = _8451;
              _8531 = _8452;
              _8532 = _8453;
            }
          } else {
            _8530 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
            _8531 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
            _8532 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
          }
          _8536 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
          _8541 = 0.0f;
          _8542 = 0.0f;
          _8543 = 0.0f;
          _8544 = select(_8536, 0.0f, _8530);
          _8545 = select(_8536, 0.0f, _8531);
          _8546 = select(_8536, 0.0f, _8532);
          _8547 = 0.0f;
          _8548 = 0.0f;
          _8549 = 0.0f;
        } while (false);
      }
      uavDeferredShadingPass_Specular[int2(_63, _64)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_8547 * _8541) + _8544)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_8548 * _8542) + _8545)), 7936.0f), 5.960464477539063e-08f), max(min((((_8549 * _8543) + _8546) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_63, _64)] = float3(0.0f, 0.0f, 0.0f);
    } while (false);
  }
}
