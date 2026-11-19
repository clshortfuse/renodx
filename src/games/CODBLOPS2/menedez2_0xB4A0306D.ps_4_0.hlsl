// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 01 16:45:16 2026
// HDR-safe patch for R16G16B16A16_FLOAT.
//
// Fixes:
// - Negative log2 base in the ghost mask when scene brightness exceeds 1.0.
// - Invalid log2 base in the Falloff power operation.
// - Zero/near-zero divisions in warp, shift and blur coordinates.
// - NaN, infinity and negative final RGB without clamping valid HDR to 1.0.
//
//
cbuffer _Globals : register(b2)
{
  float4 gameTime : packoffset(c0);
  float ShiftBlend : packoffset(c1);
  float BlurAmount : packoffset(c1.y);
  float GhostIntensity : packoffset(c1.z);
  float GhostPower : packoffset(c1.w);
  float OverlayAmount : packoffset(c2);
  float2 ShiftRadius : packoffset(c2.y);
  float2 WarpRadius : packoffset(c3);
  float Falloff : packoffset(c3.z);
  float Boost : packoffset(c3.w);
  float Brightness : packoffset(c4);
  float Transition : packoffset(c4.y);
}

cbuffer PerSceneConsts : register(b0)
{
  float4 windDirection : packoffset(c0);
  float4 adsZScale : packoffset(c1);
  float4 variantWindSpring[16] : packoffset(c2);
  float4 sunPosition : packoffset(c18);
  float4 sunDiffuse : packoffset(c19);
  float4 hdrControl0 : packoffset(c20);
  float4 hdrControl1 : packoffset(c21);
  float4 dlightShadowLookupMatrix0 : packoffset(c22);
  float4 dlightShadowLookupMatrix1 : packoffset(c23);
  float4 dlightShadowLookupMatrix2 : packoffset(c24);
  float4 dlightShadowLookupMatrix3 : packoffset(c25);
  float4 fogColor : packoffset(c26);
  float4 fogConsts : packoffset(c27);
  float4 fogConsts2 : packoffset(c28);
  float3 sunFogDir : packoffset(c29);
  float4 sunFogColor : packoffset(c30);
  float2 sunFog : packoffset(c31);
  float4x4 projectionMatrix : packoffset(c32);
  float4x4 viewProjectionMatrix : packoffset(c36);
  float4x4 inverseViewMatrix : packoffset(c40);
  float4x4 inverseViewProjectionMatrix : packoffset(c44);
  float4x4 shadowLookupMatrix : packoffset(c48);
  float4x4 worldOutdoorLookupMatrix : packoffset(c52);
  float4 lightingLookupScale : packoffset(c56);
  float4 lightHeroScale : packoffset(c57);
  float4 zNear : packoffset(c58);
  float4 outdoorFeatherParms : packoffset(c59);
  float4 glightPosXs : packoffset(c60);
  float4 glightPosYs : packoffset(c61);
  float4 glightPosZs : packoffset(c62);
  float4 glightFallOffs : packoffset(c63);
  float4 glightReds : packoffset(c64);
  float4 glightGreens : packoffset(c65);
  float4 glightBlues : packoffset(c66);
  float4 dlightPosition : packoffset(c67);
  float4 dlightDiffuse : packoffset(c68);
  float4 dlightAttenuation : packoffset(c69);
  float4 dlightFallOff : packoffset(c70);
  float4 dlightSpotMatrix0 : packoffset(c71);
  float4 dlightSpotMatrix1 : packoffset(c72);
  float4 dlightSpotMatrix2 : packoffset(c73);
  float4 dlightSpotMatrix3 : packoffset(c74);
  float4 dlightSpotDir : packoffset(c75);
  float4 dlightSpotFactors : packoffset(c76);
  float4 lightPosition : packoffset(c77);
  float4 lightDiffuse : packoffset(c78);
  float4 lightSpotDir : packoffset(c79);
  float4 lightSpotFactors : packoffset(c80);
  float4 lightAttenuation : packoffset(c81);
  float4 lightFallOffA : packoffset(c82);
  float4 lightFallOffB : packoffset(c83);
  float4 lightSpotMatrix0 : packoffset(c84);
  float4 lightSpotMatrix1 : packoffset(c85);
  float4 lightSpotMatrix2 : packoffset(c86);
  float4 lightSpotMatrix3 : packoffset(c87);
  float4 lightSpotAABB : packoffset(c88);
  float4 lightConeControl1 : packoffset(c89);
  float4 lightConeControl2 : packoffset(c90);
  float4 lightSpotCookieSlideControl : packoffset(c91);
  float4 spotShadowmapPixelAdjust : packoffset(c92);
  float4 dlightSpotShadowmapPixelAdjust : packoffset(c93);
  float4 _characterCharredAmount : packoffset(c94);
  float4 renderTargetSize : packoffset(c95);
  float4 upscaledTargetSize : packoffset(c96);
  float4 shadowmapSwitchPartition : packoffset(c97);
  float4 shadowmapPolygonOffset : packoffset(c98);
  float4 sunShadowmapPixelSize : packoffset(c99);
  float4 materialColor : packoffset(c100);
  float4 skyTransition : packoffset(c101);
  float rimIntensity : packoffset(c102);
  float4 filterTap[8] : packoffset(c103);
  float4 cameraUp : packoffset(c111);
  float4 cameraLook : packoffset(c112);
  float4 cameraSide : packoffset(c113);
  float4 heroLightingR : packoffset(c114);
  float4 heroLightingG : packoffset(c115);
  float4 heroLightingB : packoffset(c116);
  float4 eyeOffset : packoffset(c117);
  float4 genericEyeOffset : packoffset(c118);
  float4 genericQuadIntensity : packoffset(c119);
  float4 postFxControl0 : packoffset(c120);
  float4 postFxControl1 : packoffset(c121);
  float4 postFxControl2 : packoffset(c122);
  float4 postFxControl3 : packoffset(c123);
  float4 postFxControl4 : packoffset(c124);
  float4 postFxControl5 : packoffset(c125);
  float4 postFxControl6 : packoffset(c126);
  float4 postFxControl7 : packoffset(c127);
  float4 postFxControl8 : packoffset(c128);
  float4 postFxControl9 : packoffset(c129);
  float4 postFxControlA : packoffset(c130);
  float4 postFxControlB : packoffset(c131);
  float4 postFxControlC : packoffset(c132);
  float4 postFxControlD : packoffset(c133);
  float4 postFxControlE : packoffset(c134);
  float4 postFxControlF : packoffset(c135);
  float4 cloudLayerControl0 : packoffset(c136);
  float4 cloudLayerControl1 : packoffset(c137);
  float4 cloudLayerControl2 : packoffset(c138);
  float4 cloudLayerControl3 : packoffset(c139);
  float4 emblemLUTSelector : packoffset(c140);
  float skyColorMultiplier : packoffset(c141);
  float extraCamParam : packoffset(c141.y);
  float4 glowSetup : packoffset(c142);
  float4 glowApply : packoffset(c143);
  float4 colorMatrixR : packoffset(c144);
  float4 colorMatrixG : packoffset(c145);
  float4 colorMatrixB : packoffset(c146);
  float4 colorTintBase : packoffset(c147);
  float4 colorTintDelta : packoffset(c148);
  float4 colorBias : packoffset(c149);
  float4 cinematicBlurBox : packoffset(c150);
  float4 cinematicBlurBox2 : packoffset(c151);
}

