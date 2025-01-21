// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 20 18:02:39 2025

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

cbuffer MaterialBuffer : register(b3) {
  float4 MaterialParams[32] : packoffset(c0);
}

SamplerState p_default_Material_13D6BBA46242444_13D6BC6C6308037_19B9FD0C15847118_Param_sampler_s : register(s0);
SamplerState p_default_Setup_06DF9D2414425988_0841CA9411124985_Texture_sampler_s : register(s2);
SamplerState p_default_Setup_06DF9DE414402175_0841CA9411124985_Param_sampler_s : register(s3);
SamplerState p_default_Setup_06D5923439643940_0D4E21D437461730_Texture_sampler_s : register(s4);
SamplerState p_default_Setup_06D5923439643940_0D4E2C5437397931_Texture_sampler_s : register(s5);
Texture2D<float4> p_default_Material_13D6BBA46242444_13D6BC6C6308037_19B9FD0C15847118_Param_texture : register(t0);
Texture2D<float4> p_default_Setup_06DF9D2414425988_0841CA9411124985_Texture_texture : register(t2);
Texture2D<float4> p_default_Setup_06DF9DE414402175_0841CA9411124985_Param_texture : register(t3);
Texture2D<float4> p_default_Setup_06D5923439643940_0D4E21D437461730_Texture_texture : register(t4);
Texture2D<float4> p_default_Setup_06D5923439643940_0D4E2C5437397931_Texture_texture : register(t5);

// 3Dmigoto declarations
#define cmp -

void main(
    uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    float4 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy * MaterialParams[5].zw + MaterialParams[4].xy;
  r0.xyzw = p_default_Setup_06DF9DE414402175_0841CA9411124985_Param_texture.Sample(p_default_Setup_06DF9DE414402175_0841CA9411124985_Param_sampler_s, r0.xy).xyzw;

  r0 = max(0, r0);

  r0.xyz = MaterialParams[3].xyz * r0.xyz;
  r1.xy = v2.wz * MaterialParams[5].xy + MaterialParams[4].zw;
  r1.xyzw = p_default_Setup_06D5923439643940_0D4E2C5437397931_Texture_texture.Sample(p_default_Setup_06D5923439643940_0D4E2C5437397931_Texture_sampler_s, r1.xy).xyzw;

  r1 = max(0, r1);

  r1.xyz = MaterialParams[0].xyz * r1.xyz;
  r0.xyz = r0.xyz * r1.xyz + -r1.xyz;
  r0.xyz = MaterialParams[3].www * r0.xyz + r1.xyz;
  r1.xy = v2.xy * MaterialParams[7].zw + MaterialParams[6].xy;
  r1.xyzw = p_default_Setup_06DF9D2414425988_0841CA9411124985_Texture_texture.Sample(p_default_Setup_06DF9D2414425988_0841CA9411124985_Texture_sampler_s, r1.xy).xyzw;

  r1 = max(0, r1);

  r1.xyz = MaterialParams[1].xyz * r1.xyz;
  r1.xyz = r1.xyz * r0.xyz + -r0.xyz;
  r0.xyz = MaterialParams[1].www * r1.xyz + r0.xyz;
  r1.xy = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r1.xyzw = p_default_Material_13D6BBA46242444_13D6BC6C6308037_19B9FD0C15847118_Param_texture.Sample(p_default_Material_13D6BBA46242444_13D6BC6C6308037_19B9FD0C15847118_Param_sampler_s, r1.xy).xyzw;

  r1 = max(0, r1);

  r1.xyzw = GlobalParams[10].wwww * r1.xyzw;
  r0.w = r1.w * r1.w + r1.w;
  r0.w = 0.5 * r0.w;
  r2.xyz = r1.xyz * r0.www;
  r0.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.w = max(9.99999975e-06, r0.w);
  r2.xyz = r2.xyz / r0.www;
  r3.xy = v2.wz * MaterialParams[7].xy + MaterialParams[6].zw;
  r3.xyzw = p_default_Setup_06D5923439643940_0D4E21D437461730_Texture_texture.Sample(p_default_Setup_06D5923439643940_0D4E21D437461730_Texture_sampler_s, r3.xy).xyzw;

  r3 = max(0, r3);

  r3.xyz = MaterialParams[2].xyz * r3.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  r0.xyz = GlobalParams[1].www * r0.xyz;
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  o0.xyz = r0.xyz;
  r0.x = saturate(r0.w * GlobalParams[3].w + GlobalParams[2].w);
  r0.y = max(r2.x, r2.y);
  r0.y = max(r0.y, r2.z);
  r0.y = MaterialParams[9].z * r0.y;
  r0.y = min(GlobalParams[7].w, r0.y);
  r0.y = MaterialParams[9].y + r0.y;
  o0.w = r0.y + r0.x;

  return;
}
