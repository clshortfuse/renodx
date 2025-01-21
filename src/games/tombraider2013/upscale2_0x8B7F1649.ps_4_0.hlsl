#include "./shared.h"

cbuffer SceneBuffer : register(b2) {
  row_major float4x4 View : packoffset(c0);
  row_major float4x4 ScreenMatrix : packoffset(c4);
  float2 DepthExportScale : packoffset(c8);
  float4 FogParams : packoffset(c9);
  float3 __CameraPosition : packoffset(c10);
  float3 CameraDirection : packoffset(c11);
  float3 DepthFactors : packoffset(c12);
  float2 ShadowDepthBias : packoffset(c13);
  float4 SubframeViewport : packoffset(c14);
  row_major float3x4 DepthToWorld : packoffset(c15);
  float4 DepthToView : packoffset(c18);
  float4 OneOverDepthToView : packoffset(c19);
  float4 DepthToW : packoffset(c20);
  float4 ClipPlane : packoffset(c21);
  float2 ViewportDepthScaleOffset : packoffset(c22);
  float2 ColorDOFDepthScaleOffset : packoffset(c23);
  float2 TimeVector : packoffset(c24);
  float3 FogParams2 : packoffset(c25);
  float3 GlobalAmbient : packoffset(c26);
  float4 GlobalParams[16] : packoffset(c27);
  float4 ViewToFogH : packoffset(c43);
  float4 ScreenExtents : packoffset(c44);
  float2 ScreenResolution : packoffset(c45);
  float4 PSSMToMap1Lin : packoffset(c46);
  float4 PSSMToMap1Const : packoffset(c47);
  float4 PSSMToMap2Lin : packoffset(c48);
  float4 PSSMToMap2Const : packoffset(c49);
  float4 PSSMToMap3Lin : packoffset(c50);
  float4 PSSMToMap3Const : packoffset(c51);
  float4 PSSMDistances : packoffset(c52);
  row_major float4x4 WorldToPSSM0 : packoffset(c53);
  row_major float4x4 PrevViewProject : packoffset(c57);
  row_major float4x4 PrevWorld : packoffset(c61);
  row_major float4x4 ViewT : packoffset(c65);
  float4 PSSMExtents : packoffset(c69);
  float4 ShadowAtlasResolution : packoffset(c70);
  float4 UnitRimData[3] : packoffset(c71);
  float3 __CameraPositionForCorrection : packoffset(c74);
  row_major float4x4 InverseProjection : packoffset(c80);
  float4 StereoOffset : packoffset(c84);
}

cbuffer InstanceBuffer : register(b5) {
  struct
  {
    float4 InstanceParams[8];
    float4 ExtendedInstanceParams[16];
  }
  InstanceParameters[12] : packoffset(c0);
}

