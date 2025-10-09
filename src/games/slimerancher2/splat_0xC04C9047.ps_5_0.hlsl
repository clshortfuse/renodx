// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 27 01:10:39 2025
Texture2DArray<float4> t3 : register(t3);

Texture2DArray<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb6 : register(b6)
{
  float4 cb6[4];
}

cbuffer cb5 : register(b5)
{
  float4 cb5[7];
}

cbuffer cb4 : register(b4)
{
  float4 cb4[10];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[16];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[301];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[16];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : TEXCOORD0,
  float3 v2 : NORMAL0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  nointerpolation uint v7 : SV_InstanceID0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float2 o3 : SV_Target3)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)v7.x + asint(cb2[0].x);
  r1.xy = (uint2)v0.xy;
  r1.zw = float2(0,0);
  r0.y = t2.Load(r1.xyww).x;
  r0.zw = cb1[46].zw * v0.xy;
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r2.xyzw = cb1[29].xyzw * -r0.wwww;
  r2.xyzw = cb1[28].xyzw * r0.zzzz + r2.xyzw;
  r2.xyzw = cb1[30].xyzw * r0.yyyy + r2.xyzw;
  r2.xyzw = cb1[31].xyzw + r2.xyzw;
  r0.yzw = r2.xyz / r2.www;
  if (cb1[300].w != 0) {
    r2.x = (int)r0.x * 5;
    r1.xyz = t3.Load(r1.xyzw).xyz;
    r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
    r1.w = 1 + -abs(r1.x);
    r3.z = r1.w + -abs(r1.y);
    r1.w = max(0, -r3.z);
    r2.yz = cmp(r1.xy >= float2(0,0));
    r2.yz = r2.yz ? -r1.ww : r1.ww;
    r3.xy = r2.yz + r1.xy;
    r1.x = dot(r3.xyz, r3.xyz);
    r1.x = rsqrt(r1.x);
    r1.xyw = r3.xyz * r1.xxx;
    r1.z = 255.5 * r1.z;
    r1.z = (uint)r1.z;
    r1.z = (int)r1.z & asint(cb4[r2.x+4].x);
    r1.z = r1.z ? 1 : -1;
  } else {
    r1.xyzw = float4(0,0,1,0);
  }
  r2.xy = (uint2)r0.xx << int2(3,1);
  r3.xyz = cb3[r2.x+5].xyz * cb1[44].yyy;
  r3.xyz = cb3[r2.x+4].xyz * cb1[44].xxx + r3.xyz;
  r3.xyz = cb3[r2.x+6].xyz * cb1[44].zzz + r3.xyz;
  r3.xyz = cb3[r2.x+7].xyz + r3.xyz;
  r4.xyz = cb3[r2.x+5].xyz * r0.zzz;
  r4.xyz = cb3[r2.x+4].xyz * r0.yyy + r4.xyz;
  r0.yzw = cb3[r2.x+6].xyz * r0.www + r4.xyz;
  r0.yzw = r0.yzw + r3.xyz;
  r0.yzw = r0.yzw * float3(1,-1,1) + float3(0.5,0.5,0.5);
  r4.xyz = cmp(float3(0,0,0) < r0.yzw);
  r2.z = r4.y ? r4.x : 0;
  r2.z = r4.z ? r2.z : 0;
  r4.xyz = float3(1,1,1) + -r0.yzw;
  r4.xyz = cmp(float3(0,0,0) < r4.xyz);
  r0.z = r4.y ? r4.x : 0;
  r0.z = r4.z ? r0.z : 0;
  r0.z = (int)r0.z & (int)r2.z;
  r2.z = -2 + r1.z;
  r0.z = r0.z ? r1.z : r2.z;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  if (cb1[300].w != 0) {
    r0.z = (int)r0.x * 5;
    r1.z = cmp(cb4[r0.z+3].z < 0);
    if (r1.z != 0) {
      r1.x = dot(r1.xyw, cb4[r0.z+2].xyz);
      r1.y = -2 + r1.x;
      r1.x = r1.x * r1.y;
      r0.z = saturate(cb4[r0.z+3].z * r1.x + cb4[r0.z+3].y);
    } else {
      r0.z = 1;
    }
  } else {
    r0.z = 1;
  }
  r1.yz = ddy_coarse(r0.yw);
  r4.xz = v2.zy * r1.zy;
  r4.y = 0;
  r1.x = 0;
  r1.xyz = -r1.xyz * v2.yzx + r4.xyz;
  r4.xz = ddx_coarse(r0.wy);
  r1.w = dot(r1.yx, r4.xz);
  r2.z = frac(cb6[r2.y+1].x);
  r2.w = cmp(0 != cb5[5].z);
  r3.w = 9 * r2.z;
  r3.w = floor(r3.w);
  r2.w = r2.w ? r3.w : cb5[5].y;
  r2.w = 0.111111112 * r2.w;
  r3.w = cmp(r2.w >= -r2.w);
  r2.w = frac(abs(r2.w));
  r2.w = r3.w ? r2.w : -r2.w;
  r2.w = 9 * r2.w;
  r2.w = round(r2.w);
  r3.w = cmp(r2.w < 0);
  r3.w = r3.w ? 9.000000 : 0;
  r2.w = r3.w + r2.w;
  r3.w = 0.333333343 * r2.w;
  r4.w = cmp(r3.w >= -r3.w);
  r3.w = frac(abs(r3.w));
  r3.w = r4.w ? r3.w : -r3.w;
  r3.w = 3 * r3.w;
  r3.w = round(r3.w);
  r5.x = 0.333333343 * r3.w;
  r2.w = -r3.w + r2.w;
  r2.w = 0.111111119 * r2.w;
  r3.w = cmp(r2.w >= -r2.w);
  r2.w = frac(abs(r2.w));
  r2.w = r3.w ? r2.w : -r2.w;
  r2.w = 3 * r2.w;
  r2.w = round(r2.w);
  r2.w = 2 + -r2.w;
  r5.y = 0.333333343 * r2.w;
  r0.yw = r0.yw * float2(0.333333343,0.333333343) + r5.xy;
  r0.y = t0.Sample(s1_s, r0.yw).x;
  r5.xy = v3.xy / v3.ww;
  r6.xy = cb1[46].xy * r5.xy;
  r6.xy = (uint2)r6.xy;
  r6.zw = float2(0,0);
  r0.w = t2.Load(r6.xyzw).x;
  r5.z = 1 + -r0.w;
  r5.xyz = r5.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r6.xyzw = cb0[5].xyzw * r5.yyyy;
  r6.xyzw = cb0[4].xyzw * r5.xxxx + r6.xyzw;
  r5.xyzw = cb0[6].xyzw * r5.zzzz + r6.xyzw;
  r5.xyzw = cb0[7].xyzw + r5.xyzw;
  r5.xyz = r5.xyz / r5.www;
  r5.xyz = float3(1,1,-1) * r5.xyz;
  r6.xyz = cb0[13].xyz * r5.yyy;
  r5.xyw = cb0[12].xyz * r5.xxx + r6.xyz;
  r5.xyz = cb0[14].xyz * r5.zzz + r5.xyw;
  r5.xyz = cb0[15].xyz + r5.xyz;
  r0.w = 0.449999988 * r5.y;
  r5.w = cb1[75].x * cb5[5].x + r0.w;
  r6.xyz = r2.zzz * float3(100,100,100) + r5.xwz;
  r7.xyz = cb5[4].www * r6.xyz;
  r0.w = dot(r7.xyz, float3(0.333333343,0.333333343,0.333333343));
  r7.xyz = r6.xyz * cb5[4].www + r0.www;
  r7.xyz = floor(r7.xyz);
  r6.xyz = r6.xyz * cb5[4].www + -r7.xyz;
  r0.w = dot(r7.xyz, float3(0.166666672,0.166666672,0.166666672));
  r6.xyz = r6.xyz + r0.www;
  r8.xyz = cmp(r6.zxy >= r6.xyz);
  r9.xyz = r8.yzx ? float3(1,1,1) : 0;
  r8.xyz = r8.xyz ? float3(0,0,0) : float3(1,1,1);
  r10.xyz = min(r9.xyz, r8.xyz);
  r8.xyz = max(r9.yzx, r8.yzx);
  r9.xyz = -r10.xyz + r6.xyz;
  r9.xyz = float3(0.166666672,0.166666672,0.166666672) + r9.xyz;
  r11.xyz = -r8.zxy + r6.xyz;
  r11.xyz = float3(0.333333343,0.333333343,0.333333343) + r11.xyz;
  r12.xyz = float3(-0.5,-0.5,-0.5) + r6.xyz;
  r13.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r7.xyz;
  r13.xyz = floor(r13.xyz);
  r7.xyz = -r13.xyz * float3(289,289,289) + r7.xyz;
  r13.xw = float2(0,1);
  r13.y = r10.z;
  r13.z = r8.y;
  r13.xyzw = r13.xyzw + r7.zzzz;
  r14.xyzw = r13.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
  r13.xyzw = r14.xyzw * r13.xyzw;
  r14.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r13.xyzw;
  r14.xyzw = floor(r14.xyzw);
  r13.xyzw = -r14.xyzw * float4(289,289,289,289) + r13.xyzw;
  r13.xyzw = r13.xyzw + r7.yyyy;
  r14.xw = float2(0,1);
  r14.y = r10.y;
  r14.z = r8.x;
  r13.xyzw = r14.xyzw + r13.xyzw;
  r14.xyzw = r13.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
  r13.xyzw = r14.xyzw * r13.xyzw;
  r14.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r13.xyzw;
  r14.xyzw = floor(r14.xyzw);
  r13.xyzw = -r14.xyzw * float4(289,289,289,289) + r13.xyzw;
  r7.xyzw = r13.xyzw + r7.xxxx;
  r8.xw = float2(0,1);
  r8.y = r10.x;
  r7.xyzw = r8.xyzw + r7.xyzw;
  r8.xyzw = r7.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
  r7.xyzw = r8.xyzw * r7.xyzw;
  r8.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r7.xyzw;
  r8.xyzw = floor(r8.xyzw);
  r7.xyzw = -r8.xyzw * float4(289,289,289,289) + r7.xyzw;
  r8.xyzw = float4(0.0204081628,0.0204081628,0.0204081628,0.0204081628) * r7.xyzw;
  r8.xyzw = floor(r8.xyzw);
  r7.xyzw = -r8.xyzw * float4(49,49,49,49) + r7.xyzw;
  r8.xyzw = float4(0.142857149,0.142857149,0.142857149,0.142857149) * r7.xyzw;
  r8.xyzw = floor(r8.xyzw);
  r7.xyzw = -r8.xyzw * float4(7,7,7,7) + r7.xyzw;
  r8.xyzw = r8.xyzw * float4(2,2,2,2) + float4(0.5,0.5,0.5,0.5);
  r8.xyzw = r8.xyzw * float4(0.142857149,0.142857149,0.142857149,0.142857149) + float4(-1,-1,-1,-1);
  r7.xyzw = r7.xyzw * float4(2,2,2,2) + float4(0.5,0.5,0.5,0.5);
  r7.xyzw = r7.xzyw * float4(0.142857149,0.142857149,0.142857149,0.142857149) + float4(-1,-1,-1,-1);
  r10.xyzw = float4(1,1,1,1) + -abs(r8.xyzw);
  r10.xyzw = r10.xywz + -abs(r7.xzwy);
  r13.xz = floor(r8.xy);
  r13.yw = floor(r7.xz);
  r13.xyzw = r13.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
  r14.xz = floor(r8.zw);
  r14.yw = floor(r7.yw);
  r14.xyzw = r14.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
  r15.xyzw = cmp(float4(0,0,0,0) >= r10.xywz);
  r15.xyzw = r15.xyzw ? float4(-1,-1,-1,-1) : float4(-0,-0,-0,-0);
  r16.xz = r8.xy;
  r16.yw = r7.xz;
  r13.xyzw = r13.zwxy * r15.yyxx + r16.zwxy;
  r7.xz = r8.zw;
  r7.xyzw = r14.xyzw * r15.zzww + r7.xyzw;
  r8.xy = r13.zw;
  r8.z = r10.x;
  r14.x = dot(r8.xyz, r8.xyz);
  r13.z = r10.y;
  r14.y = dot(r13.xyz, r13.xyz);
  r15.xy = r7.xy;
  r15.z = r10.w;
  r14.z = dot(r15.xyz, r15.xyz);
  r10.xy = r7.zw;
  r14.w = dot(r10.xyz, r10.xyz);
  r7.xyzw = -r14.xyzw * float4(0.853734732,0.853734732,0.853734732,0.853734732) + float4(1.79284286,1.79284286,1.79284286,1.79284286);
  r8.xyz = r8.xyz * r7.xxx;
  r13.xyz = r13.xyz * r7.yyy;
  r7.xyz = r15.xyz * r7.zzz;
  r10.xyz = r10.xyz * r7.www;
  r14.x = dot(r6.xyz, r6.xyz);
  r14.y = dot(r9.xyz, r9.xyz);
  r14.z = dot(r11.xyz, r11.xyz);
  r14.w = dot(r12.xyz, r12.xyz);
  r14.xyzw = float4(0.600000024,0.600000024,0.600000024,0.600000024) + -r14.xyzw;
  r14.xyzw = max(float4(0,0,0,0), r14.xyzw);
  r14.xyzw = r14.xyzw * r14.xyzw;
  r14.xyzw = r14.xyzw * r14.xyzw;
  r6.x = dot(r6.xyz, r8.xyz);
  r6.y = dot(r9.xyz, r13.xyz);
  r6.z = dot(r11.xyz, r7.xyz);
  r6.w = dot(r12.xyz, r10.xyz);
  r0.w = dot(r14.xyzw, r6.xyzw);
  r0.w = r0.w * 21 + 0.5;
  r5.xyz = -cb1[44].xyz + r5.xyz;
  r6.xyz = cb3[r2.x+5].xyz * r5.yyy;
  r5.xyw = cb3[r2.x+4].xyz * r5.xxx + r6.xyz;
  r2.xzw = cb3[r2.x+6].xyz * r5.zzz + r5.xyw;
  r2.xzw = r2.xzw + r3.xyz;
  r0.w = r0.w * 2 + -1;
  r3.x = saturate(abs(r2.z) * cb5[4].z + cb5[4].y);
  r0.y = r0.w * r3.x + r0.y;
  r2.xzw = r2.xzw + r2.xzw;
  r0.w = dot(r2.xzw, r2.xzw);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r2.x = 1 / cb5[3].w;
  r0.w = saturate(r2.x * r0.w);
  r2.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r2.x * r0.w;
  r2.x = -cb6[r2.y+1].x + cb1[75].x;
  r2.x = saturate(0.100000001 * r2.x);
  r2.z = -1 + r2.x;
  r2.z = -1.25 * r2.z;
  r2.z = min(1, r2.z);
  r2.w = r2.z * -2 + 3;
  r2.z = r2.z * r2.z;
  r2.z = r2.w * r2.z;
  r0.w = cb5[4].x * r0.w;
  r2.w = cmp(0 != cb5[6].x);
  r2.x = 50 * r2.x;
  r2.x = min(1, r2.x);
  r2.x = min(r2.z, r2.x);
  r2.x = r2.w ? r2.x : cb6[r2.y+0].w;
  r0.w = r2.x * r0.w;
  r2.x = r0.y * r0.w;
  r0.y = r0.y * r0.w + -cb5[1].x;
  r0.w = 1 / cb5[5].w;
  r0.y = saturate(r0.y * r0.w);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r2.z = r0.w * r0.y;
  r2.w = ddx_coarse(r2.z);
  r3.x = ddy_coarse(r2.z);
  r4.y = 0;
  r3.yzw = v2.zxy * r4.xyz;
  r3.yzw = v2.yzx * r4.yzx + -r3.yzw;
  r3.xyz = r3.xxx * r3.yzw;
  r1.xyz = r2.www * r1.xyz + r3.xyz;
  r2.w = 0.0500000007 * cb5[3].z;
  r1.xyz = r2.www * r1.xyz;
  r1.xyz = abs(r1.www) * v2.xyz + -r1.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r3.xyz = cb1[44].xyz + v1.xyz;
  r3.xyz = cb1[44].xyz + -r3.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = r3.xyz * r1.www;
  r1.w = r2.x * 2 + -1;
  r4.xyz = r1.www * cb5[3].xxx + r1.xyz;
  r5.x = v4.x;
  r5.y = v6.x;
  r5.z = v5.x;
  r5.x = dot(r5.xyz, r4.xyz);
  r6.x = v4.y;
  r6.y = v6.y;
  r6.z = v5.y;
  r5.y = dot(r6.xyz, r4.xyz);
  r6.x = v4.z;
  r6.y = v6.z;
  r6.z = v5.z;
  r5.z = dot(r6.xyz, r4.xyz);
  r1.w = dot(-r3.xyz, r5.xyz);
  r1.w = r1.w + r1.w;
  r3.xy = r5.xy * -r1.ww + -r3.xy;
  r3.xyz = t1.Sample(s0_s, r3.xy).xyz;
  r3.xyz = cb5[2].www * r3.xyz;
  r4.xyz = cb6[r2.y+0].xyz * cb5[0].xyz;
  r0.y = r0.w * r0.y + -cb5[2].z;
  r0.y = saturate(1 + r0.y);
  r4.xyz = r4.xyz * r0.yyy;
  r0.y = cmp(r2.x >= cb5[1].x);
  r0.y = r0.y ? 1.000000 : 0;
  o0.xyz = r3.xyz * r2.zzz + r4.xyz;
  r2.xy = cb5[2].yx * r0.yy;
  r0.x = (int)r0.x * 5;
  r0.w = saturate(cb4[r0.x+3].x);
  r0.z = r0.w * r0.z;
  o0.w = r2.x * r0.z;
  r2.xzw = cb4[r0.x+1].xyz * r1.yyy;
  r1.xyw = cb4[r0.x+0].xyz * r1.xxx + r2.xzw;
  r1.xyz = cb4[r0.x+2].xyz * r1.zzz + r1.xyw;
  o1.w = r2.y * r0.z;
  r0.xy = r0.yy * r0.zz;
  o1.xyz = saturate(r1.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));  // clamp to prevent black screen flickering
  o2.xy = float2(0,1);
  o2.z = cb5[1].w;
  o2.w = r0.y;
  o3.xy = r0.xy;
  return;
}