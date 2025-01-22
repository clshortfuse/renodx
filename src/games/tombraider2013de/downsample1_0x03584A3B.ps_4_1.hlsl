// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 20 16:57:16 2025

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
    float v2: SV_ClipDistance0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;
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
  r1.xyzw = InstanceParameters[r0.z].InstanceParams[0].xyzy + r0.xyxy;
  r2.xyzw = InstanceParameters[r0.z].InstanceParams[0].xwzw + r0.xyxy;
  r3.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r1.xy).xyzw;

  r3 = max(0, r3);

  r0.x = max(r3.y, r3.z);
  r4.x = max(r3.x, r0.x);
  r5.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r1.zw).xyzw;

  r5 = max(0, r5);

  r0.x = max(r5.y, r5.z);
  r4.y = max(r5.x, r0.x);
  r6.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r2.xy).xyzw;

  r6 = max(0, r6);

  r0.x = max(r6.y, r6.z);
  r4.z = max(r6.x, r0.x);
  r7.xyzw = p_default_Material_025067CC15467187_BackBufferTexture_texture.Sample(p_default_Material_025067CC15467187_BackBufferTexture_sampler_s, r2.zw).xyzw;

  r7 = max(0, r7);

  r0.x = max(r7.y, r7.z);
  r4.w = max(r7.x, r0.x);
  r8.x = r3.w;
  r8.y = r5.w;
  r8.z = r6.w;
  r8.w = r7.w;
  r9.xyzw = r8.xyzw * r4.xyzw;
  r8.xyzw = cmp(float4(0, 0, 0, 0) >= r8.xyzw);
  r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
  r10.xyzw = log2(r4.xyzw);
  r4.xyzw = max(float4(9.99999975e-05, 9.99999975e-05, 9.99999975e-05, 9.99999975e-05), r4.xyzw);
  r10.xyzw = InstanceParameters[r0.z].InstanceParams[2].zzzz * r10.xyzw;
  r10.xyzw = exp2(r10.xyzw);
  r0.xyzw = r10.xyzw * r0.wwww + -r9.xyzw;
  r10.x = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r1.xy).x;
  r10.y = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r1.zw).x;
  r10.z = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r2.xy).x;
  r10.w = p_default_Material_02508EC46427113_Param_texture.Sample(p_default_Material_02508EC46427113_Param_sampler_s, r2.zw).x;

  r10 = max(0, r10);

  r1.xyzw = float4(-65500, -65500, -65500, -65500) + r10.xyzw;
  r1.xyzw = saturate(float4(500, 500, 500, 500) * r1.xyzw);
  r0.xyzw = r1.xyzw * r0.xyzw + r9.xyzw;
  r2.xyzw = r0.xyzw / r4.xyzw;
  r4.xyz = r5.xyz * r2.yyy;
  r3.xyz = r3.xyz * r2.xxx + r4.xyz;
  r2.xyz = r6.xyz * r2.zzz + r3.xyz;
  r2.xyz = r7.xyz * r2.www + r2.xyz;
  r3.xyz = float3(0.25, 0.25, 0.25) * r2.xyz;
  r2.w = max(r0.z, r0.w);
  r2.w = max(r2.w, r0.y);
  r2.w = max(r2.w, r0.x);
  r0.x = dot(r0.xyzw, float4(0.25, 0.25, 0.25, 0.25));
  r0.x = max(9.99999975e-05, r0.x);
  r0.yzw = r3.xyz * r2.www;
  r0.xyz = r0.yzw / r0.xxx;
  r2.xyz = r2.xyz * float3(0.25, 0.25, 0.25) + -r0.xyz;
  r0.w = dot(r1.xyzw, float4(0.25, 0.25, 0.25, 0.25));
  r1.xyzw = r8.xyzw * r1.xyzw;
  r1.x = dot(r1.xyzw, r1.xyzw);
  r1.x = cmp(0 != r1.x);
  r1.x = r1.x ? 0 : 1;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.xyz * r1.xxx;
  r0.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r0.x].x * r0.w;
  return;
}
