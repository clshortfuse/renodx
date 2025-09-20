// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 10 23:13:27 2025
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

cbuffer cb0 : register(b0)
{
  float4 cb0[12];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = float2(-12.25,-8) * cb0[5].ww;
  r0.z = sin(r0.z);
  r0.z = 1 + r0.z;
  r1.y = r0.z * 0.150000006 + 0.100000001;
  r1.x = 4 * cb0[5].w;
  r0.zw = v2.xy * float2(-0.280000001,0.219999999) + r1.xy;
  r1.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r2.xyz = float3(0.0174532942,-12.25,3) * cb0[5].xww;
  r0.z = cos(r2.y);
  r0.z = 1 + r0.z;
  r0.y = r0.z * -0.104999997 + 0.289999992;
  r0.xy = v2.xy * r0.xy + r0.xy;
  r0.xyzw = t1.Sample(s2_s, r0.xy).xyzw;
  r3.xyzw = max(float4(9.99999975e-06,9.99999975e-06,9.99999975e-06,9.99999975e-06), r0.xyzw);
  r0.x = r0.w + r1.w;
  r3.xyzw = r1.xyzw / r3.xyzw;
  r3.xyzw = r3.xyzw + -r1.xyzw;
  r0.xyzw = saturate(r0.xxxx * r3.xyzw + r1.xyzw);
  r1.x = cb0[5].w + cb0[5].w;
  r1.x = sin(r1.x);
  r2.w = 0;
  r1.xy = r2.zw + r1.xx;
  r1.xy = v2.xy * float2(0.349999994,0.75) + r1.xy;
  r1.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r2.y = sin(cb0[5].w);
  r2.yz = r2.yy * float2(2,2) + r2.wz;
  sincos(r2.x, r2.x, r3.x);
  r2.yz = v2.xy * float2(0.349999994,0.75) + r2.yz;
  r4.xyzw = t0.Sample(s1_s, r2.yz).xyzw;
  r4.xyzw = max(float4(9.99999975e-06,9.99999975e-06,9.99999975e-06,9.99999975e-06), r4.xyzw);
  r1.xyzw = saturate(r1.xyzw / r4.xyzw);
  r0.xyzw = r1.xyzw * r0.xyzw;
  r3.y = r2.x;
  r1.xy = float2(-0.5,-0.5) + v2.xy;
  r1.x = dot(r1.xy, r3.xy);
  r1.x = 0.5 + r1.x;
  r1.x = 1 + -r1.x;
  r1.y = 1 + -cb0[6].w;
  r1.y = r1.y * 1.29999995 + r1.x;
  r1.y = -0.99000001 + r1.y;
  r1.y = 3.84615397 * r1.y;
  r2.xz = float2(0,1);
  r1.zw = cb0[7].xy * cb0[5].ww + v2.xy;
  r2.w = 1 / cb0[6].y;
  r1.zw = r1.zw / r2.ww;
  r1.zw = trunc(r1.zw);
  r1.zw = r1.zw * r2.ww;
  r3.xy = cb0[7].zz * r1.zw;
  r3.x = dot(r3.xy, float2(0.366025418,0.366025418));
  r3.xy = r1.zw * cb0[7].zz + r3.xx;
  r3.xy = floor(r3.xy);
  r3.zw = float2(0.00346020772,0.00346020772) * r3.xy;
  r3.zw = floor(r3.zw);
  r3.zw = -r3.zw * float2(289,289) + r3.xy;
  r1.zw = r1.zw * cb0[7].zz + -r3.xy;
  r3.x = dot(r3.xy, float2(0.211324871,0.211324871));
  r1.zw = r3.xx + r1.zw;
  r3.x = cmp(r1.w < r1.z);
  r4.xyzw = r3.xxxx ? float4(1,0,-1,-0) : float4(0,1,-0,-1);
  r2.y = r4.y;
  r2.xyz = r3.www + r2.xyz;
  r3.xyw = r2.xyz * float3(34,34,34) + float3(1,1,1);
  r2.xyz = r3.xyw * r2.xyz;
  r3.xyw = float3(0.00346020772,0.00346020772,0.00346020772) * r2.xyz;
  r3.xyw = floor(r3.xyw);
  r2.xyz = -r3.xyw * float3(289,289,289) + r2.xyz;
  r2.xyz = r2.xyz + r3.zzz;
  r3.xz = float2(0,1);
  r3.y = r4.x;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = r2.xyz * float3(34,34,34) + float3(1,1,1);
  r2.xyz = r3.xyz * r2.xyz;
  r3.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r2.xyz;
  r3.xyz = floor(r3.xyz);
  r2.xyz = -r3.xyz * float3(289,289,289) + r2.xyz;
  r2.xyz = float3(0.024390243,0.024390243,0.024390243) * r2.xyz;
  r2.xyz = frac(r2.xyz);
  r3.xyz = r2.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r3.xyz = floor(r3.xyz);
  r3.xyz = -r3.xyz + r2.xyz;
  r2.xyz = float3(-0.5,-0.5,-0.5) + abs(r2.xyz);
  r5.xyz = r2.xyz * r2.xyz;
  r5.xyz = r3.xyz * r3.xyz + r5.xyz;
  r5.xyz = -r5.xyz * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
  r6.x = dot(r1.zw, r1.zw);
  r7.xyzw = float4(0.211324871,0.211324871,-0.577350259,-0.577350259) + r1.zwzw;
  r7.xy = r7.xy + r4.zw;
  r6.y = dot(r7.xy, r7.xy);
  r6.z = dot(r7.zw, r7.zw);
  r4.xyz = float3(0.5,0.5,0.5) + -r6.xyz;
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = r4.xyz * r4.xyz;
  r4.xyz = r4.xyz * r4.xyz;
  r4.xyz = r4.xyz * r5.xyz;
  r1.w = r2.x * r1.w;
  r2.xy = r7.yw * r2.yz;
  r2.yz = r3.yz * r7.xz + r2.xy;
  r2.x = r3.x * r1.z + r1.w;
  r1.z = dot(r4.xyz, r2.xyz);
  r1.z = r1.z * 65 + 0.5;
  r1.y = -r1.y * r1.z + 0.0421942919;
  r1.y = saturate(3.63010526 * r1.y);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r1.z * r1.y;
  r1.y = ceil(r1.y);
  r1.z = 1 + -r1.y;
  r0.xyzw = r1.zzzz * r0.xyzw;
  r0.w = cb0[7].w * r0.w;
  r2.x = cb0[5].z * cb0[5].w;
  r2.y = cb0[6].x * cb0[5].w;
  r1.zw = v2.xy + r2.xy;
  r1.zw = r1.zw / r2.ww;
  r1.zw = trunc(r1.zw);
  r1.zw = r1.zw * r2.ww;
  r2.xy = cb0[6].zz * r1.zw;
  r2.x = dot(r2.xy, float2(0.366025418,0.366025418));
  r2.xy = r1.zw * cb0[6].zz + r2.xx;
  r2.xy = floor(r2.xy);
  r2.zw = float2(0.00346020772,0.00346020772) * r2.xy;
  r2.zw = floor(r2.zw);
  r2.zw = -r2.zw * float2(289,289) + r2.xy;
  r1.zw = r1.zw * cb0[6].zz + -r2.xy;
  r2.x = dot(r2.xy, float2(0.211324871,0.211324871));
  r1.zw = r2.xx + r1.zw;
  r2.x = cmp(r1.w < r1.z);
  r3.xyzw = r2.xxxx ? float4(1,0,-1,-0) : float4(0,1,-0,-1);
  r4.y = r3.y;
  r4.xz = float2(0,1);
  r2.xyw = r4.xyz + r2.www;
  r4.xyz = r2.xyw * float3(34,34,34) + float3(1,1,1);
  r2.xyw = r4.xyz * r2.xyw;
  r4.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r2.xyw;
  r4.xyz = floor(r4.xyz);
  r2.xyw = -r4.xyz * float3(289,289,289) + r2.xyw;
  r2.xyz = r2.xyw + r2.zzz;
  r4.y = r3.x;
  r4.xz = float2(0,1);
  r2.xyz = r4.xyz + r2.xyz;
  r4.xyz = r2.xyz * float3(34,34,34) + float3(1,1,1);
  r2.xyz = r4.xyz * r2.xyz;
  r4.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r2.xyz;
  r4.xyz = floor(r4.xyz);
  r2.xyz = -r4.xyz * float3(289,289,289) + r2.xyz;
  r2.xyz = float3(0.024390243,0.024390243,0.024390243) * r2.xyz;
  r2.xyz = frac(r2.xyz);
  r4.xyz = r2.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r4.xyz = floor(r4.xyz);
  r4.xyz = -r4.xyz + r2.xyz;
  r2.xyz = float3(-0.5,-0.5,-0.5) + abs(r2.xyz);
  r2.w = r2.x * r1.w;
  r5.x = r4.x * r1.z + r2.w;
  r6.x = dot(r1.zw, r1.zw);
  r7.xyzw = float4(0.211324871,0.211324871,-0.577350259,-0.577350259) + r1.zwzw;
  r6.z = dot(r7.zw, r7.zw);
  r7.xy = r7.xy + r3.zw;
  r6.y = dot(r7.xy, r7.xy);
  r3.xyz = float3(0.5,0.5,0.5) + -r6.xyz;
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r3.xyz = r3.xyz * r3.xyz;
  r3.xyz = r3.xyz * r3.xyz;
  r6.xyz = r2.xyz * r2.xyz;
  r1.zw = r7.yw * r2.yz;
  r5.yz = r4.yz * r7.xz + r1.zw;
  r2.xyz = r4.xyz * r4.xyz + r6.xyz;
  r2.xyz = -r2.xyz * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
  r2.xyz = r3.xyz * r2.xyz;
  r1.z = dot(r2.xyz, r5.xyz);
  r1.z = r1.z * 65 + 0.5;
  r1.w = 1 + -cb0[5].y;
  r1.x = r1.w * 1.29999995 + r1.x;
  r1.x = -0.99000001 + r1.x;
  r1.x = 3.84615397 * r1.x;
  r1.x = -r1.x * r1.z + 0.0785427839;
  r1.x = saturate(3.1953516 * r1.x);
  r1.z = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.z * r1.x;
  r1.x = ceil(r1.x);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xz = v2.xy * cb0[11].xy + cb0[11].zw;
  r2.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r1.xz = v2.xy * cb0[10].xy + cb0[10].zw;
  r3.xyzw = t3.Sample(s3_s, r1.xz).xyzw;
  r1.xz = v2.xy * cb0[8].xy + cb0[8].zw;
  r4.xyzw = t2.Sample(s0_s, r1.xz).xyzw;
  r3.xyzw = -r4.xyzw + r3.xyzw;
  r3.xyzw = v1.yyyy * r3.xyzw + r4.xyzw;
  r1.x = r4.w / cb0[9].x;
  r2.xyzw = -r3.xyzw + r2.xyzw;
  r2.xyzw = v1.xxxx * r2.xyzw + r3.xyzw;
  r2.xyzw = r2.xyzw * r1.yyyy;
  r0.xyzw = r0.xyzw * r1.xxxx + r2.xyzw;
  o0.xyzw = v1.wwww * r0.xyzw;
  
  o0 = saturate(o0);
  
  return;
}