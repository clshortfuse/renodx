#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
RWTexture2D<float4> u0 : register(u0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

[numthreads(64, 1, 1)]
void main(uint vThreadIDInGroup: SV_GroupThreadID, uint2 vThreadGroupID: SV_GroupID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.x = (uint)vThreadIDInGroup.x >> 3;
  bitmask.y = ((~(-1 << 1)) << 0) & 0xffffffff;  r1.y = (((uint)vThreadIDInGroup.x << 0) & bitmask.y) | ((uint)r1.x & ~bitmask.y);
  if (3 == 0) r1.x = 0; else if (3+1 < 32) {   r1.x = (uint)vThreadIDInGroup.x << (32-(3 + 1)); r1.x = (uint)r1.x >> (32-3);  } else r1.x = (uint)vThreadIDInGroup.x >> 1;
  r1.xz = mad((int2)vThreadGroupID.xy, int2(16,16), (int2)r1.xy);
  r2.xyzw = (int4)r1.xzxz + int4(0,-1,-1,0);
  r0.xy = r2.zw;
  r0.xyz = t1.Load(r0.xyz).xyz;
  r0.xyz = r0.xyz / cb0[6].xxx;
  r0.w = t0.Load(float4(0,0,0,0)).x;
  r0.w = r0.w == 0.0 ? 1 : r0.w;
  r0.xyz = r0.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  }
  r3.x = r0.x * 0.5 + r0.y;
  r3.x = r0.z * 0.5 + r3.x;
  r1.yw = float2(0,0);
  r3.yzw = t1.Load(r1.xzy).xyz;
  r3.yzw = r3.yzw / cb0[6].xxx;
  r3.yzw = r3.yzw * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r3.yzw = max(float3(0,0,0), r3.yzw);
  r3.yzw = min(float3(65504,65504,65504), r3.yzw);
  }
  r4.x = r3.y * 0.5 + r3.z;
  r4.x = r3.w * 0.5 + r4.x;
  r4.y = max(r4.x, r3.x);
  r2.zw = float2(0,0);
  r2.xyz = t1.Load(r2.xyz).xyz;
  r2.xyz = r2.xyz / cb0[6].xxx;
  r2.xyz = r2.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.xyz = min(float3(65504,65504,65504), r2.xyz);
  }
  r2.w = r2.x * 0.5 + r2.y;
  r2.w = r2.z * 0.5 + r2.w;
  r4.y = max(r2.w, r4.y);
  r5.zw = float2(0,0);
  r6.xyzw = (int4)r1.xzxz + int4(0,1,1,0);
  r5.xy = r6.zw;
  r5.xyz = t1.Load(r5.xyz).xyz;
  r5.xyz = r5.xyz / cb0[6].xxx;
  r5.xyz = r5.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r5.xyz = min(float3(65504,65504,65504), r5.xyz);
  }
  r4.z = r5.x * 0.5 + r5.y;
  r4.z = r5.z * 0.5 + r4.z;
  r6.zw = float2(0,0);
  r6.xyz = t1.Load(r6.xyz).xyz;
  r6.xyz = r6.xyz / cb0[6].xxx;
  r6.xyz = r6.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r6.xyz = max(float3(0,0,0), r6.xyz);
  r6.xyz = min(float3(65504,65504,65504), r6.xyz);
  }
  r4.w = r6.x * 0.5 + r6.y;
  r4.w = r6.z * 0.5 + r4.w;
  r5.w = max(r4.z, r4.w);
  r4.y = max(r5.w, r4.y);
  r5.w = min(r4.x, r3.x);
  r3.x = 0.25 * r3.x;
  r3.x = r2.w * 0.25 + r3.x;
  r2.w = min(r5.w, r2.w);
  r3.x = r4.z * 0.25 + r3.x;
  r4.z = min(r4.z, r4.w);
  r3.x = r4.w * 0.25 + r3.x;
  r3.x = r3.x + -r4.x;
  r2.w = min(r4.z, r2.w);
  r2.w = r4.y + -r2.w;
  //r4.x = (int)-r2.w + 0x7ef19fff;
  r4.x = asfloat(2129764351u - asuint(r2.w));
  r2.w = -r4.x * r2.w + 2;
  r2.w = r4.x * r2.w;
  r2.w = saturate(abs(r3.x) * r2.w);
  r2.w = r2.w * -0.5 + 1;
  r4.xyz = min(r5.xyz, r0.xyz);
  r4.xyz = min(r4.xyz, r2.xyz);
  r4.xyz = min(r4.xyz, r6.xyz);
  r7.xyz = r4.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r7.xyz = rcp(r7.xyz);
  r8.xyz = max(r5.xyz, r0.xyz);
  r8.xyz = max(r8.xyz, r2.xyz);
  r8.xyz = max(r8.xyz, r6.xyz);
  r9.xyz = float3(1,1,1) + -r8.xyz;
  r8.xyz = float3(4,4,4) * r8.xyz;
  r8.xyz = rcp(r8.xyz);
  r4.xyz = r8.xyz * r4.xyz;
  r7.xyz = r9.xyz * r7.xyz;
  r4.xyz = max(r7.xyz, -r4.xyz);
  r3.x = max(r4.y, r4.z);
  r3.x = max(r4.x, r3.x);
  r3.x = min(0, r3.x);
  r3.x = max(-0.1875, r3.x);
  r3.x = cb1[0].x * r3.x;
  r2.w = r3.x * r2.w;
  r0.xyz = r2.www * r0.xyz;
  r0.xyz = r2.www * r2.xyz + r0.xyz;
  r0.xyz = r2.www * r6.xyz + r0.xyz;
  r0.xyz = r2.www * r5.xyz + r0.xyz;
  r2.x = r2.w * 4 + 1;
  r0.xyz = r0.xyz + r3.yzw;
  //r2.y = (int)-r2.x + 0x7ef19fff;
  r2.y = asfloat(2129764351u - asuint(r2.x));
  r2.x = -r2.y * r2.x + 2;
  r2.x = r2.y * r2.x;
  r0.xyz = r2.xxx * r0.xyz;
  r0.xyz = r0.xyz / r0.www;
  r2.xyz = cb0[6].xxx * r0.xyz;
  r2.w = 1;
