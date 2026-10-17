// Matcap item shader (opaque): inventory items drawn after post-processing
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float3 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.z = r1.w * cb0[4].w + -0.5;
  r1.xyzw = cb0[4].xyzw * r1.xyzw;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  r2.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r2.x = r2.x * r2.w;
  r2.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r2.xy, r2.xy);
  r0.z = min(1, r0.z);
  r0.z = 1 + -r0.z;
  r2.z = sqrt(r0.z);
  r3.z = dot(v2.xyz, r2.xyz);
  r3.x = dot(v3.xyz, r2.xyz);
  r3.y = dot(v4.xyz, r2.xyz);
  r0.z = dot(r3.xyz, r3.xyz);
  r0.z = rsqrt(r0.z);
  r0.zw = r3.xy * r0.zz;
  r0.zw = r0.zw * float2(0.5,0.5) + float2(0.5,0.5);
  r2.xyzw = t4.Sample(s5_s, r0.zw).xyzw;
  r3.xyzw = t3.Sample(s4_s, r0.zw).xyzw;
  r2.xyz = -r3.xyz + r2.xyz;
  r4.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t5.Sample(s3_s, r0.xy).xyzw;
  r0.xyz = cb0[5].xyz * r0.xyz;
  r0.w = cb0[3].x * r4.x;
  r2.xyz = r0.www * r2.xyz + r3.xyz;
  r2.xyz = r2.xyz * r1.xyz;
  r0.xyz = r2.xyz * r4.yyy + r0.xyz;
  r0.xyz = r3.xyz * float3(0.0250000004,0.0250000004,0.0250000004) + r0.xyz;
  r0.w = 1 + v2.z;
  r0.w = 0.100000001 * r0.w;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  o0.w = r1.w;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r2.xyz = float3(1,1,1) + -cb0[6].xyz;
  r1.xyz = -r1.xyz * r2.xyz + float3(1,1,1);
  r2.xyz = r0.xyz + r0.xyz;
  r1.xyz = -r2.xyz * cb0[6].xyz + r1.xyz;
  r2.xyz = cb0[6].xyz * r2.xyz;
  r3.xyz = cmp(r0.xyz >= float3(0.5,0.5,0.5));
  r3.xyz = r3.xyz ? float3(1,1,1) : 0;
  r1.xyz = r3.xyz * r1.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[6].www * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.w = sqrt(r0.w);
  r1.x = 1 + cb0[7].y;
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.x = dot(r0.xyz, r0.xyz);
  r1.x = rsqrt(r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  // RenoDX: drawn after the tonemap; vanilla relied on the RGBA8 target to clamp this to SDR white.
  // The alpha-blended variant of this shader already saturates.
  o0.xyz = saturate(cb0[7].xxx * r0.xyz);
  return;
}