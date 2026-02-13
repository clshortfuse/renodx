// ---- Created with 3Dmigoto v1.4.1 on Tue Feb 10 15:11:49 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[16];
}


#include "../shared.h"

#define cmp -

// --- Visibility Bitmask helpers (XeGTAO) ---
static const float BM_HALF_PI = 1.5707963267948966;
static const float BM_PI = 3.1415926535897932;
static const float BM_NUM_BITS = 32.0;

float BM_FastSqrt(float x) {
  return asfloat(0x1fbd1df5 + (asint(x) >> 1));
}

float BM_FastACos(float inX) {
  float x = abs(inX);
  float res = -0.156583 * x + BM_HALF_PI;
  res *= BM_FastSqrt(1.0 - x);
  return (inX >= 0) ? res : BM_PI - res;
}

uint BM_UpdateSectors(float minHorizon, float maxHorizon, uint bm) {
  int startBit = (int)(minHorizon * BM_NUM_BITS);
  int numBits = max((int)(round((maxHorizon - minHorizon) * BM_NUM_BITS)), 0);
  startBit = clamp(startBit, 0, 31);
  numBits = clamp(numBits, 0, 32 - startBit);
  if (numBits > 0) {
    uint mask = ((1u << (uint)numBits) - 1u) << (uint)startBit;
    bm |= mask;
  }
  return bm;
}

void BM_ProcessSample(float3 deltaPos, float3 viewVec, float samplingDir, float n, float thickness, inout uint bm) {
  float3 deltaPosBack = deltaPos - viewVec * thickness;
  float2 frontBackH = float2(
    BM_FastACos(dot(normalize(deltaPos), viewVec)),
    BM_FastACos(dot(normalize(deltaPosBack), viewVec))
  );
  float2 N = float2(n, n);
  frontBackH = saturate((samplingDir * -frontBackH - N + BM_HALF_PI) / BM_PI);
  frontBackH = (samplingDir >= 0.0) ? frontBackH.yx : frontBackH.xy;
  frontBackH = smoothstep(0.0, 1.0, frontBackH);
  bm = BM_UpdateSectors(frontBackH.x, frontBackH.y, bm);
}
// --- End Visibility Bitmask helpers ---

