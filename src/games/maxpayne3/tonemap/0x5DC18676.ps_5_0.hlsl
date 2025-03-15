// ---- Created with 3Dmigoto v1.4.1 on Fri Mar 14 15:41:18 2025
#include "../common.hlsl"

cbuffer _Globals : register(b1)
{
  float4 TexelSize : packoffset(c98);
  float4 TransColor : packoffset(c130);
  float4 TransPos : packoffset(c131);
  float4 TransTex0 : packoffset(c132);
  float4 TransTex1 : packoffset(c133);
  float4 TransTex2 : packoffset(c134);
  float2 BrightnessSetting : packoffset(c135);
  float4 dofProj : packoffset(c136);
  float4 dofDist : packoffset(c137);
  float dofInten : packoffset(c138);
  float4 dofBlur : packoffset(c139);
  float dofNoBlurRadius : packoffset(c140);
  float dofNoBlurBlendRingSize : packoffset(c141);
  float2 Exposures : packoffset(c142);
  float4 SharpenFilterParams : packoffset(c143);
  float4 ToneMapParams : packoffset(c144);
  float AdaptedLumMin : packoffset(c145);
  float AdaptedLumMax : packoffset(c146);
  float BurnoutLimit : packoffset(c147);
  float4 NoiseParams : packoffset(c148);
  float4 NoiseFilterArea : packoffset(c149);
  float4 KillFlashUVOff : packoffset(c150);
  float4 KillFlashCol : packoffset(c151);
  float4 InterlaceMask : packoffset(c152);
  float4 ImageFXParams : packoffset(c153);
  float ZoomBlurMaskSize : packoffset(c154);
  float ChromaticEntire : packoffset(c155);
  float DirectionalMotionBlurLength : packoffset(c156);
  row_major float4x4 motionBlurMatrix : packoffset(c157);
  float MaskTex : packoffset(c161);
  float4 MP_BulletTimeParams : packoffset(c162);
  float4 TearGasParams : packoffset(c163);
  float ElapsedTime : packoffset(c164);
  float AdaptTime : packoffset(c165);
  float lowLum : packoffset(c166);
  float highLum : packoffset(c167);
  float topLum : packoffset(c168);
  float scalerLum : packoffset(c169);
  float offsetLum : packoffset(c170);
  float offsetLowLum : packoffset(c171);
  float offsetHighLum : packoffset(c172);
  float noiseLum : packoffset(c173);
  float noiseLowLum : packoffset(c174);
  float noiseHighLum : packoffset(c175);
  float bloomLum : packoffset(c176);
  float4 colorLum : packoffset(c177);
  float4 colorLowLum : packoffset(c178);
  float4 colorHighLum : packoffset(c179);
  float3 scanlineParameters : packoffset(c180);
  float2 highlightParameters : packoffset(c181);
  float4 HeatHazeParams : packoffset(c182);
  float4 HeatHazeTex1Params : packoffset(c183);
  float4 HeatHazeTex2Params : packoffset(c184);
  float4 HeatHazeOffsetParams : packoffset(c185);
  float PlayerBrightness : packoffset(c186);
  float PedBrightness : packoffset(c187);
  float ColorShiftScalar : packoffset(c188);
  float4 ColorFringeParams1 : packoffset(c189);
  float4 ColorFringeParams2 : packoffset(c190);
  float4 lightrayParams : packoffset(c191);
  float4 SunRaysParams : packoffset(c192);
  float AdrenoEffectStrength : packoffset(c193);
  float ZoomFocusDistance : packoffset(c194);
  float ZoomFocusWidth : packoffset(c195);
  float TotalElapsedTime : packoffset(c196);
  float4 DruggedEffectColorShift : packoffset(c197);
  float4 DruggedEffectParams : packoffset(c198);
  float radialBlurScale : packoffset(c199);
  float3 radialBlurCenter : packoffset(c200);
  float radialBlurSampleScale : packoffset(c201);
  float2 radialBlurTextureStep : packoffset(c202);
  float blurIntensity : packoffset(c203);
  float deathIntensity : packoffset(c204);
  float3 g_BloodColor : packoffset(c205);
  float4 g_BloodSplatParams : packoffset(c206);
}

