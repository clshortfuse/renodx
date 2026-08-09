#include "../../shared.h"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[80];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : uv0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t3.SampleBias(s1_s, v1.xy, cb1[79].y).xyw;
  r0.x = r0.z * r0.x;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = cb0[15].zz * r0.xy;
  r0.zw = float2(-0.5,-0.5) + v1.xy;
  r1.x = dot(r0.zw, r0.zw);
  r1.y = r1.x + r1.x;
  r1.x = rsqrt(r1.x);
  r0.zw = r1.xx * r0.zw;
  r1.x = log2(r1.y);
  r1.x = cb0[15].y * r1.x;
  r1.x = exp2(r1.x);
  r1.x = min(1, r1.x);
  r1.x = cb0[15].x * r1.x;
  r0.xy = r1.xx * r0.xy;
  r0.xy = -r0.zw * r0.xy + v1.xy;
  r2.xz = cb0[2].yx * r0.yx;
  r2.w = 0;
  r3.yz = cb0[0].yx;
  r2.y = r0.y * cb0[2].y + r3.y;
  r1.yzw = t1.SampleBias(s0_s, r2.zyw, cb1[79].y).xyz;
  r0.z = renodx::color::y::from::NTSC1953(r1.yzw);
  r2.y = r0.y * cb0[2].y + -r3.y;
  r1.yzw = t1.SampleBias(s0_s, r2.zyw, cb1[79].y).xyz;
  r2.xyz = t1.SampleBias(s0_s, r2.zxw, cb1[79].y).xyz;
  if (injectedData.toneMapType == 0.f) {
  r2.xyz = max(float3(0,0,0), r2.xyz);
  }
  r0.w = renodx::color::y::from::NTSC1953(r1.yzw);
  r1.y = min(r0.z, r0.w);
  r0.z = max(r0.z, r0.w);
  r4.z = 0;
  r3.xw = float2(0,0);
  r4.xy = r0.xy * cb0[2].xy + -r3.zw;
  r4.xyz = t1.SampleBias(s0_s, r4.xyz, cb1[79].y).xyz;
  r0.w = renodx::color::y::from::NTSC1953(r4.xyz);
  r1.y = min(r1.y, r0.w);
  r0.z = max(r0.z, r0.w);
  r4.xy = r0.xy * cb0[2].xy + r3.zw;
  r4.z = 0;
  r4.xyz = t1.SampleBias(s0_s, r4.xyz, cb1[79].y).xyz;
  r0.w = renodx::color::y::from::NTSC1953(r4.xyz);
  r1.y = min(r1.y, r0.w);
  r0.z = max(r0.z, r0.w);
  r0.w = -9.99999997e-07 + r1.y;
  r1.y = r0.z + -r0.w;
  r1.y = saturate(cb0[6].w / r1.y);
  r1.z = renodx::color::y::from::NTSC1953(r2.xyz);
  r0.w = r1.z * 2 + -r0.w;
  r0.z = r0.w + -r0.z;
  r0.z = r0.z * r1.y;
  r4.xyzw = -r3.xyzw + r0.xyxy;
  r3.xyzw = r3.xyzw + r0.xyxy;
  r3.xyzw = cb1[46].xyxy * r3.zwxy;
  r4.xyzw = cb1[46].xyxy * r4.xyzw;
  r5.xy = (uint2)r4.xy;
  r4.xy = (uint2)r4.zw;
  r5.zw = float2(0,0);
  r0.w = t0.Load(r5.xyzw).x;
  r0.w = cb1[53].x * r0.w + cb1[53].y;
  r0.w = 1 / r0.w;
  r5.xy = (uint2)r3.zw;
  r3.xy = (uint2)r3.xy;
  r5.zw = float2(0,0);
  r1.y = t0.Load(r5.xyzw).x;
  r1.y = cb1[53].x * r1.y + cb1[53].y;
  r1.y = 1 / r1.y;
  r1.w = max(r1.y, r0.w);
  r0.w = min(r1.y, r0.w);
  r4.zw = float2(0,0);
  r1.y = t0.Load(r4.xyzw).x;
  r1.y = cb1[53].x * r1.y + cb1[53].y;
  r1.y = 1 / r1.y;
  r1.w = max(r1.w, r1.y);
  r3.zw = float2(0,0);
  r2.w = t0.Load(r3.xyzw).x;
  r2.w = cb1[53].x * r2.w + cb1[53].y;
  r2.w = 1 / r2.w;
  r1.w = max(r2.w, r1.w);
  r0.w = min(r1.y, r0.w);
  r1.y = -cb0[8].y + r1.y;
  r1.y = cb0[8].z / abs(r1.y);
  r0.w = min(r0.w, r2.w);
  r0.w = r1.w + -r0.w;
  r0.w = 9.99999975e-06 + r0.w;
  r0.w = saturate(cb0[6].y / r0.w);
  r0.z = r0.z * r0.w;
  r0.z = cb0[6].x * r0.z;
  r0.z = max(-cb0[6].z, r0.z);
  r0.z = min(cb0[6].z, r0.z);
  r0.w = r1.y > 1 ? 1.000000 : 0;
  r1.y = saturate(cb0[8].x * r1.y);
  r0.w = max(r0.w, r1.y);
  r0.z = r0.z * r0.w + 1;
  r3.xyz = min(float3(1,1,1), r2.xyz);
  r3.xyz = float3(1,1,1) + -r3.xyz;
  r4.xyz = r3.yxx * r2.xyz;
  r3.xyz = r4.xyz * r3.zzy;
  r3.xyz = r3.xyz * cb0[7].www + float3(1,1,1);
  r2.xyz = r3.xyz * r2.xyz;
  r0.w = renodx::color::y::from::NTSC1953(r2.xyz);
  r0.w = 9.99999975e-05 + r0.w;
  r0.w = r1.z / r0.w;
  r1.yzw = r2.xyz * r0.www;
  r2.xyz = r1.yzw * r0.zzz;
  r0.w = max(r2.y, r2.z);
  r0.w = max(r2.x, r0.w);
  r2.w = min(r2.y, r2.z);
  r2.w = min(r2.x, r2.w);
  r0.w = saturate(-r2.w + r0.w);
  r0.w = 1 + -r0.w;
  r0.w = cb0[7].z * r0.w;
  r2.w = renodx::color::y::from::NTSC1953(r2.xyz);
  r1.yzw = r1.yzw * r0.zzz + -r2.www;
  r1.yzw = r0.www * r1.yzw + float3(1,1,1);
  r1.yzw = r2.xyz * r1.yzw + float3(-0.5,-0.5,-0.5);
  r1.yzw = r1.yzw * cb0[7].yyy + float3(0.5, 0.5, 0.5);
  if (injectedData.toneMapType == 0.f) {
    r1.yzw = saturate(r1.yzw);
  }
  r2.xyz = float3(1,1,1) + -r1.yzw;
  r2.xyz = r2.xyz + r2.xyz;
  r3.xyz = -r1.yzw * cb0[9].yyy + float3(1,1,1);
  r2.xyz = -r2.xyz * r3.xyz + float3(1,1,1);
  r3.xyz = cb0[9].yyy * r1.yzw;
  r3.xyz = r3.xyz * r1.yzw;
  r3.xyz = r3.xyz + r3.xyz;
  r2.xyz = r2.w < 0.5 ? r3.xyz : r2.xyz;
  r2.xyz = r2.xyz + -r1.yzw;
  r1.yzw = cb0[9].xxx * r2.xyz + r1.yzw;
  r0.zw = cb0[0].zw * r0.xy;
  r2.xy = -cb0[11].xy + r0.xy;
  r0.x = dot(r0.zw, float2(0.0671105608,0.00583714992));
  r0.x = frac(r0.x);
  r0.x = 52.9829178 * r0.x;
  r0.x = frac(r0.x);
  r0.x = -0.5 + r0.x;
  r0.x = cb0[8].w * r0.x;
  r0.xyz = r1.yzw * cb0[7].xxx + r0.xxx;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = max(float3(0,0,0), r0.xyz);
  }
  r0.xyz = -cb0[10].xyz + r0.xyz;
  r2.z = cb0[11].z * r2.y;
  r0.w = dot(r2.xz, r2.xz);
  r0.w = -cb0[12].z + r0.w;
  r1.y = cb0[12].y + -cb0[12].z;
  r0.w = saturate(r0.w / r1.y);
  r1.y = 1 + -cb0[10].w;
  r0.w = r1.y + r0.w;
  r0.w = saturate(-cb0[12].x + r0.w);
  r0.xyz = r0.www * r0.xyz + cb0[10].xyz;
  r1.yzw = t2.SampleBias(s1_s, v1.xy, cb1[79].y).xyz;
  r0.w = -r1.z * r1.x + 1;
  r1.xyz = r1.yzw * r1.xxx;
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = r1.xyz * cb0[16].xyz + r0.xyz;
  o0.w = 1;
  return;
}