// ---- Created with 3Dmigoto v1.3.16 on Wed May 20 14:44:08 2026
Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t7 : register(t7);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s12_s : register(s12);

SamplerState s7_s : register(s7);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.zw = cb0[21].xy + r0.xy;
  r0.xy = r0.xy * cb0[18].xy + cb0[18].zw;
  r0.zw = cb0[20].xy * r0.zw;
  r1.x = t2.SampleLevel(s2_s, r0.xy, 0).x;
  r1.x = cb0[20].z + r1.x;
  r1.z = cb0[20].w / r1.x;
  r1.xy = r1.zz * r0.zw;
  r1.w = 1;
  r2.x = dot(r1.xyzw, cb0[22].xyzw);
  r2.y = dot(r1.xyzw, cb0[23].xyzw);
  r2.z = dot(r1.xyzw, cb0[24].xyzw);
  r1.xyz = t1.Sample(s3_s, r0.xy).xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r0.zw = r1.xy * cb0[156].xx + r2.xy;
  r0.zw = r0.zw * cb0[158].zw + cb0[158].xy;
  r3.xyzw = t7.SampleLevel(s7_s, r0.zw, 0).xyzw;
  r0.z = r3.w * cb0[155].x + cb0[155].y;
  r3.xyz = r3.xyz * r3.xyz;
  r0.z = r0.z + -r2.z;
  r0.z = r1.z * cb0[156].y + r0.z;
  r0.z = cb0[155].z * abs(r0.z);
  r0.z = -r0.z * r0.z + 1;
  r0.z = max(0, r0.z);
  r0.z = cb0[157].w * r0.z;
  r3.xyz = r3.xyz * r0.zzz;
  r4.z = -r2.z;
  r5.xyz = cb0[40].xyz + -r2.xyz;
  r0.zw = r2.xy * cb0[158].zw + cb0[158].xy;
  r2.xyzw = t12.SampleLevel(s12_s, r0.zw, 0).xyzw;
  r0.zw = r2.xy * float2(2,2) + float2(-1,-1);
  r4.xy = cb0[155].ww * r0.zw;
  r2.z = r2.z * cb0[155].x + cb0[155].y;
  r2.xy = float2(0,0);
  r2.xyz = r2.xyz + r4.xyz;
  r0.z = cb0[155].z * abs(r2.z);
  r0.z = -r0.z * r0.z + 1;
  r0.z = saturate(r2.w * r0.z);
  r4.xyz = cb0[157].xyz * r0.zzz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;
  r0.z = saturate(dot(r1.xyz, r2.xyz));
  r3.xyz = r0.zzz * r4.xyz + r3.xyz;
  r0.w = dot(r5.xyz, r5.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r5.xyz * r0.www + r2.xyz;
  r5.xyz = r5.xyz * r0.www;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.w = saturate(dot(r1.xyz, r2.xyz));
  r0.w = log2(max(r0.w, 0.000001));
  r2.xyzw = t0.Sample(s3_s, r0.xy).xyzw;
  r6.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r7.xyz = t13.Sample(s13_s, r0.xy).xyz;
  r0.x = 1 + -r6.w;
  r0.x = r2.w * r0.x;
  r0.y = r0.x * r6.w;
  r0.x = -r0.x * 0.5 + 1;
  r2.xyz = r2.xyz * r0.xxx;
  r0.x = saturate(r0.y * 1.5 + r6.w);
  r0.y = 8.47996902 * r0.x;
  r0.y = exp2(r0.y);
  r0.w = r0.y * r0.w;
  r0.y = r0.y * 0.25 + -0.25;
  r0.w = exp2(r0.w);
  r0.z = r0.z * r0.w;
  r0.y = r0.z * r0.y;
  r0.yzw = r0.yyy * r4.xyz;
  r0.yzw = float3(0.0199999996,0.0199999996,0.0199999996) * r0.yzw;
  r0.yzw = r3.xyz * r2.xyz + r0.yzw;
  r2.xyz = saturate(r7.xyz * r2.xyz);
  r0.yzw = r6.xyz + r0.yzw;
  r1.w = dot(-r5.xyz, r1.xyz);
  r1.w = r1.w + r1.w;
  r1.xyz = r1.xzy * -r1.www + -r5.xzy;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r1.w = 1 + -r0.x;
  o0.w = r0.x;
  r0.x = 6 * r1.w;
  r1.xyz = t5.SampleLevel(s5_s, r1.xyz, r0.x).xyz;
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.xyz = abs(r1.xyz) * float3(0.25,0.25,0.25) + r0.yzw;
  o0.xyz = r2.xyz + r0.xyz;

  o0.xyz = EncodeSRGBOutput(o0.xyz);

  return;
}