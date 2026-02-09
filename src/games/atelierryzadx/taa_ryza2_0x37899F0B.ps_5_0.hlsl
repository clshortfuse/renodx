// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 11:58:21 2025

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

  r0.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.x = smplDepth_Tex.Sample(smplDepth_s, v1.xy).x;
  r1.y = v1.x * 2 + -1;
  r2.xyz = v1.yxy * float3(-2,2,-2) + float3(1,-1,1);
  r3.xyzw = g_cbMatCW._m10_m11_m12_m13 * r2.xxxx;
  r3.xyzw = r1.yyyy * g_cbMatCW._m00_m01_m02_m03 + r3.xyzw;
  r3.xyzw = r1.xxxx * g_cbMatCW._m20_m21_m22_m23 + r3.xyzw;
  r3.xyzw = g_cbMatCW._m30_m31_m32_m33 + r3.xyzw;
  r1.yzw = g_cbMatPrevWC._m10_m11_m13 * r3.yyy;
  r1.yzw = r3.xxx * g_cbMatPrevWC._m00_m01_m03 + r1.yzw;
  r1.yzw = r3.zzz * g_cbMatPrevWC._m20_m21_m23 + r1.yzw;
  r1.yzw = r3.www * g_cbMatPrevWC._m30_m31_m33 + r1.yzw;
  r1.yz = r1.yz / r1.ww;
  r1.yz = r2.yz + -r1.yz;
  r1.yz = float2(0.5,-0.5) * r1.yz;
  r1.yz = max(float2(-1,-1), r1.yz);
  r1.yz = min(float2(1,1), r1.yz);
  r2.xy = float2(1,1) / screenWidth;
  r3.zw = v1.xy + -r2.xy;
  r3.xy = v1.xy + r2.xy;
  r2.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r3.zw).xyz;
  //r2.xyz = max(float3(0,0,0), r2.xyz);
  r1.w = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r2.x = min(10000, r1.w);
  r2.yzw = smplPrevScene_Tex.Sample(smplPrevScene_s, r3.xy).xyz;
  //r2.yzw = max(float3(0,0,0), r2.yzw);
  r2.y = dot(r2.yzw, float3(0.298999995,0.587000012,0.114));
  r2.x = min(r2.x, r2.y);
  r1.w = max(r2.y, r1.w);
  r2.yzw = smplPrevScene_Tex.Sample(smplPrevScene_s, r3.xw).xyz;
  //r2.yzw = max(float3(0,0,0), r2.yzw);
  r2.y = dot(r2.yzw, float3(0.298999995,0.587000012,0.114));
  r2.x = min(r2.x, r2.y);
  r1.w = max(r2.y, r1.w);
  r2.yzw = smplPrevScene_Tex.Sample(smplPrevScene_s, r3.zy).xyz;
  //r2.yzw = max(float3(0,0,0), r2.yzw);
  r2.y = dot(r2.yzw, float3(0.298999995,0.587000012,0.114));
  r2.x = min(r2.x, r2.y);
  r1.w = max(r2.y, r1.w);
  r2.yz = v1.xy + -r1.yz;
  r3.xyz = r0.xyz;
  r2.w = 0;
  while (true) {
    r3.w = cmp((int)r2.w >= 8);
    if (r3.w != 0) break;
    r3.w = (uint)r2.w << 1;
    r4.x = icb[r3.w+0].x / screenWidth;
    r5.x = r4.x * jitterScale + r2.y;
    r3.w = icb[r3.w+1].x / screenHeight;
    r5.y = r3.w * jitterScale + r2.z;
    r4.yz = cmp(r5.xy >= float2(0,0));
    r5.zw = cmp(float2(1,1) >= r5.xy);
    r4.y = r4.y ? r5.z : 0;
    r4.y = r4.z ? r4.y : 0;
    r4.y = r5.w ? r4.y : 0;
    r4.z = smplPrevDepth_Tex.Sample(smplPrevDepth_s, r5.xy).x;
    r6.xyz = smplPrevScene_Tex.Sample(smplPrevScene_s, r5.xy).xyz;
    r7.x = r4.x * jitterScale + v1.x;
    r7.y = r3.w * jitterScale + v1.y;
    r7.xyz = smplScene_Tex.Sample(smplScene_s, r7.xy).xyz;
    if (r4.y != 0) {
      r3.w = r5.x * 2 + -1;
      r4.xyw = r5.yxy * float3(-2,2,-2) + float3(1,-1,1);
      r5.xyzw = g_cbMatCW._m10_m11_m12_m13 * r4.xxxx;
      r5.xyzw = r3.wwww * g_cbMatCW._m00_m01_m02_m03 + r5.xyzw;
      r5.xyzw = r4.zzzz * g_cbMatCW._m20_m21_m22_m23 + r5.xyzw;
      r5.xyzw = g_cbMatCW._m30_m31_m32_m33 + r5.xyzw;
      r8.xyz = g_cbMatPrevWC._m10_m11_m13 * r5.yyy;
      r8.xyz = r5.xxx * g_cbMatPrevWC._m00_m01_m03 + r8.xyz;
      r5.xyz = r5.zzz * g_cbMatPrevWC._m20_m21_m23 + r8.xyz;
      r5.xyz = r5.www * g_cbMatPrevWC._m30_m31_m33 + r5.xyz;
      r5.xy = r5.xy / r5.zz;
      r4.xy = -r5.xy + r4.yw;
      r4.xy = float2(0.5,-0.5) * r4.xy;
      r4.xy = max(float2(-1,-1), r4.xy);
      r4.xy = min(float2(1,1), r4.xy);
      r4.xy = r4.xy + r1.yz;
      r3.w = saturate(dot(abs(r4.xy), g_cbTemporalAAParam.xx));
      r4.x = -r4.z + r1.x;
      r4.x = cmp(g_cbTemporalAAParam.z < abs(r4.x));
      r3.w = r4.x ? 1 : r3.w;
      r3.w = saturate(g_cbTemporalAAParam.y + r3.w);
      r4.x = cmp(r3.w < g_cbTemporalAAParam.w);
      if (r4.x != 0) {
        //r4.xyz = max(float3(0, 0, 0), r6.xyz);
        r4.xyz = r6.xyz;

        r4.w = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
        r4.w = max(9.99999975e-06, r4.w);
        r5.x = max(r4.w, r2.x);
        r5.x = min(r5.x, r1.w);
        r4.w = r5.x / r4.w;
        r5.xyz = r4.xyz * r4.www;
        r4.xyz = -r4.xyz * r4.www + r0.xyz;
        r4.xyz = r3.www * r4.xyz + r5.xyz;
        r3.xyz = r4.xyz + r3.xyz;
      } else {
        //r4.xyz = max(float3(0,0,0), r7.xyz);
        r4.xyz = r7.xyz;
        r3.xyz = r4.xyz + r3.xyz;
      }
    } else {
      r3.xyz = r3.xyz + r0.xyz;
    }
    r2.w = (int)r2.w + 1;
  }
  o0.xyz = float3(0.111111112,0.111111112,0.111111112) * r3.xyz;
  o0.w = r0.w;
  return;
}