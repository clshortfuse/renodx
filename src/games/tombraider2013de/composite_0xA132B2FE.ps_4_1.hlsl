// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 20 16:57:51 2025

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

cbuffer LightBuffer : register(b4) {
  struct
  {
    float4 position;
    float3 direction;
    float4 attParams;
    float4 spotParams;
    float4 diffuseColor;
    float4 shadowFadeParams;
  }
  ShadowLights[6] : packoffset(c0);

  struct
  {
    float4 position;
    float3 direction;
    float4 attParams;
    float4 spotParams;
    float4 diffuseColor;
    float4 shadowFadeParams;
  }
  NonShadowLights[6] : packoffset(c36);

  struct
  {
    float4 position;
    float3 direction;
    float4 attParams;
    float4 spotParams;
    float4 diffuseColor;
    float4 shadowFadeParams;
  }
SunLight:
  packoffset(c72);

  row_major float4x4 WorldToShadowMap[7] : packoffset(c78);
  row_major float3x4 WorldToModulationMapSpot[6] : packoffset(c106);
  row_major float2x4 WorldToModulationMapSun : packoffset(c124);
  bool ShadowLightEnabled[6] : packoffset(c126);
  bool NonShadowLightEnabled[6] : packoffset(c132);
  bool SunLightEnabled : packoffset(c138);
}

cbuffer InstanceBuffer : register(b5) {
  struct
  {
    float4 InstanceParams[8];
    float4 ExtendedInstanceParams[16];
  }
  InstanceParameters[12] : packoffset(c0);
}

SamplerState p_default_Material_188712BC9527187_19B9FD0C15847118_Param_sampler_s : register(s0);
SamplerState p_default_Material_7DA9702493319762_Param_sampler_s : register(s2);
SamplerState p_default_Material_22496F1420459822_NormalBufferTexture_sampler_s : register(s3);
SamplerState p_default_Material_19F263E43572429_Param_sampler_s : register(s5);
SamplerState p_default_Material_19E755BC3462756_Param_sampler_s : register(s6);
SamplerState p_default_Material_301BF44C5535302_Param_sampler_s : register(s7);
SamplerState p_default_Material_224ADB9420947187_DepthBufferTexture_sampler_s : register(s8);
SamplerState p_default_Material_1F2F6D3C2121562_1844FCBC2988656_Texture_sampler_s : register(s9);
SamplerState AttenuationSampler_sampler_s : register(s15);
Texture2D<float4> p_default_Material_188712BC9527187_19B9FD0C15847118_Param_texture : register(t0);
Texture2D<float4> p_default_Material_7DA9702493319762_Param_texture : register(t2);
Texture2D<float4> p_default_Material_22496F1420459822_NormalBufferTexture_texture : register(t3);
Texture2D<float4> p_default_Material_19F263E43572429_Param_texture : register(t5);
Texture2D<float4> p_default_Material_19E755BC3462756_Param_texture : register(t6);
Texture2D<float4> p_default_Material_301BF44C5535302_Param_texture : register(t7);
Texture2D<float4> p_default_Material_224ADB9420947187_DepthBufferTexture_texture : register(t8);
TextureCube<float4> p_default_Material_1F2F6D3C2121562_1844FCBC2988656_Texture_texture : register(t9);
Texture2D<float4> AttenuationSampler_texture : register(t15);

// 3Dmigoto declarations
#define cmp -

