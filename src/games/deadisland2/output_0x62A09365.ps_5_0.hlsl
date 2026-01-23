#include "./common.hlsli"

Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[247];
}

cbuffer cb0 : register(b0) {
  float4 cb0[77];
}

// 3Dmigoto declarations
#define cmp -

// void main(
//   linear noperspective float2 v0 : TEXCOORD0,
//   linear noperspective float2 w0 : TEXCOORD3,
//   linear noperspective float4 v1 : TEXCOORD1,
//   linear noperspective float4 v2 : TEXCOORD2,
//   float2 v3 : TEXCOORD4,
//   float4 v4 : SV_POSITION0,
//   out float4 o0 : SV_Target0)
void main(
    float2 TEXCOORD0: TEXCOORD0,
    float2 TEXCOORD3: TEXCOORD3,
    float3 TEXCOORD1: TEXCOORD1,
    float4 TEXCOORD2: TEXCOORD2,
    float2 TEXCOORD4: TEXCOORD4,
    float4 SV_POSITION: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = TEXCOORD3.xy * cb0[73].zw + cb0[73].xy;
  r1.xyzw = cmp(float4(0, 0, 0, 0) < r0.xyxy);
  r2.xyzw = cmp(r0.xyxy < float4(0, 0, 0, 0));
  r1.xyzw = (int4)-r1.xyzw + (int4)r2.xyzw;
  r1.xyzw = (int4)r1.xyzw;
  r2.xyzw = saturate(-cb0[76].zzzz + abs(r0.xyxy));
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyzw = -r1.xyzw * cb0[76].xxyy + r0.xyxy;
  r0.xy = r0.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r0.xyz = t2.Sample(s2_s, r0.xy).xyz;
  r0.xyz = r0.xyz * cb0[72].xyz + cb0[63].xyz;
  r1.xyzw = r1.xyzw * cb0[74].zwzw + cb0[74].xyxy;
  r1.xyzw = r1.xyzw * cb0[41].xyxy + cb0[41].zwzw;
  r1.xyzw = cb0[40].zwzw * r1.xyzw;
  r2.xyz = t0.Sample(s0_s, r1.zw).xyz;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r3.xyz = float3(0.589999974, 0.589999974, 0.589999974) * r2.xyz;
  r3.xyz = r1.xyz * float3(0.300000012, 0.300000012, 0.300000012) + r3.xyz;
  r2.x = r1.x;
  r1.xyz = t0.Sample(s0_s, TEXCOORD0.xy).xyz;
  r3.xyz = r1.xyz * float3(0.109999999, 0.109999999, 0.109999999) + r3.xyz;
  r2.z = r1.z;
  r1.xyz = -r3.xyz + r2.xyz;
  r1.xyz = cb0[76].www * r1.xyz + r3.xyz;
  r1.xyz = cb1[134].zzz * r1.xyz;
  r2.xy = cb0[61].xy * TEXCOORD0.xy + cb0[61].zw;
  r2.xy = max(cb0[53].xy, r2.xy);
  r2.xy = min(cb0[53].zw, r2.xy);
  r2.xyz = t1.Sample(s1_s, r2.xy).xyz;
  r2.xyz = cb1[134].zzz * r2.xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r0.w = cb1[152].w / cb1[152].z;
  r0.w = saturate(1.00000001e-07 + r0.w);
  r0.w = -1 + r0.w;
  r2.x = saturate(100 * cb1[152].y);
  r2.x = cb1[246].z * r2.x;
  r0.w = r2.x * r0.w + 1;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r1.xyz * cb0[62].xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.333333343, 0.333333343, 0.333333343));
  r1.x = -cb0[70].x + r0.w;
  r0.w = -cb0[69].x + r0.w;
  r1.y = cb0[70].y + -cb0[70].x;
  r1.x = saturate(r1.x / r1.y);
  r1.x = log2(r1.x);
  r1.x = cb0[70].z * r1.x;
  r1.x = exp2(r1.x);
  r1.y = 1 + -r1.x;
  r1.y = r1.y * 2.20000005 + 1;
  r1.z = cb0[69].y + -cb0[69].x;
  r0.w = saturate(r0.w / r1.z);
  r0.w = log2(r0.w);
  r0.w = cb0[69].z * r0.w;
  r0.w = exp2(r0.w);
  r1.y = r1.y + -r0.w;
  r0.w = cb1[225].y * r1.y + r0.w;
  r2.xyz = log2(r0.xyz);
  r2.xyz = cb0[69].www * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = -r2.xyz + r0.xyz;
  r0.xyz = r1.xxx * r0.xyz + r2.xyz;
  r1.x = dot(r0.xyz, cb0[68].xyz);
  r0.xyz = -r1.xxx + r0.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  r0.xyz = TEXCOORD1.xxx * r0.xyz;
  r1.xy = cb0[64].xx * TEXCOORD1.yz;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + r0.w;
  r0.w = rcp(r0.w);
  r0.w = r0.w * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r1.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r0.xyz);
  r1.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r0.xyz);
  r1.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r0.xyz);
  r0.xyz = cb0[66].www * r1.xyz;
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r1.xyz = rcp(r1.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
#if 0
  r0.rgb = renodx::lut::SampleTetrahedral(t3, r0.rgb, 32u);
#else
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = t3.Sample(s3_s, r0.xyz).xyz;
#endif
  r1.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.xyz;
  r0.w = saturate(dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114)));
  r1.x = cmp(0 < cb0[70].w);
  o0.w = r1.x ? r1.w : r0.w;
  o0.xyz = r0.xyz * float3(1.04999995, 1.04999995, 1.04999995);

#if 1
  r0.w = TEXCOORD2.w * 543.309998 + TEXCOORD2.z;
  r0.w = sin(r0.w);
  r0.w = 493013 * r0.w;
  r0.w = frac(r0.w);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.w = r0.w * (1.f / 256.f) - (1.f / 512.f);  // 8-bit dither
  } else {
    r0.w = r0.w * (1.f / 1024.f) - (1.f / 2048.f);  // 10-bit dither
  }
  o0.rgb += r0.w;
#endif

  return;
}
