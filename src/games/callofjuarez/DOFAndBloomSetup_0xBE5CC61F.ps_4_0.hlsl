#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sat Jan 24 00:40:21 2026

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
  float4 CONST_253 : packoffset(c245);
  float4 CONST_254 : packoffset(c246);
}

SamplerState samColor0_s : register(s0);
SamplerState samColor1_s : register(s1);
SamplerState samDepth_s : register(s2);
Texture2D<float4> sColor0 : register(t0);
Texture2D<float4> sColor1 : register(t1);
Texture2D<float4> sDepth : register(t2);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);

//
// Game's depth buffer is already linearized
//
// float LinearizeDepth(float depth)
// {
//   depth = min(0.99, depth);
//   //depth = 1 - depth;
//   const float N = 0.001;
//   const float fFarPlane = 1000;
//   depth = (2.0 * N * fFarPlane) / (fFarPlane + N - depth * (fFarPlane - N) + 0.00001);
//   return depth;
// }

float NormalizeDepth(float depth)
{
  const float fFarPlane = 1000;
  depth = depth / fFarPlane;
  return depth;
}

void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sColor0.Sample(samColor0_s, v1.xy).xyzw;
  r0.w = dot(float3(0.333299994,0.333299994,0.333299994), r0.xyz);
  r1.x = saturate(r0.w * vColorParams.y + -vColorParams.x);
  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    r1.xyz = saturate(r0.www * r1.xxx + r0.xyz);
  } else {
    r1.xyz = saturate(r0.www * r1.xxx) + r0.xyz;
  }
  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = fBulletTime + vColorParams.w;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  // Custom Ambient Occlusion
  float aoFactor = 1.0;
  if (CUSTOM_AO_ENABLE > 0.f) {
    uint tw, th;
    sDepth.GetDimensions(tw, th);
    float2 tex = float2(1.0 / tw, 1.0 / th);

    float rawDepthC = sDepth.Sample(samDepth_s, v1.xy).w;
    float normDepthC = rawDepthC / 1000.0;
    float2 slope = float2(ddx(normDepthC), ddy(normDepthC));

    // 1. THE NOISE (State-of-the-Art Bayer Jitter)
    // We use a 4x4 Bayer matrix to jitter the radius.
    // This "scatters" the samples per pixel, creating a perceived blur.
    float bayer[16] = { 0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5 };
    uint2 pixelPos = uint2(v1.xy * float2(tw, th));
    float bayerValue = bayer[(pixelPos.x % 4) * 4 + (pixelPos.y % 4)] / 16.0;

    // We also keep IGN for the rotation
    float noise = frac(52.9829189 * frac(dot(v1.xy * float2(tw, th), float2(0.06711056, 0.00583715))));

    float distanceBlend = smoothstep(0.5, 4.0, rawDepthC);

    // 2. JITTERED RADIUS (This is the "Blur")
    // By multiplying the radius by the bayer value, neighboring pixels
    // look at different distances, which "smears" the shadow edge.
    float radiusNear = 24.0 * CUSTOM_AO_RADIUS_NEAR;
    float radiusFar = 30.0 * CUSTOM_AO_RADIUS_FAR;
    float baseRadius = lerp(radiusNear, radiusFar, distanceBlend);

    // The Scatter: Mix the base radius with a jittered version
    float finalRadius = baseRadius * (0.7 + bayerValue * 0.6);
    float2 uvRadius = finalRadius * tex;

    float occNear = 0.0;
    float occFar = 0.0;
    float2 spiral[12] = {
      float2(-0.32, 0.94), float2(-0.19, 0.24), float2(0.91, 0.35), float2(0.35, 0.02),
      float2(0.15, -0.49), float2(-0.52, -0.11), float2(-0.82, -0.54), float2(-0.13, -0.98),
      float2(0.39, -0.22), float2(0.12, 0.84), float2(-0.61, 0.19), float2(0.22, 0.33)
    };

    [unroll]
    for (int i = 0; i < 12; i++) {
      float angle = noise * 6.28;
      float s = sin(angle), c = cos(angle);
      float2 rotOffset = float2(
                             spiral[i].x * c - spiral[i].y * s,
                             spiral[i].x * s + spiral[i].y * c
        ) * uvRadius;

      float rawDepthS = sDepth.Sample(samDepth_s, v1.xy + rotOffset).w;
      float normDepthS = rawDepthS / 1000.0;

      // PATH A: NEAR FIELD (Guns)
      float diffNear = rawDepthC - rawDepthS;
      if (diffNear > CUSTOM_AO_BIAS_NEAR && diffNear < CUSTOM_AO_THICKNESS_NEAR) {
        occNear += 1.0;
      }

      // PATH B: FAR FIELD (World)
      float expectedNormS = normDepthC + dot(rotOffset * float2(tw, th), slope);
      float diffFar = expectedNormS - normDepthS;
      float farBias = (CUSTOM_AO_BIAS_FAR) + (normDepthC * 0.002);

      if (diffFar > farBias && diffFar < CUSTOM_AO_THICKNESS_FAR) {
        occFar += 1.0;
      }
    }

    float hits = lerp(occNear, occFar, distanceBlend);
    float shadowIntensity = hits / 12.0;

    // 3. THE "INK STIPPLE" (The final look)
    // To make it look "blurred" but "inked," we dither the threshold.
    float inkDensity = 1.0 * CUSTOM_AO_INTENSITY;
    float ditheredShadow = (shadowIntensity * inkDensity) - (bayerValue * 0.5);

    // We use a slightly softer step for the "strong blur" feel
    aoFactor = 1.0 - smoothstep(0.0, 0.2, ditheredShadow);
  }

  r1.xyzw = sColor1.Sample(samColor1_s, v1.xy).xyzw;  // Bloom
  if (CUSTOM_BLOOM_IMPROVED > 0.f) {
    uint tex_width, tex_height;
    sColor1.GetDimensions(tex_width, tex_height);
    float2 texelSize = float2(1.0 / tex_width, 1.0 / tex_height);
    
    float spread = 10.0 * CUSTOM_BLOOM_RADIUS;
    float3 combinedBloom = 0;
    float totalWeight = 0;

    static const float smallKernel[5] =
        {
          0.0613595978134402f,
          0.24477019552960988f,
          0.38774041331389975f,
          0.24477019552960988f,
          0.0613595978134402f
        };

    [unroll]
    for (int i = 0; i < 32; i++) {
        float r = sqrt(float(i) + 0.5) / sqrt(32.0);
        float theta = float(i) * 2.3999632;     
        float2 spiralOffset = float2(cos(theta), sin(theta)) * r * spread * texelSize;
        float w = exp(-(r * r) * 2.0); 
        float sampleLod = min(1.0, r * 4.0); 
        float3 tapBlur = 0;
        [unroll]
        for(int k = 0; k < 4; k++) {
            float2 subOffset = smallKernel[k] * texelSize; 
            tapBlur += sColor1.SampleLevel(samColor1_s, v1.xy + spiralOffset + subOffset, sampleLod).xyz;
        }
        combinedBloom += (tapBlur * 0.2) * w;
        totalWeight += w;
    }

    r1.xyz = combinedBloom / totalWeight;
    //r1.xyz = r1.xyz / (1.0 + max(r1.x, max(r1.y, r1.z)));
    r1.xyz *= CUSTOM_BLOOM_AMOUNT;
  }
  
  // Bloom contrast
  float midgray = 0.18 * RENODX_DIFFUSE_WHITE_NITS;
  r1.xyzw = midgray * pow(r1.xyzw / midgray, 1.0 + CUSTOM_BLOOM_THRESHOLD * 0.1);

  if (RENODX_TONE_MAP_TYPE <= 0.f || CUSTOM_BLOOM_IMPROVED <= 0.f) {
    r1.xyz = r1.xyz * CUSTOM_BLOOM_AMOUNT;
  }

  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    r1.xyz = saturate(r1.xyz);
  }

  if (CUSTOM_AO_ENABLE > 0.f) {
    r0.xyz *= aoFactor;  // Apply AO to output
  }
  o0.xyz = r1.xyz + r0.xyz;                                            // Vanilla additive bloom
  // o0.xyz = lerp(r0.xyz, r1.xyz, log10(CUSTOM_BLOOM_AMOUNT + 1.0f));  // Modern bloom through lerp
  r0.xyzw = sDepth.Sample(samDepth_s, v1.xy).xyzw;
  r0.x = saturate(r0.w * CONST_254.x + CONST_254.y);
  r0.y = saturate(r0.w * CONST_253.x + CONST_253.y);
  r0.x = saturate(CONST_254.z * r0.x + CONST_254.w);
  r0.y = saturate(CONST_253.w * r0.y);
  r0.x = r0.y + -r0.x;
  o0.w = r0.x * 0.5 + 0.5;
  // Debug
  if (CUSTOM_AO_DEBUG == 1.f && CUSTOM_AO_ENABLE > 0.f) {
      // Debug AO
      o0.xyz = aoFactor.xxx;
    }
  if (CUSTOM_AO_DEBUG == 2.f) {
      // Debug depth
      o0.xyz = (sDepth.Sample(samDepth_s, v1.xy).w).xxx / 1000;
    }
  return;
}