void main(
    nointerpolation uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    float v2: SV_ClipDistance0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)v0.x * 24;
  r0.yz = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.w = p_default_Material_224ADB9420947187_DepthBufferTexture_texture.Sample(p_default_Material_224ADB9420947187_DepthBufferTexture_sampler_s, r0.yz).x;

  r0.w = max(0, r0.w);

  r1.xy = r0.ww * DepthToW.xz + DepthToW.yw;
  r0.w = max(9.99999997e-07, r1.x);
  r2.z = 1 / r0.w;
  r1.xzw = p_default_Material_188712BC9527187_19B9FD0C15847118_Param_texture.Sample(p_default_Material_188712BC9527187_19B9FD0C15847118_Param_sampler_s, r0.yz).xyz;

  r1.xzw = max(0, r1.xzw);

  r1.xzw = GlobalParams[10].www * r1.xzw;
  r3.xyz = p_default_Material_22496F1420459822_NormalBufferTexture_texture.Sample(p_default_Material_22496F1420459822_NormalBufferTexture_sampler_s, r0.yz).xyz;

  r3.xyz = max(0, r3.xyz);

  r4.xyz = GlobalParams[12].xyz * r3.yyy;
  r3.xyw = r3.xxx * GlobalParams[11].xyz + r4.xyz;
  r3.xyz = r3.zzz * GlobalParams[13].xyz + r3.xyw;
  r2.xy = r2.zz * r0.yz;
  r2.w = 1;
  r4.x = dot(DepthToWorld._m00_m01_m02_m03, r2.xyzw);
  r4.y = dot(DepthToWorld._m10_m11_m12_m13, r2.xyzw);
  r4.z = dot(DepthToWorld._m20_m21_m22_m23, r2.xyzw);
  r2.xy = r0.yz * float2(2, 2) + float2(-1, -1);
  r5.xyzw = InverseProjection._m10_m11_m12_m13 * -r2.yyyy;
  r5.xyzw = r2.xxxx * InverseProjection._m00_m01_m02_m03 + r5.xyzw;
  r5.xyzw = r1.yyyy * InverseProjection._m20_m21_m22_m23 + r5.xyzw;
  r5.xyzw = InverseProjection._m30_m31_m32_m33 + r5.xyzw;
  r2.xyw = r5.xyz / r5.www;
  r0.w = dot(r2.xyw, r2.xyw);
  r0.w = rsqrt(r0.w);
  r5.xyz = r2.xyw * r0.www;
  r6.xyz = GlobalParams[12].xyz * r5.yyy;
  r5.xyw = r5.xxx * GlobalParams[11].xyz + r6.xyz;
  r5.xyz = r5.zzz * GlobalParams[13].xyz + r5.xyw;
  r4.xyz = r3.xyz * float3(7.5, 7.5, 7.5) + r4.xyz;
  r2.xyw = InstanceParameters[r0.x].InstanceParams[1].xyz + -r2.xyw;
  r0.w = dot(r2.xyw, r2.xyw);
  r0.w = sqrt(r0.w);
  r2.x = saturate(InstanceParameters[r0.x].InstanceParams[0].y * r0.w);
  r2.y = InstanceParameters[r0.x].InstanceParams[0].x;
  r0.w = AttenuationSampler_texture.SampleLevel(AttenuationSampler_sampler_s, r2.xy, 0).z;

  r0.w = max(0, r0.w);

  r2.xyw = ShadowLights[0].diffuseColor.xyz * r0.www;
  r2.xyw = InstanceParameters[r0.x].InstanceParams[2].www * r2.xyw;
  r0.w = InstanceParameters[r0.x].InstanceParams[1].w * r0.w;
  r2.xyw = InstanceParameters[r0.x].InstanceParams[7].www * r2.xyw;
  r2.xyw = r2.xyw * r0.www;
  r0.w = TimeVector.x * 36;
  r6.x = floor(r0.w);
  r4.w = -r4.y;
  r6.zw = InstanceParameters[r0.x].ExtendedInstanceParams[2].yy * r4.xw;
  r6.zw = float2(1, 0.027777778) * abs(r6.zw);
  r6.zw = frac(r6.zw);
  r0.w = 0.166666672 * r6.x;
  r6.y = floor(r0.w);
  r6.xy = r6.zw * float2(1, 36) + r6.xy;
  r6.xy = float2(0.166666672, 0.166666672) * r6.xy;
  r6.xyz = p_default_Material_19F263E43572429_Param_texture.Sample(p_default_Material_19F263E43572429_Param_sampler_s, r6.xy).xyw;

  r6.xyz = max(0, r6.xyz);

  r6.y = r6.y * r6.z;
  r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r6.xy, r6.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r6.z = sqrt(r0.w);
  r4.xyzw = float4(1, -1, 1, -1) * r4.yzxz;
  r4.xyzw = InstanceParameters[r0.x].ExtendedInstanceParams[2].xxxx * r4.xyzw;
  r4.xyzw = TimeVector.xxxx * InstanceParameters[r0.x].ExtendedInstanceParams[1].zwzw + r4.zwxy;
  r7.xyw = p_default_Material_19E755BC3462756_Param_texture.Sample(p_default_Material_19E755BC3462756_Param_sampler_s, r4.xy).xyw;

  r7.xyw = max(0, r7.xyw);

  r7.z = r7.y * r7.w;
  r7.xz = r7.xz * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r7.xz, r7.xz);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r7.y = sqrt(r0.w);
  r4.xyw = p_default_Material_19E755BC3462756_Param_texture.Sample(p_default_Material_19E755BC3462756_Param_sampler_s, r4.zw).yxw;

  r4.xyw = max(0, r4.xyw);

  r4.z = r4.x * r4.w;
  r4.yz = r4.yz * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r4.yz, r4.yz);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r4.x = sqrt(r0.w);
  r0.w = cmp(0 < r3.z);
  r1.y = cmp(r3.z < 0);
  r0.w = (int)-r0.w + (int)r1.y;
  r0.w = (int)r0.w;
  r1.y = r3.z * r3.z;
  r0.w = r1.y * r0.w;
  r7.xyz = r7.xyz * r3.yyy;
  r4.xyz = r4.xyz * r3.xxx + r7.xyz;
  r4.xyz = r6.xyz * r0.www + r4.xyz;
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = rsqrt(r0.w);
  r6.xyz = r4.xyz * r0.www;
  r1.y = saturate(dot(r6.xyz, r3.xyz));
  r1.y = 1 + -r1.y;
  r1.xzw = r2.xyw * r1.xzw;
  r1.xzw = r1.xzw + r1.xzw;
  r2.xyw = r4.xyz * r0.www + -r3.xyz;
  r2.xyw = r2.xyw * float3(0.25, 0.25, 0.25) + r3.xyz;
  r3.xy = View._m10_m11 * r2.yy;
  r2.xy = r2.xx * View._m00_m01 + r3.xy;
  r3.xy = r2.ww * View._m20_m21 + r2.xy;
  r3.z = -r3.y;
  r0.w = dot(r3.xz, r3.xz);
  r2.xyw = p_default_Material_7DA9702493319762_Param_texture.Sample(p_default_Material_7DA9702493319762_Param_sampler_s, r0.yz).xyz;

  r2.xyw = max(0, r2.xyw);

  r0.w = saturate(-r0.w * 6 + 6);
  r0.w = -1 + r0.w;
  r3.zw = r0.yz;
  r4.xyzw = float4(0, 0, 0, 0);
  r5.w = 1;
  r6.w = 0;
  while (true) {
    r7.x = cmp((int)r6.w >= 5);
    if (r7.x != 0) break;
    r3.zw = r3.xy * float2(0.100000001, -0.100000001) + r3.zw;
    r7.x = r4.w + r4.w;
    r7.x = max(1, r7.x);
    r7.x = r5.w / r7.x;
    r7.y = p_default_Material_301BF44C5535302_Param_texture.Sample(p_default_Material_301BF44C5535302_Param_sampler_s, r3.zw).x;

    r7.y = max(0, r7.y);

    r7.y = r7.y * DepthToW.x + DepthToW.y;
    r7.y = max(9.99999997e-07, r7.y);
    r7.y = 1 / r7.y;
    r7.y = r7.y + -r2.z;
    r7.z = 0.00400000019 * abs(r7.y);
    r7.z = min(1, r7.z);
    r7.z = r7.z * r7.z;
    r7.y = saturate(r7.y);
    r7.y = r7.y * r0.w + 1;
    r7.y = -r7.z * r7.y + 1;
    r7.x = r7.x * r7.y;
    r7.yzw = p_default_Material_7DA9702493319762_Param_texture.Sample(p_default_Material_7DA9702493319762_Param_sampler_s, r3.zw).xyz;

    r7.yzw = max(0, r7.yzw);

    r8.xyz = r7.yzw * r7.xxx;
    r7.yzw = -r7.yzw * r7.xxx + r2.xyw;
    r7.z = max(abs(r7.z), abs(r7.w));
    r7.y = max(abs(r7.y), r7.z);
    r7.y = 3 * r7.y;
    r8.xyz = r8.xyz * r7.yyy;
    r7.y = max(0.100000001, r7.y);
    r8.w = r7.x * r7.y;
    r4.xyzw = r4.xyzw + r8.xyzw;
    r5.w = -0.100000001 + r5.w;
    r6.w = (int)r6.w + 1;
  }
  r0.y = max(1, r4.w);
  r2.xyzw = r4.xyzw / r0.yyyy;
  r0.y = 1 + -r2.w;
  r0.z = dot(-r5.xyz, r6.xyz);
  r0.z = r0.z + r0.z;
  r3.xyz = r6.xyz * -r0.zzz + -r5.xyz;
  r3.xyz = p_default_Material_1F2F6D3C2121562_1844FCBC2988656_Texture_texture.Sample(p_default_Material_1F2F6D3C2121562_1844FCBC2988656_Texture_sampler_s, r3.xyz).xyz;

  r3.xyz = max(0, r3.xyz);

  r0.yzw = r3.xyz * r0.yyy + r2.xyz;
  r0.yzw = InstanceParameters[r0.x].ExtendedInstanceParams[7].yyy * r0.yzw;
  r2.x = cmp(InstanceParameters[r0.x].ExtendedInstanceParams[7].x < 0.5);
  r0.yzw = r2.xxx ? r3.xyz : r0.yzw;
  r0.xyz = InstanceParameters[r0.x].ExtendedInstanceParams[2].www * r1.yyy + r0.yzw;
  r0.xyz = r0.xyz * r1.xzw;
  r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.xyz = GlobalParams[1].www * r0.xyz;
  r1.x = max(r0.x, r0.y);
  r1.x = max(r1.x, r0.z);
  r1.x = saturate(r1.x * GlobalParams[3].w + GlobalParams[2].w);
  r0.w = r1.x + r0.w;
  r1.x = v0.x;
  o0.w = __InstancedMaterialOpacity[r1.x].x * r0.w;
  o0.xyz = r0.xyz;
  return;
}
