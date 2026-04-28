// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:41 2024

cbuffer cbDefaultPSC : register(b2) {
  float4x4 AlphaLight_WorldtoClipMatrix : packoffset(c0);
  float4x4 AlphaLight_CliptoWorldMatrix : packoffset(c4);
  float4x4 ProjectorMatrix : packoffset(c8);
  float4x4 MotionBlurCurrInvViewProjection : packoffset(c12);
  float4x4 MotionBlurPrevViewProjection : packoffset(c16);
  float4x4 MotionBlurPrevSecViewProjection : packoffset(c20);
  float4x4 Spotlight0_Transform : packoffset(c24);
  float4 TextureAnimation : packoffset(c28);
  float4 AmbientDiffuse : packoffset(c29);
  float4 EnvironmentDebugParams : packoffset(c30);
  float4 ShadowFilterESMWeights : packoffset(c31);
  float4 LegacyDofParams : packoffset(c32);
  float4 OnePixelStepForS0 : packoffset(c33);
  float4 RenderTargetSize : packoffset(c34);
  float4 ModelTrackerID : packoffset(c35);
  float4 Sharpness_Bloom_Controls : packoffset(c36);
  float4 Blur_Direction : packoffset(c37);
  float4 LightMeterDebugParams : packoffset(c38);
  float4 SourceResolution : packoffset(c39);
  float4 HDR_EncodeScale : packoffset(c40);
  float4 OutputGamma : packoffset(c41);
  float4 AlphaLight_ScaleParams : packoffset(c42);
  float4 WrinkleMapWeights[6] : packoffset(c43);
  float4 RadiosityCubeMapIdx : packoffset(c49);
  float4 HairShadingParams[8] : packoffset(c50);
  float4 SkinShadingParams : packoffset(c58);
  float4 HDR_EncodeScale3 : packoffset(c59);
  float4 ScreenResolution[4] : packoffset(c60);
  float4 VelocityParams : packoffset(c64);
  float4 DeferredConstColor : packoffset(c65);
  float4 Spotlight0_Shadow_Params : packoffset(c66);
  float4 Spotlight0_ShadowMapDimensions : packoffset(c67);
  float4 ShadowFilterType : packoffset(c68);
  float4 Spotlight0_ReverseZPerspective : packoffset(c69);
  float4 SpacesuitVisorParams : packoffset(c70);
  float4 Directional_Light_Colour : packoffset(c71);
  float4 Directional_Light_Direction : packoffset(c72);
  float4 EnvironmentMap_Params : packoffset(c73);
  float4 Spotlight0_Shadow_Bias_GoboScale : packoffset(c74);
  float4 ScreenSpaceLightShaftParams1 : packoffset(c75);
  float4 ScreenSpaceLightShaftParams2 : packoffset(c76);
  float4 ScreenSpaceLightPosition : packoffset(c77);
  float4 LensAndScreenCenter : packoffset(c78);
  float4 ScaleAndScaleIn : packoffset(c79);
  float4 HmdWarpParam : packoffset(c80);
  float4 ChromAbParam : packoffset(c81);
  float4 SMAA_SubsampleIndices : packoffset(c82);
}