RWTexture2D<unorm float4> u0 : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;

  // Select between vanilla cbuffer values and improved custom values
  bool use_improved = (IMPROVED_GTAO >= 0.5);
  float _ao_radius            = use_improved ? AO_RADIUS            : cb1[0].x;
  float _ao_radius_scale      = use_improved ? AO_RADIUS_SCALE      : cb1[0].y;
  float _ao_falloff_range     = use_improved ? AO_FALLOFF_RANGE     : cb1[0].z;
  float _ao_distribution_power= use_improved ? AO_DISTRIBUTION_POWER: cb1[0].w;
  float _ao_thin_occluder     = use_improved ? AO_THIN_OCCLUDER     : cb1[1].x;
  float _ao_gamma             = use_improved ? AO_GAMMA             : cb1[1].y;
  float _ao_mip_bias          = use_improved ? AO_MIP_BIAS          : cb1[1].w;
  float _ao_thickness         = use_improved ? AO_THICKNESS         : 1.3;
  float _ao_direction_count   = use_improved ? AO_DIRECTION_COUNT   : 3.0;
  float _ao_normal_attenuation= use_improved ? AO_NORMAL_ATTENUATION: 0.05;
  bool  _ao_bitmask           = use_improved && (AO_BITMASK >= 0.5);

  r0.xy = vThreadID.yx;
  r0.zw = float2(32, 0);
  while (true) {
    r1.x = cmp(0 >= (uint)r0.z);
    if (r1.x != 0) break;
    r1.xy = (int2)r0.zz & (int2)r0.yx;
    r1.xy = min(uint2(1,1), (uint2)r1.xy);
    r1.z = (int)r0.z * (int)r0.z;
    r1.w = (int)r1.x * 3;
    r1.w = (int)r1.y ^ (int)r1.w;
    r0.w = mad((int)r1.z, (int)r1.w, (int)r0.w);
    r1.x = cmp((int)r1.x == 1);
    r1.zw = (int2)-r0.yx + int2(63,63);
    r1.xz = r1.xx ? r1.zw : r0.yx;
    r0.xy = r1.yy ? r0.xy : r1.xz;
    r0.z = (uint)r0.z >> 1;
  }
  r0.x = (uint)cb1[1].z;
  r0.x = (int)r0.x & 63;
  r0.x = mad(288, (int)r0.x, (int)r0.w);
  r0.x = (uint)r0.x;
  r0.xy = r0.xx * float2(0.754877687,0.569840312) + float2(0.5,0.5);
  r0.xy = frac(r0.xy);
  r0.zw = (uint2)vThreadID.xy;
  r1.xyzw = float4(0.5,0.5,0.5,0.5) + r0.zwzw;
  r2.xy = cb1[3].zw * r1.zw;
  r2.zw = t0.SampleLevel(s0_s, r2.xy, 0).xy;
  r2.zw = r2.zw * float2(2,2) + float2(-1,-1);
  r3.x = dot(float2(1,1), abs(r2.zw));
  r3.y = 1 + -r3.x;
  r3.w = cmp(r3.y < 0);
  r4.xy = cmp(r2.zw >= float2(0,0));
  r4.zw = float2(1,1) + -abs(r2.wz);
  r4.xy = r4.xy ? float2(1,1) : float2(-1,-1);
  r4.xy = r4.zw * r4.xy;
  r3.xz = r3.ww ? r4.xy : r2.zw;
  r2.z = dot(r3.xyz, r3.xyz);
  r2.z = rsqrt(r2.z);
  r3.xyz = r3.xyz * r2.zzz;
  r4.xyz = cb0[1].xyz * r3.yyy;
  r3.xyw = cb0[0].xyz * r3.xxx + r4.xyz;
  r3.xyz = cb0[2].xyz * r3.zzz + r3.xyw;
  r0.zw = cb1[3].zw * r0.zw;
  r0.z = t1.Gather(s0_s, r0.zw).y;
  r4.z = 0.999989986 * r0.z;
  r0.zw = r2.xy * float2(2,2) + float2(-1,-1);
  r2.xy = cb0[13].xy * r0.ww;
  r0.zw = cb0[12].xy * r0.zz + r2.xy;
  r0.zw = cb0[14].xy + r0.zw;
  r0.zw = cb0[15].xy + r0.zw;
  r4.xy = r0.zw * r4.zz;
  r4.w = -r4.y;
  r0.z = dot(-r4.xzw, -r4.xzw);
  r0.z = rsqrt(r0.z);
  r2.xyz = -r4.xwz * r0.zzz;
  r0.z = _ao_radius * _ao_radius_scale;
  r0.w = _ao_falloff_range * r0.z;
  r2.w = -1 / r0.w;
  r4.y = -_ao_falloff_range + 1;
  r4.y = r4.y * r0.z;
  r0.w = r4.y / r0.w;
  r0.w = 1 + r0.w;
  r5.xy = r1.zw * cb1[3].zw + cb1[3].zw;
  r5.xy = r5.xy * float2(2,2) + float2(-1,-1);
  r4.y = cb0[13].x * r5.y;
  r4.y = cb0[12].x * r5.x + r4.y;
  r4.y = cb0[14].x + r4.y;
  r4.y = cb0[15].x + r4.y;
  r4.y = r4.y * r4.z + -r4.x;
  r0.z = r0.z / r4.y;
  r4.y = _ao_thickness / r0.z;
  r5.x = 10 + -r0.z;
  r5.x = saturate(0.00999999978 * r5.x);
  r5.x = 0.5 * r5.x;
  r5.y = _ao_thin_occluder + 1;
  r6.z = 0;
  r3.w = -r3.z;
  r7.x = r5.x;
  r7.y = 0;
  while (true) {
    r3.z = cmp(r7.y >= _ao_direction_count);
    if (r3.z != 0) break;
    r3.z = r7.y + r0.x;
    r3.z = (3.14159265 / _ao_direction_count) * r3.z;
    sincos(r3.z, r8.x, r6.x);
    r6.y = r8.x;
    r8.xyzw = r6.xyxy * r0.zzzz;
    r3.z = dot(r6.xy, r2.xy);
    r6.xyw = -r2.xyz * r3.zzz + r6.xyz;
    r9.xyz = r6.wxy * r2.yzx;
    r9.xyz = r6.ywx * r2.zxy + -r9.xyz;
    r3.z = dot(r9.xyz, r9.xyz);
    r3.z = rsqrt(r3.z);
    r9.xyz = r9.xyz * r3.zzz;
    r3.z = dot(r3.xyw, r9.xyz);
    r9.xyz = -r9.xyz * r3.zzz + r3.xyw;
    r3.z = dot(r9.xyz, r9.xyz);
    r3.z = sqrt(r3.z);
    r5.z = dot(r9.xyz, r2.xyz);
    r5.z = saturate(r5.z / r3.z);
    r5.w = dot(r6.xyw, r9.xyz);
    r6.x = cmp(0 < r5.w);
    r5.w = cmp(r5.w < 0);
    r5.w = (int)-r6.x + (int)r5.w;
    r5.w = (int)r5.w;
    r6.x = r5.z * -0.156582996 + 1.57079601;
    r6.y = 1 + -r5.z;
    r6.y = asfloat(asuint(r6.y) >> 1);
    r6.y = asfloat(asint(r6.y) + 0x1fbd1df5);
    r6.x = r6.x * r6.y;
    r6.x = max(0, r6.x);
    r6.x = min(3.14159298, r6.x);
    r6.y = r6.x * r5.w;
    r9.xy = r5.ww * r6.xx + float2(1.57079637,-1.57079637);
    r9.xy = cos(r9.xy);
    uint bitmask = 0u;
    r6.w = r7.y * 0.618034005 + r0.y;
    r6.w = frac(r6.w);
    r6.w = 0.333333343 * r6.w;
    r6.w = log2(r6.w);
    r6.w = _ao_distribution_power * r6.w;
    r6.w = exp2(r6.w);
    r6.w = r6.w + r4.y;
    r9.zw = r8.zw * r6.ww;
    r6.w = dot(r9.zw, r9.zw);
    r6.w = sqrt(r6.w);
    r6.w = log2(r6.w);
    r6.w = -_ao_mip_bias + r6.w;
    r6.w = max(0, r6.w);
    r6.w = min(4, r6.w);
    r9.zw = round(r9.zw);
    r9.zw = cb1[3].zw * r9.zw;
    r10.xy = r1.zw * cb1[3].zw + r9.zw;
    r11.w = t1.SampleLevel(s0_s, r10.xy, r6.w).x;
    r10.xy = r10.xy * float2(2,2) + float2(-1,-1);
    r10.yz = cb0[13].xy * r10.yy;
    r10.xy = cb0[12].xy * r10.xx + r10.yz;
    r10.xy = cb0[14].xy + r10.xy;
    r10.xy = cb0[15].xy + r10.xy;
    r11.xy = r10.xy * r11.ww;
    r9.zw = r1.zw * cb1[3].zw + -r9.zw;
    r10.w = t1.SampleLevel(s0_s, r9.zw, r6.w).x;
    r9.zw = r9.zw * float2(2,2) + float2(-1,-1);
    r12.xy = cb0[13].xy * r9.ww;
    r9.zw = cb0[12].xy * r9.zz + r12.xy;
    r9.zw = cb0[14].xy + r9.zw;
    r9.zw = cb0[15].xy + r9.zw;
    r10.xy = r9.zw * r10.ww;
    r11.z = -r11.y;
    r11.xyz = r11.xzw + -r4.xwz;
    r10.z = -r10.y;
    r10.xyz = r10.xzw + -r4.xwz;
    // Bitmask: process step 0 samples
    if (_ao_bitmask) {
      BM_ProcessSample(r11.xyz, r2.xyz, -1.0, r6.y, _ao_thickness, bitmask);
      BM_ProcessSample(r10.xyz, r2.xyz,  1.0, r6.y, _ao_thickness, bitmask);
    }
    r6.w = dot(r11.xyz, r11.xyz);
    r6.w = sqrt(r6.w);
    r12.xyz = r11.xyz / r6.www;
    r6.w = dot(r12.xyz, r2.xyz);
    r11.w = r11.z * r5.y;
    r9.z = dot(r11.xyw, r11.xyw);
    r9.z = sqrt(r9.z);
    r9.z = saturate(r9.z * r2.w + r0.w);
    r6.w = r6.w + -r9.x;
    r6.w = r9.z * r6.w + r9.x;
    r6.w = max(r9.x, r6.w);
    r9.z = dot(r10.xyz, r10.xyz);
    r9.z = sqrt(r9.z);
    r11.xyz = r10.xyz / r9.zzz;
    r9.z = dot(r11.xyz, r2.xyz);
    r10.w = r10.z * r5.y;
    r9.w = dot(r10.xyw, r10.xyw);
    r9.w = sqrt(r9.w);
    r9.w = saturate(r9.w * r2.w + r0.w);
    r9.z = r9.z + -r9.y;
    r9.z = r9.w * r9.z + r9.y;
    r9.z = max(r9.y, r9.z);
    r7.yzw = float3(1,3,6) + r7.yyy;
    r10.xyzw = r7.zzww * float4(0.618034005,0.618034005,0.618034005,0.618034005) + r0.yyyy;
    r10.xyzw = frac(r10.xyzw);
    r10.xyzw = float4(1,1,2,2) + r10.xyzw;
    r10.xyzw = float4(0.333333343,0.333333343,0.333333343,0.333333343) * r10.xyzw;
    r10.xyzw = log2(r10.xyzw);
    r10.xyzw = _ao_distribution_power * r10.xyzw;
    r10.xyzw = exp2(r10.xyzw);
    r10.xyzw = r10.xyzw + r4.yyyy;
    r8.xyzw = r10.xyzw * r8.xyzw;
    r7.z = dot(r8.xy, r8.xy);
    r7.z = sqrt(r7.z);
    r7.z = log2(r7.z);
    r7.z = -_ao_mip_bias + r7.z;
    r7.z = max(0, r7.z);
    r7.z = min(4, r7.z);
    r10.xyzw = round(r8.xyzw);
    r10.xyzw = cb1[3].zwzw * r10.xyzw;
    r11.xyzw = r1.zwzw * cb1[3].zwzw + r10.xyzw;
    r12.w = t1.SampleLevel(s0_s, r11.xy, r7.z).x;
    r13.xyzw = r11.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
    r14.xyzw = cb0[13].xyxy * r13.yyww;
    r13.xyzw = cb0[12].xyxy * r13.xxzz + r14.xyzw;
    r13.xyzw = cb0[14].xyxy + r13.xyzw;
    r13.xyzw = cb0[15].xyxy + r13.xyzw;
    r12.xy = r13.xy * r12.ww;
    r10.xyzw = r1.xyzw * cb1[3].zwzw + -r10.xyzw;
    r14.w = t1.SampleLevel(s0_s, r10.xy, r7.z).x;
    r15.xyzw = r10.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
    r16.xyzw = cb0[13].xyxy * r15.yyww;
    r15.xyzw = cb0[12].xyxy * r15.xxzz + r16.xyzw;
    r15.xyzw = cb0[14].xyxy + r15.xyzw;
    r15.xyzw = cb0[15].xyxy + r15.xyzw;
    r14.xy = r15.xy * r14.ww;
    r12.z = -r12.y;
    r12.xyz = r12.xzw + -r4.xwz;
    r14.z = -r14.y;
    r14.xyz = r14.xzw + -r4.xwz;
    // Bitmask: process step 1 samples
    if (_ao_bitmask) {
      BM_ProcessSample(r12.xyz, r2.xyz, -1.0, r6.y, _ao_thickness, bitmask);
      BM_ProcessSample(r14.xyz, r2.xyz,  1.0, r6.y, _ao_thickness, bitmask);
    }
    r7.z = dot(r12.xyz, r12.xyz);
    r7.z = sqrt(r7.z);
    r16.xyz = r12.xyz / r7.zzz;
    r7.z = dot(r16.xyz, r2.xyz);
    r12.w = r12.z * r5.y;
    r7.w = dot(r12.xyw, r12.xyw);
    r7.w = sqrt(r7.w);
    r7.w = saturate(r7.w * r2.w + r0.w);
    r7.z = r7.z + -r9.x;
    r7.z = r7.w * r7.z + r9.x;
    r6.w = max(r7.z, r6.w);
    r7.z = dot(r14.xyz, r14.xyz);
    r7.z = sqrt(r7.z);
    r12.xyz = r14.xyz / r7.zzz;
    r7.z = dot(r12.xyz, r2.xyz);
    r14.w = r14.z * r5.y;
    r7.w = dot(r14.xyw, r14.xyw);
    r7.w = sqrt(r7.w);
    r7.w = saturate(r7.w * r2.w + r0.w);
    r7.z = r7.z + -r9.y;
    r7.z = r7.w * r7.z + r9.y;
    r7.z = max(r9.z, r7.z);
    r7.w = dot(r8.zw, r8.zw);
    r7.w = sqrt(r7.w);
    r7.w = log2(r7.w);
    r7.w = -_ao_mip_bias + r7.w;
    r7.w = max(0, r7.w);
    r7.w = min(4, r7.w);
    r8.w = t1.SampleLevel(s0_s, r11.zw, r7.w).x;
    r8.xy = r13.zw * r8.ww;
    r10.w = t1.SampleLevel(s0_s, r10.zw, r7.w).x;
    r10.xy = r15.zw * r10.ww;
    r8.z = -r8.y;
    r8.xyz = r8.xzw + -r4.xwz;
    r10.z = -r10.y;
    r10.xyz = r10.xzw + -r4.xwz;
    // Bitmask: process step 2 samples
    if (_ao_bitmask) {
      BM_ProcessSample(r8.xyz, r2.xyz, -1.0, r6.y, _ao_thickness, bitmask);
      BM_ProcessSample(r10.xyz, r2.xyz,  1.0, r6.y, _ao_thickness, bitmask);
    }
    r7.w = dot(r8.xyz, r8.xyz);
    r7.w = sqrt(r7.w);
    r11.xyz = r8.xyz / r7.www;
    r7.w = dot(r11.xyz, r2.xyz);
    r8.w = r8.z * r5.y;
    r8.x = dot(r8.xyw, r8.xyw);
    r8.x = sqrt(r8.x);
    r8.x = saturate(r8.x * r2.w + r0.w);
    r7.w = r7.w + -r9.x;
    r7.w = r8.x * r7.w + r9.x;
    r6.w = max(r7.w, r6.w);
    r7.w = dot(r10.xyz, r10.xyz);
    r7.w = sqrt(r7.w);
    r8.xyz = r10.xyz / r7.www;
    r7.w = dot(r8.xyz, r2.xyz);
    r10.w = r10.z * r5.y;
    r8.x = dot(r10.xyw, r10.xyw);
    r8.x = sqrt(r8.x);
    r8.x = saturate(r8.x * r2.w + r0.w);
    r7.w = r7.w + -r9.y;
    r7.w = r8.x * r7.w + r9.y;
    r7.z = max(r7.z, r7.w);
    // Visibility accumulation: bitmask vs arc integration
    if (_ao_bitmask) {
      r7.x += (1.0 - (float)countbits(bitmask) / 32.0);
    } else {
    r7.w = abs(r7.z) * -0.156582996 + 1.57079601;
    r8.x = 1 + -abs(r7.z);
    r8.x = asfloat(asuint(r8.x) >> 1);
    r8.x = asfloat(asint(r8.x) + 0x1fbd1df5);
    r8.y = r8.x * r7.w;
    r8.z = abs(r6.w) * -0.156582996 + 1.57079601;
    r8.w = 1 + -abs(r6.w);
    r8.w = asfloat(asuint(r8.w) >> 1);
    r8.w = asfloat(asint(r8.w) + 0x1fbd1df5);
    r9.x = r8.z * r8.w;
    r7.z = cmp(r7.z >= 0);
    r7.w = -r7.w * r8.x + 3.14159298;
    r7.z = r7.z ? r8.y : r7.w;
    r7.z = max(0, r7.z);
    r7.z = min(3.14159298, r7.z);
    r7.w = -2 * r7.z;
    r8.x = sin(r6.y);
    r6.w = cmp(r6.w >= 0);
    r8.y = -r8.z * r8.w + 3.14159298;
    r6.w = r6.w ? r9.x : r8.y;
    r6.w = max(0, r6.w);
    r6.w = min(3.14159298, r6.w);
    r6.w = r6.w + r6.w;
    r8.y = 1 + -r3.z;
    r3.z = r8.y * _ao_normal_attenuation + r3.z;
    r7.w = r7.w * r8.x + r5.z;
    r6.y = r7.z * -2 + -r6.y;
    r6.y = cos(r6.y);
    r6.y = r7.w + -r6.y;
    r5.z = r6.w * r8.x + r5.z;
    r5.w = -r5.w * r6.x + r6.w;
    r5.w = cos(r5.w);
    r5.z = r5.z + -r5.w;
    r5.z = r6.y + r5.z;
    r3.z = r5.z * r3.z;
    r7.x = r3.z * 0.25 + r7.x;
    }
  }
  r0.x = (1.0 / _ao_direction_count) * r7.x;
  r0.x = log2(abs(r0.x));
  r0.x = _ao_gamma * r0.x;
  r0.x = exp2(r0.x);
  r0.x = max(0.0299999993, r0.x);
  u0[vThreadID.xy] = r0.xxxx;
  return;
}