SamplerState p_default_Material_2622C6A465163452_Param_sampler_s : register(s0);
Texture2D<float4> p_default_Material_2622C6A465163452_Param_texture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)v0.x * 24;
  r0.yz = v1.xy * ScreenExtents.zw + ScreenExtents.xy;

  float4 untonemapped = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r0.yz, 0).xyzw;
  untonemapped = max(0, untonemapped);

  r1.xy = -InstanceParameters[r0.x].InstanceParams[0].xy * float2(0.25, 0.25) + r0.yz;
  r1.zw = InstanceParameters[r0.x].InstanceParams[0].xy * float2(1, 0) + r1.xy;
  r2.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r1.zw, 0).xyzw;
  
  r2 = max(0, r2);

  r0.w = dot(r2.xyz, float3(0.298999995, 0.587000012, 0.114));
  r1.zw = InstanceParameters[r0.x].InstanceParams[0].xy + r1.xy;
  r2.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r1.zw, 0).xyzw;
  
  r2 = max(0, r2);

  r1.z = dot(r2.xyz, float3(0.298999995, 0.587000012, 0.114));
  r1.w = r1.z + r0.w;
  r2.xy = InstanceParameters[r0.x].InstanceParams[0].xy * float2(0, 1) + r1.xy;
  r3.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r1.xy, 0).xyzw;

  r3 = max(0, r3);

  r1.x = dot(r3.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r2.xy, 0).xyzw;

  r2 = max(0, r2);

  r1.y = dot(r2.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.x = r1.x + r1.y;
  r2.yw = r2.xx + -r1.ww;
  r1.w = r1.x + r0.w;
  r3.x = r1.y + r1.z;
  r3.x = -r3.x + r1.w;
  r1.w = r1.w + r1.y;
  r1.w = r1.w + r1.z;
  r1.w = 0.03125 * r1.w;
  r1.w = max(0.0078125, r1.w);
  r3.y = min(abs(r3.x), abs(r2.w));
  r2.xz = -r3.xx;
  r1.w = r3.y + r1.w;
  r1.w = 1 / r1.w;
  r2.xyzw = r2.xyzw * r1.wwww;
  r2.xyzw = max(float4(-8, -8, -8, -8), r2.xyzw);
  r2.xyzw = min(float4(8, 8, 8, 8), r2.xyzw);
  r2.xyzw = InstanceParameters[r0.x].InstanceParams[0].xyxy * r2.xyzw;
  r2.xy = r2.xy * float2(-0.5, -0.5) + r0.yz;
  r3.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r2.xy, 0).xyzw;

  r3 = max(0, r3);

  r2.xy = r2.zw * float2(0.5, 0.5) + r0.yz;
  r4.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r2.xy, 0).xyzw;

  r4 = max(0, r4);

  r3.xyz = r4.xyz + r3.xyz;
  r3.xyz = float3(0.25, 0.25, 0.25) * r3.xyz;
  r2.xy = r2.zw * float2(-0.166666672, -0.166666672) + r0.yz;
  r2.zw = r2.zw * float2(0.166666672, 0.166666672) + r0.yz;
  r4.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r0.yz, 0).xyzw;

  r4 = max(0, r4);

  r5.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r2.zw, 0).xyzw;

  r5 = max(0, r5);

  r2.xyzw = p_default_Material_2622C6A465163452_Param_texture.SampleLevel(p_default_Material_2622C6A465163452_Param_sampler_s, r2.xy, 0).xyzw;

  r2 = max(0, r2);

  r0.xyz = r2.xyz + r5.xyz;
  r2.xyz = r0.xyz * float3(0.25, 0.25, 0.25) + r3.xyz;
  r0.xyz = float3(0.5, 0.5, 0.5) * r0.xyz;
  r1.w = dot(r2.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.w = min(r1.y, r1.z);
  r1.y = max(r1.y, r1.z);
  r1.z = min(r1.x, r0.w);
  r0.w = max(r1.x, r0.w);
  r0.w = max(r0.w, r1.y);
  r1.x = min(r1.z, r2.w);
  r1.y = dot(r4.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.w = r4.w;
  r1.x = min(r1.y, r1.x);
  r0.w = max(r1.y, r0.w);
  r0.w = cmp(r0.w < r1.w);
  r1.x = cmp(r1.w < r1.x);
  r0.w = (int)r0.w | (int)r1.x;
  o0.xyz = r0.www ? r0.xyz : r2.xyz;

  o0.rgb = lerp(untonemapped.rgb, o0.rgb, CUSTOM_FXAA);
  o0.rgb = max(0, o0.rgb);
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  if (RENODX_TONE_MAP_TYPE == 0) {
    o0.rgb = saturate(o0.rgb);
  } else {
    o0.rgb = renodx::draw::ToneMapPass(o0.rgb);
  }

  if (CUSTOM_FILM_GRAIN_TYPE == 1.f && CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    o0.rgb = renodx::effects::ApplyFilmGrain(
        o0.rgb,
        v1.xy * ScreenExtents.zw + ScreenExtents.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  // Needs to be 1.f or else it tries to overlay/blend ???
  o0.w = renodx::color::luma::from::BT601(o0.rgb);

  return;
}
