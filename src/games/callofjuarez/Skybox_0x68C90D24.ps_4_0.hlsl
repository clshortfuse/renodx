#include "./shared.h"
#include "./FakeHDRGain.hlsl"

// ---- Created with 3Dmigoto v1.2.45 on Fri Jan 30 22:52:09 2026

cbuffer _Globals : register(b0)
{
  float4x4 SHADOW_XFORM_BIAS_WS_0 : packoffset(c0);
  float4x4 SHADOW_XFORM_BIAS_WS_1 : packoffset(c4);
  float4x4 SHADOW_XFORM_BIAS_WS_2 : packoffset(c8);
  float4x4 SHADOW_XFORM_BIAS_MS_0 : packoffset(c12);
  float4x4 SHADOW_XFORM_BIAS_MS_1 : packoffset(c16);
  float4x4 SHADOW_XFORM_BIAS_MS_2 : packoffset(c20);
  float4 POSITION_BIAS_SCALE : packoffset(c24);
  float4 NRM_TAN_TEX_SCALE : packoffset(c25);
  float4 FOG_PARAMS : packoffset(c26);
  float4x4 COMBINED_XFORM : packoffset(c27);
  float4x4 MODELVIEW_XFORM : packoffset(c31);
  float4x4 INVMODEL_XFORM : packoffset(c35);
  float4x4 MODEL_XFORM : packoffset(c39);
  float4x4 VIEW_XFORM : packoffset(c43);
  float4x4 PROJECTION_XFORM : packoffset(c47);
  float4x4 VIEWPROJ_XFORM : packoffset(c51);
  float4 BACKBUFFER_PARAMS : packoffset(c55);
  float4 TIME : packoffset(c56);
  float3 LIGHT_DIR_MS : packoffset(c57);
  float3 LIGHT_DIR_MS_0 : packoffset(c58);
  float4 LIGHT_POS_MS : packoffset(c59);
  float4 LIGHT_POS_MS_0 : packoffset(c60);
  float4 LIGHT_POS_MS_1 : packoffset(c61);
  float4 LIGHT_POS_MS_2 : packoffset(c62);
  float4x4 LIGHT_XFORM_MS : packoffset(c63);
  float4x4 LIGHT_XFORM_MS_0 : packoffset(c67);
  float4x4 LIGHT_XFORM_MS_1 : packoffset(c71);
  float4x4 LIGHT_XFORM_MS_2 : packoffset(c75);
  float4x4 LIGHT_XFORM_BIAS_MS : packoffset(c79);
  float4x4 LIGHT_XFORM_BIAS_MS_0 : packoffset(c83);
  float4x4 LIGHT_XFORM_BIAS_MS_1 : packoffset(c87);
  float4x4 LIGHT_XFORM_BIAS_MS_2 : packoffset(c91);
  float3 LIGHT_DIR_WS : packoffset(c95);
  float3 LIGHT_DIR_WS_0 : packoffset(c96);
  float4 LIGHT_POS_WS : packoffset(c97);
  float4 LIGHT_POS_WS_0 : packoffset(c98);
  float4 LIGHT_POS_WS_1 : packoffset(c99);
  float4 LIGHT_POS_WS_2 : packoffset(c100);
  float4x4 LIGHT_XFORM_WS : packoffset(c101);
  float4x4 LIGHT_XFORM_WS_0 : packoffset(c105);
  float4x4 LIGHT_XFORM_WS_1 : packoffset(c109);
  float4x4 LIGHT_XFORM_WS_2 : packoffset(c113);
  float4x4 LIGHT_XFORM_BIAS_WS : packoffset(c117);
  float4x4 LIGHT_XFORM_BIAS_WS_0 : packoffset(c121);
  float4x4 LIGHT_XFORM_BIAS_WS_1 : packoffset(c125);
  float4x4 LIGHT_XFORM_BIAS_WS_2 : packoffset(c129);
  float3 LIGHT_COLOR : packoffset(c133);
  float3 LIGHT_COLOR_0 : packoffset(c134);
  float3 LIGHT_COLOR_1 : packoffset(c135);
  float3 LIGHT_COLOR_2 : packoffset(c136);
  float4 CAMERA_POS_MS : packoffset(c137);
  float4 CAMERA_POS_WS : packoffset(c138);
  float4 ENV_SH[9] : packoffset(c139);
  float4 SCATTERING[4] : packoffset(c148);
  float4 CONST_0 : packoffset(c152);
  float4 CONST_1 : packoffset(c153);
  float4 CONST_2 : packoffset(c154);
  float4 CONST_3 : packoffset(c155);
  float4 CONST_4 : packoffset(c156);
  float4 CONST_5 : packoffset(c157);
  float4 CONST_6 : packoffset(c158);
  float4 CONST_7 : packoffset(c159);
  float4 CONST_8 : packoffset(c160);
  float4 CONST_9 : packoffset(c161);
  float4 CONST_10 : packoffset(c162);
  float4 CONST_11 : packoffset(c163);
  float4 CONST_12 : packoffset(c164);
  float4 CONST_13 : packoffset(c165);
  float4 CONST_14 : packoffset(c166);
  float4 CONST_15 : packoffset(c167);
  float4 CONST_16 : packoffset(c168);
  float4 CONST_17 : packoffset(c169);
  float4 CONST_18[4] : packoffset(c170);
  float4 CONST_22 : packoffset(c174);
  float4 CONST_23 : packoffset(c175);
  float4 CONST_24[4] : packoffset(c176);
  float4 CONST_28[4] : packoffset(c180);
  float4 CONST_32[4] : packoffset(c184);
  float4 CONST_36[4] : packoffset(c188);
  float4 CONST_40 : packoffset(c192);
  float4 CONST_41 : packoffset(c193);
  float4 CONST_42 : packoffset(c194);
  float4 CONST_43 : packoffset(c195);
  float4 CONST_90 : packoffset(c196);
  float4 TEX_INV_SIZE_NRM_sColor0 : packoffset(c197);
  float4 TEX_SIZE_NRM_sHeight0 : packoffset(c198);
  float4 TEX_SIZE_NRM_sHeight1 : packoffset(c199);
  float4 TEX_SIZE_NRM_sHeight2 : packoffset(c200);
  float4 TEX_SIZE_NRM_sHeight3 : packoffset(c201);
  float2 TEX_SIZE_sShadowMap0 : packoffset(c202);
  float2 TEX_SIZE_sShadowMap1 : packoffset(c202.z);
  float2 TEX_SIZE_sShadowMap2 : packoffset(c203);
  float2 TEX_INV_SIZE_sShadowMap0 : packoffset(c203.z);
  float2 TEX_INV_SIZE_sShadowMap1 : packoffset(c204);
  float2 TEX_INV_SIZE_sShadowMap2 : packoffset(c204.z);
  float4 aNGQuad0 : packoffset(c205);
  float4 aNGQuad1 : packoffset(c206);
  float4 aNGQuad2 : packoffset(c207);
  float4 aNGQuad3 : packoffset(c208);
  float4 vNGRange : packoffset(c209);
  float4 grass_wind_force_params : packoffset(c210);
  float4 grass_wave : packoffset(c211);
  float4 grass_wind_force : packoffset(c212);
  float4 grass_params : packoffset(c213);
  float4 ngPlayerPos : packoffset(c214);
  float4 quad[4] : packoffset(c215);
  float water_level : packoffset(c219);
  float terrain_inv_x : packoffset(c219.y);
  float terrain_inv_y : packoffset(c219.z);
  float terrain_inv_z : packoffset(c219.w);
  float fShadowmap0Bias : packoffset(c220);
  float fShadowmap1Bias : packoffset(c220.y);
  float fShadowmap2Bias : packoffset(c220.z);
  float fHDRSunIntensity : packoffset(c220.w);
  float fhdrambientintensity : packoffset(c221);
  float fHDRLightsIntensity : packoffset(c221.y);
  float fHDRSkyIntensity : packoffset(c221.z);
  float fHDRSelfIlluminationIntensity : packoffset(c221.w);
  float4 vGlowParams : packoffset(c222);
  float4 vColorParams : packoffset(c223);
  float fBulletTime : packoffset(c224);
  float fPlayerDamage : packoffset(c224.y);
  int iUseWaterReflection : packoffset(c224.z);
  int iUseWaterBorder : packoffset(c224.w);
  int iUseWaterSpecular : packoffset(c225);
  int iUseWaterFresnel : packoffset(c225.y);
  int iUseWaterWavesNumber : packoffset(c225.z);
  float fGrassSizeFactor : packoffset(c225.w);
  float4 vAmbient : packoffset(c226);
  float4 vTerrainDetail0 : packoffset(c227);
  float4 vTerrainDetail1 : packoffset(c228);
  float4 vTerrainCliff : packoffset(c229);
  float4 vWaterColor : packoffset(c230);
  float fWaterBaseOpacity : packoffset(c231);
  float fWaterReflDeformPower : packoffset(c231.y);
  float fWaterPlantsDeformPower : packoffset(c231.z);
  float fWaterDepth : packoffset(c231.w);
  float fWindPower : packoffset(c232);
  float fFakeBumpPower : packoffset(c232.y);
  float fRefractionPower : packoffset(c232.z);
  float fDiffuseGlow : packoffset(c232.w);
  float fGrassColormapScaleX : packoffset(c233);
  float fGrassColormapScaleY : packoffset(c233.y);
  float fGrassColormapOffsetX : packoffset(c233.z);
  float fGrassColormapOffsetY : packoffset(c233.w);
  float3 vWindCurrentForce : packoffset(c234);
  float3 vWindInitialDir : packoffset(c235);
  float fUndergrowthHeight : packoffset(c235.w);
  float fTopDetailSize : packoffset(c236);
  float fSideDetailSize : packoffset(c236.y);
  float fDetailsBorder : packoffset(c236.z);
  float fUndergrowthScale : packoffset(c236.w);
  float fWaterWave1ScaleX : packoffset(c237);
  float fWaterWave1ScaleY : packoffset(c237.y);
  float fWaterWave2ScaleX : packoffset(c237.z);
  float fWaterWave2ScaleY : packoffset(c237.w);
  float fWaterWave1SpeedX : packoffset(c238);
  float fWaterWave1SpeedY : packoffset(c238.y);
  float fWaterWave2SpeedX : packoffset(c238.z);
  float fWaterWave2SpeedY : packoffset(c238.w);
  float fSkyScale : packoffset(c239);
  float fSkyScaleHDR : packoffset(c239.y);
  float fSkyCloudsL0Scale : packoffset(c239.z);
  float fSkyCloudsL0Speed : packoffset(c239.w);
  float fSkyCloudsL1Scale : packoffset(c240);
  float fSkyCloudsL1Speed : packoffset(c240.y);
  float fSkyCloudsL2Scale : packoffset(c240.z);
  float fSkyCloudsL2Speed : packoffset(c240.w);
  float fSkyHorizonScaleH : packoffset(c241);
  float fSkyHorizonScaleV : packoffset(c241.y);
  float fSkyBackgroundScale : packoffset(c241.z);
  float4 vHorizonColor : packoffset(c242);
  float3 vSunDir : packoffset(c243);
  float4 vSunColor : packoffset(c244);
}

