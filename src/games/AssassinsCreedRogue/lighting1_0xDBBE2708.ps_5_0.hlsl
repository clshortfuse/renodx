// ---- Created with 3Dmigoto v1.3.16 on Wed May 20 14:39:17 2026
Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s12_s : register(s12);

SamplerState s5_s : register(s5);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

cbuffer cb0 : register(b0)
{
  float4 cb0[159];
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

  r0.xy = float2(0,0);
  r1.xy = v1.xy / v1.ww;
  r1.xy = r1.xy * cb0[18].xy + cb0[18].zw;
  r0.w = t2.SampleLevel(s2_s, r1.xy, 0).x;
  r0.w = cb0[20].z + r0.w;
  r0.w = cb0[20].w / r0.w;
  r2.xyz = v2.xyz * r0.www + v3.xyz;
  r1.zw = r2.xy * cb0[158].zw + cb0[158].xy;
  r3.xyzw = t12.SampleLevel(s12_s, r1.zw, 0).xyzw;
  r1.zw = r3.xy * float2(2,2) + float2(-1,-1);
  r4.xy = cb0[155].ww * r1.zw;
  r4.z = -r2.z;
  r2.xyz = cb0[40].xyz + -r2.xyz;
  r0.z = r3.z * cb0[155].x + cb0[155].y;
  r0.xyz = r4.xyz + r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyw = r0.xyz * r0.www;
  r0.z = cb0[155].z * abs(r0.z);
  r0.z = -r0.z * r0.z + 1;
  r0.z = saturate(r3.w * r0.z);
  r3.xyz = cb0[157].xyz * r0.zzz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r4.xyz = r2.xyz * r0.zzz + r0.xyw;
  r1.z = dot(r4.xyz, r4.xyz);
  r1.z = rsqrt(r1.z);
  r4.xyz = r4.xyz * r1.zzz;
  r5.xyzw = t1.Sample(s3_s, r1.xy).xyzw;
  r5.xyz = r5.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.z = r5.w + r5.w;
  r1.w = dot(r5.xyz, r5.xyz);
  r1.w = rsqrt(r1.w);
  r6.xyz = r5.xyz * r1.www;
  r1.w = dot(cb0[130].xyz, r5.xyz);
  r2.w = saturate(dot(r6.xyz, r4.xyz));
  r2.w = log2(max(r2.w, 0.000001));
  r4.xyzw = t0.Sample(s3_s, r1.xy).xyzw;
  r5.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r7.xyzw = t13.Sample(s13_s, r1.xy).xyzw;
  r1.x = 1 + -r5.w;
  r1.x = r4.w * r1.x;
  r1.y = r1.x * r5.w;
  r1.x = -r1.x * 0.5 + 1;
  r4.xyz = r4.xyz * r1.xxx;
  r1.x = saturate(r1.y * 1.5 + r5.w);
  r1.y = 8.47996902 * r1.x;
  r1.y = exp2(r1.y);
  r2.w = r1.y * r2.w;
  r2.w = exp2(r2.w);
  r0.x = saturate(dot(r6.xyz, r0.xyw));
  r0.y = r0.x * r2.w;
  r8.xyz = r0.xxx * r3.xyz;
  r0.x = r1.y * 0.25 + -0.25;
  r0.y = r0.y * r0.x;
  r3.xyz = r0.yyy * r3.xyz;
  r3.xyz = float3(0.0199999996,0.0199999996,0.0199999996) * r3.xyz;
  r3.xyz = r8.xyz * r4.xyz + r3.xyz;
  r3.xyz = r5.xyz + r3.xyz;
  r5.xyz = r2.xyz * r0.zzz;
  r0.yzw = r2.xyz * r0.zzz + cb0[130].xyz;
  r2.x = dot(-r5.xyz, r6.xyz);
  r2.x = r2.x + r2.x;
  r2.xyz = r6.xzy * -r2.xxx + -r5.xzy;
  r2.w = dot(r2.xyz, r2.xyz);
  r2.w = rsqrt(r2.w);
  r2.xyz = r2.xyz * r2.www;
  r2.w = 1 + -r1.x;
  o0.w = r1.x;
  r1.x = 6 * r2.w;
  r2.xyz = t5.SampleLevel(s5_s, r2.xyz, r1.x).xyz;
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyz = abs(r2.xyz) * float3(0.25,0.25,0.25) + r3.xyz;
  r1.x = 0.300000012 + -r1.w;
  r1.w = saturate(r1.w);
  r1.x = r1.z * r1.x;
  r1.x = max(0, r1.x);
  r1.x = r1.w + r1.x;
  r3.xyz = cb0[131].xyz * r4.xyz;
  r4.xyz = saturate(r7.xyz * r4.xyz);
  r3.xyz = r3.xyz * r7.www;
  r3.xyz = r3.xyz * r1.xxx + r4.xyz;
  r1.x = dot(r0.yzw, r0.yzw);
  r1.x = rsqrt(r1.x);
  r0.yzw = r1.xxx * r0.yzw;
  r0.y = saturate(dot(r6.xyz, r0.yzw));
  r0.y = log2(max(r0.y, 0.000001));
  r0.y = r1.y * r0.y;
  r0.y = exp2(r0.y);
  r0.y = r1.w * r0.y;
  r0.x = r0.y * r0.x;
  r0.xyz = cb0[131].xyz * r0.xxx;
  r0.xyz = r0.xyz * r7.www;
  r0.xyz = r0.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r3.xyz;
  o0.xyz = r0.xyz + r2.xyz;

  o0.xyz = EncodeSRGBOutput(o0.xyz);

  return;
}