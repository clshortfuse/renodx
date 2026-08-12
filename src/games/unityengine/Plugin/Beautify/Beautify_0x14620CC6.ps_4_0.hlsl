#include "../../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[170];
}

#define cmp -
// Iron Nest: Heavy Turret Simulator

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s1_s, v1.xy, cb0[4].x).xyzw;
  r1.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r2.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r0.xyz = r2.xyz * cb0[149].xxx + r0.xyz;
  r1.y = max(r0.y, r0.z);
  r1.y = max(r1.y, r0.x);
  r1.z = min(r0.y, r0.z);
  r1.z = min(r1.z, r0.x);
  r1.y = saturate(r1.y + -r1.z);
  r1.y = 1 + -r1.y;
  r1.y = cb0[152].z * r1.y;
  r1.z = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r2.xyz = -r1.zzz + r0.xyz;
  r1.yzw = r1.yyy * r2.xyz + float3(1,1,1);
  r0.xyz = r1.yzw * r0.xyz;
  r1.yzw = r0.xyz * cb0[153].xyz + -r0.xyz;
  r0.xyz = cb0[153].www * r1.yzw + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[152].yyy + float3(0.5,0.5,0.5);
  r0.xyz = cb0[152].xxx * r0.xyz;
  r2.xyzw = cb0[140].zzzz * cb0[136].zwzw;
  r1.yz = v1.xy * r2.zw;
  r3.xyzw = floor(r1.yzyz);
  r1.x = sqrt(r1.x);
  r1.yz = v1.xy * r2.zw + -r3.zw;
  r2.xyzw = float4(1,1,1,1) / r2.xyzw;
  r4.xy = r3.zw * r2.zw;
  r1.w = dot(r4.xy, float2(321.894196,1225.65479));
  r4.xyzw = r3.zwzw * r2.zwzw + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r4.x = dot(r4.xy, float2(321.894196,1225.65479));
  r4.y = dot(r4.zw, float2(321.894196,1225.65479));
  r5.x = sin(r1.w);
  r5.yz = sin(r4.xy);
  r4.xyz = r5.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r4.xyz = frac(r4.xyz);
  r5.xyzw = float4(1,0,0,1) + r3.zwzw;
  r6.xyzw = r5.xyzw * r2.xyzw;
  r1.w = dot(r6.xy, float2(321.894196,1225.65479));
  r7.xyzw = r5.xyxy * r2.xyxy + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r4.w = dot(r7.xy, float2(321.894196,1225.65479));
  r5.x = dot(r7.zw, float2(321.894196,1225.65479));
  r7.x = sin(r1.w);
  r7.y = sin(r4.w);
  r7.z = sin(r5.x);
  r7.xyz = r7.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r7.xyz = frac(r7.xyz);
  r1.w = dot(r6.zw, float2(321.894196,1225.65479));
  r5.xyzw = r5.zwzw * r2.zwzw + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r4.w = dot(r5.xy, float2(321.894196,1225.65479));
  r5.x = dot(r5.zw, float2(321.894196,1225.65479));
  r6.x = sin(r1.w);
  r6.y = sin(r4.w);
  r6.z = sin(r5.x);
  r5.xyz = r6.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r5.xyz = frac(r5.xyz);
  r3.xyzw = float4(1,1,1,1) + r3.xyzw;
  r6.xy = r3.zw * r2.zw;
  r1.w = dot(r6.xy, float2(321.894196,1225.65479));
  r2.xyzw = r3.xyzw * r2.xyzw + float4(0.100000001,0.100000001,0.200000003,0.200000003);
  r2.x = dot(r2.xy, float2(321.894196,1225.65479));
  r2.y = dot(r2.zw, float2(321.894196,1225.65479));
  r3.x = sin(r1.w);
  r3.yz = sin(r2.xy);
  r2.xyz = r3.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r2.xyz = frac(r2.xyz);
  r3.xyz = r7.xyz + -r4.xyz;
  r3.xyz = r1.yyy * r3.xyz + r4.xyz;
  r2.xyz = r2.xyz + -r5.xyz;
  r2.xyz = r1.yyy * r2.xyz + r5.xyz;
  r2.xyz = r2.xyz + -r3.xyz;
  r1.yzw = r1.zzz * r2.xyz + r3.xyz;
  r2.xy = cmp(float2(0,0) < cb0[141].xz);
  if (r2.x != 0) {
    r2.xz = float2(20,20) * v1.xy;
    r3.xyzw = floor(r2.xzxz);
    r2.xz = v1.xy * float2(20,20) + -r3.zw;
    r2.w = 0.5 * cb0[15].y;
    r2.w = floor(r2.w);
    r3.xyzw = r3.xyzw + r2.wwww;
    r2.w = dot(r3.zw, float2(321.894196,1225.65479));
    r3.xyzw = float4(0.100000001,0.100000001,0.200000003,0.200000003) + r3.xyzw;
    r3.x = dot(r3.xy, float2(321.894196,1225.65479));
    r3.y = dot(r3.zw, float2(321.894196,1225.65479));
    r4.x = sin(r2.w);
    r4.yz = sin(r3.xy);
    r3.xyz = r4.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
    r3.xyz = frac(r3.xyz);
    r2.w = cmp(cb0[141].x < r3.x);
    r2.xz = float2(-0.5,-0.5) + r2.xz;
    r2.x = dot(r2.xz, r2.xz);
    r2.z = r3.y * 0.300000012 + 0.100000001;
    r2.z = r2.z * r2.z;
    r2.z = 1 / r2.z;
    r2.x = r2.x * r2.z;
    r2.x = min(1, r2.x);
    r2.z = r2.x * -2 + 3;
    r2.x = r2.x * r2.x;
    r2.x = -r2.z * r2.x + 1;
    r2.z = -0.5 + r3.z;
    r2.x = r2.x * r2.z;
    r2.x = cb0[141].y * r2.x;
    r2.x = r2.w ? r2.x : 0;
  } else {
    r2.x = 0;
  }
  if (r2.y != 0) {
    r2.y = dot(cb0[15].xyzw, float4(1,1,1,1));
    r2.y = floor(r2.y);
    r2.z = 321.894196 * r2.y;
    r2.z = sin(r2.z);
    r2.z = r2.z * 4251.48633 + cb0[15].y;
    r2.z = frac(r2.z);
    r2.z = cmp(cb0[141].z < r2.z);
    r2.yw = float2(0.100000001,0.200000003) + r2.yy;
    r2.yw = float2(321.894196,321.894196) * r2.yw;
    r2.yw = sin(r2.yw);
    r2.yw = r2.yw * float2(4251.48633,4251.48633) + cb0[15].yy;
    r2.yw = frac(r2.yw);
    r2.w = r2.w * 0.00300000003 + 0.00100000005;
    r2.y = v1.x + -r2.y;
    r2.w = 1 / r2.w;
    r2.y = abs(r2.y) * r2.w;
    r2.y = min(1, r2.y);
    r2.w = r2.y * -2 + 3;
    r2.y = r2.y * r2.y;
    r2.y = -r2.w * r2.y + 1;
    r2.y = r2.y * cb0[141].w + r2.x;
    r2.x = r2.z ? r2.y : r2.x;
  }
  r1.yzw = float3(-0.5,-0.5,-0.5) + r1.yzw;
  r1.yzw = float3(1,0.949999988,1.04999995) * r1.yzw;
  r1.x = cb0[140].y * -r1.x + 1;
  r1.xyz = r1.yzw * r1.xxx;
  r1.xyz = r1.xyz * cb0[140].xxx + r2.xxx;
  r1.xyz = float3(1,1,1) + r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r1.xy = -cb0[168].xy + v1.xy;
  r2.x = cb0[169].x * r1.x;
  r2.y = cb0[168].z * r1.y;
  r1.x = dot(r2.xy, r2.xy);
  r1.x = -cb0[168].w + r1.x;
  r1.y = -cb0[168].w + cb0[154].w;
  r1.x = saturate(r1.x / r1.y);
  r1.x = saturate(-cb0[154].z + r1.x);
  r1.yzw = -cb0[167].xyz + r0.xyz;
  r1.xyz = r1.xxx * r1.yzw + cb0[167].xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = cb0[167].www * r1.xyz + r0.xyz;
  o0.w = r0.w;
  return;
}