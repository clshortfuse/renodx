// ---- Created with 3Dmigoto v1.3.16 on Sat Mar  1 01:01:15 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[5].xy + cb0[5].zw;
  r0.zw = float2(-0.5,-0.5) + r0.xy;
  r0.zw = float2(2.20000005,2.20000005) * r0.zw;
  r1.x = 0.200000003 * abs(r0.w);
  r1.x = r1.x * r1.x + 1;
  r1.x = r1.x * r0.z;
  r0.z = 0.25 * abs(r1.x);
  r0.z = r0.z * r0.z + 1;
  r1.y = r0.w * r0.z;
  r0.zw = r1.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.zw = r0.zw * float2(0.920000017,0.920000017) + float2(0.0399999991,0.0399999991);
  r0.zw = r0.zw + -r0.xy;
  r0.xy = saturate(cb0[3].xx * r0.zw + r0.xy);
  r0.zw = float2(21,29) * r0.yy;
  r0.zw = cb0[2].xx * float2(0.300000012,0.699999988) + r0.zw;
  r0.zw = sin(r0.zw);
  r0.z = r0.z * r0.w;
  r0.w = cb0[2].x * 0.330000013 + 0.300000012;
  r0.w = r0.y * 31 + r0.w;
  r0.w = sin(r0.w);
  r0.z = r0.z * r0.w;
  r0.z = r0.z * 0.00170000002 + r0.x;
  r1.x = 0.00100000005 + r0.z;
  r1.y = 0.00100000005 + r0.y;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyz = float3(0.0500000007,0.0500000007,0.0500000007) + r1.xyz;
  r2.xyz = r1.xyz * r1.xyz;
  r2.xyz = float3(0.400000006,0.400000006,0.400000006) * r2.xyz;
  //r1.xyz = saturate(r1.xyz * float3(0.600000024,0.600000024,0.600000024) + r2.xyz);
  r1.xyz = (r1.xyz * float3(0.600000024,0.600000024,0.600000024) + r2.xyz);
  r0.z = -cb0[2].x * cb0[2].z;
  r0.z = frac(r0.z);
  r0.z = r0.y * cb0[2].y + -r0.z;
  r0.z = -0.0500000007 + r0.z;
  r0.z = max(0, r0.z);
  r0.z = min(0.100000001, r0.z);
  r0.w = r0.z * 10 + -0.5;
  r0.z = 100 * r0.z;
  r0.z = sin(r0.z);
  r0.w = r0.w * r0.w;
  r0.w = r0.w * -4 + 1;
  r0.z = r0.z * r0.w;
  r2.x = 0.0199999996 * r0.z;
  r2.y = 0;
  r0.xy = r2.xy + r0.xy;
  r0.z = r0.y * r0.x;
  r0.z = 16 * r0.z;
  r2.xy = float2(1,1) + -r0.xy;
  r0.z = r2.x * r0.z;
  r0.z = r0.z * r2.y;
  r0.z = log2(r0.z);
  r0.z = 0.300000012 * r0.z;
  r0.z = exp2(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r1.xyz = float3(2.66000009,2.94000006,2.66000009) * r1.xyz;
  r0.z = cb0[4].y * r0.y;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xw = float2(3.5,110) * cb0[2].xx;
  r0.x = r0.z * 1.5 + r0.x;
  r0.xw = sin(r0.xw);
  r0.x = r0.x * 0.349999994 + 0.349999994;
  r0.x = log2(r0.x);
  r0.x = 1.70000005 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = cb0[2].w * r0.x;
  r0.x = r0.x * 0.699999988 + 0.400000006;
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = r0.w * 0.00999999978 + 1;
  r0.xyz = r0.xyz * r0.www + -r2.xyz;
  o0.xyz = cb0[3].xxx * r0.xyz + r2.xyz;
  o0.w = 1;
  return;
}