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

cbuffer MaterialBuffer : register(b3) {
  float4 MaterialParams[32] : packoffset(c0);
}

cbuffer InstanceBuffer : register(b5) {
  struct
  {
    float4 InstanceParams[8];
    float4 ExtendedInstanceParams[16];
  }
  InstanceParameters[12] : packoffset(c0);
}

SamplerState p_default_Material_1376C724912777_0BF50A1C106154_Texture_sampler_s : register(s0);
SamplerState p_default_Setup_1966A6EC30019627_Texture_sampler_s : register(s1);
SamplerState p_default_Material_123DFEB42371716_193DEBA41903451_BackBufferTexture_sampler_s : register(s2);
SamplerState AttenuationSampler_sampler_s : register(s15);
Texture2D<float4> p_default_Material_1376C724912777_0BF50A1C106154_Texture_texture : register(t0);
Texture2D<float4> p_default_Setup_1966A6EC30019627_Texture_texture : register(t1);
Texture2D<float4> p_default_Material_123DFEB42371716_193DEBA41903451_BackBufferTexture_texture : register(t2);
Texture2D<float4> AttenuationSampler_texture : register(t15);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    float v2: SV_ClipDistance0,
    float4 v3: COLOR0,
    float4 v4: TEXCOORD0,
    float4 v5: TEXCOORD1,
    float4 v6: TEXCOORD2,
    float4 v7: TEXCOORD3,
    float4 v8: TEXCOORD4,
    float4 v9: TEXCOORD5,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = GlobalParams[2].xyz * float3(1, -1, 1);
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = rsqrt(r0.x);
  r0.y = -GlobalParams[2].y * r0.x;
  r0.xz = GlobalParams[2].xz * r0.xx;
  r1.xyz = GlobalParams[12].xyz * r0.yyy;
  r0.xyw = r0.xxx * GlobalParams[11].xyz + r1.xyz;
  r0.xyz = r0.zzz * GlobalParams[13].xyz + r0.xyw;
  r1.xyz = -__CameraPosition.xyz + v9.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r0.x = dot(r1.xyz, r0.xyz);
  r0.y = FogParams2.z;
  r0.x = AttenuationSampler_texture.SampleLevel(AttenuationSampler_sampler_s, r0.xy, 0).z;
  r0.yzw = GlobalParams[8].xyz + -FogColor.xyz;
  r0.xyz = r0.xxx * r0.yzw + FogColor.xyz;
  r0.w = dot(v6.xyz, v6.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v6.xyz * r0.www;
  r2.xyz = p_default_Setup_1966A6EC30019627_Texture_texture.Sample(p_default_Setup_1966A6EC30019627_Texture_sampler_s, v4.xy).xyw;
  r2.y = r2.y * r2.z;
  r2.xy = r2.xy * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = sqrt(r0.w);
  r1.w = dot(v7.xyz, v7.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = v7.xyz * r1.www;
  r3.xyz = r3.xyz * r2.xxx;
  r1.xyz = r0.www * r1.xyz + r3.xyz;
  r0.w = dot(v8.xyz, v8.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = v8.xyz * r0.www;
  r1.xyz = r2.yyy * r3.xyz + r1.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(r1.xyz, v5.xyw);
  r0.w = min(1, abs(r0.w));
  r0.w = log2(r0.w);
  r0.w = MaterialParams[1].w * r0.w;
  r0.w = exp2(r0.w);
  r0.w = MaterialParams[2].x * r0.w;
  r1.x = (int)v0.x * 24;
  r1.xyz = InstanceParameters[r1.x].InstanceParams[0].xxx * v3.xyz;
  r1.xyz = MaterialParams[0].www * r1.xyz;
  r1.w = max(1, r1.z);
  r2.z = max(r1.x, r1.y);
  r1.w = max(r2.z, r1.w);
  r1.w = 1 / r1.w;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = MaterialParams[0].xyz * r0.www + r1.xyz;
  r0.xyz = -r1.xyz + r0.xyz;
  r3.x = v9.w;
  r3.yw = FogParams2.zz;
  r0.w = AttenuationSampler_texture.SampleLevel(AttenuationSampler_sampler_s, r3.xy, 0).x;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = cmp(FogColor.w == 0.000000);
  r1.xyz = r0.www ? FogColor.xyz : GlobalParams[7].xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r3.z = v9.z * FogParams.y + FogParams2.y;
  r0.w = AttenuationSampler_texture.SampleLevel(AttenuationSampler_sampler_s, r3.zw, 0).y;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.xyz = GlobalParams[1].www * r0.xyz + float3(-0.5, -0.5, -0.5);
  r1.xyz = p_default_Material_1376C724912777_0BF50A1C106154_Texture_texture.Sample(p_default_Material_1376C724912777_0BF50A1C106154_Texture_sampler_s, v4.xy).xyz;
  r0.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.w = v3.w * r0.w;
  r1.x = MaterialParams[1].y * r0.w;
  r1.yz = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r1.xy = r1.xx * r2.xy + r1.yz;
  r1.xyz = p_default_Material_123DFEB42371716_193DEBA41903451_BackBufferTexture_texture.Sample(p_default_Material_123DFEB42371716_193DEBA41903451_BackBufferTexture_sampler_s, r1.xy).xyz;
  r2.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
  r2.xyz = float3(0.5, 0.5, 0.5) + -abs(r2.xyz);
  r2.xyz = MaterialParams[1].zzz * r2.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  o0.xyz = r2.xyz * r0.xyz + r1.xyz;
  r0.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r0.x].x * r0.w;
  return;
}
