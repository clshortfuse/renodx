#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Tue Jun 24 12:22:54 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[10];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[149];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = cb0[38].zw * r0.xy;
  r0.zw = r0.zw * cb0[5].xy + cb0[4].xy;

  r1.xyz = t1.Sample(s1_s, r0.zw).xyz;
  r1.xyz = renodx::draw::InvertIntermediatePass(r1.xyz);

  r0.zw = r0.xy * cb0[38].zw + float2(-0.5,-0.5);
  r1.w = dot(r0.zw, r0.zw);
  r1.w = sqrt(r1.w);
  r0.zw = r0.zw / r1.ww;
  r2.xy = r0.xy * cb0[38].zw + cb2[5].xy;
  r1.w = 6.28318548 * cb2[7].z;
  sincos(r1.w, r3.x, r4.x);
  r5.x = -r3.x;
  r5.y = r4.x;
  r4.y = dot(r2.yx, r5.xy);
  r5.z = r3.x;
  r4.x = dot(r2.yx, r5.yz);
  r1.w = dot(r4.xy, r4.xy);
  r1.w = sqrt(r1.w);
  r2.x = max(9.99999975e-06, cb2[0].y);
  r2.x = 1 / r2.x;
  r2.y = 1 + -cb2[0].z;
  r2.y = max(9.99999975e-06, r2.y);
  r2.y = 1 / r2.y;
  r1.w = -r1.w * r2.x + 1;
  r1.w = saturate(r1.w * r2.y);
  r2.x = 0.100000001 * cb1[148].z;
  r2.x = frac(r2.x);
  r2.x = cb2[7].w * r2.x;
  r2.x = floor(r2.x);
  r2.x = 0.25 * r2.x;
  sincos(r2.x, r2.x, r3.x);
  r5.x = -r2.x;
  r2.yz = cb2[7].xy + r4.yx;
  r3.yz = r4.xy + r4.xy;
  r2.w = min(abs(r3.y), abs(r3.z));
  r3.w = max(abs(r3.y), abs(r3.z));
  r3.w = 1 / r3.w;
  r2.w = r3.w * r2.w;
  r3.w = r2.w * r2.w;
  r4.x = r3.w * 0.0208350997 + -0.0851330012;
  r4.x = r3.w * r4.x + 0.180141002;
  r4.x = r3.w * r4.x + -0.330299497;
  r3.w = r3.w * r4.x + 0.999866009;
  r4.x = r3.w * r2.w;
  r4.y = cmp(abs(r3.z) < abs(r3.y));
  r4.x = r4.x * -2 + 1.57079637;
  r4.x = r4.y ? r4.x : 0;
  r2.w = r2.w * r3.w + r4.x;
  r3.w = cmp(r3.z < -r3.z);
  r3.w = r3.w ? -3.141593 : 0;
  r2.w = r3.w + r2.w;
  r3.w = min(r3.y, r3.z);
  r3.y = max(r3.y, r3.z);
  r3.z = cmp(r3.w < -r3.w);
  r3.y = cmp(r3.y >= -r3.y);
  r3.y = r3.y ? r3.z : 0;
  r2.w = r3.y ? -r2.w : r2.w;
  r2.w = 4 + r2.w;
  r4.x = 0.159999996 * r2.w;
  r4.y = 1 + -r1.w;
  r3.yz = cb2[7].xy + r4.xy;
  r3.yz = r3.yz + -r2.yz;
  r2.yz = cb2[0].xx * r3.yz + r2.yz;
  r3.yz = cb2[5].zw * r2.yz + float2(-0.5,-0.5);
  r5.y = r3.x;
  r6.x = dot(r5.yx, r3.yz);
  r5.z = r2.x;
  r6.y = dot(r5.zy, r3.yz);
  r2.xw = float2(0.5,0.5) + r6.xy;
  r3.xy = r2.xw;
  r3.zw = float2(0,0);
  r4.xz = float2(1,0);
  while (true) {
    r4.w = cmp((uint)r4.z >= 6);
    if (r4.w != 0) break;
    r4.w = dot(r3.xy, float2(0.333333343,0.333333343));
    r6.xyz = r4.www + r3.xyz;
    r7.xyz = floor(r6.xyz);
    r8.xyz = float3(1,1,1) + r7.xyz;
    r6.xyz = -r7.xyz + r6.xyz;
    r4.w = max(r6.y, r6.z);
    r4.w = max(r6.x, r4.w);
    r5.w = min(r6.y, r6.z);
    r5.w = min(r6.x, r5.w);
    r9.xyz = cmp(r6.xyz == r4.www);
    r9.xyz = r9.xyz ? float3(1,1,1) : 0;
    r9.xyz = r9.xyz + r7.xyz;
    r6.xyz = cmp(r6.xyz != r5.www);
    r6.xyz = r6.xyz ? float3(1,1,1) : 0;
    r6.xyz = r7.xyz + r6.xyz;
    r10.xy = r7.zz * float2(17,89) + r7.xy;
    r10.xy = float2(0.5,0.5) + r10.xy;
    r10.xy = float2(0.0078125,0.0078125) * r10.xy;
    r10.xyz = t0.SampleLevel(s0_s, r10.xy, 0).xyz;
    r10.xyz = r10.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r11.xy = r8.zz * float2(17,89) + r8.xy;
    r11.xy = float2(0.5,0.5) + r11.xy;
    r11.xy = float2(0.0078125,0.0078125) * r11.xy;
    r11.xyz = t0.SampleLevel(s0_s, r11.xy, 0).xyz;
    r11.xyz = r11.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r12.xy = r9.zz * float2(17,89) + r9.xy;
    r12.xy = float2(0.5,0.5) + r12.xy;
    r12.xy = float2(0.0078125,0.0078125) * r12.xy;
    r12.xyz = t0.SampleLevel(s0_s, r12.xy, 0).xyz;
    r12.xyz = r12.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r13.xy = r6.zz * float2(17,89) + r6.xy;
    r13.xy = float2(0.5,0.5) + r13.xy;
    r13.xy = float2(0.0078125,0.0078125) * r13.xy;
    r13.xyz = t0.SampleLevel(s0_s, r13.xy, 0).xyz;
    r13.xyz = r13.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r4.w = dot(r7.xyz, float3(0.166666672,0.166666672,0.166666672));
    r7.xyz = r7.xyz + -r4.www;
    r4.w = dot(r8.xyz, float3(0.166666672,0.166666672,0.166666672));
    r8.xyz = r8.xyz + -r4.www;
    r4.w = dot(r9.xyz, float3(0.166666672,0.166666672,0.166666672));
    r9.xyz = r9.xyz + -r4.www;
    r4.w = dot(r6.xyz, float3(0.166666672,0.166666672,0.166666672));
    r6.xyz = r6.xyz + -r4.www;
    r7.xyz = -r7.xyz + r3.xyz;
    r4.w = dot(r7.xyz, r7.xyz);
    r4.w = 0.600000024 + -r4.w;
    r4.w = max(0, r4.w);
    r4.w = r4.w * r4.w;
    r4.w = r4.w * r4.w;
    r5.w = dot(r10.xyz, r7.xyz);
    r7.xyz = -r8.xyz + r3.xyz;
    r6.w = dot(r7.xyz, r7.xyz);
    r6.w = 0.600000024 + -r6.w;
    r6.w = max(0, r6.w);
    r6.w = r6.w * r6.w;
    r6.w = r6.w * r6.w;
    r7.x = dot(r11.xyz, r7.xyz);
    r6.w = r7.x * r6.w;
    r7.xyz = -r9.xyz + r3.xyz;
    r7.w = dot(r7.xyz, r7.xyz);
    r7.w = 0.600000024 + -r7.w;
    r7.w = max(0, r7.w);
    r7.w = r7.w * r7.w;
    r7.x = dot(r12.xyz, r7.xyz);
    r6.xyz = -r6.xyz + r3.xyz;
    r7.y = dot(r6.xyz, r6.xyz);
    r7.y = 0.600000024 + -r7.y;
    r7.y = max(0, r7.y);
    r7.yw = r7.yw * r7.yw;
    r7.y = r7.y * r7.y;
    r6.x = dot(r13.xyz, r6.xyz);
    r4.w = r5.w * r4.w + r6.w;
    r4.w = r7.x * r7.w + r4.w;
    r4.w = r6.x * r7.y + r4.w;
    r4.w = 32 * r4.w;
    r3.w = abs(r4.w) * r4.x + r3.w;
    r3.xyz = r3.xyz + r3.xyz;
    r4.x = 0.5 * r4.x;
    r4.z = (int)r4.z + 1;
  }
  r2.x = r3.w * 2 + -1;
  r2.w = cmp(r2.x >= r1.w);
  r2.w = r2.w ? 1.000000 : 0;
  r3.x = cb2[1].y + -cb2[1].x;
  r2.w = r2.w * r3.x + cb2[1].x;
  r2.x = cb2[0].w * r2.x;
  r2.x = r2.x * r1.w;
  r2.x = r2.w * r2.x;
  r0.zw = r2.xx * r0.zw;
  r2.x = cmp(2.98023295e-08 >= r4.y);
  r2.w = log2(r4.y);
  r3.x = cb2[1].w * r2.w;
  r3.x = exp2(r3.x);
  r3.x = cb2[2].x * r3.x;
  r3.x = r2.x ? 0 : r3.x;
  r3.xy = r0.zw * r3.xx + -r0.zw;
  r0.zw = cb2[1].zz * r3.xy + r0.zw;
  r0.xy = r0.xy * cb0[38].zw + r0.zw;
  r0.xy = r0.xy * cb0[5].xy + cb0[4].xy;
  r0.xy = max(cb0[6].xy, r0.xy);
  r0.xy = min(cb0[6].zw, r0.xy);

  r0.xyz = t1.Sample(s1_s, r0.xy).xyz;
  r0.xyz = renodx::draw::InvertIntermediatePass(r0.xyz);

  r0.x = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.y = cmp(2.98023295e-08 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = cb2[2].y * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.y ? 0 : r0.x;
  r0.yz = cb2[6].xy * r2.yz + float2(-0.5,-0.5);
  r3.x = dot(r5.yx, r0.yz);
  r3.y = dot(r5.zy, r0.yz);
  r0.yz = float2(0.5,0.5) + r3.xy;
  r3.xy = r0.yz;
  r3.z = 0;
  r0.w = 0;
  r2.yz = float2(1,0);
  while (true) {
    r3.w = cmp((uint)r2.z >= 6);
    if (r3.w != 0) break;
    r3.w = dot(r3.xy, float2(0.333333343,0.333333343));
    r4.xyz = r3.xyz + r3.www;
    r5.xyz = floor(r4.xyz);
    r6.xyz = float3(1,1,1) + r5.xyz;
    r4.xyz = -r5.xyz + r4.xyz;
    r3.w = max(r4.y, r4.z);
    r3.w = max(r4.x, r3.w);
    r4.w = min(r4.y, r4.z);
    r4.w = min(r4.x, r4.w);
    r7.xyz = cmp(r4.xyz == r3.www);
    r7.xyz = r7.xyz ? float3(1,1,1) : 0;
    r7.xyz = r7.xyz + r5.xyz;
    r4.xyz = cmp(r4.xyz != r4.www);
    r4.xyz = r4.xyz ? float3(1,1,1) : 0;
    r4.xyz = r5.xyz + r4.xyz;
    r8.xy = r5.zz * float2(17,89) + r5.xy;
    r8.xy = float2(0.5,0.5) + r8.xy;
    r8.xy = float2(0.0078125,0.0078125) * r8.xy;
    r8.xyz = t0.SampleLevel(s0_s, r8.xy, 0).xyz;
    r8.xyz = r8.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r9.xy = r6.zz * float2(17,89) + r6.xy;
    r9.xy = float2(0.5,0.5) + r9.xy;
    r9.xy = float2(0.0078125,0.0078125) * r9.xy;
    r9.xyz = t0.SampleLevel(s0_s, r9.xy, 0).xyz;
    r9.xyz = r9.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r10.xy = r7.zz * float2(17,89) + r7.xy;
    r10.xy = float2(0.5,0.5) + r10.xy;
    r10.xy = float2(0.0078125,0.0078125) * r10.xy;
    r10.xyz = t0.SampleLevel(s0_s, r10.xy, 0).xyz;
    r10.xyz = r10.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r11.xy = r4.zz * float2(17,89) + r4.xy;
    r11.xy = float2(0.5,0.5) + r11.xy;
    r11.xy = float2(0.0078125,0.0078125) * r11.xy;
    r11.xyz = t0.SampleLevel(s0_s, r11.xy, 0).xyz;
    r11.xyz = r11.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r3.w = dot(r5.xyz, float3(0.166666672,0.166666672,0.166666672));
    r5.xyz = r5.xyz + -r3.www;
    r3.w = dot(r6.xyz, float3(0.166666672,0.166666672,0.166666672));
    r6.xyz = r6.xyz + -r3.www;
    r3.w = dot(r7.xyz, float3(0.166666672,0.166666672,0.166666672));
    r7.xyz = r7.xyz + -r3.www;
    r3.w = dot(r4.xyz, float3(0.166666672,0.166666672,0.166666672));
    r4.xyz = r4.xyz + -r3.www;
    r5.xyz = -r5.xyz + r3.xyz;
    r3.w = dot(r5.xyz, r5.xyz);
    r3.w = 0.600000024 + -r3.w;
    r3.w = max(0, r3.w);
    r3.w = r3.w * r3.w;
    r3.w = r3.w * r3.w;
    r4.w = dot(r8.xyz, r5.xyz);
    r5.xyz = -r6.xyz + r3.xyz;
    r5.w = dot(r5.xyz, r5.xyz);
    r5.w = 0.600000024 + -r5.w;
    r5.w = max(0, r5.w);
    r5.w = r5.w * r5.w;
    r5.w = r5.w * r5.w;
    r5.x = dot(r9.xyz, r5.xyz);
    r5.x = r5.x * r5.w;
    r5.yzw = -r7.xyz + r3.xyz;
    r6.x = dot(r5.yzw, r5.yzw);
    r6.x = 0.600000024 + -r6.x;
    r6.x = max(0, r6.x);
    r6.x = r6.x * r6.x;
    r6.x = r6.x * r6.x;
    r5.y = dot(r10.xyz, r5.yzw);
    r4.xyz = -r4.xyz + r3.xyz;
    r5.z = dot(r4.xyz, r4.xyz);
    r5.z = 0.600000024 + -r5.z;
    r5.z = max(0, r5.z);
    r5.z = r5.z * r5.z;
    r5.z = r5.z * r5.z;
    r4.x = dot(r11.xyz, r4.xyz);
    r3.w = r4.w * r3.w + r5.x;
    r3.w = r5.y * r6.x + r3.w;
    r3.w = r4.x * r5.z + r3.w;
    r3.w = 32 * r3.w;
    r0.w = abs(r3.w) * r2.y + r0.w;
    r3.xyz = r3.xyz + r3.xyz;
    r2.y = 0.5 * r2.y;
    r2.z = (int)r2.z + 1;
  }
  r0.y = r0.w * 2 + -1;
  r0.z = 1 + -cb2[3].z;
  r0.z = r0.z * r2.w;
  r0.z = exp2(r0.z);
  r0.z = r2.x ? 0 : r0.z;
  r0.y = r0.y * r0.z + -r1.w;

  // r0.z = 1 / cb2[3].y;
  // r0.y = saturate(r0.y * r0.z);
  // r0.z = r0.y * -2 + 3;
  // r0.y = r0.y * r0.y;
  // r0.y = r0.z * r0.y;
  r0.y = smoothstep(0, cb2[3].y, r0.y);

  // r0.z = cb2[3].w + -r0.x;
  // r0.x = r0.y * r0.z + r0.x;
  r0.x = lerp(r0.x, cb2[3].w, r0.y);

  // r0.y = cb2[3].x + -cb2[2].w;
  // r0.x = -cb2[2].w + r0.x;
  // r0.y = 1 / r0.y;
  // r0.x = saturate(r0.x * r0.y);
  // r0.y = r0.x * -2 + 3;
  // r0.x = r0.x * r0.x;
  // r0.x = r0.y * r0.x;
  r0.x = smoothstep(cb2[2].w, cb2[3].x, r0.x);

  r0.y = r0.x * -2 + 1;
  r0.x = cb2[2].z * r0.y + r0.x;

  // r0.yzw = cb2[9].xyz + -cb2[8].xyz;
  // r0.xyz = r0.xxx * r0.yzw + cb2[8].xyz;
  r0.xyz = lerp(cb2[8].xyz,
                cb2[9].xyz * (RENODX_PEAK_NITS / RENODX_GAME_NITS),
                r0.x);

  // r0.xyz = r0.xyz + -r1.xyz;
  // r0.xyz = cb2[4].xxx * r0.xyz + r1.xyz;
  r0.xyz = lerp(r1.xyz, r0.xyz, cb2[4].x);

  // r1.xyz = cb3[1].xyz + -r0.xyz;
  // r0.xyz = cb3[2].xxx * r1.xyz + r0.xyz;
  r0.xyz = lerp(r0.xyz, cb3[1].xyz, cb3[2].x);

  o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = 1;

  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);

  return;
}