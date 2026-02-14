// ---- Created with 3Dmigoto v1.3.16 on Thu Feb  6 16:55:15 2025

struct DecalData
{
    float4x3 worldMtx;             // Offset:    0
    float4x3 invWorldMtx;          // Offset:   48
    float4x3 rot;                  // Offset:   96
    float4x4 colormatrix;          // Offset:  144
    float alpha;                   // Offset:  208
    float cliffAlpha;              // Offset:  212
    float useMask_Box;             // Offset:  216
    float useMask_Sphere;          // Offset:  220
    float useOverrideRoughtness;   // Offset:  224
    float Roughtness;              // Offset:  228
    float useWet;                  // Offset:  232
    float uvfluffy;                // Offset:  236
    float AlbedoIntensity;         // Offset:  240
    float AffectAngleAlpha;        // Offset:  244
    float parallaxStepScale;       // Offset:  248
    float stepCount;               // Offset:  252
    float2 uvScroll;               // Offset:  256
    float2 uvTiling;               // Offset:  264
    float4 uvClip;                 // Offset:  272
    float4 Mask;                   // Offset:  288
    float2 mask_tiling;            // Offset:  304
    float CutOcclusion;            // Offset:  312
    float directivityFlag;         // Offset:  316
    float3 directivityCameraVec;   // Offset:  320
    float directivityRate;         // Offset:  332
    float directivityReverse;      // Offset:  336
    float directivityAlphaReverse; // Offset:  340
    float uselengthFade;           // Offset:  344
    float lengthFadeReverse;       // Offset:  348
    float lengthFadeAlphaDistance; // Offset:  352
    float lengthFadeMin;           // Offset:  356
    float lengthFadeMax;           // Offset:  360
    float lengthFadePower;         // Offset:  364
};

cbuffer SceneBuffer : register(b0)
{
  float4x4 g_View : packoffset(c0);
  float4x4 g_Proj : packoffset(c4);
  float4x4 g_ViewProjection : packoffset(c8);
  float4x4 g_ViewInverseMatrix : packoffset(c12);
  float4x4 g_PrevView : packoffset(c16);
  float4x4 g_PrevProj : packoffset(c20);
  float4x4 g_PrevViewProjection : packoffset(c24);
  float4x4 g_PrevViewInverseMatrix : packoffset(c28);
  float4 g_ProjectionOffset : packoffset(c32);
  int g_FrameCount[4] : packoffset(c33);
}

cbuffer HPixel_Buffer : register(b12)
{
  float4 g_TargetUvParam : packoffset(c0);
}

cbuffer CamParam_HPixel_Buffer : register(b13)
{
  float4 g_CameraParam : packoffset(c0);
  float4 g_CameraVec : packoffset(c1);
  float4 g_CameraParam2 : packoffset(c2);
}