// No code for instruction (needs manual fix):
//store_uav_typed u0.xyzw, r1.xzzz, r2.xyzw
  u0[r1.xz] = r2;
  r2.zw = float2(0,0);
  r1.xy = (int2)r1.xz + int2(8,8);
  r2.xy = (int2)r1.xz + int2(-1,0);
  r0.xyz = t1.Load(r2.xyz).xyz;
  r0.xyz = r0.xyz / cb0[6].xxx;
  r0.xyz = r0.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  }
  r2.x = r0.x * 0.5 + r0.y;
  r2.x = r0.z * 0.5 + r2.x;
  r1.w = 0;
  r2.yzw = t1.Load(r1.xzw).xyz;
  r3.xyz = t1.Load(r1.xyw).xyz;
  r3.xyz = r3.xyz / cb0[6].xxx;
  r3.xyz = r3.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r3.xyz = min(float3(65504,65504,65504), r3.xyz);
  }
  r2.yzw = r2.yzw / cb0[6].xxx;
  r2.yzw = r2.yzw * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r2.yzw = max(float3(0,0,0), r2.yzw);
  r2.yzw = min(float3(65504,65504,65504), r2.yzw);
  }
  r1.w = r2.y * 0.5 + r2.z;
  r1.w = r2.w * 0.5 + r1.w;
  r3.w = max(r2.x, r1.w);
  r4.zw = float2(0,0);
  r4.xy = (int2)r1.xz + int2(0,-1);
  r4.xyz = t1.Load(r4.xyz).xyz;
  r4.xyz = r4.xyz / cb0[6].xxx;
  r4.xyz = r4.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = min(float3(65504,65504,65504), r4.xyz);
  }
  r4.w = r4.x * 0.5 + r4.y;
  r4.w = r4.z * 0.5 + r4.w;
  r3.w = max(r4.w, r3.w);
  r5.zw = float2(0,0);
  r5.xy = (int2)r1.xz + int2(1,0);
  r5.xyz = t1.Load(r5.xyz).xyz;
  r5.xyz = r5.xyz / cb0[6].xxx;
  r5.xyz = r5.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r5.xyz = min(float3(65504,65504,65504), r5.xyz);
  }
  r5.w = r5.x * 0.5 + r5.y;
  r5.w = r5.z * 0.5 + r5.w;
  r6.zw = float2(0,0);
  r6.xy = (int2)r1.xz + int2(0,1);
  r6.xyz = t1.Load(r6.xyz).xyz;
  r6.xyz = r6.xyz / cb0[6].xxx;
  r6.xyz = r6.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r6.xyz = max(float3(0,0,0), r6.xyz);
  r6.xyz = min(float3(65504,65504,65504), r6.xyz);
  }
  r6.w = r6.x * 0.5 + r6.y;
  r6.w = r6.z * 0.5 + r6.w;
  r7.x = max(r6.w, r5.w);
  r3.w = max(r7.x, r3.w);
  r7.x = min(r2.x, r1.w);
  r2.x = 0.25 * r2.x;
  r2.x = r4.w * 0.25 + r2.x;
  r4.w = min(r7.x, r4.w);
  r2.x = r5.w * 0.25 + r2.x;
  r5.w = min(r6.w, r5.w);
  r2.x = r6.w * 0.25 + r2.x;
  r1.w = r2.x + -r1.w;
  r2.x = min(r5.w, r4.w);
  r2.x = r3.w + -r2.x;
  //r3.w = (int)-r2.x + 0x7ef19fff;
  r3.w = asfloat(2129764351u - asuint(r2.x));
  r2.x = -r3.w * r2.x + 2;
  r2.x = r3.w * r2.x;
  r1.w = saturate(r2.x * abs(r1.w));
  r1.w = r1.w * -0.5 + 1;
  r7.xyz = min(r5.xyz, r0.xyz);
  r7.xyz = min(r7.xyz, r4.xyz);
  r7.xyz = min(r7.xyz, r6.xyz);
  r8.xyz = r7.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r8.xyz = rcp(r8.xyz);
  r9.xyz = max(r5.xyz, r0.xyz);
  r9.xyz = max(r9.xyz, r4.xyz);
  r9.xyz = max(r9.xyz, r6.xyz);
  r10.xyz = float3(1,1,1) + -r9.xyz;
  r9.xyz = float3(4,4,4) * r9.xyz;
  r9.xyz = rcp(r9.xyz);
  r7.xyz = r9.xyz * r7.xyz;
  r8.xyz = r10.xyz * r8.xyz;
  r7.xyz = max(r8.xyz, -r7.xyz);
  r2.x = max(r7.y, r7.z);
  r2.x = max(r7.x, r2.x);
  r2.x = min(0, r2.x);
  r2.x = max(-0.1875, r2.x);
  r2.x = cb1[0].x * r2.x;
  r1.w = r2.x * r1.w;
  r0.xyz = r1.www * r0.xyz;
  r0.xyz = r1.www * r4.xyz + r0.xyz;
  r0.xyz = r1.www * r6.xyz + r0.xyz;
  r0.xyz = r1.www * r5.xyz + r0.xyz;
  r1.w = r1.w * 4 + 1;
  r0.xyz = r0.xyz + r2.yzw;
  //r2.x = (int)-r1.w + 0x7ef19fff;
  r2.x = asfloat(2129764351u - asuint(r1.w));
  r1.w = -r2.x * r1.w + 2;
  r1.w = r2.x * r1.w;
  r0.xyz = r1.www * r0.xyz;
  r0.xyz = r0.xyz / r0.www;
  r2.xyz = cb0[6].xxx * r0.xyz;
  r2.w = 1;
