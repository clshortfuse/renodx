#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 19 06:05:10 2026

cbuffer _Globals : register(b0)
{
  row_major float4x4 g_MtxProjection : packoffset(c16);
  row_major float4x4 g_MtxInvProjection : packoffset(c20);
  row_major float4x4 g_MtxView : packoffset(c89);
  row_major float4x4 g_MtxInvView : packoffset(c93);
  float4 g_Diffuse : packoffset(c24);
  float4 g_Ambient : packoffset(c25);
  float4 g_Specular : packoffset(c26);
  float4 g_Emission : packoffset(c27);
  float4 g_PowerGlossLevel : packoffset(c28);
  float4 g_OpacityReflectionRefractionSpectype : packoffset(c29);
  float4 g_EyePosition : packoffset(c30);
  float4 g_EyeDirection : packoffset(c31);
  float4 g_ViewportSize : packoffset(c32);
  float3 g_CameraNearFarAspect : packoffset(c33);
  float4 mrgTexcoordIndex[4] : packoffset(c34);
  float4 mrgAmbientColor : packoffset(c38);
  float4 mrgGroundColor : packoffset(c39);
  float4 mrgSkyColor : packoffset(c40);
  float4 mrgPowerGlossLevel : packoffset(c41);
  float4 mrgEmissionPower : packoffset(c42);
  float4 mrgGlobalLight_Direction : packoffset(c43);
  float4 mrgGlobalLight_Direction_View : packoffset(c44);
  float4 mrgGlobalLight_Diffuse : packoffset(c45);
  float4 mrgGlobalLight_Specular : packoffset(c46);
  float4 mrgEyeLight_Diffuse : packoffset(c55);
  float4 mrgEyeLight_Specular : packoffset(c56);
  float4 mrgEyeLight_Range : packoffset(c57);
  float4 mrgEyeLight_Attribute : packoffset(c58);
  float2 mrgFresnelParam : packoffset(c59);
  float4 mrgLuminanceRange : packoffset(c60);
  float4 mrgInShadowScale : packoffset(c61);
  float4 g_ShadowMapParams : packoffset(c62);
  float4 mrgVsmEpsilon : packoffset(c87);
  float g_BackGroundScale : packoffset(c64);
  float4 g_TimeParam : packoffset(c65);
  float4 g_GIModeParam : packoffset(c66);
  float4 g_GI0Scale : packoffset(c67);
  float4 g_GI1Scale : packoffset(c68);
  float4 g_LightScattering_Ray_Mie_Ray2_Mie2 : packoffset(c69);
  float4 g_LightScattering_ConstG_FogDensity : packoffset(c70);
  float4 g_LightScatteringFarNearScale : packoffset(c71);
  float4 g_LightScatteringColor : packoffset(c72);
  float g_LightScatteringMode : packoffset(c73);
  float4 g_aLightField[6] : packoffset(c74);
  float4 g_MotionBlur_AlphaRef_VelocityLimit_VelocityCutoff_BlurMagnitude : packoffset(c82);
  float4 mrgPlayableParam : packoffset(c83);
  float4 mrgDebugDistortionParam : packoffset(c84);
  float4 mrgEdgeEmissionParam : packoffset(c85);
  float4 g_DebugValue : packoffset(c88);
  row_major float4x4 g_MtxLightViewProjection : packoffset(c97);
  row_major float4x4 g_MtxVerticalLightViewProjection : packoffset(c101);
  float4 g_ForceAlphaColor : packoffset(c86);
  float4 g_smallBlurOffsets[2] : packoffset(c105);
  float4 g_dofLerpScaleBias[2] : packoffset(c121);
  float4 g_Param2 : packoffset(c123);
  float4 g_Param3 : packoffset(c124);
  float4 g_MiddleGray_Scale_LuminanceLow_LuminanceHigh : packoffset(c125);
  float4 g_DepthOfFieldFocusNearFarRange : packoffset(c126);
  float4 g_glow_strength : packoffset(c127);
}