cbuffer PerObjectConsts : register(b1)
{
  float4x4 worldViewMatrix : packoffset(c0);
  float4x4 worldViewProjectionMatrix : packoffset(c4);
  float4x4 inverseTransposeWorldViewMatrix : packoffset(c8);
  float4x4 inverseWorldViewMatrix : packoffset(c12);
  float4 clipSpaceLookupScale : packoffset(c16);
  float4 clipSpaceLookupOffset : packoffset(c17);
  float4 particleCloudColor : packoffset(c18);
  float4 particleCloudMatrix : packoffset(c19);
  float4 particleCloudVelWorld : packoffset(c20);
  float4 codeMeshArg[2] : packoffset(c21);
  float4 scriptVector0 : packoffset(c23);
  float4 scriptVector1 : packoffset(c24);
  float4 scriptVector2 : packoffset(c25);
  float4 scriptVector3 : packoffset(c26);
  float4 scriptVector4 : packoffset(c27);
  float4 scriptVector5 : packoffset(c28);
  float4 scriptVector6 : packoffset(c29);
  float4 scriptVector7 : packoffset(c30);
  float4 weaponParam0 : packoffset(c31);
  float4 weaponParam1 : packoffset(c32);
  float4 weaponParam2 : packoffset(c33);
  float4 weaponParam3 : packoffset(c34);
  float4 weaponParam4 : packoffset(c35);
  float4 weaponParam5 : packoffset(c36);
  float4 weaponParam6 : packoffset(c37);
  float4 weaponParam7 : packoffset(c38);
  float4 weaponParam8 : packoffset(c39);
  float4 weaponParam9 : packoffset(c40);
  float4 flagParams : packoffset(c41);
  float3 occlusionAmount : packoffset(c42);
  float4 colorObjMin : packoffset(c43);
  float4 colorObjMax : packoffset(c44);
  float colorObjMinBaseBlend : packoffset(c45);
  float colorObjMaxBaseBlend : packoffset(c45.y);
  float2 uvScroll : packoffset(c45.z);
  float4 featherParms : packoffset(c46);
  float4 falloffParms : packoffset(c47);
  float4 falloffBeginColor : packoffset(c48);
  float4 falloffEndColor : packoffset(c49);
  float4 eyeOffsetParms : packoffset(c50);
  float4 alphaDissolveParms : packoffset(c51);
  float4 spotLightWeight : packoffset(c52);
  float4 detailScale : packoffset(c53);
  float4 detailScale1 : packoffset(c54);
  float4 detailScale2 : packoffset(c55);
  float4 detailScale3 : packoffset(c56);
  float4 detailScale4 : packoffset(c57);
  float4 alphaRevealParms : packoffset(c58);
  float4 alphaRevealParms1 : packoffset(c59);
  float4 alphaRevealParms2 : packoffset(c60);
  float4 alphaRevealParms3 : packoffset(c61);
  float4 alphaRevealParms4 : packoffset(c62);
  float4 colorDetailScale : packoffset(c63);
  float4 colorTint : packoffset(c64);
}

