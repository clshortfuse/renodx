Texture2D<float4> t12 : register(t12);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[14];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float4 v5 : TEXCOORD6,
  float4 v6 : TEXCOORD7,
  float4 v7 : TEXCOORD8,
  float4 v8 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[3].xx + v8.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -w0.x + r0.x;
  r0.x = saturate(r0.x / cb0[12].x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = -r0.y * r0.x + 1;
  r0.x = r0.y * r0.x;
  r0.y = max(0, r0.z);
  r0.x = dot(r0.xx, r0.yy);
  r0.y = 1 / cb0[13].x;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = 1 + -cb0[10].x;
  r0.y = 1 / r0.y;
  r1.xyz = t6.Sample(s6_s, v0.xy).xyw;
  r1.xyz = r1.xyz * float3(2,2,1) + float3(-1,-1,0);
  r2.z = v0.y;
  r2.xy = cb0[1].xx * float2(-2,-0.800000012) + v0.xx;
  r0.z = t5.Sample(s5_s, r2.yz).y;
  r2.x = 0.100000001 * r2.x;
  r2.y = v0.y;
  r2.z = t5.Sample(s5_s, r2.xy).x;
  r0.w = r2.z + r0.z;
  r2.xy = -r2.zz * r0.zz + r0.ww;
  r1.xyz = r2.xyz * r1.xyz;
  r0.z = cb0[6].x * r2.y;
  r0.w = cb0[7].x * r2.y;
  r2.xy = float2(2,1) * v0.xy;
  r2.xy = t4.Sample(s4_s, r2.xy).xy;
  r2.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r2.xy = r2.xy * r0.zz;
  r2.zw = r1.xy * float2(0.238532007,0.238532007) + -r2.xy;
  r0.z = 0.238532007 * r1.z;
  r1.zw = r0.zz * r2.zw + r2.xy;
  r2.xy = float2(0.5,0.5) * r2.xy;
  r3.xy = v0.yx + r1.zw;
  r1.z = t0.Sample(s0_s, r3.xy).w;
  r1.w = cb0[10].x * v6.w;
  r1.z = r1.z * cb0[10].x + r1.w;
  r1.z = -cb0[10].x + r1.z;
  r0.y = saturate(r1.z * r0.y);
  r1.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r1.z * r0.y;
  r0.y = v6.x * r0.y;
  r0.y = cb0[11].x * r0.y;
  r1.z = r0.y * r0.x + -cb0[2].x;
  r0.x = r0.y * r0.x;
  o0.w = r0.x;
  r0.x = cmp(r1.z < 0);
  if (r0.x != 0) discard;
  r0.xy = r1.xy * float2(0.238532007,0.238532007) + -r2.xy;
  r0.xy = r0.zz * r0.xy + r2.xy;
  r0.xy = v0.yx + r0.xy;
  r0.z = 2 * r0.y;
  r1.xyz = t2.Sample(s2_s, r0.xz).xyz;
  r0.x = t5.Sample(s5_s, r0.xz).z;
  r3.z = 2 * r3.y;
  r0.yz = t3.Sample(s3_s, r3.xz).xy;
  r2.xy = r0.yz * float2(2,2) + float2(-1,-1);
  r0.y = dot(r2.xy, r2.xy);
  r0.y = 1 + -r0.y;
  r0.y = max(0, r0.y);
  r2.z = sqrt(r0.y);
  r0.y = dot(r2.xyz, r2.xyz);
  r0.y = rsqrt(r0.y);
  r2.xyz = r2.xyz * r0.yyy;
  r4.xyz = v1.xyz * r2.yyy;
  r2.xyw = r2.xxx * v2.xyz + r4.xyz;
  r2.xyz = r2.zzz * v4.xyz + r2.xyw;
  r0.y = dot(r2.xyz, r2.xyz);
  r0.y = sqrt(r0.y);
  r3.yw = cmp(float2(9.99999991e-38,0) < r0.yy);
  r0.z = (int)-r3.w;
  r1.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r1.w ? r0.z : 9.99999991e-38;
  r0.y = r3.y ? r0.y : r0.z;
  r2.xyz = r2.xyz / r0.yyy;
  r0.y = saturate(dot(r2.xyz, -v3.xyz));
  r0.y = 1 + -r0.y;
  r0.z = dot(v4.xyz, v3.xyz);
  r2.xy = cmp(float2(9.99999991e-38,0) < abs(r0.zz));
  r1.w = (int)-r2.y;
  r2.y = cmp(r1.w != 0.000000);
  r1.w = 9.99999991e-38 * r1.w;
  r1.w = r2.y ? r1.w : 9.99999991e-38;
  r0.z = r2.x ? abs(r0.z) : r1.w;
  r0.z = log2(r0.z);
  r0.z = 16 * r0.z;
  r0.z = exp2(r0.z);
  r0.y = r0.z + r0.y;
  r2.xy = cmp(float2(9.99999991e-38,0) < r0.yy);
  r0.z = (int)-r2.y;
  r1.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r1.w ? r0.z : 9.99999991e-38;
  r0.y = r2.x ? r0.y : r0.z;
  r0.y = log2(r0.y);
  r0.y = 16 * r0.y;
  r0.y = exp2(r0.y);
  r2.xyzw = t2.Sample(s2_s, r3.xz).xyzw;
  r0.z = t5.Sample(s5_s, r3.xz).z;
  r1.w = r2.w * r0.y;
  r3.xy = cb0[5].xx * v5.xy;
  r3.z = t1.Sample(s1_s, r3.xy).w;
  r3.xyw = t0.Sample(s0_s, r3.xy).xyz;
  r0.y = r3.z * r0.y;
  r0.y = 0.000199999995 * r0.y;
  r1.w = r1.w * 1.99999995e-05 + -r0.y;
  r0.y = r2.w * r1.w + r0.y;
  r3.xyz = r0.yyy * float3(0.0500000007,0.0500000007,0.0500000007) + r3.xyw;
  r3.xyz = v6.xyz * r3.xyz;
  r2.xyz = min(r3.xyz, r2.xyz);
  r1.xyz = min(r2.xyz, r1.xyz);
  r0.y = r0.z + r0.x;
  r0.x = -r0.z * r0.x + r0.y;
  r2.xyz = cb0[9].xxx * cb0[8].xyz;
  r0.xyz = r2.xyz * r0.xxx;
  r0.xyz = r0.www * r0.xyz + r0.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.w = 1 + -v7.w;
  o0.xyz = r0.xyz * r0.www + v7.xyz;
  o0.a = saturate(o0.a);
  return;
}