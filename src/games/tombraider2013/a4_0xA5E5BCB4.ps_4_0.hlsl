// ---- Created with 3Dmigoto v1.4.1 on Sun Jan 19 11:18:34 2025

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

SamplerState p_default_Material_024F04E4252657_DepthBufferTexture_sampler_s : register(s0);
SamplerState p_default_Material_024F041C225126_BackBufferTexture_sampler_s : register(s1);
Texture2D<float4> p_default_Material_024F04E4252657_DepthBufferTexture_texture : register(t0);
Texture2D<float4> p_default_Material_024F041C225126_BackBufferTexture_texture : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 1;
  r1.xy = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.w = (int)v0.x * 24;
  r1.zw = InstanceParameters[r0.w].InstanceParams[0].xy + r1.xy;
  r2.xyzw = p_default_Material_024F04E4252657_DepthBufferTexture_texture.SampleLevel(p_default_Material_024F04E4252657_DepthBufferTexture_sampler_s, r1.zw, 0).xyzw;

  r2 = max(0, r2);

  r2.x = r2.x * DepthToW.x + DepthToW.y;
  r2.x = max(9.99999997e-07, r2.x);
  r2.x = 1 / r2.x;
  r0.xy = r1.zw * DepthToView.xy + DepthToView.zw;
  r3.xyzw = p_default_Material_024F041C225126_BackBufferTexture_texture.Sample(p_default_Material_024F041C225126_BackBufferTexture_sampler_s, r1.zw).xyzw;

  r3 = max(0, r3);

  r0.xyz = r2.xxx * r0.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r2.x = sqrt(r0.x);
  r0.z = 1;
  r1.zw = InstanceParameters[r0.w].InstanceParams[0].xw + r1.xy;
  r4.xyzw = p_default_Material_024F04E4252657_DepthBufferTexture_texture.SampleLevel(p_default_Material_024F04E4252657_DepthBufferTexture_sampler_s, r1.zw, 0).xyzw;

  r4 = max(0, r4);

  r3.w = r4.x * DepthToW.x + DepthToW.y;
  r3.w = max(9.99999997e-07, r3.w);
  r3.w = 1 / r3.w;
  r0.xy = r1.zw * DepthToView.xy + DepthToView.zw;
  r4.xyzw = p_default_Material_024F041C225126_BackBufferTexture_texture.Sample(p_default_Material_024F041C225126_BackBufferTexture_sampler_s, r1.zw).xyzw;

  r4 = max(0, r4);

  r0.xyz = r3.www * r0.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r2.y = sqrt(r0.x);
  r0.z = 1;
  r1.zw = InstanceParameters[r0.w].InstanceParams[0].zy + r1.xy;
  r5.xyzw = p_default_Material_024F04E4252657_DepthBufferTexture_texture.SampleLevel(p_default_Material_024F04E4252657_DepthBufferTexture_sampler_s, r1.zw, 0).xyzw;

  r5 = max(0, r5);

  r3.w = r5.x * DepthToW.x + DepthToW.y;
  r3.w = max(9.99999997e-07, r3.w);
  r3.w = 1 / r3.w;
  r0.xy = r1.zw * DepthToView.xy + DepthToView.zw;
  r5.xyzw = p_default_Material_024F041C225126_BackBufferTexture_texture.Sample(p_default_Material_024F041C225126_BackBufferTexture_sampler_s, r1.zw).xyzw;

  r5 = max(0, r5);

  r0.xyz = r3.www * r0.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r2.z = sqrt(r0.x);
  r0.z = 1;
  r1.zw = InstanceParameters[r0.w].InstanceParams[0].zw + r1.xy;
  r1.xy = float2(-0.5, -0.5) + r1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = -InstanceParameters[r0.w].InstanceParams[3].x + r1.x;
  r1.x = saturate(InstanceParameters[r0.w].InstanceParams[3].y * r1.x);
  r1.x = InstanceParameters[r0.w].InstanceParams[3].z * r1.x;
  r6.xyzw = p_default_Material_024F04E4252657_DepthBufferTexture_texture.SampleLevel(p_default_Material_024F04E4252657_DepthBufferTexture_sampler_s, r1.zw, 0).xyzw;

  r6 = max(0, r6);

  r1.y = r6.x * DepthToW.x + DepthToW.y;
  r1.y = max(9.99999997e-07, r1.y);
  r1.y = 1 / r1.y;
  r0.xy = r1.zw * DepthToView.xy + DepthToView.zw;
  r6.xyzw = p_default_Material_024F041C225126_BackBufferTexture_texture.Sample(p_default_Material_024F041C225126_BackBufferTexture_sampler_s, r1.zw).xyzw;

  r6 = max(0, r6);

  r0.xyz = r1.yyy * r0.xyz;
  r0.x = dot(r0.xyz, r0.xyz);
  r2.w = sqrt(r0.x);
  r7.xyzw = -InstanceParameters[r0.w].InstanceParams[2].xxxx + r2.xyzw;
  r2.xyzw = InstanceParameters[r0.w].InstanceParams[1].xxxx + -r2.xyzw;
  r2.xyzw = saturate(InstanceParameters[r0.w].InstanceParams[1].yyyy * r2.xyzw);
  r2.xyzw = InstanceParameters[r0.w].InstanceParams[1].zzzz * r2.xyzw;
  r2.xyzw = sqrt(r2.xyzw);
  r7.xyzw = saturate(InstanceParameters[r0.w].InstanceParams[2].yyyy * r7.xyzw);
  r0.xyzw = InstanceParameters[r0.w].InstanceParams[2].zzzz * r7.xyzw;
  r0.xyzw = sqrt(r0.xyzw);
  r0.xyzw = r0.xyzw + -r2.xyzw;
  r1.xyzw = max(abs(r0.xyzw), r1.xxxx);
  r2.xyzw = cmp(float4(0, 0, 0, 0) < r0.xyzw);
  r0.xyzw = cmp(r0.xyzw < float4(0, 0, 0, 0));
  r0.xyzw = (int4)r0.xyzw + (int4)-r2.xyzw;
  r0.xyzw = (int4)r0.xyzw;
  r0.xyzw = r0.xyzw * r1.xyzw;
  r1.x = dot(r0.xyzw, float4(0.25, 0.25, 0.25, 0.25));
  r1.y = cmp(r1.x == 0.000000);
  r1.x = r1.x * 0.5 + 0.5;
  r0.xyzw = r1.yyyy ? float4(1, 1, 1, 1) : abs(r0.xyzw);
  r1.yzw = r4.xyz * r0.yyy;
  r1.yzw = r3.xyz * r0.xxx + r1.yzw;
  r1.yzw = r5.xyz * r0.zzz + r1.yzw;
  r1.yzw = r6.xyz * r0.www + r1.yzw;
  r0.x = dot(r0.xyzw, float4(1, 1, 1, 1));
  o0.xyz = r1.yzw / r0.xxx;
  r0.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r0.x].x * r1.x;

  return;
}
