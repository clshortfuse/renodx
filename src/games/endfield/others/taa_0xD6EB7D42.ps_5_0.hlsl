// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 22:02:47 2025

// TAA shader - nothing done

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[12];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[93];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 27, 0, 0, 0},
                              { 54, 0, 0, 0},
                              { 216, 0, 0, 0},
                              { 432, 0, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[7].zw * v0.xy;
  r0.zw = cb1[8].xy * v0.xy;
  r0.zw = floor(r0.zw);
  r0.zw = (int2)r0.zw;
  r1.xy = v0.xy * cb1[8].xy + -cb0[85].xy;
  r1.zw = cb1[6].xy + float2(-0.5,-0.5);
  r1.xy = max(float2(0.5,0.5), r1.xy);
  r1.xy = min(r1.xy, r1.zw);
  r1.xy = floor(r1.xy);
  r2.xy = (int2)r1.xy;
  r1.xy = float2(0.5,0.5) + r1.xy;
  r1.xy = cb1[6].zw * r1.xy;
  r1.x = t1.SampleBias(s0_s, r1.xy, cb0[92].x).x;
  r2.zw = float2(0,0);
  r3.xyzw = t2.Load(r2.xyz).xyzw;
  r1.yz = abs(r3.xy) * float2(2,2) + float2(-1,-1);
  r1.yz = r1.yz * r1.yz;
  r1.yz = r1.yz * r1.yz;
  r4.xyzw = float4(-0.5,-0.5,-0.600000024,-0.300000012) + r3.xyww;
  r2.zw = cmp(float2(0,0) < r4.xy);
  r3.xy = cmp(r4.xy < float2(0,0));
  r2.zw = (int2)-r2.zw + (int2)r3.xy;
  r2.zw = (int2)r2.zw;
  r1.yz = r2.zw * r1.yz;
  r2.zw = v0.xy * cb1[7].zw + -r1.yz;
  r1.w = cmp(0.899999976 < r3.w);
  r3.x = r1.w ? 1.000000 : 0;
  r3.yw = cmp(abs(r4.zw) < float2(0.100000001,0.100000001));
  r4.xy = r3.yy ? r0.zw : r2.xy;
  r5.xy = (int2)r4.xy + int2(-1,-1);
  r5.zw = float2(0,0);
  r5.xyz = t0.Load(r5.xyz).xyz;
  r5.xyz = min(float3(0,0,0), -r5.xyz);
  r6.w = dot(-r5.xzy, float3(1,1,2));
  r7.y = dot(-r5.xz, float2(2,-2));
  r7.z = dot(-r5.xzy, float3(-1,-1,2));
  r8.xy = (int2)r4.xy + int2(0,-1);
  r8.zw = float2(0,0);
  r8.xyz = t0.Load(r8.xyz).xyz;
  r8.xyz = min(float3(0,0,0), -r8.xyz);
  r9.x = dot(-r8.xzy, float3(1,1,2));
  r9.y = dot(-r8.xz, float2(2,-2));
  r9.z = dot(-r8.xzy, float3(-1,-1,2));
  r10.xy = (int2)r4.xy + int2(1,-1);
  r10.zw = float2(0,0);
  r10.xyz = t0.Load(r10.xyz).xyz;
  r10.xyz = min(float3(0,0,0), -r10.xyz);
  r11.x = dot(-r10.xzy, float3(1,1,2));
  r11.y = dot(-r10.xz, float2(2,-2));
  r11.z = dot(-r10.xzy, float3(-1,-1,2));
  r12.xy = (int2)r4.xy + int2(-1,0);
  r12.zw = float2(0,0);
  r12.xyz = t0.Load(r12.xyz).xyz;
  r12.xyz = min(float3(0,0,0), -r12.xyz);
  r13.x = dot(-r12.xzy, float3(1,1,2));
  r13.y = dot(-r12.xz, float2(2,-2));
  r13.z = dot(-r12.xzy, float3(-1,-1,2));
  r4.zw = float2(0,0);
  r14.xyz = t0.Load(r4.xyw).xyz;
  r14.xyz = min(float3(0,0,0), -r14.xyz);
  r15.x = dot(-r14.xzy, float3(1,1,2));
  r15.y = dot(-r14.xz, float2(2,-2));
  r15.z = dot(-r14.xzy, float3(-1,-1,2));
  r16.xyzw = (int4)r4.xyww + int4(1,0,0,0);
  r16.xyz = t0.Load(r16.xyz).xyz;
  r16.xyz = min(float3(0,0,0), -r16.xyz);
  r17.x = dot(-r16.xzy, float3(1,1,2));
  r17.y = dot(-r16.xz, float2(2,-2));
  r17.z = dot(-r16.xzy, float3(-1,-1,2));
  r18.xyzw = (int4)r4.xyww + int4(-1,1,0,0);
  r18.xyz = t0.Load(r18.xyz).xyz;
  r18.xyz = min(float3(0,0,0), -r18.xyz);
  r19.x = dot(-r18.xzy, float3(1,1,2));
  r19.y = dot(-r18.xz, float2(2,-2));
  r19.z = dot(-r18.xzy, float3(-1,-1,2));
  r20.xyzw = (int4)r4.xyww + int4(0,1,0,0);
  r20.xyz = t0.Load(r20.xyz).xyz;
  r20.xyz = min(float3(0,0,0), -r20.xyz);
  r21.x = dot(-r20.xzy, float3(1,1,2));
  r21.y = dot(-r20.xz, float2(2,-2));
  r21.z = dot(-r20.xzy, float3(-1,-1,2));
  r4.xyzw = (int4)r4.xyzw + int4(1,1,0,0);
  r4.xyz = t0.Load(r4.xyz).xyz;
  r4.xyz = min(float3(0,0,0), -r4.xyz);
  r22.x = dot(-r4.xzy, float3(1,1,2));
  r22.y = dot(-r4.xz, float2(2,-2));
  r22.z = dot(-r4.xzy, float3(-1,-1,2));
  r8.xyz = cb1[9].yyy * -r8.xyz;
  r5.xyz = -r5.xyz * cb1[9].xxx + r8.xyz;
  r5.xyz = -r10.xyz * cb1[9].zzz + r5.xyz;
  r5.xyz = -r12.xyz * cb1[9].www + r5.xyz;
  r5.xyz = -r14.xyz * cb1[10].xxx + r5.xyz;
  r5.xyz = -r16.xyz * cb1[10].yyy + r5.xyz;
  r5.xyz = -r18.xyz * cb1[10].zzz + r5.xyz;
  r5.xyz = -r20.xyz * cb1[10].www + r5.xyz;
  r4.xyz = -r4.xyz * cb1[11].xxx + r5.xyz;
  r0.z = cb1[9].x + cb1[9].y;
  r0.z = cb1[9].z + r0.z;
  r0.z = cb1[9].w + r0.z;
  r0.z = cb1[10].x + r0.z;
  r0.z = cb1[10].y + r0.z;
  r0.z = cb1[10].z + r0.z;
  r0.z = cb1[10].w + r0.z;
  r0.z = cb1[11].x + r0.z;
  r0.z = 1 / r0.z;
  r4.xyz = r4.xyz * r0.zzz;
  r5.x = dot(r4.xzy, float3(1,1,2));
  r0.zw = r2.zw * cb1[7].xy + float2(-0.5,-0.5);
  r0.zw = floor(r0.zw);
  r8.xyzw = float4(0.5,0.5,-0.5,-0.5) + r0.zwzw;
  r2.xy = r2.wz * cb1[7].yx + -r8.yx;
  r10.xy = r2.yx * r2.yx;
  r10.zw = r10.xy * r2.yx;
  r12.xy = r10.yx * r2.xy + r2.xy;
  r12.xy = -r12.xy * float2(0.5,0.5) + r10.yx;
  r12.zw = float2(2.5,2.5) * r10.yx;
  r10.zw = r10.wz * float2(1.5,1.5) + -r12.zw;
  r10.zw = float2(1,1) + r10.zw;
  r2.xy = r10.xy * r2.yx + -r10.xy;
  r10.xy = float2(0.5,0.5) * r2.xy;
  r12.zw = float2(1,1) + -r12.yx;
  r12.zw = r12.zw + -r10.wz;
  r2.xy = -r2.xy * float2(0.5,0.5) + r12.zw;
  r10.zw = r10.zw + r2.yx;
  r14.zw = cb1[7].zw * r8.zw;
  r8.zw = float2(1,1) / r10.wz;
  r2.xy = r2.xy * r8.zw + r8.xy;
  r14.xy = cb1[7].zw * r2.xy;
  r0.zw = float2(2.5,2.5) + r0.zw;
  r8.xw = saturate(cb1[7].zw * r0.zw);
  r0.zw = r10.wz * r12.xy;
  r2.x = r10.w * r10.z;
  r12.xy = r10.xy * r10.zw;
  r16.xyzw = saturate(r14.xwzy);
  r18.xyz = t4.SampleLevel(s1_s, r16.xy, 0).xyz;
  r2.y = dot(r18.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.y = 1 + r2.y;
  r18.xyz = r18.xyz / r2.yyy;
  r16.xyz = t4.SampleLevel(s1_s, r16.zw, 0).xyz;
  r2.y = dot(r16.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.y = 1 + r2.y;
  r16.xyz = r16.xyz / r2.yyy;
  r16.xyz = r16.xyz * r0.www;
  r16.xyz = r18.xyz * r0.zzz + r16.xyz;
  r12.zw = saturate(r14.xy);
  r18.xyz = t4.SampleLevel(s1_s, r12.zw, 0).xyz;
  r2.y = dot(r18.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.y = 1 + r2.y;
  r18.xyz = r18.xyz / r2.yyy;
  r16.xyz = r18.xyz * r2.xxx + r16.xyz;
  r8.yz = saturate(r14.yx);
  r14.xyz = t4.SampleLevel(s1_s, r8.xy, 0).xyz;
  r2.x = dot(r14.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.x = 1 + r2.x;
  r14.xyz = r14.xyz / r2.xxx;
  r12.xzw = r14.xyz * r12.xxx + r16.xyz;
  r8.xyz = t4.SampleLevel(s1_s, r8.zw, 0).xyz;
  r2.x = dot(r8.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.x = 1 + r2.x;
  r8.xyz = r8.xyz / r2.xxx;
  r8.xyz = r8.xyz * r12.yyy + r12.xzw;
  r0.z = r0.z + r0.w;
  r0.z = r10.w * r10.z + r0.z;
  r0.z = r10.x * r10.z + r0.z;
  r0.z = r10.y * r10.w + r0.z;
  r0.z = 1 / r0.z;
  r8.xyz = r8.xyz * r0.zzz;
  r10.xyzw = t4.SampleLevel(s1_s, r2.zw, 0).xyzw;
  r0.z = dot(r8.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.z = 1 + -r0.z;
  r8.xyz = r8.xyz / r0.zzz;
  r12.xyzw = float4(0.200000003,0.200000003,0.200000003,0.899999976) * r10.xyzw;
  r10.xyz = float3(1.79999995,1.79999995,1.79999995) * r10.xyz;
  r8.xyz = max(r12.xyz, r8.xyz);
  r8.xyz = min(r8.xyz, r10.xyz);
  r10.x = dot(r8.xzy, float3(1,1,2));
  r10.y = dot(r8.xz, float2(2,-2));
  r10.z = dot(r8.xzy, float3(-1,-1,2));
  r0.z = r3.z * 1023 + 0.5;
  r0.z = (uint)r0.z;
  if (1 == 0) r0.z = 0; else if (1+1 < 32) {   r0.z = (uint)r0.z << (32-(1 + 1)); r0.z = (uint)r0.z >> (32-1);  } else r0.z = (uint)r0.z >> 1;
  r0.z = (uint)r0.z;
  r2.xy = -cb1[7].zw + float2(1,1);
  r2.xy = cmp(r2.xy < r2.zw);
  r0.w = (int)r2.y | (int)r2.x;
  r2.xy = cmp(r2.zw < cb1[7].zw);
  r2.x = (int)r2.y | (int)r2.x;
  r0.w = (int)r0.w | (int)r2.x;
  r2.x = (int)r0.w & 0x3f800000;
  r2.y = max(r15.x, r6.w);
  r2.z = min(r15.x, r6.w);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r6.z = min(100000, r6.w);
  r6.y = 16;
  r8.yzw = r2.yyy ? float3(2.38220739e-044,100000,0) : r6.yzw;
  r2.z = max(r15.x, r9.x);
  r2.w = min(r15.x, r9.x);
  r2.z = r2.z / r2.w;
  r2.w = cmp(0 < r2.z);
  r2.z = cmp(r2.z < 1.89999998);
  r2.z = r2.z ? r2.w : 0;
  r8.x = r2.y ? 19 : 18;
  r14.z = min(r8.z, r9.x);
  r14.w = max(r8.w, r9.x);
  r14.y = r8.y;
  r8.yzw = r2.zzz ? r8.xzw : r14.yzw;
  r2.y = max(r15.x, r11.x);
  r2.z = min(r15.x, r11.x);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r8.x = (int)r8.y | 20;
  r14.z = min(r8.z, r11.x);
  r14.w = max(r8.w, r11.x);
  r14.y = r8.y;
  r8.yzw = r2.yyy ? r8.xzw : r14.yzw;
  r2.y = max(r15.x, r13.x);
  r2.z = min(r15.x, r13.x);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r8.x = (int)r8.y | 24;
  r14.z = min(r8.z, r13.x);
  r14.w = max(r8.w, r13.x);
  r14.y = r8.y;
  r8.yzw = r2.yyy ? r8.xzw : r14.yzw;
  r2.y = max(r17.x, r15.x);
  r2.z = min(r17.x, r15.x);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r8.x = (int)r8.y | 48;
  r14.z = min(r8.z, r17.x);
  r14.w = max(r8.w, r17.x);
  r14.y = r8.y;
  r8.yzw = r2.yyy ? r8.xzw : r14.yzw;
  r2.y = max(r19.x, r15.x);
  r2.z = min(r19.x, r15.x);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r8.x = (int)r8.y | 80;
  r14.z = min(r8.z, r19.x);
  r14.w = max(r8.w, r19.x);
  r14.y = r8.y;
  r8.yzw = r2.yyy ? r8.xzw : r14.yzw;
  r2.y = max(r21.x, r15.x);
  r2.z = min(r21.x, r15.x);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r8.x = (int)r8.y | 144;
  r14.z = min(r8.z, r21.x);
  r14.w = max(r8.w, r21.x);
  r14.y = r8.y;
  r8.yzw = r2.yyy ? r8.xzw : r14.yzw;
  r2.y = max(r22.x, r15.x);
  r2.z = min(r22.x, r15.x);
  r2.y = r2.y / r2.z;
  r2.z = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 1.89999998);
  r2.y = r2.y ? r2.z : 0;
  r8.x = (int)r8.y | 272;
  r6.y = min(r8.z, r22.x);
  r6.z = max(r8.w, r22.x);
  r6.x = r8.y;
  r2.yzw = r2.yyy ? r8.xzw : r6.xyz;
  r2.w = cmp(r2.w < r15.x);
  r2.z = cmp(r15.x < r2.z);
  r2.z = (int)r2.z | (int)r2.w;
  if (r2.z != 0) {
    r2.zw = float2(0,0);
    while (true) {
      r3.z = cmp((int)r2.w < 4);
      if (r3.z != 0) {
        r3.z = (int)r2.y & (int)icb[r2.w+0].x;
        r3.z = cmp((int)r3.z == (int)icb[r2.w+0].x);
        if (r3.z != 0) {
          r2.z = -1;
          break;
        }
        r2.w = (int)r2.w + 1;
        r2.z = 0;
        continue;
      } else {
        r2.z = 0;
        break;
      }
      r2.z = 0;
    }
    r2.y = r2.z ? 0 : 1;
  } else {
    r2.y = 0;
  }
  r2.y = max(r2.y, r12.w);
  r0.x = t3.SampleLevel(s1_s, r0.xy, 0).x;
  r0.x = cmp(0 < r0.x);
  r0.x = r0.x ? 0 : 1;
  r0.y = r1.w ? -1 : -0;
  r0.x = r0.x + r0.y;
  r0.y = r0.w ? -1 : -0;
  r0.x = r0.x + r0.y;
  r0.x = -cb1[1].w + r0.x;
  r0.y = abs(r1.y) + abs(r1.z);
  r0.y = cmp(0.300000012 < r0.y);
  r0.y = r0.y ? -1 : -0;
  r0.x = r0.x + r0.y;
  r0.x = max(0, r0.x);
  r0.x = r2.y * r0.x;
  r0.y = cmp(r0.x >= 0.100000001);
  r0.y = r0.y ? 1.000000 : 0;
  r7.x = r6.w;
  r2.yzw = r9.xyz * r9.xyz;
  r2.yzw = r7.xyz * r7.xyz + r2.yzw;
  r6.xyz = r9.xyz + r7.xyz;
  r2.yzw = r11.xyz * r11.xyz + r2.yzw;
  r6.xyz = r6.xyz + r11.xyz;
  r2.yzw = r13.xyz * r13.xyz + r2.yzw;
  r6.xyz = r6.xyz + r13.xyz;
  r2.yzw = r15.xyz * r15.xyz + r2.yzw;
  r6.xyz = r6.xyz + r15.xyz;
  r2.yzw = r17.xyz * r17.xyz + r2.yzw;
  r6.xyz = r6.xyz + r17.xyz;
  r2.yzw = r19.xyz * r19.xyz + r2.yzw;
  r6.xyz = r6.xyz + r19.xyz;
  r2.yzw = r21.xyz * r21.xyz + r2.yzw;
  r6.xyz = r6.xyz + r21.xyz;
  r2.yzw = r22.xyz * r22.xyz + r2.yzw;
  r6.xyz = r6.xyz + r22.xyz;
  r7.xyz = float3(0.111111112,0.111111112,0.111111112) * r6.xyz;
  r7.xyz = r7.xyz * r7.xyz;
  r2.yzw = r2.yzw * float3(0.111111112,0.111111112,0.111111112) + -r7.xyz;
  r2.yzw = sqrt(abs(r2.yzw));
  r7.xyz = float3(-20,-20,-20) + r2.yzw;
  r7.xyz = saturate(float3(0.0500000007,0.0500000007,0.0500000007) * r7.xyz);
  r8.xyz = r7.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r7.xyz = r7.xyz * r7.xyz;
  r7.xyz = r8.xyz * r7.xyz;
  r7.xyz = -r7.xyz * float3(0.699999988,0.699999988,0.699999988) + float3(1.25,1.25,1.25);
  r2.yzw = r7.xyz * r2.yzw;
  r7.xyz = r6.xyz * float3(0.111111112,0.111111112,0.111111112) + -r2.yzw;
  r7.xyz = min(r7.xyz, r15.xyz);
  r2.yzw = r6.xyz * float3(0.111111112,0.111111112,0.111111112) + r2.yzw;
  r2.yzw = max(r2.yzw, r15.xyz);
  r6.xyz = max(r10.xyz, r7.xyz);
  r2.yzw = min(r6.xyz, r2.yzw);
  r0.w = r0.w ? 0 : r0.y;
  r6.xyz = r10.xyz + -r2.yzw;
  r2.yzw = r0.www * r6.xyz + r2.yzw;
  r5.y = dot(r4.xz, float2(2,-2));
  r5.z = dot(r4.xzy, float3(-1,-1,2));
  r4.xyz = r5.xyz + -r15.xyz;
  r4.xyz = r0.zzz * r4.xyz + r15.xyz;
  r0.w = 1 + r4.x;
  r4.xyz = r4.xyz / r0.www;
  r0.w = 1 + r2.y;
  r2.yzw = r2.yzw / r0.www;
  r0.w = abs(r1.z) * cb0[84].y + abs(r1.y);
  r1.yz = r3.yw ? float2(1,1) : 0;
  r1.x = r1.x * 256 + -1;
  r1.x = r1.z * r1.x + 1;
  r1.z = cb1[3].z + -cb1[3].y;
  r0.w = r0.w * r1.x + -cb1[3].y;
  r1.x = 1 / r1.z;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r1.x = cb1[0].w + -cb1[0].z;
  r0.w = r0.w * r1.x + cb1[0].z;
  r1.x = r2.x + r1.y;
  r1.x = saturate(cb1[2].w + r1.x);
  r1.y = cb1[4].x + -r0.w;
  r0.w = r1.x * r1.y + r0.w;
  r0.z = saturate(r3.x * cb1[5].x + r0.z);
  r1.x = cb1[2].z + -r0.w;
  r0.z = r0.z * r1.x + r0.w;
  r0.w = 0.899999976 + -r0.z;
  r0.y = r0.y * r0.w + r0.z;
  r1.xyz = r2.yzw + -r4.xyz;
  r0.yzw = r0.yyy * r1.xyz + r4.xyz;
  r1.x = 1.00100005 + -r0.y;
  r0.yzw = r0.yzw / r1.xxx;
  r1.xyz = float3(0.25,0.25,0.25) * r0.yzw;
  r2.yz = r1.xx + r1.yz;
  r2.x = -r0.w * 0.25 + r2.y;
  r0.y = r0.y * 0.25 + -r1.y;
  r2.w = -r0.w * 0.25 + r0.y;
  o0.xyz = max(float3(0,0,0), r2.xzw);
  o0.w = r0.x;
  return;
}