// No code for instruction (needs manual fix):
//store_uav_typed u0.xyzw, r1.xzzz, r2.xyzw
  u0[r1.xz] = r2;
  r2.zw = float2(0,0);
  r4.xyzw = (int4)r1.xyxy + int4(0,-1,-1,0);
  r2.xy = r4.zw;
  r0.xyz = t1.Load(r2.xyz).xyz;
  r0.xyz = r0.xyz / cb0[6].xxx;
  r0.xyz = r0.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  }
  r1.z = r0.x * 0.5 + r0.y;
  r1.z = r0.z * 0.5 + r1.z;
  r1.w = r3.x * 0.5 + r3.y;
  r1.w = r3.z * 0.5 + r1.w;
  r2.x = max(r1.z, r1.w);
  r4.zw = float2(0,0);
  r2.yzw = t1.Load(r4.xyz).xyz;
  r2.yzw = r2.yzw / cb0[6].xxx;
  r2.yzw = r2.yzw * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r2.yzw = max(float3(0,0,0), r2.yzw);
  r2.yzw = min(float3(65504,65504,65504), r2.yzw);
  }
  r3.w = r2.y * 0.5 + r2.z;
  r3.w = r2.w * 0.5 + r3.w;
  r2.x = max(r3.w, r2.x);
  r4.zw = float2(0,0);
  r5.xyzw = (int4)r1.xyxy + int4(0,1,1,0);
  r4.xy = r5.zw;
  r4.xyz = t1.Load(r4.xyz).xyz;
  r4.xyz = r4.xyz / cb0[6].xxx;
  r4.xyz = r4.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = min(float3(65504,65504,65504), r4.xyz);
  }
  r4.w = r4.x * 0.5 + r4.y;
  r4.w = r4.z * 0.5 + r4.w;
  r5.zw = float2(0,0);
  r5.xyz = t1.Load(r5.xyz).xyz;
  r5.xyz = r5.xyz / cb0[6].xxx;
  r5.xyz = r5.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r5.xyz = min(float3(65504,65504,65504), r5.xyz);
  }
  r5.w = r5.x * 0.5 + r5.y;
  r5.w = r5.z * 0.5 + r5.w;
  r6.x = max(r5.w, r4.w);
  r2.x = max(r6.x, r2.x);
  r6.x = min(r1.z, r1.w);
  r1.z = 0.25 * r1.z;
  r1.z = r3.w * 0.25 + r1.z;
  r3.w = min(r6.x, r3.w);
  r1.z = r4.w * 0.25 + r1.z;
  r4.w = min(r5.w, r4.w);
  r1.z = r5.w * 0.25 + r1.z;
  r1.z = r1.z + -r1.w;
  r1.w = min(r4.w, r3.w);
  r1.w = r2.x + -r1.w;
  //r2.x = (int)-r1.w + 0x7ef19fff;
  r2.x = asfloat(2129764351u - asuint(r1.w));
  r1.w = -r2.x * r1.w + 2;
  r1.w = r2.x * r1.w;
  r1.z = saturate(abs(r1.z) * r1.w);
  r1.z = r1.z * -0.5 + 1;
  r6.xyz = min(r4.xyz, r0.xyz);
  r6.xyz = min(r6.xyz, r2.yzw);
  r6.xyz = min(r6.xyz, r5.xyz);
  r7.xyz = r6.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r7.xyz = rcp(r7.xyz);
  r8.xyz = max(r4.xyz, r0.xyz);
  r8.xyz = max(r8.xyz, r2.yzw);
  r8.xyz = max(r8.xyz, r5.xyz);
  r9.xyz = float3(1,1,1) + -r8.xyz;
  r8.xyz = float3(4,4,4) * r8.xyz;
  r8.xyz = rcp(r8.xyz);
  r6.xyz = r8.xyz * r6.xyz;
  r7.xyz = r9.xyz * r7.xyz;
  r6.xyz = max(r7.xyz, -r6.xyz);
  r1.w = max(r6.y, r6.z);
  r1.w = max(r6.x, r1.w);
  r1.w = min(0, r1.w);
  r1.w = max(-0.1875, r1.w);
  r1.w = cb1[0].x * r1.w;
  r1.z = r1.w * r1.z;
  r0.xyz = r1.zzz * r0.xyz;
  r0.xyz = r1.zzz * r2.yzw + r0.xyz;
  r0.xyz = r1.zzz * r5.xyz + r0.xyz;
  r0.xyz = r1.zzz * r4.xyz + r0.xyz;
  r1.z = r1.z * 4 + 1;
  r0.xyz = r0.xyz + r3.xyz;
  //r1.w = (int)-r1.z + 0x7ef19fff;
  r1.w = asfloat(2129764351u - asuint(r1.z));
  r1.z = -r1.w * r1.z + 2;
  r1.z = r1.w * r1.z;
  r0.xyz = r1.zzz * r0.xyz;
  r0.xyz = r0.xyz / r0.www;
  r2.xyz = cb0[6].xxx * r0.xyz;
  r2.w = 1;
