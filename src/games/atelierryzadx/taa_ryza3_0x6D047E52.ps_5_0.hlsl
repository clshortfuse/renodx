// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:43 2025

cbuffer _Globals : register(b0)
{
  row_major float4x4 g_cbMatCW : packoffset(c0);
  row_major float4x4 g_cbMatPrevWC : packoffset(c4);
  float screenWidth : packoffset(c8) = {1280};
  float screenHeight : packoffset(c8.y) = {720};
  float jitterScale : packoffset(c8.z) = {1};
  float4 g_cbTemporalAAParam : packoffset(c9);
}

SamplerState smplPrevScene_s : register(s0);
SamplerState smplScene_s : register(s1);
SamplerState smplDepth_s : register(s2);
SamplerState smplPrevDepth_s : register(s3);
Texture2D<float4> smplPrevScene_Tex : register(t0);
Texture2D<float4> smplScene_Tex : register(t1);
Texture2D<float4> smplDepth_Tex : register(t2);
Texture2D<float4> smplPrevDepth_Tex : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0.500000, 0, 0, 0},
                              { 0.333333, 0, 0, 0},
                              { 0.250000, 0, 0, 0},
                              { 0.666667, 0, 0, 0},
                              { 0.750000, 0, 0, 0},
                              { 0.111111, 0, 0, 0},
                              { 0.125000, 0, 0, 0},
                              { 0.444444, 0, 0, 0},
                              { 0.625000, 0, 0, 0},
                              { 0.777778, 0, 0, 0},
                              { 0.375000, 0, 0, 0},
                              { 0.222222, 0, 0, 0},
                              { 0.875000, 0, 0, 0},
                              { 0.555556, 0, 0, 0},
                              { 0.062500, 0, 0, 0},
                              { 0.888889, 0, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = smplDepth_Tex.Sample(smplDepth_s, v1.xy).x;
  r1.x = v1.x * 2 + -1;
  r1.yzw = v1.yxy * float3(-2,2,-2) + float3(1,-1,1);
  r2.xyzw = g_cbMatCW._m10_m11_m12_m13 * r1.yyyy;
  r2.xyzw = r1.xxxx * g_cbMatCW._m00_m01_m02_m03 + r2.xyzw;
  r2.xyzw = r0.wwww * g_cbMatCW._m20_m21_m22_m23 + r2.xyzw;
  r2.xyzw = g_cbMatCW._m30_m31_m32_m33 + r2.xyzw;
  r3.xyz = g_cbMatPrevWC._m10_m11_m13 * r2.yyy;
  r3.xyz = r2.xxx * g_cbMatPrevWC._m00_m01_m03 + r3.xyz;
  r2.xyz = r2.zzz * g_cbMatPrevWC._m20_m21_m23 + r3.xyz;
  r2.xyz = r2.www * g_cbMatPrevWC._m30_m31_m33 + r2.xyz;
  r1.xy = r2.xy / r2.zz;
  r1.xy = r1.zw + -r1.xy;
  r1.xy = float2(0.5,-0.5) * r1.xy;
  r1.xy = max(float2(-1,-1), r1.xy);
  r1.xy = min(float2(1,1), r1.xy);
  r1.zw = float2(1,1) / screenWidth;
  r2.zw = v1.xy + -r1.zw;
  r2.xy = v1.xy + r1.zw;
  r3.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r2.zw).xyz;
  //r3.xyz = max(float3(0,0,0), r3.xyz);
  r1.z = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = min(10000, r1.z);
  r3.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r2.xy).xyz;
  //r3.xyz = max(float3(0,0,0), r3.xyz);
  r3.x = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = min(r3.x, r1.w);
  r1.z = max(r3.x, r1.z);
  r3.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r2.xw).xyz;
  //r3.xyz = max(float3(0,0,0), r3.xyz);
  r2.x = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = min(r2.x, r1.w);
  r1.z = max(r2.x, r1.z);
  r2.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r2.zy).xyz;
  //r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.x = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = min(r2.x, r1.w);
  r1.z = max(r2.x, r1.z);
  r2.xy = v1.xy + -r1.xy;
  r3.xyz = r0.xyz;
  r2.z = 0;
  while (true) {
    r2.w = cmp((int)r2.z >= 8);
    if (r2.w != 0) break;
    r2.w = (uint)r2.z << 1;
    r3.w = icb[r2.w+0].x / screenWidth;
    r4.x = r3.w * jitterScale + r2.x;
    r2.w = icb[r2.w+1].x / screenHeight;
    r4.y = r2.w * jitterScale + r2.y;
    r4.zw = cmp(r4.xy >= float2(0,0));
    r5.xy = cmp(float2(1,1) >= r4.xy);
    r4.z = r4.z ? r5.x : 0;
    r4.z = r4.w ? r4.z : 0;
    r4.z = r5.y ? r4.z : 0;
    r4.w = smplPrevDepth_Tex.Sample(smplPrevDepth_s, r4.xy).x;
    r5.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r4.xy).xyz;
    r6.x = r3.w * jitterScale + v1.x;
    r6.y = r2.w * jitterScale + v1.y;
    r6.xyz = smplScene_Tex.Sample(smplScene_s, r6.xy).xyz;
    if (r4.z != 0) {
      r2.w = r4.x * 2 + -1;
      r4.xyz = r4.yxy * float3(-2,2,-2) + float3(1,-1,1);
      r7.xyzw = g_cbMatCW._m10_m11_m12_m13 * r4.xxxx;
      r7.xyzw = r2.wwww * g_cbMatCW._m00_m01_m02_m03 + r7.xyzw;
      r7.xyzw = r4.wwww * g_cbMatCW._m20_m21_m22_m23 + r7.xyzw;
      r7.xyzw = g_cbMatCW._m30_m31_m32_m33 + r7.xyzw;
      r8.xyz = g_cbMatPrevWC._m10_m11_m13 * r7.yyy;
      r8.xyz = r7.xxx * g_cbMatPrevWC._m00_m01_m03 + r8.xyz;
      r7.xyz = r7.zzz * g_cbMatPrevWC._m20_m21_m23 + r8.xyz;
      r7.xyz = r7.www * g_cbMatPrevWC._m30_m31_m33 + r7.xyz;
      r7.xy = r7.xy / r7.zz;
      r4.xy = -r7.xy + r4.yz;
      r4.xy = float2(0.5,-0.5) * r4.xy;
      r4.xy = max(float2(-1,-1), r4.xy);
      r4.xy = min(float2(1,1), r4.xy);
      r4.xy = r4.xy + r1.xy;
      r2.w = saturate(dot(abs(r4.xy), g_cbTemporalAAParam.xx));
      r3.w = -r4.w + r0.w;
      r3.w = cmp(g_cbTemporalAAParam.z < abs(r3.w));
      r2.w = r3.w ? 1 : r2.w;
      r2.w = saturate(g_cbTemporalAAParam.y + r2.w);
      r3.w = cmp(r2.w < g_cbTemporalAAParam.w);
      if (r3.w != 0) {
        //r4.xyz = max(float3(0,0,0), r5.xyz);
        r4.xyz = r5.xyz;
        r3.w = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
        r3.w = max(9.99999975e-06, r3.w);
        r4.w = max(r3.w, r1.w);
        r4.w = min(r4.w, r1.z);
        r3.w = r4.w / r3.w;
        r5.xyz = r4.xyz * r3.www;
        r4.xyz = -r4.xyz * r3.www + r0.xyz;
        r4.xyz = r2.www * r4.xyz + r5.xyz;
        r3.xyz = r4.xyz + r3.xyz;
      } else {
        //r4.xyz = max(float3(0,0,0), r6.xyz);
        r4.xyz = r6.xyz;
        r3.xyz = r4.xyz + r3.xyz;
      }
    } else {
      r3.xyz = r3.xyz + r0.xyz;
    }
    r2.z = (int)r2.z + 1;
  }
  o0.xyz = float3(0.111111112,0.111111112,0.111111112) * r3.xyz;
  o0.w = 1;
  return;
}