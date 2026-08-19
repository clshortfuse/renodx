// Stolen from Luma UE!

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<uint4> t0 : register(t0);

SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[5];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[143];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}

#define cmp

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  r0.xyz = float3(0.772831857,9.66039753,-3) * cb1[142].w;
  r0.xy = sin(r0.xy);
  r1.xyzw = float4(6.28318548,0.891728759,2.24009228,12.8805304) * cb1[142].w;
  r1.xyzw = sin(r1.xyzw);
  r0.x = r1.z * 0.9 + r0.x;
  r0.x = r0.y * 0.4 + r0.x;
  r0.y = cmp(r0.x >= 0);
  r0.x = cmp(9.99999975e-006 < abs(r0.x));
  r0.y = r0.y ? -0.361905009 : -0.23;
  r0.x = r0.x ? r0.y : -0.361905009;
  r0.y = r1.z * 0.5 + r1.y;
  r0.y = r1.w * 0.2 + r0.y;
  r0.x = r0.y * 0.0666 + r0.x;
  r0.yw = asuint(cb0[37].xy);
  r0.yw = v0.xy + -r0.yw;
  r2.w = r0.w * cb0[38].w + r0.x;
  r2.yz = cb0[38].wz * r0.wy;
  r0.x = t2.Sample(s0_s, r2.zw).x;
  r1.y = log2(r0.x);
  r0.x = cmp(0 >= r0.x);
  r1.y = 0.4545 * r1.y;
  r1.y = exp2(r1.y);
  r0.x = r0.x ? 0 : r1.y;
  r1.xy = r2.zy * float2(3,3) + r1.xx;
  r1.x = t1.Sample(s0_s, r1.xy).x;
  r1.y = 1 + -r1.x;
  r1.zw = r2.zy * cb0[5].xy + cb0[4].xy;
  r3.xy = max(cb0[6].xy, r1.zw);
  r4.xyz = t8.Sample(s1_s, r1.zw).xyz;
  r1.zw = min(cb0[6].zw, r3.xy);
  r3.xyz = t8.Sample(s1_s, r1.zw).xyz;
  r5.xyz = 1.0 + -r3.xyz;
  r5.xyz = r5.xyz + r5.xyz;
  r1.yzw = -r5.xyz * r1.y + 1.0;
  r5.xyz = r3.xyz * r1.x;
  r3.xyz = cmp(r3.xyz >= 0.5);
  r5.xyz = r5.xyz + r5.xyz;
  r1.xyz = r3.xyz ? r1.yzw : r5.xyz;
  r1.xyz = r1.xyz + -r4.xyz;
  r1.xyz = r0.x * r1.xyz + r4.xyz;
  r0.x = r2.y * 4 + r0.z;
  r0.x = 184.257645 * r0.x;
  r0.x = sin(r0.x);
  r0.z = r2.y * 4 + cb1[142].w;
  r3.xy = float2(50.8266068,418.879028) * r0.zz;
  r3.xy = sin(r3.xy);
  r0.x = r3.x + r0.x;
  r0.x = r0.x + r3.y;
  r2.x = r0.x * 0.003 + r2.z;
  r0.xz = r2.xy * cb0[5].xy + cb0[4].xy;
  r0.xz = max(cb0[6].xy, r0.xz);
  r0.xz = min(cb0[6].zw, r0.xz);
  r3.xyz = t8.Sample(s1_s, r0.xz).xyz;
  r3.xyz = r3.xyz + -r1.xyz;
  r0.x = cb4[2].y * cb1[142].w;
  r5.xyz = float3(7.24982691,10.3083477,14.342061) * r0.xxx;
  r5.xyz = sin(r5.xyz);
  r0.x = r5.x + r5.y;
  r0.x = r0.x + r5.z;
  r0.x = cb4[2].z * r0.x;
  r0.x = saturate(r0.x * 0.333 + cb4[2].w);
  r5.xy = float2(3.14159274,3.14159274) * r2.zy;
  r5.xy = sin(-r5.xy);
  r5.xy = float2(1,1) + r5.xy;
  r0.z = r5.x + r5.y;
  r0.z = saturate(-r0.x * 1.54289699 + r0.z);
  r0.x = 1 + -r0.x;
  r1.w = rsqrt(r0.z);
  r1.w = 1 / r1.w;
  r1.w = min(1, r1.w);
  r2.w = cmp(0 >= r0.z);
  r0.z = log2(r0.z);
  r5.xy = float2(0.9,4.6) * r0.zz;
  r5.xy = exp2(r5.xy);
  r0.z = r2.w ? 0 : r1.w;
  r1.xyz = r0.zzz * r3.xyz + r1.xyz;
  r1.w = cb1[130].y / cb1[130].x;
  r3.y = 40 * r1.w;
  r3.xw = float2(40,0.03);
  r5.zw = r3.xy * r2.zy;
  r5.zw = round(r5.zw);
  r3.xy = r5.zw / r3.xy;
  r3.xy = r3.xy * cb0[5].xy + cb0[4].xy;
  r3.xy = max(cb0[6].xy, r3.xy);
  r3.xy = min(cb0[6].zw, r3.xy);
  r6.xyz = t8.Sample(s1_s, r3.xy).xyz;
  r6.xyz = r6.xyz + -r1.xyz;
  r1.w = r2.w ? 0 : r5.x;
  r3.x = min(0.152381003, r5.y);
  r2.w = r2.w ? 0 : r3.x;
  r3.z = 0.05 * cb1[142].w;
  r3.xy = t3.Sample(s0_s, r3.zw).xy;
  r3.xy = r3.xy * float2(2,2) + float2(-1,-1);
  r3.xy = r3.xy * float2(50,50) + r2.zy;
  r3.z = t4.Sample(s0_s, r3.xy).x;
  r3.xyw = t6.Sample(s0_s, r3.xy).xyz;
  r3.xyw = r3.xyw * r0.zzz;
  r3.xyw = 0.1 * r3.xyw;
  r5.x = 0.05 * cb1[142].w;
  r5.yz = float2(0.01,0);
  r5.xy = t5.Sample(s0_s, r5.xy).xy;
  r5.xy = r5.xy * float2(2,2) + float2(-1,-1);
  r5.xy = r5.xy * float2(50,50) + r2.zy;
  r5.xy = float2(1.5,1.5) * r5.xy;
  r0.z = t4.Sample(s0_s, r5.xy).x;
  r0.z = r3.z * r0.z + r1.w;
  r0.z = saturate(-1 + r0.z);
  r1.xyz = r0.zzz * r6.xyz + r1.xyz;
  r6.xyz = float3(1.2566371,0.25,0.2) * cb1[142].wzz;
  r0.z = sin(r6.x);
  r0.z = 1 + r0.z;
  r2.x = r0.z * 0.1 + 0.4;
  r5.xy = r2.xy * cb0[5].xy + cb0[4].xy;
  r5.xy = max(cb0[6].xy, r5.xy);
  r5.xy = min(cb0[6].zw, r5.xy);
  r7.xyz = t8.Sample(s1_s, r5.xy).xyz;
  r7.xyz = r7.xyz + -r1.xyz;
  r1.xyz = r2.www * r7.xyz + r1.xyz;
  r1.xyz = r3.xyw * r0.xxx + r1.xyz;
  r3.xyz = float3(1,0,0) + -r1.xyz;
  r0.x = cb4[3].x * cb1[130].z;
  r5.w = r0.x + r0.x;
  r5.x = 0.5 * r0.x;
  r0.xz = r0.yw * cb0[38].zw + r5.zw;
  r0.xz = r0.xz * cb1[130].xy + cb1[129].xy;
  r0.xz = cb1[132].zw * r0.xz;
  r0.xz = max(cb1[133].xy, r0.xz);
  r0.xz = min(cb1[133].zw, r0.xz);
  r0.xz = cb1[132].xy * r0.xz;
  r0.xz = trunc(r0.xz);
  r0.x = t0.Load(int3(r0.xz, 0)).y; // utof
  r2.xw = r2.zy * cb1[130].xy + cb1[129].xy;
  r2.yz = cb4[4].xx * r2.zy;
  r2.xw = cb1[132].zw * r2.xw;
  r2.xw = max(cb1[133].xy, r2.xw);
  r2.xw = min(cb1[133].zw, r2.xw);
  r2.xw = cb1[132].xy * r2.xw;
  r2.xw = trunc(r2.xw);
  r0.z = t0.Load(int3(r2.xw, 0)).y; // utof
  r0.x = r0.x + -r0.z;
  r5.y = 0;
  r0.yw = r0.yw * cb0[38].zw + r5.xy;
  r0.yw = r0.yw * cb1[130].xy + cb1[129].xy;
  r0.yw = cb1[132].zw * r0.yw;
  r0.yw = max(cb1[133].xy, r0.yw);
  r0.yw = min(cb1[133].zw, r0.yw);
  r0.yw = cb1[132].xy * r0.yw;
  r0.yw = trunc(r0.yw);
  r0.y = t0.Load(int3(r0.yw, 0)).y; // utof
  r0.y = r0.y + -r0.z;
  r0.x = abs(r0.x) + abs(r0.y);
  r0.xyz = r0.xxx * r3.xyz;
  r0.xyz = cb2[0].xxx * r0.xyz + r1.xyz;
  r1.xyz = r4.xyz + -r4.yxz;
  r1.xyz = cb4[3].zzz * r1.xyz + r4.yxz;
  r1.xyz = cb3[0].xyz * cb4[3].yyy + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = ceil(r6.y);
  r1.w = frac(r6.z);
  r1.w = frac(r1.w);
  r2.xw = float2(4,2) * r1.ww;
  r2.xw = floor(r2.xw);
  r2.xw = float2(0.5,0.5) * r2.xw;
  r2.yz = r0.ww * cb4[3].ww + r2.yz;
  r2.xy = r2.yz * float2(0.5,0.5) + r2.xw;
  r0.w = t7.SampleBias(s0_s, r2.xy, 0).x;
  r1.w = cb4[4].y + -cb4[4].z;
  r0.w = r0.w * r1.w + cb4[4].z;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyz = cb4[1].xyz + -r0.xyz;
  r0.xyz = cb4[4].www * r1.xyz + r0.xyz;
#if 1 // Luma
  o0.xyz = r0.xyz;
#else
  o0.xyz = max(0.0, r0.xyz);
#endif
  o0.w = 1;
}