SamplerState g_Source_sampler_s : register(s0);
SamplerState g_SourceLow_sampler_s : register(s1);
SamplerState s2_sampler_s : register(s2);
SamplerState s3_sampler_s : register(s3);
Texture2D<float4> g_Source_NedSmpignorenametexture : register(t0);
Texture2D<float4> g_SourceLow_NedSmpignorenametexture : register(t1);
Texture2D<float4> s2_NedSmpignorenametexture : register(t2);
Texture2D<float4> s3_NedSmpignorenametexture : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_Param2.xy + -v1.xy;
  r0.z = r0.y / g_CameraNearFarAspect.z;
  r0.y = dot(r0.xz, r0.xz);
  r0.w = rsqrt(r0.y);
  r0.y = sqrt(r0.y);
  r0.y = -g_Param2.w + r0.y;
  r0.y = r0.y / g_Param3.x;
  r0.y = max(-1, r0.y);
  r0.y = min(1, r0.y);
  r0.y = 1.57079637 * r0.y;
  r0.y = cos(r0.y);
  r0.xz = r0.xz * r0.ww;
  r0.xz = r0.xz * r0.yy;
  r0.y = r0.y * g_Param3.w + 1;
  r0.xz = r0.xz * g_Param3.yy + v1.xy;
  r1.xyzw = g_SourceLow_NedSmpignorenametexture.Sample(g_SourceLow_sampler_s, r0.xz).xyzw;
  r0.xzw = g_Source_NedSmpignorenametexture.Sample(g_Source_sampler_s, r0.xz).xyz;
  r2.x = -0.996078432 + r1.w;
  r2.x = -r2.x * 255 + 1;
  r2.y = cmp(0.996078432 < r1.w);
  r1.w = r2.y ? r2.x : r1.w;
  r1.xyz = r1.xyz + -r0.xzw;
  r1.w = g_Param3.z * r1.w;
  r0.xzw = r1.www * r1.xyz + r0.xzw;
  // RenoDX: Motion Blur Off skips the blur lerp; Improved blurs the full-res source along the velocity map (t2).
  if (shader_injection.sg_motion_blur != 0.f) {
    if (shader_injection.sg_motion_blur >= 1.5f) {
      r1 = SGFullResMotionBlur(g_Source_NedSmpignorenametexture, g_Source_sampler_s, s2_NedSmpignorenametexture, s2_sampler_s, v1.xy, v0.xy);
    } else {
      r1.xyzw = s2_NedSmpignorenametexture.Sample(s2_sampler_s, v1.xy).xyzw;
    }
    r1.xyz = r1.xyz + -r0.xzw;
    r0.xzw = r1.www * r1.xyz + r0.xzw;
  }
  // RenoDX: vanilla bloom target was RGBA8 (clamped at 1). sg_bloom_hdr lerps to the unclamped value; strength and enable scale the glow.
  float3 bloom_raw = s3_NedSmpignorenametexture.Sample(s3_sampler_s, v1.xy).xyz;
  r1.xyz = lerp(saturate(bloom_raw), max(bloom_raw, 0.f), shader_injection.sg_bloom_hdr) * (g_glow_strength.y * shader_injection.sg_bloom_strength * shader_injection.sg_bloom_enabled);
  // RenoDX: equals vanilla wherever vanilla's sum stayed below 1. Above that, keeps the HDR excess instead of clipping,
  // without amplifying bloom on HDR highlights. Bloom is added in linear on the clipped base.
  float3 base = r0.xzw * r0.yyy;
  float3 clipped = min(base, 1.f);
  float3 bloom_linear = renodx::color::srgb::DecodeSafe(clipped + r1.xyz) - renodx::color::srgb::DecodeSafe(clipped);
  o0.xyz = renodx::color::srgb::EncodeSafe(renodx::color::srgb::DecodeSafe(base) + bloom_linear);
  // o0.xyz = r0.xzw * r0.yyy + r1.xyz;
  o0.w = 1;
  return;
}