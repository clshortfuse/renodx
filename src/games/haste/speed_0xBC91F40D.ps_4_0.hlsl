#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr  1 23:19:14 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[8];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[4].xy + v1.xy;
  r0.z = max(abs(r0.x), abs(r0.y));
  r0.z = 1 / r0.z;
  r0.w = min(abs(r0.x), abs(r0.y));
  r0.z = r0.w * r0.z;
  r0.w = r0.z * r0.z;
  r1.x = r0.w * 0.0208350997 + -0.0851330012;
  r1.x = r0.w * r1.x + 0.180141002;
  r1.x = r0.w * r1.x + -0.330299497;
  r0.w = r0.w * r1.x + 0.999866009;
  r1.x = r0.z * r0.w;
  r1.x = r1.x * -2 + 1.57079637;
  r1.y = cmp(abs(r0.y) < abs(r0.x));
  r1.x = r1.y ? r1.x : 0;
  r0.z = r0.z * r0.w + r1.x;
  r0.w = cmp(r0.y < -r0.y);
  r0.w = r0.w ? -3.141593 : 0;
  r0.z = r0.z + r0.w;
  r0.w = min(r0.x, r0.y);
  r0.w = cmp(r0.w < -r0.w);
  r1.x = max(r0.x, r0.y);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = cb1[0].y * -1000 + r0.x;
  r1.x = cmp(r1.x >= -r1.x);
  r0.w = r0.w ? r1.x : 0;
  r0.z = r0.w ? -r0.z : r0.z;
  r0.y = r0.z * 0.318309873 + 1;
  r1.xyzw = float4(2500,2894.28003,3640.30005,3214.18262) * r0.yyyy;
  r0.xy = float2(0.00749999983,37.5) * r0.xy;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.y = cb1[0].y * -18.5272808 + r1.w;
  r1.xyz = cb1[0].yyy * float3(15,-16.6877556,21.9518108) + r1.xyz;
  r1.xyz = cos(r1.xyz);
  r1.xyz = float3(1,1,1) + r1.xyz;
  r1.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r0.y = cos(r0.y);
  r0.y = 1 + r0.y;
  r0.y = 0.5 * r0.y;
  r0.y = min(r1.z, r0.y);
  r0.z = min(r1.x, r1.y);
  r0.y = r0.z * r0.y;
  r0.y = r0.y * r0.x;
  r0.x = r0.x * 1.79999995 + -0.300000012;
  r0.x = cb0[4].z * r0.x;
  r0.y = r0.y * cb0[4].z + -0.100000001;
  r0.y = saturate(4.99999952 * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.zw = cb0[4].xy + -v1.xy;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = saturate(r0.z * 2 + -0.200000003);
  r0.z = r0.z * r0.z;
  r0.w = log2(r0.z);
  r0.w = 0.300000012 * r0.w;
  r0.w = exp2(r0.w);
  r0.y = r0.y * r0.w;
  r0.y = r0.y * cb0[6].x + -0.75999999;
  r0.y = saturate(24.9999866 * r0.y);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.xy = r0.xw * r0.zy;
  r1.xy = w1.xy;
  r1.z = 1;
  r1.xyz = float3(-0.5,-0.5,-0) + r1.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xy = r1.xy * r0.ww;
  r0.xw = r1.xy * r0.xx;
  r1.x = -0.699999988 + cb0[4].z;
  r1.x = saturate(3.33333325 * r1.x);
  r0.xw = r1.xx * r0.xw;
  r1.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r1.x = cb1[7].z * r1.x + cb1[7].w;
  r1.x = 1 / r1.x;
  r1.x = saturate(-r1.x * 0.00499999989 + 1);
  r1.x = cb0[4].w * r1.x;
  r0.xw = r0.xw * r1.xx + v1.xy;
  r1.xyzw = t2.Sample(s0_s, r0.xw).xyzw;

  float3 unspeed = r1.rgb;

  r1.xyzw = r0.yyyy * cb0[7].xyzw + r1.xyzw;
  o0.xyzw = cb0[8].xyzw * r0.zzzz + r1.xyzw;

  float3 speed = o0.rgb;

  o0.rgb = lerp(unspeed, speed, CUSTOM_SPEED_LINES);
  return;
}