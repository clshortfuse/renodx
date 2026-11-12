#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 03 23:02:43 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[39];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  float ui_white = cb3[4].x;
  if (RENODX_TONE_MAP_TYPE != CODWW2_TONE_MAP_TYPE_VANILLA
      && RENODX_PEAK_WHITE_NITS > 0.f && RENODX_GRAPHICS_WHITE_NITS > 0.f) {
    ui_white = min(RENODX_GRAPHICS_WHITE_NITS, RENODX_PEAK_WHITE_NITS);
  }

  r0.xy = asuint(cb3[38].xy);
  r0.z = t0.Sample(s0_s, v2.xy).x;
  r0.z = r0.z * 2 + -1;
  r1.xy = float2(256,256) * v2.xy;
  r1.zw = ddx_coarse(r1.xy);
  r1.xy = ddy_coarse(r1.xy);
  r2.x = ddx_coarse(r0.z);
  r2.y = ddy_coarse(r0.z);
  r2.zw = cmp(r2.xy == float2(0,0));
  r0.w = r2.w ? r2.z : 0;
  r2.z = dot(r2.xy, r2.xy);
  r2.z = rsqrt(r2.z);
  r2.xy = r2.xy * r2.zz;
  r2.xy = r0.ww ? float2(0,0) : r2.xy;
  r1.xy = r2.yy * r1.xy;
  r1.xy = r2.xx * r1.zw + r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r1.x = 1.41419995 * r0.w;
  r0.w = r0.w * 0.707099974 + r0.z;
  r1.x = 1 / r1.x;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r1.x = v1.w * r0.w;
  r1.yz = cmp(int2(0,0) < (uint2)r0.xy);
  r2.xy = cmp((uint2)r0.xy < int2(4,4));
  r1.yz = r1.yz ? r2.xy : 0;
  if (r1.y != 0) {
    r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= v1.xyz);
    r3.xyz = float3(12.9200001,12.9200001,12.9200001) * v1.xyz;
    r4.xyz = log2(v1.xyz);
    r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r2.xyz = r2.xyz ? r3.xyz : r4.xyz;
    r3.x = dot(float3(17.8824005,43.5161018,4.11934996), r2.xyz);
    r3.y = dot(float3(3.45565009,27.1553993,3.86714005), r2.xyz);
    r3.z = dot(float3(0.0299565997,0.184309006,1.46709001), r2.xyz);
    switch (r0.x) {
      case 1 :      r2.xyz = float3(0,2.02343988,-2.52581);
      r4.xyz = float3(0,1,0);
      r5.xyz = float3(0,0,1);
      break;
      case 2 :      r2.xyz = float3(1,0,0);
      r4.xyz = float3(0.494206995,0,1.24827003);
      r5.xyz = float3(0,0,1);
      break;
      case 3 :      r2.xyz = float3(1,0,0);
      r4.xyz = float3(0,1,0);
      r5.xyz = float3(-0.0122450003,0.0720349997,0);
      break;
      case 0 :      r2.xyz = float3(1,0,0);
      r4.xyz = float3(0,1,0);
      r5.xyz = float3(0,0,1);
      break;
      default :
      r2.xyz = float3(1,0,0);
      r4.xyz = float3(0,1,0);
      r5.xyz = float3(0,0,1);
      break;
    }
    r2.x = dot(r2.xyz, r3.xyz);
    r2.y = dot(r4.xyz, r3.xyz);
    r2.z = dot(r5.xyz, r3.xyz);
    r3.x = dot(float3(0.0809444487,-0.130504414,0.116721064), r2.xyz);
    r3.y = dot(float3(-0.0102485335,0.0540193282,-0.113614708), r2.xyz);
    r3.z = dot(float3(-0.000365296932,-0.00412161462,0.693511426), r2.xyz);
    r2.xyz = max(float3(0,0,0), r3.xyz);
    r3.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r2.xyz);
    r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r2.xyz;
    r2.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r2.xyz;
    r2.xyz = float3(0.947867334,0.947867334,0.947867334) * r2.xyz;
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r3.xyz ? r4.xyz : r2.xyz;
    r2.xyz = v1.xyz + -r2.xyz;
    switch (r0.x) {
      case 1 :      r3.xy = float2(0,0);
      r4.xyz = float3(0.600000024,1,0);
      r5.xy = float2(0.600000024,1);
      break;
      case 2 :      r3.xy = float2(0,0);
      r4.xyz = float3(0.600000024,1,0);
      r5.xy = float2(0.600000024,1);
      break;
      case 3 :      r3.xy = float2(1,0.200000003);
      r4.xyz = float3(0,1,0.200000003);
      r5.xy = float2(0,0);
      break;
      case 0 :      r3.xy = float2(0,0);
      r4.xyz = float3(0,0,0);
      r5.xy = float2(0,0);
      break;
      default :
      r3.xy = float2(0,0);
      r4.xyz = float3(0,0,0);
      r5.xy = float2(0,0);
      break;
    }
    r3.x = dot(r3.xy, r2.xz);
    r3.y = dot(r4.xyz, r2.xyz);
    r3.z = dot(r5.xy, r2.xz);
    r2.xyz = r3.xyz * cb3[38].zzz + v1.xyz;
  } else {
    r2.xyz = v1.xyz;
  }
  if (r1.z != 0) {
    r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r2.xyz);
    r4.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.xyz;
    r5.xyz = log2(r2.xyz);
    r5.xyz = float3(0.416666657,0.416666657,0.416666657) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = r5.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r3.xyz = r3.xyz ? r4.xyz : r5.xyz;
    r4.x = dot(float3(17.8824005,43.5161018,4.11934996), r3.xyz);
    r4.y = dot(float3(3.45565009,27.1553993,3.86714005), r3.xyz);
    r4.z = dot(float3(0.0299565997,0.184309006,1.46709001), r3.xyz);
    switch (r0.y) {
      case 1 :      r3.xyz = float3(0,2.02343988,-2.52581);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
      case 2 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0.494206995,0,1.24827003);
      r6.xyz = float3(0,0,1);
      break;
      case 3 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(-0.0122450003,0.0720349997,0);
      break;
      case 0 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
      default :
      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
    }
    r3.x = dot(r3.xyz, r4.xyz);
    r3.y = dot(r5.xyz, r4.xyz);
    r3.z = dot(r6.xyz, r4.xyz);
    r4.x = dot(float3(0.0809444487,-0.130504414,0.116721064), r3.xyz);
    r4.y = dot(float3(-0.0102485335,0.0540193282,-0.113614708), r3.xyz);
    r4.z = dot(float3(-0.000365296932,-0.00412161462,0.693511426), r3.xyz);
    r3.xyz = max(float3(0,0,0), r4.xyz);
    r4.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r3.xyz);
    r5.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
    r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r3.xyz;
    r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r2.xyz = r4.xyz ? r5.xyz : r3.xyz;
  }
  r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r2.xyz);
  r4.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = r3.xyz ? r4.xyz : r2.xyz;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = ui_white.xxx * r2.xyz;
  r3.x = dot(float3(0.627399981,0.329299986,0.0432999991), r2.xyz);
  r3.y = dot(float3(0.0691,0.919499993,0.0114000002), r2.xyz);
  r3.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r2.xyz);
  r2.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r3.xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.159301758,0.159301758,0.159301758) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = r2.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r2.xyz = r2.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r2.xyz = r3.xyz / r2.xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(78.84375,78.84375,78.84375) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xy = cb1[1].xy + v2.xy;
  r1.w = t0.Sample(s0_s, r3.xy).x;
  r1.w = r1.w * 2 + -1;
  r3.xy = cb1[0].yw + -cb1[0].xz;
  r1.w = -cb1[0].x + r1.w;
  r3.xy = float2(1,1) / r3.xy;
  r1.w = saturate(r3.x * r1.w);
  r2.w = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.w * r1.w;
  r1.w = cb1[2].w * r1.w;
  r0.z = -cb1[0].z + r0.z;
  r0.z = saturate(r0.z * r3.y);
  r2.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r2.w * r0.z;
  r0.z = cb1[3].w * r0.z;
  if (r1.y != 0) {
    r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb1[2].xyz);
    r4.xyz = float3(12.9200001,12.9200001,12.9200001) * cb1[2].xyz;
    r5.xyz = log2(cb1[2].xyz);
    r5.xyz = float3(0.416666657,0.416666657,0.416666657) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = r5.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r3.xyz = r3.xyz ? r4.xyz : r5.xyz;
    r4.x = dot(float3(17.8824005,43.5161018,4.11934996), r3.xyz);
    r4.y = dot(float3(3.45565009,27.1553993,3.86714005), r3.xyz);
    r4.z = dot(float3(0.0299565997,0.184309006,1.46709001), r3.xyz);
    switch (r0.x) {
      case 1 :      r3.xyz = float3(0,2.02343988,-2.52581);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
      case 2 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0.494206995,0,1.24827003);
      r6.xyz = float3(0,0,1);
      break;
      case 3 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(-0.0122450003,0.0720349997,0);
      break;
      case 0 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
      default :
      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
    }
    r3.x = dot(r3.xyz, r4.xyz);
    r3.y = dot(r5.xyz, r4.xyz);
    r3.z = dot(r6.xyz, r4.xyz);
    r4.x = dot(float3(0.0809444487,-0.130504414,0.116721064), r3.xyz);
    r4.y = dot(float3(-0.0102485335,0.0540193282,-0.113614708), r3.xyz);
    r4.z = dot(float3(-0.000365296932,-0.00412161462,0.693511426), r3.xyz);
    r3.xyz = max(float3(0,0,0), r4.xyz);
    r4.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r3.xyz);
    r5.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
    r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r3.xyz;
    r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r4.xyz ? r5.xyz : r3.xyz;
    r3.xyz = cb1[2].xyz + -r3.xyz;
    switch (r0.x) {
      case 1 :      r4.xy = float2(0,0);
      r5.xyz = float3(0.600000024,1,0);
      r6.xy = float2(0.600000024,1);
      break;
      case 2 :      r4.xy = float2(0,0);
      r5.xyz = float3(0.600000024,1,0);
      r6.xy = float2(0.600000024,1);
      break;
      case 3 :      r4.xy = float2(1,0.200000003);
      r5.xyz = float3(0,1,0.200000003);
      r6.xy = float2(0,0);
      break;
      case 0 :      r4.xy = float2(0,0);
      r5.xyz = float3(0,0,0);
      r6.xy = float2(0,0);
      break;
      default :
      r4.xy = float2(0,0);
      r5.xyz = float3(0,0,0);
      r6.xy = float2(0,0);
      break;
    }
    r4.x = dot(r4.xy, r3.xz);
    r4.y = dot(r5.xyz, r3.xyz);
    r4.z = dot(r6.xy, r3.xz);
    r3.xyz = r4.xyz * cb3[38].zzz + cb1[2].xyz;
  } else {
    r3.xyz = cb1[2].xyz;
  }
  if (r1.z != 0) {
    r4.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r3.xyz);
    r5.xyz = float3(12.9200001,12.9200001,12.9200001) * r3.xyz;
    r6.xyz = log2(r3.xyz);
    r6.xyz = float3(0.416666657,0.416666657,0.416666657) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r6.xyz = r6.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r4.xyz = r4.xyz ? r5.xyz : r6.xyz;
    r5.x = dot(float3(17.8824005,43.5161018,4.11934996), r4.xyz);
    r5.y = dot(float3(3.45565009,27.1553993,3.86714005), r4.xyz);
    r5.z = dot(float3(0.0299565997,0.184309006,1.46709001), r4.xyz);
    switch (r0.y) {
      case 1 :      r4.xyz = float3(0,2.02343988,-2.52581);
      r6.xyz = float3(0,1,0);
      r7.xyz = float3(0,0,1);
      break;
      case 2 :      r4.xyz = float3(1,0,0);
      r6.xyz = float3(0.494206995,0,1.24827003);
      r7.xyz = float3(0,0,1);
      break;
      case 3 :      r4.xyz = float3(1,0,0);
      r6.xyz = float3(0,1,0);
      r7.xyz = float3(-0.0122450003,0.0720349997,0);
      break;
      case 0 :      r4.xyz = float3(1,0,0);
      r6.xyz = float3(0,1,0);
      r7.xyz = float3(0,0,1);
      break;
      default :
      r4.xyz = float3(1,0,0);
      r6.xyz = float3(0,1,0);
      r7.xyz = float3(0,0,1);
      break;
    }
    r4.x = dot(r4.xyz, r5.xyz);
    r4.y = dot(r6.xyz, r5.xyz);
    r4.z = dot(r7.xyz, r5.xyz);
    r5.x = dot(float3(0.0809444487,-0.130504414,0.116721064), r4.xyz);
    r5.y = dot(float3(-0.0102485335,0.0540193282,-0.113614708), r4.xyz);
    r5.z = dot(float3(-0.000365296932,-0.00412161462,0.693511426), r4.xyz);
    r4.xyz = max(float3(0,0,0), r5.xyz);
    r5.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r4.xyz);
    r6.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r4.xyz;
    r4.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r4.xyz;
    r4.xyz = float3(0.947867334,0.947867334,0.947867334) * r4.xyz;
    r4.xyz = log2(r4.xyz);
    r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r3.xyz = r5.xyz ? r6.xyz : r4.xyz;
  }
  r4.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r3.xyz);
  r5.xyz = float3(12.9200001,12.9200001,12.9200001) * r3.xyz;
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = r4.xyz ? r5.xyz : r3.xyz;
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = ui_white.xxx * r3.xyz;
  r4.x = dot(float3(0.627399981,0.329299986,0.0432999991), r3.xyz);
  r4.y = dot(float3(0.0691,0.919499993,0.0114000002), r3.xyz);
  r4.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r3.xyz);
  r3.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r4.xyz;
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(0.159301758,0.159301758,0.159301758) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r4.xyz = r3.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r3.xyz = r3.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r3.xyz = r4.xyz / r3.xyz;
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(78.84375,78.84375,78.84375) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r4.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb1[3].xyz);
  r5.xyz = float3(12.9200001,12.9200001,12.9200001) * cb1[3].xyz;
  r6.xyz = log2(cb1[3].xyz);
  r6.xyz = float3(0.416666657,0.416666657,0.416666657) * r6.xyz;
  r6.xyz = exp2(r6.xyz);
  r6.xyz = r6.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r4.xyz = r4.xyz ? r5.xyz : r6.xyz;
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = log2(r4.xyz);
  r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = ui_white.xxx * r4.xyz;
  r5.x = dot(float3(0.627399981,0.329299986,0.0432999991), r4.xyz);
  r5.y = dot(float3(0.0691,0.919499993,0.0114000002), r4.xyz);
  r5.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r4.xyz);
  r4.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r5.xyz;
  r4.xyz = log2(r4.xyz);
  r4.xyz = float3(0.159301758,0.159301758,0.159301758) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r5.xyz = r4.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r4.xyz = r4.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r4.xyz = r5.xyz / r4.xyz;
  r4.xyz = log2(r4.xyz);
  r4.xyz = float3(78.84375,78.84375,78.84375) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * r0.zzz;
  r3.xyz = r3.xyz * r1.www + r4.xyz;
  r0.x = -v1.w * r0.w + 1;
  r0.xyw = r3.xyz * r0.xxx;
  o0.xyz = r2.xyz * r1.xxx + r0.xyw;
  r0.x = max(r1.w, r0.z);
  o0.w = max(r0.x, r1.x);
  return;
}
