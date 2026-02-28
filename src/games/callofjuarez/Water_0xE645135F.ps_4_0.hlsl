#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Fri Jan 30 22:52:24 2026

cbuffer _Globals : register(b0)
{
  float4 RENDER_TARGET_PARAMS : packoffset(c0);
  float4x4 SHADOW_XFORM_BIAS_WS_0 : packoffset(c1);
  float4x4 SHADOW_XFORM_BIAS_WS_1 : packoffset(c5);
  float4x4 SHADOW_XFORM_BIAS_WS_2 : packoffset(c9);
  float4x4 SHADOW_XFORM_BIAS_MS_0 : packoffset(c13);
  float4x4 SHADOW_XFORM_BIAS_MS_1 : packoffset(c17);
  float4x4 SHADOW_XFORM_BIAS_MS_2 : packoffset(c21);
  float4 POSITION_BIAS_SCALE : packoffset(c25);
  float4 NRM_TAN_TEX_SCALE : packoffset(c26);
  float4 FOG_PARAMS : packoffset(c27);
  float4x4 COMBINED_XFORM : packoffset(c28);
  float4x4 MODELVIEW_XFORM : packoffset(c32);
  float4x4 INVMODEL_XFORM : packoffset(c36);
  float4x4 MODEL_XFORM : packoffset(c40);
  float4x4 VIEW_XFORM : packoffset(c44);
  float4x4 PROJECTION_XFORM : packoffset(c48);
  float4x4 VIEWPROJ_XFORM : packoffset(c52);
  float4 BACKBUFFER_PARAMS : packoffset(c56);
  float4 TIME : packoffset(c57);
  float3 LIGHT_DIR_MS : packoffset(c58);
  float3 LIGHT_DIR_MS_0 : packoffset(c59);
  float4 LIGHT_POS_MS : packoffset(c60);
  float4 LIGHT_POS_MS_0 : packoffset(c61);
  float4 LIGHT_POS_MS_1 : packoffset(c62);
  float4 LIGHT_POS_MS_2 : packoffset(c63);
  float4x4 LIGHT_XFORM_MS : packoffset(c64);
  float4x4 LIGHT_XFORM_MS_0 : packoffset(c68);
  float4x4 LIGHT_XFORM_MS_1 : packoffset(c72);
  float4x4 LIGHT_XFORM_MS_2 : packoffset(c76);
  float4x4 LIGHT_XFORM_BIAS_MS : packoffset(c80);
  float4x4 LIGHT_XFORM_BIAS_MS_0 : packoffset(c84);
  float4x4 LIGHT_XFORM_BIAS_MS_1 : packoffset(c88);
  float4x4 LIGHT_XFORM_BIAS_MS_2 : packoffset(c92);
  float3 LIGHT_DIR_WS : packoffset(c96);
  float3 LIGHT_DIR_WS_0 : packoffset(c97);
  float4 LIGHT_POS_WS : packoffset(c98);
  float4 LIGHT_POS_WS_0 : packoffset(c99);
  float4 LIGHT_POS_WS_1 : packoffset(c100);
  float4 LIGHT_POS_WS_2 : packoffset(c101);
  float4x4 LIGHT_XFORM_WS : packoffset(c102);
  float4x4 LIGHT_XFORM_WS_0 : packoffset(c106);
  float4x4 LIGHT_XFORM_WS_1 : packoffset(c110);
  float4x4 LIGHT_XFORM_WS_2 : packoffset(c114);
  float4x4 LIGHT_XFORM_BIAS_WS : packoffset(c118);
  float4x4 LIGHT_XFORM_BIAS_WS_0 : packoffset(c122);
  float4x4 LIGHT_XFORM_BIAS_WS_1 : packoffset(c126);
  float4x4 LIGHT_XFORM_BIAS_WS_2 : packoffset(c130);
  float3 LIGHT_COLOR : packoffset(c134);
  float3 LIGHT_COLOR_0 : packoffset(c135);
  float3 LIGHT_COLOR_1 : packoffset(c136);
  float3 LIGHT_COLOR_2 : packoffset(c137);
  float4 CAMERA_POS_MS : packoffset(c138);
  float4 CAMERA_POS_WS : packoffset(c139);
  float4 ENV_SH[9] : packoffset(c140);
  float4 SCATTERING[4] : packoffset(c149);
  float4 CONST_0 : packoffset(c153);
  float4 CONST_1 : packoffset(c154);
  float4 CONST_2 : packoffset(c155);
  float4 CONST_3 : packoffset(c156);
  float4 CONST_4 : packoffset(c157);
  float4 CONST_5 : packoffset(c158);
  float4 CONST_6 : packoffset(c159);
  float4 CONST_7 : packoffset(c160);
  float4 CONST_8 : packoffset(c161);
  float4 CONST_9 : packoffset(c162);
  float4 CONST_10 : packoffset(c163);
  float4 CONST_11 : packoffset(c164);
  float4 CONST_12 : packoffset(c165);
  float4 CONST_13 : packoffset(c166);
  float4 CONST_14 : packoffset(c167);
  float4 CONST_15 : packoffset(c168);
  float4 CONST_16 : packoffset(c169);
  float4 CONST_17 : packoffset(c170);
  float4 CONST_18[4] : packoffset(c171);
  float4 CONST_22 : packoffset(c175);
  float4 CONST_23 : packoffset(c176);
  float4 CONST_24[4] : packoffset(c177);
  float4 CONST_28[4] : packoffset(c181);
  float4 CONST_32[4] : packoffset(c185);
  float4 CONST_36[4] : packoffset(c189);
  float4 CONST_40 : packoffset(c193);
  float4 CONST_41 : packoffset(c194);
  float4 CONST_42 : packoffset(c195);
  float4 CONST_43 : packoffset(c196);
  float4 CONST_90 : packoffset(c197);
  float4 TEX_INV_SIZE_NRM_sColor0 : packoffset(c198);
  float4 TEX_SIZE_NRM_sHeight0 : packoffset(c199);
  float4 TEX_SIZE_NRM_sHeight1 : packoffset(c200);
  float4 TEX_SIZE_NRM_sHeight2 : packoffset(c201);
  float4 TEX_SIZE_NRM_sHeight3 : packoffset(c202);
  float2 TEX_SIZE_sShadowMap0 : packoffset(c203);
  float2 TEX_SIZE_sShadowMap1 : packoffset(c203.z);
  float2 TEX_SIZE_sShadowMap2 : packoffset(c204);
  float2 TEX_INV_SIZE_sShadowMap0 : packoffset(c204.z);
  float2 TEX_INV_SIZE_sShadowMap1 : packoffset(c205);
  float2 TEX_INV_SIZE_sShadowMap2 : packoffset(c205.z);
  float4 aNGQuad0 : packoffset(c206);
  float4 aNGQuad1 : packoffset(c207);
  float4 aNGQuad2 : packoffset(c208);
  float4 aNGQuad3 : packoffset(c209);
  float4 vNGRange : packoffset(c210);
  float4 grass_wind_force_params : packoffset(c211);
  float4 grass_wave : packoffset(c212);
  float4 grass_wind_force : packoffset(c213);
  float4 grass_params : packoffset(c214);
  float4 ngPlayerPos : packoffset(c215);
  float4 quad[4] : packoffset(c216);
  float water_level : packoffset(c220);
  float terrain_inv_x : packoffset(c220.y);
  float terrain_inv_y : packoffset(c220.z);
  float terrain_inv_z : packoffset(c220.w);
  float fShadowmap0Bias : packoffset(c221);
  float fShadowmap1Bias : packoffset(c221.y);
  float fShadowmap2Bias : packoffset(c221.z);
  float fHDRSunIntensity : packoffset(c221.w);
  float fhdrambientintensity : packoffset(c222);
  float fHDRLightsIntensity : packoffset(c222.y);
  float fHDRSkyIntensity : packoffset(c222.z);
  float fHDRSelfIlluminationIntensity : packoffset(c222.w);
  float4 vGlowParams : packoffset(c223);
  float4 vColorParams : packoffset(c224);
  float fBulletTime : packoffset(c225);
  float fPlayerDamage : packoffset(c225.y);
  int iUseWaterReflection : packoffset(c225.z);
  int iUseWaterBorder : packoffset(c225.w);
  int iUseWaterSpecular : packoffset(c226);
  int iUseWaterFresnel : packoffset(c226.y);
  int iUseWaterWavesNumber : packoffset(c226.z);
  float fGrassSizeFactor : packoffset(c226.w);
  float4 vAmbient : packoffset(c227);
  float4 vTerrainDetail0 : packoffset(c228);
  float4 vTerrainDetail1 : packoffset(c229);
  float4 vTerrainCliff : packoffset(c230);
  float4 vWaterColor : packoffset(c231);
  float fWaterBaseOpacity : packoffset(c232);
  float fWaterReflDeformPower : packoffset(c232.y);
  float fWaterPlantsDeformPower : packoffset(c232.z);
  float fWaterDepth : packoffset(c232.w);
  float fWindPower : packoffset(c233);
  float fFakeBumpPower : packoffset(c233.y);
  float fRefractionPower : packoffset(c233.z);
  float fDiffuseGlow : packoffset(c233.w);
  float fGrassColormapScaleX : packoffset(c234);
  float fGrassColormapScaleY : packoffset(c234.y);
  float fGrassColormapOffsetX : packoffset(c234.z);
  float fGrassColormapOffsetY : packoffset(c234.w);
  float3 vWindCurrentForce : packoffset(c235);
  float3 vWindInitialDir : packoffset(c236);
  float fUndergrowthHeight : packoffset(c236.w);
  float fTopDetailSize : packoffset(c237);
  float fSideDetailSize : packoffset(c237.y);
  float fDetailsBorder : packoffset(c237.z);
  float fUndergrowthScale : packoffset(c237.w);
  float fWaterWave1ScaleX : packoffset(c238);
  float fWaterWave1ScaleY : packoffset(c238.y);
  float fWaterWave2ScaleX : packoffset(c238.z);
  float fWaterWave2ScaleY : packoffset(c238.w);
  float fWaterWave1SpeedX : packoffset(c239);
  float fWaterWave1SpeedY : packoffset(c239.y);
  float fWaterWave2SpeedX : packoffset(c239.z);
  float fWaterWave2SpeedY : packoffset(c239.w);
  float fSkyScale : packoffset(c240);
  float fSkyScaleHDR : packoffset(c240.y);
  float fSkyCloudsL0Scale : packoffset(c240.z);
  float fSkyCloudsL0Speed : packoffset(c240.w);
  float fSkyCloudsL1Scale : packoffset(c241);
  float fSkyCloudsL1Speed : packoffset(c241.y);
  float fSkyCloudsL2Scale : packoffset(c241.z);
  float fSkyCloudsL2Speed : packoffset(c241.w);
  float fSkyHorizonScaleH : packoffset(c242);
  float fSkyHorizonScaleV : packoffset(c242.y);
  float fSkyBackgroundScale : packoffset(c242.z);
  float4 vHorizonColor : packoffset(c243);
  float3 vSunDir : packoffset(c244);
  float4 vSunColor : packoffset(c245);
}