cbuffer rage_globals : register(b5)
{
  float4 globalScalars : packoffset(c0);
  float4 globalScalars2 : packoffset(c1);
  float4 globalScalars3 : packoffset(c2);
  float4 globalScalars4 : packoffset(c3);
  float4 globalFogParams : packoffset(c4);
  float4 globalFogColor : packoffset(c5);
  float4 globalFogOffsetN : packoffset(c6);
  float4 globalFogColorN : packoffset(c7);
  float4 globalScreenSize : packoffset(c8);
  float4 globalDayNightEffects : packoffset(c9);
  float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
  float4 ColorCorrectBottomOffset : packoffset(c11);
  float4 ColorShift : packoffset(c12);
  float4 deSatContrastGamma : packoffset(c13);
  float4 deSatContrastGammaIFX : packoffset(c14);
  float4 colorize : packoffset(c15);
  float4 globalUmScalars : packoffset(c16);
  float4 gToneMapScalers : packoffset(c17);
  float4 gAmbientOcclusionEffect : packoffset(c18);
  float4 gWaterGlobals : packoffset(c19);
  float4 ColorCorrectTopScreenEdge : packoffset(c20);
  float4 ColorCorrectBottomOffsetScreenEdge : packoffset(c21);
  float4 gScreenSpaceTessFactors : packoffset(c22);
  float4 gTessFactors : packoffset(c23);
  float4 gFrustumPlaneEquation_Left : packoffset(c24);
  float4 gFrustumPlaneEquation_Right : packoffset(c25);
  float4 gFrustumPlaneEquation_Top : packoffset(c26);
  float4 gFrustumPlaneEquation_Bottom : packoffset(c27);
  float4 gTessParameters : packoffset(c28);
}

