// ---- Created with 3Dmigoto v1.3.16 on Wed May 20 15:00:58 2026
Texture2D<float4> t13 : register(t13);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s8_s : register(s8);

SamplerState s7_s : register(s7);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.xy = r0.xy * cb0[18].xy + cb0[18].zw;
  r0.z = t2.SampleLevel(s2_s, r0.xy, 0).x;
  r0.z = cb0[20].z + r0.z;
  r0.z = cb0[20].w / r0.z;
  r1.xyz = v2.xyz * r0.zzz + v3.xyz;
  r2.xyz = cb0[40].xyz + -r1.xyz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r3.xyz = r2.xyz * r0.zzz;
  r2.xyz = r2.xyz * r0.zzz + cb0[130].xyz;
  r4.xyzw = t1.Sample(s3_s, r0.xy).xyzw;
  r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.z = r4.w + r4.w;
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = rsqrt(r0.w);
  r5.xyz = r4.xyz * r0.www;
  r0.w = dot(cb0[130].xyz, r4.xyz);
  r1.w = dot(-r3.xyz, r5.xyz);
  r1.w = r1.w + r1.w;
  r3.xyz = r5.xzy * -r1.www + -r3.xzy;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = r3.xyz * r1.www;
  r4.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r1.w = cb0[160].w + -r4.w;
  r6.xyzw = t0.Sample(s3_s, r0.xy).xyzw;
  r7.xyzw = t13.Sample(s13_s, r0.xy).xyzw;
  r0.x = r6.w * r1.w + r4.w;
  r0.y = 1 + -r0.x;
  r0.y = 6 * r0.y;
  r3.xyz = t5.SampleLevel(s5_s, r3.xyz, r0.y).xyz;
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r3.xyz = float3(0.25,0.25,0.25) * abs(r3.xyz);
  r8.xy = -cb0[161].xy + r1.xy;
  r8.xy = float2(0.75,0.75) * r8.xy;
  r0.y = t8.Sample(s8_s, r8.xy).x;
  r8.xy = t8.Sample(s8_s, r1.xy).xy;
  r0.y = r8.x * r0.y;
  r1.w = r8.y * 2 + -1;
  r1.w = r6.w * r1.w;
  r6.xyz = r1.www * float3(0.5,0.5,0.5) + r6.xyz;
  r1.w = saturate(r5.z * 10 + -9);
  r0.y = r1.w * r0.y;
  r0.y = cb0[161].z * r0.y;
  r0.y = r0.y * r6.w;
  r3.xyz = r0.yyy * float3(0.25,0.25,0.25) + r3.xyz;
  r1.xy = r5.xy * cb0[156].xx + r1.xy;
  r1.xy = r1.xy * cb0[158].zw + cb0[158].xy;
  r8.xyzw = t7.SampleLevel(s7_s, r1.xy, 0).xyzw;
  r0.y = r8.w * cb0[155].x + cb0[155].y;
  r1.xyw = r8.xyz * r8.xyz;
  r0.y = r0.y + -r1.z;
  r0.y = r5.z * cb0[156].y + r0.y;
  r0.y = cb0[155].z * abs(r0.y);
  r0.y = -r0.y * r0.y + 1;
  r0.y = max(0, r0.y);
  r0.y = cb0[157].w * r0.y;
  r1.xyz = r1.xyw * r0.yyy;
  r1.xyz = r1.xyz * r6.xyz + r4.xyz;
  r1.xyz = r1.xyz + r3.xyz;
  r0.y = 0.300000012 + -r0.w;
  r0.w = saturate(r0.w);
  r0.y = r0.z * r0.y;
  r0.y = max(0, r0.y);
  r0.y = r0.w + r0.y;
  r3.xyz = cb0[131].xyz * r6.xyz;
  r4.xyz = saturate(r7.xyz * r6.xyz);
  r3.xyz = r3.xyz * r7.www;
  r3.xyz = r3.xyz * r0.yyy + r4.xyz;
  r0.y = dot(r2.xyz, r2.xyz);
  r0.y = rsqrt(r0.y);
  r2.xyz = r2.xyz * r0.yyy;
  r0.y = saturate(dot(r5.xyz, r2.xyz));
  r0.y = log2(max(r0.y, 0.000001));
  r0.z = 8.47996902 * r0.x;
  o0.w = r0.x;
  r0.x = exp2(r0.z);
  r0.y = r0.x * r0.y;
  r0.x = r0.x * 0.25 + -0.25;
  r0.y = exp2(r0.y);
  r0.y = r0.w * r0.y;
  r0.x = r0.y * r0.x;
  r0.xyz = cb0[131].xyz * r0.xxx;
  r0.xyz = r0.xyz * r7.www;
  r0.xyz = r0.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r3.xyz;
  o0.xyz = r0.xyz + r1.xyz;

  o0.xyz = EncodeSRGBOutput(o0.xyz);

  return;
}