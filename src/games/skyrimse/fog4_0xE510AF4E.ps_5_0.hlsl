// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 05 14:25:17 2026
Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb12[43].xy * v1.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r1.x = min(cb12[44].z, r0.x);
  r1.y = min(cb12[43].y, r0.y);
  r0.xyzw = t0.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.z = cmp(0.5 < cb2[10].z);
  if (r1.z != 0) {
    r1.zw = t3.SampleLevel(s3_s, r1.xy, 0).zw;
    r1.z = cmp(9.99999975e-006 >= r1.z);
    r1.w = cmp(9.99999975e-006 < r1.w);
    r1.z = r1.w ? r1.z : 0;
    r2.xyzw = t6.Sample(s6_s, r1.xy).xyzw;
    if (r1.z != 0) {
      r2.xyz = r2.xyz * r2.www;
      r2.xyz = cb2[10].xxx * r2.xyz;
      r3.xyz = cb2[10].yyy * r0.xyz;
      r2.xyz = max(float3(0,0,0), r2.xyz);
      r2.xyz = min(r2.xyz, r3.xyz);
    } else {
      r2.xyz = float3(0,0,0);
    }
    r0.xyz = r2.xyz + r0.xyz;
  }
  r1.z = cmp(0 != cb2[5].w);
  if (r1.z != 0) {
    r2.xy = t4.Sample(s4_s, r1.xy).yx;
    r0.xyz = r2.yyy * r2.xxx + r0.xyz;
  } else {
    r2.x = 0;
  }
  r3.z = t2.SampleLevel(s2_s, r1.xy, 0).x;
  r1.w = r3.z * 1.00999999 + -0.00999999978;
  r1.w = r1.w * 2 + -1;
  r2.y = dot(cb2[3].xx, cb2[3].yy);
  r2.z = cb2[3].y + cb2[3].x;
  r2.w = cb2[3].y + -cb2[3].x;
  r1.w = -r1.w * r2.w + r2.z;
  r1.w = r2.y / r1.w;
  r1.w = saturate(r1.w * cb2[0].y + -cb2[0].x);
  r1.w = log2(r1.w);
  r1.w = cb2[0].z * r1.w;
  r1.w = exp2(r1.w);
  r1.w = min(cb2[0].w, r1.w);
  r2.yzw = cb2[2].xyz + -cb2[1].xyz;
  r2.yzw = r1.www * r2.yzw + cb2[1].xyz;
  r4.x = cmp(r3.z < 0.999998987);
  r2.yzw = r2.yzw + -r0.xyz;
  r2.yzw = r1.www * r2.yzw + r0.xyz;
  r2.yzw = cb2[1].www * r2.yzw;
  r0.xyz = r4.xxx ? r2.yzw : r0.xyz;
  r1.w = cmp(r2.x != 0.000000);
  r1.z = r1.w ? r1.z : 0;
  r1.w = cmp(9.99999975e-006 < cb2[7].z);
  r1.z = r1.w ? r1.z : 0;
  if (r1.z != 0) {
    r1.x = t5.SampleLevel(s5_s, r1.xy, 0).x;
    r1.yz = v1.xy * float2(1,-1) + float2(0,1);
    r3.xy = r1.yz * float2(2,2) + float2(-1,-1);
    r3.w = 1;
    r4.x = dot(cb12[32].xyzw, r3.xyzw);
    r4.y = dot(cb12[33].xyzw, r3.xyzw);
    r4.z = dot(cb12[34].xyzw, r3.xyzw);
    r1.y = dot(cb12[35].xyzw, r3.xyzw);
    r1.yzw = r4.xyz / r1.yyy;
    r1.yzw = cb12[40].xyz + r1.yzw;
    r2.yzw = cb2[7].xxx * r1.yzw;
    r3.xyz = float3(0.0700000003,0.0700000003,0.0700000003) * r2.yzw;
    r3.x = dot(r3.xyz, float3(0.333333343,0.333333343,0.333333343));
    r3.xyz = r2.yzw * float3(0.0700000003,0.0700000003,0.0700000003) + r3.xxx;
    r3.xyz = floor(r3.xyz);
    r2.yzw = r2.yzw * float3(0.0700000003,0.0700000003,0.0700000003) + -r3.xyz;
    r3.w = dot(r3.xyz, float3(0.166666672,0.166666672,0.166666672));
    r2.yzw = r3.www + r2.yzw;
    r4.xyz = cmp(r2.wyz >= r2.yzw);
    r5.xyz = r4.yzx ? float3(1,1,1) : 0;
    r4.xyz = r4.xyz ? float3(0,0,0) : float3(1,1,1);
    r6.xyz = min(r5.xyz, r4.xyz);
    r4.xyz = max(r5.yzx, r4.yzx);
    r5.xyz = -r6.xyz + r2.yzw;
    r5.xyz = float3(0.166666672,0.166666672,0.166666672) + r5.xyz;
    r7.xyz = -r4.zxy + r2.yzw;
    r7.xyz = float3(0.333333343,0.333333343,0.333333343) + r7.xyz;
    r8.xyz = float3(-0.5,-0.5,-0.5) + r2.yzw;
    r9.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r3.xyz;
    r9.xyz = floor(r9.xyz);
    r3.xyz = -r9.xyz * float3(289,289,289) + r3.xyz;
    r9.xw = float2(0,1);
    r9.y = r6.z;
    r9.z = r4.y;
    r9.xyzw = r9.xyzw + r3.zzzz;
    r10.xyzw = r9.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
    r9.xyzw = r10.xyzw * r9.xyzw;
    r10.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r9.xyzw;
    r10.xyzw = floor(r10.xyzw);
    r9.xyzw = -r10.xyzw * float4(289,289,289,289) + r9.xyzw;
    r9.xyzw = r9.xyzw + r3.yyyy;
    r10.xw = float2(0,1);
    r10.y = r6.y;
    r10.z = r4.x;
    r9.xyzw = r10.xyzw + r9.xyzw;
    r10.xyzw = r9.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
    r9.xyzw = r10.xyzw * r9.xyzw;
    r10.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r9.xyzw;
    r10.xyzw = floor(r10.xyzw);
    r9.xyzw = -r10.xyzw * float4(289,289,289,289) + r9.xyzw;
    r3.xyzw = r9.xyzw + r3.xxxx;
    r4.xw = float2(0,1);
    r4.y = r6.x;
    r3.xyzw = r4.xyzw + r3.xyzw;
    r4.xyzw = r3.xyzw * float4(34,34,34,34) + float4(1,1,1,1);
    r3.xyzw = r4.xyzw * r3.xyzw;
    r4.xyzw = float4(0.00346020772,0.00346020772,0.00346020772,0.00346020772) * r3.xyzw;
    r4.xyzw = floor(r4.xyzw);
    r3.xyzw = -r4.xyzw * float4(289,289,289,289) + r3.xyzw;
    r4.xyzw = float4(0.0204081647,0.0204081647,0.0204081647,0.0204081647) * r3.xyzw;
    r4.xyzw = floor(r4.xyzw);
    r3.xyzw = -r4.xyzw * float4(49,49,49,49) + r3.xyzw;
    r4.xyzw = float4(0.142857149,0.142857149,0.142857149,0.142857149) * r3.xyzw;
    r4.xyzw = floor(r4.xyzw);
    r3.xyzw = -r4.xyzw * float4(7,7,7,7) + r3.xyzw;
    r4.xyzw = r4.xyzw * float4(0.285714298,0.285714298,0.285714298,0.285714298) + float4(-0.928571403,-0.928571403,-0.928571403,-0.928571403);
    r3.xyzw = r3.xzyw * float4(0.285714298,0.285714298,0.285714298,0.285714298) + float4(-0.928571403,-0.928571403,-0.928571403,-0.928571403);
    r6.xyzw = float4(1,1,1,1) + -abs(r4.xyzw);
    r6.xyzw = r6.xywz + -abs(r3.xzwy);
    r9.xz = floor(r4.xy);
    r9.yw = floor(r3.xz);
    r9.xyzw = r9.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
    r10.xz = floor(r4.zw);
    r10.yw = floor(r3.yw);
    r10.xyzw = r10.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
    r11.xyzw = cmp(float4(0,0,0,0) >= r6.xywz);
    r11.xyzw = r11.xyzw ? float4(-1,-1,-1,-1) : float4(-0,-0,-0,-0);
    r12.xz = r4.xy;
    r12.yw = r3.xz;
    r9.xyzw = r9.zwxy * r11.yyxx + r12.zwxy;
    r3.xz = r4.zw;
    r3.xyzw = r10.xyzw * r11.zzww + r3.xyzw;
    r4.xy = r9.zw;
    r4.z = r6.x;
    r10.x = dot(r4.xyz, r4.xyz);
    r9.z = r6.y;
    r10.y = dot(r9.xyz, r9.xyz);
    r11.xy = r3.xy;
    r11.z = r6.w;
    r10.z = dot(r11.xyz, r11.xyz);
    r6.xy = r3.zw;
    r10.w = dot(r6.xyz, r6.xyz);
    r3.xyzw = -r10.xyzw * float4(0.853734732,0.853734732,0.853734732,0.853734732) + float4(1.79284286,1.79284286,1.79284286,1.79284286);
    r4.xyz = r4.xyz * r3.xxx;
    r9.xyz = r9.xyz * r3.yyy;
    r3.xyz = r11.xyz * r3.zzz;
    r6.xyz = r6.xyz * r3.www;
    r10.x = dot(r2.yzw, r2.yzw);
    r10.y = dot(r5.xyz, r5.xyz);
    r10.z = dot(r7.xyz, r7.xyz);
    r10.w = dot(r8.xyz, r8.xyz);
    r10.xyzw = float4(0.600000024,0.600000024,0.600000024,0.600000024) + -r10.xyzw;
    r10.xyzw = max(float4(0,0,0,0), r10.xyzw);
    r10.xyzw = r10.xyzw * r10.xyzw;
    r10.xyzw = r10.xyzw * r10.xyzw;
    r4.x = dot(r4.xyz, r2.yzw);
    r4.y = dot(r9.xyz, r5.xyz);
    r4.z = dot(r3.xyz, r7.xyz);
    r4.w = dot(r6.xyz, r8.xyz);
    r2.y = dot(r10.xyzw, r4.xyzw);
    r2.y = r2.y * 42 + 1;
    r2.y = 0.5 * r2.y;
    r2.z = rcp(r2.y);
    r2.z = saturate(r2.z);
    r1.yzw = -cb2[5].xyz + r1.yzw;
    r1.y = dot(r1.yzw, r1.yzw);
    r1.y = sqrt(r1.y);
    r1.z = 1 / cb2[8].y;
    r1.y = saturate(r1.y * r1.z);
    r1.z = r1.y * -2 + 3;
    r1.y = r1.y * r1.y;
    r1.y = -r1.z * r1.y + 1;
    r1.z = 1 + -r1.x;
    r1.x = r1.z * cb2[9].x + r1.x;
    r1.z = r2.y * r2.z;
    r1.z = log2(abs(r1.z));
    r1.z = cb2[6].z * r1.z;
    r1.z = exp2(r1.z);
    r1.w = cmp(r1.z < cb2[6].w);
    r1.z = cb2[6].x * r1.z;
    r1.z = r1.w ? 0 : r1.z;
    r1.x = r1.z * r1.x;
    r1.x = r1.x * r1.y;
  } else {
    r1.x = 0;
  }
  r1.y = 1 + -cb2[7].w;
  r2.w = r1.x * r2.x;
  r2.xyz = cb2[9].yzw * r2.www;
  o0.xyzw = r0.xyzw * r1.yyyy + r2.xyzw;
  return;
}