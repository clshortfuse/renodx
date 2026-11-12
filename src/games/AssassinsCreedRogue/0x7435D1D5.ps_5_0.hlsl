// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 16 22:52:36 2026
TextureCube<float4> t13 : register(t13);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[143];
}

#define cmp -

#ifndef MANUAL_SRGB_RT_ENCODE
#define MANUAL_SRGB_RT_ENCODE 0
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

float3 PreserveHueClamp(float3 c)
{
  c = max(c, 0.0);

  float peak = max(max(c.r, c.g), c.b);
  if (peak <= 1.0)
    return c;

  float3 luma_weights = float3(0.2126, 0.7152, 0.0722);
  float in_luma = dot(c, luma_weights);

  float3 hue = c / peak;
  float hue_luma = max(dot(hue, luma_weights), 0.000001);

  float target_luma = saturate(in_luma);
  return saturate(hue * (target_luma / hue_luma));
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t2.Sample(s2_s, v2.xy).xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r1.xyz = v6.xyz * r0.yyy;
  r0.xyw = r0.xxx * v5.xyz + r1.xyz;
  r0.xyz = r0.zzz * v7.xyz + r0.xyw;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(max(r0.w, 0.000001));
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = -cb0[63].xxx * r0.xyz;
  r0.xyz = v8.xxx ? r1.xyz : r0.xyz;
  r1.xyz = cb0[40].xyz + -v4.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(max(r0.w, 0.000001));
  r1.xyz = r1.xyz * r1.www;
  r2.xy = v2.xy;
  r2.z = 1;
  r3.x = dot(r2.xyz, cb0[139].xyz);
  r3.y = dot(r2.xyz, cb0[140].xyz);
  r3.xyz = t0.Sample(s0_s, r3.xy).xyz;
  r4.xyz = cb0[142].xyz * r3.zzz;
  r3.xzw = cb0[134].xyz * r3.xxx + r4.xyz;
  r4.xyz = cb0[45].www * r3.xzw;
  r4.xyz = r4.xyz * r4.xyz;
  r1.w = t3.Sample(s3_s, v3.xy).x;
  r1.w = r3.y * r1.w;
  r5.x = dot(r2.xyz, cb0[135].xyz);
  r5.y = dot(r2.xyz, cb0[136].xyz);
  r2.xy = t1.Sample(s1_s, r5.xy).xy;
  r2.x = cb0[133].x + r2.x;
  r2.y = cb0[138].x + r2.y;
  r5.xyz = cb0[132].xyz * v3.www;
  r6.xyz = cb0[129].xyz * v3.www;
  r2.z = cb0[128].x + -0.5;
  r2.w = max(r3.x, r3.z);
  r2.w = max(r2.w, r3.w);
  r2.w = 1.70000005 * r2.w;
  r3.xyz = cb0[45].xyz * r2.www;
  r2.x = r2.x + r2.z;
  r7.xyz = r2.xxx * r0.xyz + v6.xyz;
  r2.x = dot(r7.xyz, r7.xyz);
  r2.x = rsqrt(max(r2.x, 0.000001));
  r7.xyz = r7.xyz * r2.xxx;
  r2.x = r2.y + r2.z;
  r2.xyz = r2.xxx * r0.xyz + v6.xyz;
  r2.w = dot(r2.xyz, r2.xyz);
  r2.w = rsqrt(max(r2.w, 0.000001));
  r2.xyz = r2.xyz * r2.www;
  r8.xyzw = float4(0,0,0,0);

  while (true) {
    r2.w = cmp((int)r8.w >= 4);
    if (r2.w != 0) break;

    r2.w = (uint)r8.w << 1;
    r9.xyz = cb0[r2.w+64].xyz + -v4.xyz;
    r3.w = dot(r9.xyz, r9.xyz);
    r4.w = sqrt(max(r3.w, 0.0));
    r4.w = cb0[r2.w+64].w + -r4.w;
    r4.w = saturate(abs(cb0[r2.w+65].w) * r4.w);
    r4.w = r4.w * r4.w;
    r5.w = cmp(0 < r4.w);

    if (r5.w != 0) {
      r3.w = rsqrt(max(r3.w, 0.000001));
      r10.xyz = r9.xyz * r3.www;
      r5.w = dot(r0.xyz, r10.xyz);
      r6.w = saturate(r5.w);
      r10.xyz = cb0[r2.w+65].xyz * r6.www;
      r11.xyz = r4.www * r4.xyz;
      r9.xyz = r9.xyz * r3.www + r1.xyz;
      r3.w = dot(r9.xyz, r9.xyz);
      r3.w = rsqrt(max(r3.w, 0.000001));
      r9.xyz = r9.xyz * r3.www;

      r3.w = dot(r7.xyz, r9.xyz);
      r3.w = -r3.w * r3.w + 1;
      r3.w = sqrt(max(r3.w, 0.0));

      r5.w = 0.200000003 + r5.w;
      r5.w = saturate(5 * r5.w);
      r6.w = r5.w * -2 + 3;
      r5.w = r5.w * r5.w;
      r5.w = r6.w * r5.w;

      r3.w = log2(max(r3.w, 0.000001));
      r3.w = cb0[130].x * r3.w;
      r3.w = exp2(r3.w);
      r3.w = r5.w * r3.w;

      r6.w = dot(r2.xyz, r9.xyz);
      r6.w = -r6.w * r6.w + 1;
      r6.w = sqrt(max(r6.w, 0.0));
      r6.w = log2(max(r6.w, 0.000001));
      r6.w = cb0[131].x * r6.w;
      r6.w = exp2(r6.w);
      r5.w = r6.w * r5.w;

      r9.xyz = r6.xyz * r5.www;
      r9.xyz = r5.xyz * r3.www + r9.xyz;
      r9.xyz = cb0[r2.w+65].xyz * r9.xyz;
      r9.xyz = r9.xyz * r4.www;
      r9.xyz = r11.xyz * r10.xyz + r9.xyz;
      r8.xyz = r9.xyz + r8.xyz;
    }

    r8.w = (int)r8.w + 1;
  }

  r2.xyz = t13.SampleLevel(s13_s, r0.xyz, 0).xyz;
  r5.x = dot(r0.xyz, float3(-0.408248007,-0.707107008,0.577350318));
  r5.y = dot(r0.xzy, float3(-0.408248007,0.577350318,0.707107008));
  r5.z = dot(r0.xz, float2(0.816497028,0.577350318));
  r5.w = r0.z;
  r5.xyzw = r5.xyzw * float4(1,1,1,-0.5) + float4(0,0,0,0.5);
  r0.xyz = saturate(r5.xyz);
  r5.xyz = r5.xyz * r0.xyz;
  r0.x = dot(r5.xyzw, cb0[95].xyzw);
  r0.y = dot(r5.xyzw, cb0[96].xyzw);
  r0.z = dot(r5.xyzw, cb0[97].xyzw);
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz * r4.xyz + r8.xyz;
  r0.xyz = r3.xyz * r3.xyz + r0.xyz;

  r2.x = cb0[40].z + cb0[37].z;
  r0.xyzw = sqrt(max(r0.xyzw, 0.0));

  r2.y = -cb0[37].x + r0.w;
  r2.z = cb0[37].y + -cb0[37].x;
  r2.y = saturate(r2.y / r2.z);
  r2.y = 1 + -r2.y;
  r2.y = r2.y * r2.y;
  r2.y = -r2.y * r2.y + 1;
  r2.x = v4.z + -r2.x;
  r2.x = min(cb0[37].z, r2.x);
  r2.x = saturate(-r2.x * cb0[37].w + 1);
  r0.w = -20 + r0.w;
  r0.w = saturate(0.0700000003 * r0.w);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * r0.w + 1;
  r0.w = cb0[36].x * r0.w;
  r0.w = saturate(r2.y * r2.x + r0.w);
  r1.x = dot(cb0[11].xyz, r1.xyz);
  r1.x = 1 + r1.x;
  r1.x = -r1.x * 0.5 + 1;
  r1.x = r1.x * r1.x;
  r2.xyz = -cb0[61].xyz + cb0[60].xyz;
  r1.xyz = r1.xxx * r2.xyz + cb0[61].xyz;

  r0.xyz = PreserveHueClamp(r0.xyz);

  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.w = 1 + -r0.w;
  r1.x = r1.w * r0.w;
  r0.w = r1.w * r0.w + -cb0[62].x;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;

  o0.xyz = cb0[49].xyz + r0.xyz;
  o0.xyz = EncodeSRGBOutput(o0.xyz);

  o1.xyz = v1.zzz / v1.www;
  o0.w = r1.x;
  o1.w = r1.x;
  return;
}