SamplerState AdapLumSampler_s : register(s1);
SamplerState BlurSampler_s : register(s7);
SamplerState BloomSampler_s : register(s10);
SamplerState HeatHazeSampler_s : register(s12);
SamplerState RadialBlurSampler_s : register(s14);
SamplerState DeathSampler_s : register(s15);
Texture2D<float4> AdapLumSampler : register(t1);
Texture2DMS<float> gbufferTextureDepth : register(t3);
Texture2DMS<float4> PostFxTexture0a : register(t6);
Texture2D<float4> BlurSampler : register(t7);
Texture2D<float4> BloomSampler : register(t10);
Texture2D<float4> HeatHazeSampler : register(t12);
Texture2D<float4> RadialBlurSampler : register(t14);
Texture2D<float4> DeathSampler : register(t15);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  gbufferTextureDepth.GetDimensions(fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.xy = v1.xy * r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = gbufferTextureDepth.Load(r0.xy, 0).x;
  r0.y = dofProj.y + -dofProj.x;
  r0.y = dofProj.y / r0.y;
  r0.z = -dofProj.x * r0.y;
  r0.x = r0.x + -r0.y;
  r0.x = r0.z / r0.x;
  r0.y = ZoomFocusDistance + -r0.x;
  r0.y = saturate(0.200000003 * r0.y);
  r0.z = dofDist.y + -r0.x;
  r0.w = -dofDist.z + r0.x;
  r0.zw = saturate(r0.zw / dofDist.xw);
  r0.z = max(r0.z, r0.w);
  r0.z = dofInten * r0.z;
  r0.y = max(r0.y, r0.z);
  r0.z = -HeatHazeParams.x + r0.x;
  r0.z = max(0, r0.z);
  r0.z = saturate(r0.z / HeatHazeParams.y);
  r0.w = HeatHazeParams.w + -HeatHazeParams.z;
  r0.z = r0.z * r0.w + HeatHazeParams.z;
  r0.x = -dofProj.y * 0.5 + r0.x;
  r0.x = max(0, r0.x);
  r0.x = saturate(r0.x / dofProj.y);
  r0.x = 1 + -r0.x;
  r0.x = r0.z * r0.x;
  r0.zw = v1.xy * HeatHazeTex1Params.xy + HeatHazeTex1Params.zw;
  r1.xy = v1.xy * HeatHazeTex2Params.xy + HeatHazeTex2Params.zw;
  r0.zw = HeatHazeSampler.Sample(HeatHazeSampler_s, r0.zw).xy;
  r1.xy = HeatHazeSampler.Sample(HeatHazeSampler_s, r1.xy).xy;
  r0.zw = r1.xy + r0.zw;
  r0.zw = float2(-1,-1) + r0.zw;
  r0.zw = HeatHazeOffsetParams.xy * r0.zw;
  r0.xz = r0.zw * r0.xx + v1.xy;
  PostFxTexture0a.GetDimensions(fDest.x, fDest.y, fDest.z);
  r1.xy = fDest.xy;
  r0.xw = r1.xy * r0.xz;
  r1.xy = (int2)r0.xw;
  r1.zw = float2(0,0);
  r2.xyz = PostFxTexture0a.Load(r1.xy, 0).xyz;
  r3.xyz = PostFxTexture0a.Load(r1.xy, 1).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = PostFxTexture0a.Load(r1.xy, 2).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = PostFxTexture0a.Load(r1.xy, 3).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = PostFxTexture0a.Load(r1.xy, 4).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = PostFxTexture0a.Load(r1.xy, 5).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = PostFxTexture0a.Load(r1.xy, 6).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = PostFxTexture0a.Load(r1.xy, 7).xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = float3(0.125,0.125,0.125) * r1.xyz;
  r0.x = cmp(radialBlurScale != 1.000000);
  if (r0.x != 0) {
    r0.xw = radialBlurTextureStep.xy + v1.xy;
    r2.xyz = RadialBlurSampler.Sample(RadialBlurSampler_s, r0.xw).xyz;
    r1.xyz = r1.xyz * radialBlurScale + r2.xyz;
  }
  r0.x = cmp(0 != blurIntensity);
  if (r0.x != 0) {
    r2.xyz = BlurSampler.Sample(BlurSampler_s, v1.xy).xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = blurIntensity * r2.xyz + r1.xyz;
  }
  r0.xw = DeathSampler.Sample(DeathSampler_s, w1.xy).xz;
  r2.xyz = BlurSampler.Sample(BlurSampler_s, v1.xy).xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r0.yyy * r2.xyz + r1.xyz;
  r0.y = AdapLumSampler.Sample(AdapLumSampler_s, float2(0,0)).x;
  r0.y = 9.99999997e-07 + r0.y;
  r0.y = ToneMapParams.y / r0.y;
  r2.xyz = BloomSampler.Sample(BloomSampler_s, v1.xy).xyz;
  r1.w = ToneMapParams.w + -ToneMapParams.z;
  r1.w = r0.x * r1.w + ToneMapParams.z;
  r2.xyz = r2.xyz * r1.www;
  r1.xyz = r2.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r2.xyz = r0.zzz * ColorCorrectBottomOffset.xyz + ColorCorrectTopAndPedReflectScale.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.z = Exposures.y + -Exposures.x;
  r0.x = r0.x * r0.z + Exposures.x;
  r1.xyz = r1.xyz * r0.xxx;
  r0.x = dot(r1.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.z = r0.x * r0.y;
  r1.w = BurnoutLimit * BurnoutLimit;
  r1.w = r0.z / r1.w;
  r1.w = 1 + r1.w;
  r0.z = r1.w * r0.z;
  r0.x = r0.x * r0.y + 1;
  r0.x = r0.z / r0.x;
  r0.xyz = r1.xyz * r0.xxx;
  r1.x = saturate(dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986)));
  r1.x = 1.00999996e-05 + r1.x;
  r1.y = deSatContrastGammaIFX.z + -deSatContrastGamma.z;
  r0.w = r0.w * r1.y + deSatContrastGamma.z;
  r0.w = -0.999989986 + r0.w;
  r1.x = log2(r1.x);
  r0.w = r1.x * r0.w;
  r0.w = exp2(r0.w);
  r0.w = min(65000, r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz * BrightnessSetting.xxx + BrightnessSetting.yyy;
  r1.xyz = saturate(r0.xyz);
  o0.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;


  o0.rgb = ApplyToneMapAndScale(o0.rgb, v1.xy);
  return;
}