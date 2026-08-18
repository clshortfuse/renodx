// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 01 13:21:16 2026

cbuffer _Globals : register(b2)
{
  float4x4 inverseTransposeWorldMatrix : packoffset(c0);
  float4 gameTime : packoffset(c4);
  float Reflection_Amount : packoffset(c5);
  float Normal_Detail_Scale : packoffset(c5.y);
  float Specular_Amount : packoffset(c5.z);
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

SamplerState Normal_Detail_Map_s : register(s1);
SamplerState Normal_Map_s : register(s2);
SamplerState SpecularAndGloss_s : register(s3);
SamplerState Hue_Map_s : register(s4);
SamplerState Luminance_Map_s : register(s5);
SamplerState modelLightingSampler_s : register(s13);
SamplerState reflectionProbeSampler_s : register(s15);
Texture2D<float4> Normal_Map : register(t0);
Texture2D<float4> Normal_Detail_Map : register(t1);
Texture2D<float4> Luminance_Map : register(t2);
Texture2D<float4> Hue_Map : register(t3);
Texture2D<float4> SpecularAndGloss : register(t4);
Texture3D<float4> modelLightingSampler : register(t13);
TextureCube<float4> reflectionProbeSampler : register(t15);


// 3Dmigoto declarations
#define cmp -


// HDR/float-upgrade safety helpers.
// Preserve values above 1.0 while preventing NaN/INF propagation.
float SafePositive1(float value)
{
  value = (value == value) ? value : 0.0f; // NaN -> 0
  return min(max(value, 0.0f), 65504.0f);
}

float2 SafePositive2(float2 value)
{
  return float2(SafePositive1(value.x), SafePositive1(value.y));
}

float3 SafePositive3(float3 value)
{
  return float3(
    SafePositive1(value.x),
    SafePositive1(value.y),
    SafePositive1(value.z)
  );
}



void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD7,
  float3 v7 : TEXCOORD8,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Luminance_Map.Sample(Luminance_Map_s, v5.xy).xyzw;
  r0.xyzw = v2.xxyz * r0.xxyz;
  r1.xyzw = Hue_Map.Sample(Hue_Map_s, v5.xy).xyzw;
  r0.xyzw = r1.xxyz * v2.xxyz + r0.xyzw;
  r1.xy = float2(-0.444999993,-0.444999993) + r0.zw;
  r0.xyzw = float4(-0.5,-0.444999993,-0.5,-0.5) + r0.xyzw;
  r1.xy = float2(0.947867274,0.947867274) * r1.xy;
  r1.xy = log2(max(r1.xy, float2(0.000001,0.000001)));
  r1.xy = float2(2.4000001,2.4000001) * r1.xy;
  r1.xy = exp2(r1.xy);
  r2.xyz = cmp(r0.xzw < float3(0.0404499993,0.0404499993,0.0404499993));
  r0.xyzw = float4(0.0773993805,0.947867274,0.0773993805,0.0773993805) * r0.xyzw;
  r0.zw = r2.yz ? r0.zw : r1.xy;
  r0.y = log2(max(r0.y, 0.000001));
  r0.y = 2.4000001 * r0.y;
  r0.y = exp2(r0.y);
  r0.x = r2.x ? r0.x : r0.y;
  r1.xyz = sqrt(SafePositive3(r0.xzw));
  r0.xyz = v2.xyz * r1.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.w = dot(v1.xyz, v1.xyz);
  r0.w = rsqrt(max(r0.w, 0.000000000001));
  r1.xyz = -v1.xyz * r0.www + sunPosition.xyz;
  r2.xyz = v1.xyz * r0.www;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(max(r0.w, 0.000000000001));
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(v3.xyz, v3.xyz);
  r0.w = rsqrt(max(r0.w, 0.000000000001));
  r3.xyz = v3.xyz * r0.www;
  r4.xyz = v4.yzx * r3.zxy;
  r4.xyz = r3.yzx * v4.zxy + -r4.xyz;
  r4.xyz = v4.www * r4.xyz;
  r5.xyzw = Normal_Map.Sample(Normal_Map_s, v5.xy).xyzw;
  r5.xy = r5.xy * float2(4.01574802,4.01574802) + float2(-2.01574802,-2.01574802);
  r5.zw = Normal_Detail_Scale * v5.xy;
  r6.xyzw = Normal_Detail_Map.Sample(Normal_Detail_Map_s, r5.zw).xyzw;
  r5.xy = r6.xy * float2(4.01574802,4.01574802) + r5.xy;
  r5.xy = float2(-2.01574802,-2.01574802) + r5.xy;
  r3.xyz = r5.xxx * v4.xyz + r3.xyz;
  r3.xyz = r5.yyy * r4.xyz + r3.xyz;
  r0.w = dot(r3.xyz, r3.xyz);
  r0.w = rsqrt(max(r0.w, 0.000000000001));
  r3.xyz = r3.xyz * r0.www;
  r0.w = saturate(dot(r3.xyz, r1.xyz));
  r1.x = saturate(dot(r1.xyz, sunPosition.xyz));
  r0.w = log2(max(r0.w, 0.000001));
  r4.xyzw = SpecularAndGloss.Sample(SpecularAndGloss_s, v5.xy).xyzw;
  r1.y = 13 * r4.w;
  r1.y = exp2(r1.y);
  r0.w = r1.y * r0.w;
  r1.y = r1.y * 0.125 + 0.25;
  r0.w = exp2(r0.w);
  r0.w = r1.y * r0.w;
  r1.y = r1.x * r1.x;
  r1.x = -10 * r1.x;
  r1.x = exp2(r1.x);
  r1.z = saturate(0.545000017 + r4.w);
  r1.y = r1.y * r1.z + -r1.z;
  r1.y = 1.00999999 + r1.y;
  r1.z = saturate(dot(sunPosition.xyz, r3.xyz));
  r1.y = r1.z / r1.y;
  r0.w = r1.y * r0.w;
  r1.y = saturate(scriptVector0.x);
  r1.y = 1 + -r1.y;
  r4.xyz = r4.xyz * r1.yyy;
  r5.xyz = -r4.xyz * r4.xyz + float3(1,1,1);
  r4.xyz = r4.xyz * r4.xyz;
  r1.xyw = r5.xyz * r1.xxx + r4.xyz;
  r1.xyw = r1.xyw * r0.www;
  r5.x = 1;
  r5.yz = v2.ww;
  r5.xy = Specular_Amount * r5.xy;
  r1.xyw = r5.xxx * r1.xyw;
  r6.xyz = sunDiffuse.xyz * v6.www;
  r1.xyw = r6.xyz * r1.xyw;
  r0.w = dot(r2.xyz, r3.xyz);
  r0.w = r0.w + r0.w;
  r7.xyz = r3.xyz * -r0.www + r2.xyz;
  r0.w = saturate(dot(r3.xyz, -r2.xyz));
  r0.w = -9.27999973 * r0.w;
  r0.w = exp2(r0.w);
  r2.x = r4.w * -4 + 4;
  r8.xyzw = r4.wwww * float4(1.04166675,0.474999994,0.0182291996,0.25) + float4(0,0,-0.015625,0.75);
  r2.xyzw = reflectionProbeSampler.SampleLevel(reflectionProbeSampler_s, r7.xyz, r2.x).xyzw;
  r2.w = 9.99999997e-007 + r2.w;
  r2.w = 1 / r2.w;
  r2.xyz = r2.xyz * r2.www;
  r0.w = min(r8.y, r0.w);
  r0.w = r8.x * r0.w + r8.z;
  r2.w = r8.w + -r0.w;
  r4.xyz = saturate(r4.xyz * r2.www + r0.www);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r2.xyz * r5.yyy;
  r1.xyw = r2.xyz * v7.xyz + r1.xyw;
  r0.w = max(abs(r3.y), abs(r3.z));
  r0.w = max(abs(r3.x), r0.w);
  r2.xyz = lightingLookupScale.xyz * r3.xyz;
  r2.xyz = r2.xyz / max(r0.www, 0.000001);
  r2.xyz = v6.xyz + r2.xyz;
  r2.xyzw = modelLightingSampler.Sample(modelLightingSampler_s, r2.xyz).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r5.zzz;
  r2.xyz = float3(32,32,32) * r2.xyz;
  r2.xyz = r1.zzz * r6.xyz + r2.xyz;
  r0.xyz = r0.xyz * r2.xyz + r1.xyw;
  r0.w = 1;
  r1.x = dot(r0.xyzw, heroLightingR.xyzw);
  r1.y = dot(r0.xyzw, heroLightingG.xyzw);
  r1.z = dot(r0.xyzw, heroLightingB.xyzw);
  r0.xyz = -v0.xyz + r1.xyz;
  r0.xyz = v1.www * r0.xyz + v0.xyz;
  r0.xyz = hdrControl0.xxx * r0.xyz;
  o0.xyz = sqrt(SafePositive3(r0.xyz));
  o0.w = 1;
  return;
}