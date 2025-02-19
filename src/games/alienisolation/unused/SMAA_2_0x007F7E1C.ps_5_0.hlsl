// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:42:56 2024

cbuffer cbDefaultXSC : register(b0) {
  float4x4 ViewProj : packoffset(c0);
  float4x4 ViewMatrix : packoffset(c4);
  float4x4 SecondaryProj : packoffset(c8);
  float4x4 SecondaryViewProj : packoffset(c12);
  float4x4 SecondaryInvViewProj : packoffset(c16);
  float4 ConstantColour : packoffset(c20);
  float4 Time : packoffset(c21);
  float4 CameraPosition : packoffset(c22);
  float4 InvProjectionParams : packoffset(c23);
  float4 SecondaryInvProjectionParams : packoffset(c24);
  float4 ShaderDebugParams : packoffset(c25);
  float4 ToneMappingDebugParams : packoffset(c26);
  float4 HDR_EncodeScale2 : packoffset(c27);
  float4 EmissiveSurfaceMultiplier : packoffset(c28);
  float4 AlphaLight_OffsetScale : packoffset(c29);
  float4 TessellationScaleFactor : packoffset(c30);
  float4 FogNearColour : packoffset(c31);
  float4 FogFarColour : packoffset(c32);
  float4 FogParams : packoffset(c33);
  float4 AdvanceEnvironmentShaderDebugParams : packoffset(c34);
  float4 SMAA_RTMetrics : packoffset(c35);
}

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

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> edgesTex : register(t5);
Texture2D<float4> areaTex : register(t7);
Texture2D<float4> searchTex : register(t8);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float4 v2: TEXCOORD2,
    float4 v3: TEXCOORD3,
    float4 v4: TEXCOORD4,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = edgesTex.Sample(LinearSampler_s, v1.xy).xy;
  r0.y = cmp(0 < r0.y);
  if (r0.y != 0) {
    r0.y = cmp(0 < r0.x);
    if (r0.y != 0) {
      r1.xy = float2(-1, 1) * SMAA_RTMetrics.xy;
      r1.z = 1;
      r2.xy = v1.xy;
      r0.y = 0;
      r2.z = -1;
      r3.x = 1;
      while (true) {
        r0.w = cmp(r2.z < 15);
        r1.w = cmp(0.899999976 < r3.x);
        r0.w = r0.w ? r1.w : 0;
        if (r0.w == 0) break;
        r2.xyz = r2.xyz + r1.xyz;
        r0.yz = edgesTex.SampleLevel(LinearSampler_s, r2.xy, 0).yx;
        r3.x = dot(r0.zy, float2(0.5, 0.5));
      }
      r0.y = cmp(0.899999976 < r0.y);
      r0.y = r0.y ? 1.000000 : 0;
      r1.x = r2.z + r0.y;
    } else {
      r1.x = 0;
      r3.x = 0;
    }
    r0.yz = float2(1, -1) * SMAA_RTMetrics.xy;
    r0.w = 1;
    r2.yz = v1.xy;
    r2.xw = float2(-1, 1);
    while (true) {
      r3.z = cmp(r2.x < 15);
      r3.w = cmp(0.899999976 < r2.w);
      r3.z = r3.w ? r3.z : 0;
      if (r3.z == 0) break;
      r2.xyz = r2.xyz + r0.wyz;
      r3.zw = edgesTex.SampleLevel(LinearSampler_s, r2.yz, 0).xy;
      r2.w = dot(r3.zw, float2(0.5, 0.5));
    }
    r3.y = r2.w;
    r0.y = r2.x + r1.x;
    r0.y = cmp(2 < r0.y);
    if (r0.y != 0) {
      r1.y = 0.25 + -r1.x;
      r1.zw = r2.xx * float2(1, -1) + float2(0, -0.25);
      r2.xyzw = r1.yxzw * SMAA_RTMetrics.xyxy + v1.xyxy;
      r0.yz = edgesTex.SampleLevel(LinearSampler_s, r2.xy, 0, int2(-1, 0)).xy;
      r1.yw = edgesTex.SampleLevel(LinearSampler_s, r2.zw, 0, int2(1, 0)).xy;
      r0.w = r1.y;
      r2.xy = r0.wy * float2(5, 5) + float2(-3.75, -3.75);
      r0.yw = abs(r2.xy) * r0.wy;
      r0.yw = round(r0.yw);
      r2.y = round(r0.z);
      r2.w = round(r1.w);
      r0.yz = r2.wy * float2(2, 2) + r0.yw;
      r1.yw = cmp(r3.yx >= float2(0.899999976, 0.899999976));
      r0.yz = r1.yw ? float2(0, 0) : r0.yz;
      r0.yz = r0.yz * float2(20, 20) + r1.zx;
      r1.xy = r0.yz * float2(0.0017857143, 0.00625000009) + float2(0.000892857148, 0.503125012);
      r1.z = SMAA_SubsampleIndices.z * 0.142857149 + r1.x;
      r0.yz = areaTex.SampleLevel(LinearSampler_s, r1.yz, 0).xy;
    } else {
      r0.yz = float2(0, 0);
    }
    r0.w = SMAA_RTMetrics.x * 0.25 + v1.x;
    r1.xy = -SMAA_RTMetrics.xy;
    r1.z = 1;
    r2.y = r0.w;
    r2.z = v1.y;
    r2.xw = float2(1, -1);
    while (true) {
      r1.w = cmp(r2.w < 15);
      r3.x = cmp(0.899999976 < r2.x);
      r1.w = r1.w ? r3.x : 0;
      if (r1.w == 0) break;
      r2.yzw = r2.yzw + r1.xyz;
      r3.xy = edgesTex.SampleLevel(LinearSampler_s, r2.yz, 0).xy;
      r1.w = r3.x * 5 + -3.75;
      r1.w = r3.x * abs(r1.w);
      r4.x = round(r1.w);
      r4.y = round(r3.y);
      r2.x = dot(r4.xy, float2(0.5, 0.5));
    }
    r1.x = r2.w;
    r1.w = edgesTex.SampleLevel(LinearSampler_s, v1.xy, 0, int2(1, 0)).x;
    r1.w = cmp(0 < r1.w);
    if (r1.w != 0) {
      r3.xy = SMAA_RTMetrics.xy;
      r3.z = 1;
      r4.x = r0.w;
      r4.y = v1.y;
      r4.z = -1;
      r2.yz = float2(1, 0);
      while (true) {
        r1.w = cmp(r4.z < 15);
        r3.w = cmp(0.899999976 < r2.y);
        r1.w = r1.w ? r3.w : 0;
        if (r1.w == 0) break;
        r4.xyz = r4.xyz + r3.xyz;
        r5.xy = edgesTex.SampleLevel(LinearSampler_s, r4.xy, 0).xy;
        r1.w = r5.x * 5 + -3.75;
        r1.w = r5.x * abs(r1.w);
        r2.w = round(r1.w);
        r2.z = round(r5.y);
        r2.y = dot(r2.wz, float2(0.5, 0.5));
      }
      r0.w = cmp(0.899999976 < r2.z);
      r0.w = r0.w ? 1.000000 : 0;
      r1.z = r4.z + r0.w;
    } else {
      r1.z = 0;
      r2.y = 0;
    }
    r0.w = r1.x + r1.z;
    r0.w = cmp(2 < r0.w);
    if (r0.w != 0) {
      r1.y = -r1.x;
      r3.xyzw = r1.yyzz * SMAA_RTMetrics.xyxy + v1.xyxy;
      r4.y = edgesTex.SampleLevel(LinearSampler_s, r3.xy, 0, int2(-1, 0)).y;
      r4.w = edgesTex.SampleLevel(LinearSampler_s, r3.xy, 0, int2(0, -1)).x;
      r4.xz = edgesTex.SampleLevel(LinearSampler_s, r3.zw, 0, int2(1, 0)).yx;
      r1.yw = r4.xy * float2(2, 2) + r4.zw;
      r2.xy = cmp(r2.yx >= float2(0.899999976, 0.899999976));
      r1.yw = r2.xy ? float2(0, 0) : r1.yw;
      r1.xy = r1.yw * float2(20, 20) + r1.zx;
      r1.xy = r1.xy * float2(0.0017857143, 0.00625000009) + float2(0.000892857148, 0.503125012);
      r1.z = SMAA_SubsampleIndices.w * 0.142857149 + r1.x;
      r1.xy = areaTex.SampleLevel(LinearSampler_s, r1.yz, 0).xy;
      r0.yz = r1.yx + r0.yz;
    }
    r0.w = cmp(r0.y == -r0.z);
    if (r0.w != 0) {
      r1.xy = v2.xy;
      r1.z = 1;
      r2.x = 0;
      while (true) {
        r0.w = cmp(v4.x < r1.x);
        r1.w = cmp(0.828100026 < r1.z);
        r0.w = r0.w ? r1.w : 0;
        r1.w = cmp(r2.x == 0.000000);
        r0.w = r0.w ? r1.w : 0;
        if (r0.w == 0) break;
        r2.xy = edgesTex.SampleLevel(LinearSampler_s, r1.xy, 0).xy;
        r1.xy = SMAA_RTMetrics.xy * float2(-2, -0) + r1.xy;
        r1.z = r2.y;
      }
      r2.yz = r1.xz;
      r1.xy = r2.xz * float2(0.5, -2) + float2(0.0078125, 2.03125);
      r0.w = searchTex.SampleLevel(LinearSampler_s, r1.xy, 0).x;
      r0.w = r0.w * -2.00787401 + 3.25;
      r1.x = SMAA_RTMetrics.x * r0.w + r2.y;
      r1.y = v3.y;
      r2.x = edgesTex.SampleLevel(LinearSampler_s, r1.xy, 0).x;
      r3.xy = v2.zw;
      r3.z = 1;
      r4.x = 0;
      while (true) {
        r0.w = cmp(r3.x < v4.y);
        r2.z = cmp(0.828100026 < r3.z);
        r0.w = r0.w ? r2.z : 0;
        r2.z = cmp(r4.x == 0.000000);
        r0.w = r0.w ? r2.z : 0;
        if (r0.w == 0) break;
        r4.xy = edgesTex.SampleLevel(LinearSampler_s, r3.xy, 0).xy;
        r3.xy = SMAA_RTMetrics.xy * float2(2, 0) + r3.xy;
        r3.z = r4.y;
      }
      r4.yz = r3.xz;
      r2.zw = r4.xz * float2(0.5, -2) + float2(0.5234375, 2.03125);
      r0.w = searchTex.SampleLevel(LinearSampler_s, r2.zw, 0).x;
      r0.w = r0.w * -2.00787401 + 3.25;
      r1.z = -SMAA_RTMetrics.x * r0.w + r4.y;
      r3.xyzw = SMAA_RTMetrics.zzzz * r1.zxzx + -w1.x;  // -w1.xzzz
      r3.xyzw = round(r3.xyzw);
      r2.zw = sqrt(abs(r3.wz));
      r2.y = edgesTex.SampleLevel(LinearSampler_s, r1.zy, 0, int2(1, 0)).x;
      r2.xy = float2(4, 4) * r2.xy;
      r2.xy = round(r2.xy);
      r2.xy = r2.xy * float2(16, 16) + r2.zw;
      r2.xy = r2.xy * float2(0.00625000009, 0.0017857143) + float2(0.00312500005, 0.000892857148);
      r2.z = SMAA_SubsampleIndices.y * 0.142857149 + r2.y;
      r2.xy = areaTex.SampleLevel(LinearSampler_s, r2.xz, 0).xy;
      r3.xyzw = cmp(abs(r3.xyzw) >= abs(r3.wzwz));
      r3.xyzw = r3.xyzw ? float4(1, 1, 0.75, 0.75) : 0;
      r0.w = r3.x + r3.y;
      r2.zw = r3.zw / r0.ww;
      r1.w = v1.y;
      r0.w = edgesTex.SampleLevel(LinearSampler_s, r1.xw, 0, int2(0, 1)).x;
      r0.w = -r2.z * r0.w + 1;
      r1.y = edgesTex.SampleLevel(LinearSampler_s, r1.zw, 0, int2(1, 1)).x;
      r3.x = saturate(-r2.w * r1.y + r0.w);
      r0.w = edgesTex.SampleLevel(LinearSampler_s, r1.xw, 0, int2(0, -2)).x;
      r0.w = -r2.z * r0.w + 1;
      r1.x = edgesTex.SampleLevel(LinearSampler_s, r1.zw, 0, int2(1, -2)).x;
      r3.y = saturate(-r2.w * r1.x + r0.w);
      o0.xy = r3.xy * r2.xy;
    } else {
      o0.xy = r0.yz;
      r0.x = 0;
    }
  } else {
    o0.xy = float2(0, 0);
  }
  r0.x = cmp(0 < r0.x);
  if (r0.x != 0) {
    r0.xy = v3.xy;
    r0.z = 1;
    r1.x = 0;
    while (true) {
      r0.w = cmp(v4.z < r0.y);
      r1.w = cmp(0.828100026 < r0.z);
      r0.w = r0.w ? r1.w : 0;
      r1.w = cmp(r1.x == 0.000000);
      r0.w = r0.w ? r1.w : 0;
      if (r0.w == 0) break;
      r1.xy = edgesTex.SampleLevel(LinearSampler_s, r0.xy, 0).yx;
      r0.xy = SMAA_RTMetrics.xy * float2(-0, -2) + r0.xy;
      r0.z = r1.y;
    }
    r1.yz = r0.yz;
    r0.xy = r1.xz * float2(0.5, -2) + float2(0.0078125, 2.03125);
    r0.x = searchTex.SampleLevel(LinearSampler_s, r0.xy, 0).x;
    r0.x = r0.x * -2.00787401 + 3.25;
    r0.x = SMAA_RTMetrics.y * r0.x + r1.y;
    r0.y = v2.x;
    r1.x = edgesTex.SampleLevel(LinearSampler_s, r0.yx, 0).y;
    r2.xy = v3.zw;
    r2.z = 1;
    r3.x = 0;
    while (true) {
      r1.z = cmp(r2.y < v4.w);
      r1.w = cmp(0.828100026 < r2.z);
      r1.z = r1.w ? r1.z : 0;
      r1.w = cmp(r3.x == 0.000000);
      r1.z = r1.w ? r1.z : 0;
      if (r1.z == 0) break;
      r3.xy = edgesTex.SampleLevel(LinearSampler_s, r2.xy, 0).yx;
      r2.xy = SMAA_RTMetrics.xy * float2(0, 2) + r2.xy;
      r2.z = r3.y;
    }
    r3.yz = r2.yz;
    r1.zw = r3.xz * float2(0.5, -2) + float2(0.5234375, 2.03125);
    r1.z = searchTex.SampleLevel(LinearSampler_s, r1.zw, 0).x;
    r1.z = r1.z * -2.00787401 + 3.25;
    r0.z = -SMAA_RTMetrics.y * r1.z + r3.y;
    r2.xyzw = SMAA_RTMetrics.wwww * r0.zxzx + -w1.y;  // -w1.ywww
    r2.xyzw = round(r2.xyzw);
    r1.zw = sqrt(abs(r2.wz));
    r1.y = edgesTex.SampleLevel(LinearSampler_s, r0.yz, 0, int2(0, 1)).y;
    r1.xy = float2(4, 4) * r1.xy;
    r1.xy = round(r1.xy);
    r1.xy = r1.xy * float2(16, 16) + r1.zw;
    r1.xy = r1.xy * float2(0.00625000009, 0.0017857143) + float2(0.00312500005, 0.000892857148);
    r1.z = SMAA_SubsampleIndices.x * 0.142857149 + r1.y;
    r1.xy = areaTex.SampleLevel(LinearSampler_s, r1.xz, 0).xy;
    r2.xyzw = cmp(abs(r2.xyzw) >= abs(r2.wzwz));
    r2.xyzw = r2.xyzw ? float4(1, 1, 0.75, 0.75) : 0;
    r0.y = r2.x + r2.y;
    r1.zw = r2.zw / r0.yy;
    r0.w = v1.x;
    r0.y = edgesTex.SampleLevel(LinearSampler_s, r0.wx, 0, int2(1, 0)).y;
    r0.y = -r1.z * r0.y + 1;
    r2.x = edgesTex.SampleLevel(LinearSampler_s, r0.wz, 0, int2(1, 1)).y;
    r2.z = saturate(-r1.w * r2.x + r0.y);
    r0.x = edgesTex.SampleLevel(LinearSampler_s, r0.wx, 0, int2(-2, 0)).y;
    r0.x = -r1.z * r0.x + 1;
    r0.y = edgesTex.SampleLevel(LinearSampler_s, r0.wz, 0, int2(-2, 1)).y;
    r2.w = saturate(-r1.w * r0.y + r0.x);
    o0.zw = r2.zw * r1.xy;
  } else {
    o0.zw = float2(0, 0);
  }
  return;
}
