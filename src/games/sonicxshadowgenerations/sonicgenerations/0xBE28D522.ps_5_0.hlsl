#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 19 05:03:48 2026

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
  float4 cY : packoffset(c105);
  float4 g_TextureWindowSize : packoffset(c106);
  float4 u_color_grading_factor : packoffset(c107);
}

SamplerState s0_sampler_s : register(s0);
SamplerState s_ColorGradingLUT_0_sampler_s : register(s1);
SamplerState s_ColorGradingLUT_1_sampler_s : register(s2);
Texture2D<float4> s0_NedSmpignorenametexture : register(t0);
Texture2D<float4> s_ColorGradingLUT_0_NedSmpignorenametexture : register(t1);
Texture2D<float4> s_ColorGradingLUT_1_NedSmpignorenametexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_ViewportSize.zwzw * float4(0,-1,-1,0) + v1.xyxy;
  // RenoDX: every FXAA input tap goes through FxaaCompress so FXAA works on an SDR-range signal.
  r1.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r0.xy, 0).xyz);
  r0.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r0.zw, 0).xyz);
  r2.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, v1.xy, 0).xyz);
  r3.xyzw = g_ViewportSize.zwzw * float4(1,0,0,1) + v1.xyxy;
  r4.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r3.xy, 0).xyz);
  r3.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r3.zw, 0).xyz);
  r0.w = r1.y * 1.9632107 + r1.x;
  r1.w = r0.y * 1.9632107 + r0.x;
  r2.w = r2.y * 1.9632107 + r2.x;
  r3.w = r4.y * 1.9632107 + r4.x;
  r4.w = r3.y * 1.9632107 + r3.x;
  r5.x = min(r1.w, r0.w);
  r5.y = min(r4.w, r3.w);
  r5.x = min(r5.x, r5.y);
  r5.x = min(r5.x, r2.w);
  r5.y = max(r1.w, r0.w);
  r5.z = max(r4.w, r3.w);
  r5.y = max(r5.y, r5.z);
  r5.y = max(r5.y, r2.w);
  r5.x = r5.y + -r5.x;
  r5.y = 0.125 * r5.y;
  r5.y = max(0.0416666679, r5.y);
  r5.y = cmp(r5.x >= r5.y);
  if (r5.y != 0) {
    r0.xyz = r1.xyz + r0.xyz;
    r0.xyz = r0.xyz + r2.xyz;
    r0.xyz = r0.xyz + r4.xyz;
    r0.xyz = r0.xyz + r3.xyz;
    r1.x = r1.w + r0.w;
    r1.x = r1.x + r3.w;
    r1.x = r1.x + r4.w;
    r1.x = r1.x * 0.25 + -r2.w;
    r1.x = abs(r1.x) / r5.x;
    r1.x = -0.25 + r1.x;
    r1.x = max(0, r1.x);
    r1.x = 1.33333337 * r1.x;
    r1.x = min(0.75, r1.x);
    r1.yz = -g_ViewportSize.zw + v1.xy;
    r3.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r1.yz, 0).xyz);
    r5.xyzw = g_ViewportSize.zwzw * float4(1,-1,-1,1) + v1.xyxy;
    r4.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r5.xy, 0).xyz);
    r5.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r5.zw, 0).xyz);
    r1.yz = g_ViewportSize.zw + v1.xy;
    r6.xyz = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r1.yz, 0).xyz);
    r7.xyz = r4.xyz + r3.xyz;
    r7.xyz = r7.xyz + r5.xyz;
    r7.xyz = r7.xyz + r6.xyz;
    r0.xyz = r7.xyz + r0.xyz;
    r0.xyz = r0.xyz * r1.xxx;
    r1.y = r3.y * 1.9632107 + r3.x;
    r1.z = r4.y * 1.9632107 + r4.x;
    r3.x = r5.y * 1.9632107 + r5.x;
    r3.y = r6.y * 1.9632107 + r6.x;
    r3.z = -0.5 * r0.w;
    r3.z = r1.y * 0.25 + r3.z;
    r3.z = r1.z * 0.25 + r3.z;
    r4.x = -0.5 * r1.w;
    r4.y = r1.w * 0.5 + -r2.w;
    r4.z = -0.5 * r3.w;
    r4.y = r3.w * 0.5 + r4.y;
    r3.z = abs(r4.y) + abs(r3.z);
    r4.y = -0.5 * r4.w;
    r4.y = r3.x * 0.25 + r4.y;
    r4.y = r3.y * 0.25 + r4.y;
    r3.z = abs(r4.y) + r3.z;
    r1.y = r1.y * 0.25 + r4.x;
    r1.y = r3.x * 0.25 + r1.y;
    r3.x = r0.w * 0.5 + -r2.w;
    r3.x = r4.w * 0.5 + r3.x;
    r1.y = abs(r3.x) + abs(r1.y);
    r1.z = r1.z * 0.25 + r4.z;
    r1.z = r3.y * 0.25 + r1.z;
    r1.y = r1.y + abs(r1.z);
    r1.y = cmp(r1.y >= r3.z);
    r1.z = r1.y ? -g_ViewportSize.w : -g_ViewportSize.z;
    r0.w = r1.y ? r0.w : r1.w;
    r1.w = r1.y ? r4.w : r3.w;
    r3.x = r0.w + -r2.w;
    r3.y = r1.w + -r2.w;
    r0.w = r0.w + r2.w;
    r0.w = 0.5 * r0.w;
    r1.w = r1.w + r2.w;
    r1.w = 0.5 * r1.w;
    r3.z = cmp(abs(r3.x) >= abs(r3.y));
    r0.w = r3.z ? r0.w : r1.w;
    r1.w = r3.z ? abs(r3.x) : abs(r3.y);
    r1.z = r3.z ? r1.z : -r1.z;
    r3.x = 0.5 * r1.z;
    r3.y = r1.y ? 0 : r3.x;
    r3.x = r1.y ? r3.x : 0;
    r4.xy = v1.xy + r3.yx;
    r1.w = 0.25 * r1.w;
    r3.yz = float2(0,0);
    r3.xw = g_ViewportSize.zw;
    r3.xy = r1.yy ? r3.xy : r3.zw;
    r3.zw = r4.xy + -r3.xy;
    r4.xy = r4.xy + r3.xy;
    r4.zw = r3.zw;
    r5.xy = r4.xy;
    r5.zw = r0.ww;
    r6.xyz = float3(0,0,0);
    while (true) {
      r6.w = cmp((int)r6.z >= 16);
      if (r6.w != 0) break;
      if (r6.x == 0) {
        r7.xy = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r4.zw, 0).xyz).xy;
        r6.w = r7.y * 1.9632107 + r7.x;
      } else {
        r6.w = r5.z;
      }
      if (r6.y == 0) {
        r7.xy = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r5.xy, 0).xyz).xy;
        r7.x = r7.y * 1.9632107 + r7.x;
      } else {
        r7.x = r5.w;
      }
      r7.y = r6.w + -r0.w;
      r7.y = cmp(abs(r7.y) >= r1.w);
      r6.x = (int)r6.x | (int)r7.y;
      r7.y = r7.x + -r0.w;
      r7.y = cmp(abs(r7.y) >= r1.w);
      r6.y = (int)r6.y | (int)r7.y;
      r7.y = (int)r6.y & (int)r6.x;
      if (r7.y != 0) {
        r5.z = r6.w;
        r5.w = r7.x;
        break;
      }
      r7.yz = r4.zw + -r3.xy;
      r4.zw = r6.xx ? r4.zw : r7.yz;
      r7.yz = r5.xy + r3.xy;
      r5.xy = r6.yy ? r5.xy : r7.yz;
      r6.z = (int)r6.z + 1;
      r5.z = r6.w;
      r5.w = r7.x;
    }
    r3.xy = v1.xy + -r4.zw;
    r1.w = r1.y ? r3.x : r3.y;
    r3.xy = -v1.xy + r5.xy;
    r3.x = r1.y ? r3.x : r3.y;
    r3.y = cmp(r1.w < r3.x);
    r3.z = r3.y ? r5.z : r5.w;
    r2.w = r2.w + -r0.w;
    r2.w = cmp(r2.w < 0);
    r0.w = r3.z + -r0.w;
    r0.w = cmp(r0.w < 0);
    r0.w = cmp((int)r0.w == (int)r2.w);
    r0.w = r0.w ? 0 : r1.z;
    r1.z = r3.x + r1.w;
    r1.w = r3.y ? r1.w : r3.x;
    r1.z = -1 / r1.z;
    r1.z = r1.w * r1.z + 0.5;
    r0.w = r1.z * r0.w;
    r1.z = r1.y ? 0 : r0.w;
    r3.x = v1.x + r1.z;
    r0.w = r1.y ? r0.w : 0;
    r3.y = v1.y + r0.w;
    r1.yzw = FxaaCompress(s0_NedSmpignorenametexture.SampleLevel(s0_sampler_s, r3.xy, 0).xyz);
    r0.xyz = r0.xyz * float3(0.111111112,0.111111112,0.111111112) + r1.yzw;
    r2.xyz = -r1.xxx * r1.yzw + r0.xyz;
  }
  // RenoDX: tonemap bridge replaces the vanilla LUT grade.
  float3 untonemapped = renodx::color::srgb::DecodeSafe(FxaaExpand(r2.xyz));  // RenoDX: FXAA HDR expand
  // Vanilla had no curve (linear until the RGBA8 clip): stay linear below 0.75, then roll off to 1.
  // The roll-off scales by the max channel so hue and chroma survive; per-channel roll-off washed bright colors to white.
  float max_channel = max(untonemapped.r, max(untonemapped.g, untonemapped.b));
  float3 neutral_sdr;
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    neutral_sdr = saturate(untonemapped);  // RenoDX: Vanilla RGBA8 clip
  } else {
    neutral_sdr = untonemapped * (max_channel > 0.f ? renodx::tonemap::ExponentialRollOff(max_channel, 0.75f) / max_channel : 0.f);
  }
  float3 neutral_encoded = renodx::color::srgb::EncodeSafe(neutral_sdr);

  // Vanilla LUT addressing, fed with the sRGB-encoded neutral SDR.
  float3 lut_input = saturate(neutral_encoded);
  float blue_slice = floor(lut_input.b * 14.9998999f);
  float blue_frac = saturate(lut_input.b * 15.f - blue_slice);
  float2 lut_uv = float2(blue_slice * 0.0625f + lut_input.r * 0.05859375f, lut_input.g * 0.9375f + 0.03125f);
  float2 lut_uv_a = lut_uv + float2(0.001953125f, 0.f);
  float2 lut_uv_b = lut_uv + float2(0.064453125f, 0.f);
  float3 lut0 = lerp(
      s_ColorGradingLUT_0_NedSmpignorenametexture.SampleLevel(s_ColorGradingLUT_0_sampler_s, lut_uv_a, 0).rgb,
      s_ColorGradingLUT_0_NedSmpignorenametexture.SampleLevel(s_ColorGradingLUT_0_sampler_s, lut_uv_b, 0).rgb,
      blue_frac);
  float3 lut1 = lerp(
      s_ColorGradingLUT_1_NedSmpignorenametexture.SampleLevel(s_ColorGradingLUT_1_sampler_s, lut_uv_a, 0).rgb,
      s_ColorGradingLUT_1_NedSmpignorenametexture.SampleLevel(s_ColorGradingLUT_1_sampler_s, lut_uv_b, 0).rgb,
      blue_frac);

  // Vanilla factor.x / factor.y blends, in encoded space.
  float3 graded_encoded = lerp(neutral_encoded, lerp(lut0, lut1, u_color_grading_factor.x), saturate(u_color_grading_factor.y));
  float3 graded_sdr = renodx::color::srgb::DecodeSafe(graded_encoded);
  renodx::draw::Config config = SonicToneMapConfig();
  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = renodx::draw::RenderIntermediatePass(graded_sdr, config);  // RenoDX: Vanilla, no tonemap
  } else {
    o0.rgb = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(SGHighlightShoulder(untonemapped), graded_sdr, neutral_sdr, config), config);
  }
  o0.w = 1;
  return;
}