// No code for instruction (needs manual fix):
//store_uav_typed u0.xyzw, r1.xyyy, r2.xyzw
  u0[r1.xy] = r2;
  r2.y = r1.y;
  r3.xyz = (int3)r1.xxy + int3(-8,-8,-1);
  r3.w = 0;
  r2.xzw = r3.xww;
  r0.xyz = t1.Load(r3.yzw).xyz;
  r0.xyz = r0.xyz / cb0[6].xxx;
  r0.xyz = r0.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  }
  r3.xyz = t1.Load(r2.xyz).xyz;
  r3.xyz = r3.xyz / cb0[6].xxx;
  r3.xyz = r3.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r3.xyz = min(float3(65504,65504,65504), r3.xyz);
  }
  r1.z = r3.x * 0.5 + r3.y;
  r1.z = r3.z * 0.5 + r1.z;
  r4.xyzw = (int4)r1.xyxy + int4(-7,0,-9,0);
  r5.xy = (int2)r1.xy + int2(-8,1);
  r6.xy = r4.zw;
  r6.zw = float2(0,0);
  r1.xyw = t1.Load(r6.xyz).xyz;
  r1.xyw = r1.xyw / cb0[6].xxx;
  r1.xyw = r1.xyw * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r1.xyw = max(float3(0,0,0), r1.xyw);
  r1.xyw = min(float3(65504,65504,65504), r1.xyw);
  }
  r2.z = r1.x * 0.5 + r1.y;
  r2.z = r1.w * 0.5 + r2.z;
  r2.w = max(r2.z, r1.z);
  r3.w = r0.x * 0.5 + r0.y;
  r3.w = r0.z * 0.5 + r3.w;
  r2.w = max(r3.w, r2.w);
  r4.zw = float2(0,0);
  r4.xyz = t1.Load(r4.xyz).xyz;
  r4.xyz = r4.xyz / cb0[6].xxx;
  r4.xyz = r4.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = min(float3(65504,65504,65504), r4.xyz);
  }
  r4.w = r4.x * 0.5 + r4.y;
  r4.w = r4.z * 0.5 + r4.w;
  r5.zw = float2(0,0);
  r5.xyz = t1.Load(r5.xyz).xyz;
  r5.xyz = r5.xyz / cb0[6].xxx;
  r5.xyz = r5.xyz * r0.www;
  if (injectedData.toneMapType == 0.f) {
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r5.xyz = min(float3(65504,65504,65504), r5.xyz);
  }
  r5.w = r5.x * 0.5 + r5.y;
  r5.w = r5.z * 0.5 + r5.w;
  r6.x = max(r5.w, r4.w);
  r2.w = max(r6.x, r2.w);
  r6.x = min(r5.w, r4.w);
  r6.y = min(r2.z, r1.z);
  r2.z = 0.25 * r2.z;
  r2.z = r3.w * 0.25 + r2.z;
  r3.w = min(r6.y, r3.w);
  r3.w = min(r3.w, r6.x);
  r2.w = -r3.w + r2.w;
  r2.z = r4.w * 0.25 + r2.z;
  r2.z = r5.w * 0.25 + r2.z;
  r1.z = r2.z + -r1.z;
  //r2.z = (int)-r2.w + 0x7ef19fff;
  r2.z = asfloat(2129764351u - asuint(r2.w));
  r2.w = -r2.z * r2.w + 2;
  r2.z = r2.z * r2.w;
  r1.z = saturate(r2.z * abs(r1.z));
  r1.z = r1.z * -0.5 + 1;
  r6.xyz = max(r4.xyz, r1.xyw);
  r6.xyz = max(r6.xyz, r0.xyz);
  r6.xyz = max(r6.xyz, r5.xyz);
  r7.xyz = float3(4,4,4) * r6.xyz;
  r6.xyz = float3(1,1,1) + -r6.xyz;
  r7.xyz = rcp(r7.xyz);
  r8.xyz = min(r4.xyz, r1.xyw);
  r8.xyz = min(r8.xyz, r0.xyz);
  r8.xyz = min(r8.xyz, r5.xyz);
  r7.xyz = r8.xyz * r7.xyz;
  r8.xyz = r8.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r8.xyz = rcp(r8.xyz);
  r6.xyz = r8.xyz * r6.xyz;
  r6.xyz = max(-r7.xyz, r6.xyz);
  r2.z = max(r6.y, r6.z);
  r2.z = max(r6.x, r2.z);
  r2.z = min(0, r2.z);
  r2.z = max(-0.1875, r2.z);
  r2.z = cb1[0].x * r2.z;
  r1.z = r2.z * r1.z;
  r1.xyw = r1.zzz * r1.xyw;
  r0.xyz = r1.zzz * r0.xyz + r1.xyw;
  r0.xyz = r1.zzz * r5.xyz + r0.xyz;
  r0.xyz = r1.zzz * r4.xyz + r0.xyz;
  r1.x = r1.z * 4 + 1;
  r0.xyz = r0.xyz + r3.xyz;
  //r1.y = (int)-r1.x + 0x7ef19fff;
  r1.y = asfloat(2129764351u - asuint(r1.x));
  r1.x = -r1.y * r1.x + 2;
  r1.x = r1.y * r1.x;
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = cb0[6].xxx * r0.xyz;
  r0.w = 1;
// No code for instruction (needs manual fix):
//store_uav_typed u0.xyzw, r2.xyyy, r0.xyzw
  u0[r2.xy] = r0;
  return;
}