SamplerState g_AlbedTextureSampler_s : register(s4);
SamplerState g_MaskTextureSampler_s : register(s8);
StructuredBuffer<DecalData> instanceData : register(t0);
Texture2D<float4> g_AlbedTexture : register(t4);
Texture2D<float4> g_MaskTexture : register(t8);
Texture2D<float4> g_GeometryBuffer01 : register(t21);
Texture2D<float4> g_ZBuffer : register(t24);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  nointerpolation uint v3 : INSTANCE_ID0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = instanceData[v3.x].invWorldMtx._m00;
  r0.y = instanceData[v3.x].invWorldMtx._m10;
  r0.z = instanceData[v3.x].invWorldMtx._m20;
  r0.w = instanceData[v3.x].invWorldMtx._m30;
  r1.x = instanceData[v3.x].invWorldMtx._m01;
  r1.y = instanceData[v3.x].invWorldMtx._m11;
  r1.z = instanceData[v3.x].invWorldMtx._m21;
  r1.w = instanceData[v3.x].invWorldMtx._m31;
  r2.x = instanceData[v3.x].invWorldMtx._m02;
  r2.y = instanceData[v3.x].invWorldMtx._m12;
  r2.z = instanceData[v3.x].invWorldMtx._m22;
  r2.w = instanceData[v3.x].invWorldMtx._m32;
  r3.x = instanceData[v3.x].rot._m20;
  r3.y = instanceData[v3.x].rot._m21;
  r3.z = instanceData[v3.x].rot._m22;
  r4.x = instanceData[v3.x].alpha;
  r4.y = instanceData[v3.x].cliffAlpha;
  r4.z = instanceData[v3.x].useMask_Box;
  r4.w = instanceData[v3.x].useMask_Sphere;
  r5.x = instanceData[v3.x].useWet;
  r5.y = instanceData[v3.x].uvfluffy;
  r5.z = instanceData[v3.x].AlbedoIntensity;
  r5.w = instanceData[v3.x].AffectAngleAlpha;
  r6.x = instanceData[v3.x].uvClip.x;
  r6.y = instanceData[v3.x].uvClip.y;
  r6.z = instanceData[v3.x].uvClip.z;
  r6.w = instanceData[v3.x].uvClip.w;
  r7.x = instanceData[v3.x].Mask.x;
  r7.y = instanceData[v3.x].Mask.y;
  r7.z = instanceData[v3.x].Mask.z;
  r7.w = instanceData[v3.x].Mask.w;
  r8.x = instanceData[v3.x].mask_tiling.x;
  r8.y = instanceData[v3.x].mask_tiling.y;
  r8.z = instanceData[v3.x].CutOcclusion;
  r8.w = instanceData[v3.x].directivityFlag;
  r9.x = instanceData[v3.x].directivityCameraVec.x;
  r9.y = instanceData[v3.x].directivityCameraVec.y;
  r9.z = instanceData[v3.x].directivityCameraVec.z;
  r9.w = instanceData[v3.x].directivityRate;
  r10.x = instanceData[v3.x].directivityReverse;
  r10.y = instanceData[v3.x].directivityAlphaReverse;
  r10.z = instanceData[v3.x].uselengthFade;
  r10.w = instanceData[v3.x].lengthFadeReverse;
  r11.x = instanceData[v3.x].lengthFadeAlphaDistance;
  r11.y = instanceData[v3.x].lengthFadeMin;
  r11.z = instanceData[v3.x].lengthFadeMax;
  r11.w = instanceData[v3.x].lengthFadePower;
  r12.xy = v0.xy / g_TargetUvParam.zw;
  r13.xy = (int2)v0.xy;
  r13.zw = float2(0,0);
  r3.w = g_GeometryBuffer01.Load(r13.xyw).z;
  r12.z = g_ZBuffer.Load(r13.xyz).x;
  r13.x = 1 / g_Proj._m00;
  r13.y = 1 / g_Proj._m11;
  r12.z = r12.z * g_CameraParam.y + g_CameraParam.x;
  r12.xy = r12.xy * float2(2,-2) + float2(-1,1);
  r12.xy = r12.xy * r12.zz;
  r13.xy = r12.xy * r13.xy;
  r13.z = -r12.z;
  r13.w = 1;
  r12.x = dot(r13.xyzw, g_ViewInverseMatrix._m00_m10_m20_m30);
  r12.y = dot(r13.xyzw, g_ViewInverseMatrix._m01_m11_m21_m31);
  r12.z = dot(r13.xyzw, g_ViewInverseMatrix._m02_m12_m22_m32);
  r12.w = 1;
  r0.x = dot(r12.xyzw, r0.xyzw);
  r0.y = dot(r12.xyzw, r1.xyzw);
  r0.z = dot(r12.xyzw, r2.xyzw);
  r0.w = -r0.x + r6.y;
  r0.w = -0.5 + r0.w;
  r1.xyz = float3(0.5,0.5,0.5) + r0.xxy;
  r1.w = 0.5 + -r0.y;
  r1.xw = r1.xw + -r6.xz;
  r2.x = r0.y + r6.w;
  r2.x = -0.5 + r2.x;
  r1.w = min(r2.x, r1.w);
  r1.x = min(r1.x, r1.w);
  r0.w = min(r1.x, r0.w);
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r2.xyz = float3(0.5,0.5,0.5) + -abs(r0.xyz);
  r6.xyz = cmp(r2.xyz < float3(0,0,0));
  r0.w = (int)r6.y | (int)r6.x;
  r0.w = (int)r6.z | (int)r0.w;
  if (r0.w != 0) discard;
  r0.w = r1.z * r8.y;
  r1.xw = float2(25.1327419,25.1327419) * r1.yz;
  r1.xw = sin(r1.xw);
  r1.xw = g_CameraVec.ww + r1.xw;
  r1.xw = sin(r1.xw);
  r1.xw = r1.xw * r5.yy;
  r6.x = r1.y * r8.x + r1.w;
  r6.y = r1.x * 0.5 + r0.w;
  r6.xyzw = g_MaskTexture.Sample(g_MaskTextureSampler_s, r6.xy).xyzw;
  r6.xyzw = r6.xyzw * r7.xyzw;
  r0.w = dot(r6.xyzw, r6.xyzw);
  r0.w = sqrt(r0.w);
  r0.w = min(1, r0.w);
  r1.x = r4.x * r0.w;
  r0.w = r4.x * r0.w + -0.00999999978;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r4.xz = cmp(float2(0.5,0.5) < r4.zw);
  r2.xyz = r2.xyz + r2.xyz;
  r0.w = min(r2.x, r2.y);
  r0.w = min(r0.w, r2.z);
  r0.w = max(0, r0.w);
  r0.w = r0.w * -2 + 1;
  r0.w = 1 + -r0.w;
  r0.w = min(1, r0.w);
  r0.w = r1.x * r0.w;
  r0.w = r4.x ? r0.w : r1.x;
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = sqrt(r0.x);
  r0.x = 0.5 + -r0.x;
  r0.x = r0.x + r0.x;
  r0.x = max(0, r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.x * r0.x;
  r0.x = -r0.x * r0.x + 1;
  r0.x = r0.w * r0.x;
  r0.x = r4.z ? r0.x : r0.w;
  r0.yz = cmp(float2(0,0) != r8.zw);
  r0.w = r0.x * r3.w;
  r0.x = r0.y ? r0.w : r0.x;
  r2.xyz = g_CameraVec.xyz + -r12.xyz;
  r4.xzw = cmp(float3(0,0,0) != r10.xyw);
  r0.y = dot(r9.xyz, r2.xyz);
  r0.w = dot(r2.xyz, r2.xyz);
  r1.x = rsqrt(r0.w);
  r2.xyz = r2.xyz * r1.xxx;
  r1.x = dot(r9.xyz, r2.xyz);
  r0.y = saturate(r4.x ? abs(r0.y) : r1.x);
  r0.y = log2(r0.y);
  r0.y = r9.w * r0.y;
  r0.y = exp2(r0.y);
  r1.x = 1 + -r0.y;
  r0.y = r4.z ? r1.x : r0.y;
  r0.y = r0.x * r0.y;
  r0.x = r0.z ? r0.y : r0.x;
  r0.y = cmp(0.5 < r10.z);
  r0.z = sqrt(r0.w);
  r0.z = r0.z + -r11.x;
  r0.w = 1 / r11.x;
  r0.z = saturate(r0.z * r0.w);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.z = max(0.00100000005, r0.z);
  r0.z = log2(r0.z);
  r0.z = r11.w * r0.z;
  r0.z = exp2(r0.z);
  r0.w = 1 + -r0.z;
  r0.z = r4.w ? r0.w : r0.z;
  r0.z = max(r0.z, r11.y);
  r0.z = min(r0.z, r11.z);
  r0.z = r0.x * r0.z;
  r0.x = r0.y ? r0.z : r0.x;
  r0.yzw = ddx_fine(r12.yzx);
  r2.xyz = ddy_fine(r12.zxy);
  r4.xzw = r2.xyz * r0.yzw;
  r0.yzw = r2.zxy * r0.zwy + -r4.xzw;
  r1.x = dot(r0.yzw, r0.yzw);
  r1.x = rsqrt(r1.x);
  r0.yzw = r1.xxx * r0.yzw;
  r1.x = cmp(0 != r5.w);
  r0.y = saturate(dot(r3.xyz, r0.yzw));
  r0.y = max(0.00999999978, r0.y);
  r0.y = log2(r0.y);
  r0.y = r4.y * r0.y;
  r0.y = exp2(r0.y);
  r0.y = r0.x * r0.y;
  r0.x = r1.x ? r0.y : r0.x;
  r0.y = cmp(0.5 < r5.x);
  if (r0.y != 0) {
    r0.y = r0.x * r5.z;
    r2.xyz = float3(0,0,0);
  } else {
    r3.x = instanceData[v3.x].colormatrix._m00;
    r3.y = instanceData[v3.x].colormatrix._m10;
    r3.z = instanceData[v3.x].colormatrix._m20;
    r3.w = instanceData[v3.x].colormatrix._m30;
    r4.x = instanceData[v3.x].colormatrix._m01;
    r4.y = instanceData[v3.x].colormatrix._m11;
    r4.z = instanceData[v3.x].colormatrix._m21;
    r4.w = instanceData[v3.x].colormatrix._m31;
    r6.x = instanceData[v3.x].colormatrix._m02;
    r6.y = instanceData[v3.x].colormatrix._m12;
    r6.z = instanceData[v3.x].colormatrix._m22;
    r6.w = instanceData[v3.x].colormatrix._m32;
    r7.x = instanceData[v3.x].uvScroll.x;
    r7.y = instanceData[v3.x].uvScroll.y;
    r7.z = instanceData[v3.x].uvTiling.x;
    r7.w = instanceData[v3.x].uvTiling.y;
    r0.zw = r7.xy + r1.yz;
    r0.zw = r0.zw * r7.zw;
    r1.xyzw = g_AlbedTexture.Sample(g_AlbedTextureSampler_s, r0.zw).xyzw;
    r5.xyz = r1.xyz * r5.zzz;
    r5.w = 1;
    r2.x = dot(r5.xyzw, r3.xyzw);
    r2.y = dot(r5.xyzw, r4.xyzw);
    r2.z = dot(r5.xyzw, r6.xyzw);
    r0.y = r1.w * r0.x;
  }
  r2.w = r0.x * r0.y;
  r0.x = r0.x * r0.y + -9.99999975e-05;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  o0.xyzw = r2.xyzw;

  o0 = max(0, o0); // gets broken due to upgrades, this fixes at least one spot
  
  return;
}