SamplerState OverlayMap_s : register(s1);
SamplerState GhostMap1_s : register(s2);
SamplerState ResolvedPostSun_Sampler_C1_P0_s : register(s3);
Texture2D<float4> GhostMap1 : register(t0);
Texture2D<float4> OverlayMap : register(t1);
Texture2D<float4> ResolvedPostSun_Sampler_C1_P0 : register(t2);


// 3Dmigoto declarations
#define cmp -

// HDR safety helpers.
//
// The original UNORM path implicitly constrained several values. After an
// R16G16B16A16_FLOAT upgrade, HDR values above 1.0 can make expressions such as
// pow(1 - sceneBrightness, GhostPower) invalid. These helpers protect only the
// mathematical domains; valid HDR RGB is not clamped to 1.0.

float SafeFinite1(float value, float fallback)
{
  // NaN is the only floating-point value that is not equal to itself.
  value = (value == value) ? value : fallback;

  // Also convert infinities to values representable by float16.
  return clamp(value, -65504.0, 65504.0);
}

float SafeSignedDenominator(float value)
{
  value = SafeFinite1(value, 1.0);

  if (abs(value) < 0.000001)
  {
    return (value < 0.0) ? -0.000001 : 0.000001;
  }

  return value;
}

float SafePowNonNegative(float baseValue, float exponentValue)
{
  baseValue = max(SafeFinite1(baseValue, 0.0), 0.0);
  exponentValue = max(SafeFinite1(exponentValue, 1.0), 0.0);

  if (baseValue <= 0.0)
  {
    return (exponentValue <= 0.0) ? 1.0 : 0.0;
  }

  return clamp(
    SafeFinite1(exp2(log2(baseValue) * exponentValue), 0.0),
    0.0,
    65504.0
  );
}

float3 SafePositiveHDR(float3 color)
{
  color.x = SafeFinite1(color.x, 0.0);
  color.y = SafeFinite1(color.y, 0.0);
  color.z = SafeFinite1(color.z, 0.0);

  // Preserve HDR values above 1.0; remove only invalid/negative values.
  return clamp(color, 0.0, 65504.0);
}