SamplerState g_smp_frame_SMP_s : register(s0);
Texture2D<float4> g_smp_frame_TEX : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, v1.xy, 0).xyzw;
  r1.xyz = g_smp_frame_TEX.Gather(g_smp_frame_SMP_s, v1.xy).xyz;
  r2.xyz = g_smp_frame_TEX.Gather(g_smp_frame_SMP_s, v1.xy, int2(-1, -1)).xzw;
  r1.w = max(r1.x, r0.w);
  r2.w = min(r1.x, r0.w);
  r1.w = max(r1.z, r1.w);
  r2.w = min(r2.w, r1.z);
  r3.x = max(r2.y, r2.x);
  r3.y = min(r2.y, r2.x);
  r1.w = max(r3.x, r1.w);
  r2.w = min(r3.y, r2.w);
  r3.x = 0.125 * r1.w;
  r1.w = -r2.w + r1.w;
  r2.w = max(0.0625, r3.x);
  r2.w = cmp(r1.w >= r2.w);
  if (r2.w != 0) {
    r3.xy = float2(1, 1) / RenderTargetSize.xy;
    r2.w = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, v1.xy, 0, int2(1, -1)).w;
    r3.z = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, v1.xy, 0, int2(-1, 1)).w;
    r4.xy = r2.yx + r1.xz;
    r1.w = 1 / r1.w;
    r3.w = r4.x + r4.y;
    r4.xy = r0.ww * float2(-2, -2) + r4.xy;
    r4.z = r2.w + r1.y;
    r2.w = r2.z + r2.w;
    r4.w = r1.z * -2 + r4.z;
    r2.w = r2.y * -2 + r2.w;
    r2.z = r3.z + r2.z;
    r1.y = r3.z + r1.y;
    r3.z = abs(r4.x) * 2 + abs(r4.w);
    r2.w = abs(r4.y) * 2 + abs(r2.w);
    r4.x = r2.x * -2 + r2.z;
    r1.y = r1.x * -2 + r1.y;
    r3.z = abs(r4.x) + r3.z;
    r1.y = abs(r1.y) + r2.w;
    r2.z = r2.z + r4.z;
    r1.y = cmp(r3.z >= r1.y);
    r2.z = r3.w * 2 + r2.z;
    r2.x = r1.y ? r2.y : r2.x;
    r1.x = r1.y ? r1.x : r1.z;
    r1.z = r1.y ? r3.y : r3.x;
    r2.y = r2.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.x + -r0.w;
    r2.x = r2.x + r0.w;
    r1.x = r1.x + r0.w;
    r3.z = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r1.z = r3.z ? -r1.z : r1.z;
    r1.w = saturate(abs(r2.y) * r1.w);
    r2.y = r1.y ? r3.x : 0;
    r2.w = r1.y ? 0 : r3.y;
    r3.xy = r1.zz * float2(0.5, 0.5) + v1.xy;
    r3.x = r1.y ? v1.x : r3.x;
    r3.y = r1.y ? r3.y : v1.y;
    r4.xy = r3.xy + -r2.yw;
    r5.xy = r3.xy + r2.yw;
    r3.x = r1.w * -2 + 3;
    r3.y = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r4.xy, 0).w;
    r1.w = r1.w * r1.w;
    r3.w = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r5.xy, 0).w;
    r1.x = r3.z ? r2.x : r1.x;
    r2.x = 0.25 * r2.z;
    r2.z = -r1.x * 0.5 + r0.w;
    r1.w = r3.x * r1.w;
    r2.z = cmp(r2.z < 0);
    r3.x = -r1.x * 0.5 + r3.y;
    r3.y = -r1.x * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r2.xx);
    r4.z = -r2.y * 1.5 + r4.x;
    r4.x = r3.z ? r4.x : r4.z;
    r4.w = -r2.w * 1.5 + r4.y;
    r4.z = r3.z ? r4.y : r4.w;
    r4.yw = ~(int2)r3.zw;
    r4.y = (int)r4.w | (int)r4.y;
    r4.w = r2.y * 1.5 + r5.x;
    r5.x = r3.w ? r5.x : r4.w;
    r4.w = r2.w * 1.5 + r5.y;
    r5.z = r3.w ? r5.y : r4.w;
    if (r4.y != 0) {
      if (r3.z == 0) {
        r3.x = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r4.xz, 0).w;
      }
      if (r3.w == 0) {
        r3.y = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r5.xz, 0).w;
      }
      r4.y = -r1.x * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r4.y;
      r3.z = -r1.x * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r3.z;
      r3.zw = cmp(abs(r3.xy) >= r2.xx);
      r4.y = -r2.y * 2 + r4.x;
      r4.x = r3.z ? r4.x : r4.y;
      r4.y = -r2.w * 2 + r4.z;
      r4.z = r3.z ? r4.z : r4.y;
      r4.yw = ~(int2)r3.zw;
      r4.y = (int)r4.w | (int)r4.y;
      r4.w = r2.y * 2 + r5.x;
      r5.x = r3.w ? r5.x : r4.w;
      r4.w = r2.w * 2 + r5.z;
      r5.z = r3.w ? r5.z : r4.w;
      if (r4.y != 0) {
        if (r3.z == 0) {
          r3.x = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r4.xz, 0).w;
        }
        if (r3.w == 0) {
          r3.y = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r5.xz, 0).w;
        }
        r4.y = -r1.x * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r4.y;
        r3.z = -r1.x * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r3.z;
        r3.zw = cmp(abs(r3.xy) >= r2.xx);
        r4.y = -r2.y * 2 + r4.x;
        r4.x = r3.z ? r4.x : r4.y;
        r4.y = -r2.w * 2 + r4.z;
        r4.z = r3.z ? r4.z : r4.y;
        r4.yw = ~(int2)r3.zw;
        r4.y = (int)r4.w | (int)r4.y;
        r4.w = r2.y * 2 + r5.x;
        r5.x = r3.w ? r5.x : r4.w;
        r4.w = r2.w * 2 + r5.z;
        r5.z = r3.w ? r5.z : r4.w;
        if (r4.y != 0) {
          if (r3.z == 0) {
            r3.x = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r4.xz, 0).w;
          }
          if (r3.w == 0) {
            r3.y = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r5.xz, 0).w;
          }
          r4.y = -r1.x * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r4.y;
          r3.z = -r1.x * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r3.z;
          r3.zw = cmp(abs(r3.xy) >= r2.xx);
          r4.y = -r2.y * 4 + r4.x;
          r4.x = r3.z ? r4.x : r4.y;
          r4.y = -r2.w * 4 + r4.z;
          r4.z = r3.z ? r4.z : r4.y;
          r4.yw = ~(int2)r3.zw;
          r4.y = (int)r4.w | (int)r4.y;
          r4.w = r2.y * 4 + r5.x;
          r5.x = r3.w ? r5.x : r4.w;
          r4.w = r2.w * 4 + r5.z;
          r5.z = r3.w ? r5.z : r4.w;
          if (r4.y != 0) {
            if (r3.z == 0) {
              r3.x = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r4.xz, 0).w;
            }
            if (r3.w == 0) {
              r3.y = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r5.xz, 0).w;
            }
            r4.y = -r1.x * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r4.y;
            r1.x = -r1.x * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r1.x;
            r3.zw = cmp(abs(r3.xy) >= r2.xx);
            r1.x = -r2.y * 2 + r4.x;
            r4.x = r3.z ? r4.x : r1.x;
            r1.x = -r2.w * 2 + r4.z;
            r4.z = r3.z ? r4.z : r1.x;
            r1.x = r2.y * 2 + r5.x;
            r5.x = r3.w ? r5.x : r1.x;
            r1.x = r2.w * 2 + r5.z;
            r5.z = r3.w ? r5.z : r1.x;
          }
        }
      }
    }
    r1.x = v1.x + -r4.x;
    r2.y = v1.y + -r4.z;
    r1.x = r1.y ? r1.x : r2.y;
    r2.xy = -v1.xy + r5.xz;
    r2.x = r1.y ? r2.x : r2.y;
    r2.yw = cmp(r3.xy < float2(0, 0));
    r3.x = r2.x + r1.x;
    r2.yz = cmp((int2)r2.yw != (int2)r2.zz);
    r2.w = 1 / r3.x;
    r3.x = cmp(r1.x < r2.x);
    r1.x = min(r2.x, r1.x);
    r2.x = r3.x ? r2.y : r2.z;
    r1.w = r1.w * r1.w;
    r1.x = r1.x * -r2.w + 0.5;
    r1.w = 0.75 * r1.w;
    r1.x = (int)r1.x & (int)r2.x;
    r1.x = max(r1.x, r1.w);
    r1.xz = r1.xx * r1.zz + v1.xy;
    r2.x = r1.y ? v1.x : r1.x;
    r2.y = r1.y ? r1.z : v1.y;
    o0.xyzw = g_smp_frame_TEX.SampleLevel(g_smp_frame_SMP_s, r2.xy, 0).xyzw;
  } else {
    o0.xyzw = r0.xyzw;
  }
  return;
}
