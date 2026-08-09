#include "../common.hlsl"

struct u0_t {
  float val[4];
};
RWStructuredBuffer<u0_t> u0 : register(u0);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture2D<float4> u1 : register(u1);

[numthreads(64, 1, 1)]
void main(uint3 vThreadIDInGroup: SV_GroupThreadID, uint3 vThreadGroupID: SV_GroupID, uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (uint)vThreadIDInGroup.x >> 3;
  bitmask.y = ((~(-1 << 1)) << 0) & 0xffffffff;  r0.y = (((uint)vThreadIDInGroup.x << 0) & bitmask.y) | ((uint)r0.x & ~bitmask.y);
  bitmask.z = ((~(-1 << 1)) << 0) & 0xffffffff;  r0.z = (((uint)vThreadIDInGroup.x << 0) & bitmask.z) | ((uint)r0.x & ~bitmask.z);
  bitmask.w = ((~(-1 << 1)) << 0) & 0xffffffff;  r0.w = (((uint)vThreadIDInGroup.x << 0) & bitmask.w) | ((uint)r0.x & ~bitmask.w);
  if (3 == 0) r0.x = 0; else if (3+1 < 32) {   r0.x = (uint)vThreadIDInGroup.x << (32-(3 + 1)); r0.x = (uint)r0.x >> (32-3);  } else r0.x = (uint)vThreadIDInGroup.x >> 1;
  r0.xyzw = mad((int4)vThreadGroupID.xyyy, int4(8,8,8,8), (int4)r0.xyzw);
  r1.xy = (uint2)r0.xw;
  r2.x = u0[0].val[0/4];
  r2.y = u0[0].val[0/4+1];
  r2.z = u0[0].val[0/4+2];
  r2.w = u0[0].val[0/4+3];
  r1.xy = r1.xy * r2.xy + r2.zw;
  r1.zw = floor(r1.xy);
  r1.xy = r1.xy + -r1.zw;
  r2.x = u0[1].val[0/4];
  r2.y = u0[1].val[0/4+1];
  r2.z = u0[1].val[0/4+2];
  r2.w = u0[1].val[0/4+3];
  r1.zw = r1.zw * r2.xy + r2.zw;
  r2.xy = t0.GatherGreen(s0_s, r1.zw).xy;
  if(injectedData.toneMapType == 0.f){
  r2.zw = log2(abs(r2.xy));
  r2.xyzw = float4(12.9200001,12.9200001,0.416666657,0.416666657) * r2.xyzw;
  r2.xy = max(float2(0.0404499359,0.0404499359), r2.xy);
  r2.zw = exp2(r2.zw);
  r2.zw = r2.zw * float2(1.05499995,1.05499995) + float2(-0.0549999997,-0.0549999997);
  r2.xy = min(r2.xy, r2.zw);
  } else {
    r2.xy = renodx::math::SignSqrt(r2.xy);
  }
  r3.z = r2.x;
  r4.xy = t0.GatherBlue(s0_s, r1.zw).xy;
  if(injectedData.toneMapType == 0.f){
  r4.zw = log2(abs(r4.xy));
  r4.xyzw = float4(12.9200001,12.9200001,0.416666657,0.416666657) * r4.xyzw;
  r4.xy = max(float2(0.0404499359,0.0404499359), r4.xy);
  r4.zw = exp2(r4.zw);
  r4.zw = r4.zw * float2(1.05499995,1.05499995) + float2(-0.0549999997,-0.0549999997);
  r4.xy = min(r4.xy, r4.zw);
  } else {
    r4.xy = renodx::math::SignSqrt(r4.xy);
  }
  r3.w = r4.x;
  r4.zw = t0.GatherRed(s0_s, r1.zw).xy;
  if(injectedData.toneMapType == 0.f){
  r5.xy = log2(abs(r4.zw));
  r4.zw = float2(12.9200001,12.9200001) * r4.zw;
  r4.zw = max(float2(0.0404499359,0.0404499359), r4.zw);
  r5.xy = float2(0.416666657,0.416666657) * r5.xy;
  r5.xy = exp2(r5.xy);
  r5.xy = r5.xy * float2(1.05499995,1.05499995) + float2(-0.0549999997,-0.0549999997);
  r3.xy = min(r5.xy, r4.zw);
  } else {
    r3.xy = renodx::math::SignSqrt(r4.zw);
  }
  r2.w = r4.y;
  r2.z = r3.y;
  r4.z = u0[3].val[0/4];
  r4.w = u0[3].val[0/4+1];
  r4.zw = r4.zw + r1.zw;
  r5.xy = t0.GatherRed(s0_s, r4.zw).zw;
  if(injectedData.toneMapType == 0.f){
  r5.zw = log2(abs(r5.xy));
  r5.xyzw = float4(12.9200001,12.9200001,0.416666657,0.416666657) * r5.xyzw;
  r5.xy = max(float2(0.0404499359,0.0404499359), r5.xy);
  r5.zw = exp2(r5.zw);
  r5.zw = r5.zw * float2(1.05499995,1.05499995) + float2(-0.0549999997,-0.0549999997);
  r5.xy = min(r5.xy, r5.zw);
  } else {
    r5.xy = renodx::math::SignSqrt(r5.xy);
  }
  r6.xy = t0.GatherGreen(s0_s, r4.zw).zw;
  r4.zw = t0.GatherBlue(s0_s, r4.zw).zw;
  if(injectedData.toneMapType == 0.f){
  r6.zw = log2(abs(r6.xy));
  r6.xyzw = float4(12.9200001,12.9200001,0.416666657,0.416666657) * r6.xyzw;
  r6.xy = max(float2(0.0404499359,0.0404499359), r6.xy);
  r6.zw = exp2(r6.zw);
  r6.zw = r6.zw * float2(1.05499995,1.05499995) + float2(-0.0549999997,-0.0549999997);
  r6.xy = min(r6.xy, r6.zw);
  } else {
    r6.xy = renodx::math::SignSqrt(r6.xy);
  }
  r7.xy = r5.xy * float2(0.5,0.5) + r6.xy;
  if(injectedData.toneMapType == 0.f){
  r7.zw = log2(abs(r4.zw));
  r4.zw = float2(12.9200001,12.9200001) * r4.zw;
  r4.zw = max(float2(0.0404499359,0.0404499359), r4.zw);
  r7.zw = float2(0.416666657,0.416666657) * r7.zw;
  r7.zw = exp2(r7.zw);
  r7.zw = r7.zw * float2(1.05499995,1.05499995) + float2(-0.0549999997,-0.0549999997);
  r4.zw = min(r7.zw, r4.zw);
  } else {
    r4.zw = renodx::math::SignSqrt(r4.zw);
  }
  r7.xy = r4.zw * float2(0.5,0.5) + r7.xy;
  r8.x = u0[2].val[0/4];
  r8.y = u0[2].val[0/4+1];
  r8.z = u0[2].val[0/4+2];
  r8.w = u0[2].val[0/4+3];
  r8.xyzw = r8.xyzw + r1.zwzw;
  r9.xyzw = t0.GatherRed(s0_s, r8.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r10.xyzw = log2(abs(r9.zwyx));
  r9.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r9.zwyx;
  r9.xyzw = max(float4(0.0404499359,0.0404499359,0.0404499359,0.0404499359), r9.xyzw);
  r10.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r10.xyzw;
  r10.xyzw = exp2(r10.xyzw);
  r10.xyzw = r10.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r9.xyzw = min(r10.yxzw, r9.yxzw);
  } else {
    r9.yxzw = renodx::math::SignSqrt(r9.zwyx);
  }
  r10.xyzw = t0.GatherGreen(s0_s, r8.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r11.xyzw = log2(abs(r10.zwyx));
  r10.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r10.zwyx;
  r10.xyzw = max(float4(0.0404499359,0.0404499359,0.0404499359,0.0404499359), r10.xyzw);
  r11.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r11.xyzw;
  r11.xyzw = exp2(r11.xyzw);
  r11.xyzw = r11.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r10.xyzw = min(r11.xyzw, r10.xyzw);
  } else {
    r10.xyzw = renodx::math::SignSqrt(r10.zwyx);
  }
  r11.xyzw = r9.yxzw * float4(0.5,0.5,0.5,0.5) + r10.xyzw;
  r12.xyzw = t0.GatherBlue(s0_s, r8.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r13.xyzw = log2(abs(r12.zwyx));
  r12.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r12.zwyx;
  r12.xyzw = max(float4(0.0404499359,0.0404499359,0.0404499359,0.0404499359), r12.xyzw);
  r13.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r13.xyzw;
  r13.xyzw = exp2(r13.xyzw);
  r13.xyzw = r13.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r12.xyzw = min(r13.xyzw, r12.xyzw);
  } else {
    r12.xyzw = renodx::math::SignSqrt(r12.zwyx);
  }
  r11.xyzw = r12.xyzw * float4(0.5,0.5,0.5,0.5) + r11.xyzw;
  r1.zw = -r11.zx + r7.yy;
  r7.yzw = r11.xzz + -r11.yxw;
  r1.z = max(abs(r7.z), abs(r1.z));
  r1.z = asfloat(2129690299u - asuint(r1.z));
  r1.z = saturate(abs(r1.w) * r1.z);
  r1.z = r1.z * r1.z;
  r8.xy = r3.xy * float2(0.5,0.5) + r2.xy;
  r4.xy = r4.xy * float2(0.5,0.5) + r8.xy;
  r13.xyzw = t0.GatherRed(s0_s, r8.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r14.xyzw = log2(abs(r13.xyzw));
  r13.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r13.xyzw;
  r13.xyzw = max(float4(0.0404499359,0.0404499359,0.0404499359,0.0404499359), r13.xyzw);
  r14.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r14.xyzw;
  r14.xyzw = exp2(r14.xyzw);
  r14.xyzw = r14.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r13.xyzw = min(r14.xyzw, r13.xyzw);
  } else {
    r13.xyzw = renodx::math::SignSqrt(r13.xyzw);
  }
  r14.xyzw = t0.GatherGreen(s0_s, r8.zw).xyzw;
  r8.xyzw = t0.GatherBlue(s0_s, r8.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r15.xyzw = log2(abs(r14.xyzw));
  r14.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r14.xyzw;
  r14.xyzw = max(float4(0.0404499359,0.0404499359,0.0404499359,0.0404499359), r14.xyzw);
  r15.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r15.xyzw;
  r15.xyzw = exp2(r15.xyzw);
  r15.xyzw = r15.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r14.xyzw = min(r15.xzyw, r14.xzyw);
  } else {
    r14.xzyw = renodx::math::SignSqrt(r14.xyzw);
  }
  r15.xyzw = r13.xyzw * float4(0.5,0.5,0.5,0.5) + r14.xzyw;
  if(injectedData.toneMapType == 0.f){
  r16.xyzw = log2(abs(r8.xyzw));
  r8.xyzw = float4(12.9200001,12.9200001,12.9200001,12.9200001) * r8.xyzw;
  r8.xyzw = max(float4(0.0404499359,0.0404499359,0.0404499359,0.0404499359), r8.xyzw);
  r16.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r16.xyzw;
  r16.xyzw = exp2(r16.xyzw);
  r16.xyzw = r16.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r8.xyzw = min(r16.xywz, r8.xywz);
  } else {
    r8.xywz = renodx::math::SignSqrt(r8.xyzw);
  }
  r15.xyzw = r8.xywz * float4(0.5,0.5,0.5,0.5) + r15.xyzw;
  r16.xy = r15.wx + -r4.yy;
  r4.xy = r11.xz + -r4.xx;
  r17.xyz = r15.zxy + -r15.wwx;
  r2.x = max(abs(r17.y), abs(r16.x));
  r2.x = asfloat(2129690299u - asuint(r2.x));
  r2.x = saturate(abs(r16.y) * r2.x);
  r2.x = r2.x * r2.x;
  r3.y = max(abs(r7.z), abs(r4.x));
  r3.y = asfloat(2129690299u - asuint(r3.y));
  r3.y = saturate(abs(r4.y) * r3.y);
  r3.y = r3.y * r3.y;
  r18.xyzw = float4(1,1,0,-1) + -r1.xyxy;
  r4.x = r18.x * r18.y;
  r3.y = r4.x * r3.y;
  r19.xyzw = r15.wwzx + -r11.xyxz;
  r11.xy = r15.xy + -r11.wz;
  r7.xz = -r15.xw + r7.xx;
  r7.yw = max(abs(r19.xw), abs(r7.yw));
  r7.yw = asfloat(2129690299u - asuint(r7.yw));
  r7.y = saturate(abs(r19.y) * r7.y);
  r7.w = saturate(abs(r11.x) * r7.w);
  r7.yw = r7.yw * r7.yw;
  r3.y = r7.y * r4.x + r3.y;
  r11.zw = max(abs(r19.xw), abs(r17.xz));
  r7.x = max(abs(r7.x), abs(r17.y));
  r7.x = asfloat(2129690299u - asuint(r7.x));
  r7.x = saturate(abs(r7.z) * r7.x);
  r11.zw = asfloat(2129690299u - asuint(r11.zw));
  r7.y = saturate(abs(r19.z) * r11.z);
  r11.z = saturate(abs(r11.y) * r11.w);
  r11.z = r11.z * r11.z;
  r7.xy = r7.xy * r7.xy;
  r15.xy = r18.yx * r1.xy;
  r3.y = r7.y * r15.x + r3.y;
  r2.x = r2.x * r15.x + r3.y;
  r2.x = r7.w * r15.y + r2.x;
  r1.z = r1.z * r15.y + r2.x;
  r2.x = r1.x * r1.y;
  r1.z = r11.z * r2.x + r1.z;
  r1.z = r7.x * r2.x + r1.z;
  r1.z = 0.5 * r1.z;
  r1.z = r1.z * r1.z;
  r17.yz = r1.zz * float2(-0.5,-0.289999992) + float2(1,0.5);
  r3.y = r16.y * r15.x;
  r3.y = r4.y * r4.x + r3.y;
  r1.w = r1.w * r15.y + r3.y;
  r7.z = r7.z * r2.x + r1.w;
  r1.w = r19.z * r15.x;
  r1.w = r19.y * r4.x + r1.w;
  r1.w = r11.x * r15.y + r1.w;
  r7.y = r11.y * r2.x + r1.w;
  r4.xy = r7.yz * r7.yz;
  r1.w = r4.x + r4.y;
  r2.x = asfloat(1597275508u - (asuint(r1.w) >> 1u));
  r2.x = r1.w < 3.05175781e-05 ? 1 : r2.x;
  r7.x = r1.w < 3.05175781e-05 ? 1 : r7.y;
  r4.xy = r7.xz * r2.xx;
  r1.w = max(abs(r4.x), abs(r4.y));
  r1.w = asfloat(2129690299u - asuint(r1.w));
  r2.x = dot(r4.xy, r4.xy);
  r1.w = r2.x * r1.w + -1;
  r17.x = r1.w * r1.z + 1;
  r7.xyzw = float4(1,-1,-1,1) + -r1.xyxy;
  r1.zw = r7.yw * r4.xx;
  r11.zw = r7.xz * -r4.yy + r1.zw;
  r11.y = dot(r7.xy, r4.xy);
  r11.x = dot(r7.zw, r4.xy);
  r1.zw = r11.xw * r17.xy;
  r7.xy = r11.yz * r17.xy;
  r2.x = dot(r7.xy, r7.xy);
  r1.z = dot(r1.zw, r1.zw);
  r1.w = asfloat(2129690299u - asuint(r17.z));
  r2.x = min(r2.x, r1.w);
  r3.y = r17.z * r2.x + -1;
  r2.x = r2.x * 0.4 + -1;
  r2.x = r2.x * r2.x;
  r2.x = r2.x * 1.5625 + -0.5625;
  r3.y = r3.y * r3.y;
  r2.x = r3.y * r2.x;
  r2.yzw = r2.zyw * r2.xxx;
  r3.y = r18.w * r4.x;
  r7.y = r18.z * -r4.y + r3.y;
  r7.x = dot(r18.zw, r4.xy);
  r7.xy = r7.xy * r17.xy;
  r3.y = dot(r7.xy, r7.xy);
  r3.y = min(r3.y, r1.w);
  r7.x = r17.z * r3.y + -1;
  r3.y = r3.y * 0.4 + -1;
  r3.y = r3.y * r3.y;
  r3.y = r3.y * 1.5625 + -0.5625;
  r7.x = r7.x * r7.x;
  r7.y = r7.x * r3.y;
  r2.x = r3.y * r7.x + r2.x;
  r2.yzw = r3.xzw * r7.yyy + r2.yzw;
  r1.z = min(r1.z, r1.w);
  r3.x = r17.z * r1.z + -1;
  r1.z = r1.z * 0.4 + -1;
  r1.z = r1.z * r1.z;
  r1.z = r1.z * 1.5625 + -0.5625;
  r3.x = r3.x * r3.x;
  r3.y = r3.x * r1.z;
  r1.z = r1.z * r3.x + r2.x;
  r7.x = r9.w;
  r7.y = r10.w;
  r7.z = r12.w;
  r2.xyz = r7.xyz * r3.yyy + r2.yzw;
  r3.xyzw = float4(0,1,-1,0) + -r1.xyxy;
  r7.xy = r3.yw * r4.xx;
  r7.zw = r3.xz * -r4.yy + r7.xy;
  r7.y = dot(r3.xy, r4.xy);
  r7.x = dot(r3.zw, r4.xy);
  r3.xyzw = r7.xwyz * r17.xyxy;
  r2.w = dot(r3.zw, r3.zw);
  r2.w = min(r2.w, r1.w);
  r3.x = dot(r3.xy, r3.xy);
  r3.x = min(r3.x, r1.w);
  r3.y = r17.z * r2.w + -1;
  r2.w = r2.w * 0.4 + -1;
  r2.w = r2.w * r2.w;
  r2.w = r2.w * 1.5625 + -0.5625;
  r3.y = r3.y * r3.y;
  r3.z = r3.y * r2.w;
  r1.z = r2.w * r3.y + r1.z;
  r7.x = r9.z;
  r7.y = r10.z;
  r7.z = r12.z;
  r2.xyz = r7.xyz * r3.zzz + r2.xyz;
  r2.w = r4.x * -r1.y;
  r11.y = r1.x * r4.y + r2.w;
  r11.x = dot(-r1.xy, r4.xy);
  r3.yz = r11.xy * r17.xy;
  r2.w = dot(r3.yz, r3.yz);
  r2.w = min(r2.w, r1.w);
  r3.y = r17.z * r2.w + -1;
  r2.w = r2.w * 0.4 + -1;
  r2.w = r2.w * r2.w;
  r2.w = r2.w * 1.5625 + -0.5625;
  r3.y = r3.y * r3.y;
  r3.z = r3.y * r2.w;
  r1.z = r2.w * r3.y + r1.z;
  r11.x = r9.y;
  r11.y = r10.x;
  r9.y = r10.y;
  r11.z = r12.x;
  r9.z = r12.y;
  r2.xyz = r11.xyz * r3.zzz + r2.xyz;
  r2.w = r17.z * r3.x + -1;
  r3.x = r3.x * 0.4 + -1;
  r3.x = r3.x * r3.x;
  r3.x = r3.x * 1.5625 + -0.5625;
  r2.w = r2.w * r2.w;
  r3.y = r3.x * r2.w;
  r1.z = r3.x * r2.w + r1.z;
  r2.xyz = r9.xyz * r3.yyy + r2.xyz;
  r3.xyzw = float4(1,1,2,1) + -r1.xyxy;
  r9.xy = r3.yw * r4.xx;
  r9.zw = r3.xz * -r4.yy + r9.xy;
  r9.y = dot(r3.xy, r4.xy);
  r9.x = dot(r3.zw, r4.xy);
  r3.xyzw = r9.xwyz * r17.xyxy;
  r2.w = dot(r3.zw, r3.zw);
  r2.w = min(r2.w, r1.w);
  r3.x = dot(r3.xy, r3.xy);
  r3.x = min(r3.x, r1.w);
  r3.y = r17.z * r2.w + -1;
  r2.w = r2.w * 0.4 + -1;
  r2.w = r2.w * r2.w;
  r2.w = r2.w * 1.5625 + -0.5625;
  r3.y = r3.y * r3.y;
  r3.z = r3.y * r2.w;
  r1.z = r2.w * r3.y + r1.z;
  r9.x = r13.x;
  r9.y = r14.x;
  r9.z = r8.x;
  r2.xyz = r9.xyz * r3.zzz + r2.xyz;
  r2.w = r17.z * r3.x + -1;
  r3.x = r3.x * 0.4 + -1;
  r3.x = r3.x * r3.x;
  r3.x = r3.x * 1.5625 + -0.5625;
  r2.w = r2.w * r2.w;
  r3.y = r3.x * r2.w;
  r1.z = r3.x * r2.w + r1.z;
  r10.x = r13.y;
  r10.y = r14.z;
  r10.z = r8.y;
  r2.xyz = r10.xyz * r3.yyy + r2.xyz;
  r3.xyzw = float4(2,0,1,0) + -r1.xyxy;
  r10.xyzw = float4(1,2,0,2) + -r1.xyxy;
  r1.xy = r3.yw * r4.xx;
  r12.zw = r3.xz * -r4.yy + r1.xy;
  r12.y = dot(r3.xy, r4.xy);
  r12.x = dot(r3.zw, r4.xy);
  r1.xy = r12.xw * r17.xy;
  r3.xy = r12.yz * r17.xy;
  r2.w = dot(r3.xy, r3.xy);
  r2.w = min(r2.w, r1.w);
  r1.x = dot(r1.xy, r1.xy);
  r1.x = min(r1.x, r1.w);
  r1.y = r17.z * r2.w + -1;
  r2.w = r2.w * 0.4 + -1;
  r2.w = r2.w * r2.w;
  r2.w = r2.w * 1.5625 + -0.5625;
  r1.y = r1.y * r1.y;
  r3.x = r2.w * r1.y;
  r1.y = r2.w * r1.y + r1.z;
  r14.x = r13.z;
  r8.x = r13.w;
  r8.y = r14.w;
  r14.z = r8.w;
  r2.xyz = r14.xyz * r3.xxx + r2.xyz;
  r1.z = r17.z * r1.x + -1;
  r1.x = r1.x * 0.4 + -1;
  r1.xz = r1.xz * r1.xz;
  r1.x = r1.x * 1.5625 + -0.5625;
  r2.w = r1.x * r1.z;
  r1.x = r1.x * r1.z + r1.y;
  r2.xyz = r8.xyz * r2.www + r2.xyz;
  r5.z = r6.x;
  r5.w = r4.z;
  r6.w = r4.w;
  r1.yz = r10.yw * r4.xx;
  r3.zw = r10.xz * -r4.yy + r1.yz;
  r3.y = dot(r10.xy, r4.xy);
  r3.x = dot(r10.zw, r4.xy);
  r1.yz = r3.xw * r17.xy;
  r3.xy = r3.yz * r17.xy;
  r2.w = dot(r3.xy, r3.xy);
  r2.w = min(r2.w, r1.w);
  r1.y = dot(r1.yz, r1.yz);
  r1.y = min(r1.y, r1.w);
  r1.z = r17.z * r2.w + -1;
  r1.w = r2.w * 0.4 + -1;
  r1.zw = r1.zw * r1.zw;
  r1.w = r1.w * 1.5625 + -0.5625;
  r2.w = r17.z * r1.y + -1;
  r1.y = r1.y * 0.4 + -1;
  r1.y = r1.y * r1.y;
  r1.y = r1.y * 1.5625 + -0.5625;
  r2.w = r2.w * r2.w;
  r3.x = r1.w * r1.z;
  r1.x = r1.w * r1.z + r1.x;
  r1.x = r1.y * r2.w + r1.x;
  r1.y = r2.w * r1.y;
  r1.x = rcp(r1.x);
  r2.xyz = r5.xzw * r3.xxx + r2.xyz;
  r6.z = r5.y;
  r1.yzw = r6.zyw * r1.yyy + r2.xyz;
  r1.xyz = r1.yzw * r1.xxx;
  r2.xyz = min(r8.xyz, r7.xyz);
  r3.xyz = max(r8.xyz, r7.xyz);
  r3.xyz = max(r11.xyz, r3.xyz);
  r2.xyz = min(r11.xyz, r2.xyz);
  r2.xyz = min(r2.xyz, r9.xyz);
  r3.xyz = max(r3.xyz, r9.xyz);
  r1.xyz = max(r2.xyz, r1.xyz);
  r1.xyz = min(r3.xyz, r1.xyz);
  if(injectedData.toneMapType == 0.f){
  r1.xyz = renodx::color::srgb::Decode(r1.xyz);
  } else {
    r1.xyz = sign(r1.xyz) * r1.xyz * r1.xyz;
  }
  r1.w = 1;
  u1[uint2(r0.xy)] = r1;
  return;
}