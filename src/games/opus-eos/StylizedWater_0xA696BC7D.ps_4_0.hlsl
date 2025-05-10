// ---- Created with 3Dmigoto v1.4.1 on Fri Apr 18 23:06:45 2025
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

cbuffer cb4 : register(b4) {
  float4 cb4[13];
}

cbuffer cb3 : register(b3) {
  float4 cb3[2];
}

cbuffer cb2 : register(b2) {
  float4 cb2[1];
}

cbuffer cb1 : register(b1) {
  float4 cb1[8];
}

cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float w1: TEXCOORD4,
    float w2: TEXCOORD5,
    float4 v2: TEXCOORD1,
    float3 v3: TEXCOORD2,
    float w3: TEXCOORD6,
    float4 v4: TEXCOORD3,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb4[8].y + cb4[8].z;
  r0.yz = v4.xy / v4.ww;
  r1.xyzw = t4.Sample(s1_s, r0.yz).xyzw;
  r0.w = cb1[7].z * r1.x + cb1[7].w;
  r0.w = 1 / r0.w;
  r0.w = -cb1[5].y + r0.w;
  r0.w = max(0, r0.w);
  r1.x = -cb1[5].y + v4.z;
  r1.x = max(0, r1.x);
  r0.w = -r1.x + r0.w;
  r0.x = saturate(r0.w / r0.x);
  r1.x = r0.x * r0.x;
  r0.x = r1.x * r0.x;
  r1.xyz = cb4[9].xyz + -cb4[0].xyz;
  r1.xyz = r0.xxx * r1.xyz + cb4[0].xyz;
  r1.xyz = -cb4[7].xyz + r1.xyz;
  r0.x = saturate(r0.w / cb4[8].y);
  r1.xyz = r0.xxx * r1.xyz + cb4[7].xyz;
  r2.xyz = cb4[2].xyz + -r1.xyz;
  r3.xyz = cb1[4].xyz + -v2.xyz;
  r0.x = dot(r3.xyz, r3.xyz);
  r0.x = rsqrt(r0.x);
  r3.xyz = r3.xyz * r0.xxx;
  r0.x = dot(v3.xyz, v3.xyz);
  r0.x = rsqrt(r0.x);
  r4.xyz = v3.xyz * r0.xxx;
  r0.x = dot(r4.xyz, r3.xyz);
  r0.x = max(0, r0.x);
  r0.x = 1 + -r0.x;
  r0.x = log2(r0.x);
  r0.x = cb4[3].y * r0.x;
  r0.x = exp2(r0.x);
  r0.x = min(1, r0.x);
  r1.xyz = r0.xxx * r2.xyz + r1.xyz;
  r0.x = 0.00999999978 * cb1[0].y;
  r2.xy = v1.xy * cb4[10].yy + r0.xx;
  r2.zw = v1.xy * cb4[3].ww + r0.xx;
  r2.zw = r2.zw * cb0[5].xy + cb0[5].zw;
  r5.xyzw = t3.Sample(s4_s, r2.zw).xyzw;
  r0.x = saturate(r5.x * 4 + -1);
  r0.x = rsqrt(r0.x);
  r0.x = 1 / r0.x;
  r2.xy = r2.xy * cb0[4].xy + cb0[4].zw;
  r2.xyzw = t0.Sample(s3_s, r2.xy).xyzw;
  r1.w = r2.y * cb4[10].x * 5;

  // r2.x = cb4[6].z * w3;
  float time = cb1[0].y;
  float frequency = 0.5f;
  float amplitude = 100.0f;
  float smooth_time_value = sin(time * frequency) * amplitude;
  r2.x = cb4[6].z * smooth_time_value;

  r1.w = r2.x * 0.0500000007 + r1.w;
  r2.xy = v1.xy * r1.ww;
  r2.z = 0.00999999978 * cb4[12].x;
  r2.xy = r2.xy * r2.zz;
  r0.yz = r2.xy * float2(2, 2) + r0.yz;
  r2.xy = r1.ww * float2(0.00999999978, 0.00999999978) + r0.yz;
  r5.xyzw = t1.Sample(s0_s, r0.yz).xyzw;
  r0.y = r1.w / cb4[11].x;
  r0.y = r0.y * 0.800000012 + 0.200000003;
  r2.xy = r2.xy * cb0[3].xy + cb0[3].zw;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyz = cb4[10].zzz * r2.xyz;
  r2.xyz = float3(0.300000012, 0.300000012, 0.300000012) * r2.xyz;
  r1.xyz = saturate(cb4[6].yyy * r2.xyz + r1.xyz);
  r0.z = cb4[8].x * cb1[0].y;
  r2.xy = cb4[3].zz * v1.xy;
  r2.xy = r0.zz * float2(0.150000006, 0.150000006) + r2.xy;
  r2.xy = r2.xy * cb0[5].xy + cb0[5].zw;
  r2.xyzw = t3.Sample(s4_s, r2.xy).xyzw;
  r0.z = cb4[3].x * r2.x;
  r1.w = w1 * 0.100000001 + 0.200000003;
  r0.z = r1.w * r0.z;
  r0.z = saturate(r0.w / r0.z);
  r0.z = log2(r0.z);
  r0.z = 15 * r0.z;
  r0.z = exp2(r0.z);
  r0.z = 10 * r0.z;
  r0.z = min(1, r0.z);
  r0.z = 1 + -r0.z;
  r1.w = cb4[4].w * r0.z;
  r1.xyz = cb4[1].xyz * r1.www + r1.xyz;
  r1.w = saturate(r0.w / cb4[4].x);
  r0.w = saturate(r0.w / cb4[11].z);
  r1.w = 1.25 * r1.w;
  r1.w = min(1, r1.w);
  r1.w = 1 + -r1.w;
  r2.x = 1 + -r1.w;
  r1.w = cb4[4].y * r2.x + r1.w;
  r0.x = r1.w * r0.x;
  r0.x = cb4[4].z * r0.x;
  r2.xy = float2(0.300000012, 0.0600000024) * r0.xx;
  r1.xyz = cb4[1].xyz * r2.xxx + r1.xyz;
  r0.x = r0.z * cb4[4].w + r2.y;
  r0.x = cb4[11].w + r0.x;
  r0.x = r0.x + r0.w;
  r2.xyz = max(float3(0.300000012, 0.300000012, 0.300000012), cb0[2].xyz);
  r2.xyz = min(float3(1, 1, 1), r2.xyz);
  r2.xyz = float3(-1, -1, -1) + r2.xyz;
  r2.xyz = cb4[10].www * r2.xyz + float3(1, 1, 1);
  r0.z = dot(-r3.xyz, r4.xyz);
  r0.z = r0.z + r0.z;
  r3.xyz = r4.xyz * -r0.zzz + -r3.xyz;
  r0.z = dot(cb2[0].xyz, cb2[0].xyz);
  r0.z = rsqrt(r0.z);
  r4.xyz = cb2[0].xyz * r0.zzz;
  r0.z = dot(r4.xyz, r3.xyz);
  r0.z = log2(r0.z);
  r0.w = 1 + -cb4[11].x;
  r0.w = r0.w * 5 + 5;
  r0.w = exp2(r0.w);
  r0.z = r0.w * r0.z;
  r0.z = exp2(r0.z);
  r0.z = r0.z + r0.z;
  r3.xyz = cb0[2].xyz * r0.zzz;
  r0.yzw = saturate(r3.xyz * r0.yyy);
  r3.xyz = cb4[11].yyy * r0.yzw;
  r0.xyz = saturate(r0.yzw * cb4[11].yyy + r0.xxx);
  r1.xyz = r1.xyz * r2.xyz + r3.xyz;
  r1.xyz = r1.xyz + -r5.xyz;
  r0.xyz = r0.xyz * r1.xyz + r5.xyz;
  r0.xyz = -cb3[0].xyz + r0.xyz;
  r0.w = w1 / cb1[5].y;
  r0.w = 1 + -r0.w;
  r0.w = cb1[5].z * r0.w;
  r0.w = max(0, r0.w);
  r0.w = saturate(r0.w * cb3[1].z + cb3[1].w);
  o0.xyz = r0.www * r0.xyz + cb3[0].xyz;
  o0.w = 1;

  return;
}
