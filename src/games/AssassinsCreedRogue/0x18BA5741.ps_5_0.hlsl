// ---- Created with 3Dmigoto v1.3.16 on Wed May 20 15:03:20 2026
Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s12_s : register(s12);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
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
  r0.z = r3.z * cb0[155].x + cb0[155].y;
  r4.z = -r2.z;
  r0.xyz = r4.xyz + r0.xyz;
  r0.w = cb0[155].z * abs(r0.z);
  r0.w = -r0.w * r0.w + 1;
  r0.w = saturate(r3.w * r0.w);
  r3.xyz = cb0[157].xyz * r0.www;
  r5.xyzw = t1.Sample(s3_s, r1.xy).xyzw;
  r4.xyw = r5.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.w = r5.w + r5.w;
  r1.z = dot(r4.xyw, r4.xyw);
  r1.z = rsqrt(r1.z);
  r5.xyz = r4.xyw * r1.zzz;
  r1.z = dot(cb0[130].xyz, r4.xyw);
  r4.xy = r5.xy * cb0[156].xx + r2.xy;
  r4.xy = r4.xy * cb0[158].zw + cb0[158].xy;
  r6.xyzw = t7.SampleLevel(s7_s, r4.xy, 0).xyzw;
  r1.w = r6.w * cb0[155].x + cb0[155].y;
  r4.xyw = r6.xyz * r6.xyz;
  r1.w = r1.w + r4.z;
  r1.w = r5.z * cb0[156].y + r1.w;
  r1.w = cb0[155].z * abs(r1.w);
  r1.w = -r1.w * r1.w + 1;
  r1.w = max(0, r1.w);
  r1.w = cb0[157].w * r1.w;
  r4.xyz = r4.xyw * r1.www;
  r1.w = dot(r0.xyz, r0.xyz);
  r1.w = rsqrt(r1.w);
  r0.xyz = r1.www * r0.xyz;
  r1.w = saturate(dot(r5.xyz, r0.xyz));
  r4.xyz = r1.www * r3.xyz + r4.xyz;
  r6.xyz = cb0[40].xyz + -r2.xyz;
  r2.z = dot(r6.xyz, r6.xyz);
  r2.z = rsqrt(r2.z);
  r0.xyz = r6.xyz * r2.zzz + r0.xyz;
  r2.w = dot(r0.xyz, r0.xyz);
  r2.w = rsqrt(r2.w);
  r0.xyz = r2.www * r0.xyz;
  r0.x = saturate(dot(r5.xyz, r0.xyz));
  r0.x = log2(max(r0.x, 0.000001));
  r7.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r0.y = cb0[160].w + -r7.w;
  r8.xyzw = t0.Sample(s3_s, r1.xy).xyzw;
  r9.xyzw = t13.Sample(s13_s, r1.xy).xyzw;
  r0.y = r8.w * r0.y + r7.w;
  r0.z = 8.47996902 * r0.y;
  r0.z = exp2(r0.z);
  r0.x = r0.z * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r1.w * r0.x;
  r1.x = r0.z * 0.25 + -0.25;
  r0.x = r1.x * r0.x;
  r3.xyz = r0.xxx * r3.xyz;
  r3.xyz = float3(0.0199999996,0.0199999996,0.0199999996) * r3.xyz;
  r1.yw = t8.Sample(s8_s, r2.xy).xy;
  r2.xy = -cb0[161].xy + r2.xy;
  r2.xy = float2(0.75,0.75) * r2.xy;
  r0.x = t8.Sample(s8_s, r2.xy).x;
  r0.x = r0.x * r1.y;
  r1.y = r1.w * 2 + -1;
  r1.y = r8.w * r1.y;
  r2.xyw = r1.yyy * float3(0.5,0.5,0.5) + r8.xyz;
  r3.xyz = r4.xyz * r2.xyw + r3.xyz;
  r3.xyz = r7.xyz + r3.xyz;
  r1.y = saturate(r5.z * 10 + -9);
  r0.x = r1.y * r0.x;
  r0.x = cb0[161].z * r0.x;
  r0.x = r0.x * r8.w;
  r4.xyz = r6.xyz * r2.zzz;
  r6.xyz = r6.xyz * r2.zzz + cb0[130].xyz;
  r1.y = dot(-r4.xyz, r5.xyz);
  r1.y = r1.y + r1.y;
  r4.xyz = r5.xzy * -r1.yyy + -r4.xzy;
  r1.y = dot(r4.xyz, r4.xyz);
  r1.y = rsqrt(r1.y);
  r4.xyz = r4.xyz * r1.yyy;
  r1.y = 1 + -r0.y;
  o0.w = r0.y;
  r0.y = 6 * r1.y;
  r4.xyz = t5.SampleLevel(s5_s, r4.xyz, r0.y).xyz;
  r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r4.xyz = float3(0.25,0.25,0.25) * abs(r4.xyz);
  r4.xyz = r0.xxx * float3(0.25,0.25,0.25) + r4.xyz;
  r3.xyz = r4.xyz + r3.xyz;
  r0.x = 0.300000012 + -r1.z;
  r1.z = saturate(r1.z);
  r0.x = r0.w * r0.x;
  r0.x = max(0, r0.x);
  r0.x = r1.z + r0.x;
  r4.xyz = cb0[131].xyz * r2.xyw;
  r2.xyz = saturate(r9.xyz * r2.xyw);
  r4.xyz = r4.xyz * r9.www;
  r0.xyw = r4.xyz * r0.xxx + r2.xyz;
  r1.y = dot(r6.xyz, r6.xyz);
  r1.y = rsqrt(r1.y);
  r2.xyz = r6.xyz * r1.yyy;
  r1.y = saturate(dot(r5.xyz, r2.xyz));
  r1.y = log2(max(r1.y, 0.000001));
  r0.z = r1.y * r0.z;
  r0.z = exp2(r0.z);
  r0.z = r1.z * r0.z;
  r0.z = r0.z * r1.x;
  r1.xyz = cb0[131].xyz * r0.zzz;
  r1.xyz = r1.xyz * r9.www;
  r0.xyz = r1.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r0.xyw;
  o0.xyz = r0.xyz + r3.xyz;

  o0.xyz = EncodeSRGBOutput(o0.xyz);

  return;
}