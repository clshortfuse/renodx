#include "./shared.h"

cbuffer DrawableBuffer : register(b1) {
  float4 FogColor : packoffset(c0);
  float4 DebugColor : packoffset(c1);
  float AlphaThreshold : packoffset(c2);
  float4 __InstancedMaterialOpacity[12] : packoffset(c3);
}

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

SamplerState p_default_Material_17272C1C7708652_BackBufferTexture_sampler_s : register(s0);
SamplerState p_default_Material_18F3494417343873_177C260427234832_199E787C1910656_Texture_sampler_s : register(s1);
SamplerState p_default_Material_19F213AC4902546_Param_sampler_s : register(s2);
SamplerState AttenuationSampler_sampler_s : register(s15);
Texture2D<float4> p_default_Material_17272C1C7708652_BackBufferTexture_texture : register(t0);
Texture2D<float4> p_default_Material_18F3494417343873_177C260427234832_199E787C1910656_Texture_texture : register(t1);
Texture2D<float4> p_default_Material_19F213AC4902546_Param_texture : register(t2);
Texture3D<float4> g_Texlut0 : register(t112);
Texture3D<float4> g_Texlut1 : register(t113);
Texture3D<float4> g_Texlut2 : register(t114);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    float v2: SV_ClipDistance0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.z = (int)v0.x * 24;
  r1.xyz = p_default_Material_17272C1C7708652_BackBufferTexture_texture.Sample(p_default_Material_17272C1C7708652_BackBufferTexture_sampler_s, r0.xy).xyz;
  float3 original = r1.rgb;
  r2.xy = -InstanceParameters[r0.z].InstanceParams[6].zw + r0.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = -InstanceParameters[r0.z].InstanceParams[6].x + r0.w;
  r0.w = saturate(InstanceParameters[r0.z].InstanceParams[6].y * r0.w);
  r2.xyzw = InstanceParameters[r0.z].InstanceParams[1].xyzw + -InstanceParameters[r0.z].InstanceParams[0].xyzw;
  r2.xyzw = r0.wwww * r2.xyzw + InstanceParameters[r0.z].InstanceParams[0].xyzw;
  r0.w = max(r1.x, r1.y);
  r3.x = max(r0.w, r1.z);
  r3.yw = float2(0.25, 0.75);
  r3.z = p_default_Material_19F213AC4902546_Param_texture.Sample(p_default_Material_19F213AC4902546_Param_sampler_s, r3.xy).w;
  r1.xyz = r3.zzz * r1.xyz;
  r1.xyz = r1.xyz / r3.xxx;
  r4.xyzw = p_default_Material_19F213AC4902546_Param_texture.Sample(p_default_Material_19F213AC4902546_Param_sampler_s, r3.zw).xyzw;
  r0.w = -r4.w * 2 + 1;
  r3.xyw = r3.zzz + -r1.xyz;

  float3 scaled = r0.www * r3.xyw + r1.xyz;

  r1.xyz = saturate(r0.www * r3.xyw + r1.xyz);
  r0.w = max(r4.x, r4.y);
  r0.w = max(r0.w, r4.z);
  r0.w = 1 + -r0.w;
  r3.xyw = r4.xyz * r3.zzz;
  r1.xyz = r1.xyz * r0.www + r3.xyw;
  r0.w = 1 + -r3.z;
  r0.xy = r0.xy * InstanceParameters[r0.z].InstanceParams[7].xy + InstanceParameters[r0.z].InstanceParams[7].zw;
  r3.xyz = p_default_Material_18F3494417343873_177C260427234832_199E787C1910656_Texture_texture.Sample(p_default_Material_18F3494417343873_177C260427234832_199E787C1910656_Texture_sampler_s, r0.xy).xyz;
  r3.xyz = float3(1, 1, 1) + r3.xyz;
  r0.x = r0.w * r0.w;
  r0.x = InstanceParameters[r0.z].InstanceParams[5].w * r0.x;
  r3.xyz = r3.xyz * r1.xyz + -r1.xyz;
  r0.xyw = r0.xxx * r3.xyz + r1.xyz;
  r1.x = round(InstanceParameters[r0.z].InstanceParams[4].y);
  r1.x = (int)r1.x;
  r1.y = cmp(0 < (int)r1.x);
  if (r1.y != 0) {
    r1.yzw = log2(r0.xyw);
    r1.yzw = float3(0.833333313, 0.833333313, 0.833333313) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r3.xyz = g_Texlut0.SampleLevel(AttenuationSampler_sampler_s, r1.yzw, 0).xyz;
    r3.w = cmp(1 < (int)r1.x);
    if (r3.w != 0) {
      r4.xyz = g_Texlut1.SampleLevel(AttenuationSampler_sampler_s, r1.yzw, 0).xyz;
      r4.xyz = r4.xyz + -r3.xyz;
      r3.xyz = InstanceParameters[r0.z].InstanceParams[4].zzz * r4.xyz + r3.xyz;
      r1.x = cmp(2 < (int)r1.x);
      if (r1.x != 0) {
        r1.xyz = g_Texlut2.SampleLevel(AttenuationSampler_sampler_s, r1.yzw, 0).xyz;
        r1.xyz = r1.xyz + -r3.xyz;
        r3.xyz = InstanceParameters[r0.z].InstanceParams[4].www * r1.xyz + r3.xyz;
      }
    }
    r1.xyz = log2(r3.xyz);
    r1.xyz = float3(1.20000005, 1.20000005, 1.20000005) * r1.xyz;
    r0.xyw = exp2(r1.xyz);
  }
  r1.xyz = r2.xyz + -r0.xyw;
  o0.xyz = r2.www * r1.xyz + r0.xyw;
  r0.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r0.x].x;

  o0.rgb = renodx::draw::UpgradeToneMapByLuminance(scaled, renodx::tonemap::renodrt::NeutralSDR(scaled), o0.rgb, 1.f);
  o0.w = saturate(o0.w);

  return;
}