SamplerState samBackbuffer_s : register(s0);
SamplerState samReflection_s : register(s1);
SamplerState samWaterBorder_s : register(s2);
SamplerState samCubemap_s : register(s3);
SamplerState samNormal0_s : register(s4);
Texture2D<float4> sBackbuffer : register(t0);
Texture2D<float4> sReflection : register(t1);
Texture2D<float4> sWaterBorder : register(t2);
TextureCube<float4> sCubemap : register(t3);
Texture2D<float4> sNormal0 : register(t4);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  linear centroid float4 v1 : TEXCOORD0,
  linear centroid float4 v2 : TEXCOORD1,
  linear centroid float4 v3 : TEXCOORD2,
  linear centroid float2 v4 : TEXCOORD3,
  linear centroid float2 w4 : TEXCOORD5,
  linear centroid float4 v5 : TEXCOORD4,
  linear centroid float2 v6 : TEXCOORD6,
  linear centroid float2 w6 : TEXCOORD7,
  linear centroid float2 v7 : TEXCOORD8,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sNormal0.Sample(samNormal0_s, w4.xy).xyzw;
  r1.xyzw = sNormal0.Sample(samNormal0_s, v6.xy).xyzw;
  r0.xy = r1.xy + r0.xy;
  r1.xyzw = sNormal0.Sample(samNormal0_s, w6.xy).xyzw;
  r0.xy = r1.xy + r0.xy;
  r1.xyzw = sNormal0.Sample(samNormal0_s, v7.xy).xyzw;
  r0.xy = r1.xy + r0.xy;
  r0.xz = float2(0.25,0.25) * r0.xy;
  r0.w = -r0.x * r0.x + 1;
  r0.w = -r0.z * r0.z + r0.w;
  r0.y = sqrt(r0.w);
  r0.w = dot(v5.xyz, r0.xyz);
  r0.w = r0.w + r0.w;
  r1.xyz = r0.xyz * -r0.www + v5.xyz;
  r1.xyzw = sCubemap.Sample(samCubemap_s, r1.xyz).xyzw;
  r2.xy = r0.xz * fWaterReflDeformPower + v3.xy;
  r2.xy = r2.xy / v3.zz;
  r2.xyzw = sReflection.Sample(samReflection_s, r2.xy).xyzw;
  r3.xyz = vSunColor.xyz * fHDRSunIntensity + -vAmbient.xyz;
  r4.xyzw = sWaterBorder.Sample(samWaterBorder_s, v4.xy).xyzw;
  r3.xyz = r4.yyy * r3.xyz + vAmbient.xyz;
  r2.xyz = -r1.xyz * r3.xyz + r2.xyz;
  r1.xyz = r3.xyz * r1.xyz;
  r0.w = dot(v5.xyz, v5.xyz);
  r0.w = rsqrt(r0.w);
  r1.w = -v5.y * r0.w + 1;
  r1.w = r1.w * r1.w;
  r1.w = r1.w * r1.w;
  r1.xyz = r1.www * r2.xyz + r1.xyz;
  r2.xyz = v5.xyz * r0.www;
  r3.xyz = v5.xyz * r0.www + vSunDir.xyz;
  r0.w = dot(r0.xyz, r2.xyz);
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w;
  r2.xy = float2(0.5,0.5) + v0.xy;
  r2.xy = RENDER_TARGET_PARAMS.xy * r2.xy;
  r5.xyzw = sBackbuffer.Sample(samBackbuffer_s, r2.xy).xyzw;
  r1.w = -v2.w + r5.w;
  r2.z = saturate(r1.w / fWaterDepth);
  r1.w = saturate(10 * r1.w);
  r0.w = r2.z * r0.w;
  r1.xyz = r0.www * r1.xyz;
  r1.xyz = v1.xyz * r1.xyz;
  r4.xz = fRefractionPower * r0.xz;
  r2.xy = -r4.xz * r2.zz + r2.xy;
  r6.xyzw = sBackbuffer.Sample(samBackbuffer_s, r2.xy).xyzw;
  r2.xyw = r6.xyz + -r5.xyz;
  r2.xyw = r1.www * r2.xyw + r5.xyz;
  r4.xzw = float3(1,1,1) + -vWaterColor.xyz;
  r4.xzw = r4.xzw * v1.xyz + -v2.xyz;
  r4.xzw = r2.zzz * -r4.xzw + float3(1,1,1);
  r1.xyz = r2.xyw * r4.xzw + r1.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r1.www * r3.xyz;
  r0.x = saturate(dot(r2.xyz, r0.xyz));
  r0.x = r0.x * 1.04999995 + -0.0250000004;
  r0.x = log2(r0.x);
  r0.x = 100 * r0.x;
  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    r0.x = saturate(exp2(r0.x));
  } else {
    r0.x = (exp2(r0.x));
  }
  r0.x = r0.x * r4.y;
  r2.xyz = vSunColor.xyz * fHDRSunIntensity;
  r0.xyz = r2.xyz * r0.xxx;
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = r0.xyz * v1.xyz + r1.xyz;
  o0.w = v2.w;
  return;
}