
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[27];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float v6 : TEXCOORD6,
  float4 v7 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy / v0.zz;
  r0.z = t0.Sample(s0_s, r0.xy).x;
  r1.xyz = t1.Sample(s1_s, r0.xy).xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.w = 1;
  r0.x = dot(r0.zw, cb0[14].zw);
  r0.y = dot(r0.zw, cb0[15].zw);
  r0.x = -r0.x / r0.y;
  r0.yzw = v5.xyz / v5.zzz;
  r2.x = v1.w;
  r2.y = v2.w;
  r2.z = v3.w;
  r0.xyz = r0.yzw * -r0.xxx + -r2.xyz;
  r2.z = dot(r0.xyz, v3.xyz);
  r2.z = abs(r2.z);
  r3.x = dot(r0.xyz, v1.xyz);
  r3.y = dot(r0.xyz, v2.xyz);
  r3.zw = abs(r3.xy) * abs(r3.xy);
  r4.xy = r3.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r2.xy = r3.zw * r3.zw;
  r2.xyz = min(float3(1,1,1), r2.xyz);
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r0.w = r2.x * r2.y;
  r0.w = r0.w * r2.z;
  r4.z = 1 + -r4.y;
  r2.xyzw = t2.Sample(s2_s, r4.xz).xyzw;
  r1.w = dot(r2.xyzw, v4.xyzw);
  r0.w = r1.w * r0.w;
  r2.x = dot(r1.xyz, cb0[24].xyz);
  r2.y = dot(r1.xyz, cb0[25].xyz);
  r2.z = dot(r1.xyz, cb0[26].xyz);
  r1.x = dot(r2.xyz, r2.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = r2.xyz * r1.xxx;
  r1.w = dot(r0.xyz, r0.xyz);
  r1.w = rsqrt(r1.w);
  r0.xyz = r1.www * r0.xyz;
  r0.x = dot(r1.xyz, r0.xyz);
  r0.x = saturate(0.5 + r0.x);
  r0.x = -r0.x * v6.x + 1;
  r0.x = r0.w * r0.x;
  r0.x = v5.w * r0.x;
  r0.x = saturate(min(v4.w, r0.x));
  r0.x = v0.w + -r0.x;
  o0.xyzw = float4(1,1,1,1) + r0.xxxx;
  o0.w = saturate(o0.w);
  return;
}