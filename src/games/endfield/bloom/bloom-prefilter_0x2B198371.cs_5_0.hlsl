// ============================================================================
// BLOOM PREFILTER / THRESHOLD EXTRACTION (13-tap Weighted)
// ============================================================================
// ============================================================================

#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[2];
  // cb1[0].xy = output dimensions
  // cb1[0].zw = texel size (1/width, 1/height)
  // cb1[1].x = threshold (bloom starts above this brightness)
  // cb1[1].y = threshold knee start (soft transition begins)
  // cb1[1].z = knee curve max
  // cb1[1].w = knee intensity multiplier
}

cbuffer cb0 : register(b0)
{
  float4 cb0[110];
  // cb0[82].zw = sample offset scale
  // cb0[109].x = bloom intensity multiplier
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -
[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  const float4 icb[] = { 
    { 0, 0, 4.000000, 0},           // [0]  Center tap - weight 4
    { -2.000000, -2.000000, 1.000000, 0},  // [1]  Bottom-left corner - weight 1
    { 2.000000, -2.000000, 1.000000, 0},   // [2]  Bottom-right corner - weight 1
    { 2.000000, 2.000000, 1.000000, 0},    // [3]  Top-right corner - weight 1
    { -2.000000, 2.000000, 1.000000, 0},   // [4]  Top-left corner - weight 1
    { -2.000000, 0, 2.000000, 0},          // [5]  Left edge - weight 2
    { 2.000000, 0, 2.000000, 0},           // [6]  Right edge - weight 2
    { 0, 2.000000, 2.000000, 0},           // [7]  Top edge - weight 2
    { 0, -2.000000, 2.000000, 0},          // [8]  Bottom edge - weight 2
    { -1.000000, 1.000000, 4.000000, 0},   // [9]  Inner top-left - weight 4
    { 1.000000, 1.000000, 4.000000, 0},    // [10] Inner top-right - weight 4
    { -1.000000, -1.000000, 4.000000, 0},  // [11] Inner bottom-left - weight 4
    { -1.000000, 1.000000, 4.000000, 0}    // [12] Inner top-left (duplicate?) - weight 4
  };

  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;       
  r1.xyz = float3(0,0,0);                
  r0.zw = float2(0,0);                    
  while (true) {
    r1.w = cmp((int)r0.w >= 13);
    if (r1.w != 0) break;
    r2.xy = icb[r0.w+0].xy * cb0[82].zw;
    r2.xy = r0.xy * cb1[0].zw + r2.xy;
    r2.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    r1.w = max(r2.x, r2.y);
    r1.w = max(r1.w, r2.z);              
    r3.xy = -cb1[1].yx + r1.ww;
    r2.w = max(0, r3.x);                  
    r2.w = min(cb1[1].z, r2.w);           
    r2.w = r2.w * r2.w;                   
    r2.w = cb1[1].w * r2.w;               
    r2.w = max(r2.w, r3.y);             
    r1.w = max(9.99999975e-05, r1.w);
    r1.w = r2.w / r1.w;               
    r2.xyz = r2.xyz * r1.www;
    
    r2.xyz = cb0[109].xxx * r2.xyz * (BLOOM_STRENGTH / 50.0f);

    r1.w = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036)); 
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;                     
    r2.w = icb[r0.w+0].z * r1.w + r0.z;   
    r2.xyz = icb[r0.w+0].zzz * r2.xyz;    
    r2.xyz = r2.xyz * r1.www + r1.xyz;    
    r1.w = (int)r0.w + 1;
    r1.xyz = r2.xyz;                      
    r0.z = r2.w;                          
    r0.w = r1.w;                          
    continue;
  }
  r1.xyzw = r1.xyzx;                      
  r0.xy = (uint2)cb1[0].xy;               
  r1.xyzw = r1.xyzw / r0.zzzz;            
  r0.xy = cmp((uint2)r0.xy >= (uint2)vThreadID.xy);
  r0.x = r0.y ? r0.x : 0;
  r0.x = r0.x ? 1.000000 : 0;             
  r0.xyzw = r1.xyzw * r0.xxxx;           
  u0[vThreadID.xy] = r0.xyzw;
  return;
}