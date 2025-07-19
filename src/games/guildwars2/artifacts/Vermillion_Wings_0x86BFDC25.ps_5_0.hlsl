Texture2D<float4> t14 : register(t14);
TextureCube<float4> t13 : register(t13);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s14_s : register(s14);
SamplerState s13_s : register(s13);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[26];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD6,
  float4 v7 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t3.Sample(s3_s, v0.zw).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.zw = cb0[22].xx * r0.xy + v0.xy;
  r0.z = t0.Sample(s0_s, r0.zw).w;
  r0.z = saturate(r0.z + r0.z);
  r0.z = -0.5 + r0.z;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  r0.zw = t1.Sample(s1_s, v0.xy).xy;
  r1.xy = r0.zw * float2(2,2) + float2(-1,-1);
  r0.z = dot(r1.xy, r1.xy);
  r0.z = 1 + -r0.z;
  r0.z = max(0, r0.z);
  r1.z = sqrt(r0.z);
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r2.xyz = v2.xyz * r1.yyy;
  r1.xyw = r1.xxx * v3.xyz + r2.xyz;
  r1.xyz = r1.zzz * v4.xyz + r1.xyw;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = sqrt(r0.z);
  r2.xy = cmp(float2(9.99999991e-38,0) < r0.zz);
  r0.w = (int)-r2.y;
  r1.w = cmp(r0.w != 0.000000);
  r0.w = 9.99999991e-38 * r0.w;
  r0.w = r1.w ? r0.w : 9.99999991e-38;
  r0.z = r2.x ? r0.z : r0.w;
  r1.xyz = r1.xyz / r0.zzz;
  r2.x = v3.w;
  r2.y = v2.w;
  r2.z = v4.w;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;
  r0.z = dot(-r2.xyz, r1.xyz);
  r0.z = r0.z + r0.z;
  r1.xyz = r1.xyz * -r0.zzz + -r2.xyz;
  r0.z = -2000 + v5.x;
  r0.z = saturate(-0.000500000024 * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.w = t0.Sample(s0_s, v0.xy).w;
  r0.w = -0.5 + r0.w;
  r0.w = saturate(r0.w + r0.w);
  r0.z = -r0.z * r0.w + 1;
  r0.z = max(0, r0.z);
  r0.z = 4 * r0.z;
  r1.xyzw = t13.SampleLevel(s13_s, r1.xyz, r0.z).xyzw;
  r1.xyz = r1.xyz / r1.www;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = cb0[25].xyz * r1.xyz;
  r2.xy = cb0[8].xx * r0.xy + v0.xy;
  r0.xy = cb0[20].xx * r0.xy + v0.xy;
  r3.xyz = t2.Sample(s2_s, r0.xy).xyz;
  r2.xyz = t0.Sample(s0_s, r2.xy).xyz;
  r4.xyzw = t4.Sample(s4_s, v0.xy).xyzw;
  r0.x = dot(r4.xyzw, float4(1,1,1,1));
  r0.y = cmp(0 < r0.x);
  r0.z = cmp(r0.x < 0);
  r0.y = (int)-r0.y + (int)r0.z;
  r0.y = (int)r0.y;
  r0.z = cmp(r0.y != 0.000000);
  r0.y = 9.99999991e-38 * r0.y;
  r0.y = r0.z ? r0.y : 9.99999991e-38;
  r0.z = cmp(9.99999991e-38 < abs(r0.x));
  r0.y = r0.z ? r0.x : r0.y;
  r0.x = min(1, r0.x);
  r0.x = 1 + -r0.x;
  r4.xyzw = r4.xyzw / r0.yyyy;
  r2.w = 1;
  r5.x = dot(cb0[7].xyzw, r2.xyzw);
  r5.y = dot(cb0[9].xyzw, r2.xyzw);
  r5.z = dot(cb0[10].xyzw, r2.xyzw);
  r5.w = dot(cb0[11].xyzw, r2.xyzw);
  r5.x = dot(r5.xyzw, r4.xyzw);
  r6.x = dot(cb0[12].xyzw, r2.xyzw);
  r6.y = dot(cb0[13].xyzw, r2.xyzw);
  r6.z = dot(cb0[14].xyzw, r2.xyzw);
  r6.w = dot(cb0[15].xyzw, r2.xyzw);
  r5.y = dot(r6.xyzw, r4.xyzw);
  r6.x = dot(cb0[16].xyzw, r2.xyzw);
  r6.y = dot(cb0[17].xyzw, r2.xyzw);
  r6.z = dot(cb0[18].xyzw, r2.xyzw);
  r6.w = dot(cb0[19].xyzw, r2.xyzw);
  r5.z = dot(r6.xyzw, r4.xyzw);
  r2.xyz = -r5.xyz + r2.xyz;
  r0.xyz = r0.xxx * r2.xyz + r5.xyz;
  r2.xyz = r0.xyz * float3(0.6,0.6,0.6) + float3(-0.3,-0.3,-0.3);
  r2.xyz = cb0[23].xxx * r2.xyz + float3(0.5,0.5,0.5);
  r1.xyz = r2.xyz * r1.xyz;
  r4.xy = cb0[4].xx + v7.xy;
  r4.xy = cb0[2].xy * r4.xy;
  r4.xyzw = t14.Sample(s14_s, r4.xy).xyzw;
  r4.xyzw = cb0[0].yyyy * r4.xyzw;
  r0.xyz = r4.xyz * r0.xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + -r0.xyz;
  r1.w = cb0[25].w * r0.w;
  r4.xyz = cb0[24].xyz * r0.www;
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r2.xyz = cb0[3].xyz * r2.xyz;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r0.xyz = r2.xyz * r4.www + r0.xyz;
  r1.xyzw = t5.Sample(s5_s, v0.xy).xyzw;
  r0.w = dot(r1.xyzw, float4(1,1,1,1));
  r2.x = cmp(0 < r0.w);
  r2.y = cmp(r0.w < 0);
  r2.x = (int)-r2.x + (int)r2.y;
  r2.x = (int)r2.x;
  r2.y = cmp(r2.x != 0.000000);
  r2.x = 9.99999991e-38 * r2.x;
  r2.x = r2.y ? r2.x : 9.99999991e-38;
  r2.y = cmp(9.99999991e-38 < abs(r0.w));
  r2.x = r2.y ? r0.w : r2.x;
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r1.xyzw = r1.xyzw / r2.xxxx;
  r3.w = 1;
  r2.x = dot(cb0[7].xyzw, r3.xyzw);
  r2.y = dot(cb0[9].xyzw, r3.xyzw);
  r2.z = dot(cb0[10].xyzw, r3.xyzw);
  r2.w = dot(cb0[11].xyzw, r3.xyzw);
  r2.x = dot(r2.xyzw, r1.xyzw);
  r4.x = dot(cb0[12].xyzw, r3.xyzw);
  r4.y = dot(cb0[13].xyzw, r3.xyzw);
  r4.z = dot(cb0[14].xyzw, r3.xyzw);
  r4.w = dot(cb0[15].xyzw, r3.xyzw);
  r2.y = dot(r4.xyzw, r1.xyzw);
  r4.x = dot(cb0[16].xyzw, r3.xyzw);
  r4.y = dot(cb0[17].xyzw, r3.xyzw);
  r4.z = dot(cb0[18].xyzw, r3.xyzw);
  r4.w = dot(cb0[19].xyzw, r3.xyzw);
  r2.z = dot(r4.xyzw, r1.xyzw);
  r1.xyz = r3.xyz + -r2.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = cb0[21].xxx * r1.xyz;
  r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r0.w = 1 + -v6.w;
  o0.xyz = r0.xyz * r0.www + v6.xyz;
  o0.w = cb0[1].x;
  o0 = max(0.f, o0);
  return;
}