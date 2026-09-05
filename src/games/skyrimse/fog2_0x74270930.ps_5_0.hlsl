// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 05 14:26:09 2026
Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[11];
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
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb12[43].xy * v1.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r1.x = min(cb12[44].z, r0.x);
  r1.y = min(cb12[43].y, r0.y);
  r0.x = t1.Sample(s1_s, r1.xy).x;
  r2.xyzw = t0.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r0.y = cmp(0.5 < cb2[10].z);
  if (r0.y != 0) {
    r0.yz = t3.SampleLevel(s3_s, r1.xy, 0).zw;
    r0.y = cmp(9.99999975e-006 >= r0.y);
    r0.z = cmp(9.99999975e-006 < r0.z);
    r0.y = r0.z ? r0.y : 0;
    r3.xyzw = t6.Sample(s6_s, r1.xy).xyzw;
    if (r0.y != 0) {
      r0.yzw = r3.xyz * r3.www;
      r0.yzw = cb2[10].xxx * r0.yzw;
      r3.xyz = cb2[10].yyy * r2.xyz;
      r0.yzw = max(float3(0,0,0), r0.yzw);
      r0.yzw = min(r0.yzw, r3.xyz);
    } else {
      r0.yzw = float3(0,0,0);
    }
    r2.xyz = r2.xyz + r0.yzw;
  }
  r0.y = cmp(0 != cb2[5].w);
  if (r0.y != 0) {
    r0.zw = t4.Sample(s4_s, r1.xy).yx;
    r2.xyz = r0.www * r0.zzz + r2.xyz;
  } else {
    r0.z = 0;
  }
  r0.w = cmp(9.99999975e-006 < r0.z);
  r0.w = r0.w ? r0.y : 0;
  r1.z = cb2[8].x + r0.x;
  r1.z = min(1, r1.z);
  r0.x = r0.w ? r1.z : r0.x;
  r3.xyz = r2.xyz * r0.xxx;
  r4.z = t2.SampleLevel(s2_s, r1.xy, 0).x;
  r0.w = r4.z * 1.00999999 + -0.00999999978;
  r0.w = r0.w * 2 + -1;
  r1.z = dot(cb2[3].xx, cb2[3].yy);
  r1.w = cb2[3].y + cb2[3].x;
  r3.w = cb2[3].y + -cb2[3].x;
  r0.w = -r0.w * r3.w + r1.w;
  r0.w = r1.z / r0.w;
  r0.w = saturate(r0.w * cb2[0].y + -cb2[0].x);
  r0.w = log2(r0.w);
  r0.w = cb2[0].z * r0.w;
  r0.w = exp2(r0.w);
  r0.w = min(cb2[0].w, r0.w);
  r5.xyz = cb2[2].xyz + -cb2[1].xyz;
  r5.xyz = r0.www * r5.xyz + cb2[1].xyz;
  r1.z = cmp(r4.z < 0.999998987);
  r5.xyz = -r2.xyz * r0.xxx + r5.xyz;
  r5.xyz = r0.www * r5.xyz + r3.xyz;
  r5.xyz = cb2[1].www * r5.xyz;
  r2.xyz = r1.zzz ? r5.xyz : r3.xyz;
  r0.x = cmp(r0.z != 0.000000);
  r0.x = r0.x ? r0.y : 0;
  r0.y = cmp(9.99999975e-006 < cb2[7].z);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) {
    r0.x = t5.SampleLevel(s5_s, r1.xy, 0).x;
    r0.yw = v1.xy * float2(1,-1) + float2(0,1);
    r4.xy = r0.yw * float2(2,2) + float2(-1,-1);
    r4.w = 1;
    r1.x = dot(cb12[32].xyzw, r4.xyzw);
    r1.y = dot(cb12[33].xyzw, r4.xyzw);
    r1.z = dot(cb12[34].xyzw, r4.xyzw);
    r0.y = dot(cb12[35].xyzw, r4.xyzw);
    r1.xyz = r1.xyz / r0.yyy;
    r1.xyz = cb12[40].xyz + r1.xyz;
    r3.xyz = cb2[7].xxx * r1.xyz;
    r4.xyz = float3(0.0700000003,0.0700000003,0.0700000003) * r3.xyz;
    r0.y = dot(r4.xyz, float3(0.333333343,0.333333343,0.333333343));
    r4.xyz = r3.xyz * float3(0.0700000003,0.0700000003,0.0700000003) + r0.yyy;
    r4.xyz = floor(r4.xyz);
    r3.xyz = r3.xyz * float3(0.0700000003,0.0700000003,0.0700000003) + -r4.xyz;
    r0.y = dot(r4.xyz, float3(0.166666672,0.166666672,0.166666672));
    r3.xyz = r3.xyz + r0.yyy;
    r5.xyz = cmp(r3.zxy >= r3.xyz);
    r6.xyz = r5.yzx ? float3(1,1,1) : 0;
    r5.xyz = r5.xyz ? float3(0,0,0) : float3(1,1,1);
    r7.xyz = min(r6.xyz, r5.xyz);
    r5.xyz = max(r6.yzx, r5.yzx);
    r6.xyz = -r7.xyz + r3.xyz;
    r6.xyz = float3(0.166666672,0.166666672,0.166666672) + r6.xyz;
    r8.xyz = -r5.zxy + r3.xyz;
    r8.xyz = float3(0.333333343,0.333333343,0.333333343) + r8.xyz;
    r9.xyz = float3(-0.5,-0.5,-0.5) + r3.xyz;
    r10.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r4.xyz;
    r10.xyz = floor(r10.xyz);
    r4.xyz = -r10.xyz * float3(289,289,289) + r4.xyz;
    r10.xw = float2(0,1);
    r10.y = r7.z;
    r10.z = r5.y;
    r10.xyzw = r10.xyzw + r4.zzzz;
    r11.xyzw = r10.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
    r10.xyzw = r11.xyzw * r10.xyzw;
    r11.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r10.xyzw;
    r11.xyzw = floor(r11.xyzw);
    r10.xyzw = -r11.xyzw * float4(289,289,289,289) + r10.xyzw;
    r10.xyzw = r10.xyzw + r4.yyyy;
    r11.xw = float2(0,1);
    r11.y = r7.y;
    r11.z = r5.x;
    r10.xyzw = r11.xyzw + r10.xyzw;
    r11.xyzw = r10.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
    r10.xyzw = r11.xyzw * r10.xyzw;
    r11.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r10.xyzw;
    r11.xyzw = floor(r11.xyzw);
    r10.xyzw = -r11.xyzw * float4(289,289,289,289) + r10.xyzw;
    r4.xyzw = r10.xyzw + r4.xxxx;
    r5.xw = float2(0,1);
    r5.y = r7.x;
    r4.xyzw = r5.xyzw + r4.xyzw;
    r5.xyzw = r4.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
    r4.xyzw = r5.xyzw * r4.xyzw;
    r5.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r4.xyzw;
    r5.xyzw = floor(r5.xyzw);
    r4.xyzw = -r5.xyzw * float4(289,289,289,289) + r4.xyzw;
    r5.xyzw = float4(0.0204081647,0.0204081647,0.0204081647,0.0204081647) * r4.xyzw;
    r5.xyzw = floor(r5.xyzw);
    r4.xyzw = -r5.xyzw * float4(49,49,49,49) + r4.xyzw;
    r5.xyzw = float4(0.142857149,0.142857149,0.142857149,0.142857149) * r4.xyzw;
    r5.xyzw = floor(r5.xyzw);
    r4.xyzw = -r5.xyzw * float4(7,7,7,7) + r4.xyzw;
    r5.xyzw = r5.xyzw * float4(0.285714298,0.285714298,0.285714298,0.285714298) + float4(-0.928571403,-0.928571403,-0.928571403,-0.928571403);
    r4.xyzw = r4.xzyw * float4(0.285714298,0.285714298,0.285714298,0.285714298) + float4(-0.928571403,-0.928571403,-0.928571403,-0.928571403);
    r7.xyzw = float4(1,1,1,1) + -abs(r5.xyzw);
    r7.xyzw = r7.xywz + -abs(r4.xzwy);
    r10.xz = floor(r5.xy);
    r10.yw = floor(r4.xz);
    r10.xyzw = r10.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
    r11.xz = floor(r5.zw);
    r11.yw = floor(r4.yw);
    r11.xyzw = r11.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
    r12.xyzw = cmp(float4(0,0,0,0) >= r7.xywz);
    r12.xyzw = r12.xyzw ? float4(-1,-1,-1,-1) : float4(-0,-0,-0,-0);
    r13.xz = r5.xy;
    r13.yw = r4.xz;
    r10.xyzw = r10.zwxy * r12.yyxx + r13.zwxy;
    r4.xz = r5.zw;
    r4.xyzw = r11.xyzw * r12.zzww + r4.xyzw;
    r5.xy = r10.zw;
    r5.z = r7.x;
    r11.x = dot(r5.xyz, r5.xyz);
    r10.z = r7.y;
    r11.y = dot(r10.xyz, r10.xyz);
    r12.xy = r4.xy;
    r12.z = r7.w;
    r11.z = dot(r12.xyz, r12.xyz);
    r7.xy = r4.zw;
    r11.w = dot(r7.xyz, r7.xyz);
    r4.xyzw = -r11.xyzw * float4(0.853734732,0.853734732,0.853734732,0.853734732) + float4(1.79284286,1.79284286,1.79284286,1.79284286);
    r5.xyz = r5.xyz * r4.xxx;
    r10.xyz = r10.xyz * r4.yyy;
    r4.xyz = r12.xyz * r4.zzz;
    r7.xyz = r7.xyz * r4.www;
    r11.x = dot(r3.xyz, r3.xyz);
    r11.y = dot(r6.xyz, r6.xyz);
    r11.z = dot(r8.xyz, r8.xyz);
    r11.w = dot(r9.xyz, r9.xyz);
    r11.xyzw = float4(0.600000024,0.600000024,0.600000024,0.600000024) + -r11.xyzw;
    r11.xyzw = max(float4(0,0,0,0), r11.xyzw);
    r11.xyzw = r11.xyzw * r11.xyzw;
    r11.xyzw = r11.xyzw * r11.xyzw;
    r3.x = dot(r5.xyz, r3.xyz);
    r3.y = dot(r10.xyz, r6.xyz);
    r3.z = dot(r4.xyz, r8.xyz);
    r3.w = dot(r7.xyz, r9.xyz);
    r0.y = dot(r11.xyzw, r3.xyzw);
    r0.y = r0.y * 42 + 1;
    r0.y = 0.5 * r0.y;
    r0.w = rcp(r0.y);
    r0.w = saturate(r0.w);
    r1.xyz = -cb2[5].xyz + r1.xyz;
    r1.x = dot(r1.xyz, r1.xyz);
    r1.x = sqrt(r1.x);
    r1.y = 1 / cb2[8].y;
    r1.x = saturate(r1.x * r1.y);
    r1.y = r1.x * -2 + 3;
    r1.x = r1.x * r1.x;
    r1.x = -r1.y * r1.x + 1;
    r1.y = 1 + -r0.x;
    r0.x = r1.y * cb2[9].x + r0.x;
    r0.y = r0.y * r0.w;
    r0.y = log2(abs(r0.y));
    r0.y = cb2[6].z * r0.y;
    r0.y = exp2(r0.y);
    r0.w = cmp(r0.y < cb2[6].w);
    r0.y = cb2[6].x * r0.y;
    r0.y = r0.w ? 0 : r0.y;
    r0.x = r0.y * r0.x;
    r0.x = r0.x * r1.x;
  } else {
    r0.x = 0;
  }
  r0.y = 1 + -cb2[7].w;
  r1.w = r0.x * r0.z;
  r1.xyz = cb2[9].yzw * r1.www;
  o0.xyzw = r2.xyzw * r0.yyyy + r1.xyzw;
  return;
}