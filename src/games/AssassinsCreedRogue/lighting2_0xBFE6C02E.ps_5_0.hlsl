// ---- Created with 3Dmigoto v1.3.16 on Wed May 20 14:58:08 2026
Texture2D<float4> t13 : register(t13);

Texture2D<float4> t8 : register(t8);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s8_s : register(s8);

SamplerState s5_s : register(s5);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

cbuffer cb0 : register(b0)
{
  float4 cb0[162];
}

#define cmp -

#ifndef MANUAL_SRGB_RT_ENCODE
#define MANUAL_SRGB_RT_ENCODE 1
#endif

float3 LinearToSRGB(float3 c)
{
  float3 lo = c * 12.92;
  float3 hi = 1.055 * pow(max(c, 0.0), 1.0 / 2.4) - 0.055;
  return lerp(lo, hi, step(0.0031308, c));
}

float3 EncodeSRGBOutput(float3 c)
{
#if MANUAL_SRGB_RT_ENCODE
  c = LinearToSRGB(max(c, 0.0));
#endif
  return c;
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.xy = r0.xy * cb0[18].xy + cb0[18].zw;
  r1.xyzw = t1.Sample(s3_s, r0.xy).xyzw;
  r0.z = r1.w + r1.w;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.w = dot(cb0[130].xyz, r1.xyz);
  r1.w = 0.300000012 + -r0.w;
  r0.w = saturate(r0.w);
  r0.z = r1.w * r0.z;
  r0.z = max(0, r0.z);
  r0.z = r0.w + r0.z;
  r1.w = t2.SampleLevel(s2_s, r0.xy, 0).x;
  r1.w = cb0[20].z + r1.w;
  r1.w = cb0[20].w / r1.w;
  r2.xyz = v2.xyz * r1.www + v3.xyz;
  r3.xy = t8.Sample(s8_s, r2.xy).xy;
  r1.w = r3.y * 2 + -1;
  r4.xyzw = t0.Sample(s3_s, r0.xy).xyzw;
  r1.w = r4.w * r1.w;
  r3.yzw = r1.www * float3(0.5,0.5,0.5) + r4.xyz;
  r4.xyz = cb0[131].xyz * r3.yzw;
  r5.xyzw = t13.Sample(s13_s, r0.xy).xyzw;
  r6.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r4.xyz = r5.www * r4.xyz;
  r3.yzw = saturate(r5.xyz * r3.yzw);
  r0.xyz = r4.xyz * r0.zzz + r3.yzw;
  r3.yzw = cb0[40].xyz + -r2.xyz;
  r2.xy = -cb0[161].xy + r2.xy;
  r2.xy = float2(0.75,0.75) * r2.xy;
  r1.w = t8.Sample(s8_s, r2.xy).x;
  r1.w = r1.w * r3.x;
  r2.x = dot(r3.yzw, r3.yzw);
  r2.x = rsqrt(r2.x);
  r2.yzw = r3.yzw * r2.xxx + cb0[130].xyz;
  r3.xyz = r3.yzw * r2.xxx;
  r2.x = dot(r2.yzw, r2.yzw);
  r2.x = rsqrt(r2.x);
  r2.xyz = r2.yzw * r2.xxx;
  r2.w = dot(r1.xyz, r1.xyz);
  r2.w = rsqrt(r2.w);
  r1.xyz = r2.www * r1.xyz;
  r2.x = saturate(dot(r1.xyz, r2.xyz));
  r2.x = log2(max(r2.x, 0.000001));
  r2.y = cb0[160].w + -r6.w;
  r2.y = r4.w * r2.y + r6.w;
  r2.z = 8.47996902 * r2.y;
  r2.z = exp2(r2.z);
  r2.x = r2.z * r2.x;
  r2.z = r2.z * 0.25 + -0.25;
  r2.x = exp2(r2.x);
  r0.w = r2.x * r0.w;
  r0.w = r0.w * r2.z;
  r2.xzw = cb0[131].xyz * r0.www;
  r2.xzw = r2.xzw * r5.www;
  r0.xyz = r2.xzw * float3(0.0199999996,0.0199999996,0.0199999996) + r0.xyz;
  r0.w = saturate(r1.z * 10 + -9);
  r0.w = r1.w * r0.w;
  r0.w = cb0[161].z * r0.w;
  r0.w = r0.w * r4.w;
  r1.w = dot(-r3.xyz, r1.xyz);
  r1.w = r1.w + r1.w;
  r1.xyz = r1.xzy * -r1.www + -r3.xzy;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r1.w = 1 + -r2.y;
  o0.w = r2.y;
  r1.w = 6 * r1.w;
  r1.xyz = t5.SampleLevel(s5_s, r1.xyz, r1.w).xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = float3(0.25,0.25,0.25) * abs(r1.xyz);
  r1.xyz = r0.www * float3(0.25,0.25,0.25) + r1.xyz;
  r1.xyz = r6.xyz + r1.xyz;
  o0.xyz = r1.xyz + r0.xyz;

  o0.xyz = EncodeSRGBOutput(o0.xyz);

  return;
}