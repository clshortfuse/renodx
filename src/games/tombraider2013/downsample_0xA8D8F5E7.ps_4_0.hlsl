// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 20 18:03:19 2025

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

SamplerState p_default_Material_025067CC15467187_BackBufferTexture_sampler_s : register(s0);
SamplerState p_default_Material_02508EC46427113_Param_sampler_s : register(s1);
Texture2D<float4> p_default_Material_025067CC15467187_BackBufferTexture_texture : register(t0);
Texture2D<float4> p_default_Material_02508EC46427113_Param_texture : register(t1);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.z = (int)v0.x * 24;
  r1.xy = InstanceParameters[r0.z].InstanceParams[3].xy * float2(0.5, 0.5) + r0.xy;
  r1.xy = InstanceParameters[r0.z].InstanceParams[1].xy + -r1.xy;
  r1.z = InstanceParameters[r0.z].InstanceParams[3].z * r1.y;
  r0.w = dot(r1.xz, r1.xz);
  r0.w = sqrt(r0.w);
  r0.w = -InstanceParameters[r0.z].InstanceParams[1].z + r0.w;
  r0.w = saturate(-r0.w * InstanceParameters[r0.z].InstanceParams[1].w + 1);
  r1.x = InstanceParameters[r0.z].InstanceParams[2].x + -InstanceParameters[r0.z].InstanceParams[2].y;
  r0.w = r0.w * r1.x + InstanceParameters[r0.z].InstanceParams[2].y;
  r1.xy = InstanceParameters[r0.z].InstanceParams[0].xy + r0.xy;
  r2.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r1.xy).xyzw;

  r2 = max(0, r2);  // fix float

  r1.xyzw = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r1.xy).xyzw;

  r1 = max(0, r1);

  r3.x = max(r2.y, r2.z);
  r3.x = max(r3.x, r2.x);
  r4.xy = InstanceParameters[r0.z].InstanceParams[0].zy + r0.xy;
  r5.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r4.xy).xyzw;

  r5 = max(0, r5);  // fix float

  r4.xyzw = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r4.xy).xyzw;

  r4 = max(0, r4);

  r1.y = r4.x;
  r4.x = max(r5.y, r5.z);
  r3.y = max(r5.x, r4.x);
  r4.xy = InstanceParameters[r0.z].InstanceParams[0].xw + r0.xy;
  r0.xy = InstanceParameters[r0.z].InstanceParams[0].zw + r0.xy;
  r6.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r4.xy).xyzw;

  r6 = max(0, r6);  // fix float

  r4.xyzw = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r4.xy).xyzw;

  r4 = max(0, r4);

  r1.z = r4.x;
  r4.x = max(r6.y, r6.z);
  r3.z = max(r6.x, r4.x);
  r4.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r0.xy).xyzw;

  r4 = max(0, r4);  // fix float

  r7.xyzw = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r0.xy).xyzw;

  r7 = max(0, r7);

  r1.w = r7.x;
  r1.xyzw = float4(-65500, -65500, -65500, -65500) + r1.xyzw;
  r1.xyzw = saturate(float4(500, 500, 500, 500) * r1.xyzw);
  r0.x = max(r4.y, r4.z);
  r3.w = max(r4.x, r0.x);
  r7.x = r2.w;
  r7.y = r5.w;
  r7.z = r6.w;
  r7.w = r4.w;
  r7.xyzw = r7.xyzw * r3.xyzw;
  r8.xyzw = log2(r3.xyzw);
  r3.xyzw = max(float4(9.99999975e-05, 9.99999975e-05, 9.99999975e-05, 9.99999975e-05), r3.xyzw);
  r8.xyzw = InstanceParameters[r0.z].InstanceParams[2].zzzz * r8.xyzw;

  r8.xyzw = exp2(r8.xyzw);
  r0.xyzw = r8.xyzw * r0.wwww + -r7.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw + r7.xyzw;
  r1.x = dot(r1.xyzw, float4(0.25, 0.25, 0.25, 0.25));
  r3.xyzw = r0.xyzw / r3.xyzw;
  r1.yzw = r5.xyz * r3.yyy;
  r1.yzw = r2.xyz * r3.xxx + r1.yzw;
  r1.yzw = r6.xyz * r3.zzz + r1.yzw;
  r1.yzw = r4.xyz * r3.www + r1.yzw;
  r2.xyz = float3(0.25, 0.25, 0.25) * r1.yzw;
  r2.w = max(r0.z, r0.w);
  r2.w = max(r2.w, r0.y);
  r2.w = max(r2.w, r0.x);
  r0.x = dot(r0.xyzw, float4(0.25, 0.25, 0.25, 0.25));
  r0.x = max(9.99999975e-05, r0.x);
  r0.yzw = r2.xyz * r2.www;
  r0.xyz = r0.yzw / r0.xxx;
  r1.yzw = r1.yzw * float3(0.25, 0.25, 0.25) + -r0.xyz;
  o0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r0.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r0.x].x * r1.x;

  return;
}
