// ---- Created with 3Dmigoto v1.3.16 on Sat May 16 23:34:26 2026
Texture2D<float4> t13 : register(t13);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s5_s : register(s5);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

cbuffer cb0 : register(b0)
{
  float4 cb0[132];
}

#define cmp -

#ifndef MANUAL_SRGB_TEXTURE_DECODE
#define MANUAL_SRGB_TEXTURE_DECODE 0
#endif

#ifndef MANUAL_SRGB_RT_ENCODE
#define MANUAL_SRGB_RT_ENCODE 1
#endif

float3 SRGBToLinear(float3 c)
{
  float3 lo = c / 12.92;
  float3 hi = pow(max((c + 0.055) / 1.055, 0.0), 2.4);
  return lerp(lo, hi, step(0.04045, c));
}

float3 LinearToSRGB(float3 c)
{
  float3 lo = c * 12.92;
  float3 hi = 1.055 * pow(max(c, 0.0), 1.0 / 2.4) - 0.055;
  return lerp(lo, hi, step(0.0031308, c));
}

float4 DecodeSRGBColor(float4 c)
{
#if MANUAL_SRGB_TEXTURE_DECODE
  c.rgb = SRGBToLinear(saturate(c.rgb));
#endif
  return c;
}

float3 DecodeSRGBColor3(float3 c)
{
#if MANUAL_SRGB_TEXTURE_DECODE
  c = SRGBToLinear(saturate(c));
#endif
  return c;
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.xy = r0.xy * cb0[18].xy + cb0[18].zw;

  r0.z = t2.SampleLevel(s2_s, r0.xy, 0).x;
  r0.z = cb0[20].z + r0.z;
  r0.z = cb0[20].w / r0.z;

  r1.xyz = v2.xyz * r0.zzz + v3.xyz;
  r1.xyz = cb0[40].xyz + -r1.xyz;

  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);

  r2.xyz = r1.xyz * r0.zzz + cb0[130].xyz;
  r1.xyz = r1.xyz * r0.zzz;

  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;

  r3.xyzw = saturate(t1.Sample(s3_s, r0.xy).xyzw);
  r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);

  r0.z = r3.w + r3.w;
  r0.w = dot(r3.xyz, r3.xyz);
  r0.w = rsqrt(max(r0.w, 0.000001));

  r4.xyz = r3.xyz * r0.www;

  r0.w = dot(cb0[130].xyz, r3.xyz);

  r1.w = saturate(dot(r4.xyz, r2.xyz));
  r1.w = log2(max(r1.w, 0.000001));

  r2.xyzw = DecodeSRGBColor(t0.Sample(s3_s, r0.xy));
  r3.xyzw = DecodeSRGBColor(t3.Sample(s3_s, r0.xy));
  r5.xyzw = DecodeSRGBColor(t13.Sample(s13_s, r0.xy));

  r2.xyzw = saturate(r2.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  r5.xyzw = saturate(r5.xyzw);

  r0.x = 1 + -r3.w;
  r0.x = r2.w * r0.x;
  r0.y = r0.x * r3.w;
  r0.x = -r0.x * 0.5 + 1;

  r2.xyz = r2.xyz * r0.xxx;

  r0.x = saturate(r0.y * 1.5 + r3.w);

  r0.y = 8.47996902 * r0.x;
  r0.y = exp2(r0.y);

  r1.w = r0.y * r1.w;

  r0.y = r0.y * 0.25 + -0.25;
  r1.w = exp2(r1.w);

  r2.w = saturate(r0.w);

  r0.w = 0.300000012 + -r0.w;
  r0.z = r0.z * r0.w;
  r0.z = max(0, r0.z);
  r0.z = r2.w + r0.z;

  r0.w = r2.w * r1.w;
  r0.y = r0.w * r0.y;

  r6.xyz = cb0[131].xyz * r0.yyy;
  r6.xyz = r6.xyz * r5.www;

  r7.xyz = cb0[131].xyz * r2.xyz;

  r2.xyz = max(r5.xyz * r2.xyz, 0.0);
  r5.xyz = r7.xyz * r5.www;

  r0.yzw = r5.xyz * r0.zzz + r2.xyz;
  r0.yzw = r6.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r0.yzw;

  r1.w = dot(-r1.xyz, r4.xyz);
  r1.w = r1.w + r1.w;

  r1.xyz = r4.xzy * -r1.www + -r1.xzy;

  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(max(r1.w, 0.000001));

  r1.xyz = r1.xyz * r1.www;

  r1.w = 1 + -r0.x;

  o0.w = r0.x;

  r0.x = 6 * r1.w;

  r1.xyz = t5.SampleLevel(s5_s, r1.xyz, r0.x).xyz;
  r1.xyz = DecodeSRGBColor3(r1.xyz);
  r1.xyz = saturate(r1.xyz);

  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = abs(r1.xyz) * float3(0.25,0.25,0.25) + r3.xyz;

  o0.xyz = max(r1.xyz + r0.yzw, 0.0);
  o0.xyz = EncodeSRGBOutput(o0.xyz);

  return;
}