SamplerState samColor0_s : register(s0);
Texture2D<float4> sColor0 : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  linear centroid float4 v1 : TEXCOORD0,
  linear centroid float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
    float4 r0, r1, r2, r3;
    // Calculate view direction and normalize
    r0.xyz = CAMERA_POS_WS.xyz - v2.xyz;
    float distSq = dot(r0.xyz, r0.xyz);
    float invDist = rsqrt(distSq);
    float3 viewDir = r0.xyz * invDist;
    // Scattering calculations
    // Assembly Instruction 4-5: Dot product with Sun Direction
    float cosTheta = dot(-viewDir, vSunDir.xyz);
    float sunMask = dot(viewDir, vSunDir.xyz);
    // Assembly Instruction 6-10: Phase function / Scattering curve
    r0.y = SCATTERING[1].y * saturate(cosTheta) + SCATTERING[1].x;
    r0.z = saturate(cosTheta) * saturate(cosTheta) + 1.0;
    r0.y = max(0.0001, r0.y);
    float invScatY = 1.0 / r0.y;
    // Assembly Instruction 11-13: Finalize scattering color
    r1.xyz = SCATTERING[3].xyz * invScatY;
    r1.xyz = r1.xyz * rsqrt(r0.y);
    float3 scatteringColor = SCATTERING[2].xyz * r0.z + r1.xyz;
    // Assembly Instruction 14-18: Exponential fog / Extinction
    float fogFactor = saturate(v1.y * 0.5 + 0.5);
    fogFactor = v2.w * fogFactor;
    fogFactor = SCATTERING[1].z * -fogFactor;
    float3 extinction = exp2(SCATTERING[0].xyz * fogFactor);
    // Apply extinction to scattering
    float3 invExtinction = float3(1.0, 1.0, 1.0) - extinction;
    scatteringColor *= invExtinction;
    // Assembly Instruction 21-25: Texture and Sun/Ambient blending
    float lerpFactor = saturate(sunMask * 0.5 + 0.5);
    float3 sunColorScaled = vSunColor.xyz * fHDRSunIntensity;
    float3 blendedLight = lerp(vAmbient.xyz, sunColorScaled, lerpFactor);
    // Sample the sky texture
    r3 = sColor0.Sample(samColor0_s, v1.xy);
    float3 finalTex = r3.xyz * blendedLight;
    finalTex = FakeHDRGain::Apply(finalTex, pow(CUSTOM_SKY_SKYBOX_GLOW, 2), CUSTOM_SKY_LUMINARIES_GLOW_CONTRAST, CUSTOM_SKY_SKYBOX_GLOW_SATURATION); // Sky intensity
    // Alpha test / Discard logic (Instructions 26-29)
    // The assembly uses an unsigned comparison hack for alpha testing
    clip(r3.w - 0.5);

    // Final color composition
    o0.xyz = finalTex * extinction + scatteringColor;
    o0.w = 500000.0; 
}