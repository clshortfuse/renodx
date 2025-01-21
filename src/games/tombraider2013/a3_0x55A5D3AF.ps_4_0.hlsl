// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 20 18:02:49 2025

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

SamplerState p_default_Material_2A1E440C8286025_cp0_BackBufferTexture_sampler_s : register(s0);
Texture2D<float4> p_default_Material_2A1E440C8286025_cp0_BackBufferTexture_texture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    uint4 v0: PSIZE0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { -1.500000, -1.500000, 0, 0 },
                         { -1.500000, -0.500000, 0, 0 },
                         { -1.500000, 0.500000, 0, 0 },
                         { -1.500000, 1.500000, 0, 0 },
                         { -0.500000, -1.500000, 0, 0 },
                         { -0.500000, -0.500000, 0, 0 },
                         { -0.500000, 0.500000, 0, 0 },
                         { -0.500000, 1.500000, 0, 0 },
                         { 0.500000, -1.500000, 0, 0 },
                         { 0.500000, -0.500000, 0, 0 },
                         { 0.500000, 0.500000, 0, 0 },
                         { 0.500000, 1.500000, 0, 0 },
                         { 1.500000, -1.500000, 0, 0 },
                         { 1.500000, -0.500000, 0, 0 },
                         { 1.500000, 0.500000, 0, 0 },
                         { 1.500000, 1.500000, 0, 0 } };
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * ScreenExtents.zw + ScreenExtents.xy;
  r0.xy = r0.xy * float2(0.400000006, 0.711111128) + float2(0.300000012, 0.144444451);
  r0.zw = float2(0, 0);
  while (true) {
    r1.x = cmp((int)r0.w >= 16);
    if (r1.x != 0) break;
    r1.xy = icb[r0.w + 0].xy * float2(0.00468750019, 0.00225694454) + r0.xy;
    r1.xyzw = p_default_Material_2A1E440C8286025_cp0_BackBufferTexture_texture.Sample(p_default_Material_2A1E440C8286025_cp0_BackBufferTexture_sampler_s, r1.xy).xyzw;
    
    r1 = max(0, r1);

    r1.x = dot(r1.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r1.x = 9.99999975e-05 + r1.x;
    r1.x = log2(r1.x);
    r0.z = r1.x * 0.693147182 + r0.z;
    r0.w = (int)r0.w + 1;
  }
  o0.xyz = float3(0.0625, 0.0625, 0.0625) * r0.zzz;
  o0.w = 1;
  return;
}