void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float3 v2 : TEXCOORD3,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy / float2(
    SafeSignedDenominator(renderTargetSize.x),
    SafeSignedDenominator(renderTargetSize.y)
  );
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.y = r0.x * 0.707213581 + -WarpRadius.x;
  r0.x = r0.x * 0.707213581 + -ShiftRadius.x;
  r0.z = 1 / SafeSignedDenominator(
    WarpRadius.y - WarpRadius.x
  );
  r0.y = saturate(r0.y * r0.z);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.y = -r0.y * r0.y + 1;
  r0.y = r0.y * scriptVector1.z + 1;
  r0.zw = float2(-0.5,-0.5) + v0.xy;
  r0.yz = r0.zw / SafeSignedDenominator(r0.y);
  r1.xy = float2(0.5,0.5) + r0.yz;
  r1.xyzw = ResolvedPostSun_Sampler_C1_P0.Sample(ResolvedPostSun_Sampler_C1_P0_s, r1.xy).xyzw;
  r0.w = 1 / SafeSignedDenominator(
    ShiftRadius.y - ShiftRadius.x
  );
  r0.x = saturate(r0.x * r0.w);
  r0.w = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.w * r0.x;
  r0.x = -r0.x * r0.x + 1;
  r0.w = 1 + -r0.x;
  r0.x = scriptVector1.y * r0.x;
  r1.w = 0.00999999978 * BlurAmount;
  r0.w = r1.w * r0.w;
  r1.w = saturate(scriptVector0.x);
  r2.x = -0.5 + r1.w;
  r2.x = max(0, r2.x);
  r2.y = r0.w * r2.x + 1;
  r0.w = r2.x * r0.w;
  r0.w = r0.w * 2 + 1;
  r2.xz = r0.yz / SafeSignedDenominator(r0.w);
  r2.xz = float2(0.5,0.5) + r2.xz;
  r3.xyzw = ResolvedPostSun_Sampler_C1_P0.Sample(ResolvedPostSun_Sampler_C1_P0_s, r2.xz).xyzw;
  r2.xy = r0.yz / SafeSignedDenominator(r2.y);
  r2.xy = float2(0.5,0.5) + r2.xy;
  r2.xyzw = ResolvedPostSun_Sampler_C1_P0.Sample(ResolvedPostSun_Sampler_C1_P0_s, r2.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = r1.xyz + r3.xyz;
  r0.x = r1.w * r0.x;
  r0.xy = r0.xx * float2(0.0500000007,0) + r0.yz;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xyzw = ResolvedPostSun_Sampler_C1_P0.Sample(ResolvedPostSun_Sampler_C1_P0_s, r0.xy).xyzw;
  r0.xyz = -r1.xyz * float3(0.333333343,0.333333343,0.333333343) + r0.xyz;
  r1.xyz = float3(0.333333343,0.333333343,0.333333343) * r1.xyz;
  r0.xyz = ShiftBlend * r0.xyz;
  r0.xyz = r1.www * r0.xyz + r1.xyz;
  r0.w = r1.w + r1.w;
  r0.w = min(1, r0.w);
  // HDR-safe form of pow(1 - averageSceneRGB, GhostPower).
  // For HDR highlights averageSceneRGB can exceed 1.0. The original log2 of
  // the resulting negative value produced NaN and made the highlight black.
  r1.x = dot(
    SafePositiveHDR(r0.xyz),
    float3(0.333299994,0.333299994,0.333299994)
  );
  r1.x = SafePowNonNegative(
    saturate(1.0 - r1.x),
    GhostPower
  );
  r2.xyzw = GhostMap1.Sample(GhostMap1_s, w0.xy).xyzw;
  r1.y = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));
  r3.xyz = r1.yyy + -r2.xyz;
  r3.w = 0;
  r2.xyzw = scriptVector1.xxxx * r3.xyzw + r2.xyzw;
  r1.yzw = r2.xyz * r2.www;
  r1.yzw = GhostIntensity * r1.yzw;
  r1.yzw = scriptVector0.yyy * r1.yzw;
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  r1.xyzw = OverlayMap.Sample(OverlayMap_s, v0.xy).xyzw;
  r1.w = OverlayAmount * r1.w;
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r0.w = r1.w * r0.w;
  r1.xyz = r0.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * v2.xyz + -r0.xyz;
  r0.xyz = v1.xxx * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.x = 1 + -r0.w;
  r1.x = r1.x * r1.x;
  r1.x = -r1.x * Brightness + 1;
  r1.y = r0.w * r0.w;
  r0.w = -1 + r0.w;
  r0.w = saturate(10 * r0.w);
  r1.x = -r1.y * Brightness + r1.x;
  r1.y = Brightness * r1.y;
  r0.w = r0.w * r1.x + r1.y;
  r1.x = SafePowNonNegative(
    max(SafeFinite1(r0.w, 0.0), 0.0),
    Falloff
  );
  r1.x = saturate(Boost * r1.x);
  r1.xyz = r1.xxx * float3(1,0,0) + r0.www;
  r1.xyz = r1.xyz * r1.xyz + -r0.xyz;
  o0.xyz = SafePositiveHDR(
    v1.yyy * r1.xyz + r0.xyz
  );
  o0.w = 0;
  return;
}