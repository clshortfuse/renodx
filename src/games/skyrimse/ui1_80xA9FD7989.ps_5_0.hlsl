// ---- Created with 3Dmigoto v1.3.16 on Sat Mar 21 10:43:34 2026
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[5];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[45];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb2[3].xy + v1.xy;
  r0.zw = cb2[3].xy + v1.xy;
  r1.xy = cb12[43].xy * r0.zw;
  r1.xy = max(float2(0,0), r1.xy);
  r2.x = cb12[44].z;
  r2.y = cb12[43].y;
  r1.xy = min(r2.xy, r1.xy);
  r1.z = t3.Sample(s3_s, r1.xy).x;
  r3.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r4.xyzw = cb2[3].xyxy * float4(1,-1,1,0) + v1.xyxy;
  r5.xyzw = cb12[43].xyxy * r4.xyzw;
  r5.xyzw = max(float4(0,0,0,0), r5.xyzw);
  r5.xyzw = min(r5.xyzw, r2.xyxy);
  r1.x = t3.Sample(s3_s, r5.xy).x;
  r1.y = min(r1.x, r1.z);
  r1.zw = cb12[43].xy * r0.xy;
  r1.zw = max(float2(0,0), r1.zw);
  r1.zw = min(r1.zw, r2.xy);
  r2.z = t3.Sample(s3_s, r1.zw).x;
  r1.y = min(r2.z, r1.y);
  r2.z = cmp(r1.y == r2.z);
  r0.xy = r2.zz ? r0.xy : r0.zw;
  r0.z = cmp(r1.y == r1.x);
  r0.xy = r0.zz ? r4.xy : r0.xy;
  r6.xyzw = cb2[3].xyxy * float4(0,-1,-1,1) + v1.xyxy;
  r7.xyzw = cb12[43].xyxy * r6.xyzw;
  r7.xyzw = max(float4(0,0,0,0), r7.xyzw);
  r7.xyzw = min(r7.xyzw, r2.xyxy);
  r0.z = t3.Sample(s3_s, r7.xy).x;
  r0.w = min(r0.z, r1.y);
  r1.x = t3.Sample(s3_s, r5.zw).x;
  r0.w = min(r1.x, r0.w);
  r1.x = cmp(r0.w == r1.x);
  r0.xy = r1.xx ? r4.zw : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r6.xy : r0.xy;
  r4.xyzw = cb2[3].xyxy * float4(-1,0,0,1) + v1.xyxy;
  r8.xyzw = cb12[43].xyxy * r4.xyzw;
  r8.xyzw = max(float4(0,0,0,0), r8.xyzw);
  r8.xyzw = min(r8.xyzw, r2.xyxy);
  r0.z = t3.Sample(s3_s, r8.xy).x;
  r0.w = min(r0.z, r0.w);
  r1.x = t3.Sample(s3_s, r7.zw).x;
  r0.w = min(r1.x, r0.w);
  r1.x = cmp(r0.w == r1.x);
  r0.xy = r1.xx ? r6.zw : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r4.xy : r0.xy;
  r1.xy = cb12[43].xy * v1.xy;
  r1.xy = max(float2(0,0), r1.xy);
  r1.xy = min(r1.xy, r2.xy);
  r0.z = t3.Sample(s3_s, r1.xy).x;
  r0.w = min(r0.z, r0.w);
  r2.z = t3.Sample(s3_s, r8.zw).x;
  r0.w = min(r2.z, r0.w);
  r2.z = cmp(r0.w == r2.z);
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r2.zz ? r4.zw : r0.xy;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xy = cb12[43].xy * r0.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r0.xy = min(r0.xy, r2.xy);
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r0.zw = v1.xy + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r2.xy = cb12[43].zw * r0.zw;
  r2.xy = max(float2(0,0), r2.xy);
  r4.x = min(cb12[44].w, r2.x);
  r4.y = min(cb12[43].w, r2.y);
  r2.xyw = t1.Sample(s1_s, r4.xy).xyz;
  r3.w = dot(r3.xzy, float3(0.5,0.25,0.25));
  r0.y = cmp(r3.w < r2.x);
  r4.xyz = t0.Sample(s0_s, r1.zw).yxz;
  r1.z = t4.Sample(s4_s, r1.zw).x;
  r4.w = dot(r4.xzy, float3(0.5,0.25,0.25));
  r1.w = cmp(r4.w < r2.x);
  r6.xyz = t0.Sample(s0_s, r5.xy).yxz;
  r6.w = dot(r6.xzy, float3(0.5,0.25,0.25));
  r3.x = cmp(r6.w < r2.x);
  r9.xyz = t0.Sample(s0_s, r5.zw).yxz;
  r9.w = dot(r9.xzy, float3(0.5,0.25,0.25));
  r4.x = cmp(r9.w < r2.x);
  r10.xyz = t0.Sample(s0_s, r7.xy).yxz;
  r10.w = dot(r10.xzy, float3(0.5,0.25,0.25));
  r6.x = cmp(r10.w < r2.x);
  r11.xyz = t0.Sample(s0_s, r7.zw).yxz;
  r11.w = dot(r11.xzy, float3(0.5,0.25,0.25));
  r9.x = cmp(r11.w < r2.x);
  r12.xyz = t0.Sample(s0_s, r8.xy).yxz;
  r12.w = dot(r12.xzy, float3(0.5,0.25,0.25));
  r10.x = cmp(r12.w < r2.x);
  r13.xyz = t0.Sample(s0_s, r8.zw).yxz;
  r13.w = dot(r13.xzy, float3(0.5,0.25,0.25));
  r14.x = cmp(r13.w < r2.x);
  r14.yzw = t0.Sample(s0_s, r1.xy).xyz;
  r1.x = t4.Sample(s4_s, r1.xy).x;
  r15.x = dot(r14.zwy, float3(0.5,0.25,0.25));
  r1.y = cmp(r15.x < r2.x);
  r15.yz = r14.yw;
  r16.x = cmp(r15.x < 1.00100005);
  r16.xyz = r16.xxx ? r15.yzx : float3(1.00100005,1.00100005,1.00100005);
  r16.xyz = r1.yyy ? float3(1.00100005,1.00100005,1.00100005) : r16.xyz;
  r16.w = cmp(r13.w < r16.z);
  r17.xyz = r16.www ? r13.yzw : r16.xyz;
  r16.xyz = r14.xxx ? r16.xyz : r17.xyz;
  r17.xyz = cb2[2].zzz * r12.yxz;
  r17.xyz = r11.yxz * cb2[2].www + r17.xyz;
  r17.xyz = r13.yxz * cb2[2].yyy + r17.xyz;
  r17.xyz = r14.yzw * cb2[2].xxx + r17.xyz;
  r11.x = cmp(r12.w < r16.z);
  r18.xyz = r11.xxx ? r12.yzw : r16.xyz;
  r16.xyz = r10.xxx ? r16.xyz : r18.xyz;
  r11.x = cmp(r11.w < r16.z);
  r18.xyz = r11.xxx ? r11.yzw : r16.xyz;
  r16.xyz = r9.xxx ? r16.xyz : r18.xyz;
  r11.x = cmp(r10.w < r16.z);
  r18.xyz = r11.xxx ? r10.yzw : r16.xyz;
  r16.xyz = r6.xxx ? r16.xyz : r18.xyz;
  r11.x = cmp(r9.w < r16.z);
  r18.xyz = r11.xxx ? r9.yzw : r16.xyz;
  r16.xyz = r4.xxx ? r16.xyz : r18.xyz;
  r11.x = cmp(r6.w < r16.z);
  r18.xyz = r11.xxx ? r6.yzw : r16.xyz;
  r16.xyz = r3.xxx ? r16.xyz : r18.xyz;
  r11.x = cmp(r4.w < r16.z);
  r18.xyz = r11.xxx ? r4.yzw : r16.xyz;
  r16.yzw = r1.www ? r16.xyz : r18.xyz;
  r11.x = cmp(r3.w < r16.w);
  r18.yzw = r11.xxx ? r3.yzw : r16.yzw;
  r11.x = cmp(-0.00100000005 < r15.x);
  r19.xyz = r11.xxx ? r15.yzx : float3(-0.00100000005,-0.00100000005,-0.00100000005);
  r19.xyz = r1.yyy ? r19.xyz : float3(-0.00100000005,-0.00100000005,-0.00100000005);
  r1.y = cmp(r19.z < r13.w);
  r13.xyz = r1.yyy ? r13.yzw : r19.xyz;
  r13.xyz = r14.xxx ? r13.xyz : r19.xyz;
  r1.y = r15.x + -r13.w;
  r1.y = 0.200000003 + -abs(r1.y);
  r11.x = cmp(r13.z < r12.w);
  r12.xyz = r11.xxx ? r12.yzw : r13.xyz;
  r12.xyz = r10.xxx ? r12.xyz : r13.xyz;
  r10.x = r15.x + -r12.w;
  r10.x = 0.200000003 + -abs(r10.x);
  r10.x = ceil(r10.x);
  r11.x = cmp(r12.z < r11.w);
  r11.xyz = r11.xxx ? r11.yzw : r12.xyz;
  r11.xyz = r9.xxx ? r11.xyz : r12.xyz;
  r9.x = r15.x + -r11.w;
  r9.x = 0.200000003 + -abs(r9.x);
  r9.x = ceil(r9.x);
  r11.w = cmp(r11.z < r10.w);
  r12.xyz = r11.www ? r10.yzw : r11.xyz;
  r11.xyz = r6.xxx ? r12.xyz : r11.xyz;
  r6.x = r15.x + -r10.w;
  r6.x = 0.200000003 + -abs(r6.x);
  r6.x = ceil(r6.x);
  r10.y = cmp(r11.z < r9.w);
  r10.yzw = r10.yyy ? r9.yzw : r11.xyz;
  r10.yzw = r4.xxx ? r10.yzw : r11.xyz;
  r4.x = r15.x + -r9.w;
  r4.x = 0.200000003 + -abs(r4.x);
  r4.x = ceil(r4.x);
  r9.y = cmp(r10.w < r6.w);
  r9.yzw = r9.yyy ? r6.yzw : r10.yzw;
  r9.yzw = r3.xxx ? r9.yzw : r10.yzw;
  r3.x = r15.x + -r6.w;
  r3.x = 0.200000003 + -abs(r3.x);
  r3.x = ceil(r3.x);
  r6.y = cmp(r9.w < r4.w);
  r6.yzw = r6.yyy ? r4.yzw : r9.yzw;
  r6.yzw = r1.www ? r6.yzw : r9.yzw;
  r1.w = r15.x + -r4.w;
  r1.w = 0.200000003 + -abs(r1.w);
  r1.yw = ceil(r1.yw);
  r18.x = r6.z;
  r4.y = cmp(r6.w < r3.w);
  r4.yzw = r4.yyy ? r3.yzw : r6.yzw;
  r11.xw = r0.yy ? r4.yw : r6.yw;
  r16.x = r4.z;
  r12.xyzw = r0.yyyy ? r16.xyzw : r18.xyzw;
  r0.y = r15.x + -r3.w;
  r0.y = 0.200000003 + -abs(r0.y);
  r0.y = ceil(r0.y);
  r0.y = 4 + -r0.y;
  r0.y = r0.y + -r1.w;
  r0.y = r0.y + -r3.x;
  r0.y = r0.y + -r4.x;
  r0.y = r0.y + -r6.x;
  r0.y = r0.y + -r9.x;
  r0.y = r0.y + -r10.x;
  r0.y = saturate(r0.y + -r1.y);
  r1.y = cmp(1 < r12.w);
  r1.w = -r12.y * 0.25 + r12.w;
  r1.w = -r12.z * 0.25 + r1.w;
  r3.y = r1.w + r1.w;
  r11.z = r12.x;
  r3.xzw = r12.yzw;
  r1.w = -r11.x * 0.25 + r11.w;
  r1.w = -r12.x * 0.25 + r1.w;
  r11.y = r1.w + r1.w;
  r1.w = cmp(r11.w < 0);
  r4.xyzw = r1.wwww ? r3.xyzw : r11.xyzw;
  r6.xyzw = r1.yyyy ? r4.xyzw : r3.xyzw;
  r1.y = max(r4.w, r2.x);
  r9.x = min(r1.y, r6.w);
  r9.z = r6.w;
  r9.y = r4.w;
  r10.z = r3.w;
  r10.x = r2.x;
  r1.y = t4.Sample(s4_s, r5.xy).x;
  r1.w = t4.Sample(s4_s, r5.zw).x;
  r1.y = r1.z + r1.y;
  r1.y = cmp(r1.y < 2);
  r1.z = t4.Sample(s4_s, r7.xy).x;
  r3.w = t4.Sample(s4_s, r7.zw).x;
  r1.z = r1.w + r1.z;
  r1.z = cmp(r1.z < 2);
  r1.y = (int)r1.z | (int)r1.y;
  r1.z = t4.Sample(s4_s, r8.xy).x;
  r1.w = t4.Sample(s4_s, r8.zw).x;
  r1.w = r1.w + r1.x;
  r1.z = r3.w + r1.z;
  r1.zw = cmp(r1.zw < float2(2,2));
  r1.y = (int)r1.z | (int)r1.y;
  r1.y = (int)r1.w | (int)r1.y;
  r1.x = r1.y ? 0 : r1.x;
  r1.y = 1 + -r1.x;
  r1.x = cmp(0 < r1.x);
  r1.z = 0.949999988 * r2.y;
  r0.y = saturate(r0.y * 0.25 + r1.z);
  r0.y = r0.y * r1.y;
  r1.y = cmp(r0.y < 0.902499974);
  r10.y = r11.w;
  r4.xyz = r1.yyy ? r4.xyz : r11.xyz;
  r2.xyz = r1.yyy ? r9.xyz : r10.xyz;
  r1.yzw = r1.yyy ? r6.xyz : r3.xyz;
  r1.yzw = r1.yzw + -r4.xyz;
  r2.yz = r2.zx + -r2.yy;
  r3.x = cmp(0.00999999978 < r2.y);
  r2.y = r2.z / r2.y;
  r2.y = r3.x ? r2.y : 0.5;
  r1.yzw = r2.yyy * r1.yzw + r4.xyz;
  r2.y = min(r0.z, r0.w);
  r0.zw = cmp(r0.zw >= float2(1,1));
  r2.y = cmp(0 >= r2.y);
  r0.z = (int)r0.z | (int)r2.y;
  r0.z = (int)r0.w | (int)r0.z;
  r0.z = (int)r1.x | (int)r0.z;
  r1.xyz = r0.zzz ? r14.yzw : r1.yzw;
  r3.xyz = r0.zzz ? r14.yzw : r17.xyz;
  r4.xyz = r14.yzw + -r3.xyz;
  r15.w = 0;
  r0.zw = r0.zz ? r15.xw : r2.xw;
  r1.w = 128 * cb2[0].x;
  r2.z = saturate(r0.x / r1.w);
  r0.x = r2.z + -r0.w;
  r0.z = r0.z + -r15.x;
  r0.xw = -abs(r0.xx) * float2(20,100) + float2(1,1);
  r0.xw = max(float2(0,0), r0.xw);
  r4.xyz = r0.xxx * r4.xyz + r3.xyz;
  r1.xyz = -r4.xyz + r1.xyz;
  r1.w = cb2[4].x + -cb2[4].y;
  r1.w = r2.z * r1.w + cb2[4].y;
  r0.x = min(r1.w, r0.x);
  r2.y = saturate(r0.y * r0.w);
  r0.y = 0.99000001 + -r0.x;
  r0.x = r2.y * r0.y + r0.x;
  o1.yz = r2.yz;
  r1.xyz = max(float3(0, 0, 0), r0.xxx * r1.xyz + r4.xyz);
  r2.xyz = r1.xyz + -r3.xyz;
  r1.xyz = max(float3(0, 0, 0), r2.xyz * cb2[4].zzz + r1.xyz);
  r2.xyz = r3.xyz + -r1.xyz;
  o0.xyz = max(float3(0, 0, 0), cb2[4].www * r2.xyz + r1.xyz);
  o0.w = 1;
  r0.y = r0.x * r0.z + r15.x;
  r0.x = r0.x * r0.z;
  r0.x = cmp(abs(r0.x) < 0.00999999978);
  o1.x = saturate(r0.x ? r15.x : r0.y);
  o1.w = 1;
  return;
}