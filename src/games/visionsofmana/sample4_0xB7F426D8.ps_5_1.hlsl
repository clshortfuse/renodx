// ---- Created with 3Dmigoto v1.3.16 on Mon Oct  7 22:40:16 2024
// Sample 4

#include "./shared.h"



Texture3D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[144];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[68];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  linear noperspective float2 w0 : TEXCOORD3,
  linear noperspective float3 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  linear noperspective float2 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w * 543.309998 + v2.z;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.x = frac(r0.x);
  r0.yzw = t1.Sample(s1_s, v0.xy).xyz;
  r0.yzw = cb1[143].zzz * r0.yzw;
  r1.xy = cb0[58].zw * v0.xy + cb0[59].xy;
  r1.xy = max(cb0[50].zw, r1.xy);
  r1.xy = min(cb0[51].xy, r1.xy);
  r1.xyz = t2.Sample(s2_s, r1.xy).xyz;
  r1.xyz = cb1[143].zzz * r1.xyz;
  r2.xy = w0.xy * cb0[67].zw + cb0[67].xy;
  r2.xy = r2.xy * float2(0.5,-0.5) + float2(0.5,0.5);
  r2.xyz = t4.Sample(s4_s, r2.xy).xyz;
  r2.xyz = r2.xyz * cb0[66].xyz + cb0[61].xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.yzw = r0.yzw * cb0[60].xyz + r1.xyz;
  r1.xyzw = t3.Sample(s3_s, v3.xy).xyzw;
  r2.xyz = cb1[143].zzz * r1.xyz;
  r2.w = cmp(r1.w < 1);
  
        
        
 if (r2.w != 0) {
    r2.w = 1 + -r1.w;
    r3.xyz = r2.www * r0.yzw;
    r1.xyz = r1.xyz * cb1[143].zzz + -r3.xyz;
    r2.xyz = cb0[59].zzz * r1.xyz + r3.xyz;
  }
  r0.yzw = r0.yzw * r1.www + r2.xyz;
  r0.yzw = v1.xxx * r0.yzw;
  r1.xy = cb0[62].xx * v1.yz;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = 1 + r1.x;
  r1.x = rcp(r1.x);
  r1.x = r1.x * r1.x;
    
  r1.yzw = r1.xxx * r0.yzw;
    
    
  //r0.yzw = r0.yzw * r1.xxx + float3(0.00266771927,0.00266771927,0.00266771927);
  //r0.yzw = log2(r0.yzw);
  //r0.yzw = saturate(r0.yzw * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953));
  //r0.yzw = r0.yzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  //r0.yzw = t5.Sample(s5_s, r0.yzw).xyz;
  //r0.yzw = float3(1.04999995,1.04999995,1.04999995) * r0.yzw;
    
    float3 untonemapped = r0.yzw * r1.x;
    float3 lut_input = renodx::color::pq::from::BT2020(untonemapped, 100.f);
    float3 sampled = renodx::lut::Sample(t5, s5_s, lut_input);
    float3 post_lut = renodx::color::bt2020::from::PQ(sampled, 100.f);
    r0.yzw = post_lut;
    
  r1.x = t0.Sample(s0_s, v0.xy).x;
  r1.x = 256 * r1.x;
  r1.x = (uint)r1.x;
  r1.x = (int)r1.x & 1;
  r0.yzw = r1.xxx ? r1.yzw : r0.yzw;
    
    

    
    
  o0.w = saturate(dot(r0.yzw, float3(0.298999995,0.587000012,0.114)));
  r0.x = r0.x * 0.00390625 + -0.001953125;
  r0.xyz = r0.yzw + r0.xxx;
  
    
    
        
  if (cb0[65].x != 0) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(10000,10000,10000) * r1.xyz;
    r1.xyz = r1.xyz / cb0[64].www;
    r1.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r1.xyz);
    r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
    r1.xyz = max(float3(0.00313066994,0.00313066994,0.00313066994), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    o0.xyz = min(r2.xyz, r1.xyz);
  } else {
    o0.xyz = r0.xyz;
  }
 
    //o0.rgb = post_lut.rgb;

    //o0.w = 1.f;
    
  return;
}